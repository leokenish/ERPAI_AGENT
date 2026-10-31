*&---------------------------------------------------------------------*
*&  Include           LZHR008_3F04
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  A_CW_REPORT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_ZSHR0141  text
*      -->P_I_PERNR  text
*      -->P_I_BEGDA  text
*      -->P_I_ENDDA  text
*      -->P_I_STATE  text
*----------------------------------------------------------------------*
FORM a_cw_report_data  TABLES   pt_zshr0141 STRUCTURE zshr0141
                       USING    pv_pernr
                                pv_begda
                                pv_endda
                                pv_state
                       CHANGING ps_return TYPE bapireturn1.

  DATA: lv_zbegtm_t(5),
        lv_zendtm_t(8).

  RANGES r_state FOR zshr0141-state.

  "상태
  IF pv_state IS INITIAL.
    r_state-sign = 'E'.
    r_state-option = 'EQ'.
    r_state-low = '2'.
    APPEND r_state.
  ELSE.
    r_state-sign = 'I'.
    r_state-option = 'EQ'.
    r_state-low = pv_state.
    APPEND r_state.
  ENDIF.

  "실적
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE pt_zshr0141
    FROM zthr0112
   WHERE pernr = pv_pernr
     AND datum <= pv_endda
     AND datum >= pv_begda
     AND z52wktp = c_z52wktp_0110
     AND z52prsq = c_z52prsq_04
     AND state IN r_state.

  SORT pt_zshr0141 BY datum DESCENDING seqnr DESCENDING.

  ps_return-type = c_success.

ENDFORM.                    " A_CW_REPORT_DATA
*&---------------------------------------------------------------------*
*&      Form  MAKE_PAYMENT_WKPRD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_RTRO  text
*      -->P_LT_ZTHR0132  text
*      -->P_LT_ZTHR0112  text
*----------------------------------------------------------------------*
FORM make_payment_wkprd  TABLES   pt_data STRUCTURE zthr0113
                                  pt_zthr0132 STRUCTURE zthr0132
                           USING pv_case.

  DATA: BEGIN OF lt_zthr0112 OCCURS 0.
          INCLUDE TYPE zthr0112.
  DATA: rwkhr_s_min TYPE i,
        rwkhr_d_min TYPE i,
        msg(100),
        END OF lt_zthr0112.

  DATA: lt_zthrbs13 TYPE TABLE OF zthrbs13 WITH HEADER LINE,
        lv_day TYPE dats,
        lv_time1 TYPE zchar06,
        lv_time2 TYPE zchar06,
        lv_time_dif TYPE zchar06.

  DATA: lv_pwkhr_min TYPE i,
        lv_hodhr_min TYPE i,
        lv_owkhr_min TYPE i,
        lv_zrlexwkhr_min TYPE i,
        lv_zrlwk_t_min TYPE i,
        lv_zrlwk_t_extra TYPE i,
*        lv_zprsdwk_t_extra TYPE i,
        lv_zovradd_t_min TYPE i,
        lv_zprsdwk_t_min TYPE i,
        lv_awkhr_t_min TYPE i,
        lv_ewkhr_t_min TYPE i,
        lv_awkhr_t_min2 TYPE i,
        lv_ewkhr_t_min2 TYPE i,
        lv_diff_min TYPE i,
        lv_remain_min TYPE i,
        lv_rwkhr_s_min TYPE i,
        lv_zadtwk_t_min TYPE i,
*        lv_zemcwk_t_min TYPE i,
        lv_zrlngtwk_t_min TYPE i,
        lv_zrlholwk_t_min TYPE i,
        lv_zdaeh_t_min TYPE i,
        lv_zdaeh_t_day TYPE i,
        lv_sign TYPE i,
        lv_min TYPE i,
        lv_min2 TYPE i,
        lv_zprsdwk_min TYPE i,
        lv_pwkhr_sum TYPE i,
        lv_pwkhr_last TYPE i,
        lv_owkhr_sum TYPE i,
        lv_zrlwkhrtot_sum TYPE i,
        lv_zrlovrwkhr_sum TYPE i,
        lv_tdcost_t_min TYPE i,
        lv_tdcost_sum TYPE zetdcost,
        lt_zshr0111 TYPE TABLE OF zshr0111 WITH HEADER LINE,
        lt_attributes TYPE TABLE OF casdayattr WITH HEADER LINE,
        ls_zshr0141 TYPE zshr0141,
        ls_zshr0143 TYPE zshr0143,
        ls_return TYPE bapireturn1.


  LOOP AT pt_zthr0132.
    "소정근로시간(분)
    PERFORM convert_hour_to_min IN PROGRAM saplzhr008_3
                                 USING pt_zthr0132-pwkhr
                                 CHANGING lv_pwkhr_min.
    "주중공휴일시간(분)
    PERFORM convert_hour_to_min IN PROGRAM saplzhr008_3
                                 USING pt_zthr0132-hodhr
                                 CHANGING lv_hodhr_min.

    "연장가능시간(분)
    PERFORM convert_hour_to_min IN PROGRAM saplzhr008_3
                                 USING pt_zthr0132-owkhr
                                 CHANGING lv_owkhr_min.

    CALL FUNCTION 'ZHR_52TM_AWART_LIST'
      EXPORTING
        i_pernr    = pt_zthr0132-pernr
        i_begda    = pt_zthr0132-begda
        i_endda    = pt_zthr0132-endda
        i_zsangsin = 'X'
      TABLES
        t_data     = lt_zshr0111.

    "총 인정근로시간(분)
    LOOP AT lt_zshr0111 WHERE zstat = 'A' AND zabsdayty = 'A'.  "휴무와 익휴
      IF lt_zshr0111-zprsdwk_tm IS NOT INITIAL.
        PERFORM convert_time_to_min IN PROGRAM saplzhr008_3
                                    USING lt_zshr0111-zprsdwk_tm
                                    CHANGING lv_min.

        ADD lv_min TO lv_zprsdwk_t_min.
      ENDIF.
    ENDLOOP.

    "근태(간주)근로시간
    LOOP AT lt_zshr0111 WHERE awart = '9997'
                          AND zstat = 'A'
                          AND zabsdayty = 'P'.
