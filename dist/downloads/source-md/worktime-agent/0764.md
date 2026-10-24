---
title: "통상·시차 시간외 입력"
as_of: 2026-10-07
review_status: pending_business_review
tags: [business-map, 통상시차시간외]
---

# 통상·시차 시간외 입력

[전체 목차](../INDEX.md)

SRC-14로 원래 출근시각부터 입력하는 기준을 확인했다. 0원 조건의 존재와 업무 결함 판정은 다르다.

## 문서 관계와 적용 시점

| 구분 | 근거 문서·위치 | 연결 의미 | 확인 수준·시점 |
|---|---|---|---|
| 현재 기준 | [overtime-start-time](../../knowledge/processes/overtime-start-time.md#%EC%A0%81%EC%9A%A9%20%EA%B8%B0%EC%A4%80) — 10행, `## 적용 기준` | 통상·시차 전체 구간 입력, 선택근무와 구분 | 확인: 사용자 최종 설명 SRC-14 / 시행일 미제공 |
| 과거 협의 | [SRC-10-late](../../knowledge/feedback/SRC-10-late.md#17.%20%EB%B0%98%EC%B0%A8%C2%B7%ED%9C%B4%EA%B0%80%EC%9D%BC%20%EC%8B%9C%EA%B0%84%EC%99%B8%2C%203%EC%9D%BC%20%EC%9E%85%EB%A0%A5%EA%B3%BC%20%EC%98%88%EC%99%B8%20%EA%B6%8C%ED%95%9C%EC%9D%98%20%EA%B5%AC%EB%B6%84) — 188행, `## 17. 반차` | 원래 자율출근시각부터 입력한 7/28 설명 | 확인: SRC-10 L2898–2914, 2026-07-28 |
| 정정 이력 | [FB-20261001-001](../../harness/feedback/FB-20261001-001.md#%EC%97%85%EB%AC%B4%20%ED%94%BC%EB%93%9C%EB%B0%B1) — 7행, `문제 답변` | 반차 예외 누락 결함 추정 철회 | 확인: 분석 정정 / 코드 수정 아님 |
| 기한 기준 | [late-overtime-request](../../knowledge/forms/late-overtime-request.md#%EC%8B%9C%EA%B0%84%EC%99%B8%EC%8B%A4%EB%B9%84%20%EC%9E%85%EB%A0%A5%EA%B8%B0%ED%95%9C%20%EA%B2%BD%EA%B3%BC%EB%B6%84%20%EB%82%B4%EB%B6%80%EA%B2%B0%EC%9E%AC) — 8행, `입력` | 일반 입력기한과 경과분 예외 구분 | 확인: 양식 설명 / 현행 운영은 개별 확인 |

## ABAP·웹 연결

| 설명 문서 | 연결 의미·한계 |
|---|---|
| [ORD_OT_INSERT](../sources/ORD_OT_INSERT.md) | **통상·교대 시간외 웹 입력** — 저장·상신 함수 이름을 AJAX 요청으로 전송（원본1768행）; 로그인 정보 함수 이름 참조（원본1211행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZHR_52TM_MOBILE_OVERTIME_APPR](../sources/ZHR_52TM_MOBILE_OVERTIME_APPR.md) | **시간외 저장·상신 요청** — 저장 데이터 처리 호출（원본193행）; 상신 처리 호출（원본350행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZHR_52TM_GET_OVERTIME_SAVE](../sources/ZHR_52TM_GET_OVERTIME_SAVE.md) | **시간외 저장 데이터 생성** — 시간·실비 계산 호출（원본40행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZHR_52TM_GET_OVERTIME_REQUEST](../sources/ZHR_52TM_GET_OVERTIME_REQUEST.md) | **시간외 워크플로 상신** — 외부 워크플로 시작 함수 호출（원본80행）. 확인: 정적 호출. 최종 승인·지급 완료를 의미하지 않는다. |
| [ZHR_52TM_GET_OVERTIME_DATA](../sources/ZHR_52TM_GET_OVERTIME_DATA.md) | **통상·시차 계산과 실비 표시** — 일별 시간·금액 처리 FORM 호출（원본61행）; 시차 7시간/휴게시간 조건（원본133행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZHR_52TM_CALC_NORM_OT_PAY](../sources/ZHR_52TM_CALC_NORM_OT_PAY.md) | **시간외 항목별 실비** — 야간시간 산정 FORM 호출（원본112행）; 야간실비 금액 필드（원본173행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |

## 회의·결정·검증

