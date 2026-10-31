FUNCTION zhr_52tm_mobile_overtime_check.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(I_ZGUBUN) TYPE  CHAR01
*"     VALUE(I_MODE) TYPE  CHAR01
*"     VALUE(I_PERNR) TYPE  PERSNO
*"     VALUE(I_DATUM) TYPE  DATUM DEFAULT SY-DATUM
*"     VALUE(I_SEQNR) TYPE  SEQNR
*"     VALUE(I_WKTYPE) TYPE  ZEWKTYPE OPTIONAL
*"     VALUE(I_ISFST) TYPE  CHAR01 OPTIONAL
*"  EXPORTING
*"     VALUE(E_RETURN) TYPE  BAPIRETURN1
*"     VALUE(E_ZRLWK_TM) TYPE  ZERLWK_TM
*"     VALUE(E_ZPDWK_TM) TYPE  ZEPDWK_TM
*"  TABLES
*"      LT_WKTP STRUCTURE  ZSHR0114 OPTIONAL
*"  CHANGING
*"     VALUE(CS_ZSHR0131) TYPE  ZSHR0131 OPTIONAL
*"----------------------------------------------------------------------
*- I_MODE : 신규 - 근로형태에 따른 기준시간 등 초기값 조회
*           변경 - 근로형태에 따른 근무/휴게시간 및 시간외실비수당 조회

  DATA : ls_zthrbs01 TYPE zthrbs01,
         lt_zthrbs01 LIKE TABLE OF ls_zthrbs01,
         l_zyuhyung  TYPE zyuhyung,
         l_zcnval    TYPE zecnval.
  DATA : lv_corgtx(50).
  DATA l_iam_msg(200).
  DATA: l_chk,
        l_hol.

  DATA : temp_wktype TYPE ZEWKTYPE.

*- Default Setting시에만 근무시간정보 Clear!!
  IF i_zgubun IS INITIAL.
*    CLEAR cs_zshr0131.
  ENDIF.

*- 대상기간 초기값 설정
  PERFORM set_overtime_date USING i_datum
                         CHANGING cs_zshr0131-wkbegda
                                  cs_zshr0131-wkendda.
*- 신청구분
  IF i_wktype IS NOT INITIAL.
    cs_zshr0131-wktype = i_wktype.
  ENDIF.
  PERFORM set_overtime_zgubun USING i_pernr
                                    i_datum
                                    cs_zshr0131-wktype
                           CHANGING cs_zshr0131-zgubun
                                    e_return.
  IF e_return IS NOT INITIAL.
    RETURN.
  ENDIF.


*- 시차근로자 공/휴일 선택 못 함
  IF i_wktype EQ 'N3'.
*    DATA l_hol.
    CLEAR l_hol.
    CALL FUNCTION 'ZHR_GET_DAY_DATA_N'
      EXPORTING
        znal    = i_datum
      IMPORTING
        holiday = l_hol.

    IF l_hol = 'X'.
      e_return-type = 'E'.
      e_return-message = text-ea1.
    ENDIF.

    IF e_return IS NOT INITIAL.
      RETURN.
    ENDIF.

  ENDIF.


*- 해외출장자 기준시간
  IF cs_zshr0131-zgubun = 'T'.
    CLEAR l_zcnval.
    SELECT SINGLE zcnval INTO l_zcnval
      FROM zthr0101
     WHERE zconst = 'ZTRPHR'
       AND begda <= i_datum
       AND endda >= i_datum.
    IF sy-subrc = 0.
      PERFORM set_hour_to_time USING l_zcnval
                                     cs_zshr0131-ztbase_tm.
    ENDIF.
  ENDIF.

*- 최근 결재자
  IF cs_zshr0131-zcope IS INITIAL.
    PERFORM set_overtime_zcope USING i_pernr
                            CHANGING cs_zshr0131-zcosa
                                     cs_zshr0131-zcope
                                     cs_zshr0131-corgtx
                                     cs_zshr0131-zcid.
  ENDIF.

*- 최근 결재자의 부서정보
  " Web에서는 해당 정보를 저장하지 않으므로, 항상 전송한다!!
  IF cs_zshr0131-zcope IS INITIAL.
    CLEAR : cs_zshr0131-zcosa, cs_zshr0131-corgtx.
  ELSE.
    IF cs_zshr0131-zcosa <> '00000000'.
      lv_corgtx = zcl_cm_util_dev=>get_vdstext( i_pernr = cs_zshr0131-zcosa ).
      cs_zshr0131-corgtx  = lv_corgtx.
      CLEAR : lv_corgtx.
      lv_corgtx = zcl_cm_util_dev=>get_jikwitext( i_pernr = cs_zshr0131-zcosa ).
      CONCATENATE cs_zshr0131-corgtx   lv_corgtx INTO cs_zshr0131-corgtx SEPARATED BY space.
    ENDIF.
  ENDIF.

  CASE i_zgubun.
