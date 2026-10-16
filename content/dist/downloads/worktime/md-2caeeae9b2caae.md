---
title: "ZRPTH406TOP — ABAP 프로그램·독립 Include"
as_of: 2026-10-07
review_status: pending_business_review
tags: [특별연장재난방송]
---

# ZRPTH406TOP — ABAP 프로그램·독립 Include

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 제목 메타데이터 없음; 이름만으로 업무를 확정하지 않음.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZRPTH406TOP.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406TOP/attributes/ZRPTH406TOP.xml) | 36행; 원본 보존 |
| [ZRPTH406TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406TOP/source/ZRPTH406TOP.abap) | 131행; 원본 보존 |
| [../texts/ZRPTH406TOP.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406TOP/texts/ZRPTH406TOP.xml) | 9행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [RP_PNP_ORGSTRUCTURE](EXTERNAL_DEPENDENCIES.md#RP_PNP_ORGSTRUCTURE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH406TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406TOP/source/ZRPTH406TOP.abap) L122 |
| [ZE52PRSQ](ZE52PRSQ.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH406TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406TOP/source/ZRPTH406TOP.abap) L36 |
| [ZE52WKTP](ZE52WKTP.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH406TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406TOP/source/ZRPTH406TOP.abap) L34 |
| [ZE52WKTXT](ZE52WKTXT.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH406TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406TOP/source/ZRPTH406TOP.abap) L35 |
| [ZEYOIL](ZEYOIL.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH406TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406TOP/source/ZRPTH406TOP.abap) L47 |
| [ZRPTH406F01](ZRPTH406F01.md) | **FORM 호출** — EVENT_TOP_OF_PAGE: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406F01/source/ZRPTH406F01.abap L308; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH406TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406TOP/source/ZRPTH406TOP.abap) L107 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [ZRPTH406](ZRPTH406.md) | Include | [ZRPTH406.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406/source/ZRPTH406.abap) L10 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
