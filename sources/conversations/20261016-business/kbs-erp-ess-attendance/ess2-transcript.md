# 근태페이지 수정 완료

출처: https://chatgpt.com/share/e/6ad08960-7d58-83ec-8ec6-c1b3ddfc2ab7

공유 화면의 표시 순서대로 전사했습니다. 본문이 없는 응답 위치는 별도 표시합니다.

## ess2-t001-u1 · 사용자

근태페이지에서 이 부분 수정해야하는데, 가능하지 ?

## ess2-t001-a1 · AI

네. **첨부하신 세 화면의 수정 내용을 기존 R1 소스에 반영했습니다.**

- 출산전후휴가 도움말: 예정일 50일 전부터·출산 후 120일 이내 사용 안내
- 배우자 유사산휴가: 5일·사유 발생일부터 20일 이내 청구 안내
- ‘알립니다’ 표: 출산전후 명칭과 유사산 5일 반영

**현재는 수정 파일 작성 완료이며, 실제 SAP 적용·저장 검증은 아직입니다.** 명세서의 한글 표시도 Excel에서 확인이 필요합니다.

`guntae_r1_dev_XA32762.zip`

guntae_r1_change_spec_XA32762.xlsxExcel

## ess2-t002-u1 · 사용자

지금 개선작업 하고 있는것에서도 필요하지만,
내가 지금 요청한건 , 현존 페이지에서 저 문구들만 수정한 버전을 요청한거야 .

## ess2-t002-a1 · AI

제가 요청 범위를 잘못 이해했습니다. **제공하신 기존 페이지 원본에 문구만 수정한 버전**을 별도로 만들었습니다.

기존 화면·기능은 유지하고, 도움말 2곳과 ‘알립니다’ 표만 수정했습니다. R1 개선 기능은 포함하지 않았습니다.

`guntae_input_layout_text_only_XA32762.kbs`

`guntae_input.kbs`의 **Layout에 적용할 전체 소스**입니다. 실제 SAP에는 아직 적용하지 않았습니다.

## ess2-t003-u1 · 사용자

추가로, 이거 눌렀을때 두번째 캡쳐처럼 다운 받는 파일이 있는데 이걸  신규파일(세번째 첨부)로 교체하는거까지해줘.

## ess2-t003-a1 · AI

**기존 페이지용 수정본에 추가 반영했습니다.** ‘근태도움말 보기’를 누르면 신규 `guntae_help_n.hwp`를 받도록 연결했습니다.

ZIP에 **문구 수정이 포함된 Layout, 신규 HWP, 적용 안내**를 넣었습니다. 실제 SAP에는 아직 적용하지 않았으며, 신규 HWP 등록과 Layout 적용이 필요합니다.

`guntae_current_page_update_XA32762.zip`

`guntae_input_layout_text_only_XA32762.kbs`

## ess2-t004-u1 · 사용자

신규 HWP 등록 하는 방법은 ?

## ess2-t004-a1 · AI

**SE80에서 `ZHR0008`의 MIMEs에 등록하시면 됩니다.** 기존 `guntae_help.hwp`와 같은 위치에 신규 파일을 추가하는 방식입니다.

1. **파일 준비**
  드린 ZIP을 풀고 `mime/guntae_help_n.hwp`를 PC에 준비합니다.
2. **BSP 애플리케이션 열기**
  SAP에서 `SE80` 실행 → 왼쪽 객체 종류를 **BSP 애플리케이션**으로 선택 → `ZHR0008` 입력 → Enter.
3. **기존 파일 위치 확인**
  왼쪽 트리의 **MIMEs**를 펼쳐 `guntae_help.hwp`가 있는 위치를 확인합니다.
4. **신규 파일 가져오기**
  해당 폴더에서 마우스 오른쪽 버튼 → **가져오기(Import) → MIME 오브젝트** → PC의 `guntae_help_n.hwp` 선택.
  메뉴 이름은 SAP 버전에 따라 조금 다를 수 있습니다.