*      IF lt_zshr0111-zprsdwk_tm IS NOT INITIAL.
*        PERFORM convert_time_to_min IN PROGRAM saplzhr008_3
*                                    USING lt_zshr0111-zprsdwk_tm
*                                    CHANGING lv_min.
      lv_min = 480.  "위평션에서 시간을 주지 않은 경우도 있음
      "8시간 이상이면 8시간만 인정
      IF lv_min > 480.
        lv_min = 480.
      ENDIF.

      ADD lv_min TO lv_awkhr_t_min.
*      ENDIF.
    ENDLOOP.

    "출제위원근로시간
    LOOP AT lt_zshr0111 WHERE awart = '9998'
                           AND zstat = 'A'
                           AND zabsdayty = 'P'.
      IF lt_zshr0111-zprsdwk_tm IS NOT INITIAL.
        PERFORM convert_time_to_min IN PROGRAM saplzhr008_3
                                    USING lt_zshr0111-zprsdwk_tm
                                    CHANGING lv_min.
        "8시간 이상이면 8시간만 인정
        IF lv_min > 480.
          lv_min = 480.
        ENDIF.

        ADD lv_min TO lv_ewkhr_t_min.
      ENDIF.
    ENDLOOP.


    "기준소정근로시간(분) -> 재계산
    lv_pwkhr_sum = lv_pwkhr_min - "기준소정근로시간
                   lv_hodhr_min -  "주중공휴일시간
                   lv_zprsdwk_t_min -  "인정근로시간(A/A)
                   lv_awkhr_t_min -  "근태(간주)근로시간(9997/A/P)
                   lv_ewkhr_t_min.  "출제위원근로시간(9998/A/P)


    IF pv_case = 'RETRO'.  "소급
      "소급대상년월 실적
      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE lt_zthr0112
        FROM zthr0112
       WHERE pernr = pt_zthr0132-pernr
         AND begda = pt_zthr0132-begda
         AND endda = pt_zthr0132-endda
         AND z52wktp = pt_zthr0132-z52wktp
         AND z52prsq = pt_zthr0132-z52prsq
         AND state IN ('3', '2', 'H').

      "삭제건에 대한 점검
      LOOP AT lt_zthr0112 WHERE state = '2'.
        SELECT SINGLE mandt
          INTO sy-mandt
          FROM zwf0022
         WHERE key12 = lt_zthr0112-zserial
           AND zwftype = 'E' "탄력근로
           AND zordr = '01'  "결재자
           AND zstts = 'A'.
        IF sy-subrc <> 0.
          DELETE lt_zthr0112.
        ENDIF.
      ENDLOOP.
    ELSE.
      "대상년월 실적
      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE lt_zthr0112
        FROM zthr0112
       WHERE pernr = pt_zthr0132-pernr
         AND begda = pt_zthr0132-begda
         AND endda = pt_zthr0132-endda
         AND z52wktp = pt_zthr0132-z52wktp
         AND z52prsq = pt_zthr0132-z52prsq
         AND state IN ('3', 'H').
    ENDIF.

    SORT lt_zthr0112 BY datum seqnr.

    lv_day = pt_zthr0132-begda.

    WHILE ( lv_day <= pt_zthr0132-endda ).
      "근태(간주)근로시간
      READ TABLE lt_zshr0111 WITH KEY datum = lv_day
                                      awart = '9997'
                                      zstat = 'A'
                                      zabsdayty = 'P'.
      IF sy-subrc = 0.
*        IF lt_zshr0111-zprsdwk_tm IS NOT INITIAL.
*        PERFORM convert_time_to_min IN PROGRAM saplzhr008_3
*                                    USING lt_zshr0111-zprsdwk_tm
*                                    CHANGING lv_min.
        lv_min = 480.  "위평션에서 시간을 주지 않은 경우도 있음
        "8시간 이상이면 8시간만 인정
        IF lv_min > 480.
          lv_min = 480.
        ENDIF.

        ADD lv_min TO lv_awkhr_t_min2.
