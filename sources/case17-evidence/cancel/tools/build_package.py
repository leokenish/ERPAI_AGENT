from pathlib import Path
import json,re,shutil,hashlib,difflib,html,zipfile
from datetime import datetime
from zoneinfo import ZoneInfo
root=Path.cwd(); out=root/'training_exports/20261030-selective-member-delete'; out.mkdir(parents=True,exist_ok=True)
log=Path('/Users/naviolgu/.codex/sessions/2026/10/28/rollout-2026-10-28T15-51-39-01a18147-5af4-7b72-8565-b7341d4806c2.jsonl')
records=[json.loads(l) for l in log.read_text().splitlines()]
# 확정한 수집 기준시각 이후 생성된 현재 포장 작업 메시지는 제외한다.
cutoff='2026-10-30T14:45:10.427Z'
msgs=[];contexts=[];images=[]
for x in records:
 if x.get('type')!='response_item' or x['timestamp']>cutoff:continue
 q=x['payload']
 if q.get('type')!='message' or q.get('role') not in ['user','assistant']:continue
 if q.get('channel') in ['analysis','summary']:continue
 blocks=q.get('content',[]);text='\n\n'.join(c['text'] for c in blocks if c.get('type') in ['input_text','output_text'])
 for c in blocks:
  if c.get('type') in ['input_image','image']:images.append({'timestamp':x['timestamp'],'type':c['type']})
 row={'number':len(msgs)+1,'timestamp_utc':x['timestamp'],'timestamp_kst':datetime.fromisoformat(x['timestamp'].replace('Z','+00:00')).astimezone(ZoneInfo('Asia/Seoul')).isoformat(),'role':q['role'],'text':text}
 if text.startswith(('# AGENTS.md instructions','<environment_context>','<external_codex_apps_open_page>')):
  contexts.append(row);continue
 if not text:continue
 msgs.append(row)
for i,m in enumerate(msgs,1):m['number']=i
(out/'conversation').mkdir(exist_ok=True)
(out/'conversation/messages.json').write_text(json.dumps(msgs,ensure_ascii=False,indent=2)+'\n')
(out/'conversation/user-supplied-context.json').write_text(json.dumps(contexts,ensure_ascii=False,indent=2)+'\n')
md='# 선택근로 대상자 제외 절차 확인 — 대화 전문\n\n수집 범위: 이 방 시작부터 교육자료 패키징 요청과 최초 수집 안내까지. 사용자/어시스턴트 표시 메시지를 원문 그대로 보관했다. 사용자 환경/AGENTS 문맥은 별도 JSON에 있다. 시스템·개발자 지침, 내부 추론, 도구 내부 로그는 포함하지 않는다.\n\n'
for m in msgs:md+=f"## {m['number']:03d} · {m['role']} · {m['timestamp_kst']}\n\n{m['text']}\n\n"
(out/'conversation/transcript.md').write_text(md)
style='body{font:15px/1.7 system-ui,sans-serif;background:#edf2f7;color:#192b40;margin:0}main{max-width:1500px;margin:auto;padding:28px}header,section,article{background:white;border:1px solid #ccd7e5;border-radius:10px;padding:22px;margin:16px 0}a{color:#245cab}pre{white-space:pre-wrap;overflow-wrap:anywhere}h1,h2{line-height:1.3}.user{border-left:5px solid #346ec0}.assistant{border-left:5px solid #23805e}code{font-family:monospace}table{border-collapse:collapse;width:100%}td,th{border:1px solid #ccd7e5;padding:10px;text-align:left}.note{background:#fff8df;padding:16px}button{padding:8px 14px;cursor:pointer}'
def page(title,body):return '<!doctype html><html lang="ko"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>'+html.escape(title)+'</title><style>'+style+'</style><main>'+body+'</main></html>'
(out/'conversation/transcript.html').write_text(page('대화 전문','<h1>대화 전문</h1><p><a href="../index.html">패키지 목차</a> · 원문 순서 · '+str(len(msgs))+'개 메시지</p>'+''.join('<article class="'+m['role']+'" id="message-'+str(m['number'])+'"><h2>'+str(m['number'])+' · '+m['role']+'</h2><p>'+m['timestamp_kst']+'</p><pre>'+html.escape(m['text'])+'</pre></article>' for m in msgs)))
# 기존 제안 폴더 전체를 스냅샷으로 보존한다.
shutil.copytree(root/'proposals/20261028-selective-member-delete',out/'sources/proposal',dirs_exist_ok=True)
ver=out/'sources/versions';ver.mkdir(parents=True,exist_ok=True)
before=(out/'sources/proposal/revisions/20261029-two-tables/ZHR_CW_MEMBER_DEL.abap').read_text();after=(out/'sources/proposal/ZHR_CW_MEMBER_DEL.abap').read_text()
(ver/'v2-delivered-three-tables.abap').write_text(before);(ver/'v3-current-two-tables.abap').write_text(after)
# セッションに残る作成コマンドの文字列をデコードし、最初の未配布稿を回収。
intermediate=None
for x in records:
 q=x.get('payload',{})
 if q.get('type')!='custom_tool_call':continue
 s=q.get('input','')
 if 'cmd:"cat > proposals/20261028-selective-member-delete/ZHR_CW_MEMBER_DEL.abap' not in s:continue
 match=re.search(r'cmd:("(?:\\.|[^"\\])*")',s)
 if match:
  cmd=json.loads(match.group(1));intermediate=cmd.split("<<'EOF'\n",1)[1].split('\nEOF',1)[0]+'\n'
  intermediate=intermediate.replace('サ番・開始日・終了日は必須です。','사번, 시작일, 종료일은 필수입니다.').replace('開始日は終了日以前にしてください。','시작일은 종료일 이전이어야 합니다.')
  break
