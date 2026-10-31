from pathlib import Path
import difflib
import hashlib
import html
import json

HERE = Path(__file__).resolve().parents[1]
ROOT = HERE.parents[1]
BASE = ROOT / 'exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2'
SOURCES = {
    'F03': BASE / 'Include/LZHR008_2F03.abap',
    'SAVE': BASE / 'Function Module/ZHR_52TM_GET_OVERTIME_SAVE/Source code/ZHR_52TM_GET_OVERTIME_SAVE.abap',
}
for directory in ('originals', 'proposed', 'snippets', 'checks'):
    (HERE / directory).mkdir(exist_ok=True)
changes = []

def change(id, source, start, end, after, title, decision, purpose, details):
    original = SOURCES[source].read_text().splitlines(keepends=True)
    before = ''.join(original[start - 1:end])
    changes.append(dict(id=id, source=source, start=start, end=end,
                        before=before, after=after.strip('\n') + '\n',
                        title=title, decision=decision, purpose=purpose, details=details))

change('F03-01', 'F03', 5534, 5537, '''
* 이번 호출에서 반환할 대휴 상세와 정산금액을 초기화한다.
* 정산금액 전달에 사용하던 임시 DB용 변수는 삭제한다.
  REFRESH pt_zdaeh.
  CLEAR lv_zjorgehamt.

  CLEAR: p_zemcwk_o, p_ztoich_o, p_ztomoh_o, p_zdaeh_o.
''', '이번 호출의 상세와 누계를 초기화',
'신청마다 계산 결과를 독립시킨다. DB 중계용 지역변수 두 개는 더 이상 사용하지 않는다.',
'반환 상세가 반복 호출에서 누적되는 것을 막고, 정산금액 누계를 0부터 시작한다.',
['기존 FORM의 TABLES 인수 PT_ZDAEH를 그대로 사용한다. 새 전역 캐시나 매개변수를 만들지 않는다.',
 'REFRESH는 메모리 내부 테이블을 비우는 명령이다. ZHRDAEHUAMT의 DB 행을 삭제하는 처리가 아니다.',
 '시간외 입력 검사와 기존 출력 플래그 초기화는 유지한다.'])

change('F03-02', 'F03', 5774, 5782, '''
* 이번 계산 결과는 기존 반환 구조와 PT_ZDAEH로 직접 전달한다.
* 신청끼리 공유하는 ZHRDAEHUAMT에는 기록하지 않는다.
* 아래 LT_RESULT 반복문에서 금액과 대휴 상세를 집계한다.
''', '공유 임시 DB에 금액을 쓰지 않음',
'후보 4번은 쓰기와 읽기를 함께 교체한다. 이전 신청의 금액을 현재 신청의 계산 근거로 쓰지 않는다.',
'화면 계산·저장 중단 등에서 임시 DB 금액이 생기고 다음 신청에 읽히는 연결을 제거한다.',
['이 구간은 삭제 대상이다. 오른쪽은 삭제 후 남길 설명 주석이며 새로운 DB 명령이 아니다.',
 'ZTOMO를 만드는 처리, 날짜 경계 분리, 8+2 시간 분할과 NORM 호출은 그대로 둔다.',
 '테이블 정의나 기존 잔존 행을 삭제하지 않는다. SAVE-04/05의 조회 제거와 반드시 함께 적용한다.'])

change('F03-03', 'F03', 5844, 5861, '''
* 대휴 상세는 같은 계산 행을 한 번만 반환한다.
* 두 조건이 모두 맞아도 APPEND는 한 번만 실행한다.
    IF ls_result-zdaeh EQ 'X' OR lv_ngt EQ 'Y'.
      APPEND ls_result TO pt_zdaeh.
    ENDIF.

* 신청 전체의 정산금액을 원래 계산 행에서 합산한다.
* 대휴 상세에 포함되지 않은 다른 날짜의 기여분도 더한다.
* 뒤의 기존 반올림 및 * 100 반환 처리는 그대로 사용한다.
    ADD ls_result-zjorgehamt TO lv_zjorgehamt.
''', '중복 APPEND 제거 + 신청 전체 금액 합산',
'8시간과 2시간이라는 서로 다른 계산 구간은 유지한다. 동일한 행이 두 조건으로 반복 추가되는 것만 없앤다.',
'상세 금액의 이중 합산과 마지막 행만 전체 JORGEH가 되는 문제를 함께 막는다.',
['기존 두 APPEND 조건의 합집합을 OR로 표현한다. 어느 조건에도 맞지 않던 행을 새로 상세에 넣지 않는다.',
 '전체 합계는 PT_ZDAEH가 아니라 LT_RESULT의 각 원행에서 한 번씩 구한다. 3+2 합산 대휴처럼 한 날짜가 상세에서 빠질 수 있는 경우도 포함한다.',
 'L5906–5918의 기존 반올림과 출력 단위 변환은 유지한다. NORM의 0.5/1.5배 계산은 변경하지 않는다.'])