*--------------------------------------------------------------------*
*- 신규(기본값 Setting)
*--------------------------------------------------------------------*
    WHEN ''.
      " 기본시간Setting
      PERFORM set_init_check USING i_pernr
                                   i_datum
                                   i_isfst
                          CHANGING cs_zshr0131
                                   g_code
                                   g_text
                                   l_iam_msg.
      IF g_code+0(1) = 'E'.
        e_return-type = c_error.
        e_return-message = g_text.
        RETURN.
      ENDIF.

*-> beg 근로형태를 set_init_check 서브루틴에서 받는것으로 바뀌어서 실행되지 않음 - 2019.03.19 by chl
*       아래의 source 를 zhr_52tm_set_default_time 으로 옮김 - 2019.03.19 by chl
      " 근로형태
      IF cs_zshr0131-wktype IS INITIAL.
        " 교대근무

        IF cs_zshr0131-zgubun EQ 'C'.
*          cs_zshr0131-wktype = 'S4'.
          "[19.02.27]교대 근무별 기본 타입 설정.
          IF cs_zshr0131-zyoil = '휴'.
            cs_zshr0131-wktype = 'S2'.  "휴일
          ELSEIF cs_zshr0131-kind = '일근' OR cs_zshr0131-kind = '야근' OR cs_zshr0131-kind = '조근'.
            cs_zshr0131-wktype = 'S5'.
          ELSEIF cs_zshr0131-kind = '비번'.
            cs_zshr0131-wktype = 'S4'.
          ENDIF.
*        CLEAR : cs_zshr0131-zpbeg1, cs_zshr0131-zpend1, cs_zshr0131-zpbeg2, cs_zshr0131-zpend2, cs_zshr0131-zpbtm2, cs_zshr0131-zpetm2.
        ELSEIF cs_zshr0131-zgubun EQ 'B'.
          cs_zshr0131-wktype = 'N3'."시차
          CLEAR : cs_zshr0131-zpbeg1, cs_zshr0131-zpend1, cs_zshr0131-zpbeg2, cs_zshr0131-zpend2, cs_zshr0131-zpbtm2, cs_zshr0131-zpetm2.
        ELSE.
          " 근무형태 값이 없는경우 'N1': 통상/해외로 지정
          cs_zshr0131-wktype = 'N1'.
        ENDIF.
      ENDIF.
*<- end

      " 교대근로형태
      IF cs_zshr0131-wktype+0(1) = 'S'.
        cs_zshr0131-zyuhyung = cs_zshr0131-wktype.
*        CLEAR : cs_zshr0131-zpbeg1, cs_zshr0131-zpend1, cs_zshr0131-zpbeg2, cs_zshr0131-zpend2, cs_zshr0131-zpbtm2, cs_zshr0131-zpetm2.
      ENDIF.
      PERFORM set_wktype_list TABLES lt_wktp
                               USING cs_zshr0131-zgubun
                                      cs_zshr0131-wktype
                                      i_pernr
                                       i_datum
                            CHANGING g_code
                                     g_text.
      IF g_code+0(1) = 'E'.
        e_return-type = c_error.
        e_return-message = g_text.
        RETURN.
      ENDIF.



*      " 근로 및 휴게시간(특근/철야 예외처리)
      PERFORM calc_working_time USING cs_zshr0131
                                      e_zrlwk_tm
                                      e_zpdwk_tm
                                      cs_zshr0131-wktype
                                      e_return-type.
*      IF ( cs_zshr0131-wktype = 'N2' OR cs_zshr0131-wktype = 'S1' ) AND
*        i_mode = '' . " 특근 or 철야시 의무휴게시간
*        IF e_return-type = 'E' .
*             CONCATENATE text-e91 '(의무휴게시간 01:00)' into
*          e_return-message .
**          e_return-type = c_success.
*          RETURN.
*        ENDIF.
*      ENDIF.
*      CLEAR e_return-type.
      e_return-type = c_success.
      e_return-message = l_iam_msg.  "추가 - 2019.03.18 by chl

      " 입력한 총 휴게시간과 의무 휴게시간 비교
      PERFORM check_overtime_break_time USING i_mode
                                     CHANGING cs_zshr0131.



*--------------------------------------------------------------------*
*- 수정(변경사항Check)
*--------------------------------------------------------------------*
    WHEN 'M'.
