---
title: "ZHR_52TM_VALID_DATE_CHECK — 입력 기한·월마감 검사"
as_of: 2026-10-07
review_status: pending_business_review
tags: [교대근무, 선택근무, 월정산전표지급, 인사정보형9021_9023, 탄력근무, 통상시차시간외, 통합결재, 퇴직자관리자입력검토, 특별연장재난방송]
---

# ZHR_52TM_VALID_DATE_CHECK — 입력 기한·월마감 검사

[소스 설명 목차](INDEX.md) · [원본 파일](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Source%20code/ZHR_52TM_VALID_DATE_CHECK.abap)

재직 여부와 별개의 입력·결재 기한 및 월마감 경로다.

확인 수준: 표시한 소스 구간 정적 확인; 운영 실행 검증 아님. 원본 경로·파일은 그대로 유지한다.

## 근거 위치

| 위치 | 관계의 의미 | 근거 구문 |
|---|---|---|
| 41행 | 마감 데이터 조회 | `SELECT * FROM ZTHR0160 WHERE ZMONTH =  temp_datum` |
| 63행 | 조회 모드의 과거 조회 예외 | `IF I_OPT = 'R'. "조회모드일 경우 과거내역 조회 제한 두지 않음(노사협의 인사운영부 요청) - 나구엽 2023.07.24` |
| 68행 | 입력기한 검사 FORM 호출 | `PERFORM check_possible_date USING i_pernr     "사번` |

## 관련 업무

<!-- topics -->
- [퇴직자·관리자 입력 검토](../topics/retired.md) — 이 소스를 검토하는 업무 지도.
- [월정산·확정·전표·지급](../topics/settlement.md) — 이 소스를 검토하는 업무 지도.

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 신청. 상신.결재 유효기간 CHECK.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Changing.xml) | 46행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Exception.xml) | 46행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Export.xml) | 58행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Import.xml) | 117행; 원본 보존 |
| [ZHR_52TM_VALID_DATE_CHECK.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Source%20code/ZHR_52TM_VALID_DATE_CHECK.abap) | 240행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Tables.xml) | 46행; 원본 보존 |
| [../../../Include/LZHR008_2U13.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U13.abap) | 240행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U13.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U13.abap) L1 | LZHR008_2U13: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_RETURN` | BAPIRETURN1 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Export.xml) L8 |
| Import | `I_PERNR` | PERSNO | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Import.xml) L8 |
| Import | `I_DATE` | DATUM | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Import.xml) L22 |
| Import | `I_OPT` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Import.xml) L36 |
| Import | `I_ZTOMO` | ZTOMO | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Import.xml) L50 |
| Import | `I_CHECK` | CHAR4 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Import.xml) L64 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F03](LZHR008_2F03.md) | **FORM 호출** — CHECK_DAILYWORK_POSSIBLE_DATE: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap L897; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_VALID_DATE_CHECK.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Source%20code/ZHR_52TM_VALID_DATE_CHECK.abap) L77 |
| [LZHR008_2F03](LZHR008_2F03.md) | **FORM 호출** — CHECK_POSSIBLE_DATE: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap L482; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_VALID_DATE_CHECK.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Source%20code/ZHR_52TM_VALID_DATE_CHECK.abap) L68 |
| [LZHR008_2F06](LZHR008_2F06.md) | **FORM 호출** — CHECK_DAILYWORK_APV_DATE: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap L1635; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_VALID_DATE_CHECK.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Source%20code/ZHR_52TM_VALID_DATE_CHECK.abap) L98 |
| [LZHR008_2F06](LZHR008_2F06.md) | **FORM 호출** — CHECK_POSSIBLE_APV_DATE: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap L1542; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_VALID_DATE_CHECK.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Source%20code/ZHR_52TM_VALID_DATE_CHECK.abap) L90 |
| [PA0001](EXTERNAL_DEPENDENCIES.md#PA0001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_VALID_DATE_CHECK.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Source%20code/ZHR_52TM_VALID_DATE_CHECK.abap) L46, 54 |
| [PA9021](PA9021.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_VALID_DATE_CHECK.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Source%20code/ZHR_52TM_VALID_DATE_CHECK.abap) L33 |
| [ZTHR0112](ZTHR0112.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_VALID_DATE_CHECK.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Source%20code/ZHR_52TM_VALID_DATE_CHECK.abap) L22 |
| [ZTHR0160](ZTHR0160.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_VALID_DATE_CHECK.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Source%20code/ZHR_52TM_VALID_DATE_CHECK.abap) L41 |
| [ZTOMO](EXTERNAL_DEPENDENCIES.md#ZTOMO) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_VALID_DATE_CHECK/Import.xml) L57 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F01](LZHR008_2F01.md) | 직접 호출 | [LZHR008_2F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap) L1446 |
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L27 |
| [LZHR008_3F01](LZHR008_3F01.md) | 직접 호출 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L265 |
| [LZHR008_3F03](LZHR008_3F03.md) | 직접 호출 | [LZHR008_3F03.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap) L619, 730, 877 |
| [MORD_OT_LIST](MORD_OT_LIST.md) | 웹 요청 | [MORD_OT_LIST.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_LIST/Layout/MORD_OT_LIST.htm) L381 |
| [MORD_OT_LIST_NEW](MORD_OT_LIST_NEW.md) | 웹 요청 | [MORD_OT_LIST_NEW.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_LIST_NEW/Layout/MORD_OT_LIST_NEW.htm) L267 |
| [ORD_OT_LIST](ORD_OT_LIST.md) | 웹 요청 | [ORD_OT_LIST.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_LIST/Layout/ORD_OT_LIST.htm) L399 |
| [ORD_OT_MONTHLY_CONDITION](ORD_OT_MONTHLY_CONDITION.md) | 웹 요청 | [ORD_OT_MONTHLY_CONDITION.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MONTHLY_CONDITION/Layout/ORD_OT_MONTHLY_CONDITION.htm) L503 |
| [ZHR_52TM_APPROVE_OT_DATA](ZHR_52TM_APPROVE_OT_DATA.md) | 직접 호출 | [ZHR_52TM_APPROVE_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_OT_DATA/Source%20code/ZHR_52TM_APPROVE_OT_DATA.abap) L134 |
| [ZHR_52TM_CW_PROCESS_DATA](ZHR_52TM_CW_PROCESS_DATA.md) | 직접 호출 | [ZHR_52TM_CW_PROCESS_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Source%20code/ZHR_52TM_CW_PROCESS_DATA.abap) L52 |
| [ZHR_52TM_DAILY_APPROVE_OT_DATA](ZHR_52TM_DAILY_APPROVE_OT_DATA.md) | 직접 호출 | [ZHR_52TM_DAILY_APPROVE_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Source%20code/ZHR_52TM_DAILY_APPROVE_OT_DATA.abap) L124 |
| [ZHR_52TM_MOBILE_OVERTIME_APPR](ZHR_52TM_MOBILE_OVERTIME_APPR.md) | 직접 호출 | [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L74, 331 |
| [ZHR_52TM_MOBILE_OVERTIME_CHANG](ZHR_52TM_MOBILE_OVERTIME_CHANG.md) | 직접 호출 | [ZHR_52TM_MOBILE_OVERTIME_CHANG.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_CHANG/Source%20code/ZHR_52TM_MOBILE_OVERTIME_CHANG.abap) L37 |

### 관련 업무와 미확인 범위

- [ordinary](../topics/ordinary.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [retired](../topics/retired.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
