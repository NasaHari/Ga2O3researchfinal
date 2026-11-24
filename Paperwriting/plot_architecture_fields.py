from pathlib import Path
import sys, re, math, json, hashlib
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.tri import Triangulation
from matplotlib.collections import PolyCollection, LineCollection
from matplotlib.colors import Normalize
from matplotlib.cm import ScalarMappable
from matplotlib.lines import Line2D
sys.path.insert(0,str(Path.home()/'.gemini/config/skills/tcad-analysis/scripts'))
from tdr_reader import TDR
out=Path(__file__).resolve().parent
raw=out.parent/'arch_field_data'
B='NLM_g156e8_Full_Batch_20261122/'
cases=[('Bare Schottky diode','Bare/tdr/rev_298K_des.tdr','Bare/rev_298K_des.plt'),('Planar JTE + field plate', B+'03_Planar_WF5p10/rev_03_Planar_WF5p10_final_des.tdr',B+'03_Planar_WF5p10/rev_03_Planar_WF5p10.plt'),('Mesa JBS + JTE + field plate',B+'07_Mesa_WF5p10/rev_07_Mesa_WF5p10_final_des.tdr',B+'07_Mesa_WF5p10/rev_07_Mesa_WF5p10.plt'),('Trench JBS + JTE + field plate','barrier_height/04_Trench_WF5p10/rev_final_des.tdr','barrier_height/04_Trench_WF5p10/rev.plt')]
contacts={'anode':('Schottky anode','#14243b','-'),'anode_rim':('Schottky rim','#14243b','-'),'anode_pgan':('p-GaN contact','#850d84','-'),'anode_fp':('Field plate','#07683b','--')}
x0,x1,y0,y1=0.,90.,-2.0,10.
def elements(t,node,tag):
    parts=[]
    for k,e in node.children.items():
        if not k.startswith('elements_'): continue
        b=t._data(e)
        if b is None or not len(b): continue
        a=np.frombuffer(b.tobytes(),'<i4').reshape(-1,tag+2)
        assert (a[:,0]==tag).all()
        parts.append(a[:,1:])
    return np.concatenate(parts) if parts else None

def pair_plt(path,bias):
    s=path.read_text(); names=re.findall(r'"([^"]+)"',re.search(r'datasets\s*=\s*\[(.*?)\]',s,re.S)[1]); a=np.array(list(map(float,re.search(r'\bData\s*\{([^}]*)\}\s*\Z',s,re.S)[1].split()))).reshape(-1,len(names)); assert len(names)==len(set(names)) and np.isfinite(a).all(); i=names.index('anode OuterVoltage'); j=names.index('cathode TotalCurrent'); k=int(np.argmin(abs(a[:,i]-bias))); assert abs(a[k,i]-bias)<1e-4,(path,bias,a[k,i]); return float(a[k,j]),k

