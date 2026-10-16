---
title: "ZHR_52TM_PERSONAL_WORK_TIME — [52시간] 개인별 계획/실적 근무시간 정보"
as_of: 2026-10-07
review_status: pending_business_review
tags: [IAM등록기본설정, 교대근무, 근무현황조회, 통상시차시간외]
---

# ZHR_52TM_PERSONAL_WORK_TIME — [52시간] 개인별 계획/실적 근무시간 정보

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 개인별 계획/실적 근무시간 정보.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Changing.xml) | 52행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Exception.xml) | 52행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Export.xml) | 64행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Import.xml) | 109행; 원본 보존 |
| [ZHR_52TM_PERSONAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Source%20code/ZHR_52TM_PERSONAL_WORK_TIME.abap) | 370행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Tables.xml) | 75행; 원본 보존 |
| [../../../Include/LZHR008_2U34.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U34.abap) | 370행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U34.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U34.abap) L1 | LZHR008_2U34: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_RETURN` | BAPIRETURN1 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Export.xml) L8 |
| Import | `I_PERNR` | PERSNO | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Import.xml) L8 |
| Import | `I_BEGDA` | BEGDA | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Import.xml) L22 |
| Import | `I_ENDDA` | ENDDA | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Import.xml) L36 |
| Import | `I_FLEXT` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Import.xml) L50 |
| Tables | `LT_INFO` | [ZSHR0119](ZSHR0119.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Tables.xml) L8 |
| Tables | `LT_DATA` | [ZSHR0122](ZSHR0122.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Tables.xml) L19 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [DAY_ATTRIBUTES_GET](EXTERNAL_DEPENDENCIES.md#DAY_ATTRIBUTES_GET) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_PERSONAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Source%20code/ZHR_52TM_PERSONAL_WORK_TIME.abap) L119 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — GET_DIFF_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L2037; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_PERSONAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Source%20code/ZHR_52TM_PERSONAL_WORK_TIME.abap) L156, 293 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — GET_DOMAIN: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L151; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_PERSONAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Source%20code/ZHR_52TM_PERSONAL_WORK_TIME.abap) L328, 338, 351 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — GET_OPTION_REAL: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L2389; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_PERSONAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Source%20code/ZHR_52TM_PERSONAL_WORK_TIME.abap) L104 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — GET_PLAN_TO_REAL: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L2359; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_PERSONAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Source%20code/ZHR_52TM_PERSONAL_WORK_TIME.abap) L98 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — GET_ZPLWK_TM: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L2427; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_PERSONAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Source%20code/ZHR_52TM_PERSONAL_WORK_TIME.abap) L111 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — MAKE_BREAK_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L2525; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_PERSONAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Source%20code/ZHR_52TM_PERSONAL_WORK_TIME.abap) L151, 288 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — SET_TIME1: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L2496; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_PERSONAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Source%20code/ZHR_52TM_PERSONAL_WORK_TIME.abap) L145, 148 |
| [ZEPDWK_TM](ZEPDWK_TM.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_PERSONAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Source%20code/ZHR_52TM_PERSONAL_WORK_TIME.abap) L32 |
| [ZEPLWK_TM](ZEPLWK_TM.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_PERSONAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Source%20code/ZHR_52TM_PERSONAL_WORK_TIME.abap) L31 |
| [ZHR_52TM_WKTYPE_PERIOD](ZHR_52TM_WKTYPE_PERIOD.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_PERSONAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Source%20code/ZHR_52TM_PERSONAL_WORK_TIME.abap) L46 |
| [ZHR_GET_DAY_DATA](EXTERNAL_DEPENDENCIES.md#ZHR_GET_DAY_DATA) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_PERSONAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Source%20code/ZHR_52TM_PERSONAL_WORK_TIME.abap) L191 |
| [ZSHR0119](ZSHR0119.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Tables.xml) L9 |
| [ZSHR0119](ZSHR0119.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_PERSONAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Source%20code/ZHR_52TM_PERSONAL_WORK_TIME.abap) L20, 21 |
| [ZSHR0122](ZSHR0122.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Tables.xml) L20 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_PERSONAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Source%20code/ZHR_52TM_PERSONAL_WORK_TIME.abap) L174, 303 |
| [ZTHRWORKSCHEDULE](EXT-ZTHRWORKSCHEDULE.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_PERSONAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Source%20code/ZHR_52TM_PERSONAL_WORK_TIME.abap) L267 |
| [ZTHR_FLEX_WORK](EXTERNAL_DEPENDENCIES.md#ZTHR_FLEX_WORK) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_PERSONAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Source%20code/ZHR_52TM_PERSONAL_WORK_TIME.abap) L137 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L71 |
| [ZHR_52TM_REAL_WORK_TIME_TEAM](ZHR_52TM_REAL_WORK_TIME_TEAM.md) | 직접 호출 | [ZHR_52TM_REAL_WORK_TIME_TEAM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME_TEAM/Source%20code/ZHR_52TM_REAL_WORK_TIME_TEAM.abap) L191 |
| [ZHR_52TM_REAL_WORK_TIME_TEAM_M](ZHR_52TM_REAL_WORK_TIME_TEAM_M.md) | 직접 호출 | [ZHR_52TM_REAL_WORK_TIME_TEAM_M.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME_TEAM_M/Source%20code/ZHR_52TM_REAL_WORK_TIME_TEAM_M.abap) L195 |
| [ZHR_52TM_SET_DEFAULT_TIME](ZHR_52TM_SET_DEFAULT_TIME.md) | 직접 호출 | [ZHR_52TM_SET_DEFAULT_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Source%20code/ZHR_52TM_SET_DEFAULT_TIME.abap) L86 |
| [ZRPTH405F01](ZRPTH405F01.md) | 직접 호출 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L585 |

### 관련 업무와 미확인 범위

- [reporting](../topics/reporting.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
