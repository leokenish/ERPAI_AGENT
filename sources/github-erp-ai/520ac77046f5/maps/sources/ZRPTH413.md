---
title: "ZRPTH413 — 선택근로 일별 근무실적 조회"
as_of: 2026-10-07
review_status: pending_business_review
tags: [근무현황조회, 선택근무]
---

# ZRPTH413 — 선택근로 일별 근무실적 조회

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 선택근로 일별 근무실적 조회.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZRPTH413.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413/attributes/ZRPTH413.xml) | 36행; 원본 보존 |
| [ZRPTH413.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413/source/ZRPTH413.abap) | 83행; 원본 보존 |
| [../texts/ZRPTH413.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413/texts/ZRPTH413.xml) | 46행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZRPTH413F01](ZRPTH413F01.md) | **FORM 호출** — F4_ORGEH: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap L81; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH413.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413/source/ZRPTH413.abap) L45, 48 |
| [ZRPTH413F01](ZRPTH413F01.md) | **FORM 호출** — F4_YM: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap L110; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH413.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413/source/ZRPTH413.abap) L55 |
| [ZRPTH413F01](ZRPTH413F01.md) | **FORM 호출** — INIT_DATA: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap L12; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH413.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413/source/ZRPTH413.abap) L26 |
| [ZRPTH413F01](ZRPTH413F01.md) | **FORM 호출** — SELECT_DATA: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap L465; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH413.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413/source/ZRPTH413.abap) L76 |
| [ZRPTH413F01](ZRPTH413F01.md) | **Include** — 컴파일 소스 포함; 순차 실행 의미 아님 | [ZRPTH413.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413/source/ZRPTH413.abap) L18 |
| [ZRPTH413F02](ZRPTH413F02.md) | **Include** — 컴파일 소스 포함; 순차 실행 의미 아님 | [ZRPTH413.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413/source/ZRPTH413.abap) L19 |
| [ZRPTH413I01](ZRPTH413I01.md) | **Include** — 컴파일 소스 포함; 순차 실행 의미 아님 | [ZRPTH413.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413/source/ZRPTH413.abap) L17 |
| [ZRPTH413O01](ZRPTH413O01.md) | **Include** — 컴파일 소스 포함; 순차 실행 의미 아님 | [ZRPTH413.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413/source/ZRPTH413.abap) L16 |
| [ZRPTH413SEL](ZRPTH413SEL.md) | **Include** — 컴파일 소스 포함; 순차 실행 의미 아님 | [ZRPTH413.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413/source/ZRPTH413.abap) L15 |
| [ZRPTH413TOP](ZRPTH413TOP.md) | **Include** — 컴파일 소스 포함; 순차 실행 의미 아님 | [ZRPTH413.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413/source/ZRPTH413.abap) L14 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| — | 색인 내 정적 참조 없음; 미사용 근거 아님 | 동적 호출·외부 시스템은 미확인 |

### 관련 업무와 미확인 범위

- [reporting](../topics/reporting.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [selective](../topics/selective.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