change('SAVE-01', 'SAVE', 59, 62, '''
      c_zdaeh          = c_zdaeh.    " 대휴

* 계산 오류일 때는 기존 오류 코드와 문구를 호출자에게 돌려준다.
* 실패한 계산값을 새 정산금액으로 저장하지 않는다.
  IF lv_code+0(1) EQ 'E'.
    e_code = lv_code.
    e_text = lv_text.
    RETURN.
  ENDIF.

  MOVE-CORRESPONDING is_zthrbs01 TO ls_zthrbs01.
''', '정상 계산 결과만 저장 단계로 전달',
'새 금액 복사는 정상 계산을 전제로 한다. 계산 함수가 반환한 기존 E 코드와 문구를 그대로 사용한다.',
'계산 실패 후 이전 값이나 초기값을 새 계산 결과처럼 저장하는 것을 막는다.',
['설계 구체화 과정에서 추가한 최소 보완이다. 원본은 LV_CODE/LV_TEXT를 받지만 이 지점에서 E를 확인하지 않는다.',
 '새 오류 번호·메시지·팝업을 만들지 않는다. 기존 웹/관리자 호출자가 확인하는 E_CODE/E_TEXT에 그대로 반환한다.',
 '뒤의 키 설정과 DB 변경보다 먼저 반환한다. W/I/S의 기존 흐름은 바꾸지 않는다.',
 'F05 내부의 개별 재계산 오류 전달은 이번 두 소스 수정 밖의 기존 확인 사항이며, 이 구간만으로 모든 오류 경로를 검증했다고 주장하지 않는다.'])

change('SAVE-02', 'SAVE', 75, 78, '''
         ls_overtime_data-zs_money    TO ls_zthrbs01-zs_money,
         ls_overtime_data-zd_money    TO ls_zthrbs01-zd_money,
* 현재 신청의 새 정산금액도 복사한다. 정상 계산값 0도 반영한다.
         ls_overtime_data-jorgeh      TO ls_zthrbs01-jorgeh,
         ls_overtime_data-zmoney      TO ls_zthrbs01-zmoney,
         ls_overtime_data-zdaeh       TO ls_zthrbs01-zdaeh,
''', '새 JORGEH를 기존 복사 목록에 포함',
'비휴휴의 사전계산 여부와 배율은 유지한다. 계산한 값과 최종 저장할 값을 일치시킨다.',
'6시간으로 수정해 새 금액이 60,000원이면 저장 구조도 60,000원으로 교체한다.',
['기존 MOVE 목록 안에 한 항목을 넣는다. 새 JORGEH가 0인지 여부로 복사를 생략하지 않는다.',
 'ES_OVERTIME_DATA-JORGEH는 이미 기존 출력 단위로 변환된 값이므로 여기서 다시 *100하지 않는다.',
 '웹 신규·수정은 F06에서도 복사하지만, 공통 SAVE가 자신의 재계산 결과를 반영하도록 한다. 관리자에 계산을 복제하지 않는다.'])

