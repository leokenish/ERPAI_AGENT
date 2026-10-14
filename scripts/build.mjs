import {readFile,writeFile,mkdir,cp,rm,readdir} from 'node:fs/promises';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
import {renderMarkdown} from './markdown.mjs';
import {buildConversations} from './build-conversations.mjs';
import {buildKnowledge} from './build-knowledge.mjs';
const root=path.dirname(path.dirname(fileURLToPath(import.meta.url)));
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
catalog.compareCases=JSON.parse(await readFile(path.join(root,'examples/three_way_cases.json'),'utf8'));
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
await cp(path.join(root,'site'),out,{recursive:true});
await writeFile(path.join(out,'styles.css'),(await readFile(path.join(root,'site/styles.css'),'utf8'))+'\n'+(await readFile(path.join(root,'site/conversations.css'),'utf8'))+'\n'+(await readFile(path.join(root,'site/presentation.css'),'utf8'))+'\n'+(await readFile(path.join(root,'site/knowledge.css'),'utf8'))+'\n'+(await readFile(path.join(root,'site/refinements.css'),'utf8'))+'\n/* Screen-only hero animation */\n'+heroCSS);
await cp(path.join(root,'assets'),path.join(out,'assets'),{recursive:true});
catalog.conversations=await buildConversations(root,out);
catalog.worktimeKnowledge=await buildKnowledge(root,out);
catalog.sources.find(s=>s.id==='worktime-agent').sha256=catalog.worktimeKnowledge.archiveSha256;
await mkdir(path.join(out,'downloads'),{recursive:true});
for(const item of catalog.downloads){
 if(!/^(examples|content\/templates)\/[\w.-]+$/.test(item.from))throw Error('Invalid download path');
 if(!/^[\w.-]+$/.test(item.file))throw Error('Invalid download name');
 await cp(path.join(root,item.from),path.join(out,'downloads',item.file));
}
await mkdir(path.join(out,'data'),{recursive:true});
await writeFile(path.join(out,'data/portal.json'),JSON.stringify(catalog));
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
await cp(out,path.join(root,'dist'),{recursive:true}); await rm(out,{recursive:true,force:true});
console.log(`Built ${catalog.lessons.length} lessons, ${catalog.sources.length} source summaries, ${catalog.downloads.length} downloads. Output: dist/`);
