

import 'package:flutter/material.dart';

enum ScreenType {
  watch,
  mobile,
  tablet,
  smallDesktop,
  desktop,
  largeDesktop
}

class ResponsiveHelper {
  final BuildContext context;
  late final double _screenWidth;
  late final double _screenHeight;
  
  static const double _maxScaleWidth = 1000.0;

  static const double _watchBreakpoint = 300.0;
  static const double _mobileBreakpoint = 600.0;
  static const double _tabletBreakpoint = 900.0;
  static const double _smallDesktopBreakpoint = 1200.0;
  static const double _desktopBreakpoint = 1800.0;

  static const double _watchScale = 0.67;
  static const double _tabletScale = 1.22; 
  static const double _smallDesktopScale = 1.44;
  static const double _desktopScale = 1.67; 
  static const double _largeDesktopScale = 1.89; 

  ScreenType? _cachedScreenType;

  ResponsiveHelper(this.context) {
    final Size size = MediaQuery.of(context).size;
 
    _screenWidth = size.width > _maxScaleWidth ? _maxScaleWidth : size.width;
    _screenHeight = size.height;
  }

  double get screenWidth => _screenWidth;

  double get screenHeight => _screenHeight;

  
  double get actualScreenWidth => MediaQuery.of(context).size.width;

  ScreenType get screenType {
    if (_cachedScreenType != null) return _cachedScreenType!;
    
    if (_screenWidth < _watchBreakpoint) {
      _cachedScreenType = ScreenType.watch;
    } else if (_screenWidth < _mobileBreakpoint) {
      _cachedScreenType = ScreenType.mobile;
    } else if (_screenWidth < _tabletBreakpoint) {
      _cachedScreenType = ScreenType.tablet;
    } else if (_screenWidth < _smallDesktopBreakpoint) {
      _cachedScreenType = ScreenType.smallDesktop;
    } else if (_screenWidth < _desktopBreakpoint) {
      _cachedScreenType = ScreenType.desktop;
    } else {
      _cachedScreenType = ScreenType.largeDesktop;
    }
    
    return _cachedScreenType!;
  }


  bool get isSmallScreen => screenType == ScreenType.watch || screenType == ScreenType.mobile;
  bool get isMediumScreen => screenType == ScreenType.tablet || screenType == ScreenType.smallDesktop;
  bool get isLargeScreen => screenType == ScreenType.desktop || screenType == ScreenType.largeDesktop;

 
  bool get isOverMaxWidth => actualScreenWidth > _maxScaleWidth;

  T valueByScreen<T>({
    required T watch,
    required T mobile,
    required T tablet,
    required T smallDesktop,
    required T desktop,
    required T largeDesktop,
  }) {
    switch (screenType) {
      case ScreenType.watch:
        return watch;
      case ScreenType.mobile:
        return mobile;
      case ScreenType.tablet:
        return tablet;
      case ScreenType.smallDesktop:
        return smallDesktop;
      case ScreenType.desktop:
        return desktop;
      case ScreenType.largeDesktop:
        return largeDesktop;
    }
  }

  T autoScale<T extends num>(T mobileValue) {
  
    switch (screenType) {
      case ScreenType.watch:
        return (mobileValue * _watchScale) as T;
      case ScreenType.mobile:
        return mobileValue;
      case ScreenType.tablet:
        return (mobileValue * _tabletScale) as T;
      case ScreenType.smallDesktop:
        return (mobileValue * _smallDesktopScale) as T;
      case ScreenType.desktop:
        return (mobileValue * _desktopScale) as T;
      case ScreenType.largeDesktop:
        return (mobileValue * _largeDesktopScale) as T;
    }
  }
  
  T autoScaleUI<T extends num>(T mobileValue) {
    switch (screenType) {
      case ScreenType.watch:
        return (mobileValue * 0.75) as T;
      case ScreenType.mobile:
        return mobileValue;
      case ScreenType.tablet:
        return (mobileValue * 1.15) as T;
      case ScreenType.smallDesktop:
        return (mobileValue * 1.25) as T;
      case ScreenType.desktop:
        return (mobileValue * 1.35) as T;
      case ScreenType.largeDesktop:
        return (mobileValue * 1.5) as T;
    }
  }
  
  int autoScaleInt(int mobileValue) => autoScale(mobileValue).round();
  
  double autoScaleDouble(double mobileValue) => autoScale(mobileValue);

  double autoScaleSpace(double mobileValue) => autoScaleUI(mobileValue);

  double autoScaleFontSize(double mobileSize) => autoScale(mobileSize);
 
  double autoScaleIconSize(double mobileSize) => autoScaleUI(mobileSize);
  
  T valueByScreenSize<T>({
    required T small,
    required T medium,
    required T large,
  }) {
    if (isSmallScreen) return small;
    if (isMediumScreen) return medium;
    if (isLargeScreen) return large;
    
    return medium; 
  }
}

extension ResponsiveContext on BuildContext {
  ResponsiveHelper get responsive => ResponsiveHelper(this);
}
