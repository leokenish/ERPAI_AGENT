*----------------------------------------------------------------------*
***INCLUDE LZHR008_2F03 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      FORM  CHECK_TRAINING_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_T_ERROR  TEXT
*      -->P_IS_ZTHRBS01_PERNR  TEXT
*      -->P_IS_ZTHRBS01_ZNAL  TEXT
*      -->P_IS_ZTHRBS01_ZTOMO  TEXT
*      <--P_E_CODE  TEXT
*      <--P_E_TEXT  TEXT
*----------------------------------------------------------------------*
FORM check_training_data USING p_pernr
                               p_znal
                               p_ztomo
                      CHANGING c_code
                               c_text.
  DATA: lv_code(3)   TYPE c,
        lv_text(200) TYPE c,
        ls_error     TYPE zsh_error,
        lt_error     TYPE TABLE OF zsh_error.

* 연수중 입력제한.
  CALL FUNCTION 'ZHR_CHECK_TRAINING_DATA_N'
    EXPORTING
      pernr      = p_pernr
      znal       = p_znal
      ztomo      = p_ztomo
    IMPORTING
      error_code = lv_code
      error_text = lv_text
    TABLES
      it_error   = lt_error.

  CHECK LINES( lt_error ) > 0.

  READ TABLE lt_error INTO ls_error WITH KEY code+0(1) = 'E'.
  IF sy-subrc EQ 0.
    c_code = ls_error-code.
    c_text = ls_error-text.
  ELSE.
    READ TABLE lt_error INTO ls_error INDEX 1.
    c_code = ls_error-code.
    c_text = ls_error-text.
  ENDIF.
ENDFORM.                    " CHECK_TRAINING_DATA
*&---------------------------------------------------------------------*
*&      FORM  CHECK_TRIP_WARNING
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_T_ERROR  TEXT
*      -->P_IS_ZTHRBS01  TEXT
*      <--P_E_CODE  TEXT
*      <--P_E_TEXT  TEXT
*----------------------------------------------------------------------*
FORM check_trip_warning USING p_pernr
                              p_znal
                              p_ztomo
*                              PS_ZTHRBS01 STRUCTURE ZTHRBS01
                     CHANGING c_code
                              c_text.

  DATA : lv_begda   LIKE sy-datum,
         lv_endda   LIKE sy-datum,
         lv_lines   TYPE i,
         ls_zhrt002 TYPE zhrt002.

*...// 해외출장자 내역 CHECK
  DATA : BEGIN OF ls_trip,
           pernr     LIKE pa0001-pernr,
           ename     LIKE pa0001-ename,
           sdate     LIKE zhrt001-sdate,    " 신청일자
           app_no    LIKE zhrt001-app_no,
           seq_no    LIKE zhrt001-seq_no,
           bdate     LIKE zhrt001-bdate,
           edate     LIKE zhrt001-edate,
           zbdate    LIKE zhrt001-bdate,  " 중복확인용.
           zedate    LIKE zhrt001-edate,  " 중복확인용.
           term      LIKE zhrt001-term,
           zterm     TYPE i,              " 출장기간-계산
           c_code    LIKE zhrt001-c_code, " 출장구분=1(국내),2(국외)
           t_name    LIKE zhrt001-t_name, " 출장분류
           zctnm     LIKE zhrt001-zctnm,  " 출장지
           zctx1     LIKE zhrt001-zctx1,  " 출장내역
           zttot     LIKE zhrt002-zttot,
           zttot_krw LIKE bsik-dmbtr,
           waers     LIKE bsik-waers,
  END OF ls_trip,
         lt_trip LIKE TABLE OF ls_trip.

  CLEAR: c_code, c_text.

*...// 근무일자를 시작일자로 설정.
  lv_begda = p_znal.        " 근무일.

*...// 익일 CHECK에 따라 종료일 설정.
  IF p_ztomo IS INITIAL.   " 익일.
    lv_endda = p_znal.
  ELSE.
    lv_endda = p_znal + 1.
  ENDIF.

*...// 출장 시작일/종료일에 시간외 신청한 내역인지 확인후
  SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_trip
           FROM zhrt001 AS a INNER JOIN zhrt002 AS b
             ON a~sdate  = b~sdate
            AND a~app_no = b~app_no
            AND a~seq_no = b~seq_no
          WHERE ( ( a~bdate = lv_begda OR a~edate = lv_begda ) OR
                  ( a~bdate = lv_endda OR a~edate = lv_endda )
                )
            AND a~c_code EQ '2'                " 해외출장
            AND b~pernr  EQ p_pernr  " 사번
            AND b~zstat  EQ 'A'                " 승인건만
            AND b~c_flag NE 'X'                " 변경신청 FLAG
            AND b~zcanc  NE 'X'.               " 출장취소

  SORT lt_trip BY pernr bdate edate.

* 변경/취소신청->원건삭제(C_FLAG='X')->간혹 누락표시된 건 존재함.
* 예) 운영-> 16946, 20060419~20060426 취소신청건.
  LOOP AT lt_trip INTO ls_trip.
    SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_zhrt002
      FROM zhrt002
     WHERE pernr    EQ ls_trip-pernr
       AND c_sdate  EQ ls_trip-sdate
       AND c_app_no EQ ls_trip-app_no
       AND c_seq_no EQ ls_trip-seq_no
       AND  zcanc = ''
       AND zstat    EQ 'A'.

    IF sy-subrc = 0.
      DELETE lt_trip FROM ls_trip. CLEAR ls_trip.
    ENDIF.
  ENDLOOP.

  DESCRIBE TABLE lt_trip LINES lv_lines.

  DATA: rol_count TYPE i.
  CLEAR: rol_count.
  SELECT COUNT(*) FROM agr_users INTO rol_count WHERE agr_name = 'MRHR300_1' AND uname = sy-uname AND from_dat <= sy-datum AND to_dat >= sy-datum.

  IF rol_count > 0. " 관리자의 경우 해외출장 시작일, 종료일에 시간외 입력 가능하도록 (요청 인사운영부 김승훈 2019.05.03 by xa30752)

  ELSE.
    IF lv_lines > 0.
      "c_code = 'E52'.  "20230425-나구엽-단순한 알림인데 에러 처리 하면 안됨
      c_code = 'I52'.
      c_text = text-e52.
    ENDIF.

  ENDIF.

ENDFORM.                    " CHECK_TRIP_WARNING
*&---------------------------------------------------------------------*
*&      FORM  CHECK_INPUT_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_IS_ZTHRBS01_ZNAL  TEXT
*      -->P_IS_ZTHRBS01_ZBEGT  TEXT
*      -->P_IS_ZTHRBS01_ZENDT  TEXT
*      -->P_IS_ZTHRBS01_ZTOMO  TEXT
*      -->P_IS_ZTHRBS01_ZGUBUN  TEXT
*      -->P_IS_ZTHRBS01_ZKTYPE  TEXT
*      -->P_IS_ZTHRBS01_ZYUHYUNG  TEXT
*      -->P_IS_ZTHRBS01_ZTEXT  TEXT
*      -->P_IS_ZTHRBS01_ZCOPE  TEXT
*      -->P_IS_ZTHRBS01_ZCOSA  TEXT
*      -->P_IS_ZTHRBS01_ZCID  TEXT
*      -->P_I_ACTION  TEXT
*      <--P_E_CODE  TEXT
*      <--P_E_TEXT  TEXT
*----------------------------------------------------------------------*
FORM check_input_data  USING p_action
                             p_zgubun
                             p_znal
                             p_zbegt
                             p_zendt
                             p_zktype
                             p_zyuhyung
                             p_ztomo
                             p_ztext
                             p_zcope
                             p_zcosa
                             p_zcid
*                             PS_ZTHRBS01 STRUCTURE ZTHRBS01
                    CHANGING c_code
                             c_text.

  DATA: l_holiday.
  DATA: l_date TYPE datum.

* 필수 입력사항 점검.
  IF p_zgubun IS INITIAL.
    c_code = 'E53'.
    CONCATENATE '시간외 신청구분은'
                text-e53
                INTO c_text SEPARATED BY space.
    RETURN.
  ENDIF.

* 1) 근무일->ZNAL.
  IF p_znal IS INITIAL OR
     p_znal = '00000000'.
    c_code = 'E53'.
    CONCATENATE '(근무일)은'
                text-e53
                INTO c_text SEPARATED BY space.
    RETURN.
  ENDIF.

* 2) 시작시간/종료시간->ZBEGT,ZENDT.
  IF p_zbegt = ''.
    c_code = 'E53'.
    CONCATENATE '(시작시간)은'
                text-e53
                INTO c_text SEPARATED BY space.
    RETURN.
  ENDIF.

  IF p_zendt = ''.
    c_code = 'E53'.
    CONCATENATE '(종료시간)은'
                text-e53
                INTO c_text SEPARATED BY space.
    RETURN.
  ENDIF.

* 3) 교대근무->교대형태(ZKTYPE),교대근무유형(ZYUHYUNG).
  IF p_zgubun = '2' OR p_zgubun = 'C'.
    CLEAR l_holiday.

    CASE p_zyuhyung.
*     1. 휴일 근로 신청
*         시작일 종료일 모두 휴일인 경우만 가능
      WHEN '02'.
        CALL FUNCTION 'ZHR_GET_DAY_DATA'
          EXPORTING
            znal    = p_znal
          IMPORTING
            holiday = l_holiday.

        IF l_holiday IS INITIAL.
          c_code = 'E73'.
          c_text = text-e73.
          RETURN.
        ENDIF.

        IF p_ztomo = 'X'.
          l_date = p_znal + 1.

          CALL FUNCTION 'ZHR_GET_DAY_DATA'
            EXPORTING
              znal    = l_date
            IMPORTING
              holiday = l_holiday.

          IF l_holiday IS INITIAL.
            c_code = 'E73'.
            c_text = text-e73.
            RETURN.
          ENDIF.
        ENDIF.
    ENDCASE.
  ENDIF.
*  IF p_zgubun = '2' OR p_zgubun = 'C'.
*    IF p_zktype IS INITIAL.
*      c_code = 'E53'.
*      CONCATENATE '(교대형태)는'
*                  text-e53
*                  INTO c_text SEPARATED BY space.
*      RETURN.
*    ENDIF.
*    IF p_zyuhyung IS INITIAL.
*      c_code = 'E53'.
*      CONCATENATE '(근무유형)은'
*                  text-e53
*                  INTO c_text SEPARATED BY space.
*      RETURN.
*    ENDIF.
*  ENDIF.

* 4) 입력정보 유효성점검->시작/종료시간,등급정보.
  IF p_action = 'SAVE'.      " 저장 모드시.
    IF p_zbegt = '240000'.
      c_code = 'E54'.
      CONCATENATE '(시작시간)이'
                  text-e54
                  INTO c_text SEPARATED BY space.
      RETURN.
    ENDIF.
    IF p_zendt = '000000'.
      c_code = 'E54'.
      CONCATENATE '(종료시간)이'
                  text-e54
                  INTO c_text SEPARATED BY space.
      RETURN.
    ENDIF.
    IF p_zbegt > p_zendt AND
       p_ztomo IS INITIAL.
      c_code = 'E55'.
      c_text = text-e55.
      RETURN.
    ENDIF.

* appr로 이동 [19.02.21]
** 5) 업무내용(ZTEXT).
*    IF p_ztext IS INITIAL.
*      c_code = 'E53'.
*      CONCATENATE '(업무내용)은'
*                  text-e53
*                  INTO c_text SEPARATED BY space.
*      RETURN.
*    ENDIF.
*
** 6) 결재자 지정.
*    IF p_zcope IS INITIAL OR
*       p_zcosa IS INITIAL OR
*       p_zcid  IS INITIAL.
*      c_code = 'E53'.
*      CONCATENATE '(결재자)는'
*                  text-e53
*                  INTO c_text SEPARATED BY space.
*      RETURN.
*    ENDIF.
  ELSE.
*   5) 업무내용(ZTEXT).
    IF p_ztext IS INITIAL.
      c_code = 'E53'.
      CONCATENATE '(업무내용)은'
                  text-e53
                  INTO c_text SEPARATED BY space.
      RETURN.
    ENDIF.

*   6) 결재자 지정.
    IF p_zcope IS INITIAL OR
       p_zcosa IS INITIAL OR
       p_zcid  IS INITIAL.
      c_code = 'E53'.
      CONCATENATE '(결재자)는'
                  text-e53
                  INTO c_text SEPARATED BY space.
      RETURN.
    ENDIF.
  ENDIF.
ENDFORM.                    " CHECK_INPUT_DATA
*&---------------------------------------------------------------------*
*&      FORM  CHECK_INPUT_DATE
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_T_ERROR  TEXT
*      -->P_IS_ZTHRBS01  TEXT
*      <--P_E_CODE  TEXT
*      <--P_E_TEXT  TEXT
*----------------------------------------------------------------------*
FORM check_input_date USING p_zgubun
                            p_pernr
                            p_znal
                            p_persk
                            p_ztomo
*                              PS_ZTHRBS01 STRUCTURE ZTHRBS01
                   CHANGING c_code
                            c_text.

  CLEAR: c_code, c_text.

*...// 신시간외실비 적용일자->2007.6.1일자 적용.
  IF p_znal < '20070601'.
    c_code = 'E50'.
    c_text = text-e50.
    RETURN.
  ENDIF.

*...// 음향디자인실 시간외 포함 기간 CHECK.
  IF p_znal < '20100401' AND p_persk = 'D6'.
    c_code = 'E51'.
    c_text = text-e51.
    RETURN.
  ENDIF.

*...// 해외출장 시간외 (2011.07.01 발생건부터 적용)
  IF p_zgubun = 'T'.
    IF p_znal LT '20110701'.
      c_code = 'E50'.
      CONCATENATE '해외출장중 시간외는 2011.07.01일 부터 입력가능합니다.'
                      '근무일을 확인하세요!'
                 INTO c_text SEPARATED BY space.
      RETURN.
    ENDIF.
    IF p_persk = 'D6'. " 음향디자인실 시간외 포함 기간 CHECK.
      IF p_znal LT '20110801'.
        c_code = 'E54'.
        c_text = '해외출장 적용대상이 아닙니다 !'.
        RETURN.
      ENDIF.
    ENDIF.
  ENDIF.

*...// 해외출장자 입력 CHECK.
  IF p_zgubun = 'T'.
    IF p_persk NE 'D6'.
      PERFORM check_trip_warning USING p_pernr
                                       p_znal
                                       p_ztomo
*                                      PS_ZTHRBS01
                              CHANGING c_code
                                       c_text.

      IF c_code+0(1) EQ 'E'.
        RETURN.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    " CHECK_INPUT_DATE
*&---------------------------------------------------------------------*
*&      FORM  CHECK_POSSIBLE_DATE
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_IS_ZTHRBS01  TEXT
*      <--P_E_CODE  TEXT
*      <--P_E_TEXT  TEXT
*----------------------------------------------------------------------*
FORM check_wkdate  USING p_pernr
                         p_persk
                         p_orgeh
                         p_vdsk1
                         p_znal
                         p_ztomo
                         p_znurak
*                         PS_ZTHRBS01 STRUCTURE ZTHRBS01
                CHANGING c_code
                         c_text.

  CHECK p_znurak = ''.
*...// 입력가능일 점검->현재일기준(+/-)5일전후,입력기간관리정보(ZTHRBS07)
*....// 예외처리: 1.2010.05.04 : 대상자 인사하위그룹 D6(음향디자인실) && 담당자(22602,XA14423).
*....// 예외처리: 2.대상자 조직이 50037672(TV기술국)인 경우 현재일자가 2010년6월25일 이전인경우 근로일자가 2010년6월9일~2010년6월15일까지 해제.
*....// 예외처리: 3.현재일자가 2010년6월25일 이전인경우 근로일자가 2010년6월9일~2010년6월13일까지 해제.
  IF ( (  p_persk EQ 'D6' AND ( sy-uname EQ '22602' OR sy-uname EQ 'XA14423') ) OR
       (  p_orgeh EQ '50037672' AND sy-datum LE '20100625' AND
          p_znal  GE '20100609' AND p_znal LE '20100615' )  OR "TV기술국은 15일까지 해제요청
       ( sy-datum LE '20100625' AND p_znal GE '20100609' AND p_znal LE '20100613' )
     ).
    RETURN.
  ELSE.
    PERFORM check_possible_date USING p_pernr     "사번
                                      p_vdsk1     "조직
                                      p_znal      "근로일
                                      p_ztomo     "익일FLAG
                                CHANGING c_code
                                         c_text.

*    IF sy-uname = 'XA31535'.
*      IF p_znal = '20180127' OR p_znal = '20180128'.
*        c_code = ''.
*        c_text = ''.
*      ENDIF.
*    ENDIF.

  ENDIF.
ENDFORM.                    " CHECK_POSSIBLE_DATE
*&---------------------------------------------------------------------*
*&      FORM  CHECK_POSSIBLE_DATE
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_PS_ZTHRBS01_PERNR  TEXT
*      -->P_PS_ZTHRBS01_VDSK1  TEXT
*      -->P_PS_ZTHRBS01_ZNAL  TEXT
*      -->P_PS_ZTHRBS01_ZTOMO  TEXT
*      <--P_C_CODE  TEXT
*      <--P_C_TEXT  TEXT
*----------------------------------------------------------------------*
FORM check_possible_date  USING    p_pernr
                                   p_vdsk1
                                   p_znal
                                   p_ztomo
                          CHANGING c_code
                                   c_text.

  DATA : lv_begda           TYPE datum,
         lv_endda           TYPE datum,
         lv_eznal           TYPE datum, "현재 신청건의 근무 종료일
         lv_cznal           TYPE datum, "변경일 또는 반려일
         lv_orgeh           TYPE orgeh, "부서
         lv_day_cnt         TYPE i,
         lv_idays           TYPE i,
         lv_extenddaycount  TYPE i,
         lv_nonholidaycount TYPE i,
         lv_holidaycount    TYPE i,
         lv_nextdayholiday  TYPE i,
         lv_extendday       TYPE datum.

  DATA: ls_zthrbs01 TYPE zthrbs01,
        lt_zthrbs01 TYPE TABLE OF zthrbs01,
        ls_zthrbs07 TYPE zthrbs07,
        lt_zthrbs07 TYPE TABLE OF zthrbs07,
        ls_holyday  TYPE iscal_day,
        lt_holyday  TYPE TABLE OF iscal_day ,
        lt_holyday3 TYPE TABLE OF iscal_day.

  CLEAR: c_code, c_text.

*...// 익일 지시자 여부에 따라 근무 종료일자 설정
  IF p_ztomo IS NOT INITIAL.
    lv_eznal = p_znal + 1.
  ELSE.
    lv_eznal = p_znal.
  ENDIF.

  lv_nonholidaycount = 2.

*...// 1 2018.06.11일 이후 근무 종료 후 3일(휴일 제외) 이내 신청 가능하도록 수정
  IF sy-datum >= '20180611' OR
     p_pernr EQ '31756'. " 인사운영부 김승훈

    lv_extendday = lv_eznal + 1.

    WHILE lv_nonholidaycount > 0 OR lv_nextdayholiday = 1.

      CLEAR lt_holyday[].

      CALL FUNCTION 'HOLIDAY_GET'
        EXPORTING
          holiday_calendar = 'KR'
          factory_calendar = 'KR'
          date_from        = lv_extendday
          date_to          = lv_extendday
        TABLES
          holidays         = lt_holyday. "공휴일이 쌓여있음

      DESCRIBE TABLE lt_holyday LINES lv_holidaycount.
      IF lv_holidaycount EQ 1.
        lv_extendday = lv_extendday + 1.

        CLEAR lt_holyday[].
        CALL FUNCTION 'HOLIDAY_GET'
          EXPORTING
            holiday_calendar = 'KR'
            factory_calendar = 'KR'
            date_from        = lv_extendday
            date_to          = lv_extendday
          TABLES
            holidays         = lt_holyday. "공휴일이 쌓여있음

        DESCRIBE TABLE lt_holyday LINES lv_holidaycount.
        IF lv_holidaycount EQ 1.
          lv_nextdayholiday = 1.
        ELSE.
          lv_nextdayholiday = 0.
        ENDIF.
      ELSE.
        lv_extendday = lv_extendday + 1.
        lv_nonholidaycount = lv_nonholidaycount - 1.

        CLEAR lt_holyday[].

        CALL FUNCTION 'HOLIDAY_GET'
          EXPORTING
            holiday_calendar = 'KR'
            factory_calendar = 'KR'
            date_from        = lv_extendday
            date_to          = lv_extendday
          TABLES
            holidays         = lt_holyday. "공휴일이 쌓여있음

        DESCRIBE TABLE lt_holyday LINES lv_holidaycount.
        IF lv_holidaycount EQ 1.
          lv_nextdayholiday = 1.
        ELSE.
          lv_nextdayholiday = 0.
        ENDIF.
      ENDIF.

    ENDWHILE.

  ELSE.

    lv_extendday = lv_eznal.

  ENDIF.

*...// 2.
*  IF D_ZNAL < SY-DATUM.  " 근무 종료일이 과거이면 입력 불가, 단 삭제/회수/반려 건에 한해서만 입력가능 2015.7.14 수정
  IF lv_extendday < sy-datum."근무 종료일 + 3일 이내 신청 가능하도록 수정
***    DATA ls_pa9021 TYPE pa9021.
***
***    SELECT SINGLE *
***      INTO CORRESPONDING FIELDS OF ls_pa9021
***      FROM pa9021
***     WHERE pernr = p_pernr
***       AND begda <= p_znal
***       AND endda >= p_znal.
***
***    CASE ls_pa9021-z52wktp.
***      WHEN '0110'.  "선택근로
***        SELECT state cdate aedat AS aedtm ztomo
***          INTO CORRESPONDING FIELDS OF TABLE lt_zthrbs01
***          FROM zthr0112
***         WHERE pernr = p_pernr
***           AND datum = p_znal
***           AND z52wktp = ls_pa9021-z52wktp
***           AND z52prsq = ls_pa9021-z52prsq
***           AND state IN ('2','5','9').
***
***      WHEN '0120'.  "탄력근로
***        SELECT state cdate aedat AS aedtm ztomo
***          INTO CORRESPONDING FIELDS OF TABLE lt_zthrbs01
***          FROM zthr0110
***         WHERE pernr = p_pernr
***           AND datum = p_znal
***           AND state IN ('2','5','9').
***
***      WHEN OTHERS.
*  XA30750 시간외 지침 개정에 따른 수정 (7.1 시행)
    SELECT * FROM zthrbs01 INTO CORRESPONDING FIELDS OF TABLE lt_zthrbs01
            WHERE pernr = p_pernr
              AND znal = p_znal
              AND zsangsin = 'Y'                    "XA31535 20180529 수정 상신 여부 확인
              AND state IN ('0','2','5','9')         " STATE '0' 추가 '0'만 있을 경우 저장만 했는지 알 수 없으므로, 상신여부 확인 필요.
       ORDER BY erdat ertim DESCENDING.

*    APPEND IT_ZTHRBS01.
***    ENDCASE.


    IF sy-subrc = 0.  "기존신청건이 있던 경우. 즉 반려, 회수, 삭제 후 재상신하는 경우

      CLEAR ls_zthrbs01.

      READ TABLE lt_zthrbs01 INTO ls_zthrbs01 INDEX 1.

*    반려건의 경우는, 변경일이 아니라 승인/반려일 필드에 있는 날짜를 기준으로 비교해야함 20150714 수정
      IF ls_zthrbs01-state = '9' AND ls_zthrbs01-cdate IS NOT INITIAL.
        lv_cznal = ls_zthrbs01-cdate.
      ELSE.
        lv_cznal = ls_zthrbs01-aedtm.
      ENDIF.


      "이전 신청건이 익일까지 신청된 건이 있었다면, 종료일(익일) 기준으로 2일간 수정/결재 가능
      "휴일을 판단하기 위해, 근무 시작일을 기준으로 삼아, 종료일을 익일일 경우 +1 해주는 방식으로 처리
      IF ls_zthrbs01-ztomo IS NOT INITIAL.
        lv_endda = p_znal + 1.
      ELSE.
        lv_endda = p_znal .
      ENDIF.

      IF lv_cznal > lv_endda OR lv_endda >= sy-datum.

        CLEAR : lv_day_cnt, ls_holyday, lt_holyday3.

* 처음 시작하는 날이, 평일인지 휴일인지 구분
        CALL FUNCTION 'HOLIDAY_GET'
          EXPORTING
            holiday_calendar = 'KR'
            factory_calendar = 'KR'
            date_from        = lv_endda
            date_to          = lv_endda
          TABLES
            holidays         = lt_holyday3. "공휴일이 쌓여있음

        READ TABLE lt_holyday3 INTO ls_holyday INDEX 1.
        IF ls_holyday-holiday IS INITIAL AND ls_holyday-freeday IS INITIAL.
          lv_day_cnt = -1.
        ELSE.
          lv_day_cnt = 0.
        ENDIF.


** 휴일제외 하고, 종료일 기준으로 +2일 -> +5일
** 원래는 상신일 기준으로 +2일이어야 함. 근데 회수할 경우 상신일자를 가져올 수 없음..
** 그래서 근무일 +5일으로..로동자에게 유리하게..

        WHILE lv_day_cnt <> 5.
          CLEAR: ls_holyday, lt_holyday3.

          CALL FUNCTION 'HOLIDAY_GET'
            EXPORTING
              holiday_calendar = 'KR'
              factory_calendar = 'KR'
              date_from        = lv_endda
              date_to          = lv_endda
            TABLES
              holidays         = lt_holyday3. "공휴일이 쌓여있음

          READ TABLE lt_holyday3 INTO ls_holyday INDEX 1.

          IF ls_holyday-holiday IS INITIAL AND ls_holyday-freeday IS INITIAL.
            lv_day_cnt = lv_day_cnt + 1.
          ENDIF.

          IF lv_day_cnt <> 5.
            lv_endda = lv_endda + 1.
          ENDIF.

        ENDWHILE.
*   XA30750 수정. 입력기한 5일(공휴일 제외) 설정 로직 추가 - 끝
        IF sy-datum > lv_endda.

          MOVE p_vdsk1 TO lv_orgeh.  " 조직코드.

          " 입력기간 설정정보 점검->사번/팀별 정보.
          SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_zthrbs07
            FROM zthrbs07
           WHERE ( orgeh = lv_orgeh OR pernr = p_pernr )
             AND ( begda  <= p_znal AND endda  >= p_znal )     " 입력가능기간.
             AND ( zbegda <= sy-datum AND zendda >= sy-datum )  " 유효기간.
             AND zdele = ''.
          IF sy-subrc NE 0.
            c_code = 'E31'.
            c_text = text-e31.
            RETURN.
          ENDIF.
        ENDIF.
      ELSE.
        MOVE p_vdsk1 TO lv_orgeh.  " 조직코드.

        " 입력기간 설정정보 점검->사번/팀별 정보.
        SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_zthrbs07
          FROM zthrbs07
         WHERE ( orgeh = lv_orgeh OR pernr = p_pernr )
           AND ( begda  <= p_znal AND endda  >= p_znal )      " 입력가능기간.
           AND ( zbegda <= sy-datum AND zendda >= sy-datum )  " 유효기간.
           AND zdele = ''.
        IF sy-subrc NE 0.
          c_code = 'E31'.
          c_text = text-e31.
          RETURN.
        ENDIF.
      ENDIF.
    ELSE.
* XA30750 수정. 입력기한 5일(공휴일 제외) 설정 로직 추가 -시작

*휴일점검
*  DATA : I_HOL3 LIKE ISCAL_DAY OCCURS 0 WITH HEADER LINE.

      " 현재일기준, + 5일만 점검(현재일 기준으로 이전 근무는 신청 못한다.). 20150501시행, XA30750
      IF sy-datum < '20150507'.
        lv_begda = sy-datum - 5.
        lv_endda = sy-datum + 5.
      ELSE.
        lv_begda = sy-datum.
        lv_endda = sy-datum + 5.
      ENDIF.

* 익일로 신청한 건에 대해서는, 종료일 기준으로 24시간 내에 신청 가능해야 한다. 20150701시행. XA30750
      CLEAR lv_eznal.

      IF p_ztomo IS NOT INITIAL.
        lv_eznal = p_znal + 1.
        IF sy-datum =  lv_eznal.
          lv_begda = sy-datum - 1.
        ENDIF.
      ENDIF.


* 예산부에서 휴일제외로 처음 요구했으나, 다시 휴일포함 5일로 변경되어, 아래 로직 주석 처리함.
*  현재일 기준으로 -5일 계산(휴일제외)
*  WHILE DAY_COUNT <> 6.
*    CLEAR I_HOL3.
*    REFRESH I_HOL3.
*
*    CALL FUNCTION 'HOLIDAY_GET'
*      EXPORTING
*        HOLIDAY_CALENDAR = 'KR'
*        FACTORY_CALENDAR = 'KR'
*        DATE_FROM        = LV_BEGDA
*        DATE_TO          = LV_BEGDA
*      TABLES
*        HOLIDAYS         = I_HOL3. "공휴일이 쌓여있음
*
*    IF I_HOL3-HOLIDAY IS INITIAL AND I_HOL3-FREEDAY IS INITIAL.
*      DAY_COUNT = DAY_COUNT + 1.
*    ENDIF.
*
*    IF DAY_COUNT <> 6.
*      LV_BEGDA = LV_BEGDA - 1.
*    ENDIF.
*
*  ENDWHILE.
*
*  CLEAR DAY_COUNT.
*
** 현재일 기준으로 +5일 계산(휴일제외)
*  WHILE DAY_COUNT <> 6 .
*    CLEAR I_HOL3.
*    REFRESH I_HOL3.
*
*    CALL FUNCTION 'HOLIDAY_GET'
*      EXPORTING
*        HOLIDAY_CALENDAR = 'KR'
*        FACTORY_CALENDAR = 'KR'
*        DATE_FROM        = LV_ENDDA
*        DATE_TO          = LV_ENDDA
*      TABLES
*        HOLIDAYS         = I_HOL3. "공휴일이 쌓여있음
*
*
*
*    IF I_HOL3-HOLIDAY IS INITIAL AND I_HOL3-FREEDAY IS INITIAL.
*      DAY_COUNT = DAY_COUNT + 1.
*    ENDIF.
*
*    IF DAY_COUNT <> 6.
*      LV_ENDDA = LV_ENDDA + 1.
*    ENDIF.
*
*  ENDWHILE.

*   XA30750 수정. 입력기한 5일(공휴일 제외) 설정 로직 추가 - 끝

      IF p_znal < lv_begda OR p_znal > lv_endda.
        MOVE p_vdsk1 TO lv_orgeh.  " 조직코드.

        " 입력기간 설정정보 점검->사번/팀별 정보.
        SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_zthrbs07
          FROM zthrbs07
         WHERE ( orgeh = lv_orgeh OR pernr = p_pernr )
           AND ( begda  <= p_znal AND endda  >= p_znal )      " 입력가능기간.
           AND ( zbegda <= sy-datum AND zendda >= sy-datum )  " 유효기간.
           AND zdele = ''.
        IF sy-subrc NE 0.
            c_code = 'E31'.
            c_text = text-e31.
        ENDIF.
      ENDIF.
    ENDIF.
  ELSE. " 근무 종료일이 미래이면 무조건 입력 가능, 2015.7.14 수정
*    휴일점검
*  DATA : I_HOL3 LIKE ISCAL_DAY OCCURS 0 WITH HEADER LINE.

    " 현재일기준, + 5일만 점검(현재일 기준으로 이전 근무는 신청 못한다.). 20150501시행, XA30750
    IF sy-datum < '20150507'.
      lv_begda = sy-datum - 5.
      lv_endda = sy-datum + 5.
    ELSE.
      lv_begda = sy-datum.
      lv_endda = sy-datum + 5.
    ENDIF.

* 익일로 신청한 건에 대해서는, 종료일 기준으로 24시간 내에 신청 가능해야 한다. 20150701시행. XA30750
    CLEAR lv_eznal.

    IF p_ztomo IS NOT INITIAL.
      lv_eznal = p_znal + 1.
      IF sy-datum = lv_eznal.
        lv_begda = sy-datum - 1.
      ENDIF.
    ENDIF.

*        IF P_ZNAL < LV_BEGDA OR
*       P_ZNAL > LV_ENDDA.

    IF p_znal > lv_endda.  "XA31535 20180529 수정.

      MOVE p_vdsk1 TO lv_orgeh.  " 조직코드.

      " 입력기간 설정정보 점검->사번/팀별 정보.
      SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_zthrbs07
        FROM zthrbs07
       WHERE ( orgeh = lv_orgeh OR pernr = p_pernr )
         AND ( begda  <= p_znal AND endda  >= p_znal )       " 입력가능기간.
         AND ( zbegda <= sy-datum AND zendda >= sy-datum )  " 유효기간.
         AND zdele = ''.
      IF sy-subrc NE 0.
