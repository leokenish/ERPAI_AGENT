---
title: "ORD_OT_MODIFY — [PC] 통상근무 시간외 수정"
as_of: 2026-10-07
review_status: pending_business_review
tags: [통상시차시간외]
---

# ORD_OT_MODIFY — [PC] 통상근무 시간외 수정

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **BSP 화면·스크립트**. 설명: [PC] 통상근무 시간외 수정.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Event Handler/OnInitialization.abap](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Event%20Handler/OnInitialization.abap) | 1행; 원본 보존 |
| [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) | 3486행; 원본 보존 |
| [../Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Page%20Attributes.xml) | 12행; 원본 보존 |
| [../Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Properties.xml) | 45행; 원본 보존 |
| [../Type Definitions.abap](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Type%20Definitions.abap) | 0행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Properties.xml) L18 | IMPLCLASS=CL_O25GIZ6HE2PUQWPFQV3KGPUY2PK; 생성 클래스 본문/실행 미확인 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Properties.xml) L39 | VERSION=A; metadata이며 운영 사용 증거 아님 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Properties.xml) L35 | IS_START_PAGE=빈값; metadata이며 운영 사용 증거 아님 |
| 페이지 매개변수 정의 | [Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Page%20Attributes.xml) L10 | PAGE_ATTRIBUTES 항목 0개. 웹 요청 데이터는 Layout JavaScript와 함수 인터페이스에서 별도로 확인 |
| BSP 이벤트 | [OnInitialization.abap](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Event%20Handler/OnInitialization.abap) L1 | OnInitialization: 주석/공백만 존재; 실행 구문 없음; 실제 lifecycle 실행 미검증 |

### 화면 이벤트와 JavaScript

Layout의 인라인 JavaScript를 함께 색인했다. onClick/onChange는 화면 이벤트, Event Handler ABAP는 서버 이벤트이며 서로 동일하지 않다. 구형·new·bak 명칭만으로 운영 사용 여부를 결정하지 않는다.

