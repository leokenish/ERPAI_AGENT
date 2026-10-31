*&---------------------------------------------------------------------*
*&  Include           ZRPTH410F01
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
  DATA lv_daynr TYPE hrvsched-daynr.

  "검색기간 시작일
  p_frdat = sy-datum(6).
  p_frdat+6(2) = '01'.

  "검색기간 종료일
  CALL FUNCTION 'HR_IN_LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = p_frdat
    IMPORTING
      last_day_of_month = p_todat
    EXCEPTIONS
      day_in_no_date    = 1
      OTHERS            = 2.

  "대휴생성 대상년월
  p_dhdat = sy-datum(6).

  "기준일
**  p_kjdat = sy-datum.
**  p_dhdat = sy-datum.

*  DO.
*    CALL FUNCTION 'RH_GET_DATE_DAYNAME'
*      EXPORTING
*        langu = sy-langu
*        date  = p_kjdat
*      IMPORTING
*        daynr = lv_daynr.
*
*    IF lv_daynr = '1'.
*      EXIT.
*    ENDIF.
*    p_kjdat = p_kjdat - 1.
*  ENDDO.

  "레이아웃 포멧
  gs_format-name01 = '사번'.
  gs_format-name02 = '이름'.
  gs_format-name03 = '시작일'.
  gs_format-name04 = '종료일'.
  gs_format-name05 = '근로유형'.
  gs_format-name06 = '근로유형명'.
  gs_format-name07 = '정산주기'.
  APPEND gs_format TO gt_format.

  gs_format-name01 = '12345'.
  gs_format-name02 = '홍일동'.
  gs_format-name03 = '20190101'.
  gs_format-name04 = '20191231'.
  CONCATENATE '''' '0110' INTO gs_format-name05.
  gs_format-name06 = '선택'.
  CONCATENATE '''' '04' INTO gs_format-name07.
  APPEND gs_format TO gt_format.

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
  DATA: lv_realo LIKE objec-realo,
        lv_begda TYPE begda,
        lv_endda TYPE endda.

  IF p_select = 'X'.  "재량수당 조회
    lv_begda = p_frdat.
    lv_endda = p_todat.
  ELSE.  "재량수당 생성
    lv_begda = p_kjdat.
    lv_endda = p_kjdat.
  ENDIF.

  IF lv_begda IS INITIAL OR lv_endda IS INITIAL.
    lv_begda = sy-datum.
    lv_endda = sy-datum.
  ENDIF.


  CALL FUNCTION 'RH_DETERMINE_ORG_OBJID'
    EXPORTING
      org_object_type       = 'O'
      act_plvar             = '01'
      f4_mode               = 'X'
      seark_begda           = lv_begda
      seark_endda           = lv_endda
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
*&      Form  F4_DHDAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f4_dhdat .
  DATA: lv_mf_returncode LIKE sy-subrc,
            lv_mf_monat  LIKE isellist-month.

  DATA lt_mf_dynpfields TYPE TABLE OF dynpread WITH HEADER LINE.

  lt_mf_dynpfields-fieldname = 'P_DHDAT'.
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
      selected_month             = p_dhdat
      return_code                = lv_mf_returncode
    EXCEPTIONS
      factory_calendar_not_found = 1
      holiday_calendar_not_found = 2
      month_not_found            = 3
      OTHERS                     = 4.
  IF sy-subrc = 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.                    " F4_DHDAT
*&---------------------------------------------------------------------*
*&      Form  SELECT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM select_data .
  DATA: lv_begda TYPE begda,
        lv_endda TYPE endda.

  DATA: lt_tmp LIKE TABLE OF gt_disp WITH HEADER LINE,
        lt_zthr0132 TYPE TABLE OF zthr0132 WITH HEADER LINE,
        lt_oinfo TYPE TABLE OF zth0500 WITH HEADER LINE.


  DATA: ls_tmp LIKE lt_tmp.

  DATA: ls_z52wktp TYPE hrecm00keyandtext ,
        lt_z52wktp TYPE TABLE OF hrecm00keyandtext.


  IF p_frdat IS INITIAL OR p_todat IS INITIAL.
    gv_stop = 'X'.
    MESSAGE s001 DISPLAY LIKE 'E' WITH '검색기간을 입력하십시오.'.
    RETURN.
  ENDIF.

  lv_begda = p_frdat.
  lv_endda = p_todat.

  SELECT a~pernr a~begda a~endda a~z52wktp a~z52prsq
         b~ename b~vdsk1
    INTO CORRESPONDING FIELDS OF TABLE lt_tmp
    FROM pa9021 AS a INNER JOIN pa0001 AS b
                     ON a~pernr = b~pernr
   WHERE a~z52wktp = '0110'
     AND a~pernr IN s_pernr
     AND a~begda <= lv_endda
     AND a~endda >= lv_begda
     AND b~vdsk1 IN s_orgeh
     AND b~begda <= lv_begda
     AND b~endda >= lv_begda.

  IF sy-subrc = 0.
    SELECT *
      INTO CORRESPONDING FIELDS OF TABLE lt_zthr0132
      FROM zthr0132
      FOR ALL ENTRIES IN lt_tmp
     WHERE pernr = lt_tmp-pernr
       AND z52wktp = lt_tmp-z52wktp
       AND z52prsq = lt_tmp-z52prsq
       AND begda <= lv_endda
       AND endda >= lv_begda.

    "부서정보,
*    SELECT *
*      INTO CORRESPONDING FIELDS OF TABLE lt_oinfo
*      FROM zth0500
*     WHERE begda <= lv_endda
*       AND endda >= lv_begda.

   "이전 기간 부서정보들도 가져와야 함
   SORT lt_tmp ASCENDING BY begda.
   READ TABLE lt_tmp INDEX 1 INTO ls_tmp.

    SELECT *
      INTO CORRESPONDING FIELDS OF TABLE lt_oinfo
      FROM zth0500
     WHERE begda <= lv_endda
       AND endda >= ls_tmp-begda.


    "근로유형
    CALL FUNCTION 'ZHR_52TM_WKTYPE'
      IMPORTING
        resulttab = lt_z52wktp.
  ENDIF.


  LOOP AT lt_tmp.
    MOVE-CORRESPONDING lt_tmp TO gt_disp.

    READ TABLE lt_z52wktp INTO ls_z52wktp WITH KEY keyfield = gt_disp-z52wktp.
    IF sy-subrc = 0.
      gt_disp-z52wktp_tx = ls_z52wktp-textfield.
    ENDIF.

    LOOP AT lt_oinfo WHERE objid = gt_disp-vdsk1
                       AND begda <= gt_disp-begda
                       AND endda >= gt_disp-begda.
      gt_disp-zorder = lt_oinfo-zorder.
      gt_disp-vdsk1_tx = lt_oinfo-fname.
      EXIT.
    ENDLOOP.


    LOOP AT lt_zthr0132 WHERE pernr = lt_tmp-pernr
                          AND z52wktp = lt_tmp-z52wktp
                          AND z52prsq = lt_tmp-z52prsq
                          AND begda BETWEEN lt_tmp-begda AND lt_tmp-endda
                          AND endda BETWEEN lt_tmp-begda AND lt_tmp-endda.

      gt_disp-wkbeg = lt_zthr0132-begda.
      gt_disp-wkend = lt_zthr0132-endda.

      APPEND gt_disp.
    ENDLOOP.

    CLEAR gt_disp.
  ENDLOOP.

  SORT gt_disp BY zorder pernr.
  DESCRIBE TABLE gt_disp LINES g_line.
