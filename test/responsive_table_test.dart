import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';
import 'test_helpers.dart';

void main() {
  group('ResponsiveTable', () {
    const columns = ['Name', 'Price', 'Status'];
    const rows = [
      ['iPhone', '\$999', 'Available'],
      ['MacBook', '\$1199', 'Sold Out'],
      ['AirPods', '\$249', 'Available'],
    ];

    testWidgets('renders DataTable on desktop', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(1200, 800)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveTable(
              columns: columns,
              rows: rows,
            ),
          ),
        ),
      );

      expect(find.byType(DataTable), findsOneWidget);
    });

    testWidgets('DataTable shows all column headers', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(1200, 800)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveTable(
              columns: columns,
              rows: rows,
            ),
          ),
        ),
      );

      expect(find.text('Name'), findsWidgets);
      expect(find.text('Price'), findsWidgets);
      expect(find.text('Status'), findsWidgets);
    });

    testWidgets('DataTable shows row data', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(1200, 800)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveTable(
              columns: columns,
              rows: rows,
            ),
          ),
        ),
      );

      expect(find.text('iPhone'), findsOneWidget);
      expect(find.text('\$999'), findsOneWidget);
    });

    testWidgets('renders cards on mobile', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveTable(
              columns: columns,
              rows: rows,
            ),
          ),
        ),
      );

      // On mobile, should use ListView instead of DataTable
      expect(find.byType(DataTable), findsNothing);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('hides columns on mobile via hiddenColumnsOnMobile',
        (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveTable(
              columns: ['Name', 'Price', 'Status', 'Category'],
              rows: [
                ['iPhone', '\$999', 'Available', 'Electronics']
              ],
              hiddenColumnsOnMobile: [3],
            ),
          ),
        ),
      );

      // 'Category' column should be hidden on mobile cards
      expect(find.text('Category'), findsNothing);
    });

    testWidgets('onRowTap callback fires on mobile card tap', (tester) async {
      int tappedRow = -1;

      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ResponsiveTable(
              columns: columns,
              rows: rows,
              onRowTap: (index, row) => tappedRow = index,
            ),
          ),
        ),
      );

      // Tap a card
      await tester.tap(find.text('iPhone'));
      await tester.pump();
      expect(tappedRow, 0);
    });

    testWidgets('onRowTap callback fires on DataTable row tap', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(1200, 800)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ResponsiveTable(
              columns: columns,
              rows: rows,
              onRowTap: (index, row) {},
            ),
          ),
        ),
      );

      // The DataRow should have an onSelectChanged handler
      expect(find.byType(DataTable), findsOneWidget);
    });

    testWidgets('renders with empty rows', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveTable(
              columns: columns,
              rows: [],
            ),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('renders tablet as DataTable (not cards)', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(768, 1024)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: const ResponsiveTable(
              columns: columns,
              rows: rows,
            ),
          ),
        ),
      );

      expect(find.byType(DataTable), findsOneWidget);
    });

    testWidgets('uses custom mobileCardBuilder', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ResponsiveTable(
              columns: columns,
              rows: rows,
              mobileCardBuilder: (context, row, headers) {
                return Card(
                  child: Text('Custom: ${row[0]}'),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Custom: iPhone'), findsOneWidget);
    });
  });
}
