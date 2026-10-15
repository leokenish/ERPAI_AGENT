# HR 업무 개요 — ZHR5 초안

분석일: 2026-09-21. 대상은 `exports/ZHR5` 한 추출물이다. **[확인]** manifest의 선택 패키지와 catalog의 618개 객체 소유 패키지가 모두 ZHR5다. ZHR6 폴더는 없으므로 이번 초안에 ZHR6 업무를 섞지 않았다. [manifest](../../exports/ZHR5/manifest.xml), [객체 catalog](../../exports/ZHR5/catalog/objects.xml)

표기: **[확인]**은 metadata·소스에서 직접 확인한 사실, **[추론]**은 근거에 따른 업무 해석, **[확인 필요]**는 누락·운영 정보, **[미검토]**는 아직 분석하지 않은 본문·분기다. 확인된 소스 사실도 운영에서의 성공을 의미하지 않는다.

## 1. 추출 범위와 품질

| 항목 | 확인 결과 | 근거 |
| --- | --- | --- |
| 시스템 | SYSID `KSD`, CLIENT `300`, BASIS `700`, UNICODE `X` | `exports/ZHR5/manifest.xml` HEADER |
| ECC 환경 | ECC 6.0은 사용자 제공 환경. manifest만으로 ECC 제품 버전을 추가 검증하지 않음 | 사용자 지시 |
| 추출기 | DEVHUB format `0.2`, tool `0.3.18` | manifest HEADER |
| 실행 시각 | `2026-09-21 13:40:15`; 로그에 시간대는 없음 | [logs/run.xml](../../exports/ZHR5/logs/run.xml) |
| 범위 설정 | `INCLUDE_SUBPACKAGES=X`; 실제 catalog DEVCLASS는 ZHR5만 존재 | manifest PACKAGES, catalog |
| 완전성 | `COMPLETENESS=PARTIAL`, `DEPENDENCY_POLICY=REFERENCE_ONLY_EXTERNAL`, `DEPENDENCY_COVERAGE=OWNED_FUGR_INCLUDE_WALK_PARTIAL` | manifest HEADER |
| 파일 | manifest 등록 2,530개, 모두 로컬 존재. 모든 파일의 CAPABILITY가 `ANALYSIS_ONLY` | manifest FILES 대조 |
| 버전 표기 | `ACTIVE_STATE=A` 1,222개, `U` 1,308개. 모든 파일을 active 검증 완료로 간주할 수 없음 | manifest FILES |
| 언어 | KO 우선, EN fallback. API 출력의 실제 언어를 metadata로 확인해야 함 | manifest, 추출 README |
| SP 정보 | `SAP_BASIS 700 SP0041`은 screenshot 근거로 기록되며 도구 측정 결과가 아님 | manifest SUPPORT_PACKAGE_EVIDENCE |
| 운영 데이터 | DDIC 정의·소스 중심. 실제 상수값, 승인 내역, 잡 스케줄, 운영 권한을 확인할 수 없음 | manifest 파일 구성 |

manifest에 없는 비-baseline 파일 9개는 `.gitattributes`, `.gitignore`, `manifest.xml`, 루트/패키지 `README.md`, `catalog/objects.xml`, `catalog/references.xml`, `logs/processing.xml`, `logs/run.xml`이다. 등록 파일의 누락과 구별한다. baseline은 업무 분석에서 제외했다.

### Catalog 객체 618개

| 객체 유형 | 개수 | 추출 상태 |
| --- | ---: | --- |
| CLAS | 3 | UNSUPPORTED 3 |
| DEVC / DIAL / NROB / SHI3 / SICF | 1 / 2 / 1 / 1 / 1 | 모두 UNSUPPORTED |
| DOMA / DTEL | 20 / 131 | 모두 PARTIAL |
| FUGR | 5 | PARTIAL 5 |
| PROG | 110 | PARTIAL 110; SUBC 1=29, M=3, I=78 |
| SHLP | 4 | PARTIAL 4 |
| SMIM | 144 | PARTIAL 141, EXCLUDED 3 |
| TABL | 104 | PARTIAL 103, FAILED 1; DB 테이블과 구조를 포함 |
| TOBJ / TRAN | 19 / 44 | 모두 UNSUPPORTED |
| TTYP / VIEW / WAPA | 9 / 18 / 1 | 모두 PARTIAL |
| **합계** | **618** | **PARTIAL 542, UNSUPPORTED 72, EXCLUDED 3, FAILED 1** |

근거: [catalog/objects.xml](../../exports/ZHR5/catalog/objects.xml). 전체 이름은 [object-inventory.csv](object-inventory.csv)에 있다. `PARTIAL`은 분석 완료 또는 실행 보장을 뜻하지 않는다.

