import pathlib, re, collections, sys

root = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else ".")
rx = re.compile(r"BarrierTunneling_:\s*g_e\s*=\s*([0-9.eE+-]+),\s*instead of")

rows = collections.defaultdict(set)
cnt = collections.defaultdict(int)
for p in root.rglob("*.log*"):
    n = p.name.lower()
    if "rev" not in n and "pilot" not in n:
        continue
    try:
        txt = p.read_text(errors="ignore")
    except Exception:
        continue
    ms = rx.findall(txt)
    if not ms:
        continue
    rows[str(p.parent.relative_to(root))].update(ms)
    cnt[str(p.parent.relative_to(root))] += 1

def cls(gs):
    has13 = any(x.startswith("1.0000e-13") for x in gs)
    has8 = any(x.startswith("1.5600e-08") for x in gs)
    if has8 and has13:
        return "A_g1.56e-8"
    if has13:
        return "B_g1e-13"
    return "C_other"

groups = collections.defaultdict(list)
for k, gs in rows.items():
    groups[cls(gs)].append((k, cnt[k], sorted(gs)))

print("=== TOP-LEVEL FOLDERS IN", root.resolve().name, "===")
for d in sorted(x.name for x in root.iterdir() if x.is_dir()):
    print("  " + d)

for g in sorted(groups):
    print("\n=== %s (%d folders) ===" % (g, len(groups[g])))
    for k, c, gs in sorted(groups[g]):
        print("  %-70s %d log(s)  %s" % (k, c, ",".join(gs)))
