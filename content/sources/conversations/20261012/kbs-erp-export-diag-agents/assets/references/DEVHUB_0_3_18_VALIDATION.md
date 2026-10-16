# DEVHUB 0.3.18 검증 기록

검증일: 2026-09-21. Export0.3.18 / CHECK0.3.3(변경 없음) / manifest0.2.

## 변경 범위

DOMA/DTEL 출력명을 Domain/Data element로 변경. SMIM 독립 자산을 MIME_TYPE별로 배치하고 패키지별 메타데이터를 통합했다. BSP 소속 MIME 본문 경로는 유지한다. W3MI 상위 폴더는 MIME로 변경한다. MIME 새 경로의 RAW 본문에 Git 줄바꿈 변환이 적용되지 않도록 생성 .gitattributes에 규칙을 추가했다.

소스: Z_PACKAGE_EXPORT.abap, 203,340바이트, 5,101행.
SHA-256: `cce9a924ead825858d177956766dcbcbefacd4e9e992203ce2a4e8a4a3da0157`.

## 수행 결과

| 검증 | 결과·범위 |
|---|---|
| 전체 ABAP v700 구문 분석 | 통과; unknown statement0 |
| 변경 루틴·기존 API 타입 대역 | 통과; 이전 시스템 근거의 MIME/BSP 메서드 시그니처 사용 |
| FORM 변경 경계 | 전체88개: 기존78개 동일,5개 변경,5개 추가 |
| SORT 타입 | 새 정렬 대상 gt_mime_metadata는 STANDARD TABLE; 기존 SORTED에 SORT 추가 없음 |
| 경로 실행 검사 | 실제 첨부 SMIM1,510개 식별자·URL·유형으로 실행; 독립75개 배치/충돌36개 식별자 부여 |
| BSP 경로 보존 | 기존 BSP MIME 파일1,306개 경로 동일 |
| 유형·이름 경계 | 대소문자, charset 매개변수, 누락/잘못된 유형, 경로 이탈 문자, 예약 이름, 동일 이름 충돌 확인 |
| 패키지 범위 | 외부 BSP 소유 패키지 거부, 메타데이터 패키지 분리, 빈 패키지 파일 미생성 확인 |
| 메타데이터 | ZWEB1,510행 + 별도 ZOTHER 합성1행; 각각 한 XML 경로; LOIO/URL/크기/언어/출력 경로 보존 |
| 오프라인 점검기 | 변경 없는 실제 HTML0.3.3을 실행; 합성 콘텐츠3,897개와 baseline 비교 통과, 변경/실패/추가/고아0 |
| 공용 METADATA_PATH | 웹 자산2,766행이 하나의 SMIM 메타데이터를 참조하는 구조에서 점검 통과 |
| RAW·Git 속성 | 합성 비UTF8 본문 바이트 비교; git check-attr로 MIME 본문 text 해제, 통합 XML text 설정, baseline/BSP RAW 유지 확인 |

변경된 기존 FORM은 preflight(버전), export_object(경로), finalize(통합 호출·안내·Git 속성), export_smim(본문 라우팅·메타데이터 수집), mime_output_path(독립 유형 경로)다. 추가 FORM은 mime_type_folder, mime_group_path, mime_metadata_path, mime_metadata_add, finalize_mime이다.

기존 add_raw/add_file, baseline 작성, XML 정렬/보존 검사, DDIC 읽기, 개발클래스 확인, 프로그램 읽기, BSP 페이지/앱 추출, W3MI 본문 처리, 생략/실패 정책 루틴은 변경하지 않았다. MIME GET_BY_IO 인자·호출 순서도 동일하다. P_MB512와 실행 시 재설정, 숨김 P_SUB, 클래스 참조 진단 제외를 유지했다.

실행 검사에서는 실제 신규 FORM을 타입 검사·변환해 실행했다. SAP TADIR 조회와 CALL TRANSFORMATION 경계는 대역 처리했고 PHIO는 명시적인 합성값을 사용했다. 따라서 실제 MIME 본문·PHIO·SAP ID 직렬화 성공을 검증했다고 해석하지 않는다. 타입 검사도 대상 시스템 DDIC 전체를 갖춘 SAP 컴파일러 검사가 아니다.

## 실제 결과와 미검증 구분

첨부 ZWEB0.3.17은 BASIS700에서 실행됐으며, 점검 TXT상 콘텐츠17,142 일치·파일실패0·SKIPPED19/WARNING19다. 실제 web-assets 목록의2,766행이 직전 결과와 동일한 것도 확인했다. 전체 ZIP 본문을 직접 재해시하지 않았다.

이번 0.3.18은 **실제 SAP 문법검사·활성화·재추출 미수행**이다. 개발계에서 새 ZIP을 추출하여 독립 MIME 경로와 공용 metadata.xml을 확인해야 한다. 같은 등록 대상이라면 콘텐츠15,633개가 예상되지만 실제 재실행 수치와 동일하다고 보장하지 않는다. Import, SAP 저장·활성화·CTS는 구현·검증 범위 밖이다.

## 배포 파일

전체 ZIP에는 Z_PACKAGE_EXPORT.abap, DEVHUB_CHECK.html, DEVHUB_EXPORT_GUIDE.md, DEVHUB_PROJECT_CONTEXT.md, 이 검증 기록, DEVHUB_ZWEB_0_3_17_REVIEW.md, DEVHUB_GITHUB_AGENTS_IMPORT_PLAN.md를 넣는다. ZIP 제작 후 항목 중복/상대경로·CRC·개별 원문 바이트 일치를 확인한다.
