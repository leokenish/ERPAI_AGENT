---
title: "ZRPTH402 — 탄력근로 정산관리"
as_of: 2026-10-07
review_status: pending_business_review
tags: [월정산전표지급, 탄력근무]
---

# ZRPTH402 — 탄력근로 정산관리

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 탄력근로 정산관리.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZRPTH402.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402/attributes/ZRPTH402.xml) | 36행; 원본 보존 |
| [ZRPTH402.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402/source/ZRPTH402.abap) | 203행; 원본 보존 |
| [../texts/ZRPTH402.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402/texts/ZRPTH402.xml) | 190행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [PA2010](EXT-PA2010.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH402.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402/source/ZRPTH402.abap) L104 |
| [RP_LAST_DAY_OF_MONTHS](EXTERNAL_DEPENDENCIES.md#RP_LAST_DAY_OF_MONTHS) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH402.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402/source/ZRPTH402.abap) L21, 69 |
| [ZRPTH402F01](ZRPTH402F01.md) | **FORM 호출** — GET_52WKTY_TEXT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap L783; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH402.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402/source/ZRPTH402.abap) L113 |
| [ZRPTH402F01](ZRPTH402F01.md) | **FORM 호출** — GET_CALC_DATA_DISPLAY: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap L640; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH402.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402/source/ZRPTH402.abap) L143 |
| [ZRPTH402F01](ZRPTH402F01.md) | **FORM 호출** — GET_CALC_SUM_DATA_DISPLAY: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap L668; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH402.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402/source/ZRPTH402.abap) L168 |
| [ZRPTH402F01](ZRPTH402F01.md) | **FORM 호출** — SET_CALC_WEEKLY_AMT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap L13; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH402.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402/source/ZRPTH402.abap) L158 |
| [ZRPTH402F01](ZRPTH402F01.md) | **FORM 호출** — SET_MISS_APPROVE_LIST: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap L734; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH402.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402/source/ZRPTH402.abap) L163 |
| [ZRPTH402F01](ZRPTH402F01.md) | **Include** — 컴파일 소스 포함; 순차 실행 의미 아님 | [ZRPTH402.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402/source/ZRPTH402.abap) L15 |
| [ZRPTH402TOP](ZRPTH402TOP.md) | **Include** — 컴파일 소스 포함; 순차 실행 의미 아님 | [ZRPTH402.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402/source/ZRPTH402.abap) L14 |
| [ZTH0500](EXTERNAL_DEPENDENCIES.md#ZTH0500) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH402.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402/source/ZRPTH402.abap) L129 |
| [ZTHR0106](ZTHR0106.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH402.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402/source/ZRPTH402.abap) L82 |
| [ZTHR0110](ZTHR0110.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH402.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402/source/ZRPTH402.abap) L119 |
| [ZTHR0120](ZTHR0120.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH402.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402/source/ZRPTH402.abap) L93 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| — | 색인 내 정적 참조 없음; 미사용 근거 아님 | 동적 호출·외부 시스템은 미확인 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
