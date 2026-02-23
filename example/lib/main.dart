// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_scalify/flutter_scalify.dart';

void main() {
  // Initialize the design token spacing system
  ScalifySpacing.init(const SpacingScale(
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32,
    xxl: 48,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScalifyProvider(
      config: const ScalifyConfig(
        designWidth: 375,
        designHeight: 812,
        minScale: 0.5,
        maxScale: 3.0,
        debounceWindowMillis: 16,
        minWidth: 160,
        enableGranularNotifications: true,
        memoryProtectionThreshold: 1920.0,
        highResScaleFactor: 0.60,
        autoSwapDimensions: true,
      ),
      builder: (context, child) {
        final base = ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          primaryColor: const Color(0xFF0F172A),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F172A)),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0F172A),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        );

        final TextTheme concreteBaseTextTheme =
            Typography.material2021().englishLike.merge(base.textTheme);

        final scale = ScalifyProvider.of(context, aspect: ScalifyAspect.scale)
            .scaleFactor;

        final theme = base.copyWith(
          textTheme: concreteBaseTextTheme.apply(fontSizeFactor: scale),
        );

        return MaterialApp(
          title: 'Scalify Ultimate Showcase',
          debugShowCheckedModeBanner: false,
          themeAnimationDuration: Duration.zero,
          theme: theme,
          home: child,
        );
      },
      child: const ScalifyDebugOverlay(
        child: AppWidthLimiter(
          maxWidth: 1200,
          horizontalPadding: 16,
          minWidth: 230,
          backgroundColor: Color(0xFFE2E8F0),
          child: ScalifyShowcaseScreen(),
        ),
      ),
    );
  }
}

class ScalifyShowcaseScreen extends StatelessWidget {
  const ScalifyShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = ScalifyProvider.of(context, aspect: ScalifyAspect.scale);

    final double dynamicAspectRatio = context.valueByScreen(
      mobile: 2,
      tablet: 1.5,
      smallDesktop: 0.8,
      desktop: 0.8,
    );

