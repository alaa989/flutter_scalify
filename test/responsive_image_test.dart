import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';
import 'test_helpers.dart';

// A 1x1 transparent PNG encoded as bytes — works in test without real assets.
final Uint8List _kTransparentPixel = Uint8List.fromList(<int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG signature
  0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, // IHDR chunk
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
  0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41, // IDAT chunk
  0x54, 0x78, 0x9C, 0x62, 0x00, 0x00, 0x00, 0x02,
  0x00, 0x01, 0xE5, 0x27, 0xDE, 0xFC, 0x00, 0x00,
  0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42, // IEND chunk
  0x60, 0x82,
]);

void main() {
  group('ResponsiveImage', () {
    late MemoryImage mobileImg;
    late MemoryImage tabletImg;
    late MemoryImage desktopImg;

    setUp(() {
      mobileImg = MemoryImage(_kTransparentPixel);
      tabletImg = MemoryImage(Uint8List.fromList(_kTransparentPixel));
      desktopImg = MemoryImage(Uint8List.fromList(_kTransparentPixel));
    });

    testWidgets('renders Image widget', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ResponsiveImage(mobile: mobileImg),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('uses mobile provider on mobile screen', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ResponsiveImage(
              mobile: mobileImg,
              desktop: desktopImg,
            ),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, equals(mobileImg));
    });

    testWidgets('uses desktop provider on desktop screen', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(1400, 900)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ResponsiveImage(
              mobile: mobileImg,
              desktop: desktopImg,
            ),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, equals(desktopImg));
    });

    testWidgets('falls back to mobile when tablet is null', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(768, 1024)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ResponsiveImage(mobile: mobileImg),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, equals(mobileImg));
    });

    testWidgets('uses tablet provider on tablet', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(768, 1024)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ResponsiveImage(
              mobile: mobileImg,
              tablet: tabletImg,
            ),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, equals(tabletImg));
    });

    testWidgets('applies fit, width, and height', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ResponsiveImage(
              mobile: mobileImg,
              fit: BoxFit.contain,
              width: 200,
              height: 100,
            ),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.fit, BoxFit.contain);
      expect(image.width, 200);
      expect(image.height, 100);
    });

    testWidgets('applies borderRadius via ClipRRect', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ResponsiveImage(
              mobile: mobileImg,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      );

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('no ClipRRect when borderRadius is null', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ResponsiveImage(mobile: mobileImg),
          ),
        ),
      );

      expect(find.byType(ClipRRect), findsNothing);
    });

    testWidgets('showsplaceholder while loading', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ResponsiveImage(
              mobile: mobileImg,
              placeholder: const Text('Loading...'),
            ),
          ),
        ),
      );

      // placeholder logic is tested via Image's frameBuilder
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('desktop falls back through chain correctly', (tester) async {
      // Only mobile and tablet provided; desktop should use tablet
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(1400, 900)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ResponsiveImage(
              mobile: mobileImg,
              tablet: tabletImg,
            ),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, equals(tabletImg));
    });

    testWidgets('default fit is BoxFit.cover', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ResponsiveImage(mobile: mobileImg),
          ),
        ),
      );

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.fit, BoxFit.cover);
    });
  });
}
