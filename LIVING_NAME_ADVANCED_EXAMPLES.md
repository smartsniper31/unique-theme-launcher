# 🎭 Living Name - Exemples Avancés

## Cas d'Utilisation Avancés et Patterns

### 1️⃣ Intégration avec Animations Personnalisées

```dart
// Dans un widget custom
class UserGreetingCard extends StatelessWidget {
  final String userName;
  final Color primaryColor;

  const UserGreetingCard({
    required this.userName,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LivingNameProvider>(
      builder: (context, provider, _) {
        final state = provider.currentState;
        
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryColor.withOpacity(0.1),
                state.getColor().withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              LivingName(
                name: userName,
                color: primaryColor,
                fontSize: 48,
              ),
              const SizedBox(height: 16),
              Text(
                "État: ${state.label}",
                style: TextStyle(
                  color: state.getColor(),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

### 2️⃣ État Personnalisé avec Notification

```dart
class LivingNameNotificationWidget extends StatefulWidget {
  final String name;
  final Color color;

  const LivingNameNotificationWidget({
    required this.name,
    required this.color,
  });

  @override
  State<LivingNameNotificationWidget> createState() =>
      _LivingNameNotificationWidgetState();
}

class _LivingNameNotificationWidgetState
    extends State<LivingNameNotificationWidget> {
  LivingNameState? _lastState;

  @override
  Widget build(BuildContext context) {
    return Consumer<LivingNameProvider>(
      builder: (context, provider, _) {
        // Notifier si état change
        if (_lastState != provider.currentState && _lastState != null) {
          _showStateChangeNotification(
            provider.currentState,
            context,
          );
        }
        _lastState = provider.currentState;

        return LivingName(
          name: widget.name,
          color: widget.color,
        );
      },
    );
  }

  void _showStateChangeNotification(
    LivingNameState newState,
    BuildContext context,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.name} est maintenant ${newState.label} ${newState.emoji}',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
```

### 3️⃣ Contrôle Manuel d'État (Testing)

```dart
class LiveNameDebugPanel extends StatelessWidget {
  const LiveNameDebugPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LivingNameProvider>(
      builder: (context, provider, _) {
        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contrôle d\'État (Debug)',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                // Heures rapides
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => provider.updateHour(2),
                      icon: const Icon(Icons.dark_mode),
                      label: const Text('🌙 2h'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => provider.updateHour(7),
                      icon: const Icon(Icons.light_mode),
                      label: const Text('☀️ 7h'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => provider.updateHour(14),
                      icon: const Icon(Icons.wb_sunny),
                      label: const Text('☀️ 14h'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => provider.updateHour(20),
                      icon: const Icon(Icons.night_stay),
                      label: const Text('🌙 20h'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Batterie rapide
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => provider.updateBatteryLevel(0.10),
                      icon: const Icon(Icons.battery_0_bar),
                      label: const Text('10%'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => provider.updateBatteryLevel(0.30),
                      icon: const Icon(Icons.battery_3_bar),
                      label: const Text('30%'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => provider.updateBatteryLevel(0.75),
                      icon: const Icon(Icons.battery_6_bar),
                      label: const Text('75%'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => provider.updateBatteryLevel(1.0),
                      icon: const Icon(Icons.battery_charging_full),
                      label: const Text('100%'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Autres
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () => provider.setIsBirthday(true),
                      child: const Text('🎉 Anniversaire'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          provider.updateScreenTime(150),
                      child: const Text('😫 Fatigué'),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          provider.setFirstUnlockToday(true),
                      child: const Text('☀️ Premier unlock'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Conditions actuelles
                _buildConditionsDisplay(provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildConditionsDisplay(LivingNameProvider provider) {
    final conditions = provider.getCurrentConditions();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Conditions Actuelles',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...conditions.entries.map(
          (e) => Text(
            '${e.key}: ${e.value}',
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
      ],
    );
  }
}
```

### 4️⃣ Intégration avec Hive (Persistance)

```dart
// model/living_name_history.dart
class LivingNameHistory {
  final DateTime timestamp;
  final String state;
  final int hour;
  final double batteryLevel;

  LivingNameHistory({
    required this.timestamp,
    required this.state,
    required this.hour,
    required this.batteryLevel,
  });

  Map<String, dynamic> toMap() => {
    'timestamp': timestamp.toIso8601String(),
    'state': state,
    'hour': hour,
    'batteryLevel': batteryLevel,
  };
}

// provider/living_name_history_provider.dart
class LivingNameHistoryProvider extends ChangeNotifier {
  final Box<LivingNameHistory> historyBox;
  
  LivingNameHistoryProvider(this.historyBox);

  List<LivingNameHistory> get history => historyBox.values.toList();

  void recordStateChange(
    LivingNameState state,
    int hour,
    double batteryLevel,
  ) {
    final record = LivingNameHistory(
      timestamp: DateTime.now(),
      state: state.toString(),
      hour: hour,
      batteryLevel: batteryLevel,
    );
    historyBox.add(record);
    notifyListeners();
  }

  void clearHistory() {
    historyBox.clear();
    notifyListeners();
  }
}
```

### 5️⃣ Stats et Analytics

```dart
class LivingNameStatsWidget extends StatelessWidget {
  const LivingNameStatsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistiques de l\'État',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Consumer<LivingNameProvider>(
            builder: (context, provider, _) {
              final conditions = provider.getCurrentConditions();
              
              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                children: [
                  _buildStatCard(
                    icon: Icons.schedule,
                    label: 'Heure',
                    value: '${conditions['hour']}h',
                  ),
                  _buildStatCard(
                    icon: Icons.battery_full,
                    label: 'Batterie',
                    value: conditions['batteryLevel'],
                  ),
                  _buildStatCard(
                    icon: Icons.screen_time,
                    label: 'Écran',
                    value: '${conditions['screenTimeMinutes']}min',
                  ),
                  _buildStatCard(
                    icon: Icons.sentiment_satisfied,
                    label: 'État',
                    value: provider.currentState.label,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
```

### 6️⃣ Animation d'Entrée pour le Premier Lancement

```dart
class LivingNameWelcomeAnimation extends StatefulWidget {
  final String name;
  final Color color;
  final VoidCallback onAnimationComplete;

  const LivingNameWelcomeAnimation({
    required this.name,
    required this.color,
    required this.onAnimationComplete,
  });

  @override
  State<LivingNameWelcomeAnimation> createState() =>
      _LivingNameWelcomeAnimationState();
}

class _LivingNameWelcomeAnimationState
    extends State<LivingNameWelcomeAnimation>
    with TickerProviderStateMixin {
  late AnimationController _firstEntranceController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _firstEntranceController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _firstEntranceController, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _firstEntranceController, curve: Curves.easeIn),
    );

    _firstEntranceController.forward().then((_) {
      widget.onAnimationComplete();
    });
  }

  @override
  void dispose() {
    _firstEntranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _opacityAnimation]),
      builder: (context, _) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: LivingName(
              name: widget.name,
              color: widget.color,
              fontSize: 64,
            ),
          ),
        );
      },
    );
  }
}

// Utilisation
LivingNameWelcomeAnimation(
  name: "Alice",
  color: Colors.blue,
  onAnimationComplete: () {
    // Continuer vers l'app
    Navigator.of(context).pushReplacementNamed('/home');
  },
)
```

### 7️⃣ Intégration avec Transitions

```dart
class LivingNameTransitionPage extends Page {
  final String name;
  final Color color;

  LivingNameTransitionPage({
    required this.name,
    required this.color,
  }) : super(key: ValueKey(name));

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          appBar: AppBar(
            title: LivingName(
              name: name,
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          body: const Center(child: Text('Page avec Living Name')),
        );
      },
    );
  }
}
```

### 8️⃣ Test d'Intégration

```dart
// test/living_name_integration_test.dart
void main() {
  testWidgets('Living Name integration test', (WidgetTester tester) async {
    final testProvider = LivingNameProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: testProvider,
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: LivingName(
                name: 'TestName',
                color: Colors.blue,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );

    // Vérifier le rendu initial
    expect(find.text('TestName'), findsOneWidget);

    // Simuler un changement d'état
    testProvider.updateBatteryLevel(0.10);
    await tester.pumpAndSettle();

    // Vérifier que le widget s'est reconstruit
    expect(find.byType(LivingName), findsOneWidget);

    // Vérifier les conditions
    final conditions = testProvider.getCurrentConditions();
    expect(conditions['currentState'], LivingNameState.sad.toString());
  });
}
```

---

## 📋 Patterns Recommandés

### ✅ BON: Utiliser Consumer pour écouter

```dart
Consumer<LivingNameProvider>(
  builder: (context, provider, _) {
    return LivingName(
      name: userName,
      color: provider.currentState.getColor(),
    );
  },
)
```

### ❌ MAUVAIS: Accéder directement sans Consumer

```dart
final provider = LivingNameProvider(); // NON! Crée une nouvelle instance
LivingName(name: userName)
```

### ✅ BON: Disposer correctement

```dart
@override
void dispose() {
  _provider.dispose(); // Libère les ressources
  super.dispose();
}
```

### ❌ MAUVAIS: Oublier dispose

```dart
@override
void dispose() {
  super.dispose(); // La batterie continue à écouter!
}
```

---

## 🚀 Performance Tips

1. **Éviter les rebuilds inutiles**: Utiliser `Consumer` au niveau le plus profond possible
2. **Optimiser les animations**: Préférer `Stream` à `Timer` pour les mises à jour
3. **Tester en profile**: `flutter run --profile` pour vérifier les performances
4. **Monitorer la batterie**: Les listeners de batterie consomment des ressources

---

**Version**: 1.0.0  
**Last Updated**: 2026-04-05

