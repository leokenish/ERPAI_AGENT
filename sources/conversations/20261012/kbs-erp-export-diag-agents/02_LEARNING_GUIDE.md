# 실제 대화를 따라가는 교육 과정

프로젝트: SAP 패키지 추출·읽기 전용 진단 및 업무 AI 에이전트 구축

project_id: `kbs-erp-export-diag-agents` · 기준일: 2026-10-12

## 이용 방법

SAP 개발·업무 담당자를 대상으로 한다. 패키지·함수·파일 경로의 기본 개념이 있으면 읽을 수 있다. SAP 실행 실습은 BASIS700 개발 환경과 읽기 권한·정확한 입력 ZIP이 필요하다. 이 ZIP만으로 운영 ERP에 프로그램을 설치하거나 변경하지 않는다.

각 단계의 발화는 실제 기록이고, 아래 해설·실습 프롬프트는 이번에 작성한 교육 콘텐츠다. 과거 잘못된 방법은 사례로 남기되 따라 하기에서는 현재 읽기 전용 DIAG와 출처 중심 업무 지식 방식을 사용한다. **당시 AI 응답 미확보**는 다른 파일의 내용으로 말풍선을 복원하지 말라는 뜻이다.

SAP 없이도 1) 발화 읽기 2) 오류 분류 3) RawData 해석 4) 합성 비교 5) 담당자 피드백 사례 작성은 가능하다. 아직 구현하지 않은 Actions·원격 협업·MCP는 설치 실습으로 채우지 않는다.

## 1. SAP 화면을 기준으로 추출 구조를 다시 정의하다 (E01)

### 1.1 학습 목표

개발자가 쓰는 화면 용어를 파일 경로 계약으로 바꾼다.

### 1.2 이전 상황과 준비물

ZMM6 추출 프로그램과 BSP 애플리케이션 ZPCM0001 화면. 프로그램의 최초 개발 대화는 확보하지 못했다.

### 1.3 관련 실제 발화 ID

U002, U003, U004, U005 — [전체 발화](assets/conversation/visible_messages.md)에서 같은 ID로 탐색한다.

### 1.4 사용자가 요구한 핵심

중복 경로로 ZIP이 중단되는 문제를 검토하고 BSP의 다섯 탭, 실제 이벤트 이름, Properties 및 Page Attributes를 파일 구조에 반영해 달라고 요청했다.

### 1.5 AI 대응과 결과물의 확인 수준

당시 AI 답변 원문은 미확보. 현재 Export 0.3.18 소스와 기존 Export 가이드에서 탭별 경로와 이벤트 이름 처리 구현을 확인할 수 있다.

### 1.6 오류·오해·누락 또는 판단

attributes.xml 등 구현 편의상 나눈 파일 이름은 SAP 사용자가 이해하는 탭과 달랐다. U003의 “OnDestory”는 원문 오타를 보존한다. 교육 해설에서는 OnDestroy로 구분한다. ZIP 충돌은 개별 데이터 누락과 다른 오류다.

### 1.7 추가 설명과 수정이 필요했던 이유

첫 요청은 불필요한 XML 삭제처럼 보였지만 U004에서 Properties·Page Attributes의 정보를 보존해야 한다는 요구가 추가됐다. 파일명 변경과 데이터 폐기는 구분해야 했다.

### 1.8 다음 단계로 넘어간 근거

U005에서 해당 방향으로 재작성을 요청했다는 결정 근거가 있다. 이 시점 수정본의 SAP 성공 실행은 원문 답변이나 코드 버전으로 확정할 수 없다.

### 1.9 따라 하기 실습 — 교육용 재작성 프롬프트

본인 패키지의 BSP 한 페이지를 골라 SAP의 다섯 탭과 추출 파일을 표로 대조한다. 프롬프트: “실제 페이지의 Properties, Layout, Event Handler, Page Attributes, Type Definitions와 파일 경로를 대응시켜줘. 원본에 없는 이벤트 코드를 만들지 말고 이름을 확인하지 못하면 미확인으로 남겨줘.”

### 1.10 확인 방법과 흔한 실패

페이지 경로·확장자·이벤트명·UTF-8 한글이 보존되는지 확인한다. 파일 이름만 예쁘게 바꾸고 본문이 빠진 경우를 통과시키지 않는다. 현재 완전한 ZMM6 ZIP이 없으므로 첨부 화면과 코드 검토부터 수행한다.

### 1.11 관련 캡처·코드·문서

- `CODE-EXPORT`: [Z_PACKAGE_EXPORT.abap](assets/code/Z_PACKAGE_EXPORT_0_3_18.abap) — 접근 가능한 최신 Export 소스. 0.3.18. 현재 SAP 설치본과 같다는 뜻은 아님.
- `DOC-EXPORT-GUIDE`: [DEVHUB_EXPORT_GUIDE.md](assets/references/DEVHUB_EXPORT_GUIDE.md) — Export·오프라인 검사 가이드.
- `IMG-U002-1`: [0840834c-7367-409f-ba43-a7f4dd68f538.png](assets/images/U002_1.png) — BSP 중복·대소문자 충돌 경로로 ZIP 중단
- `IMG-U003-1`: [88d9858a-1280-40a2-a80b-3d11ed419936.png](assets/images/U003_1.png) — ZMM6 결과 점검 및 SAP BSP 탭 화면
- `IMG-U003-2`: [111fa5e9-ceb1-49c9-8085-4f4c9da4bc3c.png](assets/images/U003_2.png) — ZMM6 결과 점검 및 SAP BSP 탭 화면
- `IMG-U004-1`: [ea915e65-4844-4da7-98de-d9987fd1f165.png](assets/images/U004_1.png) — BSP Properties / Page Attributes 실제 화면
- `IMG-U004-2`: [96cec730-05f7-496d-8a98-ffc5d4e3efbe.png](assets/images/U004_2.png) — BSP Properties / Page Attributes 실제 화면

## 2. 20개 변경 요청을 출력 계약으로 구체화하다 (E02)

### 2.1 학습 목표

폴더 이름, 정보 단위, 예외를 명시하여 AI의 경로 해석 오해를 줄인다.

### 2.2 이전 상황과 준비물

BSP 재구성 이후 DDIC·함수·MIME·구조체·메시지 클래스까지 동일한 읽기 방식을 요구하는 상황.

### 2.3 관련 실제 발화 ID

U006, U007, U008, U009, U010 — [전체 발화](assets/conversation/visible_messages.md)에서 같은 ID로 탐색한다.

### 2.4 사용자가 요구한 핵심

KO 경로 수식 제거, Dictionary Object/DBtable/TableType/Structures, 함수 탭 XML, MIMEs 원본 폴더, 메시지 번호를 가진 Messages.xml을 요청했다.

### 2.5 AI 대응과 결과물의 확인 수준

당시 AI의 수정 응답은 미확보. 현재 소스와 PROJECT_CONTEXT §4에서 경로 계약을 확인한다. NORMAL 파라미터 오류의 당시 정확한 수정 diff는 미확보다.

### 2.6 오류·오해·누락 또는 판단

Function Module 바로 아래 공용 Source code 폴더가 생긴 것은 U009에서 사용자가 바로잡았다. 요구한 최종 단위는 각 함수 폴더 아래 Source code/함수명.abap이다. U006의 Inlcude 표기는 원문 그대로 남기고 현재 경로와 구분한다.

### 2.7 추가 설명과 수정이 필요했던 이유

“functions 아래”라는 상대 경로 표현만으로는 함수별 소유 관계가 충분히 전달되지 않았다. XML 가독성은 줄바꿈·들여쓰기 요구와 값 보존 요구가 함께 필요했다.

### 2.8 다음 단계로 넘어간 근거

U009에서 사용자가 잘못된 구조의 실제 화면을 제시하고 정확한 경로를 재설명했다. U010에서 ZCO3 메시지 클래스 확장과 전체 배포 ZIP 제공을 요청했다. Messages.xml 구현은 현재 소스 근거로 확인한다.

### 2.9 따라 하기 실습 — 교육용 재작성 프롬프트

프롬프트: “packages/패키지/function-groups/FUGR/그룹/Function Module/함수명/Source code/함수명.abap 구조를 계약으로 삼아줘. Import.xml 등 함수 탭 XML의 목적을 표로 설명하고, 메시지 000과 &1 자리표시자도 보존해줘.” 자신의 패키지 한 함수로 경로 명세를 작성한다.

### 2.10 확인 방법과 흔한 실패

동명 함수·하위 그룹·빈 인터페이스·000 메시지 번호를 확인한다. KO 경로 삭제를 한국어 값 삭제로 해석하면 실패다. NORMAL 3067줄은 과거 버전 위치이므로 현재 같은 줄을 기계적으로 바꾸지 않는다.

### 2.11 관련 캡처·코드·문서

- `CODE-EXPORT`: [Z_PACKAGE_EXPORT.abap](assets/code/Z_PACKAGE_EXPORT_0_3_18.abap) — 접근 가능한 최신 Export 소스. 0.3.18. 현재 SAP 설치본과 같다는 뜻은 아님.
- `DOC-CONTEXT`: [PROJECT_CONTEXT.md](assets/references/PROJECT_CONTEXT_20261008_v3.md) — 기존 인계·요약 문서. 원문 대화가 아니며 최신성은 파일 내부 기준.
- `IMG-U006-1`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.
- `IMG-U006-2`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.
- `IMG-U006-3`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.
- `IMG-U006-4`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.
- `IMG-U006-5`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.
- `IMG-U006-6`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.
- `IMG-U006-7`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.
- `IMG-U006-8`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.
- `IMG-U006-9`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.
- `CODE-CHECK`: [DEVHUB_CHECK_0_3_3.html](assets/tools/DEVHUB_CHECK_0_3_3.html) — 기존 오프라인 Export 결과 검사 도구. 교육 포털을 새로 만든 파일이 아님.
- `IMG-U009-1`: [3b1e2e90-3279-40f2-af7c-4f73beff5585.png](assets/images/U009_1.png) — 함수별 Source code 위치 오해와 ZMM6 점검
- `IMG-U009-2`: [473b0fc7-1fbe-4783-b214-a6f4c17f4fc6.png](assets/images/U009_2.png) — 함수별 Source code 위치 오해와 ZMM6 점검
- `IMG-U010-1`: [4e268c2f-1dd1-4f32-8c35-91c4aa0c8aa1.png](assets/images/U010_1.png) — ZCO3 메시지 클래스

