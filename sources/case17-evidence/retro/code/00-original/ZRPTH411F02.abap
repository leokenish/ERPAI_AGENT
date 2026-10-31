*&---------------------------------------------------------------------*
*&  Include           ZRPTH411F02
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  F4_YYMM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f4_yymm .
  DATA: lv_mf_returncode LIKE sy-subrc,
            lv_mf_monat  LIKE isellist-month.

  DATA lt_mf_dynpfields TYPE TABLE OF dynpread WITH HEADER LINE.

  lt_mf_dynpfields-fieldname = 'PA_YYMM'.
  APPEND lt_mf_dynpfields.

  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname               = sy-repid
      dynumb               = sy-dynnr
    TABLES
      dynpfields           = lt_mf_dynpfields
    EXCEPTIONS
      invalid_abapworkarea = 1
      invalid_dynprofield  = 2
      invalid_dynproname   = 3
      invalid_dynpronummer = 4
      invalid_request      = 5
      no_fielddescription  = 6
      invalid_parameter    = 7
      undefind_error       = 8
      double_conversion    = 9
      stepl_not_found      = 10
      OTHERS               = 11.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    READ TABLE lt_mf_dynpfields INDEX 1.
    lv_mf_monat = lt_mf_dynpfields-fieldvalue.
  ENDIF.


  CALL FUNCTION 'POPUP_TO_SELECT_MONTH'
    EXPORTING
      actual_month               = lv_mf_monat
    IMPORTING
      selected_month             = pa_yymm
      return_code                = lv_mf_returncode
    EXCEPTIONS
      factory_calendar_not_found = 1
      holiday_calendar_not_found = 2
      month_not_found            = 3
      OTHERS                     = 4.
  IF sy-subrc = 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.                    " F4_YYMM
*&---------------------------------------------------------------------*
*&      Form  F4_ZSEQ
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f4_zseq .
  DATA: BEGIN OF lt_prsq OCCURS 0,
          z52wktp TYPE zthr0104-z52wktp,
          z52wktp_t TYPE val_text,
          z52prsq TYPE zthr0104-z52prsq,
          zanzhl TYPE zthr0104-zanzhl,
          zprut TYPE zthr0104-zprut,
          zprut_t TYPE val_text,
        END OF lt_prsq.

  DATA lt_dd07t TYPE TABLE OF dd07t WITH HEADER LINE.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE lt_prsq
    FROM zthr0104
   WHERE z52wktp = pa_zwktp.

  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE lt_dd07t
    FROM dd07t
   WHERE domname IN ('ZD52WKTP1', 'ZDPRUT')
     AND ddlanguage = sy-langu.

  SORT lt_dd07t BY domname domvalue_l.

  LOOP AT lt_prsq.
    "근로유형
    READ TABLE lt_dd07t WITH KEY domname = 'ZD52WKTP1'
                                domvalue_l = lt_prsq-z52wktp BINARY SEARCH.
    IF sy-subrc = 0.
      lt_prsq-z52wktp_t = lt_dd07t-ddtext.
    ENDIF.
    "기간단위
    READ TABLE lt_dd07t WITH KEY domname = 'ZDPRUT'
                                domvalue_l = lt_prsq-zprut BINARY SEARCH.
    IF sy-subrc = 0.
      lt_prsq-zprut_t = lt_dd07t-ddtext.
    ENDIF.

    MODIFY lt_prsq.
  ENDLOOP.
*  ENDIF.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'Z52PRSQ'
      dynpprog        = sy-repid
      dynpnr          = sy-dynnr
      dynprofield     = 'PA_ZSEQ'
