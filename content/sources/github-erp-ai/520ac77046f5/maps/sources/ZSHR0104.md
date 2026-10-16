---
title: "ZSHR0104 — [52시간] 휴게시간"
as_of: 2026-10-07
review_status: pending_business_review
tags: [IAM등록기본설정, PC모바일공통웹, 간주근무, 교대근무, 근로시간알림, 근무현황조회, 대휴익휴보상휴가, 선택근무, 시간외단가등급, 월정산전표지급, 인사정보형9021_9023, 자료복사결재보정, 탄력근무, 통상시차시간외, 통합결재, 퇴직자관리자입력검토, 특별연장재난방송, 휴가공가반차]
---

# ZSHR0104 — [52시간] 휴게시간

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **DDIC Structures**. 설명: [52시간] 휴게시간.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0104/definition.xml) | 1389행; 원본 보존 |

### 데이터 정의

XML TABCLASS: `INTTAB`. GOTSTATE: `A`. 정의는 운영 행 데이터가 아니다. 구조·타입을 DB 저장 테이블로 해석하지 않는다.

| 필드 | 키 표시 | 타입/데이터요소 | 정의 위치 |
|---|---|---|---|
| `ZPBEG1` | — | PDBEG | DD03P_TAB, L63 |
| `ZPBTM1` | — | ZTOMO | DD03P_TAB, L129 |
| `ZPEND1` | — | PDEND | DD03P_TAB, L195 |
| `ZPETM1` | — | ZTOMO | DD03P_TAB, L261 |
| `ZPBEG2` | — | PDBEG | DD03P_TAB, L327 |
| `ZPBTM2` | — | ZTOMO | DD03P_TAB, L393 |
| `ZPEND2` | — | PDEND | DD03P_TAB, L459 |
| `ZPETM2` | — | ZTOMO | DD03P_TAB, L525 |
| `ZPBEG3` | — | PDBEG | DD03P_TAB, L591 |
| `ZPBTM3` | — | ZTOMO | DD03P_TAB, L657 |
| `ZPEND3` | — | PDEND | DD03P_TAB, L723 |
| `ZPETM3` | — | ZTOMO | DD03P_TAB, L789 |
| `ZPBEG4` | — | PDBEG | DD03P_TAB, L855 |
| `ZPBTM4` | — | ZTOMO | DD03P_TAB, L921 |
| `ZPEND4` | — | PDEND | DD03P_TAB, L987 |
| `ZPETM4` | — | ZTOMO | DD03P_TAB, L1053 |
| `ZPBEG5` | — | PDBEG | DD03P_TAB, L1119 |
| `ZPBTM5` | — | ZTOMO | DD03P_TAB, L1185 |
| `ZPEND5` | — | PDEND | DD03P_TAB, L1251 |
| `ZPETM5` | — | ZTOMO | DD03P_TAB, L1317 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZTOMO](EXTERNAL_DEPENDENCIES.md#ZTOMO) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0104/definition.xml) L134, 266, 398, 530, 662, 794, 926, 1058, 1190, 1322 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F01](LZHR008_2F01.md) | 타입 참조 | [LZHR008_2F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap) L1705 |
| [LZHR008_2F06](LZHR008_2F06.md) | 타입 참조 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L432, 978 |
| [MZH4110I01](MZH4110I01.md) | 타입 참조 | [MZH4110I01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110I01/source/MZH4110I01.abap) L148 |
| [ZSHR0110](ZSHR0110.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0110/definition.xml) L470 |
| [ZSHR0115](ZSHR0115.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0115/definition.xml) L932 |
| [ZSHR0117](ZSHR0117.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0117/definition.xml) L668 |
| [ZSHR0121](ZSHR0121.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0121/definition.xml) L998 |
| [ZSHR0130](ZSHR0130.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0130/definition.xml) L7070 |
| [ZSHR0131](ZSHR0131.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0131/definition.xml) L866 |
| [ZSHR0132](ZSHR0132.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0132/definition.xml) L7070 |
| [ZSHR0134](ZSHR0134.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0134/definition.xml) L7070 |
| [ZSHR0141](ZSHR0141.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0141/definition.xml) L2384 |
| [ZSHR0142](ZSHR0142.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0142/definition.xml) L272 |
| [ZSHR0145](ZSHR0145.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0145/definition.xml) L1064 |
| [ZSWF0015](ZSWF0015.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0015/definition.xml) L2120 |
| [ZTHR0107](ZTHR0107.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0107/definition.xml) L536 |
| [ZTHR0108](ZTHR0108.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0108/definition.xml) L668 |
| [ZTHR0110](ZTHR0110.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0110/definition.xml) L602 |
| [ZTHR0112](ZTHR0112.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0112/definition.xml) L998 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
