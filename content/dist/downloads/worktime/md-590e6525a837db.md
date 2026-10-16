---
title: "temp — [PC] 통상근무 시간외 신청"
as_of: 2026-10-07
review_status: pending_business_review
tags: [통상시차시간외]
---

# temp — [PC] 통상근무 시간외 신청

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **BSP 화면·스크립트**. 설명: [PC] 통상근무 시간외 신청.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) | 2907행; 원본 보존 |
| [../Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Page%20Attributes.xml) | 12행; 원본 보존 |
| [../Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Properties.xml) | 45행; 원본 보존 |
| [../Type Definitions.abap](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Type%20Definitions.abap) | 0행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Properties.xml) L18 | IMPLCLASS=CL_O25GW2KOU259METTYZA87L33BJS; 생성 클래스 본문/실행 미확인 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Properties.xml) L39 | VERSION=A; metadata이며 운영 사용 증거 아님 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Properties.xml) L35 | IS_START_PAGE=빈값; metadata이며 운영 사용 증거 아님 |
| 페이지 매개변수 정의 | [Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Page%20Attributes.xml) L10 | PAGE_ATTRIBUTES 항목 0개. 웹 요청 데이터는 Layout JavaScript와 함수 인터페이스에서 별도로 확인 |

### 화면 이벤트와 JavaScript

Layout의 인라인 JavaScript를 함께 색인했다. onClick/onChange는 화면 이벤트, Event Handler ABAP는 서버 이벤트이며 서로 동일하지 않다. 구형·new·bak 명칭만으로 운영 사용 여부를 결정하지 않는다.

