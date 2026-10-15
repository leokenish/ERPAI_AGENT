---
title: "ZHR_52TM_CW_PROCESS_DATA — 선택 실적 조회·저장·상신"
as_of: 2026-10-07
review_status: pending_business_review
tags: [PC모바일공통웹, 선택근무, 특별연장재난방송]
---

# ZHR_52TM_CW_PROCESS_DATA — 선택 실적 조회·저장·상신

[소스 설명 목차](INDEX.md) · [원본 파일](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Source%20code/ZHR_52TM_CW_PROCESS_DATA.abap)

선택 실적 요청 유형별 FORM을 연결한다. 마감 검사는 조회와 저장을 구분한다.

확인 수준: 표시한 소스 구간 정적 확인; 운영 실행 검증 아님. 원본 경로·파일은 그대로 유지한다.

## 근거 위치

| 위치 | 관계의 의미 | 근거 구문 |
|---|---|---|
| 36행 | 선택 정산 마감 조회 | `SELECT * FROM ZTHR0160 WHERE ZMONTH = temp_datum` |
| 86행 | 수정 저장 분기 | `WHEN 'U' OR 'E'.  "수정 page에서 저장, 선택휴무저장(E)` |
| 96행 | 결재상신 분기 | `WHEN 'A'.  "결재상신` |

## 연결된 소스

- [ZHR_52TM_VALID_DATE_CHECK](ZHR_52TM_VALID_DATE_CHECK.md) — 함수 호출 확인, 위 원본 52행. 호출 이후 전체 실행 성공은 미검증.

## 관련 업무

<!-- topics -->
- [선택근무](../topics/selective.md) — 이 소스를 검토하는 업무 지도.

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 실적 프로세스 - 선택근로제.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Changing.xml) | 61행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Exception.xml) | 46행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Export.xml) | 58행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Import.xml) | 103행; 원본 보존 |
| [ZHR_52TM_CW_PROCESS_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Source%20code/ZHR_52TM_CW_PROCESS_DATA.abap) | 108행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Tables.xml) | 46행; 원본 보존 |
| [../../../Include/LZHR008_3U03.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3U03.abap) | 108행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_3U03.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3U03.abap) L1 | LZHR008_3U03: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Changing | `CS_ZSHR0141` | [ZSHR0141](ZSHR0141.md) | X | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Changing.xml) L8 |
| Export | `E_RETURN` | BAPIRETURN1 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Export.xml) L8 |
| Import | `I_CASE` | CHAR1 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Import.xml) L8 |
| Import | `I_PERNR` | PERSNO | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Import.xml) L22 |
| Import | `I_DATUM` | DATS | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Import.xml) L36 |
| Import | `I_TDCOST` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Import.xml) L50 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_3F03](LZHR008_3F03.md) | **FORM 호출** — A_CW_PROCESS_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap L706; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_PROCESS_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Source%20code/ZHR_52TM_CW_PROCESS_DATA.abap) L97 |
| [LZHR008_3F03](LZHR008_3F03.md) | **FORM 호출** — B_CW_PROCESS_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap L856; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_PROCESS_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Source%20code/ZHR_52TM_CW_PROCESS_DATA.abap) L101 |
| [LZHR008_3F03](LZHR008_3F03.md) | **FORM 호출** — D_CW_PROCESS_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap L595; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_PROCESS_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Source%20code/ZHR_52TM_CW_PROCESS_DATA.abap) L93 |
| [LZHR008_3F03](LZHR008_3F03.md) | **FORM 호출** — R_CW_PROCESS_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap L14; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_PROCESS_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Source%20code/ZHR_52TM_CW_PROCESS_DATA.abap) L72 |
| [LZHR008_3F03](LZHR008_3F03.md) | **FORM 호출** — S_CW_PROCESS_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap L126; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_PROCESS_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Source%20code/ZHR_52TM_CW_PROCESS_DATA.abap) L80 |
| [LZHR008_3F03](LZHR008_3F03.md) | **FORM 호출** — U_CW_PROCESS_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap L1120; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_PROCESS_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Source%20code/ZHR_52TM_CW_PROCESS_DATA.abap) L87 |
| [LZHR008_3F03](LZHR008_3F03.md) | **FORM 호출** — Z_CW_PROCESS_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap L959; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CW_PROCESS_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Source%20code/ZHR_52TM_CW_PROCESS_DATA.abap) L65 |
| [PA9021](PA9021.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_CW_PROCESS_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Source%20code/ZHR_52TM_CW_PROCESS_DATA.abap) L28 |
| [ZHR_52TM_VALID_DATE_CHECK](ZHR_52TM_VALID_DATE_CHECK.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CW_PROCESS_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Source%20code/ZHR_52TM_CW_PROCESS_DATA.abap) L52 |
| [ZSHR0141](ZSHR0141.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Changing.xml) L15 |
| [ZTHR0132](ZTHR0132.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_CW_PROCESS_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Source%20code/ZHR_52TM_CW_PROCESS_DATA.abap) L24 |
| [ZTHR0132](ZTHR0132.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CW_PROCESS_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Source%20code/ZHR_52TM_CW_PROCESS_DATA.abap) L17 |
| [ZTHR0160](ZTHR0160.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_CW_PROCESS_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Source%20code/ZHR_52TM_CW_PROCESS_DATA.abap) L36 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [DAILY_WORK_DETAIL](DAILY_WORK_DETAIL.md) | 웹 요청 | [DAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L795 |
| [DAILY_WORK_INPUT](DAILY_WORK_INPUT.md) | 웹 요청 | [DAILY_WORK_INPUT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT/Layout/DAILY_WORK_INPUT.htm) L921 |
| [DAILY_WORK_MODIFY](DAILY_WORK_MODIFY.md) | 웹 요청 | [DAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_MODIFY/Layout/DAILY_WORK_MODIFY.htm) L907 |
| [LZHR008_3UXX](LZHR008_3UXX.md) | Include | [LZHR008_3UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3UXX.abap) L9 |
| [MDAILY_WORK_DETAIL](MDAILY_WORK_DETAIL.md) | 웹 요청 | [MDAILY_WORK_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL/Layout/MDAILY_WORK_DETAIL.htm) L822 |
| [MDAILY_WORK_DETAIL_new](MDAILY_WORK_DETAIL_new.md) | 웹 요청 | [MDAILY_WORK_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_DETAIL_new/Layout/MDAILY_WORK_DETAIL_new.htm) L268 |
| [MDAILY_WORK_INPUT](MDAILY_WORK_INPUT.md) | 웹 요청 | [MDAILY_WORK_INPUT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT/Layout/MDAILY_WORK_INPUT.htm) L970 |
| [MDAILY_WORK_INPUT_new](MDAILY_WORK_INPUT_new.md) | 웹 요청 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L278 |
| [MDAILY_WORK_MODIFY](MDAILY_WORK_MODIFY.md) | 웹 요청 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L969 |
| [MDAILY_WORK_MODIFY_new](MDAILY_WORK_MODIFY_new.md) | 웹 요청 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L284 |

### 관련 업무와 미확인 범위

- [selective](../topics/selective.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
