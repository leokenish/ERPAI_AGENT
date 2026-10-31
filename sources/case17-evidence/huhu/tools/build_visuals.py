"""Editable SVG lesson diagrams. PNG renditions are made by the browser QA script."""
from pathlib import Path
import html,json,textwrap
OUT=Path(__file__).resolve().parents[1]
D=OUT/'assets/visuals';D.mkdir(parents=True,exist_ok=True)
INK='#163345';TEAL='#087d73';RED='#b33d3f';MUTED='#586b79'
def text(x,y,s,size=20,color=INK,weight=400):
 return f'<text x="{x}" y="{y}" fill="{color}" font-size="{size}" font-weight="{weight}">{html.escape(str(s))}</text>'
def rect(x,y,w,h,fill='#ffffff',stroke='#d3dfe2',r=18):return f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="{r}" fill="{fill}" stroke="{stroke}"/>'
def arrow(x,y,w=36):return f'<path d="M{x} {y} h{w} m-10 -7 10 7 -10 7" fill="none" stroke="#7e939f" stroke-width="3"/>'
def card(x,y,w,h,title,lines,number=None,accent=TEAL):
 a=rect(x,y,w,h)+f'<rect x="{x}" y="{y}" width="{w}" height="7" rx="3" fill="{accent}"/>'
 if number is not None:
  a+=f'<circle cx="{x+30}" cy="{y+40}" r="16" fill="{accent}"/>'+text(x+24,y+46,number,17,'#fff',700)
  a+=text(x+58,y+48,title,24,INK,700)
 else:a+=text(x+24,y+44,title,24,INK,700)
 yy=y+88
 for s in lines:
  for l in textwrap.wrap(s,width=max(12,int((w-48)/18))):a+=text(x+24,yy,l,18,MUTED);yy+=28
  yy+=8
 return a
def base(id,title,subtitle,body,height=760,foot='교육용 조건부 예시 · 실제 SAP 실행 결과가 아닙니다.'):
 svg=f'''<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="{height}" viewBox="0 0 1200 {height}" role="img" aria-labelledby="title desc"><title id="title">{html.escape(title)}</title><desc id="desc">{html.escape(subtitle+' '+foot)}</desc><style>text{{font-family:-apple-system,BlinkMacSystemFont,"Apple SD Gothic Neo","Malgun Gothic",sans-serif}}</style><rect width="1200" height="{height}" fill="#f3f6f3"/>{text(48,48,'ZHR5  /  AI 에이전트 활용 사례',16,TEAL,700)}{text(48,98,title,34,INK,800)}{text(48,137,subtitle,19,MUTED)}{body}<path d="M48 {height-61} H1152" stroke="#d3dfe2"/>{text(48,height-30,foot,16,MUTED)}</svg>'''
 (D/(id+'.svg')).write_text(svg)
 return {'id':id,'title':title,'description':subtitle,'svg':f'assets/visuals/{id}.svg','png':f'assets/visuals/{id}.png','width':1200,'height':height,'origin':'new_educational_diagram','status':'conditional_model_not_sap_execution'}
assets=[]

b=card(48,180,530,270,'토요일 6시간 · 대휴 있음',['단가 10,000원 × 6시간 × 0.5','먼저 받는 휴일분 30,000원','미사용 대휴 추가 정산 60,000원'],1)
b+=card(622,180,530,270,'일요일 2시간 · 대휴 없음',['단가 10,000원 × 2시간 × 1.5','먼저 받는 휴일분 30,000원','추가 대휴 정산 0원'],2,RED)
for x,n,col in [(76,6,TEAL),(650,2,RED)]:
 for i in range(n):b+=rect(x+i*42,385,32,28,col,col,5)
b+=rect(48,485,1104,162,'#e6f3ee')+text(74,523,'같은 30,000원이어도 계산 근거는 다릅니다.',24,INK,700)
b+=text(74,566,'휴일분 합계 60,000원 × 2 = 120,000원',24,RED,700)
b+=text(74,608,'추가 정산할 대휴는 토요일 하나 → 60,000원',24,TEAL,700)
assets.append(base('rates','0.5배와 1.5배가 섞이면, 전체 ×2는 맞지 않을 수 있습니다','설명용 단가 10,000원 / 휴게 반영 후 시간 / 일반 휴휴 분기 / 시차 B 제외',b))

