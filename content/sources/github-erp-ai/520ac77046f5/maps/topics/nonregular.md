---
title: "비정규 인원 조회·수정"
as_of: 2026-10-07
review_status: pending_business_review
tags: [비정규인원관리]
---

# 비정규 인원 조회·수정

<!-- atlas:auto:start -->

## 전체 범위 단계 지도

[전체 업무 진행 상태](../PROGRESS.md) · [소스 설명 목차](../sources/INDEX.md)
ZHR_ETC의 BWORK/BPERSON 함수와 ZHRTMPPF2를 확인했다. 본문 전체를 읽었지만 채용·평가·급여 전반을 포함하지 않는다.
**완료 범위:** 아래 단계의 지정 소스 구간·직접 관계 확인 및 탐색 연결. 전체 업무 규칙·모든 분기 검토 완료를 뜻하지 않는다. 적용 시점은 추출본이며 운영 반영일 미확인. 기존 문서에 있는 정책/과거 검토안의 구분을 유지한다.

| 단계 | 관련 설명 문서 | 관계의 의미 | 근거 파일·코드 위치 | 수준 |
|---|---|---|---|---|
| 목록·중복표시 | [ZHR_GET_BWORK_INFO](../sources/ZHR_GET_BWORK_INFO.md) · [ZHRTMPPF2](../sources/ZHRTMPPF2.md) | BWORK_INFO는 기간/이름 조건 조회, 중복표시, 동적 정렬 및 건수를 반환한다(L28–73). 개인정보 실제 값은 설명 문서에 전재하지 않는다. | [ZHR_GET_BWORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BWORK_INFO/Source%20code/ZHR_GET_BWORK_INFO.abap) L34, 38, 47, 51 (데이터 조회) | 확인: 지정 구간의 정적 관계 |
| 단건 조회·수정 저장 | [ZHR_GET_BPERSON_INFO](../sources/ZHR_GET_BPERSON_INFO.md) · [ZHRTMPPF2](../sources/ZHRTMPPF2.md) | BPERSON_INFO의 ZFLAG R은 ZINDEX 단건 조회, S는 첫 입력행을 MODIFY한다(L19–39). 결재/취소 단계는 이 함수에 확인되지 않았다. | [ZHR_GET_BPERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BPERSON_INFO/Source%20code/ZHR_GET_BPERSON_INFO.abap) L20 (데이터 조회)<br>[ZHR_GET_BPERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_BPERSON_INFO/Source%20code/ZHR_GET_BPERSON_INFO.abap) L32 (데이터 저장) | 확인: 지정 구간의 정적 관계 |

### 이 업무의 미추출·미검토 경계

상위 요청 화면, 인증/수정권한, 실제 등록 업무·중복 판정 정책, 운영 인원 데이터는 미확인.
화면 요청/직접 호출/Include/타입 참조/데이터 조회·저장/분석상 연관을 구분했다. 화면이 없거나 중계기·함수가 미추출이면 연결을 그 지점에서 멈춘다. 저장은 승인·지급·배포 완료의 동의어가 아니다.

<!-- atlas:auto:end -->
