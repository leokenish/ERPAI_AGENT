# ERP WebGUI·SYSTEMGUI — 대화·자료 근거 목록

프로젝트: KBS ERP WebGUI·SYSTEMGUI 리팩토링 / 정리 기준일: 2026-10-08

이 문서는 접근 가능한 현재 대화 및 전달된 발췌의 **출처 색인과 선택적 재구성**이다. 전체 대화 원문 내보내기가 아니다. 대화 날짜가 보이지 않는 항목은 “날짜 미표시”로 둔다. 도구 내부 로그·서명 URL·인증값은 수록하지 않는다.

## 1. 실제 읽은 파일 근거

| ID | 출처 | 기준 시점·확인 수준 |
|---|---|---|
| S01 | [ITS_Chrome_v3_Report.md](ITS_Chrome_v3_Report.md) | 문서 작성일 2026-09-14. 전문 읽음. 구현·검증·제한·100개 파일 설명 |
| S02 | [ITS_Chrome_v3_Evidence.zip](../attachments/ITS_Chrome_v3_Evidence.zip) | original/baseline/modified 각 100개, manifest·diff·검증 코드/기록. 실제 확보·대조 |
| S02-V | [validation.json](v3_evidence/validation.json) | cases 합계 186. 모의 함수 테스트 기록 |
| S02-M | [markup_validation.json](v3_evidence/markup_validation.json), [inline_validation.json](v3_evidence/inline_validation.json) | HTML/CSS 구조·직렬화 및 인라인 구문 기록 |
| S02-I | [integration_validation.json](v3_evidence/integration_validation.json) | 최소 DOM 모형의 5개 시나리오 기록. 실제 브라우저 아님 |
| S02-D | [changes.diff](v3_evidence/changes.diff), [manifest.json](v3_evidence/manifest.json) | v3 직전 기준본 대비 33개 변경과 3개 버전 해시 |
| S03 | [SYSTEMGUI_Analysis_Report.md](SYSTEMGUI_Analysis_Report.md) | 2026-09-13. 전문 읽음. 14개 원본·2개 변경·221건 모의 검증 |
| S04 | [WEBGUI_Arrow_Error_Report.md](WEBGUI_Arrow_Error_Report.md) | 2026-09-13. 전문 읽음. 오류 진단·커서 단일 패치·25건 모의 검증 |
| S05 | [drive_inventory_2026-10-08.json](drive_inventory_2026-10-08.json) | 2026-10-08 직접 조회한 대상 100개 이름/크기/수정 시각. 메타데이터이며 내용 해시 아님 |
| S06 | ad119731-38e7-4cb7-b45c-a8a04b6183af.png | 2026-10-08 원본 열람. 저장 메타데이터 2026-09-13. 캡처 시각은 미확인. 식별자 노출 우려로 미포함 |
| S07 | [추출_검증결과.json](추출_검증결과.json) | 2026-10-08 추출 시 새로 수행한 CRC·해시·구성 대조. 기능 재검증 아님 |
| S08 | Drive contextmenubase.html 현재 본문 | 2026-10-08 읽음. 수정 시각 2026-09-14T01:03:35.271Z, 크기 736. 보관 원본과 읽은 텍스트 일치 여부는 S07에 기록 |

## 2. 대화 근거와 중요한 요구

