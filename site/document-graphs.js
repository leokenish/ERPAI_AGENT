// Small lesson diagrams share the published MD download links, including offline URLs.
export function mountDocumentGraphs(root){
 const cleanups=[];
 for(const graph of root.querySelectorAll('[data-document-graph]')){
  const cards=[...graph.querySelectorAll('[data-graph-card]')];
  const edges=[...graph.querySelectorAll('[data-graph-from]')];
  const buttons=cards.map(card=>card.querySelector('[data-graph-select]'));
  const panels=[...graph.querySelectorAll('[data-graph-detail]')];
  const status=graph.querySelector('[data-graph-status]');
  function select(value){
   const selected=value===null?null:String(value);
   if(selected!==null&&!cards.some(c=>c.dataset.graphCard===selected))return;
   const neighbors=new Set(selected===null?[]:[selected]);
   for(const line of edges){
    const active=selected!==null&&(line.dataset.graphFrom===selected||line.dataset.graphTo===selected);
    if(active){neighbors.add(line.dataset.graphFrom);neighbors.add(line.dataset.graphTo);}
    line.classList.toggle('is-connected',active);
    line.classList.toggle('is-muted',selected!==null&&!active);
   }
   for(const card of cards){
    const active=card.dataset.graphCard===selected;
    card.classList.toggle('is-selected',active);
    card.classList.toggle('is-muted',selected!==null&&!neighbors.has(card.dataset.graphCard));
    card.querySelector('button').setAttribute('aria-pressed',String(active));
   }
   for(const panel of panels)panel.hidden=panel.dataset.graphDetail!==selected;
   status.textContent=selected===null?'전체 문서의 연결을 표시합니다.':`${cards.find(c=>c.dataset.graphCard===selected).querySelector('.document-graph-download').textContent} · 연결 문서 ${neighbors.size-1}개`;
  }
  function click(event){
   const target=event.target.closest('[data-graph-select],[data-graph-reset]');
   if(target){
    const related=target.closest?.('.document-graph-detail');
    select(target.hasAttribute('data-graph-reset')?null:target.dataset.graphSelect);
    if(related)buttons.find(b=>b.dataset.graphSelect===target.dataset.graphSelect)?.focus({preventScroll:true});
    return;
   }
   if(event.target.closest('.document-graph-stage')&&!event.target.closest('.document-graph-node'))select(null);
  }
  function keydown(event){
   if(event.key==='Escape'){select(null);return;}
   const at=buttons.indexOf(event.target);
   if(at<0||!['ArrowRight','ArrowDown','ArrowLeft','ArrowUp','Home','End'].includes(event.key))return;
   event.preventDefault();
   const next=event.key==='Home'?0:event.key==='End'?buttons.length-1:(at+(['ArrowRight','ArrowDown'].includes(event.key)?1:-1)+buttons.length)%buttons.length;
   buttons[next].focus();select(buttons[next].dataset.graphSelect);
  }
  graph.addEventListener('click',click);graph.addEventListener('keydown',keydown);
  select(0);
  cleanups.push(()=>{graph.removeEventListener('click',click);graph.removeEventListener('keydown',keydown);});
 }
 return ()=>cleanups.forEach(cleanup=>cleanup());
}
