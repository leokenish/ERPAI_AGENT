---
title: "ZHR_52TM_GET_PERSONNEL_DATA_N — 근무일 인사·등급 검사"
as_of: 2026-10-07
review_status: pending_business_review
tags: [교대근무, 선택근무, 시간외단가등급, 통상시차시간외, 퇴직자관리자입력검토]
---

# ZHR_52TM_GET_PERSONNEL_DATA_N — 근무일 인사·등급 검사

[소스 설명 목차](INDEX.md) · [원본 파일](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Source%20code/ZHR_52TM_GET_PERSONNEL_DATA_N.abap)

대상일의 인사정보 및 등급을 조회한다. 현재 퇴직 여부와 과거 근무일의 재직 상태를 구분한다.

확인 수준: 표시한 소스 구간 정적 확인; 운영 실행 검증 아님. 원본 경로·파일은 그대로 유지한다.

## 근거 위치

| 위치 | 관계의 의미 | 근거 구문 |
|---|---|---|
| 6행 | 기준일 인수의 기본값 SY-DATUM | `*"     VALUE(I_ZNAL) TYPE  ZNAL DEFAULT SY-DATUM` |
| 39행 | 외부 인사조회 호출 | `CALL FUNCTION 'ZHR_GET_PERSON'` |
| 57행 | 사원그룹 재직 조건 검사 | `IF ls_person_data-persg NE '1'.  " 재작자여부.` |
| 121행 | 등급 조회 오류 반환 | `e_code = 'E07'.` |

## 연결된 소스

- [ZHR_52TM_AWART_LIST](ZHR_52TM_AWART_LIST.md) — 함수 호출 확인, 위 원본 303행. 호출 이후 전체 실행 성공은 미검증.

## 관련 업무

<!-- topics -->
- [퇴직자·관리자 입력 검토](../topics/retired.md) — 이 소스를 검토하는 업무 지도.
- [시간외 단가·직군·효력일](../topics/rates.md) — 이 소스를 검토하는 업무 지도.

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 사원 인사 관련정보 추출.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Changing.xml) | 52행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Exception.xml) | 52행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Export.xml) | 97행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Import.xml) | 95행; 원본 보존 |
| [ZHR_52TM_GET_PERSONNEL_DATA_N.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Source%20code/ZHR_52TM_GET_PERSONNEL_DATA_N.abap) | 379행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Tables.xml) | 52행; 원본 보존 |
| [../../../Include/LZHR008_2U24.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U24.abap) | 379행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U24.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U24.abap) L1 | LZHR008_2U24: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `ES_ZTHRBS01` | ZTHRBS01 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Export.xml) L8 |
| Export | `ES_PERSONNEL_DATA` | [ZSH_PERSONNEL_DATA_N](ZSH_PERSONNEL_DATA_N.md) | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Export.xml) L19 |
| Export | `E_CODE` | CHAR03 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Export.xml) L30 |
| Export | `E_TEXT` | CHAR200 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Export.xml) L41 |
| Import | `I_PERNR` | PERSNO | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Import.xml) L8 |
| Import | `I_ZNAL` | ZNAL | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Import.xml) L22 |
| Import | `I_ZGUBUN` | ZBSGUBUN | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Import.xml) L36 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [HR_READ_FOREIGN_OBJECT_TEXT](EXTERNAL_DEPENDENCIES.md#HR_READ_FOREIGN_OBJECT_TEXT) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_GET_PERSONNEL_DATA_N.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Source%20code/ZHR_52TM_GET_PERSONNEL_DATA_N.abap) L247 |
| [HR_READ_INFOTYPE](EXTERNAL_DEPENDENCIES.md#HR_READ_INFOTYPE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_GET_PERSONNEL_DATA_N.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Source%20code/ZHR_52TM_GET_PERSONNEL_DATA_N.abap) L225 |
| [LZHR008_2F04](LZHR008_2F04.md) | **FORM 호출** — CHECK_PERSON: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F04.abap L23; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_GET_PERSONNEL_DATA_N.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Source%20code/ZHR_52TM_GET_PERSONNEL_DATA_N.abap) L79 |
| [RH_READ_OBJECT](EXTERNAL_DEPENDENCIES.md#RH_READ_OBJECT) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_GET_PERSONNEL_DATA_N.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Source%20code/ZHR_52TM_GET_PERSONNEL_DATA_N.abap) L273 |
| [T527X](EXTERNAL_DEPENDENCIES.md#T527X) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_GET_PERSONNEL_DATA_N.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Source%20code/ZHR_52TM_GET_PERSONNEL_DATA_N.abap) L189, 203 |
| [ZBSGUBUN](EXTERNAL_DEPENDENCIES.md#ZBSGUBUN) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Import.xml) L43 |
| [ZHR_52TM_AWART_LIST](ZHR_52TM_AWART_LIST.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_GET_PERSONNEL_DATA_N.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Source%20code/ZHR_52TM_GET_PERSONNEL_DATA_N.abap) L303 |
| [ZHR_GET_PERSON](EXTERNAL_DEPENDENCIES.md#ZHR_GET_PERSON) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_GET_PERSONNEL_DATA_N.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Source%20code/ZHR_52TM_GET_PERSONNEL_DATA_N.abap) L39 |
| [ZHR_GET_PERSONNEL_RANK_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_PERSONNEL_RANK_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_GET_PERSONNEL_DATA_N.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Source%20code/ZHR_52TM_GET_PERSONNEL_DATA_N.abap) L98 |
| [ZNAL](EXTERNAL_DEPENDENCIES.md#ZNAL) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Import.xml) L29 |
| [ZSHR0111](ZSHR0111.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_GET_PERSONNEL_DATA_N.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Source%20code/ZHR_52TM_GET_PERSONNEL_DATA_N.abap) L300, 301 |
| [ZSH_PERSONNEL_DATA_N](ZSH_PERSONNEL_DATA_N.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Export.xml) L23 |
| [ZTH0500](EXTERNAL_DEPENDENCIES.md#ZTH0500) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_GET_PERSONNEL_DATA_N.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Source%20code/ZHR_52TM_GET_PERSONNEL_DATA_N.abap) L215 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Export.xml) L12 |
| [ZTHRWORKSCHEDULE](EXT-ZTHRWORKSCHEDULE.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_GET_PERSONNEL_DATA_N.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Source%20code/ZHR_52TM_GET_PERSONNEL_DATA_N.abap) L333 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F06](LZHR008_2F06.md) | 직접 호출 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L99, 269 |
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L51 |
| [LZHR008_3F01](LZHR008_3F01.md) | 직접 호출 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L140 |
| [MZH4110F01](MZH4110F01.md) | 직접 호출 | [MZH4110F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110F01/source/MZH4110F01.abap) L615 |

### 관련 업무와 미확인 범위

- [rates](../topics/rates.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [retired](../topics/retired.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
