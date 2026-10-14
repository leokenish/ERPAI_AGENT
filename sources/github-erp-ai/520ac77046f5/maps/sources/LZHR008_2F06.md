---
title: "LZHR008_2F06 — 통상 화면 초기화·수정 연결"
as_of: 2026-10-07
review_status: pending_business_review
tags: [교대근무, 근무현황조회, 월정산전표지급, 통상시차시간외, 통합결재, 퇴직자관리자입력검토]
---

# LZHR008_2F06 — 통상 화면 초기화·수정 연결

[소스 설명 목차](INDEX.md) · [원본 파일](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap)

화면 기준일을 인사정보 함수에 전달한다. 관리자 대행 인증이나 디버거 권한 구현은 여기서 확정하지 않는다.

확인 수준: 표시한 소스 구간 정적 확인; 운영 실행 검증 아님. 원본 경로·파일은 그대로 유지한다.

## 근거 위치

| 위치 | 관계의 의미 | 근거 구문 |
|---|---|---|
| 73행 | 초기 검사 | `FORM set_init_check  USING    p_pernr` |
| 102행 | 전달 기준일 | `i_znal            = p_datum` |
| 257행 | 인사정보 갱신 | `FORM get_overtime_pernr_info CHANGING ps_zshr0131 TYPE zshr0131` |
| 572행 | 수정 데이터 계산 호출 | `CALL FUNCTION 'ZHR_52TM_GET_OVERTIME_DATA'` |

## 연결된 소스

- [ZHR_52TM_GET_PERSONNEL_DATA_N](ZHR_52TM_GET_PERSONNEL_DATA_N.md) — 함수 호출 확인, 위 원본 99행. 호출 이후 전체 실행 성공은 미검증.
- [ZHR_52TM_GET_OVERTIME_DATA](ZHR_52TM_GET_OVERTIME_DATA.md) — 함수 호출 확인, 위 원본 572행. 호출 이후 전체 실행 성공은 미검증.

## 관련 업무