change('SAVE-03', 'SAVE', 116, 150, '''
* 날짜 묶음 수와 실제 대휴 발생일 수를 구분한다.
* 기존 상세 구조를 사용하므로 DDIC나 함수 인수 추가가 없다.
  DATA: lt_zdaeh_day TYPE TABLE OF zshr0121,
        ls_zdaeh_day TYPE zshr0121,
        lv_daeh_days TYPE i.

  REFRESH lt_zdaeh_day.
  CLEAR: ls_zdaeh_day, lv_daeh_days.

* 토8 / 일6 / 토2를 토8 / 토2 / 일6 순서로 정렬한다.
  SORT lt_zdaeh BY datum zbegtm zendtm.

  LOOP AT lt_zdaeh INTO ls_zdaeh.
    IF ls_zdaeh_day-datum IS INITIAL.
* 첫 구간의 시작시각과 기존 휴게정보를 보관한다.
      MOVE ls_zdaeh TO ls_zdaeh_day.

    ELSEIF ls_zdaeh_day-datum EQ ls_zdaeh-datum.
* 같은 날짜의 종료시각은 가장 늦은 시각을 사용한다.
      IF ls_zdaeh-zendtm GT ls_zdaeh_day-zendtm.
        ls_zdaeh_day-zendtm = ls_zdaeh-zendtm.
      ENDIF.

* 금액만 더한다. 날짜나 다른 숫자 필드를 함께 더하지 않는다.
      ADD ls_zdaeh-zjorgehamt TO ls_zdaeh_day-zjorgehamt.
      IF ls_zdaeh-zdaeh EQ 'X'.
        ls_zdaeh_day-zdaeh = 'X'.
      ENDIF.

    ELSE.
* 날짜가 바뀌면 앞 날짜를 확정하고 다음 날짜를 시작한다.
      APPEND ls_zdaeh_day TO lt_zdaeh_day.
      MOVE ls_zdaeh TO ls_zdaeh_day.
    ENDIF.
  ENDLOOP.

* 마지막 날짜는 반복문이 끝난 뒤 한 번 추가한다.
  IF ls_zdaeh_day-datum IS NOT INITIAL.
    APPEND ls_zdaeh_day TO lt_zdaeh_day.
  ENDIF.

  lt_zdaeh[] = lt_zdaeh_day[].

* 이틀 근무라도 실제 대휴는 한 개일 수 있다.
  LOOP AT lt_zdaeh INTO ls_zdaeh WHERE zdaeh EQ 'X'.
    ADD 1 TO lv_daeh_days.
  ENDLOOP.

* 기존 1일 / 2일 저장 분기에는 날짜 묶음 수를 사용한다.
  lv_zdaeh_c = LINES( lt_zdaeh ).
''', '날짜별 묶음과 정산금액 집계',
'기존 날짜별 저장 분기를 재사용한다. 금액 합계와 실제 대휴 발생일 수를 분리해 판단한다.',
'토→일→토를 세 묶음으로 세는 문제를 없애고, 토요일의 8시간분과 2시간분 금액을 함께 보관한다.',
['AT END OF DATUM의 인접 순서에 맡기지 않고 날짜를 직접 비교한다. 초급자가 첫 행·같은 날짜·다음 날짜를 순서대로 읽을 수 있도록 작성했다.',
 '첫 시작시각·기존 휴게정보를 보관하고 최대 종료시각을 사용한다. 상세의 시간 필드를 COLLECT하지 않으며 기존 F05 재계산을 유지한다.',
 'LV_ZDAEH_C는 저장할 날짜 묶음 수, LV_DAEH_DAYS는 대휴표시 X인 날짜 수다. 두 값을 혼용하지 않는다.',
 'F03-03의 중복 APPEND 제거와 함께 적용해야 한다. 같은 날짜라는 이유로 토8 또는 토2 원행을 삭제해서는 안 된다.'])

change('SAVE-04', 'SAVE', 163, 170, '''
* 한 날짜 묶음에 저장하는 건은 이번 신청의 전체 금액을 사용한다.
* 합산 대휴의 다른 날짜 기여분도 전체 금액에 포함되어 있다.
* 임시 DB를 조회하지 않으며 이전 신청의 값으로 대체하지 않는다.
    ls_zthrbs01-jorgeh = ls_overtime_data-jorgeh.
''', '한 묶음 저장: 이번 신청의 전체 금액 사용',
'대휴 하나에 귀속되는 금액은 시작일의 임시 DB 한 행이 아니라 이번 신청의 전체 계산값으로 정한다.',
'합산형의 다른 날짜 기여분과 익일에 발생한 대휴 금액을 누락하지 않고 전달한다.',
['기존 대휴 발생일·사용기간 설정과 APPEND 위치는 유지한다.',
 '기존 SELECT SINGLE과 사용 후 DELETE를 모두 제거한다. DB 조회 실패 시 이전 값이 남는 분기도 사라진다.',
 '계산값 0은 그대로 저장한다. 0일 때 예전 JORGEH를 되살리는 fallback은 추가하지 않는다.'])

