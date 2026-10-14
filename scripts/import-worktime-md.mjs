// Import only committed Markdown from a local ERP_AI clone. No network or push.
import {execFileSync} from 'node:child_process';
import {mkdir,readFile,writeFile,access} from 'node:fs/promises';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
import {createHash} from 'node:crypto';
const root=path.resolve(path.dirname(fileURLToPath(import.meta.url)),'..');
const clone=process.argv[2];if(!clone){console.error('Usage: npm run knowledge:import -- /absolute/path/to/ERP_AI [commit]');process.exit(1);}
const git=(...args)=>execFileSync('git',['-C',path.resolve(clone),...args],{maxBuffer:32*1024*1024});
const requested=process.argv[3]||'HEAD';if(!/^(HEAD|[a-f\d]{40})$/.test(requested))throw Error('Use HEAD or a full commit SHA');
const commit=git('rev-parse','--verify',requested+'^{commit}').toString().trim();
const entries=git('ls-tree','-rz','--full-tree',commit).toString('utf8').split('\0').filter(Boolean).map(row=>{const [meta,p]=row.split('\t');const [mode,type,sha]=meta.split(' ');return {mode,type,sha,path:p};}).filter(f=>f.type==='blob'&&/\.md$/i.test(f.path));
if(!entries.some(f=>f.path==='maps/INDEX.md')||!entries.some(f=>f.path==='knowledge/INDEX.md'))throw Error('Expected ERP_AI Markdown structure not found');
const relative='sources/github-erp-ai/'+commit.slice(0,12),dest=path.join(root,relative);
try{await access(dest);throw Error('Snapshot already exists. Existing source files are immutable; select another commit.');}catch(e){if(e.code!=='ENOENT')throw e;}
const files=[];for(const f of entries){if(f.path.split('/').includes('..')||path.isAbsolute(f.path))throw Error('Unsafe path');const bytes=git('show',commit+':'+f.path);const p=path.join(dest,f.path);await mkdir(path.dirname(p),{recursive:true});await writeFile(p,bytes);files.push({path:f.path,sha:f.sha,size:bytes.length});}
const asOf=new Intl.DateTimeFormat('en-CA',{timeZone:'Asia/Seoul',year:'numeric',month:'2-digit',day:'2-digit'}).format(new Date());
const snapshot={repository:'leokenish/ERP_AI',commit,retrievedAt:asOf,dateTimezone:'Asia/Seoul',scope:'Markdown only',files};
await writeFile(path.join(dest,'snapshot.json'),JSON.stringify(snapshot,null,2)+'\n');
const hash=b=>createHash('sha256').update(b).digest('hex');
const registerPath=path.join(root,'docs/source-files.json'),register=JSON.parse(await readFile(registerPath,'utf8'));
for(const name of [...files.map(f=>f.path),'snapshot.json'])register.push({path:relative+'/'+name,sha256:hash(await readFile(path.join(dest,name)))});
await writeFile(registerPath,JSON.stringify(register,null,2)+'\n');
const configPath=path.join(root,'content/worktime-knowledge.json'),config=JSON.parse(await readFile(configPath,'utf8'));config.snapshot=relative;await writeFile(configPath,JSON.stringify(config,null,2)+'\n');
const catPath=path.join(root,'content/catalog.json'),catalog=JSON.parse(await readFile(catPath,'utf8'));const source=catalog.sources.find(s=>s.id==='worktime-agent');Object.assign(source,{version:'GitHub snapshot · '+commit.slice(0,12),mdCount:files.length,fileCount:files.length,path:relative+'/',archive:'ERP_AI_Markdown_'+commit.slice(0,12)+'.zip',sha256:'',summary:`${files.length}개 MD의 폴더 역할과 문서 링크를 교육용 지도로 정리했습니다.`,findings:['새 스냅샷을 반영했습니다. 교육 설명·읽기 경로·확인 상태의 재검토가 필요합니다.','MD만 수집. 소스 코드·SAP 운영 결과는 재검증하지 않았습니다.']});
catalog.lessons.find(l=>l.id==='worktime-agent').asOf=asOf;await writeFile(catPath,JSON.stringify(catalog,null,2)+'\n');
console.log(`Imported ${files.length} committed MD files from ${commit}. Review course text, walkthrough, source findings and date; then build, test and preview:file.`);
