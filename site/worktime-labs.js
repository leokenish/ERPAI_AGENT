const escape = x => String(x).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const money = n => new Intl.NumberFormat('ko-KR').format(n)+'원';
export function rateCheck(amount, group='regular', month='09') {
 const oldRate=group==='regular'?8400:5400,newRate=group==='e8'?5400:9240;
 const oldUnit=oldRate/4,newUnit=newRate/4,oldOK=amount>0&&amount%oldUnit===0,newOK=amount>0&&amount%newUnit===0;
 const correct=month==='08'?oldOK:newOK;
 const status=oldRate===newRate?(correct?'유지 단가 배수 일치':'배수 불일치'):oldOK&&newOK?'양쪽 배수 일치 · 단가 판별 불가':correct?'기준월 단가 배수 일치':month==='09'&&oldOK?'구단가 적용 의심':month==='08'&&newOK?'8월 건 신단가 적용 의심':'배수 불일치';
 return {oldRate,newRate,oldUnit,newUnit,oldOK,newOK,status,estimate:month==='09'&&oldOK&&!newOK?Math.round(amount*newRate/oldRate):month==='08'&&newOK&&!oldOK?Math.round(amount*oldRate/newRate):null};
}
export function retroTotal(rows) {return rows.reduce((sum,row)=>sum+row.now-row.fixed,0);}
export function deleteDecision(kind,closed,settled,voucher=false) {return kind==='cancel'?(!closed&&!settled?'기간·실적 2종 취소 조건 충족':'처리 중단 · 마감 또는 정산 이력 존재'):(closed&&settled&&!voucher?'8050 지급 항목 제외 조건 충족':'처리 중단 · 마감·정산·전표 조건 확인');}
const cards = items => `<div class="wt-card-grid">${items.map(([label,value,note])=>`<div class="wt-number-card"><span>${label}</span><strong>${value}</strong><small>${note}</small></div>`).join('')}</div>`;
const flow=items=>`<ol class="wt-flow">${items.map(x=>`<li>${x}</li>`).join('')}</ol>`;
export function renderWorktimeLab(key) {
 let body='';
 if(key==='huhu')body=`<p>토요일 6시간과 일요일 2시간을 일한 예시입니다. 시간당 단가를 10,000원으로 가정합니다.</p><div class="wt-timeline"><div><strong>토요일 · 6시간</strong><span>대휴 발생일</span><b>0.5배 · 30,000원</b></div><div><strong>일요일 · 2시간</strong><span>휴일 근무 실비</span><b>1.5배 · 30,000원</b></div></div>${cards([['최초 실비','60,000원','토요일 30,000 + 일요일 30,000'],['대휴 추가 정산','60,000원','토요일 발생분 30,000 × 2'],['전체 실비를 두 배로 계산','120,000원','일요일분까지 포함한 잘못된 계산']])}<p><strong>이 예시에서는 같은 신청의 금액이라도 대휴 발생일에 해당하는 부분만 따로 찾아야 합니다.</strong></p><details><summary>왜 저장 경로까지 확인할까요?</summary>${flow(['시간 구간 계산','날짜별 임시 금액','신청 저장 시 금액 복사','반기 정산'])}<p>계산식이 맞아도 임시 금액을 잘못 합치거나 이전 값이 남으면 저장 결과가 달라집니다. 이번 검토는 최초 입력·저장 구간의 F03와 SAVE를 대상으로 했습니다.</p></details>`;
 if(key==='rate')body=`<p>금액과 직원 구분을 바꾸면 단가 검사 결과를 비교할 수 있습니다. 인정시간이 0.5시간 단위라는 전제의 <strong>이상 후보 선별</strong>입니다.</p><div class="wt-controls"><label>직원 구분<select data-wt-group><option value="regular">일반 · 8,400 → 9,240원</option><option value="special">E1·E4·E5·E6·E7 · 5,400 → 9,240원</option><option value="e8">E8 · 5,400원 유지</option></select></label><label>근무 시작월<select data-wt-month><option value="09">9월</option><option value="08">8월</option></select></label><label>대휴 실비 금액<input data-wt-amount type="number" min="0" step="1" value="33600"></label></div><div class="wt-presets"><button data-wt-preset="33600">33,600원</button><button data-wt-preset="23100">23,100원</button><button data-wt-preset="36960">36,960원</button></div><div data-wt-result aria-live="polite"></div><p class="wt-note">8월 31일에 시작한 익일 근무는 8월 기준입니다. 배수 일치는 지급액 전체의 정확성을 확정하지 않습니다. 환산액은 수정·지급액이 아닌 검토용 추정치입니다.</p>`;
 if(key==='compare')body=`${flow(['정산 당시 금액','현재 실적 재계산','금액·시간·대휴 비교','차이의 원인 분리'])}${cards([['비교 대상','143명','업로드한 정산 비교 결과'],['금액 차이','122명','차이 자체가 실적 오류를 뜻하지 않습니다'],['같은 대휴 내역','143명','개수·시간·저장금액·발생일 비교 동일']])}<div class="wt-split"><div><h4>정산 당시</h4><p>9월 단가 인상분을 인사부가 수기로 반영했습니다.</p><strong>수기보정 포함</strong></div><div><h4>비교 프로그램의 재계산</h4><p>기간 시작일 단가를 사용하고 수기보정을 재현하지 않았습니다.</p><strong>계산 기준 차이 발생</strong></div></div><p>따라서 실적이 그대로여도 금액은 달라질 수 있습니다. 논의한 개선 방향은 <strong>시간 계산을 유지하고 입력별 시작일 단가를 적용</strong>하는 것입니다. 자정마다 단가를 나누는 제안은 최종 기준에서 제외했습니다.</p>`;
 if(key==='retro')body=`<p>아래 값은 차액 구조를 설명하기 위한 교육용 예시입니다. 과거 확정액과 재계산액을 바꿔 보세요.</p><div class="table-wrap"><table><thead><tr><th>변경된 월</th><th>과거 확정액</th><th>재계산액</th><th>차액</th></tr></thead><tbody><tr><th>2월</th><td><input aria-label="2월 확정액" data-wt-fixed="0" type="number" value="100000" step="1000"></td><td><input aria-label="2월 재계산액" data-wt-now="0" type="number" value="120000" step="1000"></td><td data-wt-diff="0"></td></tr><tr><th>5월</th><td><input aria-label="5월 확정액" data-wt-fixed="1" type="number" value="200000" step="1000"></td><td><input aria-label="5월 재계산액" data-wt-now="1" type="number" value="190000" step="1000"></td><td data-wt-diff="1"></td></tr></tbody></table></div><div data-wt-result aria-live="polite"></div><p>선택한 소급 범위에 두 달이 포함되면 +20,000원과 −10,000원이 함께 계산됩니다. 과거 상세내역을 먼저 펼쳐 보이면 현재 지급액만 보고 차액을 추측할 필요가 줄어듭니다.</p>`;
 if(key==='retired'||key==='cancel'){
 const cancel=key==='cancel';body=`<div class="wt-split"><div><h4>이번에 ${cancel?'취소':'제외'}하는 자료</h4><strong>${cancel?'선택기간 + 실적':'8050 지급 항목'}</strong><p>${cancel?'ZTHR0132 · ZTHR0112':'PA2010 중 해당 사번·정산월의 연결 항목'}</p></div><div><h4>보존하는 자료</h4><strong>${cancel?'인사 등록원장':'기간 · 실적 · 정산결과'}</strong><p>${cancel?'PA9021을 유지합니다. 대휴 자료도 삭제 범위에서 제외합니다.':'퇴직자 제한을 해제해도 다른 지급 항목까지 삭제하지 않습니다.'}</p></div></div><div class="wt-controls"><label><input type="checkbox" data-wt-closed ${cancel?'':'checked'}> 해당 월 마감</label><label><input type="checkbox" data-wt-settled ${cancel?'':'checked'}> 정산 이력</label>${cancel?'':'<label><input type="checkbox" data-wt-voucher> 전표 참조 존재</label>'}</div><div data-wt-result aria-live="polite"></div><p class="wt-note">처리 조건을 이해하기 위한 모의 화면입니다. 실제 프로그램은 권한, 대상 키, 잠금 및 실행 직전 재조회도 검사합니다.</p>${flow(['대상 한정','조건 검사','건수 확인','잠금·재조회','모두 성공 시 한 번 저장'])}`;
 }
 if(key==='halfday')body=`<p>2026년 9월 1일 이후 시간외 단가 9,240원 대상인 통상근무자의 오전 반일 사례입니다. 정상 근무 시작은 09:00, 종료 입력은 22:30이며 휴게는 18:00~19:00입니다.</p><div class="wt-timeline"><div><strong>09:00~13:00</strong><span>승인된 오전 반일</span></div><div><strong>13:00~18:00</strong><span>실제 근무</span></div><div><strong>18:00~19:00</strong><span>휴게</span></div><div><strong>19:00~22:30</strong><span>추가 근무</span></div></div>${cards([['정상 시작시각부터 입력','43,890원','09:00~22:30 입력'],['실제 출근시각부터 입력','6,930원','13:00~22:30 입력']])}<p><strong>해당 입력 방식에서는 전체 구간을 입력하고, 승인된 반일을 별도로 반영합니다.</strong> 따라서 계산식 수정에 앞서 입력 기준을 안내합니다. 최종 코드는 기존 근태 검사의 정보 안내 전달 경로에 I95/TEXT-E95를 추가하고, 해당일 원래 출근시각부터 입력하도록 안내합니다.</p>`;
 return `<section class="worktime-lab" data-worktime-lab="${escape(key)}" aria-label="업무 원리 시각자료"><div class="eyebrow">업무 원리 살펴보기</div>${body}</section>`;
}
export function mountWorktimeLabs(root) {
 const listeners=[];
 for(const el of root.querySelectorAll('[data-worktime-lab]')){
  const key=el.dataset.worktimeLab;
  const update=()=>{
   const out=el.querySelector('[data-wt-result]');if(!out)return;
   if(key==='rate'){
    const value=Number(el.querySelector('[data-wt-amount]').value);
    if(!Number.isSafeInteger(value)||value<0){out.textContent='0 이상의 원 단위 정수를 입력해 주세요.';return;}
    const r=rateCheck(value,el.querySelector('[data-wt-group]').value,el.querySelector('[data-wt-month]').value);
    out.innerHTML=cards([['8월 검사단위',money(r.oldUnit),r.oldOK?'배수 일치':'배수 불일치'],['9월 검사단위',money(r.newUnit),r.newOK?'배수 일치':'배수 불일치']])+`<p class="wt-verdict"><strong>${r.status}</strong>${r.estimate===null?'':`<br>기준월 단가 환산 추정 ${money(r.estimate)} · 추정 차액 ${money(r.estimate-value)}`}</p>`;
   }else if(key==='retro'){
    const rows=[0,1].map(i=>({fixed:Number(el.querySelector(`[data-wt-fixed="${i}"]`).value),now:Number(el.querySelector(`[data-wt-now="${i}"]`).value)}));
    if(rows.some(r=>!Number.isFinite(r.fixed)||!Number.isFinite(r.now))){out.textContent='금액을 숫자로 입력해 주세요.';return;}
    rows.forEach((r,i)=>el.querySelector(`[data-wt-diff="${i}"]`).textContent=money(r.now-r.fixed));
    out.innerHTML=`<p class="wt-verdict">범위에 포함된 두 달의 소급 차액 합계 <strong>${money(retroTotal(rows))}</strong></p>`;
   }else out.innerHTML=`<p class="wt-verdict"><strong>${deleteDecision(key,el.querySelector('[data-wt-closed]').checked,el.querySelector('[data-wt-settled]').checked,el.querySelector('[data-wt-voucher]')?.checked)}</strong></p>`;
  };
  const click=e=>{const b=e.target.closest('[data-wt-preset]');if(b){el.querySelector('[data-wt-amount]').value=b.dataset.wtPreset;update();}};
  el.addEventListener('input',update);el.addEventListener('click',click);listeners.push(()=>{el.removeEventListener('input',update);el.removeEventListener('click',click);});update();
 }
 return ()=>listeners.forEach(fn=>fn());
}
