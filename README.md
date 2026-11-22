# Sovereign Circuits

**Zero-dependency POSIX EDA + Formal Verification Stack for Safety-Critical Dual-Circuit Designs**

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](LICENSE)
[![Status](https://img.shields.io/badge/Status-Production%20Candidate-green.svg)]()

## Mission

Provide a fully auditable, tool-chain-sovereign environment for describing, compiling, simulating, and formally verifying mixed-signal dual-circuit systems (controller + protected SRAM + oscillators) without proprietary EDA dependencies.

## Key Properties

- **POSIX-only core tools** (`awk`) — no binary blobs required for board → netlist → SPICE / Verilog-A / KiCad / MNA
- **Formal models** (Why3-style `.mlw`, Cryptol, SAW) with machine-checked safety properties
- **RTL** synthesizable in pure IEEE VHDL (GHDL-friendly)
- **Analog** behavioral models in Verilog-A + parasitic RC
- **Crystal synthesizer** that emits both pure VHDL and SAW-compatible JSON (zero Yosys)

## Repository Structure

```
├── docs/                          # Process & assurance documentation (12 areas)
│   ├── 01-requirements/
│   ├── 02-architecture/
│   ├── 03-traceability/
│   ├── 04-verification/
│   ├── 05-validation/
│   ├── 06-testing/
│   ├── 07-safety/
│   ├── 08-configuration-management/
│   ├── 09-software-assurance/
│   ├── 10-cybersecurity/
│   ├── 11-operations/
│   └── 12-release/
├── posix-eda/                     # Zero-dep board compiler + MNA solver
├── formal/                        # Semantics, Cryptol, SAW, RTL, analog, verification
├── crystal-synth/                 # Zero-Yosys Crystal → VHDL + JSON
├── tests/                         # Unit / integration / system / regression / boundary / acceptance
├── scripts/                       # Build, proof, release helpers
└── LICENSE                        # AGPLv3
```

## Quick Start

```bash
# Compile board to SPICE and simulate
awk -v mode=spice -f posix-eda/eda.awk posix-eda/board.txt | ngspice -b -

# Full structural netlist + ERC + BOM
awk -v mode=netlist -f posix-eda/eda-full.awk posix-eda/board-hybrid.txt

# Pure-awk DC + transient MNA (no external simulator)
awk -f posix-eda/mna.awk posix-eda/board.txt | column -t

# Crystal zero-dep synthesis
cd crystal-synth && crystal run synth_sram.cr
```

## Process Coverage

This repository is organized against the following production software process areas:

1. Requirements  
2. Architecture  
3. Traceability  
4. Verification  
5. Validation  
6. Testing  
7. Software Safety  
8. Configuration Management  
9. Software Assurance  
10. Cybersecurity  
11. Operations  
12. Release Evidence  

See the corresponding folders under `docs/` for the detailed artifacts.

## License

GNU Affero General Public License v3.0 — see [LICENSE](LICENSE).
