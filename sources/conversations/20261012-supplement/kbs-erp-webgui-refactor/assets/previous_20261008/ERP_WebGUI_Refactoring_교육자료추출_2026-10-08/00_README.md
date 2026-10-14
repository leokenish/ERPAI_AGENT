# ERP WebGUI·SYSTEMGUI 리팩토링 — 교육자료 안내

- 프로젝트: KBS ERP WebGUI·SYSTEMGUI HTML·JavaScript·CSS 리팩토링
- 대화 주제: 디자인 보존형 개선, 스크롤 지연 분석, Chrome 오류 대응, 통합 리팩토링
- 정리 기준일: **2026-10-08**
- 추출물 성격: ERP AI 에이전트 교육 포털에 통합할 **원천 자료 묶음**. 웹사이트나 배포 완료본이 아니다.

## 1. 목적과 현재 상태

이 프로젝트는 SAP ITS/WebGUI의 기존 업무 기능과 데이터 처리 계약을 유지하면서 화면 가독성, 브라우저 호환 오류, 불필요한 클라이언트 연산을 개선한 사례다. 사용자가 Google Drive에 제공한 WEBGUI·SYSTEMGUI 소스, 실행 후 피드백과 DevTools 관찰을 바탕으로 AI가 소스를 분석·수정하고 검토용 파일을 제공했다.

현재 확보한 통합 산출물은 **2026-09-14 작성 Chrome v3**다. WEBGUI 67개와 SYSTEMGUI 33개, 총 100개(JS 47·CSS 34·HTML 19)를 포함하며 직전 기준본 대비 33개(HTML 14·JS 16·CSS 3)를 수정했다. v3의 구현·정적 검사·모의 회귀 기록은 있지만, **실제 Chrome 및 SAP 업무 화면의 v3 검증·운영 승인 기록은 없다**. 초기 WEBGUI 개편본에 대한 사용자의 “동작이 이상은 없는 것 같다”는 피드백을 v3 검증 완료로 확대 해석하지 않는다. [S01, S02, C02: 아래 출처 안내]

이번 추출에서는 기존 소스를 수정하거나 새 패치를 만들지 않았다. 운영 ERP, 서버 설치, GitHub push, 포털 구현도 수행하지 않았다.

## 2. 실제 확인한 범위

| 범위 | 이번에 확인한 내용 | 확인 수준 |
|---|---|---|
| 현재 대화 및 전달된 이전 대화 발췌 | 사용자 요구·피드백·오류·Network 해석·Chrome 우선순위·contextmenubase 재동기화 요청 | 보이는 대화 원문/발췌. 대화 전체 내보내기는 아님 |
| 보고서 3개 | Chrome v3, SYSTEMGUI 1차, 화살표 오류 보고서 | 전문을 읽고 교육 문서에 반영 |
| v3 ZIP 5개 | Full·Apply·Rollback·Original·Evidence | 실제 확보, ZIP 구성·CRC·해시·전후 소스 대응 검사 |
| v3 소스 100개와 3개 버전 | original·baseline·modified | 전체 바이트를 확보·자동 대조. 핵심 변경 부분은 본문/차이 검토. 모든 함수를 새로 재감사한 것은 아님 |
| 검증 기록·검증 코드 | validation·markup·inline·integration·manifest·diff·실행 설명 | 기록을 읽음. 이번 추출에서 과거 회귀 스위트를 다시 실행한 것으로 표기하지 않음 |
| Drive WEBGUI·SYSTEMGUI | 현재 대상 100개 이름·크기·수정 시각, contextmenubase 본문 | 100개 이름·크기가 보관 원본과 일치. 나머지 99개는 재다운로드·해시 대조하지 않음 |
| 오류 PNG 1개 | unload 정책 메시지, dropdown 미정의, createTextRange 오류 | 실제 이미지 열람. URL 식별자 노출 방지를 위해 ZIP에는 제외 |

출처 ID는 [대화·자료 근거 목록](references/대화와자료_근거목록.md)에 정의한다. 날짜가 표시되지 않은 대화는 임의로 날짜를 붙이지 않고 C01 등의 순서 ID로 인용한다. 보고서 작성일·Drive 수정 시각과 대화 발생일은 다른 정보다.

## 3. 최신 여부와 누락 범위

“최신”은 **이번에 확보한 이 프로젝트의 산출물 중 v3가 통합 기준이라는 뜻**이다. 운영 서버의 최신 배포본이라는 의미가 아니다. Drive 현재 목록의 가장 최근 수정 시각은 `2026-09-14T01:03:35.271Z`이며 contextmenubase 원본은 736바이트다. v3 수정본은 주석 등을 반영한 891바이트다. 이름·크기 일치만으로 Drive 100개 전체의 내용 동일성을 보장하지 않는다. [S05, S02/manifest]

확인하지 못한 범위:

- 다른 ERP AI 대화방 전체, 이 대화 이전의 생략된 구간과 완전한 원문 로그
- 실제 SAP 업무 문서 Response HTML, 스크롤 명령을 생성한 서버 코드, 운영 배포 파일
- 기존 Network 캡처 원본 전체 및 HAR·Performance trace. 수치는 전달된 대화의 판독 기록이며 이번에 재측정하지 않음
- SAP/ITS 릴리스·패치 수준, 운영 Chrome 정확한 버전, 프레임 출처 구성과 서버 캐시 설정
- `ITSSM_unload` 구현, IAC generator/splitter 리소스, 이미지 원본
- 초기 `WEBGUI_Analysis_Report.md`, `WEBGUI_Scroll_Report.md` 원본: 이번 정확한 파일명 검색에서 확보하지 못함. 존재하지 않는다고 단정하지 않음
- v3 이후의 운영 적용 결과·사용자 확인 및 추가 구조 개선의 구현 증빙

