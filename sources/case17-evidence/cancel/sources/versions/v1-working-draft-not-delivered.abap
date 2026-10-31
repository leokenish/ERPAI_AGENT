REPORT zhr_cw_member_del.

*---------------------------------------------------------------------*
* 선택근로 등록 직후 취소 전용 / SAP_BASIS 700
* 입력한 사번, 시작일, 종료일이 모두 일치하는 한 기간만 처리한다.
* PA9021은 정보형 삭제 함수, ZTHR0112/0132는 물리 삭제한다.
* 결재 연결과 실적 상태는 삭제 차단 조건으로 사용하지 않는다.
* 대휴 및 결재 테이블, 정산 이력과 지급 자료는 변경하지 않는다.
* 설치: 전용 T-code ZHR_CW_DEL을 만들고 인사부에만 부여한다.
* 중요: README의 동시 마감 잠금 및 로컬 갱신 검증 후 사용한다.
*---------------------------------------------------------------------*
CONSTANTS: gc_wktp TYPE pa9021-z52wktp VALUE '0110',
           gc_tcode TYPE tstc-tcode VALUE 'ZHR_CW_DEL'.
PARAMETERS: p_pernr TYPE pa9021-pernr OBLIGATORY,
            p_begda TYPE pa9021-begda OBLIGATORY,
            p_endda TYPE pa9021-endda OBLIGATORY.

DATA: gt_9021 TYPE STANDARD TABLE OF pa9021,
      gt_0132 TYPE STANDARD TABLE OF zthr0132,
      gt_0112 TYPE STANDARD TABLE OF zthr0112,
      gs_9021 TYPE pa9021,
      gs_0132 TYPE zthr0132,
      gs_p9021 TYPE p9021,
      gs_return TYPE bapireturn1,
      gv_error TYPE string,
      gv_month TYPE zthr0160-zmonth,
      gv_count TYPE i,
      gv_deleted TYPE i,
      gv_answer TYPE c,
      gv_question TYPE string,
      gv_count_text TYPE c LENGTH 12,
      gv_locked TYPE c,
      gt_locks TYPE STANDARD TABLE OF rstable-tabname,
      gv_tabname TYPE rstable-tabname,
      go_sql_error TYPE REF TO cx_sy_open_sql_db.

AT SELECTION-SCREEN.
  IF p_pernr IS INITIAL OR p_begda IS INITIAL OR p_endda IS INITIAL.
    MESSAGE '사번, 시작일, 종료일은 필수입니다.' TYPE 'E'.
  ENDIF.
  IF p_begda > p_endda.
    MESSAGE '시작일은 종료일 이전이어야 합니다.' TYPE 'E'.
  ENDIF.
  CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
    EXPORTING date = p_begda
    EXCEPTIONS plausibility_check_failed = 1 OTHERS = 2.
  IF sy-subrc <> 0.
    MESSAGE '시작일이 올바르지 않습니다.' TYPE 'E'.
  ENDIF.
  CALL FUNCTION 'DATE_CHECK_PLAUSIBILITY'
    EXPORTING date = p_endda
    EXCEPTIONS plausibility_check_failed = 1 OTHERS = 2.
  IF sy-subrc <> 0.
    MESSAGE '종료일이 올바르지 않습니다.' TYPE 'E'.
  ENDIF.

START-OF-SELECTION.
  IF sy-batch = 'X' OR sy-binpt = 'X'.
    MESSAGE 'SAP GUI에서 직접 실행하세요.' TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

* SE38로 실행해도 인사부 전용 트랜잭션 권한을 검사한다.
  AUTHORITY-CHECK OBJECT 'S_TCODE' ID 'TCD' FIELD gc_tcode.
  IF sy-subrc <> 0.
    MESSAGE '인사부 전용 ZHR_CW_DEL 권한이 없습니다.'
      TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.
  gv_month = p_endda+0(6).

  TRY.
      PERFORM read_and_check.
    CATCH cx_sy_open_sql_db INTO go_sql_error.
      gv_error = go_sql_error->get_text( ).
  ENDTRY.
  IF gv_error IS NOT INITIAL.
    MESSAGE gv_error TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

