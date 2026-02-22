import 'package:flutter/material.dart';
import 'responsive_data.dart';
import 'responsive_extensions.dart';

/// A destination item for [ResponsiveNavigation].
class NavDestination {
  /// The icon for this destination.
  final IconData icon;

  /// The selected icon for this destination.
  /// If null, [icon] is used for both states.
  final IconData? selectedIcon;

  /// The label text for this destination.
  final String label;

  /// Optional badge count (e.g., notifications).
  final int? badge;

  /// Creates a [NavDestination].
  const NavDestination({
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.badge,
  });
}

/// An adaptive navigation widget that automatically switches between:
/// - **[BottomNavigationBar]** on mobile/watch
/// - **[NavigationRail]** on tablet/small desktop
/// - **Sidebar drawer** on desktop/large desktop
///
/// ## Usage
///
/// ```dart
/// ResponsiveNavigation(
///   destinations: [
///     NavDestination(icon: Icons.home, label: 'Home'),
///     NavDestination(icon: Icons.search, label: 'Search'),
///     NavDestination(icon: Icons.person, label: 'Profile'),
///   ],
///   selectedIndex: _selectedIndex,
///   onChanged: (index) => setState(() => _selectedIndex = index),
///   body: _pages[_selectedIndex],
/// )
/// ```
class ResponsiveNavigation extends StatelessWidget {
  /// The navigation destinations.
  final List<NavDestination> destinations;

  /// The currently selected index.
  final int selectedIndex;

  /// Called when a destination is selected.
  final ValueChanged<int> onChanged;

  /// The main content body.
  final Widget body;

  /// Whether the [NavigationRail] labels are always shown. Default: `true`.
  final bool showLabels;

  /// The width of the sidebar drawer on desktop. Default: `280.0`.
  final double drawerWidth;

  /// Whether the [NavigationRail] is extended (shows labels inline).
  /// Default: `false`.
  final bool railExtended;

  /// Background color for the navigation. If null, uses theme defaults.
  final Color? backgroundColor;

  /// Color for selected items. If null, uses theme primary color.
  final Color? selectedColor;

  /// Color for unselected items. If null, uses theme defaults.
  final Color? unselectedColor;

  /// Elevation for the navigation surface. Default: `0.0`.
  final double elevation;

  /// The [ScreenType] at which to switch from bottom nav to rail.
  /// Default: [ScreenType.mobile] (rail starts at tablet).
  final ScreenType railBreakpoint;

  /// The [ScreenType] at which to switch from rail to full sidebar.
  /// Default: [ScreenType.smallDesktop] (sidebar starts at desktop).
  final ScreenType sidebarBreakpoint;

