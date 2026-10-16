---
title: "ZTHR0127 — [52시간] 재량근로 직무"
as_of: 2026-10-07
review_status: pending_business_review
tags: [IAM등록기본설정, 간주근무, 교대근무, 근로시간알림, 근무현황조회, 기준정보유지보수, 대휴익휴보상휴가, 선택근무, 시간외단가등급, 시차근무대상자관리, 월정산전표지급, 인사정보형9021_9023, 재량근무, 탄력근무, 통상시차시간외, 통합결재, 퇴직자관리자입력검토, 특별연장재난방송, 휴가공가반차]
---

# ZTHR0127 — [52시간] 재량근로 직무

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **DDIC DBtable**. 설명: [52시간] 재량근로 직무.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0127/definition.xml) | 663행; 원본 보존 |

### 데이터 정의

XML TABCLASS: `TRANSP`. GOTSTATE: `A`. 정의는 운영 행 데이터가 아니다. 구조·타입을 DB 저장 테이블로 해석하지 않는다.

| 필드 | 키 표시 | 타입/데이터요소 | 정의 위치 |
|---|---|---|---|
| `MANDT` | X | MANDT | DD03P_TAB, L63 |
| `JOBTY` | X | [ZEJOBTY](ZEJOBTY.md) | DD03P_TAB, L129 |
| `ENDDA` | X | ENDDA | DD03P_TAB, L195 |
| `BEGDA` | — | BEGDA | DD03P_TAB, L261 |
| `JOBTX` | — | [ZEJOBTX](ZEJOBTX.md) | DD03P_TAB, L327 |
| `.INCLUDE` | — |  | DD03P_TAB, L393 |
| `AEDAT` | — | AEDAT | DD03P_TAB, L459 |
| `AEZET` | — | AEZET | DD03P_TAB, L525 |
| `AENAM` | — | AENAM | DD03P_TAB, L591 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZEJOBTX](ZEJOBTX.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0127/definition.xml) L332 |
| [ZEJOBTY](ZEJOBTY.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0127/definition.xml) L134 |
| [ZSHR0101](ZSHR0101.md) | **타입 참조** — PRECFIELD XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0127/definition.xml) L404 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_1F00](LZHR008_1F00.md) | 데이터 저장 | [LZHR008_1F00.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Include/LZHR008_1F00.abap) L2027, 2061, 2063 |
| [LZHR008_1F00](LZHR008_1F00.md) | 데이터 조회 | [LZHR008_1F00.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Include/LZHR008_1F00.abap) L1969, 2023, 2038, 2080, 2172, 2327, 2416, 2470, 2625, 2714, 2768, 2923, 3012 |
| [MP902110](MP902110.md) | 타입 참조 | [MP902110.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MP902110/source/MP902110.abap) L27 |
| [MP902140](MP902140.md) | 데이터 조회 | [MP902140.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MP902140/source/MP902140.abap) L239, 318 |
| [MP902140](MP902140.md) | 타입 참조 | [MP902140.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MP902140/source/MP902140.abap) L224, 225 |
| [P9021](P9021.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/P9021/definition.xml) L2379, 2509, 2522, 2535, 2659 |
| [P9023](P9023.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/P9023/definition.xml) L2379, 2509, 2522, 2535, 2659 |
| [PA9021](PA9021.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/PA9021/definition.xml) L2313, 2417, 2430, 2443, 2577 |
| [PS9021](PS9021.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/PS9021/definition.xml) L597, 701, 714, 727, 796 |
| [ZH_JOBTY](ZH_JOBTY.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/SHLP/ZH_JOBTY/definition.xml) L15 |
| [ZRPTH407F01](ZRPTH407F01.md) | 데이터 조회 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L218 |
| [ZRPTH407F01](ZRPTH407F01.md) | 타입 참조 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L162 |
| [ZRPTH407TOP](ZRPTH407TOP.md) | 타입 참조 | [ZRPTH407TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407TOP/source/ZRPTH407TOP.abap) L17 |
| [ZRPTH408F01](ZRPTH408F01.md) | 데이터 조회 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L315 |
| [ZRPTH408F01](ZRPTH408F01.md) | 타입 참조 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L180 |
| [ZRPTH408TOP](ZRPTH408TOP.md) | 타입 참조 | [ZRPTH408TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408TOP/source/ZRPTH408TOP.abap) L18 |
| [ZRPTH409F01](ZRPTH409F01.md) | 데이터 조회 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L313 |
| [ZRPTH409F01](ZRPTH409F01.md) | 타입 참조 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L180 |
| [ZRPTH409TOP](ZRPTH409TOP.md) | 타입 참조 | [ZRPTH409TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409TOP/source/ZRPTH409TOP.abap) L17 |
| [ZRPTH419TOP](ZRPTH419TOP.md) | 타입 참조 | [ZRPTH419TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419TOP/source/ZRPTH419TOP.abap) L17 |
| [ZTHR0128](ZTHR0128.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0128/definition.xml) L267, 899, 912, 925, 1020 |
| [ZTHR0129](ZTHR0129.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0129/definition.xml) L267, 899, 912, 925, 994 |
| [ZTHR0130](ZTHR0130.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0130/definition.xml) L267, 899, 912, 925, 1020 |
| [ZVHR0127](ZVHR0127.md) | 뷰 구성 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/VIEW/ZVHR0127/definition.xml) L53, 66, 114, 162, 210, 258, 306, 354, 402 |
| [ZVHR0128](ZVHR0128.md) | 뷰 구성 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/VIEW/ZVHR0128/definition.xml) L80, 573 |
| [ZVHR0128](ZVHR0128.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/VIEW/ZVHR0128/definition.xml) L251 |
| [ZVHR0129](ZVHR0129.md) | 뷰 구성 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/VIEW/ZVHR0129/definition.xml) L80, 381 |
| [ZVHR0129](ZVHR0129.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/VIEW/ZVHR0129/definition.xml) L347 |
| [ZVHR0130](ZVHR0130.md) | 뷰 구성 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/VIEW/ZVHR0130/definition.xml) L80, 573 |
| [ZVHR0130](ZVHR0130.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/VIEW/ZVHR0130/definition.xml) L251 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
