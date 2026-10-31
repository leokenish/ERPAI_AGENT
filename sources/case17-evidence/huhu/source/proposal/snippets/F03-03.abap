* 대휴 상세는 같은 계산 행을 한 번만 반환한다.
* 두 조건이 모두 맞아도 APPEND는 한 번만 실행한다.
    IF ls_result-zdaeh EQ 'X' OR lv_ngt EQ 'Y'.
      APPEND ls_result TO pt_zdaeh.
    ENDIF.

* 신청 전체의 정산금액을 원래 계산 행에서 합산한다.
* 대휴 상세에 포함되지 않은 다른 날짜의 기여분도 더한다.
* 뒤의 기존 반올림 및 * 100 반환 처리는 그대로 사용한다.
    ADD ls_result-zjorgehamt TO lv_zjorgehamt.
