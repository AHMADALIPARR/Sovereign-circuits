# Software Safety Analysis
**Project:** Sovereign Circuits  

## 1. System Context

The software produces artifacts and formal evidence for dual-circuit systems that protect SRAM writes behind a controller lock derived from phase-error calibration of dual oscillators.

## 2. Hazard Identification

| Hazard ID | Description | Severity | Controllability |
|-----------|-------------|----------|-----------------|
| H-01 | Unauthorized SRAM write while controller is not locked | High (data corruption / security) | Software gate |
| H-02 | Controller reports RUN while not locked | High | Formal invariant |
| H-03 | Oscillator calibration word drives frequency outside safe bounds while locked | Medium | Formal bounds lemma |
| H-04 | Tool generates incorrect netlist leading to wrong simulation conclusions | Medium | ERC + inspection |
| H-05 | Formal proof is accepted but does not correspond to the shipped RTL | High | Equivalence checking |

## 3. Risk Analysis & Controls

| Hazard | Cause | Control | Residual Risk |
|--------|-------|---------|---------------|
| H-01 | Missing or bypassed write-enable gate | Combinational gate in RTL + Cryptol property `sram_write_protected` proved in SAW | Low (machine-checked) |
| H-02 | State-machine coding error | `run_implies_locked` property + PSL assertions | Low |
| H-03 | Calibration arithmetic error | Lemma `lock_implies_calibrated_osc` | Low |
| H-04 | Parser / emitter bug | ERC checks, golden-board regression, human inspection of generated decks | Medium |
| H-05 | Divergence between model and RTL | SAW equivalence (Crystal JSON path for write-cell; planned for controller) | Medium → Low with full equivalence |

## 4. Failure Modes & Effects (Software)

- **MNA singular matrix** → explicit error and exit (no silent wrong voltages).
- **Floating net** → ERC warning; does not halt generation (user responsibility).
- **Proof failure** → CI / release gate fails; no claim of verified status.

## 5. Safety Requirements Derived

- SR-01: SRAM write enable shall be asserted only when mode = RUN and locked = true. (→ FR-07)
- SR-02: The controller shall never enter RUN without setting locked. (→ FR-06)
- SR-03: Formal models used for safety claims shall be shown equivalent (or refined) to the RTL delivered. (→ equivalence strategy)

## 6. Safety Case Outline

1. Requirements and architecture define the protection mechanism.
2. Formal models capture the critical invariants.
3. Machine-checked proofs discharge the invariants.
4. Equivalence / refinement arguments link models to RTL.
5. Testing and ERC provide supporting evidence for the generation tools.
