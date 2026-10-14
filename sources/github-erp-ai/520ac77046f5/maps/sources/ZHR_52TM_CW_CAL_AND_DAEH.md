---
title: "ZHR_52TM_CW_CAL_AND_DAEH — 선택 실비·대휴 계산"
as_of: 2026-10-07
review_status: pending_business_review
tags: [간주근무, 근무현황조회, 대휴익휴보상휴가, 선택근무, 시간외단가등급, 월정산전표지급, 특별연장재난방송, 휴가공가반차]
---

# ZHR_52TM_CW_CAL_AND_DAEH — 선택 실비·대휴 계산

[소스 설명 목차](INDEX.md) · [원본 파일](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap)

소정 충당, 인정시간, 대휴, 연장·야간·휴일 계산을 잇는 중심 함수. 예외 분기 전체의 업무 승인은 미확인.

[2026-10-08 특별연장 정산 상세 분석](../topics/special-extension.md#월정산%20총근로시간과%20208시간%20제한) — L1603–1676의 총시간·208 제한·연장 계산, L1852–1940의 대휴 경로, L268/L558의 과거·현재 분기를 추가 확인했다. X 표지와 가산시간을 구분한다.

확인 수준: 표시한 소스 구간 정적 확인; 운영 실행 검증 아님. 원본 경로·파일은 그대로 유지한다.

## 근거 위치

| 위치 | 관계의 의미 | 근거 구문 |
|---|---|---|
| 166행 | 휴가·근태시간 취득 | `CALL FUNCTION 'ZHR_52TM_AWART_LIST'` |
| 221행 | 휴일·인정시간을 뺀 소정 재계산 | `lv_pwkhr_sum = lv_pwkhr_min - "기준소정근로시간` |
| 1312행 | 연장실비 계산 | `lt_zthr0113-zrlovramt = ( lv_zrlovrwkhr_sum / 60 ) * lt_zthr0113-zcost.` |
| 1322행 | 대휴발생분 실비 계산 | `lt_zthr0113-zdaehamt = ( lv_zdaeh_t_min / 60 ) * ( lt_zthr0113-zcost * '0.5' ).` |

## 연결된 소스

- [ZHR_52TM_AWART_LIST](ZHR_52TM_AWART_LIST.md) — 함수 호출 확인, 위 원본 166행. 호출 이후 전체 실행 성공은 미검증.

## 관련 업무

<!-- topics -->
- [시간외 단가·직군·효력일](../topics/rates.md) — 이 소스를 검토하는 업무 지도.
- [간주근무](../topics/deemed.md) — 이 소스를 검토하는 업무 지도.
- [대휴·익휴·보상휴가](../topics/rest.md) — 이 소스를 검토하는 업무 지도.
- [휴가·공가·반차](../topics/leave.md) — 이 소스를 검토하는 업무 지도.
- [선택근무](../topics/selective.md) — 이 소스를 검토하는 업무 지도.

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 정산/대휴/일별실적 데이터 생성 - 선택근로제.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Changing.xml) | 46행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Exception.xml) | 46행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Export.xml) | 46행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Import.xml) | 61행; 원본 보존 |
| [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) | 2267행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Tables.xml) | 102행; 원본 보존 |
| [../../../Include/LZHR008_3U10.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3U10.abap) | 2267행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_3U10.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3U10.abap) L1 | LZHR008_3U10: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Import | `I_CASE` | CHAR1 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Import.xml) L8 |
| Tables | `LT_ZTHR0132` | [ZTHR0132](ZTHR0132.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Tables.xml) L8 |
| Tables | `LT_ZTHR0113` | [ZTHR0113](ZTHR0113.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Tables.xml) L19 |
| Tables | `LT_DAEH` | [ZSHR0146](ZSHR0146.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Tables.xml) L30 |
| Tables | `LT_SAVE` | [ZSHR0145](ZSHR0145.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Tables.xml) L41 |
| Tables | `LT_DAILY` | [ZSHR0145](ZSHR0145.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Tables.xml) L52 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [DAY_ATTRIBUTES_GET](EXTERNAL_DEPENDENCIES.md#DAY_ATTRIBUTES_GET) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L1083, 1364 |
| [LZHR008_3F02](LZHR008_3F02.md) | **FORM 호출** — CONVERT_HOUR_TO_MIN: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F02.abap L276; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L156, 159 |
| [LZHR008_3F02](LZHR008_3F02.md) | **FORM 호출** — CONVERT_MIN_TO_HOUR2: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F02.abap L313; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L2089, 2197 |
| [LZHR008_3F02](LZHR008_3F02.md) | **FORM 호출** — CONVERT_MIN_TO_HOUR: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F02.abap L290; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L1210, 1218, 1222, 1226, 1230, 1234, 1238, 1249, 1274, 1292, 1296, 1301, 1308, 1564, 1572, 1576, 1580, 1584, 1588, 1592, 1596, 1600, 1639, 1658, 1675, 1679, 1684, 1691 |
| [LZHR008_3F02](LZHR008_3F02.md) | **FORM 호출** — CONVERT_MIN_TO_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F02.abap L351; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L289, 328, 625, 665, 2030, 2034, 2215, 2219, 2239, 2244, 2251 |
| [LZHR008_3F02](LZHR008_3F02.md) | **FORM 호출** — CONVERT_TIME_TO_MIN: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F02.abap L257; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L178, 208, 319, 411, 445, 475, 478, 497, 512, 541, 544, 656, 791, 809, 811, 821, 846, 853, 870, 913, 916, 945, 950, 952, 961, 1005, 1008, 1067, 1103, 1121, 1135, 1140, 1169, 1172, 1182, 1346, 1406, 1414, 1442, 1459, 1464, 1516, 1529, 1872, 1875, 1880, 1909, 1920, 1965, 1968, 2026, 2094, 2143, 2188 |
| [LZHR008_3F02](LZHR008_3F02.md) | **FORM 호출** — G_CW_GET_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F02.abap L587; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L1202, 1556 |
| [LZHR008_3F04](LZHR008_3F04.md) | **FORM 호출** — MAKE_DAEH_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F04.abap L606; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L1751, 1767, 1774, 1841, 1901, 1930 |
| [RP_CALC_DATE_IN_INTERVAL](EXTERNAL_DEPENDENCIES.md#RP_CALC_DATE_IN_INTERVAL) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L1390, 2126, 2162 |
| [ZETDCOST](ZETDCOST.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L101 |
| [ZHR_52TM_AWART_LIST](ZHR_52TM_AWART_LIST.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L166, 562, 859 |
| [ZHR_52TM_CALC_WORK_TIME_DAYILY](ZHR_52TM_CALC_WORK_TIME_DAYILY.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L1075, 1354 |
| [ZHR_52TM_CW_BASE_DATA](ZHR_52TM_CW_BASE_DATA.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L1948 |
| [ZHR_GET_DAY_DATA](EXTERNAL_DEPENDENCIES.md#ZHR_GET_DAY_DATA) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L596, 747, 938, 1036, 1400, 1864, 2017, 2136, 2172 |
| [ZHR_MINUS_TIME_N](EXTERNAL_DEPENDENCIES.md#ZHR_MINUS_TIME_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L840, 1509, 2180 |
| [ZSHR0111](ZSHR0111.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L13, 14, 24 |
| [ZSHR0115](ZSHR0115.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L17, 18 |
| [ZSHR0137](ZSHR0137.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L22 |
| [ZSHR0141](ZSHR0141.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L20 |
| [ZSHR0143](ZSHR0143.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L21 |
| [ZSHR0145](ZSHR0145.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Tables.xml) L42, 53 |
| [ZSHR0145](ZSHR0145.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L15, 16 |
| [ZSHR0146](ZSHR0146.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Tables.xml) L31 |
| [ZTHR0112](ZTHR0112.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L233 |
| [ZTHR0113](ZTHR0113.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Tables.xml) L20 |
| [ZTHR0132](ZTHR0132.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Tables.xml) L9 |
| [ZTHRBS05](EXT-ZTHRBS05.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L2048 |
| [ZTHRCOST](EXT-ZTHRCOST.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L2051, 2066 |
| [ZWF0022](EXT-ZWF0022.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L252 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_3UXX](LZHR008_3UXX.md) | Include | [LZHR008_3UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3UXX.abap) L23 |
| [ZHR_52TM_CW_PAYMENT_WKPRD](ZHR_52TM_CW_PAYMENT_WKPRD.md) | 직접 호출 | [ZHR_52TM_CW_PAYMENT_WKPRD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Source%20code/ZHR_52TM_CW_PAYMENT_WKPRD.abap) L90, 125 |
| [ZRPTH410F01](ZRPTH410F01.md) | 직접 호출 | [ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap) L1661 |
| [ZRPTH413F01](ZRPTH413F01.md) | 직접 호출 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L526 |

### 관련 업무와 미확인 범위

- [rates](../topics/rates.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [rest](../topics/rest.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [selective](../topics/selective.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
