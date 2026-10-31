REPORT zhr_daeh_rate_check.

*---------------------------------------------------------------------*
* 대휴 실비 단가 인상 누락 후보 조회 / SAP_BASIS 700
* 인정시간은 재계산하지 않는다. 0.5시간 단위 금액 배수만 검사한다.
* 추정차액은 금액에서 역산한 값이며 확정 지급차액이 아니다.
* ZTHRBS01 조회 금액을 그대로 원 단위로 비교한다. 임의 /100 금지.
*---------------------------------------------------------------------*
TYPE-POOLS: slis.
TABLES: zthrbs01.
TYPES: ty_money TYPE p LENGTH 16 DECIMALS 2,
       ty_number TYPE p LENGTH 16 DECIMALS 8.
* 인사이력은 조회기간과 겹치는 자료만 한 번 읽는다.
TYPES: BEGIN OF ty_person,
         pernr TYPE pa0001-pernr,
         begda TYPE pa0001-begda,
         endda TYPE pa0001-endda,
         persk TYPE pa0001-persk,
       END OF ty_person.
TYPES: BEGIN OF ty_out,
         pernr TYPE zthrbs01-pernr,
         rdate TYPE zthrbs01-rdate,
         seqnr TYPE zthrbs01-seqnr,
         subty TYPE zthrbs01-subty,
         begda TYPE zthrbs01-begda,
         endda TYPE zthrbs01-endda,
         znal TYPE zthrbs01-znal,
         zdday TYPE zthrbs01-zdday,
         zgubun TYPE zthrbs01-zgubun,
         zsourflex TYPE zthrbs01-zsourflex,
         zd_time TYPE zthrbs01-zd_time,
         ztomo TYPE zthrbs01-ztomo,
         zdchk TYPE zthrbs01-zdchk,
         jorgeh_txt TYPE zthrbs01-jorgeh_txt,
         persk TYPE pa0001-persk,
         rate_group TYPE c LENGTH 30,
         old_rate TYPE ty_money,
         new_rate TYPE ty_money,
         old_step TYPE ty_money,
         new_step TYPE ty_money,
         amount TYPE ty_money,
         settle TYPE ty_money,
         old_ok TYPE c,
         new_ok TYPE c,
         month_ok TYPE c,
         result TYPE c LENGTH 40,
         diff_ok TYPE c,
         estimate TYPE ty_money,
         difference TYPE ty_money,
         note TYPE c LENGTH 120,
       END OF ty_out.
CONSTANTS: gc_special_rate TYPE ty_money VALUE '5400'.
DATA: gt_person TYPE STANDARD TABLE OF ty_person,
      gs_person TYPE ty_person,
      gv_person_ok TYPE c,
      gt_source TYPE STANDARD TABLE OF zthrbs01,
      gs_source TYPE zthrbs01,
      gt_out TYPE STANDARD TABLE OF ty_out,
      gs_out TYPE ty_out,
      gt_fcat TYPE slis_t_fieldcat_alv,
      gs_fcat TYPE slis_fieldcat_alv,
      gs_layout TYPE slis_layout_alv,
      gv_from TYPE d,
      gv_to TYPE d,
      gv_change TYPE d,
      gv_old_step TYPE ty_money,
      gv_new_step TYPE ty_money,
      gv_old_check TYPE ty_money,
      gv_new_check TYPE ty_money.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-t01.
PARAMETERS: p_year TYPE n LENGTH 4 DEFAULT '2026' OBLIGATORY.
SELECT-OPTIONS: s_pernr FOR zthrbs01-pernr,
                s_gubun FOR zthrbs01-zgubun.
PARAMETERS: p_old TYPE ty_money DEFAULT '8400' OBLIGATORY,
            p_new TYPE ty_money DEFAULT '9240' OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

INITIALIZATION.
* 기존 통상 계산 분기의 통상/시차 구분값. 필요 시 조회조건에서 조정.
  s_gubun-sign = 'I'.
  s_gubun-option = 'EQ'.
  s_gubun-low = '1'. APPEND s_gubun.
  s_gubun-low = 'A'. APPEND s_gubun.
  s_gubun-low = 'B'. APPEND s_gubun.

AT SELECTION-SCREEN.
  IF p_year < '1900' OR p_year > '9998'.
    MESSAGE '조회연도를 확인하십시오.' TYPE 'E'.
  ENDIF.
  IF p_old <= 0 OR p_new <= p_old.
    MESSAGE '단가는 양수이며 인상 후 단가가 더 커야 합니다.' TYPE 'E'.
  ENDIF.
  gv_old_step = p_old / 4.
  gv_new_step = p_new / 4.
