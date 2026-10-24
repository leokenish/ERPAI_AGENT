# 근태 페이지 개선 진행

출처: https://chatgpt.com/share/6ac704e5-ec3c-83ee-8874-a0b85fe777a9?ogimg=plain

공유 화면의 표시 순서대로 전사했습니다. 본문이 없는 응답 위치는 별도 표시합니다.

## ess1-t001-u1 · 사용자

얼마전에 말한 근태 페이지 개선하는 작업 여기에다가 해도 될까 ?

## ess1-t001-a1 · AI

네, 여기서 진행하시면 됩니다. 말씀하셨던 **SAP BSP 기반 근태·연차촉진 페이지 개선 작업**이시죠. 기존 처리 로직은 유지하면서, 기간 일괄 신청과 일별 취소, 오전·오후 반차 표시 등을 개선하는 방향으로 알고 있습니다.

**현재 화면 캡처와 수정할 BSP 소스**를 보내주시면, 화면 구성부터 실제 코드 수정까지 함께 진행하겠습니다. 소스가 길면 페이지별로 나눠서 보내주셔도 됩니다.

우선 개선하려는 화면부터 보여주세요.

## ess1-t002-u1 · 사용자

<첨부 파일 설명>

1. guntae~로 시작하는 파일들은 현재 근태페이지 구성하는 소스코드들이야
2. file_upload~로 시작하는 파일들은, 현재 근태페이지에서 파일 업로드가 있기는 한데, 파일 하나밖에 못올리는 문제가 있어서, 이 소스코드들을 활용해서 개선하려고 해
3. 근태입력화면은 현재 화면인데, CSS 파일 개선을 통해서 디자인을 세련되게 바꾸고싶어.
4. '3번'의 취지에 ESS화면이 최근에  프로젝트를 통해서 UI와 디자인이 개선되었는데, 이 ESS 메뉴 안에 근태 메뉴가 있으니까, 이와 디자인이 유사하게 바꾸고 싶어서 보여주는거야.

<근태 페이지 기능개선 점>

1. 한번에 기간으로 근태 신청할떄 주말이 껴있어도 알아서 빠져서 신청 해주는 기능
2. 위에처럼 한번에 기간으로 신청해서 승인까지 났는데, 추후 변경이 있을때 전체 기간을 다시 취소해야하는데 이렇게가 아닌 내가 변경하고 싶은 날짜만 할 수 있게 해주는 기능
3. 내역보이는 창의 줄이 좁아서, 내역 볼때 스크롤 해야하는 불편함이 있는데 이를 개선

…

## ess1-t002-a1 · AI

네. 첨부하신 소스를 확인했고, **이번 작업은 일반 근태 신청 페이지의 디자인 개선과 기능 개선**으로 이해했습니다. 앞서 제가 연차촉진 화면으로 좁혀 말씀드린 부분은 정정하겠습니다.

**현재 소스에서 확인한 내용과 개선 방향**은 다음과 같습니다.

| 개선 항목 | 현재 구조 | 개선 방향 |
| --- | --- | --- |
| ESS와 디자인 통일 | 기존 SAP HTMLB 화면과 공통 스타일 사용 | ESS처럼 연한 회색 배경, 흰색 카드, 둥근 모서리, 파란색 강조 적용 |
| 기간 신청 시 주말 제외 | 별도 함수에서 휴가 일수와 휴일 처리 | 실제 신청 대상 날짜에서 주말이 제외되는지 확인하고 보완 |
| 승인 후 특정 날짜만 변경·취소 | 선택한 신청 건의 전체 기간을 기준으로 처리 | 승인 건에서 변경할 날짜를 선택하고 나머지 날짜는 유지하도록 개선 |
| 신청 이력 표시 확대 | **목록 높이가 `170px`로 고정** | 목록 영역 확대, 화면 높이에 맞춘 조정, 긴 사유 줄바꿈 |
| 여러 파일 첨부 | 현재 근태는 단일 문서 연결 방식 | 제공하신 다중 첨부 모듈과 근태 신청 건을 연결 |

특히 기능 두 가지는 화면만 수정해서는 해결되지 않습니다.

**1. 주말 제외는 ‘일수 계산’과 ‘실제 근태 등록’을 함께 확인해야 합니다.**

현재 `ZHR_GUN_DAYS_LIMIT_CHECK`와 `ZHR_GUN_DAYS_COUNT`를 호출하면서 `holiday` 값을 전달하고 있습니다. 이미 휴일을 고려하는 구조는 있지만, 함수 본문이 없어 **일수만 제외하는지, 실제 등록에서도 제외하는지**는 아직 확인되지 않았습니다.

또한 화면에 근무형태와 휴일 포함 휴가가 있으므로, 모든 근태에서 토·일을 일괄 제외하면 안 됩니다. 우선 **통상근무 연차의 기간 신청**을 기준으로 적용 범위를 잡는 것이 적절합니다.

**2. 날짜별 변경·취소는 기존 승인 건과의 연결 처리가 필요합니다.**

현재 취소 처리에는 **원래 시작일·종료일과 다르면 취소를 막는 코드**가 있고, 이미 변경·취소 신청이 있는지도 원신청 번호로 검사합니다. 단순히 날짜 입력 제한을 풀면 되는 구조가 아닙니다.

예를 들어 9월 21~25일 승인 건에서 23일만 취소한다면, **21·22·24·25일의 승인은 유지하고 23일에 대해서만 취소 결재가 진행**되어야 합니다. 이를 위해 저장 함수와 결재 완료 시 실제 근태를 반영하는 로직까지 확인해야 합니다.

다중 첨부도 제공하신 모듈에 이미 `multiple` 입력과 파일별 저장 처리가 있습니다. 다만 기존 근태는 `ZEP_DOC_CREATE`로 생성한 문서를 연결하고, 제공 모듈은 `ZTCOMMON_FILE`에 저장하므로 **기존 첨부 조회와 새 첨부 연결을 함께 설계**해야 합니다.

다음 소스를 추가로 보내주시면 기능 수정 지점을 구체적으로 확정할 수 있습니다.

- **`ZHR_SAVE_ZTHR0080`** — 가장 먼저 필요한 저장·변경·취소 함수
- `ZHR_GUN_DAYS_COUNT`, `ZHR_GUN_DAYS_LIMIT_CHECK`
- `ZTHR0080` 테이블 필드 구성과 근태 BSP의 **페이지 속성(Attributes)**
- 가능하면 **결재 승인 후 실제 근태에 반영하는 프로그램 또는 함수**

**디자인과 이력창 확대는 지금 주신 소스로 먼저 진행할 수 있습니다.** ESS 화면의 분위기를 기준으로 근태 전용 CSS를 적용하고, 신청 영역·이력 영역·도움말 영역을 정돈하는 방향으로 잡겠습니다.

## ess1-t003-u1 · 사용자



## ess1-t003-a1 · AI

자료 확인했습니다. **주말·휴일을 사용 일수에서 제외하는 로직은 이미 있지만, 특정 날짜만 변경·취소하려면 저장 함수가 호출하는 하위 로직을 더 확인해야 합니다.**

이번 자료로 확인된 내용은 다음과 같습니다.

| 항목 | 확인 결과 |
| --- | --- |
| 휴일 제외 대상 | 통상근무 연차·반차, 장기근속휴가, 일부 청원휴가 등에 `HOLIDAY = 'X'` 설정 |
| 일수 계산 | `HOLIDAY_GET`에 달력 `KB`·`KR`을 전달하고, 반환된 휴일 개수를 전체 기간에서 차감 |
| 실제 날짜별 저장 | `ZHR_SAVE_ZTHR0080` 안의 `INSERT_DATA`에서 처리하므로 해당 본문 확인 필요 |
| 승인 후 변경·취소 | 모두 `CHANGE_DATA`를 호출 |
| 결재 상신 | `KULJAE_DATA`와 `INSERT_KOBIS`를 호출 |
| 첨부파일 | 테이블에 기존 문서 유형 `ZDOKAR`, 문서 번호 `ZATTACHMENT`가 있고, 별도의 첨부 그룹 필드는 보이지 않음 |

따라서 **“휴일을 빼서 일수를 계산한다”와 “휴일을 빼고 날짜별로 신청 건을 만든다”는 구분해서 수정**해야 합니다. 현재 일수 계산 함수는 시작일·종료일을 분리하거나 날짜별 신청을 만드는 역할은 하지 않습니다. 실제 토·일 제외 결과는 해당 SAP 달력 설정도 함께 확인해야 합니다.

추가로 보내주실 것은 **`ZHR_SAVE_ZTHR0080`이 속한 함수그룹의 FORM INCLUDE 소스**입니다. 아래 루틴이 들어 있는 INCLUDE를 통째로 주시면 개별적으로 여러 번 추출하실 필요가 없습니다.

- `CHECK_ERROR`, `CHECK_GUNCODE`, `MAPPING_CODE`
- **`INSERT_DATA`, `CHANGE_DATA`, `DELETE_DATA`**
- `CHECK_KULJAE`, `KULJAE_DATA`, `INSERT_KOBIS`

함수 소스에서 **`PERFORM insert_data`의 `insert_data`를 더블클릭**해 이동한 뒤, 열린 INCLUDE 전체를 보내주시면 됩니다. 다른 루틴이 별도 INCLUDE에 있으면 그것도 함께 주시면 됩니다.

이 부분을 확인하면 **새 기간 신청을 날짜별로 저장하는 방식으로 해결 가능한지, 기존에 기간으로 승인된 건은 별도 부분취소 처리가 필요한지**를 구체적으로 결정할 수 있습니다. 단순히 반복 저장하면 결재 건수가 늘거나 일부 날짜만 저장될 수 있어, 저장·결재 단위를 함께 확인하겠습니다.

## ess1-t004-u1 · 사용자

일단 근태 페이지 미리보기 해 줄 수 있어 ?

## ess1-t004-a1 · AI

ESS 디자인에 맞춘 미리보기입니다. **기간 선택·다중 첨부·날짜별 변경**을 눌러보실 수 있습니다. 실제 SAP에는 반영되지 않습니다.

Guntae Preview을(를) 생성하고 있습니다

## ess1-t005-u1 · 사용자

이 화면에서 취소 하고 싶은경우에는 어떻게 해야하는거지 ?

## ess1-t005-a1 · AI

이 미리보기에서는 다음 순서로 취소하시면 됩니다.

