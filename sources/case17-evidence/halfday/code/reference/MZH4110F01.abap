*&---------------------------------------------------------------------*
*&  Include           MZH4110F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  0100_CHECK_PERSONNEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GV_PERNR  text
*----------------------------------------------------------------------*
FORM 0100_check_personnel USING p_pernr
                       CHANGING c_error
                                c_text.
  DATA: ls_p0001 TYPE p0001.

  CLEAR: c_error, c_text.

*...// 입력받은 사원번호의 유효성 Check
*-> begin 퇴직자 사번 입력 허용 - 2026.10.02 BY HJH
* 기존 : 현재일자 기준 재직중인 사원만 허용
*  SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_p0001
*    FROM pa0001
*   WHERE pernr = p_pernr
*     AND endda >= sy-datum
*     AND begda <= sy-datum.

* 변경 : PA0001에 사번 이력이 존재하면 퇴직자도 허용
  SELECT SINGLE *
    INTO CORRESPONDING FIELDS OF ls_p0001
    FROM pa0001
   WHERE pernr = p_pernr.
*<- end 퇴직자 사번 입력 허용 - 2026.10.02 BY HJH

  IF sy-subrc <> 0.
*    MESSAGE s000 WITH '사번을 확인하시기 바랍니다!'.
    c_error    = 'X'.
    c_text     = text-e05. "사번을 확인하시기 바랍니다!
    gv_fieldname = 'GV_PERNR'.
    RETURN.
  ENDIF.
ENDFORM.                    " 0100_CHECK_PERSONNEL
*&---------------------------------------------------------------------*
*&      Form  SET_INIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GV_PERNR  text
*      -->P_GS_RECORD  text
*----------------------------------------------------------------------*
FORM set_init  USING p_pernr
                     p_datum
            CHANGING c_error
                     c_text
                     cs_record STRUCTURE gs_record.

  DATA: lv_saveok TYPE syucomm,
        ls_person TYPE zsh_insa_person.

  CLEAR: c_error, c_text, cs_record.

*...// 개인기본정보 READ -> 시간외신청과 무관하게 순수한 개인정보 SETTING
  CALL FUNCTION 'ZHR_GET_PERSON'
    EXPORTING
      pernr                 = p_pernr
      begda                 = p_datum
      endda                 = p_datum
    IMPORTING
      person                = ls_person
    EXCEPTIONS
      person_not_found      = 1
      no_active_integration = 2
      OTHERS                = 3.


*-> begin 퇴직자 인사정보 조회 오류처리 보완 - 2026.10.02 BY HJH
  IF sy-subrc <> 0.
    c_error = abap_true.

    CONCATENATE '해당 사번의 인사정보를 조회할 수 없습니다.'
                '기준일:'
                p_datum
           INTO c_text
      SEPARATED BY space.

    RETURN.
  ENDIF.
*<- end 퇴직자 인사정보 조회 오류처리 보완 - 2026.10.02 BY HJH

  gs_record-pernr = ls_person-pernr.
  gs_record-ename = ls_person-ename.
  gs_record-jikwiname_1 = ls_person-jikwiname_1.
  gs_record-jikkname    = ls_person-jikkname.
  gs_record-fname       = ls_person-vdsk1txt.

*...// 입력받은 사번에 해당하는 기본 Data 설정
*....// 1. 사번에 해당하는 시간외 신청유형 설정.
*  PERFORM set_req_type
*    USING p_pernr
*          p_datum
*      CHANGING      gv_wktype    "근로형태
*          gv_zgubun
*          gv_error_code
*          c_text.
*  IF gv_error_code+0(1) EQ 'E'.
*    c_error = abap_true. RETURN.
*  ENDIF.

* 처음에는 gv_wktype이 설정되어 있지 않으므로 무조건 'A'가 들어오게 됨.
* 그러니 명시적으로 초기값을  'A'로 설정함. 20190715 임재하.
  gv_zgubun = 'A'.

*....// 2. 시간외신청 기본시간 설정
  PERFORM set_default_time
    USING p_pernr
          p_datum
          gv_zgubun
 CHANGING gv_wktype    "근로형태
          gv_error_code
          c_text
          cs_record.

  IF gv_error_code+0(1) EQ 'E'.
    c_error = abap_true. RETURN.
  ELSE.
    IF c_text IS NOT INITIAL.  "i am 메세지 - 2019.03.22 by chl
      MESSAGE c_text TYPE 'S'.
    ENDIF.
  ENDIF.

* 초기값이 들어가 있지 않으므로 재설정함. 20190715. 임재하.
*....// 1. 사번에 해당하는 시간외 신청유형 설정.
  PERFORM set_req_type
    USING p_pernr
          p_datum
      CHANGING      gv_wktype    "근로형태
          gv_zgubun
          gv_error_code
          c_text.
  IF gv_error_code+0(1) EQ 'E'.
    c_error = abap_true. RETURN.
  ENDIF.

  cs_record-zgubun = gv_zgubun.
*------


*-> begin 결재자 정보 - 2019.03.22 by chl
  PERFORM get_approve
   TABLES gt_approver
    USING cs_record-pernr
          cs_record-znal
 CHANGING cs_record-zcosa "결재자사번
          cs_record-zcope "결재자성명
          cs_record-zcid  "결재자ID
          gv_zcosa        "결재자리스트
          gv_error
          gv_error_code
          gv_error_text.

  IF gv_error EQ abap_true.
    PERFORM display_message USING gv_error_text.
    CLEAR gv_error.
  ENDIF.
*<- begin 결재자 정보 - 2019.03.22 by chl


*...// 3. 사원정보
  PERFORM get_person_data
 CHANGING gv_error_code
          c_text
          cs_record.
  IF gv_error_code+0(1) EQ 'E'.
    c_error = abap_true. RETURN.
  ENDIF.

  IF gv_wktype IS INITIAL.
    IF gv_zgubun EQ 'C'.
      gv_wktype = 'S4'. "교대근무 근무형태 값이 없는경우 'S4': 비번으로 지정
    ELSEIF gv_zgubun EQ 'B'.
      gv_wktype = 'N3'.
    ELSE.
      gv_wktype = 'N1'. "근무형태 값이 없는경우 'N1': 통상/해외로 지정
    ENDIF.
  ENDIF.

  IF gv_zgubun EQ 'C'.
    gs_record-zyuhyung = gv_wktype.
  ENDIF.

*...// 4. 근로형태 리스트 박스 구성 .
  PERFORM set_wktype_list
   TABLES gt_wktp
    USING p_pernr
          p_datum
   CHANGING gv_zgubun
            gv_wktype
            gv_error_code
          gv_error_text.
  IF gv_error_code+0(1) EQ 'E'.
    c_error = abap_true.
  ENDIF.

*...// 5. 재난, 퇴출, 익휴, 대휴 Checkbox 제어 여부 결정.
  IF cs_record-zyoil EQ '휴'.
    CLEAR: gv_ztoich_e.
  ELSE.
    gv_ztoich_e =  'X'.
  ENDIF.

  CLEAR: gv_zemcwk_e, gv_zdaeh_e, gv_ztomoh_e,  gv_ztoich_e,
             gv_zemcwk_o, gv_zdaeh_o, gv_ztomoh_o,  gv_ztoich_o.
*...// 6. 검색기간 초기값 설정.
  PERFORM set_search_date USING p_datum.

*...// 7. 기본검색기간에 해당하는 신청내역 조회
  PERFORM get_table_data
   TABLES gt_record       "시간외실비 내역
    USING p_pernr         "시간외실비 대상자사번
          gv_sbegda       "검색기간 시작일
          gv_sendda       "검색기간 종료일
          gv_stype.       "검색유형
ENDFORM.                    " SET_INIT
*&---------------------------------------------------------------------*
*&      Form  SET_WORK_TYPE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_PERNR  text
*      <--P_GV_WTYP  text
*----------------------------------------------------------------------*
FORM set_req_type USING p_pernr
                        p_datum
                 CHANGING        p_wktype
                       c_zgubun
                        c_code
                        c_text.
  CLEAR: c_code, c_text.

  CALL FUNCTION 'ZHR_52TM_SET_ZGUBUN'
    EXPORTING
      i_pernr  = p_pernr
      i_znal   = p_datum
      i_wktype = p_wktype
    IMPORTING
      e_zgubun = c_zgubun
      e_code   = c_code
      e_text   = c_text.

ENDFORM.                    " SET_WORK_TYPE

*&---------------------------------------------------------------------*
*&      Form  SET_DEFAULT_VALUE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_PERNR  text
*      -->P_SY_DATUM  text
*      -->P_GV_REQTP  text
*      -->P_GV_TYPE  text
*      <--P_C_ERROR  text
*      <--P_C_ERROR_TEXT  text
*      <--P_CS_RECORD  text
*----------------------------------------------------------------------*
FORM set_default_time  USING p_pernr
                             p_datum
                             p_zgubun
                  CHANGING  p_wktype
                             c_code
                             c_text
                             cs_record STRUCTURE gs_record.

  DATA: lv_pernr  TYPE persno,
        lv_znal   TYPE datum,
        lv_zgubun TYPE zbsgubun.

  DATA lt_zthrbs01 LIKE TABLE OF zthrbs01 WITH HEADER LINE.

  lv_pernr  = p_pernr.
  lv_znal   = p_datum.
  lv_zgubun = p_zgubun.

  CLEAR: c_code, c_text.

  "근무일이 바뀌면 근로형태를 새로 받기위해서 클리어해서 전송한다 - 2019.03.22 by chl
  IF gv_chg_datum <> lv_znal.
    CLEAR p_wktype.
  ENDIF.

  gv_chg_datum = lv_znal.  "추가 - 2019.03.22 by chl

