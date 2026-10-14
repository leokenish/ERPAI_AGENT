---
title: "MAIN — NEW MOBILE MAIN PAGE"
as_of: 2026-10-07
review_status: pending_business_review
tags: [PC모바일공통웹, 통상시차시간외]
---

# MAIN — NEW MOBILE MAIN PAGE

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **BSP 화면·스크립트**. 설명: NEW MOBILE MAIN PAGE.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [MAIN.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm) | 359행; 원본 보존 |
| [../Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Page%20Attributes.xml) | 12행; 원본 보존 |
| [../Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Properties.xml) | 45행; 원본 보존 |
| [../Type Definitions.abap](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Type%20Definitions.abap) | 0행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Properties.xml) L18 | IMPLCLASS=CL_O25FP5C5MNEINWGJX1BPIV3WC3C; 생성 클래스 본문/실행 미확인 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Properties.xml) L39 | VERSION=A; metadata이며 운영 사용 증거 아님 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Properties.xml) L35 | IS_START_PAGE=빈값; metadata이며 운영 사용 증거 아님 |
| 페이지 매개변수 정의 | [Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Page%20Attributes.xml) L10 | PAGE_ATTRIBUTES 항목 0개. 웹 요청 데이터는 Layout JavaScript와 함수 인터페이스에서 별도로 확인 |

### 화면 이벤트와 JavaScript

Layout의 인라인 JavaScript를 함께 색인했다. onClick/onChange는 화면 이벤트, Event Handler ABAP는 서버 이벤트이며 서로 동일하지 않다. 구형·new·bak 명칭만으로 운영 사용 여부를 결정하지 않는다.

| 구분 | 이름·식 | 원본 위치 |
|---|---|---|
| HTML 이벤트 바인딩 | `javascript:fn_moveMenu(` → 함수 정의/실행 대상 추가 확인 | [MAIN.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm) L81 |
| HTML 이벤트 바인딩 | `javascript:fn_moveMenu(` → 함수 정의/실행 대상 추가 확인 | [MAIN.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm) L82 |
| HTML 이벤트 바인딩 | `javascript:fn_moveMenu(` → 함수 정의/실행 대상 추가 확인 | [MAIN.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm) L83 |
| HTML 이벤트 바인딩 | `javascript:fn_moveMenu(` → 함수 정의/실행 대상 추가 확인 | [MAIN.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm) L84 |
| HTML 이벤트 바인딩 | `javascript:fn_moveMenu(` → 함수 정의/실행 대상 추가 확인 | [MAIN.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm) L85 |
| HTML 이벤트 바인딩 | `fn_goUrl(\` → 함수 정의/실행 대상 추가 확인 | [MAIN.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm) L207 |
| HTML 이벤트 바인딩 | `fn_goUrl(\` → 함수 정의/실행 대상 추가 확인 | [MAIN.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm) L244 |
| HTML 이벤트 바인딩 | `fn_goUrl(\` → 함수 정의/실행 대상 추가 확인 | [MAIN.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm) L281 |
| HTML 이벤트 바인딩 | `fn_goUrl(\` → 함수 정의/실행 대상 추가 확인 | [MAIN.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm) L323 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZMOBILE_GUNTAE_LIST](EXTERNAL_DEPENDENCIES.md#ZMOBILE_GUNTAE_LIST) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MAIN.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm) L156 |
| [ZMOBILE_HR_LIST](EXTERNAL_DEPENDENCIES.md#ZMOBILE_HR_LIST) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MAIN.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm) L149 |
| [ZMOBILE_OVERTIME_LIST](EXTERNAL_DEPENDENCIES.md#ZMOBILE_OVERTIME_LIST) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MAIN.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm) L169, 176 |
| [ZMOBILE_TRIP_LIST](EXTERNAL_DEPENDENCIES.md#ZMOBILE_TRIP_LIST) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MAIN.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm) L163 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [MORD_OT_INSERT](MORD_OT_INSERT.md) | 웹 파일 참조 | [MORD_OT_INSERT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_INSERT/Layout/MORD_OT_INSERT.htm) L906 |
| [MORD_OT_INSERT_new](MORD_OT_INSERT_new.md) | 웹 파일 참조 | [MORD_OT_INSERT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_INSERT_new/Layout/MORD_OT_INSERT_new.htm) L64 |

### 관련 업무와 미확인 범위

- [web-common](../topics/web-common.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.

| 미확인 종류 | 참조·이름 | 근거 |
|---|---|---|
| 외부 웹 파일 | `../zmobile_common/server_util.ssjs` | [MAIN.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm) L73 |
| 웹 중계 의존 | `../zmobile_common/server_util.ssjs` | [MAIN.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm) L73 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MAIN.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm) L152 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MAIN.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm) L159 |
| 웹 중계 의존 | `../zweb_common/AJAX_COMMON.HTM` | [MAIN.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm) L165 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MAIN.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm) L171 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MAIN.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm) L178 |

정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
