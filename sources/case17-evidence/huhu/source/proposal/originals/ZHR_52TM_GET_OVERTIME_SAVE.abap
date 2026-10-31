FUNCTION zhr_52tm_get_overtime_save.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(I_MODE) TYPE  CHAR01
*"     VALUE(I_WKTYPE) TYPE  ZEWKTYPE OPTIONAL
*"     VALUE(I_ACTION) TYPE  SYUCOMM OPTIONAL
*"     VALUE(I_ZEXC) TYPE  CHAR1 OPTIONAL
*"     VALUE(I_MTYPE) TYPE  CHAR1 OPTIONAL
*"     VALUE(I_ZDIFF) TYPE  I OPTIONAL
*"     VALUE(I_RUN_R3) TYPE  CHAR1 OPTIONAL
*"     VALUE(IS_ZTHRBS01) TYPE  ZTHRBS01
*"     VALUE(I_SEQNR) TYPE  SEQNR
*"  EXPORTING
*"     VALUE(E_CODE) TYPE  CHAR03
*"     VALUE(E_TEXT) TYPE  CHAR200
*"  TABLES
*"      T_DATA STRUCTURE  ZTHRBS01 OPTIONAL
*"  CHANGING
*"     VALUE(C_ZTOMOH) TYPE  CHAR1 OPTIONAL
*"     VALUE(C_ZDAEH) TYPE  CHAR1 OPTIONAL
*"     VALUE(C_ZTOICH) TYPE  CHAR1 OPTIONAL
*"     VALUE(C_ZEMCWK) TYPE  CHAR1 OPTIONAL
*"----------------------------------------------------------------------
  DATA: lv_index TYPE i,
        lv_seqnr TYPE seqnr,
        lv_code TYPE char03,
        lv_text TYPE char200,
        lv_zdaeh_c TYPE i.    "대휴건수

  DATA : ls_zthrbs01      TYPE zthrbs01,
         ls_zthrbs01_d    TYPE zthrbs01,
         ls_overtime_data TYPE zsh_overtime_data_n,
         ls_zdaeh         TYPE zshr0121,
         lt_zdaeh         TYPE TABLE OF zshr0121.
* 데이타 초기화.
  CLEAR : e_code, e_text, ls_zthrbs01.

* 데이터가 가공되는곳 (가공이라고 해봐야... 연장시간 계산해서 대휴 /익휴 생성하고 ....재난이면 12시간 초과 가능하고..... 퇴출은 없어질거... ).
  CALL FUNCTION 'ZHR_52TM_GET_OVERTIME_DATA'
    EXPORTING
      i_mode           = i_mode
      i_wktype         = i_wktype
      i_action         = i_action
      i_zexc           = i_zexc
      i_mtype          = i_mtype
      is_zthrbs01      = is_zthrbs01
      i_run_r3         = i_run_r3
    IMPORTING
      es_overtime_data = ls_overtime_data
      e_code           = lv_code
      e_text           = lv_text
    TABLES
      t_zdaeh          = lt_zdaeh
    CHANGING
      c_zemcwk         = c_zemcwk " 재난
      c_ztoich         = c_ztoich       " 퇴출
      c_ztomoh         = c_ztomoh   " 익휴
      c_zdaeh          = c_zdaeh.    " 대휴


  MOVE-CORRESPONDING is_zthrbs01 TO ls_zthrbs01.

  MOVE : ls_overtime_data-zyoil       TO ls_zthrbs01-zyoil,
         ls_overtime_data-za_time     TO ls_zthrbs01-za_time,
         ls_overtime_data-ze_time     TO ls_zthrbs01-ze_time,
         ls_overtime_data-zr_time     TO ls_zthrbs01-zr_time,
         ls_overtime_data-zo_time     TO ls_zthrbs01-zo_time,
         ls_overtime_data-zn_time     TO ls_zthrbs01-zn_time,
         ls_overtime_data-zh_time     TO ls_zthrbs01-zh_time,
         ls_overtime_data-zd_time     TO ls_zthrbs01-zd_time,     "2011.04.
         ls_overtime_data-zo_money    TO ls_zthrbs01-zo_money,
         ls_overtime_data-zn_money    TO ls_zthrbs01-zn_money,
         ls_overtime_data-zh_money    TO ls_zthrbs01-zh_money,
         ls_overtime_data-zs_money    TO ls_zthrbs01-zs_money,
         ls_overtime_data-zd_money    TO ls_zthrbs01-zd_money,    "2011.04.
         ls_overtime_data-zmoney      TO ls_zthrbs01-zmoney,
         ls_overtime_data-zdaeh       TO ls_zthrbs01-zdaeh,
         ls_overtime_data-zgubn       TO ls_zthrbs01-zgubn,
         ls_overtime_data-zsign       TO ls_zthrbs01-zsign,
         ls_overtime_data-zcho        TO ls_zthrbs01-zcho,
         ls_overtime_data-zcho_m      TO ls_zthrbs01-zcho_m,
         ls_overtime_data-zyuhyung    TO ls_zthrbs01-zyuhyung.


