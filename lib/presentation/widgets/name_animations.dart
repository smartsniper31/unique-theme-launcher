import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Enum pour les états du prénom vivant
enum LivingNameState {
  asleep, // 😴 Endormi 22h-6h
  waking, // ☀️ Réveil 6h-10h (premier déverrouillage)
  energetic, // ⚡ Énergique batterie > 50% + matin
  tired, // 😫 Fatigué usage > 2h
  happy, // 🎉 Heureux (anniversaire)
  sad, // 😢 Triste batterie < 15%
  hungry, // 🔋 Affamé batterie 15-20%
  playful, // 😏 Joueur soirée 18h-22h
}

/// 🎭 Widget d'animation du prénom selon l'état
abstract class NameAnimationBuilder {
  Widget build(
    BuildContext context,
    String name,
    Color color,
    double fontSize,
  );

  /// Emoji correspondant à l'état
  String get emoji;

  /// Description de l'état pour l'accessibilité
  String get stateLabel;
}

// ============================================================================
// 😴 ANIMATION ENDORMI (Asleep)
// ============================================================================
class AsleepAnimation extends NameAnimationBuilder {
  @override
  String get emoji => '😴';

  @override
  String get stateLabel => 'Endormi';

  @override
  Widget build(
    BuildContext context,
    String name,
    Color color,
    double fontSize,
  ) {
    return _AsleepAnimationWidget(
      name: name,
      color: color,
      fontSize: fontSize,
    );
  }
}

class _AsleepAnimationWidget extends StatefulWidget {
  final String name;
  final Color color;
  final double fontSize;

  const _AsleepAnimationWidget({
    required this.name,
    required this.color,
    required this.fontSize,
  });

  @override
  State<_AsleepAnimationWidget> createState() => _AsleepAnimationWidgetState();
}

class _AsleepAnimationWidgetState extends State<_AsleepAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _breatheController;
  late Animation<double> _breatheAnimation;

  @override
  void initState() {
    super.initState();
    _breatheController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _breatheAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _breatheController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _breatheAnimation,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: 0.6 + (_breatheAnimation.value * 0.2),
              child: Transform.translate(
                offset: Offset(0, -2 * _breatheAnimation.value),
                child: Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.bold,
                    color: widget.color.withValues(alpha: 0.7),
                    letterSpacing: -1.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '😴',
              style: TextStyle(fontSize: widget.fontSize * 0.7),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================================
// ☀️ ANIMATION RÉVEIL (Waking)
// ============================================================================
class WakingAnimation extends NameAnimationBuilder {
  @override
  String get emoji => '☀️';

  @override
  String get stateLabel => 'Réveil';

  @override
  Widget build(
    BuildContext context,
    String name,
    Color color,
    double fontSize,
  ) {
    return _WakingAnimationWidget(
      name: name,
      color: color,
      fontSize: fontSize,
    );
  }
}

class _WakingAnimationWidget extends StatefulWidget {
  final String name;
  final Color color;
  final double fontSize;

  const _WakingAnimationWidget({
    required this.name,
    required this.color,
    required this.fontSize,
  });

  @override
  State<_WakingAnimationWidget> createState() => _WakingAnimationWidgetState();
}

class _WakingAnimationWidgetState extends State<_WakingAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _blurController;
  late AnimationController _rotationController;
  late Animation<double> _blurAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _blurController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _blurAnimation = Tween<double>(begin: 8.0, end: 0.0).animate(
      CurvedAnimation(parent: _blurController, curve: Curves.easeOut),
    );

    _rotationAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _blurController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _blurController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_blurAnimation, _rotationAnimation]),
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.rotate(
              angle: _rotationAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: [
                        widget.color.withValues(alpha: 0.5),
                        widget.color,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -1.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Opacity(
              opacity: _opacityAnimation.value,
              child: Text(
                '☀️',
                style: TextStyle(fontSize: widget.fontSize * 0.7),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================================
// ⚡ ANIMATION ÉNERGIQUE (Energetic)
// ============================================================================
class EnergeticAnimation extends NameAnimationBuilder {
  @override
  String get emoji => '⚡';

  @override
  String get stateLabel => 'Énergique';

  @override
  Widget build(
    BuildContext context,
    String name,
    Color color,
    double fontSize,
  ) {
    return _EnergeticAnimationWidget(
      name: name,
      color: color,
      fontSize: fontSize,
    );
  }
}

class _EnergeticAnimationWidget extends StatefulWidget {
  final String name;
  final Color color;
  final double fontSize;

  const _EnergeticAnimationWidget({
    required this.name,
    required this.color,
    required this.fontSize,
  });

  @override
  State<_EnergeticAnimationWidget> createState() =>
      _EnergeticAnimationWidgetState();
}

class _EnergeticAnimationWidgetState extends State<_EnergeticAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _glowController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: -15).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _glowAnimation = Tween<double>(begin: 10, end: 30).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_bounceAnimation, _glowAnimation]),
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: Offset(0, _bounceAnimation.value),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.6),
                      blurRadius: _glowAnimation.value,
                      spreadRadius: _glowAnimation.value * 0.5,
                    ),
                  ],
                ),
                child: Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.bold,
                    color: widget.color,
                    letterSpacing: -1.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '⚡',
              style: TextStyle(fontSize: widget.fontSize * 0.7),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================================
