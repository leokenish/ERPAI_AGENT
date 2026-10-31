FUNCTION zhr_52tm_mobile_overtime_appr.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(I_MODE) TYPE  CHAR01
*"     VALUE(I_ACTION) TYPE  SYUCOMM
*"     VALUE(IS_ZSHR0131) TYPE  ZSHR0131 OPTIONAL
*"     VALUE(I_SEQNR) TYPE  SEQNR
*"  EXPORTING
*"     VALUE(E_PERNR) TYPE  PERSNO
*"     VALUE(E_DATUM) TYPE  DATUM
*"     VALUE(E_SEQNR) TYPE  SEQNR
*"     VALUE(E_RETURN) LIKE  BAPIRETURN1 STRUCTURE  BAPIRETURN1
*"----------------------------------------------------------------------
*- (Mobile) 통상/교대 시간외신청관리

  DATA : ls_zthrbs01 TYPE zthrbs01,
         lt_zthrbs01 LIKE TABLE OF ls_zthrbs01,
         ls_zshr0131 TYPE zshr0131,
         l_mode      TYPE c,
         l_tmp_zgubun TYPE zbsgubun,
         lv_zrlovrwkhr TYPE i,
         lv_ze_time TYPE numc06.
  DATA : l_zpdwk_tm   TYPE zepdwk_tm,
       l_zoblwk_m   TYPE i,
       l_zpubhwk_m  TYPE i,
       l_zpoverwk_m TYPE i,
       l_ztotwk_m   TYPE i,
       l_zrlwk_m    TYPE i,
       l_zrlovrwk_m TYPE i,
       l_zrestwk_m  TYPE i,
       p_code(3) TYPE c.

  DATA ls_zthrbs01_new TYPE zthrbs01.

  CLEAR : temp_zthrbs01, g_code, g_text.


  IF i_action <> 'SAVE'.
    " 기존 신청내역 조회
    CLEAR ls_zthrbs01.
    SELECT SINGLE * FROM zthrbs01
      INTO CORRESPONDING FIELDS OF ls_zthrbs01
     WHERE pernr = is_zshr0131-pernr
       AND rdate = is_zshr0131-datum
       AND seqnr = is_zshr0131-seqnr.

* ----------- 20201202 XA31769 퇴출/익휴 문제 때문에 임시 코드 / (구) 시간외 시스템 폐기 후에 -------
    IF ls_zthrbs01-znal <= '99991231'.
      IF ls_zthrbs01-ZTOICH = 'Y'. " 퇴출
        ls_zthrbs01-ZTOICH = 'X'.
      ENDIF.
      IF ls_zthrbs01-ZTOMOH = 'Y'. " 익휴
        ls_zthrbs01-ZTOMOH = 'X'.
      ENDIF.
      IF ls_zthrbs01-ZTOMO = 'Y'. " 익휴
        ls_zthrbs01-ZTOMO = 'X'.
      ENDIF.
      IF ls_zthrbs01-ZDAEH = 'Y'.
*        ls_zthrbs01-ZDAEH = 'X'.
      ENDIF.
    ENDIF.

*    퇴출과 익휴가 zthrbs01 현재 테이블에서 Y로 저장되고 있는데 프로그램 소스에서는 X인 경우로
*    코딩 되어 있음....
*    (구) 시간외에서 X로 사용했다고 하는데 어쨋든 추후 이부분 해결해야함
*    zthrbs01에 저장할 때 Y로 저장하도록 수정해야함...... 현재는 1월1일 로 보고 있는데 잘모르겠네...

*----------------------------------------------------------------------
  ENDIF.

  CASE i_action.
      "결재상신 혹은 변경이 가능한 건인지 미리 확인
      CALL FUNCTION 'ZHR_52TM_VALID_DATE_CHECK'
        EXPORTING
          I_PERNR        = is_zshr0131-pernr
          I_DATE         =  is_zshr0131-datum
          I_OPT          = ''
          I_ZTOMO = ''
       IMPORTING
         E_RETURN       = e_return.
       IF e_return-type EQ 'E'.
         EXIT.
       ENDIF.
*--------------------------------------------------------------------*
*- 저장
*--------------------------------------------------------------------*
    WHEN 'SAVE'.

*      IF is_zshr0131-zcid is INITIAL.
*        is_zshr0131-zcid = is_zshr0131-zcosa+3(5). "결재자id
*      endif.

      PERFORM set_overtime_zgubun USING is_zshr0131-pernr
                                                                    is_zshr0131-datum
                                                                    is_zshr0131-wktype
                                                  CHANGING l_tmp_zgubun
                                                                    e_return.
      IF e_return IS NOT INITIAL.
        RETURN.
      ENDIF.
      is_zshr0131-zgubun = l_tmp_zgubun.

