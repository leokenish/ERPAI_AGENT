---
title: "ZHR_52TM_GET_WORKSCHEDULE_TIME — [52시간] 워크스케쥴로부터 근무계획시간 조회"
as_of: 2026-10-07
review_status: pending_business_review
---

# ZHR_52TM_GET_WORKSCHEDULE_TIME — [52시간] 워크스케쥴로부터 근무계획시간 조회

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 워크스케쥴로부터 근무계획시간 조회.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_WORKSCHEDULE_TIME/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_WORKSCHEDULE_TIME/Changing.xml) | 34행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_WORKSCHEDULE_TIME/Exception.xml) | 34행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_WORKSCHEDULE_TIME/Export.xml) | 46행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_WORKSCHEDULE_TIME/Import.xml) | 77행; 원본 보존 |
| [ZHR_52TM_GET_WORKSCHEDULE_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_WORKSCHEDULE_TIME/Source%20code/ZHR_52TM_GET_WORKSCHEDULE_TIME.abap) | 63행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_WORKSCHEDULE_TIME/Tables.xml) | 34행; 원본 보존 |
| [../../../Include/LZHR008_2U64.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U64.abap) | 63행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U64.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U64.abap) L1 | LZHR008_2U64: API 본문과 행말 공백 제외 본문 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `O_PLANTIME` | ZCHAR06 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_WORKSCHEDULE_TIME/Export.xml) L8 |
| Import | `I_PERNR` | PERSNO | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_WORKSCHEDULE_TIME/Import.xml) L8 |
| Import | `I_BEGDA` | BEGDA | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_WORKSCHEDULE_TIME/Import.xml) L22 |
| Import | `I_ENDDA` | ENDDA | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_WORKSCHEDULE_TIME/Import.xml) L36 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZCHAR06](EXTERNAL_DEPENDENCIES.md#ZCHAR06) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_WORKSCHEDULE_TIME/Export.xml) L12 |
| [ZHR_SUM_TIME_N](EXTERNAL_DEPENDENCIES.md#ZHR_SUM_TIME_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_GET_WORKSCHEDULE_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_WORKSCHEDULE_TIME/Source%20code/ZHR_52TM_GET_WORKSCHEDULE_TIME.abap) L45 |
| [ZTHRWORKSCHEDULE](EXT-ZTHRWORKSCHEDULE.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_GET_WORKSCHEDULE_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_WORKSCHEDULE_TIME/Source%20code/ZHR_52TM_GET_WORKSCHEDULE_TIME.abap) L23 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L131 |
| [ZHR_52TM_CALC_WEEK_TIME](ZHR_52TM_CALC_WEEK_TIME.md) | 직접 호출 | [ZHR_52TM_CALC_WEEK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Source%20code/ZHR_52TM_CALC_WEEK_TIME.abap) L168 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
