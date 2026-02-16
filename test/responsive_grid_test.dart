import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';
import 'test_helpers.dart';

void main() {
  Widget buildApp({
    required Size size,
    required Widget child,
  }) {
    return MediaQuery(
      data: MediaQueryData(size: size),
      child: ScalifyProvider(
        builder: (context, c) => MaterialApp(
          home: Scaffold(body: c),
        ),
        child: child,
      ),
    );
  }

  group('ResponsiveGrid', () {
    group('Manual Mode (children)', () {
      testWidgets('renders all children', (tester) async {
        await pumpApp(
          tester,
          buildApp(
            size: const Size(375, 812),
            child: const ResponsiveGrid(
              mobile: 2,
              shrinkWrap: true,
              children: [
                Text('1'),
                Text('2'),
                Text('3'),
                Text('4'),
              ],
            ),
          ),
        );

        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
        expect(find.text('4'), findsOneWidget);
      });

      testWidgets('uses correct column count for mobile', (tester) async {
        await pumpApp(
          tester,
          buildApp(
            size: const Size(375, 812),
            child: ResponsiveGrid(
              mobile: 2,
              tablet: 3,
              desktop: 4,
              shrinkWrap: true,
              children: List.generate(
                  4, (i) => Container(key: ValueKey(i), height: 50)),
            ),
          ),
        );

        final pos0 = tester.getTopLeft(find.byKey(const ValueKey(0)));
        final pos1 = tester.getTopLeft(find.byKey(const ValueKey(1)));
        final pos2 = tester.getTopLeft(find.byKey(const ValueKey(2)));

        expect(pos0.dy, equals(pos1.dy));
        expect(pos2.dy, greaterThan(pos1.dy));
      });
    });

    group('Auto-Fit Mode (itemBuilder)', () {
      testWidgets('renders items from builder', (tester) async {
        await pumpApp(
          tester,
          buildApp(
            size: const Size(375, 812),
            child: ResponsiveGrid(
              minItemWidth: 150,
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) => Text('Item $index'),
            ),
          ),
        );

        expect(find.text('Item 0'), findsOneWidget);
        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
      });
    });

    group('Sliver Mode', () {
      testWidgets('works inside CustomScrollView', (tester) async {
        await pumpApp(
          tester,
          buildApp(
            size: const Size(375, 812),
            child: CustomScrollView(
              slivers: [
                ResponsiveGrid(
                  useSliver: true,
                  mobile: 2,
                  itemCount: 4,
                  itemBuilder: (context, index) =>
                      Container(key: ValueKey(index), height: 50),
                ),
              ],
            ),
          ),
        );

        expect(find.byKey(const ValueKey(0)), findsOneWidget);
        expect(find.byKey(const ValueKey(1)), findsOneWidget);
      });

      testWidgets('sliver mode with padding', (tester) async {
        await pumpApp(
          tester,
          buildApp(
            size: const Size(375, 812),
            child: CustomScrollView(
              slivers: [
                ResponsiveGrid(
                  useSliver: true,
                  mobile: 2,
                  padding: const EdgeInsets.all(16),
                  itemCount: 2,
                  itemBuilder: (context, index) =>
                      Container(key: ValueKey(index), height: 50),
                ),
              ],
            ),
          ),
        );

        expect(find.byType(SliverPadding), findsOneWidget);
      });
    });

    group('Custom properties', () {
      testWidgets('custom spacing is applied', (tester) async {
        await pumpApp(
          tester,
          buildApp(
            size: const Size(375, 812),
            child: ResponsiveGrid(
              mobile: 2,
              spacing: 20,
              runSpacing: 20,
              shrinkWrap: true,
              children: List.generate(
                  4, (i) => Container(key: ValueKey(i), height: 50)),
            ),
          ),
        );

        expect(find.byKey(const ValueKey(0)), findsOneWidget);
      });

      testWidgets('custom childAspectRatio', (tester) async {
        await pumpApp(
          tester,
          buildApp(
            size: const Size(375, 812),
            child: ResponsiveGrid(
              mobile: 2,
              childAspectRatio: 2.0,
              shrinkWrap: true,
              children: List.generate(4, (i) => Container(key: ValueKey(i))),
            ),
          ),
        );

        expect(find.byKey(const ValueKey(0)), findsOneWidget);
      });
    });

    group('Assertions', () {
      test('asserts when both children and itemBuilder provided', () {
        expect(
          () => ResponsiveGrid(
            itemBuilder: (_, __) => const Text('b'),
            itemCount: 1,
            children: const [Text('a')],
          ),
          throwsA(isA<AssertionError>()),
        );
      });

      test('asserts when itemBuilder without itemCount', () {
        expect(
          () => ResponsiveGrid(
            itemBuilder: (_, __) => const Text('a'),
          ),
          throwsA(isA<AssertionError>()),
        );
      });
    });
  });
}