1. **근태 신청 이력**에서 취소하려는 승인 건 오른쪽의 **[날짜별 변경]**을 누릅니다.
2. 아래에 펼쳐지는 영역에서 **취소할 날짜를 체크**합니다.
3. **[선택일 취소]**를 선택합니다.
4. 취소 사유를 입력하고 **[변경·취소 신청]**을 누릅니다.

**전체 기간을 취소하려면 모든 날짜를 체크**하시면 됩니다. 일부만 선택하면 나머지 날짜는 기존 승인을 유지하는 구상입니다.

버튼명이 **[날짜별 변경]**이라 취소 기능을 찾기 어렵네요. **[변경·취소]**로 표시하는 편이 명확하겠습니다. 현재는 미리보기이므로 실제 취소나 결재는 진행되지 않습니다.

## ess1-t006-u1 · 사용자

응 다시 미리보기해줘

## ess1-t006-a1 · AI

승인 내역 오른쪽 버튼을 **[변경·취소]**로 수정했습니다. 눌러서 취소할 날짜를 선택하시면 됩니다.

Guntae Cancel Preview을(를) 생성하고 있습니다

## ess1-t007-u1 · 사용자

좋아. 그리고 미리보기 색상은 ESS 메뉴 혹은 현재 근태 페이지 처럼 읜색 베이스가 돼야 할것 같은데, 왜이렇게 어둡게 된거지 ?

## ess1-t007-a1 · AI

앱의 다크 모드를 따라가서 어둡게 보였던 것입니다. **ESS처럼 흰색 카드·연한 회색 배경·파란색 강조**로 고정했습니다.

Guntae Light Preview을(를) 생성하고 있습니다

## ess1-t008-u1 · 사용자

글씨 색깔이 밝아서 안보여

## ess1-t008-a1 · AI

제목·날짜·취소 선택 문구를 **진한 글자색**으로 수정했습니다.

Guntae Readable Preview을(를) 생성하고 있습니다

## ess1-t009-u1 · 사용자

기승인건에서 변경/취소할때, 하루 근태건은 자동선택 되게 하는게 어떨까

## ess1-t009-a1 · AI

네, **하루짜리 승인 건은 [변경·취소]를 누르면 해당 날짜가 자동 선택**되는 게 자연스럽습니다. 선택지가 하나라 다시 체크할 필요가 없으니까요.

- **하루짜리·반차 건:** 날짜 자동 선택 → 변경 또는 취소 선택 → 사유 입력 → 신청
- **여러 날짜 건:** 원하는 날짜를 직접 선택하고, **[전체 선택]**도 제공

날짜만 자동 선택하고, **실제 신청은 마지막 버튼을 눌렀을 때 진행**하면 편리하면서도 실수도 줄일 수 있습니다.

## ess1-t010-u1 · 사용자

응 이런식으로 사용자 입장에서 진행시 편리하면서 실수 줄일 수 있는게 뭐가있을지, 개선해서 미리보기 다시 보여주고, 개선 된점 정리해줘

## ess1-t010-a1 · AI

**하루짜리 승인 건의 [변경·취소]**를 눌러보시면 자동 선택을 확인하실 수 있습니다.

Guntae Convenient Preview을(를) 생성하고 있습니다

개선한 점입니다.

| 개선 | 사용자 편의·실수 방지 |
| --- | --- |
| 하루·반차 날짜 자동 선택 | 불필요한 체크 생략 |
| 여러 날짜 전체 선택·해제 | 전체 취소도 간편하게 처리 |
| 날짜에 요일 표시, 선택 개수·일수 표시 | 대상 날짜를 쉽게 확인 |
| 취소·변경 방법 직접 선택 | 취소가 기본 선택되어 발생할 실수 방지 |
| 필수 입력 완료 후 확인 버튼 활성화 | 날짜·처리 방법·사유 누락 방지 |
| 신청 전 최종 확인 | 대상 날짜, 변경 전후 내용, 사유를 재확인 |
| 처리 중인 날짜 선택 제한 | 동일 날짜 중복 변경·취소 방지 |
| 작성 중 닫기 확인 | 입력 내용이 실수로 사라지는 것 방지 |
| 첨부 추가·개별 제거 및 검사 | 중복 파일·잘못된 형식·용량 초과 확인 |

**현재는 예시 데이터로 동작하는 미리보기이며, 실제 SAP 저장·결재 연동은 별도 구현이 필요합니다.**

## ess1-t011-u1 · 사용자

기승인건에서 오전반차면 '오전반차로 변경' 은 안보이거나 비활성화, 오후반차면 '오후반차로 변경' 안보이거나 비활성화 처리해줘

## ess1-t011-a1 · AI

반영했습니다. **현재 승인 유형과 같은 옵션은 회색으로 비활성화**하고 ‘현재 승인 유형’을 표시했습니다.

- 오전 반차 승인 → **오전 반차로 변경** 비활성화
- 오후 반차 승인 → **오후 반차로 변경** 비활성화

Guntae Halfday Preview을(를) 생성하고 있습니다

## ess1-t012-u1 · 사용자

이렇게 기간설정을 먼저 하고나서, 밑에 해당 가능한 날짜가 떴고 여기에서

1. 연일 선택이면 기간으로 신청 (현재처럼)
2. 저 날짜리스트에서 클릭을 해서 제외처리(휴일이 아닌 사용자 선택)를 하면 신청이 연일과 단수일로 나눠서 신청

이렇게 가능할까 ?

## ess1-t012-a1 · AI

네, 가능합니다. **기간을 먼저 지정하고, 날짜를 클릭해 제외하면 남은 날짜를 연속 구간별로 묶어 신청**하는 방식입니다.

예를 들어 **10월 5일~9일**을 선택한 경우입니다.

| 날짜 선택 | 생성되는 신청 |
| --- | --- |
| 모두 선택 | **10/5~10/9** 기간 신청 1건 |
| 10/7 제외 | **10/5~10/6**, **10/8~10/9** 기간 신청 2건 |
| 10/6 제외 | **10/5** 단일 신청 + **10/7~10/9** 기간 신청 |
| 10/6·10/8 제외 | **10/5**, **10/7**, **10/9** 단일 신청 3건 |

화면은 이렇게 구성하면 편리하겠습니다.

- **신청 가능한 날짜는 처음에 모두 선택**
- 날짜를 클릭하면 **‘사용자 제외’** 표시, 다시 클릭하면 복원
- 주말·휴일의 **자동 제외**와 사용자의 **직접 제외**를 다르게 표시
- 아래에 **“총 4일 · 신청 2건”**과 실제 생성될 기간을 미리 표시
- **[선택 내역 저장]** 한 번으로 나뉜 신청을 함께 저장
- 모든 날짜를 제외하면 저장 버튼 비활성화

**주말·휴일은 기존 근태별 산정 규칙을 유지하고, 사용자가 제외한 날짜를 기준으로 신청 구간을 나누면 됩니다.**

실제 구현에서는 나뉜 건을 **모두 저장하거나, 오류가 있으면 전체 저장을 취소**하도록 해야 일부만 신청되는 혼란을 막을 수 있습니다. 결재도 한 번에 상신할 수 있을지는 앞서 요청드린 저장·결재 FORM 소스를 확인해 연결하겠습니다.

## ess1-t013-u1 · 사용자

응 이것 반영해서 미리보기 다시 해줘

## ess1-t013-a1 · AI

반영했습니다. **기간 아래 날짜를 클릭**해보세요.

- 클릭하면 제외, 다시 클릭하면 복원됩니다.
- 남은 날짜가 **기간·단일 신청으로 자동 분리**됩니다.
- 아래에 **신청 구간·건수·일수**가 표시됩니다.
- **[선택 내역 ○건 저장]**을 누르면 예시 이력에 구간별로 추가됩니다.

Guntae Date Exclusion Preview을(를) 생성하고 있습니다

## ess1-t014-u1 · 사용자

지금 화면 로직 좋아. 이대로 가자.
그리고 지금 소스코드에 혹시 근태 지정이 안되는 날에 대한 기준이 어떤건지 알 수 있어?

## ess1-t014-a1 · AI

네. **화면은 지금 로직으로 진행하겠습니다.**
신청할 수 없는 날짜의 기준은 일부 확인됐지만, **최종 저장 단계의 제한은 아직 하위 FORM 소스가 필요합니다.**

| 구분 | 보내주신 소스에서 확인한 내용 |
| --- | --- |
| **달력에서 날짜 선택 제한** | 시작일·종료일 입력에 특정 날짜를 선택하지 못하게 하는 설정은 보이지 않습니다. |
| **주말·휴일 제외** | 통상근무 연차·반차 등은 SAP 달력 **`KB`·`KR`**을 조회해 휴일을 사용 일수에서 제외합니다. |
| **기간 오류** | 시작일이 종료일보다 늦으면 저장을 중단합니다. |
| **휴가별 최대 일수** | 계산된 일수가 유형별 한도를 초과하면 저장을 중단합니다. |
| **과거 날짜·정산 마감 제한** | 관련 코드가 있으나, 해당 페이지에서는 **주석 처리**되어 있습니다. 다른 로직에서 적용되는지 추가 확인이 필요합니다. |

특히 **과거 날짜 제한**과 관련해 다음 기준이 소스에 남아 있습니다.

- **매월 5일까지:** 지난달 근태까지 신청·변경 허용
- **매월 6일부터:** 이번 달 이후 근태만 신청·변경 허용
- 이보다 오래된 근태는 별도 근태변경신청서로 처리

다만 이 부분에는 **“동일한 로직 존재하여 주석 처리”**라고 적혀 있습니다. 또 별도로 **오늘 이전 날짜의 신청을 막는 코드**도 주석 처리되어 있어, **어느 기준이 현재 실제 적용되는지는 이 파일만으로 확정할 수 없습니다.**

실제 저장 함수에서는 아래 검사를 실행하고 있습니다.

```
PERFORM check_error ...
PERFORM check_guncode ...
```

**우선 `CHECK_ERROR` 본문을 보내주시면**, 과거 날짜·마감일·중복 근태 등 어떤 조건으로 신청이 막히는지 확인하겠습니다.

그리고 **휴일을 일수에서 제외한다는 것이 그 날짜의 선택 자체를 금지한다는 뜻은 아닙니다.** 실제 화면에는 근태유형과 근무형태에 맞는 기준을 연결해야 하며, 지금 미리보기의 토·일 제외는 예시 처리입니다.

