# Configuration Management Plan
**Project:** Sovereign Circuits  

## 1. Objectives

Ensure all artifacts (source, documentation, proofs, releases) are uniquely identified, change-controlled, and reproducible.

## 2. Identification

- **Repository**: GitHub `AHMADALIPARR/Sovereign-circuits`
- **Branching**: `main` is the protected baseline; feature work on topic branches.
- **Versioning**: Semantic versioning (MAJOR.MINOR.PATCH). Formal proof status is part of the release notes.
- **Baselines**: Each tagged release constitutes a baseline (source + docs + known proof results).

## 3. Change Control

1. Changes proposed via pull request.
2. Required checks: proof scripts still discharge (where tools available), golden-board regression, documentation update for affected requirements.
3. Reviewer approval required before merge to `main`.
4. Post-merge, tag if the change constitutes a release.

## 4. Reproducibility

- Core path depends only on POSIX awk; any modern awk implementation should produce identical outputs for the same input.
- Formal proofs depend on SAW + Z3 versions; exact tool versions shall be recorded in each release’s evidence package.
- Crystal-generated JSON is deterministic for a given synthesizer version.

## 5. Configuration Items

| CI | Location | Notes |
|----|----------|-------|
| Source (eda, mna, formal, rtl, analog) | Top-level technical directories | Primary |
| Process documentation | `docs/` | Controlled |
| Test assets | `tests/` | Controlled |
| Release packages | GitHub Releases | Tagged + assets |

## 6. Tools

- Git + GitHub for version control and PR workflow.
- Optional: GitHub Actions for automated proof / regression gates.
