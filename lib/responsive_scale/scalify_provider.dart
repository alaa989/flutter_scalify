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
  ResponsiveData _currentData = ResponsiveData.identity;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _currentData = ResponsiveData.fromMediaQuery(null, widget.config);

    WidgetsBinding.instance.addPostFrameCallback((_) => _performUpdate());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Responds to MediaQuery changes from parent widgets (e.g. DevicePreview).
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _performUpdate();
  }

  @override
  void didChangeMetrics() => _performUpdate();

  @override
  void didChangeTextScaleFactor() => _performUpdate();

  /// Resolves [MediaQueryData] from context, with fallback to [View] or [PlatformDispatcher].
  MediaQueryData? _resolveMediaQuery() {
    final mq = MediaQuery.maybeOf(context);
    if (mq != null) return mq;

    try {
      final ui.FlutterView? view = View.maybeOf(context);
      if (view != null) return MediaQueryData.fromView(view);
      return MediaQueryData.fromView(
          ui.PlatformDispatcher.instance.views.first);
    } catch (e) {
      debugPrint(
        'Scalify: Could not resolve MediaQuery or View from context. '
        'Ensure ScalifyProvider is placed inside a WidgetsApp or MaterialApp, '
        'or that a valid View is available. Error: $e',
      );
      return null;
    }
  }

  /// Synchronous update — called by all lifecycle methods to ensure
  /// the scale factor is updated in the SAME frame as the constraints.
  void _performUpdate() {
    if (!mounted) return;

    final mq = _resolveMediaQuery();
    final newData = ResponsiveData.fromMediaQuery(mq, widget.config);

    if (newData != _currentData) {
      // Update GlobalResponsive BEFORE setState so that
      // all num extensions (.fz, .iz, .s, .w, .h, etc.)
      // read the correct data during the rebuild.
      GlobalResponsive.update(newData);
      setState(() => _currentData = newData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final showBanner = kDebugMode &&
        widget.config.showDeprecationBanner &&
        widget.config.legacyContainerTierMapping;

    // Wrap widget.child with the banner Stack so the banner renders
    // INSIDE the MaterialApp (the child becomes the `home:` parameter).
    Widget? innerChild = widget.child;
    if (showBanner && innerChild != null) {
      innerChild = Stack(
        children: [
          innerChild,
          _DeprecationBanner(onTap: () => _showMigrationDialog(context)),
        ],
      );
    }

    Widget child;
    if (widget.builder != null) {
      child = widget.builder!(context, innerChild);
    } else {
      child = innerChild!;
    }

    return _InheritedScalify(
      data: _currentData,
      child: child,
    );
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