## ess1-t015-u1 · 사용자

일단 위 미리보기처럼 적용해 보고 싶어. 각각 파일 개선해서 다운로드 받게 해줘 .

그리고 너가 바꾼 페이지 스타일은 내가 현재 파일을 안줬는데, 필요한 파일이 있으면 얘기해줘

## ess1-t015-a1 · AI

다운로드할 수 있게 준비했습니다.

**`guntae_ui_v1.zip`** — 전체 파일과 적용 안내 포함

**이번 SAP 적용본은 디자인·이력창 개선본입니다.** 날짜 제외·분할 저장·부분취소·다중 첨부는 아직 서버 연동 전이며, 별도 미리보기에서 동작합니다.

| 파일 | 용도 |
| --- | --- |
| `guntae_input_layout.kbs` | 기존 BSP의 Layout 교체 |
| `guntae_ess_v1.css` | 흰색 베이스·카드·입력창·이력 스타일 |
| `guntae_ess_v1.js` | 이력 전체 펼치기·접기 |
| `guntae_preview.html` | 합의한 전체 화면 동작 체험 |
| `README_KO.md` | 적용 순서·파일별 변경 여부·검증 항목 |

CSS·JS는 **같은 BSP 애플리케이션의 MIME 객체로 등록**하시면 됩니다. 기존 이벤트 소스는 유지합니다. ABAP·버튼 이벤트 보존과 JavaScript 문법은 확인했으며, **개발 SAP에서 문법 검사와 화면 확인은 필요합니다.**

스타일은 기존 파일을 수정한 것이 아니라 **ESS 캡처를 참고해 새로 작성**했습니다. 정확히 맞추려면 다음 자료를 보내주세요.

- **`jscommon.kbs`와 여기서 참조하는 CSS**
- **개선된 ESS 화면의 실제 CSS**
- 가능하면 근태 화면의 **렌더링된 HTML** — 개발자도구에서 버튼·입력창·이력 부분

전체 기능까지 실제 적용하려면, 앞서 요청드린 **`CHECK_ERROR`, `INSERT_DATA`, `CHANGE_DATA`, 결재 관련 FORM이 들어 있는 INCLUDE**도 필요합니다.

guntae_ess_v1.css코드guntae_ess_v1.js코드guntae_preview.htmlHTMLREADME_KO.md문서

## ess1-t016-u1 · 사용자

CSS·JS는 **같은 BSP 애플리케이션의 MIME 객체로 등록**하는방법을 잘 모르겠어

## ess1-t016-a1 · AI

네. 여기서 **MIME 객체 등록은 PC에 있는 CSS·JS 파일을 SAP BSP 애플리케이션에 업로드하는 작업**입니다. 소스를 붙여넣는 것이 아니라 파일을 올리시면 됩니다.

**1. 파일 2개를 PC에 다운로드하세요.**

**2. 개발 SAP에서 `SE80`을 실행하세요.**

왼쪽 위 객체 선택에서 **BSP 애플리케이션**을 선택하고, 현재 `guntae_input.kbs`가 들어 있는 애플리케이션을 여세요.

**3. 왼쪽 트리에서 애플리케이션 이름을 우클릭하세요.**

일반적으로 다음 메뉴를 사용합니다. SAP 버전·언어에 따라 명칭이 조금 다를 수 있습니다.

**[생성(Create)] → [MIME 객체(MIME Object)]**

파일 선택 창이 나오면 먼저 **`guntae_ess_v1.css`**를 선택하세요.

**4. 저장 위치와 파일명을 확인하세요.**

이번에 드린 Layout은 아래처럼 파일을 참조합니다.

```
href="guntae_ess_v1.css?v=1"
src="guntae_ess_v1.js?v=1"
```

따라서 **별도의 `css`·`js` 하위 폴더를 만들지 말고 애플리케이션 루트에 등록**해 주세요. 파일명도 그대로 유지하시면 됩니다.

속성에서 MIME 유형을 입력하거나 확인하는 항목이 나오면 다음과 같습니다.

| 파일 | MIME 유형 |
| --- | --- |
| `guntae_ess_v1.css` | `text/css` |
| `guntae_ess_v1.js` | `application/javascript` 또는 `text/javascript` |

**5. 패키지·CTS 요청을 지정해 저장하세요.**

입력을 요구하면 기존 BSP가 사용하는 패키지와 이번 작업의 CTS 요청을 선택하시면 됩니다.

같은 방법으로 **`guntae_ess_v1.js`도 등록**하세요. 등록 후 왼쪽 트리의 **MIME 객체** 아래에서 두 파일을 확인합니다.

**6. 개선 Layout을 적용하세요.**

`guntae_input.kbs`를 열고 **Layout 탭**에 제가 드린 개선 Layout 내용을 적용한 뒤, 문법 검사·활성화하고 브라우저에서 **Ctrl+F5**로 새로고침하세요. CSS·JS를 불러오는 코드는 개선 Layout에 이미 들어 있습니다.

**우선 3번에서 애플리케이션 이름을 우클릭한 화면을 보여주시면, 실제 보이는 메뉴 기준으로 정확히 짚어드리겠습니다.**

guntae_ess_v1.css코드guntae_ess_v1.js코드

## ess1-t017-u1 · 사용자

현재 이렇게 돼있는데, 두 폴더의 차이가 뭐야 그럼?

## ess1-t017-a1 · AI

화면의 **Page Fragments**와 **MIMEs**는 용도가 다릅니다.

| 구분 | Page Fragments | MIMEs |
| --- | --- | --- |
| 역할 | BSP 페이지에 포함하는 **공통 소스 조각** | 브라우저가 불러오거나 다운로드하는 **파일** |
| 내용 | HTML·ABAP·스크립트 등 | CSS·JS·이미지·HWP 등 |
| 사용 방식 | `<%@include file="..." %>`로 포함 | `href`, `src` 등의 URL로 참조 |
| 현재 화면 예시 | `guntae_header.kbs`, `tab_css.kbs` | 도움말 HTML, HWP 파일들 |

**`tab_css.kbs`가 Page Fragments에 있는 이유**는 CSS 내용을 `<style>...</style>`로 감싸서 페이지에 포함하는 방식일 수 있기 때문입니다. 정확한 내용은 파일을 열어봐야 알 수 있습니다.

제가 드린 **`guntae_ess_v1.css`와 `guntae_ess_v1.js`는 아래쪽 `MIMEs`에 등록**하시면 됩니다. 위 두 항목은 일반적인 경로 폴더라기보다 **객체 종류별 분류**이므로, Layout 경로에 `MIMEs/`를 붙이지 않습니다.

그리고 **`tab_css.kbs`와 `guntae_header.kbs` 소스도 보내주세요.** 기존 스타일을 어떻게 불러오는지 확인해서, 새 CSS와 충돌하지 않게 맞추겠습니다.

## ess1-t018-u1 · 사용자



## ess1-t018-a1 · AI

확인했습니다. **두 파일은 근태 입력 화면 전체의 스타일 파일은 아닙니다.**

| 파일 | 실제 역할 | 이번 수정 필요 여부 |
| --- | --- | --- |
| `tab_css.kbs` | 탭의 선택 색상·높이·배경 이미지 등 **탭 전용 CSS** | 현재는 유지 |
| `guntae_header.kbs` | 사번·성명·소속·직급·직위를 보여주는 **기본정보 영역** | 현재는 유지 |

보내주신 **`guntae_input_layout.kbs`에는 이 두 파일을 직접 포함하는 코드가 없습니다.** 상위 페이지에서 사용하는지는 별도 확인이 필요합니다.

근태 입력 페이지가 직접 불러오는 공통 파일은 다음입니다.

`<%@include file="../../sap/zcommon/jscommon.kbs" %>`

**다음에는 `ZCOMMON` BSP 애플리케이션의 `jscommon.kbs`를 보내주세요.** 이 파일을 보면 실제로 불러오는 CSS·JavaScript 경로를 확인할 수 있습니다.

지금 주신 두 파일은 수정하지 않고, 제가 드린 **`guntae_ess_v1.css`·`.js`는 근태 BSP의 MIMEs에 추가**하는 방향으로 진행하시면 됩니다.

## ess1-t019-u1 · 사용자



## ess1-t019-a1 · AI

확인했습니다. **`jscommon.kbs`는 공통 JavaScript 함수 파일이며, CSS를 연결하는 코드는 없습니다.**

| 확인 항목 | 내용 |
| --- | --- |
| 날짜 처리 | 날짜 형식 검사, 날짜 간 차이 계산, 기간 검사 |
| 입력 검사 | 필수값·숫자·문자 길이 검사 |
| 첨부파일 | 확장자·용량 검사, 기존 문서 다운로드 함수 |
| 외부 파일 연결 | `../zcommon/js/messege_ko.js` |
| 주말·휴일 제외 | 이 파일에는 해당 판단 로직이 없습니다 |

기간을 1년 이내로 검사하는 함수도 있지만, **근태 페이지에서 실제로 호출하는지까지 확인해야 적용 기준이라고 볼 수 있습니다.**

현재 근태 화면의 기본 디자인은 Layout에서 지정하는 아래 설정과 연결되어 있습니다.

```
zcl_cm_util_bsp=>design
zcl_cm_util_bsp=>themeRoot
```

따라서 기존 테마 경로를 더 확인하려면 **SE24의 `ZCL_CM_UTIL_BSP` 클래스에서 `THEMEROOT`, `DESIGN` 값을 설정하는 코드**를 보내주시면 됩니다. `CLASS_CONSTRUCTOR`에 있을 수 있습니다.

다만 **앞서 드린 근태 전용 CSS·JS를 적용하는 데 이 자료가 필수는 아닙니다.** `jscommon.kbs`는 그대로 두고, 근태 BSP 애플리케이션의 **MIMEs에 `guntae_ess_v1.css`, `guntae_ess_v1.js`를 등록**하는 방식으로 진행하시면 됩니다.

현재 배포 파일의 적용 범위는 **화면 스타일과 내역 영역 개선**이며, 날짜 제외·분할 신청·부분 변경/취소는 서버 로직 연동이 추가로 필요합니다.

## ess1-t020-u1 · 사용자

짜 제외·분할 신청·부분 변경/취소는 서버 로직 연동이 추가로 필요하다는게 무슨말인거지 ?

