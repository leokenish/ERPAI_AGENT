FUNCTION ZHR_52TM_CHECK_INPUT_DATA_M.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  IMPORTING
*"     VALUE(I_MODE) TYPE  CHAR01
*"     VALUE(I_ACTION) TYPE  SYUCOMM
*"     VALUE(I_WKTYPE) TYPE  ZEWKTYPE
*"     VALUE(I_WKTOT) TYPE  CHAR6
*"     VALUE(I_WKREG) TYPE  CHAR05
*"     VALUE(I_ATIME) TYPE  CHAR05
*"     VALUE(I_WKOTS) TYPE  CHAR05
*"     VALUE(IS_ZTHRBS01) TYPE  ZTHRBS01
*"  EXPORTING
*"     VALUE(E_CODE) TYPE  CHAR03
*"     VALUE(E_TEXT) TYPE  CHAR200
*"----------------------------------------------------------------------
  DATA: lv_min01 TYPE i,
        lv_min02 TYPE i,
        lv_min03 TYPE i,
        lv_min04 TYPE i,
        lv_min05 TYPE i.

  DATA: l_zoblwk_m TYPE i,
         l_zpubhwk_m TYPE i,
         l_zpoverwk_m TYPE i,
         l_ztotwk_m TYPE i,
         l_zrlwk_m TYPE i,
         l_zrlovrwk_m TYPE i,
         l_zrestwk_m TYPE i,
         l_zgubn TYPE i.

  DATA: lv_code(3) TYPE c.
  DATA: lv_text(200) TYPE c.

  DATA: ls_zthrbs01 TYPE  zthrbs01.
  DATA: ls_zthrbs17 TYPE  zthrbs17.

  CLEAR: ls_zthrbs01, lv_min01, lv_min02, lv_min03, lv_min04, lv_min05.

  MOVE-CORRESPONDING is_zthrbs01 TO ls_zthrbs01.

  IF i_wktype+0(1) EQ 'N'. "통상근무
    CLEAR: ls_zthrbs01-zyuhyung.
  ELSE. "근무형태가 교대근무인경우 교대근무 유형을 설정을 한다.
    if i_wktype is not INITIAL.
    ls_zthrbs01-zyuhyung = i_wktype.
    REPLACE 'S' IN ls_zthrbs01-zyuhyung WITH '0'.
    CONDENSE ls_zthrbs01-zyuhyung.
    endif.
  ENDIF.

*...// 1. 시간외 시스템 사용가능한 일자 Check.
  PERFORM check_input_date USING ls_zthrbs01-zgubun   "신청구분
                                 ls_zthrbs01-pernr    "사번
                                 ls_zthrbs01-znal     "근로일
                                 ls_zthrbs01-persk    "사원하위그룹
                                 ls_zthrbs01-ztomo    "익일 Flag
*                                  is_zthrbs01
                        CHANGING e_code
                                 e_text.
  IF e_code+0(1) EQ 'E'.
    RETURN.
  ELSEIF e_code+0(1) EQ 'I'.
    lv_code = e_code.
    lv_text = e_text.
  ENDIF.

*[19.02.21]*휴게시간 팝업으로 인한 수정
*****...// 2. 저장->필수 입력사항 점검.
****  PERFORM check_input_data USING i_action
****                                 ls_zthrbs01-zgubun   "신청구분
****                                 ls_zthrbs01-znal     "근로일
****                                 ls_zthrbs01-zbegt    "시작시간
****                                 ls_zthrbs01-zendt    "종료시간
****                                 ls_zthrbs01-zktype   "교대형태
****                                 ls_zthrbs01-zyuhyung "근무유형
****                                 ls_zthrbs01-ztomo    "익일 Flag
****                                 ls_zthrbs01-ztext    "업무내용
****                                 ls_zthrbs01-zcope    "결재자이름
****                                 ls_zthrbs01-zcosa    "결재자사번
****                                 ls_zthrbs01-zcid     "결재자 ID
*****                                 is_zthrbs01
****                        CHANGING e_code
****                                 e_text.
****  IF e_code+0(1) = 'E'.
****    RETURN.
****  ENDIF.

*...// 3. 입력가능한 근로일 Check.
  PERFORM check_wkdate USING ls_zthrbs01-pernr
                             ls_zthrbs01-persk
                             ls_zthrbs01-orgeh
                             ls_zthrbs01-vdsk1
                             ls_zthrbs01-znal
                             ls_zthrbs01-ztomo
                            is_zthrbs01-znurak
                    CHANGING e_code
                             e_text.
  IF e_code+0(1) = 'E'.
    RETURN.
  ENDIF.

