*&---------------------------------------------------------------------*
*&  Include           LZHR008_3F03
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  R_CW_PROCESS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_PERNR  text
*      -->P_I_DATUM  text
*      <--P_CS_ZTHR0112  text
*      <--P_E_RETURN  text
*----------------------------------------------------------------------*
FORM r_cw_process_data  USING    pv_pernr
                                 pv_tdcost
                                 pv_datum
                        CHANGING ps_zshr0141 TYPE zshr0141
                                 ps_return TYPE bapireturn1.


  DATA: lt_zshr0111 TYPE TABLE OF zshr0111 WITH HEADER LINE,
        ls_tmp TYPE zshr0141,
        ls_zshr0139 TYPE zshr0139,
        lv_text(50),
        lv_chk.

  MOVE-CORRESPONDING ps_zshr0141 TO ls_tmp.
  CLEAR ps_zshr0141.

  "실적
  SELECT SINGLE *
    INTO CORRESPONDING FIELDS OF ps_zshr0141
    FROM zthr0112
   WHERE pernr = ls_tmp-pernr
     AND datum = ls_tmp-datum  "근무일
     AND begda = ls_tmp-begda
     AND endda = ls_tmp-endda
     AND z52wktp = ls_tmp-z52wktp
     AND z52prsq = ls_tmp-z52prsq
     AND seqnr = ls_tmp-seqnr.

  IF sy-subrc = 0.
    "총근무시간/의무휴계시간/총휴계시간
    PERFORM d_cw_get_data USING pv_pernr
                                ps_zshr0141
                          CHANGING ls_zshr0139
                                   ps_return.

    ps_zshr0141-zdmwk_tm = ls_zshr0139-zdmwk_tm.

    "결재자 부서
    lv_text = zcl_cm_util_dev=>get_vdstext( i_pernr = ps_zshr0141-zcosa ).
    ps_zshr0141-corgtx = lv_text.
    "결재자 직위
    lv_text = zcl_cm_util_dev=>get_jikwitext( i_pernr = ps_zshr0141-zcosa ).
    CONCATENATE ps_zshr0141-corgtx lv_text INTO ps_zshr0141-corgtx SEPARATED BY space.


    "4. 근태내역
    CALL FUNCTION 'ZHR_52TM_AWART_LIST'
      EXPORTING
        i_pernr    = pv_pernr
        i_begda    = ps_zshr0141-datum
        i_endda    = ps_zshr0141-datum
        i_zsangsin = 'X'
      TABLES
        t_data     = lt_zshr0111.

    LOOP AT lt_zshr0111 WHERE datum = ps_zshr0141-datum
                          AND ( zabsdayty = 'A' OR zabsdayty = 'P' )
                          AND zstat = 'A'. " 결재승인완료건만 조회

      ps_zshr0141-awart = lt_zshr0111-awart.
      CASE lt_zshr0111-awart.
        WHEN '1012'.
          ps_zshr0141-atext = '연차'.
        WHEN '1013' OR '1015'.
          ps_zshr0141-atext = '반차'.
        WHEN OTHERS.
          ps_zshr0141-atext = lt_zshr0111-atext.
      ENDCASE.

      EXIT.
    ENDLOOP.

    "시차대상자
    CALL FUNCTION 'ZHR_52TM_EARLIER_WORKER'
      EXPORTING
        i_pernr = pv_pernr
        i_date  = ps_zshr0141-datum
      IMPORTING
        e_chk   = lv_chk.
    IF lv_chk = 'X'.
      ps_zshr0141-wktype = '시차근무'.
    ENDIF.

    CALL FUNCTION 'ZHR_52TM_CHECK_ZEMCWK'
      EXPORTING
        i_pernr  = pv_pernr
        i_datum  = ps_zshr0141-datum
      IMPORTING
        e_zemcwk = ps_zshr0141-zemcwk_e.

    " 시차실비가 금액이 0이 아니면 시차근무 표시
*    IF ps_zshr0141-tdcost NE 0.
*      ps_zshr0141-tdcost_yn = 'X'.
*    ENDIF.

    IF ps_zshr0141-zemcwk_e = ''.  "재난이 비활성이면 기존꺼 클리어
      CLEAR ps_zshr0141-zemcwk.
    ENDIF.
  ENDIF.

  ps_return-type = c_success.
