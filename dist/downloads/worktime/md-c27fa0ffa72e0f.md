---
title: "LZHR008_3F01 — 선택 재직·근태 검사"
as_of: 2026-10-07
review_status: pending_business_review
tags: [선택근무, 퇴직자관리자입력검토, 특별연장재난방송]
---

# LZHR008_3F01 — 선택 재직·근태 검사

[소스 설명 목차](INDEX.md) · [원본 파일](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap)

선택근무일 기준 PA0000-STAT2 검사. 오늘 퇴직자라는 사실만으로 과거 근무일이 거부된다고 단정하지 않는다.

확인 수준: 표시한 소스 구간 정적 확인; 운영 실행 검증 아님. 원본 경로·파일은 그대로 유지한다.

## 근거 위치

| 위치 | 관계의 의미 | 근거 구문 |
|---|---|---|
| 106행 | 첫 번째 입력 검사 진입 | `FORM b_cw_check_data  USING value(pv_pernr)` |
| 132행 | 대상 근무일 재직상태 검사 | `IF lv_stat2 <> '3'.` |
| 650행 | 두 번째 입력 검사 진입 | `FORM k_cw_check_data  USING value(pv_pernr)` |

## 연결된 소스

- [ZHR_52TM_AWART_LIST](ZHR_52TM_AWART_LIST.md) — 함수 호출 확인, 위 원본 79행. 호출 이후 전체 실행 성공은 미검증.
- [ZHR_52TM_GET_PERSONNEL_DATA_N](ZHR_52TM_GET_PERSONNEL_DATA_N.md) — 함수 호출 확인, 위 원본 140행. 호출 이후 전체 실행 성공은 미검증.
- [ZHR_52TM_MEMBER_CHECK](ZHR_52TM_MEMBER_CHECK.md) — 함수 호출 확인, 위 원본 249행. 호출 이후 전체 실행 성공은 미검증.
- [ZHR_52TM_VALID_DATE_CHECK](ZHR_52TM_VALID_DATE_CHECK.md) — 함수 호출 확인, 위 원본 265행. 호출 이후 전체 실행 성공은 미검증.

## 관련 업무

<!-- topics -->
- [퇴직자·관리자 입력 검토](../topics/retired.md) — 이 소스를 검토하는 업무 지도.

## 누적표시 변경 검토

[선택근로 누적시간 가산 포함 분석](../topics/selective.md#%EB%88%84%EC%A0%81%EA%B7%BC%EB%A1%9C%EC%8B%9C%EA%B0%84%20%EA%B0%80%EC%82%B0%20%ED%8F%AC%ED%95%A8%20%EB%B3%80%EA%B2%BD%20%EA%B2%80%ED%86%A0%202026-10-08) — 2026-10-08, 지정 구간 정적 확인과 표시 전용 변경안. 원본 수정·운영 검증 없음.

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수그룹 Include**. 설명: 제목 메타데이터 없음; 이름만으로 업무를 확정하지 않음.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) | 1158행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [DAY_ATTRIBUTES_GET](EXTERNAL_DEPENDENCIES.md#DAY_ATTRIBUTES_GET) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L56 |
| [LZHR008_2F03](LZHR008_2F03.md) | **FORM 호출** — CHECK_BKTIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap L5006; 포함 범위 내 이름 일치, 동적 해석 제외 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L852 |
| [LZHR008_3F02](LZHR008_3F02.md) | **FORM 호출** — CONVERT_TIME_TO_MIN: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F02.abap L257; 포함 범위 내 이름 일치, 동적 해석 제외 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L477, 1102, 1123, 1133, 1154 |
| [PA0000](EXTERNAL_DEPENDENCIES.md#PA0000) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L127, 668 |
| [PA9021](PA9021.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L24 |
| [ZHRT001](EXTERNAL_DEPENDENCIES.md#ZHRT001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L191, 716 |
| [ZHRT002](EXTERNAL_DEPENDENCIES.md#ZHRT002) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L191, 716 |
| [ZHR_52TM_AWART_LIST](ZHR_52TM_AWART_LIST.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L79, 165, 690 |
| [ZHR_52TM_CHECK_APPROVER_N](EXT-ZHR_52TM_CHECK_APPROVER_N.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L523 |
| [ZHR_52TM_CW_BASE_DATA](ZHR_52TM_CW_BASE_DATA.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L414 |
| [ZHR_52TM_GET_PERSONNEL_DATA_N](ZHR_52TM_GET_PERSONNEL_DATA_N.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L140 |
| [ZHR_52TM_MEMBER_CHECK](ZHR_52TM_MEMBER_CHECK.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L249, 773 |
| [ZHR_52TM_VALID_DATE_CHECK](ZHR_52TM_VALID_DATE_CHECK.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L265 |
| [ZHR_GET_TIME_DIFF_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_TIME_DIFF_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L590 |
| [ZSHR0111](ZSHR0111.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L19, 111, 655, 890, 892 |
| [ZSHR0137](ZSHR0137.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L394 |
| [ZSHR0141](ZSHR0141.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L107, 295, 390, 393, 409, 516, 551, 651, 817, 886, 1090, 1091 |
| [ZTHR0112](ZTHR0112.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L157, 682, 925, 1026 |
| [ZTHR0112](ZTHR0112.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L110, 654, 891 |
| [ZTHR0132](ZTHR0132.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L40 |
| [ZTHRBS08](EXTERNAL_DEPENDENCIES.md#ZTHRBS08) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L180, 705 |
| [ZTHRBS13](EXT-ZTHRBS13.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L229, 753 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_3F03](LZHR008_3F03.md) | FORM 호출 | [LZHR008_3F03.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap) L145, 150, 156, 161, 183, 758, 1132, 1137, 1143, 1148, 1186 |
| [SAPLZHR008_3](SAPLZHR008_3.md) | Include | [SAPLZHR008_3.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/SAPLZHR008_3.abap) L15 |
| [ZHR_52TM_CW_CHECK_DATA](ZHR_52TM_CW_CHECK_DATA.md) | FORM 호출 | [ZHR_52TM_CW_CHECK_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CHECK_DATA/Source%20code/ZHR_52TM_CW_CHECK_DATA.abap) L18, 25, 37, 44, 49, 54, 60, 69 |

### 관련 업무와 미확인 범위

- [retired](../topics/retired.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
