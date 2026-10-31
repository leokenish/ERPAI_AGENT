"""휴휴 JORGEH 의심 경로의 조건부 산술·상태 전이 모형.

SAP/ABAP 실행기가 아니다. 휴게 반영 후 계산 행을 입력하며 금액은 단가 U의
배수다. DDIC 금액 변환, 시간 산출, 권한, DB 트랜잭션은 재현하지 않는다.
"""
from copy import deepcopy
from decimal import Decimal as D
from itertools import groupby
from pathlib import Path
import hashlib
import json

ROOT = Path(__file__).resolve().parents[2]
OUT = Path(__file__).resolve().parent
FG = ROOT / 'exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2'
PROG = ROOT / 'exports/ZHR5/packages/ZHR5/programs/PROG'
SOURCES = {
    'norm': FG / 'Function Module/ZHR_52TM_CALC_NORM_OT_PAY/Source code/ZHR_52TM_CALC_NORM_OT_PAY.abap',
    'daily': FG / 'Function Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Source code/ZHR_52TM_CALC_WORK_TIME_DAYILY.abap',
    'save': FG / 'Function Module/ZHR_52TM_GET_OVERTIME_SAVE/Source code/ZHR_52TM_GET_OVERTIME_SAVE.abap',
    'f03': FG / 'Include/LZHR008_2F03.abap',
    'f05': FG / 'Include/LZHR008_2F05.abap',
    'f06': FG / 'Include/LZHR008_2F06.abap',
    'settle': PROG / 'ZRPTH415F01/source/ZRPTH415F01.abap',
}


def norm(rows, kind='A'):
    """rows=(날짜, 계산시간, 대휴표시). 비교대·양일 휴일 분기만 모형화."""
    total = sum(D(str(h)) for _, h, _ in rows)
    over = any(D(str(h)) >= D('4.5') for _, h, _ in rows)
    any_daeh = any(flag for _, _, flag in rows)
    dates = [day for day, _ in groupby(row[0] for row in rows)]
    both = kind in ('T', 'D') and len(dates) != 1
    special = kind in ('T', 'D', 'B') and not both
    result = []
    for day, hours, flag in rows:
        h = D(str(hours))
        if not any_daeh:
            paid, j = h * D('1.5'), D(0)
        elif special:
            paid, j = h * (D('.5') if total >= D('4.5') else D('1.5')), D(0)
        elif (total >= D('4.5') and not over) or h >= D('4.5') or flag:
            paid, j = h * D('.5'), h
        else:
            paid, j = h * D('1.5'), D(0)
        result.append({'day': day, 'h': h, 'paid': paid, 'j': j, 'flag': flag})
    return result


def temporary_write(rows):
    table = {}
    for row in rows:
        table[row['day']] = row['j']  # 같은 날짜 MODIFY: 합산하지 않는다.
    return table


def consume(table, rdate, inherited):
    return table.pop(rdate, inherited)


def settlement(rows, used):
    result = deepcopy(rows)
    result.sort(key=lambda r: r['j'] if r['j'] else r['zd'] * 2)
    for index, row in enumerate(result):
        row['j'] = (row['j'] or row['zd'] * 2) if index >= used else D(0)
    return result


results = []


def record(name, observed, expected, meaning):
    assert observed == expected, (name, observed, expected)
    results.append({'id': name, 'observed': observed, 'meaning': meaning, 'model_check': 'PASS'})


# 소스 변경 시 현재 모형을 무비판적으로 재사용하지 않도록 근거 위치도 검사한다.
guards = [('f03', 5850, 'lv_zjorgehamt =  ls_result-zjorgehamt.'),
          ('f03', 5780, 'MODIFY zhrdaehuamt FROM ls_zhrdaehuamt.'),
          ('save', 166, 'datum = ls_zthrbs01-rdate'),
          ('save', 134, 'AT END OF datum.'),
          ('daily', 819, 'APPEND t_day_time.'),
          ('settle', 548, 'ls_tmp-jorgeh = 0.'),
          ('settle', 1664, "SET  jorgeh_txt = ''")]
for key, line, token in guards:
    assert token.casefold() in SOURCES[key].read_text().splitlines()[line-1].casefold()