// 😫 ANIMATION FATIGUÉ (Tired)
// ============================================================================
class TiredAnimation extends NameAnimationBuilder {
  @override
  String get emoji => '😫';

  @override
  String get stateLabel => 'Fatigué';

  @override
  Widget build(
    BuildContext context,
    String name,
    Color color,
    double fontSize,
  ) {
    return _TiredAnimationWidget(
      name: name,
      color: color,
      fontSize: fontSize,
    );
  }
}

class _TiredAnimationWidget extends StatefulWidget {
  final String name;
  final Color color;
  final double fontSize;

  const _TiredAnimationWidget({
    required this.name,
    required this.color,
    required this.fontSize,
  });

  @override
  State<_TiredAnimationWidget> createState() => _TiredAnimationWidgetState();
}

class _TiredAnimationWidgetState extends State<_TiredAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _tiltController;
  late Animation<double> _tiltAnimation;

  @override
  void initState() {
    super.initState();
    _tiltController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _tiltAnimation = Tween<double>(begin: 0.0, end: 0.08).animate(
      CurvedAnimation(parent: _tiltController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _tiltController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _tiltAnimation,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.rotate(
              angle: _tiltAnimation.value,
              child: Opacity(
                opacity: 0.65,
                child: Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.bold,
                    color: widget.color.withValues(alpha: 0.8),
                    letterSpacing: -1.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '😫',
              style: TextStyle(fontSize: widget.fontSize * 0.7),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================================
// 🎉 ANIMATION HEUREUX (Happy)
// ============================================================================
class HappyAnimation extends NameAnimationBuilder {
  @override
  String get emoji => '🎉';

  @override
  String get stateLabel => 'Heureux';

  @override
  Widget build(
    BuildContext context,
    String name,
    Color color,
    double fontSize,
  ) {
    return _HappyAnimationWidget(
      name: name,
      color: color,
      fontSize: fontSize,
    );
  }
}

class _HappyAnimationWidget extends StatefulWidget {
  final String name;
  final Color color;
  final double fontSize;

  const _HappyAnimationWidget({
    required this.name,
    required this.color,
    required this.fontSize,
  });

  @override
  State<_HappyAnimationWidget> createState() => _HappyAnimationWidgetState();
}

class _HappyAnimationWidgetState extends State<_HappyAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _spinController;
  late AnimationController _scaleController;
  late Animation<double> _spinAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);

    _spinAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _spinController, curve: Curves.linear),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_spinAnimation, _scaleAnimation]),
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _spinAnimation.value,
                child: Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.bold,
                    color: widget.color,
                    letterSpacing: -1.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '🎉',
              style: TextStyle(fontSize: widget.fontSize * 0.7),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================================
// 😢 ANIMATION TRISTE (Sad)
// ============================================================================
class SadAnimation extends NameAnimationBuilder {
  @override
  String get emoji => '😢';

  @override
  String get stateLabel => 'Triste';

  @override
  Widget build(
    BuildContext context,
    String name,
    Color color,
    double fontSize,
  ) {
    return _SadAnimationWidget(
      name: name,
      color: color,
      fontSize: fontSize,
    );
  }
}

class _SadAnimationWidget extends StatefulWidget {
  final String name;
  final Color color;
  final double fontSize;

  const _SadAnimationWidget({
    required this.name,
    required this.color,
    required this.fontSize,
  });

  @override
  State<_SadAnimationWidget> createState() => _SadAnimationWidgetState();
}

class _SadAnimationWidgetState extends State<_SadAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _dropController;
  late Animation<double> _dropAnimation;

  @override
  void initState() {
    super.initState();
    _dropController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _dropAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _dropController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _dropController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _dropAnimation,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: 0.7,
              child: Transform.translate(
                offset: Offset(0, 8 * _dropAnimation.value),
                child: Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.bold,
                    color: widget.color.withValues(alpha: 0.6),
                    letterSpacing: -1.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '😢',
              style: TextStyle(fontSize: widget.fontSize * 0.7),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================================
// 🔋 ANIMATION AFFAMÉ (Hungry)
// ============================================================================
class HungryAnimation extends NameAnimationBuilder {
  @override
  String get emoji => '🔋';

  @override
  String get stateLabel => 'Affamé';

  @override
  Widget build(
    BuildContext context,
    String name,
    Color color,
    double fontSize,
  ) {
    return _HungryAnimationWidget(
      name: name,
      color: color,
      fontSize: fontSize,
    );
  }
}

class _HungryAnimationWidget extends StatefulWidget {
  final String name;
  final Color color;
  final double fontSize;

  const _HungryAnimationWidget({
    required this.name,
    required this.color,
    required this.fontSize,
  });

  @override
  State<_HungryAnimationWidget> createState() => _HungryAnimationWidgetState();
}

class _HungryAnimationWidgetState extends State<_HungryAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.scale(
              scale: _pulseAnimation.value,
              child: Text(
                widget.name,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.bold,
                  color: widget.color,
                  letterSpacing: -1.0,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '🥺',
              style: TextStyle(fontSize: widget.fontSize * 0.7),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================================
// 😏 ANIMATION JOUEUR (Playful)
// ============================================================================
class PlayfulAnimation extends NameAnimationBuilder {
  @override
  String get emoji => '😏';

  @override
  String get stateLabel => 'Joueur';

  @override
  Widget build(
    BuildContext context,
    String name,
    Color color,
    double fontSize,
  ) {
    return _PlayfulAnimationWidget(
      name: name,
      color: color,
      fontSize: fontSize,
    );
  }
}

class _PlayfulAnimationWidget extends StatefulWidget {
  final String name;
  final Color color;
  final double fontSize;

  const _PlayfulAnimationWidget({
    required this.name,
    required this.color,
    required this.fontSize,
  });

  @override
  State<_PlayfulAnimationWidget> createState() =>
      _PlayfulAnimationWidgetState();
}

class _PlayfulAnimationWidgetState extends State<_PlayfulAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _winkController;
  late Animation<double> _winkAnimation;

  @override
  void initState() {
    super.initState();
    _winkController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _winkAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(parent: _winkController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _winkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _winkAnimation,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(0.05 * _winkAnimation.value),
              child: Text(
                widget.name,
                style: TextStyle(
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.bold,
                  color: widget.color,
                  letterSpacing: -1.0,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '😏',
              style: TextStyle(fontSize: widget.fontSize * 0.7),
            ),
          ],
        );
      },
    );
  }
}

/// Factory pour créer l'animation appropriée selon l'état
NameAnimationBuilder getAnimationBuilder(LivingNameState state) {
  switch (state) {
    case LivingNameState.asleep:
      return AsleepAnimation();
    case LivingNameState.waking:
      return WakingAnimation();
    case LivingNameState.energetic:
      return EnergeticAnimation();
    case LivingNameState.tired:
      return TiredAnimation();
    case LivingNameState.happy:
      return HappyAnimation();
    case LivingNameState.sad:
      return SadAnimation();
    case LivingNameState.hungry:
      return HungryAnimation();
    case LivingNameState.playful:
      return PlayfulAnimation();
  }
}
