*&---------------------------------------------------------------------*
*&  Include           ZRPTH415F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  INIT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM init_data .
**  if p_frdat is initial.
**    p_frdat = sy-datum.
**  endif.


*  CALL FUNCTION 'HR_IN_LAST_DAY_OF_MONTHS'
*    EXPORTING
*      day_in            = p_frdat
*    IMPORTING
*      last_day_of_month = p_todat
*    EXCEPTIONS
*      day_in_no_date    = 1
*      OTHERS            = 2.

  gt_title-text = '사번'. APPEND gt_title.
  gt_title-text = '이름'. APPEND gt_title.
  gt_title-text = '직급'. APPEND gt_title.
  gt_title-text = '직위'. APPEND gt_title.
  gt_title-text = '코스트센터'. APPEND gt_title.
  gt_title-text = '입력구분'. APPEND gt_title.
  gt_title-text = '근무일'. APPEND gt_title.
*  gt_title-text = '부서명1'. APPEND gt_title.
*  gt_title-text = '부서명2'. APPEND gt_title.
  gt_title-text = '시작 시간'. APPEND gt_title.
  gt_title-text = '종료 시간'. APPEND gt_title.
  gt_title-text = '익일여부'. APPEND gt_title.
  gt_title-text = '대휴/보상 여부'. APPEND gt_title.
  gt_title-text = '휴가 발생일 근무시간'. APPEND gt_title.
  gt_title-text = '휴가 발생일 휴일근무실비'. APPEND gt_title.
  gt_title-text = '대휴/보상 휴가 발생일'. APPEND gt_title.
  gt_title-text = '대휴/보상 사용시작일'. APPEND gt_title.
  gt_title-text = '대휴/보상 사용종료일'. APPEND gt_title.
  gt_title-text = '대휴/보상 사용여부'. APPEND gt_title.
  gt_title-text = '대휴/보상 사용일'. APPEND gt_title.
  gt_title-text = '정산금액'. APPEND gt_title.
  gt_title-text = '대휴/보상 정산여부'. APPEND gt_title.


ENDFORM.                    " INIT_DATA
*&---------------------------------------------------------------------*
*&      Form  F4_ORGEH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f4_orgeh USING p_orgeh.
  DATA: lv_realo LIKE objec-realo.

  CALL FUNCTION 'RH_DETERMINE_ORG_OBJID'
    EXPORTING
      org_object_type       = 'O'
      act_plvar             = '01'
      f4_mode               = 'X'
      seark_begda           = p_frdat
      seark_endda           = p_frdat
    IMPORTING
      org_object_objid      = lv_realo
    EXCEPTIONS
      no_active_plvar       = 1
      no_object_id_selected = 2
      OTHERS                = 3.

  IF sy-subrc = 0.
    p_orgeh = lv_realo.
  ENDIF.
ENDFORM.                    " F4_ORGEH
*&---------------------------------------------------------------------*
*&      Form  basic_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM basic_data .

  DATA: tmp_zdung TYPE zthrbs05-zdung.
  DATA: lv_manager(1) TYPE c.
  DATA: lv_jikwidung TYPE pa0001-jikwidung.
  DATA:  lv_jikwigubun TYPE pa0001-jikwigubun.

  IF p_frdat IS INITIAL.
    gv_stop = 'X'.
*    MESSAGE s001 DISPLAY LIKE 'E' WITH '검색기간을 입력하십시오.'.
    MESSAGE s001 DISPLAY LIKE 'E' WITH '대휴/보상 정산 종료일을 입력하십시오.'.
    RETURN.
  ENDIF.

  CLEAR: gt_disp, gt_disp[].

  "전체 사용자
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE lt_pa0001
    FROM pa0001
   WHERE pernr IN s_pernr
     AND begda <= p_frdat
     AND endda >= p_frdat
     AND vdsk1 IN s_orgeh.

  SORT lt_pa0001 BY pernr.

IF rb3 = 'X'.
  CHECK lt_pa0001[] IS NOT INITIAL.
* 기준테이블 실적 있는 모든 데이터 표기
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE lt_tmp
    FROM zthrbs01
      FOR ALL ENTRIES IN lt_pa0001
   WHERE pernr = lt_pa0001-pernr
     AND state = '3'
     AND zdend =  p_frdat
     AND zdaeh = 'Y'
     AND jorgeh_txt = ''.
*     AND ( zsourflex <> 'T' OR zsourflex <> 'Z' ). " 간주 기타

"20220615-나구엽-교대근무자들은 2023년 7월 쯤 보상휴가 정산 예정이라 일단 제외
* 교대 근무 보상 휴가 추가
ELSEIF rb4 = 'X'.

  DATA : it0006 TYPE TABLE OF ZTHR2006_date WITH HEADER LINE.
  DATA : wa_pa2010 TYPE pa2010.
  DATA : wa_myinfo TYPE zthr_kobis_data.
  DATA : wa_pa0001 TYPE pa0001.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE it0006 FROM ZTHR2006_date
    FOR ALL ENTRIES IN lt_pa0001
    WHERE pernr = lt_pa0001-pernr AND DEEND = p_frdat AND insdat >= '20220506'. "2022년 5월 정산부터 기준 변경

  LOOP AT it0006.
"교대근무 정산 데이터가 있는지 확인
 SELECT SINGLE * INTO CORRESPONDING FIELDS OF  wa_pa2010 FROM pa2010 WHERE pernr =  it0006-pernr AND begda =  p_datum AND endda = p_datum.
   IF sy-subrc NE 0.

    lt_tmp-pernr = it0006-pernr.
    lt_tmp-begda = it0006-begda.
    lt_tmp-endda = it0006-endda.


    SELECT SINGLE * INTO wa_myinfo FROM zthr_kobis_data
      WHERE ( pernr = it0006-pernr ) AND ( persgx <> '' ).
    IF sy-subrc = 0.   "재직자
      lt_tmp-ename = wa_myinfo-ename.
      lt_tmp-vdsk1 = wa_myinfo-vdsk1.
      lt_tmp-orgeh = wa_myinfo-orgeh.
      lt_tmp-orgeh_txt = wa_myinfo-orgehx.
      lt_tmp-vdsk1_txt = wa_myinfo-vdsk1x.
    ELSE.  "퇴직자
      SELECT SINGLE * INTO CORRESPONDING FIELDS OF wa_pa0001 FROM pa0001
        WHERE pernr =  it0006-pernr AND persg = '2'.
        IF sy-subrc = 0.
           lt_tmp-ename = wa_pa0001-ename.
           lt_tmp-orgeh = wa_pa0001-orgeh.
           SELECT SINGLE text1 INTO  lt_tmp-orgeh_txt FROM zth0500
             WHERE objid = wa_pa0001-orgeh.
           lt_tmp-vdsk1 = wa_pa0001-vdsk1.
           SELECT SINGLE text2 INTO  lt_tmp-vdsk1_txt FROM zth0500
             WHERE objid = wa_pa0001-vdsk1.
        ENDIF.

    ENDIF.

    lt_tmp-rdate = it0006-begda.
    lt_tmp-znal = it0006-begda.
    lt_tmp-zdday = it0006-begda.

    lt_tmp-zdbeg = it0006-desta.
    lt_tmp-zdend = it0006-deend.

    "미보상 휴가 사용여부
    IF it0006-h_date IS NOT INITIAL.
      lt_tmp-zdchk = 'Y'.
      lt_tmp-zdhdate =  it0006-h_date.
    ELSE.
      lt_tmp-zdchk = ''.
      lt_tmp-zdhdate = ''.
    ENDIF.

    SELECT zdung INTO tmp_zdung FROM zthrbs05
      WHERE pernr = it0006-pernr AND
      ( ( begda <= it0006-begda AND endda >= it0006-begda )
      OR ( begda >= it0006-begda AND endda <= it0006-endda )
      OR ( begda <= it0006-endda AND endda >= it0006-endda ) ).
    ENDSELECT.

    IF sy-subrc NE 0.
      SELECT SINGLE zcost INTO tmp_zcost  FROM zthrcost
      WHERE z_ctype = '1'
      AND zdung NOT IN ('A', 'B', 'C')
      AND begda <= it0006-begda
      AND endda => it0006-begda
      AND zversn  = '1'.
    ELSE.
      SELECT SINGLE zcost INTO tmp_zcost FROM zthrcost
      WHERE z_ctype = '1'
      AND zdung   = tmp_zdung
      AND begda <= it0006-begda
      AND endda => it0006-begda
      AND zversn  = '1'.
    ENDIF.
    lt_tmp-zd_money = tmp_zcost * 8.
    "lt_tmp-zd_money  = '60000'.
    lt_tmp-zsourflex = 'O'.

    APPEND lt_tmp.
   ENDIF.
  ENDLOOP.

