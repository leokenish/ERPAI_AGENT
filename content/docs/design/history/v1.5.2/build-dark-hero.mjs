// Native SVG palette layers preserve every coordinate and the embedded PNG.
// Re-run after updating the approved light SVG. No raster redraw or geometry transform.
import {readFile,writeFile} from 'node:fs/promises';
import {spawnSync} from 'node:child_process';
import {createHash} from 'node:crypto';
import {fileURLToPath} from 'node:url';
import path from 'node:path';
const root=path.resolve(path.dirname(fileURLToPath(import.meta.url)),'..');
let svg=await readFile(path.join(root,'assets/images/team-collaboration-animated.svg'),'utf8');
const lightSvg=svg;
const screenColors=['#8093b6','#8093b6','#8496b8','#8496b8','#8496b8','#91a6ce','#91a6ce','#a8b9dd','#a8b9dd','#758cae','#25364f'];
const rgb=hex=>hex.match(/[\da-f]{2}/gi).map(x=>(parseInt(x,16)/255).toFixed(5));
const transfer=colors=>{const c=colors.map(rgb);return ['R','G','B'].map((ch,i)=>`<feFunc${ch} type="table" tableValues="${c.map(v=>v[i]).join(' ')}"/>`).join('');};
const filter=(id,colors,blue=true)=>`<filter id="${id}" x="0" y="0" width="1448" height="1086" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
<feColorMatrix in="SourceGraphic" type="matrix" values=".2126 .7152 .0722 0 0 .2126 .7152 .0722 0 0 .2126 .7152 .0722 0 0 0 0 0 1 0"/>
<feComponentTransfer result="neutral">${transfer(colors)}</feComponentTransfer>
${blue?`<feColorMatrix in="SourceGraphic" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 -3 0 3 0 -.4" result="blue-mask"/>
<feFlood flood-color="#9aaeff"/><feComposite in2="blue-mask" operator="in" result="blue"/>
<feMerge><feMergeNode in="neutral"/><feMergeNode in="blue"/></feMerge>`:''}
<feComposite in2="SourceGraphic" operator="in"/>
</filter>`;
const neutral=['#53617a','#6c7c98','#7e90af','#93a4c0','#b7c5dc'];
const filters=[filter('palette',neutral),
 filter('hair',['#8c7447','#dbc17e','#e6d3a3','#ced4e0','#b7c5dc','#b7c5dc','#b7c5dc','#b7c5dc','#b7c5dc','#b7c5dc','#b7c5dc'],false),
 filter('clothes',['#6b7890','#edf1f8','#eef2fa','#899ab5','#b7c5dc','#b7c5dc','#b7c5dc','#b7c5dc','#b7c5dc','#b7c5dc','#b7c5dc'],false),
 filter('screen',screenColors)].join('\n');
