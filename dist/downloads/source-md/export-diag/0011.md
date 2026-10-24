# DEVHUB 추출기 0.3.18 사용 안내

대상: SAP_BASIS 700 SP0041 Unicode / Windows 11 / SAP GUI 770.
추출기 0.3.18 · 오프라인 점검기 0.3.3 · manifest 형식 0.2.

## 적용

1. SAP에 한국어로 로그인하고 SE38의 Z_PACKAGE_EXPORT 전체 소스를 이번 ABAP로 교체한다.
2. SAP 문법검사·활성화 후 개발클래스(패키지)와 저장경로를 입력한다. 하위 패키지는 항상 포함한다.
3. 실행 화면 버전 0.3.18 및 시작 자체 점검을 확인한다.
4. 결과 ZIP은 새 폴더(예: C:/DEVHUB/ZWEB_0318)에 푼다. 기존 결과 위에 덮어 풀면 삭제한 XML과 이전 경로가 남는다.
5. 함께 제공한 DEVHUB_CHECK.html 0.3.3로 manifest.xml이 있는 결과 폴더를 점검한다. Python·PowerShell·Node 설치는 필요 없다.

## 입력 화면과 결과 ZIP — 0.3.18

| 화면 표시 | 기술 이름 | 동작 |
|---|---|---|
| 개발클래스(패키지) | S_PACK | 필수; 기존 EQ/BT/CP 선택, 선택한 루트와 그 하위 패키지 포함 |
| 저장경로 | P_FILE | 폴더 또는 ZIP 전체 경로 입력; F4 저장 대화상자 지원 |

S_TYPE/S_NAME과 해당 필터 분기를 제거했다. P_SUB는 X, P_MB는512으로 고정하고 화면에서 숨겼다. 이전 variant가 다른 값을 갖고 있어도 실행 시 위 값으로 설정한다. 예전 variant의 제거된 필드가 문제를 일으키면 두 입력으로 새 variant를 저장한다.

단일 루트 ZHR6을 선택하면 **ZHR6_export.zip**으로 저장한다. 하위 패키지 개수는 파일명에 붙이지 않는다. 여러 루트를 선택하면 중복 제거·이름순 정렬 후 `ZFI1_plus_1_export.zip`처럼 첫 이름과 추가 루트 수를 사용한다. /ABC/PKG 같은 이름의 파일명에 쓸 수 없는 문자는 기존 ~HH 규칙으로 이스케이프한다.

저장경로에 `C:/Export` 폴더 또는 `C:/Export/old.zip`을 입력해도 결과는 같은 폴더의 새 패키지 기반 이름으로 저장한다. ZIP 파일명은 사용자가 입력한 기존 basename을 사용하지 않는다. F4의 이름은 입력 전달 시점에 따라 임시값일 수 있으며 실행 시 실제 선택 루트로 확정한다. 최종 저장경로가255자를 넘으면 중단한다. 같은 결과 파일이 있으면 기존 덮어쓰기 확인을 유지한다.

**DEVHUB_0_3_18.zip은 도구 배포 파일**, **ZHR6_export.zip은 SAP에서 생성하는 결과 파일**이다. 이름 규칙을 혼동하지 않는다. 이 버전은 소스 자체에 한국어 화면 라벨 두 개를 포함하므로 UTF-8로 읽어 SAP에 붙여넣거나 업로드한다.

## 생략·참고 로그 정책 — 0.3.17

이 버전은 업무 맥락 분석용 자료 수집 범위에 맞춰 아래 두 경우만 생략한다. 정상 파일의 추출은 계속하며 해당 객체의 본문을 임의 복구하거나 성공으로 표시하지 않는다.

| 경우 | 객체 상태 | 처리 로그 |
|---|---|---|
| 등록된 SMIM의 GET_URL_FOR_IO 반환 실패 또는 빈 URL | SKIPPED | MIME_URL / WARNING: 객체 ID와 짧은 사유 한 줄 |
| DDIC 처리 중 CX_XSLT_SERIALIZATION_ERROR | SKIPPED | DDIC_XML / WARNING: 객체명과 예외 종류 한 줄 |
| 클래스 참조 | 클래스 본문 미추출 | BSP 클래스 참조 진단을 조회·기록하지 않음 |