* 기본 버튼은 취소. 실적이 0건이어도 등록 취소는 가능하다.
  WRITE gv_count TO gv_count_text LEFT-JUSTIFIED.
  CONDENSE gv_count_text.
  CONCATENATE '사번' p_pernr '기간' p_begda '~' p_endda
    '등록/기간 각 1건과 실적' gv_count_text
    '건을 영구 삭제합니다. 결재 연결이 있어도 삭제합니다. 계속할까요?'
    INTO gv_question SEPARATED BY space.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar = '선택근로 대상자 삭제'
      text_question = gv_question
      text_button_1 = '삭제'
      text_button_2 = '취소'
      default_button = '2'
      display_cancel_button = 'X'
    IMPORTING answer = gv_answer
    EXCEPTIONS text_not_found = 1 OTHERS = 2.
  IF sy-subrc <> 0 OR gv_answer <> '1'.
    RETURN.
  ENDIF.

  TRY.
      PERFORM lock_target.
      IF gv_error IS INITIAL.
* 확인창이 떠 있는 동안 자료가 바뀌었는지도 전체 값으로 비교한다.
        PERFORM recheck_target.
      ENDIF.
      IF gv_error IS INITIAL.
        PERFORM delete_target.
      ENDIF.
    CATCH cx_sy_open_sql_db INTO go_sql_error.
      gv_error = go_sql_error->get_text( ).
  ENDTRY.

  IF gv_error IS NOT INITIAL.
    ROLLBACK WORK.
  ENDIF.
  PERFORM unlock_target.
  IF gv_error IS NOT INITIAL.
    MESSAGE gv_error TYPE 'S' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

* 처리 결과는 화면 목록으로 출력한다. 영구 감사원장은 별도이다.
  WRITE: / '선택근로 대상자 삭제 완료',
         / '사번:', p_pernr,
         / '시작일:', p_begda, '종료일:', p_endda,
         / '정산연월:', gv_month,
         / 'PA9021:', 1, 'ZTHR0132:', 1,
         / 'ZTHR0112:', gv_deleted,
         / '처리자:', sy-uname, '처리일시:', sy-datum, sy-uzeit.

*---------------------------------------------------------------------*
* 정확한 등록/기간을 읽고 마감 및 정산 흔적을 검사한다.
*---------------------------------------------------------------------*
FORM read_and_check.
  DATA: lv_count TYPE i,
        lv_month TYPE zthr0160-zmonth,
        lt_org TYPE STANDARD TABLE OF pa0001,
        ls_org TYPE pa0001.
  CLEAR gv_error.
  REFRESH: gt_9021, gt_0132, gt_0112.

  SELECT * INTO TABLE gt_9021 FROM pa9021
    WHERE pernr = p_pernr AND begda = p_begda
      AND endda = p_endda AND z52wktp = gc_wktp.
  DESCRIBE TABLE gt_9021 LINES lv_count.
  IF lv_count <> 1.
    gv_error = 'PA9021의 선택근로 등록이 정확히 1건이어야 합니다.'.
    RETURN.
  ENDIF.
  READ TABLE gt_9021 INTO gs_9021 INDEX 1.

* 인사정보형 쓰기 권한도 확인한다. 조회기간 내 조직이력 전체 검사.
* P_ORGXX/구조권한 등 회사 추가 권한은 설치 시 담당자가 검증한다.
  SELECT * INTO TABLE lt_org FROM pa0001
    WHERE pernr = p_pernr AND begda <= p_endda AND endda >= p_begda.
  IF lt_org IS INITIAL.
    gv_error = '기간 내 조직정보가 없어 권한을 확인할 수 없습니다.'.
    RETURN.
  ENDIF.
  LOOP AT lt_org INTO ls_org.
    AUTHORITY-CHECK OBJECT 'P_ORGIN'
      ID 'INFTY' FIELD '9021'
      ID 'SUBTY' FIELD gs_9021-subty
      ID 'AUTHC' FIELD 'W'
      ID 'PERSA' FIELD ls_org-werks
      ID 'PERSG' FIELD ls_org-persg
      ID 'PERSK' FIELD ls_org-persk
      ID 'VDSK1' FIELD ls_org-vdsk1.
    IF sy-subrc <> 0.
      gv_error = '대상 직원의 정보형 9021 변경 권한이 없습니다.'.
      RETURN.
    ENDIF.
  ENDLOOP.

  SELECT * INTO TABLE gt_0132 FROM zthr0132
    WHERE pernr = p_pernr AND begda = p_begda
      AND endda = p_endda AND z52wktp = gc_wktp.
  DESCRIBE TABLE gt_0132 LINES lv_count.
  IF lv_count <> 1.
    gv_error = 'ZTHR0132의 선택근로 기간이 정확히 1건이어야 합니다.'.
    RETURN.
  ENDIF.
  READ TABLE gt_0132 INTO gs_0132 INDEX 1.
  IF gs_9021-z52prsq <> gs_0132-z52prsq.
    gv_error = '등록과 선택기간의 근무주기가 다릅니다.'.
    RETURN.
  ENDIF.