    // compute expandedHeight safely as double
    final double expandedHeight = ((80.0).fz).clamp(60.0, 100.0);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: expandedHeight,
            title: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Semantics(
                    label: 'App icon',
                    child: Icon(Icons.layers, size: 28.iz),
                  ),
                  14.sbw,
                  Text(
                    "Scalify UI Kit",
                    style:
                        TextStyle(fontSize: 28.fz, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            actions: [
              Center(
                child: Padding(
                  padding: 16.pr,
                  child: Container(
                    padding: [8, 4].p,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: 4.br,
                    ),
                    child: Text(
                      "W: ${data.size.width.toInt()}",
                      style: TextStyle(fontSize: 18.fz, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: 20.p,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _SectionHeader(title: "NEW v3.0.0 FEATURES"),
                  Container(
                    padding: 12.p,
                    margin: 10.pb,
                    decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        border: Border.all(color: Colors.green.shade200),
                        borderRadius: 8.br),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("1. Auto-Swap Dimensions: ENABLED ✅",
                            style: TextStyle(
                                color: Colors.green.shade800,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.fz)),
                        4.sbh,
                        Text(
                            "Rotate your device! Design width/height will utilize landscape space intelligently.",
                            style: TextStyle(
                                color: Colors.green.shade700, fontSize: 14.fz)),
                      ],
                    ),
                  ),
                  Text("2. Fractional Scaling (42.pw)",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.fz)),
                  8.sbh,
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                              color: Colors.purple.shade300,
                              borderRadius: 8.br),
                          alignment: Alignment.center,
                          child: Text("42% Width",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.fz)),
                        ),
                      ),
                      12.sbw,
                      Expanded(
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                              color: Colors.purple.shade300,
                              borderRadius: 8.br),
                          alignment: Alignment.center,
                          child: Text("42% Width",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.fz)),
                        ),
                      ),
                    ],
                  ),
                  16.sbh,
                  Text("3. Context API (Reactive)",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.fz)),
                  8.sbh,
                  Container(
                    width: context.w(375),
                    padding: 16.p,
                    decoration: BoxDecoration(
                        color: Colors.teal.shade100, borderRadius: 8.br),
                    child: Row(
                      children: [
                        Icon(Icons.monitor_heart, color: Colors.teal.shade800),
                        8.sbw,
                        Expanded(
                          child: Text(
                            "I use context.w()! Resize window to see me adapt instantly.",
                            style: TextStyle(
                                color: Colors.teal.shade900, fontSize: 15.fz),
                          ),
                        ),
                      ],
                    ),
                  ),
                  20.sbh,
                  ResponsiveVisibility(
                    visibleOn: const [ScreenType.mobile],
                    child: Container(
                      padding: 12.p,
                      margin: 10.pb,
                      decoration: BoxDecoration(
                          color: Colors.orange.shade100, borderRadius: 8.br),
                      child: Row(
                        children: [
                          const Icon(Icons.phone_android, color: Colors.orange),
                          8.sbw,
                          Expanded(
                            child: Text("Visible only on Mobile!",
                                style: TextStyle(
                                    color: Colors.orange.shade900,
                                    fontSize: 16.fz)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: 16.p,
                    decoration: BoxDecoration(
                        color: Colors.blue.shade50, borderRadius: 12.br),
                    child: ResponsiveLayout(
                      portrait: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.screen_lock_portrait, size: 40.iz),
                          4.sbh,
                          Text(
                            "Portrait Mode Active",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.fz),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      landscape: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.screen_lock_landscape, size: 30.iz),
                          8.sbw,
                          Expanded(
                            child: Text(
                              "Landscape Mode Active",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.fz),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  20.sbh,
                  ResponsiveBuilder(
                    builder: (context, data) {
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: 12.br),
                        child: Padding(
                          padding: 12.p,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20.s,
                                backgroundColor: Colors.indigo.shade100,
                                child: Text(
                                  data.screenType.name[0].toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 14.fz,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                              12.sbw,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "ResponsiveBuilder Logic",
                                      style: TextStyle(
                                          fontSize: 21.fz,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    4.sbh,
                                    Text(
                                      "W: ${data.size.width.toInt()}px | Type: ${data.screenType.name}",
                                      style: TextStyle(
                                          fontSize: 18.fz,
                                          color: Colors.grey.shade600),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Divider(height: 40.h),
                  const _SectionHeader(title: "1. RESPONSIVE FLEX (PROFILE)"),
                  _buildProfileHeader(context),
                  30.sbh,
                  const _SectionHeader(
                      title: "2. ADAPTIVE CARDS (LAYOUT CHANGE)"),
                  Text(
                    "Cards change layout (Row/Column) based on their own width.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 19.fz),
                  ),
                  10.sbh,
                ],
              ),
            ),
          ),
          ResponsiveGrid(
            useSliver: true,
            padding: 20.ph,
            watch: 1,
            mobile: 1,
            tablet: 2,
            smallDesktop: 4,
            desktop: 4,
            childAspectRatio: dynamicAspectRatio,
            spacing: 16,
            runSpacing: 16,
            itemCount: 4,
            itemBuilder: (context, index) {
              return KeyedSubtree(
                key: ValueKey('adaptive_card_$index'),
                child: _AdaptiveProductCard(index: index),
              );
            },
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: 20.p,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  30.sbh,
                  const _SectionHeader(
                      title: "3. SCALIFYBOX GRID (PERFECT SCALE)"),
                  Text(
                    "Items scale geometrically. Ideal for complex UI that shouldn't break.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 19.fz),
                  ),
                  10.sbh,
                ],
              ),
            ),
          ),
          ResponsiveGrid(
            useSliver: true,
            padding: 20.ph,
            watch: 1,
            mobile: 2,
            tablet: 3,
            desktop: 4,
            spacing: 12,
            runSpacing: 12,
            itemCount: 6,
            itemBuilder: (context, index) {
              return KeyedSubtree(
                key: ValueKey('scalify_box_item_$index'),
                child: _ScalifyBoxGridItem(index: index),
              );
            },
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: 20.p,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  30.sbh,
                  const _SectionHeader(
                      title: "4. AUTO-FIT GRID (API & LAZY LOAD)"),
                  Text(
                    "Items lazy load and wrap automatically based on minWidth.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 19.fz),
                  ),
                  10.sbh,
                ],
              ),
            ),
          ),
          ResponsiveGrid(
            useSliver: true,
            padding: 20.ph,
            minItemWidth: 300,
            scaleMinItemWidth: false,
            spacing: 10,
            runSpacing: 10,
            itemCount: 20,
            itemBuilder: (context, index) {
              return Container(
                key: ValueKey('api_item_$index'),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: 8.br,
                  border: Border.all(color: Colors.grey.shade200),
                ),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Padding(
                    padding: 8.p,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cloud_download,
                            color: Colors.blueGrey, size: 28.iz),
                        4.sbh,
                        Text("API Item $index",
                            style: TextStyle(fontSize: 18.fz)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: 20.p,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  30.sbh,
                  const _SectionHeader(
                      title: "5. SCALIFY SECTION (SPLIT SCALING)"),
                  Text(
                    "Each panel scales independently based on its own width, not the screen width.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 19.fz),
                  ),
                  10.sbh,
                  const _SplitSectionDemo(),
                  30.sbh,
                  const _SectionHeader(title: "6. BEST PRACTICE: .s vs .h"),
                  Text(
                    "Use .s for button & input heights to keep UI consistent on all screens.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 19.fz),
                  ),
                  10.sbh,
                  const _ScaleComparisonDemo(),
                ],
              ),
            ),
          ),
          // ═══════════════════════════════════════════════════
          // NEW v3.1.0 FEATURES SHOWCASE
          // ═══════════════════════════════════════════════════
          SliverToBoxAdapter(
            child: Padding(
              padding: 20.p,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(height: 40.h),
                  const _SectionHeader(title: "NEW v3.1.0 FEATURES"),

                  // ── 7. ResponsiveText ─────────────────────────
                  const _SectionHeader(title: "7. RESPONSIVE TEXT"),
                  Text(
                    "Auto-resize text & short text for small screens.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14.fz),
                  ),
                  10.sbh,
                  Container(
                    padding: 16.p,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      borderRadius: 12.br,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Auto-Resize (shrinks to fit):",
                            style: TextStyle(
                                fontSize: 13.fz,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple.shade700)),
                        8.sbh,
                        Container(
                          width: double.infinity,
                          padding: 12.p,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: 8.br,
                          ),
                          child: ResponsiveText(
                            'This is a very long heading that will automatically shrink to fit the available width',
                            style: TextStyle(
                                fontSize: 22.fz,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple),
                            autoResize: true,
                            minFontSize: 10,
                            maxLines: 1,
                          ),
                        ),
                        16.sbh,
                        Text("Short Text for Mobile:",
                            style: TextStyle(
                                fontSize: 13.fz,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple.shade700)),
                        8.sbh,
                        Container(
                          padding: 12.p,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: 8.br,
                          ),
                          child: ResponsiveText(
                            'Welcome to our Premium Shopping Experience',
                            shortText: 'Welcome! 👋',
                            style: TextStyle(
                                fontSize: 18.fz,
                                color: Colors.deepPurple.shade800),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── 8. ResponsiveSpacing ──────────────────────
                  30.sbh,
                  const _SectionHeader(title: "8. RESPONSIVE SPACING (TOKENS)"),
                  Text(
                    "Unified spacing system: xs=4, sm=8, md=16, lg=24, xl=32, xxl=48",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14.fz),
                  ),
                  10.sbh,
                  Container(
                    padding: 16.p,
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: 12.br,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Spacing.gap (SizedBox shortcuts):",
                            style: TextStyle(
                                fontSize: 13.fz,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade900)),
                        Spacing.sm.gap,
                        const _SpacingDemoRow(label: 'xs', spacing: Spacing.xs),
                        Spacing.xs.gap,
                        const _SpacingDemoRow(label: 'sm', spacing: Spacing.sm),
                        Spacing.xs.gap,
                        const _SpacingDemoRow(label: 'md', spacing: Spacing.md),
                        Spacing.xs.gap,
                        const _SpacingDemoRow(label: 'lg', spacing: Spacing.lg),
                        Spacing.xs.gap,
                        const _SpacingDemoRow(label: 'xl', spacing: Spacing.xl),
                        Spacing.md.gap,
                        Text("Spacing.insets (Padding shortcuts):",
                            style: TextStyle(
                                fontSize: 13.fz,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade900)),
                        Spacing.sm.gap,
                        Container(
                          padding: Spacing.lg.insets,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: 8.br,
                            border: Border.all(color: Colors.amber.shade200),
                          ),
                          child: Text(
                            "Spacing.lg.insets → EdgeInsets.all(24 * scale)",
                            style: TextStyle(
                                fontSize: 13.fz, color: Colors.amber.shade800),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── 9. ResponsiveWrap ─────────────────────────
                  30.sbh,
                  const _SectionHeader(title: "9. RESPONSIVE WRAP"),
                  Text(
                    "Smart auto-wrapping layout for chips, tags, and buttons.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14.fz),
                  ),
                  10.sbh,
                  Container(
                    padding: 16.p,
                    decoration: BoxDecoration(
                      color: Colors.cyan.shade50,
                      borderRadius: 12.br,
                    ),
                    child: ResponsiveWrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final label in [
                          '🎨 Design',
                          '⚡ Performance',
                          '📱 Mobile',
                          '💻 Desktop',
                          '🌐 Web',
                          '🧪 Testing',
                          '🔄 Auto-Wrap',
                          '📏 Scaled Spacing',
                        ])
                          Chip(
                            label:
                                Text(label, style: TextStyle(fontSize: 12.fz)),
                            backgroundColor: Colors.white,
                            side: BorderSide(color: Colors.cyan.shade200),
                          ),
                      ],
                    ),
                  ),

                  // ── 10. ResponsiveImage ───────────────────────
                  30.sbh,
                  const _SectionHeader(title: "10. RESPONSIVE IMAGE"),
                  Text(
                    "Different images per screen type with fallback chain.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14.fz),
                  ),
                  10.sbh,
                  Container(
                    height: 150.s,
                    decoration: BoxDecoration(
                      borderRadius: 12.br,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ResponsiveImage(
                      mobile: const NetworkImage(
                        'https://picsum.photos/400/200',
                      ),
                      desktop: const NetworkImage(
                        'https://picsum.photos/1200/400',
                      ),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150.s,
                      placeholder: Container(
                        color: Colors.grey.shade200,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.image,
                                  size: 32.iz, color: Colors.grey),
                              4.sbh,
                              Text("Loading...",
                                  style: TextStyle(
                                      fontSize: 12.fz, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                      errorWidget: Container(
                        color: Colors.red.shade50,
                        child: Center(
                          child: Icon(Icons.broken_image,
                              size: 32.iz, color: Colors.red.shade300),
                        ),
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  // ── 11. AnimatedResponsiveTransition ──────────
                  30.sbh,
                  const _SectionHeader(
                      title: "11. ANIMATED RESPONSIVE TRANSITION"),
                  Text(
                    "Smooth animations between responsive layouts on resize.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14.fz),
                  ),
                  10.sbh,
                  AnimatedResponsiveTransition(
                    duration: const Duration(milliseconds: 400),
                    transition: ResponsiveTransitionType.fadeSlide,
                    mobile: Container(
                      padding: 16.p,
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: 12.br,
                        border: Border.all(color: Colors.pink.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.phone_android,
                              size: 28.iz, color: Colors.pink),
                          12.sbw,
                          Expanded(
                            child: Text("📱 Mobile Layout",
                                style: TextStyle(
                                    fontSize: 16.fz,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pink.shade800)),
                          ),
                        ],
                      ),
                    ),
                    tablet: Container(
                      padding: 20.p,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: 12.br,
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.tablet_mac,
                              size: 36.iz, color: Colors.blue),
                          16.sbw,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("📱 Tablet Layout",
                                    style: TextStyle(
                                        fontSize: 18.fz,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue.shade800)),
                                4.sbh,
                                Text("Extra details visible on tablet!",
                                    style: TextStyle(
                                        fontSize: 13.fz,
                                        color: Colors.blue.shade600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    desktop: Container(
                      padding: 24.p,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade50,
                            Colors.teal.shade50,
                          ],
                        ),
                        borderRadius: 12.br,
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.desktop_mac,
                              size: 42.iz, color: Colors.green),
                          20.sbw,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("🖥️ Desktop Layout",
                                    style: TextStyle(
                                        fontSize: 20.fz,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade800)),
                                4.sbh,
                                Text(
                                    "Full desktop experience with extra content area!",
                                    style: TextStyle(
                                        fontSize: 14.fz,
                                        color: Colors.green.shade600)),
                              ],
                            ),
                          ),
                          Container(
                            padding: 12.p,
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: 8.br,
                            ),
                            child: Text("Extra Panel",
                                style: TextStyle(
                                    fontSize: 12.fz,
                                    color: Colors.green.shade700)),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── 12. ResponsiveTable ───────────────────────
                  30.sbh,
                  const _SectionHeader(title: "12. RESPONSIVE TABLE"),
                  Text(
                    "DataTable on desktop → Cards on mobile. With column hiding.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14.fz),
                  ),
                  10.sbh,
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: 12.br,
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ResponsiveTable(
                      columns: const ['Product', 'Price', 'Status', 'Category'],
                      rows: const [
                        ['iPhone 15 Pro', '\$999', 'Available', 'Electronics'],
                        ['MacBook Air', '\$1,199', 'Sold Out', 'Laptops'],
                        ['AirPods Pro', '\$249', 'Available', 'Audio'],
                        ['iPad Pro', '\$799', 'Pre-Order', 'Tablets'],
                        ['Apple Watch', '\$399', 'Available', 'Wearables'],
                      ],
                      hiddenColumnsOnMobile: const [3],
                      onRowTap: (index, row) {},
                    ),
                  ),

                  // ── 13. ResponsiveConstraints ─────────────────
                  30.sbh,
                  const _SectionHeader(title: "13. RESPONSIVE CONSTRAINTS"),
                  Text(
                    "Different BoxConstraints per screen type with alignment.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14.fz),
                  ),
                  10.sbh,
                  ResponsiveConstraints(
                    alignment: Alignment.center,
                    mobile: const BoxConstraints(maxWidth: 300),
                    tablet: const BoxConstraints(maxWidth: 450),
                    desktop: const BoxConstraints(maxWidth: 600),
                    child: Container(
                      padding: 16.p,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade100,
                            Colors.deepOrange.shade100,
                          ],
                        ),
                        borderRadius: 12.br,
                        border: Border.all(color: Colors.orange.shade300),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.aspect_ratio,
                              size: 32.iz, color: Colors.deepOrange),
                          8.sbh,
                          ResponsiveText(
                            'Constrained to max-width per screen type',
                            style: TextStyle(
                                fontSize: 14.fz,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange.shade800),
                            autoResize: true,
                            minFontSize: 10,
                            maxLines: 1,
                          ),
                          4.sbh,
                          ResponsiveBuilder(
                            builder: (ctx, data) => Text(
                              'mobile: 300px | tablet: 450px | desktop: 600px',
                              style: TextStyle(
                                  fontSize: 11.fz,
                                  color: Colors.deepOrange.shade600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  30.sbh,
                  const _SectionHeader(title: "14. RESPONSIVE NAVIGATION DEMO"),
                  Text(
                    "Bottom → Rail → Sidebar. See NavigationDemoPage below.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14.fz),
                  ),
                  10.sbh,
                  const _NavigationPreview(),

                  30.sbh,
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(child: 50.sbh),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final isMobile = context.responsiveData.isSmallScreen;

    return Container(
      padding: 20.p,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: 16.br,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
        ],
      ),
      child: ResponsiveFlex(
        switchOn: ScreenType.mobile,
        spacing: 16,
        rowCrossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: CircleAvatar(
              radius: 40.s,
              backgroundColor: Colors.indigo.shade50,
              child: Icon(Icons.person, size: 40.iz, color: Colors.indigo),
            ),
          ),
          if (!isMobile)
            Expanded(child: _buildInfoColumn(context))
          else
            _buildInfoColumn(context),
          if (!isMobile)
            Flexible(
              child: Container(
                alignment: isMobile ? Alignment.center : Alignment.centerRight,
                child: Tooltip(
                  message: 'Contact user',
                  child: Semantics(
                      button: true,
                      label: 'Contact the user',
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: [16, 12].p,
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.message, size: 16.iz),
                              6.sbw,
                              Text(
                                "Contact",
                                style: TextStyle(fontSize: 16.fz),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
              ),
            )
          else
            Container(
              alignment: isMobile ? Alignment.center : Alignment.centerRight,
              child: Tooltip(
                message: 'Contact user',
                child: Semantics(
                  button: true,
                  label: 'Contact the user',
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.message, size: 18.iz),
                    label: Text("Contact", style: TextStyle(fontSize: 20.fz)),
                    style: ElevatedButton.styleFrom(
                      padding: [20, 12].p,
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildInfoColumn(BuildContext context) {
    final isMobile = context.responsiveData.isSmallScreen;

    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Alaa Hassan",
          style: TextStyle(fontSize: 24.fz, fontWeight: FontWeight.bold),
        ),
        4.sbh,
        Text(
          "Senior Flutter Developer & Expert",
          style: TextStyle(fontSize: 16.fz, color: Colors.grey),
        ),
        8.sbh,
        Wrap(
          alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
          spacing: 8.s,
          runSpacing: 4.s,
          children: const [
            _Badge(text: "Pro Member"),
            _Badge(text: "Available for Hire")
          ],
        )
      ],
    );
  }
}

class _AdaptiveProductCard extends StatelessWidget {
  final int index;
  const _AdaptiveProductCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: 12.br,
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: 12.p,
      child: ContainerQuery(
        breakpoints: const [200, 350],
        builder: (context, query) {
          // حالة الحاوية الصغيرة جداً
          if (query.tier == QueryTier.xs) {
            return FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_bag, color: Colors.indigo, size: 32.iz),
                  8.sbh,
                  Text("Product $index",
                      style: TextStyle(
                          fontSize: 19.fz, fontWeight: FontWeight.bold)),
                  Text("\$99",
                      style: TextStyle(fontSize: 18.fz, color: Colors.green)),
                ],
              ),
            );
          }

          if (query.tier == QueryTier.sm) {
            return FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_bag, color: Colors.indigo, size: 40.iz),
                  8.sbh,
                  Text("Product $index",
                      style: TextStyle(
                          fontSize: 20.fz, fontWeight: FontWeight.bold)),
                  Text("\$99.00",
                      style: TextStyle(fontSize: 18.fz, color: Colors.green)),
                ],
              ),
            );
          }

          return Row(
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                    color: Colors.indigo.shade50, borderRadius: 8.br),
                child:
                    Icon(Icons.shopping_bag, color: Colors.indigo, size: 24.iz),
              ),
              16.sbw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Premium Product $index",
                        style: TextStyle(
                            fontSize: 22.fz, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    Text("High quality item description...",
                        style: TextStyle(fontSize: 18.fz, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              12.sbw,
              Tooltip(
                message: 'Buy product',
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Buy'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ScalifyBoxGridItem extends StatelessWidget {
  final int index;
  const _ScalifyBoxGridItem({required this.index});

  @override
  Widget build(BuildContext context) {
    return ScalifyBox(
      referenceWidth: 100,
      referenceHeight: 120,
      fit: ScalifyFit.contain,
      builder: (context, ls) {
        return Container(
          width: ls.w(120),
          height: ls.h(120),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: ls.br(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: ls.s(8),
                  offset: Offset(0, ls.s(4)))
            ],
          ),
          padding: ls.p(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.dashboard_customize_rounded,
                  color: Colors.indigo, size: ls.iz(40)),
              ls.sbh(8),
              Text("Item #${index + 1}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: ls.fz(12)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              ls.sbh(2),
              Text("ScalifyBox",
                  style: TextStyle(color: Colors.grey, fontSize: ls.fz(9)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        );
      },
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge({required this.text});
  @override
  Widget build(BuildContext context) => Container(
        padding: [8, 4].p,
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: 4.br,
            border: Border.all(color: Colors.grey.shade300)),
        child: Text(text,
            style: TextStyle(fontSize: 10.fz, color: Colors.grey.shade700)),
      );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) => Padding(
        padding: 10.pb,
        child: Text(title,
            style: TextStyle(
                fontSize: context.fz(24),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.blueGrey)),
      );
}

/// Demonstrates ScalifySection — responsive split with nested navigation.
class _SplitSectionDemo extends StatefulWidget {
  const _SplitSectionDemo();

  @override
  State<_SplitSectionDemo> createState() => _SplitSectionDemoState();
}

class _SplitSectionDemoState extends State<_SplitSectionDemo> {
  int _mobileTab = 0; // 0 = sidebar, 1 = content
  int? _selectedItem; // null = list, non-null = detail

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isWide = screenWidth >= 600;

    return Container(
      height: 280.s,
      decoration: BoxDecoration(
        borderRadius: 12.br,
        border: Border.all(color: Colors.grey.shade300),
      ),
      clipBehavior: Clip.antiAlias,
      child: isWide ? _buildSplitView() : _buildMobileView(),
    );
  }

  Widget _buildSplitView() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: ScalifySection(child: _buildSidebar()),
        ),
        Container(width: 1, color: Colors.grey.shade300),
        Expanded(
          flex: 7,
          child: ScalifySection(child: _buildMainContent()),
        ),
      ],
    );
  }

  Widget _buildMobileView() {
    return Column(
      children: [
        Container(
          color: Colors.grey.shade100,
          child: Row(
            children: [
              Expanded(
                child: _TabBtn(
                  label: "Sidebar",
                  icon: Icons.view_sidebar,
                  isActive: _mobileTab == 0,
                  onTap: () => setState(() => _mobileTab = 0),
                ),
              ),
              Expanded(
                child: _TabBtn(
                  label: "Content",
                  icon: Icons.dashboard,
                  isActive: _mobileTab == 1,
                  onTap: () => setState(() => _mobileTab = 1),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _mobileTab == 0 ? _buildSidebar() : _buildMainContent(),
        ),
      ],
    );
  }

  Widget _buildSidebar() {
    return Builder(builder: (context) {
      final data = ScalifyProvider.of(context);
      return Container(
        color: Colors.indigo.shade50,
        padding: EdgeInsets.all(context.s(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.view_sidebar,
                size: context.iz(28), color: Colors.indigo),
            SizedBox(height: context.s(8)),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text("Sidebar Panel",
                  style: TextStyle(
                    fontSize: context.fz(16),
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade800,
                  )),
            ),
            SizedBox(height: context.s(6)),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: context.s(8), vertical: context.s(4)),
              decoration: BoxDecoration(
                color: Colors.indigo.shade100,
                borderRadius: BorderRadius.circular(context.r(6)),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text("W: ${data.size.width.toInt()}px",
                    style: TextStyle(
                      fontSize: context.fz(13),
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo.shade700,
                    )),
              ),
            ),
            SizedBox(height: context.s(4)),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text("Scale: ${data.scaleWidth.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: context.fz(11),
                    color: Colors.indigo.shade400,
                  )),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMainContent() {
    return Builder(builder: (context) {
      final data = ScalifyProvider.of(context);
      return Container(
        color: Colors.teal.shade50,
        padding: EdgeInsets.all(context.s(12)),
        child: _selectedItem == null
            ? _listView(context, data)
            : _detailView(context, data),
      );
    });
  }

  Widget _listView(BuildContext context, ResponsiveData data) {
    return Column(
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text("Content — ${data.size.width.toInt()}px",
              style: TextStyle(
                fontSize: context.fz(15),
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade800,
              )),
        ),
        SizedBox(height: context.s(8)),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: 3,
            separatorBuilder: (_, __) => SizedBox(height: context.s(6)),
            itemBuilder: (ctx, index) {
              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(context.r(8)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(context.r(8)),
                  onTap: () => setState(() => _selectedItem = index),
                  child: Padding(
                    padding: EdgeInsets.all(context.s(10)),
                    child: Row(
                      children: [
                        Icon(Icons.article_outlined,
                            size: context.iz(20), color: Colors.teal),
                        SizedBox(width: context.s(8)),
                        Expanded(
                          child: Text("Item ${index + 1} — Tap for detail",
                              style: TextStyle(
                                  fontSize: context.fz(13),
                                  color: Colors.teal.shade700)),
                        ),
                        Icon(Icons.chevron_right,
                            size: context.iz(18), color: Colors.teal.shade300),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _detailView(BuildContext context, ResponsiveData data) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => setState(() => _selectedItem = null),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.arrow_back,
                      size: context.iz(18), color: Colors.teal.shade700),
                  SizedBox(width: context.s(4)),
                  Text("Back",
                      style: TextStyle(
                          fontSize: context.fz(13),
                          color: Colors.teal.shade700,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const Spacer(),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: context.s(6), vertical: context.s(2)),
              decoration: BoxDecoration(
                color: Colors.teal.shade100,
                borderRadius: BorderRadius.circular(context.r(4)),
              ),
              child: Text("W: ${data.size.width.toInt()}px",
                  style: TextStyle(
                      fontSize: context.fz(11), color: Colors.teal.shade600)),
            ),
          ],
        ),
        const Spacer(),
        Icon(Icons.check_circle,
            size: context.iz(40), color: Colors.teal.shade400),
        SizedBox(height: context.s(8)),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text("Detail: Item ${_selectedItem! + 1}",
              style: TextStyle(
                fontSize: context.fz(18),
                fontWeight: FontWeight.bold,
                color: Colors.teal.shade800,
              )),
        ),
        SizedBox(height: context.s(6)),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text("Split stays fixed! ✅",
              style: TextStyle(
                fontSize: context.fz(14),
                color: Colors.teal.shade600,
              )),
        ),
        const Spacer(),
      ],
    );
  }
}

class _TabBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _TabBtn({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.s),
        decoration: BoxDecoration(
          color: isActive ? Colors.indigo.shade50 : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isActive ? Colors.indigo : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 16.iz, color: isActive ? Colors.indigo : Colors.grey),
            SizedBox(width: 4.s),
            Text(label,
                style: TextStyle(
                  fontSize: 13.fz,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? Colors.indigo : Colors.grey,
                )),
          ],
        ),
      ),
    );
  }
}

