REPORT zrpth411_compare.
* Title: 선택근무 정산 전후 변경 비교
* New read-only report. SAP_BASIS 700. No changes to original objects.
* Basis: SRC-17 KSP/300 export 2026-10-22. See accompanying README.md.
* 2026-10-26: accept AWART's known empty-result return; preserve other errors.
* No database INSERT/UPDATE/MODIFY/DELETE, COMMIT, SUBMIT or save callback.
* Amounts shown in won. Stored period CURR values are multiplied by 100;
* BS01-ZD_MONEY is already in the generation routine's external won unit.
TYPE-POOLS: slis.

TYPES: ty_money TYPE p LENGTH 12 DECIMALS 2,
       ty_money_text TYPE c LENGTH 24,
       ty_duration TYPE c LENGTH 12,
       ty_note TYPE c LENGTH 250.
TYPES: tt_period TYPE STANDARD TABLE OF zthr0132 WITH DEFAULT KEY,
       tt_work TYPE STANDARD TABLE OF zshr0145 WITH DEFAULT KEY,
       tt_awart TYPE STANDARD TABLE OF zshr0111 WITH DEFAULT KEY,
       tt_calc TYPE STANDARD TABLE OF zthr0113 WITH DEFAULT KEY,
       tt_daeh TYPE STANDARD TABLE OF zshr0146 WITH DEFAULT KEY,
       tt_bs01 TYPE STANDARD TABLE OF zthrbs01 WITH DEFAULT KEY.

TYPES: BEGIN OF ty_summary,
         row_id TYPE i,
         pernr TYPE pernr_d,
         ename TYPE pa0001-ename,
         begda TYPE dats,
         endda TYPE dats,
         zadmit_ym TYPE zthr0113-zadmit_ym,
         zadmit_dt TYPE dats,
         calc_state TYPE c LENGTH 16,
         compare_state TYPE c LENGTH 30,
         old_amt TYPE ty_money_text,
         new_amt TYPE ty_money_text,
         diff_amt TYPE ty_money_text,
         settled_count TYPE i,
         current_count TYPE i,
         new_count TYPE c LENGTH 10,
         count_diff TYPE c LENGTH 10,
         settled_hours TYPE ty_duration,
         current_hours TYPE ty_duration,
         new_hours TYPE ty_duration,
         hour_diff TYPE ty_duration,
         current_daeh_amt TYPE ty_money_text,
         new_daeh_amt TYPE ty_money_text,
         added TYPE i,
         removed TYPE i,
         changed TYPE i,
         used_count TYPE i,
         settled_rest_count TYPE i,
         detail TYPE c LENGTH 12,
         note TYPE ty_note,
       END OF ty_summary.
TYPES: BEGIN OF ty_detail,
         row_id TYPE i,
         pernr TYPE pernr_d,
         source_date TYPE dats,
         daeh_date TYPE dats,
         old_count TYPE i,
         new_count TYPE i,
         new_count_text TYPE c LENGTH 10,
         old_min TYPE i,
         new_min TYPE i,
         old_money TYPE ty_money,
         new_money TYPE ty_money,
         old_hours TYPE ty_duration,
         new_hours TYPE ty_duration,
         old_amt TYPE ty_money_text,
         new_amt TYPE ty_money_text,
         delta_amt TYPE ty_money_text,
         used_count TYPE i,
         settled_count TYPE i,
         state TYPE c LENGTH 20,
         note TYPE ty_note,
       END OF ty_detail.
TYPES: BEGIN OF ty_item,
         row_id TYPE i,
         name TYPE c LENGTH 30,
         old_amt TYPE ty_money_text,
         new_amt TYPE ty_money_text,
         delta_amt TYPE ty_money_text,
       END OF ty_item.
TYPES: tt_detail TYPE STANDARD TABLE OF ty_detail WITH DEFAULT KEY.
DATA: gt_settled TYPE tt_calc,
      gt_summary TYPE STANDARD TABLE OF ty_summary,
      gt_detail TYPE tt_detail,
      gt_items TYPE STANDARD TABLE OF ty_item,
      gs_summary TYPE ty_summary,
      gv_row_id TYPE i,
      gv_denied TYPE i.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE gv_title.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(24) gv_perd FOR FIELD p_begda.
PARAMETERS p_begda TYPE zthr0132-begda OBLIGATORY.
SELECTION-SCREEN POSITION 42.
PARAMETERS p_endda TYPE zthr0132-endda OBLIGATORY.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(24) gv_pers FOR FIELD p_pernr.
PARAMETERS p_pernr TYPE pernr_d.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN COMMENT /1(79) gv_hint.
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
  gv_title = '선택근무 정산 전후 변경 비교'.
  gv_perd = '선택근무 기간(시작/종료)'.
  gv_pers = '사번(공란: 전체 대상자)'.
  gv_hint = '정확히 일치하는 선택기간의 확정자료 조회 / 업무 DB 변경 없음'.

AT SELECTION-SCREEN.
  IF p_endda < p_begda.
    MESSAGE '종료일은 시작일보다 빠를 수 없습니다.' TYPE 'E'.
  ENDIF.

START-OF-SELECTION.
  AUTHORITY-CHECK OBJECT 'S_TCODE' ID 'TCD' FIELD 'ZHR5_CW_CMP'.
  IF sy-subrc <> 0.
    MESSAGE 'ZHR5_CW_CMP 실행권한이 필요합니다.' TYPE 'S'
      DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.
  PERFORM read_targets.
  IF gt_settled IS INITIAL.
    MESSAGE '입력한 선택기간에 정산 완료된 자료가 없습니다.' TYPE 'S'.
    RETURN.
  ENDIF.
  PERFORM compare_targets.
  IF gt_summary IS INITIAL.
    MESSAGE '조회권한 또는 인사정보를 확인할 수 있는 대상이 없습니다.'
      TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.
  PERFORM display_summary.

FORM read_targets.
  IF p_pernr IS INITIAL.
    SELECT * FROM zthr0113 INTO TABLE gt_settled
      WHERE begda = p_begda AND endda = p_endda
        AND z52wktp = '0110' AND z52prsq = '04'
        AND zadmit_dt <> '00000000'.
  ELSE.
    SELECT * FROM zthr0113 INTO TABLE gt_settled
      WHERE pernr = p_pernr
        AND begda = p_begda AND endda = p_endda
        AND z52wktp = '0110' AND z52prsq = '04'
        AND zadmit_dt <> '00000000'.
  ENDIF.
  SORT gt_settled BY pernr begda endda zadmit_ym.
ENDFORM.

FORM compare_targets.
  DATA: ls_old TYPE zthr0113,
        ls_org TYPE pa0001,
        lv_allowed TYPE c,
        lv_number TYPE i,
        ls_check TYPE zthr0113.
  LOOP AT gt_settled INTO ls_old.
    CLEAR: ls_org, lv_allowed.
    PERFORM check_person USING ls_old-pernr ls_old-endda
                         CHANGING ls_org lv_allowed.
    IF lv_allowed IS INITIAL.
      ADD 1 TO gv_denied.
      CONTINUE.
    ENDIF.
    ADD 1 TO gv_row_id.
    CLEAR gs_summary.
    gs_summary-row_id = gv_row_id.
    gs_summary-pernr = ls_old-pernr.
    gs_summary-ename = ls_org-ename.
    gs_summary-begda = ls_old-begda.
    gs_summary-endda = ls_old-endda.
    gs_summary-zadmit_ym = ls_old-zadmit_ym.
    gs_summary-zadmit_dt = ls_old-zadmit_dt.
    gs_summary-settled_count = ls_old-zdaeh_day.
    gs_summary-detail = '상세 비교'.
    gs_summary-new_amt = '미계산'.
    gs_summary-diff_amt = '미계산'.
    gs_summary-new_count = '미계산'.
    gs_summary-count_diff = '미계산'.
    gs_summary-new_hours = '미계산'.
    gs_summary-hour_diff = '미계산'.
    gs_summary-new_daeh_amt = '미계산'.
    gs_summary-calc_state = '계산 불가'.
    gs_summary-compare_state = '확인 필요'.
    PERFORM stored_amount USING ls_old-zrlprdamt
                         CHANGING gs_summary-old_amt.
    PERFORM stored_duration USING ls_old-zdaehhr
                            CHANGING gs_summary-settled_hours.
    CLEAR lv_number.
    LOOP AT gt_settled INTO ls_check
      WHERE pernr = ls_old-pernr AND begda = ls_old-begda
        AND endda = ls_old-endda.
      ADD 1 TO lv_number.
    ENDLOOP.
    IF lv_number <> 1.
      gs_summary-note = '동일 선택기간의 확정월이 여러 건입니다. 기준 확인 필요'.
    ELSE.
      TRY.
          PERFORM compare_one USING ls_old CHANGING gs_summary.
        CATCH cx_sy_arithmetic_error.
          PERFORM discard_partial USING gs_summary-row_id
                                  CHANGING gs_summary.
          gs_summary-note = '계산 중 산술 오류: 입력 시간과 단가를 확인하십시오.'.
        CATCH cx_sy_conversion_error.
          PERFORM discard_partial USING gs_summary-row_id
                                  CHANGING gs_summary.
          gs_summary-note = '시간 또는 금액 변환 오류: 저장 형식을 확인하십시오.'.
      ENDTRY.
    ENDIF.
    APPEND gs_summary TO gt_summary.
  ENDLOOP.
ENDFORM.

FORM discard_partial USING pv_id TYPE i CHANGING ps_out TYPE ty_summary.
  DATA: ls_line TYPE ty_detail, lv_index TYPE sy-tabix.
* An exception must never expose half-completed proposed results.
  DELETE gt_items WHERE row_id = pv_id.
  DELETE gt_detail WHERE row_id = pv_id AND old_count = 0.
  LOOP AT gt_detail INTO ls_line WHERE row_id = pv_id.
    lv_index = sy-tabix.
    CLEAR: ls_line-new_count, ls_line-new_min, ls_line-new_money.
    MODIFY gt_detail FROM ls_line INDEX lv_index.
  ENDLOOP.
  ps_out-new_amt = '미계산'.
  ps_out-diff_amt = '미계산'.
  ps_out-new_count = '미계산'.
  ps_out-count_diff = '미계산'.
  ps_out-new_hours = '미계산'.
  ps_out-hour_diff = '미계산'.
  ps_out-new_daeh_amt = '미계산'.
  ps_out-calc_state = '계산 불가'.
  ps_out-compare_state = '확인 필요'.
  PERFORM finalize_rest USING pv_id space CHANGING ps_out.
ENDFORM.

FORM check_person USING pv_pernr TYPE pernr_d pv_date TYPE dats
                  CHANGING ps_org TYPE pa0001 pv_allowed TYPE c.
* Explicit read permission for the historical personnel assignment.
* P_ORGIN does not replace site-specific P_ORGINCON/structural authorization.
  CLEAR: ps_org, pv_allowed.
  SELECT * FROM pa0001 UP TO 1 ROWS INTO ps_org
    WHERE pernr = pv_pernr AND begda <= pv_date
    ORDER BY endda DESCENDING.
  ENDSELECT.
  IF sy-subrc <> 0.
    RETURN.
  ENDIF.
  AUTHORITY-CHECK OBJECT 'P_ORGIN'
    ID 'INFTY' FIELD '2010' ID 'SUBTY' FIELD '8050'
    ID 'AUTHC' FIELD 'R' ID 'PERSA' FIELD ps_org-werks
    ID 'PERSG' FIELD ps_org-persg ID 'PERSK' FIELD ps_org-persk
    ID 'VDSK1' FIELD ps_org-vdsk1.
  IF sy-subrc = 0.
    pv_allowed = 'X'.
  ENDIF.
ENDFORM.

