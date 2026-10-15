# 실제 대화를 따라가는 교육 과정

프로젝트: KBS ERP WebGUI·SYSTEMGUI AI 리팩토링 과정 / project_id: kbs-erp-webgui-refactor / 추출일: 2026-10-12

이 문서는 교육 해설이며 실제 발화는 conversation-data.json의 messages에 있다. 아래 프롬프트는 모두 **교육용 재작성 프롬프트**다. 원문에 없던 AI 답변을 만들지 않았다.

## 준비와 학습 경계

대상은 ERP UI 유지보수와 AI 변경 리뷰 담당 팀원이다. HTML/script/form, CSS 선택자, JS 함수·이벤트, ZIP·파일 경로의 기초가 필요하다. 기본 실습은 Python 3와 텍스트 편집기로 읽기 전용 수행한다. 기존 모의 회귀 재실행에는 Node 24/Python 3가 필요하며 실제 ERP를 대체하지 않는다.

스크롤·키보드·IME·저장·세션 종료의 실제 검증에는 승인된 테스트 ERP와 테스트 데이터가 필요하다. 사이트 구현·서버 설치·GitHub push는 이 실습에 포함하지 않는다.

## 단계 1. 빈 파일을 다시 확보하고 보존 기준을 세우기

### 1. 학습 목표

AI가 변경하기 전에 원본 완전성·인터페이스·지원 환경을 확인하는 이유를 설명한다.

### 2. 진입 전 상황·준비물

- 사용자가 제공한 WEBGUI JS/CSS 목록
- 초기 지침 조각; 지원 브라우저 범위는 당시 미정

### 3. 관련 실제 발화 ID

wg-m010, wg-m011, wg-m012, wg-m013, wg-m014, wg-m015, wg-m016, wg-m017, wg-m018, wg-m019

구성도 연결: sap, codex, diag

**교육 해설 — 실제 발화와 구분**

### 4. 사용자가 요구한 핵심

누락됐다고 한 JS를 다시 업로드했으니 확인 후 계속 진행해 달라는 요청이다. 요금제 변경과 계속 요청도 원문에서 삭제하지 않았다.

### 5. AI 대응과 결과물

AI는 ewtlib.js2979바이트·gui_popupresize.js13919바이트,JS34/CSS33을 확인했다고 보고했다. CSS26·JS4 수정,680건 모의 및 함수1303개 보존을 보고하고 전체·원본·증빙 ZIP을 제시했다.

### 6. 오류·오해·누락 또는 판단

파일명만 있고 내용이 비어 있으면 분석 완료가 아니다. 당시 Chrome의 IE 오분류를 발견했어도 영향 범위 때문에 보존했다. 이 단계의 검증 수치는 AI 당시 보고이며 독립 초기 Evidence ZIP도 최종 로컬 대조에서 확보했다. 이번에 기능 스위트를 다시 실행하지는 않았다.

### 7. 추가 설명·수정이 필요했던 이유

사용자가 원본을 보완했기 때문에 진행 가능해졌다. 지원 범위 미정 상태에서 무차별 문법/전역 변경을 피하려는 기준이 있었다.

### 8. 다음 단계로 넘어간 근거

wg-m019의 산출물 보고 후 사용자가 wg-m020에서 적용 경험과 다음 문제를 알려주었다. 무응답이 아니라 구체적 피드백으로 전환됐다.

### 9. 자기 업무로 따라 하기

**교육용 재작성 프롬프트**
```text
제공한 JS/CSS 목록과 실제 바이트를 대조해 빈 파일·누락을 먼저 표시해줘.
업무 기능, 데이터, 공개 함수, 배치와 기존 의존성을 우선 보존해줘.
확인하지 못한 부분은 보존하고 독립적으로 가능한 분석은 계속해줘.
```
현재 실습은 과거 초기 ZIP을 재생성하지 말고, 동봉 v3 Original/Full/Evidence의100개 구성과 해시를 대조한다. 이전 추출 폴더의 examples/inspect_package.py를 실행하면 된다. 이 스크립트는 ERP에 접속하지 않는다.

### 10. 결과 확인과 흔한 실패

Full/Original/Rollback 각각100개,Apply33개가 나와야 한다. 이름·크기 일치를 바이트 동일성 또는 운영 검증으로 과장하지 않는다.

### 11. 관련 캡처·코드·문서

- [initial_instruction_fragment.md](assets/source_notes/initial_instruction_fragment.md) · 전달된 과거 발췌 앞의 지침 조각. 역할/날짜/메시지 경계 미확인으로 messages에서 제외; 문구는 별도 보존.
- [ITS_Chrome_v3_Original.zip](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/attachments/ITS_Chrome_v3_Original.zip) · 제공된 JS/CSS 원본과 재동기화 HTML 원본100개. 운영 최신본이라고 단정하지 않음. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.
- [manifest.json](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/references/v3_evidence/manifest.json) · 100개 소스의3버전 SHA·크기·변경 이유. 원본 그대로. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.
- [inspect_package.py](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/examples/inspect_package.py) · 10-08 교육용으로 새로 작성한 읽기 전용 ZIP/해시 검사. ERP·브라우저 테스트 아님. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.
- [WEBGUI_Analysis_Report.md](assets/historical/WEBGUI_Analysis_Report.md) · 10-12 최종 로컬 대조에서 실제 확보한 당시 독립 산출물. 바이트를 그대로 복사했으며 v3와 구분한다. 당시 기능 검증 기록이지 이번 ERP 재실행 결과가 아니다.
- [WEBGUI_Review_Evidence.zip](assets/historical/WEBGUI_Review_Evidence.zip) · 10-12 최종 로컬 대조에서 실제 확보한 당시 독립 산출물. 바이트를 그대로 복사했으며 v3와 구분한다. 당시 기능 검증 기록이지 이번 ERP 재실행 결과가 아니다.

