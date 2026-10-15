import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile,readdir} from 'node:fs/promises';
import {once} from 'node:events';
import http from 'node:http';
import {createHash} from 'node:crypto';
import {makeServer} from '../scripts/server.mjs';
import {compare} from '../site/compare.js';
import {renderMarkdown} from '../scripts/markdown.mjs';
const root=new URL('../',import.meta.url);
test('원천 자료와 보존 사본의 해시가 일치한다',async()=>{const files=JSON.parse(await readFile(new URL('docs/source-files.json',root),'utf8'));for(const f of files){const bytes=await readFile(new URL(f.path,root));assert.equal(createHash('sha256').update(bytes).digest('hex'),f.sha256,f.path);}});
test('10개 합성 비교 사례에서 부재·읽기 실패·빈 본문을 구분한다',async()=>{const {cases}=JSON.parse(await readFile(new URL('examples/three_way_cases.json',root),'utf8'));for(const c of cases)assert.deepEqual(compare(c.original,c.extracted,c.sap),c.expected,c.name);});
test('Markdown 원문 HTML과 실행 URL이 실행 가능한 HTML로 변환되지 않는다',()=>{const {html}=renderMarkdown('# 제목\n<script>alert(1)</script>\n\n[bad](javascript:alert)\n\n[ok](#/learn/export)\n');assert.ok(!html.includes('<script>'));assert.ok(!html.includes('href="javascript:'));assert.ok(html.includes('href="#/learn/export"'));});
test('배포물에 원본·설정·실행기·비밀 파일이 포함되지 않는다',async()=>{const build=JSON.parse(await readFile(new URL('dist/data/build.json',root),'utf8'));const catalog=JSON.parse(await readFile(new URL('content/catalog.json',root),'utf8'));assert.equal(build.lessons,catalog.lessons.length);for(const f of build.files)assert.ok(!/^(sources|scripts|vendor|tests|docs)\/|(^|\/)\.env|\.sqlite/.test(f),f);assert.ok(build.files.includes('data/portal.json'));});
test('모든 교육 링크·이미지·다운로드가 배포물에 있다',async()=>{const data=JSON.parse(await readFile(new URL('dist/data/portal.json',root),'utf8'));const ids=new Set(data.lessons.map(x=>x.id));for(const l of data.lessons){for(const m of l.html.matchAll(/(?:href|src)="([^"]+)"/g)){const u=m[1];if(u.startsWith('#/learn/'))assert.ok(ids.has(u.split('/')[2]),u);if(/^(assets|downloads)\//.test(u))await readFile(new URL('dist/'+u,root));}}for(const d of data.downloads)await readFile(new URL('dist/downloads/'+d.file,root));});
test('웹서버는 dist만 제공하고 경로 탈출·원본 조회·POST를 거부한다',async t=>{
 const server=makeServer();server.listen(0,'127.0.0.1');await once(server,'listening');t.after(()=>{server.closeAllConnections();server.close();});const port=server.address().port;
 async function req(path,method='GET'){return new Promise((resolve,reject)=>{const r=http.request({host:'127.0.0.1',port,path,method},res=>{const chunks=[];res.on('data',x=>chunks.push(x));res.on('end',()=>resolve({status:res.statusCode,headers:res.headers,body:Buffer.concat(chunks).toString()}));});r.on('error',reject);r.end();});}
 const home=await req('/');assert.equal(home.status,200);assert.ok(home.body.includes('ERP AI'));assert.match(home.headers['content-security-policy'],/script-src 'self'/);
 assert.equal((await req('/data/portal.json')).status,200);assert.equal((await req('/assets/favicon.svg')).status,200);
 for(const url of ['/sources/inventory.json','/.git/config','/scripts/server.mjs','/%2e%2e/package.json','/%252e%252e/package.json','/package.json'])assert.ok([403,404].includes((await req(url)).status),url);
 assert.equal((await req('/bad%zz')).status,400);assert.equal((await req('/','POST')).status,405);assert.equal((await req('/missing.png')).status,404);assert.equal((await req('/','HEAD')).body,'');
});
