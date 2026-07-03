## ADDED Requirements

### Requirement: Skeleton loader widget
The project SHALL provide a reusable skeleton shimmer loader with multiple layout variants.

#### Scenario: Skeleton matches card layout
- **WHEN** the `SkeletonVariant.card` is used
- **THEN** the skeleton SHALL display a poster-shaped rectangle (2:3 aspect ratio) with two text lines below
- **AND** SHALL animate with a shimmer sweep from left to right

#### Scenario: Skeleton matches detail layout
- **WHEN** the `SkeletonVariant.detail` is used
- **THEN** the skeleton SHALL display a wide backdrop rectangle (16:9), a poster thumbnail shape, and three metadata text lines
- **AND** SHALL animate with a shimmer sweep

#### Scenario: Skeleton matches text layout
- **WHEN** the `SkeletonVariant.text` is used
- **THEN** the skeleton SHALL display 3-4 paragraph-shaped rectangles of varying widths
- **AND** SHALL animate with a shimmer sweep

### Requirement: Content state wrapper widget
The project SHALL provide a reusable content state widget that wraps AsyncValue state (loading/error/data) with standard UI treatment.

#### Scenario: ContentState shows skeleton on loading
- **WHEN** the async value is in loading state
- **THEN** the ContentState SHALL display a skeleton loader

#### Scenario: ContentState shows error with retry
- **WHEN** the async value is in error state
- **THEN** the ContentState SHALL display an error message with a retry button

#### Scenario: ContentState shows empty state
- **WHEN** the async value contains an empty list
- **THEN** the ContentState SHALL display an empty state message

#### Scenario: ContentState renders data
- **WHEN** the async value contains data
- **THEN** the ContentState SHALL render the provided data widget
