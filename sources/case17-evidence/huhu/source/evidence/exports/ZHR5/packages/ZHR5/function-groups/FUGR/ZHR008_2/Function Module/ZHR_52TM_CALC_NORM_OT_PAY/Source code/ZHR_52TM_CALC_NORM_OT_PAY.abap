FUNCTION zhr_52tm_calc_norm_ot_pay.
*"----------------------------------------------------------------------
*"*"Local interface:
*"  CHANGING
*"     VALUE(CT_DATA) TYPE  ZTSHR0121
*"----------------------------------------------------------------------
  CHECK ct_data[] IS NOT INITIAL.


  DATA: ct_data2 TYPE TABLE OF zshr0121.
  DATA cs_data TYPE zshr0121.
  DATA: l_zcost TYPE p DECIMALS 2,
            l_zdung TYPE zdung.
  DATA: ls_day_time TYPE zshr0115.
  data:  l_DAYNR LIKE  HRVSCHED-DAYNR.
  data: l_rate type p DECIMALS 1.
  DATA: lv_stdaz TYPE stdaz.
  DATA: lv_cnt TYPE i.
  DATA: lv_zover(1) TYPE c.
  DATA: lv_zboth(1) TYPE c.
  DATA: lv_datum TYPE sy-datum.


  DATA: ls_day TYPE zshr0115.
  DATA: lt_data   TYPE  ztshr0115 WITH HEADER LINE.
  DATA: l_chk.
  CLEAR: lt_data[], lt_data.
  DATA: ls_data TYPE zshr0121.

  CLEAR: cs_data, l_zcost, l_zdung.

  READ TABLE ct_data INDEX 1 INTO cs_data.


** 20190325 휴일 시간 계산을 위해  금액만 안나오게 변경처리 함
*  CASE CS_DATA-ZGUBUN.
*    WHEN 'E' OR 'F' OR 'G'. "출제위원.부장대휴 금액계산 없음
*       EXIT.
*  ENDCASE.
*<<--

* 사원 등급

  CALL FUNCTION 'ZHR_GET_PERSONNEL_RANK_N'
    EXPORTING
      i_pernr = cs_data-pernr
      i_znal  = cs_data-datum
    IMPORTING
      e_zdung = l_zdung.

  CHECK  sy-subrc EQ 0.

*  "  단가
*  IF cs_data-datum >= '20201201' AND ( l_zdung = '가' OR l_zdung = '나' OR l_zdung = '다' OR l_zdung = '라' OR l_zdung = '마' ).
*    l_zdung  = ''.
*  ENDIF.

  SELECT SINGLE zcost INTO  l_zcost
                  FROM zthrcost
                  WHERE z_ctype = '1'      " 기준단가.
                    AND begda <= cs_data-datum " 근무일이 기간내 들어오는지 체크 xa30752 (2020.07.22) 추가
                    AND endda >= cs_data-datum
                    AND zdung   = l_zdung
                    AND zversn  = '1'.     " 활성버전

  CHECK  sy-subrc EQ 0.


  CASE CS_DATA-ZGUBUN.
    WHEN 'E' OR 'F' OR 'G'. "출제위원.부장대휴 금액계산 없음
      clear: l_zdung, l_zcost.
  ENDCASE.


  l_zcost = l_zcost / 100.


* 계산
  CLEAR: lv_stdaz, lv_zover, lv_datum, lv_zboth.
  REFRESH ct_data2.
  ct_data2[] = ct_data[].
 "해외출장, 당번특근  기준시간 구분에 따라 나눠 지는건지(양일이상여부) 확인
 DELETE ADJACENT DUPLICATES FROM ct_data2 COMPARING datum.
 DESCRIBE TABLE ct_data2 LINES lv_cnt.

 IF cs_data-zgubun = 'T' OR cs_data-zgubun = 'D'.  "해외출장, 당번특근
  IF lv_cnt = 1.
    lv_zboth = ''.
  ELSE.
    lv_zboth = 'X'.
  ENDIF.
 ENDIF.


 "당일 익일 합계시간부터 계산, 당일 다음날이 각각 4.5시간보다 작은지도 확인
  LOOP AT ct_data INTO cs_data.
   lv_stdaz = lv_stdaz + cs_data-stdaz.
   IF cs_data-stdaz >= '4.5'.
     lv_zover = 'X'.
   ENDIF.
  ENDLOOP.

  LOOP AT ct_data INTO cs_data.
    cs_data-zdung = l_zdung.
    cs_data-zcost = l_zcost.
    cs_data-waers = 'KRW'.

*// 시간
    IF cs_data-days = '1'. " 평일 근로시간
*    //*    주간 야간근로시간   " 야간시간(22:00~06:00) 산출.
      MOVE-CORRESPONDING cs_data TO  ls_day_time.
      PERFORM get_calc_ngt_time IN PROGRAM saplzhr008_2
                                                    USING  ls_day_time
                                                   CHANGING cs_data-zrlngtwkhr .

