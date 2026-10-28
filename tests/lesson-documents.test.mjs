import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile,mkdtemp,mkdir,writeFile,rm} from 'node:fs/promises';
import {tmpdir} from 'node:os';
import path from 'node:path';
import {loadLessonTrees} from '../scripts/lesson-trees.mjs';
import {renderMarkdown} from '../scripts/markdown.mjs';
import {filterSourceDocuments} from '../site/source-library.js';
const root=new URL('../',import.meta.url);
const portal=JSON.parse(await readFile(new URL('dist/data/portal.json',root),'utf8'));

test('05–07 관계도와 근거 링크는 실제 자료실 MD와 다운로드를 가리킨다',async()=>{
 for(const id of ['knowledge','maps','feedback']){
  const lesson=portal.lessons.find(l=>l.id===id);
  assert.equal((lesson.html.match(/class="document-tree"/g)||[]).length,1);
  assert.match(lesson.html,/근거 자료 확인/);
  assert.doesNotMatch(lesson.html,/근거와 이어 읽기|<code>knowledge-files|<code>maps-files|<code>feedback-files/);
  let count=0;
  for(const match of lesson.html.matchAll(/href="#\/library\/([a-z0-9-]+)\?file=([^"]+)"/g)){
   const file=decodeURIComponent(match[2]);
   const source=portal.sources.find(s=>s.id===match[1]);
   const doc=source?.mdDocuments.find(d=>d.path===file);
   assert.ok(doc,`${id}: missing ${file}`);
   assert.ok((await readFile(new URL('dist/'+doc.download,root))).length);count++;
  }
  assert.ok(count>=10);
 }
 const lesson=portal.lessons.find(l=>l.id==='knowledge');
 assert.doesNotMatch(lesson.html,/6\. 한계와 다음 방향/);
 assert.match(lesson.html,/<strong>무엇을 근거로 답하는가<\/strong>/);
 assert.match(lesson.html,/<strong>그 근거를 어떤 순서로 찾고 판단하는가<\/strong>/);
});

test('파일 지정 링크는 같은 이름의 다른 폴더 문서를 선택하지 않고 검색으로 돌아갈 수 있다',()=>{
 const rows=['README.md','maps/README.md','AGENTS.md'].map(p=>({dataset:{sourcePath:p,sourceFile:p.toLowerCase()}}));
 const status={},empty={};const root={querySelectorAll:()=>rows,querySelector:s=>s==='[data-source-result]'?status:empty};
 filterSourceDocuments(root,'README.md',{exactPath:true});
 assert.deepEqual(rows.map(r=>r.hidden),[false,true,true]);assert.equal(status.textContent,'1개 파일');
 filterSourceDocuments(root,'missing.md',{exactPath:true});assert.ok(rows.every(r=>r.hidden));assert.equal(empty.hidden,false);
 filterSourceDocuments(root,'');assert.ok(rows.every(r=>!r.hidden));assert.equal(status.textContent,'3개 파일');
});

test('원천 Markdown은 관계도와 HTML을 실행하지 않고 수업에만 등록한 그림을 표시한다',()=>{
 const raw='```document-tree\nknowledge-files\n```\n\n<script>alert(1)</script>';
 const source=renderMarkdown(raw).html;
 assert.doesNotMatch(source,/<figure|<script>/);assert.match(source,/knowledge-files/);assert.match(source,/&lt;script&gt;/);
 const lesson=renderMarkdown(raw,{renderDocumentTree:()=>'<figure>registered</figure>'}).html;
 assert.match(lesson,/<figure>registered<\/figure>/);assert.doesNotMatch(lesson,/<script>/);
});

test('관계도는 없는 문서·원천 밖 경로를 거부하고 표시문 HTML을 이스케이프한다',async t=>{
 const dir=await mkdtemp(path.join(tmpdir(),'lesson-trees-'));t.after(()=>rm(dir,{recursive:true,force:true}));
 await mkdir(path.join(dir,'content'));await mkdir(path.join(dir,'sources/test'),{recursive:true});
 await writeFile(path.join(dir,'sources/test/README.md'),'ok');
 const tree={sample:{source:'test',title:'<img>',description:'<script>',root:{label:'<svg>',path:'README.md'}}};
 const save=()=>writeFile(path.join(dir,'content/lesson-trees.json'),JSON.stringify(tree));
 await save();const compiled=await loadLessonTrees(dir,[{id:'test',path:'sources/test',mdDocuments:[{path:'README.md',download:'downloads/source-md/test/0001.md'}]}]);
 assert.match(compiled.render('sample'),/&lt;svg&gt;/);assert.doesNotMatch(compiled.render('sample'),/<img|<script|<svg/);
 assert.throws(()=>compiled.render('unknown'),/Unknown/);
 tree.sample.root.path='../outside.md';await save();await assert.rejects(loadLessonTrees(dir,[{id:'test',path:'sources/test'}]),/Invalid/);
 tree.sample.root.path='missing.md';await save();await assert.rejects(loadLessonTrees(dir,[{id:'test',path:'sources/test'}]),/ENOENT/);
});
