import 'package:flutter/material.dart';
import 'scalify_provider.dart';

/// Limits maximum width AND resets scaling. Supports [minWidth] for scrolling.
/// Optimized version to reduce rebuild cost and resize jank.
class AppWidthLimiter extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final Color? backgroundColor;
  final double horizontalPadding;
  final double? minWidth;

  const AppWidthLimiter({
    super.key,
    required this.child,
    this.maxWidth = 1000.0,
    this.backgroundColor,
    this.horizontalPadding = 16.0,
    this.minWidth,
  });

  @override
  Widget build(BuildContext context) {
    // 🔥 قراءة MediaQuery مرة واحدة فقط (أسرع)
    final media = MediaQuery.sizeOf(context);

    // 🔥 لا تسجّل dependency كاملة — نحتاج config فقط
    // ⚠️ يفضل أن يكون لديك enum بدل string داخل provider
    final cfg = ScalifyProvider.of(context, aspect: ScalifyAspect.scale).config;
    final limit = minWidth ?? cfg.minWidth;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width =
            constraints.maxWidth.isFinite ? constraints.maxWidth : media.width;

        Widget content = child;

        /// ✅ Scroll فقط عند الحاجة
        if (limit > 0 && width < limit) {
          content = SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(width: limit, child: child),
          );
        }

        /// ✅ الحالة الطبيعية — لا تفعل أي شيء
        if (width <= maxWidth) {
          return content;
        }

        /// 🔥 نحسب MediaQuery الجديدة مرة واحدة
        final constrainedMedia =
            MediaQuery.of(context).copyWith(size: Size(maxWidth, media.height));

        return ColoredBox(
          color: backgroundColor ?? Colors.transparent,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: ConstrainedBox(
                constraints: const BoxConstraints(),

                /// 🔥 RepaintBoundary يقلل الحمل أثناء resize
                child: RepaintBoundary(
                  child: MediaQuery(
                    data: constrainedMedia,

                    /// 🔥 لا ننشئ Provider جديد إلا عند الضرورة
                    child: ScalifyProvider(
                      config: cfg,
                      child: content,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
