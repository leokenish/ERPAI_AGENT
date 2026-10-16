---
title: "DAILY_WORK_DETAIL — [PC] 선택근로-일일실적 조회"
as_of: 2026-10-07
review_status: pending_business_review
tags: [선택근무]
---

# DAILY_WORK_DETAIL — [PC] 선택근로-일일실적 조회

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **BSP 화면·스크립트**. 설명: [PC] 선택근로-일일실적 조회.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) | 1908행; 원본 보존 |
| [../Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Page%20Attributes.xml) | 12행; 원본 보존 |
| [../Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Properties.xml) | 45행; 원본 보존 |
| [../Type Definitions.abap](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Type%20Definitions.abap) | 0행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Properties.xml) L18 | IMPLCLASS=CL_O25I14T7VTJ6G001XYU2HA88MK8; 생성 클래스 본문/실행 미확인 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Properties.xml) L39 | VERSION=A; metadata이며 운영 사용 증거 아님 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Properties.xml) L35 | IS_START_PAGE=빈값; metadata이며 운영 사용 증거 아님 |
| 페이지 매개변수 정의 | [Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Page%20Attributes.xml) L10 | PAGE_ATTRIBUTES 항목 0개. 웹 요청 데이터는 Layout JavaScript와 함수 인터페이스에서 별도로 확인 |

### 화면 이벤트와 JavaScript

Layout의 인라인 JavaScript를 함께 색인했다. onClick/onChange는 화면 이벤트, Event Handler ABAP는 서버 이벤트이며 서로 동일하지 않다. 구형·new·bak 명칭만으로 운영 사용 여부를 결정하지 않는다.

