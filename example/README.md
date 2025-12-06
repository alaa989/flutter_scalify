# Flutter Scalify Example (Scalify Lab Ultimate) 🧪

This is a comprehensive "Lab" dashboard designed to demonstrate the full power of the **Scalify Engine v2.0.1**. It visualizes how the package handles scaling, performance, and responsiveness in real-time.

## What to Look For? 👁️

When running the app (preferably in Device Preview or Desktop/Web):

1.  **Resize the Window:** Watch the "Live Metrics" update instantly without lag (thanks to the new debounce logic).
2.  **Test 4K:** Expand width beyond `1920px` to see the **4K Guard** turn green (Active).
3.  **Check the Grid:** Notice how grid items grow and shrink intelligently using `ScalifyBox` instead of standard media queries.
4.  **Enjoy the ultimate scaling experience! 🚀**

## Features Demonstrated 🛠️

### 1. Core Scaling Logic
- Visual comparison between Width-based (`.w`), Height-based (`.h`), and Smart-balanced (`.s`) scaling.
- Live metrics dashboard showing real-time Width, Scale Factor, and Device Type.

### 2. The New Engine Capabilities (v2.0.1)
- **📦 ScalifyBox (Local Scaling):** Demonstrates the new Container Query widget that scales items based on their **parent** size (used in the Grid).
- **🛡️ 4K Memory Protection:** A dedicated section showing the status of the protection algorithm (**ACTIVE** vs **STANDBY**) on large screens.
- **⚡ Zero-Allocation Performance:** Uses optimized **Inline Math** extensions (`.p`, `.br`) for O(1) rendering performance without memory overhead.

### 3. Adaptive Layouts
- **Smart Grid System:** A dynamic grid that adapts columns from 1 to 5 based on precise breakpoints.
- **Proportional Scaling:** Uses `ScalifyFit.contain` to ensure grid items maintain perfect proportions without overflowing, regardless of the aspect ratio.
- **Typography:** Demonstrates safe-area typography scaling using `.fz`.

## Running the Example

```bash
cd example
flutter pub get
flutter run