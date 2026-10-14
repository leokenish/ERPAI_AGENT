# ERP WebGUI·SYSTEMGUI 리팩토링 — 자료목록과 보완사항

프로젝트: KBS ERP WebGUI·SYSTEMGUI HTML·JavaScript·CSS 리팩토링  
정리 기준일: **2026-10-08**  
범위: 실제 확보한 산출물과 현재 접근한 대화·Drive 목록. 다른 대화방 전체 목록이 아니다.

## A. 기존 자료 목록

### A.1 실제 확보·포함한 산출물

“본문 확인”은 전문 읽음, 핵심 소스/차이 읽음, 자동 바이트 검사, 메타데이터만 확인을 구분한다. ZIP 안100개 소스를 확보한 것과 모든 코드를 이번에 다시 정밀 감사한 것은 다르다.

| 파일명·형식 | 역할·주요 내용 | 최신 여부·판단 근거 | 실제 내용 확인 | ZIP 포함 | 교육 위치 |
|---|---|---|---|---|---|
| [ITS_Chrome_v3_Full.zip](attachments/ITS_Chrome_v3_Full.zip) | 전체100개 통합 수정 소스 | 2026-09-14 보고서와 Evidence modified 대응. 확보한 통합 기준 | 전체 바이트/구성·핵심 변경 검토 | attachments,원본 그대로 | 01 §10~11,02 실습A/B |
| [ITS_Chrome_v3_Apply.zip](attachments/ITS_Chrome_v3_Apply.zip) | baseline 대비 변경33개 | v3 변경분. baseline 일치가 사용 조건 | 구성·해시·Full 부분집합 대조 | attachments,원본 그대로 | 버전 혼용 방지 |
| [ITS_Chrome_v3_Rollback.zip](attachments/ITS_Chrome_v3_Rollback.zip) | v3 직전100개 | 실제 운영 백업 아님 | Evidence baseline과 바이트 대조 | attachments,원본 그대로 | 복원 기준 교육 |
| [ITS_Chrome_v3_Original.zip](attachments/ITS_Chrome_v3_Original.zip) | 최초 JS/CSS+재동기화 HTML 원본100개 | 확보 원본. 운영 최신본 아님 | Evidence original·Drive 크기 대조 | attachments,원본 그대로 | 변경 전후 분석 |
| [ITS_Chrome_v3_Evidence.zip](attachments/ITS_Chrome_v3_Evidence.zip) | 3개 소스 트리300개+증빙16개=316파일 | v3 최종 기록 | CRC·트리·manifest 확인,주요 검증/차이 읽음 | attachments,원본 그대로 | 실습B/E 재현 |
| [ITS_Chrome_v3_Report.md](references/ITS_Chrome_v3_Report.md) | 통합 변경·100개 파일·검증·한계 | 작성일2026-09-14 | 전문 | references,원본 그대로 | 상세 출처S01 |
| [SYSTEMGUI_Analysis_Report.md](references/SYSTEMGUI_Analysis_Report.md) | SYSTEM 1차14개·2개 변경·221건 모의 | 작성일2026-09-13. v3 이전 판단 | 전문 | references,원본 그대로 | 보수적→통합 변경 이유 |
| [WEBGUI_Arrow_Error_Report.md](references/WEBGUI_Arrow_Error_Report.md) | 콘솔 오류·원본 대조·커서 패치25건 | 작성일2026-09-13. v3 이전 국소 조치 | 전문 | references,원본 그대로 | 실패/미확정 원인 교육 |

기존 보고서는 수정하지 않았다. 그 안의 `sandbox:` 링크는 과거 위치이며 이식 가능 링크가 아니다. 위 표를 현재 상대경로 대응표로 사용한다. SYSTEM 1차 보고서의 “HTML 미제공”과 “UA 보존”은 당시 상태이며 현재 상태는 01 §10을 본다.

### A.2 코드·검증 상세 및 최신 원본 확인

