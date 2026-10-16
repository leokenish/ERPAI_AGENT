---
title: "ZHR_52TM_GET_OVERTIME_SAVE — 시간외 저장 데이터 생성"
as_of: 2026-10-07
review_status: pending_business_review
tags: [교대근무, 통상시차시간외, 통합결재, 퇴직자관리자입력검토]
---

# ZHR_52TM_GET_OVERTIME_SAVE — 시간외 저장 데이터 생성

[소스 설명 목차](INDEX.md) · [원본 파일](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Source%20code/ZHR_52TM_GET_OVERTIME_SAVE.abap)

입력 데이터를 계산 함수로 전달하는 경로. 대휴 분할 등 전체 분기 검증은 별도다.

확인 수준: 표시한 소스 구간 정적 확인; 운영 실행 검증 아님. 원본 경로·파일은 그대로 유지한다.

## 근거 위치

| 위치 | 관계의 의미 | 근거 구문 |
|---|---|---|
| 40행 | 시간·실비 계산 호출 | `CALL FUNCTION 'ZHR_52TM_GET_OVERTIME_DATA'` |

## 연결된 소스

- [ZHR_52TM_GET_OVERTIME_DATA](ZHR_52TM_GET_OVERTIME_DATA.md) — 함수 호출 확인, 위 원본 40행. 호출 이후 전체 실행 성공은 미검증.

## 관련 업무

<!-- topics -->
- [통상·시차 시간외 입력](../topics/ordinary.md) — 이 소스를 검토하는 업무 지도.

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 통상/교대 시간외실비신청 저장 구조 생성.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Changing.xml) | 163행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Exception.xml) | 106행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Export.xml) | 129행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Import.xml) | 233행; 원본 보존 |
| [ZHR_52TM_GET_OVERTIME_SAVE.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Source%20code/ZHR_52TM_GET_OVERTIME_SAVE.abap) | 365행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Tables.xml) | 118행; 원본 보존 |
| [../../../Include/LZHR008_2U39.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U39.abap) | 365행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U39.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U39.abap) L1 | LZHR008_2U39: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Changing | `C_ZTOMOH` | CHAR1 | X | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Changing.xml) L8 |
| Changing | `C_ZDAEH` | CHAR1 | X | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Changing.xml) L22 |
| Changing | `C_ZTOICH` | CHAR1 | X | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Changing.xml) L36 |
| Changing | `C_ZEMCWK` | CHAR1 | X | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Changing.xml) L50 |
| Export | `E_CODE` | CHAR03 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Export.xml) L8 |
| Export | `E_TEXT` | CHAR200 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Export.xml) L19 |
| Import | `I_MODE` | CHAR01 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Import.xml) L8 |
| Import | `I_WKTYPE` | [ZEWKTYPE](ZEWKTYPE.md) | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Import.xml) L22 |
| Import | `I_ACTION` | SYUCOMM | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Import.xml) L36 |
| Import | `I_ZEXC` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Import.xml) L50 |
| Import | `I_MTYPE` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Import.xml) L64 |
| Import | `I_ZDIFF` | I | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Import.xml) L78 |
| Import | `I_RUN_R3` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Import.xml) L92 |
| Import | `IS_ZTHRBS01` | ZTHRBS01 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Import.xml) L106 |
| Import | `I_SEQNR` | SEQNR | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Import.xml) L120 |
| Tables | `T_DATA` | ZTHRBS01 | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Tables.xml) L8 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F05](LZHR008_2F05.md) | **FORM 호출** — GET_ZDAEH_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F05.abap L29; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_GET_OVERTIME_SAVE.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Source%20code/ZHR_52TM_GET_OVERTIME_SAVE.abap) L157, 192 |
| [LZHR008_2F05](LZHR008_2F05.md) | **FORM 호출** — SPLIT_OVERTIME_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F05.abap L87; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_GET_OVERTIME_SAVE.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Source%20code/ZHR_52TM_GET_OVERTIME_SAVE.abap) L181 |
| [ZEWKTYPE](ZEWKTYPE.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Import.xml) L29 |
| [ZHRDAEHUAMT](ZHRDAEHUAMT.md) | **데이터 저장** — DELETE FROM DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZHR_52TM_GET_OVERTIME_SAVE.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Source%20code/ZHR_52TM_GET_OVERTIME_SAVE.abap) L169, 212 |
| [ZHRDAEHUAMT](ZHRDAEHUAMT.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_GET_OVERTIME_SAVE.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Source%20code/ZHR_52TM_GET_OVERTIME_SAVE.abap) L165, 208 |
| [ZHR_52TM_GET_OVERTIME_DATA](ZHR_52TM_GET_OVERTIME_DATA.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_GET_OVERTIME_SAVE.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Source%20code/ZHR_52TM_GET_OVERTIME_SAVE.abap) L40 |
| [ZSHR0121](ZSHR0121.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_GET_OVERTIME_SAVE.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Source%20code/ZHR_52TM_GET_OVERTIME_SAVE.abap) L34, 35, 120 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 저장** — MODIFY DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZHR_52TM_GET_OVERTIME_SAVE.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Source%20code/ZHR_52TM_GET_OVERTIME_SAVE.abap) L277 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 저장** — UPDATE DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZHR_52TM_GET_OVERTIME_SAVE.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Source%20code/ZHR_52TM_GET_OVERTIME_SAVE.abap) L97 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_GET_OVERTIME_SAVE.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Source%20code/ZHR_52TM_GET_OVERTIME_SAVE.abap) L89 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Tables.xml) L9 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Import.xml) L113 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L81 |
| [MZH4110F01](MZH4110F01.md) | 직접 호출 | [MZH4110F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110F01/source/MZH4110F01.abap) L2171 |
| [ZHR_52TM_MOBILE_OVERTIME_APPR](ZHR_52TM_MOBILE_OVERTIME_APPR.md) | 직접 호출 | [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L193, 278 |

### 관련 업무와 미확인 범위

- [ordinary](../topics/ordinary.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
