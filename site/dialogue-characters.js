// Presentation only: fictional actors never replace the recorded author/role.
const encode = value => String(value ?? '').replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
export const characterNames = {na:'나팀장',woo:'우대리',lee:'이과장',oh:'오사원',ai:'AI 에이전트'};
export const emotionNames = {neutral:'차분한',smile:'웃는',concerned:'당황한',tired:'피곤한',confident:'생각하는',warm:'다정한'};
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
 return role==='assistant'?'confident':'neutral';
}
export function avatarHTML(actor,emotion='neutral') {
 if(!Object.hasOwn(characterNames,actor))actor='oh';
 if(!Object.hasOwn(emotionNames,emotion))emotion='neutral';
 return `<span class="character-portrait portrait-${actor} expression-${emotion}" role="img" aria-label="${characterNames[actor]} · ${emotionNames[emotion]} 표정" data-character="${actor}" data-emotion="${emotion}"><img src="assets/characters/${actor}-expressions.png" alt="" loading="lazy" decoding="async"></span>`;
}
export function storyMessageHTML({actor='oh',emotion='neutral',label='',body='',time='',source='',kind='human'}) {
 return `<article class="story-message story-${kind}">${avatarHTML(actor,emotion)}<div class="story-message-main"><div class="story-meta"><strong>${characterNames[actor]||characterNames.oh}</strong>${label?`<span>${encode(label)}</span>`:''}${time?`<time>${encode(time)}</time>`:''}</div><div class="story-bubble">${body}</div>${source?`<small class="story-source">${encode(source)}</small>`:''}</div></article>`;
}
