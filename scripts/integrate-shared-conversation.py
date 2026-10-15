"""One-time editorial integration of the 2026-10-13 shared transcript.

Preserved inputs remain untouched. Normal Node builds consume generated content.
"""
import copy
import hashlib
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PID = 'kbs-erp-export-diag-agents'
SOURCE = ROOT / 'sources/conversations/20261013-shared' / PID
OLD = ROOT / 'sources/conversations/20261012-supplement' / PID
OUT = ROOT / 'content/conversations/export-full'
OUT.mkdir(parents=True, exist_ok=True)

def read(p): return json.loads(p.read_text())
def write(p, v): p.write_text(json.dumps(v, ensure_ascii=False, indent=2)+'\n')
shared, old = read(SOURCE/'conversation-data.json'), read(OLD/'conversation-data.json')
original = shared['threads'][0]['messages']
old_messages = {m['id']:m for t in old['threads'] for m in t['messages']}
bridge = read(SOURCE/'existing-id-map.json')
pair_by_old = {m['previous_id']:m['pair_number'] for m in bridge['matches']}
# Verified by order, preceding/following turns and the complete matching body.
pair_by_old.update(U013=39,U042=67,U064=89,U081=107,U083=109,U091=117,U092=118,U093=118)
old_by_pair = {}
for oid, pair in pair_by_old.items(): old_by_pair.setdefault(pair,[]).append(oid)

editorial_path = ROOT/'content/conversations/editorial-prompts.json'
editorial = read(editorial_path)
previous_edits = editorial['projects'][PID]
# Read the retained editorial source when this one-time integration is rerun.
saved_edits = OUT/'previous-editorial-prompts.json'
if saved_edits.exists(): previous_edits = read(saved_edits)
else: write(saved_edits,previous_edits)

user_edits = {
2:'첫 번째 질문에 대한 시스템 정보는 화면으로 첨부했습니다. 최초 추출 대상 개발클래스는 ZHR·ZFI 등의 값으로 고정하지 않고, 추출 Z프로그램에서 사용자가 선택하도록 구성해 주십시오. PowerShell과 Python은 설치되지 않은 환경을 전제로 진행해 주십시오.',
3:'사용하는 PC의 운영체제는 Windows 11입니다.',
5:'언어별 텍스트는 한국어·영어(K/E)를 대상으로 진행해 주십시오. 다른 패키지의 공용 객체는 우선 참조 목록만 남겨 주십시오. 제공해 주신 DIAG 프로그램의 결과를 result.txt로 첨부했습니다. 다음 작업을 계속 진행해 주십시오.',
6:'요청하신 결과물을 업로드했습니다.',
7:'최종 검증과 수정본 저장을 완료한 뒤 결과물을 다시 제공해 주십시오.',
15:'다른 패키지에서도 추출을 확인하기 위해 재무회계 패키지 ZFI1을 실행했습니다. 첨부 화면과 같은 오류가 발생했으니 확인해 주십시오.',
16:'재무회계 패키지 ZFI1도 같은 방식으로 추출했습니다. ZHR5보다 파일이 훨씬 많습니다. 이 결과도 분석하여 동일한 기준으로 피드백해 주십시오.',
17:'ZHR5와 ZFI1의 추출 결과에 BSP 라이브러리가 포함되지 않은 이유를 설명해 주십시오. 해당 영역에는 핵심 웹 자산이 포함되어 있습니다.',
18:'기존 추출 프로그램에서 BSP와 MIME까지 추출할 수 있도록 ABAP Export 프로그램을 재구성해 주십시오.',
19:'Z_PACKAGE_EXPORT 활성화 시 2719행에서 `field xstrlen( is unknown` 오류가 발생합니다. 확인해 주십시오.',
20:'2937행에서 `LT_EVNETS is a table of the kind SORTED. you cannot use the Sort command with this type of table` 오류가 발생합니다. 해당 부분을 수정해 주십시오. 전체 파일을 다시 제공할 필요는 없으며, Z_PACKAGE_EXPORT 수정본만 별도로 제공해 주십시오.',
21:'3089행에서 `LT_PAGES is a table of the kind SORTED. you cannot use the Sort command with this type of table` 오류가 발생합니다. SORT 관련 오류가 반복되므로 해당 부분과 이후의 유사한 사용 위치를 함께 확인하여 수정해 주십시오. 전체 배포본 대신 Z_PACKAGE_EXPORT 수정본만 별도로 제공해 주십시오.',
23:'ZWEB_FI_BIZCARD의 개발클래스는 ZBIZCARD이며 ZFI1과 별개입니다. 다른 개발클래스의 소스까지 가져오는 것은 원래 목적에 맞지 않습니다. 선택한 개발클래스 범위 밖의 대상은 추출 대상과 실패 로그에서 처음부터 제외해 주십시오.',
24:'다음 단계에 앞서 현재까지의 프로젝트 맥락과 수정 요구사항을 종합하여 보고해 주십시오. 대화가 길어짐에 따른 추론과 토큰 사용 부담을 줄이기 위해 기준을 정리하고자 합니다.\n\n앞으로 적용할 사항도 함께 정리해 주십시오.\n\n1. 프로그램 파일명의 `o_` 등 도구가 붙인 접두어를 제거해 주십시오. 실제 프로그램과 이름이 달라 비교 시 혼동됩니다.\n2. EN 영어를 제외하고 KO 한국어만 고려해 주십시오.\n3. 활성화 오류가 발생하지 않도록 SAP_BASIS 700에 맞는 ABAP 코드로 작성해 주십시오.\n4. 다른 개발클래스에 속하는 코드와 파일은 추출 범위에서 제외해 주십시오.',
25:'정리한 기준에 따라 작업을 계속 진행하고, 추출 프로그램을 ZIP 파일로 다시 제공해 주십시오.',
27:'예산편성 및 전용 개발클래스인 ZBUDGET를 추출했습니다. 결과를 분석해 주십시오.\n\nBSP 애플리케이션의 pages 아래에 000001·000002와 같은 숫자 폴더가 있고, 그 아래 content 폴더에 HTM 파일이 있어 원하는 페이지를 찾기 어렵습니다. 숫자 대신 해당 HTM 페이지의 이름을 사용하도록 변경해 주십시오. 예를 들어 `capital_budgeting.htm`은 `capital_budgeting` 폴더로 구성해 주십시오.',
90:'현재 제한은 유지하겠습니다. exports 폴더 아래의 내용만 압축하여 업로드하겠습니다.'
}

