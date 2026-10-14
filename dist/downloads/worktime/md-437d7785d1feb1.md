---
title: "ZHR_52TM_CALC_NORM_OT_PAY — 시간외 항목별 실비"
as_of: 2026-10-07
review_status: pending_business_review
tags: [교대근무, 대휴익휴보상휴가, 시간외단가등급, 통상시차시간외]
---

# ZHR_52TM_CALC_NORM_OT_PAY — 시간외 항목별 실비

[소스 설명 목차](INDEX.md) · [원본 파일](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_NORM_OT_PAY/Source%20code/ZHR_52TM_CALC_NORM_OT_PAY.abap)

연장·야간·휴일을 구분하는 계산 경로. 내부 호출처 전체·운영 지급 결과는 미검증.

확인 수준: 표시한 소스 구간 정적 확인; 운영 실행 검증 아님. 원본 경로·파일은 그대로 유지한다.

## 근거 위치

| 위치 | 관계의 의미 | 근거 구문 |
|---|---|---|
| 112행 | 야간시간 산정 FORM 호출 | `PERFORM get_calc_ngt_time IN PROGRAM saplzhr008_2` |
| 173행 | 야간실비 금액 필드 | `cs_data-zrlngtamt` |
| 59행 | 기준단가 테이블 조회 | `FROM zthrcost` |

## 관련 업무

<!-- topics -->
- [시간외 단가·직군·효력일](../topics/rates.md) — 이 소스를 검토하는 업무 지도.
- [대휴·익휴·보상휴가](../topics/rest.md) — 이 소스를 검토하는 업무 지도.
- [교대근무·보상휴가](../topics/shift.md) — 이 소스를 검토하는 업무 지도.
- [통상·시차 시간외 입력](../topics/ordinary.md) — 이 소스를 검토하는 업무 지도.

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 통상근로시간외 금액계산.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_NORM_OT_PAY/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_NORM_OT_PAY/Changing.xml) | 31행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_NORM_OT_PAY/Exception.xml) | 16행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_NORM_OT_PAY/Export.xml) | 16행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_NORM_OT_PAY/Import.xml) | 16행; 원본 보존 |
| [ZHR_52TM_CALC_NORM_OT_PAY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_NORM_OT_PAY/Source%20code/ZHR_52TM_CALC_NORM_OT_PAY.abap) | 367행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_NORM_OT_PAY/Tables.xml) | 16행; 원본 보존 |
| [../../../Include/LZHR008_2U30.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U30.abap) | 367행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U30.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U30.abap) L1 | LZHR008_2U30: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Changing | `CT_DATA` | [ZTSHR0121](ZTSHR0121.md) | — | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_NORM_OT_PAY/Changing.xml) L8 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F02](LZHR008_2F02.md) | **FORM 호출** — CALC_OT_AMOUNT: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F02.abap L48; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CALC_NORM_OT_PAY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_NORM_OT_PAY/Source%20code/ZHR_52TM_CALC_NORM_OT_PAY.abap) L164, 170, 179, 199, 209, 224, 239, 245, 252, 287, 294, 304, 310, 318, 324, 333, 339, 346 |
| [LZHR008_2F02](LZHR008_2F02.md) | **FORM 호출** — GET_CALC_NGT_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F02.abap L87; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CALC_NORM_OT_PAY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_NORM_OT_PAY/Source%20code/ZHR_52TM_CALC_NORM_OT_PAY.abap) L112 |
| [RH_GET_DATE_DAYNAME](EXTERNAL_DEPENDENCIES.md#RH_GET_DATE_DAYNAME) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CALC_NORM_OT_PAY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_NORM_OT_PAY/Source%20code/ZHR_52TM_CALC_NORM_OT_PAY.abap) L186, 216 |
| [ZHR_GET_PERSONNEL_RANK_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_PERSONNEL_RANK_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CALC_NORM_OT_PAY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_NORM_OT_PAY/Source%20code/ZHR_52TM_CALC_NORM_OT_PAY.abap) L44 |
| [ZSHR0115](ZSHR0115.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CALC_NORM_OT_PAY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_NORM_OT_PAY/Source%20code/ZHR_52TM_CALC_NORM_OT_PAY.abap) L14, 24 |
| [ZSHR0121](ZSHR0121.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CALC_NORM_OT_PAY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_NORM_OT_PAY/Source%20code/ZHR_52TM_CALC_NORM_OT_PAY.abap) L10, 11, 28 |
| [ZTHRCOST](EXT-ZTHRCOST.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_CALC_NORM_OT_PAY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_NORM_OT_PAY/Source%20code/ZHR_52TM_CALC_NORM_OT_PAY.abap) L59 |
| [ZTSHR0115](ZTSHR0115.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CALC_NORM_OT_PAY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_NORM_OT_PAY/Source%20code/ZHR_52TM_CALC_NORM_OT_PAY.abap) L25 |
| [ZTSHR0121](ZTSHR0121.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_NORM_OT_PAY/Changing.xml) L15 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F03](LZHR008_2F03.md) | 직접 호출 | [LZHR008_2F03.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap) L5762 |
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L63 |

### 관련 업무와 미확인 범위

- [rates](../topics/rates.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
