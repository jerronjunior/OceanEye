import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class PollutionHotspotsSection extends StatelessWidget {
  const PollutionHotspotsSection({super.key});

  static const List<_Hotspot> _hotspots = [
    _Hotspot(
      beach: 'East Coast Park',
      severity: 'High',
      severityColor: Color(0xFFE63946),
      categories: ['Plastics', 'Bottles', 'Nets'],
      emoji: '🚨',
    ),
    _Hotspot(
      beach: 'Changi Beach',
      severity: 'Medium',
      severityColor: Color(0xFFFFB703),
      categories: ['Bags', 'Cans'],
      emoji: '⚠️',
    ),
    _Hotspot(
      beach: 'Pasir Ris Beach',
      severity: 'Low',
      severityColor: Color(0xFF52B788),
      categories: ['Paper', 'Cups'],
      emoji: '🟡',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Pollution Hotspots',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppTheme.darkBlue,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View Map',
                  style: GoogleFonts.outfit(
                    color: AppTheme.teal,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._hotspots.map((h) => _HotspotCard(hotspot: h)),
        ],
      ),
    );
  }
}

class _HotspotCard extends StatelessWidget {
  final _Hotspot hotspot;

  const _HotspotCard({required this.hotspot});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2A3A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hotspot.severityColor.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: hotspot.severityColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: hotspot.severityColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(hotspot.emoji, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      hotspot.beach,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppTheme.darkBlue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: hotspot.severityColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        hotspot.severity,
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: hotspot.severityColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: hotspot.categories
                      .map(
                        (c) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withOpacity(0.08)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            c,
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              color: isDark ? Colors.white70 : Colors.grey[600],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: Column(
              children: [
                Icon(Icons.map_outlined, size: 16, color: AppTheme.teal),
                Text(
                  'Map',
                  style: GoogleFonts.outfit(fontSize: 10, color: AppTheme.teal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Hotspot {
  final String beach;
  final String severity;
  final Color severityColor;
  final List<String> categories;
  final String emoji;

  const _Hotspot({
    required this.beach,
    required this.severity,
    required this.severityColor,
    required this.categories,
    required this.emoji,
  });
}