def formal_first(text):
    # Formalize declarative/directive sentence endings without changing requirements.
    fixed = text.replace('시니어 개발자다.', '시니어 개발자의 역할을 맡아 주십시오.')
    for a,b in [('구현하라.','구현해 주십시오.'),('진행하라.','진행해 주십시오.'),('완성하라.','완성해 주십시오.'),('표시하라.','표시해 주십시오.')]: fixed=fixed.replace(a,b)
    replacements = [('하지 않는다.','하지 마십시오.'),('않는다.','않도록 해 주십시오.'),('한다.','해 주십시오.'),('있다.','있습니다.'),('이다.','입니다.'),('패키지다.','패키지입니다.'),('다르다.','다릅니다.')]
    for a,b in replacements: fixed=fixed.replace(a,b)
    return fixed.replace('집계되어야 해 주십시오.', '집계해 주십시오.')

messages, edits = [], {}
for src in original:
    m = copy.deepcopy(src)
    m['content_type'] = 'unavailable' if src['capture_status']=='no_response_body_visible' else 'verbatim'
    m['source_locator'] = f"공유 대화 ‘SAP 패키지 이관 구현’ · 대화 {src['pair_number']:03d} · {src['source_locator']} · {src['platform_turn_id']}"
    m['source_url'] = shared['source']['url']
    m['asset_ids'] = []
    m['legacy_message_ids'] = old_by_pair.get(m['pair_number'],[]) if m['role']=='user' else []
    if m['role']=='user':
        for oid in m['legacy_message_ids']:
            m['asset_ids'] += old_messages[oid]['asset_ids']
        m['asset_ids'] = list(dict.fromkeys(m['asset_ids']))
        m['capture_notes'] = ['원래 요청 본문과 교육용 표시 문장을 별도로 보존합니다. 첨부는 이전 추출본에서 동일 위치로 확인한 자료만 연결합니다.']
        candidates = [previous_edits[x]['content_markdown'] for x in m['legacy_message_ids'] if x in previous_edits]
        if m['pair_number'] in user_edits: text=user_edits[m['pair_number']]
        elif m['pair_number']==1: text=formal_first(m['content_markdown'])
        elif candidates: text=candidates[-1]
        else: text=m['content_markdown']
        m['attachment_only'] = bool(re.fullmatch(r'(?:이미지 업로드됨|파일 업로드됨|\s)+',m['content_markdown']))
        if m['attachment_only']: text='첨부 자료만 전달된 항목입니다. 별도 요청 문장은 없습니다.'
        edits[m['id']]={'source_sha256':hashlib.sha256(m['content_markdown'].encode()).hexdigest(),'content_markdown':text}
    elif m['content_type']=='unavailable':
        m['capture_notes']=['해당 위치를 직접 열었으나 공유 화면에 AI 답변 본문이 표시되지 않았습니다. 내용을 추정하지 않았습니다.']
    else:
        m['capture_notes']=['공유 화면의 답변 본문 전문입니다. 요약하거나 교육용 문체로 재작성하지 않았습니다. 당시 작성·검증 주장과 현재 운영 확인은 구분합니다.']
    messages.append(m)

def refs(start,end): return [m['id'] for m in messages if start<=m['pair_number']<=end]
def new_episode(eid,title,start,end,nodes,goal,pre,review,outcome,exercise):
    return {'id':eid,'order':0,'title':title,'goal':goal,'map_nodes':nodes,'prerequisites':pre,'message_refs':refs(start,end),'asset_ids':[],
            'commentary_markdown':'**교육 해설 — 실제 AI 발화 아님.**\n\n'+review,
            'outcome_markdown':outcome,'exercise_markdown':'**교육용 재작성 프롬프트 / 실습**\n\n'+exercise}

