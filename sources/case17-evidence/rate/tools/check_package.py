"""Package integrity and local HTML link/code-line checks; stdlib only."""
from pathlib import Path
from html.parser import HTMLParser
from urllib.parse import unquote,urlsplit
import json,hashlib,re
root=Path(__file__).resolve().parents[1]
class Links(HTMLParser):
 def __init__(self):super().__init__();self.links=[];self.ids=set();self.remote=[]
 def handle_starttag(self,tag,attrs):
  a=dict(attrs)
  if 'id' in a:self.ids.add(a['id'])
  for key in ['href','src']:
   if key in a:self.links.append(a[key])
manifest=json.loads((root/'manifest.json').read_text())
errors=[]
for item in manifest['files']:
 p=root/item['path']
 if not p.exists() or hashlib.sha256(p.read_bytes()).hexdigest()!=item['sha256']:
  errors.append('hash mismatch: '+item['path'])
parsers={}
# Reference report is external example, not our generated report.
for p in root.rglob('*.html'):
 if 'reference' in p.parts:continue
 parser=Links();parser.feed(p.read_text());parsers[p.resolve()]=parser
for p,parser in parsers.items():
 for link in parser.links:
  u=urlsplit(link)
  if u.scheme or u.netloc:
   if u.scheme in ('http','https'):errors.append('external dependency '+link)
   continue
  target=(p.parent/unquote(u.path)).resolve() if u.path else p
  if not target.exists():errors.append('missing '+str(p)+' -> '+link)
  if u.fragment and target in parsers and unquote(u.fragment) not in parsers[target].ids:
   errors.append('missing fragment '+link)
for v in manifest['versions']:
 p=root/v['path']; text=p.read_text()
 assert len(text.splitlines())==v['line_count']
 full=parsers[(root/'reports/full-source.html').resolve()]
 for i in range(1,v['line_count']+1):
  if v['id']+'-L'+str(i) not in full.ids:errors.append('missing code line '+v['id']+' '+str(i))
data=json.loads((root/'reports/change-index.json').read_text())
for c in data:
 if c['before_path']!='없음':assert (root/c['before_path']).read_text()==c['before']
 assert (root/c['after_path']).read_text()==c['after']
messages=json.loads((root/'conversation/messages.json').read_text())
assert len(messages['messages'])==messages['metadata']['message_count']
assert all(m['role'] in ('user','assistant') for m in messages['messages'])
assert all((root/image).exists() for m in messages['messages'] for image in m['images'])
report={'status':'PASS' if not errors else 'FAIL','manifest_files':len(manifest['files']),
 'generated_html_files':len(parsers),'messages':len(messages['messages']),
 'code_versions':len(manifest['versions']),'comparison_sections':len(data),
 'checks':['SHA256','local HTML href/src/anchors','all source line IDs','before/after complete code','message and image counts'],
 'errors':errors,'sap_validation':'NOT_RUN'}
(root/'package-check.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
print(json.dumps(report,ensure_ascii=False,indent=2));raise SystemExit(bool(errors))
