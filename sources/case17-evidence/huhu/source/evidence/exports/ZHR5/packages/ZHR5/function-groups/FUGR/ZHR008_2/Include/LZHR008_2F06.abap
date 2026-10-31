*----------------------------------------------------------------------*
***INCLUDE LZHR008_2F06 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  SET_OVERTIME_DATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM set_overtime_date  USING    p_datum
                        CHANGING p_begda
                                 p_endda.

  DATA : l_week TYPE scal-week.

  CLEAR : p_begda, p_endda.

  " 주차(Week)
  CLEAR l_week.
  CALL FUNCTION 'DATE_GET_WEEK'
    EXPORTING
      date = p_datum
    IMPORTING
      week = l_week.

  " 주차시작일
  CALL FUNCTION 'WEEK_GET_FIRST_DAY'
    EXPORTING
      week = l_week
    IMPORTING
      date = p_begda.

  " 주차종료일
  p_endda = p_begda + 6.

ENDFORM.                    " SET_OVERTIME_DATE
*&---------------------------------------------------------------------*
*&      Form  SET_OVERTIME_ZGUBUN
*&---------------------------------------------------------------------*
*       신청구분/교대근무유형
*----------------------------------------------------------------------*
FORM set_overtime_zgubun  USING    p_pernr
                                   p_datum
                                   p_wktype
                          CHANGING p_zgubun
                                   p_return TYPE bapireturn1.

  DATA : l_code TYPE char03,
         l_text TYPE char200.

  CLEAR : p_zgubun, l_code, l_text.
  " 신청구분유형
  CALL FUNCTION 'ZHR_52TM_SET_ZGUBUN'
    EXPORTING
      i_pernr  = p_pernr
      i_znal   = p_datum
      i_wktype = p_wktype
    IMPORTING
      e_zgubun = p_zgubun
      e_code   = l_code
      e_text   = l_text.
  IF l_code(1) = 'E'.
    p_return-type = c_error.
    p_return-message = l_text.
    RETURN.
  ENDIF.

ENDFORM.                    " SET_OVERTIME_ZGUBUN
*&---------------------------------------------------------------------*
*&      Form  SET_INIT_CHECK
*&---------------------------------------------------------------------*
*       기본근무시간 및 인사정보
*----------------------------------------------------------------------*
FORM set_init_check  USING    p_pernr
                              p_datum
                              p_isfst
                     CHANGING ps_zshr0131 TYPE zshr0131
                              p_code
                              p_text
                              p_iam_msg.

  DATA : ls_zthrbs01       TYPE zthrbs01,
         ls_personnel_data TYPE zsh_personnel_data_n.

  CLEAR : p_code, p_text.


* 서브루틴 안에서 에러코드를 리턴하지 않고 있고,
* I AM에 등록된 기본정보가 설정되었는지 메세지를 주기 위해 변경함 - 2019.03.18 by chl
*- 기본시간
  PERFORM set_overtime_default_time USING p_pernr
                                          p_datum
                                          p_isfst
                                 CHANGING ps_zshr0131
                                          p_code
                                          p_text
                                          p_iam_msg.  "추가 - 2019.03.18 by chl

*- 근무일기준 휴무/근태정보
  CALL FUNCTION 'ZHR_52TM_GET_PERSONNEL_DATA_N'
    EXPORTING
      i_pernr           = p_pernr
      i_znal            = p_datum
      i_zgubun          = ps_zshr0131-zgubun
    IMPORTING
      es_zthrbs01       = ls_zthrbs01
      es_personnel_data = ls_personnel_data
      e_code            = p_code
      e_text            = p_text.

  IF ls_personnel_data IS NOT INITIAL.
    ps_zshr0131-atext = ls_personnel_data-atext." 휴무
    ps_zshr0131-kind  = ls_personnel_data-kind. " 근태
  ENDIF.

*- 요일정보
  CALL FUNCTION 'ZHR_GET_DAY_DATA_N'
    EXPORTING
      znal  = ps_zshr0131-datum
    IMPORTING
      zyoil = ps_zshr0131-zyoil.

*- 퇴출/익휴/대휴/재난 화면표시여부
  PERFORM modify_screen USING ps_zshr0131-zgubun
                              ps_zshr0131-zyoil
                     CHANGING ps_zshr0131-ztoich_s
                              ps_zshr0131-ztomoh_s
                              ps_zshr0131-zdaeh_s
                              ps_zshr0131-zemcwk_s.

*- 퇴출/익휴/대휴/재난 OPEN 및 적합성여부 Clear!!
  CLEAR : ps_zshr0131-ztoich_o,
          ps_zshr0131-ztomoh_o,
          ps_zshr0131-zdaeh_o,
          ps_zshr0131-zemcwk_o,
          ps_zshr0131-ztoich_c,
          ps_zshr0131-ztomoh_c,
          ps_zshr0131-zdaeh_c,
          ps_zshr0131-zemcwk_c.

ENDFORM.                    " SET_INIT_CHECK
**&---------------------------------------------------------------------*
**&      Form  SET_OVERTIME_DEFAULT_TIME
**&---------------------------------------------------------------------*
**       기본시간정보
**----------------------------------------------------------------------*
FORM set_overtime_default_time  USING p_pernr
                                      p_datum
                                      p_isfst
                             CHANGING ps_zshr0131 TYPE zshr0131
                                      p_code
                                      p_text
                                      p_iam_msg.

  DATA :  l_zoblwk_m   TYPE i,
          l_zpubhwk_m  TYPE i,
          l_zpoverwk_m TYPE i,
          l_ztotwk_m   TYPE i,
          l_zrlwk_m    TYPE i,
          l_zrlovrwk_m TYPE i,
          l_zrestwk_m  TYPE i.


  CLEAR : p_code, p_text.

  CALL FUNCTION 'ZHR_52TM_SET_DEFAULT_TIME'
    EXPORTING
      i_pernr     = p_pernr
      i_znal      = p_datum
      i_zgubun    = ps_zshr0131-zgubun
      i_wktype    = ps_zshr0131-wktype
      i_isfst     = p_isfst
    IMPORTING
      e_zbegt     = ps_zshr0131-zbegt   " 근로시작시간
      e_zendt     = ps_zshr0131-zendt   " 근로종료시간
      e_ztomo     = ps_zshr0131-ztomo   " 익일여부
      e_wktim01_m = l_zoblwk_m          " 필수근로시간(분)
      e_wktim02_m = l_zpubhwk_m         " 주중공휴일시간(분)
      e_wktim03_m = l_zpoverwk_m        " 연장근로가능시간(분)
      e_wktim04_m = l_ztotwk_m          " 총근로시간(분)
      e_wktim05_m = l_zrlwk_m           " 근로시간(분)
      e_wktim06_m = l_zrlovrwk_m        " 연장근로시간(분)
      e_wktype    = ps_zshr0131-wktype  " 근로형태 - 추가 2019.03.18 by chl
      e_zpbeg1    = ps_zshr0131-zpbeg1  " 의무휴게시작시간
      e_zpend1    = ps_zshr0131-zpend1  " 의무휴게종료시간
      e_zpbeg2    = ps_zshr0131-zpbeg2  " 의무휴게시작시간2
      e_zpend2    = ps_zshr0131-zpend2  " 의무휴게종료시간2
      e_zpbtm2    = ps_zshr0131-zpbtm2  " 익일체크2
      e_zpetm2    = ps_zshr0131-zpetm2  " 익일체크2
      e_zpdwk_tm  = ps_zshr0131-zpdwk_tm" 의무휴게시간
      e_zcosa     = ps_zshr0131-zcosa   " 결재자사번 - 추가 2019.03.18 by chl
      e_zcope     = ps_zshr0131-zcope   " 결재자성명 - 추가 2019.03.18 by chl
      e_corgtx    = ps_zshr0131-corgtx  " 결재자부서정보 - 추가 2019.03.18 by chl
      e_ztext     = ps_zshr0131-ztext   " 업무내용 - 추가 2019.03.18 by chl
      e_zcid      = ps_zshr0131-zcid    " 결재자ID - 추가 2019.04.29 by chl
      e_code      = p_code
      e_text      = p_text.


  " 익일체크
  IF ( ps_zshr0131-zendt <= ps_zshr0131-zbegt ) AND ( ps_zshr0131-zbegt <> '000000' AND ps_zshr0131-zendt <> '000000' ).
    ps_zshr0131-ztomo = abap_true.
  ENDIF.

  ps_zshr0131-pernr = p_pernr." 사번
  ps_zshr0131-datum = p_datum." 근무일

  "  화면에 보여지는 연장합계 및 연장잔여 2019.12.03 xa30752
  CLEAR l_zrestwk_m.
  IF p_datum < '20201130'.
    l_zpoverwk_m = l_zpoverwk_m - 12 * 60.

    IF l_zrlovrwk_m >= l_zpoverwk_m.
      l_zrlovrwk_m = l_zrlovrwk_m - l_zpoverwk_m.
      IF l_zrlovrwk_m >= l_zpubhwk_m.
        l_zrlovrwk_m = l_zrlovrwk_m - l_zpubhwk_m.
      ELSE.
        l_zrlovrwk_m = 0.
      ENDIF.
    ELSE.
      l_zrlovrwk_m  = 0.
    ENDIF.
    " 연장근로잔여시간(분)
    CLEAR l_zrestwk_m.
    l_zrestwk_m = l_zpoverwk_m - l_zrlovrwk_m.
    IF l_zrestwk_m <= 0.
      CLEAR l_zrestwk_m.
    ENDIF.

  ELSE. " 신규 연장근로 계산 방식 xa30752 2020.03.01
    IF l_zrlovrwk_m > '1200'.
      l_zrestwk_m = '1200' - l_zrlovrwk_m.
    ELSE.
      CLEAR l_zrestwk_m.
    ENDIF.
  ENDIF.


  PERFORM set_overtime_convert_time_out : USING l_zoblwk_m   CHANGING ps_zshr0131-zoblwkhr,  " 필수근로시간
                                          USING l_zpubhwk_m  CHANGING ps_zshr0131-zpubhwkhr, " 주중공휴일시간
                                          USING l_zpoverwk_m CHANGING ps_zshr0131-zpoverwkhr," 연장근로가능시간
                                          USING l_ztotwk_m   CHANGING ps_zshr0131-ztotwkhr,  " 총근로시간
                                          USING l_zrlwk_m    CHANGING ps_zshr0131-zrlwkhr,   " 근로시간
                                          USING l_zrlovrwk_m CHANGING ps_zshr0131-zrlovrwkhr," 연장근로시간
                                          USING l_zrestwk_m  CHANGING ps_zshr0131-zrestwkhr. " 연장근로잔여시간


