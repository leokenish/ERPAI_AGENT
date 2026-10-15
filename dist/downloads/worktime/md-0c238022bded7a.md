---
tags: [간주근무, 교대근무, 근로시간알림, 근무현황조회, 기준정보유지보수, 대휴익휴보상휴가, 선택근무, 시간외단가등급, 월정산전표지급, 인사정보형9021_9023, 자료복사결재보정, 재량근무, 탄력근무, 통상시차시간외, 통합결재, 퇴직자관리자입력검토, 특별연장재난방송, 휴가공가반차]
---

# ZTHRBS01 — 미추출 의존

[소스 목차](INDEX.md) · [외부 의존 전체 목록](EXTERNAL_DEPENDENCIES.md)
확인 수준: **참조 구문 확인 / 본체 미추출**. 이 객체의 원본 본문·정의 파일은 현재 추출물에서 확인하지 못했다. 아래는 이 객체를 호출하거나 참조하는 **호출측 원본 파일**이다. 소유 패키지·운영 존재/사용·실행 성공을 추정하지 않는다.

## 참조와 후속 처리 탐색

데이터 조회/저장 행을 이용해 생산자·소비자를 찾을 수 있다. 동일 객체를 읽고 쓴다는 사실은 자동 실행 순서나 외래키를 입증하지 않는다.

