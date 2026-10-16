# 파일·기존 링크 조사

[업무 관계 목차](INDEX.md) · [기존 문서 전체 목차](DOCUMENT_INDEX.md)

조사일: 2026-10-07. 기준 Git HEAD: `16f74f8023b27cc819c2b6ca4644bd6d1cff1f36`. 작업 시작 상태는 clean이었다.

## 전체 파일 목록

[작업 전 전체 파일 목록](audit/files-before.csv)에 **5,133개** 파일의 상대경로·크기·확장자·분류·SHA-256을 기록했다. 숨김 파일과 baseline을 포함하고 Git 내부 객체 저장소 `.git`만 제외했다. baseline·바이너리는 목록과 보존 해시만 검사하고 업무 본문 분석에 사용하지 않았다.

| 영역 | 파일 수 | 조사 방식 |
|---|---:|---|
| `.DS_Store` | 1 | 파일 목록; Markdown은 링크·관련 절 조사 |
| `.agents` | 9 | 파일 목록; Markdown은 링크·관련 절 조사 |
| `.gitignore` | 1 | 파일 목록; Markdown은 링크·관련 절 조사 |
| `AGENTS.md` | 1 | 파일 목록; Markdown은 링크·관련 절 조사 |
| `README.md` | 1 | 파일 목록; Markdown은 링크·관련 절 조사 |
| `docs` | 11 | 파일 목록; Markdown은 링크·관련 절 조사 |
| `evals` | 2 | 파일 목록; Markdown은 링크·관련 절 조사 |
| `exports` | 5071 | 소스·메타데이터 목록 전체, 주요 업무 소스 구간 확인 |
| `harness` | 4 | 파일 목록; Markdown은 링크·관련 절 조사 |
| `knowledge` | 27 | 파일 목록; Markdown은 링크·관련 절 조사 |
| `sources` | 1 | 파일 목록; Markdown은 링크·관련 절 조사 |
| `templates` | 3 | 파일 목록; Markdown은 링크·관련 절 조사 |
| `tests` | 1 | 파일 목록; Markdown은 링크·관련 절 조사 |

exports 5,071개 중 baseline은2,530개다. 전체 목록 조사와 전체 소스의 의미 분석은 다르다. 업무 지도11개, 소스 설명30개에서 필요한 연결만 검토했다. 분석하지 않은 코드의 구현을 확정하지 않는다.

## 기존 링크 조사

[작업 전 링크 장부](audit/links-before.csv)는 Markdown55개에서 **348개 링크**를 기록한다. 실제 존재330개, 외부 URL4개(접속 검증 미수행), 누락14개다. 기존 문서의 링크를 자동 치환하거나 누락 원문을 재생성하지 않았다.

| 근거 문서·행 | 없는 대상 | 해석 |
|---|---|---|
| [docs/SOURCE_REGISTER.md](../docs/SOURCE_REGISTER.md) 38행 | `sources/original/SRC-01.pdf` | 출처 등록부에 있는 원문이 현재 작업본에 없음. 정리본의 과거 검토 보고와 구분. |
| [docs/SOURCE_REGISTER.md](../docs/SOURCE_REGISTER.md) 44행 | `sources/original/SRC-02.pdf` | 출처 등록부에 있는 원문이 현재 작업본에 없음. 정리본의 과거 검토 보고와 구분. |
| [docs/SOURCE_REGISTER.md](../docs/SOURCE_REGISTER.md) 50행 | `sources/original/SRC-03.pdf` | 출처 등록부에 있는 원문이 현재 작업본에 없음. 정리본의 과거 검토 보고와 구분. |
| [docs/SOURCE_REGISTER.md](../docs/SOURCE_REGISTER.md) 56행 | `sources/original/SRC-04.pdf` | 출처 등록부에 있는 원문이 현재 작업본에 없음. 정리본의 과거 검토 보고와 구분. |
| [docs/SOURCE_REGISTER.md](../docs/SOURCE_REGISTER.md) 62행 | `sources/original/SRC-05.txt` | 출처 등록부에 있는 원문이 현재 작업본에 없음. 정리본의 과거 검토 보고와 구분. |
| [docs/SOURCE_REGISTER.md](../docs/SOURCE_REGISTER.md) 68행 | `sources/original/SRC-06.txt` | 출처 등록부에 있는 원문이 현재 작업본에 없음. 정리본의 과거 검토 보고와 구분. |
| [docs/SOURCE_REGISTER.md](../docs/SOURCE_REGISTER.md) 74행 | `sources/original/SRC-07.txt` | 출처 등록부에 있는 원문이 현재 작업본에 없음. 정리본의 과거 검토 보고와 구분. |
| [docs/SOURCE_REGISTER.md](../docs/SOURCE_REGISTER.md) 80행 | `sources/original/SRC-08.txt` | 출처 등록부에 있는 원문이 현재 작업본에 없음. 정리본의 과거 검토 보고와 구분. |
| [docs/SOURCE_REGISTER.md](../docs/SOURCE_REGISTER.md) 86행 | `sources/original/SRC-09.txt` | 출처 등록부에 있는 원문이 현재 작업본에 없음. 정리본의 과거 검토 보고와 구분. |
| [docs/SOURCE_REGISTER.md](../docs/SOURCE_REGISTER.md) 92행 | `sources/original/SRC-10.txt` | 출처 등록부에 있는 원문이 현재 작업본에 없음. 정리본의 과거 검토 보고와 구분. |
| [docs/SOURCE_REGISTER.md](../docs/SOURCE_REGISTER.md) 98행 | `sources/original/SRC-11.txt` | 출처 등록부에 있는 원문이 현재 작업본에 없음. 정리본의 과거 검토 보고와 구분. |
| [knowledge/hr/open-questions.md](../knowledge/hr/open-questions.md) 19행 | `exports/ZHR5/logs/processing.xml` | 옛 분석에서 참조한 추출 로그가 현재 작업본에 없음. |
| [knowledge/hr/overview.md](../knowledge/hr/overview.md) 14행 | `exports/ZHR5/logs/run.xml` | 옛 분석에서 참조한 추출 로그가 현재 작업본에 없음. |
| [knowledge/hr/overview.md](../knowledge/hr/overview.md) 54행 | `exports/ZHR5/logs/processing.xml` | 옛 분석에서 참조한 추출 로그가 현재 작업본에 없음. |