## 3. 언어 fallback과 XML 값 보존 오류를 분리하다 (E03)

### 3.1 학습 목표

오류 메시지를 근거로 가설을 수정하고 동일성 검사를 유지한다.

### 3.2 이전 상황과 준비물

한국어만 추출하던 프로그램에서 XML 값 변경 self-test가 멈췄다.

### 3.3 관련 실제 발화 ID

U011, U012, U013 — [전체 발화](assets/conversation/visible_messages.md)에서 같은 ID로 탐색한다.

### 3.4 사용자가 요구한 핵심

사용자는 한국어 제한 문제로 추측하여 KO 시도 후 일부 EN fallback을 요청했고, 이후 Raw XML round-trip 오류 화면도 제공했다.

### 3.5 AI 대응과 결과물의 확인 수준

당시 AI 답변과 중간 수정본은 미확보. 현재 소스의 KO 우선/EN fallback 및 XML 값 보존 처리, 기존 검증 문서를 별도 근거로 연결한다.

### 3.6 오류·오해·누락 또는 판단

Generated XML formatting changed field values와 Raw XML round-trip changed values before formatting는 발생 단계가 다르다. 화면 첫 줄의 언어 안내가 원인이라는 증거는 아니다. EN fallback을 넣은 뒤에도 raw round-trip 실패가 나타났다.

### 3.7 추가 설명과 수정이 필요했던 이유

사용자의 원인 가설을 사실로 채택하면 언어 정책만 바꾸고 직렬화 오류를 놓친다. XML pretty print는 표시 개선이며 실제 값·공백·개행·문자 인코딩을 바꾸면 안 된다.

### 3.8 다음 단계로 넘어간 근거

U013 점검 화면은 파일 동일 4,285/변경 0/파일 실패 0, SAP 실패 객체 3이라는 실행 보고다. 전체 무오류 완료는 아니며 해당 결과의 정확한 소스 버전은 미확인이다.

### 3.9 따라 하기 실습 — 교육용 재작성 프롬프트

프롬프트: “언어 선택, 원시 XML 직렬화, 들여쓰기를 별도 단계로 검사해줘. 한국어·영어 혼합, 공백, 줄바꿈, &, <, 000을 가진 fixture로 값이 바뀌는 첫 단계를 찾아줘. 보호 검사를 삭제해서 성공시키지 말아줘.”

### 3.10 확인 방법과 흔한 실패

XML 파싱 성공뿐 아니라 원래 값의 보존을 확인한다. SAP 재현에는 해당 BASIS 환경이 필요하다. 로컬 예시를 통과한 것을 SAP 직렬화 통과로 쓰지 않는다.

### 3.11 관련 캡처·코드·문서

- `DOC-EXPORT-VALIDATION`: [DEVHUB_0_3_18_VALIDATION.md](assets/references/DEVHUB_0_3_18_VALIDATION.md) — 기존 Export 0.3.18 검증 기록. 현 시점 SAP 재실행 결과 아님.
- `CODE-EXPORT`: [Z_PACKAGE_EXPORT.abap](assets/code/Z_PACKAGE_EXPORT_0_3_18.abap) — 접근 가능한 최신 Export 소스. 0.3.18. 현재 SAP 설치본과 같다는 뜻은 아님.
- `IMG-U011-1`: [861d261f-c251-4bb5-bd18-b930b3d692bf.png](assets/images/U011_1.png) — XML formatting changed field values
- `IMG-U012-1`: [a4638313-ae1c-47b0-9e45-cd17eefdafb6.png](assets/images/U012_1.png) — Raw XML round-trip changed values before formatting
- `CODE-CHECK`: [DEVHUB_CHECK_0_3_3.html](assets/tools/DEVHUB_CHECK_0_3_3.html) — 기존 오프라인 Export 결과 검사 도구. 교육 포털을 새로 만든 파일이 아님.
- `IMG-U013-1`: [67b7a7bc-fa1b-45af-b6c6-eb6843693aaf.png](assets/images/U013_1.png) — Export 점검 결과

## 4. 대용량·미지원·생략을 추출 정책으로 다루다 (E04)

### 4.1 학습 목표

추출 성공률과 실제 정보 손실을 구분하고 로그 정책을 정한다.

### 4.2 이전 상황과 준비물

ZMM6/ZCO3를 거쳐 ZHR·ZWEB처럼 큰 패키지로 확장. 사용 목적은 업무 에이전트의 소스 근거 확보다.

### 4.3 관련 실제 발화 ID

U014, U015, U016, U017, U018, U019, U020 — [전체 발화](assets/conversation/visible_messages.md)에서 같은 ID로 탐색한다.

### 4.4 사용자가 요구한 핵심

활성 소스 읽기 실패 제외, 패키지명 ZIP, 입력 단순화, 예산값 조정, 특정 MIME/DDIC 오류는 생략 기록, 외부 공통 클래스 미지원 유지, MIME 유형별 폴더와 통합 metadata를 요청했다.

### 4.5 AI 대응과 결과물의 확인 수준

현재 Export 0.3.18 및 가이드·ZWEB 검토 문서가 후속 구현의 근거다. 각 중간 버전에서 어떤 AI가 어떤 문장으로 수정했다고 답했는지는 원문 미확보다.

### 4.6 오류·오해·누락 또는 판단

NO-DISPLAY와 AS CHECKBOX 조합 오류, 비압축 ZIP 예산 초과가 실제 화면에 있다. Table category S의 SE16 조회 실패가 곧 구조 메타데이터 추출 불가능을 뜻하지 않는다. “로그 0”은 생략이 없다는 뜻이 아니다.

### 4.7 추가 설명과 수정이 필요했던 이유

사용자는 AI 학습에 불필요한 기술 공통 참조 확장을 원하지 않았다. .devhub/baseline 중복 질문은 저장 용량/AI 검색 효율과 진단 비교 기준의 보존을 함께 고려해야 했다.

### 4.8 다음 단계로 넘어간 근거

ZWEB 후속 화면 U020은 SAP 실패 0, 오류 0, 생략 객체 19, 참고 로그 19, 웹 완료 2,637을 보여준다. 결함을 고쳐 복구한 것과 알려진 생략을 분리한 것을 혼동하지 않는다. 현재 코드의 기본 누적 예산은 초기 256과 달리 512 MiB다.

### 4.9 따라 하기 실습 — 교육용 재작성 프롬프트

프롬프트: “추출 대상·지원·의도적 제외·실패를 분리해 목록을 만들어줘. baseline은 진단 기준으로 보존하고 AI 색인에서는 중복 제외해줘. ZIP은 패키지명_export.zip으로 만들고 예산 초과 원인을 파일별/누적별로 설명해줘.”

### 4.10 확인 방법과 흔한 실패

한 번의 추출에서 대상 수, 생성 수, 생략 수를 함께 검토한다. 읽기 실패를 비활성 확정으로 단정하지 않는다. 예산을 무제한 늘리는 방식은 실습 해법으로 쓰지 않는다.

### 4.11 관련 캡처·코드·문서

- `DOC-ZWEB`: [DEVHUB_ZWEB_0_3_17_REVIEW.md](assets/references/DEVHUB_ZWEB_0_3_17_REVIEW.md) — 기존 ZWEB 분석 문서. 생략 객체의 의미와 범위.
- `DOC-EXPORT-GUIDE`: [DEVHUB_EXPORT_GUIDE.md](assets/references/DEVHUB_EXPORT_GUIDE.md) — Export·오프라인 검사 가이드.
- `DOC-EXPORT-VALIDATION`: [DEVHUB_0_3_18_VALIDATION.md](assets/references/DEVHUB_0_3_18_VALIDATION.md) — 기존 Export 0.3.18 검증 기록. 현 시점 SAP 재실행 결과 아님.
- `IMG-U016-1`: [3b88e164-e626-4f20-b2bf-639d429074d6.png](assets/images/U016_1.png) — NO-DISPLAY와 AS CHECKBOX 동시 사용 오류
- `IMG-U017-1`: [c2aa197c-4309-4a98-8363-30427f005351.png](assets/images/U017_1.png) — Export 0.3.16 비압축 ZIP 예산 초과
- `CODE-CHECK`: [DEVHUB_CHECK_0_3_3.html](assets/tools/DEVHUB_CHECK_0_3_3.html) — 기존 오프라인 Export 결과 검사 도구. 교육 포털을 새로 만든 파일이 아님.
- `IMG-U018-1`: [8d008caf-fec3-4402-8c30-e98ec73712c0.png](assets/images/U018_1.png) — ZWEB 초기 오류 19건
- `CODE-EXPORT`: [Z_PACKAGE_EXPORT.abap](assets/code/Z_PACKAGE_EXPORT_0_3_18.abap) — 접근 가능한 최신 Export 소스. 0.3.18. 현재 SAP 설치본과 같다는 뜻은 아님.
- `IMG-U020-1`: [6a1dd694-a348-45b2-9a93-49804d591794.png](assets/images/U020_1.png) — ZWEB 생략 객체 19건으로 분리된 점검

## 5. GitHub publish와 Mac clone으로 업무 에이전트를 시작하다 (E05)

### 5.1 학습 목표

저장소 공유, PR, 로컬 작업공간의 역할을 구분한다.

### 5.2 이전 상황과 준비물

패키지 Export를 VS Code에서 GitHub로 공유하고 MacBook Air의 Codex Desktop에서 이용하려는 상황.

