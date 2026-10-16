# 교육대화 추출 자료 안내

- **프로젝트명:** SAP 패키지 추출·읽기 전용 진단 및 업무 AI 에이전트 구축
- **project_id:** `kbs-erp-export-diag-agents`
- **추출 기준일:** 2026-10-12 (Asia/Seoul)
- **확보 수준:** **partial — 일부 실제 대화 + 실제 파일 + 기존 요약 자료**. 전체 원문 확보본이 아니다.
- **범위:** 대화방 1개, 발화 98개(사용자 92개 / assistant 6개), 학습 단계 18개, 실제 포함 자산 53개(이미지 22개). 미포함·미확보 자산 항목 34개.

## 1. 무엇을 실제로 확인했는가

현재 프로젝트의 ZMM6 Export 오류 요청부터 반복 교육자료 추출 요청 U093까지 보이는 사용자 발화를 보존했다. 이 사이의 대부분의 과거 AI 답변 원문은 현재 보이지 않는다. 이전 교육 ZIP 응답 4개와 이번 작업 중 원문이 현재 보이는 진행 안내 2개만 assistant 메시지로 포함했다. 사용자 요청의 반복(U030/U031, U092/U093)은 각각 남겼다. 이미지뿐인 발화는 텍스트를 만들지 않았다.

Export 0.3.18, DIAG 0.4.5, CHECK 0.3.3, 기존 지침·스킬·요약 MD, 과거 Import·GitHub 테스트 ZIP, 실제 오류 PNG, ICM 로그, ZHR5 결과 엑셀을 확보하여 열람했다. 기존 요약 ZIP도 다시 열었으나 통째로 중복 배포하지 않았다. **파일을 읽었다는 사실과 그 버전을 SAP에서 실행 검증했다는 사실은 다르다.**

대화의 최초·최종 날짜는 일부만 확인된다. U093만 제출 시각 `2026-10-12T15:38:00+09:00`이 확인되어 기록했고 나머지는 null이다. 파일 안 날짜·버전, 파일명의 날짜, 업로드 시간은 메시지 timestamp에 대입하지 않았다. 자체 ID는 U002부터 시작하며 원래 플랫폼 ID가 아니다. 번호 자체로 빠진 실제 발화 수를 추정하지 않는다.

## 2. 원문 보존 규칙

- `content_type=verbatim`: 현재 확인 가능한 본문을 전사했다. 줄바꿈·바깥 여백은 정리했으나 오타, 잘못된 가설, 반복, 수정 요구를 바꾸지 않았다. 플랫폼 원시 바이트 export는 아니다.
- 실제 발화는 `threads.messages`, 교육 해설은 `episodes.commentary_markdown`, 재작성 실습은 `episodes.exercise_markdown`에 있다. 기존 MD의 요약을 assistant 발화로 바꾸지 않았다.
- “Codex could not read the local image…”는 첨부 표시 오류로 보고 `capture_notes`로 분리했다. 사용자 본문과 혼동하지 않는다. 원본 PNG 확보 여부는 개별 assets가 권위 있는 목록이다.
- 당시 발화의 sandbox 링크는 원문 그대로다. 포털에서는 해당 오래된 링크를 새 다운로드 주소로 간주하지 말고 연결 `asset_ids`와 현재 `path`를 사용한다.
- `availability=unavailable`은 **이번 ZIP 안에 배포본이 없음**을 뜻한다. 원본 미확보와 개인정보/중복 때문에 제외한 자료를 `original_acquired`, `exclusion_reason`으로 구분했다. 원본 미확보 이미지를 새로 만들지 않았다.
- 추가 필드 `sha256`, `source_sha256`, `derivative`, `redacted`는 배포본·원본·마스킹 추적용이다. 요구된 표준 필드는 유지했다.

## 3. 먼저 읽을 순서와 파일 용도

| 순서 | 파일 | 용도 |
|---|---|---|
| 1 | [00_README.md](00_README.md) | 확보 수준·누락·데이터 사용 규칙 |
| 2 | [01_PROJECT_CONTEXT.md](01_PROJECT_CONTEXT.md) | 출발점·변화·현재 결정·오류·검증 경계 |
| 3 | [02_LEARNING_GUIDE.md](02_LEARNING_GUIDE.md) | 18개 단계, 단계마다 11개 학습 항목 |
| 4 | [conversation-data.json](conversation-data.json) | 채팅 말풍선·구성도 노드·첨부 연결 데이터 |
| 5 | [실제 발화 읽기용 MD](assets/conversation/visible_messages.md) | JSON 없이 ID별 원문 읽기 |
| 6 | [03_ASSET_CATALOG.md](03_ASSET_CATALOG.md) | 포함·미확보·제외 자산 전체 목록 |
| 7 | [04_VALIDATION_REPORT.md](04_VALIDATION_REPORT.md) | 이번 ZIP의 구조 검증 결과·한계 |

`assets/code/`는 현재 프로그램, `assets/history/`는 과거 실험 버전, `assets/images/`는 실제 캡처, `assets/logs/`는 마스킹 로그, `assets/results/`는 실제 Excel 셀 발췌, `assets/references/`는 기존 문서·스킬, `assets/examples/`는 합성 실습과 기존 분석, `assets/tools/`는 검사 도구다. 기존 프로그램·문서 본문은 수정하지 않았다. 파생 파일은 이름·설명에 명시했다.

