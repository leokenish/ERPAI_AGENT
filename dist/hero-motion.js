// The illustration loops in CSS. This module owns only the one-time title.
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
  if (disposed || finished) return;
  if (preference.matches || document.hidden) { finish(); return; }
  outputs.forEach(el => el.classList.remove('typing-now'));
  const current=outputs[line];
  current.classList.add('typing-now');
  current.textContent=lines[line].slice(0,++char).join('');
  if (char===lines[line].length) {
   if (line===lines.length-1) { timer=setTimeout(finish,260); return; }
   line++; char=0; timer=setTimeout(typeNext,240);
  } else timer=setTimeout(typeNext,78);
 }
 const preferenceChanged=()=>{if(preference.matches)finish();};
 const visibilityChanged=()=>{if(document.hidden)finish();};
 preference.addEventListener('change',preferenceChanged);
 document.addEventListener('visibilitychange',visibilityChanged);
 if (!outputs.length || options.alreadyTyped || preference.matches || document.hidden) finish();
 else { outputs.forEach(el=>{el.textContent='';}); timer=setTimeout(typeNext,350); }
 return ()=>{
  disposed=true; cancel();
  preference.removeEventListener('change',preferenceChanged);
  document.removeEventListener('visibilitychange',visibilityChanged);
 };
}