ENDIF.

*  분리 xa30752 2020.01.07
*  DELETE lt_tmp WHERE zsourflex = 'Z'. "  기타(미보상 대휴 출제위원 기타)
*  DELETE lt_tmp WHERE zsourflex = 'T'.  " 간주

*  DELETE lt_tmp WHERE zsourflex = 'Z' AND zsourflex = 'T'.

  "2023.05.23 나구엽- 정렬을 최종 정산금액으로 해야함, 휴휴 정산 실비 기준이 달라져서...
  LOOP AT lt_tmp.
    IF lt_tmp-jorgeh IS INITIAL.
     "2025.12.12 나구엽- 재량근로의 경우 대휴 실비 그대로 가야함 X2 하면 안됨
      IF  lt_tmp-zsourflex = 'U'.
        lt_tmp-zsort_money =  lt_tmp-zd_money.
      ELSE.
        lt_tmp-zsort_money = lt_tmp-zd_money * 2.
      ENDIF.
    ELSE.
      lt_tmp-zsort_money =  lt_tmp-jorgeh.
    ENDIF.
    MODIFY lt_tmp.
  ENDLOOP.

  "SORT lt_tmp BY pernr zd_money ASCENDING znal DESCENDING.
  SORT lt_tmp BY pernr zsort_money ASCENDING znal DESCENDING.

  " zd_time  타입 변경 (time -> char) 후 공란에 '0' 채우기 " 김승훈 요청 xa30752 2019.7.9
  LOOP AT lt_tmp.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        INPUT  = lt_tmp-zd_time
      IMPORTING
        OUTPUT = lt_tmp-zd_time_c.

    MODIFY lt_tmp.

  ENDLOOP.


  "부서정보
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE lt_zth0500
    FROM zth0500
   WHERE begda <= p_frdat
     AND endda >= p_frdat.

  SORT lt_zth0500 BY objid.

* 입력구분명
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE lt_zsourflex
    FROM dd07t
   WHERE ddlanguage = '3'
     AND domname = 'ZDSOURFLEX'.

  SORT lt_zsourflex BY domvalue_l.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE lt_zgubun
    FROM dd07t
   WHERE ddlanguage = '3'
     AND domname = 'ZBSGUBUN1'.

  SORT lt_zgubun BY domvalue_l.

  select *
    into CORRESPONDING FIELDS OF TABLE lt_exception
  from ZTHRBS16
      FOR ALL ENTRIES IN lt_tmp
   WHERE pernr = lt_tmp-pernr
     and znal = lt_tmp-znal.

  SORT lt_exception BY pernr znal.

ENDFORM.                    "basic_data
*&---------------------------------------------------------------------*
*&      Form  modify_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM modify_data .
  DATA:l_manager TYPE c,
        l_jikwidung like pa0001-jikwidung,
        l_jikwigubun like pa0001-jikwigubun.
  DATA: it_pa2010 TYPE TABLE OF pa2010.

   SELECT * FROM pa2010 INTO CORRESPONDING FIELDS OF TABLE it_pa2010 WHERE  begda =  p_datum AND endda = p_datum.
   IF sy-subrc EQ 0.
    DELETE lt_tmp WHERE zdend <= p_datum.
   ENDIF.

  LOOP AT lt_tmp.
    MOVE-CORRESPONDING lt_tmp TO gt_disp.
    READ TABLE lt_pa0001 WITH KEY pernr = lt_tmp-pernr
                          BINARY SEARCH.
    IF sy-subrc <> 0.
*      EXIT.  "존재하지 않는 사원
      CONTINUE.
    ENDIF.

*  부장급은 제외로직
    CLEAR : l_manager, l_jikwidung , l_jikwigubun.
    select single jikwidung jikwigubun jikwidung_1
      into (l_jikwidung , l_jikwigubun, lt_pa0001-jikwidung_1)
    from pa0001
    where pernr = lt_tmp-pernr
      and begda <= lt_tmp-znal  "근무일 당시 직위로
      and endda >= lt_tmp-znal.

    " 직급 추가 xa30752 20200625
    SELECT SINGLE trfgr
      INTO  lt_pa0001-zztrfgr
      FROM pa0008
      WHERE pernr = lt_tmp-pernr
        AND begda <= lt_tmp-znal  "근무일 당시 직급으로
        AND endda >= lt_tmp-znal.

*  지급일 기준으로 퇴직자 여부 확인  xa30752 20200709
    SELECT SINGLE persg
      INTO lt_pa0001-persg
    from pa0001
    where pernr = lt_tmp-pernr
      and begda <= p_datum  "지급일 기준 재직여부 확인
      and endda >= p_datum.

    CALL FUNCTION 'ZHR_GET_MANAGER_TYPE_N'
      EXPORTING
        jikwidung  = l_jikwidung
        jikwigubun = l_jikwigubun
        datum      = lt_tmp-znal
      IMPORTING
        m_type     = l_manager.

*    IF l_manager = 'M'.
**      EXIT.  "부장급은 제외
*      CONTINUE.
*    ENDIF.

    IF lt_pa0001-persg <> '1' and lt_pa0001-persg <> '3'.
      "재직, 휴직이 아니면 퇴직자표기
      gt_disp-jorgeh = 0.
      gt_disp-jorgeh_txt = 'R'.  "퇴직자표기
      gt_disp-jorgeh_txt2 = '퇴직자'.
    ENDIF.


    gt_disp-jikwidung_1 = lt_pa0001-jikwidung_1. " 직위 " 현재 직위가 보임..
    gt_disp-ZZTRFGR = lt_pa0001-ZZTRFGR. " 직급

    "부서정보
    gt_disp-orgeh = lt_pa0001-vdsk1.
    READ TABLE lt_zth0500 WITH KEY objid = gt_disp-orgeh
                          BINARY SEARCH.
    IF sy-subrc = 0.
*      gt_disp-orgtx = lt_zth0500-fname.
      gt_disp-zorder = lt_zth0500-zorder.
    ENDIF.
    gt_disp-zkostl = lt_pa0001-kostl.
    "입력구분명
    READ TABLE lt_zsourflex WITH KEY domvalue_l = gt_disp-zsourflex
                          BINARY SEARCH.
    IF sy-subrc = 0.
      " xa30752 2020.01.07 추가
      IF  lt_zsourflex-ddtext EQ 'WEB_ESS_신HR(통상근로연장)'
         OR lt_zsourflex-ddtext EQ 'Mobile_ESS_신HR(통상근로연장)'
         OR lt_zsourflex-ddtext EQ 'SAP R/3 ZH4110'.
        gt_disp-zsourflex_t = '통상근무'.

      ELSEIF lt_zsourflex-ddtext EQ 'WEB_ESS_구HR(교대근로연장)'
        OR lt_zsourflex-ddtext EQ 'Mobile_ESS_구HR(교대근로연장)'.
        gt_disp-zsourflex_t = '교대근무'.

      ELSE.
        gt_disp-zsourflex_t = lt_zsourflex-ddtext.

        if lt_zsourflex-ddtext = '교대'.

          gt_disp-zd_money = ''.

        endif.

      ENDIF.

    ELSE.  "ZSOURFLEX이 빈값이면, gubun 값으로 표기
*    190617 모두 통상으로 표기
      gt_disp-zsourflex_t = '통상근무'.
*      read table lt_ZGUBuN  with key DOMVALUE_L = gt_disp-ZGUBuN
*                                binary search.
*      if sy-subrc = 0.
*        gt_disp-ZSOURFLEX_t = lt_ZGUBuN-DDTEXT.
*      endif.
    ENDIF.

     "20260616-나구엽-인사부 요청. 부장급이면 금액 0원.
     IF l_manager = 'M'.
       gt_disp-zd_money  = 0.
       gt_disp-zd_money_c = gt_disp-zd_money.
       gt_disp-jorgeh = 0.
       gt_disp-jorgeh_c = gt_disp-jorgeh.
     ELSE.
       gt_disp-zd_money_c = gt_disp-zd_money / 100.  "추가 - 2019.06.27 by chl
       gt_disp-jorgeh_c = gt_disp-jorgeh / 100.  "추가 - 2019.06.27 by chl
     ENDIF.
    APPEND gt_disp.
  ENDLOOP.
ENDFORM.                    " modify_DATA

*&---------------------------------------------------------------------*
*&      Form  cal_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  계산식 )
*  재량 외 : 대휴 총갯수 - 대휴 사용 = 보상해야 하는 대휴 갯수
*  재량 : 최소 사용 갯수 = 대휴 총갯수 * 20%
*      대휴 총갯수 - 대휴 사용 or 최소 사용 갯수 = 보상해야 하는 대휴 갯수
* (재량+재량외 총 갯수) - (재량+재량외 사용 총 갯수) = 최종 보상해야 하는 갯수