*-> being 최근 결재자 정보 - 2019.03.22 by chl
  SELECT zcosa zcope erdat ertim
    INTO CORRESPONDING FIELDS OF TABLE lt_zthrbs01
    FROM zthrbs01
    UP TO 1 ROWS
   WHERE pernr = p_pernr
     AND zcosa <> '0000000'
   ORDER BY erdat DESCENDING ertim DESCENDING.

  READ TABLE lt_zthrbs01 INDEX 1.
  IF sy-subrc = 0.
    cs_record-zcosa = lt_zthrbs01-zcosa." 결재자사번
    cs_record-zcope = lt_zthrbs01-zcope." 결재자성명
  ENDIF.
*<- end 최근 결재자 정보 - 2019.03.22 by chl


  cs_record-pernr  = lv_pernr.   "사번
  cs_record-znal   = lv_znal.    "근무일자
  cs_record-zgubun = lv_zgubun.  "입력구분

  CALL FUNCTION 'ZHR_52TM_SET_DEFAULT_TIME'
    EXPORTING
      i_pernr     = cs_record-pernr
      i_znal      = cs_record-znal
      i_zgubun    = cs_record-zgubun
      i_wktype    = p_wktype
      i_isfst     = gv_isfst
    IMPORTING
      e_zbegt     = cs_record-zbegt
      e_zendt     = cs_record-zendt
      e_ztomo     = cs_record-ztomo
      e_zdangb    = cs_record-zdangb
      e_zdangj    = cs_record-zdangj
      e_wktim01_m = cs_record-wktim01_m "필수근로시간
      e_wktim02_m = cs_record-wktim02_m "주중공휴일시간
      e_wktim03_m = cs_record-wktim03_m "추가근로가능시간
      e_wktim04_m = cs_record-wktim04_m "총근로시간
      e_wktim05_m = cs_record-wktim05_m "근로시간
      e_wktim06_m = cs_record-wktim06_m "초과근로시간
      e_zpbeg1    = cs_record-zpbeg1    "의무휴게 시작시간
      e_zpend1    = cs_record-zpend1    "의무휴게 종료시간
      e_zpdwk_tm  = cs_record-zpdwk_tm   "의무휴게 시간
      e_zpbtm     = cs_record-zpbtm1
      e_zpetm     = cs_record-zpetm1
      e_waers     = cs_record-waers
      e_code      = c_code
      e_text      = c_text
      e_zpbeg2    = cs_record-zpbeg2
      e_zpend2    = cs_record-zpend2
      e_zpbtm2    = cs_record-zpbtm2
      e_zpetm2    = cs_record-zpetm2
      e_wktype    = p_wktype
      e_zcosa     = cs_record-zcosa   " 결재자사번 - 추가 2019.03.22 by chl
      e_zcope     = cs_record-zcope   " 결재자성명 - 추가 2019.03.22 by chl
      e_ztext     = cs_record-ztext   " 업무내용 - 추가 2019.03.22 by chl
      e_zcid      = cs_record-zcid.    " 결재ID - 추가 2019.04.29 by chl


  " defualt 익일 check
  IF ( cs_record-zendt <= cs_record-zbegt ) AND
     ( cs_record-zendt <> '000000'  AND  cs_record-zendt <> '000000' ).
    cs_record-ztomo = 'X'.
  ENDIF.

  PERFORM convert_time_out: USING cs_record-wktim01_m CHANGING cs_record-wktim01, "필수근로시간 OUT
                            USING cs_record-wktim02_m CHANGING cs_record-wktim02, "주중공휴일시간 OUT
                            USING cs_record-wktim03_m CHANGING cs_record-wktim03, "추가근로가능시간 OUT
                            USING cs_record-wktim04_m CHANGING cs_record-wktim04, "총근로시간 OUT
                            USING cs_record-wktim05_m CHANGING cs_record-wktim05, "근로시간 OUT
                            USING cs_record-wktim06_m CHANGING cs_record-wktim06. "초과근로시간 OUT

ENDFORM.                    " SET_DEFAULT_VALUE
*&---------------------------------------------------------------------*
*&      Form  GET_DEFAULT_VALUES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_CS_RECORD_PERNR  text
*      -->P_CS_RECORD_ZNAL  text
*      <--P_CS_RECORD_ZBEGT  text
*      <--P_CS_RECORD_ZENDT  text
*      <--P_LV_FLAG  text
*----------------------------------------------------------------------*
FORM get_default_values  USING    p_pernr
                                  p_znal
                         CHANGING c_zbegt
                                  c_zendt
                                  c_flag.
*...// 시차근무자 시간정보 초기값 조회.
  DATA : ls_bs12       TYPE zthrbs12,
         lv_holiday(1) TYPE c.

  CLEAR c_flag.

  CALL FUNCTION 'ZHR_GET_DAY_DATA_N'
    EXPORTING
      znal    = p_znal
    IMPORTING
      holiday = lv_holiday.

  IF lv_holiday IS INITIAL.
    SELECT SINGLE * INTO ls_bs12
      FROM zthrbs12
     WHERE pernr = p_pernr
       AND begda <= p_znal
       AND endda >= p_znal.

    IF sy-subrc = 0.
      MOVE : ls_bs12-zbegt TO c_zbegt,
             ls_bs12-zendt TO c_zendt,
             'X'           TO c_flag.
    ENDIF.
  ENDIF.
ENDFORM.                    " GET_DEFAULT_VALUES
*&---------------------------------------------------------------------*
*&      Form  GET_OVERTIME_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_SAVEOK  text
*      <--P_CS_RECORD  text
*----------------------------------------------------------------------*
FORM get_overtime_data  USING p_mode
                              p_saveok
                              p_wktype
                              p_exc
                     CHANGING c_error
                              c_code
                              c_text
                              c_zemcwk_e
                              c_ztoich_e
                              c_ztomoh_e
                              c_zdaeh_e
                              cs_record STRUCTURE gs_record.

  DATA : ls_zthrbs01      TYPE zthrbs01,
         ls_overtime_data TYPE zsh_overtime_data_n.

  CLEAR : c_code, c_text.

  CHECK c_error IS INITIAL.

* 시간외실비 시간 및 금액정보 산출.
  MOVE-CORRESPONDING cs_record TO ls_zthrbs01.

  CALL FUNCTION 'ZHR_52TM_GET_OVERTIME_DATA'
    EXPORTING
      i_mode                 = p_mode
      i_wktype               = p_wktype
      i_zexc                  = p_exc
      i_action               = p_saveok
*   I_MTYPE                =
*   I_ZDIFF                =
      i_run_r3               = 'X'
      is_zthrbs01            = ls_zthrbs01
   IMPORTING
     es_overtime_data       = ls_overtime_data
     e_zpdwk_tm             = cs_record-zpdwk_tm_sum
     e_code                 = c_code
     e_text                 = c_text
     e_zemcwk_o    = gv_zemcwk_o
     e_ztoich_o      = gv_ztoich_o
     e_ztomoh_o    = gv_ztomoh_o
     e_zdaeh_o      =  gv_zdaeh_o
   CHANGING
     c_zemcwk               = c_zemcwk_e
     c_ztoich               = c_ztoich_e
     c_ztomoh               = c_ztomoh_e
     c_zdaeh                = c_zdaeh_e.

  IF c_code+0(1) <> 'E'.

    MOVE :ls_overtime_data-zyoil      TO cs_record-zyoil,
          ls_overtime_data-za_time    TO cs_record-za_time,
          ls_overtime_data-ze_time    TO cs_record-ze_time,
          ls_overtime_data-zr_time    TO cs_record-zr_time,
          ls_overtime_data-zo_time    TO cs_record-zo_time,
          ls_overtime_data-zn_time    TO cs_record-zn_time,
          ls_overtime_data-zh_time    TO cs_record-zh_time,
          ls_overtime_data-zd_time    TO cs_record-zd_time,     "2011.04.
          ls_overtime_data-zo_money   TO cs_record-zo_money,
          ls_overtime_data-zn_money   TO cs_record-zn_money,
          ls_overtime_data-zh_money   TO cs_record-zh_money,
          ls_overtime_data-zs_money   TO cs_record-zs_money,
          ls_overtime_data-zd_money   TO cs_record-zd_money,    "2011.04.
          ls_overtime_data-zmoney     TO cs_record-zmoney,
          ls_overtime_data-zmoney_c   TO cs_record-zmoney_c,
          ls_overtime_data-waers      TO cs_record-waers,
          ls_overtime_data-zdaeh      TO cs_record-zdaeh,
          ls_overtime_data-zdaeh_c    TO cs_record-zdaeh_c,
          ls_overtime_data-zgubn      TO cs_record-zgubn,
          ls_overtime_data-zdaeh_f    TO cs_record-zdaeh_f,
          ls_overtime_data-ztomoh_f   TO cs_record-ztomoh_f,
          ls_overtime_data-zsign      TO cs_record-zsign,
          ls_overtime_data-zcho       TO cs_record-zcho,
          ls_overtime_data-zcho_m     TO cs_record-zcho_m,
          ls_overtime_data-zdday      TO cs_record-zdday,
          ls_overtime_data-ztbase     TO cs_record-ztbase,      "2011.06.22
          ls_overtime_data-zbancha    TO cs_record-zbancha, "2012.11.12 반차 추가 xa30750
          ls_overtime_data-zemcwk     TO cs_record-zemcwk.

    cs_record-zcost = ls_overtime_data-zcost * 100.
    " 익일.