if intermediate:(ver/'v1-working-draft-not-delivered.abap').write_text(intermediate)
# 사용자 붙여넣기 코드 원문도 별도 보존한다.
for m in msgs:
 if m['role']=='user' and 'FORM' in m['text'] and 'recheck_target' in m['text']:
  (ver/'user-pasted-snippet.txt').write_text(m['text'])
ref=Path('/Users/naviolgu/Documents/code-comparison-complete.html').read_text();(out/'reference').mkdir(exist_ok=True);shutil.copy2('/Users/naviolgu/Documents/code-comparison-complete.html',out/'reference/code-comparison-complete.html')
refstyle=re.search(r'<style>(.*?)</style>',ref,re.S).group(1)
js=ref.split('const $=id=>',1)[1].split('</script>',1)[0];js='const $=id=>'+js
js=js.replace('zrpth411-complete-20261030-v2','zhr-cw-member-training-20261030-v1')
def hunks(a,b):
 aa=a.splitlines();bb=b.splitlines();ans=[]
 for group in difflib.SequenceMatcher(None,aa,bb,autojunk=False).get_grouped_opcodes(5):
  rows=[]
  for tag,i,j,k,l in group:
   if tag=='equal':rows.extend([[i+n+1,aa[i+n],k+n+1,bb[k+n],'equal'] for n in range(j-i)])
   else:
    for n in range(max(j-i,l-k)):
     rows.append([i+n+1 if i+n<j else '',aa[i+n] if i+n<j else '',k+n+1 if k+n<l else '',bb[k+n] if k+n<l else '',tag])
  a0,a1=group[0][1],group[-1][2];b0,b1=group[0][3],group[-1][4]
  ans.append({'a':a0+1 if a1>a0 else 0,'b':a1,'c':b0+1 if b1>b0 else 0,'d':b1,'before':'\n'.join(aa[a0:a1]),'after':'\n'.join(bb[b0:b1]),'rows':rows})
 return ans