* I AM에 등록된 기본정보가 설정되었는지 메세지를 주기 위해 추가 - 2019.03.18 by chl
  IF p_code+0(1) <> c_error.
    p_iam_msg = p_text.
  ENDIF.
ENDFORM.                    " SET_OVERTIME_DEFAULT_TIME
*&---------------------------------------------------------------------*
*&      Form  GET_OVERTIME_PERNR_INFO
*&---------------------------------------------------------------------*
*       인사정보
*----------------------------------------------------------------------*
FORM get_overtime_pernr_info CHANGING ps_zshr0131 TYPE zshr0131
                                      ps_zthrbs01 TYPE zthrbs01
                                      p_code
                                      p_text.

  DATA : ls_zthrbs01       TYPE zthrbs01,
         ls_personnel_data TYPE zsh_personnel_data_n.

  CLEAR: p_code, p_text.


  " 인사정보
  CALL FUNCTION 'ZHR_52TM_GET_PERSONNEL_DATA_N'
    EXPORTING
      i_pernr           = ps_zthrbs01-pernr
      i_znal            = ps_zthrbs01-znal
      i_zgubun          = ps_zthrbs01-zgubun
    IMPORTING
      es_zthrbs01       = ls_zthrbs01
      es_personnel_data = ls_personnel_data
      e_code            = p_code
      e_text            = p_text.

  MOVE : ls_zthrbs01-znal        TO ps_zthrbs01-rdate,    " 신청일=근무일.
         ls_zthrbs01-werks       TO ps_zthrbs01-werks,    " 인사영역.
         ls_zthrbs01-persg       TO ps_zthrbs01-persg,    " 사원그룹.
         ls_zthrbs01-persk       TO ps_zthrbs01-persk,    " 사원서브그룹.
         ls_zthrbs01-ename       TO ps_zthrbs01-ename,    " 이름.
         ls_zthrbs01-orgeh       TO ps_zthrbs01-orgeh,    " 소속부서.
         ls_zthrbs01-orgeh_txt   TO ps_zthrbs01-orgeh_txt," 조직이름.
         ls_zthrbs01-plans_txt   TO ps_zthrbs01-plans_txt," 포지션명.
         ls_zthrbs01-jikj        TO ps_zthrbs01-jikj,     " 직종.
         ls_zthrbs01-jikk        TO ps_zthrbs01-jikk,     " 직급.
         ls_zthrbs01-btrtl       TO ps_zthrbs01-btrtl,    " 인사하위영역.
         ls_zthrbs01-btrtx       TO ps_zthrbs01-btrtx,    " 인사하위영역명
         ls_zthrbs01-gsber       TO ps_zthrbs01-gsber,    " 사업영역.
         ls_zthrbs01-gtext       TO ps_zthrbs01-gtext,    " 사업영역텍스트
         ls_zthrbs01-zdung       TO ps_zthrbs01-zdung,    " 등급.
         ls_zthrbs01-zkost       TO ps_zthrbs01-zkost,    " 코스트센터.
         ls_zthrbs01-zzj         TO ps_zthrbs01-zzj,      " 직종
         ls_zthrbs01-zgl01       TO ps_zthrbs01-zgl01,    " G/L계정
         ls_zthrbs01-vdsk1       TO ps_zthrbs01-vdsk1,    " 조직키
         ls_zthrbs01-vdsk1_txt   TO ps_zthrbs01-vdsk1_txt," 부서명
         ls_zthrbs01-zorder      TO ps_zthrbs01-zorder,   " 직제순.
         ls_personnel_data-atext TO ps_zshr0131-atext,    " 휴무
         ls_personnel_data-kind  TO ps_zshr0131-kind.     " 근태

*- 요일정보
  CALL FUNCTION 'ZHR_GET_DAY_DATA_N'
    EXPORTING
      znal  = ps_zthrbs01-znal
    IMPORTING
      zyoil = ps_zthrbs01-zyoil.

ENDFORM.                    " GET_OVERTIME_PERNR_INFO
*&---------------------------------------------------------------------*
*&      Form  MODIFY_SCREEN
*&---------------------------------------------------------------------*
*       화면표시여부 - 퇴출/익휴/대휴/대휴수/재난
*----------------------------------------------------------------------*
FORM modify_screen  USING    p_zgubun
                             p_zyoil
                    CHANGING p_ztoich_s
                             p_ztomoh_s
                             p_zdaeh_s
                             p_zemcwk_s.


  p_ztoich_s = abap_true." 퇴출
  p_ztomoh_s = abap_true." 익휴
  p_zdaeh_s  = abap_true." 대휴
  p_zemcwk_s = abap_true." 재난

  " 퇴출
  IF p_zyoil EQ '휴'.
    CLEAR p_ztoich_s.
  ENDIF.

  " 근무유형에 따른 화면제어 체크
  IF p_zgubun = 'C'." 교대근무
    CLEAR : p_zdaeh_s.
  ENDIF.
  " 익휴/퇴출은 통상/시차근무시에만 비활성화
  IF p_zgubun <> 'A' AND p_zgubun <> 'B'.
    CLEAR : p_ztoich_s, p_ztomoh_s.
  ENDIF.

ENDFORM.                    " MODIFY_SCREEN
*&---------------------------------------------------------------------*
*&      Form  SET_WKTYPE_LIST
*&---------------------------------------------------------------------*
*       근로형태LIST
*----------------------------------------------------------------------*
FORM set_wktype_list  TABLES   pt_wktp STRUCTURE zshr0114
                      USING    p_zgubun
                            p_wktype
                            p_pernr
                            p_datum
                      CHANGING p_code
                               p_text.

  DATA: ls_output   TYPE zshr0119,
        lt_output   TYPE TABLE OF zshr0119.
  DATA: ls_wktype TYPE hcmt_bsp_ddlb_value_line,
        lt_wktype TYPE hcmt_bsp_ddlb_value_table.

  CLEAR: p_code, p_text.
  REFRESH pt_wktp.

  CALL FUNCTION 'ZHR_52TM_SET_WKTYPE_LIST'
    EXPORTING
      i_zgubun  = p_zgubun
    IMPORTING
      et_wktype = lt_wktype
      e_code    = p_code
      e_text    = p_text.

  CHECK p_code+0(1) <> c_error.

  CALL FUNCTION 'ZHR_52TM_WKTYPE_PERIOD'
    EXPORTING
      i_pernr  = p_pernr
      i_begda  = p_datum
      i_endda  = p_datum
      i_opt    = 'X'
    TABLES
      t_output = lt_output.

  CLEAR ls_output.
  READ TABLE lt_output INTO ls_output INDEX 1.

****
*20190422 시차 근로자 확인
*근로유형 0020 시차 삭제
*시차근로자는 infotype 9023에 등록여부로 판단
  DATA e_earlier TYPE char1.
  CLEAR e_earlier.
  CALL FUNCTION 'ZHR_52TM_EARLIER_WORKER'
    EXPORTING
      i_pernr = p_pernr
      i_date  = p_datum
    IMPORTING
      e_chk   = e_earlier.
****


  LOOP AT lt_wktype INTO ls_wktype.
    pt_wktp-domvalue = ls_wktype-domvalue_l.
    pt_wktp-ddtext = ls_wktype-ddtext.
*    IF p_zgubun = 'A' and  pt_wktp-domvalue  = 'N3'  ." 시차근무 제외
**    ELSEIF p_zgubun = 'D' and  pt_wktp-domvalue  = 'N3'  ."시차 아닌 사람이 당번 선택하면 시차가 나옴.
*    IF ls_output-z52wktp <> '0020' AND pt_wktp-domvalue  = 'N3' .  "20190422 시차근로 판단 변경
    IF e_earlier <> 'X' AND pt_wktp-domvalue = 'N3' ."20190422 시차근로 판단 변경
*    ELSEIF p_zgubun = 'C' AND p_wktype = 'S4' AND  pt_wktp-domvalue  = 'S5'  .  "비번인 날은 시차 제외
    ELSE.
      APPEND pt_wktp. CLEAR pt_wktp.
    ENDIF.
  ENDLOOP.


