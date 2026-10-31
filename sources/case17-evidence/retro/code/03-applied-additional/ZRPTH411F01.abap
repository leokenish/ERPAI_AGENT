*----------------------------------------------------------------------*
***INCLUDE ZRPTH402F01 .
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  SET_CALC_WKPRD_AMT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_calc_wkprd_amt .
  DATA lt_zthr0113 TYPE TABLE OF zthr0113 WITH HEADER LINE.
  DATA : tmp TYPE pa0001-pernr.
  DATA: lt_retro_new TYPE STANDARD TABLE OF zthr0113,
        lt_retro_old TYPE STANDARD TABLE OF zthr0113.

*************   현재 재직 여부 체크 xa30752 2020.06.10
*  SELECT pernr INTO tmp
*    FROM pa0001
*    WHERE pernr = pernr-pernr
*    AND begda <= sy-datum
*    AND endda >= sy-datum
*    AND persg  = '1'. " 재직자
*  ENDSELECT.
*
*  IF sy-subrc <> 0.
*     CLEAR pernr.
*
*  ENDIF.
*
*  IF pernr-pernr IS INITIAL.
*    RETURN.
*  ENDIF.
***********************************************

  CALL FUNCTION 'ZHR_52TM_CW_PAYMENT_WKPRD'
    EXPORTING
      i_pernr     = pernr-pernr
      i_yymm      = pa_yymm
      i_z52wktp   = pa_zwktp
      i_z52prsq   = pa_zseq
      i_opt       = 'X'
      i_retmo     = pa_retmo
      i_retro     = pa_retro
    TABLES
      lt_zthr0113 = lt_zthr0113
      lt_retro_new = lt_retro_new
      lt_retro_old = lt_retro_old.

  APPEND LINES OF lt_retro_new TO gt_retro_new.
  APPEND LINES OF lt_retro_old TO gt_retro_old.

  CHECK lt_zthr0113[] IS NOT INITIAL.

  ADD 1 TO gv_pcnt.

  LOOP AT lt_zthr0113.
    MOVE-CORRESPONDING lt_zthr0113 TO gt_disp2.
    gt_disp2-ename = pernr-ename.
    IF pa_admdt IS NOT INITIAL.
      gt_disp2-zadmit_dt = pa_admdt. "정산일
    ENDIF.

    CLEAR p0001.
    rp-provide-from-last p0001 space lt_zthr0113-endda lt_zthr0113-endda.
    "부서명
    PERFORM get_orgtx USING p0001-vdsk1
                            gt_disp2-vdsk1_tx
                            'F'.
    "조직단위
    PERFORM get_orgtx USING p0001-orgeh
                            gt_disp2-orgeh_tx
                            'S'.

    "사원하위그룹
    SELECT SINGLE ptext
      INTO gt_disp2-persk_tx
      FROM t503t
     WHERE sprsl = sy-langu
       AND persk = p0001-persk.

    "포지션명
    CALL FUNCTION 'RH_READ_OBJECT'
      EXPORTING
        begda     = gt_disp2-endda
        endda     = gt_disp2-endda
        istat     = '1'
        langu     = sy-langu
        objid     = p0001-plans
        ointerval = 'X'
        otype     = 'S'
        plvar     = '01'
      IMPORTING
        stext     = gt_disp2-plans_tx
      EXCEPTIONS
        not_found = 01.

    "코스트센터명
    CALL FUNCTION 'HR_READ_FOREIGN_OBJECT_TEXT'
      EXPORTING
        otype                   = 'K'
        costcenter              = p0001-kostl
        controllingarea         = p0001-kokrs
        begda                   = gt_disp2-endda
        endda                   = gt_disp2-endda
        langu                   = sy-langu
      IMPORTING
        costcenter_name         = gt_disp2-kostl_tx
      EXCEPTIONS
        nothing_found           = 1
        wrong_objecttype        = 2
        missing_costcenter_data = 3
        missing_object_id       = 4
        OTHERS                  = 5.


    gt_disp2-vdsk1 = p0001-vdsk1.
    gt_disp2-kostl = p0001-kostl.
    gt_disp2-jikjong_k = p0001-jikjong_k.
    gt_disp2-z52wktxt = g_wktp_tx.

    "Start-Add / 8월 정산용 / xa32762
    IF  pa_yymm = '202608' AND pa_retro = 'X' AND pa_retmo = '202606'.

      DATA lt_retro_mod LIKE TABLE OF gt_disp2 WITH HEADER LINE.
      CLEAR: lt_retro_mod, lt_retro_mod[].

      CLEAR lt_retro_mod.
      lt_retro_mod-pernr     = '00032022'.
      lt_retro_mod-zretroamt = '2121.00'.
      lt_retro_mod-zotpayamt = '5124.00'.
      APPEND lt_retro_mod.

      SORT lt_retro_mod BY pernr.

      READ TABLE lt_retro_mod
              WITH KEY pernr = gt_disp2-pernr
              BINARY SEARCH.

      IF sy-subrc = 0.
        gt_disp2-zretroamt = lt_retro_mod-zretroamt.
*        gt_disp2-zotpayamt = lt_retro_mod-zotpayamt.
        gt_disp2-zotpayamt = gt_disp2-zretroamt + gt_disp2-zrlprdamt.
      ENDIF.
    ENDIF.
    "End-Add

    APPEND gt_disp2. CLEAR gt_disp2.
  ENDLOOP.

ENDFORM.                    " SET_CALC_WKPRD_AMT
*---------------------------------------------------------------------*
*       FORM CREATE_INIT_FIELDCAT                                     *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM create_init_fieldcat.

  CLEAR help_fieldcat. REFRESH help_fieldcat.


  PERFORM append_init_fieldcat USING:
                    'X' 'STATE'      '상태'             'C' ' ',
                    'X' 'PERNR'      '사번'             'C' ' ',
                    'X' 'ENAME'      '이름'             ' ' ' ',
                    'X' 'ORGEH_TX'   '조직단위'         ' ' ' ',
                    'X' 'VDSK1'      '조직키'           'C' ' ',
                    'X' 'VDSK1_TX'   '부서명'           ' ' ' ',
                    ' ' 'KOSTL'      '코스트센터'       'C' ' ',
                    ' ' 'KOSTL_TX'   '코스트센터명'     'L' ' ',
                    ' ' 'PERSK_TX'   '사원하위그룹'     'C' ' ',
                    ' ' 'PLANS_TX'   '포지션명'         'C' ' ',
                    ' ' 'JIKJONG_K'  '직종'             'C' ' ',
                    ' ' 'ZDUNG'      '등급'             'C' ' ',
                    ' ' 'ZCOST'      '단가'             ' ' 'C',
                    ' ' 'Z52WKTXT'   '선택근로제유형'   'C' ' ',
                    ' ' 'Z52PRSQ'    '근로주기'         ' ' ' ',
                    ' ' 'BEGDA'      '시작일'           'C' ' ',
                    ' ' 'ENDDA'      '종료일'           'C' ' ',
                    ' ' 'PWKHR'      '소정근로시간'     'C' ' ',
