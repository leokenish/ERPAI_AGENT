# ERP 담당자 간 자문 MCP — Node.js 예제

HR 맥의 Codex → 중앙 MCP → FI 맥의 자문 워커 → 중앙 → HR 답변 구조.
중앙은 AI를 실행하지 않으며 ZFI 저장소도 필요하지 않습니다.

## 범위

- 실행 가능한 중앙 MCP: Streamable HTTP, 사용자별 토큰/담당 허용 목록, SQLite 큐.
- 자문 요청/조회/후속 질문, 워커 작업 배정/하트비트/결과 제출.
- 모의 워커: 통신만 검증. **Codex AI 호출과 실제 ZFI 소스 분석은 포함하지 않습니다.**
- MCP SDK v1 API를 사용하며 package-lock.json으로 설치 버전을 고정합니다.
- Node.js 24 이상. SQLite 내장 API는 Node 버전에 따라 experimental 경고가 날 수 있습니다.

## 1. 중앙 서버 준비

```bash
npm ci
```

서로 다른 임의 토큰 2개를 생성합니다. 출력은 해당 담당자에게만 전달하세요.

```bash
node -e "console.log(require('node:crypto').randomBytes(32).toString('hex'))"
```

위 명령을 두 번 실행하고 중앙 터미널에 설정합니다. 아래 값은 실제 생성값으로 교체합니다.

```bash
export HR_CLIENT_TOKEN='HR용_생성값'
export FI_WORKER_TOKEN='FI워커용_생성값'
npm start
```

기본은 127.0.0.1:3000. jobs.sqlite가 생성됩니다. 같은 서버에서 먼저 확인하세요.
실제 사내 사용은 TLS 리버스 프록시를 앞에 두고 https://호스트/mcp 및 /worker 경로를 전달합니다.
평문 HTTP로 토큰을 사내망에 노출하지 마세요. SQLite 파일/백업에는 질문과 답변이 보관됩니다.

## 2. 통신 시험용 FI 워커 실행

별도 터미널에서 같은 프로젝트 폴더로 이동합니다.

```bash
export HUB_URL='http://127.0.0.1:3000'
export FI_WORKER_TOKEN='중앙에_설정한_FI워커용_생성값'
npm run worker:mock
```

다른 FI 맥에서 실행한다면 HUB_URL을 중앙의 실제 HTTPS 주소로 변경합니다.
워커는 3초 간격으로 중앙에 연결하므로 FI 맥의 수신 포트를 열 필요가 없습니다.

## 3. HR 맥 Codex MCP 설정

~/.codex/config.toml에 추가합니다. 로컬 시험 후 URL을 실제 HTTPS 주소로 변경하세요.

```toml
[mcp_servers.erp_team]
url = "http://127.0.0.1:3000/mcp"
bearer_token_env_var = "ERP_HR_MCP_TOKEN"
```

ERP_HR_MCP_TOKEN에는 HR_CLIENT_TOKEN과 같은 값을 설정합니다.
이 환경 변수는 **Codex 앱 프로세스가 실제로 상속한 환경**에 있어야 합니다.
터미널 export만으로 이미 실행 중이거나 Finder에서 시작한 앱에 전달되지 않습니다.
사용 중인 앱의 토큰 설정/실행 환경에 맞게 설정 후 재시작하세요.
정적 사용자별 토큰 예제이며 OAuth 자동 로그인 서버는 구현하지 않습니다.

질문 예시: “erp_team의 ZFI 담당에게 시간외 취소 시 회계 전표 처리 방식을 물어봐.
ask_expert가 반환한 job_id로 get_answer를 조회해줘.”

처음에는 [MOCK] 답변만 옵니다. 실제 ERP 분석 결과로 사용하면 안 됩니다.

## 중앙 핵심 API

| 연결 | 기능 |
|---|---|
| MCP list_experts | 허용된 담당과 최근 연결 상태 |
| MCP ask_expert | expert, question, context, 선택 parent_id → job_id |
| MCP get_answer | job_id → queued/running/done/failed/expired |
| POST /worker/claim | 인증된 워커의 담당 업무만 1건 배정 |
| POST /worker/:id/heartbeat | lease를 보내 60초 임대 갱신 |
| POST /worker/:id/complete | lease 및 answer 또는 error 제출 |

요청자 ID와 워커 담당은 입력 텍스트가 아니라 서버의 토큰 설정으로 결정합니다.
다른 사용자의 job_id로 답변/후속 질문에 접근할 수 없습니다.
추가 질문은 완료된 원래 요청의 parent_id를 지정합니다. 최신 선행 자문 3개가 전달됩니다.
실제 Codex 스레드 재개는 구현하지 않았으며 문맥 전달 방식입니다.
요청은 15분 만료, 실행 중 워커는 60초 내 heartbeat 필요. 워커 장애 시 실패 처리하며
자동 재배정하지 않습니다. 종료 후 중복 AI 호출을 피하기 위한 단순 정책입니다.
MCP 세션은 stateless지만 업무 요청은 SQLite에 남습니다. 단일 서버 프로세스 예제입니다.

## 실제 FI 자문 워커를 붙이는 지점

mock-worker.mjs의 고정 답변 생성 부분을 다음 처리로 교체합니다.

1. FI 맥의 고정된 자문용 ZFI 작업 사본 선택. 원격 질문으로 cwd/명령을 지정하게 하지 않기.
2. 별도 Codex SDK/CLI 실행 환경에서 읽기 전용 자문 세션 시작.
3. ZFI AGENTS.md, 해당 스킬을 읽고 question/context/history를 참고해 조사.
4. 실행 중 20초 간격 heartbeat. 취소/시간 제한으로 15분 내 중단 보장.
5. 근거 경로, 확인한 커밋, 미확인 사항을 answer로 반환. 실행 실패 시 error 반환.

워커가 중앙에 쓰는 토큰을 AI 프로세스 환경에 전달하지 마세요.
자문 실행 계정/파일 권한을 분리하고, 외부 질문을 명령이 아닌 조사 자료로 취급하세요.
AI 실행 환경의 기존 MCP/스킬 설정으로 수정 도구가 열리지 않는지도 확인해야 합니다.
Desktop 작업 중인 대화창을 원격 조종하는 방식이 아닙니다.
Codex 실행 환경의 인증 및 사용량은 별도로 구성/확인해야 합니다.

## 담당 추가

server.mjs 마지막 createHub 호출의 clients에 사용자별 토큰과 experts 목록,
workers에 맥별 토큰과 expert를 추가합니다. 실서비스에서는 이 설정을 비밀 저장소로 분리하세요.
중앙 토큰을 모든 사용자에게 공유하지 않습니다.

## 검증

```bash
npm test
```

실제 MCP SDK 클라이언트로 도구 호출, 워커 결과 제출, 후속 문맥,
타 사용자 결과 차단, 타 업무 워커 차단, 임대 만료를 검사합니다.
실제 맥/Codex Desktop/AI 인증/사내 HTTPS 연결은 별도 환경 검증이 필요합니다.

## 운영 전 확장

실서비스용 SSO/OAuth, 토큰 교체, 요청별 idempotency 키, 감사 로그/보존 기간,
장기 큐 정리, 안정적인 재시도 정책, 서비스 자동 재시작은 추가 구현 범위입니다.
현재 online 값은 최근 통신 시각이며 자문 완료를 보장하지 않습니다.

## 공식 참고

- https://ts.sdk.modelcontextprotocol.io/server
- https://learn.chatgpt.com/docs/extend/mcp
- https://learn.chatgpt.com/docs/codex-sdk
