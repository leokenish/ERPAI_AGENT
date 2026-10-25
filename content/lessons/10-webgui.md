# 실제 사례: WebGUI 개선과 검증

## 디자인에서 데이터 보존까지

WebGUI의 가독성과 스크롤 동작을 개선하고 기존 업무 기능을 보존하는 사례입니다. 우선순위는 **업무·데이터 → 호환성 → 조작 → 디자인 → 성능**입니다.

Chrome v3·Modern V2부터 ITS 실제 적용 보고, 재추출 V3와 결재 본문 렌더러 설계까지 살펴봅니다. SAP 운영 환경의 전체 검증은 추가 확인 대상입니다.

## 최신 흐름: 실제 증상에서 V429까지

후속 대화는 설정 API 응답부터 결재 렌더러, 다운로드, 팝업·스크롤까지 **66개 요청 구간**을 이어갑니다. 기존과 겹친 앞 27개 구간은 중복 수록하지 않았습니다. 현재 전달 기준은 **V429, UI 4.2.6, 결재 렌더러 1.4.5**입니다.

| 흐름 | 새로 확인한 근거 | 남은 경계 |
|---|---|---|
| 설정과 결재 본문 | `ET_CONFIG`, 실제 필드·응답·DOM·이벤트에 맞춰 수정. 사용자가 새 결재 본문을 확인한 사례 | 특정 화면 성공을 모든 결재 양식 성공으로 확대하지 않음 |
| Excel 다운로드 | 초기 unload 가설에서 실제 Applet 경로 근거로 진단 정정. 한 메뉴에서 사용자 다운로드 성공 | 모든 메뉴·형식·파일 내용 전수 검증은 미확인 |
| 팝업과 스크롤 | 재현 화면·위치·버전으로 조건을 좁혀 수정 | 최신 V429의 SAP 재시험·최종 사용자 수용은 미확인 |
| 전달물 | V428 기준 두 파일 변경 ZIP, 원복 ZIP, 검토 ZIP과 README 확보 | 전체 소스와 변경분을 혼동하지 않고 적용 기준을 확인 |