*     stepl           = sy-stepl
      window_title    = '정산주기'
      value_org       = 'S'
    TABLES
      value_tab       = lt_prsq
      return_tab      = gt_return
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2.
ENDFORM.                    " F4_ZSEQ
*&---------------------------------------------------------------------*
*&      Form  F4_RETMO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f4_retmo .
  DATA: lv_mf_returncode LIKE sy-subrc,
        lv_mf_monat  LIKE isellist-month.

  DATA lt_mf_dynpfields TYPE TABLE OF dynpread WITH HEADER LINE.

  lt_mf_dynpfields-fieldname = 'PA_RETMO'.
  APPEND lt_mf_dynpfields.

  CALL FUNCTION 'DYNP_VALUES_READ'
    EXPORTING
      dyname               = sy-repid
      dynumb               = sy-dynnr
    TABLES
      dynpfields           = lt_mf_dynpfields
    EXCEPTIONS
      invalid_abapworkarea = 1
      invalid_dynprofield  = 2
      invalid_dynproname   = 3
      invalid_dynpronummer = 4
      invalid_request      = 5
      no_fielddescription  = 6
      invalid_parameter    = 7
      undefind_error       = 8
      double_conversion    = 9
      stepl_not_found      = 10
      OTHERS               = 11.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ELSE.
    READ TABLE lt_mf_dynpfields INDEX 1.
    lv_mf_monat = lt_mf_dynpfields-fieldvalue.
  ENDIF.

  IF lv_mf_monat IS INITIAL.
    lv_mf_monat = sy-datum(6).
  ENDIF.


  CALL FUNCTION 'POPUP_TO_SELECT_MONTH'
    EXPORTING
      actual_month               = lv_mf_monat
    IMPORTING
      selected_month             = pa_retmo
      return_code                = lv_mf_returncode
    EXCEPTIONS
      factory_calendar_not_found = 1
      holiday_calendar_not_found = 2
      month_not_found            = 3
      OTHERS                     = 4.
  IF sy-subrc = 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.                    " F4_RETMO
*&---------------------------------------------------------------------*
*&      Form  CHANGE_FORMAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_DISP2_PWKHR  text
*----------------------------------------------------------------------*
FORM change_format  CHANGING p_val.

  DATA: lv_hour_c(4),
        lv_min_c(2),
        lv_hour TYPE numc4,
        lv_min TYPE numc2.

  SPLIT p_val AT ':' INTO lv_hour_c lv_min_c.
  lv_hour = lv_hour_c.
  lv_min = lv_min_c.
  CONCATENATE lv_hour lv_min INTO p_val.

ENDFORM.                    " CHANGE_FORMAT
*&---------------------------------------------------------------------*
*&      Form  CHANGE_FORMAT2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_DISP2_PWKHR  text
*----------------------------------------------------------------------*
FORM change_format2  CHANGING p_val.

  DATA: lv_hour_c(4),
        lv_min_c(2),
        lv_hour TYPE numc4,
        lv_min TYPE numc2.

  IF p_val = '000000'.
    p_val = '0'.
  ELSE.
    lv_hour_c = p_val(4).
    lv_min_c = p_val+4(2).

    SHIFT lv_hour_c LEFT DELETING LEADING '0'.
    CONDENSE lv_hour_c.

    IF lv_min_c = '00'.
      p_val = lv_hour_c.
    ELSE.
      CONCATENATE lv_hour_c ':' lv_min_c INTO p_val.
    ENDIF.
  ENDIF.
ENDFORM.                    " CHANGE_FORMAT2
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download_excel .
  DATA: lv_filename TYPE string,
        lv_path TYPE string,
        lv_fullpath TYPE string,
        lv_filename2 TYPE rlgrap-filename.

  FIELD-SYMBOLS: <fs_struc>, <fs>,
                 <fs_tab> TYPE STANDARD TABLE.

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


  PERFORM make_header.
  PERFORM make_item.

  CASE 'X'.
    WHEN rb1 OR rb2.
      ASSIGN ('GT_DATA_DOWN') TO <fs_struc>.
      ASSIGN ('GT_DATA_DOWN[]') TO <fs_tab>.
    WHEN rb3.
      ASSIGN ('GT_DATA_DOWN2') TO <fs_struc>.
      ASSIGN ('GT_DATA_DOWN2[]') TO <fs_tab>.
    WHEN rb4.
      ASSIGN ('GT_DATA_DOWN3') TO <fs_struc>.
      ASSIGN ('GT_DATA_DOWN3[]') TO <fs_tab>.
  ENDCASE.

  LOOP AT gt_title.
    ASSIGN COMPONENT sy-tabix OF STRUCTURE <fs_struc> TO <fs>.
    <fs> = gt_title-text.
  ENDLOOP.
  INSERT <fs_struc> INTO <fs_tab> INDEX 1.


  lv_filename2 = lv_fullpath.
  CALL FUNCTION 'SAP_CONVERT_TO_XLS_FORMAT'
    EXPORTING
      i_filename        = lv_filename2
      i_line_header     = 'X'
    TABLES
      i_tab_sap_data    = <fs_tab>
    EXCEPTIONS
      conversion_failed = 1.

  IF sy-subrc = 0.
    MESSAGE s034.
  ENDIF.

