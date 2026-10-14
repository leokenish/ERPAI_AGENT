---
title: "I AM 등록·기본설정"
as_of: 2026-10-07
review_status: pending_business_review
tags: [IAM등록기본설정]
---

# I AM 등록·기본설정

<!-- atlas:auto:start -->

## 전체 범위 단계 지도

[전체 업무 진행 상태](../PROGRESS.md) · [소스 설명 목차](../sources/INDEX.md)
업무내용·근무/휴게시간·결재자를 저장하는 I AM과 기본선택 변경을 구분한다. IAM 및 SET_DEFAULT 함수 본문은 전체 읽기 완료.
**완료 범위:** 아래 단계의 지정 소스 구간·직접 관계 확인 및 탐색 연결. 전체 업무 규칙·모든 분기 검토 완료를 뜻하지 않는다. 적용 시점은 추출본이며 운영 반영일 미확인. 기존 문서에 있는 정책/과거 검토안의 구분을 유지한다.

| 단계 | 관련 설명 문서 | 관계의 의미 | 근거 파일·코드 위치 | 수준 |
|---|---|---|---|---|
| 화면·등록·조회·삭제 요청 | [IAM](../sources/IAM.md) · [ZHR_52TM_IAM](../sources/ZHR_52TM_IAM.md) · [IAM_LIST](../sources/IAM_LIST.md) | IAM의 LIST/SAVE/DELETE와 IAM_LIST 선택 팝업이 같은 함수를 요청한다. | [IAM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/IAM/Layout/IAM.htm) L397, 423, 463 (웹 요청)<br>[IAM_LIST.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/IAM_LIST/Layout/IAM_LIST.htm) L116 (웹 요청) | 확인: 지정 구간의 정적 관계 |
| 검사·저장 | [ZHR_52TM_IAM](../sources/ZHR_52TM_IAM.md) · [ZTHR0124](../sources/ZTHR0124.md) | IAM L89–153에서 필수값·시각 검사, 사번별 순번 생성 후 INSERT한다. DELETE L156–167은 선택행 삭제. 결재자 필드 저장이 결재 상신을 뜻하지 않는다. | [ZHR_52TM_IAM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_IAM/Source%20code/ZHR_52TM_IAM.abap) L30, 129 (데이터 조회)<br>[ZHR_52TM_IAM.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_IAM/Source%20code/ZHR_52TM_IAM.abap) L139, 148, 162 (데이터 저장) | 확인: 지정 구간의 정적 관계 |
| 기본설정 | [IAM](../sources/IAM.md) · [ZHR_52TM_SET_DEFAULT](../sources/ZHR_52TM_SET_DEFAULT.md) · [ZTHR0124](../sources/ZTHR0124.md) | SET_DEFAULT는 대상행 검사→기존 기본표시 해제→선택행 ZDEFT=X→성공 시 COMMIT WORK AND WAIT의 순서다. | [IAM.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/IAM/Layout/IAM.htm) L557 (웹 요청)<br>[ZHR_52TM_SET_DEFAULT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT/Source%20code/ZHR_52TM_SET_DEFAULT.abap) L27, 33 (데이터 저장) | 확인: 지정 구간의 정적 관계 |
| 후속 입력 활용 | [ZHR_52TM_SET_DEFAULT_TIME](../sources/ZHR_52TM_SET_DEFAULT_TIME.md) · [ZHR_52TM_SIMPLE_SETTING](../sources/ZHR_52TM_SIMPLE_SETTING.md) | 시간외 입력 초기값 업무와 분석상 연관. 이 단계만으로 자동 신청·상신되는 직접 호출은 확정하지 않았다. | [ZHR_52TM_SET_DEFAULT_TIME 원본](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SET_DEFAULT_TIME/Source%20code/ZHR_52TM_SET_DEFAULT_TIME.abap) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[ZHR_52TM_SIMPLE_SETTING 원본](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Source%20code/ZHR_52TM_SIMPLE_SETTING.abap) — 파일 존재/헤더/정적 색인; 업무군 선정 | 분석상 연관·후보; 직접 호출 근거 아님 |

### 이 업무의 미추출·미검토 경계

외부 결재자 검색·검사, 로그인 공통 함수/dispatcher와 실제 사용자 권한·동시성은 미확인.
화면 요청/직접 호출/Include/타입 참조/데이터 조회·저장/분석상 연관을 구분했다. 화면이 없거나 중계기·함수가 미추출이면 연결을 그 지점에서 멈춘다. 저장은 승인·지급·배포 완료의 동의어가 아니다.

<!-- atlas:auto:end -->
