import 'package:flutter/material.dart';

import '../../../core/theme/theme_mode_toggle_button.dart';

/// Shared top app bar for Movies, Series, and Search shell tabs.
class PrimaryTabAppBar {
  PrimaryTabAppBar._();

  static const toolbarHeight = kToolbarHeight;

  static AppBar build({required String title, PreferredSizeWidget? bottom}) {
    return AppBar(
      toolbarHeight: toolbarHeight,
      title: Text(title),
      actions: const [ThemeModeToggleButton()],
      bottom: bottom,
    );
  }
}

/// Bottom bar slot aligned to default [TabBar] height in list tabs.
class PrimaryTabAppBarBottom extends StatelessWidget
    implements PreferredSizeWidget {
  const PrimaryTabAppBarBottom({super.key, required this.child});

  static const height = kTextTabBarHeight;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, child: child);
  }

  @override
  Size get preferredSize => const Size.fromHeight(height);
}
