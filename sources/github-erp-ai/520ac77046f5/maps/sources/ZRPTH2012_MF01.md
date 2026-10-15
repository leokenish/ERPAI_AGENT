---
title: "ZRPTH2012_MF01 — 시간외 FI 연결"
as_of: 2026-10-07
review_status: pending_business_review
tags: [대휴익휴보상휴가, 월정산전표지급, 통상시차시간외]
---

# ZRPTH2012_MF01 — 시간외 FI 연결

[소스 설명 목차](INDEX.md) · [원본 파일](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap)

PA2010 조회와 전표 참조 갱신 일부만 관계 확인. 전표·은행 지급 전체 처리 완료는 미검증.

확인 수준: 표시한 소스 구간 정적 확인; 운영 실행 검증 아님. 원본 경로·파일은 그대로 유지한다.

## 근거 위치

| 위치 | 관계의 의미 | 근거 구문 |
|---|---|---|
| 57행 | 인포타입 조회 | `FROM pa2010 AS a INNER JOIN pa0000 AS b` |
| 365행 | 전표번호와 인포타입 후처리 연결 | `PERFORM update_pa2010 USING g_belnr.` |

## 관련 업무

<!-- topics -->
- [월정산·확정·전표·지급](../topics/settlement.md) — 이 소스를 검토하는 업무 지도.

<!-- atlas:auto:start -->

## 전체 정적 소스 색인

[소스 목차](INDEX.md) · [범위와 판정 기준](../COVERAGE.md)
종류: **ABAP 프로그램·독립 Include**. 설명: 제목 메타데이터 없음; 이름만으로 업무를 확정하지 않음.

검토 상태: **후보 — 본문/정의의 정적 관계 색인 완료, 전체 업무 의미·모든 분기는 미검토**. 업무 지도에서 수동 확인한 구간은 별도로 표시한다. 추출본의 구문 존재는 운영 실행·배포·현행 기준을 증명하지 않는다.

### 원본과 구성 파일

| 원본 | 역할·위치 |
|---|---|
| [../attributes/ZRPTH2012_MF01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/attributes/ZRPTH2012_MF01.xml) | 36행; 원본 보존 |
| [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) | 1612행; 원본 보존 |
| [../texts/ZRPTH2012_MF01.xml](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/texts/ZRPTH2012_MF01.xml) | 16행; 원본 보존 |

### 이번 업무 구간 검토

파일 판정: **후보**. 검토 범위: POST/REV/RSAVE/EDI 명령 분기, 전표 함수 요청·반환, AWREF 갱신, EDI 입력·외부 요청; L315–432, L865–905, L1201–1247, L1310–1408. 남은 범위: 이외 본문/모든 예외 분기 미검토; 운영 실행 미확인. 이는 이 파일/명시한 구간의 정적 분석이며 외부 함수·업무 전체·운영 검증 완료는 아니다.

### 나가는 관계

관계 종류와 원본 위치를 함께 읽는다. 아래는 주석을 제외한 정적 구문 색인이다. 모든 제어 흐름과 동적 호출을 해결한 그래프는 아니다.

