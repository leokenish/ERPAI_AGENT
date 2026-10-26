# 활용사례 11–16 도입 맥락 추가 · v1.16.1

작성일: 2026-10-26 (Asia/Seoul)

## 사용자 요청과 추가 방식

01–10과정에 적용한 설명 방식 가운데 **이유 → 실제 근거·시행착오 → 방향 설정 → 기술적 구현**만 활용사례 11–16에도 추가한다. 기존 요소를 없애거나 기존 본문을 전면 재작성하지 않는다.

기존 여섯 본문 파일은 바이트 그대로 보존한다. 새 설명은 `content/lesson-contexts/`의 프로젝트별 MD 여섯 개이며 catalog의 `contextFile`로 연결한다. 프로젝트 4MD 요약 다음, 기존 갤러리·문서 지도·본문 앞에 표시한다. 기존 4MD 요약, 화면 선택·기능 전환·아이콘 비교, 문서 지도, 실습·검증·한계 설명, 실제 대화와 이전/다음 연결을 유지한다.

추가 목차 ID는 `context-section-1`부터 시작한다. 기존 본문과 `section-N` 주소는 바꾸지 않는다. 새 맥락도 검색과 오프라인 미리보기에 포함한다. 별도 디자인·서비스·외부 라이브러리는 추가하지 않는다.

## 근거 지도

| 과정 | 추가 설명의 핵심 | 검토한 근거 |
|---|---|---|
| 11 근로시간 AI 에이전트 | 코드에 없는 입력·협의 맥락 → 실제 오판과 정정 → 지식·스킬·지도·피드백 분리 → 질문부터 재검증까지 | `sources/github-erp-ai/520ac77046f5/README.md`, `.agents/skills/zhr5-business-qa/SKILL.md`, `docs/BUSINESS_FEEDBACK_POLICY.md`, `harness/feedback/FB-20261001-001.md`, `FB-20261008-001.md`; 포털 `docs/WORKTIME_KNOWLEDGE.md` |
| 12 ERP WEBGUI | 공통 화면의 불편 → SYSTEM 의존·아이콘 의미·다운로드 원인 구분 → 기존 명령과 등록 대상 보존 → 화면·본문 수집·파일 전달·선택 반영 | `content/conversations/business-full/kbs-erp-webgui-refactor/conversation-data.json`; `SHARED-001/003`, `wg-m026/037/038/039`, `webgui-next-t021/022/023-u1`, `webgui-progress-t033/060/067/074-u1`, `t075-a1`, `t077–079-u1`; `sources/webgui/project-md/20261024/` |
| 13 포털 구축 | 자료만 전달했을 때의 학습 부담 → 분류·단순화·동기 설명·생성물 중복 → 원본과 교육 설명 분리 → 빌드·검증·변경분 전달 | 이 대화의 사용자 개편 요구; `docs/RELEASE_v1.15.0.md`, `RELEASE_v1.15.1.md`, `RELEASE_v1.15.2.md`, `RELEASE_v1.16.0.md`; `CONTENT_WORKFLOW.md`, `INTEGRATION_REVIEW.md`; 실제 `scripts/build.mjs`와 `content/catalog.json` |
| 14 ESS | 부분 날짜 변경 부담 → 초기 범위 오해·현재 소스 불일치·결재 누락 → R1 분리·승인 원본 보존 → 입력·저장·결재·실제 잔여 대조 | `content/conversations/business-full/kbs-erp-ess-attendance/conversation-data.json`; `ess1-t002-u1/a1`, `ess3-t018/019/022/048/053/064-u1`, `ess3-t064–081`, `ess4-t027-u1`; 에피소드 `ess-01/11/13/15/20/23/24/26` |
| 15 타임라인 | 제출한 보고의 재활용 → 실제 HML·국 단위·빈 정보·수집/표시 오류 → 원문·관측·추론과 파일 역할 분리 → 카드·색인·연결·화면·갱신 | `content/conversations/progress-20261024/kbs-weekly-work-timeline/conversation-data.json`; `timeline-progress-t000–002-u1`, `t004/008–012/014–024-u1`; `sources/weekly-timeline/project-md/20261024/{intent,spec,plan}.md` |
| 16 스마트 ERP | 기존 업무 보존과 첫 화면 정돈 → 시안 불일치·큰 창 여백·국소 보정 → 확정 시안·HTML 기능 보존 → BSP 앱·iframe·CSS·프리뷰/실제 검증 구분 | `content/conversations/progress-20261024/kbs-smart-erp-main/conversation-data.json`; `smart-erp-progress-t000–002/007/010–017/023/025–027/033/035–036/039–044-u1`; `sources/smart-erp/project-md/20261024/{intent,spec,plan}.md` |

표의 턴 범위는 해당 대화의 관련 흐름을 뜻하며 범위 안의 모든 발화를 독립 검증 증거로 취급하지 않는다. 새 설명은 교육용 해설이고 원문 발화가 아니다. 근로시간·포털·ESS의 `sources/project-progress/` 문서는 이전 포털 작성 초안이므로 당시 대화의 독립 증거로 사용하지 않는다.

## 서술 경계

- 근로시간 0원 사례의 입력 규칙은 해당 시차근무·반차 사례에 관한 정정이다. 모든 근무·휴가의 일반 규칙으로 확장하지 않는다. 문서 검사와 AI 자체 대조를 독립 평가나 SAP 지급 검증으로 쓰지 않는다.
- WEBGUI의 아이콘 원형 보존, 대상 등록, 다운로드 원인 구분은 실제 요청·조사의 흐름이다. V429 확보나 한 메뉴 성공을 전체 최신 SAP 성공으로 확대하지 않는다.
- 포털 자체의 독립 대화 전문을 생성하지 않는다. 현재 사용자 요청과 릴리스 기록, 실제 구현으로 설명한다.
- ESS는 원래부터 저장·결재 경로를 확인하는 기준이 있었다. 결재 누락 사건이 그 기준을 처음 만들었다고 서술하지 않고 필요성을 더 분명히 한 사례로 쓴다. 마지막 SUBMIT_PRG01 뒤 시험은 미확인이다.
- 타임라인은 규칙 기반 추출·연결과 제한된 5주 맥락 검토다. 전 기간 AI 의미 판정, 자동 예약 실행, 미언급에 따른 업무 완료 확정으로 쓰지 않는다.
- 스마트 ERP는 확보된 v9 자료를 기준으로 한다. 모의 프리뷰, 실제 SAP 동작, 전체 ZIP 무결성과 운영 반영을 구분한다. 다른 대화의 후속 AVIF 변경 등을 이번 확보 자료에 섞지 않는다.
- 이번 작업으로 원 프로젝트 프로그램을 실행하거나 운영 상태를 새로 확인한 것은 아니다.

## 검증

기존 전체 본문·이미지·첨부·원천·대화·4MD 요약·갤러리 설정은 v1.16.0 Full ZIP과 비교한다. 실제 빌드·오프라인 생성·기존 테스트에 더해 새 맥락의 표시 순서·기존 목차 주소·검색·직접 이동을 검증한다. 실행 결과는 `docs/RELEASE_v1.16.1.md`와 `docs/validation/v1.16.1/`에 기록한다.
