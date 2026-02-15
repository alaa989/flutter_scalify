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

  group('ContainerQuery', () {
    testWidgets('provides width and height to builder', (tester) async {
      late ContainerQueryData capturedData;

      await pumpApp(
        tester,
        buildApp(
          size: const Size(375, 812),
          child: SizedBox(
            width: 300,
            height: 200,
            child: ContainerQuery(
              builder: (context, query) {
                capturedData = query;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(capturedData.width, closeTo(300, 1));
      expect(capturedData.height, closeTo(200, 1));
    });

    testWidgets('calculates tier from custom breakpoints', (tester) async {
      late ContainerQueryData capturedData;

      await pumpApp(
        tester,
        buildApp(
          size: const Size(375, 812),
          child: SizedBox(
            width: 600,
            height: 400,
            child: ContainerQuery(
              breakpoints: const [200, 400, 800],
              builder: (context, query) {
                capturedData = query;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(capturedData.tier, QueryTier.md);
    });

    testWidgets('xs tier when width is below all breakpoints', (tester) async {
      late ContainerQueryData capturedData;

      await pumpApp(
        tester,
        buildApp(
          size: const Size(375, 812),
          child: SizedBox(
            width: 100,
            height: 100,
            child: ContainerQuery(
              breakpoints: const [200, 400],
              builder: (context, query) {
                capturedData = query;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(capturedData.tier, QueryTier.xs);
    });

    testWidgets('onChanged callback fires on tier change', (tester) async {
      int changeCount = 0;

      await pumpApp(
        tester,
        buildApp(
          size: const Size(375, 812),
          child: SizedBox(
            width: 300,
            child: ContainerQuery(
              breakpoints: const [200, 400],
              onChanged: (prev, current) {
                changeCount++;
              },
              builder: (context, query) => const SizedBox(),
            ),
          ),
        ),
      );

      expect(changeCount, greaterThanOrEqualTo(1));
    });

    testWidgets('works without custom breakpoints', (tester) async {
      late ContainerQueryData capturedData;

      await pumpApp(
        tester,
        buildApp(
          size: const Size(375, 812),
          child: SizedBox(
            width: 500,
            height: 300,
            child: ContainerQuery(
              builder: (context, query) {
                capturedData = query;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(capturedData.tier, QueryTier.xs);
    });
  });

  group('ContainerQueryData', () {
    test('isLessThan returns correct value', () {
      const data =
          ContainerQueryData(width: 300, height: 200, tier: QueryTier.sm);
      expect(data.isLessThan(400), true);
      expect(data.isLessThan(200), false);
    });

    test('isAtLeast returns correct value', () {
      const data =
          ContainerQueryData(width: 300, height: 200, tier: QueryTier.sm);
      expect(data.isAtLeast(300), true);
      expect(data.isAtLeast(301), false);
    });

    test('isMobile for xs and sm', () {
      expect(
        const ContainerQueryData(width: 100, height: 100, tier: QueryTier.xs)
            .isMobile,
        true,
      );
      expect(
        const ContainerQueryData(width: 200, height: 200, tier: QueryTier.sm)
            .isMobile,
        true,
      );
      expect(
        const ContainerQueryData(width: 500, height: 500, tier: QueryTier.md)
            .isMobile,
        false,
      );
    });

    test('isTablet for md', () {
      expect(
        const ContainerQueryData(width: 500, height: 500, tier: QueryTier.md)
            .isTablet,
        true,
      );
      expect(
        const ContainerQueryData(width: 500, height: 500, tier: QueryTier.lg)
            .isTablet,
        false,
      );
    });

    test('isDesktop for lg and above', () {
      expect(
        const ContainerQueryData(width: 800, height: 600, tier: QueryTier.lg)
            .isDesktop,
        true,
      );
      expect(
        const ContainerQueryData(width: 1200, height: 800, tier: QueryTier.xl)
            .isDesktop,
        true,
      );
      expect(
        const ContainerQueryData(width: 1800, height: 1000, tier: QueryTier.xxl)
            .isDesktop,
        true,
      );
    });

    test('equality and hashCode', () {
      const a = ContainerQueryData(width: 300, height: 200, tier: QueryTier.sm);
      const b = ContainerQueryData(width: 300, height: 200, tier: QueryTier.sm);
      const c = ContainerQueryData(width: 400, height: 200, tier: QueryTier.sm);

      expect(a == b, true);
      expect(a.hashCode, b.hashCode);
      expect(a == c, false);
    });
  });
}
