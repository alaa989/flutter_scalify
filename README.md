# Flutter Scalify 🚀

[![pub package](https://img.shields.io/pub/v/flutter_scalify.svg)](https://pub.dev/packages/flutter_scalify)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

**The Intelligent Scaling Engine for Flutter.**

Not just a screen adaptation tool, but a complete high-performance engine designed for Mobile, Web, and Desktop. Easily scale your UI elements (text, spacing, icons, containers) across all screen sizes with simple extensions and smart container queries.

## Why Scalify? ⚡️

| Feature | Scalify Engine 🚀 | Standard Solutions |
| --- | --- | --- |
| **Performance** | ✅ **O(1) Inline Math** (Zero Overhead) | ❌ Complex Calculations |
| **Memory Efficiency** | ✅ **Zero Allocation** (No GC pressure) | ❌ High Memory Usage |
| **Layout System** | ✅ **Responsive Grid & Flex** (Built-in) | ❌ Manual calculations |
| **High-Res Adaptation** | ✅ **Smart Dampening** (Prevents UI explosion) | ❌ Linear Scaling Only |
| **Container Queries** | ✅ **AdaptiveContainer** (Scale by parent size) | ❌ Global Screen Only |

## Features ✨

* 🎯 **Simple API**: Use intuitive extensions like `16.fz`, `20.s`, `24.iz`.
* 📐 **Responsive Layouts**: Built-in `ResponsiveGrid`, `ResponsiveFlex`, and `ResponsiveLayout`.
* 📦 **Component-Driven**: `AdaptiveContainer` changes layout based on the widget's own size.
* 🛡️ **Ultra-High Res Safeguard**: Smart algorithm that prevents UI "explosion" on 4K and Ultra-wide screens.
* 📱 **Fully Responsive**: Adapts to Watch, Mobile, Tablet, Small Desktop, Desktop, and Large Desktop.
* ⚡ **Hyper Performance**: Uses `vm:prefer-inline` for direct memory access.
* 🔡 **Font Clamping (New)**: Optional control over minimum and maximum font sizes (e.g., 6.0 to 256.0).

## Responsive Preview

![Responsive Design Screenshots](./screenshots/screen.jpg)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_scalify: ^2.2.0

```

Then run:

```bash
flutter pub get

```

## Quick Start

### Wrap your app with ScalifyProvider

Initialize the engine with your design specifications. You can now optionally define font size limits.

```dart
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
      builder: (context, child) {
        return ScalifyProvider(
          config: const ScalifyConfig(
            designWidth: 375,
            designHeight: 812,
            minScale: 0.5,
            maxScale: 3.0,
            // 🔡 Optional: Font Clamping (New in v2.2.0)
            minFontSize: 6.0, 
            maxFontSize: 256.0,
            // 🛡️ High-Res Adaptation (Smart Dampening)
            memoryProtectionThreshold: 1920.0, 
            highResScaleFactor: 0.60, 
          ),
          child: child ?? const SizedBox(),
        );
      },
      home: const HomeScreen(),
    );
  }
}

```

---

## 🛠️ Core Extensions (Global Scaling)

Scale elements based on the screen size using simple getters.

| Extension | Description | Usage |
| --- | --- | --- |
| `.fz` | Smart Font Size (Respects scale + accessibility + Clamping) | `16.fz` |
| `.s` | General Scaling (Use for padding/margins) | `20.s` |
| `.w` | Width Scaling | `100.w` |
| `.h` | Height Scaling | `50.h` |
| `.iz` | Icon Size Scaling | `24.iz` |
| `.r` | Radius Scaling (Smoother curve) | `12.r` |
| `.sbh` | SizedBox with Height | `20.sbh` |
| `.sbw` | SizedBox with Width | `10.sbw` |

**Example:**

```dart
Container(
  padding: 16.p,
  width: 200.w,
  decoration: BoxDecoration(borderRadius: 12.br),
  child: Text("Hello", style: TextStyle(fontSize: 16.fz)),
)

```

---

## 🛡️ AppWidthLimiter (Ultra-High Res Safeguard)

Wrap your screen to center content and reset scaling on ultra-wide screens. This prevents your UI from becoming excessively large on 4K monitors/Desktops while maintaining aesthetic proportions.

```dart
AppWidthLimiter(
  maxWidth: 1400,
  horizontalPadding: 16,
  backgroundColor: const Color(0xFFE2E8F0),
  child: YourMainScreen(),
)