## ess1-t020-a1 · AI

**미리보기에서 동작하는 기능이 실제 SAP에 저장·결재되는 기능까지 완성된 것은 아니라는 뜻입니다.** 앞서 “적용할 파일”이라고 드리면서 이 차이를 명확히 설명하지 못했습니다. 죄송합니다.

예를 들어, **10월 5일~9일을 신청하면서 7일을 제외**하면 다음처럼 처리되어야 합니다.

| 단계 | 필요한 동작 | 현재 상태 |
| --- | --- | --- |
| 화면 | 7일 제외 표시, 5~6일 / 8~9일로 나눠 보여주기 | 미리보기에서 구현 |
| SAP 저장 | 두 기간을 각각 신청 건으로 저장하고 일수·중복 여부 검사 | 기존 ABAP 수정 필요 |
| 결재 | 나뉜 신청 건을 결재에 연결하고 승인 결과 반영 | 기존 결재 처리 확인·수정 필요 |

**승인된 5일 중 하루만 취소하는 것도 같은 차이가 있습니다.** 화면에서 하루를 선택하는 것에 더해, SAP에서 그 하루의 취소 요청을 저장하고, 취소 승인 후에는 나머지 4일의 승인을 유지하면서 사용일수까지 맞춰야 합니다.

현재 보내주신 `ZHR_SAVE_ZTHR0080`에는 저장·변경 처리를 **다른 `FORM`으로 넘기는 부분**이 있습니다. 그런데 실제 처리를 수행하는 `INSERT_DATA`, `CHANGE_DATA`, `CHECK_ERROR` 등의 본문은 아직 없어서, 그 부분까지 완성하지 못한 상태입니다.

따라서 현재 상태는 다음과 같습니다.

- **미리보기:** 날짜 제외·분할 신청·부분 변경/취소의 화면 동작 구현
- **드린 SAP 적용 파일:** 디자인과 내역 표시 영역 개선
- **아직 필요한 작업:** 위 기능을 실제 저장·결재에 연결하는 ABAP 수정

**요청하신 최종 목표에는 이 ABAP 수정도 포함됩니다.** 별도의 추가 요구사항이라는 뜻이 아니라, 제가 아직 완료하지 못한 작업입니다. 다음으로 **`ZHR_SAVE_ZTHR0080`이 속한 함수 그룹의 TOP 및 FORM INCLUDE 소스와 결재 승인 시 근태를 반영하는 소스**를 받아야 이어서 수정할 수 있습니다.

## ess1-t021-u1 · 사용자

**`ZHR_SAVE_ZTHR0080`** ...이것 관련 현재는 내가 너한테 함수 소스코드만 줬었나 ?
더 필요한게 뭐야 ?

## ess1-t021-a1 · AI

네. **`ZHR_SAVE_ZTHR0080.txt`로 함수 본문을 주셨습니다.** 다만 그 안에서 `PERFORM`으로 호출하는 **하위 처리 로직인 `FORM` 본문**이 더 필요합니다.

예를 들어 함수에 다음 코드가 있어도,

```
PERFORM insert_data.
```

실제로 어떤 데이터를 어떻게 저장하는지는 아래 부분을 봐야 알 수 있습니다.

```
FORM insert_data.
  " 실제 저장 처리
ENDFORM.
```

**추가로 필요한 소스는 다음과 같습니다.**

| 필요한 소스 | 확인 목적 |
| --- | --- |
| 함수 그룹의 **TOP INCLUDE** | 전역변수·내부테이블·공통 데이터 선언 |
| `CHECK_ERROR`, `CHECK_GUNCODE`, `MAPPING_CODE` | 신청 가능 조건·중복 검사·근태 코드 변환 |
| `INSERT_DATA` | 분할된 기간을 실제로 저장하는 방법 |
| `CHANGE_DATA`, `DELETE_DATA` | 일부 날짜 변경·취소 시 기존 신청 건 처리 |
| `CHECK_KULJAE`, `KULJAE_DATA`, `INSERT_KOBIS` | 결재 검증·상신 처리 |
| **결재 승인·반려 후 근태 반영 소스** | 일부 날짜만 변경·취소하고 나머지 승인을 유지하는 처리 |

가장 편한 방법은 **`ZHR_SAVE_ZTHR0080`이 속한 함수 그룹에서 TOP INCLUDE와 FORM이 들어 있는 INCLUDE를 통째로 보내주시는 것**입니다. 위 FORM을 하나씩 따로 추출하지 않으셔도 됩니다.

우선 `PERFORM insert_data`를 더블클릭해서 이동한 소스의 **INCLUDE 전체**를 보내주세요. 그 파일에 다른 FORM도 함께 들어 있다면 한 번에 확인할 수 있습니다. 이어서 TOP INCLUDE를 주시면 되고, 결재 완료 처리 소스의 위치는 받은 코드에서 연결 관계를 먼저 찾아보겠습니다.

## ess1-t022-u1 · 사용자



## ess1-t022-a1 · AI

네, **이번에 주신 두 파일에 앞서 요청드린 주요 FORM들이 모두 포함되어 있습니다.** 이제 실제 저장·변경 처리까지 확인할 수 있습니다.

| 파일 | 확인된 내용 |
| --- | --- |
| `LZHR008TOP.txt` | 함수 그룹의 전역변수·내부테이블·결재 관련 선언 |
| `LZHR008F01.txt` | 입력 검증, 근태코드 변환, 저장·삭제, 변경/취소 요청 저장, 결재상신 |

코드에서 중요한 사항도 확인했습니다.

- **오전·오후 반차는 현재 서버에서 하루씩만 신청하도록 제한**하고 있습니다. 여러 날짜의 반차를 선택하면 저장할 때 날짜별 신청 건으로 나누어야 합니다.
- **변경·취소 요청은 원래 승인 건의 결재번호를 `ZSERIAL2`에 연결해 별도 저장**합니다.
- **원래 승인 건에 변경·취소 건이 있는지 검사하는 로직**이 있어, 날짜별 부분 처리를 지원하려면 이 검사도 함께 수정해야 합니다.
- 결재상신은 **`ZWF_START_WORK_HR`을 근태 구분 `G`로 호출**합니다.

**다음으로 필요한 것은 아래 두 가지입니다.**

1. **`ZWF_START_WORK_HR` 함수 소스**
  이번 파일에는 결재를 시작하는 부분까지 확인됩니다. 승인 후 실제 근태를 변경·취소하는 코드로 연결되는 경로를 찾기 위해 필요합니다. 이 함수 자체가 최종 승인 처리 함수라는 뜻은 아닙니다.
2. **`ZSHR0032` 구조의 전체 필드 정보**
  SE11에서 조회한 구성요소를 보내주시면 됩니다. 신청 정보와 선택한 날짜를 서버에 전달할 구조를 확인하려는 목적입니다.

우선 **`ZWF_START_WORK_HR` 소스부터 보내주시면 됩니다.** 이번에 받은 TOP·FORM 파일은 다시 보내실 필요 없습니다.

## ess1-t023-u1 · 사용자



## ess1-t023-a1 · AI

확인했습니다. **`ZSHR0032`는 `ZTHR0080`을 그대로 INCLUDE한 구조**입니다. 구조 정보는 이제 확인됐으므로 다시 보내주실 필요 없습니다.

이번 `ZWF_START_WORK_HR`에서 확인된 흐름은 다음과 같습니다.

| 처리 | 코드에서 확인한 내용 |
| --- | --- |
| 결재번호 생성 | `ZWF_GET_NEXTNUM` 호출 |
| 근태 결재 구분 | `G` |
| 결재 테이블 지정 | `ZWF0022` |
| 실제 결재 시작 | **`ZWF_START_WORK` 호출** |

즉, 이번 함수는 **결재번호와 결재선을 준비해서 `ZWF_START_WORK`에 넘기는 역할**입니다. 승인 후 근태 데이터를 반영하는 로직은 여기에 없습니다.

**다음으로 `ZWF_START_WORK` 함수 전체 소스를 보내주세요.** 그 안에 별도 `PERFORM` 호출이 있으면 해당 FORM이 들어 있는 INCLUDE도 함께 주시면, 파일을 반복해서 요청하는 일을 줄일 수 있습니다.

계속 연결된 소스를 확인하는 이유는 **선택한 하루를 취소했을 때 기존 기간 전체가 취소되지 않도록, 최종 승인 처리까지 확인해야 하기 때문**입니다. 현재까지 신청 저장·변경/취소 요청 저장·구조 정보는 확보됐고, 결재 이후 실제 반영 경로를 찾고 있습니다.

## ess1-t024-u1 · 사용자



## ess1-t024-a1 · AI

확인했습니다. **이번 소스로 결재 시작 경로와, 다음에 찾아야 할 워크플로우 식별 지점까지 확인됐습니다.**

`LZWF02F01`에서는 근태 결재에 사용할 작업번호를 **`C_ZWF0022`라는 전역 상수/변수에서 가져와**, `SWW_WI_START`에 전달합니다.

```
CONCATENATE 'C_' tabname INTO l_field_name.
ASSIGN (l_field_name) TO <fs_field>.
g_task = <fs_field>.
```

이번 파일들의 역할은 다음과 같습니다.

| 파일 | 확인된 역할 |
| --- | --- |
| `ZWF_START_WORK` | 결재 시작 및 결재 테이블 갱신 |
| `LZWF02F01` | 결재선·상태 관리, 워크플로우 호출 |
| `LZWF02F06` | 결재 제목 저장 처리. 근태는 해당 저장에서 제외 |
| `ZWF_SET_INDEX` | 현재 결재 대상자 조회 |
| `ZWF_SET_PENDING_LIST` | 결재 진행현황 조회용 데이터 저장 |

**선택한 날짜의 근태를 실제로 변경·취소하는 코드는 이번 파일에서도 확인되지 않았습니다.** 공통 결재 처리에서 워크플로우로 넘어가는 구조입니다.

다음에는 전체 소스를 더 추출하기보다, **`C_ZWF0022`의 선언과 값만 먼저 보내주세요.** `ZWF02` 함수 그룹의 TOP INCLUDE에서 검색해 보시면 됩니다. 찾기 어려우시면 **`LZWF02TOP` 전체**를 보내주셔도 됩니다.

이 값을 알아야 어떤 워크플로우의 승인 후 처리를 확인할지 정확히 지정할 수 있습니다. **SAP 표준 함수 `SWW_WI_START` 소스는 보내실 필요 없습니다.**

