# p-GaN thickness and doping study (reviewer point 2)

Source: `15_LeanMesh_Calibration/Clean_Paper_g156e8_SnSub/Study2_Thickness_Doping`
Model: Sentaurus V-2024.03, cylindrical, 298.15 K, g_e = 1.56e-8 global
(GaN-local g_e = 1e-13), Sn substrate, `des_g156e8_sn.par`.
Copy method: hardlink + SHA-256 verified on write (`VERIFY_SHA256.csv`, 148/148 PASS).

Each case folder contains: `rev.cmd`, `rev.plt`, `rev.log_des.log`, `rev.stdout`,
`rev_final_des.tdr` (final reverse state -> E-field cutline), `rev_V0000_des.tdr`
(equilibrium -> band diagram), the mesh `.tdr` + mesh `.cmd/.log`, and the SDE
generator `.scm` that built the mesh.

## Doping series (Mg multiplier of 5.0 / 2.8 / 1.6e18 written concentration)
Planar: 0.25x 0.50x 0.75x [1.00x nominal - not in this folder] 1.50x 2.00x
Mesa:   0.50x 2.00x        Trench: 0.50x 2.00x

## Thickness / dimension series
Planar JTE: 0.08um, 0.25um, 0.35um (nominal 0.15um is Study1/01_Planar_JTE_FP)
Mesa height: 0.25um, 1.00um      Trench depth: 1.50um

## Known gaps (see STATUS.csv)
- `2B_Planar_t0p08um`: rev.plt is truncated, no solver log, no `.tdr`.
  Needs one re-run with `Plot` enabled to give the 0.08um field / band point.
- Nominal 1.00x (0.15um) point: its equilibrium state was never written;
  a 0 V band diagram for that geometry exists only in the WF=5.50 sibling.