* ZTHRBS01 테이블 키값설정->(PERNR+RDATE+SEQNR) 조합.
  IF i_mode <> 'M'.
    SELECT seqnr INTO lv_seqnr
        FROM zthrbs01
      UP TO 1 ROWS
      WHERE pernr = ls_zthrbs01-pernr
      AND   rdate = ls_zthrbs01-rdate
       ORDER BY seqnr DESCENDING.
    ENDSELECT.
    IF sy-subrc = 0.
      "혹시 회수된 문서인지 확인 후, 삭제 표시하고나서  seqnr + 1
      UPDATE zthrbs01 SET state = '2' state_txt = '삭제'
      WHERE  pernr = ls_zthrbs01-pernr AND rdate = ls_zthrbs01-rdate
      AND seqnr = i_seqnr AND state = '5'.

      ls_zthrbs01-seqnr = lv_seqnr + 1.
    ENDIF.

*    SELECT MAX( seqnr ) INTO lv_seqnr
*      FROM zthrbs01
*      WHERE pernr = ls_zthrbs01-pernr
*        AND subty IN ('','0009','9')     " 튜닝.
*        AND rdate = ls_zthrbs01-rdate.
*    IF sy-subrc = 0.
*      ls_zthrbs01-seqnr = lv_seqnr + 1.
*    ELSE.
*      ls_zthrbs01-seqnr = 1.
*    ENDIF.
  ENDIF.

*...// 대휴여부에 따라서 처리
  lv_zdaeh_c = LINES( lt_zdaeh ).

*..//  일자별로 합치기
  DATA: lt_zdaeh_tmp TYPE TABLE OF  zshr0121 WITH HEADER LINE.
  DATA: l_first , l_last, l_chg.
  DATA: l_time_e TYPE time.
  CLEAR: lt_zdaeh_tmp[], l_first, l_chg.

  IF lv_zdaeh_c > 1.
    LOOP AT lt_zdaeh INTO ls_zdaeh.

      IF l_first = ''.
        MOVE ls_zdaeh TO lt_zdaeh_tmp.
      ENDIF.
      l_first = 'X'.

      l_time_e = ls_zdaeh-zendtm.
      AT END OF datum.
        l_chg = 'X'.
      ENDAT.
      IF l_chg = 'X'.
        lt_zdaeh_tmp-zendtm = l_time_e.
        APPEND lt_zdaeh_tmp.
        CLEAR: l_first, l_chg.
      ENDIF.

    ENDLOOP.

    lt_zdaeh[] = lt_zdaeh_tmp[].
  ENDIF.
** // <<---


  lv_zdaeh_c = LINES( lt_zdaeh ).

  IF lv_zdaeh_c EQ 1.
    READ TABLE lt_zdaeh INTO ls_zdaeh INDEX 1.

    ls_zthrbs01-zdday = ls_zdaeh-datum.

    PERFORM get_zdaeh_data
      USING ls_zthrbs01-zgubun
            ls_zthrbs01-zdday  " 발생기준일.
   CHANGING ls_zthrbs01-zdbeg  " 사용시작일.
            ls_zthrbs01-zdend. " 사용종료일.

  "20251029-NGY-휴일 휴일이 양일로 나눠지므로 각 날짜에 맞는 대휴 금액이 들어가야 함
  "휴일-휴일용 양일 대휴 실비는 여기서 꺼내서 계산 함
     SELECT SINGLE zjorgehamt FROM zhrdaehuamt INTO ls_zthrbs01-jorgeh
     WHERE pernr = ls_zthrbs01-pernr AND datum = ls_zthrbs01-rdate.
     IF sy-subrc = 0.
       "사용하고 해당 라인 삭제
       DELETE FROM zhrdaehuamt WHERE pernr = ls_zthrbs01-pernr AND datum = ls_zthrbs01-rdate.
     ENDIF.

    APPEND ls_zthrbs01 TO t_data.

  ELSEIF lv_zdaeh_c EQ 2.  " 2일인 경우 레코드 분할
    lv_index = 1.