*    IF overtime_data-ztomo IS INITIAL.
*      CLEAR CS_RECORD-ztomo.
*    ELSE.
*      MOVE 'X' TO CS_RECORD-ztomo.
*    ENDIF.

    " 퇴출.
    IF ls_overtime_data-ztoich IS INITIAL.
      CLEAR cs_record-ztoich.
    ELSE.
      MOVE 'X' TO cs_record-ztoich.
    ENDIF.

    " 대휴.
    IF ls_overtime_data-zdaeh IS INITIAL.
      CLEAR cs_record-zdaeh.
    ELSE.
      MOVE 'X' TO cs_record-zdaeh.
    ENDIF.

    " 익휴.
    IF ls_overtime_data-ztomoh IS INITIAL.
      CLEAR cs_record-ztomoh.
    ELSE.
      MOVE 'X' TO cs_record-ztomoh.
    ENDIF.

    "재난
    IF ls_overtime_data-zemcwk IS INITIAL.
      CLEAR cs_record-zemcwk.
    ELSE.
      MOVE 'X' TO cs_record-zemcwk.
    ENDIF.

    " 근무시간.
    CONCATENATE cs_record-za_time+0(2) ':' cs_record-za_time+2(4)
                INTO cs_record-za_time_s.
    CONCATENATE cs_record-zo_time+0(2) ':' cs_record-zo_time+2(4)
                INTO cs_record-zo_time_s.
    CONCATENATE cs_record-zn_time+0(2) ':' cs_record-zn_time+2(4)
                INTO cs_record-zn_time_s.
    CONCATENATE cs_record-zh_time+0(2) ':' cs_record-zh_time+2(4)
                INTO cs_record-zh_time_s.
    CONCATENATE cs_record-ze_time+0(2) ':' cs_record-ze_time+2(4)
                INTO cs_record-ze_time_s.
    CONCATENATE cs_record-zr_time+0(2) ':' cs_record-zr_time+2(4)
              INTO cs_record-zr_time_s.

    " 연장/야간/휴일금액.
    cs_record-zo_money_c = cs_record-zo_money / 100.
    cs_record-zn_money_c = cs_record-zn_money / 100.
    cs_record-zh_money_c = cs_record-zh_money / 100.
    cs_record-zs_money_c = cs_record-zs_money / 100.
    cs_record-zcost_c    = cs_record-zcost / 100.
    cs_record-zex_money_c = cs_record-zo_money_c +
                          cs_record-zn_money_c +
                          cs_record-zh_money_c.

*...// 저장된 시간에 해당하는 의무 휴게시간.
    CALL FUNCTION 'ZHR_52TM_CALC_BREAK_TIME'
      EXPORTING
        i_zbegtm   = cs_record-zbegt
        i_zendtm   = cs_record-zendt
        i_zgubun   = cs_record-zgubun
      IMPORTING
        e_zpdwk_tm = cs_record-zpdwk_tm.

*...//
    CALL FUNCTION 'ZHR_52TM_SET_DEFAULT_TIME'
      EXPORTING
        i_pernr     = cs_record-pernr
        i_znal      = cs_record-znal
        i_zgubun    = cs_record-zgubun
        i_seqnr     = cs_record-seqnr
        i_mode      = p_mode
      IMPORTING
        e_wktim01_m = cs_record-wktim01_m
        e_wktim02_m = cs_record-wktim02_m
        e_wktim03_m = cs_record-wktim03_m
        e_wktim04_m = cs_record-wktim04_m
        e_wktim05_m = cs_record-wktim05_m
        e_wktim06_m = cs_record-wktim06_m.

    PERFORM convert_time_out: USING cs_record-wktim01_m CHANGING cs_record-wktim01, "필수근로시간 OUT
                              USING cs_record-wktim02_m CHANGING cs_record-wktim02, "주중공휴일시간 OUT
                              USING cs_record-wktim03_m CHANGING cs_record-wktim03, "추가근로가능시간 OUT
                              USING cs_record-wktim04_m CHANGING cs_record-wktim04, "총근로시간 OUT
                              USING cs_record-wktim05_m CHANGING cs_record-wktim05, "근로시간 OUT
                              USING cs_record-wktim06_m CHANGING cs_record-wktim06. "초과근로시간 OUT
    IF c_code+0(1) EQ 'I'.
      c_error = 'X'.
    ENDIF.
  ELSE.
    c_error = 'X'.
  ENDIF.
*
*  IF c_code+0(1) EQ 'I'.  "정보성 메세지도 MESSAGE 표시
*
*  ENDIF.
ENDFORM.                    " GET_OVERTIME_DATA
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_MESSAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GV_ERROR_TEXT  text
*----------------------------------------------------------------------*
FORM display_message  USING    p_error_text.

  CLEAR: gv_msg_txt1, gv_msg_txt2, gv_msg_txt3, gv_msg_txt4.

  CALL FUNCTION 'ZHR_SPLIT_TEXT_N'
    EXPORTING
      longtxt = p_error_text
    IMPORTING
      msgtxt1 = gv_msg_txt1
      msgtxt2 = gv_msg_txt2
      msgtxt3 = gv_msg_txt3
      msgtxt4 = gv_msg_txt4.

  MESSAGE s000 WITH gv_msg_txt1 gv_msg_txt2 gv_msg_txt3 gv_msg_txt4.

ENDFORM.                    " DISPLAY_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  GET_PERSON_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GV_TCODE  text
*      <--P_GV_ERROR_CODE  text
*      <--P_GV_ERROR_TEXT  text
*      <--P_CS_RECORD  text
*----------------------------------------------------------------------*
FORM get_person_data CHANGING c_code
                              c_text
                              cs_record STRUCTURE gs_record.

  DATA: lv_zcost          TYPE p DECIMALS 2,
        ls_zthrbs01       TYPE zthrbs01,
        ls_personnel_data TYPE zsh_personnel_data_n,
        lv_datum          TYPE sy-datum.

  CLEAR: c_code, c_text.

  CALL FUNCTION 'ZHR_52TM_GET_PERSONNEL_DATA_N'
    EXPORTING
      i_pernr           = cs_record-pernr
      i_znal            = cs_record-znal
      i_zgubun          = cs_record-zgubun
    IMPORTING
      es_zthrbs01       = ls_zthrbs01
      es_personnel_data = ls_personnel_data
      e_code            = c_code
      e_text            = c_text.

*  CHECK c_code+0(1) IS INITIAL.

  MOVE : ls_zthrbs01-znal      TO cs_record-rdate,      " 신청일=근무일.
         ls_zthrbs01-werks     TO cs_record-werks,      " 인사영역.
         ls_zthrbs01-persg     TO cs_record-persg,      " 사원그룹.
         ls_zthrbs01-persk     TO cs_record-persk,      " 사원서브그룹.
         ls_zthrbs01-ename     TO cs_record-ename,      " 이름.
         ls_zthrbs01-orgeh     TO cs_record-orgeh,      " 소속부서.
         ls_zthrbs01-orgeh_txt TO cs_record-orgeh_txt,  " 조직이름.
         ls_zthrbs01-plans_txt TO cs_record-plans_txt,  " 포지션명.
         ls_zthrbs01-jikj      TO cs_record-jikj,       " 직종.
         ls_zthrbs01-jikk      TO cs_record-jikk,       " 직급.
         ls_zthrbs01-btrtl     TO cs_record-btrtl,      " 인사하위영역.
         ls_zthrbs01-btrtx     TO cs_record-btrtx,      " 인사하위영역명
         ls_zthrbs01-gsber     TO cs_record-gsber,      " 사업영역.
         ls_zthrbs01-gtext     TO cs_record-gtext,      " 사업영역텍스트
         ls_zthrbs01-zdung     TO cs_record-zdung,      " 등급.
         ls_zthrbs01-zkost     TO cs_record-zkost,      " 코스트센터.
         ls_zthrbs01-zzj       TO cs_record-zzj,        " 직종
         ls_zthrbs01-zgl01     TO cs_record-zgl01,      " G/L계정
         ls_zthrbs01-vdsk1     TO cs_record-vdsk1,      " 조직키
         ls_zthrbs01-vdsk1_txt TO cs_record-vdsk1_txt,  " 부서명
         ls_zthrbs01-zorder    TO cs_record-zorder,     " 직제순.
         ls_personnel_data-jikwiname_1 TO cs_record-jikwiname_1,
         ls_personnel_data-jikkname    TO cs_record-jikkname,
         ls_personnel_data-vdsk1_ftxt  TO cs_record-fname,
         ls_personnel_data-atext       TO cs_record-atext,
         ls_personnel_data-kind        TO cs_record-kind.
  cs_record-waers = 'KRW'.
*...// 등급에 따른 기준 단가.
  SELECT SINGLE zcost INTO  lv_zcost
    FROM zthrcost
    WHERE z_ctype = '1'      " 기준단가.
      AND zdung   = cs_record-zdung
      AND begda <= cs_record-znal
      AND endda => cs_record-znal
      AND zversn  = '1'.     " 활성버전

  cs_record-zcost   = lv_zcost.
  cs_record-zcost_c = lv_zcost / 100.

*...// 요일정보.
  CALL FUNCTION 'ZHR_GET_DAY_DATA_N'
    EXPORTING
      znal  = cs_record-znal
    IMPORTING
      daynr = cs_record-daynr
      zyoil = cs_record-zyoil.
ENDFORM.                    " GET_PERSON_DATA
*&---------------------------------------------------------------------*
*&      Form  CONVERT_TIME_OUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_DATA_ZOBLWKHR  text
*      <--P_CS_RECORD_WKTIM01  text
*----------------------------------------------------------------------*
FORM convert_time_out  USING    p_time
                       CHANGING c_time_out.
  DATA: lv_min TYPE char10,
        lv_out TYPE char10.

  lv_min = p_time.

  CONDENSE: lv_min.

  CALL FUNCTION 'CONVERSION_EXIT_SDURA_OUTPUT'
    EXPORTING
      input  = lv_min
    IMPORTING
      output = lv_out.

  IF lv_out+1(1) = '' .
    lv_out+1(1) = '0'.
  ENDIF.
  CONDENSE lv_out.

  c_time_out = lv_out.

ENDFORM.                    " CONVERT_TIME_OUT

*&---------------------------------------------------------------------*
*&      Form  SET_LIST_WKTP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_list_wktp .
  IF gt_wktp[] IS NOT INITIAL.
    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id              = 'GV_WKTYPE'
        values          = gt_wktp
      EXCEPTIONS
        id_illegal_name = 1
        OTHERS          = 2.
  ENDIF.
