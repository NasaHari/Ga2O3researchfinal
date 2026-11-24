# Review 06 — Independent Adversarial Audit

**Revision note (this version).** An earlier draft of this audit argued that the nominal designs do not avalanche, using the ionisation-integral columns that the previous reviews had not read. That argument is **withdrawn**: the integral cannot resolve the question in this structure (see §B.1). The author's objection — that the termination multiplication occurs in the GaN layer where the computed integral is mesh-limited, and that avalanche is better established by the positive temperature coefficient and the hole-focused current rise — is supported by the data and is adopted. §0, §A.1 and §F are revised accordingly; the withdrawn claim is recorded rather than deleted, because it is a trap that remains open to any reviewer of this manuscript.

**Manuscript.** *Geometry and p-GaN Design Sensitivity in β-Ga₂O₃ Rectifiers: An Axisymmetric TCAD Study*, `Paperwriting/Manuscript_v5_reverse.pdf`, 8 pp. I recomputed the SHA-256 myself: `54ed7649ca1ed2ea01df740e7955d3e6b122ab81b576ba44c190ff00e72720ef`, matching the hash asserted by Reviews 01–05. I read the complete `.tex` (265 lines) as well as the PDF, and re-extracted the numerical evidence from the raw `.plt`, `.cmd`, `.scm` and `.log` files.

**Previous reports audited.** `Review_01_Project_Evidence_Map.md`, `Review_02_TCAD_Technical_Audit.md`, `Review_04_Literature_Novelty_Audit.md`, `Review_05_IEEE_Peer_Review.md`. `Review_03_Numerical_Figure_Audit.md` **does not exist** anywhere under `Z:\synopsys_chipin_work\STDB\tmp` (`find . -maxdepth 3 -iname "Review_03*"` → no output). Every review that cites it is citing a document that was never written. This is the first of several places where the prior reports accept each other's existence at face value; I treat the review chain itself as evidence to be tested, not as authority.

**Independence statement.** I did not accept any prior number without recomputation where a raw file exists. Where a raw file does not exist, I say so rather than inheriting the prior reviewer's figure. Where I could not verify (external literature, TDR node-level fields, mesh-edge area integration), the item is marked **[UNVERIFIABLE — THIS PASS]** and is not used to support a conclusion.

**Evidence labels.** [SIMULATED] converged solver output read from `.plt`; [EXTRACTED] my post-processing of solver output; [DERIVED] arithmetic from stated inputs; [IMPLEMENTED] deck setting; **[UNVERIFIED HYPOTHESIS]** mechanism inferred but not proven; [UNVERIFIABLE — THIS PASS] no accessible evidence; [CONFIRMED ERROR] demonstrated contradiction with a primary file.

---

## 0. Headline findings

1. **The 298/350 K crossings behave like an impact-ionisation-limited knee, and the two model-independent tests support it.** [EXTRACTED] The planar crossing moves **+1.95 V/K** from 298 to 350 K (+0.084 %/K), the sign and magnitude avalanche predicts — every leakage measure in the archive rises steeply with temperature (J at −1000 V: 8.7×10⁻⁹ → 2.1×10⁻⁴ → 7.1×10⁻⁴ A/cm² at 298/350/400 K), so a leakage-limited threshold would move *down*. [EXTRACTED] The same crossing is **barrier-independent to 0.32 V** across 0.75 eV of input barrier (2335.59 / 2335.90 / 2335.90 / 2335.91 / 2335.91 V at 0.75–1.50 eV), which excludes a contact-limited knee. The 400 K crossing does move down (2336 → 1473 V) and is electron-dominated, exactly as the manuscript says.
2. **The ionisation-integral columns cannot arbitrate this, and are not used here as evidence in either direction.** [DERIVED] I = 1 across the 0.15 µm JTE needs 4.06 MV/cm (GaN electrons) or 4.46 MV/cm (GaN holes); the reported I = 0.090 implies only 2.9–3.2 MV/cm. Because α ∝ exp(−b/F), ±20 % field uncertainty moves I by ×6 / ÷15 and ±30 % by ×12 / ÷100 — and ±20–30 % is what a heterointerface field peak in a 150 nm layer sampled at ~20 nm is worth. The integral is one-sided: I ≥ 1 proves avalanche, I < 1 proves nothing. It is also cut short, because every sweep stops at the 1 mA compliance before the question is asked.
3. **A completed 80 nm / 1.10 eV run exists and contradicts the manuscript's stated reason for excluding it.** [EXTRACTED] 2347.13 V at 1 mA/cm², bracket [2346.89, 2347.25], 1013 points, closed data block, mesh SHA-256 `d73423df…` identical to the named-batch 80 nm mesh. Review 05's C1 is correct and I reproduce its number independently.
4. **Four of the eight rows of Table II have no raw trace in the archive.** The three no-FP architectures rest on `Paperwriting/curve_audit.csv` alone: `find . -iname "*NoFP*"` returns three `.scm` builders and no `.plt`, `.tdr` or solver log.
5. **Every reverse sweep is terminated by the deck's current compliance, not by breakdown.** [EXTRACTED] All eight nominal cases end at |I_cathode| ≈ 1.0×10⁻³ A, i.e. 11.5 A/cm² on the paper's reference area — three decades above the reported crossing. The paper never says so, and it is also why the ionisation integral is still climbing when the run stops.

## A. Previous-review reliability audit

