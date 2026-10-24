---
title: "ZHR_52TM_SIMPLE_SETTING — [52시간] 시간외 간편설정"
as_of: 2026-10-07
review_status: pending_business_review
tags: [IAM등록기본설정]
---

# ZHR_52TM_SIMPLE_SETTING — [52시간] 시간외 간편설정

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 시간외 간편설정.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Changing.xml) | 52행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Exception.xml) | 52행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Export.xml) | 64행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Import.xml) | 123행; 원본 보존 |
| [ZHR_52TM_SIMPLE_SETTING.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Source%20code/ZHR_52TM_SIMPLE_SETTING.abap) | 164행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Tables.xml) | 64행; 원본 보존 |
| [../../../Include/LZHR008_2U49.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U49.abap) | 164행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U49.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U49.abap) L1 | LZHR008_2U49: API 본문과 행말 공백 제외 본문 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_RETURN` | BAPIRETURN1 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Export.xml) L8 |
| Import | `I_ZGUBUN` | CHAR01 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Import.xml) L8 |
| Import | `I_PERNR` | PERSNO | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Import.xml) L22 |
| Import | `I_Z52WKTP` | [ZE52WKTP](ZE52WKTP.md) | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Import.xml) L36 |
| Import | `I_Z52PRSQ` | [ZE52PRSQ](ZE52PRSQ.md) | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Import.xml) L50 |
| Import | `I_ZSIMST` | [ZESIMST](ZESIMST.md) | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Import.xml) L64 |
| Tables | `T_DATA` | ZTHRBS15 | — | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Tables.xml) L8 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — SET_0100: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L1070; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_SIMPLE_SETTING.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Source%20code/ZHR_52TM_SIMPLE_SETTING.abap) L107 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — SET_0101: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L1081; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_SIMPLE_SETTING.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Source%20code/ZHR_52TM_SIMPLE_SETTING.abap) L108 |
| [ZE52PRSQ](ZE52PRSQ.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Import.xml) L57 |
| [ZE52WKTP](ZE52WKTP.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Import.xml) L43 |
| [ZESIMST](ZESIMST.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Import.xml) L71 |
| [ZSHR0100](ZSHR0100.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_SIMPLE_SETTING.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Source%20code/ZHR_52TM_SIMPLE_SETTING.abap) L20 |
| [ZSHR0101](ZSHR0101.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_SIMPLE_SETTING.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Source%20code/ZHR_52TM_SIMPLE_SETTING.abap) L23 |
| [ZTHRBS15](EXTERNAL_DEPENDENCIES.md#ZTHRBS15) | **데이터 저장** — MODIFY DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZHR_52TM_SIMPLE_SETTING.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Source%20code/ZHR_52TM_SIMPLE_SETTING.abap) L142 |
| [ZTHRBS15](EXTERNAL_DEPENDENCIES.md#ZTHRBS15) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_SIMPLE_SETTING.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Source%20code/ZHR_52TM_SIMPLE_SETTING.abap) L43, 114 |
| [ZTHRBS15](EXTERNAL_DEPENDENCIES.md#ZTHRBS15) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Tables.xml) L9 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L101 |

### 관련 업무와 미확인 범위

- [iam](../topics/iam.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
