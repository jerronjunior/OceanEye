import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class UserImpactCard extends StatefulWidget {
  const UserImpactCard({super.key});

  @override
  State<UserImpactCard> createState() => _UserImpactCardState();
}

class _UserImpactCardState extends State<UserImpactCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _progressAnim = Tween<double>(begin: 0, end: 0.68)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A2A3A) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(isDark ? 0.15 : 0.1),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : AppTheme.lightBlue.withOpacity(0.3),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0096C7), Color(0xFF48CAE4)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.eco_outlined, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'My Impact',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppTheme.darkBlue,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF48CAE4).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Level 7',
                        style: GoogleFonts.outfit(
                          color: AppTheme.teal,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // EcoPoints
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '4,820',
                      style: GoogleFonts.outfit(
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'EcoPoints',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white54 : Colors.grey[500],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Progress bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress to Level 8',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: isDark ? Colors.white60 : Colors.grey[600],
                          ),
                        ),
                        Text(
                          '${(_progressAnim.value * 100).round()}%',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.teal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        widthFactor: _progressAnim.value,
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0077B6), Color(0xFF48CAE4)],
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '3,400 pts needed for next level',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: isDark ? Colors.white38 : Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Stats Row
                Row(
                  children: [
                    _ImpactStat(
                      icon: Icons.emoji_events_outlined,
                      value: '12',
                      label: 'Badges',
                      color: const Color(0xFFFFB703),
                    ),
                    _divider(),
                    _ImpactStat(
                      icon: Icons.delete_outline,
                      value: '89 kg',
                      label: 'Waste Reported',
                      color: AppTheme.teal,
                    ),
                    _divider(),
                    _ImpactStat(
                      icon: Icons.handshake_outlined,
                      value: '14',
                      label: 'Cleanups Joined',
                      color: const Color(0xFF52B788),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.emoji_events_outlined, size: 18),
                    label: Text(
                      'View Achievements',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryBlue,
                      side: BorderSide(color: AppTheme.primaryBlue.withOpacity(0.5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 36,
      color: Colors.grey.withOpacity(0.15),
    );
  }
}

class _ImpactStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _ImpactStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
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
              color: isDark ? Colors.white54 : Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