## 4. 빠진 내용과 추가로 필요한 자료

- U002–U090에 대응하는 당시 AI 답변 원문 대부분 및 이 구간 이전 최초 설계 대화. 현재 요약만으로 복원하지 않음.
- 실제 플랫폼 메시지 ID·옛 메시지별 정확한 날짜/시각. 파일명 날짜나 업로드일로 보충하지 않음.
- 현재 result.xlsx와 대응하는 원본 Export 전체 ZIP 및 DIAG 0.4.5의 실제 SAP 실행 JSON·최신 화면.
- 중간 오류 버전의 모든 ABAP 수정본·정확한 diff 및 각각의 재실행 결과.
- 사용자 Mac의 현재 저장소·브랜치·설치된 Codex/스킬/하네스·Actions 실행 로그.
- 이전 업로드 업무 원문 PDF·카톡·매뉴얼·규정·양식 전체. 기존 지식 문서 사본과 구분.
- 개인 식별정보가 있거나 검토를 마치지 못해 배포 제외한 화면·Office 원본. assets의 original_acquired/exclusion_reason 참고.
- 이번 추출 중 원문이 현재 남아 있지 않은 초기 진행 안내와 도구 호출 기록. 도구·시스템·환경 메시지는 채팅 발화 범위에서 제외.
- 다른 대화방의 MCP·Obsidian·협업·웹 전환 상세. 메모리나 검색 요약을 실제 발화로 편입하지 않음.

다음 자료가 있으면 교육 품질을 크게 높일 수 있다: (1) 당시 AI 답변까지 포함한 플랫폼 대화 export, (2) DIAG 0.4.5 실행에 사용한 ZIP·manifest·실제 JSON·화면과 실행 조건, (3) 대표 함수/Include·XML 차이의 원본 세 자료, (4) 담당자 승인 QA·하네스 실행 기록, (5) 현재 Git 저장소의 commit과 workflow 로그. 필수 자료가 없더라도 이번 확보 범위의 학습은 가능하다.

## 5. 제외한 파일과 이유

핵심 파일은 포함했고 제외 항목을 조용히 버리지 않았다. 상세 이름·발화 연결·이유는 [전체 목록](03_ASSET_CATALOG.md)에 있다.

- 원본 result.xlsx: 실제 읽었다. 불필요한 Office 작성자 정보를 배포하지 않기 위해 RawData 전체를 셀 단위 JSON으로 제공한다. 2,541개 데이터 행을 임의로 줄이지 않았다. 원래 잘린 문자열은 복원하지 않았다.
- 일부 화면: 계정/사용자 경로가 있거나 전체 개인 식별정보 검토를 마치지 못해 원본 배포를 제외했다. 최종 완성 UI 화면이 있다고 주장하지 않는다.
- 이전 4-MD ZIP: 중복 및 내부 개인 식별정보 때문에 통째로 재배포하지 않았다. 핵심 코드·가이드·스킬·맥락을 선별 포함했다. 이전 MD의 원문 대체물을 만들었다고 주장하지 않는다.
- 과거 diff_result 두 Excel: 확보했으나 정확한 실행 버전·발화 대응이 확정되지 않아 최신 실제 RawData 사례를 우선했다.
- 업무 원문 PDF·카톡 전문·대응 전체 Export ZIP: 이번에 전량 확보·검토한 자료가 아니다.

## 6. 교육 포털 연결 시 주의할 점

`map_nodes`는 sap/export/git/knowledge/codex/diag/feedback/portal에 실제 관련된 단계만 연결했다. MCP·Obsidian·Telegram을 이 프로젝트의 구현 성과로 추가하지 않았다. 연결 UI는 이 JSON을 데이터로 사용하되 Markdown/HTML을 안전하게 렌더링하고, availability가 unavailable이면 “원본 미확보” 또는 구체적 제외 사유를 표시한다. 기존 CHECK HTML은 이전 도구이지 새 포털 소스가 아니다.

같은 프로젝트의 이전 ZIP과 주제가 중복될 수 있다. 현재 문서는 실제 대화 중심이며 이전 요약의 확보 한계를 이번에 확보한 로그·화면으로 일부 보완했다. 다른 프로젝트 통합에서는 project_id·발화 ID를 함께 키로 사용한다. 파일 버전 충돌을 날짜 이름만으로 덮어쓰지 않는다.

## 7. 로컬 확인

압축을 풀고 이 README가 있는 폴더에서 실행한다. Python 3.9 이상이 필요하다. 두 스크립트는 SAP/네트워크에 접속하지 않는다.

```sh
python3 assets/tools/validate_bundle.py
python3 assets/examples/compare_cases.py
```

첫 명령은 교육 파일 구조를, 둘째는 합성 세 비교 예제를 검사한다. 코드의 SAP 문법·활성화·운영 검증을 수행한 명령은 아니다. 웹사이트 구현·서버 설치·GitHub push는 이번 작업에서 수행하지 않았다.
