*&---------------------------------------------------------------------*
*&  Include           ZRPTH408F01
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
  p_frdat = sy-datum(6).
  p_frdat+6(2) = '01'.

  CALL FUNCTION 'HR_IN_LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = p_frdat
    IMPORTING
      last_day_of_month = p_todat
    EXCEPTIONS
      day_in_no_date    = 1
      OTHERS            = 2.

  p_kjdat = sy-datum(6).
*  p_kjdat+6(2) = '21'.


  gt_title-text = '사번'. APPEND gt_title.
  gt_title-text = '이름'. APPEND gt_title.
  gt_title-text = '직급'. APPEND gt_title.
  gt_title-text = '근로유형'. APPEND gt_title.
  gt_title-text = '제작유형'. APPEND gt_title.
  gt_title-text = '구분'. APPEND gt_title.
  gt_title-text = '직무'. APPEND gt_title.
  gt_title-text = '재량시작일'. APPEND gt_title.
  gt_title-text = '재량종료일'. APPEND gt_title.
  gt_title-text = '대휴일수'. APPEND gt_title.
  gt_title-text = '대휴보상액'. APPEND gt_title.
  gt_title-text = '대휴발생일'. APPEND gt_title.
  gt_title-text = '사용시작일'. APPEND gt_title.
  gt_title-text = '사용종료일'. APPEND gt_title.
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
        lv_endda TYPE endda,
        lv_kjdat TYPE dats.

  IF p_select = 'X'.  "대휴일 조회
    lv_begda = p_frdat.
    lv_endda = p_todat.
  ELSE.  "대휴 생성
    CONCATENATE p_kjdat '01' INTO lv_kjdat.

    CALL FUNCTION 'HR_IN_LAST_DAY_OF_MONTHS'
      EXPORTING
        day_in            = lv_kjdat
      IMPORTING
        last_day_of_month = lv_kjdat
      EXCEPTIONS
        day_in_no_date    = 1
        OTHERS            = 2.

    lv_begda = lv_kjdat.
    lv_endda = lv_kjdat.
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
*&      Form  F4_KJDAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f4_kjdat .
  DATA: lv_mf_returncode LIKE sy-subrc,
            lv_mf_monat  LIKE isellist-month.

  DATA lt_mf_dynpfields TYPE TABLE OF dynpread WITH HEADER LINE.

  lt_mf_dynpfields-fieldname = 'P_KJDAT'.
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
      selected_month             = p_kjdat
      return_code                = lv_mf_returncode
    EXCEPTIONS
      factory_calendar_not_found = 1
      holiday_calendar_not_found = 2
      month_not_found            = 3
      OTHERS                     = 4.
  IF sy-subrc = 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.                    " F4_KJDAT
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
        lv_endda TYPE endda,
        lv_beg_dt TYPE begda,
        lv_end_dt TYPE endda,
        lv_beg_bool TYPE abap_bool,
        lv_end_bool TYPE abap_bool,
        lv_tabix TYPE sy-tabix,
        lv_kjdat TYPE dats.

  DATA: lt_tmp LIKE TABLE OF gt_disp WITH HEADER LINE,
        lt_prdty TYPE TABLE OF zthr0125 WITH HEADER LINE,
        lt_gbnty TYPE TABLE OF zthr0126 WITH HEADER LINE,
        lt_jobty TYPE TABLE OF zthr0127 WITH HEADER LINE,
        lt_oinfo TYPE TABLE OF zth0500 WITH HEADER LINE,
        lt_zthrbs01 TYPE TABLE OF zthrbs01 WITH HEADER LINE,
        lt_zthr0129 TYPE TABLE OF zthr0129 WITH HEADER LINE,
        lt_zthr0130 TYPE TABLE OF zthr0130 WITH HEADER LINE.

  DATA: ls_z52wktp TYPE hrecm00keyandtext ,
        lt_z52wktp TYPE TABLE OF hrecm00keyandtext.


  IF p_select = 'X'.  "대휴일 조회
    IF p_frdat IS INITIAL OR p_todat IS INITIAL.
      gv_stop = 'X'.
      MESSAGE s001 DISPLAY LIKE 'E' WITH '검색기간을 입력하십시오.'.
      RETURN.
    ENDIF.

    lv_begda = p_frdat.
    lv_endda = p_todat.
  ELSE.  "대휴 생성
    IF p_kjdat IS INITIAL.
      gv_stop = 'X'.
*      MESSAGE s001 DISPLAY LIKE 'E' WITH '기준일을 입력하십시오.'.
      MESSAGE s001 DISPLAY LIKE 'E' WITH '기준월을 입력하십시오.'.
      RETURN.
    ENDIF.

