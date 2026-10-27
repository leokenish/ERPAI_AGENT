# ERP AI 에이전트 포털 구축

## 원본부터 배포물까지

GitHub로 관리하는 정적 교육 사이트다. Node.js 빌드가 MD를 읽어 본문·목차·검색 데이터를 만들고, 웹서버는 결과물인 `dist/`를 제공한다.

| 폴더 | 역할 |
|---|---|
| sources/ | 받은 자료 보존. 기본 배포 제외, 과정 11의 지정 MD 스냅샷만 다운로드로 복사 |
| content/ | 통합된 교육 MD와 과정·출처 목록 |
| assets/ | 교육에 사용하는 이미지·구성도 |
| examples/ | 게시할 실습 파일 |
| site/ | 화면·스타일·상호작용 |
| scripts/ | 빌드·정적 웹서버·맥 서비스 |
| docs/ | 통합 근거·운영 안내·보완 목록 |
| dist/ | 실제 웹서버에 제공할 배포 파일 |

## 팀원이 자료를 추가하는 방법

1. 새 근거는 sources의 별도 프로젝트 폴더에 보존한다.
2. 관련 교육 문서와 비교해 중복·충돌·적용 시점을 확인한다.
3. content의 해당 MD를 수정하고 catalog의 상태·출처를 갱신한다.
4. 빌드와 검증을 실행한다.
5. 변경 이유와 화면을 검토한 뒤 GitHub에 공유한다.
6. 운영 맥에서 확정한 변경을 받아 빌드하고 반영한다.

게시 대상은 `content/`의 교육 콘텐츠와 지정한 다운로드 파일이다.

## 맥에서 처음 실행하기

실행 환경은 Node.js 24 이상이다. 포털 자체는 별도 npm 패키지를 설치하지 않고 실행할 수 있다. Markdown 변환기도 라이선스와 함께 저장소에 포함돼 있다.

```bash
npm run build
npm test
npm start
```

기본 접속 주소는 `http://127.0.0.1:8080`이다. 같은 사내망에 제공하려면 아래 명령을 사용한다. 다른 PC에서 접속할 때는 localhost 대신 맥의 사내 IP를 입력한다.

```bash
npm run start:lan
```

## 콘텐츠를 갱신할 때

로컬 변경을 확인한 뒤 팀의 기준 브랜치를 받는다. 이 예시는 원격과 로컬이 fast-forward 관계일 때만 반영하는 명령이다. 충돌이 있으면 자동으로 덮어쓰지 않고 내용을 검토한다.

```bash
git status
git pull --ff-only
npm run build
npm test
```

웹서버 루트는 `dist/`로 지정한다. 도메인·고정 IP·HTTPS는 사내 환경에 맞춰 구성한다.

## 자동 실행의 범위

제공된 맥 스크립트는 사용자 LaunchAgent 방식으로, **로그인 후 자동 실행**된다. 재부팅 직후 로그인 전부터 서비스를 제공하려면 별도 시스템 서비스 구성이 필요하다. 로그아웃하거나 잠자기 상태일 때도 서비스를 사용할 수 있는지는 운영 환경에서 확인한다.

```bash
npm run service:install
npm run service:status
npm run service:restart
npm run service:stop
```

## Codex에 맡길 업데이트 요청

```text
AGENTS.md와 docs/CONTENT_WORKFLOW.md를 읽고 새 원천 자료를 통합해줘.
기존 교육과 충돌하는 결정·버전을 확인하고 필요한 MD·목차·시각자료를 수정해줘.
sources 원본은 보존하고 build와 test를 실행해 결과를 알려줘.
실제 운영 확인 없이 상태를 검증 완료로 올리지 마.
```

## 근거

- GitHub·정적 배포·맥 Node.js 운영 방향
- `README.md`, `docs/MAC_SETUP.md`, `docs/CONTENT_WORKFLOW.md`
- 운영 맥·KBS 도메인 연결: 현장 검증 필요


## 근로시간 에이전트의 MD를 갱신할 때

과정 11은 별도 ERP_AI 저장소의 특정 커밋을 기준으로 한다. 해당 저장소를 맥에 클론하고 팀의 절차에 따라 변경을 받은 뒤, 교육 포털 폴더에서 아래 명령을 실행한다.

```bash
npm run knowledge:import -- /실제/경로/ERP_AI
npm run build
npm test
npm run preview:file
```

ERP_AI의 **커밋된 HEAD에 있는 MD**를 새 스냅샷으로 보존한다. 기존 스냅샷은 유지한다. 교육 본문·읽기 순서·출처 상태를 검토한 뒤 빌드하고 배포한다. 상세 절차는 `docs/WORKTIME_KNOWLEDGE.md`에서 확인할 수 있다.