*-> 초과근무시간이 12시간 이상이면 결재자가 부장급 이상 check하기위해서 아래로 이동 - 2019.04.28 by chl
** APPR 로 이동
*      " 결재자 체크
*      CALL FUNCTION 'ZHR_52TM_CHECK_APPROVER_N'
*        EXPORTING
*          pernr     = is_zshr0131-pernr
*          znal       = is_zshr0131-datum
*        IMPORTING
*          error_code = g_code
*          error_text = g_text
*        CHANGING
*          zpernr     = is_zshr0131-zcosa
*          zename     = is_zshr0131-zcope
*          zbname     = is_zshr0131-zcid.
*      IF g_code(1) = 'E'.
*        e_return-type = c_error.
*        e_return-message = g_text.
*        RETURN.
*      ENDIF.


*
*      CALL FUNCTION 'ZHR_52TM_NEW_ORDINARY_TIME'
*        EXPORTING
*          IS_ZSHR0131 = IS_ZSHR0131.



      " 변경신청인 경우에만 기존 신청내역 조회
      IF i_mode = 'M'.
        CLEAR ls_zthrbs01.
        SELECT SINGLE * FROM zthrbs01
          INTO CORRESPONDING FIELDS OF ls_zthrbs01
         WHERE pernr = is_zshr0131-pernr
           AND rdate = is_zshr0131-datum
           AND seqnr = is_zshr0131-seqnr.
      ENDIF.

      " 근무시간 등 변경사항 적용
      PERFORM modify_overtime_save_data USING i_mode
                                              i_action
                                     CHANGING is_zshr0131
                                              ls_zthrbs01
                                              g_code
                                              g_text.
      IF g_code+0(1) = 'E'.
        e_return-type = c_error.
        e_return-message = g_text.
        EXIT.
      ENDIF.


*->begin 현재 저장데이터 초과근무시간 계산 - 2019.04.28 by chl

      PERFORM calculate_ze_time USING ls_zthrbs01
                                CHANGING lv_ze_time.

*<-end 현재 저장데이터 초과근무시간 계산 - 2019.04.28 by chl

      " 결재자 체크
      CALL FUNCTION 'ZHR_52TM_CHECK_APPROVER_N'
        EXPORTING
          pernr      = is_zshr0131-pernr
          znal       = is_zshr0131-datum
          zrlovrwkhr = is_zshr0131-zrlovrwkhr
          ze_time    = lv_ze_time
        IMPORTING
          error_code = g_code
          error_text = g_text
        CHANGING
          zpernr     = is_zshr0131-zcosa
          zename     = is_zshr0131-zcope
          zbname     = ls_zthrbs01-zcid.  "is_zshr0131-zcid. 결재자 체크를 아래로 이동으로 인해 변경 - 2019.04.30 by chl
      IF g_code(1) = 'E'.
        IF g_code <> 'E95'.
          e_return-type = c_error.
          e_return-message = g_text.
          RETURN.

        ENDIF.
      ENDIF.

      "ZCID 값이 없으면 위평션에서 에러를 리턴하므로 이 로직은 타지 않음 - 2019.04.30
      IF ls_zthrbs01-zcid IS INITIAL.
        ls_zthrbs01-zcid = is_zshr0131-zcosa+3(5). "결재자id
      ENDIF.


      " 데이터 저장처리
      CALL FUNCTION 'ZHR_52TM_GET_OVERTIME_SAVE'
        EXPORTING
          i_mode      = i_mode
          i_wktype    = is_zshr0131-wktype
          i_action    = i_action
          is_zthrbs01 = ls_zthrbs01
          i_seqnr     = i_seqnr
        IMPORTING
          e_code      = g_code
          e_text      = g_text
        TABLES
          t_data      = lt_zthrbs01
        CHANGING
          c_zemcwk    = is_zshr0131-zemcwk_c
          c_ztoich    = is_zshr0131-ztoich_c
          c_ztomoh    = is_zshr0131-ztomoh_c
          c_zdaeh     = is_zshr0131-zdaeh_c.
      IF g_code+0(1) = 'E'.
        e_return-type = c_error.
        e_return-message = g_text.
      ELSE.
        " 저장정보(TABLE KEY_사번/근무일/순번) WEB 전송
        CLEAR ls_zthrbs01.
        READ TABLE lt_zthrbs01 INTO ls_zthrbs01 INDEX 1.
        IF sy-subrc = 0.
          e_pernr = ls_zthrbs01-pernr.
          e_datum = ls_zthrbs01-rdate.
          e_seqnr = ls_zthrbs01-seqnr.
        ENDIF.
        " DB 저장처리
        MODIFY zthrbs01 FROM TABLE lt_zthrbs01.
        IF sy-subrc = 0.
          e_return-type = c_success.
          IF i_mode <> 'M'.
            " 저장되었습니다. 확인 후, 결재 상신하시기 바랍니다!
            e_return-message = text-001.
          ELSE.
            " 변경사항을 저장했습니다. 확인 후, 결재 상신하세요!
            e_return-message = text-002.
          ENDIF.
        ELSE.
          e_return-type = c_error.
          " 저장에 실패했습니다. 다시 시도하시기 바랍니다!
          e_return-message =  text-003.
        ENDIF.
      ENDIF.
