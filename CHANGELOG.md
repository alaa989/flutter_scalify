# Changelog

All notable changes to this project will be documented in this file.

## [2.2.3] - 2025-12-21 🚀 (The Architecture & Logic Update)

Maintenance: Clean up project structure (removed unused platform folders from root). Improvement: Enhanced project organization.
This major update focuses on standardizing the package architecture, improving Developer Experience (DX), and adding powerful logic controls to your UI.

### ⚠️ Breaking Changes & Rebranding
- **Renamed Provider:** `ResponsiveProvider` is now **`ScalifyProvider`**. This aligns with the package name and avoids conflicts with other libraries.
- **Renamed Config:** `ResponsiveConfig` is now **`ScalifyConfig`**.

### 🎨 Theme Integration
- **Added `ScalifyThemeExtension`:** You can now scale your *entire* app's text theme in one line using `ThemeData.light().scale(context)`.
  - **Smart Optimization:** It automatically checks if the scale factor is `1.0` to avoid unnecessary calculations.
  - **Result:** No need to add `.fz` manually to every text widget anymore if you use the global theme!

### 🧠 New Logic Widgets
- **Added `ResponsiveVisibility`:** A powerful widget to conditionally show or hide elements based on screen type.
  - Supports `visibleOn` (Whitelist) and `hiddenOn` (Blacklist).
  - Includes assertions to ensure you don't use both lists simultaneously.
- **Added `ResponsiveLayout`:** Effortlessly switch between `portrait` and `landscape` layouts using a clean API.
- **Added `ResponsiveBuilder`:** A direct way to access `ResponsiveData` inside the widget tree via a builder pattern, simplifying complex logic.

### 📚 Documentation
- **Complete Overhaul:** The README has been rewritten to feature a "Why Scalify?" comparison table, better examples, and clearer categorization of features.

---

## [2.2.2] - 2025-12-20 🚀 (The Architecture & Logic Update)

This major update focuses on standardizing the package architecture, improving Developer Experience (DX), and adding powerful logic controls to your UI.

### ⚠️ Breaking Changes & Rebranding
- **Renamed Provider:** `ResponsiveProvider` is now **`ScalifyProvider`**. This aligns with the package name and avoids conflicts with other libraries.
- **Renamed Config:** `ResponsiveConfig` is now **`ScalifyConfig`**.

### 🎨 Theme Integration
- **Added `ScalifyThemeExtension`:** You can now scale your *entire* app's text theme in one line using `ThemeData.light().scale(context)`.
  - **Smart Optimization:** It automatically checks if the scale factor is `1.0` to avoid unnecessary calculations.
  - **Result:** No need to add `.fz` manually to every text widget anymore if you use the global theme!

### 🧠 New Logic Widgets
- **Added `ResponsiveVisibility`:** A powerful widget to conditionally show or hide elements based on screen type.
  - Supports `visibleOn` (Whitelist) and `hiddenOn` (Blacklist).
  - Includes assertions to ensure you don't use both lists simultaneously.
- **Added `ResponsiveLayout`:** Effortlessly switch between `portrait` and `landscape` layouts using a clean API.
- **Added `ResponsiveBuilder`:** A direct way to access `ResponsiveData` inside the widget tree via a builder pattern, simplifying complex logic.

### 📚 Documentation
- **Complete Overhaul:** The README has been rewritten to feature a "Why Scalify?" comparison table, better examples, and clearer categorization of features.

---

## [2.2.1] - 2025-12-19 🚀 (The Architecture & Logic Update)

This major update focuses on standardizing the package architecture, improving Developer Experience (DX), and adding powerful logic controls to your UI.

### ⚠️ Breaking Changes & Rebranding
- **Renamed Provider:** `ResponsiveProvider` is now **`ScalifyProvider`**. This aligns with the package name and avoids conflicts with other libraries.
- **Renamed Config:** `ResponsiveConfig` is now **`ScalifyConfig`**.

### 🎨 Theme Integration
- **Added `ScalifyThemeExtension`:** You can now scale your *entire* app's text theme in one line using `ThemeData.light().scale(context)`.
  - **Smart Optimization:** It automatically checks if the scale factor is `1.0` to avoid unnecessary calculations.
  - **Result:** No need to add `.fz` manually to every text widget anymore if you use the global theme!

### 🧠 New Logic Widgets
- **Added `ResponsiveVisibility`:** A powerful widget to conditionally show or hide elements based on screen type.
  - Supports `visibleOn` (Whitelist) and `hiddenOn` (Blacklist).
  - Includes assertions to ensure you don't use both lists simultaneously.
- **Added `ResponsiveLayout`:** Effortlessly switch between `portrait` and `landscape` layouts using a clean API.
- **Added `ResponsiveBuilder`:** A direct way to access `ResponsiveData` inside the widget tree via a builder pattern, simplifying complex logic.

### 📚 Documentation
- **Complete Overhaul:** The README has been rewritten to feature a "Why Scalify?" comparison table, better examples, and clearer categorization of features.

---

