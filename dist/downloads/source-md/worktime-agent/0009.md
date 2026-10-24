# ZHR5 근로시간 업무 지식·Codex 스킬 묶음

업로드한 11개 원문(PDF 37쪽, TXT 11,576행)을 검토해 만든 **근거 기반 업무 지식 초안**이다.
KBS 근로시간·시간외실비·대휴·정산에 초점을 두며, 전체 ZHR5 소스나 인사 업무 전체를 분석한 결과는 아니다.

먼저 [설치 안내](docs/INSTALL.md)를 읽고 기존 GitHub 저장소 최상위에 병합한다. 기존 코드/추출 파일은 유지한다.

| 시작점 | 역할 |
|---|---|
| [AGENTS.md](AGENTS.md) | 공통 에이전트 지침 |
| [INDEX.md](knowledge/INDEX.md) | 질문별 문서 탐색 |
| [business-qa.md](knowledge/business-qa.md) | 빠른 업무 질의응답 |
| [출처 등록부](docs/SOURCE_REGISTER.md) | 원문 11개와 줄/페이지 근거·해시 |
| [AI 설명서](docs/AGENT_PROFILE.md) | 범위·가능한 일·한계 |
| [EXPORT_GUIDE.md](docs/EXPORT_GUIDE.md) | ABAP/XML/BSP/MIME를 해석하는 방법 |
| [SAP 객체 사전](docs/SAP_OBJECT_GLOSSARY.md) | 객체 종류의 의미 |
| [미확인 사항](knowledge/OPEN_QUESTIONS.md) | 오류 후보·상충·추가 자료 |
| [평가 질문 34개](tests/business-qa.md) | 기대 답변과 근거·채점 기준 |
| [검증 기록](docs/VALIDATION.md) | 실제 수행한 검증과 한계 |
| [지식 갱신 방법](docs/KNOWLEDGE_MAINTENANCE.md) | 새 자료와 코드 변경을 반영하는 순서 |

스킬은 `.agents/skills/`의 `zhr5-business-qa`, `zhr5-knowledge-curation`, `zhr5-change-impact` 세 개다. 각 `SKILL.md`는 실행 절차를, 업무 내용은 `knowledge/`가 맡는다.

## 주요 발견

- 2022년 매뉴얼의 최대/연장가능시간 설명 차이와 반차 FAQ 예시는 계산 전제를 추가 확인해야 한다. 공휴일 1일의 소정시간은 원문대로 152시간으로 정리했다.
- 대휴 기한·간주시간 합산·단가·휴가 반려 로직은 시점별 설명/정정/롤백을 구별했다.
- 카톡의 수정 완료는 완료 보고로 표기했고 실제 코드·배포·지급 검증과 구분했다.
- 함수·테이블은 문서상 후보만 연결했다. 사용자의 실제 ZHR5 코드에서 확인할 단계가 남아 있다.
- 사진/엑셀/메일/전화 내용이 카톡에 언급돼도 실물이 없는 것은 미확인이다. 별도 회의록은 업로드되지 않았다.

개인 식별정보는 정리본에서 최소화했다. 원본은 그대로 보존했으므로 기본 Git 제외 대상이다. 실무 담당자가 검토하기 전에는 새 공식 규정으로 취급하지 않는다.

## Obsidian 업무 관계 탐색

프로젝트 루트를 보관함으로 열고 [업무 관계 목차](maps/INDEX.md)에서 시작한다. 기준·협의·결정·소스·검증의 관계를 근거 위치와 함께 탐색한다. 기존 경로와 실행 코드는 유지한다. [파일·링크 조사](maps/FILE_SURVEY.md)에서 누락 원문 및 검사 결과를 확인한다.
