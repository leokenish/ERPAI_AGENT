"""Build an offline teaching website from preserved evidence and explicit learning data."""
from pathlib import Path
import html,json,difflib,re
from urllib.parse import quote
from lesson_content import RATE_CASES,SPLIT_CASES,CHANGE_STORIES,TIMELINE,GLOSSARY
OUT=Path(__file__).resolve().parents[1]
def read(p):return (OUT/p).read_text()
def write(p,s):
 f=OUT/p;f.parent.mkdir(parents=True,exist_ok=True);f.write_text(s)
def js(o):return json.dumps(o,ensure_ascii=False).replace('<','\\u003c').replace('>','\\u003e').replace('&','\\u0026')
def esc(s):return html.escape(str(s),quote=True)
def jwrite(p,o):write(p,json.dumps(o,ensure_ascii=False,indent=2)+'\n')
messages=json.loads(read('conversation/messages.json'))['messages']
changes=json.loads(read('source/proposal/changes.json'))
assets=json.loads(read('assets/visuals/index.json'))
links=json.loads(read('conversation/local-link-map.json'))
coverage=json.loads(read('evidence/conversation-coverage.json'))
def refs(nums):return '<div class="refs">'+''.join(f'<a href="transcript.html#M{n:03d}">M{n:03d} 대화</a>' for n in nums)+'</div>'
def figure(id):
 a=next(a for a in assets if a['id']==id)
 return f'<figure class="figure"><img src="{a["svg"]}" alt="{esc(a["title"]+". "+a["description"])}" loading="lazy"><figcaption>{esc(a["description"])}</figcaption><div class="actions"><a href="{a["svg"]}" download>편집 가능한 SVG</a><a href="{a["png"]}" download>PNG 이미지</a></div></figure>'
def page(title,body,extra=''):
 return f'''<!doctype html><html lang="ko"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>{esc(title)} · 휴휴 대휴 AI 사례</title><link rel="stylesheet" href="assets/site.css"></head><body><header class="top"><a href="index.html" class="brand">계산에서 저장까지 <small>AI CASE STUDY / ZHR5</small></a><nav><a href="scenarios.html">그림으로 이해</a><a href="code-review.html">코드와 발견 과정</a><a href="transcript.html">대화 전문</a><a href="files.html">파일·이미지</a></nav></header><main>{body}<footer><span>2026.10.31 · 원본 보존 · 제안 사본 · 담당자 검토 대기</span><span>SAP 구문검사·실행·활성화 미수행</span></footer></main><div id="toast" class="toast" role="status" aria-live="polite"></div>{extra}<script src="assets/site.js"></script></body></html>'''
def hero(kicker,title,lead):return f'<section class="hero"><div class="eyebrow">{kicker}</div><h1>{title}</h1><p class="lead">{lead}</p></section>'