점검기0.3.3은 **생략 객체 / 참고 로그**를 별도 표시한다. 두 오류는 SAP 실패 객체·오류 로그에서 제외하지만 미추출 사실은 catalog/objects.xml과 logs/processing.xml에 남는다. 기존 버전에서 이미 FAILED로 저장한 결과는 자동 재분류하지 않으므로, 새 정책 적용에는 재추출이 필요하다.

DDIC 예외는 예외 타입과 PREVIOUS 원인 체인으로 판별한다. 이름이 같아 보이는 임의 오류 문구를 기준으로 다른 오류까지 생략하지 않는다. 일반 DDIC 조회 실패, 다른 변환 예외, MIME 본문 읽기 실패, 권한 문제, 경로 충돌·용량·원본 무결성 오류는 기존 처리를 유지한다. 실제 API가 제공하는 예외 연결은 SAP 실행에서 확인해야 한다.

CLAS 본문은 같은 패키지·외부 패키지 모두 현재 미지원이다. BSP 애플리케이션 클래스와 페이지 IMPLCLASS를 따라 TADIR를 조회하고 web-assets.xml의 참조 진단에 추가하던 처리를 제거했다. 독립적으로 발견한 CLAS 객체는 카탈로그에 UNSUPPORTED로 남으며 개별 처리 로그는 없다. BSP의 Properties.xml 등에 이미 포함된 원래 클래스명은 보존한다. SMIM 등 클래스 이외의 외부 패키지 참조 정책은 유지한다.

SE16의 category S 메시지만으로 DDIC 구조가 손상됐다고 판단하지 않는다. 구조는 DB 행 조회 대상과 다르며, 정상 구조의 definition.xml 추출은 계속한다. 생략은 실제 지정한 직렬화 예외가 발생한 객체에만 적용한다. 특정 다섯 객체명을 하드코딩하지 않는다.

## 활성 소스 제외 정책 — 0.3.17

첫 `READ REPORT ... STATE 'A'`의 반환값이0이 아니면 해당 소스의 본문·텍스트·속성 추출을 생략하고 개별 실패 로그를 남기지 않는다. 프로그램 객체는 catalog/objects.xml에 EXCLUDED, 함수그룹 소유 Include는 Include/includes.xml에 EXCLUDED로 남긴다. 함수그룹 메인이 제외되면 그 메인에 연결된 함수 소스 API 읽기도 생략한다. 일부만 제외된 그룹은 남은 처리 결과를 유지하며 함수 디렉터리 등 목록 정보가 남을 수 있다.

읽기 실패를 곧바로 비활성이라고 판정하지 않는다. 사유는 `No readable active source; excluded by policy`이며 비활성 소스로 대체하지 않는다. 표시 권한 실패, 두 번째 읽기 실패·소스 변경, 메타데이터 읽기 실패는 계속 오류로 기록한다. 이 정책은 첫 READ REPORT 실패에 한정하며 DDIC/MIME 오류나 상태 U를 일괄 제외하는 기능은 아니다.

아래 경로의 `<패키지>`, `<객체명>`, `<그룹명>`, `<앱명>`은 실제 이름이다. 기존 FUGR/WAPA/PROG 분류 단계는 유지했다.

## Dictionary Object

| 대상 | 출력 경로 |
|---|---|
| DB 테이블 | packages/<패키지>/Dictionary Object/DBtable/<객체명>/definition.xml |
| 테이블 유형 | packages/<패키지>/Dictionary Object/TableType/<객체명>/definition.xml |
| 구조·Append 구조 | packages/<패키지>/Dictionary Object/Structures/<객체명>/definition.xml |
| 도메인 | packages/<패키지>/Dictionary Object/Domain/<객체명>/definition.xml |
| 데이터 요소 | packages/<패키지>/Dictionary Object/Data element/<객체명>/definition.xml |
| 그 밖의 지원 DDIC | packages/<패키지>/Dictionary Object/VIEW 또는 SHLP/<객체명>/definition.xml |

