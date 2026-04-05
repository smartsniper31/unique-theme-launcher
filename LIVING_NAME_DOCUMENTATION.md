# 🎭 Système Living Name - Documentation Complète

## 📋 Vue d'ensemble

Le système **Living Name** transforme le prénom de l'utilisateur en un **personnage vivant** qui réagit aux conditions du téléphone et du moment de la journée. Le prénom n'est plus un simple texte statique - il gagne en émotion, en vie, en magie.

### ✨ La Vision

> "Mon prénom n'est pas juste écrit. Il VIT. Le matin il se réveille, le soir il est fatigué, quand la batterie est faible il a faim. C'est MAGIQUE. Personne n'a ça."

---

## 🎭 Les 8 États du Prénom

### 1. 😴 **ENDORMI** (Asleep)
- **Condition**: 22h-6h
- **Animation**: Le prénom oscille doucement (respiration), opacité réduite
- **Sentiment**: Paix, Sommeil
- **Couleur**: Indigo foncé

```
Animation: Breath effect + opacity pulse
Duration: 3s loop
```

### 2. ☀️ **RÉVEIL** (Waking)
- **Condition**: Premier déverrouillage du jour (6h-10h)
- **Animation**: Le texte passe de flou à clair, rotation légère élastique
- **Sentiment**: Éveil, Nouvelle journée
- **Couleur**: Amber

```
Animation: Blur fade out + elastic rotation
Duration: 2s once
```

### 3. ⚡ **ÉNERGIQUE** (Energetic)
- **Condition**: Batterie > 50% + Matin (6h-12h)
- **Animation**: Le prénom saute (bounce), lueur autour (glow)
- **Sentiment**: Énergie, Vitalité
- **Couleur**: Vert

```
Animation: Bounce up + glow pulse
Duration: 600ms loop
```

