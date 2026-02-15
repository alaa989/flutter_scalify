import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';

void main() {
  // GlobalResponsive.update uses WidgetsBinding internally
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GlobalResponsive', () {
    testWidgets('data returns identity by default',
        (WidgetTester tester) async {
      // Reset by updating identity
      GlobalResponsive.update(ResponsiveData.identity);
      expect(GlobalResponsive.data, ResponsiveData.identity);
      expect(GlobalResponsive.data.scaleWidth, 1.0);
      expect(GlobalResponsive.data.scaleHeight, 1.0);
    });

    testWidgets('update changes the global data', (WidgetTester tester) async {
      const config = ScalifyConfig(designWidth: 375, designHeight: 812);
      const mq = MediaQueryData(size: Size(750, 812));
      final newData = ResponsiveData.fromMediaQuery(mq, config);

      GlobalResponsive.update(newData);

      expect(GlobalResponsive.data.scaleWidth, closeTo(2.0, 0.01));
      expect(GlobalResponsive.data.size, const Size(750, 812));

      // Cleanup
      GlobalResponsive.update(ResponsiveData.identity);
    });

    testWidgets('multiple updates reflect the latest',
        (WidgetTester tester) async {
      const config = ScalifyConfig();
      const mq1 = MediaQueryData(size: Size(375, 812));
      const mq2 = MediaQueryData(size: Size(768, 1024));

      GlobalResponsive.update(ResponsiveData.fromMediaQuery(mq1, config));
      expect(GlobalResponsive.data.screenType, ScreenType.mobile);

      GlobalResponsive.update(ResponsiveData.fromMediaQuery(mq2, config));
      expect(GlobalResponsive.data.screenType, ScreenType.tablet);

      // Cleanup
      GlobalResponsive.update(ResponsiveData.identity);
    });
  });
}
