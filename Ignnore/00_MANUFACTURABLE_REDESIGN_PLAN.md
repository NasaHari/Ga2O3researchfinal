# Manufacturable Redesign and Re-Simulation Plan

**Scope:** the whole `15_LeanMesh_Calibration` campaign (52 cases / 90 production decks / 6 architectures / 5 sensitivity studies), not only the paper folder.
**Question answered:** if this study were repeated today, designing every device for a real fabrication line, what changes, why, and how is it implemented in Sentaurus?

**Evidence tags used below**
`[IMPLEMENTED]` read from a source deck/SCM I inspected; `[SIMULATED]` from a converged `.plt`/`.tdr`; `[VERIFIED-LIT]` I fetched the paper and read the number myself this session; `[PRIOR-AUDIT]` recorded in an earlier audit but **not re-verified** — treat as a lead, not a fact; `[JUDGEMENT]` my engineering assessment.

---

# Part 0 — The answer in one page

1. **Keep the material stack, the bare control, and the physics skeleton.** The 10 µm / 2×10¹⁶ cm⁻³ drift on a 650 µm Sn-doped (001) substrate is the least controversial part of the work and matches commercial HVPE capability. The bare Yang-calibrated diode is your only measurement-anchored result. Neither should be rebuilt.
2. **Three structural abstractions have to go, because the field solution depends on them, not because they look idealised:**
   * the **0.17–0.25 µm Schottky/JTE gap** under a 6–8.8:1 dielectric aspect ratio,
   * the **1.5 µm monolithic ALD Al₂O₃** carrying 5–6 MV/cm,
   * the **hollow field-plate "cavity"** (region created, then `delete-region`'d — zero metal in the mesh).
3. **One abstraction has to go because no process exists for it:** the **three coplanar abrupt Mg zones (5.0/2.8/1.6×10¹⁸ cm⁻³) inside one continuous 150 nm film**. Replace with either a discrete ring termination (the experimentally demonstrated SM-JTE approach) or a single-Mg, stepped-thickness film.
4. **One verdict from the earlier audit is wrong and must be reversed:** "the trench family has no precedent." A **p-NiO/β-Ga₂O₃ trench JBS with SM-JTE is experimentally demonstrated** (>1.8 kV, fin widths 0.6–1.25 µm, leakage <10⁻² A/cm²) `[VERIFIED-LIT]`. What has no precedent is a **p-GaN-filled** 2 µm × 1 µm trench. The architecture survives; the material assignment does not.
5. **Recalibrate four things after any geometry change:** JTE sheet charge (RESURF window), dielectric stack thickness/field margin, corner radius + mesh convergence, and the p-type leakage model (Poisson–Frenkel / VRH). Nothing else in the physics set needs re-fitting.
6. **Do not report an absolute hardware V_BR for terminated devices.** Report a band over a process window, with the dielectric margin and the region-resolved avalanche fraction.

The rest of this document justifies each of these, gives the numbers with sources, and ends with an ordered roadmap.

---

# Part A — What actually exists now (my own inspection, not file comments)

## A.1 Campaign inventory

| Study dir | Cases | What it varies |
|---|---|---|
| `Study1_Architectures` | 8 | bare 105 µm, bare 135 µm, planar ±FP, mesa ±FP, trench ±FP |
| `Study2_Thickness_Doping` | 15 | Mg ×0.25–2.00, p-GaN thickness 0.08–0.35 µm, mesa height 0.25/1.00, trench depth 1.50 |
| `Study3_Barrier_Height` | 20 | WF 4.75/4.90/5.10/5.30/5.50 on bare + 3 architectures |
| `Study4_Temperature` | 8 | 350 K, 400 K on 4 architectures |
| `Study5_Champion_080nm_075eV` | 1 | thin/low-barrier champion |

`[IMPLEMENTED]` Counted on disk. 90 forward/reverse decks resolve their `Grid` and `Parameter` relative paths; 52 cases have archived `.plt`.

## A.2 Geometric parameters — read directly from the generators

Planar JTE + FP (`01_pGaN_JTE_FieldPlate/build_v5_superlean.scm`) `[IMPLEMENTED]`:

| Symbol | Value | Note |
|---|---|---|
| `W_dev` | 135 µm | domain radius |
| `T_epi` | 10 µm | drift |
| `Y_sub_bot` | 660 µm | 650 µm substrate under the epi |
| `T_al2o3` | 1.50 µm | single monolithic dielectric |
| `T_ambient` | 1.00 µm, ε_r = 1.0 | "air" modelled as permittivity-1 solid |
| `T_pgan` | 0.150 µm | JTE film |
| `X_sch` | 51.20 µm | anode radius, 0.08 µm fillet |
| `X_via_L/R` | 52.50 / 54.50 µm | dielectric opening |
| `X_fp_in` → `X_fp_toe` | 55.00 → 67.00 µm | FP 12 µm long, 0.30 µm thick |
| `X_jte_in/12/23/out` | 51.45 / 56.50 / 63.00 / 87.00 µm | 3 zones: 5.05, 6.50, 24.00 µm |
| Mg zones | 5.0 / 2.8 / 1.6 ×10¹⁸ cm⁻³ | abrupt lateral steps |
| `N_epi`, `N_sub` | 2.0×10¹⁶ (`nSilicon`), 3.6×10¹⁸ (`nTin`) | **mixed species** |
| Fillets | 0.08 / 0.15 / 0.10 / 0.05 µm | anode, FP toe, FP corners, JTE |

Mesa (`build_mesa_superlean.scm`) `[IMPLEMENTED]`: `T_mesa` 0.50 µm, spacer 0.65 µm tall / 0.20 µm wide, **10 rings**, 2.00 µm wide, 5.00 µm pitch, 0.15 µm top overlap.
Trench (`build_trench_superlean.scm`) `[IMPLEMENTED]`: 10 fins, 2.00 µm wide, **1.00 µm deep**, cap 0.15 µm, spacer 0.30 µm, 0.15 µm bottom radius.

## A.3 Two hard facts I confirmed in the generators

* `[IMPLEMENTED]` `build_v5_superlean.scm:85` — `(sdegeo:delete-region (find-body-id (position 61.0 -1.65 0.0)))`, and the `anode_fp` contact is then defined on the **eight surviving cavity edges** (lines 110–119). The field plate is a **hole with a potential on its wall**, not metal. Consequences: (i) the simulated FP has no permittivity of its own and no metal–dielectric interface; (ii) any claim about FP-induced field spreading is a claim about a boundary condition, not a conductor; (iii) making it solid metal **changes the solution** and must be re-run before the FP gain is quoted.
* `[IMPLEMENTED]` Substrate doping uses `nTinActiveConcentration` while the drift uses `nSiliconActiveConcentration`. On a commercial Sn-doped EFG substrate both should be Sn; the mixed assignment is a modelling inconsistency that affects `R_on,sp` and substrate incomplete ionisation, i.e. exactly the quantity used in the reported efficiency comparison.

## A.4 Physics and solver, as executed

From `Study1_Architectures/01_Planar_JTE_FP/rev.cmd` `[IMPLEMENTED]`:

```
Temperature = 298.15
Mobility(DopingDependence HighFieldSaturation(GradQuasiFermi))
Recombination(SRH Auger Avalanche(vanOverstraeten GradQuasiFermi))
eBarrierTunneling "NLM_Anode"
Physics(Material="Ga2O3"){ IncompleteIonization(Dopants="nSilicon... nTin...") }
Physics(Material="GaN")  { IncompleteIonization(Dopants="pMagnesium...") }
Physics(MaterialInterface="GaN/Ga2O3")     { Thermionic RecVel(TempDep) }
Physics(MaterialInterface="Ga2O3/AluminumOxide"){ Recombination(SurfaceSRH) Traps(FixedCharge Conc=-2.67e11) }
Math { ExitOnFailure ComputeIonizationIntegrals() Cylindrical(xAxis=0) -CheckUndefinedModels }
NonLocal "NLM_Anode"(Electrode="anode" Length=15e-7 Direction=(0 1 0) MaxAngle=5
                     Digits=3 EnergyResolution=5e-3 RefinedIntervals=1e-8)
BreakCriteria { Current(Contact="cathode" AbsVal=1.0e-3) }
```

Two consequences worth stating plainly:

* `[IMPLEMENTED]` The solver's break criterion is **1 mA total**, i.e. ≈11.5 A/cm² on 8.659×10⁻⁵ cm² — a compliance stop, not your reported criterion. Your `V_BR,op` is a **post-processing** crossing at 1 mA/cm². That is legitimate but it means the solver runs far past the reported point, and near-breakdown steps are being taken in a regime where the number is already fixed. Add a second, earlier break criterion (Part E).
* `[IMPLEMENTED]` ε_r = 12.4 isotropic (`common/des_g156e8_sn.par:47`), Ga₂O₃ `Eg0 = 4.80`, `Chi0 = 4.00`, GaN `Eg0 = 3.51` with a temperature law (≈3.44 eV at 298 K), Al₂O₃ `epsilon = 9.0` in the interface block. The isotropy is the item that matters for RESURF; it is a modelling error against measured anisotropy, not a fabrication issue.

## A.5 Meshing

`[IMPLEMENTED]` Global 25/60 µm size with 2.0/2.0 max levels; epi window 3.5/1.0 → 0.50/0.25; rim window 0.04/0.025 → 0.015/0.008; p-GaN 1.50/0.08 → 0.25/0.03; JTE step windows 0.18/0.08 → 0.05/0.025; FP toe 0.25/0.25 → 0.08/0.08.

`[JUDGEMENT]` The rim window (15 nm × 8 nm) is finer than any physical corner radius you can etch, while the global mesh over the 660 µm substrate is coarse. That is the correct allocation for a corner-field problem, but it means **V_BR is a mesh-family property**: any comparison must be made within one mesh family, and the 16→2 nm corner ladder cannot be used as evidence of convergence for the terminated devices (it changes the physical corner, not just the discretisation).

---

# Part B — Manufacturability assessment, feature by feature

Categories: **A** = established in production/lab devices; **B** = demonstrated in a research device, plausible in a line; **C** = plausible but undemonstrated at this dimension; **D** = speculative; **E** = not manufacturable as drawn.

| # | Feature in the study | Verdict | Evidence (verified this session unless marked) |
|---|---|---|---|
| 1 | 10 µm, 2×10¹⁶ (001) HVPE drift + 650 µm Sn substrate | **A** | Commercial 100 mm HVPE drift reported at ±5 % thickness / ±7 % doping `[PRIOR-AUDIT, unverified]`; the stack itself is standard. |
| 2 | Drift thickness ±5 %, doping ±7 % | **A** | Same. Use as process-window inputs, not as design freedom. |
| 3 | Bare SBD, no termination | **A** | Yang 2017 baseline; your own calibration anchor. |
| 4 | 0.15 µm sputtered p-GaN JTE film | **B** | p-GaN on Ga₂O₃ is deposited by sputtering at low temperature; 0.08–0.15 µm is thinner than the ~0.5 µm in demonstrated kV devices `[PRIOR-AUDIT for Chang 2025/2026, unverified]`. Thinner is not a blocker, but **polycrystallinity and PF/VRH leakage are** and are absent from your deck. |
| 5 | Three coplanar abrupt Mg zones in one continuous film | **E** | No selective lateral doping at 150 nm depth: implant+activation needs a thermal budget incompatible with the epi, regrowth is chemically incompatible. Ring/stepped alternatives exist (row 8). |
| 6 | 0.25 µm dielectric opening, 0.17 µm effective gap | **E** as drawn | 6–8.8:1 fill aspect ratio; sub-micron overlay against ±0.25 µm (stepper) or ±0.5–1 µm (contact aligner) alignment. |
| 7 | 1.5 µm monolithic ALD Al₂O₃ | **E** as drawn | ~23 nm/h ALD → 1.5 µm ≈ 64 h; 200 MPa-class tensile stress vs ~0.1 % critical strain; and at the simulated 5–6 MV/cm it is already past a 3.5 MV/cm ten-year TDDB ceiling. |
| 7b | Ten-year dielectric reliability ceiling | **A (as a constraint)** | **Verified:** Al₂O₃ on β-Ga₂O₃ shows E_BD ≈ 10 MV/cm, with a **10-year TDDB lifetime at 3.5 MV/cm** (7.8 MV/cm for the bilayer process) — Roy et al., arXiv:2408.11342. |
| 8 | Discrete ring termination (SM-JTE) | **B** | **Verified:** NiO/Ga₂O₃ HJD with **2-step space-modulated JTE (concentric rings of varying width/spacing)** → **>3 kV**, V_on 0.8 V @1 A/cm², R_on,sp 4.4 mΩ·cm², FOM >2 GW/cm² — arXiv:2409.00344. |
| 9 | Field plate | **B** | **Verified:** 15 µm FP + N-implant termination → **1616 V**, 5.11 mΩ·cm², J_R 1.2×10⁻⁵ A/cm² @ −1000 V — Zhou et al., Nanomaterials 14 (2024) 978. And TiO₂/Al₂O₃ FP on (011): **3.90–4.16 kV with FP vs 3.06–3.16 kV without** — Hollar et al., arXiv:2610.04388. Note the honest size of the effect: **+0.8 to +1.0 kV**, not a doubling. |
| 10 | 1.0 µm-deep, 2 µm-wide, p-GaN-filled trench | **E** | Sputtered p-GaN is line-of-sight; filling a 2:1 wall/AR trench uniformly leaves voids and resist residue. **But see 10b.** |
| 10b | Trench JBS itself | **B, with NiO instead of p-GaN** | **Verified:** p-NiO/Ga₂O₃ **trench JBS + SM-JTE** → **>1.8 kV**, leakage <10⁻² A/cm², V_on ~1 V, R_on,sp 4–10.5 mΩ·cm², **fin widths 0.6–1.25 µm**, best at 0.85 µm — arXiv:2512.04033. So the *architecture* has precedent; the *material fill* you simulated does not. |
| 11 | 0.5 µm raised p-GaN islands, 2.0 µm wide / 3.0 µm gap | **B** | Same dielectric/etch classes as demonstrated ring devices; narrower pitch is a yield risk, not an impossibility. Widen to 2.5/1.5 µm if you want a demonstrated pitch `[PRIOR-AUDIT, unverified]`. |
| 12 | 83° etched sidewalls | **A (as a fact)** | **Verified:** ICP-RIE in BCl₃/Cl₂ with a Ni hard mask gives smooth sidewalls at **77 nm/min** (97 nm/min at 400 W ICP) — Okumura & Tanaka, JJAP 58 (2019) 120902. Etch depth is time-controlled, so depth tolerance ≈ ±10 % (or ±50 nm for a 1 µm step with 10 % over-etch). |
| 13 | Deterministic 80/150/200 nm CAD fillets | **C** | A real corner radius is an etch/mask-reflow outcome, not a design input. Keep as a **parameter**, report sensitivity. |
| 14 | Hollow FP cavity (no metal) | **E** | Fabrication-irrelevant: you cannot have a potential on a void. Must be solid metal, and the field solution will change. |
| 15 | Isotropic ε_r = 12.4 | **E as a model** | Measured anisotropy (12.4 / 10.87 / 10.2) means lateral RESURF is over-estimated by 14–18 % `[PRIOR-AUDIT, unverified]`. Fix in TCAD, not in the process. |
| 16 | Ideal trap-free heterointerface, no PF/VRH leakage | **E as a model** | Real sputtered p-GaN and NiO reverse leakage is defect-dominated; your deck has neither. This is the single largest physics gap for any "manufacturable" claim. |
| 17 | 297-ish µm-thick substrate, no backside thinning | **C** | 650 µm is fine electrically (series resistance dominates), but any `R_on,sp` claim should state the substrate thickness assumed and that thinning to ~100 µm is standard practice. |

**Reading of the table.** Nothing about your **electrostatics** is wrong. What is wrong is (i) three features the field solution directly touches that no process can make, and (ii) two missing models (dielectric reliability, p-type defect leakage) that decide whether the reported operating point is even survivable.

---

# Part C — Structure-by-structure required changes

## C.1 Bare SBD (105 µm) — **freeze**
Retain byte-identical. Only additions: (a) unify substrate species to Sn and re-run once to quantify the `R_on` shift; (b) ±5 % thickness / ±7 % doping corners; (c) one mesh-family convergence record. No geometry change.

## C.2 Bare SBD (135 µm) — **retain as a domain-size control**
Keep, but stop presenting it as a device variant. It exists to test domain-radius sensitivity; say so.

## C.3 Planar p-GaN JTE, no FP — **redesign termination only**
| Change | From | To | Why |
|---|---|---|---|
| Termination | 3 coplanar Mg zones, 150 nm | **discrete SM-JTE rings**, uniform [Mg], 2–3 stepped groups | demonstrated approach (row 8) |
| Doping realisation | lateral abrupt steps | one Mg level, **stepped film thickness** (or ring geometry) | dosage = N_A·t is controllable; lateral concentration is not |
| Schottky gap | 0.25 µm nominal / 0.17 µm effective | **≥1.5 µm** | overlay + fill |
| Corner radius | 0.08 µm deterministic | **0.05–0.20 µm parameter** | etch outcome |
| ε_r | 12.4 isotropic | **10.2–10.87 lateral** | measured anisotropy |
| Leakage model | ideal | **PF (φ_t ≈ 0.74 eV) + 3-D VRH** in p-GaN | real film behaviour |

## C.4 Planar JTE + FP — **redesign termination, dielectric and plate**
As C.3, plus:

| Change | From | To | Why |
|---|---|---|---|
| Dielectric | 1.5 µm ALD Al₂O₃ | **~40 nm ALD Al₂O₃ + 400–600 nm PECVD SiNₓ/SiO₂** | stress, throughput, TDDB |
| FP body | deleted region, potential on cavity walls | **solid Al (0.5–1.0 µm), sloped toe** | it must be a conductor |
| FP length | 12 µm (55→67), i.e. 4 µm from the gap | **5–15 µm overhang from the gap**, toe to be optimised | Zhou: 15 µm FP `[VERIFIED-LIT]`; Hollar: +0.8–1.0 kV `[VERIFIED-LIT]` |
| Dielectric field | 5–6 MV/cm operating, 15+ MV/cm corner spikes | **≤3.5 MV/cm at every node** | Roy ten-year TDDB `[VERIFIED-LIT]` |
| Surface charge | −2.67×10¹¹ fixed, no traps | fixed charge **±50 %** + `D_it` 1–2×10¹² cm⁻²eV⁻¹ | process scatter |

## C.5 Raised-island p-GaN JBS (±FP) — **retain shape, add realism**
The 0.5 µm raised p-GaN island is *the right shape*. Changes: rings 2.5 µm / 1.5 µm gap; 83° sidewalls with `D_it`; spacer fill modelled as SiN not Al₂O₃; PF/VRH leakage; and a statement that the p-GaN is **polycrystalline**, so the thermionic model is a transport approximation, not a materials description.

## C.6 Trench JBS (±FP) — **change the material, keep the idea, or drop it**
Two defensible options, and the choice is a modelling decision you should make explicitly:
* **C.6a (recommended): p-NiO fin JBS + SM-JTE.** Fin width 0.85 µm (demonstrated), depth 1.0–1.5 µm, conformal ALD/sputtered NiO 30–60 nm, NiO is a wide-gap p-type oxide so the junction is a heterojunction with a real band offset. This is a *different device* from what you simulated, and it is the one with hardware behind it.
* **C.6b: delete the trench family.** Defensible if you cannot justify the added process modules — but then say the architecture was dropped for process complexity, not because 1.1 kV is "bad physics".

## C.7 New reference device to add: p-NiO/Ga₂O₃ HJD (+SM-JTE)
Not required, but it is the cheapest way to have a hardware-anchored heterojunction in the paper alongside the p-GaN abstraction (verified anchors: 2.2 kV at 7.7 µm drift with 7.5 MV/cm parallel-plane field on (100); >3 kV with 2-step SM-JTE).

---

# Part D — Proposed manufacturable specifications

All dimensions nominal with the tolerance that the process actually delivers. "Basis" cites the verified source or states that it is a design choice.

## D.1 Device A — planar JTE + hybrid dielectric + solid FP

| Parameter | Nominal | Tolerance | Basis |
|---|---|---|---|
| Drift / substrate | 10 µm, 2.0×10¹⁶ / 650 µm, 3.6×10¹⁸ | ±5 % t, ±7 % N_D | commercial HVPE |
| Anode radius / WF | 51.20 µm / 5.10 eV | ±0.25 µm / — | keep |
| Schottky–JTE gap | **1.50 µm** | ±0.25 µm | overlay + aspect ratio |
| Termination | **8–10 discrete rings**, uniform [Mg] 1.5–4×10¹⁸, widths 3.0/2.0/1.5 µm in 3 groups, gaps 2.0/3.0/4.0 µm, span ≈25 µm | ±0.25 µm CD; **sheet charge ±30 %** | SM-JTE demonstrated (arXiv:2409.00344) |
| Film thickness | 150 nm nominal (or 150/100/60 nm steps) | ±10 % | sputter |
| Corner radius | 100 nm | 50–200 nm | etch outcome |
| Dielectric | 40 nm Al₂O₃ + 450 nm SiNₓ | ±5 % / ±10 % | hybrid stack |
| FP | solid Al 0.8 µm, overhang 8 µm from gap, sloped toe | ±0.5 µm | arXiv:2409.00344 analogue |
| Surface charge | −2.67×10¹¹ | ±50 % | fitted, must be swept |
| Peak dielectric field | ≤3.5 MV/cm | — | ten-year TDDB `[VERIFIED-LIT]` |

## D.2 Device B — raised p-GaN ring JBS

| Parameter | Nominal | Tolerance | Basis |
|---|---|---|---|
| p-GaN film | 0.50 µm sputtered polycrystalline | ±10 % | demonstrated class |
| Rings | 10, **2.5 µm wide / 1.5 µm gap** (pitch 4.0 µm) | ±0.25 µm | pitch from demonstrated ring HJBS `[PRIOR-AUDIT, unverified]` |
| Sidewall | 83° ± 2° | — | ICP-RIE `[VERIFIED-LIT]` |
| Spacer | SiN 0.30–0.65 µm | ±10 % | fill |
| Interface traps | `D_it` 1–2×10¹² cm⁻²eV⁻¹ | factor 2 | upper-bound benchmark `[PRIOR-AUDIT]` |
| Leakage | PF φ_t 0.74 eV + 3-D VRH | φ_t ±0.05 eV | `[PRIOR-AUDIT]` |

## D.3 Device C — p-NiO fin JBS + SM-JTE (replaces p-GaN trench)

| Parameter | Nominal | Tolerance | Basis |
|---|---|---|---|
| Fin width / depth / pitch | **0.85 µm / 1.2 µm / 2.5 µm** | ±0.15 µm / ±0.12 µm | fins 0.6–1.25 µm demonstrated `[VERIFIED-LIT]` |
| NiO | 40 nm conformal, p ≈ 1×10¹⁸–1×10¹⁹ | factor 2 | ALD/sputter NiO demonstrated |
| Termination | 2-step SM-JTE | ±0.25 µm | `[VERIFIED-LIT]` |
| Etch | BCl₃/Cl₂ ICP-RIE | depth ±10 % | 77 nm/min `[VERIFIED-LIT]` |

## D.4 Device D — bare control
Frozen.

**Why these numbers and not others.** Every dimension above is either (a) unchanged from your current deck, (b) copied from a device I verified in the literature at the stated value (gap ≥1.5 µm, rings 2.5/1.5, fins 0.6–1.25, FP 5–15 µm, Al₂O₃ field ≤3.5 MV/cm), or (c) an explicitly labelled design choice to be optimised by your own simulation. Where I could not verify a dimension, I say so rather than dressing it as demonstrated.

---

# Part E — Sentaurus implementation

## E.1 Geometry (SDE)

1. **Never build a contact on a deleted region.** For the FP, create the metal region last and keep it: `create-rectangle … "Aluminum" "region_fp"`, then `set-contact-edges` on its outer boundary. Then re-run and expect a changed field distribution — the current 2336 V number belongs to the cavity boundary condition.
2. **Discrete rings, not zone rectangles.** Loop over ring index with `(do ((i 0 (+ i 1))) ((= i N)) …)`, each ring `xL_i = X_jte_in + Σ(width+gap)`. Give every ring a distinct region name so per-ring doping and plot cuts work.
3. **Stepped thickness** is the only clean way to realise a graded dose: `T_ring_i` from a list, all sharing one doping value.
4. **Two dielectrics = two material regions**, e.g. `"AluminumOxide"` 40 nm + `"Nitride"` 450 nm, with `MaterialInterface` physics on both interfaces so the normal-displacement check is physical.
5. **Fillet radius as a `define`.** Keep `R_corner` in one place; the sensitivity study then only changes one number.
6. `find-edge-id` returns an **error string** on failure, not `'()`. Guard with `(if (or (null? e) (string? e)) …)`. This bug has already produced a silently flat/disconnected anode in this campaign.
7. `save-model` basename must differ from the source `.scm` or you will clobber the generator.

## E.2 Doping

* One species per material. Substrate `nTinActiveConcentration`, drift `nSiliconActiveConcentration` is defensible *if* you state that the substrate is Sn-doped and the drift Si-doped — otherwise unify.
* Rings: `sdedr:define-constant-profile` + `define-constant-profile-region` **per ring region** (not `define-constant-profile-region` on a shared region, which misfiles species).
* For NiO, the acceptor identifier must exist in the installed `datexcodes.txt`, or the solve fails silently at equilibrium. Verify the startup "… (acceptor)" line in the log before trusting the run.

## E.3 Contacts

* Anode: Schottky, `WorkFunction = 5.10` on Ga₂O₃; on p-GaN/NiO the same contact must be **ohmic** (a Schottky contact to p-GaN blocks and you never reach 1 mA/cm²).
* `anode_fp` and `anode_pgan` must remain **disjoint** from `anode`; sharing mesh edges is a silent truncation (`ExcludeTouchingContactParts`).
* Cathode: backside ohmic on the full substrate face.

## E.4 Interfaces and traps

```
Physics(MaterialInterface="GaN/Ga2O3")      { Thermionic RecVel(TempDep) }
Physics(MaterialInterface="Ga2O3/AluminumOxide") { Traps((FixedCharge Conc=-2.67e11))
                                                   Recombination(SurfaceSRH) }
Physics(MaterialInterface="Ga2O3/Nitride")  { Traps((FixedCharge Conc=…)) }
```
`Physics(MaterialInterface=…)` is what creates the interface double points; a `.par` block alone does nothing.

## E.5 Models to add (and keep)

Keep: `Mobility(DopingDependence HighFieldSaturation(GradQuasiFermi))`, `Recombination(SRH Auger Avalanche(vanOverstraeten GradQuasiFermi))`, `eBarrierTunneling "NLM_Anode"`, `IncompleteIonization`, `Thermionic`.

Add, in this order of importance:
1. `Math { Aniso(Poisson) }` + tensor ε (12.4 / 10.87 / 10.2). **This changes the RESURF optimum — re-optimise the ring dose after enabling it.**
2. `PooleFrenkel` and a VRH/hopping term in the p-GaN (and NiO). Without it the low-barrier variants are artificially clean and the whole barrier-height optimisation is unphysical at 0.1 mA/cm².
3. Trap-assisted tunnelling at the Schottky contact if you want the low-barrier leakage to be credible.
4. A dielectric-field monitor: `Plot` the oxide regions and post-process `|E|` (there is no built-in TDDB model; the ceiling is an external check).

## E.6 Meshing

* Refinement windows on: anode corner (5–10 nm), each ring edge (10–20 nm), FP toe (20 nm), trench/fin bottom corners (5–10 nm), heterointerface (1–2 nm normal).
* Keep the global mesh coarse over the substrate; it only sets series resistance.
* **Gate:** re-mesh at 2× corner density and require <5 % change in `V_BR,op`. Report the bare-device corner ladder separately — it is a physical-radius sweep, not a convergence proof.

## E.7 Solver

```
BreakCriteria { Current(Contact="cathode" AbsVal=8.659e-8) }   # operational point
BreakCriteria { Current(Contact="cathode" AbsVal=1.0e-3) }     # compliance guard
Quasistationary( MaxStep=0.05 → 0.02 above 0.8·V_expected, Increment=1.6, Decrement=2.0 )
Math { NotDamped=30 Iterations=15 RelErrControl Digits=5 ErrRef(Electron)=1e-4 … }
```
Staged ramp is mandatory: a single quasistationary run to −2.6 kV at 0.03 V steps is ~40 000 steps and will not finish. Ramp to −1.5 kV coarse, then refine.

## E.8 Post-processing

Parse `.plt` by **header name** (`cathode TotalCurrent`, `anode OuterVoltage`), sort by |V|, log-interpolate the 8.659×10⁻⁸ A crossing, and require **five consecutive samples above** the criterion (this rejects the one-sample excursions that produced the "71.6 V" and "1458 V" artefacts). Report the bracket, not just the interpolated value.

---

# Part F — Recalibration after the structural change

| Order | Quantity | Method | Gate |
|---|---|---|---|
| 1 | Substrate/drift parity | run `bare` with unified Sn doping and unchanged mesh | reproduces the archived bare crossing within a few V; otherwise the change is understood and documented |
| 2 | Anisotropic ε | `Aniso(Poisson)` on the **bare** device first | shift quantified before touching terminated devices |
| 3 | NLM prefactor `g_e` | fit to bare reverse leakage in the pre-breakdown decade | one decade of leakage matched with the same `mt` |
| 4 | JTE/ring dose | RESURF sweep of sheet charge 0.6–1.1× | design point ≥2 sweep steps from a cliff; peak field at the ring edges, not at the anode |
| 5 | Dielectric stack | thickness/field sweep | ≤3.5 MV/cm at `V_BR,op` **and** at `V_stop` |
| 6 | p-GaN / NiO leakage | PF + VRH with φ_t 0.74 eV; fit T0 | leakage at 0.8·V_BR matches the published order of magnitude |
| 7 | Mobility / R_on | 200–300 A/cm² slope | reproduces 4.8 mΩ·cm² (Yang) / 6.15 (Chang JTE) / 6.79 (Chang JBS) within the stated substrate assumptions |
| 8 | Avalanche coefficients | per-material, crystal-axis-consistent | region-resolved avalanche fraction reported, not a single number |

Recalibrating in any other order will produce numbers that look plausible and are not comparable.

---

# Part G — Fair-comparison methodology

**Hold fixed across every architecture:** substrate and drift specification; active anode area (define `A_active` once, from the Schottky area, and normalise everything to it); temperature; physics model list (including PF/VRH and anisotropy); mesh family and corner-density policy; extraction code and criterion; solver tolerances.

**Report, per device:**
1. `V_BR,op` at 1 mA/cm² as a **median + range** over the process window, with the bracket.
2. `V_BR,aval` only if the ionization integral reaches 1 **and** an avalanche-disabled control blocks — otherwise it is a current-threshold number.
3. `V_on` at 1 A/cm² and at 100 A/cm²; `R_on,sp` from 200–300 A/cm².
4. Leakage at 0.8·`V_BR,op`.
5. Peak |E| in Ga₂O₃, in p-GaN/NiO, and in each dielectric, separately.
6. Avalanche fraction by region (p-GaN vs Ga₂O₃) — if >50 % is in the p-type layer, the device is not a Ga₂O₃ breakdown result.
7. Process-window width: the ±sheet-charge interval that keeps `V_BR,op` within 10 %.

**Forbidden:** comparing a realizable device against an unrealizable champion; quoting the 2336 V abstraction next to a physical device as if both were predictions; comparing across mesh families; mixing `V_stop` with `V_BR,op`.

---

# Part H — Variability plan

| Parameter | Range to sweep | Type | Why it matters |
|---|---|---|---|
| JTE/ring sheet charge | 0.6 / 0.75 / 0.9 / 1.0 / 1.1× | 5-point line | sets the RESURF window; the dominant sensitivity in your own data |
| p-GaN thickness | 135 / 150 / 165 nm | 3-point | dose = N_A·t |
| Ring CD / gap | ±0.25 µm | corner | lithography + etch bias |
| Alignment offset (anode→JTE) | 0 / ±0.25 / ±0.5 µm | corner | the 0.25 µm gap failure mode |
| Etch depth (fin/trench) | ±10 % | corner | field at the bottom corner |
| Corner radius | 50 / 100 / 200 nm | 3-point | decides the peak field |
| Dielectric thickness | ±5 % (Al₂O₃), ±10 % (SiN) | corner | field margin |
| Interface fixed charge | 1.3 / 2.67 / 4.0 ×10¹¹ cm⁻² | 3-point | shifts RESURF balance |
| `D_it` | 1 / 2 ×10¹² cm⁻²eV⁻¹ | 2-point | low-barrier leakage and `V_on` |
| Drift doping / thickness | ±7 % / ±5 % | corner | `V_BR` scale |
| Temperature | 298 / 350 / 400 K | 3-point | the only place the mesa/p-GaN advantage actually appears |
| NiO acceptor / thickness | 0.5× / 1× / 2× | 3-point | Device C only |

**Method:** one-at-a-time for the four parameters that gate the design (sheet charge, corner radius, dielectric thickness, interface charge); a Latin-hypercube or corner set (~24–32 runs per architecture) for the rest. Report the *distribution*, not a single point — the paper's weakness is that every number is one draw from an unstated distribution.

---

# Part I — Execution roadmap

| Phase | Work | Gate before proceeding | Rough cost |
|---|---|---|---|
| **P0** | Freeze reference: hash the 3 verified reverse curves (planar, mesa, thin-80nm) and the bare control; unify species; archive as-run inputs | hashes recorded; nothing overwritten | hours |
| **P1** | Bare parity on the frozen mesh, +Sn-doping variant, +anisotropy on/off | bare crossing reproduced within a few V or the shift explained | 2 runs, ~0.5 h each `[SIMULATED 163 pts / 1027 s]` |
| **P2** | Rebuild geometry library: discrete-ring planar, ring JBS, NiO fin JBS, solid FP, hybrid dielectric | SDE builds; mesh/contact validation plots; no shared edges; solid metal present in `.tdr` | 4 generators, days |
| **P3** | Physics upgrade: anisotropy + PF/VRH + traps; dielectric field monitor | converges at −100 V and at −500 V; field margins printed | 3–4 pilots |
| **P4** | Device A (planar + SM-JTE + solid FP): dose sweep, FP-length sweep | `V_BR,op` with ≥2-step margin from cliff; dielectric ≤3.5 MV/cm | ~8–12 runs; terminated devices run ~7× slower than bare `[SIMULATED]`, so budget hours each |
| **P5** | Device B (ring JBS): pitch, spacer, trap sensitivity | leakage at 0.8·V_BR physical; `V_on` trade-off reproduced | ~8 runs |
| **P6** | Device C (NiO fin JBS): fin width/depth, NiO dose | builds and converges; leakage <10⁻² A/cm² order | ~8 runs, new material setup |
| **P7** | Variability DOE per architecture | distributions, not points | ~24–32 runs total |
| **P8** | Comparison table + figures under one criterion | every row traceable to a hash; no unrealizable number in the table | days |
| **P9** | Manuscript rewrite of the affected sections; limitations; as-run provenance appendix | reviewer can rebuild any row | days |

**Sequencing rule:** nothing in P4–P6 starts until P1–P3 gates pass. The most expensive mistake available here is optimising rings against a physics set that is about to change (anisotropy alone moves the RESURF optimum).

---

# Part J — What I could not verify, and the honest risks

1. **The two p-GaN hardware papers (3.0 kV JTE-SBD; 4.335 kV HJBS with 2.5/1.5 µm rings, 0.5 µm sputtered polycrystalline film, PF φ_t 0.74 eV) were not re-verified this session** — the publisher blocked extraction. They are load-bearing for Device B's dimensions. Verify the 2.5/1.5 µm pitch and the 0.5 µm thickness directly before freezing D.2.
2. **Mg activation in β-Ga₂O₃** — I verified an N-implant termination annealed at 1100 °C/30 min (Zhou 2024), but that is a damage-isolation layer, not dopant activation. Any claim that a p-type *implant* option exists is unsupported; the ring dose in Device A is a **sheet-charge surrogate** until proven otherwise.
3. **Dielectric 3.5 MV/cm** is a ten-year TDDB number for a specific MOCVD Al₂O₃ process (Roy). ALD Al₂O₃ on your surface may differ; treat 3.5 MV/cm as a target, not a guarantee, and state the source process.
4. **Alignment tolerance** ±0.25 µm is an i-line stepper figure; a contact aligner is ±0.5–1 µm. Decide which line this device is for, because it decides whether the 1.5 µm gap is comfortable or marginal.
5. **Whether the trench family is worth keeping** is a scientific judgement, not a fabrication fact. The precedent is NiO, and it is a different device.
6. **Every number in Part A is from my own inspection of the decks.** Every number in Part B marked `[PRIOR-AUDIT]` is not, and should be spot-checked before it enters the manuscript.

---

## Appendix — Sources I read directly this session

| ID | Citation | Numbers used |
|---|---|---|
| S1 | Zhou et al., *Nanomaterials* **14** (2024) 978, doi:10.3390/nano14110978 | FP 15 µm + N-IET (3 implants 50/150/230 keV, 5×10¹²–2×10¹³ cm⁻², 500 nm box, ~2–3×10¹⁹, 1100 °C/30 min N₂); V_br 1616 V; R_on,sp 5.11 mΩ·cm²; J_R 1.2×10⁻⁵ A/cm² @ −1000 V; Ti/Au 30/100 nm + RTA 470 °C/60 s |
| S2 | Okumura & Tanaka, *Jpn. J. Appl. Phys.* **58** (2019) 120902 | ICP-RIE BCl₃/Cl₂, 77 nm/min (97 nm/min @ 400 W), Ni hard mask, smooth sidewall; hot H₃PO₄ → R_on 0.91 mΩ·cm², n = 1.03 |
| S3 | Roy et al., arXiv:2408.11342 | Al₂O₃ E_BD ≈ 10 MV/cm; **10-year TDDB at 3.5 MV/cm**; bilayer E_BD 7.8 MV/cm |
| S4 | Hollar et al., arXiv:2610.04388 | (011) SBD + TiO₂/Al₂O₃ FP: 3.90–4.16 kV vs 3.06–3.16 kV; 100–300 µm; 25–150 °C |
| S5 | Gilankar et al., arXiv:2409.00344 | NiO/Ga₂O₃ HJD + **2-step SM-JTE rings**: >3 kV, V_on 0.8 V @1 A/cm², R_on,sp 4.4 mΩ·cm², FOM >2 GW/cm² |
| S6 | Gilankar et al., arXiv:2512.04033 | **p-NiO/Ga₂O₃ trench JBS + SM-JTE**: >1.8 kV, <10⁻² A/cm², V_on ~1 V, R_on,sp 4–10.5 mΩ·cm², **fins 0.6–1.25 µm** |
| S7 | Liu et al., arXiv:2503.17895 | ALD NiO/Ga₂O₃ HJD: 2.2 kV on 7.7 µm drift, parallel-plane field 7.5 MV/cm on (100); E_C 2.30–2.76 (001) vs 4.33–7.50 (100) |

Unverified-but-load-bearing (verify before freezing Device B): Chang et al., *Appl. Phys. Lett.* **126** (2025) 062102; Chang et al., *IEEE TED* **73** (2026) 3456 — sputtered p-GaN JTE-SBD 3.0 kV; HJBS 4.335 kV, 2.5/1.5 µm rings, 0.5 µm polycrystalline film, PF/VRH leakage.
