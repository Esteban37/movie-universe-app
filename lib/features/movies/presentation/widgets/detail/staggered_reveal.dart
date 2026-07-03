import 'package:flutter/material.dart';

/// Keeps content fully visible from first paint. A scroll-tied staggered
/// reveal was intentionally dropped: it hid below-the-fold content until the
/// user scrolled, which conflicts with the explicit requirement that the
/// movie information be visible immediately without scrolling.
class StaggeredReveal extends StatelessWidget {
  const StaggeredReveal({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Opacity(opacity: 1, child: child);
  }
}
