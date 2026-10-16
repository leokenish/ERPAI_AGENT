import copy
import hashlib
import html as html_std
import json
import re
import subprocess
import zipfile
from collections import Counter
from pathlib import Path

from lxml import html, etree

ROOT = Path(__file__).resolve().parent
SOURCE = Path('/workspace/scratch/erp-shared-transcript-checkpoint.json')
raw = json.loads(SOURCE.read_text())
order = raw['turn_order'][1:]
turns = {t['turn_id']: t for t in raw['turns'] + raw['empty_turns']}
assert len(order) == len(set(order)) == 238
assert set(order) == set(turns)
messages = []
assets = []
code_count = table_count = 0


def clean_body(source_html):
    global code_count, table_count
    root = html.fragment_fromstring(source_html, create_parent='div')
    links = [{'label': ''.join(e.itertext()), 'href': e.get('href')} for e in root.findall('.//a')]
    image_refs = [{'alt': e.get('alt', ''), 'src': e.get('src', '')} for e in root.findall('.//img')]
    codes = []
    # Code blocks contain a nested readonly <pre>; retain the code once, not its UI.
    for pre in root.xpath('.//pre[not(ancestor::pre)]'):
        code_nodes = pre.findall('.//code')
        if code_nodes:
            content = '\n'.join(''.join(c.itertext()) for c in code_nodes)
            codes.append(content)
            replacement = etree.Element('pre')
            code = etree.SubElement(replacement, 'code')
            code.text = content
            replacement.tail = pre.tail
            pre.getparent().replace(pre, replacement)
    for e in list(root.xpath('.//svg|.//style|.//script|.//button[@data-testid="collapsible-user-message-toggle"]|.//button[@aria-label="복사"]|.//button[@aria-label="표 복사"]')):
        e.drop_tree()
    # File buttons carry actual response text; unwrap instead of deleting them.
    for e in list(root.findall('.//button')):
        e.drop_tag()
    for e in list(root.findall('.//img')):
        e.tail = '[이미지 첨부: ' + (e.get('alt') or '공유 화면 이미지') + ']' + (e.tail or '')
        e.drop_tag()
    for e in root.iter():
        keep = {k: v for k, v in e.attrib.items() if k in ('href', 'start', 'colspan', 'rowspan')}
        e.attrib.clear()
        e.attrib.update(keep)
    code_count += len(codes)
    table_count += len(root.findall('.//table'))
    cleaned_html = html.tostring(root, encoding='unicode')
    markdown = subprocess.run(['pandoc', '-f', 'html', '-t', 'gfm-raw_html', '--wrap=none'], input=cleaned_html, text=True, capture_output=True, check=True).stdout.strip()
    if codes:
        roundtrip = subprocess.run(['pandoc', '-f', 'gfm', '-t', 'html', '--wrap=none'], input=markdown, text=True, capture_output=True, check=True).stdout
        back = html.fragment_fromstring(roundtrip, create_parent='div')
        roundtrip_codes = [''.join(e.itertext()).rstrip('\n') for e in back.findall('.//pre/code')]
        assert [c.rstrip('\n') for c in codes] == roundtrip_codes, 'Code content was changed during conversion'
    return markdown, links, image_refs


