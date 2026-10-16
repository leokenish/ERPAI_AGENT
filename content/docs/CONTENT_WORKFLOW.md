# 콘텐츠 공동 관리

## 원본과 게시 콘텐츠

`sources/`는 변경 이유와 근거를 보존한다. 새 자료는 출처·일자가 드러나는 별도 묶음으로 추가한다. 기존 보존 파일을 최신 문서로 덮어쓰지 않는다.

`content/lessons/`는 팀원이 읽는 교육 콘텐츠다. 원천 문서를 그대로 자동 게시하지 않는다. 새 근거를 읽고 과거 결정을 대체하는지, 적용 시점이 다른지, 다른 시스템의 상태인지 판단하여 통합한다.

## 기존 과정 수정

1. 관련 MD와 `docs/INTEGRATION_REVIEW.md`의 기준을 확인한다.
2. 근거 파일과 확인 시점을 기록한다.
3. 본문·표·실습·관련 링크를 갱신한다.
4. `content/catalog.json`의 상태·설명·날짜·출처를 함께 갱신한다.
5. 발표 화면, 홈 요약, 구성도의 고정 문구에 영향을 주면 `site/app.js`도 갱신한다.
6. build·test와 관련 화면을 확인한다.
7. 변경 이유·검증 범위·남은 질문을 검토 기록에 남긴다.

## 새 과정 추가

`content/lessons/13-new-topic.md`처럼 영문·숫자·하이픈 파일명을 사용한다. 본문은 한국어로 쓴다. `catalog.json`의 lessons에 아래 필드를 추가한다.

```json
{
  "id": "new-topic",
  "file": "lessons/13-new-topic.md",
  "number": 13,
  "title": "새 과정 제목",
  "summary": "배우는 내용 한 문장",
  "group": "확장 설계",
  "status": "설계 단계",
  "tag": "주제",
  "source": "원천-id",
  "goals": ["학습 결과 1", "학습 결과 2"],
  "asOf": "YYYY-MM-DD"
}
```

`source`는 catalog의 sources에 등록한 항목을 참조한다. 그룹을 추가하면 groups에도 넣는다. 기존 번호를 바꾸면 교육 경로와 홈의 범위를 함께 확인한다. 현재 홈의 통계는 catalog에서 계산하므로 과정·원천 수는 자동 갱신된다.

## 홈에 노출할 항목

홈은 모든 상세 내용을 나열하는 화면이 아니라 선별한 학습 진입점이다. `site/app.js`의 `homeCases`는 현재 사례 3개, `expansion`은 과정 08·09를 지정한다. 새 사례의 제목·링크는 `caseItems`에 등록하면 사례 탭에 반영된다. 새 과정을 catalog에 등록하면 전체 과정에 표시되지만 홈 카드는 자동으로 늘어나지 않는다. 홈에 추가하거나 교체할 때는 이 두 목록과 학습 경로 문구를 함께 검토한다. 확장 과정의 제목·설명·구현 상태는 catalog에서 가져온다.

## MD 작성 규칙

- H1은 과정명 한 개, H2는 목차 단위, H3는 하위 설명이다.
- 표·목록·강조·코드 블록·링크·이미지를 지원한다.
- 임의 raw HTML은 실행하지 않고 텍스트로 표시한다.
- Mermaid 코드 자동 렌더링은 기본 기능에 포함되지 않는다. 필요한 그림은 SVG나 기존 구성도 데이터로 제작한다.
- 다른 과정은 `#/learn/과정-id`를 사용한다.
- 게시 이미지는 `assets/images/파일명.png`로 링크한다.
- 다운로드는 `downloads/파일명`으로 링크하고 catalog.downloads에 원본 위치를 등록한다.
- 상대 경로 공백 없이 영문 파일명을 권장한다. 원천 자료의 한국어 이름은 그대로 보존한다.
- 실제 제품 화면을 생성 이미지로 대체하지 않는다. 그림은 역할 설명, 캡처는 실제 동작 근거로 구분한다.

## 이미지와 예제