<!-- topics -->
- [퇴직자·관리자 입력 검토](../topics/retired.md) — 이 소스를 검토하는 업무 지도.

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수그룹 Include**. 설명: 제목 메타데이터 없음; 이름만으로 업무를 확정하지 않음.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) | 1715행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [DATE_GET_WEEK](EXTERNAL_DEPENDENCIES.md#DATE_GET_WEEK) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L19 |
| [GET_DOMAIN_VALUES](EXTERNAL_DEPENDENCIES.md#GET_DOMAIN_VALUES) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L881 |
| [HOLIDAY_GET](EXTERNAL_DEPENDENCIES.md#HOLIDAY_GET) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L1566, 1585, 1659, 1678 |
| [LZHR008_2F06](LZHR008_2F06.md) | **FORM 호출** — CHECK_BREAK_TIME_ZTOMO: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap L719; 포함 범위 내 이름 일치, 동적 해석 제외 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L502 |
| [LZHR008_2F06](LZHR008_2F06.md) | **FORM 호출** — GET_OVERTIME_PERNR_INFO: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap L257; 포함 범위 내 이름 일치, 동적 해석 제외 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L528, 1013 |
| [LZHR008_2F06](LZHR008_2F06.md) | **FORM 호출** — MODIFY_SCREEN: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap L317; 포함 범위 내 이름 일치, 동적 해석 제외 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L123 |
| [LZHR008_2F06](LZHR008_2F06.md) | **FORM 호출** — SET_OVERTIME_CONVERT_TIME_OUT: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap L903; 포함 범위 내 이름 일치, 동적 해석 제외 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L238, 698, 859, 1101, 1250 |
| [LZHR008_2F06](LZHR008_2F06.md) | **FORM 호출** — SET_OVERTIME_DATE: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap L9; 포함 범위 내 이름 일치, 동적 해석 제외 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L777, 1195 |
| [LZHR008_2F06](LZHR008_2F06.md) | **FORM 호출** — SET_OVERTIME_DEFAULT_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap L146; 포함 범위 내 이름 일치, 동적 해석 제외 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L90 |
| [WEEK_GET_FIRST_DAY](EXTERNAL_DEPENDENCIES.md#WEEK_GET_FIRST_DAY) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L26 |
| [ZCL_CM_UTIL_DEV](EXT-ZCL_CM_UTIL_DEV.md) | **클래스 참조** — get_jikwitext 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L958 |
| [ZCL_CM_UTIL_DEV](EXT-ZCL_CM_UTIL_DEV.md) | **클래스 참조** — get_vdstext 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L955 |
| [ZEPDWK_TM](ZEPDWK_TM.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L438, 979, 1264, 1265 |
| [ZEWKTYPE](ZEWKTYPE.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L762 |
| [ZHR_52TM_CALC_BREAK_TIME](ZHR_52TM_CALC_BREAK_TIME.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L636, 1282 |
| [ZHR_52TM_CHECK_INPUT_DATA](ZHR_52TM_CHECK_INPUT_DATA.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L1109 |
| [ZHR_52TM_CHECK_INPUT_DATA_M](ZHR_52TM_CHECK_INPUT_DATA_M.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L534 |
| [ZHR_52TM_EARLIER_WORKER](ZHR_52TM_EARLIER_WORKER.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L394 |
| [ZHR_52TM_GET_OVERTIME_DATA](ZHR_52TM_GET_OVERTIME_DATA.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L572, 1027, 1292 |
| [ZHR_52TM_GET_PERSONNEL_DATA_N](ZHR_52TM_GET_PERSONNEL_DATA_N.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L99, 269 |
| [ZHR_52TM_SET_DEFAULT_TIME](ZHR_52TM_SET_DEFAULT_TIME.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L165, 645, 813, 1085, 1207 |
| [ZHR_52TM_SET_WKTYPE_LIST](ZHR_52TM_SET_WKTYPE_LIST.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L366 |
| [ZHR_52TM_SET_ZGUBUN](ZHR_52TM_SET_ZGUBUN.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L52, 1199 |
| [ZHR_52TM_WKTYPE_PERIOD](ZHR_52TM_WKTYPE_PERIOD.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L376, 782 |
| [ZHR_GET_DAY_DATA_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_DAY_DATA_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L116, 305 |
| [ZHR_MINUS_TIME_N](EXTERNAL_DEPENDENCIES.md#ZHR_MINUS_TIME_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L621, 1355 |
| [ZSHR0104](ZSHR0104.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L432, 978 |
| [ZSHR0114](ZSHR0114.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L350, 875 |
| [ZSHR0119](ZSHR0119.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L358, 359, 760 |
| [ZSHR0131](ZSHR0131.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L76, 149, 257, 425, 719, 971, 1260 |
| [ZSHR0133](ZSHR0133.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L755 |
| [ZSH_PERSONNEL_DATA_N](ZSH_PERSONNEL_DATA_N.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L82, 263 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L941 |
| [ZTHRBS07](EXTERNAL_DEPENDENCIES.md#ZTHRBS07) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L1608, 1701 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F06](LZHR008_2F06.md) | FORM 호출 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L90, 123, 238, 502, 528, 698, 777, 859, 1013, 1101, 1195, 1250 |
| [SAPLZHR008_2](SAPLZHR008_2.md) | Include | [SAPLZHR008_2.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/SAPLZHR008_2.abap) L24 |
| [ZHR_52TM_MOBILE_OVERTIME_APPR](ZHR_52TM_MOBILE_OVERTIME_APPR.md) | FORM 호출 | [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L94, 143, 158 |
| [ZHR_52TM_MOBILE_OVERTIME_CHECK](ZHR_52TM_MOBILE_OVERTIME_CHECK.md) | FORM 호출 | [ZHR_52TM_MOBILE_OVERTIME_CHECK.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_CHECK/Source%20code/ZHR_52TM_MOBILE_OVERTIME_CHECK.abap) L41, 48, 96, 123, 168, 203, 242, 300 |
| [ZHR_52TM_MOBILE_OVERTIME_DETL](ZHR_52TM_MOBILE_OVERTIME_DETL.md) | FORM 호출 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L120, 130, 216, 253, 275 |
| [ZHR_52TM_MOBILE_OVERTIME_LIST](ZHR_52TM_MOBILE_OVERTIME_LIST.md) | FORM 호출 | [ZHR_52TM_MOBILE_OVERTIME_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_LIST/Source%20code/ZHR_52TM_MOBILE_OVERTIME_LIST.abap) L35, 44 |
| [ZHR_52TM_REAL_WORK_TIME_TEAM](ZHR_52TM_REAL_WORK_TIME_TEAM.md) | FORM 호출 | [ZHR_52TM_REAL_WORK_TIME_TEAM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME_TEAM/Source%20code/ZHR_52TM_REAL_WORK_TIME_TEAM.abap) L737 |
| [ZHR_52TM_REAL_WORK_TIME_TEAM_M](ZHR_52TM_REAL_WORK_TIME_TEAM_M.md) | FORM 호출 | [ZHR_52TM_REAL_WORK_TIME_TEAM_M.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME_TEAM_M/Source%20code/ZHR_52TM_REAL_WORK_TIME_TEAM_M.abap) L803, 813 |
| [ZHR_52TM_VALID_DATE_CHECK](ZHR_52TM_VALID_DATE_CHECK.md) | FORM 호출 | [ZHR_52TM_VALID_DATE_CHECK.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Source%20code/ZHR_52TM_VALID_DATE_CHECK.abap) L90, 98 |
| [ZHR_TIME_MONTH_M](ZHR_TIME_MONTH_M.md) | FORM 호출 | [ZHR_TIME_MONTH_M.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Source%20code/ZHR_TIME_MONTH_M.abap) L49, 167, 186, 189, 192 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
