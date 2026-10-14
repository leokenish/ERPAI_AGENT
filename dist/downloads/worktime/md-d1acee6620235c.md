# 선택근로 테이블 참조 목록 — 2026-09-21

**검토 수준: 부분 검토.** 선택근로 관련 객체의 SQL 참조 위치와 DDIC 정의를 확인했다. 모든 함수·분기 본문을 검토 완료한 목록이 아니며, SAP 실행·운영 사용은 검증하지 않았다.

## 범위

- ZRPTH410/411/413/440 및 이름이 이어지는 프로그램 include.
- ZHR008_3의 함수 11개와 F include. 함수 API 소스와 U include 중복은 세지 않았다.
- 공휴일·시간 계산 연결인 ZHR_52TM_AWART_LIST, ZHR_52TM_CALC_WORK_TIME_DAYILY.
- 주석을 제외한 SQL 참조 후보를 추출하고 내부 테이블을 제외했다. 호출 대상 전체의 재귀 조사, 동적 SQL, 표준 함수·외부 함수 내부 테이블은 포함하지 않는다.
- ZHR_WF_GET_MY_LIST는 공통 결재함이다. ZTHR0106/0110은 그 함수의 탄력근로 분기 참조이며 선택근로 전용으로 분류하지 않는다.

## 핵심 DDIC

- **[확인] ZTHR0132**: [52시간] 선택근로제 기간; `TABCLASS=TRANSP`. 키: MANDT, PERNR, BEGDA, ENDDA, Z52WKTP, Z52PRSQ. 근거: [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0132/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0132/definition.xml), `DD02V_WA` 및 `KEYFLAG=X` 필드.
- **[확인] ZTHR0112**: [52시간] 선택근로제 실적관리; `TABCLASS=TRANSP`. 키: MANDT, PERNR, DATUM, BEGDA, ENDDA, Z52WKTP, Z52PRSQ, SEQNR. 근거: [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0112/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0112/definition.xml), `DD02V_WA` 및 `KEYFLAG=X` 필드.
- **[확인] ZTHR0113**: [52시간] 선택근로제 정산확정; `TABCLASS=TRANSP`. 키: MANDT, ZADMIT_YM, PERNR, BEGDA, ENDDA, Z52WKTP, Z52PRSQ. 근거: [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0113/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0113/definition.xml), `DD02V_WA` 및 `KEYFLAG=X` 필드.
- **[확인] PA9021**: HR 마스터레코드: 정보형 9021; `TABCLASS=TRANSP`. 키: MANDT, .INCLUDE, PERNR, SUBTY, OBJPS, SPRPS, ENDDA, BEGDA, SEQNR. 근거: [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/PA9021/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/PA9021/definition.xml), `DD02V_WA` 및 `KEYFLAG=X` 필드.
- **[확인] ZTHR0101**: [52시간] 유연근무 상수값관리; `TABCLASS=TRANSP`. 키: MANDT, ZCONST, ENDDA. 근거: [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0101/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0101/definition.xml), `DD02V_WA` 및 `KEYFLAG=X` 필드.
- **[확인] ZTHR0104**: [52시간] 유연근로 정산기간관리; `TABCLASS=TRANSP`. 키: MANDT, Z52WKTP, Z52PRSQ. 근거: [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0104/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0104/definition.xml), `DD02V_WA` 및 `KEYFLAG=X` 필드.
- **[확인] ZTHR0160**: [52시간] 시간외 정산 마감 여부 체크; `TABCLASS=TRANSP`. 키: MANDT, ZMONTH, Z52WKTP. 근거: [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0160/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0160/definition.xml), `DD02V_WA` 및 `KEYFLAG=X` 필드.
- **[확인] ZTHR0124**: [52시간] I AM 등록; `TABCLASS=TRANSP`. 키: MANDT, ZSEQ, PERNR. 근거: [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0124/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0124/definition.xml), `DD02V_WA` 및 `KEYFLAG=X` 필드.