* 재량근로 의무 대휴 계산식 변경 xa30752 20200623
* 비율이 아니라 업무별 의무 사용 갯수로
* 재량근로 대휴 생성 당시, 의무 사용 대휴 갯수만큼 대휴금액을 '0'으로 생성함
* 대휴 정산프로그램에서 재량근로라고 해서 별도 처리 불필요
*----------------------------------------------------------------------*
FORM cal_data .
  DATA : ls_tmp LIKE lt_tmp.
  DATA : lv_tot TYPE i,
*         lv_min2(3) TYPE p DECIMALS 1,  "재량 최소값
*         lv_min TYPE i,  "재량 최소값
*         lv_t_j TYPE i,  "재량 총합
*         lv_y_j TYPE i,  "재량 쓴거
         lv_t_e  TYPE i, "재량 외 총합
         lv_y_e TYPE i.  "재량 외 쓴거
  DATA : lv_cnt TYPE i.


  LOOP AT lt_tmp INTO ls_tmp.
**    총 갯수, 사용 갯수 산정
*    IF ls_tmp-zsourflex = 'U'. "재량
*      lv_t_j = lv_t_j + 1.
*      IF ls_tmp-zdchk = 'Y' AND ls_tmp-zdhdate IS NOT INITIAL.
*        lv_y_j = lv_y_j + 1.
*      ENDIF.
*    ELSE.
    lv_t_e = lv_t_e + 1.
    IF ls_tmp-zdchk = 'Y' AND ls_tmp-zdhdate IS NOT INITIAL.
      lv_y_e = lv_y_e + 1.
    ENDIF.
*    ENDIF.

    AT END OF pernr.
*      IF lv_t_j <> 0 OR lv_t_e <> 0.
      IF lv_t_e <> 0.
**      재량
*        lt_cal-t_j = lv_t_j.
*        lv_min2 = lv_t_j * 80 / 100.
*        lv_min = lv_min2.      "sap 기본은 반올림.
*        lv_min = lv_t_j - lv_min.
*        IF lv_y_j >= lv_min.  "재량은 최소 갯수만큼 제하고 산정함.
*          lt_cal-y_j = lv_y_j.
*        ELSE.
*          lt_cal-y_j = lv_min.
*        ENDIF.
*        lt_cal-n_j = lt_cal-t_j - lt_cal-y_j.  "재량 남은거
*       재량 외
        lt_cal-t_e = lv_t_e.
        lt_cal-y_e = lv_y_e.
        lt_cal-n_e = lt_cal-t_e - lt_cal-y_e.  "재량 외 남은거
*        최종
        lt_cal-t_t = lt_cal-t_j + lt_cal-t_e.
        lt_cal-t_y = lt_cal-y_j + lt_cal-y_e.
        lt_cal-t_n = lt_cal-n_j + lt_cal-n_e.
        lt_cal-pernr = ls_tmp-pernr.
        APPEND lt_cal.
      ENDIF.
*      CLEAR : lv_t_j, lv_y_j.
      CLEAR : lv_t_e, lv_y_e.
    ENDAT.
  ENDLOOP.

*  보상 갯수, 금액 표기
  LOOP AT lt_cal INTO ls_cal.
    CLEAR: lv_cnt.
*      예외테이블에 들어간 사람은 그 날만 보상해줘야 함.
    read table lt_exception with key pernr = ls_cal-pernr
                                       binary search.
    if sy-subrc = 0.
      LOOP AT lt_tmp INTO ls_tmp WHERE pernr = ls_cal-pernr.
        ls_tmp-jorgeh_txt = 'Y'.
        read table lt_exception with key pernr = ls_tmp-pernr
                                      znal = ls_tmp-znal
                                       binary search.
        if sy-subrc = 0.
          IF ls_tmp-zgubun IS NOT INITIAL
              OR ls_tmp-zsourflex = 'S'
              OR ls_tmp-zsourflex = 'X'.           "통상, 선택, 탄력이면 *2
            IF ls_tmp-jorgeh IS INITIAL. "휴일-휴일 인 경우 대휴 정산 금액이 시간외 저장 시 계산 해서 미리 넣어 놨음
               ls_tmp-jorgeh = ls_tmp-zd_money * 2.
            ENDIF.

          ELSE.
            ls_tmp-jorgeh = ls_tmp-zd_money.
          ENDIF.
        endif.
        MODIFY lt_tmp FROM ls_tmp.
      endloop.
    else.  "예외 아닌 사람.
      LOOP AT lt_tmp INTO ls_tmp WHERE pernr = ls_cal-pernr.
        lv_cnt = lv_cnt + 1.
        ls_tmp-jorgeh_txt = 'Y'.
        IF ls_cal-t_y < lv_cnt .  "사용갯수 넘었다는건 보상해야 한다는 것.
          IF ls_tmp-zgubun IS NOT INITIAL
              OR ls_tmp-zsourflex = 'S'
              OR ls_tmp-zsourflex = 'X'.           "통상, 선택, 탄력이면 *2
            IF ls_tmp-jorgeh IS INITIAL. "휴일-휴일 인 경우 대휴 정산 금액이 시간외 저장 시 계산 해서 미리 넣어 놨음
              ls_tmp-jorgeh = ls_tmp-zd_money * 2.
            ENDIF.
          ELSE.
            ls_tmp-jorgeh = ls_tmp-zd_money.
          ENDIF.

        ELSE. "사용갯수가 안넘었는데 대휴정산금액이 존재하면 0원 업데이트
            IF ls_tmp-jorgeh IS NOT INITIAL.
              "UPDATE zthrbs01 SET jorgeh = 0 WHERE pernr = ls_cal-pernr AND rdate = ls_tmp-rdate AND jorgeh = ls_tmp-jorgeh.
               ls_tmp-jorgeh = 0.
            ENDIF.
        ENDIF.

        MODIFY lt_tmp FROM ls_tmp.
      ENDLOOP.
    ENDIF.
  ENDLOOP.


ENDFORM.                    " cal_data
*&---------------------------------------------------------------------*
*&      Form  basic_after_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM basic_after_data .
"통상근무 대휴정산 처리 조회-------------------------------------------------*
IF rb3 EQ 'X'.
  IF p_frdat IS INITIAL.
    gv_stop = 'X'.
*    MESSAGE s001 DISPLAY LIKE 'E' WITH '검색기간을 입력하십시오.'.
    MESSAGE s001 DISPLAY LIKE 'E' WITH '대휴정산 종료일을 입력하십시오.'.
    RETURN.
  ENDIF.

  CLEAR: gt_disp, gt_disp[], lt_tmp, lt_tmp[], lt_pa0001, lt_pa0001[].

  "전체 사용자
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE lt_pa0001
    FROM pa0001
   WHERE pernr IN s_pernr
     AND begda <= p_frdat
     AND endda >= p_frdat
     AND vdsk1 IN s_orgeh.

  SORT lt_pa0001 BY pernr.

  CHECK lt_pa0001[] IS NOT INITIAL.
* 기준테이블 실적 있는 모든 데이터 표기
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE lt_tmp
    FROM zthrbs01
      FOR ALL ENTRIES IN lt_pa0001
   WHERE pernr = lt_pa0001-pernr
     AND state = '3'
     AND zdend =  p_frdat
     AND zdaeh = 'Y'
*     and jorgeh_txt = ''.
     AND jorgeh_txt <> ''.
*     and ZSOURFLEX NOT IN ('T','Z')

*  분리 xa30752 2020.01.07

*  DELETE lt_tmp WHERE zsourflex = 'Z'. "  기타(미보상 대휴 출제위원 기타)
*  DELETE lt_tmp WHERE zsourflex = 'T'.  " 간주


*  DELETE lt_tmp WHERE zsourflex = 'T' AND zsourflex = 'Z'.
  SORT lt_tmp BY pernr zd_money znal.

  " zd_time  타입 변경 (time -> char) 후 공란에 '0' 채우기 " 김승훈 요청 xa30752 2019.7.9
  LOOP AT lt_tmp.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        INPUT  = lt_tmp-zd_time
      IMPORTING
        OUTPUT = lt_tmp-zd_time_c.

    MODIFY lt_tmp.

  ENDLOOP.

  "부서정보
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE lt_zth0500
    FROM zth0500
   WHERE begda <= p_frdat
     AND endda >= p_frdat.

  SORT lt_zth0500 BY objid.

* 입력구분명
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE lt_zsourflex
    FROM dd07t
   WHERE ddlanguage = '3'
     AND domname = 'ZDSOURFLEX'.

  SORT lt_zsourflex BY domvalue_l.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE lt_zgubun
    FROM dd07t
   WHERE ddlanguage = '3'
     AND domname = 'ZBSGUBUN1'.

  SORT lt_zgubun BY domvalue_l.

