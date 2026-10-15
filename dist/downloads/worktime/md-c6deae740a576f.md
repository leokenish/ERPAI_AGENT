---
title: "시차근무 대상자 관리"
as_of: 2026-10-07
review_status: pending_business_review
tags: [시차근무대상자관리]
---

# 시차근무 대상자 관리

<!-- atlas:auto:start -->

## 전체 범위 단계 지도

[전체 업무 진행 상태](../PROGRESS.md) · [소스 설명 목차](../sources/INDEX.md)
통상 시차 시간외 입력과 별도로 관리자 대상기간 등록·수정·삭제 및 PA9023 연계를 확인한다.
**완료 범위:** 아래 단계의 지정 소스 구간·직접 관계 확인 및 탐색 연결. 전체 업무 규칙·모든 분기 검토 완료를 뜻하지 않는다. 적용 시점은 추출본이며 운영 반영일 미확인. 기존 문서에 있는 정책/과거 검토안의 구분을 유지한다.

| 단계 | 관련 설명 문서 | 관계의 의미 | 근거 파일·코드 위치 | 수준 |
|---|---|---|---|---|
| 관리자 화면 소스 | [SAPMZH432](../sources/SAPMZH432.md) · [MZH432I01](../sources/MZH432I01.md) · [MZH432F01](../sources/MZH432F01.md) | SAPMZH432 Include와 명령 처리를 연결한다. 헤더는 시차근무 대상자 관리지만 실제 메뉴 등록은 검증하지 않았다. | [SAPMZH432.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/SAPMZH432/source/SAPMZH432.abap) L19, 20 (Include) | 확인: 지정 구간의 정적 관계 |
| 조회 | [MZH432F01](../sources/MZH432F01.md) · [PA9023](../sources/PA9023.md) | F01은 PA9023을 조회한다. | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L45 (데이터 조회) | 확인: 지정 구간의 정적 관계 |
| 검사·수정·저장 | [MZH432I01](../sources/MZH432I01.md) · [PA9023](../sources/PA9023.md) · [HR_INFOTYPE_OPERATION](../sources/EXT-HR_INFOTYPE_OPERATION.md) | I01 L475–518: 기간중복 검사, 변경 모드의 이전 행 삭제, 정보형 9023 처리 요청. DB 삭제와 함수 기록은 별개 구문이다. | [MZH432I01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432I01/source/MZH432I01.abap) L197, 504 (데이터 저장)<br>[MZH432I01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432I01/source/MZH432I01.abap) L509 (직접 호출) | 확인: 지정 구간의 정적 관계 |

### 이 업무의 미추출·미검토 경계

실제 트랜잭션→모듈풀→화면 이벤트 연결, 정보형 클래스 검증·업무 승인 절차와 정책은 미확인.
화면 요청/직접 호출/Include/타입 참조/데이터 조회·저장/분석상 연관을 구분했다. 화면이 없거나 중계기·함수가 미추출이면 연결을 그 지점에서 멈춘다. 저장은 승인·지급·배포 완료의 동의어가 아니다.

<!-- atlas:auto:end -->
