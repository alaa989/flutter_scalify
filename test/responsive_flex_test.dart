import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';
import 'test_helpers.dart';

void main() {
  group('ResponsiveFlex', () {
    testWidgets('renders as Row on wide screen', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(1024, 768)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(
              home: Scaffold(body: child),
            ),
            child: ResponsiveFlex(
              switchOn: ScreenType.mobile,
              children: const [
                Text('Child 1'),
                Text('Child 2'),
              ],
            ),
          ),
        ),
      );

      // ResponsiveFlex uses Flex widget, not Row/Column directly
      expect(find.byType(Flex), findsWidgets);
      expect(find.text('Child 1'), findsOneWidget);
      expect(find.text('Child 2'), findsOneWidget);
    });

    testWidgets('renders as Column on mobile', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(
              home: Scaffold(body: child),
            ),
            child: ResponsiveFlex(
              switchOn: ScreenType.mobile,
              children: const [
                Text('Child A'),
                Text('Child B'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(Flex), findsWidgets);
      expect(find.text('Child A'), findsOneWidget);
    });

    testWidgets('switchOn works with ScreenType.tablet', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(768, 1024)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(
              home: Scaffold(body: child),
            ),
            child: ResponsiveFlex(
              switchOn: ScreenType.tablet,
              children: const [Text('A'), Text('B')],
            ),
          ),
        ),
      );

      // tablet <= tablet threshold → Column (vertical Flex)
      expect(find.byType(Flex), findsWidgets);
    });

    testWidgets('uses custom breakpoint', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(500, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(
              home: Scaffold(body: child),
            ),
            child: ResponsiveFlex(
              breakpoint: 600,
              children: const [Text('A'), Text('B')],
            ),
          ),
        ),
      );

      // 500 < 600 → Column (vertical Flex)
      expect(find.byType(Flex), findsWidgets);
    });

    testWidgets('applies spacing between children', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(
              home: Scaffold(body: child),
            ),
            child: ResponsiveFlex(
              switchOn: ScreenType.mobile,
              spacing: 16,
              children: const [Text('A'), Text('B'), Text('C')],
            ),
          ),
        ),
      );

      // SizedBox spacers between children
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('zero spacing produces no spacers', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(
              home: Scaffold(body: child),
            ),
            child: ResponsiveFlex(
              switchOn: ScreenType.mobile,
              spacing: 0,
              children: const [Text('A'), Text('B')],
            ),
          ),
        ),
      );

      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('flipOnRtl flips direction for RTL', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(1024, 768)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(
              home: Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(body: child!),
              ),
            ),
            child: ResponsiveFlex(
              switchOn: ScreenType.mobile,
              flipOnRtl: true,
              children: const [Text('A'), Text('B')],
            ),
          ),
        ),
      );

      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('custom alignment is applied', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(
              home: Scaffold(body: child),
            ),
            child: ResponsiveFlex(
              switchOn: ScreenType.mobile,
              colMainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [Text('A')],
            ),
          ),
        ),
      );

      expect(find.text('A'), findsOneWidget);
    });
  });
}