intro=hero('한 사례로 배우는 AI 에이전트 협업','계산은 맞았는데,<br><span class="light">저장된 돈은 왜 달랐을까?</span>','사용자의 업무 기억, AI의 소스 추적, 반복 질문으로 좁힌 오류 후보.<br>휴일 이틀의 대휴 정산 사례를 통해 “계산 → 전달 → 저장”을 구분해 봅니다.')
intro+='<div class="badges"><span class="badge">공개 대화 65개 · 원문 보존</span><span class="badge">두 소스 · 수정 제안 8구간</span><span class="badge">교육 도식 9개 · SVG + PNG</span><span class="badge warn">운영 원인 확정·SAP 수정 완료 아님</span></div>'
intro+='<section class="paper"><div class="section-number">먼저 알아둘 것</div><h2>이 자료는 “AI가 한 번에 정답을 맞힌 이야기”가 아닙니다.</h2><p>사용자의 구체적인 질문으로 AI의 예시와 적용 범위를 바로잡고, 실제 코드로 확인한 것과 아직 실행하지 않은 것을 구분한 사례입니다. 사용자의 오해만을 원인으로 돌리지 않습니다. 발견한 위험도 실제 반기 보정 건의 원인으로 확정하지 않았습니다.</p><div class="grid3"><a class="tile reading-link" href="scenarios.html"><b>01 · 일반인부터</b><h3>달력과 금액 카드</h3><p>0.5배·1.5배, 같은 토요일 두 줄, 남아 있는 임시값을 직접 눌러 봅니다.</p></a><a class="tile reading-link" href="code-review.html"><b>02 · 코드와 연결</b><h3>왜 이 구간을 고쳤나</h3><p>당시 이해 → AI 확인 → 수정 결정 → 전후 코드. 원본·제안의 줄번호를 함께 봅니다.</p></a><a class="tile reading-link" href="transcript.html"><b>03 · 근거로 돌아가기</b><h3>대화 전문과 원본</h3><p>질문·공개 답변·진행 안내까지 그대로 보존했습니다. 후속 정정도 지우지 않습니다.</p></a></div></section>'
intro+='<section class="paper"><div class="section-number">사례의 핵심</div><h2>숫자가 맞아도, 옮기는 과정에서 달라질 수 있습니다.</h2><div class="route"><div class="step"><strong>계산</strong><small>현재 근무조건에 맞는 돈</small></div><span class="arrow">→</span><div class="step"><strong>전달</strong><small>어느 신청·어느 날짜의 돈인가</small></div><span class="arrow">→</span><div class="step"><strong>저장</strong><small>JORGEH에 실제로 넣는 돈</small></div></div><p>기존 임시 DB는 사번·날짜로 금액을 보관했습니다. 이번 제안은 기존 함수가 돌려주는 전체·상세 결과를 사용해, 현재 계산을 같은 저장 호출에 직접 전달합니다. 시간 분할·지급 산식·정산 확정취소는 유지합니다.</p>'+figure('memory')+'</section>'
intro+='<section class="paper"><div class="section-number">협업 과정</div><h2>질문이 바뀔 때마다 확인 범위가 좁아졌습니다.</h2><div class="timeline">'
for t in TIMELINE:intro+=f'<article><h3>{esc(t["title"])}</h3><p>{esc(t["body"])}</p><p class="plain">{esc(t["lesson"])}</p>{refs(t["messages"])}</article>'
intro+='</div></section>'
intro+='<section class="paper"><h2>용어를 일상 언어로 읽기</h2><dl class="glossary">'+''.join(f'<dt>{esc(a)}</dt><dd>{esc(b)}</dd>' for a,b in GLOSSARY)+'</dl></section>'
intro+='<section class="paper"><h2>교육사이트 에이전트에게 넘길 때</h2><p><a href="PORTAL_HANDOFF.md">PORTAL_HANDOFF.md</a>에 권장 구성과 자료별 역할을 적었습니다. <a href="data/case-study.json">기계 판독용 사례 데이터</a>, <a href="conversation/messages.json">원문 메시지 JSON</a>, <a href="data/change-stories.json">수정 구간별 발견 과정</a>를 함께 사용할 수 있습니다.</p><div class="notice">이 방에서 직접 업로드된 사용자 이미지는 0건으로 확인됐습니다. 이전 보고서 캡처 3개와 새 교육 도식 9개는 별도 분류했습니다. 다른 방의 이미지를 이 방의 첨부로 대신 넣지 않았습니다.</div></section>'
write('index.html',page('교육자료 시작',intro))