### 4. 😫 **FATIGUÉ** (Tired)
- **Condition**: Usage intensif (>2h d'écran)
- **Animation**: Le texte penché légèrement, opacité réduite
- **Sentiment**: Lassitude, Fatigue
- **Couleur**: Orange

```
Animation: Tilt effect + opacity reduction
Duration: 2s loop
```

### 5. 🎉 **HEUREUX** (Happy)
- **Condition**: Anniversaire
- **Animation**: Le prénom tourne double, scale pulse (gonfle/dégonfle)
- **Sentiment**: Joie, Célébration
- **Couleur**: Rose

```
Animation: Spin + scale pulse
Duration: 2s loop
```

### 6. 😢 **TRISTE** (Sad)
- **Condition**: Batterie < 15%
- **Animation**: Le texte s'affaisse (translate down), opacité très réduite
- **Sentiment**: Urgence, Danger
- **Couleur**: Bleu

```
Animation: Drop effect + fade
Duration: 2s loop
```

### 7. 🔋 **AFFAMÉ** (Hungry)
- **Condition**: Batterie 15-20%
- **Animation**: Le prénom pulse rapidement (respiration rapide)
- **Sentiment**: Urgence douce, Besoin
- **Couleur**: Orange foncé

```
Animation: Quick pulse scale
Duration: 800ms loop
```

### 8. 😏 **JOUEUR** (Playful)
- **Condition**: Soirée (18h-22h)
- **Animation**: Le prénom cligne, rotation légère 3D wink effect
- **Sentiment**: Espièglerie, Plaisir
- **Couleur**: Violet

```
Animation: Wink effect + subtle 3D rotation
Duration: 500ms loop
```

---

## 📁 Architecture des Fichiers

### **Core Files**

```
lib/
├── presentation/
│   ├── widgets/
│   │   ├── living_name.dart          ✨ Widget principal
│   │   └── name_animations.dart      🎬 8 animations
│   ├── providers/
│   │   └── living_name_provider.dart 🧠 Logique d'état
│   └── screens/
│       └── home_screen.dart          📝 Intégration
├── main.dart                         ⚙️ Initialisation
└── test/
    └── living_name_test.dart         ✅ Tests
```

---

## 🔧 Configuration et Utilisation

### 1. **main.dart** - Initialisation

Le provider doit être ajouté au MultiProvider:

```dart
runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => DynamicTheme(profile!, storage)),
      ChangeNotifierProvider(create: (_) => LivingNameProvider()), // ✨ Living Name
    ],
    child: DynamicThemeApp(profile: profile!),
  ),
);
```

### 2. **home_screen.dart** - Utilisation

Le widget `LivingName` remplace le titre simple dans l'AppBar:

```dart
AppBar(
  title: LivingName(
    name: theme.userName,        // Prénom depuis le profil
    color: Colors.white,         // Couleur
    fontSize: theme.fontSize,    // Taille
    padding: const EdgeInsets.symmetric(vertical: 8),
  ),
  backgroundColor: theme.primaryColor,
  elevation: 0,
  centerTitle: true,
)
```

### 3. **Utilisation Standard (avec Provider)**

```dart
// Le widget LivingName lit automatiquement du provider
LivingName(
  name: "Alice",
  color: Colors.blue,
  fontSize: 48,
  onStateChanged: (newState) {
    print('État changé: $newState');
  },
)
```

### 4. **Utilisation Statique (sans Provider)**

```dart
// Pour tester ou utiliser hors du contexte provider
LivingNameStatic(
  name: "Alice",
  state: LivingNameState.energetic,
  color: Colors.blue,
  fontSize: 48,
)
```

---

## 🧠 Logique de Calcul d'État

La priorité des états (dans l'ordre d'évaluation):

```
1. Anniversaire? → HAPPY 🎉
2. Batterie < 15%? → SAD 😢
3. Batterie < 20%? → HUNGRY 🔋
4. Usage > 2h? → TIRED 😫
5. Heure 22h-6h? → ASLEEP 😴
6. Premier unlock 6h-10h? → WAKING ☀️
7. Heure 18h-22h? → PLAYFUL 😏
8. Heure 6h-12h + Batterie > 50%? → ENERGETIC ⚡
9. Défaut → ENERGETIC ⚡
```

### Code de Calcul

```dart
LivingNameState _calculateState({
  required int hour,
  required double batteryLevel,
  required int screenTimeMinutes,
  required bool isFirstUnlockToday,
  required bool isBirthday,
}) {
  // 1️⃣ Anniversaire - Priorité maximale
  if (isBirthday) return LivingNameState.happy;

  // 2️⃣ Batterie très basse < 15%
  if (batteryLevel < 0.15) return LivingNameState.sad;

  // 3️⃣ Batterie basse 15-20%
  if (batteryLevel < 0.20) return LivingNameState.hungry;

  // 4️⃣ Usage intensif > 120 minutes
  if (screenTimeMinutes > 120) return LivingNameState.tired;

  // 5️⃣ Nuit: 22h-6h
  if (hour >= 22 || hour < 6) return LivingNameState.asleep;

  // 6️⃣ Réveil: Premier déverrouillage 6h-10h
  if (isFirstUnlockToday && hour >= 6 && hour < 10) {
    return LivingNameState.waking;
  }

  // 7️⃣ Soirée: 18h-22h
  if (hour >= 18 && hour < 22) return LivingNameState.playful;

  // 8️⃣ Matin avec batterie haute: 6h-12h + batterie > 50%
  if (hour >= 6 && hour < 12 && batteryLevel > 0.5) {
    return LivingNameState.energetic;
  }

  // 9️⃣ Défaut
  return LivingNameState.energetic;
}
```

---

## 🎬 Détails des Animations

### **Asleep (😴)**
```dart
// Oscille comme une respiration
_breatheController = AnimationController(
  duration: Duration(seconds: 3),
  vsync: this,
)..repeat(reverse: true);

_breatheAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
  CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut),
);

// Applique opacity et translate
Opacity(opacity: 0.6 + (_breatheAnimation.value * 0.2))
Transform.translate(offset: Offset(0, -2 * _breatheAnimation.value))
```

### **Waking (☀️)**
```dart
// Blur → Clear + elastic rotation
_blurAnimation = Tween<double>(begin: 8.0, end: 0.0).animate(
  CurvedAnimation(parent: _blurController, curve: Curves.easeOut),
);

_rotationAnimation = Tween<double>(begin: -0.1, end: 0.0).animate(
  CurvedAnimation(parent: _rotationController, curve: Curves.elasticOut),
);

// Gradient shader pour l'émergence
ShaderMask(
  shaderCallback: (bounds) => LinearGradient(...).createShader(bounds),
  child: Transform.rotate(angle: _rotationAnimation.value, child: text),
)
```

### **Energetic (⚡)**
```dart
// Bounce + Glow
_bounceAnimation = Tween<double>(begin: 0, end: -15).animate(
  CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
);

_glowAnimation = Tween<double>(begin: 10, end: 30).animate(
  CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
);

// BoxShadow qui pulse
BoxShadow(
  color: color.withOpacity(0.6),
  blurRadius: _glowAnimation.value,
  spreadRadius: _glowAnimation.value * 0.5,
)
```

### **Tired (😫)**
```dart
// Tilt + Opacity
_tiltAnimation = Tween<double>(begin: 0.0, end: 0.08).animate(
  CurvedAnimation(parent: _tiltController, curve: Curves.easeInOut),
);

Transform.rotate(
  angle: _tiltAnimation.value,
  child: Opacity(opacity: 0.65, child: text),
)
```

### **Happy (🎉)**
```dart
// Spin + Scale pulse
_spinAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
  CurvedAnimation(parent: _spinController, curve: Curves.linear),
);

_scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
  CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
);

Transform.scale(
  scale: _scaleAnimation.value,
  child: Transform.rotate(angle: _spinAnimation.value, child: text),
)
```

### **Sad (😢)**
```dart
// Drop effect
_dropAnimation = Tween<double>(begin: 0, end: 1).animate(
  CurvedAnimation(parent: _dropController, curve: Curves.easeInOut),
);

Transform.translate(
  offset: Offset(0, 8 * _dropAnimation.value),
  child: Opacity(opacity: 0.7, child: text),
)
```

### **Hungry (🔋)**
```dart
// Quick pulse
_pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
  CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
);

Transform.scale(
  scale: _pulseAnimation.value,
  child: text,
)
```

### **Playful (😏)**
```dart
// Wink + 3D rotation
Transform(
  alignment: Alignment.center,
  transform: Matrix4.identity()
    ..setEntry(3, 2, 0.001)
    ..rotateY(0.05 * _winkAnimation.value),
  child: text,
)
```

---

## 📊 API du Provider

### **Méthodes**

```dart
// Mise à jour des conditions
void updateBatteryLevel(double level);
void updateHour(int hour);
void updateScreenTime(int minutes);
void setFirstUnlockToday(bool value);
void setIsBirthday(bool value);

// Getter
LivingNameState get currentState;

// Debug
Map<String, dynamic> getCurrentConditions();
```

### **Listeners**

Le provider est automatiquement écouté par le widget `LivingName`:

```dart
Consumer<LivingNameProvider>(
  builder: (context, provider, _) {
    final state = provider.currentState;
    // Reconstruire le widget
  },
)
```

---

## 🧪 Tests

### Exécuter les tests

```bash
flutter test test/living_name_test.dart
```

### Couverture des tests

- ✅ Calcul d'état pour chaque condition
- ✅ Priorité des états
- ✅ Notifications de changement
- ✅ Extensions et getters
- ✅ Construction des animations

### Exemple de test

```dart
test('Should return ASLEEP state between 22h and 6h', () {
  provider.updateHour(23);
  expect(provider.currentState, LivingNameState.asleep);

  provider.updateHour(5);
  expect(provider.currentState, LivingNameState.asleep);

  provider.updateHour(6);
  expect(provider.currentState, isNot(LivingNameState.asleep));
});
```

---

## 🔗 Extensions Utilitaires

### **LivingNameStateExtension**

Access helpers pour chaque état:

```dart
// Emoji
LivingNameState.happy.emoji; // "🎉"

// Label
LivingNameState.tired.label; // "Fatigué"

// Couleur recommandée
LivingNameState.energetic.getColor(); // Colors.green
```

---

## 🎨 Customisation

### Modifier une animation

Tous les fichiers d'animation sont dans `name_animations.dart`. Chaque état a sa propre classe:

```dart
class _EnergeticAnimationWidgetState extends State<_EnergeticAnimationWidget>
    with TickerProviderStateMixin {
  
  @override
  void initState() {
    super.initState();
    // Personnaliser:
    // - Duration
    // - Tween values
    // - Curve
    // - BoxShadow
  }
}
```

### Ajouter un nouvel état

1. Ajouter l'enum: `LivingNameState { newState }`
2. Créer la classe: `class NewStateAnimation extends NameAnimationBuilder`
3. Implémenter le widget d'animation
4. Ajouter la logique dans `_calculateState()`
5. Ajouter les tests

---

## 🐛 Débogage

### Afficher l'état actuel

```dart
final provider = context.read<LivingNameProvider>();
print(provider.getCurrentConditions());
```

Output:
```
{
  'hour': 8,
  'batteryLevel': '75.5%',
  'screenTimeMinutes': 45,
  'isFirstUnlockToday': true,
  'isBirthday': false,
  'currentState': LivingNameState.waking,
  'stateChangedAt': '2026-04-05 08:15:30.123456',
}
```

### Logs

Le provider loggue chaque changement d'état:

```
🎭 LivingName state changed to: LivingNameState.energetic
🎭 LivingName state changed to: LivingNameState.tired
🎭 LivingName state changed to: LivingNameState.playful
```

---

## ⚡ Optimisations de Performance

- **60 FPS**: Toutes les animations utilisent `AnimationController` avec `vsync`
- **Batterie**: Les listeners sont correctement disposés
- **Mémoire**: Pas de memory leaks avec `dispose()`
- **GPU**: Animations utilisant des propriétés optimisées (opacity, transform)

---

## 📱 Cas d'Utilisation

### Scénario 1: Matin Normal

```
6:30 AM - Battery 85% - First unlock of day
→ WAKING state ☀️
→ Animation: Blur fade out + elastic rotation
→ Message: "Éveil, Alice. Le monde t'attend."
```

### Scénario 2: Soir Fatigué

```
9 PM - Battery 45% - 3h screen time
→ TIRED state 😫
→ Animation: Tilt + opacity reduction
→ Message: "Repos, Alice. Ta signature demeure."
```

### Scénario 3: Batterie Critique

```
11 PM - Battery 12% - Trying to keep using phone
→ SAD state 😢
→ Animation: Drop effect
→ Message: "Recharge, Alice. Tu es presque au repos."
```

### Scénario 4: Joyeuse Célébration

```
March 27 - Birthday - Any time
→ HAPPY state 🎉
→ Animation: Spin + scale pulse
→ Message: "Festivité, Alice. C'est TON jour."
```

---

## 🔄 Intégration avec d'autres Providers

Le `LivingNameProvider` est **indépendant** mais peut être combiné avec:

- `DynamicTheme`: Pour les couleurs et le nom
- `Battery`: Automatiquement écouté
- Détecteur d'heure: Timer interne

---

## 📝 Checklist d'Implémentation

- [x] `living_name.dart` - Widget principal avec Consumer
- [x] `living_name_static.dart` - Version sans provider
- [x] `name_animations.dart` - 8 animations complètes
- [x] `living_name_provider.dart` - Logique d'état
- [x] `main.dart` - Initialisation MultiProvider
- [x] `home_screen.dart` - Intégration dans AppBar
- [x] Tests unitaires - Couverture complète
- [x] Documentation - Ce fichier

---

## 🚀 Déploiement

### Vérifications avant publication

```bash
# Tests
flutter test test/living_name_test.dart

# Linting
flutter analyze

# Build
flutter build apk   # ou iOS

# Performance check
flutter run --profile
```

### Monitoring en Production

- Écouter les logs pour les changements d'état
- Vérifier pas de memory leak avec DevTools
- Optimizer les animations si performance dégradée

---

## 🎯 Résultat Attendu

L'utilisateur doit ressentir une **connexion émotionnelle** avec son téléphone:

> "Mon prénom n'est pas juste écrit. Il VIT."

Chaque moment du jour, chaque situation de batterie, crée une **nouvelle expérience** où le prénom réagit comme un être vivant.

C'est **MAGIQUE**. 🎭✨

---

## 📚 Ressources Supplémentaires

- [Flutter Animation Documentation](https://docs.flutter.dev/ui/animations)
- [Provider Documentation](https://pub.dev/packages/provider)
- [Battery Plus Documentation](https://pub.dev/packages/battery_plus)
- [Code du Projet](../lib/presentation/)

---

**Version**: 1.0.0  
**Last Updated**: 2026-04-05  
**Author**: Development Team