*  form modify_data
  LOOP AT lt_tmp.
    MOVE-CORRESPONDING lt_tmp TO gt_disp.
    READ TABLE lt_pa0001 WITH KEY pernr = lt_tmp-pernr
                          BINARY SEARCH.
    IF sy-subrc <> 0.
      EXIT.  "존재하지 않는 사원
    ENDIF.

    gt_disp-jikwidung_1 = lt_pa0001-jikwidung_1.
    gt_disp-ZZTRFGR = lt_pa0001-ZZTRFGR.

    "부서정보
    gt_disp-orgeh = lt_pa0001-vdsk1.
    READ TABLE lt_zth0500 WITH KEY objid = gt_disp-orgeh
                          BINARY SEARCH.
    IF sy-subrc = 0.
*      gt_disp-orgtx = lt_zth0500-fname.
      gt_disp-zorder = lt_zth0500-zorder.
    ENDIF.
    gt_disp-zkostl = lt_pa0001-kostl.
    "입력구분명
    READ TABLE lt_zsourflex WITH KEY domvalue_l = gt_disp-zsourflex
                          BINARY SEARCH.
    IF sy-subrc = 0.
      " xa30752 2020.01.07 추가
      IF  lt_zsourflex-ddtext EQ 'WEB_ESS_신HR(통상근로연장)'
         OR lt_zsourflex-ddtext EQ 'Mobile_ESS_신HR(통상근로연장)'
         OR lt_zsourflex-ddtext EQ 'SAP R/3 ZH4110'.
        gt_disp-zsourflex_t = '통상근무'.

      ELSEIF lt_zsourflex-ddtext EQ 'WEB_ESS_구HR(교대근로연장)'
        OR lt_zsourflex-ddtext EQ 'Mobile_ESS_구HR(교대근로연장)'.
        gt_disp-zsourflex_t = '교대근무'.

      ELSE.
        gt_disp-zsourflex_t = lt_zsourflex-ddtext.
      ENDIF.
*      gt_disp-zsourflex_t = lt_zsourflex-ddtext.
    ELSE.  "ZSOURFLEX이 빈값이면, gubun 값으로 표기
      gt_disp-zsourflex_t = '통상근무'.
    ENDIF.

    IF gt_disp-jorgeh_txt = 'R'.  "퇴직자표기
      gt_disp-jorgeh_txt2 = '퇴직자'.
    ELSEIF gt_disp-jorgeh_txt = 'Y'.
      gt_disp-jorgeh_txt2 = '정산완료'.
    ENDIF.

    gt_disp-zd_money_c = gt_disp-zd_money / 100.  "추가 - 2019.06.27 by chl
    gt_disp-jorgeh_c = gt_disp-jorgeh / 100.  "추가 - 2019.06.27 by chl
    APPEND gt_disp.
  ENDLOOP.

"교대근무 보상휴가 처리 조회 20230703--------------------------------------------*
ELSEIF rb4 EQ 'X'.

  DATA: tmp_zdung TYPE zthrbs05-zdung.
  DATA : it0006 TYPE TABLE OF ZTHR2006_date WITH HEADER LINE.
  DATA : wa_pa2010 TYPE pa2010.
  DATA : wa_myinfo TYPE zthr_kobis_data.
  DATA : wa_pa0001 TYPE pa0001.
  DATA : wa_disp LIKE gt_disp.
  DATA:l_manager TYPE c,
        l_jikwidung like pa0001-jikwidung,
        l_jikwigubun like pa0001-jikwigubun.
  DATA : ls_tmp LIKE lt_tmp.
  DATA : lv_tot TYPE i,
         lv_t_e  TYPE i, "재량 외 총합
         lv_y_e TYPE i.  "재량 외 쓴거
  DATA : lv_cnt TYPE i.


  IF p_frdat IS INITIAL.
    gv_stop = 'X'.
*    MESSAGE s001 DISPLAY LIKE 'E' WITH '검색기간을 입력하십시오.'.
    MESSAGE s001 DISPLAY LIKE 'E' WITH '대휴/보상 정산 종료일을 입력하십시오.'.
    RETURN.
  ENDIF.

  CLEAR: gt_disp, gt_disp[].

  "전체 사용자
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE lt_pa0001
    FROM pa0001
   WHERE pernr IN s_pernr
     AND begda <= p_frdat
     AND endda >= p_frdat
     AND vdsk1 IN s_orgeh.

  SORT lt_pa0001 BY pernr.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE it0006 FROM ZTHR2006_date
    FOR ALL ENTRIES IN lt_pa0001
    WHERE pernr = lt_pa0001-pernr AND DEEND = p_frdat AND insdat >= '20220506'. "2022년 5월 정산부터 기준 변경

  LOOP AT it0006.
"교대근무 정산 데이터가 있는지 확인
 SELECT SINGLE * INTO CORRESPONDING FIELDS OF  wa_pa2010 FROM pa2010 WHERE pernr =  it0006-pernr AND begda =  p_datum AND endda = p_datum.
   IF sy-subrc EQ 0.

    lt_tmp-pernr = it0006-pernr.
    lt_tmp-begda = it0006-begda.
    lt_tmp-endda = it0006-endda.
    lt_tmp-zinsdat = it0006-insdat.


    SELECT SINGLE * INTO wa_myinfo FROM zthr_kobis_data
      WHERE ( pernr = it0006-pernr ) AND ( persgx <> '' ).
    IF sy-subrc = 0.   "재직자
      lt_tmp-ename = wa_myinfo-ename.
      lt_tmp-vdsk1 = wa_myinfo-vdsk1.
      lt_tmp-orgeh = wa_myinfo-orgeh.
      lt_tmp-orgeh_txt = wa_myinfo-orgehx.
      lt_tmp-vdsk1_txt = wa_myinfo-vdsk1x.
    ELSE.  "퇴직자
      SELECT SINGLE * INTO CORRESPONDING FIELDS OF wa_pa0001 FROM pa0001
        WHERE pernr =  it0006-pernr AND persg = '2'.
        IF sy-subrc = 0.
           lt_tmp-ename = wa_pa0001-ename.
           lt_tmp-orgeh = wa_pa0001-orgeh.
           SELECT SINGLE text1 INTO  lt_tmp-orgeh_txt FROM zth0500
             WHERE objid = wa_pa0001-orgeh.
           lt_tmp-vdsk1 = wa_pa0001-vdsk1.
           SELECT SINGLE text2 INTO  lt_tmp-vdsk1_txt FROM zth0500
             WHERE objid = wa_pa0001-vdsk1.
        ENDIF.

    ENDIF.

    lt_tmp-rdate = it0006-begda.
    lt_tmp-znal = it0006-begda.
    lt_tmp-zdday = it0006-begda.

    lt_tmp-zdbeg = it0006-desta.
    lt_tmp-zdend = it0006-deend.

    "미보상 휴가 사용여부
    IF it0006-h_date IS NOT INITIAL.
      lt_tmp-zdchk = 'Y'.
      lt_tmp-zdhdate =  it0006-h_date.
    ELSE.
      lt_tmp-zdchk = ''.
      lt_tmp-zdhdate = ''.
    ENDIF.

    SELECT zdung INTO tmp_zdung FROM zthrbs05
      WHERE pernr = it0006-pernr AND
      ( ( begda <= it0006-begda AND endda >= it0006-begda )
      OR ( begda >= it0006-begda AND endda <= it0006-endda )
      OR ( begda <= it0006-endda AND endda >= it0006-endda ) ).
    ENDSELECT.

    IF sy-subrc NE 0.
      SELECT SINGLE zcost INTO tmp_zcost  FROM zthrcost
      WHERE z_ctype = '1'
      AND zdung NOT IN ('A', 'B', 'C')
      AND begda <= it0006-begda
      AND endda => it0006-begda
      AND zversn  = '1'.
    ELSE.
      SELECT SINGLE zcost INTO tmp_zcost FROM zthrcost
      WHERE z_ctype = '1'
      AND zdung   = tmp_zdung
      AND begda <= it0006-begda
      AND endda => it0006-begda
      AND zversn  = '1'.
    ENDIF.
    lt_tmp-zd_money = tmp_zcost * 8.
    "lt_tmp-zd_money  = '60000'.
    lt_tmp-zsourflex = 'O'.

    APPEND lt_tmp.
   ENDIF.
  ENDLOOP.

*  분리 xa30752 2020.01.07
*  DELETE lt_tmp WHERE zsourflex = 'Z'. "  기타(미보상 대휴 출제위원 기타)
*  DELETE lt_tmp WHERE zsourflex = 'T'.  " 간주