*    lv_begda = p_kjdat.
*    lv_endda = p_kjdat.

    CONCATENATE p_kjdat '01' INTO lv_kjdat.

    lv_begda = lv_kjdat.

    CALL FUNCTION 'HR_IN_LAST_DAY_OF_MONTHS'
      EXPORTING
        day_in            = lv_kjdat
      IMPORTING
        last_day_of_month = lv_kjdat
      EXCEPTIONS
        day_in_no_date    = 1
        OTHERS            = 2.

    lv_endda = lv_kjdat.

  ENDIF.

  CLEAR: gt_disp, gt_disp[].


  SELECT a~pernr a~begda a~endda a~z52wktp a~prdty a~gbnty a~jobty
         b~jikwidung b~jikwidung_1 b~ename b~vdsk1
    INTO CORRESPONDING FIELDS OF TABLE lt_tmp
    FROM pa9021 AS a INNER JOIN pa0001 AS b
                     ON a~pernr = b~pernr
   WHERE a~z52wktp = '0140'
     AND a~pernr IN s_pernr
     AND a~begda >= lv_begda
     AND a~endda <= lv_endda
     AND b~vdsk1 IN s_orgeh
     AND b~begda <= lv_begda
     AND b~endda >= lv_begda.

*  SELECT a~pernr a~begda a~endda a~z52wktp a~prdty a~gbnty a~jobty
*     b~jikwidung b~jikwidung_1 b~ename b~vdsk1
*APPENDING CORRESPONDING FIELDS OF TABLE lt_tmp
*FROM pa9021 AS a INNER JOIN pa0001 AS b
*                 ON a~pernr = b~pernr
*WHERE a~z52wktp = '0140'
* AND a~pernr IN s_pernr
* AND a~begda <= lv_begda
* AND a~endda >= lv_endda
* AND b~vdsk1 IN s_orgeh
* AND b~begda <= lv_begda
* AND b~endda >= lv_begda.
*
*
*  SORT lt_tmp BY pernr.
*  DELETE ADJACENT DUPLICATES FROM lt_tmp COMPARING ALL FIELDS.


  IF sy-subrc = 0.
    IF p_select = 'X'.
      "대휴
      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE lt_zthrbs01
        FROM zthrbs01
        FOR ALL ENTRIES IN lt_tmp
       WHERE pernr = lt_tmp-pernr
         AND zdaeh = 'Y'
         AND state = '3'
         AND zsourflex = 'U'
         AND zdday <= p_todat
         AND zdday >= p_frdat.

      SORT lt_zthrbs01 BY pernr.
    ELSE.
      "재량근로 대휴일수
      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE lt_zthr0129
        FROM zthr0129
       WHERE begda <= lv_kjdat
         AND endda >= lv_kjdat.

      SORT lt_zthr0129 BY prdty gbnty jobty.

      "재량근로 대휴보상액
      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE lt_zthr0130
        FROM zthr0130
       WHERE begda <= lv_kjdat
         AND endda >= lv_kjdat.

      SORT lt_zthr0130 BY prdty gbnty jobty.
    ENDIF.

    "제작유형
    SELECT *
      INTO CORRESPONDING FIELDS OF TABLE lt_prdty
      FROM zthr0125
     WHERE begda <= lv_endda
       AND endda >= lv_begda.

    "구분
    SELECT *
      INTO CORRESPONDING FIELDS OF TABLE lt_gbnty
      FROM zthr0126
     WHERE begda <= lv_endda
       AND endda >= lv_begda.

    "직무
    SELECT *
      INTO CORRESPONDING FIELDS OF TABLE lt_jobty
      FROM zthr0127
     WHERE begda <= lv_endda
       AND endda >= lv_begda.

    "부서정보
*    SELECT *
*      INTO CORRESPONDING FIELDS OF TABLE lt_oinfo
*      FROM zth0500
*     WHERE begda <= lv_endda
*       AND endda >= lv_begda.

    "근로유형
    CALL FUNCTION 'ZHR_52TM_WKTYPE'
      IMPORTING
        resulttab = lt_z52wktp.
  ENDIF.


  LOOP AT lt_tmp.
    MOVE-CORRESPONDING lt_tmp TO gt_disp.

    IF p_select = 'X'.  "대휴일 조회
      CLEAR lv_tabix.
      READ TABLE lt_zthrbs01 WITH KEY pernr = lt_tmp-pernr BINARY SEARCH.
      lv_tabix = sy-tabix.
      "재량근로 수당/지급일/통화키
      LOOP AT lt_zthrbs01 FROM lv_tabix WHERE zdday BETWEEN lt_tmp-begda AND lt_tmp-endda.
        IF lt_zthrbs01-pernr <> lt_tmp-pernr.
          EXIT.
        ENDIF.

        gt_disp-dhnum = '1'.
        gt_disp-dhamt = lt_zthrbs01-zd_money / 100.
        gt_disp-zdday = lt_zthrbs01-zdday.
        gt_disp-zdbeg = lt_zthrbs01-zdbeg.
        gt_disp-zdend = lt_zthrbs01-zdend.
        gt_disp-waers = 'KRW'.

        APPEND gt_disp.
      ENDLOOP.
    ELSE.  "대휴 생성
      "대휴보상액/통화키
      READ TABLE lt_zthr0130 WITH KEY prdty = gt_disp-prdty
                                      gbnty = gt_disp-gbnty
                                      jobty = gt_disp-jobty BINARY SEARCH.
      IF sy-subrc = 0.
        gt_disp-dhamt = lt_zthr0130-dhamt.
        gt_disp-waers = lt_zthr0130-waers.
      ENDIF.

      "대휴일수/대휴발생일/사용시작일/사용종료일
      READ TABLE lt_zthr0129 WITH KEY prdty = gt_disp-prdty
                                      gbnty = gt_disp-gbnty
                                      jobty = gt_disp-jobty BINARY SEARCH.
      IF sy-subrc = 0.