*        ENDIF.
      ENDIF.

      "출제위원근로시간
      READ TABLE lt_zshr0111 WITH KEY datum = lv_day
                                      awart = '9998'
                                      zstat = 'A'
                                      zabsdayty = 'P'.
      IF sy-subrc = 0 AND lt_zshr0111-zprsdwk_tm IS NOT INITIAL.
        PERFORM convert_time_to_min IN PROGRAM saplzhr008_3
                                    USING lt_zshr0111-zprsdwk_tm
                                    CHANGING lv_min.
        "8시간 이상이면 8시간만 인정
        IF lv_min > 480.
          lv_min = 480.
        ENDIF.

        ADD lv_min TO lv_ewkhr_t_min2.
      ENDIF.


      "기준소정근로시간 소진 판단
      lv_sign = SIGN( lv_pwkhr_sum - ( lv_rwkhr_s_min + lv_awkhr_t_min2 + lv_ewkhr_t_min2 ) ).
      IF lv_sign > 0.
        lv_diff_min = lv_pwkhr_sum - ( lv_rwkhr_s_min + lv_awkhr_t_min2 + lv_ewkhr_t_min2 ).

        "실근로시간
        LOOP AT lt_zthr0112 WHERE datum = lv_day.
          PERFORM convert_time_to_min IN PROGRAM saplzhr008_3
                                      USING lt_zthr0112-zrlwk_tm
                                      CHANGING lv_min.

          IF lv_diff_min >= lv_min.
            "시차(8시간 미만은 8시간 인정)
            IF lt_zthr0112-tdcost IS NOT INITIAL.
              IF lv_min < 480.  "BETWEEN 420 AND 450.
                "추가 인정된 시간은 총근로시간에 포함.
                lv_tdcost_t_min = lv_tdcost_t_min + ( 480 - lv_min ).
                lv_min = 480.
              ENDIF.
            ENDIF.
          ENDIF.

          "재난(8시간 이상은 8시간만 인정)
          IF lt_zthr0112-zemcwk = 'X' AND lv_min > 480.
*            lv_zemcwk_t_min = lv_zemcwk_t_min + ( lv_min - 480 ).
            lv_min = 480.
          ENDIF.


          IF lt_zthr0112-zemcwk = 'X'.
            IF lv_diff_min >= lv_min.
              ADD lv_min TO lt_zthr0112-rwkhr_d_min.  "당일 실근로시간
            ELSE.
              "재난인정시간에서 남은소정근로시간만 인정
*              lt_zthr0112-rwkhr_d_min = lt_zthr0112-rwkhr_d_min + ( lv_min - lv_diff_min ).
              ADD lv_diff_min TO lt_zthr0112-rwkhr_d_min.  "당일 실근로시간
            ENDIF.
          ELSE.
            ADD lv_min TO lt_zthr0112-rwkhr_d_min.  "당일 실근로시간
          ENDIF.

          "가산근로시간 더해줌
          IF lt_zthr0112-zovradd_tm IS NOT INITIAL.
            PERFORM convert_time_to_min IN PROGRAM saplzhr008_3
                                        USING lt_zthr0112-zovradd_tm
                                        CHANGING lv_min.
            ADD lv_min TO lt_zthr0112-rwkhr_d_min.  "당일 실근로시간
          ENDIF.


          ADD lt_zthr0112-rwkhr_d_min TO lv_rwkhr_s_min.
          lt_zthr0112-rwkhr_s_min = lv_rwkhr_s_min + lv_awkhr_t_min2 + lv_ewkhr_t_min2.

          MODIFY lt_zthr0112 TRANSPORTING rwkhr_s_min rwkhr_d_min.
        ENDLOOP.
      ELSE.
*->>> 소진후 : 실근로시간으로 계산
        LOOP AT lt_zthr0112 WHERE datum = lv_day.
          PERFORM convert_time_to_min IN PROGRAM saplzhr008_3
                                      USING lt_zthr0112-zrlwk_tm
                                      CHANGING lv_min.

