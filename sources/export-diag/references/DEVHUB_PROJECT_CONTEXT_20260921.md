# DEVHUB 현재 기준 · AI 작업 재개 요약

기준일 2026-09-21. 과거의 KO 전용·옛 경로·선택 입력 정책과 클래스 확장 제안은 이 문서로 대체한다. 최신 후속 제안은 DEVHUB_GITHUB_AGENTS_IMPORT_PLAN.md, 이전 상세 맥락은 DEVHUB_EXPORT_IMPORT_HANDOFF_REPORT_20260920.md, 과거 이력은 DEVHUB_STATUS.md에서 필요한 부분만 읽는다.

## 목적·현재 단계

- SAP 개발클래스 → ZIP → 오프라인 점검 → VS Code/AI 분석·수정 → 향후 Z_PACKAGE_IMPORT의 변경검사·저장·활성화·CTS 연결.
- 현재 코드 Export0.3.18 / CHECK0.3.3 / manifest0.2, 전체 배포 DEVHUB_0_3_18.zip. SAP 실측 최신은0.3.17 ZWEB: 콘텐츠17,142 전부 일치, 파일/SAP 실패0, 생략19·참고19(MIME14/DDIC5). 0.3.18은 폴더 명칭·MIME 그룹/통합 메타데이터 수정본으로 로컬 검증 완료, 실제 SAP 활성화·실행 미확인. PARTIAL/ANALYSIS_ONLY이며 완전 복원용은 아니다.
- Import는 미구현. 사용자는 VS Code→GitHub 관리 및 FI/HR/MM 업무 맥락 에이전트를 지향한다. XML은 분석 참고로 보존하며 초기 자동 Import 제외를 제안했다. GitHub·AI·Import 자체 구현은 없음. 이번 baseline 질문에는 현행 점검에 필요한 원본 사본임을 설명하고 유지; Git 최초 commit 대체는 후속 제안이다.
- 대상 ECC6 / BASIS700 SP0041 Unicode / Oracle, 실제 검증 KSD/300. Windows11/SAP GUI770. 일반 사용자 PC에 Python·PowerShell·Node 설치를 요구하지 않는다.

## 반드시 유지할 결정

1. BASIS700 문법과 실제 시스템에서 확인한 API·타입 사용. 현대 문법이나 인터넷 API 이름을 확인 없이 적용하지 않는다. 파서 통과와 SAP 활성화 성공을 구분한다.
2. 선택 개발클래스만 추출. P_SUB=X로 고정하여 해당 하위 패키지 포함. 외부 소스·BSP·MIME는 본문 미추출, 참조만 가능. 범위 밖을 실패로 집계하지 않고 소속 미확인은 구분한다.
3. 실제 객체명·파일명 보존. 도구의 o_ 등 접두어와 자동 /KO/·/EN/·.KO·.EN은 없음. 원래 이름의 문자는 제거하지 않는다.
4. KO 우선·부분 EN 보완. T002로 키 조회(이번 실측 KO=3/EN=E). 한국어 로그인 유지. 원본 코드·영어 문구를 번역하지 않는다.
5. 생성 텍스트 UTF-8/LF, 원본 Layout/MIME는 RAW. 생성 XML만 들여쓰기. manifest 비교 정책과 .devhub/baseline 연결 유지. AI는 baseline을 중복 색인하지 않으며 삭제만 하면 현행 점검이 실패한다. Git 원본 commit 대체는 미구현.
6. Export는 읽기 전용. 사용자 요청에 따라 첫 READ REPORT STATE A 실패는 본문·개별 실패 로그에서 제외하고 EXCLUDED로 카탈로그에 남긴다. 실패 원인을 비활성으로 단정하지 않는다. 권한·재읽기·소스 변동·그 밖의 오류는 유지하며 비활성 소스 대체·자동 활성화는 하지 않는다.
7. 화면은 개발클래스(패키지)/저장경로만. S_TYPE/S_NAME 제거, P_SUB=X/P_MB=512 숨김·실행 시 고정. 결과는 ZHR6_export.zip; 복수 루트는 정렬상 첫이름_plus_추가수_export.zip. 저장경로에 기존 ZIP명을 넣어도 폴더만 유지하고 basename은 재계산.