*                   ' ' 'OWKHR'      '연장(가능)시간'   'C' ' ',
                    ' ' 'ZWKHRTOT' '평일총근로시간'       'C' ' ',
                    ' ' 'ZHKHRTOT' '휴일총근로시간'       'C' ' ',
                    ' ' 'ZRLWKHRTOT' '총근로시간'       'C' ' ',
                    ' ' 'ZRLWKHR'    '실근로시간'       'C' ' ',
                    ' ' 'ZPUBHHR'    '주중공휴일시간'   'C' ' ',
                    ' ' 'ZPRSDWKHR'  '인정근로시간'     'C' ' ',
                    ' ' 'ZADTWKHR'   '간주근로시간'     'C' ' ',
                    ' ' 'ZEDTWKHR'   '출제위원근로시간' 'C' ' ',
                    ' ' 'ZRLADDWKHR' '가산시간'         'C' ' ',
                    ' ' 'ZRLEXWKHR'  '초과근로시간'     'C' ' ',
                    'F' 'ZDAEH_DAY'  '대휴일수'         ' ' ' ',
                    'C' 'ZDAEHHR'    '대휴시간'         'C' ' ',
                    'D' 'ZDAEHAMT'   '휴일실비(대휴발생)'         ' ' 'C',
                    'C' 'ZRLOVRWKHR' '연장근로시간'     'C' ' ',
                    'D' 'ZRLOVRAMT'  '연장실비'     ' ' 'C',
                    'C' 'ZRLNGTWKHR' '야간근로시간'     'C' ' ',
                    'D' 'ZRLNGTAMT'  '야간실비'     ' ' 'C',
                    'C' 'ZRLHOLWKHR' '휴일근로시간'     'C' ' ',
                    'D' 'ZRLHOLAMT'  '휴일실비(대휴미발생)'     ' ' 'C',
                    'D' 'TDCOST'     '시차실비'         ' ' 'C',
                    'B' 'ZRLPRDAMT'  '기간실비'         ' ' 'C',
                    'B' 'ZRETROAMT'  '소급정산분'       ' ' 'C',
                    'E' 'ZOTPAYAMT'  '최종지급금액'     ' ' 'C'.

  IF rb1 = 'X'.
    PERFORM append_init_fieldcat USING:
                    ' '  'ZADMIT_DT' '정산일자'         'C' ' ' ,
                    ' '  'AWREF'     '전표번호'         ' ' ' ' ,
                    ' '  'ZGL01'     'G/L계정'         ' ' ' ' .
  ENDIF.

  IF rb2 = 'X'.
    PERFORM append_init_fieldcat USING:
      ' ' 'ROW_TEXT'  '구분'        'C' ' ',
      ' ' 'TARGET_YM' '대상연월'    'C' ' ',
      ' ' 'OLD_AMT'   '기존 확정액' ' ' 'C',
      ' ' 'DIFF_AMT'  '재계산 차액' ' ' 'C'.
  ENDIF.

ENDFORM.                    "create_init_fieldcat
*---------------------------------------------------------------------*
*       FORM CREATE_INIT_FIELDCAT2                                     *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM create_init_fieldcat2.

  CLEAR help_fieldcat. REFRESH help_fieldcat.


  PERFORM append_init_fieldcat USING:
                    'X' 'STATE_TXT'     '상태'             'C' ' ',
                    'X' 'PERNR'         '사번'             'C' ' ',
                    'X' 'ENAME'         '이름'             ' ' ' ',
                    'X' 'ORGEH_TX'      '조직단위'         ' ' ' ',
                    'X' 'VDSK1'         '조직키'           'C' ' ',
                    'X' 'VDSK1_TX'      '부서명'           ' ' ' ',
                    ' ' 'KOSTL'         '코스트센터'       'C' ' ',
                    ' ' 'KOSTL_TX'      '코스트센터명'     'L' ' ',
                    ' ' 'PERSK_TX'      '사원하위그룹'     'C' ' ',
                    ' ' 'PLANS_TX'      '포지션명'         'C' ' ',
                    ' ' 'JIKJONG_K'     '직종'             'C' ' ',
                    ' ' 'DATUM'         '근로일자'         'C' ' ',
                    ' ' 'ZBEGTM'        '시작시간'         'C' 'T',
                    ' ' 'ZENDTM'        '종료시간'         'C' 'T',
                    ' ' 'ZRLWK_TM'      '실근로시간'       'C' 'T',
                    ' ' 'ZDAEH'         '대휴여부'         'C' 'B',
                    ' ' 'ZPERNR'        '상신자사번'       'C' ' ',
                    ' ' 'ZPNAME'        '상신자명'         ' ' ' ',
                    ' ' 'REQDT'         '상신일'           'C' ' ',
                    ' ' 'ZCOSA'         '결재자사번'       'C' ' ',
                    ' ' 'ZCOPE'         '결재자명'         ' ' ' ',
                    ' ' 'MESSAGE'       '오류내용'         ' ' ' '.

ENDFORM.                    "create_init_fieldcat2
*---------------------------------------------------------------------*
*       FORM CREATE_INIT_FIELDCAT3                                     *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM create_init_fieldcat3.

  CLEAR help_fieldcat. REFRESH help_fieldcat.


  PERFORM append_init_fieldcat USING:
                    'X' 'STATE'      '상태'             'C' ' ',
                    'X' 'ZADMIT_YM'  '정산대상연월'     'C' ' ',
                    'X' 'ZADMIT_DT'  'PA전기일'         'C' ' ',
                    'X' 'PERNR'      '사번'             'C' ' ',
                    'X' 'ENAME'      '이름'             ' ' ' ',
                    'X' 'ORGEH_TX'   '조직단위'         ' ' ' ',
                    'X' 'VDSK1'      '조직키'           'C' ' ',
                    'X' 'VDSK1_TX'   '부서명'           ' ' ' ',
                    ' ' 'KOSTL'      '코스트센터'       'C' ' ',
                    ' ' 'KOSTL_TX'   '코스트센터명'     'L' ' ',
                    ' ' 'PERSK_TX'   '사원하위그룹'     'C' ' ',
                    ' ' 'PLANS_TX'   '포지션명'         'C' ' ',
                    ' ' 'JIKJONG_K'  '직종'             'C' ' ',
                    ' ' 'Z52WKTXT'   '선택근로제유형'   'C' ' ',
                    'E' 'ZOTPAYAMT'  '최종지급금액'     ' ' 'C',
                    ' ' 'LGART'      '임금유형'         'C' ' ',
                    ' ' 'LGTXT'      '임금유형명'       ' ' ' ',
                    'D' 'BETRG'      '금액(2010)'       ' ' 'C',
                    ' ' 'AWREF'      '전표번호'         ' ' ' '.

ENDFORM.                    "create_init_fieldcat
*---------------------------------------------------------------------*
*       FORM APPEND_INIT_FIELDCAT                                     *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  P_POS                                                         *
*  -->  P_KEY                                                         *
*  -->  P_FIELDNAME                                                   *
*  -->  P_REPTEXT                                                     *
*  -->  P_JUST                                                        *
*---------------------------------------------------------------------*
FORM append_init_fieldcat  USING p_key
                                 p_fieldname
                                 p_reptext
                                 p_just
                                 p_mask.

  DATA: ls_fcat TYPE lvc_s_fcat.
  STATICS lv_pos TYPE i.

  CLEAR ls_fcat.
  ADD 1 TO lv_pos.
  ls_fcat-col_pos       = lv_pos.

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
*      ls_fcat-emphasize = 'C800'.
      ls_fcat-no_zero = 'X'.
  ENDCASE.
  ls_fcat-fieldname     = p_fieldname.
  ls_fcat-reptext       = p_reptext.
  ls_fcat-just          = p_just.


  CASE p_mask.
    WHEN 'C'.
      ls_fcat-currency   = 'KRW'.
      ls_fcat-no_zero = 'X'.
    WHEN 'T'.
      ls_fcat-edit_mask = '__:__'.
    WHEN 'B'.
      ls_fcat-checkbox = 'X'.
  ENDCASE.

  IF rb2 = 'X'.
    IF pa_retro = 'X'.
      "실비 열은 당월과 과거 재계산의 참고값이 섞이므로 합계 제외.
      IF p_fieldname <> 'ZOTPAYAMT'.
        CLEAR ls_fcat-do_sum.
      ENDIF.
    ENDIF.
    IF p_fieldname = 'ZOTPAYAMT'.
      ls_fcat-reptext = '이번 지급 반영액'.
    ENDIF.
    IF p_fieldname = 'ZRETROAMT'.
      ls_fcat-reptext = '실제 소급 반영액'.
    ENDIF.
  ENDIF.

  APPEND ls_fcat TO  help_fieldcat.

ENDFORM.                    "append_init_fieldcat
*&---------------------------------------------------------------------*
*&      Module  PBO_100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pbo_100 OUTPUT.

  CASE 'X'.
    WHEN rb1 .
      SET PF-STATUS '100'.
      SET TITLEBAR  '100'.
    WHEN rb2.
      SET PF-STATUS '101'.
      SET TITLEBAR  '101'.
    WHEN rb3.
      SET PF-STATUS '102'.
      SET TITLEBAR  '102'.
    WHEN rb4.
      SET PF-STATUS '103'.
      SET TITLEBAR  '103'.
  ENDCASE.


  IF g_container IS INITIAL.

    CREATE OBJECT g_container
      EXPORTING
        container_name              = g_control
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5.


    gs_layout-zebra      = 'X'.
    gs_layout-cwidth_opt = 'X'.

    gs_variant-report = sy-repid.
    gs_variant-username = sy-uname.

