import 'package:flutter/material.dart';

/// Compact status label for detail screens (e.g. TV series status).
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.labelStyle,
  });

  final String label;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Chip(
      label: Text(
        label,
        style: labelStyle ??
            theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
      ),
      backgroundColor: colorScheme.surfaceContainerHighest,
      side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.4)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}