FORM compare_one USING ps_old TYPE zthr0113
                 CHANGING ps_out TYPE ty_summary.
  DATA: lt_period TYPE tt_period,
        ls_period TYPE zthr0132,
        lt_overlap TYPE tt_period,
        lt_all TYPE tt_work,
        lt_work TYPE tt_work,
        lt_virtual TYPE tt_work,
        lt_awart TYPE tt_awart,
        lt_new TYPE tt_daeh,
        lt_save TYPE tt_work,
        lt_calc TYPE tt_calc,
        lt_dummy_daeh TYPE tt_daeh,
        lt_dummy_save TYPE tt_work,
        lt_old_rest TYPE tt_bs01,
        ls_work TYPE zshr0145,
        ls_save TYPE zshr0145,
        ls_new TYPE zshr0146,
        ls_calc TYPE zthr0113,
        ls_rate TYPE zshr0143,
        ls_return TYPE bapireturn1,
        lv_awart_empty_text TYPE bapireturn1-message,
        lv_awart_blocked TYPE c,
        ls_manual TYPE zthreditcost,
        lv_error TYPE ty_note,
        lv_index TYPE sy-tabix,
        lv_new_count TYPE i,
        lv_new_min TYPE i,
        lv_save_count TYPE i,
        lv_save_min TYPE i,
        lv_old_min TYPE i,
        lv_min TYPE i,
        lv_delta TYPE i,
        lv_money TYPE ty_money,
        lv_bs_money TYPE zthrbs01-zd_money,
        lv_new_money TYPE ty_money,
        lv_old_money TYPE ty_money,
        lv_diff_money TYPE ty_money,
        lv_money_changed TYPE c,
        lv_rest_changed TYPE c,
        lv_has_pending TYPE c,
        lv_rows TYPE i.

* Read all source states for linkage; only 3/H enter the settled calculation.
  SELECT * FROM zthr0112 INTO CORRESPONDING FIELDS OF TABLE lt_all
    WHERE pernr = ps_old-pernr AND begda = ps_old-begda
      AND endda = ps_old-endda AND z52wktp = '0110'
      AND z52prsq = '04'.
  SORT lt_all BY datum seqnr.
  SELECT * FROM zthrbs01 INTO TABLE lt_old_rest
    WHERE pernr = ps_old-pernr AND rdate >= ps_old-begda
      AND rdate <= ps_old-endda AND zsourflex = 'S'
      AND state = '3' AND zdaeh = 'Y'.
  PERFORM collect_old_rest TABLES lt_old_rest lt_all
    USING ps_out-row_id ps_old-pernr
    CHANGING ps_out lv_old_min lv_old_money.

  SELECT SINGLE * FROM zthr0132 INTO ls_period
    WHERE pernr = ps_old-pernr AND begda = ps_old-begda
      AND endda = ps_old-endda AND z52wktp = '0110'
      AND z52prsq = '04'.
  IF sy-subrc <> 0.
    PERFORM add_note USING '선택기간 기준자료 없음(ZTHR0132)'
                    CHANGING ps_out-note.
    RETURN.
  ENDIF.
  SELECT * FROM zthr0132 INTO TABLE lt_overlap
    WHERE pernr = ps_old-pernr AND begda <= ps_old-endda
      AND endda >= ps_old-begda AND z52wktp = '0110'
      AND z52prsq = '04'.
  DESCRIBE TABLE lt_overlap LINES lv_rows.
  IF lv_rows <> 1.
    PERFORM add_note USING '선택기간 중복 등록: 대휴 귀속 확인 필요'
                    CHANGING ps_out-note.
    RETURN.
  ENDIF.
  APPEND ls_period TO lt_period.
  LOOP AT lt_all INTO ls_work.
    IF ls_work-state = 'E'.
      lv_has_pending = 'X'.
    ENDIF.
    IF ls_work-state = '3' OR ls_work-state = 'H'.
      APPEND ls_work TO lt_work.
    ELSEIF ls_work-state <> '2'.
      PERFORM add_note USING '계산 제외 상태 실적 존재(3/H만 산입)'
                      CHANGING ps_out-note.
    ENDIF.
  ENDLOOP.
  IF lv_has_pending = 'X'.
    PERFORM add_note USING 'E 상태 실적: 기존 소급/대휴 상태범위가 달라 계산 보류'
                    CHANGING ps_out-note.
    RETURN.
  ENDIF.
  PERFORM load_period_rate USING ps_old-pernr ps_old-begda
                          CHANGING ls_rate lv_error.
  IF lv_error IS NOT INITIAL.
    PERFORM add_note USING lv_error CHANGING ps_out-note.
    RETURN.
  ENDIF.
  CLEAR ls_return.
  CALL FUNCTION 'ZHR_52TM_AWART_LIST'
    EXPORTING i_pernr = ps_old-pernr i_begda = ps_old-begda
              i_endda = ps_old-endda i_zsangsin = 'X'
    IMPORTING e_return = ls_return
    TABLES t_data = lt_awart.
* AWART_LIST returns E/M01 for a valid empty auxiliary attendance list.
* Empty AWART does not mean that the employee has no working-time actuals.
  DESCRIBE TABLE lt_awart LINES lv_rows.
  IF ls_return-type = 'E' AND lv_rows = 0.
    PERFORM get_awart_empty_text CHANGING lv_awart_empty_text.
  ENDIF.
  PERFORM check_awart_result USING ls_return lv_rows lv_awart_empty_text
                            CHANGING lv_awart_blocked.
  IF lv_awart_blocked = 'X'.
    PERFORM add_note USING ls_return-message CHANGING ps_out-note.
    RETURN.
  ENDIF.
  SELECT SINGLE * FROM zthreditcost INTO ls_manual
    WHERE zadmit_ym = ps_old-zadmit_ym AND pernr = ps_old-pernr.
  IF sy-subrc = 0.
    PERFORM add_note USING '월별 수기보정 존재: 재계산은 보정 전 산식 금액'
                    CHANGING ps_out-note.
  ENDIF.

* Never clear database flags. Only this private working copy is reset.
  lt_virtual[] = lt_work[].
  LOOP AT lt_virtual INTO ls_work.
    lv_index = sy-tabix.
    CLEAR: ls_work-zdaeh, ls_work-zdaeh_day, ls_work-zdaeh_tm.
    MODIFY lt_virtual FROM ls_work INDEX lv_index.
  ENDLOOP.
  PERFORM rc_calculate TABLES lt_period lt_virtual lt_awart
    lt_calc lt_new lt_save USING 'C' ls_rate.
* Overlay every source with new flags; zero-result sources stay reset.
  LOOP AT lt_save INTO ls_save.
    READ TABLE lt_virtual INTO ls_work WITH KEY
      pernr = ls_save-pernr datum = ls_save-datum
      begda = ls_save-begda endda = ls_save-endda
      z52wktp = ls_save-z52wktp z52prsq = ls_save-z52prsq
      seqnr = ls_save-seqnr.
    IF sy-subrc <> 0.
      PERFORM add_note USING '새 대휴와 원천 실적 연결 오류'
                      CHANGING ps_out-note.
      RETURN.
    ENDIF.
    lv_index = sy-tabix.
    ls_work-zdaeh = ls_save-zdaeh.
    ls_work-zdaeh_day = ls_save-zdaeh_day.
    ls_work-zdaeh_tm = ls_save-zdaeh_tm.
    MODIFY lt_virtual FROM ls_work INDEX lv_index.
    ADD ls_save-zdaeh_day TO lv_save_count.
    PERFORM convert_time_to_min USING ls_save-zdaeh_tm
                                CHANGING lv_min.
    ADD lv_min TO lv_save_min.
  ENDLOOP.
  LOOP AT lt_new INTO ls_new.
    IF ls_new-zcost <= 0.
      PERFORM add_note USING '새 대휴의 원천 실적 단가 누락/오류'
                      CHANGING ps_out-note.
      RETURN.
    ENDIF.
    ADD 1 TO lv_new_count.
    PERFORM convert_time_to_min USING ls_new-zrlwk_tm CHANGING lv_min.
    ADD lv_min TO lv_new_min.
    lv_bs_money = ( lv_min / 60 ) * ( ls_new-zcost * '0.5' ) * 100.
    lv_money = lv_bs_money.
    ADD lv_money TO lv_new_money.
    IF ls_new-zcost <> ls_rate-zcost.
      PERFORM add_note USING '기간 시작일 단가와 대휴 실적 단가가 다름'
                      CHANGING ps_out-note.
    ENDIF.
  ENDLOOP.
  IF lv_save_count <> lv_new_count OR lv_save_min <> lv_new_min.
    PERFORM add_note USING '실적 대휴 집계와 새 대휴 개수/시간 불일치'
                    CHANGING ps_out-note.
    RETURN.
  ENDIF.
* B and C intentionally use the same snapshot and same eligibility set.
  PERFORM rc_calculate TABLES lt_period lt_virtual lt_awart
    lt_calc lt_dummy_daeh lt_dummy_save USING 'B' ls_rate.
  READ TABLE lt_calc INTO ls_calc INDEX 1.
  IF sy-subrc <> 0 OR ls_calc-zdaeh_day <> lv_new_count.
    PERFORM add_note USING '기간 계산과 대휴 산출 개수 불일치'
                    CHANGING ps_out-note.
    RETURN.
  ENDIF.
  PERFORM collect_new_rest TABLES lt_new
    USING ps_out-row_id ps_old-pernr.
  PERFORM finalize_rest USING ps_out-row_id 'X' CHANGING ps_out.
  PERFORM build_items USING ps_out-row_id ps_old ls_calc.

  PERFORM stored_amount USING ls_calc-zrlprdamt
                       CHANGING ps_out-new_amt.
  lv_diff_money = ( ls_calc-zrlprdamt - ps_old-zrlprdamt ) * 100.
  PERFORM format_money USING lv_diff_money CHANGING ps_out-diff_amt.
  WRITE lv_new_count TO ps_out-new_count LEFT-JUSTIFIED.
  lv_delta = lv_new_count - ps_out-current_count.
  WRITE lv_delta TO ps_out-count_diff LEFT-JUSTIFIED.
  PERFORM format_duration USING lv_new_min CHANGING ps_out-new_hours.
  lv_delta = lv_new_min - lv_old_min.
  PERFORM format_duration USING lv_delta CHANGING ps_out-hour_diff.
  PERFORM format_money USING lv_new_money CHANGING ps_out-new_daeh_amt.
  IF lv_diff_money <> 0
    OR ls_calc-zrlovramt <> ps_old-zrlovramt
    OR ls_calc-zrlngtamt <> ps_old-zrlngtamt
    OR ls_calc-zrlholamt <> ps_old-zrlholamt
    OR ls_calc-zdaehamt <> ps_old-zdaehamt
    OR ls_calc-tdcost <> ps_old-tdcost.
    lv_money_changed = 'X'.
  ENDIF.
  IF ps_out-added <> 0 OR ps_out-removed <> 0 OR ps_out-changed <> 0.
    lv_rest_changed = 'X'.
  ENDIF.
  IF ps_out-current_count <> ps_out-settled_count
    OR ps_out-current_hours <> ps_out-settled_hours.
    PERFORM add_note USING '정산 당시 대휴 집계와 현재 등록 내역 불일치'
                    CHANGING ps_out-note.
  ENDIF.
  IF lv_money_changed = 'X' AND lv_rest_changed = 'X'.
    ps_out-compare_state = '금액 및 대휴 차이'.
  ELSEIF lv_money_changed = 'X'.
    ps_out-compare_state = '금액 차이'.
  ELSEIF lv_rest_changed = 'X'.
    ps_out-compare_state = '대휴 차이'.
  ELSE.
    ps_out-compare_state = '차이 없음'.
  ENDIF.
  ps_out-calc_state = '계산 완료'.
  IF ps_out-note IS NOT INITIAL.
    ps_out-calc_state = '확인 필요'.
  ENDIF.
