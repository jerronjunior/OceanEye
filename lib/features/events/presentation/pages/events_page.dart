import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/mock_event_data.dart';
import '../widgets/events_hero_card.dart';
import '../widgets/event_search_bar.dart';
import '../widgets/my_registered_events_carousel.dart';
import '../widgets/cleanup_event_card.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final topPadding = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0A1520) : const Color(0xFFF8F9FA),
        body: Column(
          children: [
            // ── Custom Header ──
            Container(
              padding: EdgeInsets.only(top: topPadding + 10, bottom: 10, left: 20, right: 20),
              color: isDark ? const Color(0xFF0F1E2E) : Colors.white,
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
                            'Cleanup Events',
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : AppTheme.darkBlue,
                            ),
                          ),
                          Text(
                            'Join volunteers & protect our oceans.',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              color: isDark ? Colors.white54 : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.calendar_month, color: AppTheme.primaryBlue),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Scrollable Body ──
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        
                        // Hero Summary Card
                        EventsHeroCard(
                          upcomingCount: MockEventData.upcomingEvents.length,
                          volunteersCount: 420,
                          wasteExpectedKg: 1250,
                          availablePoints: 850,
                          onFindEventsTap: () {},
                        ),

                        // Search & Filter
                        EventSearchBar(
                          onFilterTap: () {
                            // TODO: Show Filter Bottom Sheet
                          },
                        ),

                        // Registered Events
                        MyRegisteredEventsCarousel(
                          registeredEvents: MockEventData.registeredEvents,
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),

                  // ── Sticky Tab Bar ──
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickyTabBarDelegate(
                      child: Container(
                        color: isDark ? const Color(0xFF0A1520) : const Color(0xFFF8F9FA),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TabBar(
                            controller: _tabController,
                            indicator: BoxDecoration(
                              color: isDark ? AppTheme.primaryBlue : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                if (!isDark)
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                  ),
                              ],
                            ),
                            labelColor: isDark ? Colors.white : AppTheme.primaryBlue,
                            unselectedLabelColor: isDark ? Colors.white54 : Colors.grey[500],
                            labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 13),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorPadding: const EdgeInsets.all(4),
                            tabs: const [
                              Tab(text: 'Upcoming'),
                              Tab(text: 'Completed'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ── Event Lists ──
                  SliverFillRemaining(
                    child: TabBarView(
                      controller: _tabController,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        // Upcoming Tab
                        ListView.builder(
                          padding: EdgeInsets.only(
                            left: 20, 
                            right: 20, 
                            top: 10,
                            bottom: MediaQuery.of(context).padding.bottom + 80,
                          ),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: MockEventData.upcomingEvents.length,
                          itemBuilder: (context, index) {
                            return CleanupEventCard(
                              event: MockEventData.upcomingEvents[index],
                            );
                          },
                        ),
                        // Completed Tab
                        ListView.builder(
                          padding: EdgeInsets.only(
                            left: 20, 
                            right: 20, 
                            top: 10,
                            bottom: MediaQuery.of(context).padding.bottom + 80,
                          ),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: MockEventData.completedEvents.length,
                          itemBuilder: (context, index) {
                            return CleanupEventCard(
                              event: MockEventData.completedEvents[index],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyTabBarDelegate({required this.child});

  @override
  double get minExtent => 66.0;

  @override
  double get maxExtent => 66.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
