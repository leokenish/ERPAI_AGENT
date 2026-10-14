---
title: "ZHR_52TM_IAM — [52시간] I AM 등록"
as_of: 2026-10-07
review_status: pending_business_review
tags: [IAM등록기본설정, PC모바일공통웹, 선택근무, 탄력근무, 통상시차시간외]
---

# ZHR_52TM_IAM — [52시간] I AM 등록

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] I AM 등록.

검토 상태: **분석 완료 — 아래에 명시한 본문 정적 분석 범위; 외부 구현·업무 전체·운영은 미확인**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_IAM/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_IAM/Changing.xml) | 34행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_IAM/Exception.xml) | 34행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_IAM/Export.xml) | 46행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_IAM/Import.xml) | 63행; 원본 보존 |
| [ZHR_52TM_IAM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_IAM/Source%20code/ZHR_52TM_IAM.abap) | 170행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_IAM/Tables.xml) | 46행; 원본 보존 |
| [../../../Include/LZHR008_2U55.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U55.abap) | 170행; 원본 보존 |

### 이번 업무 구간 검토

파일 판정: **분석 완료**. 검토 범위: 본문 L1–170, 분기/입출력/직접 참조 정적 검토. 남은 범위: 외부 호출 본문·권한·운영 사용·실제 실행 미확인. 이는 이 파일/명시한 구간의 정적 분석이며 외부 함수·업무 전체·운영 검증 완료는 아니다.

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U55.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U55.abap) L1 | LZHR008_2U55: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_RETURN` | BAPIRETURN1 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_IAM/Export.xml) L8 |
| Import | `I_ACTION` | SYUCOMM | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_IAM/Import.xml) L8 |
| Import | `I_PERNR` | PERSNO | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_IAM/Import.xml) L22 |
| Tables | `T_DATA` | [ZSHR0135](ZSHR0135.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_IAM/Tables.xml) L8 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZCL_CM_UTIL_DEV](EXT-ZCL_CM_UTIL_DEV.md) | **클래스 참조** — get_jikwitext 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZHR_52TM_IAM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_IAM/Source%20code/ZHR_52TM_IAM.abap) L44 |
| [ZCL_CM_UTIL_DEV](EXT-ZCL_CM_UTIL_DEV.md) | **클래스 참조** — get_name 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZHR_52TM_IAM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_IAM/Source%20code/ZHR_52TM_IAM.abap) L37 |
| [ZCL_CM_UTIL_DEV](EXT-ZCL_CM_UTIL_DEV.md) | **클래스 참조** — get_vdstext 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZHR_52TM_IAM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_IAM/Source%20code/ZHR_52TM_IAM.abap) L40 |
| [ZSHR0135](ZSHR0135.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_IAM/Tables.xml) L9 |
| [ZTHR0124](ZTHR0124.md) | **데이터 저장** — DELETE DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZHR_52TM_IAM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_IAM/Source%20code/ZHR_52TM_IAM.abap) L162 |
| [ZTHR0124](ZTHR0124.md) | **데이터 저장** — INSERT DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZHR_52TM_IAM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_IAM/Source%20code/ZHR_52TM_IAM.abap) L139 |
| [ZTHR0124](ZTHR0124.md) | **데이터 저장** — UPDATE DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZHR_52TM_IAM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_IAM/Source%20code/ZHR_52TM_IAM.abap) L148 |
| [ZTHR0124](ZTHR0124.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_IAM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_IAM/Source%20code/ZHR_52TM_IAM.abap) L30, 129 |
| [ZTHR0124](ZTHR0124.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_IAM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_IAM/Source%20code/ZHR_52TM_IAM.abap) L12, 13 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [IAM](IAM.md) | 웹 요청 | [IAM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/IAM/Layout/IAM.htm) L397, 423, 463 |
| [IAM_LIST](IAM_LIST.md) | 웹 요청 | [IAM_LIST.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/IAM_LIST/Layout/IAM_LIST.htm) L116 |
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L113 |
| [MDAILY_WORK_INPUT](MDAILY_WORK_INPUT.md) | 웹 요청 | [MDAILY_WORK_INPUT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT/Layout/MDAILY_WORK_INPUT.htm) L2160 |
| [MDAILY_WORK_INPUT_new](MDAILY_WORK_INPUT_new.md) | 웹 요청 | [MDAILY_WORK_INPUT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT_new/Layout/MDAILY_WORK_INPUT_new.htm) L1181 |
| [MDAILY_WORK_MODIFY](MDAILY_WORK_MODIFY.md) | 웹 요청 | [MDAILY_WORK_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY/Layout/MDAILY_WORK_MODIFY.htm) L2212 |
| [MDAILY_WORK_MODIFY_new](MDAILY_WORK_MODIFY_new.md) | 웹 요청 | [MDAILY_WORK_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_MODIFY_new/Layout/MDAILY_WORK_MODIFY_new.htm) L1220 |
| [MFLEX_WORK_PERFORMANCE_INPUT](MFLEX_WORK_PERFORMANCE_INPUT.md) | 웹 요청 | [MFLEX_WORK_PERFORMANCE_INPUT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MFLEX_WORK_PERFORMANCE_INPUT/Layout/MFLEX_WORK_PERFORMANCE_INPUT.htm) L4305 |
| [MFLEX_WORK_PLAN_ESTABLISH](MFLEX_WORK_PLAN_ESTABLISH.md) | 웹 요청 | [MFLEX_WORK_PLAN_ESTABLISH.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MFLEX_WORK_PLAN_ESTABLISH/Layout/MFLEX_WORK_PLAN_ESTABLISH.htm) L4012 |
| [MORD_OT_INSERT](MORD_OT_INSERT.md) | 웹 요청 | [MORD_OT_INSERT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_INSERT/Layout/MORD_OT_INSERT.htm) L1325 |
| [MORD_OT_INSERT_new](MORD_OT_INSERT_new.md) | 웹 요청 | [MORD_OT_INSERT_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_INSERT_new/Layout/MORD_OT_INSERT_new.htm) L471 |
| [MORD_OT_MODIFY](MORD_OT_MODIFY.md) | 웹 요청 | [MORD_OT_MODIFY.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY/Layout/MORD_OT_MODIFY.htm) L1253 |
| [MORD_OT_MODIFY_new](MORD_OT_MODIFY_new.md) | 웹 요청 | [MORD_OT_MODIFY_new.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MORD_OT_MODIFY_new/Layout/MORD_OT_MODIFY_new.htm) L407 |

### 관련 업무와 미확인 범위

- [iam](../topics/iam.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