8. 최신 사용자 결정: 등록 SMIM URL 실패와 DDIC CX_XSLT_SERIALIZATION_ERROR는 SKIPPED + WARNING 한 줄로 기록하고 진행한다. 원인 해결·성공으로 간주하지 않으며 다른 오류는 유지한다. DDIC 타입6종에서 PREVIOUS를 최대16단계 확인해 지정 예외만 판별한다.
9. 클래스 본문 미지원 유지. 공통 클래스가 반드시 업무 로직을 가진다고 전제하지 않는다. ZCL_APP_ZWEB_COMMON은 ZWEB 소속이지만 분석 범위상 미추출을 유지한다. BSP 앱 클래스 조회와 페이지 IMPLCLASS의 참조 로그를 제거해 같은 패키지/외부/생성 클래스 모두 개별 진단을 남기지 않는다. CLAS 루트는 카탈로그 UNSUPPORTED, Properties의 원래 클래스명은 보존. 클래스 이외 외부 패키지 참조는 유지.
10. SE16 category S는 구조와 DB 행 조회의 구분이며 구조 손상의 증거가 아니다. 정상 구조는 계속 추출하고 특정 이름으로 일괄 제외하지 않는다. 기존19건의 원인은 미해결이며 생략 정책으로 처리한다.

11. 0.3.18: DOMA→Domain, DTEL→Data element, mime→MIME. 독립 SMIM은 MIME/<주유형>/<하위유형>/<원래 파일명>, 충돌하는 후속 파일만 확장자 앞 ~전체LOIO. SMIM별 XML 대신 소속 패키지마다 MIME/metadata.xml 한 개. BSP MIMEs 본문 경로 유지, 그 메타데이터도 통합. W3MI는 대문자 상위 이름만 변경. 객체 식별은 경로가 아니라 LOIO/메타데이터로 한다.

언어 보완: 메시지는 KO에 없는 번호만, 텍스트 풀은 KO 풀이 비었을 때 전체 EN 풀, 함수 설명은 항목별 보완. DDIC/BSP/MIME는 정해진 조회 실패 조건에서만 재시도. 모든 빈 설명을 병합하지 않는다. 실제 채택은 LANGUAGE_FALLBACK, 재시도는 LANGUAGE_RETRY. 혼합 언어의 파일 단일 LANGUAGE가 공백일 수 있어 행별 언어·조회 메타데이터를 확인한다.

## 출력 계약

P=packages/<패키지>, F=P/function-groups/FUGR/<그룹>, B=P/BSP Application/WAPA/<앱>.

| 대상 | 현재 경로 |
|---|---|
| 프로그램 | P/programs/PROG 계층, 원래 이름 .abap·속성·텍스트 풀 |
| DDIC | P/Dictionary Object/{DBtable,Structures,TableType,Data element,Domain,VIEW,SHLP}/<이름>/definition.xml |
| 함수 | F/Function Module/<함수>/{Attributes,Import,Export,Changing,Tables,Exception}.xml |
| 함수 본문 | F/Function Module/<함수>/Source code/<함수>.abap |
| 그룹 Include·목록 | F/Include/<이름>.abap, Include/includes.xml, Function Module/directory.xml |
| BSP 페이지 | B/pages/<페이지명>/Properties.xml, Page Attributes.xml, Layout/<원래 파일명>, Event Handler/<실제 이벤트명>.abap, Type Definitions.abap |
| BSP 목록·MIME | B/pages/{pages,page-paths}.xml, B/MIMEs/<원래 하위 경로>; SMIM 메타데이터는 소속 패키지 MIME/metadata.xml |
| 독립 SMIM | P/MIME/<MIME 주유형>/<하위유형>/<파일명>; P/MIME/metadata.xml 통합 |
| W3MI | P/MIME/W3MI 계층의 원본 파일·메타데이터 |
| 메시지 | P/MessageClass/<클래스>/Messages.xml — 짧은 메시지, Long Text 미포함 |

구조는 TABCLASS INTTAB/APPEND로 분류. BSP 폴더는 페이지명 stem, 충돌은 페이지 키 기반 구분값과 대응표. 숫자 폴더·이벤트로 회귀하지 않는다. 삭제했던 중복 API/페이지 XML은 임의 복원하지 않는다. 함수 Source code는 함수마다 따로 둔다. Include 철자를 사용한다.

