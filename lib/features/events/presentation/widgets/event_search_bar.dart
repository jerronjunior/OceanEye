import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class EventSearchBar extends StatelessWidget {
  final VoidCallback onFilterTap;

  const EventSearchBar({super.key, required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                style: GoogleFonts.outfit(
                  color: isDark ? Colors.white : AppTheme.darkBlue,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Search by beach, city, or organizer',
                  hintStyle: GoogleFonts.outfit(
                    color: isDark ? Colors.white38 : Colors.grey[400],
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark ? Colors.white54 : Colors.grey[500],
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onFilterTap,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0077B6), Color(0xFF00B4D8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.tune,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
