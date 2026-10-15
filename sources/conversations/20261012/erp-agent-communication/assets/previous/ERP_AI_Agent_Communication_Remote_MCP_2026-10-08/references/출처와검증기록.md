# 출처와 검증 기록

- 프로젝트명: ERP AI 에이전트간의 통신
- 정리 기준일: 2026-10-08, Asia/Seoul
- 대상: 교육 추출본 1.0.0 / 기존 Node 예제 0.1.0

## 1. 대화 출처 식별자

아래는 현재 대화에서 직접 확인한 사용자 발언 시점과 해당 응답을 가리킨다. 별도 대화방 검색 결과나 전체 플랫폼 원본 export가 아니다. 날짜·시각은 현재 대화에 표시된 사용자 시각(KST)을 사용한다. 인용은 요구 구분을 위한 짧은 발췌이며 나머지는 요약이다.

| ID | 일시(KST) | 사용자 발언·주제 | 확인한 의미 |
|---|---|---|---|
| C01 | 2026-10-03 01:18:11 | 패키지별 소스·매뉴얼·회의록을 추출해 맥 Codex 사용, ZHR5와 ZFI 협업 질문 | 업무 분리와 협업의 출발점 |
| C02 | 2026-10-03 01:28:19 | “두 업무사이의 접점을 기록하는 md파일”과 ERP 하위 패키지 구성 확인 | 접점 문서·역할 배분 논의 |
| C03 | 2026-10-03 01:30:53 | Obsidian 업무 연결 시각화 질문 | 그래프·Canvas 제안 |
| C04 | 2026-10-03 01:35:30 | “다른 업무 범위의 코드나 내용은 수정하면 안되거든” | 사용자별 수정 경계 필수 |
| C05 | 2026-10-03 01:40:09 | “zfi가 서브에이전트로 붙어서 의사소통하는 모양새” | 사람 간 요청서 전달이 아닌 자동 자문 |
| C06 | 2026-10-03 01:42:54 | ZHR만 클론하며 “zfi는 클론 안할건데” | 로컬 자료 공유 전제 제거 |
| C07 | 2026-10-03 01:46:56 | “에이전트도 사람따라가게”, 팀원별 맥·자기 ZXX·중앙 MCP | 최종 분산형 방향에 명시적 동의 |
| C08 | 2026-10-03 01:55:17 | 중앙에 설치할 것 질문, Codex Desktop도 설치하려 했음 | 앱/서버/협업 프로그램 역할 구분 |
| C09 | 2026-10-03 01:58:37 | 중앙 MCP를 Node.js로 구현하는 예제 요청 | 코드 제작 및 산출물 제공 |
| C10 | 2026-10-08 21:09:34 | 교육 포털용 MD 4개와 ZIP 추출 요청 | 본 추출 범위·상태·원본 보존 기준 |

초기안과 최종안이 충돌하면 C04~C07의 더 구체적이고 후행하는 사용자 조건을 우선한다. 다만 그 조건을 충족할 실제 서비스가 배포되었다고 판단하지 않는다.

## 2. 원본 파일 식별과 보존

- 파일명: ERP_MCP_NodeJS_Example.zip
- 기존 저장 식별자: libfile_f0e9121c9e288191b3d5333d92c68028
- 이번 검색·확보 시 식별된 파일: file_00000000809c8206acb260f9ede06851
- 저장 메타데이터 created/modified: 2026-10-02T17:05:26.827127Z (= 2026-10-03 02:05:26 KST)
- 크기: 20,187 bytes
- SHA-256: `2d98d924786405b2517f1ed8d978b64dea5a3db98664430ed1b25fb32a4fd343`
- 최신성: 이번에 확보한 일치본 1건. 사용자 저장소/맥의 최신 버전까지 확인한 것은 아님.
- 복사: [attachments 원본](../attachments/ERP_MCP_NodeJS_Example.zip)
- 내부 6개 파일은 examples에 바이트 변경 없이 추출. 원본 소스는 수정하지 않음.

| ID | ZIP 내부 경로 | 확인 위치·방법 |
|---|---|---|
| F-SERVER | erp-mcp-example/server.mjs | 전체 읽기; createHub, makeMcp, sweep, worker 라우트 |
| F-WORKER | erp-mcp-example/mock-worker.mjs | 전체 읽기; 고정 답변 및 3초 폴링 |
| F-TEST | erp-mcp-example/test.mjs | 전체 읽기; 통합 시험 assertion |
| F-README | erp-mcp-example/README.md | 전체 읽기; 범위·1~3·실제 FI 자문 워커·운영 전 확장 절 |
| F-PACKAGE | erp-mcp-example/package.json | 전체 읽기; version, engines, scripts, dependencies |
| F-LOCK | erp-mcp-example/package-lock.json | 전체 JSON 파싱; 핵심 의존 packages 버전·형식 확인 |

