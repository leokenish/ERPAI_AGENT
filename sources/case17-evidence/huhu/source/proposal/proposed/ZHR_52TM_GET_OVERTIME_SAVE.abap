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

* 계산 오류일 때는 기존 오류 코드와 문구를 호출자에게 돌려준다.
* 실패한 계산값을 새 정산금액으로 저장하지 않는다.
  IF lv_code+0(1) EQ 'E'.
    e_code = lv_code.
    e_text = lv_text.
    RETURN.
  ENDIF.

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
         ls_overtime_data-zd_money    TO ls_zthrbs01-zd_money,
* 현재 신청의 새 정산금액도 복사한다. 정상 계산값 0도 반영한다.
         ls_overtime_data-jorgeh      TO ls_zthrbs01-jorgeh,
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

  IF lv_zdaeh_c EQ 1.
    READ TABLE lt_zdaeh INTO ls_zdaeh INDEX 1.

    ls_zthrbs01-zdday = ls_zdaeh-datum.

    PERFORM get_zdaeh_data
      USING ls_zthrbs01-zgubun
            ls_zthrbs01-zdday  " 발생기준일.
   CHANGING ls_zthrbs01-zdbeg  " 사용시작일.
            ls_zthrbs01-zdend. " 사용종료일.

* 한 날짜 묶음에 저장하는 건은 이번 신청의 전체 금액을 사용한다.
* 합산 대휴의 다른 날짜 기여분도 전체 금액에 포함되어 있다.
* 임시 DB를 조회하지 않으며 이전 신청의 값으로 대체하지 않는다.
    ls_zthrbs01-jorgeh = ls_overtime_data-jorgeh.

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

* F05의 하루별 재계산이 끝난 뒤 정산금액을 최종 설정한다.
* 원래 양일 계산에서 나온 이번 신청의 금액을 사용한다.
    CLEAR ls_zthrbs01-jorgeh.

    IF ls_zdaeh-zdaeh EQ 'X'.
      IF lv_daeh_days EQ 1.
* 실제 대휴가 하나이면 전체 정산금액을 그 대휴에 귀속한다.
        ls_zthrbs01-jorgeh = ls_overtime_data-jorgeh.
      ELSE.
* 대휴가 둘이면 해당 날짜의 합계만 저장한다.
* 상세 금액에는 기존 저장 단위 변환 * 100을 한 번 적용한다.
        ls_zthrbs01-jorgeh = ls_zdaeh-zjorgehamt * 100.
      ENDIF.
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
