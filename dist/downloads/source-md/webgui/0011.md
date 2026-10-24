**ITS Chrome v3 — HTML·JavaScript·CSS 통합 리팩토링 보고서**

작성일: 2026-09-14. 대상: 제공된 WEBGUI 67개와 SYSTEMGUI 33개, 총 100개(JS 47·CSS 34·HTML 19).

기존 개편본을 기준으로 **33개 파일(HTML 14·JS 16·CSS 3)**을 추가 수정했습니다. 수정하지 않은 67개도 전체 ZIP에 포함했습니다. 재동기화된 `contextmenubase.html`은 736바이트 원본을 정상 확보했고, 빈 대상 파일은 없습니다.

이 결과는 검토·시험 적용용입니다. 실제 SAP 업무 화면과 실제 Chrome에서 모든 버그가 해결됐다는 인증은 아닙니다. 자동 승인 검토가 Cloud Chrome의 로컬 검증 페이지 접근을 거절했으므로, 접근을 우회하지 않고 정적 분석과 V8/DOM 모델 검증을 수행했습니다.

**기준 버전과 결과물**

WEBGUI 기준본은 이전 전체 디자인 개편본에 스크롤 패치 4개와 커서 수정본 gui.js를 반영한 버전입니다. SYSTEMGUI 기준본은 이전 its_utils.js·gui.css 수정본에 새 HTML 19개를 더했습니다. Drive SYSTEM JS·CSS 메타데이터는 이전 확보본과 일치했고, HTML은 새로 다운로드했습니다. 마지막 재동기화에서 contextmenubase.html을 다시 확보했습니다.

| 파일 | 내용 |
|---|---|
| ITS_Chrome_v3_Full.zip | 전체 100개 완전한 소스. 이전 개선과 이번 변경을 모두 포함 |
| ITS_Chrome_v3_Apply.zip | 이번에 바뀐 33개 파일만 포함. 위 기준 버전을 이미 적용한 경우 사용 |
| ITS_Chrome_v3_Rollback.zip | 이번 작업 직전 기준본 100개. 새 HTML은 제공받은 원본 상태 |
| ITS_Chrome_v3_Original.zip | 처음 제공받은 JS·CSS 원본과 최신 HTML 원본 100개 |
| ITS_Chrome_v3_Evidence.zip | 전체 diff·SHA-256·검증 코드/결과·전후/원본 소스 |

Rollback은 실제 운영 서버에서 내려받은 백업이 아닙니다. 서버에 별도 수정이 있었다면 적용 직전에 직접 백업한 파일이 정확한 복원 기준입니다. ZIP에는 운영 실행에 필요한 기존 대상 파일만 넣었고, 테스트 코드·보고서·새 의존성을 교체용 ZIP에 섞지 않았습니다.

**우선순위에 따른 변경**

| 우선순위 | 반영 내용 | 확인 범위 |
|---|---|---|
| 업무 기능·데이터 정확성 | POST 값 손실·HTML 속성 손상·쿼리 무한 반복·메뉴 제출 실패 후 폼 오염 수정 | 실제 함수 실행과 제출 직전 값 모형 검증. SAP 처리 결과는 미검증 |
| 기존 시스템 호환성 | 함수 이름/매개변수, 폼 이벤트 명칭, 동기 호출, URL 인코딩·행 번호 유지 | 소스 대조. Chrome 기준이며 다른 브라우저 동작 인증은 아님 |
| 배치·조작 유지 | CSS 기존 선언, HTML 태그/ID/name 순서, 문서 모드, 휠 이동량·대기값 유지 | 정적 대조. UA 분기·좌표 결함 수정의 실제 배치는 화면 확인 필요 |
| 디자인·가독성 | 보조 HTML 색상 통일, 키보드 포커스 outline, 비활성 스크롤 표시 | CSS/JS 연결 분석. 실제 확대·축소·가독성 검증은 미실행 |
| 근거 있는 성능 개선 | 중복 휠 콜백 제거, 중복 이벤트 관리자 생성 제거, 네이티브 outerHTML 보존 | 코드 경로 및 모의 호출 수로 확인. FPS/응답 속도 개선율은 측정하지 않음 |

