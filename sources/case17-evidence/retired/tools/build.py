from pathlib import Path
import json,html,difflib,shutil,hashlib,zipfile,re
root=Path(__file__).resolve().parents[1]; repo=root.parents[1]
p=repo/'proposals/20261024-selective-retiree-delete'
for d in ['code/before','code/after','reports','reference','evidence','images']: (root/d).mkdir(parents=True,exist_ok=True)
name='ZRPTH411_RET_DEL.abap'
shutil.copy2(p/name,root/'code/after'/name)
shutil.copy2(p/'revisions/20261028-remove-retiree-limit'/name,root/'code/before'/name)
for f in ['README.md','verification.json']:shutil.copy2(p/f,root/'evidence'/f)
for f in ['change.patch','hashes.json']:shutil.copy2(p/'revisions/20261028-remove-retiree-limit'/f,root/'evidence'/f)
ref=Path('/Users/naviolgu/Documents/code-comparison-complete.html');shutil.copy2(ref,root/'reference'/ref.name)
a=(root/'code/before'/name).read_text();b=(root/'code/after'/name).read_text(); A=a.splitlines();B=b.splitlines()
style=re.search(r'<style>(.*?)</style>',ref.read_text(),re.S).group(1)
style+='\npre.message{white-space:pre-wrap;overflow-wrap:anywhere}.fullcode{max-height:750px;overflow:auto}.cols{align-items:start}code{font-family:monospace}.panel small{color:#52657a}'
def page(title,body,script=''):return '<!doctype html><html lang="ko"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>'+title+'</title><style>'+style+'</style><main><a href="../index.html">교육자료 목차</a><h1>'+title+'</h1>'+body+'</main>'+script+'</html>'
def lines(xs,start=1,cls=''):
 return ''.join('<div class="line '+cls+'"><span class="num">'+str(n)+'</span><code>'+html.escape(x)+'</code></div>' for n,x in enumerate(xs,start))
blocks=[];summary=[]
for tag,i,j,k,l in difflib.SequenceMatcher(None,A,B).get_opcodes():
 if tag=='equal':continue
 summary.append({'type':tag,'before_start':i+1,'before_end':j,'after_start':k+1,'after_end':l,'deleted_lines':j-i,'added_lines':l-k})
 title=f'변경 {len(summary)} · 원본 L{i+1}–{j} → 수정본 L{k+1}–{l}'
 blocks.append('<article class="hunk"><h3>'+title+'</h3><div class="cols"><div class="pane"><div class="label">변경 전</div><div class="code">'+(lines(A[i:j],i+1,'removed') or '<p>기존 행 없음</p>')+'</div></div><div class="pane"><div class="label">변경 후</div><div class="code">'+(lines(B[k:l],k+1,'added') or '<p>해당 구간 삭제</p>')+'</div></div></div></article>')
body='''<p>신규 REPORT 최초 제공본 → 퇴직자 제한 해제본 · SAP_BASIS 700 기준 · SAP 검증 미수행</p><section class="panel"><h2>요구와 변경 내용</h2><p>인사 담당자 요청으로 퇴직자 외 대상도 삭제할 수 있도록 PA0000 현재 유효 행 조회와 STAT2=0 제한을 제거했습니다. 사용하지 않는 인사상태 변수도 제거하고 화면 제목·사번 안내·확인창을 변경했습니다.</p><p>한 명씩 처리, 정산월 → 정산일 연결, 8050, 월마감, AWREF, 레코드 키 검사, 잠금 후 재조회와 삭제·커밋·롤백 흐름은 유지했습니다. 새 FORM이나 신규 처리 경로를 추가하지 않았습니다.</p><p>이 방의 최초 요청은 기존 로컬 개발안을 대화창에 제공하는 것이었습니다. 신규 프로그램 최초 작성 자체가 이 방에서 수행됐다고 해석하지 마세요. 최초 제공본 전체를 신규 REPORT 학습 자료로 함께 보존합니다.</p><p>첨부 참고 HTML은 다른 주제인 소급 상세 분리 보고서입니다. 형식 참고자료로만 별도 보관합니다.</p><a href="#diff">변경 구간</a> · <a href="#before">최초 제공본 전체</a> · <a href="#after">수정본 전체</a></section><h2 id="diff">변경 구간 비교</h2>'''+''.join(blocks)
for key,label,source in [('before','최초 제공본',A),('after','퇴직자 제한 해제본',B)]:
 body+=f'<section class="panel" id="{key}"><h2>{label} 전체 · {len(source)}행</h2><a download href="../code/{key}/{name}">ABAP 다운로드</a> <button onclick="copyCode(\'{key}\')">번호 없이 전체 복사</button><div class="fullcode">'+lines(source)+'</div></section>'
