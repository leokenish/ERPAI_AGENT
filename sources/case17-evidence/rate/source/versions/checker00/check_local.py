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
assert len(re.findall(r'^FORM ', code, re.M)) == len(re.findall(r'^ENDFORM\.', code, re.M))
report = {'source_sha256': hashlib.sha256(source.encode()).hexdigest(),
          'decimal_cases': len(cases), 'arithmetic_and_source_contract': 'PASS',
          'basis700_manual_review': 'PASS (not SAP syntax check)',
          'abap_grammar_tool': 'NOT_RUN: node/abaplint unavailable in shell',
          'sap_syntax_execution_ddic_authorization': 'NOT_RUN'}
(root / 'verification.json').write_text(json.dumps(report, ensure_ascii=False, indent=2)+'\n')
print(json.dumps(report, ensure_ascii=False, indent=2))