*        0이 나와도 입력이 가능하도록 수정 (이렇게 했다가 바뀜)
        "Start-Modify / 선택근무로 에러메시지 주석처리했었지만, 통상근무자들도 가능하게 되어 에러메시지 다시 출력/xa32726
        c_code = 'E31'.
        c_text = text-e31.
*        RETURN.
        "End-Modify
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    " CHECK_POSSIBLE_DATE
*&---------------------------------------------------------------------*
*&      FORM  CHECK_DAILYWORK_POSSIBLE_DATE
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_PS_ZTHRBS01_PERNR  TEXT
*      -->P_PS_ZTHRBS01_VDSK1  TEXT
*      -->P_PS_ZTHRBS01_ZNAL  TEXT
*      -->P_PS_ZTHRBS01_ZTOMO  TEXT
*      <--P_C_CODE  TEXT
*      <--P_C_TEXT  TEXT
*----------------------------------------------------------------------*
FORM check_dailywork_possible_date  USING    p_pernr
                                   p_vdsk1
                                   p_znal
                                   p_ztomo
                                   p_opt
                          CHANGING c_code
                                   c_text.


  DATA : lv_begda           TYPE datum,
         lv_endda           TYPE datum,
         lv_eznal           TYPE datum, "현재 신청건의 근무 종료일
         lv_cznal           TYPE datum, "변경일 또는 반려일
         lv_orgeh           TYPE orgeh, "부서
         lv_day_cnt         TYPE i,
         lv_idays           TYPE i,
         lv_extenddaycount  TYPE i,
         lv_nonholidaycount TYPE i,
         lv_holidaycount    TYPE i,
         lv_nextdayholiday  TYPE i,
         lv_extendday       TYPE datum.

  DATA: ls_zthrbs01 TYPE zthrbs01,
        lt_zthrbs01 TYPE TABLE OF zthrbs01,
        ls_zthrbs07 TYPE zthrbs07,
        lt_zthrbs07 TYPE TABLE OF zthrbs07,
        ls_holyday  TYPE iscal_day,
        lt_holyday  TYPE TABLE OF iscal_day ,
        lt_holyday3 TYPE TABLE OF iscal_day.

  DATA: ls_zthr0112 TYPE zthr0112.

  CLEAR: c_code, c_text.

*...// 익일 지시자 여부에 따라 근무 종료일자 설정
  IF p_ztomo IS NOT INITIAL.
    lv_eznal = p_znal + 1.
  ELSE.
    lv_eznal = p_znal.
  ENDIF.

  lv_nonholidaycount = 2.

*...// 1 2018.06.11일 이후 근무 종료 후 3일(휴일 제외) 이내 신청 가능하도록 수정
  IF sy-datum >= '20180611' OR
     p_pernr EQ '31756'. " 인사운영부 김승훈

    lv_extendday = lv_eznal + 1.

    WHILE lv_nonholidaycount > 0 OR lv_nextdayholiday = 1.

      CLEAR lt_holyday[].

      CALL FUNCTION 'HOLIDAY_GET'
        EXPORTING
          holiday_calendar = 'KR'
          factory_calendar = 'KR'
          date_from        = lv_extendday
          date_to          = lv_extendday
        TABLES
          holidays         = lt_holyday. "공휴일이 쌓여있음

      DESCRIBE TABLE lt_holyday LINES lv_holidaycount.
      IF lv_holidaycount EQ 1.
        lv_extendday = lv_extendday + 1.

        CLEAR lt_holyday[].
        CALL FUNCTION 'HOLIDAY_GET'
          EXPORTING
            holiday_calendar = 'KR'
            factory_calendar = 'KR'
            date_from        = lv_extendday
            date_to          = lv_extendday
          TABLES
            holidays         = lt_holyday. "공휴일이 쌓여있음

        DESCRIBE TABLE lt_holyday LINES lv_holidaycount.
        IF lv_holidaycount EQ 1.
          lv_nextdayholiday = 1.
        ELSE.
          lv_nextdayholiday = 0.
        ENDIF.
      ELSE.
        lv_extendday = lv_extendday + 1.
        lv_nonholidaycount = lv_nonholidaycount - 1.

        CLEAR lt_holyday[].

        CALL FUNCTION 'HOLIDAY_GET'
          EXPORTING
            holiday_calendar = 'KR'
            factory_calendar = 'KR'
            date_from        = lv_extendday
            date_to          = lv_extendday
          TABLES
            holidays         = lt_holyday. "공휴일이 쌓여있음

        DESCRIBE TABLE lt_holyday LINES lv_holidaycount.
        IF lv_holidaycount EQ 1.
          lv_nextdayholiday = 1.
        ELSE.
          lv_nextdayholiday = 0.
        ENDIF.
      ENDIF.

    ENDWHILE.

  ELSE.

    lv_extendday = lv_eznal.

  ENDIF.

*...// 2.
*  IF D_ZNAL < SY-DATUM.  " 근무 종료일이 과거이면 입력 불가, 단 삭제/회수/반려 건에 한해서만 입력가능 2015.7.14 수정
  IF lv_extendday < sy-datum."근무 종료일 + 3일 이내 신청 가능하도록 수정
***    DATA ls_pa9021 TYPE pa9021.
***
***    SELECT SINGLE *
***      INTO CORRESPONDING FIELDS OF ls_pa9021
***      FROM pa9021
***     WHERE pernr = p_pernr
***       AND begda <= p_znal
***       AND endda >= p_znal.
***
***    CASE ls_pa9021-z52wktp.
***      WHEN '0110'.  "선택근로
***        SELECT state cdate aedat AS aedtm ztomo
***          INTO CORRESPONDING FIELDS OF TABLE lt_zthrbs01
***          FROM zthr0112
***         WHERE pernr = p_pernr
***           AND datum = p_znal
***           AND z52wktp = ls_pa9021-z52wktp
***           AND z52prsq = ls_pa9021-z52prsq
***           AND state IN ('2','5','9').
***
***      WHEN '0120'.  "탄력근로
***        SELECT state cdate aedat AS aedtm ztomo
***          INTO CORRESPONDING FIELDS OF TABLE lt_zthrbs01
***          FROM zthr0110
***         WHERE pernr = p_pernr
***           AND datum = p_znal
***           AND state IN ('2','5','9').
***
***      WHEN OTHERS.
*  XA30750 시간외 지침 개정에 따른 수정 (7.1 시행)
    SELECT * FROM zthrbs01 INTO CORRESPONDING FIELDS OF TABLE lt_zthrbs01
            WHERE pernr = p_pernr
              AND znal = p_znal
              AND zsangsin = 'Y'                    "XA31535 20180529 수정 상신 여부 확인
              AND state IN ('0','2','5','9')         " STATE '0' 추가 '0'만 있을 경우 저장만 했는지 알 수 없으므로, 상신여부 확인 필요.
       ORDER BY erdat ertim DESCENDING.

*    APPEND IT_ZTHRBS01.
***    ENDCASE.


    IF sy-subrc = 0.  "기존신청건이 있던 경우. 즉 반려, 회수, 삭제 후 재상신하는 경우

      CLEAR ls_zthrbs01.

      READ TABLE lt_zthrbs01 INTO ls_zthrbs01 INDEX 1.

*    반려건의 경우는, 변경일이 아니라 승인/반려일 필드에 있는 날짜를 기준으로 비교해야함 20150714 수정
      IF ls_zthrbs01-state = '9' AND ls_zthrbs01-cdate IS NOT INITIAL.
        lv_cznal = ls_zthrbs01-cdate.
      ELSE.
        lv_cznal = ls_zthrbs01-aedtm.
      ENDIF.


      "이전 신청건이 익일까지 신청된 건이 있었다면, 종료일(익일) 기준으로 2일간 수정/결재 가능
      "휴일을 판단하기 위해, 근무 시작일을 기준으로 삼아, 종료일을 익일일 경우 +1 해주는 방식으로 처리
      IF ls_zthrbs01-ztomo IS NOT INITIAL.
        lv_endda = p_znal + 1.
      ELSE.
        lv_endda = p_znal .
      ENDIF.

      IF lv_cznal > lv_endda OR lv_endda >= sy-datum.

        CLEAR : lv_day_cnt, ls_holyday, lt_holyday3.

* 처음 시작하는 날이, 평일인지 휴일인지 구분
        CALL FUNCTION 'HOLIDAY_GET'
          EXPORTING
            holiday_calendar = 'KR'
            factory_calendar = 'KR'
            date_from        = lv_endda
            date_to          = lv_endda
          TABLES
            holidays         = lt_holyday3. "공휴일이 쌓여있음

        READ TABLE lt_holyday3 INTO ls_holyday INDEX 1.
        IF ls_holyday-holiday IS INITIAL AND ls_holyday-freeday IS INITIAL.
          lv_day_cnt = -1.
        ELSE.
          lv_day_cnt = 0.
        ENDIF.


** 휴일제외 하고, 종료일 기준으로 +2일 -> +5일
** 원래는 상신일 기준으로 +2일이어야 함. 근데 회수할 경우 상신일자를 가져올 수 없음..
** 그래서 근무일 +5일으로..로동자에게 유리하게..

        WHILE lv_day_cnt <> 5.
          CLEAR: ls_holyday, lt_holyday3.

          CALL FUNCTION 'HOLIDAY_GET'
            EXPORTING
              holiday_calendar = 'KR'
              factory_calendar = 'KR'
              date_from        = lv_endda
              date_to          = lv_endda
            TABLES
              holidays         = lt_holyday3. "공휴일이 쌓여있음

          READ TABLE lt_holyday3 INTO ls_holyday INDEX 1.

          IF ls_holyday-holiday IS INITIAL AND ls_holyday-freeday IS INITIAL.
            lv_day_cnt = lv_day_cnt + 1.
          ENDIF.

          IF lv_day_cnt <> 5.
            lv_endda = lv_endda + 1.
          ENDIF.

        ENDWHILE.
*   XA30750 수정. 입력기한 5일(공휴일 제외) 설정 로직 추가 - 끝
        IF sy-datum > lv_endda.

          MOVE p_vdsk1 TO lv_orgeh.  " 조직코드.

          " 입력기간 설정정보 점검->사번/팀별 정보.
          SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_zthrbs07
            FROM zthrbs07
           WHERE ( orgeh = lv_orgeh OR pernr = p_pernr )
             AND ( begda  <= p_znal AND endda  >= p_znal )     " 입력가능기간.
             AND ( zbegda <= sy-datum AND zendda >= sy-datum )  " 유효기간.
             AND zdele = ''.
          IF sy-subrc NE 0.
            c_code = 'E31'.
            c_text = text-e31.
            RETURN.
          ENDIF.
        ENDIF.
      ELSE.
        MOVE p_vdsk1 TO lv_orgeh.  " 조직코드.

        " 입력기간 설정정보 점검->사번/팀별 정보.
        SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_zthrbs07
          FROM zthrbs07
         WHERE ( orgeh = lv_orgeh OR pernr = p_pernr )
           AND ( begda  <= p_znal AND endda  >= p_znal )      " 입력가능기간.
           AND ( zbegda <= sy-datum AND zendda >= sy-datum )  " 유효기간.
           AND zdele = ''.
        IF sy-subrc NE 0.
          c_code = 'E31'.
          c_text = text-e31.
          RETURN.
        ENDIF.
      ENDIF.
    ELSE.
* XA30750 수정. 입력기한 5일(공휴일 제외) 설정 로직 추가 -시작

*휴일점검
*  DATA : I_HOL3 LIKE ISCAL_DAY OCCURS 0 WITH HEADER LINE.

      " 현재일기준, + 5일만 점검(현재일 기준으로 이전 근무는 신청 못한다.). 20150501시행, XA30750
      IF sy-datum < '20150507'.
        lv_begda = sy-datum - 5.
        lv_endda = sy-datum + 5.
      ELSE.
        lv_begda = sy-datum.
        lv_endda = sy-datum + 5.
      ENDIF.

* 익일로 신청한 건에 대해서는, 종료일 기준으로 24시간 내에 신청 가능해야 한다. 20150701시행. XA30750
      CLEAR lv_eznal.

      IF p_ztomo IS NOT INITIAL.
        lv_eznal = p_znal + 1.
        IF sy-datum =  lv_eznal.
          lv_begda = sy-datum - 1.
        ENDIF.
      ENDIF.


* 예산부에서 휴일제외로 처음 요구했으나, 다시 휴일포함 5일로 변경되어, 아래 로직 주석 처리함.
*  현재일 기준으로 -5일 계산(휴일제외)
*  WHILE DAY_COUNT <> 6.
*    CLEAR I_HOL3.
*    REFRESH I_HOL3.
*
*    CALL FUNCTION 'HOLIDAY_GET'
*      EXPORTING
*        HOLIDAY_CALENDAR = 'KR'
*        FACTORY_CALENDAR = 'KR'
*        DATE_FROM        = LV_BEGDA
*        DATE_TO          = LV_BEGDA
*      TABLES
*        HOLIDAYS         = I_HOL3. "공휴일이 쌓여있음
*
*    IF I_HOL3-HOLIDAY IS INITIAL AND I_HOL3-FREEDAY IS INITIAL.
*      DAY_COUNT = DAY_COUNT + 1.
*    ENDIF.
*
*    IF DAY_COUNT <> 6.
*      LV_BEGDA = LV_BEGDA - 1.
*    ENDIF.
*
*  ENDWHILE.
*
*  CLEAR DAY_COUNT.
*
** 현재일 기준으로 +5일 계산(휴일제외)
*  WHILE DAY_COUNT <> 6 .
*    CLEAR I_HOL3.
*    REFRESH I_HOL3.
*
*    CALL FUNCTION 'HOLIDAY_GET'
*      EXPORTING
*        HOLIDAY_CALENDAR = 'KR'
*        FACTORY_CALENDAR = 'KR'
*        DATE_FROM        = LV_ENDDA
*        DATE_TO          = LV_ENDDA
*      TABLES
*        HOLIDAYS         = I_HOL3. "공휴일이 쌓여있음
*
*
*
*    IF I_HOL3-HOLIDAY IS INITIAL AND I_HOL3-FREEDAY IS INITIAL.
*      DAY_COUNT = DAY_COUNT + 1.
*    ENDIF.
*
*    IF DAY_COUNT <> 6.
*      LV_ENDDA = LV_ENDDA + 1.
*    ENDIF.
*
*  ENDWHILE.

*   XA30750 수정. 입력기한 5일(공휴일 제외) 설정 로직 추가 - 끝

      IF p_znal < lv_begda OR p_znal > lv_endda.
        MOVE p_vdsk1 TO lv_orgeh.  " 조직코드.

        " 입력기간 설정정보 점검->사번/팀별 정보.
        SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_zthrbs07
          FROM zthrbs07
         WHERE ( orgeh = lv_orgeh OR pernr = p_pernr )
           AND ( begda  <= p_znal AND endda  >= p_znal )      " 입력가능기간.
           AND ( zbegda <= sy-datum AND zendda >= sy-datum )  " 유효기간.
           AND zdele = ''.
        IF sy-subrc NE 0.
          c_code = 'E31'.
          c_text = text-e31.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
  ELSE. " 근무 종료일이 미래이면 무조건 입력 가능, 2015.7.14 수정
*    휴일점검
*  DATA : I_HOL3 LIKE ISCAL_DAY OCCURS 0 WITH HEADER LINE.

    " 현재일기준, + 5일만 점검(현재일 기준으로 이전 근무는 신청 못한다.). 20150501시행, XA30750
    IF sy-datum < '20150507'.
      lv_begda = sy-datum - 5.
      lv_endda = sy-datum + 5.
    ELSE.
      lv_begda = sy-datum.
      lv_endda = sy-datum + 5.
    ENDIF.

* 익일로 신청한 건에 대해서는, 종료일 기준으로 24시간 내에 신청 가능해야 한다. 20150701시행. XA30750
    CLEAR lv_eznal.

    IF p_ztomo IS NOT INITIAL.
      lv_eznal = p_znal + 1.
      IF sy-datum = lv_eznal.
        lv_begda = sy-datum - 1.
      ENDIF.
    ENDIF.

*        IF P_ZNAL < LV_BEGDA OR
*       P_ZNAL > LV_ENDDA.

    IF p_znal > lv_endda.  "XA31535 20180529 수정.

      MOVE p_vdsk1 TO lv_orgeh.  " 조직코드.

      " 입력기간 설정정보 점검->사번/팀별 정보.
      SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_zthrbs07
        FROM zthrbs07
       WHERE ( orgeh = lv_orgeh OR pernr = p_pernr )
         AND ( begda  <= p_znal AND endda  >= p_znal )       " 입력가능기간.
         AND ( zbegda <= sy-datum AND zendda >= sy-datum )  " 유효기간.
         AND zdele = ''.
      IF sy-subrc NE 0.
        "20250930-나구엽-선택근로 노사협의에 따라 미래 입력 및 수정이 자유자재로 가능하게(시뮬레이션) 조치
       "단 미상신 저장만 되고 결재 상신 올리거나 수정 하려고 하면 안되어야 함(필요시 삭제), 기존에 저장된건이 있는지 확인
        IF p_opt = 'S' OR p_opt = 'U'.
          SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_zthr0112
            FROM zthr0112
          WHERE pernr = p_pernr AND datum = p_znal.
          IF sy-subrc = 0.
            c_code = 'E31'.
            c_text = text-e34.
             RETURN.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    " CHECK_DAILYWORK_POSSIBLE_DATE
*&---------------------------------------------------------------------*
*&      FORM  CHECK_WKTIME
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_IS_ZTHRBS01_ZGUBUN  TEXT
*      -->P_IS_ZTHRBS01_ZNAL  TEXT
*      -->P_IS_ZTHRBS01_ZBEGT  TEXT
*      -->P_IS_ZTHRBS01_ZENDT  TEXT
*      -->P_IS_ZTHRBS01_ZTOMOH  TEXT
*      -->P_IS_ZTHRBS01_ZYUHYUNG  TEXT
*      -->P_IS_ZTHRBS01_ZDANGJ  TEXT
*      -->P_IS_ZTHRBS01_ZTOICH  TEXT
*      -->P_IS_ZTHRBS01_ZDAEH  TEXT
*      -->P_IS_ZTHRBS01_ZYOIL  TEXT
*      <--P_E_CODE  TEXT
*      <--P_E_TEXT  TEXT
*----------------------------------------------------------------------*
FORM check_wktime  USING p_zgubun
                         p_znal
                         p_zbegt
                         p_zendt
                         p_ztomo
                         p_ztomoh
                         p_zyuhyung
*                        P_ZDANGJ
                         p_ztoich
                         p_zdaeh
                         p_zyoil
                         p_zemcwk
                CHANGING c_code
                         c_text.

  DATA:lv_holiday TYPE cind.

  CLEAR: c_code, c_text.
*...// 입력은 30분 단위로만 가능
  IF p_zbegt+2(2) <> '00' AND p_zbegt+2(2) <> '30'.
    c_code = 'E86'.
    c_text = text-e86.
    RETURN.
  ENDIF.

  IF p_zendt+2(2) <> '00' AND p_zendt+2(2) <> '30'.
    c_code = 'E86'.
    c_text = text-e86.
    RETURN.
  ENDIF.

  PERFORM check_total_wktime
    USING p_znal
          p_ztomo
          p_zbegt
          p_zendt
 CHANGING c_code
          c_text.

  IF c_code+0(1) EQ 'E'.  RETURN. ENDIF.


*...// 입력시간 CHECK.
*...// 1. 입력시간 범위제한(근로종료시간 제한)
*         1.1 익일 09:00 입력 제한.
*              -> Ⓐ 신청유형이 통상(P_ZGUBUN='1' OR P_ZGUBUN='A'),시차(P_ZGUBUN='B') & 익휴(P_ZTOMO) FLAG 가 ''인경우.
*                    근로일 다음날이 평일인 경우 09:00 까지 입력이 가능하다.
*                 Ⓑ 교대근무(P_ZGUBUN='2',P_ZGUBUN='C' & 교대근무 유형이 철야가 아닌 경우(P_ZYUHYUNG<>'01')
*                    근로일 익일 09:00 까지 입력이 가능하다.
*         1.2 익일 12:00 입력제한.
*             -> 신청유형이 교대근무(P_ZGUBUN='2',P_ZGUBUN='C' & 교대근무 유형이 철야인경우(P_ZYUHYUNG='01')
*                근로일 익일 12:00 까지 입력이 가능하다.
*...// 2. 퇴출(P_ZTOICH)과 대휴(P_ZDAEH) 동시 선택 CHECK.
*         -> 근무일이 휴일인 경우 퇴출과 대휴를 동시 선택을 할 수 없다.
*...// 3. 신청유형이 시차근무(P_ZGUBUN='B') "통상평일연장" 근무 입력제한.
*         -> 시차근무 이고 근로일이 평일, 시작시간(P_ZBEGT)이 08:00 ~ 10:00 이면 통상으로 강제.



*  1.1 익일 09:00 입력 제한.
  IF ( ( p_zgubun EQ '1' OR p_zgubun EQ 'A' OR p_zgubun EQ 'B' ) AND p_ztomoh IS INITIAL ) OR "통상 시차 이고 익휴가 아닌경우
     ( ( p_zgubun EQ '2' OR p_zgubun EQ 'C' ) AND p_zyuhyung <> '01' )."  OR                  "교대근무 이고 철야가 아닌경우
*     ( ( P_ZGUBUN EQ '3' AND NOT P_ZDANGJ IS INITIAL ) OR P_ZGUBUN EQ 'E').                   "당번후 근무(제외:2018.10.02)
    " 통상시차(익휴제외),교대근무(철야제외),당직후근무
    "-> 익일 09:00까지 입력제한.(단, 통상익일휴일인 경우제외_20070831)
    IF p_ztomo IS NOT INITIAL AND p_zendt > '090000'.
      CLEAR lv_holiday.
      PERFORM get_next_day USING p_znal
                        CHANGING lv_holiday.
      IF p_zgubun EQ '1' OR p_zgubun EQ 'A' OR p_zgubun EQ 'B'. "통상, 시차인경우
*       익일 9시 이후의 건이 발생하면 전부 오류처리 하게끔 되어 있음.
*       휴일인경우와 휴일이아닌경우로 오류맨트를 날리는데 모두 불필요. 20190522. 임재하.
*        IF lv_holiday IS INITIAL.
*          c_code = 'E20'.
*          c_text = text-e20.
**          RETURN.
*        ELSE.
**          c_code = 'E21'.
**          c_text = text-e21.
**          RETURN.
*        ENDIF.
      ELSE.
        c_code = 'E21'.
        c_text = text-e21.
        RETURN.
      ENDIF.
    ENDIF.
*  1.2 익일 12:00 입력제한.
  ELSEIF ( ( p_zgubun EQ '2' OR p_zgubun EQ 'C' ) AND p_zyuhyung EQ '01' ). "교대근무 이고 철야인경우
*         ( WA_BS01-ZGUBUN = '1' AND NOT WA_BS01-ZTOMOH IS INITIAL )
    IF NOT p_ztomo IS INITIAL AND p_zendt > '120000'. "익일FLAG값이 있고 종료시간이 12:00보다 큰경우
      c_code = 'E21'.
      c_text = text-e21.
      RETURN.
    ENDIF.
  ENDIF.

*...// 2. 퇴출과 대휴 동시 선택 CHECK.
  IF NOT p_ztoich IS INITIAL AND NOT p_zdaeh  IS INITIAL.
    IF p_zyoil = '휴'.  " 근무일이 휴일 여부.
      c_code = 'E56'.
      CONCATENATE '퇴출과 대휴을 동시에'
                  text-e56
                  INTO c_text SEPARATED BY space.
      RETURN.
    ENDIF.
  ENDIF.

** 당직후근무 입력제한( 2018.10.02일 당직후 근무 신청유형 삭제)
** 81.휴일중 당직후근무 입력불가처리.
*  IF ( P_ZGUBUN = '3' AND NOT P_ZDANGJ IS INITIAL ) OR P_ZGUBUN = 'E'.
*
*    CLEAR LV_HOLIDAY.
*
*    CALL FUNCTION 'ZHR_GET_DAY_DATA_N'
*      EXPORTING
*        ZNAL    = P_ZNAL
*      IMPORTING
*        HOLIDAY = LV_HOLIDAY.
*
*    IF NOT L_HOLIDAY IS INITIAL.
*      C_CODE = 'E57'.
*      C_TEXT = TEXT-E57.
*      RETURN.
*    ENDIF.
*  ENDIF.

* 통상근무에서 시차근무 입력시, 경고메시지
* -> 2008.05.15 예산팀 이현주님 삭제요청.
*  IF WA_BS01-ZGUBUN = 'A' AND
*     WA_BS01-ZTOICH IS INITIAL AND
*     WA_BS01-ZTOMOH IS INITIAL AND
*     WA_BS01-ZBEGT >= '100000'.
*
*    CALL FUNCTION 'ZHR_GET_DAY_DATA_N'
*         EXPORTING
*              ZNAL    = WA_BS01-ZNAL
*         IMPORTING
*              HOLIDAY = L_HOLIDAY.
*
*    IF L_HOLIDAY IS INITIAL.  " 평일
*      ERROR_CODE = 'S25'.
*      ERROR_TEXT = TEXT-S25.
*      EXIT.
*    ENDIF.
*  ENDIF.

*...// 3. 신청유형이 시차근무(P_ZGUBUN='B') "통상평일연장" 근무 입력제한.
  IF p_zgubun = 'B' AND p_zbegt BETWEEN '080100' AND '095900'.
*       ( p_zgubun = 'B' AND p_zendt BETWEEN '070000' AND '090000' AND p_ztomo = 'X' ).

    CALL FUNCTION 'ZHR_GET_DAY_DATA_N'
      EXPORTING
        znal    = p_znal
      IMPORTING
        holiday = lv_holiday.

    IF lv_holiday IS INITIAL.  " 평일
      c_code = 'E58'.
      c_text = text-e58.   "<<<- WEB에서 메세지로 체크하기 때문에 절대 수정불가 - 2019.06.25 by chl
      RETURN.
    ENDIF.
  ENDIF.
ENDFORM.                    " CHECK_WKTIME
*&---------------------------------------------------------------------*
*&      FORM  GET_NEXT_DAY
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_P_ZNAL  TEXT
*      <--P_LV_HOLIDAY  TEXT
*----------------------------------------------------------------------*
FORM get_next_day  USING    p_znal
                   CHANGING c_holiday.

*...// 다음날 휴일여부 확인
  DATA : lv_datum TYPE datum.

  CLEAR c_holiday.

  lv_datum = p_znal + 1.

  CALL FUNCTION 'ZHR_GET_DAY_DATA_N'
    EXPORTING
      znal    = lv_datum
    IMPORTING
      holiday = c_holiday.

ENDFORM.                    " GET_NEXT_DAY
*&---------------------------------------------------------------------*
*&      FORM  CHECK_EXCEP
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_IS_ZTHRBS01_PERNR  TEXT
*      -->P_IS_ZTHRBS01_ZNAL  TEXT
*      <--P_E_CODE  TEXT
*      <--P_E_TEXT  TEXT
*----------------------------------------------------------------------*
FORM check_excep  USING    p_zgubun
                           p_pernr
                           p_znal
                  CHANGING c_code
                           c_text.

* 워크스케쥴 교대근무자 등록여부 체크(20090109)
  DATA : ls_zthrwork_gubun TYPE zthrwork_gubun,
         ls_zthrbs13       TYPE zthrbs13.

  SELECT SINGLE * INTO ls_zthrwork_gubun
    FROM zthrwork_gubun
   WHERE pernr EQ p_pernr
     AND begda <= p_znal
     AND gubun = '02'
     AND endda >= p_znal.

  IF sy-subrc = 0 AND p_zgubun <> 'C'.
* 출제위원이면 예외로 (2011.06.10)
    SELECT SINGLE * INTO ls_zthrbs13
      FROM zthrbs13
      WHERE pernr EQ p_pernr
        AND begda <= p_znal
        AND endda >= p_znal
        AND zreasn = '01'. " 출제위원만

    IF sy-subrc = 0.
      c_code = 'E33'. " 출제위원 시간외 신청 불가. " 20190602 xa30752 인사운영부 민지홍 요청
      c_text = text-e33.
      RETURN.
    ELSE.
      c_code = 'E60'.
      c_text = text-e60.
      RETURN.
    ENDIF.

  ENDIF.
ENDFORM.                    " CHECK_EXCEP
*&---------------------------------------------------------------------*
*&      FORM  CHECK_TRIP_DATA_N
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_T_ERROR  TEXT
*      -->P_IS_ZTHRBS01_ZGUBUN  TEXT
*      -->P_IS_ZTHRBS01_PERNR  TEXT
*      -->P_IS_ZTHRBS01_ZNAL  TEXT
*      -->P_IS_ZTHRBS01_ZTOMO  TEXT
*      <--P_E_CODE  TEXT
*      <--P_E_TEXT  TEXT
*----------------------------------------------------------------------*
FORM check_trip_data_n USING    p_zgubun
                                p_pernr
                                p_znal
                                p_ztomo
                       CHANGING c_code
                                c_text.

  DATA : BEGIN OF ls_trip,
           pernr  LIKE pa0001-pernr,
           ename  LIKE pa0001-ename,
           sdate  LIKE zhrt001-sdate,    " 신청일자
           app_no LIKE zhrt001-app_no,
           seq_no LIKE zhrt001-seq_no,
           bdate  LIKE zhrt001-bdate,
           edate  LIKE zhrt001-edate,
           zbdate LIKE zhrt001-bdate,  " 중복확인용.
           zedate LIKE zhrt001-edate,  " 중복확인용.
           term   LIKE zhrt001-term,
           zterm  TYPE i,              " 출장기간-계산
           c_code LIKE zhrt001-c_code, " 출장구분=1(국내),2(국외)
           t_name LIKE zhrt001-t_name, " 출장분류
           zctnm  LIKE zhrt001-zctnm,  " 출장지
           zctx1  LIKE zhrt001-zctx1,  " 출장내역
           zttot  LIKE zhrt002-zttot,
           zttot_krw LIKE bsik-dmbtr,
           waers     LIKE bsik-waers,
  END OF ls_trip,
         lt_trip LIKE TABLE OF ls_trip.

  DATA: ls_zhrt002 TYPE zhrt002.

  DATA : lv_begda TYPE datum,
         lv_endda TYPE datum,
         lv_lines TYPE i.

  CLEAR: c_code, c_text.

  lv_begda = p_znal.        " 근무일.

  IF p_ztomo IS INITIAL.   " 익일.
    lv_endda = p_znal.
  ELSE.
    lv_endda = p_znal + 1.
  ENDIF.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_trip
    FROM zhrt001 AS a
   INNER JOIN zhrt002 AS b
      ON a~sdate  EQ b~sdate
     AND a~app_no EQ b~app_no
     AND a~seq_no EQ b~seq_no
   WHERE a~bdate <= lv_endda
     AND a~edate >= lv_begda
     AND a~c_code EQ '2'                " 해외출장
     AND b~pernr  EQ p_pernr
     AND b~zstat  EQ 'A'                " 승인건만
     AND b~c_flag NE 'X'
     AND b~zcanc  NE 'X'.

  SORT lt_trip BY pernr bdate edate.
* 변경/취소신청->원건삭제(C_FLAG='X')->간혹 누락표시된 건 존재함.
* 예) 운영-> 16946, 20060419~20060426 취소신청건.
  LOOP AT lt_trip INTO ls_trip.
    SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_zhrt002
      FROM zhrt002
     WHERE pernr    = ls_trip-pernr
       AND c_sdate  = ls_trip-sdate
       AND c_app_no = ls_trip-app_no
       AND c_seq_no = ls_trip-seq_no
       AND zstat    = 'A'.
    IF sy-subrc = 0.
      DELETE lt_trip FROM ls_trip. CLEAR ls_trip.
    ENDIF.
  ENDLOOP.

  DESCRIBE TABLE lt_trip LINES lv_lines.

  IF p_ztomo IS NOT INITIAL.
    IF lv_lines = 0.  "시간외 종료일에 시작하는 출장이 있는지
      SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_trip
        FROM zhrt001 AS a
       INNER JOIN zhrt002 AS b
          ON a~sdate  EQ b~sdate
         AND a~app_no EQ b~app_no
         AND a~seq_no EQ b~seq_no
       WHERE a~bdate EQ lv_endda
         AND a~c_code EQ '2'                " 해외출장
         AND b~pernr  EQ p_pernr
         AND b~zstat  EQ 'A'                " 승인건만
         AND b~c_flag NE 'X'
         AND b~zcanc  NE 'X'.

      SORT lt_trip BY pernr bdate edate.
* 변경/취소신청->원건삭제(C_FLAG='X')->간혹 누락표시된 건 존재함.
* 예) 운영-> 16946, 20060419~20060426 취소신청건.
      LOOP AT lt_trip INTO ls_trip.
        SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_zhrt002
           FROM zhrt002
          WHERE pernr    EQ ls_trip-pernr
            AND c_sdate  EQ ls_trip-sdate
            AND c_app_no EQ ls_trip-app_no
            AND c_seq_no EQ ls_trip-seq_no
            AND zstat    EQ 'A'.
        IF sy-subrc = 0.
          DELETE lt_trip FROM ls_trip. CLEAR ls_trip.
        ENDIF.
      ENDLOOP.

      DESCRIBE TABLE lt_trip LINES lv_lines.
      IF lv_lines = 0.  "시간외 시작일에 종료되는 출장이 있는지
        SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_trip
          FROM zhrt001 AS a
         INNER JOIN zhrt002 AS b
            ON a~sdate  = b~sdate
           AND a~app_no = b~app_no
           AND a~seq_no = b~seq_no
         WHERE a~edate = lv_begda
           AND a~c_code EQ '2'                " 해외출장
           AND b~pernr  EQ p_pernr
           AND b~zstat  EQ 'A'                " 승인건만
           AND b~c_flag NE 'X'
           AND b~zcanc  NE 'X'.

        SORT lt_trip BY pernr bdate edate.
