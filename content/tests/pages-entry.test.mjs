import test from 'node:test';
import assert from 'node:assert/strict';
import vm from 'node:vm';
import {readFile} from 'node:fs/promises';

test('Pages 진입점은 최신 dist로 이동하고 프로젝트 하위 경로·검색·대화 주소를 보존한다',async()=>{
 const html=await readFile(new URL('../index.html',import.meta.url),'utf8');
 const source=html.match(/<script>([\s\S]*?)<\/script>/)[1];
 for(const [href,expected] of [
  ['https://example.org/KBS_ERPEDU/?from=test#/conversations/kbs-erp-mcp-telegram/E02','https://example.org/KBS_ERPEDU/dist/?from=test#/conversations/kbs-erp-mcp-telegram/E02'],
  ['file:///C:/ERP_EDU/index.html#/home','file:///C:/ERP_EDU/preview.html#/home']
 ]){
  const url=new URL(href);let result;
  vm.runInNewContext(source,{URL,location:{href,protocol:url.protocol,search:url.search,hash:url.hash,replace(value){result=value;}}});
  assert.equal(result,expected);
 }
});
