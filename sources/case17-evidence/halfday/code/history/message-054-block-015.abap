FORM check_absence_data  USING    p_pernr
                                  p_znal
                                  p_ztomo
                                  p_zgubun
                         CHANGING c_code
                                  c_text.

* 근태(휴가) 승인 및 신청여부.
  DATA : ls_zthrbs08   TYPE zthrbs08,
         ls_zthr0080   TYPE zthr0080,
         ls_zthr0080_c TYPE zthr0080,
         lt_zthr0080   TYPE TABLE OF zthr0080,
         lt_zcal       TYPE TABLE OF zcal WITH HEADER LINE,
         ls_zcal       LIKE LINE OF lt_zcal.

  DATA : lv_begda   TYPE datum,
         lv_endda   TYPE datum,
         lv_flag(1) TYPE c.
  DATA: rol_count TYPE i.

  DATA : l_daynr  LIKE  hrvsched-daynr,
             lv_holiday.

  lv_begda = p_znal.
  lv_endda = p_znal.

* 익일건은 제외함(예산팀 박세화 요청,2007.06.08)
*  IF P_ZTOMO IS INITIAL.
*    LV_ENDDA = P_ZNAL.
*  ELSE.
*    LV_ENDDA = P_ZNAL + 1.
*  ENDIF.

  IF p_zgubun = '1' OR
     p_zgubun = 'A' OR
     p_zgubun = 'B'.
    " 통상시차->대휴인경우 입력가능.   "대휴도 근태에서 막아달라는 요청(2013.1.14- 안지연 선배 요청에 의해 수정) XA30750
* 통상/시차: 연차 반차, 자녀돌봄 반일, 일반검진 반일은 입력 허용.
* 근태종류와 세부유형을 함께 비교하여 종일 근태가 허용되지 않도록 함.
    SELECT * INTO TABLE lt_zthr0080
      FROM zthr0080
     WHERE pernr EQ p_pernr
       AND begda       <= lv_endda
       AND endda       >= lv_begda
       AND state       IN ('0','D')     " 0-신청, D-기/유형변경 신청
       AND zaccept     NE 'N'         " 승인여부
       AND NOT ( ( gunart = '10'
                   AND ( guntype = '13' OR guntype = '15' ) )
              OR ( gunart = '30'
                   AND ( guntype = '43' OR guntype = '44' ) )
              OR ( gunart = '40'
                   AND ( guntype = '28' OR guntype = '29' ) ) )
       AND zuhyung     EQ ''.          " 자료유형

  ELSE.

    CLEAR: rol_count.
    SELECT COUNT(*) FROM agr_users INTO rol_count WHERE agr_name = 'MRHR300_1' AND uname = sy-uname AND from_dat <= sy-datum AND to_dat >= sy-datum.

    IF rol_count = 0.      " 관리자의 경우 근태있을 때 신청 가능 xa30752 2019.07.05
      SELECT * INTO TABLE lt_zthr0080
        FROM zthr0080
       WHERE pernr   EQ p_pernr
         AND begda   <= lv_endda
         AND endda   >= lv_begda
         AND state   IN ('0','D')     " 0-신청, D-기/유형변경 신청
         AND zaccept NE 'N'         " 승인여부
         AND zuhyung = ''.          " 자료유형

    ENDIF.
  ENDIF.

* 변경 및 삭제 원건 제거.
  LOOP AT lt_zthr0080 INTO ls_zthr0080.
    SELECT SINGLE * INTO ls_zthr0080_c
      FROM zthr0080
     WHERE pernr EQ ls_zthr0080-pernr
       AND state    IN ('D', '2')
       AND zaccept  EQ 'Y'
       AND zserial2 EQ ls_zthr0080-zserial.
    IF sy-subrc = 0.
      DELETE TABLE lt_zthr0080 FROM ls_zthr0080. CLEAR ls_zthr0080.
    ENDIF.
  ENDLOOP.


  IF NOT lt_zthr0080[] IS INITIAL.
    LOOP AT lt_zthr0080 INTO ls_zthr0080.
      CLEAR   : ls_zcal, lt_zcal.

      SELECT * INTO TABLE lt_zcal
        FROM zcal
       WHERE zdate >= ls_zthr0080-begda
         AND zdate <= ls_zthr0080-endda.

      SORT lt_zcal BY zdate.

      CLEAR: l_daynr, lv_holiday. " xa30752 2020.11.23 추가

*      LOOP AT lt_zcal.

      CALL FUNCTION 'ZHR_GET_DAY_DATA'
        EXPORTING
          znal    = lv_begda
        IMPORTING
          daynr	  = l_daynr
          holiday = lv_holiday.

      IF  l_daynr <> '6' AND l_daynr <> '7' AND lv_holiday <> 'X'. " 평일일 경우에만 타도록

        LOOP AT lt_zcal INTO ls_zcal WHERE zdate BETWEEN lv_begda AND lv_endda.
          SELECT SINGLE * INTO ls_zthrbs08
            FROM zthrbs08       " 입력가능여부
           WHERE pernr  EQ ls_zthr0080-pernr
             AND begda  <= ls_zcal-zdate
             AND endda  >= ls_zcal-zdate
             AND zbegda <= sy-datum
             AND zendda >= sy-datum
             AND zdele  = ''.

          IF sy-subrc NE 0.
            lv_flag = 'X'.
            EXIT.
          ENDIF.

        ENDLOOP.

      ENDIF.

    ENDLOOP.
*    ENDLOOP.

    IF lv_flag = 'X'.
      c_code = 'E63'.
      c_text = text-e63.
      RETURN.
    ENDIF.
  ENDIF.
ENDFORM.                    " CHECK_ABSENCE_DATA
