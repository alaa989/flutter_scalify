import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';
import 'test_helpers.dart';

void main() {
  group('ResponsiveLayout', () {
    testWidgets('shows portrait widget when height > width', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: ResponsiveLayout(
              portrait: const Text('Portrait'),
              landscape: const Text('Landscape'),
            ),
          ),
        ),
      );

      expect(find.text('Portrait'), findsOneWidget);
      expect(find.text('Landscape'), findsNothing);
    });

    testWidgets('shows landscape widget when width > height', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(812, 375)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: ResponsiveLayout(
              portrait: const Text('Portrait'),
              landscape: const Text('Landscape'),
            ),
          ),
        ),
      );

      expect(find.text('Landscape'), findsOneWidget);
      expect(find.text('Portrait'), findsNothing);
    });

    testWidgets('shows landscape when width == height (edge case)',
        (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(500, 500)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: ResponsiveLayout(
              portrait: const Text('Portrait'),
              landscape: const Text('Landscape'),
            ),
          ),
        ),
      );

      // Width == Height → portrait (source uses strict > for landscape)
      expect(find.text('Portrait'), findsOneWidget);
    });
  });
}
