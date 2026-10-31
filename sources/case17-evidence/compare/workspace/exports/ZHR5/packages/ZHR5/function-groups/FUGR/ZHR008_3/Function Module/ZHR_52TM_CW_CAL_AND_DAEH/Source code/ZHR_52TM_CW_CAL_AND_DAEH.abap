FUNCTION zhr_52tm_cw_cal_and_daeh .
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(I_CASE) TYPE  CHAR1
*"  TABLES
*"      LT_ZTHR0132 STRUCTURE  ZTHR0132 OPTIONAL
*"      LT_ZTHR0113 STRUCTURE  ZTHR0113 OPTIONAL
*"      LT_DAEH STRUCTURE  ZSHR0146 OPTIONAL
*"      LT_SAVE STRUCTURE  ZSHR0145 OPTIONAL
*"      LT_DAILY STRUCTURE  ZSHR0145 OPTIONAL
*"----------------------------------------------------------------------
  DATA: lt_zshr0111 TYPE TABLE OF zshr0111 WITH HEADER LINE,
        lt_zshr0111_1 TYPE TABLE OF zshr0111 WITH HEADER LINE,
        lt_zthr0112	TYPE TABLE OF zshr0145 WITH HEADER LINE,
        lt_tmp  TYPE TABLE OF zshr0145 WITH HEADER LINE,
        lt_zshr0115 TYPE TABLE OF zshr0115,
        ls_zshr0115 TYPE zshr0115,
        lt_attributes TYPE TABLE OF casdayattr WITH HEADER LINE,
        ls_zshr0141 TYPE zshr0141,
        ls_zshr0143 TYPE zshr0143,
        ls_zshr0137 TYPE zshr0137,
        ls_return TYPE bapireturn1,
        lt_data TYPE TABLE OF zshr0111 WITH HEADER LINE,
        wa_zthrbs05 TYPE zthrbs05,
        wa_zthrcost TYPE zthrcost.

  DATA: lv_pwkhr_min TYPE i,
        lv_hodhr_min TYPE i,
        lv_owkhr_min TYPE i,
        lv_cwkhr_min TYPE i,
        lv_genhr TYPE i,
        lv_genhr_min TYPE i,
        lv_genhr_sum TYPE i,
        lv_genhr_diff TYPE i,
        lv_genhr_until TYPE i,
        lv_genhr_total TYPE i,
        lv_min TYPE i,
        lv_zrlholwk_d_min TYPE i,
        lv_max_sum_min TYPE i,
        lv_max_sum_min2  TYPE i,
        lv_sum  TYPE i,
        lv_sum2 TYPE i,
        lv_min2 TYPE i,
        lv_min3 TYPE i,
        lv_min4 TYPE i,
        lv_min5 TYPE i,
        lv_min6 TYPE i,
        lv_min7 TYPE i,
        lv_min8 TYPE i,
        lv_min9 TYPE i,
        lv_min10 TYPE i,
        lv_min11 TYPE i,
        lv_min12 TYPE i,
        lv_min13 TYPE i,
        lv_tabix TYPE i,
        lv_tabix2 TYPE i,
        lv_zrlwk_t_min TYPE i,
        lv_zprsdwk_t_min TYPE i,
        lv_awkhr_t_min TYPE i,
        lv_ewkhr_t_min TYPE i,
        lv_pwkhr_sum TYPE i,
        lv_pwkhr_net TYPE i,
        lv_hkhr_min TYPE i,
        lv_hkhr_sum TYPE i,
        lv_day TYPE dats,
        lv_awkhr_t_min2 TYPE i,
        lv_ewkhr_t_min2 TYPE i,
        lv_sign TYPE i,
        lv_diff TYPE i,
        lv_diff_min TYPE i,
        lv_tdcost_t_min TYPE i,
        lv_wkhr_s_min TYPE i, "평일 총근로시간
        lv_hkhr_s_min TYPE i, " 휴일 총근로시간
        lv_wkhr_s_min_t TYPE i, "평일 총근로시간
        lv_hkhr_s_min_t TYPE i, " 휴일 총근로시간
        lv_rwkhr_s_min TYPE i, " 누적근로시간
        lv_remain_min TYPE i,
        lv_remain_stdaz TYPE stdaz,
        lv_min_t TYPE i,
        lv_stdaz_t TYPE stdaz,
        lv_zdaeh_t_day TYPE i,
        lv_zdaeh_t_min TYPE i,
        lv_zrlholwk_t_min TYPE i,
        lv_zrlholwk_t_min_50 TYPE i,
        lv_zrlholwk_t_min_150 TYPE i,
        lv_zrlholwk_t_min_150_x TYPE i,
        lv_zrlngtwk_t_min TYPE i,
        lv_zrlwk_t_extra TYPE i,
        lv_zrlwk_extra TYPE i,
        lv_max_extra1 TYPE i,
        lv_max_extra2 TYPE i,
        lv_exceed1 TYPE i,
        lv_exceed2 TYPE i,
        lv_first TYPE i,
        lv_first1 TYPE i,
        lv_first2 TYPE i,
        lv_pwkhr_last TYPE i,
        lv_zovradd_t_min TYPE i,
        lv_zrlholwk_min TYPE i,
        lv_tdcost_sum TYPE zetdcost,
        lv_zrlwkhrtot_sum TYPE i,
        lv_zrlexwkhr_min TYPE i,
        lv_zrlovrwkhr_sum TYPE i,
        lv_time TYPE tims,
        lv_zprsdwk_min TYPE i,
        lv_zprsdwk_t_extra TYPE i,
        lv_next_dif TYPE i,
        lv_exh_datum1 TYPE dats.

  DATA : l_daynr  LIKE  hrvsched-daynr,
             lv_holiday.

  DATA: lv_datum TYPE sy-datum,
            lv_next_holiday, lv_next_day.

  DATA : time1 TYPE zchar06,
             time2 TYPE zchar06,
             time_dif TYPE zchar06.


  CLEAR: lt_zthr0113[], lt_daeh[], lt_save[], lt_daily[], gr_state[].

  CASE i_case.
    WHEN 'A'.   "선택근로 마감및지급(ZRPTH411:소급)
      state_macro gr_state 'I' 'EQ' '3'.
      state_macro gr_state 'I' 'EQ' 'E'.
      state_macro gr_state 'I' 'EQ' 'H'.
    WHEN 'B' OR "선택근로 마감및지급(ZRPTH411:정상)
         'C'.   "선택근로대상자 관리(ZRPTH410)
      state_macro gr_state 'I' 'EQ' '3'.
      state_macro gr_state 'I' 'EQ' 'H'.
    WHEN 'D'.  "선택근로 일별 근무실적 조회(ZRPTH413)
      state_macro gr_state 'I' 'EQ' '0'.
      state_macro gr_state 'I' 'EQ' '3'.
      state_macro gr_state 'I' 'EQ' 'E'.
      state_macro gr_state 'I' 'EQ' 'H'.
  ENDCASE.


  LOOP AT lt_zthr0132.
    CLEAR: lv_wkhr_s_min, lv_pwkhr_min, lv_hodhr_min, lv_owkhr_min, lv_cwkhr_min, lv_exceed1, lv_exceed2, lv_max_sum_min, lv_max_sum_min2,  lv_sum, lv_sum2,
           lv_min, lv_min2, lv_min3, lv_min4, lv_min5, lv_min6, lv_min7,  lv_min8,  lv_min9,  lv_min10,  lv_min11, lv_min12, lv_min13, lv_first,  lv_first1, lv_first2, lv_max_extra1, lv_max_extra2,
           lv_zprsdwk_t_min, lv_awkhr_t_min, lv_ewkhr_t_min, lv_next_dif,
           lv_pwkhr_sum, lv_day, lv_hkhr_s_min,  lv_awkhr_t_min2, lv_ewkhr_t_min2, lv_hkhr_min, lv_hkhr_sum,
           lv_sign, lv_diff_min, lv_tdcost_t_min,
           lv_rwkhr_s_min, lv_remain_min, lv_remain_stdaz,
           lv_zdaeh_t_day, lv_zdaeh_t_min,
           lv_zrlholwk_t_min_50, lv_zrlholwk_t_min_150, lv_zrlholwk_t_min_150_x,
           lv_zrlngtwk_t_min, lv_zrlwk_t_min, lv_zrlwk_t_extra,
           lv_pwkhr_last, lv_zovradd_t_min, lv_tdcost_sum,
           lv_zrlwkhrtot_sum, lv_zrlexwkhr_min, lv_zrlovrwkhr_sum, lv_genhr_sum, lv_genhr_until, lv_genhr_total,
           lv_time, lv_zprsdwk_min, lv_zprsdwk_t_extra, lv_exh_datum1, lv_datum, lv_next_holiday, lv_next_day.

    "소정근로시간(분)
    PERFORM convert_hour_to_min USING lt_zthr0132-pwkhr
                                CHANGING lv_pwkhr_min.
    "주중공휴일시간(분)
    PERFORM convert_hour_to_min USING lt_zthr0132-hodhr
                                CHANGING lv_hodhr_min.

*    "연장가능시간(분)
*    PERFORM convert_hour_to_min USING lt_zthr0132-owkhr
*                                CHANGING lv_owkhr_min.

    CALL FUNCTION 'ZHR_52TM_AWART_LIST'
      EXPORTING
        i_pernr    = lt_zthr0132-pernr
        i_begda    = lt_zthr0132-begda
        i_endda    = lt_zthr0132-endda
        i_zsangsin = 'X'
      TABLES
        t_data     = lt_zshr0111.

    "총 인정근로시간(분)
    LOOP AT lt_zshr0111 WHERE zstat = 'A' AND zabsdayty = 'A'.  "휴무와 익휴
      IF lt_zshr0111-zprsdwk_tm IS NOT INITIAL.
        PERFORM convert_time_to_min USING lt_zshr0111-zprsdwk_tm
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
        PERFORM convert_time_to_min USING lt_zshr0111-zprsdwk_tm
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
                   lv_zprsdwk_t_min.  "인정근로시간(A/A)
*                   lv_awkhr_t_min -  "근태(간주)근로시간(9997/A/P)
*                   lv_ewkhr_t_min.  "출제위원근로시간(9998/A/P)

    "최종소정근로시간(기준소정근로시간 소진 이후부터는 변동)
    lv_pwkhr_last = lv_pwkhr_sum.

    "실적 조회
    SELECT *
      INTO CORRESPONDING FIELDS OF TABLE lt_zthr0112
      FROM zthr0112
     WHERE pernr = lt_zthr0132-pernr
       AND begda = lt_zthr0132-begda
       AND endda = lt_zthr0132-endda
       AND z52wktp = lt_zthr0132-z52wktp
       AND z52prsq = lt_zthr0132-z52prsq
       AND state IN gr_state.

