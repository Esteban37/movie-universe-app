## Purpose

Legacy movie-only search specification. **Active search behavior is defined in `unified-search/spec.md`.** This document is retained for historical reference to the original movie search implementation.

## Requirements

> **Note:** Requirements below describe the pre-expansion movie-only search. See `openspec/specs/unified-search/spec.md` for the current unified multi-media search contract.

### Requirement: Search repository contract (legacy)
An abstract SearchRepository previously defined movie-only search via `searchMovies`.

### Requirement: SearchMovies use case (legacy)
A `SearchMovies` use case previously invoked movie-only repository search.

### Requirement: Movie search endpoint (legacy)
Search previously called TMDB `/search/movie`.

### Requirement: Search result mapping (legacy)
Search results were previously mapped to `List<MovieEntity>`.

## Superseded by

- `unified-search/spec.md` — multi-media search with `MediaItem` results
- `pagination/spec.md` — search infinite scroll and filter-aware pagination
