# ZHR5 업무 지식 색인

**현재 로컬 변경 — SRC-18:** [시간외 입력 조건 통일](code-map/local-20261022-overtime-attendance.md)의 두 ABAP 구간을 원본 경로에 반영했다. SAP 미반영·미검증이며, SRC-17 추출 당시 설명과 구별한다.

최신 소스 교체·근태 차단·일반검진·퇴직자·정산 금액 보정: [2026-10-22 KSP 변경 분석](code-map/export-20261022.md). 이전 KSD 분석의 적용 범위는 이 문서와 대조한다.

범위: 초기 11개 업무 자료(2026-09-22)와 후속 사용자 확인 SRC-12~16, SAP 추출본 SRC-17. **실무자 검토 전. 최신 코드 기준은 2026-10-22 KSP/300이며 정적 확인과 운영 검증을 구분한다.**

| 질문/검색어 | 먼저 읽을 파일 | 주된 근거 |
|---|---|---|
| ERP 환경·ECC 6.0·EHP 0·Oracle·Linux·SAP_BASIS 700·초급 ABAP 코딩 | [환경과 코딩 필수 기준](reference/erp-environment.md) | SRC-22 사용자 확인/지시, 2026-10-27 |
| 역할·분석 범위 | [에이전트 설명서](../docs/AGENT_PROFILE.md) | 자료 범위 |
| 자주 묻는 업무 질문 | [빠른 질의응답](business-qa.md) | SRC-01~11 |
| 소정/최대/누적, 대휴/익휴/선택휴무 차이 | [업무 용어집](BUSINESS_GLOSSARY.md) | SRC-01~06 |
| 선택 누적표시·가산시간·소정 미충족 오해·2024-10-28 롤백·대휴 구분 | [누적표시와 가산시간](processes/selective-cumulative-display.md) | SRC-15; 실제 BASE_DATA L629–635; SRC-07 후반 이력 |
| 취업규칙, 단축근무, 휴가, 야간 | [취업규칙](policies/employment-rules-20260227.md) | SRC-01 |
| 휴가일·종일 연차·근태 메시지·실적 선입력·단방향/양방향 검증·통상/선택 | [근태와 실적의 신청 순서별 검증](processes/leave-work-validation.md) | SRC-16 사용자 시험 보고, 2026-10-13; 근태 선등록 차단·역순 경로 검증 과제 |
| 통상·시차 반차·자율출근·지참·조퇴·시작시간·실비0원 | [시간외 입력 시작시각](processes/overtime-start-time.md) | SRC-14 최종 확인; SRC-10 L2898–2914 |
| 시간외 단가·9,240원·2026-09-01·선택 정산 예시 | [현재 단가와 경계 기준](policies/overtime-rate-20260901.md) | SRC-12/13 사용자 정정; SRC-10/11 |
| 8~9월 선택 금액차이·ZTHREDITCOST·입력 시작일 단가·익일 자정 분할 제외·대휴 확보 단가·시차/재량/간주 인상 제외 | [기간 중 단가 변경 계산 검토](processes/selective-rate-boundary-review.md) | SRC-23, 2026-10-29 운영 설명; SRC-17/비교 리포트 정적 확인. 개선 미구현 |
| 선택근무 4주·208·휴게·대휴·실적 | [선택근무 매뉴얼](manuals/selective-work-202203.md) | SRC-02 |
| 정산 후 실적 변경·대휴 가상 재계산·발생일 변경·양수 소급·음수 급여 삭감·근태 0건 미계산 | [정산 후 대휴 재구성 검토](processes/selective-post-settlement-rebuild.md) | SRC-19, 2026-10-24 요구/10-26 사용자 결과 및 수정 요청; SRC-17 정적 소스. 보조 근태 0건 처리 수정, 수정본 SAP 재실행 대기·저장 미구현 |
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

## 선택·통상 연장시간 입력 비교 — 2026-10-16

