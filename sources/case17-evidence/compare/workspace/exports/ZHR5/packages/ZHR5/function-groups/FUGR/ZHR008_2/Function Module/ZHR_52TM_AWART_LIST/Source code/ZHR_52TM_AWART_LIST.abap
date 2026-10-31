FUNCTION zhr_52tm_awart_list .
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(I_PERNR) TYPE  PERSNO
*"     VALUE(I_BEGDA) TYPE  BEGDA DEFAULT SY-DATUM
*"     VALUE(I_ENDDA) TYPE  ENDDA DEFAULT SY-DATUM
*"     VALUE(I_ZSANGSIN) TYPE  CHAR01 DEFAULT 'X'
*"  EXPORTING
*"     VALUE(E_RETURN) TYPE  BAPIRETURN1
*"  TABLES
*"      T_DATA STRUCTURE  ZSHR0111
*"----------------------------------------------------------------------
*- 사원이 E-HR을 통해 등록한 휴무/근무 정보 I/F

  DATA : ls_day    TYPE casdayattr,
         lt_day    LIKE TABLE OF ls_day,
         ls_0080   TYPE zthr0080," 휴무/근무
         lt_0080   LIKE TABLE OF ls_0080,
         ls_bs01   TYPE zthrbs01," 익휴
         lt_bs01   LIKE TABLE OF ls_bs01,
         ls_bs13   TYPE zthrbs13," 출제위원
         lt_bs13   LIKE TABLE OF ls_bs13,
         ls_0081   TYPE zthr0081," 근태그룹
         lt_0081   LIKE TABLE OF ls_0081,
         ls_0081_2 TYPE zthr0081_2," 근태유형
         lt_0081_2 LIKE TABLE OF ls_0081_2.
  " 출장내역
  DATA : BEGIN OF ls_bt,
         pernr    TYPE zhrt002-pernr,
         bdate    TYPE zhrt001-bdate,
         edate    TYPE zhrt001-edate,
         c_code   TYPE zhrt001-c_code,
         c_ctxt   TYPE char10,
         zstat    TYPE zhrt002-zstat,
         ztext    TYPE char10,
         zworkout TYPE zeworkout,
         SDATE    TYPE ZDATE,   "추가 - 2019.03.7 BY CHL
         APP_NO   TYPE ZANO,   "추가 - 2019.03.7 BY CHL
         SEQ_NO   TYPE ZPNO,   "추가 - 2019.03.7 BY CHL
         END OF ls_bt,
         lt_bt LIKE TABLE OF ls_bt.
  " 근태내역
  DATA : BEGIN OF ls_total.
          INCLUDE STRUCTURE zshr0111.
  DATA : f_day TYPE c,
         h_day TYPE c,
         END OF ls_total,
         lt_total LIKE TABLE OF ls_total.
  DATA : l_index  TYPE sy-index,
         l_cnt    TYPE i,
         l_begda  TYPE begda,
         l_endda  TYPE endda,
         l_awart  TYPE awart,
         l_zcnval TYPE zecnval,
         l_time   TYPE time,
         l_hour   TYPE numc2,
         l_htime  TYPE numc2.

  DATA lt_zhrt002 TYPE TABLE OF zhrt002 WITH HEADER LINE.

  REFRESH : lt_total, t_data[].

*- 사번(테스트용)
*  IF i_pernr IS INITIAL .
*    i_pernr = sy-uname.
*  ENDIF.

  IF i_pernr IS INITIAL OR i_begda IS INITIAL OR i_endda IS INITIAL. "입력값이 하나라도 없으면 작동금지
    EXIT.
  ENDIF.

  " 근태그룹
  REFRESH lt_0081.
  SELECT * FROM zthr0081
    INTO CORRESPONDING FIELDS OF TABLE lt_0081.
  SORT lt_0081 BY gunart.

  " 근태유형
  REFRESH lt_0081_2.
  SELECT * FROM zthr0081_2
    INTO CORRESPONDING FIELDS OF TABLE lt_0081_2
   WHERE gunart = '10'" 일반근태
     AND guntype IN ('12','13','15')." 연차
  SORT lt_0081_2 BY guntype.

  " 인정시간
  CLEAR l_zcnval.
  SELECT SINGLE zcnval INTO l_zcnval
    FROM zthr0101
   WHERE zconst = 'ZNORHR'
     AND begda <= i_begda
     AND endda >= i_begda.
  IF sy-subrc = 0.
    l_htime = l_zcnval.
  ENDIF.

  " 공휴일
  REFRESH lt_day.
  CALL FUNCTION 'DAY_ATTRIBUTES_GET'
    EXPORTING
      factory_calendar = 'KR'
      holiday_calendar = 'KB'
      date_from        = i_begda
      date_to          = i_endda
    TABLES
      day_attributes   = lt_day.
  SORT lt_day BY date.

