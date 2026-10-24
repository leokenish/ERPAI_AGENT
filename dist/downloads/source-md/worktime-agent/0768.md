---
title: "근로유형·부서·개인 근무현황 조회"
as_of: 2026-10-07
review_status: pending_business_review
tags: [근무현황조회]
---

# 근로유형·부서·개인 근무현황 조회

<!-- atlas:auto:start -->

## 전체 범위 단계 지도

[전체 업무 진행 상태](../PROGRESS.md) · [소스 설명 목차](../sources/INDEX.md)
계획/실적, 개인/부서, 일별/주별/기간/월별 조회 진입점을 묶는다.
**완료 범위:** 아래 단계의 지정 소스 구간·직접 관계 확인 및 탐색 연결. 전체 업무 규칙·모든 분기 검토 완료를 뜻하지 않는다. 적용 시점은 추출본이며 운영 반영일 미확인. 기존 문서에 있는 정책/과거 검토안의 구분을 유지한다.

| 단계 | 관련 설명 문서 | 관계의 의미 | 근거 파일·코드 위치 | 수준 |
|---|---|---|---|---|
| 부서 웹 조회 | [FLEX_WORK_WEEKLY_LIST](../sources/FLEX_WORK_WEEKLY_LIST.md) · [ZHR_52TM_REAL_WORK_TIME_TEAM_M](../sources/ZHR_52TM_REAL_WORK_TIME_TEAM_M.md) | PC 부서화면이 TEAM_M 함수를 요청한다. TEAM과 TEAM_M을 같은 구현으로 합치지 않는다. | [FLEX_WORK_WEEKLY_LIST.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_WEEKLY_LIST/Layout/FLEX_WORK_WEEKLY_LIST.htm) L249 (웹 요청) | 확인: 지정 구간의 정적 관계 |
| 선택 조직 누적 | [ZRPTH440](../sources/ZRPTH440.md) · [ZHR_52TM_DAILY_WEEKLY_BUSEO](../sources/ZHR_52TM_DAILY_WEEKLY_BUSEO.md) | 440은 DAILY_WEEKLY_BUSEO를 호출한다. | [ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) L461 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 통상 부서 누적 | [ZRPTH441](../sources/ZRPTH441.md) · [ZHR_52TM_REAL_WORK_TIME_TEAM](../sources/ZHR_52TM_REAL_WORK_TIME_TEAM.md) | 441은 TEAM을 호출한다. GET_DATA 및 조직권한 FORM 상세는 원문에서 계속 탐색한다. | [ZRPTH441.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH441/source/ZRPTH441.abap) L467 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 유형·일일 조회 | [ZRPTH405](../sources/ZRPTH405.md) · [ZRPTH405F01](../sources/ZRPTH405F01.md) | 405는 F01을 포함한다. 화면 flow logic 미추출이므로 실제 SAP 메뉴 연결은 미확인. | [ZRPTH405.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405/source/ZRPTH405.abap) L13 (Include) | 확인: 지정 구간의 정적 관계 |
| 다른 조회 변형 | [ZRPTH413](../sources/ZRPTH413.md) · [ZTHR_WEEK_TIME](../sources/ZTHR_WEEK_TIME.md) · [ZHR_52TM_PERSONAL_WORK_TIME](../sources/ZHR_52TM_PERSONAL_WORK_TIME.md) · [ZHR_52TM_PLAN_TO_RESULT](../sources/ZHR_52TM_PLAN_TO_RESULT.md) · [ZHR_52TM_YEARLY_PAYMENT](../sources/ZHR_52TM_YEARLY_PAYMENT.md) | 선택 일일 실적·주간 집계·개인 계획대비실적·연간지급 조회는 목적상 연관이다. 각 함수의 직접 호출/데이터 표로 더 이동한다. | [ZRPTH413 원본](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413/source/ZRPTH413.abap) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[ZTHR_WEEK_TIME 원본](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZTHR_WEEK_TIME/source/ZTHR_WEEK_TIME.abap) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[ZHR_52TM_PERSONAL_WORK_TIME 원본](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Source%20code/ZHR_52TM_PERSONAL_WORK_TIME.abap) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[ZHR_52TM_PLAN_TO_RESULT 원본](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_TO_RESULT/Source%20code/ZHR_52TM_PLAN_TO_RESULT.abap) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[ZHR_52TM_YEARLY_PAYMENT 원본](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_YEARLY_PAYMENT/Source%20code/ZHR_52TM_YEARLY_PAYMENT.abap) — 파일 존재/헤더/정적 색인; 업무군 선정 | 분석상 연관·후보; 직접 호출 근거 아님 |

### 이 업무의 미추출·미검토 경계

조직권한의 실제 적용·마스킹, 전체 합산 로직, 외부 인사/조직함수와 최신 결과는 미확인.
화면 요청/직접 호출/Include/타입 참조/데이터 조회·저장/분석상 연관을 구분했다. 화면이 없거나 중계기·함수가 미추출이면 연결을 그 지점에서 멈춘다. 저장은 승인·지급·배포 완료의 동의어가 아니다.

<!-- atlas:auto:end -->
