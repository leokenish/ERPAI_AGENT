// Offline review copy. The hosted site continues to serve dist/ through Node.
import {readFile,writeFile,readdir} from 'node:fs/promises';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
const root=path.resolve(path.dirname(fileURLToPath(import.meta.url)),'..');
const dist=path.join(root,'dist');
const readScript=async name=>(await readFile(path.join(dist,name),'utf8')).replace(/((?:\.\/|data\/)[\w./-]+\.(?:js|json))\?v=[a-f0-9]+/g,'$1');
const mime={'.otf':'font/otf','.svg':'image/svg+xml','.png':'image/png','.jpg':'image/jpeg','.webp':'image/webp','.md':'text/markdown;charset=utf-8','.zip':'application/zip','.json':'application/json','.py':'text/plain;charset=utf-8','.mjs':'text/plain;charset=utf-8','.js':'text/plain;charset=utf-8','.diff':'text/plain;charset=utf-8','.txt':'text/plain;charset=utf-8','.css':'text/plain;charset=utf-8'};
const files={};
async function collect(directory){for(const e of await readdir(directory,{withFileTypes:true})){const f=path.join(directory,e.name);if(e.isDirectory())await collect(f);else{const relative=path.relative(dist,f).split(path.sep).join('/');files[relative]=`data:${mime[path.extname(f)]||'application/octet-stream'};base64,${(await readFile(f)).toString('base64')}`;}}}
for(const name of ['assets','content','downloads'])await collect(path.join(dist,name));
let html=await readFile(path.join(dist,'index.html'),'utf8');
html=html.replace(/((?:src|href)="[^"?]+)\?v=[a-f0-9]+"/g,'$1"');
const theme=await readScript('theme.js');
html=html.replace('<script src="theme.js"></script>',()=>`<script>${theme.replace(/<\/script/gi,'<\\/script')}</script>`);
let css=await readFile(path.join(dist,'styles.css'),'utf8');
css=css.replace(/url\("([^"]+)"\)/g,(all,url)=>files[url]?`url("${files[url]}")`:all);
let app=await readScript('app.js');
const comparison=(await readScript('compare.js')).replaceAll('export function','function');
const portal=await readFile(path.join(dist,'data/portal.json'),'utf8');
app=app.replace("import {compare} from './compare.js';",()=>comparison);
const knowledgeMap=(await readScript('knowledge-map.js')).replace(/^export /gm,'');
const knowledge=(await readScript('knowledge.js')).replace(/^export /gm,'').replace("import {countNumber} from './count-up.js';",'').replace("import {renderKnowledgeMap,mountKnowledgeMap} from './knowledge-map.js';",()=>`const {renderKnowledgeMap,mountKnowledgeMap}=(()=>{\n${knowledgeMap}\nreturn {renderKnowledgeMap,mountKnowledgeMap};\n})();`);
app=app.replace("import {renderKnowledge,mountKnowledge} from './knowledge.js';",()=>`const {renderKnowledge,mountKnowledge}=(()=>{\n${knowledge}\nreturn {renderKnowledge,mountKnowledge};\n})();`);
const heroMotion=(await readScript('hero-motion.js')).replace('export function','function');
app=app.replace("import {mountHeroMotion} from './hero-motion.js';",()=>heroMotion);
const presentation=(await readScript('presentation.js')).replace(/^export /gm,'');
app=app.replace("import {renderPresentation,mountPresentation} from './presentation.js';",()=>`const {renderPresentation,mountPresentation}=(()=>{\n${presentation}\nreturn {renderPresentation,mountPresentation};\n})();`);
const countUp=(await readScript('count-up.js')).replace(/^export /gm,'');
app=app.replace("import {countNumber,mountCountUps} from './count-up.js';",()=>countUp);
const conversations=(await readScript('conversations.js')).replace(/^export /gm,'').replace("import {countNumber} from './count-up.js';",'');
app=app.replace(/^import \{[^\n]+\} from '\.\/conversations\.js';$/m,()=>`const {conversationIndex,conversationWorkspace,resolveConversation,conversationVisibleCount,relatedConversationCount,conversationLink,conversationSearchEntries}=(()=>{\n${conversations}\nreturn {conversationIndex,conversationWorkspace,resolveConversation,conversationVisibleCount,relatedConversationCount,conversationLink,conversationSearchEntries};\n})();`);
app=app.replace("const r=await fetch('data/portal.json');if(!r.ok)throw Error('자료 응답 오류');data=await r.json();",()=>`data=${portal};`);
// This trusted SVG is already inline in portal.heroScene; avoid embedding a duplicate.
delete files['assets/images/team-collaboration-animated.svg'];
delete files['assets/images/team-collaboration-dark.svg'];
for(const key of Object.keys(files))if(key.startsWith('assets/fonts/'))delete files[key];
app=`globalThis.erpPreviewFiles=${JSON.stringify(files)};\n`+app;
html=html.replace(/\s*<link rel="preload"[^>]*>/g,'').replace('<link rel="stylesheet" href="styles.css">',()=>`<style>${css}</style>`).replace('  <script type="module" src="app.js"></script>','').replace('href="assets/favicon.svg"',()=>`href="${files['assets/favicon.svg']}"`);
html=html.replace(/(src|href)="(assets\/[^"]+)"/g,(all,attr,url)=>files[url]?`${attr}="${files[url]}"`:all);
// Callbacks preserve literal $&, $` and $' within source code and transcripts.
html=html.replace('</body>',()=>`<script type="module">${app.replace(/<\/script/gi,'<\\/script')}</script>\n</body>`);
const target=path.resolve(root,process.argv[2]||'preview.html');
await writeFile(target,html);
console.log(`Offline preview: ${target} (${Buffer.byteLength(html)} bytes)`);
