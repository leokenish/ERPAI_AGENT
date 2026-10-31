# SAP export를 업무 근거로 읽는 방법

**현재 작업본에는 SRC-18 로컬 수정 2건이 포함된다.** `packages/`의 LZHR008_2F03·LZHR008_3F01은 사용자 요청으로 수정했으며 SAP 미반영 상태다. [변경 전 사본·패치·전후 해시와 적용 범위](../knowledge/code-map/local-20261022-overtime-attendance.md)를 먼저 확인한다. SRC-17 manifest·로그·baseline 및 추출 당시 해시는 수정 전 판본의 기록으로 보존한다.

이 안내는 이 프로젝트의 `DEVHUB_EXPORT_GUIDE.md` **추출기 0.3.18 설계/로컬 검증 자료**를 기준으로 정리했다. 업로드된 업무 문서가 실제 ZHR5 추출물의 객체 소유권이나 최신 동작을 입증하지는 않는다.
초기 지식 묶음에는 export가 포함되지 않았으나 현재는 `exports/ZHR5/`의 실제 추출본을 사용한다. 2026-10-22 KSP/300, 추출기 0.3.18, SAP_BASIS 700이 manifest에 기록돼 있다. [SRC-17 분석](../knowledge/code-map/export-20261022.md)과 [등록부](SOURCE_REGISTER.md#최신%20SAP%20추출본%20—%20SRC-17)를 최신 기준으로 읽는다.

## 출력 경로
`P = packages/<실제 개발클래스>`이며 `<...>`는 실제 이름으로 치환한다.

| 자료 | 추출 경로 | 분석 목적 |
|---|---|---|
| DB 정의 | P/Dictionary Object/DBtable/<객체>/definition.xml | 키·필드·타입·참조. 실제 업무 행 데이터는 없음 |
| 구조 | P/Dictionary Object/Structures/<객체>/definition.xml | 처리·화면·인터페이스 구조. DB 테이블로 단정하지 않음 |
| 테이블타입 | P/Dictionary Object/TableType/<객체>/definition.xml | 행 타입·테이블 종류·키 |
| 도메인·데이터요소 | P/Dictionary Object/Domain 또는 Data element/<객체>/definition.xml | 값 범위·기술 타입·설명 |
| 함수 본문 | P/function-groups/FUGR/<그룹>/Function Module/<함수>/Source code/<함수>.abap | 계산·분기·호출 |
| 함수 인터페이스 | 같은 함수 폴더/Attributes.xml, Import.xml, Export.xml, Changing.xml, Tables.xml, Exception.xml | 입력/출력 계약 |
| 그룹 Include | P/function-groups/FUGR/<그룹>/Include/<이름>.abap | 공통 변수·FORM·보조 코드 |
| BSP 페이지 | P/BSP Application/WAPA/<앱>/pages/<페이지 경로>/ | 사용자 화면과 이벤트 연결 |
| BSP 탭 | 위 폴더/Properties.xml, Page Attributes.xml, Layout/<원파일>, Event Handler/<이벤트>.abap, Type Definitions.abap | 설정/매개변수/화면/처리/타입 |
| BSP MIME | P/BSP Application/WAPA/<앱>/MIMEs/<원래 하위 경로> | 해당 앱 JS/CSS/이미지 등 |
| 독립 MIME | P/MIME/<주유형>/<하위유형>/<파일> | image/png 등 유형별 자산 |
| MIME 메타데이터 | P/MIME/metadata.xml | LOIO·원 URL·CONTENT_PATH로 파일 대응 |
| 메시지 | P/MessageClass/<클래스>/Messages.xml | 메시지 번호·문구·치환자 |
| 분류/처리 결과 | catalog/objects.xml, logs/processing.xml 등 실제 export의 목록 | 누락/생략/미지원 원인 확인 |

프로그램/독립 Include의 실제 경로는 기존 export의 카탈로그·manifest 및 `rg --files`로 찾는다. 존재하지 않는 경로를 예시에서 확정하지 않는다.

## 분석 때 유지할 제약
- 한국어 우선, 필요한 항목만 영어 보완. 파일·폴더에는 별도 KO/EN 수식을 붙이지 않는다. 원래 소스의 영어는 제거하지 않는다.
- 선택한 개발클래스와 포함 하위 패키지 범위. 외부 개발클래스를 따라 소스까지 자동 수집하지 않는다.
- CLAS 본문은 0.3.18 안내상 미지원이다. Properties에 클래스명이 있어도 클래스 구현이 함께 있다고 가정하지 않는다.
- 첫 활성 소스 읽기 실패는 제외될 수 있다. 특정 MIME URL 실패·DDIC 직렬화 예외는 SKIPPED로 남는다. 로그0이 모든 원본 객체 추출 완료를 뜻하지 않는다.
- 함수 API/메타데이터 등 활성 상태가 독립 확인되지 않은 U/PARTIAL이 존재한다. 전체를 완전한 활성본이라 단정하지 않는다.
- `.devhub/baseline`은 원본 비교용 사본이다. 현재 점검기에 필요하므로 삭제하지 말고 AI 검색에서 제외한다.
- XML은 구조/메타데이터이며 업무 데이터 덤프가 아니다. 구조를 SE16에서 DB 행으로 조회하지 못하는 것은 구조 손상의 근거가 아니다.
- `ANALYSIS_ONLY` 자료다. Import·활성화·CTS 자동 배포는 구현됐다고 가정하지 않는다.

## 실제 코드 연결 절차
1. `manifest.xml`의 추출 버전·일자·패키지 범위를 기록한다.
2. `knowledge/code-map/working-time.md`에서 질문 관련 이름만 고른다.
3. 작업본의 `packages/` 아래에서 파일/문자열을 검색한다. baseline을 중복 읽지 않는다.
4. 함수 본문과 인터페이스, 호출부, BSP 이벤트와 매개변수, DDIC를 필요한 만큼 연결한다.
5. 연결 장부에 실제 경로·commit·추출일·확인한 기능·미확인 의존성을 기록한다.
6. 현재 구현과 승인 정책이 다르면 둘을 나란히 보고한다. 코드를 정책의 승인 증거로 바꾸지 않는다.

0.3.18 안내의 로컬 검증과 이번 제공 export의 실행 로그를 구분한다. 2026-10-22 run 로그와 함수그룹/BSP 처리 기록은 확인했지만, DDIC 활성 읽기 FAILED 1건과 PARTIAL 범위를 유지한다. 추출 기록은 SAP 업무 실행·정책 승인·배포 검증이 아니다.

## 명시적으로 요청된 로컬 소스 반영

사용자가 특정 수정안의 원본 경로 반영을 요청한 경우 해당 로컬 파일만 수정한다. 변경 전 사본과 패치는 exports 밖에 보관하고 전후 해시·사용자 요청·대상 FORM·행·SAP 미검증 상태를 기록한다. 이 작업을 위해 manifest/CRC·catalog·로그·baseline을 재작성하지 않는다.

현재 승인 범위는 SRC-18의 두 Include 구간이다. 따라서 전체 추출 무결성 검사는 이 두 파일의 수정 전 체크섬과 다를 수 있다. 승인 목록 밖 차이는 별도 조사한다. 원래 추출본의 검증 결과와 현재 작업본 검증 결과를 혼용하지 않는다. 다음 교체 시 [유지보수 절차](KNOWLEDGE_MAINTENANCE.md)의 3개 판본 비교를 따른다.

## 2026-10-26 로컬 변경 롤백 이력

[관리자 통상 선택 시 저장 구분 보정](../knowledge/code-map/local-20261026-ordinary-save-gubun.md). 사용자 요청으로 SAVE_DATA 보정 블록을 롤백했다. MZH4110F01은 변경 전 사본과 바이트·해시가 일치하며 DB 반영은 다시 L2220이다. 이 기록은 적용·철회 이력이고 현재 활성 로컬 변경이 아니다. 후속 설계는 미구현, SAP 변경 없음.
