import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile,mkdtemp,mkdir,writeFile,rm} from 'node:fs/promises';
import {tmpdir} from 'node:os';
import path from 'node:path';
import {loadLessonTrees} from '../scripts/lesson-trees.mjs';
import {mountDocumentGraphs} from '../site/document-graphs.js';
function fixture(){
 const classes=()=>{const set=new Set();return {toggle(c,on){on?set.add(c):set.delete(c);},contains:c=>set.has(c)};};
 const buttons=[0,1,2].map(i=>({dataset:{graphSelect:String(i)},attributes:{},setAttribute(k,v){this.attributes[k]=v;},focus(){this.focused=true;}}));
 const cards=buttons.map((b,i)=>({dataset:{graphCard:String(i)},classList:classes(),querySelector:s=>s==='button'||s==='[data-graph-select]'?b:{textContent:`doc-${i}.md`}}));
 const edges=[[0,1],[1,2]].map(([a,b])=>({dataset:{graphFrom:String(a),graphTo:String(b)},classList:classes()}));
 const panels=buttons.map((_,i)=>({dataset:{graphDetail:String(i)},hidden:true}));
 const handlers=new Map(),status={};
 const graph={querySelectorAll:s=>s==='[data-graph-card]'?cards:s==='[data-graph-from]'?edges:panels,querySelector:()=>status,addEventListener:(k,v)=>handlers.set(k,v),removeEventListener:k=>handlers.delete(k)};
 const root={querySelectorAll:()=>[graph]};
 const click=index=>handlers.get('click')({target:{closest:s=>s.includes('data-graph-select')?{dataset:{graphSelect:String(index)},hasAttribute:()=>false}:null}});
 return {root,cards,buttons,edges,panels,handlers,status,click};
}
test('문서 선택은 관련 연결과 역할을 바꾸고 키보드·전체 연결·페이지 해제를 지원한다',()=>{
 const f=fixture(),cleanup=mountDocumentGraphs(f.root);
 assert.equal(f.panels[0].hidden,false);assert.ok(f.edges[0].classList.contains('is-connected'));assert.ok(f.cards[2].classList.contains('is-muted'));
 f.handlers.get('click')({target:{closest:()=>({dataset:{graphSelect:'1'},hasAttribute:()=>false,closest:()=>({})})}});
 assert.ok(f.buttons[1].focused);
 assert.equal(f.panels[1].hidden,false);assert.equal(f.panels[0].hidden,true);assert.ok(f.edges.every(e=>e.classList.contains('is-connected')));assert.match(f.status.textContent,/2개/);
 let prevented=false;f.handlers.get('keydown')({target:f.buttons[1],key:'ArrowRight',preventDefault(){prevented=true;}});
 assert.ok(prevented);assert.ok(f.buttons[2].focused);assert.equal(f.buttons[2].attributes['aria-pressed'],'true');
 f.handlers.get('keydown')({key:'Escape'});assert.ok(f.panels.every(p=>p.hidden));assert.ok(f.cards.every(c=>!c.classList.contains('is-muted')));
 cleanup();assert.equal(f.handlers.size,0);
});
test('파일명 다운로드 클릭은 연결 선택을 가로채거나 기본 동작을 취소하지 않는다',()=>{
 const f=fixture();mountDocumentGraphs(f.root);let prevented=false;
 f.handlers.get('click')({target:{closest:s=>s==='[data-graph-select],[data-graph-reset]'?null:{}},preventDefault(){prevented=true;}});
 assert.equal(prevented,false);assert.equal(f.panels[0].hidden,false);
});
test('관계도는 존재하지 않는 연결·중복 노드·고립 문서를 빌드에서 거부한다',async t=>{
 const dir=await mkdtemp(path.join(tmpdir(),'radial-docs-'));t.after(()=>rm(dir,{recursive:true,force:true}));
 await mkdir(path.join(dir,'content'));await mkdir(path.join(dir,'sources/test'),{recursive:true});
 for(const name of ['A.md','B.md','C.md'])await writeFile(path.join(dir,'sources/test',name),'# '+name);
 const source={id:'test',path:'sources/test',mdDocuments:['A.md','B.md','C.md'].map((p,i)=>({path:p,download:`downloads/source-md/test/000${i}.md`}))};
 const definition={sample:{source:'test',title:'문서 연결',description:'문서',root:{label:'A',path:'A.md',children:[{label:'B',path:'B.md'},{label:'C',path:'C.md'}]},graph:{center:'A.md',orbit:['B.md','C.md'],links:[{from:'A.md',to:'B.md',label:'절차'},{from:'B.md',to:'C.md',label:'근거'}]}}};
 const compile=async()=>{await writeFile(path.join(dir,'content/lesson-trees.json'),JSON.stringify(definition));return loadLessonTrees(dir,[source]);};
 assert.match((await compile()).render('sample'),/data-document-graph/);
 definition.sample.graph.links[1].to='unknown.md';await assert.rejects(compile(),/Invalid graph relationship/);
 definition.sample.graph.links.pop();await assert.rejects(compile(),/Disconnected graph/);
 definition.sample.graph.orbit=['B.md','B.md'];await assert.rejects(compile(),/Invalid graph documents/);
});
test('05–07 방사형 관계도는 모든 기존 MD를 유지하고 서버·오프라인 실행에서 같은 기능을 쓴다',async()=>{
 const root=new URL('../',import.meta.url),portal=JSON.parse(await readFile(new URL('dist/data/portal.json',root),'utf8'));
 for(const [id,count] of [['knowledge',9],['maps',9],['feedback',7]]){
  const html=portal.lessons.find(l=>l.id===id).html;
  assert.equal((html.match(/data-graph-card=/g)||[]).length,count);
  assert.equal((html.match(/class="document-graph-download"/g)||[]).length,count);
  assert.doesNotMatch(html,/style="|onclick=/);
 }
 const preview=await readFile(new URL('scripts/build-preview.mjs',root),'utf8');assert.match(preview,/readScript\('document-graphs.js'\)/);
});