구조는 원래 TABL 객체로 읽던 대상이며 이제 활성 DD02V-TABCLASS의 INTTAB/APPEND를 Structures로 분류한다. TRANSP/POOL/CLUSTER는 DBtable이다. 이름의 접두어만으로 추측하지 않는다. 일반 활성 정의 조회 실패는 오류를 유지하고 비활성 정의로 바꾸지 않는다. 지정한 직렬화 예외만 위 정책에 따라 SKIPPED 처리한다. 업무 테이블 데이터는 추출하지 않는다.

## 함수그룹

기준 경로: `packages/<패키지>/function-groups/FUGR/<그룹명>/`

| 내용 | 기준 경로 아래 출력 |
|---|---|
| 함수 목록 | Function Module/directory.xml |
| 함수별 속성 | Function Module/<함수명>/Attributes.xml |
| 입력·출력·변경·테이블·예외 | 같은 함수 폴더의 Import.xml, Export.xml, Changing.xml, Tables.xml, Exception.xml |
| 함수 본문 | Function Module/<함수명>/Source code/<함수명>.abap |
| 그룹 메인·소유권 확인 Include | Include/<프로그램명>.abap |
| Include 읽기 결과 | Include/includes.xml |

`Inlcude`는 SAP 화면의 철자인 `Include`로 적용했다. 함수 소스는 각 함수명 폴더 아래에 별도의 Source code 폴더를 만들어 저장한다. Attributes.xml에는 함수명·그룹·개발클래스·메인 프로그램·RFC/Update/Global 값, TFDIR/ENLFDIR 정보, 한국어 우선·없으면 영어인 TFTIT/TLIBT 설명, 메인 프로그램 TRDIR 및 그룹 TADIR 정보를 담는다. 화면의 모든 표시 라벨을 재현한 파일은 아니며 원래 기술 필드와 원시 값을 보존한다.

각 매개변수 XML은 해당 API 테이블을 통째로 보존한다. Typing·참조 유형·기본값·Optional·Pass Value 등의 필드는 API가 반환한 그대로 남긴다. API DOCUMENTATION도 원래 식별자로 함께 저장한다. 탭에 항목이 없으면 빈 목록을 기록한다. 함수 API와 저장소 메타데이터의 활성 버전은 확인되지 않아 U를 유지한다.

function-read-api.xml, include-owner-api.xml, 함수별 short-text.KO.xml/source-rows.xml/interface.xml은 생성하지 않는다. 첫 활성 소스 읽기 실패에는 위 제외 정책을 적용하며 그 외 실제 읽기 오류 진단은 유지한다. 원본 함수의 영어 설명이나 코드 내용은 삭제·번역하지 않는다.

## MessageClass — 메시지 클래스

선택한 패키지의 R3TR MSAG 객체를 추출한다. 패키지명과 메시지 클래스명은 서로 달라도 된다.

출력 예: `packages/ZCO3/MessageClass/ZCO3/Messages.xml`

| XML 항목 | 의미 |
|---|---|
| MESSAGE_CLASS / DEVELOPMENT_CLASS | 메시지 클래스명 / 실제 소속 패키지 |
| REQUESTED_LANGUAGE | T002에서 조회한 한국어 내부 키 |
| MESSAGE_COUNT | 한국어 우선 선택 후 영어로 보완한 최종 메시지 수 |
| MESSAGES/item/MSGNR | 000, 001 등 세 자리 메시지 번호 |
| MESSAGES/item/TEXT | 치환 전 원래 메시지 문구 |
| MESSAGES/item/ARBGB, SPRSL | 원래 T100 클래스·언어 키 |
| LONG_TEXTS_INCLUDED | 공백: 별도 Long Text는 이번 추출 범위에 없음 |

T100A의 클래스 존재를 확인한 뒤 T100에서 해당 클래스의 한국어를 먼저 조회하고, 한국어 행이 없는 번호만 영어로 보완하여 번호순으로 정렬한다. 한국어 행이 있으면 문구가 공백이어도 그 행을 우선한다. 005·006처럼 등록되지 않은 번호는 새로 만들거나 재번호를 부여하지 않는다. `&`, `&1`~`&4`는 XML에서 `&amp;`로 표시되지만 XML을 읽은 값은 원문과 같다. 실제 사용자·금액·문서번호를 치환하지 않는다.

