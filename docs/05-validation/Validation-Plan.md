# Validation Plan
**Project:** Sovereign Circuits  

## 1. Intended Operational Use

The software is intended for:

- Description and analysis of mixed-signal dual-circuit systems in research and safety-critical development environments.
- Generation of inspectable SPICE / Verilog-A / netlist artifacts without proprietary toolchains.
- Machine-checked demonstration of digital control and memory-protection safety properties.

## 2. Validation Approach

Validation confirms that the system satisfies its intended use, not merely that it meets the written requirements.

| Activity | Method | Success Criteria |
|----------|--------|------------------|
| End-to-end board flow | Compile example boards → SPICE → ngspice waveform | Waveforms match expected filter / clipper behavior |
| Formal safety story | Execute SAW proofs on the dual-circuit model | All stated safety properties discharge |
| Zero-dependency claim | Run core awk tools in a container with only POSIX utilities | Successful execution, correct outputs |
| RTL usability | Elaborate VHDL with GHDL | Clean analysis & elaboration |
| Analog co-simulation readiness | Compile Verilog-A with OpenVAF (optional) | Successful compilation |

## 3. Operational Scenarios

1. **Design exploration** — engineer writes board.txt, iterates with eda-full.awk + mna.awk.
2. **Safety case generation** — formal models + SAW proofs are included in a certification package.
3. **Toolchain audit** — third party inspects every source file; no closed binaries required for core claims.

## 4. Validation Evidence

- Example boards and resulting waveforms / netlists.
- Proof logs demonstrating property discharge.
- Container / minimal-environment run logs.
- Review records of the architecture and safety analysis against the operational use cases.

Validation is considered complete for a release when the scenarios above have been executed and the evidence archived under `docs/05-validation/evidence/` or the release package.