## ess1-t025-u1 · 사용자

이걸로 될까 ?

## ess1-t025-a1 · AI

네, **찾으려던 값이 이 파일에 있습니다.**

```
c_zwf0022 LIKE functab-element VALUE 'WS95000055',  " HR
```

근태 결재에서 시작하는 워크플로우는 **`WS95000055`**로 확인됐습니다.

이제 함수 소스를 더 따라가기보다 **해당 워크플로우의 승인 후 처리 단계**를 확인하면 됩니다.

1. **SWDD**에서 `WS95000055`를 조회해 주세요.
2. **전체 흐름 화면을 캡처**해서 보내주세요.
3. 화면에서 승인 후 처리 단계를 찾으면, 제가 열어볼 단계와 필요한 소스를 짚어드리겠습니다.

**이번 파일로 워크플로우 식별은 완료됐습니다.** 부분 취소 구현을 마무리하려면 그 안에서 실제 근태 데이터를 반영하는 처리까지 확인해야 합니다.

## ess1-t026-u1 · 사용자



## ess1-t026-a1 · AI

네, 맞는 화면입니다. **다음으로 왼쪽 목록의 `000059 HR 기타 결재`를 더블클릭해 주세요.** 가운데 그림의 ‘HR 기타 결재’를 더블클릭하셔도 됩니다.

열리는 상세 화면에서 **태스크 번호(`TS…`)가 보이도록 캡처**해 주세요. 태스크 번호와 설명이 함께 나오면 됩니다.

현재 흐름은 **결재자 지정 → HR 기타 결재 → 승인·반려 상태 분기**로 보입니다. 따라서 먼저 ‘HR 기타 결재’에 연결된 실행 메서드를 확인해야 실제 근태 반영 코드를 찾을 수 있습니다.

## ess1-t027-u1 · 사용자



## ess1-t027-a1 · AI

확인됐습니다. **태스크 번호는 `TS95000125`입니다.**

화면 위쪽 **`TS95000125`를 더블클릭**해서 태스크 정의를 열어주세요. 열린 화면의 **기본 데이터(Basic Data)** 탭에서 아래 항목이 보이도록 캡처해 주시면 됩니다.

- **오브젝트 유형 / 클래스**
- **메서드**

이 정보로 ‘HR 기타 결재’가 실행하는 실제 코드의 위치를 확인할 수 있습니다.

## ess1-t028-u1 · 사용자



## ess1-t028-a1 · AI

확인됐습니다. 연결된 실행 대상은 **BOR 오브젝트 `ZWFET22`의 `APPROVE` 메서드**입니다.

다음 순서로 소스를 열어주세요.

1. **SWO1** 실행
2. 오브젝트 유형에 **`ZWFET22`** 입력 → **조회**
3. **메서드(Methods)** 목록에서 **`APPROVE`** 선택
4. **프로그램/소스코드** 버튼으로 구현 코드 열기

열린 소스에서 **`BEGIN_METHOD … APPROVE`부터 `END_METHOD`까지** 보내주세요. 전체 프로그램을 텍스트로 보내주셔도 됩니다.

이 메서드가 실제 승인 처리를 하는지, 결재 화면이나 다른 함수를 호출하는지 확인하면 됩니다. 화면의 안내 문구상 **KOBIS·포털 결재와 연결되어 있으므로**, 이름만 보고 이 메서드가 근태를 최종 반영한다고 단정하지 않고 코드를 확인하겠습니다.

## ess1-t029-u1 · 사용자

근데 할건데, 이거 지금 뭐때문에 하는지 알려줄 수 있어 ?

## ess1-t029-a1 · AI

지금 하는 건 **“승인된 기간 중 선택한 날짜만 변경·취소”하기 위해, 실제 근태를 수정하는 코드를 찾는 작업**입니다.

예를 들어 **월~금 5일이 승인된 상태에서 수요일만 취소**하려면,

- 수요일만 취소 요청을 올리고
- 결재자가 승인하면 수요일만 근태에서 빼고
- 나머지 4일은 승인 상태를 유지하고
- 연차 사용일수도 5일에서 4일로 반영해야 합니다.

지금까지 받은 소스로 **신청 저장과 취소 요청을 만드는 부분**은 확인했습니다. 그런데 **취소가 승인된 뒤 원래 근태를 실제로 어떻게 삭제하는지**는 아직 확인하지 못했습니다.

이 부분을 확인하지 않고 화면과 신청 로직만 바꾸면, **수요일만 선택해도 기존 처리에서 월~금 전체를 취소할 가능성**이 있습니다. 그래서 결재 함수 → 워크플로우 → 실행 메서드 순서로 따라가고 있는 겁니다.

**디자인 개선 때문에 필요한 작업은 아닙니다. 핵심 목적은 ‘기승인 건의 날짜별 부분 변경·취소’입니다.** 제가 중간 목적을 충분히 설명하지 않고 계속 소스를 요청해서 번거롭게 느껴지셨을 것 같습니다.

## ess1-t030-u1 · 사용자

여기서 어떻게 해야돼 ?

## ess1-t030-a1 · AI

지금 **`ZWFET22.APPROVE`가 선택되어 있으니**, 위쪽 툴바의 **`프로그램`** 버튼을 눌러주세요. (`매개변수` 바로 왼쪽입니다.)

소스가 열리면:

1. **Ctrl+F**로 `BEGIN_METHOD`를 검색합니다.
2. **`APPROVE` 메서드의 시작부터 `END_METHOD`까지** 복사해 보내주세요.

구분하기 어려우시면 **열린 프로그램 전체를 텍스트 파일로 보내주셔도 됩니다.**

## ess1-t031-u1 · 사용자

BEGIN_METHOD APPROVER_FIND CHANGING CONTAINER.
DATA:
      KEY12         LIKE   ZWF0022-KEY12,
      ZWFTYPE       LIKE   ZWF0022-ZWFTYPE,
      HEADTEXT      LIKE   ZWF0022-NAME,
      HEADTEXT_MAIL LIKE   ZWF0022-NAME,
      APPROVER      LIKE   WFSYST-ACT_AGENT,
      NAME          LIKE   ZWF0022-NAME1.

  SWC_GET_ELEMENT   CONTAINER   'KEY12'      KEY12.
  SWC_GET_ELEMENT   CONTAINER   'ZWFTYPE'    ZWFTYPE.

  DATA: BEGIN OF r_code OCCURS 0.
          INCLUDE STRUCTURE zwfrcode.
  DATA: END OF r_code.
  CALL FUNCTION 'ZWF_SET_INCLUDE'
       TABLES
            r_code = r_code.

  SELECT SINGLE BNAME INTO APPROVER
         FROM ZWF0022
         WHERE KEY12    = KEY12
           AND ZWFTYPE  = ZWFTYPE
           AND ZORDR    > '00'
           AND CODE IN R_CODE
          " AND ( CODE = '1' OR CODE = '4' OR CODE ='6' )
           AND ZSTTS = SPACE.

  IF SY-SUBRC = 0.
      CONCATENATE 'US' APPROVER INTO APPROVER.
      SWC_SET_ELEMENT CONTAINER 'APPROVER' APPROVER.

    DATA : LV_WI LIKE ZWF0014-WI_ID.
    SWC_GET_ELEMENT CONTAINER 'WI_ID'  LV_WI.
    CALL FUNCTION 'ZWF_SET_INDEX'
      EXPORTING
        wi_id         =  LV_WI
        tabname       = 'ZWF0022'.

  ELSE.
    EXIT_OBJECT_NOT_FOUND.
  ENDIF.

  SELECT SINGLE NAME1 INTO NAME
       FROM ZWF0022
       WHERE KEY12    = KEY12
         AND ZWFTYPE  = ZWFTYPE
         AND ZORDR    = '00'.

  IF SY-SUBRC = 0.
     SWC_SET_ELEMENT CONTAINER 'NAME' NAME.
  ENDIF.

*장비내역
  CASE ZWFTYPE.
  WHEN 'F'. "법정수당
     CONCATENATE '시간외(' NAME ')' INTO HEADTEXT SEPARATED BY SPACE.
     SWC_SET_ELEMENT CONTAINER 'HEADTEXT_MAIL' HEADTEXT.

  WHEN 'G'. "근태
     CONCATENATE '근태(' NAME ')' INTO HEADTEXT SEPARATED BY SPACE.
     SWC_SET_ELEMENT CONTAINER 'HEADTEXT_MAIL' HEADTEXT.

  WHEN 'H'. "전속단체(효과단) 법정수당
     CONCATENATE '법정수당(효과단)' NAME INTO HEADTEXT SEPARATED BY SPACE.
     SWC_SET_ELEMENT CONTAINER 'HEADTEXT_MAIL' HEADTEXT.

   WHEN 'I'.
     CONCATENATE '신분증(' NAME ')' INTO HEADTEXT SEPARATED BY SPACE.
     SWC_SET_ELEMENT CONTAINER 'HEADTEXT_MAIL' HEADTEXT.

    WHEN 'E'. "탄력근로
     CONCATENATE '탄력근로(' NAME ')' INTO HEADTEXT SEPARATED BY SPACE.
     SWC_SET_ELEMENT CONTAINER 'HEADTEXT_MAIL' HEADTEXT.

  ENDCASE.

  SWC_SET_ELEMENT CONTAINER 'HEADTEXT' HEADTEXT.

END_METHOD.

…

## ess1-t031-a1 · AI

지금 보내주신 것은 **`APPROVER_FIND` — 다음 결재자를 찾는 메서드**입니다. 결재자와 제목을 설정하는 코드이고, 근태 변경·취소를 반영하는 부분은 없습니다.

필요한 것은 그 아래에 있는 **`APPROVE` 메서드**입니다.

같은 프로그램에서 아래 문구를 검색해 주세요.

```
BEGIN_METHOD APPROVE CHANGING CONTAINER.
```

**이 줄부터 다음 `END_METHOD.`까지** 보내주시면 됩니다. 검색할 때 `APPROVER_FIND`와 구분해 주세요.

## ess1-t032-u1 · 사용자

