---
title: "퇴직자·관리자 입력 검토"
as_of: 2026-10-07
review_status: pending_business_review
tags: [business-map, 퇴직자관리자입력검토]
---

# 퇴직자·관리자 입력 검토

[전체 목차](../INDEX.md)

현재 퇴직 여부와 대상 근무일의 재직 상태를 구분하는 변경 검토 경로다. 퇴직자 수정 허용 정책이 승인됐다는 근거는 없다.

## 문서 관계와 적용 시점

| 구분 | 근거 문서·위치 | 연결 의미 | 확인 수준·시점 |
|---|---|---|---|
| 업무 사례 | [SRC-10-early-SRC-11](../../knowledge/feedback/SRC-10-early-SRC-11.md#2.2%202026%EB%85%84%204%EC%9B%94%3A%20%EC%8B%9C%EC%B0%A8%EC%8B%A4%EB%B9%84%2C%20%EC%A0%95%EC%82%B0%20%EC%88%9C%EC%84%9C%2C%20BS01%20%ED%95%B4%EC%84%9D%2C%20%EC%9E%85%EB%A0%A5%20%EC%98%88%EC%99%B8) — 48행, `4/3, 선택근로 중도 퇴직` | 퇴직 정산과 선택 신청 취소는 다른 대상 | 확인: SRC-10 L385–401 / 당시 처리 설명 |
| 관리자 자료 | [erp-handover](../../knowledge/reference/erp-handover.md#%EA%B8%B0%EC%88%A0%20%EC%A0%95%EB%B3%B4%EC%9D%98%20%EC%82%AC%EC%9A%A9%EB%B2%95) — 24행, `관리자 디버깅용` | 관리자용 테이블 문서 언급과 실제 접근 구현의 차이 | 확인: SRC-05 L50–51 문서 언급 / 권한·대행 구현 미확인 |
| 미확인 의존 | [open-questions](../../knowledge/hr/open-questions.md#Q04.%20%EC%9B%B9%EC%97%90%EC%84%9C%20%ED%95%A8%EC%88%98%EA%B9%8C%EC%A7%80%EC%9D%98%20%ED%98%B8%EC%B6%9C%20%EA%B2%BD%EB%A1%9C) — 36행, `### Q04.` | 웹 dispatcher·권한의 미추출 경계 | 미확인: 본인·관리자 진입 경로 |

## ABAP·웹 연결

| 설명 문서 | 연결 의미·한계 |
|---|---|
| [ZHR_52TM_GET_PERSONNEL_DATA_N](../sources/ZHR_52TM_GET_PERSONNEL_DATA_N.md) | **근무일 인사·등급 검사** — 기준일 인수의 기본값 SY-DATUM（원본6행）; 외부 인사조회 호출（원본39행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [LZHR008_2F06](../sources/LZHR008_2F06.md) | **통상 화면 초기화·수정 연결** — 초기 검사（원본73행）; 전달 기준일（원본102행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [LZHR008_3F01](../sources/LZHR008_3F01.md) | **선택 재직·근태 검사** — 첫 번째 입력 검사 진입（원본106행）; 대상 근무일 재직상태 검사（원본132행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZHR_52TM_CW_CHECK_DATA](../sources/ZHR_52TM_CW_CHECK_DATA.md) | **선택 입력 검사 분기** — 선택 실적 검사 호출（원본25행）; 추가 검사 경로 호출（원본60행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZHR_52TM_MEMBER_CHECK](../sources/ZHR_52TM_MEMBER_CHECK.md) | **유연근무 대상자 검사** — 현재일 인사정보 조회（원본40행）; 신청기간의 비재직 구간 검사（원본55행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZHR_52TM_VALID_DATE_CHECK](../sources/ZHR_52TM_VALID_DATE_CHECK.md) | **입력 기한·월마감 검사** — 마감 데이터 조회（원본41행）; 조회 모드의 과거 조회 예외（원본63행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |

## 회의·결정·검증

- [회의 자료와 결정 이력](../meetings-decisions.md) — 해당 업무의 협의는 위 문서 근거를 따른다. 독립 회의록 없음; 회의 안내를 결정문으로 보지 않는다.
- [기존 회귀 질문](../../tests/business-qa.md) — Q14, Q19, Q31. 검증 항목과 업무의 연결은 **검토자 선정**이며 통과 판정이 아니다. 일반 답변 생성 시 기대답변을 근거로 읽지 않는다.
- [검증 범위와 부족 자료](../verification.md) — 링크 존재 검사와 업무·SAP 검증을 구분한다.

