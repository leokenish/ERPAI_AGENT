import {readFile,mkdir,writeFile} from 'node:fs/promises';
import path from 'node:path';
import {createHash} from 'node:crypto';
import {makeZip} from './build-knowledge.mjs';
import {buildSourceDocuments} from './build-source-documents.mjs';
export async function buildCoreDocuments(root,out,sources){
 const index=JSON.parse(await readFile(path.join(root,'content/core-documents.json'),'utf8'));
 const extra={id:'portal',title:'ERP AI 에이전트 포털 구축',path:'sources/project-progress/publishing/20261026'};
 await buildSourceDocuments(root,out,[extra]);
 const all=[...sources,extra],selected=[];
 for(const entry of index.documents){
  const s=all.find(s=>s.id===entry.sourceId),d=s?.mdDocuments.find(d=>d.path===entry.path);
  if(!d||d.sha256!==entry.sha256)throw Error('Core MD evidence mismatch: '+entry.sourceId+'/'+entry.path);
  selected.push({...d,...entry,project:s.title});
 }
 const purposes={intent:'프로젝트의 목적, 대상 사용자와 지켜야 할 범위를 정리합니다. 후속 요구의 우선순위를 판단할 때 사용합니다.',spec:'요구사항과 산출물의 경계, 확인해야 할 동작을 정리합니다. 구현 검토와 수용 기준 확인에 사용합니다.',plan:'현재 근거와 다음 작업을 정리합니다. 후속 담당자가 확인된 상태에서 작업을 이어갈 때 사용합니다.',insight:'프로젝트의 존재 이유와 가치를 비판적으로 성찰합니다. 사용자·동료·조직이 얻을 수 있는 관점과 아직 입증하지 못한 가치를 함께 살펴봅니다.'};
 for(const s of all)for(const d of s.mdDocuments){
  const k=d.name.replace(/\.md$/i,'').toLowerCase();
  if(purposes[k]&&!selected.some(x=>x.sourceId===s.id&&x.path===d.path))selected.push({...d,sourceId:s.id,project:s.title,categories:['progress'],purpose:purposes[k]+' 포털 자료를 근거로 2026-10-26 새로 작성한 정리 초안입니다.'});
 }
 const groups=[['skills','스킬','업무를 수행하는 절차와 스킬별 참고 문서'],['harness','하네스','에이전트의 작업 지침, 실행 환경과 평가·회귀 기준'],['feedback','피드백','업무 지식, 정정 기록, Q&A와 용어집'],['maps','업무지도','업무와 근거를 찾아가는 Obsidian 색인·연결 문서'],['progress','프로젝트 진행','프로젝트별 intent · spec · plan · insight']];
 const result=[];
 for(const [id,title,description] of groups){
  const docs=selected.filter(d=>d.categories.includes(id)),archive=`downloads/core-md/${id}.zip`;
  const entries=[];for(const d of docs)entries.push({name:d.sourceId+'/'+d.path,bytes:await readFile(path.join(out,d.download))});
  await mkdir(path.join(out,'downloads/core-md'),{recursive:true});await writeFile(path.join(out,archive),makeZip(entries));
  result.push({id:'core-'+id,title,description,mdDocuments:docs,mdArchive:archive,mdCount:docs.length});
 }
 return result;
}
