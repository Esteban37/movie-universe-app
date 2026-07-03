## ADDED Requirements

### Requirement: Loading state widget
The project SHALL provide a reusable loading indicator widget.

#### Scenario: LoadingView displays CircularProgressIndicator
- **WHEN** a screen is in loading state
- **THEN** the system SHALL display a centered CircularProgressIndicator

### Requirement: Error state widget
The project SHALL provide a reusable error view widget with retry action.

#### Scenario: ErrorView displays error message and retry button
- **WHEN** a screen is in error state
- **THEN** the system SHALL display the error message and a "Retry" button
- **AND** tapping retry SHALL trigger the provided callback

### Requirement: Empty state widget
The project SHALL provide a reusable empty state widget.

#### Scenario: EmptyView displays custom message
- **WHEN** a screen has no data to display
- **THEN** the system SHALL display a centered message indicating no content
