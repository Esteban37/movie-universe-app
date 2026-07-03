## Context

Presentation layer for movie browsing: popular movies, top-rated movies, and movie details screens using Riverpod state management and responsive Flutter UI.

## Goals / Non-Goals

**Goals:**
- AsyncNotifier providers for popular movies, top-rated movies, movie details
- MovieListScreen with TabBar (Popular, Top Rated) and TabBarView
- MovieDetailScreen with backdrop, poster, title, rating, genres, overview
- MovieCard widget with poster, title, rating
- Infinite scroll: detect scroll-to-bottom, load next page, append results
- Loading/error/empty states for all screens
- Responsive: single-column phone, multi-column tablet

**Non-Goals:**
- No navigation wiring (separate change)
- No search UI (separate change)

## Decisions

### 1. Provider Design
- **Choice**: `AsyncNotifierProvider` with `AsyncValue<List<MovieEntity>>`
- **Rationale**: Built-in loading/error/data states. Provider manages page counter and accumulated list.

### 2. Infinite Scroll
- **Choice**: ScrollController listener on scroll position, trigger load when near bottom
- **Rationale**: Simple, no additional dependency. ScrollController is disposed with the widget.
- **Guard**: Skip load if already loading or no more pages.

### 3. Movie List Layout
- **Choice**: Single `GridView` for phone (2 columns), `GridView` for tablet (4+ columns)
- **Rationale**: `LayoutBuilder` + `MediaQuery` for breakpoint detection.

## Risks / Trade-offs

- [Risk] ScrollController listener may fire multiple times → Mitigation: debounce flag (`_isLoading`)
- [Trade-off] TabBarView with two paginated lists means both load on first render
