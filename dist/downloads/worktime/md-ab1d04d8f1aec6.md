---
title: "ZHR_52TM_REAL_WORK_TIME — [52시간] 근무실적관리"
as_of: 2026-10-07
review_status: pending_business_review
tags: [근로시간알림, 대휴익휴보상휴가, 탄력근무, 특별연장재난방송]
---

# ZHR_52TM_REAL_WORK_TIME — [52시간] 근무실적관리

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 근무실적관리.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Changing.xml) | 94행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Exception.xml) | 94행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Export.xml) | 150행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Import.xml) | 193행; 원본 보존 |
| [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) | 477행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Tables.xml) | 117행; 원본 보존 |
| [../../../Include/LZHR008_2U18.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U18.abap) | 477행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U18.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U18.abap) L1 | LZHR008_2U18: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_ZCOSA` | ZPERNR0 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Export.xml) L8 |
| Export | `E_ZCOPE` | ZCOPERSON | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Export.xml) L19 |
| Export | `E_CORGTX` | CHAR50 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Export.xml) L30 |
| Export | `E_RETURN` | BAPIRETURN1 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Export.xml) L41 |
| Export | `E_MESSAGE` | CHAR100 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Export.xml) L52 |
| Import | `I_ZGUBUN` | CHAR01 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Import.xml) L8 |
| Import | `I_PERNR` | PERSNO | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Import.xml) L22 |
| Import | `I_BEGDA` | BEGDA | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Import.xml) L36 |
| Import | `I_ENDDA` | ENDDA | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Import.xml) L50 |
| Import | `I_Z52WKTP` | [ZE52WKTP](ZE52WKTP.md) | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Import.xml) L64 |
| Import | `I_STATE` | ZSTATE_1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Import.xml) L78 |
| Import | `I_SEQNR` | SEQNR | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Import.xml) L92 |
| Tables | `T_DAILY` | [ZSHR0117](ZSHR0117.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Tables.xml) L8 |
| Tables | `T_TOTAL` | [ZSHR0116](ZSHR0116.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Tables.xml) L19 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — CHECK_REAL_APPROVE: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L1816; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L324 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — CHECK_REQUEST_DATE: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L1383; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L194, 335, 402 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — GET_DOMAIN: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L151; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L64, 375, 435 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — GET_REAL_LIST: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L2551; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L86, 110, 257 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — GET_REAL_SAVE: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L1465; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L235 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — GET_WEEK_TOTAL: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L1122; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L132, 165, 265, 310 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — GET_WEEK_WORK_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L1743; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L251, 304 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — MAKE_CALC_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L350; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L154, 158 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — MAKE_DAILY_ZOVRNGT: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L2618; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L211 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — SEND_MAIL: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L2772; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L454 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — SET_0101: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L1081; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L344, 432 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — SET_DATE: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L1092; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L56 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — SET_REAL_TIME_ZCOPE: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L2734; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L117 |
| [ZCOPERSON](EXTERNAL_DEPENDENCIES.md#ZCOPERSON) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Export.xml) L23 |
| [ZE52WKTP](ZE52WKTP.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Import.xml) L71 |
| [ZE52WKTP](ZE52WKTP.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L42 |
| [ZE52WKTXT](ZE52WKTXT.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L43 |
| [ZEDAEH](ZEDAEH.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L45 |
| [ZEDAEH_DAY](ZEDAEH_DAY.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L46 |
| [ZEEMCWK](ZEEMCWK.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L44 |
| [ZHR_52TM_CHECK_HOLIDAY_ZDAEH](ZHR_52TM_CHECK_HOLIDAY_ZDAEH.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L421 |
| [ZHR_52TM_WKTYPE_PERIOD](ZHR_52TM_WKTYPE_PERIOD.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L77 |
| [ZPERNR0](EXTERNAL_DEPENDENCIES.md#ZPERNR0) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Export.xml) L12 |
| [ZSHR0101](ZSHR0101.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L33 |
| [ZSHR0116](ZSHR0116.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Tables.xml) L20 |
| [ZSHR0117](ZSHR0117.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Tables.xml) L9 |
| [ZSHR0117](ZSHR0117.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L29 |
| [ZSHR0119](ZSHR0119.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L25 |
| [ZSTATE_1](EXTERNAL_DEPENDENCIES.md#ZSTATE_1) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Import.xml) L85 |
| [ZTHR0110](ZTHR0110.md) | **데이터 저장** — MODIFY DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L222, 280, 382, 446 |
| [ZTHR0110](ZTHR0110.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L347, 413 |
| [ZTHR0110](ZTHR0110.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L27 |
| [ZWF_DELETE](EXT-ZWF_DELETE.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L356 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [FLEX_WORK_PERFORMANCE_INPUT](FLEX_WORK_PERFORMANCE_INPUT.md) | 웹 요청 | [FLEX_WORK_PERFORMANCE_INPUT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PERFORMANCE_INPUT/Layout/FLEX_WORK_PERFORMANCE_INPUT.htm) L2240, 2354, 2368, 2597 |
| [FLEX_WORK_PERFORMANCE_INPUT_ADM](FLEX_WORK_PERFORMANCE_INPUT_ADM.md) | 웹 요청 | [FLEX_WORK_PERFORMANCE_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PERFORMANCE_INPUT_ADM/Layout/FLEX_WORK_PERFORMANCE_INPUT_ADM.htm) L2270, 2384, 2398, 2627 |
| [FLEX_WORK_PERFORMANCE_LIST](FLEX_WORK_PERFORMANCE_LIST.md) | 웹 요청 | [FLEX_WORK_PERFORMANCE_LIST.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PERFORMANCE_LIST/Layout/FLEX_WORK_PERFORMANCE_LIST.htm) L177 |
| [FLEX_WORK_PERFORMANCE_LIST_ADM](FLEX_WORK_PERFORMANCE_LIST_ADM.md) | 웹 요청 | [FLEX_WORK_PERFORMANCE_LIST_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PERFORMANCE_LIST_ADM/Layout/FLEX_WORK_PERFORMANCE_LIST_ADM.htm) L240 |
| [FLEX_WORK_PLAN_VIEW](FLEX_WORK_PLAN_VIEW.md) | 웹 요청 | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1989 |
| [FLEX_WORK_PLAN_VIEW_ADM](FLEX_WORK_PLAN_VIEW_ADM.md) | 웹 요청 | [FLEX_WORK_PLAN_VIEW_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW_ADM/Layout/FLEX_WORK_PLAN_VIEW_ADM.htm) L2021 |
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L37 |
| [MFLEX_WORK_PERFORMANCE_INPUT](MFLEX_WORK_PERFORMANCE_INPUT.md) | 웹 요청 | [MFLEX_WORK_PERFORMANCE_INPUT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MFLEX_WORK_PERFORMANCE_INPUT/Layout/MFLEX_WORK_PERFORMANCE_INPUT.htm) L2362, 2476, 2490, 2719 |
| [MFLEX_WORK_PERFORMANCE_LIST](MFLEX_WORK_PERFORMANCE_LIST.md) | 웹 요청 | [MFLEX_WORK_PERFORMANCE_LIST.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MFLEX_WORK_PERFORMANCE_LIST/Layout/MFLEX_WORK_PERFORMANCE_LIST.htm) L175 |
| [MFLEX_WORK_PLAN_VIEW](MFLEX_WORK_PLAN_VIEW.md) | 웹 요청 | [MFLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MFLEX_WORK_PLAN_VIEW/Layout/MFLEX_WORK_PLAN_VIEW.htm) L2052 |
| [ZRPTH403](ZRPTH403.md) | 직접 호출 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L200 |

### 관련 업무와 미확인 범위

- [alerts](../topics/alerts.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [flexible](../topics/flexible.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [rest](../topics/rest.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
