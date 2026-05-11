import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/event_model.dart';
import '../pages/event_detail_page.dart';

class MyRegisteredEventsCarousel extends StatelessWidget {
  final List<CleanupEvent> registeredEvents;

  const MyRegisteredEventsCarousel({super.key, required this.registeredEvents});

  @override
  Widget build(BuildContext context) {
    if (registeredEvents.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'My Registered Events',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppTheme.darkBlue,
            ),
          ),
        ),
        SizedBox(
          height: 130,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            scrollDirection: Axis.horizontal,
            itemCount: registeredEvents.length,
            itemBuilder: (context, index) {
              final event = registeredEvents[index];
              return _RegisteredEventCard(event: event, isDark: isDark);
            },
          ),
        ),
      ],
    );
  }
}

class _RegisteredEventCard extends StatelessWidget {
  final CleanupEvent event;
  final bool isDark;

  const _RegisteredEventCard({
    required this.event,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final difference = event.dateTime.difference(DateTime.now());
    final daysLeft = difference.inDays;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventDetailPage(event: event),
          ),
        );
      },
      child: Container(
        width: 260,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF162536) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.primaryBlue.withOpacity(isDark ? 0.3 : 0.1),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(event.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppTheme.darkBlue,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('MMM d, h:mm a').format(event.dateTime),
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: daysLeft <= 2 
                        ? const Color(0xFFE63946).withOpacity(0.1)
                        : const Color(0xFF52B788).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    daysLeft == 0 ? 'Today' : (daysLeft == 1 ? 'Tomorrow' : 'In $daysLeft days'),
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: daysLeft <= 2 ? const Color(0xFFE63946) : const Color(0xFF52B788),
                    ),
                  ),
                ),
                Text(
                  'View Ticket',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white54 : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
