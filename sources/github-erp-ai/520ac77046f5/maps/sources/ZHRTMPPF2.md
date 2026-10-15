---
title: "ZHRTMPPF2 — [ZHRTMP] 비정규직 인력관리 테이블"
as_of: 2026-10-07
review_status: pending_business_review
tags: [비정규인원관리]
---

# ZHRTMPPF2 — [ZHRTMP] 비정규직 인력관리 테이블

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **DDIC DBtable**. 설명: [ZHRTMP] 비정규직 인력관리 테이블.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZHRTMPPF2/definition.xml) | 1917행; 원본 보존 |

### 데이터 정의

XML TABCLASS: `TRANSP`. GOTSTATE: `A`. 정의는 운영 행 데이터가 아니다. 구조·타입을 DB 저장 테이블로 해석하지 않는다.

| 필드 | 키 표시 | 타입/데이터요소 | 정의 위치 |
|---|---|---|---|
| `ZINDEX` | X | CHAR | DD03P_TAB, L63 |
| `ZWHO` | — | CHAR | DD03P_TAB, L129 |
| `ENAME` | — | CHAR | DD03P_TAB, L195 |
| `ZBIRTH` | — | CHAR | DD03P_TAB, L261 |
| `ZSEX` | — | CHAR | DD03P_TAB, L327 |
| `LIFNR` | — | CHAR | DD03P_TAB, L393 |
| `ZCOMPANY` | — | CHAR | DD03P_TAB, L459 |
| `OBJIDX1` | — | CHAR | DD03P_TAB, L525 |
| `OBJIDX2` | — | CHAR | DD03P_TAB, L591 |
| `ZTYPE` | — | CHAR | DD03P_TAB, L657 |
| `ZLCAT` | — | CHAR | DD03P_TAB, L723 |
| `ZMCAT` | — | CHAR | DD03P_TAB, L789 |
| `ZSCAT` | — | CHAR | DD03P_TAB, L855 |
| `ZJOB` | — | CHAR | DD03P_TAB, L921 |
| `ZROLE` | — | CHAR | DD03P_TAB, L987 |
| `BEGDA` | — | CHAR | DD03P_TAB, L1053 |
| `ENDDA` | — | CHAR | DD03P_TAB, L1119 |
| `ZFIRST` | — | CHAR | DD03P_TAB, L1185 |
| `ZDURATION` | — | CHAR | DD03P_TAB, L1251 |
| `ZCOUNT` | — | CHAR | DD03P_TAB, L1317 |
| `ZCHK1` | — | CHAR | DD03P_TAB, L1383 |
| `ZCHK2` | — | CHAR | DD03P_TAB, L1449 |
| `ZCONTRACT1` | — | CHAR | DD03P_TAB, L1515 |
| `ZCONTRACT2` | — | CHAR | DD03P_TAB, L1581 |
| `ZCONTRACT3` | — | CHAR | DD03P_TAB, L1647 |
| `ZHP` | — | CHAR | DD03P_TAB, L1713 |
| `ZETC` | — | CHAR | DD03P_TAB, L1779 |
| `ZSAMECHK` | — | CHAR | DD03P_TAB, L1845 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| — | 색인 규칙으로 확정한 외부 관계 없음; 코드 무관·미사용 판정 아님 | 원본 참조 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [ZHR_GET_BPERSON_INFO](ZHR_GET_BPERSON_INFO.md) | 데이터 저장 | [ZHR_GET_BPERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BPERSON_INFO/Source%20code/ZHR_GET_BPERSON_INFO.abap) L32 |
| [ZHR_GET_BPERSON_INFO](ZHR_GET_BPERSON_INFO.md) | 데이터 조회 | [ZHR_GET_BPERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BPERSON_INFO/Source%20code/ZHR_GET_BPERSON_INFO.abap) L20 |
| [ZHR_GET_BPERSON_INFO](ZHR_GET_BPERSON_INFO.md) | 타입 참조 | [ZHR_GET_BPERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BPERSON_INFO/Source%20code/ZHR_GET_BPERSON_INFO.abap) L16 |
| [ZHR_GET_BPERSON_INFO](ZHR_GET_BPERSON_INFO.md) | 타입 참조 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BPERSON_INFO/Tables.xml) L9, 20 |
| [ZHR_GET_BWORK_INFO](ZHR_GET_BWORK_INFO.md) | 데이터 조회 | [ZHR_GET_BWORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BWORK_INFO/Source%20code/ZHR_GET_BWORK_INFO.abap) L34, 38, 47, 51 |
| [ZHR_GET_BWORK_INFO](ZHR_GET_BWORK_INFO.md) | 타입 참조 | [ZHR_GET_BWORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BWORK_INFO/Source%20code/ZHR_GET_BWORK_INFO.abap) L19, 21, 22, 23 |
| [ZHR_GET_BWORK_INFO](ZHR_GET_BWORK_INFO.md) | 타입 참조 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BWORK_INFO/Tables.xml) L9 |

### 관련 업무와 미확인 범위

- [nonregular](../topics/nonregular.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
