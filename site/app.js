import {renderSourceDocuments,filterSourceDocuments} from './source-library.js';
import {countNumber,mountCountUps} from './count-up.js';
import {renderKnowledge,mountKnowledge} from './knowledge.js';
import {mountHeroMotion} from './hero-motion.js';
import {conversationIndex,conversationWorkspace,resolveConversation,conversationVisibleCount,relatedConversationCount,conversationLink,conversationSearchEntries} from './conversations.js';
let heroCleanup, knowledgeCleanup, countCleanup;
const $=s=>document.querySelector(s);
const esc=s=>String(s??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const icons={download:'<path d="M12 3v12m-5-5 5 5 5-5M4 16v5h16v-5"/>',home:'<path d="m3 10 9-7 9 7v10H3z"/><path d="M9 20v-7h6v7"/>',book:'<path d="M12 5v16M3 4c4-1 6 0 9 2 3-2 5-3 9-2v15c-4-1-6 0-9 2-3-2-5-3-9-2z"/>',map:'<rect x="8" y="2" width="8" height="5" rx="1"/><rect x="2" y="17" width="7" height="5" rx="1"/><rect x="15" y="17" width="7" height="5" rx="1"/><path d="M12 7v5M5.5 17v-5h13v5"/>',case:'<path d="M8 3H4v18h16V3h-4"/><rect x="8" y="2" width="8" height="4" rx="1"/><path d="m7 12 3 3 7-7"/>',folder:'<path d="M3 5h7l2 3h9v12H3z"/>',code:'<path d="m8 6-5 6 5 6m8-12 5 6-5 6m-3-15-2 18"/>',nodes:'<circle cx="6" cy="6" r="3"/><circle cx="18" cy="6" r="3"/><circle cx="12" cy="19" r="3"/><path d="m7 9 4 7m6-7-4 7M9 6h6"/>'};
const icon=(name,size=20)=>`<svg width="${size}" height="${size}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">${icons[name]||icons.book}</svg>`;
let sourceDialogTrigger;
let data,currentFilter='전체',graphSelection='codex',lastRoute='',lastFocused;
let conversationState={tab:'dialogue',visible:4};
function notify(text){$('#toast').textContent=text;$('#toast').classList.add('visible');clearTimeout(notify.timer);notify.timer=setTimeout(()=>$('#toast').classList.remove('visible'),2500);}
function categoryBadge(category){const key=category==='에이전트 구축'?'build':category==='에이전트 협업 및 조회'?'connect':'case';return `<span class="badge category-${key}">${esc(category)}</span>`;}
function badge(status){const cls=/설계|미확인/.test(status)?'design':/검증/.test(status)?'test':/개념/.test(status)?'neutral':'';return `<span class="badge ${cls}">${esc(status)}</span>`;}
const groupSymbols=[
 '<path d="m12 2 10 10-10 10L2 12Z"/><path d="m12 7 5 5-5 5-5-5Z"/>',
 '<rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><path d="M14 17.5h7m-3.5-3.5v7"/>',
 '<circle cx="5" cy="6" r="3"/><circle cx="19" cy="6" r="3"/><circle cx="12" cy="19" r="3"/><path d="M8 6h8M6.5 9l4 7m7-7-4 7"/>',
 '<rect x="4" y="6" width="16" height="15" rx="4"/><path d="M12 6V3m-2 0h4M4 12H2m18 0h2M9 17h6"/><circle cx="8.5" cy="12" r="1"/><circle cx="15.5" cy="12" r="1"/>'
];
const groupIcon=g=>`<span class="group-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round" stroke-linecap="round">${groupSymbols[data.groups.indexOf(g)]||groupSymbols[0]}</svg></span>`;
const lessonLink=id=>`#/learn/${id}`;
const lessonNumber=l=>l.displayNumber||String(l.number).padStart(2,'0');
const footer=()=>`<footer class="site-footer"><span>KBS · ERP AI 에이전트</span><span>자료 기준 ${data.asOf} · v${data.version}</span></footer>`;
function hydratePreviewAssets(root){
 const files=globalThis.erpPreviewFiles;if(!files||!root)return;
 for(const el of root.querySelectorAll('[href],[src],[data-image]'))for(const attr of ['href','src','data-image']){
  const url=el.getAttribute(attr);if(files[url]){el.setAttribute(attr,files[url]);if(attr==='href'&&el.hasAttribute('download')&&!el.getAttribute('download'))el.setAttribute('download',url.split('/').at(-1));}
 }
}
function conversationForLesson(id){
 const project=data.conversations.projects.find(p=>p.lessonIds.includes(id));if(!project)return `<section class="lesson-conversation-link"><div><strong>이 과정의 실제 대화</strong><p>이 프로젝트의 대화 전문은 아직 등록되지 않았습니다.</p></div></section>`;
 const preferred={overview:'E01',export:'E01',workspace:'E05',codex:'E05',diagnosis:'E11',feedback:'E07'};
 const episode=preferred[id]||project.episodes[0].id;
 return `<a class="lesson-conversation-link" href="${conversationLink(project.id,episode)}">${icon('nodes',24)}<span><strong>이 과정의 실제 대화</strong><span>요청부터 수정·검증까지 읽기 ↗</span></span></a>`;
}
function renderConversation(){
 const node=Object.values(graphModes).flatMap(g=>g.nodes).find(n=>n[0]===conversationState.node);
 if(conversationState.node?.startsWith('case-')&&!data.conversations.projects.some(p=>p.lessonIds.includes(conversationState.node.slice(5))))return `<section class="conversation-workspace"><div class="eyebrow">PROJECT CONVERSATIONS</div><h2 id="conversation-heading" tabindex="-1">${esc(node?.[3])}</h2><p>이 프로젝트의 대화 전문은 아직 등록되지 않았습니다.</p><a class="text-link" href="#/learn/${conversationState.node.slice(5)}">프로젝트 내용과 자료 확인 ↗</a></section>`;return conversationWorkspace(data.conversations,{...conversationState,nodeLabel:node?.[3]});
}
function updateConversation(focusId,scroll=false){
 const selection=resolveConversation(data.conversations,conversationState);if(!selection){const host=$('#conversation-host');if(host)host.innerHTML=renderConversation();return;}
 conversationState.projectId=selection.project.id;conversationState.episodeId=selection.episode.id;
 const host=$('#conversation-host');if(!host)return;
 const opened=[...host.querySelectorAll('details[id][open]')].map(d=>d.id);
 host.innerHTML=renderConversation();
 for(const id of opened){const detail=document.getElementById(id);if(detail)detail.open=true;}
 hydratePreviewAssets(host);
 const q=new URLSearchParams({tab:conversationState.tab||'dialogue'});
 let hash;
 if(conversationState.node){q.set('node',conversationState.node);q.set('project',selection.project.id);q.set('episode',selection.episode.id);hash=`#/map/${mapMode()}?${q}`;}
 else hash=`${conversationLink(selection.project.id,selection.episode.id)}?${q}`;
 history.replaceState(null,'',hash);
 lastRoute=hash.slice(2).split('?')[0];
 const focus=focusId?document.getElementById(focusId):null;
 if(scroll)focus?.scrollIntoView({block:'start'});
 focus?.focus({preventScroll:true});
}
function conversationsPage(projectId){
 if(!projectId)return `<div class="page">${breadcrumbs(['프로젝트 대화'])}${conversationIndex(data.conversations)}${footer()}</div>`;
 if(!data.conversations.projects.some(p=>p.id===projectId))return notFound();
 return `<div class="page conversation-page">${breadcrumbs(['프로젝트 대화'])}<div class="eyebrow">실제 프로젝트 기록</div><h1 class="page-title">프로젝트 대화</h1><p class="page-description">프로젝트 흐름을 선택하고 당시 요청·응답과 의사결정 과정을 확인하세요.</p><div class="conversation-page-back"><a class="text-link" href="#/conversations">← 모든 프로젝트 보기</a><a class="text-link" href="#/map/core">전체 구성도 보기 ↗</a></div><div id="conversation-host">${renderConversation()}</div>${footer()}</div>`;
}
function sidebar(route){
 const active=route[0]||'home';
 const nav=[['home','home','홈'],['courses','book','전체 과정'],['map','map','전체 구성도'],['conversations','nodes','프로젝트 대화'],['library','folder','자료실']];
 $('#sidebar').innerHTML=`<nav class="side-primary">${nav.map(([id,ic,t])=>`<a href="#/${id}" class="side-link ${active===id?'active':''}" ${active===id?'aria-current="page"':''}>${icon(ic)}<span>${t}</span></a>`).join('')}</nav><nav aria-label="전체 과정">${data.groups.map(g=>`<div class="side-group">${groupIcon(g)}<span>${esc(g)}</span></div>${data.lessons.filter(l=>l.group===g).map(l=>`<a href="${lessonLink(l.id)}" class="lesson-link ${route[1]===l.id?'active':''}" ${route[1]===l.id?'aria-current="page"':''}><span class="num">${lessonNumber(l)}</span><span>${esc(l.title.replace('실제 사례: ',''))}</span></a>`).join('')}`).join('')}</nav><div class="sidebar-bottom"><strong>자료 기준 ${esc(data.asOf.replaceAll('-','.'))}</strong>현행 기능과 확장 설계를 함께 다룹니다.</div>`;
}
const breadcrumbs=parts=>`<div class="breadcrumb"><a href="#/home">홈</a>${parts.map(p=>`<span class="sep">/</span><span>${esc(p)}</span>`).join('')}</div>`;
function home(){
 const next=data.lessons[0];
 // Keep the home as a curated entry point; new content can live in the full indexes.
 const expansion=['collaboration','erp-mcp'].map(id=>data.lessons.find(l=>l.id===id));
 const applications=data.lessons.filter(l=>l.number>=11);
 const paths=[['01','처음 이해하기',1,4],['02','내 업무에 적용하기',5,8],['03','팀으로 확장하기',9,10],['04','에이전트 활용사례',11,16]];
 return `<div class="page home-page"><section class="hero-band"><div class="home-inner"><div class="hero-meta"><span>KBS / ERP AI AGENTS</span><span>v${esc(data.version)} · 자료 기준 ${esc(data.asOf.replaceAll('-','.'))}</span></div><div class="hero"><div class="hero-copy"><div class="eyebrow">BUILD · UNDERSTAND · COLLABORATE</div><h1 class="hero-title" aria-label="ERP AI 에이전트, 이해에서 실무로."><span class="type-line signature-word" aria-hidden="true"><span class="type-reserve">ERP AI 에이전트,</span><span class="type-output" data-type-output data-text="ERP AI 에이전트,">ERP AI 에이전트,</span></span><span class="type-line" aria-hidden="true"><span class="type-reserve">이해에서 실무로.</span><span class="type-output" data-type-output data-text="이해에서 실무로.">이해에서 실무로.</span></span></h1><p>소스와 업무 맥락을 연결하고,<br>우리 팀의 에이전트 환경을 만들어 갑니다.</p><div class="hero-actions"><a class="btn primary" href="${lessonLink(next.id)}">워크플로 살펴보기 <span aria-hidden="true">↗</span></a><a class="btn hero-secondary" href="#/map">전체 구성도 보기 <span aria-hidden="true">↗</span></a></div></div><div class="hero-media" role="img" aria-label="올리브 나무를 중심으로 협업하는 사람들. 컴퓨터 화면의 카드와 글자가 차례로 나타납니다."><div class="hero-art hero-art-light" aria-hidden="true">${data.heroScene}</div><div class="hero-art hero-art-dark" aria-hidden="true">${data.heroSceneDark}</div></div></div><div class="hero-foot"><span>현행 기능부터 확장 설계까지</span><a href="#/courses">${countNumber(data.lessons.length)}개 과정 둘러보기 <span aria-hidden="true">↓</span></a></div></div></section>
 <div class="home-inner home-content"><section class="intro-section" aria-label="프로젝트 자료 구성"><div class="section-top"><div><div class="eyebrow">BUILT FROM OUR WORK</div><h2>AI 에이전트가<br>프로젝트의 출발점 입니다.</h2></div><p>각 프로젝트의 의사결정 과정을 읽어 볼 수 있습니다.</p></div><div class="stats-strip"><a href="#/library" class="stat"><span class="stat-label">SOURCES</span><strong>${countNumber(data.sources.length,2)}</strong><span>원천 자료 묶음 <b aria-hidden="true">↗</b></span></a><a href="#/conversations" class="stat"><span class="stat-label">EPISODES</span><strong>${countNumber(data.conversations.totals.episodes)}</strong><span>프로젝트 대화 에피소드 <b aria-hidden="true">↗</b></span></a><a href="#/courses" class="stat"><span class="stat-label">WORK. FLOW</span><strong>${countNumber(data.lessons.length)}</strong><span>에이전트 구축·활용 과정 <b aria-hidden="true">↗</b></span></a></div></section>
 <section class="learning-paths"><div class="section-top"><div><div class="eyebrow">WORK FLOW</div><h2>한 단계씩, 다음으로.</h2><p>전체 구조를 이해하고, 업무에 적용하고, 팀으로 확장하세요.</p></div><a class="text-link" href="#/courses">전체 과정 보기 ↗</a></div><div class="path-list">${paths.map(([n,title,start,end])=>`<section class="path-entry"><span class="path-number">STEP / ${n}</span><div class="path-title"><h3>${title}</h3></div><ol class="path-courses" start="${start}">${data.lessons.filter(l=>l.number>=start&&l.number<=end).map(l=>`<li><a href="${lessonLink(l.id)}"><span class="path-course-number">${lessonNumber(l)}.</span><span>${esc(l.title)}</span></a></li>`).join('')}</ol></section>`).join('')}</div></section></div>
 <section class="home-section home-expansion" aria-labelledby="home-expansion-title"><div class="home-inner"><div class="section-top"><div><div class="eyebrow">CONNECT & EXPAND</div><h2 id="home-expansion-title">확장 설계 <span class="section-count">${countNumber(expansion.length)}개</span></h2><p>담당 에이전트의 협업과 ERP 조회·모바일 연결을 설계합니다.</p></div><a class="text-link" href="#/map/remote">연결 구성도 보기 ↗</a></div><div class="expansion-grid">${expansion.map(l=>`<a class="home-card expansion-card" href="${lessonLink(l.id)}"><div class="home-card-top"><span class="home-card-icon">${icon(l.id==='collaboration'?'nodes':'map',24)}</span>${categoryBadge(l.category)}</div><span class="home-card-tag">WORK FLOW ${lessonNumber(l)} · ${esc(l.tag)}</span><h3>${esc(l.title)}</h3><p class="home-card-description">${esc(l.summary)}</p><span class="home-card-action">설계 과정 읽기<span aria-hidden="true">↗</span></span></a>`).join('')}</div><p class="home-section-note">원격 자문: 모의 통신 검증 · 실제 AI 워커: 미구현 · ERP·Telegram: 설계 단계</p></div></section>
 <section class="home-section home-applications" aria-labelledby="home-applications-title"><div class="home-inner"><div class="section-top"><div><div class="eyebrow">AGENTS AT WORK</div><h2 id="home-applications-title">에이전트 활용사례 <span class="section-count">${countNumber(applications.length)}개</span></h2><p>프로젝트를 만든 과정과 결과를 함께 읽습니다.</p></div><a class="text-link" href="#/library?section=core-md-title">핵심 MD ↗</a></div><div class="application-grid">${applications.map(l=>`<article class="home-card application-card"><div class="home-card-top"><span class="home-card-icon">${icon(l.id==='webgui'?'code':l.id==='worktime-agent'?'nodes':l.id==='publishing'?'folder':'case',24)}</span>${categoryBadge(l.category)}</div><span class="home-card-tag">WORK FLOW ${lessonNumber(l)} · ${esc(l.tag)}</span><h3><a href="${lessonLink(l.id)}">${esc(l.title)}</a></h3><p class="home-card-description">${esc(l.summary)}</p><div class="application-actions"><a class="home-card-action" href="${lessonLink(l.id)}">설계 과정 읽기<span aria-hidden="true">↗</span></a><a class="text-link" href="#/library?section=core-md-title" aria-label="${esc(l.title)} · 핵심 MD 자료실">핵심 MD ↗</a></div></article>`).join('')}</div></div></section>
 <div class="home-inner home-ending">${footer()}</div></div>`;
}
function courses(){
 const selected=data.lessons.filter(l=>currentFilter==='전체'||l.group===currentFilter);
 return `<div class="page">${breadcrumbs(['워크플로'])}<div class="eyebrow">워크플로</div><h1 class="page-title">ERP AI 에이전트 워크플로 <span class="section-count">총 ${countNumber(data.lessons.length)}개</span></h1><p class="page-description">에이전트를 만들고 활용한 과정과 결과를 프로젝트별로 살펴보세요.</p><div class="filter-tabs" aria-label="과정 분류">${['전체',...data.groups].map(g=>`<button data-filter="${esc(g)}" class="${currentFilter===g?'active':''}" aria-pressed="${currentFilter===g}">${esc(g)}</button>`).join('')}</div><div class="lesson-groups">${data.groups.filter(g=>selected.some(l=>l.group===g)).map((g,i)=>`<section class="course-group"><div class="group-heading">${groupIcon(g)}<h2>${g}</h2></div>${selected.filter(l=>l.group===g).map(l=>`<a class="lesson-row" href="${lessonLink(l.id)}"><span class="row-number">${lessonNumber(l)}</span><div><h3>${esc(l.title)}</h3><p>${esc(l.summary)}</p></div>${categoryBadge(l.category)}</a>`).join('')}</section>`).join('')}</div>${footer()}</div>`;
}
function lessonPager(prev,next){return `<nav class="lesson-pager" aria-label="이전 다음 과정"><a class="pager-card pager-prev" href="${prev?lessonLink(prev.id):'#/courses'}"><span class="pager-label">← ${prev?'이전 과정 · '+lessonNumber(prev):'전체 과정'}</span><strong>${prev?esc(prev.title):'워크플로 목록'}</strong></a><a class="pager-card pager-next" href="${next?lessonLink(next.id):'#/courses'}"><span class="pager-label">${next?'다음 과정 · '+lessonNumber(next):'전체 과정으로'} →</span><strong>${next?esc(next.title):'다른 과정 둘러보기'}</strong></a></nav>`;}
function renderProjectBrief(l){return `<section class="project-brief" aria-label="프로젝트의 네 가지 관점">${l.projectBrief.map(b=>`<article><span class="eyebrow">${b.key.toUpperCase()}</span><h2>${esc(b.title)}</h2><p>${esc(b.text)}</p></article>`).join('')}<a class="text-link" href="#/library/core-progress">프로젝트 진행 MD 확인 ↗</a></section>`;}
function featureBody(f){return `<dl><dt>출발점</dt><dd>${esc(f.problem)}</dd><dt>바꾼 방식</dt><dd>${esc(f.change)}</dd><dt>지켜야 할 기준</dt><dd>${esc(f.keep)}</dd></dl>`;}
function renderShowcase(l){const v=l.showcase,g=v.gallery[0];return `<section class="case-showcase" data-showcase="${l.id}"><div class="section-top"><div><div class="eyebrow">DESIGN & FUNCTION</div><h2>화면으로 읽는 변화</h2></div></div><div class="showcase-tabs" aria-label="보고서 화면 선택">${v.gallery.map((x,i)=>`<button class="${i===0?'active':''}" data-gallery="${i}" aria-pressed="${i===0}">${esc(x.label)}</button>`).join('')}</div><figure class="showcase-image"><button class="image-zoom" data-image="${g.image}" aria-label="화면 크게 보기"><img src="${g.image}" alt="${esc(g.caption)}" loading="lazy"></button><figcaption>${esc(g.caption)}</figcaption></figure><h2>기능을 바꾼 이유</h2><div class="showcase-tabs" aria-label="기능별 변경 맥락">${v.features.map((f,i)=>`<button data-feature="${i}" class="${i===0?'active':''}" aria-pressed="${i===0}">${esc(f.label)}</button>`).join('')}</div><div class="feature-body" aria-live="polite">${featureBody(v.features[0])}</div>${v.icons.length?`<section class="icon-comparison"><h2>새로 그리는 것보다, 의미를 지키기</h2><p>같은 도형으로 통합하던 방식에서 원래 아이콘의 윤곽·색을 유지하는 방식으로 바뀌었습니다.</p><div class="icon-compare-head"><span>기능</span><span>원본</span><span>이전 V423</span><span>원형 유지 SVG</span></div>${v.icons.map(row=>`<div class="icon-compare-row"><strong>${row.label}</strong>${row.images.map((image,i)=>`<span><img src="${image}" alt="${row.label} · ${['원본','이전 V423','원형 유지 SVG'][i]}"></span>`).join('')}</div>`).join('')}</section>`:''}</section>`;}

function lessonPage(id){
 const l=data.lessons.find(l=>l.id===id);if(!l)return notFound();
 const i=data.lessons.indexOf(l),prev=data.lessons[i-1],next=data.lessons[i+1];
 const source=data.sources.find(s=>s.id===l.source);
 return `<div class="page ${id==='worktime-agent'?'worktime-page':''}">${breadcrumbs(['워크플로',l.group])}<div class="lesson-layout"><article class="article"><header class="article-top"><div class="eyebrow">과정 ${lessonNumber(l)} · ${esc(l.group)}</div><h1>${lessonNumber(l)}. ${esc(l.title)}</h1><p class="lead">${esc(l.summary)}</p><div class="article-meta">${categoryBadge(l.category)}</div></header>${l.projectBrief?renderProjectBrief(l):`<div class="goals"><strong>이 과정에서 할 수 있는 일</strong><ul>${l.goals.map(g=>`<li>${esc(g)}</li>`).join('')}</ul></div>`}${l.contextHtml?`<section class="prose case-context" aria-label="이 사례의 시작과 구현 과정">${l.contextHtml}</section>`:''}${l.showcase?renderShowcase(l):''}${id==='worktime-agent'?renderKnowledge(data.worktimeKnowledge):''}<div class="prose lesson-body">${l.html}</div>${conversationForLesson(id)}${lessonPager(prev,next)}</article><aside class="toc" aria-label="이 페이지 목차"><div class="toc-title">이 페이지 목차</div><nav>${l.toc.map(t=>`<a class="depth-${t.depth}" href="${lessonLink(id)}?section=${t.id}" data-section="${t.id}">${esc(t.text)}</a>`).join('')}</nav><div class="source-small">근거 프로젝트<a href="#/library/${l.source==='portal'?'':l.source}">${esc(source?.title||'포털 통합·운영')}</a>원본은 저장소 sources/에 보존합니다.</div></aside></div>${footer()}</div>`;
}
const graphModes={
 core:{title:'소스와 업무 지식의 연결',nodes:[
 ['sap',20,50,'SAP ERP','현재 저장소','업무 소스와 개발 객체를 보관합니다. Export로 추출하고 DIAG로 비교합니다.','지원 객체와 실제 업무 데이터 행을 구분합니다.','export','소스 원천'],
 ['export',245,50,'Export','파일화·원본 보존','패키지 또는 BSP 한 앱을 추출하고 manifest·catalog·baseline을 함께 보존합니다.','기준 0.4.1 · 단일 BSP 앱 ZIP 형식 확인','export','소스 확보'],
 ['git',470,50,'GitHub','이력·검토·공유','담당 패키지의 소스와 지식을 버전 관리합니다. 원본 기준과 변경 이유를 추적합니다.','소스·지식의 이력과 검토 기록 관리','workspace','사용 보고·설계'],
 ['knowledge',20,225,'업무 지식','규정·협의·매뉴얼','업무 기준과 협의 이유를 출처·시점·상태와 함께 기록합니다. 이미지도 실제 내용과 대조합니다.','텍스트 정리 사용 보고 · 이미지 연계는 보완 설계','knowledge','근거 문서'],
 ['codex',245,225,'업무 에이전트','Codex · 지침 · 스킬','소스와 업무 근거를 필요한 범위에서 읽고, 답변·변경 검토·타 담당 질문을 작성합니다.','ZHR5 구성 사용 보고 · 다른 패키지 운영 상태는 별도 확인','codex','사용 보고·설계'],
 ['diag',470,225,'DIAG','비교·검사 결과','원본·추출본·SAP를 비교하고, 지원 웹자산의 선택 반영을 저장·활성화·재검증으로 나누어 확인합니다.','기준 0.7.1 · 0.6.11 BSP 사례 확인 · 최신 SAP 실행 미확인','diagnosis','소스·결과 확보'],
 ['maps',20,400,'Obsidian · 연결 MD','사람의 업무 탐색','기존 폴더에 연결 문서를 추가해 업무 근거를 탐색합니다.','사용자 제공 업무지도·전체 그래프 캡처 확보 · 링크 유효성·성능은 별도 확인','maps','적용 화면 확보'],
 ['feedback',245,400,'담당자 검토·피드백','지식·회귀 사례 갱신','담당자 정정을 업무 지식과 회귀 사례에 반영하고 검증 결과를 기록합니다.','피드백 지침 확보 · 자동 평가 실행기는 미확인','feedback','지침 확보']
 ],edges:[['sap','export'],['export','git'],['git','codex'],['knowledge','codex'],['codex','diag'],['knowledge','maps',true],['codex','feedback'],['maps','feedback',true],['feedback','knowledge',false,'diagonal']],note:'실선: 자료·기능 관계 · 점선: 확장 설계. 구현 상태는 각 요소에서 확인하세요.'},
 remote:{title:'서로 다른 두 MCP 역할',nodes:[
 ['telegram',20,50,'Telegram 봇','모바일 질문','사내 봇이 getUpdates 요청을 시작해 질문을 받고 sendMessage로 답변합니다. 사용자별 대화 연결이 필요합니다.','실제 봇·에이전트 왕복 미검증','erp-mcp','설계 단계'],
 ['agent',245,50,'주 에이전트','사용자 질문·답변','질문에 필요한 ERP 조회 도구나 다른 담당의 자문을 선택하고 결과를 근거와 함께 통합합니다.','Desktop 세션과 봇·자문 세션 자동 공유는 미구현','workspace','연결 설계'],
 ['lookup',470,50,'ERP 조회 MCP','REST 어댑터','기존 ERP API의 입력·권한·필드·단위를 확인해 업무 조회 도구로 제공합니다.','Python은 설명 예시 · 최종 런타임·실제 API 미확정','erp-mcp','설계 단계'],
 ['worker',20,225,'담당 맥 워커','자문 작업 수신','자기 담당의 대기 작업을 가져와 결과를 제출합니다. 현재 제공 워커는 고정 모의 응답입니다.','claim·complete 통신 예제 · 실제 AI 연결 미구현','collaboration','모의 통신 검증'],
 ['hub',245,225,'중앙 자문 MCP','질문·작업 상태','Node.js 중앙 프로그램이 요청을 인증하고 SQLite에 작업을 저장·배정·조회합니다.','0.1.0 예제 · 중앙 서버와 담당 워커로 구성','collaboration','모의 통신 검증'],
 ['erp-api',470,225,'기존 REST / RFC','ERP 업무 조회','실제 업무 조회·계산은 기존 ERP API와 ABAP 함수가 수행합니다. 첫 대상 API와 계약 확인이 필요합니다.','기존 연동 사용 보고 · 이번 MCP 연결은 미확인','erp-mcp','사용 보고·설계'],
 ['expert',20,400,'전문 자문 AI','담당 소스·지식','별도 읽기 전용 자문 실행이 자기 업무 자료를 읽고 근거·기준 커밋·미확인 사항을 반환하는 목표입니다.','실제 AI 실행·취소·heartbeat 구현 필요','collaboration','미구현'],
 ['portal',470,400,'에이전트 공유 사이트','정적 파일 제공','에이전트 프로젝트의 과정과 결과물을 공유하는 정적 웹사이트입니다.','HTML·CSS·JS + MD · DB 불필요','publishing','이번 구현']
 ],edges:[['telegram','agent',true],['agent','lookup',true],['lookup','erp-api',true],['agent','hub'],['hub','worker'],['worker','expert',true]],note:'실선: 중앙 예제의 통신 경로 · 점선: 추가 구현 경로'}
};
graphModes.cases={title:'에이전트 활용사례',nodes:[
 ['case-worktime-agent',0,0,'근로시간 AI 에이전트 구축','11','업무 지식과 소스 설명, 스킬을 하나의 탐색 흐름으로 연결합니다.','','worktime-agent','에이전트 활용사례'],
 ['case-webgui',0,0,'ERP WEBGUI 개편','12','레거시 화면의 기능을 보존하며 UI와 결재 문서 렌더링을 개선합니다.','','webgui','에이전트 활용사례'],
 ['case-publishing',0,0,'ERP AI 에이전트 포털 구축','13','프로젝트의 과정과 결과물을 함께 읽을 수 있는 포털을 만듭니다.','','publishing','에이전트 활용사례'],
 ['case-ess-attendance',0,0,'ESS 근태시스템 개편','14','근태 신청과 변경·결재의 업무 흐름을 개선합니다.','','ess-attendance','에이전트 활용사례'],
 ['case-weekly-timeline',0,0,'업무일지 타임라인 개발','15','주간 기록을 업무의 연속성과 원문 근거로 연결합니다.','','weekly-timeline','에이전트 활용사례'],
 ['case-smart-erp',0,0,'스마트 ERP 메인화면 개편','16','기존 업무 기능을 유지하며 메인화면의 배치와 시각적 체계를 개선합니다.','','smart-erp','에이전트 활용사례']
],edges:[]};
const mapMode=()=>location.hash.split('?')[0].split('/')[2] in graphModes?location.hash.split('?')[0].split('/')[2]:'core';
function graphSVG(mode){
 const g=graphModes[mode];if(mode==='cases')return `<div class="case-map-grid">${g.nodes.map(n=>`<button class="graph-node case-map-node ${graphSelection===n[0]?'selected':''}" data-node="${n[0]}" aria-pressed="${graphSelection===n[0]}"><span>CASE ${n[4]}</span><strong>${esc(n[3])}</strong><p>${esc(n[5])}</p></button>`).join('')}</div>`;const byId=Object.fromEntries(g.nodes.map(n=>[n[0],n]));
 const w=180,h=77;
 const edges=g.edges.map(([a,b,planned,shape])=>{
  const A=byId[a],B=byId[b];let x1=A[1]+w/2,y1=A[2]+h/2,x2=B[1]+w/2,y2=B[2]+h/2,d;
  if(shape==='diagonal'){
   const dx=x2-x1,dy=y2-y1,t=Math.min(w/2/Math.abs(dx),h/2/Math.abs(dy));
   d=`M${x1+dx*t} ${y1+dy*t}L${x2-dx*t} ${y2-dy*t}`;
  }
  else if(A[2]===B[2]){x1+=(B[1]>A[1]?w/2:-w/2);x2+=(B[1]>A[1]?-w/2:w/2);d=`M${x1} ${y1}H${x2}`;}
  else{y1+=h/2;y2-=h/2;const mid=(y1+y2)/2;d=`M${x1} ${y1}V${mid}H${x2}V${y2}`;}
  return `<path d="${d}" data-from="${a}" data-to="${b}" class="graph-line ${shape==='diagonal'?'feedback-line':''} ${planned?'planned':''}" marker-end="url(#head-${mode})"/>`;
 }).join('');
 return `<svg class="system-diagram" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 675 505" role="group" aria-label="${g.title}"><defs><marker id="head-${mode}" markerWidth="7" markerHeight="7" refX="6" refY="3.5" orient="auto"><path d="M0 0L7 3.5L0 7" class="graph-arrow"/></marker></defs>${edges}${mode==='core'?'<text class="feedback-label" x="233" y="359">지식·사례 갱신</text>':''}${g.nodes.map(n=>`<g class="graph-node ${graphSelection===n[0]?'selected':''}" data-node="${n[0]}" tabindex="0" role="button" aria-label="${esc(n[3])} 설명 보기" aria-pressed="${graphSelection===n[0]}"><rect x="${n[1]}" y="${n[2]}" width="${w}" height="${h}" rx="4"/><text class="graph-label" x="${n[1]+w/2}" y="${n[2]+32}" text-anchor="middle">${esc(n[3])}</text><text class="graph-small" x="${n[1]+w/2}" y="${n[2]+55}" text-anchor="middle">${esc(n[4])}</text></g>`).join('')}</svg>`;
}
function nodeDetail(mode){const n=graphModes[mode].nodes.find(n=>n[0]===graphSelection)||graphModes[mode].nodes[0];return `<div class="eyebrow">선택한 구성 요소</div>${badge(n[8])}<h2>${esc(n[3])}</h2><p>${esc(n[5])}</p><div class="detail-role">${esc(n[6])}</div><div class="map-detail-actions"><button class="btn primary" data-open-conversation>실제 대화 읽기 ↓</button><a class="btn" href="${lessonLink(n[7])}">관련 과정 읽기</a></div>${['codex','knowledge','maps','feedback'].includes(n[0])?'<p><a class="text-link" href="#/learn/worktime-agent">근로시간 에이전트의 실제 MD 지도 ↗</a></p>':''}<p class="map-conversation-count">관련 프로젝트 에피소드 ${relatedConversationCount(data.conversations,n[0])}개</p>`;}
function mapPage(mode='core'){
 if(!graphModes[mode])mode='core';
 if(!graphModes[mode].nodes.some(n=>n[0]===graphSelection))graphSelection=mode==='core'?'codex':mode==='remote'?'hub':'case-worktime-agent';
 return `<div class="page">${breadcrumbs(['전체 구성도'])}<div class="eyebrow">전체 구성도</div><h1 class="page-title">ERP AI 에이전트 전체 구성도</h1><p class="page-description">구성 요소를 선택해 역할과 관련 프로젝트 대화를 살펴보세요.</p><div class="filter-tabs" aria-label="구성도 종류"><button data-map="core" class="${mode==='core'?'active':''}" aria-pressed="${mode==='core'}">에이전트 구축</button><button data-map="remote" class="${mode==='remote'?'active':''}" aria-pressed="${mode==='remote'}">에이전트 협업 및 조회</button><button data-map="cases" class="${mode==='cases'?'active':''}" aria-pressed="${mode==='cases'}">에이전트 활용사례</button></div><div class="map-layout"><div class="diagram-box"><div id="graph-host">${graphSVG(mode)}</div></div><aside class="map-detail" id="map-detail" aria-live="polite">${nodeDetail(mode)}</aside></div><div id="conversation-host" class="map-conversation-host">${renderConversation()}</div>${footer()}</div>`;
}
function libraryPage(id){
 const source=[...data.sources,...(data.coreDocuments||[])].find(s=>s.id===id);
 if(id&&!source)return notFound();
 if(source)return `<div class="page source-detail-page">${breadcrumbs(['자료실',source.title])}<p><a class="text-link" href="#/library">← 자료실</a></p>${renderSourceDocuments(source)}${footer()}</div>`;
 return `<div class="page library-page">${breadcrumbs(['자료실'])}<h1 class="visually-hidden">자료실</h1><div class="resource-grid">${data.sources.map((s,i)=>`<section class="source-card"><div class="source-head"><span class="source-id">SOURCE ${String(i+1).padStart(2,'0')}</span>${categoryBadge(s.category)}</div><h3>${esc(s.title)}</h3><div class="source-links">${s.lessons.map(id=>`<a href="${lessonLink(id)}">과정 ${lessonNumber(data.lessons.find(l=>l.id===id))}. ${esc(data.lessons.find(l=>l.id===id).title)}</a>`).join('')}</div><div class="source-foot"><span>MD ${s.mdCount}개</span><a class="text-link" href="#/library/${s.id}" data-source-open="${s.id}" aria-haspopup="dialog">자료확인</a></div></section>`).join('')}</div><section class="core-md-section" aria-labelledby="core-md-title"><h2 id="core-md-title">핵심 MD 자료</h2><div class="core-md-files">${(data.coreDocuments||[]).map(g=>`<div class="core-md-row"><div><h3>${esc(g.title)}</h3><p>${esc(g.description)}</p></div><span>MD ${g.mdDocuments.length}개</span><a class="text-link" href="#/library/${g.id}" data-source-open="${g.id}" aria-haspopup="dialog">자료확인 ↗</a></div>`).join('')}</div></section>${footer()}</div>`;
}
function openSourceDocuments(id,trigger){
 const source=[...data.sources,...(data.coreDocuments||[])].find(s=>s.id===id);if(!source)return;
 const dialog=$('#source-dialog');sourceDialogTrigger=trigger;
 $('#source-dialog-content').innerHTML=renderSourceDocuments(source);
 hydratePreviewAssets(dialog);dialog.showModal();document.body.classList.add('source-modal-open');dialog.querySelector('[data-source-search]')?.focus();
}
function notFound(){return `<div class="error-state"><h1>페이지를 찾을 수 없습니다.</h1><p>과정 목록에서 원하는 과정을 선택해 주세요.</p><a class="btn primary" href="#/courses">워크플로 보기</a></div>`;}
function route(){
 $('#source-dialog')?.close();
 $('#source-dialog-content').innerHTML='';
 countCleanup?.(); countCleanup=undefined;
 heroCleanup?.(); heroCleanup=undefined;
 knowledgeCleanup?.(); knowledgeCleanup=undefined;
 const hash=location.hash.replace(/^#\/?/,'')||'home';const [p,q]=hash.split('?');const parts=p.split('/');
 const params=new URLSearchParams(q);
 if(parts[0]==='cases'){const target={compare:'diagnosis',evidence:'diagnosis',webgui:'webgui','ess-attendance':'ess-attendance'}[parts[1]];location.replace(target?lessonLink(target):'#/courses');return;}
 if(parts[0]==='map'){
  const mode=graphModes[parts[1]]?parts[1]:'core';
  if(graphModes[mode].nodes.some(n=>n[0]===params.get('node')))graphSelection=params.get('node');
  if(!graphModes[mode].nodes.some(n=>n[0]===graphSelection))graphSelection=mode==='core'?'codex':mode==='remote'?'hub':'case-worktime-agent';
  conversationState={node:graphSelection,projectId:params.get('project'),episodeId:params.get('episode'),tab:params.get('tab')||'dialogue',visible:4};
 }
 if(parts[0]==='conversations')conversationState={projectId:parts[1],episodeId:parts[2],tab:params.get('tab')||'dialogue',visible:4};
 document.body.classList.toggle('home-mode',parts[0]==='home');
 sidebar(parts);
 let html;
 switch(parts[0]){case 'home':html=home();break;case 'courses':html=courses();break;case 'learn':html=lessonPage(parts[1]);break;case 'map':html=mapPage(parts[1]);break;case 'conversations':html=conversationsPage(parts[1]);break;case 'library':html=libraryPage(parts[1]);break;default:html=notFound();}
 $('#main').innerHTML=html;
 hydratePreviewAssets($('#main'));
 if(parts[0]==='learn'&&parts[1]==='worktime-agent')knowledgeCleanup=mountKnowledge($('[data-knowledge]'),data.worktimeKnowledge,{docId:params.get('doc'),openDocument:params.get('read')==='1',hydrate:hydratePreviewAssets});
 if(parts[0]==='home')heroCleanup=mountHeroMotion($('.hero'));
 document.title=(parts[0]==='learn'?(data.lessons.find(l=>l.id===parts[1])?.title||'과정')+' | ':'')+data.title;
 closeMenu();
 if(lastRoute!==p){window.scrollTo({top:0,behavior:'instant'});if(lastRoute)$('#main').focus({preventScroll:true});}
 lastRoute=p;
 if(parts[0]==='learn'&&parts[1]==='worktime-agent'&&params.get('doc')&&params.get('read')==='1')document.getElementById('km-selected')?.scrollIntoView({block:'start',behavior:'instant'});
 countCleanup=mountCountUps($('#main'));
 if(q){const section=new URLSearchParams(q).get('section');if(/^(?:context-)?section-\d+$/.test(section)||section==='core-md-title')document.getElementById(section)?.scrollIntoView();}
}
function closeMenu(){$('#sidebar').classList.remove('open');$('#menu-scrim').hidden=true;$('#menu-toggle').setAttribute('aria-expanded','false');document.body.classList.remove('no-scroll');}
function openSearch(){lastFocused=document.activeElement;$('#search-dialog').showModal();$('#search-input').value='';search('');$('#search-input').focus();}
function search(query){const terms=query.trim().toLocaleLowerCase().split(/\s+/).filter(Boolean);if(!terms.length){$('#search-results').innerHTML='<div class="empty-state">과정 본문, 실제 대화·에피소드, 근로시간 MD 제목·경로·요약에서 검색합니다.<br>baseline, 원격 자문, 파일 시각 등을 입력해 보세요.</div>';return;}
 const entries=[...data.lessons.map(l=>({title:l.title,group:`과정 ${lessonNumber(l)} · ${l.group}`,url:lessonLink(l.id),text:l.summary+' '+l.search})),...conversationSearchEntries(data.conversations).map(e=>({...e,group:'대화 · '+e.group})),...data.worktimeKnowledge.documents.map(d=>({title:d.title,group:'근로시간 MD · '+d.path,url:'#/learn/worktime-agent?doc='+d.id,text:d.path+' '+d.summary}))];
 const results=entries.map(l=>({l,hay:(l.title+' '+l.text).toLowerCase()})).filter(({hay})=>terms.every(t=>hay.includes(t))).sort((a,b)=>Number(b.l.title.toLowerCase().includes(terms[0]))-Number(a.l.title.toLowerCase().includes(terms[0])));
 const highlight=s=>{const parts=s.split(new RegExp(`(${terms.map(t=>t.replace(/[.*+?^${}()|[\]\\]/g,'\\$&')).join('|')})`,'gi'));return parts.map(x=>terms.includes(x.toLowerCase())?`<mark>${esc(x)}</mark>`:esc(x)).join('');};
 $('#search-results').innerHTML=results.length?results.map(({l})=>{const text=l.text.replace(/\s+/g,' '),idx=text.toLowerCase().indexOf(terms[0]);const start=Math.max(0,idx-40);return `<a class="search-result" href="${l.url}"><small>${esc(l.group)}</small><h3>${highlight(l.title)}</h3><p>${start?'… ':''}${highlight(text.slice(start,start+150))} …</p></a>`;}).join(''):'<div class="empty-state">일치하는 프로젝트 내용을 찾지 못했습니다.<br>더 짧은 단어나 다른 용어로 검색해 보세요.</div>';
}
async function copy(text){try{if(navigator.clipboard&&window.isSecureContext)await navigator.clipboard.writeText(text);else{const t=document.createElement('textarea');t.value=text;t.style.position='fixed';t.style.opacity='0';document.body.append(t);t.select();const ok=document.execCommand('copy');t.remove();if(!ok)throw Error('copy');}notify('복사했습니다.');}catch{notify('자동 복사를 사용할 수 없습니다. 내용을 선택해 복사해 주세요.');}}
document.addEventListener('click',e=>{
 const target=e.target.closest('a,button,[data-node]');if(!target)return;
 if(target.matches('[data-gallery],[data-feature]')){
  const root=target.closest('[data-showcase]'),l=data.lessons.find(l=>l.id===root.dataset.showcase);
  const isGallery=target.hasAttribute('data-gallery'),index=Number(isGallery?target.dataset.gallery:target.dataset.feature);
  target.parentElement.querySelectorAll('button').forEach(b=>{b.classList.toggle('active',b===target);b.setAttribute('aria-pressed',String(b===target));});
  if(isGallery){const g=l.showcase.gallery[index],figure=root.querySelector('.showcase-image');figure.querySelector('img').src=g.image;figure.querySelector('img').alt=g.caption;figure.querySelector('button').dataset.image=g.image;figure.querySelector('figcaption').textContent=g.caption;hydratePreviewAssets(figure);}
  else root.querySelector('.feature-body').innerHTML=featureBody(l.showcase.features[index]);return;
 }
 if(target.matches('[data-source-open]')){e.preventDefault();openSourceDocuments(target.dataset.sourceOpen,target);return;}
 if(target.matches('.skip')){e.preventDefault();$('#main').focus();$('#main').scrollIntoView();return;}
 if(target.matches('[data-close-dialog]')){target.closest('dialog').close();return;}
 if(target.matches('.search-result'))$('#search-dialog').close();
 if(target.matches('[data-filter]')){currentFilter=target.dataset.filter;route();}
 if(target.matches('[data-section]')){e.preventDefault();document.getElementById(target.dataset.section)?.scrollIntoView({behavior:'smooth'});}
 if(target.matches('[data-copy]'))copy(target.closest('.codeblock').querySelector('code').textContent);
 if(target.matches('[data-chat-copy]')){const m=data.conversations.projects.find(p=>p.id===target.dataset.projectId)?.messages.find(m=>m.id===target.dataset.chatCopy);if(m)copy(m.editorial_markdown??m.content_markdown);}
 if(target.matches('[data-exercise-copy]')){const selection=resolveConversation(data.conversations,conversationState);if(selection)copy(selection.episode.exercise_markdown);}
 if(target.matches('[data-open-conversation]')){$('#conversation-heading')?.scrollIntoView({block:'start'});$('#conversation-heading')?.focus({preventScroll:true});}
 if(target.matches('[data-conversation-episode]')){conversationState.episodeId=target.dataset.conversationEpisode;conversationState.visible=4;conversationState.tab='dialogue';updateConversation('conversation-episode-title',true);}
 if(target.matches('[data-conversation-tab]')){conversationState.tab=target.dataset.conversationTab;updateConversation('conversation-pane');}
 if(target.matches('[data-conversation-more]')){const s=resolveConversation(data.conversations,conversationState);const count=conversationVisibleCount(s.messages,conversationState.visible);const next=s.messages[count];conversationState.visible=count+1;updateConversation(next?`message-${s.project.id}-${next.id}`:null);}
 if(target.matches('[data-conversation-all]')){conversationState.visible=999;updateConversation('conversation-pane');}
 if(target.matches('[data-image-size]')){const active=$('#image-dialog').classList.toggle('actual-size');target.textContent=active?'화면에 맞추기':'원본 크기로 보기';target.setAttribute('aria-pressed',String(active));}
 if(target.matches('[data-image]')){$('#image-dialog').classList.remove('actual-size');$('#image-size').textContent='원본 크기로 보기';$('#image-size').setAttribute('aria-pressed','false');$('#large-image').src=target.dataset.image;$('#large-image').alt=target.querySelector('img').alt;$('#image-dialog').showModal();}
 if(target.matches('[data-map]')){graphSelection=graphModes[target.dataset.map].nodes[0][0];location.hash=`#/map/${target.dataset.map}`;}
 if(target.matches('[data-node]')){graphSelection=target.dataset.node;const mode=mapMode();document.querySelectorAll('.graph-node').forEach(n=>{n.classList.toggle('selected',n.dataset.node===graphSelection);n.setAttribute('aria-pressed',n.dataset.node===graphSelection);});$('#map-detail').innerHTML=nodeDetail(mode);conversationState={node:graphSelection,tab:'dialogue',visible:4};updateConversation();}
});
document.addEventListener('input',e=>{if(e.target.matches('[data-source-search]'))filterSourceDocuments(e.target.closest('[data-source-documents]'),e.target.value);if(e.target.id==='search-input')search(e.target.value);});
document.addEventListener('change',e=>{if(e.target.matches('[data-conversation-select]')){conversationState.projectId=e.target.value;conversationState.episodeId=null;conversationState.visible=4;conversationState.tab='dialogue';updateConversation('conversation-project-select');}});
document.addEventListener('keydown',e=>{
 const typing=/INPUT|TEXTAREA|SELECT/.test(e.target.tagName);
 if(e.target.matches('[data-node]')&&(e.key==='Enter'||e.key===' ')){e.preventDefault();e.target.dispatchEvent(new MouseEvent('click',{bubbles:true}));}
 if(!typing&&e.key==='/'&&!e.ctrlKey&&!e.metaKey&&!document.querySelector('dialog[open]')){e.preventDefault();openSearch();}
 if(e.key==='Escape'){closeMenu();}
});
$('#menu-toggle').addEventListener('click',()=>{const open=!$('#sidebar').classList.contains('open');$('#sidebar').classList.toggle('open',open);$('#menu-scrim').hidden=!open;$('#menu-toggle').setAttribute('aria-expanded',open);document.body.classList.toggle('no-scroll',open);});
$('#menu-scrim').addEventListener('click',closeMenu);
$('#search-open').addEventListener('click',openSearch);
$('#search-dialog').addEventListener('close',()=>lastFocused?.focus());
$('#source-dialog').addEventListener('close',()=>{document.body.classList.remove('source-modal-open');sourceDialogTrigger?.isConnected&&sourceDialogTrigger.focus();});
for(const d of document.querySelectorAll('dialog'))d.addEventListener('click',e=>{if(e.target===d){const r=d.getBoundingClientRect();if(e.clientX<r.left||e.clientX>r.right||e.clientY<r.top||e.clientY>r.bottom)d.close();}});
try{const r=await fetch('data/portal.json');if(!r.ok)throw Error('자료 응답 오류');data=await r.json();route();window.addEventListener('hashchange',route);}catch(error){$('#main').innerHTML='<div class="error-state"><h1>프로젝트 자료를 불러오지 못했습니다.</h1><p>파일을 직접 열었다면 저장소 폴더에서 <code>npm run build</code> 후 <code>npm start</code>로 실행해 주세요.</p><p>웹서버에서는 dist 폴더 전체가 배포되어 있는지 확인해 주세요.</p><button class="btn primary" id="retry">다시 시도</button></div>';$('#retry').onclick=()=>location.reload();console.error(error);}