ENDFORM.                    " SELECT_DATA
*&---------------------------------------------------------------------*
*&      Form  CREATE_WORK_PERIOD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_BEGDA  text
*      -->P_LV_ENDDA  text
*----------------------------------------------------------------------*
FORM create_work_period  TABLES pt_tmp LIKE gt_disp[].
  DATA: lt_zthr0101 TYPE TABLE OF zthr0101 WITH HEADER LINE.

  DATA: lv_wkbeg TYPE dats,
        lv_zcnval TYPE zthr0101-zcnval.

  CLEAR: gt_error, gt_zthr0132.
  REFRESH: gt_error, gt_zthr0132.

  "총근로시간/소정근로시간
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE lt_zthr0101
    FROM zthr0101
   WHERE zconst = 'ZSTOT_4' OR zconst = 'ZSFWH_4' OR zconst = 'ZNORHR'.


  LOOP AT pt_tmp.
    CLEAR lv_wkbeg.

    SELECT endda
      INTO lv_wkbeg
      UP TO 1 ROWS
      FROM zthr0132
     WHERE pernr = pt_tmp-pernr
       AND z52wktp = pt_tmp-z52wktp
       AND z52prsq = pt_tmp-z52prsq
       AND begda <= pt_tmp-endda
       AND endda >= pt_tmp-begda
    ORDER BY endda DESCENDING.
    ENDSELECT.

    IF sy-subrc = 0.
      lv_wkbeg = lv_wkbeg + 1.
    ELSE.
      lv_wkbeg = pt_tmp-begda.
    ENDIF.



    DO.
      CLEAR gt_zthr0132.
      gt_zthr0132-pernr = pt_tmp-pernr.
      "근로유형/근무주기
      gt_zthr0132-z52wktp = pt_tmp-z52wktp.
      gt_zthr0132-z52prsq = pt_tmp-z52prsq.

      "시작일
      gt_zthr0132-begda = lv_wkbeg.
      "종료일(근무주기 후 일요일)
      gt_zthr0132-endda = lv_wkbeg + ( pt_tmp-z52prsq * 7 ) - 1.


      gt_error-pernr = pt_tmp-pernr.
      gt_error-z52wktp = pt_tmp-z52wktp.
      gt_error-z52prsq = pt_tmp-z52prsq.

      "1. 주기시작일은 기준일보다 같거나 작아야 한다
      IF NOT ( gt_zthr0132-begda <= p_kjdat ).
*        gt_error-msg = '주기 시작일은 기준일보다 같거나 작아야 합니다.'.
*        APPEND gt_error.

        EXIT.
      ENDIF.

      "2. 주기시작일은 선택근로 시작일 종료일 이내여야 한다.
      IF NOT ( gt_zthr0132-begda BETWEEN pt_tmp-begda AND pt_tmp-endda ).
        gt_error-msg = '주기 시작일은 선택근로 기간내의 일자여야 합니다.'.
        APPEND gt_error.

        EXIT.
      ENDIF.

      "3. 주기종료일은 선택근로 시작일 종료일 이내여야 한다.
      IF NOT ( gt_zthr0132-endda BETWEEN pt_tmp-begda AND pt_tmp-endda ).
        gt_error-msg = '주기 종료일은 선택근로 기간내의 일자여야 합니다.'.
        APPEND gt_error.

        EXIT.
      ENDIF.

      "총근로시간
      LOOP AT lt_zthr0101 WHERE zconst = 'ZSTOT_4'
                            AND begda <= gt_zthr0132-begda
                            AND endda >= gt_zthr0132-begda.
        gt_zthr0132-twkhr = lt_zthr0101-zcnval.
      ENDLOOP.

      "소정근로시간
      LOOP AT lt_zthr0101 WHERE zconst = 'ZSFWH_4'
                            AND begda <= gt_zthr0132-begda
                            AND endda >= gt_zthr0132-begda.
        gt_zthr0132-pwkhr = lt_zthr0101-zcnval.
      ENDLOOP.

      "주중공휴일 시간(하루)
      LOOP AT lt_zthr0101 WHERE zconst = 'ZNORHR'
                            AND begda <= gt_zthr0132-begda
                            AND endda >= gt_zthr0132-begda.
        lv_zcnval = lt_zthr0101-zcnval.
      ENDLOOP.

      "주중공휴일시간
      PERFORM get_period_holiday_hour USING gt_zthr0132-begda
                                            gt_zthr0132-endda
                                            lv_zcnval
                                      CHANGING gt_zthr0132-hodhr.


      "연장(가능)시간
      gt_zthr0132-owkhr = gt_zthr0132-twkhr - gt_zthr0132-pwkhr.
      CONDENSE gt_zthr0132-owkhr NO-GAPS.

      gt_zthr0132-aedat = sy-datum.
      gt_zthr0132-aezet = sy-uzeit.
      gt_zthr0132-aenam = sy-uname.
      APPEND gt_zthr0132.

      lv_wkbeg = gt_zthr0132-endda + 1.
    ENDDO.
  ENDLOOP.

  IF gt_zthr0132[] IS NOT INITIAL.
    INSERT zthr0132 FROM TABLE gt_zthr0132.
    COMMIT WORK.
  ENDIF.

ENDFORM.                    " CREATE_WORK_PERIOD
*&---------------------------------------------------------------------*
*&      Form  GET_PERIOD_HOLIDAY_HOUR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_SAVE_BEGDA  text
*      -->P_LT_SAVE_ENDDA  text
*      <--P_LT_SAVE_HODHR  text
*----------------------------------------------------------------------*
FORM get_period_holiday_hour  USING    pv_begda
                                       pv_endda
                                       pv_zcnval
                              CHANGING pv_hodhr.

  DATA lt_attributes TYPE TABLE OF casdayattr WITH HEADER LINE.

  CALL FUNCTION 'DAY_ATTRIBUTES_GET'
   EXPORTING
     factory_calendar                 = 'KR'
     holiday_calendar                 = 'KB'
     date_from                        = pv_begda
     date_to                          = pv_endda
     language                         = sy-langu
*   NON_ISO                          = ' '
* IMPORTING
*   YEAR_OF_VALID_FROM               =
*   YEAR_OF_VALID_TO                 =
*   RETURNCODE                       =
    TABLES
      day_attributes                   = lt_attributes
   EXCEPTIONS
     factory_calendar_not_found       = 1
     holiday_calendar_not_found       = 2
     date_has_invalid_format          = 3
     date_inconsistency               = 4
     OTHERS                           = 5.

  LOOP AT lt_attributes WHERE NOT ( weekday = '6' OR weekday = '7' )
                          AND holiday = 'X'.
    ADD pv_zcnval TO pv_hodhr.
  ENDLOOP.

  CONDENSE pv_hodhr NO-GAPS.

