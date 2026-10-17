const formatCount = (value, digits) => value.toLocaleString('ko-KR', {minimumIntegerDigits: digits});

// Render the final value for assistive technology and reserve its width.
export function countNumber(value, minDigits = 1) {
 const target = Number(value);
 if (!Number.isSafeInteger(target) || target < 0) throw new TypeError('Invalid statistic');
 const digits = Math.max(1, Math.min(12, Number(minDigits) || 1));
 const final = formatCount(target, digits);
 return `<span class="count-up" data-count-to="${target}" data-count-digits="${digits}"><span class="count-up-accessible">${final}</span><span class="count-up-width" aria-hidden="true">${final}</span><span class="count-up-value" aria-hidden="true">${final}</span></span>`;
}

// One shared RAF loop per page; each statistic starts on first visibility.
export function mountCountUps(root) {
 const items = [...root.querySelectorAll('[data-count-to]')].map(el => ({
  el, output: el.querySelector('.count-up-value'), target: Number(el.dataset.countTo),
  digits: Number(el.dataset.countDigits) || 1, elapsed: 0, started: false, done: false
 })).filter(item => item.output && Number.isSafeInteger(item.target) && item.target >= 0);
 if (!items.length) return () => {};
 const preference = window.matchMedia('(prefers-reduced-motion: reduce)');
 const duration = 1600;
 let frame = null, lastTime = null, observer, disposed = false;
 const paint = (item, value) => { item.output.textContent = formatCount(value, item.digits); };
 const cancel = () => { if (frame !== null) cancelAnimationFrame(frame); frame = null; lastTime = null; };
 function finish() {
  cancel(); observer?.disconnect();
  for (const item of items) { paint(item, item.target); item.done = true; }
 }
 function schedule() {
  if (!disposed && !document.hidden && frame === null && items.some(item => item.started && !item.done)) frame = requestAnimationFrame(tick);
 }
 function tick(now) {
  frame = null;
  if (disposed || document.hidden) { lastTime = null; return; }
  if (preference.matches) { finish(); return; }
  const delta = lastTime === null ? 0 : Math.max(0, now - lastTime);
  lastTime = now;
  for (const item of items) {
   if (!item.started || item.done) continue;
   item.elapsed = Math.min(duration, item.elapsed + delta);
   const progress = item.elapsed / duration;
   // Ease out: larger steps first, then smaller ones; never exceed the total.
   paint(item, progress === 1 ? item.target : Math.floor(item.target * (1 - (1 - progress) ** 3)));
   item.done = progress === 1;
  }
  schedule();
  if (frame === null) lastTime = null;
 }
 function start(item) {
  if (item.started || item.done || disposed) return;
  item.started = true; paint(item, 0); observer?.unobserve(item.el); schedule();
 }
 const preferenceChanged = () => { if (preference.matches) finish(); };
 const visibilityChanged = () => { cancel(); if (!document.hidden) schedule(); };
 preference.addEventListener('change', preferenceChanged);
 document.addEventListener('visibilitychange', visibilityChanged);
 window.addEventListener('beforeprint', finish);
 if (preference.matches) finish();
 else if (typeof IntersectionObserver === 'function') {
  observer = new IntersectionObserver(entries => {
   for (const entry of entries) if (entry.isIntersecting) start(items.find(item => item.el === entry.target));
  }, {threshold: 0.25});
  for (const item of items) observer.observe(item.el);
 } else items.forEach(start);
 return () => {
  disposed = true; finish();
  preference.removeEventListener('change', preferenceChanged);
  document.removeEventListener('visibilitychange', visibilityChanged);
  window.removeEventListener('beforeprint', finish);
 };
}
