---
title: "ZRPTH405F01 — ABAP 프로그램·독립 Include"
as_of: 2026-10-07
review_status: pending_business_review
tags: [근무현황조회]
---

# ZRPTH405F01 — ABAP 프로그램·독립 Include

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 제목 메타데이터 없음; 이름만으로 업무를 확정하지 않음.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZRPTH405F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/attributes/ZRPTH405F01.xml) | 36행; 원본 보존 |
| [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) | 668행; 원본 보존 |
| [../texts/ZRPTH405F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/texts/ZRPTH405F01.xml) | 16행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — heading 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L382 |
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — list_heading_int 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L383 |
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — list_positive_inv 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L396, 410 |
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — medium 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L394, 408 |
| [CL_DD_DOCUMENT](EXTERNAL_DEPENDENCIES.md#CL_DD_DOCUMENT) | **클래스 참조** — strong 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L395, 409 |
| [RHPH_STRUCTURE_READ](EXTERNAL_DEPENDENCIES.md#RHPH_STRUCTURE_READ) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L188 |
| [RP_LAST_DAY_OF_MONTHS](EXTERNAL_DEPENDENCIES.md#RP_LAST_DAY_OF_MONTHS) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L45, 89 |
| [SAPGUI_PROGRESS_INDICATOR](EXTERNAL_DEPENDENCIES.md#SAPGUI_PROGRESS_INDICATOR) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L230 |
| [T501T](EXTERNAL_DEPENDENCIES.md#T501T) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L342 |
| [T503T](EXTERNAL_DEPENDENCIES.md#T503T) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L355 |
| [T527X](EXTERNAL_DEPENDENCIES.md#T527X) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L151 |
| [ZHR_52TM_AWART_LIST](ZHR_52TM_AWART_LIST.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L603 |
| [ZHR_52TM_PERSONAL_WORK_TIME](ZHR_52TM_PERSONAL_WORK_TIME.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L585 |
| [ZHR_52TM_WEEK_FROM_TO_DATE](ZHR_52TM_WEEK_FROM_TO_DATE.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L53, 100 |
| [ZHR_52TM_WKTYPE_PERIOD](ZHR_52TM_WKTYPE_PERIOD.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L247 |
| [ZHR_GET_DAY_DATA_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_DAY_DATA_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L595 |
| [ZHR_GET_PERSONNEL_RANK_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_PERSONNEL_RANK_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L300 |
| [ZRPTH405F01](ZRPTH405F01.md) | **FORM 호출** — APPEND_INIT_FIELDCAT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap L484; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L447, 460, 464 |
| [ZRPTH405F01](ZRPTH405F01.md) | **FORM 호출** — GET_PERSGTXT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap L338; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L294 |
| [ZRPTH405F01](ZRPTH405F01.md) | **FORM 호출** — GET_PERSKTXT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap L351; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L297 |
| [ZRPTH405F01](ZRPTH405F01.md) | **FORM 호출** — GET_VDSK1TXT_ZORDER: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap L322; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L289 |
| [ZSHR0111](ZSHR0111.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L569 |
| [ZSHR0119](ZSHR0119.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L241 |
| [ZSHR0122](ZSHR0122.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L571 |
| [ZTH0076](EXTERNAL_DEPENDENCIES.md#ZTH0076) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L129 |
| [ZTH0500](EXTERNAL_DEPENDENCIES.md#ZTH0500) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L328 |
| [ZUM0013](EXTERNAL_DEPENDENCIES.md#ZUM0013) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L139 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [ZRPTH405](ZRPTH405.md) | FORM 호출 | [ZRPTH405.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405/source/ZRPTH405.abap) L21, 27, 33, 34, 46, 47, 56, 59 |
| [ZRPTH405](ZRPTH405.md) | Include | [ZRPTH405.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405/source/ZRPTH405.abap) L13 |
| [ZRPTH405F01](ZRPTH405F01.md) | FORM 호출 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L289, 294, 297, 447, 460, 464 |
| [ZRPTH405O01](ZRPTH405O01.md) | FORM 호출 | [ZRPTH405O01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405O01/source/ZRPTH405O01.abap) L70, 73, 76 |
| [ZRPTH405TOP](ZRPTH405TOP.md) | FORM 호출 | [ZRPTH405TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405TOP/source/ZRPTH405TOP.abap) L110 |

### 관련 업무와 미확인 범위

- [reporting](../topics/reporting.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
