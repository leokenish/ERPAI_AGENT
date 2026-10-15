---
title: "ZHR_52TM_MOBILE_OVERTIME_DETL — [52시간] Mobile_통상/교대 시간외실비 상세조회"
as_of: 2026-10-07
review_status: pending_business_review
tags: [교대근무, 통상시차시간외]
---

# ZHR_52TM_MOBILE_OVERTIME_DETL — [52시간] Mobile_통상/교대 시간외실비 상세조회

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] Mobile_통상/교대 시간외실비 상세조회.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Changing.xml) | 64행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Exception.xml) | 64행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Export.xml) | 109행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Import.xml) | 121행; 원본 보존 |
| [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) | 317행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Tables.xml) | 76행; 원본 보존 |
| [../../../Include/LZHR008_2U42.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U42.abap) | 317행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U42.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U42.abap) L1 | LZHR008_2U42: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_ZSHR0131` | [ZSHR0131](ZSHR0131.md) | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Export.xml) L8 |
| Export | `E_RETURN` | BAPIRETURN | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Export.xml) L19 |
| Export | `E_ZRLWK_TM` | [ZERLWK_TM](ZERLWK_TM.md) | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Export.xml) L30 |
| Export | `E_ZPDWK_TM` | [ZEPDWK_TM](ZEPDWK_TM.md) | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Export.xml) L41 |
| Import | `I_PERNR` | PERSNO | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Import.xml) L8 |
| Import | `I_DATUM` | DATUM | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Import.xml) L22 |
| Import | `I_SEQNR` | SEQNR | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Import.xml) L36 |
| Import | `I_ACTION` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Import.xml) L50 |
| Tables | `LT_WKTP` | [ZSHR0114](ZSHR0114.md) | — | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Tables.xml) L8 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — CALC_WORKING_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L2920; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L261 |
| [LZHR008_2F02](LZHR008_2F02.md) | **FORM 호출** — SET_HOUR_TO_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F02.abap L12; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L152 |
| [LZHR008_2F06](LZHR008_2F06.md) | **FORM 호출** — CHECK_OVERTIME_CHANGE_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap L423; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L275 |
| [LZHR008_2F06](LZHR008_2F06.md) | **FORM 호출** — MODIFY_SCREEN: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap L317; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L253 |
| [LZHR008_2F06](LZHR008_2F06.md) | **FORM 호출** — SET_OVERTIME_CONVERT_TIME_OUT: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap L903; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L216 |
| [LZHR008_2F06](LZHR008_2F06.md) | **FORM 호출** — SET_OVERTIME_DATE: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap L9; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L120 |
| [LZHR008_2F06](LZHR008_2F06.md) | **FORM 호출** — SET_WKTYPE_LIST: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap L350; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L130 |
| [PA0001](EXTERNAL_DEPENDENCIES.md#PA0001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L295 |
| [RH_GET_DATE_DAYNAME](EXTERNAL_DEPENDENCIES.md#RH_GET_DATE_DAYNAME) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L74 |
| [T527X](EXTERNAL_DEPENDENCIES.md#T527X) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L301 |
| [ZECNVAL](ZECNVAL.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L23 |
| [ZEPDWK_TM](ZEPDWK_TM.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Export.xml) L45 |
| [ZERLWK_TM](ZERLWK_TM.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Export.xml) L34 |
| [ZHR_52TM_AWART_LIST](ZHR_52TM_AWART_LIST.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L233 |
| [ZHR_52TM_CALC_BREAK_TIME](ZHR_52TM_CALC_BREAK_TIME.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L159 |
| [ZHR_52TM_CONVERT_ZGUBUN_WKTYPE](ZHR_52TM_CONVERT_ZGUBUN_WKTYPE.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L124 |
| [ZHR_52TM_MOBILE_OVERTIME_LIST](ZHR_52TM_MOBILE_OVERTIME_LIST.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L45 |
| [ZHR_52TM_SET_DEFAULT_TIME](ZHR_52TM_SET_DEFAULT_TIME.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L168 |
| [ZHR_GET_DAY_DATA_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_DAY_DATA_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L225 |
| [ZHR_MINUS_TIME_N](EXTERNAL_DEPENDENCIES.md#ZHR_MINUS_TIME_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L93 |
| [ZSHR0111](ZSHR0111.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L21 |
| [ZSHR0114](ZSHR0114.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Tables.xml) L9 |
| [ZSHR0131](ZSHR0131.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Export.xml) L12 |
| [ZSHR0132](ZSHR0132.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L19 |
| [ZTHR0101](ZTHR0101.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L147 |
| [ZTHRWORKSCHEDULE](EXT-ZTHRWORKSCHEDULE.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L248 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L93 |
| [MORD_OT_DETAIL](MORD_OT_DETAIL.md) | 웹 요청 | [MORD_OT_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_DETAIL/Layout/MORD_OT_DETAIL.htm) L824 |
| [MORD_OT_DETAIL_new](MORD_OT_DETAIL_new.md) | 웹 요청 | [MORD_OT_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_DETAIL_new/Layout/MORD_OT_DETAIL_new.htm) L72 |
| [MORD_OT_INSERT](MORD_OT_INSERT.md) | 웹 요청 | [MORD_OT_INSERT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_INSERT/Layout/MORD_OT_INSERT.htm) L2038 |
| [MORD_OT_INSERT_new](MORD_OT_INSERT_new.md) | 웹 요청 | [MORD_OT_INSERT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_INSERT_new/Layout/MORD_OT_INSERT_new.htm) L1143 |
| [MORD_OT_MODIFY](MORD_OT_MODIFY.md) | 웹 요청 | [MORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY/Layout/MORD_OT_MODIFY.htm) L1379 |
| [MORD_OT_MODIFY_new](MORD_OT_MODIFY_new.md) | 웹 요청 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L512 |
| [ORD_OT_DETAIL](ORD_OT_DETAIL.md) | 웹 요청 | [ORD_OT_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_DETAIL/Layout/ORD_OT_DETAIL.htm) L851 |
| [ORD_OT_INSERT](ORD_OT_INSERT.md) | 웹 요청 | [ORD_OT_INSERT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_INSERT/Layout/ORD_OT_INSERT.htm) L1929 |
| [ORD_OT_MODIFY](ORD_OT_MODIFY.md) | 웹 요청 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L1250 |
| [temp](temp.md) | 웹 요청 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1621 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