ENDFORM.                    " SET_WKTYPE_LIST
*&---------------------------------------------------------------------*
*&      Form  CHECK_OVERTIME_CHANGE_DATA
*&---------------------------------------------------------------------*
*       변경내역 체크
*----------------------------------------------------------------------*
FORM check_overtime_change_data  USING p_mode
                                       p_seqnr
                              CHANGING ps_zshr0131 TYPE zshr0131
                                       p_code
                                       p_text.


  DATA : ls_zthrbs01      TYPE zthrbs01,
         ls_overtime_data TYPE zsh_overtime_data_n,
         ls_zshr0104      TYPE zshr0104.
  DATA : l_action     TYPE syucomm,
         l_zbegtm     TYPE begti,
         l_zendtm     TYPE endti,
         l_zpbtm      TYPE ztomo,
         l_zpetm      TYPE ztomo,
         l_zpdwk_tm   TYPE zepdwk_tm,
         l_zoblwk_m   TYPE i,
         l_zpubhwk_m  TYPE i,
         l_zpoverwk_m TYPE i,
         l_ztotwk_m   TYPE i,
         l_zrlwk_m    TYPE i,
         l_zrlovrwk_m TYPE i,
         l_zrestwk_m  TYPE i.

  DATA: lv_code(3) TYPE c.
  DATA: lv_text(200) TYPE c.

  DATA: l_code TYPE char03,
        l_text TYPE char200.

  DATA:  lx_time1 TYPE zchar06,
             lx_time2 TYPE zchar06,
             dif TYPE zchar06.

  DATA: tmp_saturday TYPE datum,
            tmp_sunday TYPE datum.

  CLEAR : p_code, p_text, l_action.

  IF p_mode = 'M'." 수정
    " 퇴출/익휴/대휴/재난에 적합성여부('X')
    ps_zshr0131-ztomoh_c = abap_true.
    ps_zshr0131-ztoich_c = abap_true.
    ps_zshr0131-zdaeh_c  = abap_true.
    ps_zshr0131-zemcwk_c = abap_true.
  ENDIF.

*-> 초기 휴계시간이 지정되어 있을꺼 같은데, 다시 지정해야 할 이유가 있나???
  " 휴게시간 체크
***  IF ps_zshr0131-zbegt IS NOT INITIAL OR ps_zshr0131-zendt IS NOT INITIAL.
***    " 의무휴게시간
***    CLEAR : l_zbegtm, l_zendtm, l_zpbtm, l_zpetm, l_zpdwk_tm.
***    CALL FUNCTION 'ZHR_52TM_CALC_BREAK_TIME'
***      EXPORTING
***        i_zbegtm   = ps_zshr0131-zbegt
***        i_zendtm   = ps_zshr0131-zendt
***      IMPORTING
***        e_zbegtm   = l_zbegtm
***        e_zendtm   = l_zendtm
***        e_zpbtm    = l_zpbtm
***        e_zpetm    = l_zpetm
***        e_zpdwk_tm = l_zpdwk_tm.
***
***    IF l_zpdwk_tm > 0.
****      IF ps_zshr0131-zpbeg1 IS INITIAL AND ps_zshr0131-zpend1 IS INITIAL .
**** 20181220 - 공휴일은 DEFAULT 시간 만들지 않는것으로 변경
***      IF ps_zshr0131-zpbeg1 IS INITIAL AND ps_zshr0131-zpend1 IS INITIAL
***       AND ps_zshr0131-zyoil <> '휴'.
***
***        ps_zshr0131-zpbeg1 = l_zbegtm.
***        ps_zshr0131-zpend1 = l_zendtm.
***        ps_zshr0131-zpbtm1 = l_zpbtm.
***        ps_zshr0131-zpetm1 = l_zpetm.
***
***      ENDIF.
***    ENDIF.
***  ENDIF.

  " 휴게시간 익일여부 체크
  PERFORM check_break_time_ztomo CHANGING ps_zshr0131.

  " 화면변경사항 반영
  MOVE : ps_zshr0131-pernr    TO ls_zthrbs01-pernr,
         ps_zshr0131-datum    TO ls_zthrbs01-znal,
         ps_zshr0131-zgubun   TO ls_zthrbs01-zgubun,
         ps_zshr0131-zyuhyung TO ls_zthrbs01-zyuhyung,
         ps_zshr0131-zyoil    TO ls_zthrbs01-zyoil,
         ps_zshr0131-zbegt    TO ls_zthrbs01-zbegt,
         ps_zshr0131-zendt    TO ls_zthrbs01-zendt,
         ps_zshr0131-ztomo    TO ls_zthrbs01-ztomo,
         ps_zshr0131-zemcwk   TO ls_zthrbs01-zemcwk,
         ps_zshr0131-ztoich   TO ls_zthrbs01-ztoich,
         ps_zshr0131-ztomoh   TO ls_zthrbs01-ztomoh,
         ps_zshr0131-zdaeh    TO ls_zthrbs01-zdaeh,
         ps_zshr0131-ztext    TO ls_zthrbs01-ztext,
         ps_zshr0131-zcosa    TO ls_zthrbs01-zcosa,
         ps_zshr0131-zcope    TO ls_zthrbs01-zcope,
         ps_zshr0131-zcid     TO ls_zthrbs01-zcid.

  " 휴게시간
  CLEAR ls_zshr0104.
  MOVE-CORRESPONDING ps_zshr0131 TO ls_zshr0104.
  MOVE-CORRESPONDING ls_zshr0104 TO ls_zthrbs01.

  " 인사정보
  PERFORM get_overtime_pernr_info CHANGING ps_zshr0131
                                           ls_zthrbs01
                                           p_code
                                           p_text.

  " 입력데이터 체크
  CALL FUNCTION 'ZHR_52TM_CHECK_INPUT_DATA_M'
    EXPORTING
      i_mode      = p_mode
      i_action    = ''
      i_wktype    = ps_zshr0131-wktype
      i_wktot     = ps_zshr0131-ztotwkhr  " 가능총근로간
      i_wkreg     = ps_zshr0131-zrlwkhr   " 실제근로시간
      i_atime     = ps_zshr0131-zpoverwkhr" 연장근로가능시간
      i_wkots     = ps_zshr0131-zrlovrwkhr" 실제연장근로시간
      is_zthrbs01 = ls_zthrbs01
    IMPORTING
      e_code      = p_code
      e_text      = p_text.
  IF p_code+0(1) = 'E' OR p_code+0(1) = 'W'.
    RETURN.
  ELSEIF p_code+0(1) = 'I'.
    lv_code = p_code.
    lv_text = p_text.
  ENDIF.

*------------------------------------------------------------------------------------------*
*- 시간 및 금액계산을 위해 재난/익휴/대휴 Checkbox 선택 or 선택해제시, 'L_ACTION' 처리로직
*------------------------------------------------------------------------------------------*
  " 재난
  IF ps_zshr0131-zemcwk_b IS NOT INITIAL.
    l_action = 'ZEMCWK'.
  ENDIF.
  " 익휴
  IF ps_zshr0131-ztomoh_b IS NOT INITIAL.
    l_action = 'ZTOMOH'.
  ENDIF.
  " 대휴
  IF ps_zshr0131-zdaeh_b IS NOT INITIAL.
    l_action = 'ZDAEH'.
  ENDIF.
*-------------------------------------------------------------------------------------*
  " 시간 및 금액 계산
  CLEAR l_zpdwk_tm.
  CALL FUNCTION 'ZHR_52TM_GET_OVERTIME_DATA'
    EXPORTING
      i_mode           = p_mode
      i_wktype         = ps_zshr0131-wktype
      i_action         = l_action
      is_zthrbs01      = ls_zthrbs01
    IMPORTING
      es_overtime_data = ls_overtime_data
      e_zpdwk_tm       = l_zpdwk_tm
      e_code           = p_code
      e_text           = p_text
      e_zemcwk_o       = ps_zshr0131-zemcwk_o
      e_ztoich_o       = ps_zshr0131-ztoich_o
      e_ztomoh_o       = ps_zshr0131-ztomoh_o
      e_zdaeh_o        = ps_zshr0131-zdaeh_o
    CHANGING
      c_zemcwk         = ps_zshr0131-zemcwk_c
      c_ztoich         = ps_zshr0131-ztoich_c
      c_ztomoh         = ps_zshr0131-ztomoh_c
      c_zdaeh          = ps_zshr0131-zdaeh_c.

  IF p_code+0(1) <> 'E'.

    MOVE : ls_overtime_data-ze_time(4) TO ps_zshr0131-ze_time_s," 초과근로시간_화면
           ls_overtime_data-zmoney     TO ps_zshr0131-zmoney,   " 실비금액
           ls_overtime_data-ztoich     TO ps_zshr0131-ztoich,   " 퇴출
           ls_overtime_data-zdaeh      TO ps_zshr0131-zdaeh,    " 대휴
           ls_overtime_data-ztomoh     TO ps_zshr0131-ztomoh,   " 익휴
           ls_overtime_data-zemcwk     TO ps_zshr0131-zemcwk,   " 재난
           ls_overtime_data-zdaeh_c    TO ps_zshr0131-zdaeh_day." 대휴일수


    " 주중 공휴일일 경우 화면에 보이는 연장시간 8시간 기준으로 표기 변경 ( 교대제외 )
* 2019.5.24 xa30752
    IF ps_zshr0131-zgubun <> 'C'.
      tmp_saturday = ps_zshr0131-wkendda - 1.
      tmp_sunday = ps_zshr0131-wkendda.

      IF ps_zshr0131-datum <> tmp_saturday AND ps_zshr0131-datum <> tmp_sunday
        AND ps_zshr0131-zyoil = '휴'.

        IF sy-datum < '20191201'. " xa30752 2019.12.24 주중공휴일 총근로시간을 초과시간으로 화면 표기
          IF ps_zshr0131-ze_time_s <= '0800'.
            ps_zshr0131-ze_time_s = '0000'.
          ELSE.
            lx_time1+0(4) = ps_zshr0131-ze_time_s.
            lx_time1+4(2) = '00'.
            lx_time2 = '080000'.

            CALL FUNCTION 'ZHR_MINUS_TIME_N'
              EXPORTING
                time1    = lx_time1
                time2    = lx_time2
              IMPORTING
                time_dif = dif.

            ps_zshr0131-ze_time_s = dif+0(4).

          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