const polygons={
 hair:['447,306 532,306 532,342 502,348 481,374 447,368','254,572 379,572 379,615 351,642 315,696 252,703','609,667 680,667 680,712 651,740 609,740','1128,378 1238,378 1238,452 1191,462 1137,462','960,695 1063,695 1078,774 1064,790 1026,779 999,744 960,744'],
 clothes:['441,489 511,489 512,646 473,659 440,651','285,693 364,693 428,725 435,805 405,840 376,817 365,769 303,768 282,749','585,830 679,833 738,806 757,834 763,933 729,955 685,944 690,878 643,890 583,870','1138,540 1221,544 1230,710 1180,734 1135,701','947,847 1075,826 1098,852 1088,903 1005,917 999,964 940,967 937,919'],
 screen:['203,492 326,444 326,547 203,592','619,376 758,455 758,580 619,503','945,440 1099,528 1099,628 945,544','680,618 841,709 841,791 748,742 744,730 729,713 708,730 680,714','1340,606 1399,639 1399,697 1340,665','1096,479 1139,490 1149,513 1104,501']
};
let defs=filters+`<filter id="dark-ink-mask" x="0" y="0" width="1448" height="1086" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB"><feColorMatrix in="SourceGraphic" type="matrix" values="0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 -10 0 3"/><feComposite in2="SourceGraphic" operator="in"/></filter><mask id="dark-ink-only" x="0" y="0" width="1448" height="1086" maskUnits="userSpaceOnUse" maskContentUnits="userSpaceOnUse"><use xlink:href="#screen-original" filter="url(#dark-ink-mask)"/></mask>`;
for(const [name,regions] of Object.entries(polygons))defs+=`<clipPath id="${name}-region" clipPathUnits="userSpaceOnUse">${regions.map(points=>`<polygon points="${points}"/>`).join('')}</clipPath>`;
// The same geometry is shared by every palette layer. The clipping regions add no new shapes.
const split=svg.indexOf('</defs>')+7;
const head=svg.slice(0,split).replace('</defs>',defs+'</defs>');
const body='<use xlink:href="#screen-original"/>'; // Bake the untouched source, not an animation frame.
svg=head.replace('</defs>',`<g id="scene-content">${body}</g></defs>`)+`
<use xlink:href="#scene-content" filter="url(#palette)"/>
<g clip-path="url(#screen-region)"><use xlink:href="#scene-content" filter="url(#screen)"/></g>
<g clip-path="url(#clothes-region)"><use xlink:href="#screen-original" filter="url(#clothes)" mask="url(#dark-ink-only)"/></g>
<g clip-path="url(#hair-region)"><use xlink:href="#screen-original" filter="url(#hair)" mask="url(#dark-ink-only)"/></g>
</svg>`;
// Bake this native SVG palette once, so the website does not repaint filters
// on every animated frame. Inkscape is optional for asset regeneration only.
const recipe=path.join(root,'docs/design/base/team-dark-palette.svg');
const pngPath=path.join(root,'docs/design/base/team-screen-dark.png');
await writeFile(recipe,svg);
const rendered=spawnSync('inkscape',[recipe,'--export-type=png',`--export-filename=${pngPath}`,'--export-width=1448','--export-height=1086'],{encoding:'utf8'});
if(rendered.status!==0)throw Error(rendered.stderr||'Inkscape palette rendering failed');
const png=await readFile(pngPath);
svg=lightSvg.replace(/xlink:href="data:image\/png;base64,[^"]+"/,`xlink:href="data:image/png;base64,${png.toString('base64')}"`);
// Screen erasure backgrounds follow the same luminance transfer as their PNG.
const screenColor=values=>{
 const [r,g,b]=values.split(',').map(Number),p=(r*.2126+g*.7152+b*.0722)/255*10;
 const i=Math.min(9,Math.floor(p)),t=p-i,a=rgb(screenColors[i]),z=rgb(screenColors[i+1]);
 return a.map((c,k)=>Math.round((Number(c)*(1-t)+Number(z[k])*t)*255)).join(',');
};
svg=svg.replace(/(<g id="ui-underlay">)([\s\S]*?)(<\/g>)/,(_,a,b,c)=>a+b.replace(/fill="rgb\(([^)]+)\)"/g,(_,v)=>`fill="rgb(${screenColor(v)})"`)+c);
const origin=JSON.parse(lightSvg.match(/<metadata>(.*?)<\/metadata>/s)[1].replaceAll('&quot;','"').replaceAll('&amp;','&'));
svg=svg.replace(/<metadata>.*?<\/metadata>/s,`<metadata>${JSON.stringify({...origin,source:'team-screen-dark.png',source_sha256:createHash('sha256').update(png).digest('hex'),original_source_sha256:origin.source_sha256,version:'1.5.2',format:'native SVG palette rendered to PNG; unchanged SVG screen clipping and opacity animation'}).replaceAll('&','&amp;').replaceAll('<','&lt;')}</metadata>`);
// Namespace every local reference so both SVGs can be overlaid in one document.
const ids=[...svg.matchAll(/\bid="([^"]+)"/g)].map(m=>m[1]);
for(const id of ids.sort((a,b)=>b.length-a.length)){
 svg=svg.replaceAll(`id="${id}"`,`id="dark-${id}"`).replaceAll(`#${id}"`,`#dark-${id}"`).replaceAll(`#${id})`,`#dark-${id})`).replaceAll(`#${id} `,`#dark-${id} `).replaceAll(`#${id}{`,`#dark-${id}{`).replaceAll(`#${id}.`,`#dark-${id}.`).replaceAll(`#${id},`,`#dark-${id},`);
}
svg=svg.replace('aria-labelledby="screen-title screen-desc"','aria-labelledby="dark-screen-title dark-screen-desc"').replaceAll('erp-ui-cycle','erp-dark-ui-cycle');
svg=svg.replace('배선을 정리한 원본 목업입니다.','기존 구도를 보존한 다크 팔레트입니다. 금발, 밝은 하의, 퍼리윙클 포인트와 어두운 화면을 사용합니다.');
await writeFile(path.join(root,'assets/images/team-collaboration-dark.svg'),svg);
const logo=await readFile(path.join(root,'assets/images/kbs-logo.svg'),'utf8');
await writeFile(path.join(root,'assets/images/kbs-logo-dark.svg'),logo.replaceAll('#1e1747','#f5f7fc').replaceAll('#0f9bdf','#9aaeff'));
console.log('Dark hero and logo: source geometry preserved; runtime filters removed.');