Classification of every **major** criticism. Minor editorial items are audited in §A.3.

### A.1 Major criticisms

| # | Criticism (source) | My classification | Independent basis |
|---|---|---|---|
| 1 | No-FP raw forward/reverse data absent; 2221 V unreproducible from raw (R01 §4, §5; R02 T07) | **Valid** | `find . -iname "*NoFP*"` → only `04_mesh_generators/{planar,mesa,trench}/build_*_nofp_sn.scm`. No PLT/TDR/log. `curve_audit.csv` is the sole numerical source for 2221.090/2221.068/1133.352 V. |
| 2 | Fig. 1 data not located; no per-point decks/PLTs for the 972→527 V ladder (R01 §4, §6.2) | **Valid, and worse than stated** | No file in the tree contains 972 or 527 V (`grep -rn "972\|527" --include=*.md --include=*.csv --include=*.json` → unrelated hits only). `ACTIONS_LOG.md` line 28 records: *"Removed the unverified finer-mesh comparison from the active manuscript and Fig. 1"*; line 30 then records *"Restored original two-panel Fig. 1 and its caption only"*. The authors themselves once judged this panel unverified and reinstated it without new data. |
| 3 | Completed 80 nm / 1.10 eV run contradicts §IV-B (R05 C1) | **Valid — confirmed independently** | See §B.2. My crossing: 2347.128 V [2346.886, 2347.247]; R05 quoted 2347.158 V. The 0.03 V difference is an interpolation-convention artefact, not a disagreement. |
| 4 | GaN/β-Ga₂O₃ ionization-parameter provenance not established (R02 T01/T02, R04 §3) | **Valid** | Confirmed by reading the `.par` and the deck's `Plot`/`Math` blocks; the GaN pair is a bulk-GaN homojunction set and the β-Ga₂O₃ hole pair is an assumed suppression (`bh = 5.0×10⁷ V/cm`). Neither is a property of a sputtered p-GaN film. |
| 5 | 6 V separation at 400 K / 10 mA/cm² is below the numerical resolution (R02 T04) | **Valid** | Planar bracket [2540.109, 2555.596] V spans 15.5 V; mesa bracket [2550.813, 2551.233] spans 0.4 V. The claimed ordering is inside the planar bracket. |
| 6 | "Thermionic emission over the 1.10 eV barrier" is not established by a terminal current partition (R02 T05) | **Valid — and quantifiable** | See §B.5: at 400 K, sustaining 1 mA/cm² with a 1.10 eV barrier by thermionic emission alone requires φ_eff = 0.772 eV, i.e. 0.33 eV of barrier lowering, i.e. ~9 MV/cm of image-force field. The model's nonlocal tunneling path must be doing the work. |
| 7 | Exposed-area ratio is 56.27 %, not 54.2 % (R02 T06, R05 C3) | **Partially valid** | The manuscript's 54.2 % is internally consistent with its own stated areas (4.466/8.236 = 54.22 %). Whether those areas match the mesh requires the edge integration R02 describes; I did not re-run it **[UNVERIFIABLE — THIS PASS]**. The discrepancy is 2 percentage points and changes no Table II quantity. It should be corrected, not treated as a finding. |
| 8 | "Not substrate-matched" in the Table II footnote is unsupported (R02 T07) | **Valid — [CONFIRMED ERROR]** | `Bare/build_split.scm:24` → `(define N_sub 3.6e18)`; `04_mesh_generators/planar/build_planar_150nm_sn.scm:43` → `(define N_sub 3.6e18)`. The substrates are matched; the footnote is factually wrong. |
| 9 | Contribution is an integrated comparison, not a new topology (R04 §4, §6) | **Valid** | R04's prior-art survey is the strongest part of the review chain; its Nandi/Than/Roy/Chang overlap argument survives scrutiny. Its only structural weakness is that it takes the manuscript's numbers as given, so its novelty argument inherits whatever those numbers turn out to be; the verdict itself is unaffected. |
| 10 | Table III overflows the page (R05 D1) | **Valid — [CONFIRMED ERROR]** | `Manuscript_v5_reverse.log:542`: `Overfull \hbox (59.25717pt too wide) in paragraph at lines 228--239`. |
| 11 | §IV-E duplicates two paragraphs verbatim (R05 D2) | **Valid — [CONFIRMED ERROR]** | `.tex` lines 244–246 and 248–250 are byte-identical. |
| 12 | R02's avalanche diagnostic (steep sustained rise + hole-majority terminal current) | **Valid method — upheld** | I first rejected it in favour of the integral; that rejection is withdrawn (§B.1). Given the integral's resolution limit, R02's carrier + temperature route is the better available method and reached the right classification. |
| 13 | R02's "no Critical issue demonstrated" | **Valid** | Holds. The integral evidence I used to overturn it does not bear that weight. |
| 14 | R05's verdict "Major Revision" | **Valid** | My Reject is retracted; see §F. |
| 15 | R05's "do not commission new simulations" | **Valid, with one exception** | True for the comparison; one ionisation-disabled control would still close the mechanism question cleanly (§E.3). |

### A.2 Where the previous reviews are right for the wrong reason