### 5.3 관련 실제 발화 ID

U021, U022, U023, U024 — [전체 발화](assets/conversation/visible_messages.md)에서 같은 ID로 탐색한다.

### 5.4 사용자가 요구한 핵심

무엇을 먼저 할지 질문한 후 publish 성공, PR 목록이 안 보이는 문제, Mac clone과 ZHR5 에이전트 생성 성공을 보고했다.

### 5.5 AI 대응과 결과물의 확인 수준

당시 안내 응답은 미확보. U023·U024는 사용자의 성공 보고다. 현재 저장소 URL·브랜치·설치된 Codex 버전·AGENTS 적용 상태는 직접 확인하지 못했다.

### 5.6 오류·오해·누락 또는 판단

clone/pull과 pull request는 목적이 다르다. PR 목록이 비어 있다고 저장소가 없거나 clone이 실패했다는 뜻은 아니다. 에이전트 폴더 공유와 원격 에이전트 자동 협업은 같은 기능이 아니다.

### 5.7 추가 설명과 수정이 필요했던 이유

코드를 GitHub에 두는 것만으로 업무 지식이나 실행 주체가 생기지 않는다. 담당 패키지 범위·입력·응답 책임을 별도로 정해야 한다.

### 5.8 다음 단계로 넘어간 근거

U024의 “맥북…클론…ZHR5 AI 에이전트…성공”은 실제 사용 보고로 보존한다. ZFI/ZMM 다중 에이전트의 자동 협업 운영은 확인하지 못했다.

### 5.9 따라 하기 실습 — 교육용 재작성 프롬프트

교육용 재작성 프롬프트: “이 로컬 프로젝트의 실제 파일부터 확인하고 ZHR5 업무 에이전트의 읽기 범위와 근거 경로를 정리해줘. 현재 브랜치·변경 파일을 보여주되 push는 하지 말아줘.” 준비된 저장소가 있을 때 로컬에서 `git status --short`와 `git log -5 --oneline`으로 상태를 기록한다.

### 5.10 확인 방법과 흔한 실패

보고서의 파일 경로가 실제 존재하는지 확인한다. 예시 명령은 조회용이며 현재 저장소를 우리가 검증했다는 뜻은 아니다. PR 만들기를 clone 절차로 대체하지 않는다.

### 5.11 관련 캡처·코드·문서

- `DOC-BUILD`: [PACKAGE_AGENT_BUILD_GUIDE.md](assets/references/PACKAGE_AGENT_BUILD_GUIDE.md) — 새 패키지에 업무 지식·Export·스킬을 통합하는 기존 가이드. 실행 완료 증거와 구분.

## 6. 코드만으로 부족한 업무 지식을 문서·스킬로 보완하다 (E06)

### 6.1 학습 목표

규정, 대화, 매뉴얼의 권위와 시점을 보존하여 업무 답변 근거를 만든다.

### 6.2 이전 상황과 준비물

ZHR5 에이전트가 코드를 참고할 수 있으나 정책·담당자 판단·업무 경위가 부족했다.

### 6.3 관련 실제 발화 ID

U025, U026, U027, U028, U029, U030, U031, U032 — [전체 발화](assets/conversation/visible_messages.md)에서 같은 ID로 탐색한다.

### 6.4 사용자가 요구한 핵심

카톡 텍스트, 업무 매뉴얼, 회사 규정·지침, 회의록, 양식, 용어집을 MD로 정리하고 AGENTS/INDEX/SKILL/EXPORT_GUIDE/business-qa와 재사용 가이드를 만들라고 요청했다. U030과 U031의 반복 요청은 삭제하지 않았다.

### 6.5 AI 대응과 결과물의 확인 수준

현재 기존 구축 가이드, 피드백 지침, 용어집, 세 스킬 사본이 존재한다. 과거 업로드 원문 전체를 이번에 다시 읽은 것은 아니다. 문서 생성·설치 안내와 사용자 Mac에서 실제 로드된 스킬은 구분한다.

### 6.6 오류·오해·누락 또는 판단

카톡에서 과거 담당자가 한 말은 현재 회사 규정의 확정 근거와 다를 수 있다. 모든 원문을 SKILL.md 하나에 넣으면 출처와 적용 시점이 사라지고 탐색 비용이 커진다.

### 6.7 추가 설명과 수정이 필요했던 이유

사용자가 원한 것은 단순 요약이 아니라 패키지마다 반복 가능한 통합 방식이었다. 스킬에는 절차·호출 조건을, 지식 MD에는 출처와 업무 내용을, 원문에는 보존 책임을 나눠야 한다.

### 6.8 다음 단계로 넘어간 근거

PACKAGE_AGENT_BUILD_GUIDE와 세 스킬의 확보는 산출물 존재 근거다. 기존 지식 키트 검증 문서의 QA 항목은 초안으로 구분하며 업무 정답 34개가 모두 검증됐다고 주장하지 않는다.

### 6.9 따라 하기 실습 — 교육용 재작성 프롬프트

프롬프트: “먼저 자료 목록과 확인 여부를 작성해줘. 규정의 시행일, 회의 합의일, 카톡 발언일을 분리하고 출처가 다른 주장 사이의 충돌을 남겨줘. AGENTS에는 작업 원칙, INDEX에는 탐색 링크, 스킬에는 절차, 업무 MD에는 근거를 배치해줘.” 원문 하나로 작은 범위를 실습한다.

### 6.10 확인 방법과 흔한 실패

각 주장에 원문 위치·적용 시점·확인 상태가 있는지, 인용을 열 수 있는지 점검한다. 이번 ZIP의 스킬 사본은 자동 설치되지 않는다. 사용자 이름·연락처·인사정보는 업무에 꼭 필요한지 판단해 교육판에서 마스킹한다.

### 6.11 관련 캡처·코드·문서

- `DOC-BUILD`: [PACKAGE_AGENT_BUILD_GUIDE.md](assets/references/PACKAGE_AGENT_BUILD_GUIDE.md) — 새 패키지에 업무 지식·Export·스킬을 통합하는 기존 가이드. 실행 완료 증거와 구분.
- `DOC-KNOWLEDGE`: [ZHR5_KNOWLEDGE_SETUP.md](assets/references/ZHR5_KNOWLEDGE_SETUP.md) — 기존 ZHR5 업무 지식 설치 안내. 사용자의 현재 Mac 구성 검증은 아님.
- `DOC-GLOSSARY`: [SAP_OBJECT_GLOSSARY.md](assets/references/SAP_OBJECT_GLOSSARY.md) — SAP 객체·폴더를 해석하는 기존 용어집.
- `DOC-KIT-VALIDATION`: [VALIDATION.md](assets/references/ZHR5_KIT_VALIDATION_20260922.md) — 기존 지식 키트 자체 검증 기록. 업무 질문 정답 검증 전체 통과로 해석하지 않음.
- `SKILL-01`: [SKILL.md](assets/references/skills/zhr5-business-qa/SKILL.md) — 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.
- `SKILL-02`: [openai.yaml](assets/references/skills/zhr5-business-qa/agents/openai.yaml) — 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.
- `SKILL-03`: [answer-format.md](assets/references/skills/zhr5-business-qa/references/answer-format.md) — 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.
- `SKILL-04`: [SKILL.md](assets/references/skills/zhr5-change-impact/SKILL.md) — 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.
- `SKILL-05`: [openai.yaml](assets/references/skills/zhr5-change-impact/agents/openai.yaml) — 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.
- `SKILL-06`: [impact-template.md](assets/references/skills/zhr5-change-impact/references/impact-template.md) — 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.
- `SKILL-07`: [SKILL.md](assets/references/skills/zhr5-knowledge-curation/SKILL.md) — 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.
- `SKILL-08`: [openai.yaml](assets/references/skills/zhr5-knowledge-curation/agents/openai.yaml) — 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.
- `SKILL-09`: [document-template.md](assets/references/skills/zhr5-knowledge-curation/references/document-template.md) — 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.
- `MISSING-BUSINESS-ORIGINALS`: 배포 파일 없음 — 대화에서 업로드했다고 한 카톡 전문·규정·지침·매뉴얼·양식 원문 전체. 이번 교육 추출에서 전량 확보·재검토하지 않음.

## 7. 업무 답변 하네스를 코드 하네스와 분리하다 (E07)

### 7.1 학습 목표

실행 오류가 없는 답변도 평가할 수 있도록 실패 조건을 만든다.

### 7.2 이전 상황과 준비물

하네스 폴더 예시가 제시됐으나 업무 질의에서는 SAP 오류가 발생하지 않아 피드백의 기준이 불명확했다.

### 7.3 관련 실제 발화 ID

U033, U034, U035, U036, U037, U038 — [전체 발화](assets/conversation/visible_messages.md)에서 같은 ID로 탐색한다.

### 7.4 사용자가 요구한 핵심

업무 검증과 코드 검증을 나누고, 업무 답변이 이상하면 담당자 피드백을 받아 MD·회귀 검증 파일을 자동 수정하는 지속 지침을 요청했다.

### 7.5 AI 대응과 결과물의 확인 수준