## SQL 참조 위치

이 범위에서 확인한 이름은 **31개**다. 정의 미추출 객체는 DB 조회·변경 대상 이름만 확인했으며 실제 TABCLASS, 전체 필드, 소유 패키지는 미확인이다.

### DD07T

[확인] 아래 SQL의 참조 대상. [확인 필요] 정의 미추출, 소유 패키지 미확인.

- `FROM dd07t`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F02/source/ZRPTH411F02.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F02/source/ZRPTH411F02.abap), 객체 `ZRPTH411F02`, 89행.
- `FROM dd07t`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap), 객체 `ZRPTH413F01`, 178행.

### PA0000

[확인] 아래 SQL의 참조 대상. [확인 필요] 정의 미추출, 소유 패키지 미확인.

- `FROM pa0000`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap), 객체 `LZHR008_3F01`, 127행.
- `FROM pa0000`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap), 객체 `LZHR008_3F01`, 668행.

### PA0001

[확인] 아래 SQL의 참조 대상. [확인 필요] 정의 미추출, 소유 패키지 미확인.

- `FROM pa0001`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_WF_GET_MY_LIST/Source code/ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap), 객체 `ZHR_WF_GET_MY_LIST`, 371행.
- `FROM pa0001`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap), 객체 `LZHR008_3F03`, 820행.
- `JOIN pa0001`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap), 객체 `ZRPTH410F01`, 208행.
- `FROM pa0001`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap), 객체 `ZRPTH410F01`, 841행.
- `JOIN pa0001`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap), 객체 `ZRPTH410F01`, 1498행.
- `JOIN pa0001`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap), 객체 `ZRPTH410F01`, 1639행.
- 나머지 7개 참조 위치는 이 요약에서 생략.

### PA0008

[확인] 아래 SQL의 참조 대상. [확인 필요] 정의 미추출, 소유 패키지 미확인.

- `FROM pa0008`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap), 객체 `ZRPTH413F01`, 581행.

### PA2010

[확인] 아래 SQL의 참조 대상. [확인 필요] 정의 미추출, 소유 패키지 미확인.

- `FROM pa2010`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411/source/ZRPTH411.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411/source/ZRPTH411.abap), 객체 `ZRPTH411`, 154행.
- `MODIFY pa2010`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap), 객체 `ZRPTH411F01`, 737행.
- `FROM pa2010`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap), 객체 `ZRPTH411F01`, 1206행.

### PA9021

[확인] HR 마스터레코드: 정보형 9021, `TABCLASS=TRANSP`. DDIC: [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/PA9021/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/PA9021/definition.xml).

- `FROM pa9021`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_52TM_CW_PROCESS_DATA/Source code/ZHR_52TM_CW_PROCESS_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Source%20code/ZHR_52TM_CW_PROCESS_DATA.abap), 객체 `ZHR_52TM_CW_PROCESS_DATA`, 28행.
- `FROM pa9021`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap), 객체 `LZHR008_3F01`, 24행.
- `FROM pa9021`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap), 객체 `ZRPTH410F01`, 208행.
- `FROM pa9021`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap), 객체 `ZRPTH410F01`, 981행.
- `FROM pa9021`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap), 객체 `ZRPTH410F01`, 1498행.
- `FROM pa9021`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap), 객체 `ZRPTH410F01`, 1639행.

### T503T

[확인] 아래 SQL의 참조 대상. [확인 필요] 정의 미추출, 소유 패키지 미확인.

- `FROM t503t`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap), 객체 `ZRPTH411F01`, 73행.
- `FROM t503t`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap), 객체 `ZRPTH411F01`, 840행.
- `FROM t503t`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap), 객체 `ZRPTH411F01`, 943행.
- `FROM t503t`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap), 객체 `ZRPTH411F01`, 1067행.
- `FROM t503t`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap), 객체 `ZRPTH413F01`, 574행.

### T512T

