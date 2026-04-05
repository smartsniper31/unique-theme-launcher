#!/usr/bin/env markdown
# ✅ VÉRIFICATION D'INSTALLATION - Living Name System

## 🎯 Avant de Commencer

Cette liste de vérification s'assure que le système Living Name est correctement installé et fonctionnel.

Temps estimé: **5 minutes**

---

## ✅ ÉTAPE 1: Vérifier les Fichiers Créés

### Code Source

```bash
# Vérifier que les fichiers code existent
ls -la lib/presentation/widgets/living_name.dart
ls -la lib/presentation/widgets/name_animations.dart
ls -la lib/presentation/providers/living_name_provider.dart
```

**Résultat attendu**:
```
-rw-r--r--  user  group  living_name.dart
-rw-r--r--  user  group  name_animations.dart
-rw-r--r--  user  group  living_name_provider.dart
```

### Tests

```bash
# Vérifier que les tests existent
ls -la test/living_name_test.dart
```

**Résultat attendu**:
```
-rw-r--r--  user  group  living_name_test.dart
```

### Documentation

```bash
# Vérifier que la documentation existe
ls -la *.md | grep LIVING_NAME
```

**Résultat attendu**:
```
LIVING_NAME_INDEX.md
LIVING_NAME_QUICK_START.md
LIVING_NAME_DOCUMENTATION.md
LIVING_NAME_ADVANCED_EXAMPLES.md
LIVING_NAME_API_REFERENCE.md
LIVING_NAME_IMPLEMENTATION.md
README_LIVING_NAME.md
```

---

## ✅ ÉTAPE 2: Vérifier les Modifications

### main.dart

```bash
# Chercher MultiProvider
grep -n "MultiProvider" lib/main.dart
```

**Résultat attendu**:
```
Ligne N:  MultiProvider(
```

```bash
# Chercher LivingNameProvider
grep -n "LivingNameProvider" lib/main.dart
```

**Résultat attendu**:
```
Ligne M:  import 'presentation/providers/living_name_provider.dart';
Ligne P:  ChangeNotifierProvider(create: (_) => LivingNameProvider()),
```

### home_screen.dart

```bash
# Chercher LivingName widget
grep -n "LivingName" lib/presentation/screens/home_screen.dart
```

**Résultat attendu**:
```
Ligne X:  import 'package:unique_theme_launcher/presentation/widgets/living_name.dart';
Ligne Y:  LivingName(
Ligne Z:    name: theme.userName,
```

---

## ✅ ÉTAPE 3: Vérifier la Syntaxe

### Linting

```bash
flutter analyze
```

**Résultat attendu**:
```
✓ No issues found!
```

Si erreurs, installer les dépendances:
```bash
flutter pub get
```

---

## ✅ ÉTAPE 4: Exécuter les Tests

### Test Unitaires

```bash
flutter test test/living_name_test.dart
```

**Résultat attendu**:
```
✓ All tests passed
  31 tests ran successfully
```

