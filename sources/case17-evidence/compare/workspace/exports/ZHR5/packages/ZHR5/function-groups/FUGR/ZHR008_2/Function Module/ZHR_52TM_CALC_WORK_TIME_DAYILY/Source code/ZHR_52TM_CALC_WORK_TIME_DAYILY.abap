FUNCTION zhr_52tm_calc_work_time_dayily.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(IS_DAY) TYPE  ZSHR0115
*"     VALUE(I_OPT) TYPE  CHAR1 OPTIONAL
*"     VALUE(I_NGT) TYPE  CHAR1 OPTIONAL
*"     VALUE(I_PERNR) TYPE  PERSNO OPTIONAL
*"     VALUE(I_Z52WKTP) TYPE  ZE52WKTP DEFAULT '0120'
*"     VALUE(I_Z52PRSQ) TYPE  ZE52PRSQ DEFAULT '02'
*"     VALUE(I_ZPLWKHR_TY) TYPE  ZEPLWKHR_TY OPTIONAL
*"     VALUE(I_WK_START) TYPE  BEGDA OPTIONAL
*"     VALUE(I_WK_END) TYPE  ENDDA OPTIONAL
*"  EXPORTING
*"     VALUE(E_ZRLWK_TM) TYPE  ZCHAR06
*"     VALUE(E_ZPDWK_TM) TYPE  ZCHAR06
*"     VALUE(E_RM1WK_TM) TYPE  ZCHAR06
*"     VALUE(E_RM2WK_TM) TYPE  ZCHAR06
*"     VALUE(E_RM1WK_OV) TYPE  CHAR6
*"     VALUE(E_RM2WK_OV) TYPE  CHAR6
*"     VALUE(E_ZPDWK_D_TM) TYPE  ZEPDWK_TM
*"  TABLES
*"      T_DAY_TIME TYPE  ZTSHR0115
*"      T_DAILY STRUCTURE  ZSHR0110 OPTIONAL
*"----------------------------------------------------------------------
  DATA: l_time_t(6) TYPE n,
           l_time_h(6) TYPE n,
           l_znal TYPE datum,
           l_begt TYPE tims,
           l_endt TYPE tims,
           l_days TYPE i.

  DATA: l_stdaz TYPE abstd.
  DATA: t_break TYPE STANDARD TABLE OF p2005_break WITH HEADER LINE.
  DATA: dayint TYPE STANDARD TABLE OF  pwsdayint,
           daygen TYPE STANDARD TABLE OF  pwsdaygen WITH HEADER LINE.

  DATA: l_tmtyp_f,
           l_tmtyp_l.

  DATA: l_time1 TYPE  zchar06,
              l_time2 TYPE  zchar06,
              l_time_diff1 TYPE zchar06,
              l_time_diff2 TYPE zchar06.
  DATA: ls_day TYPE   zshr0115.

  DATA: l_break_sum TYPE stdaz.

  FIELD-SYMBOLS: <fs> TYPE ANY,
                              <fs2>   TYPE ANY,
                              <fs_i>  TYPE ANY,
                              <fs_i2> TYPE ANY,
                              <fs_e>  TYPE ANY,
                              <fs_e2> TYPE ANY.

  DATA: field(40),
        l_index TYPE n,
        l_index2 TYPE n.

  DATA: l_sec TYPE  sytabix.
  CLEAR: l_days,    dayint, daygen[], daygen, t_day_time, t_day_time[],
              l_time1, l_time2, l_time_diff1, l_time_diff2.

** 입력시간 check
  CHECK is_day IS NOT INITIAL.
  IF is_day-zbegtm IS  INITIAL AND is_day-zendtm IS  INITIAL.
    RETURN.
  ENDIF.

  IF ( is_day-zbegtm(4) NOT BETWEEN '0000' AND '2330' ) OR
     ( is_day-zendtm(4) NOT BETWEEN '0030' AND '2400' ).
    RETURN.
  ENDIF.

  IF ( is_day-zbegtm < is_day-zendtm ) AND is_day-ztomo <> ' '.
    RETURN.
  ENDIF.

  IF ( is_day-zbegtm >= is_day-zendtm ) AND is_day-ztomo = ' '.
    RETURN.
  ENDIF.


