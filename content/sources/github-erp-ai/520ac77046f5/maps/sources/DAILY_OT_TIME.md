---
title: "DAILY_OT_TIME — [PC] 선택근로-휴게시간 수정"
as_of: 2026-10-07
review_status: pending_business_review
tags: [선택근무]
---

# DAILY_OT_TIME — [PC] 선택근로-휴게시간 수정

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **BSP 화면·스크립트**. 설명: [PC] 선택근로-휴게시간 수정.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) | 731행; 원본 보존 |
| [../Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Page%20Attributes.xml) | 12행; 원본 보존 |
| [../Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Properties.xml) | 45행; 원본 보존 |
| [../Type Definitions.abap](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Type%20Definitions.abap) | 0행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Properties.xml) L18 | IMPLCLASS=CL_O25HZS0HCSJMYPY3Z3TKVMYUIPK; 생성 클래스 본문/실행 미확인 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Properties.xml) L39 | VERSION=A; metadata이며 운영 사용 증거 아님 |
| 페이지 속성 | [Properties.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Properties.xml) L35 | IS_START_PAGE=빈값; metadata이며 운영 사용 증거 아님 |
| 페이지 매개변수 정의 | [Page Attributes.xml](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Page%20Attributes.xml) L10 | PAGE_ATTRIBUTES 항목 0개. 웹 요청 데이터는 Layout JavaScript와 함수 인터페이스에서 별도로 확인 |

### 화면 이벤트와 JavaScript

Layout의 인라인 JavaScript를 함께 색인했다. onClick/onChange는 화면 이벤트, Event Handler ABAP는 서버 이벤트이며 서로 동일하지 않다. 구형·new·bak 명칭만으로 운영 사용 여부를 결정하지 않는다.

| 구분 | 이름·식 | 원본 위치 |
|---|---|---|
| JS 함수 정의 | `fn_ZWEB_COMMON_GET_LOGIN_INFO` | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L319 |
| JS 함수 정의 | `fn_callBackZWEB_COMMON_GET_LOGIN_INFO` | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L328 |
| JS 함수 정의 | `fn_init` | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L338 |
| JS 함수 정의 | `fn_addBreakDiv` | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L392 |
| JS 함수 정의 | `fnMakeData` | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L421 |
| JS 함수 정의 | `fnChange` | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L447 |
| JS 함수 정의 | `fnValidation` | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L482 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_CHECK_DATA` | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L565 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_CHECK_DATA` | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L584 |
| JS 함수 정의 | `fn_save` | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L602 |
| JS 함수 정의 | `fn_close` | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L611 |
| JS 함수 정의 | `fn_ZHR_52TM_CW_GET_DATA` | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L666 |
| JS 함수 정의 | `fn_callbackZHR_52TM_CW_GET_DATA` | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L691 |
| JS 함수 정의 | `fn_formatDay` | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L714 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L447 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L52 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L447 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L78 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L447 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L82 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L447 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L84 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L447 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L111 |
| HTML 이벤트 바인딩 | `fnChange(1)` → 같은 Layout 함수 정의 L447 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L115 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L392 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L117 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L447 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L133 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L447 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L159 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L447 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L163 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L447 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L165 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L447 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L192 |
| HTML 이벤트 바인딩 | `fnChange(2)` → 같은 Layout 함수 정의 L447 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L196 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L392 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L198 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L392 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L199 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L447 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L215 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L447 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L241 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L447 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L245 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L447 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L247 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L447 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L274 |
| HTML 이벤트 바인딩 | `fnChange(3)` → 같은 Layout 함수 정의 L447 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L278 |
| HTML 이벤트 바인딩 | `fn_addBreakDiv(` → 같은 Layout 함수 정의 L392 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L280 |
| HTML 이벤트 바인딩 | `fn_save();` → 같은 Layout 함수 정의 L602 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L294 |
| HTML 이벤트 바인딩 | `self.close()` → 함수 정의/실행 대상 추가 확인 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L295 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZHR_52TM_CW_CHECK_DATA](ZHR_52TM_CW_CHECK_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L576 |
| [ZHR_52TM_CW_GET_DATA](ZHR_52TM_CW_GET_DATA.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L679 |
| [ZWEB_COMMON_GET_LOGIN_INFO](EXT-ZWEB_COMMON_GET_LOGIN_INFO.md) | **웹 요청** — FUNCTION_NAME에 전달하는 이름; 외부 dispatcher의 실제 호출은 미확인 | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L323 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| — | 색인 내 정적 참조 없음; 미사용 근거 아님 | 동적 호출·외부 시스템은 미확인 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.

| 미확인 종류 | 참조·이름 | 근거 |
|---|---|---|
| 외부 웹 파일 | `../zweb_common/server_util2.ssjs` | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L2 |
| 웹 중계 의존 | `../zweb_common/server_util2.ssjs` | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L2 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L325 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L582 |
| 웹 중계 의존 | `../ZWEB_COMMON/AJAX_COMMON.HTM` | [DAILY_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_TIME/Layout/DAILY_OT_TIME.htm) L687 |

정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
