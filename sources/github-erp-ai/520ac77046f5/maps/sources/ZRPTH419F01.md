---
title: "ZRPTH419F01 — ABAP 프로그램·독립 Include"
as_of: 2026-10-07
review_status: pending_business_review
tags: [간주근무, 대휴익휴보상휴가]
---

# ZRPTH419F01 — ABAP 프로그램·독립 Include

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 제목 메타데이터 없음; 이름만으로 업무를 확정하지 않음.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZRPTH419F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/attributes/ZRPTH419F01.xml) | 36행; 원본 보존 |
| [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) | 1143행; 원본 보존 |
| [../texts/ZRPTH419F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/texts/ZRPTH419F01.xml) | 16행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — list_positive_inv 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L695, 709 |
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — medium 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L693, 707 |
| [CL_DD_DOCUMENT](EXTERNAL_DEPENDENCIES.md#CL_DD_DOCUMENT) | **클래스 참조** — strong 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L694, 708 |
| [CL_GUI_FRONTEND_SERVICES](EXTERNAL_DEPENDENCIES.md#CL_GUI_FRONTEND_SERVICES) | **클래스 참조** — file_save_dialog 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L763 |
| [CL_GUI_FRONTEND_SERVICES](EXTERNAL_DEPENDENCIES.md#CL_GUI_FRONTEND_SERVICES) | **클래스 참조** — filetype_excel 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L765 |
| [DAY_ATTRIBUTES_GET](EXTERNAL_DEPENDENCIES.md#DAY_ATTRIBUTES_GET) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L279 |
| [DD07T](EXTERNAL_DEPENDENCIES.md#DD07T) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L261 |
| [DYNP_VALUES_READ](EXTERNAL_DEPENDENCIES.md#DYNP_VALUES_READ) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L115 |
| [HR_ECM_GET_ALL_DOMAIN_VALUE](EXTERNAL_DEPENDENCIES.md#HR_ECM_GET_ALL_DOMAIN_VALUE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L292 |
| [HR_IN_LAST_DAY_OF_MONTHS](EXTERNAL_DEPENDENCIES.md#HR_IN_LAST_DAY_OF_MONTHS) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L18, 61, 185 |
| [PA0001](EXTERNAL_DEPENDENCIES.md#PA0001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L202, 517 |
| [POPUP_TO_CONFIRM](EXTERNAL_DEPENDENCIES.md#POPUP_TO_CONFIRM) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L847, 1048 |
| [POPUP_TO_SELECT_MONTH](EXTERNAL_DEPENDENCIES.md#POPUP_TO_SELECT_MONTH) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L141 |
| [RH_DETERMINE_ORG_OBJID](EXTERNAL_DEPENDENCIES.md#RH_DETERMINE_ORG_OBJID) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L80 |
| [SAP_CONVERT_TO_XLS_FORMAT](EXTERNAL_DEPENDENCIES.md#SAP_CONVERT_TO_XLS_FORMAT) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L811 |
| [ZHRT001](EXTERNAL_DEPENDENCIES.md#ZHRT001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L227 |
| [ZHRT002](EXTERNAL_DEPENDENCIES.md#ZHRT002) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L228, 241 |
| [ZHR_GET_DAY_DATA_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_DAY_DATA_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L949 |
| [ZHR_GET_MANAGER_TYPE_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_MANAGER_TYPE_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L524 |
| [ZHR_GET_PERSONNEL_DATA_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_PERSONNEL_DATA_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L905 |
| [ZRPTH419F01](ZRPTH419F01.md) | **FORM 호출** — APPEND_INIT_FIELDCAT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap L609; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L574, 588 |
| [ZRPTH419F01](ZRPTH419F01.md) | **FORM 호출** — GET_ZDBEG_ZDEND: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap L493; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L432 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 저장** — DELETE FROM DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L1090 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 저장** — INSERT DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L955 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L213, 437, 876, 893, 1075 |
| [ZTHRBS13](EXT-ZTHRBS13.md) | **데이터 저장** — UPDATE DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L1008, 1110 |
| [ZTHRBS13](EXT-ZTHRBS13.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L271 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [ZRPTH419](ZRPTH419.md) | FORM 호출 | [ZRPTH419.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419/source/ZRPTH419.abap) L26, 45, 48, 55, 62, 64, 66 |
| [ZRPTH419](ZRPTH419.md) | Include | [ZRPTH419.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419/source/ZRPTH419.abap) L19 |
| [ZRPTH419F01](ZRPTH419F01.md) | FORM 호출 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L432, 574, 588 |
| [ZRPTH419I01](ZRPTH419I01.md) | FORM 호출 | [ZRPTH419I01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419I01/source/ZRPTH419I01.abap) L28, 30 |
| [ZRPTH419O01](ZRPTH419O01.md) | FORM 호출 | [ZRPTH419O01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419O01/source/ZRPTH419O01.abap) L75, 78, 81 |
| [ZRPTH419TOP](ZRPTH419TOP.md) | FORM 호출 | [ZRPTH419TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419TOP/source/ZRPTH419TOP.abap) L151, 156, 160 |

### 관련 업무와 미확인 범위

- [deemed](../topics/deemed.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [rest](../topics/rest.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