[확인] 아래 SQL의 참조 대상. [확인 필요] 정의 미추출, 소유 패키지 미확인.

- `FROM t512t`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap), 객체 `ZRPTH411F01`, 1006행.

### T527X

[확인] 아래 SQL의 참조 대상. [확인 필요] 정의 미추출, 소유 패키지 미확인.

- `FROM t527x`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH413F01/source/ZRPTH413F01.abap), 객체 `ZRPTH413F01`, 557행.
- `FROM t527x`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap), 객체 `ZRPTH440`, 181행.
- `FROM T527X`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap), 객체 `ZRPTH440`, 431행.

### ZHRT001

[확인] 아래 SQL의 참조 대상. [확인 필요] 정의 미추출, 소유 패키지 미확인.

- `JOIN zhrt001`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function Module/ZHR_52TM_AWART_LIST/Source code/ZHR_52TM_AWART_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_AWART_LIST/Source%20code/ZHR_52TM_AWART_LIST.abap), 객체 `ZHR_52TM_AWART_LIST`, 307행.
- `JOIN zhrt001`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap), 객체 `LZHR008_3F01`, 191행.
- `JOIN zhrt001`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap), 객체 `LZHR008_3F01`, 716행.

### ZHRT002

[확인] 아래 SQL의 참조 대상. [확인 필요] 정의 미추출, 소유 패키지 미확인.

- `FROM zhrt002`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function Module/ZHR_52TM_AWART_LIST/Source code/ZHR_52TM_AWART_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_AWART_LIST/Source%20code/ZHR_52TM_AWART_LIST.abap), 객체 `ZHR_52TM_AWART_LIST`, 306행.
- `FROM ZHRT002`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function Module/ZHR_52TM_AWART_LIST/Source code/ZHR_52TM_AWART_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_AWART_LIST/Source%20code/ZHR_52TM_AWART_LIST.abap), 객체 `ZHR_52TM_AWART_LIST`, 325행.
- `FROM zhrt002`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap), 객체 `LZHR008_3F01`, 191행.
- `FROM zhrt002`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap), 객체 `LZHR008_3F01`, 716행.

### ZTH0076

[확인] 아래 SQL의 참조 대상. [확인 필요] 정의 미추출, 소유 패키지 미확인.

- `FROM zth0076`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap), 객체 `ZRPTH440`, 155행.
- `FROM zth0076`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH440/source/ZRPTH440.abap), 객체 `ZRPTH440`, 265행.

### ZTH0500

[확인] 아래 SQL의 참조 대상. [확인 필요] 정의 미추출, 소유 패키지 미확인.

- `FROM zth0500`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_WF_GET_MY_LIST/Source code/ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap), 객체 `ZHR_WF_GET_MY_LIST`, 373행.
- `FROM zth0500`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap), 객체 `ZRPTH410F01`, 242행.
- `FROM zth0500`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap), 객체 `ZRPTH410F01`, 849행.
- `FROM zth0500`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap), 객체 `ZRPTH410F01`, 1530행.
- `FROM zth0500`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap), 객체 `ZRPTH410F01`, 1689행.
- `FROM zth0500`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411/source/ZRPTH411.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411/source/ZRPTH411.abap), 객체 `ZRPTH411`, 186행.
- 나머지 1개 참조 위치는 이 요약에서 생략.

### ZTHR0081

[확인] 아래 SQL의 참조 대상. [확인 필요] 정의 미추출, 소유 패키지 미확인.

- `FROM zthr0081`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function Module/ZHR_52TM_AWART_LIST/Source code/ZHR_52TM_AWART_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_AWART_LIST/Source%20code/ZHR_52TM_AWART_LIST.abap), 객체 `ZHR_52TM_AWART_LIST`, 75행.

### ZTHR0081_2

[확인] 아래 SQL의 참조 대상. [확인 필요] 정의 미추출, 소유 패키지 미확인.

