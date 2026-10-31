---
document_id: LOCAL-ZHR5-OVERTIME-20261022
source_ids: [SRC-17, SRC-18]
as_of: 2026-10-22
effective_from: null
review_status: pending_business_review
implementation_status: local_applied_sap_unverified
---
# 시간외 입력 조건 통일 — 로컬 소스 반영

**2026-10-22 사용자 요청에 따라 검토한 두 구간을 `exports/ZHR5/packages/`에 반영했다. SAP 구문 검사·실행·활성화·운영 반영은 수행하지 않았다.** SRC-17은 수정 전 SAP 추출 사실이고, SRC-18은 사용자 전달 기준·확인·로컬 반영 요청이다. 요청 기준의 효력일·소급 범위와 공식 시행 문서는 미제공이다.

## 요청 기준

통상·선택에 동일하게 적용하도록 전달받은 목표 기준이다. 아래 전체 기준이 모든 화면·상태·저장 경로에서 구현·검증됐다는 뜻은 아니다.

| 항목 | 요청 결과 | 이번 처리와 확인 범위 |
|---|---|---|
| 자녀돌봄(종일) | 입력불가 | 반일 43/44만 허용 목록에 넣음. 종일의 실제 세부 코드 미확인 |
| 공가(공무상 출장) | 입력불가 | 일반검진 반일 28/29만 허용 목록에 넣음. 공무상 출장 세부 코드 미확인 |
| 해외출장 간주근로 | 입력불가 | 기존 간주 차단 유지. 이번 수정에서 출장 조회·상태 조건은 변경하지 않음 |
| 일반연차(오전반차) | 입력가능 | GUNART 10 / GUNTYPE 13, 선택 AWART 1013 |
| 일반연차(오후반차) | 입력가능 | GUNART 10 / GUNTYPE 15, 선택 AWART 1015 |
| 일반 해외출장 | 입력가능 | 기존 선택 AWART 0002 조건 유지. 통상 별도 출장 경로 실행 미검증 |
| 자녀돌봄(오전) | 입력가능 | GUNART 30 / GUNTYPE 43·44 묶음, 선택 AWART 0030 |
| 자녀돌봄(오후) | 입력가능 | 위와 동일. 각 번호의 오전/오후 개별 명칭은 운영 마스터 대조 필요 |
| 일반검진(오전) | 입력가능 | GUNART 40 / GUNTYPE 28·29 묶음, 선택 AWART 0040 |
| 일반검진(오후) | 입력가능 | 위와 동일. 각 번호의 오전/오후 개별 명칭은 운영 마스터 대조 필요 |

근태·출장 값의 변환 근거: SRC-17 `ZHR_52TM_AWART_LIST` L168–181, L194–230, L374–393. 입력 허용 조건과 인정근로시간·소정시간·실비 계산은 별개이며 AWART_LIST 산식은 이번에 수정하지 않았다.

## 실제 반영 구간

| 대상 | 현재 로컬 소스 | 변경 전 범위 | 반영 내용 |
|---|---|---|---|
| 통상·시차 CHECK_ABSENCE_DATA | [LZHR008_2F03](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Include/LZHR008_2F03.abap) L2063–2078 | L2063–2072 | GUNART/GUNTYPE 조합 10/13·15, 30/43·44, 40/28·29를 차단 대상 SELECT에서 제외. P_ZGUBUN=1/A/B 분기에 적용 |
| 선택 B_CW_CHECK_DATA | [LZHR008_3F01](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_3/Include/LZHR008_3F01.abap) L204–227 | L204–227 | AWART/GUNTYPE로 자녀돌봄·일반검진 반일 허용 추가. READ TABLE 한 행 검사를 LOOP로 변경 |

선택은 해당 날짜의 **조회 결과에 포함된 모든 행**을 검사해, 허용 행과 차단 행이 함께 조회되면 차단한다. 앞단 L174의 승인상태·근태구분 필터나 AWART_LIST의 휴일 제거를 변경하지 않았으므로 모든 원천 근태가 이 반복에 들어온다고 표현하지 않는다.

통상 평일·달력·ZTHRBS08 조건은 현재 L2134–2161, 변경·삭제 원건 제거는 L2098–2109다. 선택의 후속 간주 M04(L229–235)·출제위원 M26(L237–248)은 유지된다. AWART 0001/0002/9998의 기존 M06 제외와 최종 입력 허용은 구별한다. K_CW_CHECK_DATA와 신규/수정/상신 본체는 이번 범위에 포함하지 않았다.

## 판본 보존과 다음 교체

- 수정 전 사본: [통상 원본](../../proposals/20261022-overtime-attendance/originals/LZHR008_2F03.abap), [선택 원본](../../proposals/20261022-overtime-attendance/originals/LZHR008_3F01.abap). SRC-17 원본 해시와 일치한다.
- 적용한 변경: [패치](../../proposals/20261022-overtime-attendance/changes.patch). [통상 수정본](../../proposals/20261022-overtime-attendance/LZHR008_2F03.abap)·[선택 수정본](../../proposals/20261022-overtime-attendance/LZHR008_3F01.abap)과 현재 exports 파일은 바이트가 같다.
- 공유 자료: [코드 복사 HTML](../../proposals/20261022-overtime-attendance/ZHR5_시간외_입력조건_변경안_공유.html).
- 추출 당시 manifest·catalog·로그·baseline·EXPORT-20261022 해시 장부는 유지한다. 현재 두 파일과 추출 체크섬이 다른 것은 기록된 로컬 수정이며, 이를 새 SAP 추출·배포 증거로 바꾸지 않는다.
- 새 export 교체 시 이 사본과 패치를 exports 밖에 보관하고 **수정 전 / 로컬 수정 후 / 새 SAP 추출본**을 비교한다. 동일 내용 반영 여부·충돌·정책 변경을 먼저 확인하며 이전 패치를 자동 재적용하지 않는다. [유지보수 절차](../../docs/KNOWLEDGE_MAINTENANCE.md).

## 검증과 남은 작업

[수정안 검증 및 로컬 적용 기록](../../proposals/20261022-overtime-attendance/verification.json)은 전후 SHA-256, 조건식 14개 정적 대조, 패치 사전 확인과 로컬 적용 후 역방향 패치 검사를 구분한다. 기존 `source_unchanged`는 적용 전 검증 시점의 기록이다. 현재 상태는 `local_application`을 읽는다. [이번 반영 검증](../../maps/audit/LOCAL-20261022-overtime-validation.json).

요청 10개 항목, 복수 근태, 승인/결재중/변경/취소·취소신청 반려, 평일·휴일·예외, PC·모바일·관리자, 신규·수정·상신을 SAP에서 확인해야 한다. 선택 LZHR008_3F03의 S/U/A 재검사와 PROCESS_DATA2의 오류 후 처리, 실적 선입력→근태 신청·승인 및 동시 처리 과제는 미완료다. 코드 조건식 대조를 SAP 실행 검증이나 업무 전체 통일 완료로 답하지 않는다.
