*&---------------------------------------------------------------------*
*& 프로그램 : ZRPTH411_RET_DEL
*& 용도     : 선택근무 월정산 후 퇴직자 PA2010 제외 (한 명씩)
*& 작성일   : 2026.10.24 / SAP_BASIS 700 기준 개발안
*& 상태     : SAP 구문검사 및 업무 테스트 전
*& 준비     : SE93에서 ZHR5_RET_DEL 생성 후 담당자 실행권한 부여
*&---------------------------------------------------------------------*
*& 정산연월 = 기존 선택근무 정산 대상연월(ZTHR0113-ZADMIT_YM).
*& PA2010 날짜는 해당 마감내역의 ZADMIT_DT로 찾는다.
*& ZTHR0112/0113/0132/0160은 삭제하거나 수정하지 않는다.
*&---------------------------------------------------------------------*
REPORT zrpth411_ret_del.

CONSTANTS: gc_wktp  TYPE zthr0113-z52wktp VALUE '0110',
           gc_lgart TYPE pa2010-lgart     VALUE '8050',
           gc_tcode TYPE tstc-tcode      VALUE 'ZHR5_RET_DEL'.

DATA: gv_title(60) TYPE c,
      gv_lper(20) TYPE c,
      gv_lmon(20) TYPE c,
      gv_note(79) TYPE c.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE gv_title.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(20) gv_lper FOR FIELD p_pernr.
PARAMETERS p_pernr TYPE pa2010-pernr OBLIGATORY.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT 1(20) gv_lmon FOR FIELD p_month.
PARAMETERS p_month TYPE zthr0113-zadmit_ym OBLIGATORY.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN COMMENT /1(79) gv_note.
SELECTION-SCREEN END OF BLOCK b1.

DATA: gt_2010   TYPE STANDARD TABLE OF pa2010,
      gt_before TYPE STANDARD TABLE OF pa2010,
      gs_2010   TYPE pa2010,
      gs_p2010  TYPE p2010,
      gs_return TYPE bapireturn1,
      gv_error  TYPE string,
      gv_text   TYPE string,
      gv_answer TYPE c,
      gv_count  TYPE i,
      gv_count_text(10) TYPE c.

RANGES gr_date FOR gs_2010-begda.

INITIALIZATION.
  gv_title = '선택근무 퇴직자 지급 항목 삭제'.
  gv_lper  = '퇴직자 사번'.
  gv_lmon  = '정산 대상연월'.
  gv_note  = '연월은 YYYYMM 형식입니다. 기존 선택근무 정산의 대상연월을 입력하세요.'.

AT SELECTION-SCREEN.
  IF p_month CN '0123456789' OR p_month(4) = '0000'
     OR p_month+4(2) < '01' OR p_month+4(2) > '12'.
    MESSAGE '정산연월을 YYYYMM 형식으로 입력하세요. 예: 202609'
      TYPE 'E'.
  ENDIF.
  IF p_pernr IS INITIAL.
    MESSAGE '퇴직자 사번 한 명을 입력하세요.' TYPE 'E'.
  ENDIF.

START-OF-SELECTION.
* 1. 확인창이 필요한 프로그램이므로 대화식으로만 실행한다.
  IF sy-batch = 'X' OR sy-binpt = 'X'.
    MESSAGE '이 프로그램은 SAP GUI에서 직접 실행하세요.'
      TYPE 'S' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

* SE38로 실행하더라도 전용 트랜잭션 권한을 확인한다.
  AUTHORITY-CHECK OBJECT 'S_TCODE'
    ID 'TCD' FIELD gc_tcode.
  IF sy-subrc <> 0.
    MESSAGE 'ZHR5_RET_DEL 실행권한이 없습니다.'
      TYPE 'S' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

* 2. 현재 퇴직 여부, 월마감, 해당 월의 선택 지급 항목을 확인한다.
  PERFORM read_target CHANGING gv_error.
  IF gv_error IS NOT INITIAL.
    MESSAGE gv_error TYPE 'S' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.
  gt_before[] = gt_2010[].
  DESCRIBE TABLE gt_2010 LINES gv_count.
  WRITE gv_count TO gv_count_text LEFT-JUSTIFIED.
  CONDENSE gv_count_text.

* 3. 실제 삭제 전에 한 번 더 확인한다. 기본 버튼은 '아니오'.
  CONCATENATE '사번' p_pernr '/ 정산연월' p_month
              '/ 선택근무 지급 항목' gv_count_text '건을'
              'PA2010에서 삭제하시겠습니까?'
         INTO gv_text SEPARATED BY space.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = '퇴직자 삭제 최종 확인'
      text_question         = gv_text
      text_button_1         = '예, 삭제'
      text_button_2         = '아니오'
      default_button        = '2'
      display_cancel_button = 'X'
    IMPORTING
      answer                = gv_answer
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.
  IF sy-subrc <> 0.
    MESSAGE '확인창을 표시하지 못했습니다. 삭제하지 않았습니다.'
      TYPE 'S' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.
  IF gv_answer <> '1'.
    MESSAGE '삭제를 취소했습니다.' TYPE 'S'.
    EXIT.
  ENDIF.

