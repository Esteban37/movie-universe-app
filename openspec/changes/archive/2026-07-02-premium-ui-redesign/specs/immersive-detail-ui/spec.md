## ADDED Requirements

### Requirement: Collapsing header with parallax backdrop
The system SHALL display a collapsing hero header with a parallax movie backdrop image at the top of the detail screen.

#### Scenario: Header displays backdrop at full height
- **WHEN** the detail screen is first opened
- **THEN** the header SHALL display the movie backdrop image at full height (300dp on phone, 420dp on tablet)
- **AND** the backdrop SHALL have a subtle parallax scale (1.05x) at scroll position 0

#### Scenario: Header collapses on scroll
- **WHEN** the user scrolls down
- **THEN** the header SHALL progressively collapse from maxExtent to 0
- **AND** the backdrop scale SHALL lerp from 1.05x to 1.0x as the user scrolls
- **AND** the backdrop opacity SHALL lerp from 1.0 to 0.0 by the time the header is fully collapsed

### Requirement: Dynamic gradient overlay
The system SHALL render a gradient overlay on the backdrop that blends the hero image into the content background for readability.

#### Scenario: Gradient blends backdrop into content
- **WHEN** the header is at full expansion
- **THEN** a gradient SHALL overlay the backdrop with increasing opacity toward the bottom
- **AND** the final gradient stop SHALL match the scaffold background color

#### Scenario: Gradient fades with header collapse
- **WHEN** the user scrolls down and the header collapses
- **THEN** the gradient opacity SHALL decrease proportionally
- **AND** SHALL reach fully transparent when the header is fully collapsed

### Requirement: Poster repositioning on scroll
The system SHALL display the movie poster that transitions from the hero header to the content area as the user scrolls.

#### Scenario: Poster appears in header at top
- **WHEN** the detail screen is at scroll position 0
- **THEN** a poster thumbnail SHALL appear positioned at the bottom-left of the header (120px wide, 8px radius)

#### Scenario: Poster transitions to content area
- **WHEN** the user scrolls and the header collapses
- **THEN** the header poster SHALL fade out
- **AND** a content-area poster SHALL fade in at the same relative position
- **AND** the poster width SHALL transition from 120px to 80px
- **AND** the poster corner radius SHALL transition from 8px to 4px

### Requirement: App bar opacity transition
The system SHALL transition the app bar background from transparent to opaque as the header collapses.

#### Scenario: App bar fades in on scroll
- **WHEN** the detail screen is at scroll position 0
- **THEN** the app bar background SHALL be fully transparent
- **WHEN** the header is fully collapsed
- **THEN** the app bar background SHALL be fully opaque
- **AND** the movie title SHALL appear in the app bar

### Requirement: Staggered content reveal
The system SHALL animate content elements into view with staggered timing as the header collapses.

#### Scenario: Content fades in progressively
- **WHEN** the user scrolls past 30% of the header collapse
- **THEN** the info row (poster + metadata) SHALL begin fading in
- **WHEN** the user scrolls past 50% of the header collapse
- **THEN** the genre chips SHALL begin fading in
- **WHEN** the user scrolls past 70% of the header collapse
- **THEN** the tagline and overview SHALL begin fading in

### Requirement: Gesture-driven dismiss
The system SHALL support an interactive dismiss gesture when the user overscrolls downward from the top of the detail screen.

#### Scenario: Dismiss gesture activates at top
- **WHEN** the user touches the screen at scroll position 0
- **AND** drags downward
- **THEN** the screen content SHALL scale down and translate downward following the finger
- **AND** the scaffold background SHALL become transparent to reveal the screen below

#### Scenario: Dismiss cancelled below threshold
- **WHEN** the user releases the drag
- **AND** the dismiss progress is below 0.3
- **THEN** the screen SHALL spring back to the full position with a 300ms easeOutCubic animation

#### Scenario: Dismiss completes above threshold
- **WHEN** the user releases the drag
- **AND** the dismiss progress is 0.3 or above
- **THEN** the screen SHALL animate to fully shrunk with a 200ms easeInCubic animation
- **AND** the system SHALL pop the navigation route

### Requirement: Skeleton loading state
The system SHALL display an animated skeleton shimmer placeholder while movie details are loading.

#### Scenario: Skeleton shows during loading
- **WHEN** movie details are being fetched
- **THEN** the system SHALL display a skeleton layout matching the final content shape
- **AND** the skeleton SHALL animate with a shimmer sweep effect at 1.5s intervals

#### Scenario: Skeleton transitions to content
- **WHEN** movie details finish loading
- **THEN** the skeleton SHALL fade out
- **AND** the content SHALL fade in
- **AND** the transition SHALL take 300ms

### Requirement: 60fps animation performance
All animations SHALL render at 60fps without jank.

#### Scenario: Hardware-accelerated transforms
- **WHEN** the user scrolls or performs dismiss gestures
- **THEN** all animated transformations SHALL use `Transform` widgets (GPU-composited)
- **AND** no animation SHALL use the `Opacity` widget in a way that creates per-frame saveLayers
- **AND** the scroll view SHALL be wrapped in a `RepaintBoundary`

### Requirement: Responsive layout variations
The detail screen SHALL adapt its layout to different screen sizes.

#### Scenario: Phone layout (width < 600dp)
- **WHEN** the screen width is less than 600dp
- **THEN** the layout SHALL be single-column with a backdrop height of 300dp

#### Scenario: Tablet layout (width >= 600dp)
- **WHEN** the screen width is 600dp or greater
- **THEN** the backdrop height SHALL be 420dp
- **AND** the content area SHALL use wider padding and larger typography

### Requirement: Accessibility support
The immersive detail screen SHALL remain accessible to screen readers and users with reduced motion preferences.

#### Scenario: Reduced motion respected
- **WHEN** the device has reduced motion enabled
- **THEN** the parallax, stagger, and shimmer animations SHALL be disabled
- **AND** content SHALL use cross-fade transitions only

#### Scenario: Screen reader labels
- **WHEN** a screen reader is active
- **THEN** the backdrop image SHALL have a semantic label describing the movie
- **AND** the poster SHALL have a semantic label
- **AND** all interactive elements (back button) SHALL have tooltips
