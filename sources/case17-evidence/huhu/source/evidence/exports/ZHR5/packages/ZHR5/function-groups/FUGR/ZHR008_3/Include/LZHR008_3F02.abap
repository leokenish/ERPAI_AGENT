*&---------------------------------------------------------------------*
*&  Include           LZHR008_3F02
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  B_CW_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_PERNR  text
*      -->P_I_DATUM  text
*      <--P_CS_ZSHR0137  text
*      <--P_E_RETURN  text
*----------------------------------------------------------------------*
FORM b_cw_get_data  TABLES pt_zshr0138 STRUCTURE zshr0138
                    USING    pv_pernr
                             pv_datum
                             pv_page
                    CHANGING ps_zshr0144 TYPE zshr0144
                             ps_return TYPE bapireturn1.


  DATA: lt_zshr0141 TYPE TABLE OF zshr0141 WITH HEADER LINE,
        lt_zshr0111 TYPE TABLE OF zshr0111 WITH HEADER LINE,
        lt_attributes TYPE TABLE OF casdayattr WITH HEADER LINE,
        ls_zshr0137 TYPE zshr0137,
        ls_tmp TYPE zshr0141.

  DATA: lv_zbegtm_t(5),
        lv_zendtm_t(8),
        lv_chk,
        lv_opt,
        lv_cnt TYPE n LENGTH 1.

  DATA: lv_pwkhr_min TYPE i,
        lv_owkhr_min TYPE i,
        lv_awkhr_t_min TYPE i,
        lv_awkhr_t_min2 TYPE i,
        lv_ewkhr_t_min TYPE i,
        lv_ewkhr_t_min2 TYPE i,
        lv_rwkhr_t_min TYPE i,
        lv_rwkhr_t_min2 TYPE i,
        lv_sign TYPE i.

  DATA: time1 TYPE zchar06,
            time2 TYPE zchar06,
            time_dif TYPE zchar06,
            s_time TYPE i,
            l_time TYPE i,
            m_time TYPE i.


  CLEAR: pt_zshr0138, pt_zshr0138[].


  "실적, 근태
  CALL FUNCTION 'ZHR_52TM_CW_BASE_DATA'
    EXPORTING
      i_page      = pv_page
      i_pernr     = pv_pernr
      i_datum     = pv_datum
    IMPORTING
      e_return    = ps_return
    TABLES
      lt_zshr0141 = lt_zshr0141
      lt_zshr0111 = lt_zshr0111
    CHANGING
      cs_zshr0137 = ls_zshr0137.

  "시작일/종료일
  ps_zshr0144-begda = ls_zshr0137-begda.
  ps_zshr0144-endda = ls_zshr0137-endda.

*  평일 총근로시간
  PERFORM convert_min_to_hour USING ls_zshr0137-weekhr_min
                              CHANGING ps_zshr0144-wkhr.

  "휴일 총근로시간
  PERFORM convert_min_to_hour USING ls_zshr0137-holihr_min
                              CHANGING ps_zshr0144-hkhr.

  "총근로시간
  PERFORM convert_min_to_hour USING ls_zshr0137-twkhr_min
                              CHANGING ps_zshr0144-twkhr.
  "소정근로시간
  lv_pwkhr_min = ls_zshr0137-pwkhr_min - "기본 소정근로시간
                 ls_zshr0137-hodhr_min - "주중공휴일시간
                 ls_zshr0137-zprsdwk_t_min. "인정근로시간
  PERFORM convert_min_to_hour USING lv_pwkhr_min
                              CHANGING ps_zshr0144-pwkhr.
  "연장(가능)근로시간 " 최대근로시간 명칭 변경 및 최대근로시간 = 소정근로시간 + 연장(가능)근로시간
  lv_owkhr_min = ls_zshr0137-owkhr_min + "기본 연장(가능)근로시간
*                 ls_zshr0137-hodhr_min + "주중공휴일시간
*                 ls_zshr0137-zprsdwk_t_min + "인정근로시간
                 lv_pwkhr_min. " 소정근로시간 추가 (2019.9.17 xa30752 )
  PERFORM convert_min_to_hour USING lv_owkhr_min
                              CHANGING ps_zshr0144-owkhr.

  "누적근로시간