**이전 오류와 이번 결과**

| 증상/결함 | 이번 처리 | 남은 한계 |
|---|---|---|
| f.createTextRange is not a function | Chrome을 IE로 분류하던 두 유틸리티 수정. gui.js에서 필드 API를 확인해 커서 복원 | 캡처의 gui_ts.js:360과 제공된 gui_ts.js(126행)의 불일치 원인은 미확인. 실제 서버 Response를 대조해야 함 |
| gui_dropdownManager is not defined | shmult.html의 SL/sl 경로 불일치 수정. 제공 스크립트를 순서대로 실행한 DOM 모델에서 드롭다운·TC 초기화 확인 | SL/sl을 구분하는 경로 모델에서 재현한 결과. 이전 오류 화면은 업무 HTML이 없어 같은 원인인지 미확인. 가짜 생성자나 오류 무시 코드는 넣지 않음 |
| unload 권한 정책 메시지 | sap_secu의 실패 초기화 객체 해제만 pagehide로 옮기고 persisted인 경우 보존 | ITSSM_unload 구현과 서버 생성 이벤트 코드는 없음. 세션 정리·저장 관련 unload를 일괄 치환하지 않아 다른 경로의 메시지는 남을 수 있음 |
| 화살표 반복 입력 중 이벤트 상태 공유 | sbEvent를 독립 객체로 만들고 표준 버튼 값으로 변환 | 실제 마우스·터치패드·ERP 반복 입력은 미검증 |
| 350ms·700ms 콜백 중복 | 휠이 예약을 소유하도록 내부 350ms 콜백을 취소하고 기존 wheelDelay 유지 | 실제 화면이 이 함수 경로를 사용하는지는 별도 확인 필요 |
| 메뉴 제출 오류 후 다음 요청 대상 변경 | ContextMenu_postUrl에서 실패 시 target/action/event 필드 복원 | 실패를 주입한 모형으로 검증. 서버 응답으로 메뉴가 표시되는 단계는 미검증 |

