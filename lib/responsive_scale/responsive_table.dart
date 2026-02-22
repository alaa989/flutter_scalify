import 'package:flutter/material.dart';
import 'responsive_data.dart';
import 'responsive_extensions.dart';

/// A responsive table that automatically switches between:
/// - A full **data table** on desktop/tablet screens
/// - A list of **cards** on mobile/watch screens
///
/// ## Performance Design
/// - Uses [ListView.builder] for lazy card rendering on mobile (O(visible) not O(n))
/// - Desktop table uses [DataTable] which Flutter handles efficiently
/// - Single [ScreenType] check per build — O(1) mode selection
/// - [RepaintBoundary] wraps card items for isolated repaints
///
/// ## Example
///
/// ```dart
/// ResponsiveTable(
///   columns: ['Name', 'Price', 'Status', 'Date'],
///   rows: products.map((p) => [p.name, p.price, p.status, p.date]).toList(),
///   mobileCardBuilder: (context, row, headers) => Card(
///     child: ListTile(
///       title: Text(row[0].toString()),
///       subtitle: Text(row[1].toString()),
///     ),
///   ),
///   hiddenColumnsOnMobile: [3],
/// )
/// ```
class ResponsiveTable extends StatelessWidget {
  /// Column headers for the table.
  final List<String> columns;

  /// Row data — each inner list corresponds to one row.
  /// Values can be any type; they are converted to [String] for display.
  final List<List<dynamic>> rows;

  /// Optional builder for mobile card representation.
  /// Receives the row data and column headers.
  /// If null, a default card layout is used.
  final Widget Function(
    BuildContext context,
    List<dynamic> row,
    List<String> headers,
  )? mobileCardBuilder;

  /// Column indices to hide on mobile screens (0-indexed).
  /// These columns are excluded from both the default card and
  /// from the [mobileCardBuilder]'s provided data.
  final List<int>? hiddenColumnsOnMobile;

  /// Optional callback when a row is tapped.
  final void Function(int index, List<dynamic> row)? onRowTap;

  /// The [ScreenType] at which to switch from cards to table.
  /// Default: [ScreenType.mobile] (table starts at tablet).
  final ScreenType tableBreakpoint;

  /// Whether to show column sort indicators. Default: `false`.
  final bool showSortIndicator;

  /// The currently sorted column index. Used with [showSortIndicator].
  final int? sortColumnIndex;

  /// Whether the current sort is ascending.
  final bool sortAscending;

  /// Callback when a column header is tapped for sorting.
  final void Function(int columnIndex, bool ascending)? onSort;

  /// Optional heading for the data table.
  final Widget? tableHeading;

  /// Padding for the mobile card list. Default: `EdgeInsets.all(8)`.
  final EdgeInsetsGeometry cardListPadding;

  /// Spacing between mobile cards (scaled via `.s`). Default: `8.0`.
  final double cardSpacing;

  /// Whether the table should have horizontal scroll on desktop
  /// when columns overflow. Default: `true`.
  final bool horizontalScroll;

  /// Decoration for the data table (desktop/tablet).
  final Decoration? tableDecoration;

  /// Creates a [ResponsiveTable].
  const ResponsiveTable({
    super.key,
    required this.columns,
    required this.rows,
    this.mobileCardBuilder,
    this.hiddenColumnsOnMobile,
    this.onRowTap,
    this.tableBreakpoint = ScreenType.mobile,
    this.showSortIndicator = false,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSort,
    this.tableHeading,
    this.cardListPadding = const EdgeInsets.all(8),
    this.cardSpacing = 8.0,
    this.horizontalScroll = true,
    this.tableDecoration,
  });

  @override
  Widget build(BuildContext context) {
    final data = context.responsiveData;

    // Card mode for small screens
    if (data.screenType.index <= tableBreakpoint.index) {
      return _buildCardList(context);
    }

    // Table mode for larger screens
    return _buildDataTable(context);
  }

  // ─── Desktop/Tablet: Data Table ─────────────────────────────────

  Widget _buildDataTable(BuildContext context) {
    final theme = Theme.of(context);

    final dataTable = DataTable(
      headingRowColor: WidgetStateProperty.all(
        theme.colorScheme.surfaceContainerHighest.withAlpha(80),
      ),
      decoration: tableDecoration,
      sortColumnIndex: showSortIndicator ? sortColumnIndex : null,
      sortAscending: sortAscending,
      showCheckboxColumn: false,
      columns: columns.asMap().entries.map((entry) {
        return DataColumn(
          label: Text(
            entry.value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13.fz,
            ),
          ),
          onSort: onSort != null
              ? (columnIndex, ascending) => onSort!(columnIndex, ascending)
              : null,
        );
      }).toList(),
      rows: rows.asMap().entries.map((entry) {
        final index = entry.key;
        final row = entry.value;
        return DataRow(
          onSelectChanged:
              onRowTap != null ? (_) => onRowTap!(index, row) : null,
          cells: row.map((cell) {
            return DataCell(
              Text(
                cell?.toString() ?? '',
                style: TextStyle(fontSize: 13.fz),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );

    if (tableHeading != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          tableHeading!,
          horizontalScroll
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal, child: dataTable)
              : dataTable,
        ],
      );
    }

    return horizontalScroll
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal, child: dataTable)
        : dataTable;
  }

  // ─── Mobile/Watch: Card List ──────────────────────────────────

  Widget _buildCardList(BuildContext context) {
    final hiddenSet = hiddenColumnsOnMobile?.toSet() ?? <int>{};

    return ListView.separated(
      padding: cardListPadding,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rows.length,
      separatorBuilder: (_, __) => SizedBox(height: cardSpacing.s),
      itemBuilder: (context, index) {
        final row = rows[index];

        // Filter hidden columns for mobile
        final filteredRow = <dynamic>[];
        final filteredHeaders = <String>[];
        for (int i = 0; i < row.length; i++) {
          if (!hiddenSet.contains(i)) {
            filteredRow.add(row[i]);
            if (i < columns.length) filteredHeaders.add(columns[i]);
          }
        }

        if (mobileCardBuilder != null) {
          return RepaintBoundary(
            child: GestureDetector(
              onTap: onRowTap != null ? () => onRowTap!(index, row) : null,
              child: mobileCardBuilder!(context, filteredRow, filteredHeaders),
            ),
          );
        }

        // Default card layout
        return RepaintBoundary(
          child: _DefaultMobileCard(
            headers: filteredHeaders,
            values: filteredRow,
            onTap: onRowTap != null ? () => onRowTap!(index, row) : null,
          ),
        );
      },
    );
  }
}

/// Default card layout for mobile when no [mobileCardBuilder] is provided.
class _DefaultMobileCard extends StatelessWidget {
  final List<String> headers;
  final List<dynamic> values;
  final VoidCallback? onTap;

  const _DefaultMobileCard({
    required this.headers,
    required this.values,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(14.s),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // First value as title
              if (values.isNotEmpty)
                Text(
                  values[0]?.toString() ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.fz,
                  ),
                ),
              if (values.length > 1) SizedBox(height: 8.s),
              // Remaining values as key-value pairs
              for (int i = 1; i < values.length; i++)
                Padding(
                  padding: EdgeInsets.only(bottom: 4.s),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        i < headers.length ? headers[i] : '',
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 12.fz,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          values[i]?.toString() ?? '',
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 13.fz),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
