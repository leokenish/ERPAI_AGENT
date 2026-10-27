# 업무 지도 만들기

## 1. 왜 지도가 필요한가: 문서를 모았는데 무엇부터 읽을지 모르겠다

업무 자료가 모여도 어디부터 읽어야 할지는 여전히 막막하다. “시간외 단가가 바뀌면 어디를 확인해야 하지?”라는 질문 하나에도 규정 폴더, 과거 대화, 함수 설명을 각각 찾아야 한다. 파일이 수백 개로 늘면 사람도 AI도 같은 탐색을 반복하게 된다.

업무지도는 **질문 하나에서 관련 기준·협의·코드·확인 사례로 찾아가는 길을 적은 문서**다. 규정을 복사해 모으기보다 “이 기준은 이 대화에서 정정됐고, 이 함수가 관련 값을 읽는다”는 연결 이유를 남긴다.

## 2. 무엇을 오해했는가: 폴더를 열면 관계가 저절로 생길까요?

실제 대화에서도 이 부분이 궁금했다. 이미 skill·knowledge·harness·exports가 있는데 Obsidian으로 열기만 하면 관계가 만들어지는지, AI도 그 그래프를 보는지, 답변 속도까지 빨라지는지 질문이 이어졌다.

Obsidian은 사람이 MD 문서와 링크를 탐색하는 도구다. 폴더를 보관함으로 연다고 업무의 의미까지 자동으로 정리되지는 않는다. **사람은 노트와 그래프를 보고, AI는 같은 MD 본문과 링크를 읽는다.** 그래프의 선은 두 문서가 연결됐다는 사실을 보여 준다. 왜 관련이 있는지는 문서에 따로 적어야 한다.

설치만으로 AI 모델의 계산 속도가 빨라지는 것은 아니다. 필요한 자료를 먼저 찾도록 돕는다면 탐색 부담은 줄일 수 있다. 실제로 시간이 얼마나 줄었는지는 같은 질문으로 비교해야 한다.

## 3. 어떤 방향을 택했는가: 기존 폴더를 유지하고 길 안내를 추가하기

자료를 새 폴더 구조로 모두 옮기면 소스 경로나 스킬에서 참조하는 위치가 달라질 수 있다. 그래서 기존 위치는 유지하고 `maps/`에 연결 문서를 추가하기로 했다. 업무별로 작게 시작하면 어떤 자료를 연결했고 어느 부분이 오래됐는지 관리하기도 쉽다.

| 구성 | 쉬운 역할 | 담을 내용 |
|---|---|---|
| INDEX | 첫 안내판 | 질문·주제별로 읽을 업무지도 |
| 업무별 지도 | 한 업무의 찾아가는 길 | 기준·협의·구현·검증의 관계와 근거 |
| 소스 설명 MD | 프로그램을 읽기 전 안내문 | 객체의 역할·실제 원본 위치·확인 범위 |
| Obsidian Vault | 문서를 여는 보관함 | 관련 자료가 모인 기존 프로젝트 폴더 |
| 미확인 목록 | 길이 끊긴 지점의 기록 | 미추출 코드·없는 원문·추가 확인할 담당 |

좋은 지도는 링크의 수보다 연결 이유가 분명하다. “관련 있음”이라고만 표시하지 않고, 두 자료가 어떻게 이어지는지 말로 설명할 수 있어야 한다.

## 4. 어떻게 만드는가: 파일 목록과 업무 목차를 따로 만들기

ZHR5에서는 먼저 기존 파일을 조사하고, 필요한 MD를 Codex로 작성한 다음 Obsidian에서 연결을 확인했다. Obsidian이 업무를 분석해 두 목차를 자동으로 만든 것은 아니다. **AI가 실제 파일과 내용을 읽고 연결 문서를 만들고, 담당자가 연결 이유를 검토한 뒤, Obsidian으로 그 관계를 탐색한 것**이다.

### 두 INDEX는 왜 따로 필요했나

| 실제 파일 | 답해 주는 질문 | 만드는 기준 |
|---|---|---|
| `maps/DOCUMENT_INDEX.md` | “어떤 문서가 있고, 각각 어디에 쓰이나?” | 실제 MD를 조사해 지침·스킬·업무 지식·피드백·평가 등 역할별로 목록화 |
| `maps/INDEX.md` | “이 업무 질문은 어디부터 읽어야 하나?” | 질문을 근무유형·단가·휴가·정산 등의 주제로 묶어 업무지도에 연결 |
| `maps/topics/*.md` | “이 업무의 기준·협의·코드는 어떻게 이어지나?” | 파일 링크에 연결 이유·적용 시점·확인한 범위를 함께 기록 |
| `maps/sources/*.md` | “실제 구현은 어느 파일의 어느 부분인가?” | 함수·화면·테이블 설명과 원본 경로·확인한 코드 위치를 기록 |