한국어·영어 모두 없으면 0건의 Messages.xml과 MSAG_SUMMARY 정보 로그를 남긴다. 영어 보완 건수는 LANGUAGE_FALLBACK 정보 로그에 남고 각 행의 SPRSL이 실제 언어를 나타낸다. 두 언어가 섞인 Messages.xml의 manifest LANGUAGE는 공백으로 두며 REQUESTED_LANGUAGE는 선호 언어인 한국어를 뜻한다. 등록된 클래스의 T100A 헤더가 없거나 조회/직렬화에 오류가 있으면 실패로 기록한다. 메시지 클래스명은 패키지의 TADIR 목록과 S_DEVELOP 표시 권한 검사로 제한하며, 코드에 참조된 외부 클래스까지 따라 읽지 않는다. 별도 유형 필터 없이 선택 패키지의 MSAG가 처리 대상이다.

Messages 탭의 짧은 문구가 대상이다. 별도 Long Text와 클래스 Attributes 탭 전체는 포함하지 않는다. 현재 T100 행을 읽으며 명시적인 STATE=A 읽기 API를 사용하지 않으므로 파일 상태 U, 객체 PARTIAL을 유지한다. 기존 파일 무결성 점검과 SAP 자체의 역변환 값 비교에 포함된다.

## BSP Application

기준 경로: `packages/<패키지>/BSP Application/WAPA/<앱명>/`

| 내용 | 기준 경로 아래 출력 |
|---|---|
| 페이지 목록 | pages/pages.xml |
| 페이지명·충돌 구분 대응표 | pages/page-paths.xml |
| 페이지 설정·속성 | pages/<페이지명>/Properties.xml, Page Attributes.xml |
| Layout | pages/<페이지명>/Layout/<원래파일명> |
| 이벤트·타입 | pages/<페이지명>/Event Handler/<실제이벤트명>.abap, Type Definitions.abap |
| MIME 실제 파일 | MIMEs/css/style.css, MIMEs/images/..., MIMEs/js/... 등 원래 하위 경로 |

application.xml(요청에서 applications.xml로 지칭), local-mimes.xml, navigation.xml, nodes.xml은 생성하지 않는다. MIME는 원래 SMIM 개별 폴더에 있던 본문을 앱 MIMEs 아래로 옮긴다. 추적용 SMIM 메타데이터는 0.3.18부터 해당 SMIM 소속 패키지의 MIME/metadata.xml 한 파일에 통합하며, 웹 목록도 이 공용 파일과 실제 콘텐츠 경로를 가리킨다. 파일이 있는 폴더는 ZIP 해제 시 그대로 생기며 빈 MIME 폴더는 폴더 메타데이터로 확인한다.

MIME 저장소를 재귀 조회하고 LOIO의 TADIR 소유권·선택 패키지·권한을 확인한다. 선택 범위 안의 등록된 SMIM만 본문을 읽고, 외부 패키지는 참조만 남긴다. 소유권을 확인할 수 없거나 초기 목록에 없던 파일은 미확인으로 기록한다. 등록 목록과 BSP 탐색에서 같은 LOIO를 만나도 중복 추출하지 않는다. 두 하위 폴더의 같은 파일명은 각각 유지한다. 경로 이탈과 남은 대소문자 충돌은 덮어쓰지 않는다.

## 독립 MIME와 통합 메타데이터 — 0.3.18

SMIM의 기존 `mime/SMIM/<LOIO>/content/<파일명>` 계층을 없애고 독립 파일을 `packages/<패키지>/MIME/<MIME 주유형>/<하위유형>/<파일명>`으로 저장한다. 예: `packages/ZWEB/MIME/image/png/login_bg.png`, `MIME/application/octet-stream/Pretendard-Regular.woff2`. `image/png`의 슬래시는 두 단계 폴더를 뜻한다.

폴더용 MIME 유형은 API가 반환한 MIME_TYPE에서 `; charset=...` 같은 매개변수를 제외하고 소문자로 정규화한다. 유형이 없거나 주유형/하위유형 형태가 아니면 application/octet-stream을 쓴다. 실제 MIME_TYPE 원문은 XML에 보존하고 확장자로 추측해 고치지 않는다. 경로에 사용할 수 없는 문자는 기존 안전한 이름 규칙으로 변환한다.

