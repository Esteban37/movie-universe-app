## ADDED Requirements

### Requirement: Top rated movies provider
An AsyncNotifierProvider SHALL manage top-rated movies state with pagination.

#### Scenario: Provider loads first page on initialization
- **WHEN** the top-rated movies provider is created
- **THEN** it SHALL load page 1 of top-rated movies and emit loading then data state

#### Scenario: Provider loads next page on demand
- **WHEN** loadNextPage is called
- **AND** there are more pages available
- **THEN** the provider SHALL load the next page and append results

### Requirement: Top rated movies screen
A screen SHALL display top-rated movies in a responsive grid with infinite scroll.

#### Scenario: Screen shows loading state
- **WHEN** top-rated movies are being fetched
- **THEN** the screen SHALL show the LoadingView

#### Scenario: Screen shows movie grid
- **WHEN** top-rated movies are loaded
- **THEN** the screen SHALL display a grid of MovieCard widgets with infinite scroll

#### Scenario: Screen handles errors
- **WHEN** top-rated movies fail to load
- **THEN** the screen SHALL show the ErrorView with retry
