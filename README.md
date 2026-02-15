# Flutter Scalify 🚀

[![pub package](https://img.shields.io/pub/v/flutter_scalify.svg)](https://pub.dev/packages/flutter_scalify)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2.svg)](https://dart.dev)
[![Tests](https://img.shields.io/badge/Tests-203%20passed-brightgreen.svg)](#)
[![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS%20|%20Web%20|%20macOS%20|%20Linux%20|%20Windows-purple.svg)](#)

**The Intelligent Scaling Engine for Flutter.**

A complete, high-performance responsive system — not just a sizing tool. Scale your entire UI across Mobile, Web, and Desktop with simple extensions, smart container queries, and zero overhead.

<p align="center">
  <img src="https://raw.githubusercontent.com/alaa989/flutter_scalify/master/screenshots/demo.gif" alt="Scalify Responsive Demo" width="600"/>
</p>

---

## Why Scalify? ⚡️

| Feature | Scalify |
| :--- | :---: |
| **O(1) Inline Math** (vm:prefer-inline) | ✅ |
| **Container Queries** (Rebuild by parent size) | ✅ |
| **4K/Ultra-Wide Smart Dampening** | ✅ |
| **Responsive Grid System** (6-Tier) | ✅ |
| **Builder Pattern** (Above MaterialApp) | ✅ |
| **InheritedModel** (Granular Rebuild) | ✅ |
| **Debounce on Resize** (Desktop/Web) | ✅ |
| **Local Scaler** (ScalifyBox) | ✅ |
| **6 Screen Types** (Watch → Large Desktop) | ✅ |
| **Theme Auto-Scaling** (One line) | ✅ |
| **Percentage Scaling** (.pw .hp) | ✅ |
| **Zero External Dependencies** | ✅ |
| **203 Tests Passing** | ✅ |

---

## Features ✨

- 🎯 **Simple API** — `16.fz`, `20.s`, `24.iz`, `300.w` — just add an extension
- 📐 **Responsive Layouts** — Built-in `ResponsiveGrid`, `ResponsiveFlex`, `ResponsiveLayout`
- 📦 **Container Queries** — `ContainerQuery` & `AdaptiveContainer` rebuild based on parent size
- 🛡️ **4K Protection** — Smart dampening prevents UI explosion on ultra-wide screens
- 📱 **6-Tier System** — Watch, Mobile, Tablet, Small Desktop, Desktop, Large Desktop
- ⚡ **Hyper Performance** — `vm:prefer-inline`, Quantized IDs, InheritedModel, Debounce
- 🔡 **Font Clamping** — Configurable min/max font bounds (never too small or too big)
- 🎨 **Theme Scaling** — `ThemeData.scale(context)` — one line, entire theme scaled
- 🧱 **Local Scaling** — `ScalifyBox` scales elements relative to their container
- 📊 **Percentage Scaling** — `50.pw` = 50% of screen width, `25.hp` = 25% of height

---

## Responsive Preview

![Responsive Design Screenshots](./screenshots/screen.jpg)

---

## Installation

```yaml
dependencies:
  flutter_scalify: ^3.0.0
```

```bash
flutter pub get
```

---

## Quick Start

### ✅ Recommended: Builder Pattern (ScalifyProvider wraps MaterialApp)

This is the **best practice** for maximum performance. Placing `ScalifyProvider` **above** `MaterialApp` prevents cascading rebuilds when screen size changes.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_scalify/flutter_scalify.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScalifyProvider(
      config: const ScalifyConfig(
        designWidth: 375,    // Your Figma/XD design width
        designHeight: 812,   // Your Figma/XD design height
      ),
      builder: (context, child) => MaterialApp(
        theme: ThemeData.light().scale(context), // 🎨 Auto-scale theme
        home: child,
      ),
      child: const HomeScreen(),
    );
  }
}
```

### Alternative: Child Pattern (ScalifyProvider inside MaterialApp)

```dart
MaterialApp(
  builder: (context, child) {
    return ScalifyProvider(
      config: const ScalifyConfig(designWidth: 375, designHeight: 812),
      child: child ?? const SizedBox(),
    );
  },
  home: const HomeScreen(),
);
```

> 💡 **Tip:** The builder pattern is recommended because it puts `ScalifyProvider` above `MaterialApp`, so changing window size doesn't rebuild `MaterialApp` itself.

---

## 📚 API Cheat Sheet

### 1. Size & Font

| Extension | Example | Description |
| :---: | :--- | :--- |
| `.w` | `100.w` | **Width** — Scales based on screen width ratio |
| `.h` | `50.h` | **Height** — Scales based on screen height ratio |
| `.s` | `20.s` | **Size** — General scaling (min of width/height) |
| `.fz` | `16.fz` | **Font Size** — Scaled + clamped + accessibility |
| `.iz` | `24.iz` | **Icon Size** — Proportional icon scaling |
| `.r` | `12.r` | **Radius** — Based on min(scaleWidth, scaleHeight) |
| `.si` | `10.si` | **Scaled Int** — Rounded integer for native APIs |
| `.sc` | `16.sc` | **Scale** — Alias for `.s` |
| `.ui` | `16.ui` | **UI** — Alias for `.s` |

### 2. Percentage Scaling

| Extension | Example | Description |
| :---: | :--- | :--- |
| `.pw` | `50.pw` | **50% of screen width** |
| `.hp` | `25.hp` | **25% of screen height** |

### 3. Spacing (SizedBox)

| Extension | Example | Output |
| :---: | :--- | :--- |
| `.sbh` | `20.sbh` | `SizedBox(height: 20.h)` |
| `.sbw` | `10.sbw` | `SizedBox(width: 10.w)` |
| `.sbhw()` | `20.sbhw(width: 10)` | `SizedBox(height: 20.h, width: 10.w)` |
| `.sbwh()` | `10.sbwh(height: 20)` | `SizedBox(width: 10.w, height: 20.h)` |

### 4. Padding (EdgeInsets)

| Extension | Example | Output |
| :---: | :--- | :--- |
| `.p` | `16.p` | `EdgeInsets.all(16.s)` |
| `.ph` | `16.ph` | `EdgeInsets.symmetric(horizontal: 16.w)` |
| `.pv` | `16.pv` | `EdgeInsets.symmetric(vertical: 16.h)` |
| `.pt` | `16.pt` | `EdgeInsets.only(top: 16.h)` |
| `.pb` | `16.pb` | `EdgeInsets.only(bottom: 16.h)` |
| `.pl` | `16.pl` | `EdgeInsets.only(left: 16.w)` |
| `.pr` | `16.pr` | `EdgeInsets.only(right: 16.w)` |

**List Shorthand:**

```dart
[20, 10].p      // EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h)
[10, 5, 10, 5].p // EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h)
```

### 5. Border Radius

| Extension | Example | Output |
| :---: | :--- | :--- |
| `.br` | `12.br` | `BorderRadius.circular(12.r)` |
| `.brt` | `12.brt` | Top corners only |
| `.brb` | `12.brb` | Bottom corners only |
| `.brl` | `12.brl` | Left corners only |
| `.brr` | `12.brr` | Right corners only |

### 6. Context API (for `const` widgets)

When widgets are inside a `const` tree and can't use global extensions, use context:

```dart
context.w(100)    // Width scaling
context.h(50)     // Height scaling
context.r(12)     // Radius (min of scaleWidth/scaleHeight)
context.sp(16)    // Scale factor
context.fz(18)    // Font size (clamped + accessibility)
context.iz(24)    // Icon size
context.s(10)     // General scale
context.pw(50)    // 50% of screen width
context.hp(25)    // 25% of screen height
```

---

## 💻 Complete Example

```dart
Container(
  padding: [20, 10].p,           // Symmetric padding
  width: 300.w,                   // Responsive width
  height: 200.h,                  // Responsive height
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: 20.brt,         // Top border radius
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        offset: Offset(0, 4.s),   // Scaled offset
        blurRadius: 10.s,
      )
    ],
  ),
  child: Column(
    children: [
      Icon(Icons.star, size: 32.iz),                                  // Scaled icon
      16.sbh,                                                          // Spacing
      Text("Scalify", style: TextStyle(fontSize: 24.fz)),             // Scaled font
      8.sbh,
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Start", style: TextStyle(fontSize: 14.fz)),
          8.sbw,                                                       // Width spacing
          Icon(Icons.arrow_forward, size: 16.iz),
        ],
      )
    ],
  ),
)
```

---

## 🚀 Responsive Widgets

### ResponsiveGrid — The Ultimate Grid

Supports **Manual Columns** (per screen type) and **Auto-Fit** (dynamic data).

**Manual Mode:**

```dart
ResponsiveGrid(
  spacing: 16,
  runSpacing: 16,
  watch: 1,
  mobile: 2,
  tablet: 3,
  smallDesktop: 3,
  desktop: 4,
  largeDesktop: 5,
  children: [/* widgets */],
)
```

**Auto-Fit Mode (API data):**

```dart
ResponsiveGrid(
  minItemWidth: 150,
  itemCount: products.length,
  itemBuilder: (context, index) => ProductCard(data: products[index]),
)
```

**Sliver Mode (infinite scroll):**

```dart
CustomScrollView(
  slivers: [
    ResponsiveGrid(
      useSliver: true,
      mobile: 2,
      desktop: 4,
      itemCount: 100,
      itemBuilder: (context, i) => ItemCard(i),
    ),
  ],
)
```

---

### ResponsiveFlex — Row ↔ Column

Automatically switches between `Row` and `Column` based on screen width.

```dart
ResponsiveFlex(
  switchOn: ScreenType.mobile,    // Column on mobile, Row on larger
  spacing: 20,
  flipOnRtl: true,                // RTL support
  children: [
    UserAvatar(),
    UserInfo(),
  ],
)
```

**Custom breakpoint:**

```dart
ResponsiveFlex(
  breakpoint: 600,                // Column when width < 600
  children: [Widget1(), Widget2()],
)
```

---

### ResponsiveLayout — Orientation Switch

```dart
ResponsiveLayout(
  portrait: Column(children: [Image(), Bio()]),
  landscape: Row(children: [Image(), Bio()]),
)
```

---

### ResponsiveVisibility — Show/Hide by Screen Type

```dart
// Whitelist: Show ONLY on mobile
ResponsiveVisibility(
  visibleOn: [ScreenType.mobile],
  child: MobileNavBar(),
)

