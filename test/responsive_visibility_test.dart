import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';
import 'test_helpers.dart';

void main() {
  group('ResponsiveVisibility', () {
    testWidgets('visibleOn shows widget when screen type matches',
        (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: ResponsiveVisibility(
              visibleOn: const [ScreenType.mobile],
              child: const Text('Mobile Content'),
            ),
          ),
        ),
      );

      expect(find.text('Mobile Content'), findsOneWidget);
    });

    testWidgets('visibleOn hides widget when screen type does not match',
        (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: ResponsiveVisibility(
              visibleOn: const [ScreenType.tablet],
              child: const Text('Tablet Content'),
            ),
          ),
        ),
      );

      expect(find.text('Tablet Content'), findsNothing);
    });

    testWidgets('hiddenOn hides widget when screen type matches',
        (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: ResponsiveVisibility(
              hiddenOn: const [ScreenType.mobile],
              child: const Text('Hidden on Mobile'),
            ),
          ),
        ),
      );

      expect(find.text('Hidden on Mobile'), findsNothing);
    });

    testWidgets('hiddenOn shows widget when screen type does not match',
        (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: ResponsiveVisibility(
              hiddenOn: const [ScreenType.tablet],
              child: const Text('Not Hidden'),
            ),
          ),
        ),
      );

      expect(find.text('Not Hidden'), findsOneWidget);
    });

    testWidgets('shows replacement widget when hidden', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: ResponsiveVisibility(
              visibleOn: const [ScreenType.tablet],
              replacement: const Text('Replacement'),
              child: const Text('Original'),
            ),
          ),
        ),
      );

      expect(find.text('Replacement'), findsOneWidget);
      expect(find.text('Original'), findsNothing);
    });

    testWidgets('uses SizedBox.shrink when hidden without replacement',
        (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: ResponsiveVisibility(
              visibleOn: const [ScreenType.tablet],
              child: const Text('Hidden'),
            ),
          ),
        ),
      );

      expect(find.text('Hidden'), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('shows content when no filter specified', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: ResponsiveVisibility(
              child: const Text('Always Visible'),
            ),
          ),
        ),
      );

      expect(find.text('Always Visible'), findsOneWidget);
    });

    testWidgets('visibleOn with multiple screen types', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: ResponsiveVisibility(
              visibleOn: const [ScreenType.mobile, ScreenType.tablet],
              child: const Text('Mobile or Tablet'),
            ),
          ),
        ),
      );

      expect(find.text('Mobile or Tablet'), findsOneWidget);
    });
  });
}