**결과와 확인 상태:** 초기 구현·680건은 당시 발화 및 확보한 보고서·Evidence 기록으로 확인한다. 이번에는 파일을 대조했으며 모의 기능 검증을 재실행하지 않았다. 사용자의 일부 확인을 v3 검증으로 확대하지 않는다.

## 단계 2. 사용자 실행 피드백으로 스크롤 문제를 분리하기

### 1. 학습 목표

기능 이상 없음이라는 피드백과 기존 성능 문제를 분리하고 변경 범위를 좁힌다.

### 2. 진입 전 상황·준비물

- 초기 수정본을 적용한 사용자 피드백
- 휠·화살표·표/트리 차이를 기록할 목록

### 3. 관련 실제 발화 ID

wg-m020, wg-m021, wg-m022, wg-m023, wg-m024, wg-m025

구성도 연결: sap, feedback, diag, codex

**교육 해설 — 실제 발화와 구분**

### 4. 사용자가 요구한 핵심

기존부터 끊기는 스크롤을 관련 JS/CSS만 수정해 개선해 달라고 했다.

### 5. AI 대응과 결과물

AI는 로컬/서버형 스크롤을 구분하고 gui_scroll/gui_gridview/columntree/searchhelpctrl의 반복 작업을 줄였다고 보고했다. CSS는 근거가 없어 유지했고916건 모의 결과를 제시했다.

### 6. 오류·오해·누락 또는 판단

내부350ms와외부700ms 예약 중복 가능성을 발견했지만 당시 요청 시점 변경은 보류했다. 이전 응답의 “수정 완료”는 이4개 국소 범위이며 모든 끊김 해결이 아니다.

### 7. 추가 설명·수정이 필요했던 이유

화면 작업 감소와 서버 요청 타이밍 변경은 위험이 다르다. 실제 요청 경로를 확인할 자료가 필요했다.

### 8. 다음 단계로 넘어간 근거

wg-m026에서 사용자가 다른 경로 its_utils.js 반복 로드를 관찰해 다음 분석 범위를 제공했다.

### 9. 자기 업무로 따라 하기

**교육용 재작성 프롬프트**
```text
스크롤의 로컬 렌더링과 서버 위치 전달 경로를 나눠 표시해줘.
동일 위치 재대입·반복 조회를 찾고, 요청 타이밍 변경은 별도 항목으로 설명해줘.
실제 측정값과 코드상 예상 효과를 구분해줘.
```
동봉 v3 diff에서 기존 스크롤 개선이 유지되는 위치와 v3 타이머 취소 변경을 구분해 표시한다. 과거4개 패치를 v3 위에 다시 덮어쓰지 않는다.

### 10. 결과 확인과 흔한 실패

설명서에 이전 단계의 미수정 타이머와 v3의 수정 타이머를 별도 버전으로 적는다.916건을 FPS/ERP 화면916개로 표현하면 실패다.

### 11. 관련 캡처·코드·문서

- [WEBGUI_Scroll_Patch.zip](assets/historical/WEBGUI_Scroll_Patch.zip) · 10-12 최종 로컬 대조에서 실제 확보한 당시 독립 산출물. 바이트를 그대로 복사했으며 v3와 구분한다. 당시 기능 검증 기록이지 이번 ERP 재실행 결과가 아니다.
- [WEBGUI_Scroll_Report.md](assets/historical/WEBGUI_Scroll_Report.md) · 10-12 최종 로컬 대조에서 실제 확보한 당시 독립 산출물. 바이트를 그대로 복사했으며 v3와 구분한다. 당시 기능 검증 기록이지 이번 ERP 재실행 결과가 아니다.
- [WEBGUI_Scroll_Evidence.zip](assets/historical/WEBGUI_Scroll_Evidence.zip) · 10-12 최종 로컬 대조에서 실제 확보한 당시 독립 산출물. 바이트를 그대로 복사했으며 v3와 구분한다. 당시 기능 검증 기록이지 이번 ERP 재실행 결과가 아니다.
- [changes.diff](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/references/v3_evidence/changes.diff) · v3 직전 기준본→v3 변경 전체 diff. 원본 그대로. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.
- [ITS_Chrome_v3_Report.md](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/references/ITS_Chrome_v3_Report.md) · 2026-09-14 최종 보고서. 당시 최종 대화 응답 원문이 없는 구간의 파일 근거다. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.

**결과와 확인 상태:** 4개 국소 패치·916건은 당시 보고서와 Evidence 기록으로 확인한다. 사용자의 초기 기능 확인은 제한적이며 실제 체감 개선·중복 POST는 미확인이다.

