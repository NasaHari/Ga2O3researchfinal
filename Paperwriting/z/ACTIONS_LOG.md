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
