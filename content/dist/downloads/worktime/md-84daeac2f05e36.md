# ZHR5 객체 지도와 검토 범위

기준: 2026-09-21 추출물. [전체 목록 CSV](object-inventory.csv)는 catalog 618개와 함수 127개·BSP 페이지 96개를 별도 `record_kind`로 구분한다. CSV의 제목은 metadata이며, 본문 미검토 객체의 실제 동작을 증명하지 않는다. 아래 연결은 정적 코드에서 확인한 범위다.

## 1. 진입점과 연결

| 객체 | 종류·확인한 역할 | 연결과 한계 |
| --- | --- | --- |
| Z52_FLEX_TIME / FLEX_WORK_PLAN_ESTABLISH.htm | BSP 계획 화면의 요청 구성 | `ZHR_52TM_PLAN_WORK_TIME` 이름을 공통 AJAX로 전송. `0120`, 주기 `02`. 공통 dispatcher 본문 미추출. S01 |
| ZHR_52TM_PLAN_WORK_TIME | 계획 조회 R / 저장 S / 상신 A / 회수 B / 삭제 D / 초기화 후 저장 N 분기 | `get_plan_save`, `check_plan_approve` → ZTHR0106/0107. S02–S04 |
| ZHR_52TM_APPROVE_OT_DATA | 계획 P / 실적 R의 승인·반려 분기 | 계획 경로의 PA9021 기록 및 ZTHR0106 수정 확인. 실제 결재 화면/워크플로에서 이 함수를 호출하는 연결은 미확인. S05 |
| ZRPTH401 | `[52시간] 탄력근로계획수립 미결처리 BATCH` | ZTHR0101의 ZLIMIT → ZTHR0106 → ZWF_DELETE 호출 → STATE F. 실행 잡 존재·일정은 미확인. S06 |
| ZRPTH402 | 탄력근로 정산관리 보고서 | ZRPTH402TOP/F01, ZHR_52TM_MONTHLY_PAYMENT, 화면 100. 트랜잭션 정의 및 화면 flow logic 미추출. S07–S10 |
| ZHR_52TM_MONTHLY_PAYMENT | 월/소급 지급 계산용 함수 | ZTHR0106·ZTHR0110·ZTHR0120 참조, 주 계산 함수·금액 FORM 호출. 전체 시간 집계 분기는 미검토. S10–S11 |
| Z52_FLEX_TIME / ORD_OT_INSERT.htm | 시간외 입력 화면의 저장·상신 요청 | ZHR_52TM_MOBILE_OVERTIME_APPR의 SAVE/APPR 요청을 공통 AJAX로 전송. 모바일 명칭 함수가 이 페이지에도 사용됨. S12 |
| ZHR_52TM_MOBILE_OVERTIME_APPR | 소스 주석상 통상/교대 시간외 신청관리 | SAVE→GET_OVERTIME_SAVE, APPR→GET_OVERTIME_REQUEST. DELE/RETR 상세는 미검토. S13 |
| ZHR_52TM_GET_OVERTIME_SAVE | 시간외 데이터 가공 및 일부 DB 변경 | GET_OVERTIME_DATA 호출, 신규 상태 0, 대휴 2일 분할 등 분기. 보통 T_DATA를 반환하고 호출자가 저장하지만 분할 분기는 직접 ZTHRBS01을 변경함. S14 |
| ZHR_52TM_GET_OVERTIME_REQUEST | 시간외 상신 요청 | 외부 ZWF_START_WORK_HR(`ZWFTYPE=F`) → ZTHRBS01의 상신 표시·WF 키 갱신. S15 |
| ZRPTH2012_M | 제목상 시간외실비 FI전표생성 | `get_post_data`의 PA2010 조회와 `update_pa2010`의 AWREF 갱신만 확인. 전표·역분개·EDI 본 처리 미검토. S16–S17 |
| MAIN.htm | 공통/모바일 업무 화면으로의 이동 코드 | ZMOBILE_ESS, MORD_OT_MAIN, FLEX_MAIN URL과 공통 AJAX 사용. 시작 페이지로 확정하지 않음. S18 |

