import json,re
from html.parser import HTMLParser
from pathlib import Path

class Node:
    def __init__(self,tag='',attrs=None):self.tag=tag;self.attrs=dict(attrs or []);self.children=[]
    def text(self):return ''.join(c if isinstance(c,str) else c.text() for c in self.children)
    def find(self,tag):
        out=[]
        for c in self.children:
            if isinstance(c,Node):
                if c.tag==tag:out.append(c)
                out.extend(c.find(tag))
        return out

class Parser(HTMLParser):
    def __init__(self):super().__init__(convert_charrefs=True);self.root=Node();self.stack=[self.root]
    def handle_starttag(self,t,a):
        n=Node(t,a);self.stack[-1].children.append(n)
        if t not in ['br','hr','img','input','meta','link','source','wbr','area','base','embed','param','col']:self.stack.append(n)
    def handle_endtag(self,t):
        for i in range(len(self.stack)-1,0,-1):
            if self.stack[i].tag==t:self.stack=self.stack[:i];break
    def handle_data(self,s):self.stack[-1].children.append(s)

def md(n):
    if isinstance(n,str):return n
    t=n.tag;a=n.attrs
    if t in ['svg','style','script'] or a.get('aria-hidden')=='true':return ''
    if t=='pre':
        codes=n.find('code');code=codes[0].text() if codes else n.text()
        label=n.text().split(code)[0].strip().lower() if code else ''
        lang={'bash':'bash','python':'python','javascript':'javascript','json':'json','text':'text','plaintext':'text','markdown':'markdown'}.get(label,'text')
        fence='`'*max(3,max((len(s) for s in re.findall(r'`+',code)),default=0)+1)
        return '\n\n'+fence+lang+'\n'+code+'\n'+fence+'\n\n'
    if t=='table':
        rows=[]
        for row in n.find('tr'):
            cells=[c for c in row.children if isinstance(c,Node) and c.tag in ['th','td']]
            rows.append('| '+' | '.join(md(c).strip().replace('\n','<br>').replace('|','\\|') for c in cells)+' |')
        if rows:rows.insert(1,'| '+' | '.join('---' for _ in range(len([c for c in n.find('tr')[0].children if isinstance(c,Node) and c.tag in ['th','td']])) )+' |')
        return '\n\n'+'\n'.join(rows)+'\n\n'
    inner=''.join(md(c) for c in n.children)
    if t=='button':
        txt=n.text().strip()
        return ('['+txt+']('+txt+')') if re.search(r'\.(zip|md|json|html|pdf|png|svg|js|txt)$',txt,re.I) else ''
    if 'data-file-citation-primary-file-id' in a:
        txt=a.get('title') or n.text();return '['+txt+']('+txt+')'
    if t=='a':
        href=a.get('href','');return '['+inner+']('+href+')' if href else inner
    if t=='img':return '' if 'google.com/s2/favicons' in a.get('src','') else '!['+a.get('alt','')+']('+a.get('src','')+')'
    if t=='code':return '`'+inner+'`'
    if t in ['strong','b']:return '**'+inner+'**'
    if t in ['em','i']:return '*'+inner+'*'
    if t in ['h1','h2','h3','h4','h5','h6']:return '\n\n'+'#'*int(t[1])+' '+inner+'\n\n'
    if t=='br':return '\n'
    if t=='hr':return '\n\n---\n\n'
    if t=='li':return '\n- '+inner.strip().replace('\n','\n  ')+'\n'
    if t=='ol':
        items=[c for c in n.children if isinstance(c,Node) and c.tag=='li'];start=int(a.get('start','1'))
        return '\n'+'\n'.join(str(start+i)+'. '+''.join(md(c) for c in item.children).strip().replace('\n','\n   ') for i,item in enumerate(items))+'\n'
    if t=='ul':return '\n'+inner+'\n'
    if t=='blockquote':return '\n\n> '+inner.strip().replace('\n','\n> ')+'\n\n'
    if t=='p':return '\n\n'+inner+'\n\n'
    return inner

def convert(html):
    p=Parser();p.feed(html);out=md(p.root)
    # Collapse layout whitespace only outside fenced code.
    chunks=re.split(r'(`{3,}[^\n]*\n[\s\S]*?\n`{3,})',out)
    for i in range(0,len(chunks),2):chunks[i]=re.sub(r'\n[ \t]*\n(?:[ \t]*\n)+','\n\n',chunks[i])
    return ''.join(chunks).strip()

if __name__=='__main__':
    root=Path(__file__).parent
    for name in ['webgui','mcp','obsidian','agent']:
        raw=json.loads((root/(name+'.json')).read_text());turns=[]
        for t in raw['turns']:
            texts=[convert(m['html']) for m in t['messages']]
            if not texts and t.get('progress'):texts=[convert(m['html']) for m in t['progress']]
            t['content_markdown']='\n\n'.join(texts).strip()
            if t['role']=='user':t['content_markdown']=t['content_markdown'].replace('이미지 업로드됨','').strip()
            turns.append(t)
        (root/(name+'-converted.json')).write_text(json.dumps(raw,ensure_ascii=False,indent=2))
        (root/(name+'-review.md')).write_text('\n\n'.join('## Turn '+str(t['index'])+' '+t['role']+'\n\n'+t['content_markdown'] for t in turns))
