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

  group('ScalifyBox', () {
    testWidgets('provides LocalScaler to builder', (tester) async {
      late LocalScaler capturedScaler;

      await pumpApp(
        tester,
        buildApp(
          size: const Size(375, 812),
          child: SizedBox(
            width: 320,
            height: 200,
            child: ScalifyBox(
              referenceWidth: 320,
              referenceHeight: 200,
              builder: (context, ls) {
                capturedScaler = ls;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(capturedScaler, isA<LocalScaler>());
      expect(capturedScaler.scaleFactor, closeTo(1.0, 0.01));
    });

    testWidgets('scales when container is wider than reference',
        (tester) async {
      late LocalScaler capturedScaler;

      await pumpApp(
        tester,
        buildApp(
          size: const Size(375, 812),
          child: SizedBox(
            width: 640,
            height: 400,
            child: ScalifyBox(
              referenceWidth: 320,
              referenceHeight: 200,
              fit: ScalifyFit.width,
              builder: (context, ls) {
                capturedScaler = ls;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(capturedScaler.scaleFactor, closeTo(2.0, 0.01));
    });

    testWidgets('contain fit uses smaller dimension', (tester) async {
      late LocalScaler capturedScaler;

      await pumpApp(
        tester,
        buildApp(
          size: const Size(375, 812),
          child: SizedBox(
            width: 640,
            height: 200,
            child: ScalifyBox(
              referenceWidth: 320,
              referenceHeight: 200,
              fit: ScalifyFit.contain,
              builder: (context, ls) {
                capturedScaler = ls;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(capturedScaler.scaleFactor, closeTo(1.0, 0.01));
    });

    testWidgets('cover fit uses larger dimension', (tester) async {
      late LocalScaler capturedScaler;

      await pumpApp(
        tester,
        buildApp(
          size: const Size(375, 812),
          child: SizedBox(
            width: 640,
            height: 200,
            child: ScalifyBox(
              referenceWidth: 320,
              referenceHeight: 200,
              fit: ScalifyFit.cover,
              builder: (context, ls) {
                capturedScaler = ls;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(capturedScaler.scaleFactor, closeTo(2.0, 0.01));
    });

    testWidgets('height fit uses scaleY', (tester) async {
      late LocalScaler capturedScaler;

      await pumpApp(
        tester,
        buildApp(
          size: const Size(375, 812),
          child: SizedBox(
            width: 320,
            height: 400,
            child: ScalifyBox(
              referenceWidth: 320,
              referenceHeight: 200,
              fit: ScalifyFit.height,
              builder: (context, ls) {
                capturedScaler = ls;
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(capturedScaler.scaleFactor, closeTo(2.0, 0.01));
    });
  });

  group('LocalScaler', () {
    test('s scales value', () {
      const ls = LocalScaler(2.0);
      expect(ls.s(10), 20.0);
    });

    test('fz clamps font size', () {
      const ls = LocalScaler(0.1);
      expect(ls.fz(10), 4.0);

      const lsBig = LocalScaler(100.0);
      expect(lsBig.fz(10), 400.0);
    });

    test('si returns rounded int', () {
      const ls = LocalScaler(1.5);
      expect(ls.si(10), 15);
      expect(ls.si(3), 5);
    });

    test('w and h scale like s', () {
      const ls = LocalScaler(2.0);
      expect(ls.w(100), 200.0);
      expect(ls.h(50), 100.0);
    });

    test('iz scales icon size', () {
      const ls = LocalScaler(1.5);
      expect(ls.iz(24), 36.0);
    });

    test('sbh returns SizedBox with scaled height', () {
      const ls = LocalScaler(2.0);
      final sb = ls.sbh(10);
      expect(sb, isA<SizedBox>());
      expect(sb.height, 20.0);
    });

    test('sbw returns SizedBox with scaled width', () {
      const ls = LocalScaler(2.0);
      final sb = ls.sbw(10);
      expect(sb.width, 20.0);
    });

    test('p returns EdgeInsets.all scaled', () {
      const ls = LocalScaler(2.0);
      final p = ls.p(16);
      expect(p, const EdgeInsets.all(32));
    });

    test('ph returns horizontal EdgeInsets scaled', () {
      const ls = LocalScaler(2.0);
      final p = ls.ph(16);
      expect(p, const EdgeInsets.symmetric(horizontal: 32));
    });

    test('pv returns vertical EdgeInsets scaled', () {
      const ls = LocalScaler(2.0);
      final p = ls.pv(16);
      expect(p, const EdgeInsets.symmetric(vertical: 32));
    });

    test('br returns circular BorderRadius scaled', () {
      const ls = LocalScaler(2.0);
      final br = ls.br(12);
      expect(br, BorderRadius.circular(24));
    });

    test('r returns circular Radius scaled', () {
      const ls = LocalScaler(2.0);
      final r = ls.r(12);
      expect(r, const Radius.circular(24));
    });

    test('scaleFactor getter returns the scale', () {
      const ls = LocalScaler(3.0);
      expect(ls.scaleFactor, 3.0);
    });
  });
}
