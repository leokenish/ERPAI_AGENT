import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile,mkdtemp,rm,writeFile,mkdir} from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import {createHash} from 'node:crypto';
import {characterFor,expressionFor,avatarHTML} from '../site/dialogue-characters.js';
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
