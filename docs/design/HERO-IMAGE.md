# 화면 모션 SVG 제작 기록

2026-10-12 · v1.5.0 재구성

사용자가 최종 승인한 큰 올리브 나무·주변 화분·사람·컴퓨터 목업에서 배선을 정리한 PNG를 사용한다. 원본 PNG는 docs/design/base/team-screen-approved.png에 보존하며 SVG 안에 한 번만 내장하고 use로 재사용한다. SVG 원본의 메타데이터 버전은 단독 이미지 제작 이력이며 포털 배포 버전과 별개다.

사람·식물·화분·컴퓨터 틀·배선은 변형하지 않는다. 6개 화면 영역의 카드·글자 막대 23개에만 불투명도 애니메이션을 적용한다. 각 화면은 6.2–8.2초의 다른 주기와 시차로 파란 카드 → 글자 막대 → 사라짐을 반복한다.

## 웹 연결

- 자산: assets/images/team-collaboration-animated.svg
- 기본 빌드: npm run build. 이미 완성된 SVG를 사용하므로 Python은 필요 없다.
- 선택적 재생성: python3 scripts/build-hero.py. Pillow·NumPy·SciPy가 필요하다.
- 빌드는 SVG 내부 style과 각 그룹의 --cycle/--delay를 외부 styles.css로 이동한다. 사이트에 삽입되는 SVG에는 inline style이 없다.
- 정지 버튼과 이전 잎 흔들림은 없다. 일반 설정에서 계속 반복하고 OS의 모션 감소 설정에서는 원본 정지 그림을 표시한다.
- site/hero-motion.js는 제목의 한 번 타이핑과 타이머 정리만 담당한다.

래스터 PNG를 보존하는 혼합형 SVG이며 순수 벡터가 아니다. 화면 속 표시는 장식이고 실제 ERP 결과가 아니다. 자동 검사는 원본 바이트, 화면 전용 레이어, 외부 CSS의 타이밍 보존을 확인한다. 실제 브라우저에서의 재생과 Safari는 이번 환경에서 확인하지 못했다.
