---
title: "ZHR_52TM_PLAN_WORK_TIME — 탄력근로 계획 요청"
as_of: 2026-10-07
review_status: pending_business_review
tags: [근무현황조회, 탄력근무, 통합결재, 특별연장재난방송, 휴가공가반차]
---

# ZHR_52TM_PLAN_WORK_TIME — 탄력근로 계획 요청

[소스 설명 목차](INDEX.md) · [원본 파일](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap)

조회·저장·상신·회수 분기. 탄력 계획과 선택 실적은 다른 경로다.

확인 수준: 표시한 소스 구간 정적 확인; 운영 실행 검증 아님. 원본 경로·파일은 그대로 유지한다.

## 근거 위치

| 위치 | 관계의 의미 | 근거 구문 |
|---|---|---|
| 144행 | 계획 저장 | `PERFORM get_plan_save TABLES t_daily t_total` |
| 158행 | 계획 상신 검사 | `PERFORM check_plan_approve TABLES t_daily t_total` |
| 187행 | 외부 WF 회수 호출 | `CALL FUNCTION 'ZWF_DELETE'` |

## 관련 업무

<!-- topics -->
- [탄력근로 계획·결재](../topics/flexible.md) — 이 소스를 검토하는 업무 지도.

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 근무계획관리.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Changing.xml) | 118행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Exception.xml) | 118행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Export.xml) | 185행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Import.xml) | 259행; 원본 보존 |
| [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) | 342행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Tables.xml) | 141행; 원본 보존 |
| [../../../Include/LZHR008_2U08.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U08.abap) | 342행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U08.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U08.abap) L1 | LZHR008_2U08: API 본문과 행말 공백 제외 본문 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_PERNR` | ZPERNR0 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Export.xml) L8 |
| Export | `E_NAME` | ZCOPERSON | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Export.xml) L19 |
| Export | `E_ZCOSA` | ZPERNR0 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Export.xml) L30 |
| Export | `E_ZCOPE` | ZCOPERSON | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Export.xml) L41 |
| Export | `E_CORGTX` | CHAR50 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Export.xml) L52 |
| Export | `E_RETURN` | BAPIRETURN1 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Export.xml) L63 |
| Import | `I_ZGUBUN` | CHAR01 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Import.xml) L8 |
| Import | `I_PERNR` | PERSNO | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Import.xml) L22 |
| Import | `I_BEGDA` | BEGDA | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Import.xml) L36 |
| Import | `I_ENDDA` | ENDDA | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Import.xml) L50 |
| Import | `I_Z52WKTP` | [ZE52WKTP](ZE52WKTP.md) | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Import.xml) L64 |
| Import | `I_Z52PRSQ` | [ZE52PRSQ](ZE52PRSQ.md) | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Import.xml) L78 |
| Import | `I_ZPLWKHR_TY` | [ZEPLWKHR_TY](ZEPLWKHR_TY.md) | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Import.xml) L92 |
| Import | `I_STATE` | ZSTATE_1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Import.xml) L106 |
| Import | `I_SEQNR` | SEQNR | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Import.xml) L120 |
| Import | `I_ZDAILY` | CHAR01 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Import.xml) L134 |
| Tables | `T_DAILY` | [ZSHR0110](ZSHR0110.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Tables.xml) L8 |
| Tables | `T_TOTAL` | [ZSHR0109](ZSHR0109.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Tables.xml) L19 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — CHECK_PLAN_APPROVE: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L817; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L158 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — GET_DOMAIN: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L151; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L59, 106, 204, 208, 280 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — GET_PLAN_SAVE: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L533; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L144, 330 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — SEND_MAIL: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L2772; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L293 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — SET_0101: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L1081; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L166, 231 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — SET_PLAN_TIME_ZCOPE: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L2862; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L70 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — SET_STATE: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L491; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L90 |
| [PA0001](EXTERNAL_DEPENDENCIES.md#PA0001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L78 |
| [PA9021](PA9021.md) | **데이터 저장** — DELETE DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L274 |
| [PA9021](PA9021.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L268 |
| [PA9021](PA9021.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L35 |
| [ZCOPERSON](EXTERNAL_DEPENDENCIES.md#ZCOPERSON) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Export.xml) L23, 45 |
| [ZE52PRSQ](ZE52PRSQ.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Import.xml) L85 |
| [ZE52WKTP](ZE52WKTP.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Import.xml) L71 |
| [ZE52WKTP](ZE52WKTP.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L42 |
| [ZE52WKTXT](ZE52WKTXT.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L43 |
| [ZEPLWKHR_TY](ZEPLWKHR_TY.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Import.xml) L99 |
| [ZPERNR0](EXTERNAL_DEPENDENCIES.md#ZPERNR0) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Export.xml) L12, 34 |
| [ZSHR0101](ZSHR0101.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L38 |
| [ZSHR0109](ZSHR0109.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Tables.xml) L20 |
| [ZSHR0110](ZSHR0110.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Tables.xml) L9 |
| [ZSTATE_1](EXTERNAL_DEPENDENCIES.md#ZSTATE_1) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Import.xml) L113 |
| [ZTHR0106](ZTHR0106.md) | **데이터 저장** — MODIFY DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L212, 285 |
| [ZTHR0106](ZTHR0106.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L94, 172, 250 |
| [ZTHR0106](ZTHR0106.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L28 |
| [ZTHR0107](ZTHR0107.md) | **데이터 저장** — DELETE FROM DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L323 |
| [ZTHR0107](ZTHR0107.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L114 |
| [ZTHR0107](ZTHR0107.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L31 |
| [ZTHR0110](ZTHR0110.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L234 |
| [ZTHR0110](ZTHR0110.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L33 |
| [ZWF_DELETE](EXT-ZWF_DELETE.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L187 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [FLEX_WORK_PERFORMANCE_INPUT](FLEX_WORK_PERFORMANCE_INPUT.md) | 웹 요청 | [FLEX_WORK_PERFORMANCE_INPUT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PERFORMANCE_INPUT/Layout/FLEX_WORK_PERFORMANCE_INPUT.htm) L2130 |
| [FLEX_WORK_PERFORMANCE_INPUT_ADM](FLEX_WORK_PERFORMANCE_INPUT_ADM.md) | 웹 요청 | [FLEX_WORK_PERFORMANCE_INPUT_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PERFORMANCE_INPUT_ADM/Layout/FLEX_WORK_PERFORMANCE_INPUT_ADM.htm) L2160 |
| [FLEX_WORK_PLAN_ESTABLISH](FLEX_WORK_PLAN_ESTABLISH.md) | 웹 요청 | [FLEX_WORK_PLAN_ESTABLISH.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_ESTABLISH/Layout/FLEX_WORK_PLAN_ESTABLISH.htm) L1633, 1757, 1773, 2069 |
| [FLEX_WORK_PLAN_LIST](FLEX_WORK_PLAN_LIST.md) | 웹 요청 | [FLEX_WORK_PLAN_LIST.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_LIST/Layout/FLEX_WORK_PLAN_LIST.htm) L176 |
| [FLEX_WORK_PLAN_LIST_ADM](FLEX_WORK_PLAN_LIST_ADM.md) | 웹 요청 | [FLEX_WORK_PLAN_LIST_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_LIST_ADM/Layout/FLEX_WORK_PLAN_LIST_ADM.htm) L239 |
| [FLEX_WORK_PLAN_VIEW](FLEX_WORK_PLAN_VIEW.md) | 웹 요청 | [FLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW/Layout/FLEX_WORK_PLAN_VIEW.htm) L787, 887 |
| [FLEX_WORK_PLAN_VIEW2](FLEX_WORK_PLAN_VIEW2.md) | 웹 요청 | [FLEX_WORK_PLAN_VIEW2.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW2/Layout/FLEX_WORK_PLAN_VIEW2.htm) L270, 336 |
| [FLEX_WORK_PLAN_VIEW_ADM](FLEX_WORK_PLAN_VIEW_ADM.md) | 웹 요청 | [FLEX_WORK_PLAN_VIEW_ADM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_VIEW_ADM/Layout/FLEX_WORK_PLAN_VIEW_ADM.htm) L819, 919 |
| [LZHR008_2F01](LZHR008_2F01.md) | 직접 호출 | [LZHR008_2F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap) L1165, 1712 |
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L19 |
| [MFLEX_WORK_PERFORMANCE_INPUT](MFLEX_WORK_PERFORMANCE_INPUT.md) | 웹 요청 | [MFLEX_WORK_PERFORMANCE_INPUT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MFLEX_WORK_PERFORMANCE_INPUT/Layout/MFLEX_WORK_PERFORMANCE_INPUT.htm) L2252 |
| [MFLEX_WORK_PLAN_ESTABLISH](MFLEX_WORK_PLAN_ESTABLISH.md) | 웹 요청 | [MFLEX_WORK_PLAN_ESTABLISH.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MFLEX_WORK_PLAN_ESTABLISH/Layout/MFLEX_WORK_PLAN_ESTABLISH.htm) L1903, 2027, 2043, 2339 |
| [MFLEX_WORK_PLAN_LIST](MFLEX_WORK_PLAN_LIST.md) | 웹 요청 | [MFLEX_WORK_PLAN_LIST.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MFLEX_WORK_PLAN_LIST/Layout/MFLEX_WORK_PLAN_LIST.htm) L187 |
| [MFLEX_WORK_PLAN_VIEW](MFLEX_WORK_PLAN_VIEW.md) | 웹 요청 | [MFLEX_WORK_PLAN_VIEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MFLEX_WORK_PLAN_VIEW/Layout/MFLEX_WORK_PLAN_VIEW.htm) L854, 954 |
| [ZHR_52TM_PLAN_TO_RESULT](ZHR_52TM_PLAN_TO_RESULT.md) | 직접 호출 | [ZHR_52TM_PLAN_TO_RESULT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_TO_RESULT/Source%20code/ZHR_52TM_PLAN_TO_RESULT.abap) L33 |

### 관련 업무와 미확인 범위

- [flexible](../topics/flexible.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
