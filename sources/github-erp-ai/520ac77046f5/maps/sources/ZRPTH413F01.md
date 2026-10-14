---
title: "ZRPTH413F01 — ABAP 프로그램·독립 Include"
as_of: 2026-10-07
review_status: pending_business_review
tags: [근무현황조회, 선택근무]
---

# ZRPTH413F01 — ABAP 프로그램·독립 Include

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 제목 메타데이터 없음; 이름만으로 업무를 확정하지 않음.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZRPTH413F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/attributes/ZRPTH413F01.xml) | 36행; 원본 보존 |
| [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) | 660행; 원본 보존 |
| [../texts/ZRPTH413F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/texts/ZRPTH413F01.xml) | 16행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — list_positive_inv 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L424, 438 |
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — medium 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L422, 436 |
| [CL_DD_DOCUMENT](EXTERNAL_DEPENDENCIES.md#CL_DD_DOCUMENT) | **클래스 참조** — strong 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L423, 437 |
| [DD07T](EXTERNAL_DEPENDENCIES.md#DD07T) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L178 |
| [DYNP_VALUES_READ](EXTERNAL_DEPENDENCIES.md#DYNP_VALUES_READ) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L119 |
| [F4IF_INT_TABLE_VALUE_REQUEST](EXTERNAL_DEPENDENCIES.md#F4IF_INT_TABLE_VALUE_REQUEST) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L192 |
| [HR_READ_FOREIGN_OBJECT_TEXT](EXTERNAL_DEPENDENCIES.md#HR_READ_FOREIGN_OBJECT_TEXT) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L607 |
| [PA0001](EXTERNAL_DEPENDENCIES.md#PA0001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L505, 517, 542 |
| [PA0008](EXTERNAL_DEPENDENCIES.md#PA0008) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L581 |
| [POPUP_TO_SELECT_MONTH](EXTERNAL_DEPENDENCIES.md#POPUP_TO_SELECT_MONTH) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L145 |
| [RH_DETERMINE_ORG_OBJID](EXTERNAL_DEPENDENCIES.md#RH_DETERMINE_ORG_OBJID) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L84 |
| [RH_GET_DATE_DAYNAME](EXTERNAL_DEPENDENCIES.md#RH_GET_DATE_DAYNAME) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L642 |
| [RH_READ_OBJECT](EXTERNAL_DEPENDENCIES.md#RH_READ_OBJECT) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L591 |
| [T503T](EXTERNAL_DEPENDENCIES.md#T503T) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L574 |
| [T527X](EXTERNAL_DEPENDENCIES.md#T527X) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L557 |
| [ZHR_52TM_CW_CAL_AND_DAEH](ZHR_52TM_CW_CAL_AND_DAEH.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L526 |
| [ZRPTH413F01](ZRPTH413F01.md) | **FORM 호출** — APPEND_INIT_FIELDCAT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap L344; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L241 |
| [ZSHR0111](ZSHR0111.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L468 |
| [ZSHR0145](ZSHR0145.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L467 |
| [ZTH0500](EXTERNAL_DEPENDENCIES.md#ZTH0500) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L566 |
| [ZTHR0112](ZTHR0112.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L170, 473 |
| [ZTHR0132](ZTHR0132.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L505, 517 |
| [ZTHR0132](ZTHR0132.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L466 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [ZRPTH413](ZRPTH413.md) | FORM 호출 | [ZRPTH413.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413/source/ZRPTH413.abap) L26, 45, 48, 55, 76 |
| [ZRPTH413](ZRPTH413.md) | Include | [ZRPTH413.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413/source/ZRPTH413.abap) L18 |
| [ZRPTH413F01](ZRPTH413F01.md) | FORM 호출 | [ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap) L241 |
| [ZRPTH413F02](ZRPTH413F02.md) | FORM 호출 | [ZRPTH413F02.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F02/source/ZRPTH413F02.abap) L49 |
| [ZRPTH413O01](ZRPTH413O01.md) | FORM 호출 | [ZRPTH413O01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413O01/source/ZRPTH413O01.abap) L67, 70, 73 |
| [ZRPTH413TOP](ZRPTH413TOP.md) | FORM 호출 | [ZRPTH413TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413TOP/source/ZRPTH413TOP.abap) L143 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
