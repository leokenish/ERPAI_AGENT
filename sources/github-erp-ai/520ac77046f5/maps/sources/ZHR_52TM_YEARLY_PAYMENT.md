---
title: "ZHR_52TM_YEARLY_PAYMENT — [52시간] 탄력근로제 연간 정산금액 조회"
as_of: 2026-10-07
review_status: pending_business_review
tags: [근무현황조회, 선택근무, 월정산전표지급, 탄력근무]
---

# ZHR_52TM_YEARLY_PAYMENT — [52시간] 탄력근로제 연간 정산금액 조회

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 탄력근로제 연간 정산금액 조회.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_YEARLY_PAYMENT/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_YEARLY_PAYMENT/Changing.xml) | 28행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_YEARLY_PAYMENT/Exception.xml) | 28행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_YEARLY_PAYMENT/Export.xml) | 28행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_YEARLY_PAYMENT/Import.xml) | 57행; 원본 보존 |
| [ZHR_52TM_YEARLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_YEARLY_PAYMENT/Source%20code/ZHR_52TM_YEARLY_PAYMENT.abap) | 230행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_YEARLY_PAYMENT/Tables.xml) | 40행; 원본 보존 |
| [../../../Include/LZHR008_2U43.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U43.abap) | 230행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U43.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U43.abap) L1 | LZHR008_2U43: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Import | `I_PERNR` | PERSNO | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_YEARLY_PAYMENT/Import.xml) L8 |
| Import | `I_YEAR` | NUMC4 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_YEARLY_PAYMENT/Import.xml) L22 |
| Tables | `T_MON_PAY` | [ZTSHR0126](ZTSHR0126.md) | — | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_YEARLY_PAYMENT/Tables.xml) L8 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F02](LZHR008_2F02.md) | **FORM 호출** — SET_HOUR_TO_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F02.abap L12; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_YEARLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_YEARLY_PAYMENT/Source%20code/ZHR_52TM_YEARLY_PAYMENT.abap) L217 |
| [LZHR008_3F02](LZHR008_3F02.md) | **FORM 호출** — CONVERT_MIN_TO_HOUR2: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F02.abap L313; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_YEARLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_YEARLY_PAYMENT/Source%20code/ZHR_52TM_YEARLY_PAYMENT.abap) L126, 169 |
| [PA9021](PA9021.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_YEARLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_YEARLY_PAYMENT/Source%20code/ZHR_52TM_YEARLY_PAYMENT.abap) L11 |
| [ZEZADMIT_YM](ZEZADMIT_YM.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_YEARLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_YEARLY_PAYMENT/Source%20code/ZHR_52TM_YEARLY_PAYMENT.abap) L12 |
| [ZTHR0113](ZTHR0113.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_YEARLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_YEARLY_PAYMENT/Source%20code/ZHR_52TM_YEARLY_PAYMENT.abap) L144 |
| [ZTHR0113](ZTHR0113.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_YEARLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_YEARLY_PAYMENT/Source%20code/ZHR_52TM_YEARLY_PAYMENT.abap) L21 |
| [ZTHR0120](ZTHR0120.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_YEARLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_YEARLY_PAYMENT/Source%20code/ZHR_52TM_YEARLY_PAYMENT.abap) L101 |
| [ZTHR0120](ZTHR0120.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_YEARLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_YEARLY_PAYMENT/Source%20code/ZHR_52TM_YEARLY_PAYMENT.abap) L22 |
| [ZTSHR0126](ZTSHR0126.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_YEARLY_PAYMENT/Tables.xml) L12 |
| [ZTSHR0126](ZTSHR0126.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_YEARLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_YEARLY_PAYMENT/Source%20code/ZHR_52TM_YEARLY_PAYMENT.abap) L10, 19 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [FLEX_WORK_MONTHLY_LIST](FLEX_WORK_MONTHLY_LIST.md) | 웹 요청 | [FLEX_WORK_MONTHLY_LIST.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_MONTHLY_LIST/Layout/FLEX_WORK_MONTHLY_LIST.htm) L82 |
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L95 |
| [MFLEX_WORK_MONTHLY_LIST](MFLEX_WORK_MONTHLY_LIST.md) | 웹 요청 | [MFLEX_WORK_MONTHLY_LIST.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MFLEX_WORK_MONTHLY_LIST/Layout/MFLEX_WORK_MONTHLY_LIST.htm) L83 |
| [MFLEX_WORK_MONTHLY_LIST_new](MFLEX_WORK_MONTHLY_LIST_new.md) | 웹 요청 | [MFLEX_WORK_MONTHLY_LIST_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MFLEX_WORK_MONTHLY_LIST_new/Layout/MFLEX_WORK_MONTHLY_LIST_new.htm) L50 |

### 관련 업무와 미확인 범위

- [reporting](../topics/reporting.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