/// Demonstrates .s (correct) vs .h (problematic) for button & input heights.
class _ScaleComparisonDemo extends StatelessWidget {
  const _ScaleComparisonDemo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text("✅ height: 48.s",
                        style: TextStyle(
                            fontSize: 13.fz,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700)),
                  ),
                  6.sbh,
                  SizedBox(
                    height: 48.s,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child:
                            Text("Buy Now", style: TextStyle(fontSize: 16.fz)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            12.sbw,
            Expanded(
              child: Column(
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text("⚠️ height: 48.h",
                        style: TextStyle(
                            fontSize: 13.fz,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700)),
                  ),
                  6.sbh,
                  SizedBox(
                    height: 48.h,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade600,
                        foregroundColor: Colors.white,
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child:
                            Text("Buy Now", style: TextStyle(fontSize: 16.fz)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        16.sbh,
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text("✅ height: 48.s",
                        style: TextStyle(
                            fontSize: 13.fz,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700)),
                  ),
                  6.sbh,
                  SizedBox(
                    height: 48.s,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: 8.br),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 8.s),
                      ),
                      style: TextStyle(fontSize: 14.fz),
                    ),
                  ),
                ],
              ),
            ),
            12.sbw,
            Expanded(
              child: Column(
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text("⚠️ height: 48.h",
                        style: TextStyle(
                            fontSize: 13.fz,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade700)),
                  ),
                  6.sbh,
                  SizedBox(
                    height: 48.h,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: 8.br),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 8.h),
                      ),
                      style: TextStyle(fontSize: 14.fz),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        12.sbh,
        Container(
          padding: 10.p,
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: 8.br,
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline,
                  color: Colors.blue.shade700, size: 18.iz),
              8.sbw,
              Expanded(
                child: Text(
                  "Resize the window — .s stays proportional while .h may shrink on wide screens.",
                  style:
                      TextStyle(fontSize: 12.fz, color: Colors.blue.shade800),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
// NEW v3.1.0 FEATURE DEMO WIDGETS
// ═══════════════════════════════════════════════════════════════════════

/// Row showing a spacing tier with a colored bar.
class _SpacingDemoRow extends StatelessWidget {
  final String label;
  final Spacing spacing;
  const _SpacingDemoRow({required this.label, required this.spacing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 30.w,
          child: Text(label,
              style: TextStyle(
                  fontSize: 12.fz,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber.shade800)),
        ),
        Expanded(
          child: Container(
            height: spacing.value.clamp(4, 48),
            decoration: BoxDecoration(
              color: Colors.amber.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        8.sbw,
        Text('${spacing.value.toStringAsFixed(0)}px',
            style: TextStyle(fontSize: 11.fz, color: Colors.amber.shade700)),
      ],
    );
  }
}

/// Preview of the ResponsiveNavigation widget embedded in a container.
class _NavigationPreview extends StatefulWidget {
  const _NavigationPreview();

  @override
  State<_NavigationPreview> createState() => _NavigationPreviewState();
}

class _NavigationPreviewState extends State<_NavigationPreview> {
  int _navIndex = 0;

  // Each tab gets its own GlobalKey<NavigatorState> for independent navigation
  final _navigatorKeys = List.generate(4, (_) => GlobalKey<NavigatorState>());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350.s,
      decoration: BoxDecoration(
        borderRadius: 12.br,
        border: Border.all(color: Colors.grey.shade300),
      ),
      clipBehavior: Clip.antiAlias,
      child: ResponsiveNavigation(
        destinations: const [
          NavDestination(icon: Icons.home, label: 'Home'),
          NavDestination(
              icon: Icons.search, selectedIcon: Icons.search, label: 'Search'),
          NavDestination(
              icon: Icons.notifications_outlined,
              selectedIcon: Icons.notifications,
              label: 'Alerts',
              badge: 5),
          // Profile: shown in bottom nav, hidden in sidebar (moved to footer)
          NavDestination(
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              label: 'Profile',
              showInSidebar: false),
        ],
        selectedIndex: _navIndex,
        onChanged: (i) => setState(() => _navIndex = i),
        // ── Nested Navigation: sidebar stays fixed, body navigates ──
        body: IndexedStack(
          index: _navIndex,
          children: [
            _NestedNav(
                navKey: _navigatorKeys[0],
                tabLabel: 'Home',
                tabColor: Colors.blue,
                tabIcon: Icons.home),
            _NestedNav(
                navKey: _navigatorKeys[1],
                tabLabel: 'Search',
                tabColor: Colors.green,
                tabIcon: Icons.search),
            _NestedNav(
                navKey: _navigatorKeys[2],
                tabLabel: 'Alerts',
                tabColor: Colors.orange,
                tabIcon: Icons.notifications),
            _NestedNav(
                navKey: _navigatorKeys[3],
                tabLabel: 'Profile',
                tabColor: Colors.purple,
                tabIcon: Icons.person),
          ],
        ),

        // ── Custom bottom nav (full UI control) ──
        bottomNavBuilder: (context, destinations, selected, onChanged) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 10,
                    offset: const Offset(0, -2))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(destinations.length, (i) {
                final d = destinations[i];
                final isActive = i == selected;
                return GestureDetector(
                  onTap: () => onChanged(i),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.s, horizontal: 12.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(
                              horizontal: isActive ? 16.w : 0),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.indigo.withAlpha(25)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.s),
                            child: Icon(
                              isActive ? (d.selectedIcon ?? d.icon) : d.icon,
                              color: isActive ? Colors.indigo : Colors.grey,
                              size: 22.iz,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.s),
                        Text(
                          d.label,
                          style: TextStyle(
                            fontSize: 10.fz,
                            fontWeight:
                                isActive ? FontWeight.bold : FontWeight.normal,
                            color: isActive ? Colors.indigo : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          );
        },

        // ── Sidebar header ──
        sidebarHeader: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.layers, size: 24.iz, color: Colors.indigo),
              SizedBox(width: 8.w),
              Text('Scalify App',
                  style: TextStyle(
                      fontSize: 16.fz,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo)),
            ],
          ),
        ),

        // ── Sidebar footer (Profile card replaces the button) ──
        sidebarFooter: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _navIndex == 3
                ? Colors.indigo.withAlpha(25)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => setState(() => _navIndex = 3),
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16.s,
                  backgroundColor: Colors.indigo.shade100,
                  child: Icon(Icons.person, size: 18.iz, color: Colors.indigo),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Alaa Hassan',
                          style: TextStyle(
                              fontSize: 13.fz, fontWeight: FontWeight.w600)),
                      Text('Pro Member',
                          style:
                              TextStyle(fontSize: 10.fz, color: Colors.grey)),
                    ],
                  ),
                ),
                Icon(Icons.settings, size: 16.iz, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Each tab has its own Navigator for independent nested navigation.
class _NestedNav extends StatelessWidget {
  final GlobalKey<NavigatorState> navKey;
  final String tabLabel;
  final MaterialColor tabColor;
  final IconData tabIcon;

  const _NestedNav({
    required this.navKey,
    required this.tabLabel,
    required this.tabColor,
    required this.tabIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => _TabListPage(
            label: tabLabel,
            color: tabColor,
            icon: tabIcon,
            navKey: navKey,
          ),
        );
      },
    );
  }
}

