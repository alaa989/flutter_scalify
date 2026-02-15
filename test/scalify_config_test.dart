import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';

void main() {
  group('ScalifyConfig', () {
    test('default values are correct', () {
      const config = ScalifyConfig();
      expect(config.designWidth, 375.0);
      expect(config.designHeight, 812.0);
      expect(config.watchBreakpoint, 300.0);
      expect(config.mobileBreakpoint, 600.0);
      expect(config.tabletBreakpoint, 900.0);
      expect(config.smallDesktopBreakpoint, 1200.0);
      expect(config.desktopBreakpoint, 1800.0);
      expect(config.respectTextScaleFactor, true);
      expect(config.minScale, 0.5);
      expect(config.maxScale, 4.0);
      expect(config.minFontSize, 6.0);
      expect(config.maxFontSize, 256.0);
      expect(config.memoryProtectionThreshold, 1920.0);
      expect(config.highResScaleFactor, 0.65);
      expect(config.debounceWindowMillis, 120);
      expect(config.rebuildScaleThreshold, 0.01);
      expect(config.rebuildWidthPxThreshold, 4.0);
      expect(config.legacyContainerTierMapping, false);
      expect(config.enableGranularNotifications, false);
      expect(config.showDeprecationBanner, true);
      expect(config.minWidth, 0.0);
      expect(config.autoSwapDimensions, false);
    });

    test('custom values are accepted', () {
      const config = ScalifyConfig(
        designWidth: 414,
        designHeight: 896,
        minScale: 0.8,
        maxScale: 2.0,
        minFontSize: 10.0,
        maxFontSize: 100.0,
        autoSwapDimensions: true,
      );
      expect(config.designWidth, 414);
      expect(config.designHeight, 896);
      expect(config.minScale, 0.8);
      expect(config.maxScale, 2.0);
      expect(config.minFontSize, 10.0);
      expect(config.maxFontSize, 100.0);
      expect(config.autoSwapDimensions, true);
    });

    test('assert fails when minScale > maxScale', () {
      expect(
        () => ScalifyConfig(minScale: 3.0, maxScale: 1.0),
        throwsA(isA<AssertionError>()),
      );
    });

    test('assert fails when minFontSize > maxFontSize', () {
      expect(
        () => ScalifyConfig(minFontSize: 200.0, maxFontSize: 10.0),
        throwsA(isA<AssertionError>()),
      );
    });

    test('assert fails when designWidth <= 0', () {
      expect(
        () => ScalifyConfig(designWidth: 0),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => ScalifyConfig(designWidth: -1),
        throwsA(isA<AssertionError>()),
      );
    });

    test('assert fails when designHeight <= 0', () {
      expect(
        () => ScalifyConfig(designHeight: 0),
        throwsA(isA<AssertionError>()),
      );
    });

    test('is const constructible', () {
      // This verifies the const constructor works (compile-time check)
      const config = ScalifyConfig();
      expect(config, isNotNull);
    });

    group('copyWith', () {
      test('returns identical when no fields changed', () {
        const original = ScalifyConfig();
        final copy = original.copyWith();
        expect(copy.designWidth, original.designWidth);
        expect(copy.designHeight, original.designHeight);
        expect(copy.minScale, original.minScale);
        expect(copy.maxScale, original.maxScale);
        expect(copy.autoSwapDimensions, original.autoSwapDimensions);
      });

      test('overrides specified fields only', () {
        const original = ScalifyConfig();
        final copy = original.copyWith(
          designWidth: 414,
          minScale: 0.8,
          autoSwapDimensions: true,
        );
        expect(copy.designWidth, 414);
        expect(copy.minScale, 0.8);
        expect(copy.autoSwapDimensions, true);
        // Unchanged fields
        expect(copy.designHeight, original.designHeight);
        expect(copy.maxScale, original.maxScale);
        expect(copy.mobileBreakpoint, original.mobileBreakpoint);
      });

      test('all fields are copyable', () {
        const original = ScalifyConfig();
        final copy = original.copyWith(
          designWidth: 414,
          designHeight: 896,
          watchBreakpoint: 200,
          mobileBreakpoint: 500,
          tabletBreakpoint: 800,
          smallDesktopBreakpoint: 1100,
          desktopBreakpoint: 1700,
          respectTextScaleFactor: false,
          minScale: 0.3,
          maxScale: 5.0,
          minFontSize: 8.0,
          maxFontSize: 300.0,
          memoryProtectionThreshold: 2560,
          highResScaleFactor: 0.5,
          debounceWindowMillis: 200,
          rebuildScaleThreshold: 0.02,
          rebuildWidthPxThreshold: 8.0,
          legacyContainerTierMapping: true,
          enableGranularNotifications: true,
          showDeprecationBanner: false,
          minWidth: 320,
          autoSwapDimensions: true,
        );
        expect(copy.designWidth, 414);
        expect(copy.designHeight, 896);
        expect(copy.watchBreakpoint, 200);
        expect(copy.mobileBreakpoint, 500);
        expect(copy.tabletBreakpoint, 800);
        expect(copy.smallDesktopBreakpoint, 1100);
        expect(copy.desktopBreakpoint, 1700);
        expect(copy.respectTextScaleFactor, false);
        expect(copy.minScale, 0.3);
        expect(copy.maxScale, 5.0);
        expect(copy.minFontSize, 8.0);
        expect(copy.maxFontSize, 300.0);
        expect(copy.memoryProtectionThreshold, 2560);
        expect(copy.highResScaleFactor, 0.5);
        expect(copy.debounceWindowMillis, 200);
        expect(copy.rebuildScaleThreshold, 0.02);
        expect(copy.rebuildWidthPxThreshold, 8.0);
        expect(copy.legacyContainerTierMapping, true);
        expect(copy.enableGranularNotifications, true);
        expect(copy.showDeprecationBanner, false);
        expect(copy.minWidth, 320);
        expect(copy.autoSwapDimensions, true);
      });
    });
  });
}
