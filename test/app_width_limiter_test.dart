import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';
import 'test_helpers.dart';

void main() {
  group('AppWidthLimiter', () {
    testWidgets('does not limit when width <= maxWidth', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(
              home: Scaffold(body: child),
            ),
            child: AppWidthLimiter(
              maxWidth: 1400,
              child: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('limits width when screen > maxWidth', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(1920, 1080)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(
              home: Scaffold(body: child),
            ),
            child: AppWidthLimiter(
              maxWidth: 1400,
              backgroundColor: Colors.grey,
              child: const Text('Limited Content'),
            ),
          ),
        ),
      );

      expect(find.text('Limited Content'), findsOneWidget);
      expect(find.byType(ConstrainedBox), findsWidgets);
    });

    testWidgets('applies background color when limiting', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(1920, 1080)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(
              home: Scaffold(body: child),
            ),
            child: AppWidthLimiter(
              maxWidth: 1400,
              backgroundColor: const Color(0xFFE2E8F0),
              child: const Text('Colored'),
            ),
          ),
        ),
      );

      expect(find.byType(ColoredBox), findsWidgets);
    });

    testWidgets('creates horizontal scroll when width < minWidth',
        (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(300, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(
              home: Scaffold(body: child),
            ),
            child: SizedBox(
              width: 300,
              child: AppWidthLimiter(
                maxWidth: 1400,
                minWidth: 360,
                child: const Text('Scrollable'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Scrollable'), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('no horizontal scroll when width >= minWidth', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(400, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(
              home: Scaffold(body: child),
            ),
            child: AppWidthLimiter(
              maxWidth: 1400,
              minWidth: 360,
              child: const Text('Not Scrollable'),
            ),
          ),
        ),
      );

      expect(find.text('Not Scrollable'), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsNothing);
    });

    testWidgets('uses RepaintBoundary for performance when limiting',
        (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(1920, 1080)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(
              home: Scaffold(body: child),
            ),
            child: AppWidthLimiter(
              maxWidth: 1400,
              child: const Text('Perf Bounded'),
            ),
          ),
        ),
      );

      expect(find.byType(RepaintBoundary), findsWidgets);
    });

    testWidgets('default maxWidth is 1000', (tester) async {
      const limiter = AppWidthLimiter(child: SizedBox());
      expect(limiter.maxWidth, 1000.0);
    });

    testWidgets('default horizontalPadding is 16', (tester) async {
      const limiter = AppWidthLimiter(child: SizedBox());
      expect(limiter.horizontalPadding, 16.0);
    });
  });
}
