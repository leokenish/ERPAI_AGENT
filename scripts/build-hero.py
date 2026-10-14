"""Wrap repaired transparent PNGs in SVG and add independent monitor UI.

The generated PNG bytes are embedded unchanged. Pixel reads identify blank
screen interiors only; no recoloring, image masking, resampling or PNG edits.
All animated cards are native vector paths clipped to the shared safe interior.
Optional regeneration requires Pillow, NumPy and SciPy. Normal Node build does not.
"""
from pathlib import Path
from base64 import b64encode
from html import escape
import hashlib, json
import numpy as np
from PIL import Image
from scipy import ndimage as ndi

ROOT=Path(__file__).resolve().parents[1]
SOURCES={theme:ROOT/f'docs/design/base/team-{theme}-repaired-v153.png' for theme in ['light','dark']}
images={t:np.array(Image.open(p)) for t,p in SOURCES.items()}
H,W=images['light'].shape[:2]
assert images['light'].shape==images['dark'].shape

def trace(mask):
    edges={}
    def add(a,b):edges.setdefault(a,[]).append(b)
    yy,xx=np.nonzero(mask);h,w=mask.shape
    for y,x in zip(yy.tolist(),xx.tolist()):
        if y==0 or not mask[y-1,x]:add((x,y),(x+1,y))
        if x==w-1 or not mask[y,x+1]:add((x+1,y),(x+1,y+1))
        if y==h-1 or not mask[y+1,x]:add((x+1,y+1),(x,y+1))
        if x==0 or not mask[y,x-1]:add((x,y+1),(x,y))
    paths=[]
    while edges:
        start=next(iter(edges));cur=start;pts=[start]
        while True:
            nxt=edges[cur].pop()
            if not edges[cur]:del edges[cur]
            cur=nxt
            if cur==start:break
            pts.append(cur)
        simple=[]
        for i,p in enumerate(pts):
            a=pts[i-1];b=pts[(i+1)%len(pts)]
            if (p[0]-a[0])*(b[1]-p[1])!=(p[1]-a[1])*(b[0]-p[0]):simple.append(p)
        if len(simple)>2:paths.append('M'+' L'.join(f'{x} {y}' for x,y in simple)+'Z')
    return ' '.join(paths)

# Each plane maps local 0..100 coordinates to the original isometric screen.
SCREENS=[
 {'id':'left','seed':(250,510),'plane':(210,500,.98,-.50,0,.80),'count':5,'cycle':6.6,'phase':-.8},
 {'id':'middle','seed':(680,480),'plane':(633,397,1.10,.63,0,.98),'count':6,'cycle':7.5,'phase':-3.7},
 {'id':'right','seed':(1015,530),'plane':(966,449,1.08,.63,0,.94),'count':5,'cycle':6.9,'phase':-5.0},
 {'id':'front','seed':(790,730),'plane':(699,625,1.18,.67,0,.90),'count':5,'cycle':8.2,'phase':-1.9},
 {'id':'chart','seed':(1380,650),'plane':(1354,615,.47,.28,0,.46),'count':1,'cycle':6.2,'phase':-2.4},
 {'id':'tablet','seed':(1126,504),'plane':(1107,486,.28,.13,.08,.18),'count':1,'cycle':7.8,'phase':-4.4},
]
labels={}
for theme,a in images.items():
    r,g,b=a[:,:,:3].transpose(2,0,1)
    if theme=='dark':m=(r>15)&(r<55)&(g>25)&(g<72)&(b>45)&(b<110)&(a[:,:,3]>220)
    else:m=(r>224)&(g>224)&(b>224)&(a[:,:,3]>220)
    labels[theme]=ndi.label(m)[0]

for screen in SCREENS:
    x,y=screen['seed'];selected=[]
    for theme,ls in labels.items():
        if screen['id']=='tablet':
            a=images[theme];r,g,b=a[:,:,:3].transpose(2,0,1)
            m=((r>120)&(r<195)&(g>140)&(g<205)&(b>160)&(b<230)) if theme=='light' else ((r>25)&(r<80)&(g>35)&(g<100)&(b>55)&(b<135))
            roi=np.zeros((H,W),bool);roi[478:535,1096:1160]=True
            ls=ndi.label(m&roi&(a[:,:,3]>220))[0]
        label=int(ls[y,x]);assert label>0,(theme,screen['id'],'seed outside blank screen')
        selected.append(ls==label)
    # Intersect both themes and inset from the bezel; hands remain excluded.
    mask=ndi.binary_erosion(selected[0]&selected[1],iterations=1)
    assert mask.sum()>150,(screen['id'],'screen interior not found')
    screen['mask']=mask;screen['clip']=trace(mask)

def projected(plane,x,y):
    ox,oy,ax,ay,bx,by=plane
    return (ox+ax*x+bx*y,oy+ay*x+by*y)
def point(plane,x,y):return ' '.join(f'{n:.2f}' for n in projected(plane,x,y))
def rounded(plane,x,y,w,h,r=3):
    P=lambda a,b:point(plane,a,b)
    return f'M{P(x+r,y)} L{P(x+w-r,y)} Q{P(x+w,y)} {P(x+w,y+r)} L{P(x+w,y+h-r)} Q{P(x+w,y+h)} {P(x+w-r,y+h)} L{P(x+r,y+h)} Q{P(x,y+h)} {P(x,y+h-r)} L{P(x,y+r)} Q{P(x,y)} {P(x+r,y)}Z'

