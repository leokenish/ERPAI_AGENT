---
title: "교대근무·보상휴가"
as_of: 2026-10-07
review_status: pending_business_review
tags: [business-map, 교대근무]
---

# 교대근무·보상휴가

[전체 목차](../INDEX.md)

등록 스케줄, 실적, 반차와 보상휴가를 분리해서 탐색한다.

## 문서 관계와 적용 시점

| 구분 | 근거 문서·위치 | 연결 의미 | 확인 수준·시점 |
|---|---|---|---|
| 업무 안내 | [user-faq](../../knowledge/reference/user-faq.md#FAQ%EB%B3%84%20%EB%82%B4%EC%9A%A9) — 14행, `교대근무자의 반차` | 교대 반차 입력과 담당자 처리 안내 | 확인: 날짜 미상 FAQ / 적용 전제 필요 |
| 협의 | [SRC-10-late](../../knowledge/feedback/SRC-10-late.md#5.%20%EA%B5%90%EB%8C%80%EA%B7%BC%EB%AC%B4%2052%EC%8B%9C%EA%B0%84%3A%20%EC%8B%A4%EC%A0%9C%20%EC%9E%85%EB%A0%A5%EB%B3%B4%EB%8B%A4%20%EC%82%AC%EC%A0%84%20%EC%8A%A4%EC%BC%80%EC%A4%84%EC%9D%84%20%EB%A8%BC%EC%A0%80%20%EA%B3%84%EC%82%B0) — 65행, `6월 26일 사례 D` | 입력합계33시간과 스케줄 기반46.5시간 설명 | 확인: SRC-10 L2143–2169 / 당시 사례 |
| 보상휴가 | [SRC-10-late](../../knowledge/feedback/SRC-10-late.md#14-1.%207%EC%9B%94%2013%EC%9D%BC%20%EC%9D%B8%EC%83%81%20%EA%B2%B0%EC%A0%95%20%EC%A0%84%EB%8B%AC%EA%B3%BC%20%EB%B3%B4%EC%83%81%ED%9C%B4%EA%B0%80%20%EC%B0%A8%EA%B0%90%20%EC%88%9C%EC%84%9C) — 136행, `### 14-1.` | 교대 보상휴가와 낮은 금액 차감 순서 설명 | 확인: 당시 설명 / 운영 전체 검증 아님 |
| 변경 이력 | [TIMELINE](../../knowledge/decisions/TIMELINE.md#%EC%8B%9C%EC%A0%90%EB%B3%84%20%ED%98%91%EC%9D%98%C2%B7%EB%B3%80%EA%B2%BD%20%EC%9D%B4%EB%A0%A5) — 10행, `2024-07-19` | 부장급이 포함된 만근월 보상휴가 제외 요청 | 과거 검토·요청 / 구현 완료 미확인 |

## ABAP·웹 연결

| 설명 문서 | 연결 의미·한계 |
|---|---|
| [ORD_OT_INSERT](../sources/ORD_OT_INSERT.md) | **통상·교대 시간외 웹 입력** — 저장·상신 함수 이름을 AJAX 요청으로 전송（원본1768행）; 로그인 정보 함수 이름 참조（원본1211행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZHR_52TM_MOBILE_OVERTIME_APPR](../sources/ZHR_52TM_MOBILE_OVERTIME_APPR.md) | **시간외 저장·상신 요청** — 저장 데이터 처리 호출（원본193행）; 상신 처리 호출（원본350행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZHR_52TM_CALC_NORM_OT_PAY](../sources/ZHR_52TM_CALC_NORM_OT_PAY.md) | **시간외 항목별 실비** — 야간시간 산정 FORM 호출（원본112행）; 야간실비 금액 필드（원본173행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |

## 회의·결정·검증

- [회의 자료와 결정 이력](../meetings-decisions.md) — 해당 업무의 협의는 위 문서 근거를 따른다. 독립 회의록 없음; 회의 안내를 결정문으로 보지 않는다.
- [기존 회귀 질문](../../tests/business-qa.md) — Q11, Q28, Q34. 검증 항목과 업무의 연결은 **검토자 선정**이며 통과 판정이 아니다. 일반 답변 생성 시 기대답변을 근거로 읽지 않는다.
- [검증 범위와 부족 자료](../verification.md) — 링크 존재 검사와 업무·SAP 검증을 구분한다.

## 함께 볼 업무

- [대휴·익휴·보상휴가](rest.md) — 교대 보상휴가 차감 순서를 대휴·익휴와 구분해 비교한다. 근거: [협의 기록](../../knowledge/feedback/SRC-10-late.md) §14-1. **확인: 당시 담당자 설명**; 세 제도가 같은 계산이라는 뜻은 아니다.
- [휴가·공가·반차](leave.md) — 교대 반차는 별도 입력·담당자 처리 안내를 확인하는 관계. 근거: [FAQ](../../knowledge/reference/user-faq.md) §「FAQ별 내용」14행. **확인: 날짜 미상 안내**; 현재 적용 전제는 별도 확인.
- [시간외 단가·직군·효력일](rates.md) — 교대 보상휴가의 금액 차감 순서와 단가 인상 설명을 함께 읽는 관계. 근거: [협의 기록](../../knowledge/feedback/SRC-10-late.md) §14-1. **확인: 과거 협의**; 현행 직군 단가는 SRC-13 우선.

<!-- atlas:auto:start -->

## 전체 범위 단계 지도

[전체 업무 진행 상태](../PROGRESS.md) · [소스 설명 목차](../sources/INDEX.md)
교대 시간외 입력은 통상 공통 화면·요청 함수에서 근무유형별로 갈린다. 교대 연장실비 시뮬레이션은 별도 보고서다.
**완료 범위:** 아래 단계의 지정 소스 구간·직접 관계 확인 및 탐색 연결. 전체 업무 규칙·모든 분기 검토 완료를 뜻하지 않는다. 적용 시점은 추출본이며 운영 반영일 미확인. 기존 문서에 있는 정책/과거 검토안의 구분을 유지한다.

| 단계 | 관련 설명 문서 | 관계의 의미 | 근거 파일·코드 위치 | 수준 |
|---|---|---|---|---|
| 입력 검사 | [ZHR_52TM_CHECK_INPUT_DATA](../sources/ZHR_52TM_CHECK_INPUT_DATA.md) · [ZHR_52TM_NEW_SHIFTWORK_TIME](../sources/ZHR_52TM_NEW_SHIFTWORK_TIME.md) | 공통 입력 검사에서 교대 초과시간 검사를 호출한다. | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L365 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 스케줄 조회 | [ZHR_52TM_GET_SHIFT_OT_DATA](../sources/ZHR_52TM_GET_SHIFT_OT_DATA.md) · [ZHR_GET_SHIFT_WORKER_DATA](../sources/EXT-ZHR_GET_SHIFT_WORKER_DATA.md) | 교대 월 계산은 외부 스케줄/실적 함수를 호출한다. | [ZHR_52TM_GET_SHIFT_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_SHIFT_OT_DATA/Source%20code/ZHR_52TM_GET_SHIFT_OT_DATA.abap) L102 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 단가 조회·시뮬레이션 | [ZRPTH422](../sources/ZRPTH422.md) · [ZHR_52TM_GET_SHIFT_OT_DATA](../sources/ZHR_52TM_GET_SHIFT_OT_DATA.md) · [ZTHRCOST](../sources/EXT-ZTHRCOST.md) | ZRPTH422의 조회 단계가 교대 실비 함수를 호출한다. 함수의 등급·단가·교대유형 분기를 원본에서 탐색한다. | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L427 (직접 호출)<br>[ZHR_52TM_GET_SHIFT_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_SHIFT_OT_DATA/Source%20code/ZHR_52TM_GET_SHIFT_OT_DATA.abap) L87 (데이터 조회) | 확인: 지정 구간의 정적 관계 |
| 저장·상신·승인 및 휴가 | [ZHR_52TM_MOBILE_OVERTIME_APPR](../sources/ZHR_52TM_MOBILE_OVERTIME_APPR.md) · [ZRPTH415F01](../sources/ZRPTH415F01.md) · [ZHR_52TM_AWART_LIST](../sources/ZHR_52TM_AWART_LIST.md) | 공통 시간외 처리 및 별도 대휴 정산과 분석상 연관. 교대 시뮬레이션에서 자동으로 상신·지급한다는 호출은 확인하지 않았다. | [ZHR_52TM_MOBILE_OVERTIME_APPR 원본](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[ZRPTH415F01 원본](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[ZHR_52TM_AWART_LIST 원본](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_AWART_LIST/Source%20code/ZHR_52TM_AWART_LIST.abap) — 파일 존재/헤더/정적 색인; 업무군 선정 | 분석상 연관·후보; 직접 호출 근거 아님 |

### 이 업무의 미추출·미검토 경계

워크스케줄 등록 원화면·외부 교대 집계 함수와 운영값은 없음. 시뮬레이션을 지급·월마감 완료로 보지 않는다.
화면 요청/직접 호출/Include/타입 참조/데이터 조회·저장/분석상 연관을 구분했다. 화면이 없거나 중계기·함수가 미추출이면 연결을 그 지점에서 멈춘다. 저장은 승인·지급·배포 완료의 동의어가 아니다.

<!-- atlas:auto:end -->
