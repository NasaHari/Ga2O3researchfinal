from pathlib import Path
import csv,hashlib,math,re,sys
root=Path(sys.argv[1]); out=Path(sys.argv[2]); area=8.659e-5; target=area*1e-3
cases=[]
for name in ('planar','raised_mesa','shallow_trench'):
 d=root/'Process_Constrained_Followup/candidates'/name
 cases.append((name+'_hv',d/'reverse_hv.plt',d/'reverse_hv.log_des.log',d/'hv_exit.status',None))
cp=root/'Clean_Paper_g156e8_SnSub'; bn=root/'NLM_g156e8_Full_Batch_20261122'
for src,dst in [('03_Planar_WF5p10','Study1_Architectures/01_Planar_JTE_FP'),('07_Mesa_WF5p10','Study1_Architectures/03_Mesa_JBS_JTE_FP'),('11_Thin080nm_WF4p75','Study5_Champion_080nm_075eV/01_Thin080nm_WF4p75')]:
 d=bn/src; stem='rev_'+src
 cases.append((src,d/(stem+'.plt'),d/(stem+'.log_des.log'),None,cp/dst/'rev.plt'))
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
with out.open('w',newline='') as f:
 w=csv.writer(f); w.writerow('case plot log plot_sha256 log_sha256 copy_sha256_match global_ge voltage_column current_column rows last_abs_V last_abs_A first_sustained_V bracket_low_V bracket_high_V exit_status'.split())
 for name,p,log,st,copy in cases:
  t=p.read_text(); names=re.findall(r'"([^"]+)"',re.search(r'datasets\s*=\s*\[(.*?)\]',t,re.S)[1]); body=re.search(r'\bData\s*\{(.*?)\s*$',t,re.S)[1]; closed=body.endswith('}'); assert (closed or st) and len(set(names))==len(names),p
  v=list(map(float,(body[:-1] if closed else body).split())); n=len(names); assert all(map(math.isfinite,v)) and (not closed or len(v)%n==0),p
  v=v[:len(v)//n*n]
  vs='anode OuterVoltage'; cs='cathode TotalCurrent'; a=names.index(vs); b=names.index(cs)
  rows=[(-v[j+a],abs(v[j+b])) for j in range(0,len(v),n) if v[j+a]<=0]; assert rows and all(y[0]>=x[0]-1e-7 for x,y in zip(rows,rows[1:])),p
  hits=[(u+(z-u)*math.log(target/i)/math.log(j/i),u,z) for k,((u,i),(z,j)) in enumerate(zip(rows,rows[1:])) if z>u and 0<i<target<=j and len(rows[k+1:k+6])==5 and min(x[1] for x in rows[k+1:k+6])>=target]
  s=log.read_text(errors='replace'); g=re.search(r'BarrierTunneling_: g_e\s*=\s*(\S+)',s)[1]
  stval=st.read_text().strip() if st else ''
  match=sha(copy)==sha(p) if copy else ''
  w.writerow((name,p.relative_to(root),log.relative_to(root),sha(p),sha(log),match,g,vs,cs,len(rows),*rows[-1],*(hits[0] if hits else ('','','')),stval))
  print(name,g,match,rows[-1],hits[:1],stval)