*...// 4. 입력가능한 시간 Check.
  PERFORM check_wktime
    USING ls_zthrbs01-zgubun
          ls_zthrbs01-znal
          ls_zthrbs01-zbegt
          ls_zthrbs01-zendt
          ls_zthrbs01-ztomo
          ls_zthrbs01-ztomoh
          ls_zthrbs01-zyuhyung
*          ls_zthrbs01-zdangj   "당직후 근무 제외
          ls_zthrbs01-ztoich
          ls_zthrbs01-zdaeh
          ls_zthrbs01-zyoil
          ls_zthrbs01-zemcwk
*         is_zthrbs01
 CHANGING e_code
          e_text.
  IF e_code+0(1) = 'E'.
    RETURN.
  ENDIF.

*--------------------------------------------------------------------*
" (Mobile) 근로시간 변경시,  휴게시간 체크로직 제외
"          단, 저장 or 결재상신시, 체크한다!!
*--------------------------------------------------------------------*
**...// 휴게시간 Check
*  PERFORM check_bktime
*    USING ls_zthrbs01-ztomo
*          ls_zthrbs01-zgubun
*          ls_zthrbs01-zyuhyung
*          ls_zthrbs01-zbegt  ls_zthrbs01-zendt
*          ls_zthrbs01-zpbeg1 ls_zthrbs01-zpbtm1
*          ls_zthrbs01-zpend1 ls_zthrbs01-zpetm1
*          ls_zthrbs01-zpbeg2 ls_zthrbs01-zpbtm2
*          ls_zthrbs01-zpend2 ls_zthrbs01-zpetm2
*          ls_zthrbs01-zpbeg3 ls_zthrbs01-zpbtm3
*          ls_zthrbs01-zpend3 ls_zthrbs01-zpetm3
*          ls_zthrbs01-zpbeg4 ls_zthrbs01-zpbtm4
*          ls_zthrbs01-zpend4 ls_zthrbs01-zpetm4
*          ls_zthrbs01-zpbeg5 ls_zthrbs01-zpbtm5
*          ls_zthrbs01-zpend5 ls_zthrbs01-zpetm5
* CHANGING e_code
*          e_text.
*  IF e_code+0(1) = 'E'.
*    RETURN.
*  ENDIF.

*...// 5. 예외자 Check
  PERFORM check_excep USING ls_zthrbs01-zgubun
                            ls_zthrbs01-pernr
                            ls_zthrbs01-znal
                      CHANGING e_code
                               e_text.
  IF e_code+0(1) = 'E'.
    RETURN.
  ENDIF.


*...// " 성능향상을 위해 저장 시점에서만 CHECK.
  CHECK i_action EQ 'SAVE'.

*...// 금액 확인.
  IF ls_zthrbs01-zmoney IS INITIAL AND
     ( ls_zthrbs01-zgubun NE 'F' AND ls_zthrbs01-zgubun NE 'G' ) .
    e_code = 'E22'.
    e_text = text-e22.
    RETURN.
  ENDIF.

*...// 부장대휴, 출제위원인 경우 반드시 대휴가 있어야 한다.
  IF ls_zthrbs01-zgubun EQ 'F' OR ls_zthrbs01-zgubun EQ 'G'.
    IF ls_zthrbs01-zdaeh IS INITIAL.
    e_code = 'E88'.
    e_text = text-e88.
    RETURN.
    ENDIF.
  ENDIF.
*...// 재난 FLAG 가 'X'가 아닌경우 초과근로 시간이 추가근로가능시간를 초과할 수 없다.
  IF ls_zthrbs01-zemcwk IS INITIAL.


   " 당일초과근로시간

   data: l_tmp_time(6) type n.
    DATA: L_ZCNVAL TYPE ZECNVAL,
             L_68DT TYPE DATUM.
   DATA: L_68CHK .
   DATA : L_DAYNR LIKE  HRVSCHED-DAYNR.
   DATA:  L_TIME1 TYPE ZCHAR06,
              L_TIME2 TYPE ZCHAR06,
              L_DIFF TYPE ZCHAR06.
   data: lv_min_t type i,
           lv_min_rt type i.

   DATA: l_maxhr TYPE ZeMAXHR.
   DATA: l_day_maxhr TYPE ZeMAXHR.
   DATA: l_week_maxhr TYPE ZeMAXHR.
   DATA: l_maxhr_m(6) TYPE n.
   DATA: l_day_maxhr_m(6) TYPE n.
   DATA: l_week_maxhr_m(6) TYPE n.

   CLEAR: L_ZCNVAL, L_68DT, L_68CHK, L_TIME1, L_TIME2, L_DIFF ,  lv_min_rt,  lv_min_t.

   l_tmp_time = ls_zthrbs01-ze_time. " 당일 초과시간

