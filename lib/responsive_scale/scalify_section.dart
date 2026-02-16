import 'package:flutter/material.dart';
import 'scalify_config.dart';
import 'scalify_provider.dart';

/// Creates an **independent scaling context** based on the section's actual
/// layout size rather than the full screen size.
///
/// Wrap any part of your UI in [ScalifySection] to make all context-based
/// scaling methods (`context.w()`, `context.fz()`, `context.s()`, etc.)
/// calculate values relative to this section's width and height.
///
/// This is essential for **split-screen** / **master-detail** layouts where
/// a sidebar and main content have different widths and each should scale
/// independently.
///
/// ## How It Works
///
/// 1. Uses [LayoutBuilder] to capture the section's actual constraints.
/// 2. Overrides [MediaQuery] so `size.width` equals the section width.
/// 3. Creates a new [ScalifyProvider] that calculates scaling based on
///    the overridden size.
/// 4. Uses [RepaintBoundary] to isolate repaints for performance.
///
/// ## Important: Use Context-Based Extensions
///
/// Inside a [ScalifySection], always use **context-based** scaling
/// (e.g. `context.fz(16)`, `context.w(100)`) rather than **global**
/// extensions (e.g. `16.fz`, `100.w`), because global extensions read
/// from [GlobalResponsive] which reflects the **last** updated provider.
///
/// ## Example — Split Layout
///
/// ```dart
/// Row(
///   children: [
///     // Sidebar: scales based on 300px width
///     SizedBox(
///       width: 300,
///       child: ScalifySection(child: Sidebar()),
///     ),
///     // Main content: scales based on remaining width
///     Expanded(
///       child: ScalifySection(child: MainContent()),
///     ),
///   ],
/// )
/// ```
class ScalifySection extends StatelessWidget {
  /// The child widget that will receive the local scaling context.
  final Widget child;

  /// Optional config override. If null, inherits from the nearest parent
  /// [ScalifyProvider], falling back to [ScalifyConfig] defaults.
  final ScalifyConfig? config;

  /// Creates a [ScalifySection].
  const ScalifySection({
    super.key,
    required this.child,
    this.config,
  });

  @override
  Widget build(BuildContext context) {
    final parentData = ScalifyProvider.of(context);
    final effectiveConfig = config ?? parentData.config;

    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;

        // Safety: handle unconstrained layouts (e.g. inside ListView)
        if (!width.isFinite) {
          width = MediaQuery.sizeOf(context).width;
        }
        if (!height.isFinite) {
          height = MediaQuery.sizeOf(context).height;
        }

        return RepaintBoundary(
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(
              size: Size(width, height),
            ),
            child: ScalifyProvider(
              config: effectiveConfig,
              observeMetrics: false,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
