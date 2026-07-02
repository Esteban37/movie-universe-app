import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  });

  final AsyncValue<T> asyncValue;
  final Widget Function(T data) onData;
  final Widget Function()? onLoading;
  final Widget Function()? onEmpty;
  final String? emptyMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      loading: () => onLoading?.call() ?? const Center(
        child: SkeletonLoader(variant: SkeletonVariant.detail),
      ),
      error: (error, _) => ErrorView(
        message: error.toString(),
        onRetry: onRetry ?? () {},
      ),
      data: (data) {
        if (data is List && data.isEmpty) {
          return onEmpty?.call() ?? EmptyView(
            message: emptyMessage ?? 'No content available.',
          );
        }
        if (data == null) {
          return onEmpty?.call() ?? EmptyView(
            message: emptyMessage ?? 'No content available.',
          );
        }
        return onData(data);
      },
    );
  }
}
