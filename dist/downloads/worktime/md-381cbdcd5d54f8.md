---
title: "탄력근로 계획·결재"
as_of: 2026-10-07
review_status: pending_business_review
tags: [business-map, 탄력근무]
---

# 탄력근로 계획·결재

[전체 목차](../INDEX.md)

2주 탄력 계획부터 승인·미결처리·정산까지의 정적 소스 연결이다.

## 문서 관계와 적용 시점

| 구분 | 근거 문서·위치 | 연결 의미 | 확인 수준·시점 |
|---|---|---|---|
| 구현 분석 | [flows](../../knowledge/hr/flows.md#F01.%20%ED%83%84%EB%A0%A5%EA%B7%BC%EB%A1%9C%20%EA%B3%84%ED%9A%8D%20%EC%A1%B0%ED%9A%8C%C2%B7%EC%A0%80%EC%9E%A5%C2%B7%EC%83%81%EC%8B%A0%C2%B7%ED%9A%8C%EC%88%98%C2%B7%EC%82%AD%EC%A0%9C) — 8행, `## F01.` | 계획 저장·상신·회수 처리 | 확인: 기존 정적 분석 / 실행 미검증 |
| 승인 분석 | [flows](../../knowledge/hr/flows.md#F02.%20%EA%B3%84%ED%9A%8D%20%EC%8A%B9%EC%9D%B8%C2%B7%EB%B0%98%EB%A0%A4%EC%99%80%20%EA%B7%BC%EB%AC%B4%EC%A0%95%EB%B3%B4%20%EB%B0%98%EC%98%81) — 31행, `## F02.` | 승인과 PA9021 반영 | 확인: 코드 분석 / WF 전체 미확인 |
| 월정산 분석 | [flows](../../knowledge/hr/flows.md#F04.%20%ED%83%84%EB%A0%A5%EA%B7%BC%EB%A1%9C%20%EC%9B%94%20%EC%A0%95%EC%82%B0%20%EA%B3%84%EC%82%B0%C2%B7%ED%99%95%EC%A0%95%C2%B7%EC%B7%A8%EC%86%8C) — 59행, `## F04.` | 정산 확정·취소 및 PA2010 연결 | 확인: 코드 분석 / 현행 정책 검증 아님 |
| 운영 경계 | [open-questions](../../knowledge/hr/open-questions.md#Q13.%20%EC%9A%B4%EC%98%81%20%EC%A7%84%EC%9E%85%EC%A0%90%C2%B7%EC%9E%A1%EA%B3%BC%20%EC%9D%B4%EB%B2%88%20%EB%AF%B8%EA%B2%80%ED%86%A0%20%EC%98%81%EC%97%AD) — 109행, `### Q13.` | 잡·트랜잭션·실제 진입점은 추가 자료 필요 | 미확인: 운영 실행 연결 |

## ABAP·웹 연결

| 설명 문서 | 연결 의미·한계 |
|---|---|
| [FLEX_WORK_PLAN_ESTABLISH](../sources/FLEX_WORK_PLAN_ESTABLISH.md) | **탄력 계획 웹 입력** — 계획 처리 요청（원본1622행）; 휴가 조회 요청（원본1152행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZHR_52TM_PLAN_WORK_TIME](../sources/ZHR_52TM_PLAN_WORK_TIME.md) | **탄력근로 계획 요청** — 계획 저장（원본144행）; 계획 상신 검사（원본158행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZHR_52TM_APPROVE_OT_DATA](../sources/ZHR_52TM_APPROVE_OT_DATA.md) | **계획·실적 승인 처리** — 기한 검사 호출（원본134행）; 외부 승인 호출（원본413행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZRPTH401](../sources/ZRPTH401.md) | **탄력 계획 미결처리** — 미결처리 중 외부 WF 호출（원본96행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZHR_52TM_MONTHLY_PAYMENT](../sources/ZHR_52TM_MONTHLY_PAYMENT.md) | **탄력 월정산 계산** — 주 단위 시간 계산 호출（원본228행）; 대상 등급 조회（원본415행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZRPTH402F01](../sources/ZRPTH402F01.md) | **탄력 정산 확정** — 월정산 계산 호출（원본17행）; 확정 데이터 반영（원본592행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |

