*---------------------------------------------------------------------*
* 3. ZHR_52TM_MOBILE_OVERTIME_CHECK
* 함수 상단 DATA 선언부에 추가한다.
*---------------------------------------------------------------------*
  DATA: lv_halfday_notice TYPE char200,
        lv_notice_all     TYPE string,
        lv_message_length TYPE i,
        lv_notice_length  TYPE i.

*---------------------------------------------------------------------*
* 기존 처리는 유지한다.
* 기존 "Return Message" 처리 다음, ENDFUNCTION 직전에 추가한다.
*
* 기존 PC·모바일 콜백은 정상 응답의 MESSAGE도 alert로 표시한다.
* TYPE W는 일부 경로에서 중단 처리하므로 사용하지 않는다.
*---------------------------------------------------------------------*

* 오류·경고 처리가 남아 있으면 기존 처리를 우선한다.
  IF e_return-type = 'S'
     AND g_code+0(1) <> 'E'
     AND g_code+0(1) <> 'W'.

* 신규·날짜 초기화 또는 최초 화면 진입에서만 안내한다.
* 시간·휴게 수정 때마다 반복해서 표시하지 않도록 제한한다.
*
* 주의: 날짜별 정확히 1회 표시와 저장 직전 재안내까지 보장하려면
*       BSP의 안내 상태 관리·콜백 수정이 추가로 필요하다.
    IF i_zgubun IS INITIAL OR i_isfst = 'X'.

      CLEAR: lv_halfday_notice, lv_notice_all.

      PERFORM get_halfday_start_notice
        USING    i_pernr
                 i_datum
                 cs_zshr0131-zgubun
        CHANGING lv_halfday_notice.

      IF lv_halfday_notice IS NOT INITIAL.

* 기존 I AM 안내나 다른 정보 메시지를 보존한다.
        IF e_return-message IS INITIAL.
          lv_notice_all = lv_halfday_notice.
        ELSE.
          CONCATENATE
            e_return-message
            cl_abap_char_utilities=>newline
            lv_halfday_notice
            INTO lv_notice_all.
        ENDIF.

* 응답 필드 길이를 넘겨 기존 메시지가 잘리는 것을 방지한다.
        DESCRIBE FIELD e_return-message
          LENGTH lv_message_length
          IN CHARACTER MODE.

        lv_notice_length = STRLEN( lv_notice_all ).

        IF lv_notice_length <= lv_message_length.
          e_return-message = lv_notice_all.
        ENDIF.

* 길이 초과 시에는 기존 메시지를 유지한다.
* 두 안내를 항상 모두 표시하려면 별도 응답 필드와 BSP 수정이 필요하다.

      ENDIF.
    ENDIF.
  ENDIF.
