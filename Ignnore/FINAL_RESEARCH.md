# Final research — β-Ga₂O₃ / p-GaN power diode study

Status: analysis complete, model audited, evidence mapped. Nothing is running.
Owner: user. Prepared from the archive, not from new simulations.

## 1. What the study is

A cylindrical (axisymmetric) β-Ga₂O₃ vertical Schottky diode, 105 µm domain / 52.5 µm
anode, 10 µm drift at 2×10¹⁶ cm⁻³ Si, 650 µm substrate at 3.6×10¹⁸ cm⁻³ Sn, calibrated
against Yang et al., APL 110, 192101 (2017). Against that baseline, four terminations are
compared: bare, planar p-GaN JTE, mesa JBS, trench JBS — each with and without a field
plate — plus sweeps on p-GaN doping, p-GaN thickness, Schottky barrier height, and
temperature.

## 2. The model as it actually ran

Confirmed from solver logs (`.log_des.log`), not from parameter files:

| Item | Value in the paper runs |
|---|---|
| Schottky tunnelling | named NLM, 15 nm, +y, g_e = 1.56×10⁻⁸ global (52/52 logs) |
| GaN-local override | g_e = 1×10⁻¹³ inside GaN only |
| Impact ionisation | vanOverstraeten, β-Ga₂O₃: a = 7.90e5, b = 2.92e7 (e); GaN: a = 2.9e8, b = 3.4e7 (e), a = 5.41e6, b = 1.96e7 (h) |
| Interface | GaN/Ga₂O₃ thermionic + RecVel(TempDep) |
| Fixed charge | −2.67×10¹¹ cm⁻² on Ga₂O₃/Al₂O₃ |
| Incomplete ionisation | Si, Sn (Ga₂O₃); Mg, E_A = 0.20 eV (GaN) |
| Polarisation | off (justified if the p-GaN is sputtered/polycrystalline) |
| Optics | constant generation 1×10¹³ cm⁻³s⁻¹ — a numerical seed, not physics |
| Band gap narrowing | Bennett/Wilson — Si-oriented, negligible at 2×10¹⁶ |
| Avalanche control | 9_BV_Convergence shows the bare knee is avalanche, not numerical |

## 3. Numbers that can be quoted

Reverse current threshold at 1 mA/cm² (8.659×10⁻⁸ A), 298.15 K:

| Termination | V at 1 mA/cm² | Gain over bare |
|---|---:|---:|
| Bare (0.5 µm rim split) | 929 V | 1.0× |
| Planar p-GaN JTE + FP | 2336 V | 2.51× |
| Mesa JBS + JTE + FP | 2336 V | 2.51× |
| Trench JBS + JTE + FP | 1133 V | 1.22× |
| Champion (80 nm p-GaN, 0.75 eV) | 2347 V | 2.53× |

All are **simulated current thresholds with impact ionisation active in both
semiconductors**, not measured breakdown and not an intrinsic β-Ga₂O₃ avalanche voltage.

## 4. Before submission

1. **GaN hole mobility — no change needed (checked, then retracted).** The deck runs
   `Mobility(DopingDependence HighFieldSaturation(GradQuasiFermi))`, so `mumax = 150` in
   `ConstantMobility` is only the undoped ceiling. The active Masetti model
   (`formula = 1`, GaN hole column: mumin1 1.0, Pc 5.0e18, Cr 9.5e16, alpha 0.9, mu1 0)
   gives 4.49 cm²/Vs at Mg = 5e18, 16.1 at 1e18, 73.3 at 1e17. The model is therefore
   conservative against the 10–20 cm²/Vs literature band. Changing `mumax` to 15 would
   have given 0.78 cm²/Vs and made R_on,sp ~6× worse.
2. **State that GaN impact ionisation is active and sourced** (Kunihiro 1999 electrons;
   Cao 2018 / Ji 2019 / Maeda 2019 held as documented alternates in the same block).
   Hole ionisation exceeds electron ionisation in GaN at 1–3 MV/cm — the model already
   reflects that.
3. **Disclose the constant optical generation** as a numerical seed, or set it to zero for
   the final production runs.
4. **Disclose the absent polarisation** and its justification (polycrystalline sputtered
   p-GaN).
5. **GaN tunnelling parameters are unused, not wrong.** The only non-local path is on the
   Schottky anode, 15 nm into β-Ga₂O₃; the p-GaN contact is ohmic and has no barrier.

## 5. Evidence map

- 55 reverse cases are log-verified at g = 1.56×10⁻⁸: 46 in
  `Clean_Paper_g156e8_SnSub` + `NLM_g156e8_Full_Batch_20261122`, and 9 bare cases that
  carry only the global echo because the device contains no GaN.
- 124 other folders under `15_LeanMesh_Calibration` ran at g = 1×10⁻¹³ and cannot appear
  beside these numbers (all of `09_`–`12_`, `16_`–`22_`, `MESH_BRACKET`,
  `Sn_Substrate_Parity_Batch`, `Process_Constrained_Followup`).
- **Gap:** `Clean_Paper_g156e8_SnSub/Study1_Architectures/01_Planar_JTE_FP` and
  `03_Mesa_JBS_JTE_FP` contain `rev.plt` and `rev_final_des.tdr` but **no reverse solver
  log**. The proof that these two headline devices ran at 1.56×10⁻⁸ exists only in the
  `NLM_g156e8_Full_Batch_20261122` copies. Copy those logs in or cite them.
- Sn substrate doping is verified in all 26 device meshes (`nTinActiveConcentration`),
  not by a solver-log line.

## 6. Claims allowed / not allowed

Allowed: comparative termination performance under one documented model set; the bare
device reproduces the Yang calibration; impact ionisation off raises the knee beyond
3 kV, so the ~929 V bare knee is avalanche-controlled; the p-GaN termination shifts the
peak field away from the Schottky corner.

Not allowed: "measured breakdown"; "intrinsic avalanche field of β-Ga₂O₃"; any number
from a 10⁻¹³ folder; the flat-anode 368 V artifact; field-plate projections that were
never simulated.

## 7. If the runs are repeated

Only three things change: GaN μ_p → 15, optional optics → 0, optional avalanche bracket.
Reverse numbers will reproduce within solver scatter (±2 V at 929 V). Use
`03_final_runs/common/des_final.par` (GaN μ_p 15, everything else identical, two lines
differ by SHA check) and confirm with
`log_params_extract.py <log> --grep 'ConstMob|IALMob' --show-old`.