카탈로그에 허용한 실습 자료만 downloads에 복사된다. 원천 ABAP·진단 XLSX·기존 도구 HTML은 저장소에 보존하고 기본 배포에서 제외했다. 필요한 파일을 추가 게시할 때 실제 수신 대상과 교육 목적을 확인한다.

동일 기능의 프로그램 버전, 실행 환경, 검증 상태를 반드시 적는다. 새 버전이라고 운영 검증까지 완료된 것으로 표시하지 않는다.

## Codex 요청 예시

```text
sources에 추가한 이번 자료를 읽고 기존 교육 과정과 비교해줘.
원본은 그대로 보존하고, 변경 이유·효력일·구현/검증 상태를 구분해줘.
관련 content MD와 catalog, 발표·구성도 설명을 갱신해줘.
build와 test를 실행하고 변경된 화면을 확인해줘.
판단이 필요한 충돌은 근거를 제시하고 물어봐.
```

## 검토와 배포

팀의 GitHub 브랜치·PR 규칙에 맞춰 변경을 검토한다. 이 패키지에는 원격 push나 GitHub Actions 자동 배포를 설정하지 않았다. `git pull --ff-only` 후 build·test로 새 dist를 생성한다. 무중단 배포는 별도 구성 대상이다.

## 대화 추출 자료 추가

`docs/CONVERSATION_INTEGRATION.md`에 데이터 계약과 경로가 있다. 원본 JSON은 sources/conversations 아래에 보존하고, 포털용 설명은 content/conversations/catalog.json에서 관리한다. 새로운 자료의 원문·요약·재작성·미확보를 구분하며 과거 버전의 대화를 현재 검증 결과로 바꾸지 않는다. `npm run build`, `npm test`, `npm run preview:file`로 표시 자료·참조 검사·검토본을 함께 갱신한다.


사용자 발화의 게시 문체는 `content/conversations/editorial-prompts.json`에서 관리한다. 정중한 경어체로 다듬되 당시 요청·가정·판단·제약과 기술 식별자를 유지한다. 원문 및 AI 응답은 수정하지 않는다. 원문이 바뀐 경우 편집본을 재검토하고 `source_sha256`을 갱신한다. 단순히 해시만 교체하여 다른 발화의 편집본을 재사용하지 않는다.


## 발표 자료 갱신

`content/catalog.json`의 `slides`에서 section·title·subtitle, steps 3개(title/text), prompt, fieldNote(title/text), checkpoint(question/answer), lesson, links(label/href)를 함께 관리한다. prompt는 교육용 예시이며 원문 인용으로 바꾸지 않는다. links는 현재 과정 또는 대화 에피소드로 연결한다. 한 화면의 목표를 유지하면서 긴 설명은 상세 교육에 둔다. `site/presentation.js`가 텍스트를 안전하게 표시하고 타이핑·전체 표시를 처리한다. 빌드 후 `npm test`와 `npm run preview:file`로 검증·단독 미리보기를 갱신한다.


## 공유 대화 전문의 갱신

공유 추출 원본은 sources/conversations/20261013-shared에 보존하고, 현재 게시 데이터·해설은 content/conversations/export-full에서 편집한다. sourcePath와 assetSourcePath가 다를 수 있으므로 첨부 확인은 후자를 따른다. 새 사용자 문장에는 editorial-prompts의 교육용 문장과 원문 해시가 필요하다. 본문 없는 AI 응답은 unavailable로 표시하며 임의 생성하지 않는다. 노드별 기본 에피소드와 기존 에피소드 주소, 다운로드 문서의 확보 범위를 함께 검토한다.


## 근로시간 에이전트 MD 갱신

과정 11의 연결 지도는 `content/worktime-knowledge.json`에서 지정한 MD 스냅샷으로 빌드한다. 일반 source 폴더를 전부 게시하지 않으며 이 스냅샷에 등록한 MD만 다운로드로 제공한다. `docs/WORKTIME_KNOWLEDGE.md`의 가져오기·검토·빌드 절차를 따른다. 12번 과정의 기존 `#/learn/publishing` 주소는 유지한다.
