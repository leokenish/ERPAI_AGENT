---
title: "시간외 단가·직군·효력일"
as_of: 2026-10-07
review_status: pending_business_review
tags: [business-map, 시간외단가등급]
---

# 시간외 단가·직군·효력일

[전체 목차](../INDEX.md)

2026-09-01 기준 정책과 과거 협의안·개별 마스터 반영을 구분한다.

## 문서 관계와 적용 시점

| 구분 | 근거 문서·위치 | 연결 의미 | 확인 수준·시점 |
|---|---|---|---|
| 현재 기준 | [overtime-rate-20260901](../../knowledge/policies/overtime-rate-20260901.md#%EC%A7%81%EA%B5%B0%EB%B3%84%20%ED%98%84%ED%96%89%20%EA%B8%B0%EC%A4%80%20%E2%80%94%20SRC-13%20%ED%9B%84%EC%86%8D%20%EC%A0%95%EC%A0%95) — 18행, `## 직군별 현행 기준` | 정규직9,240원; 연봉계약·특정업무 모두A9,240원; 방송지원D5,400원 | 확인: SRC-12/13 사용자 설명 / SAP배포 검증 아님 |
| 과거 협의 | [SRC-10-late](../../knowledge/feedback/SRC-10-late.md#14-2.%207%EC%9B%94%2029%EC%9D%BC%208~9%EC%9B%94%20%EA%B1%B8%EC%B9%9C%20%EC%84%A0%ED%83%9D%EA%B7%BC%EB%AC%B4%20%EA%B3%84%EC%82%B0%20%ED%95%A9%EC%9D%98) — 142행, `### 14-2.` | 근무일·연장 발생일별 단가 적용과 당시 예외 | 확인: 2026-07-29 협의 / 직군 기준은 후속 정정 우선 |
| 후속 정정 | [FB-20260923-002](../../harness/feedback/FB-20260923-002.md#%EC%97%85%EB%AC%B4%20%ED%94%BC%EB%93%9C%EB%B0%B1) — 8행, `사용자 정정` | 방송지원 비D8,400원 등 기존 현행 설명 대체 | 확인: 사용자 정정 / 과거 기록 보존 |
| 미완료 범위 | [OPEN_QUESTIONS](../../knowledge/OPEN_QUESTIONS.md#%EB%AF%B8%ED%99%95%EC%9D%B8%20%EC%82%AC%ED%95%AD%EA%B3%BC%20%EC%9E%90%EB%A3%8C%20%ED%92%88%EC%A7%88%20%EC%9D%B4%EC%8A%88) — 18행, ` /  Q13` | 정책 확인과 과거 입력 보정 완료를 분리 | 미확인: 개인 마스터·지급 검증 |

## ABAP·웹 연결

| 설명 문서 | 연결 의미·한계 |
|---|---|
| [ZHR_52TM_GET_PERSONNEL_DATA_N](../sources/ZHR_52TM_GET_PERSONNEL_DATA_N.md) | **근무일 인사·등급 검사** — 기준일 인수의 기본값 SY-DATUM（원본6행）; 외부 인사조회 호출（원본39행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZHR_52TM_CALC_NORM_OT_PAY](../sources/ZHR_52TM_CALC_NORM_OT_PAY.md) | **시간외 항목별 실비** — 야간시간 산정 FORM 호출（원본112행）; 야간실비 금액 필드（원본173행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZHR_52TM_CW_CAL_AND_DAEH](../sources/ZHR_52TM_CW_CAL_AND_DAEH.md) | **선택 실비·대휴 계산** — 휴가·근태시간 취득（원본166행）; 휴일·인정시간을 뺀 소정 재계산（원본221행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |

## 회의·결정·검증

- [회의 자료와 결정 이력](../meetings-decisions.md) — 해당 업무의 협의는 위 문서 근거를 따른다. 독립 회의록 없음; 회의 안내를 결정문으로 보지 않는다.
- [기존 회귀 질문](../../tests/business-qa.md) — Q18, Q19, Q35, Q36. 검증 항목과 업무의 연결은 **검토자 선정**이며 통과 판정이 아니다. 일반 답변 생성 시 기대답변을 근거로 읽지 않는다.
- [검증 범위와 부족 자료](../verification.md) — 링크 존재 검사와 업무·SAP 검증을 구분한다.

## 함께 볼 업무

- [통상·시차 시간외 입력](ordinary.md) — 일별 계산금액을 검토할 때 직군 단가·효력일을 함께 확인하는 분석 경로. 근거: [현행 단가](../../knowledge/policies/overtime-rate-20260901.md) §「직군별 현행 기준 — SRC-13 후속 정정」. **분석상 연결**; 운영 마스터 반영은 미확인.
- [선택근무](selective.md) — 8~9월에 걸친 선택기간은 근무일·연장 발생일의 단가 적용 검토로 이어진다. 근거: [협의 기록](../../knowledge/feedback/SRC-10-late.md) §14-2. **확인: 2026-07-29 협의**; 직군 기준은 SRC-13 후속 정정을 함께 본다.
- [월정산·확정·전표·지급](settlement.md) — 확정·재정산 금액의 근무일별 단가와 마스터를 대조하는 분석 경로. 근거: [현행 단가](../../knowledge/policies/overtime-rate-20260901.md) §「직군별 현행 기준 — SRC-13 후속 정정」 및 [미확인 사항](../../knowledge/OPEN_QUESTIONS.md) Q13, 18행. **정책 확인·실제 반영 미확인**.

<!-- atlas:auto:start -->

## 전체 범위 단계 지도

[전체 업무 진행 상태](../PROGRESS.md) · [소스 설명 목차](../sources/INDEX.md)
현재 정책은 기존 SRC-12/13 정정 문서에 따른다. 코드의 등급·유효기간·버전 조건과 현재 단가 운영값을 분리한다.
**완료 범위:** 아래 단계의 지정 소스 구간·직접 관계 확인 및 탐색 연결. 전체 업무 규칙·모든 분기 검토 완료를 뜻하지 않는다. 적용 시점은 추출본이며 운영 반영일 미확인. 기존 문서에 있는 정책/과거 검토안의 구분을 유지한다.

| 단계 | 관련 설명 문서 | 관계의 의미 | 근거 파일·코드 위치 | 수준 |
|---|---|---|---|---|
| 등급 관리 | [ZRPTH412](../sources/ZRPTH412.md) · [ZRPTH412F01](../sources/ZRPTH412F01.md) · [ZTHRBS05](../sources/EXT-ZTHRBS05.md) | 연봉계약직 등급관리 412 F01이 ZTHRBS05를 조회·변경한다. | [ZRPTH412.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412/source/ZRPTH412.abap) L19 (Include)<br>[ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L542, 675 (데이터 조회)<br>[ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L689, 749 (데이터 저장) | 확인: 지정 구간의 정적 관계 |
| 교대 단가 조회 | [ZHR_52TM_GET_SHIFT_OT_DATA](../sources/ZHR_52TM_GET_SHIFT_OT_DATA.md) · [ZTHRCOST](../sources/EXT-ZTHRCOST.md) | GET_SHIFT_OT_DATA L85–97의 기준단가·등급·유효기간·활성버전 조건. 금액이 올바르게 지급됐다는 증거는 아니다. | [ZHR_52TM_GET_SHIFT_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_SHIFT_OT_DATA/Source%20code/ZHR_52TM_GET_SHIFT_OT_DATA.abap) L87 (데이터 조회) | 확인: 지정 구간의 정적 관계 |
| 선택 정산 단가 조회 | [ZHR_52TM_CW_CAL_AND_DAEH](../sources/ZHR_52TM_CW_CAL_AND_DAEH.md) · [ZTHRCOST](../sources/EXT-ZTHRCOST.md) | 선택 실비·대휴 계산에서도 단가 테이블을 읽는다. | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L2051, 2066 (데이터 조회) | 확인: 지정 구간의 정적 관계 |
| 유지보수·적용 시점 | [ZHR_52TM_CALC_NORM_OT_PAY](../sources/ZHR_52TM_CALC_NORM_OT_PAY.md) · [ZHR_52TM_GET_PERSONNEL_DATA_N](../sources/ZHR_52TM_GET_PERSONNEL_DATA_N.md) | 현재 기준/과거 검토안은 기존 지도 문서관계를 따른다. 코드의 하드코딩·유효기간이 사규 승인 근거는 아니다. | [ZHR_52TM_CALC_NORM_OT_PAY 원본](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_NORM_OT_PAY/Source%20code/ZHR_52TM_CALC_NORM_OT_PAY.abap) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[ZHR_52TM_GET_PERSONNEL_DATA_N 원본](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Source%20code/ZHR_52TM_GET_PERSONNEL_DATA_N.abap) — 파일 존재/헤더/정적 색인; 업무군 선정 | 분석상 연관·후보; 직접 호출 근거 아님 |

### 이 업무의 미추출·미검토 경계

미추출 ZTHRCOST/ZTHRBS05의 완전한 DDIC, 운영값·소급 적용 및 정책과 구현 일치 여부는 미확인.
화면 요청/직접 호출/Include/타입 참조/데이터 조회·저장/분석상 연관을 구분했다. 화면이 없거나 중계기·함수가 미추출이면 연결을 그 지점에서 멈춘다. 저장은 승인·지급·배포 완료의 동의어가 아니다.

<!-- atlas:auto:end -->