rows = norm([(0, 3, True), (1, 2, False)])
table = temporary_write(rows)
record('M01_joined_one', consume(table, 0, D(0)), D(3), '합산 필요 5U에 대해 시작일 3U만 회수')
record('M02_leftover', table, {1: D(2)}, '합산 1건 저장 뒤 다음날 2U 잔존')

rows = norm([(0, 2, False), (1, 6, True)])
j = consume(temporary_write(rows), 0, D(6))
record('M03_second_day_only', (j, j or sum(r['paid'] for r in rows)*2), (D(0), D(12)), '일요일 6U 필요; 시작일 0U 회수 후 12U fallback')

rows = norm([(0, 5, True), (1, 5, True)])
record('M04_two_day_control', temporary_write(rows), {0: D(5), 1: D(5)}, '날짜당 한 행인 양일 발생은 임시 금액 합계 보존')

rows = norm([(0, 8, True), (1, 6, True), (0, 2, True)], 'D')
record('M05_same_day_overwrite', temporary_write(rows), {0: D(2), 1: D(6)}, '토요일 10U가 마지막 2U로 덮어써짐; 최종 저장은 M06 분기도 고려')
detail_dates = [r['day'] for r in rows for _ in range(2)]  # 대휴 표시 + lv_ngt Y의 이중 APPEND
groups = [day for day, _ in groupby(detail_dates)]
record('M06_unsorted_group', groups, [0, 1, 0], '실제 날짜 2개인데 인접 그룹 3개: EQ 2 분기 미진입')

new_single = norm([(1, 6, True)])
record('M07_stale_to_single', consume(table, 1, new_single[0]['j']), D(2), '단일일 신규 계산 6U를 남은 임시 2U가 대체')

record('M08_unmapped_fresh', {'inherited': D(8), 'fresh': D(6), 'saved_if_lookup_misses': consume({}, 0, D(8))},
       {'inherited': D(8), 'fresh': D(6), 'saved_if_lookup_misses': D(8)}, '재계산 JORGEH 미복사+조회 실패 시 입력에서 상속된 8U 잔존')

before = [{'id': 'H', 'j': D(6), 'zd': D(6)}, {'id': 'N', 'j': D(0), 'zd': D('3.5')}]
first = settlement(before, 1)
# 확정은 계산 결과를 저장, 취소는 금액은 유지하고 표시만 삭제한다는 전제.
second = settlement(first, 1)
record('M09_cancel_repeat', (sum(r['j'] for r in first), sum(r['j'] for r in second)), (D(7), D(12)),
       '입력·사용개수 불변, 정상 확정/취소 성공 가정: 총 정산 7U→12U')

rows = norm([(0, 6, True), (1, 2, False)], 'B')
record('M10_staggered_branch', ([r['j'] for r in rows], sum(r['paid'] for r in rows)), ([D(0), D(0)], D(4)),
       'B는 lv_zboth 미설정: JORGEH 미산출·양일 모두 0.5. B 업무 예외 확인 필요')

record('M11_non_huhu_output', norm([(0, 6, True)])[0]['j'], D(6), '일반 A 단일 휴일도 계산 출력 J=6U; F06은 휴휴 조건 없이 복사')
rows = norm([(0, 6, True), (1, 2, False)])
record('M12_first_day_control', (rows[-1]['j'], consume(temporary_write(rows), 0, D(0))), (D(0), D(6)),
       '스칼라 마지막값 0U여도 날짜별 회수 6U로 보완됨: 무조건 합산 수정 금지')

report = {'scope': '조건부 Python 산술·상태 전이, SAP/ABAP 미실행',
          'unit': '시간단가 U의 배수; DB/표시 단위 변환 미검증',
          'guards': [{'source': str(SOURCES[k].relative_to(ROOT)), 'line': n, 'token': t} for k,n,t in guards],
          'sources': {k:{'path':str(p.relative_to(ROOT)), 'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for k,p in SOURCES.items()},
          'cases': results, 'sap_execution': 'NOT_RUN'}
(OUT/'scenario-results.json').write_text(json.dumps(report, ensure_ascii=False, indent=2, default=str)+'\n')
print(f'PASS: {len(guards)} source guards; {len(results)} conditional scenarios. SAP NOT_RUN.')
