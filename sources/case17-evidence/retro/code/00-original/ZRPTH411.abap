*&**********************************************************************
*&    Program Name  : ZRPTH411
*&    Description   : 선택근무 마감 및 지급
*&    Transaction   : ZRh411
*&    Program Type  : ALV
*&    Programmed by : .
*&    DEV.CLASS     : ZHR5
*&    Create Date   : 2019/05/22
*&    Change by     :
*     Change Date   :
*&**********************************************************************

INCLUDE zrpth411top.
INCLUDE zrpth411f01.
INCLUDE zrpth411f02.

*---------------------------------------------------------------------*
INITIALIZATION.
  g_mon_eda(6) = pa_yymm.
  g_mon_eda+6(2) = '01'.
  CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = g_mon_eda
    IMPORTING
      last_day_of_month = g_mon_eda.

  pnpstat2 = 'IEQ'.
  pnpstat2-low = '3'.
  APPEND pnpstat2.
  pnpbegda = g_mon_eda.

  pnppersk = 'IEQ'.
  pnppersk-low = 'A1'.
  APPEND pnppersk. CLEAR pnppersk.

  pnppersk = 'IEQ'.
  pnppersk-low = 'B1'.
  APPEND pnppersk. CLEAR pnppersk.

  pnppersk = 'IEQ'.
  pnppersk-low = 'C1'.
  APPEND pnppersk. CLEAR pnppersk.

  pnppersk = 'IEQ'.
  pnppersk-low = 'E1'.
  APPEND pnppersk. CLEAR pnppersk.

  pnppersk = 'IEQ'.
  pnppersk-low = 'E5'. " 특정업무직 추가 xa30752 (2020.05.07)
  APPEND pnppersk. CLEAR pnppersk.

  pnppersk = 'IEQ'.
  pnppersk-low = 'E6'. " 특정업무직 추가 xa30752 (2020.05.07)
  APPEND pnppersk. CLEAR pnppersk.

  pnppersk = 'IEQ'.
  pnppersk-low = 'E7'. " 특정업무직 추가 xa30752 (2020.05.07)
  APPEND pnppersk. CLEAR pnppersk.

  pnppersk = 'IEQ'.
  pnppersk-low = 'E8'. " 특정업무직 추가 xa30752 (2020.05.07)
  APPEND pnppersk. CLEAR pnppersk.


*======================================================================*
* AT SELECTION-SCREEN ON VALUE-REQUEST
*======================================================================*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_yymm.
  PERFORM f4_yymm.


*======================================================================*
* AT SELECTION-SCREEN ON VALUE-REQUEST
*======================================================================*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_zseq.
  PERFORM f4_zseq.


*======================================================================*
* AT SELECTION-SCREEN ON VALUE-REQUEST
*======================================================================*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_retmo.
  PERFORM f4_retmo.


*---------------------------------------------------------------------*
START-OF-SELECTION.
*---------------------------------------------------------------------*
  IF rb2 = 'X' AND  pa_admdt IS INITIAL.
    MESSAGE s016(pn) WITH 'PA전기일(정산일)을 입력하세요'.
    EXIT.
  ENDIF.

  IF rb2 = 'X' AND   pa_retro = 'X' AND pa_retmo IS NOT INITIAL.
    IF pa_yymm <= pa_retmo.
      MESSAGE s016(pn) WITH '소급시작연월을 대상년월 이전월로 입력하세요'.
      EXIT.
    ENDIF.

    IF pnppernr IS INITIAL.
      MESSAGE s016(pn) WITH '소급분 정산 시 사번을 입력하세요'. " xa30752 (2020.05.07)
      EXIT.
    ENDIF.

  ENDIF.

*------- 20201012 김지훈 선택근로 해당월 마감 여부 체크 로직---------
*  TABLES : zthr0160.

