---
title: "MORD_OT_MODIFY_new — [모바일] 통상근무 시간외 수정"
as_of: 2026-10-07
review_status: pending_business_review
tags: [통상시차시간외]
---

# MORD_OT_MODIFY_new — [모바일] 통상근무 시간외 수정

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **BSP 화면·스크립트**. 설명: [모바일] 통상근무 시간외 수정.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) | 3272행; 원본 보존 |
| [../Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Page%20Attributes.xml) | 12행; 원본 보존 |
| [../Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Properties.xml) | 45행; 원본 보존 |
| [../Type Definitions.abap](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Type%20Definitions.abap) | 0행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Properties.xml) L18 | IMPLCLASS=CL_O29PJJOXD0DWT18EET6VD0Y1OHK; 생성 클래스 본문/실행 미확인 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Properties.xml) L39 | VERSION=A; metadata이며 운영 사용 증거 아님 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Properties.xml) L35 | IS_START_PAGE=빈값; metadata이며 운영 사용 증거 아님 |
| 페이지 매개변수 정의 | [Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Page%20Attributes.xml) L10 | PAGE_ATTRIBUTES 항목 0개. 웹 요청 데이터는 Layout JavaScript와 함수 인터페이스에서 별도로 확인 |

### 화면 이벤트와 JavaScript

Layout의 인라인 JavaScript를 함께 색인했다. onClick/onChange는 화면 이벤트, Event Handler ABAP는 서버 이벤트이며 서로 동일하지 않다. 구형·new·bak 명칭만으로 운영 사용 여부를 결정하지 않는다.

| 구분 | 이름·식 | 원본 위치 |
|---|---|---|
| JS 함수 정의 | `fn_ZHR_52TM_CALC_BREAK_TIME` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L1225 |
| JS 함수 정의 | `fn_callBackZHR_52TM_CALC_BREAK_TIME` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L1242 |
| JS 함수 정의 | `fn_disInit` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L1718 |
| JS 함수 정의 | `fn_addBreakDiv` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L1752 |
| JS 함수 정의 | `fn_save` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L1830 |
| JS 함수 정의 | `fn_approval` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L1835 |
| JS 함수 정의 | `before_fn_ZHR_52TM_MOBILE_OVERTIME_CHANG` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L1868 |
| JS 함수 정의 | `fn_callbackBefore_fn_ZHR_52TM_MOBILE_OVERTIME_CHANG` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L1899 |
| JS 함수 정의 | `fn_ZHR_52TM_MOBILE_OVERTIME_CHANG` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L1908 |
| JS 함수 정의 | `fn_ZHR_52TM_MOBILE_OVERTIME_APPR` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L1932 |
| JS 함수 정의 | `fn_setButton` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2213 |
| HTML 이벤트 바인딩 | `fn_iamSelect(` → 함수 정의/실행 대상 추가 확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L430 |
| HTML 이벤트 바인딩 | `fn_setEname(` → 함수 정의/실행 대상 추가 확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2156 |
| HTML 이벤트 바인딩 | `fn_approval(` → 같은 Layout 함수 정의 L1835 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2218 |
| HTML 이벤트 바인딩 | `fn_approval(` → 같은 Layout 함수 정의 L1835 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2219 |
| HTML 이벤트 바인딩 | `fn_approval(` → 같은 Layout 함수 정의 L1835 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2220 |
| HTML 이벤트 바인딩 | `fn_approval(` → 같은 Layout 함수 정의 L1835 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2221 |
| HTML 이벤트 바인딩 | `fn_cancel();` → 함수 정의/실행 대상 추가 확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2222 |
| HTML 이벤트 바인딩 | `fn_openIamLayer()` → 함수 정의/실행 대상 추가 확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2528 |
| HTML 이벤트 바인딩 | `fn_checkZTOICH()` → 함수 정의/실행 대상 추가 확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2629 |
| HTML 이벤트 바인딩 | `fn_checkZTOMOH()` → 함수 정의/실행 대상 추가 확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2633 |
| HTML 이벤트 바인딩 | `fn_checkZDAEH()` → 함수 정의/실행 대상 추가 확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2637 |
| HTML 이벤트 바인딩 | `fn_checkZEMCWK()` → 함수 정의/실행 대상 추가 확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2641 |
| HTML 이벤트 바인딩 | `fn_openBreaktimeLayer();` → 함수 정의/실행 대상 추가 확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2676 |
| HTML 이벤트 바인딩 | `fn_ZEP_SEARCH_ENAME()` → 함수 정의/실행 대상 추가 확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2696 |
| HTML 이벤트 바인딩 | `fn_cancel();` → 함수 정의/실행 대상 추가 확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2702 |
| HTML 이벤트 바인딩 | `fn_ZEP_SEARCH_ENAME1()` → 함수 정의/실행 대상 추가 확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2754 |
| HTML 이벤트 바인딩 | `fn_agreement(` → 함수 정의/실행 대상 추가 확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2780 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L1752 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2881 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L1752 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2973 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L1752 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2974 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L1752 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L3066 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L1752 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L3158 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L1752 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L3159 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L1752 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L3251 |
| HTML 이벤트 바인딩 | `fn_closeBreaktimeLayer()` → 함수 정의/실행 대상 추가 확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L3264 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZEP_SEARCH_ENAME](EXTERNAL_DEPENDENCIES.md#ZEP_SEARCH_ENAME) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2139, 2176 |
| [ZHR_52TM_CALC_BREAK_TIME](ZHR_52TM_CALC_BREAK_TIME.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L1234 |
| [ZHR_52TM_CALC_WORK_TIME_DAYILY](ZHR_52TM_CALC_WORK_TIME_DAYILY.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L1340 |
| [ZHR_52TM_IAM](ZHR_52TM_IAM.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L407 |
| [ZHR_52TM_MOBILE_OVERTIME_APPR](ZHR_52TM_MOBILE_OVERTIME_APPR.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L1968 |
| [ZHR_52TM_MOBILE_OVERTIME_CHANG](ZHR_52TM_MOBILE_OVERTIME_CHANG.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L1914 |
| [ZHR_52TM_MOBILE_OVERTIME_CHECK](ZHR_52TM_MOBILE_OVERTIME_CHECK.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L865, 1887 |
| [ZHR_52TM_MOBILE_OVERTIME_DETL](ZHR_52TM_MOBILE_OVERTIME_DETL.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L512 |
| [ZMOBILE_OVERTIME_APPROR_CHECK](EXTERNAL_DEPENDENCIES.md#ZMOBILE_OVERTIME_APPROR_CHECK) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2186 |
| [ZWEB_COMMON_GET_LOGIN_INFO](EXT-ZWEB_COMMON_GET_LOGIN_INFO.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2097 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| — | 색인 내 정적 참조 없음; 미사용 근거 아님 | 동적 호출·외부 시스템은 미확인 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.

| 미확인 종류 | 참조·이름 | 근거 |
|---|---|---|
| 외부 웹 파일 | `../zmobile_common/server_util3.ssjs` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L1 |
| 외부 웹 파일 | `https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.14.1/moment.min.js` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L14 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/jquery-1.8.0.min.js` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L15 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/ess_include.js` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L18 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/ess_common.js` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L19 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_common/json2.js` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L20 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_common/modernizr.js` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L21 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/bootstrap-datepicker.min.js` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L22 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/bootstrap-datepicker.ko.min.js` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L23 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/common_new.js` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2419 |
| 외부 웹 파일 | `/m001/js/cap.js` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L2422 |
| 웹 중계 의존 | `../zmobile_common/server_util3.ssjs` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L1 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L35 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L1238 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L1897 |

정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
