---
title: "ZRPTH414 — 간주 정산관리 후속 후보"
as_of: 2026-10-07
review_status: pending_business_review
tags: [간주근무, 대휴익휴보상휴가, 월정산전표지급]
---

# ZRPTH414 — 간주 정산관리 후속 후보

[소스 설명 목차](INDEX.md) · [원본 파일](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap)

역할은 소스 헤더 Description에 근거한 탐색 후보다. 세부 구현·운영 사용 여부 및 프로그램 간 대체 관계는 미확인.

확인 수준: 헤더 명칭 확인·업무 연결은 후보; 운영 실행 검증 아님. 원본 경로·파일은 그대로 유지한다.

## 근거 위치

| 위치 | 관계의 의미 | 근거 구문 |
|---|---|---|
| 3행 | 소스 헤더의 업무 명칭 | `*&    Description   : 간주근로 정산관리` |

## 관련 업무

<!-- topics -->
- [간주근무](../topics/deemed.md) — 이 소스를 검토하는 업무 지도.

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 간주근로 정산관리.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZRPTH414.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/attributes/ZRPTH414.xml) | 36행; 원본 보존 |
| [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) | 2943행; 원본 보존 |
| [../texts/ZRPTH414.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/texts/ZRPTH414.xml) | 82행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [BAPI_EMPLOYEE_DEQUEUE](EXTERNAL_DEPENDENCIES.md#BAPI_EMPLOYEE_DEQUEUE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L1817, 2218 |
| [BAPI_EMPLOYEE_ENQUEUE](EXTERNAL_DEPENDENCIES.md#BAPI_EMPLOYEE_ENQUEUE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L1688, 2090 |
| [DAY_ATTRIBUTES_GET](EXTERNAL_DEPENDENCIES.md#DAY_ATTRIBUTES_GET) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L2567, 2846 |
| [DOMAIN_VALUE_GET](EXTERNAL_DEPENDENCIES.md#DOMAIN_VALUE_GET) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L601 |
| [DYNP_VALUES_READ](EXTERNAL_DEPENDENCIES.md#DYNP_VALUES_READ) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L2309 |
| [GET_GLOBALS_FROM_SLVC_FULLSCR](EXTERNAL_DEPENDENCIES.md#GET_GLOBALS_FROM_SLVC_FULLSCR) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L1304 |
| [HR_ECM_GET_ALL_DOMAIN_VALUE](EXTERNAL_DEPENDENCIES.md#HR_ECM_GET_ALL_DOMAIN_VALUE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L2579 |
| [HR_INFOTYPE_OPERATION](EXT-HR_INFOTYPE_OPERATION.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L1711, 1733, 2113, 2133, 2165, 2184 |
| [HR_INITIALIZE_BUFFER](EXTERNAL_DEPENDENCIES.md#HR_INITIALIZE_BUFFER) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L1701, 2103 |
| [HR_PSBUFFER_INITIALIZE](EXTERNAL_DEPENDENCIES.md#HR_PSBUFFER_INITIALIZE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L1705, 2107 |
| [HR_READ_INFOTYPE_AUTHC_DISABLE](EXTERNAL_DEPENDENCIES.md#HR_READ_INFOTYPE_AUTHC_DISABLE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L1706, 2108 |
| [OIL_GET_NEXT_MONTH](EXTERNAL_DEPENDENCIES.md#OIL_GET_NEXT_MONTH) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L2768 |
| [P9021](P9021.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L98, 233 |
| [PA0001](EXTERNAL_DEPENDENCIES.md#PA0001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L2778 |
| [POPUP_TO_CONFIRM](EXTERNAL_DEPENDENCIES.md#POPUP_TO_CONFIRM) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L1376, 1425, 1479, 1527 |
| [POPUP_TO_SELECT_MONTH](EXTERNAL_DEPENDENCIES.md#POPUP_TO_SELECT_MONTH) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L2339 |
| [REUSE_ALV_COMMENTARY_WRITE](EXTERNAL_DEPENDENCIES.md#REUSE_ALV_COMMENTARY_WRITE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L1606 |
| [REUSE_ALV_EVENTS_GET](EXTERNAL_DEPENDENCIES.md#REUSE_ALV_EVENTS_GET) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L1221 |
| [REUSE_ALV_GRID_DISPLAY](EXTERNAL_DEPENDENCIES.md#REUSE_ALV_GRID_DISPLAY) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L1572 |
| [RP_LAST_DAY_OF_MONTHS](EXTERNAL_DEPENDENCIES.md#RP_LAST_DAY_OF_MONTHS) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L189, 203, 519, 2453 |
| [T512T](EXTERNAL_DEPENDENCIES.md#T512T) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L629 |
| [ZE52WKTXT](ZE52WKTXT.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L54 |
| [ZHRT001](EXTERNAL_DEPENDENCIES.md#ZHRT001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L423, 2474 |
| [ZHRT002](EXTERNAL_DEPENDENCIES.md#ZHRT002) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L423, 2474 |
| [ZHR_GET_DAY_DATA](EXTERNAL_DEPENDENCIES.md#ZHR_GET_DAY_DATA) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L1943 |
| [ZHR_GET_DAY_DATA_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_DAY_DATA_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L2681 |
| [ZHR_GET_MANAGER_TYPE_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_MANAGER_TYPE_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L352, 2783 |
| [ZHR_GET_PERSON](EXTERNAL_DEPENDENCIES.md#ZHR_GET_PERSON) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L339 |
| [ZHR_GET_PERSONNEL_DATA_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_PERSONNEL_DATA_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L2599 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — ALV_COMMENT_BUILD: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L1167; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L1603 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — ALV_DATA_OUTPUT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L1568; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L652 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — ALV_EVENTTAB_BUILD: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L1219; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L645 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — ALV_EVENTTAB_SETTING: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L1250; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L1227 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — ALV_FIELDCAT_BUILD: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L661; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L644 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — ALV_FIELDCAT_SETTING: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L1004; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L673, 684, 695, 705, 717, 726, 735, 744, 754, 763, 772, 782, 791, 800, 809, 818, 826, 835, 846, 855, 865, 877, 887, 898, 908, 918, 928, 938, 948, 958, 968, 980 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — ALV_LAYOUT_BUILD: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L1032; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L647 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — ALV_SORT_BUILD: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L1049; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L646 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — CANCEL_DATA: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L2013; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L1449 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — CONFIRM_DATA: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L1619; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L1400 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — CREATE_DAEH: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L2531; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L1503 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — DISPLAY_ALV: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L643; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L560 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — F4_RETMO: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L2300; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L224 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — GET_52WKTY_TEXT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L592; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L254 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — GET_BASIS_DATA: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L2435; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L248 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — GET_CLOSED_DATA: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L2503; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L269 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — GET_COST: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L2415; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L1989 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — GET_COST_MASTER: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L2397; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L250 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — GET_DEPT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L2378; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L326, 1986 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — GET_DEPT_MASTER: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L2362; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L249 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — GET_LGART_TEXT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L624; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L258, 261 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — GET_ZDBEG_ZDEND: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L2744; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L2614, 2870 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — LIGHT_SETTING: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L2259; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L534, 1844, 2002, 2243, 2727, 2936 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — MAKE_ADD_INFO: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L1860; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L536 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — MODIFY_SELECTION_SCREEN: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L2275; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L217 |
| [ZRPTH414](ZRPTH414.md) | **FORM 호출** — REMOVE_DAEH: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap L2817; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L1551 |
| [ZRPTH700](EXTERNAL_DEPENDENCIES.md#ZRPTH700) | **프로그램 호출** — SUBMIT 정적 대상 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L1324, 1335 |
| [ZTH0500](EXTERNAL_DEPENDENCIES.md#ZTH0500) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L2366 |
| [ZTHR0114](ZTHR0114.md) | **데이터 저장** — DELETE DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L2225 |
| [ZTHR0114](ZTHR0114.md) | **데이터 저장** — INSERT DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L1827 |
| [ZTHR0114](ZTHR0114.md) | **데이터 저장** — UPDATE DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L2699, 2908 |
| [ZTHR0114](ZTHR0114.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L441, 481, 1650, 1664, 2042, 2061, 2517 |
| [ZTHR0114](ZTHR0114.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L23, 41, 42, 46, 47, 48, 49, 50, 51, 52, 55, 56, 57, 58, 59, 60, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 95, 236, 295, 296, 299, 1621, 1627, 1628, 1631, 1632, 2015, 2021, 2022, 2025, 2026, 2505 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 저장** — DELETE FROM DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L2892 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 저장** — INSERT DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L2687 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L2620, 2636, 2877 |
| [ZTHRCOST](EXT-ZTHRCOST.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L2403 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [ZRPTH414](ZRPTH414.md) | FORM 호출 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L217, 224, 248, 249, 250, 254, 258, 261, 269, 326, 534, 536, 560, 644, 645, 646, 647, 652, 673, 684, 695, 705, 717, 726, 735, 744, 754, 763, 772, 782, 791, 800, 809, 818, 826, 835, 846, 855, 865, 877, 887, 898, 908, 918, 928, 938, 948, 958, 968, 980, 1227, 1400, 1449, 1503, 1551, 1603, 1844, 1986, 1989, 2002, 2243, 2614, 2727, 2870, 2936 |

### 관련 업무와 미확인 범위

- [deemed](../topics/deemed.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [rest](../topics/rest.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
