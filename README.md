# Flutter Scalify 🚀

A powerful and elegant Flutter package for responsive design. Easily scale your UI elements (text, spacing, icons, containers) across all screen sizes with simple extensions.
A powerful and incredible responsive UI package for Flutter. `flutter_scalify` allows you to auto-scale texts, widgets, spacing, and radius seamlessly across all screen sizes.

Developed with  by **Alaa Hassan Damad**.


## Features ✨

- 🎯 **Simple API**: Use intuitive extensions like `16.fz`, `20.s`, `24.iz`
- 📱 **Fully Responsive**: Automatically adapts to Mobile, Tablet, Desktop, and Large Desktop
- 🎨 **Comprehensive**: Scale fonts, spacing, icons, widths, heights, border radius, and more
- ⚡ **Performance**: Lightweight and optimized for performance
- 🔧 **Flexible**: Works with any Flutter widget

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_scalify: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Wrap your app with `ResponsiveProvider`

```dart
import 'package:flutter_scalify/flutter_scalify.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ResponsiveProvider(
        child: HomePage(),
      ),
    );
  }
}
```

### 2. Use the extensions

```dart
Text(
  "Hello World",
  style: TextStyle(fontSize: 16.fz), // Responsive font size
)

Container(
  padding: 16.p,                      // Responsive padding
  margin: [20, 10].p,                 // Responsive margin
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
- `16.fz` - Font size (text size)
- `24.iz` - Icon size
- `100.w` - Width
- `50.h` - Height
- `12.r` - Border radius
- `48.ui` - UI elements
- `1.5.sc` - General scaling

### Spacing
- `20.s` - Space (used for margins, padding, etc.)

### Padding Shortcuts
- `16.p` - Padding all sides
- `16.ph` - Padding horizontal
- `16.pv` - Padding vertical
- `16.pt` - Padding top
- `16.pb` - Padding bottom
- `16.pl` - Padding left
- `16.pr` - Padding right
- `[16, 24].p` - Symmetric padding (horizontal, vertical)
- `[10, 20, 30, 40].p` - LTRB padding

### Spacing Widgets
- `20.sbh` - SizedBox height
- `30.sbw` - SizedBox width

### Border Radius
- `12.br` - Circular radius
- `12.brt` - Top radius
- `12.brb` - Bottom radius
- `12.brl` - Left radius
- `12.brr` - Right radius

## Responsive Grid Example

```dart
Widget build(BuildContext context) {
  final helper = ResponsiveManager.instance.helper;
  
  final crossAxisCount = helper?.valueByScreen(
    watch: 1,
    mobile: 1,
    tablet: 2,
    smallDesktop: 3,
    desktop: 4,
    largeDesktop: 5,
  ) ?? 2;

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

The package automatically detects screen sizes:

- **Watch**: < 300px
- **Mobile**: 300px - 600px
- **Tablet**: 600px - 900px
- **Small Desktop**: 900px - 1200px
- **Desktop**: 1200px - 1800px
- **Large Desktop**: > 1800px

## AppWidthLimiter

Limit the maximum width of your app for better UX on large screens:

```dart
AppWidthLimiter(
  maxWidth: 1400,
  child: YourContent(),
)
```

## Complete Example

Check out the [example](example/) directory for a complete, beautiful example app that demonstrates all features including a responsive grid that adapts to different screen sizes.

## Author

**Alaa Hassan Damad**

- Email: alaahassanak772@gmail.com
- Country: Iraq

## License

This project is licensed under the MIT License.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
