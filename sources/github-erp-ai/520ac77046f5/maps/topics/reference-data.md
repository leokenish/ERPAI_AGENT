---
title: "기준정보·뷰·테이블 유지보수"
as_of: 2026-10-07
review_status: pending_business_review
tags: [기준정보유지보수]
---

# 기준정보·뷰·테이블 유지보수

<!-- atlas:auto:start -->

## 전체 범위 단계 지도

[전체 업무 진행 상태](../PROGRESS.md) · [소스 설명 목차](../sources/INDEX.md)
생성형 VIEWFRAME/VIEWPROC, 공통 F00 저장, DDIC 뷰/테이블의 관계를 확인한다. 근무 상수·계획 기본값·재량 대상/수당/대휴·기타 유지보수는 같은 공통 소스를 참조한다.
**완료 범위:** 아래 단계의 지정 소스 구간·직접 관계 확인 및 탐색 연결. 전체 업무 규칙·모든 분기 검토 완료를 뜻하지 않는다. 적용 시점은 추출본이며 운영 반영일 미확인. 기존 문서에 있는 정책/과거 검토안의 구분을 유지한다.

| 단계 | 관련 설명 문서 | 관계의 의미 | 근거 파일·코드 위치 | 수준 |
|---|---|---|---|---|
| 유지보수 진입 | [VIEWFRAME_ZVHR0101](../sources/VIEWFRAME_ZVHR0101.md) · [VIEWPROC_ZVHR0101](../sources/VIEWPROC_ZVHR0101.md) · [VIEWFRAME_ZVHR0128](../sources/VIEWFRAME_ZVHR0128.md) · [VIEWPROC_ZVHR0128](../sources/VIEWPROC_ZVHR0128.md) | VIEWFRAME는 VIEWPROC를 정적 호출한다. 그 아래 생성형 FORM의 동적 분기와 실제 SM30/메뉴 진입은 별도 미확인이다. | [VIEWFRAME_ZVHR0101.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0101/Source%20code/VIEWFRAME_ZVHR0101.abap) L17, 49, 98, 137, 181 (직접 호출)<br>[VIEWFRAME_ZVHR0128.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Function%20Module/VIEWFRAME_ZVHR0128/Source%20code/VIEWFRAME_ZVHR0128.abap) L17, 49, 98, 137, 181 (직접 호출) | 확인: 지정 구간의 정적 관계 |
| 상수·계획 기본값 저장 | [LZHR008_1F00](../sources/LZHR008_1F00.md) · [ZTHR0101](../sources/ZTHR0101.md) · [ZTHR0105](../sources/ZTHR0105.md) | LZHR008_1F00의 테이블별 생성형 DB_UPD FORM에서 갱신 구문 확인. | [LZHR008_1F00.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Include/LZHR008_1F00.abap) L253, 289, 291, 998, 1055, 1057 (데이터 저장) | 확인: 지정 구간의 정적 관계 |
| 재량 기준표 저장 | [LZHR008_1F00](../sources/LZHR008_1F00.md) · [ZTHR0125](../sources/ZTHR0125.md) · [ZTHR0128](../sources/ZTHR0128.md) · [ZTHR0129](../sources/ZTHR0129.md) | 공통 유지보수 Include가 대상·수당·대휴 설정을 각각 저장한다. | [LZHR008_1F00.abap](../../exports/ZHR5/packages/ZHR5/function-groups/FUGR/ZHR008_1/Include/LZHR008_1F00.abap) L1695, 1729, 1731, 2219, 2261, 2263, 2517, 2559, 2561 (데이터 저장) | 확인: 지정 구간의 정적 관계 |
| 전체 설정 객체 후보 | [ZVHR0101](../sources/ZVHR0101.md) · [ZVHR0128](../sources/ZVHR0128.md) · [ZTHRBS16](../sources/ZTHRBS16.md) · [ZTHR0150](../sources/ZTHR0150.md) | 나머지 18개 뷰와 40개 DB 정의는 소스 목차에서 전부 탐색할 수 있다. 각 정의의 읽기/쓰기 역링크로 적용 업무를 찾되 미사용/승인된 설정으로 추정하지 않는다. | [ZVHR0101 원본](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/VIEW/ZVHR0101/definition.xml) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[ZVHR0128 원본](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/VIEW/ZVHR0128/definition.xml) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[ZTHRBS16 원본](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHRBS16/definition.xml) — 파일 존재/헤더/정적 색인; 업무군 선정<br>[ZTHR0150 원본](../../exports/ZHR5/packages/ZHR5/Dictionary%20Object/DBtable/ZTHR0150/definition.xml) — 파일 존재/헤더/정적 색인; 업무군 선정 | 분석상 연관·후보; 직접 호출 근거 아님 |

### 이 업무의 미추출·미검토 경계

SM30/트랜잭션·권한·TOBJ 정의와 운영 설정값·변경 승인 여부는 미추출/미확인. 생성형 FORM 동적 디스패치는 일부 미해결.
화면 요청/직접 호출/Include/타입 참조/데이터 조회·저장/분석상 연관을 구분했다. 화면이 없거나 중계기·함수가 미추출이면 연결을 그 지점에서 멈춘다. 저장은 승인·지급·배포 완료의 동의어가 아니다.

<!-- atlas:auto:end -->
