# 🚀 Living Name - Quick Start Guide

## 5 Minutes pour Activer la Magie

### 1. Vérifier les Fichiers Créés ✅

```
lib/
├── presentation/
│   ├── widgets/
│   │   ├── living_name.dart          ✨ NOUVEAU
│   │   └── name_animations.dart      ✨ NOUVEAU
│   ├── providers/
│   │   └── living_name_provider.dart ✨ NOUVEAU
│   └── screens/
│       └── home_screen.dart          📝 MODIFIÉ
├── main.dart                         ⚙️ MODIFIÉ
└── test/
    └── living_name_test.dart         ✨ NOUVEAU
```

### 2. Vérifier l'Initialisation ✅

**main.dart** doit avoir:

```dart
import 'presentation/providers/living_name_provider.dart';

runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => DynamicTheme(profile!, storage)),
      ChangeNotifierProvider(create: (_) => LivingNameProvider()),
    ],
    child: DynamicThemeApp(profile: profile!),
  ),
);
```

### 3. Vérifier l'Affichage ✅

**home_screen.dart** doit afficher le LivingName dans l'AppBar:

```dart
AppBar(
  title: LivingName(
    name: theme.userName,
    color: Colors.white,
    fontSize: theme.fontSize,
  ),
  backgroundColor: theme.primaryColor,
)
```

### 4. Lancer l'App 🎬

```bash
flutter pub get
flutter run
```

### 5. Observer la Magie ✨

- **6h-10h**: Le prénom se réveille (☀️)
- **6h-12h + Batterie > 50%**: Énergique et rayonnant (⚡)
- **18h-22h**: Joueur et espiègle (😏)
- **22h-6h**: Endormi et paisible (😴)
- **Batterie < 15%**: Triste et urgent (😢)
- **Usage > 2h**: Fatigué (😫)
- **15-20% batterie**: Affamé (🔋)
- **Anniversaire**: Heureux en permanence (🎉)

---

## 🎮 Tester les Estados

### Via le Debugging

Ajoute un bouton de test temporaire:

```dart
// Dans home_screen.dart
FloatingActionButton(
  onPressed: () {
    final provider = context.read<LivingNameProvider>();
    provider.updateBatteryLevel(0.10); // Teste SAD
    // ou
    provider.updateHour(23);           // Teste ASLEEP
    // ou
    provider.setIsBirthday(true);      // Teste HAPPY
  },
  child: const Icon(Icons.bug_report),
)
```

### Via les Tests

```bash
flutter test test/living_name_test.dart
```

---

## 📊 Comprendre les États

| État | Condition | Animation | Emoji |
|------|-----------|-----------|-------|
| ENDORMI | 22h-6h | Respire doucement | 😴 |
| RÉVEIL | Premier unlock 6h-10h | Émerge du flou | ☀️ |
| ÉNERGIQUE | Matin + Batterie > 50% | Saute brillant | ⚡ |
| FATIGUÉ | Usage > 2h | Penché ralenti | 😫 |
| HEUREUX | Anniversaire | Tourne joyeux | 🎉 |
| TRISTE | Batterie < 15% | S'affaisse | 😢 |
| AFFAMÉ | Batterie 15-20% | Pulse rapide | 🔋 |
| JOUEUR | Soirée 18h-22h | Cligne malicieux | 😏 |

---

## 🎨 Customiser l'Apparence

### Changer les Tailles

```dart
LivingName(
  name: "Alice",
  fontSize: 64,        // Défaut: 48
  color: Colors.blue,
)
```

### Changer les Couleurs

```dart
final nameProvider = context.read<LivingNameProvider>();
final state = nameProvider.currentState;
final stateColor = state.getColor(); // Couleur recommandée

LivingName(
  name: "Alice",
  color: stateColor,   // Adapte selon l'état!
)
```

### Écouter les Changements

```dart
LivingName(
  name: "Alice",
  color: Colors.blue,
  onStateChanged: (newState) {
    print('État changé: ${newState.label} ${newState.emoji}');
    // Déclencher une action
  },
)
```

---

## 🔧 Configuration Avancée

### Ajuster les Seuils de Batterie

Dans `living_name_provider.dart`, modifiez `_calculateState()`:

