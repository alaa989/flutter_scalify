import 'dart:async';
import 'dart:ui' as ui;
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
  final Widget? child;
  final TransitionBuilder? builder;
  final ScalifyConfig config;

  const ScalifyProvider({
    super.key,
    this.child,
    this.builder,
    this.config = const ScalifyConfig(),
  }) : assert(child != null || builder != null,
            'Either child or builder must be provided');

  /// Accesses the nearest [ResponsiveData] and registers a dependency.
  /// Uses [aspect] to listen only to specific changes if granular notifications are enabled.
  static ResponsiveData of(BuildContext context, {ScalifyAspect? aspect}) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_InheritedScalify>();

    // Fallback: no provider above in the tree
    if (inherited == null) {
      final provWidget =
          context.findAncestorWidgetOfExactType<ScalifyProvider>();
      final cfg = provWidget?.config ?? const ScalifyConfig();
      return ResponsiveData.fromMediaQuery(MediaQuery.maybeOf(context), cfg);
    }

    // If granular notifications disabled, just return data directly.
    if (!inherited.data.config.enableGranularNotifications) {
      return inherited.data;
    }

    // If caller provided an aspect, subscribe to it; otherwise return data.
    if (aspect == null) {
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

        MediaQueryData? mq = MediaQuery.maybeOf(context);
        // Fallback: If no MediaQuery is found (e.g. above MaterialApp), try to get from View
        if (mq == null) {
          try {
            final ui.FlutterView? view = View.maybeOf(context);
            if (view != null) {
              mq = MediaQueryData.fromView(view);
            } else {
              mq = MediaQueryData.fromView(
                  ui.PlatformDispatcher.instance.views.first);
            }
          } catch (_) {}
        }

        final newData = ResponsiveData.fromMediaQuery(mq, widget.config);

        if (newData != _currentData) {
          setState(() => _currentData = newData);
          GlobalResponsive.update(newData);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Always check for MediaQuery changes on build to handle excessive rebuilds
    // that might bypass didChangeMetrics in some scenarios (like tests)
    MediaQueryData? mq = MediaQuery.maybeOf(context);
    if (mq == null) {
      try {
        final ui.FlutterView? view = View.maybeOf(context);
        if (view != null) {
          mq = MediaQueryData.fromView(view);
        } else {
          mq = MediaQueryData.fromView(
              ui.PlatformDispatcher.instance.views.first);
        }
      } catch (_) {}
    }

    if (mq != null) {
      final newData = ResponsiveData.fromMediaQuery(mq, widget.config);
      if (newData != _currentData) {
        _currentData = newData;
        GlobalResponsive.update(newData);
      }
    }

    Widget content = _InheritedScalify(
      data: _currentData,
      child: widget.builder != null
          ? widget.builder!(context, widget.child)
          : widget.child!,
    );

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
      return data.scaleFactorId != oldWidget.data.scaleFactorId;
    }

    if (aspects.contains(ScalifyAspect.text)) {
      return data.textScaleFactorId != oldWidget.data.textScaleFactorId;
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
