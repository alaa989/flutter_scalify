# Changelog

All notable changes to this project will be documented in this file.

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
- ResponsiveProvider widget for easy setup
- ResponsiveHelper class with screen type detection
- AppWidthLimiter widget for limiting app width on large screens
- Support for Watch, Mobile, Tablet, Small Desktop, Desktop, and Large Desktop screen sizes
- Beautiful example app demonstrating all features