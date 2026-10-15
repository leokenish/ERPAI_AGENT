---
title: "ZSHR0119 — [52시간] 사원근로유형조회"
as_of: 2026-10-07
review_status: pending_business_review
tags: [IAM등록기본설정, 교대근무, 근로시간알림, 근무현황조회, 대휴익휴보상휴가, 선택근무, 월정산전표지급, 인사정보형9021_9023, 탄력근무, 통상시차시간외, 통합결재, 퇴직자관리자입력검토, 특별연장재난방송, 휴가공가반차]
---

# ZSHR0119 — [52시간] 사원근로유형조회

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **DDIC Structures**. 설명: [52시간] 사원근로유형조회.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0119/definition.xml) | 465행; 원본 보존 |

### 데이터 정의

XML TABCLASS: `INTTAB`. GOTSTATE: `A`. 정의는 운영 행 데이터가 아니다. 구조·타입을 DB 저장 테이블로 해석하지 않는다.

| 필드 | 키 표시 | 타입/데이터요소 | 정의 위치 |
|---|---|---|---|
| `PERNR` | — | PERSNO | DD03P_TAB, L63 |
| `BEGDA` | — | BEGDA | DD03P_TAB, L129 |
| `ENDDA` | — | ENDDA | DD03P_TAB, L195 |
| `Z52WKTP` | — | [ZE52WKTP](ZE52WKTP.md) | DD03P_TAB, L261 |
| `Z52WKTXT` | — | [ZE52WKTXT](ZE52WKTXT.md) | DD03P_TAB, L327 |
| `Z52PRSQ` | — | [ZE52PRSQ](ZE52PRSQ.md) | DD03P_TAB, L393 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZD52WKTP1](ZD52WKTP1.md) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0119/definition.xml) L276 |
| [ZE52PRSQ](ZE52PRSQ.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0119/definition.xml) L398 |
| [ZE52WKTP](ZE52WKTP.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0119/definition.xml) L266 |
| [ZE52WKTXT](ZE52WKTXT.md) | **타입 참조** — ROLLNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0119/definition.xml) L332 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F01](LZHR008_2F01.md) | 타입 참조 | [LZHR008_2F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap) L2360, 2390 |
| [LZHR008_2F06](LZHR008_2F06.md) | 타입 참조 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L358, 359, 760 |
| [MZH4110F01](MZH4110F01.md) | 타입 참조 | [MZH4110F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110F01/source/MZH4110F01.abap) L957, 958 |
| [ZHR_52TM_PERSONAL_WORK_TIME](ZHR_52TM_PERSONAL_WORK_TIME.md) | 타입 참조 | [ZHR_52TM_PERSONAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Source%20code/ZHR_52TM_PERSONAL_WORK_TIME.abap) L20, 21 |
| [ZHR_52TM_PERSONAL_WORK_TIME](ZHR_52TM_PERSONAL_WORK_TIME.md) | 타입 참조 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Tables.xml) L9 |
| [ZHR_52TM_REAL_WORK_TIME](ZHR_52TM_REAL_WORK_TIME.md) | 타입 참조 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L25 |
| [ZHR_52TM_REAL_WORK_TIME_TEAM](ZHR_52TM_REAL_WORK_TIME_TEAM.md) | 타입 참조 | [ZHR_52TM_REAL_WORK_TIME_TEAM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME_TEAM/Source%20code/ZHR_52TM_REAL_WORK_TIME_TEAM.abap) L27 |
| [ZHR_52TM_REAL_WORK_TIME_TEAM_M](ZHR_52TM_REAL_WORK_TIME_TEAM_M.md) | 타입 참조 | [ZHR_52TM_REAL_WORK_TIME_TEAM_M.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME_TEAM_M/Source%20code/ZHR_52TM_REAL_WORK_TIME_TEAM_M.abap) L27 |
| [ZHR_52TM_SET_ZGUBUN](ZHR_52TM_SET_ZGUBUN.md) | 타입 참조 | [ZHR_52TM_SET_ZGUBUN.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_ZGUBUN/Source%20code/ZHR_52TM_SET_ZGUBUN.abap) L16, 17 |
| [ZHR_52TM_SET_ZGUBUN_RFC](ZHR_52TM_SET_ZGUBUN_RFC.md) | 타입 참조 | [ZHR_52TM_SET_ZGUBUN_RFC.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_ZGUBUN_RFC/Source%20code/ZHR_52TM_SET_ZGUBUN_RFC.abap) L16, 17 |
| [ZRPTH405F01](ZRPTH405F01.md) | 타입 참조 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L241 |
| [ZRPTH406F01](ZRPTH406F01.md) | 타입 참조 | [ZRPTH406F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406F01/source/ZRPTH406F01.abap) L204 |
| [ZTSHR0119](ZTSHR0119.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/TableType/ZTSHR0119/definition.xml) L10 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