ENDFORM.

FORM get_awart_empty_text CHANGING pv_text TYPE bapireturn1-message.
  STATICS: lv_loaded TYPE c,
           lv_text TYPE bapireturn1-message.
  DATA: lt_text TYPE STANDARD TABLE OF textpool,
        ls_text TYPE textpool.
  IF lv_loaded IS INITIAL.
* Match the function group's own M01 text in the current logon language.
    READ TEXTPOOL 'SAPLZHR008_2' INTO lt_text LANGUAGE sy-langu.
    IF sy-subrc = 0.
      READ TABLE lt_text INTO ls_text WITH KEY id = 'I' key = 'M01'.
      IF sy-subrc = 0 AND ls_text-entry IS NOT INITIAL.
        lv_text = ls_text-entry.
      ENDIF.
    ENDIF.
    IF lv_text IS INITIAL.
* Exact Korean fallback verified in SRC-17 and the supplied test result.
      lv_text = '해당 데이터가 없습니다.'.
    ENDIF.
    lv_loaded = 'X'.
  ENDIF.
  pv_text = lv_text.
ENDFORM.

FORM check_awart_result USING ps_return TYPE bapireturn1
                              pv_rows TYPE i
                              pv_empty_text TYPE bapireturn1-message
                       CHANGING pv_blocked TYPE c.
  DATA ls_empty_return TYPE bapireturn1.
  CLEAR pv_blocked.
  IF ps_return-type = 'E' OR ps_return-type = 'A'.
    pv_blocked = 'X'.
  ENDIF.
* SRC-17 AWART_LIST sets only TYPE=E and MESSAGE=M01 for zero results.
* Compare the entire return structure so other codes/log details stay errors.
  IF ps_return-type = 'E' AND pv_rows = 0
    AND pv_empty_text IS NOT INITIAL.
    ls_empty_return-type = 'E'.
    ls_empty_return-message = pv_empty_text.
    IF ps_return = ls_empty_return.
      CLEAR pv_blocked.
    ENDIF.
  ENDIF.
ENDFORM.

FORM collect_old_rest TABLES pt_rest STRUCTURE zthrbs01
                            pt_all STRUCTURE zshr0145
  USING pv_id TYPE i pv_pernr TYPE pernr_d
  CHANGING ps_out TYPE ty_summary pv_min TYPE i pv_money TYPE ty_money.
  DATA: ls_line TYPE ty_detail,
        lv_min TYPE i,
        lv_index TYPE sy-tabix.
  LOOP AT pt_rest.
    CLEAR ls_line.
    READ TABLE gt_detail INTO ls_line WITH KEY row_id = pv_id
      source_date = pt_rest-rdate daeh_date = pt_rest-zdday.
    IF sy-subrc = 0.
      lv_index = sy-tabix.
    ELSE.
      CLEAR lv_index.
      ls_line-row_id = pv_id.
      ls_line-pernr = pv_pernr.
      ls_line-source_date = pt_rest-rdate.
      ls_line-daeh_date = pt_rest-zdday.
    ENDIF.
    ADD 1 TO ls_line-old_count.
    ADD 1 TO ps_out-current_count.
    PERFORM convert_time_to_min USING pt_rest-zd_time CHANGING lv_min.
    ADD lv_min TO ls_line-old_min.
    ADD lv_min TO pv_min.
    ADD pt_rest-zd_money TO ls_line-old_money.
    ADD pt_rest-zd_money TO pv_money.
    IF pt_rest-zdchk = 'Y' OR pt_rest-zdhdate IS NOT INITIAL.
      ADD 1 TO ls_line-used_count.
      ADD 1 TO ps_out-used_count.
    ENDIF.
    IF pt_rest-jorgeh_txt IS NOT INITIAL.
      ADD 1 TO ls_line-settled_count.
      ADD 1 TO ps_out-settled_rest_count.
    ENDIF.
    IF pt_rest-jorgeh IS NOT INITIAL.
      PERFORM add_note USING '기존 현금정산/보정금액 존재(금액만으로 완료 판정 안 함)'
                      CHANGING ls_line-note.
      PERFORM add_note USING '대휴 현금정산/보정금액 확인 필요'
                      CHANGING ps_out-note.
    ENDIF.
    READ TABLE pt_all WITH KEY datum = pt_rest-rdate.
    IF sy-subrc <> 0 OR pt_rest-zdday IS INITIAL.
      PERFORM add_note USING '원천 실적 또는 발생일 연결 확인 필요'
                      CHANGING ls_line-note.
      PERFORM add_note USING '기존 대휴의 원천 연결 확인 필요'
                      CHANGING ps_out-note.
    ENDIF.
    IF lv_index = 0.
      APPEND ls_line TO gt_detail.
    ELSE.
      MODIFY gt_detail FROM ls_line INDEX lv_index.
    ENDIF.
  ENDLOOP.
  PERFORM format_duration USING pv_min CHANGING ps_out-current_hours.
  PERFORM format_money USING pv_money CHANGING ps_out-current_daeh_amt.
  IF ps_out-used_count > 0 OR ps_out-settled_rest_count > 0.
    PERFORM add_note USING '사용/정산 표시 있음: 향후 자동 적용 제외 대상'
                    CHANGING ps_out-note.
  ENDIF.
  PERFORM finalize_rest USING pv_id space CHANGING ps_out.
ENDFORM.

FORM collect_new_rest TABLES pt_new STRUCTURE zshr0146
                     USING pv_id TYPE i pv_pernr TYPE pernr_d.
  DATA: ls_line TYPE ty_detail,
        lv_min TYPE i,
        lv_money TYPE ty_money,
        lv_bs_money TYPE zthrbs01-zd_money,
        lv_index TYPE sy-tabix.
  LOOP AT pt_new.
    CLEAR ls_line.
    READ TABLE gt_detail INTO ls_line WITH KEY row_id = pv_id
      source_date = pt_new-datum daeh_date = pt_new-daeh_dt.
    IF sy-subrc = 0.
      lv_index = sy-tabix.
    ELSE.
      CLEAR lv_index.
      ls_line-row_id = pv_id.
      ls_line-pernr = pv_pernr.
      ls_line-source_date = pt_new-datum.
      ls_line-daeh_date = pt_new-daeh_dt.
    ENDIF.
    ADD 1 TO ls_line-new_count.
    PERFORM convert_time_to_min USING pt_new-zrlwk_tm CHANGING lv_min.
    ADD lv_min TO ls_line-new_min.
    lv_bs_money = ( lv_min / 60 ) * ( pt_new-zcost * '0.5' ) * 100.
    lv_money = lv_bs_money.
    ADD lv_money TO ls_line-new_money.
    IF lv_index = 0.
      APPEND ls_line TO gt_detail.
    ELSE.
      MODIFY gt_detail FROM ls_line INDEX lv_index.
    ENDIF.
  ENDLOOP.
ENDFORM.

FORM finalize_rest USING pv_id TYPE i pv_calculated TYPE c
                   CHANGING ps_out TYPE ty_summary.
  DATA: ls_line TYPE ty_detail,
        lv_index TYPE sy-tabix,
        lv_money TYPE ty_money.
  CLEAR: ps_out-added, ps_out-removed, ps_out-changed.
  LOOP AT gt_detail INTO ls_line WHERE row_id = pv_id.
    lv_index = sy-tabix.
    PERFORM format_duration USING ls_line-old_min
                            CHANGING ls_line-old_hours.
    PERFORM format_money USING ls_line-old_money CHANGING ls_line-old_amt.
    IF pv_calculated IS INITIAL.
      ls_line-state = '재계산 미완료'.
      ls_line-new_count_text = '미계산'.
      ls_line-new_hours = '미계산'.
      ls_line-new_amt = '미계산'.
      ls_line-delta_amt = '미계산'.
    ELSE.
      WRITE ls_line-new_count TO ls_line-new_count_text LEFT-JUSTIFIED.
      PERFORM format_duration USING ls_line-new_min
                              CHANGING ls_line-new_hours.
      PERFORM format_money USING ls_line-new_money
                           CHANGING ls_line-new_amt.
      lv_money = ls_line-new_money - ls_line-old_money.
      PERFORM format_money USING lv_money CHANGING ls_line-delta_amt.
      IF ls_line-old_count = 0.
        ls_line-state = '추가 예정'.
        ADD 1 TO ps_out-added.
      ELSEIF ls_line-new_count = 0.
        ls_line-state = '삭제 예정'.
        ADD 1 TO ps_out-removed.
      ELSEIF ls_line-old_count <> ls_line-new_count
        OR ls_line-old_min <> ls_line-new_min
        OR ls_line-old_money <> ls_line-new_money.
        ls_line-state = '내용 변경'.
        ADD 1 TO ps_out-changed.
      ELSE.
        ls_line-state = '동일'.
      ENDIF.
    ENDIF.
    MODIFY gt_detail FROM ls_line INDEX lv_index.
  ENDLOOP.
ENDFORM.

FORM load_period_rate USING pv_pernr TYPE pernr_d pv_date TYPE dats
                     CHANGING ps_rate TYPE zshr0143 pv_error TYPE ty_note.
  DATA: lv_raw TYPE zthrcost-zcost.
  CLEAR: ps_rate, pv_error.
  CALL FUNCTION 'ZHR_GET_PERSONNEL_RANK_N'
    EXPORTING i_pernr = pv_pernr i_znal = pv_date
    IMPORTING e_zdung = ps_rate-zdung
    EXCEPTIONS e1_no_overtime = 1 e1_zdung_error = 2
      e1_not_found_zdung = 3 not_found_zdung = 4 OTHERS = 5.
  IF sy-subrc <> 0.
    pv_error = '선택기간 시작일의 시간외 등급 조회 실패'.
    RETURN.
  ENDIF.
  SELECT SINGLE zcost INTO lv_raw FROM zthrcost
    WHERE z_ctype = '1' AND zdung = ps_rate-zdung
      AND begda <= pv_date AND endda >= pv_date AND zversn = '1'.
  IF sy-subrc <> 0 OR lv_raw <= 0.
    pv_error = '선택기간 시작일의 유효 단가 없음'.
    RETURN.
  ENDIF.
  ps_rate-zcost = lv_raw / 100.
ENDFORM.

FORM add_note USING pv_text CHANGING pv_note TYPE ty_note.
  IF pv_text IS INITIAL OR pv_note CS pv_text.
    RETURN.
  ENDIF.
  IF pv_note IS INITIAL.
    pv_note = pv_text.
  ELSE.
    CONCATENATE pv_note pv_text INTO pv_note SEPARATED BY ' / '.
  ENDIF.
ENDFORM.

FORM format_money USING pv_money TYPE ty_money
                  CHANGING pv_text TYPE ty_money_text.
  DATA lv_abs TYPE ty_money.
  lv_abs = abs( pv_money ).
  WRITE lv_abs TO pv_text DECIMALS 0.
  CONDENSE pv_text.
  IF pv_money < 0.
    CONCATENATE '-' pv_text INTO pv_text.
  ENDIF.
ENDFORM.

FORM stored_amount USING pv_amount
                   CHANGING pv_text TYPE ty_money_text.
  DATA lv_money TYPE ty_money.
  lv_money = pv_amount * 100.
  PERFORM format_money USING lv_money CHANGING pv_text.
ENDFORM.

FORM format_duration USING pv_min TYPE i
                     CHANGING pv_text TYPE ty_duration.
  DATA: lv_abs TYPE i, lv_hour TYPE i,
        lv_htext TYPE c LENGTH 8, lv_mtext TYPE n LENGTH 2.
  lv_abs = abs( pv_min ).
  lv_hour = lv_abs DIV 60.
  lv_mtext = lv_abs MOD 60.
  WRITE lv_hour TO lv_htext LEFT-JUSTIFIED.
  CONDENSE lv_htext.
  CONCATENATE lv_htext ':' lv_mtext INTO pv_text.
  IF pv_min < 0.
    CONCATENATE '-' pv_text INTO pv_text.
  ENDIF.
