import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class BrandAccountabilityCard extends StatelessWidget {
  const BrandAccountabilityCard({super.key});

  static const List<_Brand> _brands = [
    _Brand(name: 'Unbranded', percentage: 45, emoji: '🗑️', color: Color(0xFF6C757D)),
    _Brand(name: 'Coca-Cola', percentage: 34, emoji: '🥤', color: Color(0xFFE63946)),
    _Brand(name: 'Pepsi', percentage: 21, emoji: '🧃', color: Color(0xFF1D3557)),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE63946), Color(0xFFFF6B6B)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Text('🏭', style: TextStyle(fontSize: 20))),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BRAND ACCOUNTABILITY',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: const Color(0xFFE63946),
                      ),
                    ),
                    Text(
                      'Top Polluters This Month',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppTheme.darkBlue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ..._brands.map((b) => _BrandBar(brand: b, isDark: isDark)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.bar_chart, size: 18),
                label: Text(
                  'View Full Report',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFE63946),
                  side: const BorderSide(color: Color(0xFFE63946), width: 1.5),
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

class _BrandBar extends StatefulWidget {
  final _Brand brand;
  final bool isDark;

  const _BrandBar({required this.brand, required this.isDark});

  @override
  State<_BrandBar> createState() => _BrandBarState();
}

class _BrandBarState extends State<_BrandBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _widthAnim = Tween<double>(begin: 0, end: widget.brand.percentage / 100)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    Future.delayed(const Duration(milliseconds: 600), () {
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(widget.brand.emoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.brand.name,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: widget.isDark ? Colors.white : AppTheme.darkBlue,
                      ),
                    ),
                  ),
                  Text(
                    '${widget.brand.percentage}%',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: widget.brand.color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: widget.isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  widthFactor: _widthAnim.value,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.brand.color,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Brand {
  final String name;
  final int percentage;
  final String emoji;
  final Color color;

  const _Brand({
    required this.name,
    required this.percentage,
    required this.emoji,
    required this.color,
  });
}