## 단계 3. 캐시 요청과 요청 전 타이머를 구분하기

### 1. 학습 목표

Network에 자원이 보인다는 사실에서 다운로드/서버 대기 원인을 성급히 확정하지 않는다.

### 2. 진입 전 상황·준비물

- Network Status/Type/Size/Initiator 관찰
- 휠1회 재현 조건; 대부분의 원 캡처는 식별자 때문에 배포 제외

### 3. 관련 실제 발화 ID

wg-m026, wg-m027, wg-m028, wg-m029

구성도 연결: sap, diag, feedback

**교육 해설 — 실제 발화와 구분**

### 4. 사용자가 요구한 핵심

SYSTEM 경로도 최적화하면 좋은지,350/700ms가 호출 리턴값을 기다리기 위한 강제 지연인지 물었다.

### 5. AI 대응과 결과물

AI는 캐시/304/실제전송을 구분하고 SYSTEM script전체·CSS·HTML·Network를 요청했다. 타이머는 콜백 실행 전 지연이며 서버 응답 대기와 별개라고 설명했다.

### 6. 오류·오해·누락 또는 판단

Network 목록 수를 다운로드 수나 업무 요청 중복 수로 세지 않는다. 타이머의 설계 의도는 추정임을 당시 응답도 표시했다.

### 7. 추가 설명·수정이 필요했던 이유

제어 흐름과 실제 통신을 연결하지 않으면 잘못된delay 단축으로 요청량만 늘릴 수 있다.

### 8. 다음 단계로 넘어간 근거

사용자가 이어서 Doc/Fetch/XHR를 나누어 캡처했고,Document 요청을 확인할 수 있었다.

### 9. 자기 업무로 따라 하기

**교육용 재작성 프롬프트**
```text
이 Network 자료에서 관찰된 사실과 원인 가설을 분리해줘.
캐시 표시,Doc 요청,타이머 예약,응답 대기 시간을 혼동하지 말고
다음에 필요한 최소 캡처를 특정해줘.
```
테스트 화면이 없다면 wg-m029의 네 구간을 분류하는 문서 실습만 한다. 실제 캡처가 없는데 캡처 화면을 생성해 대체하지 않는다.

### 10. 결과 확인과 흔한 실패

“700ms 기다리면 서버 응답이 완료된다”는 문장이 없어야 한다. 원 이미지 없이 판독을 재검증했다고 적지 않는다.

### 11. 관련 캡처·코드·문서

- 86ab3040-3eea-4fa2-9785-b71423f49d15.png — 미제공 · 10-12 실제 이미지 열람. URL의 세션 식별자·내부 주소가 표시되어 원본 배포 제외; path=null은 원본 부재가 아니라 제외를 뜻함. 대화 주제와 화면 내용으로 연결했으며 해당 발화 안의 이미지 순번은 원 플랫폼 메타데이터로 확정하지 못했다. 안전한 판독은 image_review.md 참조.
- a-business-response — 미제공 · 문제가 난 서버 생성 업무 Response HTML 원본 미확보. 보조 HTML19개와 다른 자료.
- [ITS_Chrome_v3_Report.md](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/references/ITS_Chrome_v3_Report.md) · 2026-09-14 최종 보고서. 당시 최종 대화 응답 원문이 없는 구간의 파일 근거다. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.
- [image_review.md](assets/source_notes/image_review.md) · 최종 대조에서 확보한 13개 Network 이미지의 판독·배포 제외 근거. 이전 10-08 요약의 미확보 표기를 갱신하는 새 근거.

**결과와 확인 상태:** 당시 캡처 판독과 해석을 보존. Network 이미지 원본은 최종 로컬 대조에서 확인했다. 정확한 호출 경로와 업무 HTML은 미확인이다.

## 단계 4. 잘못 선택한 메뉴 문서를 고쳐 실제 업무 POST를 확인하기

### 1. 학습 목표

자료 요청·잘못된 선택·정정·재캡처가 분석 결론을 바꾸는 과정을 재현한다.

### 2. 진입 전 상황·준비물

- 큰 업무 Document와menubase 구분
- Headers/Timing 확인 권한; 인증값은 공유하지 않음

### 3. 관련 실제 발화 ID

wg-m030, wg-m031, wg-m032, wg-m033, wg-m034, wg-m035, wg-m036

구성도 연결: sap, diag, feedback

**교육 해설 — 실제 발화와 구분**

### 4. 사용자가 요구한 핵심

Fetch/XHR가 없으니 리페인트처럼 보인다는 가설과 요청받은 document 캡처를 보냈다.

### 5. AI 대응과 결과물

AI는 Doc 요청을 지적했고, 처음 선택된 것은 menubase라고 바로잡았다. 올바른 업무 문서의 POST·HTML158856바이트·전체163.19ms를 판독했다.

### 6. 오류·오해·누락 또는 판단

메뉴GET678바이트1.93ms,업무표본149kB277ms,후속업무표본163.19ms는 같은 수치가 아니다. 정확한 업무 JS 호출 스택은 여전히 없었다. wg-m034의 식별자 접두부는 마스킹했다.

### 7. 추가 설명·수정이 필요했던 이유