change('SAVE-05', 'SAVE', 206, 213, '''
* F05의 하루별 재계산이 끝난 뒤 정산금액을 최종 설정한다.
* 원래 양일 계산에서 나온 이번 신청의 금액을 사용한다.
    CLEAR ls_zthrbs01-jorgeh.

    IF ls_zdaeh-zdaeh EQ 'X'.
      IF lv_daeh_days EQ 1.
* 실제 대휴가 하나이면 전체 정산금액을 그 대휴에 귀속한다.
        ls_zthrbs01-jorgeh = ls_overtime_data-jorgeh.
      ELSE.
* 대휴가 둘이면 해당 날짜의 합계만 저장한다.
* 상세 금액에는 기존 저장 단위 변환 * 100을 한 번 적용한다.
        ls_zthrbs01-jorgeh = ls_zdaeh-zjorgehamt * 100.
      ENDIF.
    ENDIF.
''', '두 묶음 저장: 발생 대휴별로 최종 금액 배분',
'총액을 두 행에 반복 복사하지 않는다. 대휴 하나이면 해당 발생일에 총액을, 둘이면 각 날짜의 합계를 넣는다.',
'F05의 단일일 재계산 0이나 기존 상속값이 원래 양일 계산금액을 지우지 않도록 한다.',
['기존 MOVE-CORRESPONDING LS_ZTHRBS01_D 이후, 기존 상태 처리와 MODIFY ZTHRBS01 이전의 같은 위치를 사용한다.',
 '대휴가 아닌 날짜에는 전체 정산금액을 복사하지 않도록 먼저 0으로 초기화한다.',
 '이 루프의 LS_ZDAEH는 SAVE가 보관한 원래 계산 상세다. F05 내부에서 쓰는 별도 지역 계산 결과와 구별한다.',
 'F05의 대휴표시·발생 판정·실비 재계산은 수정하지 않는다. 특히 3+2 합산형의 분할 후 표시와 실비까지 포함한 전체 SAP 결과는 별도 실행 확인이 필요하다.'])

def create_candidates():
    for name, path in SOURCES.items():
        data = path.read_bytes()
        (HERE / 'originals' / path.name).write_bytes(data)
        original = data.decode('utf-8').splitlines(keepends=True)
        result = []
        cursor = 0
        for c in [c for c in changes if c['source'] == name]:
            result.extend(original[cursor:c['start'] - 1])
            c['after_start'] = len(result) + 1
            lines = c['after'].splitlines(keepends=True)
            result.extend(lines)
            c['after_end'] = len(result)
            cursor = c['end']
            (HERE / 'snippets' / (c['id'] + '.abap')).write_text(c['after'])
        result.extend(original[cursor:])
        (HERE / 'proposed' / path.name).write_text(''.join(result))
        patch = ''.join(difflib.unified_diff(original, result,
                    fromfile='originals/' + path.name, tofile='proposed/' + path.name))
        (HERE / (name + '.patch')).write_text(patch)
    (HERE / 'changes.json').write_text(json.dumps(changes, ensure_ascii=False, indent=2) + '\n')

def esc(s):
    return html.escape(str(s), quote=True)

