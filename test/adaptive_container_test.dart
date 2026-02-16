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

  group('AdaptiveContainer', () {
    testWidgets('shows xs widget when container is tiny', (tester) async {
      await pumpApp(
        tester,
        buildApp(
          size: const Size(375, 812),
          child: const SizedBox(
            width: 100,
            height: 100,
            child: AdaptiveContainer(
              breakpoints: [200, 500],
              xs: Text('XS'),
              sm: Text('SM'),
              lg: Text('LG'),
            ),
          ),
        ),
      );

      expect(find.text('XS'), findsOneWidget);
      expect(find.text('SM'), findsNothing);
    });

    testWidgets('shows sm widget when width >= first breakpoint',
        (tester) async {
      await pumpApp(
        tester,
        buildApp(
          size: const Size(375, 812),
          child: const SizedBox(
            width: 300,
            height: 200,
            child: AdaptiveContainer(
              breakpoints: [200, 500],
              xs: Text('XS'),
              sm: Text('SM'),
              lg: Text('LG'),
            ),
          ),
        ),
      );

      expect(find.text('SM'), findsOneWidget);
    });

    testWidgets('falls back to lower tier when higher not specified',
        (tester) async {
      await pumpApp(
        tester,
        buildApp(
          size: const Size(375, 812),
          child: const SizedBox(
            width: 600,
            height: 400,
            child: AdaptiveContainer(
              breakpoints: [200, 500],
              xs: Text('XS'),
            ),
          ),
        ),
      );

      expect(find.text('XS'), findsOneWidget);
    });

    testWidgets('works without custom breakpoints', (tester) async {
      await pumpApp(
        tester,
        buildApp(
          size: const Size(375, 812),
          child: const SizedBox(
            width: 300,
            height: 200,
            child: AdaptiveContainer(
              xs: Text('Default'),
            ),
          ),
        ),
      );

      expect(find.text('Default'), findsOneWidget);
    });

    testWidgets('xs is always the fallback', (tester) async {
      await pumpApp(
        tester,
        buildApp(
          size: const Size(375, 812),
          child: const SizedBox(
            width: 50,
            height: 50,
            child: AdaptiveContainer(
              breakpoints: [200, 400, 600, 800, 1000],
              xs: Text('Fallback'),
            ),
          ),
        ),
      );

      expect(find.text('Fallback'), findsOneWidget);
    });
  });
}
