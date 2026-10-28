# ERP AI 에이전트 포털 구축

## 원본과 배포물 구성

교육 내용을 수정하면 본문뿐 아니라 목차·검색·다운로드도 함께 갱신되어야 합니다. 따라서 MD와 목록 파일을 원본으로 관리하고, Node.js 빌드가 웹브라우저용 파일을 생성하도록 구성했습니다. 웹서버는 결과물인 `dist/`를 제공합니다.

| 폴더 | 역할 |
|---|---|
| sources/ | 받은 자료와 프로젝트 원문 보존 |
| content/ | 교육 MD와 과정·출처·자료 연결 |
| assets/ | 이미지·구성도·서체 |
| examples/ | 게시할 실습 파일 |
| site/ | 화면·스타일·상호작용 |
| scripts/ | 빌드·정적 웹서버·맥 서비스 |
| docs/ | 통합 결정·운영 안내 |
| dist/ | 웹서버에 제공할 배포 파일 |

## 새 자료 반영 절차

1. 받은 자료를 `sources/`의 별도 프로젝트 폴더에 보존합니다.
2. 기존 문서와 비교해 중복·변경 내용·적용 시점을 정리합니다.
3. `content/`의 관련 MD와 과정·출처 목록을 갱신합니다.
4. 빌드와 검증을 실행하고 화면·링크·다운로드를 살펴봅니다.
5. 변경 이유와 함께 GitHub에 공유합니다.
6. 운영 맥에서 확정한 변경을 받아 빌드하고 반영합니다.

게시할 교육 내용과 다운로드 파일은 목록에서 지정합니다. 이렇게 하면 보관한 원천과 화면에 제공할 자료를 나누어 관리할 수 있습니다.

## 맥 로컬 실행

Node.js 24 이상에서 실행합니다. Markdown 변환기를 포함한 빌드 도구가 저장소에 있으므로 별도의 npm 패키지를 설치하지 않고 다음 명령을 사용할 수 있습니다.

```bash
npm run build
npm test
npm start
```

기본 접속 주소는 `http://127.0.0.1:8080`입니다. 같은 사내망의 다른 PC에서도 접속하려면 아래 명령을 사용합니다. 이때 접속 주소에는 localhost 대신 맥의 사내 IP를 입력합니다.

```bash
npm run start:lan
```

## 콘텐츠 갱신

먼저 로컬의 수정 상태를 살핀 뒤 팀의 기준 브랜치를 받습니다. 아래 명령은 기존 이력을 그대로 이어 붙일 수 있는 fast-forward 관계에서 변경을 반영합니다. 서로 다른 수정이 있으면 내용을 비교해 병합합니다.

```bash
git status
git pull --ff-only
npm run build
npm test
```

웹서버 루트는 `dist/`로 지정하고, 도메인·고정 IP·HTTPS는 사내 환경에 맞춰 구성합니다.

## 로그인 후 자동 실행

맥의 LaunchAgent를 사용해 **사용자 로그인 후 웹서버를 자동 실행**합니다. 아래 명령으로 서비스를 설치하고 상태 조회·재시작·중지를 수행합니다.

```bash
npm run service:install
npm run service:status
npm run service:restart
npm run service:stop
```

## Codex 업데이트 요청문

```text
AGENTS.md와 docs/CONTENT_WORKFLOW.md를 읽고 새 자료를 통합해 주세요.
기존 내용과 비교해 필요한 MD·목차·시각자료를 수정해 주세요.
sources 원본을 보존하고 build와 test를 실행한 결과를 알려 주세요.
변경한 내용과 검사 결과를 근거와 함께 정리해 주세요.
```

## 근거 자료 확인

- [ERP AI 에이전트 포털 구축 · intent.md](#/library/core-progress?file=intent.md)
- [ERP AI 에이전트 포털 구축 · spec.md](#/library/core-progress?file=spec.md)
- [ERP AI 에이전트 포털 구축 · plan.md](#/library/core-progress?file=plan.md)
- [ERP AI 에이전트 포털 구축 · insight.md](#/library/core-progress?file=insight.md)

## 근로시간 문서 갱신

과정 11의 문서는 별도 ERP_AI 저장소에서 가져옵니다. 맥에 해당 저장소를 클론하고 변경을 받은 뒤, 교육 포털 폴더에서 아래 명령을 실행합니다.

```bash
npm run knowledge:import -- /실제/경로/ERP_AI
npm run build
npm test
npm run preview:file
```

ERP_AI의 **커밋된 HEAD에 있는 MD**를 새 문서 묶음으로 보존합니다. 이전 묶음도 유지하므로 변경 전후의 자료를 비교할 수 있습니다. 이후 교육 본문·읽기 순서·출처를 갱신하고 빌드합니다. 상세 절차는 `docs/WORKTIME_KNOWLEDGE.md`에 있습니다.