*  IF rb3 = 'X'.
**    SELECT * FROM zthr0160 WHERE zmonth = pa_yymm AND z52wktp = '0110' .
**    ENDSELECT.
**
**    IF sy-subrc = 0.
**      MESSAGE i016(pn) WITH pa_yymm+4(2) '월은 이미 미결처리 하셨습니다'.
**      exit.
**    ENDIF.
*
*  ENDIF.
*----------------------------------------------------------

  DATA l_yymm(7).
  l_yymm(6) = pa_yymm.
  l_yymm+6(1) = '%'.

  g_mon_eda(6) = pa_yymm.
  CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = g_mon_eda
    IMPORTING
      last_day_of_month = g_mon_eda.

  pnpbegda = g_mon_eda.
  pnpendda = g_mon_eda.

  CASE 'X'.
    WHEN rb1 OR rb2 OR rb4.
      "선택근로제 정산확정
      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE gt_0113
        FROM zthr0113
       WHERE zadmit_ym = pa_yymm
         AND pernr IN pnppernr
         AND endda LIKE l_yymm
         AND z52wktp = pa_zwktp
         AND z52prsq = pa_zseq.

      SORT gt_0113 BY pernr.

      IF gt_0113[] IS NOT INITIAL.
        "지급정보
        SELECT  *
          INTO CORRESPONDING FIELDS OF TABLE p2010
          FROM pa2010
           FOR ALL ENTRIES IN gt_0113
         WHERE pernr = gt_0113-pernr
           AND subty = '8050'
           AND begda = gt_0113-zadmit_dt
           AND endda = gt_0113-zadmit_dt.

        SORT p2010.
      ENDIF.

      "근로유형
      PERFORM get_52wkty_text USING 'ZD52WKTP1'
                                     pa_zwktp
                                     g_wktp_tx.

    WHEN rb3.  "미결재마감실행
      "선택근로제 실적
      SELECT *
        INTO CORRESPONDING FIELDS OF TABLE gt_0112
        FROM zthr0112
       WHERE pernr IN pnppernr
         AND z52wktp = pa_zwktp
         AND z52prsq = pa_zseq
         AND endda LIKE l_yymm
         AND state IN ('0', 'E').

      SORT gt_0112 BY pernr datum.
  ENDCASE.

  "부서정보
  SELECT *
    INTO CORRESPONDING FIELDS OF TABLE gt_0500
    FROM zth0500
   WHERE begda <= g_mon_eda
     AND endda >= g_mon_eda
   ORDER BY objid.



GET pernr.

  CASE 'X'.
    WHEN rb1. "확정조회 및 취소
      LOOP AT gt_0113 WHERE pernr = pernr-pernr.
        PERFORM get_calc_data_display.
      ENDLOOP.
      IF sy-subrc = 0.
        ADD 1 TO gv_pcnt.
      ENDIF.

    WHEN rb2. " 월 정산금액
      READ TABLE gt_0113 WITH KEY pernr = pernr-pernr BINARY SEARCH
      TRANSPORTING NO FIELDS.
      IF sy-subrc = 0. REJECT. ENDIF.

      PERFORM set_calc_wkprd_amt.
      PERFORM modify_amt. "Add / xa32762

    WHEN rb3. "미결처리
      LOOP AT  gt_0112 WHERE pernr = pernr-pernr.
        ADD 1 TO gv_pcnt.
        PERFORM set_miss_approve_list.
      ENDLOOP.

    WHEN rb4. "월 합계
      PERFORM get_calc_sum_data_display.

      gv_pcnt = LINES( gt_disp3 ).
  ENDCASE.


*---------------------------------------------------------------------*
END-OF-SELECTION.
*---------------------------------------------------------------------*
  CASE 'X'.
    WHEN rb1 OR rb2 .
      IF gt_disp2[] IS INITIAL.
        MESSAGE s016(pn) WITH '조회할 DATA가 존재하지 않습니다'.
        EXIT.
      ENDIF.
    WHEN rb3.
      IF gt_disp[] IS INITIAL.
        MESSAGE s016(pn) WITH '조회할 DATA가 존재하지 않습니다'.
        EXIT.
      ENDIF.

    WHEN rb4.
      IF gt_disp3[] IS INITIAL.
        MESSAGE s016(pn) WITH '조회할 DATA가 존재하지 않습니다'.
        EXIT.
      ENDIF.
  ENDCASE.


  CALL SCREEN 100.
*---------------------------------------------------------------------*
