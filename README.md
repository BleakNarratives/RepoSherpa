# RepoSherpa

**A repository chaperone for live software work.**

RepoSherpa observes repository and agent activity, gathers evidence, identifies defects and risk, and recommends or performs bounded interventions with an auditable trail.

It is designed to supervise work performed by coding agents and humans across GitHub repositories—not to pretend that a repository is healthy because its configuration says it is.

## Current status

This repository is being initialized. The files here define the portable contract and interface vocabulary; they do not yet constitute a live monitor or a verified runtime.

The first supervised project is [BleakNarratives/passive_income_swarm](https://github.com/BleakNarratives/passive_income_swarm).

## Operating model

1. **Observe** — inspect Git state, diffs, files, tests, agent events, and available runtime evidence.
2. **Explain** — report findings with severity, confidence, evidence, impact, and suggested remediation.
3. **Verify** — run or inspect checks where the environment permits; distinguish executed checks from inferred claims.
4. **Intervene** — make bounded, reversible changes only within the current authorization.
5. **Record** — preserve provenance, decisions, tool actions, and outcomes.

RepoSherpa does not equate a declared capability with a working capability, a green test report with production readiness, or a running process with a healthy service.

## Modes

- **Observer:** read-only reconnaissance and event capture.
- **Advisor:** analysis and recommendations; no repository writes.
- **Operator:** authorized implementation on a working branch.
- **Guardian:** blocks or escalates high-risk actions; never silently overrides the owner.

## Slash-command interface

The command registry lives in `interface/slash-commands.json`. A compatible text input should:

- show suggestions when the user types `/`;
- filter commands as the user types;
- support keyboard navigation and touch selection;
- display a short description and required arguments before execution;
- preserve ordinary text when it is not a recognized command;
- never execute a destructive action merely because a command was selected;
- resolve commands against the active repository, branch, session, and authorization scope.

Initial command vocabulary: `/status`, `/scan`, `/diff`, `/review`, `/risk`, `/tests`, `/watch`, `/explain`, `/help`.

## Architecture direction

- Portable core: repository reconnaissance, evidence model, policy checks, findings, and audit records.
- Adapters: GitHub, local Git/filesystem, coding-agent event streams, CI, test runners, and runtime probes.
- Interface: CLI first, then text-input command palette and ShipWrekD OS integration.
- Governance: Scouts gather evidence; the established Oracle process adjudicates changes to governed documentation and competency progression. This repo must adopt the existing canonical document format when its implementation is located; it must not create a competing SkillMD convention.

## Safety boundaries

- No secrets in findings, logs, fixtures, or reports.
- No claim that a test, build, probe, or deployment ran unless it actually ran.
- No force-push, history rewrite, secret rotation, payment, production deploy, or destructive filesystem action without explicit task-specific authorization.
- Prefer isolated branches and small diffs.
- Every write must identify its target, reason, scope, and rollback path.
- Treat external agent output as a claim until corroborated by repository or runtime evidence.

## First mission

Supervise `passive_income_swarm` as a real project: verify the uncommitted capability-connection work, review payment authorization and secret exposure, establish repeatable checks, and produce a truthful operator handoff. Do not claim live revenue or device deployment without direct evidence.

## License

To be selected by the repository owner before public reuse or distribution.


## Prototype

The slash-command input prototype is at [web/index.html](web/index.html). It loads the command registry from `interface/slash-commands.json` and demonstrates filtering, keyboard/touch selection, and command insertion. It intentionally has no execution backend yet.

To preview locally, serve the repository root over HTTP and open `/web/` (for example, with any static file server). Opening the HTML directly as a `file://` URL may prevent the browser from loading the JSON registry.

## Initial build sequence

1. Lock down the evidence and finding contract.
2. Connect GitHub read-only reconnaissance and diff review.
3. Add local Git and CI adapters.
4. Add an authenticated event bridge for coding-agent sessions.
5. Add bounded operator actions and audit records.
6. Integrate the established Scout/Spark Scout/Oracle governance format after its canonical implementation is identified.