5. **속성 입력 후 저장**
  파일명은 **`guntae_help_n.hwp`**로 유지합니다. MIME 유형을 입력해야 하면 기존 `guntae_help.hwp`의 속성을 참고하세요. 패키지와 전송 요청은 이번 Layout 수정에 사용하는 것으로 지정합니다. 이 등록 절차는 [SAP 공식 안내](https://help.sap.com/saphelp_snc700_ehp01/helpdata/en/46/bb1835ab4811d4968100a0c94260a5/content.htm?utm_source=chatgpt.com)에 따른 것입니다.
6. **버튼 연결 확인**
  제가 드린 수정 Layout까지 적용·활성화한 뒤, 근태페이지를 새로 열어 **‘근태도움말 보기’**를 누릅니다. `guntae_help_n.hwp`가 다운로드되고 신규 문서 내용이 열리면 됩니다.

**HWP 등록과 수정 Layout 적용이 모두 필요합니다.** 운영 반영 시에도 두 변경을 함께 이관하시면 됩니다.

## ess2-t005-u1 · 사용자

guntae_input_layout_text_only_XA32762.kbs
여기에서 modify 의 경우에는 기존의 문구들을 삭제하지 말고, 주석처리로 해서, 어떤 내용이 어떻게 변경이 되었다라는게 직관적으로 볼 수 있도록 수정해줘

## ess2-t005-a1 · AI

수정했습니다. **4개 Modify 구간 모두 기존 원문을 BSP 주석으로 보존하고, 바로 아래에 변경 후 내용을 배치**했습니다. 실제 적용 문구와 동작은 그대로입니다.

`guntae_input_layout_text_only_XA32762.kbs`

신규 HWP가 포함된 ZIP도 갱신했습니다.

`guntae_current_page_update_XA32762.zip`

## ess2-t006-u1 · 사용자

mimes에서 임포트하다가 이렇게 에러가 나와

## ess2-t006-a1 · AI

캡처는 **`.hwp` 확장자와 입력된 MIME 유형 `application/haansofthwp`가 일치하지 않는다는 경고**입니다. SAP에 등록된 확장자–MIME 연결값과 다르거나, 해당 연결값이 없을 가능성이 있습니다. [SAP 설명](https://help.sap.com/docs/ABAP_PLATFORM_NEW/0884fb55479542b38fb676e8f5b250a1/4cbf3f0dd9da048be10000000a42189c.html?utm_source=chatgpt.com)

**먼저 기존에 정상 다운로드되던 파일의 설정에 맞춰 보세요.**

1. 경고창을 닫고 `SE80 → ZHR0008 → MIMEs`로 돌아갑니다.
2. 기존 **`guntae_help.hwp`**를 선택하고, 우클릭 **속성**에서 **MIME 유형**을 확인합니다.
3. 신규 파일을 다시 Import하면서 **MIME 유형을 기존 파일과 동일하게 입력**합니다.
4. 파일명은 **`guntae_help_n.hwp`** 그대로 두고 저장합니다.

기존 파일과 같은 값을 입력해도 경고가 나오면 SAP의 HWP 확장자 매핑을 확인해야 합니다. **기존 `guntae_help.hwp`의 속성 화면을 캡처해 주세요.** 그 값을 보고 다음 조치를 정확히 안내드리겠습니다.

## ess2-t007-u1 · 사용자

이렇게야

## ess2-t007-a1 · AI

확인했습니다. **기존 파일도 `application/haansofthwp`로 동일합니다. MIME 유형은 그대로 유지하세요.**

다음 순서로 진행해 보세요.

1. 신규 `guntae_help_n.hwp`를 다시 Import합니다.
2. 같은 **경고창이 나오면 아래의 초록색 ✓ 버튼**을 눌러 다음 단계로 진행되는지 확인합니다.
3. 패키지·전송 요청 화면으로 넘어가면 지정 후 저장하고, MIMEs 목록에 신규 파일이 생겼는지 확인합니다.

**✓를 눌러도 같은 경고가 반복되거나 저장이 막히면**, 경고창의 **도움말(F1)**을 눌러 나오는 설명과 메시지 번호를 보내주세요. 그 경우에는 확장자 매핑 설정을 추가로 확인해야 합니다.

## ess2-t008-u1 · 사용자

무사히 잘 되네. 고마워. 이거 r1에도 적용이 된거지 ?

## ess2-t008-a1 · AI

네. **빠져 있던 후속 변경까지 지금 반영해서 최신 R1에도 모두 포함했습니다.**

- 도움말 문구 2곳과 ‘알립니다’ 표 수정
- 신규 HWP 파일과 다운로드 링크
- 변경 전 원문 주석 및 변경 후 내용 표시

변경명세서도 갱신했습니다. **R1 전체의 SAP 적용·검증은 별도입니다.**

`guntae_r1_dev_XA32762.zip`

guntae_r1_change_spec_XA32762.xlsxExcel

## ess2-t009-u1 · 사용자

리드미를 봤는데
적용하는 방법이  너무 복잡한데 더 쉽게 설명할 수 있어 ?

## ess2-t009-a1 · AI

네. README에 적용 순서와 개발자 점검사항을 섞어 적어서 복잡했습니다.

**R1은 아래 6단계를 순서대로 진행하는 작업입니다. SAP 개발계에서 먼저 진행하시면 됩니다.**

| 순서 | 쉽게 말하면 | SAP에서 할 일 |
| --- | --- | --- |
| 1 | 현재 상태 보관 | 수정할 기존 소스를 백업하고, 이번 작업의 전송 요청을 준비합니다. |
| 2 | 새 기능을 처리할 프로그램 등록 | **SE24**에서 `ZCL_HR_GUN_V2` 클래스를 만들고 제공한 소스를 넣습니다. |
| 3 | 새 화면과 파일 등록 | **SE80 → ZHR0008**에서 달력·첨부 페이지, 화면 조각, JS·CSS를 등록합니다. |
| 4 | 기존 근태화면에 연결 | `guntae_input.kbs`에 속성 하나를 추가하고, 화면 소스와 이벤트 소스를 적용합니다. |
| 5 | 관리자·결재 쪽 연결 | 관리자 첨부 표시와 결재 처리 관련 소스를 적용합니다. |
| 6 | 실제로 눌러서 확인 | 구문 검사·활성화 후 신청, 날짜 선택, 첨부, 결재를 시험합니다. |

**어떤 파일을 어디에 넣는지만 정리하면 다음과 같습니다.**

1. **새 클래스 등록 — SE24**
  `ZCL_HR_GUN_V2`에 ZIP의 `apply/ZCL_HR_GUN_V2.abap` 내용을 적용합니다. 먼저 구문 검사에서 오류가 없는지 확인합니다.
2. **새 화면·파일 등록 — SE80 → ZHR0008**
  `bsp` 폴더의 파일로 아래 항목을 만듭니다.

  | 등록 위치 | 만들 항목 |
  | --- | --- |
  | Pages with Flow Logic | `guntae_v2_calendar.kbs` — 달력 조회 |
  | Pages with Flow Logic | `guntae_files.kbs` — 첨부파일 조회 |
  | Page Fragments | `guntae_v2_panel.kbs` — 날짜 선택 화면 조각 |
  | MIMEs | `guntae_v2.js`, `guntae_ess_v2.css` |

  신규 페이지 2개에는 각각 이름이 대응하는 **Layout 파일과 OnInitialization 파일**을 넣습니다.
  **`guntae_help_n.hwp`는 같은 SAP 시스템에 이미 등록하셨다면 다시 등록할 필요가 없습니다.**
3. **기존 신청 화면 수정 — guntae_input.kbs**
  Attributes에 **`GV_V2_TOKEN`, 타입 `CHAR22`**를 추가하고 **Auto 체크를 해제**합니다. 이후 아래처럼 넣습니다.

  | ZIP 파일 | 넣을 위치 |
  | --- | --- |
  | `apply/guntae_input_layout.kbs` | Layout |
  | `apply/guntae_input_evt_OnInitialization.kbs` | OnInitialization |
  | `apply/guntae_input_evt_OnInputProcessing.kbs` | OnInputProcessing |
4. **관리자·결재 소스 적용**
  이 부분은 관리자 화면에서도 첨부를 열고 결재 결과를 제대로 표시하도록 연결하는 작업입니다. 대상은 `ZCL_APP_ZEP002_IT_B`의 메서드 2개, 관리자 BSP 소스 2개, 결재 관련 프로그램·함수 4개입니다. **여기는 기존 ABAP 소스를 수정하는 단계이므로, 앞 단계 등록이 끝난 다음 진행하면 됩니다.**
5. **시험**
  전체 구문 검사·활성화 후, 기본 신청 → 날짜 제외 신청 → 여러 파일 첨부 → 관리자 조회·결재 순서로 확인합니다.

**지금 처음 시작하실 작업은 ‘현재 소스 백업’과 ‘SE24의 `ZCL_HR_GUN_V2` 등록’입니다.** README의 모든 내용을 한꺼번에 처리하려 하지 않고, 위 순서대로 하나씩 완료하시면 됩니다.

## ess2-t010-u1 · 사용자

그럼 readme를 쉬운버전을도 다시 만들어줘. 하나하나 최대한 쉽게 ㅇㅇ

## ess2-t010-a1 · AI

하나씩 따라 할 수 있도록 쉬운 README를 새로 만들었습니다.

각 단계를 **열 화면 → 입력할 값 → 넣을 파일 → 완료 확인** 순서로 풀어썼고, 이미 등록한 HWP는 건너뛸 수 있는 조건도 표시했습니다. 기존 상세 README는 그대로 두었습니다.

README_R1_EASY_XA32762.md문서

## ess2-t011-u1 · 사용자

여기서 소스기반 편집화면을 어케 여는거야 ?

## ess2-t011-a1 · AI

지금 화면에서는 **맨 위 `유틸리티(U)` 메뉴부터** 열어보세요.

1. **유틸리티(U) → 설정(Settings)**을 누릅니다.
2. 설정 창에서 **클래스 빌더 / Class Builder** 탭을 선택합니다.
3. **소스 코드 기반 클래스 빌더 / Source Code-Based Class Builder** 항목을 체크합니다.
4. 확인 버튼을 눌러 설정을 저장합니다.
5. 현재 클래스를 저장하고 나갔다가, SE24에서 `ZCL_HR_GUN_V2`를 **변경 모드로 다시 엽니다**.

이 옵션은 클래스를 기본적으로 소스 기반 편집기로 열도록 하는 설정입니다. [SAP 공식 안내](https://help.sap.com/doc/saphelp_gbt10/1.0/en-US/67/6b5bbb681e4f10b44bc2d6c4167b02/content.htm?utm_source=chatgpt.com)

전환되면 지금의 표 대신 `CLASS … DEFINITION` 같은 코드가 보입니다.

**3번 항목이 없다면, ‘클래스 빌더’ 설정 탭을 캡처해서 보내주세요.** 해당 화면에 맞춰 다음 위치를 안내할게요.

## ess2-t012-u1 · 사용자



## ess2-t012-a1 · AI

확인했어요. **이 설정 화면에는 ‘소스 코드 기반’ 항목이 없습니다.** 앞서 현재 환경에 맞지 않는 경로를 안내했네요.

지금은 아래 두 가지만 해주세요.

1. 오른쪽 아래 **빨간 X**로 설정 창을 닫습니다.
2. 원래 클래스 화면 맨 위의 **`이동(G)` 메뉴**를 누릅니다.

**그 메뉴가 펼쳐진 상태를 캡처해 주세요.** 클래스 선언부를 편집하는 메뉴가 있는지 확인하려는 것입니다.

소스 기반 전환을 사용할 수 없어도, 현재 클래스 작성기에서 타입과 메서드를 나누어 등록하는 방법으로 진행할 수 있습니다. [SAP 공식 설명](https://help.sap.com/saphelp_snc70/helpdata/en/18/773e0f778211d1b4510000e8a52bed/content.htm?utm_source=chatgpt.com)

## ess2-t013-u1 · 사용자



## ess2-t013-a1 · AI

네, 여기서는 **위에서 두 번째 `공유섹션(P)`**을 누르면 됩니다.

이 화면에서는 선언부와 메서드 구현을 나누어 넣겠습니다. **먼저 선언부만** 넣으세요.

1. **`공유섹션(P)`**을 클릭합니다.
2. PC에서 R1 ZIP의 **`apply/ZCL_HR_GUN_V2.abap`** 파일을 엽니다.
3. 파일의 **`PUBLIC SECTION.` 다음 줄부터 첫 번째 `ENDCLASS.` 바로 전까지** 복사합니다.

  - 시작: `TYPES: BEGIN OF ty_day,`
  - 마지막: `IMPORTING i_text TYPE string RETURNING VALUE(rv_script) TYPE string.`
4. SAP 편집 화면의 기존 **`PUBLIC SECTION.` 아래**에 붙여 넣습니다. `PUBLIC SECTION.` 자체는 중복해서 넣지 않습니다.
5. **저장 → 뒤로(F3) → `방법` 탭**으로 이동합니다.
6. `CALENDAR`, `SPLIT_DATES`, `SAVE_SELECTED` 등을 포함한 **메서드 8개**가 생겼는지 확인합니다.

**지금은 저장까지만 하세요.** 각 메서드의 실제 처리 코드를 넣은 다음 활성화하면 됩니다.

## ess2-t014-u1 · 사용자



## ess2-t014-a1 · AI

지금은 **두 군데를 수정하면 됩니다.**

**1. `PUBLIC SECTION.` 바로 아래에 한 줄 추가하세요.**

```
TYPE-POOLS abap.
```

현재 환경에서는 `ABAP_BOOL`을 사용하기 위한 선언이 필요합니다. 제공 소스에 이 부분을 보완해야 하네요. `ABAP_BOOL`은 ABAP 타입 그룹에 정의된 형식입니다. [SAP 설명](https://help.sap.com/doc/abapdocu_731_index_htm/7.31/en-US/abenboole_functions.htm?utm_source=chatgpt.com)

위쪽이 이렇게 되면 됩니다.

```
PUBLIC SECTION.
  TYPE-POOLS abap.

  TYPES: BEGIN OF ty_day,
           datum TYPE d,
           free TYPE abap_bool,
```

**2. 공유섹션에 함께 붙여 넣은 구현부를 빼주세요.**

캡처에서는 **41행의 아래 문장까지만** 선언부입니다.

```
IMPORTING i_text TYPE string RETURNING VALUE(rv_script) TYPE string.
```

그 아래에 **직접 붙여 넣은 42행 `ENDCLASS.`부터 `CLASS … IMPLEMENTATION` 및 이후 메서드 코드 전체**는 이 공유섹션에서 제거하세요. 원본 파일에는 그대로 두고, 나중에 메서드별로 넣습니다.

그다음 **저장 → 뒤로(F3) → `방법` 탭**으로 이동하세요. 지금은 활성화하지 않아도 됩니다.

## ess2-t015-u1 · 사용자

너말대로 헀는데 이렇게 나오네

## ess2-t015-a1 · AI

**메서드 8개가 생성된 것은 맞습니다.** 다만 아래에 `ENDCLASS` 구문 오류가 남아 있어요. 앞서 삭제 범위를 더 명확히 안내했어야 했네요.

지금은 코드를 더 지우지 말고, 아래 순서로 확인해 주세요.

1. 화면 아래 노란색 **`You cannot use the statement "ENDCLASS"...` 오류 줄을 더블클릭**합니다.
2. 오류가 발생한 소스 화면으로 이동하면, **문제의 `ENDCLASS`와 그 위쪽 코드가 보이도록** 캡처해 주세요. 가능하면 **1~25행**을 보여주세요.

현재 화면만으로는 `ENDCLASS`가 중복됐는지, 앞쪽 클래스 선언이 빠졌는지 구분할 수 없습니다. **실제 오류 위치를 보고 수정할 줄을 정확히 짚겠습니다.**

## ess2-t016-u1 · 사용자

이거 해결 했어. 그다음은 ?

## ess2-t016-a1 · AI

그다음은 **메서드 8개에 실제 처리 코드를 넣는 단계**입니다. 가장 짧은 `UUID22`부터 하세요.

1. **`방법` 탭**에서 `UUID22`를 더블클릭합니다.
2. 열린 화면의 `METHOD uuid22.`와 `ENDMETHOD.` **사이에** 아래 코드를 넣습니다.

```
CALL FUNCTION 'GUID_CREATE'
  IMPORTING
    ev_guid_22 = rv_id.
```

3. 최종 모양이 아래와 같으면 됩니다. **`METHOD`와 `ENDMETHOD`는 각각 한 번만** 있어야 합니다.

```
METHOD uuid22.
  CALL FUNCTION 'GUID_CREATE'
    IMPORTING
      ev_guid_22 = rv_id.
ENDMETHOD.
```

4. **저장 → 뒤로(F3)**로 메서드 목록에 돌아옵니다.

나머지 7개도 같은 방식으로 넣습니다. PC의 `apply/ZCL_HR_GUN_V2.abap`에서 해당 부분을 찾아 **`METHOD 이름.` 다음 줄부터 짝이 되는 `ENDMETHOD.` 직전까지** 복사하세요.

| SAP에서 열 메서드 | 파일에서 검색할 시작 문장 |
| --- | --- |
| `ALERT_SCRIPT` | `METHOD alert_script.` |
| `CALENDAR` | `METHOD calendar.` |
| `SPLIT_DATES` | `METHOD split_dates.` |
| `SAVE_SELECTED` | `METHOD save_selected.` |
| `READ_UPLOADS` | `METHOD read_uploads.` |
| `SAVE_UPLOADS` | `METHOD save_uploads.` |
| `CAN_READ` | `METHOD can_read.` |

**8개 모두 넣고 저장한 다음, 클래스 전체 구문 검사 → 오류가 없으면 활성화**하세요. 오류가 나오면 해당 오류 문장과 표시된 소스 부분을 보내주시면 됩니다.

## ess2-t017-u1 · 사용자

이 파일 안에 소스코드가 이런데 이거 맞아 ?

## ess2-t017-a1 · AI

네, **캡처처럼 두 줄만 있는 게 맞습니다.** 제공 파일과 일치하고, 코드가 누락된 것은 아닙니다.

이 페이지는 달력 조회 결과를 돌려주는 용도라서, 실제 처리는 **`OnInitialization`**에 들어 있습니다.

SE80 → `ZHR0008` → **`guntae_v2_calendar.kbs`**에서 아래처럼 넣으세요.

| 넣을 위치 | 사용할 파일 |
| --- | --- |
| **Layout** | 지금 연 `guntae_v2_calendar_layout.kbs`의 두 줄 |
| **이벤트 처리기 → OnInitialization** | `guntae_v2_calendar_OnInitialization.kbs`의 전체 내용 |

**두 파일을 각각 넣고 저장하면 됩니다.** SAP 페이지 이름은 `_layout`을 제외한 `guntae_v2_calendar.kbs`입니다.

## ess2-t018-u1 · 사용자



## ess2-t018-a1 · AI

**긴 CSS 문자열이 여러 줄로 나뉘면서 발생한 오류입니다.** 제공 소스를 짧게 나눠야 하네요.

**82행의 `CONCATENATE lv_html`부터 다음 `IF ls_req-zattachment IS INITIAL.` 바로 앞까지**를 아래 코드로 교체하세요.

```
CONCATENATE lv_html
  `<style>`
  `body{font:15px 'Malgun Gothic',sans-serif;`
  `color:#172b44;background:#f5f7fb;padding:24px}`
  `main{max-width:760px;margin:auto;background:white;`
  `border:1px solid #dae3ef;border-radius:12px;padding:24px}`
  `h1{font-size:24px}`
  `li{padding:14px 0;border-bottom:1px solid #e2e8f0;`
  `overflow-wrap:anywhere}`
  `a{color:#1559b7}small{color:#52657c}`
  `</style></head><body><main><h1>근태 첨부파일</h1>`
  INTO lv_html.
```

각 줄의 문자열을 백틱으로 닫고, `CONCATENATE`로 이어 붙이는 방식입니다. 화면 모양은 동일합니다.

교체한 코드 바로 다음에 기존 `IF ls_req-zattachment IS INITIAL.`이 이어지면 됩니다. **저장한 뒤 다시 구문 검사**해 주세요.

## ess2-t019-u1 · 사용자



## ess2-t019-a1 · AI

이번에는 **테이블 필드를 `STRING` 변수에 먼저 담은 뒤 전달**하면 됩니다. 같은 방식의 호출이 있어 두 군데를 함께 수정하세요.

**① `LOOP AT lt_files INTO ls_file.` 바로 아래 세 줄을 다음으로 교체하세요.**

```
* 변경 전
* lv_name = cl_http_utility=>escape_html( ls_file-file_name ).
* lv_url = cl_http_utility=>escape_url( lv_group ).
* lv_encoded = cl_http_utility=>escape_url( ls_file-file_id ).

* 변경 후: STRING 변수에 담아서 전달
lv_name = ls_file-file_name.
lv_name = cl_http_utility=>escape_html( lv_name ).

lv_url = lv_group.
lv_url = cl_http_utility=>escape_url( lv_url ).

lv_encoded = ls_file-file_id.
lv_encoded = cl_http_utility=>escape_url( lv_encoded ).
```

**② 아래쪽 기존 첨부 처리 부분의 다음 두 줄도 교체하세요.**

```
* 변경 전
* lv_url = cl_http_utility=>escape_url( ls_req-zdokar ).
* lv_encoded = cl_http_utility=>escape_url( ls_req-zattachment ).

* 변경 후
lv_url = ls_req-zdokar.
lv_url = cl_http_utility=>escape_url( lv_url ).

lv_encoded = ls_req-zattachment.
lv_encoded = cl_http_utility=>escape_url( lv_encoded ).
```

`lv_name`, `lv_url`, `lv_encoded`는 제공 소스에서 이미 `TYPE string`으로 선언되어 있어 **변수를 추가할 필요는 없습니다.**

기존 코드는 `*` 주석으로 남긴 상태입니다. **저장 → 구문 검사**를 다시 실행해 주세요.

## ess2-t020-u1 · 사용자



## ess2-t020-a1 · AI

122행에는 기존 코드가 남아 있고, 수정 코드 일부가 다른 위치에 들어갔습니다. **OnInitialization 전체를 교체할 수 있는 수정본**을 만들었습니다.

`guntae_files_OnInitialization_fixed_XA32762.kbs`

1. 내려받은 파일을 편집기로 열고 **내용 전체를 복사**합니다.
2. SAP에서 **`ZHR0008 → guntae_files.kbs → Event Handler → OnInitialization`**을 엽니다.
3. **해당 이벤트의 코드 전체를 선택하고 붙여 넣습니다.**
4. **저장 → 구문 검사**를 실행합니다.

CSS 줄바꿈, 문자열 형변환 5곳, 첨부 링크와 파일 크기 처리를 함께 정리했습니다. 변경 전 코드는 주석으로 남겼으며, SAP에서의 구문 검사 결과는 적용 후 확인해야 합니다.