ENDFORM.

FORM stored_duration USING pv_saved
                     CHANGING pv_text TYPE ty_duration.
* ZTHR0113 time storage is HHHHMM, not TIMS and not decimal hours.
  DATA: lv_saved TYPE c LENGTH 6, lv_min TYPE i.
  lv_saved = pv_saved.
  IF lv_saved IS INITIAL.
    lv_min = 0.
  ELSEIF lv_saved CO '0123456789'.
    lv_min = lv_saved(4) * 60 + lv_saved+4(2).
  ELSE.
    pv_text = '형식 확인'.
    RETURN.
  ENDIF.
  PERFORM format_duration USING lv_min CHANGING pv_text.
ENDFORM.

FORM build_items USING pv_id TYPE i ps_old TYPE zthr0113
                       ps_new TYPE zthr0113.
  PERFORM append_item USING pv_id '기간실비 합계'
    ps_old-zrlprdamt ps_new-zrlprdamt.
  PERFORM append_item USING pv_id '연장실비'
    ps_old-zrlovramt ps_new-zrlovramt.
  PERFORM append_item USING pv_id '야간실비'
    ps_old-zrlngtamt ps_new-zrlngtamt.
  PERFORM append_item USING pv_id '휴일실비'
    ps_old-zrlholamt ps_new-zrlholamt.
  PERFORM append_item USING pv_id '대휴 발생 실비'
    ps_old-zdaehamt ps_new-zdaehamt.
  PERFORM append_item USING pv_id '시차실비'
    ps_old-tdcost ps_new-tdcost.
ENDFORM.

FORM append_item USING pv_id TYPE i pv_name pv_old pv_new.
  DATA: ls_item TYPE ty_item, lv_money TYPE ty_money.
  ls_item-row_id = pv_id.
  ls_item-name = pv_name.
  PERFORM stored_amount USING pv_old CHANGING ls_item-old_amt.
  PERFORM stored_amount USING pv_new CHANGING ls_item-new_amt.
  lv_money = ( pv_new - pv_old ) * 100.
  PERFORM format_money USING lv_money CHANGING ls_item-delta_amt.
  APPEND ls_item TO gt_items.
ENDFORM.

FORM field USING pv_field pv_text pv_length TYPE i pv_hot TYPE c
           CHANGING pt_cat TYPE slis_t_fieldcat_alv.
  DATA ls_cat TYPE slis_fieldcat_alv.
  ls_cat-fieldname = pv_field.
  ls_cat-seltext_l = pv_text.
  ls_cat-seltext_m = pv_text.
  ls_cat-seltext_s = pv_text.
  ls_cat-reptext_ddic = pv_text.
  ls_cat-outputlen = pv_length.
  ls_cat-hotspot = pv_hot.
  IF pv_field = 'BEGDA' OR pv_field = 'ENDDA'
    OR pv_field = 'ZADMIT_DT' OR pv_field = 'DAEH_DATE'
    OR pv_field = 'SOURCE_DATE'.
    ls_cat-datatype = 'DATS'.
  ENDIF.
  APPEND ls_cat TO pt_cat.
ENDFORM.

FORM display_summary.
  DATA: lt_cat TYPE slis_t_fieldcat_alv,
        ls_layout TYPE slis_layout_alv,
        lv_title TYPE lvc_title.
  PERFORM field USING 'PERNR' '사번' 10 space CHANGING lt_cat.
  PERFORM field USING 'ENAME' '성명' 12 space CHANGING lt_cat.
  PERFORM field USING 'BEGDA' '선택 시작일' 10 space CHANGING lt_cat.
  PERFORM field USING 'ENDDA' '선택 종료일' 10 space CHANGING lt_cat.
  PERFORM field USING 'ZADMIT_YM' '원정산월' 8 space CHANGING lt_cat.
  PERFORM field USING 'ZADMIT_DT' '원정산일' 10 space CHANGING lt_cat.
  PERFORM field USING 'CALC_STATE' '계산 상태' 12 space CHANGING lt_cat.
  PERFORM field USING 'COMPARE_STATE' '비교 결과' 20 space CHANGING lt_cat.
  PERFORM field USING 'OLD_AMT' '정산 당시 기간실비(원)' 22 'X'
    CHANGING lt_cat.
  PERFORM field USING 'NEW_AMT' '재계산 기간실비(원)' 22 'X'
    CHANGING lt_cat.
  PERFORM field USING 'DIFF_AMT' '기간 차액(원)' 20 'X' CHANGING lt_cat.
  PERFORM field USING 'SETTLED_COUNT' '정산 당시 대휴수' 16 space
    CHANGING lt_cat.
  PERFORM field USING 'CURRENT_COUNT' '현재 대휴수' 12 space
    CHANGING lt_cat.
  PERFORM field USING 'NEW_COUNT' '재계산 대휴수' 14 space
    CHANGING lt_cat.
  PERFORM field USING 'COUNT_DIFF' '대휴수 증감' 12 space CHANGING lt_cat.
  PERFORM field USING 'SETTLED_HOURS' '정산 당시 대휴시간' 18 space
    CHANGING lt_cat.
  PERFORM field USING 'CURRENT_HOURS' '현재 대휴시간' 16 space
    CHANGING lt_cat.
  PERFORM field USING 'NEW_HOURS' '재계산 대휴시간' 18 space
    CHANGING lt_cat.
  PERFORM field USING 'HOUR_DIFF' '대휴시간 증감' 16 space CHANGING lt_cat.
  PERFORM field USING 'CURRENT_DAEH_AMT' '현재 대휴 저장금액(원)' 22 space
    CHANGING lt_cat.
  PERFORM field USING 'NEW_DAEH_AMT' '재계산 대휴 저장금액(원)' 24 space
    CHANGING lt_cat.
  PERFORM field USING 'ADDED' '추가 발생일/원천' 16 'X' CHANGING lt_cat.
  PERFORM field USING 'REMOVED' '삭제 발생일/원천' 16 'X' CHANGING lt_cat.
  PERFORM field USING 'CHANGED' '내용 변경' 12 'X' CHANGING lt_cat.
  PERFORM field USING 'USED_COUNT' '사용표시 대휴수' 16 space
    CHANGING lt_cat.
  PERFORM field USING 'SETTLED_REST_COUNT' '정산표시 대휴수' 16 space
    CHANGING lt_cat.
  PERFORM field USING 'DETAIL' '대휴 일자 상세' 16 'X' CHANGING lt_cat.
  PERFORM field USING 'NOTE' '확인 사항' 80 space CHANGING lt_cat.
  ls_layout-zebra = 'X'.
  lv_title = gv_title.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING i_callback_program = sy-repid
      i_callback_user_command = 'USER_COMMAND'
      i_callback_top_of_page = 'TOP_OF_PAGE'
      i_grid_title = lv_title is_layout = ls_layout it_fieldcat = lt_cat
      i_save = space
    TABLES t_outtab = gt_summary
    EXCEPTIONS program_error = 1 OTHERS = 2.
  IF sy-subrc <> 0.
    MESSAGE '비교 목록 표시 중 오류가 발생했습니다.' TYPE 'S'
      DISPLAY LIKE 'E'.
  ENDIF.
ENDFORM.

FORM top_of_page.
  DATA: lt_header TYPE slis_t_listheader,
        ls_header TYPE slis_listheader,
        lv_count TYPE c LENGTH 12.
  ls_header-typ = 'H'.
  ls_header-info = gv_title.
  APPEND ls_header TO lt_header.
  CLEAR ls_header.
  ls_header-typ = 'S'.
  ls_header-info = '금액 클릭: 항목별 비교 / 상세 클릭: 대휴 일자 비교'.
  APPEND ls_header TO lt_header.
  CLEAR ls_header.
  ls_header-typ = 'S'.
  ls_header-info = '조회 전용 / 기간 차액은 다음 달 최종 지급액이 아닙니다.'.
  APPEND ls_header TO lt_header.
  IF gv_denied > 0.
    CLEAR ls_header.
    WRITE gv_denied TO lv_count LEFT-JUSTIFIED.
    ls_header-typ = 'S'.
    CONCATENATE '권한/인사정보 확인 불가로 제외:' lv_count
      INTO ls_header-info SEPARATED BY space.
    APPEND ls_header TO lt_header.
  ENDIF.
  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING it_list_commentary = lt_header.
ENDFORM.

FORM user_command USING pv_ucomm LIKE sy-ucomm
                        ps_selfield TYPE slis_selfield.
  DATA ls_row TYPE ty_summary.
  CHECK pv_ucomm = '&IC1'.
  READ TABLE gt_summary INTO ls_row INDEX ps_selfield-tabindex.
  CHECK sy-subrc = 0.
  IF ps_selfield-fieldname = 'OLD_AMT'
    OR ps_selfield-fieldname = 'NEW_AMT'
    OR ps_selfield-fieldname = 'DIFF_AMT'.
    PERFORM display_items USING ls_row-row_id.
  ELSE.
    PERFORM display_rest USING ls_row-row_id.
  ENDIF.
ENDFORM.

FORM display_rest USING pv_id TYPE i.
  DATA: lt_rows TYPE tt_detail, ls_row TYPE ty_detail,
        lt_cat TYPE slis_t_fieldcat_alv, ls_layout TYPE slis_layout_alv.
  LOOP AT gt_detail INTO ls_row WHERE row_id = pv_id.
    APPEND ls_row TO lt_rows.
  ENDLOOP.
  IF lt_rows IS INITIAL.
    MESSAGE '현재 대휴와 재계산 대휴 상세가 없습니다. 계산 상태를 확인하십시오.'
      TYPE 'S'.
    RETURN.
  ENDIF.
  SORT lt_rows BY daeh_date source_date.
  PERFORM field USING 'SOURCE_DATE' '원천 실적일' 12 space CHANGING lt_cat.
  PERFORM field USING 'DAEH_DATE' '대휴 발생일' 12 space CHANGING lt_cat.
  PERFORM field USING 'STATE' '비교 구분' 18 space CHANGING lt_cat.
  PERFORM field USING 'OLD_COUNT' '현재 개수' 10 space CHANGING lt_cat.
  PERFORM field USING 'NEW_COUNT_TEXT' '재계산 개수' 12 space
    CHANGING lt_cat.
  PERFORM field USING 'OLD_HOURS' '현재 시간' 12 space CHANGING lt_cat.
  PERFORM field USING 'NEW_HOURS' '재계산 시간' 14 space CHANGING lt_cat.
  PERFORM field USING 'OLD_AMT' '현재 저장금액(원)' 22 space CHANGING lt_cat.
  PERFORM field USING 'NEW_AMT' '재계산 저장금액(원)' 22 space CHANGING lt_cat.
  PERFORM field USING 'DELTA_AMT' '차액(원)' 22 space CHANGING lt_cat.
  PERFORM field USING 'USED_COUNT' '사용표시' 10 space CHANGING lt_cat.
  PERFORM field USING 'SETTLED_COUNT' '정산표시' 10 space CHANGING lt_cat.
  PERFORM field USING 'NOTE' '확인 사항' 60 space CHANGING lt_cat.
  ls_layout-zebra = 'X'.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING i_callback_program = sy-repid
      i_grid_title = '대휴 발생일·원천 실적별 전후 비교(현재 원장 기준)'
      is_layout = ls_layout it_fieldcat = lt_cat i_save = space
    TABLES t_outtab = lt_rows
    EXCEPTIONS program_error = 1 OTHERS = 2.
ENDFORM.

