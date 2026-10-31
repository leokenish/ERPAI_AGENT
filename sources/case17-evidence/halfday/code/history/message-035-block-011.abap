* 통상근무 반일 근태일의 시작시간 입력 안내
* 입력 중 검사에서만 안내하고, 기존 오류·안내를 우선한다.
  IF i_action IS INITIAL
     AND ls_zthrbs01-zgubun = 'A'
     AND e_code IS INITIAL.

* 토요일·일요일·공휴일은 제외한다.
    CLEAR: lv_notice_daynr, lv_notice_holiday.

    CALL FUNCTION 'ZHR_GET_DAY_DATA'
      EXPORTING
        znal    = ls_zthrbs01-znal
      IMPORTING
        daynr   = lv_notice_daynr
        holiday = lv_notice_holiday.

    IF lv_notice_daynr >= '1'
       AND lv_notice_daynr <= '5'
       AND lv_notice_holiday <> 'X'.

* 기존 근태 검사의 상태 조건을 유지한다.
* 연차 반차·자녀돌봄 반일·일반검진 반일을 조회한다.
      SELECT *
        INTO TABLE lt_halfday
        FROM zthr0080
       WHERE pernr   = ls_zthrbs01-pernr
         AND begda  <= ls_zthrbs01-znal
         AND endda  >= ls_zthrbs01-znal
         AND state  IN ('0', 'D')
         AND zaccept <> 'N'
         AND zuhyung = space
         AND ( ( gunart = '10'
                 AND ( guntype = '13' OR guntype = '15' ) )
            OR ( gunart = '30'
                 AND ( guntype = '43' OR guntype = '44' ) )
            OR ( gunart = '40'
                 AND ( guntype = '28' OR guntype = '29' ) ) ).

      LOOP AT lt_halfday INTO ls_halfday.

* 승인된 변경·삭제 이력이 있는 원건은 제외한다.
        CLEAR ls_changed.

        SELECT SINGLE *
          INTO ls_changed
          FROM zthr0080
         WHERE pernr    = ls_halfday-pernr
           AND state    IN ('D', '2')
           AND zaccept  = 'Y'
           AND zserial2 = ls_halfday-zserial.

        IF sy-subrc <> 0.
* 기존 정보성 메시지 전달 방식을 사용한다.
* 입력시간과 계산 결과는 변경하지 않는다.
          e_code = 'I95'.
          e_text = text-e95.
          EXIT.
        ENDIF.

      ENDLOOP.
    ENDIF.
  ENDIF.