episodes=[
new_episode('E00-start','프로젝트 목적과 SAP 환경을 먼저 확인하다',1,4,['sap','export','codex'],
'처음 AI에 전달한 목표·제약과 환경 확인 질문을 읽고, 자기 업무의 시작 요청을 구성합니다.',
['ECC 6.0 / SAP_BASIS 700의 패키지 단위 개발 방식.', '초기 목표에는 Import·활성화·CTS가 있었으나 후반 E16에서 읽기 전용 DIAG로 변경된다.'],
'첫 요청은 단순 소스 다운로드가 아니라, 패키지 추출부터 로컬 분석·수정·Git·SAP 반영까지 이어지는 목표였다. 단일 REPORT 구성과 BASIS 700 제약도 함께 명시했다.\n\nAI는 바로 전체 구현을 완료했다고 하지 않고 SP·Unicode, 최초 대상 패키지, PC 실행 환경을 질문했다. 사용자는 화면 정보와 Windows 11, PowerShell·Python 미설치 조건을 제공했다. 이어 진단 출력으로 실제 객체 유형과 API를 확인했다.\n\n초기 목표와 최종 결정을 구분해야 한다. 이때의 자동 반영 구상을 현재 기능으로 읽지 말고 E16의 방향 변경까지 따라간다.',
'최초 요청과 초기 AI 답변을 확보했다. 대화 4의 진단 출력 및 AI 해석에는 ZHR5 18종·618건이 나온다. 이 수치는 당시 대상이며 현재 시스템 전체 현황이 아니다.',
'“현재 시스템의 버전·작업 단위·사용 가능한 PC 도구는 다음과 같습니다. 최종 목표와 먼저 검증할 최소 단계를 분리하고, 확인이 필요한 질문을 세 가지 이내로 정리해 주십시오.”\n\n**완료 기준:** 자신의 환경표, 범위표, AI가 직접 확인할 수 없는 항목을 한 장으로 작성한다. 모르는 SP·API 정보를 추측하여 채우지 않는다.'),
new_episode('E00-export','첫 추출기의 오류를 실행 결과로 줄이다',5,14,['sap','export','feedback'],
'파일 무결성 통과와 SAP 객체 읽기 성공을 구분하고, 실행 자료를 근거로 반복 수정하는 방법을 익힙니다.',
['초기 진단 결과와 한국어·영어, 외부 패키지 참조 정책.', '이 구간의 업로드 원본 파일은 모두 확보된 것이 아니며, 실제 화면 본문만 전사했다.'],
'언어 조건, 긴 함수 소스, SOURCE/NEW_SOURCE 선택 문제로 오류가 이어졌다. AI는 각 응답에서 원인과 수정 버전을 설명했고, 사용자는 결과물과 화면을 다시 제공했다. 대화 11에서는 함수 127개 읽기 완료를 보고하고, 이후 남은 구조체의 활성 정의와 내부 INCLUDE 범위를 별도로 다뤘다.\n\n교육에서 중요한 점은 ZIP 파일 점검이 통과했다고 SAP 객체가 전부 추출된 것으로 보지 않는 것이다. 실패 유형과 검증 방법을 나눈다. 대화 13의 응답 본문은 공유 화면에 표시되지 않아 안내로만 남긴다.',
'대화 14의 AI는 0.2.4 내부 INCLUDE 추출을 사용자 실행 결과로 검증했다고 설명한다. 이번 포털 작업에서 SAP를 다시 실행하거나 당시 모든 ZIP을 새로 감사한 것은 아니다.',
'“첨부 결과에서 파일 해시·파일 개수 검증과 SAP 조회 실패를 구분해 주십시오. 원인별 수정 범위, 다시 실행할 항목, 다음 결과에서 확인할 수치를 표로 정리해 주십시오.”\n\n**완료 기준:** 오류 → 수정 → 재실행 근거를 세 열로 기록한다. 실패 0건과 미지원·생략 0건을 같은 뜻으로 쓰지 않는다.'),
new_episode('E00-web','다른 패키지에서 BSP·MIME 누락을 발견하다',15,23,['sap','export','feedback'],
'한 패키지의 성공을 다른 패키지까지 확대하지 않고, 웹 자산과 패키지 경계 요구를 구체화합니다.',
['ZHR5에서 ZFI1으로 대상을 확대했다.', 'BSP·MIME는 업무 웹 화면의 핵심 자산이라는 사용자 요구.'],
'ZFI1에서는 용량 상한과 개별 객체 문제를 확인한 뒤, 사용자가 BSP 라이브러리 누락을 지적했다. AI는 해당 기능이 아직 구현되지 않았음을 인정하고 0.3.0 확장본을 제공했다. 이후 XSTRLEN 사용과 SORTED TABLE의 SORT 문에서 BASIS 700 호환 오류가 반복됐다.\n\n사용자는 특정 행만 고치는 데 그치지 않고 비슷한 SORT 사용을 함께 확인하도록 요청했다. 마지막에는 ZWEB_FI_BIZCARD가 ZBIZCARD 소속임을 알려 선택 범위 밖 자산의 추출을 제외시켰다.',
'BSP·MIME 확장, XSTRLEN 계산 분리, 불필요한 SORT 제거, 외부 개발클래스 제외에 대한 당시 AI 답변을 읽을 수 있다. 각 답변의 로컬 검사와 실제 SAP 실행 보고는 별도 근거다.',
'“대표 패키지와 성격이 다른 패키지 하나의 결과를 비교해 주십시오. 빠진 객체 유형, 파일 용량 제한, 범위 밖 참조를 구분하고, 보고된 문법 오류와 같은 패턴을 전체 소스에서 점검해 주십시오.”\n\n**완료 기준:** 패키지별 객체 유형 비교표와 범위 밖 자산 처리 원칙을 작성한다.'),
new_episode('E00-context','변경 요구를 맥락 문서와 파일 규칙으로 남기다',24,27,['export','knowledge','feedback'],
'대화 중 바뀐 요구를 문서로 고정하고 다음 버전의 확인 기준으로 사용합니다.',
['BSP·MIME 추가 후 파일 이름·언어·패키지 경계 규칙을 다시 정리하는 단계.'],
'사용자는 장기 대화의 맥락을 정리하면서 접두어 제거, KO만 사용, BASIS 700 준수, 타 개발클래스 제외를 명시했다. AI는 맥락 문서와 0.3.5를 제공했고, 다음 결과에서는 한글 파일명이 #로 바뀌는 ZIP 이름 인코딩 문제가 드러났다. ZBUDGET 사례에서는 숫자 폴더를 페이지 이름으로 바꾸도록 요구했다.\n\n맥락 정리는 단순 요약으로 끝나지 않는다. 새 요구를 실제 파일 경로와 검증 사례에 연결한다. 이때의 KO 전용 결정은 이후 E03에서 KO 우선·EN 보완으로 바뀐다.',
'대화 26에서 AI가 ZIP 유니코드 파일명 설정 누락을 원인으로 설명했다. 대화 27에서는 ZBUDGET 점검 결과와 BSP 폴더 이름 변경을 안내했다. 최종 정책은 후속 에피소드의 변경까지 확인한다.',
'“지금까지 확정된 요구, 변경된 요구, 미해결 문제를 분리해 맥락 문서로 정리해 주십시오. 파일명·언어·범위 정책마다 확인할 실제 결과 예시를 붙여 주십시오.”\n\n**완료 기준:** 변경 이유와 적용 버전을 함께 기록한다. 한글 이름·동명 파일·페이지 경로를 다음 추출의 점검 항목으로 남긴다.')
]