*---------------------------------------------------------------------------------------------*
*- 휴무정보
*---------------------------------------------------------------------------------------------*
  " 수정신청내역 체크
  PERFORM get_0080 TABLES lt_0080
                    USING i_pernr
                          i_begda
                          i_endda
                          i_zsangsin.
  LOOP AT lt_0080 INTO ls_0080.
    CLEAR : l_begda, l_endda, l_cnt.
    " 근태시작일
    IF ls_0080-begda < i_begda.
      l_begda = i_begda.
    ELSE.
      l_begda = ls_0080-begda.
    ENDIF.
    " 근태종료일
    IF ls_0080-endda > i_endda.
      l_endda = i_endda.
    ELSE.
      l_endda = ls_0080-endda.
    ENDIF.
    " 분할횟수
    l_cnt = l_endda - l_begda + 1.
    CLEAR : ls_total, l_index.
    DO l_cnt TIMES.
      l_index = sy-index.
      ls_total-datum = l_begda.

     "교대근무자들 휴일 및 공휴일에도 근무날일수 있고, 그때에 근태를 쓸수 있기에 해당 체크로직 주석처리함
      "changed by XA32762 / 2025-09-23

      " 휴일/공휴일 체크
      READ TABLE lt_day INTO ls_day WITH KEY date = l_begda BINARY SEARCH.
      IF sy-subrc = 0.
        " 휴일(토/일)
        IF ls_day-freeday IS NOT INITIAL.
          ls_total-f_day = abap_true.
        ELSE.
          CLEAR ls_total-f_day.
        ENDIF.
        " 공휴일
        IF ls_day-holiday IS NOT INITIAL.
          ls_total-h_day = abap_true.
        ELSE.
          CLEAR ls_total-h_day.
        ENDIF.
      ELSE.
        CLEAR : ls_total-f_day, ls_total-h_day.
      ENDIF.

      IF l_index = 1.
        " 사번
        ls_total-pernr = ls_0080-pernr.
        " 근태구분
        ls_total-zabsdayty = 'A'.
        " 근태코드/근태코드명/인정근로시간
        IF ls_0080-gunart = '10' AND ( ls_0080-guntype = '12' OR ls_0080-guntype = '13' OR ls_0080-guntype = '15').
          CONCATENATE ls_0080-gunart ls_0080-guntype INTO ls_total-awart.
