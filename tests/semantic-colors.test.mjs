import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {createHash} from 'node:crypto';
import {renderMarkdown} from '../scripts/markdown.mjs';
import {avatarHTML} from '../site/dialogue-characters.js';

test('명시적인 주의사항만 분류하고 일반 인용·코드·링크를 보존한다',()=>{
  for(const label of ['주의:', '**주의사항**:', '경고：', 'CAUTION ', '**WARNING** ']){
    const {html}=renderMarkdown(`> ${label} **원본**을 보존합니다. [자료](downloads/guide.md)\n>\n> \`code\``);
    assert.match(html, /^<blockquote class="caution">/);
    assert.match(html, /<strong>원본<\/strong>/);
    assert.match(html, /<a href="downloads\/guide.md" download>자료<\/a>/);
    assert.match(html, /<code>code<\/code>/);
  }
  assert.equal(renderMarkdown('> 인용문입니다.').html, '<blockquote>\n<p>인용문입니다.</p>\n</blockquote>\n');
  assert.doesNotMatch(renderMarkdown('> 주의깊게 검토합니다.\n\n```text\n> WARNING: code\n```').html, /class="caution"/);
});

test('최팀장 자산 이름만 바꾸고 여섯 표정·원본 픽셀·ChatGPT 로고를 보존한다',async()=>{
  for(const emotion of ['neutral','smile','concerned','tired','confident','warm']){
    const html=avatarHTML('na',emotion);
    assert.match(html,/data-character="na"/);
    assert.ok(html.includes(`data-emotion="${emotion}"`));
    assert.match(html,/최팀장/);
    assert.match(html,/assets\/characters\/choi-expressions\.png/);
    assert.doesNotMatch(html,/na-expressions\.png/);
  }
  const digest=async p=>createHash('sha256').update(await readFile(new URL(p,import.meta.url))).digest('hex');
  assert.equal(await digest('../assets/characters/choi-expressions.png'),'06ab92af10eeea49f626cf90ba7177b4aae1c4ccf4456792d7699634cc3eef57');
  assert.equal(await digest('../assets/characters/chatgpt-logo.svg'),'7be72f1fea831d3ba81a545cee79b7e0ae69449d5d7837c9571ccbfb4aa1e00b');
  assert.match(avatarHTML('ai'),/chatgpt-logo\.svg/);
});
