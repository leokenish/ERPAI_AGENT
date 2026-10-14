import test from 'node:test';
import assert from 'node:assert/strict';
import vm from 'node:vm';
import {readFile} from 'node:fs/promises';

// Behavioral lifecycle tests, without claiming browser layout verification.
const source=(await readFile(new URL('../site/hero-motion.js',import.meta.url),'utf8')).replace('export function','function');
function setup(reduced=false){
 const timers=new Map();let seq=0, completed=0;
 function el(){const classes=new Set(),listeners=new Map();return {classes,listeners,textContent:'',dataset:{},classList:{add:x=>classes.add(x),remove:x=>classes.delete(x),toggle:(x,v)=>v?classes.add(x):classes.delete(x)},setAttribute(k,v){this[k]=v;},addEventListener(k,v){listeners.set(k,v);},removeEventListener(k,v){if(listeners.get(k)===v)listeners.delete(k);}};}
 const outputs=['ERP AI,','이해에서 실무로.'].map(text=>Object.assign(el(),{dataset:{text},textContent:text}));
 const button=el(),root=el(),document=Object.assign(el(),{hidden:false}),preference=Object.assign(el(),{matches:reduced});
 root.querySelectorAll=()=>outputs;root.querySelector=()=>button;
 const context=vm.createContext({document,setTimeout:fn=>{timers.set(++seq,fn);return seq;},clearTimeout:id=>timers.delete(id)});
 vm.runInContext(source,context);
 const mount=vm.runInContext('mountHeroMotion',context);
 const cleanup=mount(root,{preference,onTyped:()=>completed++});
 const step=()=>{const first=timers.entries().next().value;if(first){timers.delete(first[0]);first[1]();}};
 return {outputs,button,root,document,preference,timers,cleanup,step,completed:()=>completed};
}
test('제목은 한글 음절 단위로 완성되고 타이머를 남기지 않는다',()=>{
 const f=setup();assert.equal(f.outputs[0].textContent,'');
 f.step();assert.equal(f.outputs[0].textContent,'E');
 for(let n=0;n<40;n++)f.step();
 assert.equal(f.outputs[0].textContent,'ERP AI,');assert.equal(f.outputs[1].textContent,'이해에서 실무로.');
 assert.equal(f.completed(),1);assert.equal(f.timers.size,0);
 f.cleanup();assert.equal(f.preference.listeners.size,0);assert.equal(f.document.listeners.size,0);
});
test('모션 감소 설정은 처음부터 또는 타이핑 중에 적용되어도 완성된 제목을 표시한다',()=>{
 for(const immediate of [true,false]){
  const f=setup(immediate);
  if(!immediate){f.step();f.preference.matches=true;f.preference.listeners.get('change')();}
  assert.equal(f.timers.size,0);assert.equal(f.outputs[1].textContent,'이해에서 실무로.');
  f.cleanup();
 }
});
test('정지 버튼 없이 동작하고 페이지 이탈·재방문에 타이머를 남기지 않는다',()=>{
 const f=setup();assert.equal(f.button.listeners.size,0);f.step();
 const before=f.outputs[0].textContent;f.cleanup();f.step();
 assert.equal(f.outputs[0].textContent,before);assert.equal(f.timers.size,0);
 assert.equal(f.document.listeners.size,0);assert.equal(f.preference.listeners.size,0);
 const hidden=setup();hidden.document.hidden=true;hidden.document.listeners.get('visibilitychange')();
 assert.equal(hidden.outputs[1].textContent,'이해에서 실무로.');assert.equal(hidden.timers.size,0);hidden.cleanup();
});
