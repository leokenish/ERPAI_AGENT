---
title: "ZRPTH402F01 — 탄력 정산 확정"
as_of: 2026-10-07
review_status: pending_business_review
tags: [월정산전표지급, 탄력근무]
---

# ZRPTH402F01 — 탄력 정산 확정

[소스 설명 목차](INDEX.md) · [원본 파일](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap)

월정산 결과를 PA2010에 연결하는 코드. 실제 지급 완료를 뜻하지 않는다.

확인 수준: 표시한 소스 구간 정적 확인; 운영 실행 검증 아님. 원본 경로·파일은 그대로 유지한다.

## 근거 위치

| 위치 | 관계의 의미 | 근거 구문 |
|---|---|---|
| 17행 | 월정산 계산 호출 | `CALL FUNCTION 'ZHR_52TM_MONTHLY_PAYMENT'` |
| 592행 | 확정 데이터 반영 | `MODIFY pa2010 FROM TABLE lt_2010.` |

## 연결된 소스

- [ZHR_52TM_MONTHLY_PAYMENT](ZHR_52TM_MONTHLY_PAYMENT.md) — 함수 호출 확인, 위 원본 17행. 호출 이후 전체 실행 성공은 미검증.

## 관련 업무

<!-- topics -->
- [월정산·확정·전표·지급](../topics/settlement.md) — 이 소스를 검토하는 업무 지도.
- [탄력근로 계획·결재](../topics/flexible.md) — 이 소스를 검토하는 업무 지도.

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 제목 메타데이터 없음; 이름만으로 업무를 확정하지 않음.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZRPTH402F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/attributes/ZRPTH402F01.xml) | 36행; 원본 보존 |
| [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) | 1128행; 원본 보존 |
| [../texts/ZRPTH402F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/texts/ZRPTH402F01.xml) | 16행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — col_textarea 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L361 |
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — heading 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L947, 973, 985 |
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — large 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L974 |
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — list_heading_int 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L948, 975 |
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — list_negative_inv 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L987 |
| [CL_GUI_CFW](EXTERNAL_DEPENDENCIES.md#CL_GUI_CFW) | **클래스 참조** — flush 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L512 |
| [DOMAIN_VALUE_GET](EXTERNAL_DEPENDENCIES.md#DOMAIN_VALUE_GET) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L791 |
| [PA0001](EXTERNAL_DEPENDENCIES.md#PA0001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L740 |
| [PA2010](EXT-PA2010.md) | **데이터 저장** — DELETE DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L868 |
| [PA2010](EXT-PA2010.md) | **데이터 저장** — MODIFY DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L592 |
| [PA2010](EXT-PA2010.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L843 |
| [POPUP_TO_CONFIRM](EXTERNAL_DEPENDENCIES.md#POPUP_TO_CONFIRM) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L395, 423, 467 |
| [T512T](EXTERNAL_DEPENDENCIES.md#T512T) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L700 |
| [ZHR_52TM_MONTHLY_PAYMENT](ZHR_52TM_MONTHLY_PAYMENT.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L17 |
| [ZRPTH402F01](ZRPTH402F01.md) | **FORM 호출** — APPEND_INIT_FIELDCAT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap L179; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L65, 102, 119, 150 |
| [ZRPTH402F01](ZRPTH402F01.md) | **FORM 호출** — CANCLE_CONFIRM_DATA: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap L814; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L447 |
| [ZRPTH402F01](ZRPTH402F01.md) | **FORM 호출** — CONFIRM_DATA: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap L540; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L420 |
| [ZRPTH402F01](ZRPTH402F01.md) | **FORM 호출** — CREATE_INIT_FIELDCAT2: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap L114; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L336 |
| [ZRPTH402F01](ZRPTH402F01.md) | **FORM 호출** — CREATE_INIT_FIELDCAT3: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap L145; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L347 |
| [ZRPTH402F01](ZRPTH402F01.md) | **FORM 호출** — CREATE_INIT_FIELDCAT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap L60; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L322 |
| [ZRPTH402F01](ZRPTH402F01.md) | **FORM 호출** — GET_52WKTY_TEXT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap L783; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L1105 |
| [ZRPTH402F01](ZRPTH402F01.md) | **FORM 호출** — GET_ORGTX: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap L765; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L42, 647, 677, 745 |
| [ZRPTH402F01](ZRPTH402F01.md) | **FORM 호출** — SET_APPROVE_STATUS: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap L1096; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L495 |
| [ZRPTH402F01](ZRPTH402F01.md) | **FORM 호출** — SET_SORT_TAB: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap L1036; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L273 |
| [ZSHR0120](ZSHR0120.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L14 |
| [ZTHR0110](ZTHR0110.md) | **데이터 저장** — MODIFY DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L604, 880, 1112 |
| [ZTHR0110](ZTHR0110.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L548, 833 |
| [ZTHR0110](ZTHR0110.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L541, 815, 1097 |
| [ZTHR0120](ZTHR0120.md) | **데이터 저장** — DELETE FROM DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L892 |
| [ZTHR0120](ZTHR0120.md) | **데이터 저장** — MODIFY DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L615 |
| [ZTHR0120](ZTHR0120.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L542, 816 |
| [ZWF0022](EXT-ZWF0022.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L562 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [ZRPTH402](ZRPTH402.md) | FORM 호출 | [ZRPTH402.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402/source/ZRPTH402.abap) L113, 143, 158, 163, 168 |
| [ZRPTH402](ZRPTH402.md) | Include | [ZRPTH402.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402/source/ZRPTH402.abap) L15 |
| [ZRPTH402F01](ZRPTH402F01.md) | FORM 호출 | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L42, 65, 102, 119, 150, 273, 322, 336, 347, 420, 447, 495, 647, 677, 745, 1105 |
| [ZRPTH402TOP](ZRPTH402TOP.md) | FORM 호출 | [ZRPTH402TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402TOP/source/ZRPTH402TOP.abap) L73 |

### 관련 업무와 미확인 범위

- [flexible](../topics/flexible.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [settlement](../topics/settlement.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