어떤 항목을 선택했는지가 분석을 바꾼다. AI의 “큰 문서” 지시만으로 사용자가 정확히 선택했다고 가정할 수 없었다.

### 8. 다음 단계로 넘어간 근거

wg-m036에서 일반적인 네트워크 캡처 반복 대신 업무 Response HTML과SYSTEM script를 다음 자료로 지정했다.

### 9. 자기 업무로 따라 하기

**교육용 재작성 프롬프트**
```text
선택한 요청이 업무 문서인지 보조 메뉴 문서인지 먼저 확인해줘.
POST/GET,캐시,본문 크기,Timing의 의미를 분리하고,
이 자료로 확정 못하는 호출 스택·중복 제출은 미확인으로 남겨줘.
```
wg-m031/034/036의 세 표를 나란히 비교하여 표본·문서종류·확정/추정을 적는다. 실ERP에서는 승인된 테스트 화면의 업무 Doc만 다시 캡처한다.

### 10. 결과 확인과 흔한 실패

163.19ms에350/700ms를 기계적으로 합산하지 않는다. 응답대기를 순수ABAP시간으로 적지 않는다. 실제서버 요청을 없앴다는 결론도 금지한다.

### 11. 관련 캡처·코드·문서

- f888a2cb-5fa8-499a-9875-d8fc3bf0c844.png — 미제공 · 10-12 실제 이미지 열람. URL의 세션 식별자·내부 주소가 표시되어 원본 배포 제외; path=null은 원본 부재가 아니라 제외를 뜻함. 대화 주제와 화면 내용으로 연결했으며 해당 발화 안의 이미지 순번은 원 플랫폼 메타데이터로 확정하지 못했다. 안전한 판독은 image_review.md 참조.
- 4774516e-6a78-4f38-86e3-c6061282f7d4.png — 미제공 · 10-12 실제 이미지 열람. URL의 세션 식별자·내부 주소가 표시되어 원본 배포 제외; path=null은 원본 부재가 아니라 제외를 뜻함. 대화 주제와 화면 내용으로 연결했으며 해당 발화 안의 이미지 순번은 원 플랫폼 메타데이터로 확정하지 못했다. 안전한 판독은 image_review.md 참조.
- 29c78674-422b-4355-aa51-484d7b6c6d4e.png — 미제공 · 10-12 실제 이미지 열람. URL의 세션 식별자·내부 주소가 표시되어 원본 배포 제외; path=null은 원본 부재가 아니라 제외를 뜻함. 대화 주제와 화면 내용으로 연결했으며 해당 발화 안의 이미지 순번은 원 플랫폼 메타데이터로 확정하지 못했다. 안전한 판독은 image_review.md 참조.
- a-business-response — 미제공 · 문제가 난 서버 생성 업무 Response HTML 원본 미확보. 보조 HTML19개와 다른 자료.
- [ITS_Chrome_v3_Report.md](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/references/ITS_Chrome_v3_Report.md) · 2026-09-14 최종 보고서. 당시 최종 대화 응답 원문이 없는 구간의 파일 근거다. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.
- [image_review.md](assets/source_notes/image_review.md) · 최종 대조에서 확보한 13개 Network 이미지의 판독·배포 제외 근거. 이전 10-08 요약의 미확보 표기를 갱신하는 새 근거.
- [f48a0de8-7432-4aa0-a79a-990044a05d1f.png](assets/images/f48a0de8-7432-4aa0-a79a-990044a05d1f.png) · 10-12 실제 이미지 열람. Fetch/XHR 필터에 항목이 없는 화면 원본을 포함. 대화 주제와 화면 내용으로 연결했으며 해당 발화 안의 이미지 순번은 원 플랫폼 메타데이터로 확정하지 못했다. 안전한 판독은 image_review.md 참조.

**결과와 확인 상태:** 업무 POST와 HTML 응답은 당시 판독문 및 이번에 직접 열람한 이미지로 확인했다. 실제 요청 중복과 스크롤 핸들러 연결은 미확인이다. 원본 이미지는 식별자 때문에 대부분 배포 제외한다.

## 단계 5. 화살표 오류로 제공 소스와 배포 응답을 대조하기

### 1. 학습 목표

사용자 오류 제기를 방어하지 않고 코드·배포·실행 컨텍스트의 증거로 나눈다.

### 2. 진입 전 상황·준비물

- SYSTEM 소스 추가 요청
- 콘솔 오류·제공 JS·실제 Response 비교가 필요

### 3. 관련 실제 발화 ID

wg-m037, wg-m038

구성도 연결: sap, feedback, diag, codex

**교육 해설 — 실제 발화와 구분**

### 4. 사용자가 요구한 핵심

SYSTEMGUI도 같은 방식으로 리팩토링해 달라고 했고,이후 휠은 정상인데 화살표에서 오류가 나 수정 누락을 의심했다.

### 5. AI 대응과 결과물

해당 assistant 응답 원문은 현재 없다. 확보한 SYSTEM 보고서는14개 중2개 변경·221모의,오류 보고서는생성자 존재·gui_ts/gui.js불일치·커서 패치25모의를 기록한다. 보고서를 가짜 답변으로 만들지 않았다.

### 6. 오류·오해·누락 또는 판단

