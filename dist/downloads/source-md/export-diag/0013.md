# ZWEB 0.3.17 추출 결과 검토 및 0.3.18 변경

검토일: 2026-09-21. 근거는 첨부 점검 TXT, processing XML, web-assets(7).xml 및 직전 web-assets(6).xml이다. 화면 요약만이 아니라 첨부 목록·처리 로그를 대조했다. 전체 ZWEB ZIP과 실제 파일 본문은 제공되지 않아 독립 재해시·SAP 실행 시험을 한 것은 아니다.

## 결과 판단

요청했던 생략·참고 로그 정책이 적용됐으며, 첨부 점검 결과상 파일 무결성 문제는 없다. 미추출 원인이 해결됐거나 모든 SAP 객체가 완전히 추출됐다는 뜻은 아니다.

| 점검 항목 | 결과 | 해석 |
|---|---:|---|
| 콘텐츠 파일 | 17,142 | 모두 추출 원본 사본과 일치 |
| 변경 / 파일 실패 / 추가 / 고아 사본 | 각 0 | 첨부 점검기 결과 |
| SAP 실패 객체 / 오류 / 미확인 로그 | 각 0 | 현재 수집 범위에서 오류 기록 없음 |
| 생략 객체 / 참고 로그 | 각 19 | MIME URL14 + DDIC 직렬화5 |
| 웹 완료 | 2,637 | BSP 페이지1,256 + MIME 파일1,381 |
| 웹 폴더 | 129 | 파일 완료 수와 별도 집계 |
| 웹 실패 / 미지원 | 각 0 | 목록에 등록된 자산 범위 기준 |
| 전체 객체 | 2,453 | PARTIAL2,364 + UNSUPPORTED68 + SKIPPED19 + EXCLUDED2 |
| 선택 폴더 크기 | 496,989,503바이트 | 473.966MiB, 사본 포함; 압축 ZIP 크기 아님 |

처리 로그209건은 INFO190/WARNING19다. 지정한 MIME URL 오류14건과 DDIC 예외5건만 참고로 남았다. DDIC 생략 대상은 ZHRT004V, ZSPS_PRPS, ZTRIP_ZHRT001, ZTRIP_ZHRT003, ZTRIP_ZHRT004로 이전과 같다. 원인을 조사해 복구한 것이 아니라 합의한 처리 정책이 확인된 것이다. URL 생략14건은 웹 자산 목록 생성 전 빠지므로 웹 실패0과 별개로 생략 수를 봐야 한다.

웹 자산2,766행의 필드 값은 직전0.3.16과 동일했다. 클래스 참조 진단은 제거됐고 웹 참조는 외부 WAPA2 + SMIM7 =9건만 남았다. 참조 감소는 수집 정책 변경이며 의존성이 해소된 것은 아니다. EXCLUDED2도 외부 부모 BSP에 연결된 MIME의 범위 제외이며 비활성 프로그램2개가 아니다.

함수그룹25개, 함수784개(SOURCE404/NEW_SOURCE380), 소유 Include872개, 메시지 ZWEB_MESSAGE_WF18개 완료 로그가 유지된다. A7,789/U9,353에서 U는 활성 버전 미확인이라는 뜻이다. 실제 EN 채택 로그는 없어 영어 보완의 운영 검증이 된 것은 아니다. 전체는 여전히 PARTIAL/ANALYSIS_ONLY다.

## 0.3.18 반영 내용

아래 P는 packages/<실제 소속 패키지>다.

| 기존 | 변경 |
|---|---|
| P/Dictionary Object/DOMA | P/Dictionary Object/Domain |
| P/Dictionary Object/DTEL | P/Dictionary Object/Data element |
| P/mime/SMIM/<LOIO>/content/login_bg.png | P/MIME/image/png/login_bg.png |
| SMIM별 metadata.xml, folder.xml | P/MIME/metadata.xml 하나에 통합 |
| P/mime/W3MI/... | P/MIME/W3MI/... |

BSP 소속 MIME1,306개는 원래 앱 아래 MIMEs 경로를 유지한다. 기존 독립 MIME75개를 MIME_TYPE별로 옮긴다. 이번 목록의 유형별 파일 수는 application/octet-stream61, image/svg+xml5, image/jpeg4, text/css3, image/png2다. application/octet-stream은 API가 반환한 원래 값이며 확장자로 임의 수정하지 않는다.

독립 파일 중 동일 이름 글꼴이3개씩 있는 경우가18묶음 있다. 이름만 보고 삭제하지 않고 충돌하는36개에만 확장자 앞 ~LOIO를 붙인다. 공용 metadata.xml에 원래 URL·LOIO·PHIO·유형·언어·크기·출력 경로를 기록해 원본을 추적한다. 사례: packages/ZWEB/MIME/image/png/login_bg.png. 본문을 갖지 않는 폴더129개도 공용 XML의 폴더 행으로 남긴다.

통합 대상은 SMIM이며 W3MI는 상위 MIME 대문자 변경만 적용한다. 이번 ZWEB에는 W3MI가 없다. 여러 하위 패키지를 포함하면 메타데이터도 소속 패키지별로 분리한다.

SAP 등록 대상과 다른 파일이 동일하다고 가정하면 개별 SMIM XML1,510개가1개로 바뀌어 콘텐츠17,142→15,633개, 사본 등을 포함한 선택 파일34,293→31,275개로 줄어들 것으로 예상된다. 이는 산술 예상이며 0.3.18 실제 실행 수치가 아니다. 큰 바이너리와 원본 사본을 유지하므로 용량이 절반으로 줄어드는 변경은 아니다.

## baseline이 중복인 이유

.devhub/baseline은 의도적으로 저장한 추출 원본이다. 루트 파일을 VS Code에서 수정한 뒤 어느 내용이 바뀌었는지 비교할 때 쓴다. 현재 점검기는 manifest에 등록된 사본을 읽으므로 폴더만 지우면 점검 실패가 난다. 이번 버전은 이 계약을 유지한다.

AI 업무 맥락 분석에는 루트 packages를 사용하고 baseline은 색인에서 제외하는 것이 맞다. 장기적으로는 Git의 최초 추출 commit/tag를 원본 기준으로 사용하면 ZIP 안의 이중 사본을 없앨 수 있다. 그 경우 점검기와 향후 Import의 원본 확보 방식까지 함께 변경해야 한다. 해시만 저장하면 변경 전 본문을 복원할 수 없으며, Git 이력 없이 ZIP 하나만 전달하는 사용 방식도 달라진다. 현재는 제안이며 구현하지 않았다.

## 적용과 검증 경계

DEVHUB_0_3_18.zip의 ABAP 전체를 교체하고 SAP에서 문법검사·활성화한다. 재추출한 ZIP은 새 폴더에 풀고 동봉 점검기로 확인한다. 기존 폴더에 덮어 풀면 DOMA/DTEL/mime/SMIM 등 옛 파일이 남는다.

0.3.18은 v700 구문 분석, 타입 대역 검사, 첨부 식별자 기반 MIME 경로/통합 실행 검사, 실제 점검기 코드의 합성 본문3,897개 비교를 통과했다. SAP700에서의 실제 활성화·API 실행은 아직 미확인이다. 세부 내용은 DEVHUB_0_3_18_VALIDATION.md에 있다.