## [2.2.0] - 2025-12-19 🚀 (The Architecture & Logic Update)

This major update focuses on standardizing the package architecture, improving Developer Experience (DX), and adding powerful logic controls to your UI.

### ⚠️ Breaking Changes & Rebranding
- **Renamed Provider:** `ResponsiveProvider` is now **`ScalifyProvider`**. This aligns with the package name and avoids conflicts with other libraries.
- **Renamed Config:** `ResponsiveConfig` is now **`ScalifyConfig`**.

### 🎨 Theme Integration
- **Added `ScalifyThemeExtension`:** You can now scale your *entire* app's text theme in one line using `ThemeData.light().scale(context)`.
  - **Smart Optimization:** It automatically checks if the scale factor is `1.0` to avoid unnecessary calculations.
  - **Result:** No need to add `.fz` manually to every text widget anymore if you use the global theme!

### 🧠 New Logic Widgets
- **Added `ResponsiveVisibility`:** A powerful widget to conditionally show or hide elements based on screen type.
  - Supports `visibleOn` (Whitelist) and `hiddenOn` (Blacklist).
  - Includes assertions to ensure you don't use both lists simultaneously.
- **Added `ResponsiveLayout`:** Effortlessly switch between `portrait` and `landscape` layouts using a clean API.
- **Added `ResponsiveBuilder`:** A direct way to access `ResponsiveData` inside the widget tree via a builder pattern, simplifying complex logic.

### 📚 Documentation
- **Complete Overhaul:** The README has been rewritten to feature a "Why Scalify?" comparison table, better examples, and clearer categorization of features.

---

## [2.1.0] - 2025-12-16 🚀 (The Layout & Adaptive System Update)

This update transforms Scalify from a "Scaling Engine" into a full "Responsive Layout System". It introduces powerful widgets to handle complex layouts on Web and Desktop without manual math.

### 📐 New Feature: The Responsive Layout System
- **Added `ResponsiveGrid`:** The ultimate grid solution.
  - **6-Tier Support:** Now supports specific column counts for Watch, Mobile, Tablet, **Small Desktop** (New), Desktop, and **Large Desktop** (New).
  - **Auto-Fit Mode:** Just provide a `minItemWidth` (e.g., 150px), and the grid will automatically calculate how many items fit in the row. Perfect for API data.
  - **Lazy Loading:** Built-in support for `SliverGrid` and infinite scrolling performance.
- **Added `ResponsiveFlex`:** A smart widget that automatically switches between `Row` (horizontal) and `Column` (vertical) layouts based on screen width. Perfect for profile headers and toolbars.
- **Added `AdaptiveContainer`:** Enables **Component-Driven Design**. This widget rebuilds its child based on its *own width* (Parent Constraints) rather than the screen size.

### 🖥️ Desktop & Breakpoint Enhancements
- **Granular Breakpoints:** Added `smallDesktop` (900px-1200px) and `largeDesktop` (>1800px) to `ResponsiveConfig` and `ResponsiveGrid`. You now have control over 6 distinct screen sizes.
- **`AppWidthLimiter` Logic Upgrade:**
  - **Scaling Reset:** When `AppWidthLimiter` constrains the app width (e.g., to 1400px), it now injects a *new* scaling context.
  - **Result:** Elements inside the limiter scale relative to the *limit* (1400px), not the huge screen width (e.g., 4000px). This prevents "Gigantic UI" on ultra-wide monitors.

### 🐛 Fixes & Improvements
- **ResponsiveFlex Overflow:** Fixed `RenderFlex` overflow issues by implementing `mainAxisSize: MainAxisSize.min` defaults.
- **Grid Stability:** Improved `childAspectRatio` logic in `ResponsiveGrid` to prevent layout breaks on resize.
- **Documentation:** Updated README with comprehensive examples for the new layout widgets.

---

## [2.0.2] - 2025-12-06
### 🐛 Hotfix
- **Restored API:** Fixed missing `context.valueByScreen()` method that was accidentally removed in 2.0.1.

## [2.0.1] - 2025-12-06 🚀 (The Hyper-Performance Update)

### ⚡ Performance Overhaul (Zero Allocation)
- **Zero Allocation Strategy:** Completely removed the internal caching layer to eliminate memory allocation overhead. The engine now uses direct O(1) math.
- **Inline Optimization:** Applied `vm:prefer-inline` to all core extensions (`.w`, `.h`, `.sp`, etc.) to force the compiler to execute getters directly in the hot path.
- **Smart Equality Checks (Quantization):** Implemented Integer-based IDs in `ResponsiveData`. This prevents "phantom rebuilds" caused by microscopic floating-point errors (e.g., `100.0` vs `100.0000001`).
- **Safety Asserts:** Added debug-mode assertions to ensure `GlobalResponsive` updates only happen during valid frame phases.

### 📦 New Features: Container Queries
- **Added `ScalifyBox`:** A game-changing widget that allows **Local Scaling**. Scale UI elements based on their parent container's size, not just the screen size. Perfect for Cards and Grids.
- **Added `ScalifyFit`:** Control how content scales inside a `ScalifyBox` (`width`, `height`, `contain`, `cover`) to handle dynamic aspect ratios automatically.

