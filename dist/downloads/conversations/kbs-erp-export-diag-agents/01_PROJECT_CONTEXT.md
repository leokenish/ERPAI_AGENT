# 소스 추출·진단과 업무 에이전트 — 현재 학습 맥락

SAP 소스와 업무 근거를 연결하고, 비교·검사에서 지원 웹자산의 선택 저장·활성화로 확장합니다.

Export 0.4.1 / DIAG 0.7.1 소스 확보. 0.6.11의 기존 I 버전 재사용·활성화·SE80는 사용자 확인, 최신 0.7.1 SAP 실행은 미확인입니다.

사용자 요청 153개 · AI 본문 149개 · 본문 미확보 4곳

2026-10-24 공유 화면의 실제 사용자·AI 최종 본문을 수집했습니다. 요약·추정 답변으로 대체하지 않았습니다. 확보하지 못한 최종 답변은 원래 위치에 표시합니다. 교육용 문체와 해설은 원문과 분리합니다.

## 새로 읽을 순서

- [새 계정으로 업무맥락을 옮기고 검증의 출발점을 정하다](#/conversations/kbs-erp-export-diag-agents/E19-handover)
- [WEBGUI의 반영 경험을 DIAG의 웹자산 범위로 옮기다](#/conversations/kbs-erp-export-diag-agents/E20-webapply-review)
- [첫 MIME 반영본에서 버튼과 BSP 지원의 간격을 발견하다](#/conversations/kbs-erp-export-diag-agents/E21-mime-implementation)
- [BSP Layout 저장과 단일 페이지 활성화로 범위를 넓히다](#/conversations/kbs-erp-export-diag-agents/E22-bsp-layout)
- [BASIS 700의 실제 타입과 페이지 표현을 오류로 맞춰가다](#/conversations/kbs-erp-export-diag-agents/E23-basis700-compatibility)
- [다른 페이지 작업을 막는 제한을 좁히고 CTS 절차를 드러내다](#/conversations/kbs-erp-export-diag-agents/E24-inactive-scope-cts)
- [저장 후 비교 방식과 다음 대화의 재개 근거를 정리하다](#/conversations/kbs-erp-export-diag-agents/E25-save-verification-handover)
- [실제 ZIP으로 XML 선언 가정을 버리고 SO2 Layout을 확인하다](#/conversations/kbs-erp-export-diag-agents/E26-so2-layout-evidence)
- [저장된 미활성본을 검증하고 활성화만 재개하도록 고치다](#/conversations/kbs-erp-export-diag-agents/E27-activation-resume)
- [BSP 활성화와 SE80 반영을 확인하고 한 앱 추출을 요청하다](#/conversations/kbs-erp-export-diag-agents/E28-confirmed-bsp-next-scope)
- [BSP 한 앱 모드와 단일 앱 폴더를 두 REPORT에 맞추다](#/conversations/kbs-erp-export-diag-agents/E29-single-app-zip)
- [네 MD에 목적·요구·현재 근거와 재개 위치를 담다](#/conversations/kbs-erp-export-diag-agents/E30-context-four-md)
- [통찰을 존재 이유의 성찰로 다시 쓰고 포털용 자료로 묶다](#/conversations/kbs-erp-export-diag-agents/E31-insight-portal-package)

## 이전 수록 시점의 맥락

# 프로젝트 맥락과 학습 순서

## 시작 목적과 환경

패키지 단위 SAP 소스를 외부로 추출하여 VS Code·AI로 분석·수정하고 Git으로 관리하려는 목적에서 시작했습니다. 최초 요청에는 Z_PACKAGE_EXPORT와 Z_PACKAGE_IMPORT, 검사·저장·활성화·CTS까지 포함됐습니다. 실제 환경은 ECC 6.0 / SAP_BASIS 700이며 초기 확인에는 SP0041, Unicode, Windows 11, PowerShell·Python 미설치 조건이 등장합니다.

## 학습의 네 전환점

1. 환경 진단과 첫 추출기: API와 언어·소스 읽기·내부 INCLUDE 범위를 실행 결과로 수정했습니다.
2. 다양한 패키지와 웹 자산: ZFI1·ZBUDGET·ZMM6·ZCO3·ZWEB에서 BSP·MIME, 파일명, 인코딩, 폴더 규칙과 제외 정책을 구체화했습니다.
3. 업무 에이전트: GitHub Publish와 Mac Clone 뒤에 코드만으로 부족한 규정·카카오톡·매뉴얼을 업무 지식과 스킬로 분리하고 담당자 피드백을 문서로 남겼습니다.
4. 읽기 전용 DIAG: 비교·활성 근거·문법검사·리포트 해석을 다듬다가 자동 Import·활성화를 제외하고 진단으로 목표를 좁혔습니다.

## 현재 확인 범위

이번 통합은 실제 대화 본문 확보에 관한 업데이트입니다. Export 0.3.18·DIAG 0.4.5 확보 소스의 현재 운영 성공을 새로 검증한 것은 아닙니다. 과거 AI의 “수정했습니다”, 사용자의 실행 결과 보고, 현재 포털에 남은 파일 근거를 구분합니다. 초기의 자동 반영 목표와 최종 읽기 전용 결정은 동일하지 않습니다.

## 대화 확보

공유 화면의 요청 119개·AI 응답 본문 116개를 순서대로 배치했습니다. 응답이 표시되지 않은 13·89·90번째 대화는 별도 안내입니다. 최초 27개 대화쌍을 네 개의 시작 에피소드에 추가하고, 기존 E01~E18 주소는 유지했습니다. 사용자 말풍선은 정중한 교육용 문장이며 AI 본문은 전문입니다. 원문 확인 UI는 제공하지 않고 원천 파일은 보존합니다.

## 학습 방법

구성도에서 SAP·Export를 선택해 처음부터 시작하거나 GitHub·Codex·업무 지식·DIAG·피드백 요소에서 관련 대화로 이동합니다. 각 에피소드에서 대화 기록 → 해설·시행착오 → 따라 하기 순서로 읽고, 자기 업무에 맞는 요청·실행 결과·검증 기준을 작성합니다.