*top

*    PERFORM get_event USING gt_events.
    PERFORM set_sort_tab .


    CREATE OBJECT o_dyndoc_id
      EXPORTING
        style = 'ALV_GRID'.

    CREATE OBJECT o_splitter
      EXPORTING
        parent  = g_container
        rows    = 2
        columns = 1.

    CALL METHOD o_splitter->get_container
      EXPORTING
        row       = 1
        column    = 1
      RECEIVING
        container = o_parent_top.

    CALL METHOD o_splitter->get_container
      EXPORTING
        row       = 2
        column    = 1
      RECEIVING
        container = o_parent_grid.

    CALL METHOD o_splitter->set_row_height
      EXPORTING
        id     = 1
        height = 12.


    CREATE OBJECT g_grid
      EXPORTING
        i_parent = o_parent_grid.



*    CREATE OBJECT g_grid
*      EXPORTING
*        i_parent = g_container.

    CREATE OBJECT g_handler.
    SET HANDLER g_handler->handle_top_of_page FOR g_grid.


    CASE 'X'.
      WHEN rb1 OR rb2.
        PERFORM create_init_fieldcat.

        IF rb2 = 'X'.
        CALL METHOD g_grid->set_table_for_first_display
          EXPORTING
            is_layout       = gs_layout
            is_variant      = gs_variant
            i_save          = 'A'
          CHANGING
            it_fieldcatalog = help_fieldcat[]
*            it_sort         = gt_sorttab[]
            it_outtab       = gt_display[].
        ELSE.
        CALL METHOD g_grid->set_table_for_first_display
          EXPORTING
            is_layout       = gs_layout
            is_variant      = gs_variant
            i_save          = 'A'
          CHANGING
            it_fieldcatalog = help_fieldcat[]
*            it_sort         = gt_sorttab[]
            it_outtab       = gt_disp2[].
        ENDIF.

      WHEN rb3.
        gs_layout-sel_mode = 'A'.
        gs_layout-box_fname = 'MARK'.

        PERFORM create_init_fieldcat2.

        CALL METHOD g_grid->set_table_for_first_display
          EXPORTING
            is_layout       = gs_layout
            is_variant      = gs_variant
            i_save          = 'A'
          CHANGING
            it_fieldcatalog = help_fieldcat[]
*            it_sort         = gt_sorttab[]
            it_outtab       = gt_disp[].

      WHEN rb4.
        PERFORM create_init_fieldcat3.

        CALL METHOD g_grid->set_table_for_first_display
          EXPORTING
            is_layout       = gs_layout
            is_variant      = gs_variant
            i_save          = 'A'
          CHANGING
            it_fieldcatalog = help_fieldcat[]
*            it_sort         = gt_sorttab[]
            it_outtab       = gt_disp3[].

    ENDCASE.

    CALL METHOD o_dyndoc_id->initialize_document
      EXPORTING
        background_color = cl_dd_area=>col_textarea.

    CALL METHOD g_grid->list_processing_events
      EXPORTING
        i_event_name = 'TOP_OF_PAGE'
        i_dyndoc_id  = o_dyndoc_id.



  ELSE.
    CALL METHOD g_grid->refresh_table_display
      EXPORTING
        i_soft_refresh = 'X'.

  ENDIF.

ENDMODULE.                 " PBO_100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  PAI_100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE pai_100 INPUT.

  DATA l_ans.
  DATA: row_no TYPE lvc_t_roid ,
         index_rows TYPE lvc_t_row.
  DATA wa_no TYPE lvc_s_roid.
  DATA : it_zthr0160 TYPE zthr0160.
  TABLES : zthr0160.


  CLEAR l_ans.

  CASE ok_code.

    WHEN 'CONF'. "확정
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
         titlebar                    = '확정'
*          DIAGNOSE_OBJECT             = ' '
          text_question               = '마감 확정처리 하시겠습니까?'
         text_button_1         = 'OK'
          icon_button_1         = 'ICON_CHECKED'
         text_button_2         = 'CANCEL'
          icon_button_2         = 'ICON_CANCEL'
          display_cancel_button = ' '
       IMPORTING
         answer                      = l_ans
*        TABLES
*          PARAMETER                   =
*        EXCEPTIONS
*          TEXT_NOT_FOUND              = 1
*          OTHERS                      = 2
                .
      IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      CHECK l_ans = '1'.

      PERFORM confirm_data.
      IF rb2 = 'X'.
        PERFORM make_display_data.
      ENDIF.

*------- 20201012 김지훈 시간외 마감 여부 테이블 삽입 로직---------

      it_zthr0160-zmonth = pa_yymm.
      it_zthr0160-zpernr = sy-uname.
      it_zthr0160-zdatum = sy-datum.
      it_zthr0160-zuzeit = sy-uzeit.
      it_zthr0160-z52wktp = '0110'.
*
      SELECT * FROM zthr0160 WHERE zmonth = pa_yymm AND z52wktp = '0110' .
      ENDSELECT.

      IF sy-subrc NE 0.
        INSERT zthr0160 FROM it_zthr0160.
      ENDIF.

*------------------------------------------------------

    WHEN 'CONFC'. " 확정취소
      CALL FUNCTION 'POPUP_TO_CONFIRM'
        EXPORTING
         titlebar                    = '확정취소'
*          DIAGNOSE_OBJECT             = ' '
          text_question               = '마감 확정 취소 처리 하시겠습니까?'
         text_button_1         = 'OK'
          icon_button_1         = 'ICON_CHECKED'
         text_button_2         = 'CANCEL'
          icon_button_2         = 'ICON_CANCEL'
          display_cancel_button = ' '
       IMPORTING
         answer                      = l_ans
*        TABLES
*          PARAMETER                   =
*        EXCEPTIONS
*          TEXT_NOT_FOUND              = 1
*          OTHERS                      = 2
                .
      IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      CHECK l_ans = '1'.

      PERFORM cancle_confirm_data.

*------- 20201012 김지훈 시간외 마감 여부 테이블 삽입 로직---------

      DELETE FROM zthr0160 WHERE zmonth = pa_yymm AND z52wktp = '0110'.

*------------------------------------------------------


    WHEN 'DONE'. " 미결처리
      CLEAR: row_no, index_rows.

      CALL METHOD g_grid->get_selected_rows(
            IMPORTING
            et_row_no = row_no
            et_index_rows = index_rows ).

      IF row_no[] IS INITIAL.
        MESSAGE s016(pn) WITH '레코드를 선택 하세요'.
        CLEAR ok_code.
        EXIT.
      ENDIF.

      CALL FUNCTION 'POPUP_TO_CONFIRM'
     EXPORTING
      titlebar                    = '미결처리'
*          DIAGNOSE_OBJECT             = ' '
       text_question               = '선택된 레코드에 대해 미결 처리 하시겠습니까?'
      text_button_1         = 'OK'
       icon_button_1         = 'ICON_CHECKED'
      text_button_2         = 'CANCEL'
       icon_button_2         = 'ICON_CANCEL'
       display_cancel_button = ' '
    IMPORTING
      answer                      = l_ans
*        TABLES
*          PARAMETER                   =
*        EXCEPTIONS
*          TEXT_NOT_FOUND              = 1
*          OTHERS                      = 2
             .
      IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      CHECK l_ans = '1'.

      LOOP AT row_no INTO wa_no.
        CLEAR gt_disp.
        READ TABLE gt_disp INDEX wa_no-row_id.
        CHECK sy-subrc = 0.
        PERFORM set_approve_status.
        MODIFY gt_disp INDEX wa_no-row_id. CLEAR gt_disp.
      ENDLOOP.

    WHEN 'DOWNLOAD'.
      PERFORM download_excel.
  ENDCASE.

ENDMODULE.                 " PAI_100  INPUT



