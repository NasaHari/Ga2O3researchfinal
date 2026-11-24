# Structure audit — realism check of every device geometry

Read from the generators in `04_mesh_generators/` (planar / mesa / trench / bare), plus the
bare split builder. Line numbers refer to those files.

## Common frame (all p-GaN architectures)

| Item | Value |
|---|---|
| Domain | W_dev = 135 µm, T_epi = 10 µm, Y_sub_bot = 660 µm |
| Anode (Schottky) | r = 0 … 51.20 µm at y = 0, 80 nm fillet, plus a 150 nm tall vertical wall at r = 51.20 |
| Al₂O₃ spacer | 51.20 … 52.50 µm, 1.50 µm tall |
| p-GaN | 51.45 … 87.00 µm, 0.15 µm thick, three Mg zones 5.0 / 2.8 / 1.6 ×10¹⁸ |
| p-GaN contact window | 52.50 … 54.50 µm (2 µm), top surface only |
| Passivation | 54.50 … 135 µm, 1.50 µm |
| Ambient | 54.50 … 135 µm, y = −2.50 … −1.50, material "Oxide" with ε_r = 1 |
| Field plate | Al region 55.00 … 67.00 µm, 0.30 µm thick, sitting on the passivation |

Sheet doses: collar 7.5×10¹³, mid 4.2×10¹³, JTE 2.4×10¹³ cm⁻².
Drift column at 2.34 kV (W ≈ 6.7 µm): 1.34×10¹³ cm⁻².
→ collar 5.6×, mid 3.1×, JTE 1.8× the charge that must be terminated.

## Findings

**1. Schottky contact on a dielectric boundary — HIGH, must verify.**
`planar/build_planar_150nm_sn.scm:99-104` assigns the `anode` contact to the bottom disc, the
80 nm fillet arc *and* a vertical face at r = 51.20 spanning y = 0 … −0.15. The only region
adjacent to that face is `region_al2o3_spacer` (51.20 … 52.50). A Schottky boundary condition on
a metal/oxide interface injects nothing and is not physical.
*Fix:* delete the wall and keep the disc + fillet; or extend the epi/ambient so the face
borders semiconductor. Confirm with one bias point and a field plot at (51.2, −0.1).

**2. No metal regions anywhere except the field plate — HIGH (disclosure).**
`anode`, `anode_pgan`, `cathode` are zero-thickness boundary contacts; only `region_fp_dummy`
is real aluminium. So no metal sheet resistance, no current spreading, no pad capacitance.
*Fix:* state "ideal boundary contacts" in the methods, or add thin metal regions.

**3. Ambient is a 1 µm slab of ε_r = 1 oxide covering only r = 54.5 … 135 — MEDIUM.**
Nothing models the air above the anode disc (r < 51.2) or above the spacer (51.2 … 54.5), so
field lines there terminate on the anode wall contact of finding 1 instead of in air. The
"vacuum" is also a solid material called Oxide.
*Fix:* one ambient block over the whole top, cut by the raised features; rename to a vacuum
material.

**4. p-GaN is contacted 1.05–1.3 µm behind its own front edge — MEDIUM, quantified.**
The film starts at 51.45 µm but the contact window opens at 52.50. With Mg 5×10¹⁸, μ_p = 4.49
cm²/Vs (Masetti at that doping) and t = 0.15 µm, the sheet resistance is **1.85×10⁴ Ω/sq**, so a
1.3 µm radial path at r ≈ 53 µm carries **≈72 Ω**. At 100 A/cm² over 8.659×10⁻⁵ cm² that is
**0.63 V** — comparable to V_on = 0.70 V. Also the 5×10¹⁸ collar extends to 56.5 µm, so part of
it (54.5 … 56.5) is buried under passivation and dead.
*Fix:* widen the window to start at 51.45 and end at 54.5, or report the series term explicitly.

**5. Mesa device mixes two p-GaN thicknesses — MEDIUM (process).**
`mesa/build_mesa_150nm_sn.scm`: active mesas 0.50 µm tall (W = 2.00 µm, pitch 5.00 µm, spacer
0.20 µm) while the JTE film is 0.15 µm. One device therefore needs either two depositions or a
two-step etch.
*Fix:* state the process step, or unify the JTE annulus to the mesa thickness.

**6. Trench device is a 1 µm deep refill — MEDIUM (feasibility).**
`trench/build_trench_150nm_sn.scm`: etch 1.00 µm into the β-Ga₂O₃ epi, refill with p-GaN, plus a
0.15 µm cap above the surface, bottom radius 0.15 µm, spacer 0.30 µm. This is the published HJBS
concept but at an aspect ratio that is not demonstrated for sputtered GaN.
*Fix:* declare it as modelled; if challenged, note trench depth is the single knob.

**7. Corner fillets of 50–150 nm are numerical — LOW (disclosure).**
`R_sch_fil = 0.08`, `R_jte_fil = 0.05`, `R_ring_fil = 0.05`, `R_tr_bot = 0.15`, `R_fp_* = 0.08 …
0.15`. No process produces a 50 nm radius on a 150 nm film.
*Fix:* one methods sentence plus the existing corner-convergence studies (16_/17_/18_).

**8. Fixed charge −2.67×10¹¹ cm⁻² applied to the entire Ga₂O₃/Al₂O₃ interface — LOW.**
Includes the wall under the field plate and the trench sidewalls; it is a fitted value.
*Fix:* label it calibrated, and state the sign convention (negative = depletion of the n-drift).

**9. Different domain radii between families — LOW.**
Terminated devices W_dev = 135 µm, bare references 105 µm (and 135 in one variant). The 1 mA/cm²
normalisation uses A = 8.659×10⁻⁵ cm² (r = 52.5) in all cases, so the current criterion is
consistent, but substrate spreading resistance is not.
*Fix:* say so, or unify to 105 µm.

**10. Bare reference is a different mesh family — LOW (already known).**
`bare_split_105um` resolves the corner at 16 nm against 40 nm for terminated devices, and uses
`Ref_*` windows rather than `rs_*`.
*Fix:* describe the 929 V vs 2336 V as per-architecture converged meshes, not a like-for-like gain.

## What to do first

Finding 1 (contact on dielectric) is the only item that can invalidate a number. Everything else
is a disclosure or a forward-bias correction. Findings 2, 3, 4 and 7 are one paragraph of methods
each; findings 5 and 6 are one sentence of process.
