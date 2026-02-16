import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';

void main() {
  group('ResponsiveData', () {
    group('identity', () {
      test('has default values', () {
        const data = ResponsiveData.identity;
        expect(data.size, const Size(375, 812));
        expect(data.textScaleFactor, 1.0);
        expect(data.screenType, ScreenType.mobile);
        expect(data.scaleWidth, 1.0);
        expect(data.scaleHeight, 1.0);
        expect(data.scaleFactor, 1.0);
      });

      test('quantized IDs are correct for identity', () {
        const data = ResponsiveData.identity;
        expect(data.scaleWidthId, 1000);
        expect(data.scaleHeightId, 1000);
        expect(data.scaleFactorId, 1000);
        expect(data.textScaleFactorId, 100);
      });
    });

    group('fromMediaQuery', () {
      test('returns identity when MediaQuery is null', () {
        final data = ResponsiveData.fromMediaQuery(null, const ScalifyConfig());
        expect(data, ResponsiveData.identity);
      });

      test('returns identity when width is 0', () {
        const mq = MediaQueryData(size: Size(0, 812));
        final data = ResponsiveData.fromMediaQuery(mq, const ScalifyConfig());
        expect(data, ResponsiveData.identity);
      });

      test('returns identity when height is 0', () {
        const mq = MediaQueryData(size: Size(375, 0));
        final data = ResponsiveData.fromMediaQuery(mq, const ScalifyConfig());
        expect(data, ResponsiveData.identity);
      });

      test('calculates correct scale for design size match', () {
        const config = ScalifyConfig(designWidth: 375, designHeight: 812);
        const mq = MediaQueryData(size: Size(375, 812));
        final data = ResponsiveData.fromMediaQuery(mq, config);

        expect(data.scaleWidth, 1.0);
        expect(data.scaleHeight, 1.0);
        expect(data.scaleFactor, 1.0);
      });

      test('calculates correct scale for double-width screen', () {
        const config = ScalifyConfig(designWidth: 375, designHeight: 812);
        const mq = MediaQueryData(size: Size(750, 812));
        final data = ResponsiveData.fromMediaQuery(mq, config);

        expect(data.scaleWidth, 2.0);
        expect(data.scaleHeight, 1.0);
        expect(data.scaleFactor, 1.0); // min(2.0, 1.0)
      });

      test('calculates correct scale for half-width screen', () {
        const config = ScalifyConfig(designWidth: 375, designHeight: 812);
        const mq = MediaQueryData(size: Size(187.5, 812));
        final data = ResponsiveData.fromMediaQuery(mq, config);

        expect(data.scaleWidth, 0.5);
        expect(data.scaleHeight, 1.0);
        expect(data.scaleFactor, 0.5); // min(0.5, 1.0)
      });

      test('clamps scale to minScale', () {
        const config =
            ScalifyConfig(designWidth: 375, designHeight: 812, minScale: 0.8);
        const mq = MediaQueryData(size: Size(100, 812));
        final data = ResponsiveData.fromMediaQuery(mq, config);

        expect(data.scaleWidth, 0.8); // 100/375 = 0.267 clamped to 0.8
      });

      test('clamps scale to maxScale', () {
        const config =
            ScalifyConfig(designWidth: 375, designHeight: 812, maxScale: 2.0);
        const mq = MediaQueryData(size: Size(1500, 812));
        final data = ResponsiveData.fromMediaQuery(mq, config);

        expect(data.scaleWidth, 2.0); // clamped
      });
    });

    group('screenType detection', () {
      const config = ScalifyConfig();

      test('watch < 300', () {
        const mq = MediaQueryData(size: Size(200, 400));
        final data = ResponsiveData.fromMediaQuery(mq, config);
        expect(data.screenType, ScreenType.watch);
      });

      test('mobile 300-600', () {
        const mq = MediaQueryData(size: Size(375, 812));
        final data = ResponsiveData.fromMediaQuery(mq, config);
        expect(data.screenType, ScreenType.mobile);
      });

      test('tablet 600-900', () {
        const mq = MediaQueryData(size: Size(768, 1024));
        final data = ResponsiveData.fromMediaQuery(mq, config);
        expect(data.screenType, ScreenType.tablet);
      });

      test('smallDesktop 900-1200', () {
        const mq = MediaQueryData(size: Size(1024, 768));
        final data = ResponsiveData.fromMediaQuery(mq, config);
        expect(data.screenType, ScreenType.smallDesktop);
      });

      test('desktop 1200-1800', () {
        const mq = MediaQueryData(size: Size(1440, 900));
        final data = ResponsiveData.fromMediaQuery(mq, config);
        expect(data.screenType, ScreenType.desktop);
      });

      test('largeDesktop > 1800', () {
        const mq = MediaQueryData(size: Size(2560, 1440));
        final data = ResponsiveData.fromMediaQuery(mq, config);
        expect(data.screenType, ScreenType.largeDesktop);
      });

      test('boundary: exactly 300 is mobile not watch', () {
        const mq = MediaQueryData(size: Size(300, 812));
        final data = ResponsiveData.fromMediaQuery(mq, config);
        expect(data.screenType, ScreenType.mobile);
      });

      test('boundary: exactly 600 is tablet not mobile', () {
        const mq = MediaQueryData(size: Size(600, 812));
        final data = ResponsiveData.fromMediaQuery(mq, config);
        expect(data.screenType, ScreenType.tablet);
      });

      test('boundary: exactly 1800 is largeDesktop', () {
        const mq = MediaQueryData(size: Size(1800, 900));
        final data = ResponsiveData.fromMediaQuery(mq, config);
        expect(data.screenType, ScreenType.largeDesktop);
      });
    });

    group('high-res dampening', () {
      test('applies dampening above memoryProtectionThreshold', () {
        const config = ScalifyConfig(
          designWidth: 375,
          memoryProtectionThreshold: 1920,
          highResScaleFactor: 0.65,
          maxScale: 10.0,
        );
        const mq = MediaQueryData(size: Size(2560, 1440));
        final data = ResponsiveData.fromMediaQuery(mq, config);

        // Manual calculation:
        // thresholdScale = 1920 / 375 = 5.12
        // excessWidth = 2560 - 1920 = 640
        // dampenedPart = (640 / 375) * 0.65 = 1.1093
        // total = 5.12 + 1.1093 = 6.2293
        const expected = (1920 / 375) + ((640 / 375) * 0.65);
        expect(data.scaleWidth, closeTo(expected, 0.01));
      });

      test('no dampening below threshold', () {
        const config = ScalifyConfig(
          designWidth: 375,
          memoryProtectionThreshold: 1920,
        );
        const mq = MediaQueryData(size: Size(1000, 812));
        final data = ResponsiveData.fromMediaQuery(mq, config);

        expect(data.scaleWidth, closeTo(1000 / 375, 0.01));
      });
    });

    group('autoSwapDimensions', () {
      test('swaps design dimensions in landscape', () {
        const config = ScalifyConfig(
          designWidth: 375,
          designHeight: 812,
          autoSwapDimensions: true,
        );
        // Landscape: width > height
        const mq = MediaQueryData(size: Size(812, 375));
        final data = ResponsiveData.fromMediaQuery(mq, config);

        // In landscape, designWidth becomes 812, designHeight becomes 375
        expect(data.scaleWidth, closeTo(812 / 812, 0.01)); // 1.0
        expect(data.scaleHeight, closeTo(375 / 375, 0.01)); // 1.0
      });

      test('does not swap in portrait', () {
        const config = ScalifyConfig(
          designWidth: 375,
          designHeight: 812,
          autoSwapDimensions: true,
        );
        const mq = MediaQueryData(size: Size(375, 812));
        final data = ResponsiveData.fromMediaQuery(mq, config);

        expect(data.scaleWidth, 1.0);
        expect(data.scaleHeight, 1.0);
      });
    });

    group('textScaleFactor', () {
      test('captures system text scale factor', () {
        const mq = MediaQueryData(
          size: Size(375, 812),
          textScaler: TextScaler.linear(1.5),
        );
        final data = ResponsiveData.fromMediaQuery(mq, const ScalifyConfig());
        expect(data.textScaleFactor, 1.5);
      });
    });

    group('helper getters', () {
      test('isSmallScreen for watch', () {
        const mq = MediaQueryData(size: Size(200, 400));
        final data = ResponsiveData.fromMediaQuery(mq, const ScalifyConfig());
        expect(data.isSmallScreen, true);
        expect(data.isMediumScreen, false);
        expect(data.isLargeScreen, false);
      });

      test('isSmallScreen for mobile', () {
        const mq = MediaQueryData(size: Size(375, 812));
        final data = ResponsiveData.fromMediaQuery(mq, const ScalifyConfig());
        expect(data.isSmallScreen, true);
      });

      test('isMediumScreen for tablet', () {
        const mq = MediaQueryData(size: Size(768, 1024));
        final data = ResponsiveData.fromMediaQuery(mq, const ScalifyConfig());
        expect(data.isMediumScreen, true);
      });

      test('isLargeScreen for desktop', () {
        const mq = MediaQueryData(size: Size(1440, 900));
        final data = ResponsiveData.fromMediaQuery(mq, const ScalifyConfig());
        expect(data.isLargeScreen, true);
      });

      test('width and height getters', () {
        const mq = MediaQueryData(size: Size(375, 812));
        final data = ResponsiveData.fromMediaQuery(mq, const ScalifyConfig());
        expect(data.width, 375);
        expect(data.height, 812);
      });

      test('isOverMaxWidth', () {
        const mq = MediaQueryData(size: Size(2000, 900));
        final data = ResponsiveData.fromMediaQuery(mq, const ScalifyConfig());
        expect(data.isOverMaxWidth, true);

        const mqSmall = MediaQueryData(size: Size(375, 812));
        final dataSmall =
            ResponsiveData.fromMediaQuery(mqSmall, const ScalifyConfig());
        expect(dataSmall.isOverMaxWidth, false);
      });
    });

    group('scaleFactor (combined)', () {
      test('uses min of width and height scale', () {
        const config = ScalifyConfig(designWidth: 375, designHeight: 812);
        const mq = MediaQueryData(size: Size(750, 812));
        final data = ResponsiveData.fromMediaQuery(mq, config);

        const expectedW = 750 / 375; // 2.0
        const expectedH = 812 / 812; // 1.0
        expect(data.scaleFactor, math.min(expectedW, expectedH));
      });
    });

    group('equality & hashCode', () {
      test('identical objects are equal', () {
        const data = ResponsiveData.identity;
        expect(data == data, true);
      });

      test('same values are equal', () {
        const config = ScalifyConfig();
        const mq = MediaQueryData(size: Size(375, 812));
        final a = ResponsiveData.fromMediaQuery(mq, config);
        final b = ResponsiveData.fromMediaQuery(mq, config);
        expect(a == b, true);
        expect(a.hashCode, b.hashCode);
      });

      test('different screen types are not equal', () {
        const config = ScalifyConfig();
        const mqMobile = MediaQueryData(size: Size(375, 812));
        const mqTablet = MediaQueryData(size: Size(768, 1024));
        final a = ResponsiveData.fromMediaQuery(mqMobile, config);
        final b = ResponsiveData.fromMediaQuery(mqTablet, config);
        expect(a == b, false);
      });

      test('small width difference within tolerance is equal', () {
        const config = ScalifyConfig(rebuildWidthPxThreshold: 4.0);
        const mqA = MediaQueryData(size: Size(375, 812));
        const mqB = MediaQueryData(size: Size(377, 812));
        final a = ResponsiveData.fromMediaQuery(mqA, config);
        final b = ResponsiveData.fromMediaQuery(mqB, config);
        // Difference 2px < 4px threshold, and scale difference
        // (377/375 - 1.0 = 0.00533) < rebuildScaleThreshold (0.01)
        // Both size and scale are within tolerance → equal
        expect(a == b, true);
      });

      test('not equal to non-ResponsiveData object', () {
        const data = ResponsiveData.identity;
        expect(data == Object(), false);
      });
    });
  });
}