FORM display_items USING pv_id TYPE i.
  DATA: lt_rows TYPE STANDARD TABLE OF ty_item,
        ls_row TYPE ty_item, lt_cat TYPE slis_t_fieldcat_alv.
  LOOP AT gt_items INTO ls_row WHERE row_id = pv_id.
    APPEND ls_row TO lt_rows.
  ENDLOOP.
  IF lt_rows IS INITIAL.
    MESSAGE '금액 재계산이 완료되지 않았습니다. 확인 사항을 보십시오.' TYPE 'S'.
    RETURN.
  ENDIF.
  PERFORM field USING 'NAME' '항목' 24 space CHANGING lt_cat.
  PERFORM field USING 'OLD_AMT' '정산 당시(원)' 24 space CHANGING lt_cat.
  PERFORM field USING 'NEW_AMT' '재계산(원)' 24 space CHANGING lt_cat.
  PERFORM field USING 'DELTA_AMT' '차액(원)' 24 space CHANGING lt_cat.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING i_callback_program = sy-repid
      i_grid_title = '기간실비 항목별 비교(기지급 소급분 제외)'
      it_fieldcat = lt_cat i_save = space
    TABLES t_outtab = lt_rows
    EXCEPTIONS program_error = 1 OTHERS = 2.
ENDFORM.

* === GENERATED SNAPSHOT CALCULATION; SEE tools/build_core.py ===
FORM rc_calculate
  TABLES lt_zthr0132 STRUCTURE zthr0132
         it_work STRUCTURE zshr0145
         it_awart STRUCTURE zshr0111
         lt_zthr0113 STRUCTURE zthr0113
         lt_daeh STRUCTURE zshr0146
         lt_save STRUCTURE zshr0145
  USING i_case TYPE c
        is_rate TYPE zshr0143.
