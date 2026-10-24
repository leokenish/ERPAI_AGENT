---
title: "ZTHR0132 — [52시간] 선택근로제 기간"
as_of: 2026-10-07
review_status: pending_business_review
tags: [PC모바일공통웹, 간주근무, 근로시간알림, 근무현황조회, 대휴익휴보상휴가, 선택근무, 시간외단가등급, 월정산전표지급, 퇴직자관리자입력검토, 특별연장재난방송, 휴가공가반차]
---

# ZTHR0132 — [52시간] 선택근로제 기간

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **DDIC DBtable**. 설명: [52시간] 선택근로제 기간.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0132/definition.xml) | 993행; 원본 보존 |

### 데이터 정의

XML TABCLASS: `TRANSP`. GOTSTATE: `A`. 정의는 운영 행 데이터가 아니다. 구조·타입을 DB 저장 테이블로 해석하지 않는다.

| 필드 | 키 표시 | 타입/데이터요소 | 정의 위치 |
|---|---|---|---|
| `MANDT` | X | MANDT | DD03P_TAB, L63 |
| `PERNR` | X | PERSNO | DD03P_TAB, L129 |
| `BEGDA` | X | BEGDA | DD03P_TAB, L195 |
| `ENDDA` | X | ENDDA | DD03P_TAB, L261 |
| `Z52WKTP` | X | [ZE52WKTP](ZE52WKTP.md) | DD03P_TAB, L327 |
| `Z52PRSQ` | X | [ZE52PRSQ](ZE52PRSQ.md) | DD03P_TAB, L393 |
| `TWKHR` | — | [ZETWKHR](ZETWKHR.md) | DD03P_TAB, L459 |
| `PWKHR` | — | [ZEPWKHR](ZEPWKHR.md) | DD03P_TAB, L525 |
| `HODHR` | — | [ZEHODHR](ZEHODHR.md) | DD03P_TAB, L591 |
| `OWKHR` | — | [ZEOWKHR](ZEOWKHR.md) | DD03P_TAB, L657 |
| `.INCLUDE` | — |  | DD03P_TAB, L723 |
| `AEDAT` | — | AEDAT | DD03P_TAB, L789 |
| `AEZET` | — | AEZET | DD03P_TAB, L855 |
| `AENAM` | — | AENAM | DD03P_TAB, L921 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZD52WKTP1](ZD52WKTP1.md) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0132/definition.xml) L342 |
| [ZE52PRSQ](ZE52PRSQ.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0132/definition.xml) L398 |
| [ZE52WKTP](ZE52WKTP.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0132/definition.xml) L332 |
| [ZEHODHR](ZEHODHR.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0132/definition.xml) L596 |
| [ZEOWKHR](ZEOWKHR.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0132/definition.xml) L662 |
| [ZEPWKHR](ZEPWKHR.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0132/definition.xml) L530 |
| [ZETWKHR](ZETWKHR.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0132/definition.xml) L464 |
| [ZSHR0101](ZSHR0101.md) | **타입 참조** — PRECFIELD XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0132/definition.xml) L734 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_3F01](LZHR008_3F01.md) | 데이터 조회 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L40 |
| [LZHR008_3F03](LZHR008_3F03.md) | 데이터 조회 | [LZHR008_3F03.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap) L1010 |
| [LZHR008_3F03](LZHR008_3F03.md) | 타입 참조 | [LZHR008_3F03.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap) L966 |
| [LZHR008_3F04](LZHR008_3F04.md) | 타입 참조 | [LZHR008_3F04.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F04.abap) L66 |
| [ZHR_52TM_CW_BASE_DATA](ZHR_52TM_CW_BASE_DATA.md) | 데이터 조회 | [ZHR_52TM_CW_BASE_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Source%20code/ZHR_52TM_CW_BASE_DATA.abap) L61 |
| [ZHR_52TM_CW_BASE_DATA](ZHR_52TM_CW_BASE_DATA.md) | 타입 참조 | [ZHR_52TM_CW_BASE_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Source%20code/ZHR_52TM_CW_BASE_DATA.abap) L17 |
| [ZHR_52TM_CW_CAL_AND_DAEH](ZHR_52TM_CW_CAL_AND_DAEH.md) | 타입 참조 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Tables.xml) L9 |
| [ZHR_52TM_CW_PAYMENT_WKPRD](ZHR_52TM_CW_PAYMENT_WKPRD.md) | 데이터 조회 | [ZHR_52TM_CW_PAYMENT_WKPRD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Source%20code/ZHR_52TM_CW_PAYMENT_WKPRD.abap) L79, 114 |
| [ZHR_52TM_CW_PAYMENT_WKPRD](ZHR_52TM_CW_PAYMENT_WKPRD.md) | 타입 참조 | [ZHR_52TM_CW_PAYMENT_WKPRD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Source%20code/ZHR_52TM_CW_PAYMENT_WKPRD.abap) L31 |
| [ZHR_52TM_CW_PROCESS_DATA](ZHR_52TM_CW_PROCESS_DATA.md) | 데이터 조회 | [ZHR_52TM_CW_PROCESS_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Source%20code/ZHR_52TM_CW_PROCESS_DATA.abap) L24 |
| [ZHR_52TM_CW_PROCESS_DATA](ZHR_52TM_CW_PROCESS_DATA.md) | 타입 참조 | [ZHR_52TM_CW_PROCESS_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Source%20code/ZHR_52TM_CW_PROCESS_DATA.abap) L17 |
| [ZHR_52TM_CW_SET_ITEM](ZHR_52TM_CW_SET_ITEM.md) | 타입 참조 | [ZHR_52TM_CW_SET_ITEM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_SET_ITEM/Source%20code/ZHR_52TM_CW_SET_ITEM.abap) L14 |
| [ZHR_52TM_DAILY_WEEKLY_BUSEO](ZHR_52TM_DAILY_WEEKLY_BUSEO.md) | 데이터 조회 | [ZHR_52TM_DAILY_WEEKLY_BUSEO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Source%20code/ZHR_52TM_DAILY_WEEKLY_BUSEO.abap) L126, 205 |
| [ZHR_52TM_DAILY_WEEKLY_BUSEO](ZHR_52TM_DAILY_WEEKLY_BUSEO.md) | 타입 참조 | [ZHR_52TM_DAILY_WEEKLY_BUSEO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Source%20code/ZHR_52TM_DAILY_WEEKLY_BUSEO.abap) L15 |
| [ZHR_52TM_WEEKLY_ZEMCWK](ZHR_52TM_WEEKLY_ZEMCWK.md) | 데이터 조회 | [ZHR_52TM_WEEKLY_ZEMCWK.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WEEKLY_ZEMCWK/Source%20code/ZHR_52TM_WEEKLY_ZEMCWK.abap) L136 |
| [ZHR_OVERTIME_SMS](ZHR_OVERTIME_SMS.md) | 데이터 조회 | [ZHR_OVERTIME_SMS.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_OVERTIME_SMS/source/ZHR_OVERTIME_SMS.abap) L50, 83, 122 |
| [ZHR_OVERTIME_SMS](ZHR_OVERTIME_SMS.md) | 타입 참조 | [ZHR_OVERTIME_SMS.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_OVERTIME_SMS/source/ZHR_OVERTIME_SMS.abap) L29 |
| [ZRPTH410F01](ZRPTH410F01.md) | 데이터 저장 | [ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap) L419 |
| [ZRPTH410F01](ZRPTH410F01.md) | 데이터 조회 | [ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap) L221, 319, 1512, 1652 |
| [ZRPTH410F01](ZRPTH410F01.md) | 타입 참조 | [ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap) L186, 1474, 1609 |
| [ZRPTH410TOP](ZRPTH410TOP.md) | 타입 참조 | [ZRPTH410TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410TOP/source/ZRPTH410TOP.abap) L35, 38, 53, 54 |
| [ZRPTH413F01](ZRPTH413F01.md) | 데이터 조회 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L505, 517 |
| [ZRPTH413F01](ZRPTH413F01.md) | 타입 참조 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L466 |

### 관련 업무와 미확인 범위

- [alerts](../topics/alerts.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [special-extension](../topics/special-extension.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
