// Local browser checks. No OS clipboard mutation or external web requests.
const fs=require('fs'),path=require('path'),{pathToFileURL}=require('url');
const {chromium}=require('/Users/naviolgu/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const root=path.resolve(__dirname,'..');
const assert=(ok,msg)=>{if(!ok)throw Error(msg);};
(async()=>{
const browser=await chromium.launch({executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',headless:true});
try{
 const context=await browser.newContext({viewport:{width:1500,height:1050},deviceScaleFactor:1});
 const page=await context.newPage(),errors=[],network=[];page.on('pageerror',e=>errors.push(e.message));page.on('request',r=>{if(/^https?:/.test(r.url()))network.push(r.url());});
 await page.addInitScript(()=>{Object.defineProperty(navigator,'clipboard',{configurable:true,value:{writeText:async text=>window.__copied=text}});});
 const open=async f=>page.goto(pathToFileURL(path.join(root,f)).href);
 const noOverflow=async label=>assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1),label+' page overflow');
 const figs=JSON.parse(fs.readFileSync(path.join(root,'assets/visuals/index.json'),'utf8'));
 const svgChecks=[];
 for(const f of figs){
  await page.setViewportSize({width:f.width,height:f.height});await open(f.svg);await page.evaluate(()=>document.fonts.ready);
  const bad=await page.locator('svg text').evaluateAll(nodes=>nodes.flatMap(n=>{const b=n.getBBox(),svg=n.ownerSVGElement.viewBox.baseVal;return b.x<0||b.y<0||b.x+b.width>svg.width+1||b.y+b.height>svg.height+1?[n.textContent]:[];}));
  assert(!bad.length,f.id+' SVG text outside bounds: '+bad.join(','));
  await page.locator('svg').screenshot({path:path.join(root,f.png)});svgChecks.push({id:f.id,rendered:true,outside_canvas:bad});
 }
 await page.setViewportSize({width:1500,height:1050});await open('index.html');await noOverflow('index desktop');
 await page.screenshot({path:path.join(root,'evidence/preview-index.png')});
 await open('scenarios.html');
 for(const [id,expected] of [['six-two','60,000원'],['two-six','60,000원'],['six-six','120,000원'],['three-two','50,000원'],['two-two','0원']]){
  await page.locator(`[data-rate="${id}"]`).click();assert(await page.locator('#settle-total').innerText()===expected,'rate '+id);
 }
 await page.locator('[data-rate="six-two"]').click();assert(await page.locator('#naive').innerText()==='120,000원','mixed rate naive');
 await page.locator('#rates').screenshot({path:path.join(root,'evidence/preview-rates.png'),style:'.top{visibility:hidden!important}'});
 for(const [id,total,leaves,sunday] of [['eight-two-two','100,000원','1개','0원'],['eight-six-two','160,000원','2개','60,000원']]){
  await page.locator(`[data-split="${id}"]`).click();assert(await page.locator('#split-total').innerText()===total,'split total');assert(await page.locator('#split-leaves').innerText()===leaves,'split leave count');assert(await page.locator('#old-sat').innerText()==='20,000원','old overwrite');assert(await page.locator('#new-sat').innerText()==='100,000원','new sat sum');assert(await page.locator('#new-sun').innerText()===sunday,'sunday allocation');
 }
 await page.locator('#life-next').click();await page.locator('#life-next').click();await page.locator('#life-next').click();assert(await page.evaluate(()=>window.lifeStep)===3,'lifecycle last');assert(await page.locator('#life-next').isDisabled(),'last step disabled');await page.locator('#life-reset').click();assert(await page.evaluate(()=>window.lifeStep)===0,'lifecycle reset');
 await noOverflow('scenarios desktop');
 await open('code-review.html');assert(await page.locator('.change').count()===8,'8 changes');assert(await page.locator('[data-copy]').count()===16,'16 code copies');
 const changes=JSON.parse(fs.readFileSync(path.join(root,'source/proposal/changes.json'),'utf8'));
 for(const c of changes)for(const side of ['before','after']){await page.locator(`[data-copy="${c.id}:${side}"]`).click();assert(await page.evaluate(()=>window.__copied)===c[side],'exact code '+c.id+side);}
 await page.locator('[data-source-filter="F03"]').click();assert(await page.locator('.change:visible').count()===3,'F03 filter');await page.locator('[data-source-filter="SAVE"]').click();assert(await page.locator('.change:visible').count()===5,'SAVE filter');await page.locator('[data-source-filter="all"]').click();
 await page.locator('#SAVE-03 .compare').screenshot({path:path.join(root,'evidence/preview-code.png'),style:'.top,.toast{visibility:hidden!important}'});await noOverflow('code desktop');
 await open('transcript.html');assert(await page.locator('.message').count()===65,'65 messages');await page.locator('#conversation-role').selectOption('user');assert(await page.locator('.message:visible').count()===16,'16 users');await page.locator('#conversation-role').selectOption('all');await page.locator('#conversation-search').fill('곧바로 읽고 삭제');assert(await page.locator('.message:visible').count()>=2,'transcript search');await page.locator('#conversation-search').fill('');await page.locator('[data-copy="M062"]').click();const messages=JSON.parse(fs.readFileSync(path.join(root,'conversation/messages.json'),'utf8')).messages;assert(await page.evaluate(()=>window.__copied)===messages[61].text,'verbatim transcript copy');
 await open('source-viewer.html');const f='source/proposal/proposed/ZHR_52TM_GET_OVERTIME_SAVE.abap';await page.goto(pathToFileURL(path.join(root,'source-viewer.html')).href+'?file='+encodeURIComponent(f)+'&line=85');assert((await page.locator('#L85').innerText()).includes('jorgeh'),'source line');await page.locator('#source-copy').click();assert(await page.evaluate(()=>window.__copied)===fs.readFileSync(path.join(root,f),'utf8'),'source full copy');
 for(const name of ['index.html','scenarios.html','code-review.html','transcript.html','files.html','source-viewer.html']){
  await page.setViewportSize({width:390,height:844});await open(name);await noOverflow(name+' mobile');if(name==='index.html')await page.screenshot({path:path.join(root,'evidence/preview-mobile.png')});
 }
 assert(errors.length===0,'JS errors '+errors.join(';'));assert(network.length===0,'external requests');
 const result={status:'PASS',svg_png_pairs:svgChecks,desktop:'1500x1050',mobile:'390x844',rate_presets:5,split_presets:2,lifecycle_steps:4,changes:8,exact_code_copies:16,public_messages:65,user_messages:16,source_viewer_line_85:'PASS',verbatim_clipboard:'PASS (API mocked; OS clipboard untouched)',page_errors:errors,external_requests:network};
 fs.writeFileSync(path.join(root,'evidence/browser-check.json'),JSON.stringify(result,null,2)+'\n');console.log(JSON.stringify(result));
}finally{await browser.close();}
})().catch(e=>{console.error(e);process.exitCode=1;});
