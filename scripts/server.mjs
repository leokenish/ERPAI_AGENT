import {createServer} from 'node:http';
import {readFile,realpath,stat} from 'node:fs/promises';
import path from 'node:path';
import {fileURLToPath,pathToFileURL} from 'node:url';
const root=path.resolve(path.dirname(fileURLToPath(import.meta.url)),'../dist');
const types={'.html':'text/html; charset=utf-8','.js':'text/javascript; charset=utf-8','.css':'text/css; charset=utf-8','.json':'application/json; charset=utf-8','.md':'text/markdown; charset=utf-8','.svg':'image/svg+xml','.png':'image/png','.jpg':'image/jpeg','.woff2':'font/woff2','.ttf':'font/ttf','.otf':'font/otf','.zip':'application/zip','.py':'text/plain; charset=utf-8'};
export function makeServer(directory=root){
 return createServer(async(req,res)=>{
  res.setHeader('X-Content-Type-Options','nosniff');
  res.setHeader('Referrer-Policy','same-origin');
  res.setHeader('Content-Security-Policy',"default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self' data:; font-src 'self'; connect-src 'self'; object-src 'none'; base-uri 'self'; frame-ancestors 'none'");
  res.setHeader('Cache-Control','no-cache');
  const fail=(status,text)=>{res.writeHead(status,{'Content-Type':'text/plain; charset=utf-8'});res.end(text);};
  if(!['GET','HEAD'].includes(req.method)){res.setHeader('Allow','GET, HEAD');return fail(405,'Method not allowed');}
  try{
   const raw=decodeURIComponent((req.url||'/').split('?')[0]);
   if(raw.includes('\0')||raw.includes('\\')||raw.split('/').some(s=>s.startsWith('.')&&s!==''))return fail(403,'Forbidden');
   if(raw==='/health'){res.writeHead(200,{'Content-Type':'application/json'});return res.end(req.method==='HEAD'?undefined:'{"status":"ok"}');}
   const parts=raw.split('/').filter(Boolean);
   if(parts.some(s=>['sources','scripts','vendor','docs','tests','node_modules'].includes(s)))return fail(403,'Forbidden');
   const relative=parts.join('/')||'index.html';
   const base=await realpath(directory);
   const file=await realpath(path.join(base,relative));
   if(!file.startsWith(base+path.sep))return fail(403,'Forbidden');
   const info=await stat(file);if(!info.isFile())return fail(404,'Not found');
   const body=req.method==='HEAD'?null:await readFile(file);
   res.setHeader('Content-Type',types[path.extname(file)]||'application/octet-stream');
   res.setHeader('Content-Length',info.size);
   // Let the source MD link's download attribute retain its original filename.
   if(relative.startsWith('downloads/source-md/')&&path.extname(file)==='.md')res.setHeader('Content-Disposition','attachment');
   else if(relative.startsWith('downloads/'))res.setHeader('Content-Disposition',`attachment; filename="${path.basename(file)}"`);
   res.statusCode=200;res.end(body);
  }catch(e){return fail(e instanceof URIError?400:404,e instanceof URIError?'Bad request':'Not found');}
 });
}
export function start(){
 const host=process.env.HOST||(process.argv.includes('--lan')?'0.0.0.0':'127.0.0.1');
 const port=Number(process.env.PORT||8080);
 if(!Number.isInteger(port)||port<1||port>65535)throw Error('PORT must be 1–65535');
 const server=makeServer();
 server.on('error',e=>{console.error(`Portal failed to start: ${e.message}`);process.exitCode=1;});
 server.listen(port,host,()=>console.log(`ERP AI 에이전트 · http://${host}:${port} · dist/ only`));
 for(const signal of ['SIGINT','SIGTERM'])process.on(signal,()=>server.close(()=>process.exit(0)));
 return server;
}
if(process.argv[1]&&import.meta.url===pathToFileURL(path.resolve(process.argv[1])).href)start();
