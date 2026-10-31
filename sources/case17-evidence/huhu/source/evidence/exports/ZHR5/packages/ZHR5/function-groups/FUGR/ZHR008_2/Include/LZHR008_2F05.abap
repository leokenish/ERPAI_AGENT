*----------------------------------------------------------------------*
***INCLUDE LZHR008_2F05 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  MAKE_CONDITION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_I_PERNR  text
*      <--P_LV_CONDITION  text
*----------------------------------------------------------------------*
FORM make_condition USING p_value
                 CHANGING c_condition.

  CLEAR c_condition.
  CONCATENATE `'` p_value `'` INTO c_condition.
ENDFORM.                    " MAKE_CONDITION
*&---------------------------------------------------------------------*
*&      Form  GET_ZDAEH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_ZTHRBS01_ZNAL  text
*      -->P_LV_ZDAEH_C  text
*      <--P_LS_ZTHRBS01_ZDDAY  text
*      <--P_LS_ZTHRBS01_ZDBEG  text
*      <--P_LS_ZTHRBS01_ZDEND  text
*----------------------------------------------------------------------*
FORM get_zdaeh_data  USING p_zgubun
                           p_zdday "대휴발생일자
                  CHANGING c_zdbeg "대휴사용기간->시작
                           c_zdend."대휴사용기간->종료

  DATA : lv_year(4) TYPE n.

  CLEAR: c_zdbeg, c_zdend.

*...// 대휴발생시작일은 대휴일자 + 1일
  c_zdbeg = p_zdday + 1.

* 부장대휴의 경우 사용 기한을 최대 1년 6개월로 연장
  IF p_zgubun EQ 'F'.    "부장대휴
    lv_year = p_zdday+0(4) + 1.
    IF p_zdday < '20190701'.
      IF p_zdday+4(2) <= '06'. "상반기.
         CONCATENATE lv_year
                  '0630'
                  INTO c_zdend.
      ELSE.                   "하반기.
         CONCATENATE lv_year
                  '1231'
                  INTO c_zdend.
      ENDIF.
    ELSE. " 시간외 지침 개정 시행 2019.7.26 부장직 대휴사용기간 6개월 추가(xa30752) 인적자원실-3720 (2019.07.30.)
      IF p_zdday+4(2) <= '06'. "상반기.
         CONCATENATE lv_year
                  '1231'
                  INTO c_zdend.
      ELSE.                   "하반기.
         lv_year = p_zdday+0(4) + 2.
         CONCATENATE lv_year
                  '0630'
                  INTO c_zdend.
      ENDIF.
    ENDIF.
  ELSE.
    IF p_zdday+4(2) <= '06'.  " 상반기.
      CONCATENATE p_zdday+0(4)
                  '1231'
                  INTO c_zdend.
    ELSE.                              " 하반기
      lv_year = p_zdday+0(4) + 1.
      CONCATENATE lv_year
                  '0630'
                  INTO c_zdend.
    ENDIF.
  ENDIF.
