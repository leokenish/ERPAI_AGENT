---
title: "ZHR_52TM_CALC_WORK_TIME_DAYILY — [52시간] 일일 근로시간 계산(00:00~24:00)"
as_of: 2026-10-07
review_status: pending_business_review
tags: [간주근무, 교대근무, 대휴익휴보상휴가, 선택근무, 시간외단가등급, 월정산전표지급, 인사정보형9021_9023, 탄력근무, 통상시차시간외, 통합결재, 특별연장재난방송, 휴가공가반차]
---

# ZHR_52TM_CALC_WORK_TIME_DAYILY — [52시간] 일일 근로시간 계산(00:00~24:00)

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 일일 근로시간 계산(00:00~24:00).

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Changing.xml) | 118행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Exception.xml) | 118행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Export.xml) | 196행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Import.xml) | 245행; 원본 보존 |
| [ZHR_52TM_CALC_WORK_TIME_DAYILY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Source%20code/ZHR_52TM_CALC_WORK_TIME_DAYILY.abap) | 883행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Tables.xml) | 141행; 원본 보존 |
| [../../../Include/LZHR008_2U15.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U15.abap) | 883행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U15.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U15.abap) L1 | LZHR008_2U15: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_ZRLWK_TM` | ZCHAR06 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Export.xml) L8 |
| Export | `E_ZPDWK_TM` | ZCHAR06 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Export.xml) L19 |
| Export | `E_RM1WK_TM` | ZCHAR06 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Export.xml) L30 |
| Export | `E_RM2WK_TM` | ZCHAR06 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Export.xml) L41 |
| Export | `E_RM1WK_OV` | CHAR6 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Export.xml) L52 |
| Export | `E_RM2WK_OV` | CHAR6 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Export.xml) L63 |
| Export | `E_ZPDWK_D_TM` | [ZEPDWK_TM](ZEPDWK_TM.md) | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Export.xml) L74 |
| Import | `IS_DAY` | [ZSHR0115](ZSHR0115.md) | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Import.xml) L8 |
| Import | `I_OPT` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Import.xml) L22 |
| Import | `I_NGT` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Import.xml) L36 |
| Import | `I_PERNR` | PERSNO | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Import.xml) L50 |
| Import | `I_Z52WKTP` | [ZE52WKTP](ZE52WKTP.md) | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Import.xml) L64 |
| Import | `I_Z52PRSQ` | [ZE52PRSQ](ZE52PRSQ.md) | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Import.xml) L78 |
| Import | `I_ZPLWKHR_TY` | [ZEPLWKHR_TY](ZEPLWKHR_TY.md) | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Import.xml) L92 |
| Import | `I_WK_START` | BEGDA | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Import.xml) L106 |
| Import | `I_WK_END` | ENDDA | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Import.xml) L120 |
| Tables | `T_DAY_TIME` | [ZTSHR0115](ZTSHR0115.md) | — | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Tables.xml) L8 |
| Tables | `T_DAILY` | [ZSHR0110](ZSHR0110.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Tables.xml) L19 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [HR_PROPOSE_OVERTIME](EXTERNAL_DEPENDENCIES.md#HR_PROPOSE_OVERTIME) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CALC_WORK_TIME_DAYILY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Source%20code/ZHR_52TM_CALC_WORK_TIME_DAYILY.abap) L329, 666, 768 |
| [LZHR008_2F02](LZHR008_2F02.md) | **FORM 호출** — SET_CALC_BREAK_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F02.abap L231; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CALC_WORK_TIME_DAYILY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Source%20code/ZHR_52TM_CALC_WORK_TIME_DAYILY.abap) L366, 751, 797 |
| [LZHR008_2F02](LZHR008_2F02.md) | **FORM 호출** — SET_HOUR_TO_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F02.abap L12; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CALC_WORK_TIME_DAYILY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Source%20code/ZHR_52TM_CALC_WORK_TIME_DAYILY.abap) L360, 612, 699, 720, 746, 792 |
| [SWI_DURATION_DETERMINE](EXTERNAL_DEPENDENCIES.md#SWI_DURATION_DETERMINE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CALC_WORK_TIME_DAYILY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Source%20code/ZHR_52TM_CALC_WORK_TIME_DAYILY.abap) L310, 648 |
| [ZCHAR06](EXTERNAL_DEPENDENCIES.md#ZCHAR06) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Export.xml) L12, 23, 34, 45 |
| [ZE52PRSQ](ZE52PRSQ.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Import.xml) L85 |
| [ZE52WKTP](ZE52WKTP.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Import.xml) L71 |
| [ZECNVAL](ZECNVAL.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CALC_WORK_TIME_DAYILY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Source%20code/ZHR_52TM_CALC_WORK_TIME_DAYILY.abap) L520 |
| [ZEPDWK_TM](ZEPDWK_TM.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Export.xml) L78 |
| [ZEPLWKHR_TY](ZEPLWKHR_TY.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Import.xml) L99 |
| [ZEWEEKSQ](ZEWEEKSQ.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CALC_WORK_TIME_DAYILY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Source%20code/ZHR_52TM_CALC_WORK_TIME_DAYILY.abap) L431 |
| [ZHR_52TM_CALC_BREAK_TIME](ZHR_52TM_CALC_BREAK_TIME.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CALC_WORK_TIME_DAYILY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Source%20code/ZHR_52TM_CALC_WORK_TIME_DAYILY.abap) L91 |
| [ZHR_52TM_CALC_WEEK_TIME](ZHR_52TM_CALC_WEEK_TIME.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CALC_WORK_TIME_DAYILY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Source%20code/ZHR_52TM_CALC_WORK_TIME_DAYILY.abap) L441 |
| [ZHR_MINUS_TIME_N](EXTERNAL_DEPENDENCIES.md#ZHR_MINUS_TIME_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CALC_WORK_TIME_DAYILY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Source%20code/ZHR_52TM_CALC_WORK_TIME_DAYILY.abap) L489, 620, 728 |
| [ZHR_SUM_TIME_N](EXTERNAL_DEPENDENCIES.md#ZHR_SUM_TIME_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CALC_WORK_TIME_DAYILY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Source%20code/ZHR_52TM_CALC_WORK_TIME_DAYILY.abap) L397, 408, 467, 477, 707 |
| [ZH_GET_WORKDAYS](EXTERNAL_DEPENDENCIES.md#ZH_GET_WORKDAYS) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CALC_WORK_TIME_DAYILY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Source%20code/ZHR_52TM_CALC_WORK_TIME_DAYILY.abap) L254 |
| [ZSHR0106](ZSHR0106.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CALC_WORK_TIME_DAYILY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Source%20code/ZHR_52TM_CALC_WORK_TIME_DAYILY.abap) L430 |
| [ZSHR0110](ZSHR0110.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Tables.xml) L20 |
| [ZSHR0115](ZSHR0115.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Import.xml) L15 |
| [ZSHR0115](ZSHR0115.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CALC_WORK_TIME_DAYILY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Source%20code/ZHR_52TM_CALC_WORK_TIME_DAYILY.abap) L45 |
| [ZTHR0101](ZTHR0101.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_CALC_WORK_TIME_DAYILY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Source%20code/ZHR_52TM_CALC_WORK_TIME_DAYILY.abap) L556 |
| [ZTSHR0115](ZTSHR0115.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Tables.xml) L12 |
| [ZTSHR0115](ZTSHR0115.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CALC_WORK_TIME_DAYILY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Source%20code/ZHR_52TM_CALC_WORK_TIME_DAYILY.abap) L531 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [FLEX_WORK_PERFORMANCE_INPUT](FLEX_WORK_PERFORMANCE_INPUT.md) | 웹 요청 | [FLEX_WORK_PERFORMANCE_INPUT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PERFORMANCE_INPUT/Layout/FLEX_WORK_PERFORMANCE_INPUT.htm) L1999 |
| [FLEX_WORK_PERFORMANCE_INPUT_ADM](FLEX_WORK_PERFORMANCE_INPUT_ADM.md) | 웹 요청 | [FLEX_WORK_PERFORMANCE_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PERFORMANCE_INPUT_ADM/Layout/FLEX_WORK_PERFORMANCE_INPUT_ADM.htm) L2029 |
| [FLEX_WORK_PLAN_ESTABLISH](FLEX_WORK_PLAN_ESTABLISH.md) | 웹 요청 | [FLEX_WORK_PLAN_ESTABLISH.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_ESTABLISH/Layout/FLEX_WORK_PLAN_ESTABLISH.htm) L1527 |
| [FLEX_WORK_PLAN_VIEW](FLEX_WORK_PLAN_VIEW.md) | 웹 요청 | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1272 |
| [FLEX_WORK_PLAN_VIEW2](FLEX_WORK_PLAN_VIEW2.md) | 웹 요청 | [FLEX_WORK_PLAN_VIEW2.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW2/Layout/FLEX_WORK_PLAN_VIEW2.htm) L651 |
| [FLEX_WORK_PLAN_VIEW_ADM](FLEX_WORK_PLAN_VIEW_ADM.md) | 웹 요청 | [FLEX_WORK_PLAN_VIEW_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW_ADM/Layout/FLEX_WORK_PLAN_VIEW_ADM.htm) L1304 |
| [FLEX_WORK_TIME](FLEX_WORK_TIME.md) | 웹 요청 | [FLEX_WORK_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_TIME/Layout/FLEX_WORK_TIME.htm) L686 |
| [LZHR008_2F01](LZHR008_2F01.md) | 직접 호출 | [LZHR008_2F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap) L1664, 2945 |
| [LZHR008_2F02](LZHR008_2F02.md) | 직접 호출 | [LZHR008_2F02.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F02.abap) L128, 150, 175, 198, 312 |
| [LZHR008_2F03](LZHR008_2F03.md) | 직접 호출 | [LZHR008_2F03.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap) L5646, 5696 |
| [LZHR008_2F04](LZHR008_2F04.md) | 직접 호출 | [LZHR008_2F04.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F04.abap) L1464 |
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L31 |
| [LZHR008_3F02](LZHR008_3F02.md) | 직접 호출 | [LZHR008_3F02.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F02.abap) L414 |
| [LZHR008_3F03](LZHR008_3F03.md) | 직접 호출 | [LZHR008_3F03.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap) L1278 |
| [LZHR008_3F04](LZHR008_3F04.md) | 직접 호출 | [LZHR008_3F04.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F04.abap) L639, 902 |
| [MFLEX_WORK_PERFORMANCE_INPUT](MFLEX_WORK_PERFORMANCE_INPUT.md) | 웹 요청 | [MFLEX_WORK_PERFORMANCE_INPUT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MFLEX_WORK_PERFORMANCE_INPUT/Layout/MFLEX_WORK_PERFORMANCE_INPUT.htm) L2121 |
| [MFLEX_WORK_PLAN_ESTABLISH](MFLEX_WORK_PLAN_ESTABLISH.md) | 웹 요청 | [MFLEX_WORK_PLAN_ESTABLISH.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MFLEX_WORK_PLAN_ESTABLISH/Layout/MFLEX_WORK_PLAN_ESTABLISH.htm) L1797 |
| [MFLEX_WORK_PLAN_VIEW](MFLEX_WORK_PLAN_VIEW.md) | 웹 요청 | [MFLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MFLEX_WORK_PLAN_VIEW/Layout/MFLEX_WORK_PLAN_VIEW.htm) L1340 |
| [MORD_OT_INSERT](MORD_OT_INSERT.md) | 웹 요청 | [MORD_OT_INSERT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_INSERT/Layout/MORD_OT_INSERT.htm) L2698 |
| [MORD_OT_INSERT_new](MORD_OT_INSERT_new.md) | 웹 요청 | [MORD_OT_INSERT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_INSERT_new/Layout/MORD_OT_INSERT_new.htm) L1767 |
| [MORD_OT_MODIFY](MORD_OT_MODIFY.md) | 웹 요청 | [MORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY/Layout/MORD_OT_MODIFY.htm) L2260 |
| [MORD_OT_MODIFY_new](MORD_OT_MODIFY_new.md) | 웹 요청 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L1340 |
| [ORD_OT_INSERT](ORD_OT_INSERT.md) | 웹 요청 | [ORD_OT_INSERT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_INSERT/Layout/ORD_OT_INSERT.htm) L2587 |
| [ORD_OT_MODIFY](ORD_OT_MODIFY.md) | 웹 요청 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2169 |
| [ORD_OT_TIME](ORD_OT_TIME.md) | 웹 요청 | [ORD_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_TIME/Layout/ORD_OT_TIME.htm) L2012 |
| [ZHR_52TM_APPROVE_OT_DATA](ZHR_52TM_APPROVE_OT_DATA.md) | 직접 호출 | [ZHR_52TM_APPROVE_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_OT_DATA/Source%20code/ZHR_52TM_APPROVE_OT_DATA.abap) L273 |
| [ZHR_52TM_CHECK_TOMOH](ZHR_52TM_CHECK_TOMOH.md) | 직접 호출 | [ZHR_52TM_CHECK_TOMOH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_TOMOH/Source%20code/ZHR_52TM_CHECK_TOMOH.abap) L32, 79 |
| [ZHR_52TM_CW_CAL_AND_DAEH](ZHR_52TM_CW_CAL_AND_DAEH.md) | 직접 호출 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L1075, 1354 |
| [ZHR_52TM_MONTHLY_PAYMENT](ZHR_52TM_MONTHLY_PAYMENT.md) | 직접 호출 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L457 |
| [ZHR_52TM_NEW_ORDINARY_TIME](ZHR_52TM_NEW_ORDINARY_TIME.md) | 직접 호출 | [ZHR_52TM_NEW_ORDINARY_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_ORDINARY_TIME/Source%20code/ZHR_52TM_NEW_ORDINARY_TIME.abap) L110, 252, 361 |
| [ZHR_52TM_NEW_ORDINARY_TIME2](ZHR_52TM_NEW_ORDINARY_TIME2.md) | 직접 호출 | [ZHR_52TM_NEW_ORDINARY_TIME2.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_ORDINARY_TIME2/Source%20code/ZHR_52TM_NEW_ORDINARY_TIME2.abap) L139 |
| [ZHR_52TM_ORDINARY_ZE_TIME](ZHR_52TM_ORDINARY_ZE_TIME.md) | 직접 호출 | [ZHR_52TM_ORDINARY_ZE_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_ORDINARY_ZE_TIME/Source%20code/ZHR_52TM_ORDINARY_ZE_TIME.abap) L115, 305, 466 |
| [ZRPTH410F01](ZRPTH410F01.md) | 직접 호출 | [ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap) L1066 |
| [temp](temp.md) | 웹 요청 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2148 |

### 관련 업무와 미확인 범위

- [rest](../topics/rest.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