** 의무휴게시간 **
  DATA: l_zbegtm TYPE begti,
        l_zendtm TYPE endti,
        l_zpbtm TYPE ztomo,
        l_zpetm TYPE ztomo.

  CLEAR: l_zbegtm, l_zendtm, l_zpbtm, l_zpetm.
  CALL FUNCTION 'ZHR_52TM_CALC_BREAK_TIME'
    EXPORTING
      i_zbegtm         = is_day-zbegtm
      i_zendtm         = is_day-zendtm
      i_zgubun         = is_day-zgubun
   IMPORTING
     e_zbegtm         = l_zbegtm
     e_zendtm         = l_zendtm
     e_zpdwk_tm       = e_zpdwk_d_tm
     e_zpbtm          = l_zpbtm
     e_zpetm          = l_zpetm

*        E_RETURN         =
            .
*     if e_zpdwk_d_tm is not initial and
*       ( is_day-ZPBEG1 is initial and is_day-ZPEND1 is initial ).
*         is_day-ZPBEG1 = l_zbegtm.
*         is_day-ZPBTM1 = l_zpbtm.
*         is_day-ZPEND1 = l_zendtm.
*         is_day-ZPETM1 = l_zpetm.
*     endif.

  "*** 날짜 쪼개기 ( if 양일이면) .

  IF is_day-ztomo <> ''.
    MOVE: is_day-datum TO t_day_time-datum,
               is_day-zbegtm TO t_day_time-zbegtm,
               is_day-zendtm TO t_day_time-zendtm.

    " 첫째날 (당일) ------------------------------------
    t_day_time-zendtm = '240000'.


    DO 5 TIMES. " 필드가 5개까지 입력가능한듯....
      ADD 1 TO  l_index .
      CONCATENATE 'is_day-ZPBTM' l_index INTO field.
      ASSIGN (field) TO <fs>.
      CONCATENATE 'is_day-ZPETM' l_index INTO field.
      ASSIGN (field) TO <fs2>.

      IF <fs> IS INITIAL.
        CONCATENATE 'is_day-ZPBEG' l_index INTO field.
        ASSIGN (field) TO <fs_i>.
        CONCATENATE 't_day_time-ZPBEG' l_index INTO field.
        ASSIGN (field) TO <fs_e>.
        <fs_e> = <fs_i>.


        CONCATENATE 'is_day-ZPEND' l_index INTO field.
        ASSIGN (field) TO <fs_i>.
        CONCATENATE 't_day_time-ZPEND' l_index INTO field.
        ASSIGN (field) TO <fs_e>.
        <fs_e> = <fs_i>.

        IF <fs2> IS NOT INITIAL.
          <fs_e> = '240000'.
        ENDIF.

      ENDIF.
    ENDDO.

    APPEND t_day_time. CLEAR: l_index,  t_day_time.

    " 둘째날 (익일) -------------------------------------
    MOVE: is_day-datum TO t_day_time-datum,
              is_day-zbegtm TO t_day_time-zbegtm,
              is_day-zendtm TO t_day_time-zendtm.


    t_day_time-datum = t_day_time-datum + 1.
    t_day_time-zbegtm = '000000'.