*...// 저장된 시간에 해당하는 의무 휴게시간.
    CALL FUNCTION 'ZHR_52TM_CALC_BREAK_TIME'
      EXPORTING
        i_zbegtm   = ps_zshr0131-zbegt
        i_zendtm   = ps_zshr0131-zendt
        i_zgubun   = ps_zshr0131-zgubun
      IMPORTING
        e_zpdwk_tm = ps_zshr0131-zpdwk_tm.

*...//근무시간
    CALL FUNCTION 'ZHR_52TM_SET_DEFAULT_TIME'
      EXPORTING
        i_pernr     = ps_zshr0131-pernr
        i_znal      = ps_zshr0131-datum
        i_zgubun    = ps_zshr0131-zgubun
        i_seqnr     = ps_zshr0131-seqnr
        i_mode      = p_mode
      IMPORTING
        e_wktim01_m = l_zoblwk_m   " 필수근로시간(분)
        e_wktim02_m = l_zpubhwk_m  " 주중공휴일시간(분)
        e_wktim03_m = l_zpoverwk_m " 연장근로가능시간(분)
        e_wktim04_m = l_ztotwk_m   " 총근로시간(분)
        e_wktim05_m = l_zrlwk_m    " 근로시간(분)
        e_wktim06_m = l_zrlovrwk_m." 연장근로시간(분)

    "  화면에 보여지는 연장합계 및 연장잔여 2019.12.03 xa30752
    CLEAR l_zrestwk_m.
    IF ps_zshr0131-datum < '20201130'.
      l_zpoverwk_m = l_zpoverwk_m - 12 * 60.

      IF l_zrlovrwk_m >= l_zpoverwk_m.
        l_zrlovrwk_m = l_zrlovrwk_m - l_zpoverwk_m.
        IF l_zrlovrwk_m >= l_zpubhwk_m.
          l_zrlovrwk_m = l_zrlovrwk_m - l_zpubhwk_m.
        ELSE.
          l_zrlovrwk_m = 0.
        ENDIF.
      ELSE.
        l_zrlovrwk_m  = 0.
      ENDIF.

      " 연장근로잔여시간(분)
      l_zrestwk_m = l_zpoverwk_m - l_zrlovrwk_m.
      IF l_zrestwk_m <= 0.
        CLEAR l_zrestwk_m.
      ENDIF.

    ELSE. " 신규 연장근로 계산 방식 xa30752 2020.03.01
      IF l_zrlovrwk_m > '1200'.
        l_zrestwk_m = '1200' - l_zrlovrwk_m.
      ELSE.
        CLEAR l_zrestwk_m.
      ENDIF.
    ENDIF.


    " 연장근로잔여시간(분)
    CLEAR l_zrestwk_m.
    l_zrestwk_m = l_zpoverwk_m - l_zrlovrwk_m.
    IF l_zrestwk_m <= 0.
      CLEAR l_zrestwk_m.
    ENDIF.

    PERFORM set_overtime_convert_time_out : USING l_zoblwk_m   CHANGING ps_zshr0131-zoblwkhr,  " 필수근로시간
                                            USING l_zpubhwk_m  CHANGING ps_zshr0131-zpubhwkhr, " 주중공휴일시간
                                            USING l_zpoverwk_m CHANGING ps_zshr0131-zpoverwkhr," 연장근로가능시간
                                            USING l_ztotwk_m   CHANGING ps_zshr0131-ztotwkhr,  " 총근로시간
                                            USING l_zrlwk_m    CHANGING ps_zshr0131-zrlwkhr,   " 근로시간
                                            USING l_zrlovrwk_m CHANGING ps_zshr0131-zrlovrwkhr," 연장근로시간
                                            USING l_zrestwk_m  CHANGING ps_zshr0131-zrestwkhr. " 연장근로잔여시간
  ELSE.
    RETURN.
  ENDIF.

 IF lv_code IS NOT INITIAL.
   p_code = lv_code.
   p_text = lv_text.
 ENDIF.
ENDFORM.                    " CHECK_OVERTIME_CHANGE_DATA
*&---------------------------------------------------------------------*
*&      Form  CHECK_BREAK_TIME_ZTOMO
*&---------------------------------------------------------------------*
*       휴게시간 익일여부 체크
*----------------------------------------------------------------------*
FORM check_break_time_ztomo  CHANGING ps_zshr0131 TYPE zshr0131.

  DATA : lv_index(1)  TYPE n,
         lv_zpbtm(20) TYPE c,
         lv_zpetm(20) TYPE c.

  FIELD-SYMBOLS: <zpbtm>, <zpetm>.

  lv_index = 1.

  DO.
    CLEAR: lv_zpbtm, lv_zpetm.

    CONCATENATE 'PS_ZSHR0131-ZPBTM' lv_index INTO lv_zpbtm.
    CONCATENATE 'PS_ZSHR0131-ZPETM' lv_index INTO lv_zpetm.

    ASSIGN (lv_zpbtm) TO <zpbtm>.
    ASSIGN (lv_zpetm) TO <zpetm>.

    IF <zpbtm> EQ 'X' AND <zpetm> IS INITIAL.
      <zpetm> = 'X'.
    ENDIF.

    IF lv_index > 5.
      EXIT.
    ELSE.
      lv_index = lv_index + 1.
    ENDIF.
  ENDDO.

ENDFORM.                    " CHECK_BREAK_TIME_ZTOMO
*&---------------------------------------------------------------------*
*&      Form  GET_OVERTIME_WEEK
*&---------------------------------------------------------------------*
*       (Mobile) 시간외실적 주간 누적근무시간
*----------------------------------------------------------------------*
FORM get_overtime_week  TABLES pt_week STRUCTURE zshr0133
                         USING p_pernr
                               p_caldt
                      CHANGING p_return TYPE bapireturn1.

  DATA : ls_0119 TYPE zshr0119,
         lt_0119 LIKE TABLE OF ls_0119.
  DATA : l_wktype     TYPE zewktype,
         l_zgubun     TYPE zbsgubun,
         l_zoblwk_m   TYPE i,
         l_zpubhwk_m  TYPE i,
         l_zpoverwk_m TYPE i,
         l_ztotwk_m   TYPE i,
         l_zrlwk_m    TYPE i,
         l_zrlovrwk_m TYPE i,
         l_zrestwk_m  TYPE i.


  REFRESH pt_week.
  " 사번
  pt_week-pernr = p_pernr.
  " 대상기간
  PERFORM set_overtime_date USING p_caldt  "sy-datum  "2019.03.06 by chl
                         CHANGING pt_week-begda
                                  pt_week-endda.
  " 근로유형
  REFRESH lt_0119.
  CALL FUNCTION 'ZHR_52TM_WKTYPE_PERIOD'
    EXPORTING
      i_pernr  = pt_week-pernr
      i_begda  = sy-datum
      i_endda  = sy-datum
      i_opt    = 'X'
    TABLES
      t_output = lt_0119.
  READ TABLE lt_0119 INTO ls_0119 INDEX 1.
  IF sy-subrc = 0.
    pt_week-z52wktp  = ls_0119-z52wktp.
    pt_week-z52wktxt = ls_0119-z52wktxt.
  ENDIF.

*  " 신청구분유형
*  PERFORM set_overtime_zgubun USING p_pernr
*                                    sy-datum
*                                    l_wktype
*                           CHANGING l_zgubun
*                                    p_return.
*  IF p_return IS NOT INITIAL.
*    RETURN.
*  ENDIF.

  "교대근무일때는 근무유형 변경.
  IF pt_week-z52wktp EQ '0030'.  "교대근무인경우
    l_zgubun = 'C'.
  ENDIF.


  " 누적근무시간
  CALL FUNCTION 'ZHR_52TM_SET_DEFAULT_TIME'
    EXPORTING
      i_pernr     = p_pernr
      i_znal      = p_caldt  "sy-datum "2019.03.14 by chl
      i_zgubun    = l_zgubun
    IMPORTING
      e_wktim01_m = l_zoblwk_m   " 필수근로시간(분)
      e_wktim02_m = l_zpubhwk_m  " 주중공휴일시간(분)
      e_wktim03_m = l_zpoverwk_m " 연장근로가능시간(분)
      e_wktim04_m = l_ztotwk_m   " 총근로시간(분)
      e_wktim05_m = l_zrlwk_m    " 근로시간(분)
      e_wktim06_m = l_zrlovrwk_m." 연장근로시간(분)



  "  화면에 보여지는 연장합계 및 연장잔여 2019.12.03 xa30752
  CLEAR l_zrestwk_m.
  IF p_caldt  < '20201130'.
    l_zpoverwk_m = l_zpoverwk_m - 12 * 60.

    IF l_zrlovrwk_m >= l_zpoverwk_m.
      l_zrlovrwk_m = l_zrlovrwk_m - l_zpoverwk_m.
      IF l_zrlovrwk_m >= l_zpubhwk_m.
        l_zrlovrwk_m = l_zrlovrwk_m - l_zpubhwk_m.
      ELSE.
        l_zrlovrwk_m = 0.
      ENDIF.
    ELSE.
      l_zrlovrwk_m  = 0.
    ENDIF.

    " 연장근로잔여시간(분)
    l_zrestwk_m = l_zpoverwk_m - l_zrlovrwk_m.
    IF l_zrestwk_m <= 0.
      CLEAR l_zrestwk_m.
    ENDIF.

  ELSE. " 신규 연장근로 계산 방식 xa30752 2020.03.01
    IF l_zrlovrwk_m > '1200'.
      l_zrestwk_m = '1200' - l_zrlovrwk_m.
    ELSE.
      CLEAR l_zrestwk_m.
    ENDIF.

  ENDIF.

  PERFORM set_overtime_convert_time_out : USING l_zoblwk_m   CHANGING pt_week-zoblwkhr,  " 필수근로시간
                                          USING l_zpubhwk_m  CHANGING pt_week-zpubhwkhr, " 주중공휴일시간
                                          USING l_zpoverwk_m CHANGING pt_week-zpoverwkhr," 연장근로가능시간
                                          USING l_ztotwk_m   CHANGING pt_week-ztotwkhr,  " 총근로시간
                                          USING l_zrlwk_m    CHANGING pt_week-zrlwkhr,   " 근로시간
                                          USING l_zrlovrwk_m CHANGING pt_week-zrlovrwkhr," 연장근로시간
                                          USING l_zrestwk_m  CHANGING pt_week-zrestwkhr. " 연장근로잔여시간

  APPEND pt_week. CLEAR pt_week.

