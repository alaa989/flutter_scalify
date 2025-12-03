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

  /// ✅ Safe Access: يعيد Fallback إذا لم يجد الـ Provider
  static ResponsiveData of(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<_InheritedResponsive>();
    
    if (inherited == null) {
       // fallback آمن بدلاً من crash
       final mq = MediaQuery.maybeOf(context);
       return ResponsiveData.fromMediaQuery(mq, const ResponsiveConfig());
    }
    
    return inherited.data;
  }

  @override
  State<ResponsiveProvider> createState() => _ResponsiveProviderState();
}

class _ResponsiveProviderState extends State<ResponsiveProvider> with WidgetsBindingObserver {
  ResponsiveData? _data;
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
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 120), () {
      if (mounted) _recalcIfNeeded();
    });
  }

  void _recalcIfNeeded() {
    if (!mounted) return;

    // ✅ Safe: استخدام maybeOf
    final mq = MediaQuery.maybeOf(context);
    final newData = ResponsiveData.fromMediaQuery(mq, widget.config);

    // إذا كانت البيانات القديمة null، قم بالتحديث فوراً
    if (_data == null) {
       setState(() {
        _data = newData;
        GlobalResponsive.update(newData);
      });
      return;
    }

    final old = _data!;
    final sizeChanged = old.size.width != newData.size.width ||
        old.size.height != newData.size.height;
    final scaleChanged = (old.scaleFactor - newData.scaleFactor).abs() > 0.01;

    if (sizeChanged || scaleChanged) {
      setState(() {
        _data = newData;
        GlobalResponsive.update(newData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Safe: استخدام maybeOf وحساب البيانات حتى لو كان الـ mq null
    final mq = MediaQuery.maybeOf(context);
    
    // حساب البيانات الحالية
    final currentData = ResponsiveData.fromMediaQuery(mq, widget.config);
    
    // تحديث المتغير المحلي والـ Global
    _data = currentData;
    GlobalResponsive.update(currentData);

    return _InheritedResponsive(
      data: currentData,
      child: widget.child,
    );
  }
}

class _InheritedResponsive extends InheritedWidget {
  final ResponsiveData data;
  const _InheritedResponsive({
    required this.data,
    required super.child,
  });

  @override
  bool updateShouldNotify(covariant _InheritedResponsive oldWidget) {
    return data.scaleFactor != oldWidget.data.scaleFactor ||
        data.size != oldWidget.data.size ||
        data.textScaleFactor != oldWidget.data.textScaleFactor;
  }
}