ENDFORM.                    " GET_PERIOD_HOLIDAY_HOUR
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

  PERFORM append_init_fieldcat USING:
   '01' 'X' 'ZORDER'      '부서레벨'      'C' ' ',
   '02' 'X' 'PERNR'       '사번'          'C' ' ',
   '03' 'X' 'ENAME'       '이름'          'C' ' ',
   '04' 'X' 'VDSK1'       '부서코드'      'C' ' ',
   '05' ' ' 'VDSK1_TX'    '부서명'        'L' ' ',
   '06' ' ' 'BEGDA'       '선택시작일'    'C' ' ',
   '07' ' ' 'ENDDA'       '선택종료일'    'C' ' ',
   '08' ' ' 'Z52WKTP_TX'  '근로유형'      'C' ' ',
   '09' ' ' 'Z52PRSQ'     '근무주기'      'C' ' '.

  IF p_select = 'X'.
    PERFORM append_init_fieldcat USING:
    '10' ' ' 'WKBEG'      '주기시작일'    'C' ' ',
    '11' ' ' 'WKEND'      '주기종료일'    'C' ' '.
  ELSEIF p_cre1 = 'X'.
    PERFORM append_init_fieldcat USING:
    '10' ' ' 'MSG'         '메세지'        'L' ' '.
  ELSEIF p_cre2 = 'X'.
    PERFORM append_init_fieldcat USING:
    '10' ' ' 'WKBEG'       '주기시작일'    'C' ' ',
    '11' ' ' 'WKEND'       '주기종료일'    'C' ' ',
    '12' ' ' 'MSG'         '메세지'        'L' ' '.

  ELSEIF p_cre3 = 'X'.
    PERFORM append_init_fieldcat USING:
    '10' ' ' 'WKBEG'       '주기시작일'   'C' ' ',
    '11' ' ' 'WKEND'       '주기종료일'   'C' ' ',
    '12' ' ' 'ZDAEH_DAY'   '대휴일수'     'R' ' ',
    '13' ' ' 'ZDDAY'       '대휴발생일'   'C' ' ',
    '14' ' ' 'MSG'         '메세지'       'L' ' '.
  ENDIF.

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
      ls_fcat-emphasize = 'C600'.
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
  ELSEIF ls_fcat-fieldname = 'BETRG'.
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

  IF p_select = 'X'.  "재량수당 조회
    WRITE p_frdat TO l_text1 USING EDIT MASK '____.__.__'.
    WRITE p_todat TO l_text2 USING EDIT MASK '____.__.__'.
    CONCATENATE `검색기간 :`  l_text1 ` ~ ` l_text2 INTO l_text SEPARATED BY space.
  ELSEIF p_cre2 = 'X'.
    WRITE p_kjdat TO l_text1 USING EDIT MASK '____.__.__'.
    CONCATENATE `기준일자 :`  l_text1 INTO l_text SEPARATED BY space.
  ENDIF.

  IF p_cre1 <> 'X'.
    CALL METHOD p_dyndoc_id->add_text
      EXPORTING
        text         = l_text
        sap_fontsize = cl_dd_area=>medium
        sap_emphasis = cl_dd_document=>strong
        sap_color    = cl_dd_area=>list_positive_inv.
    CALL METHOD p_dyndoc_id->new_line.
  ENDIF.

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
*&      Form  OPEN_EXCEL2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM open_excel2 .
  DATA: ole_excel TYPE ole2_object,
        ole_books TYPE ole2_object,
        ole_sheets TYPE ole2_object,
        cell TYPE ole2_object.

  DATA: lv_row TYPE i,
        lv_ind TYPE n LENGTH 2,
        lv_field(20).

  FIELD-SYMBOLS <fs> TYPE ANY.


* APP 실행 준비를 한다.
  IF ole_excel-header = space OR ole_excel-handle = -1.
    CREATE OBJECT ole_excel 'Excel.Application'.
  ENDIF.

* 엑셀 돌아가는것이 보이는 모드로 한다. 0은 안보임
  SET PROPERTY OF ole_excel 'VISIBLE' = 1.

  CALL METHOD OF ole_excel 'Workbooks' = ole_books.

* 입력받은 파일명의 엑셀을 연다. 이때 실제적으로 열린다.
  CALL METHOD OF ole_books 'ADD'.

* 엑셀의 첫번째 쉬트를 지정한다.
  CALL METHOD OF ole_excel 'Worksheets' = ole_sheets
    EXPORTING #1 = 1.

* 지정한 쉬트를 활성화한다.
  CALL METHOD OF ole_sheets 'Activate'.

* 셀을 지정 하여 작업을 한다
* SET 는 입력 GET은 출력이다.(읽어오기)
  LOOP AT gt_format INTO gs_format.
    ADD 1 TO lv_row.

    DO 7 TIMES.
      lv_ind = sy-index.

      CALL METHOD OF ole_excel 'CELLS' = cell
        EXPORTING
        #1 = lv_row
        #2 = sy-index.

      CONCATENATE 'gs_format-name' lv_ind INTO lv_field.
      ASSIGN (lv_field) TO <fs>.

      SET PROPERTY OF cell 'VALUE' = <fs>.
    ENDDO.
  ENDLOOP.