ENDFORM.                    " GET_OVERTIME_WEEK
*&---------------------------------------------------------------------*
*&      Form  SET_OVERTIME_STYPE_LIST
*&---------------------------------------------------------------------*
*       검색유형리스트
*----------------------------------------------------------------------*
FORM set_overtime_stype_list TABLES pt_search STRUCTURE zshr0114.
  DATA: lt_value TYPE TABLE OF  dd07v  WITH HEADER LINE.
  CLEAR lt_value[].

  CLEAR : pt_search, pt_search[].

  CALL FUNCTION 'GET_DOMAIN_VALUES'
    EXPORTING
      domname    = 'ZDSTATE_C'
    TABLES
      values_tab = lt_value[].

  LOOP AT lt_value.
    pt_search-domvalue =  lt_value-domvalue_l.
    pt_search-ddtext = lt_value-ddtext.
    APPEND pt_search. CLEAR pt_search.
  ENDLOOP.
  pt_search-domvalue = 'A'.
  pt_search-ddtext = '전체'.
  APPEND pt_search. CLEAR pt_search.
  SORT pt_search.

ENDFORM.                    " SET_OVERTIME_STYPE_LIST
*&---------------------------------------------------------------------*
*&      Form  CONVERT_TIME_OUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM set_overtime_convert_time_out  USING p_time
                                 CHANGING c_time_out.
  DATA: lv_hours    TYPE i,
        lv_hour(2)  TYPE n,
        lv_hour_t(3) TYPE n,
        lv_min(2)   TYPE n.

  CLEAR c_time_out.


    lv_hours  = p_time DIV 60.
    lv_hour = lv_hours.
    lv_min    = p_time MOD 60.

    c_time_out+0(2) = lv_hour.
    c_time_out+2(2) = lv_min.


ENDFORM.                    " CONVERT_TIME_OUT
*&---------------------------------------------------------------------*
*&      Form  SET_OVERTIME_ZCOPE
*&---------------------------------------------------------------------*
*       최근 결재자 Setting
*----------------------------------------------------------------------*
FORM set_overtime_zcope  USING p_pernr
                      CHANGING p_zcosa
                               p_zcope
                               p_corgtx
                               p_zcid.

  DATA : ls_zthrbs01 TYPE zthrbs01,
         lt_zthrbs01 LIKE TABLE OF ls_zthrbs01.
  DATA : lv_corgtx(50).

  CLEAR : p_zcosa, p_zcope, p_corgtx.

  " 최근 결재자 정보
  REFRESH lt_zthrbs01.
  SELECT * FROM zthrbs01 UP TO 1 ROWS
    INTO CORRESPONDING FIELDS OF TABLE lt_zthrbs01
   WHERE pernr = p_pernr
     AND zcosa <> '0000000'
   ORDER BY erdat DESCENDING ertim DESCENDING.

  CLEAR ls_zthrbs01.
  READ TABLE lt_zthrbs01 INTO ls_zthrbs01 INDEX 1.
  IF sy-subrc = 0.
    p_zcosa = ls_zthrbs01-zcosa." 결재자사번
    p_zcope = ls_zthrbs01-zcope." 결재자성명
    p_zcid = ls_zthrbs01-zcid. "결재자ID
    " 결재자부서명
    IF p_zcosa <> '00000000'.
      lv_corgtx = zcl_cm_util_dev=>get_vdstext( i_pernr = p_zcosa ).
      p_corgtx = lv_corgtx.
      CLEAR : lv_corgtx.
      lv_corgtx = zcl_cm_util_dev=>get_jikwitext( i_pernr = p_zcosa ).
      CONCATENATE p_corgtx lv_corgtx INTO p_corgtx SEPARATED BY space..
    ENDIF.
  ENDIF.

ENDFORM.                    " SET_OVERTIME_ZCOPE
*&---------------------------------------------------------------------*
*&      Form  MODIFY_OVERTIME_SAVE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM modify_overtime_save_data  USING p_mode
                                      p_action
                             CHANGING ps_zshr0131 TYPE zshr0131
                                      ps_zthrbs01 TYPE zthrbs01
                                      p_code
                                      p_text.


  DATA : ls_overtime_data TYPE zsh_overtime_data_n,
         ls_zshr0104      TYPE zshr0104.
  DATA : l_zpdwk_tm   TYPE zepdwk_tm,
         l_zoblwk_m   TYPE i,
         l_zpubhwk_m  TYPE i,
         l_zpoverwk_m TYPE i,
         l_ztotwk_m   TYPE i,
         l_zrlwk_m    TYPE i,
         l_zrlovrwk_m TYPE i,
         l_zrestwk_m  TYPE i.

  CLEAR : p_code, p_text.

  " 화면변경사항 적용
  MOVE : ps_zshr0131-pernr    TO ps_zthrbs01-pernr,
         ps_zshr0131-datum    TO ps_zthrbs01-znal,
         ps_zshr0131-zgubun   TO ps_zthrbs01-zgubun,
         ps_zshr0131-zyuhyung TO ps_zthrbs01-zyuhyung,
         ps_zshr0131-zbegt    TO ps_zthrbs01-zbegt,
         ps_zshr0131-zendt    TO ps_zthrbs01-zendt,
         ps_zshr0131-ztomo    TO ps_zthrbs01-ztomo,
         ps_zshr0131-zemcwk   TO ps_zthrbs01-zemcwk,
         ps_zshr0131-ztoich   TO ps_zthrbs01-ztoich,
         ps_zshr0131-ztomoh   TO ps_zthrbs01-ztomoh,
         ps_zshr0131-zdaeh    TO ps_zthrbs01-zdaeh,
         ps_zshr0131-ztext    TO ps_zthrbs01-ztext,
         ps_zshr0131-zcosa    TO ps_zthrbs01-zcosa,
         ps_zshr0131-zcope    TO ps_zthrbs01-zcope,
         ps_zshr0131-zcid     TO ps_zthrbs01-zcid.

  " 휴게시간
  CLEAR ls_zshr0104.
  MOVE-CORRESPONDING ps_zshr0131 TO ls_zshr0104.
  MOVE-CORRESPONDING ls_zshr0104 TO ps_zthrbs01.

  " 인사정보
  PERFORM get_overtime_pernr_info CHANGING ps_zshr0131
                                           ps_zthrbs01
                                           p_code
                                           p_text.

  " 변경이면 퇴출/익휴/대휴/재난에 적합성여부('X')
  IF p_mode = 'M'.
    ps_zshr0131-zemcwk_c = abap_true.
    ps_zshr0131-ztoich_c = abap_true.
    ps_zshr0131-ztoich_c = abap_true.
    ps_zshr0131-ztoich_c = abap_true.
  ENDIF.

  " 시간 및 금액정보 산출
  CALL FUNCTION 'ZHR_52TM_GET_OVERTIME_DATA'
    EXPORTING
      i_mode           = p_mode
      i_wktype         = ps_zshr0131-wktype
      i_action         = p_action
      is_zthrbs01      = ps_zthrbs01
    IMPORTING
      es_overtime_data = ls_overtime_data
      e_zpdwk_tm       = l_zpdwk_tm
      e_code           = p_code
      e_text           = p_text
      e_zemcwk_o       = ps_zshr0131-zemcwk_o
      e_ztoich_o       = ps_zshr0131-ztoich_o
      e_ztomoh_o       = ps_zshr0131-ztomoh_o
      e_zdaeh_o        = ps_zshr0131-zdaeh_o
    CHANGING
      c_zemcwk         = ps_zshr0131-zemcwk_c
      c_ztoich         = ps_zshr0131-ztoich_c
      c_ztomoh         = ps_zshr0131-ztomoh_c  " ps_zshr0131-ztoich_c "2019.04.09 by chl
      c_zdaeh          = ps_zshr0131-zdaeh_c.   "ps_zshr0131-ztoich_c. "2019.04.09 by chl

  IF p_code+0(1) <> 'E'.
    MOVE : ls_overtime_data-zyoil      TO ps_zthrbs01-zyoil,    " 요일
           ls_overtime_data-za_time    TO ps_zthrbs01-za_time,  " 총근로시간
           ls_overtime_data-ze_time    TO ps_zthrbs01-ze_time,  " 초과근로시간
           ls_overtime_data-zr_time    TO ps_zthrbs01-zr_time,  " 소정근로시간
           ls_overtime_data-zo_time    TO ps_zthrbs01-zo_time,  " 연장근로시간
           ls_overtime_data-zn_time    TO ps_zthrbs01-zn_time,  " 야간근로시간
           ls_overtime_data-zh_time    TO ps_zthrbs01-zh_time,  " 휴일근로시간
           ls_overtime_data-zd_time    TO ps_zthrbs01-zd_time,  " 대휴발생일 근무시간(2011.05)
           ls_overtime_data-zo_money   TO ps_zthrbs01-zo_money, " 연장근로수당
           ls_overtime_data-zn_money   TO ps_zthrbs01-zn_money, " 야간근로수당
           ls_overtime_data-zh_money   TO ps_zthrbs01-zh_money, " 휴일근무수당
           ls_overtime_data-zs_money   TO ps_zthrbs01-zs_money, " 시차실비
           ls_overtime_data-zd_money   TO ps_zthrbs01-zd_money, " 대휴발생실비
           ls_overtime_data-jorgeh   TO ps_zthrbs01-jorgeh, " 휴일-휴일 대휴정산실비
           ls_overtime_data-zmoney     TO ps_zthrbs01-zmoney,   " 초과근무수당
           ls_overtime_data-zgubn      TO ps_zthrbs01-zgubn,    " 근무구분
           ls_overtime_data-zsign      TO ps_zthrbs01-zsign,    " 초과시간부호(+/-)
           ls_overtime_data-zcho       TO ps_zthrbs01-zcho,     " 초과시간(시간)
           ls_overtime_data-zcho_m     TO ps_zthrbs01-zcho_m,   " 초과시간(분))
           ls_overtime_data-zdday      TO ps_zthrbs01-zdday,    " 대휴일
           ls_overtime_data-ztbase     TO ps_zthrbs01-ztbase,   " 해외출장 적용기준시간
           ls_overtime_data-zbancha    TO ps_zthrbs01-zbancha,  " 반차사용여부
           ls_overtime_data-ztoich     TO ps_zthrbs01-ztoich,   " 퇴출
           ls_overtime_data-zdaeh      TO ps_zthrbs01-zdaeh,    " 대휴
           ls_overtime_data-ztomoh     TO ps_zthrbs01-ztomoh,   " 익휴
           ls_overtime_data-zemcwk     TO ps_zthrbs01-zemcwk.   " 재난
  ELSE.
    RETURN.
  ENDIF.

