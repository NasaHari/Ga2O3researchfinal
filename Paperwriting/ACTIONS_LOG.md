# Manuscript revision log

## V3 → V4
- Preserved V3 and its artwork. Built V4 separately; no simulations were launched and campaign files were not modified.
- Reframed title, abstract and conclusion around simulated thickness, dose and leakage sensitivity. The three-zone acceptor profile is a TCAD input, not a demonstrated fabrication process.
- Kept the simulated 929 V split-anode trace but removed the unsupported exact geometry-only gain and its association with the neighboring single-anode field output.
- Replaced the percentile-field-times-thickness argument with the archived planar impact-ionisation on/off current comparison. Archived spatial plots are identified separately from the final architecture curves.
- Rebuilt Figs. 3, 5, 8 and 9 from existing PLT curves. Forward resistance fits use external terminal voltage and the 200–300 A/cm² interval. Reverse extraction uses the defined current criterion on the common reference area; curve_audit.csv records brackets. Two incomplete trench forward sweeps are omitted from turn-on and derived merit panels only. The 80 nm thickness-only run is omitted from Fig. 5; the separate 80 nm low-barrier result is retained.
- Retained all five requested comparisons. Qualified literature metrics by their extraction criteria. PDF built with pdfLaTeX and BibTeX and checked in rendered form.

## V4 → V5
- Added a device legend to Fig. 3(b).
- Digitized the blue and identifiable black 105-µm traces from the supplied crop of Yang et al. (APL 110, 192101, 2017), Fig. 5. Used pixel-to-axis calibration, omitted the red 210-µm trace, and left the obscured portion of the black curve unfilled. The CSV retains the image coordinates.
- Added a separate room-temperature bare-diode benchmark against the same split-anode PLT used in Table II. This is not a new fit. No solver reruns.

## Figure 5 readability revision
- Re-exported the four saved forward TDR states with larger labels and one shared linear colorbar. No solver reruns. No other figures, tables, or layout settings changed.

## Fig. 5 palette revision
- Used a mid-tone blue-to-warm palette with stronger separation between current levels and no near-black or washed-out color stops. The range, linear mapping of values to color positions, geometry, bias, and contour levels are unchanged. No other manuscript content changed.

## Contact labels and forward field
- Marked the mesh-defined Schottky and p-GaN ohmic edges in the current-density figure, widened the zoom to include the outer ohmic contact, and added the companion electric-field figure using the same saved forward states. The separate backside annotation is not a contour. No solvers rerun.

## Reverse-only contour revision
- Removed the forward current and forward electric-field maps and their calls. The forward I–V stays. Rebuilt the reverse-field figure using four clean-campaign saved TDRs, indicated actual reverse biases and contact positions, and substituted the nominal 150 nm case for the 80 nm panel. No runs repeated.

- Removed the unverified finer-mesh comparison from the active manuscript and Fig. 1; retained the bare-device panel and rebuilt the PDF. No simulation files changed.

- Restored original two-panel Fig. 1 and its caption only; rebuilt PDF. No simulation files changed.

- Added the four-architecture reverse-field figure from saved TDRs paired with PLT rows. No simulation reruns.

- Moved only the Fig. 5 float definition earlier in the results section; verified the figure and its first discussion now both appear on page 4.

## Manuscript revision after Review 06
- Compiled `Manuscript_v6_reverse.tex` as a separate PDF, preserving the v5 source, PDF, artwork, and section order. Added the completed 80 nm nominal-barrier point to Fig. 6(b) from the raw curve. Clarified the mesh comparison, extraction method, model assumptions, and temperature interpretation. Removed duplicate prose and widened Table III. No simulations were run.

## Independent adversarial audit (Review 06)
- Wrote `Review_06_Independent_Adversarial_Audit.md` (root). No manuscript, figure, deck, parameter or prior review file was modified; no solver was launched.
- Re-extracted all reverse `.plt` curves with an independent parser (columns resolved by dataset name, log-current interpolation, five-sample sustain rule). Reproduced every headline crossing to ≤0.05 V.
- Read the ionization-integral columns (`PhiElectron`/`PhiHole`, mapped by the file `functions` block to `IonizationIntegral`) that the prior four reviews did not inspect: nominal planar/mesa/80 nm integrals are 0.09–0.10 at the reported 2336–2347 V, whereas the 491–680 V cases reach 0.88–2.15. The reported "avalanche knee" language is not supported for the nominal designs.
- Confirmed the completed 80 nm / 1.10 eV run (2347.13 V, 1013 points, mesh `d73423df…`) that §IV-B says does not exist.
- Confirmed: no no-FP solver output anywhere; no data behind Fig. 1(a); substrate doping identical (3.6e18) in bare and planar builders; Table III overfull 59.26 pt; duplicated §IV-E paragraphs; `Review_03` never existed.
- Derived and recorded: drift punch-through 1459 V (2336 V = 1.60×), ideal JTE dose 5.5e13 cm⁻² vs 3.0e12 active, and the 400 K thermionic barrier requirement (0.772 eV → 9.2 MV/cm), which excludes the manuscript's "dominated by thermionic emission" sentence.
- **Retraction (same day).** The review's first draft used the ionisation-integral columns to argue the nominal designs do not avalanche, and recommended Reject. That is withdrawn. Recorded bound of the diagnostic: I = 1 over the 0.15 µm GaN JTE needs 4.06 MV/cm (e) / 4.46 MV/cm (h); I = 0.090 implies 2.9–3.2 MV/cm; α ∝ exp(−b/F) so ±20 % field uncertainty = ×6/÷15 on I, ±30 % = ×12/÷100; and every sweep stops at the 1 mA compliance while I is still climbing (dI/dV = 1.4e-4). The integral is one-sided: I ≥ 1 proves avalanche, I < 1 proves nothing.
- Adopted instead the author's classification, on two non-numerical tests that were recomputed here: the planar 1 mA/cm² crossing is barrier-independent to 0.32 V across 0.75–1.50 eV, and it moves +1.95 V/K from 298 to 350 K while every leakage measure in the archive rises with temperature. 400 K remains leakage-limited (electron fraction 99.94 %, 1473 V).
- Review 06 verdict reverted to Major Revision (Review 05's label). The items that survive the retraction and stay submission-blocking: the 80 nm run, the four no-FP rows with no raw trace, the Fig. 1 panel with no data, the undisclosed 1 mA compliance, the wrong substrate footnote, the 400 K thermionic sentence, and the two production errors.
