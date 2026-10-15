import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import {inflateRawSync} from 'node:zlib';
import {renderKnowledge,renderDocumentDetail,filterDocuments,connections,mountKnowledge,openKnowledgeReader} from '../site/knowledge.js';
import {resolvePath} from '../scripts/build-knowledge.mjs';
const root=new URL('../',import.meta.url);
const data=JSON.parse(await readFile(new URL('dist/data/portal.json',root),'utf8'));
const k=data.worktimeKnowledge;
const byPath=p=>k.documents.find(d=>d.path===p);
test('10→11→12 과정 순서와 기존 publishing 주소를 보존한다',()=>{
 assert.deepEqual(data.lessons.slice(-3).map(l=>[l.number,l.id,l.title]),[[10,'webgui','WEBGUI 개선과 검증'],[11,'worktime-agent','근로시간 AI 에이전트 구축'],[12,'publishing','교육 포털을 함께 갱신하기']]);
 for(const step of k.walkthrough)assert.ok(byPath(step.path),step.path);
});
test('783개 원본 MD와 개별 다운로드의 바이트가 일치하고 ZIP에는 MD만 존재한다',async()=>{
 assert.equal(k.documents.length,783);assert.equal(new Set(k.documents.map(d=>d.id)).size,783);
 assert.equal(k.groups.reduce((n,g)=>n+g.count,0),783);
 for(const d of k.documents){const downloaded=await readFile(new URL('dist/'+d.download,root));const original=await readFile(new URL(k.snapshot+'/'+d.path,root));assert.deepEqual(downloaded,original,d.path);assert.equal(createHash('sha256').update(downloaded).digest('hex'),d.sha256);}
 const zip=await readFile(new URL('dist/'+k.archive,root));const files=new Map();let offset=0;
 while(zip.readUInt32LE(offset)===0x04034b50){const size=zip.readUInt32LE(offset+18),nameSize=zip.readUInt16LE(offset+26),extra=zip.readUInt16LE(offset+28);const name=zip.subarray(offset+30,offset+30+nameSize).toString();const start=offset+30+nameSize+extra;files.set(name,inflateRawSync(zip.subarray(start,start+size)));offset=start+size;}
 assert.equal(files.size,783);for(const d of k.documents){assert.ok(/\.md$/i.test(d.path));assert.equal(createHash('sha256').update(files.get(d.path)).digest('hex'),d.sha256);}
});
test('지도는 실제 MD 링크와 경로 언급을 구분하고 출발 문서의 근거 위치를 제공한다',async()=>{
 const ids=new Set(k.documents.map(d=>d.id));for(const e of k.edges){assert.ok(ids.has(e.from)&&ids.has(e.to));assert.ok(e.line>0);}
 const a=byPath('knowledge/code-map/working-time.md'),b=byPath('knowledge/processes/selective-cumulative-display.md');
 assert.ok(connections(k,a.id).outgoing.some(e=>e.to===b.id));
 const raw=await readFile(new URL(k.snapshot+'/'+a.path,root),'utf8');const edge=connections(k,a.id).outgoing.find(e=>e.to===b.id);assert.match(raw.split('\n')[edge.line-1],/selective-cumulative-display\.md/);
 assert.ok(connections(k,byPath('AGENTS.md').id,{mentions:true}).outgoing.length>connections(k,byPath('AGENTS.md').id).outgoing.length);
 assert.equal(k.summary.explicitLinks,k.edges.filter(e=>e.kind!=='mention').length);
});
test('상대 링크·공백 경로·Wikilink는 해결하되 모호한 같은 이름은 합치지 않는다',()=>{
 const paths=new Set(['maps/INDEX.md','knowledge/INDEX.md','maps/topics/selective.md','maps/한 글.md']);
 assert.equal(resolvePath('maps/INDEX.md','topics/selective.md#section',paths).path,'maps/topics/selective.md');
 assert.equal(resolvePath('maps/INDEX.md','%ED%95%9C%20%EA%B8%80.md',paths).path,'maps/한 글.md');
 assert.equal(resolvePath('README.md','selective',paths).path,'maps/topics/selective.md');
 assert.equal(resolvePath('README.md','INDEX.md',paths).missing,true);
 assert.equal(resolvePath('README.md','https://example.com/file.md',paths).external,true);
});
test('문서 역할·폴더·여러 검색어를 함께 적용하고 빈 결과를 허용한다',()=>{
 const found=filterDocuments(k,{group:'knowledge',folder:'knowledge/processes/',query:'selective cumulative'});assert.equal(found.length,1);assert.equal(found[0].path,'knowledge/processes/selective-cumulative-display.md');
 assert.equal(filterDocuments(k,{query:'존재하지않는검색어-8172'}).length,0);
 const skills=filterDocuments(k,{group:'instructions',query:'SKILL.md'});assert.equal(skills.length,3);
});
test('문서 렌더링은 범위 밖 소스의 경로만 설명하며 문서 내부 HTML을 실행하지 않는다',()=>{
 for(const d of k.documents){assert.ok(!/<script\b|\son\w+=|href="javascript:/i.test(d.html),d.path);}
 const d=byPath('maps/sources/DAILY_WORK_INPUT.md');const html=renderDocumentDetail(k,d.id);assert.match(html,/이번 수집 범위 밖/);assert.match(html,/DAILY_WORK_INPUT\.htm/);assert.ok(!/src="[^\"]*\.htm/.test(html));
 const empty=k.documents.find(d=>d.empty);assert.match(renderDocumentDetail(k,empty.id),/빈 문서/);
 assert.match(renderKnowledge(k),/전체 MD ZIP 받기/);
});
test('탐색 UI는 필터·문서 이동·경로 언급 선택과 이벤트 정리를 처리한다',()=>{
 const nodes=new Map(),events=new Map(),hydrated=[];
 const node=s=>{if(!nodes.has(s))nodes.set(s,{innerHTML:'',value:'',focus(){},scrollIntoView(){}});return nodes.get(s);};
 const host={querySelector:s=>s==='[data-map-atlas]'?null:node(s),addEventListener:(e,f)=>events.set(e,f),removeEventListener:(e,f)=>{if(events.get(e)===f)events.delete(e);}};
 const prev=globalThis.history;globalThis.history={replaceState(a,b,url){this.url=url;}};
 try{
  const cleanup=mountKnowledge(host,k,{hydrate:el=>hydrated.push(el)});
  const id=byPath('harness/feedback/FB-20261008-001.md').id;
  events.get('click')({preventDefault(){},target:{closest(){return {dataset:{kmDoc:id},hasAttribute:a=>a==='data-km-doc'};}}});
  assert.ok(!nodes.has('[data-km-detail]'));assert.ok(!renderKnowledge(k).includes('data-km-detail'));assert.equal(globalThis.history.url,'#/learn/worktime-agent?doc='+id);
  events.get('input')({target:{value:'없는내용-123456789',matches:s=>s==='[data-km-search]'}});assert.match(node('[data-km-results]').innerHTML,/일치하는 문서가 없습니다/);
  events.get('change')({target:{value:'knowledge',matches:s=>s==='[data-km-filter]'}});assert.match(node('[data-km-results]').innerHTML,/일치하는 문서가 없습니다/);
  assert.equal(hydrated.length,0);cleanup();assert.equal(events.size,0);
 }finally{globalThis.history=prev;}
});

test('갱신 명령은 커밋된 MD만 가져오고 기존 원천과 비MD·미커밋 변경을 보존한다',async t=>{
 const {mkdtemp,mkdir,cp,writeFile,rm,readdir}=await import('node:fs/promises');const os=await import('node:os');const path=await import('node:path');const {execFileSync}=await import('node:child_process');
 const tmp=await mkdtemp(path.join(os.tmpdir(),'erp-md-import-'));t.after(()=>rm(tmp,{recursive:true,force:true}));
 const repo=path.join(tmp,'repo'),portal=path.join(tmp,'portal');await mkdir(repo);
 const git=(...args)=>execFileSync('git',['-C',repo,...args],{stdio:'pipe'}).toString().trim();git('init');git('config','user.name','Fixture');git('config','user.email','fixture@example.invalid');
 for(const f of ['maps/INDEX.md','knowledge/INDEX.md','exports/private.abap']){await mkdir(path.dirname(path.join(repo,f)),{recursive:true});await writeFile(path.join(repo,f),'committed '+f);}
 git('add','.');git('commit','-m','fixture');const commit=git('rev-parse','HEAD');await writeFile(path.join(repo,'knowledge/INDEX.md'),'uncommitted change');await writeFile(path.join(repo,'untracked.md'),'not committed');
 for(const dir of ['scripts','content','docs'])await mkdir(path.join(portal,dir),{recursive:true});
 await cp(new URL('scripts/import-worktime-md.mjs',root),path.join(portal,'scripts/import-worktime-md.mjs'));
 await writeFile(path.join(portal,'content/worktime-knowledge.json'),JSON.stringify({snapshot:'old',walkthrough:[]}));
 await writeFile(path.join(portal,'docs/source-files.json'),JSON.stringify([{path:'old/raw.md',sha256:'preserved'}]));
 await writeFile(path.join(portal,'content/catalog.json'),JSON.stringify({sources:[{id:'worktime-agent'}],lessons:[{id:'worktime-agent'}]}));
 execFileSync(process.execPath,[path.join(portal,'scripts/import-worktime-md.mjs'),repo],{stdio:'pipe'});
 const snapPath=path.join(portal,'sources/github-erp-ai',commit.slice(0,12));const snap=JSON.parse(await readFile(path.join(snapPath,'snapshot.json'),'utf8'));assert.equal(snap.files.length,2);assert.equal(snap.commit,commit);
 assert.equal(await readFile(path.join(snapPath,'knowledge/INDEX.md'),'utf8'),'committed knowledge/INDEX.md');assert.equal(await readFile(path.join(repo,'knowledge/INDEX.md'),'utf8'),'uncommitted change');
 const register=JSON.parse(await readFile(path.join(portal,'docs/source-files.json'),'utf8'));assert.deepEqual(register[0],{path:'old/raw.md',sha256:'preserved'});
 assert.throws(()=>execFileSync(process.execPath,[path.join(portal,'scripts/import-worktime-md.mjs'),repo],{stdio:'pipe'}),/Snapshot already exists/);
});

test('본문은 별도 창에서 열리고 연결 문서 이동과 다운로드를 유지한다',()=>{
 const handlers=new Map();const body={innerHTML:''},head={appendChild(){}};
 const page={body,head,documentElement:{setAttribute(){}},createElement(){return {};},querySelector(){return {focus(){},textContent:''};},addEventListener:(type,fn)=>handlers.set(type,fn)};
 const reader={document:page,focus(){},scrollTo(){},close(){this.closed=true;}};
 const calls=[],hydrated=[];
 const source={baseURI:'https://example.test/index.html',documentElement:{getAttribute(){return 'dark';}},querySelectorAll(){return [];},defaultView:{open(...args){calls.push(args);return reader;},focus(){}}};
 const first=byPath('maps/topics/selective.md'),second=byPath('harness/feedback/FB-20261008-001.md');
 assert.equal(openKnowledgeReader(k,first.id,{ownerDocument:source,hydrate:el=>hydrated.push(el)}),reader);
 assert.equal(calls[0][1],'_blank');assert.match(body.innerHTML,/selective\.md/);assert.match(body.innerHTML,/download="selective.md"/);assert.match(body.innerHTML,/class="km-content" open/);
 handlers.get('click')({preventDefault(){},target:{closest(){return {dataset:{kmDoc:second.id},hasAttribute:a=>a==='data-km-doc'};}}});
 assert.match(body.innerHTML,/FB-20261008-001\.md/);assert.equal(hydrated.length,2);
 source.defaultView.open=()=>null;assert.equal(openKnowledgeReader(k,first.id,{ownerDocument:source}),null);
});
