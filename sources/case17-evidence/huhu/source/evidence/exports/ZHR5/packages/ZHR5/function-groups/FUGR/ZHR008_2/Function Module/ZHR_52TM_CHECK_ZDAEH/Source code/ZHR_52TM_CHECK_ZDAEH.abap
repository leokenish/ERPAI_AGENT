FUNCTION zhr_52tm_check_zdaeh.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(I_MODE) TYPE  CHAR01
*"     VALUE(IS_ZTHRBS01) TYPE  ZTHRBS01
*"  EXPORTING
*"     VALUE(E_ZDAEH) TYPE  ZDAEH
*"     VALUE(E_ZDHDAT01) TYPE  DATUM
*"     VALUE(E_ZDHDAT02) TYPE  DATUM
*"     VALUE(E_ZDHCNT) TYPE  I
*"     VALUE(E_ENFO) TYPE  CHAR01
*"  TABLES
*"      ET_DATA TYPE  ZTSHR0115 OPTIONAL
*"----------------------------------------------------------------------
*...// 입력받은 근무일, 근무시작시간, 근무 종료시간을 기준으로 대휴 발생여부를 Check.


  DATA : lv_znal       TYPE datum,
         lv_ex_days    TYPE i,
         lv_ex_time    TYPE t,
         lv_zbegt      TYPE t,
         lv_zendt      TYPE t,
         lv_zdaeh_time TYPE sytime,
         lv_cnt        TYPE i,
         lv_index(2)   TYPE n,
         lv_fname(30)  TYPE c.

  FIELD-SYMBOLS <zdhdate>.

  DATA : ls_holidays TYPE iscal_day,
              lt_holidays TYPE TABLE OF iscal_day.

  " 역일기준 휴일대휴는 1회 제한.
  DATA : BEGIN OF ls_zthrbs01,
           pernr LIKE zthrbs01-pernr,
           rdate LIKE zthrbs01-rdate,
           begda  LIKE zthrbs01-begda,
           endda LIKE zthrbs01-endda,
           seqnr LIKE zthrbs01-seqnr,
           znal  LIKE zthrbs01-znal,
           zdaeh LIKE zthrbs01-zdaeh,
           zdday LIKE zthrbs01-zdday,
   END OF ls_zthrbs01,
         lt_zthrbs01 LIKE TABLE OF ls_zthrbs01.


  DATA: ls_day TYPE zshr0115.
  DATA: l_daynr LIKE  hrvsched-daynr.


*...//
  CLEAR: e_zdaeh, e_zdhdat01, e_zdhdat02, e_zdhcnt, e_enfo.
**************************************************************
**** 20190406
* 연속된 휴일이면서 각근무시간이 4.5가 안되는 경우 합산해서 출근일에 부여

  DATA: lt_data   TYPE  ztshr0115 WITH HEADER LINE.
  DATA: lr_date TYPE datum.
  DATA: l_chk.
  CLEAR: lt_data[], lt_data, lr_date, l_chk.


  LOOP AT et_data  INTO ls_day .
    IF ls_day-days <> '0'. " 다 휴일인가
      l_chk = 'X'. EXIT.
    ENDIF.

    IF ls_day-zgubun = 'C'. " 교대조인가
      l_chk = 'X'. EXIT.
    ENDIF.

    IF ls_day-stdaz >= '4.5'. " 4.5 시간 미만인가
      l_chk = 'X'. EXIT.
    ENDIF.
  ENDLOOP.
  IF l_chk = ''.

    LOOP AT et_data  INTO ls_day .

      lt_data-datum = is_zthrbs01-rdate.
      lt_data-zgubun = ls_day-zgubun.
      lt_data-stdaz = ls_day-stdaz.
      lt_data-days = ls_day-days.
      COLLECT lt_data. CLEAR lt_data.

    ENDLOOP.

  ELSE.
    lt_data[] = et_data[].

  ENDIF.



  LOOP AT lt_data INTO ls_day WHERE days = '0'
*                                               AND stdaz > 5
*                                               AND stdaz_a >= 5  "대휴발생기준 변경 - 2018.12.13 by erphr2
                                                 AND stdaz >= '4.5'  "대휴발생기준 변경 - 2018.12.20 by erphr2
                                                 AND zgubun <> 'C'.


*...// 기존의 대휴발생건 확인
    SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_zthrbs01
             FROM zthrbs01
             WHERE pernr = is_zthrbs01-pernr
               AND   ZDDAY = ls_day-datum
               AND   zdaeh NE ''
*               AND NOT state IN ('0','2','5','9','F').
               AND NOT state IN ('2','5','9','F').  "상태 0제외 - 2019.05.09 by chl


    IF i_mode = 'M' AND sy-subrc = 0.
