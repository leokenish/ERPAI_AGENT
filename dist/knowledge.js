import {countNumber} from './count-up.js?v=c57d04c165ff';
import {renderKnowledgeMap,mountKnowledgeMap} from './knowledge-map.js?v=c57d04c165ff';
const escape=s=>String(s??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const link=id=>`#/learn/worktime-agent?doc=${id}`;
const kindLabel=k=>k==='mention'?'경로 언급':k==='wiki'?'Wikilink':'문서 링크';
const number=n=>Number(n).toLocaleString('ko-KR');
export function filterDocuments(data,{group='all',folder='all',query=''}={}){
 const terms=query.trim().toLocaleLowerCase().split(/\s+/).filter(Boolean);
 return data.documents.filter(d=>(group==='all'||d.group===group)&&(folder==='all'||d.path.startsWith(folder))&&terms.every(t=>(d.path+' '+d.title+' '+d.summary).toLocaleLowerCase().includes(t))).sort((a,b)=>Number(/(?:INDEX|README)\.md$/.test(b.path))-Number(/(?:INDEX|README)\.md$/.test(a.path))||a.path.localeCompare(b.path,'ko'));
}
export function connections(data,id,{mentions=false}={}){
 const edges=data.edges.filter(e=>mentions||e.kind!=='mention');
 return {incoming:edges.filter(e=>e.to===id),outgoing:edges.filter(e=>e.from===id)};
}
function overview(data){return renderKnowledgeMap(data)+`<details class="km-role-guide"><summary>각 그룹이 맡은 역할과 관리 기준</summary><div class="km-role-grid">${data.groups.map(g=>`<button class="km-role km-color-${g.id}" data-km-group="${g.id}" type="button"><strong>${escape(g.title)} · ${g.count} MD</strong><code>${escape(g.folder)}</code><span>${escape(g.purpose)}</span><span class="km-role-action">대표 문서 선택 ↗</span></button>`).join('')}</div></details>`;}
export function renderKnowledge(data){return `<section class="knowledge-portal" data-knowledge aria-label="근로시간 업무지식 지도"><p class="km-intro">근로시간 규정·협의 이력·소스 설명을 연결한 지도입니다. 문서를 선택해 관련 근거를 따라가 보세요.</p><div class="km-statbar"><div><strong>${countNumber(data.summary.documents)}</strong><span>Markdown 문서</span></div><div><strong>${countNumber(data.summary.topics)}</strong><span>업무별 지도</span></div><div><strong>${countNumber(data.summary.explicitLinks)}</strong><span>문서 사이 링크</span></div><a class="btn" href="${data.archive}" download>전체 MD ZIP 받기 ↓</a></div>${overview(data)}<section class="km-walk" aria-labelledby="km-walk-title"><div class="eyebrow">업무 질문으로 따라가기</div><h2 id="km-walk-title">“누적시간에 가산이 왜 포함되나요?”</h2><p>선택근무 질문을 예로, 업무 기준부터 정정 이력까지 읽어봅니다.</p><div class="km-walk-grid">${data.walkthrough.map((step,i)=>{const d=data.documents.find(d=>d.path===step.path);return `<a href="${link(d.id)}" data-km-doc="${d.id}"><span class="km-step">0${i+1}</span><strong>${escape(step.title)}</strong><span>${escape(step.text)}</span></a>`;}).join('')}</div></section><section class="km-explorer" id="knowledge-explorer"><div class="km-section-head"><div><div class="eyebrow">문서 탐색</div><h2>문서 목록</h2></div><a href="${data.inventory}" download class="text-link">파일 목록·해시 받기 ↓</a></div><p class="km-caption">제목·경로·요약으로 검색하고, ‘본문 읽기 ↗’로 새 창에서 확인하세요.</p><div class="km-controls"><label>문서 역할<select data-km-filter>${['<option value="all">전체 역할</option>',...data.groups.map(g=>`<option value="${g.id}">${escape(g.title)} (${g.count})</option>`)].join('')}</select></label><label>폴더<select data-km-folder><option value="all">전체 폴더</option>${[...new Set(data.documents.map(d=>d.path.includes('/')?d.path.slice(0,d.path.lastIndexOf('/')+1):''))].filter(Boolean).sort().map(p=>`<option value="${escape(p)}">${escape(p)}</option>`).join('')}</select></label><label class="km-search">제목·파일 경로·요약 검색<input type="search" data-km-search placeholder="선택근무, SKILL, feedback…" autocomplete="off"></label></div><div data-km-results></div><p data-km-reader-status role="status" hidden></p></section><p class="km-snapshot">GitHub <a href="https://github.com/${escape(data.repository)}/tree/${data.commit}" target="_blank" rel="noopener noreferrer">${escape(data.repository)}</a> · <code>${data.commit.slice(0,12)}</code> · ${data.asOf} 확보 · MD만 수집 · 이후 변경은 재수집·빌드 후 반영</p></section>`;}
export function renderDocumentDetail(data,id,{mentions=false,showAll=false}={}){
 const doc=data.documents.find(d=>d.id===id);if(!doc)return '<div class="empty-state">문서를 찾을 수 없습니다.</div>';
 const byId=new Map(data.documents.map(d=>[d.id,d]));const group=data.groups.find(g=>g.id===doc.group);
 const {incoming,outgoing}=connections(data,id,{mentions});
 const reference=data.references.filter(r=>r.from===id);
  const list=(rows,side)=>rows.length?`<ul class="km-edge-list">${rows.map(e=>{const d=byId.get(side==='in'?e.from:e.to);return `<li><a href="${link(d.id)}" data-km-doc="${d.id}">${escape(d.title)}</a><code>${escape(d.path)}</code><span>${kindLabel(e.kind)} · 출발 문서 ${e.line?e.line+'행':'위치 미확인'}${e.section?' · '+escape(e.section):''}</span></li>`;}).join('')}</ul>`:'<p class="km-caption">이 조건의 연결이 없습니다.</p>';
 return `<div class="km-document" id="km-selected"><header class="km-document-head"><div><span class="km-chip km-${doc.group}">${escape(group.title)}</span><h3 tabindex="-1" data-km-title>${escape(doc.title)}</h3><code class="km-path">${escape(doc.path)}</code></div><a class="btn primary" href="${doc.download}" download="${escape(doc.path.split('/').pop())}">이 MD 받기 ↓</a></header><p>${escape(doc.summary||'본문이 없는 문서입니다.')}</p><div class="km-meta"><span>수정 기준: ${escape(group.change)}</span>${doc.date?`<span>문서 기준일: ${escape(doc.date)}</span>`:''}${doc.review?`<span>원문 검토 상태: ${escape(doc.review)}</span>`:''}<span>${number(doc.bytes)} bytes</span></div><div class="km-connection-summary"><strong>들어오는 링크 ${incoming.length}</strong><span>→ 선택 문서 →</span><strong>나가는 링크 ${outgoing.length}</strong><button class="btn small" data-km-back-map>전체 지도에서 보기 ↑</button></div><details class="km-relations"><summary>전체 관계와 근거 위치 보기 (${incoming.length+outgoing.length})</summary><div class="km-related-columns"><section><h4>들어오는 관계</h4>${list(incoming,'in')}</section><section><h4>나가는 관계</h4>${list(outgoing,'out')}</section></div></details>${reference.length?`<details class="km-relations"><summary>범위 밖 자료·찾지 못한 MD 참조 (${reference.length})</summary><p class="km-caption">비MD 자료는 수집 범위 밖입니다. 미해결 MD 링크는 원래 저장소에서 경로를 확인하세요.</p><ul class="km-edge-list">${reference.map(r=>`<li><strong>${r.kind==='unresolved'?(r.referenceType==='mention'?'예시·모호한 MD 경로 언급':'MD 링크 대상 미해결'):'이번 수집 범위 밖'}</strong><code>${escape(r.path)}</code><span>${escape(r.original||r.path)} · 이 MD의 ${r.line||'?'}행에 기록된 참조</span></li>`).join('')}</ul></details>`:''}<details class="km-content" ${showAll?'open':''}><summary>문서 내용 읽기 <span>확보한 MD · 실행되지 않는 교육 자료</span></summary><p class="km-caption">문서 기준일과 검토 상태를 함께 확인하세요. MD 링크는 이 창에서 열리며, 연결되지 않는 참조는 원문 다운로드로 확인할 수 있습니다.</p><div class="prose km-source-content">${doc.html||'<p>빈 문서입니다.</p>'}</div></details><details class="km-integrity"><summary>원본 식별 정보</summary><code>SHA-256 ${doc.sha256}</code><code>Git blob ${doc.blobSha}</code></details></div>`;
}
export function openKnowledgeReader(data,id,{mentions=false,hydrate=()=>{},ownerDocument=document}={}){
 const source=ownerDocument,view=source.defaultView;
 const reader=view.open('','_blank','popup,width=1080,height=850,resizable=yes,scrollbars=yes');
 if(!reader)return null;
 const page=reader.document;
 page.documentElement.lang='ko';
 for(const attr of ['data-theme','class']){const value=source.documentElement.getAttribute(attr);if(value)page.documentElement.setAttribute(attr,value);}
 const base=page.createElement('base');base.href=source.baseURI;page.head.appendChild(base);
 for(const style of source.querySelectorAll('link[rel="stylesheet"],style'))page.head.appendChild(style.cloneNode(true));
 page.body.className='km-reader-window';
 function show(docId){
  const item=data.documents.find(d=>d.id===docId);if(!item)return;
  page.title=item.title+' · 근로시간 업무지식';
  page.body.innerHTML='<main class="km-reader-main"><nav class="km-reader-toolbar"><strong>근로시간 업무지식 · 문서 읽기</strong><button class="btn" data-reader-close>창 닫기 ×</button></nav>'+renderDocumentDetail(data,docId,{mentions,showAll:true})+'</main>';
  const back=page.querySelector('[data-km-back-map]');if(back)back.textContent='지도 창으로 돌아가기 ↗';
  hydrate(page.body);
  page.querySelector('[data-km-title]')?.focus({preventScroll:true});reader.scrollTo(0,0);
 }
 page.addEventListener('click',event=>{
  const target=event.target.closest?.('[data-km-doc],[data-km-back-map],[data-reader-close],a[href^="#/learn/worktime-agent?"]');if(!target)return;
  event.preventDefault();
  if(target.hasAttribute('data-km-doc'))show(target.dataset.kmDoc);
  else if(target.getAttribute?.('href')?.startsWith('#/learn/worktime-agent?'))show(new URLSearchParams(target.getAttribute('href').split('?')[1]).get('doc'));
  else if(target.hasAttribute('data-reader-close'))reader.close();
  else {view.focus();reader.close();}
 });
 show(id);reader.focus();return reader;
}
export function mountKnowledge(root,data,{docId,openDocument=false,hydrate=()=>{}}={}){
 if(!root)return ()=>{};
 let selected=data.documents.some(d=>d.id===docId)?docId:null;
 let filter={group:'all',folder:'all',query:''};let limit=12,mentions=false;
 const $=s=>root.querySelector(s);const results=$('[data-km-results]');
 let map;
 map=mountKnowledgeMap($('[data-map-atlas]'),data,{onSelect:id=>select(id,false),onRead:readInWindow,onMentions:value=>{mentions=value;},hydrate});
 function updateResults(){const docs=filterDocuments(data,filter);results.innerHTML=`<details class="km-index" ${filter.query||filter.group!=='all'||filter.folder!=='all'?'open':''}><summary>문서 목록 <span role="status">${docs.length} / ${data.documents.length}개</span></summary><div class="km-file-grid">${docs.slice(0,limit).map(d=>`<a href="${link(d.id)}" data-km-doc="${d.id}" class="km-file ${selected===d.id?'selected':''}"><strong>${escape(d.title)}</strong><code>${escape(d.path)}</code><span>${escape(data.groups.find(g=>g.id===d.group).title)}${d.empty?' · 빈 문서':''}</span></a>`).join('')}</div>${!docs.length?'<p class="empty-state">일치하는 문서가 없습니다. 검색어·역할·폴더 조건을 변경해 보세요.</p>':''}${docs.length>limit?`<button class="btn" data-km-more>문서 더 보기 (${Math.min(limit,docs.length)} / ${docs.length})</button>`:''}</details>`;}
 function readInWindow(id){
  const status=$('[data-km-reader-status]');
  const reader=openKnowledgeReader(data,id,{mentions,hydrate,ownerDocument:root.ownerDocument});
  if(status){status.hidden=!!reader;status.textContent=reader?'':'새 창이 차단되었습니다. 브라우저에서 팝업을 허용한 뒤 본문 읽기를 다시 눌러 주세요.';}
 }
 function select(id,focus=true){openDocument=false;selected=id;history.replaceState(null,'',id?link(id):'#/learn/worktime-agent');updateResults();map?.select(id);if(focus)$('[data-map-atlas]')?.scrollIntoView({block:'start',behavior:'instant'});}
 function click(e){const t=e.target.closest('[data-km-doc],[data-km-group],[data-km-more],[data-km-back-map]');if(!t)return;
  if(t.hasAttribute('data-km-doc')){e.preventDefault();select(t.dataset.kmDoc);}
  if(t.hasAttribute('data-km-group')){filter.group=t.dataset.kmGroup;filter.folder='all';filter.query='';limit=12;$('[data-km-filter]').value=filter.group;$('[data-km-folder]').value='all';$('[data-km-search]').value='';select(data.groups.find(g=>g.id===filter.group).entry);}
  if(t.hasAttribute('data-km-back-map'))$('[data-map-atlas]')?.scrollIntoView({block:'start',behavior:'instant'});
  if(t.hasAttribute('data-km-more')){limit+=24;updateResults();}
 }
 function input(e){if(e.target.matches('[data-km-search]')){filter.query=e.target.value;limit=12;updateResults();}}
 function change(e){if(e.target.matches('[data-km-filter]')){filter.group=e.target.value;limit=12;updateResults();}if(e.target.matches('[data-km-folder]')){filter.folder=e.target.value;limit=12;updateResults();}}
 root.addEventListener('click',click);root.addEventListener('input',input);root.addEventListener('change',change);updateResults();
 map?.select(selected);

 return ()=>{map?.dispose();root.removeEventListener('click',click);root.removeEventListener('input',input);root.removeEventListener('change',change);};
}
