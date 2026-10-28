# GITHUB 연동

## 1. 왜 연결하려 했는가

SAP에서 추출한 코드를 PC에서 수정하면 팀에 전달할 파일과 서버에 적용할 버전을 정해야 합니다. ZIP만 주고받으면 변경 이유와 순서를 다시 확인하는 일이 반복됩니다.

따라서 코드와 업무 문서를 GitHub에 함께 두고 변경 이력을 관리하려고 했습니다. 팀원은 같은 저장소에서 자료를 받고, 변경된 부분과 그 이유를 이어서 살펴볼 수 있습니다.

처음에는 SAP의 Z프로그램이 GitHub의 변경 후보를 읽고 현재 SAP와 비교하는 방식을 논의했습니다. **GitHub에 저장한 파일을 SAP가 직접 가져오게 하는 방식**으로, 수정 ZIP을 매번 만들어 전달하는 수고를 줄이려는 구상이었습니다.

## 2. 무엇이 막혔는가

작은 통신 프로그램으로 직접 연결을 시험하자 `ICM_HTTP_SSL_ERROR`가 발생했습니다. ICM 로그에는 `received a fatal TLS1.0 protocol version alert message from the peer`가 남았습니다. TLS는 암호화 통신을 시작할 때 양쪽이 맞추는 보안 통신 방식이며, 당시에는 이 협상 단계에서 연결이 거부됐습니다.

당시 환경은 커널 721 패치 700, CommonCryptoLib 8.4.49였습니다. RZ11에서도 `ssl/client_ciphersuites` 매개변수를 인식하지 못했습니다. 따라서 저장소 이름이나 토큰을 바꾸는 대신, PC를 거쳐 파일을 전달하는 방식으로 다음 작업을 진행했습니다.

## 3. 어떤 방향으로 바꿨는가

선택한 흐름은 **SAP에서 ZIP 다운로드 → PC에서 추출 결과 검토 → Git으로 변경 기록 → GitHub로 공유**입니다. 수정본을 SAP에 전달할 때는 ZIP으로 묶고, DIAG에서 현재 서버와 비교합니다.

이렇게 하면 SAP와의 직접 통신을 사용하지 않아도 소스 분석과 업무 문서 정리를 이어갈 수 있습니다. SAP와 PC 사이에서는 파일을 내려받고 전달하며, PC와 GitHub 사이는 Git 명령이나 VS Code 버튼으로 동기화합니다.

| 이름 | 쉬운 설명 | 이번 작업에서 사용하는 곳 |
|---|---|---|
| Git | PC 파일의 변경 이력을 기록하는 프로그램 | 수정 전후 비교, Commit |
| GitHub | Git 저장소를 보관·공유하는 서비스 | 다른 PC에서 Clone, 팀 변경 공유 |
| VS Code | 파일 편집과 Git 작업을 위한 편집기 | ABAP·MD 검토, Stage·Push |
| 저장소 · 원격 | 이력을 가진 프로젝트 폴더 · 연결된 공유 주소 | 로컬 폴더와 `origin` 연결 |