* 4. 사번을 잠근 뒤 확인창을 보는 동안 자료가 바뀌었는지 검사한다.
  CLEAR gs_return.
  CALL FUNCTION 'BAPI_EMPLOYEE_ENQUEUE'
    EXPORTING
      number = p_pernr
    IMPORTING
      return = gs_return
    EXCEPTIONS
      OTHERS = 1.
  IF sy-subrc <> 0 OR gs_return-type CA 'AEX'.
    MESSAGE '사번 잠금에 실패했습니다. 다른 작업 종료 후 다시 실행하세요.'
      TYPE 'S' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

  PERFORM read_target CHANGING gv_error.
  IF gv_error IS NOT INITIAL.
    PERFORM unlock_employee.
    MESSAGE gv_error TYPE 'S' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.
  IF gt_before[] <> gt_2010[].
    PERFORM unlock_employee.
    MESSAGE '확인 중 지급 항목이 변경되었습니다. 다시 조회하세요.'
      TYPE 'S' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

* 5. 표준 인포타입 함수로 조회한 레코드의 전체 키를 전달해 삭제한다.
*    한 명에게 여러 건이 있으면 모두 성공한 경우에만 저장한다.
  PERFORM delete_target CHANGING gv_error.
  PERFORM unlock_employee.
  IF gv_error IS NOT INITIAL.
    MESSAGE gv_error TYPE 'I' DISPLAY LIKE 'E'.
    EXIT.
  ENDIF.

* 6. 저장과 삭제 결과 확인을 마친 뒤 완료 팝업을 표시한다.
  CONCATENATE '삭제 완료되었습니다. 사번' p_pernr
              '/ 정산연월' p_month '/' gv_count_text '건'
         INTO gv_text SEPARATED BY space.
  MESSAGE gv_text TYPE 'I'.

*&---------------------------------------------------------------------*
*& 삭제 대상 읽기: 이 FORM은 조회만 수행한다.
*&---------------------------------------------------------------------*
FORM read_target CHANGING pv_error TYPE string.
  DATA: lt_0000 TYPE STANDARD TABLE OF pa0000,
        ls_0000 TYPE pa0000,
        lt_0113 TYPE STANDARD TABLE OF zthr0113,
        ls_0113 TYPE zthr0113,
        lv_lines TYPE i,
        lv_month TYPE zthr0160-zmonth,
        lv_pernr TYPE pa2010-pernr.

  CLEAR pv_error.
  REFRESH: gt_2010, gr_date.

* 실행일 현재 퇴직(STAT2 = 0)인 한 명만 처리한다.
  SELECT * INTO TABLE lt_0000 FROM pa0000
   WHERE pernr = p_pernr
     AND begda <= sy-datum AND endda >= sy-datum
     AND sprps = space.
  DESCRIBE TABLE lt_0000 LINES lv_lines.
  IF lv_lines <> 1.
    pv_error = '현재 유효한 인사상태가 한 건이 아닙니다. 인사기록을 확인하세요.'.
    RETURN.
  ENDIF.
  READ TABLE lt_0000 INTO ls_0000 INDEX 1.
  IF ls_0000-stat2 <> '0'.
    pv_error = '현재 퇴직자가 아닙니다. 삭제할 수 없습니다.'.
    RETURN.
  ENDIF.

* 기존 선택 월정산의 마감확정 표식을 확인한다.
  SELECT SINGLE zmonth INTO lv_month FROM zthr0160
   WHERE zmonth = p_month AND z52wktp = gc_wktp.
  IF sy-subrc <> 0.
    pv_error = '해당 월의 선택근무 마감확정 내역이 없습니다.'.
    RETURN.
  ENDIF.

* 연월은 PA2010-BEGDA의 앞 6자리가 아니라 ZADMIT_YM에 적용한다.
  SELECT * INTO TABLE lt_0113 FROM zthr0113
   WHERE pernr = p_pernr AND zadmit_ym = p_month
     AND z52wktp = gc_wktp.
  IF lt_0113 IS INITIAL.
    pv_error = '해당 사번과 연월의 선택근무 정산 내역이 없습니다.'.
    RETURN.
  ENDIF.

  LOOP AT lt_0113 INTO ls_0113.
    IF ls_0113-zadmit_dt IS INITIAL.
      pv_error = '정산일이 없는 내역이 있습니다. 정산확정을 확인하세요.'.
      RETURN.
    ENDIF.
    CLEAR gr_date.
    gr_date-sign = 'I'.
    gr_date-option = 'EQ'.
    gr_date-low = ls_0113-zadmit_dt.
    APPEND gr_date.
  ENDLOOP.
  SORT gr_date BY low.
  DELETE ADJACENT DUPLICATES FROM gr_date COMPARING low.

