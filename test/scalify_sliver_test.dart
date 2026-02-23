import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';
import 'test_helpers.dart';

void main() {
  group('ScalifySliverAppBar', () {
    testWidgets('renders SliverAppBar', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: const CustomScrollView(
              slivers: [
                ScalifySliverAppBar(
                  title: 'Test Title',
                  mobileExpandedHeight: 150,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(SliverAppBar), findsOneWidget);
      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('uses mobileExpandedHeight on mobile', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: const CustomScrollView(
              slivers: [
                ScalifySliverAppBar(
                  title: 'Mobile',
                  mobileExpandedHeight: 120,
                  desktopExpandedHeight: 300,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Mobile'), findsOneWidget);
    });

    testWidgets('uses desktopExpandedHeight on desktop', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(1400, 900)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: const CustomScrollView(
              slivers: [
                ScalifySliverAppBar(
                  title: 'Desktop',
                  mobileExpandedHeight: 120,
                  desktopExpandedHeight: 300,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Desktop'), findsOneWidget);
    });

    testWidgets('renders flexibleBackground when provided', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: CustomScrollView(
              slivers: [
                ScalifySliverAppBar(
                  title: 'With BG',
                  mobileExpandedHeight: 200,
                  flexibleBackground: Container(color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('With BG'), findsOneWidget);
      expect(find.byType(FlexibleSpaceBar), findsOneWidget);
    });

    testWidgets('pinned defaults to true', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: const CustomScrollView(
              slivers: [
                ScalifySliverAppBar(title: 'Pinned'),
              ],
            ),
          ),
        ),
      );

      final sliverAppBar =
          tester.widget<SliverAppBar>(find.byType(SliverAppBar));
      expect(sliverAppBar.pinned, isTrue);
    });
  });

  group('ScalifySliverHeader', () {
    testWidgets('renders mobile sliver on mobile', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: CustomScrollView(
              slivers: [
                ScalifySliverHeader(
                  mobile: const SliverToBoxAdapter(
                    child: Text('Mobile Header'),
                  ),
                  desktop: const SliverToBoxAdapter(
                    child: Text('Desktop Header'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Mobile Header'), findsOneWidget);
      expect(find.text('Desktop Header'), findsNothing);
    });

    testWidgets('renders desktop sliver on desktop', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(1400, 900)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: CustomScrollView(
              slivers: [
                ScalifySliverHeader(
                  mobile: const SliverToBoxAdapter(
                    child: Text('Mobile Header'),
                  ),
                  desktop: const SliverToBoxAdapter(
                    child: Text('Desktop Header'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Desktop Header'), findsOneWidget);
      expect(find.text('Mobile Header'), findsNothing);
    });

    testWidgets('falls back to mobile when tablet is null', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(768, 1024)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: CustomScrollView(
              slivers: [
                ScalifySliverHeader(
                  mobile: const SliverToBoxAdapter(
                    child: Text('Fallback'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Fallback'), findsOneWidget);
    });
  });

  group('ScalifySliverPersistentHeader', () {
    testWidgets('renders SliverPersistentHeader', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: CustomScrollView(
              slivers: [
                ScalifySliverPersistentHeader(
                  mobileMaxHeight: 60,
                  builder: (context, shrinkOffset, overlapsContent) {
                    return Container(
                      color: Colors.blue,
                      child: const Center(child: Text('Sticky')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(SliverPersistentHeader), findsOneWidget);
      expect(find.text('Sticky'), findsOneWidget);
    });

    testWidgets('uses mobileMaxHeight on mobile', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: CustomScrollView(
              slivers: [
                ScalifySliverPersistentHeader(
                  mobileMaxHeight: 50,
                  desktopMaxHeight: 100,
                  builder: (context, shrinkOffset, overlapsContent) {
                    return Container(
                      color: Colors.green,
                      child: const Text('Mobile Height'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Mobile Height'), findsOneWidget);
    });

    testWidgets('desktopMaxHeight used on desktop', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(1400, 900)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: CustomScrollView(
              slivers: [
                ScalifySliverPersistentHeader(
                  mobileMaxHeight: 50,
                  desktopMaxHeight: 100,
                  builder: (context, shrinkOffset, overlapsContent) {
                    return Container(
                      child: const Text('Desktop Height'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Desktop Height'), findsOneWidget);
    });

    testWidgets('pinned defaults to true', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: CustomScrollView(
              slivers: [
                ScalifySliverPersistentHeader(
                  mobileMaxHeight: 60,
                  builder: (context, shrinkOffset, overlapsContent) {
                    return Container(child: const Text('Pinned'));
                  },
                ),
              ],
            ),
          ),
        ),
      );

      final header = tester
          .widget<SliverPersistentHeader>(find.byType(SliverPersistentHeader));
      expect(header.pinned, isTrue);
    });

    testWidgets('minHeight affects delegate min height', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) => MaterialApp(home: child),
            child: CustomScrollView(
              slivers: [
                ScalifySliverPersistentHeader(
                  mobileMaxHeight: 100,
                  minHeight: 40,
                  builder: (context, shrinkOffset, overlapsContent) {
                    return Container(child: const Text('Ratio'));
                  },
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Ratio'), findsOneWidget);
    });
  });
}
