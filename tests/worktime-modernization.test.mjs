import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import vm from 'node:vm';
import {rateCheck,retroTotal,deleteDecision} from '../site/worktime-labs.js';
import {characterFor} from '../site/dialogue-characters.js';
import {conversationWorkspace,readingProjects} from '../site/conversations.js';
const root=new URL('../',import.meta.url),read=p=>readFile(new URL(p,root));
const portal=JSON.parse(await read('dist/data/portal.json'));
const projects=portal.conversations.projects.filter(p=>p.id.startsWith('worktime-'));
const hash=s=>createHash('sha256').update(s).digest('hex');
const fences=s=>[...s.matchAll(/```[\s\S]*?```/g)].map(m=>m[0]);

test('17과정은 일곱 사례·보고서·시각자료와 자료실을 연결한다',async()=>{
 const l=portal.lessons.find(l=>l.number===17);
 assert.match((await read('dist/styles.css')).toString(),/\.worktime-lab\{/);
 assert.equal(l.title,'근로시간 시스템 고도화');
 assert.equal((l.html.match(/data-worktime-lab=/g)||[]).length,7);
 for(const key of ['huhu','rate','compare','retro','retired','cancel','halfday']){
  assert.ok(l.html.includes(`assets/worktime-modernization/${key}/report.html`));
  const html=(await read(`dist/assets/worktime-modernization/${key}/report.html`)).toString();
  assert.doesNotMatch(html,/\son(?:click|change|input)=/i);
  assert.match(html,/report.css/);assert.match(html,/report.js/);
  new vm.Script((await read(`dist/assets/worktime-modernization/${key}/report.js`)).toString());
 }
 const source=portal.sources.find(s=>s.id==='worktime-modernization');
 assert.equal(source.mdCount,38);assert.deepEqual(l.projectBrief.map(x=>x.key),['insight','intent','spec','plan']);
});

test('일곱 압축의 원천 424파일은 입력 SHA256와 동일하다',async()=>{
 const manifest=JSON.parse(await read('docs/case17-source-manifest.json'));
 assert.equal(manifest.length,424);
 for(const entry of manifest){const bytes=await read(entry.path);assert.equal(bytes.length,entry.bytes);assert.equal(hash(bytes),entry.sha256,entry.path);}
});

test('293발화·20에피소드는 5명의 고정 대역과 코드 전문을 유지한다',async()=>{
 assert.equal(projects.length,7);assert.equal(projects.reduce((n,p)=>n+p.messages.length,0),293);
 assert.equal(projects.reduce((n,p)=>n+p.episodes.length,0),20);
 const casts={na:0,woo:0,lee:0,oh:0,chae:0};
 const prompts=JSON.parse(await read('content/conversations/editorial-prompts.json'));
 for(const p of projects){
  const actor=characterFor(p.id);casts[actor]++;
  const shown=readingProjects(portal.conversations).find(x=>x.id===p.id);
  for(const e of shown.episodes){const html=conversationWorkspace(portal.conversations,{projectId:p.id,episodeId:e.id,visible:999});
   const humans=[...html.matchAll(/data-character="(?!ai")([^"]+)"/g)].map(x=>x[1]);assert.ok(humans.every(x=>x===actor));assert.match(html,/chatgpt-logo.svg/);
  }
  for(const m of p.messages){
   if(m.editorial_markdown&&m.role==='assistant')assert.deepEqual(fences(m.editorial_markdown),fences(m.content_markdown),m.id);
   if(m.role==='user'&&m.content_markdown.trim())assert.equal(prompts.projects[p.id][m.id].source_sha256,hash(m.content_markdown));
  }
 }
 assert.deepEqual(casts,{na:2,woo:1,lee:2,oh:1,chae:1});
 const h=readingProjects(portal.conversations).find(p=>p.id==='worktime-huhu');assert.ok(h.messages.some(m=>m.id==='huhu-m064'));
 const half=readingProjects(portal.conversations).find(p=>p.id==='worktime-halfday');assert.ok(!half.messages.some(m=>/<INSTRUCTIONS>|external_codex_apps_open_page/.test(m.content_markdown)));
});

test('단가 선별은 공배수·역월·E8 예외를 구분한다',()=>{
 assert.equal(rateCheck(33600).estimate,36960);
 assert.match(rateCheck(23100).status,/판별 불가/);assert.equal(rateCheck(23100).estimate,null);
 assert.equal(rateCheck(36960,'regular','08').estimate,33600);
 assert.equal(rateCheck(5400,'e8','09').oldRate,rateCheck(5400,'e8','09').newRate);
 assert.match(rateCheck(5400,'e8').status,/유지/);
 assert.equal(rateCheck(2700,'special').estimate,4620);
});

test('소급은 증가·감소를 상계하고 두 삭제 업무는 반대 시점 조건을 사용한다',()=>{
 assert.equal(retroTotal([{fixed:100000,now:120000},{fixed:200000,now:190000}]),10000);
 for(const closed of [false,true])for(const settled of [false,true])for(const voucher of [false,true]){
  assert.equal(deleteDecision('cancel',closed,settled,voucher).includes('충족'),!closed&&!settled);
  assert.equal(deleteDecision('retired',closed,settled,voucher).includes('충족'),closed&&settled&&!voucher);
 }
});

test('정산 비교 보고서의 원본·패치 다운로드는 원천 바이트와 일치한다',async()=>{
 const script=(await read('assets/worktime-modernization/compare/report.js')).toString();
 const downloads=JSON.parse(script.match(/^const reportDownloads = (.*);$/m)[1]);
 const changes=JSON.parse(await read('sources/case17-evidence/compare/reports/change-map.json'));
 assert.equal(changes.length,8);
 assert.deepEqual(Object.keys(downloads),changes.map(c=>c.id));
 for(const change of changes){
  const source='sources/case17-evidence/compare/'+change.after_path;
  const patch='sources/case17-evidence/compare/reports/patches/'+change.id+'.patch';
  for(const [kind,path] of [['source',source],['patch',patch]]){
   assert.deepEqual(Buffer.from(downloads[change.id][kind].data,'base64'),await read(path));
   assert.equal(downloads[change.id][kind].name,path.split('/').at(-1));
  }
 }
 assert.doesNotMatch(script,/dl\.href='\.\.\/'|patch\.href='patches\//);
});
