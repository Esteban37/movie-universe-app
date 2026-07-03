# AI Usage

## Summary

> **Approach:** **Spec-driven** development with **OpenSpec** and **SDD**: I defined architecture, per-change scope, and acceptance criteria in specs and `tasks.md`; AI accelerated implementation, tests, and docs **within that contract**. Each delivery was reviewed before merge (task-aligned diff, analyze, automated tests, layer tests, UX). Details below: tools, models, Git/PR traceability, and checklist.

---

## Spec-Driven Development (SDD)

**SDD (Spec-Driven Development)** is the methodology for building software with AI: define **versioned specifications before implementation**, so models work against bounded requirements instead of open-ended prompts.

**Why OpenSpec?** OpenSpec was chosen as the SDD toolchain to **use its full change lifecycle** — `proposal`, `design`, `tasks`, delta specs, validation, and archive into baseline capabilities — not ad-hoc prompts. That structure gives AI a **fixed contract per change** and gives the author a **repeatable way to compare tools and models** on the same spec, tasks, and acceptance criteria.

In this project:

| Concept | Role |
|---------|------|
| **SDD** | Overarching practice — specs drive what gets built and how changes are reviewed |
| **OpenSpec** | SDD tooling — structured changes, task checklists, versioned specs, archive/sync |
| **Model evaluation** | Same OpenSpec change + same verification gate; different tools/models across phases (see below) |
| **AGENTS.md** | Guardrails so AI and humans stay aligned with architecture and quality bars |

SDD answers *“what are we building and how do we know it’s done?”*  
[`runtime-design.md`](runtime-design.md) and [`architecture.md`](architecture.md) document *how the running app is structured* — complementary, not the same as SDD.

---

## Methodology layers

| Layer | Purpose | Artifacts |
|-------|---------|-----------|
| **SDD (OpenSpec)** | *What to build* per incremental change | `openspec/changes/<name>/` → archive → `openspec/specs/` |
| **Architecture docs** | *How the codebase is organized* | [`architecture.md`](architecture.md) |
| **Runtime design** | *How the app behaves at runtime* | [`runtime-design.md`](runtime-design.md) |
| **AGENTS.md** | Engineering guardrails for AI-assisted development | Layer rules, provider wiring, visual preservation |

OpenSpec specs and tasks define each change; Git records **when a change was accepted** into `main` after human verification.

---

## OpenSpec workflow

```text
/opsx:explore   →  think / discover scope (optional)
/opsx:propose   →  create proposal + design + tasks + delta specs
/opsx:apply     →  implement tasks in code (AI-assisted)
     ↓
Manual verification gate (see checklist below)
     ↓
Git: commit(s) on feat/<change-name>/ → PR → main
     ↓
/opsx:archive   →  archive change + sync baseline specs
```

See also: [`openspec.md`](openspec.md).

---

## Git strategy

### Principles

- **One OpenSpec change ≈ one feature branch ≈ one PR** (when possible).
- **Integration branch:** `main` — reviewed work merges here via PRs.
- **Conventional commits:** `feat(scope):`, `refactor(scope):`, `test(scope):`, etc., scoped to the change.
- **Human merge gate:** AI output is treated as a *proposal* until analyze, tests, and review pass.
- **Documentation** may land in a separate PR to keep code reviews focused (e.g. docs + versioned OpenSpec).

### End-to-end flow

```text
OpenSpec change          Git                         Acceptance
─────────────────────────────────────────────────────────────────
openspec/changes/X/   →   feat/X/                  →  manual checklist
tasks.md + specs          commits + PR #N             merge to main
                       →   /opsx:archive               openspec/changes/archive/
```

---

## OpenSpec changes ↔ branches ↔ PRs

### Phase 1 — Foundation (OpenCode, cost-effective model for scaffolding)

Goal: establish project skeleton, features, and tests with clear specs before heavier refactors.

| # | OpenSpec change | Branch | PR |
|---|-----------------|--------|-----|
| 1 | `init-project` | `feat/init-project` | #1 |
| 2 | `core-infrastructure` | `feat/core-infrastructure` | #2 |
| 3 | `movies-data-layer` | `feat/movies-data-layer` | #4 *(#3 closed — superseded)* |
| 4 | `app-navigation` | `feat/app-navigation` | #5 |
| 5 | `movies-ui` | `feat/movies-ui` | #6 |
| 6 | `movie-search` | `feat/movie-search` | #7 |
| 7 | `testing-setup` | `feat/testing-setup` | #9 |

*Tooling: OpenCode with OpenCode Zen (free-tier friendly model) to implement against specs, then refine manually.*

**Context augmentation (Phase 1):** OpenCode was configured with **Context7 MCP** (up-to-date Flutter/Dart library docs) and **official Flutter and Dart skills** to ground the model during spec drafting and scaffolding — fewer API hallucinations, better alignment with current framework APIs. I selected and wired these integrations; output still passed the same verification gate.

**Out-of-spec fix (same period):** `fix/app-runtime-config` → PR #7 — runtime config correction outside an OpenSpec change.

### Phase 2 — Premium UI & architecture (Cursor, stronger models)

Goal: premium immersive UI, Clean Architecture hardening, and cross-feature decoupling.

