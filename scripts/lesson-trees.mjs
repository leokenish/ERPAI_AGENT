import {readFile,realpath} from 'node:fs/promises';
import path from 'node:path';
import {escapeHTML} from './markdown.mjs';

// Only authored lesson diagrams use this renderer. Source Markdown still escapes HTML.
export async function loadLessonTrees(root,sources){
 const definitions=JSON.parse(await readFile(path.join(root,'content/lesson-trees.json'),'utf8'));
 const compiled=new Map();
 for(const [id,tree] of Object.entries(definitions)){
  if(!/^[a-z0-9-]+$/.test(id))throw Error('Invalid lesson tree id');
  const source=sources.find(s=>s.id===tree.source);
  if(!source)throw Error(`Unknown tree source: ${tree.source}`);
  const sourceRoot=await realpath(path.join(root,source.path));
  const search=[];
  const documents=[];
  const context=[];
  async function node(n,depth=0){
   if(depth>7||!n.label||typeof n.label!=='string')throw Error('Invalid lesson tree node');
   search.push(n.label,n.role||'',n.note||'');
   let label=`<strong>${escapeHTML(n.label)}</strong>`;
   if(n.path){
    if(typeof n.path!=='string'||path.posix.isAbsolute(n.path)||n.path.includes('\\')||n.path.split('/').some(p=>p==='..'||p==='')||!n.path.endsWith('.md'))throw Error('Invalid tree document path');
    const actual=await realpath(path.join(sourceRoot,n.path));
    if(!actual.startsWith(sourceRoot+path.sep))throw Error('Tree document escapes source');
    const document=source.mdDocuments?.find(d=>d.path===n.path);
    if(!document||!/^downloads\/source-md\/[a-z0-9-]+\/\d+\.md$/.test(document.download))throw Error(`Missing tree download: ${source.id}/${n.path}`);
    label=`<a href="${escapeHTML(document.download)}" download="${escapeHTML(path.posix.basename(n.path))}" aria-label="${escapeHTML(n.label)} 다운로드"><strong>${escapeHTML(n.label)}</strong></a>`;
    search.push(n.path);
    documents.push({...n,download:document.download});
   }
   if(!n.path)context.push(n);
   const children=n.children?.length?`<ul>${(await Promise.all(n.children.map(c=>node(c,depth+1)))).join('')}</ul>`:'';
   return `<li><div class="document-tree-node">${n.role?`<span class="document-tree-role">${escapeHTML(n.role)}</span>`:''}${label}${n.note?`<p>${escapeHTML(n.note)}</p>`:''}</div>${children}</li>`;
  }
  const body=await node(tree.root);
  const diagram=tree.graph?renderDocumentGraph(id,tree,documents,context):`<ul class="document-tree-root">${body}</ul>`;
  compiled.set(id,{html:`<figure class="document-tree" aria-label="${escapeHTML(tree.title)}"><figcaption><span>파일 관계도</span><strong>${escapeHTML(tree.title)}</strong><p>${escapeHTML(tree.description)}</p></figcaption>${diagram}</figure>`,search:search.join(' ')});
 }
 return {
  render(id){const t=compiled.get(id.trim());if(!t)throw Error(`Unknown lesson tree: ${id}`);return t.html;},
  search(id){return compiled.get(id.trim())?.search||'';}
 };
}


