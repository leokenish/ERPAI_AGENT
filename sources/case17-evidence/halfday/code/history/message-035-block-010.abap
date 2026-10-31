"저장 할때만 적용
  IF lv_code IS NOT INITIAL.
     e_code = lv_code.
     e_text = lv_text.
  ENDIF.

* 여기에 아래 코드를 추가