* CALL FUNCTION 'ZHR_52TM_NEW_ORDINARY_TIME'
*        EXPORTING
*          LS_ZTHRBS01 = ps_zthrbs01.


  " 근무시간
  CALL FUNCTION 'ZHR_52TM_SET_DEFAULT_TIME'
    EXPORTING
      i_pernr     = ps_zshr0131-pernr
      i_znal      = ps_zshr0131-datum
      i_zgubun    = ps_zshr0131-zgubun
      i_seqnr     = ps_zshr0131-seqnr
      i_mode      = p_mode
    IMPORTING
      e_wktim01_m = l_zoblwk_m   " 필수근로시간(분)
      e_wktim02_m = l_zpubhwk_m  " 주중공휴일시간(분)
      e_wktim03_m = l_zpoverwk_m " 연장근로가능시간(분)
      e_wktim04_m = l_ztotwk_m   " 총근로시간(분)
      e_wktim05_m = l_zrlwk_m    " 근로시간(분)
      e_wktim06_m = l_zrlovrwk_m." 연장근로시간(분)


  PERFORM set_overtime_convert_time_out : USING l_zoblwk_m   CHANGING ps_zshr0131-zoblwkhr,  " 필수근로시간
                                          USING l_zpubhwk_m  CHANGING ps_zshr0131-zpubhwkhr, " 주중공휴일시간
                                          USING l_zpoverwk_m CHANGING ps_zshr0131-zpoverwkhr," 연장근로가능시간
                                          USING l_ztotwk_m   CHANGING ps_zshr0131-ztotwkhr,  " 총근로시간
                                          USING l_zrlwk_m    CHANGING ps_zshr0131-zrlwkhr,   " 근로시간
                                          USING l_zrlovrwk_m CHANGING ps_zshr0131-zrlovrwkhr," 연장근로시간
                                          USING l_zrestwk_m  CHANGING ps_zshr0131-zrestwkhr. " 연장근로잔여시간
  " 입력데이터 체크
  CALL FUNCTION 'ZHR_52TM_CHECK_INPUT_DATA'
    EXPORTING
      i_mode      = p_mode
      i_action    = p_action
      i_wktype    = ps_zshr0131-wktype
      i_wktot     = ps_zshr0131-ztotwkhr  " 총근로시간
      i_wkreg     = ps_zshr0131-zrlwkhr   " 근로시간
      i_atime     = ps_zshr0131-zpoverwkhr" 연장근로가능시간
      i_wkots     = ps_zshr0131-zrlovrwkhr" 연장근로시간
      is_zthrbs01 = ps_zthrbs01
    IMPORTING
      e_code      = p_code
      e_text      = p_text.
  IF p_code+0(1) = 'E' OR p_code+0(1) = 'W'.
    p_code+0(1) = c_error.
    RETURN.
  ENDIF.

  "  화면에 보여지는 연장합계 및 연장잔여 2019.12.03 xa30752
  l_zpoverwk_m = l_zpoverwk_m - 12 * 60.

  IF l_zrlovrwk_m >= l_zpoverwk_m.
    l_zrlovrwk_m = l_zrlovrwk_m - l_zpoverwk_m.
    IF l_zrlovrwk_m >= l_zpubhwk_m.
      l_zrlovrwk_m = l_zrlovrwk_m - l_zpubhwk_m.
    ELSE.
      l_zrlovrwk_m = 0.
    ENDIF.
  ELSE.
    l_zrlovrwk_m  = 0.
  ENDIF.




  " 연장근로잔여시간(분)
  CLEAR l_zrestwk_m.
  l_zrestwk_m = l_zpoverwk_m - l_zrlovrwk_m.
  IF l_zrestwk_m <= 0.
    CLEAR l_zrestwk_m.
  ENDIF.


ENDFORM.                    " MODIFY_OVERTIME_SAVE_DATA
*&---------------------------------------------------------------------*
*&      Form  SET_CURR_MONEY
*&---------------------------------------------------------------------*
*       금액
*----------------------------------------------------------------------*
FORM set_curr_money  USING p_money
                  CHANGING p_money_c.

  DATA l_money TYPE i.

  CLEAR l_money.
  l_money = p_money.

  IF l_money > 0.
    WRITE l_money TO p_money_c CURRENCY 'KRW'.
    CONDENSE p_money_c.
  ELSE.
    CLEAR p_money_c.
  ENDIF.

ENDFORM.                    " SET_CURR_MONEY
*&---------------------------------------------------------------------*
*&      Form  GET_WEEK_TIME
*&---------------------------------------------------------------------*
*       주간 연장근로 및 잔여시간 정보
*----------------------------------------------------------------------*
FORM get_week_time  USING p_pernr
                          p_datum
                 CHANGING p_begda
                          p_endda
                          p_zrlovrwkhr
                          p_zrestwkhr.

  DATA : l_zgubun     TYPE zbsgubun,
         l_zrlwk_m TYPE i,
         l_zpubhwk_m TYPE i,
         l_zpoverwk_m TYPE i,
         l_zrlovrwk_m TYPE i,
         l_zrestwk_m  TYPE i.


*- 시작/종료일
  PERFORM set_overtime_date USING p_datum
                         CHANGING p_begda
                                  p_endda.
*- 신청구분유형
  CALL FUNCTION 'ZHR_52TM_SET_ZGUBUN'
    EXPORTING
      i_pernr  = p_pernr
      i_znal   = p_datum
    IMPORTING
      e_zgubun = l_zgubun.

*- 근로시간정보
  CALL FUNCTION 'ZHR_52TM_SET_DEFAULT_TIME'
    EXPORTING
      i_pernr     = p_pernr
      i_znal      = p_datum
      i_zgubun    = l_zgubun
      i_wktype    = ''
    IMPORTING
      e_wktim02_m = l_zpubhwk_m " 주중공휴일시간(분)
      e_wktim03_m = l_zpoverwk_m " 연장근로가능시간(분)
      e_wktim05_m = l_zrlwk_m    " 근로시간(분)
      e_wktim06_m = l_zrlovrwk_m." 연장근로시간(분)

  "  화면에 보여지는 연장합계 및 연장잔여 2019.12.03 xa30752
  CLEAR l_zrestwk_m.
  IF p_datum < '20201130'.
    l_zpoverwk_m = l_zpoverwk_m - 12 * 60.

    IF l_zrlovrwk_m >= l_zpoverwk_m.
      l_zrlovrwk_m = l_zrlovrwk_m - l_zpoverwk_m.
      IF l_zrlovrwk_m >= l_zpubhwk_m.
        l_zrlovrwk_m = l_zrlovrwk_m - l_zpubhwk_m.
      ELSE.
        l_zrlovrwk_m = 0.
      ENDIF.
    ELSE.
      l_zrlovrwk_m  = 0.
    ENDIF.

    " 연장근로잔여시간(분)
    l_zrestwk_m = l_zpoverwk_m - l_zrlovrwk_m.
    IF l_zrestwk_m <= 0.
      CLEAR l_zrestwk_m.
    ENDIF.

  ELSE. " 신규 연장근로 계산 방식 xa30752 2020.03.01
    IF l_zrlovrwk_m > '1200'.
      l_zrestwk_m = '1200' - l_zrlovrwk_m.
    ELSE.
      CLEAR l_zrestwk_m.
    ENDIF.
  ENDIF.


  PERFORM set_overtime_convert_time_out : USING l_zrlovrwk_m CHANGING p_zrlovrwkhr," 연장근로시간
                                          USING l_zrestwk_m  CHANGING p_zrestwkhr. " 연장근로잔여시간

