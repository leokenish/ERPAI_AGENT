---
title: "ZRPTH440 — ABAP 프로그램·독립 Include"
as_of: 2026-10-07
review_status: pending_business_review
tags: [근무현황조회, 선택근무]
---

# ZRPTH440 — ABAP 프로그램·독립 Include

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 제목 메타데이터 없음; 이름만으로 업무를 확정하지 않음.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZRPTH440.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/attributes/ZRPTH440.xml) | 36행; 원본 보존 |
| [ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) | 522행; 원본 보존 |
| [../texts/ZRPTH440.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/texts/ZRPTH440.xml) | 40행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [DATE_GET_WEEK](EXTERNAL_DEPENDENCIES.md#DATE_GET_WEEK) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) L105 |
| [PA0001](EXTERNAL_DEPENDENCIES.md#PA0001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) L163, 281, 306 |
| [RHPH_STRUCTURE_READ](EXTERNAL_DEPENDENCIES.md#RHPH_STRUCTURE_READ) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) L367 |
| [RP_PNP_ORGSTRUCTURE](EXTERNAL_DEPENDENCIES.md#RP_PNP_ORGSTRUCTURE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) L231, 341 |
| [T527X](EXTERNAL_DEPENDENCIES.md#T527X) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) L181, 431 |
| [WEEK_GET_FIRST_DAY](EXTERNAL_DEPENDENCIES.md#WEEK_GET_FIRST_DAY) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) L114 |
| [ZALV](EXTERNAL_DEPENDENCIES.md#ZALV) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) L513 |
| [ZHR_52TM_DAILY_WEEKLY_BUSEO](ZHR_52TM_DAILY_WEEKLY_BUSEO.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) L461 |
| [ZHR_GET_MANAGER_TYPE_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_MANAGER_TYPE_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) L311 |
| [ZRPTH440](ZRPTH440.md) | **FORM 호출** — CALC_WEEK_DATE: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap L101; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) L77, 86 |
| [ZRPTH440](ZRPTH440.md) | **FORM 호출** — CHECK_ORG_AUTHORITY: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap L251; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) L87 |
| [ZRPTH440](ZRPTH440.md) | **FORM 호출** — DISPLAY_ALV: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap L511; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) L91 |
| [ZRPTH440](ZRPTH440.md) | **FORM 호출** — GET_DATA: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap L418; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) L88 |
| [ZRPTH440](ZRPTH440.md) | **FORM 호출** — GET_DEPT_DATA: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap L452; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) L422 |
| [ZRPTH440](ZRPTH440.md) | **FORM 호출** — GET_ID_ROLE: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap L140; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) L78 |
| [ZRPTH440](ZRPTH440.md) | **FORM 호출** — VALUE_REQ_ORGEH: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap L227; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) L81 |
| [ZSHR0132_WEB](ZSHR0132_WEB.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) L15, 16, 19, 20, 21, 22, 27, 28, 29, 30, 455 |
| [ZTH0076](EXTERNAL_DEPENDENCIES.md#ZTH0076) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) L155, 265 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [ZRPTH440](ZRPTH440.md) | FORM 호출 | [ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) L77, 78, 81, 86, 87, 88, 91, 422 |

### 관련 업무와 미확인 범위

- [reporting](../topics/reporting.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [selective](../topics/selective.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
