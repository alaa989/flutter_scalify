// ignore_for_file: deprecated_member_use, prefer_const_constructors
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
      title: 'Scalify Lab Ultimate',
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
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        primaryColor: Colors.indigo,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const ScalifyLabScreen(),
    );
  }
}

class ScalifyLabScreen extends StatelessWidget {
  const ScalifyLabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.responsiveData;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90.h.clamp(56.0, 120.0),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.science, size: 24.iz),
            12.sbw,
            Text("Scalify Lab 🧪",
                style: TextStyle(fontSize: 20.fz, fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: true,
      ),
      body: AppWidthLimiter(
        maxWidth: 2400,
        child: SingleChildScrollView(
          padding: 20.p,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Live Metrics
              _buildSectionTitle("1. Live Metrics"),
              Container(
                padding: 16.p,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: 12.br,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05), blurRadius: 10)
                  ],
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildMetricItem("Width", "${data.size.width.toInt()}px"),
                      30.sbw,
                      _buildMetricItem(
                          "Scale", "${data.scaleFactor.toStringAsFixed(2)}x"),
                      30.sbw,
                      _buildMetricItem(
                          "Device", data.screenType.name.toUpperCase()),
                    ],
                  ),
                ),
              ),

              24.sbh,

              // 2. Scaling Logic
              _buildSectionTitle("2. Scaling Logic"),
              Container(
                padding: 16.p,
                decoration:
                    BoxDecoration(color: Colors.white, borderRadius: 12.br),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildBox(100.w, Colors.blue, ".w (Width)", 100.w),
                      20.sbw,
                      _buildBox(100.s, Colors.green, ".s (Smart)", 100.s),
                      20.sbw,
                      _buildBox(100.h, Colors.orange, ".h (Height)", 100.h),
                    ],
                  ),
                ),
              ),

              24.sbh,

              // 3. Typography
              _buildSectionTitle("3. Typography"),
              Container(
                padding: 16.p,
                decoration:
                    BoxDecoration(color: Colors.white, borderRadius: 12.br),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Standard Body (14.fz)",
                        style: TextStyle(fontSize: 14.fz),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    8.sbh,
                    Text("Section Title (20.fz)",
                        style: TextStyle(
                            fontSize: 20.fz, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    8.sbh,
                    Text("Display Header (30.fz)",
                        style: TextStyle(
                            fontSize: 30.fz,
                            fontWeight: FontWeight.w900,
                            color: Colors.indigo),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),

              24.sbh,

              // 4. 4K Protection
              _buildSectionTitle("4. 4K Protection"),
              Container(
                padding: 16.p,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: 12.br,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.shield_moon,
                      color: data.size.width > 1920
                          ? Colors.greenAccent
                          : Colors.grey,
                      size: 36.iz,
                    ),
                    16.sbw,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.size.width > 1920
                                ? "ACTIVE GUARD"
                                : "STANDBY MODE",
                            style: TextStyle(
                              color: data.size.width > 1920
                                  ? Colors.greenAccent
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.fz,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          4.sbh,
                          Text(
                            data.size.width > 1920
                                ? "Scaling dampened to save RAM"
                                : "Standard linear scaling",
                            style: TextStyle(
                                color: Colors.white70, fontSize: 12.fz),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              24.sbh,

              // 5. ScalifyBox Grid (The New Feature)
              _buildSectionTitle("5. ScalifyBox Grid (Local Scaling)"),
              _buildAdaptiveGrid(context),

              40.sbh,
            ],
          ),
        ),
      ),
    );
  }

  // --- Grid Logic Implementation ---
  Widget _buildAdaptiveGrid(BuildContext context) {
    final width = context.responsiveData.size.width;

    int columns;
    if (width <= 320) {
      columns = 1;
    } else if (width <= 700) {
      columns = 2;
    } else if (width <= 1024) {
      columns = 3;
    } else if (width <= 1400) {
      columns = 4;
    } else {
      columns = 5;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: 8.pb,
          child: Text(
              "Cols: $columns | Width: ${width.toInt()} | ScalifyBox Active",
              style: TextStyle(
                  fontSize: 12.fz,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic)),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 10,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16.s,
            mainAxisSpacing: 16.s,
            childAspectRatio: 1.0, // Square
          ),
          itemBuilder: (context, index) {
            return _buildGridItem(index);
          },
        ),
      ],
    );
  }

  Widget _buildGridItem(int index) {
    return ScalifyBox(
      referenceWidth: 100,
      referenceHeight: 200,
      fit: ScalifyFit.contain,
      builder: (context, ls) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: ls.br(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 4))
            ],
          ),
          padding: ls.p(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.dashboard_customize_rounded,
                color: Colors.indigo,
                size: ls.s(80),
              ),
              SizedBox(height: ls.s(10)),
              Text("Item #${index + 1}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: ls.fz(26)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              SizedBox(height: ls.s(4)),
              Text("Auto Fit UI",
                  style: TextStyle(color: Colors.grey, fontSize: ls.fz(20)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: 8.pb,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.fz,
          fontWeight: FontWeight.bold,
          color: Colors.indigo[900],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 18.fz,
                fontWeight: FontWeight.bold,
                color: Colors.indigo)),
        Text(label, style: TextStyle(fontSize: 11.fz, color: Colors.grey)),
      ],
    );
  }

  Widget _buildBox(double size, Color color, String label, double actualPx) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            border: Border.all(color: color, width: 2),
            borderRadius: 10.br,
          ),
          alignment: Alignment.center,
          child: Text(
            "${size.toInt()}",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 12.fz, color: color),
          ),
        ),
        8.sbh,
        Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10.fz, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
