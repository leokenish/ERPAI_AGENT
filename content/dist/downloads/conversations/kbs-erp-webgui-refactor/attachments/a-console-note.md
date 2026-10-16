# 오류 이미지와 첨부 상태

project_id: kbs-erp-webgui-refactor / 추출일: 2026-10-12 / 관련 발화: wg-m038

## 1. 실제 사용자 문장과 별개인 첨부 표시

현재 대화의 사용자 문장 뒤에는 다음 파일 읽기 실패 표시도 붙어 있다. 이는 사용자가 직접 쓴 업무 지시로 해석하지 않고, 첨부 전송 상태로 보존한다.

```text
Codex could not read the local image at `/workspace/scratch/327a5a0571af/upload/ad119731-38e7-4cb7-b45c-a8a04b6183af.png`: No such file or directory (os error 2)
```

그 뒤 콘솔 이미지가 표시되며, 2026-10-08 추출 기록에는 별도 저장본을 열어 확인했다고 남아 있다. 파일 읽기 실패 표시가 있었다는 사실과 이미지가 영원히 없었다는 주장은 다르다.

## 2. 교육용 안전한 전사

```text
[Violation] Permissions policy violation: unload is not allowed in this document.
Uncaught ReferenceError: gui_dropdownManager is not defined
  its_tablecontrolManager.init (gui_tablecontrol.js:186:22)
Uncaught TypeError: f.createTextRange is not a function
  webguiSetCursorPosition (gui_ts.js:360:13)
```

원본의 업무 문서 URL에는 세션 식별자로 보이는 문자열이 있어 제외했다. 본 전사는 이미지 전체를 대체하는 재생성 이미지가 아니며, 오류 문구와 비민감한 파일·함수 위치만 보존했다. 마스킹/제외 대상: 업무 문서 URL·식별자. 원본 PNG는 이 ZIP에 포함하지 않는다. JSON에서 해당 이미지의 path=null, availability=unavailable은 **배포물에서 제외**를 뜻하며, 처음부터 존재하지 않았다는 뜻이 아니다.

`gui_ts.js:360` 표시는 당시 이미지 그대로 보존했다. 확보 소스는 gui_ts.js126행, gui.js의커서 함수라는 불일치가 있어 교육 해설에서 별도로 설명한다. 제공본의 함수명에 맞춰 이미지 내용을 몰래 고치지 않는다.
