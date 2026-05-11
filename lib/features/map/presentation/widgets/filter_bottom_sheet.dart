import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/map_marker_model.dart';

class FilterBottomSheet extends StatefulWidget {
  final MapFilterState initialFilter;
  final ValueChanged<MapFilterState> onApply;

  const FilterBottomSheet({
    super.key,
    required this.initialFilter,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required MapFilterState initialFilter,
    required ValueChanged<MapFilterState> onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(
        initialFilter: initialFilter,
        onApply: onApply,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late MapFilterState _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialFilter;
  }

  void _toggleWasteType(WasteType t) {
    final set = Set<WasteType>.from(_current.selectedWasteTypes);
    set.contains(t) ? set.remove(t) : set.add(t);
    setState(() => _current = _current.copyWith(selectedWasteTypes: set));
  }

  void _toggleSeverity(PollutionSeverity s) {
    final set = Set<PollutionSeverity>.from(_current.selectedSeverities);
    set.contains(s) ? set.remove(s) : set.add(s);
    setState(() => _current = _current.copyWith(selectedSeverities: set));
  }

  void _toggleStatus(ReportStatus s) {
    final set = Set<ReportStatus>.from(_current.selectedStatuses);
    set.contains(s) ? set.remove(s) : set.add(s);
    setState(() => _current = _current.copyWith(selectedStatuses: set));
  }

  void _toggleMarkerType(MarkerType t) {
    final set = Set<MarkerType>.from(_current.selectedMarkerTypes);
    set.contains(t) ? set.remove(t) : set.add(t);
    setState(() => _current = _current.copyWith(selectedMarkerTypes: set));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F1E2E) : Colors.white;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0077B6), Color(0xFF00B4D8)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Filter Map',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppTheme.darkBlue,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => setState(() {
                        _current = const MapFilterState();
                      }),
                      child: Text(
                        'Reset All',
                        style: GoogleFonts.outfit(
                          color: AppTheme.coral,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Divider(color: isDark ? Colors.white12 : Colors.grey[200]),
              // Scrollable content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  children: [
                    _Section(
                      title: 'Marker Types',
                      isDark: isDark,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _FilterChip(
                            label: '🔴 Pollution',
                            selected: _current.selectedMarkerTypes.contains(MarkerType.pollution),
                            selectedColor: const Color(0xFFE63946),
                            isDark: isDark,
                            onTap: () => _toggleMarkerType(MarkerType.pollution),
                          ),
                          _FilterChip(
                            label: '🔵 Cleanup Events',
                            selected: _current.selectedMarkerTypes.contains(MarkerType.cleanup),
                            selectedColor: AppTheme.primaryBlue,
                            isDark: isDark,
                            onTap: () => _toggleMarkerType(MarkerType.cleanup),
                          ),
                          _FilterChip(
                            label: '🟢 Recycling Bins',
                            selected: _current.selectedMarkerTypes.contains(MarkerType.recycling),
                            selectedColor: AppTheme.seaGreen,
                            isDark: isDark,
                            onTap: () => _toggleMarkerType(MarkerType.recycling),
                          ),
                        ],
                      ),
                    ),
                    _Section(
                      title: 'Severity',
                      isDark: isDark,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: PollutionSeverity.values.map((s) {
                          return _FilterChip(
                            label: s.label,
                            selected: _current.selectedSeverities.contains(s),
                            selectedColor: s.color,
                            isDark: isDark,
                            onTap: () => _toggleSeverity(s),
                          );
                        }).toList(),
                      ),
                    ),
                    _Section(
                      title: 'Report Status',
                      isDark: isDark,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ReportStatus.values.map((s) {
                          return _FilterChip(
                            label: s.label,
                            selected: _current.selectedStatuses.contains(s),
                            selectedColor: s.color,
                            isDark: isDark,
                            onTap: () => _toggleStatus(s),
                          );
                        }).toList(),
                      ),
                    ),
                    _Section(
                      title: 'Waste Type',
                      isDark: isDark,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: WasteType.values.map((t) {
                          return _FilterChip(
                            label: '${t.emoji} ${t.label}',
                            selected: _current.selectedWasteTypes.contains(t),
                            selectedColor: AppTheme.teal,
                            isDark: isDark,
                            onTap: () => _toggleWasteType(t),
                          );
                        }).toList(),
                      ),
                    ),
                    _Section(
                      title: 'Date Range',
                      isDark: isDark,
                      child: Row(
                        children: ['Today', 'This Week', 'This Month']
                            .asMap()
                            .entries
                            .map((e) {
                          final keys = ['today', 'week', 'month'];
                          final key = keys[e.key];
                          final selected = _current.dateRange == key;
                          return Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: e.key < 2 ? 8 : 0),
                              child: GestureDetector(
                                onTap: () => setState(
                                    () => _current = _current.copyWith(dateRange: key)),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? AppTheme.primaryBlue
                                        : (isDark
                                            ? Colors.white.withOpacity(0.07)
                                            : Colors.grey[100]),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: selected
                                          ? AppTheme.primaryBlue
                                          : Colors.transparent,
                                    ),
                                  ),
                                  child: Text(
                                    e.value,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: selected
                                          ? Colors.white
                                          : (isDark ? Colors.white60 : Colors.grey[600]),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              // Apply button
              Padding(
                padding: EdgeInsets.fromLTRB(
                    20, 8, 20, 20 + MediaQuery.of(context).padding.bottom),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(_current);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                    ),
                    child: Text(
                      'Apply Filters',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isDark;

  const _Section({
    required this.title,
    required this.child,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white54 : Colors.grey[500],
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color selectedColor;
  final bool isDark;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? selectedColor.withOpacity(0.15)
              : (isDark ? Colors.white.withOpacity(0.07) : Colors.grey[100]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? selectedColor : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected
                ? selectedColor
                : (isDark ? Colors.white70 : Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}