* 변경/취소신청->원건삭제(C_FLAG='X')->간혹 누락표시된 건 존재함.
* 예) 운영-> 16946, 20060419~20060426 취소신청건.
        LOOP AT lt_trip INTO ls_trip.
          SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_zhrt002
            FROM zhrt002
           WHERE pernr    EQ ls_trip-pernr
             AND c_sdate  EQ ls_trip-sdate
             AND c_app_no EQ ls_trip-app_no
             AND c_seq_no EQ ls_trip-seq_no
             AND zstat    EQ 'A'.
          IF sy-subrc = 0.
            DELETE lt_trip FROM ls_trip. CLEAR ls_trip.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.

* 여기서부터 CHECK
  CASE p_zgubun.
    WHEN 'T'.  "유형 : 해외출장 - 해외출장내역이 없으면 오류
      CLEAR : lv_lines.
      DESCRIBE TABLE lt_trip LINES lv_lines.
      IF lv_lines < 1.
        c_code = 'E59'.
        c_text = text-e59.
*        LS_ERROR-CODE = 'E59'.
*        LS_ERROR-TEXT = TEXT-E59.
*        APPEND LS_ERROR TO PT_ERROR. CLEAR LS_ERROR.
        RETURN.
      ENDIF.
* < 익일 CHECK가 된 경우 >
      IF p_ztomo IS NOT INITIAL.
        LOOP AT lt_trip INTO ls_trip.
* 시작,종료일이 출장기간내
          IF lv_begda GT ls_trip-bdate AND
             lv_endda LT ls_trip-edate.
            CONTINUE.
          ENDIF.

          IF lv_begda GT ls_trip-bdate AND lv_endda EQ ls_trip-edate.
            IF lv_begda LE '20110630'.  " 7/1 발생분부터 적용되므로
              c_code = 'E61'.
              c_text = text-e61.
              RETURN.
            ENDIF.
          ENDIF.

          IF lv_begda EQ ls_trip-bdate AND lv_endda LT ls_trip-edate.
            IF lv_begda LE '20110630'.  " 7/1 발생분부터 적용되므로
              c_code = 'E61'.
              c_text = text-e61.
              RETURN.
            ENDIF.
          ENDIF.
* 시간외 시작일이 출장시작일 이전  => 시작일기준 : 해외출장 적용대상이 아님(다른유형으로)
          IF lv_begda < ls_trip-bdate AND
             lv_endda GE ls_trip-bdate.
*            LS_ERROR-CODE = 'E28'.
*            LS_ERROR-TEXT = TEXT-E28.
*            APPEND LS_ERROR TO PT_ERROR.
*            CLEAR LS_ERROR.
            EXIT.
          ENDIF.
* 시간외 시작일이 출장종료일 : 해외 및 다른근무유형 가능 (2011.07.25)
          IF lv_begda = ls_trip-edate.
*            LS_ERROR-CODE = 'W07'.
*            LS_ERROR-TEXT = TEXT-S07.
*            APPEND LS_ERROR TO PT_ERROR. CLEAR LS_ERROR.
*            CONTINUE.
          ENDIF.
        ENDLOOP.
      ELSE.
*** <1일 시간외>
        LOOP AT lt_trip INTO ls_trip.
          ls_trip-zterm = ls_trip-edate - ls_trip-bdate + 1.
          IF ls_trip-zterm >= 3.
            ls_trip-zbdate = ls_trip-bdate + 1.
            ls_trip-zedate = ls_trip-edate - 1.
          ENDIF.
* 출장기간내 : OK
          IF ls_trip-zbdate <= lv_endda AND
             ls_trip-zedate >= lv_begda.
            CONTINUE.
          ENDIF.
* 시작/종료일에 시간외
          IF lv_begda = ls_trip-bdate.
*            LS_ERROR-CODE = 'W07'.
*            LS_ERROR-TEXT = TEXT-S07.
*            APPEND LS_ERROR TO PT_ERROR. CLEAR LS_ERROR.
*            CONTINUE.
          ENDIF.

          IF lv_endda = ls_trip-edate.
*            LS_ERROR-CODE = 'W07'.
*            LS_ERROR-TEXT = TEXT-S07.
*            APPEND LS_ERROR TO PT_ERROR. CLEAR LS_ERROR.
*            CONTINUE.
          ENDIF.
        ENDLOOP.
      ENDIF.
* 기타 유형 :
    WHEN OTHERS.
      CLEAR : lv_lines.
      DESCRIBE TABLE lt_trip LINES lv_lines.

      IF lv_lines LE 0.  "해외출장과 중복이 없음
        EXIT.
      ENDIF.
* <익일이 CHECK 된 경우>
      IF p_ztomo IS NOT INITIAL.
        LOOP AT lt_trip INTO ls_trip.
* 출장기간내
          IF lv_begda GE ls_trip-bdate AND
             lv_endda LE ls_trip-edate.
*            LS_ERROR-CODE = 'E08'.
*            LS_ERROR-TEXT = TEXT-E08.
*            APPEND LS_ERROR TO PT_ERROR. CLEAR LS_ERROR.
            EXIT.
          ENDIF.
* 시작일이 출장일 이전, 종료일이 출장기간 : OK.
          IF lv_begda < ls_trip-bdate AND
             lv_endda = ls_trip-bdate.
            CONTINUE.
          ENDIF.
* 시간외 시작일이 출장종료일 : 해외출장, 기타출장 가능 (2011.07.25)
          IF lv_begda = ls_trip-edate AND
             lv_endda GT ls_trip-edate.
            CONTINUE.
          ENDIF.
**  시간외 시작일이 출장기간, 종료일이 출장이후 : 해외출장으로 신청해야 함
*          IF LV_BEGDA LE LS_TRIP-EDATE AND
*             LV_ENDDA GT LS_TRIP-EDATE.
*            LS_ERROR-CODE = 'E08'.
*            LS_ERROR-TEXT = TEXT-E08.
*            APPEND LS_ERROR TO PT_ERROR CLEAR LS_ERROR.
*          ENDIF.
        ENDLOOP.
*< 1일 출장 >
      ELSE.
        LOOP AT lt_trip INTO ls_trip.
* 출장 시작일 또는 종료일 : 해외출장, 기타근무유형 모두 가능 (2011.07.25)
          IF  lv_begda = ls_trip-bdate OR
              lv_begda = ls_trip-edate.
          ELSE.
*              IF ( LV_BEGDA GE LS_TRIP-BDATE AND LV_BEGDA LE LS_TRIP-EDATE ) OR
*                 ( LV_ENDDA GE LS_TRIP-BDATE AND LV_ENDDA LE LS_TRIP-EDATE ).
            IF ( lv_begda GT ls_trip-bdate AND lv_begda LT ls_trip-edate ) OR
               ( lv_endda GT ls_trip-bdate AND lv_endda LT ls_trip-edate ).
*              LS_ERROR-CODE = 'E08'.
*              LS_ERROR-TEXT = TEXT-E08.
*              APPEND LS_ERROR TO PT_ERROR. CLEAR LS_ERROR.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.
  ENDCASE.

*  " 오류/경고 테이블.
*  LOOP AT LS_ERROR.
*    APPEND LS_ERROR TO PT_ERROR.
*    CLEAR  LS_ERROR.
*  ENDLOOP.
*
*  DESCRIBE TABLE LS_ERROR LINES LV_LINES.
*  IF LV_LINES = 1.
*    READ TABLE LS_ERROR INDEX 1.
*    IF LS_ERROR+0(1) = 'E'.
*      MOVE : LS_ERROR-CODE TO C_CODE,
*             LS_ERROR-TEXT TO C_TEXT.
*      EXIT.
*    ELSE.
*      PERFORM NOTIFY_MESSAGES USING LS_ERROR-TEXT.
*    ENDIF.
*  ELSEIF LV_LINES > 1.
*    READ TABLE LS_ERROR WITH KEY CODE+0(1) = 'E'.
*    IF SY-SUBRC = 0.
*      MOVE : LS_ERROR-CODE TO C_CODE,
*             LS_ERROR-TEXT TO C_TEXT.
*    ELSE.
*      READ TABLE LS_ERROR INDEX 1.
*
*      MOVE : LS_ERROR-CODE TO C_CODE,
*             LS_ERROR-TEXT TO C_TEXT.
*
*      PERFORM NOTIFY_MESSAGES USING LS_ERROR-TEXT.
*    ENDIF.
*  ENDIF.
ENDFORM.                    " CHECK_TRIP_DATA_N
*&---------------------------------------------------------------------*
*&      FORM  CHECK_TRIP_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->PS_ZTHRBS01_PERNR  TEXT
*      -->PS_ZTHRBS01_ZNAL  TEXT
*      -->PS_ZTHRBS01_ZTOMO  TEXT
*      <--P_E_CODE  TEXT
*      <--P_E_TEXT  TEXT
*----------------------------------------------------------------------*
FORM check_trip_data  USING    p_pernr
                               p_znal
                               p_ztomo
                      CHANGING c_code
                               c_text.

*...// 해외출장자 입력제한
*....// 근로일이 해외출장 시작일, 종료일에 해당하는 경우는 WARNING
*....// 근로일이 해외출장 시작일, 종료일을 제외한 출장기간에 포함이 된 경우 ERROR 처리.
  DATA : ls_zhrt002 TYPE zhrt002,
         BEGIN OF ls_trip,
            pernr  LIKE pa0001-pernr,
            ename  LIKE pa0001-ename,
            sdate  LIKE zhrt001-sdate,    " 신청일자
            app_no LIKE zhrt001-app_no,
            seq_no LIKE zhrt001-seq_no,
            bdate  LIKE zhrt001-bdate,
            edate  LIKE zhrt001-edate,
            zbdate LIKE zhrt001-bdate,  " 중복확인용.
            zedate LIKE zhrt001-edate,  " 중복확인용.
            term   LIKE zhrt001-term,
            zterm  TYPE i,              " 출장기간-계산
            c_code LIKE zhrt001-c_code, " 출장구분=1(국내),2(국외)
            t_name LIKE zhrt001-t_name, " 출장분류
            zctnm  LIKE zhrt001-zctnm,  " 출장지
            zctx1  LIKE zhrt001-zctx1,  " 출장내역
            zttot  LIKE zhrt002-zttot,
            zttot_krw LIKE bsik-dmbtr,
            waers     LIKE bsik-waers,
         END OF ls_trip,
         lt_trip LIKE TABLE OF ls_trip,
         ls_error TYPE zsh_error,
         lt_error TYPE TABLE OF zsh_error.

  DATA : lv_begda TYPE datum,
         lv_endda TYPE datum,
         lv_lines TYPE i.

  CLEAR: c_code, c_text, ls_error.

  lv_begda = p_znal.        " 근무일.
  IF p_ztomo IS INITIAL.   " 익일.
    lv_endda = p_znal.
  ELSE.
    lv_endda = p_znal + 1.
  ENDIF.

  SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_trip
    FROM zhrt001 AS a
   INNER JOIN zhrt002 AS b
      ON a~sdate  EQ b~sdate
     AND a~app_no EQ b~app_no
     AND a~seq_no EQ b~seq_no
   WHERE a~bdate <= lv_endda
     AND a~edate >= lv_begda
     AND a~c_code EQ '2'                " 해외출장
     AND b~pernr  EQ p_pernr
     AND b~zstat  EQ 'A'                " 승인건만
     AND b~c_flag NE 'X'
     AND b~zcanc  NE 'X'.

  SORT lt_trip BY pernr bdate edate.
* 변경/취소신청->원건삭제(C_FLAG='X')->간혹 누락표시된 건 존재함.
* 예) 운영-> 16946, 20060419~20060426 취소신청건.
  LOOP AT lt_trip INTO ls_trip.
    SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_zhrt002
      FROM zhrt002
    WHERE pernr    EQ ls_trip-pernr
      AND c_sdate  EQ ls_trip-sdate
      AND c_app_no EQ ls_trip-app_no
      AND c_seq_no EQ ls_trip-seq_no
      AND zstat    = 'A'.
    IF sy-subrc = 0.
      DELETE lt_trip FROM ls_trip. CLEAR ls_trip.
    ENDIF.
  ENDLOOP.


  LOOP AT lt_trip INTO ls_trip.
    ls_trip-zterm = ls_trip-edate - ls_trip-bdate + 1.   "출장기간.
    IF ls_trip-zterm >= 3.
      ls_trip-zbdate = ls_trip-bdate + 1.
      ls_trip-zedate = ls_trip-edate - 1.

      IF ls_trip-zbdate <= lv_endda AND ls_trip-zedate >= lv_begda.   " 시작/종료일제외 중복시.
        c_code = 'E62'.
        c_text = text-e62.
        RETURN.
      ELSE.                          " 시작/종료일인 경우.
        CLEAR: ls_error.
        ls_error-code = 'W06'.
        ls_error-text = text-s06.
        APPEND ls_error TO lt_error.
      ENDIF.
    ELSE.                                 " 시작/종료일인 경우.
      CLEAR: ls_error.
      ls_error-code = 'W06'.
      ls_error-text = text-s06.
      APPEND ls_error TO lt_error.
    ENDIF.
  ENDLOOP.

  CHECK LINES( lt_error ) > 0.

  READ TABLE lt_error INTO ls_error INDEX 1.
  IF sy-subrc EQ 0.
    c_code = ls_error-code.
    c_text = ls_error-text.
  ENDIF.

ENDFORM.                    " CHECK_TRIP_DATA
*&---------------------------------------------------------------------*
*&      FORM  CHECK_ABSENCE_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_IS_ZTHRBS01_PERNR  TEXT
*      -->P_IS_ZTHRBS01_ZNAL  TEXT
*      -->P_IS_ZTHRBS01_ZTOMO  TEXT
*      -->P_IS_ZTHRBS01_ZGUBUN  TEXT
*      <--P_E_CODE  TEXT
*      <--P_E_TEXT  TEXT
*----------------------------------------------------------------------*
FORM check_absence_data  USING    p_pernr
                                  p_znal
                                  p_ztomo
                                  p_zgubun
                         CHANGING c_code
                                  c_text.

* 근태(휴가) 승인 및 신청여부.
  DATA : ls_zthrbs08   TYPE zthrbs08,
         ls_zthr0080   TYPE zthr0080,
         ls_zthr0080_c TYPE zthr0080,
         lt_zthr0080   TYPE TABLE OF zthr0080,
         lt_zcal       TYPE TABLE OF zcal WITH HEADER LINE,
         ls_zcal       LIKE LINE OF lt_zcal.

  DATA : lv_begda   TYPE datum,
         lv_endda   TYPE datum,
         lv_flag(1) TYPE c.
  DATA: rol_count TYPE i.

  DATA : l_daynr  LIKE  hrvsched-daynr,
             lv_holiday.

  lv_begda = p_znal.
  lv_endda = p_znal.

* 익일건은 제외함(예산팀 박세화 요청,2007.06.08)
*  IF P_ZTOMO IS INITIAL.
*    LV_ENDDA = P_ZNAL.
*  ELSE.
*    LV_ENDDA = P_ZNAL + 1.
*  ENDIF.

  IF p_zgubun = '1' OR
     p_zgubun = 'A' OR
     p_zgubun = 'B'.
    " 통상시차->대휴인경우 입력가능.   "대휴도 근태에서 막아달라는 요청(2013.1.14- 안지연 선배 요청에 의해 수정) XA30750
* 통상/시차: 연차 반차, 자녀돌봄 반일, 일반검진 반일은 입력 허용.
* 근태종류와 세부유형을 함께 비교하여 종일 근태가 허용되지 않도록 함.
    SELECT * INTO TABLE lt_zthr0080
      FROM zthr0080
     WHERE pernr EQ p_pernr
       AND begda       <= lv_endda
       AND endda       >= lv_begda
       AND state       IN ('0','D')     " 0-신청, D-기/유형변경 신청
       AND zaccept     NE 'N'         " 승인여부
       AND NOT ( ( gunart = '10'
                   AND ( guntype = '13' OR guntype = '15' ) )
              OR ( gunart = '30'
                   AND ( guntype = '43' OR guntype = '44' ) )
              OR ( gunart = '40'
                   AND ( guntype = '28' OR guntype = '29' ) ) )
       AND zuhyung     EQ ''.          " 자료유형

  ELSE.

    CLEAR: rol_count.
    SELECT COUNT(*) FROM agr_users INTO rol_count WHERE agr_name = 'MRHR300_1' AND uname = sy-uname AND from_dat <= sy-datum AND to_dat >= sy-datum.

    IF rol_count = 0.      " 관리자의 경우 근태있을 때 신청 가능 xa30752 2019.07.05
      SELECT * INTO TABLE lt_zthr0080
        FROM zthr0080
       WHERE pernr   EQ p_pernr
         AND begda   <= lv_endda
         AND endda   >= lv_begda
         AND state   IN ('0','D')     " 0-신청, D-기/유형변경 신청
         AND zaccept NE 'N'         " 승인여부
         AND zuhyung = ''.          " 자료유형

    ENDIF.
  ENDIF.

* 변경 및 삭제 원건 제거.
  LOOP AT lt_zthr0080 INTO ls_zthr0080.
    SELECT SINGLE * INTO ls_zthr0080_c
      FROM zthr0080
     WHERE pernr EQ ls_zthr0080-pernr
       AND state    IN ('D', '2')
       AND zaccept  EQ 'Y'
       AND zserial2 EQ ls_zthr0080-zserial.
    IF sy-subrc = 0.
      DELETE TABLE lt_zthr0080 FROM ls_zthr0080. CLEAR ls_zthr0080.
    ENDIF.
  ENDLOOP.


  IF NOT lt_zthr0080[] IS INITIAL.
    LOOP AT lt_zthr0080 INTO ls_zthr0080.
      CLEAR   : ls_zcal, lt_zcal.

      SELECT * INTO TABLE lt_zcal
        FROM zcal
       WHERE zdate >= ls_zthr0080-begda
         AND zdate <= ls_zthr0080-endda.

      SORT lt_zcal BY zdate.

      CLEAR: l_daynr, lv_holiday. " xa30752 2020.11.23 추가

*      LOOP AT lt_zcal.

      CALL FUNCTION 'ZHR_GET_DAY_DATA'
        EXPORTING
          znal    = lv_begda
        IMPORTING
          daynr	  = l_daynr
          holiday = lv_holiday.

      IF  l_daynr <> '6' AND l_daynr <> '7' AND lv_holiday <> 'X'. " 평일일 경우에만 타도록

        LOOP AT lt_zcal INTO ls_zcal WHERE zdate BETWEEN lv_begda AND lv_endda.
          SELECT SINGLE * INTO ls_zthrbs08
            FROM zthrbs08       " 입력가능여부
           WHERE pernr  EQ ls_zthr0080-pernr
             AND begda  <= ls_zcal-zdate
             AND endda  >= ls_zcal-zdate
             AND zbegda <= sy-datum
             AND zendda >= sy-datum
             AND zdele  = ''.

          IF sy-subrc NE 0.
            lv_flag = 'X'.
            EXIT.
          ENDIF.

        ENDLOOP.

      ENDIF.

    ENDLOOP.
*    ENDLOOP.

    IF lv_flag = 'X'.
      c_code = 'E63'.
      c_text = text-e63.
      RETURN.
    ENDIF.
  ENDIF.
ENDFORM.                    " CHECK_ABSENCE_DATA
*&---------------------------------------------------------------------*
*&      FORM  CHECK_NEXTHOLIDAY_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_IS_ZTHRBS01_PERNR  TEXT
*      -->P_IS_ZTHRBS01_ZNAL  TEXT
*      -->P_IS_ZTHRBS01_ZTOICH  TEXT
*      <--P_E_CODE  TEXT
*      <--P_E_TEXT  TEXT
*----------------------------------------------------------------------*
FORM check_nextholiday_data  USING p_pernr
                                   p_znal
                                   p_ztoich
                          CHANGING c_code
                                   c_text.

  DATA : lv_bznal TYPE datum,
         ls_zthrbs01 TYPE zthrbs01.


  lv_bznal = p_znal - 1.

  SELECT SINGLE * INTO ls_zthrbs01
    FROM zthrbs01
   WHERE pernr  EQ p_pernr
     AND znal   EQ lv_bznal
     AND state  EQ '3'       "승인.
     AND ztomoh EQ 'Y'.

  IF sy-subrc = '0'.
    IF p_ztoich = ''.
      c_code = 'E64'.
      c_text = text-e64.
      RETURN.
    ENDIF.
  ENDIF.
ENDFORM.                    " CHECK_NEXTHOLIDAY_DATA
*&---------------------------------------------------------------------*
*&      FORM  CHECK_OVERTIME_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_IS_ZTHRBS01_PERSK  TEXT
*      -->P_IS_ZTHRBS01_PERNR  TEXT
*      -->P_IS_ZTHRBS01_RDATE  TEXT
*      -->P_IS_ZTHRBS01_SEQNR  TEXT
*      -->P_IS_ZTHRBS01_ZNAL  TEXT
*      -->P_IS_ZTHRBS01_ZBEGT  TEXT
*      -->P_IS_ZTHRBS01_ZENDT  TEXT
*      -->P_IS_ZTHRBS01_ZTOMO  TEXT
*      -->P_IS_ZTHRBS01_ZYOIL  TEXT
*      -->P_IS_ZTHRBS01_ZGUBUN  TEXT
*      -->P_IS_ZTHRBS01_ZDANGJ  TEXT
*      -->P_IS_ZTHRBS01_ZTOMOH  TEXT
*      -->P_I_MODE  TEXT
*      <--P_E_CODE  TEXT
*      <--P_E_TEXT  TEXT
*----------------------------------------------------------------------*
FORM check_overtime_data  USING    p_persk
                                   p_pernr
                                   p_rdate
                                   p_seqnr
                                   p_znal
                                   p_zbegt
                                   p_zendt
                                   p_ztomo
                                   p_zyoil
                                   p_zgubun
                                   p_zdangj
                                   p_ztomoh
                                   p_ztoich
                                   p_mode
                          CHANGING c_code
                                   c_text.

* 시간외시간 중복점검.
  DATA : ls_bs01 TYPE zthrbs01,
         lt_bs01 TYPE TABLE OF zthrbs01.

  DATA : lv_begda LIKE sy-datum,
         lv_endda LIKE sy-datum.

  DATA : lv_cnt   TYPE i,
         lv_cnt_1 TYPE i.

  DATA : lv_text(50) TYPE c.

  lv_begda = p_znal - 1.  " 근무일 전날.
  lv_endda = p_znal + 1.  " 근무일 다음날.

*  SELECT * INTO TABLE LT_BS01
*           FROM ZTHRBS01
*           WHERE PERNR = P_PERNR
*             AND ( ( ZNAL = LV_BEGDA AND ZTOMO NE '' ) OR
*                   ( ZNAL >= P_ZNAL ) )
*             AND ZNAL <= LV_ENDDA
*             AND NOT STATE IN ('2','5','9','F'). " 삭제,회수,반려,미결
  IF p_persk = 'D6'. "효과단.
    SELECT * INTO TABLE lt_bs01
      FROM zthrbs01_1
     WHERE pernr EQ p_pernr
       AND znal >= lv_begda
       AND znal <= lv_endda
       AND NOT state IN ('2','5','9','F'). " 삭제,회수,반려,미결
  ELSE.
    SELECT * INTO TABLE lt_bs01
      FROM zthrbs01
      WHERE pernr EQ p_pernr
        AND znal >= lv_begda
        AND znal <= lv_endda
        AND NOT state IN ('2','5','9','F'). " 삭제,회수,반려,미결
  ENDIF.

  " 변경모드->변경 해당건은 제외함.
  IF p_mode = 'M'.
    DELETE lt_bs01 WHERE pernr = p_pernr
                     AND rdate = p_rdate
                     AND seqnr = p_seqnr.
  ENDIF.

  SORT lt_bs01 ASCENDING BY znal zbegt.

  LOOP AT lt_bs01 INTO ls_bs01.
    " 근무일_전날+익일건->(근무일_전날-종료시간)&&시작시간 점검
    IF ls_bs01-znal EQ lv_begda AND NOT ls_bs01-ztomo IS INITIAL.
      IF ls_bs01-zendt > p_zbegt.
        c_code = 'E65'.
        PERFORM get_duplicate_text       " 중복유형 텍스트.
                USING ls_bs01-zgubun
                      ls_bs01-zdangb
                CHANGING c_text.
        RETURN.
      ENDIF.
    ENDIF.

    " 동일 근무일건 체크->시간중복여부.
    IF ls_bs01-znal = p_znal.
      IF ls_bs01-ztomo IS INITIAL.
        IF p_ztomo IS INITIAL.
          IF ls_bs01-zbegt < p_zendt AND ls_bs01-zendt > p_zbegt.
            c_code = 'E65'.
            PERFORM get_duplicate_text       " 중복유형 텍스트.
                    USING ls_bs01-zgubun
                          ls_bs01-zdangb
                    CHANGING c_text.
            RETURN.
          ENDIF.
        ELSE.
          IF ls_bs01-zendt > p_zbegt.
            c_code = 'E65'.
            PERFORM get_duplicate_text       " 중복유형 텍스트.
                    USING ls_bs01-zgubun
                          ls_bs01-zdangb
                    CHANGING c_text.
            RETURN.
          ENDIF.
        ENDIF.
      ELSE.
        IF p_ztomo IS INITIAL.
          IF ls_bs01-zbegt < p_zendt.
            c_code = 'E65'.
            PERFORM get_duplicate_text       " 중복유형 텍스트.
                    USING ls_bs01-zgubun
                          ls_bs01-zdangb
                    CHANGING c_text.
            RETURN.
          ENDIF.
        ELSE.
          c_code = 'E65'.
          PERFORM get_duplicate_text       " 중복유형 텍스트.
                  USING ls_bs01-zgubun
                        ls_bs01-zdangb
                  CHANGING c_text.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.

    " 익일체크->종료시간&&(근무일_다음날-시작시간)
    IF NOT p_ztomo IS INITIAL  AND
       ls_bs01-znal = lv_endda AND
       ls_bs01-zgubun <> 'D'   AND  "당번특근일 경우는 체크 하지 않음.
       ls_bs01-zdaeh  <> 'Y'.       "근무일자가 분리되어 익일 대휴가 발생한 날에는 체크하지않음.
      IF ls_bs01-zbegt < p_zendt.
        c_code = 'E65'.
        PERFORM get_duplicate_text       " 중복유형 텍스트.
                USING ls_bs01-zgubun
                      ls_bs01-zdangb
                CHANGING c_text.
        RETURN.
      ENDIF.
    ENDIF.
  ENDLOOP.

* 18/19.동일 일자 입력가능 건수 제한
* ->공통(3회),통상휴일_당번특근(1회) 허용.
  CLEAR : lv_cnt, lv_cnt_1.

  CHECK c_code+0(1) NE 'E'.

  LOOP AT lt_bs01 INTO ls_bs01.
    IF ls_bs01-znal = p_znal.
      ADD 1 TO lv_cnt.

      IF ( ls_bs01-zgubun = '1' OR
           ls_bs01-zgubun = 'A' OR
           ls_bs01-zgubun = 'B' )
         OR
         ( ( ls_bs01-zgubun = '3' AND NOT ls_bs01-zdangb IS INITIAL ) OR
           ( ls_bs01-zgubun = 'D' ) ).
        IF ( ls_bs01-begda IS INITIAL OR ls_bs01-begda = '00000000' ).
          ADD 1 TO lv_cnt_1.
        ELSE.
          IF ls_bs01-begda = ls_bs01-znal.
            ADD 1 TO lv_cnt_1.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.

  IF ( ( p_zgubun = '1' OR p_zgubun = 'A' OR p_zgubun = 'B' ) OR
       ( ( p_zgubun = '3' AND p_zdangj IS INITIAL ) OR
          p_zgubun = 'D' ) ) AND
      p_zyoil = '휴'.
    IF lv_cnt_1 >= 1.
      c_code = 'E69'.
      c_text = text-e69.
      RETURN.
    ENDIF.
  ELSE.
    IF lv_cnt >= 3.
      c_code = 'E70'.
      c_text = text-e70.
      RETURN.
    ENDIF.
  ENDIF.

* 60. 통상익휴 입력제한->익일 퇴출초과 선행입력.
*     ->통상익휴(18시간초과),철야/휴평철야(9시간) 이상여부 체크.
  CHECK c_code+0(1) NE 'E'.

  IF NOT p_ztomoh IS INITIAL AND
     NOT p_ztomo  IS INITIAL.


  ENDIF.

* 82. 당직후근무 입력 전, 다른 근무건 존재시 입력제한.
  "① 당직후근무 입력시.
  CHECK c_code+0(1) NE 'E'.

  IF ( p_zgubun = '3' AND NOT p_zdangj IS INITIAL ) OR p_zgubun = 'E'.
    LOOP AT lt_bs01 INTO ls_bs01.
      IF ( ls_bs01-znal = lv_begda AND         " 전날 익일건.
           NOT ls_bs01-ztomo IS INITIAL ) OR
         ( ls_bs01-znal = p_znal AND  " 동일 이전건.
           ls_bs01-zbegt < p_zbegt ).
        c_code = 'E82'.
        PERFORM get_zgubun_text USING ls_bs01-zgubun
                                      ls_bs01-zdangb
                                CHANGING lv_text.

        CONCATENATE lv_text         " 입력구분명.
                    text-e82       " 에러텍스트.
                    INTO c_text SEPARATED BY space.
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDIF.

  CHECK c_code+0(1) NE 'E'.

  "② 당직후근무 입력건이 존재하고, 전날건 익일로 입력시.
  IF NOT p_ztomo IS INITIAL.  " 익일.
    LOOP AT lt_bs01 INTO ls_bs01.
      IF ls_bs01-znal = lv_endda AND  " 다음날.
         ( ( ls_bs01-zgubun = '3' AND NOT ls_bs01-zdangj IS INITIAL ) OR
           ls_bs01-zgubun = 'E' ).
        c_code = 'E83'.
        PERFORM get_zgubun_text USING ls_bs01-zgubun
                                      ls_bs01-zdangb
                                CHANGING lv_text.

        CONCATENATE text-e83       " 에러텍스트.
                    lv_text
                    '입력이 불가합니다.확인하세요!'
                    INTO c_text SEPARATED BY space.
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDIF.

* 83. 근무시간 18시간 미달하는 {철야당번특근/통상익휴}
* -> 위의 82번 로직으로 체크가능함.
  CHECK c_code+0(1) NE 'E'.

* 61. 시차실비 부정수령 제한->연속된 근무분리 제한(통상/시차)
  CHECK c_code+0(1) NE 'E'.

  IF p_zgubun = '1' OR p_zgubun = 'A' OR p_zgubun = 'B'.
    LOOP AT lt_bs01 INTO ls_bs01.
      IF ls_bs01-zgubun = '1' OR p_zgubun = 'A' OR p_zgubun = 'B'.
        " 이전날+익일건의 종료시간&&시작시간->09시기&&22시이후.
        IF ls_bs01-znal = lv_begda AND NOT ls_bs01-ztomo IS INITIAL.
          IF ( p_zbegt = ls_bs01-zendt AND p_zbegt < '090000' ) OR
             ( p_zbegt = ls_bs01-zendt AND p_zbegt >= '220000' ).
            c_code = 'E66'.
            c_text = text-e66.
            RETURN.
          ENDIF.
        ENDIF.

        " 동일 근무일&&시작/종료시간->22시이후.
        IF ls_bs01-znal = p_znal.
          IF p_zendt = ls_bs01-zbegt AND p_zendt >= '220000'.
            c_code = 'E66'.
            c_text = text-e66.
            RETURN.
          ENDIF.
          IF p_zbegt = ls_bs01-zendt AND p_zbegt >= '220000'.
            c_code = 'E66'.
            c_text = text-e66.
            RETURN.
          ENDIF.
        ENDIF.

        " 익일건->종료시간&&다음날 시작시간->09시기준.
        IF NOT p_ztomo IS INITIAL AND ls_bs01-znal = lv_endda.
          IF p_zendt = ls_bs01-zbegt AND p_zendt < '090000'.
            c_code = 'E66'.
            c_text = text-e66.
            RETURN.
          ENDIF.
        ENDIF.

        " 24:00 ~ 00:00 분리입력.
        IF ( ls_bs01-znal = lv_begda AND ls_bs01-zendt = '240000' ) AND
           p_zbegt = '000000'.
          c_code = 'E66'.
          c_text = text-e66.
          RETURN.
        ENDIF.
        IF ( ls_bs01-znal = lv_endda AND ls_bs01-zbegt = '000000') AND
           p_zendt = '240000'.
          c_code = 'E66'.
          c_text = text-e66.
          RETURN.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDIF.