독립 파일은 원래 URL의 마지막 파일명을 사용한다. 같은 패키지·같은 유형 폴더에서 대소문자를 무시한 이름이 겹치면 먼저 기록한 파일은 원래 이름을 유지하고 이후 파일만 확장자 앞에 `~<전체 LOIO>`를 붙인다. 이름이나 크기가 같다는 이유로 서로 다른 객체의 본문을 합치거나 버리지 않는다. 등록 대상이 바뀌면 원래 이름을 차지하는 객체가 바뀔 수 있으므로 장기 대응은 LOIO와 metadata.xml을 기준으로 한다. 접미사 뒤에도 충돌하거나 기존 경로 제한을 넘으면 중단한다.

패키지마다 SMIM 파일·폴더 정보를 하나의 `MIME/metadata.xml`에 기록한다. DEVELOPMENT_CLASS와 ENTRIES에 객체 유형/이름·소속·LOIO·PHIO·원래 URL·폴더 여부·MIME_TYPE·요청/실제 언어·바이트 크기·최종 CONTENT_PATH·버전 상태·처리 상태/설명을 담는다. 패키지/LOIO순으로 정렬하고 기존 XML 들여쓰기·바이트 검증을 적용한다. 폴더는 IS_FOLDER=X, 본문 경로/PHIO가 비어 있을 수 있다. URL 실패로 생략한 객체는 본문·메타데이터 행을 만들지 않고 기존 카탈로그와 참고 로그에 남는다.

BSP 소속 MIME 본문은 **BSP Application/WAPA/<앱>/MIMEs/<원래 하위 경로>를 유지**한다. 그 파일과 폴더의 SMIM 메타데이터도 위 공용 파일에 통합한다. 선택한 하위 패키지가 여러 개면 각 소속 패키지에 별도 metadata.xml을 만들고, SMIM 기록이 없는 패키지에는 빈 파일을 만들지 않는다. web-assets.xml은 파일별 CONTENT_PATH와 공용 METADATA_PATH를 기록하며 점검기0.3.3이 이를 확인한다.

W3MI는 SMIM과 다른 기존 처리 경로다. 상위 폴더만 `MIME/W3MI/...`로 변경하고 객체별 파일·메타데이터는 유지한다. 이번 ZWEB 목록에는 W3MI가 없으며 이번 통합 대상은 SMIM이다.

## .devhub/baseline의 역할

이 폴더는 추출 당시 등록 콘텐츠의 원본 사본이다. 루트의 packages 및 일부 catalog 파일은 검토·편집할 작업본이고, baseline은 편집 뒤 원래 내용과 비교할 기준이다. 현재 점검기는 manifest의 BASELINE 경로로 사본을 읽어 최초 무결성과 변경 여부를 구분한다. 임의 삭제하면 원본 누락으로 점검이 실패한다. 중복은 의도된 것이며 이번 버전에서는 유지한다.

AI 업무 분석에는 루트 packages를 대상으로 하고 baseline은 색인에서 제외하면 된다. baseline까지 중복 학습시킬 필요는 없다. 현재 패키지만으로 오프라인 원본 비교를 해야 한다면 사본을 유지한다. 향후 Git의 최초 추출 commit/tag를 원본으로 쓰도록 점검·변경 비교·Import 입력을 함께 바꾸면 중복 사본을 없앨 수 있다. 이는 후속 설계안이며 이번 버전에 적용한 기능이 아니다. 해시만으로 변경 전 본문이나 세 방향 비교 기준을 복원할 수는 없다.

## 한국어 우선·영어 보완 정책

현재 기본값은 한국어 우선, 필요한 항목만 영어 보완이다. KO/EN의 실제 내부 키는 T002에서 조회한다. 한국어 키를 K·3으로, 영어 키를 E로 고정하지 않는다. EN 매핑이 없으면 영어 보완을 생략하고 한국어 처리를 계속한다.

