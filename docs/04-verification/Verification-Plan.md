# Verification Plan & Evidence
**Project:** Sovereign Circuits  

## 1. Objectives

Demonstrate that the implementation satisfies the specified requirements (FR-01 … FR-10 and safety properties) through a combination of:

- Static analysis / ERC
- Formal property proofs (Cryptol + SAW + Z3)
- Equivalence checking (Cryptol ↔ RTL / JSON netlist)
- Simulation comparison (awk MNA vs ngspice)
- Code inspection and peer review

## 2. Verification Methods by Requirement Class

| Class | Methods |
|-------|---------|
| Functional (FR-01–05) | Execution of awk tools on golden boards, comparison of outputs, visual inspection of generated decks |
| Safety properties (FR-06–09) | Machine-checked proofs in SAW (Z3 backend) |
| Zero-dependency (FR-10) | Execution in a minimal POSIX environment containing only awk |

## 3. Formal Proofs (Primary Evidence)

Located under `formal/saw/`:

- `digital_equivalence.saw` / `proof_gate.saw` — controller invariants + SRAM write protection
- `verify_all.saw` — unified entry point covering write-cell, Malbolge ALU, and P4 dual-circuit properties
- Individual Cryptol properties: `run_implies_locked`, `sram_write_protected`, `writeRetainsWhenDisabled`, `bitlinesComplementaryWhenEnabled`, etc.

**Status:** Proof scripts are present and intended to be run with SAW + Z3. Successful discharge of the properties constitutes verification evidence for the corresponding requirements.

## 4. Simulation-Based Verification

- Generate SPICE from `eda.awk` / `eda-full.awk` and run under ngspice; compare key node voltages against `mna.awk` output on the same board.
- ERC warnings are emitted to stderr and can be captured for automated checking.

## 5. Equivalence Checking

- Crystal-generated `sram_write_cell.json` is imported via SAW `yosys_import` and checked against the Cryptol `writeCellCircuit`.
- Future extension: AIGER / Yosys netlist of `p4_controller` for full RTL ↔ Cryptol equivalence.

## 6. Verification Records

Proof execution logs, ngspice vs mna comparison tables, and ERC result captures shall be stored under `docs/04-verification/evidence/` (or as CI artifacts) for each release baseline.
