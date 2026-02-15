# Flutter Scalify Example (Ultimate Showcase) 🧪

This project demonstrates the full power of the **Scalify Layout System v3.0.0**. It is a comprehensive showcase of how to build complex, responsive, and adaptive UIs that work perfectly on everything from a small Watch to a 4K Desktop.

## What to Look For? 👁️

When running the app (resize the window to see the magic):

1.  **Builder Pattern:** The app uses `ScalifyProvider` with the `builder` pattern, placing it **above** `MaterialApp` for optimal rebuild performance.
2.  **The Profile Header:** Watch it switch from a vertical `Column` (Mobile) to a horizontal `Row` (Desktop) automatically using `ResponsiveFlex`.
3.  **Adaptive Cards:** Notice how the product cards change their internal layout (Icon on top vs Icon on left) based on how squeezed they are.
4.  **Theme Auto-Scaling:** All text scales perfectly without manually adding `.fz` to every widget, using the `ScalifyAspect.scale` with manual `fontSizeFactor`.
5.  **Smart Visibility:** Watch certain elements vanish or appear based on the device type using `ResponsiveVisibility`.
6.  **Geometric Scaling:** Check the **ScalifyBox Grid** section. The items scale up and down geometrically without changing their layout structure.
7.  **Auto-Fit Grid:** The last section simulates an API list that lazily loads and wraps items automatically based on available width.

## Features Demonstrated 🛠️

### 1. Builder Pattern & Granular Notifications (v3.0.0)
- **Builder Pattern**: `ScalifyProvider` wraps `MaterialApp` using `builder:` — prevents cascading rebuilds on window resize.
- **`ScalifyAspect.scale`**: Only subscribes to scale changes (not type or text), reducing unnecessary rebuilds.
- **`enableGranularNotifications: true`**: Enables `InheritedModel`-based selective notifications.

### 2. Responsive Layouts
- **`ResponsiveFlex`**: Used in the Profile Header. It intelligently switches axis based on screen width breakpoints.
- **`ResponsiveGrid`**: Used throughout the app. It supports 6 tiers of breakpoints (Watch → Large Desktop).

### 3. Component-Driven Design
- **`AdaptiveContainer`**: Used in the "Adaptive Cards" section. Unlike media queries which look at the *screen*, this widget looks at the *parent container width*.

### 4. Local & Proportional Scaling
- **`ScalifyBox`**: Used in the "ScalifyBox Grid". It creates a sandbox where everything inside scales proportionally relative to a reference size (100×120).

### 5. Enterprise-Grade Features
- **🛡️ 4K Protection**: The app is wrapped in `AppWidthLimiter` (maxWidth: 1200, minWidth: 230).
- **🔄 Auto Swap Dimensions**: `autoSwapDimensions: true` for landscape support.
- **⚡ Zero-Allocation Math**: All scaling uses O(1) inline engine with `vm:prefer-inline`.

## 🧩 API Cheat Sheet

| Extension | Meaning | Example |
| :--- | :--- | :--- |
| `.fz` | Font Size | Scaled + clamped + accessibility |
| `.iz` | Icon Size | Proportional scaling |
| `.s` | Size/Space | General scaling factor |
| `.w` | Width | Width-based scaling |
| `.h` | Height | Height-based scaling |
| `.pw` | % Width | `50.pw` = 50% of screen width |
| `.hp` | % Height | `25.hp` = 25% of screen height |
| `.p` | Padding | `16.p`, `[10, 20].p`, `[10, 5, 10, 5].p` |
| `.br` | Border Radius | `12.br` (Circular) |
| `.sbh` | SizedBox Height | `20.sbh` |
| `.sbw` | SizedBox Width | `10.sbw` |

## Running the Example

```bash
cd example
flutter pub get
flutter run
```