*          "19.02.14 반차/연차로 통일
*          READ TABLE lt_0081_2 INTO ls_0081_2 WITH KEY guntype = ls_0080-guntype BINARY SEARCH.
*          IF sy-subrc = 0.
*            ls_total-atext = ls_0081_2-typetext.
*          ENDIF.
          IF ls_0080-guntype = '12'.
            ls_total-atext = '연차'.
          ELSEIF  ls_0080-guntype = '13' OR  ls_0080-guntype = '15'.
            ls_total-atext = '반차'.
          ELSE.
          ENDIF.
          ls_total-guntype = ls_0080-guntype.

          " 인정근로시간
          CLEAR l_time.
          IF ls_0080-guntype = '13' OR ls_0080-guntype = '15'." 연차(반일)
            CLEAR l_hour.
            l_hour = l_htime / 2.
            CONCATENATE l_hour '0000' INTO l_time.
          ELSE.
            CONCATENATE l_htime '0000' INTO l_time.
          ENDIF.
        ELSE.

          ls_total-awart = ls_0080-gunart.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = ls_total-awart
            IMPORTING
              output = ls_total-awart.
          " 인정근로시간
          CLEAR l_time.
          CONCATENATE l_htime '0000' INTO l_time.

          IF  ls_0080-begda >= '20200601'.
            IF ls_0080-gunart = '10' AND ( ls_0080-guntype = '42' OR ls_0080-guntype = '44' OR ls_0080-guntype = '46'
              OR ls_0080-guntype = '70' ).
              " 지참, 무단조퇴, 조퇴는 근로시간 미인정 xa30752 (2020.06.01) 인사운영부 민지홍 요청
              " 재택근무 추가
             IF ls_0080-guntype = '70'.
                ls_total-atext = '재택'.
             ELSEIF  ls_0080-guntype = '42'.
                ls_total-atext = '지참'.
             ELSEIF  ls_0080-guntype = '44'.
                ls_total-atext = '무단조퇴'.
             ELSEIF  ls_0080-guntype = '46'.
                ls_total-atext = '조퇴'.
             ENDIF.
              l_time = '000000'.
            ENDIF.
             ls_total-guntype = ls_0080-guntype.
          ENDIF.

          IF ls_0080-gunart = '30' AND ( ls_0080-guntype = '43' OR ls_0080-guntype = '44' ).
            " 청원휴가 - 자녀돌봄 (반일/오전 또는 오후) xa30752 (2020.11.11)
            l_time = '040000'.
          ENDIF.

          IF ls_0080-gunart = '40' AND ( ls_0080-guntype = '28' OR ls_0080-guntype = '29' ).
            " 공가-일반검진(오전,오후) - NGY- 4시간으로 적용
            l_time = '040000'.
          ENDIF.


        ENDIF.
        ls_total-zprsdwk_tm = l_time.
        IF ls_0080-gunart = '10' AND ( ls_0080-guntype = '12' OR ls_0080-guntype = '13' OR ls_0080-guntype = '15' OR ls_0080-guntype = '70').

        ELSE.
          READ TABLE lt_0081 INTO ls_0081 WITH KEY gunart = ls_0080-gunart BINARY SEARCH.
          IF sy-subrc = 0.
            ls_total-atext = ls_0081-arttext+0(2).  "19.02.14 청원휴가, 공가->2자리만 나오도록.
          ENDIF.
        ENDIF.
        " 결재상태코드
        CASE ls_0080-zaccept.
          WHEN 'Y'.
            ls_total-zstat = 'A'.
          WHEN OTHERS.
            IF ls_0080-zsangsin = 'X'.
              "20260804-NGY-기존 근태를 삭제 결재 올렸는데 결재자가 반려한 경우는 근태가 살아있다고 봐야함.
               IF ls_0080-state = '2' AND ls_0080-zserial2 IS NOT INITIAL AND ls_0080-zaccept = 'N'.
                  ls_total-zstat = 'A'.
               ELSE.
                  ls_total-zstat = 'P'.
               ENDIF.
            ELSE.
              ls_total-zstat = 'T'.
            ENDIF.
        ENDCASE.
        " 결재상태명
        CASE ls_total-zstat.
          WHEN 'A'.
            ls_total-zstxt = '승인'.
          WHEN 'P'.
            ls_total-zstxt = '결재중'.
          WHEN 'T'.
            ls_total-zstxt = '미상신'.
        ENDCASE.
      ENDIF.
      APPEND ls_total TO lt_total.
      l_begda = l_begda + 1.
    ENDDO.
  ENDLOOP.
  " 휴무정보는 휴일 or 공휴일 기간 삭제
  DELETE lt_total WHERE f_day = 'X' OR h_day = 'X'.
*---------------------------------------------------------------------------------------------*
*- 익휴('신청일+1'에 사용)
*---------------------------------------------------------------------------------------------*
  " 시작일/종료일
  CLEAR : l_begda, l_endda.
  l_begda = i_begda - 1.
  l_endda = i_endda - 1.

  REFRESH lt_bs01.
  SELECT * FROM zthrbs01
    INTO CORRESPONDING FIELDS OF TABLE lt_bs01
   WHERE pernr = i_pernr
     AND ztomoh = 'Y'" 익휴
     AND state  = '3'" 승인
     AND rdate BETWEEN l_begda AND l_endda.
  SORT lt_bs01 BY pernr rdate.

  LOOP AT lt_bs01 INTO ls_bs01.
    ls_total-pernr = ls_bs01-pernr." 사번
    ls_total-datum = ls_bs01-rdate + 1." 일자
    ls_total-zabsdayty = 'A'." 근태구분
    ls_total-awart = '9995'. " 근태코드
    ls_total-atext = '익휴'. " 근태코드명
    ls_total-zstat = 'A'.    " 결재상태코드
    ls_total-zstxt = '승인'. " 결재상태명
    " 인정근로시간
    CLEAR l_time.
    CONCATENATE l_htime '0000' INTO l_time.
    ls_total-zprsdwk_tm = l_time.
    APPEND ls_total TO lt_total.
  ENDLOOP.