** '// 특근 철야 같이 상용 (대휴랑)
    LOOP AT lt_zdaeh INTO ls_zdaeh.
      CLEAR: lv_seqnr.

      PERFORM split_overtime_data
        USING i_mode
              i_wktype
              i_action
              ls_zdaeh-datum
              lv_index
              ls_zthrbs01
              ls_zdaeh
     CHANGING ls_zthrbs01_d.

      IF ls_zdaeh-zdaeh  = 'X'.  " 대휴인경우만
        PERFORM get_zdaeh_data
          USING ls_zthrbs01_d-zgubun
                ls_zthrbs01_d-zdday  " 발생기준일.
       CHANGING ls_zthrbs01_d-zdbeg  " 사용시작일.
                ls_zthrbs01_d-zdend. " 사용종료일.
      ENDIF.

*      APPEND ls_zthrbs01_d TO t_data.
*--------------------------------------------------------
*--------------------------------------------------------
*--------------------------------------------------------
      MOVE-CORRESPONDING ls_zthrbs01_d TO ls_zthrbs01.
*      LOOP AT t_data INTO ls_zthrbs01.

  "20231116-NGY-휴일 휴일이 양일로 나눠지므로 각 날짜에 맞는 대휴 금액이 들어가야 함
  "휴일-휴일용 양일 대휴 실비는 여기서 꺼내서 날짜별로 계산 함
     SELECT SINGLE zjorgehamt FROM zhrdaehuamt INTO ls_zthrbs01-jorgeh
     WHERE pernr = ls_zthrbs01-pernr AND datum = ls_zthrbs01-rdate.
     IF sy-subrc = 0.
       "사용하고 해당 라인 삭제
       DELETE FROM zhrdaehuamt WHERE pernr = ls_zthrbs01-pernr AND datum = ls_zthrbs01-rdate.
     ENDIF.

        IF i_mode <> 'M'.
          MOVE: '0'      TO ls_zthrbs01-state,     " 진행상태=0(신청).
                '미상신' TO ls_zthrbs01-state_txt, " 진행상태->미상신
                sy-datum TO ls_zthrbs01-erdat,     " 생성일.
                sy-uzeit TO ls_zthrbs01-ertim,     " 생성시간.
                sy-uname TO ls_zthrbs01-ernam,     " 생성자.
                sy-uname TO ls_zthrbs01-zpernr.
        ELSE.
          IF  ls_zthrbs01-state = ''.
            MOVE: '0'      TO ls_zthrbs01-state,     " 진행상태=0(신청).
          '미상신' TO ls_zthrbs01-state_txt. " 진행상태->미상신
          ENDIF.
          MOVE: sy-datum TO ls_zthrbs01-aedtm,  " 최종변경일.
                sy-uname TO ls_zthrbs01-uname.  " 최종변경자.
        ENDIF.

        IF ls_zthrbs01-ztomo IS NOT INITIAL.    " 익일.
          ls_zthrbs01-ztomo = 'Y'.
        ENDIF.

        IF ls_zthrbs01-ztoich IS NOT INITIAL.   " 퇴출.
          ls_zthrbs01-ztoich = 'Y'.
        ENDIF.

        IF ls_zthrbs01-zdaeh IS NOT INITIAL.    " 대휴.
          ls_zthrbs01-zdaeh = 'Y'.
        ENDIF.

        IF ls_zthrbs01-ztomoh IS NOT INITIAL.   " 익휴(익일일근면제)여부.
          ls_zthrbs01-ztomoh = 'Y'.
        ENDIF.

        IF ls_zthrbs01-zemcwk IS NOT INITIAL.   " 재난
          ls_zthrbs01-zemcwk = 'Y'.
        ENDIF.

        IF ls_zthrbs01-znurak IS NOT INITIAL.   " 누락여부.
          ls_zthrbs01-znurak = 'Y'.
        ENDIF.

* 결재경로수 설정 -> zthrbs01-zkno
        IF ls_zthrbs01-zcosa1 <> ''.    " 2차 결재자 지정여부.
          ls_zthrbs01-zkno = '2'.
        ELSE.
          ls_zthrbs01-zkno = '1'.
        ENDIF.