ENDFORM.                    " R_CW_PROCESS_DATA
*&---------------------------------------------------------------------*
*&      Form  S_CW_PROCESS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_PERNR  text
*      -->P_I_DATUM  text
*      <--P_CS_ZSHR0141  text
*      <--P_E_RETURN  text
*----------------------------------------------------------------------*
FORM s_cw_process_data
  USING pv_tdcost
  CHANGING ps_zshr0141 TYPE zshr0141
                                 pv_case
                                 ps_return TYPE bapireturn1.

  DATA: lv_zovrngt TYPE zthr0112-zovrngt,
        lv_state TYPE zthr0112-state,
        lv_nextdt TYPE dats,
        ls_fromweb TYPE zshr0141,
        ls_data TYPE zshr0141,
        ls_insert TYPE zthr0112,
        lt_insert TYPE TABLE OF zthr0112.


  MOVE-CORRESPONDING ps_zshr0141 TO ls_fromweb.

  IF pv_case = 'S'.
    "근무시간 체크
    PERFORM f_cw_check_data USING ps_zshr0141
                            CHANGING ps_return.
    CHECK ps_return-type = c_success.

    "휴계시간 체크
    PERFORM g_cw_check_data USING ls_fromweb
                            CHANGING ps_return.
    CHECK ps_return-type = c_success.
  ENDIF.

  "결재자 체크 및 ZCID 리턴
  PERFORM e_cw_check_data CHANGING ps_zshr0141
                                   ps_return.
  CHECK ps_return-type = c_success.

  "근무일자 중복여부 체크, 근무시간 체크, 당번이면 대휴체크(신규이면서 당번)
  PERFORM h_cw_check_data USING ps_zshr0141
                                'S'
                          CHANGING ps_return.
  CHECK ps_return-type = c_success.

  IF pv_case = 'S'.
    "실적항목 생성
    CALL FUNCTION 'ZHR_52TM_CW_SET_ITEM'
      EXPORTING
        i_pernr     = ps_zshr0141-pernr
        is_data     = ps_zshr0141
        tdcost      = pv_tdcost
      IMPORTING
        e_return    = ps_return
      CHANGING
        cs_zshr0141 = ls_data.

    IF ls_data-tdcost NE 0.
      ps_zshr0141-tdcost = ls_data-tdcost.
    ENDIF.

    "실적항목 생성후 체크 -> 소정근로시간 소진 및 연장(가능)시간 초과 메세지
    PERFORM d_cw_check_data USING ls_data-pernr
                                  ls_data-datum
                                  ls_data
                            CHANGING ps_return.
    CHECK ps_return-type = c_success.
  ELSE.  "선택휴무
    MOVE-CORRESPONDING ps_zshr0141 TO ls_data.
  ENDIF.


  IF ls_data-zovrngt = 'X'.  "당번특근인 경우
    PERFORM make_ovrngt_data TABLES lt_insert
                             USING pv_tdcost
                             CHANGING ps_zshr0141
                                      ps_return.

    IF ps_return-type = c_error.
      RETURN.
    ENDIF.
  ELSE.  "당번특근이 아닌경우
    "ZCID값 지정
    ls_data-zcid = ps_zshr0141-zcid.
    "신규 seqnr
    PERFORM get_seqnr CHANGING ls_data.
    "상태
    ls_data-state = '0'.
    PERFORM set_state_text USING ls_data-state
                           CHANGING ls_data-state_txt.
    "변경자
    PERFORM set_change_info USING 'INS' CHANGING ls_data.

    MOVE-CORRESPONDING ls_data TO ls_insert.

    "SEQNR, ERDAT, ERZET, ERNAM WEB에 리턴해준다.
    ps_zshr0141-seqnr = ls_insert-seqnr.
    ps_zshr0141-erdat = ls_insert-erdat.
    ps_zshr0141-erzet = ls_insert-erzet.
    ps_zshr0141-ernam = ls_insert-ernam.

    APPEND ls_insert TO lt_insert.
    CLEAR ls_insert.

  ENDIF.



  IF lt_insert IS NOT INITIAL.
    "기존 데이터 조회
    SELECT SINGLE zovrngt state
      INTO (lv_zovrngt, lv_state)
      FROM zthr0112
     WHERE pernr = ls_fromweb-pernr
       AND datum = ls_fromweb-datum
       AND begda = ls_fromweb-begda
       AND endda = ls_fromweb-endda
       AND z52wktp = ls_fromweb-z52wktp
       AND z52prsq = ls_fromweb-z52prsq
       AND seqnr = ls_fromweb-seqnr.

    IF sy-subrc = 0.
      "회수 데이터를 저장 할때 기존 데이터는 삭제로 바꾸고 신규로 저장
      IF lv_state = '5'.  "회수
        UPDATE zthr0112
           SET state = '2'
               state_txt = '삭제'
               aedat = sy-datum
               aezet = sy-uzeit
               aenam = sy-uname
         WHERE pernr = ls_fromweb-pernr
           AND datum = ls_fromweb-datum
           AND begda = ls_fromweb-begda
           AND endda = ls_fromweb-endda
           AND z52wktp = ls_fromweb-z52wktp
           AND z52prsq = ls_fromweb-z52prsq
           AND seqnr = ls_fromweb-seqnr.
      ELSE.  "신규 저장 할때
        "자신 데이터 삭제
        DELETE FROM zthr0112
         WHERE pernr = ls_fromweb-pernr
           AND datum = ls_fromweb-datum
           AND begda = ls_fromweb-begda
           AND endda = ls_fromweb-endda
           AND z52wktp = ls_fromweb-z52wktp
           AND z52prsq = ls_fromweb-z52prsq
           AND seqnr = ls_fromweb-seqnr.


        "당번특근이었으면 익일당번특근 데이터 삭제
        IF lv_zovrngt = 'X'.
          lv_nextdt = ls_fromweb-datum + 1.

          DELETE FROM zthr0112
           WHERE pernr = ls_fromweb-pernr
             AND datum = lv_nextdt
             AND begda = ls_fromweb-begda
             AND endda = ls_fromweb-endda
             AND z52wktp = ls_fromweb-z52wktp
             AND z52prsq = ls_fromweb-z52prsq
             AND seqnr = ls_fromweb-seqnr2.
        ENDIF.
      ENDIF.
    ENDIF.

    INSERT zthr0112 FROM TABLE lt_insert.
  ENDIF.


  ps_return-type = c_success.

ENDFORM.                    " S_CW_PROCESS_DATA
*&---------------------------------------------------------------------*
*&      Form  GET_CALC_OTHER_TIME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PV_PERNR  text
*      -->P_PS_ZSHR0141  text
*      <--P_LS_ZTHR0112_ZPRSDWK_TM  text
*      <--P_LS_ZTHR0112_ZADTWK_TM  text
*----------------------------------------------------------------------*
FORM get_calc_other_time  USING    pv_pernr
                                  ps_zshr0141 TYPE zshr0141
                         CHANGING pv_zprsdwk_tm
                                  pv_zadtwk_tm.

  DATA: lt_zshr0111 TYPE TABLE OF zshr0111 WITH HEADER LINE,
        lv_min TYPE i,
        lv_zprsdwk_min TYPE i,
        lv_zadtwk_min TYPE i,
        lv_zrlholwk_min TYPE i.


  CALL FUNCTION 'ZHR_52TM_AWART_LIST'
    EXPORTING
      i_pernr    = pv_pernr
      i_begda    = ps_zshr0141-datum
      i_endda    = ps_zshr0141-datum
      i_zsangsin = 'X'
    TABLES
      t_data     = lt_zshr0111.

  LOOP AT lt_zshr0111 WHERE zstat = 'A' AND ( zabsdayty = 'A' OR zabsdayty = 'P' OR zabsdayty = 'H' ).
    PERFORM convert_time_to_min USING lt_zshr0111-zprsdwk_tm
                                CHANGING lv_min.

    IF lt_zshr0111-zabsdayty = 'A'.  "인정근로시간
      lv_zprsdwk_min = lv_zprsdwk_min + lv_min.
    ELSEIF lt_zshr0111-zabsdayty = 'P'.  "근로시간(근태)
      IF lt_zshr0111-zprsdwk_tm IS NOT INITIAL.
        lv_zadtwk_min = lv_zadtwk_min + lv_min.
      ENDIF.
