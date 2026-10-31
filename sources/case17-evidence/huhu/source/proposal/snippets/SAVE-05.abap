* F05의 하루별 재계산이 끝난 뒤 정산금액을 최종 설정한다.
* 원래 양일 계산에서 나온 이번 신청의 금액을 사용한다.
    CLEAR ls_zthrbs01-jorgeh.

    IF ls_zdaeh-zdaeh EQ 'X'.
      IF lv_daeh_days EQ 1.
* 실제 대휴가 하나이면 전체 정산금액을 그 대휴에 귀속한다.
        ls_zthrbs01-jorgeh = ls_overtime_data-jorgeh.
      ELSE.
* 대휴가 둘이면 해당 날짜의 합계만 저장한다.
* 상세 금액에는 기존 저장 단위 변환 * 100을 한 번 적용한다.
        ls_zthrbs01-jorgeh = ls_zdaeh-zjorgehamt * 100.
      ENDIF.
    ENDIF.
