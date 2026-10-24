---
title: "P9023 — 인포타입 9021에 대한 HR 마스터레코드"
as_of: 2026-10-07
review_status: pending_business_review
tags: [시차근무대상자관리, 인사정보형9021_9023]
---

# P9023 — 인포타입 9021에 대한 HR 마스터레코드

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **DDIC Structures**. 설명: 인포타입 9021에 대한 HR 마스터레코드.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/P9023/definition.xml) | 2793행; 원본 보존 |

### 데이터 정의

XML TABCLASS: `INTTAB`. GOTSTATE: `A`. 정의는 운영 행 데이터가 아니다. 구조·타입을 DB 저장 테이블로 해석하지 않는다.

| 필드 | 키 표시 | 타입/데이터요소 | 정의 위치 |
|---|---|---|---|
| `.INCLUDE` | — |  | DD03P_TAB, L63 |
| `.INCLUDE` | — |  | DD03P_TAB, L63 |
| `PERNR` | — | PERNR_D | DD03P_TAB, L195 |
| `INFTY` | — | INFTY | DD03P_TAB, L261 |
| `SUBTY` | — | SUBTY | DD03P_TAB, L327 |
| `OBJPS` | — | OBJPS | DD03P_TAB, L393 |
| `SPRPS` | — | SPRPS | DD03P_TAB, L459 |
| `ENDDA` | — | ENDDA | DD03P_TAB, L525 |
| `BEGDA` | — | BEGDA | DD03P_TAB, L591 |
| `SEQNR` | — | SEQNR | DD03P_TAB, L657 |
| `.INCLUDE` | — |  | DD03P_TAB, L63 |
| `AEDTM` | — | AEDAT | DD03P_TAB, L789 |
| `UNAME` | — | AENAM | DD03P_TAB, L855 |
| `HISTO` | — | HISTO | DD03P_TAB, L921 |
| `ITXEX` | — | ITXEX | DD03P_TAB, L987 |
| `REFEX` | — | PRFEX | DD03P_TAB, L1053 |
| `ORDEX` | — | ORDEX | DD03P_TAB, L1119 |
| `ITBLD` | — | ITBLD | DD03P_TAB, L1185 |
| `PREAS` | — | PREAS | DD03P_TAB, L1251 |
| `FLAG1` | — | NUSED | DD03P_TAB, L1317 |
| `FLAG2` | — | NUSED | DD03P_TAB, L1383 |
| `FLAG3` | — | NUSED | DD03P_TAB, L1449 |
| `FLAG4` | — | NUSED | DD03P_TAB, L1515 |
| `RESE1` | — | NUSED2 | DD03P_TAB, L1581 |
| `RESE2` | — | NUSED2 | DD03P_TAB, L1647 |
| `GRPVL` | — | PCCE_GPVAL | DD03P_TAB, L1713 |
| `.INCLUDE` | — |  | DD03P_TAB, L63 |
| `Z52WKTP` | — | [ZE52WKTP](ZE52WKTP.md) | DD03P_TAB, L1845 |
| `Z52PRSQ` | — | [ZE52PRSQ](ZE52PRSQ.md) | DD03P_TAB, L1911 |
| `COREWK1_B` | — | TIMS | DD03P_TAB, L1977 |
| `COREWK1_E` | — | TIMS | DD03P_TAB, L2043 |
| `COREWK2_B` | — | TIMS | DD03P_TAB, L2109 |
| `COREWK2_E` | — | TIMS | DD03P_TAB, L2175 |
| `PRDTY` | — | [ZEPRDTY](ZEPRDTY.md) | DD03P_TAB, L2241 |
| `GBNTY` | — | [ZEGBNTY](ZEGBNTY.md) | DD03P_TAB, L2307 |
| `JOBTY` | — | [ZEJOBTY](ZEJOBTY.md) | DD03P_TAB, L2373 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [PS9021](PS9021.md) | **타입 참조** — PRECFIELD XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/P9023/definition.xml) L1790 |
| [ZD52WKTP1](ZD52WKTP1.md) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/P9023/definition.xml) L1860, 2746 |
| [ZDPRUT](ZDPRUT.md) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/P9023/definition.xml) L2784 |
| [ZE52PRSQ](ZE52PRSQ.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/P9023/definition.xml) L1916, 2726 |
| [ZE52WKTP](ZE52WKTP.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/P9023/definition.xml) L1850, 2745 |
| [ZEANZHL](ZEANZHL.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/P9023/definition.xml) L2764 |
| [ZEGBNTY](ZEGBNTY.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/P9023/definition.xml) L2312 |
| [ZEJOBTY](ZEJOBTY.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/P9023/definition.xml) L2378 |
| [ZEPRDTY](ZEPRDTY.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/P9023/definition.xml) L2246 |
| [ZEPRUT](ZEPRUT.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/P9023/definition.xml) L2783 |
| [ZTHR0125](ZTHR0125.md) | **타입 참조** — CHECKTABLE XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/P9023/definition.xml) L2247, 2548, 2561, 2574, 2675 |
| [ZTHR0126](ZTHR0126.md) | **타입 참조** — CHECKTABLE XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/P9023/definition.xml) L2313, 2444, 2457, 2470, 2627 |
| [ZTHR0127](ZTHR0127.md) | **타입 참조** — CHECKTABLE XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/P9023/definition.xml) L2379, 2509, 2522, 2535, 2659 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [MP902310](MP902310.md) | 타입 참조 | [MP902310.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MP902310/source/MP902310.abap) L13, 16 |
| [MZH432I01](MZH432I01.md) | 타입 참조 | [MZH432I01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432I01/source/MZH432I01.abap) L419, 420, 422 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