* 총 근무시간

    PERFORM convert_min
      USING i_wktot
   CHANGING lv_min04.

  IF ls_zthrbs01-znal < '20201130'.
* 근무시간
    PERFORM convert_min
      USING i_wkreg
   CHANGING lv_min05.

    SELECT SINGLE ZCNVAL INTO L_ZCNVAL
          FROM ZTHR0101
        WHERE ZCONST = 'Z68VLD'
        AND     BEGDA <= SY-DATUM
        AND    ENDDA >= SY-DATUM.

       IF SY-SUBRC = 0.
            L_68DT  = L_ZCNVAL(8).
            L_68CHK = 'X'.
       ENDIF.

     IF L_68DT >= LS_ZTHRBS01-ZNAL.
             CALL FUNCTION 'RH_GET_DATE_DAYNAME'
               EXPORTING
                 langu                     = SY-LANGU
                 date                      = LS_ZTHRBS01-ZNAL
*                CALID                     =
              IMPORTING
                DAYNR                     = L_DAYNR.

             IF L_DAYNR = '6' OR L_DAYNR = '7'. " 토/일
                  IF ls_zthrbs01-ze_time <= '080000'.
                          l_tmp_time = '000000'.
                          lv_min05 = lv_min05 + ( ( ls_zthrbs01-ze_time+0(2) * 60 ) + ls_zthrbs01-ze_time+2(2) ).
                  ELSE.
                          lv_min05 = lv_min05  +  ( 8 * 60 ).  "8 시간은 근로시간에

                         L_TIME1 = ls_zthrbs01-ze_time.
                         L_TIME2 = '080000'.
                         CALL FUNCTION 'ZHR_MINUS_TIME_N'
                           EXPORTING
                             time1          = L_TIME1
                             time2          = L_TIME2
                          IMPORTING
                            TIME_DIF       = L_DIFF  .

                          l_tmp_time = l_diff. "초과시간
                  ENDIF.
             ENDIF.
        ENDIF.


   " 당일 연장시간
    PERFORM convert_min
      USING  l_tmp_time
   CHANGING lv_min02.

    " 연장근로가능시간
    PERFORM convert_min
      USING i_atime
   CHANGING lv_min01.

    " 당일제외 주간초과근로시가 합계
    PERFORM convert_min
      USING I_WKOTS
   CHANGING lv_min03.

* 연장가능 시간 체크 " 수정 xa30752 2019.12.03
   lv_min_t = lv_min03 + lv_min02..
   ELSE. " 신규 연장근로시간 xa30752 2020.03.01
*- 근무시간
  CALL FUNCTION 'ZHR_52TM_SET_DEFAULT_TIME'
    EXPORTING
      i_pernr     = ls_zthrbs01-pernr
      i_znal      = ls_zthrbs01-znal
      i_zgubun    = ls_zthrbs01-zgubun
      i_seqnr     = ls_zthrbs01-seqnr
      i_mode      = ''
    IMPORTING
      e_wktim01_m = l_zoblwk_m   " 필수근로시간(분)
      e_wktim02_m = l_zpubhwk_m  " 주중공휴일시간(분)
      e_wktim03_m = l_zpoverwk_m " 연장근로가능시간(분)
      e_wktim04_m = l_ztotwk_m   " 총근로시간(분)
      e_wktim05_m = l_zrlwk_m    " 근로시간(분)
      e_wktim06_m = l_zrlovrwk_m" 연장근로시간(분)
      e_zgubn = l_zgubn.

   " 당일 연장시간
*    PERFORM convert_min
*      USING  l_tmp_time
*   CHANGING lv_min02.
   IF l_zgubn = '2'.

   CALL FUNCTION 'RH_GET_DATE_DAYNAME'
      EXPORTING
        langu                     = sy-langu
        date                      = ls_zthrbs01-znal
      IMPORTING
        DAYNR                     = l_daynr.

   IF l_daynr = '6' OR l_daynr = '7'. " 토/일
      IF ls_zthrbs01-ze_time <= '080000'.
          ls_zthrbs01-ze_time = '000000'.

      ELSE.
          l_time1 = ls_zthrbs01-ze_time.
          l_time2 = '080000'.

          CALL FUNCTION 'ZHR_MINUS_TIME_N'
               EXPORTING
                   time1          = l_time1
                   time2          = l_time2
                IMPORTING
                   time_dif      = l_diff.

           ls_zthrbs01-ze_time = l_diff. "초과시간
       ENDIF.
   ENDIF.
   ENDIF.

    PERFORM convert_min " xa30752 2020.10.29
      USING  ls_zthrbs01-ze_time
   CHANGING lv_min02.

    " 당일제외 주간초과근로시간 합계
    PERFORM convert_min
      USING I_WKOTS
   CHANGING lv_min03.

    IF i_mode <> 'M'. " 저장 " xa30752 2020.06.22
      lv_min_rt = l_zrlovrwk_m + lv_min02.
    ELSE.  " i_mode = 'M' 저장 후 결재상신 할 경우
