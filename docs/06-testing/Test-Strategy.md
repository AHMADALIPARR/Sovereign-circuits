# Test Strategy
**Project:** Sovereign Circuits  

## 1. Test Levels

| Level | Scope | Location / Method |
|-------|-------|-------------------|
| Unit | Individual awk functions, Cryptol properties, small VHDL entities | `tests/unit/`, SAW property proofs |
| Integration | Board → eda → SPICE / netlist / Verilog-A pipeline | `tests/integration/` |
| System | Full dual-circuit model (controller + SRAM + phase) + formal proofs | `tests/system/`, `formal/saw/verify_all.saw` |
| Regression | Golden boards and known-good proof sets | `tests/regression/` |
| Boundary | Extreme values, missing ground, floating nets, diode high/low | `tests/boundary/` |
| Acceptance | End-to-end operational scenarios from Validation Plan | `tests/acceptance/` |

## 2. Key Test Cases (Illustrative)

- **TC-EDA-01**: RC low-pass + diode board compiles to valid SPICE and produces expected filtered / clipped waveform under ngspice and mna.awk.
- **TC-ERC-01**: Board with floating net emits ERC WARNING on stderr.
- **TC-MNA-01**: SIN source + RC circuit DC + transient matches ngspice within tolerance.
- **TC-FORMAL-01**: `run_implies_locked` property discharges.
- **TC-FORMAL-02**: `sram_write_protected` property discharges.
- **TC-WRITE-CELL-01**: Cryptol properties + SAW equivalence against Crystal JSON / VHDL.
- **TC-RTL-01**: GHDL analysis & elaboration of all VHDL entities succeeds.

## 3. Automation

Scripts under `scripts/` and (future) GitHub Actions workflows will:
- Run awk tools on golden inputs and diff outputs.
- Invoke SAW on the proof scripts.
- Optionally run GHDL and ngspice where available.

## 4. Coverage Goals

- All FR-* requirements mapped to at least one test or formal proof.
- All safety properties (FR-06–09) covered by machine-checked proofs.
- Boundary and negative cases for ERC and MNA singularity handling.