*    ELSEIF lt_zshr0111-zabsdayty = 'H'.  "주중공휴일시간
*      IF lt_zshr0111-zprsdwk_tm IS NOT INITIAL.
*        lv_zrlholwk_min = lv_zrlholwk_min + lv_min.
*      ENDIF.
    ENDIF.
  ENDLOOP.

  "인정근로 분->TIME 변환
  PERFORM convert_min_to_time USING lv_zprsdwk_min
                              CHANGING pv_zprsdwk_tm.

  "근로시간(근태) 분->TIME 변환
  PERFORM convert_min_to_time USING lv_zadtwk_min
                              CHANGING pv_zadtwk_tm.

*  "주중공휴일 분->TIME 변환
*  PERFORM convert_min_to_time USING lv_zrlholwk_min
*                              CHANGING pv_zrlholwk_tm.
ENDFORM.                    " GET_CALC_OTHER_TIME
*&---------------------------------------------------------------------*
*&      Form  GET_CALC_ZRLNGTWK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PV_PERNR  text
*      -->P_PS_ZSHR0141  text
*      <--P_LS_ZTHR0112_ZRLNGTWK_TM  text
*----------------------------------------------------------------------*
FORM get_calc_zrlngtwk  USING    pv_pernr
                            ps_zshr0141 TYPE zshr0141
                   CHANGING pv_zrlngtwk_tm.

  DATA: lv_zbegtm TYPE times,
        lv_zendtm TYPE times.

  lv_zbegtm = ps_zshr0141-zbegtm.
  lv_zendtm = ps_zshr0141-zendtm.
  IF ps_zshr0141-ztomo IS NOT INITIAL.
    lv_zendtm = '240000'.
  ENDIF.

  IF lv_zendtm BETWEEN '220000' AND '240000'.
    IF lv_zbegtm < '220000'.
      lv_zbegtm = '220000'.
    ENDIF.

    CALL FUNCTION 'ZHR_MINUS_TIME_N'
      EXPORTING
        time1    = lv_zbegtm
        time2    = lv_zendtm
      IMPORTING
        time_dif = pv_zrlngtwk_tm.
  ENDIF.
ENDFORM.                    " GET_CALC_ZRLNGTWK
*&---------------------------------------------------------------------*
*&      Form  GET_CALC_ZRLHOLWK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PV_PERNR  text
*      -->P_PS_ZSHR0141  text
*      <--P_LS_ZTHR0112_ZRLHOLWK_TM  text
*----------------------------------------------------------------------*
FORM get_calc_zrlholwk  USING    pv_pernr
                             ps_zshr0141 TYPE zshr0141
                    CHANGING pv_zrlholwk_tm.

  DATA: lt_attributes TYPE TABLE OF casdayattr WITH HEADER LINE,
        lv_ex_days   TYPE i,
        lv_ex_time   TYPE t.   " 반드시 TIME형이어야 함.

  CALL FUNCTION 'DAY_ATTRIBUTES_GET'
    EXPORTING
      factory_calendar           = 'KR'
      holiday_calendar           = 'KB'
      date_from                  = ps_zshr0141-datum
      date_to                    = ps_zshr0141-datum
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
  IF sy-subrc = 0.
    IF lt_attributes-freeday = 'X'.

      CALL FUNCTION 'SCOV_TIME_DIFF_46B'
        EXPORTING
          im_date1 = ps_zshr0141-datum
          im_date2 = ps_zshr0141-datum
          im_time1 = ps_zshr0141-zbegtm
          im_time2 = ps_zshr0141-zendtm
        IMPORTING
          ex_days  = lv_ex_days
          ex_time  = pv_zrlholwk_tm.

      IF lv_ex_days = 1 OR ( ps_zshr0141-zbegtm = '000000' AND ps_zshr0141-zendtm = '240000' ).
        pv_zrlholwk_tm+0(2) = pv_zrlholwk_tm+0(2) + '24'.
      ENDIF.

    ENDIF.
  ENDIF.
ENDFORM.                    " GET_CALC_ZRLHOLWK
*&---------------------------------------------------------------------*
*&      Form  GET_CALC_TDCOST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PV_PERNR  text
*      -->P_PS_ZSHR0141  text
*      <--P_LS_ZTHR0112_ZCOST  text
*----------------------------------------------------------------------*
FORM get_calc_tdcost  USING    pv_pernr temp_tdcost
                              ps_zshr0141 TYPE zshr0141
                              ps_zshr0143 TYPE zshr0143
                     CHANGING pv_tdcost.

  DATA: lv_chk,
        lv_date TYPE dats,
        lt_holidays TYPE TABLE OF iscal_day,
        check_nextday LIKE ps_zshr0141-datum,
        lv_nextday_holiday TYPE cind.

  CLEAR pv_tdcost.

  "당번특근은 시차발생하지 않음.
  CHECK ps_zshr0141-zovrngt IS INITIAL.

  CALL FUNCTION 'ZHR_52TM_EARLIER_WORKER'
    EXPORTING
      i_pernr = pv_pernr
      i_date  = ps_zshr0141-datum
    IMPORTING
      e_chk   = lv_chk.

  IF lv_chk = 'X'.
    "근무일이 휴일인제 체크
    CALL FUNCTION 'HOLIDAY_GET'
      EXPORTING
        holiday_calendar = 'KB'
        factory_calendar = 'KR'
        date_from        = ps_zshr0141-datum
        date_to          = ps_zshr0141-datum
      TABLES
        holidays         = lt_holidays.

    check_nextday = ps_zshr0141-datum + 1.

    CALL FUNCTION 'ZHR_GET_DAY_DATA'
      EXPORTING
        znal    = check_nextday" 근무 종료일
      IMPORTING
        holiday = lv_nextday_holiday.

    IF lt_holidays IS INITIAL.
      IF ( ps_zshr0141-zbegtm <= '070000' AND ps_zshr0141-zrlwk_tm >= '070000' ) OR
         ( ( ps_zshr0141-zendtm >= '220000' OR ps_zshr0141-zendtm <= ps_zshr0141-zbegtm ) AND ps_zshr0141-zrlwk_tm >= '070000' ).

        IF temp_tdcost = 'X'.
          pv_tdcost = '120'.
        ELSE.
          CLEAR pv_tdcost.
        ENDIF.


************************ 평휴의 경우 07시 이후 출근 시 시차실비 발생. 오류 수정. xa30752 2019.12.06
        IF ps_zshr0141-zbegtm > '070000' AND ps_zshr0141-ztomo = 'X' AND lv_nextday_holiday NE ''.
          CLEAR pv_tdcost.

        ENDIF.
*******************************************************************************************
        "단, 익일 근무하고 07시 이후 퇴근 시 시차실비 미발생
        IF ps_zshr0141-zendtm >= '070000' AND ps_zshr0141-ztomo = 'X'.
          CLEAR pv_tdcost.
        ENDIF.
      ENDIF.
    ENDIF.