*①  P9021-BEGDA < 16日 100% and P9021-BEGDA >= 16日 50%
*②  P9021-ENDDA >= 16日 100% and P9021-ENDDA < 16日 50%

        lv_beg_bool = abap_true.
        lv_end_bool = abap_true.


        lv_beg_dt = p_kjdat.
        lv_beg_dt+6(2) = '01'.
        lv_end_dt = lv_kjdat.  "기준월 마지막 일자로 지정

*        CALL FUNCTION 'HR_IN_LAST_DAY_OF_MONTHS'
*          EXPORTING
*            day_in            = lv_beg_dt
*          IMPORTING
*            last_day_of_month = lv_end_dt
*          EXCEPTIONS
*            day_in_no_date    = 1
*            OTHERS            = 2.

        IF gt_disp-begda BETWEEN lv_beg_dt AND lv_end_dt.
          IF gt_disp-begda+6(2) < '16'.
            lv_beg_bool = abap_true.
          ELSE.
            lv_beg_bool = abap_false.
          ENDIF.
        ENDIF.

        IF gt_disp-endda BETWEEN lv_beg_dt AND lv_end_dt.
          IF gt_disp-endda+6(2) >= '16'.
            lv_end_bool = abap_true.
          ELSE.
            lv_end_bool = abap_false.
          ENDIF.
        ENDIF.

        IF ( lv_beg_bool = abap_true AND lv_end_bool = abap_true ).
          gt_disp-dhcnt = lt_zthr0129-dhcnt. " 대휴일수(월)
          gt_disp-ndhcnt = lt_zthr0129-ndhcnt. " 의무사용 대휴일수(월) xa30752
        ELSE.
          gt_disp-dhcnt = lt_zthr0129-dhcnt / 2.
          gt_disp-ndhcnt = lt_zthr0129-ndhcnt / 2. " 반올림 확인
        ENDIF.

        "사용시작일/사용종료일
        PERFORM get_zdbeg_zdend_1year USING gt_disp-pernr
                                      lv_kjdat  "기준일
                                CHANGING gt_disp-zdbeg
                                         gt_disp-zdend.

        "대휴일수 만큰 생성
        DO gt_disp-dhcnt TIMES.
          gt_disp-dhnum = '1'.
          "대휴발생일
*          gt_disp-zdday = p_kjdat - sy-index.
          gt_disp-zdday = gt_disp-endda - sy-index + 1.

          APPEND gt_disp.
        ENDDO.


        sy-tabix = sy-tabix - gt_disp-dhcnt + 1.

        DO gt_disp-ndhcnt TIMES. " 의무사용 대휴일수 만큼 대휴보상금액을 '0'으로 " xa30752
          CLEAR: gt_disp-dhamt.
          MODIFY gt_disp INDEX sy-tabix TRANSPORTING dhamt.
          sy-tabix = sy-tabix + 1.
        ENDDO.

      ELSE.

        APPEND gt_disp.
      ENDIF.
    ENDIF.

    CLEAR gt_disp.
  ENDLOOP.



  LOOP AT gt_disp.
    LOOP AT lt_prdty WHERE prdty = gt_disp-prdty
                       AND begda <= gt_disp-begda
                       AND endda >= gt_disp-begda.
      gt_disp-prdtx = lt_prdty-prdtx.
      EXIT.
    ENDLOOP.

    LOOP AT lt_gbnty WHERE gbnty = gt_disp-gbnty
                       AND begda <= gt_disp-begda
                       AND endda >= gt_disp-begda.
      gt_disp-gbntx = lt_gbnty-gbntx.
      EXIT.
    ENDLOOP.

    LOOP AT lt_jobty WHERE jobty = gt_disp-jobty
                       AND begda <= gt_disp-begda
                       AND endda >= gt_disp-begda.
      gt_disp-jobtx = lt_jobty-jobtx.
      EXIT.
    ENDLOOP.