## 3. 원 제작 검증 T01

현재 대화의 C09 응답 제작 과정에 다음 도구 결과가 직접 보인다.

- Node 버전 v24.19.0.
- 최초 npm 설치가 제한된 네트워크에서 EPERM으로 실패하고, 설치 전 시험에 ERR_MODULE_NOT_FOUND가 발생.
- 후속 허용된 설치에서 공개 패키지 94개 추가.
- 기본 실행 환경의 시험 실패 뒤 로컬 통신 가능한 실행에서 `npm test` 재수행.
- 마지막 결과 tests 1 / pass 1 / fail 0 / exit 0.

이 기록은 제작 환경의 모의 통합 시험이다. 사용자 맥에서의 통신·Codex 화면·운영 ERP 시험이 아니다. 최종 정리 응답의 “통합 테스트 통과”는 이 범위로 해석한다.

## 4. 이번 재검증 V02

- 날짜: 2026-10-08.
- 원본 재확보 후 6개 파일을 별도 임시 작업 폴더에 복사.
- 원본 파일 각각이 ZIP 내 바이트와 일치함을 확인.
- Node v24.19.0, 기존 제작 작업 환경의 node_modules 재사용. 새 npm ci 설치는 이번에 수행하지 않음.
- 원본 test.mjs를 수정하지 않고 `npm test` 수행.
- 결과: exit 0, tests 1, pass 1, fail 0.
- [원 출력](2026-10-08_test-output.txt) 포함. npm http-proxy 환경 설정 경고는 있었으나 시험 실패는 아님.
- 임시 로컬 루프백 서버와 메모리 DB로 실행·종료. 사용자 맥·사내 서버 설치나 외부 서비스 배포 없음.

### 실제 assertion 범위

| 검사 | 결과 |
|---|---|
| HR 토큰으로 worker API 접근 | 401 |
| HR 허용 범위 밖 ZMM 질의 | MCP isError |
| 다른 사용자 job_id 조회 | MCP isError |
| MM 워커가 ZFI 작업 claim | 204, 미배정 |
| FI 워커의 정상 claim | 해당 job_id |
| MM 워커의 ZFI 완료 제출 | 409 |
| FI 정상 완료와 HR 답변 조회 | 200 및 기대 답변 |
| parent_id 후속 문맥 | 이전 질문 포함 |
| 임대 만료 뒤 완료 제출 | 409, failed 상태 |

원본에는 단일 test() 안에 여러 assertion이 있다. 이 표의 각 행이 별도 테스트 케이스 수라는 뜻은 아니다. 다중 맥·실제 모델·파일 권한·TLS·보안 감사·업무 정확성은 미검증이다.

## 5. 공식 기술 참고의 범위

아래 주소는 원 대화에서 검색·열람한 공식 자료 또는 기존 README의 링크다. 이번 추출에서는 최신 내용을 재조회하지 않았으며, 설치 UI나 SDK의 현행 지원 범위를 확정하는 근거로 확장하지 않는다.

- [Codex 서브에이전트](https://learn.chatgpt.com/docs/agent-configuration/subagents) — 원 대화 C01에서 조회.
- [AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md) — 원 대화 C01에서 조회.
- [Codex MCP](https://learn.chatgpt.com/docs/extend/mcp) — 원 대화 C07에서 조회, 기존 README 참고.
- [Codex SDK](https://learn.chatgpt.com/docs/codex-sdk) — 원 대화 C07에서 조회, 기존 README 참고.
- [MCP TypeScript SDK v1](https://ts.sdk.modelcontextprotocol.io/server) — 원 제작 C09에서 조회.
- [Obsidian Graph](https://obsidian.md/help/plugins/graph), [Canvas](https://obsidian.md/help/plugins/canvas), [내부 링크](https://obsidian.md/help/links) — 원 대화 C03에서 조회.

이번 기술 사실의 직접 근거는 확보된 코드와 테스트다. 서비스 운영 매뉴얼로 발전시킬 때는 실제 설치 버전 및 공식 문서 재확인이 필요하다.

## 6. 민감 정보와 미확인 자료 처리

실제 인증 토큰·비밀번호·개인정보는 확보하거나 포함하지 않았다. test.mjs의 문자열은 원본에 포함된 시험용 더미이고, README·교육 문서의 설정 값은 대체값이다. package-lock의 무결성 해시는 비밀 토큰이 아니다.

직접 읽지 않은 실제 스킬·업무 문서·패키지 소스는 파일명 또는 역할만 알려진 자료로 구분했다. 관련 없는 다른 대화방의 기억이나 파일명으로 최신 내용을 추정하지 않았다.
