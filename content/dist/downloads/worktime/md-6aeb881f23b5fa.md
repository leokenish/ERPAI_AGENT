---
title: "DAILY_WORK_INPUT_ADM — [PC] 선택근로-일일실적 입력(관리자)"
as_of: 2026-10-07
review_status: pending_business_review
tags: [선택근무, 퇴직자관리자입력검토]
---

# DAILY_WORK_INPUT_ADM — [PC] 선택근로-일일실적 입력(관리자)

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **BSP 화면·스크립트**. 설명: [PC] 선택근로-일일실적 입력(관리자).

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) | 2063행; 원본 보존 |
| [../Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Page%20Attributes.xml) | 12행; 원본 보존 |
| [../Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Properties.xml) | 45행; 원본 보존 |
| [../Type Definitions.abap](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Type%20Definitions.abap) | 0행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Properties.xml) L18 | IMPLCLASS=CL_O25IC1QP4YLDMJFS25SFMEBMNNC; 생성 클래스 본문/실행 미확인 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Properties.xml) L39 | VERSION=A; metadata이며 운영 사용 증거 아님 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Properties.xml) L35 | IS_START_PAGE=빈값; metadata이며 운영 사용 증거 아님 |
| 페이지 매개변수 정의 | [Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Page%20Attributes.xml) L10 | PAGE_ATTRIBUTES 항목 0개. 웹 요청 데이터는 Layout JavaScript와 함수 인터페이스에서 별도로 확인 |

### 화면 이벤트와 JavaScript

Layout의 인라인 JavaScript를 함께 색인했다. onClick/onChange는 화면 이벤트, Event Handler ABAP는 서버 이벤트이며 서로 동일하지 않다. 구형·new·bak 명칭만으로 운영 사용 여부를 결정하지 않는다.