*    //*    주간 연장근로시간   "
      IF cs_data-tmtyp = 'M'. " overtime
        cs_data-zrlovrwkhr = cs_data-zrlwk_tm.
      ENDIF.

    ELSE. " 휴일

      IF cs_data-tmtyp = 'H'.
************************************************************************************
        LOOP AT ct_data INTO ls_data WHERE zdaeh = 'X'.  " 휴휴의 경우 발생 대휴 추가 체크 필요 xa30752 2020.01.13
          IF sy-subrc = 0.
            l_chk = 'X'.
          ENDIF.
        ENDLOOP.

        IF l_chk = 'X'.  " 대휴시간
          cs_data-zdaehhr = cs_data-zrlwk_tm.
        ELSE.   " 휴일시간
          cs_data-zrlholwkhr = cs_data-zrlwk_tm.
        ENDIF.
*************************************************************************************
*
*        IF cs_data-zdaeh = 'X'.  " 대휴시간
*          cs_data-zdaehhr = cs_data-zrlwk_tm.
*        ELSE.   " 휴일시간
*          cs_data-zrlholwkhr = cs_data-zrlwk_tm.
*        ENDIF.

      ENDIF.
    ENDIF.





*//금액
* 금액계산 / 통상근로자와 교대근로자를 구분 하여 계산

    IF cs_data-zgubun eq 'C'.  " 교대조이면
* zyuhyung
*01	철야
*02	휴일
*03	대근
*04	비번초과
*__________	____________________________________________________________
**
** 1. 평일 철야.대근/비번     (100%)

      PERFORM calc_ot_amount IN PROGRAM saplzhr008_2
                                            USING cs_data-zcost
                                                       cs_data-zrlovrwkhr
                                                       cs_data-zrlovramt
                                                      '1.0'.
** 2. 야간수당 (50%)
      PERFORM calc_ot_amount   IN PROGRAM saplzhr008_2
                                                  USING cs_data-zcost
                                                     cs_data-zrlngtwkhr
                                                      cs_data-zrlngtamt
                                                      '0.5'.

** 3-1. 철야 수당 (50%)
      case cs_data-zyuhyung.
        when '01' .
          PERFORM calc_ot_amount IN PROGRAM saplzhr008_2
                                                      USING cs_data-zcost
                                                          cs_data-zrlholwkhr
                                                          cs_data-zrlholamt
                                                          '0.5'.

        when '02'. " 휴일 수당 (토.일50% 주중공휴일 150%)
          CALL FUNCTION 'RH_GET_DATE_DAYNAME'
            EXPORTING
              langu = sy-langu
              date  = cs_data-datum
            IMPORTING
              DAYNR = l_daynr.

          if L_daynr = '6' or l_daynr = '7'.
            l_rate = '0.5'.
          else.
            l_rate = '1.5'.
          endif.

          PERFORM calc_ot_amount IN PROGRAM saplzhr008_2
                                                   USING cs_data-zcost
                                                       cs_data-zrlholwkhr
                                                       cs_data-zrlholamt
                                                       l_rate.


** 3-2. 휴일 대근.비번 휴일수당 (150%)

        when '03' or '04'.
          PERFORM calc_ot_amount IN PROGRAM saplzhr008_2
                                                      USING cs_data-zcost
                                                          cs_data-zrlholwkhr
                                                          cs_data-zrlholamt
                                                          '1.5'.

        when  '05'. "교대근무면서 주중공휴일인경우
          CALL FUNCTION 'RH_GET_DATE_DAYNAME'
            EXPORTING
              langu = sy-langu
              date  = cs_data-datum
            IMPORTING
              DAYNR = l_daynr.

          if ( L_daynr <> '6' AND l_daynr <> '7' ) AND cs_data-DAYS = '0'.
            PERFORM calc_ot_amount IN PROGRAM saplzhr008_2
                                                     USING cs_data-zcost
                                                         cs_data-zrlholwkhr
                                                         cs_data-zrlholamt
                                                         '1.5'.

          endif.



      endcase.


    ELSE."교대조가 아니면
** 1. 연장수당 (100%)
      PERFORM calc_ot_amount IN PROGRAM saplzhr008_2
                                            USING cs_data-zcost
                                                       cs_data-zrlovrwkhr
                                                       cs_data-zrlovramt
                                                      '1.0'.
** 2. 야간수당 (50%)
      PERFORM calc_ot_amount   IN PROGRAM saplzhr008_2
                                                  USING cs_data-zcost
                                                     cs_data-zrlngtwkhr
                                                      cs_data-zrlngtamt
                                                      '0.5'.