*---------------------------------------------------------------------*
*       FORM EXIT_PROGRAM                                             *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM exit_program.

  CALL METHOD g_container->free.
  CALL METHOD cl_gui_cfw=>flush.
  LEAVE PROGRAM.

ENDFORM.                    "exit_program




*---------------------------------------------------------------------*
*       MODULE EXIT INPUT                                             *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
MODULE exit INPUT.

  LEAVE TO  SCREEN 0.

ENDMODULE.                    "exit INPUT
*---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  CONFIRM_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM confirm_data .
  DATA: lt_z0112 TYPE STANDARD TABLE OF zthr0112 WITH  HEADER LINE,
        lt_z0113 TYPE STANDARD TABLE OF zthr0113 WITH  HEADER LINE,
        lt_2010 TYPE STANDARD TABLE OF pa2010 WITH  HEADER LINE,
        ls_z0022 TYPE zwf0022.


  SELECT *
    INTO TABLE lt_z0112
    FROM zthr0112
     FOR ALL ENTRIES IN gt_disp2
   WHERE pernr = gt_disp2-pernr
     AND datum <= gt_disp2-endda
     AND datum >= gt_disp2-begda
     AND begda = gt_disp2-begda
     AND endda = gt_disp2-endda
     AND z52wktp = gt_disp2-z52wktp
     AND z52prsq = gt_disp2-z52prsq
     AND state IN ('3' , 'H') " 소급 반영건 신규승인 또는 승인건 삭제
     AND ( zadmit_dt = ' ' OR zadmit_dt = '00000000' )
     AND ( zserial <> '000000000000' AND zserial <> '' )
     AND cpernr <> ''.

  " 삭제건에 대한 점검 - 승인 후 삭제확인
  LOOP AT lt_z0112 WHERE state = '2'.
    SELECT SINGLE *
      INTO ls_z0022
      FROM zwf0022
     WHERE key12 = lt_z0112-zserial
       AND zwftype = 'E' "탄력근로
       AND zordr = '01'  "결재자
       AND zstts = 'A'.
    IF sy-subrc <> 0.
      DELETE lt_z0112.
    ENDIF.
  ENDLOOP.


  LOOP AT gt_disp2 WHERE state = ''.
    MOVE: gt_disp2-pernr TO lt_2010-pernr,
          gt_disp2-zotpayamt TO lt_2010-betrg.

    lt_2010-begda = lt_2010-endda = pa_admdt. "정산일자
    lt_2010-subty = lt_2010-lgart = '8050'.
    lt_2010-waers = 'KRW'.
    COLLECT lt_2010. CLEAR lt_2010.
  ENDLOOP.

  CHECK lt_2010[] IS NOT INITIAL.

  DELETE lt_2010 WHERE betrg <= 0.

  IF lt_2010[] IS NOT INITIAL.
    lt_2010-aedtm = sy-datum.
    lt_2010-uname = sy-uname.
    MODIFY lt_2010 TRANSPORTING uname aedtm WHERE uname = '' .
    MODIFY pa2010 FROM TABLE lt_2010.
    IF sy-subrc <> 0.
      MESSAGE w016(pn) WITH '확정 처리중  오류가 발생 되었습니다'.
      ROLLBACK WORK.
      CLEAR ok_code.
      EXIT.
    ENDIF.
  ENDIF.

  "정산일 지정
  lt_z0112-zadmit_dt = pa_admdt.
  MODIFY lt_z0112 TRANSPORTING zadmit_dt WHERE zadmit_dt IS INITIAL OR zadmit_dt = ''.
  MODIFY zthr0112 FROM TABLE lt_z0112.
  IF sy-subrc = 0.
    LOOP AT gt_disp2.
      gt_disp2-zadmit_dt = pa_admdt.
      gt_disp2-state = '완료'.
      MODIFY gt_disp2.
      MOVE-CORRESPONDING gt_disp2 TO lt_z0113.

      PERFORM change_format CHANGING lt_z0113-pwkhr.
      PERFORM change_format CHANGING lt_z0113-owkhr.
      PERFORM change_format CHANGING lt_z0113-zpubhhr.
      PERFORM change_format CHANGING lt_z0113-zrlwkhrtot.
      PERFORM change_format CHANGING lt_z0113-zwkhrtot.
      PERFORM change_format CHANGING lt_z0113-zhkhrtot.
      PERFORM change_format CHANGING lt_z0113-zrlwkhr.
      PERFORM change_format CHANGING lt_z0113-zprsdwkhr.
      PERFORM change_format CHANGING lt_z0113-zadtwkhr.
      PERFORM change_format CHANGING lt_z0113-zedtwkhr.
      PERFORM change_format CHANGING lt_z0113-zrlexwkhr.
      PERFORM change_format CHANGING lt_z0113-zrlovrwkhr.
      PERFORM change_format CHANGING lt_z0113-zrlngtwkhr.
      PERFORM change_format CHANGING lt_z0113-zrlholwkhr.
      PERFORM change_format CHANGING lt_z0113-zrladdwkhr.
      PERFORM change_format CHANGING lt_z0113-zdaehhr.

      lt_z0113-erdat = sy-datum.
      lt_z0113-erzet = sy-uzeit.
      lt_z0113-ernam = sy-uname.
      APPEND lt_z0113. CLEAR lt_z0113.
    ENDLOOP.

    MODIFY zthr0113 FROM TABLE lt_z0113.
    IF sy-subrc = 0.
      COMMIT WORK AND WAIT.
      MESSAGE s016(pn) WITH '확정 처리가 정상적으로 완료 되었습니다'.
    ELSE.
      ROLLBACK WORK.
      MESSAGE w016(pn) WITH '확정 처리중  오류가 발생 되었습니다'.
    ENDIF.
  ELSE.
    ROLLBACK WORK.
    MESSAGE w016(pn) WITH '확정 처리중  오류가 발생 되었습니다'.
  ENDIF.

  CLEAR ok_code.

