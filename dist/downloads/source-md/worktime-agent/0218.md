---
title: "MZH432F01 — ABAP 프로그램·독립 Include"
as_of: 2026-10-07
review_status: pending_business_review
tags: [시차근무대상자관리, 인사정보형9021_9023]
---

# MZH432F01 — ABAP 프로그램·독립 Include

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 제목 메타데이터 없음; 이름만으로 업무를 확정하지 않음.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/MZH432F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/attributes/MZH432F01.xml) | 36행; 원본 보존 |
| [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) | 676행; 원본 보존 |
| [../texts/MZH432F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/texts/MZH432F01.xml) | 9행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — MC_FC_LOC_APPEND_ROW 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L204 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_evt_modified 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L264 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_graph 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L216 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_help 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L188 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_info 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L190 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_loc_copy 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L192 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_loc_copy_row 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L194 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_loc_cut 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L196 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_loc_delete_row 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L198 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_loc_move_row 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L202 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_loc_paste 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L206 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_loc_paste_new_row 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L208 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_loc_undo 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L186 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_print 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L214 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_refresh 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L210 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_subtot 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L222 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_word_processor 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L212 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_mb_sum 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L223 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_style_disabled 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L77 |
| [MZH432F01](MZH432F01.md) | **FORM 호출** — GET_DATA: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap L23; 포함 범위 내 이름 일치, 동적 해석 제외 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L674 |
| [MZH432F01](MZH432F01.md) | **FORM 호출** — GET_ENAME: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap L389; 포함 범위 내 이름 일치, 동적 해석 제외 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L52, 82, 458 |
| [MZH432F01](MZH432F01.md) | **FORM 호출** — GET_VDSK1TXT_ZORDER: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap L374; 포함 범위 내 이름 일치, 동적 해석 제외 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L86, 462 |
| [MZH432F01](MZH432F01.md) | **FORM 호출** — REFRESH_LIST: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap L359; 포함 범위 내 이름 일치, 동적 해석 제외 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L471, 675 |
| [PA0001](EXTERNAL_DEPENDENCIES.md#PA0001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L396 |
| [PA9023](PA9023.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L45 |
| [POPUP_TO_CONFIRM](EXTERNAL_DEPENDENCIES.md#POPUP_TO_CONFIRM) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L613 |
| [RH_OBJID_REQUEST](EXTERNAL_DEPENDENCIES.md#RH_OBJID_REQUEST) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L532 |
| [ZHR_52TM_WKTYPE](ZHR_52TM_WKTYPE.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L412 |
| [ZTH0500](EXTERNAL_DEPENDENCIES.md#ZTH0500) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L380 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [MZH432F01](MZH432F01.md) | FORM 호출 | [MZH432F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432F01/source/MZH432F01.abap) L52, 82, 86, 458, 462, 471, 674, 675 |
| [MZH432I01](MZH432I01.md) | FORM 호출 | [MZH432I01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432I01/source/MZH432I01.abap) L49, 67, 68, 96, 146, 147, 177, 219, 220, 319, 403, 404 |
| [MZH432O01](MZH432O01.md) | FORM 호출 | [MZH432O01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432O01/source/MZH432O01.abap) L26, 28, 30, 32, 34, 36, 38, 40, 42 |
| [MZH432TOP](MZH432TOP.md) | FORM 호출 | [MZH432TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432TOP/source/MZH432TOP.abap) L317, 357, 365 |
| [SAPMZH432](SAPMZH432.md) | Include | [SAPMZH432.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/SAPMZH432/source/SAPMZH432.abap) L20 |

### 관련 업무와 미확인 범위

- [staggered-admin](../topics/staggered-admin.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