| 대상 설명 | 관계 종류·의미 | 근거 파일·위치 |
|---|---|---|
| [HR_INITIALIZE_BUFFER](EXTERNAL_DEPENDENCIES.md#HR_INITIALIZE_BUFFER) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L936 |
| [HR_PSBUFFER_INITIALIZE](EXTERNAL_DEPENDENCIES.md#HR_PSBUFFER_INITIALIZE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L937, 1058 |
| [PA0000](EXTERNAL_DEPENDENCIES.md#PA0000) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L57 |
| [PA0001](EXTERNAL_DEPENDENCIES.md#PA0001) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L75, 185, 1469 |
| [PA0009](EXTERNAL_DEPENDENCIES.md#PA0009) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L1323 |
| [PA0015](EXTERNAL_DEPENDENCIES.md#PA0015) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L169, 1430 |
| [PA0267](EXTERNAL_DEPENDENCIES.md#PA0267) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L157, 1420 |
| [PA2010](EXT-PA2010.md) | **데이터 저장** — UPDATE DB 이름 구문; 내부 테이블 동일명·분기·커밋은 원문 확인 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L1223 |
| [PA2010](EXT-PA2010.md) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L57, 1409 |
| [POPUP_TO_CONFIRM](EXTERNAL_DEPENDENCIES.md#POPUP_TO_CONFIRM) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L754 |
| [REUSE_ALV_COMMENTARY_WRITE](EXTERNAL_DEPENDENCIES.md#REUSE_ALV_COMMENTARY_WRITE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L337 |
| [REUSE_ALV_FIELDCATALOG_MERGE](EXTERNAL_DEPENDENCIES.md#REUSE_ALV_FIELDCATALOG_MERGE) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L488 |
| [REUSE_ALV_GRID_DISPLAY](EXTERNAL_DEPENDENCIES.md#REUSE_ALV_GRID_DISPLAY) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L723 |
| [SAPGUI_PROGRESS_INDICATOR](EXTERNAL_DEPENDENCIES.md#SAPGUI_PROGRESS_INDICATOR) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L1589 |
| [T512T](EXTERNAL_DEPENDENCIES.md#T512T) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L590 |
| [T527X](EXTERNAL_DEPENDENCIES.md#T527X) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L246 |
| [ZBDC](EXT-ZBDC.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L882 |
| [ZFI_FIRM_REQUEST_EDI](EXT-ZFI_FIRM_REQUEST_EDI.md) | **직접 호출** — 정적 함수 이름; 호출 대상 내부·실행 결과는 별도 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L1369 |
| [ZRPTH2012_MF01](ZRPTH2012_MF01.md) | **FORM 호출** — ALV_DISPLAY: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap L721; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L279 |
| [ZRPTH2012_MF01](ZRPTH2012_MF01.md) | **FORM 호출** — ALV_EVENTS: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap L698; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L276 |
| [ZRPTH2012_MF01](ZRPTH2012_MF01.md) | **FORM 호출** — ALV_FIELDCAT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap L479; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L267 |
| [ZRPTH2012_MF01](ZRPTH2012_MF01.md) | **FORM 호출** — ALV_LAYOUT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap L462; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L264 |
| [ZRPTH2012_MF01](ZRPTH2012_MF01.md) | **FORM 호출** — BUILD_COMMENT: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap L578; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L270 |
| [ZRPTH2012_MF01](ZRPTH2012_MF01.md) | **FORM 호출** — GET_ORGTX: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap L240; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L88, 193, 1478 |
| [ZRPTH2012_MF01](ZRPTH2012_MF01.md) | **FORM 호출** — OPERATION_0015: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap L1084; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L1067 |
| [ZRPTH2012_MF01](ZRPTH2012_MF01.md) | **FORM 호출** — OPERATION_0267: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap L960; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L945 |
| [ZRPTH2012_MF01](ZRPTH2012_MF01.md) | **FORM 호출** — POPUP_CONFIRM: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap L750; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L356, 386 |
| [ZRPTH2012_MF01](ZRPTH2012_MF01.md) | **FORM 호출** — PROCESS_0015: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap L1021; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L376, 406, 1183 |
| [ZRPTH2012_MF01](ZRPTH2012_MF01.md) | **FORM 호출** — PROCESS_0267: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap L918; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L374, 404, 1181 |
| [ZRPTH2012_MF01](ZRPTH2012_MF01.md) | **FORM 호출** — PROCESS_BDC: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap L783; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L363 |
| [ZRPTH2012_MF01](ZRPTH2012_MF01.md) | **FORM 호출** — PROCESS_EDI: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap L1293; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L424 |
| [ZRPTH2012_MF01](ZRPTH2012_MF01.md) | **FORM 호출** — PROCESS_REVERSE: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap L1145; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L392 |
| [ZRPTH2012_MF01](ZRPTH2012_MF01.md) | **FORM 호출** — PROGRESS: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap L1600; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L933, 1054 |
| [ZRPTH2012_MF01](ZRPTH2012_MF01.md) | **FORM 호출** — SAPGUI_PROGRESS: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap L1586; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L1608 |
| [ZRPTH2012_MF01](ZRPTH2012_MF01.md) | **FORM 호출** — SORT_FIELD: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap L669; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L273 |
| [ZRPTH2012_MF01](ZRPTH2012_MF01.md) | **FORM 호출** — UPDATE_PA2010: 정의 exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap L1204; 포함 범위 내 이름 일치, 동적 해석 제외 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L365, 1178 |
| [ZTF_FIRM_EDI](EXTERNAL_DEPENDENCIES.md#ZTF_FIRM_EDI) | **데이터 조회** — SELECT의 FROM/JOIN 대상; 조건·조회 결과 별도 검토 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L1554 |

### 들어오는 관계

다른 소스가 이 객체를 참조하는 위치다. 데이터 객체에서 이 표를 이용해 생산자·소비자·후속 처리를 탐색한다. 두 소스가 같은 테이블을 쓴다고 자동 실행 순서가 성립하지는 않는다.

| 참조 소스 | 관계 종류 | 근거 파일·위치 |
|---|---|---|
| [ZRPTH2012_M](ZRPTH2012_M.md) | FORM 호출 | [ZRPTH2012_M.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_M/source/ZRPTH2012_M.abap) L30, 35, 41, 50, 55, 58, 61, 77 |
| [ZRPTH2012_M](ZRPTH2012_M.md) | Include | [ZRPTH2012_M.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_M/source/ZRPTH2012_M.abap) L24 |
| [ZRPTH2012_MF01](ZRPTH2012_MF01.md) | FORM 호출 | [ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) L88, 193, 264, 267, 270, 273, 276, 279, 356, 363, 365, 374, 376, 386, 392, 404, 406, 424, 933, 945, 1054, 1067, 1178, 1181, 1183, 1478, 1608 |

### 관련 업무와 미확인 범위

- [rest](../topics/rest.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
- [settlement](../topics/settlement.md) — 업무 지도에서 지정 구간과 단계 의미를 확인한다.
정적 색인은 후보 누락을 줄이는 탐색 자료다. 전체 계산 분기·권한·커밋 경계·정책 적합성·실제 실행·잡과 활성 버전은 검증하지 않았다.

<!-- atlas:auto:end -->
