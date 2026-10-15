---
title: "ZHR_52TM_WKTYPE_PERIOD — [52시간] 사원근로유형 기간조회"
as_of: 2026-10-07
review_status: pending_business_review
tags: [교대근무, 근로시간알림, 근무현황조회, 대휴익휴보상휴가, 탄력근무, 통상시차시간외, 퇴직자관리자입력검토, 특별연장재난방송]
---

# ZHR_52TM_WKTYPE_PERIOD — [52시간] 사원근로유형 기간조회

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 사원근로유형 기간조회.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Changing.xml) | 40행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Exception.xml) | 40행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Export.xml) | 40행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Import.xml) | 97행; 원본 보존 |
| [ZHR_52TM_WKTYPE_PERIOD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Source%20code/ZHR_52TM_WKTYPE_PERIOD.abap) | 394행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Tables.xml) | 52행; 원본 보존 |
| [../../../Include/LZHR008_2U28.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U28.abap) | 394행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U28.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U28.abap) L1 | LZHR008_2U28: API 본문과 행말 공백 제외 본문 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Import | `I_PERNR` | PERSNO | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Import.xml) L8 |
| Import | `I_BEGDA` | BEGDA | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Import.xml) L22 |
| Import | `I_ENDDA` | ENDDA | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Import.xml) L36 |
| Import | `I_OPT` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Import.xml) L50 |
| Tables | `T_OUTPUT` | [ZTSHR0119](ZTSHR0119.md) | — | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Tables.xml) L8 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [PA0000](EXTERNAL_DEPENDENCIES.md#PA0000) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_WKTYPE_PERIOD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Source%20code/ZHR_52TM_WKTYPE_PERIOD.abap) L320 |
| [PA9021](PA9021.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_WKTYPE_PERIOD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Source%20code/ZHR_52TM_WKTYPE_PERIOD.abap) L41, 288, 347 |
| [PA9021](PA9021.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_WKTYPE_PERIOD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Source%20code/ZHR_52TM_WKTYPE_PERIOD.abap) L14 |
| [PA9041](EXTERNAL_DEPENDENCIES.md#PA9041) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_WKTYPE_PERIOD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Source%20code/ZHR_52TM_WKTYPE_PERIOD.abap) L315 |
| [ZHRT001](EXTERNAL_DEPENDENCIES.md#ZHRT001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_WKTYPE_PERIOD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Source%20code/ZHR_52TM_WKTYPE_PERIOD.abap) L271, 332 |
| [ZHRT002](EXTERNAL_DEPENDENCIES.md#ZHRT002) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_WKTYPE_PERIOD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Source%20code/ZHR_52TM_WKTYPE_PERIOD.abap) L271, 332 |
| [ZHR_52TM_WKTYPE](ZHR_52TM_WKTYPE.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_WKTYPE_PERIOD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Source%20code/ZHR_52TM_WKTYPE_PERIOD.abap) L32 |
| [ZTHR0104](ZTHR0104.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_WKTYPE_PERIOD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Source%20code/ZHR_52TM_WKTYPE_PERIOD.abap) L50 |
| [ZTHR0104](ZTHR0104.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_WKTYPE_PERIOD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Source%20code/ZHR_52TM_WKTYPE_PERIOD.abap) L22 |
| [ZTHRWORK_GUBUN](EXTERNAL_DEPENDENCIES.md#ZTHRWORK_GUBUN) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_WKTYPE_PERIOD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Source%20code/ZHR_52TM_WKTYPE_PERIOD.abap) L78, 300, 356 |
| [ZTSHR0119](ZTSHR0119.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Tables.xml) L12 |
| [ZTSHR0119](ZTSHR0119.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_WKTYPE_PERIOD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WKTYPE_PERIOD/Source%20code/ZHR_52TM_WKTYPE_PERIOD.abap) L16 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F06](LZHR008_2F06.md) | 직접 호출 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L376, 782 |
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L59 |
| [MZH4110F01](MZH4110F01.md) | 직접 호출 | [MZH4110F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110F01/source/MZH4110F01.abap) L975 |
| [ZHR_52TM_PERSONAL_WORK_TIME](ZHR_52TM_PERSONAL_WORK_TIME.md) | 직접 호출 | [ZHR_52TM_PERSONAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Source%20code/ZHR_52TM_PERSONAL_WORK_TIME.abap) L46 |
| [ZHR_52TM_REAL_WORK_TIME](ZHR_52TM_REAL_WORK_TIME.md) | 직접 호출 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L77 |
| [ZHR_52TM_SET_ZGUBUN](ZHR_52TM_SET_ZGUBUN.md) | 직접 호출 | [ZHR_52TM_SET_ZGUBUN.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_ZGUBUN/Source%20code/ZHR_52TM_SET_ZGUBUN.abap) L23 |
| [ZHR_52TM_SET_ZGUBUN_RFC](ZHR_52TM_SET_ZGUBUN_RFC.md) | 직접 호출 | [ZHR_52TM_SET_ZGUBUN_RFC.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_ZGUBUN_RFC/Source%20code/ZHR_52TM_SET_ZGUBUN_RFC.abap) L23 |
| [ZRPTH405F01](ZRPTH405F01.md) | 직접 호출 | [ZRPTH405F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405F01/source/ZRPTH405F01.abap) L247 |
| [ZRPTH406F01](ZRPTH406F01.md) | 직접 호출 | [ZRPTH406F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406F01/source/ZRPTH406F01.abap) L212 |

### 관련 업무와 미확인 범위

- [special-extension](../topics/special-extension.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
