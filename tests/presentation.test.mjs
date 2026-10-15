import test from 'node:test';
import assert from 'node:assert/strict';
import vm from 'node:vm';
import {readFile} from 'node:fs/promises';
import {renderPresentation} from '../site/presentation.js';
const portal=JSON.parse(await readFile(new URL('../dist/data/portal.json',import.meta.url),'utf8'));
const source=(await readFile(new URL('../site/presentation.js',import.meta.url),'utf8')).replace(/^export /gm,'');

function fixture(slide=portal.slides[0],reduced=false){
 const timers=new Map();let sequence=0,elapsed=0;
 const element=()=>{
  const listeners=new Map(),classes=new Set();
  return {listeners,classes,textContent:'',dataset:{},classList:{add:x=>classes.add(x),remove:x=>classes.delete(x)},addEventListener:(k,fn)=>listeners.set(k,fn),removeEventListener(k,fn){if(listeners.get(k)===fn)listeners.delete(k);}};
 };
 const text=[slide.title,slide.subtitle,...slide.steps.flatMap(s=>[s.title,s.text]),slide.prompt,slide.fieldNote.title,slide.fieldNote.text,slide.checkpoint.question];
 const outputs=text.map((value,i)=>Object.assign(element(),{textContent:value,dataset:{presentKind:i===0?'title':'body'}}));
 const button=element(),root=element(),document=Object.assign(element(),{hidden:false}),window=element(),preference=Object.assign(element(),{matches:reduced});
 root.querySelectorAll=()=>outputs;root.querySelector=()=>button;
 const context=vm.createContext({document,window,setTimeout(fn,ms){timers.set(++sequence,{fn,ms});return sequence;},clearTimeout:id=>timers.delete(id)});
 vm.runInContext(source,context);
 const cleanup=vm.runInContext('mountPresentation',context)(root,{preference});
 const step=()=>{const entry=timers.entries().next().value;if(entry){timers.delete(entry[0]);elapsed+=entry[1].ms;entry[1].fn();}};
 return {text,outputs,button,root,document,window,preference,timers,cleanup,step,elapsed:()=>elapsed};
}

test('발표 7개 화면에 실무 순서·예시·시행착오·확인 질문과 실제 근거 링크가 연결된다',()=>{
 assert.equal(portal.slides.length,7);
 for(const [i,s] of portal.slides.entries()){
  const html=renderPresentation(portal.slides,i);
  assert.equal(s.steps.length,3);
  for(const text of ['실무에서 따라갈 순서','교육용 예시','함께 확인하기','해설 보기',s.checkpoint.answer])assert.ok(html.includes(text));
  assert.equal((html.match(/data-present-text/g)||[]).length,12);
  const ids=[...html.matchAll(/\sid="([^"]+)"/g)].map(m=>m[1]);assert.equal(ids.length,new Set(ids).size);
  assert.ok(portal.lessons.some(l=>l.id===s.lesson));
  for(const link of s.links){
   const [type,pid,eid]=link.href.slice(2).split('/');
   if(type==='conversations'&&pid){const p=portal.conversations.projects.find(p=>p.id===pid);assert.ok(p,link.href);assert.ok(p.episodes.some(e=>e.id===eid),link.href);}
   if(type==='learn')assert.ok(portal.lessons.some(l=>l.id===pid));
  }
  assert.match(html,/class="slide-type-reserve">/);
  assert.match(html,/data-present-kind="title" aria-hidden="true"/);
 }
 assert.equal(renderPresentation(portal.slides,-99),renderPresentation(portal.slides,0));
 assert.equal(renderPresentation(portal.slides,999),renderPresentation(portal.slides,6));
});

test('모든 발표의 제목·본문이 순서대로 타이핑되고 11초 안에 완성된다',()=>{
 for(const slide of portal.slides){
  const f=fixture(slide);assert.ok(f.root.classes.has('is-typing'));assert.ok(f.outputs.every(el=>el.textContent===''));
  f.step();f.step();assert.ok(f.outputs[0].textContent.length>0);assert.equal(f.outputs[1].textContent,'');
  for(let i=0;i<600&&f.timers.size;i++)f.step();
  assert.deepEqual(f.outputs.map(el=>el.textContent),f.text);
  assert.equal(f.timers.size,0);assert.ok(f.elapsed()<=11000,`${slide.title}: ${f.elapsed()}ms`);
  assert.equal(f.button.disabled,true);assert.ok(!f.root.classes.has('is-typing'));
  f.cleanup();assert.equal(f.preference.listeners.size,0);assert.equal(f.document.listeners.size,0);assert.equal(f.window.listeners.size,0);assert.equal(f.button.listeners.size,0);
 }
});

test('전체 표시·모션 감소·백그라운드·인쇄는 진행 중인 텍스트를 즉시 완성한다',()=>{
 for(const reason of ['reveal','reduce','hidden','print','initial-reduce']){
  const f=fixture(portal.slides[2],reason==='initial-reduce');
  if(reason==='reveal')f.button.listeners.get('click')();
  if(reason==='reduce'){f.step();f.preference.matches=true;f.preference.listeners.get('change')();}
  if(reason==='hidden'){f.document.hidden=true;f.document.listeners.get('visibilitychange')();}
  if(reason==='print')f.window.listeners.get('beforeprint')();
  assert.deepEqual(f.outputs.map(el=>el.textContent),f.text,reason);assert.equal(f.timers.size,0);f.cleanup();
 }
});

test('발표를 넘기거나 종료한 뒤에는 이전 페이지 타이머와 이벤트가 남지 않는다',()=>{
 const old=fixture();old.step();old.step();const text=old.outputs.map(el=>el.textContent);old.cleanup();old.step();
 assert.deepEqual(old.outputs.map(el=>el.textContent),text);assert.equal(old.timers.size,0);
 assert.equal(old.preference.listeners.size+old.document.listeners.size+old.window.listeners.size+old.button.listeners.size,0);
 const next=fixture(portal.slides[1]);assert.ok(next.outputs.every(el=>el.textContent===''));next.button.listeners.get('click')();assert.equal(next.outputs[0].textContent,portal.slides[1].title);next.cleanup();
});
