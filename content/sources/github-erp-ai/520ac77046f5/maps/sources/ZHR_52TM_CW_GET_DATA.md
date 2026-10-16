---
title: "ZHR_52TM_CW_GET_DATA — [52시간] 데이터 조회 - 선택근로제"
as_of: 2026-10-07
review_status: pending_business_review
tags: [PC모바일공통웹, 근로시간알림, 근무현황조회, 선택근무, 탄력근무, 통합결재, 퇴직자관리자입력검토, 특별연장재난방송]
---

# ZHR_52TM_CW_GET_DATA — [52시간] 데이터 조회 - 선택근로제

## 누적표시 변경 검토

[선택근로 누적시간 가산 포함 분석](../topics/selective.md#%EB%88%84%EC%A0%81%EA%B7%BC%EB%A1%9C%EC%8B%9C%EA%B0%84%20%EA%B0%80%EC%82%B0%20%ED%8F%AC%ED%95%A8%20%EB%B3%80%EA%B2%BD%20%EA%B2%80%ED%86%A0%202026-10-08) — 2026-10-08, 지정 구간 정적 확인과 표시 전용 변경안. 원본 수정·운영 검증 없음.

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 데이터 조회 - 선택근로제.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Changing.xml) | 181행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Exception.xml) | 82행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Export.xml) | 94행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Import.xml) | 125행; 원본 보존 |
| [ZHR_52TM_CW_GET_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Source%20code/ZHR_52TM_CW_GET_DATA.abap) | 81행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Tables.xml) | 94행; 원본 보존 |
| [../../../Include/LZHR008_3U02.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3U02.abap) | 81행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_3U02.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3U02.abap) L1 | LZHR008_3U02: API 본문과 행말 공백 제외 본문 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Changing | `CS_ZSHR0137` | [ZSHR0137](ZSHR0137.md) | X | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Changing.xml) L8 |
| Changing | `CS_ZSHR0141` | [ZSHR0141](ZSHR0141.md) | X | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Changing.xml) L22 |
| Changing | `CS_ZSHR0139` | [ZSHR0139](ZSHR0139.md) | X | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Changing.xml) L36 |
| Changing | `CS_ZSHR0140` | [ZSHR0140](ZSHR0140.md) | X | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Changing.xml) L50 |
| Changing | `CS_ZSHR0142` | [ZSHR0142](ZSHR0142.md) | X | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Changing.xml) L64 |
| Changing | `CS_ZSHR0143` | [ZSHR0143](ZSHR0143.md) | X | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Changing.xml) L78 |
| Changing | `CS_ZSHR0144` | [ZSHR0144](ZSHR0144.md) | X | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Changing.xml) L92 |
| Export | `E_RETURN` | BAPIRETURN1 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Export.xml) L8 |
| Import | `I_CASE` | CHAR1 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Import.xml) L8 |
| Import | `I_PERNR` | PERSNO | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Import.xml) L22 |
| Import | `I_DATUM` | DATS | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Import.xml) L36 |
| Tables | `LT_ZSHR0138` | [ZSHR0138](ZSHR0138.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Tables.xml) L8 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_3F02](LZHR008_3F02.md) | **FORM 호출** — B_CW_GET_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F02.abap L15; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_GET_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Source%20code/ZHR_52TM_CW_GET_DATA.abap) L26, 35, 45 |
| [LZHR008_3F02](LZHR008_3F02.md) | **FORM 호출** — D_CW_GET_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F02.abap L372; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_GET_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Source%20code/ZHR_52TM_CW_GET_DATA.abap) L54 |
| [LZHR008_3F02](LZHR008_3F02.md) | **FORM 호출** — E_CW_GET_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F02.abap L505; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_GET_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Source%20code/ZHR_52TM_CW_GET_DATA.abap) L61 |
| [LZHR008_3F02](LZHR008_3F02.md) | **FORM 호출** — F_CW_GET_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F02.abap L546; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_GET_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Source%20code/ZHR_52TM_CW_GET_DATA.abap) L67 |
| [LZHR008_3F02](LZHR008_3F02.md) | **FORM 호출** — G_CW_GET_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F02.abap L587; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_GET_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Source%20code/ZHR_52TM_CW_GET_DATA.abap) L74 |
| [ZSHR0137](ZSHR0137.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Changing.xml) L15 |
| [ZSHR0138](ZSHR0138.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Tables.xml) L9 |
| [ZSHR0139](ZSHR0139.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Changing.xml) L43 |
| [ZSHR0140](ZSHR0140.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Changing.xml) L57 |
| [ZSHR0141](ZSHR0141.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Changing.xml) L29 |
| [ZSHR0142](ZSHR0142.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Changing.xml) L71 |
| [ZSHR0143](ZSHR0143.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Changing.xml) L85 |
| [ZSHR0144](ZSHR0144.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Changing.xml) L99 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [APP_DAILY_WORK_MONTHLY_CONDITION](APP_DAILY_WORK_MONTHLY_CONDITION.md) | 웹 요청 | [APP_DAILY_WORK_MONTHLY_CONDITION.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/APP_DAILY_WORK_MONTHLY_CONDITION/Layout/APP_DAILY_WORK_MONTHLY_CONDITION.htm) L289 |
| [DAILY_OT_TIME](DAILY_OT_TIME.md) | 웹 요청 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L679 |
| [DAILY_WORK_DETAIL](DAILY_WORK_DETAIL.md) | 웹 요청 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L665 |
| [DAILY_WORK_DETAIL_ADM](DAILY_WORK_DETAIL_ADM.md) | 웹 요청 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L704 |
| [DAILY_WORK_INPUT](DAILY_WORK_INPUT.md) | 웹 요청 | [DAILY_WORK_INPUT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT/Layout/DAILY_WORK_INPUT.htm) L787 |
| [DAILY_WORK_INPUT_ADM](DAILY_WORK_INPUT_ADM.md) | 웹 요청 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L803 |
| [DAILY_WORK_LIST_ADM](DAILY_WORK_LIST_ADM.md) | 웹 요청 | [DAILY_WORK_LIST_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_LIST_ADM/Layout/DAILY_WORK_LIST_ADM.htm) L344 |
| [DAILY_WORK_MODIFY](DAILY_WORK_MODIFY.md) | 웹 요청 | [DAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_MODIFY/Layout/DAILY_WORK_MODIFY.htm) L769 |
| [DAILY_WORK_MODIFY_ADM](DAILY_WORK_MODIFY_ADM.md) | 웹 요청 | [DAILY_WORK_MODIFY_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_MODIFY_ADM/Layout/DAILY_WORK_MODIFY_ADM.htm) L781 |
| [DAILY_WORK_MONTHLY_CONDITION](DAILY_WORK_MONTHLY_CONDITION.md) | 웹 요청 | [DAILY_WORK_MONTHLY_CONDITION.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_MONTHLY_CONDITION/Layout/DAILY_WORK_MONTHLY_CONDITION.htm) L213 |
| [DAILY_WORK_MONTHLY_CONDITION_ADM](DAILY_WORK_MONTHLY_CONDITION_ADM.md) | 웹 요청 | [DAILY_WORK_MONTHLY_CONDITION_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_MONTHLY_CONDITION_ADM/Layout/DAILY_WORK_MONTHLY_CONDITION_ADM.htm) L295 |
| [DAILY_WORK_MONTHLY_CONDITION_MANAGER](DAILY_WORK_MONTHLY_CONDITION_MANAGER.md) | 웹 요청 | [DAILY_WORK_MONTHLY_CONDITION_MANAGER.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_MONTHLY_CONDITION_MANAGER/Layout/DAILY_WORK_MONTHLY_CONDITION_MANAGER.htm) L224 |
| [LZHR008_3UXX](LZHR008_3UXX.md) | Include | [LZHR008_3UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3UXX.abap) L7 |
| [MDAILY_WORK_DETAIL](MDAILY_WORK_DETAIL.md) | 웹 요청 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L692 |
| [MDAILY_WORK_DETAIL_new](MDAILY_WORK_DETAIL_new.md) | 웹 요청 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L157 |
| [MDAILY_WORK_INPUT](MDAILY_WORK_INPUT.md) | 웹 요청 | [MDAILY_WORK_INPUT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT/Layout/MDAILY_WORK_INPUT.htm) L834 |
| [MDAILY_WORK_INPUT_new](MDAILY_WORK_INPUT_new.md) | 웹 요청 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L160 |
| [MDAILY_WORK_LIST](MDAILY_WORK_LIST.md) | 웹 요청 | [MDAILY_WORK_LIST.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_LIST/Layout/MDAILY_WORK_LIST.htm) L429 |
| [MDAILY_WORK_LIST_new](MDAILY_WORK_LIST_new.md) | 웹 요청 | [MDAILY_WORK_LIST_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_LIST_new/Layout/MDAILY_WORK_LIST_new.htm) L213 |
| [MDAILY_WORK_MODIFY](MDAILY_WORK_MODIFY.md) | 웹 요청 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L831 |
| [MDAILY_WORK_MODIFY_new](MDAILY_WORK_MODIFY_new.md) | 웹 요청 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L164 |
| [ZHR_52TM_APPROVAL_LIST](ZHR_52TM_APPROVAL_LIST.md) | 직접 호출 | [ZHR_52TM_APPROVAL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Source%20code/ZHR_52TM_APPROVAL_LIST.abap) L106 |
| [ZHR_52TM_DAILY_APPROVAL_DETAIL](ZHR_52TM_DAILY_APPROVAL_DETAIL.md) | 직접 호출 | [ZHR_52TM_DAILY_APPROVAL_DETAIL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Source%20code/ZHR_52TM_DAILY_APPROVAL_DETAIL.abap) L106 |
| [ZHR_52TM_DAILY_WEEKLY_BUSEO](ZHR_52TM_DAILY_WEEKLY_BUSEO.md) | 직접 호출 | [ZHR_52TM_DAILY_WEEKLY_BUSEO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Source%20code/ZHR_52TM_DAILY_WEEKLY_BUSEO.abap) L136 |
| [ZHR_52TM_DAILY_WEEKLY_CUM](ZHR_52TM_DAILY_WEEKLY_CUM.md) | 직접 호출 | [ZHR_52TM_DAILY_WEEKLY_CUM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_CUM/Source%20code/ZHR_52TM_DAILY_WEEKLY_CUM.abap) L19 |
| [ZHR_OVERTIME_SMS](ZHR_OVERTIME_SMS.md) | 직접 호출 | [ZHR_OVERTIME_SMS.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_OVERTIME_SMS/source/ZHR_OVERTIME_SMS.abap) L137 |

### 관련 업무와 미확인 범위

- [alerts](../topics/alerts.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [selective](../topics/selective.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
