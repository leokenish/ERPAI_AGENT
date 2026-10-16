# 출처 등록부

11개 업로드 파일을 모두 검토했다. PDF 4개 37쪽, TXT 7개 11,576행이며 이 중 카톡 5개는 11,412행이다.
PDF는 전체 텍스트/화면을 확인했고, 스캔 취업규칙은 페이지 이미지를 확인했다. 카톡은 범위를 분할해 전 행을 검토하고 날짜별 근거를 남겼다.
정리본은 축어 전사가 아닌 업무 요약·이력이다. 잡담·개인 식별정보는 지식으로 재기재하지 않았다. 원문은 바이트 그대로 보존한다.

| ID | 업로드 파일명 | 전체 범위 | 문서/메시지 시점 | 정리 문서 |
|---|---|---|---|---|
| SRC-01 | 취업규칙.pdf | 18쪽 | 2026-02-27 개정 판본 | [employment-rules-20260227.md](../knowledge/policies/employment-rules-20260227.md) |
| SRC-02 | 선택적근로제 시간제 매뉴얼.pdf | 16쪽 | 2022-03 | [selective-work-202203.md](../knowledge/manuals/selective-work-202203.md) |
| SRC-03 | ESS 통상근무 및 시차근무에서 통상(시차)익휴 설정 및 해제.pdf | 1쪽 | undated | [next-day-rest.md](../knowledge/manuals/next-day-rest.md) |
| SRC-04 | 시간외실비 입력기한 경과분에 대한 Kobis 내부결재 양식.pdf | 2쪽 | undated | [late-overtime-request.md](../knowledge/forms/late-overtime-request.md) |
| SRC-05 | 근로시간제도 ERP시스템 담당자용 Summary.txt | 101행 | undated | [erp-handover.md](../knowledge/reference/erp-handover.md) |
| SRC-06 | 근로시간제도_인사운영부_사용자 FAQ.txt | 63행 | undated | [user-faq.md](../knowledge/reference/user-faq.md) |
| SRC-07 | KakaoTalk_20260713_1647_27_424_노우진.txt | 3,835행 | 2023-03-06~2026-02-27 | [SRC-07-early.md](../knowledge/feedback/SRC-07-early.md), [SRC-07-late-SRC-08.md](../knowledge/feedback/SRC-07-late-SRC-08.md) |
| SRC-08 | KakaoTalk_20260713_1647_46_069_이승철, 노우진.txt | 784행 | 2023-11-13~2024-07-03 | [SRC-07-late-SRC-08.md](../knowledge/feedback/SRC-07-late-SRC-08.md) |
| SRC-09 | KakaoTalk_20260922_1018_46_211_정별빛.txt | 2,940행 | 2022-03-28~2026-01-20 | [SRC-09.md](../knowledge/feedback/SRC-09.md) |
| SRC-10 | KakaoTalk_20260922_1019_36_795_KBS 고보경.txt | 3,466행 | 2026-03-04~2026-09-02 | [SRC-10-early-SRC-11.md](../knowledge/feedback/SRC-10-early-SRC-11.md), [SRC-10-late.md](../knowledge/feedback/SRC-10-late.md) |
| SRC-11 | KakaoTalk_20260922_1020_23_306_고보경, 한재홍.txt | 387행 | 2026-08-24~2026-09-21 | [SRC-10-early-SRC-11.md](../knowledge/feedback/SRC-10-early-SRC-11.md) |

## 원문 줄 번호와 페이지
TXT의 `sources/text/SRC-xx.txt`는 BOM을 제거한 검색용 사본이며 원래 줄 순서를 유지한다. 인용은 이 사본/원문을 1부터 세는 줄 번호다.
PDF 인용은 원본의 실제 페이지 번호다. 취업규칙의 자동 OCR은 숫자·조항 인식 오류가 있어 검색용 정답 문서로 배포하지 않았다. 정리본의 중요한 수치는 페이지를 시각 확인했다.

## 자료 한계
- 카톡의 사진·파일·음성통화·메일 참조 내용은 별도로 업로드되지 않았으면 미확인이다. 상세 위치는 feedback 문서에 있다.
- 파일명이 같거나 비슷하다고 제공된 PDF를 카톡 속 특정 HWP의 동일 버전으로 간주하지 않는다.
- 독립적인 회의록은 없었다. 회의 일정과 의견 교환은 해당 메시지 근거로만 정리했다.
- 2026년 저장된 카톡에도 2022~2025년 과거 메시지가 있다. 저장일은 규정 효력일이 아니다.
- 실제 ZHR5 ABAP/XML export는 이번 지식 원문 11개에 포함되지 않는다. 객체 이름의 실제 경로·개발클래스는 별도 확인한다.
- 원문에는 직원 정보가 있을 수 있어 `sources/original/`, `sources/text/`는 기본 Git 제외 대상으로 제안했다. 로컬에서는 근거 확인을 위해 보존한다.