***  IF ls_zshr0137-twkhr_min < ls_zshr0137-cwkhr_min.  "총근로시간 보다 클때
***    ps_zshr0144-cwkhr = ps_zshr0144-twkhr.
***  ELSE.
  PERFORM convert_min_to_hour2 USING ls_zshr0137-cwkhr_min
                               CHANGING ps_zshr0144-cwkhr.
***  ENDIF.

  " 누적근로시간에서 208시간 차감한 시간을 특별연장근로시간으로 표기 xa30752 2020.09.16
  IF sy-datum >= '20210301'.
    IF ps_zshr0144-cwkhr+0(3) > '208'.

      time1+0(4) = ps_zshr0144-cwkhr+1(5).
      s_time = ps_zshr0144-cwkhr+0(1).
      time2+0(2) = '08'.
      l_time = '2'.

      CALL FUNCTION 'ZHR_MINUS_TIME_N'
        EXPORTING
          TIME1    = time1
          TIME2    = time2
          S_TIME   = s_time
          L_TIME   = l_time
        IMPORTING
          TIME_DIF = time_dif
          M_TIME   = m_time.

      IF m_time IS NOT INITIAL. " 시간이 3자릿수 일 경우
        ps_zshr0144-n_zemcwk+0(1) = m_time.
        ps_zshr0144-n_zemcwk+1(2) = time_dif+0(2).
        ps_zshr0144-n_zemcwk+3(1) = ':'.
        ps_zshr0144-n_zemcwk+4(2) = time_dif+3(2).

      ELSE. " 2자릿수 일 경우
        ps_zshr0144-n_zemcwk+0(2) = time_dif+0(2).
        ps_zshr0144-n_zemcwk+2(1) = ':'.
        ps_zshr0144-n_zemcwk+3(2) = time_dif+2(2).

      ENDIF.

    ELSE.
      ps_zshr0144-n_zemcwk+0(2) = '00'.
      ps_zshr0144-n_zemcwk+2(1) = ':'.
      ps_zshr0144-n_zemcwk+3(2) = '00'.
    ENDIF.

  ELSE.
    PERFORM convert_min_to_hour2 USING ls_zshr0137-cwkhr_min
                                 CHANGING ps_zshr0144-n_zemcwk.

  ENDIF.

  "결재건수
  LOOP AT lt_zshr0141.
    CASE lt_zshr0141-state.
      WHEN '0'.  "미상신
        ADD 1 TO ps_zshr0144-scnt0.
      WHEN 'E'.  "결재중
        ADD 1 TO ps_zshr0144-scnte.
      WHEN '3'.  "승인
        ADD 1 TO ps_zshr0144-scnt3.
    ENDCASE.
  ENDLOOP.

  CHECK pv_page <> 'A'.  "결재화면에서는 일별정보는 필요없음

