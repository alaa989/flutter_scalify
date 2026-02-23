import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';
import 'test_helpers.dart';

void main() {
  group('SpacingScale', () {
    test('default values are correct', () {
      const scale = SpacingScale();
      expect(scale.xs, 4.0);
      expect(scale.sm, 8.0);
      expect(scale.md, 16.0);
      expect(scale.lg, 24.0);
      expect(scale.xl, 32.0);
      expect(scale.xxl, 48.0);
    });

    test('custom values are stored', () {
      const scale = SpacingScale(xs: 2, sm: 4, md: 8, lg: 12, xl: 16, xxl: 24);
      expect(scale.xs, 2.0);
      expect(scale.md, 8.0);
      expect(scale.xxl, 24.0);
    });

    test('valueOf returns correct tier value', () {
      const scale = SpacingScale();
      expect(scale.valueOf(Spacing.xs), 4.0);
      expect(scale.valueOf(Spacing.sm), 8.0);
      expect(scale.valueOf(Spacing.md), 16.0);
      expect(scale.valueOf(Spacing.lg), 24.0);
      expect(scale.valueOf(Spacing.xl), 32.0);
      expect(scale.valueOf(Spacing.xxl), 48.0);
    });
  });

  group('ScalifySpacing', () {
    tearDown(() {
      ScalifySpacing.reset();
    });

    test('init sets custom scale', () {
      const custom = SpacingScale(xs: 2, sm: 6);
      ScalifySpacing.init(custom);
      expect(ScalifySpacing.scale.xs, 2.0);
      expect(ScalifySpacing.scale.sm, 6.0);
    });

    test('reset restores defaults', () {
      ScalifySpacing.init(const SpacingScale(xs: 99));
      expect(ScalifySpacing.scale.xs, 99.0);

      ScalifySpacing.reset();
      expect(ScalifySpacing.scale.xs, 4.0);
    });

    test('scale getter returns current scale', () {
      expect(ScalifySpacing.scale, isA<SpacingScale>());
      expect(ScalifySpacing.scale.md, 16.0);
    });
  });

  group('Spacing enum', () {
    test('has all 6 tiers', () {
      expect(Spacing.values.length, 6);
      expect(Spacing.values, contains(Spacing.xs));
      expect(Spacing.values, contains(Spacing.sm));
      expect(Spacing.values, contains(Spacing.md));
      expect(Spacing.values, contains(Spacing.lg));
      expect(Spacing.values, contains(Spacing.xl));
      expect(Spacing.values, contains(Spacing.xxl));
    });
  });

  group('SpacingExtension', () {
    testWidgets('gap returns vertical SizedBox', (tester) async {
      await pumpApp(
        tester,
        buildTestApp(
          child: Column(
            children: [
              const Text('A'),
              Spacing.md.gap,
              const Text('B'),
            ],
          ),
        ),
      );

      expect(find.byType(SizedBox), findsWidgets);
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('gapW returns horizontal SizedBox', (tester) async {
      await pumpApp(
        tester,
        buildTestApp(
          child: Row(
            children: [
              const Text('A'),
              Spacing.sm.gapW,
              const Text('B'),
            ],
          ),
        ),
      );

      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('insets returns EdgeInsets.all', (tester) async {
      await pumpApp(
        tester,
        buildTestApp(
          child: Container(
            padding: Spacing.lg.insets,
            child: const Text('Padded'),
          ),
        ),
      );

      expect(find.text('Padded'), findsOneWidget);
    });

    testWidgets('insetsH returns symmetric horizontal padding', (tester) async {
      await pumpApp(
        tester,
        buildTestApp(
          child: Container(
            padding: Spacing.sm.insetsH,
            child: const Text('H-Padded'),
          ),
        ),
      );

      expect(find.text('H-Padded'), findsOneWidget);
    });

    testWidgets('insetsV returns symmetric vertical padding', (tester) async {
      await pumpApp(
        tester,
        buildTestApp(
          child: Container(
            padding: Spacing.md.insetsV,
            child: const Text('V-Padded'),
          ),
        ),
      );

      expect(find.text('V-Padded'), findsOneWidget);
    });

    testWidgets('value returns scaled double', (tester) async {
      await pumpApp(
        tester,
        buildTestApp(
          child: Builder(
            builder: (context) {
              // The value should be base * scaleFactor
              final val = Spacing.md.value;
              return Text('val:${val > 0}');
            },
          ),
        ),
      );

      expect(find.text('val:true'), findsOneWidget);
    });
  });
}
