// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_scalify/flutter_scalify.dart';

void main() {
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
      child: const AppWidthLimiter(
        maxWidth: 1200,
        horizontalPadding: 16,
        minWidth: 230,
        backgroundColor: Color(0xFFE2E8F0),
        child: ScalifyShowcaseScreen(),
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
