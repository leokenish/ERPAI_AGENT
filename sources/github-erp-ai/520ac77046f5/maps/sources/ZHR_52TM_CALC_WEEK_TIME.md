---
title: "ZHR_52TM_CALC_WEEK_TIME — [52시간] 필수근로시간"
as_of: 2026-10-07
review_status: pending_business_review
tags: [근로시간알림, 대휴익휴보상휴가, 월정산전표지급, 탄력근무, 통합결재, 특별연장재난방송, 휴가공가반차]
---

# ZHR_52TM_CALC_WEEK_TIME — [52시간] 필수근로시간

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 필수근로시간.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Changing.xml) | 94행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Exception.xml) | 94행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Export.xml) | 161행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Import.xml) | 193행; 원본 보존 |
| [ZHR_52TM_CALC_WEEK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Source%20code/ZHR_52TM_CALC_WEEK_TIME.abap) | 309행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Tables.xml) | 106행; 원본 보존 |
| [../../../Include/LZHR008_2U02.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U02.abap) | 309행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U02.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U02.abap) L1 | LZHR008_2U02: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_BEGDA` | BEGDA | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Export.xml) L8 |
| Export | `E_ENDDA` | ENDDA | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Export.xml) L19 |
| Export | `E_RETURN` | BAPIRETURN1 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Export.xml) L30 |
| Export | `E_VDSK1_TXT` | VDSK1 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Export.xml) L41 |
| Export | `E_JIKWINAME` | ZJWNAME | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Export.xml) L52 |
| Export | `E_TRFGR` | ZTRFGR | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Export.xml) L63 |
| Import | `I_PERNR` | PERSNO | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Import.xml) L8 |
| Import | `I_Z52WKTP` | [ZE52WKTP](ZE52WKTP.md) | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Import.xml) L22 |
| Import | `I_Z52PRSQ` | [ZE52PRSQ](ZE52PRSQ.md) | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Import.xml) L36 |
| Import | `I_ZPLWKHR_TY` | [ZEPLWKHR_TY](ZEPLWKHR_TY.md) | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Import.xml) L50 |
| Import | `I_BEGDA` | BEGDA | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Import.xml) L64 |
| Import | `I_ENDDA` | ENDDA | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Import.xml) L78 |
| Import | `I_OPT` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Import.xml) L92 |
| Tables | `T_DATA` | [ZSHR0106](ZSHR0106.md) | — | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Tables.xml) L8 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [DAY_ATTRIBUTES_GET](EXTERNAL_DEPENDENCIES.md#DAY_ATTRIBUTES_GET) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CALC_WEEK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Source%20code/ZHR_52TM_CALC_WEEK_TIME.abap) L107 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — CHECK_DATE: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L183; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CALC_WEEK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Source%20code/ZHR_52TM_CALC_WEEK_TIME.abap) L78 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — MAKE_CALC_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L350; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CALC_WEEK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Source%20code/ZHR_52TM_CALC_WEEK_TIME.abap) L196, 207, 286 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — MAKE_TOT_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L363; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CALC_WEEK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Source%20code/ZHR_52TM_CALC_WEEK_TIME.abap) L200, 211, 293 |
| [ZE52PRSQ](ZE52PRSQ.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Import.xml) L43 |
| [ZE52WKTP](ZE52WKTP.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Import.xml) L29 |
| [ZECNVAL](ZECNVAL.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CALC_WEEK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Source%20code/ZHR_52TM_CALC_WEEK_TIME.abap) L32 |
| [ZEPLWKHR_TY](ZEPLWKHR_TY.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Import.xml) L57 |
| [ZHR_52TM_AWART_LIST](ZHR_52TM_AWART_LIST.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CALC_WEEK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Source%20code/ZHR_52TM_CALC_WEEK_TIME.abap) L133 |
| [ZHR_52TM_GET_WORKSCHEDULE_TIME](ZHR_52TM_GET_WORKSCHEDULE_TIME.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CALC_WEEK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Source%20code/ZHR_52TM_CALC_WEEK_TIME.abap) L168 |
| [ZHR_GET_PERSONNEL_DATA_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_PERSONNEL_DATA_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CALC_WEEK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Source%20code/ZHR_52TM_CALC_WEEK_TIME.abap) L60 |
| [ZHR_MINUS_TIME_N](EXTERNAL_DEPENDENCIES.md#ZHR_MINUS_TIME_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CALC_WEEK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Source%20code/ZHR_52TM_CALC_WEEK_TIME.abap) L238, 258 |
| [ZJWNAME](EXTERNAL_DEPENDENCIES.md#ZJWNAME) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Export.xml) L56 |
| [ZSHR0106](ZSHR0106.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Tables.xml) L9 |
| [ZSHR0111](ZSHR0111.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CALC_WEEK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Source%20code/ZHR_52TM_CALC_WEEK_TIME.abap) L24 |
| [ZTHR0101](ZTHR0101.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_CALC_WEEK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Source%20code/ZHR_52TM_CALC_WEEK_TIME.abap) L127 |
| [ZTHR0102](ZTHR0102.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_CALC_WEEK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Source%20code/ZHR_52TM_CALC_WEEK_TIME.abap) L273 |
| [ZTHR0105](ZTHR0105.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_CALC_WEEK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Source%20code/ZHR_52TM_CALC_WEEK_TIME.abap) L153 |
| [ZTRFGR](EXTERNAL_DEPENDENCIES.md#ZTRFGR) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Export.xml) L67 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [FLEX_WORK_PLAN_ESTABLISH](FLEX_WORK_PLAN_ESTABLISH.md) | 웹 요청 | [FLEX_WORK_PLAN_ESTABLISH.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_ESTABLISH/Layout/FLEX_WORK_PLAN_ESTABLISH.htm) L1226 |
| [FLEX_WORK_PLAN_VIEW](FLEX_WORK_PLAN_VIEW.md) | 웹 요청 | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1065 |
| [FLEX_WORK_PLAN_VIEW2](FLEX_WORK_PLAN_VIEW2.md) | 웹 요청 | [FLEX_WORK_PLAN_VIEW2.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW2/Layout/FLEX_WORK_PLAN_VIEW2.htm) L507 |
| [FLEX_WORK_PLAN_VIEW_ADM](FLEX_WORK_PLAN_VIEW_ADM.md) | 웹 요청 | [FLEX_WORK_PLAN_VIEW_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW_ADM/Layout/FLEX_WORK_PLAN_VIEW_ADM.htm) L1097 |
| [LZHR008_2F01](LZHR008_2F01.md) | 직접 호출 | [LZHR008_2F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap) L650, 1204, 1215 |
| [LZHR008_2F04](LZHR008_2F04.md) | 직접 호출 | [LZHR008_2F04.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F04.abap) L516, 1584 |
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L7 |
| [MFLEX_WORK_PLAN_ESTABLISH](MFLEX_WORK_PLAN_ESTABLISH.md) | 웹 요청 | [MFLEX_WORK_PLAN_ESTABLISH.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MFLEX_WORK_PLAN_ESTABLISH/Layout/MFLEX_WORK_PLAN_ESTABLISH.htm) L1498 |
| [MFLEX_WORK_PLAN_VIEW](MFLEX_WORK_PLAN_VIEW.md) | 웹 요청 | [MFLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MFLEX_WORK_PLAN_VIEW/Layout/MFLEX_WORK_PLAN_VIEW.htm) L1133 |
| [ZHR_52TM_CALC_WORK_TIME_DAYILY](ZHR_52TM_CALC_WORK_TIME_DAYILY.md) | 직접 호출 | [ZHR_52TM_CALC_WORK_TIME_DAYILY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Source%20code/ZHR_52TM_CALC_WORK_TIME_DAYILY.abap) L441 |
| [ZHR_52TM_MONTHLY_PAYMENT](ZHR_52TM_MONTHLY_PAYMENT.md) | 직접 호출 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L228, 331 |
| [ZRPTH403](ZRPTH403.md) | 직접 호출 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L114 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
