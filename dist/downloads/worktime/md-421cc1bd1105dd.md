---
title: "ZRPTH406 — 특별연장근로 관리자 조회"
as_of: 2026-10-07
review_status: pending_business_review
tags: [특별연장재난방송]
---

# ZRPTH406 — 특별연장근로 관리자 조회

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 특별연장근로 관리자 조회.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZRPTH406.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406/attributes/ZRPTH406.xml) | 36행; 원본 보존 |
| [ZRPTH406.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406/source/ZRPTH406.abap) | 59행; 원본 보존 |
| [../texts/ZRPTH406.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406/texts/ZRPTH406.xml) | 64행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZRPTH406F01](ZRPTH406F01.md) | **FORM 호출** — GET_LIST: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406F01/source/ZRPTH406F01.abap L484; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH406.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406/source/ZRPTH406.abap) L44 |
| [ZRPTH406F01](ZRPTH406F01.md) | **FORM 호출** — GET_LIST_2: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406F01/source/ZRPTH406F01.abap L571; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH406.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406/source/ZRPTH406.abap) L51 |
| [ZRPTH406F01](ZRPTH406F01.md) | **FORM 호출** — GET_ORGEH: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406F01/source/ZRPTH406F01.abap L140; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH406.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406/source/ZRPTH406.abap) L33 |
| [ZRPTH406F01](ZRPTH406F01.md) | **FORM 호출** — GET_PERNR_INFO: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406F01/source/ZRPTH406F01.abap L202; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH406.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406/source/ZRPTH406.abap) L45 |
| [ZRPTH406F01](ZRPTH406F01.md) | **FORM 호출** — MODIFY_SCREEN: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406F01/source/ZRPTH406F01.abap L60; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH406.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406/source/ZRPTH406.abap) L27 |
| [ZRPTH406F01](ZRPTH406F01.md) | **FORM 호출** — PROGRESS: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406F01/source/ZRPTH406F01.abap L192; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH406.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406/source/ZRPTH406.abap) L43 |
| [ZRPTH406F01](ZRPTH406F01.md) | **FORM 호출** — SET_INIT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406F01/source/ZRPTH406F01.abap L9; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH406.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406/source/ZRPTH406.abap) L21 |
| [ZRPTH406F01](ZRPTH406F01.md) | **Include** — 컴파일 소스 포함; 순차 실행 의미 아님 | [ZRPTH406.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406/source/ZRPTH406.abap) L13 |
| [ZRPTH406I01](ZRPTH406I01.md) | **Include** — 컴파일 소스 포함; 순차 실행 의미 아님 | [ZRPTH406.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406/source/ZRPTH406.abap) L12 |
| [ZRPTH406O01](ZRPTH406O01.md) | **Include** — 컴파일 소스 포함; 순차 실행 의미 아님 | [ZRPTH406.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406/source/ZRPTH406.abap) L11 |
| [ZRPTH406TOP](ZRPTH406TOP.md) | **Include** — 컴파일 소스 포함; 순차 실행 의미 아님 | [ZRPTH406.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406/source/ZRPTH406.abap) L10 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| — | 색인 내 정적 참조 없음; 미사용 근거 아님 | 동적 호출·외부 시스템은 미확인 |

### 관련 업무와 미확인 범위

- [special-extension](../topics/special-extension.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
