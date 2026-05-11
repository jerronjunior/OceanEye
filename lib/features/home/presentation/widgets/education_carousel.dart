import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class EducationCarousel extends StatelessWidget {
  const EducationCarousel({super.key});

  static const List<_EduTip> _tips = [
    _EduTip(
      title: 'How Plastic Harms Turtles',
      description: 'Marine turtles mistake plastic bags for jellyfish, causing fatal blockages.',
      emoji: '🐢',
      gradientColors: [Color(0xFF023E8A), Color(0xFF0096C7)],
      tag: 'Wildlife',
    ),
    _EduTip(
      title: '5 Ways to Reduce Marine Waste',
      description: 'Simple daily habits that can prevent thousands of kg of ocean pollution.',
      emoji: '♻️',
      gradientColors: [Color(0xFF2D6A4F), Color(0xFF52B788)],
      tag: 'Action',
    ),
    _EduTip(
      title: 'Ocean Facts You Should Know',
      description: 'The ocean produces over 50% of Earth\'s oxygen. Let\'s protect it.',
      emoji: '🌊',
      gradientColors: [Color(0xFF7B2D8B), Color(0xFFAD5FBF)],
      tag: 'Science',
    ),
    _EduTip(
      title: 'Microplastics in Our Food',
      description: 'Research shows humans consume a credit card\'s worth of plastic weekly.',
      emoji: '🔬',
      gradientColors: [Color(0xFFE63946), Color(0xFFFF6B6B)],
      tag: 'Health',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Row(
            children: [
              Text(
                'Learn & Discover',
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
                  'Browse All',
                  style: GoogleFonts.outfit(
                    color: AppTheme.teal,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20, right: 20),
            itemCount: _tips.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              return _EduCard(tip: _tips[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _EduCard extends StatelessWidget {
  final _EduTip tip;

  const _EduCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A2A3A) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image/Emoji section
          Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: tip.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    tip.emoji,
                    style: const TextStyle(fontSize: 52),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tip.tag,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tip.title,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppTheme.darkBlue,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Text(
                      tip.description,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: isDark ? Colors.white54 : Colors.grey[500],
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Read More',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.teal,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 12, color: AppTheme.teal),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EduTip {
  final String title;
  final String description;
  final String emoji;
  final List<Color> gradientColors;
  final String tag;

  const _EduTip({
    required this.title,
    required this.description,
    required this.emoji,
    required this.gradientColors,
    required this.tag,
  });
}
