---
title: "ZHR_52TM_CW_REPORT_DATA — [52시간] 보고서 데이터 - 선택근로제"
as_of: 2026-10-07
review_status: pending_business_review
tags: [선택근무]
---

# ZHR_52TM_CW_REPORT_DATA — [52시간] 보고서 데이터 - 선택근로제

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 보고서 데이터 - 선택근로제.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_REPORT_DATA/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_REPORT_DATA/Changing.xml) | 52행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_REPORT_DATA/Exception.xml) | 52행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_REPORT_DATA/Export.xml) | 64행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_REPORT_DATA/Import.xml) | 123행; 원본 보존 |
| [ZHR_52TM_CW_REPORT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_REPORT_DATA/Source%20code/ZHR_52TM_CW_REPORT_DATA.abap) | 30행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_REPORT_DATA/Tables.xml) | 64행; 원본 보존 |
| [../../../Include/LZHR008_3U06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3U06.abap) | 30행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_3U06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3U06.abap) L1 | LZHR008_3U06: API 본문과 행말 공백 제외 본문 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_RETURN` | BAPIRETURN1 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_REPORT_DATA/Export.xml) L8 |
| Import | `I_CASE` | CHAR1 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_REPORT_DATA/Import.xml) L8 |
| Import | `I_PERNR` | PERSNO | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_REPORT_DATA/Import.xml) L22 |
| Import | `I_BEGDA` | BEGDA | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_REPORT_DATA/Import.xml) L36 |
| Import | `I_ENDDA` | ENDDA | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_REPORT_DATA/Import.xml) L50 |
| Import | `I_STATE` | ZSTATE_1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_REPORT_DATA/Import.xml) L64 |
| Tables | `LT_ZSHR0141` | [ZSHR0141](ZSHR0141.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_REPORT_DATA/Tables.xml) L8 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_3F04](LZHR008_3F04.md) | **FORM 호출** — A_CW_REPORT_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F04.abap L15; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_REPORT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_REPORT_DATA/Source%20code/ZHR_52TM_CW_REPORT_DATA.abap) L18 |
| [ZSHR0141](ZSHR0141.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_REPORT_DATA/Tables.xml) L9 |
| [ZSTATE_1](EXTERNAL_DEPENDENCIES.md#ZSTATE_1) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_REPORT_DATA/Import.xml) L71 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [DAILY_WORK_LIST](DAILY_WORK_LIST.md) | 웹 요청 | [DAILY_WORK_LIST.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_LIST/Layout/DAILY_WORK_LIST.htm) L184 |
| [DAILY_WORK_LIST_ADM](DAILY_WORK_LIST_ADM.md) | 웹 요청 | [DAILY_WORK_LIST_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_LIST_ADM/Layout/DAILY_WORK_LIST_ADM.htm) L258 |
| [LZHR008_3UXX](LZHR008_3UXX.md) | Include | [LZHR008_3UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3UXX.abap) L15 |
| [MDAILY_WORK_LIST](MDAILY_WORK_LIST.md) | 웹 요청 | [MDAILY_WORK_LIST.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_LIST/Layout/MDAILY_WORK_LIST.htm) L261 |
| [MDAILY_WORK_LIST_new](MDAILY_WORK_LIST_new.md) | 웹 요청 | [MDAILY_WORK_LIST_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_LIST_new/Layout/MDAILY_WORK_LIST_new.htm) L63 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
