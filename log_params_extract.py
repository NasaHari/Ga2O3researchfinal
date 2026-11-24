#!/usr/bin/env python3
"""
log_params_extract.py -- reusable reader for Sentaurus Device solver logs.

Extracts EVERY parameter the solver actually applied, with its scope, from a
SDevice log (the ".log_des.log" / ".log" written next to the .plt).

It understands the two echo formats SDevice emits:

  (a)  Region-section format, printed per region/material:
         =======
         Region: "region_pgan"
           (material is "GaN")
         =======
           Model: "BarrierTunneling"
             Parameter "g_e" is modified from 2.1 to 1e-13

  (b)  "Differences compared with default parameters:" format, printed per
       parameter set (default / material / interface / electrode):
         BarrierTunneling_: g_e = 1.5600e-08, instead of: 2.1 [1]

Every record carries: line number, scope (default|material|region|interface|
electrode), scope name, region, material, model, parameter, old value, new
value, unit.

Usage
-----
  python log_params_extract.py LOG
  python log_params_extract.py LOG --grep 'gan|pgan'          # filter
  python log_params_extract.py LOG --grep BarrierTunneling --csv bt.csv
  python log_params_extract.py LOG --tree                     # scope summary
  python log_params_extract.py LOG --csv all.csv --quiet
  python log_params_extract.py LOG_A --diff LOG_B             # what changed
  python log_params_extract.py LOG --grep 'g_e|g_h' --show-old

Notes
-----
* Form (b) is the *parameter-set* view; form (a) is the *region* view. The same
  physical parameter can appear in both, at different scopes -- that is real
  information, not duplication (e.g. a material value 1.56e-8 overridden to
  1e-13 inside GaN). Do not "dedupe" across forms.
* Only applied/replaced values are reported. Anything not listed ran at the
  database default.
"""

import argparse
import csv
import re
import sys

RE_READING = re.compile(r'Reading parameters for (.+)$')
RE_REGION_HDR = re.compile(r'^Region: "([^"]+)"')
RE_MATERIAL_HDR = re.compile(r'^\s*\(material is "([^"]+)"\)')
RE_MODEL = re.compile(r'^\s*Model: "([^"]+)"')
RE_MODIFIED = re.compile(
    r'Parameter "([^"]+)" is modified from (\S+) to (\S+)')
RE_INSTEAD = re.compile(
    r'^\s*([A-Za-z0-9_]+):\s*(\S+)\s*=\s*(\S+?),\s*instead of:\s*(\S+?)\s*'
    r'(?:\[([^\]]+)\])?\s*$')

# "Reading parameters for region "x"" / material "y" / material interface "z"
RE_SCOPE = re.compile(
    r'Reading parameters for (default parameter set|region "(?P<r>[^"]+)"|'
    r'material "(?P<m>[^"]+)"|material interface "(?P<i>[^"]+)"|'
    r'electrode "(?P<e>[^"]+)")')


def _norm(v):
    """Collapse numeric formatting so 1e-13 == 1.0000e-13 in diffs."""
    try:
        return repr(float(v))
    except (TypeError, ValueError):
        return v.strip()


def parse_log(path):
    recs = []
    scope, scope_name = "unknown", ""
    region, material, model = "", "", ""
    in_region_block = False
    with open(path, errors="ignore") as fh:
        for n, line in enumerate(fh, 1):
            line = line.rstrip("\n")

            m = RE_SCOPE.search(line)
            if m:
                key = m.group(0).replace("Reading parameters for ", "")
                if key.startswith("default"):
                    scope, scope_name = "default", ""
                elif key.startswith("region"):
                    scope, scope_name = "region", m.group("r")
                elif key.startswith("material interface"):
                    scope, scope_name = "interface", m.group("i")
                elif key.startswith("material"):
                    scope, scope_name = "material", m.group("m")
                elif key.startswith("electrode"):
                    scope, scope_name = "electrode", m.group("e")
                region, material, model = "", "", ""
                in_region_block = False
                continue

            m = RE_REGION_HDR.match(line)
            if m:
                region = m.group(1)
                material, model = "", ""
                scope, scope_name = "region", region
                in_region_block = True
                continue

            m = RE_MATERIAL_HDR.match(line)
            if m:
                material = m.group(1)
                continue

            m = RE_MODEL.match(line)
            if m:
                model = m.group(1)
                continue

            # form (a): per-region applied value
            m = RE_MODIFIED.search(line)
            if m:
                param, old, new = m.group(1), m.group(2), m.group(3)
                recs.append(dict(
                    line=n, form="region", scope=scope, scope_name=scope_name,
                    region=region, material=material, model=model,
                    param=param, old=old, new=new, unit=""))
                continue

            # form (b): parameter-set "instead of" difference
            if "instead of:" not in line:
                continue
            m = RE_INSTEAD.match(line)
            if not m:
                continue
            model_b, param, new, old, unit = (
                m.group(1), m.group(2), m.group(3), m.group(4), m.group(5) or "")
            recs.append(dict(
                line=n, form="set", scope=scope, scope_name=scope_name,
                region="", material=scope_name if scope == "material" else "",
                model=model_b.rstrip("_"), param=param,
                old=old, new=new, unit=unit))
    return recs


