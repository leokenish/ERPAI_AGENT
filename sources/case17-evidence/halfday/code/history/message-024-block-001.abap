*---------------------------------------------------------------------*
* 1. LZHR008_2F03
* CHECK_ABSENCE_DATA는 그대로 두고 아래 FORM을 추가한다.
*
* 목적: 해당일에 안내 대상 반일 근태가 있는지 확인한다.
* 기준: 현재 근태 검사와 동일한 상태 조건을 사용한 검토안이다.
*       신청 중인 근태도 포함되므로 운영 적용 전 범위를 확인한다.
*---------------------------------------------------------------------*
FORM check_notice_halfday USING    p_pernr TYPE pernr_d
                                  p_datum TYPE datum
                         CHANGING p_halfday TYPE c.

  DATA: lt_absence TYPE TABLE OF zthr0080,
        ls_absence TYPE zthr0080,
        ls_changed TYPE zthr0080,
        lv_daynr   LIKE hrvsched-daynr,
        lv_holiday TYPE c.

  CLEAR p_halfday.

  IF p_pernr IS INITIAL OR p_datum IS INITIAL.
    RETURN.
  ENDIF.

* 평일만 안내한다.
  CALL FUNCTION 'ZHR_GET_DAY_DATA'
    EXPORTING
      znal    = p_datum
    IMPORTING
      daynr   = lv_daynr
      holiday = lv_holiday.

  IF lv_daynr IS INITIAL.
    RETURN.
  ENDIF.

  IF lv_daynr = '6' OR lv_daynr = '7'
     OR lv_holiday = 'X'.
    RETURN.
  ENDIF.

* 근태 종류와 세부유형을 함께 확인한다.
* 10 / 13,15 : 연차 오전·오후 반차
* 30 / 43,44 : 자녀돌봄 오전·오후 반일
* 40 / 28,29 : 일반검진 오전·오후 반일
  SELECT *
    INTO TABLE lt_absence
    FROM zthr0080
   WHERE pernr   = p_pernr
     AND begda  <= p_datum
     AND endda  >= p_datum
     AND state  IN ('0', 'D')
     AND zaccept <> 'N'
     AND zuhyung = space
     AND ( ( gunart = '10'
             AND ( guntype = '13' OR guntype = '15' ) )
        OR ( gunart = '30'
             AND ( guntype = '43' OR guntype = '44' ) )
        OR ( gunart = '40'
             AND ( guntype = '28' OR guntype = '29' ) ) ).

  LOOP AT lt_absence INTO ls_absence.

* 승인된 변경·삭제 이력이 있는 원건은 안내 대상에서 제외한다.
    CLEAR ls_changed.

    SELECT SINGLE *
      INTO ls_changed
      FROM zthr0080
     WHERE pernr    = ls_absence-pernr
       AND state    IN ('D', '2')
       AND zaccept  = 'Y'
       AND zserial2 = ls_absence-zserial.

    IF sy-subrc <> 0.
      p_halfday = 'X'.
      EXIT.
    ENDIF.

  ENDLOOP.

ENDFORM.
