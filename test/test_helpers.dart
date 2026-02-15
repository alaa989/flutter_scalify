import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';

/// Wraps [child] in ScalifyProvider → MaterialApp for testing.
///
/// ScalifyProvider is the PARENT of MaterialApp (matching the recommended
/// real-world pattern). This avoids cascading rebuilds on MediaQuery changes
/// because ScalifyProvider intercepts them before MaterialApp sees them.
Widget buildTestApp({
  required Widget child,
  Size screenSize = const Size(375, 812),
  ScalifyConfig config = const ScalifyConfig(),
  double textScaleFactor = 1.0,
}) {
  return MediaQuery(
    data: MediaQueryData(
      size: screenSize,
      textScaler: TextScaler.linear(textScaleFactor),
    ),
    child: ScalifyProvider(
      config: config,
      builder: (context, c) => MaterialApp(
        home: c,
      ),
      child: child,
    ),
  );
}

/// Creates a MediaQueryData for a given screen size.
MediaQueryData mediaQueryFor({
  double width = 375,
  double height = 812,
  double textScaleFactor = 1.0,
}) {
  return MediaQueryData(
    size: Size(width, height),
    textScaler: TextScaler.linear(textScaleFactor),
  );
}

/// Pumps the widget and then advances past the ScalifyProvider debounce timer.
///
/// Use this instead of `tester.pumpWidget(...)` + `tester.pumpAndSettle()`
/// when testing with ScalifyProvider. This is much faster because it only
/// advances by 20ms instead of waiting for the entire frame pipeline to idle.
Future<void> pumpApp(WidgetTester tester, Widget app) async {
  await tester.pumpWidget(app);
  // Advance past the debounce timer (default 16ms) so ScalifyProvider
  // computes and propagates ResponsiveData to all descendants.
  await tester.pump(const Duration(milliseconds: 20));
}
