---
title: "업무·리소스·인원 연계"
as_of: 2026-10-07
review_status: pending_business_review
tags: [업무리소스인원연계]
---

# 업무·리소스·인원 연계

<!-- atlas:auto:start -->

## 전체 범위 단계 지도

[전체 업무 진행 상태](../PROGRESS.md) · [소스 설명 목차](../sources/INDEX.md)
시간외 업무 밖에 존재하는 업무/프로그램·리소스·인원·태그 수집과 조회를 포함한다. 전체 인사/제작 업무를 분석했다고 확장하지 않는다.
**완료 범위:** 아래 단계의 지정 소스 구간·직접 관계 확인 및 탐색 연결. 전체 업무 규칙·모든 분기 검토 완료를 뜻하지 않는다. 적용 시점은 추출본이며 운영 반영일 미확인. 기존 문서에 있는 정책/과거 검토안의 구분을 유지한다.

| 단계 | 관련 설명 문서 | 관계의 의미 | 근거 파일·코드 위치 | 수준 |
|---|---|---|---|---|
| 수집·배정정보 조회 | [ZHR_GET_RES_WORK_INFO](../sources/ZHR_GET_RES_WORK_INFO.md) · [ZRPTPS_WORK_ASSIGNMENT](../sources/EXT-ZRPTPS_WORK_ASSIGNMENT.md) | GET_RES_WORK_INFO가 외부 업무배정 함수를 호출한다. | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L136 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 저장 | [ZHR_GET_RES_WORK_INFO](../sources/ZHR_GET_RES_WORK_INFO.md) · [ZHRWORKTBL](../sources/ZHRWORKTBL.md) · [ZHRPERSONTBL](../sources/ZHRPERSONTBL.md) · [ZHRTAGTBL](../sources/ZHRTAGTBL.md) | 수집 프로그램이 업무·인원·태그 테이블에 각각 MODIFY한다(L294/301/308). | [ZHR_GET_RES_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_GET_RES_WORK_INFO/source/ZHR_GET_RES_WORK_INFO.abap) L294, 301, 308 (데이터 저장) | 확인: 지정 구간의 정적 관계 |
| 후속 조회 | [ZHR_GET_WORK_INFO](../sources/ZHR_GET_WORK_INFO.md) · [ZHRWORKTBL](../sources/ZHRWORKTBL.md) · [ZHRPERSONTBL](../sources/ZHRPERSONTBL.md) · [ZHRTAGTBL](../sources/ZHRTAGTBL.md) | GET_WORK_INFO가 구분 A/B별 최신 ZDAY 자료를 읽는다. 같은 테이블 생산자/소비자라는 분석상 연결이며 직접 자동 실행 순서는 미확인. | [ZHR_GET_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_WORK_INFO/Source%20code/ZHR_GET_WORK_INFO.abap) L31, 32, 40, 41, 67, 68, 79, 80, 88, 89, 114, 115 (데이터 조회) | 확인: 지정 구간의 정적 관계 |
| 개인 인사·배정 조회 | [ZHR_GET_PERSON_INFO](../sources/ZHR_GET_PERSON_INFO.md) · [ZRPTPS_PERSON_ASSIGNMENT](../sources/EXT-ZRPTPS_PERSON_ASSIGNMENT.md) | GET_PERSON_INFO는 외부 개인배정 함수에 의존한다. | [ZHR_GET_PERSON_INFO.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR_ETC/Function%20Module/ZHR_GET_PERSON_INFO/Source%20code/ZHR_GET_PERSON_INFO.abap) L131 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 삭제 도구 | [ZHR_DELETE_WORK_INFO](../sources/ZHR_DELETE_WORK_INFO.md) · [ZHRWORKTBL](../sources/ZHRWORKTBL.md) · [ZHRPERSONTBL](../sources/ZHRPERSONTBL.md) · [ZHRTAGTBL](../sources/ZHRTAGTBL.md) | DELETE_WORK_INFO L12–14는 세 테이블 전체 DELETE FROM 구문이다. 운영 사용을 권고하거나 실행하지 않았으며 실제 사용 목적/권한은 미확인. | [ZHR_DELETE_WORK_INFO.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_DELETE_WORK_INFO/source/ZHR_DELETE_WORK_INFO.abap) L12, 13, 14 (데이터 저장) | 확인: 지정 구간의 정적 관계 |

### 이 업무의 미추출·미검토 경계

외부 PS 배정 함수·테이블, 이 연계의 웹 소비자·잡·데이터 갱신 정책, 개인/업무 조회 전체 분기 미확인.
화면 요청/직접 호출/Include/타입 참조/데이터 조회·저장/분석상 연관을 구분했다. 화면이 없거나 중계기·함수가 미추출이면 연결을 그 지점에서 멈춘다. 저장은 승인·지급·배포 완료의 동의어가 아니다.

<!-- atlas:auto:end -->
