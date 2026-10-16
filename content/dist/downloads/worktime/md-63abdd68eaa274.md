---
title: "MZH4110O01 — ABAP 프로그램·독립 Include"
as_of: 2026-10-07
review_status: pending_business_review
tags: [교대근무, 통상시차시간외, 퇴직자관리자입력검토]
---

# MZH4110O01 — ABAP 프로그램·독립 Include

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 제목 메타데이터 없음; 이름만으로 업무를 확정하지 않음.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/MZH4110O01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110O01/attributes/MZH4110O01.xml) | 36행; 원본 보존 |
| [MZH4110O01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110O01/source/MZH4110O01.abap) | 152행; 원본 보존 |
| [../texts/MZH4110O01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110O01/texts/MZH4110O01.xml) | 16행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [HR_GETEMPLOYEEDATA_FROMUSER](EXTERNAL_DEPENDENCIES.md#HR_GETEMPLOYEEDATA_FROMUSER) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [MZH4110O01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110O01/source/MZH4110O01.abap) L93 |
| [MZH4110F01](MZH4110F01.md) | **FORM 호출** — DISPLAY_MESSAGE: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110F01/source/MZH4110F01.abap L578; 포함 범위 내 이름 일치, 동적 해석 제외 | [MZH4110O01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110O01/source/MZH4110O01.abap) L124 |
| [MZH4110F01](MZH4110F01.md) | **FORM 호출** — SET_INIT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110F01/source/MZH4110F01.abap L41; 포함 범위 내 이름 일치, 동적 해석 제외 | [MZH4110O01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110O01/source/MZH4110O01.abap) L116 |
| [MZH4110F01](MZH4110F01.md) | **FORM 호출** — SET_LIST_APPROVER: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110F01/source/MZH4110F01.abap L1092; 포함 범위 내 이름 일치, 동적 해석 제외 | [MZH4110O01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110O01/source/MZH4110O01.abap) L137 |
| [MZH4110F01](MZH4110F01.md) | **FORM 호출** — SET_LIST_STYPE: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110F01/source/MZH4110F01.abap L1147; 포함 범위 내 이름 일치, 동적 해석 제외 | [MZH4110O01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110O01/source/MZH4110O01.abap) L140 |
| [MZH4110F01](MZH4110F01.md) | **FORM 호출** — SET_LIST_WKTP: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110F01/source/MZH4110F01.abap L715; 포함 범위 내 이름 일치, 동적 해석 제외 | [MZH4110O01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110O01/source/MZH4110O01.abap) L134 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [SAPMZH4110](SAPMZH4110.md) | Include | [SAPMZH4110.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/SAPMZH4110/source/SAPMZH4110.abap) L17 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