ENDFORM.                    " OPEN_EXCEL2
*&---------------------------------------------------------------------*
*&      Form  UPLOAD_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM upload_data .
  DATA: lt_ftable TYPE TABLE OF file_table,
        lv_rc TYPE i,
        lv_filename TYPE rlgrap-filename,
        lt_xls TYPE alsmex_tabline OCCURS 0 WITH HEADER LINE,
        lt_tmp TYPE TABLE OF ty_format WITH HEADER LINE,
        lv_s_cnt TYPE i,
        lv_e_cnt TYPE i,
        lv_answer TYPE c,
        ls_p9021 TYPE p9021,
        ls_return LIKE bapireturn1.


  DATA: lv_indx TYPE n LENGTH 2,
        lv_field(20),
        lv_daynr TYPE hrvsched-daynr.


  FIELD-SYMBOLS <fs>.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    CHANGING
      file_table              = lt_ftable
      rc                      = lv_rc
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5.

  IF sy-subrc <> 0.
    MESSAGE s031 DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  IF lv_rc <> 1.
    MESSAGE s001 DISPLAY LIKE 'E' WITH '업로드를 취소하였습니다.'.
    EXIT.
  ENDIF.

  READ TABLE lt_ftable INDEX 1 INTO lv_filename.

  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = lv_filename
      i_begin_col             = 1
      i_begin_row             = 2
      i_end_col               = 256
      i_end_row               = 65536
    TABLES
      intern                  = lt_xls
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.

  IF sy-subrc NE 0.
    MESSAGE s001 DISPLAY LIKE 'E' WITH '업로드 중 오류가 발생했습니다.'.
    EXIT.
  ELSE.
    LOOP AT lt_xls.
      ASSIGN COMPONENT lt_xls-col OF STRUCTURE lt_tmp TO <fs>.
      <fs> = lt_xls-value.
      AT END OF row.
        APPEND lt_tmp.
        CLEAR  lt_tmp.
      ENDAT.
    ENDLOOP.
  ENDIF.

  IF lt_xls[] IS INITIAL.
    MESSAGE s001 DISPLAY LIKE 'E' WITH '업로드된 데이터가 없습니다. 파일을 확인하세요.'.
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

  CLEAR gt_disp. REFRESH gt_disp.

  LOOP AT lt_tmp.
    CLEAR gt_disp.
    gt_disp-pernr = lt_tmp-name01.
    gt_disp-ename = lt_tmp-name02.
    gt_disp-begda = lt_tmp-name03.
    gt_disp-endda = lt_tmp-name04.
    gt_disp-z52wktp = lt_tmp-name05.
    gt_disp-z52wktp_tx = lt_tmp-name06.
    gt_disp-z52prsq = lt_tmp-name07.

    SELECT SINGLE vdsk1
      INTO gt_disp-vdsk1
      FROM pa0001
     WHERE pernr = gt_disp-pernr
       AND begda <= gt_disp-begda
       AND endda >= gt_disp-endda.

    "부서정보
    SELECT SINGLE zorder fname
      INTO (gt_disp-zorder, gt_disp-vdsk1_tx)
      FROM zth0500
     WHERE objid = gt_disp-vdsk1
       AND begda <= gt_disp-begda
       AND endda >= gt_disp-endda.


    CLEAR ls_p9021.
    ls_p9021-infty = '9021'.
    ls_p9021-pernr = lt_tmp-name01.
    ls_p9021-begda = lt_tmp-name03.
    ls_p9021-endda = lt_tmp-name04.
    ls_p9021-z52wktp = lt_tmp-name05.
    ls_p9021-z52prsq = lt_tmp-name07.

    IF ls_p9021-z52wktp IS INITIAL OR
       ls_p9021-z52prsq IS INITIAL.

      ADD 1 TO lv_e_cnt.
      gt_disp-msg = '근로유형, 근무주기는 필수입력입니다.'.
      APPEND gt_disp.
      CONTINUE.
    ENDIF.

    CALL FUNCTION 'RH_GET_DATE_DAYNAME'
      EXPORTING
        langu = sy-langu
        date  = ls_p9021-begda
      IMPORTING
        daynr = lv_daynr.

    IF lv_daynr <> '1'.
      ADD 1 TO lv_e_cnt.
      gt_disp-msg = '선택근로 시작일은 월요일입니다.'.
      APPEND gt_disp.
      CONTINUE.
    ENDIF.

    PERFORM employee_enqueue USING ls_p9021-pernr
                             CHANGING ls_return.
    IF ls_return-type EQ 'E'.
      PERFORM employee_dequeue USING ls_p9021-pernr
                               CHANGING ls_return.
    ENDIF.

    IF ls_return-type NE 'E'.
      PERFORM employee_check_flex  USING ls_p9021
                                   CHANGING ls_return.
    ENDIF.

    IF ls_return-type NE 'E'.
      PERFORM hr_infotype_operation USING ls_p9021
                                    CHANGING ls_return.
    ENDIF.

    IF ls_return IS NOT INITIAL.
      ADD 1 TO lv_e_cnt.

      gt_disp-msg = ls_return-message.
      APPEND gt_disp.
    ELSE.
      ADD 1 TO lv_s_cnt.
      gt_disp-msg = '등록되었습니다.'.
      APPEND gt_disp.
    ENDIF.

    PERFORM employee_dequeue USING ls_p9021-pernr
                             CHANGING ls_return.
  ENDLOOP.

  IF lv_e_cnt = 0.
    MESSAGE s001 DISPLAY LIKE 'S'  WITH lv_s_cnt '건 등록되었습니다.'.
  ELSE.
    MESSAGE s001 DISPLAY LIKE 'S'  WITH lv_s_cnt '건 등록,' lv_e_cnt '건 오류'.
  ENDIF.

  DESCRIBE TABLE gt_disp LINES g_line.
ENDFORM.                    " UPLOAD_DATA
*&---------------------------------------------------------------------*
*&      Form  EMPLOYEE_ENQUEUE
*&---------------------------------------------------------------------*
*       사원 잠금
*----------------------------------------------------------------------*
*      -->P_G_PERNR  text
*      <--P_LS_RETURN  text
*----------------------------------------------------------------------*
FORM employee_enqueue  USING    p_pernr
                       CHANGING ps_return TYPE bapireturn1.

  CLEAR ps_return.

  CALL FUNCTION 'BAPI_EMPLOYEE_ENQUEUE'
    EXPORTING
      number = p_pernr
    IMPORTING
      return = ps_return.

ENDFORM.                    " EMPLOYEE_ENQUEUE
*&---------------------------------------------------------------------*
*&      Form  EMPLOYEE_DEQUEUE
*&---------------------------------------------------------------------*
*       사원잠금해제
*----------------------------------------------------------------------*
*      -->P_G_PERNR  text
*      <--P_LS_RETURN  text
*----------------------------------------------------------------------*
FORM employee_dequeue  USING    p_pernr
                       CHANGING ps_return TYPE bapireturn1.

  CLEAR ps_return.

  CALL FUNCTION 'BAPI_EMPLOYEE_DEQUEUE'
    EXPORTING
      number = p_pernr
    IMPORTING
      return = ps_return.

ENDFORM.                    " EMPLOYEE_DEQUEUE
*&---------------------------------------------------------------------*
*&      Form  HR_INFOTYPE_OPERATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_P9021  text
*      <--P_LS_RETURN  text
*----------------------------------------------------------------------*
FORM hr_infotype_operation  USING    ps_p9021  TYPE p9021
                            CHANGING ps_return TYPE bapireturn1.

  DATA ls_pa9021 TYPE pa9021.

  SELECT SINGLE *
    INTO CORRESPONDING FIELDS OF ls_pa9021
    FROM pa9021
   WHERE pernr = ps_p9021-pernr
     AND begda <= ps_p9021-endda
     AND endda >= ps_p9021-begda.

  IF sy-subrc = 0.
    IF ls_pa9021-z52wktp = '0110'.
      ps_return-type = 'E'.
      ps_return-message = '해당 기간에 선택근로가 등록되어 있습니다.'.
    ELSE.
      ps_return-type = 'E'.
      ps_return-message = '해당 기간에 다른 유연근로가 등록되어 있습니다.'.
    ENDIF.

    EXIT.
  ENDIF.

  CALL FUNCTION 'HR_INFOTYPE_OPERATION'
    EXPORTING
      infty     = ps_p9021-infty
      number    = ps_p9021-pernr
      record    = ps_p9021
      operation = 'INS'
    IMPORTING
      return    = ps_return.