- 입력 구간·오전반차 예·자율출근·휴게·지급 대상 연장시간의 구분: [입력 비교 명세](processes/overtime-start-time.md#선택근무와%20통상근무의%20연장시간%20입력%20비교%20명세).
- 근태 조회/상태·반차/대휴·ZTHRBS08·평일 조건, 신규/수정 저장·상신·관리자 오류 전파의 변경 후보: [소스 차이와 수정 검토 명세](processes/leave-work-validation.md#선택·통상%20입력%20검증의%20소스%20차이와%20수정%20검토%20명세).
- 기존 SRC-14/16과 추출본을 정리한 AI 명세이며 담당자 검토 대기. 새로운 정책 시행·ABAP 변경·운영 검증 완료가 아니다.

## 2026-10-26 로컬 변경 롤백 이력

[관리자 통상 선택 시 저장 구분 보정](code-map/local-20261026-ordinary-save-gubun.md). 사용자 요청으로 SAVE_DATA 보정 블록을 롤백했다. MZH4110F01은 변경 전 사본과 바이트·해시가 일치하며 DB 반영은 다시 L2220이다. 이 기록은 적용·철회 이력이고 현재 활성 로컬 변경이 아니다. 후속 설계는 미구현, SAP 변경 없음.

## 관리자 타 사용자 로그인 매핑 — 2026-10-27

ZTHRBSADMIN·대리 로그인·시스템 관리자 사번·사용자 사번·선택/시간외 대리 조회: [업무 용도와 입력 방향](processes/admin-user-login-mapping.md). SRC-20 사용자 설명과 SRC-17 DDIC 정의를 구별한다.

인사담당자 매핑 관리 화면·저장/삭제·담당자별 1명: [개발 전 검토](../proposals/20261027-user-login-mapping/README.md), SRC-21. 코드 미작성·검토안.

2026-10-27 SRC-21 후속: [ZHR_TIME_LOGIN_MAP 개발안](../proposals/20261027-user-login-mapping/README.md) 작성. 담당자별 1건, 담당자 간 동일 대상 허용. 설치 전제·검증 한계는 개발안 참조, SAP 미반영.

SRC-21 후속 수정: 사번=로그인 ID 사용자 확인에 따라 [로그인 매핑 개발안](../proposals/20261027-user-login-mapping/README.md)의 PA0105 조회를 제거하고 입력 사번을 BNAME2에 직접 저장한다.


- 통상 오전 일반검진 반일·13시 오입력·오전 자동보충 없음·43,890원/6,930원: [입력 기준과 실제 계산 순서](processes/overtime-start-time.md#일반검진-오전-반일과-통상-시간외-계산--2026-10-29-확인), SRC-24 사용자 확인 및 SRC-17 정적 대조. 금액은 조건부 산술·SAP 미검증.

- 통상 반차·반일 근태일 출근시각 안내 팝업 제안·ABAP 후보·W 차단 영향: [2026-10-29 변경 검토](../proposals/20261029-ordinary-halfday-notice/README.md). SRC-24 후속 요청, 미구현.

- 기존 프로그램 운영 철학·최소 수정·TEXT-E63 텍스트 심볼·사용자 입력 안내 범위: AGENTS.md 필수 원칙 및 [축소한 안내 검토안](../proposals/20261029-ordinary-halfday-notice/README.md). 4곳 수정안은 철회, 현재 1개 입력 검사 함수+텍스트 심볼 우선 검토.

- 2026-10-30 반일 안내 설계 재정정: [기존 CHECK_ABSENCE_DATA 분기 재사용 우선](../proposals/20261029-ordinary-halfday-notice/README.md). _M에 별도 근태 조회를 복제하는 제안 철회. 공통 호출 영향과 오류 우선순위 확인 전 단일 위치 완결 단정 금지.

- 대휴 8월 31일~9월 1일은 시작일 8,400원 적용, “보유금액” 임의 용어 철회: [단가 경계·용어 정정](processes/selective-rate-boundary-review.md#대휴-경계일과-용어-정정--2026-10-30), SRC-23 후속 2026-10-30.

- 대휴 8·9월 0.5시간 단가 배수 검사 ALV: [ZHR_DAEH_RATE_CHECK](../proposals/20261030-daeh-rate-check/README.md). SRC-23 후속 2026-10-30 신규 조회 개발안. 인정시간 재계산 없이 구/신단가 여부·추정차액 표시, SAP 미검증.

- 대휴 검사 ALV 금액 23,100→231 축소 오류: [금액 단위 정정](../proposals/20261030-daeh-rate-check/README.md#2026-10-30-실제-금액-100분의-1-축소-오류-정정). SRC-23 후속 사용자 SAP 실측, /100 제거, 23,100원은 양쪽 배수 일치.

- PERSK E1/E4/E5/E6/E7: 5,400→9,240원, E8: 5,400원 유지 및 근무일 유효 PA0001: [단가 기준 보완](policies/overtime-rate-20260901.md#persk별-인상-전후-금액-보완--2026-10-30), SRC-23 후속 2026-10-30. 대휴 배수 ALV에 반영, SAP 미검증.
