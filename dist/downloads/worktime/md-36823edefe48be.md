---
title: "ZHR_52TM_MONTHLY_PAYMENT — 탄력 월정산 계산"
as_of: 2026-10-07
review_status: pending_business_review
tags: [월정산전표지급, 탄력근무]
---

# ZHR_52TM_MONTHLY_PAYMENT — 탄력 월정산 계산

[소스 설명 목차](INDEX.md) · [원본 파일](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap)

계획·실적·근로기간을 읽는 월정산 계산 함수. 전체 소급 산식은 별도 확인.

확인 수준: 표시한 소스 구간 정적 확인; 운영 실행 검증 아님. 원본 경로·파일은 그대로 유지한다.

## 근거 위치

| 위치 | 관계의 의미 | 근거 구문 |
|---|---|---|
| 228행 | 주 단위 시간 계산 호출 | `CALL FUNCTION 'ZHR_52TM_CALC_WEEK_TIME'` |
| 415행 | 대상 등급 조회 | `CALL FUNCTION 'ZHR_GET_PERSONNEL_RANK_N'` |

## 관련 업무

<!-- topics -->
- [탄력근로 계획·결재](../topics/flexible.md) — 이 소스를 검토하는 업무 지도.

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 탄력근로제 월간 주단위정산금액.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Changing.xml) | 64행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Exception.xml) | 64행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Export.xml) | 64행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Import.xml) | 163행; 원본 보존 |
| [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) | 795행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Tables.xml) | 87행; 원본 보존 |
| [../../../Include/LZHR008_2U14.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U14.abap) | 795행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U14.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U14.abap) L1 | LZHR008_2U14: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Import | `I_PERNR` | PERSNO | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Import.xml) L8 |
| Import | `I_YYMM` | [ZEZADMIT_YM](ZEZADMIT_YM.md) | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Import.xml) L22 |
| Import | `I_Z52WKTP` | [ZE52WKTP](ZE52WKTP.md) | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Import.xml) L36 |
| Import | `I_Z52PRSQ` | [ZE52PRSQ](ZE52PRSQ.md) | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Import.xml) L50 |
| Import | `I_OPT` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Import.xml) L64 |
| Import | `I_RETRO` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Import.xml) L78 |
| Import | `I_RETMO` | ZYEARMON | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Import.xml) L92 |
| Tables | `T_PAYMENT` | [ZTSHR0120](ZTSHR0120.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Tables.xml) L8 |
| Tables | `T_MON_PAY` | [ZTSHR0126](ZTSHR0126.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Tables.xml) L19 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [HR_IN_LAST_DAY_OF_MONTHS](EXTERNAL_DEPENDENCIES.md#HR_IN_LAST_DAY_OF_MONTHS) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L83 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — MAKE_CALC_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L350; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L259, 362, 469, 477, 490, 512, 520, 530 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — MAKE_TOT_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L363; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L262, 365, 473, 481, 493, 515, 523, 533 |
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — SET_ROUND_AMT: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L2591; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L702, 703, 704, 705 |
| [LZHR008_2F02](LZHR008_2F02.md) | **FORM 호출** — CALC_OT_AMOUNT: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F02.abap L48; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L678, 683, 689, 695 |
| [LZHR008_2F02](LZHR008_2F02.md) | **FORM 호출** — GET_CALC_NGT_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F02.abap L87; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L498 |
| [LZHR008_2F02](LZHR008_2F02.md) | **FORM 호출** — SET_HOUR_TO_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F02.abap L12; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L670, 787 |
| [SWI_DURATION_DETERMINE](EXTERNAL_DEPENDENCIES.md#SWI_DURATION_DETERMINE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L656 |
| [ZE52PRSQ](ZE52PRSQ.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Import.xml) L57 |
| [ZE52WKTP](ZE52WKTP.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Import.xml) L43 |
| [ZEPLWK_TM](ZEPLWK_TM.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L67 |
| [ZEZADMIT_YM](ZEZADMIT_YM.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Import.xml) L29 |
| [ZHR_52TM_CALC_WEEK_TIME](ZHR_52TM_CALC_WEEK_TIME.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L228, 331 |
| [ZHR_52TM_CALC_WORK_TIME_DAYILY](ZHR_52TM_CALC_WORK_TIME_DAYILY.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L457 |
| [ZHR_52TM_WKTYPE](ZHR_52TM_WKTYPE.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L171 |
| [ZHR_GET_PERSONNEL_RANK_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_PERSONNEL_RANK_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L415 |
| [ZHR_MINUS_TIME_N](EXTERNAL_DEPENDENCIES.md#ZHR_MINUS_TIME_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L625 |
| [ZHR_SUM_TIME_N](EXTERNAL_DEPENDENCIES.md#ZHR_SUM_TIME_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L593, 602, 611 |
| [ZSHR0106](ZSHR0106.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L26 |
| [ZSHR0115](ZSHR0115.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L30 |
| [ZTHR0106](ZTHR0106.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L100, 151 |
| [ZTHR0106](ZTHR0106.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L18, 19 |
| [ZTHR0107](ZTHR0107.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L252, 355 |
| [ZTHR0110](ZTHR0110.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L126, 398 |
| [ZTHR0110](ZTHR0110.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L59, 112 |
| [ZTHR0120](ZTHR0120.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L722, 746 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L443 |
| [ZTHRCOST](EXT-ZTHRCOST.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L428 |
| [ZTSHR0115](ZTSHR0115.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L31 |
| [ZTSHR0120](ZTSHR0120.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Tables.xml) L12 |
| [ZTSHR0126](ZTSHR0126.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Tables.xml) L23 |
| [ZWF0022](EXT-ZWF0022.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L138 |
| [ZYEARMON](EXTERNAL_DEPENDENCIES.md#ZYEARMON) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Import.xml) L99 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L29 |
| [ZRPTH402F01](ZRPTH402F01.md) | 직접 호출 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L17 |

### 관련 업무와 미확인 범위

- [flexible](../topics/flexible.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [settlement](../topics/settlement.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
