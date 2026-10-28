# 업무 지도 만들기

## 1. 왜 지도가 필요한가

업무 자료가 모여도 어디부터 읽어야 할지는 쉽게 알 수 없습니다. “시간외 단가가 바뀌면 어디를 살펴봐야 하나요?”라는 질문 하나에도 규정, 과거 대화, 함수 설명이 각각 필요하기 때문입니다. 파일이 수백 개로 늘면 사람과 AI 모두 같은 탐색을 반복하게 됩니다.

따라서 질문에서 관련 자료로 찾아가는 길을 함께 정리합니다. 업무지도는 **질문 하나에서 기준·협의·코드·확인 사례로 이어지는 경로를 적은 문서**입니다. 각 링크에 “이 기준은 이 대화에서 정정됐고, 이 함수가 관련 값을 읽습니다”처럼 연결 이유를 남깁니다.

## 2. 무엇을 오해했는가

프로젝트에는 이미 skill·knowledge·harness·exports 폴더가 있었습니다. 그래서 Obsidian으로 폴더를 열면 업무 관계까지 정리되는지, AI도 같은 그래프를 보는지 질문이 이어졌습니다.

Obsidian은 MD 문서와 문서 안의 링크를 탐색하는 도구입니다. 업무의 관계는 먼저 문서에 작성하고, 그래프에서는 그 연결을 살펴봅니다. 즉 **사람은 노트와 그래프를 보고, AI는 같은 MD 본문과 링크를 읽습니다.**

이 역할을 나누면 무엇을 준비할지 분명해집니다. AI와 담당자는 자료의 의미와 연결 이유를 정리하고, Obsidian은 필요한 문서를 찾아 읽는 화면으로 활용합니다.

## 3. 어떤 방향을 택했는가

기존 파일을 새 폴더로 모두 옮기면 소스 경로나 스킬의 참조 위치가 달라집니다. 따라서 원래 위치를 유지하고 `maps/`에 연결 문서를 추가했습니다. 업무 하나부터 시작하면 관련 자료와 연결 이유를 검토하기도 쉽습니다.

| 구성 | 쉬운 역할 | 담을 내용 |
|---|---|---|
| INDEX | 첫 안내판 | 질문·주제별로 읽을 업무지도 |
| 업무별 지도 | 한 업무의 탐색 경로 | 기준·협의·구현·검증의 관계와 근거 |
| 소스 설명 MD | 프로그램의 안내문 | 객체의 역할·원본 위치·코드 설명 |
| Obsidian Vault | 문서를 여는 보관함 | 관련 자료가 모인 기존 프로젝트 폴더 |

좋은 지도는 연결 이유가 분명합니다. 파일 두 개에 링크를 거는 데서 끝내지 않고, 한 문서를 읽은 뒤 다른 문서로 가는 이유를 짧게 적습니다. 그러면 파일명을 모르는 사람도 업무 질문을 기준으로 필요한 자료를 찾을 수 있습니다.

## 4. 어떻게 만드는가

ZHR5에서는 기존 파일을 조사한 뒤 필요한 MD를 Codex로 작성하고, Obsidian에서 연결을 살펴봤습니다. **AI가 실제 파일을 읽어 연결 문서를 만들고, 담당자가 업무 관계를 검토한 다음, Obsidian으로 탐색하는 순서**입니다.

### 자료 목록과 질문별 목차

| 실제 파일 | 답해 주는 질문 | 작성 기준 |
|---|---|---|
| `maps/DOCUMENT_INDEX.md` | “어떤 문서가 있고 어디에 쓰이나요?” | 지침·스킬·업무 지식·피드백·평가 문서를 역할별로 목록화 |
| `maps/INDEX.md` | “이 업무 질문은 어디부터 읽나요?” | 질문을 근무유형·단가·휴가·정산 등으로 묶어 업무지도에 연결 |
| `maps/topics/*.md` | “이 업무의 기준·협의·코드는 어떻게 이어지나요?” | 링크별 연결 이유와 적용 시점 기록 |
| `maps/sources/*.md` | “어느 파일의 어느 부분이 구현을 담당하나요?” | 함수·화면·테이블 설명과 원본 경로·코드 위치 기록 |

`DOCUMENT_INDEX.md`는 파일을 기준으로 만든 자료 목록이고, `INDEX.md`는 질문을 기준으로 만든 업무 목차입니다. 둘을 나누면 자료를 관리하는 사람은 파일 목록을, 업무를 묻는 사람은 질문별 목차를 활용할 수 있습니다. ZHR5에서는 초기 MD 55개 조사에서 출발해 23개 업무군의 지도로 범위를 넓혔습니다.

### 1단계 · DOCUMENT_INDEX 작성