for seq, tid in enumerate(order, 1):
    turn = turns[tid]
    role = turn['role']
    pair = (seq + 1) // 2
    assert role == ('user' if seq % 2 else 'assistant')
    mid = f'SHARE-{seq:03d}'
    if turn['messages']:
        assert len(turn['messages']) == 1
        body = turn['messages'][0]
        md, links, images = clean_body(body['html'])
        # Preserve plain-text user requests verbatim, including line breaks.
        user_dom = html.fragment_fromstring(body['html'], create_parent='div')
        plain_nodes = user_dom.xpath('.//div[contains(concat(" ", normalize-space(@class), " "), " whitespace-pre-wrap ")]')
        if role == 'user' and plain_nodes:
            md = '\n\n'.join(''.join(e.itertext()) for e in plain_nodes).strip()
        assert md
        status = 'captured_rendered_body'
        entry = {'id': mid, 'sequence': seq, 'pair_number': pair, 'role': role,
                 'timestamp': None, 'platform_turn_id': tid,
                 'platform_message_id': body['message_id'],
                 'content_type': 'verbatim_rendered_body', 'content_markdown': md,
                 'rendered_text': body['text'], 'capture_status': status,
                 'links': links, 'asset_ids': [],
                 'source_locator': turn['turn_locator'], 'redacted': False}
        if images:
            aid = f'ATTACHMENT-{seq:03d}'
            entry['asset_ids'].append(aid)
            assets.append({'id': aid, 'message_id': mid, 'status': 'reference_only',
                           'description': '공유 화면의 이미지 참조. 원본 이미지 파일은 이 추출에 포함하지 않음.',
                           'images': images})
    else:
        entry = {'id': mid, 'sequence': seq, 'pair_number': pair, 'role': role,
                 'timestamp': None, 'platform_turn_id': tid, 'platform_message_id': None,
                 'content_type': 'unavailable', 'content_markdown': '',
                 'rendered_text': '', 'capture_status': 'no_response_body_visible',
                 'visible_status_text': turn['text'], 'links': [], 'asset_ids': [],
                 'source_locator': turn['turn_locator'], 'redacted': False}
    entry['content_sha256'] = hashlib.sha256(entry['content_markdown'].encode()).hexdigest()
    messages.append(entry)

counts = Counter(m['role'] for m in messages if m['content_markdown'])
missing = [m for m in messages if not m['content_markdown']]
assert counts == {'user': 119, 'assistant': 116}
for m in messages[::2]:
    response = messages[m['sequence']]
    m['response_coverage'] = {'status': 'full_rendered_body' if response['content_markdown'] else 'no_response_body_visible', 'assistant_message_ids': [response['id']]}

data = {
    'schema_version': '1.0', 'project_id': 'kbs-erp-export-diag-agents',
    'project_title': raw['title'],
    'source': {'url': raw['source_url'], 'retrieved_at': raw['retrieved_at'],
               'method': 'Shared conversation UI; all 119 prompt positions visited; rendered message bodies captured in chronological DOM order',
               'first_date_label_observed': '9월 18일 (금) 오전 9:06',
               'timestamp_note': '공유 화면에서 확인하지 않은 개별 발화 시각은 추정하지 않고 null로 보존'},
    'coverage': {'status': 'all_displayed_bodies_captured_with_3_empty_assistant_slots',
                 'description': '공유된 단일 대화의 238개 발화 위치를 전부 대조했다. 사용자 요청 119개와 AI 응답 본문 116개를 확보했고, AI 응답 위치 3개는 직접 열어도 본문이 표시되지 않았다.',
                 'user_bodies': 119, 'assistant_bodies': 116, 'assistant_slots_without_body': 3,
                 'scope': '공유 링크에 표시된 대화 경로의 사용자·AI 본문. 프로젝트 전체 대화방, 다른 분기, 숨겨진 내부 처리, 첨부파일 원본 전체를 뜻하지 않음.',
                 'missing': [{'message_id': m['id'], 'pair_number': m['pair_number'], 'platform_turn_id': m['platform_turn_id'], 'visible_status_text': m['visible_status_text'], 'reason': 'No response body displayed in the shared page'} for m in missing]},
    'threads': [{'id': 'shared-sap-package-conversation', 'title': raw['title'],
                 'source_description': raw['source_url'], 'messages': messages}],
    'episodes': [], 'assets': assets,
    'integration_note': '전문 기준 자료. 기존 학습 에피소드의 선택·해설·경어체 편집과 사이트 반영은 별도 작업이며 이 파일에서 대화를 재작성하지 않았다.'
}

def write_json(name, value):
    (ROOT/name).write_text(json.dumps(value, ensure_ascii=False, indent=2)+'\n')

write_json('conversation-data.json', data)
write_json('rendered-source.json', raw)

