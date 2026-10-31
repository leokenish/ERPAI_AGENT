// Offline review copy. The hosted site continues to serve dist/ through Node.
import {readFile,writeFile,readdir,mkdir,unlink} from 'node:fs/promises';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
import {gzipSync} from 'node:zlib';
const root=path.resolve(path.dirname(fileURLToPath(import.meta.url)),'..');
const dist=path.join(root,'dist');
const readScript=async name=>(await readFile(path.join(dist,name),'utf8')).replace(/((?:\.\/|data\/)[\w./-]+\.(?:js|json))\?v=[a-f0-9]+/g,'$1');
const mime={'.html':'text/html;charset=utf-8','.abap':'text/plain;charset=utf-8','.otf':'font/otf','.svg':'image/svg+xml','.png':'image/png','.jpg':'image/jpeg','.webp':'image/webp','.md':'text/markdown;charset=utf-8','.zip':'application/zip','.json':'application/json','.py':'text/plain;charset=utf-8','.mjs':'text/plain;charset=utf-8','.js':'text/plain;charset=utf-8','.diff':'text/plain;charset=utf-8','.txt':'text/plain;charset=utf-8','.css':'text/plain;charset=utf-8'};
const files={};
async function collect(directory){for(const e of await readdir(directory,{withFileTypes:true})){const f=path.join(directory,e.name);if(e.isDirectory())await collect(f);else{const relative=path.relative(dist,f).split(path.sep).join('/');let bytes=await readFile(f);
if(/^assets\/worktime-modernization\/[^/]+\/report\.html$/.test(relative)){
 const localCSS=await readFile(path.join(path.dirname(f),'report.css'),'utf8');
 const localJS=await readFile(path.join(path.dirname(f),'report.js'),'utf8');
 let report=bytes.toString('utf8');
 report=report.replace('<script src="report.js"></script>',()=>'<script>'+localJS.replace(/<\/script/gi,'<\\/script')+'</script>');
 report=report.replace(/<link[^>]*href="report.css"[^>]*>/g,()=>'<style>'+localCSS+'</style>');
 bytes=Buffer.from(report);
}
files[relative]=`data:${mime[path.extname(f)]||'application/octet-stream'};base64,${bytes.toString('base64')}`;}}}
for(const name of ['assets','content','downloads'])await collect(path.join(dist,name));
let html=await readFile(path.join(dist,'index.html'),'utf8');
html=html.replace(/((?:src|href)="[^"?]+)\?v=[a-f0-9]+"/g,'$1"');
const theme=await readScript('theme.js');
html=html.replace('<script src="theme.js"></script>',()=>`<script>${theme.replace(/<\/script/gi,'<\\/script')}</script>`);
let css=await readFile(path.join(dist,'styles.css'),'utf8');
css=css.replace(/url\("([^"]+)"\)/g,(all,url)=>files[url]?`url("${files[url]}")`:all);
let app=await readScript('app.js');
const worktimeLabs=(await readScript('worktime-labs.js')).replace(/^export /gm,'');
app=app.replace("import {mountWorktimeLabs} from './worktime-labs.js';",()=>`const {mountWorktimeLabs}=(()=>{\n${worktimeLabs}\nreturn {mountWorktimeLabs};\n})();`);
const documentGraphs=(await readScript('document-graphs.js')).replace(/^export /gm,'');
app=app.replace("import {mountDocumentGraphs} from './document-graphs.js';",()=>`const {mountDocumentGraphs}=(()=>{\n${documentGraphs}\nreturn {mountDocumentGraphs};\n})();`);
const portal=await readFile(path.join(dist,'data/portal.json'),'utf8');
const sourceLibrary=(await readScript('source-library.js')).replace(/^export /gm,'');
app=app.replace("import {renderSourceDocuments,filterSourceDocuments} from './source-library.js';",()=>`const {renderSourceDocuments,filterSourceDocuments}=(()=>{\n${sourceLibrary}\nreturn {renderSourceDocuments,filterSourceDocuments};\n})();`);
const knowledgeMap=(await readScript('knowledge-map.js')).replace(/^export /gm,'');
const knowledge=(await readScript('knowledge.js')).replace(/^export /gm,'').replace("import {countNumber} from './count-up.js';",'').replace("import {renderKnowledgeMap,mountKnowledgeMap} from './knowledge-map.js';",()=>`const {renderKnowledgeMap,mountKnowledgeMap}=(()=>{\n${knowledgeMap}\nreturn {renderKnowledgeMap,mountKnowledgeMap};\n})();`);
app=app.replace("import {renderKnowledge,mountKnowledge} from './knowledge.js';",()=>`const {renderKnowledge,mountKnowledge}=(()=>{\n${knowledge}\nreturn {renderKnowledge,mountKnowledge};\n})();`);
const heroMotion=(await readScript('hero-motion.js')).replace('export function','function');
app=app.replace("import {mountHeroMotion} from './hero-motion.js';",()=>heroMotion);
const countUp=(await readScript('count-up.js')).replace(/^export /gm,'');
app=app.replace("import {countNumber,mountCountUps} from './count-up.js';",()=>countUp);
const characterModule=(await readScript('dialogue-characters.js')).replace(/^export /gm,'');
const conversations=(await readScript('conversations.js')).replace(/^export /gm,'').replace("import {countNumber} from './count-up.js';",'');
const completeConversations=conversations.replace("import {avatarHTML,characterFor,characterNames,expressionFor,characterExpression,dialogueHTML} from './dialogue-characters.js';",()=>`const {avatarHTML,characterFor,characterNames,expressionFor,characterExpression,dialogueHTML}=(()=>{\n${characterModule}\nreturn {avatarHTML,characterFor,characterNames,expressionFor,characterExpression,dialogueHTML};\n})();`);
app=app.replace(/^import \{[^\n]+\} from '\.\/conversations\.js';$/m,()=>`const {conversationIndex,conversationWorkspace,resolveConversation,conversationVisibleCount,relatedConversationCount,conversationLink,conversationSearchEntries}=(()=>{\n${completeConversations}\nreturn {conversationIndex,conversationWorkspace,resolveConversation,conversationVisibleCount,relatedConversationCount,conversationLink,conversationSearchEntries};\n})();`);
app=app.replace("const r=await fetch('data/portal.json');if(!r.ok)throw Error('자료 응답 오류');data=await r.json();",()=>`data=${portal};`);
// This trusted SVG is already inline in portal.heroScene; avoid embedding a duplicate.
delete files['assets/images/team-collaboration-animated.svg'];
delete files['assets/images/team-collaboration-dark.svg'];
for(const key of Object.keys(files))if(key.startsWith('assets/fonts/'))delete files[key];
app=`globalThis.erpPreviewFiles=${JSON.stringify(files)};\n`+app;
html=html.replace(/\s*<link rel="preload"[^>]*>/g,'').replace('<link rel="stylesheet" href="styles.css">',()=>`<style>${css}</style>`).replace('  <script type="module" src="app.js"></script>','').replace('href="assets/favicon.svg"',()=>`href="${files['assets/favicon.svg']}"`);
html=html.replace(/(src|href)="(assets\/[^"]+)"/g,(all,attr,url)=>files[url]?`${attr}="${files[url]}"`:all);
// Compress the trusted, self-contained module to retain all originals without
// ballooning the repository's single offline HTML file. No network is required.
const target=path.resolve(root,process.argv[2]||'preview.html');
const payload=gzipSync(Buffer.from(app),{level:9});
const companion=path.basename(target,path.extname(target))+'-data';
const companionPath=path.join(path.dirname(target),companion);
await mkdir(companionPath,{recursive:true});
for(const name of await readdir(companionPath))if(/^part-\d+\.js$/.test(name))await unlink(path.join(companionPath,name));
// Classic script sidecars also load from file://. Each generated file stays
// small enough for ordinary Git; the HTML and folder form one offline bundle.
let payloadScripts='<script>globalThis.erpPreviewParts=[];</script>';
const partSize=12*1024*1024;
for(let offset=0,index=1;offset<payload.length;offset+=partSize,index++){
 const filename=`part-${String(index).padStart(3,'0')}.js`;
 await writeFile(path.join(companionPath,filename),`globalThis.erpPreviewParts.push("${payload.subarray(offset,offset+partSize).toString('base64')}");\n`);
 payloadScripts+=`<script src="${companion}/${filename}"></script>`;
}
const bootstrap=`try {
 if(typeof DecompressionStream==='undefined')throw Error('이 미리보기는 최신 Chrome, Edge, Firefox 또는 Safari에서 열어 주세요.');
 const packed=globalThis.erpPreviewParts.map(part=>Uint8Array.from(atob(part),c=>c.charCodeAt(0)));delete globalThis.erpPreviewParts;
 const code=await new Response(new Blob(packed).stream().pipeThrough(new DecompressionStream('gzip'))).text();
 const module=document.createElement('script');module.type='module';module.textContent=code;document.body.append(module);
} catch(error) {document.getElementById('main').textContent='미리보기를 열 수 없습니다. '+error.message;}`;
html=html.replace('</body>',()=>`${payloadScripts}<script type="module">${bootstrap}</script>\n</body>`);
await writeFile(target,html);
console.log(`Offline preview: ${target} (${Buffer.byteLength(html)} bytes), ${companion}/ (${Math.ceil(payload.length/partSize)} compressed parts)`);