### 하위 구성요소 및 로그

| 함수그룹 | 함수 소스 | 소유 include 추출 | 검토 범위 |
| --- | ---: | ---: | --- |
| ZHR008_1 | 36 | 43 | 목록만 확인, 생성형 유지보수 로직 미검토 |
| ZHR008_2 | 74 | 82 | 선택한 계획·승인·정산·시간외 함수 및 FORM만 분석 |
| ZHR008_3 | 11 | 17 | 목록만 확인, 선택근로 등 본문 미검토 |
| ZHR_ETC | 4 | 6 | 목록만 확인, 인원·업무 연계 본문 미검토 |
| ZHR_ZTHRBS16 | 2 | 7 | 목록만 확인, 유지보수 본문 미검토 |
| **합계** | **127** | **155** | include와 함수 API 소스의 중복을 독립 객체로 세지 않음 |

**[확인]** [처리 로그](../../exports/ZHR5/logs/processing.xml)는 INFO 29건, FAILED 1건이다. 함수 소스 127건과 소유 include 155건은 로그상 실패 0건이고 각 `Include/includes.xml`도 EXPORTED로 기록되어 있다. BSP `Z52_FLEX_TIME`의 page/language 읽기는 96건 완료, 0건 실패다. 이는 미지원 객체·미추출 외부 의존이 없다는 의미가 아니다.

manifest에는 DDIC 정의 285개(TABL 103, DTEL 131, DOMA 20, VIEW 18, TTYP 9, SHLP 4), BSP layout 96개, BSP event source 11개, MIME content 136개가 있다. [web-assets catalog](../../exports/ZHR5/catalog/web-assets.xml)의 ASSETS 237행은 EXPORTED 232행(페이지 96 + MIME 파일 136)과 FOLDER 5행이다. 페이지와 함수는 최상위 catalog 객체 618개와 별도 계층이다.

## 2. 추출 실패·누락·외부 경계

