*---------------------------------------------------------------------*
* 4. MZH4110F01
* FORM SET_INIT의 기존 DATA 선언부에 추가한다.
*---------------------------------------------------------------------*
  DATA: lv_halfday_notice TYPE char200.

*---------------------------------------------------------------------*
* FORM SET_INIT의 기존 처리 끝, ENDFORM 직전에 추가한다.
* 신청구분이 확정되고 기존 초기화 처리가 완료된 뒤 실행한다.
*
* 관리자 SAP 화면에서는 정보 팝업으로 확인 후 계속 입력한다.
* 이 수정안의 적용 지점은 SET_INIT 진입이며, 기존건 편집 경로가
* SET_INIT을 거치지 않으면 해당 경로에도 별도 연결이 필요하다.
*---------------------------------------------------------------------*
  IF c_error IS INITIAL.

    CLEAR lv_halfday_notice.

* 앞의 SET_DEFAULT_TIME 등 함수 호출로 사용되는 함수그룹의
* 안내 FORM을 호출하여 웹과 동일한 조회·문구를 사용한다.
    PERFORM get_halfday_start_notice
      IN PROGRAM saplzhr008_2
      USING    p_pernr
               p_datum
               cs_record-zgubun
      CHANGING lv_halfday_notice.

    IF lv_halfday_notice IS NOT INITIAL.
      MESSAGE lv_halfday_notice TYPE 'I'.
    ENDIF.

  ENDIF.

*---------------------------------------------------------------------*
* 위 4곳은 원본 미수정 상태의 제안 코드이다.
* SAP_BASIS 700 호환 방식으로 작성했으며 SAP 구문·실행 검증 전이다.
*---------------------------------------------------------------------*