*    DO 5 TIMES.
*      ADD 1 TO  l_index .
*      CONCATENATE 'is_day-ZPETM' l_index INTO field.
*      ASSIGN (field) TO <fs>.
*      CONCATENATE 'is_day-ZPBTM' l_index INTO field.
*      ASSIGN (field) TO <fs2>.
*
*      IF <fs> IS NOT  INITIAL.
*        CONCATENATE 'is_day-ZPBEG' l_index INTO field.
*        ASSIGN (field) TO <fs_i>.
*        CONCATENATE 't_day_time-ZPBEG' l_index INTO field.
*        ASSIGN (field) TO <fs_e>.
*        <fs_e> = <fs_i>.
*
*        IF <fs2> IS INITIAL.
*          <fs_e> = '000000'.
*        ENDIF.
*
*        CONCATENATE 'is_day-ZPEND' l_index INTO field.
*        ASSIGN (field) TO <fs_i>.
*        CONCATENATE 't_day_time-ZPEND' l_index INTO field.
*        ASSIGN (field) TO <fs_e>.
*        <fs_e> = <fs_i>.
*
*      ENDIF.
*    ENDDO.

    DO 5 TIMES.
      ADD 1 TO  l_index .
      CONCATENATE 'is_day-ZPETM' l_index INTO field.
      ASSIGN (field) TO <fs>.
      CONCATENATE 'is_day-ZPBTM' l_index INTO field.
      ASSIGN (field) TO <fs2>.

      IF <fs> IS NOT  INITIAL.
        CONCATENATE 'is_day-ZPBEG' l_index INTO field.
        ASSIGN (field) TO <fs_i>.
        CONCATENATE 'is_day-ZPEND' l_index INTO field.
        ASSIGN (field) TO <fs_i2>.


        "IT에 휴식시간값 넣기 빈값부터 확인
        CLEAR l_index2.
        DO 5 TIMES.
          ADD 1 TO l_index2.
          CONCATENATE 't_day_time-ZPBEG' l_index2 INTO field.
          ASSIGN (field) TO <fs_e>.
          CONCATENATE 't_day_time-ZPEND' l_index2 INTO field.
          ASSIGN (field) TO <fs_e2>.

          IF <fs_e> IS NOT INITIAL OR <fs_e2> IS NOT INITIAL.
            CONTINUE.
          ENDIF.

          <fs_e> = <fs_i>.
          <fs_e2> = <fs_i2>.
          " 익일의 시작
          IF <fs2> IS INITIAL.
            <fs_e> = '000000'.
          ENDIF.
          EXIT.
        ENDDO.

      ENDIF.
    ENDDO.


    APPEND t_day_time.CLEAR t_day_time.

  ELSE. " 하루짜리면 그대로 복사해서 가져가도됨....
    MOVE is_day TO t_day_time.
    APPEND t_day_time. CLEAR t_day_time.
  ENDIF.
*------  날짜 쪼개기 완료 t_day_time테이블에 하루 또는 양일로 날짜가 나뉘어 저장------


  daygen-datum =  is_day-datum.
  daygen-motpr = '41'.
  APPEND daygen.


  DATA: lv_first.
  CLEAR lv_first.


  LOOP AT t_day_time.

    MOVE:is_day-zgubun TO t_day_time-zgubun,
             is_day-zyuhyung TO t_day_time-zyuhyung.
    CLEAR l_days.

    CALL FUNCTION 'ZH_GET_WORKDAYS'
      EXPORTING
        begda = t_day_time-datum
        endda = t_day_time-datum
      IMPORTING
        days  = l_days.


    CLEAR: t_break[], t_break, l_index, l_break_sum.
    IF  lv_first = ''. l_tmtyp_f  = l_days. ENDIF. " 첫날의 day type
    lv_first = 'X'.

*     IF I_Z52WKTP = '0010'.
*       l_days = '1'.
*   ENDIF.

    l_tmtyp_l = l_days.




    DO 5 TIMES.
      ADD 1 TO l_index.

      CONCATENATE 't_day_time-ZPBEG' l_index INTO field.
      ASSIGN (field) TO <fs_i>.

      CONCATENATE 't_day_time-ZPEND' l_index INTO field.
      ASSIGN (field) TO <fs_e>.


      t_break-pbeg = <fs_i>.
      t_break-pend = <fs_e>.

      CHECK <fs_i> IS NOT INITIAL OR <fs_e> IS NOT INITIAL.

