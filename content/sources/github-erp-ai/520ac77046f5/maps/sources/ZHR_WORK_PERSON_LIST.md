---
title: "ZHR_WORK_PERSON_LIST — [HR]업무별 근무자들 상세 리스트 구조체"
as_of: 2026-10-07
review_status: pending_business_review
tags: [업무리소스인원연계]
---

# ZHR_WORK_PERSON_LIST — [HR]업무별 근무자들 상세 리스트 구조체

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **DDIC Structures**. 설명: [HR]업무별 근무자들 상세 리스트 구조체.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZHR_WORK_PERSON_LIST/definition.xml) | 1323행; 원본 보존 |

### 데이터 정의

XML TABCLASS: `INTTAB`. GOTSTATE: `A`. 정의는 운영 행 데이터가 아니다. 구조·타입을 DB 저장 테이블로 해석하지 않는다.

| 필드 | 키 표시 | 타입/데이터요소 | 정의 위치 |
|---|---|---|---|
| `ZGUBUN` | — | CHAR | DD03P_TAB, L63 |
| `ZCODE` | — | CHAR | DD03P_TAB, L129 |
| `ZCODE_NAME` | — | CHAR | DD03P_TAB, L195 |
| `PERNR` | — | PERSNO | DD03P_TAB, L261 |
| `ENAME` | — | EMNAM | DD03P_TAB, L327 |
| `BEGDA` | — | CHAR | DD03P_TAB, L393 |
| `ENDDA` | — | CHAR | DD03P_TAB, L459 |
| `ROLE` | — | CHAR | DD03P_TAB, L525 |
| `VDSK1` | — | CHAR | DD03P_TAB, L591 |
| `VDSK1X` | — | CHAR | DD03P_TAB, L657 |
| `ZZTRFGR` | — | ZTRFGR | DD03P_TAB, L723 |
| `STELL` | — | STELL | DD03P_TAB, L789 |
| `STELLX` | — | CHAR | DD03P_TAB, L855 |
| `COLOR` | — | CHAR | DD03P_TAB, L921 |
| `JIKGUN_K` | — | ZJIKGUN_K | DD03P_TAB, L987 |
| `JIKJONG_1_K` | — | ZANSVH5_K | DD03P_TAB, L1053 |
| `JIKWIDUNG_1` | — | ZTITEL | DD03P_TAB, L1119 |
| `DURATION` | — | CHAR | DD03P_TAB, L1185 |
| `PERCENT` | — | CHAR | DD03P_TAB, L1251 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZANSVH5_K](EXTERNAL_DEPENDENCIES.md#ZANSVH5_K) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZHR_WORK_PERSON_LIST/definition.xml) L1058 |
| [ZJIKGUN_K](EXTERNAL_DEPENDENCIES.md#ZJIKGUN_K) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZHR_WORK_PERSON_LIST/definition.xml) L992 |
| [ZTITEL](EXTERNAL_DEPENDENCIES.md#ZTITEL) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZHR_WORK_PERSON_LIST/definition.xml) L1124 |
| [ZTRFGR](EXTERNAL_DEPENDENCIES.md#ZTRFGR) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZHR_WORK_PERSON_LIST/definition.xml) L738 |
| [ZTRFGR](EXTERNAL_DEPENDENCIES.md#ZTRFGR) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZHR_WORK_PERSON_LIST/definition.xml) L728 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [ZHR_GET_RES_WORK_INFO](ZHR_GET_RES_WORK_INFO.md) | 타입 참조 | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L12, 13, 22 |
| [ZHR_GET_WORK_INFO](ZHR_GET_WORK_INFO.md) | 타입 참조 | [ZHR_GET_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_WORK_INFO/Source%20code/ZHR_GET_WORK_INFO.abap) L20, 25, 26 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