*    IF sy-subrc <> 0.
*      EXIT.
*    ENDIF.

    SORT lt_zthr0112 BY datum seqnr.

    IF i_case = 'A'.
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
    ELSEIF i_case = 'D'.
      lt_tmp[] = lt_zthr0112[].
    ENDIF.


    lv_day = lt_zthr0132-begda.

    IF sy-datum < '20220401'.

      WHILE ( lv_day <= lt_zthr0132-endda ).
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

          IF i_case = 'D'.  "일별근무실적 조회인 경우
            CLEAR lt_tmp.
            PERFORM convert_min_to_time USING lv_min
                                        CHANGING lv_time.

            READ TABLE lt_tmp WITH KEY pernr = lt_zthr0132-pernr
                                         datum = lv_day.
            IF sy-subrc = 0.
              lt_tmp-c_time = lv_time.
              MODIFY lt_tmp INDEX sy-tabix TRANSPORTING c_time.
            ELSE.
              lt_tmp-pernr = lt_zthr0132-pernr.
              lt_tmp-datum = lv_day.
              lt_tmp-begda = lt_zthr0132-begda.
              lt_tmp-endda = lt_zthr0132-endda.
              lt_tmp-z52wktp = lt_zthr0132-z52wktp.
              lt_tmp-z52prsq = lt_zthr0132-z52prsq.
              lt_tmp-c_time = lv_time.
              APPEND lt_tmp.
            ENDIF.
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
          PERFORM convert_time_to_min USING lt_zshr0111-zprsdwk_tm
                                      CHANGING lv_min.
          "8시간 이상이면 8시간만 인정
          IF lv_min > 480.
            lv_min = 480.
          ENDIF.

          IF i_case = 'D'.  "일별근무실적 조회인 경우
            CLEAR lt_tmp.
            PERFORM convert_min_to_time USING lv_min
                                        CHANGING lv_time.
            READ TABLE lt_tmp WITH KEY pernr = lt_zthr0132-pernr
                                       datum = lv_day.
            IF sy-subrc = 0.
              lt_tmp-d_time = lv_time.
              MODIFY lt_tmp INDEX sy-tabix TRANSPORTING d_time.
            ELSE.
              lt_tmp-pernr = lt_zthr0132-pernr.
              lt_tmp-datum = lv_day.
              lt_tmp-begda = lt_zthr0132-begda.
              lt_tmp-endda = lt_zthr0132-endda.
              lt_tmp-z52wktp = lt_zthr0132-z52wktp.
              lt_tmp-z52prsq = lt_zthr0132-z52prsq.
              lt_tmp-d_time = lv_time.
              APPEND lt_tmp.
            ENDIF.
          ENDIF.

          ADD lv_min TO lv_ewkhr_t_min2.
        ENDIF.

        IF i_case = 'D'.  "일별근무실적 조회인 경우
          "공휴일
          READ TABLE lt_zshr0111 WITH KEY datum = lv_day
                                          zstat = 'A'
                                          zabsdayty = 'H'.
          IF sy-subrc = 0 AND lt_zshr0111-zprsdwk_tm IS NOT INITIAL.
            CLEAR lt_tmp.
            READ TABLE lt_tmp WITH KEY pernr = lt_zthr0132-pernr
                                       datum = lv_day.
            IF sy-subrc = 0.
              lt_tmp-a_time = lt_zshr0111-zprsdwk_tm.
              MODIFY lt_tmp INDEX sy-tabix TRANSPORTING a_time.
            ELSE.
              lt_tmp-pernr = lt_zthr0132-pernr.
              lt_tmp-datum = lv_day.
              lt_tmp-begda = lt_zthr0132-begda.
              lt_tmp-endda = lt_zthr0132-endda.
              lt_tmp-z52wktp = lt_zthr0132-z52wktp.
              lt_tmp-z52prsq = lt_zthr0132-z52prsq.
              lt_tmp-a_time = lt_zshr0111-zprsdwk_tm.
              APPEND lt_tmp.
            ENDIF.
          ENDIF.

          "인정(휴가)
          READ TABLE lt_zshr0111 WITH KEY datum = lv_day
                                          zstat = 'A'
                                          zabsdayty = 'A'.
          IF sy-subrc = 0 AND lt_zshr0111-zprsdwk_tm IS NOT INITIAL.
            CLEAR lt_tmp.
            READ TABLE lt_tmp WITH KEY pernr = lt_zthr0132-pernr
                                       datum = lv_day.
            IF sy-subrc = 0.
              lt_tmp-b_time = lt_zshr0111-zprsdwk_tm.
              MODIFY lt_tmp INDEX sy-tabix TRANSPORTING b_time.
            ELSE.
              lt_tmp-pernr = lt_zthr0132-pernr.
              lt_tmp-datum = lv_day.
              lt_tmp-begda = lt_zthr0132-begda.
              lt_tmp-endda = lt_zthr0132-endda.
              lt_tmp-z52wktp = lt_zthr0132-z52wktp.
              lt_tmp-z52prsq = lt_zthr0132-z52prsq.
              lt_tmp-b_time = lt_zshr0111-zprsdwk_tm.
              APPEND lt_tmp.
            ENDIF.
          ENDIF.
        ENDIF.


        "기준소정근로시간 소진 판단
        lv_sign = SIGN( lv_pwkhr_sum - ( lv_rwkhr_s_min + lv_awkhr_t_min2 + lv_ewkhr_t_min2 ) ).


        IF lv_sign > 0.
          "남은소정근로시간(소진못한시간)
          lv_diff_min = lv_pwkhr_sum - ( lv_rwkhr_s_min + lv_awkhr_t_min2 + lv_ewkhr_t_min2 ).

          "실근로시간
          READ TABLE lt_zthr0112 WITH KEY datum = lv_day.
          IF sy-subrc = 0.
            LOOP AT lt_zthr0112 WHERE datum = lv_day.
              PERFORM convert_time_to_min USING lt_zthr0112-zrlwk_tm
                                          CHANGING lv_min.
              "소진못한 시간이 있을때 추가 인정된 시차시간은 총근로시간에 포함.
              IF lv_diff_min >= lv_min.
                "시차(8시간 미만은 8시간 인정)
                IF lt_zthr0112-tdcost IS NOT INITIAL.
                  IF lv_min < 480.  "BETWEEN 420 AND 450.
                    "추가 인정된 시간은 총근로시간에 포함.
                    lv_tdcost_t_min = lv_tdcost_t_min + ( 480 - lv_min ).
                    lv_min = 480.
                  ENDIF.
                ENDIF.
*             ELSEIF ( lv_diff_min < lv_min ) AND
              ENDIF.

              "재난(8시간 이상은 8시간만 인정)
              IF lt_zthr0112-zemcwk = 'X' AND lv_min > 480.
                lv_min = 480.
              ENDIF.

              "재난은 남은소정근로시간이 당일 실근로시간보단 적을때는 남은 소정근로시간만 인정한다.
              IF lt_zthr0112-zemcwk = 'X'.
                IF lv_diff_min >= lv_min.
                  ADD lv_min TO lt_zthr0112-rwkhr_d_min.
                ELSE.
                  "재난인정시간에서 남은소정근로시간만 인정
                  ADD lv_diff_min TO lt_zthr0112-rwkhr_d_min.
                ENDIF.
              ELSE.
                ADD lv_min TO lt_zthr0112-rwkhr_d_min.
              ENDIF.

              "가산근로시간 더해줌
              IF lt_zthr0112-zovradd_tm IS NOT INITIAL.
                PERFORM convert_time_to_min USING lt_zthr0112-zovradd_tm
                                            CHANGING lv_min.
                ADD lv_min TO lt_zthr0112-rwkhr_d_min.  "당일 실근로시간
              ENDIF.


              ADD lt_zthr0112-rwkhr_d_min TO lv_rwkhr_s_min.
              lt_zthr0112-rwkhr_s_min = lv_rwkhr_s_min + lv_awkhr_t_min2 + lv_ewkhr_t_min2.

              MODIFY lt_zthr0112 TRANSPORTING rwkhr_s_min rwkhr_d_min.

              IF i_case = 'D'.  "일별근무실적 조회인 경우
                READ TABLE lt_tmp WITH KEY pernr = lt_zthr0112-pernr
                                           datum = lt_zthr0112-datum
                                           seqnr = lt_zthr0112-seqnr.
                IF sy-subrc = 0.
                  lt_tmp-rwkhr_s_min = lt_zthr0112-rwkhr_s_min.
                  lt_tmp-rwkhr_d_min = lt_zthr0112-rwkhr_d_min.
                  MODIFY lt_tmp INDEX sy-tabix TRANSPORTING rwkhr_s_min rwkhr_d_min.
                ENDIF.
              ENDIF.
            ENDLOOP.
          ELSE.

            IF i_case = 'D'.  "일별근무실적 조회인 경우
              READ TABLE lt_tmp WITH KEY pernr = lt_zthr0132-pernr
                                         datum = lv_day.
              IF sy-subrc = 0.
                lt_tmp-rwkhr_s_min = lv_rwkhr_s_min + lv_awkhr_t_min2 + lv_ewkhr_t_min2.

                PERFORM convert_time_to_min USING lt_tmp-c_time
                                            CHANGING lv_min.

                PERFORM convert_time_to_min USING lt_tmp-d_time
                                            CHANGING lv_min2.

                lt_tmp-rwkhr_d_min = lv_min + lv_min2.
                MODIFY lt_tmp INDEX sy-tabix TRANSPORTING rwkhr_s_min rwkhr_d_min.
              ENDIF.
            ENDIF.

          ENDIF.
        ELSE.
          "소정근로시간 소진 이후 인정근로시간은 연장근로시간에 포함하기위해서 필요
          IF lv_exh_datum1 IS INITIAL.
            lv_exh_datum1 = lv_day.  "소진이후 근무일
          ENDIF.

*->>> 소진후 : 실근로시간으로 계산
          READ TABLE lt_zthr0112 WITH KEY datum = lv_day.
          IF sy-subrc = 0.
            LOOP AT lt_zthr0112 WHERE datum = lv_day.
              PERFORM convert_time_to_min USING lt_zthr0112-zrlwk_tm
                                          CHANGING lv_min.

*          "재난(8시간 이상은 8시간만 인정)
*          IF lt_zthr0112-zemcwk = 'X' AND lv_min > 480.
*            lv_min = 480.
*          ENDIF.

              "소진 후에 재난은 제외
              IF lt_zthr0112-zemcwk <> 'X'.
                ADD lv_min TO lt_zthr0112-rwkhr_d_min.  "당일 실근로시간
              ENDIF.

              "가산근로시간 더해줌
              IF lt_zthr0112-zovradd_tm IS NOT INITIAL.
                PERFORM convert_time_to_min USING lt_zthr0112-zovradd_tm
                                            CHANGING lv_min.
                ADD lv_min TO lt_zthr0112-rwkhr_d_min."당일 실근로시간
              ENDIF.

              ADD lt_zthr0112-rwkhr_d_min TO lv_rwkhr_s_min.
              lt_zthr0112-rwkhr_s_min = lv_rwkhr_s_min + lv_awkhr_t_min2 + lv_ewkhr_t_min2.

              MODIFY lt_zthr0112 TRANSPORTING rwkhr_s_min rwkhr_d_min.

              IF i_case = 'D'.  "일별근무실적 조회인 경우
                READ TABLE lt_tmp WITH KEY pernr = lt_zthr0112-pernr
                                           datum = lt_zthr0112-datum
                                           seqnr = lt_zthr0112-seqnr.
                IF sy-subrc = 0.
                  lt_tmp-rwkhr_s_min = lt_zthr0112-rwkhr_s_min.
                  lt_tmp-rwkhr_d_min = lt_zthr0112-rwkhr_d_min.
                  MODIFY lt_tmp INDEX sy-tabix TRANSPORTING rwkhr_s_min rwkhr_d_min.
                ENDIF.
              ENDIF.
            ENDLOOP.
          ELSE.

            IF i_case = 'D'.  "일별근무실적 조회인 경우
              READ TABLE lt_tmp WITH KEY pernr = lt_zthr0132-pernr
                                         datum = lv_day.
              IF sy-subrc = 0.
                lt_tmp-rwkhr_s_min = lv_rwkhr_s_min + lv_awkhr_t_min2 + lv_ewkhr_t_min2.

                PERFORM convert_time_to_min USING lt_tmp-c_time
                                            CHANGING lv_min.

                PERFORM convert_time_to_min USING lt_tmp-d_time
                                            CHANGING lv_min2.

                lt_tmp-rwkhr_d_min = lv_min + lv_min2.
                MODIFY lt_tmp INDEX sy-tabix TRANSPORTING rwkhr_s_min rwkhr_d_min.
              ENDIF.
            ENDIF.

          ENDIF.
        ENDIF.

        lv_day = lv_day + 1.
      ENDWHILE.

    ELSE. " 소정근로 계산방식 변경 xa30752

      CLEAR: lt_zshr0111[].

      CALL FUNCTION 'ZHR_52TM_AWART_LIST'
        EXPORTING
          i_pernr    = lt_zthr0132-pernr
          i_begda    = lt_zthr0132-begda
          i_endda    = lt_zthr0132-endda
          i_zsangsin = 'X'
        TABLES
          t_data     = lt_zshr0111.

      WHILE ( lv_day <= lt_zthr0132-endda ).

        CLEAR: lt_zshr0111.

*        LOOP AT lt_zshr0111_1 WHERE datum = lv_day.
*          lt_zshr0111-pernr = lt_zshr0111_1-pernr.
*          lt_zshr0111-datum = lt_zshr0111_1-datum.
*          lt_zshr0111-zabsdayty = lt_zshr0111_1-zabsdayty.
*          lt_zshr0111-awart = lt_zshr0111_1-awart.
*          lt_zshr0111-atext = lt_zshr0111_1-atext.
*          lt_zshr0111-zprsdwk_tm = lt_zshr0111_1-zprsdwk_tm.
*          lt_zshr0111-zstat = lt_zshr0111_1-zstat.
*          lt_zshr0111-zstxt = lt_zshr0111_1-zstxt.
*
*          APPEND lt_zshr0111.
*        ENDLOOP.

        "근태(간주)근로시간
        READ TABLE lt_zshr0111 WITH KEY datum = lv_day
                                        awart = '9997'
                                        zstat = 'A'
                                        zabsdayty = 'P'.
        IF sy-subrc = 0.

          CLEAR: l_daynr, lv_holiday.
          CALL FUNCTION 'ZHR_GET_DAY_DATA'
            EXPORTING
              znal    = lv_day
            IMPORTING
              daynr	  = l_daynr
              holiday = lv_holiday.

          IF l_daynr <> '6' AND l_daynr <> '7'.

            IF lv_holiday = 'X'. "휴일은 간주근로 시간 노 인정
                lv_min = 0.
            ELSE.
              lv_min = 480.  "위평션에서 시간을 주지 않은 경우도 있음
              "8시간 이상이면 8시간만 인정
              IF lv_min > 480.
                lv_min = 480.
              ENDIF.
            ENDIF.

            IF i_case = 'D'.  "일별근무실적 조회인 경우

            "해당일자가 간주근로이면 휴일 상관없이 8시간을 평일 시간에 먼저 더해줌
            " 밑에  lv_awkhr_t_min2에서 이미 더해서 간주근로시간 합계를 계산하고 있기에 여기서 또 해줄 필요 없어서 주석처리
