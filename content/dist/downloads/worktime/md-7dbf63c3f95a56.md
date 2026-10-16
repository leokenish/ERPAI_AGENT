# ZHR5 업무 지식 색인

범위: 업로드된 11개 자료의 근로시간 업무. 정리일 2026-09-22. **실무자 검토 전이며 실제 ZHR5 소스는 이 묶음에 없다.**

| 질문/검색어 | 먼저 읽을 파일 | 주된 근거 |
|---|---|---|
| 역할·분석 범위 | [에이전트 설명서](../docs/AGENT_PROFILE.md) | 자료 범위 |
| 자주 묻는 업무 질문 | [빠른 질의응답](business-qa.md) | SRC-01~11 |
| 소정/최대/누적, 대휴/익휴/선택휴무 차이 | [업무 용어집](BUSINESS_GLOSSARY.md) | SRC-01~06 |
| 선택 누적표시·가산시간·소정 미충족 오해·2024-10-28 롤백·대휴 구분 | [누적표시와 가산시간](processes/selective-cumulative-display.md) | SRC-15; 실제 BASE_DATA L629–635; SRC-07 후반 이력 |
| 취업규칙, 단축근무, 휴가, 야간 | [취업규칙](policies/employment-rules-20260227.md) | SRC-01 |
| 통상·시차 반차·자율출근·지참·조퇴·시작시간·실비0원 | [시간외 입력 시작시각](processes/overtime-start-time.md) | SRC-14 최종 확인; SRC-10 L2898–2914 |
| 시간외 단가·9,240원·2026-09-01·선택 정산 예시 | [현재 단가와 경계 기준](policies/overtime-rate-20260901.md) | SRC-12/13 사용자 정정; SRC-10/11 |
| 선택근무 4주·208·휴게·대휴·실적 | [선택근무 매뉴얼](manuals/selective-work-202203.md) | SRC-02 |
| 통상익휴/시차익휴·24시간·강제 해제 | [익휴 매뉴얼](manuals/next-day-rest.md) | SRC-03 |
| 입력 3일·결재 2일·경과 5일·양식 | [경과분 양식](forms/late-overtime-request.md) | SRC-04 |
| ERP 전체 업무 흐름·주요 함수/테이블 | [담당자 인수인계](reference/erp-handover.md) | SRC-05 |
| 교대 반차·계좌·출장·선택 신청 | [사용자 FAQ](reference/user-faq.md) | SRC-06 |
| 통상/선택/교대/간주/재량 비교 | [업무 흐름](processes/working-time-lifecycle.md) | SRC-02~11 |
| 긴 카톡 근거 찾기 | [협의 이력 검색 안내](feedback/INDEX.md) | 날짜/주제별 검색 |
| 과거 변경·단가·소급·롤백 | [시점별 결정 이력](decisions/TIMELINE.md) | SRC-07~11 |
| 2023~2026 담당자 협의 | [SRC-07 전반](feedback/SRC-07-early.md), [SRC-07 후반 및 SRC-08](feedback/SRC-07-late-SRC-08.md) | SRC-07/08 |
| 초기 선택/간주/재량 개선 | [SRC-09 협의](feedback/SRC-09.md) | SRC-09 |
| 2026년 마감·단가·은행 전송 | [SRC-10 전반 및 SRC-11](feedback/SRC-10-early-SRC-11.md), [SRC-10 후반](feedback/SRC-10-late.md) | SRC-10/11 |
| 코드·BSP 화면 연결 | [업무-코드 연결 후보](code-map/working-time.md) | SRC-05 및 카톡 |
| export 폴더·분석 범위·미추출 | [EXPORT_GUIDE](../docs/EXPORT_GUIDE.md), [SAP 객체 사전](../docs/SAP_OBJECT_GLOSSARY.md) | 프로젝트 추출기 자료 |
| 충돌·최신 여부·추가 자료 | [미확인 사항](OPEN_QUESTIONS.md) | 상충/누락 근거 |
| 답변 품질 평가 | [business-qa](../tests/business-qa.md) | 근거 기반 기대 답변 |
| 원문 위치·검토 범위·해시 | [출처 등록부](../docs/SOURCE_REGISTER.md) | 11개 원문 |

2026-10-08 보완: 초기 11개 자료 묶음과 별도로, 선택 누적표시의 가산 포함/롤백은 현재 저장소의 지정 ABAP 구간과 SRC-15 사용자 설명을 대조했다. 위 신규 업무 설명에 확인 범위와 운영 미검증을 구분했다.

## 최소 읽기 원칙
질문과 관련된 위 문서 1~3개를 시작점으로 삼고, 결론에 필요한 경우 범위를 넓힌다. 이는 성능 목표이며 근거를 생략하라는 제한이 아니다.
원문 전체나 `.devhub/baseline`을 대화마다 붙이지 않는다. 확정 답변이 불가능하면 미확인 항목과 필요한 증빙을 설명한다.