| # | OpenSpec change | Branch | PR |
|---|-----------------|--------|-----|
| 8 | `premium-ui-redesign` | `feat/premium-ui-redesign` | #10 |
| 9 | `architecture-hardening` | `feat/architecture-hardening` | #11, #12 |
| 10 | `media-universe-expansion` | `feat/media-universe-expansion` | #13 |

*Tooling: Cursor with Claude Opus (architecture/design refinement) and Composer (fast code execution).*

PR #11 and #12 both target `architecture-hardening` — second iteration after review and additional hardening (layer tests, design-system decoupling, dependency validation).

### Phase 3 — Post-expansion hardening (no archived OpenSpec change)

Incremental improvements after the initial delivery scope; same Git discipline (branch → review → PR).

| Focus | Branch | PR |
|-------|--------|-----|
| Per-environment app icon & display name | `feat/app-environment-branding` | #14 |
| TV/search test coverage & widget isolation | `feat/test-suite-hardening` | #16 *(#15 closed — superseded)* |
| Shared domain, CI, integration tests | `feat/scalable-shared-foundations` | #17 |

---

## Tools and models

OpenSpec made **cross-model comparison fair**: each phase used the same artifacts (`tasks.md`, delta specs, `AGENTS.md`) and the same manual verification gate; only the tool/model varied.

| Phase | Tool | Model strategy | Context / skills | Typical use |
|-------|------|----------------|------------------|-------------|
| Foundation | **OpenCode** | OpenCode Zen (free tier) | Context7 MCP + official Flutter/Dart skills | Scaffolding from OpenSpec tasks: DTOs, layers, initial tests |
| Refinement | **Cursor** | Opus-class (architecture) | Project specs, `AGENTS.md`, codebase | Design review, refactors, audit recommendations |
| Refinement | **Cursor** | Composer (execution) | Same as above | Applying tasks, tests, iterative fixes |

**Evaluation intent:** Phase 1 tested whether a **cost-effective model** could deliver solid scaffolding when specs and tasks are explicit. Phase 2 tested whether **stronger models** improved architecture fidelity, premium UI preservation, and cross-feature refactors — still bounded by OpenSpec tasks and tests.

Models were chosen deliberately: **lower cost for bounded scaffolding**, **stronger models for architecture and UI fidelity**. All outputs were reviewed regardless of model; merges reflect what passed the gate, not which model produced the first draft.

---

## Manual verification gate (per change)

Before merging a `feat/*` branch into `main`:

| Step | Action |
|------|--------|
| 1 | Compare diff to OpenSpec `tasks.md` — scope complete? |
| 2 | `dart analyze --fatal-warnings` |
| 3 | `flutter test` |
| 4 | `flutter test test/architecture/` (from architecture-hardening onward) |
| 5 | `dart run dependency_validator` (from hardening / CI onward) |
| 6 | `flutter test integration_test` (when shell/navigation touched) |
| 7 | Manual smoke test on emulator (navigation, scroll, detail) |
| 8 | **Author decision:** merge, request AI correction, or hand-edit |

Phase-specific emphasis:

- **Foundation (1–7):** analyze + unit/widget tests.
- **Premium / architecture (8–9):** preserve immersive UI; layer-boundary tests must pass.
- **Expansion + hardening (10–15):** regression on movies; TV/search flows covered.

This checklist can be further automated in CI; merges still require human judgment on scope and UX.

---

## Human-owned (not delegated to AI)

- **Architecture and design direction** — Clean Architecture feature-first, layer rules, cross-feature boundaries, shared abstractions (`MediaItem`, `PaginatedMediaNotifier`, immersive templates), and scalability approach; defined and refined by the author against current industry practice
- **Design patterns and engineering standards** — Repository + use cases, Riverpod wiring, design system structure, typed errors, test strategy, CI gates
- Scope and acceptance criteria
- Visual / UX decisions (`premium-ui-redesign` as source of truth)
- Rejecting changes that break layer rules, architecture intent, or tests
- Squash/reword commits and PR descriptions
- Merge approval into `main`
- OpenSpec archive and baseline spec sync

AI may suggest patterns or implementations; **architectural choices and refinements remained author-led**.

---

## What AI was used for

| Area | AI assistance |
|------|-----------------|
| OpenSpec drafts | Proposals, designs, task lists, delta specs |
| Implementation | Code from `/opsx:apply` against tasks |
| Boilerplate | Freezed entities, DTO mappers, provider wiring |
| Tests | Fixtures, widget tests, architecture test ideas |
| Documentation | Draft README and `docs/` — edited by author |
| Audits | Cross-feature imports, design-system decoupling suggestions |

**Validation:** every merged PR was checked with static analysis and the automated test suite (~213 tests on `main`).

---

## Related documents

| Document | Contents |
|----------|----------|
| [README.md](../README.md) | Project summary and short AI usage pointer |
| [openspec.md](openspec.md) | OpenSpec layout and CLI workflow |
| [architecture.md](architecture.md) | Clean Architecture structure |
| [runtime-design.md](runtime-design.md) | API, networking, state, errors |
| [testing-strategy.md](testing-strategy.md) | Tests and CI |
| [AGENTS.md](../AGENTS.md) | Engineering guardrails |