*             IF  lt_zshr0111[] IS NOT INITIAL AND lt_zshr0111-awart EQ '9997' AND lt_zshr0111-zabsdayty EQ 'P'
*                  AND  l_daynr <> '6' AND l_daynr <> '7' AND lv_holiday <> 'X'.
*                    lv_wkhr_s_min =  lv_wkhr_s_min + '480' .
*             ENDIF.

              CLEAR lt_tmp.
              PERFORM convert_min_to_time USING lv_min
                                          CHANGING lv_time.

              READ TABLE lt_tmp WITH KEY pernr = lt_zthr0132-pernr
                                           datum = lv_day.
              IF sy-subrc = 0.
                lt_tmp-c_time = lv_time.
                MODIFY lt_tmp INDEX sy-tabix TRANSPORTING c_time.
              ELSE.
                lt_tmp-pernr = lt_zthr0132-pernr.
                lt_tmp-datum = lv_day.
                lt_tmp-begda = lt_zthr0132-begda.
                lt_tmp-endda = lt_zthr0132-endda.
                lt_tmp-z52wktp = lt_zthr0132-z52wktp.
                lt_tmp-z52prsq = lt_zthr0132-z52prsq.
                lt_tmp-c_time = lv_time.
                APPEND lt_tmp.
              ENDIF.
            ENDIF.

            ADD lv_min TO lv_awkhr_t_min2.

          ENDIF.
        ENDIF.

        "출제위원근로시간
        READ TABLE lt_zshr0111 WITH KEY datum = lv_day
                                        awart = '9998'
                                        zstat = 'A'
                                        zabsdayty = 'P'.
        IF sy-subrc = 0 AND lt_zshr0111-zprsdwk_tm IS NOT INITIAL.
          PERFORM convert_time_to_min USING lt_zshr0111-zprsdwk_tm
                                      CHANGING lv_min.
          "8시간 이상이면 8시간만 인정
          IF lv_min > 480.
            lv_min = 480.
          ENDIF.

          IF i_case = 'D'.  "일별근무실적 조회인 경우
            CLEAR lt_tmp.
            PERFORM convert_min_to_time USING lv_min
                                        CHANGING lv_time.
            READ TABLE lt_tmp WITH KEY pernr = lt_zthr0132-pernr
                                       datum = lv_day.
            IF sy-subrc = 0.
              lt_tmp-d_time = lv_time.
              MODIFY lt_tmp INDEX sy-tabix TRANSPORTING d_time.
            ELSE.
              lt_tmp-pernr = lt_zthr0132-pernr.
              lt_tmp-datum = lv_day.
              lt_tmp-begda = lt_zthr0132-begda.
              lt_tmp-endda = lt_zthr0132-endda.
              lt_tmp-z52wktp = lt_zthr0132-z52wktp.
              lt_tmp-z52prsq = lt_zthr0132-z52prsq.
              lt_tmp-d_time = lv_time.
              APPEND lt_tmp.
            ENDIF.
          ENDIF.

          ADD lv_min TO lv_ewkhr_t_min2.
        ENDIF.

        IF i_case = 'D'.  "일별근무실적 조회인 경우
          "공휴일
          READ TABLE lt_zshr0111 WITH KEY datum = lv_day
                                          zstat = 'A'
                                          zabsdayty = 'H'.
          IF sy-subrc = 0 AND lt_zshr0111-zprsdwk_tm IS NOT INITIAL.
            CLEAR lt_tmp.
            READ TABLE lt_tmp WITH KEY pernr = lt_zthr0132-pernr
                                       datum = lv_day.
            IF sy-subrc = 0.
              lt_tmp-a_time = lt_zshr0111-zprsdwk_tm.
              MODIFY lt_tmp INDEX sy-tabix TRANSPORTING a_time.
            ELSE.
              lt_tmp-pernr = lt_zthr0132-pernr.
              lt_tmp-datum = lv_day.
              lt_tmp-begda = lt_zthr0132-begda.
              lt_tmp-endda = lt_zthr0132-endda.
              lt_tmp-z52wktp = lt_zthr0132-z52wktp.
              lt_tmp-z52prsq = lt_zthr0132-z52prsq.
              lt_tmp-a_time = lt_zshr0111-zprsdwk_tm.
              APPEND lt_tmp.
            ENDIF.
          ENDIF.

          "인정(휴가)
          READ TABLE lt_zshr0111 WITH KEY datum = lv_day
                                          zstat = 'A'
                                          zabsdayty = 'A'.
          IF sy-subrc = 0 AND lt_zshr0111-zprsdwk_tm IS NOT INITIAL.
            CLEAR lt_tmp.
            READ TABLE lt_tmp WITH KEY pernr = lt_zthr0132-pernr
                                       datum = lv_day.
            IF sy-subrc = 0.
              lt_tmp-b_time = lt_zshr0111-zprsdwk_tm.
              MODIFY lt_tmp INDEX sy-tabix TRANSPORTING b_time.
            ELSE.
              lt_tmp-pernr = lt_zthr0132-pernr.
              lt_tmp-datum = lv_day.
              lt_tmp-begda = lt_zthr0132-begda.
              lt_tmp-endda = lt_zthr0132-endda.
              lt_tmp-z52wktp = lt_zthr0132-z52wktp.
              lt_tmp-z52prsq = lt_zthr0132-z52prsq.
              lt_tmp-b_time = lt_zshr0111-zprsdwk_tm.
              APPEND lt_tmp.
            ENDIF.
          ENDIF.
        ENDIF.


        "기준소정근로시간 소진 판단
        lv_sign = SIGN( lv_pwkhr_sum - ( lv_rwkhr_s_min + lv_awkhr_t_min2 + lv_ewkhr_t_min2 ) ).
*      소정근로 계산방식 변경
*      평일 총근로시간 먼저 기준 소정근로시간으로 채우고
*      그 다음에 휴일 총근로시간을 기준 소정근로시간으로 채움
*      기준 소정근로시간 차감할 때 우선순위 필요함
*      그렇지만 정산시점에 평일,휴일 근무에 대해서 실적이 입력 완료되었다고 가정하고
*      소정근로시간 소진여부를 판단하기 때문에 여기서는 우선순위를 두고 개발하지 않겠음

* 근무일자가 평일인지, 휴일인지 확인
        CLEAR: l_daynr, lv_holiday.
        CALL FUNCTION 'ZHR_GET_DAY_DATA'
          EXPORTING
            znal    = lv_day
          IMPORTING
            daynr	  = l_daynr
            holiday = lv_holiday.
*
* 근태는 휴일근로시간으로 간주
*        CLEAR: lt_zshr0111[].
*
*        CALL FUNCTION 'ZHR_52TM_AWART_LIST'
*          EXPORTING
*            i_pernr    = lt_zthr0132-pernr
*            i_begda    = lv_day
*            i_endda    = lv_day
*            i_zsangsin = 'X'
*          TABLES
*            t_data     = lt_zshr0111.

       "해당근무일자가 간주근로인 경우  --->606줄로 이동
*        IF  lt_zshr0111[] IS NOT INITIAL AND lt_zshr0111-awart EQ '9997' AND lt_zshr011-zabsdayty EQ 'P'
*              AND  l_daynr <> '6' AND l_daynr <> '7' AND lv_holiday <> 'X'.
*          lv_wkhr_s_min =  lv_wkhr_s_min + '480' .
*        ENDIF.


*        IF  lt_zshr0111-zprsdwk_tm = '080000'.
        IF lt_zshr0111[] IS NOT INITIAL AND lt_zshr0111-awart <> '9999' AND lt_zshr0111-datum EQ lv_day
            AND lt_zshr0111-zprsdwk_tm IS NOT INITIAL.
          l_daynr = '7'.
          lv_holiday = 'X'. " 일요일 취급...

*        ELSEIF lt_zshr0111-zprsdwk_tm = '040000'.
        ENDIF.


        IF lv_sign > 0.

          lv_diff_min = lv_pwkhr_sum - lv_wkhr_s_min.

          "실근로시간
          READ TABLE lt_zthr0112 WITH KEY datum = lv_day.
          IF sy-subrc = 0.
            LOOP AT lt_zthr0112 WHERE datum = lv_day.
              PERFORM convert_time_to_min USING lt_zthr0112-zrlwk_tm
                                          CHANGING lv_min.

******           소정근로시간내  평일 근무일 경우 시차근로 가산시간 계산 xa30752 2020.09.10
*            "소진못한 시간이 있을때 추가 인정된 시차시간은 총근로시간에 포함.
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

              "가산근로시간 더해줌
              IF lt_zthr0112-zovradd_tm IS NOT INITIAL.
                PERFORM convert_time_to_min USING lt_zthr0112-zovradd_tm
                                            CHANGING lv_min11.
                PERFORM convert_time_to_min USING lt_zthr0112-zrlwk_tm
                                            CHANGING lt_zthr0112-rwkhr_d_min.

                ADD lv_min11 TO lt_zthr0112-rwkhr_d_min.  " 가산시간을 더한 당일 근로시간
              ENDIF.

******            평일과 휴일 총근로시간 구분하여 계산 xa30752 2020.08.01
              IF l_daynr <> '6' AND l_daynr <> '7' AND lv_holiday <> 'X'. " 평일일 경우
                IF lt_zthr0112-ztomo = 'X' AND lt_zthr0112-zrlholwk_tm IS NOT INITIAL. " 평휴

                  PERFORM convert_time_to_min USING lt_zthr0112-zrlholwk_tm
                                              CHANGING lv_zrlholwk_d_min.

                    lv_min = lv_min - lv_zrlholwk_d_min.

                  ADD lv_min TO lv_wkhr_s_min. " 평일 총근로시간
                  ADD lv_zrlholwk_d_min TO lv_hkhr_s_min. " 휴일 총근로시간
                ELSE.
                  IF lt_zthr0112-zovradd_tm IS NOT INITIAL.
                    ADD lt_zthr0112-rwkhr_d_min TO lv_wkhr_s_min. " 평일 총근로시간
                  ELSE.
                    ADD lv_min TO lv_wkhr_s_min. " 평일 총근로시간
                  ENDIF.
                ENDIF.

              ELSE. " 휴일인 경우
                IF  lt_zthr0112-ztomo = 'X' . "익일 평일로 넘어가는 근무시간이 있는 경우 나눠서 계산
                 time1 = lt_zthr0112-zrlwk_tm.
                 time2 = lt_zthr0112-zrlholwk_tm.
                 CALL FUNCTION 'ZHR_MINUS_TIME_N'
                  EXPORTING
                   TIME1    = time1
                   TIME2    = time2
                 IMPORTING
                   TIME_DIF = time_dif.
                 PERFORM convert_time_to_min USING time_dif
                                           CHANGING lv_min.
               "차이나는 시간은 평일근무시간에 포함
                 ADD lv_min TO lv_wkhr_s_min. " 평일 총근로시간


                "휴일총근로시간 합산
                PERFORM convert_time_to_min USING  lt_zthr0112-zrlholwk_tm
                                       CHANGING lv_min.
                ADD lv_min TO lv_hkhr_s_min. " 휴일(주중공휴일 포함) 총근로시간

               ELSEIF  lt_zshr0111[] IS NOT INITIAL.
                "휴가가 있어도 평일 총근로시간 합계에 넣어준다
                CALL FUNCTION 'ZHR_52TM_AWART_LIST'
                  EXPORTING
                   I_PERNR          =  lt_zthr0112-pernr
                   I_BEGDA          =  lt_zthr0112-datum
                   I_ENDDA          = lt_zthr0112-datum
                   I_ZSANGSIN       = 'X'
                 IMPORTING
                   E_RETURN         = ls_return
                  TABLES
                    T_DATA           = lt_data.
                LOOP AT lt_data WHERE atext = '연차' OR atext = '반차' OR atext = '일반' OR  atext = '청원' OR  atext = '공가'. "일단 근태, 공가가 있어도 근무실적이 있으면 포함한다
                 PERFORM convert_time_to_min USING  lt_zthr0112-zrlwk_tm
                                       CHANGING lv_min.
                 ADD lv_min TO lv_wkhr_s_min. " 평일 총근로시간
                ENDLOOP.

                IF lt_zthr0112-zovradd_tm IS NOT INITIAL.
                  ADD lt_zthr0112-rwkhr_d_min TO lv_hkhr_s_min. " 휴일 총근로시간
                ELSE.
                  ADD lv_min TO lv_hkhr_s_min. " 휴일(주중공휴일 포함) 총근로시간
                ENDIF.

               ENDIF.

              ENDIF.
