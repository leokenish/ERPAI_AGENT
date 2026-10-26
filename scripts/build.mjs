import {readFile,writeFile,mkdir,cp,rm,readdir,rename} from 'node:fs/promises';
import path from 'node:path';
import {createHash} from 'node:crypto';
import {fileURLToPath} from 'node:url';
import {renderMarkdown} from './markdown.mjs';
import {buildConversations} from './build-conversations.mjs';
import {buildKnowledge} from './build-knowledge.mjs';
import {buildCoreDocuments} from './build-core-documents.mjs';
import {buildSourceDocuments} from './build-source-documents.mjs';
import {updateOliveFruits} from './color-olive-fruits.mjs';
const root=path.dirname(path.dirname(fileURLToPath(import.meta.url)));
await updateOliveFruits(root);
const out=path.join(root,'dist.next');
await rm(out,{recursive:true,force:true}); await mkdir(out,{recursive:true});
const catalog=JSON.parse(await readFile(path.join(root,'content/catalog.json'),'utf8'));
// Move trusted SVG styles into the external stylesheet to preserve the CSP.
let heroCSS='';
async function loadHero(filename,rootId){
 return (await readFile(path.join(root,'assets/images',filename),'utf8'))
 .replace(/<style>([\s\S]*?)<\/style>/g,(_,css)=>{heroCSS+=css;return '';})
 .replace(/<g id="([\w-]+)" class="ui-motion" style="([^"]+)"/g,(_,id,css)=>{
  if(!/^--cycle:[\d.]+s;--delay:-?[\d.]+s$/.test(css))throw Error('Unexpected hero timing');
  heroCSS+=`\n#${rootId} #${id}{${css}}`;
  return `<g id="${id}" class="ui-motion"`;
 });
}
catalog.heroScene=await loadHero('team-collaboration-animated.svg','erp-screen-scene');
catalog.heroSceneDark=await loadHero('team-collaboration-dark.svg','dark-erp-screen-scene');
const ids=new Set();
for(const lesson of catalog.lessons){
 if(ids.has(lesson.id))throw Error(`Duplicate lesson ${lesson.id}`); ids.add(lesson.id);
 if(!/^lessons\/[a-z0-9-]+\.md$/.test(lesson.file))throw Error('Invalid lesson path');
 const md=await readFile(path.join(root,'content',lesson.file),'utf8');
 const rendered=renderMarkdown(md);
 Object.assign(lesson,rendered,{search:md.replace(/[#*`>|]/g,' ')});
 await mkdir(path.join(out,'content','lessons'),{recursive:true});
 await writeFile(path.join(out,'content',lesson.file),md);
}
// Read the current source bytes rather than reusing file-copy metadata.
async function copySite(from,to){
 await mkdir(to,{recursive:true});
 for(const entry of await readdir(from,{withFileTypes:true})){
  const source=path.join(from,entry.name),target=path.join(to,entry.name);
  if(entry.isDirectory())await copySite(source,target);
  else await writeFile(target,await readFile(source));
 }
}
await copySite(path.join(root,'site'),out);
await writeFile(path.join(out,'styles.css'),(await readFile(path.join(root,'site/styles.css'),'utf8'))+'\n'+(await readFile(path.join(root,'site/conversations.css'),'utf8'))+'\n'+(await readFile(path.join(root,'site/knowledge.css'),'utf8'))+'\n'+(await readFile(path.join(root,'site/refinements.css'),'utf8'))+'\n/* Screen-only hero animation */\n'+heroCSS);
await cp(path.join(root,'assets'),path.join(out,'assets'),{recursive:true});
catalog.conversations=await buildConversations(root,out);
catalog.worktimeKnowledge=await buildKnowledge(root,out);
await buildSourceDocuments(root,out,catalog.sources);
catalog.coreDocuments=await buildCoreDocuments(root,out,catalog.sources);
catalog.sources.find(s=>s.id==='worktime-agent').sha256=catalog.worktimeKnowledge.archiveSha256;
await mkdir(path.join(out,'downloads'),{recursive:true});
for(const item of catalog.downloads){
 if(!/^(examples|content\/templates)\/[\w.-]+$/.test(item.from))throw Error('Invalid download path');
 if(!/^[\w.-]+$/.test(item.file))throw Error('Invalid download name');
 await cp(path.join(root,item.from),path.join(out,'downloads',item.file));
}
await mkdir(path.join(out,'data'),{recursive:true});
await writeFile(path.join(out,'data/portal.json'),JSON.stringify(catalog));
// Version the complete browser module graph together to avoid mixed cached releases.
const browserFiles=(await readdir(out)).filter(name=>/\.(js|css)$/.test(name)).sort();
const assetHash=createHash('sha256');
for(const name of browserFiles)assetHash.update(await readFile(path.join(out,name)));
assetHash.update(JSON.stringify(catalog));
const assetVersion=assetHash.digest('hex').slice(0,12);
for(const name of browserFiles.filter(name=>name.endsWith('.js'))){
 const input=await readFile(path.join(out,name),'utf8');
 await writeFile(path.join(out,name),input.replace(/(from\s+['"]\.\/[\w-]+\.js)(['"])/g,`$1?v=${assetVersion}$2`).replace("fetch('data/portal.json')",`fetch('data/portal.json?v=${assetVersion}')`));
}
const entry=await readFile(path.join(out,'index.html'),'utf8');
await writeFile(path.join(out,'index.html'),entry
 .replace('</title>',` · v${catalog.version}</title>`)
 .replace('</head>',`  <meta name="erp-portal-version" content="${catalog.version}">\n</head>`)
 .replace(/((?:src|href)="(?:theme\.js|app\.js|styles\.css))"/g,`$1?v=${assetVersion}"`));
// Generate the Pages entry from the same release as dist and the offline preview.
await writeFile(path.join(root,'index.html'),`<!doctype html>
<html lang="ko">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>ERP AI 에이전트 · v${catalog.version}</title>
<script>
const target=new URL(location.protocol==='file:'?'./preview.html':'./dist/',location.href);
target.search=location.search;
target.searchParams.set('v','${catalog.version}-${assetVersion}');
target.hash=location.hash;
location.replace(target.href);
</script>
<p><a href="./dist/?v=${catalog.version}-${assetVersion}">ERP AI 에이전트 v${catalog.version} 열기</a></p>
</html>
`);
const manifest={version:catalog.version,asOf:catalog.asOf,lessons:catalog.lessons.length,sourceBundles:catalog.sources.length,conversations:catalog.conversations.totals,files:[]};
async function walk(dir){for(const e of await readdir(dir,{withFileTypes:true})){const f=path.join(dir,e.name);if(e.isDirectory())await walk(f);else manifest.files.push(path.relative(out,f).split(path.sep).join('/'));}}await walk(out);
// Validate every curated Markdown link against known lessons or public files.
for(const lesson of catalog.lessons){
 for(const match of lesson.search.matchAll(/\]\(([^)]+)\)/g)){
  const href=match[1];
  if(href.startsWith('#/learn/')&&!ids.has(href.split('/')[2]))throw Error(`Unknown lesson link: ${href}`);
  if(/^(assets|downloads)\//.test(href)&&!manifest.files.includes(href))throw Error(`Missing asset: ${href}`);
 }
}
await writeFile(path.join(out,'data/build.json'),JSON.stringify(manifest,null,2));
await rm(path.join(root,'dist'),{recursive:true,force:true});
await rename(out,path.join(root,'dist'));
console.log(`Built ${catalog.lessons.length} lessons, ${catalog.sources.length} source summaries, ${catalog.downloads.length} downloads. Output: dist/`);
