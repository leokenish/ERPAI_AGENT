# 답변 전문 보완 변경 이력

project_id: kbs-erp-webgui-refactor / 날짜: 2026-10-12

## 기준과 원칙

이전 ZIP은 SHA-256 `ba125fa3899db72a2e3820817bf846bdeba665b2451acdfa65624b9600d6c125`다. 통합 폴더에서 다시 확보한 파일과 이전 생성본이 일치했다. 기준 ZIP 전체를 assets/answer_recovery에 보존했다.

기존 wg-m010~050의 ID·sequence·role·timestamp·content_type·content_markdown·source_locator·redacted·asset_ids는 모두 그대로다. 요약을 원문으로 교체한 항목은 0개다. wg-m034의 마스킹 발췌도 그대로다. 기존 사용자 문체를 정제하지 않았다.

## 추가 발화와 근거

| 새 ID | sequence | 역할·구분 | 대응 요청 | 근거 |
|---|---:|---|---|---|
| wg-m051 | 42 | 사용자 상태 문의 | wg-m050의 후속 | 현재 대화에 직접 표시된 ‘결과물 나왔어?’ |
| wg-m052 | 43 | AI 진행 안내 | wg-m050·051 | MD/JSON 작성 상태 답변 전체 |
| wg-m053 | 44 | AI 진행 안내 | wg-m050·051 | 초기 ZIP·보고서 추가 확보 안내 전체 |
| wg-m054 | 45 | AI 진행 안내 | wg-m050·051 | 41발화·8단계·46첨부 검사 안내 전체 |
| wg-m055 | 46 | AI 진행 안내 | wg-m050·051 | ZIP 검증·저장 안내 전체 |
| wg-m056 | 47 | AI 최종 답변 | wg-m050·051 | 이전 ZIP 링크와 범위·한계를 안내한 답변 전체 |

모두 현재 표시된 실제 텍스트이며 파일이나 요약에서 생성하지 않았다. 시각과 플랫폼 ID는 확인되지 않아 timestamp=null이다. 중간 삽입 없이 기존 끝에 추가하여 기존 sequence는 바뀌지 않았다. ID 숫자는 자체 식별자이며 플랫폼 번호가 아니다.

9월 리팩토링 누락 본문을 새로 찾은 것은 0개다. 위 AI 5개는 이전 교육자료 추출 작업의 답변을 보완한다. 검색으로 얻은 요약 후보 7개를 발화로 추가하지 않았다.

## 에피소드·파일 연결

- wg-ep08 message_refs에 wg-m051~056을 순서대로 추가했다. 기존 참조는 유지했다.
- wg-ep05·06·07에는 새 발화를 추가하지 않고 원문 미확보 해설과 조회 근거만 연결했다.
- 기존 62개 첨부 항목과 포함 파일 46개를 그대로 유지했다. 새 첨부 ID는 a-recovery-baseline, a-recovery-search, a-response-index다.
- 응답 관계와 진행/최종 구분은 response-index.json에 기록했다. conversation-data.json의 schema_version=1.0 및 필드 구조는 유지했다.
- 00_README.md를 이번 확보 범위로 갱신했다. 기존 맥락·학습 가이드는 본문을 보존하고 이번 보완 절을 덧붙였다. 이전 원형은 기준 ZIP에 있다.
- AI_RESPONSES_FULL.md, MISSING_RESPONSES.md, 본 CHANGELOG.md를 새로 작성했다. 원문 대화의 과거 sandbox 링크는 수정하지 않고 첨부 연결을 별도로 제공한다.

## 이번에 하지 않은 일

검색 요약의 시각으로 기존 timestamp를 덮어쓰지 않았다. 코드·보고서 확보를 답변 전문 확보로 간주하지 않았다. 원문 오류나 과거의 완료 표현을 몰래 정정하지 않았다. 운영 ERP·브라우저 기능 검사·소스 수정·포털 배포를 수행하지 않았다.
