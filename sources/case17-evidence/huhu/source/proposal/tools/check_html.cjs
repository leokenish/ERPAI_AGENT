const fs=require('fs'),path=require('path');
const {pathToFileURL}=require('url');
const {chromium}=require('/Users/naviolgu/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const root=path.resolve(__dirname,'..');
const assert=(condition,message)=>{if(!condition)throw Error(message);};
(async()=>{
 const browser=await chromium.launch({executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',headless:true});
 try{
  const context=await browser.newContext({viewport:{width:1600,height:1100},deviceScaleFactor:1});
  const page=await context.newPage();const errors=[];const network=[];
  page.on('pageerror',e=>errors.push(e.message));
  page.on('request',r=>{if(/^https?:/.test(r.url()))network.push(r.url());});
  await page.addInitScript(()=>{
   Object.defineProperty(navigator,'clipboard',{configurable:true,value:{writeText:async text=>{window.__copied=text;}}});
  });
  await page.goto(pathToFileURL(path.join(root,'report.html')).href);
  assert(await page.locator('.change-card').count()===8,'eight comparison cards');
  assert(await page.locator('[data-copy]').count()===16,'sixteen copy buttons');
  const expected=JSON.parse(fs.readFileSync(path.join(root,'changes.json'),'utf8'));
  for(const c of expected){
   for(const side of ['before','after']){
    await page.locator(`[data-copy="${c.id}:${side}"]`).click();
    assert(await page.evaluate(()=>window.__copied)===c[side],`copy exact ${c.id}:${side}`);
   }
  }
  await page.locator('[data-filter="F03"]').click();
  assert(await page.locator('.change-card:visible').count()===3,'F03 filter');
  await page.locator('[data-filter="SAVE"]').click();
  assert(await page.locator('.change-card:visible').count()===5,'SAVE filter');
  await page.locator('[data-filter="all"]').click();
  // Test the file/offline fallback without changing the user's OS clipboard.
  await page.evaluate(()=>{
   Object.defineProperty(navigator,'clipboard',{configurable:true,value:undefined});
   document.execCommand=command=>{window.__fallbackCopied=document.querySelector('textarea').value;return command==='copy';};
  });
  await page.locator('[data-copy="SAVE-05:after"]').click();
  assert(await page.evaluate(()=>window.__fallbackCopied)===expected.find(x=>x.id==='SAVE-05').after,'fallback copy exact');
  const boxes=await page.locator('#F03-03 .code-pane').evaluateAll(items=>items.map(x=>({x:x.getBoundingClientRect().x,y:x.getBoundingClientRect().y,width:x.getBoundingClientRect().width})));
  assert(boxes[0].x<boxes[1].x&&Math.abs(boxes[0].y-boxes[1].y)<1,'desktop side by side');
  assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1),'desktop page overflow');
  await page.evaluate(()=>scrollTo({top:0,left:0,behavior:'instant'}));
  await page.waitForFunction(()=>scrollY===0);
  await page.screenshot({path:path.join(root,'checks/report-desktop.png'),style:'.toast { visibility: hidden !important; }'});
  await page.locator('#SAVE-03').screenshot({path:path.join(root,'checks/report-comparison.png'),style:'.topbar,.toast { visibility: hidden !important; }'});
  await page.setViewportSize({width:390,height:844});
  await page.evaluate(()=>scrollTo({top:0,left:0,behavior:'instant'}));
  await page.waitForFunction(()=>scrollY===0);
  assert(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1),'mobile page overflow');
  await page.screenshot({path:path.join(root,'checks/report-mobile.png'),style:'.toast { visibility: hidden !important; }'});
  assert(errors.length===0,'page JavaScript errors: '+errors.join(';'));
  assert(network.length===0,'external network requests');
  const report={status:'PASS',viewport_desktop:'1600x1100',viewport_mobile:'390x844',comparison_cards:8,copy_buttons:16,clipboard_tests:'exact code payloads; Clipboard API and execCommand fallback mocked to avoid changing OS clipboard',source_filters:'PASS',desktop_columns:'PASS',page_overflow:'NONE',page_errors:errors,external_requests:network,screenshots:['report-desktop.png','report-comparison.png','report-mobile.png']};
  fs.writeFileSync(path.join(root,'checks/html.json'),JSON.stringify(report,null,2)+'\n');console.log(JSON.stringify(report));
 }finally{await browser.close();}
})().catch(e=>{console.error(e);process.exitCode=1;});
