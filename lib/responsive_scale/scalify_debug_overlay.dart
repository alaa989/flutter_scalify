import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'responsive_data.dart';
import 'scalify_provider.dart';

/// A debug overlay that displays live responsive metrics on screen.
///
/// **Only renders in debug mode** — completely eliminated from release builds
/// via [kDebugMode] check. Zero overhead in production.
///
/// ## Features
/// - Live display of screen size, scale factors, screen type
/// - Rebuild counter to track unnecessary rebuilds
/// - Draggable panel — move it anywhere on screen
/// - Collapsible via tap on the header
/// - Isolated repaints via [RepaintBoundary]
///
/// ## Usage
///
/// Wrap your app (or any subtree) with [ScalifyDebugOverlay]:
///
/// ```dart
/// ScalifyDebugOverlay(
///   enabled: true,
///   child: MyApp(),
/// )
/// ```
///
/// Or use it inside [ScalifyProvider]:
///
/// ```dart
/// ScalifyProvider(
///   builder: (context, child) => MaterialApp(
///     home: ScalifyDebugOverlay(child: child!),
///   ),
///   child: HomeScreen(),
/// )
/// ```
class ScalifyDebugOverlay extends StatelessWidget {
  /// The child widget (your app content).
  final Widget child;

  /// Whether the overlay is enabled. Defaults to `true`.
  /// Even when `true`, overlay only shows in [kDebugMode].
  final bool enabled;

  /// Initial position of the overlay from the top. Default: `50.0`.
  final double initialTop;

  /// Initial position of the overlay from the right. Default: `16.0`.
  final double initialRight;

  /// Creates a [ScalifyDebugOverlay].
  const ScalifyDebugOverlay({
    super.key,
    required this.child,
    this.enabled = true,
    this.initialTop = 50.0,
    this.initialRight = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    // Complete elimination in release mode.
    if (!kDebugMode || !enabled) return child;

    return Stack(
      children: [
        child,
        _DebugPanel(
          initialTop: initialTop,
          initialRight: initialRight,
        ),
      ],
    );
  }
}

/// The actual debug panel — only instantiated in debug mode.
class _DebugPanel extends StatefulWidget {
  final double initialTop;
  final double initialRight;

  const _DebugPanel({
    required this.initialTop,
    required this.initialRight,
  });

  @override
  State<_DebugPanel> createState() => _DebugPanelState();
}

class _DebugPanelState extends State<_DebugPanel> {
  late double _top;
  late double _right;
  bool _isExpanded = true;
  int _rebuildCount = 0;

  @override
  void initState() {
    super.initState();
    _top = widget.initialTop;
    _right = widget.initialRight;
  }

  @override
  Widget build(BuildContext context) {
    final data = ScalifyProvider.of(context);
    _rebuildCount++;

    return Positioned(
      top: _top,
      right: _right,
      child: RepaintBoundary(
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _top += details.delta.dy;
              _right -= details.delta.dx;
              // Clamp to screen bounds
              _top = _top.clamp(0.0, data.height - 40);
              _right = _right.clamp(0.0, data.width - 40);
            });
          },
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(12),
            color: Colors.transparent,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: const Color(0xDD1A1A2E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _screenTypeColor(data.screenType),
                  width: 1.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x40000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header — always visible, tap to toggle
                  GestureDetector(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: _screenTypeColor(data.screenType).withAlpha(40),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft: Radius.circular(_isExpanded ? 0 : 12),
                          bottomRight: Radius.circular(_isExpanded ? 0 : 12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _screenTypeIcon(data.screenType),
                            color: _screenTypeColor(data.screenType),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _screenTypeName(data.screenType),
                            style: TextStyle(
                              color: _screenTypeColor(data.screenType),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            _isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white70,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Body — collapsible
                  if (_isExpanded)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                      child: DefaultTextStyle(
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 10,
                          fontFamily: 'monospace',
                          height: 1.6,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _InfoRow(
                              '📐 Size',
                              '${data.width.toInt()} × ${data.height.toInt()}',
                            ),
                            _InfoRow(
                              '⚖️ Scale',
                              data.scaleFactor.toStringAsFixed(3),
                            ),
                            _InfoRow(
                              '↔️ ScaleW',
                              data.scaleWidth.toStringAsFixed(3),
                            ),
                            _InfoRow(
                              '↕️ ScaleH',
                              data.scaleHeight.toStringAsFixed(3),
                            ),
                            _InfoRow(
                              '🔤 TextSF',
                              data.textScaleFactor.toStringAsFixed(2),
                            ),
                            _InfoRow(
                              '🔄 Rebuilds',
                              '$_rebuildCount',
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────

  static Color _screenTypeColor(ScreenType type) {
    switch (type) {
      case ScreenType.watch:
        return const Color(0xFFFF6B6B);
      case ScreenType.mobile:
        return const Color(0xFF4ECDC4);
      case ScreenType.tablet:
        return const Color(0xFF45B7D1);
      case ScreenType.smallDesktop:
        return const Color(0xFFFFA07A);
      case ScreenType.desktop:
        return const Color(0xFF98D8C8);
      case ScreenType.largeDesktop:
        return const Color(0xFFC39BD3);
    }
  }

  static IconData _screenTypeIcon(ScreenType type) {
    switch (type) {
      case ScreenType.watch:
        return Icons.watch;
      case ScreenType.mobile:
        return Icons.phone_android;
      case ScreenType.tablet:
        return Icons.tablet_mac;
      case ScreenType.smallDesktop:
        return Icons.laptop_mac;
      case ScreenType.desktop:
        return Icons.desktop_mac;
      case ScreenType.largeDesktop:
        return Icons.tv;
    }
  }

  static String _screenTypeName(ScreenType type) {
    switch (type) {
      case ScreenType.watch:
        return 'WATCH';
      case ScreenType.mobile:
        return 'MOBILE';
      case ScreenType.tablet:
        return 'TABLET';
      case ScreenType.smallDesktop:
        return 'SM-DESKTOP';
      case ScreenType.desktop:
        return 'DESKTOP';
      case ScreenType.largeDesktop:
        return 'LG-DESKTOP';
    }
  }
}

/// A single info row in the debug panel.
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 80,
          child: Text(label),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
