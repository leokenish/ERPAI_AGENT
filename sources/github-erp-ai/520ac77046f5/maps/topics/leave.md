---
title: "휴가·공가·반차"
as_of: 2026-10-07
review_status: pending_business_review
tags: [business-map, 휴가공가반차]
---

# 휴가·공가·반차

[전체 목차](../INDEX.md)

건강검진 공가, 소정 차감, 통상 입력 방식, 휴가 취소반려 이력을 연결한다.

## 문서 관계와 적용 시점

| 구분 | 근거 문서·위치 | 연결 의미 | 확인 수준·시점 |
|---|---|---|---|
| 규정 판본 | [employment-rules-20260227](../../knowledge/policies/employment-rules-20260227.md#%EC%97%85%EB%AC%B4%20%EC%A7%88%EB%AC%B8%EC%97%90%20%EC%9E%90%EC%A3%BC%20%EC%93%B0%EB%8A%94%20%EC%A1%B0%ED%95%AD) — 29행, `공가/병가` | 종합검진 연1일·일반검진 반일 | 확인: SRC-01 pp.7–8 / 2026-02-27 판본 |
| 운영 사례 | [SRC-10-late](../../knowledge/feedback/SRC-10-late.md#4.%20%EA%B0%99%EC%9D%80%20%EB%82%A0%20%EA%B3%B5%EA%B0%80%20%EB%B0%98%EC%B0%A8%2B%EC%97%B0%EC%B0%A8%20%EB%B0%98%EC%B0%A8%EC%99%80%20%EC%84%A0%ED%83%9D%20%EC%86%8C%EC%A0%95%EC%8B%9C%EA%B0%84%20%EC%88%98%EB%8F%99%20%EB%B3%B4%EC%A0%95) — 56행, `## 4. 같은 날 공가` | 한 날짜 공가·연차 반차 병용 누락과 소정4시간 수동 보정 | 확인: SRC-10 L2112–2142, L2740–2766 / 자동기능 완료 아님 |
| 현재 입력 | [overtime-start-time](../../knowledge/processes/overtime-start-time.md#%EC%A0%81%EC%9A%A9%20%EA%B8%B0%EC%A4%80) — 10행, `## 적용 기준` | 통상·시차 반차 입력과 선택 실제시각 입력의 차이 | 확인: SRC-14 사용자 정정 |
| 정정·롤백 | [TIMELINE](../../knowledge/decisions/TIMELINE.md#%EC%8B%9C%EC%A0%90%EB%B3%84%20%ED%98%91%EC%9D%98%C2%B7%EB%B3%80%EA%B2%BD%20%EC%9D%B4%EB%A0%A5) — 25행, `2026-09-07` | 휴가 변경 후 회귀·롤백 이력 | 확인: 보고 이력 / 전면 해결 미확인 |

## ABAP·웹 연결

| 설명 문서 | 연결 의미·한계 |
|---|---|
| [ZHR_52TM_AWART_LIST](../sources/ZHR_52TM_AWART_LIST.md) | **휴가·공가 인정시간** — 연차 반일은 일 기준시간의 절반（원본187행）; 자녀돌봄 반일 조건에서 4시간 설정（원본225행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZHR_52TM_CW_CAL_AND_DAEH](../sources/ZHR_52TM_CW_CAL_AND_DAEH.md) | **선택 실비·대휴 계산** — 휴가·근태시간 취득（원본166행）; 휴일·인정시간을 뺀 소정 재계산（원본221행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZHR_52TM_GET_OVERTIME_DATA](../sources/ZHR_52TM_GET_OVERTIME_DATA.md) | **통상·시차 계산과 실비 표시** — 일별 시간·금액 처리 FORM 호출（원본61행）; 시차 7시간/휴게시간 조건（원본133행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |

## 회의·결정·검증

- [회의 자료와 결정 이력](../meetings-decisions.md) — 해당 업무의 협의는 위 문서 근거를 따른다. 독립 회의록 없음; 회의 안내를 결정문으로 보지 않는다.
- [기존 회귀 질문](../../tests/business-qa.md) — Q03, Q08, Q09, Q10, Q20, Q37, Q38. 검증 항목과 업무의 연결은 **검토자 선정**이며 통과 판정이 아니다. 일반 답변 생성 시 기대답변을 근거로 읽지 않는다.
- [검증 범위와 부족 자료](../verification.md) — 링크 존재 검사와 업무·SAP 검증을 구분한다.

## 함께 볼 업무

- [선택근무](selective.md) — 휴가 인정시간이 선택 소정시간 계산에 들어가는 관계. 근거: [ZHR_52TM_CW_CAL_AND_DAEH](../sources/ZHR_52TM_CW_CAL_AND_DAEH.md) 원본166·221행. **확인: 정적 소스**.
- [통상·시차 시간외 입력](ordinary.md) — 반차를 사용해도 통상·시차 입력 시작시각을 원래 출근시각으로 잡는 관계. 근거: [입력 기준](../../knowledge/processes/overtime-start-time.md) §「적용 기준」, SRC-14. **확인: 사용자 최종 정정**.
- [대휴·익휴·보상휴가](rest.md) — 휴가 인정시간과 소정 재계산이 선택 실비·대휴 계산 함수에 모이는 관계. 근거: [ZHR_52TM_CW_CAL_AND_DAEH](../sources/ZHR_52TM_CW_CAL_AND_DAEH.md) 원본166·221행. **확인: 정적 소스**; 모든 휴가가 동일한 대휴 효과를 갖는다는 뜻은 아니다.

<!-- atlas:auto:start -->

## 전체 범위 단계 지도

[전체 업무 진행 상태](../PROGRESS.md) · [소스 설명 목차](../sources/INDEX.md)
휴가 신청 업무 전체 대신 근로시간 코드의 근태 입력·조회·차감 연계를 확인한다. 건강검진 공가와 과거 수동 보정 이력은 기존 지식의 시점 구분을 따른다.
**완료 범위:** 아래 단계의 지정 소스 구간·직접 관계 확인 및 탐색 연결. 전체 업무 규칙·모든 분기 검토 완료를 뜻하지 않는다. 적용 시점은 추출본이며 운영 반영일 미확인. 기존 문서에 있는 정책/과거 검토안의 구분을 유지한다.

| 단계 | 관련 설명 문서 | 관계의 의미 | 근거 파일·코드 위치 | 수준 |
|---|---|---|---|---|
| 화면 조회 | [FLEX_WORK_PLAN_ESTABLISH](../sources/FLEX_WORK_PLAN_ESTABLISH.md) · [ZHR_52TM_AWART_LIST](../sources/ZHR_52TM_AWART_LIST.md) | 탄력 계획 화면은 AWART_LIST를 요청한다. | [FLEX_WORK_PLAN_ESTABLISH.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_ESTABLISH/Layout/FLEX_WORK_PLAN_ESTABLISH.htm) L1162 (웹 요청) | 확인: 지정 구간의 정적 관계 |
| 근태·휴일 정보 취득 | [ZHR_52TM_AWART_LIST](../sources/ZHR_52TM_AWART_LIST.md) · [DAY_ATTRIBUTES_GET](../sources/EXTERNAL_DEPENDENCIES.md#DAY_ATTRIBUTES_GET) · [ZTHRBS01](../sources/EXT-ZTHRBS01.md) | 공휴일은 외부 달력 함수, 근태는 소스에 있는 테이블 참조로 확인한다. | [ZHR_52TM_AWART_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_AWART_LIST/Source%20code/ZHR_52TM_AWART_LIST.abap) L100 (직접 호출)<br>[ZHR_52TM_AWART_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_AWART_LIST/Source%20code/ZHR_52TM_AWART_LIST.abap) L279 (데이터 조회) | 확인: 지정 구간의 정적 관계 |
| 초과시간 검사로 전달 | [ZHR_52TM_NEW_ORDINARY_TIME2](../sources/ZHR_52TM_NEW_ORDINARY_TIME2.md) · [ZHR_52TM_AWART_LIST](../sources/ZHR_52TM_AWART_LIST.md) | 통상 주간 검사에서 휴무정보 함수를 호출한다. 특정 0원 결과를 정책 결함으로 단정하지 않는다. | [ZHR_52TM_NEW_ORDINARY_TIME2.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_ORDINARY_TIME2/Source%20code/ZHR_52TM_NEW_ORDINARY_TIME2.abap) L53 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 신청·승인·취소 | [ZHR_52TM_AWART_LIST](../sources/ZHR_52TM_AWART_LIST.md) | 이번 추출만으로 휴가 결재 체인을 완성할 수 없다. 선택/탄력의 휴가 조회 연결과 휴가 시스템 자체의 저장·승인은 별개다. | [ZHR_52TM_AWART_LIST 원본](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_AWART_LIST/Source%20code/ZHR_52TM_AWART_LIST.abap) — 파일 존재/헤더/정적 색인; 업무군 선정 | 분석상 연관·후보; 직접 호출 근거 아님 |

### 이 업무의 미추출·미검토 경계

휴가 신청·승인·취소반려의 본체 및 미제공 첨부, 운영 달력·근태 DB 행은 미확인.
화면 요청/직접 호출/Include/타입 참조/데이터 조회·저장/분석상 연관을 구분했다. 화면이 없거나 중계기·함수가 미추출이면 연결을 그 지점에서 멈춘다. 저장은 승인·지급·배포 완료의 동의어가 아니다.

<!-- atlas:auto:end -->
