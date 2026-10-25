# WEBGUI 개선과 검증 — 현재 학습 맥락

기존 업무 기능을 보존하며 결재 본문·다운로드·팝업·스크롤을 실제 오류 근거로 개선합니다.

V429 / UI 4.2.6 / 결재 렌더러 1.4.5 구현. 특정 화면·다운로드의 사용자 확인과 최신 SAP 재시험을 구분합니다.

사용자 요청 113개 · AI 본문 135개 · 본문 미확보 3곳

2026-10-24 공유 화면의 실제 사용자·AI 최종 본문을 수집했습니다. 요약·추정 답변으로 대체하지 않았습니다. 확보하지 못한 최종 답변은 원래 위치에 표시합니다. 교육용 문체와 해설은 원문과 분리합니다.

## 새로 읽을 순서

- [설정 API의 실제 응답과 호출 경로 확정](#/conversations/kbs-erp-webgui-refactor/wg-progress-approval-api-observed)
- [입력 화면 생략과 전체 본문 확보 방식을 결정하기](#/conversations/kbs-erp-webgui-refactor/wg-progress-approval-entry-and-document-scope)
- [첫 구현을 실제 프레임·이미지·설정 계약에 맞추기](#/conversations/kbs-erp-webgui-refactor/wg-progress-approval-first-engine-runtime-contract)
- [오류명을 추측하지 않고 남은 실행 기록을 확보하기](#/conversations/kbs-erp-webgui-refactor/wg-progress-approval-diagnostic-capture-and-stability)
- [새 본문 안에서 기존 ERP 기능을 유지하고 대상 확대하기](#/conversations/kbs-erp-webgui-refactor/wg-progress-approval-native-actions-and-generalization)
- [공통 UI 개선에서 화면 증거와 업로더 계약을 함께 확인하기](#/conversations/kbs-erp-webgui-refactor/wg-progress-common-ui-and-package-contracts)
- [반복되는 겹침 오류를 본문 변경·경계선·실행 버전으로 나누기](#/conversations/kbs-erp-webgui-refactor/wg-progress-overlap-evidence-and-version-verification)
- [긴 대화를 재개 가능한 통합 명세로 남기기](#/conversations/kbs-erp-webgui-refactor/wg-progress-handoff-spec-checkpoint)
- [새 아이콘보다 사용자가 익힌 의미를 보존하기](#/conversations/kbs-erp-webgui-refactor/wg-progress-icon-familiarity-over-redesign)
- [unload 경고를 다운로드 실패와 분리해 시험하기](#/conversations/kbs-erp-webgui-refactor/wg-progress-unload-hypothesis-and-lifecycle-test)
- [실제 파일 저장 응답으로 Applet 의존을 확인하기](#/conversations/kbs-erp-webgui-refactor/wg-progress-download-applet-root-cause)
- [공통 다운로드 브리지를 실제 세션·불리언 계약에 맞추기](#/conversations/kbs-erp-webgui-refactor/wg-progress-download-bridge-runtime-contracts)
- [새 기능 뒤 재발한 오류를 별도 모듈과 경계 조건으로 분리하기](#/conversations/kbs-erp-webgui-refactor/wg-progress-overlap-narrow-window-regression)
- [다운로드의 제한된 성공 뒤 공통 크기 계산을 다시 점검하기](#/conversations/kbs-erp-webgui-refactor/wg-progress-download-one-menu-and-layout-feedback)
- [최신 UI 수정과 ZIP 무결성을 배포 단계에서 확인하기](#/conversations/kbs-erp-webgui-refactor/wg-progress-v429-package-reissue)
- [네 MD의 인계 역할과 insight의 철학적 기준을 확정하기](#/conversations/kbs-erp-webgui-refactor/wg-progress-four-md-and-philosophical-insight)

## 이전 수록 시점의 맥락

# KBS ERP WebGUI·SYSTEMGUI AI 리팩토링 과정 — 추가 확보 자료

2026-10-16 공유 화면의 사용자 요청 7개·AI 응답 본문 7개를 추가 확보했습니다. 본문이 표시되지 않은 AI 위치 0곳을 별도로 표시합니다.

- https://chatgpt.com/share/e/6ad166b7-5f20-83ee-9c53-c85cd2c03276

본문은 공유 화면의 DOM을 Markdown으로 전사했습니다. 서식·UI 버튼은 정리했으며 코드 본문은 보존했습니다. 원문 JSON·Markdown과 서명 URL을 제거한 DOM 기록을 별도로 보존합니다. 화면의 교육용 경어체는 원문을 바꾸지 않는 별도 표시층입니다.

## 확인 범위

기존 ITS Chrome v3(2026-09-14)와 새 Modern V2는 서로 다른 대화·산출물 계열입니다. 새 대화의 ALV 비교·적용 도구는 검토 단계이며 DIAG를 쓰기 도구로 바꾸지 않았습니다.


## 2026-10-17 추가 흐름

공유 대화의 후속 20쌍과 실제 이미지 8개를 연결했습니다. ITS 도구 1.0.1~1.0.9 수정, 첫 파일 적용 보고, 106개 완료·107번 D 불일치 보고, 재추출 V3 19개 변경안, 결재 화면 판별·설정 테이블·RFC·JSON 파싱을 이어서 읽습니다.

XLSX 원본 6개는 이번 다운로드 미확보입니다. ZIP은 요청에 따라 수집하지 않았습니다. 기존 경로와 대화는 유지합니다.