** 20190514 휴게시작 또는 종료시간이 근무 시작 종료시간내 시간으로 처리
      IF ( <fs_i> BETWEEN  t_day_time-zbegtm AND t_day_time-zendtm ) OR
          ( <fs_e> BETWEEN  t_day_time-zbegtm AND t_day_time-zendtm ).
      ELSE.
        CONTINUE.
      ENDIF.

      IF t_break-pbeg <= t_day_time-zbegtm .
        t_break-pbeg = t_day_time-zbegtm.
      ENDIF.

      IF t_break-pend >= t_day_time-zendtm .
        t_break-pend = t_day_time-zendtm.
      ENDIF.
*** <<----

      CLEAR l_sec.

      IF t_break-pbeg IS NOT INITIAL OR
         t_break-pend IS NOT INITIAL.
        CALL FUNCTION 'SWI_DURATION_DETERMINE'
          EXPORTING
            start_date = is_day-datum
            end_date   = is_day-datum
            start_time = t_break-pbeg
            end_time   = t_break-pend
          IMPORTING
            duration   = l_sec.

        t_break-punb = l_sec / 3600.
        APPEND t_break. CLEAR t_break.
      ENDIF.
    ENDDO.

"
*    IF t_break[] IS INITIAL .
*      EXIT.
*    ENDIF.

    CALL FUNCTION 'HR_PROPOSE_OVERTIME'
                EXPORTING
                  beguz                     =  t_day_time-zbegtm
                  enduz                      = t_day_time-zendtm
                  vtken                      = ''
                  stdaz                      = ''
                  date                       = t_day_time-datum
                  break_shift                = ''
               IMPORTING
*               BEGUZ_EXP                  =
*               ENDUZ_EXP                  =
*               VTKEN_EXP                  =
                 stdaz_exp                  = l_stdaz
*               MESSAGE_OCCURED            =
                TABLES
                  dayint                     = dayint
                  daygen                     = daygen
                  breaks                     = t_break
               EXCEPTIONS
                 overtime_not_allowed       = 1
                 error_break                = 2
                 OTHERS                     = 3
                        .
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    t_day_time-stdaz = l_stdaz.

    " hour -> 00:00:00
    PERFORM set_hour_to_time USING l_stdaz
                                                     t_day_time-zrlwk_tm.



    " 휴게시간
    PERFORM set_calc_break_time USING  t_day_time-datum
                                                                        t_day_time-zbegtm
                                                                        t_day_time-zendtm
                                                                        t_day_time-zrlwk_tm
                                                                       t_day_time-zpdwk_tm.
*
*     CALL FUNCTION 'SWI_DURATION_DETERMINE'
*          EXPORTING
*            start_date = is_day-datum
*            end_date   = is_day-datum
*            start_time = t_break-pbeg
*            end_time   = t_break-pend
*          IMPORTING
*            duration   = l_sec.
*
*        t_break-punb = l_sec / 3600.


    t_day_time-days = l_days.

    MODIFY t_day_time.
    CLEAR: t_day_time, l_stdaz, t_break[], t_break.
  ENDLOOP.


********************************************
*근무시간합산
********************************************
  LOOP AT t_day_time  INTO ls_day.
    l_time1 = ls_day-zrlwk_tm.
    l_time2 = l_time_diff1.
    CALL FUNCTION 'ZHR_SUM_TIME_N'
      EXPORTING
        time1    = l_time1
        time2    = l_time2
      IMPORTING
        time_sum = l_time_diff1.

    e_zrlwk_tm = l_time_diff1.

    l_time1 = ls_day-zpdwk_tm.
    l_time2 = l_time_diff2.
    CALL FUNCTION 'ZHR_SUM_TIME_N'
      EXPORTING
        time1    = l_time1
        time2    = l_time2
      IMPORTING
        time_sum = l_time_diff2.

    e_zpdwk_tm = l_time_diff2.
  ENDLOOP.


