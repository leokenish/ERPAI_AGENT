import test from 'node:test';
import assert from 'node:assert/strict';
import vm from 'node:vm';
import {readFile} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import {countNumber} from '../site/count-up.js';
import {conversationIndex} from '../site/conversations.js';
const root=new URL('../',import.meta.url);
const read=p=>readFile(new URL(p,root),'utf8');
const portal=JSON.parse(await read('dist/data/portal.json'));
const app=await read('site/app.js');

test('최신 WEBGUI 20쌍의 본문·코드·순서와 이미지 8개가 원천과 일치한다',async()=>{
 const captured=JSON.parse(await read('sources/conversations/20261017-webgui/transcript.json'));
 assert.equal(captured.turns.length,27);
 const p=portal.conversations.projects.find(p=>p.id==='kbs-erp-webgui-refactor');
 const added=p.messages.filter(m=>m.id.startsWith('webgui-next-'));
 assert.equal(added.length,40);
 const code=s=>[...s.matchAll(/```[\s\S]*?```/g)].map(m=>m[0]);
 for(const t of captured.turns.slice(7))for(const role of ['user','assistant']){
  const m=added.find(m=>m.turn_index===t.index+1&&m.role===role);
  assert.equal(m.content_markdown,t[role]);
  assert.deepEqual(code(m.editorial_markdown),code(t[role]));
  assert.equal(p.episodes.filter(e=>e.message_refs.includes(m.id)).length,1);
 }
 const images=p.assets.filter(a=>a.id.startsWith('webgui-next-image-'));
 assert.equal(images.length,8);
 for(const a of images){
  const b=await readFile(new URL('dist/'+a.publicPath,root));
  assert.equal(createHash('sha256').update(b).digest('hex'),a.sha256);
 }
 const missing=p.assets.filter(a=>a.id.startsWith('webgui-next-file-')&&a.original_filename.endsWith('.xlsx'));
 assert.equal(missing.length,6);assert.ok(missing.every(a=>a.publicPath===null));
});

test('홈에서 13개 과정을 각각 선택하고 두 DIAG 사례의 프로젝트를 식별한다',()=>{
 const start=app.indexOf('function home(){'),end=app.indexOf('function courses(){');
 const context=vm.createContext({data:portal,countNumber,esc:s=>s,lessonLink:id=>'#/learn/'+id,icon:()=>'',badge:()=>'',footer:()=>'',caseItems:[{id:'compare',title:'ERP 코드 형상관리 · 세 방향 비교'},{id:'evidence',title:'ERP 코드 형상관리 · DIAG 결과 읽기'},{id:'webgui'},{id:'ess-attendance'}]});
 vm.runInContext(app.slice(start,end),context);
 const html=vm.runInContext('home()',context);
 const paths=html.match(/<div class="path-list">([\s\S]*?)<\/section><\/div>/)[1];
 assert.equal((paths.match(/class="path-course-number"/g)||[]).length,13);
 for(const l of portal.lessons)assert.match(paths,new RegExp(`href="#/learn/${l.id}"`));
 assert.doesNotMatch(paths,/01[–-]03|04[–-]07|08[–-]12/);
 assert.match(app,/ERP 코드 형상관리 · 세 방향 비교/);assert.match(app,/ERP 코드 형상관리 · DIAG 결과 읽기/);
 const htmlIndex=conversationIndex(portal.conversations);
 assert.match(htmlIndex,/data-count-to="955"/);assert.doesNotMatch(htmlIndex,/data-count-to="969"/);
});

test('실제 DIAG 엑셀 다운로드는 보존된 원본 바이트와 같다',async()=>{
 const name='ZHR5_result_uploaded_20261007.xlsx';
 assert.deepEqual(await readFile(new URL('dist/downloads/'+name,root)),await readFile(new URL('sources/export-diag/attachments/results/'+name,root)));
 assert.match(portal.lessons.find(l=>l.id==='diagnosis').html,new RegExp('downloads/'+name));
});

test('HTML과 전체 모듈 그래프는 같은 버전의 정적 파일을 요청한다',async()=>{
 const html=await read('dist/index.html');const version=html.match(/styles\.css\?v=([a-f0-9]{12})/)[1];
 assert.match(html,new RegExp(`app.js\\?v=${version}`));
 for(const name of ['app.js','conversations.js','knowledge.js']){
  const js=await read('dist/'+name);
  for(const m of js.matchAll(/from ['"]\.\/[\w-]+\.js([^'"]*)['"]/g))assert.equal(m[1],'?v='+version);
 }
});

test('생성된 배포 화면에 프로젝트명·13개 개별 과정·표 앞 엑셀 링크가 함께 표시된다',async()=>{
 const built=await read('dist/app.js');
 const context=vm.createContext({data:portal,countNumber,esc:s=>s,lessonLink:id=>'#/learn/'+id,icon:()=>'',badge:()=>'',footer:()=>'',breadcrumbs:()=>''});
 vm.runInContext(built.slice(built.indexOf('const caseItems='),built.indexOf('const footer=')),context);
 vm.runInContext(built.slice(built.indexOf('function home(){'),built.indexOf('function courses(){')),context);
 vm.runInContext(built.slice(built.indexOf('const caseTabs='),built.indexOf('function timerDisplay(')),context);
 const home=vm.runInContext('home()',context);
 const rows=[...home.matchAll(/<li><a href="#\/learn\/([^"]+)"><span class="path-course-number">(\d{2})\.<\/span><span>([^<]+)<\/span><\/a><\/li>/g)];
 assert.equal(rows.length,13);
 assert.deepEqual(rows.map(m=>[m[1],m[2],m[3]]),portal.lessons.map(l=>[l.id,String(l.number).padStart(2,'0'),l.title]));
 assert.doesNotMatch(home,/01[–-]03|04[–-]07|08[–-]12/);
 for(const id of ['compare','evidence']){
  const html=vm.runInContext(`casesPage('${id}')`,context);
  assert.match(html,/<h1 class="page-title">ERP 코드 형상관리 · /);
  assert.match(home,new RegExp(`href="#/cases/${id}"[\\s\\S]*?<h3>ERP 코드 형상관리 · `));
  if(id==='evidence'){
   const download=html.indexOf('href="downloads/ZHR5_result_uploaded_20261007.xlsx"');
   assert.ok(download>0&&download<html.indexOf('<table>'));
   assert.match(html,/download="ZHR5_result_uploaded_20261007.xlsx">[\s\S]*?DIAG 결과 엑셀 다운로드/);
  }
 }
});

test('Pages 진입점은 동일 빌드로 연결하고 과정 직접 주소를 유지한다',async()=>{
 const entry=await read('index.html');
 const html=await read('dist/index.html');
 const version=html.match(/styles\.css\?v=([a-f0-9]{12})/)[1];
 assert.match(html,new RegExp(`name="erp-portal-version" content="${portal.version}"`));
 for(const protocol of ['https:','file:']){
  const location={protocol,href:protocol==='file:'?'file:///C:/ERP_EDU/index.html':'https://example.com/KBS_ERPEDU/',search:'?view=lesson',hash:'#/cases/evidence',replace:href=>{location.redirect=href;}};
  vm.runInNewContext(entry.match(/<script>([\s\S]*?)<\/script>/)[1],{URL,location});
  const target=new URL(location.redirect);
  assert.equal(target.hash,'#/cases/evidence');
  assert.equal(target.searchParams.get('view'),'lesson');
  assert.equal(target.searchParams.get('v'),`${portal.version}-${version}`);
  assert.ok(target.pathname.endsWith(protocol==='file:'?'/preview.html':'/dist/'));
 }
});
