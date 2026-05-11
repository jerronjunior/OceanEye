import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({super.key});

  static const List<_QuickAction> _actions = [
    _QuickAction(
      icon: Icons.camera_alt_outlined,
      label: 'Scan Waste',
      gradient: [Color(0xFF0077B6), Color(0xFF00B4D8)],
      emoji: '🔍',
    ),
    _QuickAction(
      icon: Icons.flag_outlined,
      label: 'Report\nPollution',
      gradient: [Color(0xFFE63946), Color(0xFFFF6B6B)],
      emoji: '⚠️',
    ),
    _QuickAction(
      icon: Icons.map_outlined,
      label: 'View Map',
      gradient: [Color(0xFF2D6A4F), Color(0xFF52B788)],
      emoji: '🗺️',
    ),
    _QuickAction(
      icon: Icons.cleaning_services_outlined,
      label: 'Join Cleanup',
      gradient: [Color(0xFFFFB703), Color(0xFFFB8500)],
      emoji: '🧹',
    ),
    _QuickAction(
      icon: Icons.school_outlined,
      label: 'Learn',
      gradient: [Color(0xFF7B2D8B), Color(0xFFAD5FBF)],
      emoji: '📚',
    ),
    _QuickAction(
      icon: Icons.leaderboard_outlined,
      label: 'Leaderboard',
      gradient: [Color(0xFF1D3557), Color(0xFF457B9D)],
      emoji: '🏆',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppTheme.darkBlue,
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.92,
            ),
            itemCount: _actions.length,
            itemBuilder: (context, index) {
              return _ActionCard(action: _actions[index], index: index);
            },
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatefulWidget {
  final _QuickAction action;
  final int index;

  const _ActionCard({required this.action, required this.index});

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.94)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.reverse();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A2A3A) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: widget.action.gradient[0].withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.07)
                  : widget.action.gradient[0].withOpacity(0.15),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.action.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: widget.action.gradient[0].withOpacity(0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(widget.action.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 10),
              Text(
                widget.action.label,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppTheme.darkBlue,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final String emoji;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.emoji,
  });
}