/// Root list page for each tab — shows items that push to detail page.
class _TabListPage extends StatelessWidget {
  final String label;
  final MaterialColor color;
  final IconData icon;
  final GlobalKey<NavigatorState> navKey;

  const _TabListPage({
    required this.label,
    required this.color,
    required this.icon,
    required this.navKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.shade50,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.s),
            child: Row(
              children: [
                Icon(icon, size: 24.iz, color: color),
                SizedBox(width: 8.w),
                Text(label,
                    style: TextStyle(
                        fontSize: 16.fz,
                        fontWeight: FontWeight.bold,
                        color: color.shade800)),
                const Spacer(),
                Text('Tap item → push detail',
                    style: TextStyle(fontSize: 10.fz, color: color.shade400)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              itemCount: 5,
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 6.s),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        // Push detail page — sidebar stays fixed!
                        navKey.currentState?.push(MaterialPageRoute(
                          builder: (_) => _TabDetailPage(
                            parentLabel: label,
                            itemIndex: index,
                            color: color,
                            navKey: navKey,
                          ),
                        ));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10.s),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 14.s,
                              backgroundColor: color.shade100,
                              child: Text('${index + 1}',
                                  style: TextStyle(
                                      fontSize: 11.fz,
                                      color: color.shade800,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text('$label Item ${index + 1}',
                                  style: TextStyle(
                                      fontSize: 13.fz, color: color.shade700)),
                            ),
                            Icon(Icons.chevron_right,
                                size: 18.iz, color: color.shade300),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Detail page pushed inside a tab — sidebar stays visible!
class _TabDetailPage extends StatelessWidget {
  final String parentLabel;
  final int itemIndex;
  final MaterialColor color;
  final GlobalKey<NavigatorState> navKey;

  const _TabDetailPage({
    required this.parentLabel,
    required this.itemIndex,
    required this.color,
    required this.navKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.shade50,
      child: Column(
        children: [
          // Back bar
          Container(
            padding: EdgeInsets.all(8.s),
            color: color.shade100,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => navKey.currentState?.pop(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back,
                          size: 18.iz, color: color.shade800),
                      SizedBox(width: 4.w),
                      Text('Back',
                          style: TextStyle(
                              fontSize: 13.fz,
                              fontWeight: FontWeight.w600,
                              color: color.shade800)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Detail content
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, size: 40.iz, color: color),
                  SizedBox(height: 8.s),
                  Text('$parentLabel — Detail #${itemIndex + 1}',
                      style: TextStyle(
                          fontSize: 16.fz,
                          fontWeight: FontWeight.bold,
                          color: color.shade800)),
                  SizedBox(height: 4.s),
                  Text('Sidebar stays fixed! ✅',
                      style: TextStyle(fontSize: 12.fz, color: color.shade600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