ENDFORM.                    " DOWNLOAD_EXCEL
*&---------------------------------------------------------------------*
*&      Form  MAKE_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM make_header .
  CLEAR gt_title. REFRESH gt_title.

  CASE 'X'.
    WHEN rb1 OR rb2.
      gt_title-text = '상태'. APPEND gt_title.
      gt_title-text = '사번'. APPEND gt_title.
      gt_title-text = '이름'. APPEND gt_title.
      gt_title-text = '조직단위'. APPEND gt_title.
      gt_title-text = '조직키'. APPEND gt_title.
      gt_title-text = '부서명'. APPEND gt_title.
      gt_title-text = '코스트센터'. APPEND gt_title.
      gt_title-text = '코스트센터명'. APPEND gt_title.
      gt_title-text = '사원하위그룹'. APPEND gt_title.
      gt_title-text = '포지션명'. APPEND gt_title.
      gt_title-text = '직종'. APPEND gt_title.
      gt_title-text = '직급'. APPEND gt_title.
      gt_title-text = '등급'. APPEND gt_title.
      gt_title-text = '단가'. APPEND gt_title.
      gt_title-text = '선택근로제유형'. APPEND gt_title.
      gt_title-text = '근로주기'. APPEND gt_title.
      gt_title-text = '시작일'. APPEND gt_title.
      gt_title-text = '종료일'. APPEND gt_title.
      gt_title-text = '소정근로시간'. APPEND gt_title.
      gt_title-text = '평일총근로시간'. APPEND gt_title.
      gt_title-text = '휴일총근로시간'. APPEND gt_title.
      gt_title-text = '총근로시간'. APPEND gt_title.
      gt_title-text = '실근로시간'. APPEND gt_title.
      gt_title-text = '주중공휴일시간'. APPEND gt_title.
      gt_title-text = '인정근로시간'. APPEND gt_title.
      gt_title-text = '간주근로시간'. APPEND gt_title.
      gt_title-text = '출제위원근로시간'. APPEND gt_title.
      gt_title-text = '가산시간'. APPEND gt_title.
      gt_title-text = '초과근로시간'. APPEND gt_title.
      gt_title-text = '대휴일수'. APPEND gt_title.
      gt_title-text = '대휴시간'. APPEND gt_title.
      gt_title-text = '대휴수당'. APPEND gt_title.
      gt_title-text = '연장근로시간'. APPEND gt_title.
      gt_title-text = '연장근로수당'. APPEND gt_title.
      gt_title-text = '야간근로시간'. APPEND gt_title.
      gt_title-text = '야간근로수당'. APPEND gt_title.
      gt_title-text = '휴일근로시간'. APPEND gt_title.
      gt_title-text = '휴일근로수당'. APPEND gt_title.
      gt_title-text = '시차실비'. APPEND gt_title.
      gt_title-text = '기간실비'. APPEND gt_title.
      gt_title-text = '소급정산분'. APPEND gt_title.
      gt_title-text = '최종지급금액'. APPEND gt_title.
      gt_title-text = 'G/L계정'. APPEND gt_title.

    WHEN rb3.
      gt_title-text = '상태'. APPEND gt_title.
      gt_title-text = '사번'. APPEND gt_title.
      gt_title-text = '이름'. APPEND gt_title.
      gt_title-text = '조직단위'. APPEND gt_title.
      gt_title-text = '조직키'. APPEND gt_title.
      gt_title-text = '부서명'. APPEND gt_title.
      gt_title-text = '코스트센터'. APPEND gt_title.
      gt_title-text = '코스트센터명'. APPEND gt_title.
      gt_title-text = '사원하위그룹'. APPEND gt_title.
      gt_title-text = '포지션명'. APPEND gt_title.
      gt_title-text = '직종'. APPEND gt_title.
      gt_title-text = '근로일자'. APPEND gt_title.
      gt_title-text = '시작시간'. APPEND gt_title.
      gt_title-text = '종료시간'. APPEND gt_title.
      gt_title-text = '실근로시간'. APPEND gt_title.
      gt_title-text = '대휴여부'. APPEND gt_title.
      gt_title-text = '상신자사번'. APPEND gt_title.
      gt_title-text = '상신자명'. APPEND gt_title.
      gt_title-text = '상신일'. APPEND gt_title.
      gt_title-text = '결재자사번'. APPEND gt_title.
      gt_title-text = '결재자명'. APPEND gt_title.

    WHEN rb4.
      gt_title-text = '상태'. APPEND gt_title.
      gt_title-text = '정산대상연월'. APPEND gt_title.
      gt_title-text = 'PA전기일'. APPEND gt_title.
      gt_title-text = '사번'. APPEND gt_title.
      gt_title-text = '이름'. APPEND gt_title.
      gt_title-text = '조직단위'. APPEND gt_title.
      gt_title-text = '조직키'. APPEND gt_title.
      gt_title-text = '부서명'. APPEND gt_title.
      gt_title-text = '코스트센터'. APPEND gt_title.
      gt_title-text = '코스트센터명'. APPEND gt_title.
      gt_title-text = '사원하위그룹'. APPEND gt_title.
      gt_title-text = '포지션명'. APPEND gt_title.
      gt_title-text = '직종'. APPEND gt_title.
      gt_title-text = '선택근로제유형'. APPEND gt_title.
      gt_title-text = '최종지급금액'. APPEND gt_title.
      gt_title-text = '임금유형'. APPEND gt_title.
      gt_title-text = '임금유형명'. APPEND gt_title.
      gt_title-text = '금액(2010)'. APPEND gt_title.
      gt_title-text = '전표번호'. APPEND gt_title.
  ENDCASE.
