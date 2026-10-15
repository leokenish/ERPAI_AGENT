---
title: "ZHR_52TM_CHECK_INPUT_DATA — [52시간] 통상/교대 시간외실비신청 입력 Check"
as_of: 2026-10-07
review_status: pending_business_review
tags: [교대근무, 통상시차시간외, 퇴직자관리자입력검토]
---

# ZHR_52TM_CHECK_INPUT_DATA — [52시간] 통상/교대 시간외실비신청 입력 Check

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 통상/교대 시간외실비신청 입력 Check.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Changing.xml) | 70행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Exception.xml) | 70행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Export.xml) | 93행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Import.xml) | 183행; 원본 보존 |
| [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) | 1136행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Tables.xml) | 70행; 원본 보존 |
| [../../../Include/LZHR008_2U17.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U17.abap) | 1136행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U17.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U17.abap) L1 | LZHR008_2U17: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_CODE` | CHAR03 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Export.xml) L8 |
| Export | `E_TEXT` | CHAR200 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Export.xml) L19 |
| Import | `I_MODE` | CHAR01 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Import.xml) L8 |
| Import | `I_ACTION` | SYUCOMM | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Import.xml) L22 |
| Import | `I_WKTYPE` | [ZEWKTYPE](ZEWKTYPE.md) | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Import.xml) L36 |
| Import | `I_WKTOT` | CHAR6 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Import.xml) L50 |
| Import | `I_WKREG` | CHAR05 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Import.xml) L64 |
| Import | `I_ATIME` | CHAR05 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Import.xml) L78 |
| Import | `I_WKOTS` | CHAR05 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Import.xml) L92 |
| Import | `IS_ZTHRBS01` | ZTHRBS01 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Import.xml) L106 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [AGR_USERS](EXTERNAL_DEPENDENCIES.md#AGR_USERS) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L201 |
| [LZHR008_2F03](LZHR008_2F03.md) | **FORM 호출** — CHECK_ABSENCE_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap L2026; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L627 |
| [LZHR008_2F03](LZHR008_2F03.md) | **FORM 호출** — CHECK_BKTIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap L5006; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L147 |
| [LZHR008_2F03](LZHR008_2F03.md) | **FORM 호출** — CHECK_EXCEP: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap L1528; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L169 |
| [LZHR008_2F03](LZHR008_2F03.md) | **FORM 호출** — CHECK_INPUT_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap L179; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L92 |
| [LZHR008_2F03](LZHR008_2F03.md) | **FORM 호출** — CHECK_INPUT_DATE: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap L363; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L79 |
| [LZHR008_2F03](LZHR008_2F03.md) | **FORM 호출** — CHECK_NEXTHOLIDAY_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap L2170; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L639 |
| [LZHR008_2F03](LZHR008_2F03.md) | **FORM 호출** — CHECK_OVERTIME_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap L2218; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L651 |
| [LZHR008_2F03](LZHR008_2F03.md) | **FORM 호출** — CHECK_TRAINING_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap L16; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L595 |
| [LZHR008_2F03](LZHR008_2F03.md) | **FORM 호출** — CHECK_TRIP_DATA: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap L1903; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L616 |
| [LZHR008_2F03](LZHR008_2F03.md) | **FORM 호출** — CHECK_TRIP_DATA_N: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap L1579; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L607 |
| [LZHR008_2F03](LZHR008_2F03.md) | **FORM 호출** — CHECK_WKDATE: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap L431; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L112 |
| [LZHR008_2F03](LZHR008_2F03.md) | **FORM 호출** — CHECK_WKTIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap L1329; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L126 |
| [LZHR008_2F03](LZHR008_2F03.md) | **FORM 호출** — CHECK_WORKSCHEDULE_DAYTIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap L6369; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L207 |
| [LZHR008_2F03](LZHR008_2F03.md) | **FORM 호출** — GET_REMAIN_DAY_WORK_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap L6177; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L257 |
| [LZHR008_2F04](LZHR008_2F04.md) | **FORM 호출** — CONVERT_MIN: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F04.abap L2009; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L246, 268, 315, 320, 325, 349, 433, 439 |
| [RH_GET_DATE_DAYNAME](EXTERNAL_DEPENDENCIES.md#RH_GET_DATE_DAYNAME) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L283, 404 |
| [ZECNVAL](ZECNVAL.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L41 |
| [ZEMAXHR](ZEMAXHR.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L53, 54, 55 |
| [ZEWKTYPE](ZEWKTYPE.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Import.xml) L43 |
| [ZHR_52TM_NEW_ORDINARY_TIME2](ZHR_52TM_NEW_ORDINARY_TIME2.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L338 |
| [ZHR_52TM_NEW_SHIFTWORK_TIME](ZHR_52TM_NEW_SHIFTWORK_TIME.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L365 |
| [ZHR_52TM_SET_DEFAULT_TIME](ZHR_52TM_SET_DEFAULT_TIME.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L383 |
| [ZHR_MINUS_TIME_N](EXTERNAL_DEPENDENCIES.md#ZHR_MINUS_TIME_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L231, 302, 419 |
| [ZTHR0101](ZTHR0101.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L273 |
| [ZTHR0102](ZTHR0102.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L507, 527 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Import.xml) L113 |
| [ZTHRBS17](EXTERNAL_DEPENDENCIES.md#ZTHRBS17) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L492 |
| [ZTHRWORKSCHEDULE](EXT-ZTHRWORKSCHEDULE.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L470 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F06](LZHR008_2F06.md) | 직접 호출 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L1109 |
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L35 |
| [MZH4110F01](MZH4110F01.md) | 직접 호출 | [MZH4110F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110F01/source/MZH4110F01.abap) L770 |

### 관련 업무와 미확인 범위

- [ordinary](../topics/ordinary.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [shift](../topics/shift.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
