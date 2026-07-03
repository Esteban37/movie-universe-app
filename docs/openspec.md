# OpenSpec

**OpenSpec** is the spec-driven development (SDD) tooling used in this project. It tracks capabilities and change proposals; it does **not** affect runtime behavior.

SDD + OpenSpec were used to keep AI work **spec-bound** (proposal → design → tasks → specs) and to **evaluate different models and tools** against the same change artifacts and verification checklist. Details: [ai-usage.md](ai-usage.md).

---

## Layout

| Path | Purpose |
|------|---------|
| `openspec/specs/` | Baseline capabilities (28 specs: movies, tv-shows, unified-search, architecture, testing, …) |
| `openspec/changes/archive/` | Completed change deltas (e.g. `architecture-hardening`, `media-universe-expansion`) |
| `openspec/config.yaml` | Project context for OpenSpec CLI / AI tooling |
| `openspec/changes/<name>/` | Active change (none currently) |

---

## Workflow

1. Create a change folder under `openspec/changes/<change-name>/` (proposal, design, tasks, delta specs).
2. Implement in code; keep `tasks.md` checkboxes updated.
3. Sync deltas to main specs (`/opsx-sync` or manual merge).
4. Run `openspec validate <change> --strict` before closing the change.
5. Archive to `openspec/changes/archive/` (`/opsx-archive`).

See [ai-usage.md](ai-usage.md) for how **SDD (Spec-Driven Development)** and OpenSpec fit the AI-assisted workflow, including spec ↔ branch ↔ PR traceability and the human verification gate.

Engineering guardrails: [AGENTS.md](../AGENTS.md).

---

## CI

`.github/workflows/ci.yml` runs `openspec doctor` when the CLI and `openspec/specs/` are present (non-blocking).

---

## Key specs (by area)

| Spec | Topic |
|------|-------|
| `architecture/spec.md` | Layer boundaries, use-case wiring |
| `shared-media-domain/spec.md` | `MediaItem`, `MediaType`, `MediaReference` in `shared/domain` |
| `unified-search/spec.md` | Multi search, `SearchMedia`, filter chips |
| `pagination/spec.md` | Infinite scroll, `PaginatedMediaNotifier` |
| `design-system/spec.md` | Atomic design, premium UI preservation |
| `testing/spec.md` | Unit/widget/integration coverage, CI |

Legacy movie-only search: `movie-search/spec.md` (superseded by `unified-search`).
