# Changelog

All notable changes to this project will be documented in this file.

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