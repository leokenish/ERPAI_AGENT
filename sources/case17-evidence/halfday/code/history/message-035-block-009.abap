* 반일 근태 안내용
  DATA: lt_halfday TYPE TABLE OF zthr0080,
        ls_halfday TYPE zthr0080,
        ls_changed TYPE zthr0080,
        lv_notice_daynr LIKE hrvsched-daynr,
        lv_notice_holiday TYPE c.
