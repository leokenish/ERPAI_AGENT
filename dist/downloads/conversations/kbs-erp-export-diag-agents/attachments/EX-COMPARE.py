"""합성 교육 예시: SAP 연결/쓰기 없음. 실제 DIAG 엔진의 대체품이 아님."""
import json
from pathlib import Path


def compare(reference, target):
    r_state, r_text = reference
    t_state, t_text = target
    if 'U' in (r_state, t_state):
        return '미확인'
    if r_state == t_state == 'N':
        return '판정 없음'
    if r_state == 'N' and t_state == 'P':
        return '신규'
    if r_state == 'P' and t_state == 'N':
        return '누락'
    if r_state == t_state == 'P':
        return '변경없음' if r_text.encode('utf-8') == t_text.encode('utf-8') else '수정'
    raise ValueError('알 수 없는 존재 상태')


def main():
    data = json.loads(Path(__file__).with_name('three_way_cases.json').read_text(encoding='utf-8'))
    for case in data['cases']:
        original, extracted, sap = (case[x] for x in ('original', 'extracted', 'sap'))
        actual = [compare(original, extracted), compare(original, sap), compare(sap, extracted)]
        if actual != case['expected']:
            raise AssertionError((case['name'], actual, case['expected']))
        print('PASS:', case['name'], '|', ' / '.join(actual))
    print(f"합성 교육 사례 {len(data['cases'])}개 통과. SAP 실행 검증 결과가 아닙니다.")


if __name__ == '__main__':
    main()
