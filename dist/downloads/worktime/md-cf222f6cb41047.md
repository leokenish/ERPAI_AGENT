# 추가 자료와 담당자 확인 사항

모든 항목은 **미해결**이다. 소스 사실과 운영 의도 사이의 차이를 확인하기 위한 목록이며, 이번 작업에서 SAP 변경·실행이나 재추출을 수행하지 않았다. 현재 초안은 ZHR5로 작성 완료하며 아래 확인은 후속 보완 사항이다.

## 1. 우선 확보할 자료

<a id="q01"></a>
### Q01. 요청 명칭 ZHR6과 실제 ZHR5의 업무 범위

- **[확인]** 로컬에는 exports/ZHR5만 있고 manifest·catalog가 모두 ZHR5다. 현재 적용은 ZHR5로 결정했다. [overview](overview.md#1-추출-범위와-품질)
- **확인할 내용:** 사용자가 의도한 HR 업무 범위가 이 ZHR5 추출물과 일치하는지, ZHR6이 별도 패키지인지.
- **자료·담당:** 패키지 담당자의 범위 설명 또는 ZHR6이 따로 필요할 경우 해당 manifest/catalog. 이름을 임의로 바꾸거나 원본을 재배치하지 않는다.

<a id="q02"></a>
### Q02. DDIC 추출 실패 객체

- **[확인]** `TABL ZHCMT_BSP_PA_XX_R9023`는 KO→EN 재시도 후 FAILED. SUBRC=0만으로 성공 판정할 수 없으며 GOTSTATE는 빈값이다. 진단에 AS4LOCAL=L, AS4VERS=0000, TABCLASS=INTTAB이 있다.
- **자료·담당:** ABAP/DDIC 담당자가 해당 시스템의 active 정의 여부와 SE11 상태·추출 API 응답을 확인하고 읽기 가능한 정의를 제공한다. L 값만으로 원인·폐기·수정 상태를 확정하지 않는다.
- **근거:** [processing.xml](../../exports/ZHR5/logs/processing.xml), [diagnostic-dd02l.xml](<../../exports/ZHR5/packages/ZHR5/Dictionary Object/TABL/ZHCMT_BSP_PA_XX_R9023/diagnostic-dd02l.xml>).

<a id="q03"></a>
### Q03. 제외된 웹 자산과 클래스·화면 정의

| 누락/제외 항목 | 확인한 경계 | 필요한 자료 |
| --- | --- | --- |
| SMIM 5BB028588DAE67D9E10000000A002438 | `/SAP/BC/BSP/SAP/ZEP0002/CSS`, ZEP1 소유 BSP 범위 밖 | 해당 자산을 사용하는 운영 화면/소유 패키지 범위 |
| SMIM 5C1C05554A724660E10000000A002438 | `/SAP/BC/BSP/SAP/ZEP0002/CSS/admin.css`, ZEP1 소유 BSP 범위 밖 | 필요 시 자산 및 공통 화면 |
| SMIM 5BD6DBE7454D51B7E10000000A002438 | `/SAP/BC/BSP/SAP/ZMOBILE_COMMON/mobilekobis/images/ico_schedule.png`, ZMOBILE 범위 밖 | 필요 시 모바일 공통 자산 |
| iam_icon.png / icon_history.png | Z52_FLEX_TIME 경로지만 web-assets상 ZHR1 소유 외부 참조 2건 | 필요 시 ZHR1 자산 |
| CLAS 3개 | ZCL_APP_ZEP002_IT_E, ZCL_HRPA_INFOTYPE_9021, ZCL_HRPA_INFOTYPE_9023 본문 미추출 | 업무에 필요한 메서드·인터페이스 본문 |
| TRAN 44개, SICF, Dynpro/GUI status | catalog 등록만 있거나 화면 정의 미직렬화 | 주요 T-code 실제 매핑, 화면 100 flow logic·status, 서비스 진입 설정 |

근거: [objects catalog](../../exports/ZHR5/catalog/objects.xml), [web-assets catalog](../../exports/ZHR5/catalog/web-assets.xml), [추출 README](../../exports/ZHR5/README.md). MIME 미추출과 업무 로직 미추출의 영향은 구분한다. 시각 자산만 확보해도 외부 업무 기능이 복원되지는 않는다.

<a id="q04"></a>
### Q04. 웹에서 함수까지의 호출 경로

- **[확인]** 계획/시간외 페이지는 함수 이름과 인수를 `ZWEB_COMMON/AJAX_COMMON.HTM`으로 전송한다. 이 dispatcher와 공통 유틸리티 본문은 없다. MAIN은 외부 ZMOBILE_ESS URL도 사용한다. [S01](object-map.md#s01), [S12](object-map.md#s12), [S18](object-map.md#s18)
- **자료·담당:** BSP/웹 담당자에게 해당 공통 페이지·유틸리티, 허용 함수 매핑, 사용자 식별·권한 확인 위치, 요청 시 커밋 경계를 요청한다.
- **미확인:** 실제 운영 시작 페이지와 메뉴, 호출이 통과하는 중간 처리. pages.xml의 IS_START_PAGE가 비어 있어 MAIN을 최초 화면으로 확정할 수 없다.

<a id="q05"></a>
### Q05. 워크플로와 결재자 선정

- **[확인]** ZWF_START_WORK_HR에 계획은 E, 시간외는 F를 전달한다. ZWF_DELETE·ZWF_APPROVE_WORK·ZWF_REJECT_WORK는 호출만 확인된다. [S03](object-map.md#s03), [S05](object-map.md#s05), [S15](object-map.md#s15)
- **자료·담당:** 워크플로 담당자에게 위 함수, ZWF0022/ZSWF0001 등의 필요한 정의, ZHR_CHECK_APPROVER_N·ZHR_52TM_CHECK_APPROVER_N의 규칙과 실제 1/2단계 결재 사례를 요청한다. 개인 식별정보를 제거한 사례면 충분하다.
- **확인할 내용:** ZHR_52TM_APPROVE_OT_DATA를 호출하는 주체, ZORDR별 의미, 중간/최종 승인 시 PA9021 반영 시점, 회수·반려·메일과 DB 변경의 연계. 외부 함수의 소유 패키지도 확인한다.

<a id="q06"></a>
### Q06. 상수·상태 도메인·근로유형 설정

- **[확인]** ZTHR0101 정의는 있지만 운영 행은 없다. 계획 상신과 미결 배치가 ZLIMIT을 사용한다. ZSTATE_1은 사용하지만 도메인 정의가 없다. [D01](object-map.md#d01), [S03](object-map.md#s03), [S06](object-map.md#s06)
- **자료·담당:** HR 제도/운영 담당자에게 ZLIMIT의 유효기간별 값과 변경 기준, ZTHR0105 주간 계획 설정, ZSTATE_1 전체 코드·설명, 운영 근로유형 적용 기준을 요청한다.
- **한계:** 코드값 0120=2주탄력 등은 확인되나 해당 조직의 현재 제도·직원 적용 범위까지 확인된 것은 아니다.

## 2. 소스와 운영 의도를 대조할 사항

<a id="q07"></a>
### Q07. 조건·주석·실제 사용의 차이

| 확인된 소스 사실 | 담당자에게 확인할 내용 | 근거 |
| --- | --- | --- |
| 계획 상신 검사는 주차별 필수시간과 계획시간이 `<>`이면 오류지만 주석은 미달 설명 | 초과도 막는 것이 의도인지, 어떤 계획유형에 적용하는지 | S03 903–923행 |
| ZRPTH401은 P_WKTP를 입력받지만 대상 SELECT에 쓰지 않음 | 실행 변형의 의도와 타 근로유형 포함 가능성 | S06 29–31, 56–61행 |
| GV_TOT 집계 뒤 WF 회수 실패 행을 제거하고 기존 GV_TOT을 완료 메시지에 사용 | 운영 모니터링이 무엇을 성공 건수로 판단하는지 | S06 90, 111–114, 132행 |
| 계획 페이지 주석에 회수 R, 함수 구현은 B | 운영에서 사용하는 회수 요청값 | S01 1634행, S02 165행 |
| ZRPTH402 헤더의 Transaction은 ZRh401 | 실제 SE93 매핑과 사용자 메뉴 | S07 4행 |
| ZRPTH404 제목에 (X), ZRPTH414도 간주근로 정산 제목 | 현행 프로그램과 미사용/사본 구분 | 각 프로그램의 texts XML; CSV title |

이는 소스 수정 요청이나 확정된 운영 장애 보고가 아니다. 담당자의 의도·사례를 확인한 뒤 지식 초안을 보완한다.

<a id="q08"></a>
### Q08. 정산 확정·취소의 커밋과 재처리

- **[확인]** ZRPTH402F01.confirm_data는 PA2010/ZTHR0110 변경 후 COMMIT하고 그 뒤 ZTHR0120을 변경한다. 취소 FORM에는 명시적 COMMIT이 없다. [S09](object-map.md#s09) 540–631, 814–923행
- **자료·담당:** ABAP·급여 운영 담당자에게 실제 화면 호출 구조와 오류/재실행 사례, 정산일·임금유형·AWREF 기준의 정합성 확인 절차를 요청한다.
- **확인할 내용:** 일부 단계만 반영된 경우의 판정·복구, 중복 확정 방지, 전표 이후 취소 정책, 잠금·동시 수행 제어. 이 초안은 전체 처리가 한 번에 롤백된다고 보장하지 않는다.

<a id="q09"></a>
### Q09. 시간·단가·소급 계산의 범위

- **[확인]** MONTHLY_PAYMENT의 계수 인수와 CALC_OT_AMOUNT 일부는 읽었다. 소스는 시간의 시·분을 분리하며 중간 변수에 소수점 1자리 타입을 쓴다. set_round_amt는 ROUND에 DECIMALS=1, SIGN='+'를 전달한다. [S10](object-map.md#s10), [S11](object-map.md#s11), [S03](object-map.md#s03)
- **[미검토]** ZHR_52TM_CALC_WEEK_TIME, CALC_WORK_TIME_DAYILY, GET_OVERTIME_DATA 등의 전체 계산 경로와 MONTHLY_PAYMENT 후반 소급 차액 처리.
- **자료·담당:** HR 급여 담당자의 익명 계산 예제(일반/야간/휴일/대휴/소급·취소), 단가·등급 설정, 반올림 규칙과 효력일. 소스 계수를 현행 법령 또는 사규 전체로 답하지 않는다.

<a id="q10"></a>
### Q10. 시간외 특수 분기와 상신 결과

- **[확인]** GET_OVERTIME_SAVE에는 대휴 2일 분할 시 직접 DB 변경, ZHRDAEHUAMT 읽기 후 삭제, ZNURAK가 있으면 승인 상태 설정 경로가 있다. [S14](object-map.md#s14)
- **[확인]** GET_OVERTIME_REQUEST의 2차 결재자 조건은 LS_ZTHRBS01-ZCOSA1이고 목록에 넣는 값은 LS_DATA다. 안식년 판정은 외부 함수 결과에 의존한다. [S15](object-map.md#s15) 24–92행
- **자료·담당:** 시간외 업무 담당자에게 ZTHRBS01 정의, 특수 입력 권한/절차, 2일 분할 및 2차 결재 성공·실패 사례, 안식년/E1 적용 기준을 요청한다.
- **미확인:** 이 조건의 의도, 전체 트랜잭션 경계, 분할 행의 반환/후속 상신 결과. 여기서 일반적인 1건 신청 규칙을 모든 특수 건에 확장하지 않는다.

<a id="q11"></a>
### Q11. 정보형 9021/9023과 추출되지 않은 클래스

- **[확인]** PA9021/PA9023 정의와 MP9021*/MP9023* 소스는 있으나 두 정보형 클래스 본문은 없다. PA9021 직접 갱신 경로만 일부 확인했다. [객체 지도](object-map.md#review-coverage)
- **자료·담당:** 정보형 담당자가 클래스 메서드, 필수 입력·유효기간/중복·권한 검사 위치와 실제 화면/운영 절차를 제공한다.
- **[미검토]** MP 프로그램 전체와 PA9023의 업무 연결. 정보형 검증이 모든 직접 DB 쓰기 경로에 적용된다고 추정하지 않는다.

<a id="q12"></a>
### Q12. PA2010 이후 회계·지급 연결

- **[확인]** ZRPTH402가 PA2010/8030을 구성하며 ZRPTH2012_M의 일부 FORM이 PA2010 조회 및 AWREF 갱신을 수행한다. [F04](flows.md#f04), [F06](flows.md#f06)
- **자료·담당:** FI·급여 담당자의 실행 순서, 실제 임금유형 선택, 전표 성공·실패 및 취소 사례, 관련 외부 함수·FI 패키지 추출 범위.
- **[미검토]** 전체 전표·역분개·EDI·은행 지급·급여 처리. 헤더 주석만으로 회계 처리 완료를 설명하지 않는다.

<a id="q13"></a>
### Q13. 운영 진입점·잡과 이번 미검토 영역

- **자료·담당:** HR 운영 담당자의 현행 메뉴/T-code 목록, 주요 배치의 잡명·변형·주기·선후행 관계, 사용하지 않는 화면/프로그램 구분을 요청한다. 사용자 명단이나 개인 급여 내역 전체는 필요하지 않다.
- **[미검토]** 선택근로, 재량근로, 간주근로, 한도알림/SMS, 대휴, 리소스·근무정보 연계, 대부분의 BSP 페이지·MIME 및 DDIC 필드 상세. 목록은 [object-map 검토 범위](object-map.md#review-coverage)와 CSV review_scope를 기준으로 한다.

## 3. 다음 조사 순서

1. Q02–Q06의 자료로 실제 진입점·공통 dispatcher·WF·필수 테이블/도메인 공백을 먼저 보완한다.
2. `ZHR_52TM_REAL_WORK_TIME`의 실적 입력부터 `ZHR_52TM_APPROVE_OT_DATA`의 R 분기·월정산까지 연결한다. 현재 이 구간의 전체 흐름은 미검토다.
3. Q08–Q10에 맞춰 시간계산/금액 계산과 정산·상신 특수 사례를 소스와 비교한다.
4. 선택근로(ZRPTH411, ZHR008_3) → 재량/간주근로 → 알림·대휴 → 근무정보 외부 연계 순으로 확장한다. 실제 운영 우선순위가 주어지면 조정한다.
5. FI 연결은 ZRPTH2012_M 전체 분석과 추가 패키지 범위 확인 뒤 별도 지식으로 확장한다. ZFI·ZMM이 현재 폴더에 있다고 가정하지 않는다.

담당자 확인을 기록할 때는 항목 ID, 확인일, 담당 역할, 적용 시스템/유효기간, 근거 자료, 확정 내용과 남은 예외를 함께 남긴다.