ENDFORM.                    " CONFIRM_DATA
*&---------------------------------------------------------------------*
*&      Form  GET_CALC_DATA_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_calc_data_display .
  CLEAR: p0001, p2010, gt_disp2.

  MOVE-CORRESPONDING gt_0113 TO gt_disp2.
  gt_disp2-ename = pernr-ename.

  PERFORM change_format2 CHANGING gt_disp2-pwkhr.  "소정근로시간
  PERFORM change_format2 CHANGING gt_disp2-owkhr.  "연장(가능)시간
  PERFORM change_format2 CHANGING gt_disp2-zwkhrtot.  "평일 총근로시간 2020.08.01
  PERFORM change_format2 CHANGING gt_disp2-zhkhrtot.  "휴일 총근로시간 2020.08.01
  PERFORM change_format2 CHANGING gt_disp2-zrlwkhrtot.  "총근로시간
  PERFORM change_format2 CHANGING gt_disp2-zrlwkhr.  "실 근로시간(휴게시간제외)
  PERFORM change_format2 CHANGING gt_disp2-zpubhhr.  "주중공휴일시간
  PERFORM change_format2 CHANGING gt_disp2-zprsdwkhr.  "인정근로시간
  PERFORM change_format2 CHANGING gt_disp2-zadtwkhr.  "간주근로시간
  PERFORM change_format2 CHANGING gt_disp2-zedtwkhr.  "출제위원근로시간
  PERFORM change_format2 CHANGING gt_disp2-zrladdwkhr.  "가산근로시간
  PERFORM change_format2 CHANGING gt_disp2-zrlexwkhr.  "초과근로시간
  PERFORM change_format2 CHANGING gt_disp2-zrlovrwkhr.  "연장근로시간
  PERFORM change_format2 CHANGING gt_disp2-zrlngtwkhr.  "야간근로시간
  PERFORM change_format2 CHANGING gt_disp2-zrlholwkhr.  "휴일근로시간
  PERFORM change_format2 CHANGING gt_disp2-zdaehhr.  "대휴시간

  rp-provide-from-last p0001 space gt_disp2-endda gt_disp2-endda.
  "부서명
  PERFORM get_orgtx USING p0001-vdsk1
                          gt_disp2-vdsk1_tx
                          'F'.
  "조직단위
  PERFORM get_orgtx USING p0001-orgeh
                           gt_disp2-orgeh_tx
                           'S'.

  "사원하위그룹
  SELECT SINGLE ptext
    INTO gt_disp2-persk_tx
    FROM t503t
   WHERE sprsl = sy-langu
     AND persk = p0001-persk.

  " g/l 계정 추가 xa30752 2020.02.20
  IF p0001-persk = 'E1' OR   " 연봉계약직
     p0001-persk = 'E4'.     "외국인 교열요원 (2009.08)
    gt_disp2-zgl01 = '648432'.                              " '648080'.
  ELSEIF p0001-persk = 'D6'.  "효과단 (2010.03.23)
    gt_disp2-zgl01 = '648900'.
  ELSEIF p0001-persk = 'E5'.  " 특정업무직(2019.9.23)
    gt_disp2-zgl01 = '648632'.
  ELSEIF p0001-persk = 'E6'.  " 특정업무직(2019.9.23)
    gt_disp2-zgl01 = '648632'.
  ELSEIF p0001-persk = 'E7'.  " 특정업무직(2019.9.23)
    gt_disp2-zgl01 = '648632'.
  ELSEIF p0001-persk = 'E8'.  " 방송지원직
    gt_disp2-zgl01 = '648645'.
  ELSE.
    gt_disp2-zgl01 = '611210'.   " 일반직
  ENDIF.

  "포지션명
  CALL FUNCTION 'RH_READ_OBJECT'
    EXPORTING
      begda     = gt_disp2-endda
      endda     = gt_disp2-endda
      istat     = '1'
      langu     = sy-langu
      objid     = p0001-plans
      ointerval = 'X'
      otype     = 'S'
      plvar     = '01'
    IMPORTING
      stext     = gt_disp2-plans_tx
    EXCEPTIONS
      not_found = 01.

  "코스트센터명
  CALL FUNCTION 'HR_READ_FOREIGN_OBJECT_TEXT'
    EXPORTING
      otype                   = 'K'
      costcenter              = p0001-kostl
      controllingarea         = p0001-kokrs
      begda                   = gt_disp2-endda
      endda                   = gt_disp2-endda
      langu                   = sy-langu
    IMPORTING
      costcenter_name         = gt_disp2-kostl_tx
    EXCEPTIONS
      nothing_found           = 1
      wrong_objecttype        = 2
      missing_costcenter_data = 3
      missing_object_id       = 4
      OTHERS                  = 5.

  gt_disp2-vdsk1 = p0001-vdsk1.
  gt_disp2-kostl = p0001-kostl.
  gt_disp2-jikjong_k = p0001-jikjong_k.
  gt_disp2-z52wktxt = g_wktp_tx.


  READ TABLE p2010 WITH KEY pernr = gt_0113-pernr
                            begda = gt_0113-zadmit_dt BINARY SEARCH.
  IF sy-subrc = 0.
    gt_disp2-awref = p2010-awref.
  ENDIF.

  APPEND gt_disp2. CLEAR gt_disp2.
ENDFORM.                    " GET_CALC_DATA_DISPLAY

*&---------------------------------------------------------------------*
*&      Form  GET_CALC_sum_DATA_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_calc_sum_data_display .
  DATA: l_orgeh_tx TYPE zth0500-fname,
        l_vdsk1_tx TYPE zth0500-fname,
        l_persk_tx TYPE t503t-ptext,
        l_kostl_tx TYPE hrca_costc-name,
        l_plans_tx TYPE objec-stext.
  DATA: l_lgart TYPE lgart,
        l_lgtxt TYPE lgtxt.

  CLEAR: p0001, p2010, gt_disp3.

  rp-provide-from-last p0001 space pn-endda pn-endda.
  "부서명
  PERFORM get_orgtx USING p0001-vdsk1
                          l_vdsk1_tx
                          'F'.
  "조직단위
  PERFORM get_orgtx USING p0001-orgeh
                          l_orgeh_tx
                          'S'.

  "사원하위그룹
  SELECT SINGLE ptext
    INTO l_persk_tx
    FROM t503t
   WHERE sprsl = sy-langu
     AND persk = p0001-persk.

  "포지션명
  CALL FUNCTION 'RH_READ_OBJECT'
    EXPORTING
      begda     = p0001-begda
      endda     = p0001-begda
      istat     = '1'
      langu     = sy-langu
      objid     = p0001-plans
      ointerval = 'X'
      otype     = 'S'
      plvar     = '01'
    IMPORTING
      stext     = l_plans_tx
    EXCEPTIONS
      not_found = 01.

  "코스트센터명
  CALL FUNCTION 'HR_READ_FOREIGN_OBJECT_TEXT'
    EXPORTING
      otype                   = 'K'
      costcenter              = p0001-kostl
      controllingarea         = p0001-kokrs
      begda                   = p0001-begda
      endda                   = p0001-begda
      langu                   = sy-langu
    IMPORTING
      costcenter_name         = l_kostl_tx
    EXCEPTIONS
      nothing_found           = 1
      wrong_objecttype        = 2
      missing_costcenter_data = 3
      missing_object_id       = 4
      OTHERS                  = 5.


  LOOP AT gt_0113 WHERE pernr = pernr-pernr.
    MOVE-CORRESPONDING gt_0113 TO gt_disp3.
    gt_disp3-ename = pernr-ename.
    gt_disp3-orgeh_tx = l_orgeh_tx.
    gt_disp3-vdsk1 = p0001-vdsk1.
    gt_disp3-vdsk1_tx = l_vdsk1_tx.
    gt_disp3-persk_tx = l_persk_tx.
    gt_disp3-plans_tx = l_plans_tx.
    gt_disp3-kostl = p0001-kostl.
    gt_disp3-kostl_tx = l_kostl_tx.
    gt_disp3-jikjong_k = p0001-jikjong_k.
    gt_disp3-z52wktxt = g_wktp_tx.

    COLLECT gt_disp3. CLEAR gt_disp3.
  ENDLOOP.


  LOOP AT gt_disp3.
    READ TABLE p2010 WITH KEY pernr = gt_disp3-pernr
                              begda = gt_disp3-zadmit_dt BINARY SEARCH.
    IF sy-subrc = 0.
      IF l_lgart <> p2010-lgart .
        SELECT SINGLE lgart lgtxt
          INTO (l_lgart, l_lgtxt)
          FROM t512t
         WHERE lgart = p2010-lgart
           AND sprsl = sy-langu
           AND molga = '41'.

        l_lgart = p2010-lgart.
      ENDIF.

      gt_disp3-awref = p2010-awref.
      gt_disp3-betrg = p2010-betrg.
      gt_disp3-lgart = p2010-lgart.
      gt_disp3-lgtxt = l_lgtxt.

      IF gt_disp3-zotpayamt <> p2010-betrg.
        gt_disp3-state = 'Error'.
        MODIFY gt_disp3. CLEAR gt_disp3.
      ELSEIF gt_disp3-zotpayamt = 0 AND p2010-betrg = 0.
        DELETE TABLE gt_disp3 FROM gt_disp3. CLEAR gt_disp3.
      ELSE.
        MODIFY gt_disp3. CLEAR gt_disp3.
      ENDIF.
    ELSE.
      DELETE TABLE gt_disp3 FROM gt_disp3. CLEAR gt_disp3.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " GET_CALC_DATA_DISPLAY
