# Cybersecurity Considerations
**Project:** Sovereign Circuits  

## 1. Threat Model (Summary)

| Threat | Relevance | Mitigation |
|--------|-----------|------------|
| Supply-chain compromise of binary EDA tools | High for conventional flows | Core path uses only source-level awk; no binary toolchains required |
| Malicious modification of formal models or proofs | High | Git history, signed tags, peer review, reproducible proof execution |
| Injection via board description | Low–Medium | Input is simple whitespace-delimited text; awk scripts do not execute external commands based on board content |
| Dependency vulnerabilities | Low for core | Core has zero external language dependencies; optional tools (SAW, Crystal, GHDL) are reviewed when used |
| Unauthorized write to protected SRAM (system under design) | High (system-level) | Primary safety property; formally proved |

## 2. Access Control

- Repository write access limited to maintainers.
- Releases are tagged; production consumers should pin to a specific tag or commit SHA.

## 3. Dependency Review

- Core: POSIX awk only.
- Extended: Crystal, SAW, Z3, GHDL, ngspice, OpenVAF — versions recorded in release evidence; advisories monitored.

## 4. Vulnerability Management

- Security-relevant issues are labeled and prioritized above ordinary defects.
- Fixes for safety or security properties are treated as high-priority changes and require full re-proof.

## 5. Secure Development Practices

- No secrets or credentials in the repository.
- All source is human-readable; no obfuscation.
- AGPLv3 encourages source availability for network-deployed derivatives.