gui_dropdownManager는 제공 파일에 존재했다. createTextRange 경로는 모형 재현됐지만 실제 배포 응답 불일치는 남았다. unload 경고가 나머지 원인이라는 증거는 없다.

### 7. 추가 설명·수정이 필요했던 이유

사용자에게는 실제 고장이고,ZIP에선 누락이 없을 수 있다. 두 사실을 함께 인정하고 요청된 파일의 Response본문·문서script목록을 확보해야 한다.

### 8. 다음 단계로 넘어간 근거

사용자는 wg-m039에서 HTML까지 추가하고 Chrome 목표를 명확히 하며 국소 수정에서 통합 수정으로 범위를 바꿨다.

### 9. 자기 업무로 따라 하기

**교육용 재작성 프롬프트**
```text
휠은 정상이고 화살표 후 이 오류가 난다.
원본·이전수정본·실제JS Response를 비교해 누락/경로/순서/브라우저API를 나눠줘.
확인 전 빈 생성자나 오류 무시 코드로 덮지 말고 필요한 최소 자료를 알려줘.
```
동봉 오류 보고서의 gui_dropdown.js46453바이트/1825행,gui_ts.js3949바이트/126행,gui.js커서 위치를 원본과 대조한다. 실제 Response 미확보 칸은 빈 상태로 남긴다.

### 10. 결과 확인과 흔한 실패

운영 원인이 “파일 누락 확정”이나 “전부 해결”로 바뀌면 실패다. 이미지의 gui_ts 표기를 몰래gui.js로 정정하지 않는다.

### 11. 관련 캡처·코드·문서

- [SYSTEMGUI_Analysis_Report.md](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/references/SYSTEMGUI_Analysis_Report.md) · 2026-09-13 SYSTEM 1차 보고서.14개 중2개 수정,221건 모의 기록. 해당 assistant 응답 원문은 미확보. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.
- [WEBGUI_Arrow_Error_Report.md](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/references/WEBGUI_Arrow_Error_Report.md) · 2026-09-13 화살표 오류 진단/커서 국소 패치 보고서.25건 모의 기록. v3 전 단계. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.
- ad119731-38e7-4cb7-b45c-a8a04b6183af.png — 미제공 · 콘솔 이미지. 현재 대화에 표시되고 10-08 열람 기록이 있으나 세션 식별자 같은 URL조각 때문에 이 배포물에서 제외. unavailable은 배포 제외이며 원래 존재하지 않았다는 뜻이 아님. a-console-note에 안전한 문자 전사.
- [console_attachment_note.md](assets/source_notes/console_attachment_note.md) · 콘솔 오류 문자 전사 및 첨부 읽기 실패 표시. 업무 문서 URL은 제외했으며 마스킹 사유 기록.
- gui_ts.js — 미제공 · 오류 화면이 실제로 받은 JS Response 원본 미확보. 제공 소스의 동명 파일로 대체하지 않음. 런타임 버전 미확인.
- [ITS_Chrome_v3_Original.zip](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/attachments/ITS_Chrome_v3_Original.zip) · 제공된 JS/CSS 원본과 재동기화 HTML 원본100개. 운영 최신본이라고 단정하지 않음. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.
- [SYSTEMGUI_Optimized.zip](assets/historical/SYSTEMGUI_Optimized.zip) · 추가로 확보한 v3 이전 산출물. 실제 파일 그대로 보존. 해당 시점의 응답 원문은 미확보이므로 발화를 재생성하지 않는다.
- [SYSTEMGUI_Original.zip](assets/historical/SYSTEMGUI_Original.zip) · 추가로 확보한 v3 이전 산출물. 실제 파일 그대로 보존. 해당 시점의 응답 원문은 미확보이므로 발화를 재생성하지 않는다.
- [SYSTEMGUI_Review_Evidence.zip](assets/historical/SYSTEMGUI_Review_Evidence.zip) · 추가로 확보한 v3 이전 산출물. 실제 파일 그대로 보존. 해당 시점의 응답 원문은 미확보이므로 발화를 재생성하지 않는다.
- [WEBGUI_Cursor_Fix.zip](assets/historical/WEBGUI_Cursor_Fix.zip) · 추가로 확보한 v3 이전 산출물. 실제 파일 그대로 보존. 해당 시점의 응답 원문은 미확보이므로 발화를 재생성하지 않는다.
- [WEBGUI_Cursor_Rollback.zip](assets/historical/WEBGUI_Cursor_Rollback.zip) · 추가로 확보한 v3 이전 산출물. 실제 파일 그대로 보존. 해당 시점의 응답 원문은 미확보이므로 발화를 재생성하지 않는다.

**결과와 확인 상태:** 사용자 오류 보고는 실제 발화. 코드 결함 조치는 보고서·파일 근거. 원래 dropdown 운영 원인과실제화면 해결은 미확인.

## 단계 6. Chrome 우선순위와 새 HTML을 반영해 v3를 검토하기

### 1. 학습 목표

지원 범위 변경·추가 자료·재동기화를 변경 기준과 검증 계획에 반영한다.

### 2. 진입 전 상황·준비물

- Chrome 최적화 결정
- HTML 19개와 기존 WEBGUI/SYSTEM 기준본
- 업무·데이터 정확성 우선순위