BEGIN_METHOD APPROVE CHANGING CONTAINER.
DATA:
      KEY12        LIKE   ZWF0022-KEY12,
      ZWFTYPE      LIKE   ZWF0022-ZWFTYPE,
      END          LIKE   ZWF0022-ZSTTS,
      STATUS       LIKE   ZWF0022-ZSTTS,
      lv_status          LIKE   ZWF0022-ZSTTS.

  SWC_GET_ELEMENT CONTAINER     'KEY12'     KEY12.
  SWC_GET_ELEMENT CONTAINER     'ZWFTYPE'   ZWFTYPE.

  CLEAR STATUS.
  SET PARAMETER ID : 'STATUS' FIELD STATUS.

  SELECT SINGLE ZSTTS INTO lv_status
       FROM ZWF0022
       WHERE KEY12    = KEY12
       AND ZWFTYPE  = ZWFTYPE
       AND ZORDR    = '01'.

  IF SY-SUBRC NE 0.
*    MOVE 'C'  TO  END.
  ENDIF.

  DATA : LV_TEMP TYPE N.

  IF lv_status = ' '.
    LV_TEMP = 1.
    SET PARAMETER  ID  'ORDR'      FIELD    LV_TEMP.
  ELSE.
     LV_TEMP = 2.
    SET PARAMETER  ID  'ORDR'      FIELD    LV_TEMP.
  ENDIF.

  SET PARAMETER  ID  'KEY12'      FIELD    KEY12.

  CASE ZWFTYPE.
       WHEN 'F'. "법정
*           CALL TRANSACTION 'ZHWF061' AND SKIP FIRST SCREEN.
       WHEN 'G'. "근태
*           CALL TRANSACTION 'ZHWF080' AND SKIP FIRST SCREEN.
       WHEN 'H'. "법정(효과단)
*           CALL TRANSACTION 'ZHWF061_1' AND SKIP FIRST SCREEN.
       WHEN 'I'. "신분증->BSP개발.
        WHEN 'E'. " 시간외
  ENDCASE.

  DATA: BEGIN OF r_code OCCURS 0.
          INCLUDE STRUCTURE zwfrcode.
  DATA: END OF r_code.
  CALL FUNCTION 'ZWF_SET_INCLUDE'
       TABLES
            r_code = r_code.

  SELECT SINGLE ZSTTS INTO END
         FROM ZWF0022
         WHERE KEY12    = KEY12
           AND ZWFTYPE  = ZWFTYPE
           AND ZORDR    > '00'
           AND CODE IN R_CODE
          " AND ( CODE = '1' OR CODE = '4' OR CODE ='6' )
           AND ZSTTS <> 'A'.
  IF SY-SUBRC = 0.
     IF END = 'R'.    MOVE 'C'   TO  END.
     ELSE.            MOVE SPACE TO  END.
     ENDIF.
  ELSE.
     MOVE 'C'  TO  END.
  ENDIF.

  GET PARAMETER ID 'STATUS'    FIELD        STATUS.
  SWC_SET_ELEMENT CONTAINER   'END'         END.
  SWC_SET_ELEMENT CONTAINER   'STATUS'      STATUS.

END_METHOD.

…

## ess1-t032-a1 · AI

네, 맞는 메서드입니다. **확인 결과, 여기서는 실제 근태 승인 처리를 하지 않고 결재 상태를 조회해 워크플로우에 전달합니다.**

핵심은 이 부분입니다.

```
WHEN 'G'. "근태
* CALL TRANSACTION 'ZHWF080' AND SKIP FIRST SCREEN.
```

**근태 결재 화면을 호출하던 코드가 주석 처리**되어 있습니다. 나머지는 `ZWF0022`의 승인·반려 상태를 읽는 처리입니다. 따라서 이 메서드를 수정하는 것으로 부분 취소가 구현되지는 않습니다.

앞선 화면의 “KOBIS 혹은 KBS Portal에서 결재” 안내까지 종합하면, **실제 근태 반영은 포털 결재 요청을 받는 다른 코드에서 수행될 가능성이 높습니다.** 이제 워크플로우 쪽 추적은 멈추고 그 코드를 찾아야 합니다.

**다음에는 현재 근태 결재자가 사용하는 BSP 결재 페이지의 `OnInputProcessing` 소스**를 보내주세요. 신청 페이지가 아니라 **승인·반려 버튼이 있는 페이지**입니다.

그 페이지 이름을 모르시면, **SE93에서 `ZHWF080`을 조회한 화면**을 보내주세요. 주석에 남아 있는 예전 결재 프로그램을 단서로 반영 로직을 찾아보겠습니다.

## ess1-t033-u1 · 사용자



## ess1-t033-a1 · AI

확인됐습니다. **`ZHWF080`에 연결된 프로그램은 `SAPMZH080_GULJAE`, 시작 화면은 `0050`입니다.**

다음으로 아래 소스를 보내주세요.

1. **SE80 → 프로그램 → `SAPMZH080_GULJAE` → 조회**
2. **메인 프로그램 소스**와 연결된 **INCLUDE 소스**를 내려받아 주세요.
3. 특히 **승인·반려 버튼 처리(PAI)**와 **FORM이 들어 있는 INCLUDE**가 필요합니다.

INCLUDE가 많으면 **메인 프로그램 소스만 먼저 보내주셔도 됩니다.** 그 안에서 필요한 INCLUDE 이름을 정확히 짚어드리겠습니다.

이 프로그램은 기존 근태 결재 로직을 찾는 단서입니다. 현재 포털에서도 같은 처리를 사용하는지는 코드에서 확인하겠습니다.

## ess1-t034-u1 · 사용자



## ess1-t034-a1 · AI

**이번 파일에서 실제 근태를 생성·삭제하는 코드를 찾았습니다.** 핵심은 `MZH080_GULJAEF01.txt`입니다.

| 처리 위치 | 현재 동작 |
| --- | --- |
| `ILGAL_QUALIFICATION` | 승인 시 신규·삭제·변경 신청을 구분해 처리 |
| `UPDATE_PRE` | 원래 승인 건을 결재번호와 기존 시작일·종료일로 조회 |
| `DELETE_INFOTYPE_2001` | 원래 승인 기간의 IT2001 근태 레코드를 읽어 삭제 |
| `INSERT_INFOTYPE_2001` | 신청 기간과 근태코드로 IT2001 생성 |

**왜 부분 취소를 위해 서버 수정이 필요한지도 확인됐습니다.** 이 프로그램은 취소 요청에서 선택한 하루가 아니라, **원래 승인 건의 기간으로 근태를 조회해 삭제**합니다. 조회된 레코드를 삭제하는 루프에도 선택 날짜로 범위를 좁히는 처리가 없습니다.

따라서 월~금 중 수요일만 취소하려면 **남겨야 할 월·화·목·금의 근태를 보존하는 처리**, 신청 이력과 사용일수의 일치까지 함께 구현해야 합니다.

다만 **이것은 `ZHWF080`에 연결된 프로그램에서 확인한 동작**입니다. 현재 KOBIS·포털 승인도 이 코드를 사용하는지는 아직 확인되지 않았습니다. 여기를 수정해도 포털에서 다른 코드를 실행하면 개선이 적용되지 않습니다.

다음으로는 **현재 승인·반려 버튼이 있는 BSP 페이지의 `OnInputProcessing` 소스**가 필요합니다. 페이지 이름을 모르시면 **실제 결재 화면의 URL에서 도메인을 제외한 경로**를 알려주세요. 현재 사용 경로와 이번에 찾은 근태 반영 로직을 연결해서 확인하겠습니다.

## ess1-t035-u1 · 사용자

<%@page language="abap" %>
<%@extension name="htmlb" prefix="htmlb" %>
<%@extension name="xhtmlb" prefix="xhtmlb" %>
<%@extension name="phtmlb" prefix="phtmlb" %>
<%@extension name="bsp" prefix="bsp" %>

<%-- *&---------------------------------------------------------------------*
     *& BSP  :
     *& 모듈 : HR
     *& 내용 : 인사기본정보 주소 상세조회
     *&---------------------------------------------------------------------*
     *& REV_NO| 작성일자 | 작성자 | 내    역                                *
     *&
     *&---------------------------------------------------------------------*        --%>
<htmlb:content design            = "<%= zcl_cm_util_bsp=>design %>"
               sessionManagement = "<%= zcl_cm_util_bsp=>sessionManagement %>"
               themeRoot         = "<%= zcl_cm_util_bsp=>themeRoot %>" >
  <htmlb:document disableBackspaceNavigation="TRUE" >
    <htmlb:documentHead>
      <%-- CSS, common script include --%>
      <%@include file="../../sap/zcommon/jscommon.kbs" %>
      <%-- Client script 작성 시작. --%>
      <%@include file="app_script.kbs" %>
      <%@include file="zep002_css.kbs" %>
      <%-- Client script 작성 끝. --%>
    </htmlb:documentHead>
    <htmlb:documentBody marginTop    = "<%= zcl_cm_util_bsp=>body_marginTop %>"
                        marginBottom = "<%= zcl_cm_util_bsp=>body_marginBottom %>"
                        marginLeft   = "<%= zcl_cm_util_bsp=>body_marginLeft %>"
                        marginRight  = "<%= zcl_cm_util_bsp=>body_marginRight %>" >
      <%@include file="../../sap/zcommon/ep_css.kbs" %>
      <htmlb:form id           = "BspForm"
                  autoComplete = "FALSE" >
        <%-- protectDoubleSubmit --%>
        <xhtmlb:protectDoubleSubmit timer="1" />
        <%-- 여기부터 화면에 보여질 영역입니다. 시작. --%>
        <htmlb:group width  = "100%"
                     title  = "근태결재 및 직권처리"
                     design = "<%= zcl_cm_util_bsp=>group_design1 %>" >
          <htmlb:groupBody>
            <%@include file="list_layer.kbs" %>
            <%@include file="list_sub2.kbs" %>
          </htmlb:groupBody>
        </htmlb:group>
        <%-- 화면에 보여지는 영역은 여기까지 입니다. 끝. --%>
        <%-- 에러 메세지. 시작. --%>
        <%@include file="../../sap/zcommon/error_detail.kbs" %>
        <%-- 에러 메세지. 끝. --%>
        <%-- hidden field등은 여기에 정의하십시오. 시작. --%>
        <input type="hidden" name="SEL_ROW" value="">
        <%-- hidden field등은 여기에 정의하십시오. 끝. --%>
        <script>
          <%= cm_script %>

          <%-- 2015.12.30 xa30750 수정, 결재건수 동기화        --%>
          <% IF cm_success is not initial. %>
           document.domain="kbs.co.kr";  //js함수 호출시 사용권한이 없는 경우 domain 추가

           try{
<%--                parent.parent.parent.frames["Navigator"].GetAprvCountCollection();--%>
                  parent.parent.parent.frames["Navigator"].location.reload();
                         }
           catch(e){}

           try{
<%--                 parent.parent.frames["Navigator"].GetAprvCountCollection();--%>
                parent.parent.frames["Navigator"].location.reload();
                }
           catch(e){}
         <%ENDIF.%>

        <%
  clear : cm_script.
        %>
        </script>
      </htmlb:form>
      <%-- main form은 여기까지 입니다. --%>
    </htmlb:documentBody>
  </htmlb:document>