## 실제 검증과 해석

- 최신 ZWEB/0.3.17: 콘텐츠17,142 일치, 변경/파일실패/추가/고아0. 객체2,453 = PARTIAL2,364 + UNSUPPORTED68 + SKIPPED19 + EXCLUDED2. 첨부 TXT/processing/web-assets 검토이며 전체ZIP 본문 재해시·실행 시험은 하지 않았다.
- BSP32개 앱/1,256페이지, MIME파일1,381개, 폴더129개. 웹 완료2,637/자산 실패0. URL 조회 생략14건은 자산 등록 전 제외되어 웹 실패0과 별개다. DDIC 생략5건과 합쳐 참고19건. 파일명·실제 원인이 해결된 것은 아니다.
- 첨부 웹 자산2,766행은0.3.16 목록과 동일하다. 웹 참조는 외부9(WAPA2/SMIM7)만 유지; 이전 클래스 IN_SCOPE_UNSUPPORTED27/OWNER_UNRESOLVED1,256 진단이 사라져 요청 정책 적용 확인. 참조 감소를 의존성 해결로 판단하지 않는다.
- 외부9건은 ZMOBILE/ZBUDGET/ZHR1/ZEP1 MIME·부모 BSP 관계. EXCLUDED2는 외부 부모 ZMOBILE_PUBLIC MIME로 비활성 프로그램2개가 아니다. 나머지7건은 BSP MIME 트리 외부 자산. ZWEB 단독 실행 번들 아님.
- 함수그룹25, 함수784(SOURCE404/NEW_SOURCE380), 소유 Include872 완료·실패0. 메시지 ZWEB_MESSAGE_WF18개 완료 로그. A7,789/U9,353; U는 활성 여부 미확인, 비활성 확정이 아님. 파일 일치는 완전 정의·활성화·복원 검증이 아니다.
- 미지원68: SICF32/TOBJ13/NROB6/TRAN6/CLAS4, AUTH/DEVC/ENHO/ENQU/PARA/SOTR/SUSO 각1. 공통 클래스/SICF 확대는 사용자 요청으로 보류. 원래 BSP Properties의 클래스명은 보존하되 본문 없는 기능 추정 금지.
- KO/EN 정책 적용됐으나 ZWEB·ZCO3 실제 LANGUAGE_RETRY/FALLBACK 로그0. 실제 EN 채택, Messages.xml/SE91 개별 번호·문구 대조 미실시.
- 0.3.18 경로 시험: SMIM1,510개 중 본문1,381(독립75/BSP1,306) + 폴더129. 독립 유형 octet-stream61/png2/svg+xml5/css3/jpeg4. 동일 이름 글꼴18묶음×3개 때문에 후속36개에 LOIO 접미사. 본문이 같다는 이유로 중복 제거하지 않음. 등록/다른 출력이 같다면 통합으로 콘텐츠15,633/전체31,275파일 예상; SAP 실측 아님.
- 직전 ZCO3/0.3.15: 콘텐츠4,285 일치, 객체1,379=PARTIAL1,228/UNSUPPORTED148/FAILED3. 함수121/Include227/메시지35/웹122 완료. 실패 PROG ZBDCCO_KS02_1, ZFM00000, ZRPTCB5420은 첫 READ REPORT 실패로0.3.16 제외 정책 대상이나 ZCO3 재실행 미확인. 미지원 TRAN118/TOBJ18/CLAS2/기타10. 상세는 별도 ZCO3 보고서.
- 과거: ZHR5/0.2.4 콘텐츠2306/실패객체1, ZBUDGET/0.3.6 콘텐츠2478/실패0, ZMM6/0.3.11 콘텐츠453/실패1. 버전·언어·XML 구성 차이로 파일 수를 직접 비교하지 않는다.

## 재발 방지·미해결