| 참조 소스 설명 | 관계 | 근거 파일·위치 |
|---|---|---|
| [LZHR008_1F00](LZHR008_1F00.md) | 데이터 저장 | [LZHR008_1F00.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Include/LZHR008_1F00.abap) L73, 109, 111, 3559, 3609, 3611 |
| [LZHR008_1F00](LZHR008_1F00.md) | 데이터 조회 | [LZHR008_1F00.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Include/LZHR008_1F00.abap) L12, 65, 84, 128, 3483, 3551, 3570, 3628 |
| [LZHR008_2F03](LZHR008_2F03.md) | 데이터 조회 | [LZHR008_2F03.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap) L624, 1043, 2183, 2266, 4041, 4669, 4677, 6242 |
| [LZHR008_2F04](LZHR008_2F04.md) | 데이터 조회 | [LZHR008_2F04.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F04.abap) L545, 553, 907, 941, 1134, 1409, 1454, 1613, 1621, 1880, 1914 |
| [LZHR008_2F05](LZHR008_2F05.md) | 데이터 조회 | [LZHR008_2F05.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F05.abap) L112, 125 |
| [LZHR008_2F06](LZHR008_2F06.md) | 데이터 조회 | [LZHR008_2F06.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F06.abap) L941 |
| [LZHR008_3F03](LZHR008_3F03.md) | 데이터 저장 | [LZHR008_3F03.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap) L668 |
| [LZHR008_3F03](LZHR008_3F03.md) | 데이터 조회 | [LZHR008_3F03.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F03.abap) L644 |
| [MZH4110F01](MZH4110F01.md) | 데이터 저장 | [MZH4110F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110F01/source/MZH4110F01.abap) L2196 |
| [MZH4110F01](MZH4110F01.md) | 데이터 조회 | [MZH4110F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH4110F01/source/MZH4110F01.abap) L270, 1332 |
| [ZHR_52TM_APPROVAL_LIST](ZHR_52TM_APPROVAL_LIST.md) | 데이터 조회 | [ZHR_52TM_APPROVAL_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_LIST/Source%20code/ZHR_52TM_APPROVAL_LIST.abap) L175 |
| [ZHR_52TM_APPROVAL_OT_DETAIL](ZHR_52TM_APPROVAL_OT_DETAIL.md) | 데이터 조회 | [ZHR_52TM_APPROVAL_OT_DETAIL.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVAL_OT_DETAIL/Source%20code/ZHR_52TM_APPROVAL_OT_DETAIL.abap) L33 |
| [ZHR_52TM_APPROVE_OT_DATA](ZHR_52TM_APPROVE_OT_DATA.md) | 데이터 저장 | [ZHR_52TM_APPROVE_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_OT_DATA/Source%20code/ZHR_52TM_APPROVE_OT_DATA.abap) L392 |
| [ZHR_52TM_APPROVE_OT_DATA](ZHR_52TM_APPROVE_OT_DATA.md) | 데이터 조회 | [ZHR_52TM_APPROVE_OT_DATA.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_OT_DATA/Source%20code/ZHR_52TM_APPROVE_OT_DATA.abap) L284 |
| [ZHR_52TM_AWART_LIST](ZHR_52TM_AWART_LIST.md) | 데이터 조회 | [ZHR_52TM_AWART_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_AWART_LIST/Source%20code/ZHR_52TM_AWART_LIST.abap) L279 |
| [ZHR_52TM_CHECK_HOLIDAY_ZDAEH](ZHR_52TM_CHECK_HOLIDAY_ZDAEH.md) | 데이터 저장 | [ZHR_52TM_CHECK_HOLIDAY_ZDAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Source%20code/ZHR_52TM_CHECK_HOLIDAY_ZDAEH.abap) L125 |
| [ZHR_52TM_CHECK_HOLIDAY_ZDAEH](ZHR_52TM_CHECK_HOLIDAY_ZDAEH.md) | 데이터 조회 | [ZHR_52TM_CHECK_HOLIDAY_ZDAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_HOLIDAY_ZDAEH/Source%20code/ZHR_52TM_CHECK_HOLIDAY_ZDAEH.abap) L104 |
| [ZHR_52TM_CHECK_INPUT_DATA](ZHR_52TM_CHECK_INPUT_DATA.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA/Import.xml) L113 |
| [ZHR_52TM_CHECK_INPUT_DATA_M](ZHR_52TM_CHECK_INPUT_DATA_M.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_INPUT_DATA_M/Import.xml) L113 |
| [ZHR_52TM_CHECK_ZDAEH](ZHR_52TM_CHECK_ZDAEH.md) | 데이터 조회 | [ZHR_52TM_CHECK_ZDAEH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_ZDAEH/Source%20code/ZHR_52TM_CHECK_ZDAEH.abap) L105, 135 |
| [ZHR_52TM_CHECK_ZDAEH](ZHR_52TM_CHECK_ZDAEH.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_ZDAEH/Import.xml) L29 |
| [ZHR_52TM_CHECK_ZEMCWK](ZHR_52TM_CHECK_ZEMCWK.md) | 데이터 조회 | [ZHR_52TM_CHECK_ZEMCWK.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_CHECK_ZEMCWK/Source%20code/ZHR_52TM_CHECK_ZEMCWK.abap) L142 |
| [ZHR_52TM_GET_OVERTIME_DATA](ZHR_52TM_GET_OVERTIME_DATA.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DATA/Import.xml) L113 |
| [ZHR_52TM_GET_OVERTIME_DELETE](ZHR_52TM_GET_OVERTIME_DELETE.md) | 데이터 저장 | [ZHR_52TM_GET_OVERTIME_DELETE.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DELETE/Source%20code/ZHR_52TM_GET_OVERTIME_DELETE.abap) L30, 35 |
| [ZHR_52TM_GET_OVERTIME_DELETE](ZHR_52TM_GET_OVERTIME_DELETE.md) | 타입 참조 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_DELETE/Tables.xml) L9 |
| [ZHR_52TM_GET_OVERTIME_LIST](ZHR_52TM_GET_OVERTIME_LIST.md) | 데이터 조회 | [ZHR_52TM_GET_OVERTIME_LIST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_LIST/Source%20code/ZHR_52TM_GET_OVERTIME_LIST.abap) L126 |
| [ZHR_52TM_GET_OVERTIME_LIST](ZHR_52TM_GET_OVERTIME_LIST.md) | 타입 참조 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_LIST/Tables.xml) L9 |
| [ZHR_52TM_GET_OVERTIME_REQUEST](ZHR_52TM_GET_OVERTIME_REQUEST.md) | 데이터 저장 | [ZHR_52TM_GET_OVERTIME_REQUEST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_REQUEST/Source%20code/ZHR_52TM_GET_OVERTIME_REQUEST.abap) L108 |
| [ZHR_52TM_GET_OVERTIME_REQUEST](ZHR_52TM_GET_OVERTIME_REQUEST.md) | 데이터 조회 | [ZHR_52TM_GET_OVERTIME_REQUEST.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_REQUEST/Source%20code/ZHR_52TM_GET_OVERTIME_REQUEST.abap) L97 |
| [ZHR_52TM_GET_OVERTIME_REQUEST](ZHR_52TM_GET_OVERTIME_REQUEST.md) | 타입 참조 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_REQUEST/Tables.xml) L9 |
| [ZHR_52TM_GET_OVERTIME_RETURN](ZHR_52TM_GET_OVERTIME_RETURN.md) | 데이터 저장 | [ZHR_52TM_GET_OVERTIME_RETURN.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_RETURN/Source%20code/ZHR_52TM_GET_OVERTIME_RETURN.abap) L43 |
| [ZHR_52TM_GET_OVERTIME_RETURN](ZHR_52TM_GET_OVERTIME_RETURN.md) | 타입 참조 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_RETURN/Tables.xml) L9 |
| [ZHR_52TM_GET_OVERTIME_SAVE](ZHR_52TM_GET_OVERTIME_SAVE.md) | 데이터 저장 | [ZHR_52TM_GET_OVERTIME_SAVE.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Source%20code/ZHR_52TM_GET_OVERTIME_SAVE.abap) L97, 277 |
| [ZHR_52TM_GET_OVERTIME_SAVE](ZHR_52TM_GET_OVERTIME_SAVE.md) | 데이터 조회 | [ZHR_52TM_GET_OVERTIME_SAVE.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Source%20code/ZHR_52TM_GET_OVERTIME_SAVE.abap) L89 |
| [ZHR_52TM_GET_OVERTIME_SAVE](ZHR_52TM_GET_OVERTIME_SAVE.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Import.xml) L113 |
| [ZHR_52TM_GET_OVERTIME_SAVE](ZHR_52TM_GET_OVERTIME_SAVE.md) | 타입 참조 | [Tables.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_OVERTIME_SAVE/Tables.xml) L9 |
| [ZHR_52TM_GET_PERSONNEL_DATA_N](ZHR_52TM_GET_PERSONNEL_DATA_N.md) | 타입 참조 | [Export.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_GET_PERSONNEL_DATA_N/Export.xml) L12 |
| [ZHR_52TM_MOBILE_OVERTIME_APPR](ZHR_52TM_MOBILE_OVERTIME_APPR.md) | 데이터 저장 | [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L223, 313 |
| [ZHR_52TM_MOBILE_OVERTIME_APPR](ZHR_52TM_MOBILE_OVERTIME_APPR.md) | 데이터 조회 | [ZHR_52TM_MOBILE_OVERTIME_APPR.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_APPR/Source%20code/ZHR_52TM_MOBILE_OVERTIME_APPR.abap) L42, 135 |
| [ZHR_52TM_MOBILE_OVERTIME_CHANG](ZHR_52TM_MOBILE_OVERTIME_CHANG.md) | 데이터 조회 | [ZHR_52TM_MOBILE_OVERTIME_CHANG.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MOBILE_OVERTIME_CHANG/Source%20code/ZHR_52TM_MOBILE_OVERTIME_CHANG.abap) L27 |
| [ZHR_52TM_MONTHLY_PAYMENT](ZHR_52TM_MONTHLY_PAYMENT.md) | 데이터 조회 | [ZHR_52TM_MONTHLY_PAYMENT.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_MONTHLY_PAYMENT/Source%20code/ZHR_52TM_MONTHLY_PAYMENT.abap) L443 |
| [ZHR_52TM_NEW_ORDINARY_TIME](ZHR_52TM_NEW_ORDINARY_TIME.md) | 데이터 조회 | [ZHR_52TM_NEW_ORDINARY_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_ORDINARY_TIME/Source%20code/ZHR_52TM_NEW_ORDINARY_TIME.abap) L47, 56, 100, 241 |
| [ZHR_52TM_NEW_ORDINARY_TIME](ZHR_52TM_NEW_ORDINARY_TIME.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_ORDINARY_TIME/Import.xml) L15 |
| [ZHR_52TM_NEW_ORDINARY_TIME2](ZHR_52TM_NEW_ORDINARY_TIME2.md) | 데이터 조회 | [ZHR_52TM_NEW_ORDINARY_TIME2.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_ORDINARY_TIME2/Source%20code/ZHR_52TM_NEW_ORDINARY_TIME2.abap) L43 |
| [ZHR_52TM_NEW_ORDINARY_TIME2](ZHR_52TM_NEW_ORDINARY_TIME2.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_ORDINARY_TIME2/Import.xml) L15 |
| [ZHR_52TM_NEW_SHIFTWORK_TIME](ZHR_52TM_NEW_SHIFTWORK_TIME.md) | 데이터 조회 | [ZHR_52TM_NEW_SHIFTWORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_SHIFTWORK_TIME/Source%20code/ZHR_52TM_NEW_SHIFTWORK_TIME.abap) L140 |
| [ZHR_52TM_NEW_SHIFTWORK_TIME](ZHR_52TM_NEW_SHIFTWORK_TIME.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_NEW_SHIFTWORK_TIME/Import.xml) L15 |
| [ZHR_52TM_ORDINARY_ZE_TIME](ZHR_52TM_ORDINARY_ZE_TIME.md) | 데이터 조회 | [ZHR_52TM_ORDINARY_ZE_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_ORDINARY_ZE_TIME/Source%20code/ZHR_52TM_ORDINARY_ZE_TIME.abap) L46, 55, 105, 218, 295, 434 |
| [ZHR_52TM_ORDINARY_ZE_TIME](ZHR_52TM_ORDINARY_ZE_TIME.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_ORDINARY_ZE_TIME/Import.xml) L15 |
| [ZHR_52TM_ORDINARY_ZE_TIME2](ZHR_52TM_ORDINARY_ZE_TIME2.md) | 데이터 조회 | [ZHR_52TM_ORDINARY_ZE_TIME2.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_ORDINARY_ZE_TIME2/Source%20code/ZHR_52TM_ORDINARY_ZE_TIME2.abap) L36, 43 |
| [ZHR_52TM_ORDINARY_ZE_TIME2](ZHR_52TM_ORDINARY_ZE_TIME2.md) | 타입 참조 | [Import.xml](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_ORDINARY_ZE_TIME2/Import.xml) L15 |
| [ZHR_52TM_OT_DATA_BY_MONTH](ZHR_52TM_OT_DATA_BY_MONTH.md) | 데이터 조회 | [ZHR_52TM_OT_DATA_BY_MONTH.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_OT_DATA_BY_MONTH/Source%20code/ZHR_52TM_OT_DATA_BY_MONTH.abap) L84, 216 |
| [ZHR_52TM_PERSONAL_WORK_TIME](ZHR_52TM_PERSONAL_WORK_TIME.md) | 데이터 조회 | [ZHR_52TM_PERSONAL_WORK_TIME.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_PERSONAL_WORK_TIME/Source%20code/ZHR_52TM_PERSONAL_WORK_TIME.abap) L174, 303 |
| [ZHR_52TM_WEEKLY_ZEMCWK](ZHR_52TM_WEEKLY_ZEMCWK.md) | 데이터 조회 | [ZHR_52TM_WEEKLY_ZEMCWK.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_WEEKLY_ZEMCWK/Source%20code/ZHR_52TM_WEEKLY_ZEMCWK.abap) L97 |
| [ZRPTH403](ZRPTH403.md) | 데이터 조회 | [ZRPTH403.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH403/source/ZRPTH403.abap) L83 |
| [ZRPTH406F01](ZRPTH406F01.md) | 데이터 조회 | [ZRPTH406F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH406F01/source/ZRPTH406F01.abap) L513 |
| [ZRPTH409F01](ZRPTH409F01.md) | 데이터 저장 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L1077, 1079, 1164, 1437, 1439 |
| [ZRPTH409F01](ZRPTH409F01.md) | 데이터 조회 | [ZRPTH409F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH409F01/source/ZRPTH409F01.abap) L266, 995, 1016, 1150, 1356, 1376 |
| [ZRPTH410F01](ZRPTH410F01.md) | 데이터 저장 | [ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap) L1301 |
| [ZRPTH410F01](ZRPTH410F01.md) | 데이터 조회 | [ZRPTH410F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH410F01/source/ZRPTH410F01.abap) L1234, 1346 |
| [ZRPTH414](ZRPTH414.md) | 데이터 저장 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L2687, 2892 |
| [ZRPTH414](ZRPTH414.md) | 데이터 조회 | [ZRPTH414.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH414/source/ZRPTH414.abap) L2620, 2636, 2877 |
| [ZRPTH415F01](ZRPTH415F01.md) | 데이터 저장 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L1460, 1658 |
| [ZRPTH415F01](ZRPTH415F01.md) | 데이터 조회 | [ZRPTH415F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH415F01/source/ZRPTH415F01.abap) L121, 594 |
| [ZRPTH419F01](ZRPTH419F01.md) | 데이터 저장 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L955, 1090 |
| [ZRPTH419F01](ZRPTH419F01.md) | 데이터 조회 | [ZRPTH419F01.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH419F01/source/ZRPTH419F01.abap) L213, 437, 876, 893, 1075 |
| [ZRPTH441](ZRPTH441.md) | 데이터 조회 | [ZRPTH441.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH441/source/ZRPTH441.abap) L626 |
| [ZRPTH_ZTHRBS01_COPY](ZRPTH_ZTHRBS01_COPY.md) | 데이터 저장 | [ZRPTH_ZTHRBS01_COPY.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH_ZTHRBS01_COPY/source/ZRPTH_ZTHRBS01_COPY.abap) L88 |
| [ZRPTH_ZTHRBS01_COPY](ZRPTH_ZTHRBS01_COPY.md) | 데이터 조회 | [ZRPTH_ZTHRBS01_COPY.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTH_ZTHRBS01_COPY/source/ZRPTH_ZTHRBS01_COPY.abap) L26 |
| [ZRPTMP003_BATCH](ZRPTMP003_BATCH.md) | 데이터 조회 | [ZRPTMP003_BATCH.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTMP003_BATCH/source/ZRPTMP003_BATCH.abap) L33 |
| [ZRPTMP003_M](ZRPTMP003_M.md) | 데이터 조회 | [ZRPTMP003_M.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZRPTMP003_M/source/ZRPTMP003_M.abap) L31 |
| [ZSHR0130](ZSHR0130.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0130/definition.xml) L74 |
| [ZSHR0132](ZSHR0132.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0132/definition.xml) L74 |
| [ZSHR0134](ZSHR0134.md) | 타입 참조 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Structures/ZSHR0134/definition.xml) L74 |
| [ZTHRBS01V](ZTHRBS01V.md) | 뷰 구성 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/VIEW/ZTHRBS01V/definition.xml) L53, 66, 114, 162, 210, 258, 306, 354, 404 |
| [ZTHR_WEEK_TIME](ZTHR_WEEK_TIME.md) | 데이터 조회 | [ZTHR_WEEK_TIME.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/ZTHR_WEEK_TIME/source/ZTHR_WEEK_TIME.abap) L34 |
| [ZVHRBS01](ZVHRBS01.md) | 뷰 구성 | [definition.xml](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/VIEW/ZVHRBS01/definition.xml) L53, 66, 114, 162, 210, 258, 306, 354, 402, 450, 498, 546, 594, 642, 690, 740, 755 |

## 관련 업무

- [deemed](../topics/deemed.md) — 참조/업무 단계 선정 근거는 지도 표 참조.
- [discretionary](../topics/discretionary.md) — 참조/업무 단계 선정 근거는 지도 표 참조.
- [leave](../topics/leave.md) — 참조/업무 단계 선정 근거는 지도 표 참조.
- [maintenance](../topics/maintenance.md) — 참조/업무 단계 선정 근거는 지도 표 참조.
- [ordinary](../topics/ordinary.md) — 참조/업무 단계 선정 근거는 지도 표 참조.
- [rest](../topics/rest.md) — 참조/업무 단계 선정 근거는 지도 표 참조.
- [special-extension](../topics/special-extension.md) — 참조/업무 단계 선정 근거는 지도 표 참조.
