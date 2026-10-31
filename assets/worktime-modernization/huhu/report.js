
const snippets=JSON.parse(document.getElementById('code-data').textContent);
let toastTimer;
function toast(message){const el=document.getElementById('toast');el.textContent=message;el.classList.add('visible');clearTimeout(toastTimer);toastTimer=setTimeout(()=>el.classList.remove('visible'),3000);}
function setFilter(value){document.querySelectorAll('.change-card').forEach(el=>{el.hidden=value!=='all'&&el.dataset.source!==value;});document.querySelectorAll('[data-filter]').forEach(btn=>{const active=btn.dataset.filter===value;btn.classList.toggle('active',active);btn.setAttribute('aria-pressed',String(active));});}
document.querySelectorAll('[data-filter]').forEach(btn=>btn.addEventListener('click',()=>setFilter(btn.dataset.filter)));
document.querySelectorAll('[data-nav]').forEach(link=>link.addEventListener('click',()=>setFilter('all')));
async function copyCode(value,button){let ok=false;try{if(navigator.clipboard&&window.isSecureContext){await navigator.clipboard.writeText(value);ok=true;}}catch(e){}
if(!ok){const area=document.createElement('textarea');area.value=value;area.style.cssText='position:fixed;left:0;top:0;opacity:0;width:1px;height:1px';area.setAttribute('readonly','');document.body.appendChild(area);area.focus();area.select();try{ok=document.execCommand('copy');}catch(e){}area.remove();button.focus();}
if(ok){button.textContent='복사 완료';toast('줄번호 없이 코드가 복사되었습니다.');setTimeout(()=>button.textContent='코드 복사',1800);}else{const pane=button.closest('.code-pane').querySelector('.code-scroll');const range=document.createRange();range.selectNodeContents(pane);const selection=window.getSelection();selection.removeAllRanges();selection.addRange(range);toast('자동 복사를 지원하지 않습니다. 코드 영역을 선택했습니다. 줄번호를 제외하고 복사해 주세요.');}}
document.querySelectorAll('[data-copy]').forEach(button=>button.addEventListener('click',()=>{const [id,side]=button.dataset.copy.split(':');return copyCode(snippets[id][side],button);}));
document.getElementById('print').addEventListener('click',()=>{setFilter('all');window.print();});
