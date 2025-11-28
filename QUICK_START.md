# Quick Start Guide

## Setup

1. **Install the package** (when published):
```bash
flutter pub add flutter_scalify
```

Or add to `pubspec.yaml`:
```yaml
dependencies:
  flutter_scalify:
    path: ../  # For local development
```

2. **Run the example**:
```bash
cd example
flutter pub get
flutter run
```

## Basic Usage

1. Wrap your app with `ResponsiveProvider`:
```dart
MaterialApp(
  builder: (context, child) {
    return ResponsiveProvider(
      child: child ?? const SizedBox(),
    );
  },
  home: YourHomePage(),
)
```

2. Use the extensions:
```dart
Text(
  "Hello",
  style: TextStyle(fontSize: 16.fz),
)

Container(
  padding: 16.p,
  width: 200.w,
  height: 100.h,
  decoration: BoxDecoration(
    borderRadius: 12.br,
  ),
)
```

## Testing Responsive Design

- Run on different devices (phone, tablet, desktop)
- Resize the window in desktop/web mode
- Check how elements adapt automatically

## Next Steps

- Check the [README.md](README.md) for full documentation
- Explore the [example](example/) app for advanced usage
- See how the responsive grid adapts to different screen sizes

