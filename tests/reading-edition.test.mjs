import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import {applyReadingEdition} from '../scripts/reading-edition.mjs';
import {readingProjects,conversationWorkspace,conversationSearchEntries,resolveConversation} from '../site/conversations.js';
const root=new URL('../',import.meta.url);
const portal=JSON.parse(await readFile(new URL('dist/data/portal.json',root),'utf8'));
const bundle=portal.conversations;
const edition=JSON.parse(await readFile(new URL('content/conversations/reading-edition.json',root),'utf8'));
const hash=s=>createHash('sha256').update(s).digest('hex');

test('편집 안내 절을 제거해도 기존 목차 주소와 뒤따르는 절의 의미를 보존한다',()=>{
 for(const [id,last,retired,next] of [['knowledge',17,16,17],['ess-attendance',10,2,3],['smart-erp',7,4,5]]){
  const lesson=portal.lessons.find(l=>l.id===id);
  const ids=[...lesson.html.matchAll(/\bid="(section-\d+)"/g)].map(m=>m[1]);
  assert.equal(new Set(ids).size,ids.length,id);
  for(let n=1;n<=last;n++)assert.ok(ids.includes(`section-${n}`),`${id}: section-${n}`);
  assert.ok(!lesson.toc.some(h=>h.id===`section-${retired}`));
  assert.ok(lesson.html.includes(`<span id="section-${retired}" aria-hidden="true"></span><h2 id="section-${next}">`));
  assert.equal(lesson.toc.at(-1).id,`section-${last}`);
  assert.equal(lesson.toc.at(-1).text,'근거 자료 확인');
 }
 const ess=portal.lessons.find(l=>l.id==='ess-attendance');
 const knowledge=portal.lessons.find(l=>l.id==='knowledge');
 assert.equal(knowledge.toc.find(h=>h.id==='section-3').text,'3. 어떻게 정리하기로 했는가');
 assert.equal(knowledge.toc.find(h=>h.id==='section-6').text,'1단계 · 추출 폴더의 핵심 업무 조사');
 assert.equal(knowledge.toc.find(h=>h.id==='section-15').text,'5-3. 개별 조치와 과거 내역 처리 구분');
 assert.equal(ess.toc.find(h=>h.id==='section-4').text,'사례 1. 기존 화면과 R1 분리');
 const smart=portal.lessons.find(l=>l.id==='smart-erp');
 assert.equal(smart.toc.find(h=>h.id==='section-6').text,'프로젝트 문서와 가치 성찰');
});

test('선별판은 원본 해시가 바뀐 제외·응답 편집을 거부한다',()=>{
 const project={id:'sample',messages:[{id:'m1',role:'assistant',content_type:'verbatim',content_markdown:'원래 응답입니다.'}],episodes:[{id:'e1',message_refs:['m1']}]};
 for(const field of ['excludedMessages','responseEdits'])assert.throws(()=>applyReadingEdition(structuredClone(project),{[field]:{m1:{source_sha256:'changed',content_markdown:'편집한 응답입니다.'}}},s=>s),/Stale reading/);
 const p=applyReadingEdition(structuredClone(project),{responseEdits:{m1:{source_sha256:hash(project.messages[0].content_markdown),content_markdown:'편집한 응답입니다.'}}},s=>s);
 assert.equal(p.messages[0].content_markdown,'원래 응답입니다.');assert.equal(p.messages[0].reading_markdown,'편집한 응답입니다.');
});

