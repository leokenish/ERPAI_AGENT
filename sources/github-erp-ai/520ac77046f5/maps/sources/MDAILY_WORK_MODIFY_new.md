---
title: "MDAILY_WORK_MODIFY_new — [모바일] 선택근로-일일실적 수정"
as_of: 2026-10-07
review_status: pending_business_review
tags: [선택근무]
---

# MDAILY_WORK_MODIFY_new — [모바일] 선택근로-일일실적 수정

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **BSP 화면·스크립트**. 설명: [모바일] 선택근로-일일실적 수정.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) | 2031행; 원본 보존 |
| [../Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Page%20Attributes.xml) | 12행; 원본 보존 |
| [../Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Properties.xml) | 45행; 원본 보존 |
| [../Type Definitions.abap](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Type%20Definitions.abap) | 0행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Properties.xml) L18 | IMPLCLASS=CL_O21BRVP56U91Z2OGUV66W2TE7UG; 생성 클래스 본문/실행 미확인 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Properties.xml) L39 | VERSION=A; metadata이며 운영 사용 증거 아님 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Properties.xml) L35 | IS_START_PAGE=빈값; metadata이며 운영 사용 증거 아님 |
| 페이지 매개변수 정의 | [Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Page%20Attributes.xml) L10 | PAGE_ATTRIBUTES 항목 0개. 웹 요청 데이터는 Layout JavaScript와 함수 인터페이스에서 별도로 확인 |

### 화면 이벤트와 JavaScript

Layout의 인라인 JavaScript를 함께 색인했다. onClick/onChange는 화면 이벤트, Event Handler ABAP는 서버 이벤트이며 서로 동일하지 않다. 구형·new·bak 명칭만으로 운영 사용 여부를 결정하지 않는다.

