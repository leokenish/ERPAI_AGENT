# 자료 목록과 보완 사항

프로젝트: SAP 패키지 추출·읽기 전용 진단 및 업무 AI 에이전트 구축 · 기준일: 2026-10-12

## 전체 자산

`unavailable`은 배포본 없음이다. “원본 확보”와 “포함”은 별도다. 코드 원본은 바이트 그대로 복사했고 파생 자료만 명시된 범위로 가공했다.

| ID | 원래 파일명 | 버전 | 원본 확보/형태 | 배포 경로 | 관련 발화 | 내용·제외 이유 |
|---|---|---|---|---|---|---|
| CODE-EXPORT | Z_PACKAGE_EXPORT.abap | 0.3.18 | 확보 | [Z_PACKAGE_EXPORT_0_3_18.abap](assets/code/Z_PACKAGE_EXPORT_0_3_18.abap) | U020, A004 | 접근 가능한 최신 Export 소스. 0.3.18. 현재 SAP 설치본과 같다는 뜻은 아님.  |
| CODE-DIAG | Z_PACKAGE_DIAG_0_4_5.abap | 0.4.5 | 확보 | [Z_PACKAGE_DIAG_0_4_5.abap](assets/code/Z_PACKAGE_DIAG_0_4_5.abap) | U088, U089, U090, A004 | 접근 가능한 최신 DIAG 소스. 9128줄 D/T→CSEQUENCE 호환 수정 후 파일. SAP에서 이 버전 실행·활성화 성공은 미확인.  |
| CODE-CHECK | DEVHUB_CHECK_0_3_3.html | 0.3.3 | 확보 | [DEVHUB_CHECK_0_3_3.html](assets/tools/DEVHUB_CHECK_0_3_3.html) | U009, U013, U018, U020, A004 | 기존 오프라인 Export 결과 검사 도구. 교육 포털을 새로 만든 파일이 아님.  |
| HISTORY-GITHUB | GITHUB_ABAP_CONNECTION_TEST.zip | 미확인 | 확보 | [GITHUB_ABAP_CONNECTION_TEST.zip](assets/history/GITHUB_ABAP_CONNECTION_TEST.zip) | U040, U042, U045 | 과거 GitHub 목록 조회 실험 코드와 README. 통신 보류 사례이며 현재 실습 권장 경로는 아님.  |
| HISTORY-IMPORT | DEVHUB_IMPORT_0_1_0.zip | 0.1.0 | 확보 | [DEVHUB_IMPORT_0_1_0.zip](assets/history/DEVHUB_IMPORT_0_1_0.zip) | U057, U058, U060 | 초기 Import 0.1.0 원본 ZIP. 명칭은 Import지만 제공 코드는 읽기 전용 검증이며 저장·자동 활성화 기능 구현을 뜻하지 않음.  |
| DOC-CONTEXT | PROJECT_CONTEXT.md | 3.0 | 확보 | [PROJECT_CONTEXT_20261008_v3.md](assets/references/PROJECT_CONTEXT_20261008_v3.md) | U090, A004 | 기존 인계·요약 문서. 원문 대화가 아니며 최신성은 파일 내부 기준.  |
| DOC-BUILD | PACKAGE_AGENT_BUILD_GUIDE.md | 미확인 | 확보 | [PACKAGE_AGENT_BUILD_GUIDE.md](assets/references/PACKAGE_AGENT_BUILD_GUIDE.md) | U032, A004 | 새 패키지에 업무 지식·Export·스킬을 통합하는 기존 가이드. 실행 완료 증거와 구분.  |
| DOC-FEEDBACK | BUSINESS_FEEDBACK_POLICY.md | 미확인 | 확보 | [BUSINESS_FEEDBACK_POLICY.md](assets/references/BUSINESS_FEEDBACK_POLICY.md) | U036, U037, A004 | 업무 답변 피드백 처리 지침. 출처 확인·MD 수정·회귀 사례 갱신 범위.  |
| DOC-EXPORT-GUIDE | DEVHUB_EXPORT_GUIDE.md | 미확인 | 확보 | [DEVHUB_EXPORT_GUIDE.md](assets/references/DEVHUB_EXPORT_GUIDE.md) | U020, A004 | Export·오프라인 검사 가이드.  |
| DOC-EXPORT-VALIDATION | DEVHUB_0_3_18_VALIDATION.md | 0.3.18 | 확보 | [DEVHUB_0_3_18_VALIDATION.md](assets/references/DEVHUB_0_3_18_VALIDATION.md) | U020, A004 | 기존 Export 0.3.18 검증 기록. 현 시점 SAP 재실행 결과 아님.  |
| DOC-ZWEB | DEVHUB_ZWEB_0_3_17_REVIEW.md | 0.3.17 | 확보 | [DEVHUB_ZWEB_0_3_17_REVIEW.md](assets/references/DEVHUB_ZWEB_0_3_17_REVIEW.md) | U018, U019, U020 | 기존 ZWEB 분석 문서. 생략 객체의 의미와 범위.  |
| DOC-KNOWLEDGE | ZHR5_KNOWLEDGE_SETUP.md | 미확인 | 확보 | [ZHR5_KNOWLEDGE_SETUP.md](assets/references/ZHR5_KNOWLEDGE_SETUP.md) | U030, U031, A004 | 기존 ZHR5 업무 지식 설치 안내. 사용자의 현재 Mac 구성 검증은 아님.  |
| DOC-GLOSSARY | SAP_OBJECT_GLOSSARY.md | 미확인 | 확보 | [SAP_OBJECT_GLOSSARY.md](assets/references/SAP_OBJECT_GLOSSARY.md) | U028, U029, A004 | SAP 객체·폴더를 해석하는 기존 용어집.  |
| DOC-KIT-VALIDATION | VALIDATION.md | 미확인 | 확보 | [ZHR5_KIT_VALIDATION_20260922.md](assets/references/ZHR5_KIT_VALIDATION_20260922.md) | U030, U031, A004 | 기존 지식 키트 자체 검증 기록. 업무 질문 정답 검증 전체 통과로 해석하지 않음.  |
| SKILL-01 | SKILL.md | 미확인 | 확보 | [SKILL.md](assets/references/skills/zhr5-business-qa/SKILL.md) | U026, U029, U031, A004 | 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.  |
| SKILL-02 | openai.yaml | 미확인 | 확보 | [openai.yaml](assets/references/skills/zhr5-business-qa/agents/openai.yaml) | U026, U029, U031, A004 | 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.  |
| SKILL-03 | answer-format.md | 미확인 | 확보 | [answer-format.md](assets/references/skills/zhr5-business-qa/references/answer-format.md) | U026, U029, U031, A004 | 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.  |
| SKILL-04 | SKILL.md | 미확인 | 확보 | [SKILL.md](assets/references/skills/zhr5-change-impact/SKILL.md) | U026, U029, U031, A004 | 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.  |
| SKILL-05 | openai.yaml | 미확인 | 확보 | [openai.yaml](assets/references/skills/zhr5-change-impact/agents/openai.yaml) | U026, U029, U031, A004 | 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.  |
| SKILL-06 | impact-template.md | 미확인 | 확보 | [impact-template.md](assets/references/skills/zhr5-change-impact/references/impact-template.md) | U026, U029, U031, A004 | 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.  |
| SKILL-07 | SKILL.md | 미확인 | 확보 | [SKILL.md](assets/references/skills/zhr5-knowledge-curation/SKILL.md) | U026, U029, U031, A004 | 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.  |
| SKILL-08 | openai.yaml | 미확인 | 확보 | [openai.yaml](assets/references/skills/zhr5-knowledge-curation/agents/openai.yaml) | U026, U029, U031, A004 | 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.  |
| SKILL-09 | document-template.md | 미확인 | 확보 | [document-template.md](assets/references/skills/zhr5-knowledge-curation/references/document-template.md) | U026, U029, U031, A004 | 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.  |
| EX-COMPARE | compare_cases.py | 미확인 | 확보 | [compare_cases.py](assets/examples/compare_cases.py) | U060, U086, U087, A002 | 기존 교육 자료. compare_cases/three_way_cases는 합성 실습이며 SAP 테스트가 아님.  |
| EX-CASES | three_way_cases.json | 미확인 | 확보 | [three_way_cases.json](assets/examples/three_way_cases.json) | U060, U086, U087, A002 | 기존 교육 자료. compare_cases/three_way_cases는 합성 실습이며 SAP 테스트가 아님.  |
| RESULT-FACTS | ZHR5_result_facts_derived.json | 미확인 | 확보 | [ZHR5_result_facts_derived.json](assets/examples/ZHR5_result_facts_derived.json) | U060, U086, U087, A002 | 기존 result.xlsx RawData 분석 파생 JSON. 이번에 원자료 발췌와 핵심 수치를 재대조.  |
| IMG-U002-1 | 0840834c-7367-409f-ba43-a7f4dd68f538.png | 미확인 | 확보 | [U002_1.png](assets/images/U002_1.png) | U002 | BSP 중복·대소문자 충돌 경로로 ZIP 중단  |
| IMG-U003-1 | 88d9858a-1280-40a2-a80b-3d11ed419936.png | 미확인 | 확보 | [U003_1.png](assets/images/U003_1.png) | U003 | ZMM6 결과 점검 및 SAP BSP 탭 화면  |
| IMG-U003-2 | 111fa5e9-ceb1-49c9-8085-4f4c9da4bc3c.png | 미확인 | 확보 | [U003_2.png](assets/images/U003_2.png) | U003 | ZMM6 결과 점검 및 SAP BSP 탭 화면  |
| IMG-U004-1 | ea915e65-4844-4da7-98de-d9987fd1f165.png | 미확인 | 확보 | [U004_1.png](assets/images/U004_1.png) | U004 | BSP Properties / Page Attributes 실제 화면  |
| IMG-U004-2 | 96cec730-05f7-496d-8a98-ffc5d4e3efbe.png | 미확인 | 확보 | [U004_2.png](assets/images/U004_2.png) | U004 | BSP Properties / Page Attributes 실제 화면  |
| IMG-U006-1 | 52e735d3-8328-4a7c-8249-3f75bc6e2545.png | 미확인 | 확보 | 없음 | U006 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U006-2 | 1d359765-c090-4c06-a307-5da6e55296ec.png | 미확인 | 확보 | 없음 | U006 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U006-3 | be1a4fad-1298-4a47-9f34-cfa974898c1a.png | 미확인 | 확보 | 없음 | U006 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U006-4 | 1ef9dab2-c563-4a69-b95b-f2e98dd4f6cb.png | 미확인 | 확보 | 없음 | U006 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U006-5 | de021689-8c56-4c7b-8c4a-10797d89a59f.png | 미확인 | 확보 | 없음 | U006 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U006-6 | 43baad20-8746-4899-af06-8813099d376d.png | 미확인 | 확보 | 없음 | U006 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U006-7 | f92cc527-a3cb-45dc-b139-877d36080394.png | 미확인 | 확보 | 없음 | U006 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U006-8 | 96e69c52-d155-4581-9225-b5867bb837ba.png | 미확인 | 확보 | 없음 | U006 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U006-9 | 265ae083-a1a2-4a11-a038-cf990b070b62.png | 미확인 | 확보 | 없음 | U006 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U009-1 | 3b1e2e90-3279-40f2-af7c-4f73beff5585.png | 미확인 | 확보 | [U009_1.png](assets/images/U009_1.png) | U009 | 함수별 Source code 위치 오해와 ZMM6 점검  |
| IMG-U009-2 | 473b0fc7-1fbe-4783-b214-a6f4c17f4fc6.png | 미확인 | 확보 | [U009_2.png](assets/images/U009_2.png) | U009 | 함수별 Source code 위치 오해와 ZMM6 점검  |
| IMG-U010-1 | 4e268c2f-1dd1-4f32-8c35-91c4aa0c8aa1.png | 미확인 | 확보 | [U010_1.png](assets/images/U010_1.png) | U010 | ZCO3 메시지 클래스  |
| IMG-U011-1 | 861d261f-c251-4bb5-bd18-b930b3d692bf.png | 미확인 | 확보 | [U011_1.png](assets/images/U011_1.png) | U011 | XML formatting changed field values  |
| IMG-U012-1 | a4638313-ae1c-47b0-9e45-cd17eefdafb6.png | 미확인 | 확보 | [U012_1.png](assets/images/U012_1.png) | U012 | Raw XML round-trip changed values before formatting  |
| IMG-U013-1 | 67b7a7bc-fa1b-45af-b6c6-eb6843693aaf.png | 미확인 | 확보 | [U013_1.png](assets/images/U013_1.png) | U013 | Export 점검 결과  |
| IMG-U016-1 | 3b88e164-e626-4f20-b2bf-639d429074d6.png | 미확인 | 확보 | [U016_1.png](assets/images/U016_1.png) | U016 | NO-DISPLAY와 AS CHECKBOX 동시 사용 오류  |
| IMG-U017-1 | c2aa197c-4309-4a98-8363-30427f005351.png | Export 0.3.16 | 확보 | [U017_1.png](assets/images/U017_1.png) | U017 | Export 0.3.16 비압축 ZIP 예산 초과  |
| IMG-U018-1 | 8d008caf-fec3-4402-8c30-e98ec73712c0.png | 미확인 | 확보 | [U018_1.png](assets/images/U018_1.png) | U018 | ZWEB 초기 오류 19건  |
| IMG-U020-1 | 6a1dd694-a348-45b2-9a93-49804d591794.png | 미확인 | 확보 | [U020_1.png](assets/images/U020_1.png) | U020 | ZWEB 생략 객체 19건으로 분리된 점검  |
| IMG-U042-1 | 3a9b8319-2215-49ba-ac6a-ae888cda4d01.png | 미확인 | 확보 | [U042_1.png](assets/images/U042_1.png) | U042 | GitHub RECEIVE 단계 SAP 오류코드 407 / ICM_HTTP_SSL_ERROR  |
| IMG-U063-1 | image.png | Import 0.3.0 | 확보 | [U063_1.png](assets/images/U063_1.png) | U063 | Import 0.3.0 ZIP 제한 중단  |
| IMG-U064-1 | image(1).png | Import 0.3.1 | 확보 | [U064_1.png](assets/images/U064_1.png) | U064 | Import 0.3.1 .git/objects 파일 16 MiB 제한 초과  |
| IMG-U065-1 | image(2).png | 미확인 | 확보 | 없음 | U065 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U066-1 | image(3).png | Import 0.3.2 | 확보 | [U066_1.png](assets/images/U066_1.png) | U066 | Import 0.3.2 manifest 버전 제한 중단  |
| IMG-U068-1 | image(4).png | 미확인 | 확보 | 없음 | U068 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U069-1 | image(5).png | 미확인 | 확보 | 없음 | U069 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U069-2 | image(6).png | 미확인 | 확보 | 없음 | U069 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U075-1 | image(7).png | 미확인 | 확보 | 없음 | U075 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U077-1 | image(8).png | 미확인 | 확보 | 없음 | U077 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U078-1 | image(9).png | 미확인 | 확보 | [U078_1.png](assets/images/U078_1.png) | U078 | WIDTH 인자 타입 오류  |
| IMG-U079-1 | image(10).png | 미확인 | 확보 | 없음 | U079 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U080-1 | image(20261003-235442).png | 미확인 | 확보 | 없음 | U080 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U080-2 | image(20261004-000612).png | 미확인 | 확보 | 없음 | U080 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U080-3 | image(20261004-002149).png | 미확인 | 확보 | 없음 | U080 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U080-4 | image(20261004-002200).png | 미확인 | 확보 | 없음 | U080 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U081-1 | image(20261004-073435).png | 미확인 | 확보 | 없음 | U081 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U081-2 | image(20261004-074151).png | 미확인 | 확보 | 없음 | U081 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U082-1 | image(20261004-080547).png | 미확인 | 확보 | [U082_1.png](assets/images/U082_1.png) | U082 | C_SCOPE 이름 중복 오류  |
| IMG-U083-1 | {57E3939E-7274-4869-B22D-70FD23435620}.png | 미확인 | 확보 | 없음 | U083 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U083-2 | {5F89FFB7-C06B-4DD8-9F5D-75A5D6106A12}.png | 미확인 | 확보 | 없음 | U083 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U083-3 | {3EDEEBCE-4C6D-4D58-9F54-FE2F70D57898}.png | 미확인 | 확보 | 없음 | U083 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U084-1 | {C3B76FE5-23FE-4CB0-9D09-B4316F1C9736}.png | 미확인 | 확보 | 없음 | U084 | 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음. 개인 계정·사용자 경로가 포함되었거나 전체 개인정보 검토를 마치지 못한 화면으로 교육 ZIP에서 제외. 원본 확보 여부와 별도로 기록; 가짜 화면을 생성하지 않음. |
| IMG-U089-1 | {F209934C-DEDF-44D4-A305-6E48CF33D7B3}.png | 미확인 | 확보 | [U089_1.png](assets/images/U089_1.png) | U089 | 9128줄 CSEQUENCE 관련 호환 오류  |
| LOG-ICM | icm_result.txt | 미확인 | 파생 자료 | [icm_result.redacted.txt](assets/logs/icm_result.redacted.txt) | U043, U044, U045 | ICM 원본 로그의 교육용 마스킹 사본. 행 순서 유지. 234–247행 TLS1.0 protocol version alert / SSL_CONNECT 확인.  |
| RESULT-RAWDATA | result.xlsx | 미확인 | 파생 자료 | [ZHR5_RawData.extracted.json](assets/results/ZHR5_RawData.extracted.json) | U086, U087, A002 | result.xlsx의 실제 RawData 2,541개 데이터 행과 머리글 전체. 교육용 파생 자료이며 원본 XLSX 자체는 아님.  |
| RESULT-XLSX-ORIGINAL | result.xlsx | 미확인 | 확보 | 없음 | U086, U087 | 실제 확보·읽은 결과 엑셀. RawData 전체를 별도 JSON에 제공. 교육에 불필요한 Office 개인 식별 메타데이터를 배포하지 않기 위해 원본 XLSX 제외. 원본 미확보는 아님. |
| HISTORY-DIFF_RESULT | diff_result.xlsx | 미확인 | 확보 | 없음 | 문서 근거 | 과거 진단 결과 파일. 해당 발화와의 직접 첨부 대응은 파일명·시점에 의한 후보이며 확정하지 않음. 최신 사례 RawData를 우선 제공. 과거 결과 파일과 개별 실행 버전의 대응 미확인. |
| HISTORY-DIFF_RESULT_V2 | diff_result_v2.xlsx | 미확인 | 확보 | 없음 | 문서 근거 | 과거 진단 결과 파일. 해당 발화와의 직접 첨부 대응은 파일명·시점에 의한 후보이며 확정하지 않음. 최신 사례 RawData를 우선 제공. 과거 결과 파일과 개별 실행 버전의 대응 미확인. |
| PREVIOUS-BUNDLE | KBS_ERP_AI_Export_Diag_Agents_20261008.zip | 미확인 | 확보 | 없음 | A004 | 직전 교육 요약 산출물 원본을 다시 확보·열람함. 당시 응답의 산출물 연결. 현재 ZIP과 중복되고 내부 원본 화면·엑셀에 불필요한 개인 식별정보가 있어 통째로 재배포하지 않음. 핵심 맥락·가이드·코드는 선별 포함. |
| MISSING-EXPORT-ZIP | ZHR5_export.zip | 미확인 | 미확보 | 없음 | U086 | 현재 SAP/DIAG 결과와 정확히 대응하는 전체 Export ZIP. 원본 미확보 또는 해당 실행과의 대응 원본 미확인 |
| MISSING-DIAG-JSON | 미확인 | 미확인 | 미확보 | 없음 | U087, U088, U089 | DIAG 0.4.5가 실제 SAP에서 생성한 JSON 결과. 소스의 기능과 실전 실행은 구분. 원본 미확보 또는 해당 실행과의 대응 원본 미확인 |
| MISSING-HISTORICAL-AI | 미확인 | 미확인 | 미확보 | 없음 | 문서 근거 | U002–U090에 대응하는 당시 AI 답변 원문. 요약 MD로 복원하지 않음. 원본 미확보 또는 해당 실행과의 대응 원본 미확인 |
| MISSING-BUSINESS-ORIGINALS | 미확인 | 미확인 | 미확보 | 없음 | U030, U031 | 대화에서 업로드했다고 한 카톡 전문·규정·지침·매뉴얼·양식 원문 전체. 이번 교육 추출에서 전량 확보·재검토하지 않음. 원본 미확보 또는 해당 실행과의 대응 원본 미확인 |
| TRANSCRIPT-MD | 미확인 | 미확인 | 파생 자료 | [visible_messages.md](assets/conversation/visible_messages.md) | 문서 근거 | JSON과 같은 확인 가능 발화의 읽기용 MD. 교육 해설이나 미확보 AI 답변을 섞지 않음.  |
| REDACTION-LOG | 미확인 | 미확인 | 파생 자료 | [redaction-log.json](assets/redaction-log.json) | 문서 근거 | 교육용 마스킹·제외 기록. 원래 식별값은 기록하지 않음.  |
| VALIDATOR | 미확인 | 미확인 | 파생 자료 | [validate_bundle.py](assets/tools/validate_bundle.py) | U092, U093 | 이번 교육 ZIP의 JSON·ID·참조·순서·파일·해시 검증 스크립트. SAP 접근 없음.  |