ENDFORM.                    " SET_LIST_WKTP

*&---------------------------------------------------------------------*
*&      Form  CHECK_INPUT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GV_MODE  text
*      -->P_GV_TCODE  text
*      -->P_GV_SAVEOK  text
*      <--P_GV_ERROR  text
*      <--P_GS_RECORD  text
*----------------------------------------------------------------------*
FORM check_input_data  TABLES t_approver  STRUCTURE zsh_approver
                              t_approver1 STRUCTURE zsh_approver
                        USING p_mode
                              p_wktype
                              p_saveok
                     CHANGING c_error
                              c_code
                              c_text
                              cs_record STRUCTURE gs_record.

  DATA : l_fieldname_1(40) TYPE c,
         l_fieldname_2(40) TYPE c,
         l_fieldname_3(40) TYPE c,
         l_cnt(1)          TYPE c.

  DATA: ls_error    TYPE zsh_error,
        lt_error    TYPE TABLE OF zsh_error,
        ls_zthrbs01 TYPE zthrbs01.

  FIELD-SYMBOLS : <fs_1> TYPE persno,
                  <fs_2> TYPE zename,
                  <fs_3> TYPE xubname.

* 함수호출용 데이타 전송.
  MOVE-CORRESPONDING cs_record TO ls_zthrbs01.

* 20181212 회수 변경 건 check 로직 추가
  IF ls_zthrbs01-state = '5' AND p_mode = 'M'.
    CLEAR: p_mode, ls_zthrbs01-state, ls_zthrbs01-zsangsin.
  ENDIF.
**

  CALL FUNCTION 'ZHR_52TM_CHECK_INPUT_DATA'
    EXPORTING
      i_mode      = p_mode
      i_action    = p_saveok
      i_wktype    = p_wktype
      i_wktot     = cs_record-wktim04 " 총근무시간
      i_wkreg     = cs_record-wktim05 "근로시간
      i_atime     = cs_record-wktim03 "연장가능시간
      i_wkots     = cs_record-wktim06 " 초과시간
      is_zthrbs01 = ls_zthrbs01
    IMPORTING
      e_code      = c_code
      e_text      = c_text.

  IF c_code+0(1) = 'E' OR c_code+0(1) = 'W'.
    c_error = abap_true.
    RETURN.
  ENDIF.

*  CALL FUNCTION 'ZHR_CHECK_INPUT_DATA_N'
*    EXPORTING
*      wa_bs01    = ls_zthrbs01
*      g_mode     = p_mode  " 신규('')/변경('M')구분.
*      g_type     = p_tcode  "2011.12.19
*      u_comm     = p_saveok  " USER-COMMAND.
*    IMPORTING
*      error_code = c_error_code
*      error_text = c_error_text
*    TABLES
*      it_error   = lt_error[].



* 결재자 지정정보 점검(저장 명령시에만).
  IF p_saveok = 'SAVE'.

    DO 2 TIMES.
      l_cnt = sy-index - 1.

      IF l_cnt = '0'.
        l_fieldname_1 = 'GS_RECORD-ZCOSA'.
        l_fieldname_2 = 'GS_RECORD-ZCOPE'.
        l_fieldname_3 = 'GS_RECORD-ZCID'.
      ELSE.
        CONCATENATE 'GS_RECORD-ZCOSA' l_cnt INTO l_fieldname_1.
        CONCATENATE 'GS_RECORD-ZCOPE' l_cnt INTO l_fieldname_2.
        CONCATENATE 'GS_RECORD-ZCID'  l_cnt INTO l_fieldname_3.
      ENDIF.

      ASSIGN (l_fieldname_1) TO <fs_1>.
      ASSIGN (l_fieldname_2) TO <fs_2>.
      ASSIGN (l_fieldname_3) TO <fs_3>.

      IF l_cnt = 1 AND <fs_2> IS INITIAL.
        EXIT.
      ENDIF.

      CALL FUNCTION 'ZHR_52TM_CHECK_APPROVER_N'
        EXPORTING
          pernr      = gs_record-pernr
          znal       = gs_record-znal
        IMPORTING
          error_code = c_code
          error_text = c_text
        CHANGING
          zpernr     = <fs_1>  " l_zcosa
          zename     = <fs_2>  " l_zcope
          zbname     = <fs_3>. " l_zcid

      IF c_code+0(1) = 'E'.
        c_error = abap_true.
        RETURN.
      ENDIF.
    ENDDO.

* 통상근무->10시 이후 입력시, 메시지 출력.
  ELSE.
    IF cs_record-zcope IS INITIAL.
      CALL FUNCTION 'ZHR_GET_APPROVER_DATA_N'
        EXPORTING
          pernr       = cs_record-pernr
          znal        = cs_record-znal
          zename      = cs_record-zcope
        TABLES
          it_approver = t_approver.

      CALL FUNCTION 'ZHR_GET_APPROVER_DATA_N'
        EXPORTING
          pernr       = cs_record-pernr
          znal        = cs_record-znal
          zename      = cs_record-zcope1
        TABLES
          it_approver = t_approver1.
    ENDIF.
  ENDIF.
ENDFORM.                    " CHECK_INPUT_DATA
*&---------------------------------------------------------------------*
*&      Form  CHECK_CHANGED_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GV_MODE  text
*      -->P_GV_TCODE  text
*      -->P_GV_SAVEOK  text
*      -->P_GV_ZDAEH  text
*      <--P_GV_ERROR  text
*      <--P_GV_ERROR_TEXT  text
*      <--P_GS_RECORD  text
*----------------------------------------------------------------------*
FORM check_changed_data  TABLES t_approver  STRUCTURE zsh_approver
                                t_approver1 STRUCTURE zsh_approver
                          USING p_mode
                                p_saveok
                                p_wktype
                                p_exc
                       CHANGING c_error
                                c_code
                                c_text
                                c_zemcwk_e
                                c_ztoich_e
                                c_ztomoh_e
                                c_zdaeh_e
                                cs_record    STRUCTURE gs_record.

  PERFORM check_input_data
   TABLES t_approver
          t_approver1
    USING p_mode
          p_wktype
          p_saveok
 CHANGING c_error
          c_code
          c_text
          cs_record.

  IF c_error EQ abap_true.
*    RETURN.

    FIND '업무내용' IN c_text.
    IF sy-subrc = 0.
      MESSAGE c_text TYPE 'S'.
      CLEAR c_error.
    ELSE.
      FIND '결재자' IN c_text.
      IF sy-subrc = 0.
        MESSAGE c_text TYPE 'S'.
        CLEAR c_error.
      ELSE.
        RETURN.
      ENDIF.
    ENDIF.
  ENDIF.

  PERFORM get_overtime_data
    USING p_mode
          p_saveok
          p_wktype
          p_exc
 CHANGING c_error
          c_code
          c_text
          c_zemcwk_e
          c_ztoich_e
          c_ztomoh_e
          c_zdaeh_e
          cs_record.

  IF c_error EQ abap_true. RETURN. ENDIF.
ENDFORM.                    " CHECK_CHANGED_DATA
*&---------------------------------------------------------------------*
*&      Form  SET_WKTYPE_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_WKTP  text
*      -->P_GV_ZGUBUN  text
*      <--P_GV_ERROR_CODE  text
*      <--P_GV_ERROR_TEXT  text
*----------------------------------------------------------------------*
FORM set_wktype_list  TABLES   pt_wktp STRUCTURE gs_wktp
                      USING p_pernr
                            p_datum
                    CHANGING    p_zgubun
                              p_wktype
                              c_code
                               c_text.

  DATA: ls_output   TYPE zshr0119,
        lt_output   TYPE TABLE OF zshr0119.
  DATA: ls_wktype TYPE hcmt_bsp_ddlb_value_line,
        lt_wktype TYPE hcmt_bsp_ddlb_value_table.

  CLEAR: c_code, c_text, gs_wktp, pt_wktp[].

  CALL FUNCTION 'ZHR_52TM_SET_WKTYPE_LIST'
    EXPORTING
      i_zgubun  = p_zgubun
    IMPORTING
      et_wktype = lt_wktype
      e_code    = c_code
      e_text    = c_text.

  CHECK c_code+0(1) <> 'E'.


  CALL FUNCTION 'ZHR_52TM_WKTYPE_PERIOD'
    EXPORTING
      i_pernr  = P_pernr
      i_begda  = P_DATUM
      i_endda  = P_DATUM
      i_opt    = 'X'
    TABLES
      t_output = lt_output.
  clear ls_output.
  READ TABLE lt_output INTO ls_output INDEX 1.


****
* 20190422 시차 근로자 확인
* 근로유형 0020 시차 삭제
* 시차근로자는 infotype 9023에 등록여부로 판단
data e_earlier type char1.
clear e_earlier.
CALL FUNCTION 'ZHR_52TM_EARLIER_WORKER'
  EXPORTING
    i_pernr       = p_pernr
   I_DATE        = p_datum
 IMPORTING
   E_CHK         = e_earlier.
****

  LOOP AT lt_wktype INTO ls_wktype.

    CLEAR: gs_wktp.
    gs_wktp-key = ls_wktype-domvalue_l.
    gs_wktp-text = ls_wktype-ddtext.
*    IF p_zgubun = 'A' AND  gs_wktp-key  = 'N3'  ." 시차근무 제외
*    IF ls_output-z52wktp <> '0020' AND gs_wktp-key = 'N3' . "20190422 시차근로 판단 변경
    IF e_earlier <> 'X' AND gs_wktp-key = 'N3' ."20190422 시차근로 판단 변경
    ELSEIF p_zgubun = 'C' AND p_wktype = 'S4' AND  gs_wktp-key  = 'S5'  ." 교대 제외
    ELSE.
      APPEND gs_wktp TO pt_wktp .
    ENDIF.
  ENDLOOP.
