---
title: "자료 복사·결재 불일치 보정 도구"
as_of: 2026-10-07
review_status: pending_business_review
tags: [자료복사결재보정]
---

# 자료 복사·결재 불일치 보정 도구

<!-- atlas:auto:start -->

## 전체 범위 단계 지도

[전체 업무 진행 상태](../PROGRESS.md) · [소스 설명 목차](../sources/INDEX.md)
보정·복사 프로그램을 업무 목록에서 누락하지 않되 정상 신청/승인 절차와 구별한다. 실행 지침이 아닌 소스 탐색 문서다.
**완료 범위:** 아래 단계의 지정 소스 구간·직접 관계 확인 및 탐색 연결. 전체 업무 규칙·모든 분기 검토 완료를 뜻하지 않는다. 적용 시점은 추출본이며 운영 반영일 미확인. 기존 문서에 있는 정책/과거 검토안의 구분을 유지한다.

| 단계 | 관련 설명 문서 | 관계의 의미 | 근거 파일·코드 위치 | 수준 |
|---|---|---|---|---|
| 시간외 자료 복사 | [ZRPTH_ZTHRBS01_COPY](../sources/ZRPTH_ZTHRBS01_COPY.md) · [ZTHRBS01](../sources/EXT-ZTHRBS01.md) | COPY 보고서에서 조회 후 ZTHRBS01 INSERT를 확인했다. 개인별 입력값·원본 사번은 전재하지 않는다. | [ZRPTH_ZTHRBS01_COPY.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH_ZTHRBS01_COPY/source/ZRPTH_ZTHRBS01_COPY.abap) L26 (데이터 조회)<br>[ZRPTH_ZTHRBS01_COPY.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH_ZTHRBS01_COPY/source/ZRPTH_ZTHRBS01_COPY.abap) L88 (데이터 저장) | 확인: 지정 구간의 정적 관계 |
| 결재 데이터 불일치 점검·삭제 | [ZRPTMP003_BATCH](../sources/ZRPTMP003_BATCH.md) · [ZTHRBS01](../sources/EXT-ZTHRBS01.md) · [ZTHR0112](../sources/ZTHR0112.md) · [ZWF0022](../sources/EXT-ZWF0022.md) · [ZRPTMP003_M](../sources/ZRPTMP003_M.md) | BATCH와 M은 ZTHRBS01/ZTHR0112 참조를 점검하고 ZWF0022 삭제 구문을 가진다. 헤더의 과거 이슈 설명과 현재 운영 승인을 구분한다. | [ZRPTMP003_BATCH.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTMP003_BATCH/source/ZRPTMP003_BATCH.abap) L33, 44 (데이터 조회)<br>[ZRPTMP003_BATCH.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTMP003_BATCH/source/ZRPTMP003_BATCH.abap) L52 (데이터 저장)<br>[ZRPTMP003_M.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTMP003_M/source/ZRPTMP003_M.abap) L50 (데이터 저장) | 확인: 지정 구간의 정적 관계 |
| 연계 자료 초기화 | [ZHR_DELETE_WORK_INFO](../sources/ZHR_DELETE_WORK_INFO.md) | 업무·인원 연계의 전체삭제 프로그램은 person-work 지도에서도 공통 참조한다. | [ZHR_DELETE_WORK_INFO 원본](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_DELETE_WORK_INFO/source/ZHR_DELETE_WORK_INFO.abap) — 파일 존재/헤더/정적 색인; 업무군 선정 | 분석상 연관·후보; 직접 호출 근거 아님 |

### 이 업무의 미추출·미검토 경계

현재 운영 사용/폐기 여부, 실행권한·변형·백업·정합성 정책은 미확인. TEST·BATCH 명칭은 안전/활성 여부 근거가 아니다.
화면 요청/직접 호출/Include/타입 참조/데이터 조회·저장/분석상 연관을 구분했다. 화면이 없거나 중계기·함수가 미추출이면 연결을 그 지점에서 멈춘다. 저장은 승인·지급·배포 완료의 동의어가 아니다.

<!-- atlas:auto:end -->
