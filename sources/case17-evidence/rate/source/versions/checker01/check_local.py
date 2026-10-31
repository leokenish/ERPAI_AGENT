"""독립 Decimal 산술 사례 + 소스 계약. ABAP 실행 검사가 아님."""
from decimal import Decimal as D
from pathlib import Path
import hashlib
import json
import re

root = Path(__file__).resolve().parents[1]
source = (root / 'ZHR_DAEH_RATE_CHECK.abap').read_text()
# 금액은 원 단위이며, 실제 인정시간은 입력하지 않는다.
cases = [
    ('8월 정상', '33600', True, False),
    ('9월 정상', '36960', False, True),
    ('9월 구단가 5.5시간', '23100', True, True),
    ('9월 신단가 5.5시간', '25410', False, True),
    ('양쪽 불일치', '25000', False, False),
    ('최소 반시간 구단가', '2100', True, False),
    ('최소 반시간 신단가', '2310', False, True),
    ('원 미만 포함', '2310.01', False, False),
]
for name, amount, old, new in cases:
    a = D(amount)
    assert (a % 2100 == 0) == old, name
    assert (a % 2310 == 0) == new, name
assert D('33600') / 2100 * 2310 - D('33600') == 3360
assert D('36960') / 2310 * 2100 - D('36960') == -3360
assert D('3360000') / 100 == D('33600')
code = '\n'.join(line.split('"')[0] for line in source.splitlines()
                 if not line.startswith('*'))
assert not re.search(r'^\s*(UPDATE|DELETE|INSERT|MODIFY|COMMIT|ROLLBACK)\b',
                     code, re.M | re.I)
for clause in ["rdate BETWEEN gv_from AND gv_to", "state = '3'",
               "zdaeh = 'Y'", "zsourflex = 'S'", "zsourflex = space",
               "gs_source-zd_money / 100", "gs_source-jorgeh / 100",
               "p_old / 4", "p_new / 4", "lv_units = trunc( lv_ratio )",
               "IF gs_source-jorgeh IS NOT INITIAL.",
               "gs_out-difference = gs_out-estimate - gs_out-amount.",
               "AUTHORITY-CHECK OBJECT 'S_TCODE'", "REUSE_ALV_GRID_DISPLAY"]:
    assert clause in code, clause
# 비교문에 계산식을 넣는 이번 오류를 재현하고 재발을 검사한다.
# 문자열/주석을 제거한 뒤 여러 줄 조건문을 문장 단위로 검사한다.
def arithmetic_conditions(abap):
    clean = '\n'.join(line.split('"')[0] for line in abap.splitlines()
                      if not line.startswith('*'))
    clean = re.sub(r"'(?:''|[^'])*'", "''", clean)
    bad = []
    for statement in clean.split('.'):
        if re.match(r'^\s*(IF|ELSEIF|CHECK|WHILE)\b', statement, re.I):
            if re.search(r'\s[+*/-]\s', statement):
                bad.append(statement.strip())
    return bad

old_source = (root / 'revisions/20261030-basis700-condition'
              / 'ZHR_DAEH_RATE_CHECK.abap').read_text()
assert len(arithmetic_conditions(old_source)) == 1, '기존 오류 조건문을 검출해야 함'
assert not arithmetic_conditions(source), arithmetic_conditions(source)
for clause in ['gv_old_check = gv_old_step * 4.',
               'gv_new_check = gv_new_step * 4.',
               'OR gv_old_check <> p_old OR gv_new_check <> p_new.']:
    assert clause in code, clause
assert len(re.findall(r'^FORM ', code, re.M)) == len(re.findall(r'^ENDFORM\.', code, re.M))
report = {'source_sha256': hashlib.sha256(source.encode()).hexdigest(),
          'decimal_cases': len(cases), 'arithmetic_and_source_contract': 'PASS',
          'basis700_condition_regression': 'PASS: original rejected, fixed source accepted',
          'basis700_manual_review': 'limited review only; previous PASS did not establish compatibility',
          'abap_grammar_tool': 'NOT_RUN: node/abaplint unavailable in shell',
          'sap_syntax_execution_ddic_authorization': 'NOT_RUN'}
(root / 'verification.json').write_text(json.dumps(report, ensure_ascii=False, indent=2)+'\n')
print(json.dumps(report, ensure_ascii=False, indent=2))