body+='<section class="panel"><h2>검증과 후속 확인</h2><p>로컬 확인: 제한 구간 제거, 삭제·잠금 해제 FORM 보존, 패치 재생성 및 전체 소스 해시 확인. SAP 구문검사·실행·권한·롤백은 미검증입니다. 재직자·재입사자·퇴직자 및 전표/잠금/타월 혼합 조건은 개발 시스템에서 확인해야 합니다.</p></section>'
data=json.dumps({'before':a,'after':b},ensure_ascii=False).replace('<','\\u003c')
script='<script>const code='+data+';async function copyCode(k){try{await navigator.clipboard.writeText(code[k]);alert("전체 코드를 복사했습니다.")}catch(e){const t=document.createElement("textarea");t.value=code[k];document.body.append(t);t.select();document.execCommand("copy");t.remove()}}</script>'
(root/'reports/code-comparison.html').write_text(page('ZRPTH411_RET_DEL · 신규 코드와 변경 보고서',body,script))
(root/'reports/change-map.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2))
con=json.loads((root/'conversation/messages.json').read_text()); txt=[];cards=[]
for n,m in enumerate(con['messages'],1):
 content=m['content'];s=content if isinstance(content,str) else '\n'.join(x.get('text',json.dumps(x,ensure_ascii=False)) for x in content)
 who='사용자' if m['type']=='userMessage' else '에이전트';label=f'{n}. {who}'+(' · '+m.get('phase','') if m.get('phase') else '')
 txt.append(label+'\n'+s);cards.append('<section class="panel"><h2>'+label+'</h2><pre class="message">'+html.escape(s)+'</pre></section>')
(root/'conversation/transcript.txt').write_text('\n\n'.join(txt))
(root/'conversation/transcript.html').write_text(page('대화 전문','<p>채팅 도구에서 반환한 사용자 메시지·공개 답변을 순서대로 보존했습니다. 도구 실행 로그와 시스템·개발자 지침은 대화 전문 대상에서 제외했습니다. 현재 자료 작성 턴은 진행 중 스냅샷으로 최종 ZIP 안내는 포함되지 않습니다.</p>'+''.join(cards)))
(root/'images/README.txt').write_text('이 채팅 도구가 반환한 4개 턴 전체(hasMore=false)의 사용자 메시지에서 이미지 첨부 0건 확인. 캡처 이미지를 임의로 생성하거나 다른 채팅의 이미지를 혼입하지 않음. 사용자 제공 HTML 1건은 reference/에 보존.\n')
readme='''# 교육 포털 인계 안내

시작 파일: index.html

- reports/code-comparison.html: 최초 제공본/수정본 전체 코드, 줄 번호, 삭제/추가 구간, 전체 복사·다운로드.
- reports/change-map.json: 변경 구간의 전후 줄 번호. 삽입/삭제의 빈 범위는 end < start로 표시.
- code/before, code/after: 실제 ABAP 파일. after가 퇴직자 제한 해제본.
- conversation/: 이 채팅의 공개 대화 원문 JSON/TXT/HTML. 4개 턴, 다음 페이지 없음. 진행 중 인계 작업은 확보 시점까지 포함.
- images/: 이 채팅에는 이미지 첨부 0건으로 확인됨.
- evidence/: 개발안 설명, 기존 정적 검증 기록, 원본 패치와 해시.
- reference/: 사용자가 제공한 다른 주제의 HTML. 디자인 참고자료이며 이번 변경 구현으로 합치지 말 것.
- manifest.json: 모든 파일 SHA-256, 크기.

포털 구성 제안: 요구 → 최초 코드 → 추가 요구 → 최소 수정 비교 → 검증 한계 → 다운로드 순서. 대화 원문은 수정하지 않고 별도 열람 영역에 보존하고, 해설과 원문을 구별한다. 모든 링크는 패키지 내부 상대 경로로 재구성한다. 소스의 기존 관례를 유지한 최소 수정 사례로 설명한다. SAP 등록·활성화·실행 또는 업무 승인 완료로 표시하지 않는다.

이번 묶음은 교육자료 내보내기이며 SAP 소스/데이터를 변경하지 않는다. 캡처 이미지가 존재했다는 근거는 확보되지 않았다. 최초 신규 REPORT는 이 방에서 작성한 것이 아니라 기존 파일을 제공한 기록이다. 저장소 전체의 다른 과제 코드는 포함하지 않는다.
'''
(root/'README.md').write_text(readme)
(root/'index.html').write_text(page('선택근무 지급 항목 삭제 · AI 협업 교육자료','<section class="panel"><h2>요구 변경을 최소 수정으로 반영한 사례</h2><p>퇴직자 전용 삭제 개발안에서 인사상태 제한을 제거한 대화와 코드의 전체 기록입니다. SAP 검증 전 개발안입니다.</p><ul><li><a href="reports/code-comparison.html">신규 코드·수정 코드 비교 보고서</a></li><li><a href="conversation/transcript.html">대화 전문</a></li><li><a href="README.md">교육사이트 관리 에이전트 인계 안내</a></li><li><a href="code/after/ZRPTH411_RET_DEL.abap">최종 ABAP</a></li><li><a href="images/README.txt">이미지 첨부 확인 결과: 0건</a></li><li><a href="reference/code-comparison-complete.html">사용자 제공 형식 참고 HTML</a></li></ul><p>원문 4개 턴/공개 메시지 '+str(len(con['messages']))+'건. 현재 작업은 스냅샷 시점까지만 포함됩니다.</p></section>').replace('<a href="../index.html">교육자료 목차</a>',''))
manifest=[]
for f in sorted(root.rglob('*')):
 if f.is_file() and f.name!='manifest.json':manifest.append({'path':str(f.relative_to(root)),'bytes':f.stat().st_size,'sha256':hashlib.sha256(f.read_bytes()).hexdigest()})
(root/'manifest.json').write_text(json.dumps({'files':manifest,'images':0,'sap_validation':'not_run'},ensure_ascii=False,indent=2))
# HTML에 포함한 코드 문자열과 원본의 완전 일치를 검증한다.
assert json.loads(data)=={'before':a,'after':b}
assert s is not None
out=root.parent/'ZRPTH411_RET_DEL-training-20261030.zip'
with zipfile.ZipFile(out,'w',zipfile.ZIP_DEFLATED) as z:
 for f in sorted(root.rglob('*')):
  if f.is_file():z.write(f,Path(root.name)/f.relative_to(root))
with zipfile.ZipFile(out) as z:assert z.testzip() is None
print(json.dumps({'zip':str(out),'files':len(manifest)+1,'change_groups':len(summary),'before_lines':len(A),'after_lines':len(B),'messages':len(con['messages']),'zip_bytes':out.stat().st_size},ensure_ascii=False))