body=hero('그림으로 이해 · 조건을 바꿔 보는 예시','두 날짜, 세 계산 줄,<br><span class="light">그리고 대휴 한 개 또는 두 개</span>','설명용 단가는 10,000원입니다. 시간은 휴게를 반영한 계산시간이며, 일반 휴휴 분기의 조건부 예시입니다. 시차 B의 별도 산식과 선택 CW에 그대로 적용하지 않습니다.')
body+='<section class="paper" id="rates"><div class="section-number">01 / 요율과 금액</div><h2>먼저 받는 휴일분과 나중에 정산할 돈</h2><p>대휴가 생긴 근무에는 먼저 0.5배를, 대휴가 없는 근무에는 1.5배를 계산하는 경우를 봅니다. 미사용 대휴의 추가 정산은 별도의 금액입니다. 이 둘을 합친 금액 전체를 무조건 두 배로 하면 안 됩니다.</p><div class="controls">'+''.join(f'<button data-rate="{c["id"]}" aria-pressed="false">{c["label"]}</button>' for c in RATE_CASES)+'</div><div class="grid2">'
for i,d in enumerate(['토요일','일요일']):
 body+=f'<article class="calendar {"sun" if i else ""}"><header><strong>{d} · 휴일</strong><span id="leave-{i}"></span></header><div class="content"><div class="hours" id="hours-{i}"></div><div class="hour-strip" id="hour-strip-{i}" aria-label="시간 칸"></div><div class="money-row"><span>먼저 받는 금액의 배율</span><b id="rate-{i}"></b></div><div class="money-row"><span>먼저 받는 휴일분</span><b id="cash-{i}"></b></div><div class="money-row"><span>그 날짜 대휴에 귀속할 추가 정산액</span><b id="settle-{i}"></b></div></div></article>'
