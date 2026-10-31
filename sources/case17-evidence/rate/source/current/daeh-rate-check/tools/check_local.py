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
# 과거 100배 금액 가정은 사용자 SAP 표본에 의해 철회한다.
code = '\n'.join(line.split('"')[0] for line in source.splitlines()
                 if not line.startswith('*'))
assert not re.search(r'^\s*(UPDATE|DELETE|INSERT|MODIFY|COMMIT|ROLLBACK)\b',
                     code, re.M | re.I)
for clause in ["rdate BETWEEN gv_from AND gv_to", "state = '3'",
               "zdaeh = 'Y'", "zsourflex = 'S'", "zsourflex = space",
               "gs_out-amount = gs_source-zd_money.",
               "gs_out-settle = gs_source-jorgeh.",
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
# 실제 소스의 금액 대입문을 읽어 표본 입력을 계산한다.
# 임의 변환을 다시 넣으면 이 검사가 실패한다. ABAP 런타임 검사는 아니다.
import ast

def eval_amount_assignment(abap, target, input_value):
    match = re.search(r'gs_out-' + target + r'\s*=\s*gs_source-[a-z_]+([^.]*)\.', abap)
    assert match, target
    expression = input_value + match.group(1)
    tree = ast.parse(expression, mode='eval')
    def calculate(node):
        if isinstance(node, ast.Expression):
            return calculate(node.body)
        if isinstance(node, ast.Constant):
            return D(str(node.value))
        if isinstance(node, ast.BinOp):
            left, right = calculate(node.left), calculate(node.right)
            if isinstance(node.op, ast.Div): return left / right
            if isinstance(node.op, ast.Mult): return left * right
        raise AssertionError('지원하지 않는 금액 대입식')
    return calculate(tree)

money_old = (root / 'revisions/20261030-money-unit'
             / 'ZHR_DAEH_RATE_CHECK.abap').read_text()
assert eval_amount_assignment(money_old, 'amount', '23100') == D('231')
assert eval_amount_assignment(source, 'amount', '23100') == D('23100')
assert eval_amount_assignment(source, 'amount', '25410') == D('25410')
assert eval_amount_assignment(source, 'settle', '46200') == D('46200')
assert eval_amount_assignment(source, 'settle', '0') == D('0')
# 실제 사용자 사례는 양쪽 배수 공통이다. 기준월 일치=Y, 판별불가 유지.
a = eval_amount_assignment(source, 'amount', '23100')
assert a % 2100 == 0 and a % 2310 == 0
assert a == D('8400') * D('0.5') * D('5.5')
# 소스 CASE에서 PERSK별 단가 대입을 읽어 정책 표와 비교한다.
rate_case = re.search(r'CASE gs_out-persk\.(.*?)ENDCASE\.', source, re.S).group(1)
branches = re.findall(r"WHEN (.*?)\.(.*?)(?=\n    WHEN|\Z)", rate_case, re.S)
def rates_from_source(persk):
    values = {'p_old': D('8400'), 'p_new': D('9240'),
              'gc_special_rate': D('5400')}
    rates = {'old_rate': values['p_old'], 'new_rate': values['p_new']}
    for condition, body in branches:
        if persk in re.findall(r"'([^']+)'", condition):
            for target, symbol in re.findall(r'gs_out-(old_rate|new_rate) = (\w+)\.', body):
                rates[target] = values[symbol]
    return rates['old_rate'], rates['new_rate']

persk_cases = 0
for persk in ['E1', 'E4', 'E5', 'E6', 'E7']:
    old, new = rates_from_source(persk)
    assert (old, new) == (D('5400'), D('9240')), persk
    assert old / 4 == D('1350') and new / 4 == D('2310')
    assert D('21600') % (old / 4) == 0  # 8월 8시간 및 9월 구단가 후보
    assert D('21600') % (new / 4) != 0
    assert D('21600') / (old / 4) * (new / 4) == D('36960')
    persk_cases += 1
assert rates_from_source('E8') == (D('5400'), D('5400'))
assert rates_from_source('A1') == (D('8400'), D('9240'))
persk_cases += 2
assert source.index('IF gs_out-old_rate = gs_out-new_rate.') < source.index("ELSEIF gs_out-old_ok = 'Y' AND gs_out-new_ok = 'Y'.")
for clause in ['FOR ALL ENTRIES IN gt_source', 'IF gt_source[] IS NOT INITIAL.',
               'AND sprps = space.', 'AND begda <= gs_source-rdate',
               'AND endda >= gs_source-rdate.', 'IF lv_count = 0.',
               'ELSEIF lv_count > 1.', 'PERFORM determine_rates.',
               'IF gv_person_ok IS INITIAL.', 'CONTINUE.',
               'gs_out-old_step = gs_out-old_rate / 4.',
               'gs_out-new_step = gs_out-new_rate / 4.',
               'USING gs_out-amount gs_out-old_step',
               'USING gs_out-amount gs_out-new_step']:
    assert clause in code, clause
# 날짜 경계·누락·중복의 독립 참조 사례. SAP 실행 검사가 아님.
history = [('20260801', '20260831', 'E1'), ('20260901', '99991231', 'E8')]
def valid_history(rows, date):
    return [p for begin, end, p in rows if begin <= date <= end]
assert valid_history(history, '20260831') == ['E1']
assert valid_history(history, '20260901') == ['E8']
assert valid_history(history, '20260731') == []
assert len(valid_history(history + [('20260815', '20260915', 'E4')], '20260831')) == 2
report = {'source_sha256': hashlib.sha256(source.encode()).hexdigest(),
          'decimal_cases': len(cases),
          'persk_source_policy_cases': persk_cases,
          'history_boundary_cases': 4,
          'persk_policy_history_contract': 'PASS (local source/reference checks only)',
          'money_assignment_regression': 'PASS: original 231, corrected 23100; JORGEH preserved', 'arithmetic_and_source_contract': 'PASS',
          'basis700_condition_regression': 'PASS: original rejected, fixed source accepted',
          'basis700_manual_review': 'limited review only; previous PASS did not establish compatibility',
          'abap_grammar_tool': 'NOT_RUN: node/abaplint unavailable in shell',
          'sap_syntax_execution_ddic_authorization': 'NOT_RUN'}
(root / 'verification.json').write_text(json.dumps(report, ensure_ascii=False, indent=2)+'\n')
print(json.dumps(report, ensure_ascii=False, indent=2))
