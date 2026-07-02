import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_universe_app/shared/widgets/skeleton_loader.dart';

void main() {
  testWidgets('SkeletonLoader renders card variant', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SkeletonLoader(variant: SkeletonVariant.card)),
      ),
    );

    expect(find.byType(SkeletonLoader), findsOneWidget);
  });

  testWidgets('SkeletonLoader renders detail variant', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SkeletonLoader(variant: SkeletonVariant.detail)),
      ),
    );

    expect(find.byType(SkeletonLoader), findsOneWidget);
  });

  testWidgets('SkeletonLoader renders text variant', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SkeletonLoader(variant: SkeletonVariant.text)),
      ),
    );

    expect(find.byType(SkeletonLoader), findsOneWidget);
  });

  testWidgets('SkeletonLoader shimmer animation runs without error', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SkeletonLoader(variant: SkeletonVariant.card)),
      ),
    );

    await tester.pump(const Duration(milliseconds: 750));
    expect(find.byType(SkeletonLoader), findsOneWidget);
  });
}
