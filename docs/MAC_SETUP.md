# 맥 Node.js 운영 안내

## 1. 저장소와 실행 환경 확인

포털 저장소를 클론하고 Codex Desktop에서 그 폴더를 연다. Node.js 24 이상을 사용한다.

```bash
node --version
npm --version
npm run build
npm test
npm start
```

포털 자체는 `npm install` 또는 인터넷 CDN 다운로드 없이 빌드된다. 기본 웹 주소는 `http://127.0.0.1:8080`이다. 종료는 실행 터미널의 Ctrl+C다.

동봉된 중앙 자문 MCP 예제는 별도 프로젝트이며 `npm ci`와 Node.js 24+가 필요하다. 포털 실행과 혼합하지 않는다.

## 2. 팀원 접속

```bash
npm run start:lan
```

맥의 실제 사내 IP가 예를 들어 `10.x.x.x`라면 다른 PC에서 `http://<맥의_사내_IP>:8080`으로 접속한다. 맥의 시스템 네트워크 설정에서 IP를 확인한다. 특정 Wi-Fi 인터페이스명이 항상 en0라고 가정하지 않는다.

- 팀원 PC와 맥 사이 경로 및 8080 접속 허용이 필요하다.
- 고정 IP나 DHCP 예약은 사내 네트워크 담당 정책에 맞춰 구성한다.
- 맥이 잠자기·전원 종료·사내망 이탈 상태이면 접속할 수 없다.
- Codex Desktop을 닫아도 별도로 실행 중인 Node 서버는 계속 가동할 수 있다.

기존 MCP가 3000 포트를 쓸 수 있어 포털 기본값은 8080으로 구분했다. 포트가 이미 사용 중이면 아래처럼 변경한다.

```bash
PORT=8081 npm run start:lan
```

## 3. 사용자 로그인 후 자동 실행

먼저 터미널에서 실행한 서버를 Ctrl+C로 종료해 포트 중복을 피한다. 운영할 저장소 경로를 확정한 후 실행한다.

```bash
npm run service:install
npm run service:status
```

설치 시 현재 Node 실행 파일과 저장소의 절대경로를 기록한다. 사용자 LaunchAgent이므로 로그인 후 시작하며 기본적으로 LAN의 8080을 수신한다.

- plist: `~/Library/LaunchAgents/com.kbs.erp-ai-learning-portal.plist`
- 로그: `~/Library/Logs/erp-ai-portal/stdout.log`, `stderr.log`
- 권한: 현재 사용자, sudo 불필요
- 로그 순환은 자동 구성하지 않았다. 크기와 오류를 운영 시 확인한다.

```bash
npm run service:restart
npm run service:stop
npm run service:uninstall
```

`stop`은 현재 로그인 세션에서 등록을 내린다. 다시 시작하려면 `service:install`로 등록한다. 영구 등록 제거는 uninstall을 사용한다. Node 설치 위치나 저장소 경로가 바뀌면 install을 다시 실행한다.

환경변수는 설치 명령에 명시한다. 새 서비스에 터미널 환경이 자동 상속된다고 가정하지 않는다.

```bash
HOST=0.0.0.0 PORT=8081 npm run service:install
```

**재부팅 직후 로그인 전 서비스, FileVault 잠금 해제, 로그아웃 중 운영은 이 사용자 서비스가 보장하지 않는다.** 무인 상시 운영이 필요하면 사내 관리자와 시스템 서비스·전원 정책을 별도로 구성한다. 이 패키지에서 launchd 실행은 실제 맥에서 아직 검증하지 않았다.

## 4. KBS 도메인과 HTTPS

내부 DNS가 운영 맥 또는 기존 사내 프록시를 가리키게 설정한다. DNS만으로 포트나 인증서가 자동 구성되지는 않는다.

이 Node 서버는 기본 HTTP다. HTTPS가 필요하면 사내 인증서를 사용하는 기존 웹 프록시 등에서 TLS를 종료하고 포털로 전달한다. 도메인·인증서·방화벽·SSO 연결은 실제 환경을 확인한 뒤 구성한다. 클라이언트 인증이나 사용자별 권한은 이 정적 서버에 구현되어 있지 않다.

웹서버 루트는 dist만 사용한다. 저장소 전체·sources·.git·환경 파일을 문서 루트로 두지 않는다.

## 5. 수정과 배포

```bash
git status
git pull --ff-only
npm run build
npm test
```

변경된 MD를 빌드하면 목차·검색 데이터도 갱신된다. dist를 직접 고치지 않는다. 서버 코드가 바뀐 경우 서비스 재시작 후 확인한다.

페이지가 오래된 경우 브라우저 새로고침을 하고, 경로와 새 배포물이 맞는지 확인한다. 실패 시 이전 검토 커밋의 빌드 결과로 복구한다. 원본 자료나 사용자 변경을 강제로 reset하는 명령은 자동 수행하지 않는다.

## 6. 현장 확인 항목

1. 로컬 접속 및 `/health` 응답
2. 다른 사내 PC에서 홈·교육·검색·이미지·다운로드
3. 로그아웃/로그인·재부팅 후 사용자 로그인 시 서비스 상태
4. 잠자기 정책과 전원·유선망 가용성
5. DNS·HTTPS·필요한 사내 접근 제한
6. 새로운 MD를 pull·build한 뒤 교육 내용과 검색 반영

이 단계는 사내 현장에서 확인하고 결과를 docs/VALIDATION.md에 추가한다.
