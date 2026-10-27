# v1.17.0 · 실제 MD로 따라 하는 05–07과정

작성·확인: 2026-10-27 (한국 시간). 기준: v1.16.2 Full ZIP.

## 반영한 요청

- 05 업무 맥락 만들기: 요청한 세 부분을 굵게 표시했다. 실제 README·AGENTS·세 SKILL의 역할, 추출 폴더 분석과 담당자 정정, 업무 문서에서 코드 위치로 가는 순서를 추가했다. 세 가지 문답 사례를 실물 기록에 근거해 재구성했고, 기존 SRC-11 사례는 유지했다. ‘6. 한계와 다음 방향’ 절을 삭제했다.
- 06 업무 지도 만들기: 사용자 요청의 ‘05 업무 지도’는 기존 공식 번호인 06으로 적용했다. DOCUMENT_INDEX와 INDEX의 차이, Codex로 조사·작성·검토하고 Obsidian에서 탐색하는 절차를 설명했다. 단가·누적시간 사례와 기존 적용 캡처 두 장을 연결했다.
- 07 업무 스킬 및 회귀: 정책 → AGENTS 연결 → 피드백 MD → 지식·스킬 보완 → 회귀 질문 → 검증 기록의 제작·사용 순서를 추가했다. 실제 네 피드백과 Q37–Q41의 의미를 설명한다.
- 세 과정에 HTML 파일 관계도를 추가했다. 링크는 자료실의 정확한 MD 경로 한 건을 표시하고 원래 파일명으로 다운로드한다. 파일 검색을 비우면 전체 목록으로 돌아간다.
- 세 과정 하단을 ‘근거 자료 확인’으로 바꾸고 부연 설명 없이 관련 MD 링크만 남겼다. ‘이 과정 자료’나 발표 모드는 추가하지 않았다.

## 근거와 구분

실제 문서 루트: `sources/github-erp-ai/520ac77046f5/`.

| 설명 | 확인한 근거 |
|---|---|
| README·AGENTS·세 SKILL | README.md, AGENTS.md, .agents/skills/zhr5-business-qa/SKILL.md, zhr5-knowledge-curation/SKILL.md, zhr5-change-impact/SKILL.md |
| 추출본 분석·담당자 확인 | knowledge/hr/overview.md, flows.md, docs/PACKAGE_AGENT_BUILD_GUIDE.md; 추출·진단 대화 SHARE-095/096, SHARE-099, SHARE-101/102, SHARE-111/112 |
| 두 목차와 지도 제작 | maps/DOCUMENT_INDEX.md, maps/INDEX.md, FILE_SURVEY.md, topics/rates.md, topics/selective.md, verification.md; Obsidian 대화 obs-m005/007/014/015 |
| 피드백 제작·사용 | docs/BUSINESS_FEEDBACK_POLICY.md, harness/feedback의 네 MD, tests/business-qa.md, docs/VALIDATION.md; SHARE-119–125 |
| 반차 입력 정정 | FB-20261001-001.md, knowledge/processes/overtime-start-time.md |
| 누적 표시의 결정 이유 | FB-20261008-001.md, knowledge/processes/selective-cumulative-display.md |
| 단가·직군 정정 | FB-20260923-001.md, FB-20260923-002.md, knowledge/policies/overtime-rate-20260901.md |

대화 원천은 `sources/conversations/20261013-shared/kbs-erp-export-diag-agents/` 및 기존 Obsidian 게시 대화와 대조했다. 초기 안내·사용자 구성 완료 보고·후속 실제 MD를 구분한다. 확인하지 않은 로컬 대화를 새 원문 발화로 만들지 않았다.