`DOCUMENT_INDEX.md`는 자료 목록이고 `INDEX.md`는 질문별 길 안내다. 둘을 나누면 파일명을 모르는 사람도 업무 이름으로 시작할 수 있다. 실제 조사 기록에는 작업 시작 시점의 MD 55개를 목록화했다고 남아 있다. 이후 지도는 23개 업무군으로 확장됐으므로 55개를 현재 전체 문서 수로 읽으면 안 된다.

### 1단계 · 현재 폴더를 조사해 DOCUMENT_INDEX 만들기

Codex에서 기존 프로젝트를 연 뒤 README·AGENTS·SKILL·knowledge·harness·exports의 파일 위치를 확인한다. 이때 파일을 새 폴더로 옮기지 않는다. 기존 링크를 유지하면서 문서 경로와 역할을 `maps/DOCUMENT_INDEX.md`에 적는다.

```text
이 프로젝트의 실제 MD 파일을 조사해 maps/DOCUMENT_INDEX.md를 만들어 주세요.
각 문서의 경로, 역할, 어떤 질문에 필요한지를 표로 정리해 주세요.
README·AGENTS·SKILL·업무 지식·피드백·평가 자료를 구분해 주세요.
기존 파일은 이동하거나 복제하지 말고, 없는 파일은 목록에 추가하지 마세요.
조사한 시점과 범위를 maps/FILE_SURVEY.md에 남겨 주세요.
```

### 2단계 · 업무 질문으로 INDEX와 개별 지도 만들기

“시간외 단가는 어디서 확인하지?”, “누적시간은 왜 이렇게 표시하지?”처럼 실제 질문을 고른다. AI가 관련 문서를 찾으면 담당자가 같은 업무인지, 현재 기준과 과거 협의를 섞지 않았는지 확인한다. 정리한 업무 이름을 `maps/INDEX.md`에 넣고 주제별 MD로 연결한다.

```text
문서 목록과 실제 내용을 바탕으로 maps/INDEX.md를 업무 질문별 목차로 만들어 주세요.
먼저 시간외 단가를 주제로 maps/topics/rates.md를 구성해 주세요.
기준·후속 정정·코드 설명·남은 확인 사항에 해당하는 실제 파일을 연결해 주세요.
각 링크에는 왜 관련이 있는지, 어느 시점의 근거인지 적어 주세요.
확인한 직접 호출과 단순 관련 후보를 구분하고, 추출되지 않은 파일은 미확인으로 남겨 주세요.
```

### 3단계 · 원문과 코드 설명으로 연결 확인하기

지도에서 기준 문서, 협의 기록, 소스 설명을 하나씩 열어 본다. `maps/sources/`에는 함수·화면의 역할과 원본 위치를 적는다. 링크가 존재한다는 사실과 실제 업무 설명이 맞다는 판단은 따로 확인한다. 빠진 자료와 오래된 연결은 `FILE_SURVEY.md`·`verification.md`에 남긴다.

```document-tree
maps-files
```

트리는 두 목차에서 어떤 자료를 찾아가는지 보여 준다. 연결선은 문서 탐색 관계이며 실제 SAP 프로그램의 호출 순서는 아니다. 평가 질문은 검토할 때 읽고, 일반 업무 답변의 정답 근거로 대신 사용하지 않는다.

### Obsidian에서 기존 폴더 열기