*---------------------------------------------------------------------------------------------*
*- 출장정보
*---------------------------------------------------------------------------------------------*
  REFRESH lt_bt.
  SELECT a~pernr a~zstat a~zworkout b~c_code b~bdate b~edate a~sdate a~app_no a~seq_no
    FROM zhrt002 AS a
   INNER JOIN zhrt001 AS b
      ON a~sdate  = b~sdate
     AND a~app_no = b~app_no
     AND a~seq_no = b~seq_no
    INTO CORRESPONDING FIELDS OF TABLE lt_bt
   WHERE a~pernr = i_pernr
     AND b~bdate <= i_endda
     AND b~edate >= i_begda
     AND a~zcanc = space
     AND a~c_flag <> 'X'  "변경신청이 아닌 경우 - 2019.06.29 by chl
     AND a~zstat IN ('A','P','T')." 승인/결재중/미상신
  SORT lt_bt BY pernr bdate.

*-> 출장삭제시 데이터를 삭제하는것이 아니고 신규데이터를 생성하면서 삭제플래그를 가지기 때문에
*   처음 생성된 출장데이터가 조회되므로 추가함 - 2019.03.7 BY CHL
  IF lt_bt IS NOT INITIAL.
    SELECT C_SDATE C_APP_NO C_SEQ_NO
      INTO CORRESPONDING FIELDS OF TABLE lt_zhrt002
      FROM ZHRT002
      FOR ALL ENTRIES IN lt_bt
     WHERE pernr = lt_bt-pernr
       AND c_sdate = lt_bt-sdate
       AND c_app_no = lt_bt-app_no
       AND c_seq_no = lt_bt-seq_no
       AND zcanc = 'X'.
  ENDIF.


  LOOP AT lt_bt INTO ls_bt.
    "삭제된 데이터인지 확인한다 - 2019.03.7 BY CHL
    READ TABLE lt_zhrt002 WITH KEY c_sdate = ls_bt-sdate
                                   c_app_no = ls_bt-app_no
                                   c_seq_no = ls_bt-seq_no.
    IF sy-subrc = 0.
      CONTINUE.
    ENDIF.

    CLEAR : l_begda, l_endda, l_cnt.
    " 출장시작일
    IF ls_bt-bdate < i_begda.
      l_begda = i_begda.
    ELSE.
      l_begda = ls_bt-bdate.
    ENDIF.
    " 출장종료일
    IF ls_bt-edate > i_endda.
      l_endda = i_endda.
    ELSE.
      l_endda = ls_bt-edate.
    ENDIF.
    " 분할횟수
    l_cnt = l_endda - l_begda + 1.
    CLEAR : ls_total, l_index.
    DO l_cnt TIMES.
      l_index = sy-index.
      ls_total-datum = l_begda.
      IF l_index = 1.
        " 사번
        ls_total-pernr = ls_bt-pernr.
        " 근태구분
        ls_total-zabsdayty = 'P'.
        IF ls_bt-zworkout IS NOT INITIAL.
          ls_total-awart = '9997'.
          ls_total-atext = '간주근로'.
          " 인정근로시간 xa30752(20190613)
          CLEAR l_time.
          CONCATENATE l_htime '0000' INTO l_time.
          ls_total-zprsdwk_tm = l_time.
        ELSE.
          " 근태코드
          ls_total-awart = ls_bt-c_code.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = ls_total-awart
            IMPORTING
              output = ls_total-awart.
          "19.02.14 출장 -> 국내, 국외로 변경
          IF ls_bt-c_code = '1'."국내
            ls_total-atext = '국내출장'.
          ELSEIF ls_bt-c_code = '2'."국외
            ls_total-atext = '국외출장'.
          ELSE.
