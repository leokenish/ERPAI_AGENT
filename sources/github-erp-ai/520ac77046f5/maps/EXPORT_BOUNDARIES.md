# 미추출·미지원·외부 의존 경계

[전체 목차](INDEX.md) · [분석 범위](COVERAGE.md)

## 현재 추출본

근거: [manifest](../exports/ZHR5/manifest.xml) HEADER 및 FILES, [catalog](../exports/ZHR5/catalog/objects.xml) OBJECTS/item.

| 항목 | 확인값 |
|---|---|
| COMPLETENESS | `PARTIAL` |
| DEPENDENCY_POLICY | `REFERENCE_ONLY_EXTERNAL` |
| DEPENDENCY_COVERAGE | `OWNED_FUGR_INCLUDE_WALK_PARTIAL` |
| CAPABILITY | `ANALYSIS_ONLY` |
| SYSID | `KSD` |
| CLIENT | `300` |
| BASIS | `700` |
| TOOL_VERSION | `0.3.18` |

추출 날짜는 기존 overview의 2026-09-21 기록을 따르되 현재 logs/run.xml 부재로 직접 재검증하지 못했다. manifest의 각 ACTIVE_STATE와 API 버전 상태가 다를 수 있으며 모든 파일을 운영 활성본으로 확정하지 않는다.

## Catalog에 있으나 내용이 부족한 객체

미지원/실패/제외 상태의 객체는 이름이 존재한다는 것만 확인한다. 아래 진단 이유를 원인 확정·복구 완료로 바꾸지 않는다.

| 유형 | 객체 | 추출 상태 | 원문 이유 |
|---|---|---|
| CLAS | `ZCL_APP_ZEP002_IT_E` | UNSUPPORTED | Class source not exported; reference diagnostics off |
| CLAS | `ZCL_HRPA_INFOTYPE_9021` | UNSUPPORTED | Class source not exported; reference diagnostics off |
| CLAS | `ZCL_HRPA_INFOTYPE_9023` | UNSUPPORTED | Class source not exported; reference diagnostics off |
| DEVC | `ZHR5` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| DIAL | `RP_9021` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| DIAL | `RP_9023` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| NROB | `ZHR_N11` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| SHI3 | `ZHR52` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| SICF | `Z52_FLEX_TIME  907RM5PM0WS1BRG2HAYGJYC1N` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| SMIM | `5BB028588DAE67D9E10000000A002438` | EXCLUDED | BSP application ZEP0002 belongs to unselected package ZEP1 ; MIME content excluded; reference only |
| SMIM | `5BD6DBE7454D51B7E10000000A002438` | EXCLUDED | BSP application ZMOBILE_COMMON belongs to unselected package ZMOBILE ; MIME content excluded; reference only |
| SMIM | `5C1C05554A724660E10000000A002438` | EXCLUDED | BSP application ZEP0002 belongs to unselected package ZEP1 ; MIME content excluded; reference only |
| TABL | `ZHCMT_BSP_PA_XX_R9023` | FAILED | DDIC active read failed; LANG=E SUBRC=0            GOTSTATE=  |
| TOBJ | `ZTHRBS01V V` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TOBJ | `ZTHRBS16  S` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TOBJ | `ZVHR0101  V` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TOBJ | `ZVHR0102  V` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TOBJ | `ZVHR0103  V` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TOBJ | `ZVHR0104  V` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TOBJ | `ZVHR0105  V` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TOBJ | `ZVHR0122  V` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TOBJ | `ZVHR0123  V` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TOBJ | `ZVHR0125  V` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TOBJ | `ZVHR0126  V` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TOBJ | `ZVHR0127  V` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TOBJ | `ZVHR0128  V` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TOBJ | `ZVHR0129  V` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TOBJ | `ZVHR0130  V` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TOBJ | `ZVHR0131  V` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TOBJ | `ZVHR0150  V` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TOBJ | `ZVHRBS01  V` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TOBJ | `ZVPA2010  V` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZDEL01` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZH2012` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZH4110` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZH432_M` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZHR003` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZRH401` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZRH402` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZRH403` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZRH404` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZRH405` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZRH406` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZRH407` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZRH408` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZRH409` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZRH410` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZRH411` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZRH412` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZRH413` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZRH414` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZRH415` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZRH419` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZRH422` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZRH440` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZRH441` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZRH480` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZVBS01` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZVH0101` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZVH0102` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZVH0103` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZVH0104` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZVH0105` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZVH0123` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZVH0125` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZVH0126` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZVH0127` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZVH0128` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZVH0129` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZVH0130` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZVH0131` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZVH0150` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZVHBS13` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZVHBS16` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZVHBS17` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |
| TRAN | `ZVPA2010` | UNSUPPORTED | Cataloged; serializer not implemented in 0.3.18 |

## 핵심 미추출 경계

- 웹: ZWEB_COMMON/AJAX_COMMON.HTM, server_util 계열과 외부 로그인/권한·결재 요청 함수. FUNCTION_NAME 문자열 전송에서 실제 dispatcher 구현으로 이어지는 부분은 미확인.
- 결재: ZWF_START_WORK_HR/DELETE/APPROVE_WORK/REJECT_WORK, 통상 승인 함수 ZHR_APPROVE_OT_DATA. 승인 순서·메일·잠금·커밋 구현을 추정하지 않는다.
- 인사/급여/FI: HR_INFOTYPE_OPERATION, 인사등급/출장/교대 함수, ZBDC, ZFI_FIRM_REQUEST_EDI. 호출 흔적은 운영 지급/송신 성공의 증거가 아니다.
- 데이터: ZTHRBS01, PA2010, ZWF0022, ZTHRCOST 등은 참조는 확인되나 정의가 이 패키지 추출에 없다. 외부 소유 개발클래스를 이름으로 추정하지 않는다.
- BSP 이벤트 파일 11개는 원문을 대조한 결과 공백/주석만 있다. 의미 있는 서버 이벤트 구현을 검토한 것으로 집계하지 않는다. Layout의 인라인 JS와 페이지 script는 별도 색인했다.
- 프로그램의 헤더 Transaction과 catalog TRAN 44개 이름만으로 실제 트랜잭션→프로그램 연결을 확정하지 않는다. Dynpro 화면 flow logic·GUI status·클래스 구현은 추가 자료가 필요하다.
[객체별 미추출 참조와 호출 근거](sources/EXTERNAL_DEPENDENCIES.md) · [미해결 FORM·외부 웹 참조 전체](audit/unresolved-static.json)

## 현재 없는 원문·로그

SRC-01~04 PDF 및 SRC-05~11 TXT 원문 11개, logs/run.xml과 logs/processing.xml 파일 2개가 현재 없다. 기존 Markdown에서는 이 13개 파일로 가는 링크 14건이 남아 있다. 파일을 만들거나 기존 문서를 임의로 고치지 않았다.
SRC-12/13/14 피드백은 기존 harness와 정리본에서 탐색한다. 담당자 완료보고·사용자 정책 확인·실제 소스/실행 검증은 별개로 유지한다.
