# 제출 전 검증 기록

프로젝트: SAP 패키지 추출·읽기 전용 진단 및 업무 AI 에이전트 구축  
project_id: `kbs-erp-export-diag-agents`  
검증일: 2026-10-12

## 이번 추출물의 실제 확인 결과

| 항목 | 결과 | 범위 |
|---|---|---|
| UTF-8 JSON 파싱 | PASS | conversation-data.json 및 포함 JSON |
| 발화·학습·첨부 ID 고유성 | PASS | 발화 98, 단계 18, 자산 목록 87 |
| 발화 순서 | PASS | 단일 thread sequence 1–98, 발화 참조도 같은 순서 |
| 반복 발화 보존 | PASS | U030/U031, U092/U093 각각 존재하고 본문 동일 |
| 날짜 미확인 처리 | PASS | U093만 확인 가능한 제출 시각, 나머지 null |
| 표준 필드·role·content_type | PASS | 사용자 92, assistant 6; 실제 발화와 해설 분리 |
| episode 참조 | PASS | 모든 message_refs 존재, 모든 발화가 최소 한 학습 단계에 연결 |
| 첨부 참조·역참조 | PASS | message asset_ids와 related_message_ids 정합성 |
| 포함 파일·해시 | PASS | included 53개 실제 파일, SHA-256 일치 |
| 미포함 자료 | PASS | unavailable 34개 path=null, 원본 미확보와 의도적 제외 구분 |
| 작성 MD 상대 링크 | PASS | README·맥락·교육·목록의 파일 경로 |
| 단계별 요구 항목 | PASS | 18단계 × 11개 항목 |
| 합성 비교 실습 | PASS | 10개. SAP 테스트 아님 |
| 실제 Excel 재대조 | PASS | RawData 데이터 2,541행; 확인 실패 함수 70+DDIC 1; 828/1440행 사례 |
| 개인정보 처리 | 수행 | ICM 내부 주소/경로 마스킹, Office 개인 메타데이터 제외, 일부 화면 배포 제외 |
| 인증값 패턴 점검 | 발견 없음 | 포함 텍스트·과거 ZIP 내부 텍스트의 토큰·개인키 패턴. 완전한 보안감사를 뜻하지 않음 |

## 증거 수준의 한계

- 이번에 검증한 것은 교육 묶음의 구조, 파일, 참조, 표기와 로컬 합성 실습이다.
- SAP BASIS700 문법 검사·저장소 활성화·실제 DIAG 실행·브라우저 작동·업무 정답의 전수 검증은 수행하지 않았다.
- 과거 AI 답변 원문 대부분이 없어 응답 내용을 다시 생성하지 않았다. 기존 MD는 요약 근거로만 연결했다.
- visible_messages.md와 JSON은 화면에서 확인 가능한 발화 전사이며 플랫폼 원시 export의 완전성·바이트 동일성을 증명하지 않는다.
- 실제 이미지의 원래 오류·버전은 유지했다. 최신 프로그램 코드와 과거 화면 버전을 섞지 않았다.
- 원본 파일은 수정하지 않았다. ICM·RawData 파생본은 별도 파일로 만들고 redaction-log.json에 처리 범위를 기록했다.
- 오래된 assistant 발화의 sandbox 링크는 원문 보존용이다. 포털의 다운로드 연결은 JSON assets.path를 사용한다.
- 현재 사용자 장비·GitHub 저장소·운영 SAP에 접근하거나 코드 push·서버 설치를 하지 않았다.

## 재검증

압축을 풀고 최상위 폴더에서 다음을 실행한다.

```sh
python3 assets/tools/validate_bundle.py
python3 assets/examples/compare_cases.py
```

`validate_bundle.py`는 JSON·참조·순서·첨부 해시를 확인한다. 이 문서의 의미 검토·화면 개인정보 검토를 자동으로 대체하지 않는다.
