# Architecture Document
**Project:** Sovereign Circuits  
**Version:** 0.1.0  

## 1. Overview

Sovereign Circuits is organized as a layered, text-centric pipeline:

```
Board Description (.txt)
        │
        ▼
   POSIX awk EDA (eda.awk / eda-full.awk / mna.awk)
        │
        ├──► SPICE deck ──► ngspice / Xyce (optional)
        ├──► Structural Netlist + BOM + ERC
        ├──► Verilog-A synthesis
        └──► KiCad S-expression
        │
        ▼
Formal Layer
  ├── Semantics (.mlw) – abstract state machines & invariants
  ├── Cryptol – executable bit-precise specs + properties
  ├── SAW – proof scripts linking Cryptol ↔ RTL / netlist
  ├── RTL (VHDL) – synthesizable dual-circuit implementation
  └── Analog (Verilog-A + parasitics)
```

## 2. Components

| Component | Location | Responsibility | Interfaces |
|-----------|----------|----------------|------------|
| Board Format | `posix-eda/*.txt` | Human-readable schematic | stdin / file |
| eda.awk / eda-full.awk | `posix-eda/` | Compilation, ERC, multi-format emission | stdin → stdout |
| mna.awk | `posix-eda/` | DC + transient MNA solver | board → time-series voltages |
| Semantics | `formal/semantics/` | Abstract models + lemmas (Why3 style) | pure functional |
| Cryptol Specs | `formal/cryptol/` | Bit-precise models + properties | Cryptol interpreter / SAW |
| SAW Scripts | `formal/saw/` | Property proofs + equivalence | SAW + Z3 |
| VHDL RTL | `formal/rtl/` | Dual-circuit controller + SRAM + phase calibrator | GHDL / synthesis |
| Verilog-A | `formal/analog/` | Oscillator & relaxation oscillators + parasitics | OpenVAF / ngspice |
| Crystal Synth | `crystal-synth/` | Zero-Yosys VHDL + JSON netlist generation | Crystal runtime |

## 3. Key Interfaces

- **Board → Tool**: whitespace-delimited text, comments with `#` or `*`.
- **Tool → SPICE**: standard SPICE deck (`.end` terminated).
- **Tool → Formal**: Cryptol and SAW consume the same semantic models used for RTL.
- **RTL ↔ Formal**: SAW `yosys_import` / AIGER path (or Crystal-generated JSON) for equivalence.
- **Analog ↔ Digital**: Phase calibrator measures dual oscillators; controller locks and gates SRAM writes.

## 4. Dependencies

**Required (core path):**  
- POSIX `awk`, `mkfifo`, standard shell utilities.

**Optional (extended flows):**  
- ngspice / Xyce, OpenVAF, GHDL, SAW, Cryptol, Crystal, Z3.

No proprietary EDA, no cloud services, no closed-source binaries in the primary assurance path.

## 5. Design Assumptions

1. Ground is node `0` / `gnd`.
2. Reference designators start with R, C, L, V, I, D, X (for subcircuits / behavioral).
3. Controller modes form a state machine: Idle → Calibrate → Run | Fault.
4. SRAM write protection is a pure combinational gate of mode and lock status.
5. Formal models intentionally abstract continuous analog dynamics into discrete state for digital safety properties.

## 6. Data Flow (Safety-Critical Path)

```
Phase Error ──► p4_controller ──► locked / sram_we_en
                      │
                      ▼
                 SRAM write gate ──► sram_bank
```

All writes are blocked unless the controller is in RUN and locked.