*****
              ADD lt_zthr0112-rwkhr_d_min TO lv_rwkhr_s_min.

              lt_zthr0112-rwkhr_s_min = lv_wkhr_s_min + lv_hkhr_s_min
                                                        + lv_awkhr_t_min2 + lv_ewkhr_t_min2.

              MODIFY lt_zthr0112 TRANSPORTING rwkhr_s_min rwkhr_d_min.

              IF i_case = 'D'.  "일별근무실적 조회인 경우
                READ TABLE lt_tmp WITH KEY pernr = lt_zthr0112-pernr
                                           datum = lt_zthr0112-datum
                                           seqnr = lt_zthr0112-seqnr.
                IF sy-subrc = 0.
                  lt_tmp-rwkhr_s_min = lt_zthr0112-rwkhr_s_min.
                  lt_tmp-rwkhr_d_min = lt_zthr0112-rwkhr_d_min.
                  MODIFY lt_tmp INDEX sy-tabix TRANSPORTING rwkhr_s_min rwkhr_d_min.
                ENDIF.
              ENDIF.
            ENDLOOP.
          ELSE.

            IF i_case = 'D'.  "일별근무실적 조회인 경우
              READ TABLE lt_tmp WITH KEY pernr = lt_zthr0132-pernr
                                         datum = lv_day.
              IF sy-subrc = 0.
*              lt_tmp-rwkhr_s_min = lv_rwkhr_s_min + lv_awkhr_t_min2 + lv_ewkhr_t_min2.
                lt_tmp-rwkhr_s_min = lv_wkhr_s_min + lv_hkhr_s_min
                                                   + lv_awkhr_t_min2 + lv_ewkhr_t_min2.

                PERFORM convert_time_to_min USING lt_tmp-c_time
                                            CHANGING lv_min.

                PERFORM convert_time_to_min USING lt_tmp-d_time
                                            CHANGING lv_min2.

                lt_tmp-rwkhr_d_min = lv_min + lv_min2.
                MODIFY lt_tmp INDEX sy-tabix TRANSPORTING rwkhr_s_min rwkhr_d_min.
              ENDIF.
            ENDIF.

          ENDIF.
        ELSE.
          "소정근로시간 소진 이후 인정근로시간은 연장근로시간에 포함하기위해서 필요
          IF lv_exh_datum1 IS INITIAL.
            lv_exh_datum1 = lv_day.  "소진이후 근무일
          ENDIF.

*->>> 소진후 : 실근로시간으로 계산
          READ TABLE lt_zthr0112 WITH KEY datum = lv_day.
          IF sy-subrc = 0.
            LOOP AT lt_zthr0112 WHERE datum = lv_day.

* 근무일자가 평일인지, 휴일인지 확인
              CLEAR: l_daynr, lv_holiday.
              CALL FUNCTION 'ZHR_GET_DAY_DATA'
                EXPORTING
                  znal    = lv_day
                IMPORTING
                  daynr	  = l_daynr
                  holiday = lv_holiday.

              PERFORM convert_time_to_min USING lt_zthr0112-zrlwk_tm
                                          CHANGING lv_min.

              "가산근로시간 더해줌
              IF lt_zthr0112-zovradd_tm IS NOT INITIAL.
                PERFORM convert_time_to_min USING lt_zthr0112-zovradd_tm
                                            CHANGING lv_min.
                PERFORM convert_time_to_min USING lt_zthr0112-zrlwk_tm
                                            CHANGING lt_zthr0112-rwkhr_d_min.

                ADD lv_min TO lt_zthr0112-rwkhr_d_min.  " 가산시간을 더한 당일 근로시간
              ENDIF.

******            평일과 휴일 총근로시간 구분하여 계산 xa30752 2020.08.01
              IF lt_zthr0112-ztomo = 'X' AND lt_zthr0112-zrlholwk_tm IS NOT INITIAL. " 평휴

                PERFORM convert_time_to_min USING lt_zthr0112-zrlholwk_tm
                                            CHANGING lv_zrlholwk_d_min.

                lv_min = lv_min - lv_zrlholwk_d_min.

                ADD lv_min TO lv_wkhr_s_min. " 평일 총근로시간
                ADD lv_zrlholwk_d_min TO lv_hkhr_s_min. " 휴일 총근로시간
              ELSE.

                IF l_daynr <> '6' AND l_daynr <> '7' AND lv_holiday <> 'X'. " 평일일 경우
                  ADD lv_min TO lv_wkhr_s_min. " 평일 총근로시간
                ELSE. " 휴일인 경우
                  ADD lv_min TO lv_hkhr_s_min. " 휴일(주중공휴일 포함) 총근로시간
                ENDIF.
              ENDIF.
*****
              ADD lt_zthr0112-rwkhr_d_min TO lv_rwkhr_s_min.

              lt_zthr0112-rwkhr_s_min = lv_wkhr_s_min + lv_hkhr_s_min
                                                       + lv_awkhr_t_min2 + lv_ewkhr_t_min2.

              MODIFY lt_zthr0112 TRANSPORTING rwkhr_s_min rwkhr_d_min.

              IF i_case = 'D'.  "일별근무실적 조회인 경우
                READ TABLE lt_tmp WITH KEY pernr = lt_zthr0112-pernr
                                           datum = lt_zthr0112-datum
                                           seqnr = lt_zthr0112-seqnr.
                IF sy-subrc = 0.
                  lt_tmp-rwkhr_s_min = lt_zthr0112-rwkhr_s_min.
                  lt_tmp-rwkhr_d_min = lt_zthr0112-rwkhr_d_min.
                  MODIFY lt_tmp INDEX sy-tabix TRANSPORTING rwkhr_s_min rwkhr_d_min.
                ENDIF.
              ENDIF.
            ENDLOOP.
          ELSE.

            IF i_case = 'D'.  "일별근무실적 조회인 경우
              READ TABLE lt_tmp WITH KEY pernr = lt_zthr0132-pernr
                                         datum = lv_day.
              IF sy-subrc = 0.

                lt_tmp-rwkhr_s_min = lv_wkhr_s_min + lv_hkhr_s_min
                                                       + lv_awkhr_t_min2 + lv_ewkhr_t_min2.

                PERFORM convert_time_to_min USING lt_tmp-c_time
                                            CHANGING lv_min.

                PERFORM convert_time_to_min USING lt_tmp-d_time
                                            CHANGING lv_min2.

                lt_tmp-rwkhr_d_min = lv_min + lv_min2.
                MODIFY lt_tmp INDEX sy-tabix TRANSPORTING rwkhr_s_min rwkhr_d_min.
              ENDIF.
            ENDIF.

          ENDIF.
        ENDIF.

        lv_day = lv_day + 1.
      ENDWHILE.

      "간주근로일자가 존재하면 최대근로시간(208)까지만 추가로 총평일근로시간에 더 해줌
      CLEAR: lv_max_sum_min, lv_sum, lv_min12.

      "일단 총근로시간에 총간주근로시간도 더해줌
         lv_wkhr_s_min =  lv_wkhr_s_min + lv_awkhr_t_min2.

       "평일+휴일 근로시간이 208시간이 넘는지 먼저 확인(재난 등)
        lv_max_sum_min = lv_wkhr_s_min + lv_hkhr_s_min.
            "208시간 보다 클 수 있지만 간주근로가 있는데 208보다 큰 경우 208시간으로 제한
            IF lv_max_sum_min > '12480'.
               lv_sum =  lv_max_sum_min.
             LOOP AT  lt_zshr0111.
              "평일인지 휴일인지 확인
              CLEAR: l_daynr, lv_holiday.
              CALL FUNCTION 'ZHR_GET_DAY_DATA'
               EXPORTING
                 znal    =  lt_zshr0111-datum
               IMPORTING
                daynr	  = l_daynr
                holiday = lv_holiday.
              IF lt_zshr0111-awart = '9997' AND lt_zshr0111-zabsdayty = 'P' AND  l_daynr <> '6' AND l_daynr <> '7' AND lv_holiday <> 'X'.
                   lv_sum =  lv_sum - '480' .
                  IF lv_sum <= '12480'. "간주근로들 때문에 작아진거면 그냥 208시간으로 인정
                     lv_wkhr_s_min = '12480' -  lv_hkhr_s_min.
                    EXIT.
                  ELSE.
                     lv_wkhr_s_min = lv_sum -  lv_hkhr_s_min.
                  ENDIF.
              ENDIF.
             ENDLOOP.
            ENDIF.


    ENDIF.


    CASE i_case.
      WHEN 'A' OR 'B'.  "선택근로 마감및지급(ZRPTH411) 에서 CALL

        IF sy-datum < '20220401'.
          LOOP AT lt_zthr0112.
            IF lt_zthr0112-zdaeh = 'X'.
              "대휴일수
              ADD lt_zthr0112-zdaeh_day TO lv_zdaeh_t_day.  "대휴일수
              "대휴시간
              PERFORM convert_time_to_min USING lt_zthr0112-zdaeh_tm
                                          CHANGING lv_min.
              ADD lv_min TO lv_zdaeh_t_min.
            ENDIF.


            MOVE-CORRESPONDING lt_zthr0112 TO ls_zshr0115.

            CALL FUNCTION 'ZHR_52TM_CALC_WORK_TIME_DAYILY'
              EXPORTING
                is_day     = ls_zshr0115
              TABLES
                t_day_time = lt_zshr0115.


            LOOP AT lt_zshr0115 INTO ls_zshr0115.
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

              IF lt_zthr0112-zdaeh = 'X'.
                "휴일근로시간에서 대휴시간을 제외한 시간
                PERFORM convert_time_to_min USING ls_zshr0115-zrlwk_tm
                                            CHANGING lv_min2.
                "휴일근로시간 - 대휴시간
                lv_sign = lv_min2 - lv_min.
                IF lv_sign = 1.
                  "주중공휴일(150%)
                  IF lt_attributes-holiday = 'X' AND NOT ( lt_attributes-weekday = '6' OR lt_attributes-weekday = '7' ).
                    lv_zrlholwk_t_min_150_x = lv_zrlholwk_t_min_150_x + ( lv_min2 - lv_min ).
                  ELSEIF ( lt_attributes-weekday = '6' OR lt_attributes-weekday = '7' ). "주휴일(50%)
                    lv_zrlholwk_t_min_50 = lv_zrlholwk_t_min_50 + ( lv_min2 - lv_min ).
                  ENDIF.

                ENDIF.

                lv_min = ABS( lv_min2 - lv_min ).

              ELSE.
                "휴일근로시간
                PERFORM convert_time_to_min USING ls_zshr0115-zrlwk_tm
                                            CHANGING lv_min.
                "주중공휴일(150%)
                IF lt_attributes-holiday = 'X' AND NOT ( lt_attributes-weekday = '6' OR lt_attributes-weekday = '7' ).
                  ADD lv_min TO lv_zrlholwk_t_min_150_x.
                ELSEIF ( lt_attributes-weekday = '6' OR lt_attributes-weekday = '7' ). "주휴일(50%)
                  ADD lv_min TO lv_zrlholwk_t_min_50.
                ENDIF.
              ENDIF.

            ENDLOOP.


            "야간근로시간
            PERFORM convert_time_to_min USING lt_zthr0112-zrlngtwk_tm
                                        CHANGING lv_min.
            ADD lv_min TO lv_zrlngtwk_t_min.

            "실근로시간
            PERFORM convert_time_to_min USING lt_zthr0112-zrlwk_tm
                                        CHANGING lv_min.
            ADD lv_min TO lv_zrlwk_t_min.

*          "1. 일별실근로시간합계(분) > 기준소정근로시간(분)
*          IF lt_zthr0112-rwkhr_s_min > lv_pwkhr_sum.
*            "2. 차이시간(분) = 일별실근로시간합계(분) - 당일실근로시간(분)
*            lv_diff_min = lt_zthr0112-rwkhr_s_min - lt_zthr0112-rwkhr_d_min.
*            "3. 2계산값 > 기준소정근로시간(분) ->>> 당일실근로시간(분) 대휴계산
*            IF lv_diff_min >= lv_pwkhr_sum.  "잔여소정근로시간이 없는 경우
**              ADD lv_min TO lv_zrlwk_t_extra.  "기준소정근로시간 소진후 실근로시간
*            ELSE.  "잔여소정근로시간이 남아 있는 경우(한번만 실행됨)
*              "4. 남은시간(분) = 기준소정근로시간 - 2계산값
*              lv_remain_min = lv_pwkhr_sum - lv_diff_min.
*              "남은시간은 실근로계산시 제외한다.
**              lv_zrlwk_t_extra = lv_zrlwk_t_extra + ( lv_min - lv_remain_min ).
*            ENDIF.
*
**            lv_pwkhr_last = lv_pwkhr_sum.  "최종소정근로시간
*          ELSE.
**            lv_pwkhr_last = lt_zthr0112-rwkhr_s_min.  "최종소정근로시간
*          ENDIF.

*************************************************************************
            IF lt_zthr0112-zdaeh = 'X'.
              " 소정,연장근로가 걸친 휴일근무(대휴발생)의 경우
              " ( 휴일총근로시간(소정) - 대휴시간(연장) ) * 50% 지급 필요 " xa30752 2020.07.08

              IF lt_zthr0112-zrlholwk_tm <> lt_zthr0112-zdaeh_tm.
                PERFORM convert_time_to_min USING lt_zthr0112-zrlholwk_tm
                                              CHANGING lv_min6.

                PERFORM convert_time_to_min USING lt_zthr0112-zdaeh_tm
                                              CHANGING lv_min7.

                lv_zrlholwk_t_min_50 = lv_zrlholwk_t_min_50 + ( lv_min6 - lv_min7 ).
              ENDIF.
            ENDIF.
