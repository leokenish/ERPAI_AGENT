// Native SVG fills: preserve the embedded illustration and all screen animations.
import {readFile,writeFile} from 'node:fs/promises';
import path from 'node:path';
import {fileURLToPath,pathToFileURL} from 'node:url';

const themes={
 light:{file:'team-collaboration-animated.svg',prefix:'screen',colors:['#B0B568','#87913E','#626D2E'],fruits:[
  [632.5,210.5,13,13.5],[754.5,153.5,13.5,14],[863.5,194,13.5,13.5],
  [886,172,13,13],[1010,246,12,13],[691,306,12.5,12.5],[912,320,13,13.5]
 ]},
 dark:{file:'team-collaboration-dark.svg',prefix:'dark-screen',colors:['#EF9A88','#D15F60','#A83E50'],fruits:[
  [628.5,210,12.5,13],[748.5,153,13,13.5],[860.5,194,12.5,13],
  [883,172,12,12],[1007,246,11.5,12.5],[688,306,12,12],[908,320.5,12.5,13]
 ]}
};
export function colorOliveFruits(svg,theme){
 const {prefix,colors,fruits}=themes[theme];
 const uiId=theme==='dark'?'dark-ui-content':'ui-content';
 svg=svg.replace(/<!-- olive-(?:defs|fruits):start -->[\s\S]*?<!-- olive-(?:defs|fruits):end -->\n?/g,'');
 const gradient=`<!-- olive-defs:start -->\n<radialGradient id="${prefix}-olive-fill" cx="32%" cy="24%" r="78%"><stop offset="0" stop-color="${colors[0]}"/><stop offset=".5" stop-color="${colors[1]}"/><stop offset="1" stop-color="${colors[2]}"/></radialGradient>\n<!-- olive-defs:end -->\n`;
 const group=`<!-- olive-fruits:start -->\n<g id="${prefix}-olive-fruits" fill="url(#${prefix}-olive-fill)">\n${fruits.map(([cx,cy,rx,ry],i)=>`<ellipse class="olive-fruit" data-fruit="${i+1}" cx="${cx}" cy="${cy}" rx="${rx}" ry="${ry}"/>`).join('\n')}\n</g>\n<!-- olive-fruits:end -->\n`;
 if(!svg.includes('</defs>')||!svg.includes(`<g id="${uiId}">`))throw Error(`Unexpected ${theme} hero structure`);
 return svg.replace('</defs>',gradient+'</defs>').replace(`<g id="${uiId}">`,group+`<g id="${uiId}">`);
}
export async function updateOliveFruits(root){
 for(const [theme,{file}] of Object.entries(themes)){
  const target=path.join(root,'assets/images',file),before=await readFile(target,'utf8'),after=colorOliveFruits(before,theme);
  if(after!==before)await writeFile(target,after);
 }
}
if(process.argv[1]&&import.meta.url===pathToFileURL(path.resolve(process.argv[1])).href){
 await updateOliveFruits(path.resolve(path.dirname(fileURLToPath(import.meta.url)),'..'));
}
