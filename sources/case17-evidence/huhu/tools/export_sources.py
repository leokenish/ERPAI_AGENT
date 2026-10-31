"""Export this chat's public messages and relevant files; never export reasoning/system logs."""
from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
from collections import Counter
import json, hashlib, re, shutil, base64

OUT=Path(__file__).resolve().parents[1]
ROOT=OUT.parents[1]
THREAD='01a18fb3-b11e-7e81-9e2b-0dd285be3d6f'
LOG=Path.home()/f'.codex/sessions/2026/10/31/rollout-2026-10-31T11-04-40-{THREAD}.jsonl'
TITLE='휴휴 대휴 정산 절차 검토'
PROPOSAL=Path('proposals/20261031-huhu-jorgeh-comparison')

def write(name,text):
 p=OUT/name;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(text,encoding='utf-8')
def jwrite(name,obj):write(name,json.dumps(obj,ensure_ascii=False,indent=2)+'\n')
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def copy(p,dst):
 dest=OUT/dst;dest.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,dest)
def fnv(text):
 h=2166136261;b=text.encode('utf-16-le')
 for i in range(0,len(b),2):h=((h^int.from_bytes(b[i:i+2],'little'))*16777619)&0xffffffff
 return f'{h:08x}'

messages=[];excluded=Counter();images=[];unknown=[];cutoff=None
for line_no,line in enumerate(LOG.open(),1):
 d=json.loads(line);v=d.get('payload',{})
 if d.get('type')!='response_item' or v.get('type')!='message':continue
 role=v.get('role');phase=v.get('phase') or 'user'
 if role not in ('user','assistant'):continue
 if role=='assistant' and phase not in ('commentary','final_answer','final'):continue
 content=v.get('content',[])
 text='\n'.join(c.get('text','') for c in content if c.get('type') in ('input_text','output_text'))
 if role=='user' and text.lstrip().startswith(('# AGENTS.md instructions','<environment_context>','<external_codex_apps_open_page>')):
  excluded['automatic_workspace_context']+=1;continue
 m={'number':len(messages)+1,'role':role,'phase':phase,'id':v.get('id'),'text':text,
    'timestamp':d['timestamp'],'timestamp_kst':datetime.fromisoformat(d['timestamp'].replace('Z','+00:00')).astimezone(ZoneInfo('Asia/Seoul')).isoformat(),'source_record':line_no}
 for c in content:
  if c.get('type') in ('input_text','output_text'):continue
  if 'image' in c.get('type',''):images.append({'message':m['number'],'content':c})
  else:unknown.append({'message':m['number'],'type':c.get('type')})
 messages.append(m)
 if role=='user' and '이 모든 소스들을 정리해서 압축파일로 만들어줘' in text:
  cutoff=d['timestamp'];break
assert cutoff and messages[0]['text'].startswith('선택근무는 반기별로')
assert not unknown,unknown
jwrite('conversation/messages.json',{'thread_id':THREAD,'title':TITLE,'cutoff':cutoff,'messages':messages})
md=['# '+TITLE,'','수록 범위: 최초 요청부터 교육자료 압축 요청까지. 사용자·AI의 공개 발화 원문을 교정하거나 축약하지 않았습니다.','']
for m in messages:
 md+=['---','',f"## M{m['number']:03d} · {'사용자' if m['role']=='user' else 'AI'} · {m['phase']} · {m['timestamp_kst']}",'',m['text'],'']
write('conversation/transcript.md','\n'.join(md));write('conversation/transcript.txt','\n'.join(md))

# App API cross-check covers every public message up to the request cutoff.
receipt=json.loads((OUT/'evidence/app-thread-receipt.json').read_text())
app=receipt['messages'];assert len(app)>=len(messages)
for m,a in zip(messages,app):
 assert m['role']==a['role'] and fnv(m['text'])==a['fnv1a_utf16'],(m['number'],a)
cut=len(messages)
jwrite('evidence/conversation-coverage.json',{'thread_id':THREAD,'title':TITLE,'first_timestamp':messages[0]['timestamp'],'cutoff':cutoff,
 'message_count':len(messages),'user_messages':sum(m['role']=='user' for m in messages),'assistant_messages':sum(m['role']=='assistant' for m in messages),
 'phases':dict(Counter(m['phase'] for m in messages)),'app_api_cross_check':'PASS','app_pages':receipt['pages'],
 'excluded_automatic_context':dict(excluded),'user_uploaded_image_count':len(images),'unprocessed_content_types':unknown,
 'scope':'Public user messages and assistant final/commentary messages; no private reasoning, system/developer prompts, compacted summaries or raw tool logs.',
 'note':'Packaging progress after this request and its delivery response are outside the fixed cutoff.'})
# Keep only a bounded receipt, not the live packaging conversation.
receipt['messages']=app[:cut];jwrite('evidence/app-thread-receipt.json',receipt)

