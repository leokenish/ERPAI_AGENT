FUNCTION zhr_52tm_cw_payment_wkprd .
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(I_PERNR) TYPE  PERSNO
*"     VALUE(I_YYMM) TYPE  ZEZADMIT_YM
*"     VALUE(I_Z52WKTP) TYPE  ZE52WKTP OPTIONAL
*"     VALUE(I_Z52PRSQ) TYPE  ZE52PRSQ DEFAULT '04'
*"     VALUE(I_OPT) TYPE  CHAR1 OPTIONAL
*"     VALUE(I_RETRO) TYPE  CHAR1 OPTIONAL
*"     VALUE(I_RETMO) TYPE  ZYEARMON OPTIONAL
*"  TABLES
*"      LT_ZTHR0113 STRUCTURE  ZTHR0113 OPTIONAL
*"      LT_RETRO_NEW STRUCTURE ZTHR0113 OPTIONAL
*"      LT_RETRO_OLD STRUCTURE ZTHR0113 OPTIONAL
*"----------------------------------------------------------------------

  DATA: lv_date TYPE datum,
        lv_begda TYPE datum,
        lv_endda TYPE datum,
        lv_f_yymm(7),
        lv_t_yymm(7),
        lv_yymm(7),
        lv_zotpayamt_sum TYPE zthr0113-zotpayamt,
        lv_zrlprdamt_sum TYPE zthr0113-zrlprdamt,
        lv_zotpayamt TYPE zthr0113-zotpayamt,
        lv_zretroamt TYPE zthr0113-zretroamt,
        lv_sign TYPE i.

  DATA:  lt_retro_t TYPE TABLE OF zthr0113 WITH HEADER LINE,
        lt_retro TYPE TABLE OF zthr0113 WITH HEADER LINE,
        lt_save TYPE TABLE OF zthr0113 WITH HEADER LINE,
        lt_zthr0132 TYPE TABLE OF zthr0132 WITH HEADER LINE,
        ls_last TYPE zthr0113.


  CLEAR lt_zthr0113. REFRESH lt_zthr0113.
  CLEAR: lt_retro_new, lt_retro_old.
  REFRESH: lt_retro_new, lt_retro_old.


*->>> begin 소급건
  IF i_retro  = 'X'.
    CONCATENATE i_yymm '01' INTO lv_date.
    "대상년 1월부터 대상월 전월까지
    lv_endda = lv_date - 1.
    lv_begda = lv_date.
    lv_begda+4(2) = '01'.

    "소급시작년월이 있으면 그때부터
    IF i_retmo IS NOT INITIAL.
      IF i_retmo < i_yymm.
        lv_begda(6) = i_retmo.
        lv_begda+6(2) = '01'.
      ENDIF.
    ENDIF.

    lv_f_yymm = lv_begda(6).
    lv_t_yymm = lv_endda(6).

    WHILE lv_t_yymm >= lv_f_yymm.
      "기지급된 최종지급금액
      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE lt_retro_t
        FROM zthr0113
       WHERE pernr = i_pernr
         AND zadmit_ym = lv_t_yymm
         AND z52wktp = c_z52wktp_0110
         AND z52prsq = c_z52prsq_04.

      IF sy-subrc = 0.
        APPEND LINES OF lt_retro_t TO lt_retro_old.
        LOOP AT lt_retro_t. " 매월 정산해야 하는 대상이 2개 이상이 있을 수 있음으로...
          ADD lt_retro_t-zrlprdamt TO lv_zotpayamt_sum.
        ENDLOOP.
      ENDIF.


      CONCATENATE lv_t_yymm '%' INTO lv_yymm.

      "소급대상년월 기간
      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE lt_zthr0132
        FROM zthr0132
       WHERE pernr = i_pernr
         AND endda LIKE lv_yymm
         AND z52wktp = c_z52wktp_0110
         AND z52prsq = c_z52prsq_04.

      "소급대상년월 계산
*        PERFORM make_payment_wkprd TABLES lt_retro
*                                          lt_zthr0132
*                                   USING 'RETRO'.

      CALL FUNCTION 'ZHR_52TM_CW_CAL_AND_DAEH'
        EXPORTING
          i_case      = 'A'
        TABLES
          lt_zthr0132 = lt_zthr0132
          lt_zthr0113 = lt_retro.

      APPEND LINES OF lt_retro TO lt_retro_new.

    LOOP AT lt_retro.
      ADD lt_retro-zrlprdamt TO lv_zrlprdamt_sum.
    ENDLOOP.

      lv_date = lv_t_yymm.
      lv_date+6(2) = '01'.
      lv_date = lv_date - 1.
      lv_t_yymm = lv_date(6).
    ENDWHILE.
  ENDIF.
*<<<- end 소급건

  CONCATENATE i_yymm '%' INTO lv_yymm.

  "대상년월 기간
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE lt_zthr0132
    FROM zthr0132
   WHERE pernr = i_pernr
     AND endda LIKE lv_yymm
     AND z52wktp = c_z52wktp_0110
     AND z52prsq = c_z52prsq_04.

  "대상년월 계산
*  PERFORM make_payment_wkprd TABLES lt_save
*                                    lt_zthr0132
*                              USING 'NORMAL'.

  CALL FUNCTION 'ZHR_52TM_CW_CAL_AND_DAEH'
    EXPORTING
      i_case      = 'B'
    TABLES
      lt_zthr0132 = lt_zthr0132
      lt_zthr0113 = lt_save.


  IF i_retro  = 'X'.  "소급건
*    LOOP AT lt_retro. " lt_retro 소급 월이 1개월 이상일 경우 오류 97 line으로 이동 xa30752 (2020.04.06)
*      ADD lt_retro-zrlprdamt TO lv_zrlprdamt_sum.
*    ENDLOOP.
    "소급정산분 = 기간실비합 - 최종지급금액합
    lv_sign = lv_zrlprdamt_sum - lv_zotpayamt_sum.
    IF lv_sign > 1.
      lv_zretroamt = lv_zrlprdamt_sum - lv_zotpayamt_sum.
    ELSE.
      lv_zretroamt = 0.
    ENDIF.
  ENDIF.


  "소급정산분이 있으면 마지막건에 소급분 처리
  SORT lt_save BY endda DESCENDING.
  LOOP AT lt_save.
    IF sy-tabix = 1.
      "소급정산분
      lt_save-zretroamt = lv_zretroamt.
      "최종지급금액 = 기간실비 + 소급정산분
      lt_save-zotpayamt = lt_save-zrlprdamt + lv_zretroamt.
    ELSE.
      "최종지급금액 = 기간실비
      lt_save-zotpayamt = lt_save-zrlprdamt.
    ENDIF.

    MODIFY lt_save TRANSPORTING zretroamt zotpayamt.
  ENDLOOP.

  SORT lt_save BY endda.
  lt_zthr0113[] = lt_save[].

ENDFUNCTION.
