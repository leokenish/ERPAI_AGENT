---
title: "ZTHR0120 — [52시간] 탄력근로제 월별정산확정"
as_of: 2026-10-07
review_status: pending_business_review
tags: [근무현황조회, 선택근무, 월정산전표지급, 탄력근무]
---

# ZTHR0120 — [52시간] 탄력근로제 월별정산확정

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **DDIC DBtable**. 설명: [52시간] 탄력근로제 월별정산확정.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) | 2247행; 원본 보존 |

### 데이터 정의

XML TABCLASS: `TRANSP`. GOTSTATE: `A`. 정의는 운영 행 데이터가 아니다. 구조·타입을 DB 저장 테이블로 해석하지 않는다.

| 필드 | 키 표시 | 타입/데이터요소 | 정의 위치 |
|---|---|---|---|
| `MANDT` | X | MANDT | DD03P_TAB, L63 |
| `ZADMIT_YM` | X | [ZEZADMIT_YM](ZEZADMIT_YM.md) | DD03P_TAB, L129 |
| `PERNR` | X | PERSNO | DD03P_TAB, L195 |
| `WPAYBEG` | X | [ZEWPAYBEG](ZEWPAYBEG.md) | DD03P_TAB, L261 |
| `WPAYEND` | X | [ZEWPAYEND](ZEWPAYEND.md) | DD03P_TAB, L327 |
| `Z52WKTP` | — | [ZE52WKTP](ZE52WKTP.md) | DD03P_TAB, L393 |
| `ZDUNG` | — | ZDUNG | DD03P_TAB, L459 |
| `ZCOST` | — | [ZECOST](ZECOST.md) | DD03P_TAB, L525 |
| `Z52BGA` | — | BEGDA | DD03P_TAB, L591 |
| `Z52EDA` | — | ENDDA | DD03P_TAB, L657 |
| `Z52PRSQ` | — | [ZE52PRSQ](ZE52PRSQ.md) | DD03P_TAB, L723 |
| `ZPLOBLH` | — | [ZEPLOBLH](ZEPLOBLH.md) | DD03P_TAB, L789 |
| `ZPUBHHR` | — | [ZEPUBHHR](ZEPUBHHR.md) | DD03P_TAB, L855 |
| `ZPRSDWKHR` | — | [ZEPRSDWKHR](ZEPRSDWKHR.md) | DD03P_TAB, L921 |
| `ZADTWKHR` | — | [ZEADTWKHR](ZEADTWKHR.md) | DD03P_TAB, L987 |
| `ZRLWKHRTOT` | — | [ZERLWKHRTOT](ZERLWKHRTOT.md) | DD03P_TAB, L1053 |
| `ZRLWKHR` | — | [ZERLWKHR](ZERLWKHR.md) | DD03P_TAB, L1119 |
| `ZRLEXWKHR` | — | [ZERLEXWKHR](ZERLEXWKHR.md) | DD03P_TAB, L1185 |
| `ZRLOVRWKHR` | — | [ZERLOVRWKHR](ZERLOVRWKHR.md) | DD03P_TAB, L1251 |
| `ZRLNGTWKHR` | — | [ZERLNGTWKHR](ZERLNGTWKHR.md) | DD03P_TAB, L1317 |
| `ZRLHOLWKHR` | — | [ZERLHOLWKHR](ZERLHOLWKHR.md) | DD03P_TAB, L1383 |
| `ZDAEH_DAY` | — | [ZEDAEH_DAY](ZEDAEH_DAY.md) | DD03P_TAB, L1449 |
| `ZDAEHHR` | — | [ZEDAEHHR](ZEDAEHHR.md) | DD03P_TAB, L1515 |
| `ZRLOVRAMT` | — | [ZERLOVRAMT](ZERLOVRAMT.md) | DD03P_TAB, L1581 |
| `ZRLNGTAMT` | — | [ZERLNGTAMT](ZERLNGTAMT.md) | DD03P_TAB, L1647 |
| `ZRLHOLAMT` | — | [ZERLHOLAMT](ZERLHOLAMT.md) | DD03P_TAB, L1713 |
| `ZDAEHAMT` | — | [ZEDAEHAMT](ZEDAEHAMT.md) | DD03P_TAB, L1779 |
| `ZRLWEEKAMT` | — | [ZERLWEEKAMT](ZERLWEEKAMT.md) | DD03P_TAB, L1845 |
| `ZPRWEEKAMT` | — | [ZEPRWEEKAMT](ZEPRWEEKAMT.md) | DD03P_TAB, L1911 |
| `ZRETROAMT` | — | [ZERETROAMT](ZERETROAMT.md) | DD03P_TAB, L1977 |
| `ZOTPAYAMT` | — | [ZEOTPAYAMT](ZEOTPAYAMT.md) | DD03P_TAB, L2043 |
| `WAERS` | — | WAERS | DD03P_TAB, L2109 |
| `ZADMIT_DT` | — | [ZEADMIT_DT](ZEADMIT_DT.md) | DD03P_TAB, L2175 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZD52WKTP1](ZD52WKTP1.md) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L408 |
| [ZDUNG](EXTERNAL_DEPENDENCIES.md#ZDUNG) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L474 |
| [ZDUNG](EXTERNAL_DEPENDENCIES.md#ZDUNG) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L464 |
| [ZE52PRSQ](ZE52PRSQ.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L728 |
| [ZE52WKTP](ZE52WKTP.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L398 |
| [ZEADMIT_DT](ZEADMIT_DT.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L2180 |
| [ZEADTWKHR](ZEADTWKHR.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L992 |
| [ZECOST](ZECOST.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L530 |
| [ZEDAEHAMT](ZEDAEHAMT.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L1784 |
| [ZEDAEHHR](ZEDAEHHR.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L1520 |
| [ZEDAEH_DAY](ZEDAEH_DAY.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L1454 |
| [ZEOTPAYAMT](ZEOTPAYAMT.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L2048 |
| [ZEPLOBLH](ZEPLOBLH.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L794 |
| [ZEPRSDWKHR](ZEPRSDWKHR.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L926 |
| [ZEPRWEEKAMT](ZEPRWEEKAMT.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L1916 |
| [ZEPUBHHR](ZEPUBHHR.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L860 |
| [ZERETROAMT](ZERETROAMT.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L1982 |
| [ZERLEXWKHR](ZERLEXWKHR.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L1190 |
| [ZERLHOLAMT](ZERLHOLAMT.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L1718 |
| [ZERLHOLWKHR](ZERLHOLWKHR.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L1388 |
| [ZERLNGTAMT](ZERLNGTAMT.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L1652 |
| [ZERLNGTWKHR](ZERLNGTWKHR.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L1322 |
| [ZERLOVRAMT](ZERLOVRAMT.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L1586 |
| [ZERLOVRWKHR](ZERLOVRWKHR.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L1256 |
| [ZERLWEEKAMT](ZERLWEEKAMT.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L1850 |
| [ZERLWKHR](ZERLWKHR.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L1124 |
| [ZERLWKHRTOT](ZERLWKHRTOT.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L1058 |
| [ZEWPAYBEG](ZEWPAYBEG.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L266 |
| [ZEWPAYEND](ZEWPAYEND.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L332 |
| [ZEZADMIT_YM](ZEZADMIT_YM.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L134 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [ZHR_52TM_MONTHLY_PAYMENT](ZHR_52TM_MONTHLY_PAYMENT.md) | 데이터 조회 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L722, 746 |
| [ZHR_52TM_YEARLY_PAYMENT](ZHR_52TM_YEARLY_PAYMENT.md) | 데이터 조회 | [ZHR_52TM_YEARLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_YEARLY_PAYMENT/Source%20code/ZHR_52TM_YEARLY_PAYMENT.abap) L101 |
| [ZHR_52TM_YEARLY_PAYMENT](ZHR_52TM_YEARLY_PAYMENT.md) | 타입 참조 | [ZHR_52TM_YEARLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_YEARLY_PAYMENT/Source%20code/ZHR_52TM_YEARLY_PAYMENT.abap) L22 |
| [ZRPTH402](ZRPTH402.md) | 데이터 조회 | [ZRPTH402.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402/source/ZRPTH402.abap) L93 |
| [ZRPTH402F01](ZRPTH402F01.md) | 데이터 저장 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L615, 892 |
| [ZRPTH402F01](ZRPTH402F01.md) | 타입 참조 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L542, 816 |
| [ZRPTH402TOP](ZRPTH402TOP.md) | 타입 참조 | [ZRPTH402TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402TOP/source/ZRPTH402TOP.abap) L97, 118 |

### 관련 업무와 미확인 범위

- [flexible](../topics/flexible.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