### 3. 관련 실제 발화 ID

wg-m039, wg-m040

구성도 연결: sap, codex, diag, feedback

**교육 해설 — 실제 발화와 구분**

### 4. 사용자가 요구한 핵심

HTML·JS·CSS 구조 변경을 허용하되 업무 정확성, 시스템 호환성, 배치·조작, 가독성, 근거 있는 성능 순서를 지정했다. contextmenubase도 재동기화하여 포함하도록 했다.

### 5. AI 대응과 결과물

당시 답변 원문은 미확보다. v3 보고서와 소스에서 100개 중 33개(HTML 14·JS 16·CSS 3) 추가 변경, UA·커서·IME·폼 전송·메뉴 복원·타이머 처리를 확인한다. contextmenubase는 원본 736바이트, v3 891바이트다.

### 6. 오류·오해·누락 또는 판단

이전의 중복 예약 보류와 v3의 취소 처리는 서로 다른 버전이다. 기본 휠 delay 700은 유지됐다. shmult의 SL/sl 경로 수정은 모형에서 확인했으며 실제 오류 화면의 원인을 확정한 것은 아니다. 실제 Chrome 접근 제한으로 모형 검증만 남았다.

### 7. 추가 설명·수정이 필요했던 이유

HTML은 스크립트 로드와 부모 폼을 연결한다. CSS/JS만 보면 초기화 순서와 부모 콜백 계약을 놓친다. Chrome 중심 변경 허용도 업무 프로토콜을 임의 변경하라는 뜻은 아니다.

### 8. 다음 단계로 넘어간 근거

Full·Apply·Rollback·Original·Evidence 및 186건 모의 기록을 확보했다. 운영 성공 확인 대신 검토 가능한 파일과 남은 검증 목록이 있다.

### 9. 자기 업무로 따라 하기

**교육용 재작성 프롬프트**
```text
Chrome을 목표로 HTML·JS·CSS를 함께 분석해줘.
업무값과 요청 계약, 시스템 호환성, 배치·조작을 우선 보존해줘.
contextmenubase의 부모 함수 인수와 메뉴 제출 실패 후 복원을 확인해줘.
타이머 콜백 수와 실제 서버 요청 수를 구분해줘.
```
v3 Evidence를 새 작업 폴더에 풀고 baseline/modified의 framepost.html, contextmenubase.html, menu.js, gui_scroll.js를 비교한다. 0/false·한글·인코딩 실패·메뉴 예외의 계약을 적는다.

기존 모의 검증을 재실행하려면 Evidence README의 Node 24/Python 3 조건을 확인한 뒤 작업 사본에서 아래 명령을 사용한다. 결과 JSON을 다시 쓰므로 원본 ZIP은 보존한다. 이번 추출에서는 이 기능 스위트를 재실행하지 않았다.
```bash
node verify.js
python3 verify_markup.py
node integration.js
```

### 10. 결과 확인과 흔한 실패

저장된 기록의 186건 모의, HTML 19·CSS 34·JS 47, 인라인 30·이벤트 66과 비교한다. 실제 IME·배치·SAP 저장 결과는 테스트 ERP에서만 확인한다. 과거 국소 패치를 v3 위에 덮어쓰지 않는다.

### 11. 관련 캡처·코드·문서

- [ITS_Chrome_v3_Full.zip](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/attachments/ITS_Chrome_v3_Full.zip) · v3 전체100개 완전한 소스. 검토본이며 운영 검증 완료본 아님. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.
- [ITS_Chrome_v3_Apply.zip](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/attachments/ITS_Chrome_v3_Apply.zip) · v3 직전 기준본 대비33개 변경분. Full과 달리 독립 전체 배포본 아님. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.
- [ITS_Chrome_v3_Rollback.zip](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/attachments/ITS_Chrome_v3_Rollback.zip) · v3 직전 기준본100개. 실제 운영 서버에서 받은 백업 아님. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.
- [ITS_Chrome_v3_Original.zip](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/attachments/ITS_Chrome_v3_Original.zip) · 제공된 JS/CSS 원본과 재동기화 HTML 원본100개. 운영 최신본이라고 단정하지 않음. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.
- [ITS_Chrome_v3_Evidence.zip](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/attachments/ITS_Chrome_v3_Evidence.zip) · original/baseline/modified 각100개와 diff·해시·검증 프로그램/기록. 기록상186모의. 이번 기능 재실행 아님. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.
- [ITS_Chrome_v3_Report.md](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/references/ITS_Chrome_v3_Report.md) · 2026-09-14 최종 보고서. 당시 최종 대화 응답 원문이 없는 구간의 파일 근거다. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.
- [validation.json](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/references/v3_evidence/validation.json) · 186건 모의 결과 및 실제 Chrome/ERP 미실행 제한. 코드상 콜백2→1 기록. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.
- [integration_validation.json](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/references/v3_evidence/integration_validation.json) · 최소 DOM 모형5개 시나리오. shmult 경로 실패/수정 차이를 포함하며 실제 화면 아님. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.
- [changes.diff](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/references/v3_evidence/changes.diff) · v3 직전 기준본→v3 변경 전체 diff. 원본 그대로. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.
- [README.md](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/references/v3_evidence/README.md) · v3 검증 모형 실행 설명. 명령은 Evidence ZIP을 별도 폴더에 푼 후 수행. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.
- a-session-implementation — 미제공 · ITSSM_unload 및 서버 생성 종료 콜백 구현 미확보. 세션 전체 동작을 확인할 수 없음.