| 파일·형식 | 역할 | 최신 판단·내용 확인 | ZIP 포함 | 교육 위치 |
|---|---|---|---|---|
| WEBGUI/JS 34개·CSS33개 | 컨트롤·메뉴·입력·스타일 | v3 Full+3트리 확보,전체 바이트 검사·핵심 변경 검토. Drive 현재67개 메타데이터 확인 | 기존 ZIP 안 전체 | 01 §4/11,02 실습 |
| SYSTEMGUI/JS13개·CSS1개·HTML19개 | 공통 함수·직렬화·보조 문서 | v3 Full+3트리 확보. Drive 현재33개 메타데이터 확인 | 기존 ZIP 안 전체 | HTML/JS/CSS 연계 |
| contextmenubase.html | 부모 메뉴 함수5개 인수 위임 | 현재 Drive 본문 읽음. 원본736/v3 891바이트. 동기화된 원본 포함 확인 | Original/Rollback/Evidence/Full/Apply의 각 버전 | 사례3 |
| [100개_소스목록.md](references/100개_소스목록.md) | 개별 경로·버전별 크기·변경 여부·확인 수준 | 이번에 manifest/Drive 목록에서 생성한 색인. 과거 원문 아님 | references | 통합 담당자 파일 색인 |
| [manifest.json](references/v3_evidence/manifest.json) | 100개 해시3종·크기·변경 이유 | Evidence에서 수정 없이 복사,현재 ZIP 바이트와 대조 | references 및 Evidence | 버전 추적 |
| [changes.diff](references/v3_evidence/changes.diff) | baseline→v3 전체 변경 | 실제 diff 읽음,원본 그대로 | references 및 Evidence | 변경 이유·리뷰 |
| [validation.json](references/v3_evidence/validation.json) | 186건 모의 회귀·구문·한계 | 결과 내용 확인. 이번에 회귀 재실행 안 함 | references 및 Evidence | 검증 수준 |
| [markup_validation.json](references/v3_evidence/markup_validation.json) | HTML19·CSS34·직렬화7건 | 결과 내용/구조 확인 | references 및 Evidence | 값·배치 계약 |
| [inline_validation.json](references/v3_evidence/inline_validation.json) | script30·이벤트66 구문 | 결과 확인 | references 및 Evidence | 인라인 코드 누락 방지 |
| [integration_validation.json](references/v3_evidence/integration_validation.json) | 최소 DOM 5개 시나리오 | 전문 확인. shmult 원본 실패/수정 성공 포함 | references 및 Evidence | 초기화·경로 |
| [zip_validation.json](references/v3_evidence/zip_validation.json) | 과거3개 ZIP 구성·해시 | 현재 파일 SHA와 대조 | references 및 Evidence | 과거 기록과 재확인 구분 |
| Evidence/verify.js·verify_markup.py·integration.js·analyze.js | 실제 과거 검사 코드 | 주요 코드/의존 경로 확인. 전체 코드 재감사 아님 | Evidence ZIP 내부만 | 실습E |
| [drive_inventory_2026-10-08.json](references/drive_inventory_2026-10-08.json) | 현재 원본100개 이름·크기·수정 시각 | 이번 직접 조회. 원격100개 전체 해시 아님 | references | 최신성 한계 |
| [추출_검증결과.json](references/추출_검증결과.json) | 이번 패키지 대조·원본 보존·자료 확인 | 이번 생성,과거 기능 검증과 별도 | references | 인수인계 |

이 교육 묶음의 examples/inspect_package.py와 examples/리뷰_프롬프트.md는 **이번에 만든 교육용 신규 자료**이며 기존 ERP 실행 파일에 포함되지 않는다.

### A.3 이름만 알거나 이번에 포함하지 않은 자료

| 파일명·형식 | 역할·알려진 내용 | 최신 여부·근거 | 실제 내용 확인 | ZIP 포함 | 교육 처리 |
|---|---|---|---|---|---|
| WEBGUI_Analysis_Report.md | 초기67개 개편 보고서 | 대화에 이름/결과 존재,정확한 파일명 검색으로 이번 미확보 | 이번 원문 미열람 | 아니오 | C02의 보고값으로만 사용 |
| WEBGUI_Scroll_Report.md | JS4개 스크롤 패치 보고서 | 대화에 이름/916건 보고,이번 미확보 | 원문 미열람 | 아니오 | C03·v3 baseline으로 연결 |
| WEBGUI_Optimized.zip / Original.zip / Review_Evidence.zip | 초기 개편·원본·증빙 | 대화상 파일명. v3 안 일부 계보 확인 | 해당 독립 ZIP은 이번 미확보 | 아니오 | v3와 별도 이력. 이름만으로 최신 판정 금지 |
| WEBGUI_Scroll_Patch.zip / Rollback.zip / Evidence.zip | 스크롤4개 패치·복원·증빙 | 대화상 파일명 | 해당 독립 ZIP 미확보 | 아니오 | 패치 내용을 v3와 혼용 금지 |
| WEBGUI_Cursor_Fix.zip / Cursor_Rollback.zip | gui.js 단일 패치 | S04에 설명. 후속 v3에 추가 보완 존재 | 해당 ZIP 미확보,보고서 읽음 | 아니오 | 과거 국소 조치 |
| SYSTEMGUI_Optimized.zip / Original.zip / Review_Evidence.zip | 14개 1차 결과 | S03에 설명,후속 v3가 통합 기준 | 해당 ZIP 미확보,보고서 읽음 | 아니오 | 과거 기준·검증221건은 보고서 기록 |
| ad119731-38e7-4cb7-b45c-a8a04b6183af.png | 실제 콘솔 오류 이미지 | 저장 메타데이터2026-09-13,촬영일 미확인 | 원본 열람 | 아니오 | 세션 식별자 같은URL조각 제외. 안전한 문자 전사 제공 |
| Network 캡처 여러 장 | Doc/JS/CSS·Headers/Timing/Initiator | 현재 대화에 과거 판독 내용. 개별 원본 파일명 미상 | 이번 이미지 원본 미확보 | 아니오 | 재캡처 요청. 수치는 대화 관찰로만 표시 |
| webgui-preview.html / webgui-preview.png / webgui-design.css | 초기 디자인 관련 후보 | 검색 메타데이터2026-09-12,생성 자료 표시 | 이름·메타데이터/검색 요약만. 본문·이미지 미열람 | 아니오 | 실제 ERP 화면/최종 소스로 사용하지 않음 |
| 오류 업무 Response HTML·운영 JS Response·ITSSM_unload | 원인 확정·세션 검증 핵심 | 제공 증거 없음 | 미확인 | 아니오 | 필수 보완 항목 |