*  DELETE lt_tmp WHERE zsourflex = 'Z' AND zsourflex = 'T'.

  "2023.05.23 나구엽- 정렬을 최종 정산금액으로 해야함, 휴휴 정산 실비 기준이 달라져서...

  LOOP AT lt_tmp.
    IF lt_tmp-jorgeh IS INITIAL.
     "2025.12.12 나구엽- 재량근로의 경우 대휴 실비 그대로 가야함 X2 하면 안됨
      IF  lt_tmp-zsourflex = 'U'.
        lt_tmp-zsort_money =  lt_tmp-zd_money.
      ELSE.
        lt_tmp-zsort_money = lt_tmp-zd_money * 2.
      ENDIF.
    ELSE.
      lt_tmp-zsort_money =  lt_tmp-jorgeh.
    ENDIF.
    MODIFY lt_tmp.
  ENDLOOP.

  "SORT lt_tmp BY pernr zd_money ASCENDING znal DESCENDING.
  SORT lt_tmp BY pernr zsort_money ASCENDING znal DESCENDING.

  " zd_time  타입 변경 (time -> char) 후 공란에 '0' 채우기 " 김승훈 요청 xa30752 2019.7.9
  LOOP AT lt_tmp.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        INPUT  = lt_tmp-zd_time
      IMPORTING
        OUTPUT = lt_tmp-zd_time_c.

    MODIFY lt_tmp.

  ENDLOOP.



"교대근무 보상 갯수, 금액 표기
LOOP AT lt_tmp INTO ls_tmp.
**    총 갯수, 사용 갯수 산정
*    IF ls_tmp-zsourflex = 'U'. "재량
*      lv_t_j = lv_t_j + 1.
*      IF ls_tmp-zdchk = 'Y' AND ls_tmp-zdhdate IS NOT INITIAL.
*        lv_y_j = lv_y_j + 1.
*      ENDIF.
*    ELSE.
    lv_t_e = lv_t_e + 1.
    IF ls_tmp-zdchk = 'Y' AND ls_tmp-zdhdate IS NOT INITIAL.
      lv_y_e = lv_y_e + 1.
    ENDIF.
*    ENDIF.

    AT END OF pernr.
*      IF lv_t_j <> 0 OR lv_t_e <> 0.
      IF lv_t_e <> 0.
**      재량
*        lt_cal-t_j = lv_t_j.
*        lv_min2 = lv_t_j * 80 / 100.
*        lv_min = lv_min2.      "sap 기본은 반올림.
*        lv_min = lv_t_j - lv_min.
*        IF lv_y_j >= lv_min.  "재량은 최소 갯수만큼 제하고 산정함.
*          lt_cal-y_j = lv_y_j.
*        ELSE.
*          lt_cal-y_j = lv_min.
*        ENDIF.
*        lt_cal-n_j = lt_cal-t_j - lt_cal-y_j.  "재량 남은거
*       재량 외
        lt_cal-t_e = lv_t_e.
        lt_cal-y_e = lv_y_e.
        lt_cal-n_e = lt_cal-t_e - lt_cal-y_e.  "재량 외 남은거
*        최종
        lt_cal-t_t = lt_cal-t_j + lt_cal-t_e.
        lt_cal-t_y = lt_cal-y_j + lt_cal-y_e.
        lt_cal-t_n = lt_cal-n_j + lt_cal-n_e.
        lt_cal-pernr = ls_tmp-pernr.
        APPEND lt_cal.
      ENDIF.
*      CLEAR : lv_t_j, lv_y_j.
      CLEAR : lv_t_e, lv_y_e.
    ENDAT.
  ENDLOOP.

*  보상 갯수, 금액 표기
  LOOP AT lt_cal INTO ls_cal.
    CLEAR: lv_cnt.
*      예외테이블에 들어간 사람은 그 날만 보상해줘야 함.
    read table lt_exception with key pernr = ls_cal-pernr
                                       binary search.
    if sy-subrc = 0.
      LOOP AT lt_tmp INTO ls_tmp WHERE pernr = ls_cal-pernr.
        ls_tmp-jorgeh_txt = 'Y'.
        read table lt_exception with key pernr = ls_tmp-pernr
                                      znal = ls_tmp-znal
                                       binary search.
        if sy-subrc = 0.
          IF ls_tmp-zgubun IS NOT INITIAL
              OR ls_tmp-zsourflex = 'S'
              OR ls_tmp-zsourflex = 'X'.           "통상, 선택, 탄력이면 *2
            IF ls_tmp-jorgeh IS INITIAL. "휴일-휴일 인 경우 대휴 정산 금액이 시간외 저장 시 계산 해서 미리 넣어 놨음
               ls_tmp-jorgeh = ls_tmp-zd_money * 2.
            ENDIF.

          ELSE.
            ls_tmp-jorgeh = ls_tmp-zd_money.
          ENDIF.
        endif.
        MODIFY lt_tmp FROM ls_tmp.
      endloop.
    else.  "예외 아닌 사람.
      LOOP AT lt_tmp INTO ls_tmp WHERE pernr = ls_cal-pernr.
        lv_cnt = lv_cnt + 1.
        ls_tmp-jorgeh_txt = 'Y'.
        IF ls_cal-t_y < lv_cnt .  "사용갯수 넘었다는건 보상해야 한다는 것.
          IF ls_tmp-zgubun IS NOT INITIAL
              OR ls_tmp-zsourflex = 'S'
              OR ls_tmp-zsourflex = 'X'.           "통상, 선택, 탄력이면 *2
            IF ls_tmp-jorgeh IS INITIAL. "휴일-휴일 인 경우 대휴 정산 금액이 시간외 저장 시 계산 해서 미리 넣어 놨음
              ls_tmp-jorgeh = ls_tmp-zd_money * 2.
            ENDIF.
          ELSE.
            ls_tmp-jorgeh = ls_tmp-zd_money.
          ENDIF.

        ELSE. "사용갯수가 안넘었는데 대휴정산금액이 존재하면 0원 업데이트
            IF ls_tmp-jorgeh IS NOT INITIAL.
              "UPDATE zthrbs01 SET jorgeh = 0 WHERE pernr = ls_cal-pernr AND rdate = ls_tmp-rdate AND jorgeh = ls_tmp-jorgeh.
               ls_tmp-jorgeh = 0.
            ENDIF.
        ENDIF.

        MODIFY lt_tmp FROM ls_tmp.
      ENDLOOP.
    ENDIF.
  ENDLOOP.




  LOOP AT lt_tmp.

    MOVE-CORRESPONDING lt_tmp TO gt_disp.
    READ TABLE lt_pa0001 WITH KEY pernr = lt_tmp-pernr
                          BINARY SEARCH.
    IF sy-subrc <> 0.
*      EXIT.  "존재하지 않는 사원
      CONTINUE.
    ENDIF.

*  부장급은 제외로직
    CLEAR : l_manager, l_jikwidung , l_jikwigubun.
    select single jikwidung jikwigubun jikwidung_1
      into (l_jikwidung , l_jikwigubun, lt_pa0001-jikwidung_1)
    from pa0001
    where pernr = lt_tmp-pernr
      and begda <= lt_tmp-znal  "근무일 당시 직위로
      and endda >= lt_tmp-znal.

    " 직급 추가 xa30752 20200625
    SELECT SINGLE trfgr
      INTO  lt_pa0001-zztrfgr
      FROM pa0008
      WHERE pernr = lt_tmp-pernr
        AND begda <= lt_tmp-znal  "근무일 당시 직급으로
        AND endda >= lt_tmp-znal.

*  지급일 기준으로 퇴직자 여부 확인  xa30752 20200709
    SELECT SINGLE persg
      INTO lt_pa0001-persg
    from pa0001
    where pernr = lt_tmp-pernr
      and begda <= p_datum  "지급일 기준 재직여부 확인
      and endda >= p_datum.

    CALL FUNCTION 'ZHR_GET_MANAGER_TYPE_N'
      EXPORTING
        jikwidung  = l_jikwidung
        jikwigubun = l_jikwigubun
        datum      = lt_tmp-znal
      IMPORTING
        m_type     = l_manager.


  "20240813-인사운영부-해당 정산기간 한달동안 하루라도 부장급 이었으면 인사운영부 IT에서 관리하는 교대근무 보상휴가
   "테이블 ZTHR2006_DATE에서 INSDAT 생성일에 일자가 안들어가게 배치 조치 할거임 여기서 검증 안해도됨
    IF l_manager = 'M'.
