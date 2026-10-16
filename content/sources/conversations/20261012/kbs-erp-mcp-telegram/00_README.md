# ERP MCP 구성 — 교육대화 추출 자료 안내

- 프로젝트명: ERP MCP 서버 구성 — REST/RFC·Codex·Telegram
- project_id: `kbs-erp-mcp-telegram`
- 추출일: 2026-10-12, Asia/Seoul
- 패키지 버전: 2.0.0
- 대화 JSON schema_version: 1.0
- 확보 수준: **partial — 일부 원문 + 짧은 발췌 + 이전 요약**
- 추출 컷오프: 이번 요청 M034까지. 이번 생성 작업의 진행 안내와 제출 답변은 자기참조를 피하기 위해 다음 추출 대상으로 남긴다.

## 1. 이 자료로 할 수 있는 일

기존 ECC의 REST/RFC 기능을 MCP로 연결하려는 목적에서 출발해, AI 역할에 대한 오해를 풀고, 사내 에이전트를 외부 Telegram으로 사용하려는 요구가 구체화되는 과정을 따라 읽는다. 사용자 질문, 당시 답변에 대한 확보 근거, 추가된 제약, 교육 해설, 재작성 프롬프트를 분리했다.

이 자료는 **성공한 ERP 연동 시스템의 사용 설명서가 아니다.** 설계 논의와 자료 추출은 확인되지만, MCP·ERP·AI·Telegram이 종단 간 동작한 증거는 없다. 이번 실제 검증 대상은 교육 데이터와 파일 패키지다.

## 2. 확인한 범위와 수량

| 항목 | 확보 수량·수준 |
|---|---|
| 대화방 | 1개(T01). 플랫폼 대화방 ID·공식 제목은 미제공이므로 정리용 명칭 사용 |
| 표시용 발화 항목 | 34개(M001~M034) |
| verbatim | 20개: 사용자 16개, 이전 자료 추출의 assistant 진행·완료 4개 |
| excerpt | 1개: 과거 대화 검색에서 반환된 초기 AI 답변의 첫 부분 |
| summary | 13개: 이전 MD의 ‘답변 요지’를 전재. 실제 답변 전문이 아님 |
| 학습 단계 | 8개(E01~E08) |
| assets 등록 | 20개: 실제 포함 14개, 미확보 6개 |
| 포함 자료 구성 | 이전 ZIP 1개 + 내부 파일 9개 + 새 출처 기록·프롬프트·검사 결과·검사 도구 4개 |
| 실제 제품 화면·운영 소스 | 확보 0개. 생성형 화면·가짜 코드 원본을 만들지 않음 |
| ZIP 최상위 파일 | MD 3개와 conversation-data.json |
| ZIP 내부 전체 파일 | 18개. 보존한 이전 ZIP 속 9개 파일은 이 개수에 중복 산입하지 않음 |

**34개는 34개의 완전한 원시 메시지를 확보했다는 뜻이 아니다.** 초기 답변 전문은 대부분 없으므로 13개 요약 항목과 1개 발췌가 사용자 질문 사이에 연결된다. 원래 답변 하나가 여러 메시지였는지까지는 알 수 없다.

기간은 초기 MCP 질문 14개, 2026-10-08 첫 자료 추출, 2026-10-12 이번 재추출 요청이다. 초기 논의가 2026년 9월이라는 단서는 이전 문서·검색에 있지만 개별 시각의 원시 메타데이터는 없다. M034만 이번 제출 시각이 직접 제공되었다. 다른 과거 timestamp는 null이다.

## 3. 원문·요약·순서 보존 규칙

