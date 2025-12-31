# Flutter Scalify Example (Ultimate Showcase) 🧪

This project demonstrates the full power of the **Scalify Layout System v2.2.4**. It is a comprehensive showcase of how to build complex, responsive, and adaptive UIs that work perfectly on everything from a small Watch to a 4K Desktop.

## What to Look For? 👁️

When running the app (resize the window to see the magic):

1.  **The Profile Header:** Watch it switch from a vertical `Column` (Mobile) to a horizontal `Row` (Desktop) automatically using `ResponsiveFlex`.
2.  **Adaptive Cards:** Notice how the product cards change their internal layout (Icon on top vs Icon on left) based on how squeezed they are.
3.  **Global Theme Scaling:** Notice that all text scales perfectly without manually adding `.fz` to every widget, thanks to the new `ScalifyThemeExtension`.
4.  **Smart Visibility:** Watch certain elements vanish or appear based on the device type using `ResponsiveVisibility`.
5.  **Geometric Scaling:** Check the **ScalifyBox Grid** section. The items scale up and down geometrically without changing their layout structure.
6.  **Auto-Fit Grid:** The last section simulates an API list that lazily loads and wraps items automatically based on available width.

## Features Demonstrated 🛠️

### 1. Logic & Theming (New in v2.2.0)
- **`ScalifyThemeExtension`**: Used in `main.dart`. It scales the entire app's Typography automatically in one line of code.
- **`ResponsiveVisibility`**: Used to hide the "Side Menu" on Mobile and show it only on Desktop/Tablet.
- **`ResponsiveLayout`**: Demonstrates switching entire page layouts between Portrait and Landscape orientations.

### 2. Responsive Layouts
- **`ResponsiveFlex`**: Used in the Profile Header. It intelligently switches axis based on screen width breakpoints.
- **`ResponsiveGrid`**: Used throughout the app. It supports 6 tiers of breakpoints (Watch -> Large Desktop) and creates the structure for all sections.

### 3. Component-Driven Design
- **`AdaptiveContainer`**: Used in the "Adaptive Cards" section. Unlike media queries which look at the *screen*, this widget looks at the *parent container width*. This allows the card to adapt perfectly whether it's in a 2-column grid or a 4-column grid.

### 4. Local & Proportional Scaling
- **`ScalifyBox`**: Used in the "ScalifyBox Grid". It creates a sandbox where everything inside scales proportionally relative to a reference size (100x120), ensuring complex UI never overflows.

### 5. Enterprise-Grade Features
- **🛡️ ultra-wide screens**: The app is wrapped in `AppWidthLimiter`, ensuring it doesn't stretch indefinitely on ultra-wide screens.
- **🌍 RTL Support**: The logic automatically mirrors for Arabic/RTL layouts (ResponsiveFlex reverses direction).
- **⚡ Zero-Allocation Math**: All scaling uses the new O(1) inline engine for maximum performance.

## 🧩 Code Reference (Cheat Sheet)

The example code uses these Scalify shortcuts heavily:

| Extension | Meaning | Example Logic |
| :--- | :--- | :--- |
| **`.fz`** | Font Size | Scales text smartly (respects accessibility). |
| **`.iz`** | Icon Size | Scales icons proportionally. |
| **`.s`** | Space / Size | General scaling factor (used for width/height/spacing). |
| **`.p`** | Padding | `16.p` (All), `[10, 20].p` (Symmetric), `[10, 5, 10, 5].p` (LTRB). |
| **`.br`** | Border Radius | `12.br` (Circular). |
| **`.sbh`** | SizedBox Height | `20.sbh` -> `SizedBox(height: 20 * scale)`. |
| **`.sbw`** | SizedBox Width | `10.sbw` -> `SizedBox(width: 10 * scale)`. |

## Running the Example

```bash
cd example
flutter pub get
flutter run