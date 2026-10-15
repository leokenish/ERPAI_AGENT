# 실제 캡처 판독과 배포 범위

project_id: kbs-erp-webgui-refactor / 판독일: 2026-10-12

최종 로컬 대조에서 Network PNG 13개를 찾아 직접 열람했다. 이전 10-08 요약의 이미지 미확보 상태와 다르다. 원본은 수정하지 않았다. 파일명과 발화 연결은 화면 내용으로 판단했으며 원 플랫폼의 첨부 순번은 미확인이다. 파일명 전체는 conversation-data.json의 assets에 기록한다.

| 파일명 시작 | 관찰한 화면 | 안전한 판독 | ZIP 포함 |
|---|---|---|---|
| 86ab3040 | All 목록 | its_utils.js 등 memory cache·0ms, 메뉴 Initiator | 제외: URL 식별자 |
| f888a2cb | Doc 목록 | 업무 document 149kB·277ms, 메뉴 disk cache | 제외: URL 식별자 |
| f48a0de8 | Fetch/XHR | 필터 결과 목록 비어 있음. 서버 통신 전체가 없다는 뜻은 아님 | 원본 포함 |
| 7274ca73 | JS 목록 | 공통 JS memory cache, menubase 참조 | 제외: URL 식별자 |
| 5961dbdf | CSS 목록 | CSS memory cache | 제외: URL 식별자 |
| 4774516e | 메뉴 Headers | GET, disk cache, Content-Length 678, Server의 ABAP 700 표기 | 제외: 내부 주소·식별자 |
| 0ce5b8df | 메뉴 Request Headers | Chrome/Chromium 152, Windows, Referer의 jmprow=76.325 | 제외: 세션 경로 |
| db9b35d4 | 메뉴 Response | its_domain.js·its_utils.js, document.write로 메뉴 JS/CSS 참조 | 제외: 목록 식별자 |
| 5af08e2a | 메뉴 Timing | 전체 1.93ms, 대기 0.11ms | 제외: 목록 식별자 |
| 38bab0ed | 메뉴 Initiator | 상위 업무 문서 → menubase → 공통 및 메뉴 자원 | 제외: 세션 경로 |
| 29c78674 | 업무 Headers | POST, 200, HTML UTF-8, 158856바이트, ITS 721 표기 | 제외: 내부 주소·세션 경로 |
| 0c53e6a0 | 업무 Timing | 대기 85.68ms, 수신 74.59ms, 전체 163.19ms | 제외: 목록 식별자 |
| 4072490c | 업무 Initiator | 업무 문서 아래 여러 WEBGUI/SYSTEM 자원 | 제외: 세션 경로 |

배포 제외 이미지를 “원본 미확보”라고 부르지 않는다. 원본 재생성 이미지도 제공하지 않는다. 수치는 화면의 관찰값이며 이번 ERP 재측정 결과가 아니다. 제품 헤더 문자열로 SAP 전체 제품 버전이나 현재 운영 패치 수준을 확정하지 않는다.

콘솔 PNG `ad119731-38e7-4cb7-b45c-a8a04b6183af.png`는 별도 오류 전사에 연결한다. 화면 표시와 기존 열람 기록이 있으며 URL 식별자 때문에 배포 제외했다. [안전한 오류 전사](console_attachment_note.md)

교육용으로 추가 캡처할 때는 실제 제품 화면에서 세션 URL·Referer·쿠키·인증 헤더·내부 주소를 제거한 사본을 준비한다. Doc의 업무 요청과 메뉴 요청을 구분하고 Status·Type·Size·Timing·선택 항목이 보이게 한다. 전체 Response HTML은 아직 확보하지 못했다.
