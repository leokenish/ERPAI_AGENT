---
title: "ZRPTH403 — 근로시간한도알림"
as_of: 2026-10-07
review_status: pending_business_review
tags: [근로시간알림]
---

# ZRPTH403 — 근로시간한도알림

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 근로시간한도알림.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZRPTH403.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/attributes/ZRPTH403.xml) | 36행; 원본 보존 |
| [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) | 513행; 원본 보존 |
| [../texts/ZRPTH403.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/texts/ZRPTH403.xml) | 40행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [CL_ABAP_CHAR_UTILITIES](EXTERNAL_DEPENDENCIES.md#CL_ABAP_CHAR_UTILITIES) | **클래스 참조** — cr_lf 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L381 |
| [PA0001](EXTERNAL_DEPENDENCIES.md#PA0001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L342, 356 |
| [RH_GET_LEADER](EXTERNAL_DEPENDENCIES.md#RH_GET_LEADER) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L328 |
| [ZHR_52TM_CALC_WEEK_TIME](ZHR_52TM_CALC_WEEK_TIME.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L114 |
| [ZHR_52TM_REAL_WORK_TIME](ZHR_52TM_REAL_WORK_TIME.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L200 |
| [ZHR_52TM_WEEK_FROM_TO_DATE](ZHR_52TM_WEEK_FROM_TO_DATE.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L69 |
| [ZHR_MINUS_TIME_N](EXTERNAL_DEPENDENCIES.md#ZHR_MINUS_TIME_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L156, 227 |
| [ZHR_SUM_TIME_N](EXTERNAL_DEPENDENCIES.md#ZHR_SUM_TIME_N) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L95, 133, 142 |
| [ZRPTH403F01](ZRPTH403F01.md) | **FORM 호출** — SET_ALMTABLE: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403F01/source/ZRPTH403F01.abap L15; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L167, 178, 217, 238, 249 |
| [ZRPTH403F01](ZRPTH403F01.md) | **Include** — 컴파일 소스 포함; 순차 실행 의미 아님 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L18 |
| [ZRPTH403TOP](ZRPTH403TOP.md) | **Include** — 컴파일 소스 포함; 순차 실행 의미 아님 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L14 |
| [ZSHR0106](ZSHR0106.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L28 |
| [ZSHR0116](ZSHR0116.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L27 |
| [ZSMSSEND](EXT-ZSMSSEND.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L447, 482 |
| [ZTHR0101](ZTHR0101.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L55 |
| [ZTHR0106](ZTHR0106.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L193 |
| [ZTHR0106](ZTHR0106.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L26 |
| [ZTHR0121](ZTHR0121.md) | **데이터 저장** — MODIFY DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L506 |
| [ZTHR0121](ZTHR0121.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L269 |
| [ZTHR0121](ZTHR0121.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L265 |
| [ZTHRBS01](EXT-ZTHRBS01.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L83 |
| [Z_KBS_GETUSERINFO](EXTERNAL_DEPENDENCIES.md#Z_KBS_GETUSERINFO) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L429, 467 |
| [Z_KBS_SENDMAIL](EXT-Z_KBS_SENDMAIL.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L406 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| — | 색인 내 정적 참조 없음; 미사용 근거 아님 | 동적 호출·외부 시스템은 미확인 |

### 관련 업무와 미확인 범위

- [alerts](../topics/alerts.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
