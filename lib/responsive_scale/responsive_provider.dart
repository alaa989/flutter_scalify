import 'dart:async';
import 'package:flutter/material.dart';
import 'responsive_config.dart';
import 'responsive_data.dart';
import 'global_responsive.dart';

class ResponsiveProvider extends StatefulWidget {
  final Widget child;
  final ResponsiveConfig config;

  const ResponsiveProvider({
    super.key,
    required this.child,
    this.config = const ResponsiveConfig(),
  });

  /// Safe access: when not found, returns fallback computed from MediaQuery.maybeOf
  static ResponsiveData of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<_InheritedResponsive>();
    if (inherited != null) return inherited.data;
    final mq = MediaQuery.maybeOf(context);
    return ResponsiveData.fromMediaQuery(mq, const ResponsiveConfig());
  }

  @override
  State<ResponsiveProvider> createState() => _ResponsiveProviderState();
}

class _ResponsiveProviderState extends State<ResponsiveProvider>
    with WidgetsBindingObserver {
  ResponsiveData _data = ResponsiveData.identity;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    // debounce rapid resizes
    _debounce?.cancel();
    _debounce =
        Timer(Duration(milliseconds: widget.config.debounceWindowMillis), () {
      _recalcIfNeeded();
    });
  }

  void _recalcIfNeeded() {
    if (!mounted) return;
    final mq = MediaQuery.maybeOf(context);
    final newData = ResponsiveData.fromMediaQuery(mq, widget.config);

    final sizeChanged = (_data.size.width != newData.size.width) ||
        (_data.size.height != newData.size.height);
    final scaleChanged = (_data.scaleFactor - newData.scaleFactor).abs() >
        widget.config.rebuildScaleThreshold;
    final widthPxChanged = (_data.size.width - newData.size.width).abs() >
        widget.config.rebuildWidthPxThreshold;
    final screenTypeChanged = _data.screenType != newData.screenType;

    if (sizeChanged && (scaleChanged || widthPxChanged || screenTypeChanged)) {
      setState(() {
        _data = newData;
        GlobalResponsive.update(newData);
      });
    } else {
      // still update global for minimal correctness (no rebuild)
      GlobalResponsive.update(newData);
      _data = newData;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.maybeOf(context);
    final current = ResponsiveData.fromMediaQuery(mq, widget.config);
    // update global and local
    _data = current;
    GlobalResponsive.update(current);

    return _InheritedResponsive(
      data: current,
      child: widget.child,
    );
  }
}

class _InheritedResponsive extends InheritedWidget {
  final ResponsiveData data;
  const _InheritedResponsive({required this.data, required super.child});

  @override
  bool updateShouldNotify(covariant _InheritedResponsive oldWidget) {
    // Notify only on meaningful changes
    return data.scaleFactor != oldWidget.data.scaleFactor ||
        data.size.width != oldWidget.data.size.width ||
        data.size.height != oldWidget.data.size.height ||
        data.screenType != oldWidget.data.screenType;
  }
}