ENDFORM.                    " HR_INFOTYPE_OPERATION
*&---------------------------------------------------------------------*
*&      Form  CREATE_WORK_DH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_TMP  text
*----------------------------------------------------------------------*
FORM create_work_dh  TABLES   pt_tmp LIKE gt_disp[].
*  DATA lt_zthr0132 TYPE TABLE OF zthr0132 WITH HEADER LINE.
*
*  "선택근로제 기간
*  SELECT *
*    INTO CORRESPONDING FIELDS OF TABLE lt_zthr0132
*    FROM zthr0132
*    FOR ALL ENTRIES IN pt_tmp
*   WHERE pernr = pt_tmp-pernr
*     AND z52wktp = pt_tmp-z52wktp
*     AND z52prsq = pt_tmp-z52prsq
*     AND begda <= p_dhdat
*     AND endda >= p_dhdat.
*
*  CHECK lt_zthr0132[] IS NOT INITIAL.
*
*
*  CALL FUNCTION 'ZHR_52TM_CW_CAL_AND_DAEH'
*    EXPORTING
*      i_case      = 'C'
*    TABLES
*      lt_zthr0132 = lt_zthr0132
*      lt_daeh     = gt_daeh
*      lt_save     = gt_save.

ENDFORM.                    " CREATE_WORK_DH
*&---------------------------------------------------------------------*
*&      Form  MAKE_DAEH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_ZTHR0112  text
*      <--P_LT_SAVE  text
*----------------------------------------------------------------------*
FORM make_daeh_data  USING  ps_zthr0112 LIKE LINE OF gt_zthr0112
                            pv_exh
                            pv_remain_stdaz.

  DATA: lt_zshr0115 TYPE TABLE OF zshr0115,
        ls_zshr0115 TYPE zshr0115,
        lt_data TYPE ztshr0115 WITH HEADER LINE,
        lt_attributes TYPE TABLE OF casdayattr WITH HEADER LINE,
        lv_sign TYPE i,
        lv_chk,
        lv_zdaeh_t_min TYPE i,
        lv_min TYPE i,
        lv_zrlwk_t_min TYPE i,
        lv_zrlwk_tm TYPE zshr0115-zrlwk_tm.


  MOVE-CORRESPONDING ps_zthr0112 TO ls_zshr0115.

  CALL FUNCTION 'ZHR_52TM_CALC_WORK_TIME_DAYILY'
    EXPORTING
      is_day     = ls_zshr0115
    TABLES
      t_day_time = lt_zshr0115.

  "잔여 소정근로시간을 전부 소진 못하고 남은 시간을 제외한다.
  IF pv_remain_stdaz > 0.
    LOOP AT lt_zshr0115 INTO ls_zshr0115.
      lv_sign = SIGN( ls_zshr0115-stdaz - pv_remain_stdaz ).
      IF lv_sign < 1.
        pv_remain_stdaz = ABS( ls_zshr0115-stdaz - pv_remain_stdaz ).
        ls_zshr0115-stdaz = 0.
      ELSE.
        ls_zshr0115-stdaz = ls_zshr0115-stdaz - pv_remain_stdaz.
        pv_remain_stdaz = 0.
      ENDIF.

      MODIFY lt_zshr0115 FROM ls_zshr0115.
    ENDLOOP.
  ENDIF.

  "전체 휴일이고, 4.5시간 미만이면 합친다.
  LOOP AT lt_zshr0115 INTO ls_zshr0115.
    IF ls_zshr0115-days <> '0'. "전체 휴일인가(0:휴일)
      lv_chk = 'X'. EXIT.
    ENDIF.

    IF ls_zshr0115-stdaz >= '4.5'. "4.5 시간 미만인가
      lv_chk = 'X'. EXIT.
    ENDIF.

    PERFORM convert_time_to_min IN PROGRAM saplzhr008_3
                                USING ls_zshr0115-zrlwk_tm
                                CHANGING lv_min.
    ADD lv_min TO lv_zrlwk_t_min.
  ENDLOOP.

  IF lv_chk IS INITIAL.
    PERFORM convert_min_to_time IN PROGRAM saplzhr008_3
                                USING lv_zrlwk_t_min
                                CHANGING lv_zrlwk_tm.

    LOOP AT lt_zshr0115 INTO ls_zshr0115.
      lt_data-datum = ps_zthr0112-datum.  "발생일
*      lt_data-zgubun = ls_zshr0115-zgubun.
      lt_data-zrlwk_tm = lv_zrlwk_tm.  "실근로시간
      lt_data-stdaz = ls_zshr0115-stdaz.
      lt_data-days = ls_zshr0115-days.
      COLLECT lt_data. CLEAR lt_data.
    ENDLOOP.
  ELSE.
    lt_data[] = lt_zshr0115[].
  ENDIF.


  LOOP AT lt_data WHERE days = '0'
                    AND stdaz >= '4.5'.

    CALL FUNCTION 'DAY_ATTRIBUTES_GET'
      EXPORTING
        factory_calendar           = 'KR'
        holiday_calendar           = 'KB'
        date_from                  = lt_data-datum
        date_to                    = lt_data-datum
        language                   = sy-langu
      TABLES
        day_attributes             = lt_attributes
      EXCEPTIONS
        factory_calendar_not_found = 1
        holiday_calendar_not_found = 2
        date_has_invalid_format    = 3
        date_inconsistency         = 4
        OTHERS                     = 5.

    READ TABLE lt_attributes INDEX 1.

    IF pv_exh = 'N'.  "잔여 소정근로시간 남아 있는 경우
      "주중 공휴일에만 대휴발생
      CHECK lt_attributes-holiday = 'X' AND NOT ( lt_attributes-weekday = '6' OR lt_attributes-weekday = '7' ).
    ELSE.  "잔여 소정근로시간 없거나, 전부 소진 못하고 남은 경우
      "휴일때 발생
      CHECK lt_attributes-freeday = 'X'.
    ENDIF.

    ADD 1 TO ps_zthr0112-zdaeh_day.

    "대휴시간 합
    PERFORM convert_time_to_min IN PROGRAM saplzhr008_3
                                USING lt_data-zrlwk_tm
                                CHANGING lv_min.
    ADD lv_min TO lv_zdaeh_t_min.

*->>> 저장 이벤트로 변경
*    "ZTHR0112 테이블 생성
*    PERFORM make_zthrbs01 USING ps_zthr0112-pernr
*                                ps_zthr0112-endda
*                                ps_zthr0112-zcost
*                                ps_zthr0112-datum
*                                lt_data-datum
*                                lt_data-zrlwk_tm
*                                lt_data-zbegtm
*                                lt_data-zendtm.

    MOVE-CORRESPONDING ps_zthr0112 TO gt_daeh.
    gt_daeh-daeh_dt = lt_data-datum.
    gt_daeh-zrlwk_tm = lt_data-zrlwk_tm.
    gt_daeh-zbegtm = lt_data-zbegtm.
    gt_daeh-zendtm = lt_data-zendtm.
    APPEND gt_daeh.
  ENDLOOP.


  IF ps_zthr0112-zdaeh_day > 0.
    ps_zthr0112-zdaeh = 'X'.
    PERFORM convert_min_to_time IN PROGRAM saplzhr008_3
                                USING lv_zdaeh_t_min
                                CHANGING ps_zthr0112-zdaeh_tm.

    MOVE-CORRESPONDING ps_zthr0112 TO gt_save.
    APPEND gt_save.
    CLEAR gt_save.
  ENDIF.