*          "재난(8시간 이상은 8시간만 인정)
*          IF lt_zthr0112-zemcwk = 'X' AND lv_min > 480.
**            lv_zemcwk_t_min = lv_zemcwk_t_min + ( lv_min - 480 ).
*            lv_min = 480.
*          ENDIF.
          "소진 후에 재난은 제외
          IF lt_zthr0112-zemcwk <> 'X'.
            ADD lv_min TO lt_zthr0112-rwkhr_d_min.  "당일 실근로시간
          ENDIF.

          "가산근로시간 더해줌
          IF lt_zthr0112-zovradd_tm IS NOT INITIAL.
            PERFORM convert_time_to_min IN PROGRAM saplzhr008_3
                                        USING lt_zthr0112-zovradd_tm
                                        CHANGING lv_min.
            ADD lv_min TO lt_zthr0112-rwkhr_d_min."당일 실근로시간
          ENDIF.

          ADD lt_zthr0112-rwkhr_d_min TO lv_rwkhr_s_min.
          lt_zthr0112-rwkhr_s_min = lv_rwkhr_s_min + lv_awkhr_t_min2 + lv_ewkhr_t_min2.

          MODIFY lt_zthr0112 TRANSPORTING rwkhr_s_min rwkhr_d_min.
        ENDLOOP.
      ENDIF.


      lv_day = lv_day + 1.
    ENDWHILE.


    LOOP AT lt_zthr0112.
      IF lt_zthr0112-zdaeh = 'X'.
        "대휴일수
        ADD lt_zthr0112-zdaeh_day TO lv_zdaeh_t_day.  "대휴일수
        "대휴시간
        PERFORM convert_time_to_min IN PROGRAM saplzhr008_3
                          USING lt_zthr0112-zdaeh_tm
                          CHANGING lv_min.
        ADD lv_min TO lv_zdaeh_t_min.

        "휴일근로시간에서 대휴시간을 제외한 시간
        PERFORM convert_time_to_min IN PROGRAM saplzhr008_3
                            USING lt_zthr0112-zrlholwk_tm
                            CHANGING lv_min2.
        lv_zrlholwk_t_min = lv_zrlholwk_t_min + ( lv_min2 - lv_min ).
      ELSE.
        "휴일근로시간
        PERFORM convert_time_to_min IN PROGRAM saplzhr008_3
                            USING lt_zthr0112-zrlholwk_tm
                            CHANGING lv_min.
        ADD lv_min TO lv_zrlholwk_t_min.
      ENDIF.

      "야간근로시간
      PERFORM convert_time_to_min IN PROGRAM saplzhr008_3
                          USING lt_zthr0112-zrlngtwk_tm
                          CHANGING lv_min.
      ADD lv_min TO lv_zrlngtwk_t_min.

      "실근로시간
      PERFORM convert_time_to_min IN PROGRAM saplzhr008_3
                          USING lt_zthr0112-zrlwk_tm
                          CHANGING lv_min.
      ADD lv_min TO lv_zrlwk_t_min.

*      "인정근로시간(분)
*      CLEAR lv_zprsdwk_min.
*      READ TABLE lt_zshr0111 WITH KEY zstat = 'A'
*                                      zabsdayty = 'A'
*                                      datum = lt_zthr0112-datum.
*      IF sy-subrc = 0 AND lt_zshr0111-zprsdwk_tm IS NOT INITIAL.
*        PERFORM convert_time_to_min IN PROGRAM saplzhr008_3
*                                    USING lt_zshr0111-zprsdwk_tm
*                                    CHANGING lv_zprsdwk_min.
*      ENDIF.

      "1. 일별실근로시간합계(분) > 기준소정근로시간(분)
      IF lt_zthr0112-rwkhr_s_min > lv_pwkhr_sum.
        "2. 차이시간(분) = 일별실근로시간합계(분) - 당일실근로시간(분)
        lv_diff_min = lt_zthr0112-rwkhr_s_min - lt_zthr0112-rwkhr_d_min.
        "3. 2계산값 > 기준소정근로시간(분) ->>> 당일실근로시간(분) 대휴계산
        IF lv_diff_min >= lv_pwkhr_sum.  "잔여소정근로시간이 없는 경우
          ADD lv_min TO lv_zrlwk_t_extra.  "기준소정근로시간 소진후 실근로시간

*          IF lv_zprsdwk_min > 0.
*            ADD lv_zprsdwk_min TO lv_zprsdwk_t_extra.  "기준소정근로시간 소진후 인정근로시간
*          ENDIF.
        ELSE.  "잔여소정근로시간이 남아 있는 경우
          "4. 남은시간(분) = 기준소정근로시간 - 2계산값
          lv_remain_min = lv_pwkhr_sum - lv_diff_min.
          "남은시간은 대휴계산시 제외한다.
*          IF lv_remain_min > 0.
          lv_zrlwk_t_extra = lv_zrlwk_t_extra + ( lv_min - lv_remain_min ).

