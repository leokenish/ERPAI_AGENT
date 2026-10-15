# 스크롤 화살표 클릭 후 오류: 진단 및 커서 복원 수정

작성일: 2026-09-13

**현재 상태: createTextRange 오류의 코드 경로를 재현하고 국소 수정본을 작성했다. gui_dropdownManager 미정의 오류의 운영 원인은 미확정이며, 화살표 스크롤 전체를 해결했다고 판단하지 않는다.**

## 1. 캡처와 실제 제공 파일 대조

캡처에는 다음 오류가 있다.

| 항목 | 판단 |
|---|---|
| unload Permissions Policy 위반 | 문서에서 unload 사용이 정책으로 제한됐다는 메시지. 이것만으로 아래 두 오류의 원인이라고 단정할 수 없음 |
| gui_dropdownManager is not defined | 실행 중인 문서가 해당 생성자를 참조할 때 정의를 찾지 못함. 테이블 초기화 186행에서도 같은 오류 발생 |
| f.createTextRange is not a function | 커서 복원 대상 요소에 해당 API가 없는데 호출함 |

기존 `WEBGUI_Optimized.zip`, 로컬 수정본, 확보한 원본을 바이트로 대조했다. 다음 4개 파일은 이전 작업에서 수정되지 않았으며 세 위치의 내용이 일치한다.

| 파일 | 바이트 | 줄 수 | 확인한 내용 |
|---|---:|---:|---|
| gui_dropdown.js | 46,453 | 1,825 | 11행에 gui_dropdownManager 선언. 전체 파일을 독립 JS 컨텍스트에 로드하면 생성자 정의와 TC 인스턴스 생성이 정상 |
| gui_tablecontrol.js | 72,129 | 2,532 | 186행에서 new gui_dropdownManager(obj, "TC") 호출. 캡처와 일치 |
| gui.js | 39,262 | 1,665 | 358행에 webguiSetCursorPosition, 360행에 f.createTextRange 호출 |
| gui_ts.js | 3,949 | 126 | 탭 메뉴 함수 3개. webguiSetCursorPosition 정의 없음 |

**캡처는 커서 오류를 gui_ts.js:360으로 표시하지만, 제공본은 gui.js:360이다.** 응답 파일의 내용·배포 매핑·캐시 혼재 또는 개발자 도구의 소스 표시/매핑을 확인해야 한다. 이것만으로 사용자가 잘못 업로드했다고 결론짓지 않는다. 제공 ZIP 안에서 gui_dropdownManager를 삭제하거나 누락한 흔적은 찾지 못했다.

직전 SYSTEMGUI 변경은 its_utils.js의 DOM 탐색·좌표 조회 함수 4개와 gui.css 색상에 한정된다. 위 생성자·스크립트 로드·커서 복원 코드를 직접 수정하지 않았다. 다만 실서비스의 로드 순서와 화살표 클릭 후 문서 갱신을 재현하지 못했으므로, 이번 변경과 증상 사이의 간접적인 연관까지 배제한 것은 아니다.

## 2. createTextRange 오류 원인과 수정

원본 gui.js의 webguiSetFocus는 텍스트 INPUT의 커서 위치가 있을 때 its_ua.ie55up이 참이면 타이머를 통해 webguiSetCursorPosition을 호출한다. 이 함수는 조건 없이 createTextRange를 호출한다.

기존 its_useragent는 Chrome·일반 Edge UA의 `like Gecko` 문자열도 IE 분류에 포함한다. 따라서 표준 브라우저 요소가 IE용 커서 복원 경로에 진입할 수 있다. 모의 실행에서 이 조합으로 캡처와 같은 TypeError를 재현했다. 실제 해당 문서의 its_ua 값과 요소는 아직 직접 관측하지 않았다.

이번 패치는 webguiSetCursorPosition에 다음 분기만 추가한다.

```javascript
  // The legacy UA flag can match Chromium. Use the field API without changing focus timing.
  if (!f.createTextRange && typeof f.setSelectionRange == "function")
  {
    f.setSelectionRange(webguiFocusFieldCursorPos, webguiFocusFieldCursorPos);
    return;
  }
```