**[확인]** `pages/pages.xml`의 96개 페이지에서 `IS_START_PAGE`가 설정된 페이지는 없었다. 이름 `MAIN`만으로 운영 최초 진입 화면을 지정할 수 없다. [BSP 페이지 metadata](<../../exports/ZHR5/packages/ZHR5/BSP Application/WAPA/Z52_FLEX_TIME/pages/pages.xml>)

**[확인 필요]** catalog에 `ZRH401`, `ZRH402` 등이 있으나 TRAN 44개는 모두 UNSUPPORTED다. 특히 ZRPTH402 헤더는 Transaction을 `ZRh401`로 적고 있다(S07 4행). 실제 실행 연결은 SE93/TSTC/TSTCP 등 담당자 제공 자료로 확인해야 한다.

## 2. 주요 데이터 객체

아래 키는 DDIC XML에서 확인한 주요 키다. `.INCLUDE` 같은 정의 행은 업무 키에서 제외했다. 키 관계가 보인다는 사실만으로 실제 외래키 제약이나 데이터 정합성을 보장하지 않는다.

| 객체 | DDIC에서 확인한 역할·주요 키 | 코드상 연결 |
| --- | --- | --- |
| ZTHR0101 | 유연근무 상수값관리. MANDT, ZCONST, ENDDA | 계획 상신·배치가 ZLIMIT과 유효기간을 조회. 운영 ZCNVAL 값은 없음. D01, S03, S06 |
| ZTHR0105 | 주간 계획근로시간 기본값 설정. MANDT, Z52WKTP, Z52PRSQ, ZPLWKHR_TY | 역할은 DDIC 설명 확인. 실제 설정값·전체 사용처 미검토. D02 |
| ZTHR0106 | 탄력근로 계획 기간 Header. MANDT, PERNR, Z52WKTP, BEGDA, ENDDA, SEQNR | 저장·상신·승인·미결·월정산의 기간계획. D03, S02, S03, S05–S10 |
| ZTHR0107 | 일일계획. MANDT, PERNR, DATUM, SEQNR | get_plan_save 저장, 계획 조회에서 기간·순번으로 연결. D04, S02–S03 |
| ZTHR0110 | 탄력근로 실적관리. MANDT, PERNR, DATUM, SEQNR | 실적 승인 분기 및 정산 대상·정산일 갱신. 실적 입력 자체는 미검토. D05, S05, S09–S10 |
| ZTHR0120 | 탄력근로제 월별정산확정. MANDT, ZADMIT_YM, PERNR, WPAYBEG, WPAYEND | 월정산 확정 결과, 소급 비교·확정취소 대상. D06, S09–S10 |
| PA9021 | HR 마스터 정보형 9021. MANDT, PERNR, SUBTY, OBJPS, SPRPS, ENDDA, BEGDA, SEQNR | 계획 승인 입력 시 기록, 승인계획 삭제 시 해당 기간 레코드 삭제 경로. 정보형 클래스 본문 없음. D07, S02, S05 |
| PA9023 | HR 마스터 정보형 9023. 표준 형태의 정보형 키 | DDIC만 확인. 업무 처리·MP9023*·클래스 본문은 각각 미검토/미추출. D08 |
| ZHRDAEHUAMT | 휴일-휴일 양일 대휴 정산 금액 배분. PERNR, DATUM | GET_OVERTIME_SAVE가 금액을 읽고 행을 삭제하는 분기. 전체 생산자·생명주기 미검토. D09, S14 |
| ZD52WKTP1 | 0010 통상 / 0030 교대 / 0110 4주선택 / 0120 2주탄력 / 0130 간주 / 0140 재량 | 소스의 근로유형 코드 해석 근거. S20 |
| ZD52REQTP | P 계획-탄력근로 / R 실적-탄력근로 | APPROVE_OT_DATA의 요청유형 분기. S21, S05 |
| ZTHRBS01 | **정의 미추출**. 코드상 시간외 데이터 읽기·쓰기 대상 | PERNR/RDATE/SEQNR를 조건으로 사용하나 완전한 DDIC 키·소유 패키지 미확인. S13–S15 |
| PA2010 | **정의 미추출**. 정산 코드가 SUBTY/LGART 8030, KRW로 기록 | ZRPTH402의 정산 출력, ZRPTH2012_M의 입력 후보. 급여 실행·실제 지급을 증명하지 않음. S09, S17 |
| ZWF0022 / ZSTATE_1 | **정의 미추출**. WF 조회 테이블 / 상태명 조회 도메인으로 참조 | 전체 WF 구조·전체 상태 목록 미확인. 다른 업무의 같은 값 의미로 일반화하지 않음. S03, S06, S09–S10 |

