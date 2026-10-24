---
title: "ZHR_52TM_CW_BASE_DATA — [52시간] 기본데이터 조회 - 선택근로제"
as_of: 2026-10-07
review_status: pending_business_review
tags: [간주근무, 대휴익휴보상휴가, 선택근무, 시간외단가등급, 월정산전표지급, 퇴직자관리자입력검토, 특별연장재난방송, 휴가공가반차]
---

# ZHR_52TM_CW_BASE_DATA — [52시간] 기본데이터 조회 - 선택근로제

## 누적표시 변경 검토

[선택근로 누적시간 가산 포함 분석](../topics/selective.md#%EB%88%84%EC%A0%81%EA%B7%BC%EB%A1%9C%EC%8B%9C%EA%B0%84%20%EA%B0%80%EC%82%B0%20%ED%8F%AC%ED%95%A8%20%EB%B3%80%EA%B2%BD%20%EA%B2%80%ED%86%A0%202026-10-08) — 2026-10-08, 지정 구간 정적 확인과 표시 전용 변경안. 원본 수정·운영 검증 없음.

## 누적표시 롤백의 업무 의미

[선택근로 누적표시와 가산시간](../../knowledge/processes/selective-cumulative-display.md) — SRC-15, 2026-10-08 사용자 요청 반영. 2024-10-15에는 대휴 오해를 줄이려고 가산을 제외했으나, 10-28에는 소정을 못 채웠다는 오해가 더 커 가산 포함 표시로 롤백했다. 누적표시를 대휴 생성시간과 동일시하지 않는다. BASE_DATA L632–635의 주석·현재 차감식 비활성 상태 확인이며 운영 배포 검증은 아니다.

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 기본데이터 조회 - 선택근로제.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Changing.xml) | 73행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Exception.xml) | 58행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Export.xml) | 70행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Import.xml) | 115행; 원본 보존 |
| [ZHR_52TM_CW_BASE_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Source%20code/ZHR_52TM_CW_BASE_DATA.abap) | 639행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Tables.xml) | 81행; 원본 보존 |
| [../../../Include/LZHR008_3U04.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3U04.abap) | 639행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_3U04.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3U04.abap) L1 | LZHR008_3U04: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Changing | `CS_ZSHR0137` | [ZSHR0137](ZSHR0137.md) | X | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Changing.xml) L8 |
| Export | `E_RETURN` | BAPIRETURN1 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Export.xml) L8 |
| Import | `I_PAGE` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Import.xml) L8 |
| Import | `I_PERNR` | PERSNO | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Import.xml) L22 |
| Import | `I_DATUM` | DATS | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Import.xml) L36 |
| Import | `IS_DATA` | [ZSHR0141](ZSHR0141.md) | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Import.xml) L50 |
| Tables | `LT_ZSHR0141` | [ZSHR0141](ZSHR0141.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Tables.xml) L8 |
| Tables | `LT_ZSHR0111` | [ZSHR0111](ZSHR0111.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Tables.xml) L19 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_3F02](LZHR008_3F02.md) | **FORM 호출** — CONVERT_HOUR_TO_MIN: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F02.abap L276; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_BASE_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Source%20code/ZHR_52TM_CW_BASE_DATA.abap) L113, 116, 119, 122 |
| [LZHR008_3F02](LZHR008_3F02.md) | **FORM 호출** — CONVERT_TIME_TO_MIN: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F02.abap L257; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_BASE_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Source%20code/ZHR_52TM_CW_BASE_DATA.abap) L129, 182, 272, 286, 308, 319, 333, 362, 381, 390, 404, 431, 436, 510, 517, 531, 549, 554, 567, 573, 587, 605, 610 |
| [ZHR_52TM_AWART_LIST](ZHR_52TM_AWART_LIST.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CW_BASE_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Source%20code/ZHR_52TM_CW_BASE_DATA.abap) L97, 211 |
| [ZHR_GET_DAY_DATA](EXTERNAL_DEPENDENCIES.md#ZHR_GET_DAY_DATA) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CW_BASE_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Source%20code/ZHR_52TM_CW_BASE_DATA.abap) L144, 172, 228 |
| [ZHR_MINUS_TIME_N](EXTERNAL_DEPENDENCIES.md#ZHR_MINUS_TIME_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CW_BASE_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Source%20code/ZHR_52TM_CW_BASE_DATA.abap) L279, 326, 397, 425, 524, 543, 580, 599 |
| [ZSHR0111](ZSHR0111.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Tables.xml) L20 |
| [ZSHR0137](ZSHR0137.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Changing.xml) L15 |
| [ZSHR0141](ZSHR0141.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Tables.xml) L9 |
| [ZSHR0141](ZSHR0141.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Import.xml) L57 |
| [ZTHR0112](ZTHR0112.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_CW_BASE_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Source%20code/ZHR_52TM_CW_BASE_DATA.abap) L77 |
| [ZTHR0112](ZTHR0112.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CW_BASE_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Source%20code/ZHR_52TM_CW_BASE_DATA.abap) L27 |
| [ZTHR0132](ZTHR0132.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_CW_BASE_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Source%20code/ZHR_52TM_CW_BASE_DATA.abap) L61 |
| [ZTHR0132](ZTHR0132.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CW_BASE_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Source%20code/ZHR_52TM_CW_BASE_DATA.abap) L17 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_3F01](LZHR008_3F01.md) | 직접 호출 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L414 |
| [LZHR008_3F02](LZHR008_3F02.md) | 직접 호출 | [LZHR008_3F02.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F02.abap) L57 |
| [LZHR008_3UXX](LZHR008_3UXX.md) | Include | [LZHR008_3UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3UXX.abap) L11 |
| [ZHR_52TM_CW_CAL_AND_DAEH](ZHR_52TM_CW_CAL_AND_DAEH.md) | 직접 호출 | [ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap) L1948 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