*    "익일선택
*    IF ps_zshr0141-ztomo IS NOT INITIAL.
*      "7시간 이상 근무
*      IF ps_zshr0141-zrlwk_tm >= '070000'.
*        lv_date = ps_zshr0141-datum + 1.
*        "익일이 휴일인제 체크
*        CALL FUNCTION 'HOLIDAY_GET'
*          EXPORTING
*            holiday_calendar = 'KB'
*            factory_calendar = 'KR'
*            date_from        = lv_date
*            date_to          = lv_date
*          TABLES
*            holidays         = lt_holidays.
*        "휴일이 아니면 시차실비 발생
*        IF NOT lt_holidays IS INITIAL.
*          pv_zcost = 120.
*        ENDIF.
*      ENDIF.
*    ELSE.  "익일선택 아니고
*      "시작시간이 7시 이전 또는 종료시간이 22시 이후
*      IF ( ps_zshr0141-zbegtm < '070000' OR ps_zshr0141-zendtm >= '220000' ).
*        "7시간 이상 근무
*        IF ps_zshr0141-zrlwk_tm >= '070000'.
*          "근무일 휴일인제 체크
*          CALL FUNCTION 'HOLIDAY_GET'
*            EXPORTING
*              holiday_calendar = 'KB'
*              factory_calendar = 'KR'
*              date_from        = ps_zshr0141-datum
*              date_to          = ps_zshr0141-datum
*            TABLES
*              holidays         = lt_holidays.
*          "휴일이 아니면 시차실비 발생
*          IF NOT lt_holidays IS INITIAL.
*            pv_zcost = 120.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    ENDIF.
  ENDIF.

ENDFORM.                    " GET_CALC_TDCOST
*&---------------------------------------------------------------------*
*&      Form  GET_SEQNR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PS_ZSHR0141  text
*      <--P_LS_DATA_SEQNR  text
*----------------------------------------------------------------------*
FORM get_seqnr  CHANGING    ps_zshr0141 TYPE zshr0141.


  "신규
  SELECT MAX( seqnr )
    INTO ps_zshr0141-seqnr
    FROM zthr0112
   WHERE pernr = ps_zshr0141-pernr
     AND datum = ps_zshr0141-datum
     AND begda = ps_zshr0141-begda
     AND endda = ps_zshr0141-endda
     AND z52wktp = ps_zshr0141-z52wktp
     AND z52prsq = ps_zshr0141-z52prsq.

  ADD 1 TO ps_zshr0141-seqnr.

ENDFORM.                    " GET_SEQNR
*&---------------------------------------------------------------------*
*&      Form  D_CW_PROCESS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_PERNR  text
*      -->P_CS_ZSHR0141  text
*      <--P_E_RETURN  text
*----------------------------------------------------------------------*
FORM d_cw_process_data  CHANGING ps_zshr0141 TYPE zshr0141
                                 ps_return TYPE bapireturn1.

  DATA: lt_delete TYPE TABLE OF zthrbs01 WITH HEADER LINE,
        lv_zdbeg TYPE dats,
        lv_zdend TYPE dats.

  "실적
  SELECT SINGLE *
    INTO CORRESPONDING FIELDS OF ps_zshr0141
    FROM zthr0112
   WHERE pernr = ps_zshr0141-pernr
     AND datum = ps_zshr0141-datum
     AND begda = ps_zshr0141-begda
     AND endda = ps_zshr0141-endda
     AND z52wktp = ps_zshr0141-z52wktp
     AND z52prsq = ps_zshr0141-z52prsq
     AND seqnr = ps_zshr0141-seqnr.


  IF ps_zshr0141-state = '3' OR ps_zshr0141-state = '5' OR
     ps_zshr0141-state = '9' OR ps_zshr0141-state = 'F'.
    IF ps_zshr0141-state = '3' AND ps_zshr0141-zapprdt IS NOT INITIAL.
      "삭제기간체크
      CALL FUNCTION 'ZHR_52TM_VALID_DATE_CHECK'
        EXPORTING
          i_pernr  = ps_zshr0141-pernr
*          i_date   = ps_zshr0141-zapprdt "결재기한 체크 기준일을 결재상신일에서 근무일로 변경 20190904 임재하.
          i_date   = ps_zshr0141-datum
*          i_opt    = 'C'
          i_ztomo  = ps_zshr0141-ztomo
        IMPORTING
          e_return = ps_return.

      IF ps_return IS NOT INITIAL.
        RETURN.
      ENDIF.

      "대휴사용여부 체크
      IF ps_zshr0141-zdaeh = 'X'.
        "사용시작일/사용종료일
        PERFORM get_zdbeg_zdend IN PROGRAM zrpth409
                                USING ps_zshr0141-pernr
                                      ps_zshr0141-endda  "기준일
                                CHANGING lv_zdbeg
                                         lv_zdend.

        SELECT *
          INTO CORRESPONDING FIELDS OF TABLE lt_delete
          FROM zthrbs01
         WHERE pernr = ps_zshr0141-pernr  "사번
           AND rdate = ps_zshr0141-datum  "신청일
*              AND znal = pv_zdday   "근무일
*              AND zdday = pv_zdday  "대휴일
           AND zdbeg = lv_zdbeg  "대휴사용 시작일
           AND zdend = lv_zdend  "대휴사용 종료일
           AND zsourflex = 'S'  "입력구분(선택)
           AND state = '3'  "상태
           AND zdaeh = 'Y'  "대휴여부
           AND zaccept = 'Y'  "승인여부
           AND zaccept1 = 'Y'.  "승인여부(최종)

        IF sy-subrc = 0.
          READ TABLE lt_delete WITH KEY zdchk = 'Y'.
          IF sy-subrc = 0.
            ps_return-type = c_error.
            ps_return-message = text-m12.
            RETURN.
          ENDIF.
        ENDIF.

        "대휴삭제
        IF lt_delete IS NOT INITIAL.
          DELETE zthrbs01 FROM TABLE lt_delete.
        ENDIF.
      ENDIF.
    ENDIF.

    UPDATE zthr0112
       SET state = '2'
           state_txt = '삭제'
           aedat = sy-datum
           aezet = sy-uzeit
           aenam = sy-uname
     WHERE pernr = ps_zshr0141-pernr
       AND datum = ps_zshr0141-datum
       AND begda = ps_zshr0141-begda
       AND endda = ps_zshr0141-endda
       AND z52wktp = ps_zshr0141-z52wktp
       AND z52prsq = ps_zshr0141-z52prsq
       AND seqnr = ps_zshr0141-seqnr.
  ELSE.
    DELETE FROM zthr0112
     WHERE pernr = ps_zshr0141-pernr
       AND datum = ps_zshr0141-datum
       AND begda = ps_zshr0141-begda
       AND endda = ps_zshr0141-endda
       AND z52wktp = ps_zshr0141-z52wktp
       AND z52prsq = ps_zshr0141-z52prsq
       AND seqnr = ps_zshr0141-seqnr.
  ENDIF.

