import test from 'node:test';
import assert from 'node:assert/strict';
import vm from 'node:vm';
import {readFile} from 'node:fs/promises';
import * as conversations from '../site/conversations.js';
import {renderPresentation} from '../site/presentation.js';
import {renderKnowledge,mountKnowledge} from '../site/knowledge.js';
const data=JSON.parse(await readFile(new URL('../dist/data/portal.json',import.meta.url),'utf8'));
const source=(await readFile(new URL('../site/app.js',import.meta.url),'utf8')).replace(/^import .+;$/gm,'');
function fixture(hash){
 const elements=new Map(),events={},windowEvents={},graphNodes=[],copied=[],presentationLifecycle=[];
 const classes=()=>({add(){},remove(){},contains(){return false;},toggle(){return false;}});
 const element=id=>{
  if(!elements.has(id))elements.set(id,{id,innerHTML:'',textContent:'',hidden:false,classList:classes(),setAttribute(){},addEventListener(){},querySelectorAll(){return [];},focus(){},scrollIntoView(){}});
  return elements.get(id);
 };
 for(const id of ['sap','export','git','knowledge','codex','diag','maps','feedback'])graphNodes.push({dataset:{node:id},classList:classes(),setAttribute(){}});
 const location={hash};
 const document={body:{classList:classes()},querySelector(s){if(s==='#compare-preset'||s==='dialog[open]'||s==='.hero')return null;if(s==='[data-presentation]')return element('presentation');return s.startsWith('#')?element(s.slice(1)):null;},querySelectorAll(s){return s==='.graph-node'?graphNodes:[];},getElementById:element,addEventListener(type,fn){events[type]=fn;}};
 const context=vm.createContext({...conversations,renderKnowledge,mountKnowledge,renderPresentation,mountPresentation(root){assert.equal(root.id,'presentation');presentationLifecycle.push('mount');return ()=>presentationLifecycle.push('cleanup');},mountHeroMotion(){return ()=>{};},document,location,history:{replaceState(a,b,url){location.hash=url;}},localStorage:{getItem(){return null;}},window:{scrollTo(){},addEventListener(type,fn){windowEvents[type]=fn;},isSecureContext:true},navigator:{clipboard:{async writeText(text){copied.push(text);}}},URLSearchParams,fetch:async()=>({ok:true,json:async()=>data}),console,setTimeout,clearTimeout});
 return {context,elements,events,windowEvents,location,copied,presentationLifecycle};
}
function target(attribute,dataset){return {dataset,closest(){return this;},matches(selector){return selector===`[${attribute}]`;}};}
test('발표의 직접 주소·방향키·버튼·종료에서 화면과 타이핑 생명주기를 연결한다',async()=>{
 const f=fixture('#/present/0');await vm.runInContext(`(async()=>{${source}})()`,f.context);
 assert.ok(f.elements.get('main').innerHTML.includes(data.slides[0].title));
 const key=k=>f.events.keydown({key:k,target:{tagName:'BODY',matches(){return false;}},preventDefault(){}});
 key('ArrowRight');assert.equal(f.location.hash,'#/present/1');f.windowEvents.hashchange();
 assert.ok(f.elements.get('main').innerHTML.includes(data.slides[1].title));
 f.events.click({target:target('data-slide',{slide:'6'})});f.windowEvents.hashchange();
 assert.ok(f.elements.get('main').innerHTML.includes(data.slides[6].title));
 key('ArrowRight');assert.equal(f.location.hash,'#/present/6');
 key('Escape');assert.equal(f.location.hash,'#/home');f.windowEvents.hashchange();
 assert.deepEqual(f.presentationLifecycle,['mount','cleanup','mount','cleanup','mount','cleanup']);
});
test('복사 버튼은 화면에 표시한 사용자 교육 문장과 AI 답변을 복사한다',async()=>{
 const f=fixture('#/conversations/erp-obsidian-knowledge-map/obs-e001');await vm.runInContext(`(async()=>{${source}})()`,f.context);
 const projectId='erp-obsidian-knowledge-map',chatCopy='obs-m001';
 const m=data.conversations.projects.find(p=>p.id===projectId).messages.find(m=>m.id===chatCopy);
 const reply=data.conversations.projects.find(p=>p.id===projectId).messages.find(m=>m.role==='assistant');
 f.events.click({target:target('data-chat-copy',{projectId,chatCopy})});
 f.events.click({target:target('data-chat-copy',{projectId,chatCopy:reply.id})});
 assert.deepEqual(f.copied,[m.editorial_markdown,reply.content_markdown]);
});
test('구성 요소 선택 후 프로젝트·에피소드·해설을 바꿔도 같은 화면에서 올바른 대화와 주소가 연결된다',async()=>{
 const f=fixture('#/map/core?node=export');await vm.runInContext(`(async()=>{${source}})()`,f.context);
 assert.ok(f.elements.get('main').innerHTML.includes('첫 추출기의 오류를 실행 결과로 줄이다'));
 f.events.click({target:target('data-node',{node:'maps'})});
 assert.ok(f.elements.get('conversation-host').innerHTML.includes('업무 자료를 연결하려는 목적과 도구의 역할'));
 assert.ok(f.location.hash.includes('node=maps'));
 const select={value:'erp-agent-communication',matches:s=>s==='[data-conversation-select]'};
 f.events.change({target:select});
 assert.ok(f.elements.get('conversation-host').innerHTML.includes('접점 MD를 업무 지도로 설명하기'));
 assert.ok(f.location.hash.includes('project=erp-agent-communication'));
 f.events.click({target:target('data-conversation-tab',{conversationTab:'review'})});
 assert.ok(f.elements.get('conversation-host').innerHTML.includes('교육 해설 · 당시 AI 답변과 구분'));
 assert.ok(f.location.hash.includes('tab=review'));
 const reloaded=fixture(f.location.hash);await vm.runInContext(`(async()=>{${source}})()`,reloaded.context);
 assert.ok(reloaded.elements.get('main').innerHTML.includes('접점 MD를 업무 지도로 설명하기'));
 assert.ok(reloaded.elements.get('main').innerHTML.includes('교육 해설 · 당시 AI 답변과 구분'));
});
test('단독 대화에서 항목을 차례로 펼치고 다음 에피소드로 이동하면 기록 순서와 초기 표시 수가 유지된다',async()=>{
 const f=fixture('#/conversations/erp-obsidian-knowledge-map/obs-e003');await vm.runInContext(`(async()=>{${source}})()`,f.context);
 assert.equal((f.elements.get('main').innerHTML.match(/class="chat-message /g)||[]).length,4);
 f.events.click({target:target('data-conversation-more',{})});
 assert.equal((f.elements.get('conversation-host').innerHTML.match(/class="chat-message /g)||[]).length,5);
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
 assert.ok(f.elements.get('main').innerHTML.includes('#/learn/publishing'));
 f.events.input({target:{id:'search-input',value:'selective-cumulative-display',matches(){return false;}}});
 assert.ok(f.elements.get('search-results').innerHTML.includes('#/learn/worktime-agent?doc='));
 f.location.hash='#/courses';f.windowEvents.hashchange();
 assert.ok(f.elements.get('main').innerHTML.includes('근로시간 AI 에이전트 구축'));
 f.location.hash='#/learn/publishing';f.windowEvents.hashchange();
 assert.ok(f.elements.get('main').innerHTML.includes('과정 12'));
});

test('완료 기록 없이 모든 과정의 자료 저장·이전 다음 이동을 제공한다',async()=>{
 const f=fixture('#/home');let prints=0,completionReads=0;
 f.context.localStorage.getItem=key=>{if(key==='erp-ai-completed-v1'){completionReads++;return JSON.stringify(data.lessons.map(l=>l.id));}return null;};
 f.context.window.print=()=>prints++;
 await vm.runInContext(`(async()=>{${source}})()`,f.context);
 assert.equal(completionReads,0);assert.match(f.elements.get('main').innerHTML,/학습 시작하기/);assert.doesNotMatch(f.elements.get('main').innerHTML,/이어서 학습하기/);
 for(let i=0;i<data.lessons.length;i++){
  const lesson=data.lessons[i];f.location.hash='#/learn/'+lesson.id;f.windowEvents.hashchange();const html=f.elements.get('main').innerHTML;
  assert.equal((html.match(/data-print/g)||[]).length,1,lesson.id);assert.match(html,/인쇄 · PDF 저장/);assert.match(html,/교육 MD 다운로드/);
  assert.ok(html.includes('href="content/'+lesson.file+'" download="'+lesson.file.split('/').pop()+'"'));
  assert.doesNotMatch(html,/data-complete|complete-panel|학습 완료 표시/);assert.doesNotMatch(f.elements.get('sidebar').innerHTML,/done-tick|학습 표시 완료/);
  if(i>0)assert.ok(html.includes('이전 과정 · '+String(data.lessons[i-1].number).padStart(2,'0')));
  if(i<data.lessons.length-1)assert.ok(html.includes('다음 과정 · '+String(data.lessons[i+1].number).padStart(2,'0')));
 }
 f.events.click({target:target('data-print',{})});assert.equal(prints,1);
 f.location.hash='#/courses';f.windowEvents.hashchange();assert.doesNotMatch(f.elements.get('main').innerHTML,/학습 표시|read-progress/);
});