* 23.휴일에 이전익일건 존재시 분리입력 불가처리
*   - 1시간이내만 체크함
  DATA : l_holiday(1).

  CHECK c_code+0(1) NE 'E'.

  IF p_zgubun NE '2' AND p_zgubun NE 'C'.
    " 전날 익일건과 현재 입력건 비교.
    CALL FUNCTION 'ZHR_GET_DAY_DATA_N'
      EXPORTING
        znal    = p_znal
      IMPORTING
        holiday = l_holiday.

    IF l_holiday = 'X'.
      READ TABLE lt_bs01 INTO ls_bs01 WITH KEY znal = lv_begda.
      IF sy-subrc = 0 AND NOT ls_bs01-ztomo IS INITIAL.
        IF p_zbegt = ls_bs01-zendt.
          c_code = 'E23'.
          c_text = text-e23.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.

    " 현재입력건이 익일건이고, 기입력건(다음날) 점검.
    CALL FUNCTION 'ZHR_GET_DAY_DATA_N'
      EXPORTING
        znal    = lv_endda
      IMPORTING
        holiday = l_holiday.

    IF l_holiday = 'X'.
      READ TABLE lt_bs01 INTO ls_bs01 WITH KEY znal = lv_endda.
      IF sy-subrc = 0 AND NOT p_ztomo IS INITIAL.
        IF p_zendt = ls_bs01-zbegt.
          c_code = 'E23'.
          c_text = text-e23.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

* 62/63. 당일 교대근무와 교대외근무 입력불가.
  CHECK c_code+0(1) NE 'E'.
  LOOP AT lt_bs01 INTO ls_bs01.
    IF ls_bs01-znal = p_znal.
      IF ( ls_bs01-zgubun = '2' OR ls_bs01-zgubun = 'C' ) AND
         ( p_zgubun <> '2' AND p_zgubun <> 'C' ).
        c_code = 'E67'.
        c_text = text-e67.
        RETURN.
      ENDIF.

      IF ( ls_bs01-zgubun <> '2' AND ls_bs01-zgubun <> 'C' ) AND
         ( p_zgubun = '2' OR p_zgubun = 'C' ).
        c_code = 'E68'.
        c_text = text-e68.
        RETURN.
      ENDIF.
    ENDIF.
  ENDLOOP.

* 교대근무가 아닐경우 당일 2회 입력 금지.
* 두번째 입력은 반드시 퇴출로 발생해야함. 2019.05.25 임재하.
  LOOP AT lt_bs01 INTO ls_bs01.
    IF ls_bs01-zgubun <> 'C'. "AND p_zgubun <> 'C'.
      IF ls_bs01-znal = p_znal AND ls_bs01-zr_time >='080000' AND p_ztoich EQ ''.
        c_code = 'E24'.
        c_text = text-e24.
      ENDIF.

    ENDIF.
  ENDLOOP.



* 진행상태(STATE)
*0  신청            -> 사용(*), ''(SPACE) 포함
*1  수정            -> 2건 존재하나, 사용안함
*2  삭제            -> 사용(*)
*3  승인            -> 사용(*)
*4  승계            -> 사용안함
*5  회수            -> 사용(*)
*6  일시상환        -> 사용안함
*7  급여상환        -> 사용안함
*8  용도외이용자    -> 사용안함
*9  반려            -> 사용(*)
*A  지급            -> 사용안함
*B  기간변경신청    -> 사용안함
*C  유형변경신청    -> 사용안함
*D  기/유형변경신청 -> 사용안함
*E  상신            -> 사용안함
*F  미결            -> 사용(*)
ENDFORM.                    " CHECK_OVERTIME_DATA
*&---------------------------------------------------------------------*
*&      FORM  GET_DUPLICATE_TEXT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_LS_BS01_ZGUBUN  TEXT
*      -->P_LS_BS01_ZDANGB  TEXT
*      <--P_C_TEXT  TEXT
*----------------------------------------------------------------------*
FORM get_duplicate_text  USING    p_zgubun
                                  p_zdangb
                         CHANGING c_text.

* 시간외중복 텍스트.
  CASE p_zgubun.
    WHEN '1' OR 'A' OR 'B'.
      IF p_zgubun = 'A'.
        CONCATENATE '(통상근무) -'
                    text-e65 INTO c_text SEPARATED BY space.
      ELSEIF p_zgubun = 'B'.
        CONCATENATE '(시차근무) -'
                    text-e65 INTO c_text SEPARATED BY space.
      ELSE.
        CONCATENATE '(통상시차) -'
                    text-e65 INTO c_text SEPARATED BY space.
      ENDIF.

    WHEN '2' OR 'C'.
      CONCATENATE '(교대근무) -'
                  text-e65 INTO c_text SEPARATED BY space.

    WHEN '3' OR 'D' OR 'E'.
      IF NOT p_zdangb IS INITIAL.
        CONCATENATE '(당번특근) -'
                    text-e65 INTO c_text SEPARATED BY space.
      ELSE.
        CONCATENATE '(당직후근무) -'
                    text-e65 INTO c_text SEPARATED BY space.
      ENDIF.

    WHEN OTHERS.
      CONCATENATE '(시간근무) -'
                  text-e65 INTO c_text SEPARATED BY space.
  ENDCASE.
ENDFORM.                    " GET_DUPLICATE_TEXT
*&---------------------------------------------------------------------*
*&      FORM  GET_ZGUBUN_TEXT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_LS_BS01_ZGUBUN  TEXT
*      -->P_LS_BS01_ZDANGB  TEXT
*      <--P_LV_TEXT  TEXT
*----------------------------------------------------------------------*
FORM get_zgubun_text  USING    p_zgubun
                               p_zdangb
                      CHANGING c_text.
* 근무구분 텍스트.
  CASE p_zgubun.
    WHEN '1' OR 'A' OR 'B'.
      IF p_zgubun = 'A'.
        MOVE '(통상근무)' TO c_text.
      ELSEIF p_zgubun = 'B'.
        MOVE '(시차근무)' TO c_text.
      ELSE.
        MOVE '(통상시차)' TO c_text.
      ENDIF.

    WHEN '2' OR 'C'.
      MOVE '(교대근무)' TO c_text.

    WHEN '3' OR 'D' OR 'E'.
      IF NOT p_zdangb IS INITIAL.
        MOVE '(당번특근)' TO c_text.
      ELSE.
        MOVE '(당직후근무)' TO c_text.
      ENDIF.

    WHEN OTHERS.
      MOVE '(시간외근무)' TO c_text.
  ENDCASE.
ENDFORM.                    " GET_ZGUBUN_TEXT
*&---------------------------------------------------------------------*
*&      FORM  CLEAR_DAYS_TABLE
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*  -->  P1        TEXT
*  <--  P2        TEXT
*----------------------------------------------------------------------*
FORM clear_days_table .
  CLEAR: gs_days, gt_days[].
ENDFORM.                    " CLEAR_DAYS_TABLE
*&---------------------------------------------------------------------*
*&      FORM  GET_DATE_TABLE
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_IS_ZTHRBS01_PERNR  TEXT
*      -->P_IS_ZTHRBS01_ZNAL  TEXT
*      -->P_IS_ZTHRBS01_ZTOMO  TEXT
*      -->P_IS_ZTHRBS01_ZBEGT  TEXT
*      -->P_IS_ZTHRBS01_ZENDT  TEXT
*      <--P_ES_OVERTIME_DATA_ZA_TIME  TEXT
*      <--P_ES_OVERTIME_DATA_ZA_TIME_P  TEXT
*      <--P_ES_OVERTIME_DATA_ZYOIL  TEXT
*      <--P_ES_OVERTIME_DATA_ZYOIL_T  TEXT
*      <--P_E_CODE  TEXT
*      <--P_E_TEXT  TEXT
*      <--P_GT_DAYS[]  TEXT
*----------------------------------------------------------------------*
FORM get_date_table TABLES pt_days STRUCTURE gs_days
                     USING    p_pernr
                              p_znal
                              p_ztomo
                              p_zbegt
                              p_zendt
                     CHANGING c_za_time
                              c_za_time_p
                              c_zyoil
                              c_zyoil_t
                              c_code
                              c_text.

  DATA : lv_to_znal      TYPE datum,
         lv_ex_time_n(6) TYPE n.

  CLEAR: gs_days.

*...// 익일 FLAG가 없는 경우 -> 근로일이 당일
  IF p_ztomo IS INITIAL.
    MOVE : p_pernr  TO gs_days-pernr, "사번
           p_znal   TO gs_days-znal,  "근로일(시작)
           p_znal   TO lv_to_znal,    "근로일(종료)
           p_zbegt  TO gs_days-zbegt, "근로시간(시작)
           p_zendt  TO gs_days-zendt. "근로시간(종료)

    PERFORM get_date_info
            USING gs_days-znal         " 일자정보.
            CHANGING gs_days-daynr
                     gs_days-daytxt
                     gs_days-holiday.

    APPEND gs_days TO pt_days.

*    MOVE GS_DAYS-DAYTXT TO P_ZYOIL_T.  " 요일명.
    MOVE gs_days-daytxt+0(1) TO c_zyoil_t.  " 요일명.

    IF gs_days-holiday IS INITIAL.
      MOVE gs_days-daytxt+0(1) TO c_zyoil.  "평일->요일명.
    ELSE.
      MOVE '휴' TO c_zyoil.                 " 휴일->'휴'.
    ENDIF.
  ELSE.
    " 근로일 당일 정보.
    MOVE : p_pernr  TO gs_days-pernr,
           p_znal   TO gs_days-znal,
           p_zbegt  TO gs_days-zbegt,
           '240000' TO gs_days-zendt.

    PERFORM get_date_info
            USING gs_days-znal         " 일자정보.
            CHANGING gs_days-daynr
                     gs_days-daytxt
                     gs_days-holiday.

    MOVE gs_days-daytxt+0(1) TO c_zyoil_t.  " 요일명.
    IF gs_days-holiday IS INITIAL.
      MOVE gs_days-daytxt+0(1) TO c_zyoil.  " 평일->요일명.
    ELSE.
      MOVE '휴' TO c_zyoil.            " 휴일->'휴'.
    ENDIF.

    APPEND gs_days TO pt_days.     CLEAR gs_days.

    " 근로일 다음날 정보.
    gs_days-pernr = p_pernr.
    gs_days-znal  = p_znal + 1.
    gs_days-zbegt = '000000'.
    gs_days-zendt = p_zendt.
    gs_days-ztomo = 'X'.           " 익일날 표시.
    lv_to_znal    = gs_days-znal.

    PERFORM get_date_info
            USING gs_days-znal         " 일자정보.
            CHANGING gs_days-daynr
                     gs_days-daytxt
                     gs_days-holiday.

    APPEND gs_days TO pt_days. CLEAR gs_days.
  ENDIF.

  SORT pt_days BY znal ASCENDING.

* 총근무시간 계산.
  CALL FUNCTION 'ZHR_GET_TIME_DIFF_N'
    EXPORTING
      im_date1        = p_znal     "근로시작일
      im_date2        = lv_to_znal "근로종료일
      im_time1        = p_zbegt    "근로시작시간
      im_time2        = p_zendt    "근로종료시간
    IMPORTING
      time_diff       = lv_ex_time_n "총근로시간
    EXCEPTIONS
      from_greater_to = 1
      max_date        = 2
      OTHERS          = 3.

  IF  sy-subrc <> 0.
    CASE sy-subrc.
*      WHEN 1 OR 2.            " 입력일자&&시간 입력오류.  "20150306 XA30750, 코비스게시판에 건의들어옴(예산부와 협의하에 주석처리하기로 함)
*        P_CODE = 'E97'.
*        P_TEXT = TEXT-E97.
*        EXIT.

      WHEN OTHERS.            " 시스템오류.
        c_code = 'E98'.
        c_text = text-e98.
        EXIT.
    ENDCASE.
  ELSE.
    IF lv_ex_time_n > '480000'.  " 시간외근무 48시간 초과여부.
      c_code = 'E71'.
      c_text = text-e71.
      EXIT.
    ENDIF.
  ENDIF.

* 총근무시간 반환.
  c_za_time = lv_ex_time_n.

  c_za_time_p = ( c_za_time+0(2) * 3600 +
                  c_za_time+2(2) * 60   +
                  c_za_time+4(2) ) / 3600.
ENDFORM.                    " GET_DATE_TABLE
*&---------------------------------------------------------------------*
*&      FORM  GET_DATE_INFO
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_GS_DAYS_ZNAL  TEXT
*      <--P_GS_DAYS_DAYNR  TEXT
*      <--P_GS_DAYS_DAYTXT  TEXT
*      <--P_GS_DAYS_HOLIDAY  TEXT
*----------------------------------------------------------------------*
FORM get_date_info  USING p_znal
                 CHANGING c_daynr    "요일ID
                          c_daytxt   "요일텍스트
                          c_holiday. "휴일FLAG
*...// 근로일자별 정보
*.....// 요일ID
*.....// 요일텍스트
*.....// 휴일FLAG

  DATA : ls_holidays TYPE iscal_day,
         lt_holidays TYPE TABLE OF iscal_day.

  DATA : lv_daytxt  LIKE hrvsched-daytxt,
         lv_dayfree LIKE hrvsched-noday.

  CLEAR : lv_daytxt, lv_dayfree, ls_holidays, lt_holidays.

  CALL FUNCTION 'RH_GET_DATE_DAYNAME'
    EXPORTING
      langu   = sy-langu
      date    = p_znal
      calid   = 'KR'
    IMPORTING
      daynr   = c_daynr
      daytxt  = lv_daytxt
      dayfree = lv_dayfree.

  IF NOT lv_daytxt IS INITIAL.
    MOVE lv_daytxt+0(1) TO c_daytxt.
  ENDIF.

  CALL FUNCTION 'HOLIDAY_GET'
    EXPORTING
      holiday_calendar = 'KB'
      factory_calendar = 'KR'
      date_from        = p_znal
      date_to          = p_znal
    TABLES
      holidays         = lt_holidays.

  IF NOT lt_holidays[] IS INITIAL.
    MOVE 'X' TO c_holiday.
  ENDIF.

ENDFORM.                    " GET_DATE_INFO
*&---------------------------------------------------------------------*
*&      FORM  GET_TIME_MONEY_PART
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_GT_DAYS[]  TEXT
*      -->P_IS_ZTHRBS01  TEXT
*      -->P_I_MODE  TEXT
*      -->P_I_ACTION  TEXT
*      -->P_I_MTYPE  TEXT
*      -->P_I_ZDIFF  TEXT
*      <--P_ES_OVERTIME_DATA  TEXT
*      <--P_E_CODE  TEXT
*      <--P_E_TEXT  TEXT
*----------------------------------------------------------------------*
FORM get_time_money_part  TABLES   pt_days STRUCTURE gs_days
                          USING    ps_zthrbs01 TYPE zthrbs01
                                   p_mode
                                   p_action
                                   p_mtype
                                   p_zdiff
                          CHANGING cs_overtime_data TYPE zsh_overtime_data_n
                                   c_code
                                   c_text.

  DATA : lv_zo_time(6) TYPE n,  " 연장근무시간
         lv_zn_time(6) TYPE n,  " 야간근무시간
         lv_zh_time(6) TYPE n,  " 휴일근무시간
         lv_zd_time(6) TYPE n. " 휴일근무 (대휴발생일)

  DATA : lv_zcost  LIKE zthrcost-zcost,   " 시간당 기준단가.
         lv_zbasic LIKE zthrcost-zcost.   " 시차실비(10,000원)

  DATA : lv_day_type(2) TYPE c.
*        L_BASE_TIME   TYPE T,             " 기준근무시간.
*         LV_BASE_TIME(6) TYPE N,            " 기준근무시간. : 2011.07.01 해외출장자는 별도로
*         LV_SH_COST(1).                     " 시차실비 적용여부.

  CLEAR: c_code, c_text, gs_days.

* (연장/야간/휴일)시간 정보계산.
  PERFORM get_ot_time
    TABLES pt_days
  CHANGING lv_day_type   " 일자타입(W/F/H조합)
           lv_zo_time    " 평일시간
           lv_zn_time    " 평일야간시간
           lv_zh_time.   " 휴일시간

*...// 등급별 시간당 기준단가추출.
  PERFORM get_unit_cost
    USING ps_zthrbs01-zdung       " 등급.
              ps_zthrbs01-rdate  "신청일 // Add / 시간외 단가 인상에 따른 개선 / xa32762
          p_zdiff                 " 시뮬레이션(단가금액 인상/인하)
 CHANGING lv_zcost                 " 등급별 시간당 기준단가.
          lv_zbasic                " 시차실비.
          cs_overtime_data-zcost. " 정보용 기준단가.

*...// 징계취소에 따른 시간외단가 변경
  PERFORM get_unit_cost_exception
    USING ps_zthrbs01-pernr
          ps_zthrbs01-rdate
 CHANGING lv_zcost                 " 등급별 시간당 기준단가.
          lv_zbasic                " 시차실비.
          cs_overtime_data-zcost. " 정보용 기준단가.

*...// 근무유형별 OT 계산
  PERFORM calculation_ot
   TABLES pt_days
    USING ps_zthrbs01   " 시간외실비 신청/승인
          p_mode        " 신규('')/수정('M')
          p_action      " '저장:'SAVE', 그외:''
          lv_day_type   " 일자타입(W/F/H조합)
          lv_zcost      " 등급별 시간당 기준단가.
          lv_zbasic     " 시차실비.
          lv_zo_time    " 평일시간
          lv_zn_time    " 평일야간시간
          lv_zh_time    " 휴일시간
          p_mtype
 CHANGING c_code
          c_text
          cs_overtime_data. "시간 정보 및 금액관련 정보

*...// 시간변환 및 금액변환
  PERFORM convert_time_amt
    USING ps_zthrbs01-zgubun
          p_action
          p_mtype
 CHANGING cs_overtime_data
          c_code
          c_text.
ENDFORM.                    " GET_TIME_MONEY_PART
*&---------------------------------------------------------------------*
*&      FORM  GET_OT_TIME
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_PT_DAYS  TEXT
*      <--P_LV_DAY_TYPE  TEXT
*      <--P_LV_ZO_TIME  TEXT
*      <--P_LV_ZN_TIME  TEXT
*      <--P_LV_ZH_TIME  TEXT
*----------------------------------------------------------------------*
FORM get_ot_time  TABLES   pt_days STRUCTURE gs_days
                  CHANGING c_day_type
                           c_zo_time
                           c_zn_time
                           c_zh_time.

  DATA : lv_ex_days   TYPE i,
         lv_ex_time   TYPE t,   " 반드시 TIME형이어야 함.
         lv_pos(1)    TYPE n.                                "2011.05.03

  CLEAR : c_day_type, c_zo_time, c_zn_time, c_zh_time, gs_days.

  SORT pt_days BY znal ASCENDING.

  LOOP AT pt_days INTO gs_days.
    CLEAR : lv_ex_days, lv_ex_time.

    CALL FUNCTION 'SCOV_TIME_DIFF_46B'
      EXPORTING
        im_date1 = gs_days-znal
        im_date2 = gs_days-znal
        im_time1 = gs_days-zbegt
        im_time2 = gs_days-zendt
      IMPORTING
        ex_days  = lv_ex_days
        ex_time  = lv_ex_time.

    IF lv_ex_days = 1 OR ( gs_days-zbegt = '000000' AND gs_days-zendt = '240000' ).
      lv_ex_time+0(2) = lv_ex_time+0(2) + '24'.
    ENDIF.

    lv_pos = sy-tabix - 1.


    IF gs_days-holiday IS INITIAL.        " 평일->연장/야간시간.
      c_day_type+lv_pos(1) = 'W'.

      " 연장시간.
      gs_days-zo_time = lv_ex_time. "전체시간

      CALL FUNCTION 'ZHR_SUM_TIME_N'
        EXPORTING
          time1    = c_zo_time
          time2    = gs_days-zo_time
        IMPORTING
          time_sum = c_zo_time.

      " 야간시간(22:00~06:00) 산출.
      PERFORM get_ot_night_time USING gs_days-znal
                                      gs_days-zbegt
                                      gs_days-zendt
                             CHANGING gs_days-zn_time.

      CALL FUNCTION 'ZHR_SUM_TIME_N'
        EXPORTING
          time1    = c_zn_time
          time2    = gs_days-zn_time
        IMPORTING
          time_sum = c_zn_time.
    ELSE.                                     " 휴일->휴일시간.
      IF gs_days-daynr < 6.
        c_day_type+lv_pos(1) = 'F'.  " 주중휴일.
      ELSE.
        c_day_type+lv_pos(1) = 'H'.  " 주말휴일(토/일).
      ENDIF.

      " 휴일시간.
      gs_days-zh_time = lv_ex_time.

      CALL FUNCTION 'ZHR_SUM_TIME_N'
        EXPORTING
          time1    = c_zh_time
          time2    = gs_days-zh_time
        IMPORTING
          time_sum = c_zh_time.
    ENDIF.

    MODIFY pt_days FROM gs_days. CLEAR gs_days.
  ENDLOOP.
ENDFORM.                    " GET_OT_TIME
*&---------------------------------------------------------------------*
*&      FORM  GET_OT_NIGHT_TIME
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_GS_DAYS_ZNAL  TEXT
*      -->P_GS_DAYS_ZBEGT  TEXT
*      -->P_GS_DAYS_ZENDT  TEXT
*      <--P_GS_DAYS_ZN_TIME  TEXT
*----------------------------------------------------------------------*
FORM get_ot_night_time  USING    p_znal
                                 p_zbegt
                                 p_zendt
                        CHANGING c_zn_time.

* 야간근무시간->22:00 ~ 06:00 근무시간 산출(휴일제외)
  DATA : BEGIN OF ls_time,
               zbegt TYPE t,
               zendt TYPE t,
         END OF ls_time,
         lt_time LIKE TABLE OF ls_time.

  DATA : lv_ex_days   TYPE i,
         lv_ex_time   TYPE t,
         lv_zn_time_s TYPE i.

  CLEAR   : lv_ex_days, lv_ex_time, lv_zn_time_s, ls_time, lt_time.

  IF p_zbegt <= '060000'.
    IF p_zendt <= '060000'.
      ls_time-zbegt = p_zbegt.
      ls_time-zendt = p_zendt.
      APPEND ls_time TO lt_time. CLEAR ls_time.
    ELSEIF p_zendt <= '220000'.
      ls_time-zbegt = p_zbegt.
      ls_time-zendt = '060000'.
      APPEND ls_time TO lt_time. CLEAR ls_time.
    ELSE.
      ls_time-zbegt = p_zbegt.
      ls_time-zendt = '060000'.
      APPEND ls_time TO lt_time. CLEAR ls_time.

      ls_time-zbegt = '220000'.
      ls_time-zendt = p_zendt.
      APPEND ls_time TO lt_time. CLEAR ls_time.
    ENDIF.
  ELSEIF p_zbegt <= '220000'.
    IF p_zendt >= '220000'.
      ls_time-zbegt = '220000'.
      ls_time-zendt = p_zendt.
      APPEND ls_time TO lt_time. CLEAR ls_time.
    ENDIF.
  ELSE.
    ls_time-zbegt = p_zbegt.
    ls_time-zendt = p_zendt.
    APPEND ls_time TO lt_time. CLEAR ls_time.
  ENDIF.

  LOOP AT lt_time INTO ls_time.
    CLEAR : lv_ex_days, lv_ex_time.

    CALL FUNCTION 'SCOV_TIME_DIFF_46B'
      EXPORTING
        im_date1 = p_znal
        im_date2 = p_znal
        im_time1 = ls_time-zbegt
        im_time2 = ls_time-zendt
      IMPORTING
        ex_days  = lv_ex_days
        ex_time  = lv_ex_time.

    " 시간(HHMMSS)->초(SECONDS) 변환.
    lv_zn_time_s = lv_zn_time_s +
                  ( lv_ex_time+0(2) * 3600 +
                    lv_ex_time+2(2) * 60   +
                    lv_ex_time+4(2) ).
  ENDLOOP.

* 초(SECONDS)->시간(HHMMSS) 변환.
  PERFORM convert_seconds_to_time USING lv_zn_time_s
                                  CHANGING c_zn_time.

ENDFORM.                    " GET_OT_NIGHT_TIME
*&---------------------------------------------------------------------*
*&      FORM  CONVERT_SECONDS_TO_TIME
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_LV_ZN_TIME_S  TEXT
*      <--P_C_ZN_TIME  TEXT
*----------------------------------------------------------------------*
FORM convert_seconds_to_time  USING p_seconds
                           CHANGING c_time.

* 초(SECONDS)->시간형(HHMMSS) 변환.
  CLEAR c_time.

  c_time+0(2) = p_seconds DIV 3600.
  c_time+2(2) = ( p_seconds MOD 3600 ) DIV 60.
  c_time+4(2) = ( p_seconds MOD 3600 ) MOD 60.

ENDFORM.                    " CONVERT_SECONDS_TO_TIME
*&---------------------------------------------------------------------*
*&      FORM  GET_UNIT_COST
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_PS_ZTHRBS01_ZDUNG  TEXT
*      -->P_P_ZDIFF  TEXT
*      <--P_C_ZCOST  TEXT
*      <--P_C_ZBASIC  TEXT
*      <--P_CS_OVERTIME_DATA_ZCOST  TEXT
*----------------------------------------------------------------------*
FORM get_unit_cost  USING p_zdung
                                            p_rdate  "Add
                                            p_zdiff
                 CHANGING c_zcost
                          c_zbasic
                          c_ot_zcost.

* 등급별 시간당 기준단가/시차실비.
  DATA : ls_zthrcost TYPE zthrcost.

  CLEAR : c_zcost, c_zbasic, c_ot_zcost.

* 1) 등급별 시간당 기준단가.
  CLEAR ls_zthrcost.
  SELECT SINGLE * INTO ls_zthrcost
    FROM zthrcost
   WHERE z_ctype EQ '1'      " 기준단가.
     AND zdung   EQ p_zdung  " 등급.
    "Start-Add // 시간외 단가 변동에 따른 개선 	/ xa32762
      AND begda <= p_rdate
     AND endda => p_rdate
"End-Add
     AND zversn  EQ '1'.     " 활성버전.
  IF sy-subrc = 0.
    IF p_zdiff <> 0.     " 단가 인상/인하 시뮬레이션용.
      c_zcost = ls_zthrcost-zcost + p_zdiff.
    ELSE.
      c_zcost = ls_zthrcost-zcost.
    ENDIF.

    MOVE c_zcost TO c_ot_zcost.
  ENDIF.

* 2) 시차실비.
  CLEAR ls_zthrcost.

  SELECT SINGLE * INTO ls_zthrcost
    FROM zthrcost
   WHERE z_ctype EQ '2'      " 시차실비.
"Start-Add // 시간외 단가 변동에 따른 개선 	/ xa32762
      AND begda <= p_rdate
     AND endda => p_rdate
"End-Add
     AND zversn  EQ '1'.     " 활성버전.
  IF sy-subrc = 0.
    c_zbasic = ls_zthrcost-zcost.
  ENDIF.
ENDFORM.                    " GET_UNIT_COST
*&---------------------------------------------------------------------*
*&      FORM  GET_UNIT_COST_EXCEPTION
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_PS_ZTHRBS01_PERNR  TEXT
*      -->P_PS_ZTHRBS01_RDATE  TEXT
*      <--P_C_ZCOST  TEXT
*      <--P_C_ZBASIC  TEXT
*      <--P_CS_OVERTIME_DATA_ZCOST  TEXT
*----------------------------------------------------------------------*
FORM get_unit_cost_exception  USING    p_pernr
                                       p_rdate
                              CHANGING c_zcost
                                       c_zbasic
                                       c_overtime_data_zcost.
* XA31535 20180412 변경
  IF p_pernr = '17350'.
    IF p_rdate >= '20160701' AND p_rdate <= '20180331'.
      c_zcost = '7700'.
      c_overtime_data_zcost = '7700'.
      IF p_rdate >= '20160701' AND p_rdate <= '20171231'.
        c_zbasic = '10000'.
      ENDIF.
    ENDIF.
  ENDIF.

  IF p_pernr = '30577'.
    IF p_rdate >= '20170701' AND p_rdate <= '20180331'.
      c_zcost = '7200'.
      c_overtime_data_zcost = '7200'.
      IF p_rdate >= '20160701' AND p_rdate <= '20171231'.
        c_zbasic = '10000'.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    " GET_UNIT_COST_EXCEPTION
*&---------------------------------------------------------------------*
*&      FORM  CALCULATION_OT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_PS_ZTHRBS01  TEXT
*      -->P_P_MODE  TEXT
*      -->P_P_ACTION  TEXT
*      -->P_LV_DAY_TYPE  TEXT
*      -->P_LV_ZCOST  TEXT
*      -->P_LV_ZBASIC  TEXT
*      -->P_LV_ZO_TIME  TEXT
*      -->P_LV_ZN_TIME  TEXT
*      -->P_LV_ZH_TIME  TEXT
*      <--P_CS_OVERTIME_DATA  TEXT
*----------------------------------------------------------------------*
FORM calculation_ot TABLES pt_days STRUCTURE gs_days
                     USING ps_zthrbs01  TYPE zthrbs01
                           p_mode
                           p_action
                           p_day_type
                           p_zcost
                           p_zbasic
                           p_zo_time
                           p_zn_time
                           p_zh_time
                           p_mtype
                 CHANGING c_code
                          c_text
                          cs_overtime_data TYPE zsh_overtime_data_n.

  DATA: lv_base_time(6) TYPE n, " 기준근무시간. : 2011.07.01 해외출장자는 별도로
        lv_sh_cost(1)   TYPE c. " 시차실비 적용여부.

  CASE ps_zthrbs01-zgubun.
      "*-------------------------------------------------------------------
      "* [통상시차,당번특근,당직후근무,해외출장] --------------------------
      "*-------------------------------------------------------------------
    WHEN '1' OR '3' OR 'A' OR 'B' OR 'D' OR "1:[구] 통상시차, 3:[구] 당번당직, A:통상근무,B:시차근무,D:당번특근
         'E' OR 'T' OR 'F' OR 'G'.          "E:당직후근무, T:해외출장, F:부장급대휴, G:출제위원
      IF ps_zthrbs01-zgubun = 'T'.
        "해외출장 근무구분 텍스트 및 기준근로시간 설정
        PERFORM get_base_data_t
          USING ps_zthrbs01
                p_day_type  " 일자타입(W/F/H조합)
                p_zo_time   " 평일근무시간->연장.
                p_zh_time   " 휴일근무시간.
       CHANGING cs_overtime_data
                lv_base_time  " 기준근로시간.
                lv_sh_cost.   " 시차실비.
      ELSE.
*        " 근무구분 텍스트 및 기준근로시간 설정
        PERFORM get_base_data
          USING ps_zthrbs01
                p_day_type
                p_zo_time       " 평일근무시간->연장.
                p_zh_time       " 휴일근무시간.
       CHANGING cs_overtime_data
                lv_base_time  " 기준근로시간.
                lv_sh_cost.   " 시차실비.
      ENDIF.

      " 연장근무시간 및 실비금액 산출
      PERFORM get_overtime_data
        USING ps_zthrbs01      " ZTHRBS01 구조.
              p_zo_time        " 평일시간->연장시간
              p_zcost          " 시간당 기준단가.
              p_zbasic         " 시차실비(10,000원)
              p_day_type       " 일자타입(2)->W/F/H
              lv_sh_cost       " 시차실비대상여부.
              p_action         " 저장('SAVE') 등 사용자명령.
              p_mode           " 신규('')/변경('M')/검증('S')
     CHANGING cs_overtime_data " ZSH_OVERTIME_DATA_N 구조.
              lv_base_time     " 기준근로시간.
              c_code
              c_text.

      IF c_code+0(1) = 'E'.
        RETURN.
      ENDIF.

      " 야간근무시간 및 실비금액 산출
      PERFORM get_night_time_data
        USING ps_zthrbs01-zgubun  " 입력구분
              ps_zthrbs01-ztoich  " 퇴출초과.
              cs_overtime_data-za_time   " 총근무시간.
              p_zo_time         " 평일시간.
              p_zn_time         " 평일야간시간.
              p_zh_time         " 휴일시간.
              p_zcost           " 시간당 기준단가.
              p_day_type        " 일자타입(2)->W/F/H
              lv_sh_cost         " 시차실비대상여부.
     CHANGING cs_overtime_data-zn_time
              cs_overtime_data-zn_time_c
              cs_overtime_data-zn_money.

      " 휴일근무시간 및 실비금액 산출
      PERFORM get_holiday_time_data
       TABLES pt_days
        USING ps_zthrbs01       " ZTHRBS01 구조.
              p_zh_time         " 휴일시간.
              p_zcost           " 시간당 기준단가.
              p_day_type        " 일자타입(2)->W/F/H
              p_action          " 사용자명령
              p_mode            " 신규('')/변경('M')/검증('S')
              p_mtype
     CHANGING cs_overtime_data        " ZSH_OVERTIME_DATA_N 구조.
              c_code
              c_text.

      IF c_code+0(1) = 'E'.
        RETURN.
      ENDIF.

      " 초과근무시간 산출
      PERFORM get_excess_time
        USING ps_zthrbs01-zgubun
              ps_zthrbs01-zyuhyung
              lv_base_time
              cs_overtime_data-za_time
              cs_overtime_data-zdaeh
              cs_overtime_data-zdaeh_c
     CHANGING cs_overtime_data-zsign
              cs_overtime_data-zcho
              cs_overtime_data-zcho_m
              cs_overtime_data-ze_time  "초과근로시간
              cs_overtime_data-zr_time. "소정근로시간

      "*-------------------------------------------------------------------
      "* [교대근무 정보산출] ----------------------------------------------
      "*-------------------------------------------------------------------
    WHEN '2' OR 'C'.                                         " 교대근무=>대휴없음
      PERFORM get_shift_work_time
       TABLES pt_days
        USING ps_zthrbs01
              p_zo_time
              p_zn_time
              p_zh_time
              p_zcost
              p_day_type
     CHANGING cs_overtime_data
              c_code
              c_text.
  ENDCASE.
