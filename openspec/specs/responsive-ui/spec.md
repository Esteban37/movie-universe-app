## Requirements

### Requirement: Responsive layout
The system SHALL adapt its layout to different screen sizes and orientations.

#### Scenario: Layout adapts to phone screen
- **WHEN** the app runs on a phone-sized screen
- **THEN** the system SHALL display a single-column layout

#### Scenario: Layout adapts to tablet screen
- **WHEN** the app runs on a tablet-sized screen
- **THEN** the system SHALL display a multi-column grid layout for movie lists

### Requirement: Dynamic text scaling
The system SHALL support system-level font size adjustments.

#### Scenario: System font size increased
- **WHEN** the device's system font size is increased
- **THEN** the app's text SHALL scale accordingly
- **AND** layouts SHALL remain usable without overflow

### Requirement: Semantic widgets
The system SHALL use semantic Flutter widgets for accessibility.

#### Scenario: Screen reader interaction
- **WHEN** a screen reader is active
- **THEN** all interactive elements SHALL have proper semantic labels