Codex에서 기존 프로젝트를 열고 README·AGENTS·SKILL·knowledge·harness·exports의 위치를 조사합니다. 기존 링크를 유지할 수 있도록 파일을 옮기지 않고, 경로와 역할을 `maps/DOCUMENT_INDEX.md`에 정리합니다.

```text
이 프로젝트의 실제 MD 파일을 조사해 maps/DOCUMENT_INDEX.md를 만들어 주세요.
각 문서의 경로, 역할, 어떤 질문에 필요한지를 표로 정리해 주세요.
README·AGENTS·SKILL·업무 지식·피드백·평가 자료를 구분해 주세요.
기존 파일은 이동하거나 복제하지 말고, 없는 파일은 목록에 추가하지 마세요.
조사한 시점과 범위를 maps/FILE_SURVEY.md에 남겨 주세요.
```

### 2단계 · 업무 질문별 INDEX 작성

“시간외 단가는 어디에서 찾나요?”, “누적시간은 왜 이렇게 표시하나요?”처럼 실제 업무 질문을 고릅니다. AI가 관련 문서를 찾으면 담당자가 업무 범위와 적용 시점을 대조합니다. 그다음 `maps/INDEX.md`에 업무 이름을 적고 주제별 MD로 연결합니다.

```text
문서 목록과 실제 내용을 바탕으로 maps/INDEX.md를 업무 질문별 목차로 만들어 주세요.
먼저 시간외 단가를 주제로 maps/topics/rates.md를 구성해 주세요.
기준·후속 정정·코드 설명·남은 확인 사항에 해당하는 실제 파일을 연결해 주세요.
각 링크에는 왜 관련이 있는지, 어느 시점의 근거인지 적어 주세요.
직접 호출과 관련 후보를 구분하고, 실제 읽은 파일의 경로를 함께 적어 주세요.
```

### 3단계 · 원문·코드 설명 연결

지도에서 기준 문서, 협의 기록, 소스 설명을 차례대로 엽니다. `maps/sources/`에는 함수·화면의 역할과 원본 위치를 적고, 각 설명이 업무지도와 자연스럽게 이어지는지 살펴봅니다. 조사 범위와 검토 결과는 `FILE_SURVEY.md`와 `verification.md`에 기록합니다.

```document-tree
maps-files
```

파일 관계도에서 MD 이름을 누르면 문서를 다운로드할 수 있습니다. 두 목차에서 주제별 지도와 소스 설명으로 이동하는 경로를 직접 읽어봅니다.

### Obsidian 설치와 프로젝트 열기

