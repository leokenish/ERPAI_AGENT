# ERP AI 에이전트 전체 그림

## 먼저 해결하려는 문제

ERP 소스와 규정·협의 기록을 연결해 업무 질문과 변경 검토를 돕습니다.

Export로 지원 객체를 추출하고 Git으로 관리합니다. Codex는 소스와 업무 지식을 함께 읽고, DIAG는 원본·추출본·현재 SAP를 비교합니다.

## 실제 프로젝트는 어떻게 시작했나요?

[9월 18일의 최초 요청과 AI 답변](#/conversations/kbs-erp-export-diag-agents/E00-start)에서 시작 목적, 두 REPORT 구상, BASIS 700 제약과 환경 확인 질문을 읽을 수 있습니다. 이후 [첫 추출기의 반복 수정](#/conversations/kbs-erp-export-diag-agents/E00-export), [BSP·MIME 누락과 범위 조정](#/conversations/kbs-erp-export-diag-agents/E00-web), [맥락 문서와 파일 규칙](#/conversations/kbs-erp-export-diag-agents/E00-context)으로 이어집니다.

학습할 때는 각 요청에서 **추가한 제약**, AI가 제시한 **수정 이유**, 다음 실행에서 **확인한 결과**를 찾아보세요. 최초의 자동 Import·활성화 목표가 왜 [읽기 전용 DIAG로 바뀌었는지](#/conversations/kbs-erp-export-diag-agents/E16)를 확인하고, [기존 웹자산에 한정한 선택 반영](#/conversations/kbs-erp-export-diag-agents/E20-webapply-review)으로 확장된 후속 결정을 함께 읽습니다.

## AI 에이전트의 구성

| 구성 | 하는일 | 연결되는자료 |
|---|---|---|
| Export | 지원 SAP 개발 객체를 파일화 | 소스·정의·manifest·baseline |
| GitHub | 변경 이력과 협업 기준 관리 | 저장소·커밋·검토 기록 |
| Codex | 자료 탐색, 설명, 변경안 작성 | 담당 패키지 소스와 업무 지식 |
| 업무 지식·스킬 | 근거와 작업 방법 제공 | 규정·협의·SKILL·INDEX |
| Obsidian | 연결 MD를 사람이 탐색 | 문서 링크와 업무지도 |
| DIAG | 세 자료 비교·검사와 지원 웹자산 선택 반영 | ALV·상세·JSON·반영 로그 |
| ERP 조회 MCP | 실제 ERP 조회 도구 연결 | 기존 REST/RFC 계약 |
| 담당자 자문 MCP | 다른 담당 에이전트에 질문 전달 | 요청·작업 상태·근거 답변 |

## 현재와 확장을 함께 읽는 방법

과정별로 확보 자료와 구현·검증 상태를 확인할 수 있습니다.

- Export 0.4.1·DIAG 0.7.1: 패키지/BSP 한 앱 추출과 기존 웹자산 선택 반영. 0.6.11의 특정 BSP 활성화는 사용자 확인, 최신 SAP 실행은 미확인. CHECK 0.3.3은 이전 기준.
- 중앙 자문 MCP 0.1.0: 모의 통신 검증, 실제 AI 워커는 미구현.
- ERP 조회·Telegram: 연결 설계 단계.
- Obsidian: 적용 캡처와 MD 지도 확보.
- WebGUI: V429·UI 4.2.6·결재 1.4.5와 실제 화면 확보. 특정 사용자 성공과 최신본 재시험을 구분.
- ESS: 날짜 이동·반차 변경의 사용자 성공 보고, 최종 PRG 수정안은 재시험 대기.
- 주간업무일지 타임라인: UI 2.3·617개 HML 처리 보고, 의미 연결 정확도는 추가 검토.
- 스마트 ERP 메인화면: v9 프리뷰·문서 확보, 전달 ZIP 정상화와 SAP 검증 대기.

## 사람이 판단할 지점

담당자는 답변의 출처·적용일·예외와 실제 실행 결과를 검토합니다. DIAG의 ABAP·DDIC는 진단 범위이며, 지원되는 기존 MIME·BSP Layout만 선택 저장·활성화할 수 있습니다. 비교 통과, 저장, 활성화, 실제 업무 성공을 별도로 판단합니다.

## 첫 번째 학습 과제

자기 업무 하나를 고르고 다음 세 질문에 답해 보세요.

1. 이 업무의 코드는 어디에 있는가?
2. 적용 기준과 협의 이유는 어느 문서에 있는가?
3. 올바른 답변인지 확인할 사례는 무엇인가?

세 질문의 근거가 이어지면 에이전트의 첫 업무 범위가 됩니다. [소스 추출 과정](#/learn/export)에서 시작하세요.

## 근거

- `sources/export-diag/01_프로젝트_맥락과설계.md` §1·4·12·14
- `sources/agent-collaboration/01_프로젝트_맥락과설계.md` §4·12
- [원천 자료와 상태 보기](#/library)
