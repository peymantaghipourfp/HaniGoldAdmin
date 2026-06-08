import 'package:flutter/material.dart';
import 'package:hanigold_admin/src/domain/splash/controller/splash.controller.dart';
import '../../../config/const/app_color.dart';
import '../../../config/const/app_text_style.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with TickerProviderStateMixin {
  final SplashController splashController = Get.find<SplashController>();

  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;
  late AnimationController _particleController;
  late List<Particle> particles;

  @override
  void initState() {
    super.initState();

    // تولید ذرات یکبار
    particles = _generateParticles();

    // انیمیشن چرخش
    _rotationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    // انیمیشن مقیاس (پالس)
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    // انیمیشن درخشش
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _particleController = AnimationController(
      duration: const Duration(seconds: 10), // حرکت آهسته‌تر
      vsync: this,
    )..repeat();
  }

  List<Particle> _generateParticles() {
    final random = math.Random();
    return List.generate(80, (index) {
      return Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        radius: random.nextDouble() * 2 + 0.5,
        speed: random.nextDouble() * 0.01 + 0.005,
        phase: random.nextDouble() * 2 * math.pi,
      );
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _shimmerController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backGroundColor,
      body: Stack(
        children: [
          // Background گرادیانت شعاعی
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.0,
                colors: [
                  Color(0xFF111111),
                  Color(0xFF000000),
                ],
              ),
            ),
          ),

          // Particles
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ParticlePainter(
                    particles: particles,
                    animationValue: _particleController.value,
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // لوگو یا آیکون با انیمیشن
                  /*ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFFD700),
                            Color(0xFFFFE55C),
                            Color(0xFFFFD700),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFFFFD700).withAlpha(130),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.diamond,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),*/

                  //const SizedBox(height: 20),

                  // لوگو چرخان به جای لودر
                  AnimatedBuilder(
                    animation: _rotationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationController.value * 2 * math.pi,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFFFD700).withAlpha(100),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              'assets/images/HaniGold.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // متن با انیمیشن درخشش
                  AnimatedBuilder(
                    animation: _shimmerController,
                    builder: (context, child) {
                      return ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            colors: [
                              Colors.white.withAlpha(130),
                              Color(0xFFFFD700),
                              Colors.white.withAlpha(130),
                            ],
                            stops: [
                              _shimmerController.value - 0.3,
                              _shimmerController.value,
                              _shimmerController.value + 0.3,
                            ],
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            tileMode: TileMode.mirror,
                          ).createShader(bounds);
                        },
                        child: Text(
                          'در حال آماده‌سازی...',
                          style: AppTextStyle.smallTitleText.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 8),

                  // متن فرعی
                  Text(
                    'حانی گلد',
                    style: AppTextStyle.smallTitleText.copyWith(
                      color: Color(0xFFFFD700),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlePainter({
    required this.particles,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var particle in particles) {
      final x = particle.x * size.width;
      final y = ((particle.y + animationValue * particle.speed) % 1.0) * size.height;

      // افکت چشمک زدن
      final opacity = (math.sin(animationValue * 10 * math.pi + particle.phase) + 1) / 2;
      paint.color = Color(0xFFFFD700).withOpacity(opacity * 0.8);

      canvas.drawCircle(
        Offset(x, y),
        particle.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

class Particle {
  final double x;
  final double y;
  final double radius;
  final double speed;
  final double phase;

  Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.phase,
  });
}