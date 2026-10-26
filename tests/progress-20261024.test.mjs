import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile,stat,readdir} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import {gunzipSync} from 'node:zlib';
import vm from 'node:vm';
import {once} from 'node:events';
import {makeServer} from '../scripts/server.mjs';
import {conversationWorkspace} from '../site/conversations.js';
const root=new URL('../',import.meta.url);
const read=p=>readFile(new URL(p,root),'utf8');
const data=JSON.parse(await read('dist/data/portal.json'));

test('세 자료 분류와 신규 14·15는 기존 번호를 보존하며 연결된다',()=>{
 const map={'export-diag':'에이전트 구축','knowledge-images':'에이전트 구축',obsidian:'에이전트 구축','agent-collaboration':'에이전트 협업 및 조회','erp-remote':'에이전트 협업 및 조회'};
 for(const s of data.sources)assert.equal(s.category,map[s.id]||'에이전트 활용사례');
 for(const [id,number,pid] of [['weekly-timeline',15,'kbs-weekly-work-timeline'],['smart-erp',16,'kbs-smart-erp-main']]){
  assert.equal(data.lessons.find(l=>l.id===id).number,number);
  assert.equal(data.sources.find(s=>s.id===id).projectDocuments.length,4);
  assert.deepEqual(data.conversations.projects.find(p=>p.id===pid).lessonIds,[id]);
 }
});

test('추가 전문 179턴은 원문 순서·표·코드를 보존하며 각 에피소드에서 한 번씩 읽는다',async()=>{
 const normalize=s=>s.replace(/!\[[^\]]*\]\([^)]*\)/g,'[IMAGE]').replace(/\[이미지 원본 미확보: [^\]]*\]/g,'[IMAGE]');
 for(const [name,pid,start] of [['webgui','kbs-erp-webgui-refactor',27],['export-diag','kbs-erp-export-diag-agents',0],['timeline','kbs-weekly-work-timeline',0],['smart-erp','kbs-smart-erp-main',0]]){
  const parsed=JSON.parse(await read(`sources/conversations/20261024-progress/${pid}/transcript.json`));
  const project=data.conversations.projects.find(p=>p.id===pid);
  const added=project.messages.filter(m=>m.id.startsWith(name+'-progress-'));
  assert.equal(added.length,(parsed.turns.length-start)*2);
  for(const m of added){
   assert.equal(project.episodes.filter(e=>e.message_refs.includes(m.id)).length,1,m.id);
   const captured=parsed.messages.find(x=>x.turn===m.turn_index&&x.role===m.role);
   if(m.content_type==='unavailable'){assert.ok(!captured?.text.trim());assert.equal(m.content_markdown,'');continue;}
   assert.equal(normalize(m.content_markdown),normalize(captured.text),m.id);
   for(const code of captured.code_blocks){assert.ok(m.content_markdown.includes(code.text));assert.ok((m.editorial_markdown||m.content_markdown).includes(code.text));}
  }
  for(const a of project.assets.filter(a=>a.asset_root?.startsWith('sources/conversations/20261024-progress/')&&a.availability==='included')){
   const bytes=await readFile(new URL('dist/'+a.publicPath,root));assert.equal(createHash('sha256').update(bytes).digest('hex'),a.sha256,a.id);
  }
 }
});

test('생성 이미지가 있어도 없는 AI 텍스트를 만들어 원문으로 표시하지 않는다',()=>{
 const p=data.conversations.projects.find(p=>p.id==='kbs-smart-erp-main');
 const m=p.messages.find(m=>m.turn_index===11&&m.role==='assistant');
 assert.equal(m.content_type,'unavailable');assert.equal(m.content_markdown,'');
 const episode=p.episodes.find(e=>e.message_refs.includes(m.id));
 const view=conversationWorkspace(data.conversations,{projectId:p.id,episodeId:episode.id,visible:999});
 assert.ok(view.includes('AI 답변 본문 미확보'));assert.ok(view.includes('별도로 확보한 이미지'));assert.ok(!view.includes('공유 대화 undefined'));
});

test('ABAP 및 프리뷰 HTML은 실행 화면이 아니라 첨부 다운로드로 제공한다',async t=>{
 const server=makeServer();server.listen(0,'127.0.0.1');await once(server,'listening');t.after(()=>{server.closeAllConnections();server.close();});
 for(const ext of ['.abap','.html']){
  const a=data.conversations.projects.flatMap(p=>p.assets).find(a=>a.publicPath?.endsWith(ext));assert.ok(a);
  const r=await fetch(`http://127.0.0.1:${server.address().port}/${a.publicPath}`);
  assert.equal(r.status,200);assert.match(r.headers.get('content-disposition'),/^attachment;/);assert.equal(r.headers.get('x-content-type-options'),'nosniff');
 }
});

test('오프라인 미리보기는 모든 압축 조각을 순서대로 복원하고 각 파일은 Git 크기 한도 아래다',async()=>{
 const html=await read('preview.html');const parts=[...html.matchAll(/src="(preview-data\/part-\d+\.js)"/g)].map(m=>m[1]);assert.ok(parts.length>0);
 const scope={erpPreviewParts:[]};
 for(const p of parts){assert.ok((await stat(new URL(p,root))).size<100*1024*1024);vm.runInNewContext(await read(p),scope);}
 assert.equal(scope.erpPreviewParts.length,parts.length);
 const code=gunzipSync(Buffer.concat(scope.erpPreviewParts.map(x=>Buffer.from(x,'base64')))).toString();
 assert.ok(code.includes('globalThis.erpPreviewFiles='));assert.ok(code.includes('kbs-weekly-work-timeline'));assert.ok(code.includes('kbs-smart-erp-main'));
 assert.doesNotMatch(code,/^import .+ from /m);
 assert.ok((await stat(new URL('preview.html',root))).size<100*1024*1024);
 assert.equal((await readdir(new URL('preview-data/',root))).filter(x=>/^part-\d+\.js$/.test(x)).length,parts.length);
});
