import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {createMapLayout,edgeGeometry,renderMapSVG,cameraZoom,clientToWorld,mountKnowledgeMap} from '../site/knowledge-map.js';
const data=JSON.parse(await readFile(new URL('../dist/data/portal.json',import.meta.url),'utf8')).worktimeKnowledge;
const layout=createMapLayout(data),positions=new Map(layout.nodes.map(n=>[n.id,n]));
test('전체 MD 783개를 겹치지 않는 색상 그룹 노드로 배치한다',()=>{
 assert.equal(layout.nodes.length,783);assert.equal(new Set(layout.nodes.map(n=>n.id)).size,783);
 for(const g of layout.regions){const nodes=layout.nodes.filter(n=>n.group===g.id);assert.equal(nodes.length,g.count);for(const n of nodes){assert.ok(n.x-n.w/2>g.x&&n.x+n.w/2<g.x+g.w);assert.ok(n.y-n.h/2>g.y+48&&n.y+n.h/2<g.y+g.h);}}
 for(let i=0;i<layout.nodes.length;i++)for(let j=i+1;j<layout.nodes.length;j++){const a=layout.nodes[i],b=layout.nodes[j];assert.ok(Math.abs(a.x-b.x)>=(a.w+b.w)/2||Math.abs(a.y-b.y)>=(a.h+b.h)/2,`${a.id}/${b.id}`);}
 const svg=renderMapSVG(data,layout);assert.equal((svg.match(/data-map-node=/g)||[]).length,783);assert.ok(!svg.includes('km-focus-graph'));
});
test('모든 실제 연결선의 양 끝은 해당 노드 경계에 정확히 붙는다',()=>{
 function onBorder(p,n){const x=Math.abs(p.x-n.x),y=Math.abs(p.y-n.y);return x<=n.w/2+.02&&y<=n.h/2+.02&&(Math.abs(x-n.w/2)<.02||Math.abs(y-n.h/2)<.02);}
 for(const edge of data.edges){const a=positions.get(edge.from),b=positions.get(edge.to),geo=edgeGeometry(a,b);assert.ok(onBorder(geo.from,a));assert.ok(onBorder(geo.to,b));assert.ok(!/NaN|undefined/.test(geo.path));}
 const total=layout.bundles.reduce((n,b)=>n+b.count,0);assert.equal(total,data.edges.filter(e=>e.kind!=='mention'&&positions.get(e.from).group!==positions.get(e.to).group).length);
});
test('확대와 좁은 화면의 여백을 반영해 마우스 좌표를 같은 SVG 좌표로 변환한다',()=>{
 const initial={x:0,y:0,w:1240,h:800,scale:1},rect={left:10,top:20,width:620,height:500};
 const center=clientToWorld(initial,rect,320,270);assert.deepEqual(center,{x:620,y:400});
 const zoomed=cameraZoom(initial,2,center);assert.equal(zoomed.scale,2);assert.deepEqual(clientToWorld(zoomed,rect,320,270),center);
 assert.deepEqual(cameraZoom(zoomed,.5,center),initial);assert.equal(cameraZoom(initial,100).scale,8);assert.equal(cameraZoom(initial,.01).scale,1);
});
function fixture(){
 const all=[];const cls=()=>{const set=new Set();return {add:s=>set.add(s),remove:s=>set.delete(s),contains:s=>set.has(s),toggle(s,force){const on=force??!set.has(s);on?set.add(s):set.delete(s);return on;}};};
 function el(dataset={},kind='div',parent=null){
  const handlers=new Map(),attrs=new Map();
  const item={dataset,kind,parent,handlers,attrs,hidden:false,value:'',checked:false,innerHTML:'',textContent:'',style:{},classList:cls(),offsetWidth:310,offsetHeight:240,addEventListener:(t,f)=>handlers.set(t,f),removeEventListener:(t,f)=>{if(handlers.get(t)===f)handlers.delete(t);},setAttribute:(k,v)=>attrs.set(k,v),getAttribute:k=>attrs.get(k),hasAttribute:k=>attrs.has(k),getBoundingClientRect:()=>({left:0,top:0,width:1240,height:800,right:1240,bottom:800}),getClientRects:()=>[{}],focus(){item.focused=true;},scrollIntoView(){},setPointerCapture(){},releasePointerCapture(){},contains(target){for(let n=target;n;n=n.parent)if(n===item)return true;return false;},closest(selector){for(let n=item;n;n=n.parent)if(n.matches(selector))return n;return null;},matches(selector){return selector.split(',').some(part=>{const q=part.trim();if(q.startsWith('.'))return item.classList.contains(q.slice(1));const a=q.match(/^([a-z]*)\[([^\]]+)\]$/);if(a)return (!a[1]||a[1]===kind)&&attrs.has(a[2]);return q===kind;});}};
  for(const [k,v] of Object.entries(dataset))attrs.set('data-'+k.replace(/[A-Z]/g,c=>'-'+c.toLowerCase()),v);
  all.push(item);return item;
 }
 const document=el({},'document'),root=el({},'section',document),stage=el({mapStage:''},'div',root),svg=el({mapSvg:''},'svg',stage);
 document.body={style:{overflow:'auto'}};root.ownerDocument=document;
 const selectors=new Map([['[data-map-svg]',svg],['[data-map-stage]',stage]]);
 const nodes=layout.nodes.map(n=>el({mapNode:n.id},'g',svg));
 root.querySelector=s=>{if(!selectors.has(s)){const item=el({},'div',s==='[data-map-tooltip]'?stage:root);item.attrs.set(s.slice(1,-1),'');selectors.set(s,item);}return selectors.get(s);};root.querySelectorAll=()=>nodes;
 const selected=[],read=[],mentions=[],hydrated=[];
 const controller=mountKnowledgeMap(root,data,{onSelect:id=>selected.push(id),onRead:id=>read.push(id),onMentions:v=>mentions.push(v),hydrate:node=>hydrated.push(node)});
 const button=(name,value,parent=root)=>{const b=el({},'button',parent);b.attrs.set(name,'');if(value)b.dataset[name.replace(/^data-/,'').replace(/-([a-z])/g,(_,a)=>a.toUpperCase())]=value;return b;};
 const event=(target,extras={})=>({target,preventDefault(){this.prevented=true;},stopPropagation(){},...extras});
 const click=target=>{const ev=event(target);if(root.contains(target))root.handlers.get('click')(ev);document.handlers.get('click')?.(ev);return ev;};
 return {root,svg,stage,nodes,selectors,all,selected,read,mentions,hydrated,controller,button,event,el,document,click};
}
test('호버는 준비 표시만 하고 클릭하면 관계·말풍선·다운로드가 고정된다',()=>{
 const f=fixture(),n=f.nodes.find(n=>data.documents.find(d=>d.id===n.dataset.mapNode).path==='maps/topics/selective.md');
 const tip=f.root.querySelector('[data-map-tooltip]'),edges=f.root.querySelector('[data-map-active-edges]');
 f.svg.handlers.get('pointerover')(f.event(n,{clientX:1230,clientY:790}));assert.equal(tip.hidden,true);assert.equal(edges.innerHTML,'');assert.ok(n.classList.contains('is-hovered'));assert.ok(f.nodes.every(n=>!n.classList.contains('is-related')&&!n.classList.contains('is-dim')));
 f.click(n);assert.deepEqual(f.selected,[n.dataset.mapNode]);assert.equal(n.attrs.get('aria-pressed'),'true');assert.equal(n.attrs.get('aria-expanded'),'true');assert.equal(tip.hidden,false);assert.ok(parseFloat(tip.style.left)<=1240-310-8);assert.match(tip.innerHTML,/selective\.md/);assert.match(tip.innerHTML,/download="selective\.md"/);assert.match(tip.innerHTML,/MD 받기/);assert.ok(f.hydrated.includes(tip));assert.equal(f.nodes.length,783);assert.ok(f.nodes.some(n=>n.classList.contains('is-dim')));
 const fixedEdges=edges.innerHTML,fixedTip=tip.innerHTML;
 f.svg.handlers.get('pointerout')(f.event(n,{relatedTarget:tip}));assert.equal(tip.hidden,false);
 const other=f.nodes.find(other=>other!==n);f.svg.handlers.get('pointerover')(f.event(other));assert.equal(edges.innerHTML,fixedEdges);assert.equal(tip.innerHTML,fixedTip);assert.equal(n.attrs.get('aria-pressed'),'true');assert.equal(other.attrs.get('aria-pressed'),'false');
 const download=f.el({},'a',tip);download.attrs.set('download','selective.md');const downloadClick=f.click(download);assert.ok(!downloadClick.prevented);assert.equal(tip.hidden,false);assert.equal(f.selected.length,1);
 f.click(f.el({},'strong',tip));assert.equal(tip.hidden,false);assert.equal(f.selected.length,1);
 f.root.handlers.get('click')(f.event(f.button('data-map-read')));assert.deepEqual(f.read,[n.dataset.mapNode]);
 const input=f.root.querySelector('[data-map-search]');input.attrs.set('data-map-search','');input.value='없는문서-927164';f.root.handlers.get('input')(f.event(input));assert.match(f.root.querySelector('[data-map-search-results]').innerHTML,/일치하는 문서가 없습니다/);
 f.root.handlers.get('click')(f.event(f.button('data-map-zoom','in')));assert.notEqual(f.svg.attrs.get('viewBox'),'0 0 1240 800');assert.equal(tip.hidden,false);f.root.handlers.get('click')(f.event(f.button('data-map-fit')));assert.equal(f.svg.attrs.get('viewBox'),'0 0 1240 800');assert.equal(tip.hidden,false);
 const box=f.button('data-map-mentions');box.checked=true;f.root.handlers.get('change')(f.event(box));assert.deepEqual(f.mentions,[true]);
 f.root.handlers.get('click')(f.event(f.button('data-map-clear')));assert.equal(f.selected.at(-1),null);assert.ok(f.nodes.every(n=>!n.classList.contains('is-dim')));
 f.root.handlers.get('click')(f.event(f.button('data-map-expand')));assert.equal(f.root.ownerDocument.body.style.overflow,'hidden');f.controller.dispose();assert.equal(f.root.ownerDocument.body.style.overflow,'auto');assert.ok(f.all.every(el=>el.handlers.size===0));
});
test('포인터 캡처 후 클릭은 원래 노드를 선택하고 드래그는 문서를 바꾸지 않는다',()=>{
 const f=fixture(),n=f.nodes[0];
 f.svg.handlers.get('pointerdown')(f.event(n,{button:0,pointerId:1,clientX:50,clientY:100}));f.svg.handlers.get('pointerup')(f.event(f.svg,{type:'pointerup',pointerId:1,clientX:50,clientY:100}));assert.deepEqual(f.selected,[n.dataset.mapNode]);
 f.root.handlers.get('click')(f.event(f.svg));
 f.svg.handlers.get('pointerdown')(f.event(n,{button:0,pointerId:2,clientX:50,clientY:100}));f.svg.handlers.get('pointermove')(f.event(f.svg,{pointerId:2,clientX:150,clientY:200}));f.svg.handlers.get('pointerup')(f.event(f.svg,{type:'pointerup',pointerId:2}));assert.equal(f.selected.length,1);assert.notEqual(f.svg.attrs.get('viewBox'),'0 0 1240 800');f.click(f.svg);assert.equal(f.selected.length,1);assert.equal(f.root.querySelector('[data-map-tooltip]').hidden,false);f.controller.dispose();
});