body+='</div><div class="grid2" aria-live="polite"><div class="result"><span>추가 대휴 정산 목표 · 대휴 <b id="leave-count"></b></span><div class="big" id="settle-total"></div><p>먼저 받는 휴일분 합계: <span id="cash-total"></span></p></div><div class="result" id="naive-box"><span>휴일분 합계에 단순 ×2를 한다면</span><div class="big" id="naive"></div><p id="naive-note"></p></div></div><p class="plain" id="rate-note"></p><div class="notice">코드의 일반 경계는 계산시간 4.5시간 이상입니다. “출퇴근 5시간 중 휴게 30분”과 모든 입력의 “5시간 초과”를 같은 조건으로 취급하지 않습니다. 대휴 중복 등 다른 제한은 제외한 교육 예시입니다.</div>'+refs([1,5,34,38])+figure('rates')+'</section>'
body+='<section class="paper" id="split"><div class="section-number">02 / 분할과 날짜 묶음</div><h2>토요일이 뒤에 다시 나오면 무슨 일이 생길까요?</h2><p>원래 토요일 10시간을 앞 8시간과 뒤 2시간으로 나눈 상황입니다. 새로운 2시간을 추가한 것이 아닙니다. 아래 세 계산 행이 실제로 만들어지고 일요일 행도 상세에 포함되는 조건을 가정합니다.</p><div class="controls">'+''.join(f'<button data-split="{c["id"]}" aria-pressed="false">{c["label"]}</button>' for c in SPLIT_CASES)+'</div><div class="split-stream" id="split-stream"></div><div class="grid2"><div class="result bad"><h3>기존 임시 기록·그룹의 위험</h3><p>인접 날짜를 세면 <b>토 / 일 / 토 = 3묶음</b></p><div class="ledger"><div class="cell">임시 DB 토요일<b id="old-sat"></b>앞 80,000원을 뒤 금액으로 교체</div><div class="cell">임시 DB 일요일<b id="old-sun"></b>다른 날짜이므로 별도 행</div></div><p class="small">중간 상태의 설명입니다. 최종 BS01 오류액을 이 숫자로 단정하지 않습니다.</p></div><div class="result"><h3>제안: 날짜별로 합산·배분</h3><p>실제 날짜는 <b>2개</b> · 대휴는 <b id="split-leaves"></b></p><div class="ledger"><div class="cell">토요일 JORGEH 목표<b id="new-sat"></b></div><div class="cell">일요일 JORGEH 목표<b id="new-sun"></b></div></div><p>합계 <strong id="split-total"></strong> · 시간 분할은 유지</p></div></div><p class="plain" id="split-note"></p><div class="notice">분할은 D·T 등에서 옵션·기준시간 초과·누계 조건을 충족할 때의 예시입니다. 확인한 선택 CW와 A의 휴일은 이 기준시간 분할에서 제외됩니다. B의 새 J는 별도 분기에서 계산되지 않을 수 있어 이 비영 금액 예시를 그대로 적용하지 않습니다.</div>'+refs([12,16,21,26,38,43])+figure('split-two')+figure('split-six')+'</section>'
body+='<section class="paper" id="lifecycle"><div class="section-number">03 / 사용자 변경과 임시값</div><h2>읽고 삭제해도, 이전 돈을 먼저 가져왔다면?</h2><p>이전 DB 기록이 다음 화면 요청까지 유지된다는 전제입니다. 첫 단계의 80,000원·20,000원은 잔존 상태를 설명하기 위한 값이며, 특정 근무시간 조합의 계산 결과라고 주장하지 않습니다.</p><div class="controls"><button id="life-prev">이전</button><button id="life-next">다음</button><button id="life-reset">처음부터</button><span id="life-count"></span></div><div class="lifecycle-state" aria-live="polite"><h3 id="life-title"></h3><p id="life-text"></p><div class="ledger"><div class="cell">임시 DB 상태<b id="life-db"></b></div><div class="cell">계산·저장 상태<b id="life-save"></b></div></div><div class="notice">화면 재계산에서도 쓰기가 발생할 수 있고 DELETE는 SAVE의 특정 분기에 있습니다. 실제 화면 요청 사이 COMMIT/ROLLBACK과 운영 잔존 여부는 미검증입니다.</div>'+refs([55,57,60,61,62,64])+figure('lifecycle')+'</section>'
body+='<section class="paper" id="copy"><div class="section-number">04 / 계산과 복사</div><h2>새 값이 계산됐다는 것과 저장됐다는 것은 다릅니다.</h2>'+figure('copy')+refs([34,38,39,43])+'</section>'
body+='<section class="paper"><h2>짧은 확인 문제</h2>'
for q,a in [('토8→일2→토2는 3일 근무인가요?','아닙니다. 날짜는 토요일·일요일 2개입니다. 토요일 뒤 2시간은 원래 토10시간의 일부입니다.'),('신청번호를 키에 추가하면 토8·토2가 자동 합산되나요?','아닙니다. 같은 신청의 같은 날짜 두 행은 여전히 같은 키일 수 있습니다. 금액을 더하는 처리도 필요합니다.'),('CLEAR로 임시 DB의 잔존 행을 지울 수 있나요?','아닙니다. 작업 변수 초기화와 DB DELETE는 대상이 다릅니다.'),('단순 ×2는 휴휴이면 항상 틀리나요?','아닙니다. 양일 모두 0.5배인 예시는 맞을 수 있습니다. 0.5배와 1.5배가 섞인 어떤 금액을 두 배 하는지 봐야 합니다.'),('로컬 v700 문법 PASS면 SAP 오류가 해결됐나요?','아닙니다. 실제 데이터·DDIC·F05 재계산·저장·정산까지 SAP 실행 검증이 남아 있습니다.')]:body+=f'<details><summary>{esc(q)}</summary><p>{esc(a)}</p></details>'
body+='</section>'
write('scenarios.html',page('그림으로 이해',body,'<script>window.LESSON='+js({'rates':RATE_CASES,'splits':SPLIT_CASES})+';</script>'))

copydata={}
def pane(c,side):
 s=c[side];copydata[c['id']+':'+side]=s;lines=s.splitlines();other=c['after' if side=='before' else 'before'].splitlines();changed=set()
 for op,i,j,_,_ in difflib.SequenceMatcher(None,lines,other).get_opcodes():
  if op!='equal':changed.update(range(i,j))
 start=c['start'] if side=='before' else c['after_start'];label='수정 전 · 원본' if side=='before' else '수정 후 · 제안'
 rows=''.join(f'<div class="code-line {"changed" if i in changed else ""}"><span class="ln" aria-hidden="true">{start+i}</span><code>{esc(t) or " "}</code></div>' for i,t in enumerate(lines))
 return f'<div class="code-pane {side}"><div class="pane-head"><b>{label} L{start}–{start+len(lines)-1}</b><button class="copy" data-copy="{c["id"]}:{side}">코드 복사</button></div><div class="code-scroll">{rows}</div></div>'