ENDFORM.                    " SET_WKTYPE_LIST
*&---------------------------------------------------------------------*
*&      Form  CLEAR_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM clear_data.
*...// SCREEN 100 으로 이동하기 전 DATA 초기화.
  CLEAR: gv_first,  gv_datum,    gv_zgubun,     gv_wktype,
         gs_record, gt_record[], gt_approver[], gt_approver1[],
         gv_zcosa,  "2019.03.21 by chl
         gv_chg_datum. "변경된 근무일 - 2019.03.21 by chl

  gv_isfst = 'X'.  "최초실행 - 019.03.21 by chl
ENDFORM.                    " CLEAR_DATA
*&---------------------------------------------------------------------*
*&      Form  GET_APPROVE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GS_RECORD_PERNR  text
*      -->P_GS_RECORD_ZNAL  text
*      <--P_GS_RECORD_ZCOSA  text
*      <--P_GS_RECORD_ZCOPE  text
*      <--P_GS_RECORD_0ZCID  text
*----------------------------------------------------------------------*
FORM get_approve TABLES pt_approver STRUCTURE zsh_approver
                  USING p_pernr
                        p_znal
               CHANGING c_zcosa      "결재자사번
                        c_zcope      "결재자성명
                        c_zcid       "결재자ID
                        c_zcosa_list "결재자리스트
                        c_error
                        c_code
                        c_text.

  CLEAR: c_error, c_code, c_text.

  IF c_zcope IS INITIAL.
    CLEAR   : c_zcosa, c_zcid, c_zcosa_list.
  ELSE.
    CLEAR   : c_code, c_text, pt_approver, pt_approver[].

    CALL FUNCTION 'ZHR_CHECK_APPROVER_N'
      EXPORTING
        pernr       = p_pernr
        znal        = p_znal
      IMPORTING
        error_code  = c_code
        error_text  = c_text
      TABLES
        it_approver = pt_approver
      CHANGING
        zpernr      = c_zcosa
        zename      = c_zcope
        zbname      = c_zcid.

    IF c_code+0(1) = 'E'.
      CLEAR : c_zcope, c_zcosa, c_zcid.
      c_error = 'X'.
      RETURN.
    ELSE.
      gv_changed = 'X'.
    ENDIF.
  ENDIF.
ENDFORM.                    " GET_APPROVE
*&---------------------------------------------------------------------*
*&      Form  SET_LIST_APPROVER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_list_approver .
  DATA: ls_approver TYPE zsh_approver,
        ls_values TYPE vrm_value,
        lt_values TYPE vrm_values.

  IF gt_approver[] IS NOT INITIAL.
    LOOP AT gt_approver INTO ls_approver.
      ls_values-key = ls_approver-pernr.
      ls_values-text = ls_approver-zptxt.
      APPEND ls_values TO lt_values. CLEAR ls_values. .
    ENDLOOP.

    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'GV_ZCOSA'
        values = lt_values[]
      EXCEPTIONS
        OTHERS = 0.

    IF gs_record-zcosa IS INITIAL.
      CLEAR gv_zcosa.
    ELSE.
      gv_zcosa = gs_record-zcosa.  " 초기값 선택.
    ENDIF.
  ENDIF.

  IF gt_approver1[] IS NOT INITIAL.
    LOOP AT gt_approver1 INTO ls_approver.
      ls_values-key  = ls_approver-pernr.
      ls_values-text = ls_approver-zptxt.
      APPEND ls_values TO lt_values. CLEAR ls_values. .
    ENDLOOP.

    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'GV_ZCOSA1'
        values = lt_values[]
      EXCEPTIONS
        OTHERS = 0.

    IF gs_record-zcosa1 IS INITIAL.
      CLEAR gv_zcosa1.
    ELSE.
      gv_zcosa1 = gs_record-zcosa1.  " 초기값 선택.
    ENDIF.
  ENDIF.
ENDFORM.                    " SET_LIST_APPROVER
*&---------------------------------------------------------------------*
*&      Form  SET_LIST_STYPE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM set_list_stype .
  DATA: ls_values TYPE vrm_value,
        lt_values TYPE vrm_values.

  IF gv_stype IS INITIAL.
    ls_values-key = 'A'.
    ls_values-text = '전체'.
    APPEND ls_values TO lt_values. CLEAR ls_values.
    ls_values-key = 'D'.
    ls_values-text = '미상신'.
    APPEND ls_values TO lt_values. CLEAR ls_values.
    ls_values-key = 'P'.
    ls_values-text = '결재중'.
    APPEND ls_values TO lt_values. CLEAR ls_values.
    ls_values-key = 'Y'.
    ls_values-text = '승인'.
    APPEND ls_values TO lt_values. CLEAR ls_values.
    ls_values-key = 'N'.
    ls_values-text = '반려'.
    APPEND ls_values TO lt_values. CLEAR ls_values.

    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        id     = 'GV_STYPE'  " screen에 보여줄 list의 필드명.
        values = lt_values[]  " key와 text로된 table.
      EXCEPTIONS
        OTHERS = 0.

    gv_stype = 'A'.                   " 디폴트->전체.

  ENDIF.

ENDFORM.                    " SET_LIST_STYPE
*&---------------------------------------------------------------------*
*&      Form  SET_SEARCH_DATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_P_DATUM  text
*----------------------------------------------------------------------*
FORM set_search_date USING p_datum.

  IF gv_sbegda IS INITIAL AND gv_sendda IS INITIAL.
    CONCATENATE p_datum+0(6) '01' INTO gv_sbegda.

    CALL FUNCTION 'LAST_DAY_OF_MONTHS'
      EXPORTING
        day_in            = gv_sbegda
      IMPORTING
        last_day_of_month = gv_sendda
      EXCEPTIONS
        day_in_no_date    = 1
        OTHERS            = 2.

  ENDIF.
ENDFORM.                    " SET_SEARCH_DATE
*&---------------------------------------------------------------------*
*&      Form  GET_TABLE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_RECORD  text
*      -->P_GS_RECORD_PERNR  text
*      -->P_GV_SBEGDA  text
*      -->P_GV_SENDDA  text
*      -->P_GV_STYPE  text
*----------------------------------------------------------------------*
FORM get_table_data TABLES pt_record STRUCTURE gs_record
                     USING p_pernr
                           p_sbegda
                           p_sendda
                           p_stype.

  DATA: lv_lines    TYPE i,
        ls_record   LIKE gs_record,
        ls_zthrbs01 TYPE zthrbs01,
        lt_zthrbs01 TYPE TABLE OF zthrbs01.

  CLEAR: pt_record[].

  CALL FUNCTION 'ZHR_52TM_GET_OVERTIME_LIST'
    EXPORTING
      i_pernr = p_pernr
      i_begda = p_sbegda
      i_endda = p_sendda
      i_stype = p_stype
    TABLES
      t_data  = lt_zthrbs01.

  LOOP AT lt_zthrbs01 INTO ls_zthrbs01.
    CLEAR ls_record.
    MOVE-CORRESPONDING ls_zthrbs01 TO ls_record.
    ls_record-zmoney_c   = ls_record-zmoney / 100.
    ls_record-zdangt_c   = ls_record-zdangt / 100.
    ls_record-zs_money_c = ls_record-zs_money / 100.
    ls_record-ztot_c     = ( ls_record-zmoney + ls_record-zdangt ) / 100.
    ls_record-waers      = 'KRW'.

    " 결재상황.
    IF ls_record-state = '0' OR ls_record-state IS INITIAL.
      IF NOT ls_record-zsangsin IS INITIAL.
        ls_record-state_txt = '결재중'.
      ELSE.
        ls_record-state_txt = '미상신'.
      ENDIF.
    ENDIF.

    IF NOT ls_record-zsangsin IS INITIAL.    " 상신 Flag 변경.
      ls_record-zsangsin  = 'Y'.
    ENDIF.

    IF NOT ls_record-znurak IS INITIAL.
      CONCATENATE '[누락]' ls_record-ztext INTO ls_record-ztext.
    ENDIF.

    IF ls_record-ztomo IS NOT INITIAL.    " 익일.
      ls_record-ztomo = 'X'.
    ENDIF.

    IF ls_record-ztoich IS NOT INITIAL.   " 퇴출.
      ls_record-ztoich = 'X'.
    ENDIF.

    IF ls_record-zdaeh IS NOT INITIAL.    " 대휴.
      ls_record-zdaeh = 'X'.
    ENDIF.

    IF ls_record-ztomoh IS NOT INITIAL.   " 익휴(익일일근면제)여부.
      ls_record-ztomoh = 'X'.
    ENDIF.

    IF ls_record-zemcwk IS NOT INITIAL.   " 재난
      ls_record-zemcwk = 'X'.
    ENDIF.

    IF ls_record-znurak IS NOT INITIAL.   " 누락여부.
      ls_record-znurak = 'X'.
    ENDIF.

    APPEND ls_record TO gt_record.

  ENDLOOP.

  SORT gt_record DESCENDING BY znal zbegt.  " 최근 근무순.

* Table Control 라인수 설정.
  DESCRIBE TABLE gt_record LINES lv_lines.
  tc_0100-lines = lv_lines.

  gv_fieldname = `GV_SBEGDA`.