* 부서명/부서순서
*    LOOP AT lt_oinfo WHERE objid = gt_disp-vdsk1
*                       AND begda <= gt_disp-begda
*                       AND endda >= gt_disp-begda.
*      gt_disp-zorder = lt_oinfo-zorder.
*      gt_disp-vdsk1_tx = lt_oinfo-fname.
*      EXIT.
*    ENDLOOP.

    READ TABLE lt_z52wktp INTO ls_z52wktp WITH KEY keyfield = gt_disp-z52wktp.
    IF sy-subrc = 0.
      gt_disp-z52wktp_tx = ls_z52wktp-textfield.
    ENDIF.

    MODIFY gt_disp.
  ENDLOOP.

  SORT gt_disp BY pernr begda zdday.
  DESCRIBE TABLE gt_disp LINES g_line.
ENDFORM.                    " SELECT_DATA
*&---------------------------------------------------------------------*
*&      Form  GET_ZDBEG_ZDEND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_DISP_ZDDAY  text
*      <--P_GT_DISP_ZDBEG  text
*      <--P_GT_DISP_ZDEND  text
*----------------------------------------------------------------------*
FORM get_zdbeg_zdend  USING    p_pernr
                               p_zdday
                      CHANGING p_zdbeg
                               p_zdend.

  DATA: ls_pa0001 TYPE pa0001,
        lv_manager.
  DATA: lv_year(4) TYPE n.

* 대휴 사용일 변경. 익월 1일에서 종료일기준 익월 10일.
  CALL FUNCTION 'HR_IN_LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = p_zdday
    IMPORTING
      last_day_of_month = p_zdbeg
    EXCEPTIONS
      day_in_no_date    = 1
      OTHERS            = 2.

  p_zdbeg = p_zdbeg + 10.

  SELECT SINGLE jikwidung jikwigubun
    INTO (ls_pa0001-jikwidung, ls_pa0001-jikwigubun)
    FROM pa0001
   WHERE pernr = p_pernr
     AND begda <= p_zdday
     AND endda >= p_zdday.

  CALL FUNCTION 'ZHR_GET_MANAGER_TYPE_N'
    EXPORTING
      jikwidung  = ls_pa0001-jikwidung
      jikwigubun = ls_pa0001-jikwigubun
      datum      = p_zdday
    IMPORTING
      m_type     = lv_manager.

  IF lv_manager = 'M'.
*    IF p_zdday+4(2) BETWEEN '01' AND '06'.
*      p_zdend(4) = p_zdday(4) + 1.
*      p_zdend+4(4) = '0630'.
*    ELSE.
*      p_zdend(4) = p_zdday(4) + 1.
*      p_zdend+4(4) = '1231'.
*    ENDIF.
    " 시간외 지침 개정 시행 2019.7.26 부장직 대휴사용기간 6개월 추가(xa30752) 인적자원실-3720 (2019.07.30.)
    IF p_zdday+4(2) <= '06'. "상반기.
      CONCATENATE lv_year
               '1231'
               INTO p_zdend.
    ELSE.                   "하반기.
      lv_year = p_zdday+0(4) + 2.
      CONCATENATE lv_year
               '0630'
               INTO p_zdend.
    ENDIF.


  ELSE.
    IF p_zdday+4(2) BETWEEN '01' AND '06'.
      p_zdend(4) = p_zdday(4).
      p_zdend+4(4) = '1231'.
    ELSE.
      p_zdend(4) = p_zdday(4) + 1.
      p_zdend+4(4) = '0630'.
    ENDIF.
  ENDIF.
ENDFORM.                    " GET_ZDBEG_ZDEND
*&---------------------------------------------------------------------*
*&      Form  GET_ZDBEG_ZDEND_1YEAR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_DISP_ZDDAY  text
*      <--P_GT_DISP_ZDBEG  text
*      <--P_GT_DISP_ZDEND  text
*----------------------------------------------------------------------*
FORM get_zdbeg_zdend_1year  USING    p_pernr
                               p_zdday
                      CHANGING p_zdbeg
                               p_zdend.

  DATA: ls_pa0001 TYPE pa0001,
        lv_manager.
  DATA: lv_year(4) TYPE n.

* 대휴 사용일 변경. 익월 1일에서 종료일기준 익월 10일.
  CALL FUNCTION 'HR_IN_LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = p_zdday
    IMPORTING
      last_day_of_month = p_zdbeg
    EXCEPTIONS
      day_in_no_date    = 1
      OTHERS            = 2.

  p_zdbeg = p_zdbeg + 10.

