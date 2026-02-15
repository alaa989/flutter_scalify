import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';
import 'test_helpers.dart';

void main() {
  group('ScalifyProvider', () {
    testWidgets('provides ResponsiveData to children', (tester) async {
      late ResponsiveData capturedData;

      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: Builder(
              builder: (context) {
                capturedData = ScalifyProvider.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(capturedData, isA<ResponsiveData>());
      expect(capturedData.screenType, ScreenType.mobile);
    });

    testWidgets('works with builder pattern', (tester) async {
      late ResponsiveData capturedData;

      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: Builder(
              builder: (context) {
                capturedData = ScalifyProvider.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(capturedData, isA<ResponsiveData>());
    });

    testWidgets('updates GlobalResponsive on metrics change', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: const SizedBox(),
          ),
        ),
      );

      expect(GlobalResponsive.data.screenType, ScreenType.mobile);
    });

    testWidgets('uses custom config', (tester) async {
      late ResponsiveData capturedData;

      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            config: const ScalifyConfig(
              designWidth: 414,
              designHeight: 896,
            ),
            builder: (context, child) => MaterialApp(home: child),
            child: Builder(
              builder: (context) {
                capturedData = ScalifyProvider.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(capturedData.config.designWidth, 414);
      expect(capturedData.config.designHeight, 896);
    });

    testWidgets('assert fails with neither child nor builder', (tester) async {
      expect(
        () => ScalifyProvider(),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('fallback when no provider above in tree', (tester) async {
      late ResponsiveData capturedData;

      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                capturedData = ScalifyProvider.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(capturedData, isA<ResponsiveData>());
    });

    testWidgets('granular notifications with ScalifyAspect.type',
        (tester) async {
      int buildCount = 0;

      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            config: const ScalifyConfig(enableGranularNotifications: true),
            builder: (context, child) => MaterialApp(home: child),
            child: Builder(
              builder: (context) {
                ScalifyProvider.of(context, aspect: ScalifyAspect.type);
                buildCount++;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(buildCount, greaterThanOrEqualTo(1));
    });

    testWidgets('shows deprecation banner with legacy mode in debug',
        (tester) async {
      // Note: The deprecation banner renders as a sibling to the builder
      // output, so it needs Material ancestors. We use the child pattern
      // (ScalifyProvider inside MaterialApp) for this specific test.
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: MaterialApp(
            home: ScalifyProvider(
              config: const ScalifyConfig(
                legacyContainerTierMapping: true,
                showDeprecationBanner: true,
              ),
              child: const SizedBox(),
            ),
          ),
        ),
      );

      expect(find.text('Legacy Mode Active'), findsOneWidget);
    });

    testWidgets('hides deprecation banner when showDeprecationBanner is false',
        (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: MaterialApp(
            home: ScalifyProvider(
              config: const ScalifyConfig(
                legacyContainerTierMapping: true,
                showDeprecationBanner: false,
              ),
              child: const SizedBox(),
            ),
          ),
        ),
      );

      expect(find.text('Legacy Mode Active'), findsNothing);
    });
  });
}
