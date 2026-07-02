import 'package:flutter/material.dart';

enum SkeletonVariant { card, detail, text }

/// Layout constants aligned with the movie detail screen hero header.
const _detailPhoneHeaderHeight = 300.0;
const _detailTabletHeaderHeight = 420.0;
const _detailPhoneBreakpoint = 600.0;
const _detailPosterWidth = 120.0;
const _detailPosterHeight = 180.0;

class SkeletonLoader extends StatefulWidget {
  const SkeletonLoader({super.key, required this.variant});

  final SkeletonVariant variant;

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final baseColor = brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.06);
    final highlightColor = brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.12)
        : Colors.black.withValues(alpha: 0.12);

    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return _buildShimmer(baseColor, highlightColor);
      },
    );
  }

  Widget _buildShimmer(Color base, Color highlight) {
    return switch (widget.variant) {
      SkeletonVariant.card => _CardSkeleton(base: base, highlight: highlight, controller: _shimmerController),
      SkeletonVariant.detail => _DetailSkeleton(base: base, highlight: highlight, controller: _shimmerController),
      SkeletonVariant.text => _TextSkeleton(base: base, highlight: highlight, controller: _shimmerController),
    };
  }
}

class _ShimmerPainter extends StatelessWidget {
  const _ShimmerPainter({
    required this.base,
    required this.highlight,
    required this.controller,
    required this.width,
    required this.height,
    this.borderRadius = 4,
  });

  final Color base;
  final Color highlight;
  final Animation<double> controller;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [base, base, highlight, base, base],
          stops: [
            0.0,
            controller.value - 0.3,
            controller.value,
            controller.value + 0.3,
            1.0,
          ],
        ).createShader(bounds),
        blendMode: BlendMode.srcOver,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: base,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton({
    required this.base,
    required this.highlight,
    required this.controller,
  });

  final Color base;
  final Color highlight;
  final Animation<double> controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _ShimmerPainter(
              base: base,
              highlight: highlight,
              controller: controller,
              width: double.infinity,
              height: double.infinity,
              borderRadius: 8,
            ),
          ),
          const SizedBox(height: 8),
          _ShimmerPainter(
            base: base,
            highlight: highlight,
            controller: controller,
            width: double.infinity,
            height: 12,
          ),
          const SizedBox(height: 4),
          _ShimmerPainter(
            base: base,
            highlight: highlight,
            controller: controller,
            width: 64,
            height: 12,
          ),
        ],
      ),
    );
  }
}

class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton({
    required this.base,
    required this.highlight,
    required this.controller,
  });

  final Color base;
  final Color highlight;
  final Animation<double> controller;

  double _headerHeight(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width < _detailPhoneBreakpoint
        ? _detailPhoneHeaderHeight
        : _detailTabletHeaderHeight;
  }

  @override
  Widget build(BuildContext context) {
    final headerHeight = _headerHeight(context);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: headerHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _ShimmerPainter(
                  base: base,
                  highlight: highlight,
                  controller: controller,
                  width: double.infinity,
                  height: headerHeight,
                  borderRadius: 0,
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 16,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _ShimmerPainter(
                        base: base,
                        highlight: highlight,
                        controller: controller,
                        width: _detailPosterWidth,
                        height: _detailPosterHeight,
                        borderRadius: 8,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _ShimmerPainter(
                              base: base,
                              highlight: highlight,
                              controller: controller,
                              width: double.infinity,
                              height: 22,
                            ),
                            const SizedBox(height: 6),
                            _ShimmerPainter(
                              base: base,
                              highlight: highlight,
                              controller: controller,
                              width: 180,
                              height: 22,
                            ),
                            const SizedBox(height: 8),
                            _ShimmerPainter(
                              base: base,
                              highlight: highlight,
                              controller: controller,
                              width: 200,
                              height: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ColoredBox(
            color: theme.scaffoldBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _chipSkeleton(72),
                      _chipSkeleton(56),
                      _chipSkeleton(64),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _ShimmerPainter(
                    base: base,
                    highlight: highlight,
                    controller: controller,
                    width: 220,
                    height: 18,
                  ),
                  const SizedBox(height: 16),
                  for (var i = 0; i < 5; i++) ...[
                    _ShimmerPainter(
                      base: base,
                      highlight: highlight,
                      controller: controller,
                      width: double.infinity,
                      height: 16,
                    ),
                    if (i < 4) const SizedBox(height: 10),
                  ],
                  const SizedBox(height: 4),
                  _ShimmerPainter(
                    base: base,
                    highlight: highlight,
                    controller: controller,
                    width: 240,
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipSkeleton(double width) {
    return _ShimmerPainter(
      base: base,
      highlight: highlight,
      controller: controller,
      width: width,
      height: 28,
      borderRadius: 4,
    );
  }
}

class _TextSkeleton extends StatelessWidget {
  const _TextSkeleton({
    required this.base,
    required this.highlight,
    required this.controller,
  });

  final Color base;
  final Color highlight;
  final Animation<double> controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ShimmerPainter(
            base: base,
            highlight: highlight,
            controller: controller,
            width: double.infinity,
            height: 14,
          ),
          const SizedBox(height: 8),
          _ShimmerPainter(
            base: base,
            highlight: highlight,
            controller: controller,
            width: double.infinity,
            height: 14,
          ),
          const SizedBox(height: 8),
          _ShimmerPainter(
            base: base,
            highlight: highlight,
            controller: controller,
            width: double.infinity,
            height: 14,
          ),
          const SizedBox(height: 8),
          _ShimmerPainter(
            base: base,
            highlight: highlight,
            controller: controller,
            width: 150,
            height: 14,
          ),
        ],
      ),
    );
  }
}
