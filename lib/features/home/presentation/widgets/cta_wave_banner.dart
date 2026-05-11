import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';

class CTAWaveBanner extends StatefulWidget {
  const CTAWaveBanner({super.key});

  @override
  State<CTAWaveBanner> createState() => _CTAWaveBannerState();
}

class _CTAWaveBannerState extends State<CTAWaveBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF03045E), Color(0xFF0077B6), Color(0xFF00B4D8)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Animated wave background
            AnimatedBuilder(
              animation: _waveController,
              builder: (context, _) {
                return CustomPaint(
                  size: Size(MediaQuery.of(context).size.width - 40, 180),
                  painter: _WaveBackgroundPainter(_waveController.value),
                );
              },
            ),
            // Floating bubbles
            Positioned(top: 20, right: 30, child: _Bubble(size: 40, opacity: 0.1)),
            Positioned(top: 60, right: 80, child: _Bubble(size: 20, opacity: 0.08)),
            Positioned(bottom: 30, right: 50, child: _Bubble(size: 60, opacity: 0.07)),
            Positioned(bottom: 20, left: 20, child: _Bubble(size: 25, opacity: 0.09)),
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '🌊 One scan can spark',
                    style: GoogleFonts.outfit(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'a global wave of change.',
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.camera_alt, size: 18),
                      label: Text(
                        'Scan Now',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
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

class _Bubble extends StatelessWidget {
  final double size;
  final double opacity;

  const _Bubble({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(opacity * 3), width: 1.5),
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}

class _WaveBackgroundPainter extends CustomPainter {
  final double animationValue;

  _WaveBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = 20.0;
    final waveFrequency = 2 * math.pi / size.width;

    path.moveTo(0, size.height * 0.7);
    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.7 +
          waveHeight * math.sin(waveFrequency * x + animationValue * 2 * math.pi);
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);

    final paint2 = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height * 0.8);
    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.8 +
          waveHeight *
              math.sin(waveFrequency * x + animationValue * 2 * math.pi + math.pi / 3);
      path2.lineTo(x, y);
    }
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant _WaveBackgroundPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}