* Work and AWART input are read-only snapshots. Calls below are calculation
* helpers; calendar/time configuration still comes from the local SAP system.
  DATA: lt_zshr0111 TYPE TABLE OF zshr0111 WITH HEADER LINE,
        lt_zshr0111_1 TYPE TABLE OF zshr0111 WITH HEADER LINE,
        lt_zthr0112 TYPE TABLE OF zshr0145 WITH HEADER LINE,
        lt_tmp  TYPE TABLE OF zshr0145 WITH HEADER LINE,
        lt_zshr0115 TYPE TABLE OF zshr0115,
        ls_zshr0115 TYPE zshr0115,
        lt_attributes TYPE TABLE OF casdayattr WITH HEADER LINE,
        ls_zshr0141 TYPE zshr0141,
        ls_zshr0143 TYPE zshr0143,
        ls_zshr0137 TYPE zshr0137,
        ls_return TYPE bapireturn1,
        lt_data TYPE TABLE OF zshr0111 WITH HEADER LINE,
        lv_unused TYPE c.
  DATA: lv_pwkhr_min TYPE i,
        lv_hodhr_min TYPE i,
        lv_owkhr_min TYPE i,
        lv_cwkhr_min TYPE i,
        lv_genhr TYPE i,
        lv_genhr_min TYPE i,
        lv_genhr_sum TYPE i,
        lv_genhr_diff TYPE i,
        lv_genhr_until TYPE i,
        lv_genhr_total TYPE i,
        lv_min TYPE i,
        lv_zrlholwk_d_min TYPE i,
        lv_max_sum_min TYPE i,
        lv_max_sum_min2  TYPE i,
        lv_sum  TYPE i,
        lv_sum2 TYPE i,
        lv_min2 TYPE i,
        lv_min3 TYPE i,
        lv_min4 TYPE i,
        lv_min5 TYPE i,
        lv_min6 TYPE i,
        lv_min7 TYPE i,
        lv_min8 TYPE i,
        lv_min9 TYPE i,
        lv_min10 TYPE i,
        lv_min11 TYPE i,
        lv_min12 TYPE i,
        lv_min13 TYPE i,
        lv_tabix TYPE i,
        lv_tabix2 TYPE i,
        lv_zrlwk_t_min TYPE i,
        lv_zprsdwk_t_min TYPE i,
        lv_awkhr_t_min TYPE i,
        lv_ewkhr_t_min TYPE i,
        lv_pwkhr_sum TYPE i,
        lv_pwkhr_net TYPE i,
        lv_hkhr_min TYPE i,
        lv_hkhr_sum TYPE i,
        lv_day TYPE dats,
        lv_awkhr_t_min2 TYPE i,
        lv_ewkhr_t_min2 TYPE i,
        lv_sign TYPE i,
        lv_diff TYPE i,
        lv_diff_min TYPE i,
        lv_tdcost_t_min TYPE i,
        lv_wkhr_s_min TYPE i,
        lv_hkhr_s_min TYPE i,
        lv_wkhr_s_min_t TYPE i,
        lv_hkhr_s_min_t TYPE i,
        lv_rwkhr_s_min TYPE i,
        lv_remain_min TYPE i,
        lv_remain_stdaz TYPE stdaz,
        lv_min_t TYPE i,
        lv_stdaz_t TYPE stdaz,
        lv_zdaeh_t_day TYPE i,
        lv_zdaeh_t_min TYPE i,
        lv_zrlholwk_t_min TYPE i,
        lv_zrlholwk_t_min_50 TYPE i,
        lv_zrlholwk_t_min_150 TYPE i,
        lv_zrlholwk_t_min_150_x TYPE i,
        lv_zrlngtwk_t_min TYPE i,
        lv_zrlwk_t_extra TYPE i,
        lv_zrlwk_extra TYPE i,
        lv_max_extra1 TYPE i,
        lv_max_extra2 TYPE i,
        lv_exceed1 TYPE i,
        lv_exceed2 TYPE i,
        lv_first TYPE i,
        lv_first1 TYPE i,
        lv_first2 TYPE i,
        lv_pwkhr_last TYPE i,
        lv_zovradd_t_min TYPE i,
        lv_zrlholwk_min TYPE i,
        lv_tdcost_sum TYPE zetdcost,
        lv_zrlwkhrtot_sum TYPE i,
        lv_zrlexwkhr_min TYPE i,
        lv_zrlovrwkhr_sum TYPE i,
        lv_time TYPE tims,
        lv_zprsdwk_min TYPE i,
        lv_zprsdwk_t_extra TYPE i,
        lv_next_dif TYPE i,
        lv_exh_datum1 TYPE dats.
  DATA : l_daynr  LIKE  hrvsched-daynr,
             lv_holiday.
  DATA: lv_datum TYPE sy-datum,
            lv_next_holiday, lv_next_day.
  DATA : time1 TYPE zchar06,
             time2 TYPE zchar06,
             time_dif TYPE zchar06.
  CLEAR: lt_zthr0113[], lt_daeh[], lt_save[].
  LOOP AT lt_zthr0132.
    CLEAR: lv_wkhr_s_min, lv_pwkhr_min, lv_hodhr_min, lv_owkhr_min, lv_cwkhr_min, lv_exceed1, lv_exceed2, lv_max_sum_min, lv_max_sum_min2,  lv_sum, lv_sum2,
           lv_min, lv_min2, lv_min3, lv_min4, lv_min5, lv_min6, lv_min7,  lv_min8,  lv_min9,  lv_min10,  lv_min11, lv_min12, lv_min13, lv_first,  lv_first1, lv_first2, lv_max_extra1, lv_max_extra2,
           lv_zprsdwk_t_min, lv_awkhr_t_min, lv_ewkhr_t_min, lv_next_dif,
           lv_pwkhr_sum, lv_day, lv_hkhr_s_min,  lv_awkhr_t_min2, lv_ewkhr_t_min2, lv_hkhr_min, lv_hkhr_sum,
           lv_sign, lv_diff_min, lv_tdcost_t_min,
           lv_rwkhr_s_min, lv_remain_min, lv_remain_stdaz,
           lv_zdaeh_t_day, lv_zdaeh_t_min,
           lv_zrlholwk_t_min_50, lv_zrlholwk_t_min_150, lv_zrlholwk_t_min_150_x,
           lv_zrlngtwk_t_min, lv_zrlwk_t_min, lv_zrlwk_t_extra,
           lv_pwkhr_last, lv_zovradd_t_min, lv_tdcost_sum,
           lv_zrlwkhrtot_sum, lv_zrlexwkhr_min, lv_zrlovrwkhr_sum, lv_genhr_sum, lv_genhr_until, lv_genhr_total,
           lv_time, lv_zprsdwk_min, lv_zprsdwk_t_extra, lv_exh_datum1, lv_datum, lv_next_holiday, lv_next_day.
    PERFORM convert_hour_to_min USING lt_zthr0132-pwkhr
                                CHANGING lv_pwkhr_min.
    PERFORM convert_hour_to_min USING lt_zthr0132-hodhr
                                CHANGING lv_hodhr_min.
    lt_zshr0111[] = it_awart[].
    LOOP AT lt_zshr0111 WHERE zstat = 'A' AND zabsdayty = 'A'.
      IF lt_zshr0111-zprsdwk_tm IS NOT INITIAL.
        PERFORM convert_time_to_min USING lt_zshr0111-zprsdwk_tm
                                    CHANGING lv_min.
        ADD lv_min TO lv_zprsdwk_t_min.
      ENDIF.
    ENDLOOP.
    LOOP AT lt_zshr0111 WHERE awart = '9997'
                          AND zstat = 'A'
                          AND zabsdayty = 'P'.
      lv_min = 480.
      IF lv_min > 480.
        lv_min = 480.
      ENDIF.
      ADD lv_min TO lv_awkhr_t_min.
    ENDLOOP.
    LOOP AT lt_zshr0111 WHERE awart = '9998'
                           AND zstat = 'A'
                           AND zabsdayty = 'P'.
      IF lt_zshr0111-zprsdwk_tm IS NOT INITIAL.
        PERFORM convert_time_to_min USING lt_zshr0111-zprsdwk_tm
                                    CHANGING lv_min.
        IF lv_min > 480.
          lv_min = 480.
        ENDIF.
        ADD lv_min TO lv_ewkhr_t_min.
      ENDIF.
    ENDLOOP.
    lv_pwkhr_sum = lv_pwkhr_min -
                   lv_hodhr_min -
                   lv_zprsdwk_t_min.
    lv_pwkhr_last = lv_pwkhr_sum.
    lt_zthr0112[] = it_work[].
    SORT lt_zthr0112 BY datum seqnr.
    lv_day = lt_zthr0132-begda.
      CLEAR: lt_zshr0111[].
      lt_zshr0111[] = it_awart[].
      WHILE ( lv_day <= lt_zthr0132-endda ).
        CLEAR: lt_zshr0111.
        READ TABLE lt_zshr0111 WITH KEY datum = lv_day
                                        awart = '9997'
                                        zstat = 'A'
                                        zabsdayty = 'P'.
        IF sy-subrc = 0.
          CLEAR: l_daynr, lv_holiday.
          CALL FUNCTION 'ZHR_GET_DAY_DATA'
            EXPORTING
              znal    = lv_day
            IMPORTING
              daynr   = l_daynr
              holiday = lv_holiday.
          IF l_daynr <> '6' AND l_daynr <> '7'.
            IF lv_holiday = 'X'.
                lv_min = 0.
            ELSE.
              lv_min = 480.
              IF lv_min > 480.
                lv_min = 480.
              ENDIF.
            ENDIF.
            ADD lv_min TO lv_awkhr_t_min2.
          ENDIF.
        ENDIF.
        READ TABLE lt_zshr0111 WITH KEY datum = lv_day
                                        awart = '9998'
                                        zstat = 'A'
                                        zabsdayty = 'P'.
        IF sy-subrc = 0 AND lt_zshr0111-zprsdwk_tm IS NOT INITIAL.
          PERFORM convert_time_to_min USING lt_zshr0111-zprsdwk_tm
                                      CHANGING lv_min.
          IF lv_min > 480.
            lv_min = 480.
          ENDIF.
          ADD lv_min TO lv_ewkhr_t_min2.
        ENDIF.
        lv_sign = SIGN( lv_pwkhr_sum - ( lv_rwkhr_s_min + lv_awkhr_t_min2 + lv_ewkhr_t_min2 ) ).
        CLEAR: l_daynr, lv_holiday.
        CALL FUNCTION 'ZHR_GET_DAY_DATA'
          EXPORTING
            znal    = lv_day
          IMPORTING
            daynr   = l_daynr
            holiday = lv_holiday.
        IF lt_zshr0111[] IS NOT INITIAL AND lt_zshr0111-awart <> '9999' AND lt_zshr0111-datum EQ lv_day
            AND lt_zshr0111-zprsdwk_tm IS NOT INITIAL.
          l_daynr = '7'.
          lv_holiday = 'X'.
        ENDIF.
        IF lv_sign > 0.
          lv_diff_min = lv_pwkhr_sum - lv_wkhr_s_min.
          READ TABLE lt_zthr0112 WITH KEY datum = lv_day.
          IF sy-subrc = 0.
            LOOP AT lt_zthr0112 WHERE datum = lv_day.
              PERFORM convert_time_to_min USING lt_zthr0112-zrlwk_tm
                                          CHANGING lv_min.
              IF lv_diff_min >= lv_min.
                IF lt_zthr0112-tdcost IS NOT INITIAL.
                  IF lv_min < 480.
                    lv_tdcost_t_min = lv_tdcost_t_min + ( 480 - lv_min ).
                    lv_min = 480.
                  ENDIF.
                ENDIF.
              ENDIF.
              IF lt_zthr0112-zovradd_tm IS NOT INITIAL.
                PERFORM convert_time_to_min USING lt_zthr0112-zovradd_tm
                                            CHANGING lv_min11.
                PERFORM convert_time_to_min USING lt_zthr0112-zrlwk_tm
                                            CHANGING lt_zthr0112-rwkhr_d_min.
                ADD lv_min11 TO lt_zthr0112-rwkhr_d_min.
              ENDIF.
              IF l_daynr <> '6' AND l_daynr <> '7' AND lv_holiday <> 'X'.
                IF lt_zthr0112-ztomo = 'X' AND lt_zthr0112-zrlholwk_tm IS NOT INITIAL.
                  PERFORM convert_time_to_min USING lt_zthr0112-zrlholwk_tm
                                              CHANGING lv_zrlholwk_d_min.
                    lv_min = lv_min - lv_zrlholwk_d_min.
                  ADD lv_min TO lv_wkhr_s_min.
                  ADD lv_zrlholwk_d_min TO lv_hkhr_s_min.
                ELSE.
                  IF lt_zthr0112-zovradd_tm IS NOT INITIAL.
                    ADD lt_zthr0112-rwkhr_d_min TO lv_wkhr_s_min.
                  ELSE.
                    ADD lv_min TO lv_wkhr_s_min.
                  ENDIF.
                ENDIF.
              ELSE.
                IF  lt_zthr0112-ztomo = 'X' .
                 time1 = lt_zthr0112-zrlwk_tm.
                 time2 = lt_zthr0112-zrlholwk_tm.
                 CALL FUNCTION 'ZHR_MINUS_TIME_N'
                  EXPORTING
                   TIME1    = time1
                   TIME2    = time2
                 IMPORTING
                   TIME_DIF = time_dif.
                 PERFORM convert_time_to_min USING time_dif
                                           CHANGING lv_min.
                 ADD lv_min TO lv_wkhr_s_min.
                PERFORM convert_time_to_min USING  lt_zthr0112-zrlholwk_tm
                                       CHANGING lv_min.
                ADD lv_min TO lv_hkhr_s_min.
               ELSEIF  lt_zshr0111[] IS NOT INITIAL.
                CLEAR lt_data[].
                LOOP AT it_awart WHERE datum = lt_zthr0112-datum.
                  APPEND it_awart TO lt_data.
                ENDLOOP.
                LOOP AT lt_data WHERE atext = '연차' OR atext = '반차' OR atext = '일반' OR  atext = '청원' OR  atext = '공가'.
                 PERFORM convert_time_to_min USING  lt_zthr0112-zrlwk_tm
                                       CHANGING lv_min.
                 ADD lv_min TO lv_wkhr_s_min.
                ENDLOOP.
                IF lt_zthr0112-zovradd_tm IS NOT INITIAL.
                  ADD lt_zthr0112-rwkhr_d_min TO lv_hkhr_s_min.
                ELSE.
                  ADD lv_min TO lv_hkhr_s_min.
                ENDIF.
               ENDIF.
              ENDIF.
              ADD lt_zthr0112-rwkhr_d_min TO lv_rwkhr_s_min.
              lt_zthr0112-rwkhr_s_min = lv_wkhr_s_min + lv_hkhr_s_min
                                                        + lv_awkhr_t_min2 + lv_ewkhr_t_min2.
              MODIFY lt_zthr0112 TRANSPORTING rwkhr_s_min rwkhr_d_min.
            ENDLOOP.
          ELSE.
          ENDIF.
        ELSE.
          IF lv_exh_datum1 IS INITIAL.
            lv_exh_datum1 = lv_day.
          ENDIF.
          READ TABLE lt_zthr0112 WITH KEY datum = lv_day.
          IF sy-subrc = 0.
            LOOP AT lt_zthr0112 WHERE datum = lv_day.
              CLEAR: l_daynr, lv_holiday.
              CALL FUNCTION 'ZHR_GET_DAY_DATA'
                EXPORTING
                  znal    = lv_day
                IMPORTING
                  daynr   = l_daynr
                  holiday = lv_holiday.
              PERFORM convert_time_to_min USING lt_zthr0112-zrlwk_tm
                                          CHANGING lv_min.
              IF lt_zthr0112-zovradd_tm IS NOT INITIAL.
                PERFORM convert_time_to_min USING lt_zthr0112-zovradd_tm
                                            CHANGING lv_min.
                PERFORM convert_time_to_min USING lt_zthr0112-zrlwk_tm
                                            CHANGING lt_zthr0112-rwkhr_d_min.
                ADD lv_min TO lt_zthr0112-rwkhr_d_min.
              ENDIF.
              IF lt_zthr0112-ztomo = 'X' AND lt_zthr0112-zrlholwk_tm IS NOT INITIAL.
                PERFORM convert_time_to_min USING lt_zthr0112-zrlholwk_tm
                                            CHANGING lv_zrlholwk_d_min.
                lv_min = lv_min - lv_zrlholwk_d_min.
                ADD lv_min TO lv_wkhr_s_min.
                ADD lv_zrlholwk_d_min TO lv_hkhr_s_min.
              ELSE.
                IF l_daynr <> '6' AND l_daynr <> '7' AND lv_holiday <> 'X'.
                  ADD lv_min TO lv_wkhr_s_min.
                ELSE.
                  ADD lv_min TO lv_hkhr_s_min.
                ENDIF.
              ENDIF.
              ADD lt_zthr0112-rwkhr_d_min TO lv_rwkhr_s_min.
              lt_zthr0112-rwkhr_s_min = lv_wkhr_s_min + lv_hkhr_s_min
                                                       + lv_awkhr_t_min2 + lv_ewkhr_t_min2.
              MODIFY lt_zthr0112 TRANSPORTING rwkhr_s_min rwkhr_d_min.
            ENDLOOP.
          ELSE.
          ENDIF.
        ENDIF.
        lv_day = lv_day + 1.
      ENDWHILE.
      CLEAR: lv_max_sum_min, lv_sum, lv_min12.
         lv_wkhr_s_min =  lv_wkhr_s_min + lv_awkhr_t_min2.
        lv_max_sum_min = lv_wkhr_s_min + lv_hkhr_s_min.
            IF lv_max_sum_min > '12480'.
               lv_sum =  lv_max_sum_min.
             LOOP AT  lt_zshr0111.
              CLEAR: l_daynr, lv_holiday.
              CALL FUNCTION 'ZHR_GET_DAY_DATA'
               EXPORTING
                 znal    =  lt_zshr0111-datum
               IMPORTING
                daynr   = l_daynr
                holiday = lv_holiday.
              IF lt_zshr0111-awart = '9997' AND lt_zshr0111-zabsdayty = 'P' AND  l_daynr <> '6' AND l_daynr <> '7' AND lv_holiday <> 'X'.
                   lv_sum =  lv_sum - '480' .
                  IF lv_sum <= '12480'.
                     lv_wkhr_s_min = '12480' -  lv_hkhr_s_min.
                    EXIT.
                  ELSE.
                     lv_wkhr_s_min = lv_sum -  lv_hkhr_s_min.
                  ENDIF.
              ENDIF.
             ENDLOOP.
            ENDIF.
    CASE i_case.
      WHEN 'B'.
          LOOP AT lt_zthr0112.
            IF lt_zthr0112-zdaeh = 'X'.
              ADD lt_zthr0112-zdaeh_day TO lv_zdaeh_t_day.
              PERFORM convert_time_to_min USING lt_zthr0112-zdaeh_tm
                                          CHANGING lv_min.
              ADD lv_min TO lv_zdaeh_t_min.
            ENDIF.
            MOVE-CORRESPONDING lt_zthr0112 TO ls_zshr0115.
            CALL FUNCTION 'ZHR_52TM_CALC_WORK_TIME_DAYILY'
              EXPORTING
                is_day     = ls_zshr0115
              TABLES
                t_day_time = lt_zshr0115.
            LOOP AT lt_zshr0115 INTO ls_zshr0115.
              CLEAR lv_tabix2.
              lv_tabix2 = sy-tabix.
              CALL FUNCTION 'DAY_ATTRIBUTES_GET'
                EXPORTING
                  factory_calendar           = 'KR'
                  holiday_calendar           = 'KB'
                  date_from                  = ls_zshr0115-datum
                  date_to                    = ls_zshr0115-datum
                  language                   = sy-langu
                TABLES
                  day_attributes             = lt_attributes
                EXCEPTIONS
                  factory_calendar_not_found = 1
                  holiday_calendar_not_found = 2
                  date_has_invalid_format    = 3
                  date_inconsistency         = 4
                  OTHERS                     = 5.
              READ TABLE lt_attributes INDEX 1.
              IF lt_zthr0112-zdaeh = 'X'.
                IF ( lt_attributes-weekday = '5' OR  lt_attributes-weekday = '6' OR lt_attributes-weekday = '7' ) OR lt_attributes-holiday = 'X'.
                  CLEAR: lv_zrlholwk_min, lv_datum, lv_next_holiday.
                  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
                    EXPORTING
                      DATE            =  ls_zshr0115-datum
                      DAYS            = '01'
                      MONTHS          = '00'
                     SIGNUM          = '+'
                      YEARS           = '00'
                   IMPORTING
                     CALC_DATE       = lv_datum.
                 CALL FUNCTION 'ZHR_GET_DAY_DATA'
                  EXPORTING
                    znal    = lv_datum
                  IMPORTING
                    holiday = lv_next_holiday.
                  IF lt_zthr0112-ztomo = 'X' AND lv_next_holiday = 'X' AND ( lt_zthr0112-datum EQ ls_zshr0115-datum ).
                        PERFORM convert_time_to_min USING lt_zthr0112-zrlholwk_tm
                                              CHANGING lv_min2.
                  ELSEIF  lt_zthr0112-ztomo = 'X' AND lv_next_holiday = 'X' AND ( lt_zthr0112-datum NE ls_zshr0115-datum ) AND lv_tabix2 >= 2.
                        lv_min2 = 0.
                  ELSEIF  lt_zthr0112-ztomo = 'X' AND lv_next_holiday = '' AND ( lt_zthr0112-datum NE ls_zshr0115-datum ).
                        lv_min2 = 0.
                  ELSE.
                       PERFORM convert_time_to_min USING ls_zshr0115-zrlwk_tm
                                              CHANGING lv_min2.
                  ENDIF.
                  lv_sign = SIGN( lv_min2 - lv_min ).
                  IF lv_sign = 1.
                    CLEAR lv_min13.
                    lv_min13 = lv_min2 - lv_min.
                    ADD lv_min13 TO lv_zrlholwk_t_min_50.
                  ENDIF.
                ENDIF.
              ELSE.
                PERFORM convert_time_to_min USING ls_zshr0115-zrlwk_tm
                                            CHANGING lv_min.
                IF ( lt_attributes-weekday = '6' OR lt_attributes-weekday = '7' ) OR lt_attributes-holiday = 'X'.
                  ADD lv_min TO lv_zrlholwk_t_min_50.
                ENDIF.
              ENDIF.
            ENDLOOP.
            PERFORM convert_time_to_min USING lt_zthr0112-zrlngtwk_tm
                                        CHANGING lv_min.
            ADD lv_min TO lv_zrlngtwk_t_min.
            PERFORM convert_time_to_min USING lt_zthr0112-zrlwk_tm
                                        CHANGING lv_min.
            ADD lv_min TO lv_zrlwk_t_min.
           CLEAR: lv_genhr, lv_diff, time1, time2, time_dif.
            time1 = lt_zthr0112-zrlwk_tm.
            time2 = lt_zthr0112-zrlholwk_tm.
           CALL FUNCTION 'ZHR_MINUS_TIME_N'
            EXPORTING
             TIME1    = time1
             TIME2    = time2
            IMPORTING
             TIME_DIF = time_dif.
             PERFORM convert_time_to_min USING time_dif
                             CHANGING  lv_genhr.
             lv_genhr_sum = lv_genhr_sum + lv_genhr.
            CLEAR lv_genhr_diff.
            lv_genhr_diff = lv_genhr_sum - lv_genhr.
            IF lv_pwkhr_sum > lv_genhr_diff.
             IF lt_zthr0112-zovradd_tm IS NOT INITIAL.
              PERFORM convert_time_to_min USING lt_zthr0112-zovradd_tm
                                          CHANGING lv_min.
               ADD lv_min TO lv_zovradd_t_min.
               lv_genhr_sum = lv_genhr_sum + lv_min.
             ENDIF.
            ENDIF.
            ADD lt_zthr0112-tdcost TO lv_tdcost_sum.
          ENDLOOP.
          lt_zthr0113-zadmit_ym = lt_zthr0132-endda(6).
          lt_zthr0113-pernr = lt_zthr0132-pernr.
          lt_zthr0113-begda = lt_zthr0132-begda.
          lt_zthr0113-endda = lt_zthr0132-endda.
          lt_zthr0113-z52wktp = lt_zthr0132-z52wktp.
          lt_zthr0113-z52prsq = lt_zthr0132-z52prsq.
          ls_zshr0141-datum = lt_zthr0132-begda.
          ls_zshr0143 = is_rate.
          lt_zthr0113-zdung = ls_zshr0143-zdung.
          lt_zthr0113-zcost = ls_zshr0143-zcost.
          PERFORM convert_min_to_hour USING lv_pwkhr_last
                                      CHANGING lt_zthr0113-pwkhr.
          PERFORM convert_min_to_hour USING lv_zrlwk_t_min
                                      CHANGING lt_zthr0113-zrlwkhr.
          PERFORM convert_min_to_hour USING lv_hodhr_min
                                      CHANGING lt_zthr0113-zpubhhr.
          PERFORM convert_min_to_hour USING lv_zprsdwk_t_min
                                      CHANGING lt_zthr0113-zprsdwkhr.
          PERFORM convert_min_to_hour USING lv_awkhr_t_min2
                                      CHANGING lt_zthr0113-zadtwkhr.
          PERFORM convert_min_to_hour USING lv_ewkhr_t_min2
                                      CHANGING lt_zthr0113-zedtwkhr.
          PERFORM convert_min_to_hour USING lv_zovradd_t_min
                                      CHANGING lt_zthr0113-zrladdwkhr.
          PERFORM convert_min_to_hour USING lv_wkhr_s_min
                                      CHANGING lt_zthr0113-zwkhrtot.
          PERFORM convert_min_to_hour USING lv_hkhr_s_min
                                      CHANGING lt_zthr0113-zhkhrtot.
          lv_zrlwkhrtot_sum = lv_zrlwk_t_min +
                              lv_tdcost_t_min +
                              lv_zovradd_t_min +
                              lv_zprsdwk_t_min +
                              lv_awkhr_t_min2 +
                              lv_ewkhr_t_min2.
            CLEAR: lv_max_sum_min2.
             lv_max_sum_min2 = lv_zrlwk_t_min + lv_awkhr_t_min2.
             IF lv_max_sum_min2 <= '12480'.
                lv_zrlwkhrtot_sum =  lv_zrlwkhrtot_sum.
             ELSE.
               READ TABLE lt_zthr0112 WITH KEY zemcwk = 'X'.
               IF sy-subrc = 0.
                 lv_zrlwkhrtot_sum =  lv_zrlwkhrtot_sum.
               ELSE.
                  lv_zrlwkhrtot_sum = '12480'.
               ENDIF.
             ENDIF.
          PERFORM convert_min_to_hour USING lv_zrlwkhrtot_sum
                                      CHANGING lt_zthr0113-zrlwkhrtot.
          lv_sign = SIGN( lv_zrlwkhrtot_sum -
                          lv_pwkhr_sum -
                          lv_zprsdwk_t_min -
                          lv_ewkhr_t_min2 ).
          IF lv_sign = 1.
            lv_zrlexwkhr_min = lv_zrlwkhrtot_sum -
                               lv_pwkhr_sum -
                               lv_zprsdwk_t_min -
                               lv_ewkhr_t_min2.
          ELSE.
            lv_zrlexwkhr_min = 0.
          ENDIF.
          PERFORM convert_min_to_hour USING lv_zrlexwkhr_min
                                      CHANGING lt_zthr0113-zrlexwkhr.
          lv_sign = SIGN( lv_zrlexwkhr_min -
                            lv_zdaeh_t_min ).
          IF lv_sign = 1.
            lv_zrlovrwkhr_sum = lv_zrlexwkhr_min -
                                  lv_zdaeh_t_min .
          ELSE.
            lv_zrlovrwkhr_sum = 0.
          ENDIF.
          PERFORM convert_min_to_hour USING lv_zrlovrwkhr_sum
                                      CHANGING lt_zthr0113-zrlovrwkhr.
          PERFORM convert_min_to_hour USING lv_zrlngtwk_t_min
                                      CHANGING lt_zthr0113-zrlngtwkhr.
          lv_zrlholwk_t_min = lv_zrlholwk_t_min_150_x + lv_zrlholwk_t_min_50.
          PERFORM convert_min_to_hour USING lv_zrlholwk_t_min
                                      CHANGING lt_zthr0113-zrlholwkhr.
          lt_zthr0113-zdaeh_day = lv_zdaeh_t_day.
          PERFORM convert_min_to_hour USING lv_zdaeh_t_min
                                      CHANGING lt_zthr0113-zdaehhr.
          lt_zthr0113-zrlovramt = ( lv_zrlovrwkhr_sum / 60 ) * lt_zthr0113-zcost.
          lt_zthr0113-zrlngtamt = ( lv_zrlngtwk_t_min / 60 ) * ( lt_zthr0113-zcost * '0.5' ).
          lt_zthr0113-zrlholamt = ( lv_zrlholwk_t_min_150_x / 60 ) * ( lt_zthr0113-zcost * '1.5' ) +
                                  ( lv_zrlholwk_t_min_50 / 60 ) * ( lt_zthr0113-zcost * '0.5' ).
          lt_zthr0113-zdaehamt = ( lv_zdaeh_t_min / 60 ) * ( lt_zthr0113-zcost * '0.5' ).
          lt_zthr0113-tdcost = lv_tdcost_sum.
          lt_zthr0113-zrlprdamt = lt_zthr0113-zrlovramt +
                                  lt_zthr0113-zrlngtamt +
                                  lt_zthr0113-zrlholamt +
                                  lt_zthr0113-zdaehamt +
                                  lt_zthr0113-tdcost.
          lt_zthr0113-waers = 'KRW'.
          APPEND lt_zthr0113.
          CLEAR lt_zthr0113.
      WHEN 'C'.
          CLEAR: lv_wkhr_s_min_t, lv_hkhr_s_min_t.
          LOOP AT lt_zthr0112 WHERE zdaeh <> 'X'.
            lv_remain_min = lv_wkhr_s_min + lv_hkhr_s_min.
            CLEAR: l_daynr, lv_holiday.
            CALL FUNCTION 'ZHR_GET_DAY_DATA'
              EXPORTING
                znal    = lt_zthr0112-datum
              IMPORTING
                daynr   = l_daynr
                holiday = lv_holiday.
            PERFORM convert_time_to_min USING lt_zthr0112-zrlwk_tm
                                            CHANGING lv_min.
            PERFORM convert_time_to_min USING lt_zthr0112-ZRLHOLWK_TM
                                CHANGING lv_min8.
            IF lt_zthr0112-zovradd_tm IS NOT INITIAL.
              PERFORM convert_time_to_min USING lt_zthr0112-zovradd_tm
                                          CHANGING lv_min2.
              lv_min = lv_min + lv_min2.
            ENDIF.
            IF l_daynr <> '6' AND l_daynr <> '7' AND lv_holiday <> 'X'.
              ADD lv_min TO lv_wkhr_s_min_t.
              IF lt_zthr0112-ztomo = 'X'.
                ADD lv_min8 TO lv_hkhr_s_min_t.
              ENDIF.
            ELSE.
              ADD lv_min TO lv_hkhr_s_min_t.
            ENDIF.
            IF lv_wkhr_s_min >= lv_pwkhr_sum.
              PERFORM make_daeh_data TABLES lt_daeh
                                            lt_zthr0112
                                            lt_save
                                     USING lt_zthr0112 'Y' '0'.
            ELSEIF lv_remain_min > lv_pwkhr_sum.
            PERFORM convert_time_to_min USING lt_zthr0112-zrlholwk_tm
                                CHANGING lv_hkhr_min.
               lv_hkhr_sum =   lv_hkhr_sum  +   lv_hkhr_min.
               lv_diff_min = lv_wkhr_s_min + lv_hkhr_sum -  lv_pwkhr_sum.
              IF lv_diff_min > 0.
                PERFORM convert_time_to_min USING lt_zthr0112-zrlwk_tm
                                                CHANGING lt_zthr0112-rwkhr_d_min.
                 IF lv_first IS INITIAL.
                   lv_diff_min = lt_zthr0112-rwkhr_d_min - lv_diff_min.
                 ELSE.
                   lv_diff_min = lt_zthr0112-rwkhr_d_min - lv_hkhr_min.
                 ENDIF.
                   lv_remain_stdaz = ( lv_diff_min DIV 60 ) + ( lv_diff_min MOD 60 ) / 60.
                   PERFORM make_daeh_data TABLES lt_daeh
                                         lt_zthr0112
                                         lt_save
                                  USING lt_zthr0112 'Y' lv_remain_stdaz.
                   lv_first = 1.
              ENDIF.
            ELSE.
            ENDIF.
          ENDLOOP.
    ENDCASE.
  ENDLOOP.
