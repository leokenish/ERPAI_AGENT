---
title: "MDAILY_WORK_DETAIL — [모바일] 선택근로-일일실적 조회"
as_of: 2026-10-07
review_status: pending_business_review
tags: [선택근무]
---

# MDAILY_WORK_DETAIL — [모바일] 선택근로-일일실적 조회

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **BSP 화면·스크립트**. 설명: [모바일] 선택근로-일일실적 조회.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) | 1916행; 원본 보존 |
| [../Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Page%20Attributes.xml) | 12행; 원본 보존 |
| [../Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Properties.xml) | 45행; 원본 보존 |
| [../Type Definitions.abap](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Type%20Definitions.abap) | 0행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Properties.xml) L18 | IMPLCLASS=CL_O25I799DR22HRVY0G562ZBWO9X4; 생성 클래스 본문/실행 미확인 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Properties.xml) L39 | VERSION=A; metadata이며 운영 사용 증거 아님 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Properties.xml) L35 | IS_START_PAGE=빈값; metadata이며 운영 사용 증거 아님 |
| 페이지 매개변수 정의 | [Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Page%20Attributes.xml) L10 | PAGE_ATTRIBUTES 항목 0개. 웹 요청 데이터는 Layout JavaScript와 함수 인터페이스에서 별도로 확인 |

### 화면 이벤트와 JavaScript

Layout의 인라인 JavaScript를 함께 색인했다. onClick/onChange는 화면 이벤트, Event Handler ABAP는 서버 이벤트이며 서로 동일하지 않다. 구형·new·bak 명칭만으로 운영 사용 여부를 결정하지 않는다.