ENDFORM.                    " CALCULATION_OT
*&---------------------------------------------------------------------*
*&      FORM  GET_BASE_DATA_T
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_PS_ZTHRBS01  TEXT
*      -->P_P_DAY_TYPE  TEXT
*      -->P_P_ZO_TIME  TEXT
*      -->P_P_ZH_TIME  TEXT
*      -->P_P_ACTION  TEXT
*      <--P_CS_OVERTIME_DATA  TEXT
*      <--P_LV_BASE_TIME  TEXT
*      <--P_LV_SH_COST  TEXT
*----------------------------------------------------------------------*
FORM get_base_data_t  USING    ps_zthrbs01 TYPE zthrbs01
                               p_day_type
                               p_zo_time
                               p_zh_time
                      CHANGING cs_overtime_data TYPE zsh_overtime_data_n
                               c_base_time
                               c_sh_cost.

  DATA: lv_begda TYPE datum,
        lv_endda TYPE datum,
        lv_lines TYPE i,
        ls_error TYPE zsh_error,
        lt_error TYPE TABLE OF zsh_error,
        ls_zthrbs14 TYPE zthrbs14,
        lt_zthrbs14 TYPE TABLE OF zthrbs14.

  lv_begda = ps_zthrbs01-znal.       " 근로일.
  IF ps_zthrbs01-ztomo IS INITIAL.   " 익일.
    lv_endda = ps_zthrbs01-znal.
  ELSE.
    lv_endda = ps_zthrbs01-znal + 1.
  ENDIF.

*...// 해외출장자 시간외 적용기준 예외자 확인.
  SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_zthrbs14
    FROM zthrbs14
   WHERE zbegda <= lv_endda
     AND zendda >= lv_begda
     AND pernr  EQ ps_zthrbs01-pernr.

*...// 9시간 적용대상자 인지 확인하고
  IF sy-subrc = 0.
    c_base_time = '090000'.
  ELSE.
    c_base_time = '100000'.
  ENDIF.

  cs_overtime_data-zgubn   = '해외출장'.
  cs_overtime_data-ztbase  = c_base_time+0(2).
ENDFORM.                    " GET_BASE_DATA_T
*&---------------------------------------------------------------------*
*&      FORM  GET_BASE_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_PS_ZTHRBS01  TEXT
*      -->P_P_DAY_TYPE  TEXT
*      -->P_P_ZO_TIME  TEXT
*      -->P_P_ZH_TIME  TEXT
*      -->P_P_ACTION  TEXT
*      <--P_CS_OVERTIME_DATA  TEXT
*      <--P_LV_BASE_TIME  TEXT
*      <--P_LV_SH_COST  TEXT
*----------------------------------------------------------------------*
FORM get_base_data USING ps_zthrbs01 TYPE zthrbs01
                         p_day_type
                         p_zo_time
                         p_zh_time
                CHANGING cs_overtime_data  TYPE zsh_overtime_data_n
                         c_base_time
                         c_sh_cost.

* 근무구분 텍스트 및 기준근로시간 설정
  CLEAR : c_base_time, c_sh_cost.

  " 퇴출초과/당직후근무 -> 기준근로시간=0시간.
  IF NOT ps_zthrbs01-ztoich IS INITIAL OR  " 퇴출초과.
     ( ( ps_zthrbs01-zgubun = '3' AND ps_zthrbs01-zdangb IS INITIAL ) OR
       ps_zthrbs01-zgubun = 'E' ).  " 당직후근무.
*---------------------------
    IF NOT ps_zthrbs01-ztoich IS INITIAL.
      cs_overtime_data-zgubn = '퇴출초과'.
    ELSEIF ( ps_zthrbs01-zgubun = '3' AND ps_zthrbs01-zdangb IS INITIAL )
           OR ps_zthrbs01-zgubun = 'E'.
      cs_overtime_data-zgubn = '당직후근무'.
    ENDIF.
*-----------------------------
    " 당번특근->평평=18시간,평휴/휴평=9시간.
  ELSEIF ( ps_zthrbs01-zgubun = '3' AND NOT ps_zthrbs01-zdangb IS INITIAL )
         OR ps_zthrbs01-zgubun = 'D'.  " 당번특근.
*---------------------
    IF p_day_type+0(1) = 'W'.
      cs_overtime_data-zgubn = '평일당번'.

      " 평일당번->시차실비발생기준->{시작시간<= '070000'}.
      IF ps_zthrbs01-zbegt <= '070000' AND
         cs_overtime_data-za_time >= '080000'.   "총근무시간 8시간이상
        c_sh_cost = 'X'.         " 시차실비=10,000원 발생.
      ENDIF.

      "평평 -> 18시간
      IF p_day_type+1(1) = 'W'.
        c_base_time    = '180000'.  " WW(평평)
        IF cs_overtime_data-za_time >= '180000'.  "총근무시간 18시간 이상
          cs_overtime_data-ztomoh = 'X'.   "익휴
        ENDIF.
      ELSE.
        c_base_time = '090000'.     " WF/WH(평휴)
      ENDIF.
    ELSE.
      cs_overtime_data-zgubn = '휴일당번'.

      IF p_day_type+1(1) = 'W'.
        c_base_time = '090000'.  "FW/HW(휴평)

        IF p_zo_time >= '090000'.
          cs_overtime_data-ztomoh = 'X'.
        ENDIF.
      ENDIF.
    ENDIF.
*-------------------------
  ELSEIF ps_zthrbs01-zgubun = '1' OR       " 퇴출초과를 제외한 통상시차.
         ps_zthrbs01-zgubun = 'A' OR
         ps_zthrbs01-zgubun = 'B'.

*-----------------------------------
*...// 부장급 대휴/ 출제자 제외
    IF p_day_type+0(1) = 'W' OR           " 기준근무시간.
       ( p_day_type+1(1) = 'W' AND        " 연속 근무 중 하루만이라도 평일이 있으면, 평일로 보는 로직인 것 같은데..
         ps_zthrbs01-zgubun NE 'F' AND    " 시작일 기준으로 평일근무?휴일근무 판단으로 변경함 XA31535 20180711 => 원복 20180723
         ps_zthrbs01-zgubun NE 'G' ) .
      c_base_time = '090000'.
    ENDIF.

*    IF P_DAY_TYPE+0(1) = 'W' OR          " 기준근무시간.
*       ( P_DAY_TYPE+0(1) <> 'H' AND
*         P_DAY_TYPE+1(1) = 'W' AND         " 연속 근무 중 하루만이라도 평일이 있으면, 평일로 보는 로직인 것 같은데..
*         P_TCODE+0(5) NE 'ZH436' AND     " 시작일 기준으로 평일근무?휴일근무 판단으로 변경함 XA31535 20180711
*         P_TCODE+0(5) NE 'ZH437' ) .
*      C_BASE_TIME = '090000'.
*    ENDIF.
*******************
    IF ps_zthrbs01-zgubun = 'A'.
*-----      통상근무   ------*
      IF p_day_type = 'W' OR p_day_type = 'WW'.
        IF ps_zthrbs01-ztomo IS INITIAL  AND
           ps_zthrbs01-zendt <= '185900' AND
           p_zo_time > '090000'.
          cs_overtime_data-zgubn = '통상조근'.
        ELSEIF p_zo_time > '090000'.
          cs_overtime_data-zgubn = '통상평일연장'.
        ELSEIF p_zo_time = '090000'.
          IF ps_zthrbs01-ztomo IS INITIAL AND
             ps_zthrbs01-zendt <= '185900'.
            cs_overtime_data-zgubn = '통상조근'.
          ELSEIF ( ps_zthrbs01-ztomo IS INITIAL AND
                   ps_zthrbs01-zendt >= '230000' ) OR
                 NOT ps_zthrbs01-ztomo IS INITIAL.
            cs_overtime_data-zgubn = '통상야근'.
          ENDIF.
        ENDIF.
      ELSEIF p_day_type = 'WF' OR p_day_type = 'WH'.
        IF cs_overtime_data-za_time > '090000'.
          cs_overtime_data-zgubn = '통상평일연장'.
        ELSEIF cs_overtime_data-za_time = '090000'.
          cs_overtime_data-zgubn = '통상야근'.
        ENDIF.

      ENDIF.
    ELSEIF ps_zthrbs01-zgubun =  'B'.               " 시차근무.
*----   " 시차실비 발생기준->평일,평평,평휴   ---*
      IF p_day_type+0(1) = 'W' .
        IF p_day_type+1(1) = 'F' OR p_day_type+1(1) = 'H'.   " 평휴
          IF  ps_zthrbs01-zbegt <= '070000' OR
              ( cs_overtime_data-za_time >= '080000' AND
                p_zh_time < '010000' ).
            c_sh_cost = 'X'.         " 시차실비=10,000 발생.
          ENDIF.

          IF cs_overtime_data-za_time BETWEEN '080000' AND '090000'.
            IF p_zh_time >= '010000'.
              cs_overtime_data-zgubn = '석근휴전시차'.
            ELSE.
              cs_overtime_data-zgubn = '석근시차기본'.
            ENDIF.
          ELSEIF cs_overtime_data-za_time > '090000'.
            IF ps_zthrbs01-zbegt <= '080000'.
              IF p_zh_time >= '010000'.
                cs_overtime_data-zgubn = '조근휴전연장'.
              ELSE.
                cs_overtime_data-zgubn = '조근시차연장'.
              ENDIF.
            ELSEIF ps_zthrbs01-zbegt >= '100000'.
              IF p_zh_time >= '010000'.
                cs_overtime_data-zgubn = '석근휴전연장'.
              ELSE.
                cs_overtime_data-zgubn = '석근시차연장'.
              ENDIF.
            ENDIF.
          ENDIF.
        ELSE.                                              " 평일,평평
          IF ( ps_zthrbs01-zbegt <= '070000' OR
                 ( ps_zthrbs01-zendt >= '220000' OR
                   ps_zthrbs01-zendt <= '070000' ) ) AND
                  cs_overtime_data-za_time >= '080000'.
            c_sh_cost = 'X'.         " 시차실비=10,000 발생.
          ENDIF.

          IF cs_overtime_data-za_time BETWEEN '080000' AND '090000'.
*            CS_OVERTIME_DATA-ZGUBN = '시차실비'.
            IF ps_zthrbs01-zbegt <= '070000'.
              cs_overtime_data-zgubn = '조근시차기본'.
            ELSE.
              cs_overtime_data-zgubn = '석근시차기본'.
            ENDIF.
          ELSEIF cs_overtime_data-za_time > '090000'.
*            CS_OVERTIME_DATA-ZGUBN = '시차평일연장'.
            IF ps_zthrbs01-zbegt <= '080000'.
              cs_overtime_data-zgubn = '조근시차연장'.
            ELSEIF ps_zthrbs01-zbegt >= '100000'.
              cs_overtime_data-zgubn = '석근시차연장'.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

****
  ENDIF.

*    IF PS_ZTHRBS01-ZBEGT BETWEEN '080100' AND '095900'.
*      IF P_DAY_TYPE+0(1) = 'W' AND P_ZO_TIME > '090000'.
*        CS_OVERTIME_DATA-ZGUBN = '통상평일연장'.
*      ENDIF.
*    ELSE.
*      " 시차실비 발생기준->평일,평평,평휴
*      IF P_DAY_TYPE+0(1) = 'W' .
*        IF P_DAY_TYPE+1(1) = 'F' OR P_DAY_TYPE+1(1) = 'H'.
*          IF  PS_ZTHRBS01-ZBEGT <= '070000' OR
*              ( CS_OVERTIME_DATA-ZA_TIME >= '080000' AND
*                P_ZH_TIME < '010000' ).
*            C_SH_COST = 'X'.         " 시차실비=10,000 발생.
*          ENDIF.
*
*          IF CS_OVERTIME_DATA-ZA_TIME > '090000'.
*            CS_OVERTIME_DATA-ZGUBN = '시차평일연장'.
*          ELSEIF CS_OVERTIME_DATA-ZA_TIME BETWEEN '080000' AND '090000' OR
*                 P_ZH_TIME >= '010000'.
*            CS_OVERTIME_DATA-ZGUBN = '시차실비'.
*          ENDIF.
*        ELSE.
*          IF ( PS_ZTHRBS01-ZBEGT <= '070000' OR
**               ( PS_ZTHRBS01-ZBEGT <= '070000' OR
**                 PS_ZTHRBS01-ZBEGT >= '220000' )
*               ( PS_ZTHRBS01-ZENDT <= '070000' OR
*                 PS_ZTHRBS01-ZENDT >= '220000' ) ) AND
*                CS_OVERTIME_DATA-ZA_TIME >= '080000'.
*            C_SH_COST = 'X'.         " 시차실비=10,000 발생.
*          ENDIF.
*
*          IF CS_OVERTIME_DATA-ZA_TIME BETWEEN '080000' AND '090000'.
*            CS_OVERTIME_DATA-ZGUBN = '시차실비'.
*          ELSEIF CS_OVERTIME_DATA-ZA_TIME > '090000'.
*            CS_OVERTIME_DATA-ZGUBN = '시차평일연장'.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*    ENDIF.
ENDFORM.                    " GET_BASE_DATA
*&---------------------------------------------------------------------*
*&      FORM  GET_OVERTIME_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_PS_ZTHRBS01  TEXT
*      -->P_P_ZO_TIME  TEXT
*      -->P_P_ZCOST  TEXT
*      -->P_P_ZBASIC  TEXT
*      -->P_P_DAY_TYPE  TEXT
*      -->P_LV_SH_COST  TEXT
*      -->P_P_ACTION  TEXT
*      -->P_P_MODE  TEXT
*      <--P_CS_OVERTIME_DATA  TEXT
*      <--P_LV_BASE_TIME  TEXT
*      <--P_C_CODE  TEXT
*      <--P_C_TEXT  TEXT
*----------------------------------------------------------------------*
FORM get_overtime_data USING ps_zthrbs01 TYPE zthrbs01
                             p_zo_time
                             p_zcost
                             p_zbasic
                             p_day_type
                             p_sh_cost
                             p_action
                             p_mode
                    CHANGING cs_overtime_data STRUCTURE zsh_overtime_data_n
                             c_base_time       " 기준근로시간.
                             c_code
                             c_text.

* 연장근무시간 산출
* DATA : LV_EXCLUDE_T TYPE T.
  DATA : lv_exclude_t(6) TYPE n.

* 익휴 강제체크 및 선택 비활성화/디폴크 익휴체크/익휴체크제한.
  CASE ps_zthrbs01-zgubun.
    WHEN 'T'.     "해외출장중 시간외 (2011.06.27)
* 해외출장은 익휴를 발생하지 않음
      IF p_day_type = 'WW'                AND  " 평일->평일+익일
         ps_zthrbs01-ztomo IS NOT INITIAL AND  " 철야(18~익일09)포함
         ps_zthrbs01-zbegt <= '180000'    AND ps_zthrbs01-zendt >= '090000'.

        IF p_mode = 'S'.  " 시뮬레이션 모드에서는 익휴 FLAG 값 삭제
*          CS_OVERTIME_DATA-ZTOMOH = PS_ZTHRBS01-ZTOMOH.
          CLEAR : cs_overtime_data-ztomoh.
        ELSEIF ps_zthrbs01-ztomoh IS NOT INITIAL AND   "익휴 FLAG 값이 존재 & USER COMMAND가 'ZTOMOH' 또는 'SAVE'인경우
               ( p_action EQ 'ZTOMOH' OR p_action EQ 'SAVE' ).
*          CS_OVERTIME_DATA-ZTOMOH = PS_ZTHRBS01-ZTOMOH.
          CLEAR : cs_overtime_data-ztomoh.  "익휴 FLAG 값 삭제
*          PERFORM NOTIFY_MESSAGES USING TEXT-S60.  " 선택 메시지.

          " EP 메시지 전송.
          c_code = 'I'.
          c_text = text-s60.
        ELSE.
*          CS_OVERTIME_DATA-ZTOMOH    = 'X'.        " 익휴체크.
*          CS_OVERTIME_DATA-ZTOMOH_F  = 'X'.        " 강제익휴.
          CLEAR : cs_overtime_data-ztomoh, cs_overtime_data-ztomoh_f. "익휴 FLAG 값 삭제, 강제익휴 FLAG 값 삭제

          IF ps_zthrbs01-ztomoh IS NOT INITIAL.  " 익휴 선택시->메시지출력.
*            PERFORM NOTIFY_MESSAGES USING TEXT-S60.  " 해외출장중에는 익휴발생 없음

            " EP 메시지 전송.
            c_code = 'I'.
            c_text = text-s60.
          ENDIF.
        ENDIF.
*...// 평일+평일이고 연장근로시간이 18시간 이상이고 익일 FLAG 값이 존재 할때, 또는
*...// 주중휴일/주말휴일+평일 이고 근로시간 종료일이 9시보다 크고 익일 FLAG 값이 존재할때
      ELSEIF ( p_day_type = 'WW'    AND p_zo_time >= '180000' AND ps_zthrbs01-ztomo IS NOT INITIAL ) OR
             ( ( p_day_type+0(1) <> 'W'  AND p_day_type+1(1) = 'W' ) AND
                ps_zthrbs01-zendt >= '090000' AND  ps_zthrbs01-ztomo IS NOT INITIAL ).

        IF p_mode = 'S'.  " 시뮬레이션모드.
*          CS_OVERTIME_DATA-ZTOMOH = PS_ZTHRBS01-ZTOMOH.
          CLEAR : cs_overtime_data-ztomoh.   "익휴 FLAG 값 삭제
        ELSEIF ps_zthrbs01-ztomoh IS INITIAL AND
               p_action <> 'ZTOMOH' AND
               p_action <> 'SAVE'.
*          CS_OVERTIME_DATA-ZTOMOH = 'X'.    " 디폴트 익휴체크.
          CLEAR : cs_overtime_data-ztomoh. "익휴 FLAG 값 삭제
*          PERFORM NOTIFY_MESSAGES USING TEXT-S60.
          " EP 메시지 전송.
          c_code = 'I'.
          c_text = text-s60.  " 해외출장중에는 익휴선택을 못하도록
        ELSE.
*          CS_OVERTIME_DATA-ZTOMOH = PS_ZTHRBS01-ZTOMOH.
          CLEAR : cs_overtime_data-ztomoh. "익휴 FLAG 값 삭제

          IF ps_zthrbs01-ztomoh IS NOT INITIAL.
*            PERFORM NOTIFY_MESSAGES USING TEXT-S69.
            " EP 메시지 전송.
            c_code = 'I'.
            c_text = text-s60.  " 익휴선택
          ENDIF.
        ENDIF.
      ELSE.
        " 익휴선택요건 불충족 ->철야, 익일 18시간초과.
        IF ps_zthrbs01-ztomoh IS NOT INITIAL.
          CLEAR cs_overtime_data-ztomoh.  "익휴 FLAG 값 삭제

*          PERFORM NOTIFY_MESSAGES USING TEXT-S58.

          " EP 메시지 전송.
          c_code = 'I'.
          c_text = text-s58.  " 익휴선택불가.
        ENDIF.
      ENDIF.

*...// 연장근로 시간이 기준근로시간 보다 큰경우 연장근로시간 - 기준근로시간을 하여 실제 연장근로시간 계산
      IF p_zo_time > c_base_time.

        CALL FUNCTION 'ZHR_MINUS_TIME_N'
          EXPORTING
            time1    = p_zo_time
            time2    = c_base_time
          IMPORTING
            time_dif = cs_overtime_data-zo_time.
      ENDIF.
    WHEN '1' OR 'A' OR 'B'.  "[구] 통상시차, 통상, 시차 근무

      IF p_day_type = 'WW'                AND  " 평일->평일+익일
         ps_zthrbs01-ztomo IS NOT INITIAL AND  " 철야(18~익일09)포함
         ps_zthrbs01-zbegt <= '180000' AND ps_zthrbs01-zendt >= '090000'.

        IF p_mode = 'S'.  " 시뮬레이션 모드.
          cs_overtime_data-ztomoh = ps_zthrbs01-ztomoh.
        ELSEIF ps_zthrbs01-ztomoh IS INITIAL AND
               ( p_action EQ 'ZTOMOH' OR p_action EQ 'SAVE' ).
          cs_overtime_data-ztomoh = ps_zthrbs01-ztomoh.
*          PERFORM NOTIFY_MESSAGES USING TEXT-S59.  " 선택 메시지.

          " EP 메시지 전송.
          c_code = 'I'.
          c_text = text-s59.
        ELSE.
          cs_overtime_data-ztomoh    = 'X'.        " 익휴체크.
          cs_overtime_data-ztomoh_f  = 'X'.        " 강제익휴.

          IF ps_zthrbs01-ztomoh IS INITIAL.  " 익휴 미선택시->메시지출력.
*            PERFORM NOTIFY_MESSAGES USING TEXT-S57.  " 강제익휴.

            " EP 메시지 전송.
            c_code = 'I'.
            c_text = text-s57.
          ENDIF.
        ENDIF.
      ELSEIF ( p_day_type = 'WW' AND p_zo_time >= '180000' AND  ps_zthrbs01-ztomo IS NOT INITIAL ) OR
             ( ( p_day_type+0(1) <> 'W'  AND p_day_type+1(1) = 'W' ) AND
                ps_zthrbs01-zendt >= '090000' AND ps_zthrbs01-ztomo IS  NOT INITIAL ).

        IF p_mode = 'S'.  " 시뮬레이션모드.
          cs_overtime_data-ztomoh = ps_zthrbs01-ztomoh.
        ELSEIF ps_zthrbs01-ztomoh IS INITIAL AND
               p_action <> 'ZTOMOH' AND
               p_action <> 'SAVE'.
          cs_overtime_data-ztomoh = 'X'.    " 디폴트 익휴체크.
        ELSE.
          cs_overtime_data-ztomoh = ps_zthrbs01-ztomoh.

          IF ps_zthrbs01-ztomoh IS INITIAL.
*            PERFORM NOTIFY_MESSAGES USING TEXT-S59.
            " EP 메시지 전송.
            c_code = 'I'.
            c_text = text-s59.  " 익휴선택
          ENDIF.
        ENDIF.
      ELSE.
        " 익휴선택요건 불충족.->철야, 익일 18시간초과.
        IF ps_zthrbs01-ztomoh IS NOT INITIAL.
          CLEAR cs_overtime_data-ztomoh.
*          PERFORM NOTIFY_MESSAGES USING TEXT-S58.

          " EP 메시지 전송.
          c_code = 'I'.
          c_text = text-s58.  " 익휴선택불가.
        ENDIF.
      ENDIF.

      " 통상시차->기준근로시간 재산출(통상익휴)
      IF cs_overtime_data-ztomoh IS NOT INITIAL.
        IF p_day_type = 'WW'.
          IF ps_zthrbs01-zgubun = 'A'.
            cs_overtime_data-zgubn = '통상익휴'.
          ELSEIF ps_zthrbs01-zgubun = 'B'.
            cs_overtime_data-zgubn = '시차익휴'.
          ENDIF.

          c_base_time   = '180000'.
        ENDIF.
      ENDIF.

* XA30750 수정, 휴평시에 연장근무시간 산정토록 수정(2012.11.05)
      IF ps_zthrbs01-zgubun = 'A' AND ( p_day_type = 'HW' OR  p_day_type = 'FW' ) AND ps_zthrbs01-zendt < '090000' AND ps_zthrbs01-znal >= '20121201'.
        p_zo_time  = p_zo_time + c_base_time.
      ENDIF.

      IF p_zo_time > c_base_time .

        CALL FUNCTION 'ZHR_MINUS_TIME_N'
          EXPORTING
            time1    = p_zo_time
            time2    = c_base_time
          IMPORTING
            time_dif = cs_overtime_data-zo_time.
      ENDIF.
    WHEN OTHERS. "교대근무
      IF p_zo_time > c_base_time.

        CALL FUNCTION 'ZHR_MINUS_TIME_N'
          EXPORTING
            time1    = p_zo_time
            time2    = c_base_time
          IMPORTING
            time_dif = cs_overtime_data-zo_time.
      ENDIF.
  ENDCASE.

  " 퇴출초과 입력점검->1)휴일인 경우, 체크불가.
  IF ps_zthrbs01-ztoich IS  NOT INITIAL AND ps_zthrbs01-zyoil = '휴'.
    CLEAR cs_overtime_data-ztoich.
    c_code = 'E56'.
    CONCATENATE '휴일에 퇴출초과를'
                text-e56
                INTO c_text SEPARATED BY space.
    RETURN.
  ELSEIF NOT ps_zthrbs01-ztoich IS INITIAL.
    " 2) 전날_익일건+퇴출초과:익휴(X)->기준근로시간 이수여부확인
    "                         익휴('')->종료시간+1시간이내 입력불가.
    PERFORM check_ztomoh_data
      USING ps_zthrbs01-pernr
            ps_zthrbs01-znal
            ps_zthrbs01-zbegt
            cs_overtime_data-za_time
   CHANGING lv_exclude_t
            c_code
            c_text.
    IF c_code+0(1) = 'E'.
      RETURN.
    ENDIF.
  ENDIF.

* 평일 야간근무 실비 및 시차실비를 받지 않는 통상 및 시차근무자 중,
* 기준근로시간 초과, 19시~22시 구간 -> 30분단위.
  IF ( ps_zthrbs01-zgubun = '1' OR ps_zthrbs01-zgubun = 'A' OR ps_zthrbs01-zgubun = 'B') AND
       ps_zthrbs01-ztoich IS INITIAL AND
     ( ps_zthrbs01-zendt BETWEEN '190100' AND '215900' ) AND
*      P_DAY_TYPE+0(1) = 'W' AND
       p_day_type = 'W' AND p_sh_cost IS INITIAL.

    IF cs_overtime_data-zo_time+2(2) < '30'.
      cs_overtime_data-zo_time_c = cs_overtime_data-zo_time+0(2).
    ELSE.
*      CS_OVERTIME_DATA-ZO_TIME_C = CS_OVERTIME_DATA-ZO_TIME+0(2) + '0.5'.
      cs_overtime_data-zo_time_c = cs_overtime_data-zo_time+0(2) + ( 1 / 2 ).
    ENDIF.
  ELSE.
    IF lv_exclude_t IS INITIAL.
      cs_overtime_data-zo_time_c = cs_overtime_data-zo_time+0(2).
    ELSE.
      IF lv_exclude_t > cs_overtime_data-zo_time.
        CLEAR cs_overtime_data-zo_time.
      ELSE.
        CALL FUNCTION 'ZHR_MINUS_TIME_N'
          EXPORTING
            time1    = cs_overtime_data-zo_time
            time2    = lv_exclude_t
          IMPORTING
            time_dif = cs_overtime_data-zo_time.

        cs_overtime_data-zo_time_c = cs_overtime_data-zo_time+0(2).
      ENDIF.
    ENDIF.
  ENDIF.

* 평일연장근무 실비금액 산출.
* ->평일+휴일,근무시간 16:01~16:59-익일 00:01~00:59->시차실비인정.
  IF ps_zthrbs01-zgubun = 'B' AND ps_zthrbs01-zbegt BETWEEN '080100' AND '095900'.  " 시차근무입력->통상평일연장 금액계산 금지.

  ELSE.
    IF p_sh_cost IS NOT INITIAL OR
       ( ( p_day_type = 'WF' OR p_day_type = 'WH' ) AND
         ( ps_zthrbs01-zbegt BETWEEN '160100' AND '165900' AND
           ps_zthrbs01-zendt BETWEEN '000100' AND '005900' AND
           NOT ps_zthrbs01-ztomo IS INITIAL                AND
           cs_overtime_data-za_time >= '080000' ) ).

*   CS_OVERTIME_DATA-ZO_MONEY = CS_OVERTIME_DATA-ZO_TIME_C * P_ZCOST + P_ZBASIC.
      cs_overtime_data-zo_money = cs_overtime_data-zo_time_c * p_zcost.

      IF ps_zthrbs01-zgubun = 'B' OR   " 시차근무/당번특근->시차실비발생
         ps_zthrbs01-zgubun = 'D'.
        cs_overtime_data-zs_money = p_zbasic.
      ENDIF.
    ELSE.
      cs_overtime_data-zo_money = cs_overtime_data-zo_time_c * p_zcost.
    ENDIF.
  ENDIF.
ENDFORM.                    " GET_OVERTIME_DATA
*&---------------------------------------------------------------------*
*&      FORM  CHECK_ZTOMOH_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_PS_ZTHRBS01_PERNR  TEXT
*      -->P_PS_ZTHRBS01_ZNAL  TEXT
*      -->P_PS_ZTHRBS01_ZBEGT  TEXT
*      -->P_CS_OVERTIME_DATA_ZA_TIME  TEXT
*      <--P_LV_EXCLUDE_T  TEXT
*      <--P_C_CODE  TEXT
*      <--P_C_TEXT  TEXT
*----------------------------------------------------------------------*
FORM check_ztomoh_data  USING    p_pernr
                                 p_znal
                                 p_zbegt
                                 p_za_time
                        CHANGING c_exclude_t
                                 c_code
                                 c_text.
* 전날_익일건+퇴출초과 : 익휴(X)->기준근로시간 이수여부확인
*                        익휴('')->종료시간+1시간이내 입력불가.
  DATA : ls_zthrbs01     TYPE zthrbs01,
         lv_begda        TYPE datum,
         lv_holiday      TYPE cind,
         lv_day_type(2)  TYPE c,
         lv_ex_time      TYPE t,  " 사용안함
         lv_ex_time_c(6) TYPE n,
         lv_base_t       TYPE t,
*        LV_DIFF_T       TYPE T,
         lv_diff_t(6)    TYPE n,
*        LV_LACK_T       TYPE T.
         lv_lack_t(6)    TYPE n,
         lv_time1(6)     TYPE n,
         lv_time2(6)     TYPE n,
         lv_text(50)     TYPE c.

  CLEAR : c_exclude_t, c_code, c_text.

  lv_begda = p_znal - 1.    "근로일 전날

*...// 근로일 전날 시간외(진행중) 신청 내역 CHECK.
  SELECT SINGLE * INTO ls_zthrbs01
    FROM zthrbs01
   WHERE pernr EQ p_pernr
     AND znal  EQ lv_begda
     AND ztomo <> ''
     AND NOT state IN ('2','5','9','F'). "2: 삭제, 5:회수, 9:반려, F:미결
  IF sy-subrc = 0.