- [회의 자료와 결정 이력](../meetings-decisions.md) — 해당 업무의 협의는 위 문서 근거를 따른다. 독립 회의록 없음; 회의 안내를 결정문으로 보지 않는다.
- [기존 회귀 질문](../../tests/business-qa.md) — Q06, Q08, Q25, Q37, Q38. 검증 항목과 업무의 연결은 **검토자 선정**이며 통과 판정이 아니다. 일반 답변 생성 시 기대답변을 근거로 읽지 않는다.
- [검증 범위와 부족 자료](../verification.md) — 링크 존재 검사와 업무·SAP 검증을 구분한다.

## 함께 볼 업무

- [휴가·공가·반차](leave.md) — 반차를 사용해도 통상·시차 입력 시작시각을 원래 출근시각으로 잡는 관계. 근거: [입력 기준](../../knowledge/processes/overtime-start-time.md) §「적용 기준」, SRC-14. **확인: 사용자 최종 정정**.
- [시간외 단가·직군·효력일](rates.md) — 일별 계산금액을 검토할 때 직군 단가·효력일을 함께 확인하는 분석 경로. 근거: [현행 단가](../../knowledge/policies/overtime-rate-20260901.md) §「직군별 현행 기준 — SRC-13 후속 정정」. **분석상 연결**; 운영 마스터 반영은 미확인.
- [퇴직자·관리자 입력 검토](retired.md) — 통상 화면 초기화에서 인사조회로 전달하는 기준일을 퇴직자 입력 검토와 연결한다. 근거: [LZHR008_2F06](../sources/LZHR008_2F06.md) 원본73·102행과 [GET_PERSONNEL_DATA_N](../sources/ZHR_52TM_GET_PERSONNEL_DATA_N.md) 원본6·39행. **확인: 정적 소스**; 관리자 우회 권한은 미확인.
- [월정산·확정·전표·지급](settlement.md) — 화면 계산·승인과 최종 지급을 구분해서 추적하는 분석 경로. 근거: [처리 단계](../../knowledge/processes/working-time-lifecycle.md) §「상태를 분리해야 하는 이유」. **문서 기반 연결**; 자동 실행순서 보장이 아니다.

<!-- atlas:auto:start -->

## 전체 범위 단계 지도

[전체 업무 진행 상태](../PROGRESS.md) · [소스 설명 목차](../sources/INDEX.md)
PC·모바일 신청, 관리자 입력, 입력 검사, 저장·상신·삭제·회수를 분리한다. SRC-14 입력 시작시각 기준과 기존 지도 정책 부분을 유지한다.
**완료 범위:** 아래 단계의 지정 소스 구간·직접 관계 확인 및 탐색 연결. 전체 업무 규칙·모든 분기 검토 완료를 뜻하지 않는다. 적용 시점은 추출본이며 운영 반영일 미확인. 기존 문서에 있는 정책/과거 검토안의 구분을 유지한다.

