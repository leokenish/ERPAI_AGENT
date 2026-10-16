---
title: "ZHR_52TM_CW_SET_ITEM — [52시간] 실적 항목 생성 - 선택근로제"
as_of: 2026-10-07
review_status: pending_business_review
tags: [선택근무, 특별연장재난방송]
---

# ZHR_52TM_CW_SET_ITEM — [52시간] 실적 항목 생성 - 선택근로제

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 실적 항목 생성 - 선택근로제.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_SET_ITEM/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_SET_ITEM/Changing.xml) | 55행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_SET_ITEM/Exception.xml) | 40행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_SET_ITEM/Export.xml) | 52행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_SET_ITEM/Import.xml) | 83행; 원본 보존 |
| [ZHR_52TM_CW_SET_ITEM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_SET_ITEM/Source%20code/ZHR_52TM_CW_SET_ITEM.abap) | 59행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_SET_ITEM/Tables.xml) | 40행; 원본 보존 |
| [../../../Include/LZHR008_3U05.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3U05.abap) | 59행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_3U05.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3U05.abap) L1 | LZHR008_3U05: API 본문과 행말 공백 제외 본문 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Changing | `CS_ZSHR0141` | [ZSHR0141](ZSHR0141.md) | X | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_SET_ITEM/Changing.xml) L8 |
| Export | `E_RETURN` | BAPIRETURN1 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_SET_ITEM/Export.xml) L8 |
| Import | `I_PERNR` | PERSNO | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_SET_ITEM/Import.xml) L8 |
| Import | `IS_DATA` | [ZSHR0141](ZSHR0141.md) | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_SET_ITEM/Import.xml) L22 |
| Import | `TDCOST` | CHAR1 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_SET_ITEM/Import.xml) L36 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_3F02](LZHR008_3F02.md) | **FORM 호출** — D_CW_GET_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F02.abap L372; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_SET_ITEM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_SET_ITEM/Source%20code/ZHR_52TM_CW_SET_ITEM.abap) L47 |
| [LZHR008_3F02](LZHR008_3F02.md) | **FORM 호출** — G_CW_GET_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F02.abap L587; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_SET_ITEM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_SET_ITEM/Source%20code/ZHR_52TM_CW_SET_ITEM.abap) L37 |
| [LZHR008_3F03](LZHR008_3F03.md) | **FORM 호출** — GET_CALC_TDCOST: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap L451; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_SET_ITEM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_SET_ITEM/Source%20code/ZHR_52TM_CW_SET_ITEM.abap) L54 |
| [RH_GET_DATE_DAYNAME](EXTERNAL_DEPENDENCIES.md#RH_GET_DATE_DAYNAME) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CW_SET_ITEM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_SET_ITEM/Source%20code/ZHR_52TM_CW_SET_ITEM.abap) L27 |
| [ZSHR0139](ZSHR0139.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CW_SET_ITEM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_SET_ITEM/Source%20code/ZHR_52TM_CW_SET_ITEM.abap) L16 |
| [ZSHR0141](ZSHR0141.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_SET_ITEM/Changing.xml) L15 |
| [ZSHR0141](ZSHR0141.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_SET_ITEM/Import.xml) L29 |
| [ZSHR0143](ZSHR0143.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CW_SET_ITEM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_SET_ITEM/Source%20code/ZHR_52TM_CW_SET_ITEM.abap) L15 |
| [ZTHR0112](ZTHR0112.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CW_SET_ITEM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_SET_ITEM/Source%20code/ZHR_52TM_CW_SET_ITEM.abap) L13 |
| [ZTHR0132](ZTHR0132.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CW_SET_ITEM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_SET_ITEM/Source%20code/ZHR_52TM_CW_SET_ITEM.abap) L14 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_3F03](LZHR008_3F03.md) | 직접 호출 | [LZHR008_3F03.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap) L168, 1155, 1308 |
| [LZHR008_3UXX](LZHR008_3UXX.md) | Include | [LZHR008_3UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3UXX.abap) L13 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
