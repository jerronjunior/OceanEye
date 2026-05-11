import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/event_model.dart';

class EventDetailPage extends StatefulWidget {
  final CleanupEvent event;

  const EventDetailPage({super.key, required this.event});

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  bool _isJoined = false;

  @override
  void initState() {
    super.initState();
    _isJoined = widget.event.isRegistered;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final e = widget.event;
    final isCompleted = e.status == EventStatus.completed;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F1E2E) : const Color(0xFFF8F9FA),
      body: CustomScrollView(
        slivers: [
          // ── Hero Header ──
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: AppTheme.primaryBlue,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share_outlined, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.white),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    e.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: e.difficulty.color,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                e.difficulty.label,
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (isCompleted)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: EventStatus.completed.color,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Completed',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          e.title,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.business, color: Colors.white70, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'By ${e.organizerName} • ${e.organizerType}',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
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
          ),

          // ── Content ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Info Row
                  Row(
                    children: [
                      _QuickInfo(
                        icon: Icons.calendar_today,
                        title: DateFormat('MMM d, yyyy').format(e.dateTime),
                        subtitle: DateFormat('h:mm a').format(e.dateTime),
                        isDark: isDark,
                      ),
                      _QuickInfo(
                        icon: Icons.timer_outlined,
                        title: '${e.duration.inHours} Hours',
                        subtitle: 'Duration',
                        isDark: isDark,
                      ),
                      _QuickInfo(
                        icon: Icons.stars,
                        title: '${e.ecoPointsReward} pts',
                        subtitle: 'Reward',
                        iconColor: AppTheme.seaGreen,
                        isDark: isDark,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Description
                  Text(
                    'About this Event',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppTheme.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    e.description,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Impact Estimate
                  if (e.expectedWasteKg > 0) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.teal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.teal.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.teal.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.delete_outline, color: AppTheme.teal),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isCompleted ? 'Total Waste Removed' : 'Expected Impact',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    color: isDark ? Colors.white54 : Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${e.expectedWasteKg} kg of marine debris',
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    color: isDark ? Colors.white : AppTheme.darkBlue,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Requirements
                  if (e.requiredItems.isNotEmpty) ...[
                    Text(
                      'What to Bring',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppTheme.darkBlue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: e.requiredItems.map((item) => Chip(
                        label: Text(item),
                        labelStyle: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white : AppTheme.darkBlue,
                        ),
                        backgroundColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100],
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      )).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Location
                  Text(
                    'Meeting Point',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppTheme.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: AppTheme.coral, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          e.address,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: isDark ? Colors.white70 : Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Mock map preview
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(16),
                      image: const DecorationImage(
                        image: NetworkImage('https://maps.googleapis.com/maps/api/staticmap?center=1.2494,103.8303&zoom=14&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C1.2494,103.8303&key=YOUR_API_KEY'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Text(
                          'Open in Map',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Participants
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Volunteers',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppTheme.darkBlue,
                        ),
                      ),
                      Text(
                        '${e.participantsCount} / ${e.maxVolunteers}',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 40,
                    child: Stack(
                      children: [
                        for (int i = 0; i < e.participantAvatars.length; i++)
                          Positioned(
                            left: i * 28.0,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundImage: NetworkImage(e.participantAvatars[i]),
                              ),
                            ),
                          ),
                        if (e.participantsCount > e.participantAvatars.length)
                          Positioned(
                            left: e.participantAvatars.length * 28.0,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                                child: Text(
                                  '+${e.participantsCount - e.participantAvatars.length}',
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primaryBlue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Bottom padding for fixed button
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // ── Bottom Action Bar ──
      bottomSheet: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF162536) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: const Offset(0, -4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            if (!isCompleted) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: AppTheme.primaryBlue.withOpacity(0.3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Icon(Icons.map_outlined, color: AppTheme.primaryBlue),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() => _isJoined = !_isJoined);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isJoined ? AppTheme.seaGreen : AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    _isJoined ? 'Joined' : 'Join Event',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ] else ...[
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'View Event Impact Report',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

class _QuickInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final bool isDark;

  const _QuickInfo({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: iconColor ?? AppTheme.primaryBlue, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppTheme.darkBlue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.outfit(
              fontSize: 11,
              color: isDark ? Colors.white54 : Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
