---
title: "ZSWF0016 — [WF] EP 결재함 (선택근로제 목록)"
as_of: 2026-10-07
review_status: pending_business_review
tags: [PC모바일공통웹, 선택근무, 탄력근무, 통합결재, 특별연장재난방송]
---

# ZSWF0016 — [WF] EP 결재함 (선택근로제 목록)

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **DDIC Structures**. 설명: [WF] EP 결재함 (선택근로제 목록).

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) | 3171행; 원본 보존 |

### 데이터 정의

XML TABCLASS: `INTTAB`. GOTSTATE: `A`. 정의는 운영 행 데이터가 아니다. 구조·타입을 DB 저장 테이블로 해석하지 않는다.

| 필드 | 키 표시 | 타입/데이터요소 | 정의 위치 |
|---|---|---|---|
| `Z52WKTP` | — | [ZE52WKTP](ZE52WKTP.md) | DD03P_TAB, L63 |
| `Z52WKTXT` | — | [ZE52WKTXT](ZE52WKTXT.md) | DD03P_TAB, L129 |
| `PERNR` | — | PERSNO | DD03P_TAB, L195 |
| `ENAME` | — | EMNAM | DD03P_TAB, L261 |
| `ORGTX` | — | CHAR | DD03P_TAB, L327 |
| `ZPERIOD` | — | CHAR | DD03P_TAB, L393 |
| `DATUM` | — | DATUM | DD03P_TAB, L459 |
| `ZYOIL` | — | ZYOIL | DD03P_TAB, L525 |
| `BEGDA` | — | BEGDA | DD03P_TAB, L591 |
| `ENDDA` | — | ENDDA | DD03P_TAB, L657 |
| `ZBEGTM` | — | BEGTI | DD03P_TAB, L723 |
| `ZENDTM` | — | ENDTI | DD03P_TAB, L789 |
| `ZTOMO` | — | ZTOMO | DD03P_TAB, L855 |
| `ZGUBUN` | — | ZBSGUBUN | DD03P_TAB, L921 |
| `ZGUBUN_TXT` | — | ZGUBUN_TXT | DD03P_TAB, L987 |
| `ZRLWK_TM` | — | [ZERLWK_TM](ZERLWK_TM.md) | DD03P_TAB, L1053 |
| `ZEMCWK` | — | [ZEEMCWK](ZEEMCWK.md) | DD03P_TAB, L1119 |
| `ZOVRNGT` | — | [ZEOVRNGT](ZEOVRNGT.md) | DD03P_TAB, L1185 |
| `TWKHR` | — | [ZETWKHR](ZETWKHR.md) | DD03P_TAB, L1251 |
| `NWKHR` | — | [ZENWKHR](ZENWKHR.md) | DD03P_TAB, L1317 |
| `PWKHR` | — | [ZEPWKHR](ZEPWKHR.md) | DD03P_TAB, L1383 |
| `OWKHR` | — | [ZEOWKHR](ZEOWKHR.md) | DD03P_TAB, L1449 |
| `ZTEXT` | — | ZBSTEXT | DD03P_TAB, L1515 |
| `ZSAYU` | — | ZSAYU | DD03P_TAB, L1581 |
| `ZSTAT` | — | CHAR | DD03P_TAB, L1647 |
| `KEY12` | — | SWW_WIID | DD03P_TAB, L1713 |
| `STATE` | — | ZSTATE_1 | DD03P_TAB, L1779 |
| `SEQNR` | — | SEQNR | DD03P_TAB, L1845 |
| `.INCLUDE` | — |  | DD03P_TAB, L1911 |
| `TABNAME` | — | TABNAME | DD03P_TAB, L1977 |
| `ZWFTYPE` | — | ZWFTYPE | DD03P_TAB, L2043 |
| `WI_ID` | — | SWW_WIID | DD03P_TAB, L2109 |
| `ZORDR` | — | ZORDR | DD03P_TAB, L2175 |
| `CODE` | — | Z_CODE | DD03P_TAB, L2241 |
| `ZBNAME` | — | XUBNAME | DD03P_TAB, L2307 |
| `ZNAME1` | — | ZNAME | DD03P_TAB, L2373 |
| `ZPERNR` | — | PERSNO | DD03P_TAB, L2439 |
| `ZBNAME_A` | — | XUBNAME | DD03P_TAB, L2505 |
| `ZNAME1_A` | — | ZNAME | DD03P_TAB, L2571 |
| `ZPERNR_A` | — | PERSNO | DD03P_TAB, L2637 |
| `ZAPDT` | — | ZAPDT | DD03P_TAB, L2703 |
| `ZAPHR` | — | ZHOUR | DD03P_TAB, L2769 |
| `ZAPDT_A` | — | ZAPDT | DD03P_TAB, L2835 |
| `ZAPHR_A` | — | ZHOUR | DD03P_TAB, L2901 |
| `ZSTTS` | — | ZATTS | DD03P_TAB, L2967 |
| `ZSTTS_TXT` | — | CHAR20 | DD03P_TAB, L3033 |
| `ZWI_ID` | — | ZSWW_WIID | DD03P_TAB, L3099 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZAPDT](EXTERNAL_DEPENDENCIES.md#ZAPDT) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L2708, 2840 |
| [ZATTS](EXTERNAL_DEPENDENCIES.md#ZATTS) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L2982 |
| [ZATTS](EXTERNAL_DEPENDENCIES.md#ZATTS) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L2972 |
| [ZBSGUBUN](EXTERNAL_DEPENDENCIES.md#ZBSGUBUN) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L926 |
| [ZBSGUBUN1](ZBSGUBUN1.md) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L936 |
| [ZBSTEXT](EXTERNAL_DEPENDENCIES.md#ZBSTEXT) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L1520 |
| [ZD52WKTP1](ZD52WKTP1.md) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L78 |
| [ZE52WKTP](ZE52WKTP.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L68 |
| [ZE52WKTXT](ZE52WKTXT.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L134 |
| [ZEEMCWK](ZEEMCWK.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L1124 |
| [ZENWKHR](ZENWKHR.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L1322 |
| [ZEOVRNGT](ZEOVRNGT.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L1190 |
| [ZEOWKHR](ZEOWKHR.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L1454 |
| [ZEPWKHR](ZEPWKHR.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L1388 |
| [ZERLWK_TM](ZERLWK_TM.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L1058 |
| [ZETWKHR](ZETWKHR.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L1256 |
| [ZGUBUN_TXT](EXTERNAL_DEPENDENCIES.md#ZGUBUN_TXT) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L992 |
| [ZHOUR](EXTERNAL_DEPENDENCIES.md#ZHOUR) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L2774, 2906 |
| [ZNAME](EXTERNAL_DEPENDENCIES.md#ZNAME) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L2388, 2586 |
| [ZNAME](EXTERNAL_DEPENDENCIES.md#ZNAME) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L2378, 2576 |
| [ZORDR](EXTERNAL_DEPENDENCIES.md#ZORDR) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L2180 |
| [ZSAYU](EXTERNAL_DEPENDENCIES.md#ZSAYU) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L1586 |
| [ZSTATE_1](EXTERNAL_DEPENDENCIES.md#ZSTATE_1) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L1794 |
| [ZSTATE_1](EXTERNAL_DEPENDENCIES.md#ZSTATE_1) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L1784 |
| [ZSWF0010](EXTERNAL_DEPENDENCIES.md#ZSWF0010) | **타입 참조** — PRECFIELD XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L1922 |
| [ZSWW_WIID](EXTERNAL_DEPENDENCIES.md#ZSWW_WIID) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L3104 |
| [ZTOMO](EXTERNAL_DEPENDENCIES.md#ZTOMO) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L860 |
| [ZWFTYPE](EXTERNAL_DEPENDENCIES.md#ZWFTYPE) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L2058 |
| [ZWFTYPE](EXTERNAL_DEPENDENCIES.md#ZWFTYPE) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L2048 |
| [ZYOIL](EXTERNAL_DEPENDENCIES.md#ZYOIL) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L530 |
| [Z_CODE](EXTERNAL_DEPENDENCIES.md#Z_CODE) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L2256 |
| [Z_CODE](EXTERNAL_DEPENDENCIES.md#Z_CODE) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L2246 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [ZHR_52TM_APPROVAL_LIST](ZHR_52TM_APPROVAL_LIST.md) | 타입 참조 | [ZHR_52TM_APPROVAL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Source%20code/ZHR_52TM_APPROVAL_LIST.abap) L29 |
| [ZHR_52TM_DAILY_APPROVE_DETAIL](ZHR_52TM_DAILY_APPROVE_DETAIL.md) | 타입 참조 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_DETAIL/Export.xml) L12 |
| [ZSWF0016_TAB](ZSWF0016_TAB.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/TableType/ZSWF0016_TAB/definition.xml) L10 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
