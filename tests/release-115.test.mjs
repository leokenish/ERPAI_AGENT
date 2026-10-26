import test from 'node:test';import assert from 'node:assert/strict';import {readFile,access} from 'node:fs/promises';import {createHash} from 'node:crypto';import {inflateRawSync} from 'node:zlib';
const root=new URL('../',import.meta.url),read=p=>readFile(new URL(p,root));const data=JSON.parse(await read('dist/data/portal.json'));
test('핵심 MD 5종의 용도·원본 해시·ZIP 파일이 일치한다',async()=>{
 assert.deepEqual(data.coreDocuments.map(g=>g.mdCount),[12,19,35,33,32]);
 for(const g of data.coreDocuments){const expected=new Map();for(const d of g.mdDocuments){assert.ok(d.project&&d.purpose.length>30);const bytes=await read('dist/'+d.download);assert.equal(createHash('sha256').update(bytes).digest('hex'),d.sha256);expected.set(d.sourceId+'/'+d.path,bytes);}
 const z=await read('dist/'+g.mdArchive);let o=0;while(z.readUInt32LE(o)===0x04034b50){const len=z.readUInt32LE(o+18),n=z.readUInt16LE(o+26),extra=z.readUInt16LE(o+28),name=z.subarray(o+30,o+30+n).toString(),start=o+30+n+extra;assert.deepEqual(inflateRawSync(z.subarray(start,start+len)),expected.get(name));expected.delete(name);o=start+len;}assert.equal(expected.size,0);
 }
});
test('활용 사례 6개는 네 관점·원본 MD를 제공하고 갤러리의 실제 이미지가 존재한다',async()=>{
 for(const l of data.lessons.filter(l=>l.number>=11)){assert.deepEqual(l.projectBrief.map(x=>x.key),['insight','intent','spec','plan']);assert.doesNotMatch(l.html,/#\/conversations/);for(const b of l.projectBrief)assert.ok(b.text.length>40);if(l.showcase){for(const g of l.showcase.gallery)await access(new URL('dist/'+g.image,root));for(const i of l.showcase.icons)for(const f of i.images)await access(new URL('dist/'+f,root));}}
 for(const id of ['worktime-agent','publishing','ess-attendance'])for(const name of ['intent','spec','plan','insight'])assert.match((await read(`sources/project-progress/${id}/20261026/${name}.md`)).toString(),/정리 초안/);
});
test('발표 기능을 제거하고 소스 빌드 결과만 Pages에 게시한다',async()=>{
 const app=(await read('site/app.js')).toString(),index=(await read('site/index.html')).toString(),wf=(await read('.github/workflows/deploy.yaml')).toString();assert.doesNotMatch(app,/renderPresentation|mountPresentation|data\.slides/);assert.doesNotMatch(index,/발표 모드|#\/present/);assert.match(wf,/npm run build/);assert.match(wf,/path: 'dist'/);assert.match((await read('.gitignore')).toString(),/\/preview-data\//);
});
