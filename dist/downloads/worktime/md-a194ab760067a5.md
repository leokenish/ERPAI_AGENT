---
title: "ZHR_52TM_CW_CHECK_DATA — 선택 입력 검사 분기"
as_of: 2026-10-07
review_status: pending_business_review
tags: [PC모바일공통웹, 선택근무, 통합결재, 퇴직자관리자입력검토, 특별연장재난방송]
---

# ZHR_52TM_CW_CHECK_DATA — 선택 입력 검사 분기

[소스 설명 목차](INDEX.md) · [원본 파일](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Source%20code/ZHR_52TM_CW_CHECK_DATA.abap)

선택 입력 검사를 공통 FORM으로 전달한다.

확인 수준: 표시한 소스 구간 정적 확인; 운영 실행 검증 아님. 원본 경로·파일은 그대로 유지한다.

## 근거 위치

| 위치 | 관계의 의미 | 근거 구문 |
|---|---|---|
| 25행 | 선택 실적 검사 호출 | `PERFORM b_cw_check_data USING i_pernr` |
| 60행 | 추가 검사 경로 호출 | `PERFORM k_cw_check_data USING i_pernr` |

## 관련 업무

<!-- topics -->
- [퇴직자·관리자 입력 검토](../topics/retired.md) — 이 소스를 검토하는 업무 지도.

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 데이터 체크 - 선택근로제.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Changing.xml) | 61행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Exception.xml) | 46행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Export.xml) | 69행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Import.xml) | 89행; 원본 보존 |
| [ZHR_52TM_CW_CHECK_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Source%20code/ZHR_52TM_CW_CHECK_DATA.abap) | 75행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Tables.xml) | 46행; 원본 보존 |
| [../../../Include/LZHR008_3U01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3U01.abap) | 75행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_3U01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3U01.abap) L1 | LZHR008_3U01: API 본문과 행말 공백 제외 본문 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Changing | `CS_ZSHR0141` | [ZSHR0141](ZSHR0141.md) | X | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Changing.xml) L8 |
| Export | `E_RETURN` | BAPIRETURN1 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Export.xml) L8 |
| Export | `E_ZNOWK` | [ZENOWK](ZENOWK.md) | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Export.xml) L19 |
| Import | `I_CASE` | CHAR1 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Import.xml) L8 |
| Import | `I_PERNR` | PERSNO | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Import.xml) L22 |
| Import | `I_DATUM` | DATS | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Import.xml) L36 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_3F01](LZHR008_3F01.md) | **FORM 호출** — A_CW_CHECK_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap L13; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_CHECK_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Source%20code/ZHR_52TM_CW_CHECK_DATA.abap) L18 |
| [LZHR008_3F01](LZHR008_3F01.md) | **FORM 호출** — B_CW_CHECK_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap L106; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_CHECK_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Source%20code/ZHR_52TM_CW_CHECK_DATA.abap) L25 |
| [LZHR008_3F01](LZHR008_3F01.md) | **FORM 호출** — D_CW_CHECK_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap L388; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_CHECK_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Source%20code/ZHR_52TM_CW_CHECK_DATA.abap) L37 |
| [LZHR008_3F01](LZHR008_3F01.md) | **FORM 호출** — E_CW_CHECK_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap L516; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_CHECK_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Source%20code/ZHR_52TM_CW_CHECK_DATA.abap) L44 |
| [LZHR008_3F01](LZHR008_3F01.md) | **FORM 호출** — F_CW_CHECK_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap L551; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_CHECK_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Source%20code/ZHR_52TM_CW_CHECK_DATA.abap) L49 |
| [LZHR008_3F01](LZHR008_3F01.md) | **FORM 호출** — G_CW_CHECK_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap L817; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_CHECK_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Source%20code/ZHR_52TM_CW_CHECK_DATA.abap) L54 |
| [LZHR008_3F01](LZHR008_3F01.md) | **FORM 호출** — H_CW_CHECK_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap L886; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_CHECK_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Source%20code/ZHR_52TM_CW_CHECK_DATA.abap) L69 |
| [LZHR008_3F01](LZHR008_3F01.md) | **FORM 호출** — K_CW_CHECK_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap L650; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_CHECK_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Source%20code/ZHR_52TM_CW_CHECK_DATA.abap) L60 |
| [ZENOWK](ZENOWK.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Export.xml) L23 |
| [ZSHR0141](ZSHR0141.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Changing.xml) L15 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [APP_DAILY_WORK_MONTHLY_CONDITION](APP_DAILY_WORK_MONTHLY_CONDITION.md) | 웹 요청 | [APP_DAILY_WORK_MONTHLY_CONDITION.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/APP_DAILY_WORK_MONTHLY_CONDITION/Layout/APP_DAILY_WORK_MONTHLY_CONDITION.htm) L223, 398 |
| [DAILY_OT_TIME](DAILY_OT_TIME.md) | 웹 요청 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L576 |
| [DAILY_WORK_DETAIL](DAILY_WORK_DETAIL.md) | 웹 요청 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L610 |
| [DAILY_WORK_DETAIL_ADM](DAILY_WORK_DETAIL_ADM.md) | 웹 요청 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L649 |
| [DAILY_WORK_INPUT](DAILY_WORK_INPUT.md) | 웹 요청 | [DAILY_WORK_INPUT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT/Layout/DAILY_WORK_INPUT.htm) L710 |
| [DAILY_WORK_INPUT_ADM](DAILY_WORK_INPUT_ADM.md) | 웹 요청 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L726 |
| [DAILY_WORK_MODIFY](DAILY_WORK_MODIFY.md) | 웹 요청 | [DAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_MODIFY/Layout/DAILY_WORK_MODIFY.htm) L706 |
| [DAILY_WORK_MODIFY_ADM](DAILY_WORK_MODIFY_ADM.md) | 웹 요청 | [DAILY_WORK_MODIFY_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_MODIFY_ADM/Layout/DAILY_WORK_MODIFY_ADM.htm) L718 |
| [DAILY_WORK_MONTHLY_CONDITION](DAILY_WORK_MONTHLY_CONDITION.md) | 웹 요청 | [DAILY_WORK_MONTHLY_CONDITION.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_MONTHLY_CONDITION/Layout/DAILY_WORK_MONTHLY_CONDITION.htm) L185, 356 |
| [DAILY_WORK_MONTHLY_CONDITION_ADM](DAILY_WORK_MONTHLY_CONDITION_ADM.md) | 웹 요청 | [DAILY_WORK_MONTHLY_CONDITION_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_MONTHLY_CONDITION_ADM/Layout/DAILY_WORK_MONTHLY_CONDITION_ADM.htm) L227, 413 |
| [DAILY_WORK_MONTHLY_CONDITION_MANAGER](DAILY_WORK_MONTHLY_CONDITION_MANAGER.md) | 웹 요청 | [DAILY_WORK_MONTHLY_CONDITION_MANAGER.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_MONTHLY_CONDITION_MANAGER/Layout/DAILY_WORK_MONTHLY_CONDITION_MANAGER.htm) L156, 345 |
| [LZHR008_3UXX](LZHR008_3UXX.md) | Include | [LZHR008_3UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3UXX.abap) L5 |
| [MDAILY_WORK_DETAIL](MDAILY_WORK_DETAIL.md) | 웹 요청 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L637 |
| [MDAILY_WORK_DETAIL_new](MDAILY_WORK_DETAIL_new.md) | 웹 요청 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L106 |
| [MDAILY_WORK_INPUT](MDAILY_WORK_INPUT.md) | 웹 요청 | [MDAILY_WORK_INPUT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT/Layout/MDAILY_WORK_INPUT.htm) L759 |
| [MDAILY_WORK_INPUT_new](MDAILY_WORK_INPUT_new.md) | 웹 요청 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L97 |
| [MDAILY_WORK_MODIFY](MDAILY_WORK_MODIFY.md) | 웹 요청 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L768 |
| [MDAILY_WORK_MODIFY_new](MDAILY_WORK_MODIFY_new.md) | 웹 요청 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L111 |

### 관련 업무와 미확인 범위

- [selective](../topics/selective.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
