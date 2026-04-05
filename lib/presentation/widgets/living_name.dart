import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'name_animations.dart';
import '../providers/living_name_provider.dart';

/// 🎭 Le prénom VIVANT - Widget principal
/// 
/// Affiche le prénom de l'utilisateur avec une animation
/// qui change selon l'état (endormi, énergique, fatigué, etc.)
class LivingName extends StatelessWidget {
  /// Le prénom à afficher
  final String name;

  /// État actuel du prénom (géré automatiquement si null)
  final LivingNameState? overrideState;

  /// Taille de la police
  final double fontSize;

  /// Couleur du prénom
  final Color color;

  /// Padding autour du widget
  final EdgeInsets padding;

  /// Callback quand l'état change
  final void Function(LivingNameState)? onStateChanged;

  const LivingName({
    Key? key,
    required this.name,
    this.overrideState,
    this.fontSize = 48,
    required this.color,
    this.padding = const EdgeInsets.all(0),
    this.onStateChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Écouter les changements du provider
    return Consumer<LivingNameProvider>(
      builder: (context, provider, _) {
        final currentState = overrideState ?? provider.currentState;

        // Callback quand l'état change
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onStateChanged?.call(currentState);
        });

        final animationBuilder = getAnimationBuilder(currentState);

        return Padding(
          padding: padding,
          child: Tooltip(
            message: 'État: ${animationBuilder.stateLabel}',
            child: animationBuilder.build(
              context,
              name,
              color,
              fontSize,
            ),
          ),
        );
      },
    );
  }
}

/// 🎭 Widget lite - Sans Consumer (pour les cas où on veut gérer l'état externalement)
class LivingNameStatic extends StatelessWidget {
  final String name;
  final LivingNameState state;
  final double fontSize;
  final Color color;
  final EdgeInsets padding;

  const LivingNameStatic({
    Key? key,
    required this.name,
    required this.state,
    this.fontSize = 48,
    required this.color,
    this.padding = const EdgeInsets.all(0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animationBuilder = getAnimationBuilder(state);

    return Padding(
      padding: padding,
      child: Tooltip(
        message: 'État: ${animationBuilder.stateLabel}',
        child: animationBuilder.build(
          context,
          name,
          color,
          fontSize,
        ),
      ),
    );
  }
}
