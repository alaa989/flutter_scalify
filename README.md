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
| **4K Support** | ✅ **Smart Dampening** (Prevents UI explosion) | ❌ Linear Scaling Only |
| **Container Queries** | ✅ **AdaptiveContainer** (Scale by parent size) | ❌ Global Screen Only |

## Features ✨

- 🎯 **Simple API**: Use intuitive extensions like `16.fz`, `20.s`, `24.iz`.
- 📐 **Responsive Layouts**: Built-in `ResponsiveGrid` and `ResponsiveFlex` widgets.
- 📦 **Component-Driven**: `AdaptiveContainer` changes layout based on the widget's own size.
- 🛡️ **4K Protection**: Smart algorithm that resets scaling on ultra-wide screens to maintain aesthetics.
- 📱 **Fully Responsive**: Adapts to Watch, Mobile, Tablet, Small Desktop, Desktop, and Large Desktop.
- ⚡ **Hyper Performance**: Uses `vm:prefer-inline` for direct memory access.

## Responsive Preview

![Responsive Design Screenshots](./screenshots/screen.jpg)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_scalify: ^2.1.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1\. Wrap your app with ResponsiveProvider

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
        return ResponsiveProvider(
          config: const ResponsiveConfig(
            designWidth: 375,
            designHeight: 812,
            minScale: 0.5,
            maxScale: 3.0,
            // 🛡️ Protects UI on large screens (4K/UltraWide)
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

-----

## 🚀 Layout Widgets (New in v2.1.0)

### 1\. ResponsiveGrid (The Ultimate Grid)

A powerful grid that supports **Manual Control** (columns per screen) and **Auto-Fit** (API data). It handles spacing automatically.

**Mode A: Manual Columns (Static UI)**
Define exactly how many columns you want for each screen size.

```dart
ResponsiveGrid(
  useSliver: false, // Set true if inside CustomScrollView
  spacing: 16,
  runSpacing: 16,
  // Define columns for each tier:
  watch: 1,
  mobile: 2,
  tablet: 3,
  smallDesktop: 4,
  desktop: 5,
  largeDesktop: 6,
  children: [/* ... widgets ... */],
)
```

**Mode B: Auto-Fit (Dynamic/API Data)**
Perfect for fetching data from an API. Items will fill the row based on a minimum width.

```dart
ResponsiveGrid(
  // Items will be at least 150px wide. 
  // The grid will calculate how many fit in the row automatically.
  minItemWidth: 150, 
  scaleMinItemWidth: true, // Should the 150px scale with screen?
  itemCount: apiData.length,
  itemBuilder: (context, index) {
    return MyCard(data: apiData[index]);
  },
)
```

### 2\. ResponsiveFlex (Row \<-\> Column)

A smart widget that switches between `Row` and `Column` based on the screen width. Perfect for **Profile Headers** or **Action Bars**.

```dart
ResponsiveFlex(
  // Switch to Column layout when screen is Mobile or smaller
  switchOn: ScreenType.mobile, 
  spacing: 20, // Adds space between items automatically
  
  // Alignment changes based on the layout mode
  colMainAxisAlignment: MainAxisAlignment.center,
  rowMainAxisAlignment: MainAxisAlignment.start,
  
  children: [
    UserAvatar(),
    UserName(),
    SettingsButton(),
  ],
)
```

### 3\. AdaptiveContainer (Component-Driven)

This widget rebuilds its child based on its **own width** (Parent Constraints), NOT the screen width. Perfect for reusable cards that look different in a Sidebar vs. Main Content.

```dart
AdaptiveContainer(
  // Define breakpoints for the CONTAINER width
  breakpoints: const [200, 500], 
  
  xs: Icon(Icons.home),           // < 200px (Icon only)
  sm: Column(children: [...]),    // 200px - 500px (Vertical Layout)
  lg: Row(children: [...]),       // > 500px (Horizontal Layout)
)
```

-----

## 🛠️ Core Extensions (Global Scaling)

Scale elements based on the screen size using simple getters.

| Extension | Description | Usage |
| :--- | :--- | :--- |
| `.fz` | Smart Font Size (Respects scale + accessibility) | `16.fz` |
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
  padding: 16.p,              // Padding all
  margin: [20, 10].p,         // [Horizontal, Vertical]
  width: 200.w,
  height: 100.h,
  decoration: BoxDecoration(
    borderRadius: 12.br,      // Radius
  ),
  child: Text("Hello", style: TextStyle(fontSize: 16.fz)),
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

-----

## 📦 ScalifyBox (Local Scaling)

Use `ScalifyBox` to scale elements proportionally within a specific area (like a Credit Card or a complex Graphic). It ensures elements maintain their positions and ratios exactly.

```dart
ScalifyBox(
  referenceWidth: 320, 
  referenceHeight: 200,
  fit: ScalifyFit.contain,
  builder: (context, ls) { // ls = LocalScaler
    return Container(
      // Use 'ls' instead of global extensions
      padding: ls.p(20), 
      child: Text("VISA", style: TextStyle(fontSize: ls.fz(18))),
    );
  },
)
```

-----

## 🛡️ AppWidthLimiter (Desktop Protection)

Wrap your `Scaffold` or `Home` screen with this to prevent the app from stretching too wide on large screens. It creates a "centered layout" effect and **resets the scaling logic** so your fonts don't become gigantic on 4K screens.

```dart
AppWidthLimiter(
  maxWidth: 1400, // Content will never exceed 1400px
  horizontalPadding: 16,
  backgroundColor: Colors.grey[100],
  child: YourMainScreen(),
)
```

-----

## Screen Breakpoints

The package automatically detects screen sizes based on width:

| Device Type | Width Range |
| :--- | :--- |
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