* 근무일 월이 아닌 선택기간 종료월로 마감을 확인한다.
  SELECT SINGLE zmonth INTO lv_month FROM zthr0160
    WHERE zmonth = gv_month AND z52wktp = gc_wktp.
  IF sy-subrc = 0.
    gv_error = '해당 정산연월의 선택근로 마감이 끝나 삭제할 수 없습니다.'.
    RETURN.
  ENDIF.

* 마감 표시가 없어도 과거/소급 정산 흔적이 있으면 삭제 금지.
  SELECT COUNT( * ) INTO lv_count FROM zthr0113
    WHERE pernr = p_pernr AND begda = p_begda
      AND endda = p_endda AND z52wktp = gc_wktp.
  IF lv_count > 0.
    gv_error = '해당 선택기간에 정산 이력이 있어 삭제할 수 없습니다.'.
    RETURN.
  ENDIF.

* 날짜 범위로 자르지 않는다. 기간 키에 속한 모든 실적을 읽는다.
  SELECT * INTO TABLE gt_0112 FROM zthr0112
    WHERE pernr = p_pernr AND begda = p_begda
      AND endda = p_endda AND z52wktp = gc_wktp.
  LOOP AT gt_0112 TRANSPORTING NO FIELDS
    WHERE z52prsq <> gs_0132-z52prsq
       OR zadmit_dt <> '00000000' AND zadmit_dt <> space.
    gv_error = '실적에 다른 근무주기 또는 정산일이 있어 삭제할 수 없습니다.'.
    RETURN.
  ENDLOOP.
  SORT gt_0112 BY pernr datum begda endda z52wktp z52prsq seqnr.
  DESCRIBE TABLE gt_0112 LINES gv_count.
ENDFORM.

*---------------------------------------------------------------------*
* 직원 잠금 + 이 프로그램 간 공통 테이블 잠금.
* E_TABLE은 기존 월마감/입력 프로그램이 자동으로 따르는 잠금이 아니다.
* 운영 전 기존 쓰기 경로와 같은 잠금을 사용하도록 연계해야 한다.
*---------------------------------------------------------------------*
FORM lock_target.
  CALL FUNCTION 'BAPI_EMPLOYEE_ENQUEUE'
    EXPORTING number = p_pernr
    IMPORTING return = gs_return
    EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0 OR gs_return-type CA 'AEX'.
    gv_error = '직원이 다른 작업 중이어서 잠글 수 없습니다.'.
    RETURN.
  ENDIF.
  gv_locked = 'X'.
  PERFORM lock_table USING 'ZTHR0160'.
  PERFORM lock_table USING 'ZTHR0113'.
  PERFORM lock_table USING 'ZTHR0132'.
  PERFORM lock_table USING 'ZTHR0112'.
ENDFORM.

FORM lock_table USING pv_tabname TYPE rstable-tabname.
  IF gv_error IS NOT INITIAL.
    RETURN.
  ENDIF.
  CALL FUNCTION 'ENQUEUE_E_TABLE'
    EXPORTING tabname = pv_tabname varkey = space _scope = '1'
    EXCEPTIONS foreign_lock = 1 system_failure = 2 OTHERS = 3.
  IF sy-subrc <> 0.
    CONCATENATE pv_tabname '잠금을 얻지 못했습니다. 다시 실행하세요.'
      INTO gv_error SEPARATED BY space.
  ELSE.
    APPEND pv_tabname TO gt_locks.
  ENDIF.
ENDFORM.