*             ls_total-atext = '출장'.
          ENDIF.

        ENDIF.
        " 결재상태코드
        ls_total-zstat = ls_bt-zstat.
        " 결재상태명
        CASE ls_bt-zstat.
          WHEN 'A'.
            ls_total-zstxt = '승인'.
          WHEN 'P'.
            ls_total-zstxt = '결재중'.
          WHEN 'T'.
            ls_total-zstxt = '미상신'.
        ENDCASE.

        IF ls_bt-zworkout IS INITIAL.
          " 인정근로시간
          CLEAR l_time.
          l_time = '000000'. "국내외 출장은 인정근로시간 제공 안함 xa30752(20190613)
          ls_total-zprsdwk_tm = l_time.
        ENDIF.
      ENDIF.
      APPEND ls_total TO lt_total.
      l_begda = l_begda + 1.
    ENDDO.
  ENDLOOP.
*---------------------------------------------------------------------------------------------*
*- 출제위원
*---------------------------------------------------------------------------------------------*
  REFRESH lt_bs13.
  SELECT * FROM zthrbs13
    INTO CORRESPONDING FIELDS OF TABLE lt_bs13
   WHERE pernr = i_pernr
     AND begda <= i_endda
     AND endda >= i_begda.
  SORT lt_bs13 BY pernr begda.

  LOOP AT lt_bs13 INTO ls_bs13.
    CLEAR : l_begda, l_endda, l_cnt.
    " 출제위원 시작일
    IF ls_bs13-begda < i_begda.
      l_begda = i_begda.
    ELSE.
      l_begda = ls_bs13-begda.
    ENDIF.
    " 근태종료일
    IF ls_bs13-endda > i_endda.
      l_endda = i_endda.
    ELSE.
      l_endda = ls_bs13-endda.
    ENDIF.
    " 분할횟수
    l_cnt = l_endda - l_begda + 1.
    CLEAR : ls_total, l_index.
    DO l_cnt TIMES.
      l_index = sy-index.
      ls_total-datum = l_begda.
      IF l_index = 1.
        " 사번
        ls_total-pernr = ls_bs13-pernr.
        " 근태구분
        ls_total-zabsdayty = 'P'.
        " 근태코드
        ls_total-awart = '9998'.
        " 근태코드명
        PERFORM get_domain USING 'ZDREASN'
                                 ls_bs13-zreasn
                        CHANGING ls_total-atext.
        " 결재상태코드
        ls_total-zstat = 'A'.
        " 결재상태명
        ls_total-zstxt = '승인'.
        " 인정근로시간
        CLEAR l_time.
        CONCATENATE l_htime '0000' INTO l_time.
        ls_total-zprsdwk_tm = l_time.
      ENDIF.
      APPEND ls_total TO lt_total.
      l_begda = l_begda + 1.
    ENDDO.
  ENDLOOP.
*---------------------------------------------------------------------------------------------*
*- 주중공휴일
*---------------------------------------------------------------------------------------------*
  LOOP AT lt_day INTO ls_day.
    IF ( ls_day-weekday <> '6' AND ls_day-weekday <> '7' ) AND ls_day-holiday IS NOT INITIAL.
      CLEAR ls_total.
      ls_total-pernr = i_pernr.
      ls_total-zabsdayty = 'H'.
      ls_total-datum = ls_day-date.
      ls_total-awart = '9999'.
      ls_total-atext = ls_day-txt_short.
      " 결재상태코드
      ls_total-zstat = 'A'.
      " 결재상태명
      ls_total-zstxt = '승인'.
      " 인정근로시간
      CLEAR l_time.
      CONCATENATE l_htime '0000' INTO l_time.
      ls_total-zprsdwk_tm = l_time.
      APPEND ls_total TO lt_total.
    ENDIF.
  ENDLOOP.

  SORT lt_total BY pernr datum.
  t_data[] = lt_total[].

  " Return Message
  IF lt_total[] IS INITIAL.
    e_return-type = c_error.
    " 해당 데이터가 없습니다.
    e_return-message = text-m01.
  ELSE.
    e_return-type = c_success.
  ENDIF.

ENDFUNCTION.
