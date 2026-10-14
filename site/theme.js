// Blocking, tiny head script: apply the saved choice before the stylesheet paints.
// No inline style or external dependency; works with the server's existing CSP.
(() => {
 const key='erp-ai-theme-v1';
 const valid=value=>value==='dark'||value==='light';
 let current='light';
 let transitionTimer;
 try { const saved=localStorage.getItem(key); if(valid(saved))current=saved; } catch {}
 function apply(value,animate=false) {
  const next=valid(value)?value:'light';
  if(animate&&next!==current){
   document.documentElement.dataset.themeMotion='on';
   window.clearTimeout(transitionTimer);
   transitionTimer=window.setTimeout(()=>{delete document.documentElement.dataset.themeMotion;},550);
  }
  current=next;
  document.documentElement.dataset.theme=current;
  document.querySelector('meta[name="theme-color"]')?.setAttribute('content',current==='dark'?'#111722':'#ffffff');
  document.querySelectorAll('[data-theme-choice]').forEach(button=>{
   button.setAttribute('aria-pressed',String(button.dataset.themeChoice===current));
  });
 }
 apply(current);
 function mount() {
  apply(current);
  document.querySelectorAll('[data-theme-choice]').forEach(button=>{
   button.addEventListener('click',()=>{
    const value=button.dataset.themeChoice;
    if(!valid(value))return;
    apply(value,true);
    try { localStorage.setItem(key,value); } catch {}
   });
  });
 }
 if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',mount,{once:true});
 else mount();
 window.addEventListener('storage',event=>{
  if(event.key===key||event.key===null)apply(event.newValue,true);
 });
})();
