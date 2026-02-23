import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';
import 'test_helpers.dart';

void main() {
  group('ScalifyDebugOverlay', () {
    testWidgets('renders child widget', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ScalifyDebugOverlay(
              child: Text('App Content'),
            ),
          ),
        ),
      );

      expect(find.text('App Content'), findsOneWidget);
    });

    testWidgets('shows debug panel in debug mode', (tester) async {
      // In test environment, kDebugMode is true
      expect(kDebugMode, isTrue);

      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ScalifyDebugOverlay(
              child: Text('App Content'),
            ),
          ),
        ),
      );

      // In debug mode, should have a Stack with the overlay
      expect(find.byType(Stack), findsWidgets);
    });

    testWidgets('uses Stack to overlay debug panel', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ScalifyDebugOverlay(
              child: Text('Content'),
            ),
          ),
        ),
      );

      // Debug overlay wraps child in a Stack
      expect(find.byType(Stack), findsWidgets);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('child widget remains interactive', (tester) async {
      bool pressed = false;

      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ScalifyDebugOverlay(
              child: ElevatedButton(
                onPressed: () => pressed = true,
                child: const Text('Tap Me'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap Me'));
      expect(pressed, isTrue);
    });
  });
}
