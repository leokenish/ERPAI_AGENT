import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile,access} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import {validateConversation,conversationResolver} from '../scripts/build-conversations.mjs';
import {renderMarkdown} from '../scripts/markdown.mjs';
import {conversationWorkspace,conversationIndex,resolveConversation,conversationTabs,conversationSearchEntries} from '../site/conversations.js';
const root=new URL('../',import.meta.url);
const portal=JSON.parse(await readFile(new URL('dist/data/portal.json',root),'utf8'));
const bundle=portal.conversations;
const fields=['id','sequence','role','timestamp','content_type','content_markdown','source_locator','redacted'];
test('174개 사용자 문장은 교육용으로 구분하고 AI 전문·첨부 전용 항목을 보존한다',async()=>{
 const edits=JSON.parse(await readFile(new URL('content/conversations/editorial-prompts.json',root),'utf8'));
 let edited=0,empty=0;
 for(const p of bundle.projects)for(const m of p.messages){
  if(m.role==='assistant'){assert.equal(m.editorial_markdown,undefined);assert.equal(m.editorialHtml,undefined);continue;}
  if(!m.content_markdown.trim()){empty++;assert.equal(m.editorial_markdown,undefined);continue;}
  const edit=edits.projects[p.id][m.id];
  assert.equal(edit.source_sha256,createHash('sha256').update(m.content_markdown).digest('hex'));
  assert.equal(m.editorial_markdown,edit.content_markdown);assert.doesNotMatch(m.editorial_markdown,/주십시오|마십시오/);assert.ok(m.editorialHtml);edited++;
 }
 assert.equal(edited,174);assert.equal(empty,0);
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
test('6개 프로젝트의 386개 위치를 원문·발췌·요약·본문 없음으로 구분하고 순서를 보존한다',async()=>{
 assert.equal(bundle.projects.length,6);
 assert.deepEqual(bundle.totals,{projects:6,messages:386,episodes:58,verbatim:363,excerpt:7,summary:13,reconstructed:0,unavailable:3});
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
test('WebGUI의 보완본과 미확보 상태는 그대로 유지한다',async()=>{
 const expected=[['kbs-erp-webgui-refactor','wg-ep08',6]];
 for(const [id,episodeId,count] of expected){
  const project=bundle.projects.find(p=>p.id===id);
  const old=JSON.parse(await readFile(new URL(`sources/conversations/20261012/${id}/conversation-data.json`,root),'utf8'));
  const messages=old.threads.flatMap(t=>t.messages);
  assert.equal(project.messages.length,messages.length+count);
  for(const original of messages){const m=project.messages.find(m=>m.id===original.id);for(const [key,value] of Object.entries(original))assert.deepEqual(m[key],value,`${id}/${m.id}/${key}`);}
  const added=project.messages.filter(m=>!messages.some(o=>o.id===m.id));
  for(const m of added)assert.ok(project.episodes.find(e=>e.id===episodeId).message_refs.includes(m.id));
  for(const file of ['AI_RESPONSES_FULL.md','MISSING_RESPONSES.md','CHANGELOG.md']){
   const published=await readFile(new URL('dist/'+project.documents[file],root));
   const original=await readFile(new URL(project.sourcePath+file,root));assert.deepEqual(published,original);
  }
  assert.match(project.coverageNote,/미확보/);
 }
});
test('58개 에피소드의 각 화면에 중복 ID·깨진 자료·과정 링크가 없다',async()=>{
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
 assert.equal([...publicLinks].filter(p=>p.startsWith('assets/conversations/')).length,23);
 assert.ok(conversationIndex(bundle).includes('원문 전사 363개'));
});
test('미확보 AI 답변과 요약을 원문 응답으로 표시하지 않고 검색으로 찾을 수 있다',()=>{
 const missing=conversationWorkspace(bundle,{projectId:'kbs-erp-export-diag-agents',episodeId:'E12',visible:999});
 assert.ok(missing.includes('이 위치에는 AI 답변 본문이 표시되지 않습니다'));
 assert.equal((missing.match(/class="conversation-missing-response"/g)||[]).length,2);
 assert.ok(!missing.includes('당시 AI 답변 원문은 확보하지 못했습니다'));
 const summary=conversationWorkspace(bundle,{projectId:'kbs-erp-mcp-telegram',episodeId:'E01',visible:999});
 assert.ok(summary.includes('type-summary'));assert.ok(summary.includes('답변 요약'));
 const entries=conversationSearchEntries(bundle);assert.equal(entries.length,58);
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
