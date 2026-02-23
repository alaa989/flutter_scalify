import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_scalify/flutter_scalify.dart';
import 'test_helpers.dart';

void main() {
  group('NavDestination', () {
    test('creates with required parameters', () {
      const dest = NavDestination(icon: Icons.home, label: 'Home');
      expect(dest.icon, Icons.home);
      expect(dest.label, 'Home');
      expect(dest.selectedIcon, isNull);
      expect(dest.badge, isNull);
      expect(dest.showInSidebar, isTrue);
    });

    test('showInSidebar defaults to true', () {
      const dest = NavDestination(icon: Icons.home, label: 'Home');
      expect(dest.showInSidebar, isTrue);
    });

    test('showInSidebar can be set to false', () {
      const dest = NavDestination(
          icon: Icons.person, label: 'Profile', showInSidebar: false);
      expect(dest.showInSidebar, isFalse);
    });

    test('badge can be set', () {
      const dest =
          NavDestination(icon: Icons.notifications, label: 'Alerts', badge: 5);
      expect(dest.badge, 5);
    });
  });

  group('ResponsiveNavigation', () {
    const destinations = [
      NavDestination(icon: Icons.home, label: 'Home'),
      NavDestination(icon: Icons.search, label: 'Search'),
      NavDestination(icon: Icons.person, label: 'Profile'),
    ];

    testWidgets('renders bottom nav on mobile', (tester) async {
      int selectedIndex = 0;

      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ResponsiveNavigation(
              destinations: destinations,
              selectedIndex: selectedIndex,
              onChanged: (i) => selectedIndex = i,
              body: const Text('Mobile Body'),
            ),
          ),
        ),
      );

      expect(find.text('Mobile Body'), findsOneWidget);
      expect(find.byType(NavigationBar), findsOneWidget);
    });

    testWidgets('renders rail on tablet', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(768, 1024)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ResponsiveNavigation(
              destinations: destinations,
              selectedIndex: 0,
              onChanged: (_) {},
              body: const Text('Tablet Body'),
            ),
          ),
        ),
      );

      expect(find.text('Tablet Body'), findsOneWidget);
      expect(find.byType(NavigationRail), findsOneWidget);
    });

    testWidgets('renders sidebar on desktop', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(1400, 900)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ResponsiveNavigation(
              destinations: destinations,
              selectedIndex: 0,
              onChanged: (_) {},
              body: const Text('Desktop Body'),
            ),
          ),
        ),
      );

      expect(find.text('Desktop Body'), findsOneWidget);
      // Sidebar renders ListTile-like items with text labels
      expect(find.text('Home'), findsWidgets);
      expect(find.text('Search'), findsWidgets);
    });

    testWidgets('uses custom bottomNavBuilder', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ResponsiveNavigation(
              destinations: destinations,
              selectedIndex: 0,
              onChanged: (_) {},
              body: const Text('Content'),
              bottomNavBuilder: (context, dests, selected, onChanged) {
                return Container(
                  key: const Key('custom_nav'),
                  child: const Text('Custom Nav'),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Custom Nav'), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('showInSidebar: false hides item from sidebar', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(1400, 900)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ResponsiveNavigation(
              destinations: const [
                NavDestination(icon: Icons.home, label: 'Home'),
                NavDestination(
                    icon: Icons.person, label: 'Profile', showInSidebar: false),
              ],
              selectedIndex: 0,
              onChanged: (_) {},
              body: const Text('Content'),
            ),
          ),
        ),
      );

      expect(find.text('Home'), findsWidgets);
      // 'Profile' text should not appear in sidebar items
      expect(find.text('Profile'), findsNothing);
    });

    testWidgets('sidebarFooter renders on desktop', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(1400, 900)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ResponsiveNavigation(
              destinations: destinations,
              selectedIndex: 0,
              onChanged: (_) {},
              body: const Text('Body'),
              sidebarFooter: const Text('Footer Widget'),
            ),
          ),
        ),
      );

      expect(find.text('Footer Widget'), findsOneWidget);
    });

    testWidgets('sidebarHeader renders on desktop', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(1400, 900)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ResponsiveNavigation(
              destinations: destinations,
              selectedIndex: 0,
              onChanged: (_) {},
              body: const Text('Body'),
              sidebarHeader: const Text('Header Widget'),
            ),
          ),
        ),
      );

      expect(find.text('Header Widget'), findsOneWidget);
    });

    testWidgets('onChanged callback fires on bottom nav tap', (tester) async {
      int tappedIndex = -1;

      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ResponsiveNavigation(
              destinations: destinations,
              selectedIndex: 0,
              onChanged: (i) => tappedIndex = i,
              body: const Text('Body'),
            ),
          ),
        ),
      );

      // Tap the second destination (Search)
      await tester.tap(find.text('Search'));
      await tester.pump();
      expect(tappedIndex, 1);
    });

    testWidgets('badge renders on navigation items', (tester) async {
      await pumpApp(
        tester,
        MediaQuery(
          data: const MediaQueryData(size: Size(375, 812)),
          child: ScalifyProvider(
            builder: (context, child) =>
                MaterialApp(home: Scaffold(body: child)),
            child: ResponsiveNavigation(
              destinations: const [
                NavDestination(icon: Icons.home, label: 'Home'),
                NavDestination(
                    icon: Icons.notifications, label: 'Alerts', badge: 3),
              ],
              selectedIndex: 0,
              onChanged: (_) {},
              body: const Text('Body'),
            ),
          ),
        ),
      );

      expect(find.byType(Badge), findsWidgets);
    });
  });
}
