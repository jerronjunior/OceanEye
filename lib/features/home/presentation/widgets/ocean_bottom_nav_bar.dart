import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class OceanBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const OceanBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<OceanBottomNavBar> createState() => _OceanBottomNavBarState();
}

class _OceanBottomNavBarState extends State<OceanBottomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.camera_alt_outlined, activeIcon: Icons.camera_alt_rounded, label: 'Scan'),
    _NavItem(icon: Icons.map_outlined, activeIcon: Icons.map_rounded, label: 'Map'),
    _NavItem(icon: Icons.event_outlined, activeIcon: Icons.event_rounded, label: 'Events'),
    _NavItem(icon: Icons.school_outlined, activeIcon: Icons.school_rounded, label: 'Learn'),
    _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D1B2A) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = widget.currentIndex == index;

              // Special FAB-style for Scan (index 1)
              if (index == 1) {
                return _ScanButton(
                  isSelected: isSelected,
                  onTap: () => widget.onTap(index),
                );
              }

              return _NavBarItem(
                item: item,
                isSelected: isSelected,
                isDark: isDark,
                onTap: () => widget.onTap(index),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatefulWidget {
  final _NavItem item;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.88)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppTheme.primaryBlue.withOpacity(0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  widget.isSelected ? widget.item.activeIcon : widget.item.icon,
                  key: ValueKey(widget.isSelected),
                  color: widget.isSelected
                      ? AppTheme.primaryBlue
                      : (widget.isDark ? Colors.white38 : Colors.grey[400]),
                  size: 22,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.item.label,
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: widget.isSelected
                      ? AppTheme.primaryBlue
                      : (widget.isDark ? Colors.white38 : Colors.grey[400]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanButton extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _ScanButton({required this.isSelected, required this.onTap});

  @override
  State<_ScanButton> createState() => _ScanButtonState();
}

class _ScanButtonState extends State<_ScanButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05)
        .animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnim,
        builder: (context, _) {
          return Transform.scale(
            scale: _pulseAnim.value,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0077B6), Color(0xFF48CAE4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryBlue.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