## 3. 소스상 상태값과 작업 구분

| 문맥 | 확인한 값 | 적용 한계 |
| --- | --- | --- |
| 계획 함수 I_ZGUBUN | R 조회, S 저장, A 상신, B 회수, D 삭제, N 초기화 후 저장 | S02 CASE가 근거. 화면 주석 일부는 회수를 R이라고 적지만 본문은 B |
| 계획/실적 STATE | 0 저장, E 상신, 3 승인, 9 반려, 5 회수, 2 삭제, F 미결처리 | 확인된 할당·주석 문맥만. ZSTATE_1 전체 정의 없음; 다단계 승인 분기를 단일 전이로 축약하지 않음 |
| 시간외 I_ACTION | SAVE 저장, APPR 상신, DELE 삭제, RETR 회수 | S13. APPR는 최종 승인 명령으로 해석하면 안 됨 |
| 시간외 상신 | STATE_TXT='결재중', ZSANGSIN='Y', ZNO=WF 키 | S15가 직접 변경하는 필드. STATE='E'를 여기서 설정한다고 말할 수 없음 |

<a id="external-boundaries"></a>
## 4. 외부 의존 경계

| 참조 대상 | 직접 근거 | 이번에 확정할 수 없는 것 |
| --- | --- | --- |
| ZWEB_COMMON/AJAX_COMMON.HTM, server_util2.ssjs | S01·S12의 요청 URL/포함문 | 동적 함수 호출 허용 목록, 인증·권한, 직렬화, 요청 단위 커밋 |
| ZMOBILE_COMMON/server_util.ssjs, ZMOBILE_ESS | S18 | 로그인·모바일 공통 처리 및 외부 화면 동작 |
| ZWF_START_WORK_HR, ZWF_DELETE, ZWF_APPROVE_WORK, ZWF_REJECT_WORK | S02·S03·S05·S06·S15 | 결재 엔진, 실제 경로·메일 발송·잠금·커밋 구현 |
| ZHR_CHECK_APPROVER_N, ZHR_52TM_CHECK_APPROVER_N, ZHR_GET_RETIREMENTAGE | S03·S13·S15 | 결재자 선정·안식년 판정의 전체 규칙 |
| ZTHRBS01, ZWF0022, ZTH0500, PA0000/0001/2010, ZSTATE_1 | S06–S10·S13–S17 | DDIC 전체 정의·운영 데이터·커스터마이징 |
| CLAS 3개 및 BSP 생성 클래스 | catalog CLAS, pages.xml의 IMPLCLASS | 정보형 검증·화면 lifecycle·추출되지 않은 메서드 |
| SVIM/PBAS/SABP/PWWW/S_ITSP include | catalog/references.xml 외부 25행 | 해당 표준 include의 실제 구현·전체 의존 범위 |

위 사용자 정의 함수·테이블은 이번 목록에서 본문/정의가 발견되지 않았다. 이름만으로 ZHR1·ZWF 등의 소유 패키지를 부여하지 않는다. 반면 web-assets가 명시한 `ZEP1`, `ZMOBILE`, `ZHR1` 소유 관계는 metadata 근거가 있다.

<a id="review-coverage"></a>
## 5. 검토 범위와 다음 진입점