assert not images,'Attachment extraction must be implemented if this thread has image content.'
text_refs=[]
for m in messages:
 if m['role']=='user':
  text_refs += [{'message':m['number'],'reference':x} for x in re.findall(r'[^\s<>"\']+\.(?:png|jpg|jpeg|webp|gif)\b',m['text'],re.I)]
jwrite('attachments/inventory.json',{'user_uploaded_images':images,'user_text_image_references':text_refs,
 'status':'NO_USER_IMAGE_ATTACHMENTS_IN_THIS_THREAD','generated_assets':'../assets/visuals/','prior_report_captures':'../source/proposal/checks/',
 'note':'다른 방의 캡처를 이 방의 첨부로 대신 넣지 않았다. 새 도식·보고서 캡처는 사용자 첨부와 구별한다.'})
write('attachments/README.md','# 첨부 이미지 확인 결과\n\n이 방의 최초 메시지부터 압축 요청까지 사용자 업로드 이미지 기록은 0건입니다. 다른 방 이미지는 포함하지 않았습니다. 이전 보고서의 캡처 3개는 `source/proposal/checks/`, 교육용으로 새로 만든 SVG·PNG는 `assets/visuals/`에 있습니다.\n')

# Every public fenced code block is retained, including obsolete examples.
blocks=[]
for m in messages:
 for i,match in enumerate(re.finditer(r'```([^\n]*)\n(.*?)```',m['text'],re.S),1):
  language=match[1].strip();ext={'abap':'abap','python':'py','javascript':'js','json':'json'}.get(language,'txt')
  name=f"conversation/code-blocks/M{m['number']:03d}-{i}.{ext}";write(name,match[2])
  blocks.append({'message':m['number'],'language':language,'file':name,'lines':len(match[2].splitlines()),'sha256':hashlib.sha256(match[2].encode()).hexdigest(),'status':'historical_conversation_example'})
jwrite('conversation/code-blocks/index.json',blocks)

# Copy proposal and investigation artifacts. Never alter exports or the proposal being taught.
copied=[]
for src,dst in [(ROOT/PROPOSAL,Path('source/proposal')),(ROOT/'reviews/20261031-huhu-jorgeh',Path('research/reviews'))]:
 for p in src.rglob('*'):
  if p.is_file() and p.name!='.DS_Store' and '__pycache__' not in p.parts:
   dest=dst/p.relative_to(src);copy(p,dest);copied.append({'source':str(p.relative_to(ROOT)),'file':str(dest),'sha256':digest(p),'kind':'proposal' if dst.parts[0]=='source' else 'research'})
docs=['knowledge/processes/huhu-jorgeh-investigation.md','knowledge/OPEN_QUESTIONS.md','docs/EXPORT_GUIDE.md','knowledge/reference/erp-environment.md']
docs += [str(p.relative_to(ROOT)) for p in sorted((ROOT/'harness/feedback').glob('FB-20261031-00[1-6].md'))]
for name in docs:
 p=ROOT/name;dst=Path('research/workspace')/name;copy(p,dst);copied.append({'source':name,'file':str(dst),'sha256':digest(p),'kind':'context'})

# Resolve linked local evidence without rewriting original message text.
links={};missing=[]
for m in messages:
 for match in re.finditer(r'\]\((?:<([^>]+)>|(/[^)]+))\)',m['text']):
  original=match[1] or match[2]
  if not original.startswith(str(ROOT)):continue
  s=original.split('#',1)[0];num=re.search(r':(\d+)$',s);line=int(num[1]) if num else None
  if num:s=s[:num.start()]
  src=Path(s);canonical=None
  if not src.exists():
   # One historical answer omitted the function group in its NORM link.
   hits=list((ROOT/'exports/ZHR5/packages').rglob(src.name)) if src.suffix=='.abap' else []
   hits=[h for h in hits if '/Source code/' in str(h)]
   if len(hits)==1:canonical=str(hits[0]);src=hits[0]
   else:missing.append({'message':m['number'],'target':original,'reason':'historical link target absent'});continue
  if not src.is_file():continue
  rel=src.relative_to(ROOT)
  if str(rel).startswith(str(PROPOSAL)):
   dst=Path('source/proposal')/rel.relative_to(PROPOSAL)
  else:
   dst=Path('source/evidence')/rel;copy(src,dst)
   copied.append({'source':str(rel),'file':str(dst),'sha256':digest(src),'kind':'read_only_evidence'})
  links[original]={'file':str(dst),'line':line,'canonical_correction':canonical}
jwrite('conversation/local-link-map.json',links)
jwrite('evidence/historical-link-issues.json',{'missing':missing,'navigation_corrections':{k:v for k,v in links.items() if v['canonical_correction']},'note':'Original public text is unchanged. Only educational navigation can use the verified canonical path.'})
unique={x['file']:x for x in copied};jwrite('evidence/copied-files.json',list(unique.values()))
print(json.dumps({'messages':len(messages),'users':sum(m['role']=='user' for m in messages),'images':len(images),'code_blocks':len(blocks),'copied_files':len(unique),'missing_historical_links':len(missing)},ensure_ascii=False))
