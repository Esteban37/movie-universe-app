import 'package:flutter/material.dart';

import '../../../core/errors/failure_presentation.dart';
import '../../../core/errors/failures.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    super.key,
    required this.onRetry,
    this.message,
    this.failure,
  }) : assert(message != null || failure != null);

  ErrorView.failure({super.key, required this.failure, required this.onRetry})
    : message = null;

  final String? message;
  final Failure? failure;
  final VoidCallback onRetry;

  String get _displayMessage {
    if (failure != null) {
      return failureUserMessage(failure!);
    }
    return message!;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _displayMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
