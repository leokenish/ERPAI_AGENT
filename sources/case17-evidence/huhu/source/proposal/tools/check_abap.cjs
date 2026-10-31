/* v700 parser only. Does not activate SAP or resolve its DDIC/FMs. */
const fs=require('fs'),path=require('path');
const moduleDir=process.env.ABAP_VALIDATION_MODULES||'/private/tmp/zhr5-abap-validation/node_modules';
const core=require(path.join(moduleDir,'@abaplint/core'));
const root=path.resolve(__dirname,'..');
const f03=fs.readFileSync(path.join(root,'proposed/LZHR008_2F03.abap'),'utf8');
const start=f03.indexOf('FORM calc_work_time_daily TABLES');
const end=f03.indexOf('ENDFORM.',start)+'ENDFORM.'.length;
if(start<0||end<start)throw Error('Target FORM not found');
const sources={
  'zhr_jorgeh_form.prog.abap':f03.slice(start,end)+'\n',
  'zhr_jorgeh_save.prog.abap':fs.readFileSync(path.join(root,'proposed/ZHR_52TM_GET_OVERTIME_SAVE.abap'),'utf8')
};
const config=new core.Config(JSON.stringify({global:{files:'/src/**/*.*'},syntax:{version:'v700',errorNamespace:'^$'},rules:{parser_error:true}}));
const registry=new core.Registry(config);
for(const [name,source]of Object.entries(sources))registry.addFile(new core.MemoryFile(name,source));
registry.parse();
const issues=registry.findIssues().map(i=>({file:i.getFilename(),line:i.getStart().getRow(),message:i.getMessage(),rule:i.getKey()}));
const report={tool:'@abaplint/core',version:JSON.parse(fs.readFileSync(path.join(moduleDir,'@abaplint/core/package.json'))).version,language:'v700',status:issues.length?'FAIL':'PASS',scope:'target FORM and function grammar only; no SAP DDIC/FMs/activation/execution',issues};
fs.writeFileSync(path.join(root,'checks/grammar.json'),JSON.stringify(report,null,2)+'\n');
console.log(JSON.stringify(report));process.exitCode=issues.length?1:0;