*          IF lv_zprsdwk_min > 0.
*            lv_zprsdwk_t_extra = lv_zprsdwk_t_extra + ( lv_zprsdwk_min - lv_remain_min ).
*          ENDIF.
*          ENDIF.
        ENDIF.

        lv_pwkhr_last = lv_pwkhr_sum.
      ELSE.
        lv_pwkhr_last = lt_zthr0112-rwkhr_s_min.
      ENDIF.

      "가산근로시간
      IF lt_zthr0112-zovradd_tm IS NOT INITIAL.
        PERFORM convert_time_to_min IN PROGRAM saplzhr008_3
                                    USING lt_zthr0112-zovradd_tm
                                    CHANGING lv_min.
        ADD lv_min TO lv_zovradd_t_min.
      ENDIF.

      "시차실비
      ADD lt_zthr0112-tdcost TO lv_tdcost_sum.
    ENDLOOP.


    pt_data-zadmit_ym = pt_zthr0132-endda(6).
    pt_data-pernr = pt_zthr0132-pernr.
    pt_data-begda = pt_zthr0132-begda.
    pt_data-endda = pt_zthr0132-endda.
    pt_data-z52wktp = pt_zthr0132-z52wktp.
    pt_data-z52prsq = pt_zthr0132-z52prsq.

    "등급, 단가
    ls_zshr0141-datum = pt_zthr0132-endda.
    PERFORM g_cw_get_data USING pt_zthr0132-pernr
                                ls_zshr0141
                          CHANGING ls_zshr0143
                                   ls_return.
    pt_data-zdung = ls_zshr0143-zdung.
    pt_data-zcost = ls_zshr0143-zcost.

    "소정근로시간
    PERFORM convert_min_to_hour USING lv_pwkhr_last   "lv_pwkhr_sum
                                CHANGING pt_data-pwkhr.

    "실근로시간의 연장근로시간
    PERFORM convert_min_to_hour USING lv_zrlwk_t_extra  "기준소정근로시간 소진후 실근로시간
                                CHANGING pt_data-owkhr.

    "실 근로시간(휴게시간제외)
    PERFORM convert_min_to_hour USING lv_zrlwk_t_min
                                CHANGING pt_data-zrlwkhr.

    "주중공휴일시간
    PERFORM convert_min_to_hour USING lv_hodhr_min
                                CHANGING pt_data-zpubhhr.

    "인정근로시간
    PERFORM convert_min_to_hour USING lv_zprsdwk_t_min
                                CHANGING pt_data-zprsdwkhr.

    "근로시간(근태)
    PERFORM convert_min_to_hour USING lv_awkhr_t_min2
                                CHANGING pt_data-zadtwkhr.

    "출제위원시간
    PERFORM convert_min_to_hour USING lv_ewkhr_t_min2
                                CHANGING pt_data-zedtwkhr.

    "가산근로시간
    PERFORM convert_min_to_hour USING lv_zovradd_t_min
                                CHANGING pt_data-zrladdwkhr.

    "총근로시간
    lv_zrlwkhrtot_sum = lv_zrlwk_t_min +  "실근로시간
                        lv_tdcost_t_min + "추가인정된 시차 시간
                        lv_zovradd_t_min +  "가산근로시간
                        lv_zprsdwk_t_min +  "인정근로시간(A/A)
                        lv_awkhr_t_min2 +  "근태(간주)근로시간(9997/A/P)
                        lv_ewkhr_t_min2.  "출제위원시간(9998/A/P)
*                        lv_zemcwk_t_min +  "재난인정시간(실근로시간 - 8시간)
*                        lv_zrlwk_t_extra.  "소정근로시간 소진 후 실근로시간
    PERFORM convert_min_to_hour USING lv_zrlwkhrtot_sum
                                CHANGING pt_data-zrlwkhrtot.

    "초과근로시간
    lv_sign = SIGN( lv_zrlwkhrtot_sum -  "총근로시간
                    lv_pwkhr_sum -  "기준소정근로시간
                    lv_awkhr_t_min2 -  "근태(간주)근로시간
                    lv_ewkhr_t_min2 ).  "출제위원시간
    IF lv_sign = 1.
      lv_zrlexwkhr_min = lv_zrlwkhrtot_sum -
                         lv_pwkhr_sum -
                         lv_awkhr_t_min2 -
                         lv_ewkhr_t_min2.
    ELSE.
      lv_zrlexwkhr_min = 0.
    ENDIF.
    PERFORM convert_min_to_hour USING lv_zrlexwkhr_min
                                CHANGING pt_data-zrlexwkhr.

    "연장근로시간
    lv_sign = SIGN( lv_zrlexwkhr_min -  "초과근로시간
                    ( lv_zrlholwk_t_min +  "휴일근로시간
                      lv_zdaeh_t_min ) ). "대휴근로시간
    IF lv_sign = 1.
      lv_zrlovrwkhr_sum = lv_zrlexwkhr_min -  "초과근로시간
                          ( lv_zrlholwk_t_min +  "휴일근로시간
                            lv_zdaeh_t_min ).  "대휴근로시간
    ELSE.
      lv_zrlovrwkhr_sum = 0.
    ENDIF.


    PERFORM convert_min_to_hour USING lv_zrlovrwkhr_sum
                                CHANGING pt_data-zrlovrwkhr.

    "야간근로시간
    PERFORM convert_min_to_hour USING lv_zrlngtwk_t_min
                                CHANGING pt_data-zrlngtwkhr.

    "휴일근로시간
    PERFORM convert_min_to_hour USING lv_zrlholwk_t_min
                                CHANGING pt_data-zrlholwkhr.

    "대휴일수
    pt_data-zdaeh_day = lv_zdaeh_t_day.

    "대휴시간
    PERFORM convert_min_to_hour USING lv_zdaeh_t_min
                                CHANGING pt_data-zdaehhr.

    "연장근로수당(연장근로시간 * 단가)
    pt_data-zrlovramt = ( lv_zrlovrwkhr_sum / 60 ) * pt_data-zcost.

    "야간근로수당(야간시간 * 단가 * 50%)
    pt_data-zrlngtamt = ( lv_zrlngtwk_t_min / 60 ) * ( pt_data-zcost * '0.5' ).

    "휴일근로수당(휴일시간 * 단가 * 150%)
    pt_data-zrlholamt = ( lv_zrlholwk_t_min / 60 ) * ( pt_data-zcost * '1.5' ).

    "대휴수당(대휴시간 * 단가 * 50%)
    pt_data-zdaehamt = ( lv_zdaeh_t_min / 60 ) * ( pt_data-zcost * '0.5' ).

    "시차실비
    pt_data-tdcost = lv_tdcost_sum.

    "기간실비
    pt_data-zrlprdamt = pt_data-zrlovramt +  "연장근로수당
                        pt_data-zrlngtamt +  "야간근로수당
                        pt_data-zrlholamt +  "휴일근로수당
                        pt_data-zdaehamt +  "대휴수당
                        pt_data-tdcost.  "시차실비

    pt_data-waers = 'KRW'.

    APPEND pt_data.
    CLEAR pt_data.
  ENDLOOP.