lines = [f'# {raw["title"]} — 사용자·AI 대화 전문', '',
         f'출처: {raw["source_url"]}', '',
         '최초 화면 날짜: 9월 18일 (금) 오전 9:06  ',
         '추출일: 2026-10-13  ',
         '확보: 사용자 요청 119개 / AI 응답 본문 116개 / 본문이 표시되지 않은 AI 응답 위치 3개', '',
         '> 공유된 한 대화의 표시 본문을 순서대로 수집한 자료입니다. 요약하거나 답변을 재구성하지 않았습니다. 파일·이미지 첨부 원본과 화면에 없는 답변은 포함하지 않습니다. Markdown 변환 과정에서 표·목록·서식 문법과 복사 버튼 등 UI 요소는 정리했습니다.', '']
plain = []
for i in range(0, len(messages), 2):
    u, a = messages[i:i+2]
    lines += ['---', '', f'## 대화 {u["pair_number"]:03d}', '', f'### 사용자 요청 · {u["id"]}', '', u['content_markdown'], '', f'### AI 응답 · {a["id"]}', '']
    if a['content_markdown']:
        lines += [a['content_markdown'], '']
    else:
        observed = a['visible_status_text'] or '(표시 문구 없음)'
        lines += [f'> **추출 상태 안내 — AI 응답 아님:** 이 응답 위치를 직접 열어 확인했으나 공유 화면에 답변 본문이 표시되지 않았습니다. 화면 표시: {observed}.', '']
    for m in (u,a):
        plain += [f'===== {m["sequence"]:03d} {m["role"]} {m["platform_turn_id"]} =====',m['rendered_text'] if m['content_markdown'] else f'[본문 표시 없음: {m["visible_status_text"]}]','']
(ROOT/'SAP_Package_Conversation_Full.md').write_text('\n'.join(lines))
(ROOT/'rendered-transcript.txt').write_text('\n'.join(plain))

# Conservative ID bridge: exact match after whitespace / Markdown escape normalization only.
previous = Path('/workspace/scratch/29b3aafad6a9/erp-ai-portal/sources/conversations/20261012-supplement/kbs-erp-export-diag-agents/conversation-data.json')
old = json.loads(previous.read_text())
def norm(text):
    return re.sub(r'\s+', '', re.sub(r'\\([_`*#\[\]()~>+.!-])', r'\1', text))
matches, unmatched = [], []
for thread in old['threads']:
    for m in thread['messages']:
        hits = [n for n in messages if n['role'] == m['role'] and norm(m['content_markdown']) in {norm(n['content_markdown']),norm(n['rendered_text'])}]
        if len(hits) == 1:
            n = hits[0]
            matches.append({'previous_id': m['id'], 'shared_id': n['id'], 'pair_number': n['pair_number'],
                            'role': n['role'], 'method': 'unique_exact_match_after_whitespace_and_markdown_escape_normalization',
                            'assistant_response_id': messages[n['sequence']]['id'] if n['role']=='user' else None})
        else:
            unmatched.append({'previous_id': m['id'], 'role': m['role'], 'reason': 'no_unique_exact_match'})
write_json('existing-id-map.json', {'previous_source': '20261012-supplement/kbs-erp-export-diag-agents/conversation-data.json', 'matches':matches,'unmatched':unmatched,'note':'매칭되지 않은 항목을 유사도만으로 연결하지 않았다. 기존 포털 파일은 변경하지 않았다.'})
validation = {'expected_turn_slots':238,'accounted_turn_slots':len(messages),'user_bodies':counts['user'],'assistant_bodies':counts['assistant'],
              'empty_assistant_slots':len(missing),'unaccounted_turn_ids':[], 'unique_turn_ids':len(set(order)),
              'unique_nonempty_message_ids':len({m['platform_message_id'] for m in messages if m['platform_message_id']}),
              'alternating_user_assistant_order':True,'code_blocks_preserved_exactly':code_count,'tables_converted':table_count,
              'old_messages_matched_exactly':len(matches),'old_messages_without_unique_exact_match':len(unmatched),
              'markdown_characters':sum(len(m['content_markdown']) for m in messages),
              'source_sha256':hashlib.sha256(SOURCE.read_bytes()).hexdigest(),
              'scope_limit':'Completeness checked against displayed turn slots, not against private server records or other branches.'}
