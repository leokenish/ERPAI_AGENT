const e=s=>String(s??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const round=n=>Math.round(n*100)/100;
const regionSpecs={instructions:[30,48,244,188],guides:[30,264,244,222],support:[30,514,244,238],knowledge:[342,48,288,292],maps:[342,368,288,238],feedback:[342,634,288,118],code:[708,48,502,704]};
export function createMapLayout(data){
 const regions=data.groups.map(g=>{const [x,y,w,h]=regionSpecs[g.id];return {...g,x,y,w,h};});const nodes=[];
 for(const g of regions){const docs=data.documents.filter(d=>d.group===g.id).sort((a,b)=>a.path.localeCompare(b.path,'ko'));const cols=g.id==='code'?Math.ceil(Math.sqrt(docs.length*(g.w-40)/(g.h-86))):Math.min(6,Math.ceil(Math.sqrt(docs.length*(g.w-40)/(g.h-70))));const rows=Math.max(1,Math.ceil(docs.length/cols));const dx=(g.w-44)/Math.max(cols,1),dy=(g.h-80)/rows;
  docs.forEach((d,i)=>nodes.push({id:d.id,group:g.id,x:round(g.x+22+dx*(i%cols+.5)),y:round(g.y+62+dy*(Math.floor(i/cols)+.5)),w:g.id==='code'?13:18,h:g.id==='code'?11:14}));
 }
 const byId=new Map(nodes.map(n=>[n.id,n]));const groupsById=new Map(regions.map(g=>[g.id,g]));const bundles=new Map();
 for(const edge of data.edges){if(edge.kind==='mention')continue;const a=byId.get(edge.from),b=byId.get(edge.to);if(!a||!b||a.group===b.group)continue;const key=[a.group,b.group].sort().join('|');const bundle=bundles.get(key)||{a:groupsById.get(key.split('|')[0]),b:groupsById.get(key.split('|')[1]),count:0};bundle.count++;bundles.set(key,bundle);}
 return {width:1240,height:800,nodes,regions,bundles:[...bundles.values()]};
}
export function nodePort(a,b){const dx=b.x-a.x,dy=b.y-a.y;if(!dx&&!dy)return {x:a.x,y:a.y};const ratio=1/Math.max(Math.abs(dx)/(a.w/2),Math.abs(dy)/(a.h/2));return {x:round(a.x+dx*ratio),y:round(a.y+dy*ratio)};}
export function edgeGeometry(a,b){const from=nodePort(a,b),to=nodePort(b,a);return {from,to,path:`M${from.x},${from.y} L${to.x},${to.y}`};}
function bundlePath({a,b},i){if(a.x===b.x){const [u,v]=a.y<b.y?[a,b]:[b,a];return `M${u.x+u.w/2},${u.y+u.h} V${v.y}`;}
 const [l,r]=a.x<b.x?[a,b]:[b,a];const y1=l.y+l.h/2,y2=r.y+r.h/2;
 if(r.x-l.x>500){const track=16+(i%3)*7;return `M${l.x+l.w},${y1} H${l.x+l.w+25} V${track} H${r.x-25} V${y2} H${r.x}`;}
 const gutter=(l.x+l.w+r.x)/2;return `M${l.x+l.w},${y1} H${gutter} V${y2} H${r.x}`;
}
export function renderMapSVG(data,layout=createMapLayout(data)){
 const docs=new Map(data.documents.map(d=>[d.id,d]));return `<svg class="km-atlas-svg" data-map-svg viewBox="0 0 ${layout.width} ${layout.height}" role="group" aria-labelledby="km-atlas-title km-atlas-desc" tabindex="0"><title id="km-atlas-title">근로시간 에이전트 전체 문서 지도</title><desc id="km-atlas-desc">${data.documents.length}개 문서를 역할별 작은 노드로 배치했다. 방향키로 노드를 이동하고 Enter로 선택한다. 선택한 문서의 실제 링크가 강조된다.</desc><g class="km-bundles" data-map-bundles>${layout.bundles.map((b,i)=>`<path d="${bundlePath(b,i)}" stroke-width="${round(1+Math.log10(b.count+1))}"><title>${e(b.a.title)} ↔ ${e(b.b.title)}: ${b.count}개 MD 링크 (양방향 합계)</title></path>`).join('')}</g><g class="km-regions">${layout.regions.map(g=>`<g class="km-color-${g.id}"><rect class="km-region-bg" x="${g.x}" y="${g.y}" width="${g.w}" height="${g.h}" rx="14"/><rect class="km-region-swatch" x="${g.x+18}" y="${g.y+19}" width="7" height="19" rx="3"/><text class="km-region-title" x="${g.x+34}" y="${g.y+35}">${e(g.title)}</text><text class="km-region-count" x="${g.x+g.w-18}" y="${g.y+35}" text-anchor="end">${g.count}</text></g>`).join('')}</g><g class="km-all-edges" data-map-all-edges aria-hidden="true"></g><g class="km-active-edges" data-map-active-edges aria-hidden="true"></g><g class="km-atlas-nodes">${layout.nodes.map((n,i)=>{const d=docs.get(n.id);return `<g class="km-dot km-color-${n.group}" data-map-node="${n.id}" role="button" tabindex="${i===0?'0':'-1'}" aria-label="${e(d.title)} · ${e(d.path)}" aria-pressed="false" aria-haspopup="dialog" aria-controls="km-map-popover" aria-expanded="false"><rect class="km-node-hit" x="${n.x-10}" y="${n.y-10}" width="20" height="20" rx="4"/><rect class="km-node-mark" x="${n.x-n.w/2}" y="${n.y-n.h/2}" width="${n.w}" height="${n.h}" rx="2"/>${d.empty?`<path class="km-empty-mark" d="M${n.x-3},${n.y} h6"/>`:''}</g>`;}).join('')}</g></svg>`;
}
export function renderKnowledgeMap(data){return `<section class="km-atlas" data-map-atlas aria-label="전체 문서 관계 지도"><div class="km-atlas-heading"><div><div class="eyebrow">근로시간 지식 지도</div><h2>업무 지식의 전체 구조</h2><p>네모 하나는 문서 한 개를 뜻한다. 클릭하면 관련 문서와 말풍선이 표시된다.</p></div><button class="btn small" data-map-expand aria-pressed="false">지도 크게 보기 ⛶</button></div><div class="km-atlas-legend" aria-label="역할별 색상과 문서 수">${data.groups.map(g=>`<button class="km-color-${g.id}" data-map-region="${g.id}" title="${e(g.title)} 영역 확대"><i aria-hidden="true"></i>${e(g.title)} <b>${g.count}</b></button>`).join('')}</div><div class="km-atlas-toolbar"><div class="km-atlas-search"><label class="sr-only" for="km-map-search">지도 문서 검색</label><input id="km-map-search" data-map-search type="search" placeholder="지도에서 제목·파일명 찾기" autocomplete="off"><div data-map-search-results class="km-map-search-results" hidden></div></div><div class="km-camera-buttons"><button data-map-zoom="in" aria-label="지도 확대">＋</button><output data-map-scale aria-label="지도 배율">100%</output><button data-map-zoom="out" aria-label="지도 축소">−</button><button data-map-fit>전체 맞춤</button><button data-map-clear>선택 해제</button></div><label><input type="checkbox" data-map-lines> 모든 개별 연결선</label><label><input type="checkbox" data-map-mentions> 경로 언급</label></div><div class="km-atlas-stage" data-map-stage>${renderMapSVG(data)}<div class="km-map-tooltip" data-map-tooltip id="km-map-popover" role="dialog" aria-modal="false" aria-labelledby="km-map-popover-title" hidden></div></div><div class="km-atlas-status"><span data-map-status role="status">${data.documents.length}개 문서 전체 · 그룹 간 링크를 묶어 표시</span><span>드래그 이동 · Ctrl/⌘ + 휠 확대 · 방향키 탐색</span></div><div class="km-map-inspector" data-map-inspector><p>노드를 클릭하면 관계와 말풍선이 고정된다. 빈 곳을 클릭하면 선택이 해제된다.</p></div><p class="km-caption km-map-note">바깥 선은 그룹별 문서 링크를 묶어 표시한다. 문서를 선택하면 개별 링크와 탐색 방향을 볼 수 있다.</p></section>`;}
export function cameraZoom(camera,factor,point){const scale=Math.max(1,Math.min(8,camera.scale*factor)),ratio=camera.scale/scale;const p=point||{x:camera.x+camera.w/2,y:camera.y+camera.h/2};const w=1240/scale,h=800/scale;return {x:p.x-(p.x-camera.x)*ratio,y:p.y-(p.y-camera.y)*ratio,w,h,scale};}
export function clientToWorld(camera,rect,x,y){const s=Math.min(rect.width/camera.w,rect.height/camera.h);return {x:camera.x+(x-rect.left-(rect.width-camera.w*s)/2)/s,y:camera.y+(y-rect.top-(rect.height-camera.h*s)/2)/s};}
export function mountKnowledgeMap(root,data,{onSelect=()=>{},onRead=()=>{},onMentions=()=>{},hydrate=()=>{}}={}){
 if(!root)return {select(){},dispose(){}};
 const layout=createMapLayout(data),byId=new Map(layout.nodes.map(n=>[n.id,n])),docs=new Map(data.documents.map(d=>[d.id,d]));
 const $=s=>root.querySelector(s),svg=$('[data-map-svg]'),stage=$('[data-map-stage]'),tooltip=$('[data-map-tooltip]'),inspector=$('[data-map-inspector]');
 const elements=new Map([...root.querySelectorAll('[data-map-node]')].map(n=>[n.dataset.mapNode,n]));
 let camera={x:0,y:0,w:1240,h:800,scale:1},selected=null,hovered=null,mentions=false,allLines=false,drag=null,suppressClick=false,query='',disposed=false;
 let tipPosition=null,tipDrag=null;
 const doc=root.ownerDocument,bodyStyle=doc?.body?.style;let previousOverflow;
 const events=[];const listen=(el,type,fn,options)=>{el.addEventListener(type,fn,options);events.push(()=>el.removeEventListener(type,fn,options));};
 const activeEdges=()=>data.edges.filter(e=>mentions||e.kind!=='mention');
 function positionTip(){
  if(!selected||tooltip.hidden)return;
  const n=byId.get(selected),r=stage.getBoundingClientRect(),v=svg.getBoundingClientRect();
  if(tipPosition){placeTip(tipPosition.x,tipPosition.y);return;}
  const scale=Math.min(v.width/camera.w,v.height/camera.h);
  const x=v.left-r.left+(v.width-camera.w*scale)/2+(n.x-camera.x)*scale;
  const y=v.top-r.top+(v.height-camera.h*scale)/2+(n.y-camera.y)*scale;
  const w=tooltip.offsetWidth||310,h=tooltip.offsetHeight||240,gap=n.w*scale/2+14;
  const left=x+gap+w<=r.width-8?x+gap:x-gap-w;
  tooltip.style.left=Math.max(8,Math.min(r.width-w-8,left))+'px';
  tooltip.style.top=Math.max(8,Math.min(r.height-h-8,y-h/2))+'px';
 }
 function placeTip(x,y){
  const r=stage.getBoundingClientRect();
  tipPosition={x:Math.max(8,Math.min(Math.max(8,r.width-tooltip.offsetWidth-8),x)),y:Math.max(8,Math.min(Math.max(8,r.height-tooltip.offsetHeight-8),y))};
  tooltip.style.left=tipPosition.x+'px';tooltip.style.top=tipPosition.y+'px';
 }
 listen(tooltip,'pointerdown',event=>{
  if(event.button!==0||!event.target.closest?.('[data-map-tip-drag]')||event.target.closest?.('button,a'))return;
  event.preventDefault();event.stopPropagation();
  tipDrag={id:event.pointerId,x:event.clientX,y:event.clientY,left:parseFloat(tooltip.style.left)||8,top:parseFloat(tooltip.style.top)||8};
  tooltip.setPointerCapture?.(event.pointerId);
 });
 listen(tooltip,'pointermove',event=>{if(!tipDrag||tipDrag.id!==event.pointerId)return;event.preventDefault();placeTip(tipDrag.left+event.clientX-tipDrag.x,tipDrag.top+event.clientY-tipDrag.y);});
 const releaseTip=event=>{if(!tipDrag||tipDrag.id!==event.pointerId)return;tipDrag=null;tooltip.releasePointerCapture?.(event.pointerId);};
 listen(tooltip,'pointerup',releaseTip);listen(tooltip,'pointercancel',releaseTip);listen(tooltip,'lostpointercapture',()=>{tipDrag=null;});
 listen(tooltip,'keydown',event=>{if(!event.target.hasAttribute?.('data-map-tip-drag'))return;const delta={ArrowLeft:[-20,0],ArrowRight:[20,0],ArrowUp:[0,-20],ArrowDown:[0,20]}[event.key];if(!delta)return;event.preventDefault();event.stopPropagation();placeTip((parseFloat(tooltip.style.left)||8)+delta[0],(parseFloat(tooltip.style.top)||8)+delta[1]);});
 function view(){svg.setAttribute('viewBox',`${round(camera.x)} ${round(camera.y)} ${round(camera.w)} ${round(camera.h)}`);$('[data-map-scale]').textContent=Math.round(camera.scale*100)+'%';positionTip();}
 function fit(){camera={x:0,y:0,w:1240,h:800,scale:1};view();}
 function edgeMarkup(edge,active=false){const a=byId.get(edge.from),b=byId.get(edge.to);if(!a||!b)return '';const geo=edgeGeometry(a,b);const angle=Math.atan2(geo.to.y-geo.from.y,geo.to.x-geo.from.x),len=5;const bx=geo.to.x-Math.cos(angle)*len,by=geo.to.y-Math.sin(angle)*len;const arrow=`M${round(bx-Math.sin(angle)*2.5)},${round(by+Math.cos(angle)*2.5)} L${geo.to.x},${geo.to.y} L${round(bx+Math.sin(angle)*2.5)},${round(by-Math.cos(angle)*2.5)}`;
  return `<path class="${edge.kind==='mention'?'km-edge-mention':''}" d="${geo.path}"/>${active?`<path class="km-edge-arrow" d="${arrow}"/>`:''}`;
 }
 function paint(){if(disposed)return;const id=selected,edges=activeEdges(),related=new Set(id?[id]:[]);let chosen=[];if(id){chosen=edges.filter(e=>e.from===id||e.to===id);for(const edge of chosen){related.add(edge.from);related.add(edge.to);}}
  for(const [key,el] of elements){const d=docs.get(key),match=!query||(d.path+' '+d.title).toLowerCase().includes(query);el.classList.toggle('is-dim',Boolean((id&&!related.has(key))||!match));el.classList.toggle('is-selected',key===selected);el.classList.toggle('is-hovered',key===hovered);el.classList.toggle('is-related',!!id&&key!==id&&related.has(key));el.classList.toggle('is-search-match',!!query&&match);el.setAttribute('aria-pressed',String(key===selected));el.setAttribute('aria-expanded',String(key===selected));}
  $('[data-map-active-edges]').innerHTML=chosen.map(e=>edgeMarkup(e,true)).join('');$('[data-map-bundles]').classList.toggle('is-dim',!!id||allLines);
  $('[data-map-status]').textContent=id?`${docs.get(id).title} · 들어오는 링크 ${chosen.filter(e=>e.to===id).length} · 나가는 링크 ${chosen.filter(e=>e.from===id).length} · 전체 ${data.documents.length}개 문서 유지`:`${data.documents.length}개 문서 전체 · ${allLines?'모든 개별 링크 표시':'그룹 간 링크를 묶어 표시'}${query?' · 검색 결과 '+[...docs.values()].filter(d=>(d.path+' '+d.title).toLowerCase().includes(query)).length+'개':''}`;
 }
 function allEdges(){const host=$('[data-map-all-edges]');host.innerHTML=allLines?activeEdges().map(e=>edgeMarkup(e)).join(''):'';}
 function hideTip(){tooltip.hidden=true;}
 function showTip(){
  if(!selected){hideTip();return;}
  const d=docs.get(selected),g=data.groups.find(g=>g.id===d.group),edges=activeEdges();
  tooltip.innerHTML=`<div class="km-tip-heading" data-map-tip-drag tabindex="0" aria-label="말풍선 이동: 드래그하거나 방향키를 사용하세요" title="드래그해서 이동"><span class="km-tooltip-group km-color-${d.group}">${e(g.title)}</span><button class="km-tip-close" data-map-dismiss aria-label="문서 선택 해제">×</button></div><strong id="km-map-popover-title">${e(d.title)}</strong><code>${e(d.path)}</code><span>들어오는 링크 ${edges.filter(e=>e.to===selected).length} · 나가는 링크 ${edges.filter(e=>e.from===selected).length}</span><div class="km-tip-actions"><a class="btn small primary" href="${e(d.download)}" download="${e(d.path.split('/').pop())}">MD 받기 ↓</a><button class="btn small" data-map-read>본문 읽기 ↗</button></div><span class="km-tip-hint">상단을 드래그해 이동 · 빈 곳 클릭 또는 Esc로 닫기</span>`;
  tooltip.hidden=false;hydrate(tooltip);positionTip();
 }
 function inspect(){if(!selected){inspector.innerHTML='<p>노드를 클릭하면 관계와 말풍선이 고정된다. 빈 곳을 클릭하면 선택이 해제된다.</p>';return;}const d=docs.get(selected),g=data.groups.find(g=>g.id===d.group);inspector.innerHTML=`<div><span class="km-tooltip-group km-color-${d.group}">${e(g.title)}</span><strong>${e(d.title)}</strong><code>${e(d.path)}</code></div><div class="km-inspector-actions"><button class="btn small" data-map-center>선택 위치 확대</button><button class="btn small" data-map-read>본문 읽기 ↗</button><a class="btn small" href="${e(d.download)}" download="${e(d.path.split('/').pop())}">MD 받기 ↓</a></div>`;hydrate(inspector);}
 function select(id,{notify=false}={}){if(id&&!docs.has(id))return;if(id!==selected){tipPosition=null;tipDrag=null;}selected=id;hovered=null;if(id)for(const [key,el] of elements)el.setAttribute('tabindex',key===id?'0':'-1');inspect();showTip();paint();if(notify)onSelect(id);}
 function dismiss(restoreFocus=false){const previous=selected;if(!previous)return;select(null,{notify:true});if(restoreFocus)elements.get(previous)?.focus({preventScroll:true});}
 function center(node,scale=4){camera={x:node.x-1240/scale/2,y:node.y-800/scale/2,w:1240/scale,h:800/scale,scale};view();}
 function nodeTarget(event){return event.target.closest?.('[data-map-node]');}
 listen(root,'click',event=>{
  const n=nodeTarget(event);
  if(suppressClick){suppressClick=false;if(n||event.target===svg||svg.contains(event.target))return;}
  if(n){select(n.dataset.mapNode,{notify:true});return;}
  const b=event.target.closest?.('button');
  if(!b){if(!event.target.closest?.('a,input,label,[data-map-tooltip],[data-map-inspector],.km-atlas-toolbar,.km-atlas-legend'))dismiss();return;}
  if(b.hasAttribute('data-map-dismiss')){dismiss(true);return;}
  if(b.hasAttribute('data-map-zoom')){camera=cameraZoom(camera,b.dataset.mapZoom==='in'?1.4:1/1.4);view();}
  if(b.hasAttribute('data-map-fit'))fit();
  if(b.hasAttribute('data-map-clear')){select(null,{notify:true});query='';$('[data-map-search]').value='';$('[data-map-search-results]').hidden=true;paint();}
  if(b.hasAttribute('data-map-region')){const g=layout.regions.find(g=>g.id===b.dataset.mapRegion);const scale=Math.min(5,Math.min(1240/(g.w+48),800/(g.h+48)));center({x:g.x+g.w/2,y:g.y+g.h/2},scale);}
  if(b.hasAttribute('data-map-result')){select(b.dataset.mapResult,{notify:true});center(byId.get(selected));$('[data-map-search-results]').hidden=true;}
  if(b.hasAttribute('data-map-center')&&selected)center(byId.get(selected));
  if(b.hasAttribute('data-map-read')&&selected){onRead(selected);}
  if(b.hasAttribute('data-map-expand')){const expanded=root.classList.toggle('is-expanded');if(expanded&&bodyStyle){previousOverflow=bodyStyle.overflow;bodyStyle.overflow='hidden';}else if(bodyStyle&&previousOverflow!==undefined){bodyStyle.overflow=previousOverflow;previousOverflow=undefined;}b.setAttribute('aria-pressed',String(expanded));b.textContent=expanded?'크게 보기 닫기 ×':'지도 크게 보기 ⛶';positionTip();}
 });
 function closeExpanded(){root.classList.remove('is-expanded');if(bodyStyle&&previousOverflow!==undefined){bodyStyle.overflow=previousOverflow;previousOverflow=undefined;}const b=$('[data-map-expand]');b.setAttribute('aria-pressed','false');b.textContent='지도 크게 보기 ⛶';positionTip();}
 // Outside clicks dismiss the pin. Document-navigation controls may select a new node in their own click handler.
 if(doc?.addEventListener)listen(doc,'click',event=>{if(selected&&!root.contains(event.target)&&!event.target.closest?.('[data-km-doc],[data-km-group],[data-km-back-map],a[download]'))dismiss();});
 listen(root,'change',event=>{if(event.target.matches('[data-map-lines]')){allLines=event.target.checked;allEdges();paint();}if(event.target.matches('[data-map-mentions]')){mentions=event.target.checked;allEdges();showTip();paint();onMentions(mentions);}});
 listen(root,'input',event=>{if(!event.target.matches('[data-map-search]'))return;query=event.target.value.trim().toLowerCase();const found=[...docs.values()].filter(d=>(d.path+' '+d.title).toLowerCase().includes(query));const host=$('[data-map-search-results]');host.hidden=!query;host.innerHTML=found.length?`${found.slice(0,8).map(d=>`<button data-map-result="${d.id}"><span class="km-color-${d.group}">■</span><strong>${e(d.title)}</strong><code>${e(d.path)}</code></button>`).join('')}<span class="km-search-total">${found.length}개 일치${found.length>8?' · 상위 8개 표시':''}</span>`:'<span class="km-search-total">일치하는 문서가 없습니다.</span>';paint();});
 listen(svg,'pointerover',event=>{if(drag)return;const n=nodeTarget(event);if(!n)return;hovered=n.dataset.mapNode;paint();});
 listen(svg,'pointerout',event=>{if(!nodeTarget(event)||event.relatedTarget?.closest?.('[data-map-node]')===nodeTarget(event))return;hovered=null;paint();});
 listen(svg,'focusin',event=>{const n=nodeTarget(event);if(!n)return;hovered=n.dataset.mapNode;paint();});
 listen(svg,'focusout',()=>{hovered=null;paint();});
 listen(svg,'pointerdown',event=>{if(event.button!==0)return;suppressClick=false;drag={id:event.pointerId,x:event.clientX,y:event.clientY,camera:{...camera},moved:false,node:nodeTarget(event)?.dataset.mapNode};svg.setPointerCapture?.(event.pointerId);});
 listen(svg,'pointermove',event=>{if(!drag||event.pointerId!==drag.id)return;const dx=event.clientX-drag.x,dy=event.clientY-drag.y;if(Math.hypot(dx,dy)<4&&!drag.moved)return;drag.moved=true;hovered=null;const r=svg.getBoundingClientRect(),s=Math.min(r.width/drag.camera.w,r.height/drag.camera.h);camera={...drag.camera,x:drag.camera.x-dx/s,y:drag.camera.y-dy/s};view();});
 const release=event=>{if(!drag||drag.id!==event.pointerId)return;suppressClick=event.type!=='pointercancel'&&(drag.moved||!!drag.node);if(!drag.moved&&drag.node&&event.type!=='pointercancel')select(drag.node,{notify:true});svg.releasePointerCapture?.(event.pointerId);drag=null;paint();};listen(svg,'pointerup',release);listen(svg,'pointercancel',release);
 listen(svg,'wheel',event=>{if(!event.ctrlKey&&!event.metaKey)return;event.preventDefault();const p=clientToWorld(camera,svg.getBoundingClientRect(),event.clientX,event.clientY);camera=cameraZoom(camera,event.deltaY<0?1.15:1/1.15,p);view();},{passive:false});
 listen(root,'keydown',event=>{
  if(event.key==='Tab'&&root.classList.contains('is-expanded')){const items=[...root.querySelectorAll('button,input,a,[tabindex="0"]')].filter(el=>!el.hidden&&el.getClientRects().length);const first=items[0],last=items.at(-1);if((event.shiftKey&&event.target===first)||(!event.shiftKey&&event.target===last)){event.preventDefault();(event.shiftKey?last:first)?.focus();return;}}
  if(event.key==='Escape'){event.stopPropagation();event.preventDefault();if(selected)dismiss(true);else closeExpanded();$('[data-map-search-results]').hidden=true;return;}
  const el=nodeTarget(event);if(!el)return;const id=el.dataset.mapNode;
  if(event.key==='Enter'||event.key===' '){event.preventDefault();select(id,{notify:true});return;}
  const direction={ArrowLeft:[-1,0],ArrowRight:[1,0],ArrowUp:[0,-1],ArrowDown:[0,1]}[event.key];if(!direction)return;event.preventDefault();const here=byId.get(id);const candidates=layout.nodes.filter(n=>(n.x-here.x)*direction[0]+(n.y-here.y)*direction[1]>1).sort((a,b)=>{const score=n=>Math.hypot(n.x-here.x,n.y-here.y)+Math.abs((n.x-here.x)*direction[1]-(n.y-here.y)*direction[0])*3;return score(a)-score(b);});if(candidates[0]){el.setAttribute('tabindex','-1');const next=elements.get(candidates[0].id);next.setAttribute('tabindex','0');next.focus({preventScroll:true});}
 });
 if(typeof ResizeObserver!=='undefined'){const observer=new ResizeObserver(positionTip);observer.observe(stage);events.push(()=>observer.disconnect());}
 else if(doc?.defaultView?.addEventListener)listen(doc.defaultView,'resize',positionTip);
 hideTip();paint();return {select,dispose(){disposed=true;for(const remove of events)remove();hideTip();closeExpanded();}};
}
