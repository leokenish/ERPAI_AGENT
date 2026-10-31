#!/usr/bin/env python3
from pathlib import Path
from datetime import datetime
from zoneinfo import ZoneInfo
from html.parser import HTMLParser
from urllib.parse import urlsplit,unquote
import hashlib,json,zipfile,re
ROOT=Path.cwd(); OUT=ROOT/'training-exports/20261030-compare-thread'
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def jsave(p,d):p.write_text(json.dumps(d,ensure_ascii=False,indent=2)+'\n')
data=json.loads((OUT/'reports/change-map.json').read_text())
line_count=0
for e in data:
 for side in ['before','after']:
  if e[side+'_path']:
   p=OUT/e[side+'_path'];assert p.read_text()==e[side],p
   assert digest(p)==e[side+'_sha256']
 for h in e['hunks']:
  for a,s,b,t,tag in h['rows']:
   if a is not None:assert e['before'].splitlines()[a-1]==s;line_count+=1
   if b is not None:assert e['after'].splitlines()[b-1]==t;line_count+=1
   if tag=='equal':assert s==t
class Links(HTMLParser):
 def __init__(self):super().__init__();self.targets=[]
 def handle_starttag(self,tag,attrs):
  for k,v in attrs:
   if k in ('href','src') and v:self.targets.append(v)
bad=[];linkcount=0
for p in [OUT/'index.html',OUT/'reports/code-comparison.html',OUT/'reports/decisions.html',OUT/'conversation/transcript.html']:
 q=Links();q.feed(p.read_text())
 for target in q.targets:
  u=urlsplit(target)
  if u.scheme or not u.path:continue
  dest=(p.parent/unquote(u.path)).resolve()
  if dest.name in ('manifest.json','SHA256SUMS.txt'):continue
  linkcount+=1
  if not dest.is_relative_to(OUT.resolve()) or not dest.exists():bad.append([str(p),target])
assert not bad,bad
snapshots=[]
for p in (OUT/'workspace').rglob('*'):
 if p.is_file():
  original=ROOT/p.relative_to(OUT/'workspace');assert p.read_bytes()==original.read_bytes(),original
  snapshots.append({'file':str(p.relative_to(OUT)),'sha256':digest(p)})
coverage=json.loads((OUT/'evidence/coverage.json').read_text())
msgs=json.loads((OUT/'conversation/messages.json').read_text())['messages']
assert len(msgs)==34 and sum(m['role']=='user' for m in msgs)==10
assert {m['role'] for m in msgs}=={'user','assistant'}
assert all(m['phase'] in ('user','commentary','final_answer','final','question') for m in msgs)
assert coverage['images_found']==0
ui=json.loads((OUT/'evidence/ui-validation.json').read_text());assert ui['status']=='PASS'
checks={'status':'PASS_WITH_DOCUMENTED_MISSING_ATTACHMENT','date_kst':'2026-10-31','visible_messages':len(msgs),'source_entries':len(data),'diff_hunks':sum(len(e['hunks']) for e in data),'validated_source_line_references':line_count,'local_entry_html_links_checked':linkcount,'broken_entry_links':bad,'workspace_snapshot_files_byte_equal':len(snapshots),'posted_abap_sha256_matches_current':True,'html_visual_review':'PASS: desktop index, side-by-side diff; mobile index overflow test','ui_checks':ui['checks'],'missing_originals':coverage['unavailable_originals'],'uploaded_images_found':0,'original_source_modified':False,'sap_syntax_execution':'NOT_RUN','scope_note':'Existing Markdown source snapshots retain repository links outside the selected bundle. UI entry links are portable. Private reasoning, internal instructions and raw execution logs are excluded.'}
jsave(OUT/'evidence/package-validation.json',checks)
jsave(OUT/'evidence/source-hashes.json',snapshots)
files=[p for p in OUT.rglob('*') if p.is_file() and p.name not in ('.DS_Store','manifest.json','SHA256SUMS.txt')]
manifest={'package':'ZHR5 선택근무 정산 비교 교육자료','created_date_kst':'2026-10-31','conversation_cutoff_kst':coverage['cutoff'],'thread_id':coverage['thread_id'],'entrypoint':'index.html','handoff':'PORTAL_HANDOFF.md','files':[{'path':str(p.relative_to(OUT)),'bytes':p.stat().st_size,'sha256':digest(p)} for p in sorted(files)]}
jsave(OUT/'manifest.json',manifest)
files.append(OUT/'manifest.json')
(OUT/'SHA256SUMS.txt').write_text(''.join(digest(p)+'  '+str(p.relative_to(OUT))+'\n' for p in sorted(files)))
files.append(OUT/'SHA256SUMS.txt')
zip_path=ROOT/'training-exports/ZHR5_선택근무_정산비교_교육자료_20261031.zip'
with zipfile.ZipFile(zip_path,'w',zipfile.ZIP_DEFLATED,compresslevel=9) as z:
 for p in sorted(files):z.write(p,arcname='ZHR5_선택근무_정산비교_교육자료/'+str(p.relative_to(OUT)))
with zipfile.ZipFile(zip_path) as z:
 assert z.testzip() is None
 assert len(z.namelist())==len(files)
 for p in files:assert z.read('ZHR5_선택근무_정산비교_교육자료/'+str(p.relative_to(OUT)))==p.read_bytes()
zip_path.with_suffix('.zip.sha256').write_text(digest(zip_path)+'  '+zip_path.name+'\n')
print(json.dumps({'zip':str(zip_path),'zip_bytes':zip_path.stat().st_size,'zip_sha256':digest(zip_path),'zip_files':len(files),'verified_line_references':line_count,'verified_workspace_snapshots':len(snapshots),'entry_links':linkcount,'zip_integrity':'PASS','missing_originals':coverage['unavailable_originals']},ensure_ascii=False))