*&---------------------------------------------------------------------*
*&      Form  SET_MISS_APPROVE_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_miss_approve_list .
  CLEAR: gt_disp, p0001.

  MOVE-CORRESPONDING gt_0112 TO gt_disp.

  rp-provide-from-last p0001 space gt_0112-endda gt_0112-endda.

  SELECT SINGLE ename zztrfgr
    INTO (gt_disp-zpname, gt_disp-zztrfgr)
    FROM pa0001
   WHERE pernr = gt_disp-zpernr
     AND begda <= g_mon_eda
     AND endda >= g_mon_eda.

  "부서명
  PERFORM get_orgtx USING pernr-vdsk1
                          gt_disp-vdsk1_tx
                          'F'.
  "조직단위
  PERFORM get_orgtx USING pernr-orgeh
                          gt_disp-orgeh_tx
                          'S'.

  "사원하위그룹
  SELECT SINGLE ptext
    INTO gt_disp-persk_tx
    FROM t503t
   WHERE sprsl = sy-langu
     AND persk = pernr-persk.

  "포지션명
  CALL FUNCTION 'RH_READ_OBJECT'
    EXPORTING
      begda     = gt_0112-endda
      endda     = gt_0112-endda
      istat     = '1'
      langu     = sy-langu
      objid     = pernr-plans
      ointerval = 'X'
      otype     = 'S'
      plvar     = '01'
    IMPORTING
      stext     = gt_disp-plans_tx
    EXCEPTIONS
      not_found = 01.

  "코스트센터명
  CALL FUNCTION 'HR_READ_FOREIGN_OBJECT_TEXT'
    EXPORTING
      otype                   = 'K'
      costcenter              = pernr-kostl
      controllingarea         = pernr-kokrs
      begda                   = gt_0112-endda
      endda                   = gt_0112-endda
      langu                   = sy-langu
    IMPORTING
      costcenter_name         = gt_disp-kostl_tx
    EXCEPTIONS
      nothing_found           = 1
      wrong_objecttype        = 2
      missing_costcenter_data = 3
      missing_object_id       = 4
      OTHERS                  = 5.

  gt_disp-ename = p0001-ename.
  gt_disp-vdsk1 = p0001-vdsk1.
  gt_disp-kostl = p0001-kostl.
  gt_disp-jikjong_k = p0001-jikjong_k.

*  PERFORM get_52wkty_text  USING  GT_DISP-Z52WKTP
*                                  GT_DISP-Z52WKTP_TX.

  APPEND gt_disp. CLEAR gt_disp.
ENDFORM.                    " SET_MISS_APPROVE_LIST


*&---------------------------------------------------------------------*
*&      Form  GET_ORGTX
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P0001_ORGEH  text
*      -->P_P0001_VDSK1  text
*      -->P_GT_DISP2_ORGTX  text
*----------------------------------------------------------------------*
FORM get_orgtx  USING    pz_orgeh
                         pz_orgtx
                         pz_case.

  CLEAR:pz_orgtx, gt_0500.
  READ TABLE gt_0500 WITH KEY objid = pz_orgeh BINARY SEARCH.

  IF pz_case = 'F'.
    pz_orgtx = gt_0500-fname.
  ELSE.
    pz_orgtx = gt_0500-sname.
  ENDIF.

ENDFORM.                    " GET_ORGTX
*&---------------------------------------------------------------------*
*&      Form  GET_52WKTY_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_DISP2_Z52WKTP  text
*      -->P_GT_DISP2_Z52WKTP_TX  text
*----------------------------------------------------------------------*
FORM get_52wkty_text  USING   p_domname
                              p_wktp
                              p_wktp_tx.

  DATA: l_dvalue TYPE domvalue_l,
        l_ddtext LIKE dd07v-ddtext.

  l_dvalue = p_wktp.

  CALL FUNCTION 'DOMAIN_VALUE_GET'
    EXPORTING
      i_domname  = p_domname
      i_domvalue = l_dvalue
    IMPORTING
      e_ddtext   = l_ddtext.

  p_wktp_tx = l_ddtext.

ENDFORM.                    " GET_52WKTY_TEXT
*&---------------------------------------------------------------------*
*&      Form  CANCLE_CONFIRM_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM cancle_confirm_data .
  DATA: lt_z0112 TYPE STANDARD TABLE OF zthr0112 WITH  HEADER LINE,
        lt_z0113 TYPE STANDARD TABLE OF zthr0113 WITH  HEADER LINE,
        lt_2010 TYPE STANDARD TABLE OF pa2010 WITH  HEADER LINE.

  DATA: lv_tot TYPE i,
        lv_suc TYPE i,
        lv_fail TYPE i.


* 정산취소대상 확인
  LOOP AT gt_disp2 WHERE state = '' AND ( awref IS INITIAL OR awref = '').
  ENDLOOP.
  CHECK sy-subrc = 0.

* 실적 정산된 건
  SELECT *
    INTO TABLE lt_z0112
    FROM zthr0112
     FOR ALL ENTRIES IN gt_disp2
   WHERE pernr = gt_disp2-pernr
     AND begda = gt_disp2-begda
     AND endda = gt_disp2-endda
     AND z52wktp = gt_disp2-z52wktp
     AND z52prsq = gt_disp2-z52prsq
     AND zadmit_dt = gt_disp2-zadmit_dt
     AND state = '3'.

* 급여 반영 건
  SELECT *
    INTO TABLE lt_2010
    FROM pa2010
     FOR ALL ENTRIES IN gt_disp2
   WHERE pernr = gt_disp2-pernr
     AND begda = gt_disp2-zadmit_dt
     AND subty = '8050'.
*    AND awref = ''. " 미지급건만

  SORT lt_2010.


* 전표발생건 대상 제외
  LOOP AT lt_z0112.
    CLEAR lt_2010.
    READ TABLE lt_2010 WITH KEY pernr = lt_z0112-pernr BINARY SEARCH.
    CHECK sy-subrc = 0.

    IF lt_2010-awref <> ''.
      DELETE lt_z0112.
    ENDIF.
  ENDLOOP.

  DELETE  lt_2010 WHERE awref <> ''.

* infotpye 2010 삭제
  IF lt_2010[] IS NOT INITIAL.
    DELETE pa2010 FROM lt_2010.
    IF sy-subrc <> 0.
      ROLLBACK WORK.  CLEAR ok_code.
      MESSAGE w016(pn) WITH ' 정산 취소 중 오류가 발생했습니다'.
      EXIT.
    ENDIF.
  ENDIF.

* 실적 table 정산일자 clear
  IF lt_z0112[] IS NOT INITIAL.
    CLEAR: lt_z0112-zprsdwk_tm,  "인정근로시간
           lt_z0112-zadtwk_tm,  "간주근로시간(근태)
           lt_z0112-zadmit_dt.  "정산일
    MODIFY lt_z0112 TRANSPORTING zprsdwk_tm zadtwk_tm zadmit_dt WHERE zadmit_dt <> ''.
    MODIFY zthr0112 FROM TABLE lt_z0112.
    IF sy-subrc <> 0.
      ROLLBACK WORK.  CLEAR ok_code.
      MESSAGE w016(pn) WITH '정산 취소 중 오류가 발생했습니다'.
      EXIT.
    ENDIF.
  ENDIF.


* 정산 table 삭제
  LOOP AT gt_disp2 WHERE state = '' AND ( awref IS INITIAL OR awref = '').
    DELETE FROM zthr0113  WHERE zadmit_dt = gt_disp2-zadmit_dt
                            AND pernr = gt_disp2-pernr
                            AND begda = gt_disp2-begda
                            AND endda = gt_disp2-endda
                            AND z52wktp = gt_disp2-z52wktp
                            AND z52prsq = gt_disp2-z52prsq
                            AND zadmit_ym = gt_disp2-zadmit_ym.

    IF sy-subrc <> 0.
      ROLLBACK WORK. CLEAR ok_code.
      lv_fail = 1.
      MESSAGE w016(pn) WITH '정산 취소 중 오류가 발생했습니다'.
      EXIT.
    ENDIF.
  ENDLOOP.

  IF lv_fail = 1.
    EXIT.
  ENDIF.

  LOOP AT gt_disp2 WHERE state = '' AND ( awref IS INITIAL OR awref = '').
    gt_disp2-state = '취소완료'.
    gt_disp2-zadmit_dt = ''.
    MODIFY gt_disp2.
  ENDLOOP.

  MESSAGE s016(pn) WITH '취소완료 되었습니다'.
  CLEAR ok_code.
ENDFORM.                    " CANCLE_CONFIRM_DATA


*&---------------------------------------------------------------------*
*&      Form  event_top_of_page
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->DG_DYNDOC_ID  text
*----------------------------------------------------------------------*
FORM event_top_of_page USING dg_dyndoc_id TYPE REF TO cl_dd_document..

  DATA: dl_text(255) TYPE c.

* 타이틀
  CONCATENATE `대상연월 : `  pa_yymm(4) '.' pa_yymm+4(2) INTO   dl_text.