*...// 근로일전날 시간외 신청 여부
    CALL FUNCTION 'ZHR_GET_DAY_DATA_N'
      EXPORTING
        znal    = ls_zthrbs01-znal
      IMPORTING
        holiday = lv_holiday.

    IF lv_holiday IS INITIAL.
      lv_day_type+0(1) = 'W'.   "평일
    ELSE.
      lv_day_type+0(1) = 'H'.   "휴일
    ENDIF.

    CLEAR lv_holiday.

    CALL FUNCTION 'ZHR_GET_DAY_DATA_N'
      EXPORTING
        znal    = p_znal
      IMPORTING
        holiday = lv_holiday.

    IF lv_holiday IS INITIAL.
      lv_day_type+1(1) = 'W'.
    ELSE.
      lv_day_type+1(1) = 'H'.
    ENDIF.

    " 이전날+익일근무->평일+평일,휴일+평일인 경우만.
    IF lv_day_type = 'WW' OR lv_day_type = 'HW'.
      IF lv_day_type = 'WW'.      " 평일+평일.
        lv_base_t = '180000'.
      ELSEIF lv_day_type = 'HW'.  " 휴일+평일
        lv_base_t = '090000'.
      ENDIF.

      " 전날 총근무시간.
      CALL FUNCTION 'ZHR_GET_TIME_DIFF_N'
        EXPORTING
          im_date1  = ls_zthrbs01-znal
          im_date2  = p_znal
          im_time1  = ls_zthrbs01-zbegt
          im_time2  = ls_zthrbs01-zendt
        IMPORTING
          time_diff = lv_ex_time_c. " LV_EX_TIME.

      " (전날근무 종료시간)-(퇴출초과 시작시간).
      MOVE : p_zbegt           TO lv_time1,
             ls_zthrbs01-zendt TO lv_time2.

      CALL FUNCTION 'ZHR_MINUS_TIME_N'
        EXPORTING
          time1    = lv_time1  " P_ZBEGT
          time2    = lv_time2  " LS_ZTHRBS01-ZENDT
        IMPORTING
          time_dif = lv_diff_t.

      IF ls_zthrbs01-ztomoh IS INITIAL.
        " 익휴미체크시->1시간이내에 입력불가.

        IF lv_diff_t < '010000'.
          c_code = 'E72'.
          CONCATENATE '이전근무 종료시간 1시간 이내입니다.'
                      text-e72
                      INTO c_text SEPARATED BY space.
          RETURN.
        ENDIF.
      ELSEIF ( lv_day_type = 'WW'     AND lv_ex_time_c < '180000' ) OR
             ( lv_day_type+1(1) = 'W' AND lv_ex_time_c < '090000' ).
        " 익휴체크시->양일간 필요한 근무시간 미달이면 입력불가.
        "           ->양일간 필요한 근무시간 초과시->연장근무 삭감.

        CALL FUNCTION 'ZHR_MINUS_TIME_N'
          EXPORTING
            time1    = '180000'
            time2    = lv_ex_time_c  " LV_EX_TIME
          IMPORTING
            time_dif = lv_lack_t.

        IF p_za_time <= lv_lack_t.
          c_code = 'E72'.
          IF lv_day_type = 'WW'.
            lv_text = '양일간에 필요한 근무시간(18시간)을'.
          ELSE.
            lv_text = '일근면제에 필요한 근무시간(9시간)을'.
          ENDIF.

          CONCATENATE lv_text
                      '초과하지 못하였습니다.'
                      text-e72
                      INTO c_text SEPARATED BY space.
          RETURN.
        ELSE.
          " 양일간 필요한 근무시간 초과->연장근무포함제외.
          c_exclude_t = lv_lack_t.
          c_code = 'S52'.
          CONCATENATE '익휴(익일일근면제)선택에 따라 필요한'
                      text-s52
                      INTO c_text SEPARATED BY space.

          "PERFORM NOTIFY_MESSAGES USING C_TEXT.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    " CHECK_ZTOMOH_DATA
*&---------------------------------------------------------------------*
*&      FORM  GET_NIGHT_TIME_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_PS_ZTHRBS01_ZGUBUN  TEXT
*      -->P_PS_ZTHRBS01_ZTOICH  TEXT
*      -->P_CS_OVERTIME_DATA_ZA_TIME  TEXT
*      -->P_P_ZO_TIME  TEXT
*      -->P_L_ZN_TIME  TEXT
*      -->P_P_ZH_TIME  TEXT
*      -->P_L_ZCOST  TEXT
*      -->P_P_DAY_TYPE  TEXT
*      -->P_LV_SH_COST  TEXT
*      <--P_CS_OVERTIME_DATA_ZN_TIME  TEXT
*      <--P_CS_OVERTIME_DATA_ZN_TIME_C  TEXT
*      <--P_CS_OVERTIME_DATA_ZN_MONEY  TEXT
*----------------------------------------------------------------------*
FORM get_night_time_data  USING    p_zgubun
                                   p_ztoich
                                   p_za_time
                                   p_zo_time
                                   p_zn_time
                                   p_zh_time
                                   p_zcost
                                   p_day_type
                                   p_sh_cost
                          CHANGING c_zn_time
                                   c_zn_time_c
                                   c_zn_money.

* 퇴출초과->무조건계산.
* 평일+평일->총근무시간 9시간 이상/시차실비 8시간 이상.
  IF NOT p_ztoich IS INITIAL.
    c_zn_time   = p_zn_time.       " 야간
    c_zn_time_c = p_zn_time+0(2).  " 야간(계산용)
  ELSE.
    IF p_day_type = 'W' OR p_day_type = 'WW'.
*     IF P_ZO_TIME > '090000' OR
      IF p_zo_time >= '090000' OR                          " 9시간 이상.
       ( p_zo_time >= '080000' AND p_zgubun = 'B' ).
        c_zn_time   = p_zn_time.       " 야간
        c_zn_time_c = p_zn_time+0(2).  " 야간(계산용)
      ENDIF.
    ELSEIF p_day_type = 'WF' OR p_day_type = 'WH'.
*     IF P_ZO_TIME > '090000' OR
*        ( P_ZO_TIME >= '080000' AND P_ZGUBUN = 'B' ) OR
      IF p_zo_time >= '090000' OR
         p_za_time >= '090000' OR
         ( p_za_time >= '080000' AND p_zgubun = 'B' ).
*        ( P_ZA_TIME >= '080000' AND PI_ZH_TIME >= '010000' AND
*          P_ZGUBUN = 'B' ).
        c_zn_time   = p_zn_time.       " 야간
        c_zn_time_c = p_zn_time+0(2).  " 야간(계산용)
      ENDIF.
    ELSEIF p_day_type = 'FW' OR p_day_type = 'HW'.  " 휴평(FW,HW)
      c_zn_time   = p_zn_time.       " 야간
      c_zn_time_c = p_zn_time+0(2).  " 야간(계산용)
    ENDIF.
  ENDIF.

*  IF NOT P_ZTOICH IS INITIAL.
*    C_ZN_TIME   = P_ZN_TIME.       " 야간
*    C_ZN_TIME_C = P_ZN_TIME+0(2).  " 야간(계산용)
*  ELSE.
*    IF P_DAY_TYPE = 'W' OR P_DAY_TYPE = 'WW'.
*      IF P_ZO_TIME > '090000' OR
*         ( NOT PI_SH_COST IS INITIAL AND P_ZO_TIME >= '080000' ).
*        C_ZN_TIME   = P_ZN_TIME.       " 야간
*        C_ZN_TIME_C = P_ZN_TIME+0(2).  " 야간(계산용)
*      ENDIF.
*    ELSEIF P_DAY_TYPE = 'WF' OR P_DAY_TYPE = 'WH'.
*      IF P_ZO_TIME > '090000' OR
*         ( NOT PI_SH_COST IS INITIAL AND P_ZO_TIME >= '080000' ) OR
*         ( PI_ZH_TIME >= '010000' AND P_ZA_TIME >= '080000' ).
*        C_ZN_TIME   = P_ZN_TIME.       " 야간
*        C_ZN_TIME_C = P_ZN_TIME+0(2).  " 야간(계산용)
*      ENDIF.
*    ELSEIF P_DAY_TYPE = 'FW' OR P_DAY_TYPE = 'HW'.  " 휴평(FW,HW)
*      C_ZN_TIME   = P_ZN_TIME.       " 야간
*      C_ZN_TIME_C = P_ZN_TIME+0(2).  " 야간(계산용)
*    ENDIF.
*  ENDIF.

* 야간금액 산출
*  C_ZN_MONEY = C_ZN_TIME_C * '0.5' * P_ZCOST.
  c_zn_money = c_zn_time_c * p_zcost / 2.
ENDFORM.                    " GET_NIGHT_TIME_DATA
*&---------------------------------------------------------------------*
*&      FORM  GET_HOLIDAY_TIME_DATA
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_PT_DAYS  TEXT
*      -->P_PS_ZTHRBS01  TEXT
*      -->P_P_ZH_TIME  TEXT
*      -->P_P_ZCOST  TEXT
*      -->P_P_DAY_TYPE  TEXT
*      -->P_P_ACTION  TEXT
*      -->P_P_MODE  TEXT
*      -->P_P_MTYPE  TEXT
*      <--P_CS_OVERTIME_DATA  TEXT
*      <--P_C_CODE  TEXT
*      <--P_C_TEXT  TEXT
*----------------------------------------------------------------------*
FORM get_holiday_time_data  TABLES pt_days     STRUCTURE gs_days
                             USING ps_zthrbs01 STRUCTURE zthrbs01
                                   p_zh_time
                                   p_zcost
                                   p_day_type
                                   p_action
                                   p_mode
                                   p_mtype
                          CHANGING cs_overtime_data STRUCTURE zsh_overtime_data_n
                                   c_code
                                   c_text.

  DATA: lv_zdaeh_time(6)  TYPE n,             " 대휴발기준시간.
        lv_factor(2)      TYPE p DECIMALS 1,  " 휴일실비가산율.
        lv_zdaeh_c        TYPE i,             " 대휴발생일수.
        lv_zdaeh_auto_c   TYPE i,             " 강제대휴수.
        lv_code(3)        TYPE c,
        lv_text(50)       TYPE c,
        lv_long_text(200) TYPE c,
        lv_daynr          TYPE hrvsched-daynr,    " 일자번호.
        lv_cnt            TYPE i.

  CLEAR: lv_cnt, gs_days.

* 1.대휴발생 기준시간->통상/당직후(5시간),당번특근(6시간).
  CASE ps_zthrbs01-zgubun.
    WHEN '1' OR 'A' OR 'B' OR 'T'.    " 통상시차/해외출장
      lv_zdaeh_time = '050000'.
    WHEN '3' OR 'D' OR 'E'.      " 당번특근/당직후근무(익일휴일)
      IF ps_zthrbs01-zdangb IS NOT INITIAL.
        IF ps_zthrbs01-znal GE '20110501'.  "당번특근대휴 (6시간 -> 5시간)
          lv_zdaeh_time = '050000'.
        ELSE.
          lv_zdaeh_time = '060000'.  " 휴일당번.
        ENDIF.
      ELSE.
        lv_zdaeh_time = '050000'.  " 당직후근무(익일휴일)
      ENDIF.
  ENDCASE.

* 2.휴일근무시간&&금액 계산(팀장대휴포함->금액미발생). "XA30750
  LOOP AT pt_days INTO gs_days.
    lv_cnt = lv_cnt + 1.

    IF gs_days-holiday = 'X'.      " 휴일
      " 부장급대휴 및 출제위원 -> 금액미발생
      IF ( ps_zthrbs01-zgubun <> 'F' AND ps_zthrbs01-zgubun <> 'G' ) AND
          p_mtype <> 'M'.             " 통상시차/당번특근/당직후근무
        IF gs_days-zh_time > lv_zdaeh_time.  " 대휴발생기준 초과시.

          gs_days-zd_time = gs_days-zh_time. " 대휴발생일 근무시간

          IF gs_days-daynr < 6.
            " 주중휴일.
            IF p_action  = 'SAVE' AND ps_zthrbs01-zdaeh IS INITIAL.
            ELSE.
              IF p_action <> 'ZDAEH'. "XA30750 수정. 주중공휴일 경우, 기본으로 대휴 선택토록
                ps_zthrbs01-zdaeh = 'X'.
              ENDIF.
            ENDIF.

            IF ps_zthrbs01-zdaeh IS INITIAL.  "->사용자 대휴 미선택한 경우.
*              L_FACTOR = '1.5'.        " 주중휴일/미대휴
              lv_factor = 3 / 2.         " 주중휴일/미대휴
            ELSE.
              " 동일기준일 대휴존재여부.
              PERFORM check_holiday USING gs_days-pernr
                                          gs_days-znal    "시작/익일
                                          ps_zthrbs01-znal  "시작일
                                          ps_zthrbs01-rdate
                                          ps_zthrbs01-seqnr
                                          p_mode
                                    CHANGING lv_code
                                             lv_long_text.
              IF lv_code+0(1) <> 'I'.
                ADD 1 TO lv_zdaeh_c.      " 대휴발생일수.
*                L_FACTOR = '0.5'.        " 주중휴일/대휴선택
                lv_factor = 1 / 2.         " 주중휴일/대휴선택

              ELSE.
*                L_FACTOR = '1.5'.        " 주중휴일/미대휴
                lv_factor = 3 / 2.         " 주중휴일/미대휴
              ENDIF.
            ENDIF.
          ELSE.
            " 주말휴일(토/일)
            PERFORM check_holiday USING gs_days-pernr
                                        gs_days-znal    "시작일/익일
                                        ps_zthrbs01-znal  "근무시작일
                                        ps_zthrbs01-rdate
                                        ps_zthrbs01-seqnr
                                        p_mode
                                  CHANGING lv_code
                                           lv_long_text.
            IF lv_code+0(1) <> 'I'.
              ADD 1 TO lv_zdaeh_c.       " 대휴발생일수.
              ADD 1 TO lv_zdaeh_auto_c.  " 강제대휴수.
*              L_FACTOR = '0.5'.         " 주중휴일/대휴선택
              lv_factor = 1 / 2.          " 주중휴일/대휴선택
            ELSE.
*              L_FACTOR = '1.5'.        " 주중휴일/미대휴
              lv_factor = 3 / 2.         " 주중휴일/미대휴
            ENDIF.
          ENDIF.

          IF lv_zdaeh_c = 1.
            " 대휴발생 기준일.
            cs_overtime_data-zdday   = gs_days-znal.
            cs_overtime_data-zd_time = gs_days-zd_time.
*          ELSEIF L_ZDAEH_C = 0.
*            CLEAR : CS_OVERTIME_DATA-ZD_TIME.
          ENDIF.
        ELSE.
          " 대휴발생기준 미달->휴일근무.
*          L_FACTOR = '1.5'.            " 휴일근무
          lv_factor = 3 / 2.             " 휴일근무
        ENDIF.

        " WF/WH 인경우, 총근무시간 >= 8시간 부터 계산 (시차근무)
        " WF/WH 인경우, 총근무시간 > 9시간 부터 계산 (통상근무)
        IF p_day_type = 'WF' OR p_day_type = 'WH'.
*          IF CS_OVERTIME_DATA-ZA_TIME >= '080000'.
          IF ( cs_overtime_data-za_time >= '080000' AND
                ps_zthrbs01-zgubun = 'B') OR
              ( cs_overtime_data-za_time >= '090000' AND                 "XA31535 20180710 수정 '>'   -->   '>='
                ( ps_zthrbs01-zgubun = 'A' OR
                  ps_zthrbs01-zgubun = 'D' OR
                  ps_zthrbs01-zgubun = 'E' OR
                  ps_zthrbs01-zgubun = 'T' ) )  OR "해외출장시 휴일근무실비 가능토록 수정 XA30750
               ( cs_overtime_data-ztoich NE '' AND
                 ( ps_zthrbs01-zgubun = 'A' OR
                   ps_zthrbs01-zgubun = 'B' ) ).
            cs_overtime_data-zh_time_c = cs_overtime_data-zh_time_c + gs_days-zh_time+0(2).
            cs_overtime_data-zh_money  = cs_overtime_data-zh_money + gs_days-zh_time+0(2) * lv_factor * p_zcost.
* 2011.05.04
            cs_overtime_data-zd_money  = cs_overtime_data-zd_time+0(2) * lv_factor * p_zcost.
          ENDIF.
        ELSE.
          cs_overtime_data-zh_time_c = cs_overtime_data-zh_time_c + gs_days-zh_time+0(2).
          cs_overtime_data-zh_money = cs_overtime_data-zh_money + gs_days-zh_time+0(2) * lv_factor * p_zcost.
* 2011.05.04
          IF gs_days-zd_time > 0.  "대휴정산 내역이 있으면
            cs_overtime_data-zd_money = cs_overtime_data-zd_time+0(2) * lv_factor * p_zcost.
          ENDIF.
        ENDIF.
      ELSE.
        " 팀장대휴신청.
        IF gs_days-zh_time > lv_zdaeh_time.

          gs_days-zd_time = gs_days-zh_time.  "대휴발생일 근무시간

          " 동일기준일 대휴존재여부.
          PERFORM check_holiday USING gs_days-pernr
                                      gs_days-znal    "시작일/익일
                                      ps_zthrbs01-znal  "근무시작일
                                      ps_zthrbs01-rdate
                                      ps_zthrbs01-seqnr
                                      p_mode
                                CHANGING lv_code
                                         lv_long_text.
          IF lv_code+0(1) <> 'I'.
            ADD 1 TO lv_zdaeh_c.       " 대휴발생일수.
            ADD 1 TO lv_zdaeh_auto_c.  " 강제대휴수.
          ENDIF.

          IF lv_zdaeh_c = 1.
            " 대휴발생 기준일.
            cs_overtime_data-zdday   = gs_days-znal.
            cs_overtime_data-zd_time = gs_days-zd_time.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.

* 5.적용기준이 동일한 휴일->휴일시간 합산 재계산 (대휴미발생만적용)
*   -> 휴일+휴일이면서, 총근무시간 > 5시간, 6시간 이면 대휴발생.(대휴미발생시)
  IF ( p_day_type = 'FF' OR p_day_type = 'HH' ) AND
       cs_overtime_data-zdaeh IS INITIAL AND
       lv_zdaeh_c = 0.
    IF p_zh_time > lv_zdaeh_time.
      " 동일기준일 대휴존재여부.

      PERFORM check_holiday USING ps_zthrbs01-pernr
                                  ps_zthrbs01-znal    "시작/익일
                                  ps_zthrbs01-znal  "시작일
                                  ps_zthrbs01-rdate
                                  ps_zthrbs01-seqnr
                                  p_mode
                            CHANGING lv_code
                                     lv_long_text.
      IF lv_code+0(1) <> 'I'.
        " 대휴 미선택 가능.
        IF p_day_type+0(1) = 'F' AND ps_zthrbs01-zdaeh IS INITIAL.

        ELSE.
          CLEAR : cs_overtime_data-zh_time_c,  cs_overtime_data-zh_money.

          lv_zdaeh_c     = 1.
          cs_overtime_data-zdaeh = 'X'.

          cs_overtime_data-zd_time = p_zh_time.                      "2011.05.03

          IF p_day_type+0(1) = 'H'.
            lv_zdaeh_auto_c  = 1.
            cs_overtime_data-zdaeh_f = 'X'.
          ENDIF.
          cs_overtime_data-zh_time_c = p_zh_time+0(2).
          cs_overtime_data-zh_money  = cs_overtime_data-zh_time_c * p_zcost / 2.
          cs_overtime_data-zd_money  = cs_overtime_data-zd_time+0(2) * p_zcost / 2.

        ENDIF.
      ENDIF.
    ELSE.
      CLEAR : cs_overtime_data-zh_time_c, cs_overtime_data-zh_money.

      cs_overtime_data-zh_time_c = p_zh_time+0(2).
      cs_overtime_data-zh_money  = cs_overtime_data-zh_time_c * lv_factor * p_zcost.
    ENDIF.
  ELSEIF ( p_day_type = 'FH' OR p_day_type = 'HF' ) AND
          cs_overtime_data-zdaeh IS INITIAL AND
          lv_zdaeh_c = 0.
    IF p_zh_time > lv_zdaeh_time.
      " 동일기준일 대휴존재여부.
      PERFORM check_holiday USING ps_zthrbs01-pernr
                                  ps_zthrbs01-znal    "시작/익일
                                  ps_zthrbs01-znal  "시작일
                                  ps_zthrbs01-rdate
                                  ps_zthrbs01-seqnr
                                  p_mode
                            CHANGING lv_code
                                     lv_long_text.
      IF lv_code+0(1) <> 'I'.
        " 대휴 미선택 가능.
        IF p_day_type+0(1) = 'F' AND ps_zthrbs01-zdaeh IS INITIAL.

        ELSE.
          CLEAR : cs_overtime_data-zh_time_c, cs_overtime_data-zh_money.

          lv_zdaeh_c = 1.
          cs_overtime_data-zdaeh = 'X'.

          cs_overtime_data-zd_time = p_zh_time.                      "2011.05.03

          IF p_day_type+0(1) = 'H'.
            lv_zdaeh_auto_c  = 1.
            cs_overtime_data-zdaeh_f = 'X'.
          ENDIF.
          cs_overtime_data-zh_time_c = p_zh_time+0(2).
          cs_overtime_data-zh_money  = cs_overtime_data-zh_time_c * p_zcost / 2.

          cs_overtime_data-zd_money  = cs_overtime_data-zd_time+0(2) * p_zcost / 2.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.

* 3.대휴 선택제한->사용자 대휴선택(PS_ZTHRBS01-ZDAEH = 'X').
  IF NOT ps_zthrbs01-zdaeh IS INITIAL AND lv_zdaeh_c = 0.
    IF lv_code+0(1) = 'I'.                                   " 휴일1회 대휴제한
*      PERFORM NOTIFY_MESSAGES USING L_LONG_TEXT.

      " EP 메시지 전송.
      c_code = 'I'.
      c_text = lv_long_text.
    ELSE.                   " 대휴미발생.
      IF ( ps_zthrbs01-zgubun = '1' OR
           ps_zthrbs01-zgubun = 'A' OR
           ps_zthrbs01-zgubun = 'B' ) OR
       ( ( ps_zthrbs01-zgubun = '3' AND ps_zthrbs01-zdangb IS INITIAL ) OR
         ps_zthrbs01-zgubun = 'E' ).
        lv_text = '휴일 5시간'.
      ELSEIF ( ps_zthrbs01-zgubun = '3' AND
               NOT ps_zthrbs01-zdangb IS INITIAL ) OR
             ps_zthrbs01-zgubun = 'D' .
        lv_text = '휴일 5시간'.
      ENDIF.
      CONCATENATE lv_text
                  text-s53
                  INTO lv_long_text SEPARATED BY space.

*      PERFORM NOTIFY_MESSAGES USING L_LONG_TEXT.

      " EP 메시지 전송.
      c_code = 'I'.
      c_text = lv_long_text.
    ENDIF.
  ENDIF.

* 4.강제대휴발생->대휴선택 디폴트 선택 및 비활성화 플래그설정.
  IF lv_zdaeh_auto_c > 0.  " 강제대휴 발생
    cs_overtime_data-zdaeh   = 'X'.
    cs_overtime_data-zdaeh_f = 'X'.
  ELSEIF lv_zdaeh_c > 0 AND NOT ps_zthrbs01-zdaeh IS INITIAL.
    cs_overtime_data-zdaeh = 'X'.
    cs_overtime_data-zd_time = p_zh_time.   "2011.05.03  (?)
  ENDIF.

* 6.근무구분 텍스트 설정.
  IF ( ps_zthrbs01-zgubun = '1' OR
       ps_zthrbs01-zgubun = 'A' OR
       ps_zthrbs01-zgubun = 'B' ) AND
     ( p_day_type+0(1) = 'F' OR p_day_type+0(1) = 'H' ).
    IF  cs_overtime_data-zdaeh IS INITIAL.
      cs_overtime_data-zgubn = '휴일근무'.
    ELSE.
      cs_overtime_data-zgubn = '휴일대휴평'.
    ENDIF.
  ENDIF.

* 7.휴일총근무시간&&대휴발생일수 설정.
  cs_overtime_data-zh_time  = p_zh_time.     " 휴일근무시간(총시간)
* 2011.05.03
  cs_overtime_data-zdaeh_c  = lv_zdaeh_c.     " 대휴발생일수.

* 8.메시지 텍스트 전송
  " 1)주말휴일 대휴미선택시 -> 강제선택 메시지,기준단가 50% 지급
  " 2)주중휴일 대휴선택시   -> 금액 50% 지급
  CLEAR lv_text.

*  IF ( P_TCODE+0(5) <> 'ZH415'
*       AND P_TCODE+0(5) <> 'ZH436'
*       AND P_TCODE+0(5) <> 'ZH437'                          "2011.06.10
*       AND P_TCODE+0(5) <> 'ZH439'
*      )
*        AND  P_MTYPE <> 'M'.
  IF ( ps_zthrbs01-zgubun <> 'F' AND ps_zthrbs01-zgubun <> 'G' ) AND
      p_mtype <> 'M'.
    IF ps_zthrbs01-zdaeh IS INITIAL AND
       cs_overtime_data-zdaeh_f IS NOT INITIAL. " 강제대휴.
      IF ps_zthrbs01-zgubun = '1' OR
         ps_zthrbs01-zgubun = 'A' OR
         ps_zthrbs01-zgubun = 'B'.
        lv_text = '휴일 5시간'.
      ELSE.
        lv_text = '휴일 5시간'.
      ENDIF.
      CONCATENATE lv_text
                  text-s54
                  INTO lv_long_text SEPARATED BY space.

*      PERFORM NOTIFY_MESSAGES USING L_LONG_TEXT.

      " EP 메시지 전송.
      c_code = 'I'.
      c_text = lv_long_text.
    ENDIF.
  ELSE.      " 팀장대휴신청. + 출제위원 대휴
    CLEAR : cs_overtime_data-zo_money, cs_overtime_data-zn_money, cs_overtime_data-zh_money.

    "XA30750 수정 (예산-1547 (2015.09.24.) 요청에 의해 부장급 이상의 경우, 대휴 발생하지 않아도 입력은 가능 토록 수정)
*    IF CS_OVERTIME_DATA-ZDAEH IS INITIAL.
*      P_CODE = 'E53'.
*      P_TEXT = TEXT-E53.  " 5시간 이하->대휴미발생,저장금지
*      EXIT.
*    ELSE.
    IF ps_zthrbs01-zdaeh IS INITIAL AND
       cs_overtime_data-zdaeh_f IS NOT INITIAL.
      lv_text = '휴일 5시간'.
      CONCATENATE lv_text
                  text-s55
                  INTO lv_long_text SEPARATED BY space.

*      PERFORM NOTIFY_MESSAGES USING L_LONG_TEXT.

      " EP 메시지 전송.
      c_code = 'I'.
      c_text = lv_long_text.
    ENDIF.
*    ENDIF.
  ENDIF.
ENDFORM.                    " GET_HOLIDAY_TIME_DATA
*&---------------------------------------------------------------------*
*&      FORM  CHECK_HOLIDAY
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_GS_DAYS_PERNR  TEXT
*      -->P_GS_DAYS_ZNAL  TEXT
*      -->P_PS_ZTHRBS01_ZNAL  TEXT
*      -->P_PS_ZTHRBS01_RDATE  TEXT
*      -->P_PS_ZTHRBS01_SEQNR  TEXT
*      -->P_P_MODE  TEXT
*      <--P_LV_CODE  TEXT
*      <--P_LV_LONG_TEXT  TEXT
*----------------------------------------------------------------------*
FORM check_holiday  USING    p_pernr
                             p_znal
                             p_s_znal
                             p_rdate
                             p_seqnr
                             p_mode
                    CHANGING c_code
                             c_text.
* 역일기준 휴일대휴는 1회 제한.
  DATA : BEGIN OF ls_zthrbs01,
           pernr LIKE zthrbs01-pernr,
           rdate LIKE zthrbs01-rdate,
           seqnr LIKE zthrbs01-seqnr,
           znal  LIKE zthrbs01-znal,
           zdaeh LIKE zthrbs01-zdaeh,
           zdday LIKE zthrbs01-zdday,
   END OF ls_zthrbs01,
          lt_zthrbs01 LIKE TABLE OF ls_zthrbs01.

  DATA : lv_cnt TYPE i.

  CLEAR : c_code, c_text.

  IF p_s_znal >= '20070601'.
    " 2007.6.1이후->대휴발생기준일(ZDDAY)=실대휴발생 기준일
    SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_zthrbs01
      FROM zthrbs01
     WHERE pernr = p_pernr
       AND zdday = p_znal
       AND zdaeh NE ''
       AND NOT state IN ('2','5','9','F').
  ELSE.
    " 2007.6.1이전->대휴발생기준일(ZDDAY)=근무 시작일(ZNAL)
    SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_zthrbs01
      FROM zthrbs01
     WHERE pernr = p_pernr   " 사번.
       AND znal = p_s_znal
       AND zdaeh NE ''
       AND NOT state IN ('2','5','9','F').
  ENDIF.

  " 변경/시뮬레이션모드->대상건 제외함.
  IF p_mode = 'M' OR p_mode = 'S'.
    DELETE lt_zthrbs01 WHERE pernr = p_pernr
                         AND rdate = p_rdate
                         AND seqnr = p_seqnr.
  ENDIF.

  DESCRIBE TABLE lt_zthrbs01 LINES lv_cnt.
  IF lv_cnt > 0.
    c_code = 'I56'.
    c_text = text-s56.
  ENDIF.
ENDFORM.                    " CHECK_HOLIDAY
*&---------------------------------------------------------------------*
*&      FORM  GET_EXCESS_TIME
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_PS_ZTHRBS01_ZGUBUN  TEXT
*      -->P_PS_ZTHRBS01_ZYUHYUNG  TEXT
*      -->P_P_BASE_TIME  TEXT
*      -->P_CS_OVERTIME_DATA_ZA_TIME  TEXT
*      -->P_CS_OVERTIME_DATA_ZDAEH  TEXT
*      -->P_CS_OVERTIME_DATA_ZDAEH_C  TEXT
*      <--P_CS_OVERTIME_DATA_ZSIGN  TEXT
*      <--P_CS_OVERTIME_DATA_ZCHO  TEXT
*      <--P_CS_OVERTIME_DATA_ZCHO_M  TEXT
*      <--P_CS_OVERTIME_DATA_ZE_TIME  TEXT
*      <--P_CS_OVERTIME_DATA_ZR_TIME  TEXT
*----------------------------------------------------------------------*
FORM get_excess_time  USING    p_zgubun
                               p_zyuhyung
                               p_base_time
                               p_za_time
                               p_zdaeh
                               p_zdaeh_c
                      CHANGING c_zsign
                               c_zcho
                               c_zcho_m
                               c_ze_time
                               c_zr_time.

* 초과시간=(종료시간-시작시간)-기준근무시간

  DATA : lv_zcho_base(6) TYPE n,              " 초과시간산출용-기준시간.
         lv_zcho_t(6)    TYPE n.              " 초과시간산출용.

  lv_zcho_base = p_base_time.

***  IF P_ZDAEH IS NOT INITIAL.  " 대휴발생분->초과기준근로시간.
***    IF P_ZDAEH_C = 1.
***      LV_ZCHO_BASE = '090000'.
***    ELSEIF P_ZDAEH_C = 2.
***      LV_ZCHO_BASE = '180000'.
***    ENDIF.
***
**** 대휴발생(익일-평일) 계산오류 발생(20081214)
****    IF P_ZDAEH_C = 1.
****      L_ZCHO_BASE = '090000'.
****    ELSEIF P_ZDAEH_C = 2.
****      L_ZCHO_BASE = '180000'.
****    ENDIF.
****
****    CALL FUNCTION 'ZHR_SUM_TIME_N'
****      EXPORTING
****        TIME1    = P_BASE_TIME
****        TIME2    = L_ZCHO_BASE
****      IMPORTING
****        TIME_SUM = L_ZCHO_BASE.
***  ELSE.
***    LV_ZCHO_BASE = P_BASE_TIME.
***  ENDIF.

  IF p_za_time > lv_zcho_base.

    CALL FUNCTION 'ZHR_MINUS_TIME_N'
      EXPORTING
        time1    = p_za_time
        time2    = lv_zcho_base
      IMPORTING
        time_dif = lv_zcho_t.
  ELSE.
    IF  p_zdaeh IS NOT INITIAL.
      CALL FUNCTION 'ZHR_MINUS_TIME_N'
        EXPORTING
          time1    = lv_zcho_base
          time2    = p_za_time
        IMPORTING
          time_dif = lv_zcho_t.

      c_zsign = '-'.
    ENDIF.
  ENDIF.

  IF lv_zcho_t = '000000'.
    CLEAR c_zsign.
  ELSE.
    c_zcho   = lv_zcho_t+0(2).
    c_zcho_m = lv_zcho_t+2(2).
    c_zr_time = lv_zcho_base.
    c_ze_time = lv_zcho_t.
  ENDIF.

ENDFORM.                    " GET_EXCESS_TIME
*&---------------------------------------------------------------------*
*&      FORM  GET_SHIFT_WORK_TIME
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_PT_DAYS  TEXT
*      -->P_PS_ZTHRBS01  TEXT
*      -->P_P_ZO_TIME  TEXT
*      -->P_P_ZN_TIME  TEXT
*      -->P_P_ZH_TIME  TEXT
*      -->P_P_ZCOST  TEXT
*      -->P_P_DAY_TYPE  TEXT
*      <--P_CS_OVERTIME_DATA  TEXT
*      <--P_C_CODE  TEXT
*      <--P_C_TEXT  TEXT
*----------------------------------------------------------------------*
FORM get_shift_work_time TABLES pt_days     STRUCTURE gs_days
                          USING ps_zthrbs01 STRUCTURE zthrbs01
                                p_zo_time
                                p_zn_time
                                p_zh_time
                                p_zcost
                                p_day_type
                       CHANGING cs_overtime_data STRUCTURE zsh_overtime_data_n
                                c_code
                                c_text.

  DATA : lv_zh_time_f(6) TYPE n,            " 주중공휴일시간.
         lv_zh_time_h(6) TYPE n.            " 주말공휴일시간.

  CLEAR: gs_days.

  CASE ps_zthrbs01-zyuhyung.
      " 철야('01')->야간50%+주중휴일150%/주말휴일50%
      " 휴일('02')->주중휴일150%/주말휴일50%,야간적용안함,대휴없음.
    WHEN '01' OR '02'.
      IF ps_zthrbs01-zyuhyung = '01'.          " 철야->야간시간계산.
        CLEAR p_zo_time.

        cs_overtime_data-zn_time   = p_zn_time.
        cs_overtime_data-zn_time_c = p_zn_time+0(2).           " 야간시간.
