function categoryBadge(category){const key=category==='에이전트 구축'?'build':category==='에이전트 협업 및 조회'?'connect':'case';return `<span class="badge category-${key}">${esc(category)}</span>`;}
import {countNumber} from './count-up.js';
const esc=s=>String(s??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const types={verbatim:'원문 전사',excerpt:'원문 발췌',summary:'답변 요약',reconstructed:'교육용 재구성',unavailable:'본문 표시 없음'};
export const conversationTabs=[['dialogue','대화기록'],['review','해설·시행착오'],['assets','관련자료']];
export const conversationLink=(pid,eid)=>`#/conversations/${pid}${eid?'/'+eid:''}`;
const matchesNode=(p,e,node)=>!node||(node.startsWith('case-')?p.lessonIds.includes(node.slice(5)):e.map_nodes.includes(node));
const readingCache=new WeakMap();
export function readingProjects(bundle){
 if(!readingCache.has(bundle))readingCache.set(bundle,bundle.projects.map(p=>{
  const messages=p.messages.filter(m=>!m.readingHidden&&m.content_type!=='unavailable');
  const ids=new Set(messages.map(m=>m.id));
  const episodes=p.episodes.filter(e=>!e.readingHidden).map(e=>({...e,message_refs:e.message_refs.filter(id=>ids.has(id))})).filter(e=>e.message_refs.length).map((e,i)=>({...e,order:i+1}));
  return {...p,messages,episodes};
 }).filter(p=>p.episodes.length));
 return readingCache.get(bundle);
}
export function resolveConversation(bundle,{node,projectId,episodeId}={}){
 const availableProjects=readingProjects(bundle).filter(p=>p.episodes.some(e=>matchesNode(p,e,node)));
 if(!availableProjects.length)return null;
 const preferred=node?bundle.preferredNodes[node]:null;
 const project=availableProjects.find(p=>p.id===projectId)||availableProjects.find(p=>p.id===preferred?.[0])||availableProjects[0];
 const episodes=project.episodes.filter(e=>matchesNode(project,e,node));
 const episode=episodes.find(e=>e.id===episodeId)||episodes.find(e=>project.id===preferred?.[0]&&e.id===preferred?.[1])||episodes[0];
 const messages=episode.message_refs.map(id=>project.messages.find(m=>m.id===id));
 return {availableProjects,project,episodes,episode,messages};
}
export function relatedConversationCount(bundle,node){return readingProjects(bundle).reduce((n,p)=>n+p.episodes.filter(e=>matchesNode(p,e,node)).length,0);}
export function conversationIndex(bundle){
 return `<div class="conversation-intro"><div><div class="eyebrow">FROM REAL PROJECTS</div><h1 class="page-title">실제 대화로 배우기</h1><p class="page-description">실제 요청과 AI 응답을 읽으며 수정과 검증이 어떻게 이어졌는지 살펴봅니다.</p></div><a class="btn" href="#/map/core">구성도에서 찾아보기 ↗</a></div><div class="conversation-stats"><span><strong>${countNumber((bundle.readingTotals||bundle.totals).projects)}</strong>개 프로젝트</span><span><strong>${countNumber((bundle.readingTotals||bundle.totals).episodes)}</strong>개 학습 에피소드</span><span><strong>${countNumber(bundle.readingTotals?.messages??(bundle.totals.messages-(bundle.totals.unavailable||0)))}</strong>개 대화 항목</span></div><div class="conversation-project-grid">${readingProjects(bundle).map((p,i)=>`<article class="conversation-project-card"><div class="conversation-project-meta"><span>PROJECT ${String(i+1).padStart(2,'0')}</span>${categoryBadge(p.category)}</div><h2><a href="${conversationLink(p.id)}">${esc(p.shortTitle)}</a></h2><p>${esc(p.purpose)}</p><div class="conversation-project-turn"><strong>이 과정의 전환점</strong><p>${esc(p.turningPoint)}</p></div><a class="text-link" href="${conversationLink(p.id)}">에피소드 및 대화 확인 <span aria-hidden="true">↗</span></a></article>`).join('')}</div>`;
}
// Reveal complete request/response turns, never only the progress before a final reply.
export function conversationVisibleCount(messages,requested=4){
 let count=Math.min(messages.length,Math.max(1,requested));
 while(count<messages.length&&messages[count].role==='assistant')count++;
 return count;
}
function dateLabel(value){
 if(!value)return '';
 const date=new Date(value);if(Number.isNaN(date.getTime()))return '';
 return new Intl.DateTimeFormat('ko-KR',{timeZone:'Asia/Seoul',year:'numeric',month:'2-digit',day:'2-digit',hour:'2-digit',minute:'2-digit',hour12:false}).format(date)+' KST';
}
function imageAsset(a){return `<figure class="conversation-image"><button class="image-zoom" data-image="${esc(a.publicPath)}" aria-label="${esc(a.description)} 크게 보기"><img src="${esc(a.publicPath)}" alt="${esc(a.description)}" loading="lazy"></button><figcaption>${esc(a.description)} <span>· ${esc(a.id)}</span></figcaption></figure>`;}
function plainSnippet(md){return md.replace(/[^]*/g,'').replace(/!\[([^\]]*)\]\([^)]*\)/g,'$1').replace(/\[([^\]]*)\]\([^)]*\)/g,'$1').replace(/[#*`>|]/g,'').replace(/\s+/g,' ').trim().slice(0,280);}
function messageCard(project,message){
 const m=message,imgs=project.assets.filter(a=>m.asset_ids.includes(a.id)&&a.kind==='image'&&a.publicPath);
 if(m.content_type==='unavailable')return '';
 const edited=Boolean(m.reading_markdown||m.editorial_markdown),text=m.reading_markdown??m.editorial_markdown??m.content_markdown,html=m.readingHtml??m.editorialHtml??m.html;
 const files=project.assets.filter(a=>m.asset_ids.includes(a.id)&&a.kind!=='image'&&a.publicPath&&m.content_markdown.includes(a.original_filename||'\u0000')).filter((a,i,list)=>list.findIndex(b=>b.publicPath===a.publicPath)===i);
 const fileLinks=files.length?`<div class="conversation-message-files" aria-label="대화의 첨부파일"><strong>첨부파일</strong>${files.map(a=>`<a class="btn small" href="${esc(a.publicPath)}" download="${esc(a.original_filename)}">${esc(a.original_filename)} ↓</a>`).join('')}</div>`:'';
 const progress=m.role==='assistant'&&m.delivery_kind==='progress';
 const long=text.length>1800&&!progress;
 const body=!text.trim()?'':long?`<details class="transcript-long" ${m.role==='assistant'?'open':''} id="long-${esc(project.id)}-${esc(m.id)}"><summary><span class="transcript-preview">${esc(plainSnippet(text))}…</span><span class="transcript-open-label">대화 전문 펼치기 ↓</span></summary><div class="prose conversation-prose">${html}</div></details>`:`<div class="prose conversation-prose">${html}</div>`;
 const copyButton=()=>`<button class="text-link" data-chat-copy="${esc(m.id)}" data-project-id="${esc(project.id)}" aria-label="${esc(m.id)} ${edited?'교육용 문장':types[m.content_type]} 복사">${edited?'교육용 문장 복사':'본문 복사'}</button>`;
 if(progress)return `<details class="conversation-progress" id="message-${esc(project.id)}-${esc(m.id)}" tabindex="-1"><summary><span>AI 진행 안내</span><span class="progress-preview">${esc(plainSnippet(text).slice(0,90))}${text.length>90?'…':''}</span></summary><div class="progress-content">${body}${fileLinks}${imgs.map(imageAsset).join('')}<div class="chat-message-foot"><span class="caption">${esc(m.id)} · ${esc(m.source_locator)}</span>${text.trim()?copyButton():''}</div></div></details>`;
 return `<article class="chat-message ${m.role==='user'?'from-user':'from-assistant'} ${m.content_type==='summary'||m.content_type==='reconstructed'?'is-summary':''}" id="message-${esc(project.id)}-${esc(m.id)}" tabindex="-1"><div class="chat-avatar" aria-hidden="true">${m.role==='user'?'요청':'AI'}</div><div class="chat-message-main"><div class="chat-message-meta"><strong>${m.role==='user'?'사용자 요청':m.delivery_kind==='progress'?'AI 진행 안내':'AI 응답'}</strong><span class="transcript-type ${'type-'+esc(m.content_type)+(edited?' type-editorial':'')}">${m.content_type==='summary'||m.content_type==='reconstructed'?types[m.content_type]:edited?'학습용 편집':'대화 기록'}</span>${m.redacted?'<span class="transcript-type">일부 마스킹</span>':''}${dateLabel(m.timestamp)?`<span class="chat-date">${dateLabel(m.timestamp)}</span>`:''}</div><div class="chat-bubble">${body}${fileLinks}${imgs.length?`<div class="conversation-message-images">${imgs.map(imageAsset).join('')}</div>`:''}</div><div class="chat-message-foot"><details class="message-source" id="source-${esc(project.id)}-${esc(m.id)}"><summary>출처 · ${esc(m.id)}</summary><p>${esc(m.source_locator)}</p></details>${text.trim()?copyButton():''}</div></div></article>`;
}
function assetsPane(project,episode){
 const related=episode.asset_ids.map(id=>project.assets.find(a=>a.id===id)).filter(a=>a?.publicPath);
 const all=project.assets.filter(a=>a.publicPath).filter((a,i,items)=>items.findIndex(b=>b.publicPath===a.publicPath)===i);
 return `<div class="conversation-pane-content"><div class="conversation-assets">${related.map(a=>`<article class="conversation-asset"><div class="conversation-asset-heading"><h4>${esc(a.original_filename||a.id)}</h4></div><p>${esc(a.description)}</p>${a.kind==='image'?imageAsset(a):`<a class="btn small" href="${esc(a.publicPath)}" download="${esc(a.original_filename||a.id)}">파일 받기</a>`}</article>`).join('')}</div><h3>프로젝트 자료</h3><div class="conversation-downloads">${[['01_PROJECT_CONTEXT.md','프로젝트 맥락 MD'],['02_LEARNING_GUIDE.md','학습 가이드 MD'],['conversation-data.json','대화 원본 JSON'],['AI_RESPONSES_FULL.md','대화 기록 MD']].filter(([f])=>project.documents[f]).map(([f,t])=>`<a class="btn small" href="${project.documents[f]}" download>${t} ↓</a>`).join('')}</div>${all.length?`<details class="project-attachment-index"><summary>프로젝트 첨부파일 · ${all.length}개</summary><ul>${all.map(a=>`<li><a href="${esc(a.publicPath)}" download="${esc(a.original_filename||a.id)}">${esc(a.original_filename||a.id)}</a></li>`).join('')}</ul></details>`:''}</div>`;
}
export function conversationWorkspace(bundle,state={}){
 const selection=resolveConversation(bundle,state);if(!selection)return '';
 const {availableProjects,project,episodes,episode,messages}=selection;
 const tab=conversationTabs.some(([t])=>t===state.tab)?state.tab:'dialogue';
 const count=conversationVisibleCount(messages,state.visible||4);
 let pane;
 if(tab==='review')pane=`<div class="conversation-pane-content"><div class="prose conversation-prose">${episode.commentaryHtml.replace(/<p>교육 해설 — 실제 AI 발화 아님[.]?<\/p>/g,'').replace(/교육 해설 — 실제 AI 발화 아님[.]?/g,'')}</div><section class="conversation-outcome"><h3>핵심 정리</h3><div class="prose conversation-prose">${episode.outcomeHtml}</div></section></div>`;
 else if(tab==='assets')pane=assetsPane(project,episode);
 else pane=`<div class="conversation-dialogue-intro"><p>요청과 AI 응답을 순서대로 읽습니다. 수정 이유와 검증 결과는 <button class="text-link" data-conversation-tab="review">해설·시행착오</button>에서 확인할 수 있습니다.</p></div><div class="conversation-transcript">${messages.slice(0,count).map(m=>messageCard(project,m)).join('')}</div><div class="conversation-reveal"><span>${count} / ${messages.length}개 항목</span>${count<messages.length?`<button class="btn primary" data-conversation-more>다음 대화 보기 ↓</button><button class="btn" data-conversation-all>전체 대화 펼치기</button>`:'<button class="btn primary" data-conversation-tab="review">이 대화의 시행착오 읽기 →</button>'}</div>`;
 const selectedIndex=episodes.indexOf(episode),next=episodes[selectedIndex+1],prev=episodes[selectedIndex-1];
 const mainEpisodes=episodes.filter(e=>!e.isMeta),metaEpisodes=episodes.filter(e=>e.isMeta);
 const episodeButtons=list=>list.map(e=>`<button class="conversation-episode ${e.id===episode.id?'active':''}" data-conversation-episode="${esc(e.id)}" aria-pressed="${e.id===episode.id}"><span>${String(e.order).padStart(2,'0')}</span><span>${esc(e.title)}</span></button>`).join('');
 return `<div class="conversation-workspace" data-conversation-project="${esc(project.id)}" data-conversation-current="${esc(episode.id)}"><div class="conversation-workspace-header"><div><div class="eyebrow">PROJECT CONVERSATIONS</div><h2 id="conversation-heading" tabindex="-1">${state.nodeLabel?esc(state.nodeLabel)+' · 관련 대화':'프로젝트의 실제 대화'}</h2>${state.node?'':'<p>핵심 요청과 해결 과정을 선별했습니다. 학습 흐름을 선택하면 관련 대화를 순서대로 읽을 수 있습니다.</p>'}</div><label class="conversation-project-select" for="conversation-project-select">프로젝트 선택<select id="conversation-project-select" data-conversation-select>${availableProjects.map(p=>`<option value="${esc(p.id)}" ${p.id===project.id?'selected':''}>${esc(p.shortTitle)} · ${p.episodes.filter(e=>matchesNode(p,e,state.node)).length}개</option>`).join('')}</select></label></div><div class="conversation-project-brief"><strong>${esc(project.shortTitle)}</strong><p>${esc(project.purpose)}</p></div><div class="conversation-layout"><aside class="conversation-episode-list" aria-label="학습 에피소드"><div class="conversation-list-label">학습 흐름 <span>${episodes.length}개</span></div>${episodeButtons(mainEpisodes)}${metaEpisodes.length?`<details class="conversation-meta-episodes" ${episode.isMeta?'open':''}><summary>자료 추출·정리 과정 <span>${metaEpisodes.length}개</span></summary>${episodeButtons(metaEpisodes)}</details>`:''}${state.node?`<a class="conversation-full-project" href="${conversationLink(project.id,episode.id)}">이 프로젝트 전체 흐름 보기 ↗</a>`:''}</aside><section class="conversation-reader" aria-labelledby="conversation-episode-title"><header class="conversation-episode-header"><div class="eyebrow">EPISODE ${String(episode.order).padStart(2,'0')} · ${messages.filter(m=>m.content_type!=='unavailable').length}개 대화 항목</div><h3 id="conversation-episode-title" tabindex="-1">${esc(episode.title)}</h3><p>${esc(episode.goal)}</p><details class="conversation-prerequisites"><summary>시작 전 알아둘 맥락과 준비물</summary><ul>${episode.prerequisites.map(x=>`<li>${esc(x)}</li>`).join('')}</ul></details></header><div class="conversation-tabs" role="group" aria-label="에피소드 내용 선택">${conversationTabs.map(([key,label])=>`<button data-conversation-tab="${key}" class="${key===tab?'active':''}" aria-pressed="${key===tab}" aria-controls="conversation-pane">${label}</button>`).join('')}</div><div id="conversation-pane" class="conversation-pane" tabindex="-1" aria-label="${conversationTabs.find(([t])=>t===tab)[1]}">${pane}</div><nav class="conversation-pager" aria-label="이전 다음 에피소드">${prev?`<button class="pager-card pager-prev" data-conversation-episode="${esc(prev.id)}"><span class="pager-label">← 이전 에피소드</span><strong>${esc(prev.title)}</strong></button>`:'<span></span>'}${next?`<button class="pager-card pager-next" data-conversation-episode="${esc(next.id)}"><span class="pager-label">다음 에피소드 →</span><strong>${esc(next.title)}</strong></button>`:`<a class="pager-card pager-next" href="${project.documents['02_LEARNING_GUIDE.md']}" download><span class="pager-label">학습 가이드 다운로드 ↓</span><strong>프로젝트 전체 흐름 다시 보기</strong></a>`}</nav></section></div></div>`;
}
export function conversationSearchEntries(bundle){return readingProjects(bundle).flatMap(p=>p.episodes.map(e=>({title:e.title,group:p.shortTitle,url:conversationLink(p.id,e.id),text:[e.goal,e.commentary_markdown,...e.message_refs.flatMap(id=>{const m=p.messages.find(m=>m.id===id);return [m.reading_markdown??m.editorial_markdown??m.content_markdown];})].join('\n')})));}