| 대상 | 영어 보완 조건·단위 |
|---|---|
| MessageClass | 같은 클래스에서 한국어 행이 없는 메시지 번호만 영어로 채움. 한국어 행은 덮어쓰지 않음 |
| 프로그램·Include 텍스트 풀 | 한국어 텍스트 풀이 비어 있을 때 영어 텍스트 풀을 선택. 일부 키만 누락된 풀의 행별 병합은 하지 않음 |
| 함수 Attributes | 한국어 함수 설명(TFTIT)·그룹 설명(TLIBT)이 없으면 각각 영어 조회. 원본 SPRAS 보존 |
| DDIC | 한국어 활성 정의 조회가 실패하면 동일 객체의 활성 정의를 영어로 한 번 재시도. 성공한 한국어 정의 안의 빈 설명을 영어와 병합하지는 않음 |
| BSP | 한국어 페이지 목록 조회가 실패하거나 비면 영어 목록 재조회. 각 페이지는 다시 KO LOAD를 먼저 시도하고 LOAD 실패 때만 EN 재시도. 경로 계획 전에 언어를 확정 |
| MIME | 같은 LOIO의 KO 본문 조회가 실패하면 EN으로 재시도. API가 반환하는 KO·EN·언어 중립만 허용하고, 두 번 읽은 본문·언어·PHIO·MIME 유형이 일치해야 저장 |

LANGUAGE_RETRY는 재시도 사실이며 성공을 의미하지 않는다. LANGUAGE_FALLBACK은 영어 데이터를 채택했음을 뜻한다. 둘 다 INFO이고, 양쪽 조회 모두 실패하면 실제 실패를 유지한다. 권한·경로 충돌·소유권·바이트 불일치·XML 값 변경을 무시하거나 영어 처리로 우회하지 않는다. 영어를 사용하더라도 다른 패키지 객체를 따라 읽지 않는다.

언어 인자를 받지 않는 기존 함수 소스/문서 API를 위해 **SAP 로그인은 한국어로 유지**한다. 이 API의 개별 매개변수 설명 전체에 영어 대체가 적용되는 것은 아니다. BSP는 성공한 LOAD 이후 이벤트·레이아웃 실패를 페이지 전체 영어 재추출로 바꾸지 않는다. 페이지 경로 계획의 READ_LANGUAGE/READ_ISO와 BSP XML REQUESTED_LANGUAGE는 API에 전달한 조회 언어이며, API가 내부적으로 선택한 모든 설명 문구의 언어를 독립 검증한 값은 아니다.

생성 경로에 /KO/·/EN/ 또는 .KO·.EN을 추가하지 않는다. 실제 원본 이름에 들어 있는 언어 문자열은 보존한다. manifest에는 KOREAN_LANGUAGE_KEY, ENGLISH_LANGUAGE_KEY, LANGUAGE_POLICY=KO_FIRST_EN_FALLBACK을 기록하고 점검기0.3.3에 표시한다. 언어가 섞일 수 있는 함수 Attributes와 페이지 경로 대응표는 파일 단일 LANGUAGE를 공백으로 둔다. XML 안의 행별 언어·조회 언어와 로그로 확인한다.

## XML 자체 시험 수정 — 0.3.15

