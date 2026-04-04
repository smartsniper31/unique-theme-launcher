import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';

import 'package:unique_theme_launcher/data/models/user_profile.dart';
import 'package:unique_theme_launcher/presentation/providers/dynamic_theme.dart';
import 'package:unique_theme_launcher/presentation/screens/home_screen.dart';
import 'package:unique_theme_launcher/presentation/widgets/particle_animation.dart';

/// 🎬 Écran de Bienvenue avec Animation Magique
/// 
/// Affiche UNIQUEMENT à la première installation.
/// Animation lettre-par-lettre du prénom avec effets visuels.
class WelcomeScreen extends StatefulWidget {
  final String userName;

  const WelcomeScreen({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _scaleController;
  late AnimationController _fadeController;

  String _displayedName = "";
  int _currentIndex = 0;
  Timer? _typingTimer;
  bool _isTypingComplete = false;
  bool _showCursor = true;
  late Timer _cursorTimer;

  // Variables pour les phases d'animation
  int _phase = 0; // 0: greeting, 1: typing, 2: completion, 3: ready

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startWelcomeSequence();
  }

  /// Initialise tous les contrôleurs d'animation
  void _initializeAnimations() {
    // Animation du gradient de fond rotatif
    _gradientController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();

    // Animation de scale du texte du prénom
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Animation de fade des messages
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Curseur clignotant
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          _showCursor = !_showCursor;
        });
      }
    });
  }

  /// Lance la séquence complète de bienvenue
  void _startWelcomeSequence() async {
    // Phase 0: Message d'accueil
    await _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 1000));

    // Phase 1: Animation du prénom
    _phase = 1;
    if (mounted) setState(() {});
    await _animateTyping();

    // Phase 2: Messages de completion
    _phase = 2;
    _isTypingComplete = true;
    if (mounted) setState(() {});
    await _scaleController.forward();
    await Future.delayed(const Duration(milliseconds: 1500));

    // Phase 3: Transition vers HomeScreen
    _phase = 3;
    if (mounted) {
      _navigateToHome();
    }
  }

  /// Animation lettre-par-lettre avec timing dynamique
  Future<void> _animateTyping() async {
    final duration = _calculateTypingDuration();
    
    return Future<void>((resolve) {
      _typingTimer = Timer.periodic(
        Duration(milliseconds: duration),
        (timer) {
          if (_currentIndex < widget.userName.length) {
            setState(() {
              _displayedName =
                  widget.userName.substring(0, _currentIndex + 1);
              _currentIndex++;
            });
          } else {
            timer.cancel();
            _typingTimer = null;
            resolve();
          }
        },
      );
    });
  }

  /// Calcule la durée entre chaque lettre
  /// Accélère pour les noms longs
  int _calculateTypingDuration() {
    if (widget.userName.length > 12) {
      return 100; // Plus rapide pour les longs noms
    } else if (widget.userName.length > 8) {
      return 120;
    }
    return 150; // Vitesse normale
  }

  /// Navigation vers HomeScreen avec sauvegarde du flag
  Future<void> _navigateToHome() async {
    try {
      // Récupérer le provider et marquer la bienvenue comme vue
      if (mounted) {
        final themeProvider =
            context.read<DynamicTheme>();
        await themeProvider.markWelcomeAsSeen();
      }

      // Navigation avec transition
      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      debugPrint('Error navigating to home: $e');
      // Fallback: naviguer quand même
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }

  /// Permet de passer l'animation avec un tap
  void _skipAnimation() async {
    _typingTimer?.cancel();
    _phase = 3;
    await _navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 600;

    return Scaffold(
      body: GestureDetector(
        onTap: _skipAnimation,
        child: AnimatedBuilder(
          animation: _gradientController,
          builder: (context, child) {
            // Gradient rotataif dynamique
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _interpolateColor(
                      Colors.blue.shade100,
                      Colors.purple.shade100,
                      _gradientController.value,
                    ),
                    _interpolateColor(
                      Colors.cyan.shade100,
                      Colors.pink.shade100,
                      _gradientController.value,
                    ),
                  ],
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 24 : 48),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Phase 0 & 1: Message d'accueil
                        FadeTransition(
                          opacity: _fadeController,
                          child: _buildGreetingMessage(),
                        ),
                        SizedBox(height: isMobile ? 40 : 60),

                        // Phase 1 & 2: Typing Animation
                        if (_phase >= 1) _buildTypingAnimation(isMobile),

                        // Phase 2: Messages de completion
                        if (_isTypingComplete && _phase >= 2)
                          ScaleTransition(
                            scale: _scaleController,
                            child: _buildCompletionMessage(),
                          ),

                        // Phase 3: Skip hint
                        if (_phase < 3)
                          Padding(
                            padding: EdgeInsets.only(
                              top: isMobile ? 60 : 80,
                            ),
                            child: _buildSkipHint(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Message de bienvenue initial
  Widget _buildGreetingMessage() {
    return Column(
      children: [
        Text(
          '🎯',
          style: TextStyle(
            fontSize: 60,
            height: 1,
          ),
        ),
        SizedBox(height: 24),
        Text(
          'Bienvenue...',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w300,
            color: Colors.grey.shade700,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Ce thème a été créé\npour TOI',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w400,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  /// Animation lettre-par-lettre avec curseur clignotant
  Widget _buildTypingAnimation(bool isMobile) {
    return Column(
      children: [
        // Texte du prénom
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 32,
            vertical: isMobile ? 20 : 32,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withOpacity(0.7),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _displayedName,
                style: TextStyle(
                  fontSize: isMobile ? 48 : 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                  letterSpacing: 2,
                  fontFamily: 'monospace',
                ),
              ),
              // Curseur clignotant
              if (!_isTypingComplete && _showCursor)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: AnimatedBuilder(
                    animation: _scaleController,
                    builder: (context, child) {
                      return Text(
                        '|',
                        style: TextStyle(
                          fontSize: isMobile ? 48 : 72,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                          animation: _scaleController,
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 24),

        // Sous-titre pendant l'animation
        if (!_isTypingComplete)
          Text(
            'C\'est ton nom unique',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),

        // Particules à la fin de l'animation
        if (_isTypingComplete)
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: ParticleAnimationWidget(
              widget.userName,
            ),
          ),
      ],
    );
  }

  /// Messages après l'animation
  Widget _buildCompletionMessage() {
    return Column(
      children: [
        Text(
          'Ravi de te connaître,',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Text(
          widget.userName,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
        ),
        SizedBox(height: 20),
        Text(
          '✓ Ton téléphone n\'a plus de jumeau',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  /// Hint pour passer l'animation
  Widget _buildSkipHint() {
    return GestureDetector(
      onTap: _skipAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade400,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.5),
        ),
        child: Text(
          'Appuyer pour passer',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  /// Interpole entre deux couleurs (pour gradient animé)
  Color _interpolateColor(
    Color startColor,
    Color endColor,
    double t,
  ) {
    final Color mid1 = Color.lerp(startColor, endColor, t) ?? startColor;
    final Color mid2 = Color.lerp(endColor, startColor, t) ?? endColor;
    return Color.lerp(mid1, mid2, (sin(t * pi) + 1) / 2) ?? startColor;
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    _cursorTimer.cancel();
    _gradientController.dispose();
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
}