# Updated explanations cite recovered response pairs, rather than later files alone.
reviews={
'E01':('대화 28에서 AI는 BSP 폴더 경로 중복을 설명했고, 29~31에서는 SAP의 다섯 탭에 맞춘 폴더와 XML 출력을 안내했다. 사용자의 첫 삭제 요청에 이어 Properties·Page Attributes 정보를 보존하라는 보완이 들어왔다. 이름 정리와 정보 삭제를 구분하는 사례다. 사용자 원문의 OnDestory 오타는 보존하고 해설에서는 OnDestroy로 구분한다.', '0.3.9·0.3.10 수정 안내 전문을 확보했다. 이 응답 자체는 당시 작성 보고이며 현재 SAP에서 다시 실행했다는 뜻은 아니다.'),
'E02':('20개 요청을 한꺼번에 받은 AI는 대화 32에서 작업 환경 연결 실패로 수정본을 제공하지 못했다고 밝혔다. 다음 응답에서 0.3.11을 제공한 뒤, NORMAL 인자 오류와 함수별 Source code 폴더 위치를 다시 수정했다. 대화 34의 실제 수정 설명은 set_normalizing 호출 두 곳의 인자를 고친 것이다. 요청 경로는 완전한 예시로 전달해야 오해를 줄일 수 있다.', '0.3.11~0.3.13의 안내와 오류 수정 응답을 확인했다. 메시지 클래스 추가와 함수 폴더 계약을 학습하며 정적 검사와 SAP 활성화 확인을 나눈다.'),
'E03':('KO 전용 추출 이후 사용자는 언어 문제를 의심했지만, AI는 대화 38에서 자체 XML 왕복 검사의 전제가 잘못됐다고 설명했다. 언어 fallback, 원시 직렬화, 들여쓰기를 별도 단계로 검토해야 원인 가설을 검증할 수 있다. 대화 39의 첨부 전용 요청 뒤에는 AI가 결과를 분석한 전문이 연결된다.', 'AI 응답에는 콘텐츠 4,285개 일치와 SAP 프로그램 3개의 읽기 실패가 함께 보고된다. 파일 검증 통과를 전체 객체 추출 성공으로 확대하지 않는다.'),
'E04':('대화 40~46은 대용량 예산, 숨김 파라미터 선언 오류, MIME 실패 집계, DDIC 예외와 의도적 제외 정책을 다룬다. AI가 오류 0으로 보였던 집계 문제를 인정한 응답도 포함한다. 사용자는 기술 공통 참조를 무조건 확장하지 않도록 범위를 정했다. baseline은 후속 비교 기준이므로 AI 검색 중복과 파일 보존 필요를 구분한다.', '0.3.18 안내에서 17,142개 파일 일치와 생략 19개 등의 당시 결과를 확인할 수 있다. 실패를 처리한 것과 의도적으로 생략한 것은 서로 다른 결과다.'),
'E05':('사용자의 목적이 패키지별 업무 AI 에이전트로 확장되는 구간이다. AI는 저장소 정리 → Publish → Mac Clone 순서를 제시하고 Clone·Pull·Pull Request를 구분했다. 대화 50의 사용자는 ZHR5 에이전트 구성을 성공했다고 보고한다. 여러 에이전트의 역할 제안과 실제 자동 협업 운영은 구분해서 읽는다.', 'GitHub Publish와 Mac Clone은 사용자의 당시 성공 보고다. 현재 브랜치·설치 버전·ZFI/ZMM 자동 협업 운영을 이 포털에서 검증한 것은 아니다.'),
'E06':('코드와 구조만으로는 정책의 이유나 담당자의 판단 맥락을 알기 어렵다는 문제에서 시작한다. AI는 스킬의 절차, 업무 지식 MD의 근거, 원문 보존, 추출 소스의 역할을 구분했다. 대화 56에서는 11개 원문을 반영한 MD 40개·스킬 3개 키트를 제공했다고 안내하고, 57에서는 다른 패키지에도 적용할 공통 구축 가이드를 제시한다. 이전 추출본의 중복 요청 U030/U031은 공유 화면에서 하나의 요청에 대응하므로 한 번만 표시한다.', '자료 구성과 생성 안내를 실제 AI 답변으로 읽을 수 있다. 키트가 존재한다는 사실과 Mac에서 현재 스킬이 로드되어 올바른 업무 답변을 하는지는 별도 확인한다.'),
'E07':('사용자는 자연어 업무 답변에는 실행 오류가 나지 않는데 어떻게 실패를 인지하는지 질문했다. AI는 앞선 설명에서 정답 판정 기준이 빠졌음을 인정했다. 이후 업무 피드백과 코드 검증을 분리하고, 담당자의 수정 지시를 근거 문서·지침·회귀 사례로 반영하는 방식으로 범위를 좁혔다. 업무 답변의 실패만으로 ABAP까지 자동 변경하지 않는다는 경계도 확인한다.', 'BUSINESS_FEEDBACK_POLICY.md 제공 응답과 사용자 적용 예정 보고가 연결된다. 하네스 폴더나 정책 문서가 모든 사례의 자동 평가·무인 운영을 입증하지는 않는다.'),
'E08':('수동 ZIP 업로드를 줄이려 SAP에서 GitHub 목록을 직접 조회했으나 SSL/TLS 단계에서 막혔다. AI는 초기 화면, 실제 ICM 로그, 존재하지 않는 프로파일 파라미터 문의를 차례로 분석했다. SAP error code 407을 HTTP 프록시 인증 코드로 단정하지 않고 로그의 protocol version alert를 함께 읽는다. 토큰 수정으로 해결할 문제인지 먼저 구분하는 사례다.', '대화 70에서 사용자가 직접 통신을 보류하고 Actions 논의로 이동했다. 현재 시스템의 TLS 설정 변경·연결 성공은 확인하지 않았다.'),
'E09':('AI는 YAML이 검사 순서를 지정하고, 실제 검사는 지정된 도구가 러너에서 수행한다고 설명한다. Actions 자체가 AI인지, 로컬 Codex에 결과가 자동 전달되는지 묻는 후속 질문으로 실행 주체와 전달 경로가 구체화된다. Ubuntu가 필수라는 오해도 해소한다. 반복 실행되는 저장소 검증과 실제 SAP 배포를 구분한다.', '사용자는 Actions를 사용해 보겠다는 의향을 밝힌 뒤 비교 프로그램으로 넘어간다. 실제 workflow 설치와 성공 로그는 이 대화의 설명만으로 확정할 수 없다.'),
'E10':('처음 Import는 실제 저장·활성화보다 ZIP 비교와 검증 리포트부터 구현하는 방향으로 시작했다. ABAP뿐 아니라 HTML·JS·CSS의 줄 차이도 요구했다. 대화 83에서 AI는 MOD가 포함된 조건식 네 곳을 수정하고 정적 검사와 108개 줄 비교 사례를 보고했다. 서버에 저장하지 않은 사전 검사와 실제 활성화를 구분해서 읽는다.', '첫 비교 프로그램 안내와 사용자 실행 결과 해석을 확보했다. 프로그램 이름이 Import였다는 이유로 자동 저장·활성화가 구현됐다고 해석하지 않는다.'),
'E11':('사용자는 ABC 모드 대신 ZIP 하나와 원본 중심 세 비교를 요구했다. 대화 86에서 AI는 DIFFERENT 78건의 내용과 파일 크기가 아닌 바이트 비교라는 점을 설명한다. 같은 길이의 다른 내용, XML 표현 차이와 의미 차이, 원본 대비 변경과 현재 두 값의 일치 여부는 각각 다른 질문이다.', '0.2.0과 0.3.0의 수정 안내를 읽을 수 있다. SAP 읽기 미확인은 파일 부재가 아니며 비교 불가를 변경없음으로 채우지 않는다.'),
'E12':('이 구간에는 ZIP 항목·크기 제한, .git 데이터 혼입, Export 버전 제한, ALV 헤더 높이, F3 복귀 경로가 차례로 등장한다. 대화 89·90의 AI 본문은 공유 화면에 없어 안내로 표시한다. 사용자는 exports 아래만 압축하겠다고 했고, 대화 91~94의 실제 AI 응답에서 헤더 축소·버전 허용·화면 복귀·좌우 비교 수정 이유를 확인할 수 있다.', '“ALV 결과까지는 나왔다”는 사용자의 부분 성공과 이어진 F3 오류를 함께 보존한다. 한 장애가 해결됐다는 보고를 전체 완료로 확대하지 않는다.'),
'E13':('조회 결과, 자료 종류, 활성 버전 근거와 검사 생략을 같은 상태 열에 섞어 둔 탓에 설명이 모호해졌다. 대화 97에서 AI가 이 설계 문제를 인정하고 상태별 실제 의미를 설명한다. 사용자는 조회 결과와 활성 버전 확인을 분리하고 한글로 표시하도록 요청한다. 미확인을 비활성으로 확정하지 않는 것이 핵심이다.', '0.3.8의 조회·활성 확인 분리 안내 전문을 확보했다. 화면 이름뿐 아니라 API·반환값·검사 수행 여부도 구분해 읽는다.'),
'E14':('XML 비교를 추가한 뒤 유사한 값이 여러 번 변경된 것처럼 표시됐다. 대화 101에서 AI는 하위 텍스트를 합쳐 읽은 상위 요소까지 변경으로 집계한 비교 로직 문제를 설명했다. 부모·자식 경로, 직접 텍스트·속성, 공백 표현 차이를 분리해 검증해야 한다.', '당시 오류 인정과 수정 설명을 확보했다. 현재 SAP에서 모든 false positive가 사라졌다는 검증을 새로 수행한 것은 아니다.'),
'E15':('사용자가 원한 것은 단순 표 모양의 헤더가 아니라 실제 ALV 헤더였다. AI는 WIDTH 인자 오류의 동일 호출 열 곳을 수정했고, 이후 상단을 별도 ALV로 구성했다. 대화 106에서는 A=세 비교, B=활성·문법 검증으로 나눠 상태·건수 집계를 정리했다. 가독성 요구를 필드·집계 모수·화면 동작으로 구체화하는 사례다.', '0.3.11~0.3.15의 수정 응답과 “표로 바뀌었지만 ALV가 필요하다”는 사용자 피드백을 함께 읽는다. 개인 정보로 제외된 과거 화면의 공개 범위는 유지한다.'),
'E16':('대화 107에서 사용자는 자동 Import·활성화가 아직 충분히 검증되지 않았다고 판단해 이를 제외하고 DIAG로 이름과 방향을 바꿨다. AI는 읽기 전용 0.4.0으로 전환한 뒤 이름 중복, 화면 높이, 입력 범위, 필터를 수정했다. 문법 사전검사 기본 선택과 모든 파일에서 검사가 실제 수행되는 것은 다르다는 후속 설명도 함께 읽는다.', '현재 교육 기준은 읽기 전용 진단이다. 초기 목표에 등장한 저장·활성화·CTS를 현재 제공 기능으로 다시 포함하지 않는다. 0.4.5 실제 SAP 실행 확인은 별도다.'),
'E17':('사용자는 일반적인 가능성 설명 대신 실제 ZHR5 엑셀의 행을 근거로 설명해 달라고 요청했다. AI는 함수/Include 연결, 공통 속성과 함수 자체 속성, 확인 실패와 검사 미수행, 잘린 설명 보존을 구체화했다. 대화 114~115에서는 선택한 개선과 날짜·시간 인자 형식 수정이 이어진다. 이전부터 확보한 RawData에서는 확인 실패 71건을 함수 70건과 DDIC 1건으로 나눠 읽는다.', '0.4.4 개선 안내와 9128행 형식 오류 수정 응답을 확보했다. 당시 AI의 정적 점검 보고와 최신 0.4.5 SAP 활성화·ALV·JSON 실행 성공은 구분한다.'),
'E18':('요약 산출물에서 실제 대화 기반 교육 자료로 요구가 발전한 과정이다. 과거 AI 답변에 “전문 미확보”라고 쓰여 있는 것은 당시 추출 상태이며 이번 화면의 현재 확보 상태가 아니다. 2026-10-13에는 공유 화면의 사용자 119개·AI 본문 116개를 확보했다. 이전 자료의 진행 안내와 중복 요청은 보존 폴더에 남기되 이번 공유 경로에 임의로 끼워 넣지 않았다.', '화면의 기술 학습과 원문 추출 작업을 구분했다. 공유 화면에 없는 응답 3곳과 첨부 원본의 미확보는 별도로 표시한다.')
}
for old_e in old['episodes']:
    e=copy.deepcopy(old_e)
    pairs=sorted({pair_by_old[mid] for mid in e['message_refs'] if mid in pair_by_old})
    if e['id']=='E12':pairs=sorted(set(pairs+[90]))
    if e['id']=='E18':pairs=[117,118,119]
    e['message_refs']=[m['id'] for m in messages if m['pair_number'] in pairs]
    review,outcome=reviews[e['id']]
    e['commentary_markdown']='**교육 해설 — 실제 AI 발화 아님.**\n\n'+review
    e['outcome_markdown']=outcome
    if e['id']=='E01':e['prerequisites']=['앞선 초기 4개 에피소드에서 환경·첫 추출기·BSP·파일 규칙을 확인한다. ZMM6의 SAP 화면과 추출 파일 구조를 비교하는 단계다.']
    episodes.append(e)