ENDFORM.                    " GET_TABLE_DATA
*&---------------------------------------------------------------------*
*&      Form  CHECK_SELECTED
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM check_selected TABLES pt_record STRUCTURE gs_record
                     USING p_saveok
                  CHANGING c_error
                           c_text.
  DATA: it_agr_users TYPE TABLE OF agr_users.

  DATA: ls_record   LIKE gs_record,
        ls_zthrsum1 TYPE zthrsum1,
        ls_zthrbs01 LIKE zthrbs01,
        lv_zyear  LIKE zthrsum1-zyear,
        lv_zmonth LIKE zthrsum1-zmonth,
        lv_datum  LIKE sy-datum,
        lv_lines TYPE i,
        lv_code(1),
        lv_text1(132),
        lv_text2(132).

  READ TABLE pt_record TRANSPORTING NO FIELDS WITH KEY mark = 'X'.
  IF sy-subrc NE 0.
    c_error = 'X'.
    c_text  = text-s01.
  ELSE.
    LOOP AT pt_record INTO ls_record WHERE mark = 'X'.
      ADD 1 TO lv_lines.

      SELECT SINGLE * INTO ls_zthrbs01
        FROM zthrbs01
       WHERE pernr EQ ls_record-pernr
         AND rdate EQ ls_record-rdate
         AND seqnr EQ ls_record-seqnr.

      IF sy-subrc EQ 0.
        CASE  p_saveok.
          WHEN 'APPR' .    " 결재상신(APPR),
            IF  p_saveok = 'APPR'.
              lv_text2 = '결재상신이 불가합니다. 확인하세요!'.
            ELSEIF p_saveok = 'MODI'.
              lv_text2 = '변경이 불가합니다. 확인하세요!'.
            ENDIF.

            IF ls_zthrbs01-state = '2'.      " 삭제.
              lv_code  = 'E'.
              lv_text1 = text-s10.
              EXIT.
            ELSEIF ls_zthrbs01-state = '5'.  " 회수.
              lv_code =  'E'.
              lv_text1 =  text-s11.
              EXIT.
            ELSEIF ls_zthrbs01-state = '9'.  " 반려.
              lv_code =  'E'.
              lv_text1 =  text-s12.
              EXIT.
            ELSEIF ls_zthrbs01-state = 'F'.  " 미결.
              lv_code =  'E'.
              lv_text1 =  text-s13.
              EXIT.
            ELSEIF NOT ls_zthrbs01-zsangsin IS INITIAL.  " 상신.
              IF ls_zthrbs01-state = '3'.    " 승인
                SELECT * FROM agr_users INTO CORRESPONDING FIELDS OF TABLE it_agr_users  "시간외 담당자만 허용
                  WHERE uname = sy-uname AND agr_name = 'CR2_0178'.
                IF sy-subrc NE 0.
                  lv_code =  'E'.
                  lv_text1 =  text-s16.
                  EXIT.
                ENDIF.
              ELSE.                      " 결재중.
                lv_code =  'E'.
                lv_text1 =  text-s14.
                EXIT.
              ENDIF.
            ENDIF.

          WHEN 'MODI'.    " 변경(MODI)
            IF  p_saveok = 'APPR'.
              lv_text2 = '결재상신이 불가합니다. 확인하세요!'.
            ELSEIF p_saveok = 'MODI'.
              lv_text2 = '변경이 불가합니다. 확인하세요!'.
            ENDIF.

            IF ls_zthrbs01-state = '2'.      " 삭제.
              lv_code  = 'E'.
              lv_text1 = text-s10.
              EXIT.
*            ELSEIF ls_zthrbs01-state = '5'.  " 회수.
*              lv_code =  'E'.
*              lv_text1 =  text-s11.
              EXIT.
            ELSEIF ls_zthrbs01-state = '9'.  " 반려.
              lv_code =  'E'.
              lv_text1 =  text-s12.
              EXIT.
            ELSEIF ls_zthrbs01-state = 'F'.  " 미결.
              lv_code =  'E'.
              lv_text1 =  text-s13.
              EXIT.
            ELSEIF NOT ls_zthrbs01-zsangsin IS INITIAL.  " 상신.
              IF ls_zthrbs01-state = '3'.    " 승인
                SELECT * FROM agr_users INTO CORRESPONDING FIELDS OF TABLE it_agr_users "시간외 담당자만 허용
                  WHERE uname = sy-uname AND agr_name = 'CR2_0178'.
                IF sy-subrc NE 0.
                  lv_code =  'E'.
                  lv_text1 =  text-s16.
                  EXIT.
                ENDIF.
              ELSEIF ls_zthrbs01-state = '5'.   " 회수
              ELSE.                      " 결재중.
                lv_code =  'E'.
                lv_text1 =  text-s14.
                EXIT.
              ENDIF.
            ENDIF.


          WHEN 'DELE'.  " 삭제.
            lv_text2 = '삭제가 불가합니다. 확인하세요!'.

            IF ls_zthrbs01-state = '2'.      " 삭제.
              lv_code =  'E'.
              lv_text1 =  text-s10.
              EXIT.
*- 결재상태가 '회수'인경우, 삭제기능 추가(2018.11.14)
*            ELSEIF ls_zthrbs01-state = '5'.  " 회수.
*              lv_code =  'E'.
*              lv_text1 =  text-s11.
*              EXIT.
*            ELSEIF ls_zthrbs01-state = '9'.  " 반려.
*              lv_code =  'E'.
*              lv_text1 =  text-s12.
*              EXIT.
*            ELSEIF ls_zthrbs01-state = 'F'.  " 미결.
*              lv_code =  'E'.
*              lv_text1 =  text-s13.
*              EXIT.
            ELSEIF NOT ls_zthrbs01-zsangsin IS INITIAL.  " 결재중&&승인
              IF ls_zthrbs01-state = '3'.                " 승인
                SELECT * FROM agr_users INTO CORRESPONDING FIELDS OF TABLE it_agr_users "시간외 담당자만 허용
                  WHERE uname = sy-uname AND agr_name = 'CR2_0178'.
                IF sy-subrc = 0.
                ELSE.
                  IF ls_zthrbs01-znurak IS INITIAL.
                    MOVE : ls_zthrbs01-znal+0(4) TO lv_zyear,
                           ls_zthrbs01-znal+4(2) TO lv_zmonth.
                  ELSE.
                    IF ls_zthrbs01-aedtm+6(2) <= '05'.
                      CONCATENATE ls_zthrbs01-aedtm+0(6) '01' INTO lv_datum.
                      lv_datum = lv_datum - 1.
                      MOVE : lv_datum+0(4) TO lv_zyear,
                             lv_datum+4(2) TO lv_zmonth.
                    ELSE.
                      MOVE : ls_zthrbs01-aedtm+0(4) TO lv_zyear,
                             ls_zthrbs01-aedtm+4(2) TO lv_zmonth.
                    ENDIF.
                  ENDIF.

                  SELECT SINGLE * INTO ls_zthrsum1
                    FROM zthrsum1
                   WHERE zpernr = ls_record-pernr
                     AND zyear  = lv_zyear
                     AND zmonth = lv_zmonth.
                  IF sy-subrc = 0.
                    lv_code =  'E'.
                    lv_text1 =  text-s15.
                    EXIT.
                  ENDIF.
                ENDIF.
              ELSE.
                IF ls_zthrbs01-state <> '5'." 회수가 아니면
                  lv_code =  'E'.
                  lv_text1 =  text-s14.
                  EXIT.
                ENDIF.                               " 결재중.
              ENDIF.
            ENDIF.
          WHEN 'RETR'.  " 회수.
            lv_text2 = '회수가 불가합니다. 확인하세요!'.

            IF ls_zthrbs01-state = '2'.      " 삭제.
              lv_code =  'E'.
              lv_text1 =  text-s10.
              EXIT.
            ELSEIF ls_zthrbs01-state = '3'.  " 승인.
              lv_code =  'E'.
              lv_text1 =  text-s16.
              EXIT.
            ELSEIF ls_zthrbs01-state = '5'.  " 회수.
              lv_code =  'E'.
              lv_text1 =  text-s11.
              EXIT.
            ELSEIF ls_zthrbs01-state = '9'.  " 반려.
              lv_code =  'E'.
              lv_text1 =  text-s12.
              EXIT.
            ELSEIF ls_zthrbs01-state = 'F'.  " 미결.
              lv_code =  'E'.
              lv_text1 =  text-s13.
              EXIT.
            ELSEIF ls_zthrbs01-zsangsin IS INITIAL.  " 미상신.
              lv_code =  'E'.
              lv_text1 =  text-s17.
              EXIT.
            ENDIF.
        ENDCASE.
      ENDIF.
    ENDLOOP.

    IF lv_code = 'E'.
      c_error =  'X'.

      CONCATENATE lv_text1 lv_text2
                  INTO c_text SEPARATED BY space.

      RETURN.
    ENDIF.

    IF p_saveok = 'MODI' AND lv_lines > 1.
      c_error = 'X'.
      c_text  = text-s02.
    ENDIF.
  ENDIF.
ENDFORM.                    " CHECK_SELECTED
*&---------------------------------------------------------------------*
*&      Form  MOVE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_RECORD  text
*      <--P_GV_ERROR  text
*      <--P_GV_ERROR_TEXT  text
*----------------------------------------------------------------------*
FORM move_data TABLES pt_record STRUCTURE gs_record
             CHANGING cs_record STRUCTURE gs_record
                      c_error
                      c_text
                      c_zemcwk_e
                      c_ztoich_e
                      c_ztomoh_e
                      c_zdaeh_e.

* 변경->데이타 전송(IT_BS01),저장->저장기능.
  DATA: lv_wktype      TYPE zewktype,
        lv_code(3)     TYPE c,
        ls_record      LIKE cs_record,
        ls_person_data TYPE zsh_personnel_data_n.

  CLEAR: c_error, c_text.

  READ TABLE pt_record INTO ls_record WITH KEY mark = 'X'.
  IF sy-subrc = 0.
    CLEAR cs_record.

    MOVE-CORRESPONDING ls_record TO cs_record.

    PERFORM get_person_data
   CHANGING lv_code
            c_text
            cs_record.
    IF lv_code+0(1) <> 'E'.

      gv_mode = 'M'. "변경모드
      " 변경이면, 최초 가 아님
      c_ztomoh_e = 'X'.
      c_zdaeh_e = 'X'.
      c_ztoich_e = 'X'.
      c_zemcwk_e = 'X'.

      PERFORM get_overtime_data
        USING gv_mode
              ''
              lv_wktype
              gv_exc
     CHANGING c_error
              lv_code
              c_text
              c_zemcwk_e
              c_ztoich_e
              c_ztomoh_e
              c_zdaeh_e
              cs_record.

      gv_zgubun = cs_record-zgubun.
      CALL FUNCTION 'ZHR_52TM_CONVERT_ZGUBUN_WKTYPE'
        EXPORTING
          i_zgubun = gv_zgubun
          i_flexty = cs_record-zyuhyung
        IMPORTING
          e_wktype = gv_wktype.