- **R01 §3 "Both example families stop at an absolute cathode limit of 1e-3 A, very different from the manuscript benchmark."** Correct observation, under-exploited. The consequence — that no reported state is a breakdown state, because the decks stop at 11.5 A/cm² on the paper's own area — is never drawn, and the manuscript never discloses it.
- **R02 §3 "the plated nominal room-temperature comparisons use shared drift and JTE recipes"** is right, but the same paragraph then attributes the 2336 V equality of planar and mesa to "a plausible common limiter in the shared JTE" and calls that limiter avalanche. The shared-JTE observation is exactly what identifies the limiter as JTE behaviour rather than active-area behaviour; the review reached the right observation and the wrong mechanism.
- **R05 C2** correctly forbids over-reading the temperature slope, but then endorses the carrier table as evidence of a *knee*. Both halves cannot be right: if the bracket is unresolved, the knee classification is unresolved too.

### A.3 Minor items (spot-checked)

| Item | Verdict |
|---|---|
| R05 D3: "same active-anode area" is ambiguous | Valid — the `.tex` (line 74–77) defines A_ref correctly but the surrounding prose says "same active-anode area". |
| R05 D5: title/abstract hedge correctly | Valid — the abstract's final sentence is disciplined. |
| R04's claim that no citation is fictitious | Consistent with `references.bib`; I did not re-fetch the DOIs **[UNVERIFIABLE — THIS PASS]**. |
| R01's inventory counts (1,823 files / 339 dirs), PLT and TDR ledgers | Not re-enumerated; no contradiction found in the paths I opened. |

---

## B. Missed critical issues

### B.1 The ionisation integral: recorded, bounded, and not decisive

The terminated reverse decks request `eIonIntegral hIonIntegral MeanIonIntegral` and enable `Math { ComputeIonizationIntegrals() }` (`NLM_g156e8_Full_Batch_20261122/03_Planar_WF5p10/rev_03_Planar_WF5p10.cmd`, lines 36 and 39). The two integrals are written into the `.plt` under the dataset names `PhiElectron` / `PhiHole`, mapped by each file's own `functions` list to `IonizationIntegral IonizationIntegral`. No previous review opened these columns. The values are:

| Case | 1 mA/cm² crossing | max I_e over all samples | max I_h | where the maximum occurs |
|---|---:|---:|---:|---|
| Planar + FP, 150 nm | 2336.3 V | 0.090 | 0.0043 | final sample (−2422 V) |
| Mesa JBS + JTE + FP | 2336.5 V | 0.100 | 0.0055 | final sample (−2423 V) |
| Trench JBS + JTE + FP | 1133.4 V | 0.192 | 0.100 | mid-sweep (−964 V) |
| Thin planar 80 nm, 1.10 eV | 2347.1 V | 0.091 | 0.0050 | final sample |
| Planar, 1.5× Mg | 679.6 V | 1.214 | 1.498 | −627 V |
| Planar, 2.0× Mg | 490.8 V | 1.302 | 2.145 | −652 V |
| Mesa, 2.0× Mg | 490.8 V | 1.300 | 2.144 | −646 V |
| Planar, 250 nm | 629.1 V | 0.881 | 0.809 | −617 V |
| Planar, 350 nm | 523.8 V | 1.024 | 1.051 | −577 V |

Two things this table does establish. (i) The integral machinery works in this geometry: in the heavily doped and thick-JTE cases it passes smoothly through unity at the observed current onset — `2A_Planar_Mg_2p00x` gives I_e = 0.013 (171 V), 0.102 (243 V), 0.341 (313 V), 0.643 (382 V), **1.118 (448 V)**, after which J runs 3.4×10⁻⁹ → 2.3×10⁻⁷ → 1.4×10⁻³ A/cm². Those cases are avalanche and the authors' reading of them is confirmed. (ii) For the nominal designs the integral is far below unity everywhere in the simulated range.

It establishes nothing about whether the nominal designs avalanche, for three reasons.

1. **The field margin is smaller than the field uncertainty.** [DERIVED] I = 1 over a 0.15 µm path needs α = 6.67×10⁴ cm⁻¹, i.e. **4.06 MV/cm** with the GaN electron pair (2.90×10⁸, 3.40×10⁷) or **4.46 MV/cm** with the GaN hole pair. The reported I = 0.090 corresponds to α = 6.0×10³ cm⁻¹, i.e. **3.15 / 2.88 MV/cm**. The entire question lives inside a ×1.3–1.4 field range.
2. **The integral is exponential in that field.** At F = 3.15 MV/cm: +10 % → ×2.7, +20 % → ×6.0, +30 % → ×12.1; −20 % → ÷15, −30 % → ÷100. A ±20–30 % uncertainty on a peak field sitting on a heterointerface double node in a 150 nm layer is not pessimistic; it is the expected accuracy. On that basis the reported 0.090 is compatible with a true integral anywhere from ~0.01 to ~1.5.
3. **The sweep stops first.** Every deck terminates at a 1 mA total-current compliance (11.5 A/cm² on A_ref), and the integral is still climbing at the last sample (dI_e/dV = 1.4×10⁻⁴ V⁻¹ between −2380 and −2422 V). The absence of I ≥ 1 here is an artefact of the stop criterion, not evidence of absence.

**The rule this leaves.** In this structure the integral is a one-sided indicator: I ≥ 1 is sufficient to call avalanche; I < 1 is not sufficient to exclude it. Any argument built on the nominal cases' 0.090 — in either direction — over-reads the file.

