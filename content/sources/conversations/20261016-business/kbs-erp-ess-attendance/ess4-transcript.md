# 근태페이지 개선 이어가기

출처: https://chatgpt.com/share/e/6ad08165-a998-83ee-ac0a-aaf87bd93dc4

공유 화면의 표시 순서대로 전사했습니다. 본문이 없는 응답 위치는 별도 표시합니다.

## ess4-t001-u1 · 사용자

근태페이지 개선하는 스레드가 이상해. 계속 로딩중이고 프롬프트도 안통해 너가 이 스레드에 새롭게 만들어줄 수 있어 ?

## ess4-t001-a1 · AI

응. 가능해. 기존 '근태페이지 개선' 스레드는 그대로 두고, 지금 이 대화를 새로운 작업 스레드로 사용하자.

기존 스레드가 계속 로딩되고 프롬프트에도 반응하지 않는다면, 굳이 그 스레드에서 작업을 이어갈 필요는 없어.

다행히 이전에 진행했던 근태페이지 R1 개선 작업의 주요 내용과 진행 상황은 파악하고 있어. 처음부터 다시 설명할 필요는 없어.

## 1. 기존 작업 진행 상황

현재 내가 파악하고 있는 내용은 다음과 같아.

| 작업 내용 | 상태 |
| --- | --- |
| 기존 근태페이지 유지 및 R1 별도 생성 | 완료 |
| `ZCL_HR_GUN_R1` 클래스 생성 | 완료 |
| 달력·첨부파일 R1 페이지 적용 | 완료 |
| 상신 전 근태 변경 기능 | 완료 |
| 1일 → 0.5일 반차 변경 및 저장 오류 수정 | 완료 |
| 반차 변경 후 승인 테스트 | 완료 |
| 승인된 근태의 일수 표시 확인 | 확인 진행 |
| 기승인 근태 변경·취소 실제 서버 처리 연결 | 다음 작업 |

이 상태는 이전 대화에서 확인한 내용을 기준으로 정리한 것이야.

## 2. 여기서 이어서 할 작업

마지막에 우리가 진행하려던 것은 기승인 근태 변경·취소 기능의 실제 처리 연결이었어.

즉, 화면에서 변경·취소 버튼만 동작하게 하는 것이 아니라 SAP 서버의 실제 근태 데이터, 잔여일수, 결재 상태까지 정상적으로 반영하는 작업이야.

기존 `guntae_input.kbs`는 유지하고, 신규 `guntae_input_r1.kbs`를 중심으로 진행한다는 원칙도 그대로 적용할게.

## 3. 새 스레드에서 작업하는 방식

앞으로는 다음 원칙으로 진행할게.

- 이미 완료한 작업은 다시 진행하지 않기
- 기존 페이지는 변경하지 않고 R1에서 작업하기
- 수정할 소스는 파일별로 구분하기
- 기존에 사용하던 수정이력 주석 스타일 유지하기
- SAP 적용 방법은 초보자도 따라 할 수 있도록 단계별로 설명하기
- 작업 완료 시점마다 진행 상황 정리하기

한 가지만 확인할게.

기존 스레드에서 마지막으로 진행하던 '기승인 변경·취소 실제 처리 연결' 작업부터 여기서 바로 이어갈까?

그렇게 하면 기존 작업을 처음부터 다시 시작하지 않고, 마지막 확인 지점부터 진행할게.

## ess4-t002-u1 · 사용자

ㅇㅇ 바로 이어가줘. 그런데 궁금한게 있어. md 파일에 테이블 2개 신규 생성하는게 있잖아. 이렇게 하면 기존 근태 레포트 프로그램도 다 고쳐야하는거 아냐 ?

## ess4-t002-a1 · AI

맞아. 그 부분은 반드시 확인하고 넘어가야 해. 네가 지적한 내용이 이번 근태페이지 R1 개선에서 상당히 중요한 문제야.

결론부터 말하면, 신규 테이블 2개를 생성한다고 해서 기존 근태 레포트 프로그램을 전부 수정해야 하는 것은 아니야. 하지만 신규 테이블을 어떤 용도로 사용하느냐에 따라 기존 프로그램까지 수정해야 할 가능성은 있어.

나는 가능하면 기존 근태 레포트 프로그램은 수정하지 않는 방향으로 설계하는 게 맞다고 생각해.

## 1. 신규 테이블을 만들면 기존 프로그램에 어떤 영향이 있을까?

현재 확인된 근태 처리 구조에는 다음 테이블들이 있어.

| 테이블 | 주요 역할 |
| --- | --- |
| `ZTHR0080` | 근태 신청 및 결재 관련 데이터 |
| `PA2001` | 실제 승인된 근태 기록 |
| `ZHR2016` | 연차 사용량 및 잔여일수 관리 |
| 신규 테이블 | 부분 변경·취소 요청과 원본 신청의 연결 정보 등 |

기존 소스 검토에서도 실제 근태 반영은 `PA2001`, 연차 사용량 반영은 `ZHR2016`을 통해 이루어지는 것으로 확인했어.

R1_annual_leave_change_review_20261002.txt

### 방식 A. 신규 테이블을 실제 근태 데이터로 사용하는 경우

기존 근태 테이블 + 신규 근태 테이블

기존 근태 조회·집계 프로그램

신규 테이블을 추가 조회하도록 수정 필요

이 방식은 기존 프로그램이 신규 데이터를 조회하지 못할 수 있어서 영향 범위가 커져.

### 방식 B. 신규 테이블은 변경 이력과 연결 정보만 관리하는 경우

R1 기승인 변경·취소 요청

신규 테이블

원본 신청 연결 · 변경 대상 날짜 · 처리 상태

기존 PA2001 · ZHR2016 · ZTHR0080

승인 후 실제 데이터 반영

기존 근태 레포트

기존 데이터 기준으로 계속 조회 가능

나는 B 방식을 추천해. 다만 기존 레포트가 변경 이력이나 원본 신청 상태까지 표시한다면 해당 프로그램은 별도 보완이 필요할 수 있어.

## 2. 기존 MD 문서를 확인해 보니

기존 작업 정리 문서에는 `ZTHR0080V2` 신규 테이블 설계가 명시되어 있어. 다만 내가 지금 확인한 MD에서는 신규 테이블 1개만 명확하게 확인돼. 네가 말한 나머지 1개는 최근 적용 안내 MD를 확인해야 정확히 판단할 수 있어.

guntae_progress_summary_XA32762.md

그리고 중요한 점이 하나 더 있어.

기존 R1 명세에는 신규 DDIC 테이블을 만들지 않고 기존 테이블을 사용하는 버전도 존재해. 따라서 과거 설계와 최신 적용안이 서로 다른 상태야.

guntae_r1_change_spec_XA32762.xlsx

## 3. 앞으로 진행할 방향

우선 신규 테이블을 생성하거나 기존 승인 로직을 수정하기 전에 아래 기준으로 설계를 확정하자.

1. 기존 근태 레포트가 조회하는 데이터 구조를 최대한 유지한다.
2. 신규 테이블은 원본 신청 연결과 변경·취소 이력 관리에 한정한다.
3. 승인 시 실제 근태는 `PA2001`, 연차 사용량은 `ZHR2016`에 정상 반영한다.
4. 기존 신청·결재 이력과 신규 변경 요청 사이의 연결을 검증한다.
5. 중간 오류가 발생하더라도 기존 승인 근태가 잘못 삭제되거나 연차가 이중 차감되지 않도록 처리한다.

특히 기존 검토에서 중간 COMMIT으로 인해 근태·연차·결재 상태가 서로 달라질 위험이 확인됐기 때문에 이 부분을 먼저 해결해야 해.

R1_annual_leave_change_review_20261002.txt

다음으로 네가 말한 신규 테이블 2개가 적힌 최신 MD 파일을 이 대화에 첨부해 줘.

그 파일을 기준으로 테이블별 역할을 분석하고, 기존 근태 레포트 수정이 필요한지부터 판단한 다음 기존 프로그램 영향 최소화 방식으로 기승인 변경·취소 실제 처리 연결 작업을 이어갈게.

## ess4-t003-u1 · 사용자

이거잖아

## ess4-t003-a1 · AI

맞아. 바로 이 파일 `README_TABLES_EASY.md`야. 이제 정확히 확인했어.

내가 앞에서 신규 테이블이 1개라고 설명한 건 이전 설계 문서를 기준으로 한 것이었어. 이번에 첨부한 파일에는 분명히 2개의 신규 테이블이 정의되어 있어.

## 1. 신규 테이블 2개의 역할

| 테이블 | 용도 | 기존 근태 레포트 영향 |
| --- | --- | --- |
| `ZTGUNR1H` | 기승인 변경·취소 처리 이력, 원본 신청 연결, 결재 상태 및 오류 기록 | 일반적인 근태 조회에는 직접 영향 없음 |
| `ZTGUNR1S` | 변경 전 원본 데이터의 스냅샷 보관, 오류 발생 시 복구 지원 | 일반적인 근태 조회에는 직접 영향 없음 |

두 테이블 모두 실제 근태 데이터를 대체하는 테이블이 아니야.

첨부된 MD에도 기존 표준 테이블이나 `ZTHR0080` 구조는 변경하지 않는다고 명시되어 있어.

## 2. 그럼 기존 근태 레포트를 수정해야 할까?

현재 설계 의도대로 구현한다면 기존 근태 레포트를 전부 수정할 필요는 없어.

예를 들어 기존에 10월 19일~23일 연차 5일이 승인되었다고 가정해 보자.

그중 10월 21일 하루만 취소하면 다음과 같이 처리하는 거야.

| 데이터 | 처리 결과 |
| --- | --- |
| `ZTGUNR1H` | 10월 21일 부분취소 처리 이력 저장 |
| `ZTGUNR1S` | 변경 전 원본 데이터 보관 |
| `PA2001` | 10월 21일을 제외한 승인 근태 유지 |
| `ZHR2016` | 사용 연차 5일 → 4일로 조정 |
| 기존 근태 레포트 | 변경된 실제 근태 데이터를 조회 |

단, 마지막 단계가 성립하려면 기존 레포트가 `PA2001` 등 실제 반영 데이터를 기준으로 조회해야 해.

만약 기존 레포트가 `ZTHR0080`의 원본 신청기간을 그대로 표시한다면, 10월 21일이 취소되었어도 여전히 5일로 나올 수 있어. 그 경우에는 해당 조회 로직을 수정해야 해.

## 3. 내가 이번에 중요하게 보는 부분

신규 테이블 생성 자체보다 기존 승인 데이터와의 정합성이 더 중요해.

특히 다음 세 가지를 확인해야 해.

1. 기존 근태 조회: 부분취소 후 실제 근태 일수가 정확하게 나오는가?
2. 기존 신청 이력: 원본 승인기간과 부분취소 결과가 모순되지 않는가?
3. 결재 및 연차: 변경 승인 시 `PA2001`, `ZHR2016`, 결재 상태가 모두 일치하는가?

그리고 `ZTGUNR1S`에 원본을 저장한다고 해서 오류 발생 시 자동으로 복구되는 것은 아니야. 실제 복구 로직까지 연결해야 해.

## 4. 다음 작업 방향

나는 두 테이블의 신규 생성은 유지하되, 기존 근태 레포트 수정 범위를 최소화하는 방식으로 진행하는 게 좋겠어.

우선 `ZTGUNR1H`, `ZTGUNR1S`는 변경 이력 및 복구 용도로만 사용하고, 실제 승인 근태와 연차 데이터는 기존 테이블에 반영하도록 하자.

다만 여기서 한 가지 확인하고 싶어.

이 두 테이블은 이미 SE11에서 생성하고 활성화까지 완료한 상태야? 아니면 아직 생성 전이야?

이것만 알려주면 완료된 작업은 건너뛰고, 실제 기승인 변경·취소 처리 연결부터 이어서 진행할게.

## ess4-t004-u1 · 사용자

아직 생성 전이야

## ess4-t004-a1 · AI

좋아. 그럼 신규 테이블 2개는 아직 생성하지 않은 상태를 기준으로 이어서 진행하자.

다만 바로 SE11에서 생성하기 전에 한 가지 설계 원칙을 확정할게.

기존 근태 레포트에 영향을 최소화하고, 신규 테이블은 기승인 변경·취소의 이력 관리와 복구 용도로만 사용한다.

## 1. 앞으로 진행할 순서

| 단계 | 작업 | 상태 |
| --- | --- | --- |
| 1 | 신규 테이블 2개 설계 확인 | 완료 |
| 2 | `ZTGUNR1H` 생성 및 활성화 | 대기 |
| 3 | `ZTGUNR1S` 생성 및 활성화 | 대기 |
| 4 | R1 서버 소스와 신규 테이블 연결 | 대기 |
| 5 | 기승인 일부 날짜 변경·취소 승인 처리 | 대기 |
| 6 | 기존 근태 레포트 및 잔여일수 영향 검증 | 대기 |
| 7 | 오류·반려·재승인 및 복구 테스트 | 대기 |

## 2. 먼저 ZTGUNR1H부터 생성하자

SAP에서 다음 순서로 진행해 줘.

1. `SE11` 실행
2. 데이터베이스 테이블 선택
3. 테이블 이름 `ZTGUNR1H` 입력
4. 생성 클릭
5. 내역에 `R1 기승인 변경 취소 처리 이력` 입력
6. 납품 클래스 `A` 선택

그다음 필드 탭에서 아래 내용을 등록하면 돼.

| 필드 | 키 | 유형 | 길이 |
| --- | --- | --- | --- |
| MANDT | ✓ | CLNT | 3 |
| RID | ✓ | CHAR | 22 |
| PERNR |  | NUMC | 8 |
| OBEGDA |  | DATS | 8 |
| OENDDA |  | DATS | 8 |
| OSEQNR |  | NUMC | 3 |
| ORIG_SER |  | NUMC | 12 |
| RBEGDA |  | DATS | 8 |
| RENDDA |  | DATS | 8 |
| RSEQNR |  | NUMC | 3 |
| ZSERIAL |  | NUMC | 12 |
| PHASE |  | CHAR | 10 |
| APPROVER |  | NUMC | 8 |
| PERSK |  | CHAR | 2 |
| DECISION |  | CHAR | 1 |
| ACTOR |  | CHAR | 12 |
| WI_ID |  | NUMC | 12 |
| REASON |  | CHAR | 255 |
| LAST_ERROR |  | CHAR | 255 |
| ERDAT |  | DATS | 8 |
| ERZET |  | TIMS | 6 |
| ERNAM |  | CHAR | 12 |
| AEDAT |  | DATS | 8 |
| AEZET |  | TIMS | 6 |

이 내용은 첨부한 `README_TABLES_EASY.md`의 정의를 그대로 따른 거야.

### 기술 설정

필드 입력이 끝나면 다음과 같이 설정해.

| 설정 항목 | 값 |
| --- | --- |
| 데이터 클래스 | APPL1 |
| 크기 범주 | 0 |
| 버퍼링 | 허용 안 함 |
| 테이블 내용 유지보수 | 허용 안 함 |

저장한 다음 활성화하면 돼.

## 3. 두 번째 테이블은 그다음에 진행

`ZTGUNR1S`는 일반적인 필드 테이블이 아니라 `EXPORT ... TO DATABASE` 방식으로 스냅샷을 보관하는 INDX 형식 테이블이야.

따라서 첫 번째 테이블을 정상적으로 생성한 다음 별도로 안내할게.

우선 `ZTGUNR1H`만 생성하고 활성화해 줘.

활성화가 완료되면 **"1번 테이블 완료"**라고 알려줘. 그러면 `ZTGUNR1S` 생성부터 실제 ABAP 처리 연결까지 순서대로 이어가자.

아직 기존 근태 레포트나 운영 데이터는 수정하지 않을 거야.

## ess4-t005-u1 · 사용자

1번 테이블 완료

## ess4-t005-a1 · AI

좋아! 그럼 1번 테이블 `ZTGUNR1H` 생성 및 활성화 완료로 진행 상황을 갱신할게.

이제 **2번 테이블 `ZTGUNR1S`**를 생성하자.

## 1. ZTGUNR1S 생성

이 테이블은 기승인 근태를 변경·취소하기 전의 원본 데이터를 보관하는 용도야. 나중에 처리 중 오류가 발생했을 때 원본 상태를 확인하거나 복구하는 데 사용하게 돼.

### ① SE11에서 테이블 생성

1. 트랜잭션 `SE11` 실행
2. 데이터베이스 테이블 선택
3. `ZTGUNR1S` 입력
4. 생성 클릭
5. 내역: `R1 기승인 변경 취소 원본 계획 스냅샷`
6. 납품 클래스: `A`

### ② 필드 등록

첨부한 `README_TABLES_EASY.md`에 정의된 순서 그대로 입력해 줘.

| 필드명 | 키 | 기본 유형 | 길이 |
| --- | --- | --- | --- |
| MANDT | ✓ | CLNT | 3 |
| RELID | ✓ | CHAR | 2 |
| SRTFD | ✓ | CHAR | 40 |
| SRTF2 | ✓ | INT4 | 10 |
| CLUSTR |  | INT2 | 5 |
| CLUSTD |  | LRAW | 32000 |

INT2와 INT4의 화면 길이는 SAP 시스템이 자동 지정하는 값을 사용하면 돼.

여기서 주의할 부분이 있어.

- `MANDT`, `RELID`, `SRTFD`, `SRTF2` 네 개만 키로 설정
- `CLUSTR` 바로 다음에 `CLUSTD` 배치
- `CLUSTD`에서 길이 참조 필드를 요구하면 `CLUSTR` 지정
- 표준 `INDX` 테이블의 실제 데이터는 복사하지 않기

### ③ 기술 설정

상단의 **기술 설정(Technical Settings)**으로 이동해서 아래와 같이 설정해.

| 항목 | 설정값 |
| --- | --- |
| 데이터 클래스 | `APPL1` |
| 크기 범주 | `0` |
| 버퍼링 | 허용 안 함 |
| 테이블 내용 유지보수 | 허용 안 함 |

그다음 저장하고 활성화하면 돼.

## 2. 현재 진행 상황

ZTGUNR1H 생성 및 활성화

ZTGUNR1S 생성 및 활성화

R1 서버 소스 연결

기승인 변경·취소 승인 처리

기존 근태 레포트 영향 및 정합성 검증

## 3. 다음 작업 예고

두 번째 테이블까지 완료하면 실제 ABAP 소스 연결 단계로 넘어갈 거야.

이때 기존 근태 레포트를 무조건 수정하는 게 아니라, `ZTGUNR1H`와 `ZTGUNR1S`를 변경 이력·스냅샷 저장용으로 사용하고 기존 `PA2001`, `ZHR2016`, `ZTHR0080`과의 정합성을 맞추는 방향으로 진행할게.

우선 `ZTGUNR1S` 생성 및 활성화까지 진행해 줘.

완료되면 **"2번 테이블 완료"**라고 알려줘. 오류가 나오면 오류 화면을 캡처해서 보내주면 돼.

## ess4-t006-u1 · 사용자

이 테이블 생성하기 전에
ZTGUNR1H...필드 내역(텍스트값) 알려줄 수 있어 ?

## ess4-t006-a1 · AI

응. `ZTGUNR1H` 테이블의 **필드 내역(Short Description)**에 입력할 한글 텍스트를 정리해 줄게.

기존 MD에는 필드명·유형·길이만 정의되어 있어서, 아래 한글 내역은 각 필드의 용도를 기준으로 내가 제안하는 설명이야.

## ZTGUNR1H 필드 내역

| 순번 | 필드명 | 필드 내역(한글) |
| --- | --- | --- |
| 1 | MANDT | 클라이언트 |
| 2 | RID | R1 변경취소 요청 ID |
| 3 | PERNR | 사원번호 |
| 4 | OBEGDA | 원본 근태 시작일 |
| 5 | OENDDA | 원본 근태 종료일 |
| 6 | OSEQNR | 원본 근태 레코드번호 |
| 7 | ORIG_SER | 원본 근태 신청번호 |
| 8 | RBEGDA | 변경 대상 시작일 |
| 9 | RENDDA | 변경 대상 종료일 |
| 10 | RSEQNR | 변경 대상 레코드번호 |
| 11 | ZSERIAL | 변경취소 신청번호 |
| 12 | PHASE | 변경취소 처리 단계 |
| 13 | APPROVER | 결재자 사원번호 |
| 14 | PERSK | 결재자 구분 |
| 15 | DECISION | 결재 결정 구분 |
| 16 | ACTOR | 처리자 ID |
| 17 | WI_ID | 워크플로우 작업 ID |
| 18 | REASON | 변경취소 사유 |
| 19 | LAST_ERROR | 최종 오류 메시지 |
| 20 | ERDAT | 생성일 |
| 21 | ERZET | 생성시간 |
| 22 | ERNAM | 생성자 |
| 23 | AEDAT | 최종 변경일 |
| 24 | AEZET | 최종 변경시간 |

이대로 필드 내역에 입력하면 돼.

참고로 `PERSK`, `RSEQNR`, `ZSERIAL` 등은 실제 ABAP 소스에서 어떤 값이 저장되는지에 따라 더 정확한 명칭으로 조정할 수 있어. 현재는 필드명에 따른 설명이야.

기존 테이블을 다시 생성할 필요는 없어. SE11에서 `ZTGUNR1H`를 변경 모드로 열어 필드 내역만 보완하고 저장·활성화하면 돼.

그다음 `ZTGUNR1S` 생성으로 넘어가자.

## ess4-t007-u1 · 사용자

ZTGUNR1S...필드 내역값도 알려줘

## ess4-t007-a1 · AI

`ZTGUNR1S` 테이블의 **필드 내역(Short Description)**도 정리해 줄게.

이 테이블은 기승인 근태 변경·취소 처리 전에 원본 데이터를 보관하는 스냅샷 테이블이야.

## ZTGUNR1S 필드 내역

| 순번 | 필드명 | 필드 내역(한글) |
| --- | --- | --- |
| 1 | MANDT | 클라이언트 |
| 2 | RELID | 데이터 영역 구분 |
| 3 | SRTFD | 스냅샷 저장 키 |
| 4 | SRTF2 | 데이터 분할 순번 |
| 5 | CLUSTR | 클러스터 데이터 길이 |
| 6 | CLUSTD | 원본 스냅샷 데이터 |

위 한글 내역은 첨부한 `README_TABLES_EASY.md`의 필드 구조를 기준으로 작성한 권장 설명이야.

### SE11 입력 시 주의사항

- 키 필드: `MANDT`, `RELID`, `SRTFD`, `SRTF2`
- 일반 필드: `CLUSTR`, `CLUSTD`
- `CLUSTR` 바로 다음에 `CLUSTD` 배치
- `CLUSTD` 유형은 `LRAW`, 길이는 `32000`
- `CLUSTD`의 길이 참조 필드가 필요하면 `CLUSTR` 지정

특히 `ZTGUNR1S`는 일반적인 이력 테이블이 아니라 ABAP 데이터 클러스터 저장용 테이블이므로 필드명과 순서를 MD 명세대로 유지해야 해.

이대로 등록하고 저장·활성화하면 돼. 완료되면 **"2번 테이블 완료"**라고 알려줘. 그다음 실제 R1 ABAP 소스 연결 작업으로 넘어가자.

## ess4-t008-u1 · 사용자

ABAP 데이터 클러스터 저장용 테이블...이면 따로 설정해줘야하는 사항 있어 ?

## ess4-t008-a1 · AI

응. ABAP 데이터 클러스터 저장용 테이블은 일반 투명 테이블과 달리 몇 가지 주의사항이 있어.

다만 `ZTGUNR1S`는 별도의 특수 테이블 유형으로 생성하는 게 아니라, 일반 투명 테이블로 생성하고 ABAP의 `EXPORT ... TO DATABASE` 명령으로 사용하는 구조야.

## 1. SE11에서 확인할 설정

| 설정 항목 | 설정값 |
| --- | --- |
| 테이블 유형 | 투명 테이블 |
| 납품 클래스 | A |
| 데이터 클래스 | APPL1 |
| 크기 범주 | 0 |
| 버퍼링 | 허용 안 함 |
| 데이터 유지보수 | 허용 안 함 |
| 별도 테이블 유지보수 생성기 | 필요 없음 |

여기까지는 첨부한 MD에 정의된 설정과 동일해.

## 2. 가장 중요한 필드 설정

| 필드 | 유형 | 키 | 주의사항 |
| --- | --- | --- | --- |
| MANDT | CLNT | ✓ | 클라이언트 필드 |
| RELID | CHAR(2) | ✓ | 데이터 영역 구분 |
| SRTFD | CHAR(40) | ✓ | 저장 키 |
| SRTF2 | INT4 | ✓ | 클러스터 분할 번호 |
| CLUSTR | INT2 |  | 데이터 길이 |
| CLUSTD | LRAW(32000) |  | 실제 데이터 저장 |

특히 아래 두 가지를 확인해야 해.

① CLUSTR와 CLUSTD의 순서

`CLUSTR` 바로 다음에 `CLUSTD`를 배치해야 해.

② CLUSTD의 길이 참조

SE11에서 `CLUSTD`의 길이 참조를 요구하면 같은 테이블의 `CLUSTR` 필드를 지정해.

이 부분이 일반적인 테이블과 다른 핵심 사항이야.

## 3. 별도로 설정하지 않아도 되는 것

- SE11에서 '클러스터 테이블' 유형을 선택할 필요 없음
- 표준 `INDX` 테이블의 데이터를 복사할 필요 없음
- SM30 유지보수 화면을 만들 필요 없음
- 별도의 저장 함수 모듈을 반드시 생성할 필요 없음

실제 스냅샷 저장은 나중에 ABAP 프로그램에서 다음과 같은 형태로 처리해.

```
EXPORT ls_snapshot = ls_snapshot
  TO DATABASE ztgunr1s(zz)
  ID lv_snapshot_id.
```

여기서 `zz`는 예시 영역 ID이고, 실제 구현 시 저장과 조회에 동일한 `RELID`를 사용해야 해. `lv_snapshot_id`도 `SRTFD` 길이인 40자 이내의 일관된 키로 관리해야 해.

## 4. 추가로 주의할 점

`ZTGUNR1S`가 정상 활성화되더라도 실제 스냅샷 저장과 복구가 정상 동작한다고 확정할 수는 없어.

추후 ABAP 연결 단계에서 `EXPORT TO DATABASE`와 `IMPORT FROM DATABASE`를 테스트하고, 변경 처리 실패 시 원본 데이터가 정확히 복원되는지 확인해야 해.

또한 스냅샷을 저장하는 것과 자동 복구 기능이 구현되는 것은 별개야.

결론: 첨부한 MD에 적힌 구조와 기술 설정을 정확히 적용했다면 SE11에서 추가로 특별한 설정을 할 필요는 없어.

`ZTGUNR1S`를 생성하고 활성화해 줘. 활성화 오류가 발생하면 화면을 보여줘. 특히 `CLUSTD` 관련 오류가 발생하면 그 부분부터 확인하자.

## ess4-t009-u1 · 사용자

그럼 md에서 'C'를 했으니 이제 'D' 하면 될까 ?

## ess4-t009-a1 · AI

응. C 단계에서 신규 테이블 2개(`ZTGUNR1H`, `ZTGUNR1S`)를 생성하고 활성화까지 완료했다면 D 단계로 넘어가면 돼.

다만 현재 내가 확인한 `README_TABLES_EASY.md`에는 테이블 생성 방법만 있고, C·D 단계 구분이나 D 단계의 작업 내용은 없어.

따라서 정확하게 이어가려면 C·D 단계가 적혀 있는 메인 MD 파일을 첨부해 줘.

그러면 다음 세 가지를 확인해서 안내할게.

1. C 단계가 실제로 모두 완료됐는지
2. D 단계에서 어떤 SAP 객체를 수정해야 하는지
3. 기존 근태 레포트에 영향 없이 진행할 수 있는지

이미 완료한 테이블 생성 작업은 다시 하지 않고, D 단계부터 기존 수정이력 주석 스타일(`XA32762`)을 유지해서 이어갈게.

## ess4-t010-u1 · 사용자

지금 이거 보고 하고 있는거야? 맞아 ?

## ess4-t010-a1 · AI

응. 맞아. 지금 첨부한 `README_R1_APPROVED_CONNECT_20261012_EASY.md`가 우리가 기준으로 삼아야 할 최신 적용 안내서야.

파일 내용을 확인했고, 버전은 **`R1-20261012-approved-connect01`**이야.

앞서 내가 안내한 신규 테이블 2개도 이 문서의 C 단계에 해당해.

## 현재 진행 상황

| 단계 | 작업 내용 | 상태 |
| --- | --- | --- |
| A | 개선 기능 설명 | 확인 |
| B | 기존 소스 백업 | 완료 여부 미확인 |
| C | 신규 테이블 `ZTGUNR1H`, `ZTGUNR1S` 생성 | 1번 완료, 2번 확인 필요 |
| D | 신규 클래스 `ZCL_HR_GUN_R1_PC` 생성 | 다음 단계 |
| E | 기존 메서드·함수 4개 수정 | 대기 |
| F | R1 신청 화면 수정 | 대기 |
| G | 진행 내역 페이지 및 관리자 링크 | 대기 |
| H | 실제 SAP 승인 테스트 | 대기 |

## 다음은 D 단계가 맞아

문서 31~38행에 따르면 신규 클래스는 다음과 같이 생성해야 해.

SE24 신규 클래스

ZCL_HR_GUN_R1_PC

| 항목 | 설정 |
| --- | --- |
| 설명 | R1 기승인 변경 취소 연결 |
| 클래스 유형 | 일반 클래스 |
| 가시성 | Public |
| Final | 체크 |

중요한 주의사항이 있어.

- 기존 `ZCL_HR_GUN_R1`을 덮어쓰면 안 돼.
- `ZCL_HR_GUN_R1_PC`라는 완전히 새로운 클래스를 생성해야 해.
- 기존 `ZCL_HR_GUN_R1`과 `ZCL_HR_GUN_R1_QUOTA`는 활성화되어 있어야 해.
- 클래스 생성 후에는 `METHODS_GUIDE.md`에 따라 메서드를 등록하고 소스를 적용해야 해.

이후 E 단계에서 함수 4개를 수정하고, F·G 단계에서 BSP 화면을 연결하는 순서야.

한 가지만 확인하자.

`ZTGUNR1S`까지 생성하고 활성화한 상태야?

완료했다면 바로 D 단계의 클래스 생성부터 메서드 등록까지, 첨부한 안내서를 기준으로 하나씩 진행하자.

## ess4-t011-u1 · 사용자

여기서 어떻게 진행해야하지 ?

## ess4-t011-a1 · AI

좋아. 지금 캡처를 보니 SE24에서 `ZCL_HR_GUN_R1_PC` 클래스를 생성하고, 메서드를 등록하는 화면까지 정상적으로 들어왔어.

현재는 메서드 목록이 비어 있으니, 여기서부터 D 단계를 진행하면 돼.

## 1. 먼저 클래스 설정 확인

상단의 등록정보 탭을 눌러서 다음 항목을 확인해 줘.

| 항목 | 설정값 |
| --- | --- |
| 클래스명 | `ZCL_HR_GUN_R1_PC` |
| 설명 | R1 기승인 변경 취소 연결 |
| 클래스 유형 | 일반 클래스 |
| 가시성 | Public |
| Final | 체크 |

이미 설정되어 있다면 변경하지 않아도 돼.

## 2. 메서드 등록 준비

지금 보이는 방법 탭이 메서드를 등록하는 곳이야.

현재 위치: 방법 탭

왼쪽 첫 번째 빈칸에 메서드 이름 입력

레벨, 가시성, 메서드 종류 설정

매개변수 및 예외 등록 후 소스 적용

하지만 아직 임의로 메서드 이름을 입력하지는 마.

첨부했던 `README_R1_APPROVED_CONNECT_20261012_EASY.md`의 D 단계에서는 메서드 선언을 별도 파일로 제공한다고 되어 있어.

필요한 파일은 다음이야.

`se24/ZCL_HR_GUN_R1_PC/METHODS_GUIDE.md`

이 파일에 메서드별 공개/비공개 여부, 정적 메서드 여부 등이 정리되어 있다고 명시되어 있어.

## 3. 다음에 할 일

`METHODS_GUIDE.md` 파일을 첨부해 줘.

그러면 지금 네가 보고 있는 SE24 화면을 기준으로 다음 사항을 하나씩 정확하게 알려줄게.

- 첫 번째 줄에 입력할 메서드명
- 가시성을 Public 또는 Private 중 무엇으로 설정할지
- 정적 메서드로 설정해야 하는지
- 매개변수 탭에 무엇을 입력할지
- 소스코드는 어디에 붙여 넣을지

기존 `ZCL_HR_GUN_R1` 클래스를 만들었던 방식처럼 한 단계씩 진행하고, 오류가 없으면 다음 단계로 넘어가는 방식으로 하자.

현재 화면은 정상적인 시작 위치야.

## ess4-t012-u1 · 사용자

**# ZCL_HR_GUN_R1_PC 메서드 등록표**

전체 클래스 소스 편집 화면에서는 `apply/approved/ZCL_HR_GUN_R1_PC.abap` 하나를 적용합니다. 아래는 탭 방식 편집 시 사용할 대조표입니다. 메서드마다 Static(정적)으로 만들고 대/소문자는 구분하지 않습니다.

공개 메서드: SAVE_PLAN, RESERVATION, BEFORE_ACTION, BIND_SERIAL, AFTER_ACTION, DECIDE, ORIGINAL_CREDIT, STATUS_HTML. 나머지는 Private입니다.

Types 정의는 PUBLIC_SECTION.txt의 TYPES 문장과 동일하게 등록합니다. 메서드 본문은 같은 폴더의 메서드명.txt입니다. 이미 METHOD/ENDMETHOD가 보이는 화면에서는 본문만 붙이고, 빈 메서드 소스 화면에서는 파일 전체를 적용합니다.

**## SAVE_PLAN**

```abap
CLASS-METHODS save_plan IMPORTING is_before TYPE zthr0080 is_request TYPE zshr0032
                i_dates TYPE string i_types TYPE string i_spans TYPE string
                i_persk TYPE char2 it_files TYPE zcl_hr_gun_r1=>tt_files
      EXPORTING es_return TYPE bapireturn1.
```

**## RESERVATION**

```abap
CLASS-METHODS reservation IMPORTING is_request TYPE zthr0080 i_desta TYPE d i_deend TYPE d
      EXPORTING e_found TYPE char1 e_days TYPE ty_days e_error TYPE string.
```

**## BEFORE_ACTION**

```abap
CLASS-METHODS before_action IMPORTING is_request TYPE zthr0080 i_action TYPE char10
      EXPORTING e_found TYPE char1 es_return TYPE bapireturn1.
```

**## BIND_SERIAL**

```abap
CLASS-METHODS bind_serial IMPORTING is_request TYPE zthr0080.
```

**## AFTER_ACTION**

```abap
CLASS-METHODS after_action IMPORTING is_request TYPE zthr0080 i_action TYPE char10
      CHANGING cs_return TYPE bapireturn1.
```

**## DECIDE**

```abap
CLASS-METHODS decide IMPORTING i_serial TYPE zwf0022-key12 i_decision TYPE char1
                i_wiid TYPE sww_wiid i_reason TYPE string OPTIONAL
      EXPORTING e_found TYPE char1 e_message TYPE string.
```

**## ORIGINAL_CREDIT**

```abap
CLASS-METHODS original_credit IMPORTING is_original TYPE zthr0080 i_desta TYPE d i_deend TYPE d
      EXPORTING e_days TYPE ty_days e_error TYPE string.
```

**## STATUS_HTML**

```abap
CLASS-METHODS status_html IMPORTING i_token TYPE string
      RETURNING VALUE(r_html) TYPE string.
```

**## PARSE_PLAN**

```abap
CLASS-METHODS parse_plan IMPORTING is_before TYPE zthr0080 is_request TYPE zshr0032
                i_dates TYPE string i_types TYPE string i_spans TYPE string
      EXPORTING et_after TYPE tt_gun e_error TYPE string.
```

**## VALIDATE**

```abap
CLASS-METHODS validate IMPORTING is_before TYPE zthr0080 it_after TYPE tt_gun
                is_header TYPE ztgunr1h i_persk TYPE char2
      EXPORTING et_hr TYPE tt_hr et_pools TYPE tt_pools e_error TYPE string.
```

**## ADD_COST**

```abap
CLASS-METHODS add_cost IMPORTING i_pernr TYPE persno i_day TYPE d i_kind TYPE char2 i_old TYPE char1
      CHANGING ct_pools TYPE tt_pools c_error TYPE string.
```

**## LOCK_EMPLOYEE**

```abap
CLASS-METHODS lock_employee IMPORTING i_pernr TYPE persno
      EXPORTING e_error TYPE string.
```

**## UNLOCK_EMPLOYEE**

```abap
CLASS-METHODS unlock_employee IMPORTING i_pernr TYPE persno.
```

**## WF_CHECK**

```abap
CLASS-METHODS wf_check IMPORTING is_header TYPE ztgunr1h i_wiid TYPE sww_wiid
      EXPORTING es_step TYPE zwf0022 es_head TYPE swwwihead e_error TYPE string.
```

**## HR_APPLY**

```abap
CLASS-METHODS hr_apply IMPORTING is_before TYPE zthr0080 it_after TYPE tt_gun
                it_hr TYPE tt_hr it_pools TYPE tt_pools
      CHANGING cs_header TYPE ztgunr1h c_error TYPE string.
```

**## WF_FINISH**

```abap
CLASS-METHODS wf_finish IMPORTING is_step TYPE zwf0022 is_head TYPE swwwihead
      CHANGING cs_header TYPE ztgunr1h c_error TYPE string.
```

**## FINALIZE**

```abap
CLASS-METHODS finalize IMPORTING is_before TYPE zthr0080
      CHANGING cs_header TYPE ztgunr1h ct_after TYPE tt_gun c_error TYPE string.
```

**## UNCHANGED**

```abap
CLASS-METHODS unchanged IMPORTING is_before TYPE zthr0080 it_after TYPE tt_gun it_hr TYPE tt_hr it_pools TYPE tt_pools
      RETURNING VALUE(r_same) TYPE char1.
```

**## SET_ERROR**

```abap
CLASS-METHODS set_error IMPORTING i_text TYPE string
      CHANGING cs_header TYPE ztgunr1h
      RAISING cx_sy_open_sql_db.
```

…

## ess4-t012-a1 · AI

좋아. 이제 `ZCL_HR_GUN_R1_PC`의 메서드 등록표를 확보했으니, 지금 열어둔 SE24 화면에서 작업을 진행할 수 있어.

제공한 등록표를 확인해 보니 총 19개 메서드야.

| 구분 | 개수 | 설정 |
| --- | --- | --- |
| Public | 8개 | 정적 메서드 |
| Private | 11개 | 정적 메서드 |
| 합계 | 19개 | 전부 Static |

다만 메서드 등록 전에 Types 정의를 먼저 등록해야 해. `ty_days`, `tt_gun`, `tt_hr`, `tt_pools`처럼 메서드 매개변수에서 사용하는 사용자 정의 타입이 있기 때문이야.

## 1단계. Types 등록

지금 SE24 화면 상단에 있는 Local Types(로컬 유형) 버튼이 보이지?

하지만 이번에 필요한 타입은 클래스의 `PUBLIC_SECTION`에 정의하는 타입이므로, 단순히 로컬 유형 편집기에 넣으면 안 돼.

가장 간단한 방법은 제공된 `PUBLIC_SECTION.txt`의 `TYPES` 선언을 확인해서 클래스의 공개 타입으로 등록하는 거야.

`PUBLIC_SECTION.txt` 내용을 먼저 보내줘.

그 파일을 보면 네 SAP 화면에서 타입을 어디에, 어떤 순서로 입력할지 정확하게 안내할게.

## 2단계. 메서드 등록 순서

Types를 등록한 뒤에는 다음 순서로 진행하자.

Public 메서드 8개

SE24 → 방법 탭 → 가시성 Public / 레벨 Static

`SAVE_PLAN` · `RESERVATION` · `BEFORE_ACTION` · `BIND_SERIAL` · `AFTER_ACTION` · `DECIDE` · `ORIGINAL_CREDIT` · `STATUS_HTML`

Private 메서드 11개

SE24 → 방법 탭 → 가시성 Private / 레벨 Static

`PARSE_PLAN` · `VALIDATE` · `ADD_COST` · `LOCK_EMPLOYEE` · `UNLOCK_EMPLOYEE` · `WF_CHECK` · `HR_APPLY` · `WF_FINISH` · `FINALIZE` · `UNCHANGED` · `SET_ERROR`

이후 각 메서드의 매개변수를 등록하고, 해당 `.txt` 파일의 메서드 본문을 적용하면 돼.

지금은 메서드를 입력하지 말고 `PUBLIC_SECTION.txt`부터 보내줘. 타입을 먼저 정확하게 등록하면 뒤에서 매개변수 유형 오류가 발생하는 걸 줄일 수 있어.

기존 `ZCL_HR_GUN_R1` 클래스는 수정하지 않고, 신규 `ZCL_HR_GUN_R1_PC`에서만 작업할 거야.

## ess4-t013-u1 · 사용자



## ess4-t013-a1 · AI

확인했어. 지금 오류는 `ZCL_HR_GUN_R1_PC` 클래스의 `ORIGINAL_CREDIT` 메서드 10번째 줄에서 발생하고 있어.

### 1. 오류 원인

오류 메시지:

```
"IS_ORIGINAL-GUNTYPE" is not type-compatible
with formal parameter "I_KIND".
```

문제가 되는 부분은 다음 코드야.

```
i_kind = is_original-guntype
```

`ADD_COST` 메서드의 `I_KIND`는 `CHAR2`로 선언되어 있는데, `IS_ORIGINAL-GUNTYPE`의 실제 타입이 이 매개변수와 호환되지 않아서 발생한 오류야.

### 2. 수정 방법

`ORIGINAL_CREDIT` 메서드에서 10번째 줄의 `IS_ORIGINAL-GUNTYPE`만 직접 전달하지 말고, CHAR2 변수로 변환해서 전달하면 돼.

먼저 메서드 상단의 DATA 선언에 아래 한 줄을 추가해.

```
DATA lv_kind TYPE char2.
```

그리고 기존 10번째 줄을 다음과 같이 수정해.

```
" Start-Modify / XA32762 : GNT-R1-U22
lv_kind = is_original-guntype.

add_cost(
  EXPORTING
    i_pernr = is_original-pernr
    i_day   = ls_day-datum
    i_kind  = lv_kind
    i_old   = 'X'
  CHANGING
    ct_pools = lt_pools
    c_error  = e_error ).
" End-Modify / XA32762 : GNT-R1-U22
```

이렇게 하면 `I_KIND`에 전달하는 변수의 타입이 `CHAR2`로 일치하게 돼.

단, 원본 `GUNTYPE` 값이 2자리를 초과한다면 잘릴 수 있으므로 실제 필드 길이를 확인해야 해. 이번 설계의 근태유형 `12`, `13`, `15`처럼 2자리 코드라면 이 변환 방식이 적절해.

### 3. 수정 후 진행

1. `ORIGINAL_CREDIT` 메서드에서 위 코드 적용
2. 저장
3. 구문 검사 (`Ctrl + F2`)
4. 오류가 사라지면 활성화 (`Ctrl + F3`)

우선 이 오류부터 해결하자. 같은 유형의 오류가 다른 메서드에서도 발생하면 해당 위치를 확인해서 동일한 기준으로 수정하면 돼.

## ess4-t014-u1 · 사용자

풀버전으로 줘

## ess4-t014-a1 · AI

아래는 `ZCL_HR_GUN_R1_PC` 클래스의 `ORIGINAL_CREDIT` 메서드 전체 수정본이야.

기존 로직은 유지하고, `GUNTYPE`을 `CHAR2` 변수로 전달하도록 수정했어. 수정이력 주석도 `XA32762` 스타일로 넣었어.

### ORIGINAL_CREDIT 전체 소스

```

METHOD original_credit.

  DATA: lt_days TYPE zcl_hr_gun_r1=>tt_days,
        ls_day  TYPE zcl_hr_gun_r1=>ty_day,
        lt_pools TYPE tt_pools,
        ls_pool  TYPE ty_pool.

  " Start-Add / XA32762 : GNT-R1-U22
  " ADD_COST-I_KIND 타입 호환성 보완
  DATA lv_kind TYPE char2.
  " End-Add / XA32762 : GNT-R1-U22

  CLEAR: e_days, e_error.

  zcl_hr_gun_r1=>calendar(
    EXPORTING
      i_begda = is_original-begda
      i_endda = is_original-endda
    IMPORTING
      et_days = lt_days
      e_error = e_error ).

  IF e_error IS NOT INITIAL.
    RETURN.
  ENDIF.

  LOOP AT lt_days INTO ls_day
    WHERE free = abap_false
      AND datum >= i_desta
      AND datum <= i_deend.

    " Start-Modify / XA32762 : GNT-R1-U22
    " 기존 GUNTYPE 직접 전달 시 타입 불일치 오류 보완
    lv_kind = is_original-guntype.

    add_cost(
      EXPORTING
        i_pernr = is_original-pernr
        i_day   = ls_day-datum
        i_kind  = lv_kind
        i_old   = 'X'
      CHANGING
        ct_pools = lt_pools
        c_error  = e_error ).
    " End-Modify / XA32762 : GNT-R1-U22

    IF e_error IS NOT INITIAL.
      RETURN.
    ENDIF.

  ENDLOOP.

  LOOP AT lt_pools INTO ls_pool.
    e_days = e_days + ls_pool-old_days.
  ENDLOOP.

ENDMETHOD.
```

### 적용 방법

1. SE24 → `ZCL_HR_GUN_R1_PC` → 방법 탭
2. `ORIGINAL_CREDIT` 메서드 더블클릭
3. 기존 `METHOD original_credit.`부터 `ENDMETHOD.`까지 전체 교체
4. 저장 (`Ctrl + S`)
5. 구문 검사 (`Ctrl + F2`)

주의: 이번 수정은 `I_KIND` 매개변수의 타입 불일치를 해결하기 위한 것이야. `GUNTYPE`이 실제로 2자리 코드인지, 그리고 `ADD_COST`가 동일한 코드를 기대하는지는 확인이 필요해.

구문 검사가 통과하면 활성화하고 다음 오류를 확인하자.

## ess4-t015-u1 · 사용자



## ess4-t015-a1 · AI

확인했어. 이번에는 `STATUS_HTML` 메서드의 42번째 줄에서 타입 호환성 오류가 발생했어.

### 1. 오류 원인

오류 메시지는 다음과 같아.

```
"LS_H-REASON" is not type-compatible
with formal parameter "UNESCAPED".
```

문제가 되는 코드는 이 부분이야.

```
lv_text = cl_http_utility=>escape_html( ls_h-reason ).
```

`ZTGUNR1H-REASON`은 `CHAR(255)`이고, `CL_HTTP_UTILITY=>ESCAPE_HTML`의 입력 매개변수는 `STRING`을 요구하기 때문에 발생한 오류야.

## 2. 수정 방법

메서드 상단에 `STRING` 변수를 하나 선언하고, 그 변수에 `REASON`을 옮긴 다음 HTML 이스케이프 함수를 호출하면 돼.

① DATA 선언부에 추가

```
" Add / XA32762 : GNT-R1-U22
DATA lv_raw_text TYPE string.
```

② 기존 42번째 줄 교체

기존:

```
lv_text = cl_http_utility=>escape_html( ls_h-reason ).
```

수정:

```
" Start-Modify / XA32762 : GNT-R1-U22
lv_raw_text = ls_h-reason.
lv_text = cl_http_utility=>escape_html( lv_raw_text ).
" End-Modify / XA32762 : GNT-R1-U22
```

### 3. 추가로 수정할 부분

바로 아래 44번째 줄도 동일한 문제가 발생할 가능성이 높아.

기존:

```
lv_text = cl_http_utility=>escape_html( ls_h-last_error ).
```

수정:

```
" Start-Modify / XA32762 : GNT-R1-U22
lv_raw_text = ls_h-last_error.
lv_text = cl_http_utility=>escape_html( lv_raw_text ).
" End-Modify / XA32762 : GNT-R1-U22
```

이렇게 하면 `REASON`, `LAST_ERROR` 모두 `STRING`으로 전달되어 타입 오류를 피할 수 있어.

수정 후 `Ctrl + F2`로 구문 검사해 봐.

추가 오류가 나오면 해당 화면을 보내줘. 이전 `ORIGINAL_CREDIT` 오류와 마찬가지로 기존 처리 로직은 유지하면서 타입 호환성 문제만 수정해 나가면 돼.

## ess4-t016-u1 · 사용자



## ess4-t016-a1 · AI

응. 캡처 확인했어. `STATUS_HTML` 메서드의 수정 내용은 정상적으로 반영된 것으로 보여.

특히 다음 부분을 확인했어.

- 45~49행: `REASON`을 `lv_raw_text`로 변환한 후 HTML 이스케이프 처리
- 51~55행: `LAST_ERROR`도 동일하게 수정
- 기존 코드 주석 보존
- `XA32762 / GNT-R1-U22` 수정이력 주석 적용
- 기존 HTML 출력 로직 유지

다만 한 군데 더 확인해야 해.

### 58행

현재 코드:

```
lv_rid = cl_http_utility=>escape_html( ls_h-rid ).
```

`LS_H-RID`도 `CHAR(22)` 필드이므로 앞서 발생한 것과 같은 타입 호환성 오류가 나올 가능성이 있어.

미리 아래처럼 수정해 줘.

```
" Start-Modify / XA32762 : GNT-R1-U22
" 기존
" lv_rid = cl_http_utility=>escape_html( ls_h-rid ).

" 변경
lv_raw_text = ls_h-rid.
lv_rid = cl_http_utility=>escape_html( lv_raw_text ).
" End-Modify / XA32762 : GNT-R1-U22
```

그리고 메서드 상단에 아래 선언이 있는지 확인해 줘.

```
DATA lv_raw_text TYPE string.
```

이미 추가했다면 중복 선언하지 않아도 돼.

이후 `Ctrl + F2`로 구문 검사해 봐.

현재 캡처에는 구문 검사 결과가 보이지 않아서 오류가 모두 해결됐다고 확정할 수는 없어.

구문 검사까지 통과하면 `STATUS_HTML`은 완료로 보고, 다음 오류나 D 단계 활성화 결과를 확인하자.

## ess4-t017-u1 · 사용자



## ess4-t017-a1 · AI

확인했어. 이번에는 `ZCL_HR_GUN_R1_PC` → `VALIDATE` 메서드 53번째 줄에서 앞서 `ORIGINAL_CREDIT`와 동일한 타입 오류가 발생했어.

오류 메시지:

```
"IS_BEFORE-GUNTYPE" is not type-compatible
with formal parameter "I_KIND".
```

`ADD_COST` 메서드의 `I_KIND`는 `CHAR2`인데, `IS_BEFORE-GUNTYPE`의 타입이 일치하지 않아서 발생한 오류야.

## 1. 수정 방법

### ① DATA 선언부에 변수 추가

`VALIDATE` 메서드 맨 위의 DATA 선언 부분에 추가해 줘.

```
" Add / XA32762 : GNT-R1-U22
DATA lv_kind TYPE char2.
```

### ② 기존 52~54행 수정

현재 코드:

```
add_cost(
  EXPORTING
    i_pernr = is_before-pernr
    i_day   = ls_calendar-datum
    i_kind  = is_before-guntype
    i_old   = 'X'
  CHANGING
    ct_pools = et_pools
    c_error  = e_error ).
```

다음 코드로 교체해.

```
" Start-Modify / XA32762 : GNT-R1-U22
" 기존 GUNTYPE 직접 전달 시 타입 호환성 오류 보완

lv_kind = is_before-guntype.

add_cost(
  EXPORTING
    i_pernr = is_before-pernr
    i_day   = ls_calendar-datum
    i_kind  = lv_kind
    i_old   = 'X'
  CHANGING
    ct_pools = et_pools
    c_error  = e_error ).

" End-Modify / XA32762 : GNT-R1-U22
```

## 2. 주의사항

`ADD_COST` 호출은 `VALIDATE` 메서드 안에 여러 개 있을 수 있어.

따라서 `i_kind = is_before-guntype`과 같은 직접 전달 구문이 다른 위치에도 있는지 확인해 줘.

단, 모든 `i_kind`를 무조건 수정할 필요는 없어. 이미 `CHAR2` 타입인 변수는 그대로 사용하면 돼.

또한 `GUNTYPE`의 실제 값이 `12`, `13`, `15`처럼 2자리 코드인지 확인해야 해. 2자리를 초과하면 `CHAR2` 변수에 대입할 때 값이 잘릴 수 있어.

## 3. 다음 진행

1. 위 코드로 52~54행 수정
2. 저장
3. `Ctrl + F2`로 구문 검사
4. 오류가 없으면 활성화

이번 수정은 타입 호환성 문제만 해결하며 기존 근태 검증 로직은 변경하지 않아.

`VALIDATE` 메서드에서 다른 오류가 발생하면 이어서 확인해 줄게.

## ess4-t018-u1 · 사용자

풀버전으로 줘

## ess4-t018-a1 · AI

응. `ZCL_HR_GUN_R1_PC` 클래스의 `VALIDATE` 메서드 전체 수정본으로 만들어줄게.

이번에는 기존 검증 로직을 유지하면서 53행의 `IS_BEFORE-GUNTYPE` 타입 오류를 수정하고, 변경 부분에는 `XA32762 / GNT-R1-U22` 주석을 넣을 거야.

다만 지금 캡처에는 `VALIDATE` 메서드의 39~101행 정도만 보이기 때문에, 나머지 소스를 임의로 만들어서 전체본이라고 제공하면 기존 검증 로직이 손상될 수 있어.

확인한 자료에는 `VALIDATE`의 전체 구현 소스가 없고, 적용 안내서에 파일 위치만 나와 있어.

ZIP 안의 다음 파일 하나만 첨부해 줘.

`se24/ZCL_HR_GUN_R1_PC/VALIDATE.txt`

그러면 다음 사항을 반영한 전체 교체용 ABAP 소스를 만들어줄게.

- `METHOD validate.`부터 `ENDMETHOD.`까지 전체 포함
- `I_KIND` 타입 호환성 오류 수정
- 기존 검증 로직과 주석 유지
- `XA32762` 수정이력 주석 적용
- SE24에 그대로 붙여 넣을 수 있는 형태

현재 보이는 53행만 고치는 것은 가능하지만, 네가 요청한 풀버전은 원본 전체를 기준으로 만드는 게 안전해.

## ess4-t019-u1 · 사용자

METHOD validate.
    DATA: ls_db TYPE zthr0080, ls_row TYPE zthr0080, ls_pending TYPE zthr0080,
          lt_pending TYPE tt_gun, lt_calendar TYPE zcl_hr_gun_r1=>tt_days,
          ls_calendar TYPE zcl_hr_gun_r1=>ty_day, ls_hr TYPE p2001,
          lt_overlap TYPE STANDARD TABLE OF pa2001, ls_overlap TYPE pa2001,
          ls_pool TYPE ty_pool, lv_awart TYPE pa2001-awart, lv_count TYPE i,
          lv_index TYPE sy-tabix, lv_days TYPE ty_days, lv_total TYPE ty_days,
          lv_used TYPE ty_days, ls_input TYPE zshr0032, ls_old TYPE zshr0032,
          ls_return TYPE bapireturn1, lt_display TYPE STANDARD TABLE OF pa2006,
          ls_display TYPE pa2006, lv_found TYPE i, lv_match TYPE char1,
          lv_sum TYPE ty_days.
    CLEAR: et_hr, et_pools, e_error.
    SELECT SINGLE * INTO ls_db FROM zthr0080 WHERE pernr = is_before-pernr
      AND begda = is_before-begda AND endda = is_before-endda AND seqnr = is_before-seqnr.
    IF sy-subrc <> 0 OR ls_db <> is_before OR ls_db-zaccept <> 'Y' OR
       ls_db-zserial IS INITIAL OR ls_db-zutext IS NOT INITIAL OR
       ls_db-gunart <> '10' OR ls_db-uhyung <> '01' OR
       ( ls_db-guntype <> '12' AND ls_db-guntype <> '13' AND ls_db-guntype <> '15' ).
      e_error = '유효한 승인 원본이 아니거나 선택 이후 변경되었습니다.'. RETURN.
    ENDIF.
    SELECT COUNT( * ) INTO lv_count FROM zthr0080_kobis WHERE key12 = is_before-zserial
      AND pernr = is_before-pernr AND zaccept = 'Y' AND state = 'A'.
    IF lv_count <> 1. e_error = '승인 원본의 유효한 결재 연동 행을 하나로 확인할 수 없습니다.'. RETURN. ENDIF.
    SELECT * INTO TABLE lt_pending FROM zthr0080 WHERE pernr = is_before-pernr AND zaccept = ''.
    DELETE lt_pending WHERE begda = is_header-rbegda AND endda = is_header-rendda AND seqnr = is_header-rseqnr.
    LOOP AT lt_pending INTO ls_pending WHERE zserial2 = is_before-zserial.
      e_error = '이 승인 원본에 처리 중인 변경·취소 요청이 있습니다.'. RETURN.
    ENDLOOP.
    CASE is_before-guntype.
      WHEN '12'. lv_awart = '1021'.
      WHEN '13'. lv_awart = '1024'.
      WHEN '15'. lv_awart = '1025'.
    ENDCASE.
    SELECT * INTO CORRESPONDING FIELDS OF TABLE et_hr FROM pa2001
      WHERE pernr = is_before-pernr AND begda <= is_before-endda AND endda >= is_before-begda.
    IF et_hr IS INITIAL. e_error = '승인 원본의 표준 근태가 없습니다.'. RETURN. ENDIF.
    LOOP AT et_hr INTO ls_hr.
      IF ls_hr-awart <> lv_awart OR ls_hr-begda < is_before-begda OR ls_hr-endda > is_before-endda OR
         ls_hr-sprps IS NOT INITIAL.
        e_error = '원본의 표준 근태 유형·기간·잠금 상태를 확인하세요.'. RETURN.
      ENDIF.
    ENDLOOP.
    zcl_hr_gun_r1=>calendar( EXPORTING i_begda = is_before-begda i_endda = is_before-endda
      IMPORTING et_days = lt_calendar e_error = e_error ).
    IF e_error IS NOT INITIAL. RETURN. ENDIF.
    LOOP AT lt_calendar INTO ls_calendar WHERE free = abap_false.
      CLEAR lv_count.
      LOOP AT et_hr INTO ls_hr WHERE begda <= ls_calendar-datum AND endda >= ls_calendar-datum.
        lv_count = lv_count + 1.
      ENDLOOP.
      IF lv_count <> 1. e_error = '원본 날짜의 표준 근태가 중복되거나 누락되었습니다.'. RETURN. ENDIF.
      add_cost( EXPORTING i_pernr = is_before-pernr i_day = ls_calendar-datum
        i_kind = is_before-guntype i_old = 'X' CHANGING ct_pools = et_pools c_error = e_error ).
      IF e_error IS NOT INITIAL. RETURN. ENDIF.
    ENDLOOP.
    "KALTG is retained as the original workday count; no guessed credit.
    LOOP AT et_hr INTO ls_hr.
      CLEAR lv_count.
      LOOP AT lt_calendar INTO ls_calendar WHERE free = abap_false AND
        datum >= ls_hr-begda AND datum <= ls_hr-endda. lv_count = lv_count + 1. ENDLOOP.
      IF ls_hr-kaltg <> lv_count OR lv_count = 0.
        e_error = '원본 표준 근태 일수와 회사 달력이 다릅니다. 자동 변경하지 않았습니다.'. RETURN.
      ENDIF.
    ENDLOOP.
    MOVE-CORRESPONDING is_before TO ls_old.
    IF it_after IS INITIAL.
      ls_input = ls_old. ls_input-state = '2'. ls_input-zserial2 = is_before-zserial.
      CALL FUNCTION 'ZHR_GUN_R1_CHECK_RULES'
        EXPORTING wa = ls_input itab = ls_old p_gubun = 'R1_APRC' persk = i_persk
        IMPORTING o_return = ls_return.
      IF ls_return-type CA 'EAX' OR ls_return-message <> 'R1_APRV_RULES_OK'.
        e_error = ls_return-message.
        IF e_error IS INITIAL. e_error = '기승인 취소 검증 버전을 확인하세요.'. ENDIF.
        RETURN.
      ENDIF.
    ENDIF.
    LOOP AT it_after INTO ls_row.
      MOVE-CORRESPONDING ls_row TO ls_input.
      ls_input-state = 'D'. ls_input-zserial2 = is_before-zserial.
      CONCATENATE is_before-begda ' ~ ' is_before-endda INTO ls_input-zbegun.
      CALL FUNCTION 'ZHR_GUN_R1_CHECK_RULES'
        EXPORTING wa = ls_input itab = ls_old p_gubun = 'R1_APRV' persk = i_persk
        IMPORTING o_return = ls_return.
      IF ls_return-type CA 'EAX' OR ls_return-message <> 'R1_APRV_RULES_OK'.
        e_error = ls_return-message.
        IF e_error IS INITIAL. e_error = '기승인 변경 업무 검증 버전을 확인하세요.'. ENDIF.
        RETURN.
      ENDIF.
      SELECT * INTO TABLE lt_overlap FROM pa2001 WHERE pernr = ls_row-pernr
        AND begda <= ls_row-endda AND endda >= ls_row-begda.
      LOOP AT lt_overlap INTO ls_overlap.
        READ TABLE et_hr WITH KEY pernr = ls_overlap-pernr subty = ls_overlap-subty
          objps = ls_overlap-objps sprps = ls_overlap-sprps begda = ls_overlap-begda
          endda = ls_overlap-endda seqnr = ls_overlap-seqnr TRANSPORTING NO FIELDS.
        IF sy-subrc <> 0. e_error = '다른 승인 근태와 변경 날짜가 겹칩니다.'. RETURN. ENDIF.
      ENDLOOP.
      LOOP AT lt_pending INTO ls_pending WHERE begda <= ls_row-endda AND endda >= ls_row-begda.
        e_error = '다른 미결 신청과 변경 날짜가 겹칩니다.'. RETURN.
      ENDLOOP.
      zcl_hr_gun_r1=>calendar( EXPORTING i_begda = ls_row-begda i_endda = ls_row-endda
        IMPORTING et_days = lt_calendar e_error = e_error ).
      IF e_error IS NOT INITIAL. RETURN. ENDIF.
      LOOP AT lt_calendar INTO ls_calendar WHERE free = abap_false.
        add_cost( EXPORTING i_pernr = is_before-pernr i_day = ls_calendar-datum
          i_kind = ls_row-guntype i_old = '' CHANGING ct_pools = et_pools c_error = e_error ).
        IF e_error IS NOT INITIAL. RETURN. ENDIF.
      ENDLOOP.
    ENDLOOP.
    LOOP AT et_pools INTO ls_pool.
      lv_index = sy-tabix.
      CLEAR ls_pool-reserved.
      LOOP AT lt_pending INTO ls_pending WHERE gunart = '10' AND
        ( guntype = '12' OR guntype = '13' OR guntype = '15' ).
        zcl_hr_gun_r1_quota=>reservation( EXPORTING is_pending = ls_pending
          i_desta = ls_pool-quota-desta i_deend = ls_pool-quota-deend
          IMPORTING e_days = lv_days e_error = e_error ).
        IF e_error IS NOT INITIAL. RETURN. ENDIF.
        ls_pool-reserved = ls_pool-reserved + lv_days.
      ENDLOOP.
      IF ls_pool-old_days > ls_pool-quota-kverb.
        e_error = '원본 사용량보다 실제 연차 사용량이 작습니다. 담당자 확인이 필요합니다.'. RETURN.
      ENDIF.
      lv_used = ls_pool-quota-kverb - ls_pool-old_days + ls_pool-new_days.
      IF lv_used < 0 OR lv_used > ls_pool-quota-anzhl.
        e_error = '변경 후 연차 사용량이 배정 범위를 벗어납니다.'. RETURN.
      ENDIF.
      REFRESH lt_display.
      CALL FUNCTION 'ZHR_ANNUAL_HOLIDAY'
        EXPORTING pernr = is_before-pernr begda = ls_pool-quota-desta endda = ls_pool-quota-deend
        TABLES it_2006 = lt_display.
      CLEAR lv_found.
      LOOP AT lt_display INTO ls_display WHERE begda = ls_pool-quota-begda AND endda = ls_pool-quota-endda
        AND desta = ls_pool-quota-desta AND deend = ls_pool-quota-deend AND ktart = ls_pool-quota-ktart.
        lv_found = lv_found + 1.
        lv_total = ls_display-kverb - ls_pool-old_days + ls_pool-new_days + ls_pool-reserved.
        IF lv_total > ls_display-anzhl.
          e_error = '다른 미결 신청을 포함하면 변경 후 연차가 부족합니다.'. RETURN.
        ENDIF.
      ENDLOOP.
      IF lv_found <> 1. e_error = '표시 잔여와 실제 공제 대상 연결을 확인할 수 없습니다.'. RETURN. ENDIF.
      MODIFY et_pools FROM ls_pool INDEX lv_index.
    ENDLOOP.
  ENDMETHOD.

…

## ess4-t019-a1 · AI

좋아. 보내준 `VALIDATE` 원본 전체를 기준으로 수정했어.

이번에는 기존 검증 로직은 그대로 유지하고, `ADD_COST` 호출 시 발생하는 타입 오류 두 곳만 수정했어.

- 53행 부근: `IS_BEFORE-GUNTYPE` → `LV_KIND`
- 후반부: `LS_ROW-GUNTYPE` → `LV_KIND`
- `LV_KIND TYPE CHAR2` 변수 추가
- 기존 소스와 수정이력 주석 유지

## ZCL_HR_GUN_R1_PC → VALIDATE 전체 수정본

아래 코드를 기존 `VALIDATE` 메서드 전체와 교체하면 돼.

```

METHOD validate.

  DATA: ls_db TYPE zthr0080,
        ls_row TYPE zthr0080,
        ls_pending TYPE zthr0080,
        lt_pending TYPE tt_gun,
        lt_calendar TYPE zcl_hr_gun_r1=>tt_days,
        ls_calendar TYPE zcl_hr_gun_r1=>ty_day,
        ls_hr TYPE p2001,
        lt_overlap TYPE STANDARD TABLE OF pa2001,
        ls_overlap TYPE pa2001,
        ls_pool TYPE ty_pool,
        lv_awart TYPE pa2001-awart,
        lv_count TYPE i,
        lv_index TYPE sy-tabix,
        lv_days TYPE ty_days,
        lv_total TYPE ty_days,
        lv_used TYPE ty_days,
        ls_input TYPE zshr0032,
        ls_old TYPE zshr0032,
        ls_return TYPE bapireturn1,
        lt_display TYPE STANDARD TABLE OF pa2006,
        ls_display TYPE pa2006,
        lv_found TYPE i,
        lv_match TYPE char1,
        lv_sum TYPE ty_days.

  " Start-Add / XA32762 : GNT-R1-U22
  " ADD_COST-I_KIND 타입 호환성 보완
  DATA lv_kind TYPE char2.
  " End-Add / XA32762 : GNT-R1-U22

  CLEAR: et_hr, et_pools, e_error.

  SELECT SINGLE * INTO ls_db
    FROM zthr0080
    WHERE pernr = is_before-pernr
      AND begda = is_before-begda
      AND endda = is_before-endda
      AND seqnr = is_before-seqnr.

  IF sy-subrc <> 0 OR
     ls_db <> is_before OR
     ls_db-zaccept <> 'Y' OR
     ls_db-zserial IS INITIAL OR
     ls_db-zutext IS NOT INITIAL OR
     ls_db-gunart <> '10' OR
     ls_db-uhyung <> '01' OR
     ( ls_db-guntype <> '12' AND
       ls_db-guntype <> '13' AND
       ls_db-guntype <> '15' ).

    e_error = '유효한 승인 원본이 아니거나 선택 이후 변경되었습니다.'.
    RETURN.
  ENDIF.

  SELECT COUNT( * ) INTO lv_count
    FROM zthr0080_kobis
    WHERE key12 = is_before-zserial
      AND pernr = is_before-pernr
      AND zaccept = 'Y'
      AND state = 'A'.

  IF lv_count <> 1.
    e_error = '승인 원본의 유효한 결재 연동 행을 하나로 확인할 수 없습니다.'.
    RETURN.
  ENDIF.

  SELECT * INTO TABLE lt_pending
    FROM zthr0080
    WHERE pernr = is_before-pernr
      AND zaccept = ''.

  DELETE lt_pending
    WHERE begda = is_header-rbegda
      AND endda = is_header-rendda
      AND seqnr = is_header-rseqnr.

  LOOP AT lt_pending INTO ls_pending
    WHERE zserial2 = is_before-zserial.

    e_error = '이 승인 원본에 처리 중인 변경·취소 요청이 있습니다.'.
    RETURN.
  ENDLOOP.

  CASE is_before-guntype.
    WHEN '12'.
      lv_awart = '1021'.
    WHEN '13'.
      lv_awart = '1024'.
    WHEN '15'.
      lv_awart = '1025'.
  ENDCASE.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE et_hr
    FROM pa2001
    WHERE pernr = is_before-pernr
      AND begda <= is_before-endda
      AND endda >= is_before-begda.

  IF et_hr IS INITIAL.
    e_error = '승인 원본의 표준 근태가 없습니다.'.
    RETURN.
  ENDIF.

  LOOP AT et_hr INTO ls_hr.

    IF ls_hr-awart <> lv_awart OR
       ls_hr-begda < is_before-begda OR
       ls_hr-endda > is_before-endda OR
       ls_hr-sprps IS NOT INITIAL.

      e_error = '원본의 표준 근태 유형·기간·잠금 상태를 확인하세요.'.
      RETURN.
    ENDIF.

  ENDLOOP.

  zcl_hr_gun_r1=>calendar(
    EXPORTING
      i_begda = is_before-begda
      i_endda = is_before-endda
    IMPORTING
      et_days = lt_calendar
      e_error = e_error ).

  IF e_error IS NOT INITIAL.
    RETURN.
  ENDIF.

  LOOP AT lt_calendar INTO ls_calendar
    WHERE free = abap_false.

    CLEAR lv_count.

    LOOP AT et_hr INTO ls_hr
      WHERE begda <= ls_calendar-datum
        AND endda >= ls_calendar-datum.

      lv_count = lv_count + 1.

    ENDLOOP.

    IF lv_count <> 1.
      e_error = '원본 날짜의 표준 근태가 중복되거나 누락되었습니다.'.
      RETURN.
    ENDIF.

    " Start-Modify / XA32762 : GNT-R1-U22
    " 기존 GUNTYPE 직접 전달 시 타입 호환성 오류
    " i_kind = is_before-guntype

    lv_kind = is_before-guntype.

    add_cost(
      EXPORTING
        i_pernr = is_before-pernr
        i_day   = ls_calendar-datum
        i_kind  = lv_kind
        i_old   = 'X'
      CHANGING
        ct_pools = et_pools
        c_error  = e_error ).

    " End-Modify / XA32762 : GNT-R1-U22

    IF e_error IS NOT INITIAL.
      RETURN.
    ENDIF.

  ENDLOOP.

  "KALTG is retained as the original workday count; no guessed credit.

  LOOP AT et_hr INTO ls_hr.

    CLEAR lv_count.

    LOOP AT lt_calendar INTO ls_calendar
      WHERE free = abap_false
        AND datum >= ls_hr-begda
        AND datum <= ls_hr-endda.

      lv_count = lv_count + 1.

    ENDLOOP.

    IF ls_hr-kaltg <> lv_count OR lv_count = 0.
      e_error = '원본 표준 근태 일수와 회사 달력이 다릅니다. 자동 변경하지 않았습니다.'.
      RETURN.
    ENDIF.

  ENDLOOP.

  MOVE-CORRESPONDING is_before TO ls_old.

  IF it_after IS INITIAL.

    ls_input = ls_old.
    ls_input-state = '2'.
    ls_input-zserial2 = is_before-zserial.

    CALL FUNCTION 'ZHR_GUN_R1_CHECK_RULES'
      EXPORTING
        wa      = ls_input
        itab    = ls_old
        p_gubun = 'R1_APRC'
        persk   = i_persk
      IMPORTING
        o_return = ls_return.

    IF ls_return-type CA 'EAX' OR
       ls_return-message <> 'R1_APRV_RULES_OK'.

      e_error = ls_return-message.

      IF e_error IS INITIAL.
        e_error = '기승인 취소 검증 버전을 확인하세요.'.
      ENDIF.

      RETURN.
    ENDIF.

  ENDIF.

  LOOP AT it_after INTO ls_row.

    MOVE-CORRESPONDING ls_row TO ls_input.

    ls_input-state = 'D'.
    ls_input-zserial2 = is_before-zserial.

    CONCATENATE is_before-begda
                ' ~ '
                is_before-endda
           INTO ls_input-zbegun.

    CALL FUNCTION 'ZHR_GUN_R1_CHECK_RULES'
      EXPORTING
        wa      = ls_input
        itab    = ls_old
        p_gubun = 'R1_APRV'
        persk   = i_persk
      IMPORTING
        o_return = ls_return.

    IF ls_return-type CA 'EAX' OR
       ls_return-message <> 'R1_APRV_RULES_OK'.

      e_error = ls_return-message.

      IF e_error IS INITIAL.
        e_error = '기승인 변경 업무 검증 버전을 확인하세요.'.
      ENDIF.

      RETURN.
    ENDIF.

    SELECT * INTO TABLE lt_overlap
      FROM pa2001
      WHERE pernr = ls_row-pernr
        AND begda <= ls_row-endda
        AND endda >= ls_row-begda.

    LOOP AT lt_overlap INTO ls_overlap.

      READ TABLE et_hr
        WITH KEY pernr = ls_overlap-pernr
                 subty = ls_overlap-subty
                 objps = ls_overlap-objps
                 sprps = ls_overlap-sprps
                 begda = ls_overlap-begda
                 endda = ls_overlap-endda
                 seqnr = ls_overlap-seqnr
        TRANSPORTING NO FIELDS.

      IF sy-subrc <> 0.
        e_error = '다른 승인 근태와 변경 날짜가 겹칩니다.'.
        RETURN.
      ENDIF.

    ENDLOOP.

    LOOP AT lt_pending INTO ls_pending
      WHERE begda <= ls_row-endda
        AND endda >= ls_row-begda.

      e_error = '다른 미결 신청과 변경 날짜가 겹칩니다.'.
      RETURN.

    ENDLOOP.

    zcl_hr_gun_r1=>calendar(
      EXPORTING
        i_begda = ls_row-begda
        i_endda = ls_row-endda
      IMPORTING
        et_days = lt_calendar
        e_error = e_error ).

    IF e_error IS NOT INITIAL.
      RETURN.
    ENDIF.

    LOOP AT lt_calendar INTO ls_calendar
      WHERE free = abap_false.

      " Start-Modify / XA32762 : GNT-R1-U22
      " 변경 후 근태유형의 ADD_COST 타입 호환성 보완
      " i_kind = ls_row-guntype

      lv_kind = ls_row-guntype.

      add_cost(
        EXPORTING
          i_pernr = is_before-pernr
          i_day   = ls_calendar-datum
          i_kind  = lv_kind
          i_old   = ''
        CHANGING
          ct_pools = et_pools
          c_error  = e_error ).

      " End-Modify / XA32762 : GNT-R1-U22

      IF e_error IS NOT INITIAL.
        RETURN.
      ENDIF.

    ENDLOOP.

  ENDLOOP.

  LOOP AT et_pools INTO ls_pool.

    lv_index = sy-tabix.

    CLEAR ls_pool-reserved.

    LOOP AT lt_pending INTO ls_pending
      WHERE gunart = '10'
        AND ( guntype = '12' OR
              guntype = '13' OR
              guntype = '15' ).

      zcl_hr_gun_r1_quota=>reservation(
        EXPORTING
          is_pending = ls_pending
          i_desta    = ls_pool-quota-desta
          i_deend    = ls_pool-quota-deend
        IMPORTING
          e_days  = lv_days
          e_error = e_error ).

      IF e_error IS NOT INITIAL.
        RETURN.
      ENDIF.

      ls_pool-reserved = ls_pool-reserved + lv_days.

    ENDLOOP.

    IF ls_pool-old_days > ls_pool-quota-kverb.
      e_error = '원본 사용량보다 실제 연차 사용량이 작습니다. 담당자 확인이 필요합니다.'.
      RETURN.
    ENDIF.

    lv_used = ls_pool-quota-kverb
            - ls_pool-old_days
            + ls_pool-new_days.

    IF lv_used < 0 OR lv_used > ls_pool-quota-anzhl.
      e_error = '변경 후 연차 사용량이 배정 범위를 벗어납니다.'.
      RETURN.
    ENDIF.

    REFRESH lt_display.

    CALL FUNCTION 'ZHR_ANNUAL_HOLIDAY'
      EXPORTING
        pernr = is_before-pernr
        begda = ls_pool-quota-desta
        endda = ls_pool-quota-deend
      TABLES
        it_2006 = lt_display.

    CLEAR lv_found.

    LOOP AT lt_display INTO ls_display
      WHERE begda = ls_pool-quota-begda
        AND endda = ls_pool-quota-endda
        AND desta = ls_pool-quota-desta
        AND deend = ls_pool-quota-deend
        AND ktart = ls_pool-quota-ktart.

      lv_found = lv_found + 1.

      lv_total = ls_display-kverb
               - ls_pool-old_days
               + ls_pool-new_days
               + ls_pool-reserved.

      IF lv_total > ls_display-anzhl.
        e_error = '다른 미결 신청을 포함하면 변경 후 연차가 부족합니다.'.
        RETURN.
      ENDIF.

    ENDLOOP.

    IF lv_found <> 1.
      e_error = '표시 잔여와 실제 공제 대상 연결을 확인할 수 없습니다.'.
      RETURN.
    ENDIF.

    MODIFY et_pools FROM ls_pool INDEX lv_index.

  ENDLOOP.

ENDMETHOD.
```

## 적용 방법

1. SE24에서 `ZCL_HR_GUN_R1_PC` 열기
2. `VALIDATE` 메서드 더블클릭
3. 기존 전체 소스 백업
4. 위 코드로 전체 교체
5. 저장 후 `Ctrl + F2` 구문 검사
6. 오류가 없으면 활성화

참고: 이번 수정은 타입 호환성을 위한 것이고, 실제 SAP 시스템에서 구문 검사나 승인 처리 테스트를 실행한 것은 아니야. `GUNTYPE`의 실제 길이가 2자리를 초과하는 경우에는 잘림 여부도 확인해야 해.

구문 검사 결과를 알려줘. 통과하면 D 단계의 나머지 메서드 오류를 계속 확인하자.

## ess4-t020-u1 · 사용자

ZCL_HR_GUN_R1_PC 클랙스와 내부 메소드 다 생성 했어. 그 다음은 ?

## ess4-t020-a1 · AI

좋아! 그럼 D 단계인 `ZCL_HR_GUN_R1_PC` 클래스 및 내부 메서드 19개 생성까지 완료한 거네.

이제 우리가 기준으로 삼고 있는 `README_R1_APPROVED_CONNECT_20261012_EASY.md`에 따라 E 단계: 기존 R1 클래스 메서드 및 함수 4개 수정으로 넘어가면 돼.

단, D 단계에서 클래스 전체 구문 검사와 활성화까지 성공했는지는 별도로 확인해야 해.

## 현재 진행 상황

| 단계 | 작업 | 상태 |
| --- | --- | --- |
| C | 신규 테이블 2개 생성 | 완료 기준 |
| D | `ZCL_HR_GUN_R1_PC` 및 19개 메서드 생성 | 생성 완료 |
| D 최종 | 클래스 구문 검사·활성화 | 확인 필요 |
| E | 기존 R1 메서드·함수 4개 수정 | 다음 단계 |
| F | R1 근태 신청 화면 연결 | 대기 |
| G | 진행 내역·관리자 화면 연결 | 대기 |
| H | 실제 승인 및 데이터 정합성 테스트 | 대기 |

## 1. E 단계에서 수정할 대상 4개

최신 README에 명시된 순서야.

README_R1_APPROVED_CONNECT_20261012_EASY.md

| 순서 | SAP 수정 대상 | 적용할 파일 |
| --- | --- | --- |
| E1 | `ZCL_HR_GUN_R1_QUOTA` → `RESERVATION` | `se24/ZCL_HR_GUN_R1_QUOTA/RESERVATION.txt` |
| E2 | `ZHR_GUN_R1_CHECK_RULES` | `apply/request_group/ZHR_GUN_R1_CHECK_RULES.txt` |
| E3 | `ZHR_SAVE_GUN_R1` | `apply/request_group/ZHR_SAVE_GUN_R1.txt` |
| E4 | `ZHR_GUN_GULJAE_R1` | `apply/approved/ZHR_GUN_GULJAE_R1.txt` |

## 2. 지금은 E1부터 진행하자

현재 작업 E1

RESERVATION 메서드 수정

1. SAP에서 `SE24` 실행
2. 클래스명 `ZCL_HR_GUN_R1_QUOTA` 입력
3. 변경 클릭
4. 방법 탭 선택
5. `RESERVATION` 메서드 더블클릭
6. 현재 소스를 먼저 백업
7. `se24/ZCL_HR_GUN_R1_QUOTA/RESERVATION.txt`의 소스로 교체
8. 저장 → 구문 검사 → 활성화

여기서 주의할 점은 `ZCL_HR_GUN_R1_PC`의 `RESERVATION`이 아니라 `ZCL_HR_GUN_R1_QUOTA`의 `RESERVATION`을 수정해야 한다는 것이야.

E2~E4에서는 SE37 함수 소스를 수정하지만, 지금은 건드리지 말자.

그리고 기존 `guntae_input.kbs`, 공통 ZWF 함수, 기존 승인 프로그램은 이번 단계에서 수정 대상이 아니야.

다음으로 `RESERVATION.txt` 파일 내용을 보내줘. 기존 코드와 대조해 타입 오류 가능성까지 확인한 후 적용하도록 하자.

추가로, D 단계의 `ZCL_HR_GUN_R1_PC`가 구문 검사 오류 없이 정상 활성화된 상태인지도 함께 알려줘. 그 상태여야 다음 연결 작업을 안전하게 진행할 수 있어.

## ess4-t021-u1 · 사용자

일단 다음 진행하기에 앞서서, 이거 내역값 알려줘

## ess4-t021-a1 · AI

좋아. 현재 `ZCL_HR_GUN_R1_PC` 클래스의 19개 메서드가 모두 등록된 것 확인했어.

지금 화면의 오른쪽 내역(Description) 칸에 입력할 한글 설명을 정리해 줄게.

아래 내용은 각 메서드의 선언과 제공된 소스를 기준으로 작성한 권장 내역값이야.

## ZCL_HR_GUN_R1_PC 메서드 내역

| 순번 | 메서드명 | 내역(한글) |
| --- | --- | --- |
| 1 | SAVE_PLAN | 기승인 변경취소 신청 저장 |
| 2 | RESERVATION | 변경취소 신청 예약일수 조회 |
| 3 | BEFORE_ACTION | 변경취소 상신전 사전검증 |
| 4 | BIND_SERIAL | 변경취소 결재문서번호 연결 |
| 5 | AFTER_ACTION | 변경취소 상신후 상태처리 |
| 6 | DECIDE | 기승인 변경취소 결재처리 |
| 7 | ORIGINAL_CREDIT | 원본 승인근태 사용일수 계산 |
| 8 | STATUS_HTML | 변경취소 진행내역 HTML 생성 |
| 9 | PARSE_PLAN | 변경후 날짜별 근태계획 구성 |
| 10 | VALIDATE | 기승인 변경취소 업무검증 |
| 11 | ADD_COST | 날짜별 연차 공제일수 집계 |
| 12 | LOCK_EMPLOYEE | 사원별 근태처리 잠금 |
| 13 | UNLOCK_EMPLOYEE | 사원별 근태처리 잠금해제 |
| 14 | WF_CHECK | 결재 워크플로우 상태검증 |
| 15 | HR_APPLY | 승인근태 및 연차사용량 반영 |
| 16 | WF_FINISH | 결재 워크플로우 완료처리 |
| 17 | FINALIZE | 변경취소 승인결과 최종확정 |
| 18 | UNCHANGED | 변경전후 근태 동일여부 확인 |
| 19 | SET_ERROR | 변경취소 처리오류 기록 |

### 입력 방법

1. 현재 SE24의 방법 탭에서 작업
2. 각 메서드 오른쪽 내역 칸에 위 한글 설명 입력
3. 19개 입력 완료 후 저장 (`Ctrl + S`)
4. 구문 검사 (`Ctrl + F2`)
5. 오류가 없으면 활성화 (`Ctrl + F3`)

메서드 이름, Static 설정, Public/Private 설정은 현재 캡처상 등록표와 일치하므로 변경하지 않아도 돼.

참고로 내역값은 설명용 텍스트이므로 실제 메서드 실행 로직에는 영향을 주지 않아.

입력 후 활성화까지 정상 완료되면 D 단계 완료로 확정하고, 앞서 안내한 E1 단계인 `ZCL_HR_GUN_R1_QUOTA → RESERVATION` 수정으로 넘어가자.

## ess4-t022-u1 · 사용자

**## E. 기존 메서드·함수 교체....이거 하고 있는데 이런게 뜨네 ?**

## ess4-t022-a1 · AI

확인했어. 지금 오류는 `ZHR_GUN_GULJAE_R1` 함수의 소스 자체보다는, 해당 함수가 속한 Function Group의 Include 구조 문제로 보여.

다행히 캡처에 원인이 비교적 명확하게 나와 있어.

## 1. 오류 원인

화면 하단의 오류 메시지는 다음과 같아.

```
Include LZHR008$14

A FUNCTION already exists with the name
"ZHR_SAVE_GUN_R1".
```

이 메시지는 SAP가 `ZHR_SAVE_GUN_R1`이라는 함수를 중복 정의된 것으로 인식하고 있다는 뜻이야.

현재 작업 중인 함수는 `ZHR_GUN_GULJAE_R1`인데, 오류는 다른 함수인 `ZHR_SAVE_GUN_R1`에서 발생하고 있어.

즉, `ZHR_GUN_GULJAE_R1`의 488번째 줄이 문제라는 의미는 아니야.

## 2. 가능한 원인

| 원인 | 설명 |
| --- | --- |
| 함수 전체 소스 중복 붙여넣기 | 기존 `FUNCTION ... ENDFUNCTION`을 남긴 상태에서 전체 소스를 추가 |
| Include 중복 | Function Group에서 동일 함수 구현 Include가 중복 참조됨 |
| 함수명 잘못 적용 | E3 단계의 `ZHR_SAVE_GUN_R1` 소스를 다른 함수 또는 Include에 붙여넣음 |

특히 지금 E 단계에서 여러 함수를 연속으로 수정하고 있으므로, E3 작업 이후 중복 정의가 발생했을 가능성을 먼저 확인해야 해.

다만 캡처만으로 세 가지 중 어느 것이 실제 원인인지는 확정할 수 없어.

## 3. 해결 방법 — 먼저 이것만 확인하자

① SE37 실행

함수명 `ZHR_SAVE_GUN_R1`을 입력하고 조회해.

② 소스코드 탭 확인

소스 맨 위에 다음 선언이 있는지 확인해.

```
FUNCTION zhr_save_gun_r1.
```

③ 소스 맨 아래 확인

`ENDFUNCTION.`이 몇 개 있는지 확인해. 정상적인 함수 구현에는 해당 함수의 시작과 종료 선언이 한 쌍이어야 해.

④ Include 확인

오류에 표시된 `LZHR008$14`를 더블클릭해서 해당 Include의 실제 소스를 확인해. 여기서 `ZHR_SAVE_GUN_R1` 선언이 어떻게 들어가 있는지 보는 게 핵심이야.

## 4. 지금은 삭제하거나 다시 생성하지 마

특히 다음 작업은 아직 하지 않는 게 좋아.

- `ZHR_SAVE_GUN_R1` 함수 삭제
- Function Group의 Include 삭제
- 기존 함수 전체 소스 재붙여넣기
- Function Group 전체 강제 활성화

함수 중복 선언의 실제 위치를 먼저 찾아야 기존 근태 처리 로직을 안전하게 유지할 수 있어.

우선 오류 메시지의 `LZHR008$14`를 더블클릭한 화면을 캡처해서 보여줘.

그 화면을 보면 중복된 `FUNCTION` 선언인지, Include 연결 문제인지 구분해서 어느 부분을 수정해야 하는지 정확하게 안내할게.

지금까지 완료한 C·D 단계는 다시 작업할 필요 없어. E 단계의 이 오류부터 해결하고 이어가자.

## ess4-t023-u1 · 사용자



## ess4-t023-a1 · AI

좋아. 이번 캡처를 보니 오류가 발생한 위치와 원인을 좀 더 구체적으로 확인할 수 있어.

현재 문제는 `ZHR_GUN_GULJAE_R1` 함수가 아니라, 같은 함수 그룹 `ZHR008`에 속한 `ZHR_SAVE_GUN_R1`의 함수 선언 부분이야.

## 1. 현재 확인된 내용

캡처의 5행을 보면 다음 코드가 있어.

```
FUNCTION $$UNIT$$ ZHR_SAVE_GUN_R1
```

여기서 `$$UNIT$$`는 SAP가 함수 모듈의 인터페이스 정보를 생성하면서 사용하는 내부 표기야.

이 화면에서 `$$UNIT$$`를 삭제하거나 `FUNCTION ZHR_SAVE_GUN_R1.`로 직접 변경하면 안 돼.

현재 확인된 사실은 다음과 같아.

| 항목 | 확인 결과 |
| --- | --- |
| 함수 그룹 | `ZHR008` |
| 오류 Include | `LZHR008$14` |
| 중복으로 인식된 함수 | `ZHR_SAVE_GUN_R1` |
| 오류 발생 위치 | 5행 함수 선언 |
| 정확한 중복 원인 | 추가 확인 필요 |

`LZHR008$14`는 함수 인터페이스 관련 생성 Include로 보이므로, 이 파일 자체를 수정하는 방식은 권장하지 않아.

## 2. 가장 먼저 확인할 부분

이번 오류는 E3 단계에서 `ZHR_SAVE_GUN_R1` 함수를 수정한 이후 발생했을 가능성이 있어.

특히 함수 모듈의 기존 소스에 `FUNCTION ... ENDFUNCTION` 전체를 중복해서 붙여넣었는지 확인해야 해.

다음 순서로 진행해 줘.

1. `SE37` 실행
2. 함수명 `ZHR_SAVE_GUN_R1` 입력
3. 조회(Display) 선택
4. 소스코드 탭 선택
5. 소스의 맨 위와 맨 아래 확인

정상적인 소스라면 다음 구조여야 해.

```
FUNCTION zhr_save_gun_r1.

  " 기존 함수 처리 로직
  " R1 개선 로직

ENDFUNCTION.
```

같은 함수의 `FUNCTION` 선언이 두 번 들어가 있다면 중복된 부분을 정리해야 해. 단, 자동 생성된 인터페이스 Include는 수정하지 마.

## 3. 추가로 확인할 사항

소스에 중복 선언이 없다면, 다음으로 함수 그룹 내 함수 등록 정보와 Include 연결을 확인해야 해.

이 경우에는 함수 모듈을 삭제하거나 다시 생성하지 말고, SE80에서 `ZHR008` 함수 그룹을 열어 `ZHR_SAVE_GUN_R1`이 어떻게 등록되어 있는지 확인하는 게 안전해.

특히 `LZHR008$14` 외에 다른 Include에서도 동일한 함수가 정의되어 있는지 살펴봐야 해.

### 지금은 이것만 보여줘

`SE37 → ZHR_SAVE_GUN_R1 → 소스코드` 화면의 맨 위쪽 20~30줄을 캡처해서 보내줘.

그러면 함수 선언이 중복된 것인지, SAP가 생성한 Include 구조 문제인지 다음 단계로 좁혀볼게.

현재는 `LZHR008$14`를 직접 수정하거나 함수를 삭제하지 말고 그대로 유지해 줘.

## ess4-t024-u1 · 사용자

FUNCTION ZHR_SAVE_GUN_R1.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(GUNTAE_LIST) TYPE  ZSHR0032
*"     VALUE(BEFORE_LIST) TYPE  ZSHR0032 OPTIONAL
*"     VALUE(GUBUN) TYPE  CHAR10
*"     VALUE(PERSK) TYPE  CHAR2 OPTIONAL
*"  EXPORTING
*"     VALUE(O_RETURN) TYPE  BAPIRETURN1
*"  CHANGING
*"     VALUE(G_LIST) TYPE  ZSHR0032 OPTIONAL
*"----------------------------------------------------------------------

*  DATA G_LIST LIKE GUNTAE_LIST.
  DATA B_LIST LIKE BEFORE_LIST.
* Start-Add / XA32762 / GNT-R1-U07 / 2026-10-06
  DATA: ls_r1_action_db TYPE zthr0080,
        ls_r1_action_kobis TYPE zthr0080_kobis,
        ls_r1_emp_return TYPE bapireturn1,
        lv_r1_emp_locked TYPE c LENGTH 1,
        lv_r1_att_locked TYPE c LENGTH 1,
        lv_r1_workflow_result TYPE sy-subrc,
        lv_r1_link_count TYPE i,
        lv_r1_workflow_key TYPE sww_wiid,
        lv_r1_empty_serial TYPE zthr0080-zserial,
        ls_r1_action_log TYPE zthr_every_log,
        lx_r1_action TYPE REF TO cx_root.
* End-Add / XA32762 / GNT-R1-U07

  MOVE-CORRESPONDING GUNTAE_LIST TO G_LIST.
  MOVE-CORRESPONDING BEFORE_LIST TO B_LIST.

  CLEAR O_RETURN.

****  결재 승인 상신 데이터 포맷  변경

  CASE b_LIST-zaccept.

…

## ess4-t024-a1 · AI

확인했어. 지금 보내준 `ZHR_SAVE_GUN_R1` 소스 상단은 정상적인 함수 모듈 형태야.

```
FUNCTION ZHR_SAVE_GUN_R1.
*"----------------------------------------------------------------------
*"*"Local interface:
...
*"----------------------------------------------------------------------
```

`FUNCTION` 선언이 한 번만 보이고, 기존 수정이력 주석 `XA32762 / GNT-R1-U07`도 유지되어 있어.

다만 상단 일부만 확인했기 때문에 함수 전체에 중복 선언이 없다고 확정할 수는 없어.

### 중요한 점

앞서 발생한 오류는 다음과 같았지.

```
Include LZHR008$14
A FUNCTION already exists with the name "ZHR_SAVE_GUN_R1".
```

이 오류는 함수 그룹 `ZHR008` 내부에서 `ZHR_SAVE_GUN_R1`이라는 이름이 중복으로 인식되고 있다는 의미야.

지금까지 확인한 두 화면을 종합하면 다음과 같아.

| 확인 항목 | 결과 |
| --- | --- |
| SE37 함수 선언 | 정상 형태 |
| 함수 그룹 | `ZHR008` |
| 오류 Include | `LZHR008$14` |
| 오류 발생 함수 | `ZHR_SAVE_GUN_R1` |
| 실제 중복 위치 | 아직 미확인 |

### 다음은 이렇게 확인하자

지금은 소스를 수정하지 말고 SE80에서 함수 그룹의 Include 연결을 확인하는 게 좋아.

1. `SE80` 실행
2. 왼쪽 객체 유형을 **함수 그룹(Function Group)**으로 선택
3. `ZHR008` 입력 후 조회
4. 함수 모듈 목록에서 `ZHR_SAVE_GUN_R1` 확인
5. Include 목록에서 `LZHR008UXX`를 열어 `ZHR_SAVE_GUN_R1`이 연결된 Include를 확인

`LZHR008UXX`에는 보통 개별 함수 구현 Include를 연결하는 `INCLUDE` 문들이 들어 있어.

확인할 것은 동일한 함수 구현 Include가 두 번 연결되어 있는지 여부야.

그리고 오류가 발생한 `LZHR008$14`는 자동 생성된 인터페이스 관련 Include이므로 직접 수정하지 마.

SE80에서 `LZHR008UXX`를 연 화면을 캡처해서 보여줘.

그걸 보면 중복 Include 문제인지, 함수 등록 정보 문제인지 더 정확하게 구분할 수 있어. 기존 근태 처리에 영향을 주지 않도록 원인을 확인한 뒤 수정하자.

## ess4-t025-u1 · 사용자

G 진행하고 있는데 이렇게 떠

## ess4-t025-a1 · AI

확인했어. 지금은 G 단계의 `guntae_change_status_r1.kbs` 페이지에서 발생한 오류야.

원인은 명확해. BSP 페이지에서 사용하는 `GV_PC_HTML` 변수가 선언되지 않았기 때문이야.

## 1. 오류 원인

현재 Layout 6행에 다음 코드가 있어.

`<%= gv_pc_html %>`

그런데 화면 하단에 다음 오류가 표시되고 있어.

```
Field "GV_PC_HTML" is unknown.
```

즉, Layout에서 `GV_PC_HTML`을 출력하려고 하지만 BSP 페이지가 이 변수를 인식하지 못하는 상태야.

## 2. 해결 방법

현재 열어둔 `guntae_change_status_r1.kbs` 페이지에서 다음 순서로 진행해 줘.

### ① Page Attributes 탭으로 이동

화면 상단에 있는 Page Attributes 탭을 클릭해.

여기에서 아래 속성을 추가해.

| 항목 | 입력값 |
| --- | --- |
| Attribute | `GV_PC_HTML` |
| Typing | TYPE |
| Associated Type | `STRING` |
| Auto | 체크 해제 |

기존에 같은 이름의 속성이 있다면 중복 생성하지 마.

### ② Event Handler 탭 확인

다음으로 Event Handler 탭을 열어.

이 페이지는 R1 변경·취소 진행 내역을 출력하기 위한 페이지이므로, `OnInitialization` 이벤트에서 HTML 내용을 만들어야 해.

기본적인 연결 형태는 다음과 같아.

```
METHOD oninitialization.

  gv_pc_html =
    zcl_hr_gun_r1_pc=>status_html(
      i_token = gv_v2_token ).

ENDMETHOD.
```

단, 이 코드는 `GV_V2_TOKEN`이 현재 페이지에 정의되어 있다는 전제야.

현재 페이지에 해당 속성이 없다면, 토큰을 전달하는 방식부터 확인해야 해. 또한 BSP 이벤트 편집 화면에서는 `METHOD ... ENDMETHOD.`가 자동으로 제공될 수 있으므로, 이미 보이는 경우에는 본문만 입력해야 해.

### ③ 저장 및 활성화

1. `Page Attributes`에서 `GV_PC_HTML` 등록
2. 저장
3. Layout에서 `GV_PC_HTML` 오류가 사라졌는지 구문 검사
4. 정상이라면 페이지 활성화

## 3. 현재 진행 상태

| 작업 | 상태 |
| --- | --- |
| `ZCL_HR_GUN_R1_PC` 클래스 생성 | 완료 |
| E 단계 함수 수정 | 진행 상황 확인 필요 |
| F 단계 R1 신청 화면 | 진행 상황 확인 필요 |
| G 단계 진행 내역 페이지 | 현재 오류 수정 중 |
| H 단계 실제 승인 테스트 | 대기 |

우선 `GV_PC_HTML` 속성부터 추가해 줘.

그리고 `OnInitialization` 이벤트에 이미 코드가 있다면 덮어쓰지 말고 그 화면을 캡처해서 보여줘. 기존 토큰 전달 방식까지 확인한 후 정확하게 연결해 줄게.

## ess4-t026-u1 · 사용자



## ess4-t026-a1 · AI

좋아. 캡처 확인했어. `GV_PC_HTML` 속성은 정상적으로 추가했어. 그런데 이번에는 다른 변수가 선언되지 않아서 오류가 발생한 거야.

### 1. 현재 오류 원인

화면 하단에 다음 메시지가 보여.

```
Field "GV_PC_TOKEN" is unknown.
```

즉, `OnInitialization` 이벤트에서 사용하는 `GV_PC_TOKEN`이 현재 BSP 페이지에 선언되어 있지 않은 상태야.

## 2. 해결 방법

지금 열려 있는 Page Attributes 탭에서 `GV_PC_TOKEN`을 추가하면 돼.

| Attribute | 내역(설명) |
| --- | --- |
| `GV_PC_HTML` | 기승인 변경취소 진행내역 HTML |
| `GV_PC_TOKEN` | 기승인 변경취소 페이지 인증토큰 |

현재 화면의 빈 두 번째 줄에 `GV_PC_TOKEN`을 입력해 줘.

그다음 두 속성의 타입을 다음과 같이 설정해야 해.

| 속성명 | ABAP 타입 | Auto |
| --- | --- | --- |
| `GV_PC_HTML` | `STRING` | 체크 해제 |
| `GV_PC_TOKEN` | `STRING` | 체크 해제 |

현재 캡처에는 속성명과 내역만 보이고 타입 열은 오른쪽으로 가려져 있어. 하단 가로 스크롤을 오른쪽으로 이동해서 타입도 확인해 줘.

## 3. 다음 진행 순서

1. `GV_PC_TOKEN` 추가
2. 두 속성 모두 `STRING` 타입인지 확인
3. 저장 (`Ctrl + S`)
4. 구문 검사
5. 오류가 없다면 활성화 (`Ctrl + F3`)

단, 속성을 선언하는 것과 실제 토큰값을 설정하는 것은 별개야. 이후 `OnInitialization`에서 요청 토큰을 어떻게 받아 `STATUS_HTML`에 전달하는지도 확인해야 해.

우선 `GV_PC_TOKEN`을 추가한 다음 구문 검사해 봐.

오류가 사라지면 `Event Handler → OnInitialization` 소스를 보여줘. 그다음에는 인증토큰 전달과 진행내역 표시가 제대로 연결됐는지 확인하자.

## ess4-t027-u1 · 사용자

**## H. 실제 테스트 — 우선 이 순서**

테스트마다 원본 번호와 요청 번호를 기록하고 `docs/approved_connect/SAP_TESTS.md` 표를 작성하세요.

1. 현재 월 또는 회사 규정상 변경 가능한 날짜에 연차 2일을 승인받습니다. 실제 잔여를 0일로 만든 테스트 사원을 사용합니다.
2. 승인 원본 선택 → 결재후변경신청 → 한 날짜 체크 해제, 같은 공제 기간의 새 날짜 선택 → 사유 입력 → 저장합니다.
3. ****저장/상신만 했을 때 PA2001 원본과 실제 사용량이 그대로인지**** 확인합니다. 요청 저장 한 줄과 날짜별 진행 내역이 보이는지 확인합니다.
4. R1 결재 페이지에서 승인합니다. 완료 후 기존 날짜 삭제·새 날짜 생성, ZHR2016 사용량 동일, 이력/진행 내역 DONE을 확인합니다.

승인시 오류가 이렇게 나네

## ess4-t027-a1 · AI

확인했어. 이번 오류는 H 단계의 기승인 변경신청을 결재자가 승인하는 과정에서 발생한 연차 검증 오류야.

캡처에 나온 메시지는 다음과 같아.

> 결재 처리 0/1건 완료.
> 00001021987: 사용가능한 휴무일수가 없습니다. 반려 처리 후 신청자에게 확인하세요.

여기서 중요한 건 실제 잔여 연차가 0일인 테스트 사원이라는 점이야.

## 1. 현재 가장 의심되는 원인

이번 테스트는 기존에 승인된 연차 2일 중 하루를 다른 날짜로 옮기는 작업이지?

예를 들어 다음과 같아.

| 구분 | 기존 승인 | 변경 승인 후 |
| --- | --- | --- |
| 10월 19일 | 연차 1일 | 연차 1일 |
| 10월 20일 | 연차 1일 | 취소 |
| 10월 21일 | 없음 | 연차 1일 |
| 총 사용량 | 2일 | 2일 |
| 잔여 연차 | 0일 | 0일 |

이 경우 같은 연차 공제 기간 안에서 변경한다면 추가 연차가 필요하지 않아.

그런데 승인 과정에서 신규 신청처럼 잔여 연차가 1일 이상 있어야 한다고 검사하면 지금과 같은 오류가 발생할 수 있어.

즉, 가장 의심되는 원인은 다음이야.

기승인 변경 요청인데도 기존 승인분을 차감하지 않고 신규 연차 신청처럼 잔여일수를 검증하는 것.

다만 현재 오류 메시지만으로 정확히 어느 함수에서 발생했는지는 확정할 수 없어.

## 2. 확인해야 할 처리 흐름

R1 결재 페이지 승인

app_va_list_r1.kbs

ZCL_HR_GUN_R1_PC → DECIDE

기승인 변경·취소 결재 처리

VALIDATE → HR_APPLY / FINALIZE

원본 사용량 반영 및 실제 근태 처리

이 흐름은 의도된 R1 처리 구조야. 실제 오류가 이 경로에서 발생했는지, 아니면 기존 일반 결재 검증 경로에서 발생했는지 확인해야 해.

## 3. 지금 확인할 것

우선 SAP에서 다음 두 곳을 확인하자.

① `ZCL_HR_GUN_R1_PC` → `DECIDE`

이 메서드는 R1 변경 요청의 결재를 처리하는 진입점이야. `VALIDATE`, `FINALIZE`를 호출하는 위치와 오류 메시지를 반환하는 부분을 확인해야 해.

② `ZHR_GUN_GULJAE_R1`

이 함수가 R1 변경 요청을 `DECIDE`로 분기시키는지 확인해야 해.

만약 기존 일반 연차 승인 로직을 먼저 실행한다면, 잔여 연차가 0일인 상태에서 오류가 발생할 수 있어.

## 4. 지금은 재승인하지 마

이번 테스트에서는 실제 근태와 연차 사용량이 변경됐는지 확인하기 전까지 같은 건을 반복 승인하지 않는 게 좋아.

먼저 `PA2001`, `ZHR2016`, `ZTGUNR1H`의 처리 상태가 승인 전과 동일한지 확인해야 해. 특히 화면에 `0/1건 완료`라고 표시됐다고 해서 DB 변경이 전혀 없었다고 단정할 수는 없어.

### 다음으로 필요한 소스

`ZHR_GUN_GULJAE_R1` 함수에서 `ZCL_HR_GUN_R1_PC=>DECIDE`를 호출하는 부분과 그 앞뒤 코드를 보여줘.

해당 호출이 없다면 함수의 결재 승인 분기 전체를 보내줘.

그걸 기준으로 기존 일반 연차 승인 검증이 먼저 실행되는지 확인하고, 원본 승인분을 고려하는 R1 처리 경로로 정확하게 연결해 줄게.

현재 단계에서는 `PA2001`이나 `ZHR2016` 데이터를 수동 수정하지 말고, 결재 분기부터 확인하는 게 안전해.

## ess4-t028-u1 · 사용자

FUNCTION ZHR_GUN_GULJAE_R1.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(ZSERIAL) TYPE  ZWF0022-KEY12
*"     VALUE(GULJAE) TYPE  CHAR1
*"     VALUE(SAYU) TYPE  ZTHR0080-ZSAYU OPTIONAL
*"     VALUE(ZWI_ID) TYPE  ZSWW_WIID
*"  EXPORTING
*"     VALUE(MSG) TYPE  STRING
*"----------------------------------------------------------------------
  DATA: s_msg(1), t_msg type string.

* Start-Add / XA32762 / GNT-R1-013
CLEAR: s_msg, t_msg, msg.
FREE MEMORY ID 'ZHR_GUN_R1_RESULT'.
DATA lv_v2_detail TYPE string.
FREE MEMORY ID 'ZHR_GUN_R1_ERROR'.
* End-Add / XA32762 / GNT-R1-013
* Start-Add / XA32762 / GNT-R1-U22 / 2026-10-12 / connect01
  DATA: lv_pc_found TYPE char1, lv_pc_reason TYPE string.
  lv_pc_reason = sayu.
  zcl_hr_gun_r1_pc=>decide( EXPORTING i_serial = zserial i_decision = guljae
    i_wiid = zwi_id i_reason = lv_pc_reason
    IMPORTING e_found = lv_pc_found e_message = msg ).
  IF lv_pc_found = 'X'. RETURN. ENDIF.
* End-Add / XA32762 / GNT-R1-U22
  SUBMIT zrpth_gun_guljae_r1
         WITH zserial EQ zserial
         WITH guljae EQ guljae
         WITH zsayu EQ sayu
         WITH zwi_id EQ zwi_id
         AND RETURN.

  IMPORT msg = s_msg FROM MEMORY ID 'ZHR_GUN_R1_RESULT'.
  FREE MEMORY ID 'ZHR_GUN_R1_RESULT'.

* Start-Add / XA32762 / GNT-R1-013
IMPORT detail = lv_v2_detail FROM MEMORY ID 'ZHR_GUN_R1_ERROR'.
FREE MEMORY ID 'ZHR_GUN_R1_ERROR'.
* End-Add / XA32762 / GNT-R1-013
  CASE s_msg.
    WHEN 'T'.
      t_msg = 'T'.
    WHEN  'A'.
      t_msg = ' 해당 결재건이 존재 하지 않습니다. 다시 확인 하신 후 결재하세요'.
    WHEN  'B'.
      t_msg = ' 사용가능한 휴무일수가 없습니다. 반려 처리 후 신청자에게 확인하세요 '.
    WHEN 'D'.
      t_msg = ' 해당 건이 이미 회수처리 되었습니다'.
    WHEN 'F'.
      t_msg = '시스템 작업 중으로  사원번호 잠금상태입니다.  \n\n  1~2시간 경과 후 다시 결재해 주세요. '.
    WHEN 'E'.
      t_msg = '승인, 반려 구분을 다시 선택하신 후 결재하세요'.
    WHEN 'G'.
      t_msg = '코비스 데이터 저장중 에러 발생. 담당자에게 문의하세요 '.
    WHEN 'H'.
      t_msg = '근태데이터 저장중 에러발생. 담당자에게 문의하세요 '.
    WHEN 'I'.
      t_msg = '휴무데이터 저장중 에러발생. 담당자에게 문의하세요 '.
    WHEN 'P'.
      t_msg = '상신기간이 지났습니다. 담당자에게 문의하세요  '.
* Start-Add / XA32762 / GNT-R1-013
    WHEN 'W'.
      t_msg = '워크플로우 처리에 실패했습니다. 재승인 전 근태·결재 상태를 대조하세요.'.
    WHEN OTHERS.
      t_msg = '결재 결과를 확인하지 못했습니다. 재시도 전 처리 상태를 확인하세요.'.
* End-Add / XA32762 / GNT-R1-013
  ENDCASE.

DATA IT_T569V LIKE T569V.

  IF s_msg = 'F' OR   s_msg = 'H' OR s_msg = 'I' OR s_msg ='B'  OR s_msg ='G'.

    SELECT   *   FROM   T569V INTO  CORRESPONDING  FIELDS OF IT_T569V
    WHERE ABKRS = 'S1'
    AND PABRJ = sy-datum(4)
    AND  NOT ( STATE =  '2' OR STATE = '3' ) .    "수정 릴리즈 상태
    ENDSELECT.

    IF sy-subrc = 0.
      MOVE 'J' TO msg.  "" return 값 추가 - 급여작업 진행시
       t_msg = '급여 작업 정산 중으로 시스템 수정이 불가능합니다.  \n\n  1~2시간 경과 후 다시 결재해 주세요. '.
   ENDIF.
ENDIF.

* Start-Add / XA32762 / GNT-R1-013
IF lv_v2_detail IS NOT INITIAL.
  CONCATENATE t_msg lv_v2_detail INTO t_msg SEPARATED BY space.
ENDIF.
* End-Add / XA32762 / GNT-R1-013
      MOVE t_msg TO msg.

    ENDFUNCTION.

…

## ess4-t028-a1 · AI

소스 확인했어. 이번 오류의 원인을 상당히 좁혔어.

결론부터 말하면, `ZHR_GUN_GULJAE_R1` 함수에는 R1 전용 승인 처리 분기가 이미 정상적인 순서로 들어가 있어.

그런데 실제 승인 결과가 기존 일반 근태 승인 프로그램에서 발생하는 오류 메시지로 나오고 있어.

## 1. 현재 소스 분석

핵심은 이 부분이야.

```
zcl_hr_gun_r1_pc=>decide(
  EXPORTING
    i_serial   = zserial
    i_decision = guljae
    i_wiid     = zwi_id
    i_reason   = lv_pc_reason
  IMPORTING
    e_found    = lv_pc_found
    e_message  = msg ).

IF lv_pc_found = 'X'.
  RETURN.
ENDIF.
```

이후 기존 승인 프로그램을 실행하고 있어.

```
SUBMIT zrpth_gun_guljae_r1
       WITH zserial EQ zserial
       WITH guljae EQ guljae
       WITH zsayu EQ sayu
       WITH zwi_id EQ zwi_id
       AND RETURN.
```

즉, 현재 구조는 다음과 같아.

`ZHR_GUN_GULJAE_R1`

`ZCL_HR_GUN_R1_PC=>DECIDE`

E_FOUND = 'X'

R1 전용 처리 후 RETURN

E_FOUND ≠ 'X'

기존 일반 승인 프로그램 실행

## 2. 오류 메시지의 출처도 확인됐어

화면에 나타났던 메시지:

> 사용가능한 휴무일수가 없습니다. 반려 처리 후 신청자에게 확인하세요.

이 메시지는 네가 보내준 함수의 아래 코드와 정확히 일치해.

```
WHEN 'B'.
  t_msg = ' 사용가능한 휴무일수가 없습니다. 반려 처리 후 신청자에게 확인하세요 '.
```

따라서 이번 실행에서는 R1 전용 처리에서 RETURN하지 않고, 기존 일반 승인 처리 경로까지 진행됐을 가능성이 매우 높아.

다만 `DECIDE`가 실제로 `E_FOUND`를 무엇으로 반환했는지는 아직 확인하지 못했어.

## 3. 가장 의심되는 문제

R1 변경·취소 신청을 `DECIDE`가 제대로 식별하지 못했을 가능성이 있어.

예를 들어 `DECIDE` 내부에서 `ZTGUNR1H`를 신청번호로 조회할 때 다음과 같은 문제가 있을 수 있어.

- `ZTGUNR1H`에 해당 변경 요청이 저장되지 않음
- `ZTGUNR1H-ZSERIAL`과 결재 화면에서 전달한 `ZSERIAL`이 일치하지 않음
- `DECIDE`의 조회 조건이 실제 저장 데이터와 다름

이 중 어느 것인지는 실제 데이터를 확인해야 해.

## 4. 지금은 함수를 수정하지 말자

특히 아래 코드를 무조건 변경하면 안 돼.

```
IF lv_pc_found = 'X'.
  RETURN.
ENDIF.
```

이를 강제로 `RETURN`하도록 바꾸면 일반 근태 승인까지 차단될 수 있어.

또한 지금 단계에서는 연차 검증을 우회하거나 `PA2001`, `ZHR2016`을 직접 수정해서는 안 돼.

## 5. 다음 확인 작업

먼저 `SE16N`에서 `ZTGUNR1H` 테이블을 조회해 줘.

이번에 승인하려던 변경 신청 건을 찾아서 아래 필드값을 확인하면 돼.

| 필드 | 확인할 내용 |
| --- | --- |
| `RID` | 변경·취소 요청 ID가 존재하는지 |
| `PERNR` | 테스트 사원번호 |
| `ZSERIAL` | 변경 신청의 결재번호 |
| `PHASE` | 현재 처리 단계 |
| `DECISION` | 승인·반려 처리값 |
| `LAST_ERROR` | 오류 메시지 저장 여부 |

가장 중요한 것은 `ZSERIAL`과 `PHASE`야.

`ZTGUNR1H`에 해당 건이 없다면 저장 단계부터 확인해야 하고, 해당 건이 존재한다면 `DECIDE`의 조회 조건을 확인해야 해.

우선 `SE16N → ZTGUNR1H` 조회 결과를 캡처해서 보여줘.

그러면 R1 승인 분기가 왜 실행되지 않았는지 확인하고, 필요한 경우 `DECIDE` 메서드의 정확한 수정 위치와 전체 소스를 만들어줄게.

## ess4-t029-u1 · 사용자



## ess4-t029-a1 · AI

확인했어. 지금 보여준 화면은 SE11의 `ZTGUNR1H` 테이블 구조 화면이야.

테이블이 활성화되어 있고, 우리가 설계했던 필드들도 등록되어 있는 것이 보여.

다만 이 화면은 테이블에 실제 저장된 데이터를 보여주는 화면이 아니야. 그래서 앞서 발생한 결재 오류의 원인을 아직 확인할 수 없어.

## 1. 현재 확인된 사항

| 항목 | 확인 결과 |
| --- | --- |
| `ZTGUNR1H` 테이블 | 활성화 상태 |
| `RID`, `ZSERIAL`, `PHASE` | 필드 존재 |
| `LAST_ERROR` | 필드 존재 |
| 실제 변경·취소 신청 데이터 | 미확인 |
| R1 결재 분기 실행 여부 | 미확인 |

한 가지 참고할 점은 `ERDAT`, `ERZET`의 화면상 길이가 각각 0으로 표시된다는 거야. 날짜·시간 타입의 내부 길이 표기일 수 있으므로, 이것만으로 테이블 오류라고 판단할 필요는 없어.

## 2. 이제 실제 데이터를 조회하자

① SAP 명령창에 `SE16N` 입력

테이블 내용 조회 화면으로 이동해.

② 테이블명 입력

`ZTGUNR1H`

③ 조회 조건 입력

가능하면 이번 테스트 사원의 `PERNR`을 입력하고 실행(F8)해. 다른 조건은 우선 비워둬.

④ 조회 결과 확인

아래 필드가 보이도록 화면을 캡처해 줘.

`RID`, `PERNR`, `ZSERIAL`, `PHASE`, `DECISION`, `LAST_ERROR`

## 3. 조회 결과에 따라 다음 작업이 달라져

| 조회 결과 | 다음 확인 대상 |
| --- | --- |
| 데이터가 0건 | `SAVE_PLAN`에서 이력 저장 여부 |
| 데이터가 있고 `ZSERIAL`이 공란 | `BIND_SERIAL` 및 결재번호 연결 |
| 데이터가 있고 `ZSERIAL`이 정상 | `DECIDE`의 요청 식별 조건 |
| `LAST_ERROR`에 오류 존재 | 해당 오류를 발생시킨 검증·처리 메서드 |

특히 지금은 기존 승인 로직으로 잘못 진입했는지 확인하는 것이 우선이야. 잔여 연차가 0일이라는 이유만으로 검증 로직을 수정하면 다른 신청에 영향을 줄 수 있어.

SE16N에서 조회한 결과 화면을 보여줘. 데이터가 0건이어도 그대로 알려줘. 그 결과에 맞춰 다음 수정 위치를 결정하자.

아직 `PA2001`, `ZHR2016` 데이터는 직접 변경하지 마.

## ess4-t030-u1 · 사용자



## ess4-t030-a1 · AI

확인했어. 이번 SE16N 화면에서 승인 오류의 핵심 원인으로 의심되는 부분을 찾았어.

현재 `ZTGUNR1H`에 데이터가 1건 존재하지만, 결재번호 `ZSERIAL`이 `000000000000`이고 처리 단계가 `SAVED` 상태야.

## 1. 실제 데이터 분석

| 필드 | 현재 값 | 판단 |
| --- | --- | --- |
| PERNR | `00032762` | 테스트 사원 |
| OBEGDA ~ OENDDA | 2026/11/03 ~ 11/05 | 기존 승인 기간 |
| ORIG_SER | `000010211986` | 기존 승인 신청번호 |
| RBEGDA ~ RENDDA | 2026/11/03 ~ 11/05 | 변경 대상 기간 |
| RSEQNR | `001` | 변경 대상 레코드 |
| ZSERIAL | `000000000000` | 연결 안 됨 |
| PHASE | `SAVED` | 저장 단계 |
| WI_ID | `000000000000` | 워크플로우 작업 ID 없음 |
| REASON | `테스트` | 사유 저장됨 |
| LAST_ERROR | 공란 | 기록된 오류 없음 |

## 2. 왜 승인 오류가 발생했을까?

앞서 보여준 `ZHR_GUN_GULJAE_R1` 함수에는 다음 분기가 있었지.

```
zcl_hr_gun_r1_pc=>decide(
  EXPORTING
    i_serial   = zserial
    i_decision = guljae
    i_wiid     = zwi_id
    i_reason   = lv_pc_reason
  IMPORTING
    e_found    = lv_pc_found
    e_message  = msg ).

IF lv_pc_found = 'X'.
  RETURN.
ENDIF.
```

현재 이력 테이블의 `ZSERIAL`이 0이므로, 결재 화면에서 전달한 신청번호와 매칭되지 않아 `DECIDE`가 R1 변경 요청을 찾지 못했을 가능성이 높아.

그 결과 기존 일반 승인 프로그램으로 넘어가면서 잔여 연차 부족 메시지가 발생했을 수 있어.

다만 `DECIDE` 내부 조회 조건은 아직 확인하지 않았으므로 확정은 아니야.

## 3. 다음 작업은 `BIND_SERIAL` 확인이야

정상적으로 연결된 변경·취소 요청이라면 결재 상신 시 다음 흐름이 필요해.

변경·취소 요청 저장

PHASE = SAVED

결재 상신 및 결재번호 연결

BIND_SERIAL / AFTER_ACTION 확인 필요

R1 전용 결재 처리

DECIDE → VALIDATE → HR_APPLY

## 4. 지금은 이것부터 확인하자

SAP `SE24`에서 다음 메서드를 열어줘.

`ZCL_HR_GUN_R1_PC` → `BIND_SERIAL`

해당 메서드의 전체 소스를 보내줘.

그 소스를 확인하면 결재번호가 언제, 어떤 조건으로 `ZTGUNR1H-ZSERIAL`에 기록되도록 되어 있는지 분석할 수 있어.

그다음에는 `ZHR_SAVE_GUN_R1`에서 `BIND_SERIAL`을 호출하는 부분을 확인하자.

중요: 현재 데이터의 `ZSERIAL`을 SE16N 등으로 임의 수정하지 마. 결재번호는 실제 워크플로우와 일치해야 하므로 저장·상신 연결 로직에서 해결해야 해.

현재까지의 판단은 신청 저장은 됐지만 R1 결재번호 연결이 누락됐을 가능성이 높다는 것이야. 이 부분을 먼저 해결하고 H 단계 테스트를 이어가자.

## ess4-t031-u1 · 사용자

METHOD bind_serial.
    IF is_request-zserial IS INITIAL. RETURN. ENDIF.
    UPDATE ztgunr1h SET zserial = is_request-zserial WHERE pernr = is_request-pernr
      AND rbegda = is_request-begda AND rendda = is_request-endda AND rseqnr = is_request-seqnr
      AND phase = 'STARTING'.
    "This is flushed by the existing INSERT_KOBIS commit, before it inserts rows.
  ENDMETHOD.

## ess4-t031-a1 · AI

확인했어. `BIND_SERIAL` 메서드를 보니 결재번호가 연결되지 않은 원인을 더 좁힐 수 있어.

현재 메서드에는 중요한 조건이 두 가지 있어.

## 1. 현재 소스 분석

```
METHOD bind_serial.
  IF is_request-zserial IS INITIAL.
    RETURN.
  ENDIF.

  UPDATE ztgunr1h
    SET zserial = is_request-zserial
    WHERE pernr  = is_request-pernr
      AND rbegda = is_request-begda
      AND rendda = is_request-endda
      AND rseqnr = is_request-seqnr
      AND phase  = 'STARTING'.
ENDMETHOD.
```

이 코드는 다음 조건을 모두 만족해야 `ZSERIAL`을 업데이트해.

1. `IS_REQUEST-ZSERIAL`에 결재번호가 있어야 함.
2. `ZTGUNR1H`에 사번·신청 시작일·종료일·레코드번호가 일치하는 행이 있어야 함.
3. 해당 행의 `PHASE`가 반드시 `STARTING`이어야 함.

그런데 앞서 확인한 실제 DB 데이터는 다음과 같았지.

| 필드 | 현재 값 |
| --- | --- |
| `PERNR` | `00032762` |
| `RBEGDA` | `2026/11/03` |
| `RENDDA` | `2026/11/05` |
| `RSEQNR` | `001` |
| `ZSERIAL` | `000000000000` |
| `PHASE` | `SAVED` |

현재 상태가 `SAVED`이므로, 지금 이 행에 `BIND_SERIAL`을 실행하더라도 `PHASE = 'STARTING'` 조건에서는 업데이트되지 않아.

단, 정상적인 상신 흐름에서는 `BEFORE_ACTION`이 먼저 `STARTING`으로 변경했어야 할 수 있어. 따라서 `BIND_SERIAL` 자체가 잘못됐다고 단정할 수는 없어.

## 2. 현재 가장 의심되는 구간

SAVE_PLAN

변경 요청 저장 → SAVED

BEFORE_ACTION

상신 전 검증 및 STARTING 전환 여부 확인

BIND_SERIAL

결재번호 연결 → ZSERIAL 업데이트

AFTER_ACTION

상신 결과 반영 및 상태 변경

이 순서는 확인해야 할 의도된 흐름이며, 실제 호출 순서는 아직 검증되지 않았어.

## 3. 지금은 `BIND_SERIAL`을 수정하지 말자

특히 아래 조건을 임의로 제거하면 안 돼.

```
AND phase = 'STARTING'.
```

이 조건을 없애면 저장만 된 요청이나 이미 처리된 요청까지 결재번호가 연결될 위험이 있어.

또한 `BIND_SERIAL`은 `UPDATE`의 성공 여부(`sy-dbcnt`)를 반환하지 않기 때문에, 호출한 쪽에서 실제 업데이트 성공을 확인하기 어려운 구조라는 점도 확인됐어.

## 4. 다음으로 필요한 소스

`ZCL_HR_GUN_R1_PC` 클래스의 `BEFORE_ACTION` 메서드 전체 소스를 보내줘.

우선 다음 세 가지를 확인할 거야.

- `SAVED → STARTING` 상태 전환이 실제로 구현되어 있는지
- `BEFORE_ACTION`이 결재 상신 전에 호출되도록 설계되어 있는지
- 현재 저장된 요청과 매칭하는 조건이 올바른지

그다음 `ZHR_SAVE_GUN_R1`의 호출부까지 확인해서 결재번호가 누락되는 정확한 지점을 찾자.

현재로서는 `BIND_SERIAL`의 조건 자체보다, 상신 시 상태 전환 또는 메서드 호출 연결이 빠졌을 가능성을 우선 확인하는 게 맞아.

## ess4-t032-u1 · 사용자

METHOD before_action.
    DATA: ls_h TYPE ztgunr1h, ls_original TYPE zthr0080, lt_after TYPE tt_gun,
          lt_hr TYPE tt_hr, lt_pools TYPE tt_pools, lv_error TYPE string, lv_owner TYPE persno.
    CLEAR: e_found, es_return.
    SELECT SINGLE * INTO ls_h FROM ztgunr1h WHERE pernr = is_request-pernr
      AND rbegda = is_request-begda AND rendda = is_request-endda AND rseqnr = is_request-seqnr.
    IF sy-subrc <> 0. RETURN. ENDIF.
    e_found = 'X'.
    lv_owner = sy-uname.
    IF ls_h-pernr <> lv_owner.
      es_return-type = 'E'. es_return-message = '본인의 요청만 처리할 수 있습니다.'. RETURN.
    ENDIF.
    IF ( i_action = 'KULJAE' OR i_action = 'DEL' ) AND ls_h-phase <> 'SAVED'.
      es_return-type = 'E'. es_return-message = '요청 상태가 변경되었습니다. 변경·취소 진행 내역을 확인하세요.'. RETURN.
    ENDIF.
    IF i_action = 'RETR' AND ls_h-phase <> 'WAIT'.
      es_return-type = 'E'. es_return-message = '결재 대기 상태에서만 회수할 수 있습니다.'. RETURN.
    ENDIF.
    IF i_action <> 'KULJAE' AND i_action <> 'DEL' AND i_action <> 'RETR'.
      es_return-type = 'E'. es_return-message = '일자별 변경 요청은 삭제 후 승인 원본에서 다시 작성하세요.'. RETURN.
    ENDIF.
    IF i_action <> 'KULJAE'. RETURN. ENDIF.
    IMPORT original = ls_original after_rows = lt_after FROM DATABASE ztgunr1s(pc) ID ls_h-rid.
    IF sy-subrc <> 0. es_return-type = 'E'. es_return-message = '변경 계획이 없습니다.'. RETURN. ENDIF.
    validate( EXPORTING is_before = ls_original it_after = lt_after is_header = ls_h i_persk = ls_h-persk
      IMPORTING et_hr = lt_hr et_pools = lt_pools e_error = lv_error ).
    IF lv_error IS NOT INITIAL. es_return-type = 'E'. es_return-message = lv_error. RETURN. ENDIF.
    UPDATE ztgunr1h SET phase = 'STARTING' WHERE rid = ls_h-rid AND phase = 'SAVED'.
    IF sy-subrc <> 0 OR sy-dbcnt <> 1.
      es_return-type = 'E'. es_return-message = '이미 상신 처리가 시작되었습니다.'. RETURN.
    ENDIF.
    EXPORT original = ls_original after_rows = lt_after hr_before = lt_hr pools = lt_pools
      TO DATABASE ztgunr1s(pc) ID ls_h-rid.
    IF sy-subrc <> 0.
      ROLLBACK WORK. es_return-type = 'E'. es_return-message = '상신 계획 저장 실패입니다.'. RETURN.
    ENDIF.
    "No local commit: shared workflow start owns its documented commit.
  ENDMETHOD.

…

## ess4-t032-a1 · AI

확인했어. 이번 `BEFORE_ACTION` 소스를 보니 `SAVED → STARTING` 상태 변경 로직은 정상적으로 구현되어 있어.

따라서 지금은 `BEFORE_ACTION` 자체를 수정하기보다, 실제 결재상신 과정에서 이 메서드가 호출되고 있는지 확인해야 해.

## 1. BEFORE_ACTION 분석 결과

| 확인 항목 | 결과 |
| --- | --- |
| 변경·취소 요청 조회 | 구현됨 |
| 본인 요청 여부 검증 | 구현됨 |
| `SAVED` 상태 확인 | 구현됨 |
| 기존 승인 근태 검증 (`VALIDATE`) | 구현됨 |
| `SAVED → STARTING` 변경 | 구현됨 |
| 변경 계획 클러스터 저장 | 구현됨 |
| 자체 COMMIT | 없음 — 기존 결재 처리에 위임 |

핵심 코드는 이 부분이야.

```
UPDATE ztgunr1h
  SET phase = 'STARTING'
  WHERE rid = ls_h-rid
    AND phase = 'SAVED'.
```

정상적인 상신 흐름에서 이 코드가 성공하면 `ZTGUNR1H-PHASE`는 `STARTING`으로 변경돼야 해.

그런데 앞서 조회한 실제 데이터는 다음과 같았어.

현재 DB 상태

## SAVED

ZSERIAL = 000000000000

정상 상신 시 예상

## STARTING

이후 결재번호 연결

즉, `BEFORE_ACTION`이 호출되지 않았거나, 검증 과정에서 반환됐거나, 상태 변경 후 트랜잭션이 롤백됐을 가능성이 있어.

## 2. 추가로 발견한 확인 사항

현재 코드에는 다음 부분이 있어.

```
lv_owner = sy-uname.

IF ls_h-pernr <> lv_owner.
  es_return-type = 'E'.
  es_return-message = '본인의 요청만 처리할 수 있습니다.'.
  RETURN.
ENDIF.
```

여기서 `LS_H-PERNR`는 사번이고 `SY-UNAME`은 SAP 사용자 ID야.

두 값이 동일하게 운영되는 시스템이라면 문제없지만, 서로 다르다면 정상 사용자도 본인 요청 검증에서 차단될 수 있어.

이 부분은 실제 사용자 ID와 사번 매핑을 확인해야 해. 지금 당장 제거하지는 말자.

## 3. 다음으로 확인할 대상

현재까지 확인한 흐름은 다음과 같아.

SAVE_PLAN

요청 저장 — 확인됨

BEFORE_ACTION

SAVED → STARTING — 코드 존재, 실행 여부 미확인

ZHR_SAVE_GUN_R1

실제 상신 호출 연결 확인 필요

BIND_SERIAL

결재번호 연결 — 코드 존재, 실행 여부 미확인

## 4. 이제 이 소스를 보여줘

`ZHR_SAVE_GUN_R1` 함수 전체에서 아래 호출 부분을 찾아서 보내줘.

```
zcl_hr_gun_r1_pc=>before_action(
```

그리고 다음 호출도 확인해야 해.

```
zcl_hr_gun_r1_pc=>bind_serial(
```

두 호출이 없다면 `ZHR_SAVE_GUN_R1`의 전체 소스를 보내줘.

이걸 보면 다음을 확인할 수 있어.

- 상신 전에 `BEFORE_ACTION`이 호출되는지
- 검증 실패 시 기존 상신 처리를 중단하는지
- 결재번호 생성 후 `BIND_SERIAL`이 실행되는지
- 상태 변경과 결재번호 연결이 동일한 트랜잭션에서 처리되는지

현재까지는 `BEFORE_ACTION`과 `BIND_SERIAL`의 내부 로직보다, 이 두 메서드를 실제 상신 과정에 연결하는 부분이 핵심 의심 지점이야.

기존 근태 승인 로직은 건드리지 않고 R1 전용 연결부터 확인하자.

## ess4-t033-u1 · 사용자

두 호출이 없어서 그냥 전체 소스 보낼게

## ess4-t033-a1 · AI

첨부해 준 `ZHR_SAVE_GUN_R1` 전체 소스 470줄을 확인했어.

예상했던 대로 `BEFORE_ACTION`과 `BIND_SERIAL` 호출이 모두 빠져 있어. 다만 단순히 두 메서드를 아무 위치에나 추가하면 기존 결재상신까지 영향을 받을 수 있어서, 정확한 연결 위치를 구분해야 해.

## 1. 현재 소스 분석 결과

| 항목 | 확인 결과 |
| --- | --- |
| `ZCL_HR_GUN_R1_PC` 클래스 | 앞서 생성 완료 |
| `BEFORE_ACTION` 호출 | 없음 |
| `BIND_SERIAL` 호출 | 없음 |
| 결재상신 분기 `KULJAE` | 존재 |
| `KULJAE_DATA` 실행 | 존재 |
| `INSERT_KOBIS` 실행 | 존재 |
| R1 전용 요청 구분 | 추가 확인 필요 |

현재 결재상신은 다음과 같이 처리되고 있어.

```
WHEN 'KULJAE'.
  ...
  PERFORM kuljae_data
    CHANGING g_list o_return.

  IF o_return-type <> 'E'
     AND o_return-type <> 'A'
     AND o_return-type <> 'X'.

    PERFORM insert_kobis
      CHANGING g_list o_return.

  ENDIF.
```

이 부분은 첨부 소스의 341~368행에 해당해.

붙여넣은 마크다운.md

즉, 기존 상신 처리만 실행하고, R1 변경·취소 요청의 상태를 연결하는 처리가 누락된 상태야.

## 2. 수정 방향

R1 전용 요청에만 아래 처리가 추가돼야 해.

① BEFORE_ACTION

R1 요청 검증 및 SAVED → STARTING

② KULJAE_DATA

기존 결재상신 데이터 처리

③ INSERT_KOBIS

결재 문서 생성 및 번호 연결

④ BIND_SERIAL

생성된 결재번호를 ZTGUNR1H에 연결

여기서 중요한 점이 하나 있어.

앞서 보여준 `BIND_SERIAL`은 `PHASE = 'STARTING'`인 요청만 업데이트해. 따라서 `BEFORE_ACTION`이 정상 완료되지 않으면 결재번호 연결도 실패할 수 있어.

또한 `INSERT_KOBIS` 내부에서 COMMIT이 발생한다면, 결재번호 연결을 그 이후에 실행하는 것은 트랜잭션 관점에서 안전하지 않을 수 있어.

## 3. 다음 작업 전에 딱 하나만 더 확인하자

현재 `ZHR_SAVE_GUN_R1` 전체 소스는 확보했으니 다시 보낼 필요 없어.

대신 함수 그룹 `ZHR008`에서 다음 두 FORM의 전체 소스를 보내줘.

- `FORM KULJAE_DATA`
- `FORM INSERT_KOBIS`

특히 `INSERT_KOBIS`에서 `G_LIST-ZSERIAL`을 언제 생성하고 `COMMIT WORK`를 언제 실행하는지가 중요해.

이 두 소스를 확인하면 기존 결재상신 로직을 유지하면서 R1 전용으로 `BEFORE_ACTION`과 `BIND_SERIAL`을 연결하는 수정본을 만들어줄게.

기존에 사용하던 `Start-Add / XA32762 / GNT-R1-U22` 주석 스타일을 유지하고, 어느 부분에 붙여 넣어야 하는지도 정확히 표시하겠어.

현재는 승인·근태·연차 사용량에 영향을 주는 구간이므로, 호출 두 개만 임의로 추가해서 테스트하는 것은 피하는 게 좋아.

## ess4-t034-u1 · 사용자

응 그렇게 해줘

## ess4-t034-a1 · AI

**`ZHR_SAVE_GUN_R1` 전체 교체용 수정본을 만들었어.** 보관된 `connect01` 적용본과 대조해서 누락된 연결을 복구했고, 기존 주석은 유지하면서 수정 구간에 `XA32762 / GNT-R1-U22` 주석을 넣었어.

**이번에 적용할 대상은 E3의 `ZHR_SAVE_GUN_R1` 함수 한 개야.** E4의 `ZHR_GUN_GULJAE_R1`에 붙여 넣으면 안 돼. README에서도 두 함수를 별도 적용 대상으로 구분하고 있어.

## 1. 수정본

**`R1_CONNECT_RESTORE_20261014_XA32762.zip`**

첫 번째 파일은 일부 코드가 아니라 **`FUNCTION ZHR_SAVE_GUN_R1.`부터 `ENDFUNCTION.`까지 포함한 전체본**이야. 묶음 파일에는 적용 안내서, 변경 전후 비교, 원본 확인 근거와 검사 결과도 넣었어.

## 2. 무엇을 수정했는지

보내준 현재 소스는 상신 분기에서 `KULJAE_DATA`와 `INSERT_KOBIS`를 실행하지만, 그 사이에 R1 결재번호를 연결하는 호출이 없어. 함수 마지막의 `AFTER_ACTION` 호출도 빠져 있어.

이번 수정본에는 다음 연결을 복구했어.

| 수정 부분 | 적용 위치 | 역할 |
| --- | --- | --- |
| `BEFORE_ACTION` | `CASE GUBUN` 진입 전 | R1 요청을 찾아 사전 검증하고, 상신 시 `SAVED → STARTING` 전환 |
| 일반 신청과 R1 요청 분기 | `WHEN 'KULJAE'` 내부 | 일반 신청은 기존 검증·매핑을 유지하고, R1 요청은 사전 검증한 계획을 사용 |
| `BIND_SERIAL` | `KULJAE_DATA` 다음, `INSERT_KOBIS` 직전 | 생성된 결재번호를 `ZTGUNR1H`에 연결 |
| `AFTER_ACTION` | `ENDCASE` 다음 | 실제 신청 DB와 처리 결과를 확인해 R1 상태 갱신 |

**앞서 내가 `BIND_SERIAL`을 `INSERT_KOBIS` 뒤에 적었던 순서는 정정할게.** 보관된 원본을 확인하니 `KULJAE_DATA`에서 결재번호를 받아오고, `INSERT_KOBIS` 초반에는 내부 `COMMIT WORK`가 있어. 따라서 복구한 순서는 아래와 같아.

```
BEFORE_ACTION
    ↓
KULJAE_DATA
    ↓
BIND_SERIAL       ← 이 위치
    ↓
INSERT_KOBIS
    ↓
AFTER_ACTION
```

이 근거는 묶음 파일의 `SOURCE_REVIEW.md`에 원본 행 번호와 함께 넣었어. 다만 확인한 FORM은 **보관된 원본**이며, 현재 SAP 활성 소스를 직접 조회한 것은 아니야.

## 3. SAP 적용 방법

1. **SE37 → `ZHR_SAVE_GUN_R1` → 변경 → 소스 코드**로 들어가.
2. 현재 SAP 소스를 먼저 백업한 다음, 위 전체 함수 소스로 교체해.
3. 저장 → 구문 검사 → 오류가 없으면 활성화해.

`FUNCTION`과 `ENDFUNCTION`을 편집할 수 있는 전체 소스 화면에서는 전체를 교체하면 돼. 시작·끝이 자동으로 고정된 본문 편집 화면이라면 파일의 첫 줄과 마지막 줄을 제외하고 넣어야 해. **함수 시작·종료 선언을 중복해서 넣지 않는 것이 중요해.**

이번에는 **`LZHR008F01`이나 공통 FORM을 수정하지 않고, `ZCL_HR_GUN_R1_PC` 클래스도 다시 덮어쓰지 않아.** 앞서 해결한 클래스의 타입 호환성 수정은 그대로 유지하면 돼.

## 4. 기존 오류 건은 바로 재승인하지 마

**소스 연결을 복구하는 것과 이미 상신된 오류 건을 정리하는 것은 별도야.**

앞서 조회한 건은 결재함에 문서가 있는데도 R1 이력은 `SAVED`, `ZSERIAL = 000000000000`으로 남아 있었지. 이번 소스를 적용한다고 그 행에 기존 결재번호가 자동으로 채워지지는 않아.

따라서 그 건은 바로 재승인·재상신하거나 `PHASE`와 `ZSERIAL`을 수동 변경하지 말고, 실제 신청·결재 상태부터 대조해야 해. 기존 안내서 역시 불확실한 상태에서 데이터를 임의로 고쳐 재시도하지 않도록 하고 있어.

이번 파일은 **16개 소스 정합성 검사를 통과했고, 주석을 제외한 실행 코드가 보관된 `connect01` E3 적용본과 일치하는 것도 확인했어.** 다만 SAP 구문 검사·활성화·실제 상신 및 승인 시험은 여기서 실행하지 않았어.

**수정본 적용·활성화 후, SE16N → `ZTHR0080`에서 `PERNR=00032762`, `BEGDA=20261103`, `ENDDA=20261105`, `SEQNR=001`로 조회한 결과를 보여줘.** `ZSERIAL`, `ZSERIAL2`, `ZSANGSIN`, `ZACCEPT`, `STATE`가 보이면 돼. 그 결과를 기준으로 이미 상신된 오류 건의 정리 절차를 이어가자.

ZHR_SAVE_GUN_R1_CONNECT_RESTORE_20261014.txt문서

## ess4-t035-u1 · 사용자

그럼 지금 잔여 연차 0인데, 다시 취소하고 새로운 연차 신청부터 하라는 말인가 ?

## ess4-t035-a1 · AI

아니야. **이미 승인된 연차를 취소하고, 신규 연차를 처음부터 다시 신청하라는 뜻은 아니야.** 내가 “오류 건 정리”라고 표현해서 헷갈리게 했어.

## 원래 승인된 연차는 그대로 유지하는 거야

지금 구분해야 하는 건 **원래 승인된 연차**와 **그 연차를 바꾸려고 추가로 만든 변경신청**이야.

| 구분 | 지금 어떻게 해야 하는지 |
| --- | --- |
| **원래 승인된 연차** | **그대로 유지. 취소하거나 다시 신청하지 않음.** |
| **오류가 발생한 변경신청·결재 건** | 실제 신청·결재 상태를 확인한 뒤, 이 요청의 연결을 어떻게 정리할지 판단 |
| **일반 신규 연차 신청** | 지금 다시 할 작업이 아님 |

이번 안내서도 **변경신청을 저장·상신하는 동안에는 원래 승인된 근태와 실제 사용량을 유지하고, 변경신청이 승인될 때 실제 근태를 바꾸는 구조**야.

## 잔여 0일에서도 날짜를 바꾸려고 만드는 기능이 맞아

예를 들어 다음 상황을 처리하려는 거야.

```
현재
  기존 승인 연차 사용량: 2일
  잔여 연차: 0일

변경 요청
  기존 2일 중 하루를 다른 날짜로 이동
  같은 연차 공제 기간 안에서 총사용량 2일 유지

변경 승인 후 목표
  승인된 날짜만 변경
  연차 사용량: 2일 유지
  잔여 연차: 0일 유지
```

**원래 연차를 취소해서 잔여를 먼저 만든 다음 새로 신청하는 방식이 아니야.** 같은 공제 기간에서 원본 사용량을 인정하고, 변경 후 사용량과 다른 미결 신청 등을 검증하는 것이 이번 R1 설계야. 다만 지금은 오류를 해결하면서 실제 승인까지 검증하는 단계야.

## 지금 해야 하는 것은 ‘새 신청’이 아니라 ‘오류 난 변경요청 확인’이야

앞서 본 상태는 **결재함에는 변경신청 문서가 있는데, R1 이력에는 결재번호가 연결되지 않고 `SAVED`로 남아 있는 상태**였어. 그래서 소스를 고쳤더라도 **이미 만들어진 이 변경요청이 자동으로 복구됐다고 볼 수는 없어.**

내가 요청한 `ZTHR0080` 조회는 이 변경요청의 실제 결재번호와 상태를 확인하기 위한 거야. 확인 결과에 따라 기존 변경요청의 연결 복구를 검토하거나, 필요하다면 **오류 난 변경요청만 회수·정리한 뒤 같은 승인 원본에서 변경신청을 다시 작성**하는 방향을 판단해야 해. 아직 회수를 실행하라는 뜻은 아니야.

**지금은 원래 승인된 연차도, 오류 난 변경신청도 취소하지 말고 그대로 둬. 앞서 요청한 `ZTHR0080` 조회 결과만 보여주면 돼. 원본 연차를 취소해서 잔여를 확보하는 방식으로 진행하지 않을 거야.**

## ess4-t036-u1 · 사용자



## ess4-t036-a1 · AI

파일 확인했어. **이번 자료에서는 원래 연차는 승인 상태이고, 그 연차를 바꾸려고 만든 변경신청 2건은 모두 반려 상태로 기록되어 있어.**

따라서 **원래 승인된 연차를 취소하거나 신규 연차를 처음부터 신청할 필요는 없어.** 또 지금 확인된 두 변경신청을 ‘결재 대기 중인 건’으로 보고 회수부터 진행해서도 안 돼.

## 1. 파일에서 확인한 실제 상태

첨부한 `근태실적.xls`의 **`Sheet1` 15~17행**을 대조했어. 아래 사번·순번·결재번호는 SAP에서 비교하기 쉽도록 앞자리 0을 채워 표시했어.

| 확인 항목 | 원래 승인된 연차 | 첫 번째 변경신청 | 두 번째 변경신청 |
| --- | --- | --- | --- |
| 사번 `PERNR` | `00032762` | `00032762` | `00032762` |
| 시작일~종료일 | 2026/11/03~11/05 | 2026/11/03~11/05 | 2026/11/03~11/05 |
| 순번 `SEQNR` | `000` | `001` | `002` |
| 결재번호 `ZSERIAL` | **`000010211986`** | **`000010211987`** | **`000010211988`** |
| 연결 원본 `ZSERIAL2` | 초기값 | `000010211986` | `000010211986` |
| 처리 구분 `STATE` | `0` | `D` | `D` |
| 구분 설명 `STATE_TXT` | 신청 | 일자별 변경 | 일자별 변경 |
| 승인 상태 `ZACCEPT` | **`Y` — 승인** | **`N` — 반려** | **`N` — 반려** |
| 상신 표시 `ZSANGSIN` | `X` | `X` | `X` |

`Y=승인`, `N=반려`라는 해석은 앞서 보내준 함수의 상태 변환 코드에서도 확인돼. **`ZSANGSIN=X`만 보고 아직 결재 대기라고 판단하면 안 되고, `ZACCEPT`도 함께 봐야 해.**

참고로 실제 대상 원본의 `SILSU`는 **3.0**이야. 앞에서 설명한 ‘연차 2일’은 예시였고, 이번 파일에 있는 원본은 11월 3~5일 건이야. 다만 이 신청 기록의 일수만으로 실제 연차 차감량이나 잔여를 다시 계산하지는 않을게.

## 2. 이제 확인할 문제는 ‘반려된 변경신청과 R1 이력이 맞는가’야

현재까지 확인한 내용을 구분하면 다음과 같아.

**이번 파일의 신청 기록**

```
원본 000010211986 → 승인(Y)
변경 000010211987 → 반려(N)
변경 000010211988 → 반려(N)
```

**이전에 보여준 R1 이력**

```
RSEQNR = 001
ZSERIAL = 000000000000
PHASE = SAVED
```

**R1 이력이 지금도 저 상태라면, 신청 기록에서는 이미 반려됐는데 R1 진행 내역은 아직 ‘저장’에 머물러 있는 불일치가 있는 거야.** 다만 이전 캡처와 이번 파일은 확인 시점이 다르므로, 최신 R1 이력까지 조회해야 확정할 수 있어.

또한 이번 파일에서 확인한 것은 **신청 기록상 원본의 승인 상태가 유지된다는 것**이야. 실제 `PA2001` 근태와 `ZHR2016` 사용량이 변경되지 않았는지는 이 파일에 없어서 아직 확정할 수 없어.

## 3. 다음은 두 테이블을 조회만 하면 돼

이미 반려로 기록된 변경신청을 다시 승인하거나, `PHASE`를 임의로 바꾸지 말고 아래 두 결과를 대조하자.

| SE16N 조회 테이블 | 조회 조건 | 확인할 열 |
| --- | --- | --- |
| **`ZTGUNR1H`** | `PERNR = 00032762` / `ORIG_SER = 000010211986` | `RID`, `RSEQNR`, `ZSERIAL`, `PHASE`, `DECISION`, `LAST_ERROR` |
| **`ZTHR0080_KOBIS`** | `PERNR = 00032762` / `KEY12`에 `000010211986`, `000010211987`, `000010211988` 다중 선택 | `KEY12`, `STATE`, `STATE_TXT`, `ZACCEPT` |

첫 번째 조회에서는 **`PHASE` 조건을 넣지 말고**, 이 원본에 연결된 이력을 모두 조회해 줘. 두 번째는 신청 테이블의 반려 표시와 결재 연동 기록이 일치하는지 확인하려는 거야.

**이 두 조회 결과를 한 번에 보내줘. 이미 올린 근태실적 파일은 다시 보낼 필요 없어. 지금은 원본 연차를 그대로 유지하면서, 반려된 변경요청과 R1 이력의 상태부터 맞춰 확인하는 단계야.**

## ess4-t037-u1 · 사용자



## ess4-t037-a1 · AI

두 화면 확인했어. **두 번째 화면에서 사번 `32762`가 `PERNR`이 아니라 맨 위 `ZSERIAL` 칸에 들어가 있어.** `PERNR`은 비어 있고. 따라서 지금의 **‘0건’만으로 결재 연동 데이터가 없다고 판단하면 안 돼.** 조회 조건부터 바로잡으면 돼.

## 1. 첫 번째 화면에서는 필요한 내용을 확인했어

`ZTGUNR1H`의 두 요청 모두 아래 상태로 남아 있어.

| 변경요청 순번 `RSEQNR` | 결재번호 `ZSERIAL` | 처리 단계 `PHASE` |
| --- | --- | --- |
| `001` | `000000000000` | `SAVED` |
| `002` | `000000000000` | `SAVED` |

즉, **R1 이력에는 두 건 모두 저장 상태이고, 결재번호가 연결되지 않은 것**이 확인됐어. 첫 번째 테이블은 다시 보내지 않아도 돼.

## 2. 두 번째 화면의 조회 조건만 이렇게 바꿔줘

현재 팝업을 **닫기**로 닫은 다음, `ZTHR0080_KOBIS` 선택 화면에서 아래처럼 입력해.

| 화면의 필드 | 입력할 값 |
| --- | --- |
| **`ZSERIAL` — 맨 위 칸** | **현재 `32762`를 지우고 공란으로 둠** |
| **`PERNR` — 바로 아래 칸** | **`00032762`** |
| `BEGDA` | 공란 |
| `ENDDA` | 공란 |
| `KEY12` | 아래 결재번호 3개를 다중 선택으로 입력 |

**`KEY12` 오른쪽의 노란색 다중 선택 버튼**을 눌러, 단일값 입력란에 다음 번호를 한 줄씩 넣어줘.

```
000010211986
000010211987
000010211988
```

첫 번째는 원본 결재번호이고, 나머지 두 개는 확인하려는 변경신청 결재번호야.

입력한 값을 적용하고 선택 화면으로 돌아온 뒤 **실행(F8)** 해줘. 이번에는 **엔트리 수 팝업이 아니라 실제 데이터 목록**에서 `KEY12`, `STATE`, `STATE_TXT`, `ZACCEPT`를 확인하면 돼.

**지금 하는 것은 데이터 수정이 아니라 조회 조건 수정이야. 원래 승인된 연차나 변경신청은 아직 취소하지 말고, 이 조건으로 조회한 `ZTHR0080_KOBIS` 결과만 보여줘.**

## ess4-t038-u1 · 사용자

이거 다시 조회한 거야 . 이제 제대로 잘 나오네 ㅇㅇ

## ess4-t038-a1 · AI

응. **이번 파일에는 확인하려던 원본 1건과 변경신청 2건이 모두 조회됐어.**

대조 결과, **신청 테이블과 결재 연동 테이블의 승인·반려 표시는 서로 일치해. 그런데 R1 처리 이력은 두 변경신청 모두 여전히 `SAVED`로 남아 있는 상태야.** 조회는 제대로 됐지만, 이력 연결 문제까지 해결된 것은 아니야.

## 1. 이번 파일에서 확인한 내용

첨부한 `zthr0080_kobis.xls`의 **`Sheet1` 2~4행**을 확인했어. 결재번호는 SAP에서 비교하기 쉽도록 앞자리 0을 채워 표시했어.

| 구분 | 결재번호 `KEY12` | 연결 원본 `KEY12_2` | 승인 상태 `ZACCEPT` |
| --- | --- | --- | --- |
| **원래 승인된 연차** | `000010211986` | 초기값 | **`Y` — 승인** |
| 첫 번째 변경신청 | `000010211987` | `000010211986` | **`N` — 반려** |
| 두 번째 변경신청 | `000010211988` | `000010211986` | **`N` — 반려** |

이 결과는 앞서 보낸 `근태실적.xls`의 **`Sheet1` 15~17행**과도 일치해. 두 변경신청의 처리 시각도 각각 **11:15:02, 11:16:32**로 두 파일에서 같아.

참고로 이번 파일에서는 세 건 모두 `STATE=A`, `STATE_TXT=신청`으로 표시돼. **이 표시만 보고 변경신청이 아직 결재 대기 중이라고 판단하면 안 돼.** 같은 행의 `ZACCEPT`에는 두 변경신청 모두 `N`이 기록되어 있어.

## 2. 이제 불일치가 확인된 부분은 R1 처리 이력이야

앞서 보여준 `ZTGUNR1H`에서는 순번 `001`, `002`가 모두 **결재번호 초기값 + `PHASE=SAVED`**였어.

따라서 지금까지 대조한 상태는 다음과 같아.

```
변경신청 000010211987 / 000010211988

ZTHR0080        : 반려(N)
ZTHR0080_KOBIS  : 반려(N)
ZTGUNR1H       : 저장(SAVED), 결재번호 미연결
```

**즉, 반려로 기록된 변경신청과 R1 진행 이력이 서로 맞지 않는 거야.** 앞서 확인한 상신 연결 호출 누락과 부합하는 결과야. 다만 이 자료만으로 SAP 워크플로의 실제 종료 상태나 `PA2001`·`ZHR2016`의 변경 여부까지 확인한 것은 아니야.

또 한 가지 중요한 구분이 있어. **이번 `ZTHR0080_KOBIS` 파일에서 결재문서번호는 `KEY12`야.** 이 테이블의 `ZSERIAL` 값인 `1775250`, `1775251`, `1775252`를 R1 이력의 결재번호로 연결하면 안 돼.

## 3. 다음 작업은 원본 연차 취소가 아니라, 반려된 변경요청의 이력 정리야

**원래 승인된 `000010211986`은 그대로 유지해. 잔여 연차를 만들기 위해 원본을 취소하거나 일반 신규 연차를 다시 신청할 필요는 없어.**

진행 순서는 아래처럼 잡으면 돼.

1. **앞서 제공한 상신 연결 수정본이 활성화됐는지 확인**
  이후 만들어지는 변경신청에서도 같은 누락이 반복되지 않도록 먼저 확인해야 해.
2. **기존 반려 건 `000010211987`, `000010211988`의 R1 이력 정리**
  원본·요청 연결과 실제 결재 종료 상태를 검증한 뒤, R1 이력에도 반려 결과를 반영하는 보정이 필요해. 지금 화면에서 `PHASE`나 결재번호를 수동으로 바꾸지는 마.
3. **정리 후 같은 승인 원본에서 변경신청 한 건으로 재시험**
  일반 신규 연차 신청이 아니라 **‘결재후변경신청’**이야. 이번에는 상신 직후 `ZTGUNR1H`에 **새 결재번호가 연결되고 `PHASE=WAIT`인지 먼저 확인한 다음** 승인 시험으로 넘어가야 해. 안내서에서도 `WAIT`는 결재 대기, `REJECT`는 반려 상태로 구분하고 있어.

**앞서 준 `ZHR_SAVE_GUN_R1_CONNECT_RESTORE_20261014.txt` 수정본은 SAP에 적용하고 활성화까지 끝낸 상태야?** 지금 추가로 확인할 것은 그 적용 여부야. 이번에 올린 두 테이블 자료는 다시 보내지 않아도 돼.

## ess4-t039-u1 · 사용자

ㅇㅇ 적용 / 활성화 했어

## ess4-t039-a1 · AI

좋아. **상신 연결 수정본 적용·활성화는 완료됐고, 다음은 기존 반려 건의 R1 이력을 정리하기 전 점검이야. 원래 승인된 연차는 그대로 유지해.**

이번에는 여러 테이블을 따로 조회하지 않도록, **두 변경신청의 결재 상태와 근태·연차 데이터를 한 번에 확인하는 조회 전용 프로그램**을 준비했어.

## 1. 이번 프로그램은 데이터를 바꾸지 않아

이미 제공한 자료에서 변경신청 `000010211987`, `000010211988`은 신청 테이블과 KOBIS 연동 테이블 모두 반려로 확인됐어.

아직 확인되지 않은 것은 **실제 워크플로 작업도 종료됐는지**, 그리고 **원본 근태와 연차 사용량이 저장 당시 상태와 같은지**야. 이를 확인하지 않고 R1 이력만 `REJECT`로 바꾸지는 않을 거야.

이번 프로그램에는 **데이터 수정·삭제, 결재 재실행, 연차 차감·복원 기능이 없어.** 실행해도 기존 반려 건이 자동으로 보정되지는 않아.

## 2. 적용할 파일

**`README_REJECT_CHECK_EASY.md`** · **`R1_REJECT_CHECK_20261014_XA32762.zip`**

**기존 `ZHR_SAVE_GUN_R1`이나 `ZCL_HR_GUN_R1_PC`에 붙여 넣는 파일이 아니야.** SE38에서 별도의 점검용 프로그램으로 등록하면 돼.

## 3. SAP에서는 이렇게 진행해

### ① SE38에서 프로그램 생성

| 항목 | 입력값 |
| --- | --- |
| 프로그램명 | **`ZHR_GUN_R1_REJECT_CHECK`** |
| 내역 | `R1 반려 변경요청 이력 보정 전 점검` |
| 유형 | 실행 가능 프로그램 |

위 **전체 소스 파일**을 열어 프로그램 소스로 적용한 다음, **저장 → 구문 검사 → 활성화**해. 자동으로 생성된 `REPORT` 문장이 중복되지 않도록 전체를 교체하면 돼.

같은 이름의 프로그램이 이미 있다면 바로 덮어쓰지 말고 기존 내용을 확인해.

### ② F8로 실행

다음 값들이 기본으로 들어가도록 작성했어.

| 화면 필드 | 의미 | 값 |
| --- | --- | --- |
| `P_PERNR` | 테스트 사번 | `00032762` |
| `P_ORIG` | 원래 승인된 결재번호 | `000010211986` |
| `P_KEY1` | 첫 번째 반려 변경신청 | `000010211987` |
| `P_KEY2` | 두 번째 반려 변경신청 | `000010211988` |

**기본값을 확인하고 다시 F8을 누르면 두 건을 차례로 조회해.** KOBIS 자체 번호인 `1775251`, `1775252`를 넣는 것이 아니야.

## 4. 이 결과로 확인할 내용

프로그램은 실제 결재선·워크플로 작업·대기 목록을 조회하고, R1 이력과 저장된 스냅샷을 읽어 **현재 원본 신청·`PA2001`·`ZHR2016`과 비교**해.

비교 결과가 다르더라도 곧바로 데이터가 손상됐다는 뜻은 아니야. 다른 정상 처리 때문에 달라졌을 수도 있으므로, 결과를 보고 구분해야 해.

**지금은 원본 연차 취소, 새로운 변경신청, 기존 반려 건 재승인을 하지 말고 이 점검만 실행해 줘.** 불확실한 단계에서 근태·연차 데이터나 `PHASE`를 임의로 바꾸지 않는다는 기존 적용 원칙도 그대로 유지해.

프로그램의 데이터 갱신 구문 유무와 소스 구조는 확인했지만, **실제 SAP 구문 검사와 실행은 아직 하지 않았어.** 구문 오류가 있으면 실행 전에 해당 오류부터 확인해야 해.

**실행 결과에서 두 문서의 출력 전체를 텍스트나 캡처로 보내줘. 그 결과를 기준으로 기존 반려 건의 R1 이력만 보정하는 절차를 확정하자.**

ZHR_GUN_R1_REJECT_CHECK_20261014.txt문서README_REJECT_CHECK_EASY.md문서

## ess4-t040-u1 · 사용자



## ess4-t040-a1 · AI

확인했어. **두 변경신청은 반려로 기록되어 있고, 조회된 상위·대화형 워크플로 작업도 모두 `COMPLETED`야. 다만 표준 근태의 저장 당시 값과 현재 값이 다르다는 결과가 있어, 지금 바로 R1 이력을 보정하거나 재시험으로 넘어가지는 말자.**

**원래 승인된 연차를 취소할 필요는 없어.** 이제 확인할 것은 **“저장 당시 근태와 현재 근태에서 정확히 어떤 필드가 다른가”**야.

## 1. 이번 결과로 확인된 사항

두 문서 `000010211987`, `000010211988`에서 공통으로 확인됐어.

| 점검 항목 | 결과 | 현재 판단 |
| --- | --- | --- |
| 신청·KOBIS의 결재 상태 | 두 건 모두 `N` | 반려로 기록됨 |
| 조회된 상위·대화형 작업 | 모두 `COMPLETED` | 조회된 작업은 완료 상태 |
| 조회된 대기 목록 | `SWWUSERWI`, 상위 작업의 `ZWFORGTASK` 모두 0건 | 해당 조회 범위에 대기 기록 없음 |
| 원본 신청 비교 | `ORIGINAL_APPLICATION_EQUAL=YES` | 원본 신청 행은 저장 당시와 동일 |
| 연차 데이터 비교 | `QUOTA_FULL_ROW_EQUAL=YES` | 비교한 연차 행은 저장 당시와 동일 |
| R1 처리 이력 | `SAVED`, 결재번호 초기값 | 반려 결과·결재번호 연결이 여전히 누락됨 |

이 결과는 **신청·결재 쪽의 반려 상태와 R1 처리 이력이 어긋나 있다는 기존 판단을 뒷받침해.** 다만 R1 이력만 고치기 전에 아래 근태 차이를 확인해야 해.

## 2. 아직 확인이 필요한 부분

### `ORIGINAL_HR_EQUAL=NO`의 의미

두 건 모두 다음과 같이 나왔지.

```
SAVED_HR_ROWS=1
CURRENT_HR_ROWS=1
ORIGINAL_HR_EQUAL=NO
```

이것은 **저장된 근태 1행과 현재 조회한 근태 1행의 전체 값이 일치하지 않았다는 뜻**이야. 점검 프로그램은 기간·유형·일수만 비교하는 것이 아니라, 현재 `PA2001`을 `P2001` 형식으로 읽어 저장된 행과 전체 비교하고 있어. 따라서 이 결과만으로 **“원본 근태가 삭제됐다”거나 “연차가 추가 차감됐다”라고 판단할 수는 없어.**

현재 출력에는 **11월 3~5일, 유형 `1021`, `SEQNR=000`, `KALTG=3.00`인 근태 1건**이 보이고, 연차는 발생 20일·사용 20일로 나와. 하지만 이 주요 값이 보인다고 해서 다른 필드까지 모두 그대로라고 확정할 수는 없어.

### 두 번째 문서의 `EXTRA_HR_IN_PLAN`도 구분해야 해

이 표시는 **현재 조회한 근태 중 저장 스냅샷에서 동일한 식별키를 찾지 못한 행**을 출력하는 코드야. **근태가 새로 한 건 생성됐다는 판정은 아니야.** 어떤 키나 값이 다른지 확인해야 해.

**내가 준 첫 점검본은 `NO`만 표시하고 차이 난 필드명을 출력하지 않았어. 그 부분을 보완해서, 이번에는 저장값과 현재값을 직접 비교할 수 있게 했어.**

## 3. 필드별 차이가 나오는 점검본으로 한 번 더 확인하자

`README_CHECK02_EASY.md` · `R1_REJECT_CHECK02_20261014_XA32762.zip`

**새 프로그램을 만들 필요는 없어.** 방금 실행한 **`ZHR_GUN_R1_REJECT_CHECK`**의 소스만 교체하면 돼.

1. **SE38 → `ZHR_GUN_R1_REJECT_CHECK` → 변경**에서 현재 소스를 백업하고, 위 전체 수정본으로 교체해.
2. **저장 → 구문 검사 → 오류가 없으면 활성화**해.
3. **기존과 동일한 사번·원본번호·변경신청번호로 실행**해.

이번에는 기존 8번 아래에 **`8A. HR KEYS AND FIELD DIFFERENCES`**가 추가돼.

| 새 출력 항목 | 의미 |
| --- | --- |
| `SAVED_ROW_INDEX` / `CURRENT_ROW_INDEX` | 저장 당시·현재 행의 식별키와 주요 값 |
| `DIFF_FIELD` | 서로 다른 필드명 |
| `SAVED_VALUE` | 저장 당시 값 |
| `CURRENT_VALUE` | 현재 값 |
| `PAIR_MODE=UNMATCHED_SINGLE_ROW_PAIR` | 양쪽이 각각 1건이지만 키가 달라, 원인 확인용으로 나란히 비교한 경우 |

**이번에도 조회 전용이야.** 근태·연차·결재 상태나 스냅샷을 수정하지 않고, 특정 필드를 지우거나 무시해서 억지로 일치시키지도 않아. 기존 R1 함수·클래스는 다시 변경하지 않아.

## 4. 저장된 변경 계획도 한 가지 짚고 갈게

이번 출력의 저장 계획은 다음과 같아.

| 문서 | 저장된 변경 후 기간 | 저장된 사용량 계산 |
| --- | --- | --- |
| `000010211987` | 11월 3~4일 | 기존 3일 → 변경 후 2일 |
| `000010211988` | 11월 4~5일 | 기존 3일 → 변경 후 2일 |

즉, **이번 두 요청에 저장된 계획은 ‘3일을 유지하면서 날짜만 이동’하는 내용이 아니라, 3일 중 하루를 제외하여 2일로 줄이는 내용**이야. 이것은 저장된 계획이며 실제 승인 반영 결과는 아니야.

소스 구조와 비교 로직의 로컬 점검은 했지만, 새 점검본의 **SAP 구문 검사·실행은 아직 하지 않았어.**

**실행 후 두 문서 각각의 `8. STANDARD HR SNAPSHOT COMPARISON`부터 `9. QUOTA SNAPSHOT COMPARISON` 바로 전까지 보내줘.** 새 8A의 필드별 차이를 보면, 다음 보정에서 무엇을 건드리지 말아야 하는지 구체적으로 판단할 수 있어.

ZHR_GUN_R1_REJECT_CHECK02_20261014.txt문서README_CHECK02_EASY.md문서

## ess4-t041-u1 · 사용자



## ess4-t041-a1 · AI

확인했어. **이번 결과로 `ORIGINAL_HR_EQUAL=NO`가 나온 이유는 정확히 확인됐어. 날짜·일수 차이가 아니라, 첫 번째 건은 `DOCNR`, 두 번째 건은 `DOCNR`과 표준 근태의 `SEQNR`이 달라서야.** 다만 이 차이를 무시하고 “원본이 완전히 그대로다”라고 처리해서는 안 돼.

**원래 승인된 연차는 계속 유지해. 지금 확인할 것은 연차를 다시 신청할지가 아니라, 이 근태 레코드의 식별 정보가 왜 달라졌는지야.**

## 1. 실제로 다른 값은 이 세 가지야

아래 `DOCNR`은 읽기 쉽도록 앞자리 0을 생략했어.

| 변경신청 문서 | 다른 필드 | 저장 당시 | 현재 |
| --- | --- | --- | --- |
| `000010211987` | `DOCNR` | `29340142001` | `29340212001` |
| `000010211988` | **`SEQNR`** | **`001`** | **`000`** |
| `000010211988` | `DOCNR` | `29340192001` | `29340212001` |

첫 번째는 **같은 식별키의 행에서 85개 필드 중 `DOCNR` 한 개가 다르고**, 두 번째는 **식별키가 다른 두 행을 나란히 비교했을 때 `SEQNR`·`DOCNR` 두 개가 다른 결과**야. 두 번째 비교는 “같은 레코드임을 확인했다”는 의미가 아니야.

여기의 **`SEQNR`은 `PA2001` 표준 근태 레코드의 순번**이야. 변경신청의 순번인 `ZTGUNR1H-RSEQNR=001/002`와 혼동하면 안 돼. 점검 소스도 표준 근태의 `SEQNR`까지 포함해 동일한 키인지 검사하고 있어.

## 2. 현재 근태와 연차 사용량은 이렇게 확인됐어

두 결과에서 현재 조회된 근태는 **2026년 11월 3~5일, 유형 `1021`, `KALTG=3.00`, 1건**이야. 원본 신청 행은 저장 당시와 같고, 비교한 `ZHR2016` 행도 발생 **20일**, 사용 **20일**로 저장 당시와 같아. **현재 확인한 연차 행의 잔여는 여전히 0일이야.**

따라서 현재 자료에서는 **“3일짜리 원본 근태가 없어졌다”거나 “사용량이 20일을 넘어 추가 차감됐다”는 결과는 나오지 않았어.** 하지만 이것과 **“중간에 근태 레코드가 수정·삭제·재생성된 적이 없다”는 것은 다른 이야기**야. 이번 비교만으로는 변경 주체와 원인을 알 수 없어.

두 번째 건의 `EXTRA_HR_IN_PLAN=1`도 같은 이유로 이해하면 돼. 저장된 키는 `SEQNR=001`, 현재 키는 `000`이라 동일한 키를 찾지 못한 것이지, **이 숫자 자체가 현재 중복 근태 1건이 있다는 뜻은 아니야.**

## 3. 지금은 이 값들을 억지로 맞추지 않을 거야

**`PA2001-SEQNR`이나 `DOCNR`을 저장 당시 값으로 돌려놓거나, 스냅샷을 현재 값으로 덮어쓰는 수정은 하지 마.** 그러면 무엇이 달라졌는지 확인할 근거까지 사라져.

R1 이력이 아직 `SAVED`이고 결재번호가 비어 있는 문제는 남아 있지만, 그것을 정리하는 것과 **표준 근태의 변경 경위를 확인하는 것은 구분해서 처리해야 해.**

## 4. 다음은 새 점검 프로그램 대신, SAP 변경이력을 확인하자

이제 필드별 비교 프로그램을 또 만들 필요는 없어. **SAP의 기존 인포타입 변경이력 보고서 `RPUAUD00`**에서 해당 근태의 생성·변경·삭제 기록을 확인하는 것이 다음 단계야. 이 보고서는 변경문서 기록 설정이 되어 있는 인포타입의 이력을 조회하는 표준 보고서야. [SAP 도움말 포털](https://help.sap.com/docs/HR_RENEWAL_SPV/28cb35be3518492c9ac9786bb7cf468d/dc39e153a217424de10000000a174cb4.html?utm_source=chatgpt.com)

**SE38 → `RPUAUD00` → 실행**한 뒤 다음 조건으로 조회해 줘.

| 조회 항목 | 입력값 |
| --- | --- |
| 문서 유형 | 장기 문서 / Long-term documents |
| 사번 | `00032762` |
| 인포타입 | `2001` |
| **변경일** | **`20261014`~`20261014`** |
| 사용자명 | 공란 — 특정 사용자로 제한하지 않음 |

여기서 **변경일은 테스트한 10월 14일**이야. 근태 적용 기간인 11월 3~5일을 입력하는 것이 아니야. 보고서에서는 사번·인포타입·변경일·사용자별로 기록을 조회할 수 있어. [SAP 도움말 포털](https://help.sap.com/docs/HR_RENEWAL_SPV/28cb35be3518492c9ac9786bb7cf468d/dc39e153a217424de10000000a174cb4.html?utm_source=chatgpt.com)

결과에서 **11월 3~5일 근태와 관련된 생성·변경·삭제 기록, 처리 시각, 처리 사용자**를 확인하면 돼. 단, 해당 인포타입의 변경문서 기록이 설정되어 있지 않았다면 결과가 없을 수 있고, **0건이라고 해서 변경이 없었다고 확정할 수는 없어.** [SAP 도움말 포털](https://help.sap.com/docs/HR_RENEWAL_SPV/28cb35be3518492c9ac9786bb7cf468d/dc39e153a217424de10000000a174cb4.html?utm_source=chatgpt.com)

**그 조회 결과를 보여줘. 기록이 없으면 0건이라고 알려주면 돼. 원본 연차 취소나 재신청 없이, 지금 확인된 `DOCNR`·`SEQNR` 차이의 발생 경로부터 판단하자.**

## ess4-t042-u1 · 사용자

조회가 안되는데 ?

## ess4-t042-a1 · AI

응. **사번·인포타입·변경일은 제대로 입력했어.** 지금 화면은 **‘장기 문서’만 선택한 상태에서 표시되는 변경이력이 없는 결과**야. 이것만으로 조회 방법이 틀렸다거나 근태 변경이 없었다고 판단하면 안 돼.

## 1. ‘단기 문서’도 함께 체크해서 한 번만 더 조회해 줘

앞에서 내가 **장기 문서만 안내했는데, 단기 문서도 포함해서 확인하는 게 맞아.** `RPUAUD00`는 장기·단기 변경문서를 구분해서 조회하므로, 지금 결과에는 단기 문서가 포함되지 않았어. [SAP 도움말 포털](https://help.sap.com/docs/SAP_S4HANA_ON-PREMISE/c6c3ffd90792427a9fee1a19df5b0925/dc39e153a217424de10000000a174cb4.html?utm_source=chatgpt.com)

첫 번째 화면으로 돌아가서 아래처럼 설정하면 돼.

| 항목 | 설정 |
| --- | --- |
| **장기 문서** | 체크 유지 |
| **단기 문서** | **추가로 체크** |
| 트랜잭션 클래스 | 마스터 자료 유지 |
| 사원 번호 | `32762` 유지 |
| 인포타입 | `2001` 유지 |
| 변경일 | `2026/10/14` 유지 |
| 변경자 | 공란 유지 |

그다음 **F8로 실행**해. 단기 문서에 반드시 기록이 있다는 뜻은 아니고, 현재 제외되어 있는 조회 범위까지 확인하는 거야.

여전히 빈 목록이면 결과 화면 위쪽의 **‘오류’ 버튼**을 눌러 별도 메시지가 있는지도 확인해 줘. 캡처에는 그 버튼은 보이지만, 내부 메시지는 보이지 않아.

## 2. 둘 다 조회해도 없을 수 있어

이 보고서는 **모든 `PA2001` 변경을 자동으로 추적하는 도구가 아니라, 당시 생성된 변경문서를 읽는 보고서**야. SAP 공식 문서에서도 변경문서를 남기려면 `V_T585A`, `V_T585B`, `V_T585C`에 대상 인포타입·필드 관련 설정이 필요하다고 설명해. 현재 회사 시스템에 그 설정이 되어 있는지는 아직 확인하지 않았어. [SAP 도움말 포털](https://help.sap.com/docs/SAP_S4HANA_ON-PREMISE/c6c3ffd90792427a9fee1a19df5b0925/dc39e153a217424de10000000a174cb4.html?utm_source=chatgpt.com)

따라서 **로그가 안 나온다고 해서 “변경되지 않았다”거나 “로깅 설정이 없다”고 바로 확정할 수는 없어.** SAP에서도 일부 변경이 보고서에 기록되지 않는 사례를 별도로 안내하고 있어. 다만 그 사례가 이번 원인이라고 확인된 것은 아니야. [SAP 지원 포털](https://userapps.support.sap.com/sap/support/knowledge/en/2909053?utm_source=chatgpt.com)

**이번 과거 이력을 찾기 위해 지금 로깅 설정부터 변경하지는 말자.** 당시 기록되지 않은 내용을 지금 설정하는 것만으로 복원할 수 있다고 볼 수는 없어.

## 3. 로그가 없어도 여기서 작업이 막히는 건 아니야

**변경이력 조회는 원인을 찾기 위한 보조 수단이야.** 장기·단기를 모두 확인해도 기록이 없다면 이 보고서 조회를 계속 반복하기보다, 기존 승인·반려 소스에서 **근태 삭제·재생성이 실행될 수 있는 경로**를 확인하는 쪽으로 넘어가야 해.

그전까지는 원래 승인된 연차를 취소하거나, `DOCNR`·`SEQNR`·R1 이력 상태를 수동으로 맞추지 말자.

**우선 단기 문서까지 포함한 결과를 알려줘. 여전히 0건이면 ‘오류’ 버튼에 별도 메시지가 있는지만 함께 알려주면 돼.**

## ess4-t043-u1 · 사용자

단기로만 했을때 이렇게 떠

## ess4-t043-a1 · AI

응. **단기 문서만 선택해도 결과가 없는 것으로 확인했어. `RPUAUD00` 조회는 여기서 마치자. 같은 조건으로 더 반복할 필요는 없어.** 이번에 확인된 것은 “이 조건으로 조회되는 변경문서가 없다”는 것이고, 근태가 변경되지 않았다는 뜻은 아니야.

그리고 첫 번째 화면의 오류는 내가 앞서 잘못 안내한 부분이야. **현재 화면에서는 `ALV에서 출력`을 선택하면 장기·단기 중 하나만 선택해야 하는데, 둘 다 체크하라고 안내했어.** 불필요하게 한 번 더 실행하게 해서 미안해.

## 1. 로그 대신 기존 소스를 확인했고, 중요한 처리 순서를 찾았어

보관된 누적 ZIP의 **`ZRPTH_GUN_GULJAE_R1` 승인 프로그램**을 직접 확인했어.

이 프로그램의 기존 변경신청 처리에는 **원본 근태를 삭제한 다음 연차를 다시 조회하는 순서**가 있어. 실제로 `WHEN 'D'`에서 `DELETE_INFOTYPE_2001`을 호출하고, 그 아래에서 `ZHR_ANNUAL_HOLIDAY`를 호출해.

또한 삭제 처리 내부에는 **표준 근태 삭제 API 호출 → 연차 사용량 복원 → `COMMIT WORK`**가 들어 있어. 즉, 최종 결재가 끝나기 전에 근태·연차 변경을 확정하는 구간이 존재해.

**따라서 최종적으로 반려됐다는 사실만으로, 그전에 오류가 났던 승인 시도에서도 근태를 전혀 건드리지 않았다고 단정할 수는 없어.**

다만 이것은 **소스에서 확인한 가능한 실행 경로**야. 이번 `DOCNR`·`SEQNR` 차이가 실제로 이 경로 때문에 발생했다고 확정한 것은 아니야.

## 2. 반려 처리 자체와, 그전에 실패한 승인 시도는 구분해야 해

보관본의 `WHEN 'N'` 반려 분기에는 신청·KOBIS의 반려 상태와 사유를 설정하는 코드가 있어. 이 분기 자체에 원본 근태 삭제 호출이 들어 있는 것은 아니야.

그래서 지금은 다음처럼 구분해서 보는 게 맞아.

| 구분 | 현재 판단 |
| --- | --- |
| 최종 반려 상태 | 앞서 신청·KOBIS·워크플로 결과로 확인 |
| 원본 기간·유형·일수와 연차 사용량 | 앞서 점검한 현재 값과 스냅샷 비교 결과 확보 |
| `DOCNR`·표준 근태 `SEQNR` 차이의 발생 원인 | **아직 미확정** |
| 우선 대조할 코드 | **오류가 났던 승인 시도에서 실행된 기존 승인 프로그램** |

**앞서 적용한 상신 연결 수정본이 과거 근태 변경을 되돌리거나, 기존 오류 건까지 자동으로 복구하는 것은 아니야.**

## 3. 다음은 현재 SAP의 활성 소스와 대조하자

이번에 내가 확인한 것은 **보관된 소스**야. 현재 SAP에 적용된 코드가 그 보관본과 같은지 확인해야 수정 범위를 정확히 정할 수 있어.

**SE38 → `ZRPTH_GUN_GULJAE_R1` → 조회**로 들어가서, **현재 활성 소스 전체를 텍스트 파일로 보내줘.**

이번 대상은 아래 프로그램이야.

```
ZRPTH_GUN_GULJAE_R1
```

앞서 수정한 함수 `ZHR_GUN_GULJAE_R1`이나 `ZHR_SAVE_GUN_R1`과는 다른 객체야. **프로그램을 F8로 실행하는 것이 아니라, 소스만 조회해서 가져오면 돼.** 보관본은 이미 확보했으니 현재 활성본만 있으면 대조할 수 있어.

**원래 승인된 연차는 취소하지 말고, 기존 두 변경신청도 재승인하지 않은 상태로 유지해. 이제 추가 로그 조회나 새 점검 프로그램 생성이 아니라, 실제 승인 코드 대조로 넘어가자.**

## ess4-t044-u1 · 사용자



## ess4-t044-a1 · AI

활성 소스 전체 확인했어. **이번에 보내준 `ZRPTH_GUN_GULJAE_R1`은 마크다운 표시용 문자와 공백을 정리한 뒤 보관본과 대조했을 때 2,159행이 일치했어. 이번 승인 레포트를 잘못 붙여 넣은 문제는 아니야.**

다만 **R1 변경요청이 전용 처리에서 인식되지 않고 이 일반 승인 레포트로 넘어왔을 때, 근태 처리 전에 막아주는 코드가 없어.** 이 부분을 보완한 **전체 교체용 소스**를 만들었어.

## 1. 이번 소스에서 확인한 중요한 문제

### 연차 부족 오류는 근태 생성 API를 호출한 뒤에도 발생할 수 있어

기존 변경신청 처리에는 다음 순서가 있어.

```
기존 변경신청 처리
    ↓
원본 신청 조회
    ↓
기존 근태 삭제 API 호출
    ↓
연차 사용량 복원 및 중간 COMMIT
    ↓
변경 기간의 근태 생성 API 호출
    ↓
연차 사용량·배정량 검사
    ↓
여기서도 'B — 사용가능한 휴무일수가 없습니다' 반환 가능
```

`WHEN 'D'`에서 원본 근태 삭제를 먼저 호출하고, 그다음 연차를 다시 조회하는 순서가 확인돼. 삭제 처리 내부에는 사용량을 복원한 뒤 `COMMIT WORK` 하는 구간도 있어.

더 중요한 것은 `INSERT_ZHR2016`이 **근태 생성 API를 호출한 다음**, 사용량을 계산하고 배정량을 초과하면 `B`를 반환한다는 점이야. **그 오류 분기 자체에는 `ROLLBACK WORK`가 없어.**

따라서 **“연차 부족 오류가 떴고 나중에 반려했으니, 그전 승인 시도에서도 근태는 전혀 건드리지 않았다”라고 볼 수는 없어.** 중간에 확정된 변경은 나중의 `ROLLBACK WORK`만으로 모두 되돌릴 수도 없어. SAP의 롤백은 현재 데이터베이스 처리 단위의 시작까지를 대상으로 하기 때문이야. [SAP 도움말 포털](https://help.sap.com/docs/SAP_NETWEAVER_702/fe24b0146c551014891ad42d6b2789e5/fceb3b64358411d1829f0000e829fbfe.html?utm_source=chatgpt.com)

다만 **이 코드가 존재한다는 것과, 과거 두 문서에서 정확히 이 경로가 실행됐다는 것은 구분해야 해.** 이번 소스만으로 `DOCNR`·`SEQNR` 변경의 실행 주체와 시점까지 확정한 것은 아니야.

## 2. 수정은 ‘연차 검증 우회’가 아니라 ‘잘못 들어온 처리 경로 차단’이야

이번에는 기존 근태 삭제·생성 순서를 임의로 재배치하거나, 잔여 0일 검사를 무조건 통과시키지 않았어.

**`ZTGUNR1H`에 등록된 R1 요청이라면, 일반 승인 레포트에서 처리하지 못하도록 앞단에 차단 검사를 추가했어.**

| 상황 | 수정본의 처리 |
| --- | --- |
| R1 이력과 연결되지 않은 일반 신청 | 기존 처리 경로 유지 |
| 래퍼 함수의 `DECIDE`에서 정상 처리된 R1 요청 | 이 레포트로 넘어오지 않으므로 이번 검사 대상이 아님 |
| R1 요청인데 이 일반 레포트까지 넘어온 경우 | **근태·연차 처리 전에 오류로 중단** |
| R1 이력의 결재번호가 아직 `000000000000`인 경우 | **사번·신청기간·신청순번으로도 찾아서 중단** |

결재번호만 검사하면 이번처럼 **번호가 연결되지 않은 요청을 또 놓칠 수 있어서, 신청키도 함께 검사**하도록 했어.

추가 위치는 기존 `PERFORM r1_before_hr.` 바로 앞이야. 그 위치는 이 레포트의 사원 잠금과 근태 처리보다 앞에 있어.

**이 보완은 앞으로 같은 경로로 잘못 처리되는 것을 막는 코드이지, 이미 반려된 두 건을 자동 복구하는 코드는 아니야.**

## 3. 적용할 전체 소스

`README_PC_GUARD01_EASY.md` · `R1_PC_GUARD01_20261014_XA32762.zip`

원래 소스와 주석은 유지하고, **`XA32762 / GNT-R1-U22 / pc-guard01` 주석으로 두 구간만 추가**했어. 묶음의 `PC_GUARD01_changes.diff`에서 추가 부분을 확인할 수 있어.

### SAP 적용 방법

1. **SE38 → `ZRPTH_GUN_GULJAE_R1` → 변경**으로 들어가서 현재 활성 소스를 백업해.
2. 위 **전체 교체용 소스**로 교체하고 저장해. `REPORT` 문장이 중복되지 않도록 해.
3. **구문 검사 → 오류가 없으면 활성화**까지만 진행해.

**주의: 이번 파일은 조회용 점검 프로그램이 아니라 실제 승인 실행 프로그램의 수정본이야. SE38에서 F8로 직접 실행하지 마.**

적용 대상은 정확히 아래 **레포트 하나**야.

```
ZRPTH_GUN_GULJAE_R1
```

앞서 활성화한 **`ZHR_SAVE_GUN_R1` 상신 연결 수정본은 그대로 유지**해. `ZHR_GUN_GULJAE_R1` 함수나 `ZCL_HR_GUN_R1_PC` 클래스에 이번 파일을 붙이는 것이 아니야.

## 4. 기존 반려 건과 원본 연차는 그대로 둬

이번 보완에서는 다음 항목을 **변경하지 않았어.**

| 대상 | 이번 보완에서의 처리 |
| --- | --- |
| 원래 승인된 연차 `000010211986` | 취소·재신청하지 않음 |
| 기존 반려 문서 `000010211987`, `000010211988` | 재승인·재반려하지 않음 |
| `PA2001`의 `DOCNR`·`SEQNR` | 과거 값으로 되돌리지 않음 |
| `ZHR2016` 사용량 | 복원하거나 다시 차감하지 않음 |
| `ZTGUNR1H`와 `ZTGUNR1S` | 기존 이력·스냅샷을 덮어쓰지 않음 |

**기존 두 반려 건의 R1 이력 정리는 별도 작업으로 남아 있어.** 그 작업도 표준 근태를 억지로 과거 값에 맞추는 방식이 아니라, 실제 반려·워크플로 종료 결과를 확인해 R1 이력만 정리하는 방향으로 분리해야 해.

원본 소스 보존, 검사 위치, 추가 구간의 데이터 갱신·커밋 부재와 분기 조건은 로컬에서 확인했어. **SAP 구문 검사·활성화·실제 승인 시험은 여기서 실행하지 않았고, 기존 일반 신청 처리의 전체 오류 복구까지 해결한 수정본도 아니야.**

**지금은 이 레포트의 구문 검사·활성화 결과만 알려줘. 원본 연차 취소나 기존 오류 건 재승인 없이, 이 보완부터 적용하면 돼.**

ZRPTH_GUN_GULJAE_R1_PC_GUARD01_20261014.txt문서README_PC_GUARD01_EASY.md문서

## ess4-t045-u1 · 사용자

활성화까지만 했어

## ess4-t045-a1 · AI

좋아. **`PC-GUARD01` 수정본은 적용·활성화까지 완료한 상태로 이어갈게. 그 승인 레포트를 SE38에서 직접 실행할 필요는 없어.**

이제 다음은 **이미 반려된 두 변경신청의 결재번호·반려 상태를 R1 이력에 연결하는 보정 단계**야. 앞서 적용한 차단 코드는 과거 이력을 수정하지 않는 보완이므로, 이 작업은 별도로 해야 해.

**보정용 프로그램을 준비했어. 다만 이번 첫 실행은 ‘테스트 실행’으로, 실제 데이터를 바꾸지 않고 보정 예정값만 확인하자.**

## 1. 이번에 정리할 대상

앞서 확인한 두 문서는 신청·KOBIS에서 반려이고, 조회된 워크플로 작업도 완료됐지만, R1 이력은 `SAVED`와 결재번호 초기값으로 남아 있었어.

프로그램이 검증 후 제시할 보정 예정값은 다음과 같아.

| 구분 | 첫 번째 변경신청 | 두 번째 변경신청 |
| --- | --- | --- |
| R1 요청 순번 `RSEQNR` | `001` | `002` |
| 연결할 결재번호 `ZSERIAL` | `000010211987` | `000010211988` |
| 처리 단계 `PHASE` | `SAVED` → `REJECT` | `SAVED` → `REJECT` |
| 결정 `DECISION` | 공란 → `N` | 공란 → `N` |

**원래 승인된 연차 `000010211986`은 취소하지 않아.** 기존 승인 프로그램에는 실제 근태 삭제 API가 있으므로, 이력 정리를 위해 그 프로그램을 다시 실행하는 방식도 사용하지 않았어.

## 2. 적용할 파일

`README_REJECT_SYNC01_EASY.md` · `R1_REJECT_SYNC01_20261014_XA32762.zip`

**이번 파일은 실제 반영 기능도 포함한 보정용 프로그램이야. 조회 전용이라고 생각하고 옵션을 바꾸면 안 돼.** 기본값인 `P_TEST` 체크를 유지하면 조회와 보정 예정값 출력만 하도록 작성했어.

## 3. SAP에서 지금 할 작업

### ① 별도 프로그램 생성

SE38에서 아래 이름으로 **새 실행 가능 프로그램**을 만들어 줘.

| 항목 | 입력값 |
| --- | --- |
| 프로그램명 | **`ZHR_GUN_R1_REJECT_SYNC`** |
| 내역 | `R1 반려 변경요청 처리이력 동기화` |
| 적용 소스 | 위 전체 소스 파일 |

기존 점검 프로그램인 `ZHR_GUN_R1_REJECT_CHECK`와는 다른 프로그램이야. 기존 승인 레포트·함수·클래스에 붙여 넣지 말고, 새 프로그램에 전체 소스를 적용한 뒤 **저장 → 구문 검사 → 활성화**해.

### ② 테스트 실행

새로 만든 **`ZHR_GUN_R1_REJECT_SYNC`**에서 F8을 눌러 선택 화면을 열고, 아래 기본값을 확인해.

| 필드 | 이번 실행값 |
| --- | --- |
| `P_PERNR` | `00032762` |
| `P_ORIG` | `000010211986` |
| `P_KEY1` | `000010211987` |
| `P_KEY2` | `000010211988` |
| **`P_TEST`** | **체크 유지 — 실제 보정하지 않음** |
| `P_CONF`, `P_SYSID`, `P_NOTE` | **모두 공란 유지** |

그 상태에서 다시 F8로 실행하면 돼.

조건이 맞으면 문서별 보정 예정값과 마지막에 다음 문구가 나오도록 작성했어.

```
TEST_OK: 2 metadata candidates. DATABASE_WRITES=0
```

**이 문구는 ‘보정 후보 두 건의 검사 통과’이지, 실제 보정 완료라는 뜻은 아니야.** `BLOCK`이 나오면 조건을 지우거나 테이블 값을 맞추지 말고 그 메시지를 확인해야 해.

## 4. 근태의 `DOCNR`·`SEQNR` 차이는 그대로 보존해

이번 보정은 **이미 끝난 반려 결과를 R1 이력에 기록하는 작업**이야. 과거 근태 식별정보 차이의 원인을 해결했다고 처리하지 않아.

프로그램에는 확인된 `DOCNR`·`SEQNR` 차이 외에 다른 변화가 생겼는지 검사하고, 이 차이가 미해결이라는 경고를 유지하도록 넣었어. **`PA2001`, `PA2006`, `ZHR2016`을 수정하거나 기존 업무 스냅샷을 덮어쓰는 코드는 넣지 않았어.**

나중에 실제 반영을 진행할 경우의 쓰기 범위도 **`ZTGUNR1H` 두 행과 별도의 보정 감사기록**으로 제한했어. 감사기록은 `ZTGUNR1S`의 **새 `RA` 영역·고유 키**에 남기며, 기존 업무 스냅샷인 `PC` 영역은 보존하는 방식이야. **지금 테스트 실행에서는 이 감사기록도 저장하지 않아.**

소스 구조와 보호 조건은 로컬에서 확인했지만, **새 프로그램의 SAP 구문 검사·실행·실제 DB 반영은 아직 검증하지 않았어.**

**우선 `P_TEST`를 체크한 실행 결과에서 두 문서의 보정 예정값과 마지막 `TEST_OK` 또는 `BLOCK` 부분을 보여줘. 원본 연차 취소나 기존 반려 건 재승인 없이, 그 결과를 보고 실제 이력 보정으로 넘어가자.**

ZHR_GUN_R1_REJECT_SYNC_20261014.txt문서README_REJECT_SYNC01_EASY.md문서

## ess4-t046-u1 · 사용자



## ess4-t046-a1 · AI

확인했어. **이번 오류는 보정 프로그램이 `ZCL_HR_GUN_R1_PC`의 자료형을 참조하기 전에, 클래스 정의를 먼저 불러오라는 구문 오류야.** 화면에 보이는 아래쪽 `COMMIT` 구문이 아니라, 오류 목록에 표시된 **66행의 클래스 참조 관련 문제**야.

**클래스를 다시 만들 필요는 없어. `ZHR_GUN_R1_REJECT_SYNC`의 상단에 선언 한 줄을 추가해서 확인하자.**

## 1. 수정 위치와 코드

SE38에서 **`ZHR_GUN_R1_REJECT_SYNC`**를 열고, 소스 맨 위쪽의 다음 줄을 찾아줘.

```
TYPE-POOLS abap.
```

**바로 아래에 `CLASS ... DEFINITION LOAD.`를 추가해서 다음처럼 만들면 돼.** 아래 코드는 프로그램 전체가 아니라, 해당 위치에 들어갈 부분이야.

```
TYPE-POOLS abap.

* Start-Add / XA32762 / GNT-R1-U22 / 2026-10-14 / classload01
* Load the global class definition before using its public types.
CLASS zcl_hr_gun_r1_pc DEFINITION LOAD.
* End-Add / XA32762 / GNT-R1-U22 / classload01
```

기존 소스에서는 `TY_CASE` 구조 안에서 `ZCL_HR_GUN_R1_PC=>TT_GUN`, `TT_HR`, `TT_POOLS`, `TT_QUOTA`를 참조하고 있어. **새 선언은 이 자료형 참조보다 앞에 있어야 해.** 기존 `PARAMETERS`, `CONSTANTS`, `TYPES` 내용은 그대로 두면 돼.

참고로 `CLASS … DEFINITION LOAD.`는 이후 ABAP 버전에서는 자동 로딩으로 불필요해진 구문이지만, 현재 시스템에서 표시한 오류에 맞춰 명시적으로 정의를 불러오는 보완이야. **새 클래스를 정의하는 블록이 아니므로 `ENDCLASS.`는 추가하지 마.** [SAP 도움말 포털](https://help.sap.com/doc/abapdocu_750_index_htm/7.50/en-US/abapclass_interface_load.htm?utm_source=chatgpt.com)

## 2. 전체 교체용 파일도 준비했어

위 파일에는 **클래스 로딩 선언과 수정이력 주석만 추가**했어. 추가한 부분을 제외하면 이전 파일과 동일하고, 기존 보정 조건·잠금·감사기록·테스트 기본값은 바꾸지 않았어.

직접 위 구간을 추가했다면 전체 파일을 다시 적용할 필요는 없어.

## 3. 수정 후에는 테스트 실행까지만

**저장 → 구문 검사 → 오류가 없으면 활성화**한 다음, 앞서 안내한 테스트 실행으로 이어가면 돼.

| 항목 | 유지할 값 |
| --- | --- |
| **`P_TEST`** | **체크 유지** |
| `P_CONF` | 공란 |
| `P_SYSID` | 공란 |
| `P_NOTE` | 공란 |
| 사번·원본번호·두 변경신청번호 | 기존 기본값 유지 |

이번에도 **실제 보정 모드로 실행하지 않는 단계**야. 기존 안내서의 테스트 실행 조건도 그대로 유지해.

새 수정본을 SAP에서 직접 구문 검사한 것은 아니므로, **다른 구문 오류가 남으면 실행하지 말고 그 오류부터 확인하자.** 구문 검사가 통과하면 `P_TEST`를 체크한 결과의 `TEST_OK` 또는 `BLOCK` 부분을 보여줘.

ZHR_GUN_R1_REJECT_SYNC_CLASSLOAD01_20261014.txt문서

## ess4-t047-u1 · 사용자



## ess4-t047-a1 · AI

좋아. **이번 테스트는 정상 통과했어. 이제 이미 반려된 두 건의 R1 처리이력만 실제로 반영하는 단계로 넘어가면 돼.**

화면의 핵심 결과는 다음이야.

```
TEST_OK: 2 metadata candidates. DATABASE_WRITES=0
```

즉, **두 건 모두 보정 후보 조건을 통과했지만, 아직 데이터는 변경되지 않았어.** `SAVED → REJECT`로 표시된 것도 현재는 보정 예정값이야.

## 1. 이번에 실제 반영할 범위

실반영이 성공하면 다음 두 R1 이력에 기존 결재번호와 반려 결과를 연결해.

| R1 요청 순번 | 연결할 결재번호 | 처리 단계 | 결정 |
| --- | --- | --- | --- |
| `001` | `000010211987` | `REJECT` | `N` |
| `002` | `000010211988` | `REJECT` | `N` |

실제 처리 계정과 작업번호도 확인된 워크플로 값으로 기록하고, 보정 시각·주의사항·감사기록 키를 남기는 구조야. **변경 대상은 `ZTGUNR1H` 두 행과 `ZTGUNR1S`의 새로운 `RA` 감사기록 묶음으로 제한돼. 기존 `PC` 스냅샷은 그대로 보존해.**

**원본 연차 취소, `PA2001`·`PA2006`·`ZHR2016` 수정, 신청·KOBIS 재반려, 워크플로 재실행은 이번 작업에 포함되지 않아.**

## 2. 같은 보정 프로그램을 다시 실행해

**새 소스를 적용하거나 프로그램을 다시 만들 필요는 없어.**

현재 결과 화면을 보관하고 보고서를 종료한 다음, SAP 명령창에서 `/nSE38`로 들어가 **`ZHR_GUN_R1_REJECT_SYNC`**를 새로 실행해.

이번 대상은 **보정 프로그램 `ZHR_GUN_R1_REJECT_SYNC`**야. 기존 승인 레포트 **`ZRPTH_GUN_GULJAE_R1`을 실행하는 것이 아니야.**

### 선택 화면에는 이렇게 입력해

**지금 테스트한 시스템 `KSD`, 클라이언트 `300`에서만 진행해.** 다른 시스템으로 바꿔서 실행하지 마. 이번 테스트 화면에서도 `KSD / 300`이 확인돼.

| 화면 필드 | 실제 반영 시 입력값 |
| --- | --- |
| `P_PERNR` | `00032762` — 유지 |
| `P_ORIG` | `000010211986` — 유지 |
| `P_KEY1` | `000010211987` — 유지 |
| `P_KEY2` | `000010211988` — 유지 |
| **`P_TEST`** | **체크 해제** |
| **`P_CONF`** | **`META_ONLY`** |
| **`P_SYSID`** | **`KSD`** |
| **`P_NOTE`** | 아래 작업 기록 입력 |

`P_NOTE`에는 다음처럼 입력하면 돼. 내부 작업번호를 관리하고 있다면 그 번호를 함께 남겨줘.

```
반려 1987/1988 R1 이력 연결 보정. DOCNR/SEQNR 차이 검토 유지.
```

실반영은 `P_TEST` 해제뿐 아니라 확인문구·현재 시스템 ID·작업 기록과 변경 권한까지 검사하도록 되어 있어. **이 설정으로 실행하면 실제 DB 보정이 진행된다는 점을 확인하고, 개발계 작업 권한과 내부 절차에 따라 F8을 한 번 눌러줘.**

실행하는 동안에는 해당 사원의 다른 근태 신청·승인·수동 수정 작업은 잠시 멈춰두자.

## 3. 성공 여부는 마지막 메시지로 확인해

정상적으로 반영되고 저장 결과 재조회까지 통과하면 다음 문구가 나오도록 작성되어 있어.

```
SYNC_OK: 2 R1 headers reflect the already completed rejection.
AUDIT_RELID=RA AUDIT_ID=...
```

**`SYNC_OK`와 실제 `AUDIT_ID`가 나온 최종 화면을 보관해.** 앞쪽에 보정 예정값이 출력됐다는 것만으로 완료라고 판단하지 않으면 돼. 프로그램은 최종 저장 뒤 헤더 두 행과 감사기록을 다시 읽고 일치할 때 이 성공 문구를 출력해.

반대로 **`BLOCK`**, **`OUTCOME_REVIEW_REQUIRED`**, 실행 오류나 연결 끊김이 발생하면 **반복 실행하지 말고 그 화면에서 멈춰줘.** 특히 `OUTCOME_REVIEW_REQUIRED`는 저장 확정 단계에 진입한 뒤 결과를 확인하지 못한 경우라서, “아무것도 반영되지 않았다”고 가정하면 안 돼. 테스트 통과가 실반영의 잠금·변경 권한·감사기록 저장까지 성공했다는 뜻도 아니야.

## 4. `HR_DOCNR_SEQNR_REVIEW=OPEN`은 그대로 남는 게 맞아

이 문구는 **과거 표준 근태의 `DOCNR`·`SEQNR` 차이 원인은 아직 미해결이라는 기록**이야. 반려 이력 보정에 성공해도 지우거나 `CLOSED`로 바꾸지 않아. 이번 작업이 그 차이까지 복구한 것으로 오해하지 않도록 남기는 것이야.

**지금은 위 설정으로 이력 보정만 한 번 실행하고, 마지막 `SYNC_OK`·`AUDIT_ID`가 보이는 결과를 보내줘. 원래 승인된 연차는 그대로 두고, 새로운 변경신청이나 승인 시험은 아직 시작하지 않으면 돼.**

## ess4-t048-u1 · 사용자

**`P_CONF` 여기에 뭘 넣으라는거야 **

## ess4-t048-a1 · AI

**`P_CONF` 칸에는 아래 문구를 그대로 입력하면 돼.**

```
META_ONLY
```

**영문 대문자**, 가운데 **밑줄 `_` 포함**, **따옴표나 공백 없이** 입력해. 프로그램에서 이 문구와 일치하는지 확인하도록 되어 있어.

자유롭게 사유를 적는 칸이 아니라 **“반려 처리이력만 실제 보정하겠다”는 확인 문구**야. 작업 사유는 별도 **`P_NOTE`** 칸에 적으면 돼. **`P_TEST`를 해제하고 나머지 조건까지 충족한 상태에서 실행하면 실제 보정이 진행돼.**

## ess4-t049-u1 · 사용자



## ess4-t049-a1 · AI

좋아. **이번에는 테스트가 아니라, 두 변경신청의 R1 반려 이력이 실제로 보정된 결과야.** 화면에 아래 성공 문구와 감사기록 번호가 모두 나왔어.

```
SYNC_OK: 2 R1 headers reflect the already completed rejection.
AUDIT_RELID=RA AUDIT_ID=...
```

이 프로그램은 **저장 확정 후 R1 이력 두 행과 감사기록을 다시 읽어, 예상값과 일치할 때만 `SYNC_OK`를 출력**해. 따라서 앞서의 `TEST_OK`와 달리 **실제 반영 및 프로그램 내부의 저장 결과 확인까지 통과한 것**이야.

## 1. 이번에 완료된 내용

| 변경신청 | R1 요청 순번 | 연결된 결재번호 | 처리 단계 | 결정 |
| --- | --- | --- | --- | --- |
| 첫 번째 변경신청 | `001` | `000010211987` | **`REJECT`** | `N` |
| 두 번째 변경신청 | `002` | `000010211988` | **`REJECT`** | `N` |

**“신청·결재는 반려로 끝났는데, R1 이력만 `SAVED`로 남아 있던 문제”는 이번 보정으로 정리됐어.** 실제 반려 처리 계정은 `30751`로 유지하고, 보정 실행자 `XA32762`는 별도 감사기록에 남긴 결과야.

**`ZHR_GUN_R1_REJECT_SYNC`를 실제 반영 모드로 다시 실행할 필요는 없어.** 지금 화면은 `AUDIT_ID`가 포함되도록 보관해 둬.

## 2. `HR_DOCNR_SEQNR_REVIEW=OPEN`은 보정 실패가 아니야

이 문구는 **과거 근태의 `DOCNR`·`SEQNR` 차이 원인은 아직 미해결이라는 기록**이야. 이번 반려 이력 보정과 구분해서 남겨 놓은 것이므로, 성공했어도 `OPEN`으로 표시되는 게 맞아.

이번 프로그램의 실제 쓰기 대상은 **R1 이력과 새 감사기록**이고, 기존 `PC` 스냅샷은 변경되지 않았는지 대조하는 구조야. **원래 승인된 연차를 취소하거나, 근태를 재생성하거나, 잔여 연차를 늘리는 작업을 한 것은 아니야.**

## 3. 다음은 R1 화면에 반영됐는지만 확인하자

**새 소스 적용이나 점검 프로그램 생성은 필요 없어.**

R1 신청 화면에서 **‘기승인 변경·취소 진행 내역’**을 새로 열어 줘. 해당 페이지는 `guntae_change_status_r1.kbs`이고, 요청의 결재문서번호와 처리 단계를 표시하는 화면이야.

확인할 것은 두 가지야.

- `000010211987`, `000010211988`이 각각 연결된 결재번호로 표시되는지
- 두 건 모두 **‘반려’**로 표시되고, 더 이상 **‘저장’이나 ‘결재 대기’**로 나오지 않는지

화면에 과거 `DOCNR`·`SEQNR` 검토 경고가 함께 나와도 삭제하지 마. **이번 단계의 완료 범위는 반려 이력 연결이며, 기승인 변경·취소의 실제 승인 기능 전체가 검증된 것은 아니야.**

**진행 내역에서 두 건이 ‘반려’로 표시되는지만 알려줘. 원본 연차와 기존 두 반려 건은 그대로 두고, 새 변경신청·승인 시험은 아직 시작하지 않으면 돼.**

## ess4-t050-u1 · 사용자



## ess4-t050-a1 · AI

좋아. **두 건 모두 R1 진행 내역 화면에서 결재번호와 ‘반려’ 상태가 정상적으로 표시됐어. 이제 기존 반려 건의 이력 보정과 화면 반영 확인까지 완료된 거야.**

| 결재문서 | 현재 화면 표시 |
| --- | --- |
| `000010211987` | **반려** |
| `000010211988` | **반려** |

화면에 있는 `[RJ-SYNC01] … DOCNR/SEQNR drift OPEN`은 **보정 실패 메시지가 아니라, 과거 근태 식별정보 차이는 아직 검토가 필요하다는 기록**이야. 이 경고와 기존 스냅샷은 그대로 보존하면 돼. 또한 화면의 **11월 3~4일, 11월 4~5일은 반려된 변경계획**이지, 그 기간으로 실제 근태 변경이 승인됐다는 뜻은 아니야.

## 다음은 새 변경요청의 ‘저장·상신 연결’만 확인하자

**보정 프로그램을 다시 실행하거나 원래 승인된 연차를 취소할 필요는 없어.** 이제 개발서버에서 **새 변경요청 한 건을 저장·상신까지만** 진행해서, 앞서 누락됐던 결재번호 연결이 동작하는지 확인하자. **결재자의 승인·반려는 아직 누르지 않는 단계야.**

이력 보정이 실제 승인 기능의 검증까지 끝났다는 뜻은 아니므로, 다음 시험은 근태 반영 전 단계로 한정하는 거야. 안내서상으로도 저장·상신 때는 원본 근태와 사용량을 유지해야 해.

### ① 원래 승인된 연차를 선택

R1 신청 화면으로 돌아가서 다음 **승인 원본**을 선택해.

| 항목 | 대상 |
| --- | --- |
| 원본 결재번호 | **`000010211986`** |
| 원본 기간 | **2026/11/03~2026/11/05** |
| 원본 일수 | **3일** |

방금 정리한 반려 건 `1987`, `1988`을 선택하는 것이 아니라 **원래 승인된 건에서 ‘결재후변경신청’**을 누르는 거야.

### ② 총 3일을 유지하면서 하루만 이동

이번에는 **잔여 0일 상태에서 사용량을 늘리지 않는 날짜 이동**을 확인하자.

예를 들어 **11월 6일이 화면에서 신청 가능하고 다른 근태와 겹치지 않는다면**, 아래처럼 선택해.

```
기존 승인: 11월 3일 · 4일 · 5일 → 총 3일
변경 계획: 11월 3일 · 4일 · 6일 → 총 3일
```

**11월 5일만 해제하고 새 날짜를 선택하지 않으면 3일 → 2일 부분취소 계획이 되므로**, 저장 전에 선택 날짜와 총일수를 확인해. 같은 연차 공제 기간에서 원본 사용량을 인정하는 것이 이번 R1 설계야.

사유는 `상신 연결 수정 후 날짜 이동 테스트`처럼 남기고, 결재자를 지정해 저장하면 돼.

### ③ 새로 저장된 요청 한 건만 결재상신

저장한 **새 변경요청 한 건만** 선택해서 상신한 뒤, 지금 보여준 진행 내역 화면을 다시 열어줘.

이번 확인 기준은 다음과 같아.

| 확인 항목 | 기대 결과 |
| --- | --- |
| 새 변경요청의 결재문서번호 | **0이 아닌 새 번호가 표시됨** |
| 새 변경요청의 처리 단계 | **‘결재 대기’ — `WAIT`** |
| 원래 승인된 근태 | **승인 전이므로 기존 11월 3~5일 유지** |
| 실제 연차 사용량·잔여 | **저장·상신 전과 동일** |

`WAIT`는 결재 대기 단계야. **상신 후에도 `SAVED`·결재번호 0으로 남거나, `STARTING`·오류가 표시되면 다시 상신하지 말고 멈춰야 해.**

**새 요청을 저장·상신한 뒤 진행 내역 화면을 보내줘. 이번에는 ‘새 결재번호 연결 + 결재 대기 표시’까지 확인하고, 실제 승인은 그다음에 판단하자.**

## ess4-t051-u1 · 사용자

저장한 **새 변경요청 한 건만** 선택해서 상신한 뒤, 지금 보여준 진행 내역 화면을 다시 열어줘.  ....이거 뭘 보여줘야하는거야 ?

## ess4-t051-a1 · AI

아, **방금 네가 보여준 「기승인 변경·취소 진행 내역」 웹화면에서, 이번에 새로 만든 변경신청이 보이는 부분을 캡처해 달라는 뜻이야.** **SE16N 조회 결과나 프로그램 소스를 말한 게 아니야.**

### 어디에서 캡처하면 되냐면

방금 **‘반려’ 두 건이 보였던 브라우저 화면**으로 돌아가서, **왼쪽 위의 파란색 「최신 상태 조회」**를 눌러줘.

그다음 **이번에 새로 저장·상신한 요청**에서 아래 항목이 함께 보이도록 캡처하면 돼.

| 화면에서 보여줄 부분 | 내가 확인하려는 내용 |
| --- | --- |
| **`00032762 · 상태`** | 새 요청이 **‘결재 대기’**로 바뀌었는지 |
| **`요청번호: … / 결재문서: …`** | **새 결재문서번호가 연결됐는지** |
| **변경 전 날짜와 그 아래 신청한 날짜** | 이번에 요청한 변경계획이 맞는지 |

**기존 반려 건 `000010211987`, `000010211988`이 아니라 새 요청 부분**을 보여주면 돼. 새 결재번호는 시스템에서 발급하는 값이므로 내가 미리 정해 준 번호를 찾는 것은 아니야.

**이미 상신했다면 다시 상신하지 말고 조회만 해줘.** 새 요청이 안 보이거나 여전히 ‘저장’으로 나오면 그 화면 그대로 보내면 돼. **결재자의 승인·반려 버튼은 아직 누르지 마.**

## ess4-t052-u1 · 사용자



## ess4-t052-a1 · AI

좋아. **이번에는 새 변경요청의 결재번호가 연결됐고, 상태도 ‘결재 대기’로 표시되고 있어. 우리가 확인하려던 상신 연결 결과가 맞아.**

## 1. 이번 화면에서 확인된 내용

| 항목 | 확인 결과 |
| --- | --- |
| 새 결재문서번호 | **`000010211991`** |
| 현재 상태 | **결재 대기** |
| 변경 전 | 2026/11/03~11/05 |
| 변경 계획 | **11월 3~4일 + 11월 6일** |
| 선택 날짜 수 | **기존 3일 → 변경 후 3일 유지** |

이번에는 이전처럼 **결재번호가 0이고 ‘저장’ 상태에 머무는 문제가 나타나지 않았어.** 날짜도 11월 5일을 제외하고 11월 6일을 추가한 계획으로 표시돼. 아래의 기존 두 건은 그대로 반려 상태야.

다만 **이 화면은 변경계획과 처리 상태를 보여주는 화면이므로, 실제 근태·연차 사용량까지 그대로인지 확인된 것은 아니야.** 안내서의 다음 확인 항목도 ‘저장·상신만 했을 때 원본 근태와 실제 사용량이 유지되는지’야.

## 2. 다음은 기존 조회 프로그램으로 새 문서만 확인하자

**새 프로그램을 만들거나 소스를 수정할 필요는 없어.** 앞서 실행했던 조회용 프로그램을 다시 사용하면 돼.

**SE38 → `ZHR_GUN_R1_REJECT_CHECK` → 실행**

> **`REJECT_CHECK`가 맞아. 실제 이력을 보정했던 `REJECT_SYNC`는 실행하지 마.**

프로그램 제목에는 ‘반려’가 들어 있지만, 소스는 입력한 문서번호를 조회하는 구조라서 이번 새 요청도 확인할 수 있어. 두 번째 문서번호를 비우면 첫 번째 문서만 조회해.

선택 화면을 아래처럼 바꿔줘.

| 필드 | 이번 입력값 |
| --- | --- |
| `P_PERNR` | `00032762` — 유지 |
| `P_ORIG` | `000010211986` — 원래 승인된 연차 번호 유지 |
| **`P_KEY1`** | **`000010211991` — 이번 새 결재번호로 변경** |
| **`P_KEY2`** | **기존 값을 지우고 공란** |

그다음 **F8로 조회**하면 돼. 이번 실행은 근태나 이력을 보정하는 작업이 아니라, 새 문서의 신청·결재 연결과 저장 당시/현재 데이터를 비교하는 조회야.

## 3. 이번에 확인할 기준

**승인 전이므로 실제 근태는 아직 11월 3~5일로 남아 있어야 하고, 이번 변경요청 때문에 11월 6일 근태가 미리 생성되거나 연차 사용량이 달라지면 안 돼.** 이 기준을 새 요청의 스냅샷과 현재 데이터로 대조하자.

**새 문서 `000010211991`의 조회 결과 전체를 보내줘. 지금 상신을 다시 할 필요는 없고, 결재자의 승인·반려도 아직 누르지 않으면 돼.**

## ess4-t053-u1 · 사용자



## ess4-t053-a1 · AI

좋아. **이번 새 요청 `000010211991`은 결재번호 연결뿐 아니라, 승인 전 원본 근태·연차 사용량 유지 여부까지 확인됐어. 이제 개발서버에서 이 한 건의 실제 승인 시험으로 넘어가면 돼.** 다만 지금 확인한 것은 **승인 전 점검 결과**이고, 실제 승인 처리의 성공 여부는 다음 실행에서 확인해야 해.

## 1. 이번 결과에서 확인된 내용

| 점검 항목 | 실제 결과 | 의미 |
| --- | --- | --- |
| R1 결재번호·상태 | `000010211991` / **`WAIT`** | 새 요청이 결재 대기로 연결됨 |
| 결재 작업 | `000051859147` / **`READY`**, 사용자 `30751` | 지정 결재자의 대기 작업이 존재함 |
| 원본 신청 비교 | `ORIGINAL_APPLICATION_EQUAL=YES` | 저장된 원본 신청과 현재 값이 같음 |
| 표준 근태 비교 | **85개 필드 비교, 차이 0개** | 새 스냅샷과 현재 근태가 같음 |
| 변경 예정 날짜의 추가 근태 | `EXTRA_HR_OCCURRENCES_IN_PLAN=0` | 조회한 계획 기간에 저장 원본 키 이외의 근태가 발견되지 않음 |
| 연차 비교 | `QUOTA_FULL_ROW_EQUAL=YES` | 저장된 연차 행과 현재 값이 같음 |

현재 실제 근태는 **11월 3~5일의 3일짜리 원본**으로 남아 있고, 연차는 **발생 20일·사용 20일**이야. 변경계획도 **기존 3일 → 변경 후 3일**로 계산되어 있어. 이번 요청의 스냅샷과 조회 시점 사이에서는, 앞서 문제가 됐던 근태 필드 차이도 나오지 않았어.

**과거 두 반려 건의 `DOCNR`·`SEQNR` 차이가 해소됐다는 뜻은 아니야.** 이번에는 **새 요청에 저장된 기준과 현재 데이터가 일치한다는 것**을 확인한 거야.

## 2. 이제는 지정 결재자가 ‘승인’을 한 번 누르는 단계야

앞에서는 승인하지 말고 멈추라고 했지만, **이번 승인 전 비교까지 확인했으니 다음 순서로 진행하자.** 적용 안내서도 저장·상신 후 원본 유지 확인 다음에 R1 결재 화면의 승인 시험을 진행하도록 되어 있어.

1. **현재 조회 결과를 승인 전 기준으로 보관해.** 시험 중에는 해당 사원의 다른 근태 변경·승인을 동시에 진행하지 않는 게 좋아.
2. **지정 결재자 `00030751`이 자신의 계정으로 R1 결재 화면**을 열고, **문서 `000010211991` 한 건만** 선택해.
3. 변경계획이 **11월 3~4일 + 11월 6일**인지 확인한 뒤 **승인을 한 번만** 눌러줘.

**기존 반려 건 `000010211987`, `000010211988`이나 원본 `000010211986`을 다시 승인하는 것이 아니야.** SE38에서 승인 레포트나 보정 프로그램을 실행하는 것도 아니고, **R1 웹 결재 화면에서 새 변경요청 한 건을 승인**하는 거야.

## 3. 승인 후 확인할 목표

아래는 **승인이 정상 완료됐을 때 확인할 결과**야. 아직 이렇게 반영됐다고 확정한 것은 아니야.

| 항목 | 승인 후 확인할 목표 |
| --- | --- |
| 진행 내역 | 새 요청이 **‘승인 완료’ / `DONE`** |
| 실제 근태 날짜 | **11월 3일·4일·6일** — 11월 5일은 제외 |
| 이번 원본에 해당하는 총 사용일수 | **3일 유지** |
| `ZHR2016` 사용량 | **20일 유지** |
| 해당 연차 행의 잔여 | **0일 유지** |

이번 계획은 같은 공제 기간에서 3일을 3일로 옮기는 것이므로, 목표 사용량은 **`현재 20일 − 원본 3일 + 변경 후 3일 = 20일`**이야. 안내서에서도 날짜 이동 승인 후 실제 근태와 사용량, `DONE` 상태를 함께 확인하도록 되어 있어.

### 오류가 나오면 반복 승인하지 마

오류 팝업이 나오거나 진행 내역이 `HR_DONE`, `PREPARED`, `RECONCILE` 등으로 남으면 **재승인·반려·회수를 연달아 실행하지 말고 멈춰줘.** 일부 처리가 먼저 반영됐을 수 있어서, 화면의 실패 표시만으로 “아무것도 바뀌지 않았다”고 가정하면 안 돼.

**승인을 한 번 진행한 뒤, 승인 결과 팝업과 「기승인 변경·취소 진행 내역」의 `000010211991` 상태가 보이는 화면을 보내줘. 성공 메시지가 나와도 실제 근태·연차 대조까지 마쳐야 이번 날짜 이동 시험을 완료로 판단할 수 있어.**

## ess4-t054-u1 · 사용자

오류가 나네

## ess4-t054-a1 · AI

확인했어. **이번 증상을 일으킬 수 있는 코드 오류를 찾았어. 내가 제공했던 R1 클래스에서 ‘결재 작업을 확보한 상태’의 코드를 잘못 비교하고 있었어.**

**같은 문서를 다시 승인하거나 반려하지 말고, 아래 두 메서드를 보완한 뒤 현재 처리 상태부터 확인하자.**

## 1. 확인된 문제: `RESERVED`가 아니라 `SELECTED`

SAP에서 화면상 **Reserved로 표시하는 작업 상태의 기술값은 `SELECTED`**야. SAP 공식 자료에서도 이를 **“RESERVED (SELECTED)”**로 구분해 표기하고 있어. [SAP 지원 포털](https://userapps.support.sap.com/sap/support/knowledge/en/3675327)

그런데 보관된 적용본의 `WF_FINISH`에는 다음 조건이 들어 있었어.

```
IF ls_head-wi_stat = 'RESERVED'.
```

이 조건 안에서 결재 완료 API를 호출하기 때문에, **실제 상태가 `SELECTED`라면 완료 호출을 건너뛰고 ‘결재 완료를 확인하지 못했습니다’로 끝날 수 있어.** 또한 `WF_CHECK`도 재개 가능한 상태를 `RESERVED`로 검사해서, 그대로 재개 버튼을 눌러도 막힐 수 있는 구조였어.

이번 팝업은 바로 그 **결재 완료 확인 실패 메시지**야. 다만 **실제 서버의 현재 작업 상태가 `SELECTED`인지는 아직 재조회하지 않았으므로**, 이번 실행의 직접 원인까지 확정한 것은 아니야.

**중요한 점은 근태가 이미 반영됐을 수 있다는 거야.** 안내서에서도 `HR_DONE`은 근태 반영 이후 결재 마무리가 필요한 단계로 구분하고 있어. 따라서 `0/1건 완료`라고 나왔다고 해서 아무 데이터도 바뀌지 않았다고 생각하면 안 돼.

## 2. 클래스의 두 메서드만 수정하면 돼

**적용할 클래스는 `ZCL_HR_GUN_R1_PC`야.** 아래 파일은 각각 `METHOD`부터 `ENDMETHOD`까지 포함한 **메서드 전체 교체용 소스**야.

| 수정 대상 | 전체 소스 | 수정 내용 |
| --- | --- | --- |
| **`WF_CHECK`** | `WF_CHECK_WF_STATE01_20261014.txt` | 재개 가능한 상태 검사에서 `RESERVED` → `SELECTED` |
| **`WF_FINISH`** | `WF_FINISH_WF_STATE01_20261014.txt` | 완료 API 호출 조건에서 `RESERVED` → `SELECTED` |

**`R1_WF_STATE01_20261014_XA32762.zip`**

기존 조건은 주석으로 남기고, `XA32762 / GNT-R1-U22 / wf-state01` 수정이력을 넣었어. **상태 비교 두 곳 외에는 실행 코드를 바꾸지 않았어.** 결재자·작업번호 검증이나 실제 근태·연차 처리 로직도 그대로야.

SE24에서 현재 두 메서드의 소스를 먼저 백업하고, 각각 해당 파일로 교체한 뒤 **저장 → 구문 검사 → 클래스 활성화**해 줘. 별도로 수정해 둔 내용이 있다면 전체 덮어쓰기 대신 묶음의 변경 비교 파일을 기준으로 두 조건만 반영해야 해.

**테이블의 상태값을 직접 바꾸는 작업이 아니라, ABAP 소스의 비교 조건을 고치는 작업이야.** 이번에는 기존 승인 레포트나 반려 이력 보정 프로그램을 다시 수정하지 않아.

## 3. 활성화 후에도 바로 재개하지 말고, 현재 상태를 조회하자

이미 사용했던 **조회용 `ZHR_GUN_R1_REJECT_CHECK`**를 아래 값으로 실행해 줘. **실제 보정용 `REJECT_SYNC`가 아니야.**

```
P_PERNR = 00032762
P_ORIG  = 000010211986
P_KEY1  = 000010211991
P_KEY2  = 공란
```

이번에는 출력 중 **다음 세 구간만** 있으면 돼.

| 출력 구간 | 확인할 내용 |
| --- | --- |
| **4. SAP 워크플로 헤더 / 진행 목록** | 작업 `000051859147`의 현재 상태와 처리자 |
| **5. 현재 PA2001 / ZHR2016** | 근태가 11월 3~4일·6일로 이미 바뀌었는지, 사용량은 20일인지 |
| **7. R1 HEADER AND SAVED SNAPSHOT** | `PHASE`, `DECISION`, `ACTOR`, `WI_ID`, `LAST_ERROR` |

**`HR_DONE`과 `SELECTED`가 확인된다면 이번 코드 결함과 맞는 상태야.** 그때는 처음부터 승인을 다시 하는 것이 아니라, **같은 결재자가 진행 내역의 ‘결재 마무리 재개’로 남은 처리를 이어가는 방향**이야. 다만 지금은 실제 상태와 근태 반영 결과를 먼저 확인하자.

이번 수정본은 소스 대조와 조건 검사를 했지만 **SAP 구문 검사·실제 재개 성공까지 확인한 것은 아니야.** 두 메서드 활성화 후 **조회 결과의 4번·5번·7번을 보내줘. 승인·반려·회수나 ‘결재 마무리 재개’ 버튼은 그 결과를 확인할 때까지 누르지 않으면 돼.**

WF_CHECK_WF_STATE01_20261014.txt문서WF_FINISH_WF_STATE01_20261014.txt문서

## ess4-t055-u1 · 사용자



## ess4-t055-a1 · AI

확인했어. **이번에는 근태 날짜 변경이 이미 반영됐고, 연차 사용량은 20일로 유지되고 있어. 남은 것은 ‘결재 완료와 신청 이력의 최종 확정’이야.** 따라서 **처음부터 다시 승인하는 것이 아니라, 같은 결재자가 ‘결재 마무리 재개’를 진행해야 하는 상태**야.

## 1. 현재 상태가 정확히 확인됐어

| 확인 항목 | 현재 결과 |
| --- | --- |
| 처리 중인 문서 | **`000010211991`** |
| R1 처리 단계 | **`HR_DONE` — 근태 반영 후 결재 마무리 단계** |
| R1에 기록된 결정·처리자 | `DECISION=Y`, **`ACTOR=30751`** |
| 결재 작업 | **`000051859147` / `SELECTED`** |
| 현재 실제 근태 | **11월 3~4일: 2일 + 11월 6일: 1일** |
| 연차 발생·사용량 | **발생 20일 / 사용 20일 — 해당 연차 행의 잔여 0일** |

즉, **11월 5일을 제외하고 11월 6일로 옮기는 실제 근태 변경은 조회 결과에서 확인됐어.** 하지만 결재 작업은 아직 `COMPLETED`가 아니고, 신청·KOBIS의 최종 결재값도 공란이므로 **전체 승인 완료로 볼 단계는 아니야.**

또한 현재 작업이 실제로 **`SELECTED`**여서, 앞서 찾은 **`RESERVED`를 비교하던 코드 문제와 부합해.** 전달한 수정본은 `WF_CHECK`에서 `SELECTED` 상태의 재개를 허용하고, `WF_FINISH`에서 그 상태일 때 결재 완료 API를 호출하도록 고친 것이야.

## 2. 이번 `ORIGINAL_HR_EQUAL=NO`는 이전과 다르게 봐야 해

이번에는 **변경 전 스냅샷과, 날짜 변경이 이미 반영된 현재 근태를 비교**하고 있어.

```
변경 전 스냅샷
  11월 3~5일 → 3일

현재 실제 근태
  11월 3~4일 → 2일
  11월 6일   → 1일
```

그래서 종료일·일수·시간 등의 차이가 출력되는 것이며, **이 비교를 다시 `YES`로 만들려고 근태나 스냅샷을 수정하면 안 돼.** 이번 계획대로 변경됐는지를 보는 것이 기준이야. `EXTRA_HR_OCCURRENCES_IN_PLAN=2`도 변경 전 스냅샷에 없던 키가 두 번 발견됐다는 출력이지, 중복 근태가 두 건 생겼다는 판정은 아니야.

참고로 **8번의 `CURRENT_HR_ROWS=1`은 원본 기간인 11월 3~5일과 겹치는 부분을 비교한 결과**야. 11월 6일은 그 범위 밖이고, 첫 번째 캡처의 **5번에서는 두 구간 모두 조회**되고 있어. 따라서 8번에 1건이라고 나온 것을 11월 6일 근태 누락으로 해석하지 않으면 돼.

## 3. 이제 ‘결재 마무리 재개’를 한 번 진행하자

**먼저, 앞서 전달한 `WF_CHECK`와 `WF_FINISH`의 `WF_STATE01` 수정본 두 개가 적용·활성화된 상태여야 해.** 이번 캡처는 데이터 상태를 보여주므로, 수정본 활성화 여부까지 확인해 주는 화면은 아니야. 아직 적용하지 않았다면 두 메서드 활성화부터 마쳐줘.

### ① 승인했던 결재자 계정으로 진행 내역 열기

**이번 승인을 누른 결재자 `30751`이 자신의 계정으로** R1 웹 결재 화면에 들어가서, **「변경 전·후 / 처리 진행 내역 확인」** 링크를 열어줘.

지금 점검 프로그램의 조회 계정은 `XA32762`지만, 실제 처리를 시작한 계정은 **`30751`**로 기록되어 있어. **재개도 그 결재자 계정으로 해야 해.** 수정본 역시 처리자와 작업번호가 일치하는지 검사하고 있어.

### ② 문서 `000010211991`의 재개 버튼 클릭

「기승인 변경·취소 진행 내역」에서 **최신 상태 조회**를 누른 다음, 다음 항목을 찾아줘.

```
결재문서: 000010211991
상태: 결재 마무리 필요
버튼: 결재 마무리 재개
```

**이 문서의 「결재 마무리 재개」를 한 번만 눌러줘.**

일반 결재 목록에서 **‘승인’을 다시 누르는 것이 아니야.** `HR_DONE` 단계의 재개는 이미 반영된 근태를 다시 처리하는 대신 남은 결재 마무리를 이어가도록 마련한 경로야.

### ③ 재개 결과 확인

정상 완료 후에는 **진행 내역이 ‘승인 완료 / `DONE`’으로 바뀌는지** 확인해야 해. 근태는 현재의 **11월 3~4일·6일, 총 3일**, 연차 사용량은 **20일**로 유지되는 것이 목표야. 아직 재개를 실행한 결과는 아니므로 완료 여부는 다음 화면에서 판단하자.

**버튼이 없거나 재개 중 오류가 나오면 승인·반려·회수로 대신 처리하거나 반복 실행하지 마. 재개 후 알림과 문서 `000010211991`의 진행 상태가 보이는 화면을 보내줘.**

## ess4-t056-u1 · 사용자

여기서 결재마무리재개 버튼은 안보이는데 ?

## ess4-t056-a1 · AI

응. **이 버튼은 ‘결재 마무리 필요’ 상태라고 모두에게 보이는 것이 아니라, 실제 승인을 시작한 결재자 계정에서만 표시되도록 되어 있어.** 지금은 **이 페이지를 연 로그인 계정이 그 결재자와 같은지**부터 확인해야 해.

## 1. 버튼 표시 조건을 확인했어

앞서 보내준 `ZCL_HR_GUN_R1_PC → STATUS_HTML`의 **57행**에 다음 조건이 있어.

```
IF ls_h-phase = 'HR_DONE' AND ls_h-actor = sy-uname.
```

이 조건을 만족할 때만 아래에 **「결재 마무리 재개」 버튼을 생성**해. 설명을 위해 보여주는 코드이고, 지금 수정하라는 뜻은 아니야.

이번 문서의 확인된 값과 비교하면 다음과 같아.

| 버튼 표시 조건 | 이번 문서의 값 |
| --- | --- |
| 처리 단계가 `HR_DONE`인지 | **충족** |
| 페이지에 로그인한 계정이 기록된 처리자와 같은지 | 기록된 처리자는 **`30751`**. **현재 브라우저의 로그인 계정은 캡처만으로 확인 불가** |

앞서 점검 결과에 `ACTOR=30751`로 기록되어 있었어. 따라서 **신청자 `XA32762`로 이 페이지를 열었다면 내역은 보이더라도 재개 버튼은 나오지 않는 구조야.** 다만 지금 브라우저가 실제로 어느 계정인지 보이지 않으므로, 계정 불일치가 원인이라고 아직 확정할 수는 없어.

**화면 제목 앞의 `00032762`는 신청 대상 사번이지, 현재 로그인 계정을 표시한 것이 아니야.**

## 2. 승인했던 결재자의 브라우저에서 다시 열어줘

이번에는 **결재자 `30751` 본인이, 앞서 승인 버튼을 눌렀던 브라우저 창에서** 아래 순서로 들어가면 돼.

1. **R1 결재 목록 화면 `app_va_list_r1.kbs`**로 돌아가.
2. 그 화면의 **「변경 전·후 / 처리 진행 내역 확인」** 링크를 눌러 진행 내역을 열어.
3. **「최신 상태 조회」**를 누르고, **결재문서 `000010211991`**의 오류 문구 아래에 **「결재 마무리 재개」** 버튼이 나오는지 확인해.

신청자 쪽에서 열어둔 진행 내역 창이 아니라, **승인했던 결재자의 로그인 상태에서 링크를 통해 들어가는 것**이 핵심이야. 현재 코드는 결재자 사번만 확인하는 것이 아니라 **기록된 처리 계정과 현재 로그인 계정이 정확히 같은지** 비교하고 있어.

## 3. 지금은 버튼을 강제로 보이게 수정하지 마

**`ACTOR` 값을 바꾸거나 위 계정 비교 조건을 삭제할 필요는 없어.** 이미 근태 날짜 변경은 반영된 상태이므로, 일반 결재 목록에서 승인을 다시 누르거나 반려로 대신 처리하지도 말자.

**우선 승인했던 결재자의 브라우저에서 위 링크로 다시 들어가서 버튼이 보이는지 확인해 줘. 같은 결재자 계정에서도 없다면, 그때는 실제 페이지가 인식한 로그인 ID와 버튼 생성 코드를 대조해야 해.**

## ess4-t057-u1 · 사용자

"기승인 변경취소 요청의 변경 전후 처리진행 내역확인을 클릭하면,  페이지가 안뜨고, 저렇게 다운로드 창이 떠.

## ess4-t057-a1 · AI

확인했어. **이번에는 재개 버튼 표시 여부보다 앞선 문제야. 진행 내역 페이지가 화면으로 열리지 않고, `guntae_change_status_r1.kbs`라는 파일로 다운로드되고 있어.**

**저장 창은 ‘취소’로 닫아줘. 파일을 저장해서 여는 방식으로 진행할 필요는 없어. 먼저 해당 BSP 페이지의 `MIME Type` 설정부터 확인하자.**

## 1. 가장 먼저 확인할 것은 페이지의 응답 형식이야

브라우저는 서버가 보내는 **`Content-Type`으로 내용의 형식을 판단**하고, **`Content-Disposition: attachment`가 있으면 다운로드로 처리**할 수 있어. 지금 증상에서는 HTML 페이지가 다운로드용 형식으로 전달되는지를 먼저 확인해야 해. 다만 **실제 응답 헤더는 아직 확인하지 못했으므로 원인을 확정한 것은 아니야.** [MDN Web Docs+1](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Type)

우선 가장 간단하게 확인할 수 있는 곳은 **새로 만든 진행 내역 페이지의 Properties 탭**이야.

## 2. SE80에서 이 페이지의 MIME Type을 확인해 줘

### ① 진행 내역 페이지 열기

SE80에서 아래 대상으로 들어가.

| 항목 | 선택할 대상 |
| --- | --- |
| 왼쪽 객체 유형 | **BSP Application — BSP 응용프로그램** |
| 응용프로그램 이름 | **`ZHR0008`** |
| 페이지 위치 | **Pages with Flow Logic — 흐름 로직이 있는 페이지** |
| 페이지 이름 | **`guntae_change_status_r1.kbs`** |

기존 안내서에서도 이 객체는 MIME 파일이나 화면 조각이 아니라 **흐름 로직이 있는 BSP 페이지**로 생성하도록 되어 있어. **MIMEs 폴더에 새 파일을 임포트하는 작업이 아니야.**

### ② `Properties` 탭 선택

페이지 상단의 **`Properties` — 속성** 탭을 열어.

**`GV_PC_HTML`, `GV_PC_TOKEN`을 등록했던 `Page Attributes` 탭과는 다른 탭이야.** 이번에 찾을 항목은 **`MIME Type` 또는 `MIME 유형`**이야. BSP 페이지의 응답 형식은 이 속성에서 지정할 수 있어. [SAP Community](https://community.sap.com/t5/technology-q-a/bsp-smartforms-codepage-problem/qaq-p/822940?utm_source=chatgpt.com)

### ③ MIME Type 값 확인

이 페이지는 HTML 화면이므로 다음 형식이어야 해.

```
text/html; charset=utf-8
```

현재 값에 따라 이렇게 진행하면 돼.

| 현재 MIME Type | 진행 방법 |
| --- | --- |
| **공란 또는 `application/octet-stream` 등 HTML이 아닌 값** | 현재 값을 캡처해 보관하고, 위의 **`text/html; charset=utf-8`**로 변경 |
| **`text/html` 또는 이미 위와 같은 HTML 형식** | 다운로드 원인을 이것만으로 설명할 수 없으므로 **다른 설정은 건드리지 않음** |

`text/html; charset=utf-8`은 HTML 내용과 UTF-8 문자 인코딩을 지정하는 형식이야. [MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Type)

값을 변경했다면 **저장 → 구문 검사 → 해당 페이지 활성화**까지 해줘. **페이지 이름의 `.kbs`를 `.html`로 바꾸거나, 결재 함수·클래스를 다시 수정하는 작업은 하지 않아.**

## 3. 변경했다면 같은 결재자 창에서 링크를 다시 열어봐

다운로드 창과 그때 열린 빈 탭만 닫고, **승인했던 결재자 계정으로 로그인된 Chrome 창**의 R1 결재 목록에서 **「기승인 변경·취소 요청의 변경 전·후 / 처리 진행 내역 확인」** 링크를 다시 눌러줘.

**지금은 페이지가 정상적으로 표시되는지만 확인하자.** 일반 결재 목록에서 승인을 다시 누르거나 반려·회수로 대신 처리하지 마.

**MIME Type이 이미 HTML로 맞게 되어 있거나, 수정 후에도 다운로드 창이 뜨면 해당 페이지의 `Properties` 화면을 보여줘. 그 경우에는 `Content-Disposition` 등 실제 응답 헤더와 링크 설정을 확인해야 해.**

## ess4-t058-u1 · 사용자



## ess4-t058-a1 · AI

응. **수정할 설정이 확인됐어. 지금 `MIME 유형`이 `application/octet-stream`으로 되어 있어.**

이 값은 HTML 화면이 아니라 **일반 바이너리 파일로 전달하는 형식**이라, 브라우저가 ‘다른 이름으로 저장’ 창을 띄우는 증상과 맞아. [MDN Web Docs](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/MIME_types?utm_source=chatgpt.com)

## 1. 지금 보이는 ‘MIME 유형’ 한 칸만 변경해

`guntae_change_status_r1.kbs`를 **변경 모드**로 열고, 화면 위쪽 **Description 바로 아래의 `MIME 유형`** 값을 바꿔줘.

| 항목 | 입력값 |
| --- | --- |
| 현재 값 | `application/octet-stream` |
| **변경할 값** | **`text/html; charset=utf-8`** |

**아래 내용을 그대로 복사해서 그 칸에 입력하면 돼.**

```
text/html; charset=utf-8
```

HTML 내용과 UTF-8 문자 인코딩을 지정하는 값이야. [MDN Web Docs](https://developer.mozilla.org/ko/docs/Web/HTTP/Reference/Headers/Content-Type?utm_source=chatgpt.com)

**페이지 이름이나 소스는 변경하지 않아.** `Page with Flow Logic`, 상태 유지 옵션, 캐시 설정 등 나머지도 지금은 그대로 둬.

## 2. 저장·활성화 후 링크를 다시 열어줘

1. MIME 유형 변경 후 **저장 → 구문 검사 → 해당 페이지 활성화**해.
2. Chrome의 **다운로드 창은 취소**하고, 다운로드 때문에 열린 빈 탭만 닫아.
3. **승인했던 결재자가 로그인한 Chrome 창**에서 R1 결재 목록의 **「기승인 변경·취소 요청의 변경 전·후 / 처리 진행 내역 확인」** 링크를 다시 눌러줘.

이번에는 **다운로드 대신 진행 내역 웹페이지가 열리는지**, 그리고 **문서 `000010211991`에 「결재 마무리 재개」 버튼이 보이는지** 확인하면 돼.

**아직 재개 버튼이나 일반 승인 버튼은 누르지 말고, MIME 변경 후 열린 화면만 보여줘.**

## ess4-t059-u1 · 사용자

이제 이렇게 잘 뜨네

## ess4-t059-a1 · AI

좋아. **이제 진행 내역 페이지가 정상적으로 열리고, 「결재 마무리 재개」 버튼도 보이는 것까지 확인됐어.** 다운로드되던 문제는 해결됐고, 이제 남아 있는 결재 마무리를 진행하면 돼.

## 지금 보이는 「결재 마무리 재개」를 한 번 눌러줘

**앞서 전달한 `WF_CHECK`·`WF_FINISH`의 `WF_STATE01` 수정본 두 개가 적용·활성화된 상태에서** 아래 순서로 진행해.

1. **승인을 시작했던 결재자 `30751`의 현재 로그인 상태를 유지해.**
2. 지금 화면의 **결재문서 `000010211991`**인지 확인하고, 아래 **「결재 마무리 재개」를 한 번만 클릭**해.
3. 처리가 끝나면 알림 내용을 확인하고, **「최신 상태 조회」**를 눌러 이 문서의 상태가 바뀌었는지 확인해.

이것은 일반 결재 목록에서 **‘승인’을 다시 누르는 작업이 아니야.** `HR_DONE` 단계에서 이미 반영된 근태를 다시 처리하지 않고, **남은 결재 마무리를 이어가도록 마련한 경로**야.

## 재개 후 확인할 결과

화면의 **‘결재 마무리 필요’가 ‘승인 완료’로 바뀌는지** 확인하면 돼. 내부 처리 단계로는 **`HR_DONE → DONE`**이 목표야. 아직 버튼을 실행한 결과는 아니므로, 지금 전체 승인이 완료된 것은 아니야.

**오류가 나오거나 계속 ‘결재 마무리 필요’로 남으면 버튼을 반복해서 누르지 마.** 일반 승인·반려·회수로 대신 처리하지 말고, 나온 메시지 그대로 확인하자.

**재개 버튼을 한 번 누른 뒤 나타난 알림과, 문서 `000010211991`의 최종 상태가 보이는 화면을 보내줘. 성공 표시가 나오면 실제 근태와 연차 사용량의 최종 대조까지 이어가자.**

## ess4-t060-u1 · 사용자

눌렀는데  아무런 반응이 없어

## ess4-t060-a1 · AI

**제공했던 버튼 코드에서 BSP 이벤트 연결용 항목이 빠진 것을 확인했어.** 버튼은 표시되지만, 눌렀을 때 **`OnInputProcessing`이라는 서버 처리 이벤트를 호출하도록 지정한 항목이 없는 상태**야. 앞서 보내준 `STATUS_HTML` 소스에도 `pc_token`, `pc_id`, `pc_action`만 들어 있어.

SAP BSP에서는 `onInputProcessing` 형식의 폼 항목으로 입력 처리 이벤트를 연결해. **이 누락은 지금처럼 클릭해도 재개 처리가 실행되지 않는 증상을 설명할 수 있어.** 다만 방금 클릭의 실제 서버 실행 결과는 아직 확인하지 못했으므로, 아무 데이터도 바뀌지 않았다고 단정하지는 않을게. [SAP 도움말 포털+1](https://help.sap.com/docs/SAP_NETWEAVER_AS_ABAP_FOR_SOH_740/0884fb55479542b38fb676e8f5b250a1/4c562e8cf69c4d4de10000000a15822b.html?utm_source=chatgpt.com)

## 1. 먼저 「최신 상태 조회」만 한 번 눌러줘

재개 버튼을 반복해서 누르지 말고, 현재 페이지 위쪽 **「최신 상태 조회」**로 문서 `000010211991`을 확인해.

**이미 ‘승인 완료’로 바뀌었다면 재개하지 않아도 돼.** 계속 **‘결재 마무리 필요’**라면 아래 버튼 연결을 수정하자.

## 2. `STATUS_HTML`의 버튼 생성 부분만 수정하면 돼

**SE24 → `ZCL_HR_GUN_R1_PC` → `STATUS_HTML`**로 들어가.

BSP 페이지의 Layout이나 `WF_FINISH`가 아니라, **버튼 HTML을 만드는 `STATUS_HTML` 메서드**야.

현재 소스에서 다음처럼 시작하는 부분을 찾아줘.

```
CONCATENATE '<form method="post">...
```

그 **`CONCATENATE`부터 `INTO lv_line.`까지 한 문장만** 아래 코드로 교체해.

```
* Start-Modify / XA32762 / GNT-R1-U22 / 2026-10-14 / resume-event01
* BSP OnInputProcessing 연결 추가
* 기존 POST, 토큰, 요청번호, pc_action은 유지
        CONCATENATE
          '<form method="post">'
          '<input type="hidden" name="onInputProcessing" value="resume">'
          '<input type="hidden" name="pc_token" value="' lv_token
          '"><input type="hidden" name="pc_id" value="' lv_rid
          '"><button type="submit" name="pc_action" value="resume">'
          '결재 마무리 재개</button></form>'
          INTO lv_line.
* End-Modify / XA32762 / GNT-R1-U22 / resume-event01
```

핵심은 추가된 이 한 줄이야.

```
<input type="hidden" name="onInputProcessing" value="resume">
```

**바깥의 처리자·상태 검사와 아래 줄은 그대로 유지해.**

```
IF ls_h-phase = 'HR_DONE' AND ls_h-actor = sy-uname.
```

```
CONCATENATE r_html lv_line INTO r_html.
```

버튼을 누구에게 보여줄지 정하는 기존 조건은 바꾸지 않고, **클릭한 요청을 기존 처리 이벤트에 연결하는 것만 보완**하는 거야.

### 교체용 파일

`STATUS_HTML_RESUME_EVENT01_FULL.txt` · `R1_RESUME_EVENT01_20261014_XA32762.zip`

전체본에는 앞서 적용한 `REASON`·`LAST_ERROR`·`RID`의 `STRING` 호환성 수정도 포함했어. **현재 SAP에서 별도로 추가한 수정이 있다면 전체 덮어쓰기보다 위의 버튼 블록만 교체해. 두 방법을 모두 적용할 필요는 없어.**

## 3. 저장·활성화 후, 새로 조회한 화면에서 확인하자

**저장 → 구문 검사 → 클래스 활성화**를 마친 다음, 승인했던 결재자 `30751`의 브라우저에서 **「최신 상태 조회」**를 눌러 새 버튼 코드를 받아야 해. 수정 전에 열어둔 화면의 버튼을 그대로 누르면 안 돼.

그리고 이 페이지의 **`Event Handler → OnInputProcessing`에는 기존 재개 처리 코드가 있어야 해.** 제공본 기준으로 다음 구문을 포함하는 코드야.

```
lv_action = request->get_form_field( 'pc_action' ).
IF lv_action = 'resume'.
```

그 아래에서 토큰·처리자·`HR_DONE`을 검사하고 `zcl_hr_gun_r1_pc=>decide`를 호출해. **이 이벤트가 비어 있다면 버튼을 다시 누르지 말고, 해당 이벤트 소스부터 확인해야 해.** 묶음에는 대조용 이벤트 원본도 넣었어.

기존 이벤트가 연결되어 있고 `WF_STATE01`의 두 메서드도 활성화된 상태라면, **문서 `000010211991`의 「결재 마무리 재개」를 한 번만** 눌러 확인하자.

**한 가지 정정할게. 제공된 재개 이벤트는 팝업을 띄우는 것이 아니라, 결과를 페이지 상단의 문장으로 출력하도록 되어 있어.** 팝업 유무가 아니라 **페이지 상단 결과 문구와 ‘승인 완료’ 전환 여부**를 확인해야 해.

이번 보완은 생성되는 폼과 기존 검사 조건의 보존을 로컬에서 확인했지만, SAP에서 이벤트 실행·결재 완료까지 시험한 것은 아니야. **수정 후에도 반응이 없으면 반복 클릭하지 말고, 현재 `guntae_change_status_r1.kbs → OnInputProcessing` 전체 소스를 보내줘.**

STATUS_HTML_RESUME_EVENT01_BLOCK.txt문서STATUS_HTML_RESUME_EVENT01_FULL.txt문서

## ess4-t061-u1 · 사용자

`STATUS_HTML`  ...만 수정하고 다시 해봤는데, 똑같이 아무런 반응이 없어. 더 변경할게 있는거야 ?

## ess4-t061-a1 · AI

**`STATUS_HTML` 외에, 실제 재개 처리를 받는 BSP 페이지의 이벤트 코드도 확인해야 해.** 다만 지금 증상만으로 “어느 코드가 빠졌다”고 확정해서 또 수정하면 안 돼. 앞서 버튼 수정만으로 해결될 것처럼 안내한 건 부족했어.

## 1. 버튼과 실제 처리 코드는 서로 다른 곳에 있어

| 위치 | 역할 | 지금 할 일 |
| --- | --- | --- |
| **클래스 → `STATUS_HTML`** | 재개 버튼과 전송할 값을 만듦 | 방금 적용한 수정은 유지 |
| **BSP 페이지 → `OnInputProcessing`** | 버튼 요청을 받아 검사하고 실제 재개 처리를 호출함 | **현재 소스 확인 필요** |
| **BSP 페이지 → `OnInitialization`** | 페이지를 표시할 내용과 토큰을 준비함 | **현재 소스 확인 필요** |

기존 적용 안내서에서도 이 페이지는 **Layout뿐 아니라 `OnInitialization`과 `OnInputProcessing`을 각각 등록하는 구성**이야. `STATUS_HTML`을 수정한다고 페이지의 이벤트 코드까지 자동으로 추가되는 것은 아니야.

또한 BSP 처리 순서상 **입력 처리 후 초기화 이벤트가 이어서 실행될 수 있어서**, 이벤트가 실행됐어도 그 결과 문구를 초기화 코드가 덮어쓰는지 함께 봐야 해. 이것은 확인할 가능성이지, 현재 원인으로 확정한 것은 아니야. [SAP 도움말 포털](https://help.sap.com/docs/SAP_NETWEAVER_740/0884fb55479542b38fb676e8f5b250a1/4c562903f69c4d4de10000000a15822b.html?utm_source=chatgpt.com)

## 2. 지금은 아래 두 곳의 소스를 한 번에 보내줘

**SE24 클래스 화면이 아니라 SE80의 BSP 페이지**로 들어가면 돼.

```
SE80
 → BSP Application: ZHR0008
 → Pages with Flow Logic
 → guntae_change_status_r1.kbs
 → Event Handler 탭
```

여기에서 **`OnInputProcessing`과 `OnInitialization`을 각각 선택한 뒤, 현재 소스 전체를 복사해서 보내줘.** 한 메시지에 아래처럼 나눠 붙여도 돼.

```
[OnInputProcessing]
여기에 현재 소스 전체

[OnInitialization]
여기에 현재 소스 전체
```

**이벤트가 비어 있다면 새 코드를 임의로 넣지 말고 ‘비어 있음’이라고 알려줘.**

이 두 코드를 보면 버튼에서 보낸 `pc_action`, `pc_id`, `pc_token`을 실제로 받는지, 재개 메서드까지 호출하는지, 처리 결과가 화면에 남는지를 연결해서 확인할 수 있어.

## 3. 지금 수정한 것은 그대로 유지해

**`STATUS_HTML`, MIME 유형, `WF_CHECK`·`WF_FINISH` 수정은 되돌리지 마.** 현재 제공된 `STATUS_HTML` 수정본에는 버튼의 POST 전송과 `onInputProcessing`, 토큰·요청번호 항목이 들어 있어. 이제 확인할 대상은 그 요청을 받는 페이지 쪽이야.

**현재 SAP에 들어 있는 두 이벤트 소스를 보내줘. 그전에는 재개 버튼을 반복해서 누르거나 일반 승인·반려로 대신 처리하지 말자.**

## ess4-t062-u1 · 사용자

* XA32762 / GNT-R1-U22 / 2026-10-12 / connect01
DATA: lv_token TYPE string, lv_rid TYPE string, lv_action TYPE string,
      lv_message TYPE string, lv_found TYPE char1, ls_header TYPE ztgunr1h,
      lx_pc TYPE REF TO cx_root.
lv_action = request->get_form_field( 'pc_action' ).
IF lv_action = 'resume'.
  lv_token = request->get_form_field( 'pc_token' ).
  lv_rid = request->get_form_field( 'pc_id' ).
  IF request->get_header_field( '~request_method' ) <> 'POST' OR
     gv_pc_token IS INITIAL OR lv_token <> gv_pc_token OR strlen( lv_rid ) <> 22.
    lv_message = '화면이 만료되었습니다. 최신 상태를 다시 조회하세요.'.
  ELSE.
    SELECT SINGLE * INTO ls_header FROM ztgunr1h WHERE rid = lv_rid.
    IF sy-subrc <> 0 OR ls_header-phase <> 'HR_DONE' OR ls_header-actor <> sy-uname.
      lv_message = '현재 사용자가 재개할 수 있는 요청이 아닙니다.'.
    ELSE.
      TRY.
        zcl_hr_gun_r1_pc=>decide( EXPORTING i_serial = ls_header-zserial
          i_decision = ls_header-decision i_wiid = ls_header-wi_id
          IMPORTING e_found = lv_found e_message = lv_message ).
        IF lv_found IS INITIAL. lv_message = '요청을 찾을 수 없습니다.'. ENDIF.
        IF lv_message = 'T'. lv_message = '결재 마무리를 완료했습니다.'. ENDIF.
      CATCH cx_root INTO lx_pc.
        lv_message = '자동 재개를 중단했습니다. 최신 상태와 담당자 확인이 필요합니다.'.
      ENDTRY.
    ENDIF.
  ENDIF.
  gv_pc_token = zcl_hr_gun_r1=>uuid22( ).
  gv_pc_html = zcl_hr_gun_r1_pc=>status_html( gv_pc_token ).
  lv_message = cl_http_utility=>escape_html( lv_message ).
  CONCATENATE '<p role="status">' lv_message '</p>' gv_pc_html INTO gv_pc_html.
ENDIF.

* XA32762 / GNT-R1-U22 / 2026-10-12 / connect01
IF gv_pc_token IS INITIAL. gv_pc_token = zcl_hr_gun_r1=>uuid22( ). ENDIF.
gv_pc_html = zcl_hr_gun_r1_pc=>status_html( gv_pc_token ).
response->set_header_field( name = 'Cache-Control' value = 'no-store' ).

…

## ess4-t062-a1 · AI

두 소스 확인했어. **`OnInputProcessing`에 재개 처리 코드는 이미 들어가 있어. 추가로 고칠 부분은 ‘처리 결과를 화면에 남기는 방식’이야.**

지금은 입력 처리에서 결과 문구를 붙인 뒤,

```
CONCATENATE '<p role="status">' lv_message '</p>' gv_pc_html INTO gv_pc_html.
```

초기화 이벤트가 다음 코드로 **화면 내용을 다시 만들면서 그 문구를 없앨 수 있어.**

```
gv_pc_html = zcl_hr_gun_r1_pc=>status_html( gv_pc_token ).
```

SAP BSP에서 같은 페이지의 입력 처리 후 초기화·화면 출력으로 이어지는 경로에서는 이런 덮어쓰기를 막아야 해. **다만 이것은 결과가 안 보이는 문제이고, 실제 재개 처리가 어디에서 멈췄는지는 별도로 확인해야 해.** [SAP 도움말 포털+1](https://help.sap.com/saphelp_gbt10/helpdata/en/4c/562903f69c4d4de10000000a15822b/content.htm?no_cache=true&utm_source=chatgpt.com)

이번에는 **결과 문구를 보존하고, 입력 이벤트가 실행됐는지와 `DECIDE`를 호출했는지도 표시하는 수정본**을 만들었어. **`STATUS_HTML`은 다시 수정하지 않아.**

## 1. 같은 BSP 페이지에 속성 한 줄만 추가해

대상은 다음 페이지야.

```
SE80
 → BSP Application: ZHR0008
 → guntae_change_status_r1.kbs
```

**`Page Attributes` 탭**에서 아래 한 줄을 추가해. SE24 클래스의 속성이 아니라 **BSP 페이지의 속성**이야.

| Attribute | Typing | Associated Type | Auto | 내역 |
| --- | --- | --- | --- | --- |
| **`GV_PC_INPUT_DONE`** | `TYPE` | **`CHAR1`** | **체크 해제** | 현재 요청의 입력 처리 여부 |

기존 **`GV_PC_TOKEN`, `GV_PC_HTML`은 그대로 유지**해. 페이지 속성은 해당 페이지의 이벤트와 Layout 사이에서 값을 공유할 수 있어서, 이번 요청에서 만들어 놓은 처리 결과를 구분하는 데 사용했어. [SAP 도움말 포털](https://help.sap.com/saphelp_gbt10/helpdata/en/4c/495ab29f9935b8e10000000a42189b/content.htm?no_cache=true&utm_source=chatgpt.com)

## 2. Event Handler에서 아래 세 곳을 적용해

**현재 소스를 먼저 백업한 뒤, 아래 파일을 각각 해당 이벤트에 적용하면 돼.** 두 이벤트의 전체 수정본과, 요청 시작 시 추가할 짧은 코드를 나눠 두었어.

| 이벤트 | 적용 방법 | 적용 파일 |
| --- | --- | --- |
| **`OnRequest`** | 아래 초기화 코드를 **맨 앞에 추가** | `OnRequest_ADD_RESUME_PAGE02.txt` |
| **`OnInputProcessing`** | 네가 보내준 첫 번째 소스를 **전체 교체** | `OnInputProcessing_RESUME_PAGE02.txt` |
| **`OnInitialization`** | 네가 보내준 두 번째 소스를 **전체 교체** | `OnInitialization_RESUME_PAGE02.txt` |

**`R1_RESUME_PAGE02_20261014_XA32762.zip`**

### `OnRequest`에는 이 코드가 추가되는 거야

```
* Start-Add / XA32762 / GNT-R1-U22 / 2026-10-14 / resume-page02
* 현재 요청의 입력 처리 여부만 초기화
CLEAR gv_pc_input_done.
* End-Add / XA32762 / GNT-R1-U22 / resume-page02
```

`OnRequest`가 비어 있다면 이 코드만 넣으면 되고, 기존 코드가 있다면 **삭제하지 말고 맨 앞에 추가**해. **여기에서 `GV_PC_TOKEN`은 초기화하지 마.**

각 파일은 **이벤트 본문용**이므로 `METHOD`·`ENDMETHOD`를 추가하지 않고, 세 파일을 한 이벤트에 합쳐 넣지도 않아.

### 나머지 두 이벤트는 이렇게 달라져

**`OnInputProcessing`**은 입력 이벤트가 실행됐다는 표시를 남기고, 기존 토큰·요청번호·처리자 검사를 유지하면서 결과를 출력해. `pc_action`이 전달되지 않은 경우도 아무 설명 없이 넘어가지 않고 문구를 보여줘.

**`OnInitialization`**은 이번 요청에서 입력 처리가 이미 결과 화면을 만들었다면 **그 내용을 덮어쓰지 않아.** 입력 이벤트 실행 표시 없이 POST만 들어왔다면, 재개 처리를 임의로 실행하지 않고 그 상황을 화면에 표시해.

**기존 승인 레포트 `ZRPTH_GUN_GULJAE_R1`은 별도 객체이고, 이번 수정 대상이 아니야.** `WF_CHECK`·`WF_FINISH`, Layout, MIME 유형도 이번에는 그대로 유지하면 돼.

## 3. 저장·활성화 후에는 이 순서로 확인해

속성과 세 이벤트를 모두 반영한 다음 **저장 → 구문 검사 → 페이지 활성화**해.

그다음 **승인을 시작한 결재자 `30751`의 브라우저**에서 「최신 상태 조회」를 눌러줘. 새 코드가 적용되면 화면 위쪽에 다음 표시가 나와.

```
[RESUME-PAGE02 / VIEW] 진행 내역 조회 화면입니다.
```

문서 `000010211991`이 이미 **‘승인 완료’라면 재개하지 않아도 돼.** 여전히 **‘결재 마무리 필요’**이고 앞서 제공한 `WF_STATE01` 두 메서드도 활성화된 상태라면, **「결재 마무리 재개」를 한 번만** 눌러줘.

**이번에는 클릭 직후, 「최신 상태 조회」나 브라우저 새로고침을 누르지 말고 화면 상단부터 확인해.** 새로 조회하면 직전 클릭의 결과 문구가 조회 화면으로 바뀌기 때문이야.

## 4. 이제는 다음처럼 어디까지 실행됐는지 보여

| 화면 상단 표시 | 의미 |
| --- | --- |
| **`INPUT` + `DECIDE_CALLED=NO`** | 입력 이벤트는 실행됐지만, 조건 검사 등으로 재개 메서드 호출 전에 멈춤 |
| **`INPUT` + `DECIDE_CALLED=YES`** | 재개 메서드 호출문에 도달함. **성공 여부는 함께 출력된 결과 문구와 문서 상태로 판단** |
| **`POST-NO-INPUT`** | POST는 읽었지만 이번 요청의 입력 이벤트 실행 표시를 확인하지 못함 |
| **`결재 마무리를 완료했습니다.`** | 기존 `DECIDE`가 성공값 `T`를 반환함 |

예를 들어 토큰 문제라면 이제는 **“서버의 화면 토큰이 없습니다”** 또는 **“화면 토큰이 일치하지 않습니다”**라는 문구가 남도록 했어. 토큰값 자체는 출력하지 않아.

**이 수정본은 ‘성공으로 강제 처리하는 코드’가 아니야.** 기존 POST·토큰·요청번호·`HR_DONE`·처리자 검사를 유지했고, 실제 재개는 기존 `DECIDE`만 호출해. 따라서 버튼 실행은 여전히 실제 결재 마무리 작업이며, 단순 조회는 아니야.

로컬에서 소스 구조와 보호 조건은 확인했지만 **SAP 구문 검사·이벤트 실행은 아직 검증하지 않았어.**

**적용 후 한 번 재개한 화면의 맨 위 결과 문구와 `DECIDE_CALLED` 표시를 보내줘. 이번에는 그 문구를 확인하기 전에 새로고침하거나 재개 버튼을 다시 누르지 않으면 돼.**

OnRequest_ADD_RESUME_PAGE02.txt문서OnInputProcessing_RESUME_PAGE02.txt문서OnInitialization_RESUME_PAGE02.txt문서

## ess4-t063-u1 · 사용자

이렇게 나오는데 ?

## ess4-t063-missing · AI

[공유 화면에 AI 응답 본문이 표시되지 않은 위치]

## ess4-t064-u1 · 사용자

결재자 사번으로 로그인 하니까 이렇게 됐어!

## ess4-t064-a1 · AI

좋아! **이번에는 재개 요청이 실제로 실행됐고, 문서 `000010211991`이 ‘승인 완료’로 바뀐 것까지 확인됐어.** 화면만 열린 것이 아니라 **결재 마무리 처리에서 성공 응답을 받은 상태**야.

## 1. 이제 재개 처리는 성공한 거야

이번 화면에는 다음 세 가지가 함께 나왔어.

| 화면 표시 | 확인된 내용 |
| --- | --- |
| `INPUT / HTTP=POST / ACTION=resume` | 버튼 요청이 서버의 입력 처리 이벤트로 전달됨 |
| `DECIDE_CALLED=YES` + **결재 마무리를 완료했습니다.** | 재개 메서드를 호출했고, 성공값 `T`를 반환받음 |
| **`00032762 · 승인 완료`** | 해당 요청의 진행 상태도 승인 완료로 표시됨 |

성공 문구는 무조건 출력하는 문장이 아니라, `DECIDE`가 성공값을 반환했을 때 표시하도록 되어 있어.

**결재자 계정으로 로그인한 것도 중요한 조건이 맞아.** 현재 재개 코드는 기록된 처리자와 로그인 계정이 같아야 실행돼. 이번에는 그 조건을 통과한 거야. 다만 앞서 보완한 버튼·이벤트 연결도 함께 적용된 결과이므로, 이전 문제가 전부 로그인 하나 때문이었다고 보지는 않을게.

**이 문서의 재개 버튼이나 일반 승인 버튼을 더 누를 필요는 없어. 보정 프로그램도 다시 실행하지 않아.**

## 2. 다음은 추가 수정 없이, 승인 완료 후 데이터만 대조하자

지금 확인한 것은 **재개 성공과 화면의 승인 완료 상태**야. 마지막으로 **결재 마무리 과정에서 근태가 다시 생성되거나 연차가 중복 차감되지 않았는지** 확인하면 이번 날짜 이동 시험을 마무리할 수 있어.

이미 사용한 **조회용 프로그램**을 다음 값으로 한 번 실행해 줘.

**SE38 → `ZHR_GUN_R1_REJECT_CHECK` → 실행**

```
P_PERNR = 00032762
P_ORIG  = 000010211986
P_KEY1  = 000010211991
P_KEY2  = 공란
```

**`REJECT_CHECK`가 맞고, 실제 보정용 `REJECT_SYNC`는 아니야.** 이 조회 프로그램은 신청·결재·근태·연차 상태를 읽어 출력하며, 승인이나 데이터 수정을 실행하지 않아.

이번에 대조할 **최종 목표값**은 아래와 같아.

| 확인 대상 | 확인할 결과 |
| --- | --- |
| R1 처리 단계 | **`DONE`**, 결정 `Y` |
| 결재 작업 `000051859147` | **`COMPLETED`**, 해당 대기 목록 정리 여부 |
| 실제 근태 | **11월 3~4일 2일 + 11월 6일 1일**, 총 3일 |
| 연차 사용량 | **발생 20일·사용 20일**, 잔여 0일 유지 |

참고로 조회 결과의 `ORIGINAL_HR_EQUAL=NO`는 **변경 전 근태와 변경 후 근태를 비교하기 때문에 나올 수 있어.** 이번에는 그 표시를 억지로 `YES`로 만드는 것이 아니라, **변경계획대로 두 구간이 남아 있고 사용량이 유지되는지**를 기준으로 확인하면 돼.

**조회 결과의 1~5번과 7번 부분을 보내줘. 그 결과까지 맞으면 이번 ‘잔여 연차 0일에서 3일을 유지한 날짜 이동 + 결재 재개’ 시험은 완료로 정리하자.**

## ess4-t065-u1 · 사용자



## ess4-t065-a1 · AI

좋아. **이번 문서 `000010211991`은 결재 완료 후 실제 근태·연차·대기 목록까지 맞게 정리된 것으로 확인됐어. 이번에 진행한 ‘잔여 연차 0일에서 총 3일을 유지한 날짜 이동 + 중단 후 결재 재개’ 시험은, 보내준 최종 조회 범위에서 통과로 정리하면 돼.**

## 1. 최종 결과가 모두 맞아

| 확인 대상 | 이번 최종 결과 |
| --- | --- |
| 신청 `ZTHR0080` | **결재값 `Y` — 승인** |
| 결재 연동 `ZTHR0080_KOBIS` | **결재값 `Y`** |
| 상위 워크플로 `000051859145` | **`COMPLETED`** |
| 결재 작업 `000051859147` | **`COMPLETED`**, 실제 처리자 `30751` |
| 조회된 대기 목록 | **상위·결재 작업의 `SWWUSERWI` 0건, 상위 작업의 `ZWFORGTASK` 0건** |
| 실제 근태 `PA2001` | **11월 3~4일 2일 + 11월 6일 1일**, 유형 `1021` |
| R1 처리 이력 | **`PHASE=DONE`, `DECISION=Y`, `LAST_ERROR` 공란** |

단순히 웹화면에 ‘승인 완료’만 나온 것이 아니라, **이번에는 신청·결재 연동의 승인값과 워크플로 종료, 대기 목록 정리까지 조회 결과로 확인된 거야.**

연차도 해당 공제 기간 **2026/04/01~2027/03/31**에서 발생량과 사용량이 각각 **20일**이고, 저장된 연차 행과 현재 행이 같다는 `QUOTA_FULL_ROW_EQUAL=YES`가 나왔어. **결재 마무리 재개 후에도 사용량이 늘지 않고, 잔여는 0일로 유지됐어.**

```
변경 전 실제 근태: 11월 3일·4일·5일 → 총 3일
변경 후 실제 근태: 11월 3일·4일·6일 → 총 3일

연차 사용량: 20일 → 20일
잔여 연차:   0일 → 0일
```

**이 문서에 대해 재승인·재개·반려 이력 보정을 다시 실행할 필요는 없어.**

## 2. 아래쪽의 `NO`는 다시 고쳐야 한다는 뜻이 아니야

현재 점검 프로그램은 **변경 전 스냅샷과 현재 데이터를 그대로 비교**하기 때문에, 승인 후에는 차이가 있는 항목에 `NO`와 `manual review required`가 출력돼. 이것만으로 처리 실패라고 판단하면 안 돼.

**`ORIGINAL_APPLICATION_EQUAL=NO`**
현재 원본 신청에는 `ZUTEXT=변경`이 표시돼 있어. 즉, 저장 당시 원본과 현재 신청 행이 완전히 같지는 않다는 결과야. 다만 이 출력은 신청 행의 모든 차이 필드를 나열한 것은 아니므로, 차이가 그 필드 하나뿐이라고 단정하지는 않을게.

**`ORIGINAL_HR_EQUAL=NO`와 `EXTRA_HR_OCCURRENCES_IN_PLAN=2`**
실제 근태가 **11월 3~5일 한 구간에서 11월 3~4일·11월 6일 두 구간으로 바뀌었으니**, 변경 전과 기간·일수·식별키가 달라져. `EXTRA=2`도 변경 전 스냅샷에 없는 키를 발견한 횟수이지, **중복 근태가 두 건 생겼다는 뜻은 아니야.** 현재 전체 신청기간 조회에서는 계획대로 두 행, 합계 3일이 확인돼.

**이 비교를 `YES`로 만들려고 원본 스냅샷이나 `PA2001`을 수정하지 않으면 돼.**

## 3. 다음은 ‘승인된 연차 1일을 반차로 변경’ 시험이야

이번에 완료한 것은 **이 한 건의 날짜 이동과 결재 재개**야. 반차 변경·부분취소·전체취소, 그리고 수정본으로 처음부터 중단 없이 승인되는 경로까지 모두 검증됐다는 뜻은 아니야. 적용 안내서의 다음 단계는 **승인된 결과에서 연차 1일을 반차로 바꿔, 실제 잔여가 0.5일 증가하는지 확인하는 시험**이야.

이번 결과 중 **11월 6일 연차 1일**을 반차로 바꾸는 것이 다음 시험 대상으로 적절해. 다른 연차 처리가 없다는 전제에서, 최종 목표는 **사용량 20일 → 19.5일, 잔여 0일 → 0.5일**이야. 다만 승인 결과 구간에는 별도 업무 문서번호가 생성되는 설계이므로, **기존 원본 `000010211986`이나 변경요청 `000010211991`을 곧바로 다시 선택하지 말고 실제 결과행부터 확인하자.**

**이제 R1 신청 화면의 ‘신청 이력’에서 11월 3~4일과 11월 6일의 승인 결과행이 보이는 부분을 보여줘. 이번에는 SE38 점검 결과나 진행 내역 페이지가 아니라, 신청자가 근태를 선택하는 이력 목록이야. 그 화면에서 다음 반차 변경 대상 한 건을 정확히 짚고 이어가자.**

## ess4-t066-u1 · 사용자



## ess4-t066-a1 · AI

확인했어. **이번 반차 변경 시험은 맨 위 첫 번째 행인 ‘2026/11/06 하루, 연차휴가 1일, 승인’ 건으로 진행하면 돼.** 바로 아래 **11월 3~4일의 2일짜리 승인 건은 그대로 두는 거야.**

## 1. 맨 위 첫 번째 행만 선택해

선택할 행은 아래 조건이야.

| 화면 항목 | 선택할 행의 값 |
| --- | --- |
| 위치 | **목록 맨 위 첫 번째 행** |
| 구분 / 결재 | 신청 / 승인 |
| 시작일 / 종료일 | **2026/11/06 / 2026/11/06** |
| 일수 / 근태유형 | **1 / 연차휴가** |
| 기승인이력 | `R1 승인문서000010211991` |

**왼쪽 체크박스를 이 행 하나만 체크**하고, 위쪽의 **「결재후변경신청」**을 눌러줘. **「상신전수정」이나 「결재후취소신청」이 아니야.**

아래에 남아 있는 **11월 3~6일 변경신청 이력이나, 이전 11월 3~5일 원본 이력은 이번 선택 대상이 아니야.**

## 2. 11월 6일을 ‘오전반차’로 바꾸고 저장해

이번 시험은 **날짜를 옮기지 않고, 하루 연차를 오전반차로 바꾸는 것**으로 진행하자. 적용 안내서의 다음 시험도 승인된 결과의 연차 1일을 반차로 변경하는 단계야.

날짜별 편집 화면이 열리면 다음처럼 설정해.

```
날짜: 2026/11/06 유지
날짜 선택 체크: 유지
근태유형: 연차 → 오전반차
사유: 승인된 11월 6일 연차를 오전반차로 변경 테스트
```

**11월 6일의 체크를 해제하지 말고 유형만 변경해.** 다른 날짜를 추가하거나 11월 3~4일을 함께 변경하지 않아.

결재자를 확인하고 **저장까지만 진행해 줘. 이번에는 아직 결재상신이나 승인을 누르지 말자.**

## 3. 이번 시험에서 확인할 기대값

다른 근태 처리가 동시에 없다는 전제에서, 최종 목표는 다음과 같아.

| 항목 | 변경요청 저장 후, 승인 전 | 변경 승인 완료 후 목표 |
| --- | --- | --- |
| 11월 6일 실제 근태 | 기존 **연차 1일 유지** | **오전반차 0.5일** |
| 11월 3~4일 실제 근태 | **연차 2일 유지** | **연차 2일 유지** |
| 연차 사용량 | **20일 유지** | **19.5일** |
| 잔여 연차 | **0일 유지** | **0.5일** |

**저장만 했는데 잔여가 먼저 0.5일 늘어나는 것이 아니라, 변경 승인이 완료됐을 때 실제 사용량이 줄어야 해.** 이는 저장·상신 때 원본을 유지하고, 반차 변경 승인 후 잔여 증가를 확인하는 시험 기준이야.

참고로 **신청 이력의 ‘일수’는 반차 승인 후에도 `1`로 표시될 수 있어.** 그 숫자만으로 판단하지 않고, 근태유형과 실제 차감량을 함께 확인할 거야.

**저장 후 「기승인 변경·취소 진행 내역」에서 이번에 새로 생긴 요청의 ‘변경 전·후 날짜와 유형’이 보이는 부분을 보내줘. 저장 중 오류가 나오면 다시 누르지 말고 그 오류 화면을 보여주면 돼.**

## ess4-t067-u1 · 사용자

오전반차 0.5일로 바꾸고 결재상신 버튼ㅇ늘 누르니까 이렇게 메시지가 뜨네

## ess4-t067-a1 · AI

확인했어. **이번 메시지는 ‘오전반차 0.5일이 안 된다’는 뜻이 아니라, 선택한 신청을 지금 상태에서 다시 상신할 수 없다는 경고야.** 화면 아래의 **새 변경신청 행에 이미 ‘상신 Y’가 표시되어 있어서, 실제로 상신이 된 상태인지부터 확인해야 해.** 지금은 결재상신을 다시 누르지 말자.

## 1. 화면에서 중요한 부분이 보여

팝업 아래에 같은 날짜의 두 행이 있어.

| 위치 | 구분 | 상신 | 결재 |
| --- | --- | --- | --- |
| **첫 번째 행** | **기/유형변경신청 — 이번에 만든 변경요청** | **Y** | 공란 |
| 두 번째 행 | 신청 — 11월 6일의 기존 승인 원본 | Y | 승인 |

**새 변경요청에도 ‘상신 Y’가 보이는 점이 핵심이야.** 이미 한 번 상신된 요청을 다시 선택했거나, 승인 원본이 선택에 포함됐을 가능성이 있어. 다만 현재 캡처는 선택이 해제된 화면이라 **어느 행을 선택했는지, 첫 상신이 실제로 완료됐는지는 이 화면만으로 확정할 수 없어.**

따라서 지금 단계에서 **상신 검사를 없애거나, 상신값을 공란으로 바꾸거나, 변경신청을 다시 만들 필요는 없어.**

## 2. 이번에 만든 요청의 진행 내역만 보여줘

팝업을 **「확인」**으로 닫고, 지금 화면에서 **신청 이력 바로 위에 있는 파란색 링크**를 눌러줘.

**「기승인 변경·취소 진행 내역 / 변경 전·후 비교」**

그 페이지에서 **「최신 상태 조회」**를 누른 다음, **이번에 만든 ‘11월 6일 연차 → 오전반차’ 요청 부분**을 캡처하면 돼. 이전에 완료한 `000010211991` 날짜 이동 건이 아니라, **변경 전 기간이 `20261106~20261106`인 새 요청**이야.

확인할 내용은 다음과 같아.

| 보여줄 항목 | 확인 목적 |
| --- | --- |
| **처리 상태와 결재문서번호** | 이미 ‘결재 대기’로 상신됐는지 |
| **변경 전 날짜·유형** | 11월 6일 연차를 대상으로 했는지 |
| **그 아래 변경계획** | **11월 6일 ‘오전반차’**로 저장됐는지 |

진행 내역이 **‘결재 대기’이고 새 결재번호가 연결되어 있다면**, 다시 상신할 필요가 없어. 반대로 **‘저장’인데 신청 목록에만 ‘상신 Y’가 보인다면**, 저장된 신청과 R1 이력의 상태를 대조해야 해. `SAVED`와 `WAIT`는 각각 상신 전 저장과 결재 대기를 구분하는 상태야.

**현재 목록의 ‘일수 1’이나 ‘연차휴가’ 표시만으로 오전반차 계획이 잘못 저장됐다고 판단하지는 않을게. 새 요청의 진행 내역에서 계획과 상신 상태를 함께 확인하자. 승인·반려·회수는 아직 누르지 말고, 그 새 요청 부분만 보여줘.**

## ess4-t068-u1 · 사용자



## ess4-t068-a1 · AI

확인했어. **이번 오전반차 변경요청은 새 결재번호가 연결되고 ‘결재 대기’까지 진행됐어. 변경계획도 11월 6일 ‘오전반차’로 저장되어 있어. 따라서 결재상신을 다시 누르거나 요청을 새로 만들 필요는 없어.**

## 1. 이번 화면에서 확인된 내용

| 항목 | 확인 결과 |
| --- | --- |
| **새 결재문서번호** | **`000010211994`** |
| 현재 상태 | **결재 대기** |
| 변경 대상 | **2026/11/06 하루의 기존 연차** |
| 변경계획 | **2026/11/06 오전반차** |
| 이전 날짜 이동 문서 `000010211991` | 승인 완료 유지 |

앞서 나온 경고만으로는 상신이 실패했다고 볼 수 없었던 거야. **지금은 새 요청이 결재 대기로 연결된 것이 확인됐어.** 다만 그 경고가 중복 상신 시도 때문인지, 선택한 행 때문인지는 이 화면만으로 확정하지 않을게.

## 2. 승인 전에, 이번 요청의 원본번호를 확인해서 조회하자

**이번에는 조회 프로그램의 `P_ORIG`를 예전 값 그대로 사용하면 안 돼.**

지난 날짜 이동 승인 후에는 **결과 구간마다 별도 업무 문서번호를 만드는 설계**야. 이번 반차 변경의 직접 원본은 **11월 6일 하루짜리 승인 결과행**이므로, `000010211986`이나 `000010211991`이라고 미리 가정하지 않고 실제 연결값을 읽어야 해.

### ① SE16N에서 새 요청의 `ZSERIAL2` 확인

**SE16N → `ZTHR0080`**에서 아래 조건으로 조회해.

```
PERNR   = 00032762
ZSERIAL = 000010211994
```

조회된 행의 **`ZSERIAL2` 값**을 복사해 둬. 이 값이 다음 점검 프로그램의 `P_ORIG`에 들어갈 번호야. 기존 점검 프로그램도 신청행의 `ZSERIAL2`와 입력한 `P_ORIG`가 같은지 검사하고 있어. **데이터를 수정하는 것이 아니라 조회만 하는 거야.**

### ② 기존 조회 프로그램 실행

**SE38 → `ZHR_GUN_R1_REJECT_CHECK`**를 아래 값으로 실행해. 새 소스를 적용할 필요는 없어.

| 필드 | 이번 입력값 |
| --- | --- |
| `P_PERNR` | `00032762` |
| **`P_ORIG`** | **①에서 확인한 `ZSERIAL2` 값** |
| **`P_KEY1`** | **`000010211994`** |
| `P_KEY2` | **공란** |

**실제 보정용 `REJECT_SYNC`가 아니라 조회용 `REJECT_CHECK`야.** 두 번째 문서번호를 비우면 이번 요청 한 건만 조회해.

## 3. 이번 승인 전 확인 기준

이제 확인하려는 것은 **“오전반차 계획은 저장됐지만, 실제 근태와 사용량은 승인 전 상태로 유지되는가”**야. 적용 안내서도 저장·상신 단계에서 원본 근태와 사용량을 유지하도록 되어 있어.

다른 근태 처리가 없었다는 전제에서 기대값은 다음과 같아.

| 항목 | **지금 — 승인 전** | 승인 완료 후 목표 |
| --- | --- | --- |
| 11월 6일 실제 근태 | **기존 연차 1일 유지** | 오전반차 0.5일 |
| 실제 연차 사용량 | **20일 유지** | 19.5일 |
| 잔여 연차 | **0일 유지** | 0.5일 |

**현재 진행 내역에 ‘오전반차’가 보이는 것은 변경계획이 맞게 저장됐다는 뜻이지, 실제 차감량이 이미 0.5일로 바뀌었다는 뜻은 아니야.**

**위 값으로 조회한 새 문서 `000010211994`의 결과를 보내줘. `ZSERIAL2`를 확인한 화면은 따로 보낼 필요 없이 그 값을 `P_ORIG`에 넣으면 돼. 이번에는 상신을 반복하지 말고, 결재자의 승인·반려도 이 승인 전 비교를 확인한 다음 진행하자.**

## ess4-t069-u1 · 사용자



## ess4-t069-a1 · AI

확인했어. **이번 오전반차 변경요청 `000010211994`은 승인 전 점검 항목이 맞게 나왔어. 기존 연차 1일은 그대로 유지되고, 변경계획만 0.5일로 저장된 상태야. 이제 개발서버에서 이 한 건의 실제 승인 시험으로 넘어가면 돼.** 아직 오전반차가 실제 반영됐거나 잔여가 늘어난 것은 아니야.

## 1. 이번 결과에서 확인한 내용

| 확인 항목 | 실제 결과 |
| --- | --- |
| 이번 변경신청 번호 | **`000010211994`** |
| 직접 연결된 승인 원본 | **`000010211993` — 11월 6일 하루짜리 승인 결과** |
| R1 상태 | **`WAIT`**, `LAST_ERROR` 공란 |
| 결재 작업 | **`000051859150` / `READY`**, 대기 사용자 `30751` |
| 원본 신청 비교 | **`ORIGINAL_APPLICATION_EQUAL=YES`** |
| 표준 근태 비교 | **85개 필드 비교, 차이 0개** |
| 현재 11월 6일 실제 근태 | **연차 유형 `1021`, 1일 유지** |
| 저장된 변경계획 | **유형 `13` — 오전반차**, 기존 **1일 → 변경 후 0.5일** |
| 현재 연차 | **발생 20일·사용 20일**, 저장된 연차 행과 현재 행 일치 |

특히 아래 결과가 중요해.

```
OLD_DAYS = 1.000
NEW_DAYS = 0.500

CURRENT_ANZHL = 20.00000
CURRENT_KVERB = 20.00000
QUOTA_FULL_ROW_EQUAL = YES
```

**오전반차로 바꿀 계획은 계산됐지만, 승인 전 실제 사용량은 아직 20일로 유지되는 것**을 확인했어. 앞서 나온 상신 경고 때문에 요청을 다시 만들거나 상신값을 수정할 필요는 없어.

## 2. 이제 지정 결재자가 새 문서 한 건만 승인해

**추가 소스 수정이나 보정 프로그램 실행 없이**, 다음 순서로 진행하면 돼.

1. **지정 결재자 `30751`이 자신의 계정으로 R1 웹 결재 화면**에 로그인해.
2. **문서 `000010211994` 한 건만** 선택하고, 변경계획이 **11월 6일 연차 → 오전반차**인지 확인해.
3. **승인을 한 번만** 눌러줘.

이번에는 `WAIT` 상태의 새 요청이므로 **일반 결재 목록의 ‘승인’으로 진행하는 단계**야. 이전 문서에서 사용했던 **‘결재 마무리 재개’를 먼저 누르는 것이 아니야.** 적용 안내서도 승인 전 원본 유지 확인 다음에 실제 반차 변경 승인을 시험하도록 되어 있어.

**이전 날짜 이동 문서 `000010211991`이나, 이번 원본 `000010211993`을 다시 승인하는 것이 아니라 새 변경신청 `000010211994`만 처리하는 거야.**

## 3. 승인 후에는 이 결과를 확인할 거야

다른 근태 처리가 동시에 없다는 전제에서, 최종 목표는 다음과 같아.

| 항목 | 승인 완료 후 확인할 목표 |
| --- | --- |
| 진행 내역 | **‘승인 완료’ / `DONE`** |
| 11월 6일 실제 근태 | **연차 1일 → 오전반차** |
| 연차 사용량 | **20일 → 19.5일** |
| 잔여 연차 | **0일 → 0.5일** |
| 별도 승인된 11월 3~4일 근태 | **기존 연차 2일 유지** |

사용량 계산은 **`20 − 원본 1 + 변경 후 0.5 = 19.5일`**이야. 이것은 이번 계획의 **승인 후 기대값**이며, 실제 반영 여부는 승인 뒤 데이터를 대조해야 해. 신청 이력의 ‘일수’가 `1`로 표시되더라도 그것만으로 실패라고 판단하지 않고, **근태유형과 실제 사용량을 함께 확인**할 거야.

**오류가 나오거나 `HR_DONE`·`RECONCILE` 등으로 남으면 반복 승인하거나 반려·회수로 바꾸지 말고 멈춰줘.** 일부 처리가 먼저 반영될 수 있으므로 상태를 보고 다음 조치를 정해야 해.

**승인을 한 번 진행한 뒤, 승인 결과 알림과 「기승인 변경·취소 진행 내역」의 문서 `000010211994` 상태가 보이는 화면을 보내줘.**

## ess4-t070-u1 · 사용자

이거 승인하라는거야 ? 문서번호가 없으니까 너가 말하는게 뭐가 뭔지 모르겠어

## ess4-t070-a1 · AI

응. **지금 화면에 한 줄로 보이는 ‘일자별 변경’ 건을 승인하라는 뜻이야.** 문서번호가 표시되지 않는 화면인데 번호로만 안내해서 헷갈리게 했어.

## 승인할 대상은 이 행이야

| 지금 화면의 항목 | 대상 값 |
| --- | --- |
| **구분** | **일자별 변경** |
| **사번** | **32762** |
| **시작일·종료일** | **2026/11/06 ~ 2026/11/06** |
| **신청일** | **2026/10/15 09:13** |

지금 보이는 이 행의 사번·기간·신청시각이 **앞서 점검한 오전반차 변경요청과 일치해.**

## 여기서 누르는 순서

1. **해당 행 맨 왼쪽 ‘결재’ 열**에 현재 **「선택」**이라고 되어 있는 드롭다운을 열고, **「승인」**을 선택해.
2. 그다음 **표 위 버튼들 중 맨 왼쪽의 「결재」 버튼을 한 번** 눌러줘.

즉, **`행 왼쪽 「선택」 → 「승인」으로 변경 → 위쪽 「결재」 버튼 클릭`**이야. **「근태 직권처리」 버튼을 누르는 것이 아니야.** 버튼과 드롭다운 위치는 지금 올린 화면 기준이야.

### 목록에 ‘연차휴가’라고 표시되어 있어도?

맞아. **현재 결재 목록에는 ‘연차휴가’로 보이지만, 앞서 확인한 진행 내역의 변경계획은 ‘11월 6일 오전반차’였어.** 승인 전 점검에서도 **기존 1일 → 변경 후 0.5일**로 계산된 것을 확인했어. 목록의 유형 표시와 변경계획을 구분해서 보면 돼.

**이 한 건만 위 순서로 처리하고, 나온 결과 메시지를 보여줘. 오류가 나오면 결재 버튼을 다시 누르거나 반려로 바꾸지 말고 멈추면 돼.**

## ess4-t071-u1 · 사용자

처리되었어

## ess4-t071-a1 · AI

좋아. **11월 6일 오전반차 변경 결재까지 진행했구나. 이제 실제 근태가 바뀌고 잔여 연차가 0.5일 늘었는지 마지막으로 확인하자.** 같은 건을 다시 승인하거나 소스를 추가로 수정할 필요는 없어.

## 1. 기존 조회 프로그램을 아래 값으로 실행해 줘

**SE38 → `ZHR_GUN_R1_REJECT_CHECK` → 실행**

앞서 승인 전에 사용한 것과 **같은 입력값**이야.

```
P_PERNR = 00032762
P_ORIG  = 000010211993
P_KEY1  = 000010211994
P_KEY2  = 공란
```

이번 반차 변경의 직접 원본은 **`000010211993`**, 변경요청은 **`000010211994`**로 확인했어. 예전 날짜 이동 시험의 `1986`·`1991`을 넣는 것이 아니야.

**조회용 `REJECT_CHECK`만 실행하면 돼. 실제 이력을 보정했던 `REJECT_SYNC`는 실행하지 않아.**

## 2. 최종적으로 확인할 값

다른 근태 처리가 동시에 없었다는 전제에서, 이번 승인 후 목표는 다음과 같아.

| 확인 대상 | 승인 후 확인할 결과 |
| --- | --- |
| R1 진행 상태 | **`DONE` / 결정 `Y` / `LAST_ERROR` 공란** |
| 결재 작업 | **`COMPLETED`**, 관련 대기 목록 정리 |
| 11월 6일 실제 근태 | **오전반차 유형 `1024`**로 변경 |
| 해당 연차 발생량 | **20일 유지** |
| 해당 연차 사용량 | **20일 → 19.5일** |
| 해당 연차 잔여 | **0일 → 0.5일** |

아직 승인 후 데이터를 본 것은 아니므로, 위 값은 **확인할 목표**야. 반차 변경 시험은 성공 메시지뿐 아니라 실제 유형과 잔여 증가까지 대조하는 단계야.

## 3. 이번 결과에서 헷갈릴 수 있는 두 가지

**`QUOTA_FULL_ROW_EQUAL=NO`가 나와도 그것만으로 오류는 아니야.** 이번에는 저장 당시 사용량 **20일**에서 현재 사용량 **19.5일**로 달라져야 하므로, 변경 전후 행이 같지 않다는 표시가 나올 수 있어. **9번의 `CURRENT_KVERB`가 실제로 얼마인지**를 확인할 거야.

또한 **5번의 `PA2001` 조회가 0건으로 나올 수도 있어.** 이 구간은 신청행에 남은 근태코드로 유형을 제한하므로, 기존 연차가 오전반차로 바뀌면 조회에서 제외될 수 있어. 그래서 **8A의 `CURRENT_ROW`에 실제 유형 `1024`가 있는지도 함께 봐야 해.** 0건이라는 숫자만 보고 근태가 삭제됐다고 판단하지 않으면 돼.

**실행 결과를 위·아래로 나눠서 보내줘. 특히 7번의 처리 상태, 8A의 현재 근태, 9번의 현재 연차 사용량이 보이면 이번 오전반차 변경 시험의 최종 결과를 판단할 수 있어.**

## ess4-t072-u1 · 사용자

이렇게만 봐도 0.5일 잘 남아있어

## ess4-t072-a1 · AI

응, 맞아. **잔여 연차가 0.5일로 표시되고, 신청 가능일수에도 0.5일이 반영된 것은 이 화면으로 확인됐어.**

| 화면 항목 | 현재 표시 |
| --- | --- |
| **잔여 연차** | **0.5일** |
| 저장·상신 예약 | **0일** |
| **신청 가능일수** | **0.5일** |
| 연차 공제 기간 | 2026/04/01~2027/03/31 |

즉, **연차 1일을 오전반차 0.5일로 바꾼 뒤, 차이인 0.5일이 잔여로 돌아오는 기대 결과와 맞아.** 예약분 때문에 신청 가능일수가 줄어든 상태도 아니고, 화면에는 남은 0.5일 전부가 신청 가능으로 표시돼.

**잔여 표시 확인을 위해 점검 프로그램 결과를 다시 보낼 필요는 없어.** 앞서 요청한 상세 조회는 실제 근태 유형과 워크플로 종료까지 대조하기 위한 별도 검증이었어. 이 캡처만으로 내부 항목까지 모두 확인한 것은 아니지만, **이번 단계는 ‘오전반차 변경 처리 후 잔여·신청 가능일수 0.5일 표시 확인’으로 정리하면 돼.**

이 건을 다시 승인하거나 잔여를 수동으로 보정할 필요는 없어.

## ess4-t073-u1 · 사용자

그럼 아까 1일연차->0.5일 반차로 변경하고 상신할때 팝업으로 떳던거 있잖아. 그건 프로그램 수정이 필요한거 아니야 ?

## ess4-t073-a1 · AI

맞아. **반차 변경 후 잔여가 0.5일로 잘 돌아온 것과, 상신할 때 혼란스러운 팝업이 뜬 문제는 별개야. 그 팝업은 개선 대상으로 남겨야 해.** 내가 최종 결과를 확인하면서 그 부분까지 해결된 것처럼 넘어간 건 구분이 부족했어.

다만 **중복 상신을 막는 검사를 없애는 것이 아니라, 실제 상태에 맞게 안내하고 불필요한 재전송을 막는 방향**으로 보완해야 해.

## 1. 팝업이 나오는 코드 위치를 찾았어

보관된 누적 소스를 확인하니, 해당 문구는 **`guntae_input_r1.kbs → OnInputProcessing`의 상신 전 상태 검사**에서 나와.

선택한 신청을 DB에서 다시 읽고 다음 중 하나라도 값이 있으면 중단하는 구조야.

```
IF ls_r1_db-zsangsin IS NOT INITIAL OR
   ls_r1_db-zaccept  IS NOT INITIAL OR
   ls_r1_db-zserial  IS NOT INITIAL.
```

여기서 **“이미 상신/결재되었거나 상태 확인이 필요한 신청입니다. 선택을 해제하고 다시 시도하세요.”**라는 하나의 문구를 표시하고 있어. **반차 0.5일 계산을 검사하다가 나온 메시지가 아니야.** 확인한 위치는 보관본의 해당 이벤트 **174~179행**이야. `R1_SUBMIT_POPUP_SOURCE_REVIEW_20261015.txt`

당시 팝업 화면에는 새 변경신청의 상신 표시가 이미 `Y`였고, 이후 진행 내역에서도 **`000010211994`가 ‘결재 대기’, 변경계획은 ‘오전반차’**로 확인됐어. 따라서 **그 팝업을 상신 실패라고만 해석하면 안 되는 상황**이었던 거야.

## 2. 무엇을 고쳐야 하느냐면

**지금은 서로 다른 상태를 같은 경고로 묶어서, 사용자가 다시 상신해야 하는지 이미 끝난 건지 알기 어려워.** 아래처럼 구분하는 것이 수정 방향이야.

| 실제 확인된 상태 | 보완할 안내·동작 |
| --- | --- |
| **이미 상신되어 결재 대기 중** | 추가 상신은 막고, **“이미 상신된 요청입니다. 결재 대기 중이므로 다시 상신할 필요가 없습니다.”**와 기존 결재번호 표시 |
| **승인된 원본 등 상신 대상이 아닌 행 선택** | **“승인 원본이 선택되어 있습니다. 새로 저장한 변경신청을 선택하세요.”**처럼 대상 오류를 구체적으로 안내 |
| **신청·R1 이력·결재 연결 상태가 서로 불일치** | 처리를 중단하고 **“상신 상태 확인이 필요합니다. 재상신하지 마세요.”**로 안내 |

여기에 **상신 성공 후 목록·선택 상태를 갱신하고, 처리 중에는 같은 요청이 연속 전송되지 않게 하는 부분**도 함께 확인해야 해.

단, **이번 팝업이 첫 클릭의 잘못된 판정인지, 중복 요청인지, 다른 행이 선택된 것인지는 당시 요청 기록이 없어서 아직 확정하지 못했어.** 정상적인 첫 상신에서도 발생했다면 실행 흐름의 결함이고, 이미 상신된 요청을 다시 보냈다면 차단 자체는 맞지만 안내 방식은 개선할 부분이야.

## 3. 연차 계산이나 승인 완료 데이터를 다시 고칠 작업은 아니야

이번에 우선 보완할 곳은 **신청 페이지의 상신 처리·결과 안내**야. `ZRPTH_GUN_GULJAE_R1`은 `GULJAE` 값으로 승인·반려를 처리하는 별도 레포트이므로, 이번 팝업 때문에 그 레포트의 연차 차감 로직부터 다시 수정하는 방향은 아니야.

**정리하면, “결국 처리됐으니 팝업은 그대로 둔다”가 아니라 “중복 상신 방지는 유지하면서, 정상 처리 여부를 오해하게 만드는 안내와 화면 동작을 보완한다”가 맞아.** 아직 이 팝업에 대한 수정본을 적용한 것은 아니고, **다음 보완 대상으로 남아 있어. 이미 승인한 반차를 취소하거나 다시 신청할 필요는 없어.**

R1_SUBMIT_POPUP_SOURCE_REVIEW_20261015.txt문서

## ess4-t074-u1 · 사용자

정상적인 첫 상신에서도 발생한거였어

## ess4-t074-a1 · AI

**그렇다면 이건 정상적인 첫 상신에서 잘못된 경고가 뜨는 프로그램 결함으로 봐야 해. 단순히 안내 문구만 바꾸고 끝낼 문제가 아니야.** 앞서 내가 “이미 상신한 건을 다시 눌렀을 가능성”을 설명했는데, 이번에는 사용자가 반복해서 누른 상황이 아니었던 거네.

## 확인 방향이 달라져

지금까지 확인된 상황은 **“새 변경신청을 처음 상신했는데 경고가 나오고, 실제로는 결재 대기까지 연결됐다”**는 거야. 따라서 **한 번의 클릭이 프로그램 내부에서 어떻게 처리되는지**를 확인해야 해. 사용자 조작 문제로 넘길 수는 없어.

보관된 소스를 다시 확인하니, 해당 경고는 **상신 함수를 호출하기 전 검사**에서 나오고, 경고를 만들면 즉시 `RETURN`하도록 되어 있어. 실제 상신 함수 호출은 그보다 뒤에 있어. **이 보관본과 같은 실행 경로라면, 그 검사에서 중단된 호출이 그대로 이어져 상신까지 완료되는 구조는 아니야.**

그래서 우선 구분해야 할 것은 다음이야.

| 확인할 지점 | 확인 목적 |
| --- | --- |
| **버튼 한 번 클릭 → 서버 요청** | 사용자 클릭은 한 번인데, 프로그램이 상신 요청을 두 번 보내는지 |
| **저장·상신 이벤트의 실행 순서** | 정상 처리 후 같은 이벤트가 다시 실행되거나, 이전 경고가 재출력되는지 |
| **선택한 신청의 식별키** | 새 변경요청과 승인 원본을 정확히 구분해 검사하는지 |

**어느 것이 직접 원인인지는 아직 확정하지 않았어.** 하지만 수정 목표는 분명해. **첫 상신은 한 번만 실행되고, 성공했다면 성공 결과를 보여줘야 해.** 중복 방지 조건을 삭제하거나 경고만 감추는 방식으로 처리하면 안 돼.

## 이제 현재 신청 페이지 소스를 대조하자

보관본은 확인했지만 **현재 SAP 활성본과 동일한지 확인되지 않았으므로**, 아래 두 소스를 한 번에 보내줘.

```
SE80 → BSP Application: ZHR0008
     → guntae_input_r1.kbs

① Layout 전체
② Event Handler → OnInputProcessing 전체
```

**지금 대상은 신청 페이지 `guntae_input_r1.kbs`야.** 최근 수정했던 진행 내역 페이지 `guntae_change_status_r1.kbs`나 결재자 페이지가 아니야.

이 두 소스로 **버튼의 전송 코드부터 상신 전 검사·함수 호출·결과 표시까지** 연결해서 대조해야 해. **이미 처리된 오전반차 건은 그대로 두고, 오류를 재현하려고 취소·재신청할 필요는 없어. 현재 활성 소스 두 개만 보내줘.**

## ess4-t075-u1 · 사용자



## ess4-t075-a1 · AI

두 소스 확인했어. **이번 수정 대상은 신청 페이지 `guntae_input_r1.kbs`로 좁혔고, 상신 전송 경로를 정리한 개발계 검증용 수정본을 만들었어.** 기존의 중복 상신 방지 검사나 연차 계산은 건드리지 않았어.

다만 먼저 분명히 할 점이 있어. **첨부한 소스만으로 과거 첫 상신 경고의 직접 원인을 확정하지는 못했어.** 실제로 요청이 두 번 전송됐다고 단정하거나, 경고만 감춰서 해결됐다고 처리할 상황은 아니야.

## 1. 이번 소스에서 확인한 내용

현재 상신 버튼은 다음 순서로 연결돼 있어.

```
「결재상신」 클릭
    ↓
js_kuljae()
    ↓
확인창
    ↓
공통 JavaScript의 GoInputProcessing('KULJAE') 호출
    ↓
서버 OnInputProcessing
```

`js_kuljae`에는 수동 전송 호출이 한 번 있고, 버튼에는 `onClientClick`만 지정되어 있어. **`onClick`과 `onClientClick`이 이중 등록된 형태는 아니야.**

서버에서는 문제의 팝업을 만드는 검사가 **실제 상신 함수 호출보다 앞**에 있어. 그 검사에서 경고를 만들면 `RETURN`하므로, **그 호출이 그대로 계속되어 상신까지 완료되는 구조는 아니야.** 경고가 나온 실행과 실제 상신을 완료한 실행을 구분할 근거가 필요한 이유야.

## 2. 수정본에서는 이렇게 바꿨어

| 수정 부분 | 변경 내용 |
| --- | --- |
| **상신 버튼의 전송 방식** | `js_kuljae`에서 수동 전송하지 않고, **HTMLB의 `onClick=KULJAE` 한 경로로 전송** |
| **클릭 처리** | 확인창 취소·검증 실패 시 전송하지 않음. 처리 중 같은 화면에서 들어오는 반복 호출을 차단 |
| **서버 처리 기록** | 요청 식별값, 선택한 신청키, 상신 전 DB 상태, 함수 호출 여부, 최종 처리 결과를 화면에 표시 |
| **기존 업무 검사** | 토큰·본인 요청·신청키·상신 상태·잠금·처리 결과 재조회 **그대로 유지** |

HTMLB의 `onClick`으로 서버 이벤트를 지정하고, `onClientClick`에서는 `htmlbevent.cancelSubmit`으로 전송 여부를 제어하는 방식이야. 공통 `GoInputProcessing` 함수 자체를 수정하는 것은 아니야. [SAP 도움말 포털+1](https://help.sap.com/saphelp_autoid2007/helpdata/en/6e/ba5732fec9ff40a5de3c0f25171f88/content.htm?utm_source=chatgpt.com)

**기존 팝업도 삭제하지 않았어.** 수정 후에도 경고가 발생하면, 이번에는 **어떤 요청이 어떤 신청의 상태를 읽고 중단됐는지** 확인할 수 있도록 했어. 이 기록은 진단용이며, 성공을 강제로 표시하거나 이미 상신된 신청을 다시 처리하는 기능은 아니야.

## 3. 적용할 파일

**`R1_SUBMIT_ONCE01_20261015_XA32762.zip`**

| 적용 위치 | 전체 교체용 파일 |
| --- | --- |
| **`guntae_input_r1.kbs → Layout`** | `guntae_input_r1_LAYOUT_SUBMIT_ONCE01_FULL.txt` |
| **같은 페이지 → `OnInputProcessing`** | `guntae_input_r1_OnInputProcessing_SUBMIT_ONCE01_FULL.txt` |

`README_SUBMIT_ONCE01_EASY.md`도 따로 넣었어. 수정 구간에는 **`XA32762 / GNT-R1-U23 / submit-once01`** 주석을 달았고, 교체한 기존 버튼 코드는 주석으로 보존했어.

### ① 먼저 페이지 속성 한 줄 추가

```
SE80
 → BSP Application: ZHR0008
 → guntae_input_r1.kbs
 → Page Attributes
```

아래 한 줄을 추가해.

| Attribute | Typing | Associated Type | Auto | 내역 |
| --- | --- | --- | --- | --- |
| **`GV_R1_SUBMIT_TRACE`** | `TYPE` | **`STRING`** | **체크 해제** | R1 상신 처리 진단 기록 |

**기존 속성은 삭제하지 않아.** 특히 `GV_V2_TOKEN`과 기존 수정용 속성은 그대로 유지해.

### ② 현재 소스를 백업하고 두 파일 적용

**Layout에는 Layout 파일**, **Event Handler의 `OnInputProcessing`에는 이벤트 파일**을 각각 전체 교체하면 돼.

이번 파일은 붙여넣은 마크다운의 표시용 역슬래시·공백을 정리한 소스야. 다운로드한 `.txt` 내용을 사용하면 돼. `OnInputProcessing`에 `METHOD`·`ENDMETHOD`를 추가하지 않아.

**저장 → 구문 검사 → 오류가 없으면 페이지 활성화**까지 진행해.

### ③ 신청 화면을 새로 열기

수정 전에 열어둔 신청 탭은 닫고, 기존 메뉴에서 **R1 신청 화면을 새로 열어줘.** 새 화면 상단에 다음 표시가 나오도록 했어.

```
[SUBMIT-ONCE01] 상신 단일 전송 검증본
```

## 4. 지금은 적용·활성화까지만 하자

**이미 승인된 오전반차 건 `000010211994`를 다시 상신하거나, 시험하려고 취소·재신청하지 마.** 기존 날짜 이동 건이나 반려 이력 보정 프로그램도 다시 실행할 필요 없어.

이번에 바꾸는 것은 **신청 페이지의 속성 한 줄과 Layout·OnInputProcessing 두 곳**이야. 승인 레포트, PC 클래스, 진행 내역 페이지, MIME 유형, 연차 계산 로직은 변경하지 않아.

로컬에서는 **JavaScript 분기 모형 10건을 통과**했고, 서버 이벤트에서 새 진단 구간을 제외하면 **기존 업무 소스가 그대로 남는 것**도 확인했어. 하지만 **SAP 구문 검사와 실제 첫 상신 재현은 아직 하지 않았어.** 따라서 현재 단계는 *검증용 수정본 준비*이며, 첫 상신 경고가 해결됐다는 판정은 실제 시험 뒤에 해야 해.

**우선 적용·구문 검사·활성화 후, 새 신청 화면에 `[SUBMIT-ONCE01]`이 표시되는지 알려줘. 기존 완료 건은 그대로 두고 이어가자.**

guntae_input_r1_LAYOUT_SUBMIT_ONCE01_FULL.txt문서guntae_input_r1_OnInputProcessing_SUBMIT_ONCE01_FULL.txt문서README_SUBMIT_ONCE01_EASY.md문서

## ess4-t076-u1 · 사용자

이거 적용후
11/3~11/4 2일 연차 상태를
3일 : 그대로 유지
4일 : 연차- > 반차로 변경
상신 및 승인까지 오류 없이 진행 후
신청화면 보니까 이렇게 상단에 에러가 나고 있어.

## ess4-t076-a1 · AI

확인했어. **상단은 이번 승인 실패 메시지가 아니라, 내가 넣은 ‘상신 처리 진단 기록’이야. 그런데 그 기록에서 중요한 문제가 확인됐어. 첫 상신은 성공했고, 그 뒤 같은 클릭 식별값으로 들어온 상신 처리가 두 번 더 토큰 검사에서 차단됐어.** 따라서 **상신·승인 결과와, 불필요한 재처리 시도 문제를 구분해야 해.**

## 1. 지금 기록은 이렇게 읽으면 돼

| 상단 기록 | 의미 |
| --- | --- |
| 첫 번째 `[START] → [PRECHECK] → [CALL_SAVE]` | 미상신 상태를 확인하고 실제 상신 함수를 호출함 |
| **`[RESULT] VERIFIED_DONE=1`** | **한 건의 상신이 기존 사후검사까지 통과함** |
| 두 번째 `[START] → [TOKEN_STOP]` | 토큰 검사에서 중단되어 상신 함수까지 가지 않음 |
| 세 번째 `[START] → [TOKEN_STOP]` | 이 처리도 토큰 검사에서 중단됨 |

첫 번째 결과에는 **“1건을 각각 결재상신 처리했습니다.”**가 명시되어 있어. 뒤의 두 처리에는 `CALL_SAVE`가 없고 `TOKEN_STOP`만 있어. 해당 코드는 화면 토큰이 없거나 전달된 토큰과 다르면 즉시 `RETURN`하도록 되어 있어. **이 기록이 상신을 세 번 완료했거나 연차를 세 번 차감했다는 뜻은 아니야.**

아래 신청 이력에서도 **11월 3일은 연차, 11월 4일은 오전반차**인 승인 결과행이 보이고, 두 행에 **`R1 승인문서 000010211996`**이 표시돼. 사용자에게서 들은 처리 결과와 화면 표시는 맞아. 다만 이 화면만으로 실제 근태·연차 테이블 전체를 재검증한 것은 아니야.

## 2. 그래도 ‘상신 전송 문제가 해결됐다’고 끝내면 안 돼

세 번의 `[START]`에 있는 클릭 식별값은 모두 같아.

```
CLICK=1792044634017-1
```

반면 `REQUEST`는 각각 달라. 이 `REQUEST`는 서버 입력 이벤트에 들어올 때마다 생성하도록 넣은 진단값이야. **즉, 같은 클릭 식별값을 가진 상신 이벤트가 반복해서 처리에 들어온 것은 확인됐어. 사용자에게서 클릭을 세 번 했다는 뜻은 아니야.**

**앞서 준 `SUBMIT-ONCE01`의 버튼 수정만으로 반복 진입까지 막혔다고 볼 수는 없어.** 이번에는 진단 기록 덕분에 **“처음 처리는 성공했고, 뒤에서 추가 처리가 들어왔다”**는 지점까지 확인한 거야.

다만 기록에 실행 시각이나 재전송을 일으킨 동작까지 넣지는 않았기 때문에, **첫 클릭 직후 자동으로 반복된 것인지, 승인 후 신청 화면으로 돌아오거나 새로고침할 때 다시 들어온 것인지는 아직 구분되지 않아.**

## 3. 승인 후에도 위에 남는 이유는 별개야

이 진단 기록은 **페이지 메모리에 누적해서 보관하고, 이후 조회 화면에서도 보여주도록 내가 작성한 것**이야. 그래서 승인 후 신청 화면을 봤을 때 남아 있다고 해서 **그 순간 새 오류가 발생했다는 뜻은 아니야.** 안내 문구에도 “최근 상신 처리 기록이며 현재 DB 상태 조회가 아닙니다”라고 되어 있어.

**기록만 지우거나 토큰 검사를 없애서 해결할 문제는 아니야.** 토큰 검사는 뒤의 추가 처리를 막은 것이므로 유지하고, 같은 상신 이벤트가 다시 들어오는 경로를 고쳐야 해. 이미 승인된 이번 건은 취소·재상신하지 않고 그대로 두면 돼.

**한 가지만 확인해 줘. 결재자 화면에서 승인한 뒤 신청 화면을 볼 때, 기존에 열어둔 신청 탭에서 새로고침(F5)·뒤로가기를 한 거야, 아니면 신청 메뉴를 눌러 화면을 새로 연 거야?** 이번에는 소스를 다시 보내거나 새 신청으로 재현하지 않아도 돼.

## ess4-t077-u1 · 사용자

기존에 열어둔 신청 탭에서 새로고침(F5)·뒤로가기를 한 거야 ㅇㅇ

## ess4-t077-a1 · AI

응. **그렇다면 이번에 추가된 두 번의 `TOKEN_STOP`은, 상신 후 남아 있던 화면을 F5·뒤로가기로 다시 열면서 이전 상신 요청이 재전송된 상황과 맞아.** 지금 기록만으로 **“첫 클릭 한 번에 프로그램이 자동으로 세 번 전송했다”**고 판단하면 안 되는 거야.

**그렇다고 사용자가 새로고침한 것이 잘못이라는 뜻은 아니야. 상신 완료 후에는 새로고침해도 조회만 되도록 프로그램을 보완하는 게 맞아.**

## 1. 이번 기록은 ‘상신 성공 1회 + 재전송 차단 2회’야

| 기록 | 판단 |
| --- | --- |
| 첫 번째 요청의 `CALL_SAVE → VERIFIED_DONE=1` | **상신 한 건이 사후검사까지 통과** |
| 이후 두 요청의 `TOKEN_STOP` | **이전 요청이 다시 들어왔지만 토큰 검사에서 중단** |

두 차단 호출은 상신 함수를 다시 실행하기 전에 `RETURN`해. **따라서 이 기록은 상신을 세 번 완료했다는 뜻도, 연차를 세 번 차감했다는 뜻도 아니야.** 토큰 검사는 오히려 재처리를 막는 역할을 한 것이므로 유지해야 해.

## 2. 이제 보완할 곳은 ‘상신 후 화면으로 돌아오는 방식’이야

현재 상신 처리의 끝부분은 결과 메시지를 `cm_script`에 넣고 입력 화면 상태를 정리하는 방식이야. **해당 처리 구간에는 완료 후 조회 요청으로 전환하는 리다이렉트가 없어.**

수정 방향은 아래처럼 잡으면 돼.

```
현재 문제 상황
상신 요청(POST) → 결과 화면
                       ↓ F5·뒤로가기 후 재전송
                 이전 상신 요청 → 토큰 검사에서 차단

보완할 흐름
상신 요청(POST) → 처리 결과 보관
                       ↓ 조회 화면으로 이동
                 조회 요청(GET) → 결과·신청 이력 표시
                                      ↓ F5
                                  조회만 다시 실행
```

이처럼 **처리 요청과 결과 조회를 분리하는 방식**이 `POST → Redirect → GET`이야. HTTP `303 See Other`는 POST 처리 후 결과를 GET으로 조회하도록 전환하는 데 사용하는 응답이야. **단, 예전에 열린 POST 화면의 재전송까지 모두 없어진다고 보장할 수는 없으므로 기존 서버의 토큰·중복 상신 방지는 그대로 필요해.** [RFC Editor](https://www.rfc-editor.org/rfc/rfc9110.html?utm_source=chatgpt.com)

보완할 때는 **상신 성공·실패 메시지가 이동 후에도 보존되게 하고**, 위쪽 진단 기록도 일반 사용자에게 계속 오류처럼 보이지 않도록 **별도 ‘처리 기록 보기’로 분리하는 방향**이 적절해. 지금 기록은 페이지 메모리에 누적되어 이후 조회 화면에도 남도록 작성된 것이야.

## 3. 앞서 ‘첫 상신 때 뜬 팝업’과는 구분해서 정리할게

**이번 새로고침 후 `TOKEN_STOP`의 설명이, 앞서 정상적인 첫 상신에서 뜬 팝업의 원인까지 확정해 주는 것은 아니야.** 그 팝업은 DB의 상신·결재 상태를 검사하는 다른 구간에서 나온 것이므로, 그때의 증상까지 해결됐다고 소급해서 판단하지 않을게.

정리하면, **이번 상신은 성공했고 재전송은 차단됐지만, 새로고침 때 불필요한 재전송·경고가 생기는 화면 흐름은 아직 보완이 필요해.** 앞서 적용한 `SUBMIT-ONCE01`에는 이 후속 처리가 포함되지 않았어.

**이미 승인된 11월 3일 연차·11월 4일 반차는 그대로 두면 돼.** 수정 전에는 기존 POST 결과 탭에서 반복 새로고침하기보다 신청 메뉴로 새로 들어가는 것을 임시 방법으로 사용하고, 프로그램 보완 범위는 **`guntae_input_r1.kbs`의 상신 후 화면 이동·결과 표시**로 잡으면 돼. 연차 계산이나 승인 완료 데이터를 다시 바꾸는 작업은 아니야.

## ess4-t078-u1 · 사용자

그럼 수정사항은 없다는거지 ?

## ess4-t078-a1 · AI

아니. **추가 수정사항은 남아 있어. 다만 이미 승인된 근태·연차 데이터를 고치는 것이 아니라, 신청 화면의 새로고침 동작을 보완하는 거야.** 내가 그 둘을 명확히 구분하지 못했어.

| 구분 | 지금 판단 |
| --- | --- |
| **이미 승인된 연차·반차 데이터** | 이번 재전송 기록 때문에 다시 수정할 필요는 없음 |
| **토큰으로 중복 처리를 막는 검사** | 그대로 유지. 실제로 추가 처리를 차단했음 |
| **상신 완료 후 화면 이동** | **추가 보완 필요.** 처리 후 조회 화면으로 전환해서 F5가 상신 재전송이 아니라 조회가 되도록 변경 |
| **상단 진단 기록** | 오류처럼 계속 노출하지 않도록 별도 ‘처리 기록 보기’로 정리 |

현재 토큰 검사는 불일치하면 상신 함수 실행 전에 중단하는 구조라서, 이 검사를 없애는 방향은 아니야.

**지금 적용된 것은 `SUBMIT-ONCE01`까지이고, ‘상신 후 조회 화면 전환·진단 표시 정리’ 수정본은 아직 전달하거나 적용하지 않았어.** 그러니까 **“수정 없음”이 아니라 “데이터 보정은 불필요하지만, 화면 처리 보완은 남아 있음”**이 정확해.

## ess4-t079-u1 · 사용자

‘상신 후 조회 화면 전환·진단 표시 정리’ 수정본 진행해줘

## ess4-t079-a1 · AI

수정본 만들었어. **이번에는 상신 처리 결과를 만든 뒤 조회 화면(GET)으로 자동 이동하고, 긴 진단 기록은 기본적으로 접힌 「처리 기록 보기」로 정리했어.**

**적용 대상은 `ZHR0008 → guntae_input_r1.kbs` 한 페이지야. 페이지 속성 네 줄을 추가하고, Layout·OnInputProcessing 두 곳만 교체하면 돼.**

## 1. 적용할 파일

**`R1_SUBMIT_PRG01_20261015_XA32762.zip`**

| 적용 위치 | 전체 교체용 파일 |
| --- | --- |
| **Layout** | `guntae_input_r1_LAYOUT_SUBMIT_PRG01_FULL.txt` |
| **Event Handler → OnInputProcessing** | `guntae_input_r1_OnInputProcessing_SUBMIT_PRG01_FULL.txt` |

`README_SUBMIT_PRG01_EASY.md`도 별도로 넣었어. ZIP에는 적용 전 기준 소스, 변경 비교, 상세 설명과 로컬 검사 결과가 함께 들어 있어.

**지금 적용된 `SUBMIT-ONCE01`을 포함한 전체본이야.** 예전에 보내준 마크다운 원본으로 되돌리는 파일이 아니야.

## 2. 달라지는 동작

기존 상신 처리의 **잠금 해제·결과 집계·입력 초기화 뒤에** 화면 이동을 추가했어. 기존 업무 처리 구간은 그대로 유지했어.

```
결재상신
   ↓
기존 상신 처리와 결과 확인
   ↓
결과 문구 보관
   ↓
조회 화면(GET)으로 자동 이동
   ↓
상신 결과 + 신청 이력 표시

이렇게 도착한 조회 화면에서 F5
   ↓
상신 재전송이 아니라 조회만 실행
```

이 전환에는 **HTTP 303 응답**을 사용했어. POST 처리 결과를 GET 조회로 이어주는 방식이야. [RFC Editor](https://www.rfc-editor.org/rfc/rfc9110.html)

상신 결과는 팝업 대신 **화면 상단의 ‘상신 처리 결과’ 영역**에 처리 시각과 함께 표시해. 여러 건 중 일부만 처리됐다면 기존의 **완료 건수·중단 건·미처리 건수와 오류 내용도 그대로 남기고**, 전부 성공한 것처럼 표시하지 않아.

긴 `[START]`, `[TOKEN_STOP]` 기록은 삭제하지 않고 **「처리 기록 보기」를 눌렀을 때만 펼쳐지도록** 했어.

## 3. SAP 적용 순서

### ① 현재 소스를 백업하고, 페이지 속성 네 줄 추가

```
SE80
 → BSP Application: ZHR0008
 → Pages with Flow Logic
 → guntae_input_r1.kbs
 → Page Attributes
```

현재 Layout과 OnInputProcessing을 먼저 백업하고, 아래 네 줄을 추가해.

| Attribute | Typing | Associated Type | Auto | 내역 |
| --- | --- | --- | --- | --- |
| **`GV_R1_PRG_ID`** | TYPE | STRING | **해제** | 상신 결과 조회 식별자 |
| **`GV_R1_PRG_MESSAGE`** | TYPE | STRING | **해제** | 상신 처리 결과 보관 |
| **`GV_R1_PRG_KIND`** | TYPE | CHAR1 | **해제** | 상신 결과 구분 |
| **`GV_R1_PRG_OWNER`** | TYPE | SYUNAME | **해제** | 상신 결과 실행 계정 |

**초기값은 직접 넣지 않아.** 기존 `GV_R1_SUBMIT_TRACE`, `GV_V2_TOKEN` 등은 그대로 유지해.

이 값들은 결과 문구를 이벤트와 화면 사이에서 공유하기 위한 **BSP 페이지 속성**이야. 클래스나 SE11 테이블에 추가하는 것이 아니야. [SAP 도움말 포털](https://help.sap.com/docs/SAP_NETWEAVER_AS_ABAP_752/0884fb55479542b38fb676e8f5b250a1/4c495ab29f9935b8e10000000a42189b-166.html?locale=en-US&state=PRODUCTION&version=7.52.11)

### ② 두 파일을 각각 전체 교체

**Layout에는 Layout 파일**, **OnInputProcessing에는 이벤트 파일**을 넣어줘. 이벤트 소스에 `METHOD`·`ENDMETHOD`를 추가하지 않아.

그다음 **저장 → 구문 검사 → 오류가 없으면 페이지 활성화**해.

**OnRequest·OnInitialization·OnCreate는 이번에 수정하지 않아.** 진행 내역 페이지, 결재자 페이지, 승인 함수·클래스, MIME·JavaScript·CSS도 그대로 두면 돼.

### ③ 기존 메뉴에서 신청 화면을 새로 열기

예전에 상신 결과가 떠 있던 탭은 닫고, **기존 메뉴에서 R1 신청 화면을 새로 열어줘.**

상단에는 긴 로그 대신 다음 항목이 보여야 해.

```
최신 신청 이력 조회    [처리 기록 보기]
```

**「처리 기록 보기」**를 누르면 안쪽에 다음 표시가 나와야 해.

```
[SUBMIT-PRG01] 현재 화면 요청: GET.
```

다시 누르면 접혀야 하고, **펼침·접기는 상신 요청을 보내지 않아.**

## 4. 이번 수정의 범위와 확인 기준

**먼저 위의 적용·활성화·조회 화면 확인까지만 진행하면 돼.** 이미 승인한 `1991`, `1994`, `1996` 문서를 시험용으로 다시 상신하거나 취소할 필요는 없어.

다음에 별도의 정상 미상신 테스트 건을 상신할 때는, 결과 화면에서 **현재 요청이 GET인지**, 그 화면에서 F5를 눌러도 **새 `[START]`·`[CALL_SAVE]`·`[TOKEN_STOP]`가 추가되지 않는지** 확인하면 돼.

다만 다음 두 가지는 구분해야 해.

**초기 토큰·신청키·상태 검사에서 바로 중단되는 요청은 기존 경고를 유지해.** 이번 자동 GET 전환은 상신 처리 루프를 마치고 결과 문구를 만든 경로에 적용했어. 또한 **브라우저에 이미 남아 있는 옛 POST 기록까지 삭제하는 수정은 아니므로**, 과거 기록으로 돌아가 재전송하면 기존 보호 검사에서 막힐 수 있어.

로컬에서는 **원본 업무 코드 보존 등을 포함한 소스·동작 모형 검사 22건과 진단 펼침·접기 검사 8항목을 통과**했어. **SAP 구문 검사와 실제 상신·F5 시험은 아직 실행하지 않았으므로**, 과거 첫 상신 팝업까지 모두 해결됐다고 판정한 것은 아니야.

**우선 적용 후 「처리 기록 보기」를 펼쳐서 `SUBMIT-PRG01`과 `현재 화면 요청: GET`이 보이는 화면을 보여줘.**

guntae_input_r1_LAYOUT_SUBMIT_PRG01_FULL.txt문서guntae_input_r1_OnInputProcessing_SUBMIT_PRG01_FULL.txt문서README_SUBMIT_PRG01_EASY.md문서