미확보는 파일이 존재하지 않는다는 판정이 아니다. 이번 검색·접근 범위에서 읽지 못했다는 뜻이다.

## B. 실제 화면 캡처 요청 목록

제품 화면은 생성형 이미지로 대체하지 않는다. 주소·쿠키·토큰·개인정보·업무 식별자는 가리고, 필요한 필드/상태/시간은 남긴다. 전체 HAR를 기본 요구하지 않는다.

| 프로그램·구체 화면 | 반드시 보여야 할 요소 | 교육 내용 | 기존 이미지 활용 가능 | 추가 캡처 |
|---|---|---|---|---|
| Chrome DevTools Console,오류 직후 해당 iframe 컨텍스트 | 오류문구·함수·파일·행,컨텍스트 이름. 실제 세션URL 제외 | 증상과 실행 문서 구분,세 오류 독립 진단 | 기존 PNG는 열람했으나 그대로 배포 부적합 | 필요: 식별자 없는 원본 |
| Chrome Network,휠1회 Doc 목록 | 큰 업무Doc와menubase,Method/Status/Type/Size/Time/Initiator,캐시표시 | Fetch/XHR없이 서버 요청 존재 | 과거 판독 기록만 있음 | 필요 |
| 큰 업무Doc Headers·Timing | POST,Content-Type,본문크기,대기/수신/전체. 쿠키·URL토큰 가림 | 메뉴문서와업무문서,네트워크시간 한계 | 원본 미확보 | 필요 |
| gui_dropdown.js·gui_ts.js 요청 Response | 본문 시작·생성자/커서 함수 위치·MIME/상태·문서 연계 | 200 오류HTML,배포파일/이름 불일치 | 콘솔만으로 부족 | 필요 |
| 업무 HTML의 script 목록/프레임 트리 | src·순서·async/defer/type·부모/자식 관계 | 의존성·초기화 순서 | 보조HTML19개는 코드 예시만 가능 | 필요: 민감정보 제거한 구조 |
| 실제 ERP 대표 TC·ALV·트리 화면 | 헤더/고정열/선택/스크롤바,휠과화살표 위치,확대율 | 동기화·배치 유지 | 안전하게 재사용 가능한 실제화면 미확보 | 필요 |
| 드롭다운·검색 도움말·우클릭 메뉴·분할선 | 선택/취소/포커스/부모프레임,메뉴 제출 전후 | HTML·JS 연동,실패 후 정상요청 | 미확보 | 필요 |
| 테스트 입력창·IME·커서 화면/짧은 녹화 | 한글 조합Enter/일반Enter 구분,커서0·중간,입력유형 | 모형이 대체하지 못하는 실제 입력 검증 | 미확보 | 필요 |
| Chrome Performance 대표 기록 | 입력마커·요청·스크립트·레이아웃·표시,조건/버전 | 병목구간분리,반복측정 | 미확보 | 성능 교육 확정 전 필요 |
| 배포 담당자의 테스트 버전 확인 화면 | 경로·배포시각·해시/응답변경주석,비밀값제외 | Drive본/ZIP/운영본 구분·복원 | 미확보 | 운영 실습 추가 전 필요 |

## C. 새로 제작할 설명용 시각자료

