import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile,mkdtemp,rm,writeFile,mkdir} from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import {createHash} from 'node:crypto';
import {characterFor,expressionFor,avatarHTML,characterExpression,dialogueTone,dialogueHTML} from '../site/dialogue-characters.js';
import {decorateLessonQA,loadMessengerCases} from '../scripts/lesson-dialogue.mjs';
import {renderMarkdown} from '../scripts/markdown.mjs';
import {conversationWorkspace} from '../site/conversations.js';
const root=path.resolve(import.meta.dirname,'..');
const portal=JSON.parse(await readFile(path.join(root,'dist/data/portal.json'),'utf8'));
test('메신저 발췌는 해시가 맞는 실제 원문에서 생성하고 이름·사번을 치환한다',async()=>{
 const data=JSON.parse(await readFile(path.join(root,'content/messenger-cases.json'),'utf8'));
 const original=await readFile(path.join(root,data.source));
 assert.equal(createHash('sha256').update(original).digest('hex'),data.sourceSha256);
 const published=await readFile(path.join(root,'dist/downloads/messenger-excerpts.md'),'utf8');
 for(const [privateText] of data.redactions)assert.ok(!published.includes(privateText));
 for(const speaker of Object.keys(data.cast))assert.ok(!published.includes(speaker));
 assert.match(published,/그럼 IAM을 지우라고 할게요! ㅋㅋ/);
 assert.match(published,/2026-09-17 오전 9:50/);
 assert.match(published,/SRC-11 · 348행/);
 assert.match(published,/과거 내역은 아직 못했네요/);
 const temp=await mkdtemp(path.join(os.tmpdir(),'messenger-hash-'));
 try {
  await mkdir(path.join(temp,'content'),{recursive:true});
  await writeFile(path.join(temp,'content/messenger-cases.json'),JSON.stringify({...data,source:'bad.txt'}));
  await writeFile(path.join(temp,'bad.txt'),'changed source');
  await assert.rejects(loadMessengerCases(temp,temp),/source hash mismatch/);
 }finally{await rm(temp,{recursive:true,force:true});}
});
test('업무카드 식별자·날짜·범위와 두 전환 화면을 연결한다',()=>{
 const lesson=portal.lessons.find(x=>x.id==='knowledge');
 assert.match(lesson.html,/업무 메신저 대화 맥락 보존/);
 for(const id of ['KC-20260824-01','KC-20260916-01'])assert.match(lesson.html,new RegExp(`id="${id}"`));
 assert.equal((lesson.html.match(/data-case-panel="chat"/g)||[]).length,2);
 assert.equal((lesson.html.match(/data-case-panel="card" hidden/g)||[]).length,2);
 assert.match(lesson.html,/교육용 카드 ID/);
 assert.match(lesson.html,/2026-08-23/);
 assert.match(lesson.html,/2026-09-22 10:20:26/);
 assert.match(lesson.html,/개인 등급 변경, 신규 입력 적용, 과거 내역 정정/);
 // This repository preserves published anchors when new headings are inserted.
 assert.equal(lesson.toc.find(t=>t.text==='문서 구성을 활용한 업무 문답').id,'section-12');
 assert.equal(lesson.toc.find(t=>t.id==='section-15').text,'5-3. 개별 조치와 과거 내역 처리 구분');
 assert.equal(lesson.toc.find(t=>t.text==='업무 메신저 대화 맥락 보존').id,'section-19');
});
test('모든 기존 명시적 업무 문답의 내용과 안전한 마크업을 보존한다',()=>{
 const md='## 예시\n\n**질문 · “어디서 찾나요?”**\n\n**답변 ·** 문서의 `INDEX.md`를 읽습니다.\n\n후속 설명입니다.';
 const before=renderMarkdown(md).html,after=decorateLessonQA(before,'case');
 assert.match(after,/어디서 찾나요/);assert.match(after,/<code>INDEX.md<\/code>/);
 assert.match(after,/<p>후속 설명입니다.<\/p>/);assert.match(after,/id="section-1"/);
 const code=renderMarkdown('```text\n**질문 · 테스트**\n답변\n```').html;
 assert.equal(decorateLessonQA(code,'case'),code);
 assert.equal(portal.lessons.reduce((n,l)=>n+(l.html.match(/class="lesson-dialogue"/g)||[]).length,0),6);
});
test('가상 대역은 에피소드마다 안정적으로 배정하고 원래 사용자·AI 역할을 유지한다',()=>{
 const actors=new Set();
 for(let i=0;i<30;i++){actors.add(characterFor('episode-'+i));assert.equal(characterFor('episode-'+i),characterFor('episode-'+i));}
 assert.equal(actors.size,4);
 const html=conversationWorkspace(portal.conversations,{projectId:'erp-obsidian-knowledge-map',episodeId:'obs-e001'});
 assert.match(html,/사용자 요청/);assert.match(html,/AI 에이전트 · AI 응답/);assert.match(html,/가상 인물 대역/);
 assert.match(html,/character-portrait/);assert.match(html,/data-chat-copy/);assert.match(html,/출처 · obs-m001/);
});
test('금액의 0은 오류 감정으로 잘못 읽지 않고 표정·이미지 경로를 제한한다',()=>{
 assert.equal(expressionFor('8,400원을 써도 되나요?'),'neutral');
 assert.equal(expressionFor('실비가 0원입니다. 오류인가요?'),'concerned');
 assert.equal(expressionFor('밤새 정리해서 피곤합니다'),'tired');
 assert.equal(expressionFor('처리가 완료되었습니다'),'smile');
 const safe=avatarHTML('../../bad','<script>');
 assert.match(safe,/portrait-oh expression-neutral/);assert.doesNotMatch(safe,/script|\.\.\//);
});


test('직급과 무관하게 발화 맥락으로 표정을 선택하며 AI는 고정 로고를 사용한다',()=>{
 for(const actor of ['na','woo','lee','oh'])assert.equal(characterExpression(actor,'na','오류입니다'),'concerned');
 assert.equal(characterExpression('na','ai','밤새 작업해서 피곤합니다'),'tired');
 assert.equal(characterExpression('na','woo','함께 차근차근 해요'),'warm');
 assert.equal(characterExpression('na','woo','제가 맡아서 책임지고 할게요'),'confident');
 for(const e of ['warm','tired','concerned']){
  const h=avatarHTML('ai',e);assert.match(h,/chatgpt-logo.svg/);assert.doesNotMatch(h,/ai-expressions|data-emotion/);
 }
});
test('AI 요청의 높임말을 역할별로 바꾸고 코드와 인용·링크는 보존한다',()=>{
 for(const actor of ['na','lee'])assert.equal(dialogueTone('코드를 수정해 주세요. 확인했습니다.',actor),'코드를 수정해. 확인했어.');
 for(const actor of ['woo','oh'])assert.equal(dialogueTone('코드를 수정해줘.',actor),'코드를 수정해 주세요.');
 const h='<p>수정해 주세요.</p><pre><code>수정해 주세요.</code></pre><blockquote>수정해 주세요.</blockquote><a href="/수정해 주세요.">확인해 주세요.</a>';
 const out=dialogueHTML(h,'na');assert.match(out,/<p>수정해.<\/p>/);assert.match(out,/<code>수정해 주세요.<\/code>/);assert.match(out,/<blockquote>수정해 주세요.<\/blockquote>/);assert.match(out,/href="\/수정해 주세요."/);
});
test('메신저 표시 대사에는 상대와 말투를 명시하고 원문 발췌와 분리한다',async()=>{
 const d=JSON.parse(await readFile(path.join(root,'content/messenger-cases.json'),'utf8'));
 for(const c of d.cases)for(const t of c.turns){assert.ok(t.recipient);assert.ok(t.displayText);for(const [privateName] of d.redactions)assert.ok(!t.displayText.includes(privateName));}
 const lesson=portal.lessons.find(l=>l.id==='knowledge');assert.match(lesson.html,/최팀장/);assert.doesNotMatch(lesson.html,/나팀장/);assert.match(lesson.html,/직급에 맞게 말투를 편집/);
 const css=await readFile(path.join(root,'site/story-dialogue.css'),'utf8');assert.match(css,/86.4px/);assert.match(css,/61.2px/);assert.doesNotMatch(css,/96px|68px/);
});

test('AI 말투에서 보입니다와 명사 어미를 구분한다',()=>{
 assert.equal(dialogueTone('구현된 것으로 보입니다.','lee'),'구현된 것으로 보여.');
 assert.equal(dialogueTone('오류입니다.','na'),'오류야.');
 assert.equal(dialogueTone('문제입니다.','na'),'문제야.');
 assert.equal(dialogueTone('계획입니다.','na'),'계획이야.');
});

test('표시용 말투 편집은 인라인 서식을 가로지르는 인용문도 보존한다',()=>{
 const html='<p>“<strong>완료했습니다</strong>”라는 문구와 &quot;확인했습니다.&quot;를 보여 주세요.</p><p><q>수정해 주세요.</q><code>보입니다.</code><strong>문서</strong>입니다.</p>';
 assert.equal(dialogueHTML(html,'na'),'<p>“<strong>완료했습니다</strong>”라는 문구와 &quot;확인했습니다.&quot;를 보여줘.</p><p><q>수정해 주세요.</q><code>보입니다.</code><strong>문서</strong>야.</p>');
 assert.equal(dialogueTone('"완료했습니다"라는 문구를 수정해 주세요.','lee'),'"완료했습니다"라는 문구를 수정해.');
 assert.equal(dialogueHTML(html,'ai'),html);
});
test('동사·명사 어미를 구분하고 편집을 반복해도 같은 문장을 유지한다',()=>{
 const text='구현된 것으로 보입니다. 화면이 움직입니다. 그림을 그립니다. 문서입니다. 계획입니다. 부탁드립니다.';
 const expected='구현된 것으로 보여. 화면이 움직여. 그림을 그려. 문서야. 계획이야. 부탁해.';
 for(const actor of ['na','lee']){assert.equal(dialogueTone(text,actor),expected);assert.equal(dialogueTone(expected,actor),expected);}
 for(const actor of ['woo','oh']){const once=dialogueTone('코드를 수정해줘.','woo');assert.equal(once,'코드를 수정해 주세요.');assert.equal(dialogueTone(once,actor),once);}
});
test('검토된 메신저 18개 대사는 직급 순위에 맞는 종결형을 사용한다',async()=>{
 const d=JSON.parse(await readFile(path.join(root,'content/messenger-cases.json'),'utf8')),rank={na:4,lee:3,woo:2,oh:1};
 assert.equal(d.cases.flatMap(c=>c.turns).length,18);
 for(const c of d.cases)for(const t of c.turns){
  assert.ok(rank[t.actor]&&rank[t.recipient]);
  assert.match(t.displayText,rank[t.actor]<rank[t.recipient]?/(?:습니다|입니다|합니다|드립니다|습니까)[.!?]$/:/요[.!?]$/);
  assert.ok(['neutral','smile','concerned','tired','confident','warm'].includes(t.emotion));
 }
});
test('동일한 발화의 표정은 수신자·새로고침·반복 렌더링에 영향받지 않는다',()=>{
 for(const [text,emotion] of [['오류가 나서 당황했습니다.','concerned'],['밤새 작업해서 피곤합니다.','tired'],['완료했습니다. 감사합니다.','smile']])for(const actor of ['na','lee','woo','oh'])for(const recipient of ['na','lee','woo','oh','ai']){
  assert.equal(characterExpression(actor,recipient,text,'a'),emotion);
  assert.equal(characterExpression(actor,recipient,text,'b'),emotion);
  assert.equal(avatarHTML(actor,emotion),avatarHTML(actor,emotion));
 }
});
