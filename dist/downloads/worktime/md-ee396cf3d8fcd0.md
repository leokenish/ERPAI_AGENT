---
title: "ZHR_52TM_APPROVAL_LIST — [52시간] 결재자 결재리스트(대기함.진행함.승인.반려)"
as_of: 2026-10-07
review_status: pending_business_review
tags: [PC모바일공통웹, 선택근무, 탄력근무, 통합결재]
---

# ZHR_52TM_APPROVAL_LIST — [52시간] 결재자 결재리스트(대기함.진행함.승인.반려)

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 결재자 결재리스트(대기함.진행함.승인.반려).

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Changing.xml) | 100행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Exception.xml) | 100행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Export.xml) | 156행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Import.xml) | 199행; 원본 보존 |
| [ZHR_52TM_APPROVAL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Source%20code/ZHR_52TM_APPROVAL_LIST.abap) | 310행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Tables.xml) | 134행; 원본 보존 |
| [../../../Include/LZHR008_2U50.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U50.abap) | 310행; 원본 보존 |

### 이번 업무 구간 검토

파일 판정: **후보**. 검토 범위: I_ACTION=A, I_BOX=4/5/6 승인 라우팅 및 데이터 전달 L160–310. 남은 범위: 목록 조회 전반·모든 분기/외부 승인함수 본문·dispatcher 실행 미검증. 이는 이 파일/명시한 구간의 정적 분석이며 외부 함수·업무 전체·운영 검증 완료는 아니다.

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U50.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U50.abap) L1 | LZHR008_2U50: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_COUNT1` | NUMC4 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Export.xml) L8 |
| Export | `E_COUNT2` | NUMC4 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Export.xml) L19 |
| Export | `E_COUNT3` | NUMC4 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Export.xml) L30 |
| Export | `E_CODE` | CHAR03 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Export.xml) L41 |
| Export | `E_TEXT` | CHAR200 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Export.xml) L52 |
| Import | `I_PERNR` | PERSNO | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Import.xml) L8 |
| Import | `I_STAT` | CHAR1 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Import.xml) L22 |
| Import | `I_BOX` | CHAR1 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Import.xml) L36 |
| Import | `I_BEGDA` | BEGDA | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Import.xml) L50 |
| Import | `I_ENDDA` | ENDDA | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Import.xml) L64 |
| Import | `I_ACTION` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Import.xml) L78 |
| Import | `IS_SORT` | [ZSHR0136](ZSHR0136.md) | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Import.xml) L92 |
| Tables | `GT_LIST4` | ZSWF0014_TAB | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Tables.xml) L8 |
| Tables | `GT_LIST5` | [ZSWF0015_TAB](ZSWF0015_TAB.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Tables.xml) L19 |
| Tables | `GT_LIST6` | [ZSWF0016_TAB](ZSWF0016_TAB.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Tables.xml) L30 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZHR_52TM_APPROVE_OT_DATA](ZHR_52TM_APPROVE_OT_DATA.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_APPROVAL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Source%20code/ZHR_52TM_APPROVAL_LIST.abap) L253 |
| [ZHR_52TM_CW_GET_DATA](ZHR_52TM_CW_GET_DATA.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_APPROVAL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Source%20code/ZHR_52TM_APPROVAL_LIST.abap) L106 |
| [ZHR_52TM_DAILY_APPROVE_OT_DATA](ZHR_52TM_DAILY_APPROVE_OT_DATA.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_APPROVAL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Source%20code/ZHR_52TM_APPROVAL_LIST.abap) L290 |
| [ZHR_APPROVE_OT_DATA](EXT-ZHR_APPROVE_OT_DATA.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_APPROVAL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Source%20code/ZHR_52TM_APPROVAL_LIST.abap) L198 |
| [ZSHR0136](ZSHR0136.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Import.xml) L99 |
| [ZSHR0144](ZSHR0144.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_APPROVAL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Source%20code/ZHR_52TM_APPROVAL_LIST.abap) L42 |
| [ZSWF0014_TAB](EXTERNAL_DEPENDENCIES.md#ZSWF0014_TAB) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Tables.xml) L12 |
| [ZSWF0015](ZSWF0015.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_APPROVAL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Source%20code/ZHR_52TM_APPROVAL_LIST.abap) L28 |
| [ZSWF0015_TAB](ZSWF0015_TAB.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Tables.xml) L23 |
| [ZSWF0015_TAB](ZSWF0015_TAB.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_APPROVAL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Source%20code/ZHR_52TM_APPROVAL_LIST.abap) L32 |
| [ZSWF0016](ZSWF0016.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_APPROVAL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Source%20code/ZHR_52TM_APPROVAL_LIST.abap) L29 |
| [ZSWF0016_TAB](ZSWF0016_TAB.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Tables.xml) L34 |
| [ZSWF0016_TAB](ZSWF0016_TAB.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_APPROVAL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Source%20code/ZHR_52TM_APPROVAL_LIST.abap) L33 |
| [ZTHR0106](ZTHR0106.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_APPROVAL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Source%20code/ZHR_52TM_APPROVAL_LIST.abap) L216 |
| [ZTHR0106](ZTHR0106.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_APPROVAL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Source%20code/ZHR_52TM_APPROVAL_LIST.abap) L37 |
| [ZTHR0110](ZTHR0110.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_APPROVAL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Source%20code/ZHR_52TM_APPROVAL_LIST.abap) L228 |
| [ZTHR0110](ZTHR0110.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_APPROVAL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Source%20code/ZHR_52TM_APPROVAL_LIST.abap) L38 |
| [ZTHR0112](ZTHR0112.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_APPROVAL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Source%20code/ZHR_52TM_APPROVAL_LIST.abap) L268 |
| [ZTHR0112](ZTHR0112.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_APPROVAL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Source%20code/ZHR_52TM_APPROVAL_LIST.abap) L39 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_APPROVAL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Source%20code/ZHR_52TM_APPROVAL_LIST.abap) L175 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [APP_C_LIST2](APP_C_LIST2.md) | 웹 요청 | [APP_C_LIST2.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/APP_C_LIST2/Layout/APP_C_LIST2.htm) L273 |
| [APP_OT_LIST](APP_OT_LIST.md) | 웹 요청 | [APP_OT_LIST.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/APP_OT_LIST/Layout/APP_OT_LIST.htm) L146, 370 |
| [APP_OT_LIST_B](APP_OT_LIST_B.md) | 웹 요청 | [APP_OT_LIST_B.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/APP_OT_LIST_B/Layout/APP_OT_LIST_B.htm) L177 |
| [APP_OT_LIST_B_bak](APP_OT_LIST_B_bak.md) | 웹 요청 | [APP_OT_LIST_B_bak.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/APP_OT_LIST_B_bak/Layout/APP_OT_LIST_B_bak.htm) L108 |
| [APP_OT_LIST_C](APP_OT_LIST_C.md) | 웹 요청 | [APP_OT_LIST_C.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/APP_OT_LIST_C/Layout/APP_OT_LIST_C.htm) L104 |
| [APP_R_LIST2](APP_R_LIST2.md) | 웹 요청 | [APP_R_LIST2.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/APP_R_LIST2/Layout/APP_R_LIST2.htm) L261 |
| [DAILY_APP_LIST](DAILY_APP_LIST.md) | 웹 요청 | [DAILY_APP_LIST.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_APP_LIST/Layout/DAILY_APP_LIST.htm) L134, 354 |
| [DAILY_OT_LIST_B](DAILY_OT_LIST_B.md) | 웹 요청 | [DAILY_OT_LIST_B.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_LIST_B/Layout/DAILY_OT_LIST_B.htm) L100 |
| [FLEXTIME_LIST](FLEXTIME_LIST.md) | 웹 요청 | [FLEXTIME_LIST.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEXTIME_LIST/Layout/FLEXTIME_LIST.htm) L116, 300 |
| [FLEXTIME_LIST_B](FLEXTIME_LIST_B.md) | 웹 요청 | [FLEXTIME_LIST_B.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEXTIME_LIST_B/Layout/FLEXTIME_LIST_B.htm) L91 |
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L103 |

### 관련 업무와 미확인 범위

- [approvals](../topics/approvals.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [flexible](../topics/flexible.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
