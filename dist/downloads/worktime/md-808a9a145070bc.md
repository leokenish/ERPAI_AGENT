---
title: "MDAILY_WORK_DETAIL_new — [모바일] 선택근로-일일실적 조회"
as_of: 2026-10-07
review_status: pending_business_review
tags: [선택근무]
---

# MDAILY_WORK_DETAIL_new — [모바일] 선택근로-일일실적 조회

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **BSP 화면·스크립트**. 설명: [모바일] 선택근로-일일실적 조회.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) | 1598행; 원본 보존 |
| [../Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Page%20Attributes.xml) | 12행; 원본 보존 |
| [../Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Properties.xml) | 45행; 원본 보존 |
| [../Type Definitions.abap](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Type%20Definitions.abap) | 0행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Properties.xml) L18 | IMPLCLASS=CL_O24EVJEZSSRCX3WA9FICRPPUI48; 생성 클래스 본문/실행 미확인 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Properties.xml) L39 | VERSION=A; metadata이며 운영 사용 증거 아님 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Properties.xml) L35 | IS_START_PAGE=빈값; metadata이며 운영 사용 증거 아님 |
| 페이지 매개변수 정의 | [Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Page%20Attributes.xml) L10 | PAGE_ATTRIBUTES 항목 0개. 웹 요청 데이터는 Layout JavaScript와 함수 인터페이스에서 별도로 확인 |

### 화면 이벤트와 JavaScript

Layout의 인라인 JavaScript를 함께 색인했다. onClick/onChange는 화면 이벤트, Event Handler ABAP는 서버 이벤트이며 서로 동일하지 않다. 구형·new·bak 명칭만으로 운영 사용 여부를 결정하지 않는다.

