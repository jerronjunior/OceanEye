import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class LeaderboardPreview extends StatelessWidget {
  const LeaderboardPreview({super.key});

  static const List<_LeaderEntry> _entries = [
    _LeaderEntry(rank: 1, name: 'AquaHero99', points: 12450, emoji: '🌊', isYou: false),
    _LeaderEntry(rank: 2, name: 'CoralSaver', points: 11820, emoji: '🪸', isYou: false),
    _LeaderEntry(rank: 3, name: 'Jerron J.', points: 4820, emoji: '⚡', isYou: true),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2A3A) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFB703), Color(0xFFFB8500)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Text('🏆', style: TextStyle(fontSize: 20))),
                ),
                const SizedBox(width: 12),
                Text(
                  'Leaderboard',
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
                    'This Week',
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
            ..._entries.asMap().entries.map((e) {
              return _LeaderCard(entry: e.value, index: e.key, isDark: isDark);
            }),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.leaderboard, size: 18),
                label: Text(
                  'View Full Leaderboard',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFFB703),
                  side: const BorderSide(color: Color(0xFFFFB703), width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LeaderCard extends StatelessWidget {
  final _LeaderEntry entry;
  final int index;
  final bool isDark;

  const _LeaderCard({required this.entry, required this.index, required this.isDark});

  static const List<Color> _rankColors = [
    Color(0xFFFFD700),
    Color(0xFFC0C0C0),
    Color(0xFFCD7F32),
  ];

  static const List<String> _rankEmojis = ['🥇', '🥈', '🥉'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: entry.isYou
            ? AppTheme.primaryBlue.withOpacity(isDark ? 0.2 : 0.08)
            : isDark
                ? Colors.white.withOpacity(0.04)
                : Colors.grey[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: entry.isYou
              ? AppTheme.primaryBlue.withOpacity(0.4)
              : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Text(_rankEmojis[index], style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          // Avatar
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  _rankColors[index].withOpacity(0.8),
                  _rankColors[index],
                ],
              ),
            ),
            child: Center(
              child: Text(
                entry.emoji,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      entry.name,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppTheme.darkBlue,
                      ),
                    ),
                    if (entry.isYou) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'You',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.points.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} pts',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _rankColors[index],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LeaderEntry {
  final int rank;
  final String name;
  final int points;
  final String emoji;
  final bool isYou;

  const _LeaderEntry({
    required this.rank,
    required this.name,
    required this.points,
    required this.emoji,
    required this.isYou,
  });
}