for id,sun,j,leaves in [('split-two',2,0,1),('split-six',6,60000,2)]:
 b=''
 for i,(day,h,money) in enumerate([('토요일',8,80000),('일요일',sun,j),('토요일',2,20000)]):
  x=48+i*380;b+=card(x,180,344,194,f'{day} {h}시간',[f'계산된 정산 기여분 {money:,}원'],i+1)
  for k in range(h):b+=rect(x+26+k*32,313,23,25,TEAL if day=='토요일' else '#b68039',r=4)
  if i<2:b+=arrow(x+350,268,24)
 b+=card(48,412,530,240,'기존 중간 처리의 위험',['날짜 묶음: 토 / 일 / 토 → 3묶음','임시 DB 토요일: 80,000 → 20,000원','이 표는 최종 BS01 오류액을 확정하지 않습니다.'],accent=RED)
 b+=card(622,412,530,240,'제안: 날짜는 2개, 대휴는 따로',['토요일: 80,000 + 20,000 = 100,000원',f'일요일 정산액: {j:,}원 / 대휴 {leaves}개','시간 분할은 유지하고, 날짜별 금액을 더합니다.'])
 assets.append(base(id,f'토8 → 일{sun} → 토2 : 세 줄이 세 날짜는 아닙니다',f'원래 토10 + 일{sun} / D·T의 해당 분할 조건 가정 / 일요일 행도 상세에 포함된 경우',b))

b=card(48,180,530,208,'생각했던 흐름',['계산 → 임시 저장 → 즉시 읽기 → 삭제','계산을 끝내면 임시 기록도 사라진다고 기대'],accent='#b68039')
b+=card(622,180,530,208,'확인한 코드의 흐름',['화면 계산에서도 임시 DB에 쓸 수 있음','읽기·삭제는 SAVE의 특정 분기에 있음'])
for i,(title,ls) in enumerate([('휴휴로 화면 계산',['토·일 금액 기록']),('익일 해제',['새 임시 기록 건너뜀','이전 행 정리도 없음']),('저장 단계 조회',['같은 사번·날짜의','이전 값이 읽힐 수 있음']),('읽은 뒤 삭제',['행은 없어져도','JORGEH에는 이미 반영'])]):
 x=48+i*282;b+=card(x,430,258,200,title,ls,i+1,RED if i>1 else TEAL)
 if i<3:b+=arrow(x+264,531,14)
assets.append(base('lifecycle','‘삭제 코드가 있다’와 ‘매 계산 후 삭제된다’는 다릅니다','이전 DB 쓰기가 다음 요청까지 유지된다는 전제의 사고 시나리오',b,foot='화면 요청 사이 COMMIT/ROLLBACK과 실제 잔존 여부는 SAP 실행 확인이 필요합니다.'))

b=card(48,180,330,235,'이전 저장 구조',['8시간 입력 당시','JORGEH 80,000원'],1)
b+=arrow(386,298,28)+card(435,180,330,235,'현재 계산 결과',['6시간으로 변경','실비 30,000원','JORGEH 60,000원'],2)
b+=arrow(775,298,26)+card(822,180,330,235,'복사 목록에 빠지면',['실비는 30,000원','JORGEH는 80,000원'],3,RED)
b+=rect(48,455,1104,176,'#e6f3ee')+text(74,497,'제안: 기존 MOVE 목록에 JORGEH 한 항목 추가',26,TEAL,700)
b+=text(74,542,'새 60,000원을 저장 구조에 반영합니다. 정상 새 값 0도 복사합니다.',22)
b+=text(74,586,'웹 F06에서 이미 새 값을 복사한 경로는 이 80,000원 잔존 예시와 다릅니다.',19,MUTED)
assets.append(base('copy','계산기에 뜬 새 숫자가 장부에도 옮겨졌을까요?','입구 구조에 이전 80,000원이 남아 있다는 조건부 예시',b))

