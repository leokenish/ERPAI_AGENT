# ITS Chrome v3 검토 증빙

실제 브라우저나 SAP 서버를 호출하지 않는 소스/DOM 모델 회귀 검증입니다.

- `baseline/`: 이번 작업 직전 제공 버전 + 새 HTML
- `modified/`: v3 전체 100개 파일
- `original/`: 제공받은 원본 100개 파일
- `changes.diff`, `manifest.json`: 이번 변경과 SHA-256
- `validation.json`: V8 모의 회귀 186건
- `markup_validation.json`: HTML/CSS 구조 및 직렬화 검증
- `integration_validation.json`: 최소 DOM 모델의 스크립트 로드 순서 검증

Node.js 24와 Python 3에서 같은 폴더를 기준으로 실행합니다. `analyze.js`는 이전 검증과 동일한 Node 내장 Acorn 경로를 사용합니다.

```sh
node verify.js
python3 verify_markup.py
node integration.js
```

Cloud Chrome의 로컬 페이지 접근은 승인 검토에서 거절되어 실제 브라우저 검증을 실행하지 못했습니다. 이미지 리소스, IAC generator/splitter, 업무 화면 HTML, SAP 응답/데이터는 이 모형에서 대체하거나 검증하지 않습니다.
