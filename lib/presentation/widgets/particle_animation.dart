import 'package:flutter/material.dart';
import 'dart:math';

/// 🎆 Animation de particules à la fin de l'animation d'accueil
/// Crée un effet de "explosion" autour du prénom
class ParticleAnimationWidget extends StatefulWidget {
  final String text;

  const ParticleAnimationWidget(this.text, {Key? key}) : super(key: key);

  @override
  State<ParticleAnimationWidget> createState() =>
      _ParticleAnimationWidgetState();
}

class _ParticleAnimationWidgetState extends State<ParticleAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();

    // Générer les particules
    _particles = List.generate(
      15,
      (index) => Particle(
        angle: (360 / 15) * index,
        speed: 2.0 + Random().nextDouble() * 1.5,
        delay: Random().nextDouble() * 200,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (var i = 0; i < _particles.length; i++)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final particle = _particles[i];
                final progress =
                    (_controller.value * 1000 - particle.delay) / 1500;

                if (progress < 0 || progress > 1) {
                  return SizedBox.shrink();
                }

                final distance = progress * 100;
                final opacity = 1.0 - progress;

                final dx = cos(particle.angle * pi / 180) * distance;
                final dy = sin(particle.angle * pi / 180) * distance;

                return Positioned(
                  left: 100 + dx - 5,
                  top: 100 + dy - 5,
                  child: Opacity(
                    opacity: opacity,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getParticleColor(i),
                        boxShadow: [
                          BoxShadow(
                            color: _getParticleColor(i)
                                .withOpacity(0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Color _getParticleColor(int index) {
    final colors = [
      Colors.blue.shade400,
      Colors.cyan.shade400,
      Colors.purple.shade400,
      Colors.pink.shade400,
      Colors.indigo.shade400,
    ];
    return colors[index % colors.length];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Modèle de particule
class Particle {
  final double angle;
  final double speed;
  final double delay;

  Particle({
    required this.angle,
    required this.speed,
    required this.delay,
  });
}
