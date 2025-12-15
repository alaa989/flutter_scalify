// ignore_for_file: deprecated_member_use, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_scalify/flutter_scalify.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scalify Ultimate Showcase',
      debugShowCheckedModeBanner: false,

      builder: (context, child) {
        return ResponsiveProvider(
          config: const ResponsiveConfig(
            designWidth: 375,
            designHeight: 812,
            minScale: 0.5,
            maxScale: 3.0,
            memoryProtectionThreshold: 1920.0,
            highResScaleFactor: 0.60,
          ),
          child: child ?? const SizedBox(),
        );
      },
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        primaryColor: const Color(0xFF0F172A),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F172A)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F172A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      // 1. FEATURE: AppWidthLimiter (Global Protection)
      home: AppWidthLimiter(
        maxWidth: 1400,
        horizontalPadding: 16,
        backgroundColor: const Color(0xFFE2E8F0),
        child: const ScalifyShowcaseScreen(),
      ),
    );
  }
}

class ScalifyShowcaseScreen extends StatelessWidget {
  const ScalifyShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.responsiveData;

    // Dynamic Aspect Ratio for Manual Grid
    final double dynamicAspectRatio = context.valueByScreen(
      mobile: 2,
      tablet: 1.5,
      smallDesktop: 0.8,
      desktop: 0.8,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // --- App Bar ---
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 80.h.clamp(60, 100),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.layers, size: 24.iz),
                12.sbw,
                Flexible(
                  child: Text(
                    "Scalify UI Kit",
                    style:
                        TextStyle(fontSize: 20.fz, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
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
                      style: TextStyle(fontSize: 12.fz, color: Colors.white),
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
                  // --- 2. FEATURE: ResponsiveFlex ---
                  _SectionHeader(title: "1. Responsive Flex (Profile)"),
                  _buildProfileHeader(context),

                  30.sbh,

                  // --- 3. FEATURE: AdaptiveContainer ---
                  _SectionHeader(title: "2. Adaptive Cards (Layout Change)"),
                  Text(
                    "Cards change layout (Row/Column) based on their own width.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 13.fz),
                  ),
                  10.sbh,
                ],
              ),
            ),
          ),

          // --- Section 2 Grid: Manual Control with AdaptiveContainer ---
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
              return _AdaptiveProductCard(index: index);
            },
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: 20.p,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  30.sbh,
                  // --- 4. FEATURE: ScalifyBox ---
                  _SectionHeader(title: "3. ScalifyBox Grid (Perfect Scale)"),
                  Text(
                    "Items scale geometrically. Ideal for complex UI that shouldn't break.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 13.fz),
                  ),
                  10.sbh,
                ],
              ),
            ),
          ),

          // --- Section 3 Grid: ScalifyBox Items ---
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
              return _ScalifyBoxGridItem(index: index);
            },
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: 20.p,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  30.sbh,
                  // --- 5. FEATURE: Auto-Fit (Lazy Loading / API Style) ---
                  _SectionHeader(title: "4. Auto-Fit Grid (API & Lazy Load)"),
                  Text(
                    "Items lazy load and wrap automatically based on minWidth. Perfect for APIs.",
                    style: TextStyle(color: Colors.grey[600], fontSize: 13.fz),
                  ),
                  10.sbh,
                ],
              ),
            ),
          ),

          // --- Section 4: Auto-Fit Grid (Simulating API Data) ---
          ResponsiveGrid(
            useSliver: true, // Enables lazy loading naturally
            padding: 20.ph,
            minItemWidth: 300,
            scaleMinItemWidth: false, // Keep standard size, add more columns
            spacing: 10,
            runSpacing: 10,
            itemCount: 20, // Simulating a large list
            itemBuilder: (context, index) {
              // This builder is only called when the item is visible on screen
              return Container(
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
                            style: TextStyle(fontSize: 12.fz)),
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

  // --- Widget 1: Profile Header ---
  Widget _buildProfileHeader(BuildContext context) {
    final isMobile = context.responsiveData.isSmallScreen;

    return Container(
      padding: 20.p,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: 16.br,
        boxShadow: [
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
          Container(
            alignment: isMobile ? Alignment.center : Alignment.centerRight,
            padding: isMobile ? EdgeInsets.zero : 8.pl,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.message, size: 18.iz),
              label: Text("Contact", style: TextStyle(fontSize: 14.fz)),
              style: ElevatedButton.styleFrom(
                padding: [20, 12].p,
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
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
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Alaa Naili",
            style: TextStyle(fontSize: 22.fz, fontWeight: FontWeight.bold),
          ),
        ),
        4.sbh,
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Senior Flutter Developer & Expert",
            style: TextStyle(fontSize: 14.fz, color: Colors.grey),
          ),
        ),
        8.sbh,
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment:
                isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              _Badge(text: "Pro Member"),
              8.sbw,
              _Badge(text: "Available for Hire"),
            ],
          ),
        )
      ],
    );
  }
}

// --- Widget 2: Adaptive Card ---
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
      child: AdaptiveContainer(
        breakpoints: const [200, 350],
        xs: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag, color: Colors.indigo, size: 32.iz),
              8.sbh,
              Text("Product $index",
                  style:
                      TextStyle(fontSize: 13.fz, fontWeight: FontWeight.bold)),
              Text("\$99",
                  style: TextStyle(fontSize: 12.fz, color: Colors.green)),
            ],
          ),
        ),
        md: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag, color: Colors.indigo, size: 40.iz),
              8.sbh,
              Text("Product $index",
                  style:
                      TextStyle(fontSize: 14.fz, fontWeight: FontWeight.bold)),
              Text("\$99.00",
                  style: TextStyle(fontSize: 12.fz, color: Colors.green)),
            ],
          ),
        ),
        lg: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: 8.br,
              ),
              child:
                  Icon(Icons.shopping_bag, color: Colors.indigo, size: 24.iz),
            ),
            16.sbw,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Premium Product $index",
                      style: TextStyle(
                          fontSize: 16.fz, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text("High quality item description...",
                      style: TextStyle(fontSize: 12.fz, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            12.sbw,
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(padding: [16, 0].p),
                child: Text("Buy"))
          ],
        ),
      ),
    );
  }
}

// --- Widget 3: ScalifyBox Grid Item ---
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
              Icon(
                Icons.dashboard_customize_rounded,
                color: Colors.indigo,
                size: ls.s(40),
              ),
              SizedBox(height: ls.s(8)),
              Text("Item #${index + 1}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: ls.fz(12)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              SizedBox(height: ls.s(2)),
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
  Widget build(BuildContext context) {
    return Container(
      padding: [8, 4].p,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: 4.br,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10.fz, color: Colors.grey.shade700),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 10.pb,
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12.fz,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}
