import 'package:flutter/material.dart';

class GenreChip extends StatelessWidget {
  const GenreChip({
    super.key,
    required this.label,
    this.labelStyle,
  });

  final String label;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: labelStyle ?? Theme.of(context).textTheme.bodyMedium,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}
