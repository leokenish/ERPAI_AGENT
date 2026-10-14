import test from 'node:test';
import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import {createHash} from 'node:crypto';

test('이전 승인본과 새 편집 PNG를 보존하고 화면의 23개 요소에만 모션을 적용한다',async()=>{
 const svg=await readFile(new URL('../assets/images/team-collaboration-animated.svg',import.meta.url),'utf8');
 const base=Buffer.from(svg.match(/xlink:href="data:image\/png;base64,([^"]+)"/)[1],'base64');
 const original=await readFile(new URL('../docs/design/base/team-screen-approved.png',import.meta.url));
 assert.equal(createHash('sha256').update(original).digest('hex'),'c6fcc9711ca2f6087a904e6ed91f5c6ed24b42689e8e924ee595c8caab846ba4');
 assert.equal(createHash('sha256').update(base).digest('hex'),'0e99277d9e6176817b8bbb5fb1d93e729bf2f495c0601d3cbc12275692d9bc5b');
 const dark=await readFile(new URL('../assets/images/team-collaboration-dark.svg',import.meta.url),'utf8');
 const darkBase=Buffer.from(dark.match(/xlink:href="data:image\/png;base64,([^"]+)"/)[1],'base64');
 assert.equal(createHash('sha256').update(darkBase).digest('hex'),'bb4d9dec9bf85ca42970da2667f02250f3ed122edf1a831ad12e7dbc0a9a2483');
 assert.equal((svg.match(/<image\b/g)||[]).length,1);
 assert.equal((svg.match(/class="ui-motion"/g)||[]).length,23);
 assert.equal(new Set([...svg.matchAll(/data-screen="([^"]+)"/g)].map(m=>m[1])).size,6);
 assert.ok(!/<filter\b|\btransform=|<script\b|<foreignObject\b|https?:\/\/(?!www\.w3\.org)/.test(svg));
 assert.ok(!svg.includes('erp-leaf'));
});
test('CSP 빌드에서도 각 화면의 독립적인 주기와 시작 시차가 보존된다',async()=>{
 const data=JSON.parse(await readFile(new URL('../dist/data/portal.json',import.meta.url),'utf8'));
 const css=await readFile(new URL('../dist/styles.css',import.meta.url),'utf8');
 assert.ok(!/<style\b|\bstyle=/.test(data.heroScene));
 const groups=[...data.heroScene.matchAll(/<g id="([^"]+)" class="ui-motion"[^>]*data-cycle="([^"]+)" data-delay="([^"]+)"/g)];
 assert.equal(groups.length,23);
 for(const [,id,cycle,delay] of groups)assert.ok(css.includes(`#erp-screen-scene #${id}{--cycle:${cycle}s;--delay:${delay}s}`),id);
 assert.match(css,/@keyframes erp-ui-cycle/);
 // The user requests continuous monitor fades; only this effect overrides
 // the global reduced-motion stop. Title and theme transitions still respect it.
 for(const prefix of ['', 'dark-'])assert.ok(css.includes(`@media(prefers-reduced-motion:reduce){#${prefix}erp-screen-scene .ui-motion{animation:${prefix}erp-ui-cycle var(--cycle) ease-in-out var(--delay) infinite!important}}`));
 assert.ok(!css.includes('.ui-motion{animation:none!important;opacity:1!important}'));
 assert.ok(new Set(groups.map(m=>m[2])).size>1);
 assert.ok(new Set(groups.map(m=>m[3])).size>1);
});
test('두 테마는 같은 크기·클립·모션을 사용하고 문서 ID가 충돌하지 않는다',async()=>{
 const data=JSON.parse(await readFile(new URL('../dist/data/portal.json',import.meta.url),'utf8'));
 const css=await readFile(new URL('../dist/styles.css',import.meta.url),'utf8');
 const light=data.heroScene,dark=data.heroSceneDark;
 assert.match(dark,/width="1448" height="1086" viewBox="0 0 1447 1087"/);
 assert.ok(!/<style\b|\bstyle=|<filter\b|\btransform=|<script\b|<foreignObject\b/.test(dark));
 const paths=svg=>[...svg.matchAll(/<path d="([^"]+)"/g)].map(m=>m[1]);
 assert.deepEqual(paths(dark),paths(light));
 assert.equal((dark.match(/<clipPath /g)||[]).length,6);
 assert.ok(!/ui-underlay|screen-static-mask/.test(dark+light),'Blank source screens must not need erasure patches');
 assert.match(light,/width="1448" height="1086" viewBox="0 0 1447 1087"/);
 const ids=[...(light+dark).matchAll(/\bid="([^"]+)"/g)].map(m=>m[1]);
 assert.equal(new Set(ids).size,ids.length);
 for(const ref of (light+dark).matchAll(/(?:xlink:href="#|url\(#)([^"\)]+)/g))assert.ok(ids.includes(ref[1]),ref[1]);
 const groups=[...dark.matchAll(/<g id="([^"]+)" class="ui-motion"[^>]*data-cycle="([^"]+)" data-delay="([^"]+)"/g)];
 assert.equal(groups.length,23);
 for(const [,id,cycle,delay] of groups)assert.ok(css.includes(`#dark-erp-screen-scene #${id}{--cycle:${cycle}s;--delay:${delay}s}`));
});
