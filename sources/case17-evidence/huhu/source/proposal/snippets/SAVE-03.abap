* 날짜 묶음 수와 실제 대휴 발생일 수를 구분한다.
* 기존 상세 구조를 사용하므로 DDIC나 함수 인수 추가가 없다.
  DATA: lt_zdaeh_day TYPE TABLE OF zshr0121,
        ls_zdaeh_day TYPE zshr0121,
        lv_daeh_days TYPE i.

  REFRESH lt_zdaeh_day.
  CLEAR: ls_zdaeh_day, lv_daeh_days.

* 토8 / 일6 / 토2를 토8 / 토2 / 일6 순서로 정렬한다.
  SORT lt_zdaeh BY datum zbegtm zendtm.

  LOOP AT lt_zdaeh INTO ls_zdaeh.
    IF ls_zdaeh_day-datum IS INITIAL.
* 첫 구간의 시작시각과 기존 휴게정보를 보관한다.
      MOVE ls_zdaeh TO ls_zdaeh_day.

    ELSEIF ls_zdaeh_day-datum EQ ls_zdaeh-datum.
* 같은 날짜의 종료시각은 가장 늦은 시각을 사용한다.
      IF ls_zdaeh-zendtm GT ls_zdaeh_day-zendtm.
        ls_zdaeh_day-zendtm = ls_zdaeh-zendtm.
      ENDIF.

* 금액만 더한다. 날짜나 다른 숫자 필드를 함께 더하지 않는다.
      ADD ls_zdaeh-zjorgehamt TO ls_zdaeh_day-zjorgehamt.
      IF ls_zdaeh-zdaeh EQ 'X'.
        ls_zdaeh_day-zdaeh = 'X'.
      ENDIF.

    ELSE.
* 날짜가 바뀌면 앞 날짜를 확정하고 다음 날짜를 시작한다.
      APPEND ls_zdaeh_day TO lt_zdaeh_day.
      MOVE ls_zdaeh TO ls_zdaeh_day.
    ENDIF.
  ENDLOOP.

* 마지막 날짜는 반복문이 끝난 뒤 한 번 추가한다.
  IF ls_zdaeh_day-datum IS NOT INITIAL.
    APPEND ls_zdaeh_day TO lt_zdaeh_day.
  ENDIF.

  lt_zdaeh[] = lt_zdaeh_day[].

* 이틀 근무라도 실제 대휴는 한 개일 수 있다.
  LOOP AT lt_zdaeh INTO ls_zdaeh WHERE zdaeh EQ 'X'.
    ADD 1 TO lv_daeh_days.
  ENDLOOP.

* 기존 1일 / 2일 저장 분기에는 날짜 묶음 수를 사용한다.
  lv_zdaeh_c = LINES( lt_zdaeh ).
