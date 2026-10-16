---
title: "ZRPTH401 — 탄력 계획 미결처리"
as_of: 2026-10-07
review_status: pending_business_review
tags: [탄력근무]
---

# ZRPTH401 — 탄력 계획 미결처리

[소스 설명 목차](INDEX.md) · [원본 파일](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH401/source/ZRPTH401.abap)

배치 프로그램의 존재가 운영 스케줄 등록을 증명하지 않는다.

확인 수준: 표시한 소스 구간 정적 확인; 운영 실행 검증 아님. 원본 경로·파일은 그대로 유지한다.

## 근거 위치

| 위치 | 관계의 의미 | 근거 구문 |
|---|---|---|
| 96행 | 미결처리 중 외부 WF 호출 | `CALL FUNCTION 'ZWF_DELETE'` |

## 관련 업무

<!-- topics -->
- [탄력근로 계획·결재](../topics/flexible.md) — 이 소스를 검토하는 업무 지도.

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: ZRPTH401.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZRPTH401.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH401/attributes/ZRPTH401.xml) | 36행; 원본 보존 |
| [ZRPTH401.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH401/source/ZRPTH401.abap) | 141행; 원본 보존 |
| [../texts/ZRPTH401.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH401/texts/ZRPTH401.xml) | 40행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [DOMAIN_VALUE_GET](EXTERNAL_DEPENDENCIES.md#DOMAIN_VALUE_GET) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH401.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH401/source/ZRPTH401.abap) L75 |
| [ZECNVAL](ZECNVAL.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH401.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH401/source/ZRPTH401.abap) L19 |
| [ZECONST](ZECONST.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH401.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH401/source/ZRPTH401.abap) L15 |
| [ZTHR0101](ZTHR0101.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH401.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH401/source/ZRPTH401.abap) L41 |
| [ZTHR0106](ZTHR0106.md) | **데이터 저장** — MODIFY DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH401.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH401/source/ZRPTH401.abap) L129 |
| [ZTHR0106](ZTHR0106.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH401.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH401/source/ZRPTH401.abap) L58 |
| [ZTHR0106](ZTHR0106.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH401.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH401/source/ZRPTH401.abap) L17, 30 |
| [ZWF_DELETE](EXT-ZWF_DELETE.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH401.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH401/source/ZRPTH401.abap) L96 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| — | 색인 내 정적 참조 없음; 미사용 근거 아님 | 동적 호출·외부 시스템은 미확인 |

### 관련 업무와 미확인 범위

- [flexible](../topics/flexible.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
