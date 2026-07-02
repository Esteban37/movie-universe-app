import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/shared/widgets/content_state.dart';
import 'package:movie_universe_app/shared/widgets/error_view.dart';
import 'package:movie_universe_app/shared/widgets/empty_view.dart';
import 'package:movie_universe_app/shared/widgets/skeleton_loader.dart';

Widget wrapTest(Widget child) {
  return ProviderScope(child: MaterialApp(home: Scaffold(body: child)));
}

void main() {
  testWidgets('ContentState shows skeleton on loading', (tester) async {
    const asyncValue = AsyncValue<List<String>>.loading();

    await tester.pumpWidget(wrapTest(
      ContentState<List<String>>(
        asyncValue: asyncValue,
        onData: (data) => const Text('data'),
      ),
    ));

    expect(find.byType(SkeletonLoader), findsOneWidget);
  });

  testWidgets('ContentState shows error with retry', (tester) async {
    final asyncValue = AsyncValue<List<String>>.error(Exception('test error'), StackTrace.current);
    var retryCalled = false;

    await tester.pumpWidget(wrapTest(
      ContentState<List<String>>(
        asyncValue: asyncValue,
        onData: (data) => const Text('data'),
        onRetry: () => retryCalled = true,
      ),
    ));

    expect(find.byType(ErrorView), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    expect(retryCalled, isTrue);
  });

  testWidgets('ContentState shows empty state for empty list', (tester) async {
    const asyncValue = AsyncValue<List<String>>.data([]);

    await tester.pumpWidget(wrapTest(
      ContentState<List<String>>(
        asyncValue: asyncValue,
        onData: (data) => const Text('data'),
        emptyMessage: 'Nothing here',
      ),
    ));

    expect(find.byType(EmptyView), findsOneWidget);
    expect(find.text('Nothing here'), findsOneWidget);
  });

  testWidgets('ContentState renders data widget', (tester) async {
    const asyncValue = AsyncValue<List<String>>.data(['item']);

    await tester.pumpWidget(wrapTest(
      ContentState<List<String>>(
        asyncValue: asyncValue,
        onData: (data) => const Text('data rendered'),
      ),
    ));

    expect(find.text('data rendered'), findsOneWidget);
  });

  testWidgets('ContentState uses custom loading widget', (tester) async {
    const asyncValue = AsyncValue<List<String>>.loading();

    await tester.pumpWidget(wrapTest(
      ContentState<List<String>>(
        asyncValue: asyncValue,
        onData: (data) => const Text('data'),
        onLoading: () => const Text('custom loading'),
      ),
    ));

    expect(find.text('custom loading'), findsOneWidget);
  });
}