def code_pane(c, side):
    lines = c[side].splitlines()
    other = c['after' if side == 'before' else 'before'].splitlines()
    changed = set()
    for op, i, j, _, _ in difflib.SequenceMatcher(None, lines, other).get_opcodes():
        if op != 'equal':
            changed.update(range(i, j))
    start = c['start'] if side == 'before' else c['after_start']
    label = '수정 전 · 원본' if side == 'before' else '수정 후 · 제안'
    rows = ''.join(f'<div class="code-line {"changed" if i in changed else ""}"><span class="ln" aria-hidden="true">{start+i}</span><code>{esc(line) or " "}</code></div>' for i, line in enumerate(lines))
    return f'''<div class="code-pane {side}"><div class="pane-head"><b>{label}</b><span>L{start}–{start+len(lines)-1}</span><button class="copy" data-copy="{c['id']}:{side}">코드 복사</button></div><div class="code-scroll" tabindex="0" aria-label="{c['id']} {label}">{rows}</div></div>'''

def render():
    validation_file = HERE / 'checks/validation.json'
    validation = json.loads(validation_file.read_text()) if validation_file.exists() else {}
    tests = json.loads((HERE/'checks/scenarios.json').read_text()) if (HERE/'checks/scenarios.json').exists() else []
    grammar = json.loads((HERE/'checks/grammar.json').read_text()) if (HERE/'checks/grammar.json').exists() else {}
    status = '로컬 검사 완료 · SAP 미검증' if validation.get('status') == 'PASS' else '검토용 제안 코드 · SAP 미검증'
    cards = []
    for c in changes:
        file = SOURCES[c['source']].name
        cards.append(f'''<section class="change-card" id="{c['id']}" data-source="{c['source']}">
          <div class="section-kicker">{c['source']} <span>{c['id']}</span></div>
          <h2>{esc(c['title'])}</h2><p class="location">{file} · 원본 L{c['start']}–{c['end']} 전체 구간 교체</p>
          <div class="rationale"><div><h3>의사결정</h3><p>{esc(c['decision'])}</p></div><div><h3>수정 목적</h3><p>{esc(c['purpose'])}</p></div></div>
          <div class="compare">{code_pane(c,'before')}{code_pane(c,'after')}</div>
          <div class="explain"><h3>적용 방법과 상세 설명</h3><ul>{''.join('<li>'+esc(x)+'</li>' for x in c['details'])}</ul></div>
        </section>''')
    toc = ''.join(f'<a href="#{c["id"]}" data-nav="{c["id"]}"><span>{c["id"]}</span>{esc(c["title"])}</a>' for c in changes)
    summary = ''.join(f'<tr><td><a href="#{c["id"]}" data-nav="{c["id"]}">{c["id"]}</a></td><td>{esc(c["title"])}</td><td>{esc(c["purpose"])}</td></tr>' for c in changes)
    test_rows = ''.join(f'<tr><td>{esc(t["id"])}</td><td>{esc(t["name"])}</td><td>{esc(t["expected_label"])}</td><td><span class="pass">{esc(t["status"])}</span></td></tr>' for t in tests)
    proof_rows = ''.join(f'<tr><td>{esc(name)}</td><td class="hash">{hashlib.sha256(path.read_bytes()).hexdigest()}</td></tr>' for name,path in SOURCES.items())
    payload = json.dumps({c['id']:{'before':c['before'],'after':c['after']} for c in changes},ensure_ascii=False).replace('<','\\u003c')
    css=(HERE/'tools/report.css').read_text()
    js=(HERE/'tools/report.js').read_text()
    document=f'''<!doctype html><html lang="ko"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>휴휴 대휴 JORGEH — 수정 전후 비교 보고서</title><style>{css}</style></head><body>
    <header class="topbar"><a class="brand" href="#top">ZHR5 <span>개발 검토</span></a><nav><a href="#decision">변경 범위</a><a href="#comparison">코드 비교</a><a href="#validation">검증·유의점</a></nav><button id="print">인쇄 / PDF</button></header>
    <main id="top"><section class="hero"><div class="eyebrow">CHANGE REVIEW / 2026.10.31 / SRC-17 · SRC-25</div><h1>휴휴 대휴 정산금액<br><span>수정 전후 비교 보고서</span></h1><p class="lead">기존 시간 분할과 지급 산식은 유지하고,<br>이번 신청의 계산금액을 각 대휴의 JORGEH에 정확히 전달합니다.</p><div class="badges"><span>두 소스 · 8개 비교 구간</span><span>SAP_BASIS 700 대상</span><span>한글 주석 · 구간별 복사</span><span class="state">{status}</span></div><div class="preserved"><b>원본 보존</b><p>exports의 원본 ABAP·DDIC·manifest·baseline은 변경하지 않았습니다. 이 문서와 별도 proposed 사본은 검토용 제안이며 SAP 반영·활성화 결과가 아닙니다.</p></div></section>
    <section class="paper" id="decision"><div class="section-kicker">01 / 변경 범위와 의사결정</div><h2>계산 방식은 유지하고 금액 전달을 고칩니다</h2>
    <div class="scope-grid"><div class="scope-card keep"><h3>그대로 유지</h3><p>① 정산 확정·취소<br>② 8+2 등의 기존 시간 분할<br>⑤ 비휴휴 사전계산 산식<br>⑥ 시차 B 산식·정책 확인 상태</p></div><div class="scope-card edit"><h3>이번에 보완</h3><p>③ 날짜 묶음과 금액 합계<br>④ 이전 신청의 임시 금액 혼입<br>⑤ 새 계산값의 저장 구조 반영<br>계산 오류 시 기존 E 코드 반환</p></div></div>
    <p>분할 전후 휴일실비 합계가 같다는 사실만으로 JORGEH 저장도 안전해지는 것은 아닙니다. 정산금액을 합산하기 전에 임시 DB에서 덮어쓰면 앞 구간을 잃습니다. 따라서 <strong>분할된 원행을 그대로 유지한 채 중복 전달만 없애고, 금액을 메모리로 직접 전달</strong>합니다.</p>
    <div class="flow"><div><b>F03</b><span>원행별 계산 결과<br>전체 J + 상세 J</span></div><i>→</i><div><b>GET_OVERTIME_DATA</b><span>기존 반환 구조<br>인터페이스 유지</span></div><i>→</i><div><b>GET_OVERTIME_SAVE</b><span>날짜별 집계<br>발생 대휴에 귀속</span></div><i>→</i><div><b>ZTHRBS01</b><span>이번 계산의<br>JORGEH 저장</span></div></div>
    <p class="note">실제 코드 변경 지점은 F03와 SAVE 두 곳입니다. GET_DATA의 T_ZDAEH에는 ZJORGEHAMT가 이미 있고, ES_OVERTIME_DATA에는 전체 JORGEH가 있습니다. 새 함수·DB 테이블·DDIC·함수 인수를 추가하지 않습니다. 기존 TABLES 상세를 정리한 뒤 재사용합니다.</p>
    <div class="table-wrap"><table><thead><tr><th>구간</th><th>변경 내용</th><th>목적</th></tr></thead><tbody>{summary}</tbody></table></div>
    <h3>수정 전후 동작 비교</h3><div class="table-wrap"><table><thead><tr><th>확인 항목</th><th>수정 전</th><th>수정 후 목표</th></tr></thead><tbody>
    <tr><td>토8 → 일6 → 토2</td><td>인접한 날짜 묶음으로 세면 3건이 되어 기존 2일 저장 분기를 벗어날 수 있음</td><td>토8+토2 / 일6의 두 날짜로 집계하고 금액을 각 대휴에 배분</td></tr>
    <tr><td>같은 계산 행의 중복 반환</td><td>대휴X와 특근 상세 조건을 모두 만족하면 같은 행을 두 번 APPEND</td><td>두 조건을 OR로 묶어 원행을 한 번만 반환. 서로 다른 8시간/2시간 행은 유지</td></tr>
    <tr><td>이전 신청의 임시금액</td><td>사번·날짜로 임시 DB를 쓰고 조회하여 현재 신청과 무관한 잔존값이 섞일 수 있음</td><td>현재 호출의 메모리 결과만 전달. 이전 DB 행을 읽거나 새로 쓰지 않음</td></tr>
    <tr><td>새 JORGEH 복사</td><td>공통 SAVE의 복사 목록에 빠져 있어 입력 구조의 이전 값에 의존할 수 있음</td><td>현재 정상 계산값으로 교체. 새 값이 0이어도 복사</td></tr>
    <tr><td>첫 계산 함수의 E 반환</td><td>LV_CODE를 받아도 저장 직전에 해당 E를 전달하는 검사가 없음</td><td>기존 오류 코드·문구를 호출자에게 반환하고 저장 단계에 진입하지 않음</td></tr>
    </tbody></table></div></section>
    <section class="paper" id="example"><div class="section-kicker">02 / 결과를 판단하는 기준</div><h2>세 계산 행을 두 대휴에 빠짐없이 배분</h2><p>설명용 단가 10,000원, 휴게 반영 후 토요일 10시간·일요일 6시간, 양일 대휴 발생을 가정합니다. 실제 단가나 운영 입력을 재현한 결과가 아닙니다.</p>
    <div class="table-wrap"><table><thead><tr><th>계산 행</th><th>휴일실비 — 유지</th><th>사전 정산금액</th><th>수정 후 귀속 목표</th></tr></thead><tbody><tr><td>토요일 앞 8시간</td><td>40,000원</td><td>80,000원</td><td rowspan="1">토요일 금액에 포함</td></tr><tr><td>일요일 6시간</td><td>30,000원</td><td>60,000원</td><td>일요일 대휴 60,000원</td></tr><tr><td>토요일 뒤 2시간</td><td>10,000원</td><td>20,000원</td><td>토요일 금액에 포함</td></tr><tr class="total"><td>합계</td><td>80,000원</td><td>160,000원</td><td>토요일 100,000원 + 일요일 60,000원</td></tr></tbody></table></div>
    <div class="rationale"><div><h3>수정 전의 위험</h3><p>임시 DB는 토요일 80,000원을 20,000원으로 덮어쓸 수 있습니다. 날짜 묶음도 토→일→토를 세 건으로 셀 수 있습니다. 최종 오류 금액은 저장 분기에 따라 달라지므로 하나로 단정하지 않습니다.</p></div><div><h3>수정 후의 기준</h3><p>전체 금액은 원행 합계, 날짜별 금액은 중복 없는 상세 합계입니다. 대휴 하나는 전체 금액, 대휴 둘은 각 날짜 금액을 저장합니다. 전체 160,000원을 양쪽에 반복 복사하지 않습니다.</p></div></div>
    <div class="note"><strong>금액 단위:</strong> 상세의 ZJORGEHAMT는 기존 계산 단위이고, 출력 구조의 JORGEH는 F03에서 변환한 값입니다. 전체 출력값은 그대로 복사하며, 날짜별 상세를 저장할 때만 기존 <code>* 100</code>을 한 번 적용합니다. 외부에서 원화 값에 임의로 다시 ×100 또는 ÷100을 적용하라는 뜻이 아닙니다.</div></section>
    <section id="comparison"><div class="comparison-title"><div><div class="section-kicker">03 / 수정 구간 좌우 비교</div><h2>원본 위치를 확인하고 구간별로 교체</h2></div><div class="filters" role="group" aria-label="소스 필터"><button class="active" data-filter="all" aria-pressed="true">전체 8</button><button data-filter="F03" aria-pressed="false">F03 · 3</button><button data-filter="SAVE" aria-pressed="false">SAVE · 5</button></div></div><p class="note">왼쪽은 현재 로컬 원본에서 직접 추출한 코드입니다. 오른쪽은 해당 구간 전체를 대체하는 제안입니다. 줄번호는 복사에 포함되지 않습니다. 수정 전 줄번호로 위치를 찾고, 실제 적용은 각 소스의 뒤 구간부터 하거나 문맥을 확인해 진행합니다. <strong>8개 구간은 함께 검토·적용하는 한 변경안</strong>입니다.</p><details class="toc"><summary>8개 비교 구간 바로가기</summary><div>{toc}</div></details>{''.join(cards)}</section>
    <section class="paper" id="validation"><div class="section-kicker">04 / 검증 범위와 적용 메모</div><h2>로컬 검증과 SAP 검증을 구분합니다</h2>
    <div class="validation-grid"><div><b>{len(tests)}</b><span>조건부 흐름 모형 사례</span></div><div><b>{'PASS' if grammar.get('status')=='PASS' else '대기'}</b><span>ABAP v700 로컬 문법 파서</span></div><div><b>{validation.get('protected_file_count','확인 중')}</b><span>원본 파일 해시 대조</span></div><div><b>NOT RUN</b><span>SAP 구문검사·실행·활성화</span></div></div>
    <p>로컬 문법 파서는 수정할 FORM과 함수의 문법을 v700으로 확인합니다. 실제 SAP DDIC·표준 함수·권한·잠금·COMMIT 동작을 검증하는 도구가 아닙니다. 아래 사례는 계산 행을 입력한 Python 흐름 모형이며 ABAP 자체나 DAILY/F05/SAP DB를 실행한 결과가 아닙니다.</p>
    <div class="table-wrap"><table><thead><tr><th>ID</th><th>조건부 사례</th><th>확인한 금액·구조 목표</th><th>모형</th></tr></thead><tbody>{test_rows}</tbody></table></div>
    <div class="attention"><h3>SAP에서 추가로 확인할 항목</h3><ul><li>실제 시간대·휴게·상수로 만들어진 계산 행과 대휴 표시가 모형의 전제와 같은지 확인합니다.</li><li><strong>3+2 합산형:</strong> 원래 양일 계산의 금액 전달은 보완하지만, F05가 하루씩 재계산할 때의 대휴 표시·발생일·실비까지 바꾸지는 않습니다. 최종 저장 행이 실제 정산 대상 대휴로 남는지는 실행 확인이 필요합니다.</li><li>F05 내부 개별 재계산의 오류 전달, 기존 저장·승인 상태와 동시 처리·키 처리도 운영 환경에서 확인해야 합니다. 이번 오류 가드는 첫 GET_DATA의 E 반환을 전달하는 범위입니다.</li><li>통상 웹 신규/수정과 관리자 저장에서 현재 금액·정상 0·합산1개·양일2개를 대조합니다. 선택 CW의 별도 생성 경로와 실제 보정 대상의 연결은 아직 미확인입니다.</li><li>ZHRDAEHUAMT의 기존 행은 일괄 삭제하지 않습니다. 이번 수정 경로는 읽고 쓰지 않으며, 미추출 외부 패키지 소비자는 별도 확인 대상입니다.</li></ul></div>
    <h3>유지하는 소스와 구현 관례</h3><p>DAILY의 시간 분할, NORM의 배율·대휴 계산, ZRPTH415F01의 정산 확정/취소, F05의 시간·실비 재계산, F06의 기존 웹 복사, 관리자 화면은 변경하지 않습니다. 기존 함수·반환 구조·분기를 재사용하고 새 메시지나 전역 캐시를 만들지 않습니다. 코드는 선언식 DATA, IF, LOOP, SORT, ADD, MOVE, REFRESH 등으로 작성했습니다.</p>
    <h3>원본과 제안 사본</h3><p>현재 원본은 SRC-17(2026-10-22 KSP/300) 추출을 바탕으로 한 로컬 작업본입니다. F03의 앞부분에는 기존 SRC-18 근태 변경이 있으며 이번 비교 구간과 별개입니다. 이 보고서 작성 중 원본에는 어떤 변경도 반영하지 않았습니다. SAVE 본문과 U39 중복 추출본도 원본 상태로 유지했습니다.</p><div class="table-wrap"><table><thead><tr><th>원본</th><th>SHA-256</th></tr></thead><tbody>{proof_rows}</tbody></table></div>
    <p class="note">보고서는 오프라인에서 열 수 있으며 외부 폰트·CDN·추적 스크립트를 사용하지 않습니다. 각 복사 버튼은 현재 선택한 코드 구간만 복사합니다. 지원되지 않는 환경에서는 코드 선택 안내로 전환합니다.</p></section>
    <footer><b>ZHR5 · JORGEH 변경 비교</b><span>원본 미반영 · 제안 코드 · 담당자 및 SAP 검증 대기</span></footer></main><div class="toast" id="toast" role="status" aria-live="polite"></div><script id="code-data" type="application/json">{payload}</script><script>{js}</script></body></html>'''
    (HERE/'report.html').write_text(document)

if __name__ == '__main__':
    create_candidates()
    if (HERE/'tools/report.css').exists():
        render()
    print(json.dumps({'changes':len(changes),'report':str(HERE/'report.html')},ensure_ascii=False))