***************************************************
* 1주차/.2주차  잔여시간
***************************************************
  DATA: l_1wk_t TYPE ztime,
           l_2wk_t TYPE ztime.

  DATA: l_1wk_start TYPE datum,
           l_1wk_end TYPE datum,
           l_2wk_start TYPE datum,
           l_2wk_end TYPE datum.

  DATA: t_z0106 TYPE STANDARD TABLE OF zshr0106 WITH HEADER LINE.
  DATA: l_weeksq TYPE zeweeksq.

  CLEAR: t_z0106[], t_z0106.
  CLEAR: e_rm1wk_tm,   e_rm2wk_tm, l_time1, l_time2,
            l_time_diff1, l_time_diff2, l_1wk_t, l_2wk_t,
            l_1wk_start, l_1wk_end, l_2wk_start, l_2wk_end.


  IF i_wk_start IS NOT INITIAL AND i_wk_end IS NOT INITIAL AND
     i_zplwkhr_ty IS NOT INITIAL.
    CALL FUNCTION 'ZHR_52TM_CALC_WEEK_TIME'
      EXPORTING
        i_pernr                = i_pernr
        i_z52wktp             = i_z52wktp
        i_z52prsq          = i_z52prsq
        i_zplwkhr_ty   = i_zplwkhr_ty
        i_begda            = i_wk_start
        i_endda            = i_wk_end
*    I_OPT              =
*  IMPORTING
*    E_BEGDA            =
*    E_ENDDA            =
*    E_RETURN           =
      TABLES
          t_data             = t_z0106   .

    IF t_z0106[] IS NOT INITIAL.
      SORT t_daily.

      LOOP AT  t_z0106  .
        CLEAR: l_time_diff1.
        LOOP AT t_daily  WHERE datum BETWEEN t_z0106-begda AND t_z0106-endda.

          l_time1 = t_daily-zplwk_tm.
          l_time2 = l_time_diff1.

          CALL FUNCTION 'ZHR_SUM_TIME_N'
            EXPORTING
              time1    = l_time1
              time2    = l_time2
            IMPORTING
              time_sum = l_time_diff1.

          l_time1 = t_daily-zovradd_tm.
          l_time2 = l_time_diff1.

          CALL FUNCTION 'ZHR_SUM_TIME_N'
            EXPORTING
              time1    = l_time1
              time2    = l_time2
            IMPORTING
              time_sum = l_time_diff1.

        ENDLOOP.

        l_time1 = t_z0106-zoblwkhr.
        l_time2 = l_time_diff1.

        CALL FUNCTION 'ZHR_MINUS_TIME_N'
          EXPORTING
            time1    = l_time1
            time2    = l_time2
          IMPORTING
            time_dif = l_time_diff1.

        CASE t_z0106-zweeksq. " 주단위 근무시간 합계
          WHEN '01'.
            e_rm1wk_tm = l_time_diff1.
            IF l_time1 < l_time2.
              e_rm1wk_ov = '(초과)'.
            ENDIF.
          WHEN '02'.
            e_rm2wk_tm = l_time_diff1.
            IF l_time1 < l_time2.
              e_rm2wk_ov = '(초과)'.
            ENDIF.
        ENDCASE.

      ENDLOOP.

    ENDIF.
  ENDIF.

*---------------------------------------------------------------- 여기까지는 평일 / 휴일 똑같이 분리됨-----------------------
**** ---->>> 통상근로시간과 초과근로시간/휴일근무시간을 구분
  CHECK i_opt = 'X'.