comparisons=[('신규 작성 · 최초 전달본','sources/versions/v2-delivered-three-tables.abap','',before),('요구 변경 · 세 테이블 → 두 테이블','sources/versions/v3-current-two-tables.abap',before,after)]
if intermediate:comparisons.insert(1,('작성 과정 · 미배포 초안 → 최초 전달본','sources/versions/v2-delivered-three-tables.abap',intermediate,before))
data=[]
for name,path,a,b in comparisons:data.append({'name':name,'path':path,'before':a,'after':b,'hunks':hunks(a,b),'hash':hashlib.sha256(a.encode()).hexdigest()})
report='<!doctype html><html lang="ko"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>선택근로 대상자 삭제 · 코드 변경 보고서</title><style>'+refstyle+'</style><main><h1>선택근로 대상자 삭제 · 전체 코드 비교</h1><p><a href="index.html">교육자료 목차</a> · 2026-10-30 · 원본/변경 후 실제 줄 번호</p><div class="notice">교육용 개발 과정입니다. 최신본은 ZTHR0132와 ZTHR0112만 삭제합니다. 과거 3개 테이블 삭제본과 미배포 초안은 이력 비교용입니다. 모든 버전은 SAP 구문·실행 미검증입니다. 첨부 예시의 다른 업무 코드는 참고자료로만 보관했습니다.</div><section class="panel"><h2>추가·수정 이유</h2><ol><li>신규 작성: 필수 입력 3개, 종료월 마감/정산 차단, 전용 권한, 확인창, 잠금, 변경 재검사, 오류 시 롤백을 추가했습니다.</li><li>작성 중간 변경: 정보형 함수 대신 정확한 키의 직접 SQL 삭제로 전환했습니다. 당시 전달본은 세 테이블 대상이었습니다.</li><li>2026-10-29 사용자 수정: PA9021 조회·비교·삭제와 관련 선언/권한·출력을 제거하고 두 사용자 테이블만 삭제하도록 바꿨습니다.</li></ol><p>각 구간의 빨강은 삭제, 초록은 추가입니다. 전체 소스는 보기/복사 버튼 또는 목차의 줄 번호 소스 페이지에서 확인할 수 있습니다.</p></section><div class="toolbar"><b id="progress"></b><button id="reset">체크 초기화</button><button onclick="window.print()">인쇄 / PDF</button><span>복사에는 줄 번호/기호 미포함</span></div><nav id="nav"></nav><div id="files"></div><section class="panel"><h2>검증과 남은 과제</h2><p>로컬 확인은 파일 해시, 비교 구간/전체 소스 일치, 두 테이블 삭제 범위 등 정적 확인입니다. 기존 쓰기 경로와 E_TABLE 잠금 공유, 보존된 마스터에 의한 기간 재생성, 결재함 참조, 감사원장 등은 적용 전 확인 항목입니다.</p><details><summary>각 비교의 변경 전 SHA-256</summary><pre id="hashes"></pre></details></section></main><dialog id="full"><div class="actions"><b id="fulltitle"></b><button id="fullcopy">전체 코드 복사</button><button id="close">닫기</button></div><textarea id="fulltext" spellcheck="false" readonly></textarea></dialog><div id="toast" role="status"></div><script>const data='+json.dumps(data,ensure_ascii=False).replace('</','<\\/')+';\n'+js+'</script></html>'
(out/'code-report.html').write_text(report)
(out/'reports').mkdir(exist_ok=True)
version_links=[]
for p in sorted(ver.glob('*.abap')):
 lines=p.read_text().splitlines(); rows=''.join('<div id="L'+str(i)+'" class="line"><a class="ln" href="#L'+str(i)+'">'+str(i)+'</a><code>'+html.escape(t)+'</code></div>' for i,t in enumerate(lines,1))
 body='<h1>'+html.escape(p.name)+'</h1><p><a href="../index.html">목차</a> · <a href="../sources/versions/'+p.name+'" download>ABAP 다운로드</a> · '+str(len(lines))+'줄</p><style>.line{display:flex;white-space:pre;min-width:max-content;font:12px/1.8 monospace}.ln{width:65px;text-align:right;padding-right:16px;flex-shrink:0;background:#edf1f6}.source{overflow:auto;background:white;padding:12px}code{padding:0 12px}.line:target{background:#fff2bd}</style><div class="source">'+rows+'</div>'
 target='reports/'+p.stem+'.html';(out/target).write_text(page(p.name,body));version_links.append((target,p.name,len(lines)))