  /// Creates a [ResponsiveNavigation].
  const ResponsiveNavigation({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onChanged,
    required this.body,
    this.showLabels = true,
    this.drawerWidth = 280.0,
    this.railExtended = false,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.elevation = 0.0,
    this.railBreakpoint = ScreenType.mobile,
    this.sidebarBreakpoint = ScreenType.smallDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final data = context.responsiveData;
    final screenType = data.screenType;
    final theme = Theme.of(context);
    final effectiveSelectedColor = selectedColor ?? theme.colorScheme.primary;
    final effectiveUnselectedColor =
        unselectedColor ?? theme.colorScheme.onSurfaceVariant;
    final effectiveBg = backgroundColor ?? theme.colorScheme.surface;

    // Determine navigation mode based on screen type breakpoints.
    if (screenType.index <= railBreakpoint.index) {
      return _buildBottomNav(
        context,
        effectiveSelectedColor,
        effectiveUnselectedColor,
        effectiveBg,
      );
    }

    if (screenType.index <= sidebarBreakpoint.index) {
      return _buildRailNav(
        context,
        effectiveSelectedColor,
        effectiveUnselectedColor,
        effectiveBg,
      );
    }

    return _buildSidebarNav(
      context,
      effectiveSelectedColor,
      effectiveUnselectedColor,
      effectiveBg,
    );
  }

  // ─── Bottom Navigation (Mobile/Watch) ─────────────────────────

  Widget _buildBottomNav(
    BuildContext context,
    Color selectedColor,
    Color unselectedColor,
    Color bgColor,
  ) {
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onChanged,
        elevation: elevation,
        backgroundColor: bgColor,
        indicatorColor: selectedColor.withAlpha(30),
        destinations: destinations.map((d) {
          return NavigationDestination(
            icon: _buildIcon(d, false, unselectedColor),
            selectedIcon: _buildIcon(d, true, selectedColor),
            label: d.label,
          );
        }).toList(),
      ),
    );
  }

  // ─── Navigation Rail (Tablet/Small Desktop) ───────────────────

  Widget _buildRailNav(
    BuildContext context,
    Color selectedColor,
    Color unselectedColor,
    Color bgColor,
  ) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onChanged,
            extended: railExtended,
            elevation: elevation,
            backgroundColor: bgColor,
            selectedIconTheme: IconThemeData(color: selectedColor),
            unselectedIconTheme: IconThemeData(color: unselectedColor),
            selectedLabelTextStyle: TextStyle(
              color: selectedColor,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelTextStyle: TextStyle(color: unselectedColor),
            labelType: showLabels && !railExtended
                ? NavigationRailLabelType.all
                : NavigationRailLabelType.none,
            destinations: destinations.map((d) {
              return NavigationRailDestination(
                icon: _buildIcon(d, false, unselectedColor),
                selectedIcon: _buildIcon(d, true, selectedColor),
                label: Text(d.label),
              );
            }).toList(),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: body),
        ],
      ),
    );
  }

  // ─── Sidebar Navigation (Desktop/Large Desktop) ───────────────

  Widget _buildSidebarNav(
    BuildContext context,
    Color selectedColor,
    Color unselectedColor,
    Color bgColor,
  ) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: drawerWidth,
            color: bgColor,
            child: SafeArea(
              child: Column(
                children: [
                  // Sidebar items
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 8),
                      itemCount: destinations.length,
                      itemBuilder: (context, index) {
                        final d = destinations[index];
                        final isSelected = index == selectedIndex;
                        return _SidebarItem(
                          destination: d,
                          isSelected: isSelected,
                          selectedColor: selectedColor,
                          unselectedColor: unselectedColor,
                          onTap: () => onChanged(index),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          // Body
          Expanded(child: body),
        ],
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────

  Widget _buildIcon(NavDestination d, bool selected, Color color) {
    final iconData = selected ? (d.selectedIcon ?? d.icon) : d.icon;

    if (d.badge != null && d.badge! > 0) {
      return Badge(
        label: Text(
          d.badge! > 99 ? '99+' : '${d.badge}',
          style: const TextStyle(fontSize: 10, color: Colors.white),
        ),
        child: Icon(iconData, color: color),
      );
    }

    return Icon(iconData, color: color);
  }
}

/// A single sidebar navigation item.
class _SidebarItem extends StatelessWidget {
  final NavDestination destination;
  final bool isSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.destination,
    required this.isSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: isSelected ? selectedColor.withAlpha(25) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildBadgedIcon(),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    destination.label,
                    style: TextStyle(
                      color: isSelected ? selectedColor : unselectedColor,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadgedIcon() {
    final iconData = isSelected
        ? (destination.selectedIcon ?? destination.icon)
        : destination.icon;
    final color = isSelected ? selectedColor : unselectedColor;

    if (destination.badge != null && destination.badge! > 0) {
      return Badge(
        label: Text(
          destination.badge! > 99 ? '99+' : '${destination.badge}',
          style: const TextStyle(fontSize: 10, color: Colors.white),
        ),
        child: Icon(iconData, color: color),
      );
    }

    return Icon(iconData, color: color);
  }
}