*  SELECT SINGLE jikwidung jikwigubun
*    INTO (ls_pa0001-jikwidung, ls_pa0001-jikwigubun)
*    FROM pa0001
*   WHERE pernr = p_pernr
*     AND begda <= p_zdday
*     AND endda >= p_zdday.
*
*  CALL FUNCTION 'ZHR_GET_MANAGER_TYPE_N'
*    EXPORTING
*      jikwidung  = ls_pa0001-jikwidung
*      jikwigubun = ls_pa0001-jikwigubun
*      datum      = p_zdday
*    IMPORTING
*      m_type     = lv_manager.
*
*  IF lv_manager = 'M'.
**    IF p_zdday+4(2) BETWEEN '01' AND '06'.
**      p_zdend(4) = p_zdday(4) + 1.
**      p_zdend+4(4) = '0630'.
**    ELSE.
**      p_zdend(4) = p_zdday(4) + 1.
**      p_zdend+4(4) = '1231'.
**    ENDIF.
*      " 시간외 지침 개정 시행 2019.7.26 부장직 대휴사용기간 6개월 추가(xa30752) 인적자원실-3720 (2019.07.30.)
*      IF p_zdday+4(2) <= '06'. "상반기.
*         CONCATENATE lv_year
*                  '0630'
*                  INTO p_zdend.
*      ELSE.                   "하반기.
*         lv_year = p_zdday+0(4) + 2.
*         CONCATENATE lv_year
*                  '1231'
*                  INTO p_zdend.
*      ENDIF.
*
*
*  ELSE.
  IF p_zdday+4(2) BETWEEN '01' AND '06'.
    p_zdend(4) = p_zdday(4) + 1.
    p_zdend+4(4) = '0630'.
  ELSE.
    p_zdend(4) = p_zdday(4) + 1.
    p_zdend+4(4) = '1231'.
  ENDIF.
*  ENDIF.

ENDFORM.                    " GET_ZDBEG_ZDEND
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
   '04' ' ' 'JIKWIDUNG_1' '직급'          'C' ' ',
   '05' ' ' 'Z52WKTP_TX'  '근로유형'      'C' ' ',
   '06' ' ' 'PRDTX'       '제작유형'      'C' ' ',
   '07' ' ' 'GBNTX'       '구분'          'C' ' ',
   '08' ' ' 'JOBTX'       '직무'          'C' ' ',
   '09' ' ' 'BEGDA'       '재량시작일'    'C' ' ',
   '10' ' ' 'ENDDA'       '재량종료일'    'C' ' ',

   '11' ' ' 'DHNUM'       '대휴일수'      'R' ' ',
   '12' ' ' 'DHAMT'       '대휴보상액'    'R' ' ',
   '13' ' ' 'ZDDAY'       '대휴발생일'    'C' ' ',
   '14' ' ' 'ZDBEG'       '사용시작일'    'C' ' ',
   '15' ' ' 'ZDEND'       '사용종료일'    'C' ' '.

  IF p_create = 'X'.
    PERFORM append_init_fieldcat USING
   '16' ' ' 'MSG'      '메세지'      'L' ' '.
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

  IF p_select = 'X'.  "대휴일 조회
    WRITE p_frdat TO l_text1 USING EDIT MASK '____.__.__'.
    WRITE p_todat TO l_text2 USING EDIT MASK '____.__.__'.
    CONCATENATE `검색기간 :`  l_text1 ` ~ ` l_text2 INTO l_text SEPARATED BY space.
  ELSE.
*    WRITE p_kjdat TO l_text1 USING EDIT MASK '____.__.__'.
*    CONCATENATE `기준일자 :`  l_text1 INTO l_text SEPARATED BY space.
    WRITE p_kjdat TO l_text1 USING EDIT MASK '____.__'.
    CONCATENATE `기준월 :`  l_text1 INTO l_text SEPARATED BY space.
  ENDIF.

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

  IF p_create = 'X'.
    ps_interactive-butn_type = 3.
    APPEND ps_interactive TO pr_object->mt_toolbar.

    ps_interactive-function = 'DOWNLOAD'.
    ps_interactive-icon =  icon_xls.
    ps_interactive-butn_type = 0.
    ps_interactive-text = 'Excel Download'.
    APPEND ps_interactive TO pr_object->mt_toolbar.
  ENDIF.
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
        lv_int_dhamt = gt_disp-dhamt * 100.
        gt_data_down-dhamt = lv_int_dhamt.
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

  DATA: lt_handler TYPE REF TO if_hrpa_message_handler.
  DATA: ls_state TYPE hrecm00keyandtext ,
        lt_state TYPE TABLE OF hrecm00keyandtext.


  IF gt_disp[] IS INITIAL.
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

  "상태도메인
  CALL FUNCTION 'HR_ECM_GET_ALL_DOMAIN_VALUE'
    EXPORTING
      domname         = 'ZSTATE_1'
      message_handler = lt_handler
    IMPORTING
      resulttab       = lt_state.


  LOOP AT gt_disp.
    IF gt_disp-zdday IS INITIAL.
      gt_disp-msg = '재량근로 대휴일이 없습니다.'.
      MODIFY gt_disp TRANSPORTING msg.
      CONTINUE.
    ENDIF.