ENDFORM.                    " MAKE_HEADER
*&---------------------------------------------------------------------*
*&      Form  MAKE_ITEM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM make_item .
  DATA: lv_hour(4),
        lv_min(2),
         lv_cost TYPE i.

  CASE 'X'.
    WHEN rb1 OR rb2.
      CLEAR gt_data_down. REFRESH gt_data_down.

      LOOP AT gt_disp2.
        MOVE-CORRESPONDING gt_disp2 TO gt_data_down.
*        IF rb1 = 'X'.
          "소정근로시간
          SPLIT gt_disp2-pwkhr AT ':' INTO lv_hour lv_min.
          gt_data_down-pwkhr = lv_hour + lv_min / 60.
          "총근로시간
          SPLIT gt_disp2-zrlwkhrtot AT ':' INTO lv_hour lv_min.
          gt_data_down-zrlwkhrtot = lv_hour + lv_min / 60.
          "실근로시간
          SPLIT gt_disp2-zrlwkhr AT ':' INTO lv_hour lv_min.
          gt_data_down-zrlwkhr = lv_hour + lv_min / 60.
          "주중공휴일시간
          SPLIT gt_disp2-zpubhhr AT ':' INTO lv_hour lv_min.
          gt_data_down-zpubhhr = lv_hour + lv_min / 60.
          "인정근로시간
          SPLIT gt_disp2-zprsdwkhr AT ':' INTO lv_hour lv_min.
          gt_data_down-zprsdwkhr = lv_hour + lv_min / 60.
          "간주근로시간
          SPLIT gt_disp2-zadtwkhr AT ':' INTO lv_hour lv_min.
          gt_data_down-zadtwkhr = lv_hour + lv_min / 60.
          "출제위원근로시간
          SPLIT gt_disp2-zedtwkhr AT ':' INTO lv_hour lv_min.
          gt_data_down-zedtwkhr = lv_hour + lv_min / 60.
          "가산시간
          SPLIT gt_disp2-zrladdwkhr AT ':' INTO lv_hour lv_min.
          gt_data_down-zrladdwkhr = lv_hour + lv_min / 60.
          "초과근로시간
          SPLIT gt_disp2-zrlexwkhr AT ':' INTO lv_hour lv_min.
          gt_data_down-zrlexwkhr = lv_hour + lv_min / 60.
          "대휴시간
          SPLIT gt_disp2-zdaehhr AT ':' INTO lv_hour lv_min.
          gt_data_down-zdaehhr = lv_hour + lv_min / 60.
          "연장근로시간
          SPLIT gt_disp2-zrlovrwkhr AT ':' INTO lv_hour lv_min.
          gt_data_down-zrlovrwkhr = lv_hour + lv_min / 60.
          "야간근로시간
          SPLIT gt_disp2-zrlngtwkhr AT ':' INTO lv_hour lv_min.
          gt_data_down-zrlngtwkhr = lv_hour + lv_min / 60.
          "휴일근로시간
          SPLIT gt_disp2-zrlholwkhr AT ':' INTO lv_hour lv_min.
          gt_data_down-zrlholwkhr = lv_hour + lv_min / 60.