**What decides it instead is the non-numerical evidence, and it favours the authors.** The planar crossing is barrier-independent to 0.32 V across 0.75 eV, which excludes a contact-limited mechanism; it rises +1.95 V/K with temperature, whereas a leakage-limited threshold must fall (and does fall at 400 K, where the same device drops to 1473 V with a 99.94 % electron fraction). Two independent tests, opposite signs, each consistent with the manuscript's own classification. The paper's physics reading stands. What it must stop doing is implying that the integral corroborates it, and it should state the mesh limit of any integral-based statement it makes.

### B.2 The 80 nm exclusion — the stated reason is false, and the excluded point changes the design story

`§IV-B` (`.tex` line 175): *"The 0.08-µm sweep at that barrier did not establish a crossing and is not included in Fig. 6(b)."*

The two runs in `pGaN_thickness_doping/2B_Planar_t0p08um{,_RERUN}/rev.plt` are indeed truncated (both parse as `UNCLOSED`, zero complete records). But a *third*, complete run exists: `NLM_g156e8_Full_Batch_20261122/10_Thin080nm_WF5p10/`. [EXTRACTED] 1013 points, closed `Data` block, terminal point −2376.1 V at 1.017×10⁻³ A (compliance), crossing **2347.13 V** at 1 mA/cm² and 2346.54 V at 0.1 mA/cm². Its mesh is `sha256 d73423dff8e3212c…`, byte-identical to `NLM_g156e8_Full_Batch_20261122/meshes/planar_080nm_sn_msh.tdr`, i.e. the intended 80 nm mesh, not a stray copy.

`Paperwriting/ACTIONS_LOG.md` line 8 records the omission as an editorial act: *"The 80 nm thickness-only run is omitted from Fig. 5; the separate 80 nm low-barrier result is retained."* The manuscript's text, however, gives a physical reason ("did not establish a crossing") that the archive contradicts. A documented editorial choice presented as a physical finding is the most serious kind of selectivity, and Review 05 was right to make it a blocker.

**Why it matters beyond honesty.** With the point restored, the thickness sequence is not monotonic:

| JTE thickness | 1 mA/cm² crossing | Ionization integral | Mechanism |
|---|---:|---:|---|
| 80 nm | 2347 V | 0.09 | reach-through |
| 150 nm | 2336 V | 0.09 | reach-through |
| 250 nm | 629 V | 0.88 | avalanche |
| 350 nm | 524 V | 1.02 | avalanche |

The correct description is a **cliff between 150 and 250 nm where the limiting mechanism changes**, not a smooth "sensitivity to thickness". The same cliff appears in the dose sweep (≤1.0× reach-through, ≥1.5× avalanche). That is a better, more publishable, and more physical result than the one currently claimed — and it is invisible as long as the 80 nm point is hidden and the integrals are unread.

### B.3 The paper's own field monitor disagrees with its field figures

My own extraction, for reference only (**not** used in any argument below):

| Case | final |V| | `.plt` `MaxField` | mean |E| implied by V/10 µm |
|---|---:|---:|---:|
| Planar 298 K | 2422 V | 1.053 MV/cm | 2.34 MV/cm |
| Mesa 298 K | 2423 V | 1.235 MV/cm | 2.34 MV/cm |
| Trench 298 K | 1258 V | 0.624 MV/cm | 1.26 MV/cm |
| Planar 400 K | 2647 V | 1.127 MV/cm | 2.65 MV/cm |

A maximum field below the volume-averaged field is impossible. Therefore the `.plt` `MaxField` column is not the device's maximum electrostatic field (most plausibly it is the maximum quasi-Fermi-gradient driving force, which is what the `GradQuasiFermi` avalanche model consumes). Two of the project's own field numbers are therefore in circulation: ~1.0–1.2 MV/cm in the `.plt` monitor and 9.7–10.3 MV/cm from the TDR node extraction used by Review 02.

This is an **unresolved internal inconsistency**, not a proven error, but it has a direct consequence for the manuscript: Fig. 5 and Fig. 7 place the semiconductor on 0–8 and 0–6 MV/cm linear scales without stating which monitor produced the plotted quantity, and Fig. 8(c,d) interprets vertical field cuts whose magnitude cannot be reconciled with the applied voltage and drift thickness unless those fields are the quasi-Fermi gradient. **A reader cannot reproduce or check the field magnitudes.** That is a reproducibility failure in its own right, independent of which value is right.

### B.4 Four table rows with no traceable evidence

Table II contains eight rows. Three of them (planar/mesa/trench "no FP") plus the four derived merit numbers for those rows exist only in `curve_audit.csv`. The paper's text repeats the claim twice (`.tex` lines 130 and 142: "2221 V without one"). Under the project's own reproducibility standard — every number traceable to a raw solver file — these four rows are unsupported. Either the runs exist and must be archived, or the rows must go. Review 05 did not place this on its essential list; it should be there.

### B.5 The 400 K mechanism sentence is quantitatively wrong

`.tex` line 215: *"the reverse current at this temperature is dominated by thermionic emission over the 1.10-eV barrier, which passes 1 mA/cm² before the multiplication-limited value is reached."*

[DERIVED] With A* = 120·(m*/m₀) = 33.6 A cm⁻² K⁻² (m* = 0.28) at 400 K, A*T² = 5.38×10⁶ A cm⁻². To reach 1×10⁻³ A/cm² requires

  φ_eff = kT·ln(A*T²/J) = 0.03447 × ln(5.38×10⁶/1×10⁻³) = **0.772 eV**,