body=hero('두 소스 · 8개 수정 제안 구간','코드 옆에 놓은<br><span class="light">생각의 변화와 발견 과정</span>','원본은 변경하지 않았습니다. 왼쪽은 실제 원본 발췌, 오른쪽은 별도로 작성한 제안 사본입니다. 이 보고서는 기존 제안 코드를 교육용으로 설명하며 새로운 SAP 수정 범위를 추가하지 않습니다.')
body+='<div class="notice">모든 구간을 “사용자 오해로 발생한 버그”라고 분류하지 않습니다. 사용자에게서 확인된 전제, AI가 추가로 발견한 위험, AI가 정정한 설명을 구분합니다. 운영 오류 원인은 아직 확정되지 않았습니다.</div><section class="paper"><div class="grid2"><div><h3>유지</h3><p>시간 분할 · NORM 산식 · 비휴휴 계산 · 정산 확정취소 · 시차 B 정책 확인 상태</p></div><div><h3>제안</h3><p>현재 계산 결과 직접 전달 · 날짜별 합산 · 새 JORGEH 복사 · 첫 계산 E 반환</p></div></div><p class="small">오른쪽 줄번호는 전체 제안 사본 기준입니다. 복사 버튼에는 줄번호가 포함되지 않습니다. 각 발췌는 독립 프로그램이 아니며 기존 구간을 교체하는 문맥입니다. 8개 구간은 함께 검토할 한 변경안입니다.</p><div class="toc-links">'+''.join(f'<a data-show-all href="#{c["id"]}">{c["id"]}</a>' for c in changes)+'</div></section><div class="controls"><button class="active" data-source-filter="all" aria-pressed="true">전체 8</button><button data-source-filter="F03" aria-pressed="false">F03 · 3</button><button data-source-filter="SAVE" aria-pressed="false">SAVE · 5</button></div>'
for c in changes:
 story=CHANGE_STORIES[c['id']];name='LZHR008_2F03.abap' if c['source']=='F03' else 'ZHR_52TM_GET_OVERTIME_SAVE.abap'
 body+=f'<section class="change" id="{c["id"]}" data-source="{c["source"]}"><div class="section-number">{c["id"]} / {esc(c["title"])}</div><h2>{esc(story["headline"])}</h2><p class="badge">{esc(story["status"])}</p><p class="plain">{esc(story["plain"])}</p><div class="journey">'
 for title,key in [('당시 이해·질문','belief'),('AI가 확인한 근거','discovery'),('수정 결정과 목적','decision')]:body+=f'<div><h3>{title}</h3><p>{esc(story[key])}</p></div>'
 body+=f'<div><h3>대화 원문으로 확인</h3><p>질문과 후속 정정을 함께 읽습니다. 아래 번호는 보존된 공개 메시지 ID입니다.</p>{refs(story["messages"])}</div></div>'+figure(story['visual'])
 body+=f'<p class="location">{name} · 원본 L{c["start"]}–{c["end"]} → 제안 L{c["after_start"]}–{c["after_end"]}</p><div class="compare">{pane(c,"before")}{pane(c,"after")}</div><details><summary>개발자를 위한 적용 메모</summary><ul>'+''.join(f'<li>{esc(t)}</li>' for t in c['details'])+'</ul></details><div class="actions">'
 for side,folder in [('before','originals'),('after','proposed')]:
  fn=f'source/proposal/{folder}/{name}';ln=c['start'] if side=='before' else c['after_start'];body+=f'<a class="button" href="source-viewer.html?file={quote(fn)}&amp;line={ln}">{"원본" if side=="before" else "제안"} 전체와 줄번호</a>'
 body+='</div></section>'
