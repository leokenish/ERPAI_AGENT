---
title: "대휴·익휴·보상휴가"
as_of: 2026-10-07
review_status: pending_business_review
tags: [business-map, 대휴익휴보상휴가]
---

# 대휴·익휴·보상휴가

[전체 목차](../INDEX.md)

세 휴무 제도는 발생 기준·차감·금액·기준일이 다르므로 별도로 연결한다.

## 문서 관계와 적용 시점

| 구분 | 근거 문서·위치 | 연결 의미 | 확인 수준·시점 |
|---|---|---|---|
| 익휴 안내 | [next-day-rest](../../knowledge/manuals/next-day-rest.md#%ED%86%B5%EC%83%81%C2%B7%EC%8B%9C%EC%B0%A8%20%EC%9D%B5%ED%9C%B4%20%EC%84%A4%EC%A0%95%EA%B3%BC%20%ED%95%B4%EC%A0%9C) — 8행, `익휴` | 강제 설정·사용자 해제·휴식시간 설명 | 확인: 날짜 미상 매뉴얼 / 최신24시간 예외 별도 |
| 선택 대휴 | [selective-work-202203](../../knowledge/manuals/selective-work-202203.md#%EB%8C%80%ED%9C%B4%20%EC%98%88%EC%8B%9C%EC%9D%98%20%EB%B2%94%EC%9C%84) — 30행, `## 대휴 예시` | 소정 충족과 휴일시간 조건 | 확인: SRC-02 pp.5–6 / 당시 판본 |
| 대휴 정산 | [SRC-07-late-SRC-08](../../knowledge/feedback/SRC-07-late-SRC-08.md#4.4%20%ED%9C%B4%ED%9C%B4%20%EB%8C%80%ED%9C%B4%C2%B7%EA%B7%BC%EB%AC%B4%EC%8B%9C%EA%B0%84%20%EB%B3%B4%EC%A0%95%C2%B7%EC%A0%95%EC%82%B0%EC%95%A1%20%EA%B3%84%EC%82%B0) — 168행, `정산식과 또 다른 오류 유형` | 150%에서 기지급액 차감 설명과 휴휴 오류 | 확인: SRC-07 L3490–3497 / 대상 조건 필요 |
| 누락 보정 | [SRC-10-early-SRC-11](../../knowledge/feedback/SRC-10-early-SRC-11.md#2.3%202026%EB%85%84%205%EC%9B%94%3A%20%EB%AF%B8%EA%B2%B0%2C%20%ED%9C%B4%EA%B2%8C%EC%8B%9C%EA%B0%84%2C%20%EC%86%8C%EA%B8%89%2C%20%EC%B6%9C%EC%A0%9C%EC%9C%84%EC%9B%90%2C%20%EC%83%9D%EC%84%B1%20%ED%9B%84%20%EA%B3%A0%EC%A0%95%20%EB%8D%B0%EC%9D%B4%ED%84%B0) — 83행, `5/26~5/27` | 실적 추가 후 고정 대휴시간 재생성 필요 사례 | 확인: SRC-10 L1462–1553 / 자동 갱신 일반화 금지 |

## ABAP·웹 연결

| 설명 문서 | 연결 의미·한계 |
|---|---|
| [ZHR_52TM_CW_CAL_AND_DAEH](../sources/ZHR_52TM_CW_CAL_AND_DAEH.md) | **선택 실비·대휴 계산** — 휴가·근태시간 취득（원본166행）; 휴일·인정시간을 뺀 소정 재계산（원본221행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZHR_52TM_CALC_NORM_OT_PAY](../sources/ZHR_52TM_CALC_NORM_OT_PAY.md) | **시간외 항목별 실비** — 야간시간 산정 FORM 호출（원본112행）; 야간실비 금액 필드（원본173행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZRPTH409](../sources/ZRPTH409.md) | **재량 대휴관리** — 소스 헤더의 업무 명칭（원본3행）. 헤더 기반 후보이며 운영 사용·업무의 세부 구현은 미확인. |

## 회의·결정·검증

- [회의 자료와 결정 이력](../meetings-decisions.md) — 해당 업무의 협의는 위 문서 근거를 따른다. 독립 회의록 없음; 회의 안내를 결정문으로 보지 않는다.
- [기존 회귀 질문](../../tests/business-qa.md) — Q07, Q16, Q22, Q34. 검증 항목과 업무의 연결은 **검토자 선정**이며 통과 판정이 아니다. 일반 답변 생성 시 기대답변을 근거로 읽지 않는다.
- [검증 범위와 부족 자료](../verification.md) — 링크 존재 검사와 업무·SAP 검증을 구분한다.

## 함께 볼 업무

- [선택근무](selective.md) — 소정 충족 여부와 휴일근로가 선택 대휴 조건으로 이어지는 관계. 근거: [선택 매뉴얼](../../knowledge/manuals/selective-work-202203.md) §「대휴 예시의 범위」, SRC-02 pp.5–6. **확인: 2022년 문서 기준**.
- [교대근무·보상휴가](shift.md) — 교대 보상휴가 차감 순서를 대휴·익휴와 구분해 비교한다. 근거: [협의 기록](../../knowledge/feedback/SRC-10-late.md) §14-1. **확인: 당시 담당자 설명**; 세 제도가 같은 계산이라는 뜻은 아니다.
- [간주근무](deemed.md) — 선택 종료일과 간주 시작일에 따른 대휴 기준을 함께 검토해야 하는 관계. 근거: [미확인 사항](../../knowledge/OPEN_QUESTIONS.md) Q06, 11행. **미확인 항목의 연결**; 공식 기준으로 확정하지 않는다.
- [재량근무](discretionary.md) — 재량 대휴의 직무별 금액 설명과 전용 관리 후보를 연결한다. 근거: [협의 기록](../../knowledge/feedback/SRC-07-late-SRC-08.md) §4.4, 170행 및 [ZRPTH409](../sources/ZRPTH409.md) 원본3행. **문서 사례 확인·헤더 기반 구현 후보**.

<!-- atlas:auto:start -->

## 전체 범위 단계 지도

[전체 업무 진행 상태](../PROGRESS.md) · [소스 설명 목차](../sources/INDEX.md)
근무유형별 발생·사용·취소·현금정산을 구별한다. 세 휴무 제도를 동일한 데이터/금액으로 합치지 않는다.
**완료 범위:** 아래 단계의 지정 소스 구간·직접 관계 확인 및 탐색 연결. 전체 업무 규칙·모든 분기 검토 완료를 뜻하지 않는다. 적용 시점은 추출본이며 운영 반영일 미확인. 기존 문서에 있는 정책/과거 검토안의 구분을 유지한다.

| 단계 | 관련 설명 문서 | 관계의 의미 | 근거 파일·코드 위치 | 수준 |
|---|---|---|---|---|
| 익휴 검사 | [ZHR_52TM_CHECK_TOMOH](../sources/ZHR_52TM_CHECK_TOMOH.md) · [ZHR_52TM_CALC_WORK_TIME_DAYILY](../sources/ZHR_52TM_CALC_WORK_TIME_DAYILY.md) | CHECK_TOMOH에서 일일 시간 계산을 호출한다. 조건과 분기는 함수 L1–100 전체를 추가 확인할 수 있다. | [ZHR_52TM_CHECK_TOMOH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_TOMOH/Source%20code/ZHR_52TM_CHECK_TOMOH.abap) L32, 79 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 탄력 대휴 검사 | [ZHR_52TM_REAL_WORK_TIME](../sources/ZHR_52TM_REAL_WORK_TIME.md) · [ZHR_52TM_CHECK_HOLIDAY_ZDAEH](../sources/ZHR_52TM_CHECK_HOLIDAY_ZDAEH.md) | 탄력 실적 처리 함수가 대휴 발생 검사 함수를 호출한다. | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L421 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 유형별 대휴 생산자 | [ZHR_52TM_CW_CAL_AND_DAEH](../sources/ZHR_52TM_CW_CAL_AND_DAEH.md) · [ZRPTH409F01](../sources/ZRPTH409F01.md) · [ZRPTH414](../sources/ZRPTH414.md) · [ZRPTH419F01](../sources/ZRPTH419F01.md) | 선택 계산, 재량·간주 대휴 프로그램은 분석상 같은 대휴 업무에 속하지만 산식·DB 변경 위치가 서로 다르다. | [ZHR_52TM_CW_CAL_AND_DAEH 원본](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[ZRPTH409F01 원본](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[ZRPTH414 원본](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[ZRPTH419F01 원본](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) — 파일 존재/헤더/정적 색인; 업무군 선정 | 분석상 연관·후보; 직접 호출 근거 아님 |
| 정산 조회·확정 | [ZRPTH415](../sources/ZRPTH415.md) · [ZRPTH415F01](../sources/ZRPTH415F01.md) · [ZTHRBS01](../sources/EXT-ZTHRBS01.md) · [HR_INFOTYPE_OPERATION](../sources/EXT-HR_INFOTYPE_OPERATION.md) | 415 F01은 ZTHRBS01/PA2010을 읽고 대휴 정산 표시를 갱신한다. L1425–1538에서는 임금유형 8000·EXBEL=X를 구성하여 정보형 INS를 요청한다. | [ZRPTH415.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415/source/ZRPTH415.abap) L21 (Include)<br>[ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L1460, 1658 (데이터 저장)<br>[ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L1515, 1710 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 후속 지급 | [ZRPTH2012_MF01](../sources/ZRPTH2012_MF01.md) | PA2010의 결과를 사용하는 FI 처리와 데이터상 연관이 있다. 대휴 정산 버튼이 FI·은행 지급을 자동 실행한다는 뜻은 아니다. | [ZRPTH2012_MF01 원본](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) — 파일 존재/헤더/정적 색인; 업무군 선정 | 분석상 연관·후보; 직접 호출 근거 아님 |

### 이 업무의 미추출·미검토 경계

휴가 사용/취소 원시스템, 전체 발생 산식, 외부 DDIC와 정산대상 운영 행, 실제 지급 여부 미확인.
화면 요청/직접 호출/Include/타입 참조/데이터 조회·저장/분석상 연관을 구분했다. 화면이 없거나 중계기·함수가 미추출이면 연결을 그 지점에서 멈춘다. 저장은 승인·지급·배포 완료의 동의어가 아니다.

<!-- atlas:auto:end -->
