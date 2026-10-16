---
title: "ZHR_TIME_MONTH_M — [52시간] Mobile_통상/교대 시간외 근무신청 현황"
as_of: 2026-10-07
review_status: pending_business_review
tags: [교대근무, 통상시차시간외]
---

# ZHR_TIME_MONTH_M — [52시간] Mobile_통상/교대 시간외 근무신청 현황

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] Mobile_통상/교대 시간외 근무신청 현황.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Changing.xml) | 106행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Exception.xml) | 106행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Export.xml) | 228행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Import.xml) | 135행; 원본 보존 |
| [ZHR_TIME_MONTH_M.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Source%20code/ZHR_TIME_MONTH_M.abap) | 319행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Tables.xml) | 140행; 원본 보존 |
| [../../../Include/LZHR008_2U48.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U48.abap) | 319행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U48.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U48.abap) L1 | LZHR008_2U48: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_WKBEGDA` | BEGDA | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Export.xml) L8 |
| Export | `E_WKENDDA` | ENDDA | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Export.xml) L19 |
| Export | `E_ZRLOVRWKHR` | CHAR05 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Export.xml) L30 |
| Export | `E_ZRESTWKHR` | CHAR05 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Export.xml) L41 |
| Export | `E_STATE_D` | INTEGER | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Export.xml) L52 |
| Export | `E_MONEY_D` | CHAR12 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Export.xml) L63 |
| Export | `E_STATE_P` | INTEGER | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Export.xml) L74 |
| Export | `E_MONEY_P` | CHAR12 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Export.xml) L85 |
| Export | `E_STATE_Y` | INTEGER | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Export.xml) L96 |
| Export | `E_MONEY_Y` | CHAR12 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Export.xml) L107 |
| Export | `E_WEEK_C` | NUMC1 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Export.xml) L118 |
| Import | `I_PERNR` | PERSNO | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Import.xml) L8 |
| Import | `I_DATA` | D | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Import.xml) L22 |
| Tables | `T_LIST` | CASDAYATTR | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Tables.xml) L8 |
| Tables | `T_LIST1` | [ZSHR4002_M](ZSHR4002_M.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Tables.xml) L19 |
| Tables | `T_LIST2` | [ZSHR0111](ZSHR0111.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Tables.xml) L30 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [DAY_ATTRIBUTES_GET](EXTERNAL_DEPENDENCIES.md#DAY_ATTRIBUTES_GET) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_TIME_MONTH_M.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Source%20code/ZHR_TIME_MONTH_M.abap) L65 |
| [DISP_WEEK_GET](EXTERNAL_DEPENDENCIES.md#DISP_WEEK_GET) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_TIME_MONTH_M.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Source%20code/ZHR_TIME_MONTH_M.abap) L125, 133 |
| [HR_JP_MONTH_BEGIN_END_DATE](EXTERNAL_DEPENDENCIES.md#HR_JP_MONTH_BEGIN_END_DATE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_TIME_MONTH_M.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Source%20code/ZHR_TIME_MONTH_M.abap) L57 |
| [LAST_DAY_OF_MONTHS](EXTERNAL_DEPENDENCIES.md#LAST_DAY_OF_MONTHS) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_TIME_MONTH_M.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Source%20code/ZHR_TIME_MONTH_M.abap) L111 |
| [LZHR008_2F06](LZHR008_2F06.md) | **FORM 호출** — GET_WEEK_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap L1179; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_TIME_MONTH_M.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Source%20code/ZHR_TIME_MONTH_M.abap) L49 |
| [LZHR008_2F06](LZHR008_2F06.md) | **FORM 호출** — SET_CURR_MONEY: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap L1158; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_TIME_MONTH_M.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Source%20code/ZHR_TIME_MONTH_M.abap) L167, 186, 189, 192 |
| [ZHR_52TM_AWART_LIST](ZHR_52TM_AWART_LIST.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_TIME_MONTH_M.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Source%20code/ZHR_TIME_MONTH_M.abap) L238 |
| [ZHR_52TM_SET_ZGUBUN](ZHR_52TM_SET_ZGUBUN.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_TIME_MONTH_M.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Source%20code/ZHR_TIME_MONTH_M.abap) L76 |
| [ZHR_GET_OT_DETAIL_DATA](EXTERNAL_DEPENDENCIES.md#ZHR_GET_OT_DETAIL_DATA) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_TIME_MONTH_M.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Source%20code/ZHR_TIME_MONTH_M.abap) L153 |
| [ZSHR0111](ZSHR0111.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Tables.xml) L31 |
| [ZSHR0111](ZSHR0111.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_TIME_MONTH_M.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Source%20code/ZHR_TIME_MONTH_M.abap) L26, 27, 29 |
| [ZSHR4002_M](ZSHR4002_M.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Tables.xml) L20 |
| [ZSHR4002_M](ZSHR4002_M.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_TIME_MONTH_M.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Source%20code/ZHR_TIME_MONTH_M.abap) L216 |
| [ZTHR0080](EXTERNAL_DEPENDENCIES.md#ZTHR0080) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_TIME_MONTH_M.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_TIME_MONTH_M/Source%20code/ZHR_TIME_MONTH_M.abap) L256, 262, 267 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L99 |
| [ORD_OT_MONTHLY_CONDITION](ORD_OT_MONTHLY_CONDITION.md) | 웹 요청 | [ORD_OT_MONTHLY_CONDITION.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MONTHLY_CONDITION/Layout/ORD_OT_MONTHLY_CONDITION.htm) L134 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
