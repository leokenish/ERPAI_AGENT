# 출처·사본·마스킹 기록

- 추출일: 2026-10-12, Asia/Seoul
- 프로젝트 ID: kakao-work-context
- 원본 ZIP의 Library 식별자: `libfile_98e0659b89e48191b5fba0032266a118`
- 확보한 원본 파일명: `카카오톡업무맥락_TXT이미지연계_2026-10-08.zip`
- 원본 ZIP SHA-256: `4229e23e6cf572683b6a30dfb2e0eeef0a8e778b69974495eee4b2f5cfc3e3b6`
- 동일 이름의 다른 프로젝트 경로 복사본도 검색됐으나, 이 대화에서 실제 전달한 식별자와 일치하는 파일을 선택했다. 다른 복사본이 최신인지 추정하지 않았다.
- 확보한 원본 ZIP은 이전에 생성한 로컬 ZIP과 바이트 비교가 일치했다. 당시 읽은 MD 4개 전체 내용과 같은 최종본임을 확인했다.
- 원본은 수정하지 않았으며 교육용 사본만 별도 작성했다.

## 1. 실제 발화

확인 가능한 공개 발화 10개에는 이번 기준에 따라 마스킹할 개인 이름·인증값이 없어 `redacted=false`다. 맞춤법, 단정적 표현, 예시의 미검증 상태를 원문 내부에서 수정하지 않았다. 시각이 없는 발화는 timestamp=null이며 날짜는 source_locator에만 기록했다.

## 2. 첨부 사본의 마스킹

이름이 포함된 관련 자료의 파일명 언급에서 이름만 역할 별칭으로 대체했다. 대체 전 이름을 이 기록에 재노출하지 않는다. 파일별 원문 행 번호는 아래와 같다. 원문 줄 수와 나머지 내용은 유지했다.

| 교육용 사본 | 원문 행 | 대체값 | 사유 |
|---|---:|---|---|
| `assets/prior_summary/01_프로젝트_맥락과설계.md` | 229 | [담당자A] | 관련 후보 자료의 파일명 안에 있는 개인 이름. 원래 이름은 기록하지 않음. |
| `assets/prior_summary/01_프로젝트_맥락과설계.md` | 231 | [담당자B] | 관련 후보 자료의 파일명 안에 있는 개인 이름. 원래 이름은 기록하지 않음. |
| `assets/prior_summary/03_자료목록과보완사항.md` | 30 | [담당자A] | 관련 후보 자료의 파일명 안에 있는 개인 이름. 원래 이름은 기록하지 않음. |
| `assets/prior_summary/03_자료목록과보완사항.md` | 32 | [담당자B] | 관련 후보 자료의 파일명 안에 있는 개인 이름. 원래 이름은 기록하지 않음. |
| `assets/prior_summary/03_자료목록과보완사항.md` | 43 | [담당자C] | 관련 후보 자료의 파일명 안에 있는 개인 이름. 원래 이름은 기록하지 않음. |

## 3. 원본과 포함 사본의 해시

```json
[
  {
    "path": "assets/prior_summary/00_README.md",
    "source_sha256": "c93407a43bc4aea3338209f94878a4003a251de79b025831939731769bf32f0c",
    "included_sha256": "c93407a43bc4aea3338209f94878a4003a251de79b025831939731769bf32f0c",
    "redacted": false
  },
  {
    "path": "assets/prior_summary/01_프로젝트_맥락과설계.md",
    "source_sha256": "f4b5e40ff5e2427e1bdec82bd2d61a339382533e4134beb1058739d6c02278ac",
    "included_sha256": "f8dea25dbb96388dc81d8ba9b89bbb7fc974a74209f1792c3c3285e0b071dc0c",
    "redacted": true
  },
  {
    "path": "assets/prior_summary/02_교육과실습.md",
    "source_sha256": "5bda1ac0ae67872bf096fab8b0b0fbe8bf3978cf60cccc1b5d8aa34e7b6d3eb4",
    "included_sha256": "5bda1ac0ae67872bf096fab8b0b0fbe8bf3978cf60cccc1b5d8aa34e7b6d3eb4",
    "redacted": false
  },
  {
    "path": "assets/prior_summary/03_자료목록과보완사항.md",
    "source_sha256": "b21510b6cc7574fe00dd63f6796e03549b0e9135f1aa152ae822e201dc99389f",
    "included_sha256": "043702ed6afdcff3b7c9036aa9e6793bb9b7863b801457f511f17c8fda6a49c7",
    "redacted": true
  }
]
```

포함된 과거 ZIP은 위 사본 4개를 다시 압축한 파일이다. 원본 아카이브의 복제본이라고 표시하지 않는다. 기존 MD의 1.0은 원래 문서 버전이며 마스킹 날짜는 2026-10-12다.
