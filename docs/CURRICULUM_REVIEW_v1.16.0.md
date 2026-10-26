# v1.16.0 과정 01–10 개편 근거 · 2026-10-26

## 목적과 범위

처음 방문한 사람이 왜 에이전트를 구성하는지, 무엇을 만들고 어떤 문제를 해결하는지 이해하도록 교육 본문을 다시 작성했다. 사용자 지정 01–16 순서·명칭·주소를 유지하고 01–10의 본문과 카탈로그 소개·목표만 개편했다. 각 과정은 이유 → 실제 근거와 시행착오 → 방향 설정 → 기술적 구현 → 사례 → 한계와 다음 단계로 이어진다. 01의 구성 표는 이 작업 흐름에 포함한다.

기준은 v1.15.2 Full ZIP이며 SHA-256은 `bc3c56cd5c99c5a3e7c4095836af146bc018ea1083cf0383ad31a690b9146bc4`다. 사용자 PC와 GitHub 원격의 현재 수정은 이번에 확인하지 않았다. 원천·대화·표시용 문체 편집·첨부·11–16과정과 AGENTS는 보존한다. 기존 ‘이 과정 자료’·발표 기능을 재도입하지 않는다.

## 과정별 주요 근거

| 과정 | 새 설명의 중심 | 실제 근거 |
|---|---|---|
| 01 | 반복 문의·흩어진 배경·인수인계 → 근거를 제시하는 작업 공간 → 자료·AI 작업·검토·피드백 | export-full `SHARE-001`, `SHARE-081–082`, `E06`; PACKAGE_AGENT_BUILD_GUIDE; 실제 SRC-11 IAM 사례 |
| 02 | 패키지 관리 단위 → 함수·웹자산 누락 → 관계와 baseline 보존 → 특정 웹 개편을 위한 BSP 한 앱 추가 | export-full `SHARE-001/012/016/020/022/034/044/045/053/057/059/063/069/074/076/078/086/088`; progress `t026/t027/t029`; DEVHUB_EXPORT_GUIDE; 최신 ABAP 019·020 |
| 03 | 수정 ZIP 전달 부담 → SAP 직접 GitHub 조회 시도 → TLS 실패·보류 → PC와 GitHub의 Git 동기화 | export-full `SHARE-093–100`, `SHARE-127–139` (`E05/E08`); 현행 Git·VS Code 공식 안내 |
| 04 | 매번 파일·배경을 붙여 넣는 한계 → Mac Clone·Codex 프로젝트 → 자료와 작업 지침 → 작은 분석·수정·검토 | export-full `E05–E07`; PACKAGE_AGENT_BUILD_GUIDE; agent-collaboration 맥별 자기 패키지 범위; 공식 앱·프로젝트·AGENTS 안내 |
| 05 | 코드에 없는 결정 이유 → 규정·대화·이미지 → 요청·합의·완료·검증 구분 | export-full `SHARE-101–106`; kakao-work-context `kwc-m001–002`; SRC-11 8–34·328–366행; knowledge-images 가이드 |
| 06 | 문서를 모은 뒤의 탐색 문제 → 자동 그래프에 대한 오해 → 기존 경로 보존·maps 추가 | shared-full/erp-obsidian-knowledge-map `obs-m003–015`; GitHub 스냅샷 maps/INDEX·topics/rates·verification; 실제 적용 캡처 2장 |
| 07 | 그럴듯한 오답의 실패 기준 → 업무 피드백과 코드 수정 분리 → 스킬·피드백·회귀·하네스 | export-full `SHARE-119–125`; BUSINESS_FEEDBACK_POLICY; GitHub 스냅샷 FB-20261001-001·FB-20261008-001·tests/business-qa.md |
| 08 | 서버의 동시 변경 → 읽기 전용 진단 → 기존 웹자산만 선택 반영 → SO2 XML 실물로 판단 정정 | export-full `E10/E16/E20-webapply-review/E24-inactive-scope-cts/E26-so2-layout-evidence/E28-confirmed-bsp-next-scope/E29-single-app-zip`; DIAG 0.4.5 화면·과거 XLSX; 0.6.11 성공 화면 |
| 09 | HR 정산과 FI 전표 접점 → 모든 소스를 모으는 제안 정정 → 질문만 원격 전달 | shared-full/erp-agent-communication `eac-m001/009–024`; agent-collaboration Node 예제 README·mock-worker·test-output |
| 10 | 소스의 처리 조건과 ERP 현재 값의 차이 → 기존 REST/RFC → AI·실행기·MCP 역할 분리 → 모바일 메시지 | shared-full/kbs-erp-mcp-telegram `M001–026`; erp_readonly_contract.example.json; Telegram 공식 API |

대화 파일 기준 경로는 `content/conversations/`다. 최근 Export 진행 메시지는 `content/conversations/export-full/conversation-data.json`에 통합되어 있으며 원천 첨부는 `sources/conversations/20261024-progress/kbs-erp-export-diag-agents/assets/`다. `export-diag-progress-asset-019.abap`가 Export 0.4.1, `020.abap`가 DIAG 0.7.1, `021.zip`이 한 앱 도구 묶음이다.

