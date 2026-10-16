---
title: "간주근무"
as_of: 2026-10-07
review_status: pending_business_review
tags: [business-map, 간주근무]
---

# 간주근무

[전체 목차](../INDEX.md)

해외출장과 간주 등록은 동일하지 않다. 선택기간 중 간주와 별도 간주 정산을 구분한다.

## 문서 관계와 적용 시점

| 구분 | 근거 문서·위치 | 연결 의미 | 확인 수준·시점 |
|---|---|---|---|
| 안내 | [user-faq](../../knowledge/reference/user-faq.md#FAQ%EB%B3%84%20%EB%82%B4%EC%9A%A9) — 16행, `출장일 선택근로 입력` | 간주 등록이 있는 경우 추가 실적 안내의 예외 | 확인: SRC-06 L23–28 |
| 합산 정정 | [SRC-10-late](../../knowledge/feedback/SRC-10-late.md#2.%20%EC%84%A0%ED%83%9D%EA%B7%BC%EB%AC%B4%20%EC%A4%91%20%EA%B0%84%EC%A3%BC%EA%B7%BC%EB%AC%B4%EC%8B%9C%EA%B0%84%3A%206%EC%9B%94%2010%EC%9D%BC%20%EB%85%BC%EC%9F%81%EA%B3%BC%206%EC%9B%94%2015%EC%9D%BC%20%EC%A0%95%EC%A0%95) — 37행, `6월 15일` | 공휴일 표시와 누적 합산 설명의 후속 정정 | 확인: 당시 설명 / 현재 실행 미검증 |
| 기간 기준 | [OPEN_QUESTIONS](../../knowledge/OPEN_QUESTIONS.md#%EB%AF%B8%ED%99%95%EC%9D%B8%20%EC%82%AC%ED%95%AD%EA%B3%BC%20%EC%9E%90%EB%A3%8C%20%ED%92%88%EC%A7%88%20%EC%9D%B4%EC%8A%88) — 11행, ` /  Q06` | 선택 종료일·간주 시작일과 대휴 기준 | 미확인: 공식 기준·후속 변경 확인 필요 |

## ABAP·웹 연결

| 설명 문서 | 연결 의미·한계 |
|---|---|
| [ZRPTH404](../sources/ZRPTH404.md) | **간주 정산관리** — 소스 헤더의 업무 명칭（원본3행）. 헤더 기반 후보이며 운영 사용·업무의 세부 구현은 미확인. |
| [ZRPTH414](../sources/ZRPTH414.md) | **간주 정산관리 후속 후보** — 소스 헤더의 업무 명칭（원본3행）. 헤더 기반 후보이며 운영 사용·업무의 세부 구현은 미확인. |
| [ZHR_52TM_CW_CAL_AND_DAEH](../sources/ZHR_52TM_CW_CAL_AND_DAEH.md) | **선택 실비·대휴 계산** — 휴가·근태시간 취득（원본166행）; 휴일·인정시간을 뺀 소정 재계산（원본221행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |

## 회의·결정·검증

- [회의 자료와 결정 이력](../meetings-decisions.md) — 해당 업무의 협의는 위 문서 근거를 따른다. 독립 회의록 없음; 회의 안내를 결정문으로 보지 않는다.
- [기존 회귀 질문](../../tests/business-qa.md) — Q05, Q16, Q17. 검증 항목과 업무의 연결은 **검토자 선정**이며 통과 판정이 아니다. 일반 답변 생성 시 기대답변을 근거로 읽지 않는다.
- [검증 범위와 부족 자료](../verification.md) — 링크 존재 검사와 업무·SAP 검증을 구분한다.

## 함께 볼 업무

- [선택근무](selective.md) — 선택기간 중 간주시간의 표시·누적 합산 설명이 정정된 관계. 근거: [협의 기록](../../knowledge/feedback/SRC-10-late.md) §2, 6/10 논쟁·6/15 정정. **확인: 과거 설명과 후속 정정**.
- [대휴·익휴·보상휴가](rest.md) — 선택 종료일과 간주 시작일에 따른 대휴 기준을 함께 검토해야 하는 관계. 근거: [미확인 사항](../../knowledge/OPEN_QUESTIONS.md) Q06, 11행. **미확인 항목의 연결**; 공식 기준으로 확정하지 않는다.
- [월정산·확정·전표·지급](settlement.md) — 간주 정산관리 이름을 가진 프로그램을 월정산 탐색 후보로 연결한다. 근거: [ZRPTH404](../sources/ZRPTH404.md)·[ZRPTH414](../sources/ZRPTH414.md) 원본 각3행. **추정·후보**; 세부 구현과 운영 진입점 미확인.

<!-- atlas:auto:start -->

## 전체 범위 단계 지도

[전체 업무 진행 상태](../PROGRESS.md) · [소스 설명 목차](../sources/INDEX.md)
출장에서 간주 대상 식별, 별도 정산 확정·취소·대휴, 결과 조회를 구분한다. ZRPTH404와 414는 별도 객체로 보존한다.
**완료 범위:** 아래 단계의 지정 소스 구간·직접 관계 확인 및 탐색 연결. 전체 업무 규칙·모든 분기 검토 완료를 뜻하지 않는다. 적용 시점은 추출본이며 운영 반영일 미확인. 기존 문서에 있는 정책/과거 검토안의 구분을 유지한다.

| 단계 | 관련 설명 문서 | 관계의 의미 | 근거 파일·코드 위치 | 수준 |
|---|---|---|---|---|
| 신청·대상 식별 | [ZRPTH404](../sources/ZRPTH404.md) · [ZRPTH414](../sources/ZRPTH414.md) · [ZHR_GANJU_LIST](../sources/ZHR_GANJU_LIST.md) | 해외출장 전체를 간주로 취급하지 않는다. 프로그램의 출장·간주 데이터를 연결한 후보이며 실제 출장 화면/승인 체인은 추출되지 않았다. | [ZRPTH404 원본](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404/source/ZRPTH404.abap) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[ZRPTH414 원본](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[ZHR_GANJU_LIST 원본](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GANJU_LIST/source/ZHR_GANJU_LIST.abap) — 파일 존재/헤더/정적 색인; 업무군 선정 | 분석상 연관·후보; 직접 호출 근거 아님 |
| 정산 확정·취소 | [ZRPTH414](../sources/ZRPTH414.md) · [HR_INFOTYPE_OPERATION](../sources/EXT-HR_INFOTYPE_OPERATION.md) · [ZTHR0114](../sources/ZTHR0114.md) | 414의 confirm_data/cancel_data 경로가 정보형 처리 함수를 호출하고 ZTHR0114를 기록/삭제한다. L1648–1844 및 L2040–2243 검토. | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L1711, 1733, 2113, 2133, 2165, 2184 (직접 호출)<br>[ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L1827, 2225, 2699, 2908 (데이터 저장) | 확인: 지정 구간의 정적 관계 |
| 대휴 생성·제거 | [ZRPTH414](../sources/ZRPTH414.md) · [ZTHRBS01](../sources/EXT-ZTHRBS01.md) | 414 create_daeh/remove_daeh의 ZTHRBS01 생성/삭제와 ZTHR0114 갱신은 별도 단계다. | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L2687, 2892 (데이터 저장) | 확인: 지정 구간의 정적 관계 |
| 간주 대휴 전용 관리 | [ZRPTH419](../sources/ZRPTH419.md) · [ZRPTH419F01](../sources/ZRPTH419F01.md) · [ZTHRBS01](../sources/EXT-ZTHRBS01.md) · [ZTHRBS13](../sources/EXT-ZTHRBS13.md) | 419 F01은 대휴 이력과 출장 관련 테이블을 갱신한다. 414와 동일한 운영 역할이라고 확정하지 않는다. | [ZRPTH419.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419/source/ZRPTH419.abap) L19 (Include)<br>[ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L955, 1008, 1090, 1110 (데이터 저장) | 확인: 지정 구간의 정적 관계 |
| 결과 조회 | [ZHR_GANJU_LIST](../sources/ZHR_GANJU_LIST.md) · [ZTHR0114](../sources/ZTHR0114.md) | 간주 조회 보고서가 ZTHR0114를 읽는다. 정산 프로그램에서 직접 호출하는 연결은 확인되지 않았다. | [ZHR_GANJU_LIST.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GANJU_LIST/source/ZHR_GANJU_LIST.abap) L202, 208 (데이터 조회) | 확인: 지정 구간의 정적 관계 |

### 이 업무의 미추출·미검토 경계

출장 신청/승인 본체, 외부 출장 테이블 정의와 함수, 404/414 실제 운영 사용 여부, 모든 금액 계산·소급 조건은 미확인.
화면 요청/직접 호출/Include/타입 참조/데이터 조회·저장/분석상 연관을 구분했다. 화면이 없거나 중계기·함수가 미추출이면 연결을 그 지점에서 멈춘다. 저장은 승인·지급·배포 완료의 동의어가 아니다.

<!-- atlas:auto:end -->