| 구분 | 이름·식 | 원본 위치 |
|---|---|---|
| JS 함수 정의 | `fn_display` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L790 |
| JS 함수 정의 | `callCalendar` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1114 |
| JS 함수 정의 | `fn_checkZTOMOH` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1119 |
| JS 함수 정의 | `fn_checkZDAEH` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1130 |
| JS 함수 정의 | `fn_checkZEMCWK` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1141 |
| JS 함수 정의 | `fn_init` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1151 |
| JS 함수 정의 | `fn_ZHR_52TM_MOBILE_OVERTIME_CHECK` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1179 |
| JS 함수 정의 | `fn_callbackZHR_52TM_MOBILE_OVERTIME_CHECK` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1208 |
| JS 함수 정의 | `fn_validation` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1531 |
| JS 함수 정의 | `fn_save` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1555 |
| JS 함수 정의 | `fn_approval` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1561 |
| JS 함수 정의 | `fn_ZHR_52TM_MOBILE_OVERTIME_APPR` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1573 |
| JS 함수 정의 | `fn_callbackZHR_52TM_MOBILE_OVERTIME_APPR` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1592 |
| JS 함수 정의 | `fn_ZHR_52TM_MOBILE_OVERTIME_DETL` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1615 |
| JS 함수 정의 | `fn_callbackZHR_52TM_MOBILE_OVERTIME_DETL` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1628 |
| JS 함수 정의 | `fn_ZHR_52TM_MOBILE_OVERTIME_CHANG` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1710 |
| JS 함수 정의 | `fn_callbackZHR_52TM_MOBILE_OVERTIME_CHANG` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1725 |
| JS 함수 정의 | `fn_callbackZHR_52TM_MOBILE_OVERTIME_APPR1` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1751 |
| JS 함수 정의 | `fn_makeForamt` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1766 |
| JS 함수 정의 | `fn_formatTime` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1783 |
| JS 함수 정의 | `fn_formatDay` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1799 |
| JS 함수 정의 | `fn_disInit` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1813 |
| JS 함수 정의 | `fn_addBreakDiv` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1846 |
| JS 함수 정의 | `fn_cancel` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1923 |
| JS 함수 정의 | `fn_cancel1` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1930 |
| JS 함수 정의 | `aaa` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1937 |
| JS 함수 정의 | `fn_ResetSelectBox` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1943 |
| JS 함수 정의 | `fn_setForm` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1949 |
| JS 함수 정의 | `fn_ZHR_52TM_CALC_BREAK_TIME` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2020 |
| JS 함수 정의 | `fn_callBackZHR_52TM_CALC_BREAK_TIME` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2051 |
| JS 함수 정의 | `fn_ZHR_52TM_CALC_WORK_TIME_DAYILY` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2067 |
| JS 함수 정의 | `fn_callBackZHR_52TM_CALC_WORK_TIME_DAYILY` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2155 |
| JS 함수 정의 | `fn_addBreakTime` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2173 |
| JS 함수 정의 | `fn_makeForamt` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2264 |
| JS 함수 정의 | `fn_getStrdTime` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2280 |
| JS 함수 정의 | `fn_validateBtDup` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2327 |
| JS 함수 정의 | `fn_ZWEB_COMMON_GET_LOGIN_INFO` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2544 |
| JS 함수 정의 | `fn_callBackZWEB_COMMON_GET_LOGIN_INFO` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2553 |
| JS 함수 정의 | `fn_ZEP_SEARCH_ENAME` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2583 |
| JS 함수 정의 | `fn_setEnameList` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2611 |
| JS 함수 정의 | `fn_ZEP_SEARCH_ENAME1` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2654 |
| JS 함수 정의 | `fn_setEnameList1` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2665 |
| JS 함수 정의 | `fn_setEname` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2693 |
| JS 함수 정의 | `callBackApprChk` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2706 |
| JS 함수 정의 | `numberWithCommas` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2724 |
| JS 함수 정의 | `onlyNumber` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2729 |
| JS 함수 정의 | `removeChar` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2738 |
| JS 함수 정의 | `fn_timeLimit` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2749 |
| JS 함수 정의 | `lfn_getEnameLayerHtml` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2838 |
| JS 함수 정의 | `displayLayer` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2870 |
| JS 함수 정의 | `hideLayer` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2883 |
| JS 함수 정의 | `fn_agreement` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2887 |
| HTML 이벤트 바인딩 | `callCalendar();` → 같은 Layout 함수 정의 L1114 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L124 |
| HTML 이벤트 바인딩 | `fn_display()` → 같은 Layout 함수 정의 L790 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L218 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L1846 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L307 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L1846 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L395 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L1846 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L396 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L1846 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L484 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L1846 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L485 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L1846 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L573 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L1846 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L574 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L1846 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L662 |
| HTML 이벤트 바인딩 | `fn_checkZTOMOH();` → 같은 Layout 함수 정의 L1119 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L700 |
| HTML 이벤트 바인딩 | `fn_checkZDAEH();` → 같은 Layout 함수 정의 L1130 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L704 |
| HTML 이벤트 바인딩 | `fn_checkZEMCWK();` → 같은 Layout 함수 정의 L1141 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L712 |
| HTML 이벤트 바인딩 | `fn_ZEP_SEARCH_ENAME();` → 같은 Layout 함수 정의 L2583 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L732 |
| HTML 이벤트 바인딩 | `fn_approval(` → 같은 Layout 함수 정의 L1561 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L752 |
| HTML 이벤트 바인딩 | `fn_save();` → 같은 Layout 함수 정의 L1555 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L753 |
| HTML 이벤트 바인딩 | `fn_cancel1();` → 같은 Layout 함수 정의 L1930 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L754 |
| HTML 이벤트 바인딩 | `fn_ZEP_SEARCH_ENAME1();` → 같은 Layout 함수 정의 L2654 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2856 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZEP_SEARCH_ENAME](EXTERNAL_DEPENDENCIES.md#ZEP_SEARCH_ENAME) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2604, 2657 |
| [ZHR_52TM_CALC_BREAK_TIME](ZHR_52TM_CALC_BREAK_TIME.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2043 |
| [ZHR_52TM_CALC_WORK_TIME_DAYILY](ZHR_52TM_CALC_WORK_TIME_DAYILY.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2148 |
| [ZHR_52TM_MOBILE_OVERTIME_APPR](ZHR_52TM_MOBILE_OVERTIME_APPR.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1584, 1738 |
| [ZHR_52TM_MOBILE_OVERTIME_CHANG](ZHR_52TM_MOBILE_OVERTIME_CHANG.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1717 |
| [ZHR_52TM_MOBILE_OVERTIME_CHECK](ZHR_52TM_MOBILE_OVERTIME_CHECK.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1195 |
| [ZHR_52TM_MOBILE_OVERTIME_DETL](ZHR_52TM_MOBILE_OVERTIME_DETL.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1621 |
| [ZMOBILE_OVERTIME_APPROR_CHECK](EXTERNAL_DEPENDENCIES.md#ZMOBILE_OVERTIME_APPROR_CHECK) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2697 |
| [ZWEB_COMMON_GET_LOGIN_INFO](EXT-ZWEB_COMMON_GET_LOGIN_INFO.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2548 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| — | 색인 내 정적 참조 없음; 미사용 근거 아님 | 동적 호출·외부 시스템은 미확인 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.

| 미확인 종류 | 참조·이름 | 근거 |
|---|---|---|
| 외부 웹 파일 | `../zweb_common/server_util2.ssjs` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2 |
| 웹 중계 의존 | `../zweb_common/server_util2.ssjs` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1205 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1589 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1626 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1723 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1743 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2047 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2151 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2550 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2608 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2661 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2703 |

정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
