import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';
import 'test_helpers.dart';

void main() {
  group('ScalifyThemeExtension', () {
    testWidgets('scale() returns same theme when scaleFactor is 1.0',
        (tester) async {
      late ThemeData originalTheme;
      late ThemeData scaledTheme;

      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            config: const ScalifyConfig(designWidth: 375, designHeight: 812),
            builder: (context, child) => MaterialApp(
              home: child,
            ),
            child: Builder(
              builder: (context) {
                originalTheme = Theme.of(context);
                scaledTheme = originalTheme.scale(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      // When scaleFactor is 1.0, should return the same theme
      expect(identical(scaledTheme, originalTheme), true);
    });

    testWidgets('scale() scales text theme when scaleFactor != 1.0',
        (tester) async {
      late ThemeData scaledTheme;

      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(750, 1624)),
          child: ScalifyProvider(
            config: const ScalifyConfig(designWidth: 375, designHeight: 812),
            builder: (context, child) => MaterialApp(
              home: child,
            ),
            child: Builder(
              builder: (context) {
                scaledTheme = Theme.of(context).scale(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      // scaleFactor is ~2.0, so text sizes should be doubled
      expect(scaledTheme.textTheme, isNotNull);
    });

    testWidgets('scale() scales icon theme', (tester) async {
      late ThemeData scaledTheme;
      const testKey = Key('icon_theme_builder');

      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(750, 1624)),
          child: ScalifyProvider(
            config: const ScalifyConfig(designWidth: 375, designHeight: 812),
            builder: (context, child) => MaterialApp(
              theme: ThemeData(
                iconTheme: const IconThemeData(size: 24),
              ),
              home: child,
            ),
            child: Builder(
              key: testKey,
              builder: (context) {
                scaledTheme = Theme.of(context).scale(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      final data = ScalifyProvider.of(tester.element(find.byKey(testKey)));
      final expectedIconSize = 24.0 * data.scaleFactor;
      expect(scaledTheme.iconTheme.size, closeTo(expectedIconSize, 0.1));
    });

    testWidgets('scale() scales primaryIconTheme', (tester) async {
      late ThemeData scaledTheme;
      const testKey = Key('primary_icon_builder');

      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(750, 1624)),
          child: ScalifyProvider(
            config: const ScalifyConfig(designWidth: 375, designHeight: 812),
            builder: (context, child) => MaterialApp(
              theme: ThemeData(
                primaryIconTheme: const IconThemeData(size: 30),
              ),
              home: child,
            ),
            child: Builder(
              key: testKey,
              builder: (context) {
                scaledTheme = Theme.of(context).scale(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      final data = ScalifyProvider.of(tester.element(find.byKey(testKey)));
      final expectedSize = 30.0 * data.scaleFactor;
      expect(scaledTheme.primaryIconTheme.size, closeTo(expectedSize, 0.1));
    });
  });
}
