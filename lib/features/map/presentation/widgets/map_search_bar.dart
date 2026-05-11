import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class MapSearchBar extends StatefulWidget {
  final ValueChanged<String>? onSearch;
  final VoidCallback? onFilterTap;
  final VoidCallback? onLocationTap;

  const MapSearchBar({
    super.key,
    this.onSearch,
    this.onFilterTap,
    this.onLocationTap,
  });

  @override
  State<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnim;
  final TextEditingController _textController = TextEditingController();
  bool _isFocused = false;
  final List<String> _suggestions = [
    'East Coast Park',
    'Sentosa Beach',
    'Changi Beach',
    'Marina Bay',
    'Pasir Ris Beach',
    'Cleanup Events Nearby',
  ];
  List<String> _filteredSuggestions = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnim = Tween<double>(begin: -60, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    setState(() {
      _filteredSuggestions = value.isEmpty
          ? []
          : _suggestions
              .where((s) => s.toLowerCase().contains(value.toLowerCase()))
              .toList();
    });
    widget.onSearch?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _slideAnim,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnim.value),
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Search Row
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.12)
                  : Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isFocused
                    ? AppTheme.teal
                    : Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 14),
                Icon(
                  Icons.search_rounded,
                  color: isDark ? Colors.white60 : Colors.grey[500],
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    onChanged: _onTextChanged,
                    onTap: () => setState(() => _isFocused = true),
                    onTapOutside: (_) => setState(() {
                      _isFocused = false;
                      _filteredSuggestions = [];
                    }),
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: isDark ? Colors.white : AppTheme.darkBlue,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search beaches, reports or events…',
                      hintStyle: GoogleFonts.outfit(
                        fontSize: 13,
                        color: isDark ? Colors.white38 : Colors.grey[400],
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                // Filter button
                _IconBtn(
                  icon: Icons.tune_rounded,
                  tooltip: 'Filters',
                  isDark: isDark,
                  onTap: widget.onFilterTap,
                ),
                // Location button
                _IconBtn(
                  icon: Icons.my_location_rounded,
                  tooltip: 'My Location',
                  isDark: isDark,
                  color: AppTheme.teal,
                  onTap: widget.onLocationTap,
                ),
                const SizedBox(width: 6),
              ],
            ),
          ),
          // Autocomplete suggestions
          if (_filteredSuggestions.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1A2A3A).withOpacity(0.96)
                    : Colors.white.withOpacity(0.97),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Column(
                  children: _filteredSuggestions.map((s) {
                    return InkWell(
                      onTap: () {
                        _textController.text = s;
                        setState(() => _filteredSuggestions = []);
                        widget.onSearch?.call(s);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 16,
                                color: AppTheme.teal),
                            const SizedBox(width: 10),
                            Text(
                              s,
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                color: isDark ? Colors.white : AppTheme.darkBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isDark;
  final Color? color;
  final VoidCallback? onTap;

  const _IconBtn({
    required this.icon,
    required this.tooltip,
    required this.isDark,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 20,
            color: color ?? (isDark ? Colors.white54 : Colors.grey[500]),
          ),
        ),
      ),
    );
  }
}
