---
title: "ZRPTH409F01 — ABAP 프로그램·독립 Include"
as_of: 2026-10-07
review_status: pending_business_review
tags: [대휴익휴보상휴가, 선택근무, 재량근무, 특별연장재난방송]
---

# ZRPTH409F01 — ABAP 프로그램·독립 Include

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 제목 메타데이터 없음; 이름만으로 업무를 확정하지 않음.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZRPTH409F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/attributes/ZRPTH409F01.xml) | 36행; 원본 보존 |
| [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) | 1482행; 원본 보존 |
| [../texts/ZRPTH409F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/texts/ZRPTH409F01.xml) | 16행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ALSM_EXCEL_TO_INTERNAL_TABLE](EXTERNAL_DEPENDENCIES.md#ALSM_EXCEL_TO_INTERNAL_TABLE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L1256 |
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — list_positive_inv 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L793, 807 |
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — medium 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L791, 805 |
| [CL_DD_DOCUMENT](EXTERNAL_DEPENDENCIES.md#CL_DD_DOCUMENT) | **클래스 참조** — strong 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L792, 806 |
| [CL_GUI_FRONTEND_SERVICES](EXTERNAL_DEPENDENCIES.md#CL_GUI_FRONTEND_SERVICES) | **클래스 참조** — file_open_dialog 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L1233 |
| [CL_GUI_FRONTEND_SERVICES](EXTERNAL_DEPENDENCIES.md#CL_GUI_FRONTEND_SERVICES) | **클래스 참조** — file_save_dialog 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L861 |
| [CL_GUI_FRONTEND_SERVICES](EXTERNAL_DEPENDENCIES.md#CL_GUI_FRONTEND_SERVICES) | **클래스 참조** — filetype_excel 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L863 |
| [DYNP_VALUES_READ](EXTERNAL_DEPENDENCIES.md#DYNP_VALUES_READ) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L118 |
| [HR_ECM_GET_ALL_DOMAIN_VALUE](EXTERNAL_DEPENDENCIES.md#HR_ECM_GET_ALL_DOMAIN_VALUE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L970, 1309 |
| [HR_IN_LAST_DAY_OF_MONTHS](EXTERNAL_DEPENDENCIES.md#HR_IN_LAST_DAY_OF_MONTHS) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L16, 64, 214, 509, 585 |
| [PA0001](EXTERNAL_DEPENDENCIES.md#PA0001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L233, 522 |
| [PA9021](PA9021.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L233 |
| [POPUP_TO_CONFIRM](EXTERNAL_DEPENDENCIES.md#POPUP_TO_CONFIRM) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L950, 1123, 1289 |
| [POPUP_TO_SELECT_MONTH](EXTERNAL_DEPENDENCIES.md#POPUP_TO_SELECT_MONTH) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L144 |
| [RH_DETERMINE_ORG_OBJID](EXTERNAL_DEPENDENCIES.md#RH_DETERMINE_ORG_OBJID) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L83 |
| [SAP_CONVERT_TO_XLS_FORMAT](EXTERNAL_DEPENDENCIES.md#SAP_CONVERT_TO_XLS_FORMAT) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L909, 1471 |
| [ZHR_52TM_WKTYPE](ZHR_52TM_WKTYPE.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L325 |
| [ZHR_GET_DAY_DATA_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_DAY_DATA_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L1069, 1429 |
| [ZHR_GET_MANAGER_TYPE_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_MANAGER_TYPE_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L527 |
| [ZHR_GET_PERSONNEL_DATA_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_PERSONNEL_DATA_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L1028, 1411 |
| [ZRPTH409F01](ZRPTH409F01.md) | **FORM 호출** — APPEND_INIT_FIELDCAT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap L707; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L667, 686 |
| [ZRPTH409F01](ZRPTH409F01.md) | **FORM 호출** — GET_ZDBEG_ZDEND_1YEAR: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap L575; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L413 |
| [ZTHR0125](ZTHR0125.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L299 |
| [ZTHR0125](ZTHR0125.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L178 |
| [ZTHR0126](ZTHR0126.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L306 |
| [ZTHR0126](ZTHR0126.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L179 |
| [ZTHR0127](ZTHR0127.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L313 |
| [ZTHR0127](ZTHR0127.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L180 |
| [ZTHR0129](ZTHR0129.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L280 |
| [ZTHR0129](ZTHR0129.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L183 |
| [ZTHR0130](ZTHR0130.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L289 |
| [ZTHR0130](ZTHR0130.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L184 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 저장** — DELETE FROM DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L1164 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 저장** — INSERT DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L1077, 1437 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 저장** — MODIFY DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L1079, 1439 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L266, 995, 1016, 1150, 1356, 1376 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_3F03](LZHR008_3F03.md) | FORM 호출 | [LZHR008_3F03.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap) L636 |
| [ZRPTH409](ZRPTH409.md) | FORM 호출 | [ZRPTH409.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409/source/ZRPTH409.abap) L26, 45, 48, 55, 62 |
| [ZRPTH409](ZRPTH409.md) | Include | [ZRPTH409.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409/source/ZRPTH409.abap) L19 |
| [ZRPTH409F01](ZRPTH409F01.md) | FORM 호출 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L413, 667, 686 |
| [ZRPTH409I01](ZRPTH409I01.md) | FORM 호출 | [ZRPTH409I01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409I01/source/ZRPTH409I01.abap) L28, 30, 32 |
| [ZRPTH409O01](ZRPTH409O01.md) | FORM 호출 | [ZRPTH409O01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409O01/source/ZRPTH409O01.abap) L76, 79, 82 |
| [ZRPTH409TOP](ZRPTH409TOP.md) | FORM 호출 | [ZRPTH409TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409TOP/source/ZRPTH409TOP.abap) L134, 139, 143 |
| [ZRPTH410F01](ZRPTH410F01.md) | FORM 호출 | [ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap) L1223 |

### 관련 업무와 미확인 범위

- [discretionary](../topics/discretionary.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [rest](../topics/rest.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
