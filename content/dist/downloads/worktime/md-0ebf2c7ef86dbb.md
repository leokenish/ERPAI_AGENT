---
title: "ZHR_52TM_NEW_SHIFTWORK_TIME — 교대근무 초과근무 입력 가능 여부 함수"
as_of: 2026-10-07
review_status: pending_business_review
tags: [교대근무, 통상시차시간외]
---

# ZHR_52TM_NEW_SHIFTWORK_TIME — 교대근무 초과근무 입력 가능 여부 함수

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: 교대근무 초과근무 입력 가능 여부 함수.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_SHIFTWORK_TIME/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_SHIFTWORK_TIME/Changing.xml) | 28행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_SHIFTWORK_TIME/Exception.xml) | 28행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_SHIFTWORK_TIME/Export.xml) | 51행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_SHIFTWORK_TIME/Import.xml) | 43행; 원본 보존 |
| [ZHR_52TM_NEW_SHIFTWORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_SHIFTWORK_TIME/Source%20code/ZHR_52TM_NEW_SHIFTWORK_TIME.abap) | 208행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_SHIFTWORK_TIME/Tables.xml) | 28행; 원본 보존 |
| [../../../Include/LZHR008_2U71.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U71.abap) | 208행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U71.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U71.abap) L1 | LZHR008_2U71: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_CODE` | CHAR3 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_SHIFTWORK_TIME/Export.xml) L8 |
| Export | `E_TEXT` | CHAR200 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_SHIFTWORK_TIME/Export.xml) L19 |
| Import | `LS_ZTHRBS01` | ZTHRBS01 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_SHIFTWORK_TIME/Import.xml) L8 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZHR_52TM_WEEK_FROM_TO_DATE](ZHR_52TM_WEEK_FROM_TO_DATE.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_NEW_SHIFTWORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_SHIFTWORK_TIME/Source%20code/ZHR_52TM_NEW_SHIFTWORK_TIME.abap) L39 |
| [ZHR_DAILY_VIEW_WS_GUN_RFC](EXTERNAL_DEPENDENCIES.md#ZHR_DAILY_VIEW_WS_GUN_RFC) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_NEW_SHIFTWORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_SHIFTWORK_TIME/Source%20code/ZHR_52TM_NEW_SHIFTWORK_TIME.abap) L82 |
| [ZHR_MINUS_TIME_N](EXTERNAL_DEPENDENCIES.md#ZHR_MINUS_TIME_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_NEW_SHIFTWORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_SHIFTWORK_TIME/Source%20code/ZHR_52TM_NEW_SHIFTWORK_TIME.abap) L177 |
| [ZHR_SUM_TIME_N](EXTERNAL_DEPENDENCIES.md#ZHR_SUM_TIME_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_NEW_SHIFTWORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_SHIFTWORK_TIME/Source%20code/ZHR_52TM_NEW_SHIFTWORK_TIME.abap) L116, 156, 166 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_NEW_SHIFTWORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_SHIFTWORK_TIME/Source%20code/ZHR_52TM_NEW_SHIFTWORK_TIME.abap) L140 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_SHIFTWORK_TIME/Import.xml) L15 |
| [ZTHRBS17](EXTERNAL_DEPENDENCIES.md#ZTHRBS17) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_NEW_SHIFTWORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_SHIFTWORK_TIME/Source%20code/ZHR_52TM_NEW_SHIFTWORK_TIME.abap) L190 |
| [ZTHRWORKSCHEDULE](EXT-ZTHRWORKSCHEDULE.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_NEW_SHIFTWORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_SHIFTWORK_TIME/Source%20code/ZHR_52TM_NEW_SHIFTWORK_TIME.abap) L49 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L149 |
| [ZHR_52TM_CHECK_INPUT_DATA](ZHR_52TM_CHECK_INPUT_DATA.md) | 직접 호출 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L365 |

### 관련 업무와 미확인 범위

- [ordinary](../topics/ordinary.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [shift](../topics/shift.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
