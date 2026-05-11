import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class CleanupEventCarousel extends StatelessWidget {
  const CleanupEventCarousel({super.key});

  static const List<_CleanupEvent> _events = [
    _CleanupEvent(
      title: 'Sentosa Beach Cleanup',
      date: 'Sat, May 17 • 8:00 AM',
      distance: '2.3 km away',
      volunteers: 38,
      emoji: '🏖️',
      gradientColors: [Color(0xFF0077B6), Color(0xFF00B4D8)],
    ),
    _CleanupEvent(
      title: 'Marina Bay Shore Drive',
      date: 'Sun, May 18 • 7:30 AM',
      distance: '4.1 km away',
      volunteers: 55,
      emoji: '🌊',
      gradientColors: [Color(0xFF2D6A4F), Color(0xFF52B788)],
    ),
    _CleanupEvent(
      title: 'Changi Coast Cleanup',
      date: 'Mon, May 19 • 9:00 AM',
      distance: '7.8 km away',
      volunteers: 22,
      emoji: '🐠',
      gradientColors: [Color(0xFF7B2D8B), Color(0xFFAD5FBF)],
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
                'Nearby Cleanup Events',
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
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 20, right: 20),
            itemCount: _events.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              return _CleanupEventCard(event: _events[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _CleanupEventCard extends StatefulWidget {
  final _CleanupEvent event;

  const _CleanupEventCard({required this.event});

  @override
  State<_CleanupEventCard> createState() => _CleanupEventCardState();
}

class _CleanupEventCardState extends State<_CleanupEventCard> {
  bool _joined = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: 230,
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
          // Image section
          Container(
            height: 90,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.event.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    widget.event.emoji,
                    style: const TextStyle(fontSize: 48),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.people, color: Colors.white, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.event.volunteers}',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event.title,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppTheme.darkBlue,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 11, color: Colors.grey),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          widget.event.date,
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 11, color: Colors.grey),
                      const SizedBox(width: 3),
                      Text(
                        widget.event.distance,
                        style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: _joined
                          ? Container(
                              key: const ValueKey('joined'),
                              decoration: BoxDecoration(
                                color: const Color(0xFF52B788).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFF52B788)),
                              ),
                              child: Center(
                                child: Text(
                                  '✓ Joined',
                                  style: GoogleFonts.outfit(
                                    color: const Color(0xFF52B788),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                          : ElevatedButton(
                              key: const ValueKey('join'),
                              onPressed: () => setState(() => _joined = true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryBlue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.zero,
                                textStyle: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              child: const Text('Join Event'),
                            ),
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

class _CleanupEvent {
  final String title;
  final String date;
  final String distance;
  final int volunteers;
  final String emoji;
  final List<Color> gradientColors;

  const _CleanupEvent({
    required this.title,
    required this.date,
    required this.distance,
    required this.volunteers,
    required this.emoji,
    required this.gradientColors,
  });
}
