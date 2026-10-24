---
title: "PC·모바일 공통 화면·웹 의존"
as_of: 2026-10-07
review_status: pending_business_review
tags: [PC모바일공통웹]
---

# PC·모바일 공통 화면·웹 의존

<!-- atlas:auto:start -->

## 전체 범위 단계 지도

[전체 업무 진행 상태](../PROGRESS.md) · [소스 설명 목차](../sources/INDEX.md)
96개 BSP 페이지와 인라인 JavaScript, 서버 이벤트 11개 및 app_script.kbs를 색인했다. PC/모바일/관리자/new/bak/OLD 변형을 보존한다.
**완료 범위:** 아래 단계의 지정 소스 구간·직접 관계 확인 및 탐색 연결. 전체 업무 규칙·모든 분기 검토 완료를 뜻하지 않는다. 적용 시점은 추출본이며 운영 반영일 미확인. 기존 문서에 있는 정책/과거 검토안의 구분을 유지한다.

| 단계 | 관련 설명 문서 | 관계의 의미 | 근거 파일·코드 위치 | 수준 |
|---|---|---|---|---|
| 진입·변형 화면 | [MAIN](../sources/MAIN.md) · [MAIN_OLD](../sources/MAIN_OLD.md) · [FLEX_MAIN](../sources/FLEX_MAIN.md) · [MORD_OT_MAIN](../sources/MORD_OT_MAIN.md) · [MORD_OT_MAIN_new](../sources/MORD_OT_MAIN_new.md) | MAIN이라는 이름을 실제 최초 진입점으로 확정하지 않는다. 96개 페이지 Properties와 pages.xml은 파일 증거일 뿐 운영 메뉴/사용 빈도 자료가 아니다. | [MAIN 원본](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[MAIN_OLD 원본](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MAIN_OLD/Layout/MAIN_OLD.htm) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[FLEX_MAIN 원본](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_MAIN/Layout/FLEX_MAIN.htm) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[MORD_OT_MAIN 원본](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MAIN/Layout/MORD_OT_MAIN.htm) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[MORD_OT_MAIN_new 원본](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MAIN_new/Layout/MORD_OT_MAIN_new.htm) — 파일 존재/헤더/정적 색인; 업무군 선정 | 분석상 연관·후보; 직접 호출 근거 아님 |
| 요청 공통 경계 | [IAM](../sources/IAM.md) · [ZWEB_COMMON_GET_LOGIN_INFO](../sources/EXT-ZWEB_COMMON_GET_LOGIN_INFO.md) · [DAILY_WORK_INPUT](../sources/DAILY_WORK_INPUT.md) | 여러 화면의 로그인 정보 함수명은 웹 요청 문자열로 확인된다. 인증/함수 실행 구현은 미추출이다. | [IAM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/IAM/Layout/IAM.htm) L347 (웹 요청)<br>[DAILY_WORK_INPUT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT/Layout/DAILY_WORK_INPUT.htm) L669 (웹 요청) | 확인: 지정 구간의 정적 관계 |
| 클라이언트·서버 이벤트 | [app_script](../sources/app_script.md) · [APP_OT_LIST](../sources/APP_OT_LIST.md) · [DAILY_APP_LIST](../sources/DAILY_APP_LIST.md) · [FLEXTIME_LIST](../sources/FLEXTIME_LIST.md) | app_script.kbs의 chkAppDr 등 클라이언트 처리와 각 페이지 Event Handler ABAP를 구분한다. 정적 함수 정의·HTML 바인딩 위치는 각 소스 설명에 기록했다. | [app_script 원본](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/app_script/Layout/app_script.kbs) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[APP_OT_LIST 원본](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/APP_OT_LIST/Layout/APP_OT_LIST.htm) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[DAILY_APP_LIST 원본](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_APP_LIST/Layout/DAILY_APP_LIST.htm) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[FLEXTIME_LIST 원본](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEXTIME_LIST/Layout/FLEXTIME_LIST.htm) — 파일 존재/헤더/정적 색인; 업무군 선정 | 분석상 연관·후보; 직접 호출 근거 아님 |

### 이 업무의 미추출·미검토 경계

외부 ZWEB_COMMON/ZMOBILE_COMMON, UI 스크립트 라이브러리, 로그인·권한·라우팅·dispatcher·런타임 이벤트 순서·운영 시작 페이지는 미확인.
화면 요청/직접 호출/Include/타입 참조/데이터 조회·저장/분석상 연관을 구분했다. 화면이 없거나 중계기·함수가 미추출이면 연결을 그 지점에서 멈춘다. 저장은 승인·지급·배포 완료의 동의어가 아니다.

<!-- atlas:auto:end -->
