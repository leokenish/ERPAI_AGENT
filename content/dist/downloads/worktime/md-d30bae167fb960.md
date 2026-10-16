---
title: "ZHR_WF_GET_MY_LIST — [공통결재]결재리스트 가져오기 - 구 결재함 (대기/결재중/완료/반려/회수함 등)"
as_of: 2026-10-07
review_status: pending_business_review
tags: [통합결재]
---

# ZHR_WF_GET_MY_LIST — [공통결재]결재리스트 가져오기 - 구 결재함 (대기/결재중/완료/반려/회수함 등)

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [공통결재]결재리스트 가져오기 - 구 결재함 (대기/결재중/완료/반려/회수함 등).

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Changing.xml) | 58행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Exception.xml) | 58행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Export.xml) | 81행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Import.xml) | 129행; 원본 보존 |
| [ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap) | 469행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Tables.xml) | 70행; 원본 보존 |
| [../../../Include/LZHR008_3U09.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3U09.abap) | 469행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_3U09.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3U09.abap) L1 | LZHR008_3U09: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_RCODE` | ZE_RESULTCODE | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Export.xml) L8 |
| Export | `E_RMSG` | ZE_RESULTMSG | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Export.xml) L19 |
| Import | `I_MODE` | CHAR100 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Import.xml) L8 |
| Import | `I_BOX_NAME` | CHAR100 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Import.xml) L22 |
| Import | `I_SABUN` | ZLOGIN_ID | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Import.xml) L36 |
| Import | `I_STRDATE` | ZREGDT | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Import.xml) L50 |
| Import | `I_ENDDATE` | ZREGDT | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Import.xml) L64 |
| Tables | `T_LIST` | ZSWFCF01 | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Tables.xml) L8 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [PA0001](EXTERNAL_DEPENDENCIES.md#PA0001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap) L371 |
| [ZE_RESULTCODE](EXTERNAL_DEPENDENCIES.md#ZE_RESULTCODE) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Export.xml) L12 |
| [ZE_RESULTMSG](EXTERNAL_DEPENDENCIES.md#ZE_RESULTMSG) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Export.xml) L23 |
| [ZHR_WF_GET_MY_LIST](ZHR_WF_GET_MY_LIST.md) | **FORM 호출** — ZWEB_WF_GET_HR_LIST_ZAPDT: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_WF_GET_MY_LIST/Source code/ZHR_WF_GET_MY_LIST.abap L295; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap) L254 |
| [ZHR_WF_GET_MY_LIST](ZHR_WF_GET_MY_LIST.md) | **FORM 호출** — ZWEB_WF_GET_MY_OLD_LIST_STATUS: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_WF_GET_MY_LIST/Source code/ZHR_WF_GET_MY_LIST.abap L394; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap) L170 |
| [ZLOGIN_ID](EXTERNAL_DEPENDENCIES.md#ZLOGIN_ID) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Import.xml) L43 |
| [ZREGDT](EXTERNAL_DEPENDENCIES.md#ZREGDT) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Import.xml) L57, 71 |
| [ZSWFCF01](EXTERNAL_DEPENDENCIES.md#ZSWFCF01) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Tables.xml) L9 |
| [ZTH0500](EXTERNAL_DEPENDENCIES.md#ZTH0500) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap) L373 |
| [ZTHR0106](ZTHR0106.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap) L142 |
| [ZTHR0106](ZTHR0106.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap) L42 |
| [ZTHR0110](ZTHR0110.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap) L148 |
| [ZTHR0110](ZTHR0110.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap) L43 |
| [ZTHR0112](ZTHR0112.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap) L158 |
| [ZTHR0112](ZTHR0112.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap) L44 |
| [ZWEB_COMMON_SERVER_PREFIX](EXTERNAL_DEPENDENCIES.md#ZWEB_COMMON_SERVER_PREFIX) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap) L66 |
| [ZWEB_WF_IS_ADMIN](EXTERNAL_DEPENDENCIES.md#ZWEB_WF_IS_ADMIN) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap) L58 |
| [ZWF0022](EXT-ZWF0022.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap) L112, 119, 310, 412 |
| [ZWF_OLD_URL_LIST](EXTERNAL_DEPENDENCIES.md#ZWF_OLD_URL_LIST) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap) L76, 81 |
| [ZWF_SET_EXCLUDE](EXTERNAL_DEPENDENCIES.md#ZWF_SET_EXCLUDE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap) L304, 405 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_3UXX](LZHR008_3UXX.md) | Include | [LZHR008_3UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3UXX.abap) L21 |
| [ZHR_WF_GET_MY_LIST](ZHR_WF_GET_MY_LIST.md) | FORM 호출 | [ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap) L170, 254 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