** 통상근로시간 계산
  DATA l_mnhr TYPE zecnval.
  DATA: l_mnhr_t TYPE time,
            l_mnhr_s TYPE time,
            l_mnhr_e TYPE time.



  DATA: l_mn_sum TYPE stdaz,
             l_mn_sum_b TYPE stdaz.
  DATA: l_diff TYPE stdaz,
            l_diff2 TYPE stdaz.
  DATA: lt_d_time TYPE   ztshr0115 WITH HEADER LINE.
  DATA: l_time_tmp TYPE time,
            l_time_b TYPE time,
            l_time_e TYPE time.

  DATA: l_zbeguz TYPE zchar06,
            l_zenduz TYPE zchar06,
            l_zdiff TYPE zchar06.



  DATA: l_cnt TYPE i.
  DATA: l_tabix LIKE sy-tabix.
  DATA: l_const(10).

  CLEAR: l_cnt, l_tabix,l_zdiff, l_zbeguz,l_zenduz,l_diff, l_diff2.

** 통상근로시간 가져오기
** 해외출장자 ZTRPHR/ 그외 ZNORHR
  IF is_day-zgubun = 'T'.
    l_const = 'ZTRPHR'.  " TRIP의 TRP 같음...
  ELSE.
    l_const = 'ZNORHR'. " 노멀의 NOR 같음...
  ENDIF.
  SELECT SINGLE   zcnval INTO l_mnhr  " 필수 근로 시간 등의 세팅 값들...
       FROM zthr0101
      WHERE zconst =  l_const
      AND     begda <= is_day-datum
      AND     endda >= is_day-datum.

  CHECK sy-subrc = 0.

*ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ   여기를 주의 깊게 봐야 할듯...-----------------------------

  " 양일근로계산  2일 18시간으로 계산 후 초과근로 계산
  IF i_ngt = 'X' AND is_day-ztomo  <> ''. " 양일근로 중 익휴
    IF l_tmtyp_f = '1' AND l_tmtyp_l = '1'. " 양일 평일인겨우만
      l_mnhr = l_mnhr * 2.
    ENDIF.
  ENDIF.
* ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
  l_cnt = LINES( t_day_time ).


*** REGTP 정규근무시간/초과근무시간
****  TMTYP = 수당계산용 정규 /연장 /휴일

  LOOP AT t_day_time FROM 1 TO l_cnt.

    IF t_day_time-zgubun = 'A' AND t_day_time-days = '0'.   "  현재 조건 + 소정 근로가 채워지면 여기를 타도록.....
      CONTINUE.
    ENDIF.


    CHECK t_day_time-zyuhyung <> '03' AND "         교대조 대근
              t_day_time-zyuhyung <> '04'.         "         교대조 비번

    IF i_ngt = 'Y'. " 특근/철야/휴일...
      CLEAR: l_mn_sum,  l_tabix.
    ENDIF.

    ADD 1 TO l_tabix.
    l_time_b = t_day_time-zbegtm.
    l_time_e = t_day_time-zendtm.

    ADD t_day_time-stdaz TO l_mn_sum.

    IF l_mn_sum <= l_mnhr.  " 통상근로시간 보다 작으면 REGULAR
      t_day_time-regtp = 'N'.
      MODIFY t_day_time.
    ELSE.
      IF l_tabix = 1. " 처음 넘었을때
        l_diff  =  l_mn_sum -  l_mnhr .
      ELSE.
        l_diff  =  l_mnhr - l_mn_sum_b.
        t_day_time-regtp = 'M'.
        MODIFY t_day_time.
      ENDIF.

      CHECK l_diff > 0.

      PERFORM set_hour_to_time USING l_diff
                                                             l_time_tmp.


      " 종료시간 조정
      l_zbeguz = l_time_tmp.
      l_zenduz = t_day_time-zendtm.

      CALL FUNCTION 'ZHR_MINUS_TIME_N'
        EXPORTING
          time1    = l_zenduz
          time2    = l_zbeguz
        IMPORTING
          time_dif = l_zdiff.

      t_day_time-zendtm  = l_zdiff.

      " 휴게시간
      CLEAR l_index.
      DO 5 TIMES.

        ADD 1 TO l_index.

        CONCATENATE 't_day_time-ZPBEG' l_index INTO field.
        ASSIGN (field) TO <fs_i>.

        CONCATENATE 't_day_time-ZPEND' l_index INTO field.
        ASSIGN (field) TO <fs_e>.


        t_break-pbeg = <fs_i>.
        t_break-pend = <fs_e>.
        CLEAR l_sec.

        IF t_break-pbeg IS NOT INITIAL OR
           t_break-pend IS NOT INITIAL.
          CALL FUNCTION 'SWI_DURATION_DETERMINE'
            EXPORTING
              start_date = is_day-datum
              end_date   = is_day-datum
              start_time = t_break-pbeg
              end_time   = t_break-pend
            IMPORTING
              duration   = l_sec.

          t_break-punb = l_sec / 3600.
          APPEND t_break. CLEAR t_break.
        ENDIF.

      ENDDO.

      " 시간 확인
      DO 10 TIMES.

        CALL FUNCTION 'HR_PROPOSE_OVERTIME'
              EXPORTING
                beguz                     =  t_day_time-zbegtm
                enduz                      = t_day_time-zendtm
                vtken                      = ''
                stdaz                      = ''
                date                       = t_day_time-datum
                break_shift                = ''
             IMPORTING