| 구분 | 이름·식 | 원본 위치 |
|---|---|---|
| JS 함수 정의 | `fn_ZWEB_COMMON_GET_LOGIN_INFO` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L632 |
| JS 함수 정의 | `fn_callBackZWEB_COMMON_GET_LOGIN_INFO` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L640 |
| JS 함수 정의 | `fn_ZWEB_CHECK_ACCESS` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L659 |
| JS 함수 정의 | `fn_callbackZWEB_CHECK_ACCESS` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L668 |
| JS 함수 정의 | `fn_ZHR_GET_PERSONNEL_BASIC_INFO` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L680 |
| JS 함수 정의 | `fn_callbackZHR_GET_PERSONNEL_BASIC_INFO` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L689 |
| JS 함수 정의 | `fn_init` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L700 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_CHECK_DATA` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L713 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_CHECK_DATA` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L735 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_GET_DATA` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L790 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_GET_DATA` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L813 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_PROCESS_DATA` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L926 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_PROCESS_DATA` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L950 |
| JS 함수 정의 | `fnWorkChange` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1150 |
| JS 함수 정의 | `fnBreakeTimeReset` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1162 |
| JS 함수 정의 | `fnChange` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1188 |
| JS 함수 정의 | `fn_checkTDCOST` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1211 |
| JS 함수 정의 | `fn_checkZOVRNGT` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1225 |
| JS 함수 정의 | `fn_checkZNOWK` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1240 |
| JS 함수 정의 | `fnValidation` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1317 |
| JS 함수 정의 | `fnValidation2` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1407 |
| JS 함수 정의 | `fnMakeData` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1464 |
| JS 함수 정의 | `fn_checkZTOICH` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1509 |
| JS 함수 정의 | `callCalendar` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1521 |
| JS 함수 정의 | `fn_formatDay` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1524 |
| JS 함수 정의 | `fn_ename_close` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1539 |
| JS 함수 정의 | `fn_ZEP_SEARCH_ENAME` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1545 |
| JS 함수 정의 | `fn_setEnameList` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1580 |
| JS 함수 정의 | `fn_ZEP_SEARCH_ENAME1` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1624 |
| JS 함수 정의 | `fn_setEnameList1` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1635 |
| JS 함수 정의 | `fn_setEname` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1663 |
| JS 함수 정의 | `callBackApprChk` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1685 |
| JS 함수 정의 | `numberWithCommas` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1704 |
| JS 함수 정의 | `onlyNumber` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1709 |
| JS 함수 정의 | `removeChar` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1718 |
| JS 함수 정의 | `fn_timeLimit` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1729 |
| JS 함수 정의 | `lfn_getEnameLayerHtml` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1818 |
| JS 함수 정의 | `displayLayer` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1842 |
| JS 함수 정의 | `hideLayer` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1855 |
| JS 함수 정의 | `displayLayer1` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1859 |
| JS 함수 정의 | `hideLayer1` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1868 |
| JS 함수 정의 | `displayLayer2` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1872 |
| JS 함수 정의 | `hideLayer2` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1882 |
| JS 함수 정의 | `displayLayer3` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1886 |
| JS 함수 정의 | `hideLayer3` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1895 |
| JS 함수 정의 | `fn_agreement` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1899 |
| JS 함수 정의 | `fn_change` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1912 |
| JS 함수 정의 | `fn_iam` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1930 |
| JS 함수 정의 | `fn_save` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1938 |
| JS 함수 정의 | `fn_approval` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1952 |
| JS 함수 정의 | `fn_cancel` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1966 |
| JS 함수 정의 | `fn_checkZEMCWK` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1973 |
| JS 함수 정의 | `fn_cm1Toggle` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1980 |
| JS 함수 정의 | `fn_cm2Toggle` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1984 |
| JS 함수 정의 | `displayLayer` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1989 |
| JS 함수 정의 | `hideLayer` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L2003 |
| JS 함수 정의 | `displayLayer1` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L2007 |
| JS 함수 정의 | `hideLayer1` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L2016 |
| JS 함수 정의 | `displayLayer2` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L2020 |
| JS 함수 정의 | `hideLayer2` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L2030 |
| JS 함수 정의 | `fn_view` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L2034 |
| JS 함수 정의 | `fn_hide` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L2047 |
| JS 함수 정의 | `fn_gohome` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L2051 |
| HTML 이벤트 바인딩 | `fn_gohome();` → 같은 Layout 함수 정의 L2051 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L46 |
| HTML 이벤트 바인딩 | `callCalendar();` → 같은 Layout 함수 정의 L1521 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L79 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1150 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L101 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1150 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L127 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1150 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L132 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1150 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L159 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L1150 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L163 |
| HTML 이벤트 바인딩 | `fn_checkTDCOST();` → 같은 Layout 함수 정의 L1211 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L170 |
| HTML 이벤트 바인딩 | `fn_checkZTOICH();` → 같은 Layout 함수 정의 L1509 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L175 |
| HTML 이벤트 바인딩 | `fn_checkZEMCWK();` → 같은 Layout 함수 정의 L1973 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L179 |
| HTML 이벤트 바인딩 | `fn_checkZOVRNGT();` → 같은 Layout 함수 정의 L1225 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L184 |
| HTML 이벤트 바인딩 | `fn_checkZNOWK();` → 같은 Layout 함수 정의 L1240 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L188 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1188 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L209 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1188 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L236 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1188 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L240 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1188 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L244 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1188 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L272 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L1188 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L276 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 함수 정의/실행 대상 추가 확인 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L280 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1188 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L298 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1188 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L325 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1188 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L329 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1188 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L333 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1188 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L361 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L1188 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L365 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 함수 정의/실행 대상 추가 확인 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L369 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 함수 정의/실행 대상 추가 확인 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L370 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1188 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L388 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1188 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L415 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1188 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L419 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1188 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L423 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1188 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L450 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L1188 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L454 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 함수 정의/실행 대상 추가 확인 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L458 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 함수 정의/실행 대상 추가 확인 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L459 |
| HTML 이벤트 바인딩 | `fn_change();` → 같은 Layout 함수 정의 L1912 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L476 |
| HTML 이벤트 바인딩 | `fn_ZEP_SEARCH_ENAME();` → 같은 Layout 함수 정의 L1545 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L496 |
| HTML 이벤트 바인딩 | `fn_approval(` → 같은 Layout 함수 정의 L1952 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L505 |
| HTML 이벤트 바인딩 | `fn_save();` → 같은 Layout 함수 정의 L1938 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L506 |
| HTML 이벤트 바인딩 | `fn_cancel();` → 같은 Layout 함수 정의 L1966 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L507 |
| HTML 이벤트 바인딩 | `fn_ZEP_SEARCH_ENAME1();` → 같은 Layout 함수 정의 L1624 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1829 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZEP_SEARCH_ENAME](EXTERNAL_DEPENDENCIES.md#ZEP_SEARCH_ENAME) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1573, 1627 |
| [ZHR_52TM_CW_CHECK_DATA](ZHR_52TM_CW_CHECK_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L726 |
| [ZHR_52TM_CW_GET_DATA](ZHR_52TM_CW_GET_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L803 |
| [ZHR_52TM_CW_PROCESS_DATA2](ZHR_52TM_CW_PROCESS_DATA2.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L939 |
| [ZHR_GET_PERSONNEL_BASIC_INFO](EXTERNAL_DEPENDENCIES.md#ZHR_GET_PERSONNEL_BASIC_INFO) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L682 |
| [ZWEB_CHECK_ACCESS](EXTERNAL_DEPENDENCIES.md#ZWEB_CHECK_ACCESS) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L662 |
| [ZWEB_COMMON_GET_LOGIN_INFO](EXT-ZWEB_COMMON_GET_LOGIN_INFO.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L635 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| — | 색인 내 정적 참조 없음; 미사용 근거 아님 | 동적 호출·외부 시스템은 미확인 |

### 관련 업무와 미확인 범위

- [retired](../topics/retired.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [selective](../topics/selective.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.

| 미확인 종류 | 참조·이름 | 근거 |
|---|---|---|
| 외부 웹 파일 | `../zweb_common/server_util2.ssjs` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L2 |
| 웹 중계 의존 | `../zweb_common/server_util2.ssjs` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L2 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L637 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L666 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L687 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L732 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L809 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L946 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1577 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_WORK_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) L1631 |

정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