Chrome의 document.domain 변경 제한에 맞춰 `originAgentCluster === true`인 경우 대입을 생략합니다. 기존 서버가 명시적으로 다른 에이전트 클러스터 동작을 사용하는 환경에서는 원래 분기를 유지합니다. 같은 출처의 프레임 통신을 전제로 하며, 서로 다른 출처 사이의 DOM 접근을 새로 허용하지 않습니다. [Chrome 공식 설명](https://developer.chrome.com/blog/document-domain-setter-deprecation/)

커서 복원은 지원하는 텍스트 유형에만 setSelectionRange를 호출합니다. 숫자·날짜 등 지원하지 않는 필드에 호출해 새 오류를 만드는 것을 방지했습니다. [MDN API 문서](https://developer.mozilla.org/en-US/docs/Web/API/HTMLInputElement/setSelectionRange)

unload 메시지 제거 자체와 세션 기능 보존을 구분했습니다. 변경한 sap_secu 콜백에는 서버 요청이 없고, 메모리 객체 해제만 있습니다. BFCache에 보관되는 문서에서는 해제하지 않습니다. 다른 세션 종료 콜백은 구현 자료 없이 변경하지 않았습니다. [Chrome unload 설명](https://developer.chrome.com/docs/web-platform/deprecating-unload)

**통신·데이터 계약**

- framepost의 POST, target=_self, application/x-www-form-urlencoded, 초기 파라미터의 URL 디코딩과 + 공백 처리는 유지했습니다. 새로운 JSON 요청이나 비동기 API로 바꾸지 않았습니다.
- 숫자 0과 false는 빈 문자열로 버리지 않습니다. 잘못 인코딩된 파라미터가 있으면 hidden field와 부모 제외 목록에 반영하기 전에 실패합니다. 오류를 무시하고 일부 값만 제출하지 않습니다.
- sap_commobj의 이스케이프는 HTML 문법을 보호하기 위한 것입니다. HTML 파서가 읽는 input의 name/value는 원래 텍스트와 일치하도록 한글·따옴표·앰퍼샌드·줄바꿈을 확인했습니다. 삭제된 행은 생략하되 뒤 행의 [n] 번호를 당기지 않습니다. 배열 속성은 기존 실제 동작인 쉼표 연결 문자열을 유지합니다.
- contextmenubase의 contextform에는 GET이 있지만, 이 페이지는 그 폼을 직접 제출하지 않습니다. 부모 업무 폼을 대상으로 기존 ContextMenu_postUrl(controlid, myevent, params, x, y)를 한 번 호출합니다. 실제 업무 폼의 method는 변경하지 않았습니다.
- 메뉴 함수의 정상 제출 경로는 요청 대상 ContextFrame0·주소·제어/이벤트·좌표 값과 정리 동작을 비교했습니다. 예외 시에는 다음 요청이 메뉴 프레임으로 잘못 향하지 않도록 복원한 뒤 원래 오류를 전달합니다.
- 휠의 이동량과 wheelDelay를 줄이지 않았습니다. 서버로 HTML을 다시 요청하고 메뉴 프레임을 구성하는 기존 구조도 유지됩니다.

**검증 결과**

| 검증 | 결과 |
|---|---|
| 전체 파일 | 전후 100개, 이름·폴더 구성 일치, 빈 파일 없음 |
| JavaScript | 47개 모두 ES3 구문 파싱 통과. Chrome API 사용 가능 여부와 구문 호환성은 별개 |
| HTML 코드 | 인라인 스크립트 30개·이벤트 속성 66개 구문 검사 통과 |
| 공개 이름/매개변수 | 기존 명명 함수 선언의 이름·매개변수 유지 검사 통과. 변경 함수와 추가 지역 함수는 diff에 기록 |
| CSS | 34개 모두 기존 선언 부분 바이트 일치. 3개 CSS 파일 끝에 focus-visible 규칙만 추가 |
| HTML 구조 | 19개 태그/ID/name 시퀀스와 DOCTYPE 유지 검사 통과 |
| 동작 모의 회귀 | 186건 통과: UA·마우스 버튼·커서·IME·쿼리·좌표·프레임·스크롤·POST·메뉴 복원 등 |
| 직렬화 독립 검사 | 생성된 hidden input HTML 7건을 Python HTML 파서로 읽어 name/value 대조 통과 |
| 소스 연동 모형 | SYSTEM→WEBGUI 및 반대 유틸리티 로드 순서, shmult 스크립트 순서, TC/드롭다운 초기화 확인 |
| ZIP | 전체·복원·원본 각 100개, 변경 패치 33개. CRC와 파일 바이트 대조 통과 |
| 실제 브라우저/ERP | 미실행. 자동 승인 검토가 Cloud Chrome의 로컬 URL 접근을 차단. SAP 세션·업무 데이터를 사용한 검증 없음 |

이전 패치의 916건 등의 수치를 이번 검증 건수에 합산하지 않았습니다. 이번 실행 결과는 validation.json, markup_validation.json, inline_validation.json, integration_validation.json에 따로 기록했습니다. DOM 모델은 브라우저의 레이아웃 엔진·IME 입력기·네트워크를 대체하지 않습니다.

**성능 근거와 예상 효과**

기본 wheelDelay=700인 모의 단일 휠 입력에서 기존 코드는 같은 위치 13으로 350ms와 700ms에 콜백을 두 번 실행했습니다. 수정본은 700ms에 한 번 실행합니다. 이는 실제 서버 요청 수나 체감 지연의 측정값이 아니라 결정적 타이머 모형의 코드 경로 결과입니다. 화살표 350ms 대기와 로컬 스크롤의 정상 콜백은 별도 비교했습니다.

shmult의 이벤트 관리자 중복 생성 제거는 문서당 불필요한 객체 생성 한 번을 줄입니다. outerHTML 네이티브 구현을 덮어쓰지 않아 이후 cloneNode/직렬화로 우회하는 비용과 setter 손실을 막습니다. 쿼리 파서의 반복 종료는 성능 튜닝 이전에 정확성 결함 수정입니다. 실제 FPS·레이아웃 횟수·서버 처리 시간의 개선율은 제시하지 않습니다.

**적용·복원 및 실제 확인 항목**

1. 현재 서버의 해당 파일을 먼저 백업합니다. 검증 환경에서 전체 버전을 같은 변경 묶음으로 적용하는 것이 좋습니다. 이전 기준본과 일치하는 경우에만 Apply.zip 33개 패치를 사용하세요. 기존 WEBGUI와 SYSTEMGUI 유틸리티를 섞어 적용하지 마세요.
2. ZIP의 업로드용 폴더를 MIME 실제 경로에 대응시킵니다. 아래 경로는 제공된 소스 참조로 확인한 구분입니다. 서버의 실제 서비스 경로·테마 이름은 기존 설정을 유지합니다.

| ZIP 폴더 | 소스에 나타나는 실제 MIME 경로 |
|---|---|
| WEBGUI/JS | /mimes/webgui/sl/scripts |
| WEBGUI/CSS | /mimes/webgui/sl/style |
| SYSTEMGUI/JS | /mimes/system/sl/script |
| SYSTEMGUI/CSS | /mimes/system/sl/style |
| SYSTEMGUI/HTML | /mimes/system/sl/page |

3. SAP MIME 서비스가 새 바이트를 반환하는지 확인하고, 해당 테스트 세션을 다시 열어 캐시를 갱신합니다. Network Response에서 변경 주석이나 파일 내용이 실제 제공되는지 확인하세요. CSS·JS를 부분적으로 오래 캐시한 상태에서 비교하지 마세요. 서버 캐시 정책을 JS로 변경하거나 일괄 비활성화하지 않았습니다.
4. 최초 진입 → 조회 → 휠 → 화살표 단일 클릭 → 길게 누르기 → 드롭다운 → 우클릭 메뉴 → 메뉴 선택 순서로 검증합니다. TC·ALV·검색 도움말·팝업·iframe·분할선을 각각 포함합니다.
5. 한글 IME 조합 Enter와 일반 Enter, 붙여넣기, Tab·방향키·단축키, 커서 위치 0과 중간, 읽기 전용·비활성 필드, 화면 확대/축소·스크롤 경계·RTL 사용 여부를 확인합니다. 실제 저장·제출 검증은 테스트 데이터로만 수행하세요.
6. 실패 시 실제 서버 백업 또는 Rollback 전체 버전으로 되돌리고 캐시를 다시 갱신합니다. Rollback의 HTML은 최신 업로드 원본이며, 재동기화된 contextmenubase.html도 정상 내용이 들어 있습니다.

추가 확인이 필요한 자료는 오류가 발생한 업무 화면의 실제 Response HTML과 제공된 gui.js/gui_ts.js/gui_dropdown.js가 서버에서 응답되는 내용입니다. IAC generator/splitter 리소스와 이미지 원본도 제공 범위 밖이므로 실제 화면에서 확인해야 합니다. 메뉴 화면의 서버 응답 HTML·ITSSM_unload 구현·교차 출처 프레임이 있는 경우의 구성·지원 Chrome 버전별 동작도 미검증입니다.

**파일별 변경 목록 — 이번 기준본 대비**

기존 수정 유지로 표시된 파일은 이번 버전에서 추가 변경하지 않았습니다. 전체 diff와 세 버전의 SHA-256은 Evidence에 포함했습니다.

| 파일 | 이번 변경 | 이유·주요 내용 |
|---|---|---|
| `SYSTEMGUI/CSS/gui.css` | 수정 | 기존 선언은 바이트 단위로 유지하고 About 버튼의 Chrome 키보드 포커스 outline만 추가. 크기·위치·SYSTEM 이미지 경로 보존. |
| `SYSTEMGUI/HTML/aboutbox.html` | 수정 | 이전 WEBGUI 색상 체계에 맞춰 배경·텍스트 색상 정리. 크기·위치·DOM·콜백·이미지·문서 모드 유지. |
| `SYSTEMGUI/HTML/contextmenubase.html` | 수정 | 재동기화된 736바이트 원본을 포함. 부모의 ContextMenu_postUrl에 다섯 인수를 동기 전달하는 계약을 주석으로 명시하고 불필요한 javascript 레이블 제거. helper의 GET 폼은 스스로 제출하지 않음. |
| `SYSTEMGUI/HTML/dockingsash.html` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `SYSTEMGUI/HTML/emptypage.html` | 수정 | 이전 WEBGUI 색상 체계에 맞춰 배경·텍스트 색상 정리. 크기·위치·DOM·콜백·이미지·문서 모드 유지. |
| `SYSTEMGUI/HTML/endsess.html` | 수정 | 이전 WEBGUI 색상 체계에 맞춰 배경·텍스트 색상 정리. 크기·위치·DOM·콜백·이미지·문서 모드 유지. |
| `SYSTEMGUI/HTML/framepost.html` | 수정 | 동적 속성 접근의 eval 제거. 숫자 0·false 보존, 상속 속성 제외, 인코딩된 파라미터를 모두 해석한 뒤 필드와 제외 목록 반영. 잘못된 인코딩이면 제출 전 중단. submit 필드 이름 충돌 대응. POST·target·인코딩 계약 보존. |
| `SYSTEMGUI/HTML/hourglass.html` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `SYSTEMGUI/HTML/lodingpage.html` | 수정 | 이전 WEBGUI 색상 체계에 맞춰 배경·텍스트 색상 정리. 크기·위치·DOM·콜백·이미지·문서 모드 유지. |
| `SYSTEMGUI/HTML/menubase.html` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `SYSTEMGUI/HTML/perfdisplay.html` | 수정 | 이전 WEBGUI 색상 체계에 맞춰 배경·텍스트 색상 정리. 크기·위치·DOM·콜백·이미지·문서 모드 유지. |
| `SYSTEMGUI/HTML/sheerror.html` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `SYSTEMGUI/HTML/shmult.html` | 수정 | gui_dropdown.js의 대문자 SL 경로를 기존 상대 sl 경로로 수정. 동반 IE 스타일 경로도 정규화. 이벤트 관리자 중복 생성 제거. 스크립트 동기 로드 순서·스타일 적용 순서 유지. |
| `SYSTEMGUI/HTML/splashscreen.html` | 수정 | 이전 WEBGUI 색상 체계에 맞춰 배경·텍스트 색상 정리. 크기·위치·DOM·콜백·이미지·문서 모드 유지. |
| `SYSTEMGUI/HTML/splittersash.html` | 수정 | onmouseup 속성 뒤 잘못 들어간 세미콜론 제거. 부모 콜백·클래스·분할선 구조 보존. |
| `SYSTEMGUI/HTML/tabstripmenu.html` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `SYSTEMGUI/HTML/wgu_empty.html` | 수정 | 이전 WEBGUI 색상 체계에 맞춰 배경·텍스트 색상 정리. 크기·위치·DOM·콜백·이미지·문서 모드 유지. |
| `SYSTEMGUI/HTML/wgu_pers_emptypage.html` | 수정 | IE 전용 event/for 스크립트가 Chrome에서 즉시 실행되어 event 오류를 내는 구조를 네이티브 contextmenu 리스너로 수정. 기존 우클릭 차단 방식과 요소 위치를 유지하고 배경색 정리. |
| `SYSTEMGUI/HTML/wgu_pers_emptypage1.html` | 수정 | IE 전용 event/for 스크립트가 Chrome에서 즉시 실행되어 event 오류를 내는 구조를 네이티브 contextmenu 리스너로 수정. 기존 우클릭 차단 방식과 요소 위치를 유지하고 배경색 정리. |
| `SYSTEMGUI/HTML/wgu_pers_emptypage2.html` | 수정 | IE 전용 event/for 스크립트가 Chrome에서 즉시 실행되어 event 오류를 내는 구조를 네이티브 contextmenu 리스너로 수정. 기존 우클릭 차단 방식과 요소 위치를 유지하고 배경색 정리. |
| `SYSTEMGUI/JS/dss_list.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `SYSTEMGUI/JS/editorg.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `SYSTEMGUI/JS/its_domain.js` | 수정 | originAgentCluster가 true인 Chrome 문서에서 효과 없는 domain 대입 생략. 함수·캐시 속성·별칭 유지. 브라우저가 허용하는 기존 환경의 분기 보존. |
| `SYSTEMGUI/JS/its_frameset.js` | 수정 | 비활성 프레임 조회에서 함수 객체를 비교하던 코드를 실제 활성 프레임 조회 호출로 수정. 프레임 전환·종료 통신 로직 유지. |
| `SYSTEMGUI/JS/its_utils.js` | 수정 | Chrome IE 오분류 수정, 네이티브 outerHTML 보존, 좌표 계산의 미정의 변수·문서 참조 수정, 0 스크롤 처리, 이벤트 인수·버튼·오프셋·휠 취소 일관화. 기존 4개 DOM 조회 개선도 유지. |
| `SYSTEMGUI/JS/sap_commobj.js` | 수정 | HTML 속성의 특수문자·줄바꿈 이스케이프, 삭제된 행 건너뛰기, fld 전역 유출 제거. 남은 행 번호와 실제 기존 배열 속성 직렬화 형식을 보존하면서 도달 불가능한 분기 정리. |
| `SYSTEMGUI/JS/sap_externalwindowinterface.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `SYSTEMGUI/JS/sap_its.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `SYSTEMGUI/JS/sap_refreshinterface.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `SYSTEMGUI/JS/sap_savecancelinterface.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `SYSTEMGUI/JS/sap_secu.js` | 수정 | 초기화 실패 뒤 객체 참조만 해제하는 unload 처리만 pagehide로 변경. BFCache에 보관되는 경우 상태를 유지. 토큰 생성·폼 수정·종료 요청 로직은 보존. |
| `SYSTEMGUI/JS/sap_terminateinterface.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `SYSTEMGUI/JS/sapwebframework.js` | 수정 | 정규식 결과 배열의 lastIndex 사용으로 끝나지 않던 쿼리 파서를 index와 일치 문자열 길이로 수정. 인코딩·중복 키 처리·반환 형식 보존. domain 진입점 통일. |
| `WEBGUI/CSS/calendar.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/CSS/columntree.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/CSS/columntree_ie.css` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/CSS/dynprolist.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/CSS/edit.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/CSS/generator.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/CSS/gui.css` | 수정 | About 버튼에 크기를 바꾸지 않는 inset outline 포커스 표시 추가. |
| `WEBGUI/CSS/gui_bar.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/CSS/gui_button.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/CSS/gui_cua.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/CSS/gui_cua_ie.css` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/CSS/gui_dropdown.css` | 수정 | 기존 드롭다운 선택자에 focus-visible outline 추가. 기존 높이·너비·테두리·선택 상태 색상 유지. |
| `WEBGUI/CSS/gui_dropdown_ie.css` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/CSS/gui_dynpro_ie6.css` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/CSS/gui_font.css` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/CSS/gui_gridview.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/CSS/gui_gridview_ie.css` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/CSS/gui_groupbox.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/CSS/gui_input.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/CSS/gui_page.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/CSS/gui_popup.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/CSS/gui_popupresize.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/CSS/gui_scroll.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/CSS/gui_splitter.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/CSS/gui_statusbar.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/CSS/gui_tablecontrol.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/CSS/gui_tablecontrol_ie.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/CSS/gui_toolbar.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/CSS/gui_toolbarctrl.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/CSS/gui_toolbarctrl_ie.css` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/CSS/gui_ts.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/CSS/menu.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/CSS/searchhelpctrl.css` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/JS/calendar.js` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/JS/columntree.js` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/JS/control.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/JS/controldhtml.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/JS/edit.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/JS/ewtlib.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/JS/gui.js` | 수정 | 선택 가능한 필드 유형 확인 후 setSelectionRange 사용. 커서 위치 0·음수·범위 초과·유실된 필드 처리. 포커스 이동과 요청 처리는 별도 기존 경로 유지. |
| `WEBGUI/JS/gui_a11y.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/JS/gui_acf.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/JS/gui_ctxtmenu.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/JS/gui_cua.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/JS/gui_dialogbox.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/JS/gui_dropdown.js` | 수정 | 드롭다운과 Dynpro 드롭다운에서 IME 조합을 업무 선택과 구분. 생성자·공개 메서드·항목 구조 유지. |
| `WEBGUI/JS/gui_event.js` | 수정 | 한글 IME 조합 중 Enter·단축키가 업무 제출로 처리되지 않도록 전역 키 처리 진입점 보호. |
| `WEBGUI/JS/gui_form.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/JS/gui_gridview.js` | 수정 | ALV 키 처리의 IME 조합 보호. 기존 스크롤 동기화 최적화 유지. |
| `WEBGUI/JS/gui_list.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/JS/gui_perf.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/JS/gui_popupresize.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/JS/gui_scroll.js` | 수정 | 화살표 반복 이벤트를 개별 객체로 생성, 콜백이 올바른 컨트롤을 참조하도록 지역화, 휠 내부의 남은 350ms 타이머 취소. 기존 휠 지연값·이동량 유지. Chrome 휠 등록/해제와 px 위치 적용·비활성 표시 보완. |
| `WEBGUI/JS/gui_shbutton.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/JS/gui_splitter.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/JS/gui_statusbar.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/JS/gui_tablecontrol.js` | 수정 | 테이블 자체의 키 핸들러가 전역 처리 전에 실행되는 경로에서도 IME 조합 보호. |
| `WEBGUI/JS/gui_toolbarctrl.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/JS/gui_ts.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/JS/htmlviewer.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/JS/itsdoc.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/JS/menu.js` | 수정 | contextmenubase에서 호출하는 메뉴 제출에 try/finally 적용. 제출 실패 시 업무 폼의 target·action·saveAction·제어/이벤트/요청 필드 복원. 성공 시 기존 파라미터와 정리 동작 보존. submit 이름의 필드가 메서드를 가릴 때 네이티브 제출 사용. |
| `WEBGUI/JS/menubase.js` | 유지 | 제공 원본 그대로 포함. 연결 경로·구문 검토 대상. |
| `WEBGUI/JS/searchhelpctrl.js` | 유지 | 이전 개선본 그대로 포함. |
| `WEBGUI/JS/wgu_domain.js` | 수정 | SYSTEM 도메인 함수와 동작 통일. 동일 출처 접근을 사용하고 교차 출처 제한을 우회하지 않음. |
| `WEBGUI/JS/wgu_frameset.js` | 수정 | SYSTEM 프레임 관리와 동일한 비활성 프레임 선택 결함 수정. |
| `WEBGUI/JS/wgu_utils.js` | 수정 | 공통 유틸리티와 같은 Chrome 판별·이벤트 API 적용. 여러 정적 인수가 있는 이벤트 콜백의 문자열 생성 오류를 apply 호출로 수정. 기존 호출의 this와 인수 순서 보존. |

**다운로드**

- [ITS_Chrome_v3_Full.zip](sandbox:/workspace/scratch/327a5a0571af/output/ITS_Chrome_v3_Full.zip)
- [ITS_Chrome_v3_Apply.zip](sandbox:/workspace/scratch/327a5a0571af/output/ITS_Chrome_v3_Apply.zip)
- [ITS_Chrome_v3_Rollback.zip](sandbox:/workspace/scratch/327a5a0571af/output/ITS_Chrome_v3_Rollback.zip)
- [ITS_Chrome_v3_Original.zip](sandbox:/workspace/scratch/327a5a0571af/output/ITS_Chrome_v3_Original.zip)
- [ITS_Chrome_v3_Evidence.zip](sandbox:/workspace/scratch/327a5a0571af/output/ITS_Chrome_v3_Evidence.zip)