ENDFORM.                    " GET_WEEK_TIME
*&---------------------------------------------------------------------*
*&      Form  CHECK_OVERTIME_BREAK_TIME
*&---------------------------------------------------------------------*
*       의무 휴게시간과 입력한 총 휴게시간 체크 후, 근무시간정보 전송
*----------------------------------------------------------------------*
FORM check_overtime_break_time USING p_mode
                            CHANGING ps_zshr0131 TYPE zshr0131.

  DATA : ls_zthrbs01      TYPE zthrbs01,
         ls_overtime_data TYPE zsh_overtime_data_n.
  DATA : l_zpdwk_tm_1 TYPE zepdwk_tm,
         l_zpdwk_tm_2 TYPE zepdwk_tm,
         l_zemcwk_o   TYPE c,
         l_ztoich_o   TYPE c,
         l_ztomoh_o   TYPE c,
         l_zdaeh_o    TYPE c,
         l_zemcwk_c   TYPE c,
         l_ztoich_c   TYPE c,
         l_ztomoh_c   TYPE c,
         l_zdaeh_c    TYPE c.


  CLEAR ls_zthrbs01.
  MOVE-CORRESPONDING ps_zshr0131 TO ls_zthrbs01.
  ls_zthrbs01-znal = ps_zshr0131-datum." 근무일

  " 의무 휴게시간
  CLEAR l_zpdwk_tm_1.
  CALL FUNCTION 'ZHR_52TM_CALC_BREAK_TIME'
    EXPORTING
      i_zbegtm   = ps_zshr0131-zbegt
      i_zendtm   = ps_zshr0131-zendt
      i_zgubun   = ps_zshr0131-zgubun
    IMPORTING
      e_zpdwk_tm = l_zpdwk_tm_1.

  " 시간 및 금액 계산
  CLEAR l_zpdwk_tm_2.
  CALL FUNCTION 'ZHR_52TM_GET_OVERTIME_DATA'
    EXPORTING
      i_mode           = p_mode
      i_wktype         = ps_zshr0131-wktype
      i_action         = ''
      is_zthrbs01      = ls_zthrbs01
    IMPORTING
      es_overtime_data = ls_overtime_data
      e_zpdwk_tm       = l_zpdwk_tm_2" 입력한 총 휴게시간
      e_zemcwk_o       = l_zemcwk_o
      e_ztoich_o       = l_ztoich_o
      e_ztomoh_o       = l_ztomoh_o
      e_zdaeh_o        = l_zdaeh_o
    CHANGING
      c_zemcwk         = l_zemcwk_c
      c_ztoich         = l_ztoich_c
      c_ztomoh         = l_ztomoh_c
      c_zdaeh          = l_zdaeh_c.

  " 의무휴게시간과 입력한 총 휴게시간이 동일한 경우만
  IF l_zpdwk_tm_1 = l_zpdwk_tm_2.
    MOVE : ls_overtime_data-ze_time(4) TO ps_zshr0131-ze_time_s," 초과근로시간_화면
           ls_overtime_data-zmoney     TO ps_zshr0131-zmoney,   " 실비금액
           ls_overtime_data-ztoich     TO ps_zshr0131-ztoich,   " 퇴출
           ls_overtime_data-zdaeh      TO ps_zshr0131-zdaeh,    " 대휴
           ls_overtime_data-ztomoh     TO ps_zshr0131-ztomoh,   " 익휴
           ls_overtime_data-zemcwk     TO ps_zshr0131-zemcwk,   " 재난
           ls_overtime_data-zdaeh_c    TO ps_zshr0131-zdaeh_day," 대휴일수
           l_zemcwk_o                  TO ps_zshr0131-zemcwk_o, " 재난(활성화여부)
           l_ztoich_o                  TO ps_zshr0131-ztoich_o, " 퇴출(활성화여부)
           l_ztomoh_o                  TO ps_zshr0131-ztomoh_o, " 익휴(활성화여부)
           l_zdaeh_o                   TO ps_zshr0131-zdaeh_o,  " 대휴(활성화여부)
           l_zemcwk_c                  TO ps_zshr0131-zemcwk_c, " 재난(적합성여부)
           l_ztoich_c                  TO ps_zshr0131-ztoich_c, " 퇴출(적합성여부)
           l_ztomoh_c                  TO ps_zshr0131-ztomoh_c, " 익휴(적합성여부)
           l_zdaeh_c                   TO ps_zshr0131-zdaeh_c.  " 대휴(적합성여부)
  ENDIF.

ENDFORM.                    " CHECK_OVERTIME_BREAK_TIME
*&---------------------------------------------------------------------*
*&      Form  CALCULATE_ZE_TIME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_ZTHRBS01  text
*      <--P_LV_ZE_TIME  text
*----------------------------------------------------------------------*
FORM calculate_ze_time  USING    ps_zthrbs01 TYPE zthrbs01
                        CHANGING pv_ze_time.


  pv_ze_time = ps_zthrbs01-ze_time.

  IF ps_zthrbs01-zyoil = '휴'.

*                  신규시스템에서는 ze_time에 있는 값은 휴게시간 제외한 실 근로시간 합계(대휴 발생여부 상관없음)
*                  주중 휴일 및 주말의 경우 ze_time 8시간 초과 시만 연장근로로 계산 (68시간 기준일 때)

    IF pv_ze_time  < '080000' AND ps_zthrbs01-zemcwk <> 'X'. "9시간 근무 미만인 경우.
      pv_ze_time  = '000000'. " 68시간 기준 8시간 미만 근무는 연장근무가 아님

    ELSEIF pv_ze_time  >= '080000' AND ps_zthrbs01-zemcwk <> 'X'.

      CALL FUNCTION 'ZHR_MINUS_TIME_N'
        EXPORTING
          time1    = pv_ze_time
          time2    = '080000'
        IMPORTING
          time_dif = pv_ze_time.

    ELSEIF ps_zthrbs01-zemcwk = 'X'. " 단, 재난(특별연장근로) 했을 경우 연장근로로 계산안함
      pv_ze_time = '000000'.
    ENDIF.
  ELSE. " 평일
    IF ps_zthrbs01-zemcwk = 'X'. " 단, 재난(특별연장근로) 했을 경우 연장근로로 계산안함
      pv_ze_time = '000000'.
    ENDIF.
  ENDIF.

