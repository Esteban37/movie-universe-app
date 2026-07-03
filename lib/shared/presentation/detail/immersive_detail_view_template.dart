import 'package:flutter/material.dart';

import '../../../core/media/tmdb_image.dart';
import '../../widgets/floating_detail_app_bar.dart';
import 'immersive_detail_constants.dart';

/// Layout values shared with header and content builders during scroll.
class ImmersiveDetailLayout {
  const ImmersiveDetailLayout({
    required this.headerHeight,
    required this.collapseProgress,
    required this.reducedMotion,
    required this.isTablet,
    required this.backdropUrl,
    required this.posterPath,
    required this.imageUrls,
  });

  final double headerHeight;
  final double collapseProgress;
  final bool reducedMotion;
  final bool isTablet;
  final String? backdropUrl;
  final String posterPath;
  final TmdbImageUrl imageUrls;
}

typedef ImmersiveDetailSliversBuilder = List<Widget> Function(
  BuildContext context,
  ImmersiveDetailLayout layout,
);

/// Shared immersive detail scaffold: collapsing header scroll, parallax backdrop,
/// swipe-to-dismiss, and floating app bar. Feature screens supply slivers via
/// [sliversBuilder] so movie/TV-specific header and content stay in their modules.
class ImmersiveDetailViewTemplate extends StatefulWidget {
  const ImmersiveDetailViewTemplate({
    super.key,
    required this.backdropPath,
    required this.posterPath,
    required this.imageUrls,
    required this.title,
    required this.sliversBuilder,
  });

  final String? backdropPath;
  final String posterPath;
  final TmdbImageUrl imageUrls;
  final String title;
  final ImmersiveDetailSliversBuilder sliversBuilder;

  @override
  State<ImmersiveDetailViewTemplate> createState() =>
      _ImmersiveDetailViewTemplateState();
}

class _ImmersiveDetailViewTemplateState extends State<ImmersiveDetailViewTemplate>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<double> _collapseProgress = ValueNotifier(0.0);

  late AnimationController _dismissController;
  double _dismissProgress = 0;
  bool _isDismissing = false;
  bool _reducedMotion = false;

  double get _headerHeight {
    final width = MediaQuery.of(context).size.width;
    return width < ImmersiveDetailConstants.phoneBreakpoint
        ? ImmersiveDetailConstants.phoneHeaderHeight
        : ImmersiveDetailConstants.tabletHeaderHeight;
  }

  @override
  void initState() {
    super.initState();
    _dismissController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(_onDismissAnimate);
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reducedMotion = MediaQuery.of(context).disableAnimations;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _collapseProgress.dispose();
    _dismissController.removeListener(_onDismissAnimate);
    _dismissController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final scrollRange = _headerHeight;
    if (scrollRange <= 0) return;
    final progress = (_scrollController.offset / scrollRange).clamp(0.0, 1.0);
    _collapseProgress.value = progress;
  }

  void _onDismissAnimate() {
    setState(() {
      _dismissProgress = _dismissController.value;
    });
  }

  void _onDismissDragUpdate(DragUpdateDetails details) {
    if (_scrollController.offset > 0) return;
    if (details.delta.dy <= 0) return;

    setState(() {
      _isDismissing = true;
      _dismissProgress = (_dismissProgress + (details.delta.dy / 400)).clamp(
        0.0,
        1.0,
      );
    });
  }

  void _onDismissDragEnd(DragEndDetails details) {
    if (!_isDismissing) return;

    if (_dismissProgress >= 0.3) {
      _isDismissing = false;
      _dismissController.value = _dismissProgress;
      _dismissController
          .animateTo(
            1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInCubic,
          )
          .then((_) {
            if (mounted) Navigator.of(context).pop();
          });
    } else {
      _isDismissing = false;
      _dismissController.value = _dismissProgress;
      _dismissController
          .animateTo(
            0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          )
          .then((_) {
            if (mounted) setState(() {});
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageUrls = widget.imageUrls;
    final backdropUrl = imageUrls.backdrop(widget.backdropPath);
    final theme = Theme.of(context);
    final isTablet =
        MediaQuery.of(context).size.width >=
        ImmersiveDetailConstants.phoneBreakpoint;

    final dismissScale = 1.0 - (_dismissProgress * 0.08);
    final dismissTranslate = _dismissProgress * 200;
    final dismissRadius = _dismissProgress * 20;

    return Semantics(
      explicitChildNodes: true,
      child: ValueListenableBuilder<double>(
        valueListenable: _collapseProgress,
        builder: (context, collapseProgress, _) {
          final layout = ImmersiveDetailLayout(
            headerHeight: _headerHeight,
            collapseProgress: collapseProgress,
            reducedMotion: _reducedMotion,
            isTablet: isTablet,
            backdropUrl: backdropUrl,
            posterPath: widget.posterPath,
            imageUrls: imageUrls,
          );

          return Stack(
            children: [
              Positioned.fill(
                child: ColoredBox(
                  color: theme.scaffoldBackgroundColor.withValues(
                    alpha: 1 - _dismissProgress,
                  ),
                ),
              ),
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.diagonal3Values(
                  dismissScale,
                  dismissScale,
                  1.0,
                )..setTranslationRaw(0.0, dismissTranslate, 0.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(dismissRadius),
                    boxShadow: _dismissProgress > 0
                        ? [
                            BoxShadow(
                              color: theme.colorScheme.shadow.withValues(
                                alpha: 0.4 * _dismissProgress,
                              ),
                              blurRadius: 30,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(dismissRadius),
                    child: Scaffold(
                      backgroundColor: theme.scaffoldBackgroundColor,
                      body: Stack(
                        children: [
                          RepaintBoundary(
                            child: Listener(
                              onPointerMove: (event) {
                                _onDismissDragUpdate(
                                  DragUpdateDetails(
                                    globalPosition: event.position,
                                    delta: event.delta,
                                  ),
                                );
                              },
                              onPointerUp: (_) {
                                if (_isDismissing) {
                                  _onDismissDragEnd(DragEndDetails());
                                }
                              },
                              onPointerCancel: (_) {
                                if (_isDismissing) {
                                  _onDismissDragEnd(DragEndDetails());
                                }
                              },
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onVerticalDragUpdate: _onDismissDragUpdate,
                                onVerticalDragEnd: _onDismissDragEnd,
                                child: CustomScrollView(
                                  controller: _scrollController,
                                  physics: _dismissProgress > 0
                                      ? const NeverScrollableScrollPhysics()
                                      : const BouncingScrollPhysics(
                                          parent:
                                              AlwaysScrollableScrollPhysics(),
                                        ),
                                  slivers: widget.sliversBuilder(context, layout),
                                ),
                              ),
                            ),
                          ),
                          FloatingDetailAppBar(
                            backdropPath: widget.backdropPath,
                            imageUrls: imageUrls,
                            title: widget.title,
                            collapseProgress: collapseProgress,
                            onBack: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