*           CS_OVERTIME_DATA-ZN_MONEY  = CS_OVERTIME_DATA-ZN_TIME_C * '0.5' * L_ZCOST.
        cs_overtime_data-zn_money  = cs_overtime_data-zn_time_c * p_zcost * 1 / 2.
      ELSE.  " 휴일 시작일 종료일이 휴일인 경우만 가능
        CLEAR : p_zo_time, p_zn_time.
        LOOP AT pt_days INTO gs_days.
          IF gs_days-holiday = ''.
            c_code = 'E73'.
            c_text = text-e73.
            RETURN.
          ENDIF.
        ENDLOOP.
      ENDIF.


      " 공통->휴일근무시간 및 금액계산(주중휴일-150%,주말휴일-50%).
      CLEAR : lv_zh_time_f, lv_zh_time_h.

      cs_overtime_data-zh_time = p_zh_time.
*
      LOOP AT pt_days INTO gs_days.
        IF gs_days-holiday = 'X'.
          IF gs_days-daynr < 6.                 " 주중휴일 150%.
            CALL FUNCTION 'ZHR_SUM_TIME_N'
              EXPORTING
                time1    = lv_zh_time_f
                time2    = gs_days-zh_time
              IMPORTING
                time_sum = lv_zh_time_f. " 주중휴일시간합산.
          ELSE.                                         " 주말휴일 50%.
            CALL FUNCTION 'ZHR_SUM_TIME_N'
              EXPORTING
                time1    = lv_zh_time_h
                time2    = gs_days-zh_time
              IMPORTING
                time_sum = lv_zh_time_h. " 주말휴일시간합산.
          ENDIF.
        ENDIF.
      ENDLOOP.
      cs_overtime_data-zh_time_c = lv_zh_time_f+0(2) + lv_zh_time_h+0(2).
*         CS_OVERTIME_DATA-ZH_MONEY = ( P_ZH_TIME_F+0(2) * '1.5' * L_ZCOST ) +
*                            ( P_ZH_TIME_H+0(2) * '0.5' * L_ZCOST ).
      cs_overtime_data-zh_money = ( lv_zh_time_f+0(2) * p_zcost * 3 / 2 ) +
                         ( lv_zh_time_h+0(2) * p_zcost * 1 / 2 ).

      " 대근('03'),비번초과('04')->연장100%+야간50%/휴일150%+야간제외.
    WHEN '03' OR '04'.
      cs_overtime_data-zo_time   = p_zo_time.
      cs_overtime_data-zn_time   = p_zn_time.
      cs_overtime_data-zh_time   = p_zh_time.
*
      cs_overtime_data-zo_time_c = p_zo_time+0(2).  " 연장시간.
      cs_overtime_data-zn_time_c = p_zn_time+0(2).  " 야간시간.
      cs_overtime_data-zh_time_c = p_zh_time+0(2).  " 휴일시간.
*         CS_OVERTIME_DATA-ZO_MONEY  = CS_OVERTIME_DATA-ZO_TIME_C * '1.0' * L_ZCOST.
*         CS_OVERTIME_DATA-ZN_MONEY  = CS_OVERTIME_DATA-ZN_TIME_C * '0.5' * L_ZCOST.
*         CS_OVERTIME_DATA-ZH_MONEY  = CS_OVERTIME_DATA-ZH_TIME_C * '1.5' * L_ZCOST.
      cs_overtime_data-zo_money  = cs_overtime_data-zo_time_c * p_zcost.            "연장시간
      cs_overtime_data-zn_money  = cs_overtime_data-zn_time_c * p_zcost * 1 / 2.    "야간근무
      cs_overtime_data-zh_money  = cs_overtime_data-zh_time_c * p_zcost * 3 / 2.    "휴일근무

      " 초과시간산출=(종료시간-시작시간)->대근/비번초과만.
      cs_overtime_data-zcho   = cs_overtime_data-za_time+0(2).
      cs_overtime_data-zcho_m = cs_overtime_data-za_time+2(2).
      cs_overtime_data-ze_time = cs_overtime_data-za_time.
  ENDCASE.


*** 20181013 주석처리
*  " 교대근무 근무구분 텍스트정보 추출.
*  DATA : lv_zgubun(1).
*
*  MOVE '2' TO lv_zgubun.
*
*  CALL FUNCTION 'ZHR_GET_WORKTYPE_TEXT_N'
*    EXPORTING
*      zgubun    = lv_zgubun  " PS_ZTHRBS01-ZGUBUN
*      znal      = ps_zthrbs01-znal
*      zktype    = ps_zthrbs01-zktype
*      zyuhyung  = ps_zthrbs01-zyuhyung
*      ztomo     = ps_zthrbs01-ztomo
*    IMPORTING
*      zgubn     = cs_overtime_data-zgubn  " 근무구분 텍스트.
*    EXCEPTIONS
*      not_found = 1
*      OTHERS    = 2.
*
*  CASE sy-subrc.
*    WHEN 1.            " 평일/휴전->휴일근무유형 선택시 오류발생.
*      c_code = 'E74'.
*      c_text = text-e74.
*      EXIT.
*  ENDCASE.
ENDFORM.                    " GET_SHIFT_WORK_TIME
*&---------------------------------------------------------------------*
*&      FORM  CONVERT_TIME_AMT
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_PS_ZTHRBS01_ZGUBUN  TEXT
*      -->P_P_ACTION  TEXT
*      <--P_CS_OVERTIME_DATA  TEXT
*      <--P_C_CODE  TEXT
*      <--P_C_TEXT  TEXT
*----------------------------------------------------------------------*
FORM convert_time_amt  USING    p_zgubun
                                p_action
                                p_mtype
                       CHANGING cs_overtime_data STRUCTURE zsh_overtime_data_n
                                c_code
                                c_text.

* 시간변환(HHMMSS->HOURS)
  cs_overtime_data-zo_time_p = ( cs_overtime_data-zo_time+0(2) * 3600 +
                        cs_overtime_data-zo_time+2(2) * 60   +
                        cs_overtime_data-zo_time+4(2) ) / 3600.

  cs_overtime_data-zn_time_p = ( cs_overtime_data-zn_time+0(2) * 3600 +
                        cs_overtime_data-zn_time+2(2) * 60   +
                        cs_overtime_data-zn_time+4(2) ) / 3600.

  cs_overtime_data-zh_time_p = ( cs_overtime_data-zh_time+0(2) * 3600 +
                        cs_overtime_data-zh_time+2(2) * 60   +
                        cs_overtime_data-zh_time+4(2) ) / 3600.

* 금액 변환(통화)
  cs_overtime_data-zmoney      = cs_overtime_data-zo_money +
                        cs_overtime_data-zn_money +
                        cs_overtime_data-zh_money +
                        cs_overtime_data-zs_money.

  cs_overtime_data-zmoney_c    = cs_overtime_data-zmoney   / 100.
  cs_overtime_data-zo_money_c  = cs_overtime_data-zo_money / 100.
  cs_overtime_data-zn_money_c  = cs_overtime_data-zn_money / 100.
  cs_overtime_data-zh_money_c  = cs_overtime_data-zh_money / 100.
  cs_overtime_data-zs_money_c  = cs_overtime_data-zs_money / 100.
  cs_overtime_data-waers       = 'KRW'.

  " 실비금액=0 -> 근무구분 텍스트 삭제.
  IF (  p_zgubun <> 'F' AND p_zgubun  <> 'G') AND   p_mtype <> 'M'.
    IF cs_overtime_data-zmoney = 0.
      CLEAR : cs_overtime_data-zgubn.
      IF p_action = 'SAVE'.
        c_code = 'E22'.
        c_text = text-e22.
        EXIT.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    " CONVERT_TIME_AMT
*&---------------------------------------------------------------------*
*&      FORM  CHECK_BKTIME
*&---------------------------------------------------------------------*
*       TEXT
*----------------------------------------------------------------------*
*      -->P_IS_ZTHRBS01_ZPBEG1  TEXT
*      -->P_IS_ZTHRBS01_ZPBTM1  TEXT
*      -->P_IS_ZTHRBS01_ZPEND1  TEXT
*      -->P_IS_ZTHRBS01_ZPETM1  TEXT
*      -->P_IS_ZTHRBS01_ZPBEG1  TEXT
*      -->P_IS_ZTHRBS01_ZPBTM1  TEXT
*      -->P_IS_ZTHRBS01_ZPEND1  TEXT
*      -->P_IS_ZTHRBS01_ZPETM1  TEXT
*      -->P_IS_ZTHRBS01_ZPBEG1  TEXT
*      -->P_IS_ZTHRBS01_ZPBTM1  TEXT
*      -->P_IS_ZTHRBS01_ZPEND1  TEXT
*      -->P_IS_ZTHRBS01_ZPETM1  TEXT
*      -->P_IS_ZTHRBS01_ZPBEG1  TEXT
*      -->P_IS_ZTHRBS01_ZPBTM1  TEXT
*      -->P_IS_ZTHRBS01_ZPEND1  TEXT
*      -->P_IS_ZTHRBS01_ZPETM1  TEXT
*      -->P_IS_ZTHRBS01_ZPBEG1  TEXT
*      -->P_IS_ZTHRBS01_ZPBTM1  TEXT
*      -->P_IS_ZTHRBS01_ZPEND1  TEXT
*      -->P_IS_ZTHRBS01_ZPETM1  TEXT
*      <--P_E_CODE  TEXT
*      <--P_E_TEXT  TEXT
*----------------------------------------------------------------------*
FORM check_bktime  USING p_ztomo
                         p_zgubun
                         p_zyuhyung
                         p_zbegt  "근로시작시간
                         p_zendt  "근로종료시간
                         p_zpbeg1 "휴게시작시간1
                         p_zpbtm1 "휴게시작시간 익일여부1
                         p_zpend1 "휴게종료시간1
                         p_zpetm1 "휴게종료시간 익일여부1
                         p_zpbeg2 "휴게시작시간2
                         p_zpbtm2 "휴게시작시간 익일여부2
                         p_zpend2 "휴게종료시간2
                         p_zpetm2 "휴게종료시간 익일여부2
                         p_zpbeg3 "휴게시작시간3
                         p_zpbtm3 "휴게시작시간 익일여부3
                         p_zpend3 "휴게종료시간3
                         p_zpetm3 "휴게종료시간 익일여부3
                         p_zpbeg4 "휴게시작시간4
                         p_zpbtm4 "휴게시작시간 익일여부4
                         p_zpend4 "휴게종료시간4
                         p_zpetm4 "휴게종료시간 익일여부4
                         p_zpbeg5 "휴게시작시간5
                         p_zpbtm5 "휴게시작시간 익일여부5
                         p_zpend5 "휴게종료시간5
                         p_zpetm5 "휴게종료시간 익일여부5
                CHANGING c_code
                         c_text.
  CONSTANTS: lc_day(2) TYPE c VALUE '24',
             lc_00(2)  TYPE c VALUE '00',
             lc_30(2)  TYPE c VALUE '30',
             lc_tole   TYPE t VALUE '003000'.

  DATA: lv_begtm     TYPE t,
        lv_endtm     TYPE t,
        lv_index(1)  TYPE n,
        lv_hour(2)   TYPE c,
        lv_diff      TYPE t,
        lv_diff1    TYPE t,
        lv_diff2    TYPE t,
        lv_sum       TYPE t,
        lv_sum1      TYPE t,
        lv_sum2      TYPE t,
        lv_zpdwk_tm  TYPE zepdwk_tm,
        lv_fname(30) TYPE c,
        lr_btime1    TYPE RANGE OF uzeit,
        lr_btime2    TYPE RANGE OF uzeit,
        lr_btime3    TYPE RANGE OF uzeit,
        lr_btime4    TYPE RANGE OF uzeit,
        lr_btime5    TYPE RANGE OF uzeit,
        ls_btime     LIKE LINE OF lr_btime1.

  DATA: l_d_time TYPE uzeit.
  DATA: lv_zpdwk_tm1 TYPE zepdwk_tm,
           lv_zpdwk_tm2 TYPE zepdwk_tm.

  DATA: ls_btime2     LIKE LINE OF lr_btime2,
            ls_btime3     LIKE LINE OF lr_btime3,
            ls_btime4     LIKE LINE OF lr_btime4,
            ls_btime5     LIKE LINE OF lr_btime5.

  DATA: lv_pbegt TYPE time,
            lv_pendt TYPE time.

  FIELD-SYMBOLS: <begtm>, <endtm>, <zpbtm>, <zpetm>.


  lv_pbegt = p_zbegt.
  lv_pendt = p_zendt.
  IF lv_pbegt >= lv_pendt.
    lv_pendt(2)  =  lv_pendt(2) + 24.
  ENDIF.

*...// 휴게시간 중복 CHECK.
  IF  p_zpbeg1 IS NOT INITIAL OR  p_zpend1 IS NOT INITIAL.
    CLEAR: ls_btime.

    IF p_zpbtm1 EQ 'X'.
      lv_hour = p_zpbeg1+0(2) + lc_day.
      p_zpbeg1+0(2) = lv_hour.
    ENDIF.

    IF p_zpetm1 EQ 'X'.
      lv_hour = p_zpend1+0(2) + lc_day.
      p_zpend1+0(2) = lv_hour.
    ENDIF.

    ls_btime-sign = 'I'.
    ls_btime-option = 'BT'.
    ls_btime-low  = p_zpbeg1.
    ls_btime-high = p_zpend1.
    APPEND ls_btime TO lr_btime1.
  ENDIF.

*...// 휴게시간 2 중복 입력 확인
  IF  p_zpbeg2 IS NOT INITIAL OR  p_zpend2 IS NOT INITIAL.
    CLEAR: ls_btime.

    IF p_zpbtm2 EQ 'X'.
      lv_hour = p_zpbeg2+0(2) + lc_day.
      p_zpbeg2+0(2) = lv_hour.
    ENDIF.

    IF p_zpetm2 EQ 'X'.
      lv_hour = p_zpend2+0(2) + lc_day.
      p_zpend2+0(2) = lv_hour.
    ENDIF.

    ls_btime-sign = 'I'.
    ls_btime-option = 'BT'.
    ls_btime-low  = p_zpbeg2.
    ls_btime-high = p_zpend2.
    APPEND ls_btime TO lr_btime2.

*    IF ls_btime-low IN lr_btime1.
*      c_code = 'E87'.
*      c_text = text-e87.
*      RETURN.
*    ENDIF.
*
*    IF ls_btime-high IN lr_btime1.
*      c_code = 'E87'.
*      c_text = text-e87.
*      RETURN.
*    ENDIF.
  ENDIF.

*...// 휴게시간 3 중복 확인
  IF  p_zpbeg3 IS NOT INITIAL OR  p_zpend3 IS NOT INITIAL.
    CLEAR: ls_btime.

    IF p_zpbtm3 EQ 'X'.
      lv_hour = p_zpbeg3+0(2) + lc_day.
      p_zpbeg3+0(2) = lv_hour.
    ENDIF.

    IF p_zpetm3 EQ 'X'.
      lv_hour = p_zpend3+0(2) + lc_day.
      p_zpend3+0(2) = lv_hour.
    ENDIF.

    ls_btime-sign = 'I'.
    ls_btime-option = 'BT'.
    ls_btime-low  = p_zpbeg3.
    ls_btime-high = p_zpend3.
    APPEND ls_btime TO lr_btime3.

*    IF ls_btime-low IN lr_btime1 OR ls_btime-low IN lr_btime2.
*      c_code = 'E87'.
*      c_text = text-e87.
*      RETURN.
*    ENDIF.
*
*    IF ls_btime-high IN lr_btime1 OR ls_btime-high IN lr_btime2.
*      c_code = 'E87'.
*      c_text = text-e87.
*      RETURN.
*    ENDIF.
  ENDIF.

*...// 휴게시간 4 중복 확인
  IF  p_zpbeg4 IS NOT INITIAL OR  p_zpend4 IS NOT INITIAL.
    CLEAR: ls_btime.

    IF p_zpbtm4 EQ 'X'.
      lv_hour = p_zpbeg4+0(2) + lc_day.
      p_zpbeg4+0(2) = lv_hour.
    ENDIF.

    IF p_zpetm4 EQ 'X'.
      lv_hour = p_zpend4+0(2) + lc_day.
      p_zpend4+0(2) = lv_hour.
    ENDIF.

    ls_btime-sign = 'I'.
    ls_btime-option = 'BT'.
    ls_btime-low  = p_zpbeg4.
    ls_btime-high = p_zpend4.
    APPEND ls_btime TO lr_btime4.

*    IF ls_btime-low IN lr_btime1 OR ls_btime-low IN lr_btime2 OR
*       ls_btime-low IN lr_btime3.
*      c_code = 'E87'.
*      c_text = text-e87.
*      RETURN.
*    ENDIF.
*
*    IF ls_btime-high IN lr_btime1 OR ls_btime-high IN lr_btime2 OR
*       ls_btime-high IN lr_btime3.
*      c_code = 'E87'.
*      c_text = text-e87.
*      RETURN.
*    ENDIF.
  ENDIF.


*...// 휴게시간 5 중복 확인
  IF  p_zpbeg5 IS NOT INITIAL OR p_zpend5 IS NOT INITIAL.
    CLEAR: ls_btime.

    IF p_zpbtm5 EQ 'X'.
      lv_hour = p_zpbeg5+0(2) + lc_day.
      p_zpbeg5+0(2) = lv_hour.
    ENDIF.

    IF p_zpetm5 EQ 'X'.
      lv_hour = p_zpend5+0(2) + lc_day.
      p_zpend5+0(2) = lv_hour.
    ENDIF.

    ls_btime-sign = 'I'.
    ls_btime-option = 'BT'.
    ls_btime-low  = p_zpbeg5.
    ls_btime-high = p_zpend5.
    APPEND ls_btime TO lr_btime5.

*    IF ls_btime-low IN lr_btime1 OR ls_btime-low IN lr_btime2 OR
*       ls_btime-low IN lr_btime3 OR ls_btime-low IN lr_btime4.
*      c_code = 'E87'.
*      c_text = text-e87.
*      RETURN.
*    ENDIF.
*
*    IF ls_btime-high IN lr_btime1 OR ls_btime-high IN lr_btime2 OR
*       ls_btime-high IN lr_btime3 OR ls_btime-high IN lr_btime4.
*      c_code = 'E87'.
*      c_text = text-e87.
*      RETURN.
*    ENDIF.
  ENDIF.


************************************************
* 휴게시간 중복 CHECK
************************************************
  DATA: BEGIN  OF ls_flag,
                flag1,
                flag2,
                flag3,
                flag4,
                flag5,
             END OF ls_flag.
  DATA: orf_1 TYPE REF TO cx_root.
  DATA: l_index(1) TYPE n,
            l_cnt TYPE i,

            l_fields(30).
  FIELD-SYMBOLS: <fs> TYPE ANY.

  CLEAR: ls_flag , l_index, l_cnt.

  TRY.
      PROVIDE FIELDS low high
                                        FROM  lr_btime1 INTO ls_btime VALID ls_flag-flag1
                                            BOUNDS  low   AND  high
                     FIELDS  low high
                                        FROM  lr_btime2 INTO ls_btime2 VALID ls_flag-flag2
                                            BOUNDS  low   AND  high
                    FIELDS  low high
                                        FROM  lr_btime3 INTO ls_btime3 VALID ls_flag-flag3
                                            BOUNDS  low   AND  high
                    FIELDS  low high
                                        FROM  lr_btime4 INTO ls_btime4 VALID ls_flag-flag4
                                            BOUNDS  low   AND  high
                    FIELDS  low high
                                        FROM  lr_btime5 INTO ls_btime5 VALID ls_flag-flag5
                                            BOUNDS  low   AND  high
       BETWEEN  lv_pbegt   AND lv_pendt .


        DO 5 TIMES.
          ADD 1 TO l_index.
          CONCATENATE 'LS_FLAG-FLAG' l_index INTO l_fields.
          ASSIGN (l_fields) TO <fs>.
          IF <fs> = 'X'. ADD 1 TO l_cnt. ENDIF.

          IF l_cnt > 1 . EXIT. ENDIF.
        ENDDO.
        IF l_cnt > 1 . EXIT. ENDIF.

        CLEAR:l_index,  l_cnt.
      ENDPROVIDE.
    CATCH cx_sy_provide_table_not_sorted INTO orf_1.
  ENDTRY.

  IF l_cnt > 1.
    c_code = 'E87'.
    c_text = text-e87.
    RETURN.
  ENDIF.

**********************************************

*...// 휴게시간 입력범위 설정(근로시작시간+30분~근로종료시간-30분)
  lv_begtm = p_zbegt + lc_tole.
  lv_endtm = p_zendt - lc_tole.

  IF p_ztomo EQ 'X'.
    lv_hour = lv_endtm+0(2) + lc_day.
    lv_endtm+0(2) = lv_hour.
  ENDIF.

*...// 입력받은 근로시간에 해당하는 의무 휴식시간 구하기
  CALL FUNCTION 'ZHR_52TM_CALC_BREAK_TIME'
    EXPORTING
      i_zbegtm   = p_zbegt
      i_zendtm   = p_zendt
      i_zgubun   = p_zgubun
    IMPORTING
      e_zpdwk_tm = lv_zpdwk_tm.

** 특근/철야인 경우 의무휴게시간 각일자별로 한번 더 체크*
  IF (  p_zgubun = 'D' OR ( p_zgubun = 'C' AND ( p_zyuhyung = 'S1' OR  p_zyuhyung = '01' ) ) )
      AND p_ztomo = 'X'.

    CLEAR: l_d_time, lv_zpdwk_tm1, lv_zpdwk_tm2.

    l_d_time = '240000'.
    CALL FUNCTION 'ZHR_52TM_CALC_BREAK_TIME'
      EXPORTING
        i_zbegtm   = p_zbegt
        i_zendtm   = l_d_time
        i_zgubun   = p_zgubun
      IMPORTING
        e_zpdwk_tm = lv_zpdwk_tm1.

    l_d_time = '000000'.
    CALL FUNCTION 'ZHR_52TM_CALC_BREAK_TIME'
      EXPORTING
        i_zbegtm   = l_d_time
        i_zendtm   = p_zendt
        i_zgubun   = p_zgubun
      IMPORTING
        e_zpdwk_tm = lv_zpdwk_tm2.
  ENDIF.


*...// 휴게시간 입력범위 Check
*...// 휴게시간 30분 단위 입력 CHECK 및 전체 휴게시간 합계
  lv_index = 1.
  DO 5 TIMES.
    CLEAR: lv_diff.

    CONCATENATE `P_ZPBEG` lv_index INTO lv_fname.
    ASSIGN (lv_fname) TO <begtm>.

    CONCATENATE `P_ZPEND` lv_index INTO lv_fname.
    ASSIGN (lv_fname) TO <endtm>.

    CONCATENATE `P_ZPBTM` lv_index INTO lv_fname.
    ASSIGN (lv_fname) TO <zpbtm>.

    CONCATENATE `P_ZPETM` lv_index INTO lv_fname.
    ASSIGN (lv_fname) TO <zpetm>.

    CHECK <begtm> <> '000000' OR <endtm> <> '000000'.

**************************
*    IF <zpbtm> EQ 'X'.
*      lv_hour = <begtm>+0(2) + lc_day.
*      <begtm>+0(2) = lv_hour.
*    ENDIF.
*
*    IF <zpetm> EQ 'X'.
*      lv_hour = <endtm>+0(2) + lc_day.
*      <endtm>+0(2) = lv_hour.
*    ENDIF.
***************************

*...// 휴게시간 입력 범위는 근로시간 범위내에 입력 Check
    IF <begtm> > 0 OR <endtm> > 0.
      IF <endtm> <= <begtm>.
        c_code = 'E89'.
        c_text = text-e89.
        RETURN.
      ENDIF.

      IF <begtm> < lv_begtm OR <begtm> > lv_endtm.
        c_code = 'E77'.
        c_text = text-e77.
        RETURN.
      ENDIF.

      IF <endtm> < lv_begtm OR <endtm> > lv_endtm.
        c_code = 'E77'.
        c_text = text-e77.
        RETURN.
      ENDIF.
    ENDIF.

    lv_diff = <endtm> - <begtm>.


***** 양일근로 ---- >
    IF <endtm> <= '240000'.
      lv_diff1 = <endtm> - <begtm>.
    ELSEIF <begtm> < '240000' AND <endtm> > '240000'.
      l_d_time = '240000'.
      lv_diff1 = l_d_time - <begtm>.
      lv_diff2 = <endtm> - l_d_time.
    ELSEIF <begtm> >=  '240000' .
      lv_diff2 = <endtm> - <begtm>.
    ENDIF.

***** 양일근로 <----


    IF <begtm>+2(2) NE lc_00 AND <begtm>+2(2) NE lc_30.
      c_code = 'E76'.
      c_text = text-e76.
      RETURN.
    ENDIF.

    IF <endtm>+2(2) NE lc_00 AND <endtm>+2(2) NE lc_30.
      c_code = 'E76'.
      c_text = text-e76.
      RETURN.
    ENDIF.

    lv_sum =  lv_sum  + lv_diff.
    lv_sum1 =  lv_sum1 + lv_diff1. " 양일근로 첫째날
    lv_sum2 =  lv_sum2 + lv_diff2. "양일근로 두째날
    lv_index = lv_index + 1.
    CLEAR: lv_diff, lv_diff1, lv_diff2.
  ENDDO.

*...// 의무휴게시간 입력여부 Check.
  IF lv_zpdwk_tm > lv_sum.
    c_code = 'E78'.
    c_text = text-e78.
    RETURN.
  ENDIF.



*...// 휴게시간의 합은 총근로시간을 초과 할 수 없다.
  CLEAR lv_diff.

  lv_diff = lv_endtm - lv_begtm.

  IF lv_sum > lv_diff.
    c_code = 'E79'.
    c_text = text-e79.
    RETURN.
  ENDIF.


** 특근/철야인 경우 의무휴게시간 각일자별로 한번 더 체크*
  IF (  p_zgubun = 'D' OR ( p_zgubun = 'C' AND ( p_zyuhyung = 'S1' OR  p_zyuhyung = '01' ) ) )
      AND p_ztomo = 'X'.
    IF  lv_zpdwk_tm1 > lv_sum1.
      c_code = 'E81'.
      CONCATENATE text-e81 '(의무휴게시간:' lv_zpdwk_tm1(2) ':' lv_zpdwk_tm1+2(2)')' INTO c_text .
      RETURN.
    ENDIF.
    IF  lv_zpdwk_tm2 > lv_sum2.
      c_code = 'E91'.
      CONCATENATE text-e91 '(의무휴게시간:'lv_zpdwk_tm2(2) ':' lv_zpdwk_tm2+2(2)')' INTO c_text .
      RETURN.
    ENDIF.
  ENDIF.
ENDFORM.                    " CHECK_BKTIME
*&---------------------------------------------------------------------*
*&      Form  CALC_WORK_TIME_DAILY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_IS_ZTHRBS01_PERNR  text
*      -->P_IS_ZTHRBS01_ZNAL  text
*      -->P_IS_ZTHRBS01_ZTOMO  text
*      -->P_IS_ZTHRBS01_ZBEGT  text
*      -->P_IS_ZTHRBS01_ZENDT  text
*      <--P_ES_OVERTIME_DATA  text
*      <--P_E_CODE  text
*      <--P_E_TEXT  text
*----------------------------------------------------------------------*
FORM calc_work_time_daily TABLES pt_zdaeh STRUCTURE zshr0121
                           USING p_mode
                                 p_wktype
                                 p_action
                                 p_mtype
                                 p_zdiff
                                 p_run_r3
                                 ps_zthrbs01 STRUCTURE zthrbs01
                                 p_zemcwk_o
                                 p_ztoich_o
                                 p_ztomoh_o
                                 p_zdaeh_o
                        CHANGING cs_overtime_data  TYPE zsh_overtime_data_n
                                 c_zemcwk        "재난
                                 c_ztoich        "퇴출
                                 c_ztomoh        "익휴
                                 c_zdaeh         "대휴
                                 c_zpdwk_tm      "휴게시간 합계
                                 c_code
                                 c_text.

  DATA: lv_min      TYPE i, "
        lv_za_time  TYPE i, "전체근로시간
        lv_zr_time  TYPE i, "소정근로시간
        lv_ze_time  TYPE i, "초가근로시간
        lv_zo_time  TYPE i, "연장근로시간
        lv_zn_time  TYPE i, "야간근로시간
        lv_zh_time  TYPE i, "휴일근로시간
        lv_zd_time  TYPE i, "휴일대휴시간
        lv_zrlovramt TYPE zerlovramt, "연장근로수당.
        lv_zrlngtamt TYPE zerlngtamt, "야간근로수당.
        lv_zrlholamt TYPE zerlholamt, "휴일근로수당.
        lv_zdaehamt  TYPE zedaehamt,  "대휴수당.
        lv_zjorgehamt TYPE zjorgehamt, "휴일-휴일용 대휴 실비
*        lv_zdaeh     TYPE zdaeh,      "대휴여부
        lv_tomoh(1) TYPE c,
        lv_fix(1)   TYPE c,
        lv_ngt(1)   TYPE c,
        lv_stdaz_n  TYPE stdaz,   "정상근무시간
        lv_stdaz_o  TYPE stdaz,   "초과근무시간
        ls_day_time TYPE zshr0115,
        ls_zdaeh    TYPE zshr0121,
        ls_result   TYPE zshr0121,
        lt_day_time   TYPE ztshr0115,  " 시간유형별
        lt_day_time2 TYPE ztshr0115,  "일자별
        lt_result   TYPE ztshr0121. "[52시간] 통상시간외 금액계산 결과

* 이번 호출에서 반환할 대휴 상세와 정산금액을 초기화한다.
* 정산금액 전달에 사용하던 임시 DB용 변수는 삭제한다.
  REFRESH pt_zdaeh.
  CLEAR lv_zjorgehamt.

  CLEAR: p_zemcwk_o, p_ztoich_o, p_ztomoh_o, p_zdaeh_o.


*...// 근로시간을 계산하기전 입력받은 '근로시작~근로종료' 시간이 유효한지 CHECK
  PERFORM check_total_wktime
    USING ps_zthrbs01-znal
          ps_zthrbs01-ztomo
          ps_zthrbs01-zbegt
          ps_zthrbs01-zendt
   CHANGING c_code
            c_text.


  IF c_code+0(1) EQ 'E'.
    RETURN.
  ENDIF.

*...//
  MOVE-CORRESPONDING ps_zthrbs01 TO ls_day_time.
  ls_day_time-datum = ps_zthrbs01-znal.
  ls_day_time-zbegtm = ps_zthrbs01-zbegt.
  ls_day_time-zendtm = ps_zthrbs01-zendt.

  IF ps_zthrbs01-zgubun EQ 'A' OR
     ps_zthrbs01-zgubun EQ 'B' .



*...// 익휴 Check
*...// 익휴발생 및 강제 여부 확인
    CALL FUNCTION 'ZHR_52TM_CHECK_TOMOH'
      EXPORTING
        is_day  = ls_day_time
      IMPORTING
        e_tomoh = lv_tomoh
        e_fix   = lv_fix.

    IF p_run_r3 = 'X'.  "R3에서는 익휴를 비활성하지 않음 - 2019.04.08 BY CHL'
      CLEAR lv_fix.
    ENDIF.

*...// 근로일자에 익휴가 존재하는 경우 ( 발생조건 충족 : lv_tomoh가 'X' 일때)
    IF lv_tomoh EQ 'X'.

      IF c_ztomoh IS INITIAL AND p_action NE 'APPR' . "최초익휴여부 Check  =  익휴 발생 조건이지만, 화면에는 빈값이면 체크 표시를 해주겠다. ( 익휴를 선택 했을때 화면 초기화 )  .
*        문제는 상신했을때 초기화를 해준다는게 문제.... 상신때 빈값이기 때문에 체크가 표시....

        c_ztomoh = 'X'. "최초 익휴 Flag 최초
        cs_overtime_data-ztomoh = lv_tomoh.

      ELSE.                          "  = 익휴 발생 조건이지만, 화면에 체크가 되어 있다면,
*        IF p_action EQ 'ZTOMOH'.
*          IF ps_zthrbs01-ztomoh IS INITIAL.
**...// 익휴가 발생하는 조건이나 입력받은 익휴 FLAG가 '' 인 경우 MESSAGE 처리
*            CLEAR: cs_overtime_data-ztomoh.
*            c_ztomoh = 'X'.
*            "R3에서 실행시 메세지 불필요하므로 추가함 - 2019.04.08 BY CHL
*            IF p_run_r3 <> 'X'. " web 으로 진행했을때
*              c_code = 'I59'.
*              c_text = text-s59.
*            ENDIF.
*          ELSE.
*            c_ztomoh = 'X'.
*            cs_overtime_data-ztomoh = lv_tomoh.
*          ENDIF.
*        ENDIF.
      ENDIF.