// Blacklist: Hide on desktop
ResponsiveVisibility(
  hiddenOn: [ScreenType.desktop, ScreenType.largeDesktop],
  replacement: DesktopSidebar(),   // Optional replacement widget
  child: MobileDrawer(),
)
```

---

### ResponsiveBuilder — Direct Data Access

```dart
ResponsiveBuilder(
  builder: (context, data) {
    return Text("Screen: ${data.screenType} — ${data.width.toInt()}px");
  },
)
```

---

### Conditional Logic — `valueByScreen`

```dart
final columns = context.valueByScreen<int>(
  mobile: 2,
  tablet: 3,
  desktop: 4,
  largeDesktop: 6,
);
```

---

## 📦 Container Queries

### ContainerQuery — Rebuild by Parent Size

Unlike `MediaQuery` which reads the **screen** size, `ContainerQuery` reads the **parent widget's** size. Perfect for reusable components.

```dart
ContainerQuery(
  breakpoints: [200, 400, 800],
  onChanged: (prev, current) => print("Tier: ${current.tier}"),
  builder: (context, query) {
    if (query.isMobile) return CompactCard();
    if (query.isTablet) return MediumCard();
    return FullCard();
  },
)
```

**QueryTier values:** `xs`, `sm`, `md`, `lg`, `xl`, `xxl`

---

### AdaptiveContainer — Tier-Based Widgets

```dart
AdaptiveContainer(
  breakpoints: [200, 500],
  xs: Icon(Icons.home),                    // < 200px
  sm: Column(children: [Icon(), Text()]),  // 200-500px
  lg: Row(children: [Icon(), Text(), Button()]),  // > 500px
)
```

---

## 🧱 ScalifyBox — Local Scaling

Scale elements relative to a **specific container** instead of the screen. Perfect for credit cards, game UIs, and embedded components.

```dart
ScalifyBox(
  referenceWidth: 320,
  referenceHeight: 200,
  fit: ScalifyFit.contain,    // width | height | contain | cover
  builder: (context, ls) {
    return Container(
      width: ls.w(300),         // Local width scaling
      height: ls.h(180),        // Local height scaling
      padding: ls.p(20),        // Local padding
      decoration: BoxDecoration(
        borderRadius: ls.br(12), // Local border radius
      ),
      child: Column(
        children: [
          Text("VISA", style: TextStyle(fontSize: ls.fz(18))),
          ls.sbh(10),            // Local spacing
        ],
      ),
    );
  },
)
```

**LocalScaler API:**

| Method | Description |
| :--- | :--- |
| `ls.w(value)` | Local width scaling |
| `ls.h(value)` | Local height scaling |
| `ls.s(value)` | Local general scaling |
| `ls.fz(value)` | Local font size (clamped) |
| `ls.iz(value)` | Local icon size |
| `ls.si(value)` | Rounded int |
| `ls.p(value)` | `EdgeInsets.all` |
| `ls.ph(value)` | Horizontal padding |
| `ls.pv(value)` | Vertical padding |
| `ls.br(value)` | `BorderRadius.circular` |
| `ls.r(value)` | `Radius.circular` |
| `ls.sbh(value)` | `SizedBox(height:)` |
| `ls.sbw(value)` | `SizedBox(width:)` |
| `ls.scaleFactor` | Current scale value |

---

## 🛡️ AppWidthLimiter — Ultra-Wide Protection

Centers and constrains your app on ultra-wide monitors.

```dart
AppWidthLimiter(
  maxWidth: 1400,
  minWidth: 360,               // Enables horizontal scroll below 360px
  horizontalPadding: 16,
  backgroundColor: Color(0xFFE2E8F0),
  child: YourApp(),
)
```

---

## 🎨 Theme Auto-Scaling

Scale your **entire** app theme with one line — no need to add `.fz` to every text widget.

```dart
ScalifyProvider(
  builder: (context, child) => MaterialApp(
    theme: ThemeData.light().scale(context),  // ✨ One line!
    home: child,
  ),
  child: const HomeScreen(),
)
```

> 💡 Automatically skips scaling when `scaleFactor == 1.0` for zero overhead.

---

## 🔄 Live Resizing (Desktop & Web)

For instant UI updates while dragging the window:

**Option 1: ScalifyBuilder (Recommended)**

```dart
ScalifyBuilder(
  builder: (context, data) {
    return Scaffold(
      body: Center(
        child: Text("${data.width.toInt()}px", style: TextStyle(fontSize: 20.fz)),
      ),
    );
  },
)
```

**Option 2: Direct Subscription**

```dart
@override
Widget build(BuildContext context) {
  context.responsiveData;  // 👈 Subscribe to resize events
  return Scaffold(/* ... */);
}
```

---

## ⚙️ ScalifyConfig — Full Reference

```dart
ScalifyConfig(
  // 📐 Design Baseline
  designWidth: 375.0,             // Figma/XD design width
  designHeight: 812.0,            // Figma/XD design height

  // 📱 Breakpoints (Customizable)
  watchBreakpoint: 300.0,         // < 300 = Watch
  mobileBreakpoint: 600.0,        // 300-600 = Mobile
  tabletBreakpoint: 900.0,        // 600-900 = Tablet
  smallDesktopBreakpoint: 1200.0,  // 900-1200 = Small Desktop
  desktopBreakpoint: 1800.0,      // 1200-1800 = Desktop
  //                               // > 1800 = Large Desktop

  // 🔡 Font Control
  minFontSize: 6.0,               // Floor for .fz
  maxFontSize: 256.0,             // Ceiling for .fz
  respectTextScaleFactor: true,   // System accessibility support

  // 📏 Scale Bounds
  minScale: 0.5,                  // Minimum scale factor
  maxScale: 4.0,                  // Maximum scale factor

  // 🛡️ 4K Protection
  memoryProtectionThreshold: 1920.0,  // Where dampening kicks in
  highResScaleFactor: 0.65,           // Dampening strength (0-1)

  // ⚡ Performance
  debounceWindowMillis: 120,          // Resize debounce (ms)
  rebuildScaleThreshold: 0.01,        // Min scale change to rebuild
  rebuildWidthPxThreshold: 4.0,       // Min px change to rebuild
  enableGranularNotifications: false, // InheritedModel aspects

  // 🔄 Orientation
  autoSwapDimensions: false,          // Swap design W/H in landscape

  // 🔧 Minimum Window Width
  minWidth: 0.0,                      // Enables horizontal scroll below this

  // 🏷️ Legacy
  legacyContainerTierMapping: false,  // v1 compatibility
  showDeprecationBanner: true,        // Debug banner for legacy mode
)
```

---

## 📱 Screen Breakpoints

```
┌──────────────┬─────────────────┬──────────────────────────┐
│  Screen Type │   Width Range   │        Enum Value        │
├──────────────┼─────────────────┼──────────────────────────┤
│  Watch       │     < 300px     │  ScreenType.watch        │
│  Mobile      │  300px - 600px  │  ScreenType.mobile       │
│  Tablet      │  600px - 900px  │  ScreenType.tablet       │
│  Small DT    │  900px - 1200px │  ScreenType.smallDesktop │
│  Desktop     │ 1200px - 1800px │  ScreenType.desktop      │
│  Large DT    │    > 1800px     │  ScreenType.largeDesktop │
└──────────────┴─────────────────┴──────────────────────────┘
```

---

## 🧠 Advanced: How the Engine Works

### Quantized IDs (Jitter Prevention)

Scalify converts floating-point scale values to integer IDs (×1000). This prevents "phantom rebuilds" caused by microscopic floating-point differences:

```
100.0 → ID: 1000
100.0000001 → ID: 1000  ← Same ID, no rebuild!
```

### InheritedModel Aspects

Enable granular notifications to rebuild widgets **only** when specific data changes:

```dart
// Only rebuilds when screen TYPE changes (not on every pixel resize)
ScalifyProvider.of(context, aspect: ScalifyAspect.type);