*  DATA: l_zcnval TYPE zecnval,
*        l_68dt TYPE datum,
*        l_68chk.
*  DATA: l_daynr LIKE  hrvsched-daynr.
*  DATA: l_time1 TYPE zchar06,
*        l_time2 TYPE zchar06,
*        l_diff TYPE zchar06.
*  DATA: lv_date TYPE datum.
*  DATA: ls_time TYPE zshr0115.
*  DATA: lt_time TYPE ztshr0115 WITH HEADER LINE.
*  DATA: l_hol TYPE  iscal_day-holiday.
*
*
*  SELECT SINGLE zcnval INTO l_zcnval
*    FROM zthr0101
*   WHERE zconst = 'Z68VLD'
*     AND begda <= sy-datum
*     AND endda >= sy-datum.
*
*  IF sy-subrc = 0.
*    l_68dt  = l_zcnval(8).
*    l_68chk = 'X'.
*  ENDIF.
*
*
*  CLEAR pv_ze_time.
*
*  IF l_68dt >= ps_zthrbs01-znal.
******* 1.  익일이 CHECK 된 경우 / CHECK 안된 경우
******  a 익일 CHECK  된 경우  양일중 휴일이 있는지 확인
******     휴일이 있는 휴일시간 중 8시간까지는 휴일근로간으로 연장근로시간에서 마이너스  , -->>
*    IF ps_zthrbs01-ztomo = 'X'. " 익일인경우
*      MOVE-CORRESPONDING ps_zthrbs01 TO ls_time.
*      ls_time-datum  =  ps_zthrbs01-znal.
*      ls_time-zbegtm = ps_zthrbs01-zbegt.
*      ls_time-zendtm = ps_zthrbs01-zendt.
*
*      l_time1 = ps_zthrbs01-ze_time. " 전체 초과
*
*      CALL FUNCTION 'ZHR_52TM_CALC_WORK_TIME_DAYILY'
*        EXPORTING
*          is_day     = ls_time
*        TABLES
*          t_day_time = lt_time.
*
*
*      LOOP AT lt_time.
*        CLEAR:l_hol, l_time2, l_diff,  l_daynr.
*
*
*        CALL FUNCTION 'ZHR_GET_DAY_DATA_N'
*          EXPORTING
*            znal    = lt_time-datum
*          IMPORTING
*            daynr   = l_daynr
*            holiday = l_hol.
*
*
*        "공.휴일이면
*        CASE l_hol.
*          WHEN 'X'.
*            IF lt_time-zrlwk_tm <= '080000'.
**              c_min05 = c_min05  + ( ( lt_time-zrlwk_tm+0(2) * 60 ) + lt_time-zrlwk_tm+2(2) ). "근로시간
*              l_time2 = lt_time-zrlwk_tm.
*            ELSE.
**              c_min05 = c_min05  +  ( 8 * 60 ).  "8 시간은 근로시간에
*              " 나머지 시간은 초과시간에
*
*              l_time2 = '080000'.
*            ENDIF.
*
*            IF l_time1 >= l_time2.
*              CALL FUNCTION 'ZHR_MINUS_TIME_N'
*                EXPORTING
*                  time1    = l_time1   " 전체 초과 시간 ze_time
*                  time2    = l_time2   " 근로시간(휴일)
*                IMPORTING
*                  time_dif = l_diff.
*
*              l_time1 = l_diff.     " 잔여 연장 시간
*            ENDIF.
*          WHEN OTHERS.
*
*            "평일이면
*
*        ENDCASE.
*
*      ENDLOOP.
*
*      " 재난이 아닌경우, 초과근로시간에 포함
*      IF ps_zthrbs01-zemcwk <> 'X' AND l_time1 IS NOT INITIAL.
**        c_min06 = c_min06 + ( ( l_time1+0(2) * 60 ) + l_time1+2(2) ).
*        pv_ze_time = l_time1.
*      ENDIF.
*
*    ELSE.
*
*
******  b 익일 CHECK 안 된 경우  , -->>
***** 20190429 -->>
*      CALL FUNCTION 'ZHR_GET_DAY_DATA_N'
*        EXPORTING
*          znal    = ps_zthrbs01-znal
*        IMPORTING
*          daynr   = l_daynr
*          holiday = l_hol.
*
**
*      IF l_hol = 'X'. " 공휴일
*        IF ps_zthrbs01-ze_time <= '080000'.
**          c_min05 = c_min05  + ( ( ps_zthrbs01-ze_time+0(2) * 60 ) + ps_zthrbs01-ze_time+2(2) ).
*        ELSE.
**          c_min05 = c_min05  +  ( 8 * 60 ).  "8 시간은 근로시간에
*          " 나머지 시간은 초과시간에
*          l_time1 = ps_zthrbs01-ze_time.
*          l_time2 = '080000'.
*          CALL FUNCTION 'ZHR_MINUS_TIME_N'
*            EXPORTING
*              time1    = l_time1
*              time2    = l_time2
*            IMPORTING
*              time_dif = l_diff.
*          " 재난이 아닌경우, 초과근로시간에 포함
*          IF ps_zthrbs01-zemcwk <> 'X'.
**            c_min06 = c_min06 + ( ( l_diff+0(2) * 60 ) + l_diff+2(2) ).
*            pv_ze_time = l_diff.
*          ENDIF.
*        ENDIF.
*      ELSE. " 평일
*        " 재난이 아닌경우, 초과근로시간에 포함
*        IF ps_zthrbs01-zemcwk <> 'X'.
**          c_min06 = c_min06 + ( ( ps_zthrbs01-ze_time+0(2) * 60 ) + ps_zthrbs01-ze_time+2(2) ).
*          pv_ze_time = ps_zthrbs01-ze_time.
*        ENDIF.
*      ENDIF.
*
*    ENDIF.  " 68l시간 로직 종료
*** <<----
*
*  ELSE.  " 52시간 인 경우
******** 20190107 공휴일 40시간 초과시 초과근로시간 아니면 휴일 시간
*    IF ps_zthrbs01-zyoil = '휴'.
**      c_min05 = c_min05 + ( ( ps_zthrbs01-zr_time+0(2) * 60 ) + ps_zthrbs01-zr_time+2(2) ).
*      " 재난이 아닌경우, 초과근로시간에 포함
*      IF ps_zthrbs01-zemcwk <> 'X'.
**        c_min06 = c_min06 + ( ( ps_zthrbs01-ze_time+0(2) * 60 ) + ps_zthrbs01-ze_time+2(2) ).
*        pv_ze_time = ps_zthrbs01-ze_time.
*      ENDIF.
*
*    ELSE.
*      " 재난이 아닌경우, 초과근로시간에 포함
*      IF ps_zthrbs01-zemcwk <> 'X'.
**        c_min06 = c_min06 + ( ( ps_zthrbs01-ze_time+0(2) * 60 ) + ps_zthrbs01-ze_time+2(2) ).
*        pv_ze_time = ps_zthrbs01-ze_time.
*      ENDIF.
*
*    ENDIF.
*  ENDIF.
ENDFORM.                    " CALCULATE_ZE_TIME
*&---------------------------------------------------------------------*
*&      Form  CHECK_POSSIBLE_APV_DATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PERNR  text
*      -->P_VDSK1  text
*      -->P_DATE  text
*      -->P_ZTOMO  text
*      <--P_CODE  text
*      <--P_TEXT  text
*----------------------------------------------------------------------*
FORM CHECK_POSSIBLE_APV_DATE  USING    P_PERNR
                                       P_VDSK1
                                       P_DATE
                                       P_ZTOMO
                              CHANGING P_CODE
                                       P_TEXT.

  DATA: l_endda    TYPE sy-datum.
  DATA: day_count  TYPE i.
  DATA: lv_orgeh   TYPE orgeh. "부서

  DATA: ls_zthrbs07 TYPE zthrbs07.
  DATA: i_hol3      LIKE iscal_day OCCURS 0 WITH HEADER LINE. "휴일점검

  IF P_ZTOMO IS NOT INITIAL.
    l_endda = P_DATE + 1.
  ELSE.
    l_endda = P_DATE .
  ENDIF.

  CLEAR : day_count,
       i_hol3.
  REFRESH i_hol3.
*처음 시작하는 날이, 평일인지 휴일인지 구분
  CALL FUNCTION 'HOLIDAY_GET'
    EXPORTING
      holiday_calendar = 'KR'
      factory_calendar = 'KR'
      date_from        = l_endda
      date_to          = l_endda
    TABLES
      holidays         = i_hol3. "공휴일이 쌓여있음

  IF i_hol3-holiday is INITIAL AND i_hol3-freeday is INITIAL.
    day_count = -1.
  ELSE.
    day_count = 0.
  ENDIF.

  WHILE day_count <> 5 .
    CLEAR i_hol3.
    REFRESH i_hol3.

    CALL FUNCTION 'HOLIDAY_GET'
      EXPORTING
        holiday_calendar = 'KR'
        factory_calendar = 'KR'
        date_from        = l_endda
        date_to          = l_endda
      TABLES
        holidays         = i_hol3. "공휴일이 쌓여있음

    IF i_hol3-holiday is INITIAL AND i_hol3-freeday is INITIAL.
      day_count = day_count + 1.
    ENDIF.

    IF day_count <> 5.
      l_endda = l_endda + 1.
    ENDIF.
  ENDWHILE.


  MOVE p_vdsk1 TO lv_orgeh.  " 조직코드.

  " 입력기간 설정정보 점검->사번/팀별 정보.
  SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_zthrbs07
    FROM zthrbs07
   WHERE ( orgeh = lv_orgeh OR pernr = p_pernr )
     AND ( begda  <= P_DATE AND endda  >= P_DATE )     " 입력가능기간.
     AND ( zbegda <= sy-datum AND zendda >= sy-datum )  " 유효기간.
     AND zdele = ''.

  IF sy-subrc <> 0.
    IF l_endda < sy-datum.
      p_code = 'E31'.
      p_text = text-e31.
      RETURN.
    ENDIF.
  ENDIF.

ENDFORM.                    " CHECK_POSSIBLE_APV_DATE
*&---------------------------------------------------------------------*
*&      Form  CHECK_DAILYWORK_APV_DATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_PERNR  text
*      -->P_VDSK1  text
*      -->P_DATE  text
*      -->P_ZTOMO  text
*      <--P_CODE  text
*      <--P_TEXT  text
*----------------------------------------------------------------------*
FORM CHECK_DAILYWORK_APV_DATE  USING    P_PERNR
                                       P_VDSK1
                                       P_DATE
                                       P_ZTOMO
                              CHANGING P_CODE
                                       P_TEXT.

  DATA: l_endda    TYPE sy-datum.
  DATA: day_count  TYPE i.
  DATA: lv_orgeh   TYPE orgeh. "부서

  DATA: ls_zthrbs07 TYPE zthrbs07.
  DATA: i_hol3      LIKE iscal_day OCCURS 0 WITH HEADER LINE. "휴일점검

  IF P_ZTOMO IS NOT INITIAL.
    l_endda = P_DATE + 1.
  ELSE.
    l_endda = P_DATE .
  ENDIF.

  CLEAR : day_count,
       i_hol3.
  REFRESH i_hol3.
*처음 시작하는 날이, 평일인지 휴일인지 구분
  CALL FUNCTION 'HOLIDAY_GET'
    EXPORTING
      holiday_calendar = 'KR'
      factory_calendar = 'KR'
      date_from        = l_endda
      date_to          = l_endda
    TABLES
      holidays         = i_hol3. "공휴일이 쌓여있음

  IF i_hol3-holiday is INITIAL AND i_hol3-freeday is INITIAL.
    day_count = -1.
  ELSE.
    day_count = 0.
  ENDIF.

  WHILE day_count <> 5 .
    CLEAR i_hol3.
    REFRESH i_hol3.

    CALL FUNCTION 'HOLIDAY_GET'
      EXPORTING
        holiday_calendar = 'KR'
        factory_calendar = 'KR'
        date_from        = l_endda
        date_to          = l_endda
      TABLES
        holidays         = i_hol3. "공휴일이 쌓여있음

    IF i_hol3-holiday is INITIAL AND i_hol3-freeday is INITIAL.
      day_count = day_count + 1.
    ENDIF.

    IF day_count <> 5.
      l_endda = l_endda + 1.
    ENDIF.
  ENDWHILE.


  MOVE p_vdsk1 TO lv_orgeh.  " 조직코드.

  " 입력기간 설정정보 점검->사번/팀별 정보.
  SELECT SINGLE * INTO CORRESPONDING FIELDS OF ls_zthrbs07
    FROM zthrbs07
   WHERE ( orgeh = lv_orgeh OR pernr = p_pernr )
     AND ( begda  <= P_DATE AND endda  >= P_DATE )     " 입력가능기간.
     AND ( zbegda <= sy-datum AND zendda >= sy-datum )  " 유효기간.
     AND zdele = ''.

  IF sy-subrc <> 0.
    IF l_endda < sy-datum.
      p_code = 'E31'.
      p_text = text-e31.
      RETURN.
    ENDIF.
  ENDIF.

ENDFORM.                    " CHECK_DAILYWORK_POSSIBLE_APV_DATE