*************************************************************************

            "가산근로시간
            IF lt_zthr0112-zovradd_tm IS NOT INITIAL.
              PERFORM convert_time_to_min USING lt_zthr0112-zovradd_tm
                                          CHANGING lv_min.
              ADD lv_min TO lv_zovradd_t_min.
            ENDIF.

            "시차실비
            ADD lt_zthr0112-tdcost TO lv_tdcost_sum.
          ENDLOOP.


          lt_zthr0113-zadmit_ym = lt_zthr0132-endda(6).
          lt_zthr0113-pernr = lt_zthr0132-pernr.
          lt_zthr0113-begda = lt_zthr0132-begda.
          lt_zthr0113-endda = lt_zthr0132-endda.
          lt_zthr0113-z52wktp = lt_zthr0132-z52wktp.
          lt_zthr0113-z52prsq = lt_zthr0132-z52prsq.

          "등급, 단가
*          ls_zshr0141-datum = lt_zthr0132-endda.
          ls_zshr0141-datum = lt_zthr0132-begda."중간에 퇴직한 사람들 있어서 종료일로 하면 단가 못 가져옴
          PERFORM g_cw_get_data USING lt_zthr0132-pernr
                                      ls_zshr0141
                                CHANGING ls_zshr0143
                                         ls_return.
          lt_zthr0113-zdung = ls_zshr0143-zdung.
          lt_zthr0113-zcost = ls_zshr0143-zcost.

          "소정근로시간
          PERFORM convert_min_to_hour USING lv_pwkhr_last
                                      CHANGING lt_zthr0113-pwkhr.

***        "실근로시간의 연장근로시간
***        PERFORM convert_min_to_hour USING lv_zrlwk_t_extra  "기준소정근로시간 소진후 실근로시간
***                                    CHANGING lt_zthr0113-owkhr.

          "실 근로시간(휴게시간제외)
          PERFORM convert_min_to_hour USING lv_zrlwk_t_min
                                      CHANGING lt_zthr0113-zrlwkhr.

          "주중공휴일시간
          PERFORM convert_min_to_hour USING lv_hodhr_min
                                      CHANGING lt_zthr0113-zpubhhr.

          "인정근로시간
          PERFORM convert_min_to_hour USING lv_zprsdwk_t_min
                                      CHANGING lt_zthr0113-zprsdwkhr.

          "근로시간(근태)
          PERFORM convert_min_to_hour USING lv_awkhr_t_min2
                                      CHANGING lt_zthr0113-zadtwkhr.

          "출제위원시간
          PERFORM convert_min_to_hour USING lv_ewkhr_t_min2
                                      CHANGING lt_zthr0113-zedtwkhr.

          "가산근로시간
          PERFORM convert_min_to_hour USING lv_zovradd_t_min
                                      CHANGING lt_zthr0113-zrladdwkhr.

          "총근로시간 계산
          lv_zrlwkhrtot_sum = lv_zrlwk_t_min +  "실근로시간
                              lv_tdcost_t_min + "추가인정된 시차 시간
                              lv_zovradd_t_min +  "가산근로시간
                              lv_zprsdwk_t_min +  "인정근로시간(A/A)
                              lv_awkhr_t_min2 +  "근태(간주)근로시간(9997/A/P)
                              lv_ewkhr_t_min2.  "출제위원시간(9998/A/P)

          PERFORM convert_min_to_hour USING lv_zrlwkhrtot_sum
                                      CHANGING lt_zthr0113-zrlwkhrtot.

          "초과근로시간 계산
          lv_sign = SIGN( lv_zrlwkhrtot_sum -  "총근로시간
                          lv_pwkhr_sum -  "기준소정근로시간
                          lv_zprsdwk_t_min -  "인정근로시간(A/A)
                          lv_awkhr_t_min2 -  "근태(간주)근로시간
                          lv_ewkhr_t_min2 ).  "출제위원시간
          IF lv_sign = 1.
            lv_zrlexwkhr_min = lv_zrlwkhrtot_sum -
                               lv_pwkhr_sum -
                               lv_zprsdwk_t_min -
                               lv_awkhr_t_min2 -
                               lv_ewkhr_t_min2.
          ELSE.
            IF lv_awkhr_t_min2 IS NOT INITIAL.
            lv_zrlexwkhr_min = lv_zrlwkhrtot_sum -
                               lv_pwkhr_sum -
                               lv_zprsdwk_t_min -
                               lv_ewkhr_t_min2.
            ELSE.
              lv_zrlexwkhr_min = 0.
            ENDIF.
          ENDIF.
          PERFORM convert_min_to_hour USING lv_zrlexwkhr_min
                                      CHANGING lt_zthr0113-zrlexwkhr.

          "연장근로시간 계산
          lv_sign = SIGN( lv_zrlexwkhr_min - "초과근로시간
                            lv_zdaeh_t_min - "대휴근로시간
                            lv_zrlholwk_t_min_150_x ).


          IF lv_sign = 1.
            lv_zrlovrwkhr_sum = lv_zrlexwkhr_min - "초과근로시간
                                  lv_zdaeh_t_min - "대휴근로시간
                                  lv_zrlholwk_t_min_150_x.

          ELSE.
            lv_zrlovrwkhr_sum = 0.
          ENDIF.
          "연장근로시간
          PERFORM convert_min_to_hour USING lv_zrlovrwkhr_sum
                                      CHANGING lt_zthr0113-zrlovrwkhr.

          "야간근로시간
          PERFORM convert_min_to_hour USING lv_zrlngtwk_t_min
                                      CHANGING lt_zthr0113-zrlngtwkhr.

          "휴일근로시간
          lv_zrlholwk_t_min = lv_zrlholwk_t_min_150_x + lv_zrlholwk_t_min_50.
          PERFORM convert_min_to_hour USING lv_zrlholwk_t_min
                                      CHANGING lt_zthr0113-zrlholwkhr.

          "대휴일수
          lt_zthr0113-zdaeh_day = lv_zdaeh_t_day.

          "대휴시간
          PERFORM convert_min_to_hour USING lv_zdaeh_t_min
                                      CHANGING lt_zthr0113-zdaehhr.

          "연장근로수당(연장근로시간 * 단가)
          lt_zthr0113-zrlovramt = ( lv_zrlovrwkhr_sum / 60 ) * lt_zthr0113-zcost.

          "야간근로수당(야간시간 * 단가 * 50%)
          lt_zthr0113-zrlngtamt = ( lv_zrlngtwk_t_min / 60 ) * ( lt_zthr0113-zcost * '0.5' ).

          "휴일근로수당(휴일시간 * 단가 * 50%)
          lt_zthr0113-zrlholamt = ( lv_zrlholwk_t_min_150_x / 60 ) * ( lt_zthr0113-zcost * '1.5' ) +
                                  ( lv_zrlholwk_t_min_50 / 60 ) * ( lt_zthr0113-zcost * '0.5' ).

          "대휴수당(대휴시간 * 단가 * 50%)
          lt_zthr0113-zdaehamt = ( lv_zdaeh_t_min / 60 ) * ( lt_zthr0113-zcost * '0.5' ).

          "시차실비
          lt_zthr0113-tdcost = lv_tdcost_sum.

          "기간실비
          lt_zthr0113-zrlprdamt = lt_zthr0113-zrlovramt +  "연장근로수당
                                  lt_zthr0113-zrlngtamt +  "야간근로수당
                                  lt_zthr0113-zrlholamt +  "휴일근로수당
                                  lt_zthr0113-zdaehamt +  "대휴수당
                                  lt_zthr0113-tdcost.  "시차실비

          lt_zthr0113-waers = 'KRW'.

          APPEND lt_zthr0113.
          CLEAR lt_zthr0113.

        ELSE.  " 소정근로 계산방식 변경 xa30752

          LOOP AT lt_zthr0112.
            IF lt_zthr0112-zdaeh = 'X'.
              "대휴일수
              ADD lt_zthr0112-zdaeh_day TO lv_zdaeh_t_day.  "대휴일수
              "대휴시간
              PERFORM convert_time_to_min USING lt_zthr0112-zdaeh_tm
                                          CHANGING lv_min.
              ADD lv_min TO lv_zdaeh_t_min.
            ENDIF.


            MOVE-CORRESPONDING lt_zthr0112 TO ls_zshr0115.

            CALL FUNCTION 'ZHR_52TM_CALC_WORK_TIME_DAYILY'
              EXPORTING
                is_day     = ls_zshr0115
              TABLES
                t_day_time = lt_zshr0115.


            LOOP AT lt_zshr0115 INTO ls_zshr0115.
              CLEAR lv_tabix2.
              lv_tabix2 = sy-tabix.
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

              IF lt_zthr0112-zdaeh = 'X'.

               "휴일근로시간에서 대휴시간을 제외한 시간 계산
                "20250606-나구엽-선택근무 신청 시 휴일이 걸리는 경우 : 금/토/일/공휴일 4가지 케이스가 있음
                IF ( lt_attributes-weekday = '5' OR  lt_attributes-weekday = '6' OR lt_attributes-weekday = '7' ) OR lt_attributes-holiday = 'X'.

                 "익일이 휴일인 경우만 익일시간을 휴일근로시간에 포함
                  CLEAR: lv_zrlholwk_min, lv_datum, lv_next_holiday.
                  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
                    EXPORTING
                      DATE            =  ls_zshr0115-datum
                      DAYS            = '01'
                      MONTHS          = '00'
                     SIGNUM          = '+'
                      YEARS           = '00'
                   IMPORTING
                     CALC_DATE       = lv_datum.

                 CALL FUNCTION 'ZHR_GET_DAY_DATA'
                  EXPORTING
                    znal    = lv_datum
                  IMPORTING
                    holiday = lv_next_holiday.
                  IF lt_zthr0112-ztomo = 'X' AND lv_next_holiday = 'X' AND ( lt_zthr0112-datum EQ ls_zshr0115-datum ).
                        PERFORM convert_time_to_min USING lt_zthr0112-zrlholwk_tm
                                              CHANGING lv_min2.
                  "20250407-나구엽-선택근로정산시 휴일근무 중 익일+익일(다다음날까지 전부)가 휴일인 경우 휴일근무시간 계산 제외
                  ELSEIF  lt_zthr0112-ztomo = 'X' AND lv_next_holiday = 'X' AND ( lt_zthr0112-datum NE ls_zshr0115-datum ) AND lv_tabix2 >= 2.
                        lv_min2 = 0.
                  ELSEIF  lt_zthr0112-ztomo = 'X' AND lv_next_holiday = '' AND ( lt_zthr0112-datum NE ls_zshr0115-datum ).
                        lv_min2 = 0.
                  ELSE.
                       PERFORM convert_time_to_min USING ls_zshr0115-zrlwk_tm
                                              CHANGING lv_min2.

                  ENDIF.

                  "휴일근로시간 - 대휴시간
                  "대휴시간 lv_min 빼는거 다시 한번 생각해봐야함,,,
                  "lv_sign = SIGN( lv_min2 - lv_zdaeh_t_min ).
                  lv_sign = SIGN( lv_min2 - lv_min ).
                  IF lv_sign = 1.
*                IF lt_attributes-holiday = 'X' AND NOT ( lt_attributes-weekday = '6' OR lt_attributes-weekday = '7' ).
*                  lv_zrlholwk_t_min_150_x = lv_zrlholwk_t_min_150_x + ( lv_min2 - lv_min ).
*                ELSEIF ( lt_attributes-weekday = '6' OR lt_attributes-weekday = '7' ). "주휴일(50%)
*                  lv_zrlholwk_t_min_50 = lv_zrlholwk_t_min_50 + ( lv_min2 - lv_min ).
*                ENDIF.


                    "lv_min = lv_min2 - lv_zdaeh_t_min.
                    CLEAR lv_min13.
                    lv_min13 = lv_min2 - lv_min.

*              주중공휴일 +  주말 (50%) " 주중공휴일 예외 없음 xa30752 2020.08.11
                    ADD lv_min13 TO lv_zrlholwk_t_min_50.

                  ENDIF.
                ENDIF.
              ELSE.
                "휴일근로시간
                PERFORM convert_time_to_min USING ls_zshr0115-zrlwk_tm
                                            CHANGING lv_min.
*                IF lt_attributes-holiday = 'X' AND NOT ( lt_attributes-weekday = '6' OR lt_attributes-weekday = '7' ).
*                  lv_zrlholwk_t_min_150_x = lv_zrlholwk_t_min_150_x + ( lv_min2 - lv_min ).
*                ELSEIF ( lt_attributes-weekday = '6' OR lt_attributes-weekday = '7' ). "주휴일(50%)
*                  lv_zrlholwk_t_min_50 = lv_zrlholwk_t_min_50 + ( lv_min2 - lv_min ).
*                ENDIF.

