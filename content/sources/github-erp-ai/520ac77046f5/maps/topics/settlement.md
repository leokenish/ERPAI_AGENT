---
title: "월정산·확정·전표·지급"
as_of: 2026-10-07
review_status: pending_business_review
tags: [business-map, 월정산전표지급]
---

# 월정산·확정·전표·지급

[전체 목차](../INDEX.md)

입력·승인·월마감·PA2010·전표·은행 전송을 각각 다른 상태로 탐색한다.

[선택 특별연장과 월정산 총시간](special-extension.md#월정산%20총근로시간과%20208시간%20제한) — CAL_AND_DAEH L1603–1676의 실근로+간주 208시간 비교, 특별연장 X 존재 분기, 초과·연장·대휴시간 계산을 정적 확인했다. 사용자 누적표시와 월정산을 구분하며 운영 적용 검증은 아니다.

## 문서 관계와 적용 시점

| 구분 | 근거 문서·위치 | 연결 의미 | 확인 수준·시점 |
|---|---|---|---|
| 처리 기준 | [working-time-lifecycle](../../knowledge/processes/working-time-lifecycle.md#%EC%83%81%ED%83%9C%EB%A5%BC%20%EB%B6%84%EB%A6%AC%ED%95%B4%EC%95%BC%20%ED%95%98%EB%8A%94%20%EC%9D%B4%EC%9C%A0) — 14행, `## 상태를 분리` | 화면 계산과 최종 지급 완료의 차이 | 확인: 문서 분석 / 자동 실행순서 보장 아님 |
| 협의 이력 | [TIMELINE](../../knowledge/decisions/TIMELINE.md#%EC%8B%9C%EC%A0%90%EB%B3%84%20%ED%98%91%EC%9D%98%C2%B7%EB%B3%80%EA%B2%BD%20%EC%9D%B4%EB%A0%A5) — 20행, `2026-07-09` | EDI 내부수정 후 은행 반영 실패·재처리 | 확인: SRC-10 L2431–2567 보고 / 지급증빙 별도 |
| 환수환급 | [SRC-10-late](../../knowledge/feedback/SRC-10-late.md#25.%20%EC%84%A0%ED%83%9D%EA%B7%BC%EB%AC%B4%20%ED%99%98%EC%88%98%C2%B7%ED%99%98%EA%B8%89%EA%B3%BC%20%EB%88%84%EB%9D%BD%EB%B6%84%20%EC%9D%B4%EC%A4%91%20%EC%A0%95%EC%82%B0%20%EB%B0%A9%EC%A7%80%20%EC%82%AC%EB%A1%80) — 246행, `환수환급` | 누락과 환수환급 재입력의 중복 위험 | 확인: SRC-10 L3365–3390 / 최종 검증 별도 |
| FI 코드 분석 | [flows](../../knowledge/hr/flows.md#F06.%20PA2010%EC%97%90%EC%84%9C%20FI%20%EC%97%85%EB%AC%B4%EB%A1%9C%20%EB%84%98%EC%96%B4%EA%B0%80%EB%8A%94%20%EC%9D%BC%EB%B6%80%20%EC%97%B0%EA%B2%B0) — 102행, `## F06.` | PA2010과 FI 연결의 일부 | 확인: 정적 분석 / 전체 회계처리 미검토 |

## ABAP·웹 연결

| 설명 문서 | 연결 의미·한계 |
|---|---|
| [ZRPTH411F01](../sources/ZRPTH411F01.md) | **선택 월정산 처리** — 기간 정산 호출（원본36행）; 산정 결과 인포타입 반영 구문（원본737행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZRPTH402F01](../sources/ZRPTH402F01.md) | **탄력 정산 확정** — 월정산 계산 호출（원본17행）; 확정 데이터 반영（원본592행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZHR_52TM_VALID_DATE_CHECK](../sources/ZHR_52TM_VALID_DATE_CHECK.md) | **입력 기한·월마감 검사** — 마감 데이터 조회（원본41행）; 조회 모드의 과거 조회 예외（원본63행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZRPTH2012_MF01](../sources/ZRPTH2012_MF01.md) | **시간외 FI 연결** — 인포타입 조회（원본57행）; 전표번호와 인포타입 후처리 연결（원본365행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |

## 회의·결정·검증

- [회의 자료와 결정 이력](../meetings-decisions.md) — 해당 업무의 협의는 위 문서 근거를 따른다. 독립 회의록 없음; 회의 안내를 결정문으로 보지 않는다.
- [기존 회귀 질문](../../tests/business-qa.md) — Q14, Q23, Q24, Q27. 검증 항목과 업무의 연결은 **검토자 선정**이며 통과 판정이 아니다. 일반 답변 생성 시 기대답변을 근거로 읽지 않는다.
- [검증 범위와 부족 자료](../verification.md) — 링크 존재 검사와 업무·SAP 검증을 구분한다.

## 함께 볼 업무

- [퇴직자·관리자 입력 검토](retired.md) — 재직 여부 외에도 입력일의 월마감·기한 검사가 수정 가능성에 영향을 주는지 검토한다. 근거: [ZHR_52TM_VALID_DATE_CHECK](../sources/ZHR_52TM_VALID_DATE_CHECK.md) 원본41·63행. **정적 검사 확인·영향 검토 연결**; 퇴직 예외 구현을 의미하지 않는다.
- [시간외 단가·직군·효력일](rates.md) — 확정·재정산 금액의 근무일별 단가와 마스터를 대조하는 분석 경로. 근거: [현행 단가](../../knowledge/policies/overtime-rate-20260901.md) §「직군별 현행 기준 — SRC-13 후속 정정」 및 [미확인 사항](../../knowledge/OPEN_QUESTIONS.md) Q13, 18행. **정책 확인·실제 반영 미확인**.
- [탄력근로 계획·결재](flexible.md) — 탄력 정산 확정 프로그램이 월정산 계산을 호출하는 관계. 근거: [ZRPTH402F01](../sources/ZRPTH402F01.md) 원본17·592행. **확인: 정적 호출·반영 구문**.
- [재량근무](discretionary.md) — 재량 누락 금액 입력 보고와 정산월·상태 확인을 분리하는 관계. 근거: [후속 협의](../../knowledge/feedback/SRC-10-early-SRC-11.md) §3, 105행, SRC-11 L174–195. **확인: 보고 이력**; 최종 지급 완료는 미확인.
- [간주근무](deemed.md) — 간주 정산관리 이름을 가진 프로그램을 월정산 탐색 후보로 연결한다. 근거: [ZRPTH404](../sources/ZRPTH404.md)·[ZRPTH414](../sources/ZRPTH414.md) 원본 각3행. **추정·후보**; 세부 구현과 운영 진입점 미확인.

<!-- atlas:auto:start -->

## 전체 범위 단계 지도

[전체 업무 진행 상태](../PROGRESS.md) · [소스 설명 목차](../sources/INDEX.md)
근로유형별 계산 → 확정 데이터/PA2010 → FI 처리 → EDI 요청을 데이터 연관과 직접 호출로 구별한다.
**완료 범위:** 아래 단계의 지정 소스 구간·직접 관계 확인 및 탐색 연결. 전체 업무 규칙·모든 분기 검토 완료를 뜻하지 않는다. 적용 시점은 추출본이며 운영 반영일 미확인. 기존 문서에 있는 정책/과거 검토안의 구분을 유지한다.

| 단계 | 관련 설명 문서 | 관계의 의미 | 근거 파일·코드 위치 | 수준 |
|---|---|---|---|---|
| 탄력 월정산 | [ZRPTH402F01](../sources/ZRPTH402F01.md) · [ZHR_52TM_MONTHLY_PAYMENT](../sources/ZHR_52TM_MONTHLY_PAYMENT.md) · [PA2010](../sources/EXT-PA2010.md) | 402 F01이 월 계산 후 PA2010을 기록한다. | [ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L17 (직접 호출)<br>[ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) L592, 868 (데이터 저장) | 확인: 지정 구간의 정적 관계 |
| 선택 월마감 | [ZRPTH411F01](../sources/ZRPTH411F01.md) · [ZTHR0160](../sources/ZTHR0160.md) · [PA2010](../sources/EXT-PA2010.md) | 411 F01은 기간 정산 호출, 마감 테이블 및 PA2010 변경을 포함한다. | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L553, 587, 737, 1231 (데이터 저장) | 확인: 지정 구간의 정적 관계 |
| FI 대상 조회 | [ZRPTH2012_MF01](../sources/ZRPTH2012_MF01.md) · [PA2010](../sources/EXT-PA2010.md) | 2012_M F01이 PA2010을 조회한다. 위 보고서에서 FI 프로그램으로 직접 호출되는 것이 아니라 같은 데이터 대상에 의한 후속 처리 연관이다. | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L57, 1409 (데이터 조회) | 확인: 지정 구간의 정적 관계 |
| 전표 요청 | [ZRPTH2012_MF01](../sources/ZRPTH2012_MF01.md) · [ZBDC](../sources/EXT-ZBDC.md) | POST→process_bdc, ZBDC에 F-63을 전달. 반환 전표번호를 확인하는 코드가 있다(L345–377, L881–905). | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L882 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 참조번호 갱신 | [ZRPTH2012_MF01](../sources/ZRPTH2012_MF01.md) · [PA2010](../sources/EXT-PA2010.md) | 전표번호가 있으면 update_pa2010을 호출하고 AWREF를 기록한다(L1204–1228). REV·RSAVE는 별도 명령이다. | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L1223 (데이터 저장) | 확인: 지정 구간의 정적 관계 |
| EDI 후속 요청 | [ZRPTH2012_MF01](../sources/ZRPTH2012_MF01.md) · [ZFI_FIRM_REQUEST_EDI](../sources/EXT-ZFI_FIRM_REQUEST_EDI.md) | EDI 명령은 은행정보 검사 후 외부 함수에 transfer_list를 전달한다(L1310–1373). 메시지/함수 호출만으로 은행 지급 성공을 확정하지 않는다. | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L1369 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 사용자 지급현황 조회 | [ORD_OT_MONTHLY_LIST](../sources/ORD_OT_MONTHLY_LIST.md) · [FLEX_WORK_MONTHLY_LIST](../sources/FLEX_WORK_MONTHLY_LIST.md) · [POP_FLEX_WORK_MONTHLY_DETAIL](../sources/POP_FLEX_WORK_MONTHLY_DETAIL.md) | 웹 월지급·상세조회는 별도 화면 및 외부 요청 함수다. 사용자 표시와 지급 시스템 완료 상태를 구별한다. | [ORD_OT_MONTHLY_LIST 원본](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_MONTHLY_LIST/Layout/ORD_OT_MONTHLY_LIST.htm) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[FLEX_WORK_MONTHLY_LIST 원본](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_MONTHLY_LIST/Layout/FLEX_WORK_MONTHLY_LIST.htm) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[POP_FLEX_WORK_MONTHLY_DETAIL 원본](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/POP_FLEX_WORK_MONTHLY_DETAIL/Layout/POP_FLEX_WORK_MONTHLY_DETAIL.htm) — 파일 존재/헤더/정적 색인; 업무군 선정 | 분석상 연관·후보; 직접 호출 근거 아님 |

### 이 업무의 미추출·미검토 경계

통상 월정산 본체의 전체 추출 여부, 외부 ZBDC/ZFI 함수, 역분개·0015/0267 전체 분기, 은행 처리 결과·실제 잡은 미확인.
화면 요청/직접 호출/Include/타입 참조/데이터 조회·저장/분석상 연관을 구분했다. 화면이 없거나 중계기·함수가 미추출이면 연결을 그 지점에서 멈춘다. 저장은 승인·지급·배포 완료의 동의어가 아니다.

<!-- atlas:auto:end -->