for i,e in enumerate(episodes,1): e['order']=i
assert {m['id'] for m in messages}=={mid for e in episodes for mid in e['message_refs']}

assets=copy.deepcopy(old['assets'])
for a in assets:
    a['legacy_related_message_ids']=a.get('related_message_ids',[])
    a['related_message_ids']=list(dict.fromkeys(f'SHARE-{2*pair_by_old[mid]-1:03d}' for mid in a.get('related_message_ids',[]) if mid in pair_by_old))

missing=[m for m in messages if m['content_type']=='unavailable']
coverage=copy.deepcopy(shared['coverage'])
coverage['status']='partial'
coverage['description']='9월 18일 시작 공유 대화의 238개 발화 위치를 대조했습니다. 사용자 요청 119개와 AI 응답 본문 116개를 수집했고, 본문이 표시되지 않는 AI 응답 위치 3곳을 별도 안내로 남겼습니다. 프로젝트의 다른 대화방·분기나 첨부파일 원본 전체를 확보했다는 뜻은 아닙니다.'
coverage['missing']=[f'대화 {m["pair_number"]:03d}: 공유 화면에 AI 응답 본문 없음. 표시 문구: {m.get("visible_status_text") or "없음"}.' for m in missing]+['초기 업로드와 중간 버전의 모든 첨부파일 원본, 개별 메시지의 정확한 시각.', '현재 사용자 Mac 상태와 최신 DIAG의 실제 SAP 실행·활성화 성공.']
data={'schema_version':'1.0','project_id':PID,'project_title':old['project_title'],'source':shared['source'],'coverage':coverage,
      'threads':[{'id':'shared-sap-package-conversation','title':shared['project_title'],'source_description':shared['source']['url'],'messages':messages}],
      'episodes':episodes,'assets':assets}
