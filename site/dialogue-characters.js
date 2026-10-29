// Presentation only: fictional actors never replace the recorded author/role.
const encode = value => String(value ?? '').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
export const characterNames = {na:'최팀장',woo:'우대리',lee:'이과장',oh:'오사원',ai:'AI 에이전트'};
export const emotionNames = {neutral:'차분한',smile:'웃는',concerned:'당황한',tired:'피곤한',confident:'매력적인',warm:'사랑스러운'};
export function characterFor(seed) {
 let value=2166136261;
 for(const c of String(seed))value=Math.imul(value^c.charCodeAt(0),16777619)>>>0;
 return ['na','woo','lee','oh'][value%4];
}
export function expressionFor(text,role='user') {
 const value=String(text).replace(/```[\s\S]*?```/g,'').slice(0,1800);
 if(/피곤|지쳤|밤새|야근|힘드|힘들|ㅠㅠ/.test(value))return 'tired';
 if(/오류|(?<![0-9,])0원|잘못|다르|다른 이유|누락|안[ ]?되|문제|실패|수정 전|당황/.test(value))return 'concerned';
 if(/감사|고마|다행|좋아|잘됐|잘 됐|완료|해결했/.test(value))return 'smile';
 if(/함께|도와|차근|천천히/.test(value))return 'warm';
 if(/자신 있|확신|제가 맡|책임지고|해낼/.test(value))return 'confident';
 return role==='assistant'?'confident':'neutral';
}
export function avatarHTML(actor,emotion='neutral') {
 if(!Object.hasOwn(characterNames,actor))actor='oh';
 if(actor==='ai')return `<span class="character-portrait portrait-chatgpt" role="img" aria-label="ChatGPT 로고" data-character="ai"><img src="assets/characters/chatgpt-logo.svg" alt="" loading="lazy" decoding="async"></span>`;
 if(!Object.hasOwn(emotionNames,emotion))emotion='neutral';
 return `<span class="character-portrait portrait-${actor} expression-${emotion}" role="img" aria-label="${characterNames[actor]} · ${emotionNames[emotion]} 표정" data-character="${actor}" data-emotion="${emotion}"><img src="assets/characters/${actor}-expressions.png" alt="" loading="lazy" decoding="async"></span>`;
}
export function storyMessageHTML({actor='oh',emotion='neutral',label='',body='',time='',source='',kind='human'}) {
 return `<article class="story-message story-${kind}">${avatarHTML(actor,emotion)}<div class="story-message-main"><div class="story-meta"><strong>${characterNames[actor]||characterNames.oh}</strong>${label?`<span>${encode(label)}</span>`:''}${time?`<time>${encode(time)}</time>`:''}</div><div class="story-bubble">${body}</div>${source?`<small class="story-source">${encode(source)}</small>`:''}</div></article>`;
}

