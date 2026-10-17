import test from 'node:test';
import assert from 'node:assert/strict';
import vm from 'node:vm';
import {readFile} from 'node:fs/promises';
import {countNumber} from '../site/count-up.js';

const source=(await readFile(new URL('../site/count-up.js',import.meta.url),'utf8')).replace(/^export /gm,'');
function setup({reduced=false,hidden=false,observe=true}={}) {
 const events=()=>({listeners:new Map(),addEventListener(k,v){this.listeners.set(k,v);},removeEventListener(k,v){if(this.listeners.get(k)===v)this.listeners.delete(k);}});
 const preference=Object.assign(events(),{matches:reduced});
 const document=Object.assign(events(),{hidden});
 const window=Object.assign(events(),{matchMedia:()=>preference});
 const outputs=[{textContent:'08'},{textContent:'9,425'}];
 const items=outputs.map((output,i)=>({dataset:{countTo:String(i?9425:8),countDigits:String(i?1:2)},querySelector:()=>output}));
 const root={querySelectorAll:()=>items},frames=new Map();let id=0,observer;
 class Observer {constructor(callback){this.callback=callback;this.observed=new Set();observer=this;}observe(el){this.observed.add(el);}unobserve(el){this.observed.delete(el);}disconnect(){this.observed.clear();}}
 const ctx=vm.createContext({window,document,requestAnimationFrame:fn=>{frames.set(++id,fn);return id;},cancelAnimationFrame:id=>frames.delete(id),...(observe?{IntersectionObserver:Observer}:{})});
 vm.runInContext(source,ctx);
 const cleanup=vm.runInContext('mountCountUps',ctx)(root);
 const step=time=>{const pending=[...frames.values()];frames.clear();pending.forEach(fn=>fn(time));};
 const enter=(index=0)=>observer.callback([{target:items[index],isIntersecting:true}]);
 return {preference,document,window,outputs,frames,cleanup,step,enter,get observer(){return observer;}};
}
test('통계는 고정 폭과 접근성용 최종값을 제공하고 자릿수·천 단위 구분을 유지한다',()=>{
 assert.match(countNumber(8,2),/class="count-up-accessible">08</);
 assert.match(countNumber(9425),/class="count-up-width" aria-hidden="true">9,425</);
 assert.equal((countNumber(13).match(/aria-hidden="true"/g)||[]).length,2);
 for(const n of [-1,Infinity,NaN,1.5])assert.throws(()=>countNumber(n));
});
test('화면 진입 때 시작하여 감속하고 정확한 최종값에서 멈추며 재진입 시 반복하지 않는다',()=>{
 const f=setup();assert.equal(f.frames.size,0);assert.equal(f.outputs[1].textContent,'9,425');
 f.enter(1);assert.equal(f.outputs[1].textContent,'0');
 const values=[];for(const t of [0,400,800,1200,1600]){f.step(t);values.push(Number(f.outputs[1].textContent.replaceAll(',','')));}
 const steps=values.slice(1).map((n,i)=>n-values[i]);
 assert.ok(steps.every((n,i)=>!i||n<steps[i-1]));
 assert.equal(values.at(-1),9425);assert.equal(f.frames.size,0);
 f.enter(1);assert.equal(f.outputs[1].textContent,'9,425');assert.equal(f.frames.size,0);f.cleanup();
});
test('숨긴 탭에서는 멈추고 돌아오면 같은 위치에서 이어간다',()=>{
 const f=setup({hidden:true});f.enter();assert.equal(f.frames.size,0);
 f.document.hidden=false;f.document.listeners.get('visibilitychange')();f.step(100);f.step(300);
 const value=f.outputs[0].textContent;
 f.document.hidden=true;f.document.listeners.get('visibilitychange')();assert.equal(f.frames.size,0);
 f.document.hidden=false;f.document.listeners.get('visibilitychange')();f.step(90000);assert.equal(f.outputs[0].textContent,value);
 f.step(91600);assert.equal(f.outputs[0].textContent,'08');f.cleanup();
});
test('모션 감소 설정과 인쇄 시에는 즉시 최종값을 표시한다',()=>{
 const reduced=setup({reduced:true});assert.equal(reduced.frames.size,0);assert.equal(reduced.outputs[0].textContent,'08');reduced.cleanup();
 for(const action of ['preference','print']){
  const f=setup();f.enter();f.step(0);
  if(action==='preference'){f.preference.matches=true;f.preference.listeners.get('change')();}
  else f.window.listeners.get('beforeprint')();
  assert.equal(f.outputs[0].textContent,'08');assert.equal(f.outputs[1].textContent,'9,425');assert.equal(f.frames.size,0);assert.equal(f.observer.observed.size,0);f.cleanup();
 }
});
test('페이지 이탈 시 프레임·이벤트·관찰자를 정리하고 새 페이지는 다시 재생한다',()=>{
 const f=setup();f.enter();f.step(0);f.cleanup();f.step(500);
 assert.equal(f.frames.size,0);assert.equal(f.observer.observed.size,0);
 for(const target of [f.window,f.document,f.preference])assert.equal(target.listeners.size,0);
 f.enter();assert.equal(f.frames.size,0);
 const next=setup();next.enter();assert.equal(next.outputs[0].textContent,'00');next.cleanup();
});
test('IntersectionObserver가 없는 환경에서도 최종 통계로 완료한다',()=>{
 const f=setup({observe:false});assert.equal(f.frames.size,1);f.step(0);f.step(1600);
 assert.deepEqual(f.outputs.map(o=>o.textContent),['08','9,425']);assert.equal(f.frames.size,0);f.cleanup();
});
