import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class RecentActivityList extends StatelessWidget {
  const RecentActivityList({super.key});

  static const List<_Activity> _activities = [
    _Activity(
      icon: Icons.cleaning_services_outlined,
      text: 'You earned 50 points for joining a cleanup.',
      time: '2 hours ago',
      color: Color(0xFF52B788),
      emoji: '🧹',
    ),
    _Activity(
      icon: Icons.military_tech_outlined,
      text: 'Badge unlocked: Beach Guardian 🏅',
      time: '5 hours ago',
      color: Color(0xFFFFB703),
      emoji: '🏅',
    ),
    _Activity(
      icon: Icons.verified_outlined,
      text: 'Your pollution report was verified by the community.',
      time: 'Yesterday',
      color: Color(0xFF0077B6),
      emoji: '✅',
    ),
    _Activity(
      icon: Icons.camera_alt_outlined,
      text: 'You scanned 3 waste items. AI identified: Plastic bottles.',
      time: 'Yesterday',
      color: AppTheme.teal,
      emoji: '📷',
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
                'Recent Activity',
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
                  'See All',
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
          Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A2A3A) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _activities.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.grey[100],
              ),
              itemBuilder: (context, index) {
                return _ActivityTile(
                  activity: _activities[index],
                  isDark: isDark,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final _Activity activity;
  final bool isDark;

  const _ActivityTile({required this.activity, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: activity.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(activity.icon, color: activity.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.text,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: isDark ? Colors.white.withOpacity(0.9) : Colors.grey[800],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.time,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: isDark ? Colors.white38 : Colors.grey[400],
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

class _Activity {
  final IconData icon;
  final String text;
  final String time;
  final Color color;
  final String emoji;

  const _Activity({
    required this.icon,
    required this.text,
    required this.time,
    required this.color,
    required this.emoji,
  });
}
