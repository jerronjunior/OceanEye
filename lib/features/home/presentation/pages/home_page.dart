import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/home_app_bar.dart';
import '../widgets/hero_ocean_health_card.dart';
import '../widgets/user_impact_card.dart';
import '../widgets/quick_action_grid.dart';
import '../widgets/daily_challenge_card.dart';
import '../widgets/cleanup_event_carousel.dart';
import '../widgets/pollution_hotspots_section.dart';
import '../widgets/brand_accountability_card.dart';
import '../widgets/education_carousel.dart';
import '../widgets/leaderboard_preview.dart';
import '../widgets/recent_activity_list.dart';
import '../widgets/cta_wave_banner.dart';
import '../widgets/ocean_bottom_nav_bar.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../map/presentation/pages/map_page.dart';
import '../../../events/presentation/pages/events_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();

    // Set status bar style
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A1520)
          : const Color(0xFFF0F7FF),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeDashboard(isDark),
          _buildPlaceholderTab('Scan Waste', '📷', 'AI-powered waste detection coming soon'),
          const MapPage(),
          const EventsPage(),
          _buildPlaceholderTab('Learn', '📚', 'Educational content about ocean conservation'),
          _buildPlaceholderTab('Profile', '👤', 'Your eco profile & achievements'),
        ],
      ),
      bottomNavigationBar: OceanBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget _buildHomeDashboard(bool isDark) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Custom SliverAppBar that stays visible
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyAppBarDelegate(
              child: const HomeAppBar(),
              height: 80 + MediaQuery.of(context).padding.top,
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // 1. Ocean Health Hero Card
                const HeroOceanHealthCard(),

                // 2. User Impact Card
                const UserImpactCard(),

                // 3. Quick Action Grid
                const QuickActionGrid(),

                // 4. Daily Eco Challenge
                const DailyChallengeCard(),

                // 5. Nearby Cleanup Events
                const CleanupEventCarousel(),

                // 6. Pollution Hotspots
                const PollutionHotspotsSection(),

                // 7. Brand Accountability
                const BrandAccountabilityCard(),

                // 8. Education Carousel
                const EducationCarousel(),

                // 9. Leaderboard Preview
                const LeaderboardPreview(),

                // 10. Recent Activity
                const RecentActivityList(),

                // 11. CTA Banner
                const CTAWaveBanner(),

                // Bottom padding
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTab(String title, String emoji, String subtitle) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppTheme.darkBlue,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Text(
                subtitle,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  color: isDark ? Colors.white54 : Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => setState(() => _currentIndex = 0),
              icon: const Icon(Icons.arrow_back),
              label: Text(
                'Back to Home',
                style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Sticky header delegate for SliverPersistentHeader
class _StickyAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  const _StickyAppBarDelegate({required this.child, required this.height});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _StickyAppBarDelegate oldDelegate) =>
      oldDelegate.child != child || oldDelegate.height != height;
}