[공식 설치 안내](https://obsidian.md/help/install)에서 운영체제에 맞는 앱을 설치한다. Windows는 설치 프로그램의 안내를 따르고, macOS는 앱을 Applications로 옮겨 연다.

Vault 선택 화면에서 **Open folder as vault → Open**을 누르고 업무 문서와 maps가 들어 있는 기존 프로젝트 폴더를 선택한다. 이미 다른 Vault를 열었다면 왼쪽 아래 Vault 메뉴의 **Manage Vaults**에서 선택할 수 있다. 파일을 새 보관함으로 옮길 필요는 없다. [공식 Vault 안내](https://obsidian.md/help/manage-vaults)

먼저 `maps/DOCUMENT_INDEX.md`에서 기존 문서가 보이는지 확인하고, `maps/INDEX.md`에서 업무 하나를 골라 링크를 따라가 본다. 노트 안에서 `[[`를 입력하면 다른 노트를 찾을 수 있고, 기존 Markdown 링크도 그대로 열 수 있다. [공식 링크 안내](https://obsidian.md/help/links)

그다음 왼쪽 리본의 **Open graph view**로 전체 관계를 보거나, 명령 팔레트의 **Open local graph**로 현재 노트 주변만 살펴본다. 점은 노트, 선은 문서 안의 링크다. [공식 그래프 안내](https://obsidian.md/help/plugins/graph)

숨김 폴더인 `.agents/skills/`는 Obsidian 그래프에서 보이지 않을 수 있다. 파일을 옮기지 말고 VS Code나 Codex에서 실제 경로를 확인한다. 그 뒤에 그래프를 보면 선이 무엇을 연결하는지 이해하기 쉽다. 폴더 열기·링크·그래프 메뉴는 2026-10-27 공식 안내에서 확인했다.

## 5. 실제 사례: 단가 질문에서 정책·코드·검증으로

### 5-1. 실제 확보된 rates.md 읽기

**따라 할 질문 · “시간외 단가를 바꾸면 어떤 기준과 프로그램을 확인해야 하나요?”**

Obsidian에서 `maps/INDEX.md`를 열고 ‘시간외 단가·직군·효력일’을 선택한다. `rates.md`에서 기준 문서와 후속 정정을 먼저 읽은 다음, 아래 소스 설명으로 내려간다.

| 순서 | 실제로 여는 MD | 확인할 내용 |
|---|---|---|
| 1 | `knowledge/policies/overtime-rate-20260901.md` | 대상 직군과 적용일, 후속 정정 |
| 2 | `harness/feedback/FB-20260923-002.md` | 이전 설명에서 무엇이 달라졌는지 |
| 3 | `maps/sources/ZHR_52TM_GET_PERSONNEL_DATA_N.md` | 근무일의 인사·등급을 읽는 구간 |
| 4 | `maps/sources/ZHR_52TM_CALC_NORM_OT_PAY.md` | 실비 계산과 관련된 코드 위치 |

이 경로를 따라가면 “단가 숫자 하나를 바꾸면 된다”에서 끝나지 않고, 적용일·직군·계산 경로와 추가로 확인할 운영값을 함께 정리할 수 있다.


근로시간 프로젝트의 `maps/topics/rates.md`는 단가와 직군·효력일을 연결한다. 먼저 2026-09-01 기준 문서를 읽고, 후속 직군 정정과 과거 협의를 구분한다. 이어 근무일의 인사·등급을 읽는 함수, 실비를 계산하는 함수의 설명으로 연결한다.

지도에는 과거 입력 보정과 실제 지급 확인이 아직 끝나지 않았다는 점도 남아 있다. Q18·Q19·Q35·Q36 검증 질문으로 이어지지만, 질문을 연결한 것과 검사를 통과한 것은 다르다. 업무 답변의 근거는 기대 답안이 아니라 실제 정책·협의 자료에서 확인한다.

이처럼 하나의 질문에서 **기준 → 정정 → 구현 → 남은 확인**을 따라갈 수 있으면 지도가 제 역할을 한다. [11. 근로시간 AI 에이전트 구축](#/learn/worktime-agent)의 문서 지도에서도 실제 MD를 찾아볼 수 있다.

### 5-2. 표시를 되돌린 이유까지 찾아가기

**따라 할 질문 · “누적시간에 가산시간이 다시 들어간 이유를 어디서 찾나요?”**

`maps/INDEX.md` → `maps/topics/selective.md` → `knowledge/processes/selective-cumulative-display.md` 순서로 연다. 여기서 당시 결정 이유와 10월 8일 보완 기록을 읽고, 코드 설명과 `FB-20261008-001.md`로 이동한다. 파일명만 검색했을 때 놓치기 쉬운 ‘왜 되돌렸는가’라는 배경까지 확인하는 사례다.

### 5-3. 실제 Obsidian 화면으로 찾기

실제 적용 화면 2장을 살펴본다. 첫 지도에서는 업무와 근거를 따라 읽고, 전체 그래프에서는 문서가 얼마나 넓게 연결됐는지 살펴본다.

#### 업무를 중심으로 읽는 지도

![사례 1 · 실제 Obsidian 업무지도. INDEX 주변에 settlement, selective, working-time, SRC 문서와 소스 유형별 색인이 연결되어 있다. 클릭하면 확대할 수 있다.](assets/images/obsidian-business-map.png)

| 화면에서 찾을 곳 | 업무 탐색에 활용하는 방법 |
|---|---|
| `INDEX`와 `INDEX-DB테이블`, `INDEX-함수` 등 | 업무 문서에서 구현 근거를 찾을 진입점을 고른다. |
| `settlement`, `selective`, `working-time` | 정산·선택근무·근로시간의 관련 문서를 탐색한다. |
| `SRC-10-early-SRC-11` 등 SRC 노드 | 정리 문장의 근거가 된 협의 이력으로 돌아간다. |
| `OPEN_QUESTIONS`, `open-questions` | 미확인 사항이 확정된 지식과 섞이지 않도록 확인한다. |

정산 질문은 `settlement`에서 시작해 연결 문서의 적용 조건·구현·출처를 확인한다. 캡처의 색상 분류 규칙은 미확인이다.

#### 전체 규모를 살펴보는 그래프

![사례 2 · 실제 Obsidian 전체 연결망. 촘촘한 노드와 군집을 통해 연결 규모와 중심부·주변부를 살펴보는 화면이다.](assets/images/obsidian-full-graph.png)

전체 그래프에서 연결이 집중된 곳과 떨어진 문서를 찾고, 개별 질문은 업무별 지도로 좁혀 읽는다. 현재 자료는 적용 캡처이며 링크 유효성과 성능은 추가 확인 대상이다.

> **직접 찾아보기** · 캡처에서 `settlement` → 업무 노드 → SRC 문서를 찾아보세요. 실제 Vault에서는 링크를 열어 관계 설명과 출처 날짜를 확인합니다.

## 6. 한계와 다음 방향: 연결의 수보다 연결의 정확성

초기 대화에서는 설계를 논의했고, 후속 자료에서는 실제 `maps/` 문서와 적용 캡처를 확보했다. 당시 검증 기록에 남은 정리 범위는 23개 업무군·100개 단계·651개 정규 소스/데이터 설명이다. 이 수치가 모든 업무 규칙이나 SAP 실행을 검증했다는 뜻은 아니다.

포털의 MD 스냅샷에는 소스 설명 문서가 있지만, 그 문서가 가리키는 ABAP 원본 전체가 들어 있지는 않다. 실제 코드 확인에는 해당 추출본이 필요하다. 링크가 열리는지 확인하는 검사와 설명이 업무적으로 맞는지 검토하는 작업도 구분해야 한다.

처음 만든 지도는 질문 하나로 시험해 본다. 필요한 문서를 찾는 데 도움이 되는지, 후속 정정을 놓치지는 않는지, 부족한 근거가 구체적으로 드러나는지 확인한다. 다음 [07. 업무 스킬 및 회귀](#/learn/feedback)에서는 이 탐색 순서를 반복 가능한 절차로 만들고, 틀린 답을 바로잡는 방법을 다룬다.

## 근거 자료 확인

- [maps/DOCUMENT_INDEX.md](#/library/worktime-agent?file=maps%2FDOCUMENT_INDEX.md)
- [maps/INDEX.md](#/library/worktime-agent?file=maps%2FINDEX.md)
- [maps/FILE_SURVEY.md](#/library/worktime-agent?file=maps%2FFILE_SURVEY.md)
- [maps/topics/rates.md](#/library/worktime-agent?file=maps%2Ftopics%2Frates.md)
- [maps/topics/selective.md](#/library/worktime-agent?file=maps%2Ftopics%2Fselective.md)
- [maps/sources/INDEX.md](#/library/worktime-agent?file=maps%2Fsources%2FINDEX.md)
- [maps/sources/ZHR_52TM_GET_PERSONNEL_DATA_N.md](#/library/worktime-agent?file=maps%2Fsources%2FZHR_52TM_GET_PERSONNEL_DATA_N.md)
- [maps/sources/ZHR_52TM_CALC_NORM_OT_PAY.md](#/library/worktime-agent?file=maps%2Fsources%2FZHR_52TM_CALC_NORM_OT_PAY.md)
- [maps/verification.md](#/library/worktime-agent?file=maps%2Fverification.md)
- [knowledge/processes/selective-cumulative-display.md](#/library/worktime-agent?file=knowledge%2Fprocesses%2Fselective-cumulative-display.md)
