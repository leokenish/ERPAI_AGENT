*---------------------------------------------------------------------*
* 2. LZHR008_2F06
* 아래 FORM을 추가한다.
*
* 목적: 통상근무자의 반일 근태 안내 문구를 만든다.
* 입력시간·계산결과·오류코드는 변경하지 않는다.
*---------------------------------------------------------------------*
FORM get_halfday_start_notice
  USING    p_pernr TYPE pernr_d
           p_datum TYPE datum
           p_zgubun TYPE zthrbs01-zgubun
  CHANGING p_notice TYPE char200.

  DATA: lv_halfday TYPE c.

  CLEAR: p_notice, lv_halfday.

* 통상근무만 대상으로 한다.
* 시차·교대·선택·해외출장 등으로 범위를 확대하지 않는다.
  IF p_zgubun <> 'A'.
    RETURN.
  ENDIF.

  PERFORM check_notice_halfday
    USING    p_pernr
             p_datum
    CHANGING lv_halfday.

  IF lv_halfday <> 'X'.
    RETURN.
  ENDIF.

  CONCATENATE
    '반차·반일 근태가 있는 날에도 근무 시작시간은'
    '해당일의 원래 출근시간(자율출근 기준 포함)으로 입력해 주세요.'
    '실제 업무를 시작한 시각부터 입력하면'
    '연장시간과 실비가 적게 계산될 수 있습니다.'
    INTO p_notice
    SEPARATED BY space.

ENDFORM.