* SAP_BASIS 700: 조건문 안에서 계산하지 않고 먼저 계산한 값을 비교한다.
  gv_old_check = gv_old_step * 4.
  gv_new_check = gv_new_step * 4.
  IF gv_old_step <= 0 OR gv_new_step <= 0
     OR gv_old_check <> p_old OR gv_new_check <> p_new.
    MESSAGE '반시간 검사단위가 0.01원까지 표현되는 단가를 입력하세요.'
      TYPE 'E'.
  ENDIF.
  IF s_gubun[] IS INITIAL.
    MESSAGE '통상 입력구분을 지정하십시오. 기본값은 1/A/B입니다.' TYPE 'E'.
  ENDIF.

START-OF-SELECTION.
* 직접 SQL은 HR 구조권한을 자동 적용하지 않으므로 전용 조회권한 사용.
  AUTHORITY-CHECK OBJECT 'S_TCODE' ID 'TCD' FIELD 'ZHR_DAEH_CHK'.
  IF sy-subrc <> 0.
    MESSAGE 'ZHR_DAEH_CHK 조회 권한이 없습니다.' TYPE 'S'
      DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.
  CONCATENATE p_year '0801' INTO gv_from.
  CONCATENATE p_year '0930' INTO gv_to.
  CONCATENATE p_year '0901' INTO gv_change.
  gv_old_step = p_old / 4.
  gv_new_step = p_new / 4.
  PERFORM read_data.
  PERFORM check_data.
  IF gt_out[] IS INITIAL.
    MESSAGE '조회 조건에 해당하는 승인 대휴 자료가 없습니다.' TYPE 'S'.
    RETURN.
  ENDIF.
  PERFORM display_data.

FORM read_data.
* 현재 재직자 마스터로 제한하지 않아 퇴직자도 포함한다.
* RDATE는 저장된 원천 근무일이다. ZDDAY의 월로 단가를 바꾸지 않는다.
* 선택은 S, 통상은 선택/재량/간주 등 별도 생성구분이 없는 행을 조회.
  SELECT * INTO TABLE gt_source FROM zthrbs01
    WHERE pernr IN s_pernr
      AND rdate BETWEEN gv_from AND gv_to
      AND state = '3'
      AND zdaeh = 'Y'
      AND ( zsourflex = 'S'
         OR ( zsourflex = space AND zgubun IN s_gubun ) ).
  SORT gt_source BY pernr rdate seqnr.
* 사번과 기간을 제한하고, 퇴직 후 현재 인사정보로 과거를 덮어쓰지 않는다.
* FOR ALL ENTRIES가 빈 조건으로 전체 조회되지 않도록 먼저 검사한다.
  CLEAR gt_person.
  IF gt_source[] IS NOT INITIAL.
    SELECT pernr begda endda persk INTO TABLE gt_person FROM pa0001
      FOR ALL ENTRIES IN gt_source
      WHERE pernr = gt_source-pernr
        AND begda <= gv_to
        AND endda >= gv_from
        AND sprps = space.
    SORT gt_person BY pernr begda endda.
  ENDIF.
ENDFORM.

FORM determine_rates.
  DATA: lv_count TYPE i.
  CLEAR: gv_person_ok, lv_count.
* RDATE에 실제로 유효한 이력을 찾는다. 인사이력 공백/중복은 추측 금지.
  LOOP AT gt_person INTO gs_person
    WHERE pernr = gs_source-pernr
      AND begda <= gs_source-rdate
      AND endda >= gs_source-rdate.
    ADD 1 TO lv_count.
    gs_out-persk = gs_person-persk.
  ENDLOOP.
  IF lv_count = 0.
    gs_out-result = '별도확인: 인사이력 없음'.
    gs_out-note = '근무 시작일에 유효한 PA0001 미조회. 단가 판정 제외'.
    RETURN.
  ELSEIF lv_count > 1.
    CLEAR gs_out-persk.
    gs_out-result = '별도확인: 인사이력 중복'.
    gs_out-note = '근무 시작일에 유효한 PA0001 복수건. 단가 판정 제외'.
    RETURN.
  ENDIF.

* 기본 그룹은 기존 입력단가를 사용하고 확인된 PERSK만 예외 적용한다.
  gs_out-rate_group = '기본 인상 대상'.
  gs_out-old_rate = p_old.
  gs_out-new_rate = p_new.
  CASE gs_out-persk.
    WHEN 'E1' OR 'E4' OR 'E5' OR 'E6' OR 'E7'.
      gs_out-rate_group = '비정규 인상 대상'.
      gs_out-old_rate = gc_special_rate.
    WHEN 'E8'.
      gs_out-rate_group = '방송지원직 단가 유지'.
      gs_out-old_rate = gc_special_rate.
      gs_out-new_rate = gc_special_rate.
  ENDCASE.