*-> begin 일별정보
  SORT lt_zshr0141 BY datum seqnr DESCENDING.
  DELETE lt_zshr0111 WHERE NOT ( zstat = 'A' AND ( zabsdayty = 'A' OR zabsdayty = 'P' ) ).
  SORT lt_zshr0111 BY datum.

  "기간별 요일
  CALL FUNCTION 'DAY_ATTRIBUTES_GET'
    EXPORTING
      factory_calendar           = 'KR'
      holiday_calendar           = 'KB'
      date_from                  = ls_zshr0137-begda
      date_to                    = ls_zshr0137-endda
      language                   = sy-langu
    TABLES
      day_attributes             = lt_attributes
    EXCEPTIONS
      factory_calendar_not_found = 1
      holiday_calendar_not_found = 2
      date_has_invalid_format    = 3
      date_inconsistency         = 4
      OTHERS                     = 5.

  LOOP AT lt_attributes.
    pt_zshr0138-date = lt_attributes-date.
    pt_zshr0138-weekday = lt_attributes-weekday.

    IF lt_attributes-freeday = 'X'.
      pt_zshr0138-holiday = 'X'.
    ENDIF.

    READ TABLE lt_zshr0141 WITH KEY datum = lt_attributes-date BINARY SEARCH.
    IF sy-subrc = 0.
      CLEAR lv_cnt.
      LOOP AT lt_zshr0141 INTO ls_tmp WHERE datum = lt_zshr0141-datum
                                        AND seqnr <> lt_zshr0141-seqnr.
        ADD 1 TO lv_cnt.
        DELETE lt_zshr0141 INDEX sy-tabix.
      ENDLOOP.

      pt_zshr0138-state = lt_zshr0141-state.
      pt_zshr0138-state_txt = lt_zshr0141-state_txt.
      pt_zshr0138-zemcwk = lt_zshr0141-zemcwk.

      IF lv_cnt > 0.
        CONCATENATE '외' lv_cnt '건' INTO pt_zshr0138-rcnt.
      ENDIF.

      IF lt_zshr0141-znowk = 'X'.
        pt_zshr0138-wktime = text-m29.
      ELSE.
        WRITE: lt_zshr0141-zbegtm USING EDIT MASK '__:__' TO lv_zbegtm_t,
               lt_zshr0141-zendtm USING EDIT MASK '__:__' TO lv_zendtm_t,
               lt_zshr0141-zrlwk_tm USING EDIT MASK '__:__' TO pt_zshr0138-zrlwk.

        IF lt_zshr0141-ztomo = 'X'.
          CONCATENATE lv_zendtm_t '(익)' INTO lv_zendtm_t.
        ENDIF.

        CONCATENATE lv_zbegtm_t '~' lv_zendtm_t INTO pt_zshr0138-wktime.
      ENDIF.
    ENDIF.

    LOOP AT lt_zshr0111 WHERE datum = lt_attributes-date
                          AND ( zabsdayty = 'A' OR zabsdayty = 'P' )
                          AND zstat = 'A'. " 결재승인완료건만 조회
      pt_zshr0138-awart = lt_zshr0111-awart.
      CASE lt_zshr0111-awart.
        WHEN '1012'.
          pt_zshr0138-atext = '연차'.
        WHEN '1013' OR '1015'.
          pt_zshr0138-atext = '반차'.
        WHEN '0040'.
          pt_zshr0138-atext = '공가'. " 민방위 lt_zshr011-atext가 없어서 추가 xa30752 2019.7.16
        WHEN OTHERS.
          pt_zshr0138-atext = lt_zshr0111-atext.
      ENDCASE.

      EXIT.
    ENDLOOP.

    APPEND pt_zshr0138. CLEAR pt_zshr0138.
  ENDLOOP.
*<- end 일별정보
ENDFORM.                    " B_CW_GET_DATA
*&---------------------------------------------------------------------*
*&      Form  CONVERT_TIME_TO_MIN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_DATA_ZPRSDWK_TM  text
*      <--P_LV_MIN  text
*----------------------------------------------------------------------*
FORM convert_time_to_min  USING    pv_time  "format(00:00:00)
                          CHANGING pv_min.

  DATA: lv_hour TYPE i,
        lv_min TYPE i.

  lv_hour = pv_time(2).
  lv_min = pv_time+2(2).

  pv_min = ( lv_hour * 60 ) + lv_min.
ENDFORM.                    " CONVERT_TIME_TO_MIN
*&---------------------------------------------------------------------*
*&      Form  CONVERT_HOUR_TO_MIN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_ZTHR0132_PWKHR  text
*      <--P_LV_PWKHR_TIME  text
*----------------------------------------------------------------------*
FORM convert_hour_to_min  USING    pv_hour
                           CHANGING pv_min.

  pv_min = pv_hour * 60.

ENDFORM.                    " CONVERT_HOUR_TO_TIME
*&---------------------------------------------------------------------*
*&      Form  CONVERT_MIN_TO_HOUR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_PWKHR_MIN  text
*      <--P_PS_ZSHR0137_PWKHR  text
*----------------------------------------------------------------------*
FORM convert_min_to_hour  USING    pv_min
                          CHANGING pv_hour.

  DATA: lv_time1(4),
        lv_time2(2) TYPE n.

  lv_time1 = pv_min DIV 60.
  lv_time2 = pv_min MOD 60.

  IF lv_time2 IS INITIAL.
    pv_hour = lv_time1.
  ELSE.
    CONCATENATE lv_time1 ':' lv_time2 INTO pv_hour.
  ENDIF.