- `FROM zthr0081_2`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function Module/ZHR_52TM_AWART_LIST/Source code/ZHR_52TM_AWART_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_AWART_LIST/Source%20code/ZHR_52TM_AWART_LIST.abap), 객체 `ZHR_52TM_AWART_LIST`, 81행.

### ZTHR0101

[확인] [52시간] 유연근무 상수값관리, `TABCLASS=TRANSP`. DDIC: [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0101/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0101/definition.xml).

- `FROM zthr0101`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function Module/ZHR_52TM_AWART_LIST/Source code/ZHR_52TM_AWART_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_AWART_LIST/Source%20code/ZHR_52TM_AWART_LIST.abap), 객체 `ZHR_52TM_AWART_LIST`, 90행.
- `FROM zthr0101`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Source code/ZHR_52TM_CALC_WORK_TIME_DAYILY.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CALC_WORK_TIME_DAYILY/Source%20code/ZHR_52TM_CALC_WORK_TIME_DAYILY.abap), 객체 `ZHR_52TM_CALC_WORK_TIME_DAYILY`, 556행.
- `FROM zthr0101`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap), 객체 `ZRPTH410F01`, 309행.

### ZTHR0104

[확인] [52시간] 유연근로 정산기간관리, `TABCLASS=TRANSP`. DDIC: [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0104/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0104/definition.xml).

- `FROM zthr0104`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F02/source/ZRPTH411F02.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F02/source/ZRPTH411F02.abap), 객체 `ZRPTH411F02`, 84행.

### ZTHR0106

[확인] [52시간] 탄력근로 계획관리 - 기간(Header), `TABCLASS=TRANSP`. DDIC: [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0106/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0106/definition.xml).

- `from ZTHR0106`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_WF_GET_MY_LIST/Source code/ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap), 객체 `ZHR_WF_GET_MY_LIST`, 142행.

### ZTHR0110

[확인] [52시간] 탄력근로 실적관리, `TABCLASS=TRANSP`. DDIC: [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0110/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0110/definition.xml).

- `from ZTHR0110`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_WF_GET_MY_LIST/Source code/ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap), 객체 `ZHR_WF_GET_MY_LIST`, 148행.

### ZTHR0112

[확인] [52시간] 선택근로제 실적관리, `TABCLASS=TRANSP`. DDIC: [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0112/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0112/definition.xml).

- `FROM zthr0112`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_52TM_CW_BASE_DATA/Source code/ZHR_52TM_CW_BASE_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Source%20code/ZHR_52TM_CW_BASE_DATA.abap), 객체 `ZHR_52TM_CW_BASE_DATA`, 77행.
- `FROM zthr0112`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_52TM_CW_CAL_AND_DAEH/Source code/ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap), 객체 `ZHR_52TM_CW_CAL_AND_DAEH`, 233행.
- `UPDATE zthr0112`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_52TM_CW_PROCESS_DATA2/Source code/ZHR_52TM_CW_PROCESS_DATA2.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA2/Source%20code/ZHR_52TM_CW_PROCESS_DATA2.abap), 객체 `ZHR_52TM_CW_PROCESS_DATA2`, 48행.
- `FROM zthr0112`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_52TM_CW_PROCESS_DATA2/Source code/ZHR_52TM_CW_PROCESS_DATA2.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA2/Source%20code/ZHR_52TM_CW_PROCESS_DATA2.abap), 객체 `ZHR_52TM_CW_PROCESS_DATA2`, 55행.
- `from ZTHR0112`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_WF_GET_MY_LIST/Source code/ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap), 객체 `ZHR_WF_GET_MY_LIST`, 158행.
- `FROM zthr0112`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap), 객체 `LZHR008_3F01`, 157행.
- 나머지 29개 참조 위치는 이 요약에서 생략.

### ZTHR0113

[확인] [52시간] 선택근로제 정산확정, `TABCLASS=TRANSP`. DDIC: [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0113/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0113/definition.xml).