**결과와 확인 상태:** 구현 파일과 당시 검증 기록을 확보했다. 이번 재실행 또는 실제 Chrome·ERP 운영 검증은 아니다. 세션 전체 종료와 원래 오류 문서의 원인은 미확인이다.

## 단계 7. 구조 개선 제안을 구현과 구분해 후속 과제로 남기기

### 1. 학습 목표

더 강한 리팩토링 아이디어에 선행 자료·수용 기준을 붙이고 제안을 완료로 오인하지 않는다.

### 2. 진입 전 상황·준비물

- v3 검토본과 남은 한계
- 실제 업무 HTML과 요청별 계약은 일부 부족

### 3. 관련 실제 발화 ID

wg-m041

구성도 연결: codex, diag, feedback, knowledge

**교육 해설 — 실제 발화와 구분**

### 4. 사용자가 요구한 핵심

더 구조적으로 수정하고 싶거나 제안할 부분을 정리해 달라고 했다.

### 5. AI 대응과 결과물

답변 원문은 없다. 이전 맥락 문서 §17은 요청 계층, 수명주기, 중복 유틸리티, 의존성 명세, 렌더링 분리, 대표 화면 fixture를 제안으로 정리했다. 실제 발화를 복원한 것은 아니다.

### 6. 오류·오해·누락 또는 판단

함수 이름이 겹친다고 전역을 합치거나 iframe 간 초기화를 공유하면 안 된다. 완전한 연속 스크롤은 서버 계약에도 영향을 줄 수 있다.

### 7. 추가 설명·수정이 필요했던 이유

국소 모형은 운영 전체를 보장하지 않는다. 구조 변경 전 요청 종류별 계약과 대표 화면이 필요하다.

### 8. 다음 단계로 넘어간 근거

후속 구현과 운영 수용 증거가 없어 제안으로 남긴다. 다음 단계는 이 한계를 교육 자료에도 보존하는 것이다.

### 9. 자기 업무로 따라 하기

**교육용 재작성 프롬프트**
```text
구조 개선 항목을 제안·결정·구현·검증으로 분류해줘.
각 제안에 문제 근거, 업무 계약, 필요한 자료, 작은 검증 단계, 복원 기준을 붙여줘.
제안만 한 내용을 현재 구현된 아키텍처처럼 그리지 마.
```
대표 화면 확보 → 요청 계약 회귀 → 수명주기 → 중복 유틸리티 순서의 검토표를 만든다. 이번 실습에서 새 공통 모듈이나 서버를 구현하지 않는다.

### 10. 결과 확인과 흔한 실패

각 제안에 근거 파일과 미확인 칸이 있어야 한다. 이 프로젝트에서 MCP·워커·Telegram이 구축됐다고 설명하면 실패다.

### 11. 관련 캡처·코드·문서

- [01_프로젝트_맥락과설계.md](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/01_프로젝트_맥락과설계.md) · 이전 요약/설계 문서. 실제 발화 원문이 아니므로 messages의 복원 재료로 쓰지 않았다. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.
- [ITS_Chrome_v3_Report.md](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/references/ITS_Chrome_v3_Report.md) · 2026-09-14 최종 보고서. 당시 최종 대화 응답 원문이 없는 구간의 파일 근거다. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.
- a-business-response — 미제공 · 문제가 난 서버 생성 업무 Response HTML 원본 미확보. 보조 HTML19개와 다른 자료.

**결과와 확인 상태:** 구조 개선 요청은 실제 발화다. 상세 방안은 이전 요약 문서의 제안으로 확보했으며 후속 구현·승인·운영 완료는 미확인이다.

## 단계 8. 요약 자료를 대화·근거·실습이 연결된 교육 데이터로 바꾸기

### 1. 학습 목표

실제 발화와 요약의 차이를 보존하며 교육 포털이 읽을 수 있는 데이터를 구성한다.

### 2. 진입 전 상황·준비물

- 이전 교육 ZIP과 현재 보이는 발화
- 실제로 확인한 원문 확보 범위

### 3. 관련 실제 발화 ID

wg-m042, wg-m043, wg-m044, wg-m045, wg-m046, wg-m047, wg-m048, wg-m049, wg-m050

구성도 연결: knowledge, portal, diag, feedback, codex

**교육 해설 — 실제 발화와 구분**

### 4. 사용자가 요구한 핵심

첫 요청은 MD 4개와 관련 자료 추출이었다. 후속 요청은 실제 명령·응답·시행착오를 말풍선으로 표시하도록 MD·JSON·첨부를 연결하는 것이다.

### 5. AI 대응과 결과물

10-08에는 요약 MD와 기존 산출물 ZIP을 제공했다. 이번에는 확보된 41개 발화를 전사하고 원문이 없는 구간을 보고서 근거로 분리했다. 추출 중의 진행 안내와 반복 제출은 README의 추출 경계로 구분했다.

### 6. 오류·오해·누락 또는 판단