ENDFORM.                    " CONVERT_MIN_TO_HOUR
*&---------------------------------------------------------------------*
*&      Form  CONVERT_MIN_TO_HOUR2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_PWKHR_MIN  text
*      <--P_PS_ZSHR0137_PWKHR  text
*----------------------------------------------------------------------*
FORM convert_min_to_hour2  USING    pv_min
                          CHANGING pv_hour.

  DATA: lv_time1(4),
        lv_time2(2) TYPE n.

  lv_time1 = pv_min DIV 60.
  lv_time2 = pv_min MOD 60.

  CONCATENATE lv_time1 ':' lv_time2 INTO pv_hour.
ENDFORM.                    " CONVERT_MIN_TO_HOUR2
*&---------------------------------------------------------------------*
*&      Form  CONVERT_MIN_TO_HOUR3
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_PWKHR_MIN  text
*      <--P_PS_ZSHR0137_PWKHR  text
*----------------------------------------------------------------------*
FORM convert_min_to_hour3  USING    pv_min
                          CHANGING pv_hour.

  DATA: lv_time1(4) TYPE n,
        lv_time2(2) TYPE n.

  lv_time1 = pv_min DIV 60.
  lv_time2 = pv_min MOD 60.

  CONCATENATE lv_time1 lv_time2 INTO pv_hour.
ENDFORM.                    " CONVERT_MIN_TO_HOUR3
*&---------------------------------------------------------------------*
*&      Form  CONVERT_MIN_TO_TIME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LV_PWKHR_MIN  text
*      <--P_PS_ZSHR0137_PWKHR  text
*----------------------------------------------------------------------*
FORM convert_min_to_time  USING    pv_min
                          CHANGING pv_time.

  DATA: lv_time1 TYPE n LENGTH 2,
        lv_time2 TYPE n LENGTH 2.

  lv_time1 = pv_min DIV 60.
  lv_time2 = pv_min MOD 60.

  CONCATENATE lv_time1 lv_time2 '00' INTO pv_time.
ENDFORM.                    " CONVERT_MIN_TO_TIME
*&---------------------------------------------------------------------*
*&      Form  D_CW_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_PERNR  text
*      -->P_CS_ZTHR0112  text
*      <--P_CS_ZSHR0139  text
*      <--P_E_RETURN  text
*----------------------------------------------------------------------*
FORM d_cw_get_data  USING    value(pv_pernr)
                             value(ps_zshr0141) TYPE zshr0141
                    CHANGING ps_zshr0139 TYPE zshr0139
                             ps_return TYPE bapireturn1.

  DATA: lv_chk,
        lt_day    LIKE TABLE OF  casdayattr WITH HEADER LINE,
        lv_ngt,
        lv_zrlwk_tm TYPE zchar06,
        lv_zpdwk_tm TYPE zchar06,
        lv_zrlngtwk_tm TYPE zchar06,
        lv_time1 TYPE tims VALUE '053000',
        lv_time2 TYPE tims VALUE '080000',
        ls_zshr0115 TYPE zshr0115,
        lt_zshr0115 TYPE TABLE OF zshr0115.

  CLEAR ps_zshr0139.

  MOVE-CORRESPONDING ps_zshr0141 TO ls_zshr0115.

  "시차대상자
  CALL FUNCTION 'ZHR_52TM_EARLIER_WORKER'
    EXPORTING
      i_pernr = pv_pernr
      i_date  = ps_zshr0141-datum
    IMPORTING
      e_chk   = lv_chk.

  IF lv_chk = 'X'.
    ls_zshr0115-zgubun = 'B'.
  ENDIF.

  "퇴출이면
  IF ps_zshr0141-ztoich EQ 'X'.
    lv_ngt = 'Z'.
  ENDIF.

  "당번특근이고 익일체크이면
  IF ps_zshr0141-zovrngt = 'X' AND ps_zshr0141-ztomo = 'X' .
    lv_ngt = 'Y'.
  ENDIF.

  CALL FUNCTION 'ZHR_52TM_CALC_WORK_TIME_DAYILY'
    EXPORTING
      is_day       = ls_zshr0115
