import {readFile,writeFile,mkdir,copyFile,stat} from 'node:fs/promises';
import path from 'node:path';
import {createHash} from 'node:crypto';
import {renderMarkdown} from './markdown.mjs';
import {applyReadingEdition} from './reading-edition.mjs';

const allowedNodes=new Set(['sap','export','git','knowledge','codex','diag','maps','feedback','telegram','agent','lookup','worker','hub','erp-api','expert','portal']);
const idPattern=/^[a-zA-Z0-9_-]+$/;
function requireValue(condition,message){if(!condition)throw Error(`Conversation data: ${message}`);}
function safePath(base,relative){
 requireValue(typeof relative==='string'&&!relative.includes('\\')&&!path.isAbsolute(relative),'invalid path');
 const full=path.resolve(base,relative);
 requireValue(full.startsWith(path.resolve(base)+path.sep),'path outside source bundle');
 return full;
}
export function validateConversation(raw){
 requireValue(raw.schema_version==='1.0'&&idPattern.test(raw.project_id),'unknown schema/project');
 const messages=raw.threads.flatMap(t=>t.messages),ids=new Set(),assetIds=new Set();
 for(const a of raw.assets){requireValue(idPattern.test(a.id)&&!assetIds.has(a.id),'duplicate/invalid asset ID');assetIds.add(a.id);}
 let sequence=0;
 for(const m of messages){
  requireValue(idPattern.test(m.id)&&!ids.has(m.id),'duplicate/invalid message ID');ids.add(m.id);
  requireValue(Number.isInteger(m.sequence)&&m.sequence>sequence,`message order ${m.id}`);sequence=m.sequence;
  requireValue(['user','assistant'].includes(m.role),`unsupported role ${m.id}`);
  requireValue(['verbatim','excerpt','summary','reconstructed','unavailable'].includes(m.content_type),`unknown content type ${m.id}`);
  if(m.content_type==='unavailable')requireValue(m.role==='assistant'&&m.content_markdown===''&&m.capture_status==='no_response_body_visible',`invalid missing-response marker ${m.id}`);
  requireValue(typeof m.content_markdown==='string'&&typeof m.source_locator==='string',`missing source/body ${m.id}`);
  for(const aid of m.asset_ids)requireValue(assetIds.has(aid),`missing message asset ${aid}`);
 }
 const byId=new Map(messages.map(m=>[m.id,m])),episodeIds=new Set();
 for(const e of raw.episodes){
  requireValue(idPattern.test(e.id)&&!episodeIds.has(e.id),'duplicate/invalid episode ID');episodeIds.add(e.id);
  requireValue(e.map_nodes.length&&e.map_nodes.every(n=>allowedNodes.has(n)),`unknown map node ${e.id}`);
  let previous=0;
  for(const mid of e.message_refs){const m=byId.get(mid);requireValue(m&&m.sequence>previous,`invalid message reference/order ${e.id}/${mid}`);previous=m.sequence;}
  for(const aid of e.asset_ids)requireValue(assetIds.has(aid),`missing episode asset ${aid}`);
 }
 return messages;
}
export function conversationResolver(assets,documents){
 const byPath=new Map(assets.filter(a=>a.publicPath).map(a=>[a.path,a.publicPath]));
 const byName=new Map();
 for(const a of assets.filter(a=>a.publicPath)){
  for(const name of [a.original_filename,path.posix.basename(a.path)]){
   if(!byName.has(name))byName.set(name,a.publicPath);
   else if(byName.get(name)!==a.publicPath)byName.set(name,null);
  }
 }
 return href=>{
  if(!href)return null;
  if(/^https?:\/\//i.test(href))return href;
  // Historical sandbox, citation and attachment links are not live portal routes.
  const rel=href.replace(/^\.\//,'');
  return documents[rel]||byPath.get(rel)||byName.get(path.posix.basename(rel))||null;
 };
}
export async function buildConversations(root,out){
 const config=JSON.parse(await readFile(path.join(root,'content/conversations/catalog.json'),'utf8'));
 const reading=JSON.parse(await readFile(path.join(root,'content/conversations/reading-edition.json'),'utf8'));
 requireValue(reading.schema_version==='1.0'&&Object.keys(reading.projects).every(id=>config.projects.some(p=>p.id===id)),'invalid reading edition');
 const editorial=JSON.parse(await readFile(path.join(root,'content/conversations/editorial-prompts.json'),'utf8'));
 requireValue(editorial.schema_version==='1.0','unknown editorial schema');
 requireValue(Object.keys(editorial.projects).every(id=>config.projects.some(p=>p.id===id)),'unknown editorial project');
 const responseEditorial=JSON.parse(await readFile(path.join(root,'content/conversations/editorial-responses.json'),'utf8'));
 requireValue(responseEditorial.schema_version==='1.0','unknown response editorial schema');
 requireValue(Object.keys(responseEditorial.projects).every(id=>config.projects.some(p=>p.id===id)),'unknown response editorial project');
 const projects=[];
 for(const meta of config.projects){
  const sourcePath=meta.sourcePath||`${config.sourceRoot}/${meta.id}`;
  const source=safePath(root,sourcePath);
  const assetSource=meta.assetSourcePath?safePath(root,meta.assetSourcePath):source;
  const raw=JSON.parse(await readFile(path.join(source,'conversation-data.json'),'utf8'));
  requireValue(raw.project_id===meta.id,'project directory mismatch');
  const messages=validateConversation(raw);
  const progressIds=new Set(meta.progressMessageIds||[]);
  for(const id of progressIds)requireValue(messages.some(m=>m.id===id&&m.role==='assistant'&&m.content_type==='verbatim'),`invalid progress message ${meta.id}/${id}`);
  const edits=editorial.projects[meta.id]||{};
  const responseEdits=responseEditorial.projects[meta.id]||{};
  for(const [id,edit] of Object.entries(responseEdits)){
   const m=messages.find(m=>m.id===id);
   requireValue(m?.role==='assistant'&&m.content_markdown.trim(),`response editorial target is not assistant text ${meta.id}/${id}`);
   requireValue(edit.source_sha256===createHash('sha256').update(m.content_markdown).digest('hex'),`stale response editorial source ${meta.id}/${id}`);
   requireValue(edit.source_content_type===m.content_type,`response editorial provenance mismatch ${meta.id}/${id}`);
   requireValue(typeof edit.content_markdown==='string'&&edit.content_markdown.trim(),`empty response editorial text ${meta.id}/${id}`);
  }
  for(const [id,edit] of Object.entries(edits)){
   const m=messages.find(m=>m.id===id);
   requireValue(m?.role==='user'&&m.content_markdown.trim(),`editorial target is not a user text ${meta.id}/${id}`);
   requireValue(edit.source_sha256===createHash('sha256').update(m.content_markdown).digest('hex'),`stale editorial source ${meta.id}/${id}`);
   requireValue(typeof edit.content_markdown==='string'&&edit.content_markdown.trim(),`empty editorial text ${meta.id}/${id}`);
  }
  for(const m of messages)if(m.role==='user'&&m.content_markdown.trim())requireValue(edits[m.id],`missing editorial text ${meta.id}/${m.id}`);
  const assets=[],publishedAssets=new Map();
  for(const original of raw.assets){
   const a={...original,publicPath:null};
   if(a.availability==='included'){
    const input=safePath(a.asset_root?safePath(root,a.asset_root):assetSource,a.path);
    requireValue((await stat(input)).isFile(),`missing included asset ${a.id}`);
    if(a.kind==='image'){
     requireValue(/\.(png|jpe?g|webp)$/i.test(input),'unsupported image');
     a.publicPath=`assets/conversations/${meta.id}/${a.id}${path.extname(input).toLowerCase()}`;
     const target=path.join(out,a.publicPath);await mkdir(path.dirname(target),{recursive:true});await copyFile(input,target);
    }
    if(meta.publishAttachments&&a.kind!=='image'){
     requireValue(/\.(zip|md|txt|json|mjs|js|py|css|diff|csv|ya?ml|abap|html)$/i.test(input),'unsupported attachment');
     const bytes=await readFile(input),hash=createHash('sha256').update(bytes).digest('hex');
     if(a.sha256)requireValue(a.sha256===hash,`attachment hash mismatch ${a.id}`);
     a.sha256=hash;
     const key=hash+path.extname(input).toLowerCase();
     a.publicPath=publishedAssets.get(key)||`downloads/conversations/${meta.id}/attachments/${a.id}${path.extname(input).toLowerCase()}`;
     if(!publishedAssets.has(key)){const target=path.join(out,a.publicPath);await mkdir(path.dirname(target),{recursive:true});await copyFile(input,target);publishedAssets.set(key,a.publicPath);}
    }
    // Reuse the already-curated download instead of publishing source archives.
    if(!meta.publishAttachments&&meta.id==='erp-agent-communication'&&a.id==='asset-node-zip')a.publicPath='downloads/ERP_MCP_NodeJS_Example.zip';
   }
   assets.push(a);
  }
  const downloadDir=`downloads/conversations/${meta.id}`;
  await mkdir(path.join(out,downloadDir),{recursive:true});
  const documents={};
  for(const filename of ['00_README.md','01_PROJECT_CONTEXT.md','02_LEARNING_GUIDE.md',...(meta.supplementDocuments||[])]){
   requireValue(['00_README.md','01_PROJECT_CONTEXT.md','02_LEARNING_GUIDE.md','AI_RESPONSES_FULL.md','MISSING_RESPONSES.md','CHANGELOG.md'].includes(filename),'unsupported conversation document');
   documents[filename]=`${downloadDir}/${filename}`;
   await copyFile(path.join(source,filename),path.join(out,documents[filename]));
  }
  documents['conversation-data.json']=`${downloadDir}/conversation-data.json`;
  await copyFile(path.join(source,'conversation-data.json'),path.join(out,documents['conversation-data.json']));
  const resolveURL=conversationResolver(assets,documents);
  const render=(text,key)=>renderMarkdown(text.replace(/[^]*/g,'[당시 답변의 출처 표기]'),{headingPrefix:`cv-${meta.id}-${key}-`,keepTitle:true,headingOffset:2,resolveURL}).html;
  for(const [episodeId,additions] of Object.entries(meta.episodeMessageAdditions||{})){
   requireValue(raw.episodes.some(e=>e.id===episodeId),`unknown episode extension ${meta.id}/${episodeId}`);
   requireValue(Array.isArray(additions)&&additions.every(id=>messages.some(m=>m.id===id)),`invalid episode messages ${meta.id}/${episodeId}`);
  }
  const episodes=raw.episodes.map(original=>{
   const ids=new Set([...original.message_refs,...(meta.episodeMessageAdditions?.[original.id]||[])]);
   const e={...original,message_refs:messages.filter(m=>ids.has(m.id)).map(m=>m.id)};
   const exercise=e.exercise_markdown.replaceAll('주십시오','주세요').replaceAll('마십시오','마세요');
   const refs=new Set([...e.asset_ids,...messages.filter(m=>e.message_refs.includes(m.id)).flatMap(m=>m.asset_ids)]);
   return {...e,exercise_markdown:exercise,asset_ids:[...refs],isMeta:meta.metaEpisodes.includes(e.id),commentaryHtml:render(e.commentary_markdown,`${e.id}-commentary`),outcomeHtml:render(e.outcome_markdown,`${e.id}-outcome`),exerciseHtml:render(exercise,`${e.id}-exercise`)};
  });
  const displayEdits={...edits,...responseEdits};
  const preparedMessages=messages.map(m=>({...m,...(progressIds.has(m.id)?{delivery_kind:'progress'}:{}),html:render(m.content_markdown,m.id),...(displayEdits[m.id]?{editorial_markdown:displayEdits[m.id].content_markdown,editorialHtml:render(displayEdits[m.id].content_markdown,`${m.id}-editorial`)}:{})}));
  const counts={messages:messages.length,episodes:episodes.length,verbatim:0,excerpt:0,summary:0,reconstructed:0,unavailable:0};
  for(const m of messages)counts[m.content_type]++;
  const context=await readFile(path.join(source,'01_PROJECT_CONTEXT.md'),'utf8');
  projects.push(applyReadingEdition({...meta,title:raw.project_title,coverage:raw.coverage,threads:raw.threads.map(({messages,...t})=>t),messages:preparedMessages,episodes,assets,counts,documents,contextHtml:render(context,'context'),sourcePath:`${sourcePath}/`},reading.projects[meta.id],render));
 }
 const totals=projects.reduce((n,p)=>{for(const [k,v] of Object.entries(p.counts))n[k]=(n[k]||0)+v;return n;},{projects:projects.length});
 for(const [node,[pid,eid]] of Object.entries(config.preferredNodes)){
  const episode=projects.find(p=>p.id===pid)?.episodes.find(e=>e.id===eid);
  requireValue(episode?.map_nodes.includes(node),`invalid preferred episode for ${node}`);
 }
 const readingTotals=projects.reduce((n,p)=>({projects:n.projects+(p.readingCounts.episodes?1:0),episodes:n.episodes+p.readingCounts.episodes,messages:n.messages+p.readingCounts.messages}),{projects:0,episodes:0,messages:0});
 return {asOf:config.asOf,preferredNodes:config.preferredNodes,projects,totals,readingTotals};
}
