# HR 업무 이해도 검증 질문 후보 20개

대상: 2026-09-21 ZHR5 지식 초안. **질문 후보이며 에이전트 실행·자동 평가 결과가 아니다.** 검증자는 답변의 소스 근거와 확실성 구분을 함께 평가한다. S/D 근거 ID의 원본 상대 경로는 [객체 지도](../../knowledge/hr/object-map.md)에 있다.

공통 채점: 문항당 0–2점, 총 40점. 2점은 기대 요소가 맞고 객체명·원본 상대 경로/코드 위치를 제시하며 한계를 구분한 답변, 1점은 핵심은 맞지만 근거·조건·한계가 빠진 답변, 0점은 사실 오류 또는 미추출 구현을 확정한 답변이다. 운영 실행 성공·법적 적합성·전체 복원을 근거 없이 주장하면 해당 문항은 0점이다. 아직 합격 기준은 정하지 않았다.

| ID | 질문 | 기대 답변 요소와 오답 방지 기준 | 확인 근거 |
| --- | --- | --- | --- |
| E01 | 최초 대상은 ZHR6인데 왜 이번 지식은 ZHR5로 작성했는가? | 폴더·manifest PACKAGES·catalog DEVCLASS가 ZHR5. ZHR6을 분석했다고 말하지 않음 | exports/ZHR5/manifest.xml, catalog/objects.xml; [개요](../../knowledge/hr/overview.md) |
| E02 | catalog 객체 618개, 목록 841행, manifest 파일 2,530개는 각각 무엇을 세는가? | 618은 최상위 catalog 객체, 841은 하위 함수 127·페이지 96 포함 행 수, 2,530은 등록 파일. PARTIAL 542/UNSUPPORTED 72/EXCLUDED 3/FAILED 1을 완전 추출로 해석하지 않음 | catalog/objects.xml, manifest FILES, object-inventory.csv |
| E03 | references.xml만으로 모든 프로그램·함수의 호출 관계를 설명할 수 있는가? | DIRECT_INCLUDE 258건, 내부 root 78/component 155/외부 25. 함수·클래스·동적 호출 전체를 스캔한 결과가 아님 | exports/ZHR5/catalog/references.xml, README.md |
| E04 | ZHCMT_BSP_PA_XX_R9023는 어떤 상태이며 무엇을 추가 확인해야 하는가? | KO→EN 후 FAILED, GOTSTATE 공백, SUBRC=0만으로 성공 아님. 진단 AS4LOCAL=L 등을 근거로 active 정의/API 확인 필요; 원인·삭제 단정 금지 | logs/processing.xml, diagnostic-dd02l.xml; [Q02](../../knowledge/hr/open-questions.md#q02) |
| E05 | 정보형 9021/9023 클래스가 검증하는 규칙을 현재 자료로 설명할 수 있는가? | 클래스 3개 UNSUPPORTED, 본문 미추출. PA9021/9023 정의·일부 직접 쓰기만으로 클래스 검증을 추정하지 않음; MP 본문도 미검토 | catalog/objects.xml; [Q11](../../knowledge/hr/open-questions.md#q11) |
| E06 | 근로유형 0010·0030·0110·0120·0130·0140은 무엇이며 어떤 한계가 있는가? | 통상/교대/4주선택/2주탄력/간주/재량. DDIC 코드 의미이며 운영 적용·현행 사규 전체를 의미하지 않음 | S20 ZD52WKTP1 |
| E07 | ZTHR0106·0107·0110·0120은 업무상 어떻게 구분되는가? | 기간계획/일일계획/실적/월별정산확정. 사번·기간/일자·순번 또는 정산월/주 구간 키 구분. DDIC 관계만으로 외래키 보장 주장 금지 | D03–D06; [객체 지도](../../knowledge/hr/object-map.md) |
| E08 | 계획 화면에서 저장과 상신은 어떻게 나뉘고 어떤 데이터가 전달되는가? | PLAN_WORK_TIME에 R/S/A 등 전달, 0120·02·T_DAILY/T_TOTAL. 상신 동작도 먼저 S 요청 후 성공 callback에서 A. 공통 AJAX 본문 누락을 명시 | S01–S03; [F01](../../knowledge/hr/flows.md#f01) |
| E09 | 계획 상신은 어떤 날짜·시간·결재자 조건에서 거절되는가? | 시작일−ZLIMIT보다 현재일이 늦음, 주차별 필수/계획시간 불일치, 결재자 공백·외부 검사 오류. 주석상 미달과 실제 <> 조건 차이, 운영 ZLIMIT 미확인 | S03 check_plan_approve; Q06–Q07 |
| E10 | 계획을 회수·삭제·초기화할 때 어떤 차이가 있는가? | B는 외부 WF 회수 후 STATE 5, D는 기간 실적 존재 시 중단·승인계획 PA9021 삭제 경로 및 STATE 2, N은 일일계획 삭제 후 저장. 모든 관련 자료 물리 삭제라고 단정 금지 | S02; F01 |
| E11 | 계획 승인 입력은 PA9021에 언제 반영되고 다단계 결재에는 무엇이 불확실한가? | P 분기에서 STATE E 계획 조회. ZSTAT Y일 때 사번·겹치는 기간·유형 0120~0140 PA9021 검사 후 기록. 최종 STATE 조건과 다름; ZORDR/UI/WF 추가 확인 | S05 64–210행; [F02](../../knowledge/hr/flows.md#f02) |
| E12 | ZRPTH401의 미결처리 대상은 무엇이며 P_WKTP=0120으로 유형이 제한되는가? | 유효 ZLIMIT 사용, 시작일이 P_DATE~P_DATE+값−1, 사번 범위, STATE 0/E. P_WKTP는 대상 SELECT에 미사용 | S06; [F03](../../knowledge/hr/flows.md#f03) |
| E13 | ZRPTH401에서 WF 회수가 실패하면 어떻게 되고 완료 건수는 믿을 수 있는가? | 실패 행을 내부 테이블에서 제외, 나머지를 F로 갱신. GV_TOT은 제외 전 집계라 실제 성공 건수와 다를 수 있음. 외부 WF 내부 효과는 미확인 | S06 90–135행 |
| E14 | ZRPTH402의 월 정산금액 처리와 다른 라디오 분기는 어떻게 다른가? | RB1 조회/취소, RB2 월 정산, RB3 미결, RB4 월 합계. RB2 정산일·소급 시작월 검사, 기존 확정 사번 제외, MONTHLY_PAYMENT 호출 | S07–S09; [F04](../../knowledge/hr/flows.md#f04) |
| E15 | 월 지급액 계산에서 확인한 계수와 아직 설명할 수 없는 규칙은 무엇인가? | 연장/야간/휴일/대휴 인수 1.0/0.5/1.5/0.5, 시·분 변환×단가×계수. 시간 집계·단가·소급 전체 및 ROUND 실효 결과는 미검토/추가 확인; 법정 기준 일반화 금지 | S10–S11, S03 set_round_amt; Q09 |
| E16 | 정산 확정은 어디에 어떤 임금유형·날짜·통화로 기록되는가? | PA2010 SUBTY/LGART 8030, BEGDA/ENDDA=PA_ADMDT, KRW, 금액 0 이하 제외. ZTHR0110 정산일·ZTHR0120 확정 결과 연결. 실제 지급 완료와 구별 | S09 confirm_data |
| E17 | 정산 확정이 실패하면 모두 롤백되는가? 취소 시 전표가 있는 건은 어떻게 되는가? | 중간 COMMIT 뒤 ZTHR0120 변경이라 전체 롤백 보장 불가. AWREF 있는 PA2010 건은 취소 대상에서 제외하는 코드, 취소 FORM 명시 COMMIT 없음; 실행 경계 확인 필요 | S09 540–631, 814–923행; Q08 |
| E18 | 시간외 화면의 APPR는 최종 승인인가? 상신 함수는 어떤 필드를 바꾸는가? | APPR는 결재 상신. 저장 후 요청 경로, WF F 호출 성공 시 STATE_TXT 결재중·ZSANGSIN Y·ZNO. GET_OVERTIME_REQUEST가 STATE E를 직접 설정한다고 주장하지 않음 | S12–S15; [F05](../../knowledge/hr/flows.md#f05) |
| E19 | 시간외 저장 함수는 항상 데이터 가공만 하는가? 특수 경로에서 추가로 확인할 것은 무엇인가? | 2일 대휴 분기는 직접 ZTHRBS01 MODIFY, ZHRDAEHUAMT 읽기 후 삭제, 누락 승인 분기. 2차 결재 조건 LS_ZTHRBS01와 입력 LS_DATA 차이·외부 판정·트랜잭션은 확인 필요 | S14–S15; Q10 |
| E20 | PA2010 정산 결과가 FI 전표·지급으로 이어지는 전체 흐름을 지금 확정할 수 있는가? | ZRPTH2012_M 일부의 선택조건·AWREF 갱신만 확인. 8030 결과가 입력 후보라는 것은 추론. 자동 실행 순서·전표·역분개·EDI·지급 전체는 미검토; 추가 FI 범위 필요 | S16–S17; [F06](../../knowledge/hr/flows.md#f06), Q12 |

평가 답변은 이 문서의 기대 요소를 되풀이하는 데 그치지 않고 원본 경로로 근거를 다시 확인해야 한다. 새로운 추출물·담당자 검증으로 지식이 달라지면 질문과 기대 답변을 함께 갱신한다.
