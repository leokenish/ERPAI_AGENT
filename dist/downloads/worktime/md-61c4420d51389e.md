---
title: "ZHR_52TM_CONVERT_ZGUBUN_WKTYPE — [52시간] 근로구분기준 근로형태값 찾기"
as_of: 2026-10-07
review_status: pending_business_review
tags: [교대근무, 통상시차시간외, 퇴직자관리자입력검토]
---

# ZHR_52TM_CONVERT_ZGUBUN_WKTYPE — [52시간] 근로구분기준 근로형태값 찾기

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **함수**. 설명: [52시간] 근로구분기준 근로형태값 찾기.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../Attributes.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CONVERT_ZGUBUN_WKTYPE/Attributes.xml) | 116행; 원본 보존 |
| [../Changing.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CONVERT_ZGUBUN_WKTYPE/Changing.xml) | 28행; 원본 보존 |
| [../Exception.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CONVERT_ZGUBUN_WKTYPE/Exception.xml) | 28행; 원본 보존 |
| [../Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CONVERT_ZGUBUN_WKTYPE/Export.xml) | 40행; 원본 보존 |
| [../Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CONVERT_ZGUBUN_WKTYPE/Import.xml) | 57행; 원본 보존 |
| [ZHR_52TM_CONVERT_ZGUBUN_WKTYPE.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CONVERT_ZGUBUN_WKTYPE/Source%20code/ZHR_52TM_CONVERT_ZGUBUN_WKTYPE.abap) | 51행; 원본 보존 |
| [../Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CONVERT_ZGUBUN_WKTYPE/Tables.xml) | 28행; 원본 보존 |
| [../../../Include/LZHR008_2U46.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U46.abap) | 51행; 원본 보존 |

### 구성 확인

| 종류 | 근거 | 의미 |
|---|---|---|
| 대응 Include | [LZHR008_2U46.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2U46.abap) L1 | LZHR008_2U46: API 본문과 행말 공백 제외 본문 동일. 독립 업무로 중복 집계하지 않음 |

### 함수 인터페이스

| 방향 | 매개변수 | XML 타입 | OPTIONAL | 근거 |
|---|---|---|---|---|
| Export | `E_WKTYPE` | CHAR2 | — | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CONVERT_ZGUBUN_WKTYPE/Export.xml) L8 |
| Import | `I_ZGUBUN` | ZBSGUBUN | — | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CONVERT_ZGUBUN_WKTYPE/Import.xml) L8 |
| Import | `I_FLEXTY` | ZYUHYUNG | X | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CONVERT_ZGUBUN_WKTYPE/Import.xml) L22 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZBSGUBUN](EXTERNAL_DEPENDENCIES.md#ZBSGUBUN) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CONVERT_ZGUBUN_WKTYPE/Import.xml) L15 |
| [ZYUHYUNG](EXTERNAL_DEPENDENCIES.md#ZYUHYUNG) | **타입 참조** — TYP XML 정의 참조; 데이터 조회/저장 아님 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CONVERT_ZGUBUN_WKTYPE/Import.xml) L29 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2UXX](LZHR008_2UXX.md) | Include | [LZHR008_2UXX.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2UXX.abap) L87 |
| [MZH4110F01](MZH4110F01.md) | 직접 호출 | [MZH4110F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110F01/source/MZH4110F01.abap) L1586 |
| [ZHR_52TM_MOBILE_OVERTIME_CHECK](ZHR_52TM_MOBILE_OVERTIME_CHECK.md) | 직접 호출 | [ZHR_52TM_MOBILE_OVERTIME_CHECK.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_CHECK/Source%20code/ZHR_52TM_MOBILE_OVERTIME_CHECK.abap) L236 |
| [ZHR_52TM_MOBILE_OVERTIME_DETL](ZHR_52TM_MOBILE_OVERTIME_DETL.md) | 직접 호출 | [ZHR_52TM_MOBILE_OVERTIME_DETL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_DETL/Source%20code/ZHR_52TM_MOBILE_OVERTIME_DETL.abap) L124 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