*...// 결재자 정보
      IF cs_record-zcope IS NOT INITIAL.
        CLEAR: gt_approver[].

        PERFORM get_approve
         TABLES gt_approver
          USING cs_record-pernr
                cs_record-znal
       CHANGING cs_record-zcosa "결재자사번
                cs_record-zcope "결재자성명
                cs_record-zcid  "결재자ID
                gv_zcosa        "결재자리스트
                c_error
                gv_error_code
                c_text.
      ENDIF.

      IF gs_record-zcope1 IS NOT INITIAL.
        CLEAR gt_approver1[].

        PERFORM get_approve
         TABLES gt_approver1
          USING cs_record-pernr
                cs_record-znal
       CHANGING cs_record-zcosa1 "결재자사번
                cs_record-zcope1 "결재자성명
                cs_record-zcid1  "결재자ID
                gv_zcosa1        "결재자리스트
                c_error
                gv_error_code
                c_text.

      ENDIF.
    ELSE.
      c_error = 'X'.
      RETURN.
    ENDIF.
  ENDIF.
ENDFORM.                    " MOVE_DATA
*&---------------------------------------------------------------------*
*&      Form  POPUP_TO_COMFIRM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM popup_to_comfirm USING p_saveok
                   CHANGING c_error.

  DATA : lv_text(100)      TYPE c,
         lv_button_txt(10) TYPE c,
         lv_icon_1         LIKE icon-name,
         lv_icon_2         LIKE icon-name,
         lv_answer(1)      TYPE c.

  CLEAR: c_error.

  lv_icon_1 = 'ICON_OKAY'.
  lv_icon_2 = 'ICON_CANCEL'.

  CASE p_saveok.
    WHEN 'APPR'.
      lv_text = text-t01.
      lv_button_txt = '상 신'.

    WHEN 'MODI'.
      lv_text = text-t02.
      lv_button_txt = '확 인'.

    WHEN 'DELE'.
      lv_text = text-t03.
      lv_button_txt = '삭 제'.

    WHEN 'RETR'.
      lv_text = text-t04.
      lv_button_txt = '회 수'.
  ENDCASE.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = '확 인'
      text_question         = lv_text
      text_button_1         = lv_button_txt
      icon_button_1         = lv_icon_1
      text_button_2         = '취 소'
      icon_button_2         = lv_icon_2
      default_button        = '1'
      display_cancel_button = ''
      start_column          = 25
      start_row             = 6
    IMPORTING
      answer                = lv_answer.

  IF lv_answer NE '1'.
    c_error = 'X'.
    MESSAGE s000 WITH '실행을 취소하셨습니다.'.
  ENDIF.
ENDFORM.                    " POPUP_TO_COMFIRM
*&---------------------------------------------------------------------*
*&      Form  APPROVE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_RECORD  text
*      <--P_GV_ERROR  text
*      <--P_GV_ERROR_TEXT  text
*----------------------------------------------------------------------*
FORM request_data TABLES pt_record STRUCTURE gs_record
                   USING p_pernr
                         p_sbegda
                         p_sendda
                         p_stype
                CHANGING c_error
                         c_text.

  DATA: lv_error_code TYPE char03,
        lv_error_text TYPE char200,
        ls_record     LIKE gs_record,
        ls_zthrbs01   TYPE zthrbs01,
        lt_zthrbs01   TYPE TABLE OF zthrbs01.

  LOOP AT pt_record INTO ls_record WHERE mark EQ 'X'.
    CLEAR: ls_zthrbs01.
    MOVE-CORRESPONDING ls_record TO ls_zthrbs01.

    APPEND ls_zthrbs01 TO lt_zthrbs01.
  ENDLOOP.

  IF lt_zthrbs01[] IS NOT INITIAL.
    CALL FUNCTION 'ZHR_52TM_GET_OVERTIME_REQUEST'
      IMPORTING
        e_code = lv_error_code
        e_text = lv_error_text
      TABLES
        t_data = lt_zthrbs01.
    IF lv_error_code+0(1) EQ 'E'.
      c_error = 'X'.
      c_text  = lv_error_text.
    ELSE. "결재처리후 DATA READ
      PERFORM get_table_data
       TABLES pt_record       "시간외실비 내역
        USING p_pernr "시간외실비 대상자사번
              p_sbegda       "검색기간 시작일
              p_sendda       "검색기간 종료일
              p_stype.       "검색유형
    ENDIF.
  ELSE.
    c_error = 'X'.
    c_text = text-e02.
  ENDIF.
ENDFORM.                    " APPROVE_DATA
*&---------------------------------------------------------------------*
*&      Form  DELETE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_RECORD  text
*      -->P_GS_RECORD_PERNR  text
*      -->P_GV_SBEGDA  text
*      -->P_GV_SENDDA  text
*      -->P_GV_STYPE  text
*      <--P_GV_ERROR  text
*      <--P_GV_ERROR_TEXT  text
*----------------------------------------------------------------------*
FORM delete_data TABLES pt_record STRUCTURE gs_record
                   USING p_pernr
                         p_sbegda
                         p_sendda
                         p_stype
                CHANGING c_error
                         c_text.

  DATA: lv_error_code TYPE char03,
        lv_error_text TYPE char200,
        ls_record     LIKE gs_record,
        ls_zthrbs01   TYPE zthrbs01,
        lt_zthrbs01   TYPE TABLE OF zthrbs01.

  LOOP AT pt_record INTO ls_record WHERE mark EQ 'X'.
    CLEAR: ls_zthrbs01.
    MOVE-CORRESPONDING ls_record TO ls_zthrbs01.

    APPEND ls_zthrbs01 TO lt_zthrbs01.
  ENDLOOP.

  IF lt_zthrbs01[] IS NOT INITIAL.

    CALL FUNCTION 'ZHR_52TM_GET_OVERTIME_DELETE'
      IMPORTING
        e_code = lv_error_code
        e_text = lv_error_text
      TABLES
        t_data = lt_zthrbs01.

    IF lv_error_code+0(1) EQ 'E'.
      c_error = 'X'.
      c_text  = lv_error_text.
    ELSE. "결재처리후 DATA READ
      PERFORM get_table_data
       TABLES pt_record       "시간외실비 내역
        USING p_pernr "시간외실비 대상자사번
              p_sbegda       "검색기간 시작일
              p_sendda       "검색기간 종료일
              p_stype.       "검색유형
    ENDIF.
  ELSE.
    c_error = 'X'.
    c_text = text-e03.
  ENDIF.
ENDFORM.                    " DELETE_DATA
*&---------------------------------------------------------------------*
*&      Form  RETURN_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GT_RECORD  text
*      -->P_GS_RECORD_PERNR  text
*      -->P_GV_SBEGDA  text
*      -->P_GV_SENDDA  text
*      -->P_GV_STYPE  text
*      <--P_GV_ERROR  text
*      <--P_GV_ERROR_TEXT  text
*----------------------------------------------------------------------*
FORM return_data  TABLES pt_record STRUCTURE gs_record
                   USING p_pernr
                         p_sbegda
                         p_sendda
                         p_stype
                CHANGING c_error
                         c_text.

  DATA: lv_error_code TYPE char03,
        lv_error_text TYPE char200,
        ls_record     LIKE gs_record,
        ls_zthrbs01   TYPE zthrbs01,
        lt_zthrbs01   TYPE TABLE OF zthrbs01.

  LOOP AT pt_record INTO ls_record WHERE mark EQ 'X'.
    CLEAR: ls_zthrbs01.
    MOVE-CORRESPONDING ls_record TO ls_zthrbs01.

    APPEND ls_zthrbs01 TO lt_zthrbs01.
  ENDLOOP.

  IF lt_zthrbs01[] IS NOT INITIAL.
    CALL FUNCTION 'ZHR_52TM_GET_OVERTIME_RETURN'
      IMPORTING
        e_code = lv_error_code
        e_text = lv_error_text
      TABLES
        t_data = lt_zthrbs01.

    IF lv_error_code+0(1) EQ 'E'.
      c_error = 'X'.
      c_text  = lv_error_text.
    ELSE. "결재처리후 DATA READ
      PERFORM get_table_data
       TABLES pt_record       "시간외실비 내역
        USING p_pernr "시간외실비 대상자사번
              p_sbegda       "검색기간 시작일
              p_sendda       "검색기간 종료일
              p_stype.       "검색유형
    ENDIF.
  ELSE.
    c_error = 'X'.
    c_text = text-e04.
  ENDIF.
ENDFORM.                    " RETURN_DATA
*&---------------------------------------------------------------------*
*&      Form  REFRESH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM refresh_data .
  CLEAR: gv_first, gs_record.
ENDFORM.                    " REFRESH_DATA
*&---------------------------------------------------------------------*
*&      Form  MODIFY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM modify.
  PERFORM check_selected
   TABLES gt_record
    USING gv_saveok
 CHANGING gv_error
          gv_error_text.
  IF gv_error EQ abap_true.
    PERFORM display_message USING gv_error_text.
    CLEAR gv_error. RETURN.
  ENDIF.

  PERFORM popup_to_comfirm
     USING gv_saveok
  CHANGING gv_error.
  IF gv_error EQ abap_true.
    RETURN.
  ENDIF.

  PERFORM move_data
   TABLES gt_record
 CHANGING gs_record
          gv_error
          gv_error_text
          gv_zemcwk_e
          gv_ztoich_e
          gv_ztomoh_e
          gv_zdaeh_e.
  IF gv_error EQ abap_true.
    PERFORM display_message USING gv_error_text.
    CLEAR gv_error. RETURN.
  ENDIF.