// Authored reading relationships only; every endpoint resolves to a published MD.
function renderDocumentGraph(id,tree,documents,context){
 const graph=tree.graph;
 const byPath=new Map(documents.map(d=>[d.path,d]));
 const order=[graph.center,...graph.orbit];
 if(documents.length!==byPath.size||order.length!==documents.length||new Set(order).size!==order.length||order.some(p=>!byPath.has(p))||order.length<2||order.length>9)throw Error(`Invalid graph documents: ${id}`);
 const nodes=order.map((p,index)=>({...byPath.get(p),index}));
 const indices=new Map(nodes.map(n=>[n.path,n.index]));
 const edgeKeys=new Set();
 const edges=graph.links.map(edge=>{
  const from=indices.get(edge.from),to=indices.get(edge.to),key=[from,to].sort((a,b)=>a-b).join('-');
  if(from===undefined||to===undefined||from===to||!edge.label||edgeKeys.has(key))throw Error(`Invalid graph relationship: ${id}`);
  edgeKeys.add(key);return {...edge,from,to};
 });
 const visited=new Set([0]);
 for(let i=0;i<nodes.length;i++)for(const e of edges){if(visited.has(e.from))visited.add(e.to);if(visited.has(e.to))visited.add(e.from);}
 if(visited.size!==nodes.length)throw Error(`Disconnected graph document: ${id}`);
 const positions=[[500,450],[500,100],[780,220],[860,450],[780,680],[500,800],[220,680],[140,450],[220,220]];
 const slots=nodes.length===7?[0,1,2,4,5,6,8]:nodes.map((_,i)=>i);
 const group=p=>p.startsWith('.agents/')?'skill':p.startsWith('knowledge/')?'knowledge':p.startsWith('maps/')?'map':p.startsWith('harness/')?'feedback':p.startsWith('tests/')?'review':'guide';
 const lines=edges.map(e=>{
  const [x1,y1]=positions[slots[e.from]],[x2,y2]=positions[slots[e.to]];
  return `<line x1="${x1}" y1="${y1}" x2="${x2}" y2="${y2}" data-graph-from="${e.from}" data-graph-to="${e.to}"/>`;
 }).join('');
 const cards=nodes.map(n=>`<div class="document-graph-node document-slot-${slots[n.index]} document-kind-${group(n.path)}" data-graph-card="${n.index}"><button type="button" class="document-graph-select" data-graph-select="${n.index}" aria-label="${escapeHTML(n.label)} 연결 보기" aria-pressed="false" aria-controls="${id}-detail-${n.index}"><span class="document-graph-square" aria-hidden="true"></span><span>${escapeHTML(n.role||'문서')}</span></button><a class="document-graph-download" href="${escapeHTML(n.download)}" download="${escapeHTML(path.posix.basename(n.path))}" aria-label="${escapeHTML(n.label)} 다운로드">${escapeHTML(path.posix.basename(n.path))}</a></div>`).join('');
 const panels=nodes.map(n=>{
  const related=edges.filter(e=>e.from===n.index||e.to===n.index).map(e=>{
   const other=nodes[e.from===n.index?e.to:e.from];
   return `<li><button type="button" data-graph-select="${other.index}">${escapeHTML(other.role||'문서')} · ${escapeHTML(path.posix.basename(other.path))}</button><span>${escapeHTML(e.label)}</span></li>`;
  }).join('');
  return `<section class="document-graph-detail" id="${id}-detail-${n.index}" data-graph-detail="${n.index}" hidden><div><span class="document-graph-detail-role">${escapeHTML(n.role||'문서')}</span><strong>${escapeHTML(n.label)}</strong><p>${escapeHTML(n.note||'')}</p><code>${escapeHTML(n.path)}</code></div><div><h4>함께 읽을 문서</h4><ul>${related}</ul></div></section>`;
 }).join('');
 const notes=context.filter(n=>n.note).map(n=>`<p><b>${escapeHTML(n.label)}</b> · ${escapeHTML(n.note)}</p>`).join('');
 return `<div class="document-graph" data-document-graph><div class="document-graph-toolbar"><span>${nodes.length}개 MD · 문서별 연결</span><button type="button" data-graph-reset>전체 연결</button></div><div class="document-graph-scroll" tabindex="0" aria-label="${escapeHTML(tree.title)}. 좁은 화면에서는 좌우로 이동할 수 있습니다."><div class="document-graph-stage"><svg class="document-graph-lines" viewBox="0 0 1000 900" preserveAspectRatio="none" aria-hidden="true" focusable="false">${lines}</svg>${cards}</div></div><div class="document-graph-status" data-graph-status role="status" aria-live="polite">문서의 역할을 선택하면 연결 설명이 표시됩니다.</div>${panels}${notes?`<div class="document-graph-context">${notes}</div>`:''}</div>`;
}
