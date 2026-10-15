---
title: "MDAILY_WORK_INPUT_new — [모바일] 선택근로-일일실적 입력"
as_of: 2026-10-07
review_status: pending_business_review
tags: [선택근무]
---

# MDAILY_WORK_INPUT_new — [모바일] 선택근로-일일실적 입력

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **BSP 화면·스크립트**. 설명: [모바일] 선택근로-일일실적 입력.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) | 1995행; 원본 보존 |
| [../Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Page%20Attributes.xml) | 12행; 원본 보존 |
| [../Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Properties.xml) | 45행; 원본 보존 |
| [../Type Definitions.abap](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Type%20Definitions.abap) | 0행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Properties.xml) L18 | IMPLCLASS=CL_O2BJP2B1OTEN75SJU9C9PYKI7UG; 생성 클래스 본문/실행 미확인 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Properties.xml) L39 | VERSION=A; metadata이며 운영 사용 증거 아님 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Properties.xml) L35 | IS_START_PAGE=빈값; metadata이며 운영 사용 증거 아님 |
| 페이지 매개변수 정의 | [Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Page%20Attributes.xml) L10 | PAGE_ATTRIBUTES 항목 0개. 웹 요청 데이터는 Layout JavaScript와 함수 인터페이스에서 별도로 확인 |

### 화면 이벤트와 JavaScript

Layout의 인라인 JavaScript를 함께 색인했다. onClick/onChange는 화면 이벤트, Event Handler ABAP는 서버 이벤트이며 서로 동일하지 않다. 구형·new·bak 명칭만으로 운영 사용 여부를 결정하지 않는다.