- 비압축 ZIP 예산은 콘텐츠와 .devhub/baseline을 모두 합산한다. P_MB 기본값 및 재설정2곳/생성 README512, 점검기 MAX_ALL512MiB. 최신 ZWEB 결과496,989,503바이트(473.966MiB), 512MiB까지 여유38.034MiB로 완료. 글꼴108개+PDF82개가 사본 포함300.112MiB. ZIP 압축 크기/SAP 메모리와 다르다. 추가 대용량은 독립 분할 ZIP 설계를 권장하나 미구현. 바이너리·baseline은 AI 본문 색인에서 제외하되 export에서 임의 삭제 금지.
- 사용자 SAP 활성화에서 AS CHECKBOX + NO-DISPLAY 동시 선언 오류 확인. P_SUB를 TYPE c LENGTH 1 DEFAULT X NO-DISPLAY로 수정. 기존 v700 파서가 이 조합을 잡지 못해 별도 금지 검사 추가. 이후 시작 검사 통과 및 최신 ZWEB 추출 완료로 수정 효과 확인.
- ZWEB MIME14건: GET_URL_FOR_IO 실패/빈URL→web_fail→RETURN이 web_init/자산 등록보다 앞서 웹 실패0 표시. 0.3.17부터 이 경우 SKIPPED + MIME_URL/WARNING으로 기록하며 점검기에 생략 객체/참고 로그 별도 표시. 실패 자산으로 새로 등록하지 않는다. 실패 LOIO 목록은 ZWEB 보고서. 파일명·부모·실제 원인은 미확인; URL 없이 소유 경계를 우회해 추출하지 않는다.
- ZWEB TABL5건: ZHRT004V, ZSPS_PRPS, ZTRIP_ZHRT001, ZTRIP_ZHRT003, ZTRIP_ZHRT004에 CX_XSLT_SERIALIZATION_ERROR. DDIC_READ 단계가 API와 CALL TRANSFORMATION ID를 함께 감싸 정확한 발생 지점 미확정. 사용자가 상세 원인 보완을 보류해0.3.17부터 지정 예외를 SKIPPED + DDIC_XML/WARNING으로 기록한다. KO 문제·비활성·구조의 실제 오류로 단정하거나 데이터를 임의 치환하지 않는다. READ REPORT 제외 정책과 무관.
- SORTED 타입 LT_EVENTS/LT_PAGES에 SORT 금지. XSTRLEN 호출식 반복 횟수는 정수 변수로 분리. NORMAL 명명 인자 오류 수정 유지. ZIP 한글명 보존·대소문자 충돌·경로 제한 유지.
- 0.3.15는 기본 ID 변환의 공백만 있는 STRING 완전 왕복 가정을 제거했다. 원시 asXML→정렬본의 태그/속성·리프 바이트 비교로 변경했고 실제 ZCO3가 시작 검사를 통과했다. 임의 ABAP 값의 완전 import 보증은 아니다.
- ZMM6 SMIM 4F03B526A6651A37E10000000A002438 URL 실패. ZFI1 한글56건 전체 재검증, PROG MZF024I01/MZF024O01/ZSAPMF05B/ZSAPMF05B1 및 ZTFIC0000 읽기 실패 미해결.
- ZFI1 빈 함수 디렉터리6그룹: ZF04/ZF06/ZF07/ZF22/ZFFI_ZTFI019/ZFI_GET_SPONSORSHIP_LIST. 메인·Include 부재로 단정 금지. ZHR5 ZHCMT_BSP_PA_XX_R9023 활성 정의 실패도 별도 잔존.
- 0.3.16 제외 정책은 PROG/소유 Include/함수그룹 메인의 첫 READ REPORT 실패에만 적용한다. 제외된 메인 연결 함수 API 읽기도 생략한다. DDIC/MIME·빈 함수 디렉터리의 다른 문제를 해결한 것은 아니다.
- 다른 패키지 성공으로 위 문제 해결을 선언하지 않는다. MIME14·DDIC5 원인 진단 확대와 공통 클래스/SICF 추출 확대는 이번 범위에서 보류한다. 두 오류의 생략 참고 로그와 클래스 진단 제외가 최신 합의다. 별개 과거 오류가 읽기 전용 preview 개발 전체를 막지는 않는다.

## 다음 단계 제안 — 아직 미구현

