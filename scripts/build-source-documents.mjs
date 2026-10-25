import {readFile,readdir,mkdir,writeFile,realpath} from 'node:fs/promises';
import path from 'node:path';
import {createHash} from 'node:crypto';
import {makeZip} from './build-knowledge.mjs';

// Only the explicitly catalogued project roots are published, and only MD.
// Original bytes, line endings, filenames and relative ZIP paths are retained.
export async function buildSourceDocuments(root,out,sources){
 const sourceRoot=await realpath(path.join(root,'sources'));
 for(const source of sources){
  if(!/^[a-z0-9-]+$/.test(source.id)||!source.path.startsWith('sources/'))throw Error('Invalid source catalog entry');
  const directory=await realpath(path.join(root,source.path));
  if(!directory.startsWith(sourceRoot+path.sep))throw Error('Source directory escapes sources/');
  const entries=[];
  async function walk(dir){
   for(const entry of (await readdir(dir,{withFileTypes:true})).sort((a,b)=>a.name<b.name?-1:a.name>b.name?1:0)){
    const file=path.join(dir,entry.name);
    if(entry.isSymbolicLink())throw Error(`Source symlink is not supported: ${file}`);
    if(entry.isDirectory())await walk(file);
    else if(entry.isFile()&&/\.md$/i.test(entry.name))entries.push({name:path.relative(directory,file).split(path.sep).join('/'),bytes:await readFile(file)});
   }
  }
  await walk(directory);
  const downloadRoot=`downloads/source-md/${source.id}`;
  await mkdir(path.join(out,downloadRoot),{recursive:true});
  source.mdDocuments=[];
  for(const [index,entry] of entries.entries()){
   const download=`${downloadRoot}/${String(index+1).padStart(4,'0')}.md`;
   await writeFile(path.join(out,download),entry.bytes);
   source.mdDocuments.push({path:entry.name,name:path.posix.basename(entry.name),download,bytes:entry.bytes.length,sha256:createHash('sha256').update(entry.bytes).digest('hex')});
  }
  source.mdCount=entries.length;
  source.mdArchive=`${downloadRoot}/${source.id}_MD.zip`;
  await writeFile(path.join(out,source.mdArchive),makeZip(entries));
 }
 console.log(`Source MD downloads: ${sources.map(s=>`${s.id}=${s.mdCount}`).join(', ')}`);
}