- `FROM zthr0113`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_52TM_CW_PAYMENT_WKPRD/Source code/ZHR_52TM_CW_PAYMENT_WKPRD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Source%20code/ZHR_52TM_CW_PAYMENT_WKPRD.abap), 객체 `ZHR_52TM_CW_PAYMENT_WKPRD`, 61행.
- `FROM zthr0113`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411/source/ZRPTH411.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411/source/ZRPTH411.abap), 객체 `ZRPTH411`, 141행.
- `MODIFY zthr0113`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap), 객체 `ZRPTH411F01`, 780행.
- `DELETE FROM zthr0113`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap), 객체 `ZRPTH411F01`, 1256행.

### ZTHR0124

[확인] [52시간] I AM 등록, `TABCLASS=TRANSP`. DDIC: [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0124/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0124/definition.xml).

- `FROM zthr0124`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap), 객체 `LZHR008_3F03`, 1029행.

### ZTHR0132

[확인] [52시간] 선택근로제 기간, `TABCLASS=TRANSP`. DDIC: [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0132/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0132/definition.xml).

- `FROM zthr0132`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_52TM_CW_BASE_DATA/Source code/ZHR_52TM_CW_BASE_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_BASE_DATA/Source%20code/ZHR_52TM_CW_BASE_DATA.abap), 객체 `ZHR_52TM_CW_BASE_DATA`, 61행.
- `FROM zthr0132`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_52TM_CW_PAYMENT_WKPRD/Source code/ZHR_52TM_CW_PAYMENT_WKPRD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Source%20code/ZHR_52TM_CW_PAYMENT_WKPRD.abap), 객체 `ZHR_52TM_CW_PAYMENT_WKPRD`, 79행.
- `FROM zthr0132`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_52TM_CW_PAYMENT_WKPRD/Source code/ZHR_52TM_CW_PAYMENT_WKPRD.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PAYMENT_WKPRD/Source%20code/ZHR_52TM_CW_PAYMENT_WKPRD.abap), 객체 `ZHR_52TM_CW_PAYMENT_WKPRD`, 114행.
- `FROM zthr0132`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_52TM_CW_PROCESS_DATA/Source code/ZHR_52TM_CW_PROCESS_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Source%20code/ZHR_52TM_CW_PROCESS_DATA.abap), 객체 `ZHR_52TM_CW_PROCESS_DATA`, 24행.
- `FROM zthr0132`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap), 객체 `LZHR008_3F01`, 40행.
- `FROM zthr0132`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap), 객체 `LZHR008_3F03`, 1010행.
- 나머지 6개 참조 위치는 이 요약에서 생략.

### ZTHR0160

[확인] [52시간] 시간외 정산 마감 여부 체크, `TABCLASS=TRANSP`. DDIC: [exports/ZHR5/packages/ZHR5/Dictionary Object/DBtable/ZTHR0160/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0160/definition.xml).

- `FROM ZTHR0160`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_52TM_CW_PROCESS_DATA/Source code/ZHR_52TM_CW_PROCESS_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA/Source%20code/ZHR_52TM_CW_PROCESS_DATA.abap), 객체 `ZHR_52TM_CW_PROCESS_DATA`, 36행.
- `FROM zthr0160`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap), 객체 `ZRPTH411F01`, 549행.
- `DELETE FROM zthr0160`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH411F01/source/ZRPTH411F01.abap), 객체 `ZRPTH411F01`, 587행.

### ZTHRBS01

[확인] 아래 SQL의 참조 대상. [확인 필요] 정의 미추출, 소유 패키지 미확인.

- `FROM zthrbs01`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function Module/ZHR_52TM_AWART_LIST/Source code/ZHR_52TM_AWART_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_AWART_LIST/Source%20code/ZHR_52TM_AWART_LIST.abap), 객체 `ZHR_52TM_AWART_LIST`, 279행.
- `FROM zthrbs01`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap), 객체 `LZHR008_3F03`, 644행.
- `FROM zthrbs01`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap), 객체 `ZRPTH410F01`, 1234행.
- `FROM zthrbs01`: [exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap), 객체 `ZRPTH410F01`, 1346행.

