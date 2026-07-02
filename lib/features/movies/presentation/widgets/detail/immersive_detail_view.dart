import 'package:flutter/material.dart';

import '../../../../../core/media/tmdb_image.dart';
import '../../../domain/entities/movie_detail_entity.dart';
import 'detail_content.dart';
import 'detail_header_delegate.dart';
import 'floating_detail_app_bar.dart';
import 'immersive_detail_constants.dart';

class ImmersiveDetailView extends StatefulWidget {
  const ImmersiveDetailView({
    super.key,
    required this.details,
    required this.imageUrls,
  });

  final MovieDetailEntity details;
  final TmdbImageUrl imageUrls;

  @override
  State<ImmersiveDetailView> createState() => _ImmersiveDetailViewState();
}

class _ImmersiveDetailViewState extends State<ImmersiveDetailView>
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
    final details = widget.details;
    final imageUrls = widget.imageUrls;
    final backdropUrl = imageUrls.backdrop(details.backdropPath);
    final posterPath = details.posterPath;
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
          return Stack(
            children: [
              // Own background fades out during dismiss so the non-opaque
              // route below (the movie list) shows through the gaps left by
              // the shrinking card.
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
                                  slivers: [
                                    SliverPersistentHeader(
                                      delegate: DetailHeaderDelegate(
                                        backdropUrl: backdropUrl,
                                        posterPath: posterPath,
                                        imageUrls: imageUrls,
                                        title: details.title,
                                        voteAverage: details.voteAverage,
                                        releaseDate: details.releaseDate,
                                        runtime: details.runtime,
                                        headerHeight: _headerHeight,
                                        collapseProgress: collapseProgress,
                                        reducedMotion: _reducedMotion,
                                        isTablet: isTablet,
                                      ),
                                    ),
                                    SliverToBoxAdapter(
                                      child: DetailContent(
                                        details: details,
                                        posterPath: posterPath,
                                        imageUrls: imageUrls,
                                        collapseProgress: collapseProgress,
                                        isTablet: isTablet,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          FloatingDetailAppBar(
                            backdropPath: details.backdropPath,
                            imageUrls: imageUrls,
                            title: details.title,
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