## 추가 캡처·원본 요청

| 대상 | 반드시 보여야 할 것 | 이유 | 우선순위 |
|---|---|---|---|
| DIAG 0.4.5 입력/메인/상세 | 실행 버전, 패키지, 네 유형, 변경분 필터, A/B 집계, 세 비교, F3 복귀 | 현재 UI·입력·집계 구현의 실제 SAP 확인 | 교육 재현 전 필수 |
| 함수·Include 확인 실패 대표 1건 | 함수명, 실제 소유 Include, 두 소스의 경계, 읽기/활성 근거 | 확인 실패 원인을 추측이 아닌 근거로 설명 | 중요 |
| XML 의미 비교 대표 1건 | 원본·추출본·SAP 파일, 바뀐 leaf/속성 | 가짜 대량 차이와 실제 속성 변화를 구분 | 중요 |
| 최신 JSON 다운로드 | 파일의 프로그램 버전, 전체/표시 대상, 긴 설명, 마스킹된 변경자 | 엑셀 잘림 대안 실제 검증 | 중요 |
| Codex 스킬 호출·업무 피드백 | 실제 읽은 자료, 출처, 담당자 정정, 회귀 결과 | 문서 설치와 작동의 차이 교육 | 후속 보완 |
| GitHub Actions | 실제 YAML·run ID·로그와 commit | 단순 개념 설명을 재현 실습으로 확장 | 후속 보완 |

## 설명용 시각자료와 상호작용 제안

- 세 비교: baseline/추출본/SAP를 선택해 기준→대상 방향과 네 상태를 보여준다. 합성 실습임을 배지로 명시한다.
- 검증 층: 조회/활성 버전/문법 형식의 근거를 펼쳐 보인다. 같은 행의 다른 판정을 묶어 하나의 성공으로 표시하지 않는다.
- 경로 수정: 공용 Source code의 과거 구조와 함수별 구조를 비교한다. 실제 화면은 첨부 원본, 설명도는 Mermaid/SVG로 구분한다.
- 실패 흐름: 오류 화면 → 실제 요청 → 교육 해설 → 후속 결정 → 검증 수준으로 넘긴다. 없는 AI 답변 말풍선은 만들지 않는다.
- 복사 버튼: 교육용 재작성 프롬프트·조회용 Git 명령·로컬 검증 명령에만 제공한다. 과거 Import 실행이나 TLS 설정 변경을 클릭 실습으로 제공하지 않는다.

실제 제품 화면을 생성형 이미지로 대체하지 않았다. 이번 ZIP에는 새 웹 UI·생성 이미지가 없다.
