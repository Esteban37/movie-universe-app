## Purpose

Extend infinite-scroll pagination to search results so users can browse beyond the first page of multi search results.

## ADDED Requirements

### Requirement: Paginated search notifier
Search state SHALL be managed by a paginated notifier that supports append-on-scroll.

#### Scenario: Initial search loads page 1
- **WHEN** a debounced query is submitted
- **THEN** the notifier SHALL fetch page 1 and replace prior results

#### Scenario: Scroll loads next page
- **WHEN** the user scrolls to the bottom of search results
- **AND** `currentPage < totalPages`
- **THEN** the notifier SHALL fetch the next page and append items

#### Scenario: Loading indicator during pagination
- **WHEN** a subsequent page is loading
- **THEN** the search list SHALL show a bottom loading indicator
- **AND** existing results SHALL remain visible

#### Scenario: No more pages
- **WHEN** the user reaches the bottom
- **AND** `currentPage >= totalPages`
- **THEN** the notifier SHALL NOT request additional pages

#### Scenario: Prevent duplicate page loads
- **WHEN** a page request is already in progress
- **THEN** the notifier SHALL NOT trigger additional page requests

### Requirement: Query change resets pagination
Changing the search query SHALL reset pagination state.

#### Scenario: New query resets pages
- **WHEN** the debounced query changes
- **THEN** the notifier SHALL reset to page 1
- **AND** clear previously loaded results before showing new page 1 data

### Requirement: Filter does not reset pagination
Changing the type filter chip SHALL NOT re-fetch from the API.

#### Scenario: Filter applies to loaded items
- **WHEN** the user switches between All, Movies, and Series
- **THEN** the UI SHALL filter the in-memory result list
- **AND** SHALL NOT call the search endpoint solely because the filter changed

### Requirement: Pagination with active filter
When a filter is active, load-more SHALL continue fetching unfiltered pages from the API.

#### Scenario: Load more under Movies filter
- **WHEN** Movies filter is active and the user scrolls to load more
- **THEN** the notifier SHALL fetch the next API page
- **AND** the UI SHALL append only movie items from that page to the filtered view

### Requirement: Search provider uses use case
The paginated search notifier SHALL call `SearchMedia`, not the repository directly.

#### Scenario: Provider reads use case
- **WHEN** the search notifier fetches any page
- **THEN** it SHALL invoke `SearchMedia` via its use-case provider
