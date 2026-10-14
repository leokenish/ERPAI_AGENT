---
title: "ZRPTH415F01 — ABAP 프로그램·독립 Include"
as_of: 2026-10-07
review_status: pending_business_review
tags: [교대근무, 대휴익휴보상휴가, 월정산전표지급]
---

# ZRPTH415F01 — ABAP 프로그램·독립 Include

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 제목 메타데이터 없음; 이름만으로 업무를 확정하지 않음.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZRPTH415F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/attributes/ZRPTH415F01.xml) | 36행; 원본 보존 |
| [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) | 1751행; 원본 보존 |
| [../texts/ZRPTH415F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/texts/ZRPTH415F01.xml) | 16행; 원본 보존 |

### 이번 업무 구간 검토

파일 판정: **후보**. 검토 범위: 대휴 정산 표시·정보형 2010 기록 요청; L1420–1538. 남은 범위: 이외 본문/모든 예외 분기 미검토; 운영 실행 미확인. 이는 이 파일/명시한 구간의 정적 분석이며 외부 함수·업무 전체·운영 검증 완료는 아니다.

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [BAPI_EMPLOYEE_DEQUEUE](EXTERNAL_DEPENDENCIES.md#BAPI_EMPLOYEE_DEQUEUE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L1543, 1738 |
| [BAPI_EMPLOYEE_ENQUEUE](EXTERNAL_DEPENDENCIES.md#BAPI_EMPLOYEE_ENQUEUE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L1483, 1681 |
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — list_positive_inv 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L1215, 1226, 1240 |
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — medium 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L1213, 1224, 1238 |
| [CL_DD_DOCUMENT](EXTERNAL_DEPENDENCIES.md#CL_DD_DOCUMENT) | **클래스 참조** — strong 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L1214, 1225, 1239 |
| [CL_GUI_FRONTEND_SERVICES](EXTERNAL_DEPENDENCIES.md#CL_GUI_FRONTEND_SERVICES) | **클래스 참조** — file_save_dialog 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L1293 |
| [CL_GUI_FRONTEND_SERVICES](EXTERNAL_DEPENDENCIES.md#CL_GUI_FRONTEND_SERVICES) | **클래스 참조** — filetype_excel 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L1295 |
| [CONVERSION_EXIT_ALPHA_INPUT](EXTERNAL_DEPENDENCIES.md#CONVERSION_EXIT_ALPHA_INPUT) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L250, 615, 855 |
| [DD07T](EXTERNAL_DEPENDENCIES.md#DD07T) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L273, 281, 637, 645 |
| [HR_INFOTYPE_OPERATION](EXT-HR_INFOTYPE_OPERATION.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L1515, 1710 |
| [HR_INITIALIZE_BUFFER](EXTERNAL_DEPENDENCIES.md#HR_INITIALIZE_BUFFER) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L1506, 1701 |
| [HR_PSBUFFER_INITIALIZE](EXTERNAL_DEPENDENCIES.md#HR_PSBUFFER_INITIALIZE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L1510, 1705 |
| [HR_READ_INFOTYPE_AUTHC_DISABLE](EXTERNAL_DEPENDENCIES.md#HR_READ_INFOTYPE_AUTHC_DISABLE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L1511, 1706 |
| [PA0001](EXTERNAL_DEPENDENCIES.md#PA0001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L108, 162, 329, 345, 582, 736, 768, 982, 998 |
| [PA0008](EXTERNAL_DEPENDENCIES.md#PA0008) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L337, 990 |
| [PA2010](EXT-PA2010.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L145, 311, 750, 1430, 1636 |
| [POPUP_TO_CONFIRM](EXTERNAL_DEPENDENCIES.md#POPUP_TO_CONFIRM) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L1388, 1608 |
| [RH_DETERMINE_ORG_OBJID](EXTERNAL_DEPENDENCIES.md#RH_DETERMINE_ORG_OBJID) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L63 |
| [SAP_CONVERT_TO_XLS_FORMAT](EXTERNAL_DEPENDENCIES.md#SAP_CONVERT_TO_XLS_FORMAT) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L1341 |
| [ZHR_GET_MANAGER_TYPE_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_MANAGER_TYPE_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L350, 1003 |
| [ZRPTH415F01](ZRPTH415F01.md) | **FORM 호출** — APPEND_INIT_FIELDCAT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap L1137; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L1091, 1116 |
| [ZTH0500](EXTERNAL_DEPENDENCIES.md#ZTH0500) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L167, 170, 264, 628, 773, 776 |
| [ZTHR2006_DATE](EXT-ZTHR2006_DATE.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L139, 744 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 저장** — UPDATE DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L1460, 1658 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L121, 594 |
| [ZTHRBS05](EXT-ZTHRBS05.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L192, 798 |
| [ZTHRBS16](ZTHRBS16.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L289 |
| [ZTHRCOST](EXT-ZTHRCOST.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L200, 207, 806, 813 |
| [ZTHR_KOBIS_DATA](EXTERNAL_DEPENDENCIES.md#ZTHR_KOBIS_DATA) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L153, 759 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [ZRPTH415](ZRPTH415.md) | FORM 호출 | [ZRPTH415.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415/source/ZRPTH415.abap) L29, 42, 48, 51, 59, 60, 61, 63 |
| [ZRPTH415](ZRPTH415.md) | Include | [ZRPTH415.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415/source/ZRPTH415.abap) L21 |
| [ZRPTH415F01](ZRPTH415F01.md) | FORM 호출 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L1091, 1116 |
| [ZRPTH415I01](ZRPTH415I01.md) | FORM 호출 | [ZRPTH415I01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415I01/source/ZRPTH415I01.abap) L28, 30 |
| [ZRPTH415O01](ZRPTH415O01.md) | FORM 호출 | [ZRPTH415O01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415O01/source/ZRPTH415O01.abap) L74, 77, 80 |
| [ZRPTH415TOP](ZRPTH415TOP.md) | FORM 호출 | [ZRPTH415TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415TOP/source/ZRPTH415TOP.abap) L189, 194, 198 |

### 관련 업무와 미확인 범위

- [rest](../topics/rest.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [shift](../topics/shift.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
