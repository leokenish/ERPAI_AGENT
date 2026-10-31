FORM check_absence_data USING    p_pernr
                                 p_znal
                                 p_ztomo
                                 p_zgubun
                        CHANGING c_code
                                 c_text.

* 근태(휴가) 승인 및 신청여부
  DATA: ls_zthrbs08   TYPE zthrbs08,
        ls_zthr0080   TYPE zthr0080,
        ls_zthr0080_c TYPE zthr0080,
        lt_zthr0080   TYPE TABLE OF zthr0080,
        lt_zcal       TYPE TABLE OF zcal WITH HEADER LINE,
        ls_zcal       LIKE LINE OF lt_zcal.

  DATA: lv_begda   TYPE datum,
        lv_endda   TYPE datum,
        lv_flag(1) TYPE c.

  DATA: rol_count TYPE i.

  DATA: l_daynr LIKE hrvsched-daynr,
        lv_holiday.

* 추가: 반일 근태 안내 여부
  DATA: lv_halfday_notice TYPE c.

  CLEAR: lv_flag, lv_halfday_notice.

  lv_begda = p_znal.
  lv_endda = p_znal.

* 기존과 동일하게 입력 당일의 근태만 검사한다.
  IF p_zgubun = '1' OR
     p_zgubun = 'A' OR
     p_zgubun = 'B'.

* 변경: 반일 근태도 함께 조회한다.
* 기존 SELECT의 반일 제외 조건을 제거한다.
    SELECT *
      INTO TABLE lt_zthr0080
      FROM zthr0080
     WHERE pernr   EQ p_pernr
       AND begda   <= lv_endda
       AND endda   >= lv_begda
       AND state   IN ('0', 'D')
       AND zaccept NE 'N'
       AND zuhyung EQ ''.

  ELSE.

* 기존 관리자 예외 처리는 유지한다.
    CLEAR rol_count.

    SELECT COUNT(*)
      FROM agr_users
      INTO rol_count
     WHERE agr_name = 'MRHR300_1'
       AND uname    = sy-uname
       AND from_dat <= sy-datum
       AND to_dat   >= sy-datum.

    IF rol_count = 0.

      SELECT *
        INTO TABLE lt_zthr0080
        FROM zthr0080
       WHERE pernr   EQ p_pernr
         AND begda   <= lv_endda
         AND endda   >= lv_begda
         AND state   IN ('0', 'D')
         AND zaccept NE 'N'
         AND zuhyung EQ ''.

    ENDIF.
  ENDIF.

* 기존 변경·삭제 원건 제거 처리는 유지한다.
  LOOP AT lt_zthr0080 INTO ls_zthr0080.

    SELECT SINGLE *
      INTO ls_zthr0080_c
      FROM zthr0080
     WHERE pernr    EQ ls_zthr0080-pernr
       AND state    IN ('D', '2')
       AND zaccept  EQ 'Y'
       AND zserial2 EQ ls_zthr0080-zserial.

    IF sy-subrc = 0.
      DELETE TABLE lt_zthr0080 FROM ls_zthr0080.
      CLEAR ls_zthr0080.
    ENDIF.

  ENDLOOP.

  IF NOT lt_zthr0080[] IS INITIAL.

    LOOP AT lt_zthr0080 INTO ls_zthr0080.

      CLEAR: ls_zcal, lt_zcal.

      SELECT *
        INTO TABLE lt_zcal
        FROM zcal
       WHERE zdate >= ls_zthr0080-begda
         AND zdate <= ls_zthr0080-endda.

      SORT lt_zcal BY zdate.

      CLEAR: l_daynr, lv_holiday.

      CALL FUNCTION 'ZHR_GET_DAY_DATA'
        EXPORTING
          znal    = lv_begda
        IMPORTING
          daynr   = l_daynr
          holiday = lv_holiday.

      IF l_daynr <> '6'
         AND l_daynr <> '7'
         AND lv_holiday <> 'X'.

* 추가: 기존에 입력을 허용하던 반일 근태를 구분한다.
        IF p_zgubun = '1' OR
           p_zgubun = 'A' OR
           p_zgubun = 'B'.

          IF ( ls_zthr0080-gunart = '10'
               AND ( ls_zthr0080-guntype = '13'
                  OR ls_zthr0080-guntype = '15' ) )
          OR ( ls_zthr0080-gunart = '30'
               AND ( ls_zthr0080-guntype = '43'
                  OR ls_zthr0080-guntype = '44' ) )
          OR ( ls_zthr0080-gunart = '40'
               AND ( ls_zthr0080-guntype = '28'
                  OR ls_zthr0080-guntype = '29' ) ).

* 안내는 통상근무에만 적용한다.
            IF p_zgubun = 'A'.
              lv_halfday_notice = 'X'.
            ENDIF.

* 허용 반일은 차단 검사에서 제외한다.
* 다른 차단 근태가 있을 수 있으므로 다음 근태를 계속 검사한다.
            CONTINUE.

          ENDIF.
        ENDIF.

* 그 외 근태는 기존 입력 예외·차단 검사를 수행한다.
        LOOP AT lt_zcal INTO ls_zcal
          WHERE zdate BETWEEN lv_begda AND lv_endda.

          SELECT SINGLE *
            INTO ls_zthrbs08
            FROM zthrbs08
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

* 기존 차단 오류를 반일 안내보다 우선한다.
    IF lv_flag = 'X'.
      c_code = 'E63'.
      c_text = text-e63.
      RETURN.
    ENDIF.

  ENDIF.

* 추가: 차단 오류가 없고 기존 반환 코드도 없을 때 안내한다.
  IF lv_halfday_notice = 'X'
     AND c_code IS INITIAL.

    c_code = 'I95'.
    c_text = text-e95.

  ENDIF.

ENDFORM.                    " CHECK_ABSENCE_DATA
