---
title: "ZSH_PERSONNEL_DATA_N — [시간외] 사원정보"
as_of: 2026-10-07
review_status: pending_business_review
tags: [교대근무, 근무현황조회, 선택근무, 시간외단가등급, 월정산전표지급, 통상시차시간외, 통합결재, 퇴직자관리자입력검토]
---

# ZSH_PERSONNEL_DATA_N — [시간외] 사원정보

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **DDIC Structures**. 설명: [시간외] 사원정보.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) | 3039행; 원본 보존 |

### 데이터 정의

XML TABCLASS: `INTTAB`. GOTSTATE: `A`. 정의는 운영 행 데이터가 아니다. 구조·타입을 DB 저장 테이블로 해석하지 않는다.

| 필드 | 키 표시 | 타입/데이터요소 | 정의 위치 |
|---|---|---|---|
| `.INCLUDE` | — |  | DD03P_TAB, L63 |
| `PERNR` | — | PERSNO | DD03P_TAB, L129 |
| `ENAME` | — | ZNAMEKO | DD03P_TAB, L195 |
| `PERSG` | — | PERSG | DD03P_TAB, L261 |
| `PERSG_TXT` | — | PGTXT | DD03P_TAB, L327 |
| `PERSK` | — | PERSK | DD03P_TAB, L393 |
| `PERSK_TXT` | — | PKTXT | DD03P_TAB, L459 |
| `WERKS` | — | PERSA | DD03P_TAB, L525 |
| `WERKS_TXT` | — | PBTXT | DD03P_TAB, L591 |
| `BTRTL` | — | BTRTL | DD03P_TAB, L657 |
| `BTRTL_TXT` | — | BTRTX | DD03P_TAB, L723 |
| `GSBER` | — | GSBER | DD03P_TAB, L789 |
| `GSBER_TXT` | — | GTEXT | DD03P_TAB, L855 |
| `KOSTL` | — | KOSTL | DD03P_TAB, L921 |
| `KOSTL_TXT` | — | ZKOSTL_TXT | DD03P_TAB, L987 |
| `ORGEH` | — | ORGEH | DD03P_TAB, L1053 |
| `ORGEH_TXT` | — | ORGTX | DD03P_TAB, L1119 |
| `VDSK1` | — | VDSK1 | DD03P_TAB, L1185 |
| `VDSK1_TXT` | — | ORGTX | DD03P_TAB, L1251 |
| `VDSK1_FTXT` | — | ZVDSK1_FTXT | DD03P_TAB, L1317 |
| `ZORDER` | — | ZORDER | DD03P_TAB, L1383 |
| `PLANS` | — | PLANS | DD03P_TAB, L1449 |
| `PLANS_TXT` | — | ZPLANS_TXT | DD03P_TAB, L1515 |
| `STELL` | — | STELL | DD03P_TAB, L1581 |
| `STELL_TXT` | — | ZSTELL_TXT | DD03P_TAB, L1647 |
| `JIKGUN` | — | ZJIKGUN | DD03P_TAB, L1713 |
| `JIKGUN_K` | — | ZJIKGUN_K | DD03P_TAB, L1779 |
| `JIKJONG` | — | ZANSVH1 | DD03P_TAB, L1845 |
| `JIKJONG_K` | — | ZANSVH1_K | DD03P_TAB, L1911 |
| `JIKWINAME` | — | ZANSVH2 | DD03P_TAB, L1977 |
| `JIKWINAME_1` | — | ZJWNAME | DD03P_TAB, L2043 |
| `JIKWIDUNG` | — | ZANSVH3 | DD03P_TAB, L2109 |
| `JIKWIDUNG_1` | — | ZTITEL | DD03P_TAB, L2175 |
| `JIKWIGUBUN` | — | ZANSVH4 | DD03P_TAB, L2241 |
| `JIKWIGUBUN_K` | — | ZANSVH4_K | DD03P_TAB, L2307 |
| `TRFGR` | — | ZTRFGR | DD03P_TAB, L2373 |
| `TRFST` | — | ZTRFST | DD03P_TAB, L2439 |
| `JKNG` | — | ZJKNG | DD03P_TAB, L2505 |
| `JKNG_TXT` | — | ZJKNGNM | DD03P_TAB, L2571 |
| `JKGB` | — | ZJKGB | DD03P_TAB, L2637 |
| `JIKKNAME` | — | ZJGNM | DD03P_TAB, L2703 |
| `KBSIB` | — | ZKBSIB | DD03P_TAB, L2769 |
| `ZMANAGER` | — | CHAR | DD03P_TAB, L2835 |
| `ATEXT` | — | ABWTXT | DD03P_TAB, L2901 |
| `KIND` | — | CHAR | DD03P_TAB, L2967 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZANSVH1](EXTERNAL_DEPENDENCIES.md#ZANSVH1) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L1850 |
| [ZANSVH1_K](EXTERNAL_DEPENDENCIES.md#ZANSVH1_K) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L1916 |
| [ZANSVH2](EXTERNAL_DEPENDENCIES.md#ZANSVH2) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L1982 |
| [ZANSVH3](EXTERNAL_DEPENDENCIES.md#ZANSVH3) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L2124 |
| [ZANSVH3](EXTERNAL_DEPENDENCIES.md#ZANSVH3) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L2114 |
| [ZANSVH4](EXTERNAL_DEPENDENCIES.md#ZANSVH4) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L2246 |
| [ZANSVH4_K](EXTERNAL_DEPENDENCIES.md#ZANSVH4_K) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L2312 |
| [ZDATE](EXTERNAL_DEPENDENCIES.md#ZDATE) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L2784 |
| [ZJGNM](EXTERNAL_DEPENDENCIES.md#ZJGNM) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L2708 |
| [ZJIKGUN](EXTERNAL_DEPENDENCIES.md#ZJIKGUN) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L1728 |
| [ZJIKGUN](EXTERNAL_DEPENDENCIES.md#ZJIKGUN) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L1718 |
| [ZJIKGUN_K](EXTERNAL_DEPENDENCIES.md#ZJIKGUN_K) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L1784 |
| [ZJKGB](EXTERNAL_DEPENDENCIES.md#ZJKGB) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L2642 |
| [ZJKNG](EXTERNAL_DEPENDENCIES.md#ZJKNG) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L2510 |
| [ZJKNGNM](EXTERNAL_DEPENDENCIES.md#ZJKNGNM) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L2576 |
| [ZJWNAME](EXTERNAL_DEPENDENCIES.md#ZJWNAME) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L2048 |
| [ZKBSIB](EXTERNAL_DEPENDENCIES.md#ZKBSIB) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L2774 |
| [ZKOSTL_TXT](EXTERNAL_DEPENDENCIES.md#ZKOSTL_TXT) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L992 |
| [ZNAMEKO](EXTERNAL_DEPENDENCIES.md#ZNAMEKO) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L200 |
| [ZORDER](EXTERNAL_DEPENDENCIES.md#ZORDER) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L1388 |
| [ZPLANS_TXT](EXTERNAL_DEPENDENCIES.md#ZPLANS_TXT) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L1520 |
| [ZSH_PERSONNEL_DATA](EXTERNAL_DEPENDENCIES.md#ZSH_PERSONNEL_DATA) | **타입 참조** — PRECFIELD XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L74 |
| [ZSTELL_TXT](EXTERNAL_DEPENDENCIES.md#ZSTELL_TXT) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L1652 |
| [ZTITEL](EXTERNAL_DEPENDENCIES.md#ZTITEL) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L2180 |
| [ZTRFGR](EXTERNAL_DEPENDENCIES.md#ZTRFGR) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L2388 |
| [ZTRFGR](EXTERNAL_DEPENDENCIES.md#ZTRFGR) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L2378 |
| [ZTRFST](EXTERNAL_DEPENDENCIES.md#ZTRFST) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L2444 |
| [ZVDSK1_FTXT](EXTERNAL_DEPENDENCIES.md#ZVDSK1_FTXT) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSH_PERSONNEL_DATA_N/definition.xml) L1322 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F06](LZHR008_2F06.md) | 타입 참조 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L82, 263 |
| [MZH4110F01](MZH4110F01.md) | 타입 참조 | [MZH4110F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110F01/source/MZH4110F01.abap) L610, 1548 |
| [ZHR_52TM_GET_PERSONNEL_DATA_N](ZHR_52TM_GET_PERSONNEL_DATA_N.md) | 타입 참조 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Export.xml) L23 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
