---
title: "ZHR_52TM_WKTYPE — [52시간] 근로유형정보 I/F"
as_of: 2026-10-07
review_status: pending_business_review
tags: [근무현황조회, 대휴익휴보상휴가, 선택근무, 시차근무대상자관리, 월정산전표지급, 재량근무, 탄력근무, 특별연장재난방송]
---

# ZHR_52TM_WKTYPE — [52시간] 근로유형정보 I/F

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 근로유형정보 I/F.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE/Changing.xml) | 16행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE/Exception.xml) | 16행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE/Export.xml) | 28행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE/Import.xml) | 16행; 원본 보존 |
| [ZHR_52TM_WKTYPE.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE/Source%20code/ZHR_52TM_WKTYPE.abap) | 25행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE/Tables.xml) | 16행; 원본 보존 |
| [../../../Include/LZHR008_2U10.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U10.abap) | 25행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U10.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U10.abap) L1 | LZHR008_2U10: API 본문과 행말 공백 제외 본문 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `RESULTTAB` | HRECM00KEYANDTEXTTAB | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE/Export.xml) L8 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [HR_ECM_GET_ALL_DOMAIN_VALUE](EXTERNAL_DEPENDENCIES.md#HR_ECM_GET_ALL_DOMAIN_VALUE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_WKTYPE.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE/Source%20code/ZHR_52TM_WKTYPE.abap) L10 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [FLEX_WORK_WEEKLY_LIST](FLEX_WORK_WEEKLY_LIST.md) | 웹 요청 | [FLEX_WORK_WEEKLY_LIST.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_WEEKLY_LIST/Layout/FLEX_WORK_WEEKLY_LIST.htm) L190 |
| [FLEX_WORK_WEEKLY_LIST_ADM](FLEX_WORK_WEEKLY_LIST_ADM.md) | 웹 요청 | [FLEX_WORK_WEEKLY_LIST_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_WEEKLY_LIST_ADM/Layout/FLEX_WORK_WEEKLY_LIST_ADM.htm) L192 |
| [FLEX_WORK_WEEKLY_LIST_ESS](FLEX_WORK_WEEKLY_LIST_ESS.md) | 웹 요청 | [FLEX_WORK_WEEKLY_LIST_ESS.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_WEEKLY_LIST_ESS/Layout/FLEX_WORK_WEEKLY_LIST_ESS.htm) L193 |
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L23 |
| [MZH432F01](MZH432F01.md) | 직접 호출 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L412 |
| [ZHR_52TM_MONTHLY_PAYMENT](ZHR_52TM_MONTHLY_PAYMENT.md) | 직접 호출 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L171 |
| [ZHR_52TM_REAL_WORK_TIME_TEAM](ZHR_52TM_REAL_WORK_TIME_TEAM.md) | 직접 호출 | [ZHR_52TM_REAL_WORK_TIME_TEAM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME_TEAM/Source%20code/ZHR_52TM_REAL_WORK_TIME_TEAM.abap) L113 |
| [ZHR_52TM_REAL_WORK_TIME_TEAM_M](ZHR_52TM_REAL_WORK_TIME_TEAM_M.md) | 직접 호출 | [ZHR_52TM_REAL_WORK_TIME_TEAM_M.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME_TEAM_M/Source%20code/ZHR_52TM_REAL_WORK_TIME_TEAM_M.abap) L122 |
| [ZHR_52TM_WKTYPE_PERIOD](ZHR_52TM_WKTYPE_PERIOD.md) | 직접 호출 | [ZHR_52TM_WKTYPE_PERIOD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Source%20code/ZHR_52TM_WKTYPE_PERIOD.abap) L32 |
| [ZRPTH407F01](ZRPTH407F01.md) | 직접 호출 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L230 |
| [ZRPTH408F01](ZRPTH408F01.md) | 직접 호출 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L320 |
| [ZRPTH409F01](ZRPTH409F01.md) | 직접 호출 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L325 |
| [ZRPTH410F01](ZRPTH410F01.md) | 직접 호출 | [ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap) L248, 1535, 1695 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
