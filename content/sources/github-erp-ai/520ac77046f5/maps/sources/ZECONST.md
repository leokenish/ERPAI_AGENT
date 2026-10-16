---
title: "ZECONST — 상수"
as_of: 2026-10-07
review_status: pending_business_review
tags: [교대근무, 근로시간알림, 근무현황조회, 기준정보유지보수, 대휴익휴보상휴가, 선택근무, 탄력근무, 통상시차시간외, 통합결재, 특별연장재난방송, 휴가공가반차]
---

# ZECONST — 상수

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **DDIC Data element**. 설명: 상수.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Data%20element/ZECONST/definition.xml) | 55행; 원본 보존 |

### 데이터 정의

XML TABCLASS: `해당 없음`. GOTSTATE: `A`. 정의는 운영 행 데이터가 아니다. 구조·타입을 DB 저장 테이블로 해석하지 않는다.

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| — | 색인 규칙으로 확정한 외부 관계 없음; 코드 무관·미사용 판정 아님 | 원본 참조 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [ZRPTH401](ZRPTH401.md) | 타입 참조 | [ZRPTH401.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH401/source/ZRPTH401.abap) L15 |
| [ZRPTH403TOP](ZRPTH403TOP.md) | 타입 참조 | [ZRPTH403TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403TOP/source/ZRPTH403TOP.abap) L16, 17, 18 |
| [ZTHR0101](ZTHR0101.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0101/definition.xml) L134 |
| [ZVHR0101](ZVHR0101.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/VIEW/ZVHR0101/definition.xml) L119 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
