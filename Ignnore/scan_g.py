import pathlib, re, collections, sys

root = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else ".")
rx = re.compile(r"BarrierTunneling_:\s*ge\s*=\s*([0-9.eE+-]+),\s*instead of".replace("ge", "g_e"))

rows = collections.defaultdict(list)
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
    rows[str(p.parent.relative_to(root))].append((p.name, sorted(set(ms))))

print("=== TOP-LEVEL FOLDERS ===")
for d in sorted(x.name for x in root.iterdir() if x.is_dir()):
    print("  " + d)

print("\n=== REVERSE LOGS BY FOLDER ===")
for k in sorted(rows):
    gs = set()
    for _f, ms in rows[k]:
        gs.update(ms)
    print("%-72s %2d logs  g=%s" % (k, len(rows[k]), ",".join(sorted(gs))))
