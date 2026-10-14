---
title: "VIEWFRAME_ZVHR0129 — 확장테이블 유지보수: 상위레벨"
as_of: 2026-10-07
review_status: pending_business_review
tags: [기준정보유지보수]
---

# VIEWFRAME_ZVHR0129 — 확장테이블 유지보수: 상위레벨

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: 확장테이블 유지보수: 상위레벨.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Changing.xml) | 70행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Exception.xml) | 77행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Export.xml) | 70행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Import.xml) | 113행; 원본 보존 |
| [VIEWFRAME_ZVHR0129.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Source%20code/VIEWFRAME_ZVHR0129.abap) | 241행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Tables.xml) | 126행; 원본 보존 |
| [../../../Include/LZHR008_1U27.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Include/LZHR008_1U27.abap) | 241행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_1U27.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Include/LZHR008_1U27.abap) L1 | LZHR008_1U27: API 본문과 행말 공백 제외 본문 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Exception | `NO_VALUE_FOR_SUBSET_IDENT` | 형식 미기재 | — | [Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Exception.xml) L8 |
| Exception | `MISSING_CORR_NUMBER` | 형식 미기재 | — | [Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Exception.xml) L11 |
| Import | `VIEW_ACTION` | 형식 미기재 | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Import.xml) L8 |
| Import | `VIEW_NAME` | DD02V-TABNAME | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Import.xml) L22 |
| Import | `CORR_NUMBER` | E070-TRKORR | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Import.xml) L36 |
| Tables | `DBA_SELLIST` | VIMSELLIST | — | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Tables.xml) L8 |
| Tables | `DPL_SELLIST` | VIMSELLIST | — | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Tables.xml) L19 |
| Tables | `EXCL_CUA_FUNCT` | VIMEXCLFUN | — | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Tables.xml) L30 |
| Tables | `X_HEADER` | VIMDESC | — | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Tables.xml) L41 |
| Tables | `X_NAMTAB` | VIMNAMTAB | — | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Tables.xml) L52 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [VIEWPROC_ZVHR0129](VIEWPROC_ZVHR0129.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [VIEWFRAME_ZVHR0129.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Source%20code/VIEWFRAME_ZVHR0129.abap) L17, 49, 98, 137, 181 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_1UXX](LZHR008_1UXX.md) | Include | [LZHR008_1UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Include/LZHR008_1UXX.abap) L61 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.

| 미확인 종류 | 참조·이름 | 근거 |
|---|---|---|
| FORM 미해결 | `BEFORE_LEAVING_FRAME_FUNCTION: 범위 내 정의 0개` | [VIEWFRAME_ZVHR0129.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Source%20code/VIEWFRAME_ZVHR0129.abap) L75 |
| FORM 미해결 | `BEENDEN: 범위 내 정의 0개` | [VIEWFRAME_ZVHR0129.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Source%20code/VIEWFRAME_ZVHR0129.abap) L95 |
| FORM 미해결 | `TRANSPORTIEREN: 범위 내 정의 0개` | [VIEWFRAME_ZVHR0129.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Source%20code/VIEWFRAME_ZVHR0129.abap) L134 |
| FORM 미해결 | `ENQUEUE: 범위 내 정의 0개` | [VIEWFRAME_ZVHR0129.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Source%20code/VIEWFRAME_ZVHR0129.abap) L217 |
| FORM 미해결 | `ENQUEUE: 범위 내 정의 0개` | [VIEWFRAME_ZVHR0129.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Source%20code/VIEWFRAME_ZVHR0129.abap) L222 |
| FORM 미해결 | `ENQUEUE: 범위 내 정의 0개` | [VIEWFRAME_ZVHR0129.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Source%20code/VIEWFRAME_ZVHR0129.abap) L235 |
| FORM 미해결 | `BEFORE_LEAVING_FRAME_FUNCTION: 범위 내 정의 0개` | [VIEWFRAME_ZVHR0129.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0129/Source%20code/VIEWFRAME_ZVHR0129.abap) L237 |

정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
