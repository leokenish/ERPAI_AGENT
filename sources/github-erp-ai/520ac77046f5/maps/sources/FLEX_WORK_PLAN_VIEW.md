---
title: "FLEX_WORK_PLAN_VIEW — [PC] 탄력근로-근무계획수립VIEW"
as_of: 2026-10-07
review_status: pending_business_review
tags: [탄력근무]
---

# FLEX_WORK_PLAN_VIEW — [PC] 탄력근로-근무계획수립VIEW

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **BSP 화면·스크립트**. 설명: [PC] 탄력근로-근무계획수립VIEW.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) | 2016행; 원본 보존 |
| [../Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Page%20Attributes.xml) | 12행; 원본 보존 |
| [../Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Properties.xml) | 45행; 원본 보존 |
| [../Type Definitions.abap](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Type%20Definitions.abap) | 0행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Properties.xml) L18 | IMPLCLASS=CL_O25FMKMBULP7SYRFLDW8HY84L6G; 생성 클래스 본문/실행 미확인 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Properties.xml) L39 | VERSION=A; metadata이며 운영 사용 증거 아님 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Properties.xml) L35 | IS_START_PAGE=빈값; metadata이며 운영 사용 증거 아님 |
| 페이지 매개변수 정의 | [Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Page%20Attributes.xml) L10 | PAGE_ATTRIBUTES 항목 0개. 웹 요청 데이터는 Layout JavaScript와 함수 인터페이스에서 별도로 확인 |

### 화면 이벤트와 JavaScript

Layout의 인라인 JavaScript를 함께 색인했다. onClick/onChange는 화면 이벤트, Event Handler ABAP는 서버 이벤트이며 서로 동일하지 않다. 구형·new·bak 명칭만으로 운영 사용 여부를 결정하지 않는다.

| 구분 | 이름·식 | 원본 위치 |
|---|---|---|
| JS 함수 정의 | `fn_ResetSelectBox` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L661 |
| JS 함수 정의 | `fn_init` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L666 |
| JS 함수 정의 | `fn_makeWeek` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L684 |
| JS 함수 정의 | `fn_ZHR_52TM_AWART_LIST` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L710 |
| JS 함수 정의 | `fn_callBackZHR_52TM_AWART_LIST` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L722 |
| JS 함수 정의 | `fn_ZHR_52TM_PLAN_CALC_TIME` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L742 |
| JS 함수 정의 | `fn_callBackZHR_52TM_PLAN_CALC_TIME` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L755 |
| JS 함수 정의 | `fn_ZHR_52TM_PLAN_WORK_TIME` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L776 |
| JS 함수 정의 | `fn_callBackZHR_52TM_PLAN_WORK_TIME1` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L906 |
| JS 함수 정의 | `fn_callBackZHR_52TM_PLAN_WORK_TIME2` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1048 |
| JS 함수 정의 | `fn_ZHR_52TM_CALC_WEEK_TIME` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1062 |
| JS 함수 정의 | `fn_callBackZHR_52TM_CALC_WEEK_TIME` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1077 |
| JS 함수 정의 | `fn_ZHR_52TM_CALC_BREAK_TIME` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1092 |
| JS 함수 정의 | `fn_callBackZHR_52TM_CALC_BREAK_TIME` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1136 |
| JS 함수 정의 | `fn_ZHR_52TM_CALC_WORK_TIME_DAYILY` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1169 |
| JS 함수 정의 | `fn_callBackZHR_52TM_CALC_WORK_TIME_DAYILY` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1279 |
| JS 함수 정의 | `fn_makeForamt` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1312 |
| JS 함수 정의 | `fn_weekDrawing` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1330 |
| JS 함수 정의 | `fn_gridInit` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1413 |
| JS 함수 정의 | `fn_drawGrid` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1457 |
| JS 함수 정의 | `fn_setSchData` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1554 |
| JS 함수 정의 | `makeDisabledDate` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1678 |
| JS 함수 정의 | `fn_formatTime` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1685 |
| JS 함수 정의 | `fn_formatDay` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1702 |
| JS 함수 정의 | `fn_yoil` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1716 |
| JS 함수 정의 | `fn_cancel` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1734 |
| JS 함수 정의 | `fn_addBreakDiv` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1784 |
| JS 함수 정의 | `fn_setButton` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1848 |
| JS 함수 정의 | `fn_moveMenu` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1929 |
| JS 함수 정의 | `fn_ZWEB_COMMON_GET_LOGIN_INFO` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1951 |
| JS 함수 정의 | `fn_callBackZWEB_COMMON_GET_LOGIN_INFO` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1959 |
| JS 함수 정의 | `fn_ZHR_52TM_REAL_WORK_TIME` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1986 |
| JS 함수 정의 | `fn_callBackZHR_52TM_REAL_WORK_TIME` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L2000 |
| JS 함수 정의 | `fn_list` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L2011 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZHR_52TM_AWART_LIST](ZHR_52TM_AWART_LIST.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L713 |
| [ZHR_52TM_CALC_BREAK_TIME](ZHR_52TM_CALC_BREAK_TIME.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1125 |
| [ZHR_52TM_CALC_WEEK_TIME](ZHR_52TM_CALC_WEEK_TIME.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1065 |
| [ZHR_52TM_CALC_WORK_TIME_DAYILY](ZHR_52TM_CALC_WORK_TIME_DAYILY.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1272 |
| [ZHR_52TM_PLAN_CALC_TIME](ZHR_52TM_PLAN_CALC_TIME.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L748 |
| [ZHR_52TM_PLAN_WORK_TIME](ZHR_52TM_PLAN_WORK_TIME.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L787, 887 |
| [ZHR_52TM_REAL_WORK_TIME](ZHR_52TM_REAL_WORK_TIME.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1989 |
| [ZWEB_COMMON_GET_LOGIN_INFO](EXT-ZWEB_COMMON_GET_LOGIN_INFO.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1954 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| — | 색인 내 정적 참조 없음; 미사용 근거 아님 | 동적 호출·외부 시스템은 미확인 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.

| 미확인 종류 | 참조·이름 | 근거 |
|---|---|---|
| 외부 웹 파일 | `../zweb_common/server_util2.ssjs` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L2 |
| 웹 중계 의존 | `../zweb_common/server_util2.ssjs` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L2 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L719 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L752 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L800 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L900 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1074 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1129 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1275 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1956 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1997 |

정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
