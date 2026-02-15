import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';
import 'test_helpers.dart';

void main() {
  // Ensure GlobalResponsive uses identity for predictable results
  setUp(() {
    GlobalResponsive.update(ResponsiveData.identity);
  });

  group('ResponsiveExtension on num', () {
    group('with identity scale (1.0)', () {
      test('.w returns value * scaleWidth', () {
        expect(100.w, 100.0);
      });

      test('.h returns value * scaleHeight', () {
        expect(50.h, 50.0);
      });

      test('.s returns value * scaleFactor', () {
        expect(20.s, 20.0);
      });

      test('.r returns value * min(scaleWidth, scaleHeight)', () {
        expect(12.r, 12.0);
      });

      test('.fz returns clamped font size', () {
        expect(16.fz, 16.0);
      });

      test('.iz returns icon size (alias for .s)', () {
        expect(24.iz, 24.0);
      });

      test('.sc returns same as .s', () {
        expect(20.sc, 20.s);
      });

      test('.ui returns same as .s', () {
        expect(20.ui, 20.s);
      });

      test('.si returns rounded integer', () {
        expect(10.si, 10);
        expect(10.si, isA<int>());
      });
    });

    group('with custom scale', () {
      setUp(() {
        const config = ScalifyConfig(designWidth: 375, designHeight: 812);
        const mq = MediaQueryData(size: Size(750, 1624));
        final data = ResponsiveData.fromMediaQuery(mq, config);
        GlobalResponsive.update(data);
      });

      tearDown(() {
        GlobalResponsive.update(ResponsiveData.identity);
      });

      test('.w doubles when screen is 2x design width', () {
        expect(100.w, closeTo(200, 0.1));
      });

      test('.h doubles when screen is 2x design height', () {
        expect(50.h, closeTo(100, 0.1));
      });

      test('.s uses min of width/height scale', () {
        final data = GlobalResponsive.data;
        expect(20.s, closeTo(20 * data.scaleFactor, 0.1));
      });
    });

    group('.fz font clamping', () {
      test('respects minFontSize', () {
        expect(2.fz, 6.0);
      });

      test('respects maxFontSize', () {
        const config = ScalifyConfig(
          designWidth: 100,
          designHeight: 100,
          maxFontSize: 50.0,
          maxScale: 10.0,
        );
        const mq = MediaQueryData(size: Size(1000, 1000));
        final data = ResponsiveData.fromMediaQuery(mq, config);
        GlobalResponsive.update(data);

        expect(100.fz, 50.0);

        GlobalResponsive.update(ResponsiveData.identity);
      });

      test('respects textScaleFactor when enabled', () {
        const config = ScalifyConfig(
          designWidth: 375,
          designHeight: 812,
          respectTextScaleFactor: true,
        );
        const mq = MediaQueryData(
          size: Size(375, 812),
          textScaler: TextScaler.linear(2.0),
        );
        final data = ResponsiveData.fromMediaQuery(mq, config);
        GlobalResponsive.update(data);

        expect(16.fz, closeTo(32, 0.1));

        GlobalResponsive.update(ResponsiveData.identity);
      });
    });

    group('percentage scaling', () {
      test('.pw returns percentage of screen width', () {
        expect(50.pw, closeTo(375 * 0.5, 0.1));
      });

      test('.hp returns percentage of screen height', () {
        expect(50.hp, closeTo(812 * 0.5, 0.1));
      });

      test('100.pw equals full screen width', () {
        expect(100.pw, closeTo(375, 0.1));
      });

      test('0.pw equals zero', () {
        expect(0.pw, 0.0);
      });
    });

    group('works with int and double', () {
      test('int extensions work', () {
        expect(10.w, isA<double>());
        expect(10.h, isA<double>());
        expect(10.s, isA<double>());
        expect(10.fz, isA<double>());
      });

      test('double extensions work', () {
        expect(10.5.w, isA<double>());
        expect(10.5.h, isA<double>());
        expect(10.5.s, isA<double>());
      });
    });
  });

  group('Spacing Extensions', () {
    test('.sbh returns SizedBox with height', () {
      final sb = 20.sbh;
      expect(sb, isA<SizedBox>());
      expect(sb.height, 20.h);
    });

    test('.sbw returns SizedBox with width', () {
      final sb = 10.sbw;
      expect(sb, isA<SizedBox>());
      expect(sb.width, 10.w);
    });

    test('.sbhw returns SizedBox with both', () {
      final sb = 20.sbhw(width: 10);
      expect(sb, isA<SizedBox>());
      expect(sb.height, 20.h);
      expect(sb.width, 10.w);
    });

    test('.sbhw with null width', () {
      final sb = 20.sbhw();
      expect(sb.height, 20.h);
      expect(sb.width, isNull);
    });

    test('.sbwh returns SizedBox with both', () {
      final sb = 10.sbwh(height: 20);
      expect(sb.width, 10.w);
      expect(sb.height, 20.h);
    });

    test('.sbwh with null height', () {
      final sb = 10.sbwh();
      expect(sb.width, 10.w);
      expect(sb.height, isNull);
    });
  });

  group('Padding Extensions', () {
    test('.p returns EdgeInsets.all', () {
      final p = 16.p;
      expect(p, isA<EdgeInsets>());
      expect(p.left, 16.s);
      expect(p.right, 16.s);
      expect(p.top, 16.s);
      expect(p.bottom, 16.s);
    });

    test('.ph returns horizontal padding', () {
      final p = 16.ph;
      expect(p.left, 16.w);
      expect(p.right, 16.w);
      expect(p.top, 0);
      expect(p.bottom, 0);
    });

    test('.pv returns vertical padding', () {
      final p = 16.pv;
      expect(p.top, 16.h);
      expect(p.bottom, 16.h);
      expect(p.left, 0);
      expect(p.right, 0);
    });

    test('.pt returns top-only padding', () {
      final p = 16.pt;
      expect(p.top, 16.h);
      expect(p.bottom, 0);
      expect(p.left, 0);
      expect(p.right, 0);
    });

    test('.pb returns bottom-only padding', () {
      final p = 16.pb;
      expect(p.bottom, 16.h);
      expect(p.top, 0);
    });

    test('.pl returns left-only padding', () {
      final p = 16.pl;
      expect(p.left, 16.w);
      expect(p.right, 0);
    });

    test('.pr returns right-only padding', () {
      final p = 16.pr;
      expect(p.right, 16.w);
      expect(p.left, 0);
    });
  });

  group('BorderRadius Extensions', () {
    test('.br returns circular radius', () {
      final br = 12.br;
      expect(br, isA<BorderRadius>());
      expect(br.topLeft, Radius.circular(12.r));
      expect(br.bottomRight, Radius.circular(12.r));
    });

    test('.brt returns top-only radius', () {
      final br = 12.brt;
      expect(br.topLeft, Radius.circular(12.r));
      expect(br.topRight, Radius.circular(12.r));
      expect(br.bottomLeft, Radius.zero);
      expect(br.bottomRight, Radius.zero);
    });

    test('.brb returns bottom-only radius', () {
      final br = 12.brb;
      expect(br.bottomLeft, Radius.circular(12.r));
      expect(br.bottomRight, Radius.circular(12.r));
      expect(br.topLeft, Radius.zero);
      expect(br.topRight, Radius.zero);
    });

    test('.brl returns left-only radius', () {
      final br = 12.brl;
      expect(br.topLeft, Radius.circular(12.r));
      expect(br.bottomLeft, Radius.circular(12.r));
      expect(br.topRight, Radius.zero);
      expect(br.bottomRight, Radius.zero);
    });

    test('.brr returns right-only radius', () {
      final br = 12.brr;
      expect(br.topRight, Radius.circular(12.r));
      expect(br.bottomRight, Radius.circular(12.r));
      expect(br.topLeft, Radius.zero);
      expect(br.bottomLeft, Radius.zero);
    });
  });

  group('EdgeInsetsListExtension', () {
    test('list of 1 returns EdgeInsets.all', () {
      final p = [16].p;
      expect(p, EdgeInsets.all(16.s));
    });

    test('list of 2 returns symmetric padding', () {
      final p = [20, 10].p;
      expect(p, EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h));
    });

    test('list of 4 returns LTRB padding', () {
      final p = [10, 20, 30, 40].p;
      expect(p, EdgeInsets.fromLTRB(10.w, 20.h, 30.w, 40.h));
    });

    test('list of 3 throws ArgumentError', () {
      expect(() => [10, 20, 30].p, throwsArgumentError);
    });

    test('empty list throws ArgumentError', () {
      expect(() => <num>[].p, throwsArgumentError);
    });

    test('list of 5 throws ArgumentError', () {
      expect(() => [1, 2, 3, 4, 5].p, throwsArgumentError);
    });
  });

  group('ResponsiveContext (context extensions)', () {
    testWidgets('context.responsiveData returns data', (tester) async {
      late ResponsiveData capturedData;

      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: Builder(
              builder: (context) {
                capturedData = context.responsiveData;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(capturedData, isA<ResponsiveData>());
      expect(capturedData.screenType, ScreenType.mobile);
    });

    testWidgets('context.w scales by width', (tester) async {
      late double result;

      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(750, 812)),
          child: ScalifyProvider(
            config: const ScalifyConfig(designWidth: 375),
            builder: (context, child) => MaterialApp(home: child),
            child: Builder(
              builder: (context) {
                result = context.w(100);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(result, closeTo(200, 1));
    });

    testWidgets('context.h scales by height', (tester) async {
      late double result;

      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 1624)),
          child: ScalifyProvider(
            config: const ScalifyConfig(designHeight: 812),
            builder: (context, child) => MaterialApp(home: child),
            child: Builder(
              builder: (context) {
                result = context.h(100);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(result, closeTo(200, 1));
    });

    testWidgets('context.valueByScreen returns correct value', (tester) async {
      late String result;

      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(768, 1024)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: Builder(
              builder: (context) {
                result = context.valueByScreen<String>(
                  mobile: 'mobile',
                  tablet: 'tablet',
                  desktop: 'desktop',
                );
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(result, 'tablet');
    });

    testWidgets('context.responsiveHelper is accessible', (tester) async {
      late ResponsiveHelper helper;

      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: Builder(
              builder: (context) {
                helper = context.responsiveHelper;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(helper, isA<ResponsiveHelper>());
      expect(helper.screenType, ScreenType.mobile);
    });
  });
}