기존 createTextRange API가 있으면 원래 코드의 호출·move·select 순서를 유지한다. API가 없고 setSelectionRange를 지원하면 같은 커서 위치를 표준 API에 전달한다. [MDN setSelectionRange 문서](https://developer.mozilla.org/en-US/docs/Web/API/HTMLInputElement/setSelectionRange)에 설명된 텍스트 선택 API이며, 기존 원본의 비IE 분기에도 이미 사용되고 있다.

함수명·매개변수·기존 반환 형식, 포커스 예약 순서, 타이머 코드, 브라우저 판별 전체, 휠·화살표 이동량, 서버 요청을 바꾸지 않았다. 예외를 무조건 삼키거나 gui_dropdownManager의 가짜 구현을 추가하지 않았다. 일반적인 입력 요소가 아닌 대상에 대한 별도 기능을 추가한 패치는 아니다.

## 3. 수정본과 검증

- `WEBGUI_Cursor_Fix.zip`: 완전한 `WEBGUI/JS/gui.js` 1개. 보고서나 새 의존성을 포함하지 않음.
- `WEBGUI_Cursor_Rollback.zip`: 위 수정 전 gui.js 1개. 기존 제공본 기준이며 실제 서버의 적용 전 백업을 대체하지 않음.
- `WEBGUI_Arrow_Error_Report.md`: 본 보고서.

검증 결과:

1. 원본·수정본 ECMAScript 3 구문 검사 통과.
2. webguiSetCursorPosition 본문을 제외한 전체 AST 동일. 호출자와 타이머 코드는 그대로다.
3. 모의 검증 25건 통과. IE API만 있는 요소, 두 API가 있는 요소, 표준 API만 있지만 IE로 판별된 요소, 기존 비IE 경로와 여러 커서 값을 확인했다. API가 둘 다 없는 경우까지 오류를 숨기지는 않는다.
4. 표준 API만 있는 요소·IE 플래그·커서 위치 5의 원본은 createTextRange TypeError 발생. 수정본은 동일 타이머를 실행한 뒤 setSelectionRange(5, 5)를 호출했다.
5. 실제 Chrome·Edge·IE 모드, SAP 업무 화면과 저장·제출은 미검증이다. 이 패치로 dropdown 미정의 문제가 해결됐다고 주장하지 않는다.

## 4. 적용 전 확인과 복원

**현재는 파일명·함수 위치의 불일치를 먼저 확인해야 한다.** 이 패치는 제공받았던 gui.js를 기준으로 작성했으며, 실제 서버 응답이 다른 버전이면 해당 응답을 기준으로 다시 대조해야 한다.

Network에서 오류가 난 업무 문서에 연결된 gui_dropdown.js와 gui_ts.js 요청의 **Response 본문**을 확인한다. Sources의 표시 이름만으로 판단하지 않는다.

- gui_dropdown.js: 요청이 존재하는지, 실제 본문에 `function gui_dropdownManager`가 있는지 확인한다. 200 응답이어도 오류 HTML이 반환됐을 수 있으므로 본문을 확인한다. 요청 자체가 없다면 업무 문서의 script 목록이 필요하다.
- gui_ts.js: 실제 본문이 탭 메뉴 코드인지, gui.js의 내용이나 다른 코드인지 확인한다.
- 업무 문서: `<script>`의 src·순서·async/defer/type 및 오류가 난 초기화 코드의 위치를 확인한다. 부모와 내부 iframe은 별도 실행 컨텍스트다.

서버의 실제 파일이 제공본과 대응됨을 확인한 뒤, 테스트 환경의 기존 WEBGUI gui.js를 백업하고 패치를 적용한다. **gui_ts.js나 SYSTEM its_utils.js 위치에 이 gui.js를 넣지 않는다.** MIME 게시 후 새 세션·캐시 갱신으로 실제 응답에 새 분기가 포함됐는지 확인한다. 기존 디자인·스크롤 패치를 함께 다시 적용할 필요는 없다.

문제가 있으면 gui.js를 적용 직전 서버 백업으로 복원하고 같은 게시·캐시 갱신을 수행한다. 제공 롤백 ZIP은 서버 백업이 이전 제공본과 일치하는 경우 사용할 수 있다.

직전 SYSTEM 변경과의 인과관계만 분리하려면 동일 테스트 화면에서 its_utils.js를 적용 직전 백업으로 되돌린 상태와 비교할 수 있다. 결과는 원인 분리를 위한 것으로, 미정의 생성자 오류의 해결을 보장하지 않는다.

## 5. 추가로 필요한 자료

오류 발생 직후 **업무 문서의 script 태그 목록**, **gui_dropdown.js와 gui_ts.js의 Network → Response 원문**이 필요하다. 요청이 실패했다면 상태·차단 이유를, 요청이 없다면 없다는 점을 함께 알려주면 된다. 업무 값·토큰을 포함한 전체 HAR나 쿠키는 필요하지 않다.

unload 경고는 브라우저의 해당 이벤트 제한과 관련된다. [Chrome 공식 설명](https://developer.chrome.com/docs/web-platform/deprecating-unload)과 같이 이벤트 사용 정책 자체를 확인할 사안이다. 경고를 없애기 위해 세션 종료 코드를 임의로 삭제하거나 pagehide로 치환하지 않았다.