| 단계 | 관련 설명 문서 | 관계의 의미 | 근거 파일·코드 위치 | 수준 |
|---|---|---|---|---|
| 화면 → 검사 요청 | [ORD_OT_INSERT](../sources/ORD_OT_INSERT.md) · [ZHR_52TM_MOBILE_OVERTIME_CHECK](../sources/ZHR_52TM_MOBILE_OVERTIME_CHECK.md) | ORD_OT_INSERT가 모바일 명칭의 검사 함수를 PC 화면에서도 요청한다. | [ORD_OT_INSERT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_INSERT/Layout/ORD_OT_INSERT.htm) L1337, 1809 (웹 요청) | 확인: 지정 구간의 정적 관계 |
| 화면 → 저장·상신 요청 | [ORD_OT_INSERT](../sources/ORD_OT_INSERT.md) · [ZHR_52TM_MOBILE_OVERTIME_APPR](../sources/ZHR_52TM_MOBILE_OVERTIME_APPR.md) · [MORD_OT_INSERT](../sources/MORD_OT_INSERT.md) | 동일 요청 함수에 SAVE/APPR를 전달하는 구간. APPR는 상신이며 최종 승인으로 해석하지 않는다. | [ORD_OT_INSERT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_INSERT/Layout/ORD_OT_INSERT.htm) L1870, 2063 (웹 요청)<br>[MORD_OT_INSERT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_INSERT/Layout/MORD_OT_INSERT.htm) L1986, 2174 (웹 요청) | 확인: 지정 구간의 정적 관계 |
| 검사 → 시간 계산 | [ZHR_52TM_CHECK_INPUT_DATA](../sources/ZHR_52TM_CHECK_INPUT_DATA.md) · [ZHR_52TM_NEW_ORDINARY_TIME2](../sources/ZHR_52TM_NEW_ORDINARY_TIME2.md) · [ZHR_52TM_NEW_SHIFTWORK_TIME](../sources/ZHR_52TM_NEW_SHIFTWORK_TIME.md) | CHECK_INPUT_DATA의 통상·교대 계산 호출을 구분한다. 휴가·출장·휴게 세부 조건은 원문 추가 검토. | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L338, 365 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 저장 | [ZHR_52TM_MOBILE_OVERTIME_APPR](../sources/ZHR_52TM_MOBILE_OVERTIME_APPR.md) · [ZHR_52TM_GET_OVERTIME_SAVE](../sources/ZHR_52TM_GET_OVERTIME_SAVE.md) · [ZTHRBS01](../sources/EXT-ZTHRBS01.md) | SAVE/APPR 경로에서 저장 구조를 만들고 호출자가 ZTHRBS01을 변경한다. 구조 생성 함수에도 일부 직접 DB 변경이 있다. | [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L193, 278 (직접 호출)<br>[ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L223, 313 (데이터 저장) | 확인: 지정 구간의 정적 관계 |
| 상신 | [ZHR_52TM_MOBILE_OVERTIME_APPR](../sources/ZHR_52TM_MOBILE_OVERTIME_APPR.md) · [ZHR_52TM_VALID_DATE_CHECK](../sources/ZHR_52TM_VALID_DATE_CHECK.md) · [ZHR_52TM_GET_OVERTIME_REQUEST](../sources/ZHR_52TM_GET_OVERTIME_REQUEST.md) · [ZWF_START_WORK_HR](../sources/EXT-ZWF_START_WORK_HR.md) | 기한 검사와 상신 함수 호출 후 외부 WF 생성으로 이어진다. | [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L74, 331, 350 (직접 호출)<br>[ZHR_52TM_GET_OVERTIME_REQUEST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_REQUEST/Source%20code/ZHR_52TM_GET_OVERTIME_REQUEST.abap) L80 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 취소·회수·삭제 | [ZHR_52TM_MOBILE_OVERTIME_APPR](../sources/ZHR_52TM_MOBILE_OVERTIME_APPR.md) · [ZHR_52TM_GET_OVERTIME_DELETE](../sources/ZHR_52TM_GET_OVERTIME_DELETE.md) · [ZHR_52TM_GET_OVERTIME_RETURN](../sources/ZHR_52TM_GET_OVERTIME_RETURN.md) · [ZWF_DELETE](../sources/EXT-ZWF_DELETE.md) | DELE와 RETR는 별도 분기. DELETE는 상태에 따라 논리 삭제 또는 물리 삭제, RETURN은 WF 회수 성공 후 상태 5를 기록한다. | [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L380, 417 (직접 호출)<br>[ZHR_52TM_GET_OVERTIME_RETURN.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_RETURN/Source%20code/ZHR_52TM_GET_OVERTIME_RETURN.abap) L21 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 관리자 화면·후속 정산 | [SAPMZH4110](../sources/SAPMZH4110.md) · [MZH4110F01](../sources/MZH4110F01.md) · [ZRPTH2012_M](../sources/ZRPTH2012_M.md) | SAPMZH4110은 헤더 및 Include로 관리자 입력을 식별했다. 웹과 동일한 운영 권한·진입점이라는 뜻은 아니다. 월정산·FI는 settlement 지도에서 이어간다. | [SAPMZH4110 원본](../../exports/ZHR5/packages/ZHR5/programs/PROG/SAPMZH4110/source/SAPMZH4110.abap) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[MZH4110F01 원본](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110F01/source/MZH4110F01.abap) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[ZRPTH2012_M 원본](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_M/source/ZRPTH2012_M.abap) — 파일 존재/헤더/정적 색인; 업무군 선정 | 분석상 연관·후보; 직접 호출 근거 아님 |

### 이 업무의 미추출·미검토 경계

통상 최종 승인 함수 ZHR_APPROVE_OT_DATA, 실제 결재 중계기·권한과 시간 계산 전체 분기, 관리자 Dynpro flow logic은 미추출/미검토.
화면 요청/직접 호출/Include/타입 참조/데이터 조회·저장/분석상 연관을 구분했다. 화면이 없거나 중계기·함수가 미추출이면 연결을 그 지점에서 멈춘다. 저장은 승인·지급·배포 완료의 동의어가 아니다.

<!-- atlas:auto:end -->
