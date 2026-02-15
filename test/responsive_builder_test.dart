import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';
import 'test_helpers.dart';

void main() {
  group('ResponsiveBuilder', () {
    testWidgets('provides ResponsiveData via builder', (tester) async {
      late ResponsiveData capturedData;

      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: ResponsiveBuilder(
              builder: (context, data) {
                capturedData = data;
                return const Text('Hello');
              },
            ),
          ),
        ),
      );

      expect(capturedData, isA<ResponsiveData>());
      expect(capturedData.screenType, ScreenType.mobile);
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('renders content', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: ResponsiveBuilder(
              builder: (context, data) =>
                  Text('Screen: ${data.screenType.name}'),
            ),
          ),
        ),
      );

      expect(find.text('Screen: mobile'), findsOneWidget);
    });
  });

  group('ScalifyBuilder', () {
    testWidgets('provides ResponsiveData via builder', (tester) async {
      late ResponsiveData capturedData;

      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: ScalifyBuilder(
              builder: (context, data) {
                capturedData = data;
                return const Text('Scalify');
              },
            ),
          ),
        ),
      );

      expect(capturedData, isA<ResponsiveData>());
      expect(find.text('Scalify'), findsOneWidget);
    });

    testWidgets('renders screen type', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(768, 1024)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: ScalifyBuilder(
              builder: (context, data) => Text('Type: ${data.screenType.name}'),
            ),
          ),
        ),
      );

      expect(find.text('Type: tablet'), findsOneWidget);
    });
  });
}