*        ELSEIF rb2 = 'X'.
*          "소정근로시간
*          gt_data_down-pwkhr = gt_disp2-pwkhr(4) + gt_disp2-pwkhr+4(2) / 60.
*          "총근로시간
*          gt_data_down-zrlwkhrtot = gt_disp2-zrlwkhrtot(4) + gt_disp2-zrlwkhrtot+4(2) / 60.
*          "실근로시간
*          gt_data_down-zrlwkhr = gt_disp2-zrlwkhr(4) + gt_disp2-zrlwkhr+4(2) / 60.
*          "주중공휴일시간
*          gt_data_down-zpubhhr = gt_disp2-zpubhhr(4) + gt_disp2-zpubhhr+4(2) / 60.
*          "인정근로시간
*          gt_data_down-zprsdwkhr = gt_disp2-zprsdwkhr(4) + gt_disp2-zprsdwkhr+4(2) / 60.
*          "간주근로시간
*          gt_data_down-zadtwkhr = gt_disp2-zadtwkhr(4) + gt_disp2-zadtwkhr+4(2) / 60.
*          "출제위원근로시간
*          gt_data_down-zedtwkhr = gt_disp2-zedtwkhr(4) + gt_disp2-zedtwkhr+4(2) / 60.
*          "가산시간
*          gt_data_down-zrladdwkhr = gt_disp2-zrladdwkhr(4) + gt_disp2-zrladdwkhr+4(2) / 60.
*          "초과근로시간
*          gt_data_down-zrlexwkhr = gt_disp2-zrlexwkhr(4) + gt_disp2-zrlexwkhr+4(2) / 60.
*          "대휴시간
*          gt_data_down-zdaehhr = gt_disp2-zdaehhr(4) + gt_disp2-zdaehhr+4(2) / 60.
*          "연장근로시간
*          gt_data_down-zrlovrwkhr = gt_disp2-zrlovrwkhr(4) + gt_disp2-zrlovrwkhr+4(2) / 60.
*          "야간근로시간
*          gt_data_down-zrlngtwkhr = gt_disp2-zrlngtwkhr(4) + gt_disp2-zrlngtwkhr+4(2) / 60.
*          "휴일근로시간
*          gt_data_down-zrlholwkhr = gt_disp2-zrlholwkhr(4) + gt_disp2-zrlholwkhr+4(2) / 60.
*        ENDIF.

        "단가
        lv_cost = gt_disp2-zcost * 100.
        gt_data_down-zcost = lv_cost.
        "대휴수당
        lv_cost = gt_disp2-zdaehamt * 100.
        gt_data_down-zdaehamt = lv_cost.
        "연장근로수당
        lv_cost = gt_disp2-zrlovramt * 100.
        gt_data_down-zrlovramt = lv_cost.
        "야간근로수당
        lv_cost = gt_disp2-zrlngtamt * 100.
        gt_data_down-zrlngtamt = lv_cost.
        "휴일근로수당
        lv_cost = gt_disp2-zrlholamt * 100.
        gt_data_down-zrlholamt = lv_cost.
        "시차실비
        lv_cost = gt_disp2-tdcost * 100.
        gt_data_down-tdcost = lv_cost.
        "기간실비
        lv_cost = gt_disp2-zrlprdamt * 100.
        gt_data_down-zrlprdamt = lv_cost.
        "소급정산분
        lv_cost = gt_disp2-zretroamt * 100.
        gt_data_down-zretroamt = lv_cost.
        "최종지급금액
        lv_cost = gt_disp2-zotpayamt * 100.
        gt_data_down-zotpayamt = lv_cost.

        APPEND gt_data_down.
      ENDLOOP.

    WHEN rb3.
      CLEAR gt_data_down2. REFRESH gt_data_down2.

      LOOP AT gt_disp.
        MOVE-CORRESPONDING gt_disp TO gt_data_down2.
        "실근로시간
        gt_data_down2-zrlwk_tm = gt_disp-zrlwk_tm(2) + gt_disp-zrlwk_tm+2(2) / 60.

        APPEND gt_data_down2.
      ENDLOOP.

    WHEN rb4.
      CLEAR gt_data_down3. REFRESH gt_data_down3.

      LOOP AT gt_disp3.
        MOVE-CORRESPONDING gt_disp3 TO gt_data_down3.
        "최종지급금액
        lv_cost = gt_disp3-zotpayamt * 100.
        gt_data_down3-zotpayamt = lv_cost.
        "금액(2010)
        lv_cost = gt_disp3-betrg * 100.
        gt_data_down3-betrg = lv_cost.

        APPEND gt_data_down3.
      ENDLOOP.
  ENDCASE.
ENDFORM.                    " MAKE_ITEM