아래는 제작 명세이며 **이번에 새 이미지를 생성하지 않았다**. 실제 제품 UI를 그럴듯하게 재현하는 그림과 구별한다.

| 자료 | 전달 목적 | 필수 요소·연결 | 적합한 표현 | 근거 절 |
|---|---|---|---|---|
| 문서·프레임·공통 자원 구성도 | 파일 목록이 아니라 실행 관계 이해 | 주업무문서,보조문서,두유틸리티,부모호출,서버응답;문서별전역 경계 | Mermaid,최종SVG | 01 §4~5 |
| 원본/기준본/v3 비교도 | Rollback과Original 혼동 방지 |100/100/100개,baseline→33변경,Apply조건,운영백업 별도 | 비교표 또는SVG | 01 §10 |
| 스크롤 관찰·모형 나란히 보기 | 실제POST와모의콜백 구분 | 관찰163.19ms는대화표본,모형350/700→700,미확인 연결선 | HTML 비교 또는SVG | 01 §5/13,02 사례1 |
| 메뉴 제출 상태 변화 | 실패후다음업무요청 오염 이유 | 기존폼→임시변경→성공정리/실패복원,부모함수5인수 | Mermaid 상태/흐름도 | 01 §5.3/14 |
| 데이터 직렬화 단계 | 문자열과실제필드값 차이 | 가상한글/따옴표/0/false→디코딩→HTML이스케이프→파싱값 | HTML 단계 전환·비교표 | 02 실습D |
| 오류 증거 매트릭스 | 원인 단정 방지 | 콘솔증상,제공파일,Response,컨텍스트,확정/가설 | HTML표 | 01 §14,02 실습C |
| 검증 수준 피라미드 대신 증거표 | 단순상하우열보다범위 이해 | 정적,모형,실제브라우저,업무수용 각각 가능한판정·불가능판정 | 비교표 | 01 §13,02 §11 |

색상은 보조 정보로만 사용하고 “미확인/모의/운영” 텍스트를 항상 병기한다. 운영 화면은 B의 실제 캡처를 사용한다.

## D. 포털 상호작용 아이디어 — 미구현 제안

| 기능 | 상호작용 | 학습에 도움이 되는 이유 | 콘텐츠 근거 |
|---|---|---|---|
| 구성요소 클릭 설명 | 메뉴문서/유틸리티/폼 클릭 시역할·파일·계약·미확인 표시 | 같은이름파일과프레임전역 구분 | 01 §4/11 |
| 버전 비교 탭 | Original/Baseline/v3 및Apply33개 필터 | 과거판단과현재변경 혼용방지 | 01 §9~10,S02manifest |
| 휠·화살표 비교 | 타이머모형 전후·요청관찰을별도탭으로 표시 | 콜백수와POST수 오해방지 | 02 사례1/2 |
| 실패 경로 단계 전환 | 메뉴제출 정상/예외 선택→폼필드복원 변화 | try/finally의업무의미 이해 | 02 실습D |
| 증거 수준 펼침 | 숫자186 옆 펼침에서범위·조건·못한검증 표시 | 숫자만으로운영완료 판단방지 | 01 §13 |
| 안전한 코드/명령 복사 | inspect명령,임시압축해제,리뷰프롬프트에복사버튼 | 경로오타감소. 운영반영명령과분리 | 02 실습A/B/E,examples |
| 실제/가상 표시 필터 | 캡처는실제,데이터값예시는가상,구조개선은제안 배지 | 출처·구현상태 혼동방지 | 전체 |
| 업무 유형별 회귀 탭 | TC·ALV·트리·검색도움말·메뉴·입력 항목 | 본인담당화면의필수검증 찾기 | 01 §13.2 |
| 보완사항 담당/상태 | 질문·이유·필수도·증거링크를읽기쉽게 표시 | 미확인항목의운영승격 방지 | E |

포털에는 실제 세션 쿠키를 입력하거나 업무 요청을 실행하는 시뮬레이터를 넣지 않는다. 첨부 ERP HTML은 샌드박스 없는 iframe으로 자동 실행하지 않고, 소스 표시/다운로드 자료로 취급하는 방향을 권한다. 이 기능들은 제안이며 이번 ZIP에 구현하지 않았다.

## E. 보완·확인 사항

