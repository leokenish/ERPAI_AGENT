---
title: "재량근무"
as_of: 2026-10-07
review_status: pending_business_review
tags: [business-map, 재량근무]
---

# 재량근무

[전체 목차](../INDEX.md)

대상자·수당·대휴 프로그램을 구분한다. 정액을 모든 직무에 일괄 적용하지 않는다.

## 문서 관계와 적용 시점

| 구분 | 근거 문서·위치 | 연결 의미 | 확인 수준·시점 |
|---|---|---|---|
| 업무 흐름 | [erp-handover](../../knowledge/reference/erp-handover.md#%EC%9E%90%EB%A3%8C%EA%B0%80%20%EC%84%A4%EB%AA%85%ED%95%98%EB%8A%94%20%EC%97%85%EB%AC%B4) — 15행, `선택·재량근무` | 대상 등록·실적·월 지급·대휴 연결 | 확인: SRC-05 L17–18 문서 설명 |
| 누락 재처리 | [SRC-10-early-SRC-11](../../knowledge/feedback/SRC-10-early-SRC-11.md#3.%20SRC-11%3A%202026%EB%85%84%208~9%EC%9B%94%20%ED%9B%84%EC%86%8D%20%EC%9D%B4%EB%A0%A5) — 105행, `재량 누락` | 금액 입력 보고 뒤 정산월·상태 재확인 필요 | 확인: SRC-11 L174–195 / 완료 미확인 |
| 정액 예외 | [SRC-07-late-SRC-08](../../knowledge/feedback/SRC-07-late-SRC-08.md#4.4%20%ED%9C%B4%ED%9C%B4%20%EB%8C%80%ED%9C%B4%C2%B7%EA%B7%BC%EB%AC%B4%EC%8B%9C%EA%B0%84%20%EB%B3%B4%EC%A0%95%C2%B7%EC%A0%95%EC%82%B0%EC%95%A1%20%EA%B3%84%EC%82%B0) — 170행, `재량 직무별 대휴 단가` | 일부 직무120,000원 설명을 전체 직무에 확대 금지 | 확인: SRC-07 L3642–3663 / 사례 한정 |

## ABAP·웹 연결

| 설명 문서 | 연결 의미·한계 |
|---|---|
| [ZRPTH407](../sources/ZRPTH407.md) | **재량 대상자 조회·생성** — 소스 헤더의 업무 명칭（원본3행）. 헤더 기반 후보이며 운영 사용·업무의 세부 구현은 미확인. |
| [ZRPTH408](../sources/ZRPTH408.md) | **재량 수당관리** — 소스 헤더의 업무 명칭（원본3행）. 헤더 기반 후보이며 운영 사용·업무의 세부 구현은 미확인. |
| [ZRPTH409](../sources/ZRPTH409.md) | **재량 대휴관리** — 소스 헤더의 업무 명칭（원본3행）. 헤더 기반 후보이며 운영 사용·업무의 세부 구현은 미확인. |

## 회의·결정·검증

- [회의 자료와 결정 이력](../meetings-decisions.md) — 해당 업무의 협의는 위 문서 근거를 따른다. 독립 회의록 없음; 회의 안내를 결정문으로 보지 않는다.
- [기존 회귀 질문](../../tests/business-qa.md) — Q27, Q16. 검증 항목과 업무의 연결은 **검토자 선정**이며 통과 판정이 아니다. 일반 답변 생성 시 기대답변을 근거로 읽지 않는다.
- [검증 범위와 부족 자료](../verification.md) — 링크 존재 검사와 업무·SAP 검증을 구분한다.

## 함께 볼 업무

- [대휴·익휴·보상휴가](rest.md) — 재량 대휴의 직무별 금액 설명과 전용 관리 후보를 연결한다. 근거: [협의 기록](../../knowledge/feedback/SRC-07-late-SRC-08.md) §4.4, 170행 및 [ZRPTH409](../sources/ZRPTH409.md) 원본3행. **문서 사례 확인·헤더 기반 구현 후보**.
- [월정산·확정·전표·지급](settlement.md) — 재량 누락 금액 입력 보고와 정산월·상태 확인을 분리하는 관계. 근거: [후속 협의](../../knowledge/feedback/SRC-10-early-SRC-11.md) §3, 105행, SRC-11 L174–195. **확인: 보고 이력**; 최종 지급 완료는 미확인.
- [시간외 단가·직군·효력일](rates.md) — 재량 직무별 대휴 금액을 일반 시간외 등급 단가와 구별해서 확인하는 분석 경로. 근거: [협의 기록](../../knowledge/feedback/SRC-07-late-SRC-08.md) §4.4, 170행, SRC-07 L3642–3663. **문서 사례 기반 연결**; 일부 직무의 120,000원을 전체에 확대하지 않는다.

<!-- atlas:auto:start -->

## 전체 범위 단계 지도

[전체 업무 진행 상태](../PROGRESS.md) · [소스 설명 목차](../sources/INDEX.md)
대상자 생성/삭제, 수당, 대휴를 세 프로그램으로 나누어 연결한다. DDIC 기준표와 실제 저장된 운영값은 다르다.
**완료 범위:** 아래 단계의 지정 소스 구간·직접 관계 확인 및 탐색 연결. 전체 업무 규칙·모든 분기 검토 완료를 뜻하지 않는다. 적용 시점은 추출본이며 운영 반영일 미확인. 기존 문서에 있는 정책/과거 검토안의 구분을 유지한다.

| 단계 | 관련 설명 문서 | 관계의 의미 | 근거 파일·코드 위치 | 수준 |
|---|---|---|---|---|
| 대상자 등록·검사 | [ZRPTH407](../sources/ZRPTH407.md) · [ZRPTH407F01](../sources/ZRPTH407F01.md) · [PA9021](../sources/PA9021.md) · [HR_INFOTYPE_OPERATION](../sources/EXT-HR_INFOTYPE_OPERATION.md) | 407 F01은 기존 PA9021 기간 겹침 검사 후 정보형 INS를 호출한다(L1111–1142). | [ZRPTH407.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407/source/ZRPTH407.abap) L19 (Include)<br>[ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L190, 1118 (데이터 조회)<br>[ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L1135 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 대상자 취소·삭제 | [ZRPTH407F01](../sources/ZRPTH407F01.md) · [PA9021](../sources/PA9021.md) | PA9021 중 해당 기간의 근로유형 0140을 삭제하는 구간 L779–803. 승인 절차 존재를 의미하지 않는다. | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L789 (데이터 저장) | 확인: 지정 구간의 정적 관계 |
| 수당 조회·반영 | [ZRPTH408](../sources/ZRPTH408.md) · [ZRPTH408F01](../sources/ZRPTH408F01.md) · [PA2010](../sources/EXT-PA2010.md) · [HR_INFOTYPE_OPERATION](../sources/EXT-HR_INFOTYPE_OPERATION.md) | 408은 PA2010을 읽고 p_opt를 HR_INFOTYPE_OPERATION으로 전달한다. INS/DEL 등 전체 호출 조건은 원본 FORM 역링크에서 조사한다. | [ZRPTH408.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408/source/ZRPTH408.abap) L19 (Include)<br>[ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L278, 409, 1175, 1363, 1625 (데이터 조회)<br>[ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L1818 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 대휴 생성·삭제 | [ZRPTH409](../sources/ZRPTH409.md) · [ZRPTH409F01](../sources/ZRPTH409F01.md) · [ZTHRBS01](../sources/EXT-ZTHRBS01.md) | 409 F01에서 ZTHRBS01 INSERT/MODIFY/DELETE를 확인했다. 발생수·유효기간의 정책 확정과 구별한다. | [ZRPTH409.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409/source/ZRPTH409.abap) L19 (Include)<br>[ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L1077, 1079, 1164, 1437, 1439 (데이터 저장) | 확인: 지정 구간의 정적 관계 |
| 기준표 참조 | [ZRPTH407F01](../sources/ZRPTH407F01.md) · [ZTHR0125](../sources/ZTHR0125.md) · [ZRPTH408F01](../sources/ZRPTH408F01.md) · [ZTHR0128](../sources/ZTHR0128.md) · [ZRPTH409F01](../sources/ZRPTH409F01.md) · [ZTHR0129](../sources/ZTHR0129.md) | 대상·수당·대휴 코드가 유형별 설정 테이블을 읽는다. 표의 현재 운영 행 값은 제공되지 않았다. | [ZRPTH407F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH407F01/source/ZRPTH407F01.abap) L204 (데이터 조회)<br>[ZRPTH408F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH408F01/source/ZRPTH408F01.abap) L290 (데이터 조회)<br>[ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L280 (데이터 조회) | 확인: 지정 구간의 정적 관계 |

### 이 업무의 미추출·미검토 경계

엑셀 업로드 전체 검증, 직무별 대상·수당·대휴 정책 승인본, 외부 인사 함수와 급여 지급 실행은 미확인.
화면 요청/직접 호출/Include/타입 참조/데이터 조회·저장/분석상 연관을 구분했다. 화면이 없거나 중계기·함수가 미추출이면 연결을 그 지점에서 멈춘다. 저장은 승인·지급·배포 완료의 동의어가 아니다.

<!-- atlas:auto:end -->
