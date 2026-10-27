const escapeSourceText=value=>String(value??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));

export function renderSourceDocuments(source){
 const esc=escapeSourceText,documents=[...(source.mdDocuments||[])];
 const featured=source.projectDocuments||[];
 documents.sort((a,b)=>{const x=featured.indexOf(a.path),y=featured.indexOf(b.path);return (x<0?featured.length:x)-(y<0?featured.length:y);});
 return `<section class="source-documents" data-source-documents>
  <div class="eyebrow">자료확인</div>
  <h1 id="source-documents-title">${esc(source.title)}</h1>
  <div class="source-document-toolbar"><span>MD ${documents.length}개</span>${documents.length?`<a class="btn primary" href="${esc(source.mdArchive)}" download="${esc(source.id)}_MD.zip">전체 MD 다운로드 · ZIP</a>`:''}</div>
  <label class="source-document-search">파일 찾기<input type="search" data-source-search placeholder="프로젝트, 용도, 파일명 또는 경로" autocomplete="off"></label>
  <p class="source-document-count" data-source-result role="status">${documents.length}개 파일</p>
  <ul class="source-document-list">${documents.map(d=>`<li data-source-file="${esc([d.path,d.project,d.purpose,d.title].join(' ').toLocaleLowerCase())}"><div><strong>${esc(d.title||d.name)}</strong>${d.project?`<span class="source-document-project">${esc(d.project)}</span>`:''}${d.purpose?`<p class="source-document-purpose">${esc(d.purpose)}</p>`:''}${featured.includes(d.path)?'<span class="source-document-kind">프로젝트 MD</span>':''}<span class="source-document-path">${esc(d.path)}</span></div><a class="btn small" href="${esc(d.download)}" download="${esc(d.name)}" aria-label="${esc(d.path)} 다운로드">다운로드</a></li>`).join('')}</ul>
  <p class="source-document-empty" data-source-empty ${documents.length?'hidden':''}>표시할 MD 파일이 없다.</p>
 </section>`;
}

export function filterSourceDocuments(root,query){
 const terms=String(query).trim().toLocaleLowerCase().split(/\s+/).filter(Boolean);
 let visible=0;
 for(const row of root.querySelectorAll('[data-source-file]')){
  row.hidden=!terms.every(term=>row.dataset.sourceFile.includes(term));
  if(!row.hidden)visible++;
 }
 root.querySelector('[data-source-result]').textContent=`${visible}개 파일`;
 root.querySelector('[data-source-empty]').hidden=visible!==0;
}
