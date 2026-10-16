---
title: "DAILY_WORK_DETAIL_ADM — [PC] 선택근로-일일실적 조회(관리자)"
as_of: 2026-10-07
review_status: pending_business_review
tags: [선택근무]
---

# DAILY_WORK_DETAIL_ADM — [PC] 선택근로-일일실적 조회(관리자)

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **BSP 화면·스크립트**. 설명: [PC] 선택근로-일일실적 조회(관리자).

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) | 1948행; 원본 보존 |
| [../Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Page%20Attributes.xml) | 12행; 원본 보존 |
| [../Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Properties.xml) | 45행; 원본 보존 |
| [../Type Definitions.abap](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Type%20Definitions.abap) | 0행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Properties.xml) L18 | IMPLCLASS=CL_O25IC1QMKS9UE189KRUEUAYZ320; 생성 클래스 본문/실행 미확인 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Properties.xml) L39 | VERSION=A; metadata이며 운영 사용 증거 아님 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Properties.xml) L35 | IS_START_PAGE=빈값; metadata이며 운영 사용 증거 아님 |
| 페이지 매개변수 정의 | [Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Page%20Attributes.xml) L10 | PAGE_ATTRIBUTES 항목 0개. 웹 요청 데이터는 Layout JavaScript와 함수 인터페이스에서 별도로 확인 |

### 화면 이벤트와 JavaScript

Layout의 인라인 JavaScript를 함께 색인했다. onClick/onChange는 화면 이벤트, Event Handler ABAP는 서버 이벤트이며 서로 동일하지 않다. 구형·new·bak 명칭만으로 운영 사용 여부를 결정하지 않는다.

