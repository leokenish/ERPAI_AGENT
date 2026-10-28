import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile,access} from 'node:fs/promises';
import {createHash} from 'node:crypto';
const root=new URL('../',import.meta.url);
const portal=JSON.parse(await readFile(new URL('dist/data/portal.json',root),'utf8'));
const config=JSON.parse(await readFile(new URL('content/conversations/catalog.json',root),'utf8'));
const sourceRoot='sources/conversations/20261016-business/';

test('사업용 공유 화면의 261개 요청과 252개 AI 본문을 원문·순서 그대로 보존한다',async()=>{
 let users=0,answers=0,missing=0;
 for(const [pid,keys] of [['kbs-erp-webgui-refactor',['webgui']],['kbs-erp-ess-attendance',['ess1','ess2','ess3','ess4']]]){
  const p=portal.conversations.projects.find(p=>p.id===pid);
  const meta=config.projects.find(p=>p.id===pid);
  const raw=JSON.parse(await readFile(new URL(meta.sourcePath+'/conversation-data.json',root),'utf8'));
  const messages=raw.threads.flatMap(t=>t.messages);
  for(const key of keys){
   const capture=JSON.parse(await readFile(new URL(sourceRoot+pid+'/'+key+'-transcript.json',root),'utf8'));
   const found=messages.filter(m=>m.id.startsWith(key+'-t'));
   assert.deepEqual(found.map(m=>m.id),capture.messages.map(m=>m.id));
   for(const source of capture.messages){
    const m=found.find(m=>m.id===source.id);
    assert.equal(m.content_markdown,source.content_markdown);
    const published=p.messages.find(message=>message.id===m.id);
    const code=text=>[...text.matchAll(/```[\s\S]*?```|~~~[\s\S]*?~~~/g)].map(match=>match[0]);
    assert.deepEqual(code(published.editorial_markdown??published.content_markdown),code(source.content_markdown),`code changed in display: ${m.id}`);
    assert.equal(m.source_platform_message_id,source.source_platform_message_id);
    assert.equal(m.content_type,source.content_type);
    const episodes=p.episodes.filter(e=>e.message_refs.includes(m.id));
    assert.equal(episodes.length,1,`missing or duplicated episode assignment: ${m.id}`);
    if(m.role==='user')users++;
    else if(m.content_type==='unavailable'){missing++;assert.equal(m.content_markdown,'');}
    else answers++;
   }
  }
 }
 assert.deepEqual({users,answers,missing},{users:261,answers:252,missing:9});
});

test('추가 첨부의 공개 파일은 원본 해시와 같고 미확보 파일은 링크를 만들지 않는다',async()=>{
 for(const p of portal.conversations.projects)for(const a of p.assets.filter(a=>a.source_thread)){
  if(a.availability==='included'){
   assert.ok(a.publicPath);const bytes=await readFile(new URL('dist/'+a.publicPath,root));
   assert.equal(createHash('sha256').update(bytes).digest('hex'),a.sha256);
   assert.deepEqual(bytes,await readFile(new URL(a.asset_root+'/'+a.path,root)));
  }else assert.equal(a.publicPath,null);
 }
 const ess=portal.conversations.projects.find(p=>p.id==='kbs-erp-ess-attendance');
 assert.ok(ess.assets.some(a=>a.original_filename==='R1_SUBMIT_PRG01_20261015_XA32762.zip'&&a.publicPath));
});

test('새 ESS 과정·사례·대화가 연결되고 기존 WebGUI 버전과 기술적 범위를 유지한다',async()=>{
 const lesson=portal.lessons.find(l=>l.id==='ess-attendance');assert.equal(lesson.number,14);
 assert.match(lesson.html,/SUBMIT_PRG01/);assert.doesNotMatch(lesson.html,/적용 후 사용자 재시험은 대기 상태/);
 const web=portal.lessons.find(l=>l.id==='webgui');assert.match(web.html,/Modern V2/);assert.match(web.html,/ITS/);assert.doesNotMatch(web.html,/ITS 쓰기 도구는 검토 단계/);assert.match(web.html,/Chrome v3/);
 assert.equal(lesson.group,'에이전트 활용사례');assert.ok(portal.conversations.projects.some(p=>p.id==='kbs-erp-ess-attendance'));
 await access(new URL('dist/content/lessons/13-ess-attendance.md',root));
});
