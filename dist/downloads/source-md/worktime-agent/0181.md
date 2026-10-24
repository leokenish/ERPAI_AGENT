---
title: "MDAILY_WORK_MODIFY — [모바일] 선택근로-일일실적 수정"
as_of: 2026-10-07
review_status: pending_business_review
tags: [선택근무]
---

# MDAILY_WORK_MODIFY — [모바일] 선택근로-일일실적 수정

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **BSP 화면·스크립트**. 설명: [모바일] 선택근로-일일실적 수정.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) | 2351행; 원본 보존 |
| [../Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Page%20Attributes.xml) | 12행; 원본 보존 |
| [../Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Properties.xml) | 45행; 원본 보존 |
| [../Type Definitions.abap](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Type%20Definitions.abap) | 0행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Properties.xml) L18 | IMPLCLASS=CL_O25I799TJH1MEC8CFD5VSKKPMWO; 생성 클래스 본문/실행 미확인 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Properties.xml) L39 | VERSION=A; metadata이며 운영 사용 증거 아님 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Properties.xml) L35 | IS_START_PAGE=빈값; metadata이며 운영 사용 증거 아님 |
| 페이지 매개변수 정의 | [Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Page%20Attributes.xml) L10 | PAGE_ATTRIBUTES 항목 0개. 웹 요청 데이터는 Layout JavaScript와 함수 인터페이스에서 별도로 확인 |

### 화면 이벤트와 JavaScript

Layout의 인라인 JavaScript를 함께 색인했다. onClick/onChange는 화면 이벤트, Event Handler ABAP는 서버 이벤트이며 서로 동일하지 않다. 구형·new·bak 명칭만으로 운영 사용 여부를 결정하지 않는다.

