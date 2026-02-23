import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';
import 'test_helpers.dart';

void main() {
  group('ResponsiveTransitionType', () {
    test('has 4 types', () {
      expect(ResponsiveTransitionType.values.length, 4);
      expect(ResponsiveTransitionType.values,
          contains(ResponsiveTransitionType.fade));
      expect(ResponsiveTransitionType.values,
          contains(ResponsiveTransitionType.fadeSlide));
      expect(ResponsiveTransitionType.values,
          contains(ResponsiveTransitionType.scale));
      expect(ResponsiveTransitionType.values,
          contains(ResponsiveTransitionType.fadeScale));
    });
  });

  group('AnimatedResponsiveTransition', () {
    testWidgets('renders mobile widget on mobile screen', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const AnimatedResponsiveTransition(
              mobile: Text('Mobile'),
              desktop: Text('Desktop'),
            ),
          ),
        ),
      );

      expect(find.text('Mobile'), findsOneWidget);
      expect(find.text('Desktop'), findsNothing);
    });

    testWidgets('renders desktop widget on desktop screen', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(1400, 900)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const AnimatedResponsiveTransition(
              mobile: Text('Mobile'),
              desktop: Text('Desktop'),
            ),
          ),
        ),
      );

      expect(find.text('Desktop'), findsOneWidget);
      expect(find.text('Mobile'), findsNothing);
    });

    testWidgets('renders tablet widget on tablet screen', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(768, 1024)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const AnimatedResponsiveTransition(
              mobile: Text('Mobile'),
              tablet: Text('Tablet'),
              desktop: Text('Desktop'),
            ),
          ),
        ),
      );

      expect(find.text('Tablet'), findsOneWidget);
    });

    testWidgets('falls back to mobile when tablet is null', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(768, 1024)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const AnimatedResponsiveTransition(
              mobile: Text('Mobile Fallback'),
            ),
          ),
        ),
      );

      expect(find.text('Mobile Fallback'), findsOneWidget);
    });

    testWidgets('uses AnimatedSwitcher internally', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const AnimatedResponsiveTransition(
              mobile: Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedSwitcher), findsOneWidget);
    });

    testWidgets('wraps in RepaintBoundary', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const AnimatedResponsiveTransition(
              mobile: Text('Content'),
            ),
          ),
        ),
      );

      expect(find.byType(RepaintBoundary), findsWidgets);
    });

    testWidgets('custom duration is applied', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const AnimatedResponsiveTransition(
              duration: Duration(milliseconds: 500),
              mobile: Text('Content'),
            ),
          ),
        ),
      );

      final switcher =
          tester.widget<AnimatedSwitcher>(find.byType(AnimatedSwitcher));
      expect(switcher.duration, const Duration(milliseconds: 500));
    });

    testWidgets('uses KeyedSubtree for proper identity', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const AnimatedResponsiveTransition(
              mobile: Text('Mobile'),
            ),
          ),
        ),
      );

      expect(find.byType(KeyedSubtree), findsWidgets);
    });

    testWidgets('fade transition type works', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const AnimatedResponsiveTransition(
              transition: ResponsiveTransitionType.fade,
              mobile: Text('Fade'),
            ),
          ),
        ),
      );

      expect(find.text('Fade'), findsOneWidget);
    });

    testWidgets('fadeSlide transition type works', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const AnimatedResponsiveTransition(
              transition: ResponsiveTransitionType.fadeSlide,
              mobile: Text('FadeSlide'),
            ),
          ),
        ),
      );

      expect(find.text('FadeSlide'), findsOneWidget);
    });

    testWidgets('scale transition type works', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const AnimatedResponsiveTransition(
              transition: ResponsiveTransitionType.scale,
              mobile: Text('Scale'),
            ),
          ),
        ),
      );

      expect(find.text('Scale'), findsOneWidget);
    });

    testWidgets('fadeScale transition type works', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const AnimatedResponsiveTransition(
              transition: ResponsiveTransitionType.fadeScale,
              mobile: Text('FadeScale'),
            ),
          ),
        ),
      );

      expect(find.text('FadeScale'), findsOneWidget);
    });
  });
}