*              주중공휴일 +  주말 (50%) " 주중공휴일 예외 없음 xa30752 2020.08.11
                IF ( lt_attributes-weekday = '6' OR lt_attributes-weekday = '7' ) OR lt_attributes-holiday = 'X'.
                  ADD lv_min TO lv_zrlholwk_t_min_50.
                ENDIF.
              ENDIF.
              "CLEAR: lv_min.
            ENDLOOP.

            "야간근로시간
            PERFORM convert_time_to_min USING lt_zthr0112-zrlngtwk_tm
                                        CHANGING lv_min.
            ADD lv_min TO lv_zrlngtwk_t_min.

            "실근로시간
            PERFORM convert_time_to_min USING lt_zthr0112-zrlwk_tm
                                        CHANGING lv_min.
            ADD lv_min TO lv_zrlwk_t_min.

*          "1. 일별실근로시간합계(분) > 기준소정근로시간(분)
*          IF lt_zthr0112-rwkhr_s_min > lv_pwkhr_sum.
*            "2. 차이시간(분) = 일별실근로시간합계(분) - 당일실근로시간(분)
*            lv_diff_min = lt_zthr0112-rwkhr_s_min - lt_zthr0112-rwkhr_d_min.
*            "3. 2계산값 > 기준소정근로시간(분) ->>> 당일실근로시간(분) 대휴계산
*            IF lv_diff_min >= lv_pwkhr_sum.  "잔여소정근로시간이 없는 경우
**              ADD lv_min TO lv_zrlwk_t_extra.  "기준소정근로시간 소진후 실근로시간
*            ELSE.  "잔여소정근로시간이 남아 있는 경우(한번만 실행됨)
*              "4. 남은시간(분) = 기준소정근로시간 - 2계산값
*              lv_remain_min = lv_pwkhr_sum - lv_diff_min.
*              "남은시간은 실근로계산시 제외한다.
**              lv_zrlwk_t_extra = lv_zrlwk_t_extra + ( lv_min - lv_remain_min ).
*            ENDIF.
*
**            lv_pwkhr_last = lv_pwkhr_sum.  "최종소정근로시간
*          ELSE.
**            lv_pwkhr_last = lt_zthr0112-rwkhr_s_min.  "최종소정근로시간
*          ENDIF.

*************************************************************************
*            IF lt_zthr0112-zdaeh = 'X'.
*              " 소정,연장근로가 걸친 휴일근무(대휴발생)의 경우
*               " ( 휴일총근로시간(소정) - 대휴시간(연장) ) * 50% 지급 필요 " xa30752 2020.07.08
*
*              IF lt_zthr0112-zrlholwk_tm <> lt_zthr0112-zdaeh_tm.
*                 PERFORM convert_time_to_min USING lt_zthr0112-zrlholwk_tm
*                                               CHANGING lv_min6.
*
*                 PERFORM convert_time_to_min USING lt_zthr0112-zdaeh_tm
*                                               CHANGING lv_min7.
*
*                  lv_zrlholwk_t_min_50 = lv_zrlholwk_t_min_50 + ( lv_min6 - lv_min7 ).
*             ENDIF.
*           ENDIF.
*************************************************************************


           "평일근무시간 합계 계산
           CLEAR: lv_genhr, lv_diff, time1, time2, time_dif.
            time1 = lt_zthr0112-zrlwk_tm.
            time2 = lt_zthr0112-zrlholwk_tm.
           CALL FUNCTION 'ZHR_MINUS_TIME_N'
            EXPORTING
             TIME1    = time1
             TIME2    = time2
            IMPORTING
             TIME_DIF = time_dif.

             PERFORM convert_time_to_min USING time_dif
                             CHANGING  lv_genhr.

            "이 날짜 까지의 평일 근로시간 합계 계산
             lv_genhr_sum = lv_genhr_sum + lv_genhr.

          "평일근로시간 합계가 소정근로시간을 초과하지 않을때만 가산근로시간을 계산함
            CLEAR lv_genhr_diff.
            lv_genhr_diff = lv_genhr_sum - lv_genhr. "전날 합계 기준으로 생각

            IF lv_pwkhr_sum > lv_genhr_diff.
            "가산근로시간
             IF lt_zthr0112-zovradd_tm IS NOT INITIAL.
              PERFORM convert_time_to_min USING lt_zthr0112-zovradd_tm
                                          CHANGING lv_min.
              "lv_diff = lv_pwkhr_sum - lv_genhr_sum.
              "lv_diff = lv_pwkhr_sum - lv_genhr_diff.
              "IF lv_min > lv_diff.
               " lv_min = lv_min - lv_diff.
              "ENDIF.
               ADD lv_min TO lv_zovradd_t_min.
               lv_genhr_sum = lv_genhr_sum + lv_min. "가산근로시간도 평일근로시간 합계에 더해줘야 함
             ENDIF.
            ENDIF.

            "시차실비
            ADD lt_zthr0112-tdcost TO lv_tdcost_sum.
          ENDLOOP.


          lt_zthr0113-zadmit_ym = lt_zthr0132-endda(6).
          lt_zthr0113-pernr = lt_zthr0132-pernr.
          lt_zthr0113-begda = lt_zthr0132-begda.
          lt_zthr0113-endda = lt_zthr0132-endda.
          lt_zthr0113-z52wktp = lt_zthr0132-z52wktp.
          lt_zthr0113-z52prsq = lt_zthr0132-z52prsq.

          "등급, 단가
*          ls_zshr0141-datum = lt_zthr0132-endda.
          ls_zshr0141-datum = lt_zthr0132-begda."중간에 퇴직한 사람들 있어서 종료일로 하면 단가 못 가져옴
          PERFORM g_cw_get_data USING lt_zthr0132-pernr
                                      ls_zshr0141
                                CHANGING ls_zshr0143
                                         ls_return.
          lt_zthr0113-zdung = ls_zshr0143-zdung.
          lt_zthr0113-zcost = ls_zshr0143-zcost.

          "소정근로시간
          PERFORM convert_min_to_hour USING lv_pwkhr_last
                                      CHANGING lt_zthr0113-pwkhr.

***        "실근로시간의 연장근로시간
***        PERFORM convert_min_to_hour USING lv_zrlwk_t_extra  "기준소정근로시간 소진후 실근로시간
***                                    CHANGING lt_zthr0113-owkhr.

          "실 근로시간(휴게시간제외)
          PERFORM convert_min_to_hour USING lv_zrlwk_t_min
                                      CHANGING lt_zthr0113-zrlwkhr.

          "주중공휴일시간
          PERFORM convert_min_to_hour USING lv_hodhr_min
                                      CHANGING lt_zthr0113-zpubhhr.

          "인정근로시간
          PERFORM convert_min_to_hour USING lv_zprsdwk_t_min
                                      CHANGING lt_zthr0113-zprsdwkhr.

          "근로시간(근태)
          PERFORM convert_min_to_hour USING lv_awkhr_t_min2
                                      CHANGING lt_zthr0113-zadtwkhr.

          "출제위원시간
          PERFORM convert_min_to_hour USING lv_ewkhr_t_min2
                                      CHANGING lt_zthr0113-zedtwkhr.

          "가산근로시간
          PERFORM convert_min_to_hour USING lv_zovradd_t_min
                                      CHANGING lt_zthr0113-zrladdwkhr.

          "평일 총근로시간
          PERFORM convert_min_to_hour USING lv_wkhr_s_min
                                      CHANGING lt_zthr0113-zwkhrtot.

          "휴일 총근로시간
          PERFORM convert_min_to_hour USING lv_hkhr_s_min
                                      CHANGING lt_zthr0113-zhkhrtot.

          "총근로시간 계산
          lv_zrlwkhrtot_sum = lv_zrlwk_t_min +  "실근로시간
                              lv_tdcost_t_min + "추가인정된 시차 시간
                              lv_zovradd_t_min +  "가산근로시간
                              lv_zprsdwk_t_min +  "인정근로시간(A/A)
                              lv_awkhr_t_min2 +  "근태(간주)근로시간(9997/A/P)
                              lv_ewkhr_t_min2.  "출제위원시간(9998/A/P)


          ""인정근로시간을 제외한 실근로시간과 간주근로시간을 더한 시간이 208시간을 안넘으면 총근로시간을 그대로반영하고
          " 208시간을 넘으면 208시간으로 제한
            CLEAR: lv_max_sum_min2.
             "인정근로시간을 제외한 실근로시간과 간주근로시간을 더한 시간
             lv_max_sum_min2 = lv_zrlwk_t_min + lv_awkhr_t_min2.
             IF lv_max_sum_min2 <= '12480'.
               "그럼 총근로시간을 반영
                lv_zrlwkhrtot_sum =  lv_zrlwkhrtot_sum.
             ELSE.
               "특별재난근로가 하나라도 있으면 간주근로시간 포함한 모든시간 반영
               READ TABLE lt_zthr0112 WITH KEY zemcwk = 'X'.
               IF sy-subrc = 0.
                 lv_zrlwkhrtot_sum =  lv_zrlwkhrtot_sum.
               ELSE. "아니면 208 시간까지만 반영
                  lv_zrlwkhrtot_sum = '12480'.
               ENDIF.

               "특별연장근로를 통해 실근로시간이 208시간이 넘어간 경우 간주근로 시간까지 총근로시간으로 포함 (특별연장근로 시간 O + 간주근로 시간 O)
               "만일 208시간이 안넘어가면 특별연장근로가 아닌 경우 이므로 간주근로가 있어도 무조건 208시간으로 제한 (간주근로시간 제외)
*                IF  lv_zrlwk_t_min <= '12480'.
*                  lv_zrlwkhrtot_sum = '12480'.
*                ELSE.
*                 "그럼 총근로시간을 반영
*                  lv_zrlwkhrtot_sum =  lv_zrlwkhrtot_sum.
*                ENDIF.
             ENDIF.

          PERFORM convert_min_to_hour USING lv_zrlwkhrtot_sum
                                      CHANGING lt_zthr0113-zrlwkhrtot.


          "초과근로시간 계산
          lv_sign = SIGN( lv_zrlwkhrtot_sum -  "총근로시간
                          lv_pwkhr_sum -  "기준소정근로시간
                          lv_zprsdwk_t_min -  "인정근로시간(A/A)
                          "lv_awkhr_t_min2 -  "근태(간주)근로시간
                          lv_ewkhr_t_min2 ).  "출제위원시간
          IF lv_sign = 1.
            lv_zrlexwkhr_min = lv_zrlwkhrtot_sum -
                               lv_pwkhr_sum -
                               lv_zprsdwk_t_min -
                               "lv_awkhr_t_min2 -
                               lv_ewkhr_t_min2.
          ELSE.
            lv_zrlexwkhr_min = 0.
          ENDIF.
          PERFORM convert_min_to_hour USING lv_zrlexwkhr_min
                                      CHANGING lt_zthr0113-zrlexwkhr.

          "연장근로시간 계산
          lv_sign = SIGN( lv_zrlexwkhr_min - "초과근로시간
                            lv_zdaeh_t_min ). "대휴근로시간
*                          lv_zrlholwk_t_min_150_x ).


          IF lv_sign = 1.
            lv_zrlovrwkhr_sum = lv_zrlexwkhr_min - "초과근로시간
                                  lv_zdaeh_t_min . "대휴근로시간
*                                lv_zrlholwk_t_min_150_x.
          ELSE.
            lv_zrlovrwkhr_sum = 0.
          ENDIF.
          "연장근로시간
          PERFORM convert_min_to_hour USING lv_zrlovrwkhr_sum
                                      CHANGING lt_zthr0113-zrlovrwkhr.

          "야간근로시간
          PERFORM convert_min_to_hour USING lv_zrlngtwk_t_min
                                      CHANGING lt_zthr0113-zrlngtwkhr.

          "휴일근로시간
          lv_zrlholwk_t_min = lv_zrlholwk_t_min_150_x + lv_zrlholwk_t_min_50.
          PERFORM convert_min_to_hour USING lv_zrlholwk_t_min
                                      CHANGING lt_zthr0113-zrlholwkhr.

          "대휴일수
          lt_zthr0113-zdaeh_day = lv_zdaeh_t_day.

          "대휴시간
          PERFORM convert_min_to_hour USING lv_zdaeh_t_min
                                      CHANGING lt_zthr0113-zdaehhr.

          "연장근로수당(연장근로시간 * 단가)
          lt_zthr0113-zrlovramt = ( lv_zrlovrwkhr_sum / 60 ) * lt_zthr0113-zcost.

          "야간근로수당(야간시간 * 단가 * 50%)
          lt_zthr0113-zrlngtamt = ( lv_zrlngtwk_t_min / 60 ) * ( lt_zthr0113-zcost * '0.5' ).

          "휴일근로수당(휴일시간 * 단가 * 50%)
          lt_zthr0113-zrlholamt = ( lv_zrlholwk_t_min_150_x / 60 ) * ( lt_zthr0113-zcost * '1.5' ) +
                                  ( lv_zrlholwk_t_min_50 / 60 ) * ( lt_zthr0113-zcost * '0.5' ).

          "대휴수당(대휴시간 * 단가 * 50%)
          lt_zthr0113-zdaehamt = ( lv_zdaeh_t_min / 60 ) * ( lt_zthr0113-zcost * '0.5' ).

          "시차실비
          lt_zthr0113-tdcost = lv_tdcost_sum.

          "기간실비
          lt_zthr0113-zrlprdamt = lt_zthr0113-zrlovramt +  "연장근로수당
                                  lt_zthr0113-zrlngtamt +  "야간근로수당
                                  lt_zthr0113-zrlholamt +  "휴일근로수당
                                  lt_zthr0113-zdaehamt +  "대휴수당
                                  lt_zthr0113-tdcost.  "시차실비

          lt_zthr0113-waers = 'KRW'.

          APPEND lt_zthr0113.
          CLEAR lt_zthr0113.

        ENDIF.

      WHEN 'C'.  "선택근로대상자 관리(ZRPTH410) 에서 CALL
        IF sy-datum < '20220401'.

          DATA : h_sign TYPE i.

          LOOP AT lt_zthr0112 WHERE zdaeh <> 'X'.


