---
title: "HR 정보형 9021·9023 화면·구조"
as_of: 2026-10-07
review_status: pending_business_review
tags: [인사정보형9021_9023]
---

# HR 정보형 9021·9023 화면·구조

<!-- atlas:auto:start -->

## 전체 범위 단계 지도

[전체 업무 진행 상태](../PROGRESS.md) · [소스 설명 목차](../sources/INDEX.md)
정보형 모듈풀과 Include, PA 테이블, DDIC 구조/도메인 연결을 포함한다. 생성 화면/클래스 본체의 공백을 명시한다.
**완료 범위:** 아래 단계의 지정 소스 구간·직접 관계 확인 및 탐색 연결. 전체 업무 규칙·모든 분기 검토 완료를 뜻하지 않는다. 적용 시점은 추출본이며 운영 반영일 미확인. 기존 문서에 있는 정책/과거 검토안의 구분을 유지한다.

| 단계 | 관련 설명 문서 | 관계의 의미 | 근거 파일·코드 위치 | 수준 |
|---|---|---|---|---|
| 9021 모듈풀 구성 | [MP902100](../sources/MP902100.md) · [MP902110](../sources/MP902110.md) · [MP902130](../sources/MP902130.md) · [MP902150](../sources/MP902150.md) | MP902100의 10/20/30/40/50 Include는 코드 포함 관계이다. | [MP902100.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MP902100/source/MP902100.abap) L2, 7, 10 (Include) | 확인: 지정 구간의 정적 관계 |
| 9023 모듈풀 구성 | [MP902300](../sources/MP902300.md) · [MP902310](../sources/MP902310.md) · [MP902330](../sources/MP902330.md) · [MP902350](../sources/MP902350.md) | MP902300도 별도 정보형 Include를 가진다. | [MP902300.abap](../../exports/ZHR5/packages/ZHR5/programs/PROG/MP902300/source/MP902300.abap) L2, 7, 10 (Include) | 확인: 지정 구간의 정적 관계 |
| 자료형·업무 처리 연결 | [PA9021](../sources/PA9021.md) · [PA9023](../sources/PA9023.md) · [ZD52WKTP1](../sources/ZD52WKTP1.md) · [ZHR_52TM_APPROVE_OT_DATA](../sources/ZHR_52TM_APPROVE_OT_DATA.md) · [MZH432I01](../sources/MZH432I01.md) | PA9021은 탄력 승인/재량/선택 등의 공통 데이터, PA9023은 시차 대상관리에서 사용된다. 실제 호출은 각각의 생산자/소비자 표를 따른다. | [PA9021 원본](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/PA9021/definition.xml) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[PA9023 원본](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/PA9023/definition.xml) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[ZD52WKTP1 원본](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/Domain/ZD52WKTP1/definition.xml) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[ZHR_52TM_APPROVE_OT_DATA 원본](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_2/Function%20Module/ZHR_52TM_APPROVE_OT_DATA/Source%20code/ZHR_52TM_APPROVE_OT_DATA.abap) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[MZH432I01 원본](../../exports/ZHR5/packages/ZHR5/programs/PROG/MZH432I01/source/MZH432I01.abap) — 파일 존재/헤더/정적 색인; 업무군 선정 | 분석상 연관·후보; 직접 호출 근거 아님 |

### 이 업무의 미추출·미검토 경계

CLAS ZCL_HRPA_INFOTYPE_9021/9023 본문 미지원, 화면 flow logic·권한 미추출. ZHCMT_BSP_PA_XX_R9023 정상 정의 추출 실패.
화면 요청/직접 호출/Include/타입 참조/데이터 조회·저장/분석상 연관을 구분했다. 화면이 없거나 중계기·함수가 미추출이면 연결을 그 지점에서 멈춘다. 저장은 승인·지급·배포 완료의 동의어가 아니다.

<!-- atlas:auto:end -->