## 4. 파일 구성과 권장 읽기 순서

| 순서 | 파일/폴더 | 용도 |
|---|---|---|
| 1 | [00_README.md](00_README.md) | 범위·상태·안전한 사용 방법 |
| 2 | [01_프로젝트_맥락과설계.md](01_프로젝트_맥락과설계.md) | 배경, 설계 이유, 버전 변화, 오류 및 미확인 사항 |
| 3 | [02_교육과실습.md](02_교육과실습.md) | 학습 순서·실제 사례·오프라인 실습·운영 검증 과제 |
| 4 | [03_자료목록과보완사항.md](03_자료목록과보완사항.md) | 자료·화면 캡처·시각자료·포털 상호작용·보완 목록 |
| 근거 | [references/대화와자료_근거목록.md](references/대화와자료_근거목록.md) | 인용 ID, 중요한 사용자 요구와 출처 수준 |
| 근거 | [references/ITS_Chrome_v3_Report.md](references/ITS_Chrome_v3_Report.md) | 2026-09-14 기존 최종 보고서 원문 |
| 근거 | [references/100개_소스목록.md](references/100개_소스목록.md) | 경로별 3개 버전 크기·변경 여부·Drive 대조 |
| 근거 | [references/추출_검증결과.json](references/추출_검증결과.json) | 이번 추출의 패키지·원본 보존 검사. 과거 기능 검증과 별개 |
| 실습 | [examples/inspect_package.py](examples/inspect_package.py) | 새로 작성한 읽기 전용 ZIP·해시 검증 예제 |
| 실습 | [examples/리뷰_프롬프트.md](examples/리뷰_프롬프트.md) | 교육용 분석 요청 템플릿. 운영 명령 아님 |
| 첨부 | [Full](attachments/ITS_Chrome_v3_Full.zip), [Apply](attachments/ITS_Chrome_v3_Apply.zip), [Rollback](attachments/ITS_Chrome_v3_Rollback.zip), [Original](attachments/ITS_Chrome_v3_Original.zip), [Evidence](attachments/ITS_Chrome_v3_Evidence.zip) | 실제 확보한 기존 파일을 수정 없이 포함 |

`images/`는 제공할 안전한 원본 이미지가 없어 생략했다. 기존 보고서 안의 과거 `sandbox:` 다운로드 링크는 역사적 원문 그대로이며, 이동한 환경에서 작동하지 않을 수 있다. 이 README와 03 문서의 **상대경로 링크**를 사용한다. Evidence 안 README의 실행 명령은 Evidence ZIP을 별도 작업 폴더에 푼 뒤 사용하는 것이다.

## 5. 상태 표기 규칙

| 표기 | 의미 |
|---|---|
| 제안 | 검토 아이디어. 승인·구현을 의미하지 않음 |
| 결정 | 사용자 요구/선택으로 작업 기준이 정해짐 |
| 구현 | 확보한 코드에 변경이 존재 |
| 정적·모의 검증 | 지정한 분석/모델에서 확인. 실제 화면·통신·IME 검증은 아님 |
| 사용자 일부 확인 | 특정 시점 버전에 대한 사용자 실행 피드백 |
| 운영 확인 | 운영 환경에서 확인된 기록. **v3에는 확보된 기록 없음** |
| 미확인 | 자료 부족 또는 실제 실행 미실시 |

## 6. 통합 교육 포털과의 관계

이 묶음은 “AI와 함께 레거시 ERP UI 소스를 안전하게 분석·변경·검증하는 방법” 모듈에 해당한다. ERP 소스 추출·배포 프로젝트와는 소스 경로·버전·복원 기준에서 연결된다. GitHub에는 원본·교육 문서·검증 근거를 구분할 수 있는 자료를 제공하지만, 이 대화에서 GitHub 저장소 운영이나 Codex Desktop 설치 절차를 구현한 것은 아니다.

ERP MCP 구성, 담당 업무별 에이전트·서브에이전트, Obsidian, 업무 지식 스킬·하네스 구축을 이 프로젝트의 완료 항목으로 추가하지 않는다. 통합 대화방은 해당 프로젝트의 실제 자료를 별도로 받아 연결해야 한다. 다른 추출물과 **WebGUI 디자인, Chrome 오류, ITS 경로, 소스 검증·복원, AI 변경 지침**이 중복될 수 있으므로 출처 ID와 버전 기준으로 합친다.

## 7. 보안과 사용 주의

첨부 ZIP은 교육·검토용이며 즉시 운영 적용 지시가 아니다. Rollback은 실제 서버 백업이 아니고, Apply는 직전 기준본이 맞는 경우에만 의미가 있다. SAP 저작권 주석과 기존 파일을 보존했다. 통합 GitHub 저장소의 공개 여부와 사내 소스 재배포 권한은 별도로 확인해야 한다.

인증정보·비밀번호·실제 세션 토큰을 교육 문서에 옮기지 않는다. 캡처·HAR·HTML을 추가할 때도 URL 세션 식별자, 쿠키, Authorization, 업무 개인 정보를 제거한다. 예시는 테스트 데이터만 사용한다.