| ID | 접근한 대화 위치·시점 | 요구·관찰·응답 내용 | 상태 해석 |
|---|---|---|---|
| C01 | 전달된 발췌 시작 부분, 지침 9~14 및 재업로드 요청. 날짜 미표시 | 최신 문법·전역·strict mode·프로토타입 일괄 변경 금지. JS 마크업·CSS 함께 분석. 업무/통신/배치/인터페이스 변경은 질문. 전체 파일·원본 구조·보고서 분리·실제/정적/미검증 구분 요구 | 초기 보수적 작업 기준. 앞부분 지침은 생략되어 전체 원문 확보 아님 |
| C02 | 전달된 발췌 msg_idx 10~20. 날짜 미표시 | 누락 JS 재업로드. assistant가 67개 중 CSS26·JS4 수정과 680건 모의 결과 보고. 사용자가 “적용 해보니 WEBGUI 동작이 이상은 없는거 같아”라고 피드백 | 해당 초기 버전의 사용자 일부 확인. 수치는 대화 보고값이며 초기 증빙 ZIP 재확보 못함 |
| C03 | msg_idx 20~25. 날짜 미표시 | 스크롤 끊김 개선 요청. JS4개 패치, CSS 유지, 휠 대기·이동량 유지, 916건 모의 검증 보고. 350/700ms 중복 예약 발견했으나 당시 미수정 | 초기 스크롤 패치와 후속 v3 타이머 수정은 서로 다른 단계 |
| C04 | msg_idx 26~29. 날짜 미표시 | /system/sl/script/its_utils.js 반복 요청 관찰. cache 200과 실제 다운로드 구분. 타이머가 반환값을 기다리는 시간인지 질문 | 대기시간은 콜백 실행 전 지연으로 해석. 설계 의도 자체는 추정 |
| C05 | msg_idx 30~36. 날짜 미표시 | Fetch/XHR 없음에도 Doc 요청 존재. menubase 보조 문서와 업무 문서 구분. 업무 POST HTML 158856바이트, 전체163.19ms, 응답대기85.68ms, 수신74.59ms로 판독 | 이번 추출에서 원 Network 이미지/측정 재확인 못함. 대화 판독 기록으로만 사용 |
| C06 | 현재 대화 SYSTEMGUI 추가 요청 | /system/sl JS·CSS도 기존 방식 리팩토링 요청 | 결과는 S03으로 실제 확인 |
| C07 | 현재 대화 콘솔 PNG 첨부 사용자 메시지 | “마우스 휠스크롤은 잘 되는데 스크롤 화살표를 클릭”할 때 오류. 수정 누락 가능성 제기 | 증상 보고. 원인이 AI 수정 누락이라는 확정은 아님. S04·S06으로 대조 |
| C08 | 현재 대화 강도 높은 통합 리팩토링 요청 | HTML 추가, Chrome 최적화 허용. “1. 업무 기능과 데이터 처리의 정확성, 2. 기존 시스템과의 호환성, 3. 화면 배치와 조작 방식 유지, 4. 디자인 및 가독성 개선, 5. 근거가 있는 성능 최적화” | 현재 v3 결정 기준. 모든 레거시 코드를 제거하라는 뜻 아님 |
| C09 | 현재 대화 contextmenubase 재동기화 요청 | 누락 확인 후 재동기화, 분석 범위 재포함 요구 | S01·S02·S08에서 원본736바이트와 v3 수정본891바이트 확인 |
| C10 | 현재 대화 추가 구조 개선 제안 요청 | 더 구조적으로 수정하고 싶은 부분을 정리해 달라는 요청 | 후속 제안 필요성. 본 추출의 제안 목록은 구현 완료로 표기하지 않음 |
| C11 | 현재 자료 추출 요청, 정리 기준일2026-10-08 | MD4개와 ZIP, 원본·교육·실습 분리, 상태·출처·누락 명시. 사이트·서버·GitHub push 금지 | 이번 수행 범위 |

## 3. 캡처의 안전한 문자 전사

S06에서 읽은 오류 문구만 옮겼다. 업무 문서 URL은 제외했다.

```text
[Violation] Permissions policy violation: unload is not allowed in this document.
Uncaught ReferenceError: gui_dropdownManager is not defined
  its_tablecontrolManager.init (gui_tablecontrol.js:186:22)
Uncaught TypeError: f.createTextRange is not a function
  webguiSetCursorPosition (gui_ts.js:360:13)
```

표시된 파일명과 확보 소스의 실제 함수 위치가 다르다는 사실을 지우지 않는다. `gui_ts.js`를 오류 수정 대상으로 단정하거나, unload 메시지가 나머지 오류를 유발했다고 설명하지 않는다.

## 4. 인용 규칙과 기존 보고서 사용법

- S01의 절은 원문에 굵은 제목으로 표시되어 있다. 예: “이전 오류와 이번 결과”, “통신·데이터 계약”, “검증 결과”, “적용·복원 및 실제 확인 항목”.
- S03·S04의 절 번호는 원문 그대로 인용한다.
- S02 내부 경로는 ZIP을 풀었을 때 기준이다. 예: `modified/WEBGUI/JS/gui_scroll.js`.
- 원문 보고서의 링크나 과거 문장을 현재 완료 상태로 자동 승격하지 않는다. 현재 요약은 01 문서의 상태표가 기준이다.
- 외부 API 설명 링크는 기존 보고서의 참고 자료다. 이번 추출에서 최신 브라우저 정책을 새로 조사·검증한 것은 아니다.