| 구분 | 이름·식 | 원본 위치 |
|---|---|---|
| JS 함수 정의 | `fn_ZWEB_COMMON_GET_LOGIN_INFO` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L566 |
| JS 함수 정의 | `fn_callBackZWEB_COMMON_GET_LOGIN_INFO` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L573 |
| JS 함수 정의 | `fn_init` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L586 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_CHECK_DATA` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L596 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_CHECK_DATA` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L618 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_GET_DATA` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L652 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_GET_DATA` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L675 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_PROCESS_DATA` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L779 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_PROCESS_DATA` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L808 |
| JS 함수 정의 | `fnWorkChange` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1039 |
| JS 함수 정의 | `fnChange` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1049 |
| JS 함수 정의 | `fn_checkTDCOST` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1072 |
| JS 함수 정의 | `fn_checkZOVRNGT` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1087 |
| JS 함수 정의 | `fnValidation` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1100 |
| JS 함수 정의 | `fnMakeData` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1188 |
| JS 함수 정의 | `fn_checkZTOICH` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1231 |
| JS 함수 정의 | `callCalendar` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1243 |
| JS 함수 정의 | `fn_formatDay` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1246 |
| JS 함수 정의 | `fn_ename_close` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1261 |
| JS 함수 정의 | `fn_ZEP_SEARCH_ENAME` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1267 |
| JS 함수 정의 | `fn_setEnameList` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1302 |
| JS 함수 정의 | `fn_ZEP_SEARCH_ENAME1` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1346 |
| JS 함수 정의 | `fn_setEnameList1` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1356 |
| JS 함수 정의 | `fn_setEname` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1384 |
| JS 함수 정의 | `callBackApprChk` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1403 |
| JS 함수 정의 | `numberWithCommas` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1422 |
| JS 함수 정의 | `onlyNumber` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1427 |
| JS 함수 정의 | `removeChar` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1436 |
| JS 함수 정의 | `fn_timeLimit` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1447 |
| JS 함수 정의 | `lfn_getEnameLayerHtml` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1536 |
| JS 함수 정의 | `displayLayer` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1568 |
| JS 함수 정의 | `hideLayer` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1581 |
| JS 함수 정의 | `displayLayer1` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1585 |
| JS 함수 정의 | `hideLayer1` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1594 |
| JS 함수 정의 | `displayLayer2` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1598 |
| JS 함수 정의 | `hideLayer2` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1608 |
| JS 함수 정의 | `displayLayer3` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1612 |
| JS 함수 정의 | `hideLayer3` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1621 |
| JS 함수 정의 | `fn_agreement` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1625 |
| JS 함수 정의 | `fn_change` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1642 |
| JS 함수 정의 | `fn_iam` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1651 |
| JS 함수 정의 | `fn_save` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1659 |
| JS 함수 정의 | `fn_approval` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1684 |
| JS 함수 정의 | `fn_cancel` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1711 |
| JS 함수 정의 | `fn_setButton` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1720 |
| JS 함수 정의 | `fn_disInit` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1744 |
| JS 함수 정의 | `fn_addBreakDiv` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1765 |
| JS 함수 정의 | `fn_modify` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1799 |
| JS 함수 정의 | `fn_checkZEMCWK` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1806 |
| JS 함수 정의 | `fn_cm1Toggle` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1813 |
| JS 함수 정의 | `fn_cm2Toggle` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1817 |
| JS 함수 정의 | `fn_cm3Toggle` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1821 |
| JS 함수 정의 | `displayLayer` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1826 |
| JS 함수 정의 | `hideLayer` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1840 |
| JS 함수 정의 | `displayLayer1` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1844 |
| JS 함수 정의 | `hideLayer1` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1853 |
| JS 함수 정의 | `displayLayer2` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1857 |
| JS 함수 정의 | `hideLayer2` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1867 |
| JS 함수 정의 | `displayLayer3` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1871 |
| JS 함수 정의 | `hideLayer3` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1880 |
| JS 함수 정의 | `fn_view` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1884 |
| JS 함수 정의 | `fn_hide` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1897 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1039 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L97 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1039 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L123 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1039 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L128 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1039 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L155 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1039 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L159 |
| HTML 이벤트 바인딩 | `fn_checkTDCOST();` → 같은 Layout 함수 정의 L1072 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L166 |
| HTML 이벤트 바인딩 | `fn_checkZTOICH();` → 같은 Layout 함수 정의 L1231 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L171 |
| HTML 이벤트 바인딩 | `fn_checkZEMCWK();` → 같은 Layout 함수 정의 L1806 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L175 |
| HTML 이벤트 바인딩 | `fn_checkZOVRNGT();` → 같은 Layout 함수 정의 L1087 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L178 |
| HTML 이벤트 바인딩 | `fn_checkZNOWK();` → 함수 정의/실행 대상 추가 확인 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L182 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1049 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L200 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1049 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L226 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1049 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L230 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1049 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L232 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1049 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L259 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1049 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L263 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1049 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L281 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1049 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L307 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1049 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L311 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1049 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L313 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1049 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L340 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1049 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L344 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1049 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L363 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1049 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L389 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1049 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L393 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1049 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L395 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1049 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L422 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1049 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L426 |
| HTML 이벤트 바인딩 | `fn_ZEP_SEARCH_ENAME1();` → 같은 Layout 함수 정의 L1346 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1554 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZEP_SEARCH_ENAME](EXTERNAL_DEPENDENCIES.md#ZEP_SEARCH_ENAME) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1295, 1348 |
| [ZHR_52TM_CW_CHECK_DATA](ZHR_52TM_CW_CHECK_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L610 |
| [ZHR_52TM_CW_GET_DATA](ZHR_52TM_CW_GET_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L665 |
| [ZHR_52TM_CW_PROCESS_DATA](ZHR_52TM_CW_PROCESS_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L795 |
| [ZWEB_COMMON_GET_LOGIN_INFO](EXT-ZWEB_COMMON_GET_LOGIN_INFO.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L568 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| — | 색인 내 정적 참조 없음; 미사용 근거 아님 | 동적 호출·외부 시스템은 미확인 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.

| 미확인 종류 | 참조·이름 | 근거 |
|---|---|---|
| 외부 웹 파일 | `../zweb_common/server_util2.ssjs` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L2 |
| 웹 중계 의존 | `../zweb_common/server_util2.ssjs` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L2 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L570 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L616 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L673 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L804 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1299 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L1352 |

정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