### 🛡️ 4K & Ultra-Wide Protection
- **Smart Dampening Algorithm:** Introduced a non-linear scaling logic for screens wider than `1920px` (configurable). This prevents UI elements from becoming comically large on TVs or Ultra-wide monitors.
- **New Config Options:** Added `memoryProtectionThreshold` and `highResScaleFactor` to `ResponsiveConfig`.

### 🛠️ Maintenance & Docs
- **100% Documentation:** Added comprehensive Dartdoc comments to all public APIs to meet pub.dev scoring requirements.
- **Code Formatting:** The entire codebase is now strictly formatted according to Dart standards.
- **Resize Debouncing:** The provider waits for window resize events to settle before recalculating layout, eliminating lag on Desktop/Web.

---

## [2.0.0] - 2025-12-04 🚀 (The Engine Update)

### 📦 New Features: Container Queries
- **Added `ScalifyBox`:** A game-changing widget that allows **Local Scaling**. Scale UI elements based on their parent container's size, not just the screen size. Perfect for Cards and Grids.
- **Added `ScalifyFit`:** Control how content scales inside a `ScalifyBox` (`width`, `height`, `contain`, `cover`) to handle dynamic aspect ratios automatically.

### 🛡️ 4K & Ultra-Wide Protection
- **Smart Dampening Algorithm:** Introduced a non-linear scaling logic for screens wider than `1920px` (configurable). This prevents UI elements from becoming comically large on TVs or Ultra-wide monitors while saving Texture Memory.
- **New Config Options:** Added `memoryProtectionThreshold` and `highResScaleFactor` to `ResponsiveConfig`.

### ⚡ Ultimate Performance (Zero-Cost)
- **LRU Caching System:** Implemented an internal cache for `EdgeInsets` (.p) and `BorderRadius` (.br). This reduces memory allocations by up to 90% during rebuilds.
- **Resize Debouncing:** The provider now waits for the window resize to settle before recalculating layout (Smart Throttling), eliminating lag on Desktop/Web resizing.
- **Optimized Getters:** Refactored extension getters to access data in O(1) time without unnecessary context lookups in hot paths.

### 🛠️ API & DX Improvements
- **Context Shortcuts:** Added `context.screenType` getter for faster checks.
- **Grid Stability:** Fixed layout overflows in dynamic grids using the new `ScalifyFit` logic.

---

## [1.0.1] - 2025-12-03

### 🛡️ Critical Fixes & Null Safety
- **Defensive Programming:** Implemented robust null checks using `MediaQuery.maybeOf` to prevent crashes when context is invalid.
- **Safe Fallbacks:** Added `ResponsiveData.identity` to provide safe default values (fallback) if the provider is not found or during early app initialization.
- **Web/Desktop Stability:** Handled edge cases where screen dimensions might report as 0 during the first frame or window resizing.
- **Global Safety:** `GlobalResponsive.data` no longer throws exceptions but returns safe defaults with a debug warning.

### ✨ Improvements & Features
- **Two-Axis Scaling:** Introduced `scaleWidth` (width-driven) and `scaleHeight` (height-driven) with a smart combined factor for better scaling on ultra-wide or short screens.
- **ResponsiveConfig Enhancements:**
  - `respectTextScaleFactor`: When enabled, `.fz` respects system accessibility text settings.
  - `minScale` & `maxScale`: Added clamping bounds to prevent UI elements from becoming too small or excessively large.
  - `outerHorizontalPadding`: Added breathing room for width-limited layouts.
- **Performance:** Added debounce mechanism for window-resize events on Desktop/Web to reduce rebuild churn.
- **Validation:** Added strict validation for list-based padding shortcuts (accepts lengths of 1, 2, or 4 only) with informative error messages.
- **AppWidthLimiter:** Now supports optional `horizontalPadding`.

### 📝 Notes
- **Backwards Compatibility:** All public extensions (`.w`, `.h`, `.fz`, `.s`, etc.) remain fully compatible.
- **Recommendation:** It is highly recommended to wrap your app with `ResponsiveProvider` to ensure complete null safety and reactive layout updates.

---

## [1.0.0] - 2025-11-24

### Added
- Initial release of flutter_scalify
- Responsive extensions for text size (.fz), spacing (.s), icons (.iz), width (.w), height (.h), radius (.r), and UI elements (.ui)
- Padding shortcuts (.p, .ph, .pv, etc.)
- SizedBox shortcuts (.sbh, .sbw)
- BorderRadius shortcuts (.br, .brt, .brb, .brl, .brr)
- ScalifyProvider widget for easy setup
- ResponsiveHelper class with screen type detection
- AppWidthLimiter widget for limiting app width on large screens
- Support for Watch, Mobile, Tablet, Small Desktop, Desktop, and Large Desktop screen sizes
- Beautiful example app demonstrating all features including a responsive grid that adapts to different screen sizes.