ENDFORM.                    " MAKE_PAYMENT_WKPRD
*&---------------------------------------------------------------------*
*&      Form  MAKE_DAEH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_ZTHR0112  text
*      <--P_LT_SAVE  text
*----------------------------------------------------------------------*
FORM make_daeh_data TABLES pt_daeh STRUCTURE zshr0146
                            lt_zthr0112_chk STRUCTURE zshr0145
                           pt_save STRUCTURE zshr0145
                     USING  ps_zthr0112 TYPE zshr0145
                            pv_exh  "소정근로시간 소진여부
                            pv_remain_stdaz.  "소진 못한 시간

  DATA: lt_zshr0115 TYPE TABLE OF zshr0115,
        ls_zshr0115 TYPE zshr0115,
        ls_zshr0145 type zshr0145,
        lt_data TYPE ztshr0115 WITH HEADER LINE,
        lt_attributes TYPE TABLE OF casdayattr WITH HEADER LINE,
        lt_attributes2 TYPE TABLE OF casdayattr WITH HEADER LINE,
        lv_sign TYPE i,
        lv_chk,
        lv_zdaeh_t_min TYPE i,
        lv_min TYPE i,
        lv_zrlwk_t_min TYPE i,
        stdaz_s LIKE lt_data-stdaz,
        stdaz_e LIKE lt_data-stdaz,
        temp TYPE i,
        count TYPE i,
        lv_zrlwk_tm TYPE zshr0115-zrlwk_tm,
        pv_remain_tm TYPE zshr0115-zrlwk_tm,
        check_date TYPE datum,
        double_chk(1) TYPE c,
        chk_hol1(1) TYPE c,
        chk_hol2(2) TYPE c.



  MOVE-CORRESPONDING ps_zthr0112 TO ls_zshr0115.

  CALL FUNCTION 'ZHR_52TM_CALC_WORK_TIME_DAYILY'
    EXPORTING
      is_day     = ls_zshr0115
    TABLES
      t_day_time = lt_zshr0115.

  SORT  lt_zshr0115 DESCENDING BY days.

  "잔여 소정근로시간을 전부 소진 못하고 남은 시간은 제외한다.
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

   SORT  lt_zshr0115 ASCENDING BY days.

  "전체 휴일이고, 4.5시간 미만이면 합친다.
  LOOP AT lt_zshr0115 INTO ls_zshr0115.
    IF pv_exh = 'N'.  "잔여 소정근로시간 남아 있는 경우
      CALL FUNCTION 'DAY_ATTRIBUTES_GET'
        EXPORTING
          factory_calendar           = 'KR'
          holiday_calendar           = 'KB'
          date_from                  = ls_zshr0115-datum
          date_to                    = ls_zshr0115-datum
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
      IF lt_attributes-weekday = '6' OR lt_attributes-weekday = '7'.
        lv_chk = 'X'. EXIT.
      ENDIF.
    ENDIF.

    IF ls_zshr0115-days <> '0'. "전체 휴일인가(0:휴일)
      lv_chk = 'X'. EXIT.
    ENDIF.

    IF ls_zshr0115-stdaz >= '4.5'. "4.5 시간 미만인가
      lv_chk = 'X'. EXIT.
    ENDIF.

    PERFORM convert_time_to_min USING ls_zshr0115-zrlwk_tm
                                CHANGING lv_min.
    ADD lv_min TO lv_zrlwk_t_min.
  ENDLOOP.

  IF lv_chk IS INITIAL.
    PERFORM convert_min_to_time USING lv_zrlwk_t_min
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


  LOOP AT lt_data WHERE days = '0' AND stdaz >= '4.5' .


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
      IF lt_attributes-holiday = 'X' AND NOT ( lt_attributes-weekday = '6' OR lt_attributes-weekday = '7' ).
        chk_hol1 = 1. " 주중공휴일이면 1 / 주말이면 2
      ENDIF.
      CHECK lt_attributes-holiday = 'X' AND NOT ( lt_attributes-weekday = '6' OR lt_attributes-weekday = '7' ).
    ELSE.  "잔여 소정근로시간 없거나, 전부 소진 못하고 남은 경우
      "휴일때 발생
      chk_hol1 = 2. " 주중공휴일이면 1 / 주말이면 2
      CHECK lt_attributes-freeday = 'X'.
    ENDIF.


    " 대휴 중복 발생 여부 체크
    " 전일자 대휴 발생 여부를 체크하여