ENDFORM.                    " GET_ZDAEH_DATA
*&---------------------------------------------------------------------*
*&      Form  SPLIT_OVERTIME_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_ZDAEH  text
*      <--P_LS_ZTHRBS01_D  text
*----------------------------------------------------------------------*
FORM split_overtime_data  USING p_mode
                                p_wktype
                                p_action
                                p_datum
                                p_index
                                ps_zthrbs01 STRUCTURE zthrbs01
                                ps_zdaeh    STRUCTURE zshr0121
                       CHANGING cs_zthrbs01 STRUCTURE zthrbs01.
  DATA: lv_seqnr TYPE seqnr,
        lv_code TYPE char03,
        lv_text TYPE char200,
        ls_overtime_data TYPE zsh_overtime_data_n.
  DATA: ls_zthrbs01 LIKE zthrbs01.
  CLEAR: cs_zthrbs01.

  MOVE-CORRESPONDING ps_zthrbs01 TO cs_zthrbs01.
  cs_zthrbs01-rdate  = p_datum.
  cs_zthrbs01-znal   = p_datum.

  IF p_index > 1.

    "당번특근의경우 내역이 쪼개지는데, 두번째 일자의 SEQ는 1로 들어 있음.
    "이럴경우 기존의 SEQ를 계속 유지해야함. 증가 시키면 안됨.
    SELECT SINGLE *
      INTO CORRESPONDING FIELDS OF ls_zthrbs01
      FROM zthrbs01
      WHERE pernr EQ cs_zthrbs01-pernr
        AND subty IN ('','0009','9')
        AND rdate EQ cs_zthrbs01-rdate.

   "근무시간이 같은 건이면 동일한 건으로 인식.
   "(연속된 근무면 시작시간이 다르게 들어옴)
    IF ls_zthrbs01-zendt EQ cs_zthrbs01-zendt.
      cs_zthrbs01-seqnr = ls_zthrbs01-seqnr.

    ELSE.
      CLEAR lv_seqnr.
      SELECT MAX( seqnr ) INTO lv_seqnr
        FROM zthrbs01
        WHERE pernr EQ cs_zthrbs01-pernr
          AND subty IN ('','0009','9')
          AND rdate EQ cs_zthrbs01-rdate.
      IF sy-subrc = 0.
        cs_zthrbs01-seqnr = lv_seqnr + 1.
      ELSE.
        cs_zthrbs01-seqnr = 1.
      ENDIF.

    ENDIF.


  ENDIF.

  cs_zthrbs01-begda  = ps_zthrbs01-rdate.         "역일 분리건 표시.
  cs_zthrbs01-endda  = ps_zthrbs01-rdate + 1.     "역일 분리건 표시.
  cs_zthrbs01-zbegt  = ps_zdaeh-zbegtm. "대휴발생일자 시작시간
  cs_zthrbs01-zendt  = ps_zdaeh-zendtm. "종료시간
  cs_zthrbs01-ztomo  = ps_zdaeh-ztomo.  "익일FLAG
  cs_zthrbs01-zdday  = ps_zdaeh-datum.  "대휴발생일자
  cs_zthrbs01-zpbeg1 = ps_zdaeh-zpbeg1.
  cs_zthrbs01-zpbtm1 = ps_zdaeh-zpbtm1.
  cs_zthrbs01-zpend1 = ps_zdaeh-zpend1.
  cs_zthrbs01-zpetm1 = ps_zdaeh-zpetm1.
  cs_zthrbs01-zpbeg2 = ps_zdaeh-zpbeg2.
  cs_zthrbs01-zpbtm2 = ps_zdaeh-zpbtm2.
  cs_zthrbs01-zpend2 = ps_zdaeh-zpend2.
  cs_zthrbs01-zpetm2 = ps_zdaeh-zpetm2.
  cs_zthrbs01-zpbeg3 = ps_zdaeh-zpbeg3.
  cs_zthrbs01-zpbtm3 = ps_zdaeh-zpbtm3.
  cs_zthrbs01-zpend3 = ps_zdaeh-zpend3.
  cs_zthrbs01-zpetm3 = ps_zdaeh-zpetm3.
  cs_zthrbs01-zpbeg4 = ps_zdaeh-zpbeg4.
  cs_zthrbs01-zpbtm4 = ps_zdaeh-zpbtm4.
  cs_zthrbs01-zpend4 = ps_zdaeh-zpend4.
  cs_zthrbs01-zpetm4 = ps_zdaeh-zpetm4.
  cs_zthrbs01-zpbeg5 = ps_zdaeh-zpbeg5.
  cs_zthrbs01-zpbtm5 = ps_zdaeh-zpbtm5.
  cs_zthrbs01-zpend5 = ps_zdaeh-zpend5.
  cs_zthrbs01-zpetm5 = ps_zdaeh-zpetm5.

*...// 대휴기준으로 SPLIT된 내역으로 초과근무 내역을 재계산 한다.
  CALL FUNCTION 'ZHR_52TM_GET_OVERTIME_DATA'
    EXPORTING
      i_mode           = p_mode
      i_wktype         = p_wktype
      i_action         = p_action
      is_zthrbs01      = cs_zthrbs01
    IMPORTING
      es_overtime_data = ls_overtime_data
      e_code           = lv_code
      e_text           = lv_text.

  MOVE : ls_overtime_data-zyoil      TO cs_zthrbs01-zyoil,
         ls_overtime_data-za_time    TO cs_zthrbs01-za_time,
         ls_overtime_data-ze_time    TO cs_zthrbs01-ze_time,
         ls_overtime_data-zr_time    TO cs_zthrbs01-zr_time,
         ls_overtime_data-zo_time    TO cs_zthrbs01-zo_time,
         ls_overtime_data-zn_time    TO cs_zthrbs01-zn_time,
         ls_overtime_data-zh_time    TO cs_zthrbs01-zh_time,
         ls_overtime_data-zd_time    TO cs_zthrbs01-zd_time,     "2011.04.
         ls_overtime_data-zo_money   TO cs_zthrbs01-zo_money,
         ls_overtime_data-zn_money   TO cs_zthrbs01-zn_money,
         ls_overtime_data-zh_money   TO cs_zthrbs01-zh_money,
         ls_overtime_data-zs_money   TO cs_zthrbs01-zs_money,
         ls_overtime_data-zd_money   TO cs_zthrbs01-zd_money,    "2011.04.
         ls_overtime_data-zmoney     TO cs_zthrbs01-zmoney,
*         ls_overtime_data-waers      TO cs_zthrbs01-waers,
         ls_overtime_data-zdaeh      TO cs_zthrbs01-zdaeh,
         ls_overtime_data-zsign      TO cs_zthrbs01-zsign,
         ls_overtime_data-zcho       TO cs_zthrbs01-zcho,
         ls_overtime_data-zcho_m     TO cs_zthrbs01-zcho_m.
ENDFORM.                    " SPLIT_OVERTIME_DATA
