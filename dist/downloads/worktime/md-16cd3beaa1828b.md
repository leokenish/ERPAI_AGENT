---
title: "ZRPTH412F01 — ABAP 프로그램·독립 Include"
as_of: 2026-10-07
review_status: pending_business_review
tags: [시간외단가등급]
---

# ZRPTH412F01 — ABAP 프로그램·독립 Include

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 제목 메타데이터 없음; 이름만으로 업무를 확정하지 않음.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZRPTH412F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/attributes/ZRPTH412F01.xml) | 36행; 원본 보존 |
| [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) | 755행; 원본 보존 |
| [../texts/ZRPTH412F01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/texts/ZRPTH412F01.xml) | 16행; 원본 보존 |

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_check 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L268 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_graph 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L274 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_info 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L266 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_loc_append_row 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L252 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_loc_copy 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L270 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_loc_copy_row 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L248 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_loc_cut 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L258 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_loc_delete_row 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L250 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_loc_insert_row 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L254 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_loc_move_row 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L256 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_loc_paste 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L272 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_loc_paste_new_row 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L262 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_loc_undo 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L264 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_fc_refresh 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L260 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_style_disabled 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L521 |
| [CL_GUI_ALV_GRID](EXTERNAL_DEPENDENCIES.md#CL_GUI_ALV_GRID) | **클래스 참조** — mc_style_enabled 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L519 |
| [CL_GUI_CFW](EXTERNAL_DEPENDENCIES.md#CL_GUI_CFW) | **클래스 참조** — flush 정적 멤버 참조; 클래스 본문 미추출 여부 별도 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L479 |
| [DD07T](EXTERNAL_DEPENDENCIES.md#DD07T) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L22 |
| [F4IF_FIELD_VALUE_REQUEST](EXTERNAL_DEPENDENCIES.md#F4IF_FIELD_VALUE_REQUEST) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L388 |
| [PA0001](EXTERNAL_DEPENDENCIES.md#PA0001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L308, 542 |
| [PA0008](EXTERNAL_DEPENDENCIES.md#PA0008) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L322 |
| [POPUP_TO_CONFIRM](EXTERNAL_DEPENDENCIES.md#POPUP_TO_CONFIRM) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L590, 721 |
| [RH_DETERMINE_ORG_OBJID](EXTERNAL_DEPENDENCIES.md#RH_DETERMINE_ORG_OBJID) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L58 |
| [ZHR_GET_PERSONNEL_RANK](EXTERNAL_DEPENDENCIES.md#ZHR_GET_PERSONNEL_RANK) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L327 |
| [ZRPTH412F01](ZRPTH412F01.md) | **FORM 호출** — ALV_REFRESH: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap L466; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L458 |
| [ZRPTH412F01](ZRPTH412F01.md) | **FORM 호출** — APPEND_INIT_FIELDCAT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap L127; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L101 |
| [ZRPTH412F01](ZRPTH412F01.md) | **FORM 호출** — DIS_ENABLE_FIELD: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap L510; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L445, 561, 693 |
| [ZRPTH412F01](ZRPTH412F01.md) | **FORM 호출** — MODIFY_CELL: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap L492; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L314, 347 |
| [ZRPTH412F01](ZRPTH412F01.md) | **FORM 호출** — SET_DROPDOWN: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap L228; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L211 |
| [ZTHRBS05](EXT-ZTHRBS05.md) | **데이터 저장** — DELETE DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L749 |
| [ZTHRBS05](EXT-ZTHRBS05.md) | **데이터 저장** — MODIFY DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L689 |
| [ZTHRBS05](EXT-ZTHRBS05.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L542, 675 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [ZRPTH412](ZRPTH412.md) | FORM 호출 | [ZRPTH412.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412/source/ZRPTH412.abap) L26, 45, 48 |
| [ZRPTH412](ZRPTH412.md) | Include | [ZRPTH412.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412/source/ZRPTH412.abap) L19 |
| [ZRPTH412F01](ZRPTH412F01.md) | FORM 호출 | [ZRPTH412F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412F01/source/ZRPTH412F01.abap) L101, 211, 314, 347, 445, 458, 561, 693 |
| [ZRPTH412I01](ZRPTH412I01.md) | FORM 호출 | [ZRPTH412I01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412I01/source/ZRPTH412I01.abap) L28, 30, 32 |
| [ZRPTH412O01](ZRPTH412O01.md) | FORM 호출 | [ZRPTH412O01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412O01/source/ZRPTH412O01.abap) L63, 66, 69, 72, 75, 140 |
| [ZRPTH412TOP](ZRPTH412TOP.md) | FORM 호출 | [ZRPTH412TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH412TOP/source/ZRPTH412TOP.abap) L108, 112, 116, 120 |

### 관련 업무와 미확인 범위

- [rates](../topics/rates.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