### ZTHRBS05

[확인] 아래 SQL의 참조 대상. [확인 필요] 정의 미추출, 소유 패키지 미확인.

- `FROM zthrbs05`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_52TM_CW_CAL_AND_DAEH/Source code/ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap), 객체 `ZHR_52TM_CW_CAL_AND_DAEH`, 2048행.

### ZTHRBS08

[확인] 아래 SQL의 참조 대상. [확인 필요] 정의 미추출, 소유 패키지 미확인.

- `FROM zthrbs08`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap), 객체 `LZHR008_3F01`, 180행.
- `FROM zthrbs08`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap), 객체 `LZHR008_3F01`, 705행.

### ZTHRBS13

[확인] 아래 SQL의 참조 대상. [확인 필요] 정의 미추출, 소유 패키지 미확인.

- `FROM zthrbs13`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function Module/ZHR_52TM_AWART_LIST/Source code/ZHR_52TM_AWART_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_AWART_LIST/Source%20code/ZHR_52TM_AWART_LIST.abap), 객체 `ZHR_52TM_AWART_LIST`, 420행.
- `FROM zthrbs13`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap), 객체 `LZHR008_3F01`, 229행.
- `FROM zthrbs13`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap), 객체 `LZHR008_3F01`, 753행.

### ZTHRCOST

[확인] 아래 SQL의 참조 대상. [확인 필요] 정의 미추출, 소유 패키지 미확인.

- `FROM zthrcost`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_52TM_CW_CAL_AND_DAEH/Source code/ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap), 객체 `ZHR_52TM_CW_CAL_AND_DAEH`, 2051행.
- `FROM zthrcost`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_52TM_CW_CAL_AND_DAEH/Source code/ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap), 객체 `ZHR_52TM_CW_CAL_AND_DAEH`, 2066행.
- `FROM zthrcost`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F02.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F02.abap), 객체 `LZHR008_3F02`, 609행.

### ZWF0022

[확인] 아래 SQL의 참조 대상. [확인 필요] 정의 미추출, 소유 패키지 미확인.

- `FROM zwf0022`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_52TM_CW_CAL_AND_DAEH/Source code/ZHR_52TM_CW_CAL_AND_DAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_CAL_AND_DAEH/Source%20code/ZHR_52TM_CW_CAL_AND_DAEH.abap), 객체 `ZHR_52TM_CW_CAL_AND_DAEH`, 252행.
- `UPDATE zwf0022`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_52TM_CW_PROCESS_DATA2/Source code/ZHR_52TM_CW_PROCESS_DATA2.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_52TM_CW_PROCESS_DATA2/Source%20code/ZHR_52TM_CW_PROCESS_DATA2.abap), 객체 `ZHR_52TM_CW_PROCESS_DATA2`, 53행.
- `FROM ZWF0022`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_WF_GET_MY_LIST/Source code/ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap), 객체 `ZHR_WF_GET_MY_LIST`, 112행.
- `FROM ZWF0022`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_WF_GET_MY_LIST/Source code/ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap), 객체 `ZHR_WF_GET_MY_LIST`, 119행.
- `FROM ZWF0022`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_WF_GET_MY_LIST/Source code/ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap), 객체 `ZHR_WF_GET_MY_LIST`, 310행.
- `FROM ZWF0022`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_WF_GET_MY_LIST/Source code/ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap), 객체 `ZHR_WF_GET_MY_LIST`, 412행.
- 나머지 2개 참조 위치는 이 요약에서 생략.

### ZWF_OLD_URL_LIST

[확인] 아래 SQL의 참조 대상. [확인 필요] 정의 미추출, 소유 패키지 미확인.