- 초기 사용자 질문 14개는 현재 보이는 본문 전체를 사용했다. 오타·띄어쓰기를 교정하지 않았다.
- M029와 M034의 긴 자료 추출 요청도 전체 수록했다. 핵심 학습 구간 밖의 확보 대화를 지우지 않았다.
- 현재 직접 보이는 이전 추출 진행 3개와 최종 답변 1개도 수록했다. 앞부분 진행 발화 중 압축 요약만 남은 부분은 새 대사로 복원하지 않았다.
- M006은 검색에서 반환된 첫 부분만 보존했다. ‘...’는 검색 결과가 사용한 생략 형태다. 전체 답변으로 표시하면 안 된다.
- summary는 [이전 대화 발췌 문서](assets/previous_extract/ERP_MCP서버구성_ERP연동과텔레그램에이전트_2026-10-08/references/대화출처_발췌.md)의 대응 C절 ‘답변 요지’ 문단이다. 그 문단을 실제 assistant의 발화 문장처럼 따옴표로 인용하지 않는다.
- Mxxx·T01·Exx·Axxx는 이 프로젝트 안의 자체 ID다. 원래 플랫폼 ID가 아니다.
- sequence는 확보한 항목의 상대 순서를 보존한 표시 순번이다. 누락된 메시지까지 포함한 플랫폼의 절대 순번을 뜻하지 않는다. 요약은 해당 C절의 질문 뒤에 배치하고 이 사실을 source_locator에 남겼다.
- asset_ids는 관련 자료다. 예를 들어 초기 질문과 연결한 10월 8일 교육 문서는 당시 질문에 붙어 있던 첨부가 아니다.
- 원문에 있는 과거 sandbox 링크는 바꾸지 않았다. 포털에서는 A001의 새 상대경로를 별도 첨부 버튼으로 제공하면 된다.
- 시스템·개발자 지침, 내부 도구 호출, 환경 메타데이터, 다른 프로젝트 검색 결과는 사용자–AI 발화로 넣지 않았다.

## 4. 먼저 읽을 순서

1. 이 README: 확보 수준과 표시 규칙.
2. [01_PROJECT_CONTEXT.md](01_PROJECT_CONTEXT.md): 목적·요구 변화·상태.
3. [02_LEARNING_GUIDE.md](02_LEARNING_GUIDE.md): 발화를 따라가는 8단계 교육.
4. [conversation-data.json](conversation-data.json): 포털 연결 데이터.
5. [SOURCE_AUDIT.md](assets/evidence/SOURCE_AUDIT.md): 시각·출처·중복·마스킹·누락의 판단 근거.
6. [VALIDATION_REPORT.json](assets/evidence/VALIDATION_REPORT.json): 이번 구조 검사 결과.

## 5. 파일 목록

| 파일·경로 | 용도 |
|---|---|
| [00_README.md](00_README.md) | 안내·확보 범위·통합 규칙 |
| [01_PROJECT_CONTEXT.md](01_PROJECT_CONTEXT.md) | 시간 흐름에 따른 맥락과 변화 |
| [02_LEARNING_GUIDE.md](02_LEARNING_GUIDE.md) | 단계별 11개 교육 항목 |
| [conversation-data.json](conversation-data.json) | 실제 원문/발췌/요약, 교육 단계, 자산 연결 |
| `assets/originals/` | 이전 산출물 ZIP 원본 |
| `assets/previous_extract/` | 이전 ZIP 내부 9개 파일, 원본 바이트 유지 |
| [assets/evidence/SOURCE_AUDIT.md](assets/evidence/SOURCE_AUDIT.md) | 이번 출처·제외·충돌 기록 |
| [assets/evidence/VALIDATION_REPORT.json](assets/evidence/VALIDATION_REPORT.json) | 이번 패키지 검사 결과 |
| [assets/exercises/EDUCATIONAL_PROMPTS.md](assets/exercises/EDUCATIONAL_PROMPTS.md) | **교육용 재작성 프롬프트**, 실제 발화 아님 |
| [assets/tools/validate_package.py](assets/tools/validate_package.py) | 로컬 읽기 전용 패키지 검사 |

### 5.1 포함 자산의 개별 목록