*      lv_min_rt = l_zrlovrwk_m.
      lv_min_rt =  lv_min02 + lv_min03. " xa30752 2020.10.29
    ENDIF.

   ENDIF.


* 총근로시간
  IF ls_zthrbs01-zgubun <>'C'.
    IF ls_zthrbs01-znal < '20201130'.
      lv_min_rt = lv_min_t + lv_min05.
    ENDIF.
  ELSE. "교대근무의 경우
    "20190917.임재하.
    "get_remain_day_work_time에서 당일 워크스케쥴 시간을 더해주는데
    "이 때문에 화면에서 입력받은 시간과 중복차감되는 현상이 발생함.
    "이를 방지하기위해, 입력한 시간이 워크스케쥴 시간과 동일하면
    "화면에서 입력받은 내용을 이미 반영하였다고 보고 계산하지 않음.

    DATA: LS_SCHEDULE LIKE ZTHRWORKSCHEDULE.

    SELECT SINGLE *
           INTO LS_SCHEDULE
           FROM ZTHRWORKSCHEDULE
          WHERE PERNR  EQ ls_zthrbs01-pernr
            AND WDATE  EQ ls_zthrbs01-znal
            AND W_CODE EQ '02'. "교대근무

    "시작/종료 시간이 동일 -> 스케쥴시간이 들어온걸로 보고, 화면에 입력된 내용은 더하지 않음.
    IF LS_SCHEDULE-BEGT = ls_zthrbs01-ZBEGT AND
       LS_SCHEDULE-ENDT = ls_zthrbs01-ZENDT.
      lv_min_rt = lv_min04.
    ELSE.
      "교대근무의 경우
      "교대근무는 초과근무가 0으로 표시됨.
      "총근로시간에 당일 총근로시간을 더한게 체크하려는 시간이 됨.
      lv_min_rt = lv_min04
                + ( ( ls_zthrbs01-za_time+0(2) * 60 ) + ls_zthrbs01-za_time+2(2) ).
    ENDIF.
  ENDIF.



   SELECT * INTO ls_zthrbs17 FROM zthrbs17 " 52시간 입력 제한 예외자인지 check (2019.10.30 xa30752 추가)
      WHERE pernr = ls_zthrbs01-pernr
      AND begda <= ls_zthrbs01-znal
      AND endda >= ls_zthrbs01-znal.

    ENDSELECT.

   IF sy-subrc <> 0. " 예외자가 아니라면 주단위 근로시간 체크하여 입력 차단

   IF ls_zthrbs01-znal < '20201130'.
" 평일 일 최대 근무시간 체크 "  평일 연장 12시간 초과 불가
   IF ls_zthrbs01-zyoil <> '휴' AND ls_zthrbs01-zemcwk <> 'X' AND l_daynr <> '6' AND l_daynr <> '7'.
      CLEAR l_day_maxhr.
      SELECT SINGLE ZMAXHR INTO l_day_maxhr " 일 최대 연장근로  " 12시간
         FROM zthr0102
       WHERE z52wktp = '0010' " 통상으로 처리
          AND ZWKHR_TYPE  = '01'
          AND  begda <= ls_zthrbs01-znal
          AND  endda =>  ls_zthrbs01-znal.

     IF l_day_maxhr IS NOT INITIAL.
       l_day_maxhr_m = l_day_maxhr(2) * 60.
       IF lv_min02 > l_day_maxhr_m.
            e_code = 'E85'(005).
            e_text = text-e94.
            RETURN.

       ENDIF.
    ENDIF.
  ENDIF.

