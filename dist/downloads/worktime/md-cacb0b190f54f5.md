---
title: "ZHR_52TM_CALC_BREAK_TIME — [52시간] 휴게시간"
as_of: 2026-10-07
review_status: pending_business_review
tags: [IAM등록기본설정, 교대근무, 대휴익휴보상휴가, 탄력근무, 통상시차시간외, 퇴직자관리자입력검토, 특별연장재난방송, 휴가공가반차]
---

# ZHR_52TM_CALC_BREAK_TIME — [52시간] 휴게시간

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 휴게시간.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Changing.xml) | 88행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Exception.xml) | 88행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Export.xml) | 199행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Import.xml) | 131행; 원본 보존 |
| [ZHR_52TM_CALC_BREAK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Source%20code/ZHR_52TM_CALC_BREAK_TIME.abap) | 153행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Tables.xml) | 88행; 원본 보존 |
| [../../../Include/LZHR008_2U07.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U07.abap) | 153행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U07.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U07.abap) L1 | LZHR008_2U07: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_ZBEGTM` | BEGTI | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Export.xml) L8 |
| Export | `E_ZENDTM` | ENDTI | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Export.xml) L19 |
| Export | `E_ZPDWK_TM` | [ZEPDWK_TM](ZEPDWK_TM.md) | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Export.xml) L30 |
| Export | `E_ZPBTM` | ZTOMO | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Export.xml) L41 |
| Export | `E_ZPETM` | ZTOMO | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Export.xml) L52 |
| Export | `E_RETURN` | BAPIRETURN1 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Export.xml) L63 |
| Export | `E_ZBEGTM2` | BEGTI | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Export.xml) L74 |
| Export | `E_ZENDTM2` | ENDTI | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Export.xml) L85 |
| Export | `E_ZPBTM2` | ZTOMO | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Export.xml) L96 |
| Export | `E_ZPETM2` | ZTOMO | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Export.xml) L107 |
| Import | `I_ZBEGTM` | BEGTI | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Import.xml) L8 |
| Import | `I_ZENDTM` | ENDTI | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Import.xml) L22 |
| Import | `I_ZGUBUN` | ZBSGUBUN | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Import.xml) L36 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — GET_DIFF_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L2037; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CALC_BREAK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Source%20code/ZHR_52TM_CALC_BREAK_TIME.abap) L51 |
| [LZHR008_2F02](LZHR008_2F02.md) | **FORM 호출** — SET_HOUR_TO_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F02.abap L12; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CALC_BREAK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Source%20code/ZHR_52TM_CALC_BREAK_TIME.abap) L76 |
| [ZBSGUBUN](EXTERNAL_DEPENDENCIES.md#ZBSGUBUN) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Import.xml) L43 |
| [ZEPDWK_TM](ZEPDWK_TM.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Export.xml) L34 |
| [ZTOMO](EXTERNAL_DEPENDENCIES.md#ZTOMO) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_BREAK_TIME/Export.xml) L45, 56, 100, 111 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [FLEX_WORK_PERFORMANCE_INPUT](FLEX_WORK_PERFORMANCE_INPUT.md) | 웹 요청 | [FLEX_WORK_PERFORMANCE_INPUT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PERFORMANCE_INPUT/Layout/FLEX_WORK_PERFORMANCE_INPUT.htm) L1856 |
| [FLEX_WORK_PERFORMANCE_INPUT_ADM](FLEX_WORK_PERFORMANCE_INPUT_ADM.md) | 웹 요청 | [FLEX_WORK_PERFORMANCE_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PERFORMANCE_INPUT_ADM/Layout/FLEX_WORK_PERFORMANCE_INPUT_ADM.htm) L1886 |
| [FLEX_WORK_PLAN_ESTABLISH](FLEX_WORK_PLAN_ESTABLISH.md) | 웹 요청 | [FLEX_WORK_PLAN_ESTABLISH.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_ESTABLISH/Layout/FLEX_WORK_PLAN_ESTABLISH.htm) L1320 |
| [FLEX_WORK_PLAN_VIEW](FLEX_WORK_PLAN_VIEW.md) | 웹 요청 | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L1125 |
| [FLEX_WORK_PLAN_VIEW_ADM](FLEX_WORK_PLAN_VIEW_ADM.md) | 웹 요청 | [FLEX_WORK_PLAN_VIEW_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW_ADM/Layout/FLEX_WORK_PLAN_VIEW_ADM.htm) L1157 |
| [LZHR008_2F01](LZHR008_2F01.md) | 직접 호출 | [LZHR008_2F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap) L2537 |
| [LZHR008_2F03](LZHR008_2F03.md) | 직접 호출 | [LZHR008_2F03.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap) L5308, 5323, 5332 |
| [LZHR008_2F06](LZHR008_2F06.md) | 직접 호출 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L636, 1282 |
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L17 |
| [MFLEX_WORK_PERFORMANCE_INPUT](MFLEX_WORK_PERFORMANCE_INPUT.md) | 웹 요청 | [MFLEX_WORK_PERFORMANCE_INPUT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MFLEX_WORK_PERFORMANCE_INPUT/Layout/MFLEX_WORK_PERFORMANCE_INPUT.htm) L1978 |
| [MFLEX_WORK_PLAN_ESTABLISH](MFLEX_WORK_PLAN_ESTABLISH.md) | 웹 요청 | [MFLEX_WORK_PLAN_ESTABLISH.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MFLEX_WORK_PLAN_ESTABLISH/Layout/MFLEX_WORK_PLAN_ESTABLISH.htm) L1590 |
| [MFLEX_WORK_PLAN_VIEW](MFLEX_WORK_PLAN_VIEW.md) | 웹 요청 | [MFLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MFLEX_WORK_PLAN_VIEW/Layout/MFLEX_WORK_PLAN_VIEW.htm) L1193 |
| [MORD_OT_INSERT](MORD_OT_INSERT.md) | 웹 요청 | [MORD_OT_INSERT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_INSERT/Layout/MORD_OT_INSERT.htm) L2474 |
| [MORD_OT_INSERT_new](MORD_OT_INSERT_new.md) | 웹 요청 | [MORD_OT_INSERT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_INSERT_new/Layout/MORD_OT_INSERT_new.htm) L1548 |
| [MORD_OT_MODIFY](MORD_OT_MODIFY.md) | 웹 요청 | [MORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY/Layout/MORD_OT_MODIFY.htm) L2148 |
| [MORD_OT_MODIFY_new](MORD_OT_MODIFY_new.md) | 웹 요청 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L1234 |
| [MZH4110F01](MZH4110F01.md) | 직접 호출 | [MZH4110F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110F01/source/MZH4110F01.abap) L530 |
| [MZH4110I01](MZH4110I01.md) | 직접 호출 | [MZH4110I01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110I01/source/MZH4110I01.abap) L171 |
| [ORD_OT_INSERT](ORD_OT_INSERT.md) | 웹 요청 | [ORD_OT_INSERT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_INSERT/Layout/ORD_OT_INSERT.htm) L2364 |
| [ORD_OT_MODIFY](ORD_OT_MODIFY.md) | 웹 요청 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2033 |
| [ORD_OT_TIME](ORD_OT_TIME.md) | 웹 요청 | [ORD_OT_TIME.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_TIME/Layout/ORD_OT_TIME.htm) L1906 |
| [ZHR_52TM_CALC_WORK_TIME_DAYILY](ZHR_52TM_CALC_WORK_TIME_DAYILY.md) | 직접 호출 | [ZHR_52TM_CALC_WORK_TIME_DAYILY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Source%20code/ZHR_52TM_CALC_WORK_TIME_DAYILY.abap) L91 |
| [ZHR_52TM_MOBILE_OVERTIME_DETL](ZHR_52TM_MOBILE_OVERTIME_DETL.md) | 직접 호출 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L159 |
| [ZHR_52TM_SET_BREAK_TIME](ZHR_52TM_SET_BREAK_TIME.md) | 직접 호출 | [ZHR_52TM_SET_BREAK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_BREAK_TIME/Source%20code/ZHR_52TM_SET_BREAK_TIME.abap) L61, 99 |
| [ZHR_52TM_SET_DEFAULT_TIME](ZHR_52TM_SET_DEFAULT_TIME.md) | 직접 호출 | [ZHR_52TM_SET_DEFAULT_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Source%20code/ZHR_52TM_SET_DEFAULT_TIME.abap) L196, 340 |
| [temp](temp.md) | 웹 요청 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L2043 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