ENDFORM.

FORM make_daeh_data TABLES pt_daeh STRUCTURE zshr0146
                            lt_zthr0112_chk STRUCTURE zshr0145
                           pt_save STRUCTURE zshr0145
                     USING  ps_zthr0112 TYPE zshr0145
                            pv_exh
                            pv_remain_stdaz.
  DATA: lt_zshr0115 TYPE TABLE OF zshr0115,
        ls_zshr0115 TYPE zshr0115,
        ls_zshr0145 type zshr0145,
        lt_data TYPE ztshr0115 WITH HEADER LINE,
        lt_attributes TYPE TABLE OF casdayattr WITH HEADER LINE,
        lt_attributes2 TYPE TABLE OF casdayattr WITH HEADER LINE,
        lv_sign TYPE i,
        lv_chk,
        lv_zdaeh_t_min TYPE i,
        lv_min TYPE i,
        lv_zrlwk_t_min TYPE i,
        stdaz_s LIKE lt_data-stdaz,
        stdaz_e LIKE lt_data-stdaz,
        temp TYPE i,
        count TYPE i,
        lv_zrlwk_tm TYPE zshr0115-zrlwk_tm,
        pv_remain_tm TYPE zshr0115-zrlwk_tm,
        check_date TYPE datum,
        double_chk(1) TYPE c,
        chk_hol1(1) TYPE c,
        chk_hol2(2) TYPE c.
  MOVE-CORRESPONDING ps_zthr0112 TO ls_zshr0115.
  CALL FUNCTION 'ZHR_52TM_CALC_WORK_TIME_DAYILY'
    EXPORTING
      is_day     = ls_zshr0115
    TABLES
      t_day_time = lt_zshr0115.
  SORT  lt_zshr0115 DESCENDING BY days.
  IF pv_remain_stdaz > 0.
    LOOP AT lt_zshr0115 INTO ls_zshr0115.
      lv_sign = SIGN( ls_zshr0115-stdaz - pv_remain_stdaz ).
      IF lv_sign < 1.
        pv_remain_stdaz = ABS( ls_zshr0115-stdaz - pv_remain_stdaz ).
        ls_zshr0115-stdaz = 0.
      ELSE.
        ls_zshr0115-stdaz = ls_zshr0115-stdaz - pv_remain_stdaz.
        pv_remain_stdaz = 0.
      ENDIF.
      MODIFY lt_zshr0115 FROM ls_zshr0115.
    ENDLOOP.
  ENDIF.
   SORT  lt_zshr0115 ASCENDING BY days.
  LOOP AT lt_zshr0115 INTO ls_zshr0115.
    IF pv_exh = 'N'.
      CALL FUNCTION 'DAY_ATTRIBUTES_GET'
        EXPORTING
          factory_calendar           = 'KR'
          holiday_calendar           = 'KB'
          date_from                  = ls_zshr0115-datum
          date_to                    = ls_zshr0115-datum
          language                   = sy-langu
        TABLES
          day_attributes             = lt_attributes
        EXCEPTIONS
          factory_calendar_not_found = 1
          holiday_calendar_not_found = 2
          date_has_invalid_format    = 3
          date_inconsistency         = 4
          OTHERS                     = 5.
      READ TABLE lt_attributes INDEX 1.
      IF lt_attributes-weekday = '6' OR lt_attributes-weekday = '7'.
        lv_chk = 'X'. EXIT.
      ENDIF.
    ENDIF.
    IF ls_zshr0115-days <> '0'.
      lv_chk = 'X'. EXIT.
    ENDIF.
    IF ls_zshr0115-stdaz >= '4.5'.
      lv_chk = 'X'. EXIT.
    ENDIF.
    PERFORM convert_time_to_min USING ls_zshr0115-zrlwk_tm
                                CHANGING lv_min.
    ADD lv_min TO lv_zrlwk_t_min.
  ENDLOOP.
  IF lv_chk IS INITIAL.
    PERFORM convert_min_to_time USING lv_zrlwk_t_min
                                CHANGING lv_zrlwk_tm.
    LOOP AT lt_zshr0115 INTO ls_zshr0115.
      lt_data-datum = ps_zthr0112-datum.
      lt_data-zrlwk_tm = lv_zrlwk_tm.
      lt_data-stdaz = ls_zshr0115-stdaz.
      lt_data-days = ls_zshr0115-days.
      COLLECT lt_data. CLEAR lt_data.
    ENDLOOP.
  ELSE.
    lt_data[] = lt_zshr0115[].
  ENDIF.
  LOOP AT lt_data WHERE days = '0' AND stdaz >= '4.5' .
    CALL FUNCTION 'DAY_ATTRIBUTES_GET'
      EXPORTING
        factory_calendar           = 'KR'
        holiday_calendar           = 'KB'
        date_from                  = lt_data-datum
        date_to                    = lt_data-datum
        language                   = sy-langu
      TABLES
        day_attributes             = lt_attributes
      EXCEPTIONS
        factory_calendar_not_found = 1
        holiday_calendar_not_found = 2
        date_has_invalid_format    = 3
        date_inconsistency         = 4
        OTHERS                     = 5.
    READ TABLE lt_attributes INDEX 1.
    IF pv_exh = 'N'.
      IF lt_attributes-holiday = 'X' AND NOT ( lt_attributes-weekday = '6' OR lt_attributes-weekday = '7' ).
        chk_hol1 = 1.
      ENDIF.
      CHECK lt_attributes-holiday = 'X' AND NOT ( lt_attributes-weekday = '6' OR lt_attributes-weekday = '7' ).
    ELSE.
      chk_hol1 = 2.
      CHECK lt_attributes-freeday = 'X'.
    ENDIF.
    IF lt_data-stdaz IS NOT INITIAL AND lv_chk = 'X'.
      count = lines( lt_data ).
      stdaz_s = lt_data-stdaz.
      LOOP AT lt_data WHERE stdaz < '4.5' .
        CALL FUNCTION 'DAY_ATTRIBUTES_GET'
          EXPORTING
            factory_calendar           = 'KR'
            holiday_calendar           = 'KB'
            date_from                  = lt_data-datum
            date_to                    = lt_data-datum
            language                   = sy-langu
          TABLES
            day_attributes             = lt_attributes2
          EXCEPTIONS
            factory_calendar_not_found = 1
            holiday_calendar_not_found = 2
            date_has_invalid_format    = 3
            date_inconsistency         = 4
            OTHERS                     = 5.
        READ TABLE lt_attributes2 INDEX 1.
        IF  lt_attributes2-holiday = 'X' AND NOT ( lt_attributes2-weekday = '6' OR lt_attributes2-weekday = '7' ).
          chk_hol2 = 1.
        ELSEIF  lt_attributes2-holiday IS INITIAL AND ( lt_attributes2-weekday = '6' OR lt_attributes2-weekday = '7' ).
          chk_hol2 = 2.
        ELSEIF   lt_attributes2-holiday IS INITIAL AND NOT ( lt_attributes2-weekday = '6' OR lt_attributes2-weekday = '7' ).
          chk_hol2 = 3.
        ENDIF.