| ID | 파일 | 성격 |
|---|---|---|
| A001 | [ERP_MCP서버구성_ERP연동과텔레그램에이전트_2026-10-08.zip](assets/originals/ERP_MCP서버구성_ERP연동과텔레그램에이전트_2026-10-08.zip) | 이전 답변 M033의 실제 산출물. 현재 내려받은 두 사본은 SHA-256이 동일하므로 한 사본만 포함. 원본 바이트 보존. |
| A002 | [00_README.md](assets/previous_extract/ERP_MCP서버구성_ERP연동과텔레그램에이전트_2026-10-08/00_README.md) | 이전 추출본의 범위·상태 안내. 당시 확인 주장을 보존하며 10월 12일 원문 확보 수준을 보증하지는 않음. |
| A003 | [01_프로젝트_맥락과설계.md](assets/previous_extract/ERP_MCP서버구성_ERP연동과텔레그램에이전트_2026-10-08/01_프로젝트_맥락과설계.md) | 이전 맥락·설계 요약. 초기 AI 답변 전문의 대체물이 아닌 2차 자료. |
| A004 | [02_교육과실습.md](assets/previous_extract/ERP_MCP서버구성_ERP연동과텔레그램에이전트_2026-10-08/02_교육과실습.md) | 10월 8일 교육용 재구성 예제와 절차. 당시 발화에 첨부된 원래 코드가 아니며 실행되지 않았음. |
| A005 | [03_자료목록과보완사항.md](assets/previous_extract/ERP_MCP서버구성_ERP연동과텔레그램에이전트_2026-10-08/03_자료목록과보완사항.md) | 이전 자료목록, 실제 캡처 요청, 시각자료 제안, 보완 목록. |
| A006 | [대화출처_발췌.md](assets/previous_extract/ERP_MCP서버구성_ERP연동과텔레그램에이전트_2026-10-08/references/대화출처_발췌.md) | C01~C15의 사용자 발췌·답변 요지. 이 파일의 답변 요약 13개를 summary 항목으로 옮김. C03 전체 요지는 여기 남기고 M006에는 검색 발췌 1건만 수록. |
| A007 | [공식문서_확인목록.md](assets/previous_extract/ERP_MCP서버구성_ERP연동과텔레그램에이전트_2026-10-08/references/공식문서_확인목록.md) | 10월 8일 문서 대조 기록을 원본 그대로 보존. 링크·SDK 버전·제품 정보를 이번에 최신 검증한 것이 아님. |
| A008 | [erp_readonly_contract.example.json](assets/previous_extract/ERP_MCP서버구성_ERP연동과텔레그램에이전트_2026-10-08/examples/erp_readonly_contract.example.json) | 가상 구매오더 계약. FICTIONAL_EDUCATION_EXAMPLE이며 실제 ERP 명세가 아님. |
| A009 | [validation_record.example.json](assets/previous_extract/ERP_MCP서버구성_ERP연동과텔레그램에이전트_2026-10-08/examples/validation_record.example.json) | 이전 교육용 빈 검증 양식. 10개 시험이 모두 NOT_RUN이고 실행 증거 없음. |
| A010 | [codex_build_request.txt](assets/previous_extract/ERP_MCP서버구성_ERP연동과텔레그램에이전트_2026-10-08/examples/codex_build_request.txt) | 10월 8일 후속 구축용으로 새로 쓴 프롬프트. 실제 사용자 발화나 실행한 지시가 아님. |
| A017 | [SOURCE_AUDIT.md](assets/evidence/SOURCE_AUDIT.md) | 이번 추출에서 작성한 원문/요약/발췌·시각 충돌·중복 파일·마스킹·제외 범위의 근거 기록. 과거 대화 발화가 아님. |
| A018 | [VALIDATION_REPORT.json](assets/evidence/VALIDATION_REPORT.json) | 이번 JSON·ID·참조·원본·파일 정합성 검사 결과. ERP 실행 검증이 아님. |
| A019 | [EDUCATIONAL_PROMPTS.md](assets/exercises/EDUCATIONAL_PROMPTS.md) | 8단계 교육용 재작성 프롬프트. 실제 발화·실행 결과와 별개로 새로 작성. |
| A020 | [validate_package.py](assets/tools/validate_package.py) | 추출 패키지 읽기 전용 검증 도구. JSON/참조/파일/원본 해시 검사만 수행하며 ERP·AI·Telegram에 접속하지 않음. |

## 6. 빠진 핵심 자료와 필요한 보완

