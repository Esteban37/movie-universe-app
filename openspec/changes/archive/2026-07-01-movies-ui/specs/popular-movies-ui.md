## ADDED Requirements

### Requirement: Popular movies provider
An AsyncNotifierProvider SHALL manage popular movies state with pagination.

#### Scenario: Provider loads first page on initialization
- **WHEN** the popular movies provider is created
- **THEN** it SHALL load page 1 of popular movies and emit loading then data state

#### Scenario: Provider loads next page on demand
- **WHEN** loadNextPage is called
- **AND** there are more pages available
- **THEN** the provider SHALL load the next page and append results to the existing list

#### Scenario: Provider prevents duplicate page loads
- **WHEN** a page is already being loaded
- **THEN** loadNextPage SHALL be a no-op

### Requirement: Popular movies screen
A screen SHALL display popular movies in a responsive grid with infinite scroll.

#### Scenario: Screen shows loading indicator initially
- **WHEN** popular movies are being fetched
- **THEN** the screen SHALL show the LoadingView

#### Scenario: Screen shows movie grid
- **WHEN** popular movies are loaded
- **THEN** the screen SHALL display a grid of MovieCard widgets
- **AND** support infinite scroll to load more pages

#### Scenario: Screen shows error with retry
- **WHEN** popular movies fail to load
- **THEN** the screen SHALL show the ErrorView with retry callback

#### Scenario: Screen shows empty state
- **WHEN** popular movies list is empty
- **THEN** the screen SHALL show the EmptyView