- AGENT.md 대신 실제·공식 파일명 AGENTS.md를 사용한다. README는 프로젝트 안내이며 자동 적용되는 공통 지침이라고 설명하지 않는다.
- SKILL은 요청에 맞춰 선택해 읽는 절차다. 규정 전체를 스킬에 복사하거나 세 스킬을 매번 모두 읽도록 설명하지 않는다.
- Obsidian은 이미 작성한 MD와 링크를 탐색한다. 폴더를 여는 것만으로 업무 목차가 생성된다고 설명하지 않는다.
- DOCUMENT_INDEX의 55개는 조사 시작 시점 수치다. 현재 스냅샷 전체 개수로 쓰지 않는다.
- harness/evals/cases·rubrics·Python은 정책의 확장 경로다. 이 스냅샷에서 확인된 harness MD는 피드백 네 건이고, 회귀 기준은 tests/business-qa.md다.
- 05 문답은 실제 문서를 바탕으로 한 재구성이다. 사용자·AI 원문과 표시용 대화 파일은 변경하지 않았다. 누적시간 사례는 오답을 새로 만들어 붙이지 않고 결정 이유와 탐색 경로 보완으로 설명한다.
- 포털은 MD 스냅샷이다. 원 저장소 ABAP·화면 파일의 확인 위치를 설명하지만, 없는 소스 다운로드나 SAP 실행 성공을 추가하지 않는다.

## 공식 문서 확인 · 2026-10-27

- [OpenAI AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md): 프로젝트 지침 탐색과 적용.
- [OpenAI Build skills](https://learn.chatgpt.com/docs/build-skills): SKILL.md의 이름·설명·본문, 요청별 선택과 .agents/skills 위치.
- [OpenAI 프로젝트 문서 구성 예시](https://developers.openai.com/cookbook/examples/codex/iterating-development-workflows-with-codex): AGENTS의 인식과 다른 파일의 프로젝트 관례 구분.
- [Obsidian 보관함](https://obsidian.md/help/manage-vaults), [링크](https://obsidian.md/help/links), [그래프](https://obsidian.md/help/plugins/graph): 기존 폴더 열기, Markdown 링크, 노트와 연결의 탐색.

## 구현과 보존

`content/lesson-trees.json`에 실제 파일 경로와 관계를 두고 `scripts/lesson-trees.mjs`가 빌드 시 존재·경로를 확인한다. 수업 Markdown의 `document-tree` 블록만 이 등록된 그림으로 표시한다. 원문 Markdown의 HTML 이스케이프와 기존 CSP는 유지한다. 새 외부 라이브러리·서비스·폰트는 없다.

자료 링크의 `file` 매개변수는 자료실의 정확한 상대 경로를 고른다. 같은 이름의 README나 SKILL이 다른 폴더에 있어도 함께 선택하지 않는다. 기존 전체 자료실·검색·ZIP 다운로드를 유지한다. 관계도 문구는 수업 검색과 오프라인 미리보기에 포함된다.

다른 13개 과정·6개 활용사례 도입부·원천·대화·첨부·기존 이미지·MD 다운로드 바이트를 보존했다. 삭제 파일은 없다. 이번에 삭제한 것은 05 본문의 지정 절뿐이다.

## 검증

- Node 24.22.1, `npm run build`, `npm run preview:file`, `npm test` 실행.
- 테스트 94개 통과. 기존 90개에 관계도·실제 MD 연결·정확한 파일 선택·렌더링 범위와 경로 방어 4개를 추가했다.
- 실제 브라우저에서 05·06·07 제목·목차·관계도, 강조 문구, 스킬 링크에서 자료실 한 건 표시, 검색 초기화 후 787개 복귀를 확인했다.
- 데스크톱과 390px 테스트 프레임에서 줄바꿈·가로 넘침을 확인했다. 좁은 본문은 clientWidth=scrollWidth=375px였다. 라이트·다크 관계도 표시를 확인했다.
- 원천 보존·변경 범위, 867개 소스 MD와 783개 업무지도 MD는 기존 테스트와 별도 비교로 확인했다.
- 검증 로그와 보존 결과는 `docs/validation/v1.17.0/`에 보관한다.

실제 휴대전화·사용자 PC의 file:// 실행·GitHub push·운영 배포·SAP 실행은 하지 않았다. 오프라인 생성과 재구성은 기존 테스트 범위에서 확인했다.

## 로컬 적용

변경분 ZIP은 v1.16.2 기준이다. `project/` 아래 파일을 로컬 저장소의 같은 상대 경로와 비교·병합한다. 기준 해시와 다르면 새 로컬 변경을 보존하며 대조한다. `.git`·사용자 설정·다른 작업은 덮어쓰지 않는다. 버전이 더 오래됐다면 전체 ZIP을 비교 기준으로 사용한다.

변경분과 전체 ZIP의 APPLY.md에 Codex Desktop용 적용·검증·GitHub push 프롬프트를 포함했다. 여기서는 커밋·push·배포를 수행하지 않았다.