i.e. 0.328 eV of barrier lowering below the implemented 1.10 eV. Image-force lowering of 0.328 eV requires

  E = Δφ²·4πε₀ε_r/q = **9.2 MV/cm**.

That is above any field the model itself reports anywhere in the semiconductor. Thermionic emission alone therefore cannot deliver the stated current by roughly two orders of magnitude; the nonlocal tunneling path (`eBarrierTunneling`, g = 1.56×10⁻⁸) must dominate. The defensible wording is "field-assisted electron leakage at the Schottky contact"; the physically decisive term is tunneling, and Review 02's T05 objection is correct in kind and stronger in magnitude than it stated.

**Supporting independent check.** From the 298/350/400 K planar traces at fixed bias, the apparent activation energy of the leakage is not a single value: 0.87 eV (298→350 K), 1.19 eV (298→400 K) and 1.63 eV (350→400 K) at −500 V; 0.28/0.71/1.31 eV at −2300 V. A single thermionic process would return one barrier. The 1.3–1.6 eV values *exceed the 1.10 eV input barrier*, which no pure thermionic model can produce. A mixed tunneling/thermionic channel can. This is a second, independent reason to reject the "dominated by thermionic emission" sentence.

### B.6 The trench field-plate null result is a placement artefact

The plate runs from r = 55.0 to 67.0 µm. Review 02's own endpoint localisation puts the trench's impact-generation maximum at the outer active ring near r ≈ 48.4 µm and the stored hole-current peak nearby. The plate does not cover the region that limits the device, which is exactly why the plated and unplated trench crossings differ by 0.08 V (1133.43 vs 1133.35). The manuscript reports this as a design finding ("changes by less than 1 V between the plated and unplated variants") and hedges that it is not an isolated test of recessing. It is still not a statement about field plates on trench JBS: it is a statement about a plate placed 7 µm outboard of the hot spot. Either move the plate, or say plainly that it does not overlap the active-area field peak.

### B.7 The reference voltage rests on an unstated corner treatment

The paper's bare reference is 929 V, taken from a split-anode trace. Its own Fig. 1(a) study says the bare crossing moves from 972 to 527 V between 16 and 2 nm nominal corner spacing — a factor of 1.84. Nothing in the archive says which corner treatment the 929 V trace used, and no data backs either ladder endpoint. The stated gain is then 2336/929 = 2.51×, but the same ratio computed against the paper's own extremes is 2.40× (972 V) to 4.43× (527 V).

Two consequences. (i) "929 V" is a selected point inside a 1.8× numerical range, and its agreement with Yang's 975 ± 40 V is partly a consequence of that selection. (ii) Because the bare device breaks at 929 V and the terminated ones at 2336 V, and because the 10 µm/2.0×10¹⁶ drift is fully depleted at

  V_pt = qN_D d²/(2ε) = 1.602×10⁻¹⁹ × 2.0×10¹⁶ × (10⁻³)² / (2 × 1.098×10⁻¹²) = **1459 V**,

the bare comparison is between a **corner-limited, non-punch-through** breakdown and a **post-punch-through** termination limit (2336 V = 1.60 × V_pt). Those are different regimes; the ratio is not a termination efficiency, and the paper's Table II footnote should say so.

### B.8 The nominal JTE is grossly under-charged at equilibrium

[DERIVED] A single-zone JTE optimum at E_c ≈ 8 MV/cm is

  Q_opt = εE_c/q = 1.098×10⁻¹² × 8×10⁶ / 1.602×10⁻¹⁹ ≈ **5.5×10¹³ cm⁻²**.

The inner collar's written sheet is 7.5×10¹³ cm⁻², but at the implemented 4.0 % equilibrium ionisation that is **3.0×10¹² cm⁻² active** — about 5 % of the single-zone optimum, and 13 % if all three zones are summed (6.9×10¹²). The termination therefore behaves as a *heavily under-dosed* JTE until it depletes, and the active charge rises as it depletes (the manuscript's own point that the ionised fraction "rises towards unity where the layer is depleted"). A layer whose charge grows as it is depleted cannot deplete smoothly: it reaches a critical state and then collapses.

**[UNVERIFIED HYPOTHESIS]** Read as an explanation of *abruptness* rather than of the current source, this is the most economical account of what the archive shows: a layer whose charge grows as it depletes reaches a critical state and then collapses, which would produce a near-vertical rise on the multiplication branch and would explain why the 0.25–1.0× dose results are non-monotonic (1837, 2024, 1906, 2336 V) while the over-charged cases collapse cleanly at 491–680 V. It does not compete with impact ionisation as the origin of the current; it competes with it as the explanation for why the rise is so sharp and why the field margin sits where it does.

The hypothesis is testable without new physics: sweep the fixed interface charge and the Mg ionisation energy and see whether the 2336 V crossing moves with the JTE charge state. I hold it as a hypothesis, not a correction.

### B.9 The assumed interface charge is a first-order input that was never swept

The −2.67×10¹¹ cm⁻² sheet charge is stated as a model input but not labelled as assumed, not sourced, and never varied. If §B.8 is right, the reach-through voltage is a direct function of the net JTE charge, and the interface charge is part of that budget. A design-sensitivity paper whose headline number depends on an unsourced fixed charge must either source it, bound it, or show that the ranking is insensitive to it. None of these is done.

---