BUSINESS_FEEDBACK_POLICY.md가 확인된다. 원래 제안한 모든 harness/*.py와 운영 자동 반복 루프가 실제 구현·실행됐다는 증거는 확보하지 못했다.

### 7.6 오류·오해·누락 또는 판단

“에러가 안 뜬다”와 “업무 답변이 맞다”는 다르다. 잘못된 시행일 적용, 근거 없는 단정, 예외 누락, 출처 위조도 업무 실패다. 실패 테스트를 삭제하거나 정답을 현재 답변에 맞추는 것은 회귀 검증이 아니다.

### 7.7 추가 설명과 수정이 필요했던 이유

MD 수정 권한이 있어도 SAP 반영 권한까지 포함하지 않는다. 피드백마다 원문 근거와 업무 담당자 확인이 필요한 지점을 구분해야 했다.

### 7.8 다음 단계로 넘어간 근거

U036에서 업무 하네스를 우선 구현하겠다는 범위 결정, U037의 지속 MD 요청, 기존 지침 파일이 근거다. 실제 전 사례 PASS 또는 무인 운영 성공은 미확인이다.

### 7.9 따라 하기 실습 — 교육용 재작성 프롬프트

프롬프트: “이 답변은 적용 시점을 잘못 해석했어. 근거 문서의 해당 절을 확인하고 원인·수정 MD·추가 회귀 사례를 제시해줘. 근거가 부족하면 REVIEW_REQUIRED로 남겨줘. ABAP, Export 원본, baseline은 수정하지 말아줘.” 담당자 승인 근거가 있는 한 사례만 처리한다.

### 7.10 확인 방법과 흔한 실패

질문/적용일/필수 근거/기대 판단/금지 단정/검토 상태를 기록한다. PASS·FAIL·REVIEW_REQUIRED·NOT_RUN을 구분한다. 평가 코드를 고칠 때 기존 실패 사례를 지워 성공 수치만 높이지 않는다.

### 7.11 관련 캡처·코드·문서

- `DOC-FEEDBACK`: [BUSINESS_FEEDBACK_POLICY.md](assets/references/BUSINESS_FEEDBACK_POLICY.md) — 업무 답변 피드백 처리 지침. 출처 확인·MD 수정·회귀 사례 갱신 범위.

## 8. SAP에서 GitHub에 직접 접속하려다 통신 제약을 확인하다 (E08)

### 8.1 학습 목표

통신 오류 코드·로그·보류 결정을 연결해 재현한다.

### 8.2 이전 상황과 준비물

수정 ZIP 수동 업로드를 줄이기 위해 BASIS700의 ABAP에서 GitHub 목록을 조회하는 실험을 시작했다.

### 8.3 관련 실제 발화 ID

U039, U040, U041, U042, U043, U044, U045 — [전체 발화](assets/conversation/visible_messages.md)에서 같은 ID로 탐색한다.

### 8.4 사용자가 요구한 핵심

계정·주소·키를 필요하면 입력받는 읽기 전용 통신 검증 코드를 요청하고 RECEIVE 오류와 ICM 로그를 제공했다. 이후 보안 프로토콜 때문에 직접 통신은 보류했다.

### 8.5 AI 대응과 결과물의 확인 수준

GITHUB_ABAP_CONNECTION_TEST.zip의 코드·README와 실제 ICM 로그를 확보했다. 당시 AI 설명 원문은 없으며 현재 파일을 근거로 기능 범위를 설명한다.

### 8.6 오류·오해·누락 또는 판단

화면의 SAP error code 407 / ICM_HTTP_SSL_ERROR를 HTTP 407 프록시 인증으로 자동 해석하면 안 된다. ICM 로그 234–247행에 TLS1.0 protocol version alert와 SSSLERR_SSL_CONNECT가 있다. 정확한 커널·암호화 라이브러리 구성 변경 후 성공 여부는 미확인이다.

### 8.7 추가 설명과 수정이 필요했던 이유

GitHub 토큰이나 URL을 바꾸는 일과 HTTPS 프로토콜 협상 실패 해결은 분리해야 했다. 사용자는 시스템 설정 변경을 계속 밀어붙이지 않고 작업 흐름을 보류했다.

### 8.8 다음 단계로 넘어간 근거

U045에 명시적인 통신 보류 결정이 있다. 비밀키를 받은 기록이나 성공 통신 결과는 이번 자료에 없다. TLS 검증 해제는 최종 방식이 아니다.

### 8.9 따라 하기 실습 — 교육용 재작성 프롬프트

프롬프트: “오류 화면의 코드가 HTTP 응답인지 SAP transport 오류인지 구분해줘. 마스킹된 ICM 로그에서 직접 확인되는 문구만 근거로 후보 원인을 정리하고, 확인하지 않은 설정값을 존재한다고 단정하지 말아줘.” 실제 네트워크 연결 실습은 하지 않고 첨부 로그를 읽는다.

### 8.10 확인 방법과 흔한 실패

로그의 protocol alert와 일반 traffic timeout을 구분한다. 계정·토큰을 Git이나 프롬프트에 저장하지 않는다. 재시도에는 BASIS 담당자의 지원 범위 확인이 필요하며 이 ZIP은 시스템 보안 설정을 변경하지 않는다.

### 8.11 관련 캡처·코드·문서

- `HISTORY-GITHUB`: [GITHUB_ABAP_CONNECTION_TEST.zip](assets/history/GITHUB_ABAP_CONNECTION_TEST.zip) — 과거 GitHub 목록 조회 실험 코드와 README. 통신 보류 사례이며 현재 실습 권장 경로는 아님.
- `LOG-ICM`: [icm_result.txt](assets/logs/icm_result.redacted.txt) — ICM 원본 로그의 교육용 마스킹 사본. 행 순서 유지. 234–247행 TLS1.0 protocol version alert / SSL_CONNECT 확인.
- `IMG-U042-1`: [3a9b8319-2215-49ba-ac6a-ae888cda4d01.png](assets/images/U042_1.png) — GitHub RECEIVE 단계 SAP 오류코드 407 / ICM_HTTP_SSL_ERROR

## 9. GitHub Actions를 AI와 구분해 이해하다 (E09)

### 9.1 학습 목표

자동 실행 규칙, 검증 범위, 로컬 피드백의 경계를 이해한다.

### 9.2 이전 상황과 준비물

SAP 직접 GitHub 접속은 보류하고 저장소에서 검증을 자동화할 수 있는지 알아보는 단계.

### 9.3 관련 실제 발화 ID

U046, U047, U048, U049, U050, U051, U052, U053 — [전체 발화](assets/conversation/visible_messages.md)에서 같은 ID로 탐색한다.

### 9.4 사용자가 요구한 핵심

Actions 설치, YAML 역할, ABAP 검사 가능 여부, CI/CD의 지속이라는 말, AI 여부, push하지 않을 때 실행과 로컬 Codex 전달, Ubuntu 러너·Docker의 관계를 순차 질문했다.

### 9.5 AI 대응과 결과물의 확인 수준

당시 설명 원문과 실제 workflow YAML은 미확보. 사용자 질문과 기존 프로젝트 인계서의 Actions 역할 설명만 근거로 사용한다. 실행된 CI 로그는 없다.

### 9.6 오류·오해·누락 또는 판단

YAML 자체가 코드 품질을 판단하는 AI가 아니다. workflow가 지정한 도구를 러너에서 실행한다. 저장소 검사 통과가 BASIS700의 문법·권한·DDIC 활성화·실행 성공을 대신하지 않는다.

### 9.7 추가 설명과 수정이 필요했던 이유

GitHub 이벤트에서의 실행과 로컬 Codex가 실패를 읽고 고치는 연결은 별도 구성이다. Ubuntu는 선택 가능한 환경이지 이 프로젝트의 필수 업무 요구가 아니다.

### 9.8 다음 단계로 넘어간 근거

U054에서 사용하겠다는 의향을 밝히고 다음 단계로 이동했다. 실제 workflow 설치·실행·배포는 검증되지 않았다.

### 9.9 따라 하기 실습 — 교육용 재작성 프롬프트

프롬프트: “저장소에 workflow가 실제 있는지 먼저 확인해줘. 없다면 미구현이라고 표시해줘. 현재 파일로 로컬 검증 가능한 JSON 파싱, 링크, 합성 비교 실습을 실행하고 그 결과를 SAP 검증과 구분해줘.” 새 workflow 제작이나 push는 별도 작업으로 둔다.

### 9.10 확인 방법과 흔한 실패

검증 명령·대상·실패 조건이 없는 YAML은 교육상 구현 완료로 분류하지 않는다. 실패 로그를 Codex에 직접 제공하는 수동 피드백부터 재현한다.

### 9.11 관련 캡처·코드·문서

- `DOC-CONTEXT`: [PROJECT_CONTEXT.md](assets/references/PROJECT_CONTEXT_20261008_v3.md) — 기존 인계·요약 문서. 원문 대화가 아니며 최신성은 파일 내부 기준.
- `EX-COMPARE`: [compare_cases.py](assets/examples/compare_cases.py) — 기존 교육 자료. compare_cases/three_way_cases는 합성 실습이며 SAP 테스트가 아님.

## 10. 첫 Import는 비교 리포트부터 시작하다 (E10)

### 10.1 학습 목표

원래 목표와 실제 제공 프로그램의 실행 권한을 구분한다.

### 10.2 이전 상황과 준비물

ABAP·XML·BSP 웹 자산의 변경 내역과 활성화 가능성을 알고 싶었으나 BASIS700 제약이 있었다.

### 10.3 관련 실제 발화 ID

U054, U055, U056, U057, U058, U059 — [전체 발화](assets/conversation/visible_messages.md)에서 같은 ID로 탐색한다.

### 10.4 사용자가 요구한 핵심

ZIP 업로드, 전후 줄 비교, 활성화 가능성 확인, 첫 Import 프로그램을 요청한 후 744줄 MOD relational operator 오류와 C→B 선택 실행 결과를 보고했다.

### 10.5 AI 대응과 결과물의 확인 수준

초기 DEVHUB_IMPORT_0_1_0.zip이 존재하며 README와 코드는 읽기 전용 비교·사전검사 범위다. 이름이 Import라고 자동 저장·활성화를 구현한 것으로 볼 수 없다. 당시 AI 응답·해당 오류 수정 diff는 미확보다.

### 10.6 오류·오해·누락 또는 판단

최신 ABAP 문법으로 작성된 코드가 BASIS700에서 활성화되지 않는 호환 문제가 반복됐다. 웹 소스의 줄 차이를 표시하는 것과 브라우저/ERP에서 정상 동작하는 것은 다른 검증이다.

### 10.7 추가 설명과 수정이 필요했던 이유

입력 파일의 문법이 맞아도 함수 컨텍스트·Include·DDIC 의존성·권한을 모두 확정할 수 없다. 실제 반영 전 비교 리포트부터 좁히는 이유가 생겼다.

### 10.8 다음 단계로 넘어간 근거

U059는 사용자가 프로그램을 실행하고 결과를 엑셀로 내보냈다고 한 보고다. 당시 실행 버전과 후속 result.xlsx가 동일하다는 근거는 없다.

### 10.9 따라 하기 실습 — 교육용 재작성 프롬프트

초기 ZIP의 README를 읽고 입력·읽기·쓰기·활성화 항목을 표로 만든다. 프롬프트: “이 소스에서 실제 SAP 저장 호출과 읽기 호출을 구분하고, 이름만으로 Import 실행이라고 추측하지 말아줘. BASIS700에서 검증되지 않은 구문을 표시해줘.”

### 10.10 확인 방법과 흔한 실패

과거 0.1.0은 시행착오 참고용이다. 실습 대상 소스는 현재 DIAG 0.4.5로 하고 SAP 적용에는 개발 환경 문법 확인이 선행한다. 코드 파일 존재를 운영 검증 완료로 쓰지 않는다.

### 10.11 관련 캡처·코드·문서

- `HISTORY-IMPORT`: [DEVHUB_IMPORT_0_1_0.zip](assets/history/DEVHUB_IMPORT_0_1_0.zip) — 초기 Import 0.1.0 원본 ZIP. 명칭은 Import지만 제공 코드는 읽기 전용 검증이며 저장·자동 활성화 기능 구현을 뜻하지 않음.
- `CODE-DIAG`: [Z_PACKAGE_DIAG_0_4_5.abap](assets/code/Z_PACKAGE_DIAG_0_4_5.abap) — 접근 가능한 최신 DIAG 소스. 9128줄 D/T→CSEQUENCE 호환 수정 후 파일. SAP에서 이 버전 실행·활성화 성공은 미확인.

## 11. ABC 모드에서 원본 중심 세 비교로 정리하다 (E11)

### 11.1 학습 목표

대비 방향과 값 존재 여부를 명확히 하여 상태를 해석한다.

### 11.2 이전 상황과 준비물

ABC 구분, SAP_UNVERIFIED 1,308건, XML DIFFERENT와 byte 표시가 사용자에게 혼란을 줬다.

### 11.3 관련 실제 발화 ID

U060, U061, U062 — [전체 발화](assets/conversation/visible_messages.md)에서 같은 ID로 탐색한다.

### 11.4 사용자가 요구한 핵심

baseline을 원본으로 두고 추출본/원본, SAP/원본, 추출본/SAP를 각각 비교하며 변경 줄·XML 필드·바이너리 차이를 구체적으로 보여 달라고 요청했다.

### 11.5 AI 대응과 결과물의 확인 수준

현재 DIAG의 byte 비교와 세 대비 필드, 기존 인계서 §6이 근거다. 사용자의 “용량만 비교했나?” 질문은 사실 판정으로 채택하지 않는다.

### 11.6 오류·오해·누락 또는 판단

같은 길이의 서로 다른 내용도 수정이다. PNG는 byte 차이·크기·기타 진단을 보여줄 수 있지만 ABAP처럼 변경 문장 줄을 설명하는 대상은 아니다. SAP 읽기 미확인은 파일 부재와 같지 않다.

### 11.7 추가 설명과 수정이 필요했던 이유

원본 대비 변경 여부와 현재 두 값의 일치 여부는 서로 다른 질문이다. 양쪽이 독립적으로 수정되었어도 서로 같을 수 있고, 비교 불가를 변경없음으로 채우면 위험하다.

### 11.8 다음 단계로 넘어간 근거

이후 U080에서 상태를 신규·누락·수정·변경없음으로 통일했다. 현재 구현에서는 판단할 수 없는 비교는 공란/설명으로 남기는 계약을 함께 확인해야 한다.

### 11.9 따라 하기 실습 — 교육용 재작성 프롬프트

첨부 합성 실습을 `python3 assets/examples/compare_cases.py`로 실행한다. 프롬프트: “기준→대상의 방향으로 네 상태를 판정해줘. SAP 읽기 실패는 known absent로 바꾸지 말고 비교 불가로 분리해줘.” 같은 길이의 서로 다른 텍스트도 한 사례로 추가 검토한다.

### 11.10 확인 방법과 흔한 실패

세 결과를 방향별로 손으로 설명할 수 있어야 한다. 누락은 비교 대상에서 없다는 관찰이며 SAP 삭제 명령이 아니다. 이 실습의 통과는 Python 합성 사례 검증이다.

### 11.11 관련 캡처·코드·문서

- `DOC-CONTEXT`: [PROJECT_CONTEXT.md](assets/references/PROJECT_CONTEXT_20261008_v3.md) — 기존 인계·요약 문서. 원문 대화가 아니며 최신성은 파일 내부 기준.
- `EX-COMPARE`: [compare_cases.py](assets/examples/compare_cases.py) — 기존 교육 자료. compare_cases/three_way_cases는 합성 실습이며 SAP 테스트가 아님.
- `EX-CASES`: [three_way_cases.json](assets/examples/three_way_cases.json) — 기존 교육 자료. compare_cases/three_way_cases는 합성 실습이며 SAP 테스트가 아님.
- `RESULT-FACTS`: [ZHR5_result_facts_derived.json](assets/examples/ZHR5_result_facts_derived.json) — 기존 result.xlsx RawData 분석 파생 JSON. 이번에 원자료 발췌와 핵심 수치를 재대조.
- `HISTORY-IMPORT`: [DEVHUB_IMPORT_0_1_0.zip](assets/history/DEVHUB_IMPORT_0_1_0.zip) — 초기 Import 0.1.0 원본 ZIP. 명칭은 Import지만 제공 코드는 읽기 전용 검증이며 저장·자동 활성화 기능 구현을 뜻하지 않음.

## 12. ZIP·버전·화면 이동의 실제 장애를 나누다 (E12)

### 12.1 학습 목표

서로 다른 실패를 한 오류로 뭉뚱그리지 않고 증거별로 수정 요청한다.

### 12.2 이전 상황과 준비물

줄 비교와 상세 화면을 추가한 뒤 ZIP 업로드와 ALV 화면에 연쇄 문제가 나타났다.

### 12.3 관련 실제 발화 ID

U063, U064, U065, U066, U067, U068 — [전체 발화](assets/conversation/visible_messages.md)에서 같은 ID로 탐색한다.

### 12.4 사용자가 요구한 핵심

업로드 중단, ALV 미표시, 추가 오류, 상세 F3가 첫 화면으로 돌아가는 문제를 보고하고 SAP 표준 version compare 수준의 가독성을 요청했다.

### 12.5 AI 대응과 결과물의 확인 수준

Import 0.3.0/0.3.1/0.3.2 오류 화면은 실제 확보했다. 당시 각 AI 수정 응답은 없다. 현재 DIAG 소스는 Git 관리 파일 제외 및 화면 복귀 관련 로직을 가진 후속 산출물이다.

### 12.6 오류·오해·누락 또는 판단

U063은 ZIP 제한 안내, U064는 .git/objects/pack 파일 23,453,562 bytes가 16 MiB 제한을 넘은 오류, U066은 manifest가 Export 0.3.28만 허용한다는 별도 오류다. UI F3 문제는 파일 검사 실패와 다르다.

### 12.7 추가 설명과 수정이 필요했던 이유

저장소 전체 ZIP과 SAP 추출 데이터 ZIP을 구분할 필요가 있었다. 표준 SAP 비교 화면은 디자인 참고이지 우리가 만든 DIAG의 성공 화면이 아니다.

### 12.8 다음 단계로 넘어간 근거

U067의 “일단 alv 결과까지는 나왔어”는 이전 화면 장애 일부 해결의 사용자 확인이다. 이어 F3 문제가 남았다고 했으므로 전체 해결 보고로 쓰지 않는다.

### 12.9 따라 하기 실습 — 교육용 재작성 프롬프트

프롬프트: “ZIP 내부 목록에서 .git/objects, 원본 manifest, baseline, packages를 구분해줘. 제한 오류와 manifest 호환 오류를 각각 보고해줘.” 파일 검사 후 목록→상세→F3→같은 목록 복귀를 테스트 케이스로 작성한다.

### 12.10 확인 방법과 흔한 실패

실제 데이터 ZIP 없이 실행 성공을 꾸미지 않는다. 헤더의 self-test PASS 아래 STOP이 있으면 전체 실행은 중단된 것이다. 과거 특정 버전 제한을 무조건 모든 파일 허용으로 바꾸는 방식은 사용하지 않는다.

### 12.11 관련 캡처·코드·문서

- `CODE-DIAG`: [Z_PACKAGE_DIAG_0_4_5.abap](assets/code/Z_PACKAGE_DIAG_0_4_5.abap) — 접근 가능한 최신 DIAG 소스. 9128줄 D/T→CSEQUENCE 호환 수정 후 파일. SAP에서 이 버전 실행·활성화 성공은 미확인.
- `IMG-U063-1`: [image.png](assets/images/U063_1.png) — Import 0.3.0 ZIP 제한 중단
- `IMG-U064-1`: [image(1).png](assets/images/U064_1.png) — Import 0.3.1 .git/objects 파일 16 MiB 제한 초과
- `IMG-U065-1`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.
- `IMG-U066-1`: [image(3).png](assets/images/U066_1.png) — Import 0.3.2 manifest 버전 제한 중단
- `IMG-U068-1`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.

## 13. 조회·활성 버전·문법 검사를 별도 사실로 표시하다 (E13)

### 13.1 학습 목표

모호한 영문 상태를 증거가 분리된 한글 리포트로 바꾼다.

### 13.2 이전 상황과 준비물

ACTIVE_CONFIRMED, DIAGNOSTIC_ONLY, METADATA_SNAPSHOT, MIME_REPOSITORY, VERSION_UNCONFIRMED 설명이 사용자의 질문에 충분히 답하지 못했다.

### 13.3 관련 실제 발화 ID

U069, U070, U071, U072, U073 — [전체 발화](assets/conversation/visible_messages.md)에서 같은 ID로 탐색한다.

### 13.4 사용자가 요구한 핵심

상태가 조회 미시도인지 실패인지 불가능인지 의미 없는지 구분하고, 조회 결과와 활성 버전 확인 결과를 분리하라고 요구했다. 자동 활성화와 활성화 가능성 표현 제거도 명시했다.

### 13.5 AI 대응과 결과물의 확인 수준

당시 AI의 상세 설명 원문은 미확보. 현재 DIAG 필드와 기존 인계서 §7에서 읽기 결과·활성 근거·문법 검사를 나눠 구현한 흔적을 확인한다.

### 13.6 오류·오해·누락 또는 판단

U070의 “VERSION_UNCONFIRMED=활성화 안 된 것 같음”은 사용자 확인 질문이다. 교육 해설은 이를 비활성 확정으로 정정하지 않고, 확인 근거 미확보라는 별도 상태로 설명한다. MIME 조회 성공은 ABAP 활성 버전 판정과 다르다.

### 13.7 추가 설명과 수정이 필요했던 이유

“근거 부족”이라는 추상어만으로는 사용자가 다음 조치를 결정할 수 없다. API 이름, 요청한 STATE, 반환값, 실패 단계, 검사 미수행 이유를 함께 보여줘야 했다.

### 13.8 다음 단계로 넘어간 근거

U072에서 조회 결과/활성 확인 분리와 한글화가 명시 결정됐다. 이후 U081에서 프로젝트 명칭까지 DIAG로 변경된다.

### 13.9 따라 하기 실습 — 교육용 재작성 프롬프트

프롬프트: “각 결과를 읽기 시도 여부, 읽기 성공 여부, 활성 버전 근거, 문법검사 실행 여부로 나눠 설명해줘. 실패를 비활성으로 추론하지 말고 확인한 API·반환값을 적어줘.” 실제 RawData 한 행을 세 축으로 읽는다.

### 13.10 확인 방법과 흔한 실패

세 비교가 변경없음인데 활성 확인 실패인 행도 설명할 수 있어야 한다. UI 라벨만 바꾸고 내부 상태의 의미를 합치면 실패다. 사용자 질문에 포함된 가설을 정답 표에 복사하지 않는다.

### 13.11 관련 캡처·코드·문서

- `CODE-DIAG`: [Z_PACKAGE_DIAG_0_4_5.abap](assets/code/Z_PACKAGE_DIAG_0_4_5.abap) — 접근 가능한 최신 DIAG 소스. 9128줄 D/T→CSEQUENCE 호환 수정 후 파일. SAP에서 이 버전 실행·활성화 성공은 미확인.
- `DOC-CONTEXT`: [PROJECT_CONTEXT.md](assets/references/PROJECT_CONTEXT_20261008_v3.md) — 기존 인계·요약 문서. 원문 대화가 아니며 최신성은 파일 내부 기준.
- `RESULT-RAWDATA`: [result.xlsx](assets/results/ZHR5_RawData.extracted.json) — result.xlsx의 실제 RawData 2,541개 데이터 행과 머리글 전체. 교육용 파생 자료이며 원본 XLSX 자체는 아님.
- `IMG-U069-1`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.
- `IMG-U069-2`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.

## 14. XML의 가짜 대량 변경을 필드 단위로 좁히다 (E14)

### 14.1 학습 목표

직렬화 차이와 의미 있는 필드 변경을 구분한다.

### 14.2 이전 상황과 준비물

attributes/Import/Export 등 XML 비교 미구현이 많았고, 구현 후에는 내용이 비슷한데 많은 변경 표시가 나타났다.

### 14.3 관련 실제 발화 ID

U074, U075 — [전체 발화](assets/conversation/visible_messages.md)에서 같은 ID로 탐색한다.

### 14.4 사용자가 요구한 핵심

XML 조회·비교 구현과 하단 진행 상태를 요청한 뒤 함수 Attributes.xml의 상위 변경이 하위 전체로 퍼진 것인지 지적했다.

### 14.5 AI 대응과 결과물의 확인 수준

현재 DIAG 소스 주석과 XML 노드 추출 루틴에서 SAP iXML element GET_VALUE의 하위 텍스트 합산을 피하는 처리 근거가 있다. 당시 화면 캡처가 모든 원인을 증명하는 것은 아니다.

### 14.6 오류·오해·누락 또는 판단

부모 element 값을 모든 하위 text의 합으로 비교하면 자식 하나의 변경이 조상 여러 곳의 변경으로 부풀려질 수 있다. XML 문자열 전체 동일성과 요소·속성의 의미 비교는 분리해야 한다.

### 14.7 추가 설명과 수정이 필요했던 이유

사용자는 “많이 달랐다”는 수치보다 실제 어떤 값이 바뀌었는지를 알아야 했다. 공통 프로그램 속성과 함수 자체 속성이 뒤섞이는 문제도 뒤에서 추가로 드러난다.

### 14.8 다음 단계로 넘어간 근거

현재 코드에 직접값 비교 처리가 존재한다. 최신 SAP에서 해당 함수 XML false positive가 모두 사라졌다는 실행 증거는 미확인이다.

### 14.9 따라 하기 실습 — 교육용 재작성 프롬프트

프롬프트: “부모 경로에 자식 텍스트가 중복 집계되는지 확인해줘. 직접 텍스트·속성·자식 경로를 분리하고, 하나의 leaf만 바꾼 합성 XML에서 해당 의미 값만 변경으로 표시해줘. 공백을 임의로 없애지 말아줘.”

### 14.10 확인 방법과 흔한 실패

동일 내용의 들여쓰기 차이, leaf 변경, 속성 변경, 추가/누락을 각각 검토한다. 실제 함수 Attributes와 공통 TRDIR 값 변경은 원본 세 자료가 있어야 최종 원인을 확정할 수 있다.

### 14.11 관련 캡처·코드·문서

- `CODE-DIAG`: [Z_PACKAGE_DIAG_0_4_5.abap](assets/code/Z_PACKAGE_DIAG_0_4_5.abap) — 접근 가능한 최신 DIAG 소스. 9128줄 D/T→CSEQUENCE 호환 수정 후 파일. SAP에서 이 버전 실행·활성화 성공은 미확인.
- `DOC-CONTEXT`: [PROJECT_CONTEXT.md](assets/references/PROJECT_CONTEXT_20261008_v3.md) — 기존 인계·요약 문서. 원문 대화가 아니며 최신성은 파일 내부 기준.
- `IMG-U075-1`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.

## 15. 리포트 화면 자체를 업무 판단 도구로 다듬다 (E15)

### 15.1 학습 목표

필드 순서·고정 열·집계 모수를 요구사항으로 명시한다.

### 15.2 이전 상황과 준비물

넓고 복잡한 ALV, 지나치게 큰 헤더, 중복 XML 필드와 불분명한 상태가 읽기를 방해했다.

### 15.3 관련 실제 발화 ID

U076, U077, U078, U079, U080 — [전체 발화](assets/conversation/visible_messages.md)에서 같은 ID로 탐색한다.

### 15.4 사용자가 요구한 핵심

파일명에 상위 경로 포함, 불필요 필드 삭제, 폭 조절, 고정 열, native ALV 헤더 A/B 분리, 합계, 네 비교 상태, 상세 세 번째 대비 추가를 요청했다.

### 15.5 AI 대응과 결과물의 확인 수준

당시 응답은 미확보. 현재 DIAG 소스와 인계서 §8에서 레이아웃·집계·상세 구조가 확인된다. 원래 캡처의 일부에는 개인 계정이 있어 ZIP에서 제외했다.

### 15.6 오류·오해·누락 또는 판단

표처럼 보이는 HTML 헤더와 사용자가 원한 ALV 헤더는 달랐다. WIDTH 인자 오류 등 UI 코드도 구형 ABAP의 타입 제약을 받았다. 상태 종류가 늘면 한 줄로 집계한 의미가 불분명해졌다.

### 15.7 추가 설명과 수정이 필요했던 이유

사용자는 단순 미관이 아니라 조회 결과를 빠르게 판단하고 상세 기준을 일관되게 유지하려고 했다. 신규/누락/수정/변경없음은 방향마다 기준이 다르다.

### 15.8 다음 단계로 넘어간 근거

U079는 두 화면 헤더가 표로 바뀌었음을 인정하면서도 native ALV를 다시 요구했다. U080은 A=세 비교, B=활성·문법 검증이라는 최종 분리 방향을 제시했다. 현재 화면의 실사용 가독성은 재확인 필요다.

### 15.9 따라 하기 실습 — 교육용 재작성 프롬프트

프롬프트: “메인은 예외·유형·구성요소·파일명을 왼쪽 고정하고 상세는 순서와 세 대비를 고정해줘. 헤더 A의 각 행 합계를 표시하되 B와 집계 대상이 같다고 가정하지 말아줘.” 요구사항-화면-코드 대응표를 만든다.

### 15.10 확인 방법과 흔한 실패

32인치 화면 확대·가로 스크롤·긴 경로·F3 복귀를 개발 SAP GUI에서 확인한다. 고정 필드 수와 기본 width, 사용자 저장 레이아웃의 영향을 함께 기록한다.

### 15.11 관련 캡처·코드·문서

- `CODE-DIAG`: [Z_PACKAGE_DIAG_0_4_5.abap](assets/code/Z_PACKAGE_DIAG_0_4_5.abap) — 접근 가능한 최신 DIAG 소스. 9128줄 D/T→CSEQUENCE 호환 수정 후 파일. SAP에서 이 버전 실행·활성화 성공은 미확인.
- `DOC-CONTEXT`: [PROJECT_CONTEXT.md](assets/references/PROJECT_CONTEXT_20261008_v3.md) — 기존 인계·요약 문서. 원문 대화가 아니며 최신성은 파일 내부 기준.
- `IMG-U077-1`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.
- `IMG-U078-1`: [image(9).png](assets/images/U078_1.png) — WIDTH 인자 타입 오류
- `IMG-U079-1`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.
- `IMG-U080-1`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.
- `IMG-U080-2`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.
- `IMG-U080-3`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.
- `IMG-U080-4`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.

## 16. 자동 Import를 제외하고 DIAG로 방향을 확정하다 (E16)

### 16.1 학습 목표

목표 축소를 실패가 아니라 책임 경계의 명확화로 이해한다.

### 16.2 이전 상황과 준비물

자동 활성화까지 계획했으나 검증 수준과 위험 부담이 충분히 해소되지 않았다.

### 16.3 관련 실제 발화 ID

U081, U082, U083, U084, U085 — [전체 발화](assets/conversation/visible_messages.md)에서 같은 ID로 탐색한다.

### 16.4 사용자가 요구한 핵심

Import를 프로젝트에서 제외하고 DIAG로 변경. 단일 패키지 입력, 전체/소스코드/XML/MIME, 소스코드 기본값, ABAP 문법 사전검사 상시 기본 설정, 신규/누락/수정만 조회 체크를 요청했다.

### 16.5 AI 대응과 결과물의 확인 수준

현재 Z_PACKAGE_DIAG_0_4_5.abap에 읽기 전용 방향과 선택 조건이 반영되어 있다. 이름 중복 C_SCOPE 등 후속 호환 오류 화면도 존재한다.

### 16.6 오류·오해·누락 또는 판단

“문법 사전검사 기본 ON”이 모든 파일에서 검사가 반드시 실행됐다는 뜻은 아니다. 내용 일치로 생략, 문서라 해당 없음, 현재 SAP에만 있는 자료 등 실행 조건이 다르다. 소스와 MIME 유형은 단순 확장자만으로 완전히 배타적이지 않다.

### 16.7 추가 설명과 수정이 필요했던 이유

진단 결과를 신뢰할 수 있는 수준으로 설명하는 것이 현재 목표다. 자동 반영·신규 객체 생성·DDIC 활성화·삭제를 계속 숨은 목표로 남기지 않아야 했다.

### 16.8 다음 단계로 넘어간 근거

U081의 명시적 방향 변경이 최우선 결정이다. U085는 사용자가 진단이 어느 정도 완성됐다고 한 평가이지 최신 0.4.5 실행 완료는 아니다. 후속 U089에 문법 오류가 남아 있다.

### 16.9 따라 하기 실습 — 교육용 재작성 프롬프트

프롬프트: “DIAG는 저장·활성화 없이 비교 리포트만 생성해줘. 소스코드 기본 선택과 변경분만 표시를 적용하되 검사 실패 행을 단순 변경없음으로 숨기지 않는지 설명해줘.” 현재 소스의 조건 분기부터 확인한다.

### 16.10 확인 방법과 흔한 실패

결과 필터가 실제 조회 시간 절약인지 표시만 제한하는지 확인한다. 현재 코드의 필터/헤더/JSON 모수를 검토하고 사용자 테스트에서 네 결과 유형을 각각 비교한다. 운영 ERP 변경 단계는 이 교육 범위에 없다.

### 16.11 관련 캡처·코드·문서

- `CODE-DIAG`: [Z_PACKAGE_DIAG_0_4_5.abap](assets/code/Z_PACKAGE_DIAG_0_4_5.abap) — 접근 가능한 최신 DIAG 소스. 9128줄 D/T→CSEQUENCE 호환 수정 후 파일. SAP에서 이 버전 실행·활성화 성공은 미확인.
- `DOC-CONTEXT`: [PROJECT_CONTEXT.md](assets/references/PROJECT_CONTEXT_20261008_v3.md) — 기존 인계·요약 문서. 원문 대화가 아니며 최신성은 파일 내부 기준.
- `IMG-U081-1`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.
- `IMG-U081-2`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.
- `IMG-U082-1`: [image(20261004-080547).png](assets/images/U082_1.png) — C_SCOPE 이름 중복 오류
- `IMG-U083-1`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.
- `IMG-U083-2`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.
- `IMG-U083-3`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.
- `IMG-U084-1`: 배포 파일 없음 — 사용자가 요청에 첨부한 SAP/ALV 화면. 최신 완성 화면으로 단정하지 않음.

## 17. 실제 ZHR5 결과로 검증 의미와 마지막 호환 오류를 좁히다 (E17)

### 17.1 학습 목표

사용자 결과 데이터로 개선 항목을 만들고 최신 수정의 검증 한계를 남긴다.

### 17.2 이전 상황과 준비물

ZHR5 결과 엑셀을 보고 구체적인 문제를 묻고 개선 요청을 확정하는 단계.

### 17.3 관련 실제 발화 ID

U086, U087, U088, U089, U090 — [전체 발화](assets/conversation/visible_messages.md)에서 같은 ID로 탐색한다.

### 17.4 사용자가 요구한 핵심

함수↔Include 연결, 함수/공통 프로그램 속성 차이, 확인 실패 원인, 검사 미수행 이유, JSON 다운로드를 요구한 뒤 9128줄 오류를 다시 보고했다.

### 17.5 AI 대응과 결과물의 확인 수준

result.xlsx 실제 RawData와 DIAG 0.4.5를 확보했다. 기존 인계서 §9와 최신 코드에 함수/Include 근거, 속성 범위 구분, JSON 출력 및 D/T 문자열 변환 수정이 존재한다. 당시 AI 설명 원문은 미확보다.

### 17.6 오류·오해·누락 또는 판단

사용자가 말한 “71건 함수”는 실제 결과에서 FUNCTION_API_SOURCE 70건 + DDIC_STATE_DIAGNOSTIC 1건이다. 3,210 bytes로 셋이 같은 Attributes 행도 SAP 대비 수정이다. “검사 미수행” SAP 신규 10개 파일은 파일 수이며 객체 4개와 다르다.

### 17.7 추가 설명과 수정이 필요했던 이유

확인 실패를 비활성으로 해석하거나 byte 길이를 같음으로 해석하면 조치가 틀린다. 긴 설명이 엑셀에서 잘린 문제는 JSON으로 증거 문자열을 보존할 필요를 만들었다.

### 17.8 다음 단계로 넘어간 근거

현재 소스 0.4.5는 날짜·시간을 문자열로 옮긴 뒤 CSEQUENCE 인자로 전달한다. 원본 엑셀은 실행 버전 미확인이고 최신 0.4.5의 실제 SAP 활성화·ALV·JSON 성공 결과는 없다. 이 미확인을 완료로 바꾸지 않는다.

### 17.9 따라 하기 실습 — 교육용 재작성 프롬프트

RawData JSON의 828·1440·2532–2542행을 읽고 비교 상태·SAP 검증·활성 근거·문법 검사를 각각 설명한다. 프롬프트: “71건을 구성요소별로 다시 집계하고, 공통 함수그룹 변경인지 함수 자체 변경인지 근거 필드를 찾아줘. 원본에 없는 잘린 설명은 복원하지 말아줘.”

### 17.10 확인 방법과 흔한 실패

행 수 2,541, 확인 실패 70+1, 동일 byte 3,210 사례를 재대조한다. 함수 API 소스와 실제 활성 Include 내용의 정규화·추출 경계 차이는 후보 원인이며 해당 SAP와 세 원본 없이 모든 건의 원인 확정은 불가하다.

### 17.11 관련 캡처·코드·문서

- `RESULT-RAWDATA`: [result.xlsx](assets/results/ZHR5_RawData.extracted.json) — result.xlsx의 실제 RawData 2,541개 데이터 행과 머리글 전체. 교육용 파생 자료이며 원본 XLSX 자체는 아님.
- `RESULT-FACTS`: [ZHR5_result_facts_derived.json](assets/examples/ZHR5_result_facts_derived.json) — 기존 result.xlsx RawData 분석 파생 JSON. 이번에 원자료 발췌와 핵심 수치를 재대조.
- `CODE-DIAG`: [Z_PACKAGE_DIAG_0_4_5.abap](assets/code/Z_PACKAGE_DIAG_0_4_5.abap) — 접근 가능한 최신 DIAG 소스. 9128줄 D/T→CSEQUENCE 호환 수정 후 파일. SAP에서 이 버전 실행·활성화 성공은 미확인.
- `DOC-CONTEXT`: [PROJECT_CONTEXT.md](assets/references/PROJECT_CONTEXT_20261008_v3.md) — 기존 인계·요약 문서. 원문 대화가 아니며 최신성은 파일 내부 기준.
- `EX-COMPARE`: [compare_cases.py](assets/examples/compare_cases.py) — 기존 교육 자료. compare_cases/three_way_cases는 합성 실습이며 SAP 테스트가 아님.
- `EX-CASES`: [three_way_cases.json](assets/examples/three_way_cases.json) — 기존 교육 자료. compare_cases/three_way_cases는 합성 실습이며 SAP 테스트가 아님.
- `RESULT-XLSX-ORIGINAL`: 배포 파일 없음 — 실제 확보·읽은 결과 엑셀. RawData 전체를 별도 JSON에 제공.
- `MISSING-EXPORT-ZIP`: 배포 파일 없음 — 현재 SAP/DIAG 결과와 정확히 대응하는 전체 Export ZIP.
- `MISSING-DIAG-JSON`: 배포 파일 없음 — DIAG 0.4.5가 실제 SAP에서 생성한 JSON 결과. 소스의 기능과 실전 실행은 구분.
- `IMG-U089-1`: [{F209934C-DEDF-44D4-A305-6E48CF33D7B3}.png](assets/images/U089_1.png) — 9128줄 CSEQUENCE 관련 호환 오류

## 18. 요약 산출물에서 실제 대화 기반 교육 자료로 확장하다 (E18)

### 18.1 학습 목표

증거 수준을 표시하며 실패·수정 과정을 재사용 가능한 콘텐츠로 만든다.

### 18.2 이전 상황과 준비물

Export·DIAG·업무 지식의 이전 4-MD 요약 ZIP을 전달한 뒤, 이번에 실제 채팅 UI용 발화 JSON과 실습 맥락을 추가로 요구했다.

### 18.3 관련 실제 발화 ID

U091, A001, A002, A003, A004, U092, A005, A006, U093 — [전체 발화](assets/conversation/visible_messages.md)에서 같은 ID로 탐색한다.

### 18.4 사용자가 요구한 핵심

성공 결과만 요약하지 말고 실제 발화·오류·맥락 보완·결정·검증의 순서를 보존하며 원문 미확보를 명시하라고 요청했다.

### 18.5 AI 대응과 결과물의 확인 수준

A001–A004는 현재 확인 가능한 실제 assistant 원문이다. 이전 ZIP도 다시 열어 확인했다. U002–U090의 옛 assistant 메시지를 요약 MD에서 재생성하지 않는다.

### 18.6 오류·오해·누락 또는 판단

요약 문서가 상세해도 원래 AI가 한 말은 아니다. 파일의 업로드 시각·이름 날짜를 대화 시각으로 붙이거나 이후 코드가 존재한다는 이유로 당시 버전을 확인한 것으로 표현하면 출처가 왜곡된다.

### 18.7 추가 설명과 수정이 필요했던 이유

교육생은 최종 정답뿐 아니라 요구가 바뀐 이유와 검증을 남기는 방식을 배워야 한다. 원문·해설·교육용 프롬프트를 UI에서 분리해야 한다.

### 18.8 다음 단계로 넘어간 근거

이번 ZIP은 현재 확보된 일부 대화와 원본/파생 파일의 교육 추출물이다. 웹사이트 구현·서버 설치·GitHub push는 수행 범위가 아니다. 포털/다른 프로젝트 통합은 다음 단계다.

### 18.9 따라 하기 실습 — 교육용 재작성 프롬프트

프롬프트: “이 JSON의 role/content_type/coverage를 이용해 실제 발화와 교육 해설을 분리해줘. 없는 AI 답변은 빈 말풍선을 생성하지 말고 원문 미확보로 표시해줘. asset path가 null이면 다운로드 버튼을 만들지 말아줘.” UI를 실제 구현하지 않고 화면 요구사항만 검토한다.

### 18.10 확인 방법과 흔한 실패

첨부 검증 스크립트로 ID·참조·파일·순서·체크섬을 확인한다. 이 ZIP의 자체 검증 결과를 SAP 검증 결과와 혼동하지 않는다.

### 18.11 관련 캡처·코드·문서

- `PREVIOUS-BUNDLE`: 배포 파일 없음 — 직전 교육 요약 산출물 원본을 다시 확보·열람함. 당시 응답의 산출물 연결.
- `EX-COMPARE`: [compare_cases.py](assets/examples/compare_cases.py) — 기존 교육 자료. compare_cases/three_way_cases는 합성 실습이며 SAP 테스트가 아님.
- `EX-CASES`: [three_way_cases.json](assets/examples/three_way_cases.json) — 기존 교육 자료. compare_cases/three_way_cases는 합성 실습이며 SAP 테스트가 아님.
- `RESULT-FACTS`: [ZHR5_result_facts_derived.json](assets/examples/ZHR5_result_facts_derived.json) — 기존 result.xlsx RawData 분석 파생 JSON. 이번에 원자료 발췌와 핵심 수치를 재대조.
- `RESULT-RAWDATA`: [result.xlsx](assets/results/ZHR5_RawData.extracted.json) — result.xlsx의 실제 RawData 2,541개 데이터 행과 머리글 전체. 교육용 파생 자료이며 원본 XLSX 자체는 아님.
- `CODE-EXPORT`: [Z_PACKAGE_EXPORT.abap](assets/code/Z_PACKAGE_EXPORT_0_3_18.abap) — 접근 가능한 최신 Export 소스. 0.3.18. 현재 SAP 설치본과 같다는 뜻은 아님.
- `CODE-DIAG`: [Z_PACKAGE_DIAG_0_4_5.abap](assets/code/Z_PACKAGE_DIAG_0_4_5.abap) — 접근 가능한 최신 DIAG 소스. 9128줄 D/T→CSEQUENCE 호환 수정 후 파일. SAP에서 이 버전 실행·활성화 성공은 미확인.
- `CODE-CHECK`: [DEVHUB_CHECK_0_3_3.html](assets/tools/DEVHUB_CHECK_0_3_3.html) — 기존 오프라인 Export 결과 검사 도구. 교육 포털을 새로 만든 파일이 아님.
- `DOC-CONTEXT`: [PROJECT_CONTEXT.md](assets/references/PROJECT_CONTEXT_20261008_v3.md) — 기존 인계·요약 문서. 원문 대화가 아니며 최신성은 파일 내부 기준.
- `DOC-BUILD`: [PACKAGE_AGENT_BUILD_GUIDE.md](assets/references/PACKAGE_AGENT_BUILD_GUIDE.md) — 새 패키지에 업무 지식·Export·스킬을 통합하는 기존 가이드. 실행 완료 증거와 구분.
- `DOC-FEEDBACK`: [BUSINESS_FEEDBACK_POLICY.md](assets/references/BUSINESS_FEEDBACK_POLICY.md) — 업무 답변 피드백 처리 지침. 출처 확인·MD 수정·회귀 사례 갱신 범위.
- `DOC-EXPORT-GUIDE`: [DEVHUB_EXPORT_GUIDE.md](assets/references/DEVHUB_EXPORT_GUIDE.md) — Export·오프라인 검사 가이드.
- `DOC-EXPORT-VALIDATION`: [DEVHUB_0_3_18_VALIDATION.md](assets/references/DEVHUB_0_3_18_VALIDATION.md) — 기존 Export 0.3.18 검증 기록. 현 시점 SAP 재실행 결과 아님.
- `DOC-KNOWLEDGE`: [ZHR5_KNOWLEDGE_SETUP.md](assets/references/ZHR5_KNOWLEDGE_SETUP.md) — 기존 ZHR5 업무 지식 설치 안내. 사용자의 현재 Mac 구성 검증은 아님.
- `DOC-GLOSSARY`: [SAP_OBJECT_GLOSSARY.md](assets/references/SAP_OBJECT_GLOSSARY.md) — SAP 객체·폴더를 해석하는 기존 용어집.
- `DOC-KIT-VALIDATION`: [VALIDATION.md](assets/references/ZHR5_KIT_VALIDATION_20260922.md) — 기존 지식 키트 자체 검증 기록. 업무 질문 정답 검증 전체 통과로 해석하지 않음.
- `SKILL-01`: [SKILL.md](assets/references/skills/zhr5-business-qa/SKILL.md) — 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.
- `SKILL-02`: [openai.yaml](assets/references/skills/zhr5-business-qa/agents/openai.yaml) — 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.
- `SKILL-03`: [answer-format.md](assets/references/skills/zhr5-business-qa/references/answer-format.md) — 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.
- `SKILL-04`: [SKILL.md](assets/references/skills/zhr5-change-impact/SKILL.md) — 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.
- `SKILL-05`: [openai.yaml](assets/references/skills/zhr5-change-impact/agents/openai.yaml) — 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.
- `SKILL-06`: [impact-template.md](assets/references/skills/zhr5-change-impact/references/impact-template.md) — 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.
- `SKILL-07`: [SKILL.md](assets/references/skills/zhr5-knowledge-curation/SKILL.md) — 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.
- `SKILL-08`: [openai.yaml](assets/references/skills/zhr5-knowledge-curation/agents/openai.yaml) — 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.
- `SKILL-09`: [document-template.md](assets/references/skills/zhr5-knowledge-curation/references/document-template.md) — 확보한 기존 스킬 참고 사본. 이 ZIP을 푸는 것만으로 Codex에 설치·활성화되지 않음.

## 운영 중 갱신 방법

새 질문이나 오류가 들어오면 원문 발화, 프로그램 버전, 입력 파일 해시, 실행 조건, 담당자 검토, 후속 수정, 재실행 결과를 묶어서 추가한다. 기존 실패 발화는 고치지 않고 후속 해설·발화를 연결한다. 코드 수정과 업무 지식 수정은 목적과 검증 방식이 다르다.

### 자주 혼동한 질문

| 질문 | 이 프로젝트에서의 답변 기준 |
|---|---|
| 파일 길이가 같으면 내용도 같은가? | 아니다. 실제 3,210 bytes XML 사례를 비교한다. |
| 확인 실패면 비활성인가? | 아니다. 어떤 API·근거 확인에 실패했는지 읽는다. |
| SAP에서 읽혔으니 수정 파일도 활성화 가능한가? | 별개다. DIAG는 반영·자동 활성화 보장을 하지 않는다. |
| 모든 XML은 그냥 속성이므로 검증이 의미 없는가? | 정의·인터페이스·속성마다 비교 목적이 다르다. |
| 소스만 있으면 업무 에이전트가 업무 규정을 아는가? | 업무 문서·시행일·담당자 맥락·출처가 추가로 필요하다. |
| 스킬 사본을 ZIP에 넣으면 설치 완료인가? | 아니다. 실제 Codex 환경의 로드·경로·호출을 따로 확인한다. |
| Actions가 AI이며 SAP를 다 검사하는가? | 아니다. 구성한 도구·이벤트·환경 범위만 검사한다. |
| baseline은 중복이므로 지워도 되는가? | 현재 DIAG 기준 자료다. AI 색인 제외와 원본 삭제는 다르다. |
| 최신 코드 파일이 있으면 최신 SAP 실행도 끝났나? | 아니다. 0.4.5 소스와 SAP 실행 증거는 따로 확보해야 한다. |
