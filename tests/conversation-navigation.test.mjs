import test from 'node:test';
import assert from 'node:assert/strict';
import vm from 'node:vm';
import {readFile} from 'node:fs/promises';
import {countNumber,mountCountUps} from '../site/count-up.js';
import * as conversations from '../site/conversations.js';
import {renderSourceDocuments,filterSourceDocuments} from '../site/source-library.js';
import {renderKnowledge,mountKnowledge} from '../site/knowledge.js';
const data=JSON.parse(await readFile(new URL('../dist/data/portal.json',import.meta.url),'utf8'));
const source=(await readFile(new URL('../site/app.js',import.meta.url),'utf8')).replace(/^import .+;$/gm,'');
function fixture(hash){
 const elements=new Map(),events={},windowEvents={},graphNodes=[],copied=[],presentationLifecycle=[],heroLifecycle=[];
 const classes=()=>({add(){},remove(){},contains(){return false;},toggle(){return false;}});
 const element=id=>{
  if(!elements.has(id))elements.set(id,{id,innerHTML:'',textContent:'',hidden:false,classList:classes(),setAttribute(){},addEventListener(){},querySelectorAll(){return [];},focus(){},scrollIntoView(){},close(){}});
  return elements.get(id);
 };
 for(const id of ['sap','export','git','knowledge','codex','diag','maps','feedback'])graphNodes.push({dataset:{node:id},classList:classes(),setAttribute(){}});
 const location={hash,replace(next){this.hash=next;}};
 const document={body:{classList:classes()},querySelector(s){if(s==='#compare-preset'||s==='dialog[open]'||s==='.hero')return null;if(s==='[data-presentation]')return element('presentation');return s.startsWith('#')?element(s.slice(1)):null;},querySelectorAll(s){return s==='.graph-node'?graphNodes:[];},getElementById:element,addEventListener(type,fn){events[type]=fn;}};
 const context=vm.createContext({...conversations,renderSourceDocuments,filterSourceDocuments,countNumber,mountCountUps,renderKnowledge,mountKnowledge,mountPresentation(root){assert.equal(root.id,'presentation');presentationLifecycle.push('mount');return ()=>presentationLifecycle.push('cleanup');},mountHeroMotion(root,options){assert.equal(options?.alreadyTyped,undefined);heroLifecycle.push('mount');return ()=>heroLifecycle.push('cleanup');},document,location,history:{replaceState(a,b,url){location.hash=url;}},localStorage:{getItem(){return null;}},window:{scrollTo(){},addEventListener(type,fn){windowEvents[type]=fn;},isSecureContext:true},navigator:{clipboard:{async writeText(text){copied.push(text);}}},URLSearchParams,fetch:async()=>({ok:true,json:async()=>data}),console,setTimeout,clearTimeout});
 return {context,elements,events,windowEvents,location,copied,presentationLifecycle,heroLifecycle};
}
function target(attribute,dataset){return {dataset,closest(){return this;},matches(selector){return selector===`[${attribute}]`;}};}
test('목차는 앞선 지연 이미지의 높이가 확정된 뒤 이동하고 오래된 이동 요청은 취소한다',async()=>{
 const f=fixture('#/learn/maps');await vm.runInContext(`(async()=>{${source}})()`,f.context);
 const scrolled=[];
 for(const id of ['section-16','section-17']){
  const el=f.context.document.getElementById(id);el.isConnected=true;el.scrollIntoView=()=>scrolled.push(id);
 }
 let release,pending=new Promise(resolve=>{release=resolve;});
 const image={loading:'lazy',compareDocumentPosition:()=>4,decode:()=>pending};
 const query=f.context.document.querySelectorAll;
 f.context.document.querySelectorAll=s=>s==='.article img'?[image]:query(s);
 f.context.Node={DOCUMENT_POSITION_FOLLOWING:4};
 const click=id=>f.events.click({target:target('data-section',{section:id}),preventDefault(){}});
 click('section-17');assert.equal(image.loading,'eager');assert.deepEqual(scrolled,[]);
 release();await new Promise(resolve=>setImmediate(resolve));assert.deepEqual(scrolled,['section-17']);
 pending=new Promise(resolve=>{release=resolve;});
 click('section-16');click('section-17');release();await new Promise(resolve=>setImmediate(resolve));
 assert.deepEqual(scrolled,['section-17','section-17']);
 pending=new Promise(resolve=>{release=resolve;});click('section-16');
 f.context.document.getElementById('section-16').isConnected=false;
 release();await new Promise(resolve=>setImmediate(resolve));assert.deepEqual(scrolled,['section-17','section-17']);
});
test('활용사례의 새 맥락은 기존 요소 앞에 추가되고 기존 목차·검색·직접 이동을 유지한다',async()=>{
 const f=fixture('#/learn/worktime-agent');await vm.runInContext(`(async()=>{${source}})()`,f.context);
 for(const l of data.lessons){
  f.location.hash='#/learn/'+l.id;f.windowEvents.hashchange();const html=f.elements.get('main').innerHTML;
  assert.ok(html.includes(l.html),l.id+' 기존 본문');
  if(l.number<11){assert.doesNotMatch(html,/class="prose case-context"/);continue;}
  const start=html.indexOf('class="prose case-context"');assert.ok(start>=0);
  assert.ok(html.indexOf('프로젝트의 네 가지 관점')<start);
  assert.ok(html.indexOf('class="prose lesson-body"')>start);
  if(l.showcase)assert.ok(html.indexOf('class="case-showcase"')>start);
  if(l.id==='worktime-agent')assert.ok(html.indexOf('업무 지식의 전체 구조')>start);
  const added=l.toc.filter(t=>t.id.startsWith('context-'));
  assert.equal(added.length,4);assert.equal(new Set(l.toc.map(t=>t.id)).size,l.toc.length);
  for(const t of l.toc){assert.ok(html.includes(`id="${t.id}"`));assert.ok(html.includes(`data-section="${t.id}"`));}
 }
 f.events.input({target:{id:'search-input',value:'JSONL',matches(){return false;}}});
 assert.match(f.elements.get('search-results').innerHTML,/#\/learn\/weekly-timeline/);
 let scrolled=false;f.context.document.getElementById('context-section-4').scrollIntoView=()=>{scrolled=true;};
 f.location.hash='#/learn/weekly-timeline?section=context-section-4';f.windowEvents.hashchange();assert.equal(scrolled,true);
});
test('복사 버튼은 화면에 표시한 사용자 교육 문장과 AI 답변을 복사한다',async()=>{
 const f=fixture('#/conversations/erp-obsidian-knowledge-map/obs-e001');await vm.runInContext(`(async()=>{${source}})()`,f.context);
 const projectId='erp-obsidian-knowledge-map',chatCopy='obs-m001';
 const m=data.conversations.projects.find(p=>p.id===projectId).messages.find(m=>m.id===chatCopy);
 const reply=data.conversations.projects.find(p=>p.id===projectId).messages.find(m=>m.role==='assistant');
 f.events.click({target:target('data-chat-copy',{projectId,chatCopy})});
 f.events.click({target:target('data-chat-copy',{projectId,chatCopy:reply.id})});
 assert.deepEqual(f.copied,[m.editorial_markdown,reply.editorial_markdown??reply.content_markdown]);
});
test('구성 요소 선택 후 프로젝트·에피소드·해설을 바꿔도 같은 화면에서 올바른 대화와 주소가 연결된다',async()=>{
 const f=fixture('#/map/core?node=export');await vm.runInContext(`(async()=>{${source}})()`,f.context);
 assert.ok(f.elements.get('main').innerHTML.includes('첫 추출기 오류 분석 및 수정'));
 f.events.click({target:target('data-node',{node:'maps'})});
 assert.ok(f.elements.get('conversation-host').innerHTML.includes('업무 자료 연결 목적 및 도구 역할'));
 assert.ok(f.location.hash.includes('node=maps'));
 const select={value:'erp-agent-communication',matches:s=>s==='[data-conversation-select]'};
 f.events.change({target:select});
 assert.ok(f.elements.get('conversation-host').innerHTML.includes('업무 접점 MD 및 관계 시각화'));
 assert.ok(f.location.hash.includes('project=erp-agent-communication'));
 f.events.click({target:target('data-conversation-tab',{conversationTab:'review'})});
 assert.ok(f.elements.get('conversation-host').innerHTML.includes('conversation-outcome'));
 assert.ok(f.location.hash.includes('tab=review'));
 const reloaded=fixture(f.location.hash);await vm.runInContext(`(async()=>{${source}})()`,reloaded.context);
 assert.ok(reloaded.elements.get('main').innerHTML.includes('업무 접점 MD 및 관계 시각화'));
 assert.ok(reloaded.elements.get('main').innerHTML.includes('conversation-outcome'));
});
test('단독 대화에서 항목을 차례로 펼치고 다음 에피소드로 이동하면 기록 순서와 초기 표시 수가 유지된다',async()=>{
 const f=fixture('#/conversations/erp-obsidian-knowledge-map/obs-e003');await vm.runInContext(`(async()=>{${source}})()`,f.context);
 assert.equal((f.elements.get('main').innerHTML.match(/class="chat-message /g)||[]).length,4);
 f.events.click({target:target('data-conversation-more',{})});
 assert.equal((f.elements.get('conversation-host').innerHTML.match(/class="chat-message /g)||[]).length,6);
 f.events.click({target:target('data-conversation-all',{})});
 assert.equal((f.elements.get('conversation-host').innerHTML.match(/class="chat-message /g)||[]).length,6);
 f.events.click({target:target('data-conversation-episode',{conversationEpisode:'obs-e004'})});
 assert.ok(f.location.hash.startsWith('#/conversations/erp-obsidian-knowledge-map/obs-e004'));
 assert.equal((f.elements.get('conversation-host').innerHTML.match(/class="chat-message /g)||[]).length,2);
});


test('새 11번 과정과 전체 과정·검색·12번 이동이 같은 카탈로그를 사용한다',async()=>{
 const f=fixture('#/learn/worktime-agent');await vm.runInContext(`(async()=>{${source}})()`,f.context);
 assert.ok(f.elements.get('main').innerHTML.includes('업무 지식의 전체 구조'));
 assert.ok(f.elements.get('sidebar').innerHTML.includes('근로시간 AI 에이전트 구축'));
 assert.ok(f.elements.get('main').innerHTML.includes('#/learn/webgui'));
 f.events.input({target:{id:'search-input',value:'selective-cumulative-display',matches(){return false;}}});
 assert.ok(f.elements.get('search-results').innerHTML.includes('#/learn/worktime-agent?doc='));
 f.location.hash='#/courses';f.windowEvents.hashchange();
 assert.ok(f.elements.get('main').innerHTML.includes('근로시간 AI 에이전트 구축'));
 f.location.hash='#/learn/publishing';f.windowEvents.hashchange();
 assert.ok(f.elements.get('main').innerHTML.includes('과정 13'));
});

test('모든 과정에서 자료 저장 박스를 제거하고 이전 다음 이동을 유지한다',async()=>{
 const f=fixture('#/home');let completionReads=0;
 f.context.localStorage.getItem=key=>{if(key==='erp-ai-completed-v1'){completionReads++;return JSON.stringify(data.lessons.map(l=>l.id));}return null;};
 await vm.runInContext(`(async()=>{${source}})()`,f.context);
 assert.equal(completionReads,0);assert.match(f.elements.get('main').innerHTML,/워크플로 살펴보기/);assert.doesNotMatch(f.elements.get('main').innerHTML,/이어서 학습하기/);
 for(let i=0;i<data.lessons.length;i++){
  const lesson=data.lessons[i];f.location.hash='#/learn/'+lesson.id;f.windowEvents.hashchange();const html=f.elements.get('main').innerHTML;
  assert.doesNotMatch(html,/이 과정 자료|lesson-tools|data-print|인쇄 · PDF 저장|과정 MD 다운로드/,lesson.id);
  assert.ok(!html.includes('href="content/'+lesson.file+'"'),lesson.id);
  if(lesson.number>=11)assert.match(html,/프로젝트의 네 가지 관점/);
  assert.doesNotMatch(html,/data-complete|complete-panel|학습 완료 표시/);assert.doesNotMatch(f.elements.get('sidebar').innerHTML,/done-tick|학습 표시 완료/);
  if(i>0)assert.ok(html.includes('이전 과정 · '+(data.lessons[i-1].displayNumber||String(data.lessons[i-1].number).padStart(2,'0'))));
  if(i<data.lessons.length-1)assert.ok(html.includes('다음 과정 · '+(data.lessons[i+1].displayNumber||String(data.lessons[i+1].number).padStart(2,'0'))));
 }
 f.location.hash='#/courses';f.windowEvents.hashchange();assert.doesNotMatch(f.elements.get('main').innerHTML,/학습 표시|read-progress/);
});

test('GITHUB와 CODEX의 독립 주소·탐색·검색과 핵심 MD 바로가기가 동작한다',async()=>{
 const f=fixture('#/learn/workspace');await vm.runInContext(`(async()=>{${source}})()`,f.context);
 assert.match(f.elements.get('main').innerHTML,/<h1>03. GITHUB 연동<\/h1>/);
 assert.match(f.elements.get('main').innerHTML,/과정 03/);
 assert.match(f.elements.get('main').innerHTML,/다음 과정 · 04/);
 f.location.hash='#/learn/codex';f.windowEvents.hashchange();
 assert.match(f.elements.get('main').innerHTML,/<h1>04. 로컬 에이전트 구성<\/h1>/);
 assert.match(f.elements.get('main').innerHTML,/이전 과정 · 03/);
 assert.match(f.elements.get('main').innerHTML,/다음 과정 · 05/);
 assert.equal(data.lessons.find(l=>l.id==='codex').file,'lessons/03-codex.md');
 f.events.input({target:{id:'search-input',value:'Git: Clone',matches(){return false;}}});
 assert.match(f.elements.get('search-results').innerHTML,/#\/learn\/workspace/);
 f.events.input({target:{id:'search-input',value:'프로젝트 폴더 지정',matches(){return false;}}});
 assert.match(f.elements.get('search-results').innerHTML,/#\/learn\/codex/);
 let scrolled=false;f.context.document.getElementById('core-md-title').scrollIntoView=()=>{scrolled=true;};
 f.location.hash='#/library?section=core-md-title';f.windowEvents.hashchange();
 assert.equal(scrolled,true);assert.match(f.elements.get('main').innerHTML,/core-progress/);
});

test('홈으로 돌아오면 제목 타이핑을 새로 시작하고 기존 생명주기를 정리한다',async()=>{
 const f=fixture('#/home');await vm.runInContext(`(async()=>{${source}})()`,f.context);
 f.location.hash='#/courses';f.windowEvents.hashchange();
 f.location.hash='#/home';f.windowEvents.hashchange();
 assert.deepEqual(f.heroLifecycle,['mount','cleanup','mount']);
});


test('제거된 사례실습 주소는 관련 과정으로 이동한다',async()=>{
 for(const [old,next] of [['compare','diagnosis'],['evidence','diagnosis'],['webgui','webgui'],['ess-attendance','ess-attendance']]){
  const f=fixture('#/cases/'+old);await vm.runInContext(`(async()=>{${source}})()`,f.context);
  assert.equal(f.location.hash,'#/learn/'+next);
  f.windowEvents.hashchange();
  const lesson=data.lessons.find(l=>l.id===next);
  assert.ok(f.elements.get('main').innerHTML.includes(`<h1>${lesson.displayNumber||String(lesson.number).padStart(2,'0')}. ${lesson.title}</h1>`));
 }
});

test('자료확인 직접 주소는 선택한 프로젝트 MD만 표시한다',async()=>{
 for(const item of data.sources){
  const f=fixture('#/library/'+item.id);await vm.runInContext(`(async()=>{${source}})()`,f.context);
  const html=f.elements.get('main').innerHTML;
  assert.equal((html.match(/data-source-file=/g)||[]).length,item.mdCount);
  assert.ok(html.includes(item.mdArchive));
  for(const other of data.sources.filter(s=>s.id!==item.id))assert.ok(!html.includes(other.mdArchive));
 }
});

test('16개 새 순서·4개 홈 묶음·메뉴와 제목이 일치한다',async()=>{
 const titles=['ERP AI 에이전트 전체 그림','ERP 소스 추출하기','GITHUB 연동','로컬 에이전트 구성','업무 맥락 만들기','업무 지도 만들기','업무 스킬 및 회귀','코드 검증 및 적용','에이전트간 협업','ERP 데이터 연동','근로시간 AI 에이전트 구축','ERP WEBGUI 개편','ERP AI 에이전트 포털 구축','ESS 근태시스템 개편','업무일지 타임라인 개발','스마트 ERP 메인화면 개편'];
 assert.deepEqual(data.lessons.map(l=>l.title),titles);assert.deepEqual(data.lessons.map(l=>l.number),Array.from({length:16},(_,i)=>i+1));
 const f=fixture('#/home');await vm.runInContext(`(async()=>{${source}})()`,f.context);
 assert.equal((f.elements.get('main').innerHTML.match(/class="path-entry"/g)||[]).length,4);
 assert.doesNotMatch(f.elements.get('sidebar').innerHTML,/워크플로/);
 for(const l of data.lessons){f.location.hash='#/learn/'+l.id;f.windowEvents.hashchange();assert.ok(f.elements.get('main').innerHTML.includes(`<h1>${String(l.number).padStart(2,'0')}. ${l.title}</h1>`));}
});
test('활용사례 지도는 독립 박스 여섯 개이며 자체 프로젝트 대화만 선택한다',async()=>{
 const f=fixture('#/map/cases');await vm.runInContext(`(async()=>{${source}})()`,f.context);
 assert.equal((f.elements.get('main').innerHTML.match(/data-node="case-/g)||[]).length,6);assert.doesNotMatch(f.elements.get('main').innerHTML,/class="graph-line/);
 for(const [id,pid] of [['webgui','kbs-erp-webgui-refactor'],['ess-attendance','kbs-erp-ess-attendance'],['weekly-timeline','kbs-weekly-work-timeline'],['smart-erp','kbs-smart-erp-main']]){
  f.events.click({target:target('data-node',{node:'case-'+id})});assert.ok(f.elements.get('conversation-host').innerHTML.includes(`data-conversation-project="${pid}"`));assert.ok(f.location.hash.startsWith('#/map/cases?'));
 }
 f.events.click({target:target('data-node',{node:'case-publishing'})});assert.match(f.elements.get('conversation-host').innerHTML,/href="#\/learn\/publishing"/);assert.doesNotMatch(f.elements.get('conversation-host').innerHTML,/아직 등록/);
});
test('핵심 MD 직접 주소에는 프로젝트·용도·다운로드를 제공하고 제거된 대화 탭은 노출하지 않는다',async()=>{
 for(const g of data.coreDocuments){const f=fixture('#/library/'+g.id);await vm.runInContext(`(async()=>{${source}})()`,f.context);const html=f.elements.get('main').innerHTML;assert.match(html,/source-document-purpose/);for(const d of g.mdDocuments){assert.ok(html.includes(d.download));assert.ok(html.includes(d.project));}}
 assert.deepEqual(conversations.conversationTabs.map(t=>t[0]),['dialogue','review','assets']);
 for(const p of data.conversations.projects){const html=conversations.conversationWorkspace(data.conversations,{projectId:p.id,tab:'review'});assert.doesNotMatch(html,/선택한 요소와 연결된 에피소드만|교육 해설 — 실제 AI 발화 아님|교육 해설 · 당시 AI 답변과 구분|대화 확보 범위 ·/);}
});
