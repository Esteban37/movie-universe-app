## Purpose

Application-wide theming configuration using Material 3.
## Requirements
### Requirement: Material 3 light theme
The project SHALL have a Material 3 light theme configuration.

#### Scenario: Theme is applied
- **WHEN** the app is rendered
- **THEN** Material 3 color scheme and typography SHALL be applied app-wide

### Requirement: Dark theme configuration
The system SHALL provide a dark theme using a cinematic color palette.

#### Scenario: Dark theme applied
- **WHEN** the app renders with dark theme active
- **THEN** the scaffold background SHALL be near-black (#0D0D0D)
- **AND** surface colors SHALL use dark variants (#1A1A1A for cards, #2A2A2A for elevated surfaces)
- **AND** primary actions SHALL use the brand primary color (#E50914)
- **AND** secondary elements SHALL use cosmic purple (#7367F0)
- **AND** tertiary indicators (ratings) SHALL use teal (#00BFA5)
- **AND** text SHALL use high-contrast light tones (#F0EFEC primary, #9E9E9E secondary)

### Requirement: Theme mode switching
The system SHALL allow switching between light and dark themes.

#### Scenario: Theme mode provider
- **WHEN** the app initializes
- **THEN** a Riverpod StateProvider<ThemeMode> SHALL manage the current theme mode
- **AND** the default SHALL be dark theme

#### Scenario: Theme persists across screens
- **WHEN** the user navigates between screens
- **THEN** the selected theme mode SHALL remain active
- **AND** all screens SHALL respond to the theme change immediately

### Requirement: Theme-aware gradient overlays
The detail screen gradient overlay SHALL adapt to the active theme.

#### Scenario: Dark theme gradient
- **WHEN** dark theme is active
- **THEN** the backdrop gradient SHALL blend into the dark scaffold background (#0D0D0D)

#### Scenario: Light theme gradient
- **WHEN** light theme is active
- **THEN** the backdrop gradient SHALL blend into the light scaffold background (#FAFAF8)

### Requirement: Shared typography across themes
The typography system SHALL remain identical across light and dark themes.

#### Scenario: Typography unchanged on theme switch
- **WHEN** the user switches between light and dark themes
- **THEN** all font sizes, weights, line heights, and letter spacing SHALL remain unchanged
- **AND** only color values SHALL change

### Requirement: Widget colors sourced from theme tokens
All widget colors SHALL be derived from the active `ThemeData` / `ColorScheme` tokens. Hardcoded color literals SHALL NOT be used in widgets, except semantically-neutral values (e.g., `Colors.transparent` for gradient endpoints).

#### Scenario: Rating indicator uses a theme token
- **WHEN** a rating star icon is rendered on a movie card or search result
- **THEN** its color SHALL come from `colorScheme.tertiary`
- **AND** it SHALL NOT use a hardcoded literal such as `Colors.amber`

#### Scenario: No hardcoded brand colors in widgets
- **WHEN** any widget needs a color
- **THEN** it SHALL read the value from `Theme.of(context)` tokens
- **AND** the same visual result SHALL apply automatically under light and dark themes

