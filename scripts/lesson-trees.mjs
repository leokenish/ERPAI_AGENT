import {readFile,realpath} from 'node:fs/promises';
import path from 'node:path';
import {escapeHTML} from './markdown.mjs';

// Only authored lesson diagrams use this renderer. Source Markdown still escapes HTML.
export async function loadLessonTrees(root,sources){
 const definitions=JSON.parse(await readFile(path.join(root,'content/lesson-trees.json'),'utf8'));
 const compiled=new Map();
 for(const [id,tree] of Object.entries(definitions)){
  if(!/^[a-z0-9-]+$/.test(id))throw Error('Invalid lesson tree id');
  const source=sources.find(s=>s.id===tree.source);
  if(!source)throw Error(`Unknown tree source: ${tree.source}`);
  const sourceRoot=await realpath(path.join(root,source.path));
  const search=[];
  async function node(n,depth=0){
   if(depth>7||!n.label||typeof n.label!=='string')throw Error('Invalid lesson tree node');
   search.push(n.label,n.role||'',n.note||'');
   let label=`<strong>${escapeHTML(n.label)}</strong>`;
   if(n.path){
    if(typeof n.path!=='string'||path.posix.isAbsolute(n.path)||n.path.includes('\\')||n.path.split('/').some(p=>p==='..'||p==='')||!n.path.endsWith('.md'))throw Error('Invalid tree document path');
    const actual=await realpath(path.join(sourceRoot,n.path));
    if(!actual.startsWith(sourceRoot+path.sep))throw Error('Tree document escapes source');
    const document=source.mdDocuments?.find(d=>d.path===n.path);
    if(!document||!/^downloads\/source-md\/[a-z0-9-]+\/\d+\.md$/.test(document.download))throw Error(`Missing tree download: ${source.id}/${n.path}`);
    label=`<a href="${escapeHTML(document.download)}" download="${escapeHTML(path.posix.basename(n.path))}" aria-label="${escapeHTML(n.label)} 다운로드"><strong>${escapeHTML(n.label)}</strong></a>`;
    search.push(n.path);
   }
   const children=n.children?.length?`<ul>${(await Promise.all(n.children.map(c=>node(c,depth+1)))).join('')}</ul>`:'';
   return `<li><div class="document-tree-node">${n.role?`<span class="document-tree-role">${escapeHTML(n.role)}</span>`:''}${label}${n.note?`<p>${escapeHTML(n.note)}</p>`:''}</div>${children}</li>`;
  }
  const body=await node(tree.root);
  compiled.set(id,{html:`<figure class="document-tree" aria-label="${escapeHTML(tree.title)}"><figcaption><span>파일 관계도</span><strong>${escapeHTML(tree.title)}</strong><p>${escapeHTML(tree.description)}</p></figcaption><ul class="document-tree-root">${body}</ul></figure>`,search:search.join(' ')});
 }
 return {
  render(id){const t=compiled.get(id.trim());if(!t)throw Error(`Unknown lesson tree: ${id}`);return t.html;},
  search(id){return compiled.get(id.trim())?.search||'';}
 };
}