b=card(48,180,530,236,'토3 + 일2 → 대휴 하나',['토요일 기여분 30,000원','일요일 기여분 20,000원','두 기여분 50,000원을 시작일 대휴에 귀속'],1)
b+=card(622,180,530,236,'토6 + 일6 → 대휴 둘',['토요일 대휴에 60,000원','일요일 대휴에 60,000원','전체 120,000원을 양쪽에 반복 복사하지 않음'],2)
b+=rect(48,456,1104,174,'#e6f3ee')+text(74,500,'날짜 수와 대휴 개수는 다릅니다.',29,TEAL,700)
b+=text(74,547,'양일 계산 결과를 보관 → 하루별 F05 재계산 → 해당 대휴의 JORGEH 최종 설정',22)
b+=text(74,590,'3+2의 최종 대휴 표시·발생일·실비는 F05까지 포함한 SAP 검증이 남아 있습니다.',19,MUTED)
assets.append(base('allocation','두 날짜의 금액을 대휴 하나에 모을 때도 있습니다','설명용 단가 10,000원 / 일반 휴휴 계산 결과의 전달 원칙',b))

b=card(48,180,530,244,'같은 행이 두 조건에 모두 해당',['대휴X 조건 → 영수증 A 추가','특근 상세 조건 → 같은 영수증 A 또 추가','무조건 더하면 A를 두 번 셀 수 있음'],1,RED)
b+=card(622,180,530,244,'OR 조건으로 한 번만 추가',['대휴X 또는 특근 상세이면 A 한 번 추가','토8의 A와 토2의 B는 서로 다른 원행','A와 B는 둘 다 보존하여 더함'],2)
b+=rect(48,465,1104,164,'#e6f3ee')+text(74,510,'중복 복사본 제거 ≠ 시간 구간 삭제',30,TEAL,700)
b+=text(74,556,'전체 J 합계는 원래 계산 행에서 한 번씩, 날짜별 금액은 정리된 상세에서 합산합니다.',21)
b+=text(74,596,'상세에서 제외된 날짜의 기여분이 있을 수 있어 전체 합계도 별도로 보존합니다.',19,MUTED)
assets.append(base('duplicate','같은 영수증 두 장과, 서로 다른 영수증 두 장을 구별합니다','F03-03 / 중복 APPEND 방지 + 전체 금액 합산',b))

b=card(48,180,530,242,'공유 DB에 임시 보관',['여러 계산이 사번·날짜 주소로 접근','이전 계산값과 현재 계산값의 구분 필요','CLEAR/REFRESH로 DB 행은 삭제되지 않음'],1,RED)
b+=card(622,180,530,242,'이번 호출의 작업 목록',['SAVE가 현재 입력으로 GET_DATA를 호출','기존 전체·상세 반환값을 그대로 받음','호출 시작에 상세와 누계를 초기화'],2)
b+=rect(48,465,1104,164,'#e6f3ee')+text(74,510,'새로운 메모리 캐시를 만든 것이 아닙니다.',30,TEAL,700)
b+=text(74,554,'계산 함수가 돌려주는 기존 구조·내부 테이블을 활용합니다.',23)
b+=text(74,596,'최종 정산금액은 여전히 ZTHRBS01에 저장합니다.',23)
assets.append(base('memory','공유 서랍 대신, 이번 계산 종이를 바로 전달합니다','F03-01 / 기존 반환 통로 재사용 / 새 DDIC·함수 인수 없음',b))

b=card(48,180,330,240,'첫 계산 호출',['GET_DATA','오류 코드 E 반환'],1,RED)
b+=arrow(388,300,32)+card(435,180,330,240,'기존 E 코드 전달',['E_CODE / E_TEXT','기존 문구를 호출자에게 반환'],2)
b+=arrow(777,300,28)+card(822,180,330,240,'저장 전 반환',['RETURN','실패 결과를 새 금액으로 저장하지 않음'],3)
b+=rect(48,463,1104,166,'#fff3da')+text(74,506,'사용자의 오해로 발생한 버그라고 붙이지 않습니다.',27,INK,700)
b+=text(74,550,'제안 작성 과정에서 추가한 보호 조건입니다. 새 메시지·팝업은 없습니다.',22)
b+=text(74,592,'F05 내부 재계산 오류 전달까지 해결했다는 뜻은 아닙니다.',21,MUTED)
assets.append(base('error','계산 실패를 정상 금액으로 저장하지 않도록', 'SAVE-01 / 첫 계산의 기존 오류 반환 확인',b))
(OUT/'assets/visuals/index.json').write_text(json.dumps(assets,ensure_ascii=False,indent=2)+'\n')
print(json.dumps({'svg_diagrams':len(assets)}))
