import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class FloatingMapActions extends StatefulWidget {
  final VoidCallback onScanTap;
  final VoidCallback onReportTap;
  final VoidCallback onRecenterTap;
  final VoidCallback onHeatmapTap;
  final bool heatmapActive;

  const FloatingMapActions({
    super.key,
    required this.onScanTap,
    required this.onReportTap,
    required this.onRecenterTap,
    required this.onHeatmapTap,
    required this.heatmapActive,
  });

  @override
  State<FloatingMapActions> createState() => _FloatingMapActionsState();
}

class _FloatingMapActionsState extends State<FloatingMapActions>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _expandAnim =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      _expanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Expandable secondary actions
        AnimatedBuilder(
          animation: _expandAnim,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Heatmap toggle
                if (_expandAnim.value > 0.05)
                  Transform.translate(
                    offset: Offset(0, 20 * (1 - _expandAnim.value)),
                    child: Opacity(
                      opacity: _expandAnim.value,
                      child: _FabItem(
                        icon: Icons.local_fire_department_outlined,
                        label: 'Heatmap',
                        color: widget.heatmapActive
                            ? const Color(0xFFE63946)
                            : (isDark ? const Color(0xFF1A2A3A) : Colors.white),
                        iconColor: widget.heatmapActive
                            ? Colors.white
                            : const Color(0xFFE63946),
                        isDark: isDark,
                        onTap: widget.onHeatmapTap,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                // Recenter
                if (_expandAnim.value > 0.2)
                  Transform.translate(
                    offset: Offset(0, 20 * (1 - _expandAnim.value)),
                    child: Opacity(
                      opacity: _expandAnim.value,
                      child: _FabItem(
                        icon: Icons.my_location_rounded,
                        label: 'Re-center',
                        color: isDark ? const Color(0xFF1A2A3A) : Colors.white,
                        iconColor: AppTheme.teal,
                        isDark: isDark,
                        onTap: widget.onRecenterTap,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                // Report
                if (_expandAnim.value > 0.4)
                  Transform.translate(
                    offset: Offset(0, 20 * (1 - _expandAnim.value)),
                    child: Opacity(
                      opacity: _expandAnim.value,
                      child: _FabItem(
                        icon: Icons.flag_outlined,
                        label: 'Report',
                        color: isDark ? const Color(0xFF1A2A3A) : Colors.white,
                        iconColor: const Color(0xFFE63946),
                        isDark: isDark,
                        onTap: widget.onReportTap,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                // Scan
                if (_expandAnim.value > 0.6)
                  Transform.translate(
                    offset: Offset(0, 20 * (1 - _expandAnim.value)),
                    child: Opacity(
                      opacity: _expandAnim.value,
                      child: _FabItem(
                        icon: Icons.camera_alt_outlined,
                        label: 'Scan Waste',
                        color: isDark ? const Color(0xFF1A2A3A) : Colors.white,
                        iconColor: AppTheme.primaryBlue,
                        isDark: isDark,
                        onTap: widget.onScanTap,
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
              ],
            );
          },
        ),
        // Main FAB
        GestureDetector(
          onTap: _toggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0077B6), Color(0xFF48CAE4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withOpacity(0.4),
                  blurRadius: 14,
                  spreadRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: AnimatedRotation(
              turns: _expanded ? 0.125 : 0,
              duration: const Duration(milliseconds: 280),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
            ),
          ),
        ),
      ],
    );
  }
}

class _FabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color iconColor;
  final bool isDark;
  final VoidCallback onTap;

  const _FabItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.iconColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withOpacity(0.55)
                  : Colors.white.withOpacity(0.92),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.14),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppTheme.darkBlue,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Mini-FAB
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
        ],
      ),
    );
  }
}
