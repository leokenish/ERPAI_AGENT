---
title: "ZHR_52TM_CW_PAYMENT_WKPRD — 선택 기간별 정산 호출"
as_of: 2026-10-07
review_status: pending_business_review
tags: [선택근무, 월정산전표지급, 특별연장재난방송]
---

# ZHR_52TM_CW_PAYMENT_WKPRD — 선택 기간별 정산 호출

[소스 설명 목차](INDEX.md) · [원본 파일](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Source%20code/ZHR_52TM_CW_PAYMENT_WKPRD.abap)

정산기간 데이터와 선택 계산 함수를 연결한다.

확인 수준: 표시한 소스 구간 정적 확인; 운영 실행 검증 아님. 원본 경로·파일은 그대로 유지한다.

## 근거 위치

| 위치 | 관계의 의미 | 근거 구문 |
|---|---|---|
| 90행 | 선택 실비·대휴 계산 호출 | `CALL FUNCTION 'ZHR_52TM_CW_CAL_AND_DAEH'` |

## 연결된 소스

- [ZHR_52TM_CW_CAL_AND_DAEH](ZHR_52TM_CW_CAL_AND_DAEH.md) — 함수 호출 확인, 위 원본 90행. 호출 이후 전체 실행 성공은 미검증.

## 관련 업무

<!-- topics -->
- [선택근무](../topics/selective.md) — 이 소스를 검토하는 업무 지도.

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 정산처리 - 선택근로제.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Changing.xml) | 58행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Exception.xml) | 58행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Export.xml) | 58행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Import.xml) | 157행; 원본 보존 |
| [ZHR_52TM_CW_PAYMENT_WKPRD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Source%20code/ZHR_52TM_CW_PAYMENT_WKPRD.abap) | 166행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Tables.xml) | 70행; 원본 보존 |
| [../../../Include/LZHR008_3U08.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3U08.abap) | 166행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_3U08.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3U08.abap) L1 | LZHR008_3U08: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Import | `I_PERNR` | PERSNO | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Import.xml) L8 |
| Import | `I_YYMM` | [ZEZADMIT_YM](ZEZADMIT_YM.md) | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Import.xml) L22 |
| Import | `I_Z52WKTP` | [ZE52WKTP](ZE52WKTP.md) | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Import.xml) L36 |
| Import | `I_Z52PRSQ` | [ZE52PRSQ](ZE52PRSQ.md) | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Import.xml) L50 |
| Import | `I_OPT` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Import.xml) L64 |
| Import | `I_RETRO` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Import.xml) L78 |
| Import | `I_RETMO` | ZYEARMON | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Import.xml) L92 |
| Tables | `LT_ZTHR0113` | [ZTHR0113](ZTHR0113.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Tables.xml) L8 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZE52PRSQ](ZE52PRSQ.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Import.xml) L57 |
| [ZE52WKTP](ZE52WKTP.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Import.xml) L43 |
| [ZEZADMIT_YM](ZEZADMIT_YM.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Import.xml) L29 |
| [ZHR_52TM_CW_CAL_AND_DAEH](ZHR_52TM_CW_CAL_AND_DAEH.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CW_PAYMENT_WKPRD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Source%20code/ZHR_52TM_CW_PAYMENT_WKPRD.abap) L90, 125 |
| [ZTHR0113](ZTHR0113.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_CW_PAYMENT_WKPRD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Source%20code/ZHR_52TM_CW_PAYMENT_WKPRD.abap) L61 |
| [ZTHR0113](ZTHR0113.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Tables.xml) L9 |
| [ZTHR0113](ZTHR0113.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CW_PAYMENT_WKPRD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Source%20code/ZHR_52TM_CW_PAYMENT_WKPRD.abap) L22, 23, 24, 25, 28, 29, 30, 32 |
| [ZTHR0132](ZTHR0132.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_CW_PAYMENT_WKPRD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Source%20code/ZHR_52TM_CW_PAYMENT_WKPRD.abap) L79, 114 |
| [ZTHR0132](ZTHR0132.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CW_PAYMENT_WKPRD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Source%20code/ZHR_52TM_CW_PAYMENT_WKPRD.abap) L31 |
| [ZYEARMON](EXTERNAL_DEPENDENCIES.md#ZYEARMON) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Import.xml) L99 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_3UXX](LZHR008_3UXX.md) | Include | [LZHR008_3UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3UXX.abap) L19 |
| [ZRPTH411F01](ZRPTH411F01.md) | 직접 호출 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L36 |

### 관련 업무와 미확인 범위

- [selective](../topics/selective.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
