# Sovereign Circuits

Zero-dependency POSIX pipeline for analog/digital circuit description, compilation, simulation, and formal verification of safety-critical dual-circuit designs (P4-style controller + protected SRAM + oscillators).

## Overview

This repository unifies:

1. **POSIX EDA tools** (pure `awk`) — board description → SPICE / Verilog-A / netlist / KiCad / MNA solver
2. **Formal semantics** (Why3-style `.mlw`) for controller, SRAM, oscillator, and system refinement
3. **Cryptol** specifications + properties
4. **SAW** proof scripts for property + RTL equivalence checking
5. **VHDL RTL** (GHDL-friendly, zero external IP)
6. **Verilog-A** analog blocks + parasitic models
7. **Crystal synthesizer** that emits pure IEEE VHDL + SAW-compatible JSON netlists (no Yosys required)

The design philosophy is *sovereign*: everything runs with standard POSIX tools, GHDL, Cryptol/SAW, and optional ngspice/OpenVAF. No proprietary EDA, no cloud services, no hidden dependencies.

## Directory Layout

```
Sovereign circuits/
├── posix-eda/                 # Zero-dep awk EDA + MNA solver
│   ├── board.txt              # Example RC + diode
│   ├── board-hybrid.txt       # Example with inline .va
│   ├── eda.awk                # Basic spice/netlist
│   ├── eda-full.awk           # Full: spice | veriloga | netlist | kicad
│   └── mna.awk                # Modified Nodal Analysis (DC + transient + diode)
├── formal/
│   ├── semantics/             # Why3 / mlw models
│   │   ├── state.mlw
│   │   ├── sram.mlw
│   │   ├── oscillator.mlw
│   │   ├── refinement.mlw
│   │   └── sram_write_cell.mlw
│   ├── cryptol/               # Cryptol specs + properties
│   │   ├── state.cry
│   │   ├── sram.cry
│   │   ├── circuit_contract.cry
│   │   ├── sram_write_cell.cry
│   │   ├── malbolge_alu.cry
│   │   └── p4_dual_circuit.cry
│   ├── saw/                   # SAW proof scripts
│   │   ├── digital_equivalence.saw
│   │   ├── sram_refinement.saw
│   │   ├── proof_gate.saw
│   │   └── verify_all.saw
│   ├── rtl/                   # Synthesizable VHDL
│   │   ├── p4_controller.vhd
│   │   ├── dual_circuit.vhd
│   │   ├── sram_bank.vhd
│   │   ├── phase_calibrator.vhd
│   │   └── sram_write_cell.vhd
│   ├── analog/                # Verilog-A + SPICE parasitics
│   │   ├── oscillator.va
│   │   ├── relaxation.va
│   │   └── parasitic_model.sp
│   └── verification/
│       ├── psl/dual_circuit.psl
│       ├── pex/pex_rc_check.awk
│       └── thermal/thermal_sweep.sp
├── crystal-synth/
│   └── synth_sram.cr          # Crystal → pure VHDL + SAW JSON (0 Yosys)
└── README.md
```

## Quick Start — POSIX EDA

```bash
cd posix-eda

# Compile to SPICE and run in ngspice
awk -v mode=spice -f eda.awk board.txt | ngspice -b -

# Structural netlist + ERC
awk -v mode=netlist -f eda.awk board.txt | sort

# Full-featured (Verilog-A synthesis, KiCad, BOM)
awk -v mode=veriloga -f eda-full.awk board-hybrid.txt > board.va
awk -v mode=netlist  -f eda-full.awk board-hybrid.txt
awk -v mode=kicad    -f eda-full.awk board-hybrid.txt > board.net

# Pure-awk MNA solver (no external simulator required)
awk -f mna.awk board.txt | column -t
```

## Quick Start — Crystal + GHDL + SAW (SRAM write cell)

```bash
cd crystal-synth
crystal run synth_sram.cr          # emits sram_write_cell.vhd + .json

# Zero-dependency GHDL
ghdl -a --std=08 sram_write_cell.vhd
ghdl -e --std=08 sram_write_cell

# Then run SAW (adjust paths to .cry / .json as needed)
saw ../formal/saw/verify_all.saw
```

## Core Safety Properties

- **Controller**: `RUN` mode implies `locked = true`
- **SRAM**: write enable is gated by `(mode = RUN ∧ locked)`
- **Oscillator**: calibrated code stays within frequency bounds when locked
- **Write cell**: retains previous value when disabled; complementary bitlines when enabled
- **Malbolge ALU**: ternary add/sub inverse + crazy-op self-bound (aligned with Lean axioms)

## Philosophy

Everything is text. Everything pipes. Everything is auditable.

- No binary blob toolchains for the core flow
- Formal models, executable specs, and RTL live side-by-side
- ERC, BOM, PEX timing budget, thermal corners all available as plain `awk` / SPICE

Contributions that preserve the zero-dependency invariant are welcome.

## License

This project is licensed under the **GNU Affero General Public License v3.0** (AGPLv3).
See the [LICENSE](LICENSE) file for the full text.
