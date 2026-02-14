import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'responsive_data.dart';
import 'scalify_config.dart';
import 'global_responsive.dart';

/// Internal rebuild aspects used by [InheritedModel].
/// Improves performance by limiting widget rebuilds.
enum ScalifyAspect {
  /// Listen when screen type changes (mobile / tablet / desktop).
  type,

  /// Listen when scaleFactor changes.
  scale,

  /// Listen when textScaleFactor changes.
  text,
}

/// Provider widget that calculates and shares [ResponsiveData].
class ScalifyProvider extends StatefulWidget {
  final Widget child;
  final ScalifyConfig config;

  const ScalifyProvider({
    super.key,
    required this.child,
    this.config = const ScalifyConfig(),
  });

  /// Accesses the nearest [ResponsiveData] and registers a dependency.
  /// Uses [aspect] to listen only to specific changes if granular notifications are enabled.
  static ResponsiveData of(BuildContext context, {ScalifyAspect? aspect}) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_InheritedScalify>();

    // fallback عندما لا يوجد Provider (مثالي للاختبارات)
    if (inherited == null) {
      final provWidget =
          context.findAncestorWidgetOfExactType<ScalifyProvider>();
      final cfg = provWidget?.config ?? const ScalifyConfig();
      return ResponsiveData.fromMediaQuery(MediaQuery.maybeOf(context), cfg);
    }

    // إذا granular notifications غير مفعلة — لا تستخدم InheritedModel
    if (!inherited.data.config.enableGranularNotifications) {
      return inherited.data;
    }

    return InheritedModel.inheritFrom<_InheritedScalify>(
      context,
      aspect: aspect,
    )!
        .data;
  }

  @override
  State<ScalifyProvider> createState() => _ScalifyProviderState();
}

class _ScalifyProviderState extends State<ScalifyProvider>
    with WidgetsBindingObserver {
  Timer? _debounce;
  ResponsiveData _currentData = ResponsiveData.identity;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // إنشاء بيانات أولية بدون MediaQuery (آمن أثناء init)
    _currentData = ResponsiveData.fromMediaQuery(null, widget.config);

    WidgetsBinding.instance.addPostFrameCallback((_) => _update(force: true));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void didChangeMetrics() => _update();

  @override
  void didChangeTextScaleFactor() => _update();

  void _update({bool force = false}) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(
      Duration(milliseconds: force ? 0 : widget.config.debounceWindowMillis),
      () {
        if (!mounted) return;

        final mq = MediaQuery.maybeOf(context);
        final newData = ResponsiveData.fromMediaQuery(mq, widget.config);

        // 🔥 منع rebuild إذا الفرق غير ملحوظ
        if (newData != _currentData) {
          setState(() => _currentData = newData);
          GlobalResponsive.update(newData);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // fallback إضافي في حال identity
    if (_currentData == ResponsiveData.identity) {
      final mq = MediaQuery.maybeOf(context);
      if (mq != null) {
        _currentData = ResponsiveData.fromMediaQuery(mq, widget.config);
        GlobalResponsive.update(_currentData);
      }
    }

    Widget content = _InheritedScalify(
      data: _currentData,
      child: widget.child,
    );

    // Debug-only banner (لن يظهر في release)
    if (kDebugMode &&
        widget.config.showDeprecationBanner &&
        widget.config.legacyContainerTierMapping) {
      return Stack(
        children: [
          content,
          _DeprecationBanner(onTap: () => _showMigrationDialog(context)),
        ],
      );
    }

    return content;
  }

  void _showMigrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Scalify: Migration Alert'),
        content: const Text(
          'You are using legacyContainerTierMapping. Please update your breakpoints for full precision.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }
}

class _InheritedScalify extends InheritedModel<ScalifyAspect> {
  final ResponsiveData data;

  const _InheritedScalify({
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant _InheritedScalify oldWidget) =>
      data != oldWidget.data;

  @override
  bool updateShouldNotifyDependent(
    covariant _InheritedScalify oldWidget,
    Set<ScalifyAspect> aspects,
  ) {
    if (aspects.contains(ScalifyAspect.type)) {
      return data.screenType != oldWidget.data.screenType;
    }

    if (aspects.contains(ScalifyAspect.scale)) {
      return data.scaleFactor != oldWidget.data.scaleFactor;
    }

    if (aspects.contains(ScalifyAspect.text)) {
      return data.textScaleFactor != oldWidget.data.textScaleFactor;
    }

    return data != oldWidget.data;
  }
}

class _DeprecationBanner extends StatelessWidget {
  final VoidCallback onTap;

  const _DeprecationBanner({required this.onTap});

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FloatingActionButton.extended(
              onPressed: onTap,
              backgroundColor: Colors.orange.shade800,
              icon: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
              ),
              label: const Text(
                "Legacy Mode Active",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      );
}
