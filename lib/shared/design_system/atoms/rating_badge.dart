import 'package:flutter/material.dart';

class RatingBadge extends StatelessWidget {
  const RatingBadge({
    super.key,
    required this.rating,
    this.iconSize = 16,
    this.textStyle,
  });

  final double rating;
  final double iconSize;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, size: iconSize, color: theme.colorScheme.tertiary),
        SizedBox(width: iconSize / 4),
        Text(
          rating.toStringAsFixed(1),
          style: textStyle ?? theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}
