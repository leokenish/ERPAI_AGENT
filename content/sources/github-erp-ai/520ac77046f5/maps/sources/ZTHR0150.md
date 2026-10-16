---
title: "ZTHR0150 — [52시간] 수습직등급 관리"
as_of: 2026-10-07
review_status: pending_business_review
tags: [기준정보유지보수, 시간외단가등급]
---

# ZTHR0150 — [52시간] 수습직등급 관리

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **DDIC DBtable**. 설명: [52시간] 수습직등급 관리.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0150/definition.xml) | 719행; 원본 보존 |

### 데이터 정의

XML TABCLASS: `TRANSP`. GOTSTATE: `A`. 정의는 운영 행 데이터가 아니다. 구조·타입을 DB 저장 테이블로 해석하지 않는다.

| 필드 | 키 표시 | 타입/데이터요소 | 정의 위치 |
|---|---|---|---|
| `MANDT` | X | MANDT | DD03P_TAB, L63 |
| `PERNR` | X | PERSNO | DD03P_TAB, L129 |
| `ENDDA` | X | ENDDA | DD03P_TAB, L195 |
| `BEGDA` | — | BEGDA | DD03P_TAB, L261 |
| `ZDUNG` | — | ZDUNG | DD03P_TAB, L327 |
| `AEDAT` | — | AEDAT | DD03P_TAB, L393 |
| `AEZET` | — | AEZET | DD03P_TAB, L459 |
| `AENAM` | — | AENAM | DD03P_TAB, L525 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [PA0001](EXTERNAL_DEPENDENCIES.md#PA0001) | **타입 참조** — CHECKTABLE XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0150/definition.xml) L135, 596, 609, 622, 635, 648, 661, 674, 687, 701 |
| [ZDUNG](EXTERNAL_DEPENDENCIES.md#ZDUNG) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0150/definition.xml) L342 |
| [ZDUNG](EXTERNAL_DEPENDENCIES.md#ZDUNG) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0150/definition.xml) L332 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_1F00](LZHR008_1F00.md) | 데이터 저장 | [LZHR008_1F00.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Include/LZHR008_1F00.abap) L3333, 3367, 3369 |
| [LZHR008_1F00](LZHR008_1F00.md) | 데이터 조회 | [LZHR008_1F00.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Include/LZHR008_1F00.abap) L3268, 3329, 3344, 3386 |
| [ZVHR0150](ZVHR0150.md) | 뷰 구성 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/VIEW/ZVHR0150/definition.xml) L53, 75, 123, 171, 219, 267, 315, 363, 411 |

### 관련 업무와 미확인 범위

- [reference-data](../topics/reference-data.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