body+='<section class="paper"><h2>검증 결과를 어디까지 믿을 수 있나</h2><div class="table-wrap"><table><thead><tr><th>항목</th><th>상태</th><th>의미</th></tr></thead><tbody><tr><td>v700 로컬 문법 파서</td><td class="qa-pass">PASS</td><td>대상 FORM·함수의 문법 검사. 실제 SAP DDIC 검증은 아님</td></tr><tr><td>16개 금액 전달 모형</td><td class="qa-pass">PASS</td><td>이미 계산된 행을 입력한 Python 모형. 실제 ABAP/SAP 실행은 아님</td></tr><tr><td>원본 소스 보존</td><td class="qa-pass">PASS</td><td>기존 제안 작성 당시 exports 5,077개 파일 해시 대조. 교육 포장 때 복사본도 재대조</td></tr><tr><td>SAP 구문·입력·저장 실행</td><td class="qa-pending">NOT RUN</td><td>실제 운영 오류의 재현과 반영 검증 필요</td></tr><tr><td>F05 이후 3+2 대휴표시·실비</td><td class="qa-pending">REVIEW REQUIRED</td><td>이번 두 소스의 금액 전달 보완과 별도 확인</td></tr></tbody></table></div><a href="source/proposal/report.html">당시 작성한 원본 비교 보고서</a> · <a href="source/proposal/checks/validation.json">당시 검증 기록</a></section>'
write('code-review.html',page('코드와 발견 과정',body,'<script>window.COPY_DATA='+js(copydata)+';</script>'))

body=hero('공개 발화 원문 · 65개 메시지','질문과 답변을<br><span class="light">정정 과정까지 그대로</span>','2026년 10월 31일 최초 질문부터 교육자료 압축 요청까지. 사용자 16개, AI 공개 답변·진행 안내 49개를 수록했습니다. 원문 오탈자와 과거 설명을 교정하지 않았습니다.')
body+='<div class="notice">아래 초기 답변을 현재 확정 결론으로 인용하지 마세요. 선택 CW 분할 제외, 웹 신규·수정 공통 복사, DB 잔존의 조건부 설명 등 뒤의 정정을 함께 봐야 합니다. 시스템 지침·비공개 추론·도구 원시 로그는 공개 대화 전문에 포함하지 않습니다.</div><div class="actions"><a href="conversation/transcript.md" download>Markdown 전문</a><a href="conversation/transcript.txt" download>텍스트 전문</a><a href="conversation/messages.json" download>메시지 JSON</a></div><div class="searchbar"><input id="conversation-search" type="search" aria-label="대화 검색" placeholder="대화 내용 검색"><select id="conversation-role" aria-label="발화자"><option value="all">전체 발화자</option><option value="user">사용자</option><option value="assistant">AI</option></select><label><input type="checkbox" id="hide-commentary"> 진행 안내 숨기기</label><span id="conversation-count"></span></div>'
copies={}
for m in messages:
 id=f'M{m["number"]:03d}';copies[id]=m['text'];body+=f'<article id="{id}" class="message {m["role"]} {m["phase"]}" data-role="{m["role"]}" data-phase="{m["phase"]}"><div class="message-head"><b>{id} · {"사용자" if m["role"]=="user" else "AI"}</b><span>{m["phase"]}</span><span>{m["timestamp_kst"]}</span><button class="copy" data-copy="{id}">원문 복사</button></div>'
 for i,part in enumerate(re.split(r'(```[^\n]*\n[\s\S]*?```)',m['text'])):
  if part.startswith('```'):
   code=part[part.index('\n')+1:-3];key=id+'-code-'+str(i);copies[key]=code;body+=f'<button class="copy" data-copy="{key}">이 코드 복사</button><pre>{esc(code)}</pre>'
  elif part:body+=f'<div class="message-body">{esc(part)}</div>'
 ml=[(k,v) for k,v in links.items() if k in m['text']]
 if ml:
  body+='<details><summary>이 메시지에서 인용한 로컬 근거 열기</summary><div class="file-list">'
  for k,v in ml:body+=f'<a href="source-viewer.html?file={quote(v["file"])}'+(f'&amp;line={v["line"]}' if v['line'] else '')+f'">{esc(Path(v["file"]).name)}'+(f' · L{v["line"]}' if v['line'] else '')+'</a>'
  body+='</div></details>'
 body+='</article>'
write('transcript.html',page('대화 전문',body,'<script>window.COPY_DATA='+js(copies)+';window.MESSAGE_COUNT='+str(len(messages))+';</script>'))