write(OUT/'conversation-data.json',data)
editorial['projects'][PID]=edits
write(editorial_path,editorial)

context='''# 프로젝트 맥락과 학습 순서

## 시작 목적과 환경

패키지 단위 SAP 소스를 외부로 추출하여 VS Code·AI로 분석·수정하고 Git으로 관리하려는 목적에서 시작했습니다. 최초 요청에는 Z_PACKAGE_EXPORT와 Z_PACKAGE_IMPORT, 검사·저장·활성화·CTS까지 포함됐습니다. 실제 환경은 ECC 6.0 / SAP_BASIS 700이며 초기 확인에는 SP0041, Unicode, Windows 11, PowerShell·Python 미설치 조건이 등장합니다.

## 학습의 네 전환점

1. 환경 진단과 첫 추출기: API와 언어·소스 읽기·내부 INCLUDE 범위를 실행 결과로 수정했습니다.
2. 다양한 패키지와 웹 자산: ZFI1·ZBUDGET·ZMM6·ZCO3·ZWEB에서 BSP·MIME, 파일명, 인코딩, 폴더 규칙과 제외 정책을 구체화했습니다.
3. 업무 에이전트: GitHub Publish와 Mac Clone 뒤에 코드만으로 부족한 규정·카카오톡·매뉴얼을 업무 지식과 스킬로 분리하고 담당자 피드백을 문서로 남겼습니다.
4. 읽기 전용 DIAG: 비교·활성 근거·문법검사·리포트 해석을 다듬다가 자동 Import·활성화를 제외하고 진단으로 목표를 좁혔습니다.

## 현재 확인 범위

이번 통합은 실제 대화 본문 확보에 관한 업데이트입니다. Export 0.3.18·DIAG 0.4.5 확보 소스의 현재 운영 성공을 새로 검증한 것은 아닙니다. 과거 AI의 “수정했습니다”, 사용자의 실행 결과 보고, 현재 포털에 남은 파일 근거를 구분합니다. 초기의 자동 반영 목표와 최종 읽기 전용 결정은 동일하지 않습니다.

## 대화 확보

공유 화면의 요청 119개·AI 응답 본문 116개를 순서대로 배치했습니다. 응답이 표시되지 않은 13·89·90번째 대화는 별도 안내입니다. 최초 27개 대화쌍을 네 개의 시작 에피소드에 추가하고, 기존 E01~E18 주소는 유지했습니다. 사용자 말풍선은 정중한 교육용 문장이며 AI 본문은 전문입니다. 원문 확인 UI는 제공하지 않고 원천 파일은 보존합니다.

## 학습 방법

구성도에서 SAP·Export를 선택해 처음부터 시작하거나 GitHub·Codex·업무 지식·DIAG·피드백 요소에서 관련 대화로 이동합니다. 각 에피소드에서 대화 기록 → 해설·시행착오 → 따라 하기 순서로 읽고, 자기 업무에 맞는 요청·실행 결과·검증 기준을 작성합니다.
'''
(OUT/'01_PROJECT_CONTEXT.md').write_text(context)
guide=['# 전체 학습 가이드 — 공유 대화 전문 반영','', '각 에피소드는 실제 발화와 별도의 교육 해설·실습으로 구성됩니다.','']
for e in episodes:
    guide += [f'## {e["order"]:02d}. {e["title"]}', '', e['goal'], '',e['commentary_markdown'],'', '### 확인한 결과','',e['outcome_markdown'],'','### 따라 하기','',e['exercise_markdown'],'']
