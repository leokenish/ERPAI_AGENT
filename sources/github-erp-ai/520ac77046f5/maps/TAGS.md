# 업무별 태그와 기술 색인

[전체 목차](INDEX.md) · [업무별 진행 상태](PROGRESS.md) · [기술 객체 목차](sources/INDEX.md)

23개 업무를 구별하는 태그를 업무 지도와 관련 소스 설명 Markdown에 붙였다. 공통 소스는 여러 태그를 가질 수 있다. 태그는 업무 관련성을 탐색하기 위한 분류이며 분석 완료·운영 적용·정책 승인 상태를 뜻하지 않는다.

적용 범위: 업무 지도 23개 + 소스 설명 651개 = 674개 문서. 소스 설명에는 미추출 외부 객체와 보존한 별도 파일도 포함한다. 업무 미배정 27개는 아래 목록에 남겼다.

## 업무 태그

| 업무 태그 | 업무 지도 | 태그가 붙은 문서 수 |
|---|---|---:|
| `#통상시차시간외` | [통상·시차 시간외 입력](topics/ordinary.md) | 217 |
| `#교대근무` | [교대근무·보상휴가](topics/shift.md) | 195 |
| `#탄력근무` | [탄력근로 계획·실적·결재](topics/flexible.md) | 238 |
| `#선택근무` | [선택근무](topics/selective.md) | 272 |
| `#간주근무` | [간주근무](topics/deemed.md) | 144 |
| `#재량근무` | [재량근무](topics/discretionary.md) | 64 |
| `#휴가공가반차` | [휴가·공가·반차](topics/leave.md) | 175 |
| `#대휴익휴보상휴가` | [대휴·익휴·보상휴가](topics/rest.md) | 209 |
| `#시간외단가등급` | [시간외 단가·직군·효력일](topics/rates.md) | 147 |
| `#월정산전표지급` | [월정산·확정·전표·지급](topics/settlement.md) | 223 |
| `#퇴직자관리자입력검토` | [퇴직자·관리자 입력 검토](topics/retired.md) | 178 |
| `#IAM등록기본설정` | [I AM 등록·기본설정](topics/iam.md) | 116 |
| `#통합결재` | [통합결재함·승인·반려·이력](topics/approvals.md) | 193 |
| `#특별연장재난방송` | [특별연장·재난방송](topics/special-extension.md) | 209 |
| `#근로시간알림` | [근로시간 한도·입력 알림](topics/alerts.md) | 144 |
| `#근무현황조회` | [근로유형·부서·개인 근무현황 조회](topics/reporting.md) | 206 |
| `#업무리소스인원연계` | [업무·리소스·인원 연계](topics/person-work.md) | 25 |
| `#비정규인원관리` | [비정규 인원 조회·수정](topics/nonregular.md) | 9 |
| `#시차근무대상자관리` | [시차근무 대상자 관리](topics/staggered-admin.md) | 28 |
| `#기준정보유지보수` | [기준정보·뷰·테이블 유지보수](topics/reference-data.md) | 104 |
| `#인사정보형9021_9023` | [HR 정보형 9021·9023 화면·구조](topics/infotypes.md) | 126 |
| `#자료복사결재보정` | [자료 복사·결재 불일치 보정 도구](topics/maintenance.md) | 37 |
| `#PC모바일공통웹` | [PC·모바일 공통 화면·웹 의존](topics/web-common.md) | 83 |

## 부여 기준

- 업무 단계 지도에서 직접 연결한 소스와 기존 업무 지도의 소스 링크를 우선한다.
- 실제 객체의 설명(metadata)에 업무명이 있으면 해당 업무의 후보 태그를 붙인다. 후보 표시는 근거 장부에 남긴다.
- 프로그램 Include 구성, 직접 호출·웹 요청·FORM·데이터 접근은 위 기준 소스에서 한 단계까지 반영한다. 공통 함수를 통해 호출 그래프 전체로 무제한 확산하지 않는다.
- 테이블/구조 → 데이터요소 → 도메인 등 데이터 정의는 실제 XML·타입 참조를 따라 연결한다. 같은 테이블을 사용하는 다른 프로그램으로 거꾸로 퍼뜨리지 않는다.
- 아직 업무가 없는 웹 화면은 직접 요청하는 업무 함수, 함수그룹 공통 Include는 해당 그룹의 명시된 업무를 후보 근거로 삼는다.
- 전체 목차·기술 색인·감사 보고서에는 23개 태그를 일괄 부여하지 않는다. 원본 ABAP·XML, knowledge, harness, baseline·이미지·폰트는 수정하지 않는다.
- 기존 `zhr5`, `source-note` 태그는 제거했다. 그 밖에 사용자가 요청하지 않은 기존 태그는 유지한다.

[파일별 업무 태그·부여 근거](audit/business-tags.json) · [태그 집계](audit/business-tags-summary.json)

## 기술 색인 이름

이 파일들은 업무 구분이 아니라 기술 객체 종류별 목차다. 파일명을 바꾸고 참조 링크도 갱신했다.