## C. Incorrect criticisms (do not follow these)

1. **"The nominal designs do not avalanche; the integral is 0.090" — my own first draft. Withdrawn.** It over-reads a mesh-limited exponential diagnostic (§B.1). Do not reinstate it in any revision of this review.
2. **"A hole-majority knee is the wrong diagnostic" (my first draft, against R02).** Withdrawn. Given the integral's resolution limit, R02's carrier + temperature route is the better available method and reached the right classification.
3. **"Reject" and "Major Revision understates the problem" (my first draft, against R05).** Both withdrawn; Major Revision is correct (§F).
4. **"Do not commission new simulations" (R05 §H).** Correct for the comparative result; one ionisation-disabled control would still close the mechanism question decisively and is the only run worth adding (§E.3). It is not a submission requirement.
5. **The framing of Fig. 8's evidence gap as a submission blocker (R01 §6.3).** The band diagram is decorative; its provenance gap is not worth a resubmission. Fig. 1 is the opposite: it carries a numerical claim with no data and should be treated as a blocker. The two gaps are not equivalent.
6. **Do not argue from Fig. 5's colour scales** while §B.3 stands. The caption's honesty about unequal saved biases does not fix a field magnitude that cannot be reconciled between the project's two monitors.

## D. Unresolved disagreements

### D.1 What is the resolved mechanism at 2336 V?

Two candidates matter, and the paper commits to neither explicitly.

| Hypothesis | For | Against | Discriminating test |
|---|---|---|---|
| **H1. Impact ionisation in the GaN JTE, under-resolved by the integral** | Positive dV/dT (+1.95 V/K) where leakage would fall; barrier-independence to 0.32 V over 0.75 eV; 99.94 % hole partition; the model's own `AvalancheGeneration` peaks in the middle GaN JTE (R02 §1) | Reported integral only 0.090 — with the resolution caveat of §B.1 | Disable impact ionisation; if the knee moves by hundreds of volts, H1 |
| **H2. Contact-limited injection (Schottky tunnelling, or JTE reach-through)** | Abrupt onset; a fully depleted, under-charged JTE (§B.8) is reach-through-prone; the mesa's 0.75 eV drop (2336 → 2061 V) shows one case *is* barrier-sensitive | Barrier-independence of the planar crossing is the opposite of what a contact-limited knee does; the 298 K knee is hole-dominated, which a Schottky electron path cannot supply | Ionisation-off run, or a JTE-charge sweep |
| **H3. Numerical snap** | The 350 K crossing jumps 5.3×10⁴ in one accepted step; `NotDamped=18`, `LineSearchDamping=0.5` | The 298 K rise is resolved over several samples and the integral is smooth | Halve MaxStep; an unchanged crossing excludes H3 |

**Ranking:** H1 for the 298/350 K crossings, H2 for the 400 K low-threshold crossings, H3 only for the 350 K point value. The author's reading is H1 and the two non-numerical tests support it; I hold H1 as leading but not proven, which is the same status the manuscript's own language should carry.

### D.2 The planar/mesa barrier asymmetry

The planar crossing is barrier-independent to 0.32 V; the mesa's falls 275 V at 0.75 eV. Same JTE, same barrier, different exposed area. If the JTE sets both, the mesa should also be independent. This is unexplained and is the strongest internal evidence that at least one of the two is contact-influenced. Worth one paragraph in the paper.

### D.3 The field magnitude

`.plt` `MaxField` (~1.0–1.2 MV/cm) versus TDR node extraction (9.7–10.3 MV/cm) versus the 2.34 MV/cm volume average. At most one can be the electrostatic maximum. I cannot resolve this without re-running the TDR reader, which needs the cluster toolchain **[UNVERIFIABLE — THIS PASS]**. Until it is resolved, no field magnitude in the paper should be quoted as physical, and the 0–8 MV/cm colour scale in Fig. 5 is uninterpretable.

### D.4 Did the 1.5× / 250 nm runs complete?

R02 T11 says their logs end mid-Newton. I add a counter-argument it did not have: in `2A_Planar_Mg_1p50x` the ionization integral rises smoothly 0.01 → 1.21 over 171–680 V and the terminal current then follows a coherent post-breakdown branch. A spurious final iterate would not produce a monotonic integral through unity. So the *crossings* are trustworthy even though the *process disposition* is unknown. R02's caution stands for the log, not for the number.

### D.5 Area ratio

54.22 % (stated areas) versus 56.27 % (mesh-edge integration per R02). I did not re-integrate. Low stakes: the ratio affects only the per-area leakage normalisation, not Table II.

### D.6 Is the 400 K 10 mA/cm² event avalanche?

Open. I_e = 0.053 at −2556 V, and the terminal current switches from 0.51 % to 99.49 % holes across the 2540–2556 V bracket. Under the rule of §B.1 that integral value cannot exclude avalanche, so this stays a question rather than a finding. What is settled is the 400 K *1 mA/cm²* crossing: electron-dominated at 99.94 % with I_e = 0.0066, which the manuscript already classifies as leakage and which falls with temperature, as a leakage threshold must. The paper's contrast at 400 K is therefore sound in kind — leakage first, then a hole-focused transition whose mechanism is unresolved — but it should not assert that the later transition is multiplication.

### D.7 The Ti/Al or Ni contact is unspecified for the low-barrier cases