Si erreur d'import, vérifier:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:unique_theme_launcher/presentation/providers/living_name_provider.dart';
import 'package:unique_theme_launcher/presentation/widgets/name_animations.dart';
```

### Couverture des Tests

```bash
flutter test test/living_name_test.dart --coverage
```

---

## ✅ ÉTAPE 5: Build et Run

### Build Clean

```bash
flutter clean
flutter pub get
```

### Exécuter L'App

```bash
flutter run
```

**Résultat attendu**:
- Pas d'erreurs de compilation
- L'app se lance normalement
- Le prénom s'affiche dans l'AppBar avec animation

### Vérifier l'Apparence

1. AppBar montre le prénom (pas "Unique Theme Launcher")
2. Le prénom a une animation (respire, bouge, etc.)
3. Pas d'erreur dans la console

---

## ✅ ÉTAPE 6: Vérifier les Animations

### Tester les États Manuellement

Ajouter temporairement un bouton de test:

```dart
// Dans home_screen.dart, ajouter:
FloatingActionButton(
  onPressed: () {
    final provider = context.read<LivingNameProvider>();
    // Test HAPPY
    provider.setIsBirthday(true);
    // Ou test TIRED
    // provider.updateScreenTime(150);
    // Ou test SAD
    // provider.updateBatteryLevel(0.10);
  },
  child: const Icon(Icons.emoji_emotions),
)
```

**Vérifier que**:
- ✅ Cliquer le bouton change l'animation
- ✅ Le prénom change de comportement
- ✅ L'emoji change
- ✅ Pas de lag ou saccade

### Vérifier les Logs

Dans la console, vous devez voir:

```
🎭 LivingName state changed to: LivingNameState.happy
```

---

## ✅ ÉTAPE 7: Vérifier la Documentation

### Accéder à la Documentation

```bash
# Vérifier les fichiers markdown
head -10 LIVING_NAME_QUICK_START.md
head -10 LIVING_NAME_DOCUMENTATION.md
head -10 LIVING_NAME_API_REFERENCE.md
```

**Résultat attendu**: Fichiers markdown lisibles avec contenu

### Vérifier les Liens

Les fichiers doivent contenir:
- ✅ Table des matières
- ✅ Exemples de code
- ✅ Troubleshooting
- ✅ API reference

---

## ✅ ÉTAPE 8: Vérifier les Performances

### Profile Mode

```bash
flutter run --profile
```

Vérifier dans DevTools:
- ✅ FPS stable (60 FPS)
- ✅ CPU < 10%
- ✅ Memory < 100 MB

### Release Build (Optional)

```bash
flutter build apk
```

ou iOS:
```bash
flutter build ios
```

---

## 🔍 TROUBLESHOOTING

### Erreur: "Unable to find package"

```bash
flutter pub get
flutter pub upgrade
```

### Erreur: "LivingNameProvider not found"

Vérifier l'import dans main.dart:
```dart
import 'presentation/providers/living_name_provider.dart';
```

### Erreur: "Widget not rendering"

Vérifier Consumer:
```dart
Consumer<LivingNameProvider>(
  builder: (context, provider, _) {
    return LivingName(...);
  },
)
```

### Animation saccade

Run en profile:
```bash
flutter run --profile
```

Si toujours saccade, vérifier:
- Animation duration dans name_animations.dart
- Autres animations actives

### Tests échouent

```bash
flutter test test/living_name_test.dart -v
```

Chercher le message d'erreur spécifique

---

## 📊 Checklist Complète

### Fichiers (4 + 2 modifiés = 6 fichiers)

- [ ] lib/presentation/widgets/living_name.dart (✨ créé)
- [ ] lib/presentation/widgets/name_animations.dart (✨ créé)
- [ ] lib/presentation/providers/living_name_provider.dart (✨ créé)
- [ ] test/living_name_test.dart (✨ créé)
- [ ] lib/main.dart (📝 modifié)
- [ ] lib/presentation/screens/home_screen.dart (📝 modifié)

### Documentation (7 fichiers)

- [ ] LIVING_NAME_INDEX.md
- [ ] LIVING_NAME_QUICK_START.md
- [ ] LIVING_NAME_DOCUMENTATION.md
- [ ] LIVING_NAME_ADVANCED_EXAMPLES.md
- [ ] LIVING_NAME_API_REFERENCE.md
- [ ] LIVING_NAME_IMPLEMENTATION.md
- [ ] README_LIVING_NAME.md

### Tests

- [ ] `flutter test test/living_name_test.dart` passe
- [ ] Tous les 28+ tests réussissent
- [ ] Pas d'erreurs dans la console

### Build & Run

- [ ] `flutter clean` OK
- [ ] `flutter pub get` OK
- [ ] `flutter analyze` OK
- [ ] `flutter run` OK
- [ ] L'app affiche le prénom animé

### Animations

- [ ] 😴 ASLEEP: Respiration visible
- [ ] ☀️ WAKING: Émerge du flou
- [ ] ⚡ ENERGETIC: Saute et brille
- [ ] 😫 TIRED: Penché
- [ ] 🎉 HAPPY: Tourne
- [ ] 😢 SAD: S'affaisse
- [ ] 🔋 HUNGRY: Pulse
- [ ] 😏 PLAYFUL: Cligne

### Performance

- [ ] 60 FPS fluide
- [ ] Pas de lag
- [ ] CPU < 10%
- [ ] Memory < 100 MB

---

## 🎯 Résultats Attendus

### À l'Ouverture de l'App

```
✓ App lance sans erreur
✓ Prénom visible dans l'AppBar
✓ Animation en cours (breathing effect)
✓ Console montre: 🎭 LivingName state changed to: ...
```

### Quand on Force un État (test)

```
✓ Animation change immédiatement
✓ Emoji change
✓ Console montre la transition
✓ Pas de lag ou saccade
```

### Dans la Console

```bash
✓ 🎭 LivingName state changed to: LivingNameState.waking
✓ 🎭 LivingName state changed to: LivingNameState.energetic
✓ No errors or warnings
```

---

## 🚀 Quoi Faire Après Vérification

Si ✅ TOUS les checks passent:

1. **Lire la documentation** → `LIVING_NAME_QUICK_START.md`
2. **Observer la magie** → Laisser l'app tourner
3. **Customizer** → Adapter les couleurs/tailles
4. **Publier** → L'app est prête!

Si ❌ Certains checks échouent:

1. **Revoir le troubleshooting**
2. **Consulter la documentation**
3. **Exécuter `flutter doctor -v`**
4. **Chercher dans les logs**

---

## 📞 Besoin d'Aide?

1. **Erreur de code?** → Voir dans la console exact
2. **Comment utiliser?** → `LIVING_NAME_QUICK_START.md`
3. **API question?** → `LIVING_NAME_API_REFERENCE.md`
4. **Exemple avancé?** → `LIVING_NAME_ADVANCED_EXAMPLES.md`

---

## ✅ Validation Finale

```bash
# RUN THIS COMMAND TO VERIFY EVERYTHING
flutter test test/living_name_test.dart && flutter analyze && echo "✅ ALL CHECKS PASSED"
```

**Résultat attendu**:
```
✓ All tests passed
✓ No issues found
✅ ALL CHECKS PASSED
```

---

## 📝 Version

- **Cheklist**: v1.0.0
- **Date**: 2026-04-05
- **Système**: Living Name v1.0.0
- **Status**: Production Ready

---

## 🎉 Bravo!

Si vous êtes arrivé ici avec tous les checks ✅, **le système Living Name est complètement installé et fonctionnel!**

Le prénom n'est plus juste du texte.

## **IL VIT.** 🎭✨

---

[Commencer avec LIVING_NAME_QUICK_START.md →](LIVING_NAME_QUICK_START.md)