</htmlb:content>

이 페이지를 말하는걸까 ?
근태 상신하면, 인사관리자가 승인하는 페이지야

…

## ess1-t035-a1 · AI

네, **말씀하신 실제 승인 페이지가 맞습니다.** 코드에도 제목이 **‘근태결재 및 직권처리’**로 되어 있습니다.

지금 주신 것은 **Layout(화면 구성)**입니다. 실제 승인 버튼을 눌렀을 때 실행되는 코드를 확인하려면 **이 페이지의 `OnInputProcessing`**이 필요합니다.

SE80에서 해당 페이지를 열고:

1. **Event Handler** 탭 선택
2. **`OnInputProcessing`** 선택
3. 소스 전체를 복사해서 보내주세요.

추가로 Layout에서 포함하고 있는 **`list_sub2.kbs`와 `app_script.kbs`**도 함께 주시면, 승인 버튼과 서버 이벤트가 어떻게 연결되는지 확인할 수 있습니다.

**이번에는 실제 사용 중인 승인 페이지를 찾았으므로**, 여기서 호출하는 근태 반영 함수를 확인하면 앞서 받은 결재 프로그램과 같은 로직인지 판단할 수 있습니다.

## ess1-t036-u1 · 사용자

* event handler for checking and processing user input and
* for defining navigation
    DATA : L_EXCEPTION    TYPE REF TO ZCX_CM_EXCEPTION.

    DATA : LCL_TABLEVIEW  TYPE REF TO CL_HTMLB_TABLEVIEW,
           TABLE_EVENT    TYPE REF TO CL_HTMLB_EVENT_TABLEVIEW,
           L_INDEX        TYPE STRING.

    DATA: EVENT TYPE REF TO IF_HTMLB_DATA.

    DATA : LV_TOT_CNT    TYPE I,
           LV_APP_CNT    TYPE I,
           LV_APP        TYPE STRING,
           LV_TOT        TYPE STRING,
           LV_MSG        TYPE STRING.

    TRY.
        CLEAR : LV_TOT_CNT, LV_APP_CNT, CM_SCRIPT.
        CLEAR: cm_success.

        IF EVENT_ID = CL_HTMLB_MANAGER=>EVENT_ID.
          EVENT = CL_HTMLB_MANAGER=>GET_EVENT_EX( REQUEST ).
          "tableview event 얻기
          LCL_TABLEVIEW ?= CL_HTMLB_MANAGER=>GET_DATA( REQUEST = REQUEST
                                            NAME    = 'tableView'
                                            ID      = 'TV1' ).
          TABLE_EVENT = LCL_TABLEVIEW->DATA.
          "tableview의 첫번째 row 읽기
          APPLICATION->VISIBLE_FIRST_ROW = TABLE_EVENT->VISIBLEFIRSTROWINDEX.

          IF EVENT IS BOUND.
            CASE EVENT->EVENT_ID.
              WHEN 'APPROVAL'.

                SORT GT_LIST1 BY  BEGDA ASCENDING.

                LOOP AT GT_LIST1 INTO GS_LIST1 WHERE ZSTAT NE SPACE .
                  IF GS_LIST1-ZSTAT EQ 'Y'.
                    CLEAR : GS_LIST1-ZSAYU.
                  ENDIF.
                  CALL FUNCTION 'ZHR_GUN_GULJAE'
                    EXPORTING
                      ZSERIAL = GS_LIST1-KEY12
                      GULJAE  = GS_LIST1-ZSTAT
                      SAYU    = GS_LIST1-ZSAYU
                      ZWI_ID  = GS_LIST1-ZWI_ID
                    IMPORTING
                      MSG     = LV_MSG.

                  IF LV_MSG EQ 'T'.
                    LV_APP_CNT = LV_APP_CNT + 1.
*                  CONCATENATE CM_SCRIPT '\n' MSG INTO CM_SCRIPT.
                  ENDIF.
                  LV_TOT_CNT = LV_TOT_CNT + 1.
                ENDLOOP.

                LV_TOT = LV_TOT_CNT.
                LV_APP = LV_APP_CNT.
                IF  LV_MSG EQ 'T'.
                  IF LV_APP EQ LV_TOT.
                    CONCATENATE `alert("근태 신청 ` LV_APP `건을 결재 처리를 하였습니다.");`
                           INTO CM_SCRIPT.
                  ELSE.
                    CONCATENATE `alert("[ ` LV_APP ` / ` LV_TOT ` ]건의 결재가 완료되었습니다.");`
                           INTO CM_SCRIPT.
                  ENDIF.
                ELSE.
                  CONCATENATE `alert("  ` LV_MSG ` ");`  INTO CM_SCRIPT.

                ENDIF.
*            WHEN 'REQUEST'.
*               navigation->goto_page('../ZHR0008/guntae_absent_input.kbs').
*            WHEN 'REQUEST_TIMEOFF'.
*               navigation->goto_page('../ZHR0008/guntae_timeoff_input.kbs').
            ENDCASE.

*             코비스 좌측 건수 표시 메뉴 리로드 하기 위해  추가 20160107 seokhyon
                cm_success = 1.
          ENDIF.
        ENDIF.

      CATCH ZCX_CM_EXCEPTION INTO L_EXCEPTION.
        CM_SCRIPT = L_EXCEPTION->EXCEPTION_BSP( I_EXCEPTION = L_EXCEPTION ).
        CM_ERROR = L_EXCEPTION->RETURN-MESSAGE.
      CATCH CX_ROOT.
        NAVIGATION->GOTO_PAGE('../../sap/zcommon/error.kbs').
    ENDTRY.

이거야

…

## ess1-t036-a1 · AI

네, **이 코드에서 실제 승인 처리 함수가 확인됐습니다.**

```
CALL FUNCTION 'ZHR_GUN_GULJAE'
  EXPORTING
    ZSERIAL = GS_LIST1-KEY12   "결재 대상 번호
    GULJAE  = GS_LIST1-ZSTAT   "승인·반려 값
    SAYU    = GS_LIST1-ZSAYU   "사유
    ZWI_ID  = GS_LIST1-ZWI_ID
  IMPORTING
    MSG     = LV_MSG.
```

현재 승인 페이지는 선택된 건마다 **`ZHR_GUN_GULJAE`를 호출**합니다. 부분 변경·취소를 실제 근태에 반영하려면 이 함수 내부를 확인해야 합니다.

**SE37에서 `ZHR_GUN_GULJAE`의 전체 소스를 보내주세요.** 함수 안에서 `PERFORM`을 호출한다면 해당 FORM이 들어 있는 INCLUDE와 함수 그룹 TOP도 함께 주시면 됩니다. 이미 주신 INCLUDE라면 다시 보내실 필요 없습니다.

승인 버튼의 서버 연결은 확인됐으므로, **`list_sub2.kbs`와 `app_script.kbs`는 지금 단계에서는 추가로 주지 않으셔도 됩니다.**

## ess1-t037-u1 · 사용자

FUNCTION ZHR_GUN_GULJAE.
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

  SUBMIT zrpth_gun_guljae_new
         WITH zserial EQ zserial
         WITH guljae EQ guljae
         WITH zsayu EQ sayu
         WITH zwi_id EQ zwi_id
         AND RETURN.

  GET PARAMETER ID 'MSG_ID' FIELD s_msg.

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

      MOVE t_msg TO msg.

    ENDFUNCTION.

…

## ess1-t037-a1 · AI

**실제 승인 처리를 실행하는 프로그램 이름이 확인됐습니다: `ZRPTH_GUN_GULJAE_NEW`입니다.**

이번 함수는 아래 프로그램에 결재번호·승인/반려·사유를 전달하고, 실행 결과를 메시지로 바꿔 반환합니다.

```
SUBMIT zrpth_gun_guljae_new
  WITH zserial EQ zserial
  WITH guljae  EQ guljae
  WITH zsayu  EQ sayu
  WITH zwi_id EQ zwi_id
  AND RETURN.
```

따라서 확인된 **현재 사용 경로**는 다음과 같습니다.

**승인 BSP → `ZHR_GUN_GULJAE` → `ZRPTH_GUN_GULJAE_NEW`**

다음으로 **SE38에서 `ZRPTH_GUN_GULJAE_NEW` 전체 소스**를 보내주세요. `INCLUDE`로 나뉘어 있으면 해당 INCLUDE도 함께 부탁드립니다.

이제 기존 GUI 결재 프로그램이 아닌, **현재 승인 페이지가 실제로 실행하는 프로그램을 기준으로** 날짜별 부분 변경·취소 처리 위치를 확인할 수 있습니다.

## ess1-t038-u1 · 사용자



## ess1-t038-a1 · AI

**현재 승인 페이지가 실행하는 근태 반영 로직까지 확인됐습니다.** 이제 워크플로우 쪽을 더 추적할 필요는 없습니다.

이번 소스에서 확인한 핵심은 다음과 같습니다.

| 항목 | 현재 동작 |
| --- | --- |
| 휴일 제외 | 통상근무 연차 등 일부 유형은 `KB` 휴일달력·`KR` 공장달력을 조회해 휴일을 제외하고 IT2001에 나누어 저장 |
| 취소 승인 | 원래 승인 건의 전체 기간을 조회한 뒤 해당 IT2001 레코드를 삭제 |
| 변경 승인 | 기존 근태 삭제 후 변경한 근태를 생성 |
| 연차 일수 | 일부 연차코드는 삭제 시 `ZHR2016`의 쿼터도 복원 |

**주말·휴일 제외는 일부 유형의 ‘승인 후 저장’ 단계에 이미 구현되어 있었습니다.** 앞서 신청 화면과 일수 계산 코드만으로는 확인하지 못했던 부분입니다. 개선 화면의 신청 가능 날짜도 이 기준과 맞춰야 합니다.