body=hero('전체 코드 열람 · 원본과 제안 구분','파일의 전체 문맥과<br><span class="light">정확한 줄번호 확인</span>','개선 제안 ABAP, 기존 근거 소스, 이 방에서 작성한 검증 도구, 교육자료 제작 코드를 구별해 보존했습니다. 신규 독립 SAP 업무 프로그램을 만든 사례가 아닙니다.')
body+='<div class="searchbar"><select id="source-select" aria-label="소스 파일 선택"></select><span id="source-lines"></span></div><p class="path" id="source-path"></p><div class="actions"><button id="source-copy">전체 원문 복사</button><a class="button" id="source-download">원본 파일 받기</a></div><section class="viewer"><div class="source-area" id="source-area"></div></section>'
write('source-viewer.html',page('전체 소스와 줄번호',body,'<script src="assets/source-data.js"></script>'))

# Machine-readable data for the receiving education agent.
jwrite('data/change-stories.json',{'changes':[{**c,'learning':CHANGE_STORIES[c['id']]} for c in changes]})
jwrite('data/case-study.json',{'title':'계산은 맞았는데, 저장된 돈은 왜 달랐을까?','thread_title':'휴휴 대휴 정산 절차 검토','coverage':coverage,'timeline':TIMELINE,'glossary':GLOSSARY,'rates':RATE_CASES,'splits':SPLIT_CASES,'visuals':assets,
 'approved_scope':{'preserve':['기존 시간 분할','NORM 산식','정산 확정취소','비휴휴 사전계산','B 정책 확인 상태'],'proposal':['현재 결과 직접 반환','날짜별 금액 합산','새 JORGEH 복사','첫 GET_DATA E 반환']},
 'limits':['선택 CW에는 기준시간 8+2 분할 예시를 적용하지 않음','A 휴일 분할 제외','D/T/B 모두 항상 8시간 분할이 아님','B 비영 J 예시 일반화 금지','화면 요청 간 DB 잔존 미검증','실제 SAP 운영 오류 원인 미확정','원본 코드 미반영','F05 합산 대휴 표시/실비 후속 검증 필요']})

