# EXPORT

## 추출의 목적

SE80의 지원 객체를 AI와 Git이 읽을 수 있는 파일로 바꿉니다. ABAP 본문, 함수 인터페이스, DDIC 정의, BSP·MIME의 대응 관계를 함께 확인합니다.

대상 환경은 원천 기록상 **ECC 6.0 / SAP_BASIS 700 Unicode / Oracle / SAP GUI 770**입니다. 실제 대상 시스템의 패치와 권한은 실행 전에 확인합니다.

## 요청과 응답으로 따라가기

[첫 추출기 제작 대화](#/conversations/kbs-erp-export-diag-agents/E00-export)에서는 파일 무결성 검사와 SAP 소스 읽기 오류를 구분한 과정을 볼 수 있습니다. [다른 패키지로 확대한 대화](#/conversations/kbs-erp-export-diag-agents/E00-web)에서는 BSP·MIME 누락과 반복되는 SORT 오류를 어떻게 지적하고 수정했는지 확인합니다. 이어 [SAP 화면에 맞춘 파일 구조](#/conversations/kbs-erp-export-diag-agents/E01)에서 실제 요청과 AI 답변을 한 쌍씩 읽어보세요.

## 확보한 도구 기준

| 도구 | 확보 버전 | 역할 |
|---|---|---|
| Z_PACKAGE_EXPORT | 0.3.18 | 지원 객체 파일화 |
| DEVHUB_CHECK | 0.3.3 | 로컬 추출물 무결성·로그 확인 |
| Z_PACKAGE_DIAG | 0.4.5 | 추출본·원본·현재 SAP 비교 |
| manifest | 0.2 | 파일과 객체의 대응 정보 |

도구 소스는 `sources/export-diag/attachments/`에 있습니다. DIAG 입력에는 해당 추출 도구로 만든 ZIP을 사용합니다.

## 추출물에서 먼저 찾을 것

| 자료 | 확인할 내용 |
|---|---|
| manifest·catalog | 선택 패키지, 객체 식별, 파일 대응 |
| 로그 | 실패·생략·미지원의 구분 |
| 프로그램·함수 본문 | 실제 ABAP 소스와 소유 관계 |
| Dictionary Object | DB 테이블과 Structures의 구분 |
| BSP Application | 페이지 이름·레이아웃·실제 이벤트 이름 |
| MIME | 원래 자산과 metadata의 대응 |
| `.devhub/baseline` | 추출 시점 원문 사본 |

baseline은 추출 시점 원문으로 보존하고, 작업 파일과 분리합니다.

## 범위와 제한을 먼저 확인하기

- 대상: 선택 패키지와 하위 패키지의 지원 개발 객체.
- 범위 밖: 업무 테이블 데이터 행. 외부 참조 본문은 일부 제한.
- 클래스 본문 지원: 현행 가이드에 명시 없음.
- 언어: KO 우선, 항목별 조건에 따라 EN 보완.
- 용량: 파일당 16 MiB, 전체 비압축 512 MiB.
- 시점: 객체별 순차 추출. 객체 간 시점 차이는 별도 확인.

## 따라 하기: 첫 추출물 확인

1. 담당자가 개발 환경에서 도구 버전과 지원 범위를 확인합니다.
2. 대상 패키지 ZIP을 풀고 manifest와 로그부터 읽습니다.
3. 함수 하나를 골라 인터페이스 XML, 함수 본문, Include 연결을 확인합니다.
4. BSP가 있으면 실제 페이지명과 이벤트 이름이 SE80과 대응하는지 확인합니다.
5. 실패·생략·미지원 항목을 기록한 뒤 Git에 관리할 기준본을 정합니다.

확보·실패·생략·미지원 항목과 파일 경로를 설명할 수 있으면 첫 점검이 끝납니다.

## Codex에 요청할 문장

```text
이 추출 폴더의 manifest, catalog, 로그, 가이드를 먼저 읽어줘.
지원 객체와 누락·생략·미지원 범위를 구분하고,
함수 한 개와 BSP 페이지 한 개의 실제 파일 경로를 찾아줘.
baseline과 추출 원본은 수정하지 말고 읽은 파일을 근거로 적어줘.
```

## 근거

- `sources/export-diag/01_프로젝트_맥락과설계.md` §3·5·8
- `sources/export-diag/references/DEVHUB_EXPORT_GUIDE.md`
- [진단 결과를 읽는 과정](#/learn/diagnosis)
