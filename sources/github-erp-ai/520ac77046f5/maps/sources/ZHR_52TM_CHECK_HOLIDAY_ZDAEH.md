---
title: "ZHR_52TM_CHECK_HOLIDAY_ZDAEH — [52시간] 대휴발생여부 체크"
as_of: 2026-10-07
review_status: pending_business_review
tags: [근로시간알림, 대휴익휴보상휴가, 탄력근무, 특별연장재난방송]
---

# ZHR_52TM_CHECK_HOLIDAY_ZDAEH — [52시간] 대휴발생여부 체크

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 대휴발생여부 체크.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Changing.xml) | 46행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Exception.xml) | 46행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Export.xml) | 91행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Import.xml) | 75행; 원본 보존 |
| [ZHR_52TM_CHECK_HOLIDAY_ZDAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Source%20code/ZHR_52TM_CHECK_HOLIDAY_ZDAEH.abap) | 146행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Tables.xml) | 46행; 원본 보존 |
| [../../../Include/LZHR008_2U11.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U11.abap) | 146행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U11.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U11.abap) L1 | LZHR008_2U11: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_ZDAEH` | [ZEDAEH](ZEDAEH.md) | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Export.xml) L8 |
| Export | `E_ZDAEH_DAY` | [ZEDAEH_DAY](ZEDAEH_DAY.md) | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Export.xml) L19 |
| Export | `E_RETURN` | BAPIRETURN1 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Export.xml) L30 |
| Export | `E_ENFO` | CHAR1 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Export.xml) L41 |
| Import | `I_ZGUBUN` | CHAR01 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Import.xml) L8 |
| Import | `IS_ZSHR0117` | [ZSHR0117](ZSHR0117.md) | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Import.xml) L22 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — CHECK_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L1649; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CHECK_HOLIDAY_ZDAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Source%20code/ZHR_52TM_CHECK_HOLIDAY_ZDAEH.abap) L34 |
| [LZHR008_2F02](LZHR008_2F02.md) | **FORM 호출** — CHECK_PRV_DAEH: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F02.abap L276; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CHECK_HOLIDAY_ZDAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Source%20code/ZHR_52TM_CHECK_HOLIDAY_ZDAEH.abap) L52 |
| [RH_GET_DATE_DAYNAME](EXTERNAL_DEPENDENCIES.md#RH_GET_DATE_DAYNAME) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CHECK_HOLIDAY_ZDAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Source%20code/ZHR_52TM_CHECK_HOLIDAY_ZDAEH.abap) L60 |
| [ZEDAEH](ZEDAEH.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Export.xml) L12 |
| [ZEDAEH_DAY](ZEDAEH_DAY.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Export.xml) L23 |
| [ZSHR0115](ZSHR0115.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CHECK_HOLIDAY_ZDAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Source%20code/ZHR_52TM_CHECK_HOLIDAY_ZDAEH.abap) L15 |
| [ZSHR0117](ZSHR0117.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Import.xml) L29 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 저장** — DELETE FROM DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZHR_52TM_CHECK_HOLIDAY_ZDAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Source%20code/ZHR_52TM_CHECK_HOLIDAY_ZDAEH.abap) L125 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_CHECK_HOLIDAY_ZDAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Source%20code/ZHR_52TM_CHECK_HOLIDAY_ZDAEH.abap) L104 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [FLEX_WORK_PERFORMANCE_INPUT](FLEX_WORK_PERFORMANCE_INPUT.md) | 웹 요청 | [FLEX_WORK_PERFORMANCE_INPUT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PERFORMANCE_INPUT/Layout/FLEX_WORK_PERFORMANCE_INPUT.htm) L2043 |
| [FLEX_WORK_PERFORMANCE_INPUT_ADM](FLEX_WORK_PERFORMANCE_INPUT_ADM.md) | 웹 요청 | [FLEX_WORK_PERFORMANCE_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PERFORMANCE_INPUT_ADM/Layout/FLEX_WORK_PERFORMANCE_INPUT_ADM.htm) L2073 |
| [LZHR008_2F01](LZHR008_2F01.md) | 직접 호출 | [LZHR008_2F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap) L2689 |
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L49 |
| [MFLEX_WORK_PERFORMANCE_INPUT](MFLEX_WORK_PERFORMANCE_INPUT.md) | 웹 요청 | [MFLEX_WORK_PERFORMANCE_INPUT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MFLEX_WORK_PERFORMANCE_INPUT/Layout/MFLEX_WORK_PERFORMANCE_INPUT.htm) L2165 |
| [ZHR_52TM_REAL_WORK_TIME](ZHR_52TM_REAL_WORK_TIME.md) | 직접 호출 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L421 |

### 관련 업무와 미확인 범위

- [rest](../topics/rest.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