*ㅡ20201007 31769 김지훈 주중공휴일/소정근로 걸쳐 있는 경우 계산 로직 수정 ( 주중공휴일 체크로직)ㅡㅡ
            CLEAR : h_sign.
            LOOP AT LT_ZSHR0111 WHERE datum = lt_zthr0112-datum AND
                                     ZABSDAYTY = 'H'.
              h_sign = 1.

            ENDLOOP.
*ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ


            "1. 당일까지 실근로 시간 누적(분) > 기준소정근로시간(분)
            IF  lt_zthr0112-rwkhr_s_min >= lv_pwkhr_sum . " 등호 추가 xa30752 (20200619)
              " 사번 31030 5.1(금,주중공휴일) 익일근무에 대해서 대휴 미발생 문제 발생함

              "2. 전날까지 실근로시간 누적(분) = 당일까지 실근로 시간 누적(분) - 당일 실근로시간(분)
              lv_diff_min = lt_zthr0112-rwkhr_s_min - lt_zthr0112-rwkhr_d_min.


              IF lv_diff_min >= lv_pwkhr_sum.  " 전날까지 소정근로를 다 소모한 경우
                PERFORM make_daeh_data TABLES lt_daeh
                                              lt_zthr0112
                                              lt_save
                                       USING lt_zthr0112 'Y' '0'.

              ELSE.  " 당일 근로시간을 누적했을때 소정근로를 다 소모되는 경우


                lv_remain_min = lv_pwkhr_sum - lv_diff_min. " 현재 남은 소정근로시간(당일근무시간 제외) = 총 소정근로시간 - 전날 누적실근로시간

                "남은시간은 대휴계산시 제외한다.
*          IF lv_remain_min > 0.
                lv_remain_stdaz = ( lv_remain_min DIV 60 ) + ( lv_remain_min MOD 60 ) / 60.

*ㅡ20201007 31769 김지훈 주중공휴일/소정근로 걸쳐 있는 경우 계산 로직 수정 ( 주중공휴일이면 대휴발생)ㅡㅡ
                IF h_sign = 1 AND  lt_zthr0112-rwkhr_d_min >= 270.
                  PERFORM make_daeh_data TABLES lt_daeh
                                              lt_zthr0112
                                              lt_save
                                       USING lt_zthr0112 'N'  '0'.
**ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
                else.

                  PERFORM make_daeh_data TABLES lt_daeh
                                                lt_zthr0112
                                                lt_save
                                         USING lt_zthr0112 'Y' lv_remain_stdaz.
                ENDIF.




              ENDIF.
            ELSE.  "잔여 소정근로시간 남아 있는 경우
**********************************************************************************
              " 4주 총 누적근로시간 > 기준 소정근로시간 xa30752 2020.05.28
*            IF LV_RWKHR_S_MIN > lv_pwkhr_sum.
*               IF lt_zthr0112-zyoil = '토' OR lt_zthr0112-zyoil = '일'.
*                 " 소정근로 충족 시 주말 근무 하였을 경우
*                    IF lt_zthr0112-rwkhr_d_min >= '480'.
*                      " 당일 실근로시간이 8시간 이상인 경우만 미보상 대휴 발생
*                        lv_min_t = lt_zthr0112-rwkhr_d_min.
*                        lv_stdaz_t = ( lv_min_t DIV 60 ) + ( lv_min_t MOD 60 ) / 60.
*                        IF lv_stdaz_t >= '8.0'.
*
*                            lt_zthr0112-zdaeh = 'X'.
*                            lt_zthr0112-zdaeh_day = '1'.
*
*                            MODIFY lt_zthr0112 TRANSPORTING zdaeh zdaeh_day.
*                            lt_daeh-pernr = lt_zthr0112-pernr.
*                            lt_daeh-begda = lt_zthr0112-begda.
*                            lt_daeh-endda = lt_zthr0112-endda.
*                            lt_daeh-z52wktp = '0110'.
*                            lt_daeh-z52prsq = '04'.
*
*                            lt_daeh-datum = lt_zthr0112-datum.
*                            lt_daeh-daeh_dt = lt_zthr0112-datum.
**                            lt_daeh-zrlwk_tm = lt_zthr0112-zrlwk_tm. " 실근로시간
*
*                            APPEND lt_daeh.
*.
*                            MOVE-CORRESPONDING lt_zthr0112 TO lt_save.
*
*                            APPEND lt_save.
*                            CLEAR : lt_daeh, lt_save.
*
*                        ENDIF.
*                    ENDIF.
*                ELSE. " 주중공휴일 체크
*                    PERFORM make_daeh_data TABLES lt_daeh
*                                             lt_zthr0112
*                                             lt_save
*                                      USING lt_zthr0112 'N' '0'.
*                ENDIF.
*            ELSE.
**********************************************************************************

*              lv_diff_min = lt_zthr0112-rwkhr_s_min - lt_zthr0112-rwkhr_d_min.  " 전날까지 누적 실근로시간 = 당일까지 실근로시간 누적 - 당일 실근로시간
*
*              lv_remain_min = lv_pwkhr_sum - lv_diff_min. " 현재 남은 소정근로시간(당일근무시간 제외) = 총 소정근로시간 - 전날 누적실근로시간
*
*              lv_remain_stdaz = ( lv_remain_min DIV 60 ) + ( lv_remain_min MOD 60 ) / 60.
*
*
*              IF h_sign = 1 AND  lt_zthr0112-rwkhr_d_min >= 270.
*                PERFORM make_daeh_data TABLES lt_daeh
*                                            lt_zthr0112
*                                            lt_save
*                                     USING lt_zthr0112 'N' '0'.
*              else.
              PERFORM make_daeh_data TABLES lt_daeh
                                        lt_zthr0112
                                        lt_save
                                 USING lt_zthr0112 'N'  '0'.
*              ENDIF.

*            ENDIF.
            ENDIF.

          ENDLOOP.

        ELSE. " 선택근로 소정근로계산방식 변경 xa30752

          CLEAR: lv_wkhr_s_min_t, lv_hkhr_s_min_t.

          LOOP AT lt_zthr0112 WHERE zdaeh <> 'X'.

            " 총근로시간 (평일과 휴일총근로시간 합산)
            lv_remain_min = lv_wkhr_s_min + lv_hkhr_s_min.


* 근무일자가 평일인지, 휴일인지 확인
            CLEAR: l_daynr, lv_holiday.
            CALL FUNCTION 'ZHR_GET_DAY_DATA'
              EXPORTING
                znal    = lt_zthr0112-datum
              IMPORTING
                daynr	  = l_daynr
                holiday = lv_holiday.

* 평일과 휴일 총근로시간 구분하여 계산
            PERFORM convert_time_to_min USING lt_zthr0112-zrlwk_tm
                                            CHANGING lv_min.

            PERFORM convert_time_to_min USING lt_zthr0112-ZRLHOLWK_TM
                                CHANGING lv_min8.

            "가산근로시간 더해줌
            IF lt_zthr0112-zovradd_tm IS NOT INITIAL.
              PERFORM convert_time_to_min USING lt_zthr0112-zovradd_tm
                                          CHANGING lv_min2.
              lv_min = lv_min + lv_min2.
            ENDIF.


            IF l_daynr <> '6' AND l_daynr <> '7' AND lv_holiday <> 'X'.
              ADD lv_min TO lv_wkhr_s_min_t. " 평일 누적 근로시간
*            익일 추가 .
              IF lt_zthr0112-ztomo = 'X'.
                ADD lv_min8 TO lv_hkhr_s_min_t.
              ENDIF.

            ELSE. " 휴일인 경우
              ADD lv_min TO lv_hkhr_s_min_t. " 휴일(주중공휴일 포함) 누적 근로시간
            ENDIF.


            "1. 평일총근로시간합계(분) > 기준소정근로시간(분)
            IF lv_wkhr_s_min >= lv_pwkhr_sum.

              PERFORM make_daeh_data TABLES lt_daeh
                                            lt_zthr0112
                                            lt_save
                                     USING lt_zthr0112 'Y' '0'.

              " 2. 평일+휴일 총근로시간합계(분) > 기준소정근로시간(분)
            ELSEIF lv_remain_min > lv_pwkhr_sum.

            PERFORM convert_time_to_min USING lt_zthr0112-zrlholwk_tm
                                CHANGING lv_hkhr_min.
               lv_hkhr_sum =   lv_hkhr_sum  +   lv_hkhr_min.
              " 평일 총근로시간 + 휴일 누적근로시간(당일 실근로시간 포함)  - 기준 소정근로시간
             " lv_diff_min = lv_wkhr_s_min + lv_hkhr_s_min_t  -  lv_pwkhr_sum.

              " 평일 총근로시간 + 휴일 누적근로시간  - 기준 소정근로시간
               lv_diff_min = lv_wkhr_s_min + lv_hkhr_sum -  lv_pwkhr_sum.

*              "남은시간은 대휴계산시 제외한다.
              IF lv_diff_min > 0.
                PERFORM convert_time_to_min USING lt_zthr0112-zrlwk_tm
                                                CHANGING lt_zthr0112-rwkhr_d_min.
                 IF lv_first IS INITIAL.
                   lv_diff_min = lt_zthr0112-rwkhr_d_min - lv_diff_min.
                   "lv_diff_min = lv_hkhr_min - lv_diff_min.
                 ELSE.
                   lv_diff_min = lt_zthr0112-rwkhr_d_min - lv_hkhr_min.
                 ENDIF.

                   lv_remain_stdaz = ( lv_diff_min DIV 60 ) + ( lv_diff_min MOD 60 ) / 60.
                   PERFORM make_daeh_data TABLES lt_daeh
                                         lt_zthr0112
                                         lt_save
                                  USING lt_zthr0112 'Y' lv_remain_stdaz.
                   lv_first = 1.
              ENDIF.

            ELSE.
            ENDIF.

          ENDLOOP.

        ENDIF.

      WHEN 'D'.  "선택근로 일별 근무실적 조회(ZRPTH413) 에서 CALL
        SORT lt_tmp BY datum seqnr.

          "소정근로시간부터 계산
          CALL FUNCTION 'ZHR_52TM_CW_BASE_DATA'
              EXPORTING
               i_pernr     = lt_zthr0132-pernr
               i_datum     = lt_zthr0132-begda
              IMPORTING
               e_return    = ls_return
              CHANGING
               cs_zshr0137 = ls_zshr0137.
         lv_pwkhr_net = ls_zshr0137-pwkhr_min - "기본 소정근로시간
                 ls_zshr0137-hodhr_min - "주중공휴일시간
                 ls_zshr0137-zprsdwk_t_min. "인정근로시간

        CLEAR lv_tabix.
        LOOP AT lt_tmp.
          "선택근로기간 중 몇번쨰 순서인지 저장.
          lv_tabix = sy-tabix.
          "실근로시간/간주(근태)/출제위원
          PERFORM convert_time_to_min USING lt_tmp-zrlwk_tm
                                      CHANGING lv_min.
          "가산근로시간
          PERFORM convert_time_to_min USING lt_tmp-zovradd_tm
                                      CHANGING lv_min2.

          CLEAR: lv_zrlwk_extra, lv_min5.
          "1. 일별실근로시간합계(분) > 기준소정근로시간(분)
          IF lt_tmp-rwkhr_s_min > lv_pwkhr_sum.
            "2. 차이시간(분) = 일별실근로시간합계(분) - 당일실근로시간(분)
            lv_diff_min = lt_tmp-rwkhr_s_min - lt_tmp-rwkhr_d_min.
            "3. 2계산값 > 기준소정근로시간(분)
            IF lv_diff_min >= lv_pwkhr_sum.  "잔여소정근로시간이 없는 경우
              "기준소정근로시간 소진후
              IF lt_tmp-zemcwk = 'X'.  "재난
                lv_min5 = lt_tmp-rwkhr_d_min.  "소정근로시간
                lv_zrlwk_extra = ( lv_min + lv_min2 ) - lv_min5.  "연장근로시간

                IF lt_tmp-zovradd_tm IS NOT INITIAL.