The 0.75 eV barrier is implemented as WorkFunction 4.75 eV with no contact metal named. This is a modelling choice, not a device. It does not affect the comparative result but should not be presented as a designed anode.

---

## E. Final prioritized correction list

### E.1 Must fix — submission-blocking

| # | Correction | Why |
|---|---|---|
| M1 | Report the 80 nm / 1.10 eV result (2347.13 V, [2346.89, 2347.25], 1013 pts) and delete "The 0.08-µm sweep at that barrier did not establish a crossing". If an exclusion is kept, state the editorial ground recorded in `ACTIONS_LOG.md`. | A completed run exists; the stated reason is false. |
| M2 | Supply raw traces for the no-FP rows, or delete them from Table II and §IV-A. | Four of eight table rows have no primary evidence. |
| M3 | State that all reverse sweeps stop at the 1 mA total compliance (≈11.5 A/cm² on A_ref) and that no reported state is a breakdown state. | Otherwise "final saved bias" is uninterpretable, and it explains why any integral statement is cut short. |
| M4 | Correct the Table II footnote: the substrates are matched (`N_sub = 3.6e18` in both builders). | Direct factual error. |
| M5 | Replace "dominated by thermionic emission over the 1.10-eV barrier" with "field-assisted electron leakage", naming tunnelling as the dominant term. | Quantitatively impossible as written (§B.5). |
| M6 | Fix the Table III overflow (59.26 pt) and delete the duplicated §IV-E paragraphs. | Both confirmed. |

### E.2 Should fix

| # | Correction | Why |
|---|---|---|
| S1 | Add one ionisation-disabled control at the nominal planar and report whether the knee survives. Strongly recommended, not blocking. | It closes the mechanism question with a single run; nothing else in the paper needs a new simulation. |
| S2 | If the ionisation integral is shown at all, show I versus V **and** state its mesh limit (α = 6.7×10⁴ cm⁻¹ needed; ±20 % field ⇒ ×6 on I). | Quoted without that caveat, 0.090 invites exactly the misreading this review first made (§B.1). |
| S3 | Restate the dose/thickness results as **two regimes** with a bounded boundary (somewhere between 1.0× and 1.5× dose, between 150 and 250 nm), with the 80 nm point restored. | The cliff is the real result; its mechanism is unresolved, so state the boundary and label the mechanism open. |
| S4 | Reconcile the field magnitudes and state which monitor produces Figs. 5, 7, 8; if unresolvable, remove the absolute colour scales and the field-reduction argument. | Two of the project's own numbers differ by 9×. |
| S5 | Correct the exposed-area ratio or state the counting convention; keep A_ref for the operational comparison. | 2 pp discrepancy, unresolved convention. |
| S6 | Label the interface sheet charge as an assumed input, and either source it or show the ranking is insensitive to it. | It is part of the charge budget that sets the reported voltage. |
| S7 | Report the 350 K planar crossing as a bracket (2430.1–2446.5 V, one 5.3×10⁴ current jump), not as 2437 V with a +2 V/K slope. | The slope is not resolved; the bracket allows +1.8 to +2.1 V/K. |
| S8 | State explicitly that the trench FP does not overlap the active-ring field maximum (r ≈ 48 µm vs plate 55–67 µm). | Otherwise the null result reads as physics. |
| S9 | Put the bare/terminated comparison in its correct regime: bare breaks *below* punch-through (929 V < 1459 V), terminated designs block *above* it (2336 V = 1.60×1459 V). | The ratio 2.5× is not a termination efficiency. |

### E.3 Optional

| # | Suggestion |
|---|---|
| O1 | Reframe the contribution around the criterion dependence plus the two observed channels (electron leakage with a strong temperature activation at 400 K; a hole-focused termination event at 298/350 K, mechanism left open). Stronger than the current framing and needs no new physics. |
| O2 | Add the 0.1 mA/cm² column to Table III, or drop V²/V_on. In its current form the highest number in the table (15.50 MV) belongs to the device whose stricter-criterion voltage is 925 V. |
| O3 | Report M_on and BFOM to the precision the brackets support (the 6 V ordering at 400 K/10 mA/cm² is not resolved). |
| O4 | Cite the Fiedler value as the (001)-normal permittivity, not the "c-axis static value" (R04 is right). |
| O5 | Add a one-page case-to-file manifest (deck, mesh hash, par hash, PLT, extraction rule). |

---

## F. Independent publication assessment

**Recommendation: Major Revision.**

*What survives and is good.* The physics reading is defensible. Two model-independent tests — barrier-independence to 0.32 V across 0.75 eV, and a +1.95 V/K coefficient of the sign avalanche predicts and leakage does not — support the impact-ionisation classification better than the numerical integral does, and the manuscript's separation of the 400 K leakage threshold from the 298/350 K knee is correct. The extraction discipline is above the norm for simulation papers: log-current interpolation with a stated sustain rule, a common reference area kept distinct from physical area, mesh-sensitivity disclosure, literal compliance-versus-threshold language, controlled within-family temperature runs (shared `.par` hash), and a Yang benchmark correctly framed as a crossing-scale check. Review 04's prior-art survey is sound and its "established concept, incremental implementation" verdict stands.

