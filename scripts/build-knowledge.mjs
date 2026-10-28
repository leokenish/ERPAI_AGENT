import {readFile,readdir,mkdir,writeFile} from 'node:fs/promises';
import path from 'node:path';
import {createHash} from 'node:crypto';
import {deflateRawSync} from 'node:zlib';
import {Marked} from '../vendor/marked.mjs';
import {renderMarkdown} from './markdown.mjs';
export const groups=[
 {id:'instructions',title:'지침·스킬',folder:'AGENTS.md · .agents/skills/',purpose:'어떤 범위에서, 어떤 순서로 읽고 판단할지 정합니다.',change:'역할·근거 원칙·작업 절차가 바뀔 때',entry:'AGENTS.md'},
 {id:'guides',title:'구축·유지 가이드',folder:'docs/',purpose:'구축 방법과 출처, 지식을 유지하는 기준을 기록합니다.',change:'새 원문·판본·갱신 절차가 추가될 때',entry:'docs/KNOWLEDGE_MAINTENANCE.md'},
 {id:'knowledge',title:'업무 지식',folder:'knowledge/',purpose:'규정·협의 이유·절차·예외와 질의 이력을 보관합니다.',change:'정책·협의·사례를 추가하거나 정정할 때',entry:'knowledge/INDEX.md'},
 {id:'maps',title:'Obsidian 업무 지도',folder:'maps/ · maps/topics/',purpose:'업무 질문에 필요한 근거와 소스 설명을 찾아가도록 안내합니다.',change:'문서·소스·업무 단계의 관계가 바뀔 때',entry:'maps/INDEX.md'},
 {id:'code',title:'소스 설명 MD',folder:'maps/sources/',purpose:'객체·화면·함수·데이터의 설명과 참조 위치를 연결합니다.',change:'추출 소스의 변경과 근거 위치를 확인한 뒤',entry:'maps/sources/INDEX.md'},
 {id:'feedback',title:'피드백·평가',folder:'harness/feedback/ · tests/ · evals/',purpose:'정정 이유와 다시 확인할 질문을 묶어 같은 오류의 재발을 줄입니다.',change:'오류·반례·경계 조건을 발견했을 때',entry:'harness/feedback/FB-20261008-001.md'},
 {id:'support',title:'시작점·양식·안내',folder:'README.md · templates/ · exports/ 등',purpose:'처음 시작하는 방법과 반복 사용할 기록 양식을 둡니다.',change:'안내·기록 양식·추출 설명이 달라질 때',entry:'README.md'}
];
export function classify(p){if(p==='AGENTS.md'||p.startsWith('.agents/'))return 'instructions';if(p.startsWith('docs/'))return 'guides';if(p.startsWith('knowledge/'))return 'knowledge';if(p.startsWith('maps/sources/'))return 'code';if(p.startsWith('maps/'))return 'maps';if(/^(harness|tests|evals)\//.test(p))return 'feedback';return 'support';}
const idFor=p=>'md-'+createHash('sha256').update(p).digest('hex').slice(0,14);
const digest=b=>createHash('sha256').update(b).digest('hex');
export function resolvePath(from,href,all){
 let value=String(href||'').trim();try{value=decodeURIComponent(value);}catch{}
 if(/^(?:[a-z][a-z\d+.-]*:|\/\/)/i.test(value))return {external:true,href:value};
 const [base,anchor='']=value.split('#');if(!base)return {path:from,anchor};
 const relative=path.posix.normalize(path.posix.join(path.posix.dirname(from),base));
 const attempts=[relative,base.replace(/^\//,'')];
 for(const p of attempts)if(all.has(p))return {path:p,anchor};
 if(!path.posix.extname(base))for(const p of attempts)if(all.has(p+'.md'))return {path:p+'.md',anchor};
 const name=base.split('/').pop();const basenameMatches=[...all].filter(p=>p.split('/').pop()===name||(p.split('/').pop()===name+'.md'));
 if(basenameMatches.length===1)return {path:basenameMatches[0],anchor};
 return {path:relative,anchor,missing:true};
}
// Reproducible UTF-8 ZIP, using only Node built-ins (no system zip/Python needed).
const crcTable=Array.from({length:256},(_,n)=>{for(let i=0;i<8;i++)n=(n&1)?0xedb88320^(n>>>1):n>>>1;return n>>>0;});
function crc32(b){let c=0xffffffff;for(const v of b)c=crcTable[(c^v)&255]^(c>>>8);return (c^0xffffffff)>>>0;}
export function makeZip(entries){let offset=0;const chunks=[],central=[];for(const {name,bytes} of entries){const n=Buffer.from(name),z=deflateRawSync(bytes),crc=crc32(bytes);const h=Buffer.alloc(30);h.writeUInt32LE(0x04034b50);h.writeUInt16LE(20,4);h.writeUInt16LE(0x800,6);h.writeUInt16LE(8,8);h.writeUInt16LE(33,12);h.writeUInt32LE(crc,14);h.writeUInt32LE(z.length,18);h.writeUInt32LE(bytes.length,22);h.writeUInt16LE(n.length,26);chunks.push(h,n,z);const c=Buffer.alloc(46);c.writeUInt32LE(0x02014b50);c.writeUInt16LE(20,4);c.writeUInt16LE(20,6);c.writeUInt16LE(0x800,8);c.writeUInt16LE(8,10);c.writeUInt16LE(33,14);c.writeUInt32LE(crc,16);c.writeUInt32LE(z.length,20);c.writeUInt32LE(bytes.length,24);c.writeUInt16LE(n.length,28);c.writeUInt32LE(offset,42);central.push(c,n);offset+=h.length+n.length+z.length;}const end=Buffer.alloc(22);end.writeUInt32LE(0x06054b50);end.writeUInt16LE(entries.length,8);end.writeUInt16LE(entries.length,10);end.writeUInt32LE(central.reduce((n,b)=>n+b.length,0),12);end.writeUInt32LE(offset,16);return Buffer.concat([...chunks,...central,end]);}
export async function buildKnowledge(root,out){
 const config=JSON.parse(await readFile(path.join(root,'content/worktime-knowledge.json'),'utf8'));
 const source=path.join(root,config.snapshot);const snapshot=JSON.parse(await readFile(path.join(source,'snapshot.json'),'utf8'));
 const all=new Set(snapshot.files.map(f=>f.path));const docs=[],edges=[],refs=[],zip=[];const raw=new Map();
 await mkdir(path.join(out,'downloads/worktime'),{recursive:true});
 for(const f of snapshot.files){
  if(!/\.md$/i.test(f.path)||path.isAbsolute(f.path)||f.path.split('/').includes('..'))throw Error('Invalid MD path');
  const bytes=await readFile(path.join(source,f.path));const blob=createHash('sha1').update(Buffer.concat([Buffer.from(`blob ${bytes.length}\0`),bytes])).digest('hex');
  if(blob!==f.sha)throw Error(`Snapshot changed: ${f.path}`);
  const text=bytes.toString('utf8'),body=text.replace(/^---\r?\n[\s\S]*?\r?\n---\r?\n/,'');raw.set(f.path,{text,body});
  const meta=text.match(/^---\r?\n([\s\S]*?)\r?\n---/)?.[1]||'';
  const title=(body.match(/^#\s+(.+)$/m)?.[1]||f.path.split('/').pop()).replace(/[`*_]/g,'');
  const doc={id:idFor(f.path),path:f.path,title,group:classify(f.path),bytes:bytes.length,sha256:digest(bytes),blobSha:f.sha,empty:bytes.length===0,date:meta.match(/^as_of:\s*(.+)$/m)?.[1]||'',review:meta.match(/^review_status:\s*(.+)$/m)?.[1]||'',download:`downloads/worktime/${idFor(f.path)}.md`,summary:body.split('\n').filter(s=>s.trim()&&!/^(#|\||```|<!--|---)/.test(s)).slice(0,2).join(' ').replace(/\[([^\]]+)\]\([^)]*\)/g,'$1').replace(/[`*_]/g,'').slice(0,230)};
  docs.push(doc);await writeFile(path.join(out,doc.download),bytes);zip.push({name:f.path,bytes});
 }
 const parser=new Marked();const docByPath=new Map(docs.map(d=>[d.path,d]));
 for(const d of docs){
  const {text,body}=raw.get(d.path);const found=[];
  // Marked resolves reference-style links and omits links inside code blocks.
  parser.walkTokens(parser.lexer(text),t=>{if(t.type==='link')found.push({href:t.href,label:t.text,kind:'link',raw:t.raw});if(t.type==='codespan'&&/\.md(?:#.*)?$/i.test(t.text)&&!/[<>*]/.test(t.text))found.push({href:t.text,label:t.text,kind:'mention',raw:t.raw});});
  for(const m of text.replace(/```[\s\S]*?```/g,'').matchAll(/\[\[([^\]|]+)(?:\|([^\]]+))?\]\]/g))found.push({href:m[1],label:m[2]||m[1],kind:'wiki',raw:m[0]});
  const seen=new Set();
  for(const f of found){const target=resolvePath(d.path,f.href,all);if(target.external)continue;const key=target.path+'|'+f.kind;if(seen.has(key)||target.path===d.path)continue;seen.add(key);
   const pos=text.indexOf(f.raw);const line=pos<0?null:text.slice(0,pos).split('\n').length;
   const section=pos<0?'':([...text.slice(0,pos).matchAll(/^#{1,6}\s+(.+)$/gm)].at(-1)?.[1]||'');
   if(!target.missing){edges.push({from:d.id,to:docByPath.get(target.path).id,kind:f.kind,line,section,label:f.label});}
   else refs.push({from:d.id,path:target.path,label:f.label,line,referenceType:f.kind,original:f.href,kind:/\.md$/i.test(target.path)?'unresolved':'outside'});
  }
  const converted=body.replace(/\[\[([^\]|]+)(?:\|([^\]]+))?\]\]/g,(_,href,label)=>`[${label||href}](${href})`);
  d.html=renderMarkdown(converted,{keepTitle:true,headingPrefix:d.id+'-',headingOffset:2,resolveURL:href=>{const t=resolvePath(d.path,href,all);if(t.external)return /^https?:/.test(href)?href:null;if(t.missing)return null;return `#/learn/worktime-agent?doc=${docByPath.get(t.path).id}&read=1`;}}).html;
 }
 const archive='downloads/ERP_AI_Markdown_'+snapshot.commit.slice(0,12)+'.zip';const archiveBytes=makeZip(zip);await writeFile(path.join(out,archive),archiveBytes);
 const inventory={repository:snapshot.repository,commit:snapshot.commit,asOf:snapshot.retrievedAt,files:docs.map(({html,...d})=>d)};
 await writeFile(path.join(out,'downloads/ERP_AI_Markdown_inventory.json'),JSON.stringify(inventory,null,2));
 const summary={documents:docs.length,explicitLinks:edges.filter(e=>e.kind!=='mention').length,pathMentions:edges.filter(e=>e.kind==='mention').length,outside:refs.filter(r=>r.kind==='outside').length,unresolved:refs.filter(r=>r.kind==='unresolved').length,topics:docs.filter(d=>d.path.startsWith('maps/topics/')).length,empty:docs.filter(d=>d.empty).length};
 console.log('Knowledge snapshot:',summary);
 return {...config,repository:snapshot.repository,commit:snapshot.commit,asOf:snapshot.retrievedAt,groups:groups.map(g=>({...g,count:docs.filter(d=>d.group===g.id).length,entry:docByPath.get(g.entry)?.id})),documents:docs,edges,references:refs,summary,archive,archiveSha256:digest(archiveBytes),inventory:'downloads/ERP_AI_Markdown_inventory.json'};
}
