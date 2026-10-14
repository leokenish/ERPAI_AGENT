---
title: "선택근무"
as_of: 2026-10-07
review_status: pending_business_review
tags: [business-map, 선택근무]
---

# 선택근무

[전체 목차](../INDEX.md)

4주 소정·휴일 충당·대휴·입력·정산을 연결한다. 2022 매뉴얼은 당시 판본이고, 현행 단가는 SRC-12/13 정정을 함께 본다.

[선택근무 특별연장 입력과 정산 분석 2026-10-08](special-extension.md#선택근무%20특별연장%20입력과%20정산%20분석%202026-10-08) — 체크 활성·동의·저장·상신, 일반 입력 한도와 월정산의 서로 다른 208시간 처리, 소정·누적·가산·간주·대휴·실비 영향을 실제 지정 소스로 확인했다. 과거 8시간 제한 분기와 현재 추출 코드, 운영 미검증을 구분한다.

## 문서 관계와 적용 시점

| 구분 | 근거 문서·위치 | 연결 의미 | 확인 수준·시점 |
|---|---|---|---|
| 기준 | [selective-work-202203](../../knowledge/manuals/selective-work-202203.md#%EA%B3%84%EC%82%B0%20%EA%B0%9C%EB%85%90) — 14행, `## 계산 개념` | 소정·최대·휴게·대휴 개념 | 확인: 문서 기준 / 2022-03 판본 |
| 협의 | [SRC-10-early-SRC-11](../../knowledge/feedback/SRC-10-early-SRC-11.md#2.2%202026%EB%85%84%204%EC%9B%94%3A%20%EC%8B%9C%EC%B0%A8%EC%8B%A4%EB%B9%84%2C%20%EC%A0%95%EC%82%B0%20%EC%88%9C%EC%84%9C%2C%20BS01%20%ED%95%B4%EC%84%9D%2C%20%EC%9E%85%EB%A0%A5%20%EC%98%88%EC%99%B8) — 51행, `4/7 선택 소정 부족시간` | 휴일 실근로와 소정 충당 후 대휴시간 구분 | 확인: 당시 설명 / SRC-10 L439–488 |
| 결정 이력 | [TIMELINE](../../knowledge/decisions/TIMELINE.md#%EC%8B%9C%EC%A0%90%EB%B3%84%20%ED%98%91%EC%9D%98%C2%B7%EB%B3%80%EA%B2%BD%20%EC%9D%B4%EB%A0%A5) — 18행, `2026-06-15` | 선택+간주 합산 설명 정정 | 확인: 협의 이력 / 현행 구현 미검증 |
| 미확인 | [OPEN_QUESTIONS](../../knowledge/OPEN_QUESTIONS.md#%EB%AF%B8%ED%99%95%EC%9D%B8%20%EC%82%AC%ED%95%AD%EA%B3%BC%20%EC%9E%90%EB%A3%8C%20%ED%92%88%EC%A7%88%20%EC%9D%B4%EC%8A%88) — 7행, ` /  Q02` | 최대시간 본문과 화면 각주 차이 | 미확인: 승인 기준·산식 대조 필요 |

## ABAP·웹 연결

| 설명 문서 | 연결 의미·한계 |
|---|---|
| [ZHR_52TM_CW_PROCESS_DATA](../sources/ZHR_52TM_CW_PROCESS_DATA.md) | **선택 실적 조회·저장·상신** — 선택 정산 마감 조회（원본36행）; 수정 저장 분기（원본86행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZHR_52TM_CW_CAL_AND_DAEH](../sources/ZHR_52TM_CW_CAL_AND_DAEH.md) | **선택 실비·대휴 계산** — 휴가·근태시간 취득（원본166행）; 휴일·인정시간을 뺀 소정 재계산（원본221행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZHR_52TM_CW_PAYMENT_WKPRD](../sources/ZHR_52TM_CW_PAYMENT_WKPRD.md) | **선택 기간별 정산 호출** — 선택 실비·대휴 계산 호출（원본90행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [ZRPTH411F01](../sources/ZRPTH411F01.md) | **선택 월정산 처리** — 기간 정산 호출（원본36행）; 산정 결과 인포타입 반영 구문（원본737행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |
| [DAILY_WORK_INPUT](../sources/DAILY_WORK_INPUT.md) | **선택 일별 실적 웹 입력** — 선택 실적 처리 요청（원본822행）; 반차 때 실제 근무시간 입력 안내（원본977행）. 확인: 표시 구간의 정적 소스. 실제 실행·배포는 미검증. |

## 회의·결정·검증

- [회의 자료와 결정 이력](../meetings-decisions.md) — 해당 업무의 협의는 위 문서 근거를 따른다. 독립 회의록 없음; 회의 안내를 결정문으로 보지 않는다.
- [기존 회귀 질문](../../tests/business-qa.md) — Q01, Q02, Q04, Q12, Q17, Q21, Q22. 검증 항목과 업무의 연결은 **검토자 선정**이며 통과 판정이 아니다. 일반 답변 생성 시 기대답변을 근거로 읽지 않는다.
- [검증 범위와 부족 자료](../verification.md) — 링크 존재 검사와 업무·SAP 검증을 구분한다.

## 함께 볼 업무

- [휴가·공가·반차](leave.md) — 휴가 인정시간이 선택 소정시간 계산에 들어가는 관계. 근거: [ZHR_52TM_CW_CAL_AND_DAEH](../sources/ZHR_52TM_CW_CAL_AND_DAEH.md) 원본166·221행. **확인: 정적 소스**.
- [대휴·익휴·보상휴가](rest.md) — 소정 충족 여부와 휴일근로가 선택 대휴 조건으로 이어지는 관계. 근거: [선택 매뉴얼](../../knowledge/manuals/selective-work-202203.md) §「대휴 예시의 범위」, SRC-02 pp.5–6. **확인: 2022년 문서 기준**.
- [시간외 단가·직군·효력일](rates.md) — 8~9월에 걸친 선택기간은 근무일·연장 발생일의 단가 적용 검토로 이어진다. 근거: [협의 기록](../../knowledge/feedback/SRC-10-late.md) §14-2. **확인: 2026-07-29 협의**; 직군 기준은 SRC-13 후속 정정을 함께 본다.
- [월정산·확정·전표·지급](settlement.md) — 선택 기간 계산 결과를 월정산에서 사용하는 관계. 근거: [ZRPTH411F01](../sources/ZRPTH411F01.md) 원본36·737행. **확인: 정적 호출·반영 구문**; 운영 완료를 뜻하지 않는다.
- [간주근무](deemed.md) — 선택기간 중 간주시간의 표시·누적 합산 설명이 정정된 관계. 근거: [협의 기록](../../knowledge/feedback/SRC-10-late.md) §2, 6/10 논쟁·6/15 정정. **확인: 과거 설명과 후속 정정**.

## 누적근로시간 가산 포함 변경 검토 2026-10-08

**결론: 사용자 확인 범위는 누적시간 표시만 변경이다. 현재 추출본의 주요 표시 경로에는 가산 포함 코드가 이미 있다. 같은 가산을 다시 더하는 변경은 제안하지 않는다. 실제 제외 사례가 재현될 때 조회 응답의 표시 전용 값을 분리하는 것이 수정 방향이다.**

### 요청과 적용 범위

- 요청일·분석일: 2026-10-08. 사용자 추가 확인: “누적시간 표시만 변경”. 대상은 선택근로 사용자 화면이며 직군 제한·효력일·과거 기간 표시 적용 시점은 미지정이다.
- 분석 상태: 지정 구간의 실제 ABAP·웹·XML 확인, 변경안 제안. 소스 수정·SAP 실행·운영 반영은 수행하지 않았다. 실데이터가 없어 운영 화면의 제외 현상이나 그 원인은 재현하지 못했다.
- 한도 검사·대휴·연장수당·정산·저장값 재산정은 이번 변경 범위 밖이다. 조회시 표시와 저장시 가산 산출을 구분한다.
- 대상 근거는 현재 작업트리 추출본이다. Git HEAD `16f74f8023b27cc819c2b6ca4644bd6d1cff1f36`은 저장소 버전이며 SAP 활성 버전이 아니다. [manifest](../../exports/ZHR5/manifest.xml) HEADER L4–17은 KSD/300, BASIS 700, PARTIAL, 외부 참조만 수집하는 범위를 표시한다. 정확한 운영 배포본·추출 실행일은 로그 부재로 확인하지 못했다.

### 화면에서 데이터까지 확인한 경로

| 순서 | 관련 설명 | 실제 관계와 근거 |
|---|---|---|
| 화면 | [DAILY_WORK_MONTHLY_CONDITION](../sources/DAILY_WORK_MONTHLY_CONDITION.md) | 달력/누적조회는 `I_CASE=B`로 요청한다. 응답 `CS_ZSHR0144.CWKHR`를 `SP_TEXT5`에 그대로 표시한다. JavaScript에서 가산을 따로 빼거나 더하지 않는다. [DAILY_WORK_MONTHLY_CONDITION 원본](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_MONTHLY_CONDITION/Layout/DAILY_WORK_MONTHLY_CONDITION.htm) L208–247 |
| 요청 함수 | [ZHR_52TM_CW_GET_DATA](../sources/ZHR_52TM_CW_GET_DATA.md) | `B` 분기 → `PERFORM B_CW_GET_DATA`, 출력 `CS_ZSHR0144`. 웹 요청 문자열과 ABAP 본문은 확인했지만 공통 AJAX dispatcher 본문은 미추출이다. [ZHR_52TM_CW_GET_DATA 원본](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_GET_DATA/Source%20code/ZHR_52TM_CW_GET_DATA.abap) L32–40 |
| 표시 조립 | [LZHR008_3F02](../sources/LZHR008_3F02.md) | `B_CW_GET_DATA`가 BASE_DATA를 호출하고 `CWKHR_MIN`을 분→시간 문자열로 변환해 `ZSHR0144-CWKHR`에 넣는다. [LZHR008_3F02 원본](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F02.abap) L56–68, 99–104, 313–323 |
| 기간 데이터와 합계 | [ZHR_52TM_CW_BASE_DATA](../sources/ZHR_52TM_CW_BASE_DATA.md) | `ZTHR0132`에서 대상 기간을 찾고 `ZTHR0112`를 기간·근무유형·상태로 조회한다. `WEEKHR_MIN + HOLIHR_MIN`이 최종 `CWKHR_MIN`이다. [ZHR_52TM_CW_BASE_DATA 원본](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Source%20code/ZHR_52TM_CW_BASE_DATA.abap) L38–91, 629–635 |
| 저장 데이터 | [ZTHR0112](../sources/ZTHR0112.md) · [ZSHR0141](../sources/ZSHR0141.md) | `ZOVRADD_TM`은 가산근무시간(TIMS, 6자리), `ZRLWK_TM`과 별도 필드다. 전자는 [ZTHR0112 원본](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0112/definition.xml) L2505–2547, 조회/처리 구조는 [ZSHR0141 원본](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0141/definition.xml) L1053–1095 |
| 계산/응답 구조 | [ZSHR0137](../sources/ZSHR0137.md) · [ZSHR0144](../sources/ZSHR0144.md) | 내부 `CWKHR_MIN`은 INT4 분, 웹 응답 `CWKHR`는 CHAR6 표시 문자열이다. 누적을 TIMS 필드 자체에 합산하거나 문자열을 일반 숫자로 더하지 않는다. [ZSHR0137 원본](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0137/definition.xml) L723–765; [ZSHR0144 원본](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0144/definition.xml) L525–567 |

같은 필드의 표시 위치: PC 입력 [DAILY_WORK_INPUT 원본](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT/Layout/DAILY_WORK_INPUT.htm) L787–815, 수정 [DAILY_WORK_MODIFY 원본](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_MODIFY/Layout/DAILY_WORK_MODIFY.htm) L769–800, 상세 [DAILY_WORK_DETAIL 원본](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_DETAIL/Layout/DAILY_WORK_DETAIL.htm) L665–696. 모바일 기존 목록/입력/수정/상세는 각각 [MDAILY_WORK_LIST](../sources/MDAILY_WORK_LIST.md) L429–449, [MDAILY_WORK_INPUT](../sources/MDAILY_WORK_INPUT.md) L834–864, [MDAILY_WORK_MODIFY](../sources/MDAILY_WORK_MODIFY.md) L831–862, [MDAILY_WORK_DETAIL](../sources/MDAILY_WORK_DETAIL.md) L692–723이다. 모바일 new 목록/입력/수정/상세는 각각 [MDAILY_WORK_LIST_new](../sources/MDAILY_WORK_LIST_new.md) L213–232, [MDAILY_WORK_INPUT_new](../sources/MDAILY_WORK_INPUT_new.md) L160–187, [MDAILY_WORK_MODIFY_new](../sources/MDAILY_WORK_MODIFY_new.md) L164–193, [MDAILY_WORK_DETAIL_new](../sources/MDAILY_WORK_DETAIL_new.md) L157–186이다. 원본 링크는 각 설명에 있다. 파일명이 new라는 이유로 운영 사용 화면으로 단정하지 않는다.

### 이미 포함되는 코드와 조건

1. BASE_DATA L378–383에서 `ZOVRADD_TM`을 분(`lv_min2`)으로 변환한다. L408·417에서 **평일 누적 `WEEKHR_MIN`에 가산**한다. L629에서 평일·휴일 합계를 만든다.
2. L632–635의 주석에는 2024-10-15 가산 제외, 2024-10-28 가산 포함으로 롤백한 이유가 적혀 있다. **`CWKHR_MIN = CWKHR_MIN - zovradd_sum`은 현재 주석이라 실행되지 않는다.** 주석의 변경 설명과 실제 주석 처리 상태를 함께 확인했다.
3. 모든 분기를 무조건 포함한다고 확대하지 않는다. L348–355의 소정 소진 분기, L387 이하의 평일/휴일·익일 분기에 따라 계산이 다르다. 소진후 L565–620에도 가산 관련 처리가 있으며 `lv_diff_min > 0` 조건을 사용한다. 이 변수의 경계일 상태와 평휴/휴평 분기는 재현 검증 대상이다.
4. `zovradd_sum`은 L383의 특정 분기에서 누적되고, 소진후 경로의 모든 가산 기여를 포괄하는 검증된 총계가 아니다. 이를 무조건 다시 더하거나, 전체 가산 합계라고 출력하는 변경은 피한다.
5. 조건을 단순화한 산식 예: 다른 근태·시차·휴일이 없고 소정 미소진인 평일 행에 실근로 5시간30분과 저장 가산 2시간30분이 있으면 해당 경로의 누적 기여는 8시간이다. 여기에 가산을 또 더하면 10시간30분으로 중복된다. 이는 코드 산식 예이며 SAP 재현 결과가 아니다.

근거: [ZHR_52TM_CW_BASE_DATA 원본](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Source%20code/ZHR_52TM_CW_BASE_DATA.abap) L348–441, 565–635.

### 어디를 어떻게 수정할지

| 확인 결과 | 조치/수정 후보 | 범위와 주의점 |
|---|---|---|
| 현재 추출본과 동일하고 `CS_ZSHR0144.CWKHR`에 가산이 포함됨 | 합산 코드를 추가하지 않는다. 화면 callback·사용중 페이지·배포본을 확인한다. | 현재 주요 callback은 이미 `CWKHR`를 그대로 표시한다. 변경 필요가 입증되지 않았다. |
| 저장 가산이 있는데 실제 응답이 가산을 제외함 | 우선 BASE_DATA의 해당 행 처리와 최종 값, `B_CW_GET_DATA` 변환 전후를 디버깅한다. | 운영본의 L635 대응 구문이 실행문인지 비교한다. 공통 BASE_DATA에서 차감만 없애는 방식도 한도 검사에 영향을 줄 수 있으므로 표시만 변경이라는 요구에는 바로 적용하지 않는다. |
| 표시만 기존 계산값과 다르게 만들어야 한다고 재현/정의가 확정됨 | 표시용 분 합계와 응답 필드를 추가하는 변경안: `ZSHR0137-CWKHR_DISP_MIN`(INT4), `ZSHR0144-CWKHR_DISP`(기존 형식과 같은 CHAR6). **이 이름들은 제안이며 현재 필드가 아니다.** | BASE_DATA의 기존 필드 산식은 유지하고 표시용 합계만 별도로 계산한다. F02 `B_CW_GET_DATA`에서 기존 `CONVERT_MIN_TO_HOUR2`로 새 필드에 변환한다. 사용자 화면의 `SP_TEXT5` 바인딩만 새 필드로 전환한다. |
| 저장된 `ZOVRADD_TM`이 0이거나 기간·상태 조건으로 행이 제외됨 | 가산 생성·저장·조회 필터를 원인 후보로 점검한다. 표시 코드에서 고정 2.5시간을 만들지 않는다. | 생성/저장 수정이나 과거 데이터 보정은 이번 요청과 별도 범위다. |

표시 전용 계산안은 **기존 누적 + 표시대상 가산 − 기존 누적에 이미 반영된 가산**이다. 대상 기간·상태·직원은 기존 조회와 같게 한다. ‘이미 반영된 가산’은 실제 가산 ADD 분기에서 따로 추적해야 하며 `SUM(ZOVRADD_TM)` 또는 기존 `zovradd_sum`으로 임의 대체하지 않는다. 소진후/익일 분기의 다른 근로시간 재가산 가능성까지 검증하기 전 이 수식을 완성 패치로 취급하지 않는다. 기존 적격 가산을 표시하는 제안이며 가산 생성 자격 자체의 확대는 포함하지 않는다.

새 표시 필드를 도입하면 기존 `CWKHR`, `CWKHR_MIN`, `WEEKHR_MIN`, `HOLIHR_MIN`은 그대로 두어 기존 소비자의 계산을 보존한다. DDIC 변경과 웹 배포 순서, 외부 AJAX 직렬화가 신규 필드를 전달하는지는 개발계에서 확인한다. SAP_BASIS 700 문법·활성화 의존 순서로 별도 구현 검토하며 여기서는 실행하지 않는다.

### 영향 지점과 보존할 계산

| 단계 | 확인한 연결 | 이번 범위의 처리 |
|---|---|---|
| 가산 산출 | [LZHR008_3F02](../sources/LZHR008_3F02.md) `D_CW_GET_DATA`: 5시간30분 이상·8시간 미만, 당번특근·당일·시작일 비휴일 조건 아래 8시간과의 차이를 계산한다. L383–384, 477–486. [ZHR_52TM_CW_SET_ITEM](../sources/ZHR_52TM_CW_SET_ITEM.md) L44–51이 결과를 실적 구조로 옮긴다. | 기존 가산 생성 기준 보존. 시차의 8시간 보정(L368–373)은 별도 경로이므로 가산으로 중복 합산하지 않는다. |
| 저장/익일 분리 | [LZHR008_3F03](../sources/LZHR008_3F03.md) L168–214, 286은 생성 결과를 저장한다. `MAKE_OVRNGT_DATA` L1320–1329는 둘째 행의 가산을 지운다. 수정시 L1180–1182도 대응한다. | ZTHR0112 갱신·과거 소급·익일 가산 복원은 수행하지 않는다. |
| 입력 한도 검사 | [LZHR008_3F01](../sources/LZHR008_3F01.md) `D_CW_CHECK_DATA` L414–424에서 BASE_DATA를 호출하고 L449–498에서 같은 `CWKHR_MIN`으로 소정/초과 판단을 한다. | BASE_DATA 기존 누적값 자체를 바꾸면 표시만의 변경이 아니다. 입력 허용/차단 결과는 회귀에서 동일해야 한다. |
| 특별연장 표시 | F02 L107–147이 `CWKHR`를 이용해 `N_ZEMCWK`를 만든다. | 기존 `CWKHR`를 덮어쓰지 않아 특별연장값까지 따라 변하지 않도록 한다. |
| 소정부족 안내 | 사용자 달력 L235–261이 `CWKHR - PWKHR`로 부족시간을 표시한다. | 새 필드를 SP_TEXT5에만 연결하면 기존 안내는 기존 값으로 남는다. 안내까지 일치시키는 것은 표시 항목 확대이므로 별도 결정한다. |
| 관리자/결재 화면 | [DAILY_WORK_MONTHLY_CONDITION_ADM](../sources/DAILY_WORK_MONTHLY_CONDITION_ADM.md), [DAILY_WORK_MONTHLY_CONDITION_MANAGER](../sources/DAILY_WORK_MONTHLY_CONDITION_MANAGER.md), [APP_DAILY_WORK_MONTHLY_CONDITION](../sources/APP_DAILY_WORK_MONTHLY_CONDITION.md)도 같은 응답 필드를 표시한다. | 공통 `CWKHR` 변경은 다른 화면까지 파급된다. 새 필드라면 사용자 화면에서만 소비하도록 제한할 수 있다. |
| 대휴/정산 | [ZHR_52TM_CW_CAL_AND_DAEH](../sources/ZHR_52TM_CW_CAL_AND_DAEH.md) L1944–1969의 `I_CASE=D`는 일별 리포트용 경로로 BASE_DATA를 호출하되 여기서는 소정 필드를 읽는다. [ZHR_52TM_CW_PAYMENT_WKPRD](../sources/ZHR_52TM_CW_PAYMENT_WKPRD.md) L90–95는 정산 함수의 `I_CASE=A`를 호출한다. | 두 경로를 동일한 표시 계산으로 합치지 않는다. 표시 변경에 정산 함수·대휴 생성·PA2010 재계산을 끼워 넣지 않는다. 전체 정산 분기 무영향을 실행 검증한 것은 아니다. |

### 과거 이력과 현재 코드의 구분

[SRC-07 후반 정리본](../../knowledge/feedback/SRC-07-late-SRC-08.md)의 2024-10-28 항목은 가산을 누적표시에 다시 더하라는 요청·완료 보고(SRC-07 L2196–2207)를 기록한다. 2025-01-16 항목은 누적/소정충족과 대휴 생성시간을 구분하고 연장수당 포함 여부는 미답변으로 남긴다(SRC-07 L2613–2636, L2660–2663). 현재 코드의 20241028 주석과 일치하는 정황이 있으나 이력·주석만으로 운영 반영을 증명하지 않는다.

현재 `sources/text/SRC-07.txt` 원문은 없어 이번 분석에서 원문 행을 다시 대조하지 못했다. 위 출처 번호·줄은 기존 정리본의 인용 위치다. 코드 사실은 추출 파일을 직접 확인했다. [초기 가산/리포트 이력](../../knowledge/feedback/SRC-09.md)의 2022-05-04 중복 합산과 2022-06-21~22 화면·확정값 불일치는 회귀 사례 선정 근거로만 사용한다.

### 검증 시나리오

아래는 수행할 개발계 검증 계획이다. SAP 실행 테스트를 통과했다는 뜻이 아니다. 모든 사례에서 저장된 가산·누적 원값·새 표시값·한도 메시지·대휴/정산 결과를 전후 대조한다.

| 사례 | 입력/전제 | 기대 결과/확인 사항 |
|---|---|---|
| 일반 가산 포함 | 소정 미소진 평일, 다른 근태/시차/휴일 없음, 실근로 5:30·유효 저장 가산 2:30 | 해당 행 기여 8:00, 이미 8:00이면 재가산하지 않는다. 위 실제 ADD 구문의 산식 예. |
| 가산 없음 | 동일 조건에서 가산 0 | 기존 누적과 새 표시값 동일. |
| 복수 행/익일 | 당번 첫 행에만 가산, 둘째 행 가산 0 | 가산을 한 번만 표시. 둘째 행에 고정 보충시간을 만들지 않는다. |
| 저장 전/후 | 입력 중인 행과 저장된 행 비교 | B 조회는 DB 기간행 기준이다. 저장 후 재조회와 일치하는지 확인한다. 미저장 미리보기까지 확대하지 않는다. |
| 상태 변화 | 미상신/결재중/승인/삭제/회수/반려, 같은 기간 | BASE_DATA의 기존 I_PAGE·STATE 필터를 그대로 따른다. B와 A/C의 집계 대상 차이를 버그로 단정하지 않는다. |
| 경계 | 소정 직전/당일 소진/소진후, 평휴·휴평, 기간 시작/끝 | 어떤 가산이 실제 반영됐는지 분 단위로 확인. 무조건 합산 기대값은 아직 확정하지 않는다. |
| 시차·간주·휴가 혼합 | TDCOST 보정 또는 9997 근태와 저장 가산 동시 존재 | 다른 인정시간·소정 차감은 원값 보존, 가산만 단 한 번 표시. |
| 208 경계/재난 | 기존 한도 근처와 재난 행 포함 기간 | 표시값 차이와 관계없이 기존 입력 차단/허용, N_ZEMCWK, 대휴·금액이 바뀌지 않는지 확인. |
| 화면 일치 | PC 달력/입력/수정/상세, 실제 사용 모바일 페이지 | 같은 기간·상태의 새 표시 필드 일치. 관리자/결재는 이번 적용 대상으로 자동 확대하지 않는다. |

### 협업 확인 초안과 남은 결정

운영/웹 담당자에게 전달할 분석 요청 초안: “익명 사례 SELECTIVE-DISPLAY-01의 선택기간과 조회일, 실제 메뉴·URL, I_CASE, 응답 CS_ZSHR0144.CWKHR, ZTHR0112의 날짜·상태·ZRLWK_TM·ZOVRADD_TM(직원 식별값은 제외), 활성 BASE_DATA의 최종 합계/가산 차감 여부를 비교해 주세요. 신규 표시 필드가 필요할 경우 공통 AJAX 직렬화/배포 버전도 확인해 주세요.” 이 초안은 전송하지 않았다.

필수 다음 확인은 실제 제외 사례의 계산 분기와 운영본 일치 여부다. 새 표시 정의가 기존 적격 가산 전체를 포함하는지, 소정 소진후에도 동일한지, 소정부족 안내까지 일치시킬지는 구현 전에 확정한다. 사용자가 확정한 것은 누적시간 표시만이라는 범위이며 지급·대휴 기준 변경이나 운영 배포 승인은 아니다.

[이번 검토의 파일 해시·근거 구간](../audit/selective-cumulative-display-review.json)에 확인 범위를 남겼다. 문서 링크 검사는 별도로 수행하며 실제 운영 계산 검증을 대신하지 않는다.

## 누적표시 롤백의 업무 의미

[선택근로 누적표시와 가산시간](../../knowledge/processes/selective-cumulative-display.md) — SRC-15, 2026-10-08 사용자 요청 반영. 2024-10-15에는 대휴 오해를 줄이려고 가산을 제외했으나, 10-28에는 소정을 못 채웠다는 오해가 더 커 가산 포함 표시로 롤백했다. 누적표시를 대휴 생성시간과 동일시하지 않는다. BASE_DATA L632–635의 주석·현재 차감식 비활성 상태 확인이며 운영 배포 검증은 아니다.

<!-- atlas:auto:start -->

## 전체 범위 단계 지도

[전체 업무 진행 상태](../PROGRESS.md) · [소스 설명 목차](../sources/INDEX.md)
대상자 등록, 사용자/관리자/모바일 실적, 승인, 누적조회, 기간 정산 및 월마감. 구 2022 매뉴얼·과거 협의안과 SRC-12/13 현행 정정을 구별한다.
**완료 범위:** 아래 단계의 지정 소스 구간·직접 관계 확인 및 탐색 연결. 전체 업무 규칙·모든 분기 검토 완료를 뜻하지 않는다. 적용 시점은 추출본이며 운영 반영일 미확인. 기존 문서에 있는 정책/과거 검토안의 구분을 유지한다.

| 단계 | 관련 설명 문서 | 관계의 의미 | 근거 파일·코드 위치 | 수준 |
|---|---|---|---|---|
| 대상자 관리 진입 | [ZRPTH410](../sources/ZRPTH410.md) · [ZRPTH410F01](../sources/ZRPTH410F01.md) | ZRPTH410이 F01을 포함한다. 조회·기간 생성·저장 세부는 F01의 해당 FORM과 DDIC 역링크를 따른다. | [ZRPTH410.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410/source/ZRPTH410.abap) L19 (Include) | 확인: 지정 구간의 정적 관계 |
| 화면 → 검사·조회·요청 | [DAILY_WORK_INPUT](../sources/DAILY_WORK_INPUT.md) · [ZHR_52TM_CW_CHECK_DATA](../sources/ZHR_52TM_CW_CHECK_DATA.md) · [ZHR_52TM_CW_GET_DATA](../sources/ZHR_52TM_CW_GET_DATA.md) · [ZHR_52TM_CW_PROCESS_DATA](../sources/ZHR_52TM_CW_PROCESS_DATA.md) | 일일 입력은 검사, 데이터 조회, 프로세스 요청으로 구분된다. | [DAILY_WORK_INPUT.htm](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT/Layout/DAILY_WORK_INPUT.htm) L710, 787, 921 (웹 요청) | 확인: 지정 구간의 정적 관계 |
| 등록·수정·상신·회수·삭제 | [ZHR_52TM_CW_PROCESS_DATA](../sources/ZHR_52TM_CW_PROCESS_DATA.md) · [LZHR008_3F03](../sources/LZHR008_3F03.md) · [ZHR_52TM_CW_PROCESS_DATA2](../sources/ZHR_52TM_CW_PROCESS_DATA2.md) · [ZTHR0112](../sources/ZTHR0112.md) · [ZWF0022](../sources/EXT-ZWF0022.md) | Z/R/S/C/U/E/D/A/B 분기에서 공통 F03 FORM으로 위임한다. DATA2는 A 이후 별도 직접 갱신도 있으므로 동일 함수로 합치지 않는다. | [ZHR_52TM_CW_PROCESS_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Source%20code/ZHR_52TM_CW_PROCESS_DATA.abap) L65, 72, 80, 87, 93, 97, 101 (FORM 호출)<br>[ZHR_52TM_CW_PROCESS_DATA2.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA2/Source%20code/ZHR_52TM_CW_PROCESS_DATA2.abap) L48, 53 (데이터 저장) | 확인: 지정 구간의 정적 관계 |
| 승인·반려 | [ZHR_52TM_DAILY_APPROVE_OT_DATA](../sources/ZHR_52TM_DAILY_APPROVE_OT_DATA.md) · [ZTHR0112](../sources/ZTHR0112.md) · [ZWF_APPROVE_WORK](../sources/EXT-ZWF_APPROVE_WORK.md) · [ZWF_REJECT_WORK](../sources/EXT-ZWF_REJECT_WORK.md) | 유효기간 확인 후 ZTHR0112 변경과 외부 WF 승인/반려. 원본 L124–213의 성공·실패 분기는 운영 결과가 아니다. | [ZHR_52TM_DAILY_APPROVE_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Source%20code/ZHR_52TM_DAILY_APPROVE_OT_DATA.abap) L169 (데이터 저장)<br>[ZHR_52TM_DAILY_APPROVE_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_APPROVE_OT_DATA/Source%20code/ZHR_52TM_DAILY_APPROVE_OT_DATA.abap) L180, 197 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 기간 정산·대휴 계산 | [ZHR_52TM_CW_PAYMENT_WKPRD](../sources/ZHR_52TM_CW_PAYMENT_WKPRD.md) · [ZHR_52TM_CW_CAL_AND_DAEH](../sources/ZHR_52TM_CW_CAL_AND_DAEH.md) | 기간 지급 계산이 실비·대휴 계산을 호출한다. | [ZHR_52TM_CW_PAYMENT_WKPRD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Source%20code/ZHR_52TM_CW_PAYMENT_WKPRD.abap) L90, 125 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 월 마감·확정·취소 | [ZRPTH411F01](../sources/ZRPTH411F01.md) · [ZHR_52TM_CW_PAYMENT_WKPRD](../sources/ZHR_52TM_CW_PAYMENT_WKPRD.md) · [ZTHR0160](../sources/ZTHR0160.md) · [PA2010](../sources/EXT-PA2010.md) | 마감 데이터 ZTHR0160와 PA2010 연결. 개별 산식·소급분 전체 분석 완료를 뜻하지 않는다. | [ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L36 (직접 호출)<br>[ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap) L553, 587, 737, 1231 (데이터 저장) | 확인: 지정 구간의 정적 관계 |
| 기간·누적·관리자 보고 | [ZRPTH413](../sources/ZRPTH413.md) · [ZRPTH440](../sources/ZRPTH440.md) · [ZHR_52TM_DAILY_WEEKLY_CUM](../sources/ZHR_52TM_DAILY_WEEKLY_CUM.md) · [DAILY_WORK_INPUT_ADM](../sources/DAILY_WORK_INPUT_ADM.md) · [MDAILY_WORK_INPUT](../sources/MDAILY_WORK_INPUT.md) | 계산/승인 데이터의 후속 조회라는 분석상 연관이다. 실행 순서를 자동화하는 직접 호출로 간주하지 않는다. | [ZRPTH413 원본](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413/source/ZRPTH413.abap) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[ZRPTH440 원본](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[ZHR_52TM_DAILY_WEEKLY_CUM 원본](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_DAILY_WEEKLY_CUM/Source%20code/ZHR_52TM_DAILY_WEEKLY_CUM.abap) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[DAILY_WORK_INPUT_ADM 원본](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/DAILY_WORK_INPUT_ADM/Layout/DAILY_WORK_INPUT_ADM.htm) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[MDAILY_WORK_INPUT 원본](../../exports/ZHR5/packages/ZHR5/BSP%20Application/WAPA/Z52_FLEX_TIME/pages/MDAILY_WORK_INPUT/Layout/MDAILY_WORK_INPUT.htm) — 파일 존재/헤더/정적 색인; 업무군 선정 | 분석상 연관·후보; 직접 호출 근거 아님 |

### 이 업무의 미추출·미검토 경계

CW_PROCESS_DATA와 DATA2의 호출 화면·버전 차이, 전체 일별 산식·휴일/간주/퇴직 경계, 동적 결재 중계와 실제 월마감 데이터는 미검증.
화면 요청/직접 호출/Include/타입 참조/데이터 조회·저장/분석상 연관을 구분했다. 화면이 없거나 중계기·함수가 미추출이면 연결을 그 지점에서 멈춘다. 저장은 승인·지급·배포 완료의 동의어가 아니다.

<!-- atlas:auto:end -->
