import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class EventsHeroCard extends StatelessWidget {
  final int upcomingCount;
  final int volunteersCount;
  final int wasteExpectedKg;
  final int availablePoints;
  final VoidCallback onFindEventsTap;

  const EventsHeroCard({
    super.key,
    required this.upcomingCount,
    required this.volunteersCount,
    required this.wasteExpectedKg,
    required this.availablePoints,
    required this.onFindEventsTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF03045E), const Color(0xFF0077B6)]
              : [const Color(0xFF0077B6), const Color(0xFF00B4D8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background graphic
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.waves,
              size: 150,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Community Impact',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.8),
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'This Month',
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.people_alt, color: Colors.white, size: 28),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _StatItem(
                      value: '$upcomingCount',
                      label: 'Events',
                      icon: Icons.event,
                    ),
                    _Divider(),
                    _StatItem(
                      value: '$volunteersCount',
                      label: 'Volunteers',
                      icon: Icons.handshake,
                    ),
                    _Divider(),
                    _StatItem(
                      value: '${wasteExpectedKg}kg',
                      label: 'Target',
                      icon: Icons.delete_outline,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onFindEventsTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primaryBlue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Find Events Near Me',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white.withOpacity(0.7), size: 14),
              const SizedBox(width: 4),
              Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 30,
      color: Colors.white.withOpacity(0.2),
    );
  }
}
