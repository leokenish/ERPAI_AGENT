---
title: "ZHR_GET_BPERSON_INFO — [HR]개인별 인사정보"
as_of: 2026-10-07
review_status: pending_business_review
tags: [비정규인원관리]
---

# ZHR_GET_BPERSON_INFO — [HR]개인별 인사정보

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [HR]개인별 인사정보.

검토 상태: **분석 완료 — 아래에 명시한 본문 정적 분석 범위; 외부 구현·업무 전체·운영은 미확인**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BPERSON_INFO/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BPERSON_INFO/Changing.xml) | 46행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BPERSON_INFO/Exception.xml) | 46행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BPERSON_INFO/Export.xml) | 69행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BPERSON_INFO/Import.xml) | 75행; 원본 보존 |
| [ZHR_GET_BPERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BPERSON_INFO/Source%20code/ZHR_GET_BPERSON_INFO.abap) | 43행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BPERSON_INFO/Tables.xml) | 69행; 원본 보존 |
| [../../../Include/LZHR_ETCU04.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Include/LZHR_ETCU04.abap) | 43행; 원본 보존 |

### 이번 업무 구간 검토

파일 판정: **분석 완료**. 검토 범위: 본문 L1–43, 분기/입출력/직접 참조 정적 검토. 남은 범위: 외부 호출 본문·권한·운영 사용·실제 실행 미확인. 이는 이 파일/명시한 구간의 정적 분석이며 외부 함수·업무 전체·운영 검증 완료는 아니다.

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR_ETCU04.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Include/LZHR_ETCU04.abap) L1 | LZHR_ETCU04: API 본문과 행말 공백 제외 본문 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_RCODE` | CHAR1 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BPERSON_INFO/Export.xml) L8 |
| Export | `E_RMSG` | CHAR200 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BPERSON_INFO/Export.xml) L19 |
| Import | `ZINDEX` | CHAR10 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BPERSON_INFO/Import.xml) L8 |
| Import | `ZFLAG` | CHAR1 | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BPERSON_INFO/Import.xml) L22 |
| Tables | `ZPERSON` | [ZHRTMPPF2](ZHRTMPPF2.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BPERSON_INFO/Tables.xml) L8 |
| Tables | `ZHRTMP` | [ZHRTMPPF2](ZHRTMPPF2.md) | X | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BPERSON_INFO/Tables.xml) L19 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZHRTMPPF2](ZHRTMPPF2.md) | **데이터 저장** — MODIFY DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZHR_GET_BPERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BPERSON_INFO/Source%20code/ZHR_GET_BPERSON_INFO.abap) L32 |
| [ZHRTMPPF2](ZHRTMPPF2.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_GET_BPERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BPERSON_INFO/Source%20code/ZHR_GET_BPERSON_INFO.abap) L20 |
| [ZHRTMPPF2](ZHRTMPPF2.md) | **타입 참조** — DBSTRUCT XML 정의 참조; 데이터 조회/저장 아님 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BPERSON_INFO/Tables.xml) L9, 20 |
| [ZHRTMPPF2](ZHRTMPPF2.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_GET_BPERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BPERSON_INFO/Source%20code/ZHR_GET_BPERSON_INFO.abap) L16 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR_ETCUXX](LZHR_ETCUXX.md) | Include | [LZHR_ETCUXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Include/LZHR_ETCUXX.abap) L11 |

### 관련 업무와 미확인 범위

- [nonregular](../topics/nonregular.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