```

---

## 📦 ScalifyBox (Local Scaling)

Proportionally scale elements within a specific area (like a Credit Card). It ensures elements maintain their positions and ratios exactly regardless of screen size.

```dart
ScalifyBox(
  referenceWidth: 320, 
  referenceHeight: 200,
  builder: (context, ls) {
    return Container(
      padding: ls.p(20), 
      child: Text("VISA", style: TextStyle(fontSize: ls.fz(18))),
    );
  },
)

```

---

## 🎨 Scalify Theme Scaling (Zero Boilerplate)

Automatically scale your entire app's text theme with a single line. No need to add `.fz` manually to every text widget.

```dart
MaterialApp(
  // Scales all text styles in the theme automatically
  theme: ThemeData.light().scale(context), 
  home: const HomeScreen(),
)

```

---

## 🚀 Responsive Layout Widgets

### 1. ResponsiveGrid (The Ultimate Grid)

A powerful grid that supports **Manual Control** (columns per screen) and **Auto-Fit** (API data). It handles spacing automatically.

**Mode A: Manual Columns (Static UI)**

```dart
ResponsiveGrid(
  useSliver: false,
  spacing: 16,
  runSpacing: 16,
  watch: 1,
  mobile: 2,
  tablet: 3,
  desktop: 4,
  children: [/* ... widgets ... */],
)

```

**Mode B: Auto-Fit (Dynamic/API Data)**

```dart
ResponsiveGrid(
  minItemWidth: 150, 
  itemCount: apiData.length,
  itemBuilder: (context, index) => MyCard(data: apiData[index]),
)

```

### 2. ResponsiveFlex (Row <-> Column)

A smart widget that switches between `Row` and `Column` based on the screen width.

```dart
ResponsiveFlex(
  switchOn: ScreenType.mobile, 
  spacing: 20,
  children: [
    UserAvatar(),
    UserName(),
  ],
)

```

### 3. ResponsiveLayout (Orientation Switch)

Effortlessly switch between Portrait and Landscape layouts using Scalify metrics.

```dart
ResponsiveLayout(
  portrait: Column(children: [Image(), Bio()]),
  landscape: Row(children: [Image(), Bio()]),
)

```

### 4. AdaptiveContainer (Component-Driven)

This widget rebuilds based on its **own width** (Parent Constraints), NOT the screen width.

```dart
AdaptiveContainer(
  breakpoints: const [200, 500], 
  xs: Icon(Icons.home),
  sm: Column(children: [...]),
  lg: Row(children: [...]),
)

```

---

## 👁️ Logic & Visibility

### ResponsiveVisibility (The Bouncer)

Show or hide widgets based on the current screen type without using messy `if` statements.

```dart
ResponsiveVisibility(
  visibleOn: [ScreenType.mobile], // Whitelist
  child: MobileOnlyWidget(),
)

ResponsiveVisibility(
  hiddenOn: [ScreenType.desktop], // Blacklist
  child: SideDrawer(),
)

```

### ResponsiveBuilder (Direct Logic)

Access `ResponsiveData` directly inside your widget tree for complex custom logic.

```dart
ResponsiveBuilder(
  builder: (context, data) {
    return Text("Current Width: ${data.size.width}");
  },
)

```

### Conditional Logic (`valueByScreen`)

Return different values based on the device type.

```dart
double width = context.valueByScreen(
  mobile: 300, 
  tablet: 500, 
  desktop: 800
);

```

---

## Screen Breakpoints

| Device Type | Width Range |
| --- | --- |
| **Watch** | `< 300px` |
| **Mobile** | `300px - 600px` |
| **Tablet** | `600px - 900px` |
| **Small Desktop** | `900px - 1200px` |
| **Desktop** | `1200px - 1800px` |
| **Large Desktop** | `> 1800px` |

Check out the [example](example/) directory for a complete, beautiful example app that demonstrates all features including a responsive grid that adapts to different screen sizes.

## Author

**Alaa Hassan Damad**

  - Email: alaahassanak772@gmail.com
  - Country: Iraq