| 구분 | 이름·식 | 원본 위치 |
|---|---|---|
| JS 함수 정의 | `fn_ZWEB_COMMON_GET_LOGIN_INFO` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L71 |
| JS 함수 정의 | `fn_callBackZWEB_COMMON_GET_LOGIN_INFO` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L78 |
| JS 함수 정의 | `fn_init` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L91 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_CHECK_DATA` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L100 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_CHECK_DATA` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L119 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_GET_DATA` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L151 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_GET_DATA` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L174 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_PROCESS_DATA` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L269 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_PROCESS_DATA` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L294 |
| JS 함수 정의 | `fnWorkChange` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L529 |
| JS 함수 정의 | `fnChange` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L537 |
| JS 함수 정의 | `fn_checkTDCOST` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L555 |
| JS 함수 정의 | `fn_checkZOVRNGT` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L564 |
| JS 함수 정의 | `fn_checkZNOWK` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L575 |
| JS 함수 정의 | `fnValidation` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L646 |
| JS 함수 정의 | `fnValidation2` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L731 |
| JS 함수 정의 | `fnMakeData` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L778 |
| JS 함수 정의 | `fn_checkZTOICH` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L822 |
| JS 함수 정의 | `fn_formatDay` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L829 |
| JS 함수 정의 | `fn_ZEP_SEARCH_ENAME` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L844 |
| JS 함수 정의 | `fn_setEnameList` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L868 |
| JS 함수 정의 | `fn_ZEP_SEARCH_ENAME1` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L895 |
| JS 함수 정의 | `fn_setEname` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L904 |
| JS 함수 정의 | `callBackApprChk` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L923 |
| JS 함수 정의 | `numberWithCommas` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L942 |
| JS 함수 정의 | `onlyNumber` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L947 |
| JS 함수 정의 | `removeChar` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L954 |
| JS 함수 정의 | `fn_timeLimit` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L964 |
| JS 함수 정의 | `fn_agreement` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1057 |
| JS 함수 정의 | `fn_save` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1095 |
| JS 함수 정의 | `fn_approval` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1109 |
| JS 함수 정의 | `fn_cancel` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1140 |
| JS 함수 정의 | `fn_setButton` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1148 |
| JS 함수 정의 | `fn_addBreakDiv` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1175 |
| JS 함수 정의 | `fn_checkZEMCWK` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1209 |
| JS 함수 정의 | `fn_ZHR_52TM_IAM` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1217 |
| JS 함수 정의 | `fn_callbackZHR_52TM_IAM_LIST` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1228 |
| JS 함수 정의 | `fn_iamSelect` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1261 |
| HTML 이벤트 바인딩 | `fn_setEname(` → 같은 Layout 함수 정의 L904 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L877 |
| HTML 이벤트 바인딩 | `fn_approval(` → 같은 Layout 함수 정의 L1109 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1153 |
| HTML 이벤트 바인딩 | `fn_approval(` → 같은 Layout 함수 정의 L1109 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1154 |
| HTML 이벤트 바인딩 | `fn_approval(` → 같은 Layout 함수 정의 L1109 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1155 |
| HTML 이벤트 바인딩 | `fn_approval(` → 같은 Layout 함수 정의 L1109 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1156 |
| HTML 이벤트 바인딩 | `fn_cancel();` → 같은 Layout 함수 정의 L1140 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1157 |
| HTML 이벤트 바인딩 | `fn_iamSelect(` → 같은 Layout 함수 정의 L1261 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1242 |
| HTML 이벤트 바인딩 | `fn_openIamLayer()` → 함수 정의/실행 대상 추가 확인 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1441 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L529 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1463 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L529 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1491 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L529 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1498 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L529 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1527 |
| HTML 이벤트 바인딩 | `fnWorkChange()` → 같은 Layout 함수 정의 L529 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1533 |
| HTML 이벤트 바인딩 | `fn_checkTDCOST()` → 같은 Layout 함수 정의 L555 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1542 |
| HTML 이벤트 바인딩 | `fn_checkZTOICH()` → 같은 Layout 함수 정의 L822 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1546 |
| HTML 이벤트 바인딩 | `fn_checkZEMCWK()` → 같은 Layout 함수 정의 L1209 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1550 |
| HTML 이벤트 바인딩 | `fn_checkZOVRNGT()` → 같은 Layout 함수 정의 L564 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1554 |
| HTML 이벤트 바인딩 | `fn_checkZNOWK()` → 같은 Layout 함수 정의 L575 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1558 |
| HTML 이벤트 바인딩 | `fn_openBreaktimeLayer()` → 함수 정의/실행 대상 추가 확인 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1582 |
| HTML 이벤트 바인딩 | `fn_ZEP_SEARCH_ENAME()` → 같은 Layout 함수 정의 L844 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1602 |
| HTML 이벤트 바인딩 | `fn_cancel();` → 같은 Layout 함수 정의 L1140 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1608 |
| HTML 이벤트 바인딩 | `fn_ZEP_SEARCH_ENAME1()` → 같은 Layout 함수 정의 L895 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1698 |
| HTML 이벤트 바인딩 | `fn_agreement(` → 같은 Layout 함수 정의 L1057 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1724 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L537 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1745 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L537 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1773 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L537 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1779 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L537 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1785 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L537 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1814 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L537 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1820 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L1175 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1825 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L537 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1837 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L537 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1865 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L537 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1871 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L537 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1877 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L537 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1906 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L537 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1912 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L1175 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1917 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L1175 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1918 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L537 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1930 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L537 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1958 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L537 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1964 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L537 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1970 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L537 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1999 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L537 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L2005 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L1175 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L2010 |
| HTML 이벤트 바인딩 | `fn_closeBreaktimeLayer()` → 함수 정의/실행 대상 추가 확인 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L2023 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZEP_SEARCH_ENAME](EXTERNAL_DEPENDENCIES.md#ZEP_SEARCH_ENAME) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L861, 897 |
| [ZHR_52TM_CW_CHECK_DATA](ZHR_52TM_CW_CHECK_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L111 |
| [ZHR_52TM_CW_GET_DATA](ZHR_52TM_CW_GET_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L164 |
| [ZHR_52TM_CW_PROCESS_DATA](ZHR_52TM_CW_PROCESS_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L284 |
| [ZHR_52TM_IAM](ZHR_52TM_IAM.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1220 |
| [ZWEB_COMMON_GET_LOGIN_INFO](EXT-ZWEB_COMMON_GET_LOGIN_INFO.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L73 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| — | 색인 내 정적 참조 없음; 미사용 근거 아님 | 동적 호출·외부 시스템은 미확인 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.

| 미확인 종류 | 참조·이름 | 근거 |
|---|---|---|
| 외부 웹 파일 | `../zmobile_common/server_util3.ssjs` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1 |
| 외부 웹 파일 | `https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.14.1/moment.min.js` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L14 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/jquery-1.8.0.min.js` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L15 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/ess_include.js` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L18 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/ess_common.js` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L19 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_common/json2.js` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L20 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_common/modernizr.js` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L21 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/bootstrap-datepicker.min.js` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L22 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/bootstrap-datepicker.ko.min.js` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L23 |
| 외부 웹 파일 | `/sap/bc/bsp/sap/zmobile_ess/js/common_new.js` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1357 |
| 외부 웹 파일 | `/m001/js/cap.js` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1360 |
| 웹 중계 의존 | `../zmobile_common/server_util3.ssjs` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L75 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L117 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L172 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L291 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L865 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L901 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1224 |

정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