*--------------------------------------------------------------------*
*- 결재상신
*--------------------------------------------------------------------*
    WHEN 'APPR'.
**->   begin 회수상태건 재상신 기능 추가 - 2018.12.14 by erphr2
*      회수건 재상신일때 web에서 결재상신버튼을 비활성으로 처리해서 필요없어짐
*      SELECT SINGLE *
*        INTO CORRESPONDING FIELDS OF ls_zthrbs01_new
*        FROM zthrbs01
*       WHERE pernr = ls_zthrbs01-pernr
*         AND rdate = ls_zthrbs01-rdate
*         AND seqnr = ls_zthrbs01-seqnr.
*
*      IF ls_zthrbs01_new-state = '5'.
*        CLEAR ls_zthrbs01_new-seqnr.
*
*        SELECT seqnr INTO ls_zthrbs01_new-seqnr
*          FROM zthrbs01
*         UP TO 1 ROWS
*         WHERE pernr = ls_zthrbs01-pernr
*           AND rdate = ls_zthrbs01-rdate
*         ORDER BY seqnr DESCENDING.
*        ENDSELECT.
*        IF sy-subrc = 0.
*          ls_zthrbs01_new-seqnr = ls_zthrbs01_new-seqnr + 1.
*        ENDIF.
*        ls_zthrbs01_new-state = '0'.
*        INSERT zthrbs01 FROM ls_zthrbs01_new.
*
*        ls_zthrbs01-seqnr = ls_zthrbs01_new-seqnr.
*        ls_zthrbs01-state = ls_zthrbs01_new-state.
*      ENDIF.
**<- end 회수상태건 재상신 기능 추가 - 2018.12.14 by erphr2


* 변경사항이 있을수 있기 때문에 상신할때도 저장 로직을 수행한다..

      IF ls_zthrbs01-znal >= '20201130'. " 연장근로계산방식 변경 xa30752
        " 데이터 저장처리
        CALL FUNCTION 'ZHR_52TM_GET_OVERTIME_SAVE'
          EXPORTING
*          i_mode      = i_mode
            i_mode = 'M'
            i_wktype    = is_zshr0131-wktype
            i_action    = i_action
            is_zthrbs01 = ls_zthrbs01
            i_seqnr     = i_seqnr
          IMPORTING
            e_code      = g_code
            e_text      = g_text
          TABLES
            t_data      = lt_zthrbs01
          CHANGING
            c_zemcwk    = is_zshr0131-zemcwk_c
            c_ztoich    = is_zshr0131-ztoich_c
            c_ztomoh    = is_zshr0131-ztomoh_c
            c_zdaeh     = is_zshr0131-zdaeh_c.

        IF g_code+0(1) = 'E'.
          e_return-type = c_error.
          e_return-message = g_text.
        ELSE.

* --------------- 20201201 김지훈 결재 상태 변경 로직 위치 이동 ---------------------

          " 저장정보(TABLE KEY_사번/근무일/순번) WEB 전송
          CLEAR ls_zthrbs01.
          READ TABLE lt_zthrbs01 INTO ls_zthrbs01 INDEX 1.
          IF sy-subrc = 0.
            e_pernr = ls_zthrbs01-pernr.
            e_datum = ls_zthrbs01-rdate.
            e_seqnr = ls_zthrbs01-seqnr.
          ENDIF.
          " DB 저장처리
          MODIFY zthrbs01 FROM TABLE lt_zthrbs01.
          IF sy-subrc = 0.
            e_return-type = c_success.

            IF e_return-type+0(1) = 'E'.
              e_return-message = '주간 최대근로시간을 초과했습니다.'.
            ENDIF.
          ENDIF.
