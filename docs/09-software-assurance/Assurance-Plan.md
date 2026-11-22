# Software Assurance Plan
**Project:** Sovereign Circuits  

## 1. Objectives

Provide confidence that the software is free from defects that would compromise the safety and functional claims.

## 2. Activities

| Activity | Description | Independence |
|----------|-------------|--------------|
| Peer review | All changes to formal models, RTL, and safety documentation reviewed by at least one other competent person | Same team or external |
| Formal verification | Machine-checked proofs of safety properties | Tool (Z3) provides independent checking |
| Static analysis / ERC | Floating nets, missing ground, duplicates | Automated |
| Defect tracking | Issues logged in GitHub Issues; linked to requirements where applicable | — |
| Independent assessment | For certification use, an independent assessor may re-run the SAW proofs and inspect the models | Recommended for high-assurance use |

## 3. Defect Analysis

- Defects discovered in proofs or tests are recorded with severity (safety-related vs quality).
- Safety-related defects trigger review of the corresponding hazard and control effectiveness.
- Root-cause analysis is performed for any defect that escaped into a released baseline.

## 4. Metrics (Targets)

- 100 % of safety properties (FR-06–09) discharged by formal proof before claiming “verified”.
- All PRs affecting formal or RTL assets receive peer review.
- Zero open safety-related defects at release.