| 구분 | 이름·식 | 원본 위치 |
|---|---|---|
| JS 함수 정의 | `callCalendar` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L871 |
| JS 함수 정의 | `fn_checkZTOMOH` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L1184 |
| JS 함수 정의 | `fn_checkZDAEH` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L1195 |
| JS 함수 정의 | `fn_checkZEMCWK` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L1207 |
| JS 함수 정의 | `fn_init` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L1217 |
| JS 함수 정의 | `fn_ZHR_52TM_MOBILE_OVERTIME_DETL` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L1244 |
| JS 함수 정의 | `fn_callbackZHR_52TM_MOBILE_OVERTIME_DETL` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L1258 |
| JS 함수 정의 | `fn_ZHR_52TM_MOBILE_OVERTIME_CHECK` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L1609 |
| JS 함수 정의 | `fn_callbackZHR_52TM_MOBILE_OVERTIME_CHECK` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L1664 |
| JS 함수 정의 | `fn_settimeinputable` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L1976 |
| JS 함수 정의 | `fn_validation` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L1994 |
| JS 함수 정의 | `fn_ZHR_52TM_CALC_BREAK_TIME` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2021 |
| JS 함수 정의 | `fn_callBackZHR_52TM_CALC_BREAK_TIME` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2041 |
| JS 함수 정의 | `fn_ZHR_52TM_CALC_WORK_TIME_DAYILY` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2060 |
| JS 함수 정의 | `fn_callBackZHR_52TM_CALC_WORK_TIME_DAYILY` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2176 |
| JS 함수 정의 | `fn_addBreakTime` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2198 |
| JS 함수 정의 | `fn_getStrdTime` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2291 |
| JS 함수 정의 | `fn_validateBtDup` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2338 |
| JS 함수 정의 | `fn_makeForamt` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2556 |
| JS 함수 정의 | `fn_formatTime` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2573 |
| JS 함수 정의 | `fn_formatDay` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2590 |
| JS 함수 정의 | `fn_disInit` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2606 |
| JS 함수 정의 | `fn_addBreakDiv` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2642 |
| JS 함수 정의 | `fn_save` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2722 |
| JS 함수 정의 | `fn_approval` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2727 |
| JS 함수 정의 | `before_fn_ZHR_52TM_MOBILE_OVERTIME_CHANG` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2763 |
| JS 함수 정의 | `fn_callbackBefore_fn_ZHR_52TM_MOBILE_OVERTIME_CHANG` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2796 |
| JS 함수 정의 | `fn_ZHR_52TM_MOBILE_OVERTIME_CHANG` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2808 |
| JS 함수 정의 | `fn_callbackZHR_52TM_MOBILE_OVERTIME_CHANG` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2823 |
| JS 함수 정의 | `fn_ZHR_52TM_MOBILE_OVERTIME_APPR` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2833 |
| JS 함수 정의 | `fn_callbackZHR_52TM_MOBILE_OVERTIME_APPR` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2877 |
| JS 함수 정의 | `fn_cancel` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2908 |
| JS 함수 정의 | `fn_ResetSelectBox` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2916 |
| JS 함수 정의 | `fn_setForm` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2922 |
| JS 함수 정의 | `fn_ZWEB_COMMON_GET_LOGIN_INFO` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2997 |
| JS 함수 정의 | `fn_callBackZWEB_COMMON_GET_LOGIN_INFO` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3006 |
| JS 함수 정의 | `fn_ZEP_SEARCH_ENAME` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3035 |
| JS 함수 정의 | `fn_setEnameList` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3063 |
| JS 함수 정의 | `fn_ZEP_SEARCH_ENAME1` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3107 |
| JS 함수 정의 | `fn_setEnameList1` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3117 |
| JS 함수 정의 | `fn_setEname` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3146 |
| JS 함수 정의 | `callBackApprChk` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3159 |
| JS 함수 정의 | `fn_setButton` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3178 |
| JS 함수 정의 | `numberWithCommas` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3207 |
| JS 함수 정의 | `onlyNumber` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3212 |
| JS 함수 정의 | `removeChar` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3221 |
| JS 함수 정의 | `fn_timeLimit` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3232 |
| JS 함수 정의 | `lfn_getEnameLayerHtml` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3321 |
| JS 함수 정의 | `displayLayer` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3353 |
| JS 함수 정의 | `hideLayer` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3364 |
| JS 함수 정의 | `fn_cm1Toggle` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3368 |
| JS 함수 정의 | `fn_cm2Toggle` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3372 |
| JS 함수 정의 | `fn_cm3Toggle` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3376 |
| JS 함수 정의 | `fn_cm4Toggle` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3379 |
| JS 함수 정의 | `displayLayer4` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3383 |
| JS 함수 정의 | `hideLayer4` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3390 |
| JS 함수 정의 | `displayLayer1` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3393 |
| JS 함수 정의 | `hideLayer1` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3402 |
| JS 함수 정의 | `displayLayer2` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3406 |
| JS 함수 정의 | `hideLayer2` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3415 |
| JS 함수 정의 | `displayLayer3` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3419 |
| JS 함수 정의 | `hideLayer3` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3428 |
| JS 함수 정의 | `fn_agreement` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3432 |
| JS 함수 정의 | `fn_change` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3449 |
| JS 함수 정의 | `fn_iam` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3458 |
| JS 함수 정의 | `fnPdfDown` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3466 |
| JS 함수 정의 | `gShowWindow` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3470 |
| HTML 이벤트 바인딩 | `fn_checkZTOMOH();` → 같은 Layout 함수 정의 L1184 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L236 |
| HTML 이벤트 바인딩 | `fn_checkZDAEH();` → 같은 Layout 함수 정의 L1195 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L240 |
| HTML 이벤트 바인딩 | `fn_checkZEMCWK();` → 같은 Layout 함수 정의 L1207 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L248 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L2642 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L338 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L2642 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L426 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L2642 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L426 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L2642 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L514 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L2642 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L514 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L2642 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L602 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L2642 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L602 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L2642 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L690 |
| HTML 이벤트 바인딩 | `fn_change();` → 같은 Layout 함수 정의 L3449 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L706 |
| HTML 이벤트 바인딩 | `fn_ZEP_SEARCH_ENAME();` → 같은 Layout 함수 정의 L3035 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L741 |
| HTML 이벤트 바인딩 | `fn_ZEP_SEARCH_ENAME1();` → 같은 Layout 함수 정의 L3107 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3339 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZEP_SEARCH_ENAME](EXTERNAL_DEPENDENCIES.md#ZEP_SEARCH_ENAME) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3056, 3110 |
| [ZHR_52TM_CALC_BREAK_TIME](ZHR_52TM_CALC_BREAK_TIME.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2033 |
| [ZHR_52TM_CALC_WORK_TIME_DAYILY](ZHR_52TM_CALC_WORK_TIME_DAYILY.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2169 |
| [ZHR_52TM_MOBILE_OVERTIME_APPR](ZHR_52TM_MOBILE_OVERTIME_APPR.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2868 |
| [ZHR_52TM_MOBILE_OVERTIME_CHANG](ZHR_52TM_MOBILE_OVERTIME_CHANG.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2815 |
| [ZHR_52TM_MOBILE_OVERTIME_CHECK](ZHR_52TM_MOBILE_OVERTIME_CHECK.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L1625, 2784 |
| [ZHR_52TM_MOBILE_OVERTIME_DETL](ZHR_52TM_MOBILE_OVERTIME_DETL.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L1250 |
| [ZMOBILE_OVERTIME_APPROR_CHECK](EXTERNAL_DEPENDENCIES.md#ZMOBILE_OVERTIME_APPROR_CHECK) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3150 |
| [ZWEB_COMMON_GET_LOGIN_INFO](EXT-ZWEB_COMMON_GET_LOGIN_INFO.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3001 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| — | 색인 내 정적 참조 없음; 미사용 근거 아님 | 동적 호출·외부 시스템은 미확인 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.

| 미확인 종류 | 참조·이름 | 근거 |
|---|---|---|
| 외부 웹 파일 | `../zweb_common/server_util2.ssjs` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2 |
| 웹 중계 의존 | `../zweb_common/server_util2.ssjs` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L1256 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L1634 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2037 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2172 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2794 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2821 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2874 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3003 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3060 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3114 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L3156 |

정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