## 회의·결정·검증

- [회의 자료와 결정 이력](../meetings-decisions.md) — 해당 업무의 협의는 위 문서 근거를 따른다. 독립 회의록 없음; 회의 안내를 결정문으로 보지 않는다.
- [코드 기반 검증 질문](../../evals/hr/questions.md) — 탄력 계획·승인·정산 관련 항목. 기대답변 접근 없이 답변한 뒤 별도 대조한다.
- [검증 범위와 부족 자료](../verification.md) — 링크 존재 검사와 업무·SAP 검증을 구분한다.

## 함께 볼 업무

- [월정산·확정·전표·지급](settlement.md) — 탄력 정산 확정 프로그램이 월정산 계산을 호출하는 관계. 근거: [ZRPTH402F01](../sources/ZRPTH402F01.md) 원본17·592행. **확인: 정적 호출·반영 구문**.
- [휴가·공가·반차](leave.md) — 탄력 계획 화면에서 휴가 조회 이름을 전송하는 관계. 근거: [FLEX_WORK_PLAN_ESTABLISH](../sources/FLEX_WORK_PLAN_ESTABLISH.md) 원본1152행. **확인: 웹 요청 이름**; dispatcher의 실제 실행 연결은 미확인.

<!-- atlas:auto:start -->

## 전체 범위 단계 지도

[전체 업무 진행 상태](../PROGRESS.md) · [소스 설명 목차](../sources/INDEX.md)
계획(기간/일일)과 실적의 조회·저장·상신·회수·삭제, 승인·미결·월정산을 각각 연결한다.
**완료 범위:** 아래 단계의 지정 소스 구간·직접 관계 확인 및 탐색 연결. 전체 업무 규칙·모든 분기 검토 완료를 뜻하지 않는다. 적용 시점은 추출본이며 운영 반영일 미확인. 기존 문서에 있는 정책/과거 검토안의 구분을 유지한다.

