from pathlib import Path
import re,json,hashlib,zipfile
from html.parser import HTMLParser
from urllib.parse import unquote,urlsplit
p=Path(__file__).resolve().parent.parent
(p/'checksums.json').write_text('{}\n')
report=(p/'code-report.html').read_text();data=json.loads(re.search(r'const data=(.*?);\nconst \$=',report,re.S).group(1))
checks={};checks['report_latest_equals_abap']=data[-1]['after']==(p/'sources/versions/v3-current-two-tables.abap').read_text();checks['report_original_equals_snapshot']=data[-1]['before']==(p/'sources/versions/v2-delivered-three-tables.abap').read_text()
for f in data:
 for h in f['hunks']:
  for row in h['rows']:
   for side,num,text in [('before',row[0],row[1]),('after',row[2],row[3])]:
    if num!='':assert f[side].splitlines()[num-1]==text
checks['all_diff_line_numbers_match']=True
class Links(HTMLParser):
 def __init__(self):super().__init__();self.links=[]
 def handle_starttag(self,tag,attrs):
  for k,v in attrs:
   if k in ('href','src') and v:self.links.append(v)
broken=[]
for f in [p/'index.html',p/'code-report.html',*list((p/'reports').glob('*.html'))]:
 parser=Links();parser.feed(f.read_text())
 for v in parser.links:
  u=urlsplit(v)
  if u.scheme or not u.path:continue
  if not (f.parent/unquote(u.path)).exists():broken.append((str(f),v))
checks['offline_html_links_exist']=not broken
checks['latest_abap_snapshot_matches_workspace']=(p/'sources/proposal/ZHR_CW_MEMBER_DEL.abap').read_bytes()==(p/'sources/versions/v3-current-two-tables.abap').read_bytes()
checks['transcript_message_count']=len(json.loads((p/'conversation/messages.json').read_text()))==24
checks['no_images_claimed']=json.loads((p/'manifest.json').read_text())['image_attachment_count']==0
assert all(checks.values()),checks
script=report.split('<script>',1)[1].split('</script>',1)[0];Path('/private/tmp/zhr-training-report-check.js').write_text(script)
r={'checks':checks,'broken_links':broken,'browser_render':'NOT_RUN: local file URL blocked by browser policy; no workaround attempted','javascript_syntax':'Run node --check separately','sap_execution':'NOT_RUN'}
(p/'package-validation.json').write_text(json.dumps(r,ensure_ascii=False,indent=2)+'\n');print(json.dumps(r,ensure_ascii=False,indent=2))
