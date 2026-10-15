---
title: "ZRPTH422 — [52시간] 교대연장실비 정산 시뮬레이션"
as_of: 2026-10-07
review_status: pending_business_review
tags: [교대근무, 월정산전표지급]
---

# ZRPTH422 — [52시간] 교대연장실비 정산 시뮬레이션

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: [52시간] 교대연장실비 정산 시뮬레이션.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZRPTH422.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/attributes/ZRPTH422.xml) | 36행; 원본 보존 |
| [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) | 958행; 원본 보존 |
| [../texts/ZRPTH422.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/texts/ZRPTH422.xml) | 40행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — col_textarea 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L684 |
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — list_positive_inv 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L737, 751 |
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — medium 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L735, 749 |
| [CL_DD_DOCUMENT](EXTERNAL_DEPENDENCIES.md#CL_DD_DOCUMENT) | **클래스 참조** — strong 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L736, 750 |
| [CONVERSION_EXIT_PERI_INPUT](EXTERNAL_DEPENDENCIES.md#CONVERSION_EXIT_PERI_INPUT) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L230 |
| [CONVERSION_EXIT_PERI_OUTPUT](EXTERNAL_DEPENDENCIES.md#CONVERSION_EXIT_PERI_OUTPUT) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L254 |
| [DYNP_VALUES_READ](EXTERNAL_DEPENDENCIES.md#DYNP_VALUES_READ) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L204 |
| [DYNP_VALUES_UPDATE](EXTERNAL_DEPENDENCIES.md#DYNP_VALUES_UPDATE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L260 |
| [LAST_DAY_OF_MONTHS](EXTERNAL_DEPENDENCIES.md#LAST_DAY_OF_MONTHS) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L325 |
| [POPUP_TO_SELECT_MONTH](EXTERNAL_DEPENDENCIES.md#POPUP_TO_SELECT_MONTH) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L241 |
| [RHPH_STRUCTURE_READ](EXTERNAL_DEPENDENCIES.md#RHPH_STRUCTURE_READ) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L352 |
| [RP_PNP_ORGSTRUCTURE](EXTERNAL_DEPENDENCIES.md#RP_PNP_ORGSTRUCTURE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L289 |
| [T527X](EXTERNAL_DEPENDENCIES.md#T527X) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L495 |
| [ZECOST](ZECOST.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L35 |
| [ZHR_52TM_GET_SHIFT_OT_DATA](ZHR_52TM_GET_SHIFT_OT_DATA.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L427 |
| [ZHR_GET_PERSON](EXTERNAL_DEPENDENCIES.md#ZHR_GET_PERSON) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L545 |
| [ZHR_GET_PERSONNEL_RANK_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_PERSONNEL_RANK_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L559 |
| [ZRPTH422](ZRPTH422.md) | **FORM 호출** — ALV_HANDLE_TOP_OF_PAGE: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap L722; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L104 |
| [ZRPTH422](ZRPTH422.md) | **FORM 호출** — APPEND_INIT_FIELDCAT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap L852; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L798 |
| [ZRPTH422](ZRPTH422.md) | **FORM 호출** — F4_VDSK1: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap L284; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L135 |
| [ZRPTH422](ZRPTH422.md) | **FORM 호출** — FREE_OBJECT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap L931; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L916, 919 |
| [ZRPTH422](ZRPTH422.md) | **FORM 호출** — GET_DEPT_DATA: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap L478; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L370 |
| [ZRPTH422](ZRPTH422.md) | **FORM 호출** — GET_PERSON_DATA: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap L527; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L403 |
| [ZRPTH422](ZRPTH422.md) | **FORM 호출** — INITIALIZE: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap L160; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L125 |
| [ZRPTH422](ZRPTH422.md) | **FORM 호출** — MONAT_F4: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap L190; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L132 |
| [ZRPTH422](ZRPTH422.md) | **FORM 호출** — SELECT_DATA: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap L309; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L142 |
| [ZRPTH422](ZRPTH422.md) | **FORM 호출** — SET_FIELDCAT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap L795; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L662 |
| [ZRPTH422](ZRPTH422.md) | **FORM 호출** — SET_LAYOUT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap L778; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L659 |
| [ZRPTH422](ZRPTH422.md) | **FORM 호출** — SET_SORT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap L824; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L665 |
| [ZTH0500](EXTERNAL_DEPENDENCIES.md#ZTH0500) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L504 |
| [ZTHR2006_1_NEW](EXT-ZTHR2006_1_NEW.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L388 |
| [ZTHRCOST](EXT-ZTHRCOST.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L587 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [ZRPTH422](ZRPTH422.md) | FORM 호출 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L104, 125, 132, 135, 142, 370, 403, 659, 662, 665, 798, 916, 919 |

### 관련 업무와 미확인 범위

- [shift](../topics/shift.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