* ------------------------------------------------------------------------
        ENDIF.

      ELSE.

        APPEND ls_zthrbs01 TO lt_zthrbs01.

      ENDIF.
**********************************************************************************

      CALL FUNCTION 'ZHR_52TM_VALID_DATE_CHECK'
        EXPORTING
          I_PERNR  = ls_zthrbs01-pernr
          I_DATE   = ls_zthrbs01-znal
          I_ZTOMO  = ls_zthrbs01-ztomo
          I_CHECK  = '0010' " 통상 시간외
        IMPORTING
          E_RETURN = e_return.

      IF e_return-type = 'E'.
        RETURN.
      ENDIF.


      IF ls_zthrbs01-zcid IS INITIAL.
        ls_zthrbs01-zcid = ls_zthrbs01-zcosa+3(5). "결재자id
      ENDIF.


      CALL FUNCTION 'ZHR_52TM_GET_OVERTIME_REQUEST'
        IMPORTING
          e_code = g_code
          e_text = g_text
        TABLES
          t_data = lt_zthrbs01.

      e_return-message = g_text.

      IF g_code+0(1) = 'E'.
        e_return-type = c_error.
      ELSE.

        e_return-type = c_success.
        " 결재상신정보(TABLE KEY_사번/근무일/순번) WEB 전송
        CLEAR ls_zthrbs01.
        READ TABLE lt_zthrbs01 INTO ls_zthrbs01 INDEX 1.
        IF sy-subrc = 0.
          e_pernr = ls_zthrbs01-pernr.
          e_datum = ls_zthrbs01-rdate.
          e_seqnr = ls_zthrbs01-seqnr.
        ENDIF.
* ------------------------------------------------------------------------

      ENDIF.
*--------------------------------------------------------------------*
*- 삭제
*--------------------------------------------------------------------*
    WHEN 'DELE'.
      APPEND ls_zthrbs01 TO lt_zthrbs01.
      CALL FUNCTION 'ZHR_52TM_GET_OVERTIME_DELETE'
        IMPORTING
          e_code = g_code
          e_text = g_text
        TABLES
          t_data = lt_zthrbs01.
      e_return-message = g_text.
      IF g_code+0(1) = 'E'.
        e_return-type = c_error.
      ELSE.
        e_return-type = c_success.
        " 삭제정보(TABLE KEY_사번/근무일/순번) WEB 전송
        CLEAR ls_zthrbs01.
        READ TABLE lt_zthrbs01 INTO ls_zthrbs01 INDEX 1.
        IF sy-subrc = 0.
          e_pernr = ls_zthrbs01-pernr.
          e_datum = ls_zthrbs01-rdate.
          e_seqnr = ls_zthrbs01-seqnr.
        ENDIF.
        " 승인건을 삭제하는 경우, 결재자에게 메일통보
        IF ls_zthrbs01-state = '3'.
          PERFORM send_mail USING '3'" 통상
                                  ls_zthrbs01-pernr
                                  ls_zthrbs01-rdate
                                  ls_zthrbs01-rdate
                                  ls_zthrbs01-zbegt
                                  ls_zthrbs01-zendt
                                  ls_zthrbs01-zcosa
                                  '통상근로 시간외실비'
                         CHANGING e_return.
        ENDIF.
      ENDIF.
*--------------------------------------------------------------------*
*- 회수
*--------------------------------------------------------------------*
    WHEN 'RETR'.
      APPEND ls_zthrbs01 TO lt_zthrbs01.
      CALL FUNCTION 'ZHR_52TM_GET_OVERTIME_RETURN'
        IMPORTING
          e_code = g_code
          e_text = g_text
        TABLES
          t_data = lt_zthrbs01.
      e_return-message = g_text.
      IF g_code+0(1) = 'E'.
        e_return-type = c_error.
      ELSE.
        e_return-type = c_success.
        " 회수정보(TABLE KEY_사번/근무일/순번) WEB 전송
        CLEAR ls_zthrbs01.
        READ TABLE lt_zthrbs01 INTO ls_zthrbs01 INDEX 1.
        IF sy-subrc = 0.
          e_pernr = ls_zthrbs01-pernr.
          e_datum = ls_zthrbs01-rdate.
          e_seqnr = ls_zthrbs01-seqnr.
        ENDIF.
      ENDIF.
  ENDCASE.

ENDFUNCTION.
