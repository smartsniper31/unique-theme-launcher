import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'dart:async';
import '../widgets/name_animations.dart';

/// 🎭 Provider pour gérer l'état du prénom vivant
/// 
/// Responsabilités:
/// - Écouter l'heure (DateTime)
/// - Écouter la batterie (Battery)
/// - Calculer l'état approprié selon les conditions
/// - Notifier les widgets des changements d'état
class LivingNameProvider extends ChangeNotifier {
  // État
  LivingNameState _currentState = LivingNameState.energetic;
  LivingNameState get currentState => _currentState;

  // Context data
  int _currentHour = 12;
  double _currentBatteryLevel = 0.5;
  int _screenTimeMinutes = 0;
  bool _isFirstUnlockToday = true;
  bool _isBirthday = false;
  DateTime? _lastStateChangeTime;

  // Listeners
  late Timer _hourCheckTimer;
  StreamSubscription<int>? _batterySubscription;
  StreamSubscription<BatteryState>? _batteryStateSubscription;

  LivingNameProvider() {
    _initializeListeners();
    _updateState();
  }

  /// Initialiser les listeners pour batterie et heure
  void _initializeListeners() {
    // Listener de batterie
    _setupBatteryListeners();

    // Timer pour vérifier l'heure et l'usage toutes les minutes
    _hourCheckTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _updateState(),
    );
  }

  /// Configurer les listeners de batterie
  void _setupBatteryListeners() {
    final battery = Battery();

    // Écouter les changements d'état de batterie
    _batteryStateSubscription = battery.onBatteryStateChanged.listen(
      (_) async {
        final level = await battery.batteryLevel;
        updateBatteryLevel(level / 100.0);
      },
    );
  }

  /// Mettre à jour le niveau de batterie
  void updateBatteryLevel(double level) {
    _currentBatteryLevel = level.clamp(0.0, 1.0);
    _updateState();
  }

  /// Mettre à jour l'heure actuelle
  void updateHour(int hour) {
    _currentHour = hour;
    _updateState();
  }

  /// Mettre à jour le temps d'écran
  void updateScreenTime(int minutes) {
    _screenTimeMinutes = minutes;
    _updateState();
  }

  /// Mettre à jour l'état du premier déverrouillage
  void setFirstUnlockToday(bool value) {
    _isFirstUnlockToday = value;
    _updateState();
  }

  /// Mettre à jour le statut anniversaire
  void setIsBirthday(bool value) {
    _isBirthday = value;
    _updateState();
  }

  /// Calculer le nouvel état et notifier si changement
  void _updateState() {
    final newState = _calculateState(
      hour: _currentHour,
      batteryLevel: _currentBatteryLevel,
      screenTimeMinutes: _screenTimeMinutes,
      isFirstUnlockToday: _isFirstUnlockToday,
      isBirthday: _isBirthday,
    );

    if (newState != _currentState) {
      _currentState = newState;
      _lastStateChangeTime = DateTime.now();
      debugPrint('🎭 LivingName state changed to: $newState');
      notifyListeners();
    }
  }

  /// 🧠 LOGIQUE DE CALCUL D'ÉTAT
  /// 
  /// Implémente l'algorithme de décision pour chaque état
  /// Les conditions sont vérifiées dans l'ordre de priorité:
  /// 1. Anniversaire → HAPPY
  /// 2. Batterie très basse → SAD
  /// 3. Batterie basse → HUNGRY
  /// 4. Usage intensif → TIRED
  /// 5. Heure de nuit → ASLEEP
  /// 6. Premier déverrouillage matin → WAKING
  /// 7. Soirée → PLAYFUL
  /// 8. Batterie haute + matin → ENERGETIC
  /// 9. Défaut → ENERGETIC
  LivingNameState _calculateState({
    required int hour,
    required double batteryLevel,
    required int screenTimeMinutes,
    required bool isFirstUnlockToday,
    required bool isBirthday,
  }) {
    // 1️⃣ Anniversaire - Priorité maximale
    if (isBirthday) {
      return LivingNameState.happy;
    }

    // 2️⃣ Batterie très basse < 15%
    if (batteryLevel < 0.15) {
      return LivingNameState.sad;
    }

    // 3️⃣ Batterie basse 15-20%
    if (batteryLevel < 0.20) {
      return LivingNameState.hungry;
    }

    // 4️⃣ Usage intensif > 120 minutes (2h)
    if (screenTimeMinutes > 120) {
      return LivingNameState.tired;
    }

    // 5️⃣ Nuit: 22h-6h → ENDORMI 😴
    if (hour >= 22 || hour < 6) {
      return LivingNameState.asleep;
    }

    // 6️⃣ Réveil: Premier déverrouillage 6h-10h → RÉVEIL ☀️
    if (isFirstUnlockToday && hour >= 6 && hour < 10) {
      return LivingNameState.waking;
    }

    // 7️⃣ Soirée: 18h-22h → JOUEUR 😏
    if (hour >= 18 && hour < 22) {
      return LivingNameState.playful;
    }

    // 8️⃣ Matin avec batterie haute: 6h-12h + batterie > 50% → ÉNERGIQUE ⚡
    if (hour >= 6 && hour < 12 && batteryLevel > 0.5) {
      return LivingNameState.energetic;
    }

    // 9️⃣ Défaut
    return LivingNameState.energetic;
  }

  /// Obtenir les conditions actuelles (pour debug/testing)
  Map<String, dynamic> getCurrentConditions() {
    return {
      'hour': _currentHour,
      'batteryLevel': (_currentBatteryLevel * 100).toStringAsFixed(1) + '%',
      'screenTimeMinutes': _screenTimeMinutes,
      'isFirstUnlockToday': _isFirstUnlockToday,
      'isBirthday': _isBirthday,
      'currentState': _currentState.toString(),
      'stateChangedAt': _lastStateChangeTime?.toString(),
    };
  }

  @override
  void dispose() {
    _hourCheckTimer.cancel();
    _batterySubscription?.cancel();
    _batteryStateSubscription?.cancel();
    super.dispose();
  }
}