- GitHub는 추출 파일 단위 관리+원본 commit/tag·baseline 보관. CI는 변경 범위·700 구문·정적 검사·검토용 묶음. DEVHUB는 abapGit 형식이 아니므로 abaplint 연동 adapter/검사 범위를 명시한다. 초기 CD는 SAP 자동 배포가 아닌 승인된 변경 전달이다.
- AI는 공통 모델+패키지별 지침/검색/권한. 파일·객체·commit 근거, 확인/추론 구분, 변경 객체만 재색인, 관련 업무만 협업. XML은 유용한 문맥이며 누락 클래스·화면·외부 의존성과 업무 규칙을 보완한다.
- Import 1단계: ZIP/대상·패키지·타입·언어 검사 + diff + 추출원본(B)/로컬(L)/현재SAP(S) 비교. 저장·활성화·CTS 변경 없는 preview부터.
- L=B는 미변경; S=L은 이미 반영; L≠B/S=B는 후보; 양쪽 변경·불일치는 충돌. 적용 직전 잠금·재읽기와 다른 개발자 비활성 작업 확인.
- 초기에는 Preview 후 기존 SE80/SE38 적용 절차를 이용한다. 향후 첫 자동 쓰기 범위는 활성 원본 확인된 기존 PROG/검증된 Include 본문 수정 권장. 생성·삭제·이름 변경·패키지 이동·DDIC/속성/함수 인터페이스 XML은 초기 자동 반영 제외. BSP·함수·MIME는 확장자가 아닌 객체별 API로 별도 검증. 파일 누락≠삭제 지시.
- 파일별 편집 가능/참고/생성물 구분, 안정적 객체 키·부모·언어·버전·원본 매핑 필요. 함수 .abap와 그룹 Include 중복은 단일 기준을 정하고 상충 시 중단.
- U 파일은 자동 반영 대상 아님. EN 보완 문구를 KO로 쓰지 않음. 미지원 외부 의존성은 대상 SAP에서 존재 확인만 하고 자동 수정하지 않음.
- 저장·구문검사·활성화·CTS·재읽기·복구를 구분. API의700 지원·비활성 저장·내부COMMIT·잠금·CTS는 개발계에서 검증. 직접 저장소 테이블 갱신 금지. ROLLBACK 하나로 전체 복구 보장 금지.
- ZIP 경로 이탈/중복/크기, XML 외부 자원·타입, 권한, 대상 시스템, 원본 신뢰성 검사. 객체별 복구 원본과 재실행 상태 기록. 전체 ZIP/SAP 구조를 그대로 복원한다고 약속하지 않음.

## 근거·재개 방법

최신 결과: DEVHUB_ZWEB_0_3_17_REVIEW.md 및 DEVHUB_check_result(20260921-004714).txt / processing(20260921-004728).xml / web-assets(7).xml. 직전 ZWEB0.3.16 보고서는 과거 기록으로 유지. 직전 결과는 DEVHUB_ZCO3_0_3_15_REVIEW.md. 상세 경로·언어는 DEVHUB_EXPORT_GUIDE.md, 과거 이력은 DEVHUB_STATUS.md와 버전별 VALIDATION에서 필요한 부분만 조회한다.

현재 Z_PACKAGE_EXPORT.abap: 203340바이트/5101행, SHA256 cce9a924ead825858d177956766dcbcbefacd4e9e992203ce2a4e8a4a3da0157. 0.3.18 전체 v700 구문·최소 API 타입 검사 통과. 실제 첨부 식별자를 쓴 MIME 경로/통합 FORM 실행, 패키지 분리, 대소문자 충돌, 새 Git RAW 규칙 검증 완료. 변경 없는 점검기0.3.3으로 합성 콘텐츠3,897개/웹2,766행/공용 메타데이터 비교 통과. SAP 조회·직렬화/PHIO는 대역이므로0.3.18 실제 SAP 활성화·재추출은 미검증. 실제 실행 확인은0.3.17까지다. 상세 DEVHUB_0_3_18_VALIDATION.md. 파일16MiB/비압축ZIP512MiB/경로220자 제한, 자동분할 없음.

새 AI 작업에는 이 문서+현재 소스+해당 오류/변경 대상만 제공한다. 종료 시 현재 상태를 갱신하고 과거 전문을 덧붙이지 않는다. 해결된 기능의 재검사는 변경 영향·새 증거가 있을 때만 한다. 이 요약만으로 보이지 않는 소스나 API를 추정하지 않는다.
