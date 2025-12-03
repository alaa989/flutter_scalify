# Flutter Scalify 🚀

[![pub package](https://img.shields.io/pub/v/flutter_scalify.svg)](https://pub.dev/packages/flutter_scalify)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A powerful and elegant Flutter package for responsive design. Easily scale your UI elements (text, spacing, icons, containers) across all screen sizes with simple extensions.

**Developed with by Alaa Hassan Damad**
Iraq 🇮🇶

## Features ✨

- 🎯 **Simple API**: Use intuitive extensions like `16.fz`, `20.s`, `24.iz`.
- 📱 **Fully Responsive**: Automatically adapts to Mobile, Tablet, Desktop, and Large Desktop.
- 🎨 **Comprehensive**: Scale fonts, spacing, icons, widths, heights, border radius, and more.
- ⚡️ **Performance**: Lightweight, optimized, and includes debounce handling for window resizing.
- 🔧 **Flexible**: Works with any Flutter widget.

### Advanced / Precision features (v1.0.1)



- 🔁 **Two-axis scaling**: The system calculates both a width-driven scale (`scaleWidth`) and a height-driven scale (`scaleHeight`), and exposes a combined `scaleFactor`. This improves visual consistency on ultra-wide, short, or tall screens.
- 🔡 **Text accessibility**: Font sizes produced by `.fz` respect the device's system text scale factor when enabled (use `ResponsiveConfig.respectTextScaleFactor`).
- 🛡️ **Clamping**: `minScale` and `maxScale` bounds prevent UI elements from becoming too small or excessively large on extreme screen sizes.
- 🧭 **AppWidthLimiter centering**: Supports optional horizontal padding so centered content on very wide viewports does not touch the window edges.
- ✅ **Safe padding helper**: The list-based padding shorthand (`[a].p`, `[a,b].p`) validates input to avoid accidental layout bugs.
- 🔁 **Global Access**: `GlobalResponsive` is available for legacy code, while `ResponsiveProvider.of(context)` is recommended for widgets.

## Responsive Preview

![Responsive Design Screenshots](./screenshots/screen.jpg)

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_scalify: ^1.0.1
```

Then run:

```bash
flutter pub get
```

## Quick Start & Usage

### 1\. Wrap your app with ResponsiveProvider

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
        // Initialize the provider
        return ResponsiveProvider(
          config: const ResponsiveConfig(maxScale: 3.0),
          child: child ?? const SizedBox(),
        );
      },
      home: const ScalifyExampleHome(),
    );
  }
}
```

### 2\. Use the extensions

```dart
Text(
  "Hello World",
  style: TextStyle(fontSize: 16.fz), // Responsive font size
)

Container(
  padding: 16.p,                      // Responsive padding
  margin: [20, 10].p,                 // Responsive margin (vertical 10, horizontal 20)
  width: 200.w,                       // Responsive width
  height: 100.h,                      // Responsive height
  decoration: BoxDecoration(
    borderRadius: 12.br,              // Responsive border radius
  ),
  child: Icon(Icons.home, size: 24.iz), // Responsive icon size
)
```

## Available Extensions

### Text & Sizing

  - `16.fz` - Font size (text size) - respects accessibility if configured.
  - `24.iz` - Icon size.
  - `100.w` - Width-driven scale.
  - `50.h` - Height-driven scale.
  - `12.r` - Border radius (uses conservative scale).
  - `48.ui` - UI elements (buttons, inputs).
  - `1.5.sc` - General scaling factor.

### Spacing

  - `20.s` - Space (used for margins, padding, etc.).

### Padding Shortcuts

  - `16.p` - Padding all sides.
  - `16.ph` - Padding horizontal.
  - `16.pv` - Padding vertical.
  - `[16, 24].p` - Symmetric padding (horizontal 16, vertical 24).
  - `[10, 20, 30, 40].p` - LTRB padding.

> **Note**: The list padding helper validates the list length. Allowed lengths are 1, 2, or 4.

### Spacing Widgets

  - `20.sbh` - `SizedBox` height.
  - `30.sbw` - `SizedBox` width.

## Responsive Grid Example

```dart
Widget build(BuildContext context) {
  // Use the context extension to get the helper
  final helper = context.responsiveHelper; 
  
  final crossAxisCount = helper.valueByScreen(
    watch: 1,
    mobile: 1,
    tablet: 2,
    smallDesktop: 3,
    desktop: 4,
    largeDesktop: 5,
  );

  return GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 16.s,
      crossAxisSpacing: 16.s,
    ),
    itemBuilder: (context, index) => YourWidget(),
  );
}
```

## Screen Breakpoints

The package automatically detects screen sizes based on width:

  - **Watch**: \< 300px
  - **Mobile**: 300px - 600px
  - **Tablet**: 600px - 900px
  - **Small Desktop**: 900px - 1200px
  - **Desktop**: 1200px - 1800px
  - **Large Desktop**: \> 1800px

## AppWidthLimiter

Limit the maximum width of your app for better UX on large screens. This centers your content and adds a safe background area.

```dart
AppWidthLimiter(
  maxWidth: 1400,
  horizontalPadding: 16, // Optional outer padding
  child: YourContent(),
)
```

## Behavior & Configuration

`ResponsiveConfig` exposes options to tune breakpoints and scaling behavior:

  - `watchBreakpoint`, `mobileBreakpoint`, etc.
  - `respectTextScaleFactor`: When true, `.fz` multiplies by system text scale.
  - `minScale` and `maxScale`: Clamp sizes to prevent UI explosions.
  - `outerHorizontalPadding`: Default padding used by `AppWidthLimiter` when centering content.

## Screenshots

## Complete Example

Check out the [example](example/) directory for a complete, beautiful example app that demonstrates all features including a responsive grid that adapts to different screen sizes.

## Author

**Alaa Hassan Damad**

  - Email: alaahassanak772@gmail.com
  - Country: Iraq

## License

This project is licensed under the MIT License.