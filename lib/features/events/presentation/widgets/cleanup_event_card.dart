import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/event_model.dart';
import '../pages/event_detail_page.dart';

class CleanupEventCard extends StatelessWidget {
  final CleanupEvent event;

  const CleanupEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Header
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    event.imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 140,
                      color: isDark ? Colors.grey[800] : Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: _Badge(
                    label: '${event.ecoPointsReward} pts',
                    icon: Icons.stars,
                    color: AppTheme.seaGreen,
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: _Badge(
                    label: event.difficulty.label,
                    color: event.difficulty.color,
                  ),
                ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(event.type.icon, size: 16, color: AppTheme.teal),
                      const SizedBox(width: 6),
                      Text(
                        event.type.label.toUpperCase(),
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.teal,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${event.distanceKm} km away',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white54 : Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.title,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppTheme.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    text: DateFormat('EEE, MMM d • h:mm a').format(event.dateTime),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 6),
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    text: event.address,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.people_outline, 
                              size: 16, 
                              color: isDark ? Colors.white54 : Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            '${event.participantsCount}/${event.maxVolunteers} joined',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white70 : Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      if (event.status != EventStatus.completed)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Join',
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        )
                      else
                        Text(
                          'Completed',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: EventStatus.completed.color,
                          ),
                        ),
                    ],
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

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const _Badge({required this.label, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: Colors.white),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDark;

  const _InfoRow({
    required this.icon,
    required this.text,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: isDark ? Colors.white38 : Colors.grey[400]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: isDark ? Colors.white60 : Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