문서 안의 코드표기 경로·평문 경로는 링크로 세지 않는다. 웹 소스의 AJAX URL은 실행 의존성으로 소스 설명에 기록하며 보관함 링크로 검사하지 않는다. 외부 서비스·원문 전체 재열람·SAP 접속은 수행하지 않았다.

## 새 관계의 근거

- [문서 관계 장부](audit/relationships.json): 41개 관계의 원본 파일·지정 절 검색어·줄·의미·상태.
- [소스 근거 장부](audit/source-evidence.json): 65개 정적 근거의 파일·줄·구문·의미. 원본 해시는 전체 파일 목록과 대조한다.
- 추출일은 옛 분석문서에2026-09-21로 기록되어 있으나 현재 `logs/run.xml`이 없어 이번에는 다시 검증하지 못했다. 분석일2026-10-07을 추출일로 쓰지 않는다.
- 기존 knowledge/INDEX와 code-map의 “소스가 없다”는 문구는 지식 묶음 작성 당시 범위다. 현재 로컬 exports에는 소스가 있으며 새 소스 설명에서 실제 경로를 연결했다. 옛 분석 범위 표시는 원본에 그대로 보존한다.
- 독립 회의록 파일은 이번 목록에 없다. 회의 템플릿·카톡 일정은 실제 회의록으로 분류하지 않았다.

## 최종 검사 결과

[기계 검사 결과](audit/result.json) · [현재 링크 전체 장부](audit/links-current.csv).

2026-10-07 검사 결과: Markdown **102개**, 링크 **845개**를 검사했다. 새 `maps` 문서의 누락 대상·제목 앵커 오류는 **0개**이며, 전체 누락 **14개**는 위에 기록한 기존 링크다. 외부 URL 4개는 접속 검사하지 않았다.

문서 관계 41개와 소스 근거 65개의 지정 줄·검색어가 일치했다. 기존 `SKILL.md`·knowledge·harness·exports·tests·evals의 보존 대상 파일 변경은 **0개**다. 다만 macOS 메타데이터인 `.DS_Store` 4개에서 작업 전후 해시 차이가 관찰되어 기계 결과에 별도 표시했다. 이 파일들은 업무 소스가 아니며 이번 문서 작업에서 편집하지 않았다.

기존 파일 편집은 `AGENTS.md`, `README.md`, `docs/VALIDATION.md`의 탐색 안내·검사 기록에 한정했다. 파일 존재·앵커·근거 줄·보존 해시 검사는 정적 검사이며 Obsidian UI·업무 정확도·SAP 배포 확인이 아니다. 지도의 업무 검토 상태는 담당자 검토 대기로 유지한다.

<!-- atlas:auto:start -->

## 전체 범위 확장 조사

앞 절은 1차 지도 작성 당시의 기록이다. 이번 작업 시작은 기존 사용자 변경과 maps가 있는 상태였으며 clean 상태로 되돌리지 않았다.
[최신 전체 파일별 상태·검토 범위](COVERAGE.md) · [현재 파일 목록](audit/file-coverage.csv) · [이번 작업 시작 파일 목록](audit/scope-start-files.csv) · [이번 검사 결과](audit/scope-validation.json)
23개 업무군에 단계 지도를 작성했다. 정규 객체 651개(함수 127개 대응 U Include 포함)는 정적 관계 색인과 전체 업무 의미 분석을 구분한다. baseline·이미지·폰트는 목록에만 남겼다.

<!-- atlas:auto:end -->