ENDFORM.                    " D_CW_PROCESS_DATA
*&---------------------------------------------------------------------*
*&      Form  A_CW_PROCESS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_CS_ZSHR0141  text
*      <--P_E_RETURN  text
*----------------------------------------------------------------------*
FORM a_cw_process_data  CHANGING ps_zshr0141 TYPE zshr0141
                                 ps_return TYPE bapireturn1.

  DATA: lv_key12 TYPE sww_wiid,
        lt_seq TYPE TABLE OF zswf0001 WITH HEADER LINE.

  SELECT SINGLE *
    INTO CORRESPONDING FIELDS OF ps_zshr0141
    FROM zthr0112
   WHERE pernr = ps_zshr0141-pernr
     AND datum = ps_zshr0141-datum
     AND begda = ps_zshr0141-begda
     AND endda = ps_zshr0141-endda
     AND z52wktp = ps_zshr0141-z52wktp
     AND z52prsq = ps_zshr0141-z52prsq
     AND seqnr = ps_zshr0141-seqnr.

  IF ps_zshr0141-state <> '0'.
    ps_return-type = c_error.
    ps_return-message = text-m13.
    RETURN.
  ENDIF.

  "결재상신 시 가능일 체크 2020.01.21 xa30752  추가
  CALL FUNCTION 'ZHR_52TM_VALID_DATE_CHECK'
    EXPORTING
      i_pernr  = ps_zshr0141-pernr
      i_date   = ps_zshr0141-datum
*      i_opt    = lv_opt
      i_ztomo  = ps_zshr0141-ztomo
    IMPORTING
      e_return = ps_return.

  IF sy-subrc = 0.
    IF ps_return-type = 'E'.
      RETURN.
    ENDIF.
  ENDIF.

  "상태
  ps_zshr0141-state = 'E'.  "결재상신
  PERFORM set_state_text USING ps_zshr0141-state
                         CHANGING ps_zshr0141-state_txt.

*  "소정근로시간 소진 및 연장(가능)시간 초과, 총근로시간 초과 메세지
*  PERFORM d_cw_check_data USING ps_zshr0141-pernr
*                                ps_zshr0141-datum
*                                ps_zshr0141
*                          CHANGING ps_return.
*  CHECK ps_return-type = c_success.

  "결재자 체크
  PERFORM e_cw_check_data CHANGING ps_zshr0141
                                   ps_return.
  CHECK ps_return-type = c_success.

  "W/F키
  PERFORM set_seq TABLES lt_seq
                   USING ps_zshr0141.

  CALL FUNCTION 'ZWF_START_WORK_HR'
    EXPORTING
      zwftype            = 'E'
    IMPORTING
      key12              = lv_key12
    TABLES
      seq                = lt_seq
    EXCEPTIONS
      error_get_number   = 1
      error_wf_start     = 2
      error_not_input_it = 3
      error_id           = 4
      OTHERS             = 5.

  IF sy-subrc = 0.
    UPDATE zthr0112
       SET state = ps_zshr0141-state
           state_txt = ps_zshr0141-state_txt
           zserial = lv_key12
           reqdt = sy-datum
           aedat = sy-datum
           aezet = sy-uzeit
           aenam = sy-uname
     WHERE pernr = ps_zshr0141-pernr
       AND datum = ps_zshr0141-datum
       AND begda = ps_zshr0141-begda
       AND endda = ps_zshr0141-endda
       AND z52wktp = ps_zshr0141-z52wktp
       AND z52prsq = ps_zshr0141-z52prsq
       AND seqnr = ps_zshr0141-seqnr.
  ELSE.
    ps_return-type    = c_error.
    ps_return-message = text-m15.
    RETURN.
  ENDIF.

ENDFORM.                    " A_CW_PROCESS_DATA
*&---------------------------------------------------------------------*
*&      Form  SET_SEQ
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_SEQ  text
*      -->P_LS_ZTHR0112  text
*----------------------------------------------------------------------*
FORM set_seq  TABLES   pt_seq STRUCTURE zswf0001
              USING    ps_zshr0141 TYPE zshr0141.

  DATA lv_ename TYPE emnam.

  REFRESH pt_seq.

  SELECT SINGLE ename
    INTO lv_ename
    FROM pa0001
   WHERE pernr = ps_zshr0141-pernr
     AND begda <= ps_zshr0141-datum
     AND endda >= ps_zshr0141-datum.

  "상신자
  CLEAR pt_seq." 상신자
  pt_seq-zordr = '0'.
  pt_seq-code  = '0'.
  pt_seq-bname = ps_zshr0141-pernr.

  IF pt_seq-bname(3)  = '000'.
    pt_seq-bname = pt_seq-bname+3(5).
  ENDIF.

  pt_seq-name1 = lv_ename.
  pt_seq-pernr = ps_zshr0141-pernr.
  APPEND pt_seq.

  "1차결재자
  CLEAR pt_seq.
  pt_seq-zordr = '1'.
  pt_seq-code  = '1'.
  pt_seq-bname = ps_zshr0141-zcid.
  pt_seq-name1 = ps_zshr0141-zcope.
  pt_seq-pernr = ps_zshr0141-zcosa.
  APPEND pt_seq.
ENDFORM.                    " SET_SEQ
*&---------------------------------------------------------------------*
*&      Form  B_CW_PROCESS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_CS_ZSHR0141  text
*      <--P_E_RETURN  text
*----------------------------------------------------------------------*
FORM b_cw_process_data  CHANGING ps_zshr0141 TYPE zshr0141
                                 ps_return TYPE bapireturn1.

  SELECT SINGLE *
    INTO CORRESPONDING FIELDS OF ps_zshr0141
    FROM zthr0112
   WHERE pernr = ps_zshr0141-pernr
     AND datum = ps_zshr0141-datum
     AND begda = ps_zshr0141-begda
     AND endda = ps_zshr0141-endda
     AND z52wktp = ps_zshr0141-z52wktp
     AND z52prsq = ps_zshr0141-z52prsq
     AND seqnr = ps_zshr0141-seqnr.

  IF ps_zshr0141-state <> 'E'.
    ps_return-type = c_error.
    ps_return-message = text-m16.
    RETURN.
  ENDIF.

  "회수기간체크
  CALL FUNCTION 'ZHR_52TM_VALID_DATE_CHECK'
    EXPORTING
      i_pernr  = ps_zshr0141-pernr
      i_date   = ps_zshr0141-datum