* 주 총 근무시간 체크 " 주 총 근무시간 52시간 초과 불가
   CLEAR l_maxhr.
   SELECT SINGLE ZMAXHR INTO l_maxhr " 주 최대 근로시간 " 52시간
       FROM zthr0102
     WHERE z52wktp = '0010' " 통상으로 처리
        AND ZWKHR_TYPE  = '02'
        AND  begda <= ls_zthrbs01-znal
        AND  endda =>  ls_zthrbs01-znal.

    IF l_maxhr IS NOT INITIAL.
      l_maxhr_m = l_maxhr(2) * 60.
*      lv_min_rt = lv_min_rt - lv_min01.
       IF lv_min_rt > l_maxhr_m.
          e_code = 'E85'.
          e_text = text-e92.
          RETURN.

       ENDIF.
    ENDIF.

   ELSE.  " 신규 연장근로시간 xa30752 2020.03.01
* 주 총 근무시간 체크 " 주 총 근무시간 52시간 초과 불가
   CLEAR l_week_maxhr.
   SELECT SINGLE ZMAXHR INTO l_week_maxhr " 주 최대 연장 근로시간 " 12시간
       FROM zthr0102
     WHERE z52wktp = '0010' " 통상으로 처리
        AND ZWKHR_TYPE  = '01'
        AND  begda <= ls_zthrbs01-znal
        AND  endda =>  ls_zthrbs01-znal.

    IF l_week_maxhr IS NOT INITIAL.
       l_week_maxhr_m+0(3) = l_week_maxhr(2) * 60.
       IF lv_min_rt > l_week_maxhr_m+0(3).
          e_code = 'E85'.
          e_text = text-e92.
          RETURN.

       ENDIF.
    ENDIF.
   ENDIF.

   ENDIF.
 ENDIF.

*....// 연수중 입력 CHECK
  PERFORM check_training_data USING ls_zthrbs01-pernr
                                    ls_zthrbs01-znal
                                    ls_zthrbs01-ztomo
                           CHANGING e_code
                                    e_text.
  IF e_code+0(1) = 'E'.
    RETURN.
  ENDIF.

  IF ls_zthrbs01-znal GE '20110701' OR sy-datum GE '20110701'.
    "팀장급이상 대휴 신청은 해외출장 CHECK 제외(2011.12.19)
    IF  ls_zthrbs01-zgubun NE 'F'.
      PERFORM check_trip_data_n USING ls_zthrbs01-zgubun
                                      ls_zthrbs01-pernr
                                      ls_zthrbs01-znal        " 근무일.
                                      ls_zthrbs01-ztomo
                             CHANGING e_code
                                      e_text.
    ENDIF.
  ELSE.
    IF ls_zthrbs01-persk NE 'D6'.
      PERFORM check_trip_data USING ls_zthrbs01-pernr
                                    ls_zthrbs01-znal
                                    ls_zthrbs01-ztomo
                           CHANGING e_code
                                    e_text.
    ENDIF.
  ENDIF.
  IF e_code+0(1) = 'E'.
    RETURN.
  ENDIF.

  PERFORM check_absence_data USING ls_zthrbs01-pernr
                                   ls_zthrbs01-znal
                                   ls_zthrbs01-ztomo
                                   ls_zthrbs01-zgubun
                          CHANGING e_code
                                   e_text.

  IF e_code+0(1) = 'E'.
    RETURN.
  ELSE.
* xa31535 20180514 수정
* 익휴생성일에 시간외 신청 불가능하도록 수정.
    PERFORM check_nextholiday_data USING ls_zthrbs01-pernr
                                         ls_zthrbs01-znal
                                         ls_zthrbs01-ztoich
                                CHANGING e_code
                                         e_text.

    IF e_code+0(1) = 'E'.
      RETURN.
    ENDIF.
  ENDIF.

*...// 시간외시간 중복여부 및 입력제한 점검. ls_zthrbs01-
  PERFORM check_overtime_data USING ls_zthrbs01-persk
                                    ls_zthrbs01-pernr
                                    ls_zthrbs01-rdate
                                    ls_zthrbs01-seqnr
                                    ls_zthrbs01-znal
                                    ls_zthrbs01-zbegt
                                    ls_zthrbs01-zendt
                                    ls_zthrbs01-ztomo
                                    ls_zthrbs01-zyoil
                                    ls_zthrbs01-zgubun
                                    ls_zthrbs01-zdangj
                                    ls_zthrbs01-ztomoh
                                    ls_zthrbs01-ztoich
                                    i_mode
                           CHANGING e_code
                                    e_text.
  IF e_code+0(1) = 'E'.
    RETURN.
  ENDIF.

"저장 할때만 적용
  IF lv_code IS NOT INITIAL.
     e_code = lv_code.
     e_text = lv_text.
  ENDIF.

ENDFUNCTION.