또한 **부분 취소는 삭제 날짜만 좁히는 것으로 끝나지 않습니다.** 기존 레코드가 월~금으로 저장됐다면, 수요일 취소 후 월~화·목~금을 보존하고 연차 쿼터와 신청 이력도 함께 맞춰야 합니다. 현재 코드에는 처리 중간의 `COMMIT WORK`도 있어 오류 시 일부만 반영되지 않도록 살펴봐야 합니다.

추가로, 본문에서 **아직 받지 못한 INCLUDE 하나**가 확인됐습니다.

```
INCLUDE zrpth_gun_gyeongjo.   "경조금 연계
```

**`ZRPTH_GUN_GYEONGJO` 전체 소스도 보내주세요.** 신규·변경 승인에서 이 INCLUDE의 `SELECT_ZTHW0105`를 호출하므로, 기존 경조금 연계에 영향을 주지 않도록 확인해야 합니다. 함께 주신 `RHEHCONS`, `RHEH0000`은 다시 보내지 않으셔도 됩니다.

## ess1-t039-u1 · 사용자



## ess1-t039-a1 · AI

네, **요청드린 경조금 연동 소스가 맞습니다.** 두 파일 확인했습니다.

| 파일 | 확인한 역할 |
| --- | --- |
| `ZRPTH_GUN_GYEONGJO` | 특정 근태 승인 시 경조금 신청을 `ZTHW0105`에 생성하고 중복 검사 |
| `ZHW_GET_PERSON_DATA` | 사원 기본정보·근속기간 등 경조금 대상 판단에 필요한 정보 조회 |

핵심은 **근태를 여러 신청으로 나누더라도, 같은 경조사에 대한 경조금 신청까지 여러 번 생기면 안 된다는 점**입니다. 현재 중복 검사에는 신청번호(`ZSERIAL`)를 사용하는 부분이 있어, 분할하면서 신청번호가 달라지면 기존 검사만으로 충분하지 않을 수 있습니다.

따라서 개선 시에는 다음을 함께 처리해야 합니다.

- **분할 신청:** 나뉜 근태들이 같은 원래 신청에서 만들어졌다는 연결 유지
- **부분 변경·취소:** 선택한 날짜만 반영하고 나머지 승인 날짜와 잔여일수 보존
- **경조금 연동:** 분할 건수만큼 중복 생성되지 않도록 처리

인사정보 조회 함수 내부 소스를 더 보내실 필요는 없습니다. 이번 자료로 경조금 연동의 영향 범위까지 확인했고, **아직 실제 소스 수정이나 SAP 검증을 완료한 단계는 아닙니다.**

## ess1-t040-u1 · 사용자

그럼 이제 어떻게 수정 개발해줄거야 ?

## ess1-t040-a1 · AI

**지금까지 받은 소스를 기준으로, 미리보기 화면과 실제 저장·승인 처리를 연결하는 방식으로 개발하겠습니다.** 핵심은 신청을 나누더라도 원래 신청과의 관계를 유지하고, 선택하지 않은 날짜는 그대로 남기는 것입니다.

수정 범위는 다음과 같습니다.

| 대상 | 수정할 내용 |
| --- | --- |
| 근태 입력 BSP·CSS·JS | ESS 흰색 디자인, 내역 영역 확대, 날짜 선택·제외, 신청 결과 미리보기 |
| BSP 입력 이벤트 | 선택한 날짜를 서버에 전달하고, 서버에서 신청 가능 여부를 다시 검사 |
| `ZHR_SAVE_ZTHR0080` 및 관련 INCLUDE | 선택 날짜를 연속 기간·단일 날짜로 나눠 저장하고 원래 신청과 연결 |
| `ZRPTH_GUN_GULJAE_NEW` | 부분 변경·취소 승인 시 해당 날짜만 반영하고 잔여일수 조정 |
| `ZRPTH_GUN_GYEONGJO` | 분할 신청으로 같은 경조금이 중복 생성되지 않도록 연결 기준 보완 |
| 첨부파일 관련 BSP | 기존 다중 업로드 소스를 연결하고 저장·조회까지 처리 |

**① 신규 신청은 저장 전에 나뉘는 결과를 보여주겠습니다.**

예를 들어 신청 가능한 날짜가 월~금이고 수요일을 직접 제외했다면:

- 월~화: 기간 신청 1건
- 목~금: 기간 신청 1건

휴일 자동 제외와 사용자 직접 제외는 구분하겠습니다. 휴일 처리도 모든 근태에 토·일 제외를 일괄 적용하지 않고, **기존 근태유형별 기준을 서버와 화면에 동일하게 적용**하겠습니다.

**② 부분 변경·취소는 원래 승인 이력을 보존하겠습니다.**

월~금 승인 건에서 수요일만 취소하면, 취소 신청·승인 대상은 수요일입니다. 나머지 날짜는 유지하고 취소 승인 후 해당 일수만 복원합니다.

이를 위해 원신청과 변경 대상 날짜를 연결하는 정보를 별도로 관리하는 방향으로 설계하겠습니다. **기존 시작일·종료일만 바꿔 덮어쓰는 방식으로는 이력과 반복 변경을 제대로 관리하기 어렵습니다.** 필요한 신규 DDIC 객체가 확정되면 필드 정의와 생성 순서도 함께 드리겠습니다.

**③ 화면에서 막았던 실수 방지를 서버에서도 검사하겠습니다.**

하루 건 자동 선택, 동일 오전·오후반차 변경 비활성화뿐 아니라, 이미 변경 진행 중인 날짜의 재신청과 중복 제출도 검사하겠습니다. 분할 저장 도중 오류가 발생했을 때 일부 건만 남지 않도록 기존 `COMMIT WORK` 위치도 함께 검토하겠습니다.

결과물은 **파일별 수정본, 변경점 비교, 신규 객체 정의, 적용 순서, 테스트 시나리오**로 드리겠습니다. 개발계에서 **신규 신청 → 승인 → 일부 취소 → 남은 날짜 재변경 → 반려·회수**까지 확인한 뒤 CTS로 옮길 수 있도록 구성하겠습니다.

현재는 소스 분석 단계까지 진행됐습니다. 제가 수정본과 자체 검증 결과를 제공하되, **SAP 활성화와 실제 결재·잔여일수 검증은 개발계에서 확인해야 합니다.**

## ess1-t041-u1 · 사용자

제가 수정본과 자체 검증 결과를 제공하되,
SAP 활성화와 실제 결재·잔여일수 검증은 개발계에서 확인해야 합니다.

이게 무슨말이야 ?

## ess1-t041-a1 · AI

**제가 소스를 수정해서 드릴 수는 있지만, 사내 SAP에 직접 접속해서 실행해 볼 수는 없다는 뜻입니다.**

역할을 나누면 이렇습니다.

- **제가 할 일:** 파일별 수정본 작성, 로직의 누락·오류 검토, 적용 위치와 테스트 방법 안내
- **피터한님이 개발계에서 할 일:** 수정본 반영·활성화 후 실제 신청과 결재 실행

예를 들어 **“5일 승인 건에서 하루만 취소했을 때, 나머지 4일이 유지되고 잔여 연차가 1일만 복원되는지”**는 실제 SAP 데이터로 실행해 확인해야 합니다.

그 과정에서 활성화 오류나 잘못된 결과가 나오면, **오류 메시지와 결과를 보내주시면 제가 이어서 수정하겠습니다.** 소스만 드리고 끝낸다는 의미는 아닙니다.

그리고 앞서 말한 ‘자체 검증’은 **제가 확인할 수 있는 범위의 코드 검토·계산 로직 테스트**를 뜻하며, SAP에서 정상 작동까지 확인했다는 의미는 아닙니다.

## ess1-t042-u1 · 사용자

ㅇㅇ 진행해줘. 진행하면서,

1. 주석처리자는 사번 XA32762 로 통일해줘
2. 변경 포인트 소스코드에 주석 처리 : 추가할떄는 복수건은 "Start-Add" ~ "End-Add", 단일 추가건은 "Add  / 사번
3. 변경건 복수 라인은 "Start-Modify"~ "End-Modify" , 단일 변경은 "Modify / 사번
4. 삭제건 복수라인은 " Start-Delete" ~ "End-Delete ",  단일 삭제는 "Del / 사번
5. 변경 이력 및 내역을 명세서로 남겨줘. 최대한 상세하게 . 그래서 나중에 따로 파일로 다운받게 해줘. (엑셀파일 형태)

## ess1-t042-missing · AI

[공유 화면에 AI 응답 본문이 표시되지 않은 위치]

## ess1-t043-u1 · 사용자

다시 시도해줘

## ess1-t043-missing · AI

[공유 화면에 AI 응답 본문이 표시되지 않은 위치]

## ess1-t044-u1 · 사용자

지금 까지 작업한것들 마크다운형태로 정리해줄 수 있어 ?

## ess1-t044-a1 · AI

지금까지의 작업을 마크다운 파일로 정리했습니다.

요구사항, 화면 동작, 수정 파일, XA32762 주석 규칙, 검증 결과, 남은 작업과 필요한 소스를 담았습니다. **다른 대화에서 이어갈 때 사용할 요약**도 마지막에 포함했습니다.

---

대화 내용을 간단히 요약하면 다음과 같습니다.

근태 페이지 개선 작업을 진행 중이며, 주요 목표는 기간 일괄 신청, 날짜별 취소, 오전·오후 반차 표시 등 기능과 디자인 개선입니다. 현재 주말 제외 처리, 승인 후 날짜별 변경·취소 기능, 다중 파일 첨부 연동 등을 소스 코드 분석을 통해 구체화하고 있습니다. ESS 스타일을 적용한 미리보기도 제작되었으며, 사용자 인터페이스 개선 사항에 대해서도 논의되었습니다.

근태 결재 워크플로우와 승인 후 처리 코드를 분석하는 과정이 진행 중입니다. 특히 승인된 기간 중 일부 날짜만 변경·취소하는 기능 구현을 위해 워크플로우 ID 'WS95000055' 및 실행 메서드 'ZWFET22.APPROVE' 등 관련 소스를 상세히 검토하고 있습니다. 현재는 핵심 승인 반영 코드 파악 단계로, 실제 근태 반영 로직 확인이 남아 있습니다.

guntae_progress_summary_XA32762.md문서
