import {countNumber,mountCountUps} from './count-up.js?v=7d479e1ba83b';
import {renderKnowledge,mountKnowledge} from './knowledge.js?v=7d479e1ba83b';
import {compare} from './compare.js?v=7d479e1ba83b';
import {mountHeroMotion} from './hero-motion.js?v=7d479e1ba83b';
import {renderPresentation,mountPresentation} from './presentation.js?v=7d479e1ba83b';
import {conversationIndex,conversationWorkspace,resolveConversation,conversationVisibleCount,relatedConversationCount,conversationLink,conversationSearchEntries} from './conversations.js?v=7d479e1ba83b';
let heroCleanup, presentationCleanup, knowledgeCleanup, countCleanup;
const $=s=>document.querySelector(s);
const esc=s=>String(s??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const icons={print:'<path d="M6 9V3h12v6M6 17H3V9h18v8h-3"/><path d="M6 14h12v7H6z"/><path d="M17 12h1"/>',download:'<path d="M12 3v12m-5-5 5 5 5-5M4 16v5h16v-5"/>',home:'<path d="m3 10 9-7 9 7v10H3z"/><path d="M9 20v-7h6v7"/>',book:'<path d="M12 5v16M3 4c4-1 6 0 9 2 3-2 5-3 9-2v15c-4-1-6 0-9 2-3-2-5-3-9-2z"/>',map:'<rect x="8" y="2" width="8" height="5" rx="1"/><rect x="2" y="17" width="7" height="5" rx="1"/><rect x="15" y="17" width="7" height="5" rx="1"/><path d="M12 7v5M5.5 17v-5h13v5"/>',case:'<path d="M8 3H4v18h16V3h-4"/><rect x="8" y="2" width="8" height="4" rx="1"/><path d="m7 12 3 3 7-7"/>',folder:'<path d="M3 5h7l2 3h9v12H3z"/>',code:'<path d="m8 6-5 6 5 6m8-12 5 6-5 6m-3-15-2 18"/>',nodes:'<circle cx="6" cy="6" r="3"/><circle cx="18" cy="6" r="3"/><circle cx="12" cy="19" r="3"/><path d="m7 9 4 7m6-7-4 7M9 6h6"/>'};
const icon=(name,size=20)=>`<svg width="${size}" height="${size}" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">${icons[name]||icons.book}</svg>`;
let data,currentFilter='전체',graphSelection='codex',lastRoute='',lastFocused;
let conversationState={tab:'dialogue',visible:4};
function notify(text){$('#toast').textContent=text;$('#toast').classList.add('visible');clearTimeout(notify.timer);notify.timer=setTimeout(()=>$('#toast').classList.remove('visible'),2500);}
function badge(status){const cls=/설계|미확인/.test(status)?'design':/검증/.test(status)?'test':/개념/.test(status)?'neutral':'';return `<span class="badge ${cls}">${esc(status)}</span>`;}
const groupSymbols=[
 '<path d="m12 2 10 10-10 10L2 12Z"/><path d="m12 7 5 5-5 5-5-5Z"/>',
 '<rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><path d="M14 17.5h7m-3.5-3.5v7"/>',
 '<circle cx="5" cy="6" r="3"/><circle cx="19" cy="6" r="3"/><circle cx="12" cy="19" r="3"/><path d="M8 6h8M6.5 9l4 7m7-7-4 7"/>',
 '<path d="M12 2 21 6v6c0 5-9 10-9 10S3 17 3 12V6Z"/><path d="m7 12 3 3 7-7"/>'
];
const groupIcon=g=>`<span class="group-icon" aria-hidden="true"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linejoin="round" stroke-linecap="round">${groupSymbols[data.groups.indexOf(g)]||groupSymbols[0]}</svg></span>`;
const lessonLink=id=>`#/learn/${id}`;
const caseItems=[
 {id:'compare',title:'ERP 코드 형상관리 · 세 방향 비교',icon:'nodes',tag:'원본 · 추출본 · SAP',question:'같은 3,210 bytes, 왜 ‘수정’일까요?',summary:'원본·추출본·현재 SAP의 값을 바꾸며 비교 결과가 달라지는 이유를 확인합니다.',action:'비교 실습하기'},
 {id:'evidence',title:'ERP 코드 형상관리 · DIAG 결과 읽기',icon:'case',tag:'실제 결과 · XLSX',question:'결과표의 숫자는 무엇을 뜻할까요?',summary:'확보한 결과를 읽으며 읽기 실패·활성 근거·검사 미수행을 구분합니다.',action:'결과 살펴보기'},
 {id:'webgui',title:'WEBGUI 개선과 검증',icon:'code',tag:'WebGUI · 동작과 근거',question:'디자인 개선과 업무 검증을 어떻게 나눌까요?',summary:'ITS 적용 결과·재추출 V3·결재 화면 렌더러와 RFC 설계를 살펴봅니다.',action:'사례 살펴보기'},
 {id:'ess-attendance',title:'ESS 근태시스템 개편',icon:'case',tag:'BSP · 저장과 결재',question:'화면에서 바뀐 날짜가 실제로 반영됐을까요?',summary:'R1 분리 개발부터 기승인 변경·반차·중복 제출까지 실제 대화와 검증 근거를 따라갑니다.',action:'ESS 사례 읽기'}
];
const footer=()=>`<footer class="site-footer"><span>KBS · ERP AI 에이전트 교육 포털</span><span>자료 기준 ${data.asOf} · v${data.version}</span></footer>`;
function hydratePreviewAssets(root){
 const files=globalThis.erpPreviewFiles;if(!files||!root)return;
 for(const el of root.querySelectorAll('[href],[src],[data-image]'))for(const attr of ['href','src','data-image']){
  const url=el.getAttribute(attr);if(files[url]){el.setAttribute(attr,files[url]);if(attr==='href'&&el.hasAttribute('download')&&!el.getAttribute('download'))el.setAttribute('download',url.split('/').at(-1));}
 }
}
function conversationForLesson(id){
 const project=data.conversations.projects.find(p=>p.lessonIds.includes(id));if(!project)return '';
 const preferred={overview:'E01',export:'E01',workspace:'E05',diagnosis:'E11',feedback:'E07'};
 const episode=preferred[id]||project.episodes[0].id;
 return `<a class="lesson-conversation-link" href="${conversationLink(project.id,episode)}">${icon('nodes',24)}<span><strong>이 과정의 실제 대화</strong><span>요청부터 수정·검증까지 읽기 ↗</span></span></a>`;
}
function renderConversation(){
 const node=Object.values(graphModes).flatMap(g=>g.nodes).find(n=>n[0]===conversationState.node);
 return conversationWorkspace(data.conversations,{...conversationState,nodeLabel:node?.[3]});
}
function updateConversation(focusId,scroll=false){
 const selection=resolveConversation(data.conversations,conversationState);if(!selection)return;
 conversationState.projectId=selection.project.id;conversationState.episodeId=selection.episode.id;
 const host=$('#conversation-host');if(!host)return;
 const opened=[...host.querySelectorAll('details[id][open]')].map(d=>d.id);
 host.innerHTML=renderConversation();
 for(const id of opened){const detail=document.getElementById(id);if(detail)detail.open=true;}
 hydratePreviewAssets(host);
 const q=new URLSearchParams({tab:conversationState.tab||'dialogue'});
 let hash;
 if(conversationState.node){q.set('node',conversationState.node);q.set('project',selection.project.id);q.set('episode',selection.episode.id);hash=`#/map/${location.hash.includes('/remote')?'remote':'core'}?${q}`;}
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
 return `<div class="page conversation-page">${breadcrumbs(['프로젝트 대화'])}<div class="eyebrow">실제 프로젝트 기록</div><h1 class="page-title">프로젝트 대화 학습</h1><p class="page-description">학습 흐름을 선택하고 당시 요청·응답, 해설, 따라 하기를 차례로 확인하세요.</p><div class="conversation-page-back"><a class="text-link" href="#/conversations">← 모든 프로젝트 보기</a><a class="text-link" href="#/map/core">전체 구성도 보기 ↗</a></div><div id="conversation-host">${renderConversation()}</div>${footer()}</div>`;
}
function sidebar(route){
 const active=route[0]||'home';
 const nav=[['home','home','교육 홈'],['courses','book','학습 과정'],['map','map','전체 구성도'],['conversations','nodes','프로젝트 대화'],['cases','case','사례 실습'],['library','folder','자료실']];
 $('#sidebar').innerHTML=`<nav class="side-primary">${nav.map(([id,ic,t])=>`<a href="#/${id}" class="side-link ${active===id?'active':''}" ${active===id?'aria-current="page"':''}>${icon(ic)}<span>${t}</span></a>`).join('')}</nav><div class="side-label">교육 과정</div><nav aria-label="교육 과정">${data.groups.map(g=>`<div class="side-group">${groupIcon(g)}<span>${esc(g)}</span></div>${data.lessons.filter(l=>l.group===g).map(l=>`<a href="${lessonLink(l.id)}" class="lesson-link ${route[1]===l.id?'active':''}" ${route[1]===l.id?'aria-current="page"':''}><span class="num">${String(l.number).padStart(2,'0')}</span><span>${esc(l.title.replace('실제 사례: ',''))}</span></a>`).join('')}`).join('')}</nav><div class="sidebar-bottom"><strong>자료 기준 ${esc(data.asOf.replaceAll('-','.'))}</strong>현행 기능과 확장 설계를 함께 다룹니다.</div>`;
}
const breadcrumbs=parts=>`<div class="breadcrumb"><a href="#/home">교육 홈</a>${parts.map(p=>`<span class="sep">/</span><span>${esc(p)}</span>`).join('')}</div>`;
function home(){
 const next=data.lessons[0];
 // Keep the home as a curated entry point; new content can live in the full indexes.
 const homeCases=['compare','evidence','webgui','ess-attendance'].map(id=>caseItems.find(c=>c.id===id));
 const expansion=['collaboration','erp-mcp'].map(id=>data.lessons.find(l=>l.id===id));
 const paths=[
  ['01','처음 이해하기',1,3],
  ['02','내 업무에 적용하기',4,7],
  ['03','팀으로 확장하기',8,13]
 ];
 return `<div class="page home-page"><section class="hero-band"><div class="home-inner"><div class="hero-meta"><span>KBS / ERP AI LEARNING</span><span>v${esc(data.version)} · 자료 기준 ${esc(data.asOf.replaceAll('-','.'))}</span></div><div class="hero"><div class="hero-copy"><div class="eyebrow">BUILD · UNDERSTAND · COLLABORATE</div><h1 class="hero-title" aria-label="ERP AI, 이해에서 실무로."><span class="type-line signature-word" aria-hidden="true"><span class="type-reserve">ERP AI,</span><span class="type-output" data-type-output data-text="ERP AI,">ERP AI,</span></span><span class="type-line" aria-hidden="true"><span class="type-reserve">이해에서 실무로.</span><span class="type-output" data-type-output data-text="이해에서 실무로.">이해에서 실무로.</span></span></h1><p>소스와 업무 맥락을 연결하고,<br>우리 팀의 에이전트 환경을 만들어 갑니다.</p><div class="hero-actions"><a class="btn primary" href="${lessonLink(next.id)}">학습 시작하기 <span aria-hidden="true">↗</span></a><a class="btn hero-secondary" href="#/map">전체 구성도 보기 <span aria-hidden="true">↗</span></a></div></div><div class="hero-media" role="img" aria-label="올리브 나무를 중심으로 협업하는 사람들. 컴퓨터 화면의 카드와 글자가 차례로 나타납니다."><div class="hero-art hero-art-light" aria-hidden="true">${data.heroScene}</div><div class="hero-art hero-art-dark" aria-hidden="true">${data.heroSceneDark}</div></div></div><div class="hero-foot"><span>현행 기능부터 확장 설계까지</span><a href="#/courses">${countNumber(data.lessons.length)}개 과정 둘러보기 <span aria-hidden="true">↓</span></a></div></div></section>
 <div class="home-inner home-content"><section class="intro-section" aria-label="교육 자료 구성"><div class="section-top"><div><div class="eyebrow">BUILT FROM OUR WORK</div><h2>우리 프로젝트가<br>학습의 출발점입니다.</h2></div><p>각 프로젝트에 흩어진 소스와 문서를<br>팀이 함께 읽는 교육 과정으로 연결했습니다.</p></div><div class="stats-strip"><a href="#/library" class="stat"><span class="stat-label">SOURCE BUNDLES</span><strong>${countNumber(data.sources.length,2)}</strong><span>원천 자료 묶음 <b aria-hidden="true">↗</b></span></a><a href="#/conversations" class="stat"><span class="stat-label">LEARNING EPISODES</span><strong>${countNumber(data.conversations.totals.episodes)}</strong><span>대화로 배우는 에피소드 <b aria-hidden="true">↗</b></span></a><a href="#/courses" class="stat"><span class="stat-label">LEARNING MODULES</span><strong>${countNumber(data.lessons.length)}</strong><span>단계별 교육 과정 <b aria-hidden="true">↗</b></span></a></div></section>
 <section class="learning-paths"><div class="section-top"><div><div class="eyebrow">YOUR LEARNING PATH</div><h2>한 단계씩, 다음으로.</h2><p>전체 구조를 이해하고, 업무에 적용하고, 팀으로 확장하세요.</p></div><a class="text-link" href="#/courses">전체 과정 보기 ↗</a></div><div class="path-list">${paths.map(([n,title,start,end])=>`<section class="path-entry"><span class="path-number">STEP / ${n}</span><div class="path-title"><h3>${title}</h3></div><ol class="path-courses" start="${start}">${data.lessons.filter(l=>l.number>=start&&l.number<=end).map(l=>`<li><a href="${lessonLink(l.id)}"><span class="path-course-number">${String(l.number).padStart(2,'0')}.</span><span>${esc(l.title)}</span></a></li>`).join('')}</ol></section>`).join('')}</div></section></div>
 <section class="home-section home-practice" aria-labelledby="home-practice-title"><div class="home-inner"><div class="section-top"><div><div class="eyebrow">LEARN BY DOING</div><h2 id="home-practice-title">사례 실습 <span class="section-count">${countNumber(homeCases.length)}개</span></h2><p>직접 비교하고, 결과를 읽고, 동작을 확인해 보세요.</p></div><a class="text-link" href="#/cases">전체 사례 보기 ↗</a></div><div class="practice-grid">${homeCases.map(c=>`<a class="home-card practice-card" href="#/cases/${c.id}"><div class="home-card-top"><span class="home-card-icon">${icon(c.icon,24)}</span><span class="home-card-tag">${esc(c.tag)}</span></div><h3>${esc(c.title)}</h3><p class="home-card-question">${esc(c.question)}</p><p class="home-card-description">${esc(c.summary)}</p><span class="home-card-action">${esc(c.action)}<span aria-hidden="true">↗</span></span></a>`).join('')}</div></div></section>
 <section class="home-section home-expansion" aria-labelledby="home-expansion-title"><div class="home-inner"><div class="section-top"><div><div class="eyebrow">CONNECT & EXPAND</div><h2 id="home-expansion-title">확장 설계 <span class="section-count">${countNumber(expansion.length)}개</span></h2><p>담당 에이전트의 협업과 ERP 조회·모바일 연결을 설계합니다.</p></div><a class="text-link" href="#/map/remote">연결 구성도 보기 ↗</a></div><div class="expansion-grid">${expansion.map(l=>`<a class="home-card expansion-card" href="${lessonLink(l.id)}"><div class="home-card-top"><span class="home-card-icon">${icon(l.id==='collaboration'?'nodes':'map',24)}</span>${badge(l.status)}</div><span class="home-card-tag">LESSON ${String(l.number).padStart(2,'0')} · ${esc(l.tag)}</span><h3>${esc(l.title)}</h3><p class="home-card-description">${esc(l.summary)}</p><span class="home-card-action">설계 과정 읽기<span aria-hidden="true">↗</span></span></a>`).join('')}</div><p class="home-section-note">원격 자문: 모의 통신 검증 · 실제 AI 워커: 미구현 · ERP·Telegram: 설계 단계</p></div></section>
 <div class="home-inner home-ending">${footer()}</div></div>`;
}
function courses(){
 const selected=data.lessons.filter(l=>currentFilter==='전체'||l.group===currentFilter);
 return `<div class="page">${breadcrumbs(['학습 과정'])}<div class="eyebrow">교육 과정</div><h1 class="page-title">ERP AI 학습 과정 <span class="section-count">총 ${countNumber(data.lessons.length)}개</span></h1><p class="page-description">기초 개념부터 업무 적용과 사례 실습까지 단계별로 배웁니다.</p><div class="filter-tabs" aria-label="과정 분류">${['전체',...data.groups].map(g=>`<button data-filter="${esc(g)}" class="${currentFilter===g?'active':''}" aria-pressed="${currentFilter===g}">${esc(g)}</button>`).join('')}</div><div class="lesson-groups">${data.groups.filter(g=>selected.some(l=>l.group===g)).map((g,i)=>`<section class="course-group"><div class="group-heading">${groupIcon(g)}<h2>${g}</h2></div>${selected.filter(l=>l.group===g).map(l=>`<a class="lesson-row" href="${lessonLink(l.id)}"><span class="row-number">${String(l.number).padStart(2,'0')}</span><div><h3>${esc(l.title)}</h3><p>${esc(l.summary)}</p></div>${badge(l.status)}</a>`).join('')}</section>`).join('')}</div>${footer()}</div>`;
}
function lessonTools(l){return `<section class="lesson-tools" aria-label="교육 자료 저장"><div class="lesson-tools-heading"><strong>이 과정 자료</strong><span>인쇄하거나 파일로 보관하세요.</span></div><div class="lesson-tool-actions"><button class="btn tool-print" data-print>${icon('print')}<span>인쇄 · PDF 저장</span></button><a class="btn primary tool-download" href="content/${l.file}" download="${esc(l.file.split('/').pop())}">${icon('download')}<span>교육 MD 다운로드</span></a></div><p class="lesson-tools-note">PDF는 인쇄 창에서 ‘PDF로 저장’을 선택해 주세요.</p></section>`;}
function lessonPager(prev,next){return `<nav class="lesson-pager" aria-label="이전 다음 과정"><a class="pager-card pager-prev" href="${prev?lessonLink(prev.id):'#/courses'}"><span class="pager-label">← ${prev?'이전 과정 · '+String(prev.number).padStart(2,'0'):'전체 과정'}</span><strong>${prev?esc(prev.title):'학습 과정 목록'}</strong></a><a class="pager-card pager-next" href="${next?lessonLink(next.id):'#/courses'}"><span class="pager-label">${next?'다음 과정 · '+String(next.number).padStart(2,'0'):'전체 과정으로'} →</span><strong>${next?esc(next.title):'다른 과정 둘러보기'}</strong></a></nav>`;}
function lessonPage(id){
 const l=data.lessons.find(l=>l.id===id);if(!l)return notFound();
 const i=data.lessons.indexOf(l),prev=data.lessons[i-1],next=data.lessons[i+1];
 const source=data.sources.find(s=>s.id===l.source);
 return `<div class="page ${id==='worktime-agent'?'worktime-page':''}">${breadcrumbs(['학습 과정',l.group])}<div class="lesson-layout"><article class="article"><header class="article-top"><div class="eyebrow">과정 ${String(l.number).padStart(2,'0')} · ${esc(l.group)}</div><h1>${esc(l.title)}</h1><p class="lead">${esc(l.summary)}</p><div class="article-meta">${badge(l.status)}<span>${esc(l.tag)}</span><span>자료 기준 ${l.asOf}</span></div></header>${lessonTools(l)}<div class="goals"><strong>이 과정에서 할 수 있는 일</strong><ul>${l.goals.map(g=>`<li>${esc(g)}</li>`).join('')}</ul></div>${id==='worktime-agent'?renderKnowledge(data.worktimeKnowledge):''}<div class="prose lesson-body">${l.html}</div>${conversationForLesson(id)}${lessonPager(prev,next)}</article><aside class="toc" aria-label="이 페이지 목차"><div class="toc-title">이 페이지 목차</div><nav>${l.toc.map(t=>`<a class="depth-${t.depth}" href="${lessonLink(id)}?section=${t.id}" data-section="${t.id}">${esc(t.text)}</a>`).join('')}</nav><div class="source-small">근거 프로젝트<a href="#/library/${l.source==='portal'?'':l.source}">${esc(source?.title||'포털 통합·운영')}</a>원본은 저장소 sources/에 보존합니다.</div></aside></div>${footer()}</div>`;
}
const graphModes={
 core:{title:'소스와 업무 지식의 연결',nodes:[
 ['sap',20,50,'SAP ERP','현재 저장소','업무 소스와 개발 객체를 보관합니다. Export로 추출하고 DIAG로 비교합니다.','지원 객체와 실제 업무 데이터 행을 구분합니다.','export','소스 원천'],
 ['export',245,50,'Export','파일화·원본 보존','지원 객체를 추출하고 manifest·catalog·로그·baseline을 함께 만듭니다.','확보 기준 0.3.18 · 최신 SAP 전체 재검증은 별도','export','소스 확보'],
 ['git',470,50,'GitHub','이력·검토·공유','담당 패키지의 소스와 지식을 버전 관리합니다. 원본 기준과 변경 이유를 추적합니다.','소스·지식의 이력과 검토 기록 관리','workspace','사용 보고·설계'],
 ['knowledge',20,225,'업무 지식','규정·협의·매뉴얼','업무 기준과 협의 이유를 출처·시점·상태와 함께 기록합니다. 이미지도 실제 내용과 대조합니다.','텍스트 정리 사용 보고 · 이미지 연계는 보완 설계','knowledge','근거 문서'],
 ['codex',245,225,'업무 에이전트','Codex · 지침 · 스킬','소스와 업무 근거를 필요한 범위에서 읽고, 답변·변경 검토·타 담당 질문을 작성합니다.','ZHR5 구성 사용 보고 · 다른 패키지 운영 상태는 별도 확인','workspace','사용 보고·설계'],
 ['diag',470,225,'DIAG','비교·검사 결과','원본·추출본·SAP의 차이를 제시합니다. 조회·활성 버전 근거·문법 검사를 나누어 해석합니다.','확보 기준 0.4.5 · 읽기 전용 · 자동 Import 제외','diagnosis','소스·결과 확보'],
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
 ['portal',470,400,'교육 포털','정적 파일 제공','교육 내용과 실습 자료를 제공하는 정적 웹사이트입니다.','HTML·CSS·JS + MD · DB 불필요','publishing','이번 구현']
 ],edges:[['telegram','agent',true],['agent','lookup',true],['lookup','erp-api',true],['agent','hub'],['hub','worker'],['worker','expert',true]],note:'실선: 중앙 예제의 통신 경로 · 점선: 추가 구현 경로'}
};
function graphSVG(mode){
 const g=graphModes[mode], byId=Object.fromEntries(g.nodes.map(n=>[n[0],n]));
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
function nodeDetail(mode){const n=graphModes[mode].nodes.find(n=>n[0]===graphSelection)||graphModes[mode].nodes[0];return `<div class="eyebrow">선택한 구성 요소</div>${badge(n[8])}<h2>${esc(n[3])}</h2><p>${esc(n[5])}</p><div class="detail-role">${esc(n[6])}</div><div class="map-detail-actions"><button class="btn primary" data-open-conversation>실제 대화로 배우기 ↓</button><a class="btn" href="${lessonLink(n[7])}">관련 과정 읽기</a></div>${['codex','knowledge','maps','feedback'].includes(n[0])?'<p><a class="text-link" href="#/learn/worktime-agent">근로시간 에이전트의 실제 MD 지도 ↗</a></p>':''}<p class="map-conversation-count">관련 학습 에피소드 ${relatedConversationCount(data.conversations,n[0])}개</p>`;}
function mapPage(mode='core'){
 if(!graphModes[mode])mode='core';
 if(!graphModes[mode].nodes.some(n=>n[0]===graphSelection))graphSelection=mode==='core'?'codex':'hub';
 return `<div class="page">${breadcrumbs(['전체 구성도'])}<div class="eyebrow">전체 구성도</div><h1 class="page-title">ERP AI 전체 구성도</h1><p class="page-description">구성 요소를 선택해 역할과 관련 프로젝트 대화를 살펴보세요.</p><div class="filter-tabs" aria-label="구성도 종류"><button data-map="core" class="${mode==='core'?'active':''}" aria-pressed="${mode==='core'}">기본 작업 구조</button><button data-map="remote" class="${mode==='remote'?'active':''}" aria-pressed="${mode==='remote'}">원격 협업·조회 확장</button></div><div class="map-layout"><div class="diagram-box"><div class="diagram-top"><span>${graphModes[mode].title}</span><span>요소 선택 가능</span></div><div id="graph-host">${graphSVG(mode)}</div></div><aside class="map-detail" id="map-detail" aria-live="polite">${nodeDetail(mode)}</aside></div><div class="map-legend"><span><i class="legend-line"></i>자료·기능의 관계</span><span><i class="legend-line dashed"></i>확장 설계</span></div><div class="note-box">${graphModes[mode].note}</div><div id="conversation-host" class="map-conversation-host">${renderConversation()}</div>${footer()}</div>`;
}
function libraryPage(id){
 const source=data.sources.find(s=>s.id===id);
 const sources=source?[source]:data.sources;
 return `<div class="page">${breadcrumbs(['자료실',...(source?[source.title]:[])])}<div class="eyebrow">원천 자료와 실습</div><h1 class="page-title">${source?esc(source.title):'근거와 실습 자료'}</h1><p class="page-description">${data.sources.length}개 프로젝트의 근거 문서와 실습 자료를 찾아보세요.</p>${source?'<p><a class="text-link" href="#/library">모든 프로젝트 보기</a></p>':''}<div class="section-top"><div><h2>프로젝트별 근거</h2><p>프로젝트 MD ${data.sources.reduce((n,s)=>n+s.mdCount,0)}개 · 학습 대화 ${data.conversations.projects.length}개 프로젝트 <a class="text-link" href="#/conversations">대화 ${data.conversations.totals.messages}개 항목 읽기 ↗</a></p></div></div><div class="resource-grid">${sources.map((s,i)=>`<section class="source-card"><div class="source-head"><span class="source-id">SOURCE ${String(data.sources.indexOf(s)+1).padStart(2,'0')}</span>${badge(s.status)}</div><h3>${esc(s.title)}</h3><p>${esc(s.summary)}</p><p class="caption">${esc(s.version)}</p><ul>${s.findings.map(f=>`<li>${esc(f)}</li>`).join('')}</ul><div class="source-links">${s.lessons.map(id=>`<a href="${lessonLink(id)}">과정 ${String(data.lessons.find(l=>l.id===id).number).padStart(2,'0')}</a>`).join('')}</div><div class="source-path">${esc(s.path)}</div><div class="source-foot"><span>MD ${s.mdCount}개 · 전체 ${s.fileCount}파일</span><a href="#/library/${s.id}">자료 범위</a></div></section>`).join('')}</div><div class="section-top"><div><h2>바로 사용할 실습 자료</h2><p>실제 대화에서 정리한 MD, 합성 데이터와 문서 양식, 별도 모의 통신 예제입니다.</p></div></div><p><a class="btn" href="#/learn/worktime-agent">근로시간 MD 지도·783개 문서 다운로드 ↗</a></p><div class="download-list">${data.downloads.map(d=>`<div class="download-row"><span class="download-type">${esc(d.type)}</span><div><h3>${esc(d.title)}</h3><p>${esc(d.desc)}</p></div><a href="downloads/${d.file}" download aria-label="${esc(d.title)} 다운로드">다운로드</a></div>`).join('')}</div><div class="section-top"><div><h2>실제 화면으로 보완할 부분</h2><p>다음 자료를 확보하면 실습 화면을 더 구체화할 수 있습니다.</p></div></div><div class="supplement-list"><ul><li>Export·DIAG의 선택 화면과 JSON 실출력 (DIAG 0.4.5 요약·상세 캡처는 과정 06에 반영)</li><li>Codex에서 담당 패키지를 연 화면과 실제 지침·스킬 적용 확인</li><li>Obsidian의 비MD 원본·운영 검증 보완 (실제 연결 MD 783개와 탐색 지도는 <a href="#/learn/worktime-agent">과정 11</a>에 반영)</li><li>실제 MCP 워커 또는 Telegram 연결 완료 후의 왕복 기록</li><li>WebGUI 운영 배포본과 개인정보를 제외한 Network·오류 재현 자료</li></ul></div>${footer()}</div>`;
}
const caseTabs=id=>`<nav class="case-tabs" aria-label="실습 선택">${caseItems.map(c=>`<a href="#/cases/${c.id}" class="${id===c.id?'active':''}" ${id===c.id?'aria-current="page"':''}>${esc(c.title)}</a>`).join('')}</nav>`;
function casesPage(id='compare'){
 let body;
 if(id==='webgui')body=`<div class="simulator"><div class="simulator-top"><div><h2>중복 예약과 지연 시간을 구분하기</h2><p>wheelDelay 700ms 기준 교육용 타이머 모형</p></div></div><div class="filter-tabs"><button data-timer="before" class="active" aria-pressed="true">기존 모형</button><button data-timer="after" aria-pressed="false">v3 모형</button></div><div id="timer-display">${timerDisplay(false)}</div><div class="note-box">v3는 700ms를 유지하며 중복 예약을 제거합니다. 실제 POST 횟수와 체감 속도는 운영 환경에서 측정합니다.</div><a class="btn" href="${lessonLink('webgui')}">사례 전체 읽기</a></div>`;
 else if(id==='ess-attendance')body=`<div class="simulator"><h2>신청·승인·반영을 각각 확인하기</h2><p class="page-description">실제 대화 4개에서 근태 신청·결재·데이터 반영 과정을 살펴봅니다.</p><div class="table-wrap"><table><thead><tr><th>관찰한 상태</th><th>확인할 근거</th><th>관련 대화</th></tr></thead><tbody><tr><td>R1 화면이 열림</td><td>기존 화면 보존과 실제 호출 경로</td><td><a href="#/conversations/kbs-erp-ess-attendance/ess-11">분리 개발</a></td></tr><tr><td>상신 이력에 표시됨</td><td>결재 번호와 실제 결재자의 목록</td><td><a href="#/conversations/kbs-erp-ess-attendance/ess-21">저장·결재 연결</a></td></tr><tr><td>반차 승인 후 0.5일 표시</td><td>원래 승인 데이터·변경 신청·잔여 일수</td><td><a href="#/conversations/kbs-erp-ess-attendance/ess-24">반차 결과 확인</a></td></tr><tr><td>최종 PRG 수정안 제공</td><td>적용 후 첫 상신·F5·뒤로 가기 재시험</td><td><a href="#/conversations/kbs-erp-ess-attendance/ess-26">검증 대기</a></td></tr></tbody></table></div><div class="note-box">날짜 이동·반차: 사용자 성공 보고 · 최종 PRG 수정안: SAP 재시험 대기</div><p><a class="btn primary" href="#/learn/ess-attendance">ESS 사례 전체 읽기</a> <a class="btn" href="#/conversations/kbs-erp-ess-attendance">학습흐름대화 읽기</a></p></div>`;
 else if(id==='evidence')body=`<div class="simulator"><h2>2,541행 결과에서 무엇을 말할 수 있나요?</h2><p class="page-description">2026-10-07 업로드 자료의 재집계입니다. 실행 버전은 미확인입니다.</p><section class="case-download-panel" aria-label="실제 DIAG 결과 파일"><a class="btn primary" href="downloads/ZHR5_result_uploaded_20261007.xlsx" download="ZHR5_result_uploaded_20261007.xlsx">${icon('download')}<span>DIAG 결과 엑셀 다운로드</span></a><p class="caption">원본 XLSX · RawData 2,541행 · 업로드 2026-10-07</p></section><div class="table-wrap"><table><thead><tr><th>관찰</th><th>확인된 사실</th><th>추가 근거가 필요한 결론</th></tr></thead><tbody><tr><td>3,210 bytes</td><td>동일 크기지만 SAP 대비 수정</td><td>실제 변경 XML 필드</td></tr><tr><td>71건 확인 실패</td><td>함수 API 70 + DDIC 진단 1</td><td>실제 활성 상태</td></tr><tr><td>10파일 검사 미수행</td><td>SAP 신규, 추출본은 없음</td><td>미수행 원인과 검사 기능 상태</td></tr></tbody></table></div><div class="note-box">파일 비교, 활성 버전, 업무 결과를 각각 확인합니다.</div><p><a class="btn" href="${lessonLink('diagnosis')}">근거와 해석 읽기</a></p></div>`;
 else {id='compare';body=`<div class="simulator"><div class="simulator-top"><div><h2>원본 · 추출본 · SAP</h2><p>값과 존재 상태를 바꾸면 세 비교 결과가 달라집니다.</p></div><label class="select-wrap" for="compare-preset">사례 선택<select id="compare-preset">${data.compareCases.cases.map((c,i)=>`<option value="${i}">${esc(c.name)}</option>`).join('')}</select></label></div><div class="sim-inputs">${[['original','원본','추출 시점'],['extracted','추출본','현재 작업 파일'],['sap','현재 SAP','진단 시점']].map(([key,label,sub],i)=>`<section class="sim-input"><h3><span>${i+1}</span>${label}</h3><p class="caption">${sub}</p><label>존재·확인 상태<select data-state="${key}" aria-label="${label} 존재 상태"><option value="P">본문 확보</option><option value="N">부재 확인</option><option value="U">읽기 미확인</option></select></label><label>내용<textarea data-value="${key}" aria-label="${label} 내용" spellcheck="false">A</textarea></label></section>`).join('')}</div><div id="compare-results" aria-live="polite"></div><div class="note-box">합성 데이터로 익히는 문자열 비교 실습입니다. 실제 SAP 검사는 DIAG에서 수행합니다.</div><a class="text-link" href="${lessonLink('diagnosis')}">실제 DIAG 결과 해석하기</a></div>`;}
 if(id==='webgui')body=`<section class="simulator"><div class="eyebrow">2026.10.17 UPDATE</div><h2>ITS 실제 적용에서 결재 화면 개편까지</h2><p>파일 비교·저장·게시 결과를 확인하고, 결재 본문 렌더러와 RFC 설계로 이어갑니다.</p><div class="table-wrap"><table><thead><tr><th>학습 흐름</th><th>확인한 내용</th></tr></thead><tbody><tr><td><a href="#/conversations/kbs-erp-webgui-refactor/wg-apply-02">112행 실패 분석</a></td><td>공통 호출부 오류와 실제 게시 API 확인</td></tr><tr><td><a href="#/conversations/kbs-erp-webgui-refactor/wg-apply-03">첫 파일 적용</a></td><td>GUI_CUA.JS 변경 확인·저장과 게시 결과 보고</td></tr><tr><td><a href="#/conversations/kbs-erp-webgui-refactor/wg-apply-04">일괄 처리와 107번 오류</a></td><td>충돌 차단·D 불일치·1.0.8~1.0.9 보정</td></tr><tr><td><a href="#/conversations/kbs-erp-webgui-refactor/wg-v3-review">재추출 V3</a></td><td>CSS 9·JS 7·템플릿 3개 교체안</td></tr><tr><td><a href="#/conversations/kbs-erp-webgui-refactor/wg-approval-03">결재 본문·설정 조회</a></td><td>대상 판별·설정 테이블·RFC·POST·JSON 파싱</td></tr></tbody></table></div><p><a class="btn primary" href="#/learn/webgui">최신 사례와 실제 이미지 보기</a> <a class="btn" href="#/conversations/kbs-erp-webgui-refactor/wg-apply-01">추가 대화 전문 읽기</a></p><p class="caption">엑셀 첨부 6개: 이름·분석 대화 확보, 원본 다운로드 미확보</p></section><h2>앞선 사례: 스크롤 타이머 비교</h2>`+body;
 return `<div class="page">${breadcrumbs(['사례 실습'])}<div class="eyebrow">사례로 익히기</div><h1 class="page-title">${esc(caseItems.find(c=>c.id===id).title)}</h1><p class="page-description">비교 상태와 검증 범위를 작은 사례로 확인합니다.</p>${caseTabs(id)}${body}${footer()}</div>`;
}
function timerDisplay(after){return `<div class="timeline"><p class="timeline-note">같은 위치의 콜백 ${after?'1':'2'}회</p><div class="timeline-axis"><div class="event"><b></b>0ms<br>휠 입력</div><div class="event ${after?'empty':''}"><b></b>350ms<br>${after?'중복 예약 제거':'내부 예약 콜백'}</div><div class="event"><b></b>700ms<br>wheelDelay 콜백</div></div></div>`;}
function setPreset(n){const c=data.compareCases.cases[n]||data.compareCases.cases[0];for(const key of ['original','extracted','sap']){$(`[data-state="${key}"]`).value=c[key][0];$(`[data-value="${key}"]`).value=c[key][1]??'';}updateComparison();}
function updateComparison(){
 const values=['original','extracted','sap'].map(key=>{const state=$(`[data-state="${key}"]`).value;const input=$(`[data-value="${key}"]`);input.disabled=state!=='P';return [state,state==='P'?input.value:null];});
 const results=compare(...values);
 let note=results.includes('미확인')?'읽기 미확인(U): 내용을 읽지 못한 상태입니다. 파일 존재 여부를 먼저 확인하세요.':results.includes('누락')?'누락: 기준에는 있고 비교 대상에는 없는 상태입니다. 반영 여부는 담당자가 판단합니다.':results.every(r=>r==='변경없음')?'세 본문이 같습니다. 빈 파일도 존재하는 파일로 비교합니다. 업무 결과는 별도로 검증합니다.':results.includes('판정 없음')?'양쪽 모두 부재인 방향은 판정 없음입니다. 다른 방향의 신규·누락과 구분합니다.':'전체 내용이 다른 방향을 수정으로 표시합니다. 글자 수나 파일 크기가 같아도 내용은 다를 수 있습니다.';
 $('#compare-results').innerHTML=`<div class="sim-results">${results.map((r,i)=>`<div class="sim-result"><span>${['추출본 / 원본','SAP / 원본','추출본 / SAP'][i]}</span><strong>${r}</strong></div>`).join('')}</div><div class="sim-explanation">${note}</div>`;
}
function notFound(){return `<div class="error-state"><h1>페이지를 찾을 수 없습니다.</h1><p>과정 목록에서 원하는 교육을 선택해 주세요.</p><a class="btn primary" href="#/courses">학습 과정 보기</a></div>`;}
function route(){
 countCleanup?.(); countCleanup=undefined;
 heroCleanup?.(); heroCleanup=undefined;
 presentationCleanup?.(); presentationCleanup=undefined;
 knowledgeCleanup?.(); knowledgeCleanup=undefined;
 const hash=location.hash.replace(/^#\/?/,'')||'home';const [p,q]=hash.split('?');const parts=p.split('/');
 const params=new URLSearchParams(q);
 if(parts[0]==='map'){
  const mode=graphModes[parts[1]]?parts[1]:'core';
  if(graphModes[mode].nodes.some(n=>n[0]===params.get('node')))graphSelection=params.get('node');
  if(!graphModes[mode].nodes.some(n=>n[0]===graphSelection))graphSelection=mode==='core'?'codex':'hub';
  conversationState={node:graphSelection,projectId:params.get('project'),episodeId:params.get('episode'),tab:params.get('tab')||'dialogue',visible:4};
 }
 if(parts[0]==='conversations')conversationState={projectId:parts[1],episodeId:parts[2],tab:params.get('tab')||'dialogue',visible:4};
 document.body.classList.toggle('present-mode',parts[0]==='present');
 document.body.classList.toggle('home-mode',parts[0]==='home');
 sidebar(parts);
 let html;
 switch(parts[0]){case 'home':html=home();break;case 'courses':html=courses();break;case 'learn':html=lessonPage(parts[1]);break;case 'map':html=mapPage(parts[1]);break;case 'conversations':html=conversationsPage(parts[1]);break;case 'library':html=libraryPage(parts[1]);break;case 'cases':html=casesPage(parts[1]);break;case 'present':html=renderPresentation(data.slides,parts[1]);break;default:html=notFound();}
 $('#main').innerHTML=html;
 hydratePreviewAssets($('#main'));
 if(parts[0]==='learn'&&parts[1]==='worktime-agent')knowledgeCleanup=mountKnowledge($('[data-knowledge]'),data.worktimeKnowledge,{docId:params.get('doc'),openDocument:params.get('read')==='1',hydrate:hydratePreviewAssets});
 if(parts[0]==='present')presentationCleanup=mountPresentation($('[data-presentation]'));
 if(parts[0]==='home')heroCleanup=mountHeroMotion($('.hero'));
 document.title=(parts[0]==='learn'?(data.lessons.find(l=>l.id===parts[1])?.title||'교육')+' | ':'')+data.title;
 if($('#compare-preset'))setPreset(0);
 closeMenu();
 if(lastRoute!==p){window.scrollTo({top:0,behavior:'instant'});if(lastRoute)$('#main').focus({preventScroll:true});}
 lastRoute=p;
 if(parts[0]==='learn'&&parts[1]==='worktime-agent'&&params.get('doc')&&params.get('read')==='1')document.getElementById('km-selected')?.scrollIntoView({block:'start',behavior:'instant'});
 countCleanup=mountCountUps($('#main'));
 if(q){const section=new URLSearchParams(q).get('section');if(/^section-\d+$/.test(section))document.getElementById(section)?.scrollIntoView();}
}
function closeMenu(){$('#sidebar').classList.remove('open');$('#menu-scrim').hidden=true;$('#menu-toggle').setAttribute('aria-expanded','false');document.body.classList.remove('no-scroll');}
function openSearch(){lastFocused=document.activeElement;$('#search-dialog').showModal();$('#search-input').value='';search('');$('#search-input').focus();}
function search(query){const terms=query.trim().toLocaleLowerCase().split(/\s+/).filter(Boolean);if(!terms.length){$('#search-results').innerHTML='<div class="empty-state">교육 본문, 실제 대화·에피소드, 근로시간 MD 제목·경로·요약에서 검색합니다.<br>baseline, 원격 자문, 파일 시각 등을 입력해 보세요.</div>';return;}
 const entries=[...data.lessons.map(l=>({title:l.title,group:`과정 ${String(l.number).padStart(2,'0')} · ${l.group}`,url:lessonLink(l.id),text:l.summary+' '+l.search})),...conversationSearchEntries(data.conversations).map(e=>({...e,group:'대화 · '+e.group})),...data.worktimeKnowledge.documents.map(d=>({title:d.title,group:'근로시간 MD · '+d.path,url:'#/learn/worktime-agent?doc='+d.id,text:d.path+' '+d.summary}))];
 const results=entries.map(l=>({l,hay:(l.title+' '+l.text).toLowerCase()})).filter(({hay})=>terms.every(t=>hay.includes(t))).sort((a,b)=>Number(b.l.title.toLowerCase().includes(terms[0]))-Number(a.l.title.toLowerCase().includes(terms[0])));
 const highlight=s=>{const parts=s.split(new RegExp(`(${terms.map(t=>t.replace(/[.*+?^${}()|[\]\\]/g,'\\$&')).join('|')})`,'gi'));return parts.map(x=>terms.includes(x.toLowerCase())?`<mark>${esc(x)}</mark>`:esc(x)).join('');};
 $('#search-results').innerHTML=results.length?results.map(({l})=>{const text=l.text.replace(/\s+/g,' '),idx=text.toLowerCase().indexOf(terms[0]);const start=Math.max(0,idx-40);return `<a class="search-result" href="${l.url}"><small>${esc(l.group)}</small><h3>${highlight(l.title)}</h3><p>${start?'… ':''}${highlight(text.slice(start,start+150))} …</p></a>`;}).join(''):'<div class="empty-state">일치하는 교육 내용을 찾지 못했습니다.<br>더 짧은 단어나 다른 용어로 검색해 보세요.</div>';
}
async function copy(text){try{if(navigator.clipboard&&window.isSecureContext)await navigator.clipboard.writeText(text);else{const t=document.createElement('textarea');t.value=text;t.style.position='fixed';t.style.opacity='0';document.body.append(t);t.select();const ok=document.execCommand('copy');t.remove();if(!ok)throw Error('copy');}notify('복사했습니다.');}catch{notify('자동 복사를 사용할 수 없습니다. 내용을 선택해 복사해 주세요.');}}
document.addEventListener('click',e=>{
 const target=e.target.closest('a,button,[data-node]');if(!target)return;
 if(target.matches('.skip')){e.preventDefault();$('#main').focus();$('#main').scrollIntoView();return;}
 if(target.matches('[data-close-dialog]')){target.closest('dialog').close();return;}
 if(target.matches('.search-result'))$('#search-dialog').close();
 if(target.matches('[data-filter]')){currentFilter=target.dataset.filter;route();}
 if(target.matches('[data-section]')){e.preventDefault();document.getElementById(target.dataset.section)?.scrollIntoView({behavior:'smooth'});}
 if(target.matches('[data-print]'))window.print();
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
 if(target.matches('[data-map]')){graphSelection=target.dataset.map==='core'?'codex':'hub';location.hash=`#/map/${target.dataset.map}`;}
 if(target.matches('[data-node]')){graphSelection=target.dataset.node;const mode=location.hash.includes('/remote')?'remote':'core';document.querySelectorAll('.graph-node').forEach(n=>{n.classList.toggle('selected',n.dataset.node===graphSelection);n.setAttribute('aria-pressed',n.dataset.node===graphSelection);});$('#map-detail').innerHTML=nodeDetail(mode);conversationState={node:graphSelection,tab:'dialogue',visible:4};updateConversation();}
 if(target.matches('[data-slide]'))location.hash=`#/present/${target.dataset.slide}`;
 if(target.matches('[data-timer]')){document.querySelectorAll('[data-timer]').forEach(b=>{b.classList.toggle('active',b===target);b.setAttribute('aria-pressed',b===target);});$('#timer-display').innerHTML=timerDisplay(target.dataset.timer==='after');}
});
document.addEventListener('input',e=>{if(e.target.id==='search-input')search(e.target.value);if(e.target.matches('[data-value]'))updateComparison();});
document.addEventListener('change',e=>{if(e.target.id==='compare-preset')setPreset(Number(e.target.value));if(e.target.matches('[data-state]'))updateComparison();if(e.target.matches('[data-conversation-select]')){conversationState.projectId=e.target.value;conversationState.episodeId=null;conversationState.visible=4;conversationState.tab='dialogue';updateConversation('conversation-project-select');}});
document.addEventListener('keydown',e=>{
 const typing=/INPUT|TEXTAREA|SELECT/.test(e.target.tagName);
 if(e.target.matches('[data-node]')&&(e.key==='Enter'||e.key===' ')){e.preventDefault();e.target.dispatchEvent(new MouseEvent('click',{bubbles:true}));}
 if(!typing&&e.key==='/'&&!e.ctrlKey&&!e.metaKey&&!document.querySelector('dialog[open]')){e.preventDefault();openSearch();}
 if(e.key==='Escape'){closeMenu();if(location.hash.startsWith('#/present/')&&!document.querySelector('dialog[open]'))location.hash='#/home';}
 if(!typing&&location.hash.startsWith('#/present/')&&!document.querySelector('dialog[open]')){const n=Number(location.hash.split('/')[2])||0;if(e.key==='ArrowRight'&&n<data.slides.length-1){e.preventDefault();location.hash=`#/present/${n+1}`;}if(e.key==='ArrowLeft'&&n>0){e.preventDefault();location.hash=`#/present/${n-1}`;}}
});
$('#menu-toggle').addEventListener('click',()=>{const open=!$('#sidebar').classList.contains('open');$('#sidebar').classList.toggle('open',open);$('#menu-scrim').hidden=!open;$('#menu-toggle').setAttribute('aria-expanded',open);document.body.classList.toggle('no-scroll',open);});
$('#menu-scrim').addEventListener('click',closeMenu);
$('#search-open').addEventListener('click',openSearch);
$('#search-dialog').addEventListener('close',()=>lastFocused?.focus());
for(const d of document.querySelectorAll('dialog'))d.addEventListener('click',e=>{if(e.target===d){const r=d.getBoundingClientRect();if(e.clientX<r.left||e.clientX>r.right||e.clientY<r.top||e.clientY>r.bottom)d.close();}});
try{const r=await fetch('data/portal.json?v=7d479e1ba83b');if(!r.ok)throw Error('자료 응답 오류');data=await r.json();route();window.addEventListener('hashchange',route);}catch(error){$('#main').innerHTML='<div class="error-state"><h1>교육 자료를 불러오지 못했습니다.</h1><p>파일을 직접 열었다면 저장소 폴더에서 <code>npm run build</code> 후 <code>npm start</code>로 실행해 주세요.</p><p>웹서버에서는 dist 폴더 전체가 배포되어 있는지 확인해 주세요.</p><button class="btn primary" id="retry">다시 시도</button></div>';$('#retry').onclick=()=>location.reload();console.error(error);}