| 범위 | 이번 검토 | 남은 영역 |
| --- | --- | --- |
| manifest·catalog·로그 | 전체 집계 및 파일 존재 확인 | SAP 실제 객체와의 완전성 대조 미수행 |
| ZRPTH401 | 141행 단일 소스 전체 검토 | 외부 ZWF_DELETE, 운영 상수·잡·실행 결과 미확인 |
| ZHR_52TM_PLAN_WORK_TIME / LZHR008_2F01 | 함수의 분기 본문, get_plan_save·check_plan_approve, 라운딩 FORM | 날짜·휴게·주간시간 보조 함수/FORM의 모든 내부 분기는 미검토 |
| ZHR_52TM_APPROVE_OT_DATA | 계획 P 분기와 WF 후처리 | 실적 R 분기 중 금액·대휴 생성 상세, UI 호출 경로 미검토/미확인 |
| ZRPTH402/TOP/F01 | 메인·선택조건·계산호출·PAI 명령·확정·취소·미결처리 | ALV 표시 세부, 화면 flow logic, 실제 입력/실행 미확인 |
| ZHR_52TM_MONTHLY_PAYMENT / LZHR008_2F02 | 대상 조회, 소급 대상, 주 구간, 계산 호출·계수·금액 FORM | 전체 일별 시간 집계·특례·소급 차액 후반 분기 미검토 |
| 시간외 함수 3개 | MOBILE_OVERTIME_APPR의 SAVE/APPR 주요 구간, GET_OVERTIME_SAVE·REQUEST 본문 | GET_OVERTIME_DATA의 전체 계산, 삭제·회수·검증 및 2일 분할 보조 FORM 미검토 |
| BSP | MAIN 이동 위치, 계획·시간외 화면의 요청/일부 callback 구간, APP_OT_LIST 호출 이름 검색 | 나머지 UI·이벤트·MIME 본문 미검토. 일부 페이지를 보았다고 WAPA 전체 검토 완료로 표시하지 않음 |
| ZRPTH2012_M/F01 | 메인과 PA2010 조회·AWREF 갱신 FORM의 선택 구간 | TOP의 변수·설정, 전표 생성·역분개·EDI·정보형 후처리 대부분 미검토 |
| 그 외 | catalog·함수 디렉터리·보고서 제목·페이지 metadata만 정리 | 본문 미검토 |

다음 후보는 보고서 제목/함수 이름으로 식별했으며, 아직 확인된 처리 흐름으로 승격하지 않았다.

- `ZRPTH403` 근로시간한도알림, `ZHR_OVERTIME_SMS`: 알림 실제 조건·수신자·발송 미검토.
- `ZRPTH404`/`ZRPTH414`: 둘 다 간주근로 정산 제목이지만 404에는 `(X)` 표기. 운영 사용/폐기 여부 미확인.
- `ZRPTH405`/`406`: 근로유형·일일시간, 특별연장 실행직원 조회 본문 미검토.
- `ZRPTH407`/`408`/`409`: 재량근로 대상자·수당·대휴 처리 미검토.
- `ZRPTH410`/`411`/`413`/`440`, `ZHR008_3`의 `ZHR_52TM_CW_*`: 선택근로 대상·마감·실적·누적시간 본문 미검토.
- `ZRPTH412`/`415`/`419`/`422`/`441`: 등급·대휴·시뮬레이션·통상 초과시간 본문 미검토.
- `ZHR_GET_RES_WORK_INFO`, `ZHR_DELETE_WORK_INFO`, `ZHR_GANJU_LIST`, `ZHR_ETC` 함수: 리소스/업무·인원 연계 미검토.
- `MP9021*`, `MP9023*`, `SAPMZH4110`, `SAPMZH432`, `ZRPTMP003_*`, `ZTHR_WEEK_TIME`, `ZRPTH_ZTHRBS01_COPY`: 본문 미검토. 오래된 이름·TEST 제목·사본 명칭만으로 폐기/테스트 전용이라고 확정하지 않음.

CSV 검토 표기: `BODY_REVIEWED`는 해당 파일 본문 확인, `PARTIAL_REVIEW`는 일부 경로만 확인, `METADATA_ONLY`는 목록·제목/정의 일부 확인으로 업무 본문 미검토, `NOT_REVIEWED`는 업무 미검토다. 각각의 한계는 `review_scope`에 기록했다. 어떤 표기도 SAP 실행 검증을 뜻하지 않는다.

## 6. 근거 경로 사전