*      EXIT.  "부장급은 제외
*      CONTINUE.
    ENDIF.

    IF lt_pa0001-persg <> '1' and lt_pa0001-persg <> '3'.
      "재직, 휴직이 아니면 퇴직자표기
      gt_disp-jorgeh = 0.
      gt_disp-jorgeh_txt = 'R'.  "퇴직자표기
      gt_disp-jorgeh_txt2 = '퇴직자'.
    ENDIF.


    gt_disp-jikwidung_1 = lt_pa0001-jikwidung_1. " 직위 " 현재 직위가 보임..
    gt_disp-ZZTRFGR = lt_pa0001-ZZTRFGR. " 직급

    "부서정보
    gt_disp-orgeh = lt_pa0001-vdsk1.
    READ TABLE lt_zth0500 WITH KEY objid = gt_disp-orgeh
                          BINARY SEARCH.
    IF sy-subrc = 0.
*      gt_disp-orgtx = lt_zth0500-fname.
      gt_disp-zorder = lt_zth0500-zorder.
    ENDIF.

    gt_disp-zkostl = lt_pa0001-kostl.
    gt_disp-jorgeh_c = gt_disp-jorgeh / 100.
    gt_disp-zd_money_c = gt_disp-zd_money / 100.

    APPEND gt_disp.

  ENDLOOP.

ENDIF.

ENDFORM.                    "basic_after_data

*&---------------------------------------------------------------------*
*&      Form  modifyscreen
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM modifyscreen.
  IF p_datum IS INITIAL.
    gv_stop = 'X'.
    MESSAGE s001 DISPLAY LIKE 'E' WITH '지급일을 입력하십시오.'.
    EXIT.
  ENDIF.
ENDFORM.                    "modifyscreen

*&---------------------------------------------------------------------*
*&      Form  SET_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_layout .
  gs_layout-cwidth_opt = 'X'.
  gs_layout-zebra = 'X'.
  gs_layout-sel_mode   = 'A'.
ENDFORM.                    " SET_LAYOUT
*&---------------------------------------------------------------------*
*&      Form  SET_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_fieldcat .
  CLEAR gs_fieldcat. REFRESH gt_fieldcat.

  PERFORM append_init_fieldcat USING :
   '01' 'X' 'ZORDER'      '부서레벨'      'C' ' ',
   '02' 'X' 'PERNR'       '사번'          'C' ' ',
   '03' 'X' 'ENAME'       '이름'          'C' ' ',
   '04' ' ' 'JIKWIDUNG_1' '직위'          'C' ' ',
   '04' ' ' 'ZZTRFGR'     '직급'          'C' ' ',
   '05' ' ' 'ORGEH_TXT'       '부서명1'      'L' ' ',
   '06' ' ' 'VDSK1_TXT'       '부서명2'      'L' ' ',
   '07' ' ' 'ZKOSTL'       '코스트센터'      'L' ' ',
   '08' ' ' 'ZSOURFLEX_T'   '입력구분'      'C' ' ',
   '09' ' ' 'ZNAL'       '근무일'      'C' ' ',
   '10' ' ' 'ZBEGT'       '시작 시간'    'C' ' ',
   '11' ' ' 'ZENDT'       '종료 시간'    'C' ' ',
   '12' ' ' 'ZTOMO'       '익일여부'      'C' ' ',
   '13' ' ' 'ZDAEH'       '대휴여부'      'C' ' ',
   '14' ' ' 'ZD_TIME_C'     '대휴발생일 근무시간'    'C' ' ',
   '15' 'D' 'ZD_MONEY_C'  '대휴발생일 휴일근무실비'    'R' 'C',
   '16' ' ' 'ZDDAY'       '대휴발생일'    'C' ' ',
   '17' ' ' 'ZDBEG'       '대휴 사용시작일'    'C' ' ',
   '18' ' ' 'ZDEND'       '대휴 사용종료일'    'C' ' ',
   '19' ' ' 'ZDCHK'       '대휴 사용여부'      'C' ' ',
   '20' ' ' 'ZDHDATE'     '대휴 사용일'        'C' ' ',
   '21' 'D' 'JORGEH_C'    '정산금액'           'R' 'C',
   '22' ' ' 'JORGEH_TXT2' '대휴정산여부'       'C' ' '.

  PERFORM append_init_fieldcat USING
 '23' ' ' 'MSG'      '메세지'      'L' ' '.


ENDFORM.                    " SET_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  SET_SORT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_sort .

ENDFORM.                    " SET_SORT
*---------------------------------------------------------------------*
*       FORM APPEND_INIT_FIELDCAT                                     *
*---------------------------------------------------------------------*
*       FIEDLCAT                                                      *
*---------------------------------------------------------------------*
FORM append_init_fieldcat  USING p_pos
                                 p_key
                                 p_fieldname
                                 p_reptext
                                 p_just
                                 p_mask.

  DATA: ls_fcat TYPE lvc_s_fcat.

  CLEAR ls_fcat.
  ls_fcat-col_pos       = p_pos.

  CASE p_key.
    WHEN 'X'.
      ls_fcat-key       = p_key.
    WHEN 'A'.
      ls_fcat-emphasize = 'C300'.
    WHEN 'B'.
      ls_fcat-emphasize = 'C400'.
    WHEN 'C'.
      ls_fcat-emphasize = 'C500'.
    WHEN 'D'.
*      ls_fcat-emphasize = 'C600'.
      ls_fcat-do_sum = 'X'.
      ls_fcat-no_zero = 'X'.
    WHEN 'E'.
      ls_fcat-emphasize = 'C700'.
      ls_fcat-do_sum = 'X'.
      ls_fcat-no_zero = 'X'.
    WHEN 'F'.
      ls_fcat-emphasize = 'C800'.
      ls_fcat-no_zero = 'X'.
  ENDCASE.

  ls_fcat-fieldname     = p_fieldname.
  IF ls_fcat-fieldname = 'ZORDER'.
    ls_fcat-no_out = 'X'.
  ELSEIF ls_fcat-fieldname = 'DHAMT'.
    ls_fcat-cfieldname = 'WAERS'.
  ENDIF.

  ls_fcat-reptext       = p_reptext.
  ls_fcat-just          = p_just.

  CASE p_mask.
    WHEN 'C'.
      ls_fcat-currency   = 'KRW'.
      ls_fcat-no_zero = 'X'.
    WHEN 'T'.
      ls_fcat-edit_mask = '__:__'.
      ls_fcat-no_zero = 'X'.
    WHEN 'B'.
      ls_fcat-checkbox = 'X'.
  ENDCASE.

  APPEND ls_fcat TO gt_fieldcat.

ENDFORM.                    "append_init_fieldcat
*&---------------------------------------------------------------------*
*&      Form  ALV_HANDLE_TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       TITLE
*----------------------------------------------------------------------*
FORM alv_handle_top_of_page  USING p_dyndoc_id TYPE REF TO cl_dd_document.
  DATA: l_text(255) TYPE c,
        l_text1(50) TYPE c,
        l_text2(50) TYPE c.

  CLEAR: l_text, l_text1, l_text2.


  WRITE p_frdat TO l_text1 USING EDIT MASK '____.__.__'.
  CONCATENATE `대휴정산 종료일 :`  l_text1 INTO l_text SEPARATED BY space.
  CALL METHOD p_dyndoc_id->add_text
    EXPORTING
      text         = l_text
      sap_fontsize = cl_dd_area=>medium
      sap_emphasis = cl_dd_document=>strong
      sap_color    = cl_dd_area=>list_positive_inv.
  CALL METHOD p_dyndoc_id->new_line.

  clear : l_text, l_text1.
  WRITE p_datum TO l_text1 USING EDIT MASK '____.__.__'.
  CONCATENATE `기준일(지급일) :`  l_text1 INTO l_text SEPARATED BY space.
  CALL METHOD p_dyndoc_id->add_text
    EXPORTING
      text         = l_text
      sap_fontsize = cl_dd_area=>medium
      sap_emphasis = cl_dd_document=>strong
      sap_color    = cl_dd_area=>list_positive_inv.
  CALL METHOD p_dyndoc_id->new_line.

*- 대상 건수
  CLEAR: l_text, l_text1, l_text2.
  l_text1 = g_line.
  CONDENSE l_text1.
  CONCATENATE l_text1 `건` INTO l_text2.
  CONCATENATE `대상건수 :`  l_text2 INTO l_text SEPARATED BY space.
  CALL METHOD p_dyndoc_id->add_text
    EXPORTING
      text         = l_text
      sap_fontsize = cl_dd_area=>medium
      sap_emphasis = cl_dd_document=>strong
      sap_color    = cl_dd_area=>list_positive_inv.

  IF o_html_cntrl IS INITIAL.
    CREATE OBJECT o_html_cntrl
      EXPORTING
        parent = o_parent_top.
  ENDIF.

  CALL METHOD o_dyndoc_id->merge_document.
  o_dyndoc_id->html_control = o_html_cntrl.

  CALL METHOD o_dyndoc_id->display_document
    EXPORTING
      reuse_control      = 'X'
      parent             = o_parent_top
    EXCEPTIONS
      html_display_error = 1.