ENDFORM.                    " MODIFY_DATA
*&---------------------------------------------------------------------*
*&      Form  REQUEST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM request .
  PERFORM check_selected
   TABLES gt_record
    USING gv_saveok
 CHANGING gv_error
          gv_error_text.
  IF gv_error EQ abap_true.
    PERFORM display_message USING gv_error_text.
    CLEAR gv_error. RETURN.
  ENDIF.

  PERFORM popup_to_comfirm
     USING gv_saveok
  CHANGING gv_error.
  IF gv_error EQ abap_true.
    RETURN.
  ENDIF.

  PERFORM request_data
   TABLES gt_record
    USING gs_record-pernr "시간외실비 대상자사번
          gv_sbegda       "검색기간 시작일
          gv_sendda       "검색기간 종료일
          gv_stype        "검색유형
 CHANGING gv_error
          gv_error_text.
  IF gv_error EQ abap_true.
    PERFORM display_message USING gv_error_text.
    CLEAR gv_error. RETURN.
  ENDIF.
ENDFORM.                    " REQUEST
*&---------------------------------------------------------------------*
*&      Form  DELETE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM delete .
  PERFORM check_selected
   TABLES gt_record
    USING gv_saveok
 CHANGING gv_error
          gv_error_text.
  IF gv_error EQ abap_true.
    PERFORM display_message USING gv_error_text.
    CLEAR gv_error. RETURN.
  ENDIF.

  PERFORM popup_to_comfirm
     USING gv_saveok
  CHANGING gv_error.
  IF gv_error EQ abap_true.
    RETURN.
  ENDIF.

  PERFORM delete_data
   TABLES gt_record
    USING gs_record-pernr "시간외실비 대상자사번
          gv_sbegda       "검색기간 시작일
          gv_sendda       "검색기간 종료일
          gv_stype        "검색유형
 CHANGING gv_error
          gv_error_text.
  IF gv_error EQ abap_true.
    PERFORM display_message USING gv_error_text.
    CLEAR gv_error. RETURN.
  ENDIF.
ENDFORM.                    " DELETE
*&---------------------------------------------------------------------*
*&      Form  RETURN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM return .
  PERFORM check_selected
   TABLES gt_record
    USING gv_saveok
 CHANGING gv_error
          gv_error_text.
  IF gv_error EQ abap_true.
    PERFORM display_message USING gv_error_text.
    CLEAR gv_error. RETURN.
  ENDIF.

  PERFORM popup_to_comfirm
     USING gv_saveok
  CHANGING gv_error.
  IF gv_error EQ abap_true.
    RETURN.
  ENDIF.

  PERFORM return_data
   TABLES gt_record
    USING gs_record-pernr "시간외실비 대상자사번
          gv_sbegda       "검색기간 시작일
          gv_sendda       "검색기간 종료일
          gv_stype        "검색유형
 CHANGING gv_error
          gv_error_text.
  IF gv_error EQ abap_true.
    PERFORM display_message USING gv_error_text.
    CLEAR gv_error. RETURN.
  ENDIF.
ENDFORM.                    " RETURN
*&---------------------------------------------------------------------*
*&      Form  CHECK_CHANGED
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM check_changed .
  PERFORM check_changed_data
   TABLES gt_approver
          gt_approver1
    USING gv_mode
          gv_saveok
          gv_wktype
          gv_exc
 CHANGING gv_error
          gv_error_code
          gv_error_text
          gv_zemcwk_e
          gv_ztoich_e
          gv_ztomoh_e
          gv_zdaeh_e
          gs_record.

  IF gv_error EQ abap_true.
    PERFORM display_message USING gv_error_text.
    CLEAR gv_error.
  ENDIF.

  CLEAR gv_changed.
ENDFORM.                    " CHECK_CHANGED
*&---------------------------------------------------------------------*
*&      Form  SAVE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM save .
  DATA : ls_zthrbs01      TYPE zthrbs01,
         ls_overtime_data TYPE zsh_overtime_data_n.

*...// 입력 DATA CHECK.
  PERFORM check_input_data
   TABLES gt_approver
          gt_approver1
    USING gv_mode
          gv_wktype
          gv_saveok
 CHANGING gv_error
          gv_error_code
          gv_error_text
          gs_record.

  IF gv_error EQ abap_true.
    PERFORM display_message USING gv_error_text.
    CLEAR gv_error. RETURN.
  ENDIF.

  PERFORM save_data
    USING gv_mode
          gv_saveok
          gv_wktype
          gv_exc
 CHANGING gv_error
          gv_error_code
          gv_error_text
          gs_record.

  IF gv_error EQ abap_true.
    PERFORM display_message USING gv_error_text.
    CLEAR gv_error. RETURN.
  ENDIF.
ENDFORM.                    " SAVE
*&---------------------------------------------------------------------*
*&      Form  SEARCH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM search .
  PERFORM get_table_data
   TABLES gt_record       "시간외실비 내역
    USING gs_record-pernr "시간외실비 대상자사번
          gv_sbegda       "검색기간 시작일
          gv_sendda       "검색기간 종료일
          gv_stype.       "검색유형
ENDFORM.                    " SEARCH
*&---------------------------------------------------------------------*
*&      Form  SAVE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_GV_MODE  text
*      -->P_GV_SAVEOK  text
*      <--P_GV_ERROR  text
*      <--P_GV_ERROR_CODE  text
*      <--P_GV_ERROR_TEXT  text
*      <--P_GS_RECORD  text
*----------------------------------------------------------------------*
FORM save_data USING p_mode
                     p_saveok
                     p_wktype
                     p_exc
            CHANGING c_error
                     c_code
                     c_text
                     cs_record STRUCTURE gs_record.

  DATA : lv_code     TYPE char03,
         lv_text     TYPE char200,
         ls_zthrbs01 TYPE zthrbs01,
         lt_zthrbs01 TYPE TABLE OF zthrbs01.

  MOVE-CORRESPONDING cs_record TO ls_zthrbs01.

*  CALL FUNCTION 'ZHR_52TM_GET_OVERTIME_SAVE'
*    EXPORTING
*      i_mode      = p_mode
*      i_wktype    = p_wktype
*      i_action    = p_saveok
*      is_zthrbs01 = ls_zthrbs01
*    IMPORTING
*      e_code      = lv_code
*      e_text      = lv_text
*    TABLES
*      t_data      = lt_zthrbs01.

* 20181212 회수 변경 건 check 로직 추가
  IF ls_zthrbs01-state = '5' .
    CLEAR: p_mode, ls_zthrbs01-state, ls_zthrbs01-state_txt, ls_zthrbs01-zsangsin.
  ENDIF.
**


  CALL FUNCTION 'ZHR_52TM_GET_OVERTIME_SAVE'
    EXPORTING
      i_mode      = p_mode
      i_wktype    = p_wktype
      i_action    = p_saveok
      i_zexc      = p_exc
      i_seqnr     = ls_zthrbs01-seqnr
      i_run_r3    = 'X'
      is_zthrbs01 = ls_zthrbs01
    IMPORTING
      e_code      = lv_code
      e_text      = lv_text
    TABLES
      t_data      = lt_zthrbs01
    CHANGING
      c_ztomoh    = gv_ztomoh_e
      c_zdaeh     = gv_zdaeh_e
      c_ztoich    = gv_ztoich_e
      c_zemcwk    = gv_zemcwk_e.


  IF lv_code+0(1) EQ 'E'.
    c_error = 'X'. c_text = lv_text.  RETURN.
  ENDIF.

  MODIFY zthrbs01 FROM TABLE lt_zthrbs01.
  IF sy-subrc = 0.
    IF gv_mode <> 'M'.
      MESSAGE s000 WITH text-001.
    ELSE.
      MESSAGE s000 WITH text-003.
      CLEAR gv_mode.
    ENDIF.

    PERFORM refresh_data.            " 입력 초기화.
  ELSE.
    c_error = 'X'.

    c_text =  text-002.
  ENDIF.
ENDFORM.                    " SAVE_DATA
*&---------------------------------------------------------------------*
*&      Form  CHANGE_ZCOSA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM change_zcosa .
  "결재자 사번
  gs_record-zcosa = gv_zcosa.

  "결재자 성명
  CLEAR gs_record-zcope.
  SELECT SINGLE ename
    INTO gs_record-zcope
    FROM pa0001
   WHERE pernr = gs_record-zcosa
     AND endda >= sy-datum
     AND begda <= sy-datum
     AND persg = '1'.
ENDFORM.                    " CHANGE_ZCOSA
*&---------------------------------------------------------------------*
*&      Form  CHANGE_WK_DATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM change_wk_date .
  DATA lv_date TYPE workflds-gkday.

  CALL FUNCTION 'F4_DATE'
   EXPORTING
     date_for_first_month               = sy-datum
*     DISPLAY                            = ' '
*     FACTORY_CALENDAR_ID                = ' '
*     GREGORIAN_CALENDAR_FLAG            = ' '
*     HOLIDAY_CALENDAR_ID                = ' '
*     PROGNAME_FOR_FIRST_MONTH           = ' '
*     DATE_POSITION                      = ' '
   IMPORTING
     select_date                        = lv_date
*     SELECT_WEEK                        =
*     SELECT_WEEK_BEGIN                  =
*     SELECT_WEEK_END                    =
   EXCEPTIONS
     calendar_buffer_not_loadable       = 1
     date_after_range                   = 2
     date_before_range                  = 3
     date_invalid                       = 4
     factory_calendar_not_found         = 5
     holiday_calendar_not_found         = 6
     parameter_conflict                 = 7
     OTHERS                             = 8.

  IF lv_date IS NOT INITIAL.
    IF gv_datum <> lv_date.
      CLEAR gv_first.
      gv_datum = lv_date.
    ENDIF.
  ENDIF.

ENDFORM.                    " CHANGE_WK_DATE