write_json('validation.json',validation)
readme = f'''# SAP 패키지 이관 구현 — 공유 대화 전문 추출

사용자 요청 **119개**, AI 응답 본문 **116개**를 확보했습니다. 전체 발화 위치 **238개**를 대조했고, 미확인 위치는 없습니다. 다만 AI 응답 위치 3곳에는 공유 화면에 본문이 표시되지 않았습니다.

출처: {raw['source_url']}

최초 화면 날짜는 **9월 18일 (금) 오전 9:06**입니다. 개별 메시지의 시각은 확인되지 않은 경우 추정하지 않았습니다.

## 파일

- `SAP_Package_Conversation_Full.md`: 사용자 요청·AI 응답 전문을 119개 대화쌍으로 배열한 읽기용 파일.
- `conversation-data.json`: 역할, 순서, 원래 발화 식별자, 전문, 응답 확보 상태를 포함한 포털 가공용 자료.
- `rendered-transcript.txt`: 수집한 화면 표시 텍스트. 코드 언어명 등 UI 문구가 일부 포함될 수 있음.
- `rendered-source.json`: 변환 전 화면 본문 HTML·텍스트와 대화 순서. 검증용이며 웹페이지에 그대로 삽입하지 않음.
- `existing-id-map.json`: 이전 추출본과 고유한 정확 일치가 확인된 발화 {len(matches)}개의 식별자 대응표.
- `validation.json`: 발화 수, 순서, 본문 없는 위치, 코드·표 보존 검사 결과.
- `build_transcript.py`: 수집 결과를 전문 파일로 변환한 재현용 스크립트. 입력 경로는 실행 환경에 맞게 변경 필요.

## 공유 화면에서 본문이 없는 응답

| 대화 번호 | 응답 식별자 | 공유 화면 표시 |
|---|---|---|
'''
for m in missing:
    readme += f'| {m["pair_number"]:03d} | {m["id"]} | {m["visible_status_text"] or "표시 문구 없음"} |\n'
readme += '''
## 추출 범위와 활용

이번 자료는 공유 링크에 표시된 **단일 대화 경로**의 본문입니다. 프로젝트의 다른 대화방·분기와 첨부 파일 원본 전체를 포함한다는 뜻은 아닙니다. 파일 이름이나 링크가 답변에 있더라도 파일 내부까지 추출한 것은 아닙니다. 본문이 표시되지 않는 3곳의 내용과 이유는 추정하지 않았습니다.

사용자 요청의 어조를 바꾸거나 AI 답변을 요약·보충하지 않았습니다. Markdown에서는 표·목록·코드 서식을 변환하고 복사 버튼·접기 버튼을 제거했습니다. 원래 화면 텍스트와 HTML도 함께 보존했습니다. 링크가 이후 만료될 가능성은 본문 보존 여부와 별개입니다.

교육 포털에서는 이 전문을 기준 자료로 삼아 목적 → 최초 지시 → 응답 → 오류·피드백 → 수정·검증으로 학습 에피소드를 구성할 수 있습니다. 교육용 경어체 요청·해설은 원래 발화와 별도 필드로 관리하는 것이 적절합니다. 이번 ZIP은 대화 추출 자료이며 사이트 배포본은 아닙니다. 기존 포털과 에피소드 파일은 변경하지 않았습니다.
'''
(ROOT/'README.md').write_text(readme)
zip_path=ROOT.parent/'SAP_Package_Conversation_Full_20261013.zip'
with zipfile.ZipFile(zip_path,'w',zipfile.ZIP_DEFLATED) as z:
    for p in sorted(ROOT.iterdir()):
        if p.is_file():z.write(p,arcname=f'SAP_Package_Conversation_Full/{p.name}')
with zipfile.ZipFile(zip_path) as z:
    assert z.testzip() is None
print(json.dumps({'validation':validation,'zip':str(zip_path),'zip_size':zip_path.stat().st_size},ensure_ascii=False,indent=2))
