---
title: "ZHR_52TM_MEMBER_CHECK — 유연근무 대상자 검사"
as_of: 2026-10-07
review_status: pending_business_review
tags: [선택근무, 재량근무, 탄력근무, 퇴직자관리자입력검토, 특별연장재난방송, 휴가공가반차]
---

# ZHR_52TM_MEMBER_CHECK — 유연근무 대상자 검사

[소스 설명 목차](INDEX.md) · [원본 파일](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MEMBER_CHECK/Source%20code/ZHR_52TM_MEMBER_CHECK.abap)

시간외 수정 전체를 막는 공통 진입점으로 단정하지 않는다. 유연근무 대상 신청 검사다.

확인 수준: 표시한 소스 구간 정적 확인; 운영 실행 검증 아님. 원본 경로·파일은 그대로 유지한다.

## 근거 위치

| 위치 | 관계의 의미 | 근거 구문 |
|---|---|---|
| 40행 | 현재일 인사정보 조회 | `AND begda <= sy-datum` |
| 55행 | 신청기간의 비재직 구간 검사 | `AND persg <> '1'.` |

## 관련 업무

<!-- topics -->
- [퇴직자·관리자 입력 검토](../topics/retired.md) — 이 소스를 검토하는 업무 지도.

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 유연근로제 신청가능 여부 및 대상자 체크.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MEMBER_CHECK/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MEMBER_CHECK/Changing.xml) | 40행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MEMBER_CHECK/Exception.xml) | 40행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MEMBER_CHECK/Export.xml) | 63행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MEMBER_CHECK/Import.xml) | 83행; 원본 보존 |
| [ZHR_52TM_MEMBER_CHECK.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MEMBER_CHECK/Source%20code/ZHR_52TM_MEMBER_CHECK.abap) | 160행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MEMBER_CHECK/Tables.xml) | 40행; 원본 보존 |
| [../../../Include/LZHR008_2U05.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U05.abap) | 160행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U05.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U05.abap) L1 | LZHR008_2U05: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_CHK` | CHAR01 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MEMBER_CHECK/Export.xml) L8 |
| Export | `E_RETURN` | BAPIRETURN1 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MEMBER_CHECK/Export.xml) L19 |
| Import | `I_PERNR` | PERSNO | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MEMBER_CHECK/Import.xml) L8 |
| Import | `I_BEGDA` | BEGDA | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MEMBER_CHECK/Import.xml) L22 |
| Import | `I_ENDDA` | ENDDA | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MEMBER_CHECK/Import.xml) L36 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — GET_PERNR_INFO: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L2101; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_MEMBER_CHECK.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MEMBER_CHECK/Source%20code/ZHR_52TM_MEMBER_CHECK.abap) L104 |
| [PA0001](EXTERNAL_DEPENDENCIES.md#PA0001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_MEMBER_CHECK.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MEMBER_CHECK/Source%20code/ZHR_52TM_MEMBER_CHECK.abap) L38, 51 |
| [PA9021](PA9021.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_MEMBER_CHECK.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MEMBER_CHECK/Source%20code/ZHR_52TM_MEMBER_CHECK.abap) L82 |
| [PA9021](PA9021.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_MEMBER_CHECK.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MEMBER_CHECK/Source%20code/ZHR_52TM_MEMBER_CHECK.abap) L22 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [FLEX_WORK_PLAN_ESTABLISH](FLEX_WORK_PLAN_ESTABLISH.md) | 웹 요청 | [FLEX_WORK_PLAN_ESTABLISH.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_ESTABLISH/Layout/FLEX_WORK_PLAN_ESTABLISH.htm) L3550 |
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L13 |
| [LZHR008_3F01](LZHR008_3F01.md) | 직접 호출 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L249, 773 |
| [MFLEX_WORK_PLAN_ESTABLISH](MFLEX_WORK_PLAN_ESTABLISH.md) | 웹 요청 | [MFLEX_WORK_PLAN_ESTABLISH.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MFLEX_WORK_PLAN_ESTABLISH/Layout/MFLEX_WORK_PLAN_ESTABLISH.htm) L3813 |
| [ZRPTH407F01](ZRPTH407F01.md) | 직접 호출 | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L990 |
| [ZRPTH410F01](ZRPTH410F01.md) | 직접 호출 | [ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap) L1446 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