PC에는 **Git과 VS Code**를 설치하고, GitHub에는 계정과 저장소를 준비합니다. 이 포털의 저장소는 [leokenish/ERPAI_AGENT](https://github.com/leokenish/ERPAI_AGENT)입니다. 아래 실습은 이 주소를 예시로 사용하며, SAP 소스 작업에는 회사가 허용한 담당 패키지 저장소를 사용합니다.

## 4. 어떻게 사용하는가

### 4-1. VS Code와 Git 설치

| 환경 | 설치 과정 | 설치 후 확인 |
|---|---|---|
| Windows | [VS Code 다운로드](https://code.visualstudio.com/download)에서 User Installer를 실행합니다. 이어서 [Git 설치 안내](https://git-scm.com/install/windows)에 따라 Git을 설치합니다. | VS Code를 다시 열고 Terminal → New Terminal에서 `git --version`을 실행합니다. |
| macOS | [VS Code 설치 안내](https://code.visualstudio.com/docs/setup/mac)에 따라 앱을 Applications로 옮깁니다. Git은 [Git 설치 안내](https://git-scm.com/install/mac)에 따라 준비합니다. | 터미널에서 `git --version`을 실행합니다. `code .`을 사용하려면 명령 팔레트의 Shell Command에서 code 명령을 PATH에 추가합니다. |

Windows의 User 설치와 전체 사용자 설치는 권한과 설치 위치가 다릅니다. 따라서 회사에서 지정한 설치 방식을 사용합니다. [Windows 설치 안내](https://code.visualstudio.com/docs/setup/windows)

**VS Code에는 Clone·Commit·Push 등 기본 Git 기능이 내장되어 있습니다.** PC에 Git을 설치하면 이 기능을 사용할 수 있습니다. [소스 제어 개요](https://code.visualstudio.com/docs/sourcecontrol/overview)

### 4-2. Git·ABAP 확장 준비

왼쪽 Extensions를 누르거나 Windows `Ctrl+Shift+X`, macOS `Cmd+Shift+X`로 확장 화면을 엽니다. 아래 ID로 검색한 뒤 제작자를 확인하고 Install을 누릅니다. Reload가 표시되면 다시 불러옵니다.

| 항목 | 설치 ID·제작자 | 활용 |
|---|---|---|
| 기본 Git | VS Code 내장 | 파일 차이·Stage·Commit·Clone·Fetch·Pull·Push |
| GitHub Pull Requests and Issues | `GitHub.vscode-pull-request-github` · GitHub | PR 작성·검토와 Issue 관리 |
| ABAP | `larshp.vscode-abap` | 로컬 `.abap` 파일의 구문 강조와 코드 접기 |

Private 저장소를 Clone하거나 Push할 때는 VS Code가 안내하는 브라우저 로그인을 진행합니다. PR 확장은 해당 기능에서 사용하는 계정도 연결합니다. [GitHub 연동 안내](https://code.visualstudio.com/docs/sourcecontrol/github) · [ABAP 확장 제작자 문서](https://github.com/larshp/vscode-abap)

이 프로젝트에서는 ECC 6.0 / SAP_BASIS 700에서 **추출한 소스를 로컬로 읽고 관리하는 방식**을 사용합니다.

### 4-3. 기존 저장소 Clone

1. GitHub 저장소의 Code → HTTPS에서 주소를 복사합니다.
2. VS Code에서 `Ctrl+Shift+P` 또는 `Cmd+Shift+P`를 누르고 **Git: Clone**을 실행합니다.
3. 주소를 붙여 넣고 상위 폴더를 선택합니다. 예를 들어 Windows는 `C:\work`, macOS는 `~/work`를 사용합니다.
4. 완료 후 Open을 눌러 생성된 `ERPAI_AGENT` 폴더를 엽니다.
5. 터미널에서 저장소 루트·현재 변경·원격 주소를 확인합니다. Clone한 저장소에는 기본적으로 `origin` 원격이 등록됩니다.

```bash
git rev-parse --show-toplevel
git status --short --branch
git remote -v
```

명령으로 진행할 때는 상위 폴더에서 다음과 같이 실행합니다.

```bash
git clone https://github.com/leokenish/ERPAI_AGENT.git
cd ERPAI_AGENT
git status
```

Clone과 Push에는 저장소의 접근 권한이 적용됩니다. 따라서 작업 계정의 읽기·쓰기 권한에 맞춰 진행합니다. [Clone·원격 안내](https://code.visualstudio.com/docs/sourcecontrol/repos-remotes)

### 4-4. 원격 지정과 저장소 이름 변경

기존 Git 저장소에서는 `git remote -v`로 연결 주소부터 확인합니다. 이 포털의 이전 이름인 `KBS_ERPEDU`가 보이면 다음 명령으로 주소를 바꿉니다. 로컬 폴더는 기존 위치를 그대로 사용해도 됩니다.

```bash
git remote set-url origin https://github.com/leokenish/ERPAI_AGENT.git
git remote -v
```

`origin`이 없는 저장소에는 다음 명령으로 원격을 추가합니다. VS Code의 **Git: Add Remote**에서 URL과 이름 `origin`을 입력해도 됩니다.

```bash
git remote add origin https://github.com/leokenish/ERPAI_AGENT.git
```

원격을 지정한 뒤 Commit과 Push를 진행하면 파일이 GitHub에 공유됩니다. [Git remote 공식 문서](https://git-scm.com/docs/git-remote)

#### 새 프로젝트의 첫 게시

기존 이력이 있는 프로젝트는 먼저 Clone하고 그 폴더에 작업 파일을 비교·병합합니다. 새 프로젝트라면 Source Control → Initialize Repository로 로컬 저장소를 만들고, 변경을 검토해 첫 Commit을 작성합니다.

게시 방법은 다음 중 하나를 선택합니다.

- **VS Code에서 저장소 생성:** Publish to GitHub에서 저장소 이름과 공개 범위를 지정합니다. 생성 후 `git remote -v`로 연결 주소를 살펴봅니다.
- **기존 빈 저장소에 연결:** GitHub에 만든 빈 저장소를 `git remote add origin "실제 저장소 URL"`로 등록합니다. 현재 브랜치에서 `git push -u origin "실제 브랜치명"`을 실행합니다.

명령의 설명용 값은 실제 URL과 브랜치명으로 바꿉니다. 기존 `.git`, `.github`, `AGENTS.md`, `.gitattributes`, `.gitignore`는 유지합니다.

### 4-5. ABAP 소스와 MD 읽기·비교

1. Explorer에서 추출 폴더를 엽니다. manifest와 로그에서 패키지·객체·추출 시점을 읽습니다.
2. `.abap` 파일의 우측 하단 언어 모드를 ABAP으로 선택합니다.
3. `Ctrl+Shift+F` 또는 `Cmd+Shift+F`로 함수·테이블·메시지를 검색합니다. INCLUDE·함수 정의·BSP 이벤트도 함께 찾아 연결 관계를 살펴봅니다.
4. 첫 파일 우클릭 → Select for Compare, 두 번째 파일 우클릭 → Compare with Selected로 두 파일을 비교합니다. 수정 파일은 Source Control에서 선택해 변경 전후를 볼 수 있습니다.
5. 저장할 때는 기존 인코딩과 LF/CRLF, Git 속성을 유지합니다. 원천과 baseline의 바이트·줄바꿈도 보존합니다.

VS Code에서는 파일을 읽고 변경 차이를 검토합니다. 이후 SAP에서의 검사와 적용은 [코드 검증 및 적용](#/learn/diagnosis) 절차로 이어갑니다.

### 4-6. Stage와 Commit

커밋에는 변경 파일과 작성자 정보가 함께 기록됩니다. 따라서 처음 작업하는 PC에서는 현재 저장소의 이름·이메일을 설정합니다. 아래 설명용 값은 실제 작성자 정보로 바꿉니다.

```bash
git config user.name "작성자 이름"
git config user.email "작성자 이메일"
git config --get user.name
git config --get user.email
```

1. Source Control의 Changes에서 파일별 차이를 읽습니다.
2. 공유할 파일의 `+`를 눌러 Staged Changes로 옮깁니다.
3. 메시지에 변경 목적과 범위를 적습니다. 예를 들어 `근태 문의의 적용 조건과 확인 근거 보완`처럼 작성합니다.
4. Commit을 눌러 로컬 변경 이력에 저장합니다.
5. `git status`, `git log -1 --oneline`으로 결과를 살펴봅니다.

명령으로 진행할 때도 공유할 파일을 지정합니다.

```bash
git diff -- README.md
git add README.md
git diff --cached
git commit -m "프로젝트 시작 안내 보완"
git status --short --branch
```

포털을 수정했다면 `npm run build`, `npm test`, `npm run preview:file`로 결과를 점검합니다. 생성물인 `dist/`, `preview.html`, `preview-data/`는 빌드로 다시 만들고, 루트 `index.html`은 변경 내용을 검토해 관리합니다. [첫 커밋 안내](https://code.visualstudio.com/docs/sourcecontrol/quickstart)

### 4-7. Fetch·Pull·Push·Sync Changes

| 작업 | 하는 일 | VS Code의 위치 | 결과 |
|---|---|---|---|
| Fetch | 원격의 새 커밋 정보 가져오기 | Source Control `…` → Fetch | 원격과 로컬 이력 비교 |
| Pull | 원격 변경을 현재 브랜치에 통합 | `…` → Pull | 작업 파일 갱신 |
| Push | 로컬 커밋을 원격으로 전송 | `…` → Push | GitHub 커밋·파일 갱신 |
| Sync Changes | Pull과 Push를 이어서 실행 | 상태 표시줄 또는 Source Control | 원격·로컬 동기화 |

아래는 현재 브랜치가 `main`이고 작업 중인 변경을 정리한 경우의 예시입니다. 다른 브랜치를 사용한다면 해당 이름으로 바꿉니다.

```bash
git status --short --branch
git fetch origin
git log --oneline --left-right HEAD...origin/main
git pull --ff-only origin main
git push origin main
```

`--ff-only`는 서로 다른 변경을 병합하지 않아도 원격 이력으로 이동할 수 있을 때만 진행합니다. 양쪽에 새 커밋이 있다면 팀의 Merge·Rebase 방식으로 통합합니다. 아직 커밋하지 않은 작업은 Commit하거나 Stash에 보관한 뒤 Pull합니다.

**동기화한 뒤에는 통합된 파일을 빌드하고 검토합니다.** SAP에 적용할 파일은 다음 검증 절차로 전달합니다. [원격 저장소 작업](https://code.visualstudio.com/docs/sourcecontrol/repos-remotes)

### 4-8. 팀 검토와 오류 대응

브랜치로 협업하는 경우 `git switch -c docs/agent-guide`로 작업 브랜치를 만듭니다. Commit 후 `git push -u origin docs/agent-guide`로 게시하고, GitHub 또는 PR 확장에서 Pull Request를 엽니다. 이후 팀의 브랜치 정책에 따라 차이를 검토하고 병합합니다.

| 메시지·상황 | 확인할 항목 |
|---|---|
| Git을 찾을 수 없음 | Git 설치, VS Code 재시작, `git --version` |
| Please tell me who you are | 현재 저장소의 `user.name`·`user.email` |
| Repository not found / 권한 거부 | `git remote -v`, 로그인 계정, 저장소 접근·쓰기 권한 |
| No upstream branch | 현재 브랜치, Publish Branch 또는 `git push -u origin "실제 브랜치명"` |
| Push rejected / non-fast-forward | Fetch 후 양쪽 커밋 비교·통합 |
| 충돌 | 양쪽 변경 의도, 병합·저장·검사·Stage·Commit |
| 모든 줄이 바뀜 | 인코딩·줄바꿈·자동 포맷·Git 속성 |

오류가 반복되면 **Git: Show Git Output**에서 실패한 명령을 찾습니다. 오류 문구와 브랜치·원격·`git status`를 함께 정리하면 원인을 좁히기 쉽습니다. 비밀번호와 토큰은 공유 자료에서 제외합니다.

## 5. 직접 따라 해보기

첫 연습은 문서 한 개로 진행합니다. README의 설명 한 줄을 수정해 다른 PC까지 전달되는 흐름을 살펴봅니다.

1. 쓰기 권한이 있는 저장소를 Clone하고 VS Code와 터미널에서 같은 폴더를 엽니다.
2. README의 설명 한 줄을 수정하고 저장합니다.
3. Changes에서 차이를 읽고 Stage한 뒤 목적을 적어 Commit합니다.
4. Fetch로 원격 이력을 살펴보고, 필요한 변경을 Pull로 통합합니다.
5. Push한 뒤 GitHub의 같은 브랜치에서 커밋과 수정 문장을 찾습니다.
6. 다른 PC에서 Fetch·Pull하고 같은 문장이 나타나는지 살펴봅니다.

실제 프로젝트에서도 GitHub Publish와 Mac Clone을 거쳐 담당 패키지를 Codex에서 열었습니다. **파일 저장 → 로컬 이력 기록 → GitHub 공유**의 단계를 구분하면 어느 위치에 변경이 반영됐는지 이해하기 쉽습니다.

## 6. 공유 이후의 작업

GitHub에 공유한 뒤에도 SAP 서버에서는 다른 개발자의 수정이 이어질 수 있습니다. 따라서 ERP에 반영하기 전에는 [08. 코드 검증 및 적용](#/learn/diagnosis)에서 원본·작업본·현재 SAP를 비교합니다.

포털의 문서 링크 검사와 사이트 빌드·게시에는 GitHub Actions를 활용합니다. 이처럼 GitHub는 공유한 파일을 기준으로 반복 작업을 연결하는 출발점이 됩니다.

다음 [04. 로컬 에이전트 구성](#/learn/codex)에서는 방금 Clone한 폴더를 Codex에서 열고 업무 자료를 연결합니다.

## 근거 자료 확인

- [소스 추출 및 진단, 업무 에이전트 자료확인](#/library/export-diag)