FORM recheck_target.
  DATA: lt_before_9021 TYPE STANDARD TABLE OF pa9021,
        lt_before_0132 TYPE STANDARD TABLE OF zthr0132,
        lt_before_0112 TYPE STANDARD TABLE OF zthr0112.
  lt_before_9021[] = gt_9021[].
  lt_before_0132[] = gt_0132[].
  lt_before_0112[] = gt_0112[].
  PERFORM read_and_check.
  IF gv_error IS NOT INITIAL.
    RETURN.
  ENDIF.
  IF lt_before_9021[] <> gt_9021[] OR
     lt_before_0132[] <> gt_0132[] OR
     lt_before_0112[] <> gt_0112[].
    gv_error = '확인 중 자료가 변경됐습니다. 다시 조회하여 실행하세요.'.
  ENDIF.
ENDFORM.

*---------------------------------------------------------------------*
* 중간 COMMIT 없이 삭제. 오류 시 호출부에서 전체 ROLLBACK한다.
* 정보형 함수의 갱신도 같은 DB LUW에서 수행하도록 로컬 갱신 사용.
* 사용자 출구에서 COMMIT/별도 RFC를 수행하면 원자성이 깨지므로
* 반드시 개발계에서 정보형 함수/출구와 오류 강제시험을 검증한다.
*---------------------------------------------------------------------*
FORM delete_target.
  DATA lv_count TYPE i.
  SET UPDATE TASK LOCAL.
  CLEAR: gs_p9021, gs_return.
  MOVE-CORRESPONDING gs_9021 TO gs_p9021.
  gs_p9021-infty = '9021'.
  CALL FUNCTION 'HR_INFOTYPE_OPERATION'
    EXPORTING
      infty = '9021'
      number = gs_p9021-pernr
      subtype = gs_p9021-subty
      objectid = gs_p9021-objps
      lockindicator = gs_p9021-sprps
      validityend = gs_p9021-endda
      validitybegin = gs_p9021-begda
      recordnumber = gs_p9021-seqnr
      record = gs_p9021
      operation = 'DEL'
      dialog_mode = '0'
      nocommit = 'X'
    IMPORTING return = gs_return
    EXCEPTIONS OTHERS = 1.
  IF sy-subrc <> 0 OR gs_return-type CA 'AEX'.
    CONCATENATE '정보형 삭제 실패:' gs_return-message
      INTO gv_error SEPARATED BY space.
    RETURN.
  ENDIF.

* 결재 연결 및 실적 상태와 관계없이 해당 기간 실적을 물리 삭제.
  DELETE FROM zthr0112 WHERE pernr = p_pernr
    AND begda = p_begda AND endda = p_endda
    AND z52wktp = gc_wktp AND z52prsq = gs_0132-z52prsq.
  gv_deleted = sy-dbcnt.
  IF gv_deleted <> gv_count.
    gv_error = '실적 삭제 건수가 달라 전체 취소합니다.'.
    RETURN.
  ENDIF.
  DELETE FROM zthr0132 WHERE pernr = p_pernr
    AND begda = p_begda AND endda = p_endda
    AND z52wktp = gc_wktp AND z52prsq = gs_0132-z52prsq.
  IF sy-dbcnt <> 1.
    gv_error = '선택기간 삭제 건수가 달라 전체 취소합니다.'.
    RETURN.
  ENDIF.

* 저장 직전 마감 표시를 한 번 더 확인한다.
  SELECT COUNT( * ) INTO lv_count FROM zthr0160
    WHERE zmonth = gv_month AND z52wktp = gc_wktp.
  IF lv_count > 0.
    gv_error = '처리 중 마감이 확인되어 전체 취소합니다.'.
    RETURN.
  ENDIF.
  COMMIT WORK AND WAIT.
  IF sy-subrc <> 0.
    gv_error = '갱신 오류입니다. 시스템 담당자가 저장 결과를 확인해야 합니다.'.
  ENDIF.
ENDFORM.

FORM unlock_target.
  LOOP AT gt_locks INTO gv_tabname.
    CALL FUNCTION 'DEQUEUE_E_TABLE'
      EXPORTING tabname = gv_tabname varkey = space _scope = '1'.
  ENDLOOP.
  REFRESH gt_locks.
  IF gv_locked = 'X'.
    CALL FUNCTION 'BAPI_EMPLOYEE_DEQUEUE'
      EXPORTING number = p_pernr
      IMPORTING return = gs_return.
    CLEAR gv_locked.
  ENDIF.
ENDFORM.
