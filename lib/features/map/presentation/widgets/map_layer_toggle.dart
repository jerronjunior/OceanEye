import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models/map_marker_model.dart';

class MapLayerToggle extends StatelessWidget {
  final MapLayerType selected;
  final ValueChanged<MapLayerType> onChanged;

  const MapLayerToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const List<_LayerOption> _options = [
    _LayerOption(type: MapLayerType.standard, icon: Icons.map_outlined, label: 'Map'),
    _LayerOption(type: MapLayerType.satellite, icon: Icons.satellite_alt_outlined, label: 'Satellite'),
    _LayerOption(type: MapLayerType.terrain, icon: Icons.terrain_outlined, label: 'Terrain'),
    _LayerOption(type: MapLayerType.heatmap, icon: Icons.local_fire_department_outlined, label: 'Heat'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withOpacity(0.55)
            : Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.12) : Colors.white,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: _options.map((opt) {
            final isSelected = opt.type == selected;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: GestureDetector(
                onTap: () => onChanged(opt.type),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Color(0xFF0077B6), Color(0xFF00B4D8)],
                          )
                        : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        opt.icon,
                        size: 18,
                        color: isSelected
                            ? Colors.white
                            : (isDark ? Colors.white54 : Colors.grey[500]),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        opt.label,
                        style: GoogleFonts.outfit(
                          fontSize: 9,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.white54 : Colors.grey[500]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _LayerOption {
  final MapLayerType type;
  final IconData icon;
  final String label;

  const _LayerOption({
    required this.type,
    required this.icon,
    required this.label,
  });
}