*      -----------------------------------------------------------
      IF lv_fix EQ 'X'. " 익휴 강제 발생인 경우
        cs_overtime_data-ztomoh   = lv_tomoh.
        cs_overtime_data-ztomoh_f = lv_fix. "익휴강제 설정
*        CLEAR c_ztomoh.
        c_code = 'I57'.
        c_text = text-s57.

      ELSE.
        p_ztomoh_o = 'X'. " 익휴 오픈
        CLEAR: cs_overtime_data-ztomoh_f.
      ENDIF.
    ELSE. "해당근로일에 익휴가 발생하지 않음 => 익휴CHECKBOX 편집불가, 익휴FLAG, 익휴강제FLAG CLEAR.
      CLEAR: c_ztomoh, cs_overtime_data-ztomoh, cs_overtime_data-ztomoh_f.
    ENDIF.
  ENDIF.


*...// 재난 FLAG 설정
  CALL FUNCTION 'ZHR_52TM_CHECK_ZEMCWK'
    EXPORTING
      i_pernr  = ps_zthrbs01-pernr
      i_datum  = ps_zthrbs01-znal
    IMPORTING
      e_zemcwk = c_zemcwk.

  p_zemcwk_o = c_zemcwk. " 재난오픈

*  if cs_overtime_data-zemcwk = 'X' and p_action = 'ZEMCWK'.
*        c_code = 'I61'.
*        c_text = text-s61.
*  endif.

  IF cs_overtime_data-ztomoh EQ 'X'. "익휴
    lv_ngt = 'X'.
  ELSEIF cs_overtime_data-ztoich IS NOT INITIAL. "퇴출
    lv_ngt = 'Z'.
  ENDIF.


*.. // 당번특근 .교대철야/휴일 은 양일(ztomo)로 계산
  IF (  p_wktype EQ 'N2' OR  p_wktype  EQ 'S1'  OR p_wktype  EQ 'S2' ) AND
         cs_overtime_data-ztomo = 'X' .
    lv_ngt = 'Y'.
  ENDIF.



  CALL FUNCTION 'ZHR_52TM_CALC_WORK_TIME_DAYILY'  " 여기가 해당 일자에 대해서 소정 / 연장 나누는 함수
    EXPORTING
      is_day     = ls_day_time
      i_opt      = 'X'
      i_ngt      = lv_ngt
*      I_Z52WKTP = '0010'
    TABLES
      t_day_time = lt_day_time.


  IF ps_zthrbs01-zgubun EQ 'A' OR
       ps_zthrbs01-zgubun EQ 'B' .
*...// 퇴출편집 FLAG 설정
    READ TABLE lt_day_time INTO ls_day_time INDEX 1.
    IF sy-subrc EQ 0.
      IF ls_day_time-days <> '0'.
        c_ztoich = 'Y'.
        p_ztoich_o = 'X'. " 퇴출OPEN
      ELSE.
        CLEAR c_ztoich.
      ENDIF.
    ENDIF.
  ENDIF.


**
* 익휴 발생이면 퇴출 선택 불가
  IF cs_overtime_data-ztomoh = 'X'.
    CLEAR:p_ztoich_o , cs_overtime_data-ztoich.
  ENDIF.

*...// 대휴 Flag에 따른 처리
  DATA: lv_zdaeh    TYPE zdaeh,
        lv_zdhdat01 TYPE datum,
        lv_zdhdat02 TYPE datum,
        lv_zdhcnt   TYPE i,
        lv_enfo(1)  TYPE c.
  DATA: ls_day TYPE zshr0115.

*..// 대휴용 --> ㅣlt_day_time2 로 대휴 계산
  CLEAR: lt_day_time2[], lt_day_time2, ls_day.
*  MOVE-CORRESPONDING cs_overtime_data TO ls_day.
*  ls_day-datum = cs_overtime_data-znal.

  MOVE-CORRESPONDING ps_zthrbs01 TO ls_day.
  ls_day-datum = ps_zthrbs01-znal.
  ls_day-zbegtm = ps_zthrbs01-zbegt.
  ls_day-zendtm = ps_zthrbs01-zendt.


  CALL FUNCTION 'ZHR_52TM_CALC_WORK_TIME_DAYILY'
    EXPORTING
      is_day     = ls_day
*      i_opt      = 'X'
      i_ngt      = lv_ngt
*       I_Z52WKTP = '0010'
    TABLES
      t_day_time = lt_day_time2.

  CALL FUNCTION 'ZHR_52TM_CHECK_ZDAEH'
    EXPORTING
      i_mode      = p_mode
      is_zthrbs01 = ps_zthrbs01
    IMPORTING
      e_zdaeh     = lv_zdaeh
      e_zdhdat01  = lv_zdhdat01
      e_zdhdat02  = lv_zdhdat02
      e_zdhcnt    = lv_zdhcnt
      e_enfo      = lv_enfo
    TABLES
      et_data     = lt_day_time2.

  IF lv_zdaeh EQ 'X'. "근로일자에 대휴가 존재하는 경우
    IF ( c_zdaeh IS INITIAL AND p_action NE 'APPR')  OR ( c_zdaeh = 'X' AND  lv_enfo = 'X' )  . "최초 대휴여부 Check
      c_zdaeh = 'X'. "최초 대휴 Flag 최초
      cs_overtime_data-zdaeh   = lv_zdaeh.
      cs_overtime_data-zdaeh_c = lv_zdhcnt.
      cs_overtime_data-zdaeh_f = lv_enfo.
    ELSE.
*      IF p_action EQ 'ZDAEH' .
      IF ps_zthrbs01-zdaeh IS INITIAL. "사용자가 대휴CHECK BOX를 해제.
        CLEAR: lv_zdaeh, lv_zdhdat01,  lv_zdhdat02, lv_zdhcnt, lv_enfo,
               cs_overtime_data-zdaeh, cs_overtime_data-zdaeh_c, cs_overtime_data-zdaeh_f.
      ELSE. "그외의 경우는 대휴가 있는경우 대휴 FLAG와 대휴일수 RETURN.
        cs_overtime_data-zdaeh   = lv_zdaeh.
        cs_overtime_data-zdaeh_c = lv_zdhcnt.
        cs_overtime_data-zdaeh_f = lv_enfo.
      ENDIF.
*      ENDIF.
    ENDIF.

    IF lv_enfo EQ ''. " 대휴 open
      p_zdaeh_o = 'X'.
    ENDIF.

  ELSE.
    CLEAR: c_zdaeh, lv_zdaeh, lv_zdhdat01,  lv_zdhdat02, lv_zdhcnt,lv_enfo,
           cs_overtime_data-zdaeh, cs_overtime_data-zdaeh_c,
           cs_overtime_data-zdaeh_f.
  ENDIF.


   LOOP AT lt_day_time INTO ls_day_time.
    CLEAR: ls_result.
    MOVE-CORRESPONDING ls_day_time TO ls_result.
    ls_result-pernr = ps_zthrbs01-pernr.
    IF ls_day_time-days EQ 0.
      IF ls_day_time-datum EQ lv_zdhdat01 OR
         ls_day_time-datum EQ lv_zdhdat02.
        ls_result-zdaeh = 'X'.
      ENDIF.
    ENDIF.
    APPEND ls_result TO lt_result.
   ENDLOOP.


  CALL FUNCTION 'ZHR_52TM_CALC_NORM_OT_PAY'
    CHANGING
      ct_data = lt_result.

  CLEAR: lv_za_time, lv_zr_time, lv_ze_time.

* 이번 계산 결과는 기존 반환 구조와 PT_ZDAEH로 직접 전달한다.
* 신청끼리 공유하는 ZHRDAEHUAMT에는 기록하지 않는다.
* 아래 LT_RESULT 반복문에서 금액과 대휴 상세를 집계한다.

  LOOP AT lt_result INTO ls_result.
    CASE ls_result-regtp.
      WHEN 'N'.
*...// 소정근로시간 합계
        CLEAR: lv_min.
        PERFORM convert_min
          USING ls_result-zrlwk_tm
       CHANGING lv_min.

        lv_zr_time = lv_zr_time + lv_min.
      WHEN 'M'.
*...// 초과근로시간 집계
        CLEAR: lv_min.
        PERFORM convert_min
          USING ls_result-zrlwk_tm
       CHANGING lv_min.

        lv_ze_time = lv_ze_time + lv_min.
    ENDCASE.

*...// 연장근로시간 및 연장근로 수당.
    IF ls_result-zrlovrwkhr IS NOT INITIAL.
      CLEAR lv_min.
      PERFORM convert_min
        USING ls_result-zrlovrwkhr
      CHANGING lv_min.

      lv_zo_time = lv_zo_time + lv_min.
      lv_zrlovramt = lv_zrlovramt + ls_result-zrlovramt.
    ENDIF.
*...// 야간근로시간 및 야간근로 수당.
    IF ls_result-zrlngtwkhr IS NOT INITIAL.
      CLEAR lv_min.
      PERFORM convert_min
        USING ls_result-zrlngtwkhr
      CHANGING lv_min.

      lv_zn_time = lv_zn_time + lv_min.
      lv_zrlngtamt = lv_zrlngtamt + ls_result-zrlngtamt.
    ENDIF.
*...// 휴일근로시간 및 휴일근로 수당.
    IF ls_result-zrlholwkhr IS NOT INITIAL.
      CLEAR lv_min.
      PERFORM convert_min
        USING ls_result-zrlholwkhr
      CHANGING lv_min.

      lv_zh_time = lv_zh_time + lv_min.
      lv_zrlholamt = lv_zrlholamt + ls_result-zrlholamt.
    ENDIF.
*...// 대휴시간 및 대휴수당
    IF ls_result-zdaehhr  IS NOT INITIAL.
      CLEAR lv_min.
      PERFORM convert_min
        USING ls_result-zdaehhr
      CHANGING lv_min.

      lv_zd_time  = lv_zd_time  + lv_min.
      lv_zdaehamt = lv_zdaehamt + ls_result-zdaehamt.
    ENDIF.
* 대휴 상세는 같은 계산 행을 한 번만 반환한다.
* 두 조건이 모두 맞아도 APPEND는 한 번만 실행한다.
    IF ls_result-zdaeh EQ 'X' OR lv_ngt EQ 'Y'.
      APPEND ls_result TO pt_zdaeh.
    ENDIF.

* 신청 전체의 정산금액을 원래 계산 행에서 합산한다.
* 대휴 상세에 포함되지 않은 다른 날짜의 기여분도 더한다.
* 뒤의 기존 반올림 및 * 100 반환 처리는 그대로 사용한다.
    ADD ls_result-zjorgehamt TO lv_zjorgehamt.

*...// 단가
    IF cs_overtime_data-zcost IS INITIAL.
      cs_overtime_data-zcost = ls_result-zcost.
    ENDIF.
*...// 휴게시간 합계
    c_zpdwk_tm = c_zpdwk_tm + ls_result-zpdwk_tm.
  ENDLOOP.

  lv_za_time = lv_zr_time + lv_ze_time.

*...// 금액 원단위 올림 처리
  CALL FUNCTION 'FIMA_NUMERICAL_VALUE_ROUND'
    EXPORTING
      i_rtype     = '+'
      i_runit     = '0.1'
      i_value     = lv_zrlovramt
    IMPORTING
      e_value_rnd = lv_zrlovramt.

  CALL FUNCTION 'FIMA_NUMERICAL_VALUE_ROUND'
    EXPORTING
      i_rtype     = '+'
      i_runit     = '0.1'
      i_value     = lv_zrlngtamt
    IMPORTING
      e_value_rnd = lv_zrlngtamt.

  CALL FUNCTION 'FIMA_NUMERICAL_VALUE_ROUND'
    EXPORTING
      i_rtype     = '+'
      i_runit     = '0.1'
      i_value     = lv_zrlholamt
    IMPORTING
      e_value_rnd = lv_zrlholamt.

  CALL FUNCTION 'FIMA_NUMERICAL_VALUE_ROUND'
    EXPORTING
      i_rtype     = '+'
      i_runit     = '0.1'
      i_value     = lv_zdaehamt
    IMPORTING
      e_value_rnd = lv_zdaehamt.

  CALL FUNCTION 'FIMA_NUMERICAL_VALUE_ROUND'
    EXPORTING
      i_rtype     = '+'
      i_runit     = '0.1'
      i_value     = lv_zjorgehamt
    IMPORTING
      e_value_rnd = lv_zjorgehamt.

  cs_overtime_data-zo_money = lv_zrlovramt * 100. "연장근로수당.
  cs_overtime_data-zn_money = lv_zrlngtamt * 100. "야간근로수당
  cs_overtime_data-zh_money = ( lv_zrlholamt * 100 ) + ( lv_zdaehamt  * 100 ). "휴일근로수당.
  cs_overtime_data-zd_money = lv_zdaehamt  * 100. "휴일대휴수당.
  cs_overtime_data-jorgeh =  lv_zjorgehamt * 100. "휴일-휴일 대휴 정산 금액

  lv_zh_time = lv_zh_time + lv_zd_time. "휴일근로시간(휴일근로시간+대휴시간)


**** 20190107 휴일근로 추가 -->>>>
******* 20190107 공휴일 40시간 초과시 초과근로시간 아니면 휴일 시간(r_time)
  DATA: l_wktim01_m TYPE i,
         l_wktim02_m TYPE i,
         l_wktim03_m TYPE i,
         l_wktim04_m TYPE i,
         l_wktim05_m TYPE i,
         l_wktim06_m TYPE i,
         e_zgubn TYPE i,
         e_code,
         e_text(100).
*...// 주간 누적근로 시간
  PERFORM get_week_basic_time
    USING ps_zthrbs01-pernr
             ps_zthrbs01-znal
          ps_zthrbs01-zgubun
          ps_zthrbs01-seqnr
          p_mode


 CHANGING l_wktim01_m  " 필수근로시간(분)
          l_wktim02_m  " 주중공휴일시간(분)
          l_wktim03_m   " 추가근로가능시간(분)
          l_wktim04_m  " 총근로시간(분)
          l_wktim05_m  " 근로시간(분)
          l_wktim06_m  " 초과근로시간(분)
          e_zgubn
          e_code
          e_text.

* ******* 20190107 68시간제도 토.일 8시간 초과시 초과근로시간
*  data: l_hol_ot type i,
*           l_hol_reg type i,
*           l_hol_df type p,
*           l_zyoil LIKE  HRVSCHED-DAYNR.
*
*  DATA: l_zcnval TYPE zecnval,
*             l_68dt TYPE datum.
*
*  clear: l_hol_ot, l_hol_reg, l_hol_df , l_zyoil.
*
* CALL FUNCTION 'RH_GET_DATE_DAYNAME'
*   EXPORTING
*     langu                     = sy-langu
*     date                      =  cs_overtime_data-znal
*    CALID                     =  'KR'
*  IMPORTING
*    DAYNR                     = l_zyoil     .
*
*      SELECT SINGLE zcnval INTO l_zcnval
*          FROM zthr0101
*        WHERE zconst = 'Z68VLD'
*        AND     begda <= cs_overtime_data-znal
*        AND    endda >= cs_overtime_data-znal.
*
*      IF sy-subrc = 0.
*        l_68dt  = l_zcnval(8).
*      ENDIF.

*  if cs_overtime_data-zyoil = '휴' .
**      check  l_68dt < ls_zthrbs01-znal.
*    " 1. 40시간 기준 구분
*      if l_wktim05_m < 2400.
*         l_hol_df = 2400 -  ( l_wktim05_m +  lv_ze_time ).
*         if l_hol_df <= 0.
*            l_hol_reg  = 2400 - l_wktim05_m.
*            l_hol_ot  = ( lv_ze_time - l_hol_reg ).
*
*            " 시간 변경
*                lv_ze_time = l_hol_ot.            "초과근로시간
*                lv_zr_time = l_hol_reg.         "휴일근로시간-정상
*
*        else.
*              lv_zr_time = lv_ze_time.
*              clear lv_ze_time.
*
*        endif.
*      else.
*        " 전체 초과시간
*
*      endif.
*
*  endif.
**** <<---


  PERFORM convert_time_out: USING lv_za_time CHANGING cs_overtime_data-za_time, "총근로시간
                            USING lv_zr_time CHANGING cs_overtime_data-zr_time, "소정근로시간
                            USING lv_ze_time CHANGING cs_overtime_data-ze_time, "초과근로시간
                            USING lv_zo_time CHANGING cs_overtime_data-zo_time, "연장근로시간
                            USING lv_zn_time CHANGING cs_overtime_data-zn_time, "야간근로시간
                            USING lv_zh_time CHANGING cs_overtime_data-zh_time, "휴일근로시간
                            USING lv_zd_time CHANGING cs_overtime_data-zd_time. "대휴시간
*...// 시차실비 계산
  CHECK p_wktype EQ 'N3'.
  DATA: lv_zcost   TYPE zzcost,
        lv_daynr   TYPE pdaynr,
        lv_daytxt  TYPE zyoil,
        lv_holiday TYPE cind.

  PERFORM get_date_info
    USING ps_zthrbs01-znal         "근로일
 CHANGING lv_daynr
          lv_daytxt
          lv_holiday.


* 2019.12.06 xa30752
  DATA: check_nextday LIKE zthrbs01-znal,
            lv_nextday_holiday LIKE lv_holiday,
            temp TYPE zchar06.

  CLEAR: check_nextday, lv_nextday_holiday, temp.

  "  근무일자가 평휴인지 확인
  CALL FUNCTION 'ZHR_GET_DAY_DATA'
    EXPORTING
      znal    = cs_overtime_data-znal " 근무일
    IMPORTING
      holiday = lv_holiday.

  check_nextday = cs_overtime_data-znal + 1.

  CALL FUNCTION 'ZHR_GET_DAY_DATA'
    EXPORTING
      znal    = check_nextday" 근무 종료일
    IMPORTING
      holiday = lv_nextday_holiday.

*********************************************************************시차 수당 발생 check
** 20190325 시차수당 발생기준 8시간에서 7시간으로 변경 초로 계산 480 -> 420
  IF p_wktype EQ 'N3' AND lv_holiday IS INITIAL.
*    IF ( ( ps_zthrbs01-zbegt <= '070000' AND lv_zr_time >= 480 ) OR
    IF ( ( ps_zthrbs01-zbegt <= '070000' AND lv_zr_time >= 420 ) OR
          (  (  ps_zthrbs01-zendt >= '220000' OR
*                 ps_zthrbs01-zendt <= ps_zthrbs01-zbegt ) and lv_zr_time >= 480 ) ).
         ps_zthrbs01-zendt <= ps_zthrbs01-zbegt ) AND lv_zr_time >= 420 ) ).

      SELECT SINGLE zcost INTO lv_zcost
        FROM zthrcost
       WHERE z_ctype = '2'      " 시차실비.
        "Start-Add // 시간외 단가 변동에 따른 개선 	/ xa32762
          AND begda <= ps_zthrbs01-rdate
          AND endda => ps_zthrbs01-rdate
       "End-Add
         AND zversn  = '1'.     " 활성버전.
      IF sy-subrc = 0.
        cs_overtime_data-zs_money = lv_zcost.
      ENDIF.

************************ 평휴의 경우 07시 이후 출근 시 시차실비 발생. 오류 수정. xa30752 2019.12.06
      " 124차 노사협의 후속조치 - 공사는 시차실비를 지급받을 수 있는 시차근무자가 추가 연장근로로 인해
       " 익일 휴일에 퇴근하는 경우에도 시차실비가 지급되도록 시스템을 개선, 익일이 휴일인지 체크하는 로직 제외
*      IF ps_zthrbs01-zbegt > '070000' AND ps_zthrbs01-ztomo = 'X' AND lv_nextday_holiday NE ''.
*        CLEAR : cs_overtime_data-zs_money, lv_zcost.
*      ENDIF.
*******************************************************************************************

      IF  ps_zthrbs01-zendt >= '070000' AND ps_zthrbs01-ztomo = 'X'. " 단, 익일 근무하고 07시 이후 퇴근 시 시차실비 미발생
        CLEAR : cs_overtime_data-zs_money, lv_zcost.
      ENDIF.

    ELSE.
      CLEAR : cs_overtime_data-zs_money.
    ENDIF.
  ENDIF.


******************************************************************************************


  IF cs_overtime_data-zgubun EQ 'A' OR cs_overtime_data-zgubun EQ 'B'    " 통상 또는 시차의 경우
    AND cs_overtime_data-ztomo NE '' AND cs_overtime_data-ztoich EQ ''. "


    IF lv_holiday EQ '' AND lv_nextday_holiday NE ''.  " 평휴 익일 근무 시 8시간 이하은 초과근무가 아님.
      IF cs_overtime_data-za_time <= '080000'.        " za_time(총근로시간)이 8시간 이하인 경우 ze_time(초과시간) = 0.
        cs_overtime_data-ze_time = '000000'.
      ELSE. " 총근무가 8시간 초과분은 연장근무로

        temp = cs_overtime_data-za_time.

        CALL FUNCTION 'ZHR_MINUS_TIME_N'
          EXPORTING
            TIME1    = temp
            TIME2    = '080000'
          IMPORTING
            TIME_DIF = temp.

        cs_overtime_data-ze_time = temp.
      ENDIF.

    ENDIF.

  ENDIF.
*** ************************************************************************************

ENDFORM.                    " CALC_WORK_TIME_DAILY
*&---------------------------------------------------------------------*
*&      Form  CHECK_TOTAL_WKTIME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PS_ZTHRBS01_ZNAL  text
*      -->P_PS_ZTHRBS01_ZTOMO  text
*      -->P_PS_ZTHRBS01_ZBEGT  text
*      -->P_PS_ZTHRBS01_ZENDT  text
*      <--P_C_CODE  text
*      <--P_C_TEXT  text
*----------------------------------------------------------------------*
FORM check_total_wktime USING p_znal
                              p_ztomo
                              p_zbegt
                              p_zendt
                     CHANGING c_code
                              c_text.

  DATA: lv_next_day     TYPE datum,
        lv_ex_time_n(6) TYPE n.

  IF p_ztomo EQ 'X'.
    lv_next_day = p_znal + 1.
  ELSE.
    lv_next_day = p_znal.
  ENDIF.

  CALL FUNCTION 'ZHR_GET_TIME_DIFF_N'
    EXPORTING
      im_date1        = p_znal
      im_date2        = lv_next_day
      im_time1        = p_zbegt
      im_time2        = p_zendt
    IMPORTING
      time_diff       = lv_ex_time_n
    EXCEPTIONS
      from_greater_to = 1
      max_date        = 2
      OTHERS          = 3.

  IF  sy-subrc <> 0.
*    c_code = 'E98'.
*    c_text = text-e98.
    RETURN.
  ELSE.
    IF lv_ex_time_n > '240000'.  " 시간외근무 24시간 초과여부.
      c_code = 'E80'.
      c_text = text-e80.
      RETURN.
    ENDIF.
  ENDIF.
ENDFORM.                    " CHECK_TOTAL_WKTIME
*&---------------------------------------------------------------------*
*&      Form  GET_REMAIN_DAY_WORK_TIME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PERNR
*      -->P_LS_ZTHRBS01_ZNAL  text
*      <--P_LV_WORKTIME  text
*----------------------------------------------------------------------*
FORM GET_REMAIN_DAY_WORK_TIME  USING    P_MODE
                                        P_PERNR
                                        P_ZNAL
                                        P_SEQNR
                               CHANGING P_LV_WORKTIME.

  "일자를 받아, 속한주의 나머지 일자까지의 근무시간(분단위)을 반환한다.

  DATA : Monday  LIKE SY-DATUM,      "조회일 기준 월요일
         Sunday  LIKE SY-DATUM,      "조회일 기준 일요일
         Im_Date LIKE SCAL-DATE,     "조회일
         Ex_Week LIKE SCAL-WEEK,     "조회일 기준 주차(미사용)
         Ex_Day  LIKE SCAL-DATE,
         nt_date LIKE SY-DATUM.      "검색시작일
  DATA: lv_acttime(6)       TYPE n,
        lv_sum_time(6)      TYPE n,
        lv_time(6)          TYPE n,
        lv_mins(6)          TYPE c,
        lv_hours(6)         TYPE c.
*        ls_bs01             TYPE zthrbs01.
  DATA: LT_ZTHRBS01 LIKE TABLE OF ZTHRBS01 WITH HEADER LINE.
  DATA: LT_SCHEDULE LIKE TABLE OF ZTHRWORKSCHEDULE WITH HEADER LINE.

  Im_Date = P_ZNAL.
  nt_date = P_ZNAL + 1.

  CALL FUNCTION 'DATE_GET_WEEK'
    EXPORTING
      date         = Im_Date
    IMPORTING
      WEEK         = Ex_Week
    EXCEPTIONS
      DATE_INVALID = 1
      OTHERS       = 2.

  CALL FUNCTION 'WEEK_GET_FIRST_DAY'
    EXPORTING
      week         = Ex_Week
    IMPORTING
      DATE         = Ex_Day
    EXCEPTIONS
      WEEK_INVALID = 1
      OTHERS       = 2.

  Move Ex_Day to Monday.        "조회일 기준 월요일 계산

  Add 6 to Ex_Day.
  Move Ex_Day to Sunday.        "조회일 기준 일요일 계산

  SELECT *
         INTO CORRESPONDING FIELDS OF TABLE LT_SCHEDULE
         FROM ZTHRWORKSCHEDULE
        WHERE PERNR  EQ P_PERNR
          AND WDATE  BETWEEN Im_Date AND Sunday
          AND W_CODE EQ '02' "교대근무
        ORDER BY WDATE ASCENDING.


* 워크스케쥴 기준으로 기간동안의 근무시간을 다 더해준다.

  LOOP AT LT_SCHEDULE.

    CLEAR: LT_ZTHRBS01, LT_ZTHRBS01[].
    SELECT *
           INTO CORRESPONDING FIELDS OF TABLE LT_ZTHRBS01
           FROM ZTHRBS01
          WHERE PERNR EQ P_PERNR
            AND ZNAL  EQ LT_SCHEDULE-WDATE
            AND STATE IN ('', '0', '3'). " 저장 결재중 승인

    IF p_mode = 'M'. " 변경이면, 해당일자 초과근로시간 제외
      DELETE lt_zthrbs01 WHERE pernr EQ p_pernr
                           AND ( znal EQ p_znal  AND seqnr EQ p_seqnr ).
    ENDIF.

    "동일일자에 있는 실근로시간 모두 더함.
    LOOP AT LT_ZTHRBS01.
      IF lt_zthrbs01-zemcwk <> 'Y'. "재난이 아닌경우에만 계산해줌.

        lv_acttime = lt_zthrbs01-za_time.
        CALL FUNCTION 'ZHR_SUM_TIME_N'
          EXPORTING
            time1    = lv_sum_time
            time2    = lv_acttime
          IMPORTING
            time_sum = lv_sum_time.  "실근로시간.

      ENDIF.
    ENDLOOP.

*    워크스케쥴을 전일자 까지만 계산되어 들어오므로
*    입력당일일의 데이터를 추가로 가지고와 더해준다.
    IF LT_SCHEDULE-WDATE EQ P_ZNAL.
      CLEAR: lv_hours, lv_mins, lv_time.
      lv_hours = LT_SCHEDULE-workh.
      lv_mins  = LT_SCHEDULE-workm.
      CONDENSE : lv_hours, lv_mins.
      IF strlen( lv_hours ) = 1.
        CONCATENATE '0' lv_hours INTO lv_hours.
      ENDIF.
      IF strlen( lv_mins ) = 1.
        CONCATENATE '0' lv_mins INTO lv_mins.
      ENDIF.
      CONCATENATE lv_hours lv_mins '00' INTO lv_time. "워크스케쥴시간

      CALL FUNCTION 'ZHR_SUM_TIME_N'
        EXPORTING
          time1    = lv_sum_time
          time2    = lv_time
        IMPORTING
          time_sum = lv_sum_time.  "비번초과 + 워크스케쥴시간
    ENDIF.


*    "입력당일일 경우에 스케쥴에서 데이터 가지고 오는 로직 시작.
*    IF LT_SCHEDULE-WDATE EQ P_ZNAL.
*
*    CLEAR LT_ZTHRBS01.
*    READ TABLE LT_ZTHRBS01 WITH KEY ZNAL = P_ZNAL.
*
*      "'입력당일'의 생성내역이 아직 발생하지 않았을 수 있다.
*      IF LT_ZTHRBS01 IS INITIAL.
*        CLEAR: lv_hours, lv_mins, lv_time.
*        lv_hours = LT_SCHEDULE-workh.
*        lv_mins  = LT_SCHEDULE-workm.
*        CONDENSE : lv_hours, lv_mins.
*        IF strlen( lv_hours ) = 1.
*          CONCATENATE '0' lv_hours INTO lv_hours.
*        ENDIF.
*        IF strlen( lv_mins ) = 1.
*          CONCATENATE '0' lv_mins INTO lv_mins.
*        ENDIF.
*        CONCATENATE lv_hours lv_mins '00' INTO lv_time. "워크스케쥴시간
*
*        CALL FUNCTION 'ZHR_SUM_TIME_N'
*          EXPORTING
*            time1    = lv_sum_time
*            time2    = lv_time
*          IMPORTING
*            time_sum = lv_sum_time.  "비번초과 + 워크스케쥴시간
*
*      "만약 있다면 비번초과만 입력 되었는지 확인.
*      "비번초과만 있다면, 원래 근무스케쥴을 더해주어야 한다.
*      ELSE.
*
*        DATA: lv_cnt type i.
*        LOOP AT LT_ZTHRBS01 WHERE  ZNAL = P_ZNAL.
*          IF LT_ZTHRBS01-ZYUHYUNG <> '04'.
*            lv_cnt = lv_cnt + 1.
*          ENDIF.
*        ENDLOOP.
*
*        IF lv_cnt = 0.
*          CLEAR: lv_hours, lv_mins, lv_time.
*          lv_hours = LT_SCHEDULE-workh.
*          lv_mins  = LT_SCHEDULE-workm.
*          CONDENSE : lv_hours, lv_mins.
*          IF strlen( lv_hours ) = 1.
*            CONCATENATE '0' lv_hours INTO lv_hours.
*          ENDIF.
*          IF strlen( lv_mins ) = 1.
*            CONCATENATE '0' lv_mins INTO lv_mins.
*          ENDIF.
*          CONCATENATE lv_hours lv_mins '00' INTO lv_time. "워크스케쥴시간
*
*          CALL FUNCTION 'ZHR_SUM_TIME_N'
*            EXPORTING
*              time1    = lv_sum_time
*              time2    = lv_time
*            IMPORTING
*              time_sum = lv_sum_time.  "비번초과 + 워크스케쥴시간
*
*        ENDIF.
*
*      ENDIF.
*
*    ENDIF.


  ENDLOOP.

  P_LV_WORKTIME = lv_sum_time+0(2) * 60 + lv_sum_time+2(2).

ENDFORM.                    " GET_REMAIN_DAY_WORK_TIME
*&---------------------------------------------------------------------*
*&      Form  CHECK_WORKSCHEDULE_DAYTIME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_ZTHRBS01  text
*      <--P_LV_CHECK  text
*----------------------------------------------------------------------*
FORM CHECK_WORKSCHEDULE_DAYTIME  USING    P_ZTHRBS01 STRUCTURE ZTHRBS01
                                 CHANGING P_CHECK.

  DATA: LS_ZTHRWORKSCHEDULE TYPE ZTHRWORKSCHEDULE.

* 해당일자의 근무 유형을 체크해서, 스케쥴과 겹치는 시간대가 있으면
* 에러로 뱉는다.

  SELECT SINGLE *
         INTO CORRESPONDING FIELDS OF LS_ZTHRWORKSCHEDULE
         FROM ZTHRWORKSCHEDULE
        WHERE PERNR  EQ P_ZTHRBS01-PERNR
          AND WDATE  EQ P_ZTHRBS01-ZNAL
          AND W_CODE EQ '02'. "교대근무
*          AND KIND   EQ '일근'
*          AND OFFDAY NE '1'. "평일


  IF LS_ZTHRWORKSCHEDULE IS NOT INITIAL.

    IF ( P_ZTHRBS01-ZBEGT > LS_ZTHRWORKSCHEDULE-BEGT AND P_ZTHRBS01-ZBEGT < LS_ZTHRWORKSCHEDULE-ENDT ) OR
       ( P_ZTHRBS01-ZENDT > LS_ZTHRWORKSCHEDULE-BEGT AND P_ZTHRBS01-ZENDT < LS_ZTHRWORKSCHEDULE-ENDT ).
      P_CHECK = 'E'.
    ENDIF.
  ENDIF.



ENDFORM.                    " CHECK_WORKSCHEDULE_DAYTIME
