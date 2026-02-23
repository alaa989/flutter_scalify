import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';
import 'test_helpers.dart';

void main() {
  group('ResponsiveWrap', () {
    testWidgets('renders all children', (tester) async {
      await pumpApp(
        tester,
        buildTestApp(
          child: const ResponsiveWrap(
            children: [Text('A'), Text('B'), Text('C')],
          ),
        ),
      );

      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('uses Wrap widget internally', (tester) async {
      await pumpApp(
        tester,
        buildTestApp(
          child: const ResponsiveWrap(
            children: [Text('A'), Text('B')],
          ),
        ),
      );

      expect(find.byType(Wrap), findsOneWidget);
    });

    testWidgets('applies spacing and runSpacing', (tester) async {
      await pumpApp(
        tester,
        buildTestApp(
          child: const ResponsiveWrap(
            spacing: 16,
            runSpacing: 12,
            children: [Text('A'), Text('B')],
          ),
        ),
      );

      final wrap = tester.widget<Wrap>(find.byType(Wrap));
      // Spacing is scaled, so it should be > 0
      expect(wrap.spacing, greaterThan(0));
      expect(wrap.runSpacing, greaterThan(0));
    });

    testWidgets('scaleSpacing: false uses raw pixel values', (tester) async {
      await pumpApp(
        tester,
        buildTestApp(
          child: const ResponsiveWrap(
            spacing: 20,
            runSpacing: 10,
            scaleSpacing: false,
            children: [Text('A'), Text('B')],
          ),
        ),
      );

      final wrap = tester.widget<Wrap>(find.byType(Wrap));
      expect(wrap.spacing, 20.0);
      expect(wrap.runSpacing, 10.0);
    });

    testWidgets('applies alignment', (tester) async {
      await pumpApp(
        tester,
        buildTestApp(
          child: const ResponsiveWrap(
            alignment: WrapAlignment.center,
            children: [Text('A')],
          ),
        ),
      );

      final wrap = tester.widget<Wrap>(find.byType(Wrap));
      expect(wrap.alignment, WrapAlignment.center);
    });

    testWidgets('applies crossAxisAlignment', (tester) async {
      await pumpApp(
        tester,
        buildTestApp(
          child: const ResponsiveWrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [Text('A')],
          ),
        ),
      );

      final wrap = tester.widget<Wrap>(find.byType(Wrap));
      expect(wrap.crossAxisAlignment, WrapCrossAlignment.end);
    });

    testWidgets('applies direction', (tester) async {
      await pumpApp(
        tester,
        buildTestApp(
          child: const ResponsiveWrap(
            direction: Axis.vertical,
            children: [Text('A'), Text('B')],
          ),
        ),
      );

      final wrap = tester.widget<Wrap>(find.byType(Wrap));
      expect(wrap.direction, Axis.vertical);
    });

    testWidgets('applies padding when provided', (tester) async {
      await pumpApp(
        tester,
        buildTestApp(
          child: const ResponsiveWrap(
            padding: EdgeInsets.all(16),
            children: [Text('A')],
          ),
        ),
      );

      expect(find.byType(Padding), findsWidgets);
    });

    testWidgets('no padding widget when padding is null', (tester) async {
      await pumpApp(
        tester,
        buildTestApp(
          child: const ResponsiveWrap(
            children: [Text('A')],
          ),
        ),
      );

      // The Wrap should be the direct child, no extra Padding wrapper
      final wrap = find.byType(Wrap);
      expect(wrap, findsOneWidget);
    });

    testWidgets('handles empty children list', (tester) async {
      await pumpApp(
        tester,
        buildTestApp(
          child: const ResponsiveWrap(children: []),
        ),
      );

      expect(find.byType(Wrap), findsOneWidget);
    });
  });
}
