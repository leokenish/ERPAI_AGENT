# SAP 추출 객체 사전

이 파일은 AI가 파일 종류와 분석 역할을 구분하기 위한 안내다. 특정 객체의 업무 의미는 실제 정의와 호출처로 확인한다.

| 종류 | 무엇을 담는가 | 먼저 확인할 것 / 주의 |
|---|---|---|
| 개발클래스/패키지 | 개발 객체의 소속 단위 | 업무 영역과 1:1이라고 가정하지 않음 |
| Function Group | 함수 모듈을 묶는 프로그램 단위 | 그룹 공통 선언과 Include 의존성 |
| Function Module | 입력/출력 인터페이스와 ABAP 처리 | Import/Export/Changing/Tables/Exception, 호출 조건 |
| Include | 다른 프로그램에 포함되는 ABAP 소스 | 단독 실행 프로그램과 구분, 실제 소유권/포함 관계 |
| Program | ABAP 실행/모듈풀 등의 소스 | 유형, 화면, 텍스트 풀, 활성 상태 |
| DBtable | DB 테이블의 정의 | 필드·키·참조. 추출 XML에 업무 레코드가 있다는 뜻 아님 |
| Structure | 필드를 묶은 구조 타입 | 물리 DB 행 저장소와 구별 |
| TableType | 내부 테이블 타입 정의 | 행 타입, STANDARD/SORTED/HASHED 및 키 |
| Data element | 의미/설명을 붙인 타입 정의 | 도메인·라벨과 실제 프로그램 사용처 |
| Domain | 기술 속성·값 범위 등 | 고정값만으로 모든 업무 검증을 설명하지 않음 |
| BSP Application | ABAP 웹 애플리케이션 | Layout, Event Handler, Page Attributes, Properties 연결 |
| Properties.xml | BSP 페이지 설정 | 구현 클래스 이름은 실제 클래스 소스 존재 증거 아님 |
| Page Attributes.xml | 페이지 속성/파라미터 정의 | 자동 바인딩·타입과 이벤트에서 사용되는 방식 |
| Event Handler | 페이지 이벤트 ABAP | 실제 생성된 OnCreate 등의 파일을 확인. 빈 이벤트를 있다고 만들지 않음 |
| Type Definitions | 페이지 로컬 타입 정의 | 페이지 속성과의 타입 연결 |
| MIME | JS/CSS/이미지/폰트/문서 등 자산 | JS는 동작, CSS는 표현, 이미지는 시각 근거. 모두 같은 비중으로 읽지 않음 |
| MessageClass | 번호로 관리되는 메시지 문구 | 번호 앞의0, &1 등 자리표시자 유지. Long Text는 별도 범위 |
| Class | ABAP 객체지향 구현 단위 | 이 추출기 안내상 본문 미지원. 참조만으로 동작 추론 금지 |
| manifest/catalog/log | 추출 대상·파일·처리 상태 | 성공·부분·생략·미지원을 구분 |

## 업무 이해에 도움이 되는 읽기 순서
업무 질문 → 사용자 화면/매뉴얼 → 이벤트/함수 → 인터페이스·테이블 구조 → 메시지/예외.
CSS·이미지·폰트는 화면 차이가 질문에 영향을 줄 때 읽는다. 모든 XML을 항상 통째로 넣지 않는다.