*    check_date = lt_data-datum - 1.
*
*    READ TABLE lt_zthr0112_chk WITH KEY datum = check_date
*                                                              ztomo = 'X'.
*    double_chk = 'N'.
*
*    IF sy-subrc = 0.
*
*      MOVE-CORRESPONDING lt_zthr0112_chk TO ls_zshr0115.
*
*      CALL FUNCTION 'ZHR_52TM_CALC_WORK_TIME_DAYILY'
*        EXPORTING
*          is_day     = ls_zshr0115
*        TABLES
*          t_day_time = lt_zshr0115.
*
*      LOOP AT lt_zshr0115 INTO ls_zshr0115.
*        IF ls_zshr0115-datum = lt_data-datum.
*
*          IF ls_zshr0115-zrlwk_tm >= '043000'.
*            " 전일자 익일 근무가 4.5이상이면 대휴 발생 조건에 만족함.
*            " 그러므로 이 경우에는 대휴 발생하면 안됨........
*            double_chk = 'Y'.
*          ENDIF.
*        ENDIF.
*      ENDLOOP.
*
*    ENDIF.
*
*    IF double_chk = 'N'.


*   대휴발생 중복체크. 2019.11.05. 임재하.
*   하나로 퉁쳐서 발생되는 건 (EX: 20191022 16:00~09:00)과
*   익일에 근무(16:00~22:00)가 연달아 생기는경우
*   하루에 중복근무해도 1건만 대휴는 1건만 생겨야 한다는 원칙을 위배 함.
*   (익일 근무가 2건이 생기게 됨)
*   따라서 전일자 근무건을 쪼개어, 익일때문에 대휴가 발생한 건과
*   당일의 당일건 때문에 발생한 건이 중복될경우
*   당일의 당일건 은 생성하지 않도록 처리한다.


    "기 마감돌렸던 대휴건은 lt_zthr0112_chk에 들어 있고
    "이번마감으로 새로 생기는 pt_daeh에 들어 있음.

************************************************************************
    IF lt_data-stdaz IS NOT INITIAL AND lv_chk = 'X'.

      count = lines( lt_data ). " 휴일이 쪼개져서(익일로) lt_data가 두건이상일 경우는 stdaz 대신 실근로시간
*      휴일 익일근무의 경우
*      예) 토 18 시 출근 익일 일 09시 퇴근의 경우 ->>> 각각 대휴 1개씩 발생함 (이때 대휴시간은)
*      예) 토 18시 출근 익일 일 03시 퇴근의 경우 ->>> 토 대휴 1개만 발생함 (이때 대휴시간은 8)

      stdaz_s = lt_data-stdaz.

      LOOP AT lt_data WHERE stdaz < '4.5' .
*          4.5 시간 (대휴 발생 요건)이 안되면 합친다.
*          ex) 하루가 4.5시간이 넘고(대휴발생) 다른 날은 4.5가 안되면 두 시간을 합친다.

* ------ 20201108 김지훈 휴일 성격이 다른지 체크하는 로직 추가( 주중공휴일인지 주말인지 ) -----------

        CALL FUNCTION 'DAY_ATTRIBUTES_GET'
          EXPORTING
            factory_calendar           = 'KR'
            holiday_calendar           = 'KB'
            date_from                  = lt_data-datum
            date_to                    = lt_data-datum
            language                   = sy-langu
          TABLES
            day_attributes             = lt_attributes2
          EXCEPTIONS
            factory_calendar_not_found = 1
            holiday_calendar_not_found = 2
            date_has_invalid_format    = 3
            date_inconsistency         = 4
            OTHERS                     = 5.

        READ TABLE lt_attributes2 INDEX 1.

*        IF  lt_attributes2-holiday = 'X' AND NOT ( lt_attributes-weekday = '6' OR lt_attributes-weekday = '7' ).
*          chk_hol2 = 1. " 주중공휴일이면 1 / 주말이면 2
*        ELSE.
*          chk_hol2 = 2. " 주중공휴일이면 1 / 주말이면 2
*        ENDIF.

        IF  lt_attributes2-holiday = 'X' AND NOT ( lt_attributes2-weekday = '6' OR lt_attributes2-weekday = '7' )..
          chk_hol2 = 1. " 주중공휴일이면 1
        ELSEIF  lt_attributes2-holiday IS INITIAL AND ( lt_attributes2-weekday = '6' OR lt_attributes2-weekday = '7' ).
          chk_hol2 = 2. " 주말이면 2
        ELSEIF   lt_attributes2-holiday IS INITIAL AND NOT ( lt_attributes2-weekday = '6' OR lt_attributes2-weekday = '7' ).
          chk_hol2 = 3. " 일반평일이면 3
        ENDIF.