def glyphs(screen,accent,text):
    p=screen['plane'];name=screen['id']
    if name=='tablet':return [f'<path d="{rounded(p,12,14,69,68,5)}" fill="{accent}"/>']
    if name=='chart':
        # A compact two-tone chart, one independently animated element.
        P=lambda x,y:point(p,x,y)
        circle=f'M{P(50,14)} C{P(70,14)} {P(86,30)} {P(86,50)} C{P(86,70)} {P(70,86)} {P(50,86)} C{P(30,86)} {P(14,70)} {P(14,50)} C{P(14,30)} {P(30,14)} {P(50,14)}Z'
        wedge=f'M{P(50,50)} L{P(50,14)} C{P(70,14)} {P(86,30)} {P(86,50)}Z'
        return [f'<path d="{circle}" fill="{accent}"/><path d="{wedge}" fill="{text}"/>']
    rects=[(4,10,30,43,4,accent),(4,64,30,7,3,text)]
    rows=[10,29,48,67] if screen['count']==6 else [13,36,59]
    rects += [(51,y,42,7,3,text) for y in rows]
    # Ensure planned card/text centers are actually in the visible screen.
    for x,y,w,h,r,color in rects:
        px,py=projected(p,x+w/2,y+h/2)
        assert screen['mask'][round(py),round(px)],(name,'glyph outside screen',px,py)
    return [f'<path d="{rounded(p,x,y,w,h,r)}" fill="{color}"/>' for x,y,w,h,r,color in rects]

report={'version':'1.5.3','viewport':[1448,1086],'viewBox':[W,H],'screen_count':6,'glyph_count':23,'sources':{},'screens':[]}
for theme in ['light','dark']:
    prefix='dark-' if theme=='dark' else '';rootid=prefix+'erp-screen-scene';cycle=prefix+'erp-ui-cycle'
    accent,text=('#9AAEFF','#A3B4D0') if theme=='dark' else ('#2454D6','#B0BCD6')
    source=SOURCES[theme].read_bytes();sha=hashlib.sha256(source).hexdigest()
    report['sources'][theme]={'file':SOURCES[theme].name,'sha256':sha}
    parts=[f'<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="{rootid}" width="1448" height="1086" viewBox="0 0 {W} {H}" role="img" aria-labelledby="{prefix}screen-title {prefix}screen-desc">',
     f'<title id="{prefix}screen-title">ERP AI 협업 — 화면 정보 모션</title>',
     f'<desc id="{prefix}screen-desc">피부와 소매, 신발, 식물 줄기를 정리한 {"다크" if theme=="dark" else "라이트"} 일러스트입니다. 모니터 프레임 안의 카드와 글자만 각각 나타났다 사라집니다.</desc>',
     '<metadata>'+escape(json.dumps({'version':'1.5.3','source':SOURCES[theme].name,'source_sha256':sha,'format':'unchanged imagegen PNG with native SVG screen UI','screen_count':6,'glyph_count':23},ensure_ascii=False))+'</metadata>',
     f'<style>#{rootid}{{display:block;max-width:100%;height:auto}}\n#{rootid} .ui-motion{{opacity:1;animation:{cycle} var(--cycle) ease-in-out var(--delay) infinite}}\n@keyframes {cycle}{{0%,8%{{opacity:0}}15%,58%{{opacity:1}}68%,100%{{opacity:0}}}}\n@media(prefers-reduced-motion:reduce){{#{rootid} .ui-motion{{animation:{cycle} var(--cycle) ease-in-out var(--delay) infinite!important}}}}</style>',
     '<defs>',f'<image id="{prefix}screen-original" width="{W}" height="{H}" xlink:href="data:image/png;base64,{b64encode(source).decode()}"/>']
    for s in SCREENS:parts.append(f'<clipPath id="{prefix}clip-screen-{s["id"]}" clipPathUnits="userSpaceOnUse"><path d="{s["clip"]}"/></clipPath>')
    parts+=['</defs>',f'<use id="{prefix}screen-base" xlink:href="#{prefix}screen-original"/>',f'<g id="{prefix}ui-content">']
    for s in SCREENS:
        parts.append(f'<g clip-path="url(#{prefix}clip-screen-{s["id"]})">')
        glyphlist=glyphs(s,accent,text);assert len(glyphlist)==s['count']
        for i,g in enumerate(glyphlist):
            delay=round(s['phase']+i*.42,2)
            parts.append(f'<g id="{prefix}screen-{s["id"]}-{i+1}" class="ui-motion" style="--cycle:{s["cycle"]}s;--delay:{delay}s" data-screen="{s["id"]}" data-sequence="{i}" data-cycle="{s["cycle"]}" data-delay="{delay}">{g}</g>')
        parts.append('</g>')
    parts+=['</g>','</svg>']
    filename='team-collaboration-dark.svg' if theme=='dark' else 'team-collaboration-animated.svg'
    (ROOT/'assets/images'/filename).write_text('\n'.join(parts)+'\n')
for s in SCREENS:report['screens'].append({'id':s['id'],'safe_pixels':int(s['mask'].sum()),'glyph_count':s['count'],'plane':s['plane']})
(ROOT/'docs/design/hero-assets-v153.json').write_text(json.dumps(report,ensure_ascii=False,indent=2)+'\n')
print(json.dumps(report,ensure_ascii=False))