ENDFORM.                    " MAKE_DAEH_DATA
*&---------------------------------------------------------------------*
*&      Form  MAKE_ZTHRBS01
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PS_ZTHR0112  text
*----------------------------------------------------------------------*
FORM make_zthrbs01  USING  ps_daeh LIKE LINE OF gt_daeh.

  DATA: ls_zthrbs01 TYPE zthrbs01,
        ls_zdata TYPE zthrbs01,
        ls_pdata TYPE zsh_personnel_data,
        ls_return LIKE bapireturn1,
        lv_opt TYPE actio,
        lv_zdbeg TYPE dats,
        lv_zdend TYPE dats,
        lv_zdaeh_min TYPE i.

  DATA: lt_handler TYPE REF TO if_hrpa_message_handler.
  DATA: ls_state TYPE hrecm00keyandtext ,
        lt_state TYPE TABLE OF hrecm00keyandtext.


  "상태도메인
  CALL FUNCTION 'HR_ECM_GET_ALL_DOMAIN_VALUE'
    EXPORTING
      domname         = 'ZSTATE_1'
      message_handler = lt_handler
    IMPORTING
      resulttab       = lt_state.


  "사용시작일/사용종료일
  PERFORM get_zdbeg_zdend IN PROGRAM zrpth409
                          USING ps_daeh-pernr
                                ps_daeh-endda  "기준일
                          CHANGING lv_zdbeg
                                   lv_zdend.


  "seqnr
  SELECT seqnr
    UP TO 1 ROWS
    INTO ls_zthrbs01-seqnr
    FROM zthrbs01
   WHERE pernr = ps_daeh-pernr  "사번
     AND rdate = ps_daeh-datum   "신청일
  ORDER BY seqnr DESCENDING.
  ENDSELECT.

  IF sy-subrc = 0.
    ADD 1 TO ls_zthrbs01-seqnr.
  ENDIF.

  "사원정보
  CALL FUNCTION 'ZHR_GET_PERSONNEL_DATA_N'
    EXPORTING
      pernr          = ps_daeh-pernr
      znal           = ps_daeh-daeh_dt
    IMPORTING
      zthrbs01       = ls_zdata
      personnel_data = ls_pdata.

  MOVE-CORRESPONDING ls_pdata TO ls_zthrbs01.
  ls_zthrbs01-btrtx = ls_pdata-btrtl_txt.
  ls_zthrbs01-gtext = ls_pdata-gsber_txt.
  ls_zthrbs01-vdsk1_txt = ls_pdata-vdsk1_ftxt.
  ls_zthrbs01-zkost = ls_pdata-kostl.
  ls_zthrbs01-jikk = ls_zdata-jikk.
  ls_zthrbs01-jikj = ls_zdata-jikj.
  ls_zthrbs01-zzj = ls_zdata-zzj.
  ls_zthrbs01-zgl01 = ls_zdata-zgl01.

  ls_zthrbs01-pernr = ps_daeh-pernr.
  ls_zthrbs01-rdate = ps_daeh-datum.
  ls_zthrbs01-state = '3'.
  READ TABLE lt_state INTO ls_state WITH KEY keyfield = '3'.
  IF sy-subrc = 0.
    ls_zthrbs01-state_txt = ls_state-textfield.
  ENDIF.
  ls_zthrbs01-zdaeh = 'Y'.
  ls_zthrbs01-znal = ps_daeh-daeh_dt.
  ls_zthrbs01-zbegt = ps_daeh-zbegtm.
  ls_zthrbs01-zendt = ps_daeh-zendtm.
  ls_zthrbs01-zaccept = 'Y'.
  ls_zthrbs01-zaccept1 = 'Y'.
  ls_zthrbs01-zdday = ps_daeh-daeh_dt.
  ls_zthrbs01-zdbeg = lv_zdbeg.
  ls_zthrbs01-zdend = lv_zdend.
  ls_zthrbs01-zd_time = ps_daeh-zrlwk_tm.
  "대휴수당(대휴시간 * 단가 * 50%)
  PERFORM convert_time_to_min IN PROGRAM saplzhr008_3
                              USING ps_daeh-zrlwk_tm
                              CHANGING lv_zdaeh_min.
  ls_zthrbs01-zd_money = ( lv_zdaeh_min / 60 ) * ( ps_daeh-zcost * '0.5' ) * 100.

  ls_zthrbs01-zsourflex = 'S'.
*    ls_zthrbs01-zkno = '1'.
  ls_zthrbs01-aedtm = sy-datum.
  ls_zthrbs01-uname = sy-uname.
  ls_zthrbs01-ertim = sy-uzeit.
  ls_zthrbs01-erdat = sy-datum.
  ls_zthrbs01-ernam = sy-uname.

  "요일
  CALL FUNCTION 'ZHR_GET_DAY_DATA_N'
    EXPORTING
      znal  = ls_zthrbs01-zdday
    IMPORTING
      zyoil = ls_zthrbs01-zyoil.

  INSERT zthrbs01 FROM ls_zthrbs01.
  COMMIT WORK AND WAIT.

