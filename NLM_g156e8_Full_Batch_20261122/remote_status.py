#!/usr/bin/env python3
import os, glob, re, math, subprocess, time

BATCH_DIR = "/home/2023b5aa1006g/synopsys_chipin_work/STDB/tmp/Yang_OldPublished_Model_Adapted/Pgan_Boost_Research_20261114/15_LeanMesh_Calibration/NLM_g156e8_Full_Batch_20261122"
A_ACT = 8.659015e-5

RUNS = [
    ("01_Planar_WF4p75",    "Planar 150nm", "0.75 eV (WF=4.75)", 3500.0),
    ("02_Planar_WF4p90",    "Planar 150nm", "0.90 eV (WF=4.90)", 3500.0),
    ("03_Planar_WF5p10",    "Planar 150nm", "1.10 eV (WF=5.10)", 3500.0),
    ("04_Planar_WF5p30",    "Planar 150nm", "1.30 eV (WF=5.30)", 3500.0),
    ("05_Mesa_WF4p75",      "Mesa JBS",     "0.75 eV (WF=4.75)", 3500.0),
    ("06_Mesa_WF4p90",      "Mesa JBS",     "0.90 eV (WF=4.90)", 3500.0),
    ("07_Mesa_WF5p10",      "Mesa JBS",     "1.10 eV (WF=5.10)", 3500.0),
    ("08_Mesa_WF5p30",      "Mesa JBS",     "1.30 eV (WF=5.30)", 3500.0),
    ("09_Trench_WF4p75",    "Trench JBS",   "0.75 eV (WF=4.75)", 3000.0),
    ("10_Thin080nm_WF5p10", "Thin 80nm",    "1.10 eV (WF=5.10)", 3500.0),
    ("11_Thin080nm_WF4p75", "Thin 80nm",    "0.75 eV (WF=4.75)", 3500.0),
]

def get_running_cmds():
    try:
        return subprocess.check_output(["ps", "-u", "2023b5aa1006g", "-f"], text=True)
    except Exception:
        return ""

def parse_plt(plt_path):
    if not os.path.exists(plt_path):
        return []
    txt = open(plt_path, errors="ignore").read()
    m_ds = re.search(r"datasets\s*=\s*\[(.*?)\]", txt, re.S)
    if not m_ds:
        return []
    names = [n.strip() for n in re.findall(r'"([^"]+)"', m_ds.group(1))]
    m_da = re.search(r"Data\s*\{([^}]*)\}", txt, re.S)
    if not m_da:
        return []
    nums = []
    for tok in m_da.group(1).split():
        try:
            nums.append(float(tok))
        except ValueError:
            pass
    ncols = len(names)
    if ncols == 0:
        return []
    nrows = len(nums) // ncols
    rows = [nums[i*ncols:(i+1)*ncols] for i in range(nrows)]
    v_idx = next((i for i, n in enumerate(names) if "anode" in n and "OuterVoltage" in n), 0)
    ic_idx = next((i for i, n in enumerate(names) if "cathode" in n and "TotalCurrent" in n), None)
    ia_idx = next((i for i, n in enumerate(names) if "anode" in n and "TotalCurrent" in n), None)
    ie_idx = next((i for i, n in enumerate(names) if "anode" in n and "eCurrent" in n), None)
    ih_idx = next((i for i, n in enumerate(names) if "anode_pgan" in n and "hCurrent" in n), None)
    return [(
        abs(r[v_idx]),
        abs(r[ic_idx]) / A_ACT if ic_idx is not None else 0.0,
        abs(r[ia_idx]) / A_ACT if ia_idx is not None else 0.0,
        abs(r[ie_idx]) / A_ACT if ie_idx is not None else 0.0,
        abs(r[ih_idx]) / A_ACT if ih_idx is not None else 0.0,
    ) for r in rows]

def interp_5sample(pts, j_target, col=1):
    n = len(pts)
    for k in range(n - 1):
        v1, j1 = pts[k][0], pts[k][col]
        v2, j2 = pts[k+1][0], pts[k+1][col]
        if v1 >= 50.0 and j1 <= j_target <= j2 and j1 > 0 and j2 > j1:
            above = all(pts[m][col] >= j_target for m in range(k+1, min(k+6, n)))
            if above or (k+1 == n-1):
                return v1 + (v2 - v1) * (math.log10(j_target) - math.log10(j1)) / (math.log10(j2) - math.log10(j1))
    return None

def j_at_v(pts, v_target, col=1):
    best = min((p for p in pts if p[0] >= 50.0), key=lambda p: abs(p[0] - v_target), default=None)
    return best[col] if best and abs(best[0] - v_target) < 50.0 else None

ps_out = get_running_cmds()
print("=" * 145)
print(f" NLM g = 1.56e-8 PARALLEL BATCH STATUS  |  {time.strftime('%Y-%m-%d %H:%M:%S')}  |  Cluster: 10.8.8.15")
print("=" * 145)
print(f"{'Run Folder':22s} | {'Arch':12s} | {'Barrier':17s} | {'State':17s} | {'Steps':5s} | {'|V_end|':9s} | {'J(1000V)':10s} | {'J(1500V)':10s} | {'|J_end|':10s} | {'V_BR(0.1mA)':11s} | {'V_BR(1mA)':9s}")
print("-" * 145)
done_cnt = 0
for rname, arch, bar, goal in RUNS:
    rdir = os.path.join(BATCH_DIR, rname)
    plt_p = os.path.join(rdir, f"rev_{rname}.plt")
    stdout_p = os.path.join(rdir, f"rev_{rname}.stdout")
    pts = parse_plt(plt_p)
    is_running = f"rev_{rname}.cmd" in ps_out
    txt = open(stdout_p, errors="ignore").read()[-6000:] if os.path.exists(stdout_p) else ""
    if is_running:
        state = "RUNNING"
    elif "BreakCriteria" in txt or "break criteria" in txt.lower():
        state = "DONE (Compliance)"
        done_cnt += 1
    elif os.path.exists(os.path.join(rdir, f"rev_{rname}_final_des.tdr")) or "goodbye" in txt.lower() or " elapsed " in txt.lower():
        state = "DONE"
        done_cnt += 1
    elif os.path.exists(stdout_p):
        state = "STOPPED/CHECK"
        done_cnt += 1
    else:
        state = "WAITING"
    v_now = pts[-1][0] if pts else 0.0
    j_now = pts[-1][1] if pts else 0.0
    j1000 = j_at_v(pts, 1000.0)
    j1500 = j_at_v(pts, 1500.0)
    v01 = interp_5sample(pts, 1e-4)
    v1 = interp_5sample(pts, 1e-3)
    print(f"{rname:22s} | {arch:12s} | {bar:17s} | {state:17s} | {len(pts):5d} | {v_now:7.1f} V | {f'{j1000:.2e}' if j1000 else '       -':10s} | {f'{j1500:.2e}' if j1500 else '       -':10s} | {j_now:10.2e} | {f'{v01:9.1f} V' if v01 else '        -  ':11s} | {f'{v1:7.1f} V' if v1 else '      -  ':9s}")
print("-" * 145)
print(f"Summary: {done_cnt} / {len(RUNS)} runs completed.")
if done_cnt == len(RUNS):
    print("ALL_11_DONE")