/// 🛠️ Extension utilitaire pour Parser LivingNameState
extension LivingNameStateExtension on LivingNameState {
  /// Obtenir l'emoji correspondant à l'état
  String get emoji {
    switch (this) {
      case LivingNameState.asleep:
        return '😴';
      case LivingNameState.waking:
        return '☀️';
      case LivingNameState.energetic:
        return '⚡';
      case LivingNameState.tired:
        return '😫';
      case LivingNameState.happy:
        return '🎉';
      case LivingNameState.sad:
        return '😢';
      case LivingNameState.hungry:
        return '🔋';
      case LivingNameState.playful:
        return '😏';
    }
  }

  /// Obtenir la description de l'état
  String get label {
    switch (this) {
      case LivingNameState.asleep:
        return 'Endormi';
      case LivingNameState.waking:
        return 'Réveil';
      case LivingNameState.energetic:
        return 'Énergique';
      case LivingNameState.tired:
        return 'Fatigué';
      case LivingNameState.happy:
        return 'Heureux';
      case LivingNameState.sad:
        return 'Triste';
      case LivingNameState.hungry:
        return 'Affamé';
      case LivingNameState.playful:
        return 'Joueur';
    }
  }

  /// Obtenir la couleur recommandée pour l'état
  Color getColor() {
    switch (this) {
      case LivingNameState.asleep:
        return Colors.indigo.shade700;
      case LivingNameState.waking:
        return Colors.amber;
      case LivingNameState.energetic:
        return Colors.green;
      case LivingNameState.tired:
        return Colors.orange;
      case LivingNameState.happy:
        return Colors.pink;
      case LivingNameState.sad:
        return Colors.blue;
      case LivingNameState.hungry:
        return Colors.orange.shade700;
      case LivingNameState.playful:
        return Colors.purple;
    }
  }
}