* 누락/환수->결재처리과정 무시(승인처리)
        IF ls_zthrbs01-znurak IS NOT INITIAL.   " 누락여부.
          ls_zthrbs01-zaccept   = 'Y'.
          ls_zthrbs01-zaccept1  = 'Y'.
          ls_zthrbs01-zno       = '9999'.
          ls_zthrbs01-zsangsin  = 'Y'.
          ls_zthrbs01-state     = '3'.
          ls_zthrbs01-state_txt = '승인'.
          ls_zthrbs01-aedtm     = sy-datum.
          ls_zthrbs01-uname     = sy-uname.
        ENDIF.

** 20190826 임시 입력구분 처리
        ls_zthrbs01-ZSOURFLEX = '1'.

        MODIFY zthrbs01 FROM ls_zthrbs01.
*        CLEAR ls_zthrbs01.
*--------------------------------------------------------
*--------------------------------------------------------
*--------------------------------------------------------
      lv_index  = lv_index + 1.
    ENDLOOP.
  ELSE.
    "대휴체크가 없을때 대휴일/대휴시작일/대휴종료일은 클리어 - 2019.05.09 by chl
    IF ls_zthrbs01-zdaeh = ''.
      CLEAR: ls_zthrbs01-zdday, ls_zthrbs01-zdbeg, ls_zthrbs01-zdend.
    ENDIF.
    APPEND ls_zthrbs01 TO t_data.
  ENDIF.



  IF lv_zdaeh_c NE '2'.

* 생성일/생성자 및 변경일/변경자 정보추가.
    LOOP AT t_data INTO ls_zthrbs01.
      IF i_mode <> 'M'.
        MOVE: '0'      TO ls_zthrbs01-state,     " 진행상태=0(신청).
              '미상신' TO ls_zthrbs01-state_txt, " 진행상태->미상신
              sy-datum TO ls_zthrbs01-erdat,     " 생성일.
              sy-uzeit TO ls_zthrbs01-ertim,     " 생성시간.
              sy-uname TO ls_zthrbs01-ernam,     " 생성자.
              sy-uname TO ls_zthrbs01-zpernr.
      ELSE.
        IF  ls_zthrbs01-state = ''.
          MOVE: '0'      TO ls_zthrbs01-state,     " 진행상태=0(신청).
        '미상신' TO ls_zthrbs01-state_txt. " 진행상태->미상신
        ENDIF.
        MOVE: sy-datum TO ls_zthrbs01-aedtm,  " 최종변경일.
              sy-uname TO ls_zthrbs01-uname.  " 최종변경자.
      ENDIF.

      IF ls_zthrbs01-ztomo IS NOT INITIAL.    " 익일.
        ls_zthrbs01-ztomo = 'Y'.
      ENDIF.

      IF ls_zthrbs01-ztoich IS NOT INITIAL.   " 퇴출.
        ls_zthrbs01-ztoich = 'Y'.
      ENDIF.

      IF ls_zthrbs01-zdaeh IS NOT INITIAL.    " 대휴.
        ls_zthrbs01-zdaeh = 'Y'.
      ENDIF.

      IF ls_zthrbs01-ztomoh IS NOT INITIAL.   " 익휴(익일일근면제)여부.
        ls_zthrbs01-ztomoh = 'Y'.
      ENDIF.

      IF ls_zthrbs01-zemcwk IS NOT INITIAL.   " 재난
        ls_zthrbs01-zemcwk = 'Y'.
      ENDIF.

      IF ls_zthrbs01-znurak IS NOT INITIAL.   " 누락여부.
        ls_zthrbs01-znurak = 'Y'.
      ENDIF.

* 결재경로수 설정 -> zthrbs01-zkno
      IF ls_zthrbs01-zcosa1 <> ''.    " 2차 결재자 지정여부.
        ls_zthrbs01-zkno = '2'.
      ELSE.
        ls_zthrbs01-zkno = '1'.
      ENDIF.

* 누락/환수->결재처리과정 무시(승인처리)
      IF ls_zthrbs01-znurak IS NOT INITIAL.   " 누락여부.
        ls_zthrbs01-zaccept   = 'Y'.
        ls_zthrbs01-zaccept1  = 'Y'.
        ls_zthrbs01-zno       = '9999'.
        ls_zthrbs01-zsangsin  = 'Y'.
        ls_zthrbs01-state     = '3'.
        ls_zthrbs01-state_txt = '승인'.
        ls_zthrbs01-aedtm     = sy-datum.
        ls_zthrbs01-uname     = sy-uname.
      ENDIF.

** 20190826 임시 입력구분 처리
      ls_zthrbs01-ZSOURFLEX = '1'.

      MODIFY t_data FROM ls_zthrbs01. CLEAR ls_zthrbs01.
    ENDLOOP.

  ENDIF.

ENDFUNCTION.
