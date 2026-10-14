---
title: "ZHR_52TM_GET_SHIFT_OT_DATA — [52시간] 교대연장 실비 계산"
as_of: 2026-10-07
review_status: pending_business_review
tags: [교대근무, 시간외단가등급, 월정산전표지급]
---

# ZHR_52TM_GET_SHIFT_OT_DATA — [52시간] 교대연장 실비 계산

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 교대연장 실비 계산.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_SHIFT_OT_DATA/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_SHIFT_OT_DATA/Changing.xml) | 46행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_SHIFT_OT_DATA/Exception.xml) | 46행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_SHIFT_OT_DATA/Export.xml) | 80행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_SHIFT_OT_DATA/Import.xml) | 75행; 원본 보존 |
| [ZHR_52TM_GET_SHIFT_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_SHIFT_OT_DATA/Source%20code/ZHR_52TM_GET_SHIFT_OT_DATA.abap) | 171행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_SHIFT_OT_DATA/Tables.xml) | 58행; 원본 보존 |
| [../../../Include/LZHR008_2U66.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U66.abap) | 171행; 원본 보존 |

### 이번 업무 구간 검토

파일 판정: **후보**. 검토 범위: 단가·외부 스케줄·교대유형 및 반환항목; L58–171. 남은 범위: 이외 본문/모든 예외 분기 미검토; 운영 실행 미확인. 이는 이 파일/명시한 구간의 정적 분석이며 외부 함수·업무 전체·운영 검증 완료는 아니다.

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U66.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U66.abap) L1 | LZHR008_2U66: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_ZSHIFT_DATA` | ZSH_SHIFT_OT | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_SHIFT_OT_DATA/Export.xml) L8 |
| Export | `E_ERROR_CODE` | CHAR01 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_SHIFT_OT_DATA/Export.xml) L19 |
| Export | `E_ERROR_TEXT` | CHAR200 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_SHIFT_OT_DATA/Export.xml) L30 |
| Import | `I_PERNR` | PERSNO | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_SHIFT_OT_DATA/Import.xml) L8 |
| Import | `I_SPMON` | SPMON | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_SHIFT_OT_DATA/Import.xml) L22 |
| Tables | `IT_ZTHRSILT` | ZTHRSILT | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_SHIFT_OT_DATA/Tables.xml) L8 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [RP_LAST_DAY_OF_MONTHS](EXTERNAL_DEPENDENCIES.md#RP_LAST_DAY_OF_MONTHS) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_GET_SHIFT_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_SHIFT_OT_DATA/Source%20code/ZHR_52TM_GET_SHIFT_OT_DATA.abap) L64 |
| [ZHR_GET_PERSONNEL_RANK_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_PERSONNEL_RANK_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_GET_SHIFT_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_SHIFT_OT_DATA/Source%20code/ZHR_52TM_GET_SHIFT_OT_DATA.abap) L72 |
| [ZHR_GET_SHIFT_WORKER_DATA](EXT-ZHR_GET_SHIFT_WORKER_DATA.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_GET_SHIFT_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_SHIFT_OT_DATA/Source%20code/ZHR_52TM_GET_SHIFT_OT_DATA.abap) L102 |
| [ZSH_SHIFT_OT](EXTERNAL_DEPENDENCIES.md#ZSH_SHIFT_OT) | **타입 참조** — DBFIELD XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_SHIFT_OT_DATA/Export.xml) L9 |
| [ZTHR2006_1_NEW](EXT-ZTHR2006_1_NEW.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_GET_SHIFT_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_SHIFT_OT_DATA/Source%20code/ZHR_52TM_GET_SHIFT_OT_DATA.abap) L44 |
| [ZTHRCOST](EXT-ZTHRCOST.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_GET_SHIFT_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_SHIFT_OT_DATA/Source%20code/ZHR_52TM_GET_SHIFT_OT_DATA.abap) L87 |
| [ZTHRSILT](EXTERNAL_DEPENDENCIES.md#ZTHRSILT) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_SHIFT_OT_DATA/Tables.xml) L9 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L135 |
| [ZRPTH422](ZRPTH422.md) | 직접 호출 | [ZRPTH422.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH422/source/ZRPTH422.abap) L427 |

### 관련 업무와 미확인 범위

- [rates](../topics/rates.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [shift](../topics/shift.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