| 미확보 자료 | 추가로 필요한 것 | 이유 |
|---|---|---|
| 초기 AI 답변 전문·원래 코드 블록 | 이 대화방의 원시 내보내기 또는 역할·순서가 보이는 원문 | summary·excerpt를 실제 원문으로 교체하고 메시지 경계 확인 |
| 과거 시각 | 내보내기의 시각·시간대·메시지 ID | 이전 요약과 검색의 1~2초 차이를 임의 판정하지 않기 위함 |
| MCP·봇·Codex 연결 소스 | 실제 저장된 파일·의존성·서비스 설정의 버전 | 설명 예시와 구현본을 구분 |
| ERP API 명세 | 마스킹된 URL 구조·인증 방식·필드·권한·업무 오류 계약 | 가상 구매오더 예시를 회사 API로 오인하지 않게 함 |
| 실행 증거·화면 | 도구 호출, API 대조, 채팅 왕복, 오류/수정 전후, 재시작 시험 | ‘만들었다’·‘썼다’·‘검증했다’를 별도 판정 |
| 원래 업무 자료 | 추출 소스·업무 지침의 시스템·추출일·버전 | 소스 조건과 현재 데이터 비교의 근거 |
| 별도 Node.js ZIP | 해당 프로젝트가 제공할 원본·맥락·시험 결과 | 조회 MCP와 중앙 자문/협업 MCP의 책임을 대조. 이 프로젝트 구현으로 합치지 않음 |

현재 자료로는 역할·요구 수정·계약 작성·검증 계획·교육 데이터 검사 실습까지 할 수 있다. 실제 설치·ERP 연결·Telegram 발송은 승인된 환경과 명세, 실제 버전 검증이 있어야 재현할 수 있다. 이 작업에서는 서버 설치·GitHub push·웹사이트 구현·운영 ERP 변경을 하지 않았다.

## 7. 제외 자료와 이유

- 같은 이름의 이전 ZIP 두 사본: SHA-256이 동일하여 하나만 포함. 단순 중복 제거이며 버전 하나를 버린 것이 아니다.
- 다른 대화방의 소스 추출·하네스·Obsidian·TLS·포털 구현 정보: 현재 대화의 실제 실행 증거가 아니므로 제외.
- 개인 프로필·관계없는 검색 결과: 교육 범위 밖이며 사용하지 않았다.
- 접근하지 못한 오류 캡처·원래 서버 파일: 재생성하지 않고 A011~A016의 unavailable 항목으로 기록.
- 현재 SDK·장비 사양·가격에 대한 추가 조사: 과거 대화 추출 범위가 아니므로 수행하지 않음. 과거 문서의 설명은 과거 기록으로만 보존.
- 파일 크기를 이유로 잘라낸 대화나 첨부는 없다.

## 8. 포털에 넣을 때

`threads`의 전체 보존과 `episodes`의 교육 편집은 별도다. 기본 화면에서 ‘원문 / 발췌 / 이전 요약’ 배지를 표시하고, summary는 원문과 동일한 신뢰 수준으로 보이지 않게 한다. 교육 해설·재작성 프롬프트도 대화 말풍선과 구분한다. 시각 null은 ‘시각 미확인’, path null은 ‘원본 미확보’로 표시한다.

구성도에서는 lookup을 ERP 조회 MCP로 연결한다. hub·worker·expert·maps·diag는 이 프로젝트에서 해당 구현을 확인하지 못해 연결하지 않았다. GitHub·포털 배포는 후속 활용 의도이며 이번에 실행한 작업으로 보여주지 않는다.

일반 제품 화면을 생성 이미지로 채우지 않는다. 실제 캡처 요청은 이전 [자료 목록 B절](assets/previous_extract/ERP_MCP서버구성_ERP연동과텔레그램에이전트_2026-10-08/03_자료목록과보완사항.md)을 사용한다.

## 9. 마스킹과 검증

확보 발화와 첨부에 포함할 인증값·비밀번호·개인 식별값을 찾지 못해 이번 마스킹은 0건이다. 모든 messages.redacted는 false다. 과거 가상 번호와 .invalid 주소는 원래부터 교육 예시다. 마스킹이 필요해지는 후속 자료는 위치·이유를 기록하고 redacted를 true로 바꾼다.

```bash
python3 assets/tools/validate_package.py .
```

위 명령은 압축을 푼 최상위 폴더에서 실행한다. 표준 라이브러리만 쓰며 외부 통신·ERP/Telegram 실행·파일 수정은 하지 않는다. JSON·ID·참조·포함 파일·보존 원본의 동일성을 검사한다. PASS는 ERP 연동 성공을 뜻하지 않는다.