*      i_opt    = 'C'
      i_ztomo  = ps_zshr0141-ztomo
    IMPORTING
      e_return = ps_return.

  IF ps_return IS NOT INITIAL.
    RETURN.
  ENDIF.

  "회수처리
  CALL FUNCTION 'ZWF_DELETE'
    EXPORTING
      tabname            = 'ZWF0022'
      key_1              = ps_zshr0141-zserial
      key_2              = 'E'
    EXCEPTIONS
      already_delete     = 1
      already_approved   = 2
      already_rejected   = 3
      lock_wf            = 4
      not_found_wf_table = 5
      error_update_wf    = 6
      error_del_wf       = 7
      different_user     = 8
      OTHERS             = 9.

  IF sy-subrc = 0.
    UPDATE zthr0112
       SET state = '5'
           state_txt = '회수'
           aedat = sy-datum
           aezet = sy-uzeit
           aenam = sy-uname
     WHERE pernr = ps_zshr0141-pernr
       AND datum = ps_zshr0141-datum
       AND begda = ps_zshr0141-begda
       AND endda = ps_zshr0141-endda
       AND z52wktp = ps_zshr0141-z52wktp
       AND z52prsq = ps_zshr0141-z52prsq
       AND seqnr = ps_zshr0141-seqnr.
  ELSE.
    ps_return-type = c_error.
    ps_return-message = text-m17.
    RETURN.
  ENDIF.
ENDFORM.                    " B_CW_PROCESS_DATA
*&---------------------------------------------------------------------*
*&      Form  SET_CHANGE_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_MOD  text
*      <--P_LS_INSERT  text
*----------------------------------------------------------------------*
FORM set_change_info  USING    pv_mode
                      CHANGING ps_data TYPE zshr0141.
  IF pv_mode = 'INS'.
    "생성자정보, 변경자정보
    ps_data-erdat = ps_data-aedat = sy-datum.
    ps_data-erzet = ps_data-aezet = sy-uzeit.
    ps_data-ernam = ps_data-aenam = sy-uname.
  ELSE.
    "변경자정보
    ps_data-aedat = sy-datum.
    ps_data-aezet = sy-uzeit.
    ps_data-aenam = sy-uname.
  ENDIF.
ENDFORM.                    " SET_CHANGE_INFO
*&---------------------------------------------------------------------*
*&      Form  Z_CW_PROCESS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_PERNR  text
*      -->P_I_DATUM  text
*      <--P_CS_ZSHR0141  text
*      <--P_E_RETURN  text
*----------------------------------------------------------------------*
FORM z_cw_process_data  USING    pv_pernr
                                 i_tdcost
                                 pv_datum
                        CHANGING ps_zshr0141 TYPE zshr0141
                                 ps_return TYPE bapireturn1.

  DATA: lt_zshr0111 TYPE TABLE OF zshr0111 WITH HEADER LINE,
        ls_zthr0132 TYPE zthr0132,
        ls_zthr0124 TYPE zthr0124,
        ls_zshr0139 TYPE zshr0139,
        ls_zshr0140 TYPE zshr0140,
        ls_fromweb TYPE zshr0141,
        lv_chk,
        lv_daytxt TYPE tagbez,
        lv_text(50).

  MOVE-CORRESPONDING ps_zshr0141 TO ls_fromweb.
  CLEAR ps_zshr0141.

  "시차대상자
  CALL FUNCTION 'ZHR_52TM_EARLIER_WORKER'
    EXPORTING
      i_pernr = pv_pernr
      i_date  = ls_fromweb-datum
    IMPORTING
      e_chk   = lv_chk.
  IF lv_chk = 'X'.
    ps_zshr0141-wktype = '시차근무'.
  ENDIF.

  "요일
  CALL FUNCTION 'RH_GET_DATE_DAYNAME'
    EXPORTING
      langu  = '3'  "sy-langu
      date   = ls_fromweb-datum
    IMPORTING
      daytxt = lv_daytxt.

  ps_zshr0141-zyoil = lv_daytxt+0(1).

  "재난 활성여부
  CALL FUNCTION 'ZHR_52TM_CHECK_ZEMCWK'
    EXPORTING
      i_pernr  = pv_pernr
      i_datum  = ls_fromweb-datum
    IMPORTING
      e_zemcwk = ps_zshr0141-zemcwk_e.

  "기간
  SELECT SINGLE *
    INTO CORRESPONDING FIELDS OF ls_zthr0132
    FROM zthr0132
   WHERE pernr = pv_pernr
     AND z52wktp = c_z52wktp_0110
     AND z52prsq = c_z52prsq_04
     AND begda <= pv_datum
     AND endda >= pv_datum.


* 1. 기본값 설정
  ps_zshr0141-datum = ls_fromweb-datum.
  ps_zshr0141-pernr = ls_zthr0132-pernr.
  ps_zshr0141-begda = ls_zthr0132-begda.
  ps_zshr0141-endda = ls_zthr0132-endda.
  ps_zshr0141-z52wktp = ls_zthr0132-z52wktp.
  ps_zshr0141-z52prsq = ls_zthr0132-z52prsq.