| 구분 | 이름·식 | 원본 위치 |
|---|---|---|
| JS 함수 정의 | `fn_ZWEB_COMMON_GET_LOGIN_INFO` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L561 |
| JS 함수 정의 | `fn_callBackZWEB_COMMON_GET_LOGIN_INFO` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L569 |
| JS 함수 정의 | `fn_ZWEB_CHECK_ACCESS` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L587 |
| JS 함수 정의 | `fn_callbackZWEB_CHECK_ACCESS` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L596 |
| JS 함수 정의 | `fn_ZHR_GET_PERSONNEL_BASIC_INFO` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L608 |
| JS 함수 정의 | `fn_callbackZHR_GET_PERSONNEL_BASIC_INFO` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L617 |
| JS 함수 정의 | `fn_init` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L625 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_CHECK_DATA` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L635 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_CHECK_DATA` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L657 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_GET_DATA` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L691 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_GET_DATA` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L714 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_PROCESS_DATA` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L819 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_PROCESS_DATA` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L847 |
| JS 함수 정의 | `fnWorkChange` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1075 |
| JS 함수 정의 | `fnChange` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1085 |
| JS 함수 정의 | `fn_checkTDCOST` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1108 |
| JS 함수 정의 | `fn_checkZOVRNGT` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1123 |
| JS 함수 정의 | `fnValidation` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1136 |
| JS 함수 정의 | `fnMakeData` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1224 |
| JS 함수 정의 | `fn_checkZTOICH` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1267 |
| JS 함수 정의 | `callCalendar` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1279 |
| JS 함수 정의 | `fn_formatDay` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1282 |
| JS 함수 정의 | `fn_ename_close` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1297 |
| JS 함수 정의 | `fn_ZEP_SEARCH_ENAME` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1303 |
| JS 함수 정의 | `fn_setEnameList` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1338 |
| JS 함수 정의 | `fn_ZEP_SEARCH_ENAME1` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1382 |
| JS 함수 정의 | `fn_setEnameList1` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1392 |
| JS 함수 정의 | `fn_setEname` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1420 |
| JS 함수 정의 | `callBackApprChk` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1439 |
| JS 함수 정의 | `numberWithCommas` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1458 |
| JS 함수 정의 | `onlyNumber` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1463 |
| JS 함수 정의 | `removeChar` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1472 |
| JS 함수 정의 | `fn_timeLimit` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1483 |
| JS 함수 정의 | `lfn_getEnameLayerHtml` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1572 |
| JS 함수 정의 | `displayLayer` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1604 |
| JS 함수 정의 | `hideLayer` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1617 |
| JS 함수 정의 | `displayLayer1` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1621 |
| JS 함수 정의 | `hideLayer1` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1630 |
| JS 함수 정의 | `displayLayer2` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1634 |
| JS 함수 정의 | `hideLayer2` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1644 |
| JS 함수 정의 | `displayLayer3` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1648 |
| JS 함수 정의 | `hideLayer3` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1657 |
| JS 함수 정의 | `fn_agreement` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1661 |
| JS 함수 정의 | `fn_change` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1678 |
| JS 함수 정의 | `fn_iam` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1687 |
| JS 함수 정의 | `fn_save` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1695 |
| JS 함수 정의 | `fn_approval` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1720 |
| JS 함수 정의 | `fn_cancel` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1747 |
| JS 함수 정의 | `fn_setButton` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1754 |
| JS 함수 정의 | `fn_disInit` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1778 |
| JS 함수 정의 | `fn_addBreakDiv` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1799 |
| JS 함수 정의 | `fn_modify` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1833 |
| JS 함수 정의 | `fn_checkZEMCWK` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1841 |
| JS 함수 정의 | `fn_cm1Toggle` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1848 |
| JS 함수 정의 | `fn_cm2Toggle` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1852 |
| JS 함수 정의 | `fn_cm3Toggle` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1856 |
| JS 함수 정의 | `displayLayer` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1861 |
| JS 함수 정의 | `hideLayer` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1875 |
| JS 함수 정의 | `displayLayer1` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1879 |
| JS 함수 정의 | `hideLayer1` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1888 |
| JS 함수 정의 | `displayLayer2` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1892 |
| JS 함수 정의 | `hideLayer2` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1902 |
| JS 함수 정의 | `displayLayer3` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1906 |
| JS 함수 정의 | `hideLayer3` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1915 |
| JS 함수 정의 | `fn_view` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1919 |
| JS 함수 정의 | `fn_hide` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1932 |
| JS 함수 정의 | `fn_gohome` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1936 |
| HTML 이벤트 바인딩 | `fn_gohome();` → 같은 Layout 함수 정의 L1936 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L46 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1075 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L100 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1075 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L126 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1075 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L131 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1075 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L158 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1075 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L162 |
| HTML 이벤트 바인딩 | `fn_checkTDCOST();` → 같은 Layout 함수 정의 L1108 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L169 |
| HTML 이벤트 바인딩 | `fn_checkZTOICH();` → 같은 Layout 함수 정의 L1267 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L174 |
| HTML 이벤트 바인딩 | `fn_checkZEMCWK();` → 같은 Layout 함수 정의 L1841 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L178 |
| HTML 이벤트 바인딩 | `fn_checkZOVRNGT();` → 같은 Layout 함수 정의 L1123 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L181 |
| HTML 이벤트 바인딩 | `fn_checkZNOWK();` → 함수 정의/실행 대상 추가 확인 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L185 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1085 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L204 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1085 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L231 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1085 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L235 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1085 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L237 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1085 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L265 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1085 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L269 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1085 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L287 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1085 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L314 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1085 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L318 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1085 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L320 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1085 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L348 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1085 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L352 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1085 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L371 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1085 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L398 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1085 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L402 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1085 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L404 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1085 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L431 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1085 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L435 |
| HTML 이벤트 바인딩 | `fn_ZEP_SEARCH_ENAME1();` → 같은 Layout 함수 정의 L1382 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1590 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZEP_SEARCH_ENAME](EXTERNAL_DEPENDENCIES.md#ZEP_SEARCH_ENAME) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1331, 1384 |
| [ZHR_52TM_CW_CHECK_DATA](ZHR_52TM_CW_CHECK_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L649 |
| [ZHR_52TM_CW_GET_DATA](ZHR_52TM_CW_GET_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L704 |
| [ZHR_52TM_CW_PROCESS_DATA2](ZHR_52TM_CW_PROCESS_DATA2.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L835 |
| [ZHR_GET_PERSONNEL_BASIC_INFO](EXTERNAL_DEPENDENCIES.md#ZHR_GET_PERSONNEL_BASIC_INFO) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L610 |
| [ZWEB_CHECK_ACCESS](EXTERNAL_DEPENDENCIES.md#ZWEB_CHECK_ACCESS) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L590 |
| [ZWEB_COMMON_GET_LOGIN_INFO](EXT-ZWEB_COMMON_GET_LOGIN_INFO.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L564 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| — | 색인 내 정적 참조 없음; 미사용 근거 아님 | 동적 호출·외부 시스템은 미확인 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.

| 미확인 종류 | 참조·이름 | 근거 |
|---|---|---|
| 외부 웹 파일 | `../zweb_common/server_util2.ssjs` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L2 |
| 웹 중계 의존 | `../zweb_common/server_util2.ssjs` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L2 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L566 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L594 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L615 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L655 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L712 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L843 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1335 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_WORK_DETAIL_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL_ADM/Layout/DAILY_WORK_DETAIL_ADM.htm) L1388 |

정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