def build_files():
 catalog=[]
 for p in sorted(OUT.rglob('*')):
  if not p.is_file() or any(x in p.parts for x in ('__pycache__','node_modules')):continue
  rel=str(p.relative_to(OUT))
  if p.suffix not in ('.abap','.py','.cjs','.js','.css','.xml','.md','.patch','.json','.html'):continue
  if rel.startswith(('assets/source-data','conversation/messages','evidence/app-thread','evidence/copied-files','source/proposal/source-hashes','data/','evidence/package-check')) or rel in ('manifest.json','index.html','transcript.html','code-review.html','source-viewer.html','files.html','scenarios.html'):continue
  if rel.startswith('source/proposal/proposed/') or rel.startswith('source/proposal/snippets/'):
   label='ABAP 수정 제안';status='원본 미반영 · SAP 미검증'
  elif rel.startswith('source/proposal/originals/') or rel.startswith('source/evidence/'):
   label='기존 근거 원본';status='읽기 자료 · 이번 방에서 변경한 소스 아님'
  elif rel.startswith(('source/proposal/tools/','research/reviews/')) and p.suffix in ('.py','.cjs','.js','.css'):
   label='본 대화의 신규 검증·보고서 도구';status='로컬 개발 보조 · SAP 등록용 아님'
  elif rel.startswith(('tools/','assets/site.')):
   label='신규 교육자료 제작 코드';status='HTML·도식·검증·압축 제작용'
  elif rel.startswith('conversation/code-blocks/'):
   label='대화 속 코드 예제';status='과거 설명 원문 · 현재 적용안과 구분'
  else:label='검토·검증 문서';status='문서 근거 · 운영 승인 아님'
  catalog.append({'path':rel,'label':label,'status':status,'text':p.read_text()})
 write('assets/source-data.js','window.SOURCE_FILES='+js(catalog)+';\n')
 body=hero('전체 소스 인계','교육사이트 제작에 필요한<br><span class="light">파일과 이미지 묶음</span>','원문, 수정 제안, 근거 소스, 교육용 해설을 따로 보관했습니다. 파일명·해시·출처는 manifest.json과 evidence에 기록합니다.')
 body+='<section class="paper"><h2>교육사이트 에이전트 시작점</h2><div class="file-list"><a href="PORTAL_HANDOFF.md">PORTAL_HANDOFF.md · 페이지 구성·인용 규칙·검증 한계</a><a href="README.md">README.md · 패키지 구조와 사용 방법</a><a href="manifest.json">manifest.json · 파일별 해시</a><a href="evidence/conversation-coverage.json">대화 수록 범위·앱 대조 결과</a><a href="evidence/package-check.json">패키지 검증 결과</a><a href="source/proposal/report.html">이전 턴에서 작성한 원본 HTML 비교 보고서</a></div></section>'
 body+='<section class="paper"><h2>신규·수정 코드는 이렇게 분류했습니다.</h2><div class="table-wrap"><table><thead><tr><th>구분</th><th>무엇이 들어 있나</th><th>상태</th></tr></thead><tbody><tr><td>ABAP 수정 제안</td><td>F03와 SAVE 전체 사본, 8개 구간, 패치</td><td>원본 미반영</td></tr><tr><td>대화 중 신규 도구</td><td>비교 HTML 생성·v700 파서·Python 모형·브라우저 검사</td><td>개발·검증 보조</td></tr><tr><td>신규 교육자료 코드</td><td>이 패키지의 HTML·CSS·JS·SVG·빌드·검사 코드</td><td>교육사이트 재구성에 사용</td></tr><tr><td>기존 근거 소스</td><td>NORM·DAILY·F05·F06·DDIC 등 인용한 원본</td><td>참조 사본 · 수정 실적 아님</td></tr></tbody></table></div><p>모든 파일은 <a href="source-viewer.html">전체 코드와 줄번호 열람기</a>에서 열 수 있습니다. 아래는 코드 파일 중심 목록입니다.</p><div class="file-list">'
 for f in catalog:
  if f['path'].endswith(('.abap','.py','.cjs','.js','.css')) and not f['path'].startswith('source/evidence/'):
   body+=f'<a href="source-viewer.html?file={quote(f["path"])}">{esc(f["label"])} · {esc(f["path"])}</a>'
 body+='</div></section><section class="paper"><h2>새로 만든 교육 이미지 · 9종</h2><p>각 SVG는 텍스트와 도형을 편집할 수 있습니다. PNG는 교육 페이지에 바로 배치할 수 있는 렌더링 사본입니다.</p><div class="asset-grid">'
 for a in assets:body+=f'<article><a href="{a["png"]}"><img src="{a["svg"]}" alt="{esc(a["title"])}" loading="lazy"></a><h3>{esc(a["title"])}</h3><div class="actions"><a href="{a["svg"]}" download>SVG</a><a href="{a["png"]}" download>PNG</a></div></article>'
 body+='</div></section><section class="paper"><h2>사용자 첨부와 보고서 캡처</h2><p>사용자 업로드 이미지는 이 방 기록에서 0건입니다. <a href="attachments/inventory.json">첨부 조사 기록</a>을 남겼습니다. 아래 세 장은 AI가 이전 보고서를 검사하면서 생성한 화면 캡처입니다.</p><div class="grid3">'
 for f in ('report-desktop.png','report-comparison.png','report-mobile.png'):body+=f'<a href="source/proposal/checks/{f}"><img src="source/proposal/checks/{f}" alt="기존 보고서 검증 캡처 {f}" style="width:100%;height:230px;object-fit:contain;background:#edf2f1">{f}</a>'
 body+='</div></section>'
 write('files.html',page('파일과 이미지',body))
 return len(catalog)
if __name__=='__main__':print(json.dumps({'pages':6,'source_catalog':build_files(),'messages':len(messages),'changes':len(changes),'visuals':len(assets)}))
