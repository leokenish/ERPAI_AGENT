const escapeText=value=>String(value??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
// The complete text stays in the accessibility tree and reserves its final height.
const typedText=(text,kind='body')=>`<span class="slide-type"><span class="slide-type-reserve">${escapeText(text)}</span><span class="slide-type-output" data-present-text data-present-kind="${kind}" aria-hidden="true">${escapeText(text)}</span></span>`;

export function renderPresentation(slides,index=0){
 const n=Math.max(0,Math.min(slides.length-1,Math.floor(Number(index))||0)),s=slides[n];
 return `<div class="presentation" data-presentation>
  <article class="slide" aria-labelledby="slide-title">
   <div class="slide-topline"><span class="slide-number">ERP AI · ${String(n+1).padStart(2,'0')} / ${String(slides.length).padStart(2,'0')}</span><span class="slide-section">${escapeText(s.section)}</span><button class="btn small" data-present-reveal>전체 표시</button></div>
   <header class="slide-heading"><h1 id="slide-title">${typedText(s.title,'title')}</h1><p class="subtitle">${typedText(s.subtitle)}</p></header>
   <div class="slide-body">
    <section class="slide-workflow" aria-labelledby="slide-workflow-title"><h2 class="slide-label" id="slide-workflow-title">실무에서 따라갈 순서</h2><ol class="slide-steps">${s.steps.map((step,i)=>`<li><span class="slide-step-number" aria-hidden="true">${String(i+1).padStart(2,'0')}</span><div><h3>${typedText(step.title)}</h3><p>${typedText(step.text)}</p></div></li>`).join('')}</ol></section>
    <div class="slide-examples"><section class="slide-prompt" aria-labelledby="slide-prompt-title"><h2 class="slide-label" id="slide-prompt-title">따라 할 요청 · 교육용 예시</h2><blockquote>${typedText(s.prompt)}</blockquote></section><section class="slide-field-note" aria-labelledby="slide-case-title"><h2 id="slide-case-title">${typedText(s.fieldNote.title)}</h2><p>${typedText(s.fieldNote.text)}</p></section></div>
   </div>
   <section class="slide-checkpoint" aria-labelledby="slide-checkpoint-title"><div class="slide-check-question"><span class="slide-label">함께 확인하기</span><h2 id="slide-checkpoint-title">${typedText(s.checkpoint.question)}</h2></div><details class="slide-answer"><summary>해설 보기</summary><p>${escapeText(s.checkpoint.answer)}</p></details></section>
   <nav class="slide-related" aria-label="이 발표의 근거와 실습">${s.links.map(link=>`<a class="text-link" href="${escapeText(link.href)}">${escapeText(link.label)} <span aria-hidden="true">↗</span></a>`).join('')}</nav>
  </article>
  <nav class="slide-controls" aria-label="발표 화면 이동"><div class="controls-group"><button class="btn" data-slide="${n-1}" ${n===0?'disabled':''}>← 이전 화면</button><button class="btn primary" data-slide="${n+1}" ${n===slides.length-1?'disabled':''}>다음 화면 →</button></div><div class="slide-dots">${slides.map((slide,i)=>`<a href="#/present/${i}" class="${i===n?'active':''}" aria-label="${i+1}번째 발표 · ${escapeText(slide.title)}" ${i===n?'aria-current="step"':''}></a>`).join('')}</div><div class="controls-group"><a class="btn" href="#/learn/${escapeText(s.lesson)}">관련 교육 읽기</a><a class="btn" href="#/home">발표 종료</a></div></nav>
  <p class="section-note">← → 페이지 이동 · Esc 종료 · 타이핑을 기다리지 않으려면 전체 표시</p>
 </div>`;
}

export function mountPresentation(root,options={}){
 const preference=options.preference||window.matchMedia('(prefers-reduced-motion: reduce)');
 const outputs=[...root.querySelectorAll('[data-present-text]')];
 const lines=outputs.map(el=>Array.from(el.textContent));
 const reveal=root.querySelector('[data-present-reveal]');
 const weights=outputs.map(el=>el.dataset.presentKind==='title'?36:10);
 const totalWeight=lines.reduce((total,line,i)=>total+line.length*weights[i],0);
 // About ten seconds per slide, including pauses; longer text advances in batches.
 const scale=Math.min(1,Math.max(1000,9000-outputs.length*60)/Math.max(1,totalWeight));
 let timer,disposed=false,finished=false,line=0,char=0,credit=0;
 const cancel=()=>{clearTimeout(timer);timer=undefined;};
 function finish(){
  if(disposed||finished)return;
  cancel();finished=true;
  outputs.forEach((el,i)=>{el.textContent=lines[i].join('');el.classList.remove('typing-now');});
  root.classList.remove('is-typing');
  if(reveal)reveal.disabled=true;
 }
 function tick(){
  if(disposed||finished)return;
  if(preference.matches||document.hidden){finish();return;}
  const output=outputs[line];output.classList.add('typing-now');
  credit+=28/(weights[line]*scale);
  const advance=Math.floor(credit);credit-=advance;
  char=Math.min(lines[line].length,char+advance);
  output.textContent=lines[line].slice(0,char).join('');
  if(char===lines[line].length){
   output.classList.remove('typing-now');line++;char=0;credit=0;
   if(line===lines.length){finish();return;}
   timer=setTimeout(tick,60);
  }else timer=setTimeout(tick,28);
 }
 const preferenceChanged=()=>{if(preference.matches)finish();};
 const visibilityChanged=()=>{if(document.hidden)finish();};
 preference.addEventListener('change',preferenceChanged);
 document.addEventListener('visibilitychange',visibilityChanged);
 window.addEventListener('beforeprint',finish);
 reveal?.addEventListener('click',finish);
 if(!outputs.length||preference.matches||document.hidden)finish();
 else{outputs.forEach(el=>{el.textContent='';});root.classList.add('is-typing');timer=setTimeout(tick,180);}
 return ()=>{
  disposed=true;cancel();
  preference.removeEventListener('change',preferenceChanged);
  document.removeEventListener('visibilitychange',visibilityChanged);
  window.removeEventListener('beforeprint',finish);
  reveal?.removeEventListener('click',finish);
 };
}