## 무결성
`source-register.json`에 파일 크기·SHA-256·페이지/줄 수·정리문서 경로를 기록했다. ZIP 생성 전에 원본11개 해시를 대조한다.

### SRC-01

원문: [`sources/original/SRC-01.pdf`](../sources/original/SRC-01.pdf) · 5,283,465바이트

SHA-256: `b56852da0359be149cce1ca7070e1c69959727ea394c9cc8cb900cd49a793b2d`

### SRC-02

원문: [`sources/original/SRC-02.pdf`](../sources/original/SRC-02.pdf) · 1,486,101바이트

SHA-256: `e8c1721e1eed794d9cc473eb437dabf33efec935095c7ab34cd0be9b5138f2e6`

### SRC-03

원문: [`sources/original/SRC-03.pdf`](../sources/original/SRC-03.pdf) · 74,067바이트

SHA-256: `7951b4ee253d108639187ae55c6815ef90248b6f54b18fbb335fc0096cf6b7d3`

### SRC-04

원문: [`sources/original/SRC-04.pdf`](../sources/original/SRC-04.pdf) · 153,527바이트

SHA-256: `42f59546fc60045a4047b065cfbb4e8e121567017ba12cb15b8bb7915f3565e4`

### SRC-05

원문: [`sources/original/SRC-05.txt`](../sources/original/SRC-05.txt) · 6,253바이트

SHA-256: `4bb75f50627e09f569cb74c0d98310be48c1c26555dd6258150c33a165cf248a`

### SRC-06

원문: [`sources/original/SRC-06.txt`](../sources/original/SRC-06.txt) · 4,324바이트

SHA-256: `b88532094012219294d3e6c1ff7084870ee8328251bbc63ddf5cdb49adbca4a0`

### SRC-07

원문: [`sources/original/SRC-07.txt`](../sources/original/SRC-07.txt) · 323,759바이트

SHA-256: `80fdec12844dc76afdb6137300159f8aa846a25029be31a96d88a80913868d20`

### SRC-08

원문: [`sources/original/SRC-08.txt`](../sources/original/SRC-08.txt) · 60,573바이트

SHA-256: `9bd547a8e497df3d64513336600798bee4de158d2b86814f5ef750f278ac48a4`

### SRC-09

원문: [`sources/original/SRC-09.txt`](../sources/original/SRC-09.txt) · 196,003바이트

SHA-256: `b3c8657b3fe85cd2ea4c30147b462b5d881928850a51e10a75783c708f97880d`

### SRC-10

원문: [`sources/original/SRC-10.txt`](../sources/original/SRC-10.txt) · 290,506바이트

SHA-256: `c6702498c03b413bcfa68cf44ea716ba17d8791b19a9b7b73c305abfee0a02c5`

### SRC-11

원문: [`sources/original/SRC-11.txt`](../sources/original/SRC-11.txt) · 33,295바이트

SHA-256: `4a5c89356e08701552d441049daeedf41ee12d269a382245386850b27e8c7717`

## 추가 사용자 설명 — SRC-12

- 출처: 현재 대화의 사용자 정정(발화·기록일 2026-09-23). 기존 업로드 11개와 별도의 대화 출처다.
- 전체 원문: “최근에 2026년 9월 1일부터 시간외 단가가 8400원 -> 9240원으로 변경됐어. 수정이 필요해”
- 효력일: 2026-09-01. 금액: 8,400원 → 9,240원.
- 확인 상태: 사용자 설명으로 변경 사실 확인. 공식 승인문서·운영 배포·실제 지급 검증은 아님. 대상 예외 폐지를 확인한 발언은 아님.
- 별도 업로드 파일/파일 해시: 해당 없음. 위 발화 전체를 기록했으며 원문 페이지·줄 번호를 부여하지 않음.
- [업무 정리](../knowledge/policies/overtime-rate-20260901.md), [피드백 기록](../harness/feedback/FB-20260923-001.md).

## 추가 사용자 설명 — SRC-13

