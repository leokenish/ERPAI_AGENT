---
title: "통합결재함·승인·반려·이력"
as_of: 2026-10-07
review_status: pending_business_review
tags: [통합결재]
---

# 통합결재함·승인·반려·이력

<!-- atlas:auto:start -->

## 전체 범위 단계 지도

[전체 업무 진행 상태](../PROGRESS.md) · [소스 설명 목차](../sources/INDEX.md)
대기/진행/완료/반려·회수함, 상세·이력 조회, 결재 처리 함수를 나누어 연결한다.
**완료 범위:** 아래 단계의 지정 소스 구간·직접 관계 확인 및 탐색 연결. 전체 업무 규칙·모든 분기 검토 완료를 뜻하지 않는다. 적용 시점은 추출본이며 운영 반영일 미확인. 기존 문서에 있는 정책/과거 검토안의 구분을 유지한다.

| 단계 | 관련 설명 문서 | 관계의 의미 | 근거 파일·코드 위치 | 수준 |
|---|---|---|---|---|
| 결재함 목록 | [APP_OT_LIST](../sources/APP_OT_LIST.md) · [ZHR_52TM_APPROVAL_LIST](../sources/ZHR_52TM_APPROVAL_LIST.md) · [DAILY_APP_LIST](../sources/DAILY_APP_LIST.md) · [FLEXTIME_LIST](../sources/FLEXTIME_LIST.md) | 시간외·선택·탄력 페이지가 공통 결재목록을 요청한다. 페이지 이름과 목록 구분 파라미터를 함께 확인한다. | [APP_OT_LIST.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/APP_OT_LIST/Layout/APP_OT_LIST.htm) L146, 370 (웹 요청)<br>[DAILY_APP_LIST.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_APP_LIST/Layout/DAILY_APP_LIST.htm) L134, 354 (웹 요청)<br>[FLEXTIME_LIST.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEXTIME_LIST/Layout/FLEXTIME_LIST.htm) L116, 300 (웹 요청) | 확인: 지정 구간의 정적 관계 |
| 상세 조회 | [WF_OT_POP](../sources/WF_OT_POP.md) · [ZHR_52TM_APPROVAL_OT_DETAIL](../sources/ZHR_52TM_APPROVAL_OT_DETAIL.md) | 시간외 팝업은 상세 함수를 요청한다. | [WF_OT_POP.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/WF_OT_POP/Layout/WF_OT_POP.htm) L141 (웹 요청) | 확인: 지정 구간의 정적 관계 |
| 화면 요청 → 업무별 승인 라우팅 | [ZHR_52TM_APPROVAL_LIST](../sources/ZHR_52TM_APPROVAL_LIST.md) · [ZHR_APPROVE_OT_DATA](../sources/EXT-ZHR_APPROVE_OT_DATA.md) · [ZHR_52TM_APPROVE_OT_DATA](../sources/ZHR_52TM_APPROVE_OT_DATA.md) · [ZHR_52TM_DAILY_APPROVE_OT_DATA](../sources/ZHR_52TM_DAILY_APPROVE_OT_DATA.md) | APP_OT_LIST L370–378은 I_ACTION=A를 전송한다. APPROVAL_LIST L168–304는 I_BOX 4=시간외, 5=탄력, 6=선택별로 승인 함수를 정적 호출한다. 이름이 LIST여도 조회 전용이 아니다. 기존 문서의 UI 연결 미확인 부분을 이번 지정구간 분석으로 보완했다. dispatcher 자체 실행은 미검증. | [ZHR_52TM_APPROVAL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Source%20code/ZHR_52TM_APPROVAL_LIST.abap) L198, 253, 290 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 탄력 승인·반려 | [ZHR_52TM_APPROVE_OT_DATA](../sources/ZHR_52TM_APPROVE_OT_DATA.md) · [ZWF_APPROVE_WORK](../sources/EXT-ZWF_APPROVE_WORK.md) · [ZWF_REJECT_WORK](../sources/EXT-ZWF_REJECT_WORK.md) | 승인과 반려가 외부 WF 함수를 각각 호출한다. | [ZHR_52TM_APPROVE_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_OT_DATA/Source%20code/ZHR_52TM_APPROVE_OT_DATA.abap) L413, 430 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 선택 승인·반려 | [ZHR_52TM_DAILY_APPROVE_OT_DATA](../sources/ZHR_52TM_DAILY_APPROVE_OT_DATA.md) · [ZTHR0112](../sources/ZTHR0112.md) · [ZWF_APPROVE_WORK](../sources/EXT-ZWF_APPROVE_WORK.md) | 선택용 함수도 별도로 상태를 기록하고 WF 후처리를 호출한다. | [ZHR_52TM_DAILY_APPROVE_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Source%20code/ZHR_52TM_DAILY_APPROVE_OT_DATA.abap) L169 (데이터 저장)<br>[ZHR_52TM_DAILY_APPROVE_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Source%20code/ZHR_52TM_DAILY_APPROVE_OT_DATA.abap) L180 (직접 호출) | 확인: 지정 구간의 정적 관계 |

### 이 업무의 미추출·미검토 경계

동적 폼 submit, BSP 이벤트의 실제 순서, 외부 통상 승인 ZHR_APPROVE_OT_DATA와 결재 엔진, 다단계 권한·최종 승인 시점 미검증.
화면 요청/직접 호출/Include/타입 참조/데이터 조회·저장/분석상 연관을 구분했다. 화면이 없거나 중계기·함수가 미추출이면 연결을 그 지점에서 멈춘다. 저장은 승인·지급·배포 완료의 동의어가 아니다.

<!-- atlas:auto:end -->