test('다른 노드 클릭은 고정을 바꾸고 지도 빈 곳·지도 밖 클릭은 선택을 해제한다',()=>{
 const f=fixture(),tip=f.root.querySelector('[data-map-tooltip]');f.click(f.nodes[0]);f.click(f.nodes[1]);assert.equal(f.selected.at(-1),f.nodes[1].dataset.mapNode);assert.equal(f.nodes[0].attrs.get('aria-pressed'),'false');assert.equal(tip.hidden,false);
 f.click(f.svg);assert.equal(f.selected.at(-1),null);assert.equal(tip.hidden,true);assert.equal(f.root.querySelector('[data-map-active-edges]').innerHTML,'');assert.ok(f.nodes.every(n=>!n.classList.contains('is-selected')&&!n.classList.contains('is-dim')));
 f.click(f.nodes[0]);const outside=f.el({},'p',f.document);f.click(outside);assert.equal(f.selected.at(-1),null);assert.equal(tip.hidden,true);
 f.click(f.nodes[0]);const nav=f.el({kmDoc:f.nodes[1].dataset.mapNode},'a',f.document);f.controller.select(f.nodes[1].dataset.mapNode);f.click(nav);assert.equal(f.nodes[1].attrs.get('aria-pressed'),'true');assert.equal(tip.hidden,false);f.controller.dispose();assert.equal(f.document.handlers.size,0);
});
test('키보드·닫기 버튼으로 고정 말풍선을 해제하고 크게 보기와 선택을 구분한다',()=>{
 const f=fixture(),n=f.nodes[0],tip=f.root.querySelector('[data-map-tooltip]');
 f.svg.handlers.get('focusin')(f.event(n));assert.equal(tip.hidden,true);assert.equal(f.root.querySelector('[data-map-active-edges]').innerHTML,'');
 f.root.handlers.get('keydown')(f.event(n,{key:'Enter'}));assert.equal(tip.hidden,false);f.svg.handlers.get('focusout')(f.event(n));assert.equal(tip.hidden,false);
 f.click(f.button('data-map-expand'));f.root.handlers.get('keydown')(f.event(n,{key:'Escape'}));assert.equal(tip.hidden,true);assert.equal(f.selected.at(-1),null);assert.ok(n.focused);assert.equal(f.root.ownerDocument.body.style.overflow,'hidden');
 f.root.handlers.get('keydown')(f.event(n,{key:'Escape'}));assert.equal(f.root.ownerDocument.body.style.overflow,'auto');
 f.root.handlers.get('keydown')(f.event(n,{key:' '}));assert.equal(tip.hidden,false);f.click(f.button('data-map-dismiss',null,tip));assert.equal(tip.hidden,true);assert.equal(f.selected.at(-1),null);f.controller.dispose();
});
