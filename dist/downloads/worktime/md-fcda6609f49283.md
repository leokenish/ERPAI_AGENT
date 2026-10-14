---
title: "ZSHR0132_WEB — [52시간]  선택근로 레포트용 구조"
as_of: 2026-10-07
review_status: pending_business_review
tags: [근무현황조회, 선택근무]
---

# ZSHR0132_WEB — [52시간]  선택근로 레포트용 구조

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **DDIC Structures**. 설명: [52시간]  선택근로 레포트용 구조.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0132_WEB/definition.xml) | 993행; 원본 보존 |

### 데이터 정의

XML TABCLASS: `INTTAB`. GOTSTATE: `A`. 정의는 운영 행 데이터가 아니다. 구조·타입을 DB 저장 테이블로 해석하지 않는다.

| 필드 | 키 표시 | 타입/데이터요소 | 정의 위치 |
|---|---|---|---|
| `PERNR` | — | PERSNO | DD03P_TAB, L63 |
| `NAME` | — | EMNAM | DD03P_TAB, L129 |
| `BEGDA` | — | CHAR10 | DD03P_TAB, L195 |
| `ENDDA` | — | CHAR10 | DD03P_TAB, L261 |
| `PERIOD` | — | CHAR30 | DD03P_TAB, L327 |
| `VDSK1` | — | CHAR8 | DD03P_TAB, L393 |
| `WKHR` | — | CHAR10 | DD03P_TAB, L459 |
| `HKHR` | — | CHAR10 | DD03P_TAB, L525 |
| `PWKHR` | — | CHAR10 | DD03P_TAB, L591 |
| `OWKHR` | — | CHAR10 | DD03P_TAB, L657 |
| `CWKHR` | — | CHAR10 | DD03P_TAB, L723 |
| `ZEMCWK_T` | — | CHAR1 | DD03P_TAB, L789 |
| `ZEMCWK` | — | CHAR10 | DD03P_TAB, L855 |
| `TOTHR` | — | CHAR10 | DD03P_TAB, L921 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| — | 색인 규칙으로 확정한 외부 관계 없음; 코드 무관·미사용 판정 아님 | 원본 참조 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [ZHR_52TM_DAILY_WEEKLY_BUSEO](ZHR_52TM_DAILY_WEEKLY_BUSEO.md) | 타입 참조 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_BUSEO/Tables.xml) L9 |
| [ZRPTH440](ZRPTH440.md) | 타입 참조 | [ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) L15, 16, 19, 20, 21, 22, 27, 28, 29, 30, 455 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