*  CALL METHOD dg_dyndoc_id->add_gap.

  CALL METHOD o_dyndoc_id->add_text
    EXPORTING
      text = dl_text.
*      sap_style = cl_dd_area=>heading
*      sap_color = cl_dd_area=>list_heading_int.

*  CALL METHOD dg_dyndoc_id->add_gap
*    EXPORTING
*      width = 200.

*  CALL METHOD dg_dyndoc_id->new_line.


  CLEAR dl_text.

  CASE 'X'.
    WHEN rb1.
      dl_text = '선택근로 실비 확정 조회'.
    WHEN rb2.
      dl_text = '선택근로 실비 정산'.
    WHEN rb3.
      dl_text = '선택근로 실적 미결처리'.
    WHEN rb4.
      dl_text = '선택근로 월 합산내역조회'.
  ENDCASE.

*  CALL METHOD dg_dyndoc_id->add_text
*    EXPORTING
*      text         = dl_text.
*      sap_style    = cl_dd_area=>heading
*      sap_fontsize = cl_dd_area=>large
*      sap_color    = cl_dd_area=>list_heading_int.


  CALL METHOD dg_dyndoc_id->new_line.

  CLEAR dl_text.
  CONCATENATE `대상인원 : ` gv_pcnt INTO dl_text.
  CALL METHOD dg_dyndoc_id->add_text
    EXPORTING
      text = dl_text.
*      sap_emphasis    = cl_dd_area=>heading
*      sap_fontsize = cl_dd_area=>large
*      sap_color    = cl_dd_area=>list_negative_inv.



  IF o_html_cntl IS INITIAL.
    CREATE OBJECT o_html_cntl
      EXPORTING
        parent = o_parent_top.
  ENDIF.

  CALL METHOD o_dyndoc_id->merge_document.
  o_dyndoc_id->html_control = o_html_cntl.
  CALL METHOD o_dyndoc_id->display_document
    EXPORTING
      reuse_control      = 'X'
      parent             = o_parent_top
    EXCEPTIONS
      html_display_error = 1.


ENDFORM.                    "event_top_of_page
*&---------------------------------------------------------------------*
*&      Form  get_event
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_EVENTS  text
*----------------------------------------------------------------------*
FORM get_event USING gt_events TYPE slis_t_event.
  DATA: ls_event  TYPE slis_alv_event.
  CLEAR ls_event.
  REFRESH gt_events.


  ls_event-name = 'TOP_OF_PAGE'.
  ls_event-form = 'TOP_OF_PAGE'.
  APPEND ls_event TO gt_events.

ENDFORM.                    " get_event


*&---------------------------------------------------------------------*
*&      Form  SET_SORT_TAB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_sort_tab .
  CASE 'X'.
    WHEN rb1 OR rb2.
      CLEAR: gt_sorttab[].
      gt_sorttab-fieldname = 'PERNR'.
      gt_sorttab-spos      = 1.
      gt_sorttab-up        = 'X'.
      APPEND  gt_sorttab.

      gt_sorttab-fieldname = 'ENAME'.
      gt_sorttab-spos      = 2.
      gt_sorttab-up        = 'X'.
      APPEND  gt_sorttab.

      gt_sorttab-fieldname = 'ORGTX'.
      gt_sorttab-spos      = 3.
      gt_sorttab-up        = 'X'.
      APPEND  gt_sorttab.

      gt_sorttab-fieldname = 'Z52WKTXT'.
      gt_sorttab-spos      = 4.
      gt_sorttab-up        = 'X'.
      APPEND  gt_sorttab.

      gt_sorttab-fieldname = 'Z52BGA'.
      gt_sorttab-spos      = 5.
      gt_sorttab-up        = 'X'.
      APPEND  gt_sorttab.

      gt_sorttab-fieldname = 'Z52EDA'.
      gt_sorttab-spos      = 5.
      gt_sorttab-up        = 'X'.
      APPEND  gt_sorttab.

      gt_sorttab-fieldname = 'Z52PRSQ'.
      gt_sorttab-spos      = 6.
      gt_sorttab-up        = 'X'.
      APPEND  gt_sorttab.

      gt_sorttab-fieldname = 'ZDUNG'.
      gt_sorttab-spos      = 7.
      gt_sorttab-up        = 'X'.
      APPEND  gt_sorttab.

      gt_sorttab-fieldname = 'ZCOST'.
      gt_sorttab-spos      = 8.
      gt_sorttab-up        = 'X'.
      APPEND  gt_sorttab.

  ENDCASE.

ENDFORM.                    " SET_SORT_TAB
*&---------------------------------------------------------------------*
*&      Form  SET_APPROVE_STATUS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_approve_status .
  DATA: ls_z0112 TYPE zthr0112.

  CHECK gt_disp-state <> 'F'.

  MOVE-CORRESPONDING gt_disp TO ls_z0112.
  ls_z0112-state = 'F'.

  PERFORM get_52wkty_text USING 'ZSTATE_1'
                                ls_z0112-state
                                ls_z0112-state_txt  .
  ls_z0112-cdate = sy-datum.
  ls_z0112-cpernr = sy-uname.

  MODIFY zthr0112 FROM ls_z0112.
  IF sy-subrc = 0 .
    COMMIT WORK AND WAIT.
    gt_disp-message = '미결처리되었습니다'.
    gt_disp-state = ls_z0112-state.
    gt_disp-state_txt = ls_z0112-state_txt.
    gt_disp-cdate = ls_z0112-cdate.
    gt_disp-cpernr = ls_z0112-cpernr.

*   신청건 회수처리. 20191008. 임재하.
    IF gt_disp-zserial IS NOT INITIAL.
      CALL FUNCTION 'ZWF_DELETE'
        EXPORTING
          tabname            = 'ZWF0022'
          key_1              = gt_disp-zserial
          key_2              = 'E'
        EXCEPTIONS
          already_delete     = 1
          already_approved   = 2
          already_rejected   = 3
          lock_wf            = 4
          not_found_wf_table = 5
          error_update_wf    = 6
          error_del_wf       = 7
          OTHERS             = 8.
    ENDIF.

  ELSE.
    ROLLBACK WORK.
    gt_disp-message = '처리중 오류가 발생되었습니다'.
  ENDIF.

ENDFORM.                    " SET_APPROVE_STATUS
*&---------------------------------------------------------------------*
*&      Form  MODIFY_AMT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM modify_amt .
  DATA : lt_tab LIKE TABLE OF zthreditcost WITH HEADER LINE.

  CLEAR : lt_tab, lt_tab[].

  SELECT  *
    FROM zthreditcost
    INTO CORRESPONDING FIELDS OF TABLE lt_tab
    WHERE zadmit_ym = pa_yymm.
  SORT lt_tab.

  LOOP AT gt_disp2.
    READ TABLE lt_tab WITH KEY zadmit_ym = gt_disp2-zadmit_ym
                                                  pernr = gt_disp2-pernr

    BINARY SEARCH.

    IF sy-subrc = 0.
      "금액 처리는 그대로 두고 보정 적용 대상만 기록한다.
      CLEAR gt_cost_applied.
      gt_cost_applied-zadmit_ym = gt_disp2-zadmit_ym.
      gt_cost_applied-pernr = gt_disp2-pernr.
      COLLECT gt_cost_applied.

      gt_disp2-zdaehamt = lt_tab-zdaehamt / 100.
      gt_disp2-zrlovramt =   lt_tab-zrlovramt / 100.
      gt_disp2-zrlngtamt =  lt_tab-zrlngtamt / 100.
      gt_disp2-zrlholamt = lt_tab-zrlholamt / 100.
      gt_disp2-tdcost  = lt_tab-tdcost / 100  .
      gt_disp2-zrlprdamt =   lt_tab-zrlprdamt / 100.
      IF  pa_retro <> 'X'.
        gt_disp2-zretroamt = lt_tab-zretroamt / 100.
      ENDIF.
      gt_disp2-zotpayamt  = gt_disp2-zretroamt + gt_disp2-zrlprdamt.


      MODIFY gt_disp2         TRANSPORTING zdaehamt
                                                       zrlovramt
                                                       zrlngtamt
                                                        zrlholamt
                                                         tdcost
                                                         zrlprdamt
                                                         zretroamt
                                                         zotpayamt   .
    ELSE.
      CONTINUE.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " MODIFY_AMT