| 구분 | 이름·식 | 원본 위치 |
|---|---|---|
| JS 함수 정의 | `fn_ZWEB_COMMON_GET_LOGIN_INFO` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L597 |
| JS 함수 정의 | `fn_callBackZWEB_COMMON_GET_LOGIN_INFO` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L604 |
| JS 함수 정의 | `fn_init` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L613 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_CHECK_DATA` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L623 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_CHECK_DATA` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L645 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_GET_DATA` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L679 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_GET_DATA` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L702 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_PROCESS_DATA` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L806 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_PROCESS_DATA` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L834 |
| JS 함수 정의 | `fnWorkChange` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1048 |
| JS 함수 정의 | `fnChange` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1058 |
| JS 함수 정의 | `fn_checkTDCOST` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1080 |
| JS 함수 정의 | `fn_checkZOVRNGT` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1096 |
| JS 함수 정의 | `fnValidation` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1109 |
| JS 함수 정의 | `fnMakeData` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1197 |
| JS 함수 정의 | `fn_checkZTOICH` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1240 |
| JS 함수 정의 | `callCalendar` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1252 |
| JS 함수 정의 | `fn_formatDay` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1255 |
| JS 함수 정의 | `fn_ename_close` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1270 |
| JS 함수 정의 | `fn_ZEP_SEARCH_ENAME` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1276 |
| JS 함수 정의 | `fn_setEnameList` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1311 |
| JS 함수 정의 | `fn_ZEP_SEARCH_ENAME1` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1355 |
| JS 함수 정의 | `fn_setEnameList1` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1365 |
| JS 함수 정의 | `fn_setEname` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1393 |
| JS 함수 정의 | `callBackApprChk` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1412 |
| JS 함수 정의 | `numberWithCommas` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1431 |
| JS 함수 정의 | `onlyNumber` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1436 |
| JS 함수 정의 | `removeChar` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1445 |
| JS 함수 정의 | `fn_timeLimit` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1456 |
| JS 함수 정의 | `lfn_getEnameLayerHtml` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1545 |
| JS 함수 정의 | `displayLayer` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1577 |
| JS 함수 정의 | `hideLayer` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1590 |
| JS 함수 정의 | `displayLayer1` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1594 |
| JS 함수 정의 | `hideLayer1` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1603 |
| JS 함수 정의 | `displayLayer2` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1607 |
| JS 함수 정의 | `hideLayer2` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1617 |
| JS 함수 정의 | `displayLayer3` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1621 |
| JS 함수 정의 | `hideLayer3` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1631 |
| JS 함수 정의 | `fn_agreement` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1635 |
| JS 함수 정의 | `fn_change` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1652 |
| JS 함수 정의 | `fn_iam` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1661 |
| JS 함수 정의 | `fn_save` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1669 |
| JS 함수 정의 | `fn_approval` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1694 |
| JS 함수 정의 | `fn_cancel` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1721 |
| JS 함수 정의 | `fn_setButton` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1730 |
| JS 함수 정의 | `fn_disInit` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1754 |
| JS 함수 정의 | `fn_addBreakDiv` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1775 |
| JS 함수 정의 | `fn_modify` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1809 |
| JS 함수 정의 | `fn_checkZEMCWK` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1816 |
| JS 함수 정의 | `fn_cm1Toggle` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1823 |
| JS 함수 정의 | `fn_cm2Toggle` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1827 |
| JS 함수 정의 | `fn_cm3Toggle` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1831 |
| JS 함수 정의 | `displayLayer` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1836 |
| JS 함수 정의 | `hideLayer` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1850 |
| JS 함수 정의 | `displayLayer1` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1854 |
| JS 함수 정의 | `hideLayer1` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1863 |
| JS 함수 정의 | `displayLayer2` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1867 |
| JS 함수 정의 | `hideLayer2` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1877 |
| JS 함수 정의 | `displayLayer3` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1881 |
| JS 함수 정의 | `hideLayer3` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1891 |
| JS 함수 정의 | `fn_view` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1895 |
| JS 함수 정의 | `fn_hide` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1908 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1048 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L142 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1048 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L168 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1048 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L173 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1048 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L200 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1048 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L204 |
| HTML 이벤트 바인딩 | `fn_checkTDCOST();` → 같은 Layout 함수 정의 L1080 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L212 |
| HTML 이벤트 바인딩 | `fn_checkZTOICH();` → 같은 Layout 함수 정의 L1240 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L216 |
| HTML 이벤트 바인딩 | `fn_checkZEMCWK();` → 같은 Layout 함수 정의 L1816 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L220 |
| HTML 이벤트 바인딩 | `fn_checkZOVRNGT();` → 같은 Layout 함수 정의 L1096 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L223 |
| HTML 이벤트 바인딩 | `fn_checkZNOWK();` → 함수 정의/실행 대상 추가 확인 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L228 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1058 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L241 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1058 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L267 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1058 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L271 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1058 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L273 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1058 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L300 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1058 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L304 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1058 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L315 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1058 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L342 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1058 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L346 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1058 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L348 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1058 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L375 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1058 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L379 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1058 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L390 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1058 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L416 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1058 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L420 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1058 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L422 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1058 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L449 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1058 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L453 |
| HTML 이벤트 바인딩 | `fn_ZEP_SEARCH_ENAME1();` → 같은 Layout 함수 정의 L1355 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1563 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZEP_SEARCH_ENAME](EXTERNAL_DEPENDENCIES.md#ZEP_SEARCH_ENAME) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1304, 1357 |
| [ZHR_52TM_CW_CHECK_DATA](ZHR_52TM_CW_CHECK_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L637 |
| [ZHR_52TM_CW_GET_DATA](ZHR_52TM_CW_GET_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L692 |
| [ZHR_52TM_CW_PROCESS_DATA](ZHR_52TM_CW_PROCESS_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L822 |
| [ZWEB_COMMON_GET_LOGIN_INFO](EXT-ZWEB_COMMON_GET_LOGIN_INFO.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L599 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| — | 색인 내 정적 참조 없음; 미사용 근거 아님 | 동적 호출·외부 시스템은 미확인 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.

| 미확인 종류 | 참조·이름 | 근거 |
|---|---|---|
| 외부 웹 파일 | `../zmobile_common/server_util3.ssjs` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L2 |
| 웹 중계 의존 | `../zmobile_common/server_util3.ssjs` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L2 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L601 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L643 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L700 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L830 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1308 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L1361 |

정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
