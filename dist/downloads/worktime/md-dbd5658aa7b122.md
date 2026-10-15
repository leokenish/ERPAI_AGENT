---
title: "ZRPTH411F01 — 선택 월정산 처리"
as_of: 2026-10-07
review_status: pending_business_review
tags: [선택근무, 월정산전표지급, 특별연장재난방송]
---

# ZRPTH411F01 — 선택 월정산 처리

[소스 설명 목차](INDEX.md) · [원본 파일](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap)

선택 기간 정산 호출 및 PA2010 반영 코드의 일부를 확인했다. 원래 Include 헤더 주석과 실제 파일명이 다르므로 파일 경로를 기준으로 한다.

확인 수준: 표시한 소스 구간 정적 확인; 운영 실행 검증 아님. 원본 경로·파일은 그대로 유지한다.

## 근거 위치

| 위치 | 관계의 의미 | 근거 구문 |
|---|---|---|
| 36행 | 기간 정산 호출 | `CALL FUNCTION 'ZHR_52TM_CW_PAYMENT_WKPRD'` |
| 737행 | 산정 결과 인포타입 반영 구문 | `MODIFY pa2010 FROM TABLE lt_2010.` |

## 연결된 소스

- [ZHR_52TM_CW_PAYMENT_WKPRD](ZHR_52TM_CW_PAYMENT_WKPRD.md) — 함수 호출 확인, 위 원본 36행. 호출 이후 전체 실행 성공은 미검증.

## 관련 업무

