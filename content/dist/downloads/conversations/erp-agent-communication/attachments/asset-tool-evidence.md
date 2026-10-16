# 도구 증거 발췌와 해설

프로젝트명: ERP AI 에이전트간의 통신 / project_id: erp-agent-communication  
작성일: 2026-10-12

이 파일은 **이번에 만든 증거 정리 문서**다. 아래 도구 출력을 사용자나 assistant가 말한 채팅처럼 복원하지 않았다. 원 도구 이벤트 ID·전체 export는 확보하지 못했고, 현재 대화에 직접 표시된 실행 결과에서 필요한 부분을 발췌했다. 로그에 생략이 있는 경우 아래에서 명시한다.

## T01. 최초 설치 실패 — 출력 발췌

연결 발화: eac-m020~m024 사이 제작 과정. 정확한 실행 시각은 미확인.

```text
npm error code EPERM
npm error syscall connect
npm error errno EPERM
```

전체 npm 출력 중 오류 종류 세 줄만 발췌했다. 내부 네트워크 주소를 교육자료에 재출력할 필요가 없어 해당 줄은 발췌 대상에서 제외했다. 사용자 맥이 아닌 당시 제작 실행 환경의 오류다.

## T02. 의존성 없는 상태의 시험 실패 — 출력 발췌

```text
Error [ERR_MODULE_NOT_FOUND]: Cannot find package '@modelcontextprotocol/sdk' imported from /workspace/scratch/07a793692472/erp-mcp-example/test.mjs
```

스택 전체는 생략했다. 당시 모듈이 없었다는 증거이며, 라이브러리 API 자체가 잘못됐다는 증거가 아니다.

## T03. 후속 설치 및 최종 시험 — 실제 출력 발췌

설치 후 출력:

```text
added 94 packages in 4s
```

최종 시험 출력:

```text
✔ MCP 요청 → 워커 → 답변, 후속 질문, 사용자/워커 권한 분리 (214.742822ms)
ℹ tests 1
ℹ suites 0
ℹ pass 1
ℹ fail 0
ℹ cancelled 0
ℹ skipped 0
ℹ todo 0
ℹ duration_ms 461.156754
```

도구 결과의 exit_code는 0이었다. 원 npm 경고와 업데이트 안내는 발췌에서 생략했다. 최초 짧은 시험 실패 뒤 다른 허용 실행에서 통과한 사실을 보존하며, 모든 첫 실패의 세부 원인을 임의로 확정하지 않는다.

## T04. 10월8일 실제 재시험

[기존 시험 출력 원본](previous/ERP_AI_Agent_Communication_Remote_MCP_2026-10-08/references/2026-10-08_test-output.txt)을 그대로 포함했다. tests 1/pass 1/fail 0이며 이전 추출 도구 기록에 exit_code=0이 있다. 당시 Node v24.19.0, 기존 node_modules를 재사용한 시험이다. 새 맥 설치·실제 AI 분석 시험이 아니다. 연결 발화: eac-m029, eac-m031.

## T05. 이번 추출의 파일 증거

| 파일 | SHA-256 | 의미 |
|---|---|---|
| ERP_MCP_NodeJS_Example.zip | 2d98d924786405b2517f1ed8d978b64dea5a3db98664430ed1b25fb32a4fd343 | 원본 예제 재확보 |
| ERP_AI_Agent_Communication_Remote_MCP_2026-10-08.zip | cc7f3cc0a9a61b5919651553de52b7cb8eb2321819cbfe3b758e8ee2398e7637 | 원본·다른 폴더 사본 동일 |

10월8일 묶음 내부 13개 파일은 기존 확인 파일과 동일하고, 그 안의 예제 6개 파일은 원 Node ZIP의 대응 파일과 동일하다. 이번에는 파일·JSON·참조만 검사했고 신규 코드 시험은 수행하지 않았다.

## 원문 인용 마커의 공식 주소 대응

원문에 포함된 마커는 당시 검색 결과를 가리킨다. 아래 주소는 당시 실제 열람 기록에서 확인한 주소이며 이번에 새로 최신 내용을 검증하지 않았다.

| 원문 ref | 당시 주소 |
|---|---|
| turn2view0 | https://learn.chatgpt.com/docs/agent-configuration/subagents |
| turn2view1 | https://learn.chatgpt.com/docs/agent-configuration/agents-md |
| turn4view0 | https://obsidian.md/help/plugins/graph |
| turn4view1 | https://obsidian.md/help/plugins/canvas |
| turn4view2 | https://obsidian.md/help/links |
| turn6view0 | https://learn.chatgpt.com/docs/extend/mcp?surface=cli |
| turn6view1 | https://learn.chatgpt.com/docs/codex-sdk |
| turn8view0 | https://ts.sdk.modelcontextprotocol.io/server |

최신 설치 매뉴얼을 만들 때는 실제 앱 버전과 공식 문서를 다시 확인한다. 여기서는 원문의 출처 연결을 보존하는 용도다.