| 단계 | 관련 설명 문서 | 관계의 의미 | 근거 파일·코드 위치 | 수준 |
|---|---|---|---|---|
| 계획 화면 → 요청 | [FLEX_WORK_PLAN_ESTABLISH](../sources/FLEX_WORK_PLAN_ESTABLISH.md) · [ZHR_52TM_PLAN_WORK_TIME](../sources/ZHR_52TM_PLAN_WORK_TIME.md) · [MFLEX_WORK_PLAN_ESTABLISH](../sources/MFLEX_WORK_PLAN_ESTABLISH.md) | PC·모바일 계획 화면이 같은 계획 함수를 요청한다. | [FLEX_WORK_PLAN_ESTABLISH.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_ESTABLISH/Layout/FLEX_WORK_PLAN_ESTABLISH.htm) L1633, 1757, 1773, 2069 (웹 요청)<br>[MFLEX_WORK_PLAN_ESTABLISH.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MFLEX_WORK_PLAN_ESTABLISH/Layout/MFLEX_WORK_PLAN_ESTABLISH.htm) L1903, 2027, 2043, 2339 (웹 요청) | 확인: 지정 구간의 정적 관계 |
| 계획 등록·검사·저장·상신 | [ZHR_52TM_PLAN_WORK_TIME](../sources/ZHR_52TM_PLAN_WORK_TIME.md) · [LZHR008_2F01](../sources/LZHR008_2F01.md) · [ZTHR0106](../sources/ZTHR0106.md) · [ZTHR0107](../sources/ZTHR0107.md) | R/S/A/B/D/N 분기는 원본 L64–337. F01에 get_plan_save와 check_plan_approve가 있으며 기간·일일계획을 저장한다. | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L59, 70, 90, 106, 144, 158, 166, 204, 208, 231, 280, 293, 330 (FORM 호출)<br>[LZHR008_2F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap) L605, 789, 792, 989, 991 (데이터 저장) | 확인: 지정 구간의 정적 관계 |
| 실적 화면 → 조회·저장·상신 | [FLEX_WORK_PERFORMANCE_INPUT](../sources/FLEX_WORK_PERFORMANCE_INPUT.md) · [ZHR_52TM_REAL_WORK_TIME](../sources/ZHR_52TM_REAL_WORK_TIME.md) · [ZTHR0110](../sources/ZTHR0110.md) | REAL_WORK_TIME은 L/R/S/A/B/D를 구분한다. 저장 L185–290, 상신 L295–325, 회수 L331–392, 삭제 L398–468. | [FLEX_WORK_PERFORMANCE_INPUT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PERFORMANCE_INPUT/Layout/FLEX_WORK_PERFORMANCE_INPUT.htm) L2240, 2354, 2368, 2597 (웹 요청)<br>[ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L222, 280, 382, 446 (데이터 저장) | 확인: 지정 구간의 정적 관계 |
| 승인·반려 | [ZHR_52TM_APPROVAL_LIST](../sources/ZHR_52TM_APPROVAL_LIST.md) · [ZHR_52TM_APPROVE_OT_DATA](../sources/ZHR_52TM_APPROVE_OT_DATA.md) · [PA9021](../sources/PA9021.md) · [ZWF_APPROVE_WORK](../sources/EXT-ZWF_APPROVE_WORK.md) · [ZWF_REJECT_WORK](../sources/EXT-ZWF_REJECT_WORK.md) | 계획 P/실적 R 분기와 외부 WF 후처리. 이번 분석에서 APPROVAL_LIST의 I_ACTION=A/I_BOX=5 라우팅을 추가 확인했다. 외부 dispatcher 실행은 미확인. | [ZHR_52TM_APPROVAL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Source%20code/ZHR_52TM_APPROVAL_LIST.abap) L253 (직접 호출)<br>[ZHR_52TM_APPROVE_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_OT_DATA/Source%20code/ZHR_52TM_APPROVE_OT_DATA.abap) L201 (데이터 저장)<br>[ZHR_52TM_APPROVE_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_OT_DATA/Source%20code/ZHR_52TM_APPROVE_OT_DATA.abap) L413, 430 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 미결처리 | [ZRPTH401](../sources/ZRPTH401.md) · [ZTHR0101](../sources/ZTHR0101.md) · [ZWF_DELETE](../sources/EXT-ZWF_DELETE.md) · [ZTHR0106](../sources/ZTHR0106.md) | ZRPTH401이 ZLIMIT 기준 대상을 읽고 WF 회수 후 F 상태를 기록한다. 잡 등록·실행 일정 미확인. | [ZRPTH401.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH401/source/ZRPTH401.abap) L41 (데이터 조회)<br>[ZRPTH401.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH401/source/ZRPTH401.abap) L96 (직접 호출)<br>[ZRPTH401.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH401/source/ZRPTH401.abap) L129 (데이터 저장) | 확인: 지정 구간의 정적 관계 |
| 월정산·확정 | [ZRPTH402F01](../sources/ZRPTH402F01.md) · [ZHR_52TM_MONTHLY_PAYMENT](../sources/ZHR_52TM_MONTHLY_PAYMENT.md) · [ZTHR0120](../sources/ZTHR0120.md) · [PA2010](../sources/EXT-PA2010.md) | 보고서 Include의 계산 호출과 정산 확정 결과. 실제 지급은 별도 단계. | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L17 (직접 호출)<br>[ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L592, 615, 868, 892 (데이터 저장) | 확인: 지정 구간의 정적 관계 |

### 이 업무의 미추출·미검토 경계

외부 dispatcher/WF, ZLIMIT 운영값, 다단계 최종 승인과 정보형 반영 시점, 전체 산식은 추가 확인 필요.
화면 요청/직접 호출/Include/타입 참조/데이터 조회·저장/분석상 연관을 구분했다. 화면이 없거나 중계기·함수가 미추출이면 연결을 그 지점에서 멈춘다. 저장은 승인·지급·배포 완료의 동의어가 아니다.

<!-- atlas:auto:end -->