* 2. I AM 체크
  SELECT SINGLE *
    INTO CORRESPONDING FIELDS OF ls_zthr0124
    FROM zthr0124
   WHERE pernr = pv_pernr
     AND zdeft = 'X'.

  IF sy-subrc = 0.
    ps_zshr0141-zbegtm = ls_zthr0124-zbegt.
    ps_zshr0141-zendtm = ls_zthr0124-zendt.
    ps_zshr0141-ztomo = ls_zthr0124-ztomo.
    ps_zshr0141-zpbeg1 = ls_zthr0124-zpbeg1.
    ps_zshr0141-zpend1 = ls_zthr0124-zpend1.
    ps_zshr0141-zpbtm1 = ls_zthr0124-zpbtm1.
    ps_zshr0141-zpetm2 = ls_zthr0124-zpetm1.
    ps_zshr0141-zpbeg2 = ls_zthr0124-zpbeg2.
    ps_zshr0141-zpend2 = ls_zthr0124-zpend2.
    ps_zshr0141-zpbtm2 = ls_zthr0124-zpbtm2.
    ps_zshr0141-zpetm2 = ls_zthr0124-zpetm2.

    "총근무시간/의무휴계시간/총휴계시간
    PERFORM d_cw_get_data USING pv_pernr
                                ps_zshr0141
                          CHANGING ls_zshr0139
                                   ps_return.
    ps_zshr0141-zrlwk_tm = ls_zshr0139-zrlwk_tm.
    ps_zshr0141-zdmwk_tm = ls_zshr0139-zdmwk_tm.
    ps_zshr0141-zpdwk_tm = ls_zshr0139-zpdwk_tm.


    "결재사 사번
    ps_zshr0141-zcosa = ls_zthr0124-zcosa.
    "결재자 성명
    ps_zshr0141-zcope = zcl_cm_util_dev=>get_name( i_pernr = ls_zthr0124-zcosa ).
    "결재자 부서
    lv_text = zcl_cm_util_dev=>get_vdstext( i_pernr = ls_zthr0124-zcosa ).
    ps_zshr0141-corgtx = lv_text.
    "결재자 직위
    lv_text = zcl_cm_util_dev=>get_jikwitext( i_pernr = ls_zthr0124-zcosa ).
    CONCATENATE ps_zshr0141-corgtx lv_text INTO ps_zshr0141-corgtx SEPARATED BY space.
    "업무내용
    ps_zshr0141-ztext = ls_zthr0124-ztext.
    "결재자ID
    ps_zshr0141-zcid = zcl_cm_util_dev=>conversion_alpha( value = ls_zthr0124-zcosa flag = 'O' ).

    ps_return-message = text-m20.
  ELSE.
* 3. I AM 등록 안된 경우의 최근결재자
    PERFORM e_cw_get_data USING pv_pernr
                          CHANGING ls_zshr0140
                                   ps_return.

    MOVE-CORRESPONDING ls_zshr0140 TO ps_zshr0141.
  ENDIF.

  "4. 근태내역
  CALL FUNCTION 'ZHR_52TM_AWART_LIST'
    EXPORTING
      i_pernr    = pv_pernr
      i_begda    = ps_zshr0141-datum
      i_endda    = ps_zshr0141-datum
      i_zsangsin = 'X'
    TABLES
      t_data     = lt_zshr0111.

  LOOP AT lt_zshr0111 WHERE datum = ps_zshr0141-datum
                         AND ( zabsdayty = 'A' OR zabsdayty = 'P' )
                         AND zstat = 'A'. " 결재승인완료건만 조회

    ps_zshr0141-awart = lt_zshr0111-awart.
    CASE lt_zshr0111-awart.
      WHEN '1012'.
        ps_zshr0141-atext = '연차'.
      WHEN '1013' OR '1015'.
        ps_zshr0141-atext = '반차'.
      WHEN OTHERS.
        ps_zshr0141-atext = lt_zshr0111-atext.
    ENDCASE.

    EXIT.
  ENDLOOP.

  ps_return-type = c_success.
ENDFORM.                    " Z_CW_PROCESS_DATA
*&---------------------------------------------------------------------*
*&      Form  U_CW_PROCESS_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_PERNR  text
*      -->P_I_DATUM  text
*      <--P_CS_ZSHR0141  text
*      <--P_E_RETURN  text
*----------------------------------------------------------------------*
FORM u_cw_process_data  USING pv_tdcost CHANGING ps_zshr0141 TYPE zshr0141
                                 pv_case
                                 ps_return TYPE bapireturn1.

  DATA: ls_fromweb TYPE zshr0141,
        ls_data TYPE zshr0141,
        ls_update TYPE zthr0112.

  MOVE-CORRESPONDING ps_zshr0141 TO ls_fromweb.

  IF pv_case = 'U'.
    "근무시간 체크
    PERFORM f_cw_check_data USING ps_zshr0141
                            CHANGING ps_return.
    CHECK ps_return-type = c_success.

    "휴계시간 체크
    PERFORM g_cw_check_data USING ls_fromweb
                            CHANGING ps_return.
    CHECK ps_return-type = c_success.
  ENDIF.

  "결재자 체크 및 ZCID 리턴
  PERFORM e_cw_check_data CHANGING ps_zshr0141
                                   ps_return.
  CHECK ps_return-type = c_success.

  "근무일자 중복여부 체크, 근무시간 체크
  PERFORM h_cw_check_data USING ps_zshr0141
                                'U'
                          CHANGING ps_return.
  CHECK ps_return-type = c_success.

  IF pv_case = 'U'.
    "실적항목 생성
    CALL FUNCTION 'ZHR_52TM_CW_SET_ITEM'
      EXPORTING
        i_pernr     = ps_zshr0141-pernr
        is_data     = ps_zshr0141
        tdcost      = pv_tdcost
      IMPORTING
        e_return    = ps_return
      CHANGING
        cs_zshr0141 = ls_data.

    IF ls_data-tdcost NE 0.
      ps_zshr0141-tdcost = ls_data-tdcost.
    ENDIF.

    SELECT SINGLE awart
      INTO ls_data-awart
      FROM zthr0112
     WHERE pernr = ls_data-pernr
       AND datum = ls_data-datum
       AND begda = ls_data-begda
       AND endda = ls_data-endda
       AND z52wktp = ls_data-z52wktp
       AND z52prsq = ls_data-z52prsq
       AND seqnr = ls_data-seqnr.

    "익일 당번특근 데이터는 가산시간이 발생하지 않음(처음 저장신 X로 입력함)
    IF ls_data-awart = 'X'.
      CLEAR ls_data-zovradd_tm.
    ENDIF.

    "소정근로시간 소진 및 연장(가능)시간 초과 메세지
    PERFORM d_cw_check_data USING ls_data-pernr
                                  ls_data-datum
                                  ls_data
                            CHANGING ps_return.
    CHECK ps_return-type = c_success.
  ELSE.  "선택휴무
    MOVE-CORRESPONDING ps_zshr0141 TO ls_data.
  ENDIF.

  ls_data-zcid = ps_zshr0141-zcid.  "ZCID값 지정
  "상태
  ls_data-state = '0'.
  PERFORM set_state_text USING ls_data-state
                         CHANGING ls_data-state_txt.
  "변경자
  PERFORM set_change_info USING 'UPD' CHANGING ls_data.

  MOVE-CORRESPONDING ls_data TO ls_update.
  MODIFY zthr0112 FROM ls_update.

  ps_return-type = c_success.

