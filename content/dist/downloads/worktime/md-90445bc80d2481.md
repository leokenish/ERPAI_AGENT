---
title: "ZE52WKTP — 근로유형(0010 통상,0030 교대,0110 선택,0120 2주탄력,0130 간주,0140 재량)"
as_of: 2026-10-07
review_status: pending_business_review
tags: [IAM등록기본설정, PC모바일공통웹, 간주근무, 교대근무, 근로시간알림, 근무현황조회, 기준정보유지보수, 대휴익휴보상휴가, 선택근무, 시간외단가등급, 시차근무대상자관리, 월정산전표지급, 인사정보형9021_9023, 자료복사결재보정, 재량근무, 탄력근무, 통상시차시간외, 통합결재, 퇴직자관리자입력검토, 특별연장재난방송, 휴가공가반차]
---

# ZE52WKTP — 근로유형(0010 통상,0030 교대,0110 선택,0120 2주탄력,0130 간주,0140 재량)

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **DDIC Data element**. 설명: 근로유형(0010 통상,0030 교대,0110 선택,0120 2주탄력,0130 간주,0140 재량).

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Data%20element/ZE52WKTP/definition.xml) | 55행; 원본 보존 |

### 데이터 정의

XML TABCLASS: `해당 없음`. GOTSTATE: `A`. 정의는 운영 행 데이터가 아니다. 구조·타입을 DB 저장 테이블로 해석하지 않는다.

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [ZD52WKTP1](ZD52WKTP1.md) | **타입 참조** — DOMNAME XML 정의 참조; 데이터 조회/저장 아님 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Data%20element/ZE52WKTP/definition.xml) L10 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_2F04](LZHR008_2F04.md) | 타입 참조 | [LZHR008_2F04.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F04.abap) L459, 1526 |
| [LZHR008_2TOP](LZHR008_2TOP.md) | 타입 참조 | [LZHR008_2TOP.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2TOP.abap) L17, 18, 19, 20, 21, 22, 23, 24 |
| [P9021](P9021.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/P9021/definition.xml) L1850, 2745 |
| [P9023](P9023.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/P9023/definition.xml) L1850, 2745 |
| [PA9021](PA9021.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/PA9021/definition.xml) L1784, 2679 |
| [PA9023](PA9023.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/PA9023/definition.xml) L1784, 2316 |
| [PS9021](PS9021.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/PS9021/definition.xml) L68, 866 |
| [PS9023](PS9023.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/PS9023/definition.xml) L68, 501 |
| [ZHCMT_BSP_PA_XX_R9021](ZHCMT_BSP_PA_XX_R9021.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZHCMT_BSP_PA_XX_R9021/definition.xml) L794 |
| [ZHRH017](ZHRH017.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/SHLP/ZHRH017/definition.xml) L32 |
| [ZHR_52TM_CALC_WEEK_TIME](ZHR_52TM_CALC_WEEK_TIME.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WEEK_TIME/Import.xml) L29 |
| [ZHR_52TM_CALC_WORK_TIME_DAYILY](ZHR_52TM_CALC_WORK_TIME_DAYILY.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Import.xml) L71 |
| [ZHR_52TM_CW_PAYMENT_WKPRD](ZHR_52TM_CW_PAYMENT_WKPRD.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Import.xml) L43 |
| [ZHR_52TM_MONTHLY_PAYMENT](ZHR_52TM_MONTHLY_PAYMENT.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Import.xml) L43 |
| [ZHR_52TM_PLAN_CALC_TIME](ZHR_52TM_PLAN_CALC_TIME.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_CALC_TIME/Import.xml) L15 |
| [ZHR_52TM_PLAN_CHECK_PERIOD](ZHR_52TM_PLAN_CHECK_PERIOD.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_CHECK_PERIOD/Import.xml) L43 |
| [ZHR_52TM_PLAN_SIMPLE_SETTING](ZHR_52TM_PLAN_SIMPLE_SETTING.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_SIMPLE_SETTING/Import.xml) L43 |
| [ZHR_52TM_PLAN_TO_RESULT](ZHR_52TM_PLAN_TO_RESULT.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_TO_RESULT/Import.xml) L29 |
| [ZHR_52TM_PLAN_WORK_TIME](ZHR_52TM_PLAN_WORK_TIME.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Import.xml) L71 |
| [ZHR_52TM_PLAN_WORK_TIME](ZHR_52TM_PLAN_WORK_TIME.md) | 타입 참조 | [ZHR_52TM_PLAN_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PLAN_WORK_TIME/Source%20code/ZHR_52TM_PLAN_WORK_TIME.abap) L42 |
| [ZHR_52TM_REAL_CHECK_PERIOD](ZHR_52TM_REAL_CHECK_PERIOD.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_CHECK_PERIOD/Import.xml) L43 |
| [ZHR_52TM_REAL_WORK_TIME](ZHR_52TM_REAL_WORK_TIME.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Import.xml) L71 |
| [ZHR_52TM_REAL_WORK_TIME](ZHR_52TM_REAL_WORK_TIME.md) | 타입 참조 | [ZHR_52TM_REAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME/Source%20code/ZHR_52TM_REAL_WORK_TIME.abap) L42 |
| [ZHR_52TM_REAL_WORK_TIME_TEAM](ZHR_52TM_REAL_WORK_TIME_TEAM.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME_TEAM/Import.xml) L57 |
| [ZHR_52TM_REAL_WORK_TIME_TEAM_M](ZHR_52TM_REAL_WORK_TIME_TEAM_M.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_REAL_WORK_TIME_TEAM_M/Import.xml) L57 |
| [ZHR_52TM_SIMPLE_SETTING](ZHR_52TM_SIMPLE_SETTING.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_SIMPLE_SETTING/Import.xml) L43 |
| [ZRPTH402TOP](ZRPTH402TOP.md) | 타입 참조 | [ZRPTH402TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402TOP/source/ZRPTH402TOP.abap) L133 |
| [ZRPTH404TOP](ZRPTH404TOP.md) | 타입 참조 | [ZRPTH404TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH404TOP/source/ZRPTH404TOP.abap) L23 |
| [ZRPTH405TOP](ZRPTH405TOP.md) | 타입 참조 | [ZRPTH405TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH405TOP/source/ZRPTH405TOP.abap) L34 |
| [ZRPTH406TOP](ZRPTH406TOP.md) | 타입 참조 | [ZRPTH406TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406TOP/source/ZRPTH406TOP.abap) L34 |
| [ZRPTH411TOP](ZRPTH411TOP.md) | 타입 참조 | [ZRPTH411TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411TOP/source/ZRPTH411TOP.abap) L264 |
| [ZSHR0108](ZSHR0108.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0108/definition.xml) L134 |
| [ZSHR0109](ZSHR0109.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0109/definition.xml) L332 |
| [ZSHR0117](ZSHR0117.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0117/definition.xml) L266 |
| [ZSHR0118](ZSHR0118.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0118/definition.xml) L68 |
| [ZSHR0119](ZSHR0119.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0119/definition.xml) L266 |
| [ZSHR0120](ZSHR0120.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0120/definition.xml) L332 |
| [ZSHR0122](ZSHR0122.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0122/definition.xml) L134 |
| [ZSHR0123](ZSHR0123.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0123/definition.xml) L332 |
| [ZSHR0124](ZSHR0124.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0124/definition.xml) L134 |
| [ZSHR0125](ZSHR0125.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0125/definition.xml) L266 |
| [ZSHR0126](ZSHR0126.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0126/definition.xml) L266 |
| [ZSHR0133](ZSHR0133.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0133/definition.xml) L134 |
| [ZSHR0137](ZSHR0137.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0137/definition.xml) L200 |
| [ZSHR0141](ZSHR0141.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0141/definition.xml) L332 |
| [ZSHR0145](ZSHR0145.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0145/definition.xml) L464 |
| [ZSHR0146](ZSHR0146.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0146/definition.xml) L266 |
| [ZSWF0015](ZSWF0015.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0015/definition.xml) L200 |
| [ZSWF0016](ZSWF0016.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml) L68 |
| [ZTHR0102](ZTHR0102.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0102/definition.xml) L134 |
| [ZTHR0104](ZTHR0104.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0104/definition.xml) L134 |
| [ZTHR0105](ZTHR0105.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0105/definition.xml) L134, 1482 |
| [ZTHR0106](ZTHR0106.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0106/definition.xml) L200 |
| [ZTHR0108](ZTHR0108.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0108/definition.xml) L200 |
| [ZTHR0112](ZTHR0112.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0112/definition.xml) L398 |
| [ZTHR0113](ZTHR0113.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0113/definition.xml) L398 |
| [ZTHR0114](ZTHR0114.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0114/definition.xml) L662 |
| [ZTHR0120](ZTHR0120.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0120/definition.xml) L398 |
| [ZTHR0132](ZTHR0132.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0132/definition.xml) L332 |
| [ZTHR0160](ZTHR0160.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0160/definition.xml) L200 |
| [ZVHR0102](ZVHR0102.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/VIEW/ZVHR0102/definition.xml) L119 |
| [ZVHR0104](ZVHR0104.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/VIEW/ZVHR0104/definition.xml) L119 |
| [ZVHR0105](ZVHR0105.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/VIEW/ZVHR0105/definition.xml) L128 |

### 관련 업무와 미확인 범위

- [업무 배정 후보 목록](CANDIDATES.md) — 직접 업무 연결은 아직 미검토. 호출·타입 역링크로 조사할 수 있다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
