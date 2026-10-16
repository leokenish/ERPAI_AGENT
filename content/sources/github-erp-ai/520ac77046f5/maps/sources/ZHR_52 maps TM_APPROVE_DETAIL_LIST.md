---
title: "ZHR_52TM_APPROVE_DETAIL_LIST — [52시간] 탄력근로 결재상세 조회"
as_of: 2026-10-07
review_status: pending_business_review
tags: [탄력근무, 통합결재]
---

# ZHR_52TM_APPROVE_DETAIL_LIST — [52시간] 탄력근로 결재상세 조회

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 탄력근로 결재상세 조회.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_DETAIL_LIST/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_DETAIL_LIST/Changing.xml) | 40행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_DETAIL_LIST/Exception.xml) | 40행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_DETAIL_LIST/Export.xml) | 74행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_DETAIL_LIST/Import.xml) | 69행; 원본 보존 |
| [ZHR_52TM_APPROVE_DETAIL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_DETAIL_LIST/Source%20code/ZHR_52TM_APPROVE_DETAIL_LIST.abap) | 244행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_DETAIL_LIST/Tables.xml) | 40행; 원본 보존 |
| [../../../Include/LZHR008_2U21.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U21.abap) | 244행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U21.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U21.abap) L1 | LZHR008_2U21: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `ES_WF0015` | [ZSWF0015](ZSWF0015.md) | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_DETAIL_LIST/Export.xml) L8 |
| Export | `E_CODE` | CHAR03 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_DETAIL_LIST/Export.xml) L19 |
| Export | `E_TEXT` | CHAR200 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_DETAIL_LIST/Export.xml) L30 |
| Import | `I_WI_ID` | SWW_WIID | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_DETAIL_LIST/Import.xml) L8 |
| Import | `I_KEY12` | SWW_WIID | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_DETAIL_LIST/Import.xml) L22 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — GET_DOMAIN: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L151; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_APPROVE_DETAIL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_DETAIL_LIST/Source%20code/ZHR_52TM_APPROVE_DETAIL_LIST.abap) L171, 211 |
| [ZHR_GET_PERSONNEL_DATA_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_PERSONNEL_DATA_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_APPROVE_DETAIL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_DETAIL_LIST/Source%20code/ZHR_52TM_APPROVE_DETAIL_LIST.abap) L50 |
| [ZHR_SUM_TIME_N](EXTERNAL_DEPENDENCIES.md#ZHR_SUM_TIME_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_APPROVE_DETAIL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_DETAIL_LIST/Source%20code/ZHR_52TM_APPROVE_DETAIL_LIST.abap) L130, 137 |
| [ZSWF0015](ZSWF0015.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_DETAIL_LIST/Export.xml) L12 |
| [ZTHR0106](ZTHR0106.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_APPROVE_DETAIL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_DETAIL_LIST/Source%20code/ZHR_52TM_APPROVE_DETAIL_LIST.abap) L71, 95, 201 |
| [ZTHR0110](ZTHR0110.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_APPROVE_DETAIL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_DETAIL_LIST/Source%20code/ZHR_52TM_APPROVE_DETAIL_LIST.abap) L83, 111, 119 |
| [ZTHR0110](ZTHR0110.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_APPROVE_DETAIL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_DETAIL_LIST/Source%20code/ZHR_52TM_APPROVE_DETAIL_LIST.abap) L16 |
| [ZWF0022](EXT-ZWF0022.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_APPROVE_DETAIL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_DETAIL_LIST/Source%20code/ZHR_52TM_APPROVE_DETAIL_LIST.abap) L29 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [FLEX_WORK_PERFORMANCE_VIEW](FLEX_WORK_PERFORMANCE_VIEW.md) | 웹 요청 | [FLEX_WORK_PERFORMANCE_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PERFORMANCE_VIEW/Layout/FLEX_WORK_PERFORMANCE_VIEW.htm) L132 |
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L43 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