| 구분 | 이름·식 | 원본 위치 |
|---|---|---|
| JS 함수 정의 | `fn_ZWEB_COMMON_GET_LOGIN_INFO` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L726 |
| JS 함수 정의 | `fn_callBackZWEB_COMMON_GET_LOGIN_INFO` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L733 |
| JS 함수 정의 | `fn_init` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L746 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_CHECK_DATA` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L756 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_CHECK_DATA` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L776 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_GET_DATA` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L818 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_GET_DATA` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L841 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_PROCESS_DATA` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L949 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_PROCESS_DATA` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L979 |
| JS 함수 정의 | `fnWorkChange` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1236 |
| JS 함수 정의 | `fnChange` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1246 |
| JS 함수 정의 | `fn_checkTDCOST` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1269 |
| JS 함수 정의 | `fn_checkZOVRNGT` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1284 |
| JS 함수 정의 | `fn_checkZNOWK` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1299 |
| JS 함수 정의 | `fnValidation` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1375 |
| JS 함수 정의 | `fnValidation2` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1464 |
| JS 함수 정의 | `fnMakeData` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1520 |
| JS 함수 정의 | `fn_checkZTOICH` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1565 |
| JS 함수 정의 | `callCalendar` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1577 |
| JS 함수 정의 | `fn_formatDay` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1580 |
| JS 함수 정의 | `fn_ename_close` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1595 |
| JS 함수 정의 | `fn_ZEP_SEARCH_ENAME` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1601 |
| JS 함수 정의 | `fn_setEnameList` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1636 |
| JS 함수 정의 | `fn_ZEP_SEARCH_ENAME1` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1680 |
| JS 함수 정의 | `fn_setEnameList1` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1691 |
| JS 함수 정의 | `fn_setEname` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1719 |
| JS 함수 정의 | `callBackApprChk` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1739 |
| JS 함수 정의 | `numberWithCommas` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1758 |
| JS 함수 정의 | `onlyNumber` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1763 |
| JS 함수 정의 | `removeChar` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1772 |
| JS 함수 정의 | `fn_timeLimit` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1783 |
| JS 함수 정의 | `lfn_getEnameLayerHtml` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1872 |
| JS 함수 정의 | `displayLayer` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1896 |
| JS 함수 정의 | `hideLayer` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1909 |
| JS 함수 정의 | `displayLayer1` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1913 |
| JS 함수 정의 | `hideLayer1` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1922 |
| JS 함수 정의 | `displayLayer2` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1926 |
| JS 함수 정의 | `hideLayer2` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1936 |
| JS 함수 정의 | `displayLayer3` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1940 |
| JS 함수 정의 | `hideLayer3` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1949 |
| JS 함수 정의 | `fn_agreement` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1953 |
| JS 함수 정의 | `fn_change` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1969 |
| JS 함수 정의 | `fn_iam` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1984 |
| JS 함수 정의 | `fn_save` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1989 |
| JS 함수 정의 | `fn_approval` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2004 |
| JS 함수 정의 | `fn_cancel` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2047 |
| JS 함수 정의 | `fn_setButton` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2056 |
| JS 함수 정의 | `fn_addBreakDiv` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2078 |
| JS 함수 정의 | `fn_checkZEMCWK` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2113 |
| JS 함수 정의 | `fn_cm1Toggle` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2120 |
| JS 함수 정의 | `fn_cm2Toggle` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2124 |
| JS 함수 정의 | `fn_cm3Toggle` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2128 |
| JS 함수 정의 | `displayLayer` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2133 |
| JS 함수 정의 | `hideLayer` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2147 |
| JS 함수 정의 | `displayLayer1` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2151 |
| JS 함수 정의 | `hideLayer1` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2160 |
| JS 함수 정의 | `displayLayer2` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2164 |
| JS 함수 정의 | `hideLayer2` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2174 |
| JS 함수 정의 | `displayLayer3` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2178 |
| JS 함수 정의 | `hideLayer3` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2187 |
| JS 함수 정의 | `fn_view` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2191 |
| JS 함수 정의 | `fn_hide` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2204 |
| JS 함수 정의 | `fn_ZHR_52TM_IAM` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2209 |
| JS 함수 정의 | `fn_callbackZHR_52TM_IAM_LIST` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2220 |
| JS 함수 정의 | `fn_iamSelect` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2259 |
| JS 함수 정의 | `iamDisplayLayer` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2334 |
| JS 함수 정의 | `iamHideLayer` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2343 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1236 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L145 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1236 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L171 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1236 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L176 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1236 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L203 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1236 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L207 |
| HTML 이벤트 바인딩 | `fn_checkTDCOST();` → 같은 Layout 함수 정의 L1269 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L215 |
| HTML 이벤트 바인딩 | `fn_checkZTOICH();` → 같은 Layout 함수 정의 L1565 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L219 |
| HTML 이벤트 바인딩 | `fn_checkZEMCWK();` → 같은 Layout 함수 정의 L2113 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L223 |
| HTML 이벤트 바인딩 | `fn_checkZOVRNGT();` → 같은 Layout 함수 정의 L1284 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L227 |
| HTML 이벤트 바인딩 | `fn_checkZNOWK();` → 같은 Layout 함수 정의 L1299 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L231 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1246 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L254 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1246 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L281 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1246 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L285 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1246 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L289 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1246 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L316 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1246 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L320 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L2078 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L324 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1246 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L342 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1246 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L369 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1246 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L373 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1246 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L377 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1246 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L404 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1246 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L408 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L2078 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L412 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L2078 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L413 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1246 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L431 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1246 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L458 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1246 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L462 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1246 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L466 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1246 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L493 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1246 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L497 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L2078 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L501 |
| HTML 이벤트 바인딩 | `fn_change();` → 같은 Layout 함수 정의 L1969 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L536 |
| HTML 이벤트 바인딩 | `fn_ZEP_SEARCH_ENAME();` → 같은 Layout 함수 정의 L1601 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L558 |
| HTML 이벤트 바인딩 | `fn_ZEP_SEARCH_ENAME1();` → 같은 Layout 함수 정의 L1680 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1883 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZEP_SEARCH_ENAME](EXTERNAL_DEPENDENCIES.md#ZEP_SEARCH_ENAME) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1629, 1683 |
| [ZHR_52TM_CW_CHECK_DATA](ZHR_52TM_CW_CHECK_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L768 |
| [ZHR_52TM_CW_GET_DATA](ZHR_52TM_CW_GET_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L831 |
| [ZHR_52TM_CW_PROCESS_DATA](ZHR_52TM_CW_PROCESS_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L969 |
| [ZHR_52TM_IAM](ZHR_52TM_IAM.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2212 |
| [ZWEB_COMMON_GET_LOGIN_INFO](EXT-ZWEB_COMMON_GET_LOGIN_INFO.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L728 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| — | 색인 내 정적 참조 없음; 미사용 근거 아님 | 동적 호출·외부 시스템은 미확인 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.

| 미확인 종류 | 참조·이름 | 근거 |
|---|---|---|
| 외부 웹 파일 | `../zmobile_common/server_util3.ssjs` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2 |
| 웹 중계 의존 | `../zmobile_common/server_util3.ssjs` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L730 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L774 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L839 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L976 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1633 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L1687 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2216 |

정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
