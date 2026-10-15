---
title: "ZHR_52TM_SET_DEFAULT_TIME — [52시간] 통상/교대 시간외근무 신청 초기 시간 설정"
as_of: 2026-10-07
review_status: pending_business_review
tags: [IAM등록기본설정, 교대근무, 근무현황조회, 통상시차시간외, 퇴직자관리자입력검토]
---

# ZHR_52TM_SET_DEFAULT_TIME — [52시간] 통상/교대 시간외근무 신청 초기 시간 설정

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 통상/교대 시간외근무 신청 초기 시간 설정.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Changing.xml) | 325행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Exception.xml) | 268행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) | 599행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Import.xml) | 395행; 원본 보존 |
| [ZHR_52TM_SET_DEFAULT_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Source%20code/ZHR_52TM_SET_DEFAULT_TIME.abap) | 395행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Tables.xml) | 268행; 원본 보존 |
| [../../../Include/LZHR008_2U26.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U26.abap) | 395행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U26.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U26.abap) L1 | LZHR008_2U26: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Changing | `C_ZCOSA` | ZPERNR0 | X | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Changing.xml) L8 |
| Changing | `C_ZCOPE` | ZCOPERSON | X | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Changing.xml) L22 |
| Changing | `C_CORGTX` | CHAR50 | X | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Changing.xml) L36 |
| Changing | `C_ZTEXT` | ZBSTEXT | X | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Changing.xml) L50 |
| Export | `E_ZBEGT` | BEGTI | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L8 |
| Export | `E_ZENDT` | ENDTI | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L19 |
| Export | `E_ZTOMO` | ZTOMO | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L30 |
| Export | `E_ZDANGB` | ZDANGB | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L41 |
| Export | `E_ZDANGJ` | ZDANGJ | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L52 |
| Export | `E_WKTIM01_M` | I | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L63 |
| Export | `E_WKTIM02_M` | I | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L74 |
| Export | `E_WKTIM03_M` | I | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L85 |
| Export | `E_WKTIM04_M` | I | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L96 |
| Export | `E_WKTIM05_M` | I | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L107 |
| Export | `E_WKTIM06_M` | I | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L118 |
| Export | `E_ZGUBN` | I | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L129 |
| Export | `E_ZPBEG1` | PDBEG | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L140 |
| Export | `E_ZPEND1` | PDEND | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L151 |
| Export | `E_ZPDWK_TM` | [ZEPDWK_TM](ZEPDWK_TM.md) | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L162 |
| Export | `E_ZPBTM` | ZTOMO | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L173 |
| Export | `E_ZPETM` | ZTOMO | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L184 |
| Export | `E_WAERS` | WAERS | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L195 |
| Export | `E_CODE` | CHAR03 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L206 |
| Export | `E_TEXT` | CHAR200 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L217 |
| Export | `E_WKTYPE` | [ZEWKTYPE](ZEWKTYPE.md) | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L228 |
| Export | `E_ZPBEG2` | PDBEG | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L239 |
| Export | `E_ZPEND2` | PDEND | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L250 |
| Export | `E_ZPBTM2` | ZTOMO | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L261 |
| Export | `E_ZPETM2` | ZTOMO | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L272 |
| Export | `E_ZCOSA` | ZPERNR0 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L283 |
| Export | `E_ZCOPE` | ZCOPERSON | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L294 |
| Export | `E_CORGTX` | CHAR50 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L305 |
| Export | `E_ZTEXT` | ZBSTEXT | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L316 |
| Export | `E_ZCID` | ZCID | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L327 |
| Import | `I_PERNR` | PERSNO | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Import.xml) L8 |
| Import | `I_ZNAL` | ZNAL | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Import.xml) L22 |
| Import | `I_ZGUBUN` | ZBSGUBUN | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Import.xml) L36 |
| Import | `I_WKTYPE` | [ZEWKTYPE](ZEWKTYPE.md) | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Import.xml) L50 |
| Import | `I_SEQNR` | SEQNR | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Import.xml) L64 |
| Import | `I_MODE` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Import.xml) L78 |
| Import | `I_MODE2` | CHAR2 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Import.xml) L92 |
| Import | `I_MODE3` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Import.xml) L106 |
| Import | `I_ISFST` | CHAR01 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Import.xml) L120 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F04](LZHR008_2F04.md) | **FORM 호출** — GET_WEEK_BASIC_TIME: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F04.abap L442; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_SET_DEFAULT_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Source%20code/ZHR_52TM_SET_DEFAULT_TIME.abap) L160 |
| [LZHR008_2F04](LZHR008_2F04.md) | **FORM 호출** — GET_WEEK_BASIC_TIME_FOR_REPORT: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F04.abap L1508; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_SET_DEFAULT_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Source%20code/ZHR_52TM_SET_DEFAULT_TIME.abap) L138 |
| [ZBSGUBUN](EXTERNAL_DEPENDENCIES.md#ZBSGUBUN) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Import.xml) L43 |
| [ZBSTEXT](EXTERNAL_DEPENDENCIES.md#ZBSTEXT) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Changing.xml) L57 |
| [ZBSTEXT](EXTERNAL_DEPENDENCIES.md#ZBSTEXT) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L320 |
| [ZCID](EXTERNAL_DEPENDENCIES.md#ZCID) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L331 |
| [ZCL_CM_UTIL_DEV](EXT-ZCL_CM_UTIL_DEV.md) | **클래스 참조** — conversion_alpha 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZHR_52TM_SET_DEFAULT_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Source%20code/ZHR_52TM_SET_DEFAULT_TIME.abap) L362 |
| [ZCL_CM_UTIL_DEV](EXT-ZCL_CM_UTIL_DEV.md) | **클래스 참조** — get_jikwitext 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZHR_52TM_SET_DEFAULT_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Source%20code/ZHR_52TM_SET_DEFAULT_TIME.abap) L357 |
| [ZCL_CM_UTIL_DEV](EXT-ZCL_CM_UTIL_DEV.md) | **클래스 참조** — get_name 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZHR_52TM_SET_DEFAULT_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Source%20code/ZHR_52TM_SET_DEFAULT_TIME.abap) L352 |
| [ZCL_CM_UTIL_DEV](EXT-ZCL_CM_UTIL_DEV.md) | **클래스 참조** — get_vdstext 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZHR_52TM_SET_DEFAULT_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Source%20code/ZHR_52TM_SET_DEFAULT_TIME.abap) L354 |
| [ZCOPERSON](EXTERNAL_DEPENDENCIES.md#ZCOPERSON) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Changing.xml) L29 |
| [ZCOPERSON](EXTERNAL_DEPENDENCIES.md#ZCOPERSON) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L298 |
| [ZDANGB](EXTERNAL_DEPENDENCIES.md#ZDANGB) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L45 |
| [ZDANGJ](EXTERNAL_DEPENDENCIES.md#ZDANGJ) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L56 |
| [ZEPDWK_TM](ZEPDWK_TM.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L166 |
| [ZEWKTYPE](ZEWKTYPE.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L232 |
| [ZEWKTYPE](ZEWKTYPE.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Import.xml) L57 |
| [ZHR_52TM_CALC_BREAK_TIME](ZHR_52TM_CALC_BREAK_TIME.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_SET_DEFAULT_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Source%20code/ZHR_52TM_SET_DEFAULT_TIME.abap) L196, 340 |
| [ZHR_52TM_EARLIER_WORKER](ZHR_52TM_EARLIER_WORKER.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_SET_DEFAULT_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Source%20code/ZHR_52TM_SET_DEFAULT_TIME.abap) L249 |
| [ZHR_52TM_PERSONAL_WORK_TIME](ZHR_52TM_PERSONAL_WORK_TIME.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_SET_DEFAULT_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Source%20code/ZHR_52TM_SET_DEFAULT_TIME.abap) L86 |
| [ZHR_52TM_SET_BREAK_TIME](ZHR_52TM_SET_BREAK_TIME.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_SET_DEFAULT_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Source%20code/ZHR_52TM_SET_DEFAULT_TIME.abap) L215 |
| [ZHR_GET_DAY_DATA_N](EXTERNAL_DEPENDENCIES.md#ZHR_GET_DAY_DATA_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_SET_DEFAULT_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Source%20code/ZHR_52TM_SET_DEFAULT_TIME.abap) L257 |
| [ZNAL](EXTERNAL_DEPENDENCIES.md#ZNAL) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Import.xml) L29 |
| [ZPERNR0](EXTERNAL_DEPENDENCIES.md#ZPERNR0) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Changing.xml) L15 |
| [ZPERNR0](EXTERNAL_DEPENDENCIES.md#ZPERNR0) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L287 |
| [ZSHR0122](ZSHR0122.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_SET_DEFAULT_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Source%20code/ZHR_52TM_SET_DEFAULT_TIME.abap) L52 |
| [ZSHR0131](ZSHR0131.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_SET_DEFAULT_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Source%20code/ZHR_52TM_SET_DEFAULT_TIME.abap) L213 |
| [ZTHR0124](ZTHR0124.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_SET_DEFAULT_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Source%20code/ZHR_52TM_SET_DEFAULT_TIME.abap) L322 |
| [ZTHR0124](ZTHR0124.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_SET_DEFAULT_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Source%20code/ZHR_52TM_SET_DEFAULT_TIME.abap) L56 |
| [ZTHRWORKSCHEDULE](EXT-ZTHRWORKSCHEDULE.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_SET_DEFAULT_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Source%20code/ZHR_52TM_SET_DEFAULT_TIME.abap) L273 |
| [ZTOMO](EXTERNAL_DEPENDENCIES.md#ZTOMO) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Export.xml) L34, 177, 188, 265, 276 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F06](LZHR008_2F06.md) | 직접 호출 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L165, 645, 813, 1085, 1207 |
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L55 |
| [MZH4110F01](MZH4110F01.md) | 직접 호출 | [MZH4110F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110F01/source/MZH4110F01.abap) L288, 539 |
| [ZHR_52TM_CHECK_INPUT_DATA](ZHR_52TM_CHECK_INPUT_DATA.md) | 직접 호출 | [ZHR_52TM_CHECK_INPUT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Source%20code/ZHR_52TM_CHECK_INPUT_DATA.abap) L383 |
| [ZHR_52TM_CHECK_INPUT_DATA_M](ZHR_52TM_CHECK_INPUT_DATA_M.md) | 직접 호출 | [ZHR_52TM_CHECK_INPUT_DATA_M.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA_M/Source%20code/ZHR_52TM_CHECK_INPUT_DATA_M.abap) L281 |
| [ZHR_52TM_CHECK_WKTYPE](ZHR_52TM_CHECK_WKTYPE.md) | 직접 호출 | [ZHR_52TM_CHECK_WKTYPE.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_WKTYPE/Source%20code/ZHR_52TM_CHECK_WKTYPE.abap) L34 |
| [ZHR_52TM_MOBILE_OVERTIME_DETL](ZHR_52TM_MOBILE_OVERTIME_DETL.md) | 직접 호출 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L168 |
| [ZHR_52TM_REAL_WORK_TIME_TEAM](ZHR_52TM_REAL_WORK_TIME_TEAM.md) | 직접 호출 | [ZHR_52TM_REAL_WORK_TIME_TEAM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME_TEAM/Source%20code/ZHR_52TM_REAL_WORK_TIME_TEAM.abap) L729 |
| [ZHR_52TM_REAL_WORK_TIME_TEAM_M](ZHR_52TM_REAL_WORK_TIME_TEAM_M.md) | 직접 호출 | [ZHR_52TM_REAL_WORK_TIME_TEAM_M.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME_TEAM_M/Source%20code/ZHR_52TM_REAL_WORK_TIME_TEAM_M.abap) L772 |

### 관련 업무와 미확인 범위

- [iam](../topics/iam.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