* 같은 PA 일자에 다른 정산월 등이 합쳐졌으면 월별 분리삭제하지 않는다.
  SELECT SINGLE pernr INTO lv_pernr FROM zthr0113
   WHERE pernr = p_pernr AND zadmit_dt IN gr_date
     AND ( zadmit_ym <> p_month OR z52wktp <> gc_wktp ).
  IF sy-subrc = 0.
    pv_error = '같은 정산일에 다른 월 또는 유형의 내역이 있습니다. 개별 확인이 필요합니다.'.
    RETURN.
  ENDIF.

  SELECT * INTO TABLE gt_2010 FROM pa2010
   WHERE pernr = p_pernr AND subty = gc_lgart
     AND lgart = gc_lgart AND begda IN gr_date.
  IF gt_2010 IS INITIAL.
    pv_error = '삭제할 선택근무 PA2010 항목이 없습니다. 이미 삭제됐을 수 있습니다.'.
    RETURN.
  ENDIF.

  LOOP AT gt_2010 INTO gs_2010.
    IF gs_2010-awref IS NOT INITIAL.
      pv_error = '전표번호가 있는 항목입니다. 이 프로그램으로 삭제할 수 없습니다.'.
      RETURN.
    ENDIF.
* 기존 ZRPTH411에서 만드는 기본 키의 일자별 항목만 허용한다.
    IF gs_2010-begda <> gs_2010-endda
       OR gs_2010-objps IS NOT INITIAL
       OR gs_2010-sprps IS NOT INITIAL
       OR gs_2010-seqnr IS NOT INITIAL
       OR gs_2010-histo IS NOT INITIAL.
      pv_error = '일반 선택근무 정산 항목과 키가 다릅니다. 개별 확인이 필요합니다.'.
      RETURN.
    ENDIF.
  ENDLOOP.
  SORT gt_2010 BY pernr subty objps sprps endda begda seqnr.
ENDFORM.

*&---------------------------------------------------------------------*
*& 실제 삭제: 함수 오류 시 전체 취소, 성공 시 저장 후 재조회
*&---------------------------------------------------------------------*
FORM delete_target CHANGING pv_error TYPE string.
  DATA lv_remaining TYPE i.
  CLEAR pv_error.

  LOOP AT gt_2010 INTO gs_2010.
    CLEAR: gs_p2010, gs_return.
    MOVE-CORRESPONDING gs_2010 TO gs_p2010.
    gs_p2010-infty = '2010'.

    CALL FUNCTION 'HR_INFOTYPE_OPERATION'
      EXPORTING
        infty         = '2010'
        number        = gs_p2010-pernr
        subtype       = gs_p2010-subty
        objectid      = gs_p2010-objps
        lockindicator = gs_p2010-sprps
        validityend   = gs_p2010-endda
        validitybegin = gs_p2010-begda
        recordnumber  = gs_p2010-seqnr
        record        = gs_p2010
        operation     = 'DEL'
        dialog_mode   = '0'
        nocommit      = 'X'
      IMPORTING
        return        = gs_return
      EXCEPTIONS
        OTHERS        = 1.
    IF sy-subrc <> 0 OR gs_return-type CA 'AEX'.
      ROLLBACK WORK.
      CONCATENATE '삭제 실패. 전체 취소했습니다.' gs_return-message
             INTO pv_error SEPARATED BY space.
      RETURN.
    ENDIF.
  ENDLOOP.

  COMMIT WORK AND WAIT.
  IF sy-subrc <> 0.
    pv_error = '저장 결과 오류입니다. 실제 반영 상태를 시스템 담당자에게 확인하세요.'.
    RETURN.
  ENDIF.

* 성공 메시지를 함수 반환값만으로 판단하지 않고 DB 결과도 확인한다.
  SELECT COUNT( * ) INTO lv_remaining FROM pa2010
   WHERE pernr = p_pernr AND subty = gc_lgart
     AND lgart = gc_lgart AND begda IN gr_date.
  IF lv_remaining <> 0.
    pv_error = '저장 후에도 대상 항목이 남아 있습니다. 실제 반영 상태를 확인하세요.'.
  ENDIF.
ENDFORM.

FORM unlock_employee.
  CALL FUNCTION 'BAPI_EMPLOYEE_DEQUEUE'
    EXPORTING
      number = p_pernr
    EXCEPTIONS
      OTHERS = 1.
ENDFORM.
