# Final Research

Start here. This workspace separates evidence for the existing paper from experiments for the redesign. The old `15_LeanMesh_Calibration` tree is a source archive; do not edit it from this workspace.

| Folder | What belongs here |
|---|---|
| `01_as_run_reference/` | Exact, unedited inputs and saved outputs for verified paper runs, with source paths and SHA-256 hashes. Keep historical comments as part of the original bytes, not as evidence of what ran. |
| `02_clean_model/` | Editable redesign inputs: geometry `.scm`, mesh `.tdr`, material `.par`, and forward/reverse `.cmd`. Any physics or geometry change creates a new model revision. |
| `03_redesign_runs/` | One directory per run ID, containing a snapshot of exact inputs (or references to immutable hashed inputs), the executed log, `.plt`, `.tdr`, and stop reason. Never overwrite a completed run. |
| `04_paper_evidence/` | One evidence row per figure panel/table result, linked to the run ID or marked `unverified`. Keep the earlier evidence web out of the trusted reference set. |

## Which facts to trust

- **Intent:** `PARAMETER_DECISIONS.md` records what we want in the clean model. Intent is not proof a historical run used it.
- **What ran:** take settings from the run's solver log, keeping the global/named nonlocal prefactor separate from material/region echoes and checking which carrier and path the executed deck enables. A logged assignment and an active physical contribution are different claims. File comments do not decide either.
- **Which output:** link `.log` to the executed `.cmd` and its output paths. Require a full output hash match when identifying a relocated/copied `.plt` or `.tdr`. Record input provenance separately; a matching curve does not prove every historical input was recovered.
- **What the paper can say:** use the criterion the manuscript actually defines. Record first excursions separately from sustained crossings. If an important link is missing, mark the specific link unverified rather than guessing.

## First checkpoint

Freeze the already identified reverse-output anchors: nominal plated planar, nominal plated mesa, and thin 80 nm low-barrier planar. For each, collect the source log/deck, exact mesh and parameter dependencies where recoverable, and output hashes. Only then create the first editable redesign baseline. Do not copy the entire campaign or use the previously edited reviewer package as the as-run source of truth.
