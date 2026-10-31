
const data=JSON.parse(document.querySelector('#comparison-data').textContent);document.querySelector('#toggle').onclick=()=>document.body.classList.toggle('same-hidden');document.querySelectorAll('.copy').forEach(b=>b.onclick=async()=>{const t=data.find(d=>d.key===b.dataset.key)[b.dataset.side];try{await navigator.clipboard.writeText(t);b.textContent='복사됨'}catch(e){document.querySelector('#copytext').value=t;document.querySelector('#copydialog').showModal();document.querySelector('#copytext').select()}});
document.querySelector('[data-report-event="0"]').addEventListener("click", function(event){window.print();});
document.querySelector('[data-report-event="1"]').addEventListener("click", function(event){document.querySelector('#copydialog').close();});
