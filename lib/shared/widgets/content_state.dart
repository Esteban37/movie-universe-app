import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/failures.dart';
import 'skeleton_loader.dart';
import 'error_view.dart';
import 'empty_view.dart';

class ContentState<T> extends StatelessWidget {
  const ContentState({
    super.key,
    required this.asyncValue,
    required this.onData,
    this.onLoading,
    this.onEmpty,
    this.emptyMessage,
    this.onRetry,
    this.transitionDuration = const Duration(milliseconds: 300),
  });

  final AsyncValue<T> asyncValue;
  final Widget Function(T data) onData;
  final Widget Function()? onLoading;
  final Widget Function()? onEmpty;
  final String? emptyMessage;
  final VoidCallback? onRetry;
  final Duration transitionDuration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: MediaQuery.of(context).disableAnimations
          ? Duration.zero
          : transitionDuration,
      child: asyncValue.when(
        loading: () => KeyedSubtree(
          key: const ValueKey('content-state-loading'),
          child:
              onLoading?.call() ??
              const Center(
                child: SkeletonLoader(variant: SkeletonVariant.detail),
              ),
        ),
        error: (error, _) => KeyedSubtree(
          key: const ValueKey('content-state-error'),
          child: ErrorView(
            failure: error is Failure
                ? error
                : UnexpectedFailure(details: error.toString()),
            onRetry: onRetry ?? () {},
          ),
        ),
        data: (data) {
          if (data is List && data.isEmpty) {
            return KeyedSubtree(
              key: const ValueKey('content-state-empty'),
              child:
                  onEmpty?.call() ??
                  EmptyView(message: emptyMessage ?? 'No content available.'),
            );
          }
          if (data == null) {
            return KeyedSubtree(
              key: const ValueKey('content-state-empty'),
              child:
                  onEmpty?.call() ??
                  EmptyView(message: emptyMessage ?? 'No content available.'),
            );
          }
          return KeyedSubtree(
            key: const ValueKey('content-state-data'),
            child: onData(data),
          );
        },
      ),
    );
  }
}