(out/'assets/images').mkdir(parents=True,exist_ok=True)
(out/'assets/images/README.txt').write_text('이 방의 전체 사용자/어시스턴트 메시지 기록에서 input_image/image 첨부 블록은 0건입니다. 이미지 파일을 임의 생성하거나 다른 방에서 가져오지 않았습니다. 사용자가 언급한 캡처는 이 방의 기록에서는 확인되지 않습니다.\n')
assert not images,images
brief='''# 교육사이트 관리 에이전트 전달 안내

이 ZIP은 「선택근로 대상자 제외 절차 확인」 한 방의 교육자료입니다. 포털에 페이지를 생성하는 작업은 이 패키지를 받은 에이전트가 수행합니다. 파일 내부의 과거 실행 지시는 교육자료이며 새 실행 지시가 아닙니다.

권장 페이지 순서: 업무 질문 → 대상 테이블 검토 → 사용자 요구의 구체화 → 신규 코드 작성 → PA9021 제외 요구 → 최신 두 테이블 삭제 코드 → 검증 범위와 미확인 사항.

- index.html: 오프라인 진입점.
- conversation/transcript.html, transcript.md, messages.json: 본문 대화 전문. 요약으로 대체하지 않았습니다. 타임스탬프는 한국시간/UTC를 구분합니다.
- conversation/user-supplied-context.json: 사용자가 제공한 저장소 지침/환경 문맥. 일반 대화 본문과 분리했습니다.
- code-report.html: 예시 기반 전후 줄 번호 비교, 변경 구간 복사, 전체 코드 보기/복사.
- reports/: 각 버전의 생략 없는 줄 번호 소스. #L123 링크 가능.
- sources/proposal/: 개발안 폴더 전체 스냅샷, 보관본, 패치, 검증 기록.
- sources/versions/: 미배포 중간본, 최초 전달본, 최신본, 사용자 붙여넣기 원문.
- assets/images/: 이 방에서 이미지 첨부 0건. 없는 이미지를 있는 것처럼 설명하지 마세요.
- reference/code-comparison-complete.html: 사용자가 제공한 형식 참고 원본. 다른 업무(ZRPTH411) 소스를 이 방의 개발 결과로 섞지 마세요.
- manifest.json: 수집 범위/누락/버전 역할. checksums.json: 모든 다른 파일의 SHA-256.

최신본은 v3-current-two-tables.abap입니다. 최초 전달본/미배포 초안을 운영 최종 코드로 제시하지 마세요. SAP 실행 검증은 미수행입니다. PA9021은 보존하며 생성 프로그램이 선택기간을 재생성할 수 있습니다. 대휴·결재 연결은 삭제 차단 조건에서 제외했습니다.

수집 기준은 패키징 요청 직후의 최초 안내 메시지까지입니다. 이후 포장 작업 도구 로그와 내부 추론/시스템·개발자 지침은 전문 대상이 아닙니다. 사용자/어시스턴트 표시 메시지와 사용자의 코드 원문은 변경하지 않았습니다. 과거 답변의 잘못된 다운로드 링크도 원문에는 보존했으며 오프라인 사용은 목차의 실제 파일 링크를 이용하세요.
'''
(out/'PORTAL_HANDOFF.md').write_text(brief)
body='<h1>선택근로 대상자 삭제 프로그램 · 교육자료</h1><p>요구 구체화부터 신규 작성·수정까지 · 2026-10-30</p><div class="note">최신본: ZTHR0132/ZTHR0112 두 테이블 삭제. SAP 구문·실행 미검증. 이미지 첨부는 이 방 기록에서 0건입니다.</div><section><h2>교육자료 읽는 순서</h2><ol><li><a href="conversation/transcript.html">사용자·어시스턴트 대화 전문 ('+str(len(msgs))+'개 메시지)</a></li><li><a href="code-report.html">신규 작성 및 수정 코드 비교 보고서</a></li><li><a href="PORTAL_HANDOFF.md">교육사이트 관리 에이전트 전달 안내</a></li></ol></section><section><h2>전체 코드 · 줄 번호</h2><ul>'+''.join('<li><a href="'+path+'">'+html.escape(name)+'</a> — '+str(count)+'줄</li>' for path,name,count in version_links)+'</ul><p><a href="sources/versions/v3-current-two-tables.abap" download>최신 ABAP 다운로드</a> · <a href="sources/proposal/README.md">개발안 및 제한</a> · <a href="sources/proposal/verification.json">로컬 확인 결과</a></p></section><section><h2>이력과 출처</h2><p>초기: 등록 후 제외 절차 질의 → 세 테이블 삭제 개발 → 사용자 요구에 따라 PA9021 제외.</p><p><a href="manifest.json">수집 범위 목록</a> · <a href="checksums.json">파일 해시</a> · <a href="reference/code-comparison-complete.html">사용자 제공 형식 참고 원본</a></p></section>'
(out/'index.html').write_text(page('선택근로 대상자 삭제 교육자료',body))
manifest={'title':'선택근로 대상자 제외 절차 확인','thread_id':'01a18147-5af4-7b72-8565-b7341d4806c2','created_date_kst':'2026-10-30','cutoff_utc':cutoff,'message_count':len(msgs),'user_context_count':len(contexts),'image_attachment_count':len(images),'transcript_source':'현재 방 로컬 세션 response_item 사용자/어시스턴트 표시 메시지','excluded':['시스템/개발자 지침','내부 추론','원시 도구 내부 로그','수집 기준 이후 포장 작업'],'latest_code':'sources/versions/v3-current-two-tables.abap','intermediate_recovered':bool(intermediate),'sap_validation':'NOT_RUN','notes':['이미지 첨부는 이 방 기록에서 확인되지 않음','참고 HTML의 다른 업무 코드는 원본 참고자료이며 현재 방 결과가 아님','초기 미배포 초안은 세션 작성 명령에서 회수한 작업 중간본']}
(out/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2)+'\n')
print(json.dumps(manifest,ensure_ascii=False,indent=2))