test('제외한 대화는 학습 화면과 검색에서 사라지고 이전 에피소드 주소는 유효한 흐름으로 연결된다',()=>{
 const visible=readingProjects(bundle),search=conversationSearchEntries(bundle);
 assert.equal(visible.length,9);assert.ok(bundle.readingTotals.messages<bundle.totals.messages-200);
 for(const p of visible){
  const hidden=Object.keys(edition.projects[p.id].excludedMessages);
  assert.ok(p.messages.every(m=>!hidden.includes(m.id)&&!m.readingHidden));
  assert.deepEqual(p.episodes.map(e=>e.order),p.episodes.map((_,i)=>i+1));
  for(const e of p.episodes){
   const html=conversationWorkspace(bundle,{projectId:p.id,episodeId:e.id,visible:999});
   for(const id of hidden)assert.ok(!html.includes(`id="message-${p.id}-${id}"`));
   assert.doesNotMatch(e.title,/(?:하다|한다|했다|만든다|바꾼다|남긴다)$/);
  }
 }
 assert.equal(search.length,bundle.readingTotals.episodes);
 assert.equal(resolveConversation(bundle,{projectId:'kakao-work-context',episodeId:'kwc-e02'}).episode.id,'kwc-e01');
 assert.ok(resolveConversation(bundle,{projectId:'kbs-erp-export-diag-agents',episodeId:'E18'}).messages.length);
});

test('짧아도 의미 있는 오류·판단·결과는 유지하고 반복 관리 대화만 제외한다',()=>{
 const p=readingProjects(bundle).find(p=>p.id==='kbs-erp-export-diag-agents');
 for(const id of ['SHARE-168','SHARE-194','SHARE-196','export-diag-progress-t020-a1'])assert.ok(p.messages.some(m=>m.id===id),id);
 assert.match(p.messages.find(m=>m.id==='SHARE-168').content_markdown,/수정이 0건/);
 assert.ok(!p.episodes.some(e=>e.id==='E18'));
});

test('관계도의 MD 파일은 실제 다운로드로 바로 연결되고 원본 바이트가 일치한다',async()=>{
 for(const id of ['knowledge','maps','feedback']){
  const lesson=portal.lessons.find(l=>l.id===id),tree=lesson.html.match(/<figure class="document-tree"[\s\S]*?<\/figure>/)?.[0];
  assert.ok(tree);assert.doesNotMatch(tree,/document-tree-open|href="#\/library/);
  const links=[...tree.matchAll(/href="(downloads\/source-md\/[^\"]+)"\s+download="([^\"]+)"/g)];
  assert.equal(links.length,{knowledge:9,maps:9,feedback:7}[id]);
  for(const [,url,name] of links){
   const source=portal.sources.find(s=>s.mdDocuments?.some(d=>d.download===url));
   const doc=source.mdDocuments.find(d=>d.download===url);
   assert.equal(name,doc.path.split('/').at(-1));
   assert.deepEqual(await readFile(new URL('dist/'+url,root)),await readFile(new URL(source.path+'/'+doc.path,root)));
  }
 }
 const css=await readFile(new URL('site/refinements.css',root),'utf8');
 assert.match(css,/--reading-emphasis:#087576/);assert.match(css,/document-tree-node>a[\s\S]*?text-decoration:none/);
});

test('과정 제목과 설명은 합니다체·짧은 절 제목을 사용하며 편집 상태 해명을 노출하지 않는다',async()=>{
 for(const l of portal.lessons){
  for(const file of [l.file,l.contextFile].filter(Boolean)){
   const md=(await readFile(new URL('content/'+file,root),'utf8')).replace(/```[\s\S]*?```/g,'');
   assert.doesNotMatch(md,/^##\s+\d+[.]\s+[^\n]*[:：]/m,file);
   assert.doesNotMatch(md,/AGENT\.md.{0,20}아니|미확보|미검증|미구현/,file);
   assert.doesNotMatch(md,/(?:한다|했다|된다|이다|없다|있다|준다|않다)[.]/,file);
  }
 }
});

test('응답 표시 편집은 실행 코드와 원본 내용을 보존한다',()=>{
 const code=s=>[...s.matchAll(/```[^\n]*\n[\s\S]*?```/g)].map(x=>x[0]);
 let count=0;
 for(const p of bundle.projects)for(const [id,e] of Object.entries(edition.projects[p.id].responseEdits)){
  const m=p.messages.find(m=>m.id===id);assert.equal(e.source_sha256,hash(m.content_markdown));
  assert.deepEqual(code(m.reading_markdown),code(m.editorial_markdown??m.content_markdown),id);count++;
 }
 assert.ok(count>=40);
});