ENDFORM.                    " ALV_HANDLE_TOP_OF_PAGE
*&---------------------------------------------------------------------*
*&      Form  ALV_HANDLE_TOOLBAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM alv_handle_toolbar USING pr_object TYPE REF TO cl_alv_event_toolbar_set
                              ps_interactive TYPE stb_button.

  ps_interactive-butn_type = 3.
  APPEND ps_interactive TO pr_object->mt_toolbar.

  ps_interactive-function = 'DOWNLOAD'.
  ps_interactive-icon =  icon_xls.
  ps_interactive-butn_type = 0.
  ps_interactive-text = 'Excel Download'.
  APPEND ps_interactive TO pr_object->mt_toolbar.

ENDFORM.                    "alv_handle_toolbar
*&---------------------------------------------------------------------*
*&      Form  ALV_HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM alv_handle_user_command  USING p_ucomm.
  DATA: lv_filename TYPE string,
        lv_path TYPE string,
        lv_fullpath TYPE string.
  DATA: lv_int_dhamt TYPE i,
        lv_filename2 TYPE rlgrap-filename.

  FIELD-SYMBOLS <fs>.

  CASE p_ucomm.
    WHEN 'DOWNLOAD'.
      CALL METHOD cl_gui_frontend_services=>file_save_dialog
      EXPORTING
        file_filter               = cl_gui_frontend_services=>filetype_excel
        initial_directory         = 'C:\'
*    prompt_on_overwrite       = 'X'
        CHANGING
          filename                  = lv_filename
          path                      = lv_path
          fullpath                  = lv_fullpath
        EXCEPTIONS
          cntl_error                = 1
          error_no_gui              = 2
          not_supported_by_gui      = 3
          invalid_default_file_name = 4
          OTHERS                    = 5.

      IF sy-subrc <> 0.
        MESSAGE s031 DISPLAY LIKE 'E'.
        EXIT.
      ENDIF.

      IF lv_fullpath IS INITIAL.
        EXIT.
      ENDIF.


      CLEAR gt_data_down[].
      LOOP AT gt_disp.
        MOVE-CORRESPONDING gt_disp TO gt_data_down.
*        lv_int_dhamt = gt_disp-dhamt * 100.
*        gt_data_down-dhamt = lv_int_dhamt.
        APPEND gt_data_down.
      ENDLOOP.


      READ TABLE gt_title WITH KEY text = '오류 메세지'.
      IF sy-subrc = 0.
        DELETE gt_title INDEX sy-tabix.
      ENDIF.

      LOOP AT gt_title.
        ASSIGN COMPONENT sy-tabix OF STRUCTURE gt_data_down TO <fs>.
        <fs> = gt_title-text.
      ENDLOOP.
      INSERT gt_data_down INDEX 1.


      lv_filename2 = lv_fullpath.
      CALL FUNCTION 'SAP_CONVERT_TO_XLS_FORMAT'
        EXPORTING
          i_filename        = lv_filename2
          i_line_header     = 'X'
        TABLES
          i_tab_sap_data    = gt_data_down
        EXCEPTIONS
          conversion_failed = 1.

      IF sy-subrc = 0.
        MESSAGE s034.
      ENDIF.

  ENDCASE.
ENDFORM.                    "alv_handle_user_command
*&---------------------------------------------------------------------*
*&      Form  SAVE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM save_data .
  DATA: lv_answer TYPE c,
        ls_zthrbs01 TYPE zthrbs01,
        ls_zdata TYPE zthrbs01,
        ls_pdata TYPE zsh_personnel_data,
        ls_return LIKE bapireturn1,
        lv_opt TYPE actio.
  DATA : lv_betrg TYPE p2010-betrg,
        lv_t_betrg TYPE p2010-betrg.
  DATA: ls_2010 TYPE p2010.
  DATA: return  LIKE bapireturn1.
  DATA: BEGIN OF gt_pernr OCCURS 0,
        pernr TYPE persno,
        msg(50),
      END OF gt_pernr.

  DATA lv_pernr_buffer LIKE gt_disp-pernr.


  IF gt_disp[] IS INITIAL .
    MESSAGE s001 DISPLAY LIKE 'E' WITH '저장할 데이터가 없습니다.'.
    EXIT.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = '확 인'
      text_question         = '저장하시겠습니까?'
      text_button_1         = '저 장'
      icon_button_1         = 'ICON_OKAY'
      text_button_2         = '취 소'
      icon_button_2         = 'ICON_CANCEL'
      default_button        = '1'
      display_cancel_button = ''
      start_column          = 25
      start_row             = 6
    IMPORTING
      answer                = lv_answer.

  IF lv_answer NE '1'.
    EXIT.
  ENDIF.



  LOOP AT gt_disp.
*    ON CHANGE OF gt_disp-pernr.
*      SELECT SINGLE *
*        INTO CORRESPONDING FIELDS OF ls_2010
*        FROM pa2010
*       WHERE pernr = gt_disp-pernr
*         AND begda <= p_datum
*         AND endda >= p_datum
*         AND subty = '8000'.
*      IF sy-subrc = 0.
*        lv_answer = '2'.
*      ELSE.
*        lv_answer = '1'.
*      ENDIF.
*    ENDON.

    IF lv_pernr_buffer <> gt_disp-pernr.
      lv_pernr_buffer = gt_disp-pernr.

      SELECT SINGLE *
        INTO CORRESPONDING FIELDS OF ls_2010
        FROM pa2010
       WHERE pernr = gt_disp-pernr
         AND begda <= p_datum
         AND endda >= p_datum
         AND subty = '8000'
         and exbel = 'X'.    "대휴정산 완료는 이부분을 X로 업뎃해놨기때문.
      IF sy-subrc = 0.
        lv_answer = '2'.
      ELSE.
        lv_answer = '1'.
      ENDIF.
    ENDIF.

    IF lv_answer NE '1'.
      gt_disp-msg = '이미 정산된 데이터가 있습니다. 확인하세요.'.
      MODIFY gt_disp TRANSPORTING msg.
    ENDIF.

    CHECK lv_answer = '1'.

    CLEAR : lv_betrg, ls_2010.
    IF  gt_disp-jorgeh IS NOT INITIAL.
      MOVE gt_disp-jorgeh TO lv_betrg.
      lv_betrg = lv_betrg / 100.
      lv_t_betrg = lv_t_betrg + lv_betrg.
    ENDIF.

*  CBO 업뎃.
 "통상근무 / 교대근무 여부에 따라 업데이트 기준이 다름
 IF rb3 EQ 'X'.
    UPDATE zthrbs01
          SET jorgeh = gt_disp-jorgeh
              jorgeh_txt = gt_disp-jorgeh_txt
         WHERE pernr = gt_disp-pernr
           AND subty = gt_disp-subty
           AND rdate = gt_disp-rdate
           AND begda = gt_disp-begda
           AND endda = gt_disp-endda
           AND seqnr = gt_disp-seqnr.
    IF sy-subrc = 0.
      gt_disp-msg = '대휴정산이 완료되었습니다.'.
    ELSE.
      gt_disp-msg = '저장중 오류가 발생했습니다.'.
    ENDIF.
    MODIFY gt_disp TRANSPORTING msg.
 ELSEIF rb4 EQ 'X'.
     gt_disp-msg = '대휴정산이 완료되었습니다.'.
    MODIFY gt_disp TRANSPORTING msg.
 ENDIF.
    AT END OF pernr.
      CLEAR: ls_2010, return.
      CHECK lv_t_betrg <> 0.