- `FROM zwf_old_url_list`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_WF_GET_MY_LIST/Source code/ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap), 객체 `ZHR_WF_GET_MY_LIST`, 76행.
- `FROM zwf_old_url_list`: [exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function Module/ZHR_WF_GET_MY_LIST/Source code/ZHR_WF_GET_MY_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Function%20Module/ZHR_WF_GET_MY_LIST/Source%20code/ZHR_WF_GET_MY_LIST.abap), 객체 `ZHR_WF_GET_MY_LIST`, 81행.

## 구조와 선언 참조의 구별

다음은 정의상 `INTTAB` 구조이며 DB 테이블 목록에 합산하지 않는다.

- [확인] `ZSHR0111`: `INTTAB`, [52시간] 근태신청내역. [exports/ZHR5/packages/ZHR5/Dictionary Object/Structures/ZSHR0111/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0111/definition.xml).
- [확인] `ZSHR0132_WEB`: `INTTAB`, [52시간]  선택근로 레포트용 구조. [exports/ZHR5/packages/ZHR5/Dictionary Object/Structures/ZSHR0132_WEB/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0132_WEB/definition.xml).
- [확인] `ZSHR0137`: `INTTAB`, [52시간] 근로기간의 시간(분). [exports/ZHR5/packages/ZHR5/Dictionary Object/Structures/ZSHR0137/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0137/definition.xml).
- [확인] `ZSHR0138`: `INTTAB`, [52시간] 근로기간별 상태/근무시간/총근로시간/근태. [exports/ZHR5/packages/ZHR5/Dictionary Object/Structures/ZSHR0138/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0138/definition.xml).
- [확인] `ZSHR0141`: `INTTAB`, [52시간] 실적항목. [exports/ZHR5/packages/ZHR5/Dictionary Object/Structures/ZSHR0141/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0141/definition.xml).
- [확인] `ZSHR0143`: `INTTAB`, [52시간] 등급/단가. [exports/ZHR5/packages/ZHR5/Dictionary Object/Structures/ZSHR0143/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0143/definition.xml).
- [확인] `ZSHR0144`: `INTTAB`, [52시간] 총근로/소정근로/연장(가능)/미상신/결재중/승인. [exports/ZHR5/packages/ZHR5/Dictionary Object/Structures/ZSHR0144/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0144/definition.xml).
- [확인] `ZSHR0146`: `INTTAB`, [52시간] 선택근로 대휴정보. [exports/ZHR5/packages/ZHR5/Dictionary Object/Structures/ZSHR0146/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0146/definition.xml).
- [확인] `ZSWF0016`: `INTTAB`, [WF] EP 결재함 (선택근로제 목록). [exports/ZHR5/packages/ZHR5/Dictionary Object/Structures/ZSWF0016/definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSWF0016/definition.xml).

`T510`, `ZWF0001`, `ZWF0035`, `ZWF1000` 등은 이 조사에서 선언·타입 참조가 확인되었으나, 위 범위에서 직접 SQL 사용을 확인하지 못했다. 실제 데이터 접근 대상과 구별한다.

## 공휴일 경계

- [확인] ZHR_52TM_AWART_LIST 98–108행은 DAY_ATTRIBUTES_GET에 KR/KB와 기간을 전달한다. 472–489행에서 주중공휴일 목록을 구성한다.
- [확인] ZRPTH410F01.get_period_holiday_hour 433–468행에서 공휴일 시간 합계를 계산한다. 정산 함수 ZHR_52TM_CW_CAL_AND_DAEH 159–160, 220–223행은 기간의 HODHR를 변환·차감한다.
- [확인 필요] SAP 달력의 실제 운영 값과 표준 함수 내부 테이블은 미확인. 달력 내부 테이블 이름을 추정하여 목록에 넣지 않았다.

## 미검토 경계

호출 함수 내부의 추가 테이블, BSP event·외부 dispatcher, 선택근로 실적 승인에 연결될 수 있는 ZHR008_2 함수의 전체 분기, 동적 참조는 추가 조사 대상이다. 따라서 이 목록을 SAP 전체의 완전한 의존 목록으로 해석하지 않는다.