// Fictional presentation only. Never mutate transcripts or protected code/quotes.
export function characterExpression(actor,recipient,text,seed='') {
 if(actor==='ai')return 'neutral';
 // Select emotion from the actual turn; hierarchy must not mask distress.
 return expressionFor(text);
}
function toneSegment(text,actor,recipient='ai',previous='') {
 if(actor==='ai')return String(text);
 const casual=recipient==='ai'&&(actor==='na'||actor==='lee');
 let out=String(text);
 const pairs=casual?[
 ['해 주시겠어요','해'],['해 주실 수 있나요','해'],['해 주세요','해'],['해주세요','해'],['해 주십시오','해'],['해주십시오','해'],
 ['알려 주세요','알려줘'],['알려주세요','알려줘'],['보여 주세요','보여줘'],['보여주세요','보여줘'],['만들어 주세요','만들어줘'],['만들어주세요','만들어줘'],['넣어 주세요','넣어줘'],['넣어주세요','넣어줘'],['바꿔 주세요','바꿔줘'],['바꿔주세요','바꿔줘'],['주세요','줘'],['마세요','마'],
 ['어디서 찾나요','어디서 찾아'],['않았습니다','않았어'],['않습니다','않아'],['어렵습니다','어려워'],['많습니다','많아'],['좋겠습니다','좋겠어'],['이렇습니다','이래'],['만들었습니다','만들었어'],['맞습니다','맞아'],['읽었습니다','읽었어'],['번거롭습니다','번거로워'],['작습니다','작아'],['모르겠습니다','모르겠어'],['하였습니다','했어'],['지났습니다','지났어'],['올렸습니다','올렸어'],['보내드리겠습니다','보내줄게'],['됐습니다','됐어'],['하세요','해'],['하겠습니다','할게'],['했습니다','했어'],['되었습니다','됐어'],['보입니다','보여'],['움직입니다','움직여'],['그립니다','그려'],['올립니다','올려'],['내립니다','내려'],['다릅니다','달라'],['모릅니다','몰라'],['붙입니다','붙여'],['줄입니다','줄여'],['드립니다','드려'],['입니다','이야'],['합니다','해'],['됩니다','돼'],['있습니다','있어'],['없습니다','없어'],['같습니다','같아'],['싶습니다','싶어'],['바랍니다','바라'],['필요합니다','필요해'],['부탁드립니다','부탁해'],
 ['좋습니다','좋아'],['알겠습니다','알겠어'],['할까요','할까'],['인가요','이야'],['있나요','있어'],['없나요','없어'],['하나요','해'],['되나요','돼'],['어떻게 해야 하나요','어떻게 해야 해'],['알려주실 수 있나요','알려줘'],['가능할까요','가능해'],['괜찮을까요','괜찮아'],['해요','해'],['줘요','줘'],['이에요','이야'],['예요','야'],['네요','네'],['나요','나']
 ]:[['좋아','좋습니다'],['알겠어','알겠습니다'],['해 주십시오','해 주세요'],['해주십시오','해 주세요'],['해줘','해 주세요'],['알려줘','알려 주세요'],['보여줘','보여 주세요'],['만들어줘','만들어 주세요'],['바꿔줘','바꿔 주세요'],['넣어줘','넣어 주세요'],['줘','주세요'],['하겠습니다','하겠습니다'],['했어','했습니다'],['됐어','됐습니다'],['같아','같습니다'],['싶어','싶습니다'],['있어','있습니다'],['없어','없습니다'],['이야','입니다']];
 const end='(?=[.!?。！？…\\s”’"\\)\\]»]*$|[.!?。！？…](?:\\s|$)|[”’"\\)\\]])';
 // Match the longest ending once so a replacement cannot be conjugated again.
 const replacements=new Map(pairs);
 const endings=[...replacements.keys()].sort((a,b)=>b.length-a.length).join('|');
 out=out.replace(new RegExp('(?:'+endings+')'+end,'gm'),(ending,offset)=>{
  const replacement=replacements.get(ending);
  if(casual&&replacement==='이야'){
   const prior=(previous+out.slice(0,offset)).replace(/[”’"'\s]+$/,'').at(-1);
   if(prior&&/[가-힣]/.test(prior)&&(prior.charCodeAt(0)-0xac00)%28===0)return '야';
  }
  return replacement;
 });
 return out;
}

// Track quoted text across inline markup as well as within one text node.
// HTML attributes, code and quotations are never rewritten.
function renderTone(parts,actor,recipient) {
 const visible=parts.filter(part=>!part.startsWith('<')).join('');
 const closers={'“':'”','‘':'’','"':'"',"'":"'",'&quot;':'&quot;','&#39;':'&#39;','&#x27;':'&#x27;'};
 let depth=0,quoteEnd=null,offset=0,previous='';
 return parts.map(part=>{
  if(part.startsWith('<')){
   if(/^<(?:pre|code|blockquote|q)\b/i.test(part))depth++;
   if(/^<\/(?:pre|code|blockquote|q)>/i.test(part))depth=Math.max(0,depth-1);
   return part;
  }
  return part.split(/([“”‘’"']|&quot;|&#39;|&#x27;)/g).map(piece=>{
   let result=piece;
   const isQuote=Object.hasOwn(closers,piece)||piece==='”'||piece==='’';
   if(!depth&&isQuote){
    if(quoteEnd===piece)quoteEnd=null;
    else if(!quoteEnd&&closers[piece]&&!(piece==="'"&&/[A-Za-z0-9]$/.test(previous))&&visible.slice(offset+piece.length).includes(closers[piece]))quoteEnd=closers[piece];
   }else if(!depth&&!quoteEnd)result=toneSegment(piece,actor,recipient,previous);
   offset+=piece.length;previous+=piece;
   return result;
  }).join('');
 }).join('');
}
export function dialogueTone(text,actor,recipient='ai') {
 if(actor==='ai')return String(text);
 return renderTone([String(text)],actor,recipient);
}
export function dialogueHTML(html,actor,recipient='ai') {
 if(actor==='ai')return String(html);
 return renderTone(String(html).split(/(<[^>]*>)/g),actor,recipient);
}
