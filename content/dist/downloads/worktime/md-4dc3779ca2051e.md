---
title: "ZHR_GET_PERSON_INFO — [HR]개인별 인사정보"
as_of: 2026-10-07
review_status: pending_business_review
tags: [업무리소스인원연계]
---

# ZHR_GET_PERSON_INFO — [HR]개인별 인사정보

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [HR]개인별 인사정보.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Changing.xml) | 46행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Exception.xml) | 46행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Export.xml) | 69행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Import.xml) | 61행; 원본 보존 |
| [ZHR_GET_PERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Source%20code/ZHR_GET_PERSON_INFO.abap) | 290행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Tables.xml) | 80행; 원본 보존 |
| [../../../Include/LZHR_ETCU01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Include/LZHR_ETCU01.abap) | 290행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR_ETCU01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Include/LZHR_ETCU01.abap) L1 | LZHR_ETCU01: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_RCODE` | CHAR1 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Export.xml) L8 |
| Export | `E_RMSG` | CHAR200 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Export.xml) L19 |
| Import | `PERNR` | PERSNO | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Import.xml) L8 |
| Tables | `ZWHO` | [ZHR_PERSON_INFO](ZHR_PERSON_INFO.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Tables.xml) L8 |
| Tables | `ZLIST` | [ZHR_PERSON_LIST](ZHR_PERSON_LIST.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Tables.xml) L19 |
| Tables | `ZLIST_WORK` | ZHR_PERSON_WORK | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Tables.xml) L30 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [AGR_AGRS](EXTERNAL_DEPENDENCIES.md#AGR_AGRS) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_PERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Source%20code/ZHR_GET_PERSON_INFO.abap) L243 |
| [AGR_PROF](EXTERNAL_DEPENDENCIES.md#AGR_PROF) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_PERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Source%20code/ZHR_GET_PERSON_INFO.abap) L241 |
| [AGR_TEXTS](EXTERNAL_DEPENDENCIES.md#AGR_TEXTS) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_PERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Source%20code/ZHR_GET_PERSON_INFO.abap) L246 |
| [CONVERSION_EXIT_ALPHA_OUTPUT](EXTERNAL_DEPENDENCIES.md#CONVERSION_EXIT_ALPHA_OUTPUT) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_GET_PERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Source%20code/ZHR_GET_PERSON_INFO.abap) L222 |
| [PA0001](EXTERNAL_DEPENDENCIES.md#PA0001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_PERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Source%20code/ZHR_GET_PERSON_INFO.abap) L99, 102 |
| [PRPS](EXTERNAL_DEPENDENCIES.md#PRPS) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_PERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Source%20code/ZHR_GET_PERSON_INFO.abap) L158, 198 |
| [T513S](EXTERNAL_DEPENDENCIES.md#T513S) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_PERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Source%20code/ZHR_GET_PERSON_INFO.abap) L109 |
| [USH04](EXTERNAL_DEPENDENCIES.md#USH04) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_PERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Source%20code/ZHR_GET_PERSON_INFO.abap) L227 |
| [ZHR_PERSON_INFO](ZHR_PERSON_INFO.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Tables.xml) L9 |
| [ZHR_PERSON_INFO](ZHR_PERSON_INFO.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_GET_PERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Source%20code/ZHR_GET_PERSON_INFO.abap) L17 |
| [ZHR_PERSON_LIST](ZHR_PERSON_LIST.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Tables.xml) L20 |
| [ZHR_PERSON_LIST](ZHR_PERSON_LIST.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_GET_PERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Source%20code/ZHR_GET_PERSON_INFO.abap) L18, 19 |
| [ZHR_PERSON_WORK](EXTERNAL_DEPENDENCIES.md#ZHR_PERSON_WORK) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Tables.xml) L31 |
| [ZRPTPS_PERSON_ASSIGNMENT](EXT-ZRPTPS_PERSON_ASSIGNMENT.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_GET_PERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Source%20code/ZHR_GET_PERSON_INFO.abap) L131 |
| [ZTH0500](EXTERNAL_DEPENDENCIES.md#ZTH0500) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_PERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Source%20code/ZHR_GET_PERSON_INFO.abap) L106, 107 |
| [ZTHR_KOBIS_DATA](EXTERNAL_DEPENDENCIES.md#ZTHR_KOBIS_DATA) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_PERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Source%20code/ZHR_GET_PERSON_INFO.abap) L93 |
| [ZTPS7501](EXTERNAL_DEPENDENCIES.md#ZTPS7501) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_PERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Source%20code/ZHR_GET_PERSON_INFO.abap) L160, 200 |
| [ZTPS7523](EXTERNAL_DEPENDENCIES.md#ZTPS7523) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_PERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Source%20code/ZHR_GET_PERSON_INFO.abap) L153 |
| [ZTPS7523_2](EXTERNAL_DEPENDENCIES.md#ZTPS7523_2) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_PERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Source%20code/ZHR_GET_PERSON_INFO.abap) L182, 193 |
| [ZTPS7524](EXTERNAL_DEPENDENCIES.md#ZTPS7524) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_PERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Source%20code/ZHR_GET_PERSON_INFO.abap) L142 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR_ETCUXX](LZHR_ETCUXX.md) | Include | [LZHR_ETCUXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Include/LZHR_ETCUXX.abap) L5 |

### 관련 업무와 미확인 범위

- [person-work](../topics/person-work.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