- 발화·기록일: 2026-09-23. SRC-12 후속 정책 설명.
- 전체 원문: “연봉계약직과 특정업무직은 9월1일 이후로 모두 시간외 등급 단가 A(9240원)을 적용하기로 정책이 변경되었어. 그리고 방송지원직은 계속해서 등급D(5400원)이야.”
- 효력일: 대화 맥락상 2026-09-01부터 연봉계약직·특정업무직 모두 A등급9,240원. 방송지원직은 D등급5,400원 유지.
- 확인 상태: 사용자 설명으로 정책 확인. 공식 승인문서 열람·SAP 마스터 일괄 반영·과거 입력 보정 검증은 아님.
- 별도 업로드 파일/해시: 해당 없음. 발화 전체 기록, 원문 페이지/줄 번호 없음.
- [현재 단가 지식](../knowledge/policies/overtime-rate-20260901.md), [피드백](../harness/feedback/FB-20260923-002.md).

## 추가 사용자 설명 — SRC-14

- 기록일:2026-10-01. 사례일:2026-10-02. 정책 시행일:미제공.
- 사용자 발화 전체(표기상 물결표 이스케이프만 정규화):

> 최종확인 했어. 이 사람의 시작시간이 문제 였던거 같아. 이날 반차를 사용했더라도 시작시간은 이분의 원래 시차근무시작시간인 14:00를 넣었어야해. 지금처럼 18:00로 입력하면 총시간이 4.5 시간 밖에 안되어서 너가 말한 필수근무시간 7시간 미만에 걸려서 모두 금액이 0 처리돼. 따라서 오전 반차를 사용했더라도 시작시간은 명시적으로 14:00로 넣어야해. 이문제는 통상근무 시간외도 마찬가지야. 기본적으로 현재 시간외 시스템은 시작시간을 명시적으로 출근시간으로 입력하게 되어있어. 예를들어 내가 저녁에 1시간 시간외를 했다고해서 18:00~19:00으로 입력하지 않고 09:00~19:00로 입력하게 되어있어. 이것은 앞서언급한 반차와 더불어 자율출근에 따른 출근시간, 지참 조퇴와 같은 시간을 계산할때 전체 시간에서 감하는 식으로 프로세스가 설계되어 있기 때문이야. 이 수정사항과 정책을 추가로 반영해줘

- 상태:사용자 최종 확인으로 업무 입력 기준·사례 원인 정정. 공식 승인문서 열람·운영 실행·최종 지급액 검증은 아님. 별도 업로드파일/해시 없음.
- [정리](../knowledge/processes/overtime-start-time.md), [피드백](../harness/feedback/FB-20261001-001.md).

## 추가 사용자 설명 — SRC-15

- 발화·기록일: 2026-10-08. 대상: 선택근로 누적표시의 가산 포함/제외 이유와 롤백.
- 사용자 발화 전체:

> 해당 주석을 보면
> "20241015-NGY-인사부요청-선택근로에서 가산근로시간은 대휴생성에 영향을 안주기에 사용자들이 누적시간만 보고 오해의 소지가 있음
> " 누적근로시간은 실제 근로시간으로 보여주기로 하였음. 선택근로 일자별 리포트에서도 그렇게 보여주고 있음
> "20241028-NGY-인사부요청에 따른 번복-대휴 발생보다 가산근로가 안포함되어있어서 소정이 안채워져있게 오해하시는게 더 큰 문제, 다시 롤백
> 이렇게 달려있어. 중요한 내용이니 업무에 반영해줘

- 구분: 사용자 발화의 별도 업로드 파일/해시는 없음. 사용자 발화에 원문 행 번호를 새로 부여하지 않는다. 주석 날짜 2024-10-15/28, 지식 반영일 2026-10-08, 공식 정책 효력일·운영 배포일 미확인은 서로 구분한다.
- 실제 코드 대조: [ZHR_52TM_CW_BASE_DATA.abap](../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Source%20code/ZHR_52TM_CW_BASE_DATA.abap) L632–634의 세 주석 및 L635 차감식 주석 처리, L378–417 가산 합산 분기, L629 최종 합계. 아래 해시는 사용자 발화가 아니라 실제 코드 파일의 동일성 기록이다.
- 대조 코드 SHA-256: `af97a335dbd70be3ca53e73e5904115c4dc9524031b1ff3704062041c49de78f`.
- 기존 보조 근거: SRC-07 L2196–2207 및 L2613–2636/L2660–2663의 기존 정리본. 카톡 원문 파일은 현재 없어 이번에 원문을 다시 읽은 것으로 표시하지 않는다.
- 확인 상태: 사용자 요청의 업무 의미와 지정 코드 주석·구문 확인. 문서 검토는 AI 작성/담당자 검토 대기. 대휴·연장수당 산식 변경, 공식 규정 개정, 운영 배포·실제 지급 검증 아님.
- [업무 정리](../knowledge/processes/selective-cumulative-display.md), [피드백 기록](../harness/feedback/FB-20261008-001.md), [소스 설명](../maps/sources/ZHR_52TM_CW_BASE_DATA.md).
