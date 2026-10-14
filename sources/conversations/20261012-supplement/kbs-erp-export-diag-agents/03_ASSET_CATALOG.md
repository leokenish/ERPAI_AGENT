# 자산 목록 — 답변 전문 보완본

project_id: `kbs-erp-export-diag-agents` / 기준일: 2026-10-12

포함 58개 / 미포함·미확보 34개. 파일 확보와 실제 답변 전문 확보는 별개다. 기존 원본·파생·마스킹 구분을 그대로 유지했다.

| ID | 원래 파일명 | 확보/배포 상태 | 이번 ZIP 경로 | 역할 |
|---|---|---|---|---|
| CODE-EXPORT | Z_PACKAGE_EXPORT.abap | included | [Z_PACKAGE_EXPORT_0_3_18.abap](assets/code/Z_PACKAGE_EXPORT_0_3_18.abap) | 접근 가능한 최신 Export 소스. 0.3.18. 현재 SAP 설치본과 같다는 뜻은 아님. |
| CODE-DIAG | Z_PACKAGE_DIAG_0_4_5.abap | included | [Z_PACKAGE_DIAG_0_4_5.abap](assets/code/Z_PACKAGE_DIAG_0_4_5.abap) | 접근 가능한 최신 DIAG 소스. 9128줄 D/T→CSEQUENCE 호환 수정 후 파일. SAP에서 이 버전 실행·활성화 성공은 미확인. |
| CODE-CHECK | DEVHUB_CHECK_0_3_3.html | included | [DEVHUB_CHECK_0_3_3.html](assets/tools/DEVHUB_CHECK_0_3_3.html) | 기존 오프라인 Export 결과 검사 도구. 교육 포털을 새로 만든 파일이 아님. |
| HISTORY-GITHUB | GITHUB_ABAP_CONNECTION_TEST.zip | included | [GITHUB_ABAP_CONNECTION_TEST.zip](assets/history/GITHUB_ABAP_CONNECTION_TEST.zip) | 과거 GitHub 목록 조회 실험 코드와 README. 통신 보류 사례이며 현재 실습 권장 경로는 아님. |
| HISTORY-IMPORT | DEVHUB_IMPORT_0_1_0.zip | included | [DEVHUB_IMPORT_0_1_0.zip](assets/history/DEVHUB_IMPORT_0_1_0.zip) | 초기 Import 0.1.0 원본 ZIP. 명칭은 Import지만 제공 코드는 읽기 전용 검증이며 저장·자동 활성화 기능 구현을 뜻하지 않음. |
| DOC-CONTEXT | PROJECT_CONTEXT.md | included | [PROJECT_CONTEXT_20261008_v3.md](assets/references/PROJECT_CONTEXT_20261008_v3.md) | 기존 인계·요약 문서. 원문 대화가 아니며 최신성은 파일 내부 기준. |
| DOC-BUILD | PACKAGE_AGENT_BUILD_GUIDE.md | included | [PACKAGE_AGENT_BUILD_GUIDE.md](assets/references/PACKAGE_AGENT_BUILD_GUIDE.md) | 새 패키지에 업무 지식·Export·스킬을 통합하는 기존 가이드. 실행 완료 증거와 구분. |
| DOC-FEEDBACK | BUSINESS_FEEDBACK_POLICY.md | included | [BUSINESS_FEEDBACK_POLICY.md](assets/references/BUSINESS_FEEDBACK_POLICY.md) | 업무 답변 피드백 처리 지침. 출처 확인·MD 수정·회귀 사례 갱신 범위. |
| DOC-EXPORT-GUIDE | DEVHUB_EXPORT_GUIDE.md | included | [DEVHUB_EXPORT_GUIDE.md](assets/references/DEVHUB_EXPORT_GUIDE.md) | Export·오프라인 검사 가이드. |
| DOC-EXPORT-VALIDATION | DEVHUB_0_3_18_VALIDATION.md | included | [DEVHUB_0_3_18_VALIDATION.md](assets/references/DEVHUB_0_3_18_VALIDATION.md) | 기존 Export 0.3.18 검증 기록. 현 시점 SAP 재실행 결과 아님. |
| DOC-ZWEB | DEVHUB_ZWEB_0_3_17_REVIEW.md | included | [DEVHUB_ZWEB_0_3_17_REVIEW.md](assets/references/DEVHUB_ZWEB_0_3_17_REVIEW.md) | 기존 ZWEB 분석 문서. 생략 객체의 의미와 범위. |
| DOC-KNOWLEDGE | ZHR5_KNOWLEDGE_SETUP.md | included | [ZHR5_KNOWLEDGE_SETUP.md](assets/references/ZHR5_KNOWLEDGE_SETUP.md) | 기존 ZHR5 업무 지식 설치 안내. 사용자의 현재 Mac 구성 검증은 아님. |
| DOC-GLOSSARY | SAP_OBJECT_GLOSSARY.md | included | [SAP_OBJECT_GLOSSARY.md](assets/references/SAP_OBJECT_GLOSSARY.md) | SAP 객체·폴더를 해석하는 기존 용어집. |
| DOC-KIT-VALIDATION | VALIDATION.md | included | [ZHR5_KIT_VALIDATION_20260922.md](assets/references/ZHR5_KIT_VALIDATION_20260922.md) | 기존 지식 키트 자체 검증 기록. 업무 질문 정답 검증 전체 통과로 해석하지 않음. |
| SKILL-01 | SKILL.md | included | [SKILL.md](assets/references/skills/zhr5-business-qa/SKILL.md) | 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음. |
| SKILL-02 | openai.yaml | included | [openai.yaml](assets/references/skills/zhr5-business-qa/agents/openai.yaml) | 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음. |
| SKILL-03 | answer-format.md | included | [answer-format.md](assets/references/skills/zhr5-business-qa/references/answer-format.md) | 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음. |
| SKILL-04 | SKILL.md | included | [SKILL.md](assets/references/skills/zhr5-change-impact/SKILL.md) | 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음. |
| SKILL-05 | openai.yaml | included | [openai.yaml](assets/references/skills/zhr5-change-impact/agents/openai.yaml) | 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음. |
| SKILL-06 | impact-template.md | included | [impact-template.md](assets/references/skills/zhr5-change-impact/references/impact-template.md) | 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음. |
| SKILL-07 | SKILL.md | included | [SKILL.md](assets/references/skills/zhr5-knowledge-curation/SKILL.md) | 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음. |
| SKILL-08 | openai.yaml | included | [openai.yaml](assets/references/skills/zhr5-knowledge-curation/agents/openai.yaml) | 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음. |
| SKILL-09 | document-template.md | included | [document-template.md](assets/references/skills/zhr5-knowledge-curation/references/document-template.md) | 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음. |
| EX-COMPARE | compare_cases.py | included | [compare_cases.py](assets/examples/compare_cases.py) | 기존 교육 자료. compare_cases/three_way_cases는 합성 실습이며 SAP 테스트가 아님. |
| EX-CASES | three_way_cases.json | included | [three_way_cases.json](assets/examples/three_way_cases.json) | 기존 교육 자료. compare_cases/three_way_cases는 합성 실습이며 SAP 테스트가 아님. |
| RESULT-FACTS | ZHR5_result_facts_derived.json | included | [ZHR5_result_facts_derived.json](assets/examples/ZHR5_result_facts_derived.json) | 기존 result.xlsx RawData 분석 파생 JSON. 이번에 원자료 발췌와 핵심 수치를 재대조. |
| IMG-U002-1 | 0840834c-7367-409f-ba43-a7f4dd68f538.png | included | [U002_1.png](assets/images/U002_1.png) | BSP 중복·대소문자 충돌 경로로 ZIP 중단 |
| IMG-U003-1 | 88d9858a-1280-40a2-a80b-3d11ed419936.png | included | [U003_1.png](assets/images/U003_1.png) | ZMM6 결과 점검 및 SAP BSP 탭 화면 |
| IMG-U003-2 | 111fa5e9-ceb1-49c9-8085-4f4c9da4bc3c.png | included | [U003_2.png](assets/images/U003_2.png) | ZMM6 결과 점검 및 SAP BSP 탭 화면 |
| IMG-U004-1 | ea915e65-4844-4da7-98de-d9987fd1f165.png | included | [U004_1.png](assets/images/U004_1.png) | BSP Properties / Page Attributes 실제 화면 |
| IMG-U004-2 | 96cec730-05f7-496d-8a98-ffc5d4e3efbe.png | included | [U004_2.png](assets/images/U004_2.png) | BSP Properties / Page Attributes 실제 화면 |
| IMG-U006-1 | 52e735d3-8328-4a7c-8249-3f75bc6e2545.png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U006-2 | 1d359765-c090-4c06-a307-5da6e55296ec.png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U006-3 | be1a4fad-1298-4a47-9f34-cfa974898c1a.png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U006-4 | 1ef9dab2-c563-4a69-b95b-f2e98dd4f6cb.png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U006-5 | de021689-8c56-4c7b-8c4a-10797d89a59f.png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U006-6 | 43baad20-8746-4899-af06-8813099d376d.png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U006-7 | f92cc527-a3cb-45dc-b139-877d36080394.png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U006-8 | 96e69c52-d155-4581-9225-b5867bb837ba.png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U006-9 | 265ae083-a1a2-4a11-a038-cf990b070b62.png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U009-1 | 3b1e2e90-3279-40f2-af7c-4f73beff5585.png | included | [U009_1.png](assets/images/U009_1.png) | 함수별 Source code 위치 오해와 ZMM6 점검 |
| IMG-U009-2 | 473b0fc7-1fbe-4783-b214-a6f4c17f4fc6.png | included | [U009_2.png](assets/images/U009_2.png) | 함수별 Source code 위치 오해와 ZMM6 점검 |
| IMG-U010-1 | 4e268c2f-1dd1-4f32-8c35-91c4aa0c8aa1.png | included | [U010_1.png](assets/images/U010_1.png) | ZCO3 메시지 클래스 |
| IMG-U011-1 | 861d261f-c251-4bb5-bd18-b930b3d692bf.png | included | [U011_1.png](assets/images/U011_1.png) | XML formatting changed field values |
| IMG-U012-1 | a4638313-ae1c-47b0-9e45-cd17eefdafb6.png | included | [U012_1.png](assets/images/U012_1.png) | Raw XML round-trip changed values before formatting |
| IMG-U013-1 | 67b7a7bc-fa1b-45af-b6c6-eb6843693aaf.png | included | [U013_1.png](assets/images/U013_1.png) | Export 점검 결과 |
| IMG-U016-1 | 3b88e164-e626-4f20-b2bf-639d429074d6.png | included | [U016_1.png](assets/images/U016_1.png) | NO-DISPLAY와 AS CHECKBOX 동시 사용 오류 |
| IMG-U017-1 | c2aa197c-4309-4a98-8363-30427f005351.png | included | [U017_1.png](assets/images/U017_1.png) | Export 0.3.16 비압축 ZIP 예산 초과 |
| IMG-U018-1 | 8d008caf-fec3-4402-8c30-e98ec73712c0.png | included | [U018_1.png](assets/images/U018_1.png) | ZWEB 초기 오류 19건 |
| IMG-U020-1 | 6a1dd694-a348-45b2-9a93-49804d591794.png | included | [U020_1.png](assets/images/U020_1.png) | ZWEB 생략 객체 19건으로 분리된 점검 |
| IMG-U042-1 | 3a9b8319-2215-49ba-ac6a-ae888cda4d01.png | included | [U042_1.png](assets/images/U042_1.png) | GitHub RECEIVE 단계 SAP 오류코드 407 / ICM_HTTP_SSL_ERROR |
| IMG-U063-1 | image.png | included | [U063_1.png](assets/images/U063_1.png) | Import 0.3.0 ZIP 제한 중단 |
| IMG-U064-1 | image(1).png | included | [U064_1.png](assets/images/U064_1.png) | Import 0.3.1 .git/objects 파일 16 MiB 제한 초과 |
| IMG-U065-1 | image(2).png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U066-1 | image(3).png | included | [U066_1.png](assets/images/U066_1.png) | Import 0.3.2 manifest 버전 제한 중단 |
| IMG-U068-1 | image(4).png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U069-1 | image(5).png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U069-2 | image(6).png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U075-1 | image(7).png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U077-1 | image(8).png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U078-1 | image(9).png | included | [U078_1.png](assets/images/U078_1.png) | WIDTH 인자 타입 오류 |
| IMG-U079-1 | image(10).png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U080-1 | image(20261003-235442).png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U080-2 | image(20261004-000612).png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U080-3 | image(20261004-002149).png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U080-4 | image(20261004-002200).png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U081-1 | image(20261004-073435).png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U081-2 | image(20261004-074151).png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U082-1 | image(20261004-080547).png | included | [U082_1.png](assets/images/U082_1.png) | C_SCOPE 이름 중복 오류 |
| IMG-U083-1 | {57E3939E-7274-4869-B22D-70FD23435620}.png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U083-2 | {5F89FFB7-C06B-4DD8-9F5D-75A5D6106A12}.png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U083-3 | {3EDEEBCE-4C6D-4D58-9F54-FE2F70D57898}.png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U084-1 | {C3B76FE5-23FE-4CB0-9D09-B4316F1C9736}.png | unavailable | 없음 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 제외 사유: 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U089-1 | {F209934C-DEDF-44D4-A305-6E48CF33D7B3}.png | included | [U089_1.png](assets/images/U089_1.png) | 9128줄 CSEQUENCE 관련 호환 오류 |
| LOG-ICM | icm_result.txt | included | [icm_result.redacted.txt](assets/logs/icm_result.redacted.txt) | ICM 원본 로그의 교육용 마스킹 사본. 행 순서 유지. 234–247행 TLS1.0 protocol version alert / SSL_CONNECT 확인. |
| RESULT-RAWDATA | result.xlsx | included | [ZHR5_RawData.extracted.json](assets/results/ZHR5_RawData.extracted.json) | result.xlsx의 실제 RawData 2,541개 데이터 행과 머리글 전체. 교육용 파생 자료이며 원본 XLSX 자체는 아님. |
| RESULT-XLSX-ORIGINAL | result.xlsx | unavailable | 없음 | 실제 확보·읽은 결과 엑셀. RawData 전체를 별도 JSON에 제공. 제외 사유: 교육에 불필요한 Office 개인 식별 메타데이터를 배포하지 않기 위해 원본 XLSX 제외. 원본 미확보는 아님. |
| HISTORY-DIFF_RESULT | diff_result.xlsx | unavailable | 없음 | 과거 진단 결과 파일. 해당 발화와의 직접 첨부 대응은 파일명·시점에 의한 후보이며 확정하지 않음. 제외 사유: 최신 사례 RawData를 우선 제공. 과거 결과 파일과 개별 실행 버전의 대응 미확인. |
| HISTORY-DIFF_RESULT_V2 | diff_result_v2.xlsx | unavailable | 없음 | 과거 진단 결과 파일. 해당 발화와의 직접 첨부 대응은 파일명·시점에 의한 후보이며 확정하지 않음. 제외 사유: 최신 사례 RawData를 우선 제공. 과거 결과 파일과 개별 실행 버전의 대응 미확인. |
| PREVIOUS-BUNDLE | KBS_ERP_AI_Export_Diag_Agents_20261008.zip | unavailable | 없음 | 직전 교육 요약 산출물 원본을 다시 확보·열람함. 당시 응답의 산출물 연결. 제외 사유: 현재 ZIP과 중복되고 내부 원본 화면·엑셀에 불필요한 개인 식별정보가 있어 통째로 재배포하지 않음. 핵심 맥락·가이드·코드는 선별 포함. |
| MISSING-EXPORT-ZIP | ZHR5_export.zip | unavailable | 없음 | 현재 SAP/DIAG 결과와 정확히 대응하는 전체 Export ZIP. 제외 사유: 원본 미확보 또는 해당 실행과의 대응 원본 미확인 |
| MISSING-DIAG-JSON | (현재 생성/이름 미확인) | unavailable | 없음 | DIAG 0.4.5가 실제 SAP에서 생성한 JSON 결과. 소스의 기능과 실전 실행은 구분. 제외 사유: 원본 미확보 또는 해당 실행과의 대응 원본 미확인 |
| MISSING-HISTORICAL-AI | (현재 생성/이름 미확인) | unavailable | 없음 | U002–U090에 대응하는 당시 AI 답변 원문. 요약 MD로 복원하지 않음. 제외 사유: 원본 미확보 또는 해당 실행과의 대응 원본 미확인 |
| MISSING-BUSINESS-ORIGINALS | (현재 생성/이름 미확인) | unavailable | 없음 | 대화에서 업로드했다고 한 카톡 전문·규정·지침·매뉴얼·양식 원문 전체. 이번 교육 추출에서 전량 확보·재검토하지 않음. 제외 사유: 원본 미확보 또는 해당 실행과의 대응 원본 미확인 |
| TRANSCRIPT-MD | (현재 생성/이름 미확인) | included | [visible_messages.md](assets/conversation/visible_messages.md) | JSON과 같은 확인 가능 발화의 읽기용 MD. 교육 해설이나 미확보 AI 답변을 섞지 않음. |
| REDACTION-LOG | (현재 생성/이름 미확인) | included | [redaction-log.json](assets/redaction-log.json) | 교육용 마스킹·제외 기록. 원래 식별값은 기록하지 않음. |
| VALIDATOR | (현재 생성/이름 미확인) | included | [validate_bundle.py](assets/tools/validate_bundle.py) | 이번 교육 ZIP의 JSON·ID·참조·순서·파일·해시 검증 스크립트. SAP 접근 없음. |
| SUP-PRIOR-EXTRACTION-ZIP | kbs-erp-export-diag-agents_교육대화추출_20261012.zip | included | [kbs-erp-export-diag-agents_교육대화추출_20261012.zip](assets/audit/kbs-erp-export-diag-agents_교육대화추출_20261012.zip) | 이번 보완의 기준인 이전 교육 대화 ZIP 원본. 98발화·18에피소드·53포함 자산의 스냅샷. A009의 실제 산출물. |
| SUP-UNMATCHED-PROMPT | 붙여넣은 마크다운(1).md | included | [initial_project_prompt_unmatched.md](assets/audit/initial_project_prompt_unmatched.md) | 초기 Export/Import 구현 요청용 프롬프트 파일 전문. 당시 assistant 전체 발화/직전 질문과 동일성은 미확인. 누락 답변을 해결한 것으로 세지 않음. |
| SUP-RETRIEVAL-AUDIT | (현재 생성/이름 미확인) | included | [RETRIEVAL_AUDIT.md](assets/audit/RETRIEVAL_AUDIT.md) | 이번 원문 검색·파일 대조의 실제 경로와 한계. 현재 작성한 감사 설명이며 역사적 AI 발화 아님. |
| SUP-RESPONSE-AUDIT | (현재 생성/이름 미확인) | included | [response-audit.json](assets/audit/response-audit.json) | 사용자 92개 전수의 대응 응답/미확보 관계와 집계. 요약·발췌·전문 판정 기준. |
| SUP-VALIDATOR | (현재 생성/이름 미확인) | included | [validate_response_supplement.py](assets/tools/validate_response_supplement.py) | 기준 ZIP 대비 원문 98개/첨부 52개 보존, 요청 전수 대응과 에피소드 연결을 검사하는 추가 도구. |