plt.rcParams.update({'font.size':9,'axes.titlesize':9.5,'axes.labelsize':10,'pdf.fonttype':42})
fig,axs=plt.subplots(2,2,figsize=(7.35,5.15),sharex=True,sharey=True)
fig.subplots_adjust(left=.10,right=.865,bottom=.19,top=.92,wspace=.15,hspace=.32)
hi=8.; norm=Normalize(0,hi); cmap=plt.get_cmap('turbo'); levels=np.linspace(0,hi,81); meta=[]
for ax,letter,(name,src,pl) in zip(axs.flat,'abcd',cases):
    path=raw/Path(src).name; t=TDR(path); xy=np.asarray(t.vertices)[:,:2]; lines={}; V={}; numbers=[]; checks=[]
    for key,node in t.geom.children.items():
        if not re.fullmatch(r'region_\d+',key): continue
        i=int(key.split('_')[-1]); nm=t.region_name(i); mat=t.region_material(i)
        if nm in (*contacts,'cathode'):
            edges=elements(t,node,1); assert edges is not None and edges.min()>=0 and edges.max()<len(xy); lines[nm]=xy[edges]; V[nm]=float(np.asarray(t.get_field('ContactExternalVoltage',region=i)['values']).item()); continue
        if not nm or '+' in nm or mat not in ('Ga2O3','GaN','AluminumOxide'): continue
        tr=elements(t,node,2)
        if tr is None: continue
        assert tr.min()>=0 and tr.max()<len(xy); q=xy[tr]; keep=(q[:,:,0].min(1)<=x1)&(q[:,:,0].max(1)>=x0)&(q[:,:,1].min(1)<y1)&(q[:,:,1].max(1)>=y0); sub=tr[keep]
        if not len(sub): continue
        ed=np.sort(np.vstack((tr[:,[0,1]],tr[:,[0,2]],tr[:,[1,2]])),axis=1); ed,c=np.unique(ed,axis=0,return_counts=True)
        if mat=='AluminumOxide':
            ax.add_collection(PolyCollection(xy[sub],facecolors='#e0e0e0',edgecolors='none',zorder=1))
        else:
            nodes=np.unique(tr); pts=xy[nodes]; v=np.asarray(t.get_field('ElectricField',region=i)['values']); assert v.size==2*len(nodes) and np.isfinite(v).all(),nm
            vec=v.reshape(-1,2); val=np.linalg.norm(vec,axis=1)/1e6; itri=np.searchsorted(nodes,sub); assert np.array_equal(nodes[itri],sub)
            tri=Triangulation(pts[:,0],pts[:,1],itri)
            ax.tricontourf(tri,np.clip(val,0,hi),levels=levels,norm=norm,cmap=cmap,antialiased=False,zorder=2).set_rasterized(True)
            local=(pts[:,0]>=x0)&(pts[:,0]<=x1)&(pts[:,1]>=y0)&(pts[:,1]<=y1); numbers.extend(val[local].tolist())
            # Cross-check spatial pairing against the independent nodal potential gradient.
            pv=t.get_field('ElectrostaticPotential',region=i)
            if not pv: pv=t.get_field('Potential',region=i)
            if pv:
                u=np.asarray(pv['values']).reshape(-1); assert len(u)==len(nodes)
                e1,e2=np.moveaxis(pts[itri[:,1:]]-pts[itri[:,:1]],1,0); du1,du2=(u[itri[:,1:]]-u[itri[:,:1]]).T
                det=e1[:,0]*e2[:,1]-e1[:,1]*e2[:,0]; m=abs(det)>1e-10
                g=np.column_stack((du1[m]*e2[m,1]-du2[m]*e1[m,1], e1[m,0]*du2[m]-e2[m,0]*du1[m]))*(-1e4/det[m,None]); ef=vec[itri[m]].mean(1); ng=np.linalg.norm(g,axis=1); ne=np.linalg.norm(ef,axis=1); ok=(ng>1e5)&(ne>1e5)
                if ok.any(): checks.append((nm,int(ok.sum()),float(np.median((g[ok]*ef[ok]).sum(1)/(ng[ok]*ne[ok]))),float(np.median(ne[ok]/ng[ok]))))
        ax.add_collection(LineCollection(xy[ed[c==1]],colors='#333840',linewidths=.48,zorder=3))
    assert V['anode']<0 and abs(V['cathode'])<1e-8 and all(abs(v-V['anode'])<1e-8 for k,v in V.items() if k!='cathode')
    assert any(n=='region_epi' and abs(cos)>.94 and .8<ratio<1.2 for n,count,cos,ratio in checks),checks
    jc,idx=pair_plt(raw/Path(pl).name,V['anode']);
    for k,(lab,col,style) in contacts.items():
        if k not in lines: continue
        ax.add_collection(LineCollection(lines[k],colors='white',linewidths=3.25,zorder=4))
        ax.add_collection(LineCollection(lines[k],colors=col,linewidths=1.85,linestyles=style,zorder=5))
    ax.axvline(52.0,color='#3c3c3c',alpha=0) if False else None
    ax.set(xlim=(x0,x1),ylim=(y1,y0),xticks=[0,20,40,60,80],yticks=[-2,0,2,4,6,8,10]); ax.set_title(f'({letter}) {name}\n$V_{{\\mathrm{{anode,ext}}}}$ = −{abs(V["anode"])/1000:.3f} kV',loc='left',pad=6)
    stats=np.percentile(numbers,[50,95,99,100]).tolist()
    meta.append(dict(name=name,tdr=src,plt=pl,tdr_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),voltage=V,plt_row_zero_based=idx,cathode_current_A=jc,nodal_p50_p95_p99_max_MV_cm=stats,potential_gradient_check=checks))
    print(name,V['anode'],jc,stats,checks[:2])
cb=fig.colorbar(ScalarMappable(norm=norm,cmap=cmap),cax=fig.add_axes([.90,.21,.026,.67]),ticks=np.arange(0,9,1),extend='max'); cb.ax.set_title('$|E|$\n(MV/cm)',fontsize=9,pad=7)
fig.supxlabel('Radius $r$ (µm)',x=.48,y=.113,fontsize=10); fig.supylabel('Depth $y$ (µm)',x=.018,y=.555,fontsize=10)
fig.legend(handles=[Line2D([0],[0],color=col,lw=2,ls=ls,label=lab) for k,(lab,col,ls) in contacts.items() if k!='anode_rim'],loc='lower center',bbox_to_anchor=(.485,.052),ncol=3,frameon=False)
fig.text(.48,.027,'Grey: Al₂O₃  •  Backside cathode is outside the plotted window',ha='center',fontsize=8)
for fmt in ('pdf','png'): fig.savefig(out/'figures'/f'architecture_reverse_fields.{fmt}',dpi=450,facecolor='white')
(out/'architecture_field_provenance.json').write_text(json.dumps(dict(root='Final_Research',window_um=[x0,x1,y0,y1],colors_MV_cm=[0,hi],states=meta),indent=2),encoding='utf-8')