요약의 기술 설명을 AI 말풍선으로 바꾸면 가짜 대화가 된다. 추가 검색도 원문이 아닌 요약을 반환했으므로 별도 근거로 보존했다. 파일 미확보와 식별자 노출에 따른 제외를 구분한다.

### 7. 추가 설명·수정이 필요했던 이유

교육생은 완성된 정보뿐 아니라 어떤 요청을 하고 왜 고쳤는지 알아야 재현할 수 있다. 발화, 교육 해설, 재작성 프롬프트를 다른 필드에 둔다.

### 8. 다음 단계로 넘어간 근거

JSON의 ID·참조·첨부·순서와 ZIP 포함 검사를 validation-report.json에 기록한다. 포털 구현·서버 설치·GitHub push는 수행하지 않는다.

### 9. 자기 업무로 따라 하기

**교육용 재작성 프롬프트**
```text
실제로 보이는 사용자–AI 대화를 순서대로 보존해줘.
원문·발췌·요약, 구현·사용 보고·검증을 구분하고 없는 대화를 만들지 마.
교육 해설과 재작성 프롬프트를 별도 필드에 두고 첨부 경로와 발화 ID를 검증해줘.
```
JSON 파서로 conversation-data.json을 읽고 messages를 sequence 순서로 확인한다. episodes.message_refs를 따라 실제 말풍선과 해설을 분리한다. unavailable 첨부는 다운로드 버튼 대신 사유를 표시하도록 데이터 검토표를 작성한다. 웹사이트는 만들지 않는다.

### 10. 결과 확인과 흔한 실패

41개 중 핵심이 아닌 발화도 보존됐는지 확인한다. null 시각·마스킹 이유와 버전별 첨부를 확인한다. 원문이 없는 v3 답변을 새로 작성하면 실패다.

### 11. 관련 캡처·코드·문서

- [ERP_WebGUI_Refactoring_교육자료추출_2026-10-08.zip](assets/archives/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08.zip) · 10-08에 제공한 기존 교육자료 ZIP 원본. 이번에 다시 확보. 아래 previous_20261008에도 전부 풀어 상대경로를 보존했다. 대화 원문 export가 아니라 기존 요약 자료다.
- [00_README.md](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/00_README.md) · 이전 추출 범위·한계. 원문 그대로이며 10-08 확인을 10-12 확인으로 바꾸지 않았다. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.
- [conversation_transcript.md](assets/source_notes/conversation_transcript.md) · conversation-data.json의41개 발화를 읽기용 Markdown으로 렌더링. 원 플랫폼 전체 export가 아님.
- [retrieved_context_summary.md](assets/source_notes/retrieved_context_summary.md) · 10-12 추가 조회의 요약 근거. 실제 대화 원문 아님. 내부 호스트/트랜잭션은 마스킹. 원문처럼 messages로 복원하지 않음.
- [drive_inventory_2026-10-08.json](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/references/drive_inventory_2026-10-08.json) · 2026-10-08 Drive100개 메타데이터. 이번에 Drive를 재조회한 결과가 아님. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.
- [추출_검증결과.json](assets/previous_20261008/ERP_WebGUI_Refactoring_교육자료추출_2026-10-08/references/추출_검증결과.json) · 2026-10-08 패키지/바이트 검사. ERP 기능 검증과 별개. 관련 발화 연결은 교육용 주제 연결이며 그 요청 메시지에 실제 첨부되었다는 뜻은 아니다.

**결과와 확인 상태:** 이번 교육 추출의 완성은 패키지 검증으로 확인한다. 포털 배포·운영 승인·v3 ERP 성공을 의미하지 않는다.

## 운영 참고와 팀 피드백 갱신

팀원이 새 사례를 추가할 때 버전·실제 응답 해시·재현 조건·예상값과 실제값·정정 근거를 기록한다. 기존의 잘못된 발화는 그대로 두고 후속 해설에 수정 이유를 남긴다. 실제 Chrome/ERP 검증을 완료하기 전에 모의 통과를 운영 확인으로 승격하지 않는다.

확보된 최종 통합 기준은 v3 Full이다. Original은 제공 원본, Rollback은 v3 직전 기준본, Apply는 그 기준본 대비 33개 변경이다. 현재 운영 서버 백업을 대신하지 않는다.


## 2026-10-12 답변 전문 보완판 안내

이 문서의 기존 41개 발화 집계와 이전 추출 경계는 당시 기록이다. 이번 보완판은 기존 본문을 보존한 채 현재 직접 보이는 상태 문의 1개와 AI 진행 안내 4개·최종 답변 1개를 추가하여 47개 발화로 구성했다. wg-ep08에 wg-m051~056을 연결했다. SYSTEMGUI·화살표 오류·v3·구조 제안의 누락 AI 본문은 재조회에서도 찾지 못했다. 검색 요약을 원문처럼 추가하지 않았다.

현재 요청별 확보 상태는 [AI 답변 검토](AI_RESPONSES_FULL.md), [누락 목록](MISSING_RESPONSES.md), [변경 이력](CHANGELOG.md)과 [응답 연결 데이터](assets/answer_recovery/response-index.json)를 따른다. 기존 검증 수치는 이번 기능 재실행 결과가 아니다.
