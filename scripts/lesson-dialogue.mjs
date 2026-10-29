import {readFile,writeFile,mkdir} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import path from 'node:path';
import {escapeHTML} from './markdown.mjs';
import {characterFor,expressionFor,storyMessageHTML,characterExpression,dialogueHTML} from '../site/dialogue-characters.js';

export function decorateLessonQA(html,key) {
 let index=0;
 // Only explicit question paragraphs and their immediately following answer are
 // dramatized. Never parse code, tables or narrative mentions as dialogue.
 return html.replace(/<p><strong>질문\s*[·:]\s*([\s\S]*?)<\/strong>([\s\S]*?)<\/p>\s*<p>([\s\S]*?)<\/p>/g,(_all,a,b,answer)=>{
  const question=(a+b).trim();
  const cleanAnswer=answer.replace(/^<strong>답변\s*[·:]\s*<\/strong>\s*/,'');
  const plain=s=>s.replace(/<[^>]+>/g,'');
  const actor=characterFor(key+':'+index++);
  // The outer quotation marks frame the character's own speech, not a cited source.
  const displayQuestion=question.startsWith('“')&&question.endsWith('”')
   ?'“'+dialogueHTML(question.slice(1,-1),actor,'ai')+'”'
   :dialogueHTML(question,actor,'ai');
  return `<section class="lesson-dialogue" aria-label="업무 질문과 답변"><p class="story-edition">근거를 바탕으로 정리한 사례 문답 · 가상 인물 연출</p>${storyMessageHTML({actor,emotion:characterExpression(actor,'ai',plain(question)),label:'질문',body:`<p>${displayQuestion}</p>`})}${storyMessageHTML({actor:'ai',emotion:expressionFor(plain(cleanAnswer),'assistant'),label:'답변',body:`<p>${cleanAnswer}</p>`,kind:'ai'})}</section>`;
 });
}

export async function loadMessengerCases(root,out) {
 const data=JSON.parse(await readFile(path.join(root,'content/messenger-cases.json'),'utf8'));
 const bytes=await readFile(path.join(root,data.source));
 if(createHash('sha256').update(bytes).digest('hex')!==data.sourceSha256)throw Error('Messenger source hash mismatch');
 const lines=bytes.toString('utf8').replace(/^\uFEFF/,'').split(/\r?\n/);
 const redactions=data.redactions;
 const redact=text=>redactions.reduce((value,[from,to])=>value.split(from).join(to),text);
 let exportText='# 업무 메신저 원문 발췌\n\n실제 SRC-11 대화의 이름·사번을 가상 인물과 사례명으로 치환했습니다. 말투와 시각은 유지했습니다.\n';
 let cardsText='# 업무 메신저의 업무카드\n\n아래 KC 식별자는 교육용으로 새로 부여했습니다. 원문 출처 식별자는 SRC-11입니다.\n';
 const resolved=data.cases.map(item=>{
  const turns=item.turns.map(turn=>{
   if(turn.start<1||turn.end>lines.length||turn.start>turn.end)throw Error('Invalid messenger line range');
   const selected=lines.slice(turn.start-1,turn.end);
   const dateLine=lines.slice(0,turn.start).findLast(line=>/^-+ \d{4}년/.test(line));
   const dateParts=dateLine?.match(/(\d{4})년 (\d+)월 (\d+)일/);
   const actualDate=dateParts&&`${dateParts[1]}-${dateParts[2].padStart(2,'0')}-${dateParts[3].padStart(2,'0')}`;
   if(actualDate!==turn.date)throw Error('Messenger date differs from original');
   const times=[...new Set(selected.flatMap(line=>{const m=line.match(/^\[[^\]]+\] \[([^\]]+)\]/);return m?[m[1]]:[]}))];
   const parsed=selected[0].match(/^\[([^\]]+)\] \[([^\]]+)\] (.*)$/);
   if(!parsed)throw Error('Messenger selection must start at a message');
   const speaker=parsed[1];
   if(data.cast[speaker]!==turn.actor)throw Error('Inconsistent fictional cast');
   const text=selected.map(line=>{
    const m=line.match(/^\[([^\]]+)\] \[([^\]]+)\] (.*)$/);
    if(m&&m[1]!==speaker)throw Error('Do not merge different speakers');
    return m?m[3]:line;
   }).join('\n');
   return {...turn,text:redact(text),time:times.join('–'),source:`SRC-11 · ${turn.start}${turn.end===turn.start?'':'–'+turn.end}행`};
  });
  exportText+=`\n## ${item.title}\n\n`+turns.map(t=>`[${data.names[t.actor]}] [${t.date} ${t.time}] ${t.text}\n출처: ${t.source}`).join('\n\n')+'\n';
  cardsText+=`\n## ${item.id} · ${item.title}\n\n`+item.fields.map(([k,v])=>`- ${k}: ${v}`).join('\n')+'\n';
  return {...item,turns};
 });
 await mkdir(path.join(out,'downloads'),{recursive:true});
 await writeFile(path.join(out,'downloads/messenger-excerpts.md'),exportText);
 await writeFile(path.join(out,'downloads/messenger-cards.md'),cardsText);
 return {search:resolved.map(c=>[c.title,...c.fields.flat(),...c.turns.flatMap(t=>[t.text,t.displayText])].join('\n')).join('\n'),render(id){
  const c=resolved.find(x=>x.id===id.trim());if(!c)throw Error('Unknown messenger case: '+id);
  const rows=c.turns.map(t=>storyMessageHTML({actor:t.actor,emotion:t.emotion || characterExpression(t.actor,t.recipient,t.displayText,t.start),label:t.stage,body:`<p>${escapeHTML(t.displayText).replaceAll('\n','<br>')}</p>`,time:`${t.date} ${t.time}`,source:t.source})).join('');
  return `<section class="messenger-case" id="${c.id}" aria-label="${escapeHTML(c.title)}"><header class="messenger-case-heading"><span class="eyebrow">MESSENGER → KNOWLEDGE</span><h4>${escapeHTML(c.title)}</h4><p class="story-edition">실제 대화를 바탕으로 직급에 맞게 말투를 편집했습니다. 가상 인물의 관계와 표정은 연출이며, 원문 발췌는 아래 MD에서 확인합니다.</p></header><div class="messenger-switches" role="group" aria-label="사례 보기"><button class="btn small" data-case-view="chat" aria-pressed="true">메신저 대화</button><button class="btn small" data-case-view="card" aria-pressed="false">정리된 업무카드</button><button class="btn small" data-case-view="both" aria-pressed="false">함께 보기</button></div><div class="messenger-chat" data-case-panel="chat">${rows}</div><div class="work-card" data-case-panel="card" hidden><div class="work-card-heading"><span class="eyebrow">업무카드</span><span class="work-card-id">${escapeHTML(c.id)}</span></div><h4>${escapeHTML(c.title)}</h4><p class="story-edition">교육용 카드 ID · 원문 출처 SRC-11</p><dl>${c.fields.map(([key,value])=>`<div><dt>${escapeHTML(key)}</dt><dd>${escapeHTML(value)}</dd></div>`).join('')}</dl><p class="work-card-takeaway">${escapeHTML(c.takeaway)}</p><a href="downloads/messenger-cards.md" download>업무카드 MD 받기 ↓</a></div><p class="messenger-case-footer"><a href="downloads/messenger-excerpts.md" download>가상 인물로 치환한 원문 발췌 MD ↓</a></p></section>`;
 }};
}