근로시간 스냅샷 기준은 `sources/github-erp-ai/520ac77046f5/`다. 업무 지식 원문을 최신 내용으로 덮어쓰지 않고 그 자료의 의미를 교육 본문에서 설명했다.

## 사실·예시·검증 경계

- 월요일 추출·화요일 양쪽 수정은 세 자료 비교를 설명하는 교육용 가상 예시다. 실제 사건으로 표시하지 않았다.
- 최초 패키지 추출을 폐기한 것으로 쓰지 않는다. BSP 한 앱은 추가 모드다. 앱 MIME의 소유 패키지는 metadata에 보존하며 다른 패키지 소유라는 이유로 자산을 삭제한 것이 아니다.
- CHECK 통과는 SAP 자료를 모두 읽었다는 뜻이 아니다. CHECK 0.3.3의 새 BSP manifest 0.4 호환은 미확인이다.
- TLS 오류는 당시 시스템의 확인 결과다. BASIS 700 전부의 영구적 통신 불가, 인증서·토큰 문제 확정, 커널 업그레이드 필수로 확대하지 않는다. 407은 SAP 통신 오류 코드다.
- 로컬 작업은 작업 파일·명령의 위치를 뜻한다. 오프라인 모델이나 폴더 선택만으로 강제되는 접근 통제를 의미하지 않는다.
- IAM 사례는 담당자 설명·안내 합의이며 조치 뒤 실행 화면은 없다. 등급 변경 완료와 과거 입력 정정 예정도 구분한다. 과거 단가를 현행 일반 급여 안내로 사용하지 않는다.
- 반차 0원 사례는 입력 규칙 확인 전 코드 결함으로 판단한 오류를 정정한 실제 피드백이다. 2024 누적표시 롤백 사례는 업무 이유·탐색 경로 보완이며 별도의 오답을 만들어 붙이지 않는다.
- 후속 41개 업무 질문은 기대 답변 초안이다. 실무자 승인·독립 평가·SAP 실행 41건 통과로 쓰지 않는다.
- 0.6.11 BSP 성공은 기존 I 버전 재사용·해당 페이지 활성화·사후 조회·SE80 확인이다. 새 저장·전체 MIME·원복·브라우저 업무·최신 0.7.1 성공으로 확대하지 않는다.
- 09는 모의 워커의 통신 검증까지다. 10의 직원 누락·구매오더는 가상 설명이며 ERP·Telegram 왕복은 검증 전이다.
- 자료를 찾아가는 시간이나 답변 정확도 개선 수치를 새로 추정하지 않았다.

## 공식 안내 확인 · 2026-10-26

기존 프로젝트의 결정 이력은 로컬 근거로 읽었다. 설치·현재 도구 사용 안내는 다음 공식 자료를 열어 확인했다. 과거 원문을 현재 제품 안내로 고쳐 쓰지 않았다.

- https://learn.chatgpt.com/docs/app — 앱 설치·로그인·작업 위치·Codex 선택.
- https://learn.chatgpt.com/docs/projects — 로컬 프로젝트, 폴더 추가·기본 폴더와 지침 탐색.
- https://learn.chatgpt.com/docs/agent-configuration/agents-md — 지침 파일 탐색과 범위.
- https://code.visualstudio.com/docs/sourcecontrol/overview — 내장 Git 기능과 별도 Git 프로그램.
- https://code.visualstudio.com/docs/sourcecontrol/quickstart — 설치 전제·변경·Stage·Commit·공유.
- https://code.visualstudio.com/docs/sourcecontrol/github — GitHub 사용·Clone·PR.
- https://git-scm.com/docs/git-pull — Fetch·통합·ff-only.
- https://github.com/larshp/vscode-abap — ABAP 구문 강조 확장. SAP 실행 검사와 구분.
- https://obsidian.md/help/install · https://obsidian.md/help/manage-vaults — 설치·기존 폴더를 Vault로 열기.
- https://core.telegram.org/bots/api#getupdates — long polling·offset·수신 확인과 중복 처리.

VS Code repos-remotes 본문 재조회는 타임아웃이 있어 이번 재확인 완료 자료로 세지 않았다. 기존 링크를 유지하고 직접 확인한 quickstart·Git 공식 문서 등으로 기본 절차를 대조했다. 신규 SDK 설치나 API 실행 코드를 개발하지 않았으며, 09의 실행 안내는 원천 예제 README의 명령과 제한 범위를 따른다.

## 검증 방법

기존 빌드·검사·오프라인 복원 시험을 실행한다. 각 과정의 6개 본문 단위, 목차, 과정·자료실·대화 링크를 대조한다. 브라우저에서는 새 본문 표시와 목차 이동·검색·좁은 화면을 확인한다. 원천·대화·11–16과정 등 보존 범위는 기준 ZIP과 바이트를 비교한다. 상세 실행 결과는 릴리스 문서와 validation 로그에 남긴다.
