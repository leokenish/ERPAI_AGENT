---
title: "ZRPTH402TOP — ABAP 프로그램·독립 Include"
as_of: 2026-10-07
review_status: pending_business_review
tags: [월정산전표지급, 탄력근무]
---

# ZRPTH402TOP — ABAP 프로그램·독립 Include

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 제목 메타데이터 없음; 이름만으로 업무를 확정하지 않음.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZRPTH402TOP.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402TOP/attributes/ZRPTH402TOP.xml) | 36행; 원본 보존 |
| [ZRPTH402TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402TOP/source/ZRPTH402TOP.abap) | 158행; 원본 보존 |
| [../texts/ZRPTH402TOP.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402TOP/texts/ZRPTH402TOP.xml) | 16행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZE52PRSQ](ZE52PRSQ.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH402TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402TOP/source/ZRPTH402TOP.abap) L135 |
| [ZE52WKTP](ZE52WKTP.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH402TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402TOP/source/ZRPTH402TOP.abap) L133 |
| [ZE52WKTXT](ZE52WKTXT.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH402TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402TOP/source/ZRPTH402TOP.abap) L95, 108 |
| [ZEADMIT_DT](ZEADMIT_DT.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH402TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402TOP/source/ZRPTH402TOP.abap) L104 |
| [ZEOTPAYAMT](ZEOTPAYAMT.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH402TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402TOP/source/ZRPTH402TOP.abap) L109 |
| [ZEZADMIT_YM](ZEZADMIT_YM.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH402TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402TOP/source/ZRPTH402TOP.abap) L103 |
| [ZRPTH402F01](ZRPTH402F01.md) | **FORM 호출** — EVENT_TOP_OF_PAGE: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap L933; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH402TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402TOP/source/ZRPTH402TOP.abap) L73 |
| [ZTHR0106](ZTHR0106.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH402TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402TOP/source/ZRPTH402TOP.abap) L117 |
| [ZTHR0110](ZTHR0110.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH402TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402TOP/source/ZRPTH402TOP.abap) L86, 120 |
| [ZTHR0120](ZTHR0120.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH402TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402TOP/source/ZRPTH402TOP.abap) L97, 118 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [ZRPTH402](ZRPTH402.md) | Include | [ZRPTH402.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402/source/ZRPTH402.abap) L14 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
