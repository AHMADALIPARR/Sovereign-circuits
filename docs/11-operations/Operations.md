# Operations Guide
**Project:** Sovereign Circuits  

## 1. Deployment

The software is delivered as source. Deployment consists of:

1. Cloning a tagged release.
2. Ensuring a POSIX environment with `awk` is available.
3. (Optional) Installing extended tools (ngspice, GHDL, SAW, Crystal, OpenVAF) according to the user’s needs.

No installation package or daemon is required for the core path.

## 2. Monitoring

- For interactive use, users observe ERC warnings on stderr and proof success/failure messages.
- In CI, proof and regression job status constitutes the primary monitoring signal.

## 3. Anomaly Handling

| Anomaly | Response |
|---------|----------|
| ERC warning | Inspect board; correct floating nets / missing ground |
| MNA singular matrix | Review circuit topology; add ground or remove floating sources |
| SAW proof failure | Investigate model / property change; do not claim verified status until re-discharged |
| Divergence between mna.awk and ngspice | Investigate numerical tolerances or model differences; file defect |

## 4. Recovery

- All artifacts are text; recovery is via Git checkout of a known-good tag.
- No persistent state is maintained by the tools themselves.

## 5. Maintenance

- Bug fixes and enhancements follow the Configuration Management Plan.
- Safety-property changes require re-execution of the full proof suite and update of the safety analysis.
- Documentation is kept in sync with code changes via the PR checklist.
