// The illustration loops in CSS. Replay the title on each home mount.
export function mountHeroMotion(root, options = {}) {
 const preference = options.preference || window.matchMedia('(prefers-reduced-motion: reduce)');
 const outputs = [...root.querySelectorAll('[data-type-output]')];
 const lines = outputs.map(el => Array.from(el.dataset.text));
 let timer, disposed = false, finished = false, line = 0, char = 0;
 const cancel = () => { clearTimeout(timer); timer = undefined; };
 function finish() {
  cancel();
  outputs.forEach((el,i) => { el.textContent=lines[i].join(''); el.classList.remove('typing-now'); });
  if (!finished) { finished=true; options.onTyped?.(); }
 }
 function typeNext() {
  cancel();
  if (disposed || finished) return;
  if (preference.matches) { finish(); return; }
  if (document.hidden) return;
  if (line===lines.length) { finish(); return; }
  outputs.forEach(el => el.classList.remove('typing-now'));
  const current=outputs[line];
  current.classList.add('typing-now');
  current.textContent=lines[line].slice(0,++char).join('');
  if (char===lines[line].length) {
   if (line===lines.length-1) { line++; timer=setTimeout(typeNext,260); return; }
   line++; char=0; timer=setTimeout(typeNext,240);
  } else timer=setTimeout(typeNext,78);
 }
 const preferenceChanged=()=>{if(preference.matches)finish();};
 const visibilityChanged=()=>{
  cancel();
  if (!document.hidden && !finished && !disposed) timer=setTimeout(typeNext,150);
 };
 preference.addEventListener('change',preferenceChanged);
 document.addEventListener('visibilitychange',visibilityChanged);
 if (!outputs.length || preference.matches) finish();
 else { outputs.forEach(el=>{el.textContent='';}); if(!document.hidden)timer=setTimeout(typeNext,350); }
 return ()=>{
  disposed=true; cancel();
  preference.removeEventListener('change',preferenceChanged);
  document.removeEventListener('visibilitychange',visibilityChanged);
 };
}