"IF chk_hol1 = chk_hol2. " 휴일 성격이 같아야함
IF ( chk_hol1 = 1 OR  chk_hol1 = 2 ) AND ( chk_hol2 = 1 OR  chk_hol2 = 2 ) . " 당일 다음날 둘다 휴일(휴휴) 인 경우는 시간 합쳐야 함
* ------------------------------------------------------------------------------

        IF ( sy-tabix = 1 AND lt_data-days = '1' OR " 당일 휴일이면서 다음날 평일의 경우
            sy-tabix = 2 AND lt_data-days = '1' ) .  "당일 휴일이면서 다음날 휴일의 경우


          stdaz_e = lt_data-stdaz.

        ENDIF.
ENDIF.
      ENDLOOP.

      lt_data-stdaz = stdaz_s + stdaz_e.

      temp = lt_data-stdaz * 60.

      PERFORM convert_min_to_time USING temp
                                  CHANGING pv_remain_tm.
    ENDIF.
*     2020.07.06 xa30752 추가
*     소정,연장 걸쳐있는 주말 근무의 경우 주말 총근로시간에서 소정시간을 제외한 후
*     대휴시간 계산
************************************************************************

    CLEAR ls_zshr0115.

    "당일에 발생한 당일건 확인.
    IF lt_data-datum eq ps_zthr0112-datum.

      "전일에 발생한 익일건 확인(이번마감에 생긴거)
      check_date = lt_data-datum - 1.
      READ TABLE pt_save WITH KEY pernr = ps_zthr0112-pernr
                                  datum = check_date.
      IF sy-subrc eq 0.
        MOVE-CORRESPONDING pt_save TO ls_zshr0115.
      ENDIF.

      "전일에 발생한 익일건 확인(마감 프로그램 두번이상 실행했을때 이미 생겨있는거)
      CLEAR ls_zshr0145.
      READ TABLE lt_zthr0112_chk WITH KEY pernr = ps_zthr0112-pernr
                                          datum = check_date
                                          ztomo = 'X' "(안전빵을 위해 추가 조건 하나 더)
                                          zdaeh = 'X'
                                 INTO ls_zshr0145.
      IF sy-subrc eq 0.
        MOVE-CORRESPONDING ls_zshr0145 TO ls_zshr0115.
      ENDIF.

      IF ls_zshr0115 IS NOT INITIAL.
        CALL FUNCTION 'ZHR_52TM_CALC_WORK_TIME_DAYILY'
          EXPORTING
            is_day     = ls_zshr0115
          TABLES
            t_day_time = lt_zshr0115.

        READ TABLE lt_zshr0115 WITH KEY datum   = ps_zthr0112-datum
                               INTO ls_zshr0115.

        IF sy-subrc eq 0 .
          IF ls_zshr0115-stdaz >= '4.5'.
            CONTINUE.
          ENDIF.
        ENDIF.


      ENDIF.

    ENDIF.
*   -->

    ADD 1 TO ps_zthr0112-zdaeh_day.


    MOVE-CORRESPONDING ps_zthr0112 TO pt_daeh.

    pt_daeh-daeh_dt = lt_data-datum.
    pt_daeh-daeh_dt = lt_data-datum.

    IF pv_remain_tm IS NOT INITIAL. "   xa30752 수정  2020.07.06
      pt_daeh-zrlwk_tm = pv_remain_tm..
    ELSE.
      pt_daeh-zrlwk_tm = lt_data-zrlwk_tm.
    ENDIF.

    pt_daeh-zbegtm = lt_data-zbegtm.
    pt_daeh-zendtm = lt_data-zendtm.


    "대휴시간 합
    PERFORM convert_time_to_min USING pt_daeh-zrlwk_tm
                            CHANGING lv_min.
    ADD lv_min TO lv_zdaeh_t_min.


    APPEND pt_daeh.
    CLEAR pt_daeh.

    CLEAR: stdaz_s, stdaz_e.

  ENDLOOP.



  "ZTHR0112 업데이트 용도(대휴여부, 대휴일수, 대휴시간)
  IF ps_zthr0112-zdaeh_day > 0.
    ps_zthr0112-zdaeh = 'X'.
    PERFORM convert_min_to_time USING lv_zdaeh_t_min
                                CHANGING ps_zthr0112-zdaeh_tm.

    MOVE-CORRESPONDING ps_zthr0112 TO pt_save.
    APPEND pt_save.
    CLEAR pt_save.
  ENDIF.



ENDFORM.                    " MAKE_DAEH_DATA

*&---------------------------------------------------------------------*
*&      Form  CHECK_DOUBLE_DAEH
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LT_ZTHR0112  text
*      <--P_LT_SAVE  text
*----------------------------------------------------------------------*
FORM check_double_daeh TABLES lt_daeh STRUCTURE zshr0146
                                                         lt_save STRUCTURE zshr0145.


  DATA: check_date TYPE datum.

  READ TABLE lt_save WITH KEY zdaeh_day = 2.

  check_date = lt_save-datum + 1. " 다음날은 대휴 발생하면 안됨

  sy-tabix = sy-tabix + 1.

  IF sy-subrc = 0.

    DELETE lt_save INDEX sy-tabix.
  ENDIF.


  READ TABLE lt_daeh WITH KEY datum = check_date.

  IF sy-subrc = 0.
    DELETE lt_daeh INDEX sy-tabix.

  ENDIF.

ENDFORM.                    "check_double_daeh
