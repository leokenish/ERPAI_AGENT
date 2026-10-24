---
title: "ZHR_DELETE_WORK_INFO — ABAP 프로그램·독립 Include"
as_of: 2026-10-07
review_status: pending_business_review
tags: [업무리소스인원연계, 자료복사결재보정]
---

# ZHR_DELETE_WORK_INFO — ABAP 프로그램·독립 Include

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 제목 메타데이터 없음; 이름만으로 업무를 확정하지 않음.

검토 상태: **분석 완료 — 아래에 명시한 본문 정적 분석 범위; 외부 구현·업무 전체·운영은 미확인**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZHR_DELETE_WORK_INFO.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_DELETE_WORK_INFO/attributes/ZHR_DELETE_WORK_INFO.xml) | 36행; 원본 보존 |
| [ZHR_DELETE_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_DELETE_WORK_INFO/source/ZHR_DELETE_WORK_INFO.abap) | 14행; 원본 보존 |
| [../texts/ZHR_DELETE_WORK_INFO.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_DELETE_WORK_INFO/texts/ZHR_DELETE_WORK_INFO.xml) | 16행; 원본 보존 |

### 이번 업무 구간 검토

파일 판정: **분석 완료**. 검토 범위: 본문 L1–14, 분기/입출력/직접 참조 정적 검토. 남은 범위: 외부 호출 본문·권한·운영 사용·실제 실행 미확인. 이는 이 파일/명시한 구간의 정적 분석이며 외부 함수·업무 전체·운영 검증 완료는 아니다.

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZHRPERSONTBL](ZHRPERSONTBL.md) | **데이터 저장** — DELETE FROM DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZHR_DELETE_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_DELETE_WORK_INFO/source/ZHR_DELETE_WORK_INFO.abap) L13 |
| [ZHRTAGTBL](ZHRTAGTBL.md) | **데이터 저장** — DELETE FROM DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZHR_DELETE_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_DELETE_WORK_INFO/source/ZHR_DELETE_WORK_INFO.abap) L14 |
| [ZHRWORKTBL](ZHRWORKTBL.md) | **데이터 저장** — DELETE FROM DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZHR_DELETE_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_DELETE_WORK_INFO/source/ZHR_DELETE_WORK_INFO.abap) L12 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| — | 색인 내 정적 참조 없음; 미사용 근거 아님 | 동적 호출·외부 시스템은 미확인 |

### 관련 업무와 미확인 범위

- [maintenance](../topics/maintenance.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [person-work](../topics/person-work.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