(OUT/'02_LEARNING_GUIDE.md').write_text('\n'.join(guide))
(OUT/'00_README.md').write_text('# 공유 대화 전문 통합\n\n사용자 요청 119개, AI 본문 116개, 본문 없음 안내 3개를 22개 에피소드로 연결했습니다. 최초 목적부터 읽기 전용 DIAG로의 전환까지 포함합니다. 공유 추출 원본은 sources/conversations/20261013-shared, 이전 자료와 첨부는 sources/conversations/20261012-supplement에 보존했습니다.\n')
(OUT/'AI_RESPONSES_FULL.md').write_bytes((SOURCE/'SAP_Package_Conversation_Full.md').read_bytes())
(OUT/'MISSING_RESPONSES.md').write_text('# 공유 화면에 본문이 표시되지 않은 응답\n\n'+ '\n'.join(f'- 대화 {m["pair_number"]:03d} / {m["id"]}: {m.get("visible_status_text") or "표시 문구 없음"}' for m in missing)+'\n\n본문을 임의로 복원하지 않았습니다. 다른 대화방·분기와 첨부 파일 전체를 확보했다는 뜻은 아닙니다.\n')
(OUT/'CHANGELOG.md').write_text('# v1.7.1 · 2026-10-13\n\n- 공유 대화 238개 위치 연결: 요청 119·AI 본문 116·본문 없음 안내 3.\n- 초기 27개 대화쌍을 4개 에피소드로 추가하여 소스 추출 프로젝트는 총 22개 에피소드.\n- 기존 E01~E18 링크와 확보 이미지 유지.\n- 사용자 요청은 별도 교육용 경어체, AI 본문은 전문 보존.\n- 과거 대화 미확보 해설을 현재 확보 범위에 맞춰 수정.\n')

