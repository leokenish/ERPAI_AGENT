import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile,access} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import {validateConversation,conversationResolver} from '../scripts/build-conversations.mjs';
import {renderMarkdown} from '../scripts/markdown.mjs';
import {conversationWorkspace,conversationIndex,resolveConversation,conversationVisibleCount,conversationTabs,conversationSearchEntries} from '../site/conversations.js';
const root=new URL('../',import.meta.url);
const portal=JSON.parse(await readFile(new URL('dist/data/portal.json',root),'utf8'));
const bundle=portal.conversations;
const fields=['id','sequence','role','timestamp','content_type','content_markdown','source_locator','redacted'];
test('373개 사용자 문장은 교육용으로 구분하고 AI 전문·첨부 전용 항목을 보존한다',async()=>{
 const edits=JSON.parse(await readFile(new URL('content/conversations/editorial-prompts.json',root),'utf8'));
 let edited=0,empty=0;
 for(const p of bundle.projects)for(const m of p.messages){
  if(m.role==='assistant')continue;
  if(!m.content_markdown.trim()){empty++;assert.equal(m.editorial_markdown,undefined);continue;}
  const edit=edits.projects[p.id][m.id];
  assert.equal(edit.source_sha256,createHash('sha256').update(m.content_markdown).digest('hex'));
  assert.equal(m.editorial_markdown,edit.content_markdown);assert.doesNotMatch(m.editorial_markdown,/주십시오|마십시오/);assert.ok(m.editorialHtml);edited++;
 }
 assert.equal(edited,373);assert.equal(empty,66);
 const html=conversationWorkspace(bundle,{projectId:'erp-obsidian-knowledge-map',episodeId:'obs-e001',visible:999});
 assert.match(html,/>교육용 문장<\/span>/);
 assert.match(html,/회사.*ERP 관련 업무 파일을 구조화/);
 assert.doesNotMatch(html,/message-original|원문 확인|원문 복사|저장해 놓고싶어/);
 assert.match(html,/교육용 문장 복사/);
 const blank=bundle.projects.find(p=>p.id==='kbs-erp-export-diag-agents');
 const episode=blank.episodes.find(e=>e.message_refs.includes('SHARE-077'));
 const emptyHtml=conversationWorkspace(bundle,{projectId:blank.id,episodeId:episode.id,visible:999});
 assert.match(emptyHtml,/첨부 자료만 전달된 항목입니다/);
});
test('7개 프로젝트의 929개 위치를 원문·발췌·요약·본문 없음으로 구분하고 순서를 보존한다',async()=>{
 assert.equal(bundle.projects.length,7);
 assert.deepEqual(bundle.totals,{projects:7,messages:929,episodes:89,verbatim:915,excerpt:0,summary:0,reconstructed:0,unavailable:14});
 for(const p of bundle.projects){
  const source=JSON.parse(await readFile(new URL(p.sourcePath+'conversation-data.json',root),'utf8'));
  const original=validateConversation(source);assert.equal(p.messages.length,original.length);
  p.messages.forEach((m,i)=>fields.forEach(k=>assert.deepEqual(m[k],original[i][k],`${p.id}/${m.id}/${k}`)));
  const assigned=new Set(p.episodes.flatMap(e=>e.message_refs));
  for(const m of p.messages)assert.ok(assigned.has(m.id),`unreachable message ${p.id}/${m.id}`);
 }
});
test('구성도의 모든 요소에서 유효한 관련 프로젝트·에피소드를 선택한다',()=>{
 for(const [node,[pid,eid]] of Object.entries(bundle.preferredNodes)){
  const s=resolveConversation(bundle,{node});assert.equal(s.project.id,pid);assert.equal(s.episode.id,eid);
  for(const p of s.availableProjects)assert.ok(p.episodes.some(e=>e.map_nodes.includes(node)));
  const stale=resolveConversation(bundle,{node,projectId:'no-such-project',episodeId:'no-such-episode'});
  assert.ok(stale.episode.map_nodes.includes(node));
 }
 assert.equal(resolveConversation(bundle,{node:'no-such-node'}),null);
});
test('네 공유 프로젝트의 모든 표시 본문과 기존 발화 ID·첨부를 보존한다',async()=>{
 for(const p of bundle.projects.filter(p=>p.publishAttachments&&p.id!=='kbs-erp-ess-attendance')){
  const capture=JSON.parse(await readFile(new URL(`sources/conversations/20261014-shared/${p.id}/converted-conversation.json`,root),'utf8'));
  for(const turn of capture.turns){
   const messages=p.messages.filter(m=>m.shared_turn_index===turn.index);
   assert.ok(messages.length,`${p.id}/${turn.index}: lost turn`);
   assert.equal(messages.map(m=>m.content_markdown).join('\n\n'),turn.content_markdown,`${p.id}/${turn.index}: source changed`);
   for(const m of messages)assert.equal(m.platform_turn_id,turn.turn_id);
  }
  const oldPath=p.id==='kbs-erp-webgui-refactor'?'20261012-supplement':'20261012';
  const previous=JSON.parse(await readFile(new URL(`sources/conversations/${oldPath}/${p.id}/conversation-data.json`,root),'utf8'));
  for(const m of previous.threads.flatMap(t=>t.messages))assert.ok(p.messages.some(x=>x.id===m.id),`lost previous ID ${m.id}`);
  for(const a of p.assets.filter(a=>a.availability==='included')){
   assert.ok(a.publicPath,`missing download ${p.id}/${a.id}`);
   const input=(a.asset_root||p.assetSourcePath)+'/'+a.path;
   assert.deepEqual(await readFile(new URL('dist/'+a.publicPath,root)),await readFile(new URL(input,root)),a.id);
  }
  for(const file of ['AI_RESPONSES_FULL.md','MISSING_RESPONSES.md','CHANGELOG.md']){
   assert.deepEqual(await readFile(new URL('dist/'+p.documents[file],root)),await readFile(new URL(p.sourcePath+file,root)));
  }
 }
 const web=bundle.projects.find(p=>p.id==='kbs-erp-webgui-refactor');
 for(const idx of [25,27,31,33])assert.ok(web.messages.some(m=>m.shared_turn_index===idx&&m.content_type==='verbatim'));
 const mcp=bundle.projects.find(p=>p.id==='kbs-erp-mcp-telegram');
 for(let i=2;i<=28;i+=2)assert.equal(mcp.messages.find(m=>m.id===`M${String(i).padStart(3,'0')}`).content_type,'verbatim');
 assert.equal(mcp.coverage.final_responses,16);
});
test('89개 에피소드의 각 화면에 중복 ID·깨진 자료·과정 링크가 없다',async()=>{
 const projectIds=new Set(bundle.projects.map(p=>p.id)),lessonIds=new Set(portal.lessons.map(l=>l.id));
 const publicLinks=new Set();
 for(const p of bundle.projects)for(const e of p.episodes)for(const [tab] of conversationTabs){
  const html=conversationWorkspace(bundle,{projectId:p.id,episodeId:e.id,tab,visible:999});
  assert.ok(html.includes(e.title.replaceAll('&','&amp;')),`${p.id}/${e.id}/${tab}`);
  const ids=[...html.matchAll(/\sid="([^"]+)"/g)].map(m=>m[1]);assert.equal(ids.length,new Set(ids).size,`${p.id}/${e.id}/${tab}: duplicate IDs`);
  assert.ok(!/<script[\s>]|onerror=|href="(?:javascript:|sandbox:)/i.test(html));
  for(const [,url] of html.matchAll(/(?:href|src|data-image)="([^"]+)"/g)){
   if(/^(assets|downloads)\//.test(url))publicLinks.add(url);
   if(url.startsWith('#/learn/'))assert.ok(lessonIds.has(url.split('/')[2]),url);
   if(url.startsWith('#/conversations/'))assert.ok(projectIds.has(url.split('/')[2]),url);
  }
 }
 for(const url of publicLinks)await access(new URL('dist/'+url,root));
 assert.equal([...publicLinks].filter(p=>p.startsWith('assets/conversations/')).length,new Set(bundle.projects.flatMap(p=>p.assets.filter(a=>a.kind==='image'&&a.publicPath).map(a=>a.publicPath))).size);
 assert.ok(conversationIndex(bundle).includes('원문 전사 915개'));
});
test('미확보 AI 답변과 요약을 원문 응답으로 표시하지 않고 검색으로 찾을 수 있다',()=>{
 const missing=conversationWorkspace(bundle,{projectId:'kbs-erp-export-diag-agents',episodeId:'E12',visible:999});
 assert.ok(missing.includes('이 위치에는 AI 답변 본문이 표시되지 않습니다'));
 assert.equal((missing.match(/class="conversation-missing-response"/g)||[]).length,2);
 assert.ok(!missing.includes('당시 AI 답변 원문은 확보하지 못했습니다'));
 const summary=conversationWorkspace(bundle,{projectId:'kbs-erp-mcp-telegram',episodeId:'E01',visible:999});
 assert.ok(!summary.includes('type-summary'));assert.ok(summary.includes('pip install'));assert.ok(summary.includes('MCPServer'));
 const entries=conversationSearchEntries(bundle);assert.equal(entries.length,89);
 assert.ok(entries.some(e=>e.text.includes('OnDestory')),'preserves the original typo for search and quotation');
});
test('공유 화면의 235개 본문 전체와 3개 빈 응답을 보존하며 모든 요청 뒤에 대응 위치가 연결된다',async()=>{
 const p=bundle.projects.find(p=>p.id==='kbs-erp-export-diag-agents');
 const source=JSON.parse(await readFile(new URL('sources/conversations/20261013-shared/kbs-erp-export-diag-agents/conversation-data.json',root),'utf8'));
 const original=source.threads[0].messages;
 assert.equal(p.messages.length,238);assert.equal(p.episodes.length,22);
 for(let i=0;i<original.length;i++){
  const m=p.messages[i],o=original[i];
  for(const key of ['id','sequence','role','timestamp','content_markdown','platform_message_id','platform_turn_id'])assert.deepEqual(m[key],o[key],`${o.id}/${key}`);
  assert.equal(m.content_type,o.capture_status==='no_response_body_visible'?'unavailable':'verbatim');
  if(m.role==='user'){
   const response=p.messages[i+1];assert.equal(response.role,'assistant');
   assert.equal(response.pair_number,m.pair_number);
   for(const e of p.episodes.filter(e=>e.message_refs.includes(m.id)))assert.ok(e.message_refs.includes(response.id),`${e.id}/${m.id}: unpaired`);
  }
 }
 assert.equal(p.messages.filter(m=>m.role==='assistant'&&m.content_type==='verbatim').length,116);
 assert.deepEqual(p.messages.filter(m=>m.content_type==='unavailable').map(m=>m.pair_number),[13,89,90]);
 for(let i=1;i<=18;i++)assert.ok(p.episodes.some(e=>e.id===`E${String(i).padStart(2,'0')}`),'old episode links survive');
 const html=conversationWorkspace(bundle,{projectId:p.id,episodeId:'E00-start',visible:999});
 assert.ok(html.includes('대화 전문 펼치기'));assert.ok(html.includes('SP 수준'));
 const e01=conversationWorkspace(bundle,{projectId:p.id,episodeId:'E01',visible:999});
 assert.equal((e01.match(/class="chat-message from-assistant/g)||[]).length,4);
 assert.ok(!e01.includes('당시 AI 답변 원문은 확보하지 못했습니다'));
 const download=await readFile(new URL('dist/'+p.documents['AI_RESPONSES_FULL.md'],root));
 const originalMd=await readFile(new URL('sources/conversations/20261013-shared/kbs-erp-export-diag-agents/SAP_Package_Conversation_Full.md',root));
 assert.deepEqual(download,originalMd);
});
test('대화 데이터의 누락 참조를 거부하고 원문 HTML·실행 링크는 표시용으로 처리한다',async()=>{
 const source=JSON.parse(await readFile(new URL(bundle.projects[0].sourcePath+'conversation-data.json',root),'utf8'));
 source.episodes[0].message_refs.push('fabricated-reply');assert.throws(()=>validateConversation(source),/invalid message reference/);
 const resolveURL=conversationResolver([],{ '01_PROJECT_CONTEXT.md':'downloads/conversations/test/context.md' });
 assert.equal(resolveURL('sandbox:/missing.zip'),null);
 assert.equal(resolveURL('javascript:alert(1)'),null);
 const {html}=renderMarkdown('# 원문 제목\n\n<script>alert(1)</script>\n\n[bad](javascript:alert)\n\n[old](sandbox:/missing.zip)\n\n[context](01_PROJECT_CONTEXT.md)',{keepTitle:true,headingPrefix:'test-',resolveURL});
 assert.ok(html.includes('원문 제목'));assert.ok(html.includes('id="test-section-1"'));
 assert.ok(!html.includes('<script>'));assert.ok(!/href="(?:javascript:|sandbox:)/.test(html));
 assert.ok(html.includes('href="downloads/conversations/test/context.md"'));
});

test('AI 경어체 편집은 해시와 확보 수준을 보존하며 요약을 전문으로 표시하지 않는다',async()=>{
 const edits=JSON.parse(await readFile(new URL('content/conversations/editorial-responses.json',root),'utf8'));
 let count=0;
 for(const p of bundle.projects)for(const m of p.messages){
  if(m.role!=='assistant')continue;
  const edit=edits.projects[p.id]?.[m.id];
  if(!edit){assert.equal(m.editorial_markdown,undefined);continue;}
  count++;assert.equal(edit.source_sha256,createHash('sha256').update(m.content_markdown).digest('hex'));
  assert.equal(edit.source_content_type,m.content_type);assert.equal(m.editorial_markdown,edit.content_markdown);
  const code=text=>[...text.matchAll(/```[\s\S]*?```/g)].map(x=>x[0]);assert.deepEqual(code(m.editorial_markdown),code(m.content_markdown));
 }
 assert.equal(count,296); // 294 retained overlays + 2 newly edited responses.
 const project=bundle.projects.find(p=>p.id==='kbs-erp-mcp-telegram');
 const episode=project.episodes.find(e=>e.message_refs.includes('M002'));
 assert.match(conversationWorkspace(bundle,{projectId:project.id,episodeId:episode.id,visible:999}),/원문 전사 · 경어체 편집/);
});

test('M008은 요약 대신 표와 예제를 포함한 전문을 기본으로 펼친다',()=>{
 const p=bundle.projects.find(p=>p.id==='kbs-erp-mcp-telegram'),m=p.messages.find(m=>m.id==='M008');
 const e=p.episodes.find(e=>e.message_refs.includes(m.id));
 const html=conversationWorkspace(bundle,{projectId:p.id,episodeId:e.id,visible:999});
 assert.match(html,/id="message-kbs-erp-mcp-telegram-M008"/);
 assert.ok(html.includes(m.editorialHtml??m.html));
 const long=p.messages.find(m=>m.role==='assistant'&&m.delivery_kind==='final'&&(m.editorial_markdown??m.content_markdown).length>1800);
 const longEpisode=p.episodes.find(e=>e.message_refs.includes(long.id));
 const longHtml=conversationWorkspace(bundle,{projectId:p.id,episodeId:longEpisode.id,visible:999});
 assert.ok(longHtml.includes(`class="transcript-long" open id="long-${p.id}-${long.id}"`));
 assert.match(m.content_markdown,/어떤 API를 사용할지 판단하는 것은 AI/);
 assert.match(m.html,/<table>/);assert.match(m.html,/<pre>/);
 assert.doesNotMatch(html,/대체로 맞지만 API 선택의 판단 주체는 AI/);
});
test('진행 안내는 접고 해당 요청의 최종 전문까지 같은 에피소드에서 보여준다',()=>{
 const selection=resolveConversation(bundle,{projectId:'kakao-work-context',episodeId:'kwc-e02'});
 const html=conversationWorkspace(bundle,{projectId:selection.project.id,episodeId:selection.episode.id});
 assert.equal(selection.messages.at(-1).id,'kwc-m009');
 assert.equal((html.match(/class="conversation-progress"/g)||[]).length,5);
 assert.doesNotMatch(html,/<details class="conversation-progress"[^>]*\bopen/);
 assert.match(html,/id="message-kakao-work-context-kwc-m009"/);
 assert.equal(conversationVisibleCount(selection.messages,4),7);
 const messages=[{role:'user'},{role:'assistant',delivery_kind:'progress'},{role:'assistant',delivery_kind:'final'},{role:'user'},{role:'assistant'}];
 assert.equal(conversationVisibleCount(messages,1),3);assert.equal(conversationVisibleCount(messages,4),5);
});