ENDFORM.                    " MAKE_ZTHRBS01
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
        lv_pernr TYPE zthrbs01-pernr,
        ls_daeh LIKE LINE OF gt_daeh.

  IF gt_save[] IS INITIAL.
    MESSAGE '대휴생성 데이터가 없습니다.' TYPE 'S'.
    RETURN.
  ENDIF.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = '확 인'
      text_question         = '대휴생성 하시겠습니까?'
      text_button_1         = '생 성'
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

  "대휴체크
  LOOP AT gt_daeh.
    SELECT SINGLE pernr
      INTO lv_pernr
      FROM zthrbs01
     WHERE pernr = gt_daeh-pernr  "사번
       AND rdate = gt_daeh-datum  "신청일
       AND znal = gt_daeh-daeh_dt   "근무일
       AND zdday = gt_daeh-daeh_dt  "대휴일
       AND state = '3'.  "상태

    IF sy-subrc = 0.
      gt_daeh-msg = '등록된 대휴정보가 있습니다.'.
    ELSE.
      CLEAR gt_daeh-msg.
    ENDIF.

    MODIFY gt_daeh TRANSPORTING msg.
  ENDLOOP.

  "오류메세지 적용(동일 근무일에 2건 이상 생성된 경우)
  LOOP AT gt_daeh INTO ls_daeh.
    IF ls_daeh-msg IS NOT INITIAL.
      gt_daeh-msg = ls_daeh-msg.
      MODIFY gt_daeh TRANSPORTING msg
                     WHERE pernr = ls_daeh-pernr
                       AND datum = ls_daeh-datum
                       AND begda = ls_daeh-begda
                       AND endda = ls_daeh-endda
                       AND z52wktp = ls_daeh-z52wktp
                       AND z52prsq = ls_daeh-z52prsq
                       AND seqnr = ls_daeh-seqnr.
    ENDIF.
  ENDLOOP.

  "ZTHRBS01 생성
  LOOP AT gt_daeh WHERE msg = ''.
    PERFORM make_zthrbs01 CHANGING gt_daeh.
  ENDLOOP.

  "ALV 오류 메세지 적용
  LOOP AT gt_save.
    READ TABLE gt_daeh WITH KEY pernr = gt_save-pernr
                                datum = gt_save-datum
                                begda = gt_save-begda
                                endda = gt_save-endda
                                z52wktp = gt_save-z52wktp
                                z52prsq = gt_save-z52prsq
                                seqnr = gt_save-seqnr.
    IF sy-subrc = 0.
      gt_save-msg = gt_daeh-msg.
      MODIFY gt_save.
    ENDIF.
  ENDLOOP.

  "ZTHR0112 업데이트
  LOOP AT gt_save.
    IF gt_save-msg IS INITIAL.
      UPDATE zthr0112
         SET zdaeh = gt_save-zdaeh
             zdaeh_day = gt_save-zdaeh_day
             zdaeh_tm = gt_save-zdaeh_tm
       WHERE pernr = gt_save-pernr
         AND datum = gt_save-datum
         AND begda = gt_save-begda
         AND endda = gt_save-endda
         AND z52wktp = gt_save-z52wktp
         AND z52prsq = gt_save-z52prsq
         AND seqnr = gt_save-seqnr.

      COMMIT WORK AND WAIT.

      gt_disp-msg = '대휴생성 완료'.
    ELSE.
      gt_disp-msg = gt_save-msg.
    ENDIF.

    MODIFY gt_disp TRANSPORTING msg
                   WHERE pernr = gt_save-pernr
                     AND datum = gt_save-datum
                     AND wkbeg = gt_save-begda
                     AND wkend = gt_save-endda
                     AND z52wktp = gt_save-z52wktp
                     AND z52prsq = gt_save-z52prsq
                     AND seqnr = gt_save-seqnr.

  ENDLOOP.

  MESSAGE '처리 되었습니다.' TYPE 'S'.

ENDFORM.                    " SAVE_DATA
*&---------------------------------------------------------------------*
*&      Form  EMPLOYEE_CHECK_FLEX
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_P9021  text
*      <--P_LS_RETURN  text
*----------------------------------------------------------------------*
FORM employee_check_flex    USING    ps_p9021  TYPE p9021
                            CHANGING ps_return TYPE bapireturn1.

  DATA: ls_return TYPE bapireturn1.

  CALL FUNCTION 'ZHR_52TM_MEMBER_CHECK'
   EXPORTING
      i_pernr        = ps_p9021-pernr
      i_begda        = ps_p9021-begda
      i_endda        = ps_p9021-endda
   IMPORTING
*     E_CHK          =
     e_return        = ls_return.

  IF ls_return-type NE 'S'.
    ps_return-type    = 'E'.
    ps_return-message = ls_return-message.
  ENDIF.

ENDFORM.                    " EMPLOYEE_CHECK_FLEX
*&---------------------------------------------------------------------*
*&      Form  SELECT_DATA2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM select_data2 .
  DATA: lv_begda TYPE begda,
        lv_endda TYPE endda.

  DATA: lt_tmp LIKE TABLE OF gt_disp WITH HEADER LINE,
        lt_zthr0132 TYPE TABLE OF zthr0132 WITH HEADER LINE,
        lt_oinfo TYPE TABLE OF zth0500 WITH HEADER LINE.

  DATA: ls_z52wktp TYPE hrecm00keyandtext ,
        lt_z52wktp TYPE TABLE OF hrecm00keyandtext.


  IF p_kjdat IS INITIAL.
    gv_stop = 'X'.
    MESSAGE s001 DISPLAY LIKE 'E' WITH '기준일을 입력하십시오.'.
    RETURN.
  ENDIF.

  IF sy-batch = 'X'.
    p_kjdat = sy-datum.
  ENDIF.

  lv_begda = p_kjdat.
  lv_endda = p_kjdat.


  SELECT a~pernr a~begda a~endda a~z52wktp a~z52prsq
         b~ename b~vdsk1
    INTO CORRESPONDING FIELDS OF TABLE lt_tmp
    FROM pa9021 AS a INNER JOIN pa0001 AS b
                     ON a~pernr = b~pernr
   WHERE a~z52wktp = '0110'
     AND a~pernr IN s_pernr
     AND a~begda <= lv_endda
     AND a~endda >= lv_begda
     AND b~vdsk1 IN s_orgeh
     AND b~begda <= lv_begda
     AND b~endda >= lv_begda.

  IF sy-subrc = 0.
    "선택근로제 기간
    SELECT *
      INTO CORRESPONDING FIELDS OF TABLE lt_zthr0132
      FROM zthr0132
      FOR ALL ENTRIES IN lt_tmp
     WHERE pernr = lt_tmp-pernr
       AND z52wktp = lt_tmp-z52wktp
       AND z52prsq = lt_tmp-z52prsq
       AND begda <= lv_endda
       AND endda >= lv_begda.

    "선택근로 대상자 기간생성
    PERFORM create_work_period TABLES lt_tmp.
    IF sy-batch = 'X'.
      gv_stop = 'X'.
      RETURN.
    ENDIF.

    "부서정보
    SELECT *
      INTO CORRESPONDING FIELDS OF TABLE lt_oinfo
      FROM zth0500
     WHERE begda <= lv_endda
       AND endda >= lv_begda.

    "근로유형
    CALL FUNCTION 'ZHR_52TM_WKTYPE'
      IMPORTING
        resulttab = lt_z52wktp.
  ENDIF.


  LOOP AT lt_tmp.
    MOVE-CORRESPONDING lt_tmp TO gt_disp.

    READ TABLE lt_z52wktp INTO ls_z52wktp WITH KEY keyfield = gt_disp-z52wktp.
    IF sy-subrc = 0.
      gt_disp-z52wktp_tx = ls_z52wktp-textfield.
    ENDIF.

    LOOP AT lt_oinfo WHERE objid = gt_disp-vdsk1
                       AND begda <= gt_disp-begda
                       AND endda >= gt_disp-begda.
      gt_disp-zorder = lt_oinfo-zorder.
      gt_disp-vdsk1_tx = lt_oinfo-fname.
      EXIT.
    ENDLOOP.


    LOOP AT lt_zthr0132 WHERE pernr = lt_tmp-pernr
                          AND z52wktp = lt_tmp-z52wktp
                          AND z52prsq = lt_tmp-z52prsq
                          AND begda BETWEEN lt_tmp-begda AND lt_tmp-endda
                          AND endda BETWEEN lt_tmp-begda AND lt_tmp-endda.

      gt_disp-wkbeg = lt_zthr0132-begda.
      gt_disp-wkend = lt_zthr0132-endda.

      READ TABLE gt_zthr0132 WITH KEY pernr = gt_disp-pernr
                                      begda = gt_disp-begda
                                      endda = gt_disp-endda
                                      z52wktp = gt_disp-z52wktp
                                      z52prsq = gt_disp-z52prsq.
      IF sy-subrc = 0.
        gt_disp-msg = '기간생성 완료'.
      ELSE.
        gt_disp-msg = '기 생성된 기간이 있습니다.'.
      ENDIF.

      APPEND gt_disp.
    ENDLOOP.

    "기간생성시 오류사항
    LOOP AT gt_error WHERE pernr = lt_tmp-pernr
                        AND z52wktp = lt_tmp-z52wktp
                        AND z52prsq = lt_tmp-z52prsq.
      gt_disp-msg = gt_error-msg.
      APPEND gt_disp.
    ENDLOOP.

    CLEAR gt_disp.
  ENDLOOP.

  SORT gt_disp BY zorder pernr.
  DESCRIBE TABLE gt_disp LINES g_line.