```dart
// Défaut: 15% = SAD
if (batteryLevel < 0.15) return LivingNameState.sad;

// Personnalisé: 25% = SAD
if (batteryLevel < 0.25) return LivingNameState.sad;
```

### Ajuster les Plages Horaires

```dart
// Défaut: 22h-6h = ASLEEP
if (hour >= 22 || hour < 6) return LivingNameState.asleep;

// Personnalisé: 23h-7h = ASLEEP
if (hour >= 23 || hour < 7) return LivingNameState.asleep;
```

### Ajouter des Conditions Custom

```dart
// Exemple: FESTIVAL si batterie > 80% ET heure party
if (batteryLevel > 0.80 && hour >= 20 && hour < 23) {
  return LivingNameState.happy; // Ou créer un nouvel état
}
```

---

## 🐛 Troubleshooting

### Le prénom ne change pas d'état

1. Vérifier que le provider est initialisé:
```bash
flutter run --verbose | grep "LivingName"
```

2. Vérifier que la batterie est écoutée:
```dart
final provider = context.read<LivingNameProvider>();
print(provider.getCurrentConditions());
```

### Animation sac-à-dos

1. Vérifier les temps d'animation dans `name_animations.dart`
2. Tester sur `--profile` mode:
```bash
flutter run --profile
```

### Widget ne se reconstruit pas

1. Vérifier que `LivingName` est dans un `Consumer<LivingNameProvider>`
2. Vérifier que `notifyListeners()` est appelé

---

## 📱 Intégration dans d'autres Widgets

### Dans une Card

```dart
Card(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: LivingName(
      name: userName,
      color: theme.primaryColor,
      fontSize: 32,
      padding: const EdgeInsets.symmetric(vertical: 8),
    ),
  ),
)
```

### Dans une Colonne

```dart
Column(
  children: [
    LivingName(
      name: "Alice",
      color: Colors.blue,
      fontSize: 48,
    ),
    const SizedBox(height: 16),
    Text("Serait heureux de te connaître"),
  ],
)
```

### Dans une Liste

```dart
ListView(
  children: [
    ListTile(
      title: LivingName(
        name: "Alice",
        color: Colors.blue,
        fontSize: 32,
      ),
      subtitle: Text("État: ${status.label}"),
    ),
  ],
)
```

---

## 🎯 Cas d'Usage Réels

### Cas 1: Écran de Accueil

```dart
AppBar(
  title: LivingName(
    name: theme.userName,
    color: Colors.white,
    fontSize: 24,
  ),
)
```

### Cas 2: Widget d'Information Utilisateur

```dart
Card(
  child: Column(
    children: [
      LivingName(
        name: user.name,
        color: theme.primaryColor,
        fontSize: 36,
      ),
      Divider(),
      Text("Email: ${user.email}"),
    ],
  ),
)
```

### Cas 3: Écran de Profil

```dart
CircleAvatar(
  radius: 60,
  child: LivingName(
    name: user.name,
    color: Colors.white,
    fontSize: 48,
  ),
)
```

---

## ✅ Code Complet Minimal

Pour tester rapidement:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/widgets/living_name.dart';
import 'presentation/providers/living_name_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LivingNameProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: LivingName(
            name: "Alice",
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        body: Center(
          child: Consumer<LivingNameProvider>(
            builder: (context, provider, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LivingName(
                    name: "Alice",
                    color: Colors.blue,
                    fontSize: 64,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "État: ${provider.currentState.label}",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    provider.currentState.emoji,
                    style: const TextStyle(fontSize: 48),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
```

---

## 🚀 Prochaines Étapes

1. ✅ Tester les 8 états
2. ✅ Observer les animations
3. ✅ Customizer les couleurs
4. ✅ Intégrer dans toute l'app
5. ✅ Monitorer la performance
6. ✅ Publier!

---

## 📞 Support

Pour des questions:
- Voir `LIVING_NAME_DOCUMENTATION.md` pour la documentation complète
- Exécuter les tests: `flutter test test/living_name_test.dart`
- Déboguer: Utiliser `provider.getCurrentConditions()` pour inspecter l'état

---

**Remember**: Le prénom n'est pas juste du texte. IL VIT. 🎭✨