*    IF gt_disp-dhamt IS INITIAL.
*      gt_disp-msg = '재량근로 대휴 보상액이 없습니다.'.
*      MODIFY gt_disp TRANSPORTING msg.
*      CONTINUE.
*    ENDIF.

    "재량근로 대휴저장시 신청일(rdate)은 키의미가 없음
    CLEAR ls_zthrbs01.
    SELECT SINGLE *
      INTO CORRESPONDING FIELDS OF ls_zthrbs01
      FROM zthrbs01
     WHERE pernr = gt_disp-pernr  "사번
       AND rdate = gt_disp-zdday  "신청일
       AND znal = gt_disp-zdday   "근무일
       AND zdday = gt_disp-zdday  "대휴일
       AND zdbeg = gt_disp-zdbeg  "대휴사용 시작일
       AND zdend = gt_disp-zdend  "대휴사용 종료일
       AND zsourflex = 'U'  "입력구분
       AND state = '3'  "상태
       AND zdaeh = 'Y'  "대휴여부
       AND zaccept = 'Y'  "승인여부
       AND zaccept1 = 'Y'.  "승인여부(최종)

    IF sy-subrc = 0.
      lv_opt = 'MOD'.
    ELSE.
      lv_opt = 'INS'.
      "신규이면 seqnr 조회
      SELECT seqnr
        UP TO 1 ROWS
        INTO ls_zthrbs01-seqnr
        FROM zthrbs01
       WHERE pernr = gt_disp-pernr  "사번
         AND rdate = gt_disp-zdday  "sy-datum   "신청일
      ORDER BY seqnr DESCENDING.
      ENDSELECT.

      IF sy-subrc = 0.
        ADD 1 TO ls_zthrbs01-seqnr.
      ENDIF.
    ENDIF.

    "사원정보
    CALL FUNCTION 'ZHR_GET_PERSONNEL_DATA_N'
      EXPORTING
        pernr          = gt_disp-pernr
        znal           = gt_disp-zdday
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

    ls_zthrbs01-pernr = gt_disp-pernr.
    ls_zthrbs01-rdate = gt_disp-zdday.  "sy-datum.
    ls_zthrbs01-state = '3'.
    READ TABLE lt_state INTO ls_state WITH KEY keyfield = '3'.
    IF sy-subrc = 0.
      ls_zthrbs01-state_txt = ls_state-textfield.
    ENDIF.
    ls_zthrbs01-zdaeh = 'Y'.
    ls_zthrbs01-znal = gt_disp-zdday.
    ls_zthrbs01-zaccept = 'Y'.
    ls_zthrbs01-zaccept1 = 'Y'.
    ls_zthrbs01-zdday = gt_disp-zdday.
    ls_zthrbs01-zdbeg = gt_disp-zdbeg.
    ls_zthrbs01-zdend = gt_disp-zdend.
    ls_zthrbs01-zd_money = gt_disp-dhamt * 100. " 재량근로 대휴 발생 기준 변경 xa30752 (2020.06.03)
    ls_zthrbs01-zsourflex = 'U'.
*    ls_zthrbs01-zkno = '1'.
    ls_zthrbs01-aedtm = sy-datum.
    ls_zthrbs01-uname = sy-uname.
    ls_zthrbs01-ertim = sy-uzeit.
    ls_zthrbs01-erdat = sy-datum.
    ls_zthrbs01-ernam = sy-uname.

    CALL FUNCTION 'ZHR_GET_DAY_DATA_N'
      EXPORTING
        znal  = ls_zthrbs01-zdday
      IMPORTING
        zyoil = ls_zthrbs01-zyoil.


    IF lv_opt = 'INS'.
      INSERT zthrbs01 FROM ls_zthrbs01.
    ELSE.
      MODIFY zthrbs01 FROM ls_zthrbs01.
    ENDIF.

    IF sy-subrc = 0.
      COMMIT WORK AND WAIT.
      gt_disp-msg = '재량근로 대휴일이 저장되었습니다.'.
    ELSE.
      ROLLBACK WORK.
      gt_disp-msg = '저장중 오류가 발생했습니다.'.
    ENDIF.

    MODIFY gt_disp TRANSPORTING msg.
  ENDLOOP.
