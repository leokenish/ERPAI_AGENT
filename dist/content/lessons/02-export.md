# EXPORT

## 추출의 목적

SE80의 지원 객체를 AI와 Git이 읽을 수 있는 파일로 바꿉니다. ABAP 본문, 함수 인터페이스, DDIC 정의, BSP·MIME의 대응 관계를 함께 확인합니다.

대상 환경은 원천 기록상 **ECC 6.0 / SAP_BASIS 700 Unicode / Oracle / SAP GUI 770**입니다. 실제 대상 시스템의 패치와 권한은 실행 전에 확인합니다.

## 요청과 응답으로 따라가기

[첫 추출기 제작 대화](#/conversations/kbs-erp-export-diag-agents/E00-export)에서는 파일 무결성 검사와 SAP 소스 읽기 오류를 구분한 과정을 볼 수 있습니다. [다른 패키지로 확대한 대화](#/conversations/kbs-erp-export-diag-agents/E00-web)에서는 BSP·MIME 누락과 반복되는 SORT 오류를 어떻게 지적하고 수정했는지 확인합니다. 이어 [SAP 화면에 맞춘 파일 구조](#/conversations/kbs-erp-export-diag-agents/E01)에서 실제 요청과 AI 답변을 한 쌍씩 읽어보세요.

## 확보한 도구 기준

| 도구 | 확보 버전 | 역할 |
|---|---|---|
| Z_PACKAGE_EXPORT | 0.4.1 | 개발 패키지 또는 BSP 한 앱 파일화 |
| DEVHUB_CHECK | 0.3.3 | 로컬 추출물 무결성·로그 확인 |
| Z_PACKAGE_DIAG | 0.7.1 | 세 방향 비교와 지원 웹자산 선택 반영 |
| manifest | 패키지 0.3 / BSP 0.4 | 파일·객체·추출 모드 대응. 구형 0.2는 과거 패키지 기준 |

현재 도구는 [최신 BSP 한 앱 추출 대화](#/conversations/kbs-erp-export-diag-agents/E29-single-app-zip)의 관련 자료에서 내려받을 수 있습니다. 기존 `sources/export-diag/attachments/`는 과거 기준본입니다. CHECK 0.3.3의 새 BSP 형식 호환을 가정하지 말고, 해당 manifest와 도구 지원 범위를 확인합니다.

## 추가 흐름: BSP 애플리케이션 한 개 추출

전체 개발 패키지가 아닌 `ZWEB_COMMON` 같은 한 앱을 선택하는 모드가 추가됐습니다. 0.4.1은 여러 소유 패키지 폴더를 만들던 구조를 **한 앱 폴더**로 정리합니다. MIME의 소유 패키지가 다르다고 해당 앱의 실제 자산을 삭제하는 방식이 아닙니다.

| 앱 폴더 안의 자료 | 확인할 역할 |
|---|---|
| `manifest.xml` | 앱·추출 모드·객체 키·파일 경로 |
| `pages/` | Layout 및 다른 탭의 추출·비교·보존 |
| `MIMEs/` | 해당 앱 URL 트리의 자산 |
| `catalog/mime-metadata.xml`, `catalog/web-assets.xml` | MIME 소유권·언어·저장소 대응 |
| `.devhub/baseline/` | 추출 시점 원문, 편집하지 않음 |

Layout 이외 Attributes·Event Handler·Type Definitions는 추출·비교 근거로 보존하지만 현재 업로드 반영 범위는 아닙니다. 최신 0.4.1 소스와 ZIP 형식 근거를 확보했으며 **DIAG 0.7.1의 실제 SAP 비교·반영 성공은 추가 확인**입니다.

[BSP 활성화 확인 후 한 앱 추출로 이어지는 대화](#/conversations/kbs-erp-export-diag-agents/E28-confirmed-bsp-next-scope)

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

- 패키지 모드: 선택 패키지와 하위 패키지의 지원 개발 객체.
- BSP 모드: 선택한 한 앱의 페이지·다른 탭·소속 MIME과 baseline. 외부 공용 자산이나 다른 패키지 전체를 모두 확보했다는 뜻은 아닙니다.
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