ENDFORM.                    " SELECT_DATA2
*&---------------------------------------------------------------------*
*&      Form  SELECT_DATA3
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM select_data3 .
  DATA: lv_begda TYPE begda,
        lv_endda TYPE endda,
        l_yymm(7).

  DATA: lt_tmp LIKE TABLE OF gt_disp WITH HEADER LINE,
        lt_zthr0132 TYPE TABLE OF zthr0132 WITH HEADER LINE,
        lt_oinfo TYPE TABLE OF zth0500 WITH HEADER LINE.

  DATA: ls_z52wktp TYPE hrecm00keyandtext ,
        lt_z52wktp TYPE TABLE OF hrecm00keyandtext.

   DATA: ls_tmp LIKE lt_tmp.


  "선택근로 대휴정산
  IF p_dhdat IS INITIAL.
    gv_stop = 'X'.
    MESSAGE s001 DISPLAY LIKE 'E' WITH '기준년월을 입력하십시오.'.
    RETURN.
  ENDIF.

  IF sy-batch = 'X'.
    p_dhdat = sy-datum(6).
  ENDIF.

  CONCATENATE p_dhdat '01' INTO lv_begda.
  lv_endda = lv_begda.

  l_yymm(6) = p_dhdat.
  l_yymm+6(1) = '%'.


  SELECT a~pernr a~begda a~endda a~z52wktp a~z52prsq
         b~ename b~vdsk1
    INTO CORRESPONDING FIELDS OF TABLE lt_tmp
    FROM pa9021 AS a INNER JOIN pa0001 AS b
                     ON a~pernr = b~pernr
   WHERE a~z52wktp = '0110'
     AND a~pernr IN s_pernr
     AND a~endda LIKE l_yymm
     AND b~vdsk1 IN s_orgeh
     AND b~begda <= lv_begda
     AND b~endda >= lv_begda.

  IF sy-subrc = 0.
    "선택근로 대휴생성
    SELECT *
      INTO CORRESPONDING FIELDS OF TABLE lt_zthr0132
      FROM zthr0132
      FOR ALL ENTRIES IN lt_tmp
     WHERE pernr = lt_tmp-pernr
       AND z52wktp = '0110'
       AND z52prsq = '04'
       AND endda LIKE l_yymm.

    CHECK lt_zthr0132[] IS NOT INITIAL.

    CALL FUNCTION 'ZHR_52TM_CW_CAL_AND_DAEH'
      EXPORTING
        i_case      = 'C'
      TABLES
        lt_zthr0132 = lt_zthr0132
        lt_daeh     = gt_daeh
        lt_save     = gt_save.

*      PERFORM create_work_dh TABLES lt_tmp.

    IF sy-batch = 'X'.
      gv_stop = 'X'.
      RETURN.
    ENDIF.

    "부서정보
*    SELECT *
*      INTO CORRESPONDING FIELDS OF TABLE lt_oinfo
*      FROM zth0500
*     WHERE begda <= lv_endda
*       AND endda >= lv_begda.

   "이전 기간 부서정보들도 가져와야 함
   SORT lt_tmp ASCENDING BY begda.
   READ TABLE lt_tmp INDEX 1 INTO ls_tmp.

    SELECT *
      INTO CORRESPONDING FIELDS OF TABLE lt_oinfo
      FROM zth0500
     WHERE begda <= lv_endda
       AND endda >= ls_tmp-begda.


    "근로유형
    CALL FUNCTION 'ZHR_52TM_WKTYPE'
      IMPORTING
        resulttab = lt_z52wktp.
  ENDIF.


  LOOP AT lt_tmp.
    MOVE-CORRESPONDING lt_tmp TO gt_disp.

    READ TABLE lt_z52wktp INTO ls_z52wktp WITH KEY keyfield = gt_disp-z52wktp.
    IF sy-subrc = 0.
      gt_disp-z52wktp_tx = ls_z52wktp-textfield.
    ENDIF.

    LOOP AT lt_oinfo WHERE objid = gt_disp-vdsk1
                       AND begda <= gt_disp-begda
                       AND endda >= gt_disp-begda.
      gt_disp-zorder = lt_oinfo-zorder.
      gt_disp-vdsk1_tx = lt_oinfo-fname.
      EXIT.
    ENDLOOP.


    LOOP AT lt_zthr0132 WHERE pernr = lt_tmp-pernr
                          AND z52wktp = lt_tmp-z52wktp
                          AND z52prsq = lt_tmp-z52prsq
                          AND begda BETWEEN lt_tmp-begda AND lt_tmp-endda
                          AND endda BETWEEN lt_tmp-begda AND lt_tmp-endda.

      gt_disp-wkbeg = lt_zthr0132-begda.
      gt_disp-wkend = lt_zthr0132-endda.

      LOOP AT gt_save WHERE pernr = lt_tmp-pernr
                          AND datum >= '20220301'
                        AND begda = lt_zthr0132-begda
                        AND endda = lt_zthr0132-endda
                        AND z52wktp = lt_tmp-z52wktp
                        AND z52prsq = lt_tmp-z52prsq
                        AND datum BETWEEN lt_tmp-begda AND lt_tmp-endda.

        gt_disp-datum = gt_save-datum.
        gt_disp-seqnr = gt_save-seqnr.
        "발생일
        gt_disp-zdday = gt_save-datum.
        gt_disp-zdaeh_day = gt_save-zdaeh_day.
        gt_disp-msg = gt_save-msg.

        APPEND gt_disp.
      ENDLOOP.
    ENDLOOP.

    CLEAR gt_disp.
  ENDLOOP.

  SORT gt_disp BY zorder pernr.
  DESCRIBE TABLE gt_disp LINES g_line.
ENDFORM.                    " SELECT_DATA3