*...// 수정인경우 현재건은 기존 대휴 발생건에서 제외
*      DELETE lt_zthrbs01 WHERE pernr = is_zthrbs01-pernr
*                           AND rdate = is_zthrbs01-rdate
*                           AND seqnr = is_zthrbs01-seqnr.
***            *** 20190406
*       양일 대휴로 발생할수 있으므로 rdate  와 begda 를 사용
*      휴일은 한건만 발생 seqnr 조회 안함
      DELETE lt_zthrbs01 WHERE pernr = is_zthrbs01-pernr
                       AND ( ( begda = is_zthrbs01-rdate ) OR " 출근일 비교
                               ( rdate = is_zthrbs01-rdate ) ).

    ENDIF.

*  동일일자에 대휴 발생건이 있으면 발생 안함
    IF LINES( lt_zthrbs01 ) > 0.
      CONTINUE.
    ENDIF.

*-> begin 같은 대휴일이 있는지 체크 2019.05.09 by chl
    SELECT *
      INTO CORRESPONDING FIELDS OF TABLE lt_zthrbs01
      FROM zthrbs01
     WHERE pernr = is_zthrbs01-pernr
       AND zdday = ls_day-datum
       AND zdaeh NE ''
       AND NOT state IN ('2','5','9','F').

    IF sy-subrc = 0.
      IF i_mode = 'M'.
        DELETE lt_zthrbs01 WHERE begda = is_zthrbs01-rdate OR rdate = is_zthrbs01-rdate.
        IF LINES( lt_zthrbs01 ) > 0.
          CONTINUE.
        ENDIF.
      ELSE.
        CONTINUE.
      ENDIF.
    ENDIF.
*<- end 같은 대휴일이 있는지 체크 2019.05.09 by chl


    e_zdaeh = 'X'.


    IF  e_zdhdat01 IS  INITIAL.
      e_zdhdat01 = ls_day-datum.
    ELSE.
      e_zdhdat02 =  ls_day-datum.
    ENDIF.

    ADD 1 TO  e_zdhcnt.


* 강제여부 (토/일이면 강제 )
    CALL FUNCTION 'RH_GET_DATE_DAYNAME'
      EXPORTING
        langu = sy-langu
        date  = ls_day-datum
      IMPORTING
        daynr = l_daynr.

* 특근 토 .일이 아니면 강제
    IF l_daynr = '6' OR l_daynr = '7'.
      e_enfo = 'X'.
    ENDIF.

    CLEAR  ls_day.
  ENDLOOP.

***
*  LOOP AT et_data INTO ls_day WHERE days = '0'
**                                               AND stdaz > 5
**                                               AND stdaz_a >= 5  "대휴발생기준 변경 - 2018.12.13 by erphr2
*                                               AND stdaz >= '4.5'  "대휴발생기준 변경 - 2018.12.20 by erphr2
*                                               AND zgubun <> 'C'.
*
*
**...// 기존의 대휴발생건 확인
*    SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_zthrbs01
*             FROM zthrbs01
*             WHERE pernr = is_zthrbs01-pernr
*               AND   rdate = ls_day-datum
*               AND   zdaeh NE ''
*               AND NOT state IN ('2','5','9','F').
*
*
*    IF i_mode = 'M' AND sy-subrc = 0.
**...// 수정인경우 현재건은 기존 대휴 발생건에서 제외
**      DELETE lt_zthrbs01 WHERE pernr = is_zthrbs01-pernr
**                           AND rdate = is_zthrbs01-rdate
**                           AND seqnr = is_zthrbs01-seqnr.
****            *** 20190406
**       양일 대휴로 발생할수 있으므로 rdate  대신 begda 를 사용
**      휴일은 한건만 발생 seqnr 조회 안함
*          DELETE lt_zthrbs01 WHERE pernr = is_zthrbs01-pernr
*                           AND begda = is_zthrbs01-rdate. " 출근일 기준으로 비교
*
*    ENDIF.
*
**  동일일자에 대휴 발생건이 있으면 발생 안함
*    IF LINES( lt_zthrbs01 ) > 0.
*      CONTINUE.
*    ENDIF.
*
*
*    e_zdaeh = 'X'.
*
*
*    IF  e_zdhdat01 IS  INITIAL.
*      e_zdhdat01 = ls_day-datum.
*    ELSE.
*      e_zdhdat02 =  ls_day-datum.
*    ENDIF.
*
*    ADD 1 TO  e_zdhcnt.
*
*
** 강제여부 (토/일이면 강제 )
*    CALL FUNCTION 'RH_GET_DATE_DAYNAME'
*      EXPORTING
*        langu = sy-langu
*        date  = ls_day-datum
*      IMPORTING
*        daynr = l_daynr.
*
** 특근 토 .일이 아니면 강제
*    IF l_daynr = '6' OR l_daynr = '7'.
*      e_enfo = 'X'.
*    ENDIF.
*
*  ENDLOOP.

ENDFUNCTION.