## 함께 볼 업무

- [통상·시차 시간외 입력](ordinary.md) — 통상 화면 초기화에서 인사조회로 전달하는 기준일을 퇴직자 입력 검토와 연결한다. 근거: [LZHR008_2F06](../sources/LZHR008_2F06.md) 원본73·102행과 [GET_PERSONNEL_DATA_N](../sources/ZHR_52TM_GET_PERSONNEL_DATA_N.md) 원본6·39행. **확인: 정적 소스**; 관리자 우회 권한은 미확인.
- [선택근무](selective.md) — 선택 실적의 대상 근무일 재직 검사를 퇴직 후 수정 검토와 연결한다. 근거: [LZHR008_3F01](../sources/LZHR008_3F01.md) 원본106·132행. **확인: 정적 소스**; 퇴직자 수정 허용 정책의 승인 여부는 미확인이다.
- [월정산·확정·전표·지급](settlement.md) — 재직 여부 외에도 입력일의 월마감·기한 검사가 수정 가능성에 영향을 주는지 검토한다. 근거: [ZHR_52TM_VALID_DATE_CHECK](../sources/ZHR_52TM_VALID_DATE_CHECK.md) 원본41·63행. **정적 검사 확인·영향 검토 연결**; 퇴직 예외 구현을 의미하지 않는다.

<!-- atlas:auto:start -->

## 전체 범위 단계 지도

[전체 업무 진행 상태](../PROGRESS.md) · [소스 설명 목차](../sources/INDEX.md)
기존 지도에 있는 변경 검토 경로를 보완한다. 퇴직자 수정 허용 정책이 승인됐다고 해석하지 않는다.
**완료 범위:** 아래 단계의 지정 소스 구간·직접 관계 확인 및 탐색 연결. 전체 업무 규칙·모든 분기 검토 완료를 뜻하지 않는다. 적용 시점은 추출본이며 운영 반영일 미확인. 기존 문서에 있는 정책/과거 검토안의 구분을 유지한다.

| 단계 | 관련 설명 문서 | 관계의 의미 | 근거 파일·코드 위치 | 수준 |
|---|---|---|---|---|
| 검토 요청 | [ZHR_52TM_GET_PERSONNEL_DATA_N](../sources/ZHR_52TM_GET_PERSONNEL_DATA_N.md) · [LZHR008_3F01](../sources/LZHR008_3F01.md) · [DAILY_WORK_INPUT_ADM](../sources/DAILY_WORK_INPUT_ADM.md) · [SAPMZH4110](../sources/SAPMZH4110.md) | 현재일의 접근 문제와 근무일의 재직 검사를 나누는 분석상 연관이다. 새 허용 정책·수정 구현을 제안/실행한 것이 아니다. | [ZHR_52TM_GET_PERSONNEL_DATA_N 원본](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Source%20code/ZHR_52TM_GET_PERSONNEL_DATA_N.abap) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[LZHR008_3F01 원본](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[DAILY_WORK_INPUT_ADM 원본](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[SAPMZH4110 원본](../../exports/ZHR5/packages/ZHR5/programs/PROG/SAPMZH4110/source/SAPMZH4110.abap) — 파일 존재/헤더/정적 색인; 업무군 선정 | 분석상 연관·후보; 직접 호출 근거 아님 |
| 신청일·상신일 검사 | [ZHR_52TM_MOBILE_OVERTIME_APPR](../sources/ZHR_52TM_MOBILE_OVERTIME_APPR.md) · [ZHR_52TM_VALID_DATE_CHECK](../sources/ZHR_52TM_VALID_DATE_CHECK.md) | 공통 요청 함수가 유효기간 검사에 의존한다. 과거일 수정의 전체 허용 조건은 별도 원문 확인. | [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L74, 331 (직접 호출) | 확인: 지정 구간의 정적 관계 |

### 이 업무의 미추출·미검토 경계

로그인 시점 접근권한·퇴직자 변경 정책 승인·운영 예외값·현재 소스 배포 여부 미확인.
화면 요청/직접 호출/Include/타입 참조/데이터 조회·저장/분석상 연관을 구분했다. 화면이 없거나 중계기·함수가 미추출이면 연결을 그 지점에서 멈춘다. 저장은 승인·지급·배포 완료의 동의어가 아니다.

<!-- atlas:auto:end -->
