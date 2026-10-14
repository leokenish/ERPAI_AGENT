---
title: "ZWF0022_BAK — [HR] 유연근무제/시간외/근태 결재이력 테이블 (E/F/G) (~2018.12.31 까지 상신 분)"
as_of: 2026-10-07
review_status: pending_business_review
tags: [통합결재]
---

# ZWF0022_BAK — [HR] 유연근무제/시간외/근태 결재이력 테이블 (E/F/G) (~2018.12.31 까지 상신 분)

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **DDIC DBtable**. 설명: [HR] 유연근무제/시간외/근태 결재이력 테이블 (E/F/G) (~2018.12.31 까지 상신 분).

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZWF0022_BAK/definition.xml) | 1289행; 원본 보존 |

### 데이터 정의

XML TABCLASS: `TRANSP`. GOTSTATE: `A`. 정의는 운영 행 데이터가 아니다. 구조·타입을 DB 저장 테이블로 해석하지 않는다.

| 필드 | 키 표시 | 타입/데이터요소 | 정의 위치 |
|---|---|---|---|
| `MANDT` | X | MANDT | DD03P_TAB, L63 |
| `KEY12` | X | SWW_WIID | DD03P_TAB, L129 |
| `ZWFTYPE` | X | ZWFTYPE | DD03P_TAB, L195 |
| `ZORDR` | X | ZORDR | DD03P_TAB, L261 |
| `.INCLUDE` | — |  | DD03P_TAB, L327 |
| `WI_ID` | — | SWW_WIID | DD03P_TAB, L393 |
| `CODE` | — | Z_CODE | DD03P_TAB, L459 |
| `BNAME` | — | XUBNAME | DD03P_TAB, L525 |
| `NAME1` | — | ZNAME | DD03P_TAB, L591 |
| `PERNR` | — | PERSNO | DD03P_TAB, L657 |
| `ZAPDT` | — | DATUM | DD03P_TAB, L723 |
| `ZAPHR` | — | ZHOUR | DD03P_TAB, L789 |
| `ZSTTS` | — | ZATTS | DD03P_TAB, L855 |
| `ZSTTS1` | — | ZATTS | DD03P_TAB, L921 |
| `NAME` | — | ZTDOBNAME | DD03P_TAB, L987 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZATTS](EXTERNAL_DEPENDENCIES.md#ZATTS) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZWF0022_BAK/definition.xml) L870, 936 |
| [ZATTS](EXTERNAL_DEPENDENCIES.md#ZATTS) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZWF0022_BAK/definition.xml) L860, 926 |
| [ZHOUR](EXTERNAL_DEPENDENCIES.md#ZHOUR) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZWF0022_BAK/definition.xml) L794 |
| [ZNAME](EXTERNAL_DEPENDENCIES.md#ZNAME) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZWF0022_BAK/definition.xml) L606 |
| [ZNAME](EXTERNAL_DEPENDENCIES.md#ZNAME) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZWF0022_BAK/definition.xml) L596 |
| [ZORDR](EXTERNAL_DEPENDENCIES.md#ZORDR) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZWF0022_BAK/definition.xml) L266 |
| [ZTDOBNAME](EXTERNAL_DEPENDENCIES.md#ZTDOBNAME) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZWF0022_BAK/definition.xml) L992 |
| [ZWFI012](EXTERNAL_DEPENDENCIES.md#ZWFI012) | **타입 참조** — PRECFIELD XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZWF0022_BAK/definition.xml) L338 |
| [ZWFTYPE](EXTERNAL_DEPENDENCIES.md#ZWFTYPE) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZWF0022_BAK/definition.xml) L210 |
| [ZWFTYPE](EXTERNAL_DEPENDENCIES.md#ZWFTYPE) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZWF0022_BAK/definition.xml) L200 |
| [Z_CODE](EXTERNAL_DEPENDENCIES.md#Z_CODE) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZWF0022_BAK/definition.xml) L474 |
| [Z_CODE](EXTERNAL_DEPENDENCIES.md#Z_CODE) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZWF0022_BAK/definition.xml) L464 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| — | 색인 내 정적 참조 없음; 미사용 근거 아님 | 동적 호출·외부 시스템은 미확인 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
