IF g_code+0(1) = 'E'.
  e_return-type = c_error.
  e_return-message = g_text.
  RETURN.
ELSEIF g_code+0(1) = 'I'.
  e_return-type = c_success.
  e_return-message = g_text.
ENDIF.
