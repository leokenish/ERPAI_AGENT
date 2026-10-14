import test from 'node:test';
import assert from 'node:assert/strict';
import vm from 'node:vm';
import {readFile} from 'node:fs/promises';
const source=await readFile(new URL('../site/theme.js',import.meta.url),'utf8');
function setup(saved,{blocked=false,loading=true}={}){
 const documentEvents=new Map(),windowEvents=new Map(),writes=[],timers=new Map();
 let timerId=0;
 const buttons=['light','dark'].map(themeChoice=>({dataset:{themeChoice},attributes:{},listeners:new Map(),setAttribute(k,v){this.attributes[k]=v;},addEventListener(k,v){this.listeners.set(k,v);}}));
 const meta={setAttribute(k,v){this[k]=v;}};
 const document={readyState:loading?'loading':'complete',documentElement:{dataset:{}},querySelector:()=>meta,querySelectorAll:()=>document.readyState==='loading'?[]:buttons,addEventListener:(k,v)=>documentEvents.set(k,v)};
 const window={addEventListener:(k,v)=>windowEvents.set(k,v),setTimeout:fn=>{timers.set(++timerId,fn);return timerId;},clearTimeout:id=>timers.delete(id)};
 const localStorage={getItem:()=>{if(blocked)throw Error('blocked');return saved;},setItem:(k,v)=>{if(blocked)throw Error('blocked');writes.push([k,v]);}};
 vm.runInNewContext(source,{window,document,localStorage});
 function mount(){document.readyState='complete';documentEvents.get('DOMContentLoaded')?.();}
 return {document,buttons,meta,writes,mount,windowEvents,timers};
}
test('저장한 모드를 본문 생성 전에 적용하고 선택 버튼과 동기화한다',()=>{
 const f=setup('dark');assert.equal(f.document.documentElement.dataset.theme,'dark');assert.equal(f.meta.content,'#111722');
 f.mount();assert.equal(f.buttons[1].attributes['aria-pressed'],'true');assert.equal(f.buttons[0].attributes['aria-pressed'],'false');
 f.buttons[0].listeners.get('click')();assert.equal(f.document.documentElement.dataset.theme,'light');
 assert.deepEqual(f.writes,[['erp-ai-theme-v1','light']]);assert.equal(f.buttons[1].attributes['aria-pressed'],'false');
});
test('저장소 차단·잘못된 저장값에서도 모드 전환이 동작한다',()=>{
 for(const opts of [{blocked:true},{blocked:false}]){
  const f=setup('invalid',opts);f.mount();assert.equal(f.document.documentElement.dataset.theme,'light');
  f.buttons[1].listeners.get('click')();assert.equal(f.document.documentElement.dataset.theme,'dark');
 }
});
test('다른 탭의 선택과 설정 초기화가 반영된다',()=>{
 const f=setup('light',{loading:false});const storage=f.windowEvents.get('storage');
 storage({key:'erp-ai-theme-v1',newValue:'dark'});assert.equal(f.document.documentElement.dataset.theme,'dark');
 storage({key:'unrelated',newValue:'light'});assert.equal(f.document.documentElement.dataset.theme,'dark');
 storage({key:null,newValue:null});assert.equal(f.document.documentElement.dataset.theme,'light');assert.equal(f.writes.length,0);
});
test('초기 로드는 페이드 없이 적용하고 빠른 재전환은 마지막 선택으로 끝난다',()=>{
 const f=setup('dark');f.mount();assert.equal(f.document.documentElement.dataset.themeMotion,undefined);
 for(const i of [0,1,0])f.buttons[i].listeners.get('click')();
 assert.equal(f.document.documentElement.dataset.theme,'light');
 assert.equal(f.document.documentElement.dataset.themeMotion,'on');assert.equal(f.timers.size,1);
 [...f.timers.values()][0]();assert.equal(f.document.documentElement.dataset.themeMotion,undefined);
 assert.equal(f.buttons[0].attributes['aria-pressed'],'true');
});