ENDFORM.                    " U_CW_PROCESS_DATA
*&---------------------------------------------------------------------*
*&      Form  SET_STATE_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_INSERT_STATE  text
*      <--P_LS_INSERT_STATE_TXT  text
*----------------------------------------------------------------------*
FORM set_state_text  USING    ps_state
                     CHANGING ps_state_txt.

  DATA: lv_domvalue TYPE dd07v-domvalue_l,
        lv_ddtext TYPE dd07v-ddtext.

  CLEAR ps_state_txt.


  CASE ps_state.
    WHEN '0'.
      ps_state_txt = '미상신'.
    WHEN 'E'.
      ps_state_txt = '결재중'.
    WHEN OTHERS.
      lv_domvalue = ps_state.

      CALL FUNCTION 'DOMAIN_VALUE_GET'
        EXPORTING
          i_domname  = 'ZSTATE_1'
          i_domvalue = lv_domvalue
        IMPORTING
          e_ddtext   = lv_ddtext
        EXCEPTIONS
          not_exist  = 1
          OTHERS     = 2.

      ps_state_txt = lv_ddtext.
  ENDCASE.
ENDFORM.                    " SET_STATE_TEXT
*&---------------------------------------------------------------------*
*&      Form  MAKE_OVRNGT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_INSERT  text
*      -->P_LS_ZSHR0115  text
*      <--P_PS_ZSHR0141  text
*      <--P_LS_FROMWEB  text
*      <--P_PS_RETURN  text
*----------------------------------------------------------------------*
FORM make_ovrngt_data  TABLES   pt_insert STRUCTURE zthr0112
                       USING ps_tdcost
                       CHANGING ps_zshr0141 TYPE zshr0141
                                ps_return TYPE bapireturn1.

  DATA: lv_ngt,
        lv_ind TYPE int1,
        ls_data TYPE zshr0141,
        ls_ovrngt TYPE zshr0141,
        ls_zshr0115 TYPE zshr0115,
        lt_zshr0115 TYPE TABLE OF zshr0115.


  MOVE-CORRESPONDING ps_zshr0141 TO ls_zshr0115.

  "당번특근이고 익일체크이면
  IF ps_zshr0141-zovrngt = 'X' AND ps_zshr0141-ztomo = 'X' .
    lv_ngt = 'Y'.
  ENDIF.

  CALL FUNCTION 'ZHR_52TM_CALC_WORK_TIME_DAYILY'
    EXPORTING
      is_day     = ls_zshr0115
*        i_opt      = 'X'
      i_ngt      = lv_ngt
    TABLES
      t_day_time = lt_zshr0115.

  LOOP AT lt_zshr0115 INTO ls_zshr0115.
    ADD 1 TO lv_ind.

    MOVE-CORRESPONDING ps_zshr0141 TO ls_ovrngt.
    ls_ovrngt-datum = ls_zshr0115-datum.
    ls_ovrngt-zbegtm = ls_zshr0115-zbegtm.
    ls_ovrngt-zendtm = ls_zshr0115-zendtm.
    ls_ovrngt-ztomo = ls_zshr0115-ztomo.
    ls_ovrngt-zpbeg1 = ls_zshr0115-zpbeg1.
    ls_ovrngt-zpbtm1 = ls_zshr0115-zpbtm1.
    ls_ovrngt-zpend1 = ls_zshr0115-zpend1.
    ls_ovrngt-zpetm1 = ls_zshr0115-zpetm1.
    ls_ovrngt-zpbeg2 = ls_zshr0115-zpbeg2.
    ls_ovrngt-zpbtm2 = ls_zshr0115-zpbtm2.
    ls_ovrngt-zpend2 = ls_zshr0115-zpend2.
    ls_ovrngt-zpetm2 = ls_zshr0115-zpetm2.
    ls_ovrngt-zpbeg3 = ls_zshr0115-zpbeg3.
    ls_ovrngt-zpbtm3 = ls_zshr0115-zpbtm3.
    ls_ovrngt-zpend3 = ls_zshr0115-zpend3.
    ls_ovrngt-zpetm3 = ls_zshr0115-zpetm3.

    "실적항목 생성
    CALL FUNCTION 'ZHR_52TM_CW_SET_ITEM'
      EXPORTING
        i_pernr     = ps_zshr0141-pernr
        is_data     = ls_ovrngt
        tdcost      = ps_tdcost
      IMPORTING
        e_return    = ps_return
      CHANGING
        cs_zshr0141 = ls_data.


*->>> 체크를 PERFORM h_cw_check_data 에서 처리함
    IF lv_ind = 2.
***      PERFORM c_cw_check_data USING ls_data-pernr
***                                    ls_data
***                              CHANGING ps_return.
***      IF ps_return-type = c_error.
***        RETURN.
***      ENDIF.

      "익일 당번특근 데이터의 가산근무시간은 클리어.
      CLEAR ls_data-zovradd_tm.

      ls_data-awart = 'X'.  "익일 당번특근 데이터 임을 표시(수정시 필요)
    ENDIF.

    "ZCID값 지정
    ls_data-zcid = ps_zshr0141-zcid.
    "신규 seqnr
    PERFORM get_seqnr CHANGING ls_data.
    "상태
    ls_data-state = '0'.
    PERFORM set_state_text USING ls_data-state
                           CHANGING ls_data-state_txt.
    "변경자
    PERFORM set_change_info USING 'INS' CHANGING ls_data.

    CLEAR pt_insert.
    MOVE-CORRESPONDING ls_data TO pt_insert.

    IF lv_ind = 1.
      "처음건의 SEQNR, ERDAT, ERZET, ERNAM WEB에 리턴해준다.
      ps_zshr0141-seqnr = pt_insert-seqnr.
      ps_zshr0141-erdat = pt_insert-erdat.
      ps_zshr0141-erzet = pt_insert-erzet.
      ps_zshr0141-ernam = pt_insert-ernam.
    ELSE.
      "익일 당번특근 SEQNR을 WEB에 리턴해준다.(최초저장 후 수정저장시 삭제하기 위해서 필요)
      ps_zshr0141-seqnr2 = pt_insert-seqnr.
    ENDIF.

    APPEND pt_insert.
  ENDLOOP.
ENDFORM.                    " MAKE_OVRNGT_DATA