config_path=ROOT/'content/conversations/catalog.json'
config=read(config_path);config['asOf']='2026-10-13'
p=next(p for p in config['projects'] if p['id']==PID)
p.update(sourcePath='content/conversations/export-full',assetSourcePath=str(OLD.relative_to(ROOT)),
         coverageNote='사용자 요청 119개·AI 응답 전문 116개를 확보했습니다. 본문이 표시되지 않는 응답 3곳은 별도 안내합니다.',
         environment='ECC 6.0·SAP_BASIS 700 / SP0041·Unicode·Windows 11에서 시작했습니다. ZHR5부터 여러 패키지로 추출 범위를 넓히고 GitHub·Mac Codex Desktop으로 연결한 과정입니다.',
         supplementEpisode='E00-start',supplementLabel='9월 18일, 최초 목적과 환경 확인부터 읽기',
         integrationNote='이번 공유 대화의 AI 본문은 전문으로 반영했습니다. 과거 답변의 “미확보”는 당시 상태입니다. 별도 DIAG 캡처와 최신 소스 실행 여부는 소급해 일치한다고 보지 않습니다.')
config['preferredNodes']['sap']=[PID,'E00-start'];config['preferredNodes']['export']=[PID,'E00-export']
write(config_path,config)

# Register only new preserved evidence; never rewrite hashes of previous inputs.
files_path=ROOT/'docs/source-files.json';files=read(files_path);known={f['path'] for f in files}
for f in sorted(SOURCE.iterdir()):
    relative=str(f.relative_to(ROOT))
    if f.is_file() and relative not in known:files.append({'path':relative,'bytes':f.stat().st_size,'sha256':hashlib.sha256(f.read_bytes()).hexdigest()})
write(files_path,files)
bundles_path=ROOT/'docs/conversation-source-bundles.json';bundles=read(bundles_path)
archive=ROOT.parent/'transcript-input/SAP_Package_Conversation_Full_20261013.zip'
if not any(b['archive']==archive.name for b in bundles):bundles.append({'archive':archive.name,'bytes':archive.stat().st_size,'sha256':hashlib.sha256(archive.read_bytes()).hexdigest(),'preservedPath':str(SOURCE.relative_to(ROOT))+'/'})
write(bundles_path,bundles)
write(OUT/'integration-map.json',{'pair_by_previous_user_id':pair_by_old,'note':'이전 발화 ID는 보존 원천에서 유지. 게시 순서는 공유 화면의 SHARE ID를 기준으로 한다. 중복 U030/U031은 하나로 표시한다. 초기 27개 요청, 추가 exports 압축 요청, 마지막 전문 보완 요청을 포함한다.','message_count':len(messages),'episode_count':len(episodes)})
print(f'Integrated {len(messages)} positions, {len(episodes)} episodes and {len(edits)} educational prompts.')