def apply_filter(recs, pattern):
    if not pattern:
        return recs
    rx = re.compile(pattern, re.I)
    return [r for r in recs if any(rx.search(str(r[k])) for k in
                                   ("scope", "scope_name", "region", "material",
                                    "model", "param", "new", "old"))]


def print_table(recs, max_rows=None, show_old=False):
    if not recs:
        print("(no matching parameter lines)")
        return
    w = [6, 7, 10, 20, 13, 15, 28, 14, 14]
    hdr = ["line", "form", "scope", "scope_name", "region", "material",
           "model.param", "new"]
    if show_old:
        hdr.append("old")
    print("  ".join(h[:w[i]].ljust(w[i]) for i, h in enumerate(hdr)))
    print("  ".join("-" * w[i] for i in range(len(hdr))))
    for r in recs[:max_rows] if max_rows else recs:
        row = [str(r["line"]), r["form"], r["scope"], r["scope_name"],
               r["region"], r["material"],
               f'{r["model"]}.{r["param"]}', r["new"] + r["unit"]]
        if show_old:
            row.append(r["old"] + r["unit"])
        print("  ".join(str(c)[:w[i]].ljust(w[i]) for i, c in enumerate(row)))


def print_tree(recs):
    """Scope -> model summary: where the changes actually are."""
    from collections import defaultdict
    tree = defaultdict(lambda: defaultdict(list))
    for r in recs:
        key = r["scope_name"] or r["region"] or "default"
        tree[key][r["model"] or "?"].append(r["param"])
    for scope in sorted(tree, key=lambda s: (s != "default", s)):
        n = sum(len(v) for v in tree[scope].values())
        print(f"\n{scope}   ({n} changed parameters)")
        for model in sorted(tree[scope]):
            ps = tree[scope][model]
            shown = ", ".join(sorted(set(ps))[:12])
            more = "" if len(set(ps)) <= 12 else f" ... +{len(set(ps))-12}"
            print(f"   {model:22s} {shown}{more}")


def key(r):
    return (r["scope"], r["scope_name"], r["region"], r["model"], r["param"])


def diff_logs(a, b, name_a="A", name_b="B"):
    ka = {key(r): r for r in a}
    kb = {key(r): r for r in b}
    print(f"{len(ka)} entries in {name_a}, {len(kb)} in {name_b}\n")
    only_a = [k for k in ka if k not in kb]
    only_b = [k for k in kb if k not in ka]
    changed = [k for k in ka if k in kb and
               (_norm(ka[k]["new"]) != _norm(kb[k]["new"]))]

    def show(title, keys, src, col):
        if not keys:
            return
        print(f"--- {title} ({len(keys)})")
        for k in sorted(keys):
            r = src[k]
            where = r["region"] or r["scope_name"] or r["scope"]
            print(f"   {where:26s} {r['model']}.{r['param']:24s} "
                  f"{r[col]}{r['unit']}")
        print()

    show(f"only in {name_a}", only_a, ka, "new")
    show(f"only in {name_b}", only_b, kb, "new")
    if changed:
        print(f"--- different value ({len(changed)})")
        for k in sorted(changed):
            where = ka[k]["region"] or ka[k]["scope_name"] or ka[k]["scope"]
            print(f"   {where:26s} {ka[k]['model']}.{ka[k]['param']:24s} "
                  f"{name_a}={ka[k]['new']}  {name_b}={kb[k]['new']}")
    else:
        print("--- no parameter differs in value")


def main(argv=None):
    ap = argparse.ArgumentParser(
        description="Extract applied parameters from a Sentaurus solver log.")
    ap.add_argument("log", help="solver log (.log_des.log / .log)")
    ap.add_argument("--grep", default=None,
                    help="regex filter on scope/region/material/model/param")
    ap.add_argument("--csv", default=None, help="write all matches to CSV")
    ap.add_argument("--tree", action="store_true",
                    help="print scope -> model summary instead of a table")
    ap.add_argument("--show-old", action="store_true",
                    help="also show the replaced value")
    ap.add_argument("--max", type=int, default=40,
                    help="max table rows on screen (default 40)")
    ap.add_argument("--quiet", action="store_true",
                    help="no screen table, only counts / CSV")
    ap.add_argument("--diff", default=None, metavar="LOG_B",
                    help="compare this log against LOG_B")
    args = ap.parse_args(argv)

    recs = parse_log(args.log)
    if not recs:
        print("No parameter echoes found in", args.log)
        return 1

    if args.diff:
        diff_logs(recs, parse_log(args.diff), args.log, args.diff)
        return 0

    sel = apply_filter(recs, args.grep)

    if args.csv:
        with open(args.csv, "w", newline="") as fh:
            wr = csv.DictWriter(fh, fieldnames=list(recs[0].keys()))
            wr.writeheader()
            wr.writerows(sel)
        print(f"[csv] {len(sel)} rows -> {args.csv}")

    if args.tree:
        print_tree(sel)
        return 0

    if not args.quiet:
        print_table(sel, args.max, args.show_old)
        if len(sel) > args.max:
            print(f"... {len(sel) - args.max} more rows "
                  f"(raise --max or use --csv)")

    print(f"\n[summary] {len(sel)} of {len(recs)} applied-parameter entries"
          + (f" matched /{args.grep}/" if args.grep else ""))
    return 0


if __name__ == "__main__":
    sys.exit(main())
