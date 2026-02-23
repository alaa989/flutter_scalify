import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';
import 'test_helpers.dart';

void main() {
  group('ResponsiveText', () {
    testWidgets('renders full text on desktop', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(1200, 800)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveText('Welcome to our Premium Experience'),
          ),
        ),
      );

      expect(find.text('Welcome to our Premium Experience'), findsOneWidget);
    });

    testWidgets('renders shortText on mobile when provided', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveText(
              'Welcome to our Premium Experience',
              shortText: 'Welcome!',
            ),
          ),
        ),
      );

      expect(find.text('Welcome!'), findsOneWidget);
      expect(find.text('Welcome to our Premium Experience'), findsNothing);
    });

    testWidgets('renders full text on tablet when shortText provided',
        (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(768, 1024)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveText(
              'Welcome to our Premium Experience',
              shortText: 'Welcome!',
            ),
          ),
        ),
      );

      expect(find.text('Welcome to our Premium Experience'), findsOneWidget);
    });

    testWidgets('autoResize wraps in LayoutBuilder', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveText(
              'Hello World',
              autoResize: true,
              minFontSize: 8,
              maxLines: 1,
            ),
          ),
        ),
      );

      expect(find.byType(LayoutBuilder), findsWidgets);
      expect(find.text('Hello World'), findsOneWidget);
    });

    testWidgets('renders without autoResize as plain Text', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveText('Simple Text'),
          ),
        ),
      );

      expect(find.text('Simple Text'), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('applies custom style', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveText(
              'Styled',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Styled'));
      expect(textWidget.style?.fontWeight, FontWeight.bold);
    });

    testWidgets('applies overflow and maxLines', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveText(
              'Some text',
              maxLines: 2,
              overflow: TextOverflow.fade,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Some text'));
      expect(textWidget.maxLines, 2);
      expect(textWidget.overflow, TextOverflow.fade);
    });

    testWidgets('renders full text when no shortText on mobile',
        (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveText('No shortText version'),
          ),
        ),
      );

      expect(find.text('No shortText version'), findsOneWidget);
    });
  });
}