*               BEGUZ_EXP                  =
*               ENDUZ_EXP                  =
*               VTKEN_EXP                  =
               stdaz_exp                  = l_stdaz
*               MESSAGE_OCCURED            =
              TABLES
                dayint                       = dayint
                daygen                     = daygen
                breaks                      = t_break
             EXCEPTIONS
               overtime_not_allowed       = 1
               error_break                = 2
               OTHERS                     = 3
                      .

        IF l_tabix = 1. " 처음 넘었을때
          l_diff2 = l_mnhr - l_stdaz  .
        ELSE.
          l_diff2 = l_diff - l_stdaz.
        ENDIF.


        IF l_diff2 > 0.
          " 종료시간 조정
          PERFORM set_hour_to_time USING l_diff2
                                                                l_time_tmp.


          " 종료시간 조정
          l_zbeguz = l_time_tmp.
          l_zenduz = t_day_time-zendtm.

          CALL FUNCTION 'ZHR_SUM_TIME_N'
            EXPORTING
              time1    = l_zenduz
              time2    = l_zbeguz
            IMPORTING
              time_sum = l_zdiff.

          t_day_time-zendtm  = l_zdiff.

        ELSEIF l_diff2 < 0.
          l_diff2 = l_diff2 * '-1'.

          " 종료시간 조정
          PERFORM set_hour_to_time USING l_diff2
                                                                l_time_tmp.

          " 종료시간 조정
          l_zbeguz = l_time_tmp.
          l_zenduz = t_day_time-zendtm.


          CALL FUNCTION 'ZHR_MINUS_TIME_N'
            EXPORTING
              time1    = l_zenduz
              time2    = l_zbeguz
            IMPORTING
              time_dif = l_zdiff.


          t_day_time-zendtm  = l_zdiff.

        ELSE.
          EXIT.
        ENDIF.
      ENDDO.


      t_day_time-regtp = 'N'.  " 정상근무
      t_day_time-stdaz = l_stdaz.
      PERFORM set_hour_to_time USING t_day_time-stdaz
                                                            t_day_time-zrlwk_tm .


      " 휴게시간
      PERFORM set_calc_break_time USING  t_day_time-datum
                                                                          t_day_time-zbegtm
                                                                          t_day_time-zendtm
                                                                          t_day_time-zrlwk_tm
                                                                         t_day_time-zpdwk_tm.

      MODIFY t_day_time.
*----------------------------------------------------- 여기까지 근무 시간 8시간만 저장
*      필수 근무시간 8시간 기준으로 자르는 지점
*----------------------------------------------------- 여기부터 근무 시간 이후 데이터

      t_day_time-zbegtm = t_day_time-zendtm.
      t_day_time-zendtm = l_time_e.
      t_day_time-regtp = 'M'. "초과근로


      CLEAR: l_stdaz .
      CALL FUNCTION 'HR_PROPOSE_OVERTIME'
               EXPORTING
                 beguz                     =  t_day_time-zbegtm
                 enduz                      = t_day_time-zendtm
                 vtken                      = ''
                 stdaz                      = ''
                 date                       = t_day_time-datum
                 break_shift                = ''
              IMPORTING