| ID | 누락/미확인/미결정 | 필요한 질문·이유 | 통합 충돌 주의 | 우선도 |
|---|---|---|---|---|
| E01 | 실제 운영 배포본과 v3 일치 | 현재 서버 응답 파일·버전·백업을 받아야 잘못된 교체를 피함 | Drive 원본을 배포 최신본으로 표기하지 않기 | 운영 교육/적용 전 필수 |
| E02 | 오류 업무 Response HTML | 실제 script 순서·콜백·프레임을 봐야 dropdown 원인 확정 | shmult 모형 해결을 전체 오류 해결로 통합 금지 | 원인 확정 교육 전 필수 |
| E03 | gui_ts.js:360 불일치 | 실제 gui_ts/gui.js/dropdown Response가 무엇인지 | 파일명이 같아도 다른 서비스/캐시 버전 가능 | 수정 대상 결정 전 필수 |
| E04 | 정확한 SAP/ITS·Chrome 버전 | 지원 범위·기업 정책·프레임 보안 조건 확인 | 초기 IE 보존과 v3 Chrome 목표 구분 | 실행 실습 전 필수 |
| E05 | 실제 휠 경로·중복 POST | 호출 스택·업무 Doc 수·payload 위치 값을 민감정보 제거 후 확인 | 모형 2콜백을 POST 2회로 과장 금지 | 성능/중복 요청 결론 전 필수 |
| E06 | 실제 Chrome·IME·배치·저장 검증 | 승인된 테스트 화면/데이터와 수용 기준 필요 | 초기 사용자 확인≠v3 검증 | 운영 반영 전 필수 |
| E07 | ITSSM_unload·세션 종료 구현 | 로그아웃/종료/저장 의미와 현재 호출 경로 확인 | pagehide 일괄 치환 금지 | 세션 수정 전 필수 |
| E08 | IAC generator/splitter·이미지 | 실제 크기·스타일·보조 창 연동 확인 | 100개 전체=전체 시스템 소스 아님 | 해당 화면 검증 전 필수 |
| E09 | 성능 trace와 반복 비교 | 같은 환경·데이터·캐시 조건의 여러 표본 필요 | 단일 163ms·연산 횟수 감소≠개선율 | 성능 효과 발표 전 필수 |
| E10 | 초기 보고서/증빙 원문 | 초기 도안·680/916 검증 조건 보존을 위해 추가 확보 | 현재 자료는 대화 보고값임 | 추후 보완 가능 |
| E11 | 전체 대화 원문·정확한 날짜 | 발췌 앞부분/생략 구간을 보완하려면 정식 export 필요 | 보고서 작성일을 대화일로 대체 금지 | 이력 교육 정밀화 시 보완 |
| E12 | v3 후속 적용 피드백 | 누가 언제 어떤 버전으로 무엇을 확인했는지 | 사용자 무응답을 성공으로 표기 금지 | 운영 상태표 확정 전 필수 |
| E13 | 새 공통 계층/수명주기 설계 | 요청 종류별 계약·새 파일 허용·마이그레이션 범위 승인 필요 | 제안과 실제 구현 분리 | 후속 구조 개선 전 필수 |
| E14 | 소스 재배포·저장소 공개 범위 | SAP 저작권·사내 코드 권한·개인정보 심사 필요 | GitHub 공개 저장소로 자동 이전 금지 | 포털/GitHub 게시 전 필수 |
| E15 | 다른 ERP AI 프로젝트의 실제 상태 | 소스 추출/배포,MCP,Desktop,Obsidian,업무 스킬 자료 별도 확보 | 이 프로젝트의 미구현 범위를 외삽하지 않기 | 통합 커리큘럼 전 필수 |
| E16 | 교육 실습 환경 | Node24 내부 Acorn 경로 의존을 팀 환경에서 재현 가능한지 | Node 웹서버 구축과 혼동 금지 | 실습E 운영 전 필수 |
| E17 | 안전한 스크린샷 | URL 식별자·개인정보 없는 실제 캡처 요청 | 생성 화면을 운영 화면으로 표기 금지 | 화면 교육 전 필수 |

## F. 통합 담당자 인수인계

1. 이 최상위 폴더 이름을 유지해 다른 프로젝트 ZIP과 충돌을 피한다.
2. 교육 본문은 00→01→02→03으로 읽되, 포털 학습 순서는 02를 기준으로 재구성한다.
3. 원본 ZIP/기존 보고서는 수정 없이 보존하고, 교육용 편집은 별도 문서에서 한다.
4. 과거 보고서의 절대 링크 대신 현재 상대경로를 연결한다.
5. 원본/교육/실습/웹 구현을 통합 저장소에서 분리하는 정책은 다른 프로젝트 자료와 협의한다. 이번에는 저장소를 만들거나 push하지 않았다.
6. 이 묶음만으로도 설계·실패·제약은 설명할 수 있지만, E01~E09를 해결하지 않고 “운영 검증 완료” 강좌로 게시하지 않는다.
