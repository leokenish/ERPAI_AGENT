---
title: "ZRPTH419 — 간주근로 대휴관리"
as_of: 2026-10-07
review_status: pending_business_review
tags: [간주근무, 대휴익휴보상휴가]
---

# ZRPTH419 — 간주근로 대휴관리

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 간주근로 대휴관리.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZRPTH419.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419/attributes/ZRPTH419.xml) | 36행; 원본 보존 |
| [ZRPTH419.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419/source/ZRPTH419.abap) | 79행; 원본 보존 |
| [../texts/ZRPTH419.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419/texts/ZRPTH419.xml) | 88행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZRPTH419F01](ZRPTH419F01.md) | **FORM 호출** — BASIC_DATA: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap L164; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH419.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419/source/ZRPTH419.abap) L62 |
| [ZRPTH419F01](ZRPTH419F01.md) | **FORM 호출** — F4_KJDAT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap L106; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH419.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419/source/ZRPTH419.abap) L55 |
| [ZRPTH419F01](ZRPTH419F01.md) | **FORM 호출** — F4_ORGEH: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap L49; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH419.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419/source/ZRPTH419.abap) L45, 48 |
| [ZRPTH419F01](ZRPTH419F01.md) | **FORM 호출** — INIT_DATA: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap L12; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH419.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419/source/ZRPTH419.abap) L26 |
| [ZRPTH419F01](ZRPTH419F01.md) | **FORM 호출** — INSERT_DATA: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap L348; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH419.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419/source/ZRPTH419.abap) L66 |
| [ZRPTH419F01](ZRPTH419F01.md) | **FORM 호출** — SELECT_DATA: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap L307; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH419.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419/source/ZRPTH419.abap) L64 |
| [ZRPTH419F01](ZRPTH419F01.md) | **Include** — 컴파일 소스 포함; 순차 실행 의미 아님 | [ZRPTH419.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419/source/ZRPTH419.abap) L19 |
| [ZRPTH419I01](ZRPTH419I01.md) | **Include** — 컴파일 소스 포함; 순차 실행 의미 아님 | [ZRPTH419.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419/source/ZRPTH419.abap) L18 |
| [ZRPTH419O01](ZRPTH419O01.md) | **Include** — 컴파일 소스 포함; 순차 실행 의미 아님 | [ZRPTH419.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419/source/ZRPTH419.abap) L17 |
| [ZRPTH419SEL](ZRPTH419SEL.md) | **Include** — 컴파일 소스 포함; 순차 실행 의미 아님 | [ZRPTH419.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419/source/ZRPTH419.abap) L16 |
| [ZRPTH419TOP](ZRPTH419TOP.md) | **Include** — 컴파일 소스 포함; 순차 실행 의미 아님 | [ZRPTH419.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419/source/ZRPTH419.abap) L15 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| — | 색인 내 정적 참조 없음; 미사용 근거 아님 | 동적 호출·외부 시스템은 미확인 |

### 관련 업무와 미확인 범위

- [deemed](../topics/deemed.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
