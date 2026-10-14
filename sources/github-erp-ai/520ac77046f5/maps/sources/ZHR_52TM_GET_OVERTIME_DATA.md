---
title: "ZHR_52TM_GET_OVERTIME_DATA — 통상·시차 계산과 실비 표시"
as_of: 2026-10-07
review_status: pending_business_review
tags: [교대근무, 통상시차시간외, 퇴직자관리자입력검토, 휴가공가반차]
---

# ZHR_52TM_GET_OVERTIME_DATA — 통상·시차 계산과 실비 표시

[소스 설명 목차](INDEX.md) · [원본 파일](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Source%20code/ZHR_52TM_GET_OVERTIME_DATA.abap)

금액 0원 분기를 발견한 것만으로 결함을 단정하지 않는다. SRC-14는 해당 사례의 입력 시작시각을 정정했다.

확인 수준: 표시한 소스 구간 정적 확인; 운영 실행 검증 아님. 원본 경로·파일은 그대로 유지한다.

## 근거 위치

| 위치 | 관계의 의미 | 근거 구문 |
|---|---|---|
| 61행 | 일별 시간·금액 처리 FORM 호출 | `PERFORM calc_work_time_daily   " 이거 꼭 함수로 만들어라.... 통상 시간외 전용 함수로....` |
| 133행 | 시차 7시간/휴게시간 조건 | `if ( ( es_overtime_data-ZA_TIME < 070000 OR ( es_overtime_data-ZA_TIME >= 070000 AND LV_RESTTIME < '010000' ) )` |
| 144행 | 야간 표시용 금액 초기화 | `es_overtime_data-zn_money_c  = 0.` |

## 관련 업무

<!-- topics -->
- [휴가·공가·반차](../topics/leave.md) — 이 소스를 검토하는 업무 지도.
- [통상·시차 시간외 입력](../topics/ordinary.md) — 이 소스를 검토하는 업무 지도.

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 통상/교대 시간외실비신청 시간및 금액정보 산출.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Changing.xml) | 193행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Exception.xml) | 136행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Export.xml) | 225행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Import.xml) | 249행; 원본 보존 |
| [ZHR_52TM_GET_OVERTIME_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Source%20code/ZHR_52TM_GET_OVERTIME_DATA.abap) | 168행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Tables.xml) | 148행; 원본 보존 |
| [../../../Include/LZHR008_2U22.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U22.abap) | 168행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U22.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U22.abap) L1 | LZHR008_2U22: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Changing | `C_ZEMCWK` | CHAR01 | X | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Changing.xml) L8 |
| Changing | `C_ZTOICH` | CHAR01 | X | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Changing.xml) L22 |
| Changing | `C_ZTOMOH` | CHAR01 | X | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Changing.xml) L36 |
| Changing | `C_ZDAEH` | CHAR01 | X | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Changing.xml) L50 |
| Export | `ES_OVERTIME_DATA` | ZSH_OVERTIME_DATA_N | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Export.xml) L8 |
| Export | `E_ZPDWK_TM` | [ZEPDWK_TM](ZEPDWK_TM.md) | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Export.xml) L19 |
| Export | `E_CODE` | CHAR03 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Export.xml) L30 |
| Export | `E_TEXT` | CHAR200 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Export.xml) L41 |
| Export | `E_ZEMCWK_O` | CHAR01 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Export.xml) L52 |
| Export | `E_ZTOICH_O` | CHAR01 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Export.xml) L63 |
| Export | `E_ZTOMOH_O` | CHAR01 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Export.xml) L74 |
| Export | `E_ZDAEH_O` | CHAR01 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Export.xml) L85 |
| Import | `I_MODE` | CHAR01 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Import.xml) L8 |
| Import | `I_WKTYPE` | [ZEWKTYPE](ZEWKTYPE.md) | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Import.xml) L22 |
| Import | `I_ACTION` | SYUCOMM | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Import.xml) L36 |
| Import | `I_ZEXC` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Import.xml) L50 |
| Import | `I_MTYPE` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Import.xml) L64 |
| Import | `I_ZDIFF` | I | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Import.xml) L78 |
| Import | `I_RUN_R3` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Import.xml) L92 |
| Import | `IS_ZTHRBS01` | ZTHRBS01 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Import.xml) L106 |
| Tables | `T_ZDAEH` | [ZSHR0121](ZSHR0121.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Tables.xml) L8 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F03](LZHR008_2F03.md) | **FORM 호출** — CALC_WORK_TIME_DAILY: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap L5481; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_GET_OVERTIME_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Source%20code/ZHR_52TM_GET_OVERTIME_DATA.abap) L61 |
| [LZHR008_2F03](LZHR008_2F03.md) | **FORM 호출** — CLEAR_DAYS_TABLE: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap L2699; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_GET_OVERTIME_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Source%20code/ZHR_52TM_GET_OVERTIME_DATA.abap) L36 |
| [ZEPDWK_TM](ZEPDWK_TM.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Export.xml) L23 |
| [ZEWKTYPE](ZEWKTYPE.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Import.xml) L29 |
| [ZHR_52TM_ORDINARY_ZE_TIME2](ZHR_52TM_ORDINARY_ZE_TIME2.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_GET_OVERTIME_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Source%20code/ZHR_52TM_GET_OVERTIME_DATA.abap) L90 |
| [ZHR_GET_DAY_DATA_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_DAY_DATA_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_GET_OVERTIME_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Source%20code/ZHR_52TM_GET_OVERTIME_DATA.abap) L52 |
| [ZSHR0121](ZSHR0121.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Tables.xml) L9 |
| [ZSH_OVERTIME_DATA_N](EXTERNAL_DEPENDENCIES.md#ZSH_OVERTIME_DATA_N) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Export.xml) L12 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Import.xml) L113 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F05](LZHR008_2F05.md) | 직접 호출 | [LZHR008_2F05.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F05.abap) L168 |
| [LZHR008_2F06](LZHR008_2F06.md) | 직접 호출 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L572, 1027, 1292 |
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L45 |
| [MZH4110F01](MZH4110F01.md) | 직접 호출 | [MZH4110F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110F01/source/MZH4110F01.abap) L413 |
| [ZHR_52TM_GET_OVERTIME_SAVE](ZHR_52TM_GET_OVERTIME_SAVE.md) | 직접 호출 | [ZHR_52TM_GET_OVERTIME_SAVE.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Source%20code/ZHR_52TM_GET_OVERTIME_SAVE.abap) L40 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
