---
title: "ZRPTH408F01 — ABAP 프로그램·독립 Include"
as_of: 2026-10-07
review_status: pending_business_review
tags: [재량근무]
---

# ZRPTH408F01 — ABAP 프로그램·독립 Include

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 제목 메타데이터 없음; 이름만으로 업무를 확정하지 않음.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZRPTH408F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/attributes/ZRPTH408F01.xml) | 36행; 원본 보존 |
| [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) | 1830행; 원본 보존 |
| [../texts/ZRPTH408F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/texts/ZRPTH408F01.xml) | 16행; 원본 보존 |

### 이번 업무 구간 검토

파일 판정: **후보**. 검토 범위: 정보형 호출 공통 FORM; L1760–1830. 남은 범위: 이외 본문/모든 예외 분기 미검토; 운영 실행 미확인. 이는 이 파일/명시한 구간의 정적 분석이며 외부 함수·업무 전체·운영 검증 완료는 아니다.

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ALSM_EXCEL_TO_INTERNAL_TABLE](EXTERNAL_DEPENDENCIES.md#ALSM_EXCEL_TO_INTERNAL_TABLE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L1559 |
| [BAPI_EMPLOYEE_DEQUEUE](EXTERNAL_DEPENDENCIES.md#BAPI_EMPLOYEE_DEQUEUE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L1799 |
| [BAPI_EMPLOYEE_ENQUEUE](EXTERNAL_DEPENDENCIES.md#BAPI_EMPLOYEE_ENQUEUE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L1779 |
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — list_positive_inv 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L958, 970, 985 |
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — medium 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L956, 968, 983 |
| [CL_DD_DOCUMENT](EXTERNAL_DEPENDENCIES.md#CL_DD_DOCUMENT) | **클래스 참조** — strong 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L957, 969, 984 |
| [CL_GUI_FRONTEND_SERVICES](EXTERNAL_DEPENDENCIES.md#CL_GUI_FRONTEND_SERVICES) | **클래스 참조** — file_open_dialog 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L1536 |
| [CL_GUI_FRONTEND_SERVICES](EXTERNAL_DEPENDENCIES.md#CL_GUI_FRONTEND_SERVICES) | **클래스 참조** — file_save_dialog 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L1039, 1706 |
| [CL_GUI_FRONTEND_SERVICES](EXTERNAL_DEPENDENCIES.md#CL_GUI_FRONTEND_SERVICES) | **클래스 참조** — filetype_excel 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L1041, 1708 |
| [DYNP_VALUES_READ](EXTERNAL_DEPENDENCIES.md#DYNP_VALUES_READ) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L118 |
| [HR_INFOTYPE_OPERATION](EXT-HR_INFOTYPE_OPERATION.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L1818 |
| [HR_IN_LAST_DAY_OF_MONTHS](EXTERNAL_DEPENDENCIES.md#HR_IN_LAST_DAY_OF_MONTHS) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L203, 225 |
| [PA0001](EXTERNAL_DEPENDENCIES.md#PA0001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L243 |
| [PA2010](EXT-PA2010.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L278, 409, 1175, 1363, 1625 |
| [PA9021](PA9021.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L243 |
| [POPUP_TO_CONFIRM](EXTERNAL_DEPENDENCIES.md#POPUP_TO_CONFIRM) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L1121, 1331, 1592 |
| [POPUP_TO_SELECT_MONTH](EXTERNAL_DEPENDENCIES.md#POPUP_TO_SELECT_MONTH) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L144 |
| [RH_DETERMINE_ORG_OBJID](EXTERNAL_DEPENDENCIES.md#RH_DETERMINE_ORG_OBJID) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L83 |
| [SAP_CONVERT_TO_XLS_FORMAT](EXTERNAL_DEPENDENCIES.md#SAP_CONVERT_TO_XLS_FORMAT) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L1087, 1679, 1751 |
| [ZHR_52TM_WKTYPE](ZHR_52TM_WKTYPE.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L320 |
| [ZRPTH408F01](ZRPTH408F01.md) | **FORM 호출** — APPEND_INIT_FIELDCAT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap L866; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L820, 845 |
| [ZRPTH408F01](ZRPTH408F01.md) | **FORM 호출** — EMPLOYEE_DEQUEUE: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap L1794; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L1189, 1203, 1380, 1394, 1640, 1659 |
| [ZRPTH408F01](ZRPTH408F01.md) | **FORM 호출** — EMPLOYEE_ENQUEUE: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap L1774; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L1186, 1377, 1637 |
| [ZRPTH408F01](ZRPTH408F01.md) | **FORM 호출** — HR_INFOTYPE_OPERATION: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap L1814; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L1193, 1384, 1644 |
| [ZTHR0125](ZTHR0125.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L301 |
| [ZTHR0125](ZTHR0125.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L178 |
| [ZTHR0126](ZTHR0126.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L308 |
| [ZTHR0126](ZTHR0126.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L179 |
| [ZTHR0127](ZTHR0127.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L315 |
| [ZTHR0127](ZTHR0127.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L180 |
| [ZTHR0128](ZTHR0128.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L290 |
| [ZTHR0128](ZTHR0128.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L183 |
| [ZTHR_KOBIS_DATA](EXTERNAL_DEPENDENCIES.md#ZTHR_KOBIS_DATA) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L390 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [ZRPTH408](ZRPTH408.md) | FORM 호출 | [ZRPTH408.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408/source/ZRPTH408.abap) L26, 45, 48, 55, 62 |
| [ZRPTH408](ZRPTH408.md) | Include | [ZRPTH408.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408/source/ZRPTH408.abap) L19 |
| [ZRPTH408F01](ZRPTH408F01.md) | FORM 호출 | [ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L820, 845, 1186, 1189, 1193, 1203, 1377, 1380, 1384, 1394, 1637, 1640, 1644, 1659 |
| [ZRPTH408I01](ZRPTH408I01.md) | FORM 호출 | [ZRPTH408I01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408I01/source/ZRPTH408I01.abap) L28, 30, 32, 34 |
| [ZRPTH408O01](ZRPTH408O01.md) | FORM 호출 | [ZRPTH408O01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408O01/source/ZRPTH408O01.abap) L76, 79, 82 |
| [ZRPTH408TOP](ZRPTH408TOP.md) | FORM 호출 | [ZRPTH408TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408TOP/source/ZRPTH408TOP.abap) L164, 169, 173 |

### 관련 업무와 미확인 범위

- [discretionary](../topics/discretionary.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
