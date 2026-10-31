      c_zdaeh          = c_zdaeh.    " 대휴

* 계산 오류일 때는 기존 오류 코드와 문구를 호출자에게 돌려준다.
* 실패한 계산값을 새 정산금액으로 저장하지 않는다.
  IF lv_code+0(1) EQ 'E'.
    e_code = lv_code.
    e_text = lv_text.
    RETURN.
  ENDIF.

  MOVE-CORRESPONDING is_zthrbs01 TO ls_zthrbs01.