*      i_opt        = 'X'
      i_ngt        = lv_ngt
    IMPORTING
      e_zrlwk_tm   = lv_zrlwk_tm  "총근무시간
      e_zpdwk_tm   = lv_zpdwk_tm  "총휴계시간
      e_zpdwk_d_tm = ps_zshr0139-zdmwk_tm  "의무휴계시간
    TABLES
      t_day_time   = lt_zshr0115.

  ps_zshr0139-zrlwk_tm = lv_zrlwk_tm.
  ps_zshr0139-zpdwk_tm = lv_zpdwk_tm.

* ------------- 당번 특근이 휴휴 / 휴평 인경우 가산시간 더하지 않도록 수정 ---------------
*                            20201125 xa31769 김지훈
*                            첫날(PS_ZSHR0141-ZYOIL)이 휴일이면  가산시간 없도록 수정
* -------------------------------------------------------------------------
*READ TABLE lt_zshr0115 INDEX 1.

*IF .
*
*ENDIF.lt_zshr0115-days = 0

  LOOP AT lt_zshr0115 INTO ls_zshr0115.
    IF ls_zshr0115-days = '1'. "평일
      "야간근로시간, 야간시간(22:00~06:00) 산출.
      PERFORM get_calc_ngt_time IN PROGRAM saplzhr008_2
                                   USING  ls_zshr0115
                                   CHANGING ps_zshr0139-zrlngtwk_tm.

      ADD lv_zrlngtwk_tm TO ps_zshr0139-zrlngtwk_tm.

*      "연장근로시간
*      IF lt_zshr0115-tmtyp = 'M'. " overtime
*        lt_zshr0115-zrlovrwkhr = lt_zshr0115-zrlwk_tm.
*      ENDIF.

    ELSE. "휴일
*      IF ls_zshr0115-tmtyp = 'H'.
*        IF lt_zshr0115-zdaeh = 'X'.  "대휴시간
*          lt_zshr0115-zdaehhr = lt_zshr0115-zrlwk_tm.
*        ELSE.   "휴일시간
      ADD ls_zshr0115-zrlwk_tm TO ps_zshr0139-zrlholwk_tm.
*        ENDIF.
*      ENDIF.
    ENDIF.


    REFRESH lt_day.
    CALL FUNCTION 'DAY_ATTRIBUTES_GET'
      EXPORTING
        factory_calendar = 'KR'
        holiday_calendar = 'KB'
        date_from        = ps_zshr0141-datum
        date_to          = ps_zshr0141-datum
      TABLES
        day_attributes   = lt_day.

    READ TABLE lt_day INDEX 1.


    "당번특근이면서 당일근무시간이 8시간 미만이면 가산시간을 부여함
    IF ps_zshr0141-zovrngt = 'X' AND ls_zshr0115-datum = ps_zshr0141-datum.

      IF ls_zshr0115-zrlwk_tm >= lv_time1 AND ls_zshr0115-zrlwk_tm < lv_time2.

        IF lt_day-freeday NE 'X'. " 시작일이 휴일이 아니면

          ps_zshr0139-zovradd_tm = lv_time2 - ls_zshr0115-zrlwk_tm.

        ENDIF.

      ENDIF.

    ENDIF.


  ENDLOOP.

