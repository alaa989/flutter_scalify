# Quick Start Guide ⚡️

## Setup

1. **Install the package**:
```bash
flutter pub add flutter_scalify

```

2. **Import it**:

```dart
import 'package:flutter_scalify/flutter_scalify.dart';

```

## Basic Usage

1. **Initialize Scalify**:
Wrap your app with `ScalifyProvider` and use the `.scale(context)` extension on your theme for automatic text scaling.

```dart
MaterialApp(
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
  // ✨ MAGIC LINE: Automatically scales all app text!
  theme: ThemeData.light().scale(context), 
  home: YourHomePage(),
)

```

2. **Use Extensions**:
Now build your UI using the smart extensions.

```dart
// Text automatically scales because of the theme, 
// but you can override it specifically if needed:
Text(
  "Hello World",
  style: TextStyle(fontSize: 24.fz, fontWeight: FontWeight.bold),
)

Container(
  padding: 16.p,        // Padding
  width: 200.w,         // Scaled Width
  height: 100.h,        // Scaled Height
  decoration: BoxDecoration(
    borderRadius: 12.br, // Scaled Radius
  ),
)

```

## Testing Responsive Design 📱💻

1. Run the app on a **Mobile Simulator** (e.g., iPhone 14).
2. Run the app on **Chrome/MacOS/Windows**.
3. Resize the window and watch how `AppWidthLimiter` and `Smart Dampening` protect your UI from exploding!

## Next Steps

* Check the [README.md](README.md) for full documentation.
* Explore the `example/` folder for advanced grids and layouts.
* Try the new `ResponsiveBuilder` for custom logic.