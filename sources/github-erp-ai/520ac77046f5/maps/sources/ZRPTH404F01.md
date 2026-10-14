---
title: "ZRPTH404F01 — ABAP 프로그램·독립 Include"
as_of: 2026-10-07
review_status: pending_business_review
tags: [간주근무, 월정산전표지급]
---

# ZRPTH404F01 — ABAP 프로그램·독립 Include

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 제목 메타데이터 없음; 이름만으로 업무를 확정하지 않음.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZRPTH404F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/attributes/ZRPTH404F01.xml) | 36행; 원본 보존 |
| [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) | 936행; 원본 보존 |
| [../texts/ZRPTH404F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/texts/ZRPTH404F01.xml) | 16행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [BAPI_EMPLOYEE_DEQUEUE](EXTERNAL_DEPENDENCIES.md#BAPI_EMPLOYEE_DEQUEUE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L929 |
| [BAPI_EMPLOYEE_ENQUEUE](EXTERNAL_DEPENDENCIES.md#BAPI_EMPLOYEE_ENQUEUE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L776 |
| [DOMAIN_VALUE_GET](EXTERNAL_DEPENDENCIES.md#DOMAIN_VALUE_GET) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L94 |
| [GET_GLOBALS_FROM_SLVC_FULLSCR](EXTERNAL_DEPENDENCIES.md#GET_GLOBALS_FROM_SLVC_FULLSCR) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L634 |
| [HR_INFOTYPE_OPERATION](EXT-HR_INFOTYPE_OPERATION.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L814, 833 |
| [HR_INITIALIZE_BUFFER](EXTERNAL_DEPENDENCIES.md#HR_INITIALIZE_BUFFER) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L805 |
| [HR_PSBUFFER_INITIALIZE](EXTERNAL_DEPENDENCIES.md#HR_PSBUFFER_INITIALIZE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L809 |
| [HR_READ_INFOTYPE_AUTHC_DISABLE](EXTERNAL_DEPENDENCIES.md#HR_READ_INFOTYPE_AUTHC_DISABLE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L810 |
| [PA2010](EXT-PA2010.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L36 |
| [POPUP_TO_CONFIRM](EXTERNAL_DEPENDENCIES.md#POPUP_TO_CONFIRM) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L664 |
| [REUSE_ALV_COMMENTARY_WRITE](EXTERNAL_DEPENDENCIES.md#REUSE_ALV_COMMENTARY_WRITE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L744 |
| [REUSE_ALV_EVENTS_GET](EXTERNAL_DEPENDENCIES.md#REUSE_ALV_EVENTS_GET) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L552 |
| [REUSE_ALV_GRID_DISPLAY](EXTERNAL_DEPENDENCIES.md#REUSE_ALV_GRID_DISPLAY) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L710 |
| [T512T](EXTERNAL_DEPENDENCIES.md#T512T) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L122 |
| [ZRPTH404F01](ZRPTH404F01.md) | **FORM 호출** — ALV_COMMENT_BUILD: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap L498; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L741 |
| [ZRPTH404F01](ZRPTH404F01.md) | **FORM 호출** — ALV_DATA_OUTPUT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap L706; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L145 |
| [ZRPTH404F01](ZRPTH404F01.md) | **FORM 호출** — ALV_EVENTTAB_BUILD: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap L550; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L138 |
| [ZRPTH404F01](ZRPTH404F01.md) | **FORM 호출** — ALV_EVENTTAB_SETTING: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap L581; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L558 |
| [ZRPTH404F01](ZRPTH404F01.md) | **FORM 호출** — ALV_FIELDCAT_BUILD: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap L154; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L137 |
| [ZRPTH404F01](ZRPTH404F01.md) | **FORM 호출** — ALV_FIELDCAT_SETTING: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap L341; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L167, 180, 192, 202, 214, 223, 234, 243, 254, 262, 274, 286, 294, 310, 319 |
| [ZRPTH404F01](ZRPTH404F01.md) | **FORM 호출** — ALV_LAYOUT_BUILD: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap L369; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L140 |
| [ZRPTH404F01](ZRPTH404F01.md) | **FORM 호출** — ALV_SORT_BUILD: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap L386; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L139 |
| [ZRPTH404F01](ZRPTH404F01.md) | **FORM 호출** — ALV_SORT_SETTING: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap L417; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L394, 400 |
| [ZRPTH404F01](ZRPTH404F01.md) | **FORM 호출** — CONFIRM_DATA: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap L757; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L689 |
| [ZRPTH404F01](ZRPTH404F01.md) | **FORM 호출** — MARK_CHANGED: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap L463; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L449 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [ZRPTH404](ZRPTH404.md) | FORM 호출 | [ZRPTH404.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404/source/ZRPTH404.abap) L108, 116, 120, 144, 234, 244 |
| [ZRPTH404](ZRPTH404.md) | Include | [ZRPTH404.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404/source/ZRPTH404.abap) L15 |
| [ZRPTH404F01](ZRPTH404F01.md) | FORM 호출 | [ZRPTH404F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404F01/source/ZRPTH404F01.abap) L137, 138, 139, 140, 145, 167, 180, 192, 202, 214, 223, 234, 243, 254, 262, 274, 286, 294, 310, 319, 394, 400, 449, 558, 689, 741 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