*               " 소정근로시간 소진 후 특근 등 가산근로시간이 있을 경우 소정근로시간과 연장근로시간 분리할 필요가 없음  xa30752 2020.05.26
                  lv_min5 = 0.  "소정근로시간
                  lv_zrlwk_extra = lv_min + lv_min2.  "실근로시간 + 가산근로시간
                ENDIF.
                IF lt_tmp-ztoich = 'X'. " 퇴출일 경우 소정근로시간 소진 이후 근로시간을 소정근로가 아닌 연장근로사간으로 xa30752 2020.05.26
                  lv_min5 = 0.
                  lv_zrlwk_extra = lv_min.
                ENDIF.

              ELSE.
                lv_min5 = 0.  "소정근로시간
                lv_zrlwk_extra = lt_tmp-rwkhr_d_min.  "연장근로시간
              ENDIF.

            ELSE.  "잔여소정근로시간이 남아 있는 경우
              "4. 남은시간(분) = 기준소정근로시간 - 2계산값
              lv_remain_min = lv_pwkhr_sum - lv_diff_min.
              lv_zrlwk_extra = lt_tmp-rwkhr_d_min - lv_remain_min.  "연장근로시간
              lv_min5 = lv_remain_min.  "소정근로시간
            ENDIF.
          ELSE.  "소진이 아직 안된 경우
            lv_min5 = lt_tmp-rwkhr_d_min.  "소정근로시간
            IF lt_tmp-zemcwk = 'X'.  "재난
              lv_zrlwk_extra = ( lv_min + lv_min2 ) - lv_min5.  "연장근로시간
              IF lv_zrlwk_extra < 0. " 마이너스 인식 xa30752 2020.05.26
                lv_zrlwk_extra = 0.
              ENDIF.
            ELSE.
              lv_zrlwk_extra = 0.  "연장근로시간
            ENDIF.
          ENDIF.

          CLEAR: l_daynr, lv_holiday.
          CALL FUNCTION 'ZHR_GET_DAY_DATA'
            EXPORTING
              znal    = lt_tmp-datum
            IMPORTING
              daynr	  = l_daynr
              holiday = lv_holiday.


          "가산근로시간
          PERFORM convert_time_to_min USING lt_tmp-zovradd_tm
                                     CHANGING lv_zovradd_t_min.

          "소정근로시간
          PERFORM convert_min_to_time USING lv_min5
                                      CHANGING lt_tmp-e_time.

          "연장근로시간,
          PERFORM convert_min_to_time USING lv_zrlwk_extra
                                      CHANGING lt_tmp-f_time.


          "누적근로시간
          IF l_daynr <> '6' AND l_daynr <> '7' AND lv_holiday <> 'X'. "평일인 경우에만
            "간주근로시간이 있으면 간주근로시간 부터 평일에 반영, 간주근로 당일 단가도 넣어줌
             READ TABLE lt_zshr0111 WITH KEY datum = lt_tmp-datum
                              awart = '9997'
                              zstat = 'A'
                             zabsdayty = 'P'.
            IF sy-subrc = 0.
              lv_min = lt_tmp-rwkhr_d_min.
             "연봉계약직인 경우 별도 단가  다시 적용
              SELECT SINGLE * FROM zthrbs05 INTO CORRESPONDING FIELDS OF wa_zthrbs05
                WHERE pernr = lt_tmp-pernr AND begda <= lt_tmp-datum AND endda >= lt_tmp-datum.
                IF sy-subrc = 0.
                 SELECT SINGLE * FROM zthrcost INTO CORRESPONDING FIELDS OF wa_zthrcost
                 WHERE z_ctype = '1' AND zdung = wa_zthrbs05-zdung
                   "Start-Modify / 시간외 단가 변동으로 프로그램 개선 / xa32762
*                   AND endda = '99991231'.
                   AND begda <= lt_tmp-datum
                   AND endda => lt_tmp-datum.
                   "End-Modify //

                  lt_tmp-zdung = wa_zthrbs05-zdung.
                  lt_tmp-zcost = wa_zthrcost-zcost / 100. "간주근로 단가
                ELSEIF wa_zthrbs05-endda IS NOT INITIAL AND wa_zthrbs05-endda < lt_tmp-datum. "계약 종료 이후 날들
                  lt_tmp-zdung = ''.
                  lt_tmp-zcost = ''.
                ELSE.
                 "정직원인 경우 정직원 단가 적용
                  SELECT SINGLE * FROM zthrcost INTO CORRESPONDING FIELDS OF wa_zthrcost
                  WHERE z_ctype = '1' AND zdung = ''
                    "Start-modify
*                    AND endda = '99991231'.
                     AND begda <= lt_tmp-datum
                   AND endda => lt_tmp-datum.
                    "End-Modify
                   lt_tmp-zcost = wa_zthrcost-zcost / 100. "간주근로 단가
                ENDIF.
            ELSE.
            "평일 시차실비 받는 사람들 중 소정근로시간 초과 안하면서 7시간, 7.5시간 근무는 8시간으로 계산,
              lv_next_dif = lv_max_extra1 - lv_min.
            IF lt_tmp-tdcost IS NOT INITIAL AND ( lv_min = 420 OR lv_min = 450 ) AND (  lv_next_dif >= 0 ).
                lv_min = 480.
              ENDIF.
            ENDIF.
          ENDIF.
          lv_cwkhr_min = lv_cwkhr_min + lv_min.

          "누적근로시간은 208시간을 넘어갈수 없음
*          IF lv_cwkhr_min > '12480'.
*            lv_cwkhr_min = '12480'.
*          ENDIF.
          PERFORM convert_min_to_hour2 USING lv_cwkhr_min
                                       CHANGING lt_tmp-cwkhr.


          "휴일일근로시간
         PERFORM convert_time_to_min USING lt_tmp-zrlholwk_tm
                                        CHANGING lv_zrlholwk_min.

          "최대근로시간 :
*           lv_max_extra  =  lv_pwkhr_sum -  lv_cwkhr_min.
*          IF lv_max_extra < 0.
*            lv_exceed = lv_max_extra * -1.
*            "최초로 소정근로시간을 넘어가는 날에는 차이 시간 그대로 반영
*            IF lv_first EQ 1.
*              PERFORM convert_min_to_time USING  lv_exceed
*                                         CHANGING lt_tmp-g_time.
*            ELSE.
*              PERFORM convert_min_to_time USING lv_min
*                                         CHANGING lt_tmp-g_time.
*            ENDIF.
*            CLEAR lv_first.
*          ELSE.
*            lv_first = 1.
*          ENDIF.

          "평일근로시간
          IF l_daynr <> '6' AND l_daynr <> '7' AND lv_holiday <> 'X'. "평일인 경우에만
           "간주근로시간이 있으면 간주근로시간 부터 평일에 반영
           READ TABLE lt_zshr0111 WITH KEY datum = lt_tmp-datum
                              awart = '9997'
                              zstat = 'A'
                             zabsdayty = 'P'.
           IF sy-subrc = 0.
              lv_genhr_min = lt_tmp-rwkhr_d_min.
           ELSE.
            "익일이 휴일이면서 근무시간이 있는 (평휴) 경우 평일근로시간 휴일근무시간으로 분리
            CLEAR: lv_zrlholwk_min, lv_datum, lv_next_holiday.
            CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
              EXPORTING
                DATE            = lt_tmp-datum
                DAYS            = '01'
                MONTHS          = '00'
               SIGNUM          = '+'
                YEARS           = '00'
             IMPORTING
               CALC_DATE       = lv_datum.

           CALL FUNCTION 'ZHR_GET_DAY_DATA'
            EXPORTING
              znal    = lv_datum
            IMPORTING
              holiday = lv_next_holiday.

            IF lt_tmp-ztomo = 'X' AND lv_next_holiday = 'X'.
              PERFORM convert_time_to_min USING lt_tmp-zrlholwk_tm
                             CHANGING lv_zrlholwk_min.
              lv_genhr_min = lv_min +  lv_zovradd_t_min - lv_zrlholwk_min.
            ELSE.
              lv_genhr_min = lv_min +  lv_zovradd_t_min.
            ENDIF.
            "평일 시차실비 받는 사람들 중 소정근로시간 초과 안하면서 7시간, 7.5시간 근무는 8시간으로 계산
            lv_next_dif = lv_max_extra1 - lv_min.
            IF lt_tmp-tdcost IS NOT INITIAL AND ( lv_min = 420 OR lv_min = 450 ) AND ( lv_max_extra1 IS INITIAL ).
              lv_genhr_min = 480.
            ENDIF.

            IF lt_tmp-tdcost IS NOT INITIAL AND ( lv_min = 420 OR lv_min = 450 ) AND ( lv_next_dif >= 0 ).
              lv_genhr_min = 480.
            ENDIF.
           ENDIF.
          ELSE. "휴일인 경우
            "익일이 평일이면서 근무시간이 있는 (휴평) 경우 평일근로시간 휴일근무시간으로 분리
            CLEAR: lv_datum, lv_next_day, time1, time2, time_dif.
            CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
              EXPORTING
                DATE            = lt_tmp-datum
                DAYS            = '01'
                MONTHS          = '00'
               SIGNUM          = '+'
                YEARS           = '00'
             IMPORTING
               CALC_DATE       = lv_datum.

           CALL FUNCTION 'ZHR_GET_DAY_DATA'
            EXPORTING
              znal    = lv_datum
            IMPORTING
              holiday = lv_next_day.

            time1 = lt_tmp-zrlwk_tm.
            time2 = lt_tmp-zrlholwk_tm.
           CALL FUNCTION 'ZHR_MINUS_TIME_N'
            EXPORTING
             TIME1    = time1
             TIME2    = time2
            IMPORTING
             TIME_DIF = time_dif.

            IF lt_tmp-ztomo = 'X' AND lv_next_day IS INITIAL.
              PERFORM convert_time_to_min USING time_dif
                             CHANGING lv_genhr_min.
            ELSE.
              lv_genhr_min = 0.
            ENDIF.
          ENDIF.

          "이 날짜 까지의 평일 근로시간 합계 계산
          lv_genhr_until = lv_genhr_until + lv_genhr_min.
          PERFORM convert_min_to_hour2 USING lv_genhr_min
                                       CHANGING lt_tmp-genhr.

          "최대근로시간
         "1)연장가능시간: 소정근로시간에서 이 날짜 까지의 평일근로시간 합계를 제외한 시간
            lv_max_extra1 = lv_pwkhr_net  -  lv_genhr_until.

          "2)휴일대체가용시간: 소정근로시간에서 평일근로시간 총 합계를 제외한 시간
            lv_max_extra2  = lv_pwkhr_net  -  lv_wkhr_s_min.


          IF  lv_max_extra1 <= 0. "연장가능시간이 도중에 이미 소정근로시간을 초과한 경우
            "최초로 초과하는 날에는 초과분 만큼만 반영해야 하기에 lv_first라는 변수를 도입함
            "lv_tabix : 선택근로 기간중 첫날에도 초과 할 수 있으므로 따로 처리하기 위한 변수
            IF lv_first1 = 1 OR lv_tabix = 1.
              lv_exceed1 = lv_max_extra1 * -1.
              lv_exceed1 = lv_exceed1 +  lv_zrlholwk_min. "휴일 시간도 포함

               PERFORM convert_min_to_time USING  lv_exceed1
                               CHANGING lt_tmp-g_time.
              CLEAR lv_first1.
             ELSE. " 소진 이후 다음날 부터는 휴일이든 평일이든 그대로 반영
               PERFORM convert_min_to_time USING  lv_min
                               CHANGING lt_tmp-g_time.
             ENDIF.
          ELSE.
            lv_first1 = 1.
          ENDIF.

          IF lv_max_extra2  > 0. "휴일대체가용시간이 있으면 휴일근로시간을 소진 시켜준다
            IF lv_exceed2  > 0.
              lv_exceed2 = lv_exceed2 - lv_zrlholwk_min.
            ELSE.
              IF lv_first2 = 1. "소진 이후 다음날 부터는 그대로 반영
                lv_exceed2 = lv_zrlholwk_min * -1.
              ELSE.
                lv_exceed2 = lv_max_extra2 - lv_zrlholwk_min.
              ENDIF.
            ENDIF.

            IF lv_exceed2 > 0." 소진 할 가용시간이 더 있으면 0분 반영
              lv_min = 0.
              PERFORM convert_min_to_time USING  lv_min
                                     CHANGING lt_tmp-g_time.
            ELSE.  "소진 할 가용시간이 더 이상 없으면 뺀거 그대로 반영
              lv_first2 = 1.
              lv_exceed2 = lv_exceed2 * -1.
              PERFORM convert_min_to_time USING lv_exceed2
                                     CHANGING lt_tmp-g_time.
              lv_exceed2 = lv_exceed2 * -1.
            ENDIF.

          ELSE. "휴일대체가용시간이 없으면 휴일근로시간을 그대로 반영
             IF lv_max_extra1 > 0. "연장가능시간이 남아 있는 경우에만
              PERFORM convert_min_to_time USING lv_zrlholwk_min
                 CHANGING lt_tmp-g_time.
             ENDIF.
          ENDIF.


          MOVE-CORRESPONDING lt_tmp TO lt_daily.
          APPEND lt_daily.
        ENDLOOP.

        SORT lt_daily BY endda pernr datum seqnr.
        CLEAR lt_tmp[].
    ENDCASE.

  ENDLOOP.

ENDFUNCTION.
