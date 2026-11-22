# Release Process & Evidence
**Project:** Sovereign Circuits  

## 1. Release Criteria

A version may be released when:

- [ ] All FR-* requirements have corresponding verification evidence.
- [ ] Safety properties FR-06–09 are discharged by formal proof (or explicitly deferred with justification).
- [ ] Golden-board regression and ERC checks pass.
- [ ] Peer review of changes since last baseline is complete.
- [ ] Documentation (including this release package) is updated.
- [ ] Known issues list is current.
- [ ] License and copyright notices are intact.

## 2. Release Artifacts

Each GitHub Release shall contain or reference:

1. Source tree (tag).
2. Release notes (changes, known issues, tool versions used for proofs).
3. Verification evidence summary (proof logs, test results).
4. Traceability matrix status for the release.
5. Safety analysis status (any residual risks).

## 3. Approval

- Maintainer approval of the PR that prepares the release tag.
- For higher-assurance uses, independent review of the proof evidence is recommended before operational acceptance.

## 4. Acceptance Records

Acceptance by a consumer is recorded by the consumer (e.g., “Accepted tag vX.Y.Z for use in project P on date D”). The project itself maintains the evidence that the release criteria were met.

## 5. Known Issues (Template)

At each release the following shall be listed:

- Open defects with severity.
- Deferred formal properties (if any) and rationale.
- Tool version caveats (SAW / Z3 / GHDL / etc.).
