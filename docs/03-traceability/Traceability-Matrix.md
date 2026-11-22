# Requirements Traceability Matrix
**Project:** Sovereign Circuits  
**Version:** 0.1.0  

| Req ID | Requirement Summary | Design / Architecture | Implementation | Verification Artifact | Test / Proof |
|--------|---------------------|-----------------------|----------------|-----------------------|--------------|
| FR-01 | Board → SPICE deck | Architecture §2 (eda.awk) | `posix-eda/eda.awk`, `eda-full.awk` | SPICE emission | Manual / ngspice regression |
| FR-02 | Structural netlist + BOM | Architecture §2 | `eda-full.awk` (mode=netlist) | Netlist + BOM output | Inspection |
| FR-03 | Verilog-A board_top synthesis | Architecture §2 | `eda-full.awk` (mode=veriloga) | Generated `.va` | OpenVAF compile |
| FR-04 | ERC (floating, ground, duplicates) | Architecture §2 | Both eda*.awk END blocks | stderr warnings | Unit tests on malformed boards |
| FR-05 | Pure-awk MNA (DC + transient + diode) | Architecture §2 | `posix-eda/mna.awk` | Time-series stdout | Comparison vs ngspice |
| FR-06 | RUN ⇒ locked | Semantics + Cryptol | `formal/semantics/state.mlw`, `formal/cryptol/state.cry` | SAW `run_implies_locked` | Machine-checked proof |
| FR-07 | SRAM WE gated by RUN ∧ locked | Circuit contract | `formal/cryptol/circuit_contract.cry`, `formal/rtl/p4_controller.vhd` | SAW `sram_write_protected` | Machine-checked proof |
| FR-08 | Oscillator bounds when locked | Refinement | `formal/semantics/refinement.mlw`, `formal/semantics/oscillator.mlw` | Lemma `lock_implies_calibrated_osc` | Formal lemma |
| FR-09 | Write-cell retain + complementary BL | Write-cell model | `formal/cryptol/sram_write_cell.cry`, `formal/rtl/sram_write_cell.vhd`, Crystal | SAW properties + equivalence | Cryptol + SAW + GHDL |
| FR-10 | Zero-dependency core path | Architecture §4 | All `posix-eda/*.awk` | Execution with only awk | Environment check |

**Legend**  
- Implementation = primary source file(s)  
- Verification Artifact = proof script, test, or inspection method that demonstrates the requirement is met.
