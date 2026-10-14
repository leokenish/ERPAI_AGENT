---
title: "ZHR_52TM_DAILY_WEEKLY_BUSEO — [52시간] 부서별 선택근로 기간별 누적시간"
as_of: 2026-10-07
review_status: pending_business_review
tags: [근무현황조회, 선택근무]
---

# ZHR_52TM_DAILY_WEEKLY_BUSEO — [52시간] 부서별 선택근로 기간별 누적시간

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 부서별 선택근로 기간별 누적시간.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Changing.xml) | 46행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Exception.xml) | 46행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Export.xml) | 69행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Import.xml) | 89행; 원본 보존 |
| [ZHR_52TM_DAILY_WEEKLY_BUSEO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Source%20code/ZHR_52TM_DAILY_WEEKLY_BUSEO.abap) | 292행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Tables.xml) | 58행; 원본 보존 |
| [../../../Include/LZHR008_2U65.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U65.abap) | 292행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U65.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U65.abap) L1 | LZHR008_2U65: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_CODE` | CHAR03 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Export.xml) L8 |
| Export | `E_TEXT` | CHAR200 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Export.xml) L19 |
| Import | `I_OBJID` | OBJID | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Import.xml) L8 |
| Import | `I_DATUM` | D | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Import.xml) L22 |
| Import | `I_SORT` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Import.xml) L36 |
| Tables | `T_LIST` | [ZSHR0132_WEB](ZSHR0132_WEB.md) | — | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Tables.xml) L8 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [RHPH_STRUCTURE_READ](EXTERNAL_DEPENDENCIES.md#RHPH_STRUCTURE_READ) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_DAILY_WEEKLY_BUSEO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Source%20code/ZHR_52TM_DAILY_WEEKLY_BUSEO.abap) L96 |
| [ZHR_52TM_CW_GET_DATA](ZHR_52TM_CW_GET_DATA.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_DAILY_WEEKLY_BUSEO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Source%20code/ZHR_52TM_DAILY_WEEKLY_BUSEO.abap) L136 |
| [ZHR_52TM_WEEKLY_ZEMCWK](ZHR_52TM_WEEKLY_ZEMCWK.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_DAILY_WEEKLY_BUSEO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Source%20code/ZHR_52TM_DAILY_WEEKLY_BUSEO.abap) L146 |
| [ZHR_GET_PERSONNEL_BASIC_INFO](EXTERNAL_DEPENDENCIES.md#ZHR_GET_PERSONNEL_BASIC_INFO) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_DAILY_WEEKLY_BUSEO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Source%20code/ZHR_52TM_DAILY_WEEKLY_BUSEO.abap) L160 |
| [ZSHR0132_WEB](ZSHR0132_WEB.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Tables.xml) L9 |
| [ZSHR0144](ZSHR0144.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_DAILY_WEEKLY_BUSEO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Source%20code/ZHR_52TM_DAILY_WEEKLY_BUSEO.abap) L16 |
| [ZTH0076](EXTERNAL_DEPENDENCIES.md#ZTH0076) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_DAILY_WEEKLY_BUSEO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Source%20code/ZHR_52TM_DAILY_WEEKLY_BUSEO.abap) L75 |
| [ZTHR0112](ZTHR0112.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_DAILY_WEEKLY_BUSEO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Source%20code/ZHR_52TM_DAILY_WEEKLY_BUSEO.abap) L208 |
| [ZTHR0112](ZTHR0112.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_DAILY_WEEKLY_BUSEO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Source%20code/ZHR_52TM_DAILY_WEEKLY_BUSEO.abap) L39, 51, 52, 53 |
| [ZTHR0132](ZTHR0132.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_DAILY_WEEKLY_BUSEO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Source%20code/ZHR_52TM_DAILY_WEEKLY_BUSEO.abap) L126, 205 |
| [ZTHR0132](ZTHR0132.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_DAILY_WEEKLY_BUSEO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Source%20code/ZHR_52TM_DAILY_WEEKLY_BUSEO.abap) L15 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L133 |
| [ZRPTH440](ZRPTH440.md) | 직접 호출 | [ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) L461 |

### 관련 업무와 미확인 범위

- [reporting](../topics/reporting.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
