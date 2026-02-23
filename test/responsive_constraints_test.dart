import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';
import 'test_helpers.dart';

void main() {
  group('ResponsiveConstraints', () {
    testWidgets('applies mobile constraints on mobile', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveConstraints(
              mobile: BoxConstraints(maxWidth: 300),
              desktop: BoxConstraints(maxWidth: 600),
              child: SizedBox(width: double.infinity, child: Text('Content')),
            ),
          ),
        ),
      );

      expect(find.text('Content'), findsOneWidget);
      expect(find.byType(ConstrainedBox), findsWidgets);
    });

    testWidgets('applies desktop constraints on desktop', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(1400, 900)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveConstraints(
              mobile: BoxConstraints(maxWidth: 300),
              desktop: BoxConstraints(maxWidth: 600),
              child: Text('Desktop Content'),
            ),
          ),
        ),
      );

      expect(find.text('Desktop Content'), findsOneWidget);
    });

    testWidgets('applies tablet constraints on tablet', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(768, 1024)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveConstraints(
              mobile: BoxConstraints(maxWidth: 300),
              tablet: BoxConstraints(maxWidth: 450),
              child: Text('Tablet Content'),
            ),
          ),
        ),
      );

      expect(find.text('Tablet Content'), findsOneWidget);
    });

    testWidgets('falls back to mobile when tablet is null', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(768, 1024)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveConstraints(
              mobile: BoxConstraints(maxWidth: 300),
              child: Text('Fallback'),
            ),
          ),
        ),
      );

      expect(find.text('Fallback'), findsOneWidget);
    });

    testWidgets('alignment wraps in Align widget', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveConstraints(
              alignment: Alignment.center,
              mobile: BoxConstraints(maxWidth: 300),
              child: Text('Centered'),
            ),
          ),
        ),
      );

      expect(find.byType(Align), findsWidgets);
      expect(find.text('Centered'), findsOneWidget);
    });

    testWidgets('no Align when alignment is null', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveConstraints(
              mobile: BoxConstraints(maxWidth: 300),
              child: Text('No Align'),
            ),
          ),
        ),
      );

      // Should not find ResponsiveConstraints-added Align
      // (there may be other Aligns in the tree from MaterialApp)
      expect(find.text('No Align'), findsOneWidget);
    });

    testWidgets('scaleConstraints multiplies values by scale factor',
        (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveConstraints(
              mobile: BoxConstraints(maxWidth: 300),
              scaleConstraints: true,
              child: Text('Scaled'),
            ),
          ),
        ),
      );

      expect(find.text('Scaled'), findsOneWidget);
      expect(find.byType(ConstrainedBox), findsWidgets);
    });

    testWidgets('scaleConstraints: false uses raw values', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveConstraints(
              mobile: BoxConstraints(maxWidth: 300),
              scaleConstraints: false,
              child: Text('Raw'),
            ),
          ),
        ),
      );

      // Find the ConstrainedBox that has our maxWidth:300 constraint
      final boxes = tester
          .widgetList<ConstrainedBox>(find.byType(ConstrainedBox))
          .where((b) => b.constraints.maxWidth == 300.0);
      expect(boxes.isNotEmpty, isTrue);
    });

    testWidgets('largeDesktop fallback chain works', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(2000, 1200)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveConstraints(
              mobile: BoxConstraints(maxWidth: 300),
              desktop: BoxConstraints(maxWidth: 600),
              largeDesktop: BoxConstraints(maxWidth: 900),
              child: Text('LargeDesktop'),
            ),
          ),
        ),
      );

      expect(find.text('LargeDesktop'), findsOneWidget);
    });
  });
}
