---
title: "ZHR_52TM_DAILY_APPROVAL_DETAIL — [52시간] 선택근로 결재 리스트"
as_of: 2026-10-07
review_status: pending_business_review
tags: [선택근무, 통합결재]
---

# ZHR_52TM_DAILY_APPROVAL_DETAIL — [52시간] 선택근로 결재 리스트

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 선택근로 결재 리스트.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Changing.xml) | 46행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Exception.xml) | 46행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Export.xml) | 91행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Import.xml) | 75행; 원본 보존 |
| [ZHR_52TM_DAILY_APPROVAL_DETAIL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Source%20code/ZHR_52TM_DAILY_APPROVAL_DETAIL.abap) | 178행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Tables.xml) | 46행; 원본 보존 |
| [../../../Include/LZHR008_2U61.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U61.abap) | 178행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U61.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U61.abap) L1 | LZHR008_2U61: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_CODE` | CHAR03 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Export.xml) L8 |
| Export | `E_TEXT` | CHAR200 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Export.xml) L19 |
| Export | `GS_LIST` | ZWF0022 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Export.xml) L30 |
| Export | `GS_LIST1` | [ZSHR0134](ZSHR0134.md) | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Export.xml) L41 |
| Import | `I_WI_ID` | SWW_WIID | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Import.xml) L8 |
| Import | `I_KEY12` | SWW_WIID | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Import.xml) L22 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [DD07T](EXTERNAL_DEPENDENCIES.md#DD07T) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_DAILY_APPROVAL_DETAIL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Source%20code/ZHR_52TM_DAILY_APPROVAL_DETAIL.abap) L71 |
| [RH_GET_DATE_DAYNAME](EXTERNAL_DEPENDENCIES.md#RH_GET_DATE_DAYNAME) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_DAILY_APPROVAL_DETAIL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Source%20code/ZHR_52TM_DAILY_APPROVAL_DETAIL.abap) L82 |
| [ZHR_52TM_CW_GET_DATA](ZHR_52TM_CW_GET_DATA.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_DAILY_APPROVAL_DETAIL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Source%20code/ZHR_52TM_DAILY_APPROVAL_DETAIL.abap) L106 |
| [ZHR_GET_PERSONNEL_DATA_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_PERSONNEL_DATA_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_DAILY_APPROVAL_DETAIL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Source%20code/ZHR_52TM_DAILY_APPROVAL_DETAIL.abap) L55 |
| [ZSHR0134](ZSHR0134.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Export.xml) L45 |
| [ZSHR0144](ZSHR0144.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_DAILY_APPROVAL_DETAIL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Source%20code/ZHR_52TM_DAILY_APPROVAL_DETAIL.abap) L18 |
| [ZTHR0112](ZTHR0112.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_DAILY_APPROVAL_DETAIL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Source%20code/ZHR_52TM_DAILY_APPROVAL_DETAIL.abap) L37 |
| [ZTHR0112](ZTHR0112.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_DAILY_APPROVAL_DETAIL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Source%20code/ZHR_52TM_DAILY_APPROVAL_DETAIL.abap) L35 |
| [ZWF0022](EXT-ZWF0022.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_DAILY_APPROVAL_DETAIL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Source%20code/ZHR_52TM_DAILY_APPROVAL_DETAIL.abap) L26 |
| [ZWF0022](EXT-ZWF0022.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVAL_DETAIL/Export.xml) L34 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [DAILY_OT_POP](DAILY_OT_POP.md) | 웹 요청 | [DAILY_OT_POP.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_OT_POP/Layout/DAILY_OT_POP.htm) L163 |
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L125 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
