# Software Requirements Specification (SRS)
**Project:** Sovereign Circuits  
**Version:** 0.1.0  
**Status:** Baseline  

## 1. Purpose

Define the functional, safety, and interface requirements for a zero-dependency POSIX-based EDA and formal verification environment targeting safety-critical dual-circuit designs (controller + SRAM protection + oscillators).

## 2. Scope

The software shall provide:
- Board description language and compilation to SPICE, structural netlist, Verilog-A, and KiCad S-expression.
- Pure-awk Modified Nodal Analysis (MNA) solver supporting R, C, L, V, I, D and SIN sources.
- Formal semantic models of the P4 dual-circuit controller, SRAM, and oscillator.
- Executable Cryptol specifications and SAW proof scripts demonstrating key safety properties.
- Synthesizable VHDL RTL of the dual-circuit system.
- Zero-Yosys Crystal synthesizer producing pure VHDL + SAW-compatible JSON netlists.

## 3. Functional Requirements

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-01 | The system shall accept a whitespace-delimited board description (one component or directive per line) and produce a valid SPICE deck. | Must |
| FR-02 | The system shall emit a structural netlist with net-to-pin connectivity and degree, plus an aggregated BOM. | Must |
| FR-03 | The system shall synthesize a complete Verilog-A board_top module from primitive instances and user-defined `.va` blocks. | Should |
| FR-04 | The system shall perform basic ERC (floating nets, missing ground, duplicate references). | Must |
| FR-05 | The pure-awk MNA solver shall compute DC operating point and Backward-Euler transient responses including Shockley diode linearization. | Must |
| FR-06 | The controller formal model shall enforce that RUN mode implies locked = true. | Must |
| FR-07 | SRAM write enable shall be gated by (mode = RUN ∧ locked). | Must |
| FR-08 | Oscillator calibration word shall remain within defined frequency bounds when the system is locked. | Must |
| FR-09 | The SRAM write-cell shall retain previous value when write-enable is deasserted and produce complementary bitlines when asserted. | Must |
| FR-10 | All core tools shall execute using only POSIX utilities (awk, mkfifo, etc.) with no proprietary binary toolchains required for the primary flow. | Must |

## 4. Non-Functional Requirements

| ID | Requirement |
|----|-------------|
| NFR-01 | Source shall be human-readable text; no binary intermediate forms required for inspection. |
| NFR-02 | Formal proofs shall be machine-checkable with publicly available tools (Z3 via SAW/Cryptol). |
| NFR-03 | VHDL shall be pure IEEE 1076 (GHDL-compatible, no vendor primitives). |
| NFR-04 | License shall be AGPLv3 to preserve network-use source disclosure. |

## 5. Assumptions & Dependencies

- User environment provides a POSIX-compatible shell and awk.
- Optional external tools (ngspice, OpenVAF, GHDL, SAW, Crystal) are used only for extended flows; core path remains zero-dependency.
- Formal models abstract continuous-time analog behavior into discrete state for verification of digital control and memory protection properties.

## 6. Traceability

Requirements are linked to design elements, implementation files, and verification artifacts in `docs/03-traceability/`.