* 시간외 단가의 50%를 반시간 단위로 검사하므로 기준단가 /4.
  gs_out-old_step = gs_out-old_rate / 4.
  gs_out-new_step = gs_out-new_rate / 4.
  gv_person_ok = 'X'.
ENDFORM.

FORM check_data.
  DATA: lv_units TYPE ty_number.
  LOOP AT gt_source INTO gs_source.
    CLEAR gs_out.
    MOVE-CORRESPONDING gs_source TO gs_out.
* 사용자 SAP 표본: ZD_MONEY 23100은 23,100원이다.
* 다른 보고서의 /100 표시식을 가져오면 231원이 되어 배수 검사가 틀린다.
    gs_out-amount = gs_source-zd_money.
    gs_out-settle = gs_source-jorgeh.
    gs_out-month_ok = '-'.
    PERFORM determine_rates.
    IF gv_person_ok IS INITIAL.
      APPEND gs_out TO gt_out.
      CONTINUE.
    ENDIF.
    IF gs_out-amount <= 0.
      gs_out-result = '확인: 0원 또는 음수'.
      gs_out-note = '0원을 정상 배수로 판정하지 않음. 면제/보정 등 확인'.
    ELSE.
      PERFORM check_multiple USING gs_out-amount gs_out-old_step
                             CHANGING gs_out-old_ok.
      PERFORM check_multiple USING gs_out-amount gs_out-new_step
                             CHANGING gs_out-new_ok.
      IF gs_out-rdate < gv_change.
        gs_out-month_ok = gs_out-old_ok.
      ELSE.
        gs_out-month_ok = gs_out-new_ok.
      ENDIF.
* E8은 두 단가가 동일하므로 양쪽 Y여도 공배수 판별불가가 아니다.
      IF gs_out-old_rate = gs_out-new_rate.
        IF gs_out-month_ok = 'Y'.
          gs_out-result = '유지단가 배수 일치(추정)'.
        ELSE.
          gs_out-result = '확인: 유지단가 배수 불일치'.
        ENDIF.
      ELSEIF gs_out-old_ok = 'Y' AND gs_out-new_ok = 'Y'.
        gs_out-result = '판별불가: 양쪽 배수 일치'.
      ELSEIF gs_out-month_ok = 'Y'.
        gs_out-result = '기준월 배수 일치(추정)'.
      ELSEIF gs_out-old_ok = 'Y' OR gs_out-new_ok = 'Y'.
        IF gs_out-rdate >= gv_change.
          gs_out-result = '구단가 적용 의심'.
* 실제 인정시간 대신 구단가 금액에서 0.5시간 단위 수를 역산.
          lv_units = gs_out-amount / gs_out-old_step.
          gs_out-estimate = lv_units * gs_out-new_step.
        ELSE.
          gs_out-result = '8월 건 신단가 적용 의심'.
          lv_units = gs_out-amount / gs_out-new_step.
          gs_out-estimate = lv_units * gs_out-old_step.
        ENDIF.
        gs_out-diff_ok = 'Y'.
        gs_out-difference = gs_out-estimate - gs_out-amount.
      ELSE.
        gs_out-result = '확인: 양쪽 배수 불일치'.
        gs_out-note = '0.5시간 이외 인정시간/휴휴/인상제외/수기보정 확인'.
      ENDIF.
    ENDIF.
* 휴휴 전용 확정 식별자는 확인되지 않았다. JORGEH만으로 단정 금지.
* 기존 정산금액이 있으면 휴휴 또는 기정산 가능성이 있어 자동추정 제외.
    IF gs_source-jorgeh IS NOT INITIAL.
      gs_out-result = '별도확인: 정산금액 존재'.
      gs_out-month_ok = '-'.
      CLEAR: gs_out-diff_ok, gs_out-estimate, gs_out-difference.
      gs_out-note = '휴휴 사전계산/기정산 가능. 배수 결과는 참고만 사용'.
    ENDIF.
    IF gs_source-rdate <> gs_source-znal.
      gs_out-note = '원천일/근무일 다름: RDATE 기준 검사. 익일 원천 연결 확인'.
    ENDIF.
    APPEND gs_out TO gt_out.
  ENDLOOP.
ENDFORM.