IF ( chk_hol1 = 1 OR  chk_hol1 = 2 ) AND ( chk_hol2 = 1 OR  chk_hol2 = 2 ) .
        IF ( sy-tabix = 1 AND lt_data-days = '1' OR
            sy-tabix = 2 AND lt_data-days = '1' ) .
          stdaz_e = lt_data-stdaz.
        ENDIF.
ENDIF.
      ENDLOOP.
      lt_data-stdaz = stdaz_s + stdaz_e.
      temp = lt_data-stdaz * 60.
      PERFORM convert_min_to_time USING temp
                                  CHANGING pv_remain_tm.
    ENDIF.
    CLEAR ls_zshr0115.
    IF lt_data-datum eq ps_zthr0112-datum.
      check_date = lt_data-datum - 1.
      READ TABLE pt_save WITH KEY pernr = ps_zthr0112-pernr
                                  datum = check_date.
      IF sy-subrc eq 0.
        MOVE-CORRESPONDING pt_save TO ls_zshr0115.
      ENDIF.
      CLEAR ls_zshr0145.
      READ TABLE lt_zthr0112_chk WITH KEY pernr = ps_zthr0112-pernr
                                          datum = check_date
                                          ztomo = 'X'
                                          zdaeh = 'X'
                                 INTO ls_zshr0145.
      IF sy-subrc eq 0.
        MOVE-CORRESPONDING ls_zshr0145 TO ls_zshr0115.
      ENDIF.
      IF ls_zshr0115 IS NOT INITIAL.
        CALL FUNCTION 'ZHR_52TM_CALC_WORK_TIME_DAYILY'
          EXPORTING
            is_day     = ls_zshr0115
          TABLES
            t_day_time = lt_zshr0115.
        READ TABLE lt_zshr0115 WITH KEY datum   = ps_zthr0112-datum
                               INTO ls_zshr0115.
        IF sy-subrc eq 0 .
          IF ls_zshr0115-stdaz >= '4.5'.
            CONTINUE.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
    ADD 1 TO ps_zthr0112-zdaeh_day.
    MOVE-CORRESPONDING ps_zthr0112 TO pt_daeh.
    pt_daeh-daeh_dt = lt_data-datum.
    pt_daeh-daeh_dt = lt_data-datum.
    IF pv_remain_tm IS NOT INITIAL.
      pt_daeh-zrlwk_tm = pv_remain_tm.
    ELSE.
      pt_daeh-zrlwk_tm = lt_data-zrlwk_tm.
    ENDIF.
    pt_daeh-zbegtm = lt_data-zbegtm.
    pt_daeh-zendtm = lt_data-zendtm.
    PERFORM convert_time_to_min USING pt_daeh-zrlwk_tm
                            CHANGING lv_min.
    ADD lv_min TO lv_zdaeh_t_min.
    APPEND pt_daeh.
    CLEAR pt_daeh.
    CLEAR: stdaz_s, stdaz_e.
  ENDLOOP.
  IF ps_zthr0112-zdaeh_day > 0.
    ps_zthr0112-zdaeh = 'X'.
    PERFORM convert_min_to_time USING lv_zdaeh_t_min
                                CHANGING ps_zthr0112-zdaeh_tm.
    MOVE-CORRESPONDING ps_zthr0112 TO pt_save.
    APPEND pt_save.
    CLEAR pt_save.
  ENDIF.
ENDFORM.
FORM convert_time_to_min  USING    pv_time
                          CHANGING pv_min.
  DATA: lv_hour TYPE i,
        lv_min TYPE i.
  lv_hour = pv_time(2).
  lv_min = pv_time+2(2).
  pv_min = ( lv_hour * 60 ) + lv_min.
ENDFORM.
FORM convert_hour_to_min  USING    pv_hour
                           CHANGING pv_min.
  pv_min = pv_hour * 60.
ENDFORM.
FORM convert_min_to_hour  USING    pv_min
                          CHANGING pv_hour.
  DATA: lv_time1(4),
        lv_time2(2) TYPE n.
  lv_time1 = pv_min DIV 60.
  lv_time2 = pv_min MOD 60.
  IF lv_time2 IS INITIAL.
    pv_hour = lv_time1.
  ELSE.
    CONCATENATE lv_time1 ':' lv_time2 INTO pv_hour.
  ENDIF.
ENDFORM.
FORM convert_min_to_hour2  USING    pv_min
                          CHANGING pv_hour.
  DATA: lv_time1(4),
        lv_time2(2) TYPE n.
  lv_time1 = pv_min DIV 60.
  lv_time2 = pv_min MOD 60.
  CONCATENATE lv_time1 ':' lv_time2 INTO pv_hour.
ENDFORM.
FORM convert_min_to_hour3  USING    pv_min
                          CHANGING pv_hour.
  DATA: lv_time1(4) TYPE n,
        lv_time2(2) TYPE n.
  lv_time1 = pv_min DIV 60.
  lv_time2 = pv_min MOD 60.
  CONCATENATE lv_time1 lv_time2 INTO pv_hour.
ENDFORM.
FORM convert_min_to_time  USING    pv_min
                          CHANGING pv_time.
  DATA: lv_time1 TYPE n LENGTH 2,
        lv_time2 TYPE n LENGTH 2.
  lv_time1 = pv_min DIV 60.
  lv_time2 = pv_min MOD 60.
  CONCATENATE lv_time1 lv_time2 '00' INTO pv_time.
ENDFORM.