ENDFORM.                    " SAVE_DATA
*&---------------------------------------------------------------------*
*&      Form  DELETE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM delete_data .
  DATA: lv_s_cnt TYPE i,
        lv_e_cnt TYPE i.

  DATA: lt_rows TYPE lvc_t_roid,
        ls_rows TYPE lvc_s_roid.

  DATA: lv_answer TYPE c,
        lv_del_cnt(5),
        ls_zthrbs01 TYPE zthrbs01.


  CALL METHOD g_grid->get_selected_rows
    IMPORTING
      et_row_no = lt_rows.

  IF lt_rows IS INITIAL.
    MESSAGE s001 DISPLAY LIKE 'E'  WITH '삭제할 데이터를 선택하십시오.'.
    EXIT.
  ENDIF.


  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = '확 인'
      text_question         = '삭제하시겠습니까?'
      text_button_1         = '삭 제'
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


  LOOP AT lt_rows INTO ls_rows.
    READ TABLE gt_disp INDEX ls_rows-row_id.
    IF sy-subrc = 0.
      "재량근로 대휴삭제시 신청일(rdate)은 키의미가 없음
      CLEAR ls_zthrbs01.
      SELECT SINGLE *
        INTO CORRESPONDING FIELDS OF ls_zthrbs01
        FROM zthrbs01
       WHERE pernr = gt_disp-pernr  "사번
         AND znal = gt_disp-zdday   "근무일
         AND zdday = gt_disp-zdday  "대휴일
         AND zdbeg = gt_disp-zdbeg  "대휴사용 시작일
         AND zdend = gt_disp-zdend  "대휴사용 종료일
         AND zsourflex = 'U'  "입력구분
         AND state = '3'  "상태
         AND zdaeh = 'Y'  "대휴여부
         AND zaccept = 'Y'  "승인여부
         AND zaccept1 = 'Y'.  "승인여부(최종)

      IF sy-subrc = 0.
        "재량근로 대휴일 생성 키구성은 pernr/rdate/seqnr
        DELETE FROM zthrbs01
         WHERE pernr = ls_zthrbs01-pernr  "사번
           AND rdate = ls_zthrbs01-rdate   "신청일
           AND seqnr = ls_zthrbs01-seqnr.

        IF sy-subrc = 0.
          IF sy-dbcnt = 0.
            gt_disp-msg = '삭제할 재량근로 대휴일이 없습니다.'.
          ELSEIF sy-dbcnt > 1.
            lv_del_cnt = sy-dbcnt.
            CONDENSE lv_del_cnt NO-GAPS.
            CONCATENATE '삭제중 오류가 발생했습니다.(' lv_del_cnt '건 있으므로 확인필용)' INTO gt_disp-msg.
            ROLLBACK WORK.
          ELSE.
            gt_disp-msg = '재량근로 대휴일이 삭제되었습니다.'.
            COMMIT WORK.
          ENDIF.
        ELSE.
          gt_disp-msg = '삭제중 오류가 발생했씁니다.'.
        ENDIF.

      ELSE.
        gt_disp-msg = '삭제할 재량근로 대휴일이 없습니다.'.
      ENDIF.


      MODIFY gt_disp INDEX ls_rows-row_id TRANSPORTING msg.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " DELETE_DATA
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
        ls_zthrbs01 TYPE zthrbs01,
        ls_zdata TYPE zthrbs01,
        ls_pdata TYPE zsh_personnel_data,
        ls_return LIKE bapireturn1,
        lv_opt TYPE actio.

  DATA: BEGIN OF lt_error OCCURS 0.
          INCLUDE TYPE ty_format.
  DATA: msg TYPE bapi_msg,
        END OF lt_error.

  DATA: lv_indx TYPE n LENGTH 2,
        lv_field(20).

  DATA: lt_handler TYPE REF TO if_hrpa_message_handler.
  DATA: ls_state TYPE hrecm00keyandtext ,
        lt_state TYPE TABLE OF hrecm00keyandtext.


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

  "상태도메인
  CALL FUNCTION 'HR_ECM_GET_ALL_DOMAIN_VALUE'
    EXPORTING
      domname         = 'ZSTATE_1'
      message_handler = lt_handler
    IMPORTING
      resulttab       = lt_state.


  LOOP AT lt_tmp.
    ls_zthrbs01-pernr = lt_tmp-name01.
    ls_zthrbs01-zdday = lt_tmp-name12.
    ls_zthrbs01-zd_money = lt_tmp-name11.

    IF ls_zthrbs01-pernr IS INITIAL.
      ADD 1 TO lv_e_cnt.

      CLEAR lt_error.
      MOVE-CORRESPONDING lt_tmp TO lt_error.
      lt_error-msg = '사번이 없습니다.'.
      APPEND lt_error.
      CONTINUE.
    ENDIF.

    IF ls_zthrbs01-zdday IS INITIAL OR ls_zthrbs01-zdday = ''.
      ADD 1 TO lv_e_cnt.

      CLEAR lt_error.
      MOVE-CORRESPONDING lt_tmp TO lt_error.
      lt_error-msg = '재량근로 대휴일이 없습니다.'.
      APPEND lt_error.
      CONTINUE.
    ENDIF.

    IF ls_zthrbs01-zd_money IS INITIAL.
      ADD 1 TO lv_e_cnt.

      CLEAR lt_error.
      MOVE-CORRESPONDING lt_tmp TO lt_error.
      lt_error-msg = '재량근로 대휴 보상액이 없습니다.'.
      APPEND lt_error.
      CONTINUE.
    ENDIF.

    "재량근로 대휴저장시 신청일(rdate)은 키의미가 없음
    CLEAR ls_zthrbs01.
    SELECT SINGLE *
      INTO CORRESPONDING FIELDS OF ls_zthrbs01
      FROM zthrbs01
     WHERE pernr = lt_tmp-name01 "사번
       AND znal = lt_tmp-name12   "근무일
       AND zdday = lt_tmp-name12  "대휴일
       AND zdbeg = lt_tmp-name13  "대휴사용 시작일
       AND zdend = lt_tmp-name14  "대휴사용 종료일
       AND zsourflex = 'U'  "입력구분
       AND state = '3'  "상태
       AND zdaeh = 'Y'  "대휴여부
       AND zaccept = 'Y'  "승인여부
       AND zaccept1 = 'Y'.  "승인여부(최종)

    IF sy-subrc = 0.
      lv_opt = 'MOD'.
    ELSE.
      lv_opt = 'INS'.
      "신규이면 seqnr 조회
      SELECT seqnr
        UP TO 1 ROWS
        INTO ls_zthrbs01-seqnr
        FROM zthrbs01
       WHERE pernr = gt_disp-pernr  "사번
         AND rdate = sy-datum   "신청일
      ORDER BY seqnr DESCENDING.
      ENDSELECT.

      IF sy-subrc = 0.
        ADD 1 TO ls_zthrbs01-seqnr.
      ENDIF.
    ENDIF.

    ls_zthrbs01-pernr = lt_tmp-name01.
    ls_zthrbs01-rdate = sy-datum.
    ls_zthrbs01-state = '3'.
    READ TABLE lt_state INTO ls_state WITH KEY keyfield = '3'.
    IF sy-subrc = 0.
      ls_zthrbs01-state_txt = ls_state-textfield.
    ENDIF.
    ls_zthrbs01-zdaeh = 'Y'.
    ls_zthrbs01-znal = lt_tmp-name12.
    ls_zthrbs01-zaccept = 'Y'.
    ls_zthrbs01-zaccept1 = 'Y'.
    ls_zthrbs01-zdday = lt_tmp-name12.
    ls_zthrbs01-zdbeg = lt_tmp-name13.
    ls_zthrbs01-zdend = lt_tmp-name14.
    ls_zthrbs01-zd_money = lt_tmp-name11.
    ls_zthrbs01-zsourflex = 'U'.
