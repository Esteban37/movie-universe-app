import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/core/errors/failures.dart';
import 'package:movie_universe_app/shared/design_system/atoms/error_view.dart';

void main() {
  testWidgets('ErrorView.failure renders failure message', (tester) async {
    var retried = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorView.failure(
            failure: NetworkFailure(),
            onRetry: () => retried = true,
          ),
        ),
      ),
    );

    expect(
      find.text('No internet connection. Please check your network.'),
      findsOneWidget,
    );
    expect(find.textContaining('Instance of'), findsNothing);

    await tester.tap(find.text('Retry'));
    expect(retried, isTrue);
  });
}