*Why it is still not submittable.* (i) The 80 nm exclusion is given a physical reason the archive contradicts, and it hides a cliff that is more interesting than the trend it protects. (ii) Four of eight rows of Table II and one panel of Fig. 1 have no traceable primary evidence — and that Fig. 1 panel was once removed by the authors themselves as unverified. (iii) The field magnitudes cannot be reconciled between two of the project's own monitors, which blocks every field-based argument and leaves the avalanche model's input field unknown. (iv) The 400 K mechanism sentence is quantitatively impossible. (v) Two production errors remain.

None of this needs a new physical result or a new campaign. It is disclosure, traceability and correction, plus at most one control run. That is a major revision, not a rejection — the label Review 05 reached, and the one I initially and wrongly refused.

## Appendix — reproduction of every number quoted above

Working directory: `Z:\synopsys_chipin_work\STDB\tmp\Final_Research`. Parser: `plt_audit2.py` (reads the `datasets` list, chunks each `Data` block by column count, interpolates logarithmically in current between adjacent samples, requires the high side plus five subsequent samples at or above criterion).

```
A_ref = pi * (52.5e-4 cm)^2 = 8.6590e-5 cm^2
J     = |cathode TotalCurrent| / A_ref
V_rev = |anode OuterVoltage - cathode InnerVoltage|
I_e, I_h = datasets "PhiElectron", "PhiHole"   (functions block: IonizationIntegral ×2)
```

| Quantity | File | Value |
|---|---|---|
| PDF SHA-256 | `Paperwriting/Manuscript_v5_reverse.pdf` | `54ed7649ca1e…20ef` (`sha256sum`) |
| Planar 2336 V crossing | `NLM_g156e8_Full_Batch_20261122/03_Planar_WF5p10/rev_03_Planar_WF5p10.plt` | 2335.82 V [2335.69, 2336.27]; I_e 0.0776, I_h 0.0038 |
| Planar final state | same | −2422.45 V, I = 1.026×10⁻³ A, J = 11.85 A/cm², I_e 0.0897, I_h 0.0043, hole 100.000 % |
| Thin 80 nm / 1.10 eV | `…/10_Thin080nm_WF5p10/rev_10_Thin080nm_WF5p10.plt` | 2347.13 V [2346.89, 2347.25], 0.1 mA crossing 2346.54 V, 1013 pts, CLOSED |
| 2.0× Mg planar avalanche | `pGaN_thickness_doping/2A_Planar_Mg_2p00x/rev.plt` | I_e 1.302 / I_h 2.145 at −652 V; crossing 490.8 V |
| 1.5× Mg planar | `…/2A_Planar_Mg_1p50x/rev.plt` | I_e 1.214 / I_h 1.498 at −627 V; crossing 679.6 V |
| 250 / 350 nm | `…/2B_Planar_t0p25um/rev.plt`, `…/2B_Planar_t0p35um/rev.plt` | I_e 0.881 at −617 V / 1.024 at −577 V |
| 350 K planar bracket | `temperature/01_Planar_T350K/rev.plt` | [2430.149, 2446.464] V; J 9.559×10⁻⁶ → 5.058×10⁻¹ A/cm² |
| 400 K planar | `temperature/01_Planar_T400K/rev.plt` | 1 mA: 1472.98 V [1470.21, 1478.52], hole 0.065 %; 10 mA: 2544.98 V [2540.11, 2555.60], I_e 0.053, hole 99.49 % |
| Compliance | all eight nominal `.plt` | \|I_final\| = 1.00–1.06×10⁻³ A |
| Barrier independence | `barrier_height/01_Planar_WF{4p75,4p90,5p10,5p30,5p50}/rev.plt` | 2335.59 / 2335.90 / 2335.90 / 2335.91 / 2335.91 V (spread 0.32 V) |
| J at −1000 V, 298/350/400 K | planar 298 K deck plus `temperature/01_Planar_T{350,400}K/rev.plt` | 8.72×10⁻⁹ / 2.14×10⁻⁴ / 7.14×10⁻⁴ A/cm² |
| GaN field for I = 1 | derived, 0.15 µm path | 4.06 MV/cm (e), 4.46 MV/cm (h); α = 6.67×10⁴ cm⁻¹ |
| Field implied by I = 0.090 | derived | 3.15 MV/cm (e), 2.88 MV/cm (h) |
| Integral sensitivity to field error | derived | +20 % → ×6.0; −20 % → ×0.067; +30 % → ×12.1 |
| Integral growth at the stop | planar 298 K | dI_e/dV = 1.40×10⁻⁴ V⁻¹ (−2380.4 → −2422.5 V) |
| Overfull box | `Paperwriting/Manuscript_v5_reverse.log:542` | 59.25717 pt, lines 228–239 |
| Duplicate paragraphs | `Paperwriting/Manuscript_v5_reverse.tex` | 244–246 ≡ 248–250 |
| Substrate doping | `Bare/build_split.scm:24`, `04_mesh_generators/planar/build_planar_150nm_sn.scm:43` | 3.6e18 both |
| No-FP evidence | `find . -iname "*NoFP*"` | 3 `.scm` builders, no solver output |
| Review 03 | `find . -maxdepth 3 -iname "Review_03*"` | does not exist |
| Punch-through of the drift | derived | 1459 V; 2336 V = 1.60 × V_pt |
| Ideal JTE dose | derived | 5.5×10¹³ cm⁻²; active at equilibrium 3.0/2.2/1.7×10¹² cm⁻² |
| 400 K thermionic requirement | derived | φ_eff 0.772 eV → 0.33 eV lowering → 9.2 MV/cm |