* 당월·소급 기간별 화면 구성. 확정용 GT_DISP2는 유지한다.
FORM make_display_data .
  DATA: ls_base LIKE LINE OF gt_disp2,
        ls_new TYPE zthr0113,
        ls_old TYPE zthr0113,
        lt_old TYPE STANDARD TABLE OF zthr0113,
        lv_pernr TYPE persno,
        lv_index TYPE sy-tabix,
        lv_last TYPE sy-tabix,
        lv_retro TYPE zthr0113-zretroamt,
        lv_split TYPE c.

  REFRESH gt_display.
  CLEAR gt_display.
  lt_old[] = gt_retro_old[].

  "당월 정산기간별 행을 먼저 만든다.
  LOOP AT gt_disp2 INTO ls_base.
    CLEAR gt_display.
    MOVE-CORRESPONDING ls_base TO gt_display.
    gt_display-target_ym = ls_base-zadmit_ym.
    gt_display-row_kind = 'N'.
    gt_display-row_text = '당월 정산'.
    gt_display-row_order = 1.
    CLEAR lv_split.

    IF pa_retro = 'X'.
      READ TABLE gt_cost_applied
        WITH KEY zadmit_ym = ls_base-zadmit_ym
                 pernr = ls_base-pernr
        TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        gt_display-row_kind = 'C'.
        gt_display-row_text = '기존 보정 적용'.
      ELSE.
        lv_split = 'X'.
      ENDIF.
    ENDIF.

    IF lv_split = 'X'.
      "화면 복사본에서만 소급액을 떼어낸다.
      CLEAR gt_display-zretroamt.
      gt_display-zotpayamt = ls_base-zrlprdamt.
    ENDIF.
    APPEND gt_display.
  ENDLOOP.

  IF pa_retro <> 'X'.
    RETURN.
  ENDIF.

  "직원당 한 번만 과거 기간들을 표시한다.
  CLEAR lv_pernr.
  LOOP AT gt_disp2 INTO ls_base.
    IF ls_base-pernr = lv_pernr.
      CONTINUE.
    ENDIF.
    lv_pernr = ls_base-pernr.

    READ TABLE gt_cost_applied
      WITH KEY zadmit_ym = ls_base-zadmit_ym
               pernr = ls_base-pernr
      TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      CONTINUE.
    ENDIF.

    "재계산에 존재하는 기간과 동일한 기존 확정 기간을 대조한다.
    LOOP AT gt_retro_new INTO ls_new
      WHERE pernr = ls_base-pernr.
      CLEAR gt_display.
      MOVE-CORRESPONDING ls_base TO gt_display.
      MOVE-CORRESPONDING ls_new TO gt_display.
      gt_display-target_ym = ls_new-zadmit_ym.
      gt_display-row_kind = 'R'.
      gt_display-row_text = '소급 재계산'.
      gt_display-row_order = 2.
      CLEAR: gt_display-old_amt, gt_display-diff_amt,
             gt_display-zretroamt, gt_display-zotpayamt.

      LOOP AT lt_old INTO ls_old
        WHERE pernr = ls_new-pernr
          AND zadmit_ym = ls_new-zadmit_ym
          AND begda = ls_new-begda
          AND endda = ls_new-endda
          AND z52wktp = ls_new-z52wktp
          AND z52prsq = ls_new-z52prsq.
        lv_index = sy-tabix.
        ADD ls_old-zrlprdamt TO gt_display-old_amt.
        DELETE lt_old INDEX lv_index.
      ENDLOOP.

      gt_display-diff_amt = ls_new-zrlprdamt
                          - gt_display-old_amt.
      APPEND gt_display.
    ENDLOOP.

    "기존 확정에만 남은 기간도 0원 재계산/음수 차액으로 표시한다.
    LOOP AT lt_old INTO ls_old
      WHERE pernr = ls_base-pernr.
      lv_index = sy-tabix.
      CLEAR gt_display.
      MOVE-CORRESPONDING ls_base TO gt_display.
      gt_display-zadmit_ym = ls_old-zadmit_ym.
      gt_display-begda = ls_old-begda.
      gt_display-endda = ls_old-endda.
      gt_display-z52wktp = ls_old-z52wktp.
      gt_display-z52prsq = ls_old-z52prsq.
      gt_display-target_ym = ls_old-zadmit_ym.
      gt_display-row_kind = 'R'.
      gt_display-row_text = '소급 재계산 결과 없음'.
      gt_display-row_order = 2.
      "당월 시간/금액이 과거 행에 남지 않도록 정산 구조를 비운다.
      PERFORM clear_display_result.
      gt_display-old_amt = ls_old-zrlprdamt.
      gt_display-diff_amt = 0 - ls_old-zrlprdamt.
      APPEND gt_display.
      DELETE lt_old INDEX lv_index.
    ENDLOOP.
  ENDLOOP.

  SORT gt_display BY pernr row_order target_ym begda endda.

  "실제 지급 소급액은 기간별 차액과 별개로 기존 계산값을 사용한다.
  "직원별 마지막 소급 행에 한 번만 표시하여 지급액 합계를 맞춘다.
  CLEAR lv_pernr.
  LOOP AT gt_disp2 INTO ls_base.
    IF ls_base-pernr = lv_pernr.
      CONTINUE.
    ENDIF.
    lv_pernr = ls_base-pernr.
    READ TABLE gt_cost_applied
      WITH KEY zadmit_ym = ls_base-zadmit_ym
               pernr = ls_base-pernr
      TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      CONTINUE.
    ENDIF.

    CLEAR: lv_retro, lv_last.
    LOOP AT gt_disp2 WHERE pernr = ls_base-pernr.
      ADD gt_disp2-zretroamt TO lv_retro.
    ENDLOOP.
    LOOP AT gt_display WHERE pernr = ls_base-pernr
                        AND row_kind = 'R'.
      lv_last = sy-tabix.
    ENDLOOP.

    IF lv_last = 0 AND lv_retro <> 0.
      "개별 보정 등으로 상세 없이 소급액만 있는 경우도 합계를 보존.
      CLEAR gt_display.
      MOVE-CORRESPONDING ls_base TO gt_display.
      PERFORM clear_display_result.
      gt_display-row_kind = 'R'.
      gt_display-row_text = '소급 반영액(상세 없음)'.
      gt_display-row_order = 2.
      CLEAR: gt_display-begda, gt_display-endda,
             gt_display-target_ym.
      APPEND gt_display.
      DESCRIBE TABLE gt_display LINES lv_last.
    ENDIF.

    IF lv_last <> 0.
      READ TABLE gt_display INDEX lv_last.
      gt_display-zretroamt = lv_retro.
      gt_display-zotpayamt = lv_retro.
      MODIFY gt_display INDEX lv_last
        TRANSPORTING zretroamt zotpayamt.
    ENDIF.
  ENDLOOP.

  SORT gt_display BY pernr row_order target_ym begda endda.
ENDFORM.

*& 재계산 결과가 없는 행의 시간·금액만 초기화한다.
FORM clear_display_result .
  CLEAR: gt_display-pwkhr, gt_display-owkhr,
         gt_display-zwkhrtot, gt_display-zhkhrtot,
         gt_display-zrlwkhrtot, gt_display-zrlwkhr,
         gt_display-zpubhhr, gt_display-zprsdwkhr,
         gt_display-zadtwkhr, gt_display-zedtwkhr,
         gt_display-zrladdwkhr, gt_display-zrlexwkhr,
         gt_display-zdaeh_day, gt_display-zdaehhr,
         gt_display-zdaehamt, gt_display-zrlovrwkhr,
         gt_display-zrlovramt, gt_display-zrlngtwkhr,
         gt_display-zrlngtamt, gt_display-zrlholwkhr,
         gt_display-zrlholamt, gt_display-tdcost,
         gt_display-zrlprdamt, gt_display-zretroamt,
         gt_display-zotpayamt, gt_display-zcost,
         gt_display-zdung, gt_display-old_amt,
         gt_display-diff_amt.
ENDFORM.