| 기술 종류 | 기술 색인 |
|---|---|
| ABAP 프로그램·독립 Include | [INDEX-ABAP프로그램-독립Include](sources/INDEX-ABAP%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%A8-%EB%8F%85%EB%A6%BDInclude.md) |
| BSP 화면·스크립트 | [INDEX-BSP웹화면-스크립트](sources/INDEX-BSP%EC%9B%B9%ED%99%94%EB%A9%B4-%EC%8A%A4%ED%81%AC%EB%A6%BD%ED%8A%B8.md) |
| DDIC DBtable | [INDEX-DB테이블](sources/INDEX-DB%ED%85%8C%EC%9D%B4%EB%B8%94.md) |
| DDIC Data element | [INDEX-데이터요소](sources/INDEX-%EB%8D%B0%EC%9D%B4%ED%84%B0%EC%9A%94%EC%86%8C.md) |
| DDIC Domain | [INDEX-도메인](sources/INDEX-%EB%8F%84%EB%A9%94%EC%9D%B8.md) |
| DDIC SHLP | [INDEX-검색도움말](sources/INDEX-%EA%B2%80%EC%83%89%EB%8F%84%EC%9B%80%EB%A7%90.md) |
| DDIC Structures | [INDEX-구조](sources/INDEX-%EA%B5%AC%EC%A1%B0.md) |
| DDIC TableType | [INDEX-테이블타입](sources/INDEX-%ED%85%8C%EC%9D%B4%EB%B8%94%ED%83%80%EC%9E%85.md) |
| DDIC VIEW | [INDEX-뷰](sources/INDEX-%EB%B7%B0.md) |
| 함수 | [INDEX-함수](sources/INDEX-%ED%95%A8%EC%88%98.md) |
| 함수그룹 Include | [INDEX-함수그룹Include](sources/INDEX-%ED%95%A8%EC%88%98%EA%B7%B8%EB%A3%B9Include.md) |

## 기존 별도 파일 보존

작업 전부터 존재하던 아래 파일은 제목과 원본 링크가 정규 설명과 같은 객체를 가리킨다. 내용을 지우거나 합치지 않고 같은 업무 태그를 붙였다. 객체 수에는 중복 집계하지 않는다.

| 기존 파일 | 정규 설명 |
|---|---|
| [ZHR_52 maps TM_APPROVE_DETAIL_LIST](sources/ZHR_52%20maps%20TM_APPROVE_DETAIL_LIST.md) | [ZHR_52TM_APPROVE_DETAIL_LIST](sources/ZHR_52TM_APPROVE_DETAIL_LIST.md) |

## 업무 미배정 소스

연관 근거가 부족한 소스에는 임의의 업무 태그를 붙이지 않았다. 아래 목록은 미사용 또는 업무 무관 판정이 아니다.

| 소스 | 현재 설명 |
|---|---|
| [ZHR_52TM_CALC_WORK_TIME_SPLIT](sources/ZHR_52TM_CALC_WORK_TIME_SPLIT.md) | [52시간] 사용안함 |
| [ZHR_52TM_GET_WORKSCHEDULE_TIME](sources/ZHR_52TM_GET_WORKSCHEDULE_TIME.md) | [52시간] 워크스케쥴로부터 근무계획시간 조회 |
| [ZHR_52TM_SAB_START](sources/ZHR_52TM_SAB_START.md) | [52시간] 안식년진입여부확인 |
| [ZHR_52TM_CW_SPLIT_WKTIME](sources/ZHR_52TM_CW_SPLIT_WKTIME.md) | [52시간] 근무시간 분리(사용안함) |
| [ZTHRBSADMIN](sources/ZTHRBSADMIN.md) | [HR]인사 관리자 타 사용자 로그인 매핑 테이블 |
| [ZBEGT2](sources/ZBEGT2.md) | 시작시간 |
| [ZE52WKTP_TX](sources/ZE52WKTP_TX.md) | 근로유형 TEXT |
| [ZENDT2](sources/ZENDT2.md) | 종료시간 |
| [ZEOTRTP](sources/ZEOTRTP.md) | [52시간] 시간외신청 유형 |
| [ZEPLWKHR_TM](sources/ZEPLWKHR_TM.md) | 주간 계획근무시간 |
| [ZEREASN](sources/ZEREASN.md) | 구분 |
| [ZERLOBRWKHR](sources/ZERLOBRWKHR.md) | 연장근로시간 |
| [ZETCYN](sources/ZETCYN.md) | 퇴출여부 |
| [ZDBEGDT2](sources/ZDBEGDT2.md) | 시작시간 |
| [ZDELEX](sources/ZDELEX.md) | 삭제지시자 |
| [ZDENDT2](sources/ZDENDT2.md) | 종료시간 24:00 |
| [ZDOTRTP](sources/ZDOTRTP.md) | [52시간] 시간외신청 유형 |
| [ZDREASN](sources/ZDREASN.md) | 구분 |
| [ZHRH017](sources/ZHRH017.md) | 근무주기 |
| [P9021_AF](sources/P9021_AF.md) | 추가질의필드 |
| [P9023_AF](sources/P9023_AF.md) | 추가질의필드 |
| [ZSHR0113](sources/ZSHR0113.md) | [52시간] 근무계획 - 근무주기별 누적근로시간 |
| [ZTSHR0114](sources/ZTSHR0114.md) | [52시간] DOMAIN VALUE TABLE TYPE |
| [ZVPA2010](sources/ZVPA2010.md) | [52시간] 시간외 실비 금액 조정 |
| [cost_content_semi](sources/cost_content_semi.md) | 업무 연관 근거 추가 검토 |
| [cost_inquiry_semi](sources/cost_inquiry_semi.md) | 업무 연관 근거 추가 검토 |
| [popup_input_semi](sources/popup_input_semi.md) | 업무 연관 근거 추가 검토 |

## 유지 방법

생성 도구가 같은 태그 규칙을 적용한다. 태그만 다시 적용할 때는 `python3 maps/tools/business_navigation.py`를 실행한다. 업무 태그 목록과 기술 색인 파일명은 이 도구에서 관리한다.
