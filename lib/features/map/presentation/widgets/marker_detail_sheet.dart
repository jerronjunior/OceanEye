import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/map_marker_model.dart';

class MarkerDetailSheet extends StatefulWidget {
  final OceanMapMarker marker;
  final VoidCallback? onDirectionsTap;

  const MarkerDetailSheet({super.key, required this.marker, this.onDirectionsTap});

  static Future<void> show(BuildContext context, OceanMapMarker marker, {VoidCallback? onDirectionsTap}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MarkerDetailSheet(marker: marker, onDirectionsTap: onDirectionsTap),
    );
  }

  @override
  State<MarkerDetailSheet> createState() => _MarkerDetailSheetState();
}

class _MarkerDetailSheetState extends State<MarkerDetailSheet> {
  bool _joined = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F1E2E) : Colors.white;
    final m = widget.marker;
    final isCleanup = m.type == MarkerType.cleanup;
    final isRecycling = m.type == MarkerType.recycling;

    return DraggableScrollableSheet(
      initialChildSize: 0.58,
      minChildSize: 0.3,
      maxChildSize: 0.92,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  children: [
                    // ── Header ──
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _headerGradient(m),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(m.emoji,
                                style: const TextStyle(fontSize: 26)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.title,
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : AppTheme.darkBlue,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                m.subtitle,
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  color: isDark ? Colors.white54 : Colors.grey[500],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  if (m.severity != null)
                                    _Badge(
                                      label: m.severity!.label,
                                      color: m.severity!.color,
                                    ),
                                  if (m.status != null) ...[
                                    const SizedBox(width: 6),
                                    _Badge(
                                      label: m.status!.label,
                                      color: m.status!.color,
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── Hero Image / Emoji card ──
                    Container(
                      height: 140,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _headerGradient(m),
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(m.emoji,
                                style: const TextStyle(fontSize: 72)),
                          ),
                          Positioned(
                            bottom: 12,
                            right: 14,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.white, size: 13),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${m.position.latitude.toStringAsFixed(4)}, '
                                    '${m.position.longitude.toStringAsFixed(4)}',
                                    style: GoogleFonts.outfit(
                                      fontSize: 11,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── Details section (for pollution) ──
                    if (!isCleanup && !isRecycling) ...[
                      _SectionHeader(title: 'Details', isDark: isDark),
                      const SizedBox(height: 10),
                      _DetailRow(
                          icon: Icons.delete_outline,
                          label: 'Estimated Waste',
                          value: '~${m.estimatedWasteKg} kg',
                          isDark: isDark),
                      _DetailRow(
                          icon: Icons.access_time_outlined,
                          label: 'Reported',
                          value: m.timeAgo,
                          isDark: isDark),
                      _DetailRow(
                          icon: Icons.person_outline,
                          label: 'Reported by',
                          value: m.reporterName,
                          isDark: isDark),
                      if (m.wasteTypes.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Waste Categories',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: isDark ? Colors.white38 : Colors.grey[500],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: m.wasteTypes.map((t) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppTheme.teal.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: AppTheme.teal.withOpacity(0.3)),
                              ),
                              child: Text(
                                '${t.emoji} ${t.label}',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  color: AppTheme.teal,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      if (m.brandsDetected.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        _SectionHeader(
                            title: 'Brands Detected 🏭', isDark: isDark),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: m.brandsDetected.map((b) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE63946).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: const Color(0xFFE63946).withOpacity(0.3)),
                              ),
                              child: Text(
                                b,
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  color: const Color(0xFFE63946),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                      const SizedBox(height: 20),
                    ],

                    // ── Cleanup event details ──
                    if (isCleanup) ...[
                      _SectionHeader(title: 'Event Details', isDark: isDark),
                      const SizedBox(height: 10),
                      _DetailRow(
                          icon: Icons.event,
                          label: 'Date & Time',
                          value: m.eventDate ?? 'TBD',
                          isDark: isDark),
                      _DetailRow(
                          icon: Icons.people_outline,
                          label: 'Volunteers',
                          value: '${m.volunteers} joined',
                          isDark: isDark),
                      _DetailRow(
                          icon: Icons.stars_outlined,
                          label: 'EcoPoints Reward',
                          value: '+${m.ecoPoints} pts',
                          isDark: isDark),
                      const SizedBox(height: 20),
                    ],

                    // ── Recycling bin details ──
                    if (isRecycling) ...[
                      _SectionHeader(title: 'Recycling Info', isDark: isDark),
                      const SizedBox(height: 10),
                      _DetailRow(
                          icon: Icons.recycling,
                          label: 'Accepts',
                          value: 'Plastic, Glass, Metal, Paper',
                          isDark: isDark),
                      _DetailRow(
                          icon: Icons.access_time,
                          label: 'Hours',
                          value: 'Open 24 hours',
                          isDark: isDark),
                      const SizedBox(height: 20),
                    ],

                    // ── Impact stats ──
                    if (m.volunteers > 0 || m.ecoPoints > 0) ...[
                      _SectionHeader(title: 'Impact Stats', isDark: isDark),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _ImpactBox(
                            value: '${m.volunteers}',
                            label: 'Volunteers',
                            icon: Icons.people_outline,
                            color: AppTheme.primaryBlue,
                            isDark: isDark,
                          ),
                          const SizedBox(width: 10),
                          _ImpactBox(
                            value: '${m.estimatedWasteKg}kg',
                            label: 'Waste',
                            icon: Icons.delete_outline,
                            color: const Color(0xFFFFB703),
                            isDark: isDark,
                          ),
                          const SizedBox(width: 10),
                          _ImpactBox(
                            value: '+${m.ecoPoints}',
                            label: 'EcoPoints',
                            icon: Icons.stars_outlined,
                            color: AppTheme.seaGreen,
                            isDark: isDark,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],

                    // ── Action buttons ──
                    _SectionHeader(title: 'Actions', isDark: isDark),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionBtn(
                            icon: Icons.directions_outlined,
                            label: 'Directions',
                            gradient: const [Color(0xFF0077B6), Color(0xFF00B4D8)],
                            onTap: () {
                              Navigator.pop(context);
                              widget.onDirectionsTap?.call();
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (!isRecycling)
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 280),
                              child: _joined
                                  ? Container(
                                      key: const ValueKey('joined'),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 13),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF52B788)
                                            .withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                            color: const Color(0xFF52B788)),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.check_circle,
                                              color: Color(0xFF52B788), size: 16),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Joined!',
                                            style: GoogleFonts.outfit(
                                              color: const Color(0xFF52B788),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : _ActionBtn(
                                      key: const ValueKey('join'),
                                      icon: Icons.handshake_outlined,
                                      label: 'Join Cleanup',
                                      gradient: const [
                                        Color(0xFF2D6A4F),
                                        Color(0xFF52B788)
                                      ],
                                      onTap: () =>
                                          setState(() => _joined = true),
                                    ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.flag_outlined, size: 16),
                            label: Text(
                              'Report Again',
                              style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFE63946),
                              side: const BorderSide(color: Color(0xFFE63946)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.share_outlined, size: 16),
                            label: Text(
                              'Share',
                              style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.primaryBlue,
                              side: BorderSide(
                                  color: AppTheme.primaryBlue.withOpacity(0.5)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).padding.bottom + 8),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Color> _headerGradient(OceanMapMarker m) {
    switch (m.type) {
      case MarkerType.pollution:
        return [
          m.severity?.color ?? const Color(0xFFE63946),
          (m.severity?.color ?? const Color(0xFFE63946)).withOpacity(0.5),
        ];
      case MarkerType.cleanup:
        return [const Color(0xFF0077B6), const Color(0xFF00B4D8)];
      case MarkerType.recycling:
        return [const Color(0xFF20B2AA), const Color(0xFF52B788)];
      default:
        return [AppTheme.primaryBlue, AppTheme.teal];
    }
  }
}

// ── Sub-widgets ──

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
            fontSize: 10, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SectionHeader({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white38 : Colors.grey[500],
        letterSpacing: 0.8,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon,
              size: 16,
              color: isDark ? Colors.white38 : Colors.grey[400]),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 13,
              color: isDark ? Colors.white54 : Colors.grey[500],
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppTheme.darkBlue,
            ),
          ),
        ],
      ),
    );
  }
}

class _ImpactBox extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _ImpactBox({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppTheme.darkBlue,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 10,
                color: isDark ? Colors.white38 : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ActionBtn({
    super.key,
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