*    ls_zthrbs01-zkno = '1'.
    ls_zthrbs01-aedtm = sy-datum.
    ls_zthrbs01-uname = sy-uname.
    ls_zthrbs01-ertim = sy-uzeit.
    ls_zthrbs01-erdat = sy-datum.
    ls_zthrbs01-ernam = sy-uname.

    "사원정보
    CALL FUNCTION 'ZHR_GET_PERSONNEL_DATA_N'
      EXPORTING
        pernr          = ls_zthrbs01-pernr
        znal           = ls_zthrbs01-znal
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
    ls_zthrbs01-zgl01 = ls_zdata-zgl01.

    "일자정보
    CALL FUNCTION 'ZHR_GET_DAY_DATA_N'
      EXPORTING
        znal   = ls_zthrbs01-zdday
      IMPORTING
        daytxt = ls_zthrbs01-zyoil.


    IF lv_opt = 'INS'.
      INSERT zthrbs01 FROM ls_zthrbs01.
    ELSE.
      MODIFY zthrbs01 FROM ls_zthrbs01.
    ENDIF.

    IF sy-subrc <> 0.
      ADD 1 TO lv_e_cnt.

      CLEAR lt_error.
      MOVE-CORRESPONDING lt_tmp TO lt_error.
      lt_error-msg = '저장중 오류가 발생했습니다.'.
      APPEND lt_error.
      CONTINUE.
    ENDIF.

    ADD 1 TO lv_s_cnt.
  ENDLOOP.

  IF lv_e_cnt = 0.
    MESSAGE s001 DISPLAY LIKE 'S'  WITH lv_s_cnt '건 등록되었습니다.'.
  ELSE.
    READ TABLE gt_title WITH KEY text = '오류 메세지'.
    IF sy-subrc <> 0.
      gt_title-text = '오류 메세지'.
      APPEND gt_title.
    ENDIF.

    LOOP AT gt_title.
      ASSIGN COMPONENT sy-tabix OF STRUCTURE lt_error TO <fs>.
      <fs> = gt_title-text.
    ENDLOOP.
    INSERT lt_error INDEX 1.


    CALL FUNCTION 'SAP_CONVERT_TO_XLS_FORMAT'
      EXPORTING
        i_filename        = 'C:\BDC ERROR\ZTHRBS01_ERROR.XLSX'
        i_line_header     = 'X'
      TABLES
        i_tab_sap_data    = lt_error
      EXCEPTIONS
        conversion_failed = 1.

    MESSAGE s001 DISPLAY LIKE 'S'  WITH lv_s_cnt '건 등록,' lv_e_cnt '건 오류(C:\BDC ERROR\ZTHRBS01_ERROR.XLSX 파일확인)'.
  ENDIF.
ENDFORM.                    " UPLOAD_DATA