// Only rebuilds when scale FACTOR changes
ScalifyProvider.of(context, aspect: ScalifyAspect.scale);

// Only rebuilds when text scale changes (accessibility)
ScalifyProvider.of(context, aspect: ScalifyAspect.text);
```

Enable in config:

```dart
ScalifyConfig(enableGranularNotifications: true)
```

### Debounce on Resize

On Desktop/Web, window resizing fires hundreds of events per second. Scalify debounces these with a configurable window (default 120ms), calculating the layout **once** after the user stops dragging.

### 4K Smart Dampening

For screens wider than `memoryProtectionThreshold` (default 1920px):

```
Normal: scale = screenWidth / designWidth
4K:     scale = thresholdScale + (excessWidth / designWidth × dampFactor)
```

This prevents text from becoming 5× the intended size on ultra-wide monitors.

---

## 📋 Migration from v2.x → v3.0.0

### 1. Builder Pattern (Recommended)

```diff
- MaterialApp(
-   builder: (context, child) => ScalifyProvider(child: child),
-   home: HomeScreen(),
- )
+ ScalifyProvider(
+   builder: (context, child) => MaterialApp(home: child),
+   child: const HomeScreen(),
+ )
```

### 2. Context API for `const` Widgets

```diff
- // Won't update in const trees
- Text("Hi", style: TextStyle(fontSize: 16.fz))

+ // Always updates via context
+ Builder(
+   builder: (context) => Text(
+     "Hi",
+     style: TextStyle(fontSize: context.sp(16)),
+   ),
+ )
```

### 3. Percentage Scaling (New)

```dart
SizedBox(width: 50.pw)   // 50% of screen width
SizedBox(height: 25.hp)  // 25% of screen height
```

### 4. Theme Scaling (New)

```dart
MaterialApp(
  theme: ThemeData.light().scale(context),
)
```

---

## 🧪 Testing

The package includes **203 comprehensive tests** covering all widgets, extensions, and edge cases:

```bash
flutter test --reporter compact
# 00:02 +203: All tests passed!
```

---

## Author

**Alaa Hassan Damad**
- Email: alaahassanak772@gmail.com
- Country: Iraq

---

## License

MIT License — see [LICENSE](LICENSE) for details.