*     "20181220 화면 입력 시간 확인
*     "시작시간 종료시간이 정확한지 확인
*
*     if ( cs_zshr0131-zbegt < cs_zshr0131-zendt ) and cs_zshr0131-ztomo = ''.
*     elseif ( cs_zshr0131-zbegt >= cs_zshr0131-zendt ) and cs_zshr0131-ztomo = 'X'.
*     elseif ( cs_zshr0131-zbegt > cs_zshr0131-zendt ) and cs_zshr0131-ztomo = ''.
*            cs_zshr0131-ztomo = 'X'.
*
*     endif.

*   IF  cs_zshr0131-zbegt <> '000000' AND  cs_zshr0131-zendt = '000000'.
*       cs_zshr0131-zendt = cs_zshr0131-zbegt.
*   ENDIF.



      " 교대근로형태(Domain Value)
      CLEAR l_zyuhyung.
      IF cs_zshr0131-wktype+0(1) = 'S'.
        l_zyuhyung = cs_zshr0131-zyuhyung.
        REPLACE 'S' IN l_zyuhyung WITH '0'.
        CONDENSE l_zyuhyung.
      ENDIF.
      " 근로형태
      CALL FUNCTION 'ZHR_52TM_CONVERT_ZGUBUN_WKTYPE'
        EXPORTING
          i_zgubun = cs_zshr0131-zgubun
          i_flexty = l_zyuhyung
        IMPORTING
          e_wktype = cs_zshr0131-wktype.
      PERFORM set_wktype_list TABLES lt_wktp
                               USING cs_zshr0131-zgubun
                                     cs_zshr0131-wktype
                                     cs_zshr0131-pernr
                                     cs_zshr0131-datum
                            CHANGING g_code
                                     g_text.
      IF g_code+0(1) = 'E'.
        e_return-type = c_error.
        e_return-message = g_text.
        RETURN.
      ENDIF.

* 코비스 어플(아이폰)에서 통상 근무 휴일에 시간외 실비 올리는 경우, 최초 화면(초기화)에서 휴게 시간이 000000~000000이면 오류가 발생하여
* 총 근무시간이 4시간이면 휴게시간(시작, 종료 모두)을 근무시작 시간 + 1시간으로 세팅
      IF cs_zshr0131-zyoil = '휴'.

        DATA : work_t LIKE cs_zshr0131-ZBEGT.
        DATA : work_r(6) TYPE n.
        DATA : temp_t(6) TYPE n.
        work_t = cs_zshr0131-ZENDT - cs_zshr0131-ZBEGT.
        work_r = work_t.

        IF work_r > 40000 AND cs_zshr0131-ZPBEG1 = '000000' AND cs_zshr0131-ZPEND1 = '000000'.

         temp_t = cs_zshr0131-ZBEGT.
         temp_t = temp_t + 10000.

            cs_zshr0131-ZPBEG1 = temp_t.
            cs_zshr0131-ZPEND1 = temp_t.

        ENDIF.
      ENDIF.

*      " 근로 및 휴게시간(특근/철야 예외처리)
      PERFORM calc_working_time USING cs_zshr0131  " 여기는 휴게시간 / 근로시간(휴게시간을 제외한 총 근무시간)만 구함
                                      e_zrlwk_tm
                                      e_zpdwk_tm
                                      cs_zshr0131-wktype
                                      e_return-type.



*      cs_zshr0131-ze_time_s = '9999'.
*      IF ( cs_zshr0131-wktype = 'N2' OR cs_zshr0131-wktype = 'S1' ) AND
*         i_mode = '' . " 특근 or 철야시 의무휴게시간
*        IF e_return-type = 'E' .
*          CONCATENATE text-e91 '(의무휴게시간 01:00)' into
*          e_return-message .
*          e_return-type = c_success.
*          RETURN.
*        ENDIF.
*      ENDIF.

      e_return-type = c_success.


      " 변경사항 체크
      PERFORM check_overtime_change_data USING i_mode  " 날짜가 정해지면서(이게 변경사항이라 볼수 있음) 연장시간 / 금액을 구함
                                               i_seqnr
                                      CHANGING cs_zshr0131
                                               g_code
                                               g_text.
*      cs_zshr0131-ze_time_s = '9999'.

      IF g_code+0(1) = 'E'.
        e_return-type = c_error.
        e_return-message = g_text.
        RETURN.
      ELSEIF g_code+0(1) = 'I'.
        e_return-type = c_success.
        e_return-message = g_text.
      ENDIF.





  ENDCASE.

  " Return Message
  IF e_return IS INITIAL.
    e_return-type = c_success.
    " 정보성메세지가 있는 경우, Message Return!!
    IF g_text IS NOT INITIAL.
      e_return-message = g_text.
    ENDIF.
  ENDIF.

ENDFUNCTION.