[공식 설치 안내](https://obsidian.md/help/install)에서 운영체제에 맞는 앱을 설치합니다. Windows는 설치 프로그램의 안내를 따르고, macOS는 앱을 Applications로 옮겨 실행합니다.

Vault 선택 화면에서 **Open folder as vault → Open**을 누르고 업무 문서와 maps가 있는 기존 프로젝트 폴더를 선택합니다. 다른 Vault를 열어 둔 상태라면 왼쪽 아래 **Manage Vaults** 메뉴에서 프로젝트를 선택합니다. [공식 Vault 안내](https://obsidian.md/help/manage-vaults)

먼저 `maps/DOCUMENT_INDEX.md`에서 문서 목록을 살펴봅니다. 이어서 `maps/INDEX.md`의 업무 하나를 골라 관련 문서로 이동합니다. 노트에서 `[[`를 입력하면 다른 노트를 찾을 수 있고, 기존 Markdown 링크도 열 수 있습니다. [공식 링크 안내](https://obsidian.md/help/links)

전체 관계는 왼쪽 리본의 **Open graph view**로 살펴봅니다. 현재 문서 주변의 연결만 보고 싶다면 명령 팔레트에서 **Open local graph**를 선택합니다. 그래프의 점은 노트, 선은 문서 안의 링크입니다. [공식 그래프 안내](https://obsidian.md/help/plugins/graph)

`.agents/skills/`의 스킬 문서는 VS Code나 Codex에서 해당 경로를 열어 읽습니다. 업무지도와 스킬 문서를 함께 보면 자료의 연결뿐 아니라 AI가 자료를 읽는 순서도 이해할 수 있습니다.

## 5. 실제 사례

### 5-1. 시간외 단가의 정책·코드 연결

**질문 · “시간외 단가를 바꾸면 어떤 기준과 프로그램을 살펴봐야 하나요?”**

Obsidian에서 `maps/INDEX.md`를 열고 ‘시간외 단가·직군·효력일’을 선택합니다. `rates.md`에서 기준 문서와 후속 정정을 먼저 읽은 다음 아래 소스 설명으로 이동합니다.

| 순서 | 여는 MD | 읽을 내용 |
|---|---|---|
| 1 | `knowledge/policies/overtime-rate-20260901.md` | 대상 직군과 적용일, 후속 정정 |
| 2 | `harness/feedback/FB-20260923-002.md` | 이전 설명에서 달라진 내용 |
| 3 | `maps/sources/ZHR_52TM_GET_PERSONNEL_DATA_N.md` | 근무일의 인사·등급을 읽는 구간 |
| 4 | `maps/sources/ZHR_52TM_CALC_NORM_OT_PAY.md` | 실비 계산과 관련된 코드 위치 |

단가가 같아도 적용일과 직군에 따라 처리 조건은 달라질 수 있습니다. 따라서 `rates.md`는 2026-09-01 기준과 후속 직군 정정을 먼저 설명하고, 인사·등급 조회 함수와 실비 계산 함수로 연결합니다. 검토에는 Q18·Q19·Q35·Q36 질문을 함께 활용합니다.

이처럼 **기준 → 정정 → 구현 → 검토 질문**을 따라가면, 숫자를 바꾸기 전에 관련 업무와 코드의 범위를 파악할 수 있습니다. [11. 근로시간 AI 에이전트 구축](#/learn/worktime-agent)의 문서 지도에서도 같은 MD를 찾아볼 수 있습니다.

### 5-2. 누적시간 표시 변경의 결정 배경

**질문 · “누적시간에 가산시간을 다시 포함한 이유는 어디에서 찾나요?”**

`maps/INDEX.md` → `maps/topics/selective.md` → `knowledge/processes/selective-cumulative-display.md` 순서로 읽습니다. 여기서 당시 협의와 결정 이유를 살펴본 뒤, 코드 설명과 `FB-20261008-001.md`로 이동합니다.

파일명만 검색하면 현재 표시 방식을 찾는 데 그칠 수 있습니다. 반면 이 경로를 따르면 표시를 되돌린 이유와 그 설명을 보완한 기록까지 함께 읽을 수 있습니다.

### 5-3. Obsidian 화면의 업무 탐색

다음 두 화면은 ZHR5 업무지도와 전체 연결망입니다. 질문에 답할 때는 업무별 지도를 사용하고, 자료의 전체 구성을 살펴볼 때는 전체 그래프를 활용합니다.

#### 업무 중심 지도

![Obsidian 업무지도. INDEX 주변에 settlement, selective, working-time, SRC 문서와 소스 유형별 색인이 연결되어 있습니다.](assets/images/obsidian-business-map.png)

| 화면에서 찾을 곳 | 탐색 방법 |
|---|---|
| `INDEX`와 `INDEX-DB테이블`, `INDEX-함수` | 업무 설명에서 구현 근거로 이동할 진입점을 선택합니다. |
| `settlement`, `selective`, `working-time` | 정산·선택근무·근로시간의 관련 문서를 읽습니다. |
| `SRC-10-early-SRC-11` 등 SRC 노드 | 설명의 근거가 된 협의 이력으로 이동합니다. |

예를 들어 정산 질문은 `settlement`에서 시작합니다. 이어서 관련 문서의 적용 조건·구현·출처를 읽으면 질문에 필요한 근거를 좁힐 수 있습니다.

#### 전체 문서 그래프

![Obsidian 전체 연결망. 문서의 노드와 군집으로 업무별 연결 규모와 중심 문서를 살펴봅니다.](assets/images/obsidian-full-graph.png)

전체 그래프에서는 연결이 집중된 문서와 주변에 떨어진 문서를 찾습니다. 이후 개별 질문은 업무별 지도에서 읽어야 많은 선과 점 사이에서 탐색 방향을 유지하기 쉽습니다.

> **직접 찾아보기** · 캡처에서 `settlement` → 업무 노드 → SRC 문서를 찾아보세요. 실제 Vault에서는 링크를 열어 관계 설명과 출처 날짜를 읽습니다.

## 6. 업무지도 활용과 관리

ZHR5의 지도는 23개 업무군·100개 단계·651개 정규 소스/데이터 설명으로 구성됐습니다. 자료가 늘어날수록 파일 수보다 질문에서 필요한 근거까지 이어지는 경로가 중요해집니다.

따라서 새 자료를 추가할 때는 관련 업무지도와 INDEX도 함께 갱신합니다. 대표 질문 하나를 골라 기준 문서와 후속 정정, 코드 설명까지 자연스럽게 이어지는지 살펴보면 관리할 위치를 찾기 쉽습니다.

다음 [07. 업무 스킬 및 회귀](#/learn/feedback)에서는 이 탐색 순서를 반복 작업의 절차로 만들고, 답변을 바로잡은 기록을 다음 질문에 활용하는 방법을 다룹니다.

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