*               BEGUZ_EXP                  =
*               ENDUZ_EXP                  =
*               VTKEN_EXP                  =
                stdaz_exp                  = l_stdaz
*               MESSAGE_OCCURED            =
               TABLES
                 dayint                       = dayint
                 daygen                     = daygen
                 breaks                      = t_break
              EXCEPTIONS
                overtime_not_allowed       = 1
                error_break                = 2
                OTHERS                     = 3    .

      t_day_time-stdaz = l_stdaz.
      PERFORM set_hour_to_time USING t_day_time-stdaz
                                                             t_day_time-zrlwk_tm .


      " 휴게시간
      PERFORM set_calc_break_time USING  t_day_time-datum
                                                                          t_day_time-zbegtm
                                                                          t_day_time-zendtm
                                                                          t_day_time-zrlwk_tm
                                                                         t_day_time-zpdwk_tm.

*      " 실근로시간(휴게시간 고려하지 않음) - 2018.12.12 by erphr2
*      " 변경요청으로 주석처리함 - 2018.12.20 by erphr2
*      CLEAR l_sec.
*      CALL FUNCTION 'SWI_DURATION_DETERMINE'
*        EXPORTING
*          start_date = t_day_time-datum
*          end_date   = t_day_time-datum
*          start_time = t_day_time-zbegtm
*          end_time   = t_day_time-zendtm
*        IMPORTING
*          duration   = l_sec.
*
*      t_day_time-stdaz_a = l_sec / 3600.



      APPEND t_day_time.
*      여기까지가 하루를 기준으로 필수 / 연장을 나누어서 저장
    ENDIF.

    l_mn_sum_b = l_mn_sum.
    CLEAR t_day_time.
  ENDLOOP.



*********통상근로 / 교대근로 구분



  LOOP AT t_day_time.
    t_day_time-tmtyp =  t_day_time-regtp.
    "통상근로자


    IF t_day_time-zgubun <> 'C' .

      IF t_day_time-days = '0'. " 휴일인경우
        t_day_time-regtp = 'M'. "초과근로시간
        t_day_time-tmtyp = 'H'.    "휴일근로 시간

      ELSEIF  i_ngt = 'Z'. " 퇴출은 모두 초과근로
        t_day_time-regtp = 'M'. "초과근로시간
        t_day_time-tmtyp = 'M'.    "초과근로 시간
      ENDIF.


    ELSE. "교대조
      IF t_day_time-days = '0'. " 휴일인경우
        CASE t_day_time-zyuhyung.
          WHEN '03' OR '04'.   "대근/비번
            t_day_time-regtp = 'M'.    "초과근로시간
            t_day_time-tmtyp = 'H'.    "휴일근로 시간
          WHEN '01' OR '02' OR '05'.   "철야/휴일. 교대추가.201490603. 임재하.
            t_day_time-tmtyp = 'H'.    "휴일근로 시간
        ENDCASE.
      ELSE. " 평일  대근/비번   이면 모두 초과
        CASE t_day_time-zyuhyung.
          WHEN '03' OR '04'.  " 대근/비번
            t_day_time-regtp = 'M'.
            t_day_time-tmtyp = 'M'.
        ENDCASE.

      ENDIF.
    ENDIF.
    " 통상 첫날 휴일 두째날 평일이면 두째날은 연장근로
    IF t_day_time-zgubun <> 'C' AND i_ngt = '' AND l_tmtyp_f = '0'
           AND t_day_time-days = '1'.
      t_day_time-tmtyp = 'M'.
      t_day_time-regtp = 'M'.
    ENDIF.

    MODIFY t_day_time. CLEAR t_day_time.
  ENDLOOP.



*** <<---
  SORT t_day_time.

ENDFUNCTION.
