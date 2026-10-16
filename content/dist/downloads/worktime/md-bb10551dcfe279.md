---
title: "ZHR_52TM_DAILY_APPROVE_OT_DATA — [52시간] 선택근로 결재-승인/반려(사유포함)"
as_of: 2026-10-07
review_status: pending_business_review
tags: [선택근무, 탄력근무, 통합결재, 특별연장재난방송]
---

# ZHR_52TM_DAILY_APPROVE_OT_DATA — [52시간] 선택근로 결재-승인/반려(사유포함)

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 선택근로 결재-승인/반려(사유포함).

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Changing.xml) | 43행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Exception.xml) | 28행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Export.xml) | 40행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Import.xml) | 43행; 원본 보존 |
| [ZHR_52TM_DAILY_APPROVE_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Source%20code/ZHR_52TM_DAILY_APPROVE_OT_DATA.abap) | 264행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Tables.xml) | 28행; 원본 보존 |
| [../../../Include/LZHR008_2U62.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U62.abap) | 264행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U62.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U62.abap) L1 | LZHR008_2U62: API 본문과 바이트 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Changing | `IT_WF0016` | [ZSWF0016_TAB](ZSWF0016_TAB.md) | — | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Changing.xml) L8 |
| Export | `E_RETURN` | BAPIRETURN1 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Export.xml) L8 |
| Import | `I_PERNR` | PERSNO | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Import.xml) L8 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F01](LZHR008_2F01.md) | **FORM 호출** — GET_DOMAIN: 정의 exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap L151; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZHR_52TM_DAILY_APPROVE_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Source%20code/ZHR_52TM_DAILY_APPROVE_OT_DATA.abap) L108 |
| [PA9021](PA9021.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_DAILY_APPROVE_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Source%20code/ZHR_52TM_DAILY_APPROVE_OT_DATA.abap) L43 |
| [ZHR_52TM_VALID_DATE_CHECK](ZHR_52TM_VALID_DATE_CHECK.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_DAILY_APPROVE_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Source%20code/ZHR_52TM_DAILY_APPROVE_OT_DATA.abap) L124 |
| [ZSHR0115](ZSHR0115.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_DAILY_APPROVE_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Source%20code/ZHR_52TM_DAILY_APPROVE_OT_DATA.abap) L46 |
| [ZSWF0016_TAB](ZSWF0016_TAB.md) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Changing.xml) L15 |
| [ZTHR0112](ZTHR0112.md) | **데이터 저장** — MODIFY DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZHR_52TM_DAILY_APPROVE_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Source%20code/ZHR_52TM_DAILY_APPROVE_OT_DATA.abap) L169 |
| [ZTHR0112](ZTHR0112.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZHR_52TM_DAILY_APPROVE_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Source%20code/ZHR_52TM_DAILY_APPROVE_OT_DATA.abap) L142 |
| [ZTHR0112](ZTHR0112.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_DAILY_APPROVE_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Source%20code/ZHR_52TM_DAILY_APPROVE_OT_DATA.abap) L35 |
| [ZTSHR0115](ZTSHR0115.md) | **타입 참조** — 선언·구조 참조이며 DB 읽기/쓰기 아님 | [ZHR_52TM_DAILY_APPROVE_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Source%20code/ZHR_52TM_DAILY_APPROVE_OT_DATA.abap) L47 |
| [ZWF_APPROVE_WORK](EXT-ZWF_APPROVE_WORK.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_DAILY_APPROVE_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Source%20code/ZHR_52TM_DAILY_APPROVE_OT_DATA.abap) L180 |
| [ZWF_REJECT_WORK](EXT-ZWF_REJECT_WORK.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZHR_52TM_DAILY_APPROVE_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Source%20code/ZHR_52TM_DAILY_APPROVE_OT_DATA.abap) L197 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L127 |
| [ZHR_52TM_APPROVAL_LIST](ZHR_52TM_APPROVAL_LIST.md) | 직접 호출 | [ZHR_52TM_APPROVAL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Source%20code/ZHR_52TM_APPROVAL_LIST.abap) L290 |

### 관련 업무와 미확인 범위

- [approvals](../topics/approvals.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [selective](../topics/selective.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
