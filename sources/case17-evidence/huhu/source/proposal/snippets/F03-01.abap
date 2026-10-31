* 이번 호출에서 반환할 대휴 상세와 정산금액을 초기화한다.
* 정산금액 전달에 사용하던 임시 DB용 변수는 삭제한다.
  REFRESH pt_zdaeh.
  CLEAR lv_zjorgehamt.

  CLEAR: p_zemcwk_o, p_ztoich_o, p_ztomoh_o, p_zdaeh_o.
