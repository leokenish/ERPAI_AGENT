# 실제 사례: WebGUI 개선과 검증

## 디자인에서 데이터 보존까지

WebGUI의 가독성과 스크롤 동작을 개선하고 기존 업무 기능을 보존하는 사례입니다. 우선순위는 **업무·데이터 → 호환성 → 조작 → 디자인 → 성능**입니다.

기존 Chrome v3와 새 Modern V2의 산출물·검증 기록을 함께 살펴봅니다. SAP 운영 환경의 전체 검증은 추가 확인 대상입니다.

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

## 추가 사례: ITS 반영 도구는 아직 검토 단계

웹 자산과 `.sapxml`을 ALV에서 비교하고 선택 객체를 저장·활성화하는 도구를 검토했습니다. **ITS 쓰기 도구는 검토 단계**, 기존 DIAG 0.4.5는 읽기 전용입니다.

| 검토 항목 | 확인할 이유 |
|---|---|
| 파일명과 MIME 내부 키 | 표시 이름과 실제 저장 키 대조 |
| MIME와 HTMLBusiness 템플릿 | 유형별 저장·언어·활성화·발행 경로 확인 |
| 추출기와 메타데이터 스키마 | DEVHUB export와 ITS source export의 구조 대조 |
| 백업·잠금·권한·CTS | 반영 전 권한·잠금·이관·복구 절차 확인 |
| 작은 CSS 1개 시범 | 대상 조회·차이·저장·되읽기·복구를 검증한 뒤 범위를 확대 |

추출기 0.1.7 사용 여부는 미확정입니다. SAP 700 API와 저장·활성화·발행·복구 절차를 먼저 검증합니다.

[ITS 도구 검토 전문 읽기](#/conversations/kbs-erp-webgui-refactor/wg-modern-04)

## 근거

- `sources/webgui/01_프로젝트_맥락과설계.md` §5·7·10·13
- `sources/webgui/references/ITS_Chrome_v3_Report.md`
- `sources/webgui/references/v3_evidence/validation.json`
- `sources/conversations/20261016-business/kbs-erp-webgui-refactor/webgui-transcript.md`