아래 링크 표시 경로는 모두 저장소 루트 기준 상대 경로다. 실제 링크는 현재 문서 위치에 맞춰 연결했다. 행 번호는 원본 추출 파일 기준이며, 다른 추출물에 그대로 적용하지 않는다.

| ID·객체 | 원본 경로 | 확인 위치 |
| --- | --- | --- |
| <a id="s01"></a>S01 FLEX_WORK_PLAN_ESTABLISH.htm | [exports/ZHR5/packages/ZHR5/BSP Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_ESTABLISH/Layout/FLEX_WORK_PLAN_ESTABLISH.htm](<../../exports/ZHR5/packages/ZHR5/BSP Application/WAPA/Z52_FLEX_TIME/pages/FLEX_WORK_PLAN_ESTABLISH/Layout/FLEX_WORK_PLAN_ESTABLISH.htm>) | 1622–1646, 1746–1786, 1950–2082행; 요청과 callback |
| <a id="s02"></a>S02 ZHR_52TM_PLAN_WORK_TIME | [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function Module/ZHR_52TM_PLAN_WORK_TIME/Source code/ZHR_52TM_PLAN_WORK_TIME.abap](<../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function Module/ZHR_52TM_PLAN_WORK_TIME/Source code/ZHR_52TM_PLAN_WORK_TIME.abap>) | 1–342행; CASE I_ZGUBUN |
| <a id="s03"></a>S03 LZHR008_2F01 | [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F01.abap) | 533–811 get_plan_save; 817–1018 check_plan_approve; 2591–2610 set_round_amt 구간 |
| <a id="s04"></a>S04 SAPLZHR008_2 | [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/SAPLZHR008_2.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/SAPLZHR008_2.abap) | 4–24행; TOP/UXX/F01–F06 include |
| <a id="s05"></a>S05 ZHR_52TM_APPROVE_OT_DATA | [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function Module/ZHR_52TM_APPROVE_OT_DATA/Source code/ZHR_52TM_APPROVE_OT_DATA.abap](<../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function Module/ZHR_52TM_APPROVE_OT_DATA/Source code/ZHR_52TM_APPROVE_OT_DATA.abap>) | 64–217, 402–451행; 계획 P 및 WF 후처리 |
| <a id="s06"></a>S06 ZRPTH401 | [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH401/source/ZRPTH401.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH401/source/ZRPTH401.abap) | 1–141행 |
| <a id="s07"></a>S07 ZRPTH402 | [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402/source/ZRPTH402.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402/source/ZRPTH402.abap) | 1–203행; 메인 이벤트 |
| <a id="s08"></a>S08 ZRPTH402TOP | [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402TOP/source/ZRPTH402TOP.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402TOP/source/ZRPTH402TOP.abap) | 1–158행; 선언·선택조건 |
| <a id="s09"></a>S09 ZRPTH402F01 | [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH402F01/source/ZRPTH402F01.abap) | 13–54, 383–500, 540–631, 814–923, 1096–1128행 |
| <a id="s10"></a>S10 ZHR_52TM_MONTHLY_PAYMENT | [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function Module/ZHR_52TM_MONTHLY_PAYMENT/Source code/ZHR_52TM_MONTHLY_PAYMENT.abap](<../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function Module/ZHR_52TM_MONTHLY_PAYMENT/Source code/ZHR_52TM_MONTHLY_PAYMENT.abap>) | 1–255, 635–725행; 대상·금액계수 중심 |
| <a id="s11"></a>S11 LZHR008_2F02 | [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F02.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F02.abap) | 48–76행; CALC_OT_AMOUNT |
| <a id="s12"></a>S12 ORD_OT_INSERT.htm | [exports/ZHR5/packages/ZHR5/BSP Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_INSERT/Layout/ORD_OT_INSERT.htm](<../../exports/ZHR5/packages/ZHR5/BSP Application/WAPA/Z52_FLEX_TIME/pages/ORD_OT_INSERT/Layout/ORD_OT_INSERT.htm>) | 1840–1920, 2023–2068행; SAVE/APPR 전송 |
| <a id="s13"></a>S13 ZHR_52TM_MOBILE_OVERTIME_APPR | [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap](<../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap>) | 1–85, 135–225, 270–378행 및 CASE 위치검색 |
| <a id="s14"></a>S14 ZHR_52TM_GET_OVERTIME_SAVE | [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function Module/ZHR_52TM_GET_OVERTIME_SAVE/Source code/ZHR_52TM_GET_OVERTIME_SAVE.abap](<../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function Module/ZHR_52TM_GET_OVERTIME_SAVE/Source code/ZHR_52TM_GET_OVERTIME_SAVE.abap>) | 1–365행; 내부 호출 함수/보조 FORM은 미검토 |
| <a id="s15"></a>S15 ZHR_52TM_GET_OVERTIME_REQUEST | [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function Module/ZHR_52TM_GET_OVERTIME_REQUEST/Source code/ZHR_52TM_GET_OVERTIME_REQUEST.abap](<../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function Module/ZHR_52TM_GET_OVERTIME_REQUEST/Source code/ZHR_52TM_GET_OVERTIME_REQUEST.abap>) | 1–134행; 외部 WF/판정 함수 본문 없음 |
| <a id="s16"></a>S16 ZRPTH2012_M | [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_M/source/ZRPTH2012_M.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_M/source/ZRPTH2012_M.abap) | 1–77행; 진입 분기 |
| <a id="s17"></a>S17 ZRPTH2012_MF01 | [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH2012_MF01/source/ZRPTH2012_MF01.abap) | 42–94행 get_post_data 일부; 1204–1231행 update_pa2010 |
| <a id="s18"></a>S18 MAIN.htm | [exports/ZHR5/packages/ZHR5/BSP Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm](<../../exports/ZHR5/packages/ZHR5/BSP Application/WAPA/Z52_FLEX_TIME/pages/MAIN/Layout/MAIN.htm>) | 73, 130–178행 등 URL·호출 위치 검색 |
| <a id="s20"></a>S20 ZD52WKTP1 | [exports/ZHR5/packages/ZHR5/Dictionary Object/Domain/ZD52WKTP1/definition.xml](<../../exports/ZHR5/packages/ZHR5/Dictionary Object/Domain/ZD52WKTP1/definition.xml>) | DOMVALUE_L/DDTEXT; 코드·설명 확인 |
| <a id="s21"></a>S21 ZD52REQTP | [exports/ZHR5/packages/ZHR5/Dictionary Object/Domain/ZD52REQTP/definition.xml](<../../exports/ZHR5/packages/ZHR5/Dictionary Object/Domain/ZD52REQTP/definition.xml>) | DOMVALUE_L/DDTEXT |
| <a id="d01"></a>D01 ZTHR0101 | [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0101/definition.xml](<../../exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0101/definition.xml>) | TABCLASS, DDTEXT, 키 |
| <a id="d02"></a>D02 ZTHR0105 | [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0105/definition.xml](<../../exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0105/definition.xml>) | TABCLASS, DDTEXT, 키 |
| <a id="d03"></a>D03 ZTHR0106 | [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0106/definition.xml](<../../exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0106/definition.xml>) | TABCLASS, DDTEXT, 키 |
| <a id="d04"></a>D04 ZTHR0107 | [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0107/definition.xml](<../../exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0107/definition.xml>) | TABCLASS, DDTEXT, 키 |
| <a id="d05"></a>D05 ZTHR0110 | [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0110/definition.xml](<../../exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0110/definition.xml>) | TABCLASS, DDTEXT, 키 |
| <a id="d06"></a>D06 ZTHR0120 | [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0120/definition.xml](<../../exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0120/definition.xml>) | TABCLASS, DDTEXT, 키 |
| <a id="d07"></a>D07 PA9021 | [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/PA9021/definition.xml](<../../exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/PA9021/definition.xml>) | TABCLASS, DDTEXT, 키 |
| <a id="d08"></a>D08 PA9023 | [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/PA9023/definition.xml](<../../exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/PA9023/definition.xml>) | TABCLASS, DDTEXT, 키 |
| <a id="d09"></a>D09 ZHRDAEHUAMT | [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZHRDAEHUAMT/definition.xml](<../../exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZHRDAEHUAMT/definition.xml>) | TABCLASS, DDTEXT, 키 |
