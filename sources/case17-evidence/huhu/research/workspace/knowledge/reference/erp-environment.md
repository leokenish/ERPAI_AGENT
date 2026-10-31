---
document_id: erp-environment
source_ids: [SRC-22]
as_of: 2026-10-27
effective_from: null
review_status: pending_business_review
---

# ERP 환경과 코딩 기준

## 환경

| 항목 | 정보 | 확인 수준 |
|---|---|---|
| 제품 | SAP ECC 6.0 | 이전 사용자 제공 정보: [기존 기록](../hr/overview.md) |
| Enhancement Package | EHP 0 | SRC-22 사용자 확인, 2026-10-27 |
| SAP_BASIS | 700 | [현재 manifest](../../exports/ZHR5/manifest.xml) HEADER 및 사용자 필수 지침 |
| DB | Oracle | SRC-22 사용자 확인, 2026-10-27; 상세 버전 미확인 |
| 서버 OS | Linux | SRC-22 사용자 확인, 2026-10-27; 배포판·상세 버전 미확인 |
| Support Package | SAP_BASIS 700 SP0041 | manifest의 화면 캡처 근거 기록; 도구 실측 아님 |

사용자 발화일은 설치일·업그레이드일이 아니다. EHP·DB·OS는 SAP 접속으로 독립 검증하지 않았다. 기존 KSD 분석 기록 및 현재 KSP/300 추출 metadata와 사용자 설명을 구별한다.

## 코딩 필수 기준

2026-10-27 사용자 지시로 이 저장소의 모든 ABAP 신규 작성·수정·리팩토링·예제·변경 제안에 적용한다.

1. 반드시 SAP_BASIS 700 호환 문법·기능을 사용한다. 상위 버전 전용 기능은 사용하지 않으며, 불확실한 부분은 확인 필요로 남긴다.
2. 반드시 초급 개발자가 이해할 수 있도록 작성한다. 명확한 이름과 단순한 처리 순서, 적절한 역할별 FORM 분리, 업무 목적과 흐름을 설명하는 한글 주석을 사용하고 불필요한 추상화·중첩·축약을 피한다.

제출 전 두 기준을 검토한다. 로컬 검사 통과가 SAP 구문 검사·실행·활성화 완료를 뜻하지 않는다. 실행 지침 원본은 [AGENTS.md](../../AGENTS.md)의 ‘ERP 환경 및 코딩 필수 지침’이다.

## 출처

SRC-22, 2026-10-27 현재 대화 사용자 발화 전체: “EHP 버전은 0이야. db는 오라클이고 서버는 리눅스야.” 및 SAP_BASIS 700 기반·초급 개발자도 이해하기 쉬운 ABAP 코딩을 반드시 지키도록 반영하라는 지시. [출처 등록부](../../docs/SOURCE_REGISTER.md). 별도 파일·해시·원문 페이지/줄 없음. 사용자 지시는 직접 확인했으며 AI 정리문은 검토 대기다.
