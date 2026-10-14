---
title: "ZHCMT_BSP_PA_XX_R9021 — 인포타입 9021의 화면 구조"
as_of: 2026-10-07
review_status: pending_business_review
tags: [인사정보형9021_9023]
---

# ZHCMT_BSP_PA_XX_R9021 — 인포타입 9021의 화면 구조

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **DDIC Structures**. 설명: 인포타입 9021의 화면 구조.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZHCMT_BSP_PA_XX_R9021/definition.xml) | 1191행; 원본 보존 |

### 데이터 정의

XML TABCLASS: `INTTAB`. GOTSTATE: `A`. 정의는 운영 행 데이터가 아니다. 구조·타입을 DB 저장 테이블로 해석하지 않는다.

| 필드 | 키 표시 | 타입/데이터요소 | 정의 위치 |
|---|---|---|---|
| `OBJECT_KEY` | — | HCM_OBJECT_KEY | DD03P_TAB, L63 |
| `.INCLUDE` | — |  | DD03P_TAB, L129 |
| `.INCLUDE` | — |  | DD03P_TAB, L129 |
| `PERNR` | — | PERNR_D | DD03P_TAB, L261 |
| `AEDTM` | — | AEDAT | DD03P_TAB, L327 |
| `UNAME` | — | AENAM | DD03P_TAB, L393 |
| `SPRPS` | — | SPRPS | DD03P_TAB, L459 |
| `SPRTX` | — | SPRPSTEXT | DD03P_TAB, L525 |
| `ITBLD` | — | ITBLD | DD03P_TAB, L591 |
| `BEGDA` | — | PAD_BEGDA | DD03P_TAB, L657 |
| `ENDDA` | — | PAD_ENDDA | DD03P_TAB, L723 |
| `Z52WKTP` | — | [ZE52WKTP](ZE52WKTP.md) | DD03P_TAB, L789 |
| `Z52PRSQ` | — | SEQNR | DD03P_TAB, L855 |
| `COREWK1_B` | — | TIMS | DD03P_TAB, L921 |
| `COREWK1_E` | — | TIMS | DD03P_TAB, L987 |
| `COREWK2_B` | — | TIMS | DD03P_TAB, L1053 |
| `COREWK2_E` | — | TIMS | DD03P_TAB, L1119 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZD52WKTP1](ZD52WKTP1.md) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZHCMT_BSP_PA_XX_R9021/definition.xml) L804 |
| [ZE52WKTP](ZE52WKTP.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZHCMT_BSP_PA_XX_R9021/definition.xml) L794 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| — | 색인 내 정적 참조 없음; 미사용 근거 아님 | 동적 호출·외부 시스템은 미확인 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
