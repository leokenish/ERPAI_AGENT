# 기존 ZHR5 프로젝트에 넣는 방법

## 어느 폴더가 기준인가
**GitHub에서 clone한 ZHR5 프로젝트의 저장소 최상위**가 기준이다. 아래 경로는 모두 그 최상위에 대한 상대 경로다.
예를 들어 Mac 프로젝트가 `~/Projects/ZHR5_Agent`라면 `AGENTS.md`는 `~/Projects/ZHR5_Agent/AGENTS.md`, 스킬은 `~/Projects/ZHR5_Agent/.agents/skills/zhr5-business-qa/SKILL.md`에 둔다.
이 예시는 사용자의 실제 Mac 경로를 확인한 값이 아니다. ZIP 이름의 바깥 폴더 자체를 저장소 안에 한 단계 더 넣지 않는다.

| 가져올 파일/폴더 | 저장소에서의 위치 | 역할 |
|---|---|---|
| AGENTS.md | 최상위/AGENTS.md | 에이전트 공통 지침 |
| knowledge/ | 최상위/knowledge/ | 색인, 정책, 매뉴얼, 용어, 질의응답, 협의이력 |
| docs/ | 최상위/docs/ | AI설명서, 출처등록, export해석, 설치/검증 안내 |
| tests/business-qa.md | 최상위/tests/business-qa.md | 답변 품질 평가 |
| .agents/skills/ | 최상위/.agents/skills/ | 저장소에서 공유할 스킬3개 |
| sources/original/ | 최상위/sources/original/ | 업로드 원본11개, 기본로컬보관 |
| sources/text/ | 최상위/sources/text/ | 원문 줄번호 검색용TXT7개, 기본로컬보관 |
| templates/ | 최상위/templates/ | 새자료·회의록·협업 요청 형식 |
| .gitignore | 기존최상위.gitignore에필요항목병합 | 원본/개인정보포함자료의우발적공유방지 |

## 적용 순서
1. 기존 저장소에서 변경 중인 파일을 확인하고 이번 문서 추가용 브랜치를 만든다. 예: `knowledge/zhr5-working-time`.
2. ZIP을 풀고 위 매핑대로 복사한다. 기존 `packages/`, `catalog/`, `manifest.xml`, `.devhub/baseline`에는 이 묶음을 덮어쓰지 않는다.
3. 이미 `AGENTS.md`, `knowledge/INDEX.md`, `.gitignore` 또는 같은 스킬이 있으면 기존 내용과 비교해 필요한 내용을 병합한다. 기존에 만든 ZHR5 에이전트의 지침을 통째로 지우지 않는다.
4. Codex에서 **그 프로젝트를 열고** 새 대화를 시작한 뒤 `$zhr5-business-qa`처럼 호출한다. 스킬 목록에서 안 보이면 `.agents/skills/<이름>/SKILL.md` 배치와 frontmatter를 확인하고 프로젝트/세션을 다시 연다.
5. 아래 시작 요청을 실행해 실제 export와 코드 연결을 채운다. 이번 작업은 사용자의 Mac/GitHub 저장소에 직접 설치하거나 push한 것이 아니다.
6. `tests/business-qa.md`의 실제 업무 질문으로 답변을 비교하고 담당자가 정책·단가·미확인 사항을 검토한다.
7. 검토한 MD와 스킬 변경을 Git으로 공유한다. 원문은 기본적으로 제외되어 있다. 팀이 원문도 공유해야 한다면 접근 범위와 비식별화/별도 보관 방식을 정한 뒤 포함한다. 비공개 저장소라는 사실만으로 모든 원문 공개가 적절해지는 것은 아니다.

## Codex에 처음 줄 요청
> AGENTS.md와 knowledge/INDEX.md를 읽어줘. 기존 export에서 knowledge/code-map/working-time.md에 나온 함수·테이블·BSP가 실제로 있는지 검색해서 실제 경로와 확인 상태를 추가해줘. 추출 소스 자체는 바꾸지 말고, 외부 패키지나 미지원 클래스는 미확인 의존성으로 남겨줘. 다음으로 $zhr5-business-qa를 사용해 선택근무자의 시차실비 조회 근거와 주의점을 설명해줘.

## 스킬별 사용 예
- `$zhr5-business-qa`: “2026년6월 대화에서 간주와 선택 대휴 종료일이 다른 이유를 근거와 함께 설명해줘.”
- `$zhr5-knowledge-curation`: “새로 받은 운영지침을 읽고 기존 정책·미확인 항목·출처등록부를 갱신해줘. 시행일과 승인 상태를 구별해줘.”
- `$zhr5-change-impact`: “9월 단가 적용이 과거 입력과 월 정산에 미치는 영향을 검토하고 코드 후보와 회귀 사례를 정리해줘.”

## 다른 패키지로 확장
ZFI/ZMM 저장소에도 같은 **문서 분류와 근거 규칙**을 쓸 수 있다. 이 ZHR5 전용 규정·카톡 내용을 그대로 다른 업무의 정책으로 복사하지 않는다.
해당 업무 자료와 실제 코드 연결을 별도로 만들고 에이전트 역할과 스킬 이름을 맞춘다. 공통 SAP객체 사전·문서 상태 형식만 공통 저장소에서 관리할 수 있다.

## Codex 경로 참고
저장소 스킬 위치와 스킬의 점진적 로딩은 [Codex Skills](https://learn.chatgpt.com/docs/build-skills), 저장소 지침은 [AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md) 안내에 맞췄다.
일반 `knowledge/*.md`를 두는 것만으로 모델이 영구 학습하는 것이 아니며, 색인과 스킬이 필요한 파일을 찾아 읽도록 연결한다.