[후속 설정 API 대화부터 읽기](#/conversations/kbs-erp-webgui-refactor/wg-progress-approval-api-observed)

관련 자료의 이미지와 코드는 실제 공유 화면에서 확보했습니다. AI의 로컬 검사 보고, 사용자의 특정 동작 확인, 아직 시험하지 않은 최신 수정본을 구분해 읽습니다. 프로젝트 MD 네 개는 이번 업로드와 기존 수록본의 바이트가 같아 그대로 유지했습니다.

## 사례 1: 스크롤하면 자원이 다시 보인다

Fetch/XHR가 비어 있어도 Network의 Doc 요청에 업무 POST와 HTML 응답이 있을 수 있습니다. 캐시에서 읽은 JS·CSS, 작은 보조 문서, 실제 업무 문서 요청을 구분해야 합니다.

Network 관측 시간과 모형 타이머 시간은 각각 기록합니다. ABAP 실행 시간과 전체 체감 성능은 실제 환경에서 측정합니다.

## 사례 2: 중복 콜백을 제거한다

기본 wheelDelay 700ms의 모형에서 기존 코드는 같은 위치에 350ms와 700ms 두 콜백을 남겼습니다. v3는 휠 경로의 내부 중복 예약을 정리해 700ms 한 번을 남깁니다. 화살표의 350ms 처리와 로컬 스크롤은 별도입니다.

모형에서는 콜백이 2회에서 1회로 줄었습니다. 실제 POST 횟수와 체감 속도는 운영 환경에서 측정합니다.

## 사례 3: 화면보다 중요한 제출 값

0과 false가 빈 값으로 바뀌거나, 잘못된 파라미터 일부만 제출되면 업무 결과가 달라질 수 있습니다. 메뉴 제출 중 예외가 나도 원래 폼의 target·action·event가 복원되는지 확인합니다.

| 보존할 계약 | 점검 내용 |
|---|---|
| 값 | 0·false·한글·특수문자 |
| 이벤트 | 인수·호출 순서·동기 의미 |
| 폼 | 필드명·인코딩·예외 후 복원 |
| 화면 | ID·name·DOCTYPE·기존 배치 |
| 세션 | 종료와 UI 객체 정리의 구분 |

## 패키지 이름을 정확히 읽기

| 파일 | 의미 |
|---|---|
| Original | 확보 원본 100개 |
| Rollback | v3 직전 비교 기준 100개 |
| Full | v3 변경이 반영된 전체 100개 |
| Apply | 직전 기준 대비 변경분 33개 |
| Evidence | diff·검증 코드·시험 기록 |

서버 반영 전 실제 응답 파일과 기준본을 대조하고, 적용 순서와 서버 백업을 확인합니다.

## 따라 하기: 검증 범위 설명하기

v3 보고서에서 모형 시험 186건의 검사 항목을 확인합니다. 운영 환경에서는 휠·화살표·ALV·팝업·한글 IME·폼 제출·세션 유지를 시험합니다.

## 추가 사례: CSS 개선에서 Modern V2로

ECC 6.0·SAP_BASIS 700의 WEBGUI·SYSTEM 기능과 파일·함수 이름을 유지하는 디자인 개편입니다. CSS 21개에서 시작해 JS 메뉴 위치, 툴바·폰트, HTMLBusiness 템플릿과 아이콘으로 범위를 넓혔습니다.

| 계열 | 대상 | 검증을 읽는 기준 |
|---|---|---|
| 기존 ITS Chrome v3 | 100개 소스, 직전 기준 대비 변경 33개 | 기존 정적·모의 시험 기록 |
| 새 Modern V1 | CSS 중심 디자인 개선 | 실제 SAP 실행 캡처와 재구성 비교 화면 구분 |
| 새 Modern V2 | CSS 21·JS 6·HTMLBusiness 10·GIF 75, 총 112개 객체 | 원 대화의 AI가 정적 20개·로컬 Chromium 25개 검사 보고 |

Modern V2는 112개 객체(MIME 102·템플릿 10)이며 메타데이터 XML을 포함하면 224개 파일입니다. Chrome v3와는 별도 산출물로 관리합니다.

정적 20개·로컬 Chromium 25개 검사는 원 대화의 AI 보고입니다. SAP 운영 서버와 Windows 브라우저의 업무 전 구간 검증은 추가 확인 대상입니다.

[Modern V1부터 대화 전문 읽기](#/conversations/kbs-erp-webgui-refactor/wg-modern-01) · [Modern V2 객체와 검증 범위](#/conversations/kbs-erp-webgui-refactor/wg-modern-03)

## 초기 검토: ITS 반영 도구의 범위

웹 자산과 `.sapxml`을 ALV에서 비교하고 선택 객체를 저장·활성화하는 도구를 검토했습니다. 초기 대화에서 **ITS 쓰기 도구는 검토 단계**였습니다. 이후 구현·실행 보고는 아래 최신 흐름에서 이어집니다. 기존 DIAG 0.4.5는 읽기 전용입니다.

| 검토 항목 | 확인할 이유 |
|---|---|
| 파일명과 MIME 내부 키 | 표시 이름과 실제 저장 키 대조 |
| MIME와 HTMLBusiness 템플릿 | 유형별 저장·언어·활성화·발행 경로 확인 |
| 추출기와 메타데이터 스키마 | DEVHUB export와 ITS source export의 구조 대조 |
| 백업·잠금·권한·CTS | 반영 전 권한·잠금·이관·복구 절차 확인 |
| 작은 CSS 1개 시범 | 대상 조회·차이·저장·되읽기·복구를 검증한 뒤 범위를 확대 |

추출기 0.1.7 사용 여부는 미확정입니다. SAP 700 API와 저장·활성화·발행·복구 절차를 먼저 검증합니다.

[ITS 도구 검토 전문 읽기](#/conversations/kbs-erp-webgui-refactor/wg-modern-04)

## 이전 흐름: ITS 적용 결과에서 결재 본문 설계까지

2026-10-17 공유 대화에서 후속 요청·응답 20쌍을 추가했습니다. 기존 Chrome v3, Modern V2, 적용 후 재추출한 **WebGUI V3**를 구분해 읽습니다.

| 단계 | 대화에서 확인한 내용 | 현재 읽는 기준 |
|---|---|---|
| ITS 도구 1.0.1~1.0.5 | DO 문법·RTTI 반환 인자·ERROR_MESSAGE·게시 API 문제 수정 | 반복 실패를 공통 코드와 실제 API 선언으로 좁혀갑니다. |
| 1.0.6 첫 적용 | 사용자가 GUI_CUA.JS의 SE80 변경 확인 보고 | 당시 AI는 저장·INTERNAL 게시·D/P 일치를 보고했습니다. |
| 전체 선택 | 26개 서버 고유 변경으로 저장 전 차단 | 파일 선택과 덮어쓰기 허용은 별도 조건입니다. |
| 107번 템플릿 | 당시 AI가 106개 완료·107번 저장 후 D 불일치·이후 미처리 보고 | 1.0.8 보정·1.0.9 권한 인자 수정의 SAP 재시험은 추가 확인 대상입니다. |
| 재추출 V3 | CSS 9·JS 7·HTML 템플릿 3, 총 19개 교체안 | 로컬 검사 보고와 SAP 업무 검증을 구분합니다. |
| 결재 본문 | WRITE 목록 판별·변환, 설정 테이블·RFC·JSON 파싱 | 테이블 생성 보고를 확보했으며 공통 렌더러와 RFC 전체 동작은 검증 전입니다. |

[새 ITS 구현·오류 수정 대화](#/conversations/kbs-erp-webgui-refactor/wg-apply-01) · [첫 파일 적용과 CTS](#/conversations/kbs-erp-webgui-refactor/wg-apply-03) · [전체 선택·107번 오류](#/conversations/kbs-erp-webgui-refactor/wg-apply-04)

### 결과를 읽는 순서

**비교 → 저장 → INTERNAL 게시 → 저장본(D)·게시본(P) 재조회 → 실제 업무 동작** 순서로 확인합니다. 초록 신호등과 화면의 업무 정상 동작은 각각 검증합니다.

![일괄 반영 중 나타난 로그온 언어 유지보수 선택창](assets/conversations/kbs-erp-webgui-refactor/webgui-next-image-018-1.png)

원 대화의 `WEBGUI 업로드 결과.xlsx`, `_v2.xlsx`, `_v3.xlsx`, `_v4.xlsx`, `result (2).xlsx`, `result2.xlsx`는 파일명과 분석 대화를 확인했습니다. **엑셀 원본 6개는 다운로드 미확보**입니다. 아래 학습 대화에서는 당시 분석 전문과 실제 확보한 이미지를 볼 수 있습니다.

### 재추출본을 기준으로 만든 V3

적용 이후 다시 추출한 WEBGUI·SYSTEM과 이슈 기록을 기준으로 툴바, 대기 배경, 팝업·F4, 표·트리 폭, 스크롤, 탭 표시를 수정한 사례입니다. 대화에는 19개 교체안, S-Core 글꼴, 104종 벡터 아이콘 표현이 보고되어 있습니다.

브라우저 34개·정적 17개·패키지 12개 검사는 **당시 AI의 검사 보고**입니다. 이전 수록 시점에는 ZIP을 수집하지 않았으며, 실제 SAP 업무·Windows Chrome/Edge의 후속 검증은 남아 있습니다.

[재추출 V3 대화 전문](#/conversations/kbs-erp-webgui-refactor/wg-v3-review)

### 결재 화면을 판별하고 본문만 다시 구성하기

WRITE 보고서에서 결재 대상과 양식 구조를 확인한 뒤 새 본문을 표시하는 설계입니다. 제목·결재선·자산 항목을 재구성하면서 원래 목록의 ID·행·열·커서·더블클릭과 승인·반려 동작을 연결합니다.

![사용자가 제공한 결재 화면 비교 자료 1](assets/conversations/kbs-erp-webgui-refactor/webgui-next-image-021-1.png)

![사용자가 제공한 결재 화면 비교 자료 2](assets/conversations/kbs-erp-webgui-refactor/webgui-next-image-021-2.png)

| 구성 | 역할 |
|---|---|
| ZWGUI_APPR_CFG | TCODE·RULE_ID·MODE·PROFILE_ID·PROFILE_VER로 대상과 양식 관리 |
| OFF | 기존 화면 사용 |
| TEST | 구조·누락·동작 연결 검사, 원래 본문 유지 |
| ON | 판별·검증을 통과한 본문에 새 양식 적용 |
| RFC 조회 | 설정을 내부 테이블로 반환하고 기존 시스템에서 JSON 배열 변환 |
| POST input | function_name·tcode를 JSON 문자열로 묶어 폼 필드로 전달 |
| JSON 파서 | 평면 객체의 키·값을 파라미터 테이블로 변환하는 별도 함수 제안 |

![사용자가 생성했다고 보고한 ZWGUI_APPR_CFG 테이블 첨부](assets/conversations/kbs-erp-webgui-refactor/webgui-next-image-025-1.png)

[대상 판별과 기능 보존](#/conversations/kbs-erp-webgui-refactor/wg-approval-01) · [설정 테이블](#/conversations/kbs-erp-webgui-refactor/wg-approval-02) · [RFC·POST·JSON 전문](#/conversations/kbs-erp-webgui-refactor/wg-approval-03)


## 근거

- `sources/webgui/01_프로젝트_맥락과설계.md` §5·7·10·13
- `sources/webgui/references/ITS_Chrome_v3_Report.md`
- `sources/webgui/references/v3_evidence/validation.json`
- `sources/conversations/20261016-business/kbs-erp-webgui-refactor/webgui-transcript.md`

- [2026-10-17 추가 공유 대화](https://chatgpt.com/share/e/6ad30b87-ece4-8004-8229-5c974ed47060) · 보존 경로 `sources/conversations/20261017-webgui/`