<!-- topics -->
- [월정산·확정·전표·지급](../topics/settlement.md) — 이 소스를 검토하는 업무 지도.
- [선택근무](../topics/selective.md) — 이 소스를 검토하는 업무 지도.

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 제목 메타데이터 없음; 이름만으로 업무를 확정하지 않음.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZRPTH411F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/attributes/ZRPTH411F01.xml) | 36행; 원본 보존 |
| [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) | 1501행; 원본 보존 |
| [../texts/ZRPTH411F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/texts/ZRPTH411F01.xml) | 16행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [CL_DD_AREA](EXTERNAL_DEPENDENCIES.md#CL_DD_AREA) | **클래스 참조** — col_textarea 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L478 |
| [CL_GUI_CFW](EXTERNAL_DEPENDENCIES.md#CL_GUI_CFW) | **클래스 참조** — flush 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L654 |
| [DOMAIN_VALUE_GET](EXTERNAL_DEPENDENCIES.md#DOMAIN_VALUE_GET) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L1157 |
| [HR_READ_FOREIGN_OBJECT_TEXT](EXTERNAL_DEPENDENCIES.md#HR_READ_FOREIGN_OBJECT_TEXT) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L94, 879, 964, 1088 |
| [PA0001](EXTERNAL_DEPENDENCIES.md#PA0001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L1050 |
| [PA2010](EXT-PA2010.md) | **데이터 저장** — DELETE DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L1231 |
| [PA2010](EXT-PA2010.md) | **데이터 저장** — MODIFY DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L737 |
| [PA2010](EXT-PA2010.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L1206 |
| [POPUP_TO_CONFIRM](EXTERNAL_DEPENDENCIES.md#POPUP_TO_CONFIRM) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L515, 559, 606 |
| [RH_READ_OBJECT](EXTERNAL_DEPENDENCIES.md#RH_READ_OBJECT) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L78, 863, 948, 1072 |
| [T503T](EXTERNAL_DEPENDENCIES.md#T503T) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L73, 840, 943, 1067 |
| [T512T](EXTERNAL_DEPENDENCIES.md#T512T) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L1006 |
| [ZHR_52TM_CW_PAYMENT_WKPRD](ZHR_52TM_CW_PAYMENT_WKPRD.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L36 |
| [ZRPTH411F01](ZRPTH411F01.md) | **FORM 호출** — APPEND_INIT_FIELDCAT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap L287; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L157, 202, 219, 254 |
| [ZRPTH411F01](ZRPTH411F01.md) | **FORM 호출** — CANCLE_CONFIRM_DATA: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap L1175; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L583 |
| [ZRPTH411F01](ZRPTH411F01.md) | **FORM 호출** — CONFIRM_DATA: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap L681; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L539 |
| [ZRPTH411F01](ZRPTH411F01.md) | **FORM 호출** — CREATE_INIT_FIELDCAT2: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap L214; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L449 |
| [ZRPTH411F01](ZRPTH411F01.md) | **FORM 호출** — CREATE_INIT_FIELDCAT3: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap L249; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L462 |
| [ZRPTH411F01](ZRPTH411F01.md) | **FORM 호출** — CREATE_INIT_FIELDCAT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap L152; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L433 |
| [ZRPTH411F01](ZRPTH411F01.md) | **FORM 호출** — GET_52WKTY_TEXT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap L1148; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L1463 |
| [ZRPTH411F01](ZRPTH411F01.md) | **FORM 호출** — GET_ORGTX: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap L1126; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L62, 66, 829, 833, 932, 936, 1056, 1060 |
| [ZRPTH411F01](ZRPTH411F01.md) | **FORM 호출** — SET_APPROVE_STATUS: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap L1455; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L634 |
| [ZRPTH411F01](ZRPTH411F01.md) | **FORM 호출** — SET_SORT_TAB: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap L1395; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L384 |
| [ZRPTH411F02](ZRPTH411F02.md) | **FORM 호출** — CHANGE_FORMAT2: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F02/source/ZRPTH411F02.abap L218; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L810, 811, 812, 813, 814, 815, 816, 817, 818, 819, 820, 821, 822, 823, 824, 825 |
| [ZRPTH411F02](ZRPTH411F02.md) | **FORM 호출** — CHANGE_FORMAT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F02/source/ZRPTH411F02.abap L198; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L757, 758, 759, 760, 761, 762, 763, 764, 765, 766, 767, 768, 769, 770, 771, 772 |
| [ZRPTH411F02](ZRPTH411F02.md) | **FORM 호출** — DOWNLOAD_EXCEL: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F02/source/ZRPTH411F02.abap L249; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L639 |
| [ZTHR0112](ZTHR0112.md) | **데이터 저장** — MODIFY DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L749, 1245, 1469 |
| [ZTHR0112](ZTHR0112.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L690, 1193 |
| [ZTHR0112](ZTHR0112.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L682, 1176, 1456 |
| [ZTHR0113](ZTHR0113.md) | **데이터 저장** — DELETE FROM DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L1256 |
| [ZTHR0113](ZTHR0113.md) | **데이터 저장** — MODIFY DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L780 |
| [ZTHR0113](ZTHR0113.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L14, 683, 1177 |
| [ZTHR0160](ZTHR0160.md) | **데이터 저장** — DELETE FROM DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L587 |
| [ZTHR0160](ZTHR0160.md) | **데이터 저장** — INSERT DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L553 |
| [ZTHR0160](ZTHR0160.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L549 |
| [ZTHR0160](ZTHR0160.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L506 |
| [ZWF0022](EXT-ZWF0022.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L708 |
| [ZWF_DELETE](EXT-ZWF_DELETE.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L1480 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [ZRPTH411](ZRPTH411.md) | FORM 호출 | [ZRPTH411.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411/source/ZRPTH411.abap) L165, 198, 209, 214, 218 |
| [ZRPTH411](ZRPTH411.md) | Include | [ZRPTH411.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411/source/ZRPTH411.abap) L14 |
| [ZRPTH411F01](ZRPTH411F01.md) | FORM 호출 | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L62, 66, 157, 202, 219, 254, 384, 433, 449, 462, 539, 583, 634, 829, 833, 932, 936, 1056, 1060, 1463 |
| [ZRPTH411TOP](ZRPTH411TOP.md) | FORM 호출 | [ZRPTH411TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411TOP/source/ZRPTH411TOP.abap) L74 |

### 관련 업무와 미확인 범위

- [selective](../topics/selective.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [settlement](../topics/settlement.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
