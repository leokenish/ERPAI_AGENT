# 휴휴 JORGEH 수정 전후 비교 보고서

2026-10-31, SRC-25 후속 요청. **원본을 수정하지 않고** F03와 GET_OVERTIME_SAVE의 제안 코드를 별도 사본으로 작성했다. SAP_BASIS 700을 대상으로 하며 SAP 구문검사·실행·활성화는 수행하지 않았다. 담당자 검토 대기 상태다.

- [HTML 보고서](report.html): 8개 수정 구간의 좌우 비교, 수정 전후 동작 표, 의사결정·목적·한글 주석·구간별 코드 복사. 외부 리소스 없이 오프라인 사용 가능.
- [변경 구간 데이터](changes.json), [F03 패치](F03.patch), [SAVE 패치](SAVE.patch): 원본 줄번호와 수정 구간 대조용. 현재 원본에는 적용하지 않았다.
- `originals/`: 이번 작업 시작 시점의 두 소스 사본. `proposed/`: 문법·문맥 확인용 전체 제안 사본. `snippets/`: 보고서 오른쪽과 동일한 8개 교체 구간. 일부는 기존 MOVE/CALL 문장의 중간 구간이므로 독립 프로그램이 아니다.

## 변경 범위

F03는 호출별 상세 초기화, 동일 원행 중복 반환 방지, 전체 J 합산과 기존 반환값 전달을 담당한다. SAVE는 날짜별 상세 집계, 실제 대휴 수에 따른 금액 귀속, 새 JORGEH 복사, 첫 계산의 E 반환을 담당한다. 공유 임시 DB인 ZHRDAEHUAMT의 쓰기·조회·소비를 제거하고 기존 GET_DATA의 상세/전체 반환을 재사용한다. 기존 DB 행은 삭제하지 않는다.

시간 분할, NORM 산식, 비휴휴 사전계산, B 정책, 확정/취소는 유지한다. F05 재계산도 유지하며, 합산 3+2의 최종 대휴표시·발생일·실비까지 포함한 SAP 동작은 추가 확인 대상이다. 이 보고서의 금액 모형 통과를 전체 업무 처리 정상 판정으로 해석하지 않는다.

## 검증

- [검증 결과](checks/validation.json): exports/ZHR5의 5,077개 파일 해시 보존, 수정 전 발췌 정확성, 제안 사본 재구성 및 정적 계약 검사 PASS.
- [v700 문법 검사](checks/grammar.json): @abaplint/core 2.120.86, 대상 FORM과 함수의 로컬 문법 파서 PASS. SAP DDIC·표준 함수·실행 검증과 구별한다.
- [16개 조건부 모형](checks/scenarios.json): 이미 계산된 행을 입력으로 하는 Python 금액 전달 모형 PASS. 실제 ABAP 실행 결과가 아니다.
- [HTML 검사](checks/html.json): 8개 비교 카드·16개 복사 버튼·소스 필터·화면 폭·외부 요청 검사 PASS. 복사 내용은 Clipboard API/구형 복사 경로를 모의 처리해 문자열을 대조했으며 OS 클립보드를 변경하지 않았다.
- [화면](checks/report-desktop.png), [코드 비교 화면](checks/report-comparison.png), [좁은 화면](checks/report-mobile.png)을 렌더링해 확인했다.

## 재생성 도구

`tools/build_report.py`는 원본을 읽어 이 제안 폴더의 사본·패치·HTML을 생성한다. `tools/check_abap.cjs`는 v700 문법, `tools/verify.py`는 보존·발췌·정적 계약·금액 모형, `tools/check_html.cjs`는 브라우저 동작을 검사한다. Node 도구의 라이브러리 경로는 현재 로컬 환경 기준이다. 원본 해시 기준은 [source-hashes-before.json](source-hashes-before.json)이며 추출 manifest/baseline을 덮어쓰지 않았다.

출처와 이전 논의는 [휴휴 조사 기록](../../knowledge/processes/huhu-jorgeh-investigation.md)의 「최소 로컬 수정 지점 검토」를 따른다. SAVE 본문과 U39 중복 추출본은 모두 원본 그대로이며, 향후 실제 반영 여부는 이 제안 작성과 별개다.
