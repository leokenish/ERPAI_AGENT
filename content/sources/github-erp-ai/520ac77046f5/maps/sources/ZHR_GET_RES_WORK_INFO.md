---
title: "ZHR_GET_RES_WORK_INFO — ABAP 프로그램·독립 Include"
as_of: 2026-10-07
review_status: pending_business_review
tags: [업무리소스인원연계]
---

# ZHR_GET_RES_WORK_INFO — ABAP 프로그램·독립 Include

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 제목 메타데이터 없음; 이름만으로 업무를 확정하지 않음.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZHR_GET_RES_WORK_INFO.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/attributes/ZHR_GET_RES_WORK_INFO.xml) | 36행; 원본 보존 |
| [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) | 310행; 원본 보존 |
| [../texts/ZHR_GET_RES_WORK_INFO.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/texts/ZHR_GET_RES_WORK_INFO.xml) | 16행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [AGR_AGRS](EXTERNAL_DEPENDENCIES.md#AGR_AGRS) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L163 |
| [AGR_TEXTS](EXTERNAL_DEPENDENCIES.md#AGR_TEXTS) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L169, 182 |
| [AGR_USERS](EXTERNAL_DEPENDENCIES.md#AGR_USERS) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L170 |
| [CONVERSION_EXIT_ALPHA_OUTPUT](EXTERNAL_DEPENDENCIES.md#CONVERSION_EXIT_ALPHA_OUTPUT) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L97, 201, 221 |
| [PA0001](EXTERNAL_DEPENDENCIES.md#PA0001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L93, 217 |
| [T513S](EXTERNAL_DEPENDENCIES.md#T513S) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L231 |
| [ZHRPERSONTBL](ZHRPERSONTBL.md) | **데이터 저장** — MODIFY DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L301 |
| [ZHRPERSONTBL](ZHRPERSONTBL.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L26 |
| [ZHRTAGTBL](ZHRTAGTBL.md) | **데이터 저장** — MODIFY DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L308 |
| [ZHRTAGTBL](ZHRTAGTBL.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L27 |
| [ZHRWORKTBL](ZHRWORKTBL.md) | **데이터 저장** — MODIFY DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L294 |
| [ZHRWORKTBL](ZHRWORKTBL.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L25 |
| [ZHR_STELL_COLOR](ZHR_STELL_COLOR.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L234 |
| [ZHR_WORKINFO_LOG](ZHR_WORKINFO_LOG.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L18 |
| [ZHR_WORK_LIST](ZHR_WORK_LIST.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L11, 21 |
| [ZHR_WORK_PERSON_LIST](ZHR_WORK_PERSON_LIST.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L12, 13, 22 |
| [ZHR_WORK_TAG](ZHR_WORK_TAG.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L14, 23 |
| [ZRPTPS_WORK_ASSIGNMENT](EXT-ZRPTPS_WORK_ASSIGNMENT.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L136 |
| [ZTH0500](EXTERNAL_DEPENDENCIES.md#ZTH0500) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L227, 229 |
| [ZTHR_KOBIS_DATA](EXTERNAL_DEPENDENCIES.md#ZTHR_KOBIS_DATA) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L239 |
| [ZTPS0000](EXTERNAL_DEPENDENCIES.md#ZTPS0000) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L108, 109, 126 |
| [ZTPS7501](EXTERNAL_DEPENDENCIES.md#ZTPS7501) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L90 |
| [ZTPS7523](EXTERNAL_DEPENDENCIES.md#ZTPS7523) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L84 |
| [ZTPS7523_2](EXTERNAL_DEPENDENCIES.md#ZTPS7523_2) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L86 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| — | 색인 내 정적 참조 없음; 미사용 근거 아님 | 동적 호출·외부 시스템은 미확인 |

### 관련 업무와 미확인 범위

- [person-work](../topics/person-work.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