1. **[확인] DDIC 실패 1건:** `ZHCMT_BSP_PA_XX_R9023`. KO 읽기 후 EN 재시도에서도 active 정의를 확보하지 못했다. 로그는 `LANG=E SUBRC=0 GOTSTATE=빈값`을 기록한다. [진단 파일](<../../exports/ZHR5/packages/ZHR5/Dictionary Object/TABL/ZHCMT_BSP_PA_XX_R9023/diagnostic-dd02l.xml>)에는 `AS4LOCAL=L`, `AS4VERS=0000`, `TABCLASS=INTTAB`만 확인된다. 원인이나 복구 방법은 확정하지 않는다.
2. **[확인] 클래스 본문 미지원:** `ZCL_APP_ZEP002_IT_E`, `ZCL_HRPA_INFOTYPE_9021`, `ZCL_HRPA_INFOTYPE_9023`. BSP 생성/컨트롤러 클래스의 동작도 참조만으로 확정할 수 없다.
3. **[확인] TRAN 44개와 SICF 등의 정의 미지원:** 실제 트랜잭션→프로그램 매핑, 화면 100의 flow logic, GUI status, 서비스 설정·권한은 누락 경계다. 프로그램 헤더 주석은 매핑의 확정 근거가 아니다.
4. **[확인] MIME 제외 3건:** `ZEP0002` 소유 패키지 `ZEP1` 관련 2건, `ZMOBILE_COMMON` 소유 패키지 `ZMOBILE` 관련 1건. web-assets에는 별도로 ZHR1 소유 이미지 2건도 외부 참조로 나온다. 자세한 ID·경로는 [미확인 사항](open-questions.md#q03)에 기록했다.
5. **[확인] 의존 catalog는 include 일부만 수록:** DIRECT_INCLUDE 258건 = IN_SCOPE_ROOT 78 + IN_SCOPE_COMPONENT 155 + EXTERNAL_REFERENCE_ONLY 25. 외부 25건은 SVIM 11, PBAS 6, SABP 5, PWWW 2, S_ITSP 1이다. 함수·클래스·동적 호출 전체 목록이 아니다. [catalog/references.xml](../../exports/ZHR5/catalog/references.xml)
6. **[확인 필요] 실제 업무 연결의 공백:** `ZWEB_COMMON/AJAX_COMMON.HTM`, `ZWF_START_WORK_HR`, `ZWF_DELETE`, `ZWF_APPROVE_WORK`, `ZWF_REJECT_WORK`, `ZTHRBS01`, `ZWF0022`, `PA2010`, `ZSTATE_1` 등은 호출·사용 흔적이 있으나 이번 catalog/본문에는 해당 정의가 없다. 소유 패키지는 추가 확인이 필요하다. [객체 지도](object-map.md#external-boundaries)
7. **[확인] 추출 도구의 한계:** [추출 README](../../exports/ZHR5/README.md)는 처음 active source 읽기가 불가능한 대상을 제외하며 오류 로그로 모두 남기지 않는다고 설명한다. 함수 API 버전은 UNVERIFIED이고 전역 저장소 잠금 없이 읽었다. 따라서 로그 실패 수나 파일 수를 SAP 전체 누락률로 사용할 수 없다. OTR, 긴 문서/메시지 설명, 화면 등도 불완전하다.

## 3. 확인된 업무 개요

**[확인]** 근로유형 도메인 `ZD52WKTP1`에는 `0010 통상`, `0030 교대`, `0110 4주선택`, `0120 2주탄력`, `0130 간주`, `0140 재량`이 정의되어 있다. 이는 추출된 코드값이며 현행 사규·법적 기준을 검증한 결과가 아니다. [정의](<../../exports/ZHR5/packages/ZHR5/Dictionary Object/Domain/ZD52WKTP1/definition.xml>)

| 업무 | 확인한 내용 | 검토 수준·근거 |
| --- | --- | --- |
| 탄력근로 계획 | 웹 페이지의 조회·저장·상신 요청, 기간/일일계획 저장, 상신 조건 및 회수·삭제 분기 | 부분 검토; [F01](flows.md#f01), S01–S04 |
| 계획 결재 | 계획 요청 P에 대해 승인/반려 코드 갱신, 승인 입력 시 PA9021 겹침 검사·기록, 외부 WF 호출 | 부분 검토; [F02](flows.md#f02), S05 |
| 계획 미결처리 | ZLIMIT으로 대상 구간 계산, STATE 0/E 대상 검색, 회수 성공 또는 WF 없는 건을 F로 변경 | ZRPTH401 단일 소스 전체 확인; [F03](flows.md#f03), S06 |
| 탄력근로 월 정산 | 승인 계획·실적 참조, 월 정산 계산 호출, 임금유형 8030의 PA2010 반영, 확정 취소 조건 | 주요 경로만 확인; [F04](flows.md#f04), S07–S11 |
| 통상/교대 시간외 신청 | ORD_OT_INSERT의 저장·상신 요청, MOBILE_OVERTIME_APPR의 SAVE/APPR 분기, ZTHRBS01 변경 및 WF F 호출 | 주요 경로만 확인; [F05](flows.md#f05), S12–S15 |
| FI 연결 | ZRPTH2012_M이 PA2010 중 기준일·임금유형·AWREF 공백 조건으로 데이터를 읽고 참조전표번호를 갱신하는 코드 | 연결 일부만 확인; [F06](flows.md#f06), S16–S17 |

**[추론]** 검토한 코드들을 종합하면 ZHR5는 근로유형별 계획·실적·결재·수당 정산을 연결하는 HR 업무 영역으로 볼 수 있다. 월 정산의 PA2010 결과가 별도 전표 프로그램의 후보 입력이 될 수 있다. 자동 실행 순서·스케줄·실제 운영 사용은 확인되지 않았다.

**[미검토]** 선택근로 마감·지급(ZRPTH411), 재량근로 대상/수당/대휴(ZRPTH407–409), 간주근로 정산(ZRPTH404/414), 특별연장·한도알림·대휴·실적 상세 계산, 근무정보 외부 연계, 전체 FI 전표 처리, 대부분의 BSP 화면·DDIC 객체는 본문 또는 세부 분기를 검토하지 않았다. 제목으로 추정한 역할을 구현 사실로 취급하지 않는다. [검토 범위](object-map.md#review-coverage)

## 4. 이번 검증의 범위

문서 7개의 로컬 링크 116개와 원본 경로, CSV 841행의 중복·근거 경로·검토 범위, 질문 E01–E20을 확인했다. CSV 검토 상태는 BODY_REVIEWED 7행, PARTIAL_REVIEW 11행, METADATA_ONLY 333행, NOT_REVIEWED 490행이다. 본문 확인 표기도 호출 대상 전체 또는 업무 전체의 검토 완료를 뜻하지 않는다.

작업 전후 `exports`의 파일 5,069개를 목록·SHA-256으로 대조해 추가·삭제·내용 변경이 모두 0건임을 확인했다. 여기에는 baseline이 포함되지만 그 바이트는 보존 점검만 했으며 업무 검색에 사용하지 않았다. 이 점검은 추출물의 SAP 완전성이나 ABAP 실행 검증이 아니다. 업무 규칙과 남은 검토 순서는 [open-questions.md](open-questions.md)에 정리했다.