| 구분 | 이름·식 | 원본 위치 |
|---|---|---|
| JS 함수 정의 | `fn_ZWEB_COMMON_GET_LOGIN_INFO` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L66 |
| JS 함수 정의 | `fn_callBackZWEB_COMMON_GET_LOGIN_INFO` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L73 |
| JS 함수 정의 | `fn_init` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L82 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_CHECK_DATA` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L91 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_CHECK_DATA` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L114 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_GET_DATA` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L144 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_GET_DATA` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L167 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_PROCESS_DATA` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L253 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_PROCESS_DATA` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L280 |
| JS 함수 정의 | `fnWorkChange` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L471 |
| JS 함수 정의 | `fnChange` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L479 |
| JS 함수 정의 | `fn_checkTDCOST` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L496 |
| JS 함수 정의 | `fn_checkZOVRNGT` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L505 |
| JS 함수 정의 | `fnValidation` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L514 |
| JS 함수 정의 | `fnMakeData` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L598 |
| JS 함수 정의 | `fn_checkZTOICH` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L640 |
| JS 함수 정의 | `callCalendar` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L648 |
| JS 함수 정의 | `fn_formatDay` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L651 |
| JS 함수 정의 | `fn_ename_close` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L666 |
| JS 함수 정의 | `fn_ZEP_SEARCH_ENAME` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L671 |
| JS 함수 정의 | `fn_setEnameList` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L695 |
| JS 함수 정의 | `fn_ZEP_SEARCH_ENAME1` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L722 |
| JS 함수 정의 | `fn_ZEP_SEARCH_ENAME1` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L731 |
| JS 함수 정의 | `fn_setEname` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L740 |
| JS 함수 정의 | `callBackApprChk` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L758 |
| JS 함수 정의 | `numberWithCommas` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L778 |
| JS 함수 정의 | `onlyNumber` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L783 |
| JS 함수 정의 | `removeChar` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L790 |
| JS 함수 정의 | `fn_timeLimit` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L800 |
| JS 함수 정의 | `fn_approval` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L888 |
| JS 함수 정의 | `fn_cancel` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L907 |
| JS 함수 정의 | `fn_setButton` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L915 |
| JS 함수 정의 | `fn_disInit` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L944 |
| JS 함수 정의 | `fn_addBreakDiv` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L955 |
| JS 함수 정의 | `fn_modify` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L989 |
| JS 함수 정의 | `fn_checkZEMCWK` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L995 |
| HTML 이벤트 바인딩 | `fn_setEname(` → 같은 Layout 함수 정의 L740 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L704 |
| HTML 이벤트 바인딩 | `fn_approval(` → 같은 Layout 함수 정의 L888 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L920 |
| HTML 이벤트 바인딩 | `fn_modify();` → 같은 Layout 함수 정의 L989 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L921 |
| HTML 이벤트 바인딩 | `fn_approval(` → 같은 Layout 함수 정의 L888 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L922 |
| HTML 이벤트 바인딩 | `fn_approval(` → 같은 Layout 함수 정의 L888 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L923 |
| HTML 이벤트 바인딩 | `fn_cancel();` → 같은 Layout 함수 정의 L907 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L924 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L471 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1145 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L471 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1173 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L471 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1180 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L471 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1209 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L471 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1215 |
| HTML 이벤트 바인딩 | `fn_checkTDCOST()` → 같은 Layout 함수 정의 L496 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1224 |
| HTML 이벤트 바인딩 | `fn_checkZTOICH()` → 같은 Layout 함수 정의 L640 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1228 |
| HTML 이벤트 바인딩 | `fn_checkZEMCWK()` → 같은 Layout 함수 정의 L995 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1232 |
| HTML 이벤트 바인딩 | `fn_checkZOVRNGT()` → 같은 Layout 함수 정의 L505 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1236 |
| HTML 이벤트 바인딩 | `fn_checkZNOWK()` → 함수 정의/실행 대상 추가 확인 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1240 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L479 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1254 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L479 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1282 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L479 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1288 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L479 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1294 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L479 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1323 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L479 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1329 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L479 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1342 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L479 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1370 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L479 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1376 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L479 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1382 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L479 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1411 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L479 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1417 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L479 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1430 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L479 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1458 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L479 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1464 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L479 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1470 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L479 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1499 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L479 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1505 |
| HTML 이벤트 바인딩 | `fn_cancel();` → 같은 Layout 함수 정의 L907 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1552 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZEP_SEARCH_ENAME](EXTERNAL_DEPENDENCIES.md#ZEP_SEARCH_ENAME) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L688, 724, 733 |
| [ZHR_52TM_CW_CHECK_DATA](ZHR_52TM_CW_CHECK_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L106 |
| [ZHR_52TM_CW_GET_DATA](ZHR_52TM_CW_GET_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L157 |
| [ZHR_52TM_CW_PROCESS_DATA](ZHR_52TM_CW_PROCESS_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L268 |
| [ZWEB_COMMON_GET_LOGIN_INFO](EXT-ZWEB_COMMON_GET_LOGIN_INFO.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L68 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| — | 색인 내 정적 참조 없음; 미사용 근거 아님 | 동적 호출·외부 시스템은 미확인 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.

| 미확인 종류 | 참조·이름 | 근거 |
|---|---|---|
| 외부 웹 파일 | `../zmobile_common/server_util3.ssjs` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1 |
| 외부 웹 파일 | `https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.14.1/moment.min.js` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L14 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/jquery-1.8.0.min.js` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L15 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/ess_include.js` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L18 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/ess_common.js` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L19 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_common/json2.js` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L20 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_common/modernizr.js` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L21 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/bootstrap-datepicker.min.js` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L22 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/bootstrap-datepicker.ko.min.js` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L23 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/common_new.js` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1042 |
| 외부 웹 파일 | `/m001/js/cap.js` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1045 |
| 웹 중계 의존 | `../zmobile_common/server_util3.ssjs` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L1 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L70 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L112 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L165 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L276 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L692 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L728 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L737 |

정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