0.3.14의 `STOP: Raw XML round-trip changed values before formatting`는 정렬 전 원시 XML의 ID 역변환 검사에서 멈춘 것이다. 언어 조회 오류가 아니다. [SAP 공식 asXML 문서](https://help.sap.com/doc/abapdocu_750_index_htm/7.50/en-US/abenabap_xslt_asxml.htm)는 공백만 있는 문자열에 대해 기본 ID 변환이 대칭적이지 않다고 명시한다. 기존 자체 시험의 `STRING` 필드에 공백3개가 들어 있었으며, 이 경우까지 완전 왕복 변환을 요구한 검사 전제가 잘못되었다. 화면에는 어떤 필드가 달라졌는지 표시되지 않으므로 실제 차이 필드를 실행 증거로 특정한 것은 아니다.

0.3.15는 추출 단계에서 필요한 검증을 직접 수행한다. SAP가 생성한 원시 asXML과 들여쓰기가 적용된 XML에서 **모든 태그/속성 바이트와 리프 값 바이트가 동일한지** 비교한다. 구조 태그 사이의 들여쓰기 공백만 비교에서 제외하고, 리프 안의 공백만 있는 값·앞뒤 공백·줄바꿈·한국어·entity는 그대로 비교한다. 값 또는 태그가 달라지면 `XML_VERIFY`와 첫 차이의 비교 바이트 위치를 표시하고 ZIP 생성을 중단한다.

임의 STRING을 포함하는 BSP/함수 메타데이터에도 같은 방식을 적용했다. 메시지 클래스는 고정 길이 T100 필드를 사용하므로 기존 번호·문구의 타입 역변환 검사도 유지한다. 새 공통 바이트 비교는 메시지와 다른 모든 생성 XML에도 적용한다. RAW Layout/MIME 자산은 변환하지 않는다.

시작 시험은 두 가지를 분리한다. SAP가 실제 생성한 asXML은 정렬1회·2회 후 바이트 보존을 검사한다. 별도로 직접 구성한 `<R><V>   </V></R>`에서 공백3개가 정렬 뒤 유지되는지 검사하고, 그 공백을 없앤 XML을 주었을 때 검사기가 반드시 거부하는지도 확인한다. ID 변환을 공백 문자열의 원값 판정 기준으로 사용하지 않는다.

이 검사는 **직렬화된 asXML의 정렬 중 손상 방지**를 보증하는 범위다. SAP ID 직렬화 자체의 표현 규칙을 변경하거나 임의 ABAP 값의 완전한 가져오기를 보증하지 않는다. 향후 가져오기는 별도 대칭 변환 및 타입 검증이 필요하며 현재는 ANALYSIS_ONLY다. [SAP의 tt:copy 설명](https://help.sap.com/doc/abapdocu_750_index_htm/7.50/en-US/abenst_tt_copy.htm)이 해당 후속 설계의 참고다. 이번 수정은 별도 STRANS 객체 설치나 저장소 쓰기를 요구하지 않는다.

## 검증 범위와 한계

0.3.18 전체 소스의 v700 구문 분석과 기존 API 근거에 맞춘 타입 검사를 통과했다. 실제 SMIM 목록 1,510개의 식별자·URL·MIME 유형으로 경로/통합 루틴을 실행 검증했다. 독립 파일75개 중 충돌36개에 식별자를 붙이고 BSP 파일1,306개 경로를 유지했다. 별도 패키지 분리, 공용 메타데이터 참조, RAW 바이트용 Git 속성도 확인했다.

기존 점검기0.3.3은 새 구조의 테스트 콘텐츠3,897개 및 그 원본 사본을 모두 정상 비교했다. 본문은 합성 테스트 데이터이므로 실제 SAP 파일 추출·PHIO·직렬화 결과 검증과 구분한다. 상세는 DEVHUB_0_3_18_VALIDATION.md를 참고한다.

최신 실제 SAP 결과는 **0.3.17 ZWEB: 콘텐츠17,142 일치, 변경/파일실패/SAP 실패/오류/미확인 로그0, 생략19·참고19**이다. MIME URL14건·DDIC 직렬화5건이 의도한 생략 정책으로 처리됐다. 첨부 웹 목록2,766행은 직전 결과와 동일하다. 전체 ZIP을 직접 받아 재해시한 결과는 아니며 상세는 DEVHUB_ZWEB_0_3_17_REVIEW.md에 기록했다. 선택 폴더는473.966MiB였다.

0.3.18의 실제 SAP700 문법검사·활성화·재추출은 아직 수행하지 않았다. 이번 ZIP의 Z_PACKAGE_EXPORT.abap 전체를 교체·활성화한 뒤 **새 폴더**에 재추출하고 동봉 DEVHUB_CHECK.html0.3.3으로 점검한다. 객체 상태나 등록 목록이 바뀔 수 있으므로 이전 파일 수·생략19건의 재현을 보장하지 않는다.

PARTIAL / ANALYSIS_ONLY, 함수별 Source code, BSP 탭·MIMEs, KO 우선·부분 EN 보완, 개발클래스 범위·생략 로그 정책을 유지한다. 가져오기·저장·활성화·CTS 자동화는 미구현이다. 파일당16MiB, 비압축 ZIP512MiB, 내부 경로220자 제한을 유지하며 자동 분할은 없다. 통합 metadata.xml에도 같은 파일당 한도가 적용된다. GitHub·AI·Import 제안은 DEVHUB_GITHUB_AGENTS_IMPORT_PLAN.md에 정리했다. 클래스 확장에 관한 과거 제안보다 사용자가 정한 미추출 정책을 우선한다.