* 사원 LOCK
      CALL FUNCTION 'BAPI_EMPLOYEE_ENQUEUE'
        EXPORTING
          number = gt_disp-pernr
        IMPORTING
          return = return.

      IF return IS NOT INITIAL.
        gt_disp-msg = return-message.
        MODIFY gt_disp TRANSPORTING msg. CLEAR gt_disp.
        CONTINUE.
      ENDIF.

      MOVE: gt_disp-pernr TO ls_2010-pernr,
            '8000'   TO ls_2010-lgart,
            '8000'   TO ls_2010-subty,
            lv_t_betrg TO ls_2010-betrg,
            'X'      TO ls_2010-exbel.

      clear : lv_t_betrg.

      ls_2010-begda = ls_2010-endda = p_datum.
      ls_2010-infty = '2010'.

      CALL FUNCTION 'HR_INITIALIZE_BUFFER'
        EXPORTING
          pernr = ls_2010-pernr.

      CALL FUNCTION 'HR_PSBUFFER_INITIALIZE'.  "버퍼 초기화
      CALL FUNCTION 'HR_READ_INFOTYPE_AUTHC_DISABLE'. "권한 체크 패스

      IF ls_2010 IS NOT INITIAL.
        CLEAR return.
        CALL FUNCTION 'HR_INFOTYPE_OPERATION'
          EXPORTING
            infty           = ls_2010-infty
            number          = ls_2010-pernr
            subtype         = ls_2010-subty
            objectid        = ls_2010-objps
            lockindicator   = ls_2010-sprps
            validityend     = ls_2010-begda
            validitybegin   = ls_2010-begda
            recordnumber    = ls_2010-seqnr
            record          = ls_2010
            operation       = 'INS'
            nocommit        = 'X'
            dialog_mode     = 'A'
            view_identifier = '41'
          IMPORTING
            return          = return.

        IF NOT return IS INITIAL.
          ROLLBACK WORK.
          gt_pernr-pernr = ls_2010-pernr.
          gt_pernr-msg = return-message.
          APPEND gt_pernr.  "에러난 사람들.
        ELSE.
          COMMIT WORK AND WAIT.
        ENDIF.
      ENDIF.

      CALL FUNCTION 'BAPI_EMPLOYEE_DEQUEUE'
        EXPORTING
          number = gt_disp-pernr
        IMPORTING
          return = return.
    ENDAT.

  ENDLOOP.
*  에러 사용자 다시 원복 및 에러 표기
  LOOP AT gt_pernr.
    gt_disp-msg = gt_pernr-msg.
    MODIFY gt_disp TRANSPORTING msg WHERE pernr = gt_pernr-pernr.

*->>> rollback 처리를 위에서 했기 때문에 필요 없음 - 2019.06.27 by chl
*    LOOP AT gt_disp WHERE pernr = gt_pernr-pernr.
*      UPDATE zthrbs01
*          SET jorgeh = ''
*              jorgeh_txt = ''
*         WHERE pernr = gt_disp-pernr
*           AND subty = gt_disp-subty
*           AND rdate = gt_disp-rdate
*           AND begda = gt_disp-begda
*           AND endda = gt_disp-endda
*           AND seqnr = gt_disp-seqnr.
*      IF sy-subrc = 0.
*        gt_disp-msg = gt_pernr-msg.
*      ELSE.
*        gt_disp-msg = '저장중 오류가 발생했습니다.'.
*      ENDIF.
*      MODIFY gt_disp TRANSPORTING msg.
*    ENDLOOP.
  ENDLOOP.
ENDFORM.                    " SAVE_DATA
*&---------------------------------------------------------------------*
*&      Form  save_cancle
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM save_cancle .
  DATA: lv_answer TYPE c,
        lv_msg(50),
        ls_zthrbs01 TYPE zthrbs01,
        ls_zdata TYPE zthrbs01,
        ls_pdata TYPE zsh_personnel_data,
        ls_return LIKE bapireturn1,
        lv_opt TYPE actio.
  DATA : lv_betrg TYPE p2010-betrg,
        lv_t_betrg TYPE p2010-betrg.
  DATA: ls_2010 TYPE p2010.
  DATA: return  LIKE bapireturn1.
  DATA: BEGIN OF gt_pernr OCCURS 0,
        pernr TYPE persno,
        msg(50),
      END OF gt_pernr.

  DATA lv_pernr_buffer LIKE gt_disp-pernr.

  IF gt_disp[] IS INITIAL .
    MESSAGE s001 DISPLAY LIKE 'E' WITH '취소할 데이터가 없습니다.'.
    EXIT.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = '확 인'
      text_question         = '확정을 취소하시겠습니까?'
      text_button_1         = '네'
      icon_button_1         = 'ICON_OKAY'
      text_button_2         = '아니오'
      icon_button_2         = 'ICON_CANCEL'
      default_button        = '1'
      display_cancel_button = ''
      start_column          = 25
      start_row             = 6
    IMPORTING
      answer                = lv_answer.

  IF lv_answer NE '1'.
    EXIT.
  ENDIF.



  LOOP AT gt_disp.
*    2010번 저장 데이터 확인.
    IF lv_pernr_buffer <> gt_disp-pernr.
      lv_pernr_buffer = gt_disp-pernr.
      clear : lv_answer, lv_msg.
      SELECT SINGLE *
        INTO CORRESPONDING FIELDS OF ls_2010
        FROM pa2010
       WHERE pernr = gt_disp-pernr
         AND begda <= p_datum
         AND endda >= p_datum
         AND subty = '8000'
         and exbel = 'X'.
      IF sy-subrc = 0.
        lv_answer = '1'.
      ELSE.
        lv_answer = '2'.
        lv_msg = '2010번에 데이터가 없습니다. 확인하세요.'.
      ENDIF.
    ENDIF.
    if lv_answer ne '1'.
      gt_disp-msg = lv_msg.
      MODIFY gt_disp TRANSPORTING msg.
    endif.

    CHECK lv_answer = '1'.


*  CBO 업뎃.
    UPDATE zthrbs01
    "20250110-ngy-휴휴(휴일휴일) 걸쳐 대휴 생성한 대상자들의 정산금액은 미리 저장되어 있기에 정산취소한다고 금액 날리면 안됨
    "한번 정산 된 사람들은 휴휴 대상자들 때문에 어쩔수 없이 정산금액 날리지 않고 그대로 둠.(대휴정상확정 여부 값 jorgeh_txt 만 날림)
    "대상자에 따라 필요하면 인사부랑 협조하여 금액 수동으로 조절해야 할듯
*          SET jorgeh = ''
*              jorgeh_txt = ''
          SET  jorgeh_txt = ''
         WHERE pernr = gt_disp-pernr
           AND subty = gt_disp-subty
           AND rdate = gt_disp-rdate
           AND begda = gt_disp-begda
           AND endda = gt_disp-endda
           AND seqnr = gt_disp-seqnr.
    IF sy-subrc = 0.
      gt_disp-msg = '정산 확정이 취소 되었습니다.'.
    ELSE.
      gt_disp-msg = '취소중 오류가 발생했습니다.'.
    ENDIF.
    MODIFY gt_disp TRANSPORTING msg.

    AT END OF pernr.
      CLEAR: ls_2010, return.
* 사원 LOCK
      CALL FUNCTION 'BAPI_EMPLOYEE_ENQUEUE'
        EXPORTING
          number = gt_disp-pernr
        IMPORTING
          return = return.

      IF return IS NOT INITIAL.
        gt_disp-msg = return-message.
        MODIFY gt_disp TRANSPORTING msg. CLEAR gt_disp.
        CONTINUE.
      ENDIF.

      MOVE: gt_disp-pernr TO ls_2010-pernr,
            '8000'   TO ls_2010-lgart,
            '8000'   TO ls_2010-subty,
            lv_t_betrg TO ls_2010-betrg.

      ls_2010-begda = ls_2010-endda = p_datum.
      ls_2010-infty = '2010'.

      CALL FUNCTION 'HR_INITIALIZE_BUFFER'
        EXPORTING
          pernr = ls_2010-pernr.

      CALL FUNCTION 'HR_PSBUFFER_INITIALIZE'.  "버퍼 초기화
      CALL FUNCTION 'HR_READ_INFOTYPE_AUTHC_DISABLE'. "권한 체크 패스

      IF ls_2010 IS NOT INITIAL.
        CLEAR return.
        CALL FUNCTION 'HR_INFOTYPE_OPERATION'
          EXPORTING
            infty           = ls_2010-infty
            number          = ls_2010-pernr
            subtype         = ls_2010-subty
            objectid        = ls_2010-objps
            lockindicator   = ls_2010-sprps
            validityend     = ls_2010-begda
            validitybegin   = ls_2010-begda
            recordnumber    = ls_2010-seqnr
            record          = ls_2010
            operation       = 'DEL'
            nocommit        = 'X'
            dialog_mode     = 'A'
            view_identifier = '41'
          IMPORTING
            return          = return.

        IF NOT return IS INITIAL.
          ROLLBACK WORK.
          gt_pernr-pernr = ls_2010-pernr.
          gt_pernr-msg = return-message.
          APPEND gt_pernr.  "에러난 사람들.
        ELSE.
          COMMIT WORK AND WAIT.
        ENDIF.
      ENDIF.

      CALL FUNCTION 'BAPI_EMPLOYEE_DEQUEUE'
        EXPORTING
          number = gt_disp-pernr
        IMPORTING
          return = return.
    ENDAT.

  ENDLOOP.
*  에러 사용자 다시 원복 및 에러 표기
  LOOP AT gt_pernr.
    gt_disp-msg = gt_pernr-msg.
    MODIFY gt_disp TRANSPORTING msg WHERE pernr = gt_pernr-pernr.
  ENDLOOP.
ENDFORM.                    " save_cancle
