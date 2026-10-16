---
title: "근로시간 한도·입력 알림"
as_of: 2026-10-07
review_status: pending_business_review
tags: [근로시간알림]
---

# 근로시간 한도·입력 알림

<!-- atlas:auto:start -->

## 전체 범위 단계 지도

[전체 업무 진행 상태](../PROGRESS.md) · [소스 설명 목차](../sources/INDEX.md)
한도 알림 후보 생성, 중복 확인, 메일/SMS 요청, 기록을 구분한다. 선택 입력 안내 SMS는 별도 프로그램이다.
**완료 범위:** 아래 단계의 지정 소스 구간·직접 관계 확인 및 탐색 연결. 전체 업무 규칙·모든 분기 검토 완료를 뜻하지 않는다. 적용 시점은 추출본이며 운영 반영일 미확인. 기존 문서에 있는 정책/과거 검토안의 구분을 유지한다.

| 단계 | 관련 설명 문서 | 관계의 의미 | 근거 파일·코드 위치 | 수준 |
|---|---|---|---|---|
| 기준·실적 조회 | [ZRPTH403](../sources/ZRPTH403.md) · [ZTHR0101](../sources/ZTHR0101.md) · [ZHR_52TM_REAL_WORK_TIME](../sources/ZHR_52TM_REAL_WORK_TIME.md) | 403은 상수 및 탄력 실적 함수를 통해 알림대상 계산 자료를 취득한다. | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L55 (데이터 조회)<br>[ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L200 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 메일·SMS 요청 | [ZRPTH403](../sources/ZRPTH403.md) · [Z_KBS_SENDMAIL](../sources/EXT-Z_KBS_SENDMAIL.md) · [ZSMSSEND](../sources/EXT-ZSMSSEND.md) | 조건 분기 후 외부 발송 함수를 호출한다. 호출 위치 L406/447/482이며 실제 발송은 확인하지 않았다. | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L406, 447, 482 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 발송 관련 기록 | [ZRPTH403](../sources/ZRPTH403.md) · [ZTHR0121](../sources/ZTHR0121.md) | ZTHR0121 조회/변경이 존재한다. 중복방지·재시도 전체 효과는 실행 자료 필요. | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L269 (데이터 조회)<br>[ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L506 (데이터 저장) | 확인: 지정 구간의 정적 관계 |
| 선택 입력 알림 | [ZHR_OVERTIME_SMS](../sources/ZHR_OVERTIME_SMS.md) · [ZTHR0132](../sources/ZTHR0132.md) · [ZHR_52TM_CW_GET_DATA](../sources/ZHR_52TM_CW_GET_DATA.md) · [ZSMSSEND](../sources/EXT-ZSMSSEND.md) | ZHR_OVERTIME_SMS가 선택 대상/데이터를 조회하고 SMS를 요청한다. 403과 동일 잡으로 합치지 않는다. | [ZHR_OVERTIME_SMS.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_OVERTIME_SMS/source/ZHR_OVERTIME_SMS.abap) L50, 83, 122 (데이터 조회)<br>[ZHR_OVERTIME_SMS.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZHR_OVERTIME_SMS/source/ZHR_OVERTIME_SMS.abap) L60, 93, 137, 155 (직접 호출) | 확인: 지정 구간의 정적 관계 |

### 이 업무의 미추출·미검토 경계

잡 스케줄, 수신자 동의/명단, 운영 임계값, 외부 메일·SMS 구현과 발송 성공 여부 미확인.
화면 요청/직접 호출/Include/타입 참조/데이터 조회·저장/분석상 연관을 구분했다. 화면이 없거나 중계기·함수가 미추출이면 연결을 그 지점에서 멈춘다. 저장은 승인·지급·배포 완료의 동의어가 아니다.

<!-- atlas:auto:end -->
