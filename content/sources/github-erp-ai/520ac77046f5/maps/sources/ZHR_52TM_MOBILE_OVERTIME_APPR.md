---
title: "ZHR_52TM_MOBILE_OVERTIME_APPR — 시간외 저장·상신 요청"
as_of: 2026-10-07
review_status: pending_business_review
tags: [교대근무, 통상시차시간외, 통합결재, 퇴직자관리자입력검토]
---

# ZHR_52TM_MOBILE_OVERTIME_APPR — 시간외 저장·상신 요청

[소스 설명 목차](INDEX.md) · [원본 파일](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap)

함수 이름에 MOBILE이 있어도 PC 웹 요청에서도 사용한다.

확인 수준: 표시한 소스 구간 정적 확인; 운영 실행 검증 아님. 원본 경로·파일은 그대로 유지한다.

## 근거 위치

| 위치 | 관계의 의미 | 근거 구문 |
|---|---|---|
| 193행 | 저장 데이터 처리 호출 | `CALL FUNCTION 'ZHR_52TM_GET_OVERTIME_SAVE'` |
| 350행 | 상신 처리 호출 | `CALL FUNCTION 'ZHR_52TM_GET_OVERTIME_REQUEST'` |

## 연결된 소스

- [ZHR_52TM_VALID_DATE_CHECK](ZHR_52TM_VALID_DATE_CHECK.md) — 함수 호출 확인, 위 원본 74행. 호출 이후 전체 실행 성공은 미검증.
- [ZHR_52TM_GET_OVERTIME_SAVE](ZHR_52TM_GET_OVERTIME_SAVE.md) — 함수 호출 확인, 위 원본 193행. 호출 이후 전체 실행 성공은 미검증.
- [ZHR_52TM_GET_OVERTIME_REQUEST](ZHR_52TM_GET_OVERTIME_REQUEST.md) — 함수 호출 확인, 위 원본 350행. 호출 이후 전체 실행 성공은 미검증.

## 관련 업무

<!-- topics -->
- [교대근무·보상휴가](../topics/shift.md) — 이 소스를 검토하는 업무 지도.
- [통상·시차 시간외 입력](../topics/ordinary.md) — 이 소스를 검토하는 업무 지도.

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] Mobile_통상/교대 시간외실비 결재관리.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Changing.xml) | 58행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Exception.xml) | 58행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Export.xml) | 103행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Import.xml) | 115행; 원본 보존 |
| [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) | 439행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Tables.xml) | 58행; 원본 보존 |
| [../../../Include/LZHR008_2U45.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U45.abap) | 439행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U45.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U45.abap) L1 | LZHR008_2U45: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_PERNR` | PERSNO | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Export.xml) L8 |
| Export | `E_DATUM` | DATUM | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Export.xml) L19 |
| Export | `E_SEQNR` | SEQNR | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Export.xml) L30 |
| Export | `E_RETURN` | BAPIRETURN1 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Export.xml) L41 |
| Import | `I_MODE` | CHAR01 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Import.xml) L8 |
| Import | `I_ACTION` | SYUCOMM | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Import.xml) L22 |
| Import | `IS_ZSHR0131` | [ZSHR0131](ZSHR0131.md) | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Import.xml) L36 |
| Import | `I_SEQNR` | SEQNR | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Import.xml) L50 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — SEND_MAIL: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L2772; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L401 |
| [LZHR008_2F06](LZHR008_2F06.md) | **FORM 호출** — CALCULATE_ZE_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap L1339; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L158 |
| [LZHR008_2F06](LZHR008_2F06.md) | **FORM 호출** — MODIFY_OVERTIME_SAVE_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap L969; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L143 |
| [LZHR008_2F06](LZHR008_2F06.md) | **FORM 호출** — SET_OVERTIME_ZGUBUN: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap L41; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L94 |
| [ZEPDWK_TM](ZEPDWK_TM.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L24 |
| [ZHR_52TM_CHECK_APPROVER_N](EXT-ZHR_52TM_CHECK_APPROVER_N.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L164 |
| [ZHR_52TM_GET_OVERTIME_DELETE](ZHR_52TM_GET_OVERTIME_DELETE.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L380 |
| [ZHR_52TM_GET_OVERTIME_REQUEST](ZHR_52TM_GET_OVERTIME_REQUEST.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L350 |
| [ZHR_52TM_GET_OVERTIME_RETURN](ZHR_52TM_GET_OVERTIME_RETURN.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L417 |
| [ZHR_52TM_GET_OVERTIME_SAVE](ZHR_52TM_GET_OVERTIME_SAVE.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L193, 278 |
| [ZHR_52TM_VALID_DATE_CHECK](ZHR_52TM_VALID_DATE_CHECK.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L74, 331 |
| [ZSHR0131](ZSHR0131.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Import.xml) L43 |
| [ZSHR0131](ZSHR0131.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L19 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 저장** — MODIFY DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L223, 313 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L42, 135 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L85 |
| [MORD_OT_DETAIL](MORD_OT_DETAIL.md) | 웹 요청 | [MORD_OT_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_DETAIL/Layout/MORD_OT_DETAIL.htm) L1210 |
| [MORD_OT_DETAIL_new](MORD_OT_DETAIL_new.md) | 웹 요청 | [MORD_OT_DETAIL_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_DETAIL_new/Layout/MORD_OT_DETAIL_new.htm) L461 |
| [MORD_OT_INSERT](MORD_OT_INSERT.md) | 웹 요청 | [MORD_OT_INSERT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_INSERT/Layout/MORD_OT_INSERT.htm) L1986, 2174 |
| [MORD_OT_INSERT_new](MORD_OT_INSERT_new.md) | 웹 요청 | [MORD_OT_INSERT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_INSERT_new/Layout/MORD_OT_INSERT_new.htm) L1094, 1274 |
| [MORD_OT_MODIFY](MORD_OT_MODIFY.md) | 웹 요청 | [MORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY/Layout/MORD_OT_MODIFY.htm) L2949 |
| [MORD_OT_MODIFY_new](MORD_OT_MODIFY_new.md) | 웹 요청 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L1968 |
| [ORD_OT_DETAIL](ORD_OT_DETAIL.md) | 웹 요청 | [ORD_OT_DETAIL.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_DETAIL/Layout/ORD_OT_DETAIL.htm) L1194 |
| [ORD_OT_INSERT](ORD_OT_INSERT.md) | 웹 요청 | [ORD_OT_INSERT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_INSERT/Layout/ORD_OT_INSERT.htm) L1870, 2063 |
| [ORD_OT_MODIFY](ORD_OT_MODIFY.md) | 웹 요청 | [ORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MODIFY/Layout/ORD_OT_MODIFY.htm) L2868 |
| [temp](temp.md) | 웹 요청 | [temp.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/temp/Layout/temp.htm) L1584, 1738 |

### 관련 업무와 미확인 범위

- [ordinary](../topics/ordinary.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [retired](../topics/retired.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [shift](../topics/shift.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
