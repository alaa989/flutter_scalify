import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';
import 'test_helpers.dart';

void main() {
  group('ScalifySection', () {
    testWidgets('scales based on section width, not screen width',
        (tester) async {
      late ResponsiveData sectionData;

      final app = MediaQuery(
        data: const MediaQueryData(size: Size(1200, 800)),
        child: ScalifyProvider(
          config: const ScalifyConfig(designWidth: 375, designHeight: 812),
          builder: (context, child) => MaterialApp(home: child),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 600,
              height: 800,
              child: ScalifySection(
                child: Builder(
                  builder: (context) {
                    sectionData = ScalifyProvider.of(context);
                    return const Text('Content');
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await pumpApp(tester, app);
      await tester.pump(const Duration(milliseconds: 200));

      // The section should see width 600, not 1200
      expect(sectionData.size.width, closeTo(600, 1));
      // scaleWidth should be 600/375 = 1.6
      expect(sectionData.scaleWidth, closeTo(600 / 375, 0.05));
    });

    testWidgets('inherits config from parent ScalifyProvider', (tester) async {
      late ResponsiveData sectionData;
      const testConfig = ScalifyConfig(
        designWidth: 400,
        designHeight: 900,
      );

      final app = MediaQuery(
        data: const MediaQueryData(size: Size(800, 600)),
        child: ScalifyProvider(
          config: testConfig,
          builder: (context, child) => MaterialApp(home: child),
          child: ScalifySection(
            child: Builder(
              builder: (context) {
                sectionData = ScalifyProvider.of(context);
                return const Text('Content');
              },
            ),
          ),
        ),
      );

      await pumpApp(tester, app);
      await tester.pump(const Duration(milliseconds: 200));

      // Should inherit designWidth: 400 from parent
      expect(sectionData.config.designWidth, 400);
      expect(sectionData.config.designHeight, 900);
    });

    testWidgets('accepts custom config override', (tester) async {
      late ResponsiveData sectionData;
      const parentConfig = ScalifyConfig(designWidth: 375);
      const sectionConfig = ScalifyConfig(designWidth: 500);

      final app = MediaQuery(
        data: const MediaQueryData(size: Size(800, 600)),
        child: ScalifyProvider(
          config: parentConfig,
          builder: (context, child) => MaterialApp(home: child),
          child: ScalifySection(
            config: sectionConfig,
            child: Builder(
              builder: (context) {
                sectionData = ScalifyProvider.of(context);
                return const Text('Content');
              },
            ),
          ),
        ),
      );

      await pumpApp(tester, app);
      await tester.pump(const Duration(milliseconds: 200));

      // Should use the overridden config, not parent
      expect(sectionData.config.designWidth, 500);
    });

    testWidgets('multiple sections have independent scaling', (tester) async {
      late ResponsiveData sidebarData;
      late ResponsiveData contentData;

      final app = MediaQuery(
        data: const MediaQueryData(size: Size(1200, 800)),
        child: ScalifyProvider(
          config: const ScalifyConfig(designWidth: 375, designHeight: 812),
          builder: (context, child) => MaterialApp(home: child),
          child: Row(
            children: [
              // Sidebar — 300px
              SizedBox(
                width: 300,
                child: ScalifySection(
                  child: Builder(
                    builder: (context) {
                      sidebarData = ScalifyProvider.of(context);
                      return const Text('Sidebar');
                    },
                  ),
                ),
              ),
              // Main content — takes remaining space
              Expanded(
                child: ScalifySection(
                  child: Builder(
                    builder: (context) {
                      contentData = ScalifyProvider.of(context);
                      return const Text('Content');
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      await pumpApp(tester, app);
      await tester.pump(const Duration(milliseconds: 200));

      // Sidebar should have width 300
      expect(sidebarData.size.width, closeTo(300, 1));

      // They should have different scale widths
      expect(sidebarData.scaleWidth, closeTo(300 / 375, 0.05));
      // Content width will be remaining - should be different from sidebar
      expect(contentData.scaleWidth != sidebarData.scaleWidth, isTrue);
    });

    testWidgets('context extensions use section width inside ScalifySection',
        (tester) async {
      late double contextW100;
      late double contextFz16;
      late ResponsiveData sectionData;

      final app = MediaQuery(
        data: const MediaQueryData(size: Size(1200, 800)),
        child: ScalifyProvider(
          config: const ScalifyConfig(designWidth: 375, designHeight: 812),
          builder: (context, child) => MaterialApp(home: child),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              width: 600,
              height: 800,
              child: ScalifySection(
                child: Builder(
                  builder: (context) {
                    sectionData = ScalifyProvider.of(context);
                    contextW100 = context.w(100);
                    contextFz16 = context.fz(16);
                    return const Text('Content');
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await pumpApp(tester, app);
      await tester.pump(const Duration(milliseconds: 200));

      // context.w(100) should be based on section width (600px)
      // scaleWidth = 600/375 = 1.6, so context.w(100) ≈ 160
      final expectedW = 100 * sectionData.scaleWidth;
      expect(contextW100, closeTo(expectedW, 1));

      // context.fz(16) should use the section's scaleFactor
      expect(contextFz16, greaterThan(0));
      // Should be scaled based on section, not the full 1200px screen
      final expectedFz = (16 * sectionData.scaleFactor).clamp(6.0, 256.0);
      expect(contextFz16, closeTo(expectedFz, 1));
    });
  });
}
