# GITHUB 연동

## 작업 흐름

VS Code에서 담당 저장소를 열고, 추출한 ABAP 소스와 업무 MD의 변경을 검토해 GitHub에 공유합니다. **설치 → Clone → 원격 확인 → 변경 검토 → Commit → Fetch·Pull → Push** 순서로 진행합니다. 같은 폴더를 에이전트 작업 대상으로 지정하는 방법은 [로컬 에이전트 구성](#/learn/codex)에서 이어집니다.

이 포털의 저장소는 [leokenish/ERPAI_AGENT](https://github.com/leokenish/ERPAI_AGENT)입니다. 아래 예시는 이 주소를 사용합니다. 담당 ABAP 소스를 관리할 때는 담당 패키지 저장소의 주소로 바꿔 주세요.

## 1. VS Code와 Git 설치

| 환경 | 설치 과정 | 설치 후 확인 |
|---|---|---|
| Windows | [VS Code 다운로드](https://code.visualstudio.com/download)에서 환경에 맞는 User Installer를 실행합니다. 이어서 [Git 설치 안내](https://git-scm.com/install/windows)에 따라 Git을 설치합니다. | VS Code를 다시 열고 Terminal → New Terminal에서 `git --version`을 실행합니다. |
| macOS | [VS Code 설치 안내](https://code.visualstudio.com/docs/setup/mac)에 따라 앱을 Applications로 옮겨 실행합니다. Git이 없으면 [Git 설치 안내](https://git-scm.com/install/mac)에 따라 설치합니다. | 터미널에서 `git --version`을 확인합니다. `code .`을 쓰려면 명령 팔레트의 Shell Command 항목에서 code 명령을 PATH에 추가합니다. |

Windows User 설치와 전체 사용자 설치는 권한·설치 위치가 다릅니다. 회사에서 정한 설치 방식이 있으면 그 방식을 따릅니다. [Windows 설치 안내](https://code.visualstudio.com/docs/setup/windows)

Git은 파일 이력을 관리하는 프로그램, GitHub는 저장소를 공유하는 서비스, VS Code는 편집기입니다. **VS Code에는 Git 기능이 내장되어 있어 기본 Clone·Commit·Push를 위해 별도 Git 확장을 설치할 필요가 없습니다.** Git 프로그램은 PC에 설치되어 있어야 합니다. [소스 제어 개요](https://code.visualstudio.com/docs/sourcecontrol/overview)

## 2. Git·ABAP 확장 준비

왼쪽 Extensions를 누르거나 Windows `Ctrl+Shift+X`, macOS `Cmd+Shift+X`로 확장 화면을 엽니다. 아래 ID를 검색하고 제작자를 확인한 뒤 Install을 누릅니다. Reload가 표시되면 다시 불러옵니다.

| 항목 | 설치 ID·제작자 | 활용 |
|---|---|---|
| 기본 Git | VS Code 내장 | 파일 차이·Stage·Commit·Clone·Fetch·Pull·Push. 별도 확장 불필요 |
| GitHub Pull Requests and Issues | `GitHub.vscode-pull-request-github` · GitHub | 선택 사항. PR 작성·검토·Issue 관리를 VS Code에서 진행할 때 설치 |
| ABAP | `larshp.vscode-abap` | 로컬 `.abap` 파일의 구문 강조와 접기. SAP 문법 검사·활성화를 대신하지 않음 |

Private 저장소를 Clone하거나 Push할 때 VS Code가 표시하는 브라우저 로그인 절차를 완료합니다. PR 확장은 설치 후 별도로 로그인할 수 있습니다. 기본 GitHub 인증과 PR 확장 기능을 구분합니다. [GitHub 연동 안내](https://code.visualstudio.com/docs/sourcecontrol/github) · [ABAP 확장 제작자 문서](https://github.com/larshp/vscode-abap)

이 프로젝트의 ECC 6.0 / SAP_BASIS 700에서는 **추출한 소스를 로컬에서 읽고 관리하는 방식**으로 시작합니다. SAP 직접 연결용 확장은 서버 지원·인증·권한을 확인하는 별도 작업입니다.

## 3. 기존 저장소를 Clone하기

1. GitHub 저장소에서 Code → HTTPS 주소를 복사합니다.
2. VS Code에서 `Ctrl+Shift+P` 또는 `Cmd+Shift+P`를 누르고 **Git: Clone**을 실행합니다.
3. 주소를 붙여 넣고 상위 폴더를 선택합니다. 예: Windows `C:\work`, macOS `~/work`.
4. 완료 후 Open을 눌러 생성된 `ERPAI_AGENT` 폴더를 엽니다. ZIP을 풀어 놓은 사본과 Clone 폴더를 구분합니다.
5. 터미널에서 저장소 루트·현재 변경·원격을 확인합니다. Clone은 기본적으로 `origin` 원격을 등록합니다.

```bash
git rev-parse --show-toplevel
git status --short --branch
git remote -v
```

명령으로 진행하려면 상위 폴더에서 실행합니다.

```bash
git clone https://github.com/leokenish/ERPAI_AGENT.git
cd ERPAI_AGENT
git status
```

로그인 계정에 저장소 접근 권한이 있어야 합니다. 읽기 권한과 Push 권한은 다를 수 있습니다. [Clone·원격 안내](https://code.visualstudio.com/docs/sourcecontrol/repos-remotes)

## 4. 원격 지정과 저장소 이름 변경

이미 Git 저장소라면 다시 초기화하지 않고 `git remote -v`부터 확인합니다. 이 포털의 이전 이름 `KBS_ERPEDU`가 보이면 아래처럼 연결 주소를 바꿉니다. 로컬 폴더 이름까지 반드시 바꿀 필요는 없습니다.

```bash
git remote set-url origin https://github.com/leokenish/ERPAI_AGENT.git
git remote -v
```

`origin` 자체가 없을 때만 다음 명령을 사용합니다. VS Code 명령 팔레트의 **Git: Add Remote**에서 URL과 이름 `origin`을 입력해도 됩니다.

```bash
git remote add origin https://github.com/leokenish/ERPAI_AGENT.git
```

원격 등록은 파일 업로드가 아닙니다. Commit 후 Push해야 공유됩니다. [Git remote 공식 문서](https://git-scm.com/docs/git-remote)

### 아직 Git이 아닌 폴더를 처음 공유한다면

GitHub에 이미 이력이 있는 프로젝트는 먼저 Clone한 폴더에 파일을 비교·병합합니다. 정말 새 프로젝트라면 로컬 폴더를 열고 Source Control → Initialize Repository를 선택합니다. 변경을 검토해 첫 Commit을 만든 뒤 다음 중 하나로 게시합니다.

- **VS Code에서 생성:** Publish to GitHub를 선택하고 저장소 이름·공개 범위를 지정합니다. 생성 후 `git remote -v`를 확인합니다.
- **기존 빈 저장소에 연결:** README 등 초기 파일 없이 만든 GitHub 저장소에 `git remote add origin "실제 저장소 URL"`로 연결합니다. 현재 브랜치를 확인하고 `git push -u origin "실제 브랜치명"`을 실행합니다.

설명용 값을 실제 값으로 바꿉니다. 기존 `.git`, `.github`, `AGENTS.md`, `.gitattributes`, `.gitignore`를 보존합니다.

## 5. ABAP 소스와 MD 읽기·비교

1. Explorer에서 실제 추출 폴더를 엽니다. 패키지·객체·추출 시점은 manifest와 로그로 확인합니다.
2. `.abap` 파일의 우측 하단 언어 모드가 ABAP인지 확인합니다. Plain Text이면 ABAP으로 선택합니다.
3. `Ctrl+Shift+F` 또는 `Cmd+Shift+F`로 함수·테이블·메시지를 찾습니다. INCLUDE·함수 정의·BSP 이벤트 등 관련 파일을 실제 경로로 확인합니다.
4. 두 파일은 첫 파일 우클릭 → Select for Compare, 두 번째 파일 우클릭 → Compare with Selected로 비교합니다. 수정한 파일은 Source Control에서 클릭하면 변경 전후를 볼 수 있습니다.
5. 저장 전 인코딩과 LF/CRLF를 확인합니다. 기존 Git 속성을 따르고 원천·baseline의 바이트와 줄바꿈을 변환하지 않습니다.

ABAP 구문 색상은 SAP_BASIS 700의 컴파일·실행 성공을 의미하지 않습니다. GitHub Commit도 SAP 활성화를 수행하지 않습니다. 실제 검사와 적용 판단은 [코드 검증 및 적용](#/learn/diagnosis)에서 별도로 다룹니다.

## 6. Stage와 Commit

처음 커밋하는 PC는 작성자 정보를 확인합니다. 아래 설정은 현재 저장소에만 적용되며 값을 실제 이름·이메일로 바꿉니다. 작성자 정보는 로그인 암호가 아닙니다.

```bash
git config user.name "작성자 이름"
git config user.email "작성자 이메일"
git config --get user.name
git config --get user.email
```

1. Source Control의 Changes에서 파일을 하나씩 클릭해 차이를 읽습니다.
2. 공유할 파일의 `+`를 눌러 Staged Changes로 옮깁니다.
3. 메시지에 목적·범위를 적습니다. 예: `근태 문의의 적용 조건과 확인 근거 보완`.
4. Commit을 누릅니다. 여기까지는 로컬 이력에만 저장됩니다.
5. `git status`, `git log -1 --oneline`으로 결과를 확인합니다.

명령 예시는 아래와 같습니다. 현재 프로젝트에 있는 파일을 명시합니다.

```bash
git diff -- README.md
git add README.md
git diff --cached
git commit -m "프로젝트 시작 안내 보완"
git status --short --branch
```

이 포털을 수정했다면 `npm run build`, `npm test`, `npm run preview:file` 후 `dist/`, 루트 `index.html`, `preview.html`도 검토합니다. [첫 커밋 안내](https://code.visualstudio.com/docs/sourcecontrol/quickstart)

## 7. Fetch·Pull·Push·Sync Changes

| 작업 | 하는 일 | VS Code의 위치 | 확인할 결과 |
|---|---|---|---|
| Fetch | 원격 커밋 정보를 가져오며 작업 파일에는 합치지 않음 | Source Control `…` → Fetch | 원격의 새 커밋 |
| Pull | 원격 변경을 현재 브랜치에 통합 | `…` → Pull | 파일 변경·충돌 여부 |
| Push | 로컬 커밋을 원격으로 전송 | `…` → Push | GitHub의 커밋·파일 |
| Sync Changes | Pull과 Push를 이어서 처리 | 상태 표시줄 또는 Source Control | 가져오기·보내기가 모두 필요한지 |

현재 브랜치가 `main`이고 미커밋 변경을 정리한 경우의 예시입니다. 다른 브랜치라면 대상 브랜치를 바꿉니다.

```bash
git status --short --branch
git fetch origin
git log --oneline --left-right HEAD...origin/main
git pull --ff-only origin main
git push origin main
```

`--ff-only`는 이력을 앞으로 이동할 수 있을 때만 통합합니다. 양쪽에 서로 다른 커밋이 있으면 멈추므로 팀의 Merge·Rebase 기준을 확인합니다. 미커밋 파일은 검토해 Commit하거나 Stash로 보관한 뒤 Pull합니다. **Sync Changes가 충돌 해결·빌드·SAP 적용까지 완료해 주는 것은 아닙니다.** [원격 저장소 작업](https://code.visualstudio.com/docs/sourcecontrol/repos-remotes)

## 8. 팀 검토와 오류 확인

브랜치로 작업하는 팀은 `git switch -c docs/agent-guide`로 새 브랜치를 만듭니다. Commit 후 `git push -u origin docs/agent-guide`로 게시하고 GitHub 또는 PR 확장에서 Pull Request를 엽니다. 기준 브랜치와 차이를 검토한 뒤 담당자가 병합합니다. 기존 저장소의 브랜치 정책을 우선합니다.

| 메시지·상황 | 다음 확인 |
|---|---|
| Git을 찾을 수 없음 | Git 설치, VS Code 재시작, `git --version` |
| Please tell me who you are | 현재 저장소의 `user.name`·`user.email` |
| Repository not found / 권한 거부 | `git remote -v`, 로그인 계정, 저장소 접근·쓰기 권한 |
| No upstream branch | 현재 브랜치 확인 후 Publish Branch 또는 `git push -u origin "실제 브랜치명"` |
| Push rejected / non-fast-forward | Fetch 후 양쪽 커밋 비교·통합. 무조건 Force Push하지 않음 |
| 충돌 | 양쪽 변경 의도를 읽고 병합·저장·검사·Stage·Commit |
| 모든 줄이 바뀜 | 인코딩·줄바꿈·자동 포맷·Git 속성 확인 |

반복 오류는 명령 팔레트의 **Git: Show Git Output**에서 실패한 명령을 확인합니다. 비밀번호·토큰을 제외한 오류 문구, 브랜치, 원격, `git status`를 함께 기록합니다.

## 공유 완료 확인

GitHub에서 기대한 브랜치·커밋·파일을 확인하고 다른 PC에서도 Fetch·Pull 후 대조합니다. Pages 게시와 SAP 적용은 각각 실제 환경의 결과로 확인합니다. 다음 [로컬 에이전트 구성](#/learn/codex)에서 같은 Clone 폴더를 사용합니다.

## 자료 기준

공식 안내 확인일: 2026-10-24. 메뉴 이름은 버전·표시 언어에 따라 달라질 수 있습니다. 이 절차는 포털용 안내이며 과거 대화 원문을 재구성한 것이 아닙니다.

- 기존 근거: `sources/export-diag/references/PACKAGE_AGENT_BUILD_GUIDE.md`, `sources/export-diag/01_프로젝트_맥락과설계.md` §5.2·13
- [VS Code 소스 제어](https://code.visualstudio.com/docs/sourcecontrol/overview) · [GitHub 연동](https://code.visualstudio.com/docs/sourcecontrol/github) · [원격 작업](https://code.visualstudio.com/docs/sourcecontrol/repos-remotes)
