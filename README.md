# Flutter Scalify 🚀

[![pub package](https://img.shields.io/pub/v/flutter_scalify.svg)](https://pub.dev/packages/flutter_scalify)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

**The Intelligent Scaling Engine for Flutter.**

Not just a screen adaptation tool, but a complete high-performance engine designed for Mobile, Web, and Desktop. Easily scale your UI elements (text, spacing, icons, containers) across all screen sizes with simple extensions and smart container queries.

## Why Scalify? ⚡️

| Feature | Scalify Engine 🚀 | Standard Solutions |
| :--- | :--- | :--- |
| **Performance** | ✅ **O(1) Inline Math** (Zero Overhead) | ❌ Complex Calculations |
| **Memory Efficiency** | ✅ **Zero Allocation** (No GC pressure) | ❌ High Memory Usage |
| **Layout System** | ✅ **Responsive Grid & Flex** (Built-in) | ❌ Manual calculations |
| **High-Res Adaptation** | ✅ **Smart Dampening** (Prevents UI explosion) | ❌ Linear Scaling Only |
| **Container Queries** | ✅ **AdaptiveContainer** (Scale by parent size) | ❌ Global Screen Only |

## Features ✨

- 🎯 **Simple API**: Use intuitive extensions like `16.fz`, `20.s`, `24.iz`.
- 📐 **Responsive Layouts**: Built-in `ResponsiveGrid`, `ResponsiveFlex`, and `ResponsiveLayout`.
- 📦 **Component-Driven**: `AdaptiveContainer` changes layout based on the widget's own size.
- 🛡️ **Ultra-High Res Safeguard**: Smart algorithm that prevents UI "explosion" on 4K and Ultra-wide screens.
- 📱 **Fully Responsive**: Adapts to Watch, Mobile, Tablet, Small Desktop, Desktop, and Large Desktop.
- ⚡ **Hyper Performance**: Uses `vm:prefer-inline` for direct memory access.
- 🔡 **Font Clamping (New)**: Optional control over minimum and maximum font sizes (e.g., 6.0 to 256.0).

## Responsive Preview

![Responsive Design Screenshots](./screenshots/screen.jpg)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_scalify: ^2.2.4

```

Then run:

```bash
flutter pub get

```

## Quick Start

### Wrap your app with ScalifyProvider

Initialize the engine with your design specifications.

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

## 📚 API Cheat Sheet (All Shortcuts)

Scalify provides a comprehensive set of extensions to make every part of your UI responsive.

### 1. Size & Font

| Extension | Usage | Result (Description) |
| --- | --- | --- |
| `.fz` | `16.fz` | **Font Size**: Scales text smartly + respects bounds. |
| `.iz` | `24.iz` | **Icon Size**: Scales icons proportionally. |
| `.s` | `20.s` | **Size/Space**: General scaling (margins/offsets). |
| `.w` | `100.w` | **Width**: Scales based on screen width. |
| `.h` | `50.h` | **Height**: Scales based on screen height. |
| `.r` | `12.r` | **Radius**: Calculates radius based on min(w, h). |
| `.si` | `10.si` | **Int**: Returns rounded integer for native APIs. |

### 2. Spacing (SizedBox)

Replace `SizedBox(height: 20)` with clean shortcuts.

| Extension | Usage | Result |
| --- | --- | --- |
| `.sbh` | `20.sbh` | `SizedBox(height: 20.h)` |
| `.sbw` | `10.sbw` | `SizedBox(width: 10.w)` |
| `.sbhw` | `20.sbhw(width: 10)` | `SizedBox(height: 20.h, width: 10.w)` |
| `.sbwh` | `10.sbwh(height: 20)` | `SizedBox(width: 10.w, height: 20.h)` |

### 3. Padding (EdgeInsets)

Use on `double` or `List<num>`.

| Extension | Usage | Result |
| --- | --- | --- |
| `.p` | `16.p` | `EdgeInsets.all(16)` |
| `.ph` | `16.ph` | `EdgeInsets.symmetric(horizontal: 16)` |
| `.pv` | `16.pv` | `EdgeInsets.symmetric(vertical: 16)` |
| `.pt` | `16.pt` | `EdgeInsets.only(top: 16)` |
| `.pb` | `16.pb` | `EdgeInsets.only(bottom: 16)` |
| `.pl` | `16.pl` | `EdgeInsets.only(left: 16)` |
| `.pr` | `16.pr` | `EdgeInsets.only(right: 16)` |
| **List API** | `[20, 10].p` | `EdgeInsets.symmetric(h: 20, v: 10)` |
| **List API** | `[10, 5, 10, 5].p` | `EdgeInsets.fromLTRB(10, 5, 10, 5)` |

### 4. Border Radius

| Extension | Usage | Result |
| --- | --- | --- |
| `.br` | `12.br` | `BorderRadius.circular(12)` |
| `.brt` | `12.brt` | `BorderRadius.only(topLeft, topRight)` |
| `.brb` | `12.brb` | `BorderRadius.only(bottomLeft, bottomRight)` |
| `.brl` | `12.brl` | `BorderRadius.only(topLeft, bottomLeft)` |
| `.brr` | `12.brr` | `BorderRadius.only(topRight, bottomRight)` |

---

## 💻 All-in-One Example

Here is how you write clean, responsive UI code using Scalify shortcuts:

```dart
Container(
  // Symmetric Padding: Horizontal 20, Vertical 10
  padding: [20, 10].p, 
  
  // Responsive Width & Height
  width: 300.w,
  height: 200.h,
  
  decoration: BoxDecoration(
    color: Colors.white,
    // Top-only Border Radius
    borderRadius: 20.brt, 
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        // General scaling for offsets
        offset: Offset(0, 4.s), 
        blurRadius: 10.s,
      )
    ],
  ),
  child: Column(
    children: [
      // Icon Size
      Icon(Icons.star, size: 32.iz), 
      
      // Spacing (Height)
      16.sbh, 
      
      Text(
        "Scalify",
        // Smart Font Size
        style: TextStyle(fontSize: 24.fz, fontWeight: FontWeight.bold), 
      ),
      
      // Spacing (Height)
      8.sbh,
      
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Start", style: TextStyle(fontSize: 14.fz)),
          // Spacing (Width)
          8.sbw, 
          Icon(Icons.arrow_forward, size: 16.iz),
        ],
      )
    ],
  ),
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
  fit: ScalifyFit.contain,
  alignment: Alignment.center,
  builder: (context, ls) {
    return Container(
      // Use 'ls' (Local Scaler) instead of global context
      width: ls.w(300), 
      height: ls.h(180),
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

## 🔡 Font Clamping (Advanced Control)

Sometimes you want the UI to scale, but you need to ensure text remains readable (not too small) and doesn't break layout (not too big).

You can globally clamp font sizes in `ScalifyConfig`:

```dart
ScalifyConfig(
  // ... other config
  minFontSize: 6.0,   // Text will never be smaller than 6px
  maxFontSize: 256.0,   // Text will never exceed 256px
)

```
This applies to both `.fz` and `ThemeData.scale()`.

---
## 🔄 Live Resizing (Desktop & Web)


By default, Flutter optimizes performance by not rebuilding widgets that don't explicitly listen to changes. To make your UI elements (like .fz, .w, .h) adapt instantly while dragging the window on Desktop or Web, you have two professional options:

Option 1: Using ScalifyBuilder (Recommended)
Wrap your screen or specific component with ScalifyBuilder. This is the cleanest way to ensure live updates.

```dart

ScalifyBuilder(
  builder: (context, data) {
    return Scaffold(
      body: Center(
        child: Text("Responsive Text", style: TextStyle(fontSize: 20.fz)),
      ),
    );
  },
)
```

Option 2: Direct Subscription
Simply call context.responsiveData at the top of your build method. This "subscribes" the widget to resize events.

```dart
@override
Widget build(BuildContext context) {
  context.responsiveData; // 👈 Enables live scaling for this build context
  return Scaffold(...);
}


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