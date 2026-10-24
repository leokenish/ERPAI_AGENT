import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile,mkdtemp,mkdir,writeFile,rm,symlink} from 'node:fs/promises';
import {tmpdir} from 'node:os';
import path from 'node:path';
import {once} from 'node:events';
import {makeServer} from '../scripts/server.mjs';
import {inflateRawSync} from 'node:zlib';
import {renderSourceDocuments,filterSourceDocuments} from '../site/source-library.js';
import {buildSourceDocuments} from '../scripts/build-source-documents.mjs';
const root=new URL('../',import.meta.url);
const portal=JSON.parse(await readFile(new URL('dist/data/portal.json',root),'utf8'));

test('각 프로젝트 MD 목록·개별 파일·전체 ZIP은 해당 원천의 바이트와 일치한다',async()=>{
 let total=0;
 for(const source of portal.sources){
  assert.equal(source.mdCount,source.mdDocuments.length);
  const expected=new Map();
  for(const doc of source.mdDocuments){
   assert.match(doc.path,/\.md$/i);
   assert.ok(!doc.path.split('/').includes('..'));
   const original=await readFile(new URL(source.path+doc.path,root));
   assert.deepEqual(await readFile(new URL('dist/'+doc.download,root)),original);
   expected.set(doc.path,original);total++;
  }
  const zip=await readFile(new URL('dist/'+source.mdArchive,root));let offset=0,count=0;
  while(zip.readUInt32LE(offset)===0x04034b50){
   const size=zip.readUInt32LE(offset+18),nameLength=zip.readUInt16LE(offset+26),extra=zip.readUInt16LE(offset+28);
   const name=zip.subarray(offset+30,offset+30+nameLength).toString('utf8');
   const start=offset+30+nameLength+extra;
   assert.ok(expected.has(name),`${source.id}: unexpected ZIP member ${name}`);
   assert.deepEqual(inflateRawSync(zip.subarray(start,start+size)),expected.get(name));
   expected.delete(name);count++;offset=start+size;
  }
  assert.equal(count,source.mdCount);assert.equal(expected.size,0);
 }
 assert.equal(total,839);
});

test('자료확인 화면은 프로젝트별 링크·원래 파일명을 사용하고 HTML 문자를 이스케이프한다',()=>{
 const html=renderSourceDocuments({id:'sample',title:'<project>',mdArchive:'downloads/sample.zip',mdDocuments:[{path:'folder/<name>.md',name:'<name>.md',download:'downloads/0001.md'}]});
 assert.match(html,/&lt;project&gt;/);assert.match(html,/download="&lt;name&gt;\.md"/);
 assert.doesNotMatch(html,/<project>|<name>/);
 for(const source of portal.sources){
  const view=renderSourceDocuments(source);
  assert.match(view,new RegExp(source.mdArchive.replaceAll('.','\\.')));
  assert.equal((view.match(/data-source-file=/g)||[]).length,source.mdCount);
 }
});

test('파일 검색은 경로·이름의 모든 검색어를 적용하고 빈 결과를 표시한다',()=>{
 const rows=[{dataset:{sourceFile:'folder/skill.md'}},{dataset:{sourceFile:'other/readme.md'}}];
 const result={},empty={};const root={querySelectorAll:()=>rows,querySelector:s=>s==='[data-source-result]'?result:empty};
 filterSourceDocuments(root,'FOLDER skill');assert.deepEqual(rows.map(r=>r.hidden),[false,true]);assert.equal(result.textContent,'1개 파일');
 filterSourceDocuments(root,'missing');assert.ok(rows.every(r=>r.hidden));assert.equal(empty.hidden,false);
 filterSourceDocuments(root,'');assert.ok(rows.every(r=>!r.hidden));assert.equal(result.textContent,'2개 파일');
});

test('MD 게시 빌드는 원천 밖 경로·심볼릭 링크를 거부하고 비MD를 제외한다',async t=>{
 const dir=await mkdtemp(path.join(tmpdir(),'portal-md-'));t.after(()=>rm(dir,{recursive:true,force:true}));
 await mkdir(path.join(dir,'sources/project'),{recursive:true});await mkdir(path.join(dir,'outside'));
 await writeFile(path.join(dir,'sources/project/a.md'),Buffer.from('A\r\n'));
 await writeFile(path.join(dir,'sources/project/secret.txt'),'excluded');
 const sources=[{id:'project',path:'sources/project/'}];
 await buildSourceDocuments(dir,path.join(dir,'out'),sources);assert.equal(sources[0].mdCount,1);
 assert.deepEqual(await readFile(path.join(dir,'out',sources[0].mdDocuments[0].download)),Buffer.from('A\r\n'));
 await assert.rejects(buildSourceDocuments(dir,path.join(dir,'out'),[{id:'bad',path:'sources/../outside'}]),/escapes/);
 await symlink(path.join(dir,'outside'),path.join(dir,'sources/project/link'));
 await assert.rejects(buildSourceDocuments(dir,path.join(dir,'out'),sources),/symlink/);
});


test('MD와 ZIP HTTP 응답은 원천 바이트를 제공하고 MD 저장명을 덮어쓰지 않는다',async t=>{
 const server=makeServer();server.listen(0,'127.0.0.1');await once(server,'listening');
 t.after(()=>{server.closeAllConnections();server.close();});
 const base=`http://127.0.0.1:${server.address().port}/`;
 const source=portal.sources.find(s=>s.id==='knowledge-images'),doc=source.mdDocuments[1];
 const response=await fetch(base+doc.download);
 assert.equal(response.status,200);assert.equal(response.headers.get('content-disposition'),'attachment');
 assert.deepEqual(Buffer.from(await response.arrayBuffer()),await readFile(new URL(source.path+doc.path,root)));
 assert.ok(renderSourceDocuments(source).includes(`download="${doc.name}"`));
 const zip=await fetch(base+source.mdArchive);assert.equal(zip.status,200);
 assert.match(zip.headers.get('content-disposition'),/attachment; filename="knowledge-images_MD.zip"/);
 assert.deepEqual(Buffer.from(await zip.arrayBuffer()),await readFile(new URL('dist/'+source.mdArchive,root)));
});