| 구분 | 이름·식 | 원본 위치 |
|---|---|---|
| JS 함수 정의 | `fn_ZWEB_COMMON_GET_LOGIN_INFO` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L60 |
| JS 함수 정의 | `fn_callBackZWEB_COMMON_GET_LOGIN_INFO` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L67 |
| JS 함수 정의 | `fn_init` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L76 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_CHECK_DATA` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L85 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_CHECK_DATA` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L105 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_GET_DATA` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L147 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_GET_DATA` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L171 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_PROCESS_DATA` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L267 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_PROCESS_DATA` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L290 |
| JS 함수 정의 | `fnWorkChange` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L477 |
| JS 함수 정의 | `fnBreakeTimeReset` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L486 |
| JS 함수 정의 | `fnChange` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L510 |
| JS 함수 정의 | `fn_checkTDCOST` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L528 |
| JS 함수 정의 | `fn_checkZOVRNGT` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L537 |
| JS 함수 정의 | `fn_checkZNOWK` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L548 |
| JS 함수 정의 | `fnValidation` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L619 |
| JS 함수 정의 | `fnValidation2` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L704 |
| JS 함수 정의 | `fnMakeData` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L751 |
| JS 함수 정의 | `fn_checkZTOICH` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L795 |
| JS 함수 정의 | `fn_formatDay` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L802 |
| JS 함수 정의 | `fn_ZEP_SEARCH_ENAME` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L818 |
| JS 함수 정의 | `fn_setEnameList` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L842 |
| JS 함수 정의 | `fn_ZEP_SEARCH_ENAME1` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L869 |
| JS 함수 정의 | `fn_setEname` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L878 |
| JS 함수 정의 | `callBackApprChk` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L898 |
| JS 함수 정의 | `numberWithCommas` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L917 |
| JS 함수 정의 | `onlyNumber` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L922 |
| JS 함수 정의 | `removeChar` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L929 |
| JS 함수 정의 | `fn_timeLimit` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L939 |
| JS 함수 정의 | `fn_agreement` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1034 |
| JS 함수 정의 | `fn_save` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1063 |
| JS 함수 정의 | `fn_approval` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1076 |
| JS 함수 정의 | `fn_cancel` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1087 |
| JS 함수 정의 | `fn_checkZEMCWK` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1095 |
| JS 함수 정의 | `fn_addBreakDiv` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1104 |
| JS 함수 정의 | `fn_ZHR_52TM_IAM` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1178 |
| JS 함수 정의 | `fn_callbackZHR_52TM_IAM_LIST` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1189 |
| JS 함수 정의 | `fn_iamSelect` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1223 |
| HTML 이벤트 바인딩 | `fn_setEname(` → 같은 Layout 함수 정의 L878 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L851 |
| HTML 이벤트 바인딩 | `fn_iamSelect(` → 같은 Layout 함수 정의 L1223 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1204 |
| HTML 이벤트 바인딩 | `fn_openIamLayer()` → 함수 정의/실행 대상 추가 확인 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1403 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L477 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1425 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L477 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1453 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L477 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1460 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L477 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1489 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L477 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1495 |
| HTML 이벤트 바인딩 | `fn_checkTDCOST()` → 같은 Layout 함수 정의 L528 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1504 |
| HTML 이벤트 바인딩 | `fn_checkZTOICH()` → 같은 Layout 함수 정의 L795 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1508 |
| HTML 이벤트 바인딩 | `fn_checkZEMCWK()` → 같은 Layout 함수 정의 L1095 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1512 |
| HTML 이벤트 바인딩 | `fn_checkZOVRNGT()` → 같은 Layout 함수 정의 L537 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1516 |
| HTML 이벤트 바인딩 | `fn_checkZNOWK()` → 같은 Layout 함수 정의 L548 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1520 |
| HTML 이벤트 바인딩 | `fn_openBreaktimeLayer()` → 함수 정의/실행 대상 추가 확인 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1544 |
| HTML 이벤트 바인딩 | `fn_ZEP_SEARCH_ENAME()` → 같은 Layout 함수 정의 L818 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1564 |
| HTML 이벤트 바인딩 | `fn_approval(` → 같은 Layout 함수 정의 L1076 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1570 |
| HTML 이벤트 바인딩 | `fn_save()` → 같은 Layout 함수 정의 L1063 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1571 |
| HTML 이벤트 바인딩 | `fn_cancel()` → 같은 Layout 함수 정의 L1087 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1572 |
| HTML 이벤트 바인딩 | `fn_ZEP_SEARCH_ENAME1()` → 같은 Layout 함수 정의 L869 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1662 |
| HTML 이벤트 바인딩 | `fn_agreement(` → 같은 Layout 함수 정의 L1034 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1688 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L510 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1709 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L510 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1737 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L510 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1743 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L510 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1749 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L510 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1778 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L510 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1784 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L1104 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1789 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L510 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1801 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L510 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1829 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L510 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1835 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L510 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1841 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L510 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1870 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L510 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1876 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L1104 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1881 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L1104 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1882 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L510 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1894 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L510 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1922 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L510 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1928 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L510 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1934 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L510 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1963 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L510 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1969 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L1104 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1974 |
| HTML 이벤트 바인딩 | `fn_closeBreaktimeLayer()` → 함수 정의/실행 대상 추가 확인 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1987 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZEP_SEARCH_ENAME](EXTERNAL_DEPENDENCIES.md#ZEP_SEARCH_ENAME) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L835, 871 |
| [ZHR_52TM_CW_CHECK_DATA](ZHR_52TM_CW_CHECK_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L97 |
| [ZHR_52TM_CW_GET_DATA](ZHR_52TM_CW_GET_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L160 |
| [ZHR_52TM_CW_PROCESS_DATA](ZHR_52TM_CW_PROCESS_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L278 |
| [ZHR_52TM_IAM](ZHR_52TM_IAM.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1181 |
| [ZWEB_COMMON_GET_LOGIN_INFO](EXT-ZWEB_COMMON_GET_LOGIN_INFO.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L62 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| — | 색인 내 정적 참조 없음; 미사용 근거 아님 | 동적 호출·외부 시스템은 미확인 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.

| 미확인 종류 | 참조·이름 | 근거 |
|---|---|---|
| 외부 웹 파일 | `../zmobile_common/server_util2.ssjs` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1 |
| 외부 웹 파일 | `https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.14.1/moment.min.js` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L14 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/jquery-1.8.0.min.js` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L15 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/ess_include.js` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L18 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/ess_common.js` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L19 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_common/json2.js` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L20 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_common/modernizr.js` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L21 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/bootstrap-datepicker.min.js` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L22 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/bootstrap-datepicker.ko.min.js` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L23 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/common_new.js` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1319 |
| 외부 웹 파일 | `/m001/js/cap.js` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1322 |
| 웹 중계 의존 | `../zmobile_common/server_util2.ssjs` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L64 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L103 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L167 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L286 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L839 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L875 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1185 |

정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
