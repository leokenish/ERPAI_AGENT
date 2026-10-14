---
title: "ZRPTH407F01 — ABAP 프로그램·독립 Include"
as_of: 2026-10-07
review_status: pending_business_review
tags: [재량근무]
---

# ZRPTH407F01 — ABAP 프로그램·독립 Include

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 제목 메타데이터 없음; 이름만으로 업무를 확정하지 않음.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZRPTH407F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/attributes/ZRPTH407F01.xml) | 36행; 원본 보존 |
| [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) | 1143행; 원본 보존 |
| [../texts/ZRPTH407F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/texts/ZRPTH407F01.xml) | 16행; 원본 보존 |

### 이번 업무 구간 검토

파일 판정: **후보**. 검토 범위: 대상 삭제 및 중복 검사·정보형 INS; L751–805, L1080–1170. 남은 범위: 이외 본문/모든 예외 분기 미검토; 운영 실행 미확인. 이는 이 파일/명시한 구간의 정적 분석이며 외부 함수·업무 전체·운영 검증 완료는 아니다.

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ALSM_EXCEL_TO_INTERNAL_TABLE](EXTERNAL_DEPENDENCIES.md#ALSM_EXCEL_TO_INTERNAL_TABLE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L911 |
| [BAPI_EMPLOYEE_DEQUEUE](EXTERNAL_DEPENDENCIES.md#BAPI_EMPLOYEE_DEQUEUE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L846 |
| [BAPI_EMPLOYEE_ENQUEUE](EXTERNAL_DEPENDENCIES.md#BAPI_EMPLOYEE_ENQUEUE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L826 |
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — list_positive_inv 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L449, 463 |
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — medium 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L447, 461 |
| [CL_DD_DOCUMENT](EXTERNAL_DEPENDENCIES.md#CL_DD_DOCUMENT) | **클래스 참조** — strong 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L448, 462 |
| [CL_GUI_FRONTEND_SERVICES](EXTERNAL_DEPENDENCIES.md#CL_GUI_FRONTEND_SERVICES) | **클래스 참조** — file_open_dialog 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L888 |
| [CL_GUI_FRONTEND_SERVICES](EXTERNAL_DEPENDENCIES.md#CL_GUI_FRONTEND_SERVICES) | **클래스 참조** — file_save_dialog 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L501, 585 |
| [CL_GUI_FRONTEND_SERVICES](EXTERNAL_DEPENDENCIES.md#CL_GUI_FRONTEND_SERVICES) | **클래스 참조** — filetype_excel 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L503, 587 |
| [CL_GUI_FRONTEND_SERVICES](EXTERNAL_DEPENDENCIES.md#CL_GUI_FRONTEND_SERVICES) | **클래스 참조** — gui_download 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L527 |
| [CSKT](EXTERNAL_DEPENDENCIES.md#CSKT) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L301, 302 |
| [DYNP_VALUES_READ](EXTERNAL_DEPENDENCIES.md#DYNP_VALUES_READ) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L107 |
| [HR_INFOTYPE_OPERATION](EXT-HR_INFOTYPE_OPERATION.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L1135 |
| [HR_IN_LAST_DAY_OF_MONTHS](EXTERNAL_DEPENDENCIES.md#HR_IN_LAST_DAY_OF_MONTHS) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L61, 177 |
| [P9021](P9021.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L870, 1111 |
| [PA0001](EXTERNAL_DEPENDENCIES.md#PA0001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L190, 298 |
| [PA9021](PA9021.md) | **데이터 저장** — DELETE FROM DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L789 |
| [PA9021](PA9021.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L190, 1118 |
| [PA9021](PA9021.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L1114 |
| [POPUP_TO_CONFIRM](EXTERNAL_DEPENDENCIES.md#POPUP_TO_CONFIRM) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L759, 944 |
| [POPUP_TO_SELECT_MONTH](EXTERNAL_DEPENDENCIES.md#POPUP_TO_SELECT_MONTH) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L133 |
| [RH_DETERMINE_ORG_OBJID](EXTERNAL_DEPENDENCIES.md#RH_DETERMINE_ORG_OBJID) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L72 |
| [SAP_CONVERT_TO_XLS_FORMAT](EXTERNAL_DEPENDENCIES.md#SAP_CONVERT_TO_XLS_FORMAT) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L1088 |
| [ZHR_52TM_MEMBER_CHECK](ZHR_52TM_MEMBER_CHECK.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L990 |
| [ZHR_52TM_WKTYPE](ZHR_52TM_WKTYPE.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L230 |
| [ZRPTH407F01](ZRPTH407F01.md) | **FORM 호출** — APPEND_INIT_FIELDCAT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap L375; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L339 |
| [ZRPTH407F01](ZRPTH407F01.md) | **FORM 호출** — EMPLOYEE_DEQUEUE: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap L841; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L785, 799, 1010, 1028 |
| [ZRPTH407F01](ZRPTH407F01.md) | **FORM 호출** — EMPLOYEE_ENQUEUE: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap L821; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L782, 1007 |
| [ZRPTH407F01](ZRPTH407F01.md) | **FORM 호출** — HR_INFOTYPE_OPERATION: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap L1111; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L1014 |
| [ZRPTH407F01](ZRPTH407F01.md) | **FORM 호출** — SELECT_DATA: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap L156; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L811, 1101 |
| [ZTH0500](EXTERNAL_DEPENDENCIES.md#ZTH0500) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L225 |
| [ZTHR0125](ZTHR0125.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L204 |
| [ZTHR0125](ZTHR0125.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L160 |
| [ZTHR0126](ZTHR0126.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L211 |
| [ZTHR0126](ZTHR0126.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L161 |
| [ZTHR0127](ZTHR0127.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L218 |
| [ZTHR0127](ZTHR0127.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L162 |
| [ZTHR_KOBIS_DATA](EXTERNAL_DEPENDENCIES.md#ZTHR_KOBIS_DATA) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L274 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [ZRPTH407](ZRPTH407.md) | FORM 호출 | [ZRPTH407.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407/source/ZRPTH407.abap) L26, 45, 48, 55, 62 |
| [ZRPTH407](ZRPTH407.md) | Include | [ZRPTH407.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407/source/ZRPTH407.abap) L19 |
| [ZRPTH407F01](ZRPTH407F01.md) | FORM 호출 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L339, 782, 785, 799, 811, 1007, 1010, 1014, 1028, 1101 |
| [ZRPTH407I01](ZRPTH407I01.md) | FORM 호출 | [ZRPTH407I01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407I01/source/ZRPTH407I01.abap) L28, 32, 34, 36 |
| [ZRPTH407O01](ZRPTH407O01.md) | FORM 호출 | [ZRPTH407O01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407O01/source/ZRPTH407O01.abap) L63, 66, 69 |
| [ZRPTH407TOP](ZRPTH407TOP.md) | FORM 호출 | [ZRPTH407TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407TOP/source/ZRPTH407TOP.abap) L100 |

### 관련 업무와 미확인 범위

- [discretionary](../topics/discretionary.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
