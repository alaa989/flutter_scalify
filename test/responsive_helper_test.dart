import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';

void main() {
  group('ResponsiveHelper', () {
    late ResponsiveHelper mobileHelper;
    late ResponsiveHelper tabletHelper;
    late ResponsiveHelper desktopHelper;

    setUp(() {
      const config = ScalifyConfig();
      mobileHelper = ResponsiveHelper.fromData(
        ResponsiveData.fromMediaQuery(
          const MediaQueryData(size: Size(375, 812)),
          config,
        ),
      );
      tabletHelper = ResponsiveHelper.fromData(
        ResponsiveData.fromMediaQuery(
          const MediaQueryData(size: Size(768, 1024)),
          config,
        ),
      );
      desktopHelper = ResponsiveHelper.fromData(
        ResponsiveData.fromMediaQuery(
          const MediaQueryData(size: Size(1440, 900)),
          config,
        ),
      );
    });

    test('screenType is correct', () {
      expect(mobileHelper.screenType, ScreenType.mobile);
      expect(tabletHelper.screenType, ScreenType.tablet);
      expect(desktopHelper.screenType, ScreenType.desktop);
    });

    test('isSmallScreen', () {
      expect(mobileHelper.isSmallScreen, true);
      expect(tabletHelper.isSmallScreen, false);
      expect(desktopHelper.isSmallScreen, false);
    });

    test('isMediumScreen', () {
      expect(mobileHelper.isMediumScreen, false);
      expect(tabletHelper.isMediumScreen, true);
      expect(desktopHelper.isMediumScreen, false);
    });

    test('isLargeScreen', () {
      expect(mobileHelper.isLargeScreen, false);
      expect(tabletHelper.isLargeScreen, false);
      expect(desktopHelper.isLargeScreen, true);
    });

    test('scale returns value * scaleFactor', () {
      final factor = mobileHelper.data.scaleFactor;
      expect(mobileHelper.scale(10), 10 * factor);
    });

    test('scaleWidth returns value * scaleWidth', () {
      final sw = mobileHelper.data.scaleWidth;
      expect(mobileHelper.scaleWidth(10), 10 * sw);
    });

    test('scaleHeight returns value * scaleHeight', () {
      final sh = mobileHelper.data.scaleHeight;
      expect(mobileHelper.scaleHeight(10), 10 * sh);
    });

    test('autoScaleInt returns rounded scaled value', () {
      final scaled = mobileHelper.autoScaleInt(10);
      expect(scaled, isA<int>());
      expect(scaled, (10 * mobileHelper.data.scaleFactor).round());
    });

    group('valueByScreen', () {
      test('returns mobile value for mobile', () {
        final result = mobileHelper.valueByScreen<String>(
          mobile: 'mobile',
          tablet: 'tablet',
          desktop: 'desktop',
        );
        expect(result, 'mobile');
      });

      test('returns tablet value for tablet', () {
        final result = tabletHelper.valueByScreen<String>(
          mobile: 'mobile',
          tablet: 'tablet',
        );
        expect(result, 'tablet');
      });

      test('returns desktop value for desktop', () {
        final result = desktopHelper.valueByScreen<String>(
          mobile: 'mobile',
          desktop: 'desktop',
        );
        expect(result, 'desktop');
      });

      test('tablet falls back to mobile when not specified', () {
        final result = tabletHelper.valueByScreen<String>(
          mobile: 'mobile',
        );
        expect(result, 'mobile');
      });

      test('desktop falls back to smallDesktop → tablet → mobile', () {
        final result = desktopHelper.valueByScreen<String>(
          mobile: 'mobile',
        );
        expect(result, 'mobile');

        final result2 = desktopHelper.valueByScreen<String>(
          mobile: 'mobile',
          tablet: 'tablet',
        );
        expect(result2, 'tablet');

        final result3 = desktopHelper.valueByScreen<String>(
          mobile: 'mobile',
          smallDesktop: 'smallDesktop',
        );
        expect(result3, 'smallDesktop');
      });

      test('largeDesktop falls back correctly', () {
        const config = ScalifyConfig();
        final largeDesktopHelper = ResponsiveHelper.fromData(
          ResponsiveData.fromMediaQuery(
            const MediaQueryData(size: Size(2560, 1440)),
            config,
          ),
        );

        // Falls back desktop → smallDesktop → tablet → mobile
        expect(
          largeDesktopHelper.valueByScreen<String>(mobile: 'mobile'),
          'mobile',
        );
        expect(
          largeDesktopHelper.valueByScreen<String>(
            mobile: 'mobile',
            tablet: 'tablet',
          ),
          'tablet',
        );
        expect(
          largeDesktopHelper.valueByScreen<String>(
            mobile: 'mobile',
            desktop: 'desktop',
          ),
          'desktop',
        );
        expect(
          largeDesktopHelper.valueByScreen<String>(
            mobile: 'mobile',
            largeDesktop: 'largeDesktop',
          ),
          'largeDesktop',
        );
      });

      test('watch falls back to mobile', () {
        const config = ScalifyConfig();
        final watchHelper = ResponsiveHelper.fromData(
          ResponsiveData.fromMediaQuery(
            const MediaQueryData(size: Size(200, 300)),
            config,
          ),
        );

        expect(
          watchHelper.valueByScreen<String>(mobile: 'mobile'),
          'mobile',
        );
        expect(
          watchHelper.valueByScreen<String>(mobile: 'mobile', watch: 'watch'),
          'watch',
        );
      });

      test('works with different types', () {
        final intResult = mobileHelper.valueByScreen<int>(
          mobile: 10,
          tablet: 20,
        );
        expect(intResult, 10);

        final doubleResult = mobileHelper.valueByScreen<double>(
          mobile: 10.0,
          tablet: 20.0,
        );
        expect(doubleResult, 10.0);
      });
    });

    test('textScaleFactor is accessible', () {
      expect(mobileHelper.textScaleFactor, isA<double>());
    });
  });
}