ENDFORM.                    " D_CW_GET_DATA
*&---------------------------------------------------------------------*
*&      Form  E_CW_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_PERNR  text
*      <--P_CS_ZSHR0140  text
*      <--P_E_RETURN  text
*----------------------------------------------------------------------*
FORM e_cw_get_data  USING    pv_pernr
                    CHANGING ps_zshr0140 TYPE zshr0140
                             ps_return TYPE bapireturn1.

  DATA: ls_zthr0112 TYPE zthr0112,
        lv_corgtx(50).

  CLEAR ps_zshr0140.

  SELECT *
    UP TO 1 ROWS
    FROM zthr0112
    INTO CORRESPONDING FIELDS OF ls_zthr0112
   WHERE pernr = pv_pernr
     AND zcosa <> '0000000'
   ORDER BY datum DESCENDING.
  ENDSELECT.

  IF ls_zthr0112 IS NOT INITIAL.
    ps_zshr0140-zcosa = ls_zthr0112-zcosa." 결재자사번
    ps_zshr0140-zcope = ls_zthr0112-zcope." 결재자성명
    ps_zshr0140-zcid = ls_zthr0112-zcid. "결재자ID
    " 결재자부서명
    lv_corgtx = zcl_cm_util_dev=>get_vdstext( i_pernr = ls_zthr0112-zcosa ).
    ps_zshr0140-corgtx = lv_corgtx.
    CLEAR lv_corgtx.
    lv_corgtx = zcl_cm_util_dev=>get_jikwitext( i_pernr = ls_zthr0112-zcosa ).
    CONCATENATE ps_zshr0140-corgtx lv_corgtx INTO ps_zshr0140-corgtx SEPARATED BY space.
  ENDIF.

ENDFORM.                    " E_CW_GET_DATA
*&---------------------------------------------------------------------*
*&      Form  F_CW_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_PERNR  text
*      -->P_CS_ZSHR0141  text
*      <--P_CS_ZSHR0142  text
*      <--P_E_RETURN  text
*----------------------------------------------------------------------*
FORM f_cw_get_data  USING    value(pv_pernr)
                             value(ps_zshr0141) TYPE zshr0141
                    CHANGING ps_zshr0142 TYPE zshr0142
                             ps_return TYPE bapireturn1.

  DATA lt_holidays TYPE TABLE OF iscal_day.

  CLEAR ps_zshr0142.

  ps_zshr0142-zbegtm = '180000'.
  ps_zshr0142-zendtm = '090000'.
  ps_zshr0142-ztomo = 'X'.


  CALL FUNCTION 'HOLIDAY_GET'
    EXPORTING
      holiday_calendar = 'KB'
      factory_calendar = 'KR'
      date_from        = ps_zshr0141-datum
      date_to          = ps_zshr0141-datum
    TABLES
      holidays         = lt_holidays.

  CHECK lt_holidays IS INITIAL.
  ps_zshr0142-zpbeg1 = '193000'.
  ps_zshr0142-zpend1 = '200000'.
  ps_zshr0142-zpbeg2 = '060000'.
  ps_zshr0142-zpend2 = '070000'.
  ps_zshr0142-zpbtm2 = 'X'.
  ps_zshr0142-zpetm2 = 'X'.
ENDFORM.                    " F_CW_GET_DATA
*&---------------------------------------------------------------------*
*&      Form  G_CW_GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_PERNR  text
*      -->P_CS_ZSHR0141  text
*      <--P_CS_ZSHR0143  text
*      <--P_E_RETURN  text
*----------------------------------------------------------------------*
FORM g_cw_get_data  USING    value(pv_pernr)
                             value(ps_zshr0141) TYPE zshr0141
                    CHANGING ps_zshr0143 TYPE zshr0143
                             ps_return TYPE bapireturn1.

  CLEAR ps_zshr0143.

  CALL FUNCTION 'ZHR_GET_PERSONNEL_RANK_N'
    EXPORTING
      i_pernr            = pv_pernr
      i_znal             = ps_zshr0141-datum
    IMPORTING
      e_zdung            = ps_zshr0143-zdung
    EXCEPTIONS
      e1_no_overtime     = 1
      e1_zdung_error     = 2
      e1_not_found_zdung = 3
      not_found_zdung    = 4.

  IF sy-subrc EQ 0.
    SELECT SINGLE zcost
      INTO ps_zshr0143-zcost
      FROM zthrcost
     WHERE z_ctype = '1'      " 기준단가.
       AND zdung   =  ps_zshr0143-zdung
       AND begda <= ps_zshr0141-datum
       AND endda => ps_zshr0141-datum
       AND zversn  = '1'.     " 활성버전

    ps_zshr0143-zcost = ps_zshr0143-zcost / 100.
  ELSE.

  ENDIF.

ENDFORM.                    " G_CW_GET_DATA