** 3. 휴일수당 (150%)
      PERFORM calc_ot_amount IN PROGRAM saplzhr008_2
                                                  USING cs_data-zcost
                                                      cs_data-zrlholwkhr
                                                      cs_data-zrlholamt
                                                      '1.5'.


** 4. 대휴수당 (50%)
  "2022.08.18 나구엽 - 인사운영부 요청
  " 휴일-휴일에 걸쳐 근무한 경우
  " 계산 날짜에서 시간외 시간이 4.5시간이 넘어가면 대휴가 생겨서 50%만 적용하고 아니면 150% 적용
*  휴일+휴일의 4가지 유형
*1) 이틀 각각 4.5시간 이상인 경우
*  - 대휴 2개 생성. 휴일실비 50%
*
*2) 하루는 4.5시간 이상, 다른 하루는 4.5 미만
*  - 4.5시간 이상인 날에 대휴 생성하고 휴일실비 50%만 지급, 다른 하루는 150%지급
* - 익일과 당일 구분 필요
*
*3) 이틀 각각 4.5시간 미만인 경우
*   3-1) 합쳐서 4.5시간 이상인 경우
*         - 대휴1개 생성. 휴일실비 50%
*   3-2) 합쳐서 4.5시간 미만인 경우
*         - 대휴없음. 휴일실비 150%
"lv_stdaz : 양일 합계 시간
"lv_zover : 양일 중 하루라도 4.5시간이 넘는지 여부
"lv_zboth : 해외출장, 당번특근의 양일이상인지 여부


 "T-해외출장자이면서 양일이아닌(하루인)경우, 왜냐하면 zthr0101테이블에서 해외출장 시간외 연장근로시간에 따라 라인이 2개로 쪼개짐   11 = 9 +2
 "D-당번특근자도 양일이아닌(하루인) 경우 라인이 2개로 쪼개짐  10  = 8 +2
 "B-시차근무자도 쪼개짐
 IF ( cs_data-zgubun = 'T' OR cs_data-zgubun = 'D' OR cs_data-zgubun = 'B'  ) AND lv_zboth IS INITIAL.

      IF lv_stdaz >= '4.5'.
        PERFORM calc_ot_amount  IN PROGRAM saplzhr008_2
                                                   USING cs_data-zcost
                                                           cs_data-zdaehhr
                                                           cs_data-zdaehamt
                                                          '0.5'.

      ELSE.
        PERFORM calc_ot_amount  IN PROGRAM saplzhr008_2
                                                   USING cs_data-zcost
                                                           cs_data-zdaehhr
                                                           cs_data-zdaehamt
                                                          '1.5'.
      ENDIF.

 ELSE.

   IF lv_stdaz >= '4.5' AND lv_zover IS INITIAL.
      PERFORM calc_ot_amount  IN PROGRAM saplzhr008_2
                                                   USING cs_data-zcost
                                                           cs_data-zdaehhr
                                                           cs_data-zdaehamt
                                                          '0.5'.
      "휴일-휴일 대휴정산 실비
       PERFORM calc_ot_amount  IN PROGRAM saplzhr008_2
                                                   USING cs_data-zcost
                                                           cs_data-zdaehhr
                                                           cs_data-zjorgehamt
                                                          '1'.

   ELSE.
     IF cs_data-stdaz >= '4.5'.
      PERFORM calc_ot_amount  IN PROGRAM saplzhr008_2
                                                   USING cs_data-zcost
                                                           cs_data-zdaehhr
                                                           cs_data-zdaehamt
                                                          '0.5'.
     "휴일-휴일 대휴정산 실비
      PERFORM calc_ot_amount  IN PROGRAM saplzhr008_2
                                                   USING cs_data-zcost
                                                           cs_data-zdaehhr
                                                           cs_data-zjorgehamt
                                                          '1'.

     ELSE.
       "20240703-NGY-4.5시간 미만이더라도 대휴라고 찍혀 있으면 ...
       IF cs_data-zdaeh = 'X'.
         PERFORM calc_ot_amount  IN PROGRAM saplzhr008_2
                                                   USING cs_data-zcost
                                                           cs_data-zdaehhr
                                                           cs_data-zdaehamt
                                                          '0.5'.
         "휴일-휴일 대휴정산 실비
         PERFORM calc_ot_amount  IN PROGRAM saplzhr008_2
                                                   USING cs_data-zcost
                                                           cs_data-zdaehhr
                                                           cs_data-zjorgehamt
                                                          '1'.
       ELSE.

        PERFORM calc_ot_amount  IN PROGRAM saplzhr008_2
                                                   USING cs_data-zcost
                                                           cs_data-zdaehhr
                                                           cs_data-zdaehamt
                                                          '1.5'.
       ENDIF.
     ENDIF.
   ENDIF.
ENDIF.


  ENDIF.


    MODIFY ct_data FROM cs_data. CLEAR cs_data.

  ENDLOOP.


  CLEAR: l_chk.

ENDFUNCTION.