FORM check_multiple USING p_amount TYPE ty_money
                          p_step TYPE ty_money
                    CHANGING p_ok TYPE c.
  DATA: lv_ratio TYPE ty_number,
        lv_units TYPE ty_number,
        lv_back TYPE ty_money.
  p_ok = 'N'.
  lv_ratio = p_amount / p_step.
  lv_units = trunc( lv_ratio ).
  lv_back = lv_units * p_step.
  IF lv_units > 0 AND lv_back = p_amount.
    p_ok = 'Y'.
  ENDIF.
ENDFORM.

FORM add_column USING p_field TYPE slis_fieldname
                      p_text TYPE scrtext_l
                      p_length TYPE i.
  CLEAR gs_fcat.
  gs_fcat-fieldname = p_field.
  gs_fcat-seltext_l = p_text.
  gs_fcat-seltext_m = p_text.
  gs_fcat-seltext_s = p_text.
  gs_fcat-outputlen = p_length.
  IF p_field = 'AMOUNT' OR p_field = 'SETTLE'
     OR p_field = 'ESTIMATE' OR p_field = 'DIFFERENCE'
     OR p_field = 'OLD_RATE' OR p_field = 'NEW_RATE'
     OR p_field = 'OLD_STEP' OR p_field = 'NEW_STEP'.
* 통화 참조 없이 실제 원 단위 숫자를 표시. KRW 추가 배율 적용 금지.
    gs_fcat-datatype = 'DEC'.
    gs_fcat-decimals_out = 2.
    gs_fcat-no_zero = 'X'.
  ENDIF.
  APPEND gs_fcat TO gt_fcat.
ENDFORM.

FORM display_data.
  PERFORM add_column USING 'PERNR' '사번' 10.
  PERFORM add_column USING 'RDATE' '기준 근무시작일' 12.
  PERFORM add_column USING 'ZNAL' '저장 근무일' 12.
  PERFORM add_column USING 'ZDDAY' '대휴발생일' 12.
  PERFORM add_column USING 'SEQNR' '순번' 5.
  PERFORM add_column USING 'SUBTY' '하위유형' 8.
  PERFORM add_column USING 'BEGDA' '키 시작일' 12.
  PERFORM add_column USING 'ENDDA' '키 종료일' 12.
  PERFORM add_column USING 'ZGUBUN' '입력구분' 8.
  PERFORM add_column USING 'ZSOURFLEX' '대휴생성구분' 10.
  PERFORM add_column USING 'ZD_TIME' '저장 인정시간(참고)' 15.
  PERFORM add_column USING 'ZTOMO' '익일여부' 8.
  PERFORM add_column USING 'PERSK' '기준일 PERSK' 12.
  PERFORM add_column USING 'RATE_GROUP' '적용 단가그룹' 24.
  PERFORM add_column USING 'OLD_RATE' '8월 시간외 단가(원)' 20.
  PERFORM add_column USING 'NEW_RATE' '9월 시간외 단가(원)' 20.
  PERFORM add_column USING 'OLD_STEP' '8월 반시간 검사단위(원)' 22.
  PERFORM add_column USING 'NEW_STEP' '9월 반시간 검사단위(원)' 22.
  PERFORM add_column USING 'AMOUNT' '대휴 실비 금액(원)' 18.
  PERFORM add_column USING 'OLD_OK' '구단가 배수 Y/N' 14.
  PERFORM add_column USING 'NEW_OK' '신단가 배수 Y/N' 14.
  PERFORM add_column USING 'MONTH_OK' '기준월 일치 Y/N/-' 16.
  PERFORM add_column USING 'RESULT' '판정(정확성 확정 아님)' 32.
  PERFORM add_column USING 'DIFF_OK' '추정차액 산출 Y' 14.
  PERFORM add_column USING 'ESTIMATE' '단가 전환 추정금액(원)' 22.
  PERFORM add_column USING 'DIFFERENCE' '추정차액(기대-현재, 원)' 22.
  PERFORM add_column USING 'SETTLE' '기존 대휴정산금액(원)' 22.
  PERFORM add_column USING 'ZDCHK' '사용여부' 8.
  PERFORM add_column USING 'JORGEH_TXT' '정산여부' 8.
  PERFORM add_column USING 'NOTE' '확인사항' 70.
  gs_layout-zebra = 'X'.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      i_grid_title = '대휴 단가 배수 검사: 추정차액은 확정 지급차액이 아닙니다'
      is_layout = gs_layout
      it_fieldcat = gt_fcat
    TABLES
      t_outtab = gt_out
    EXCEPTIONS
      program_error = 1
      OTHERS = 2.
  IF sy-subrc <> 0.
    MESSAGE 'ALV 표시 중 오류가 발생했습니다.' TYPE 'S'
      DISPLAY LIKE 'E'.
  ENDIF.
ENDFORM.
