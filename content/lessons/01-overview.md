# ERP AI의 전체 그림

## 먼저 해결하려는 문제

ERP 소스와 규정·협의 기록을 연결해 업무 질문과 변경 검토를 돕습니다.

Export로 지원 객체를 추출하고 Git으로 관리합니다. Codex는 소스와 업무 지식을 함께 읽고, DIAG는 원본·추출본·현재 SAP를 비교합니다.

## 실제 프로젝트는 어떻게 시작했나요?

[9월 18일의 최초 요청과 AI 답변](#/conversations/kbs-erp-export-diag-agents/E00-start)에서 시작 목적, 두 REPORT 구상, BASIS 700 제약과 환경 확인 질문을 읽을 수 있습니다. 이후 [첫 추출기의 반복 수정](#/conversations/kbs-erp-export-diag-agents/E00-export), [BSP·MIME 누락과 범위 조정](#/conversations/kbs-erp-export-diag-agents/E00-web), [맥락 문서와 파일 규칙](#/conversations/kbs-erp-export-diag-agents/E00-context)으로 이어집니다.

학습할 때는 각 요청에서 **추가한 제약**, AI가 제시한 **수정 이유**, 다음 실행에서 **확인한 결과**를 찾아보세요. 최초의 자동 Import·활성화 목표가 왜 [읽기 전용 DIAG로 바뀌었는지](#/conversations/kbs-erp-export-diag-agents/E16)까지 따라가면 현재 구성을 이해할 수 있습니다.

## 구성 요소의 역할

| 요소 | 하는 일 | 연결되는 자료 |
|---|---|---|
| Export | 지원 SAP 개발 객체를 파일화 | 소스·정의·manifest·baseline |
| GitHub | 변경 이력과 협업 기준 관리 | 저장소·커밋·검토 기록 |
| Codex | 자료 탐색, 설명, 변경안 작성 | 담당 패키지 소스와 업무 지식 |
| 업무 지식·스킬 | 근거와 작업 방법 제공 | 규정·협의·SKILL·INDEX |
| Obsidian | 연결 MD를 사람이 탐색 | 문서 링크와 업무지도 |
| DIAG | 세 자료 비교와 별도 검사 | ALV·상세·JSON |
| ERP 조회 MCP | 실제 ERP 조회 도구 연결 | 기존 REST/RFC 계약 |
| 담당자 자문 MCP | 다른 담당 에이전트에 질문 전달 | 요청·작업 상태·근거 답변 |

## 현재와 확장을 함께 읽는 방법

과정별로 확보 자료와 구현·검증 상태를 확인할 수 있습니다.

- Export 0.3.18·CHECK 0.3.3·DIAG 0.4.5: 소스 확보, 최신 SAP 전체 검증은 추가 확인.
- 중앙 자문 MCP 0.1.0: 모의 통신 검증, 실제 AI 워커는 미구현.
- ERP 조회·Telegram: 연결 설계 단계.
- Obsidian: 적용 캡처와 MD 지도 확보.
- WebGUI: Chrome v3·Modern V2 산출물과 검증 기록 확보, SAP 운영 검증은 추가 확인.
- ESS: 날짜 이동·반차 변경의 사용자 성공 보고, 최종 PRG 수정안은 재시험 대기.

## 사람이 판단할 지점

담당자는 답변의 출처·적용일·예외와 실제 실행 결과를 검토합니다. DIAG는 **읽기 전용 진단** 도구이며 자동 Import·활성화·CTS는 범위 밖입니다.

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
