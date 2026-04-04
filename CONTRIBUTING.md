# 🤝 Contributing Guide

Merci de vouloir contribuer à **Unique Theme Launcher** ! Ce document vous guide à travers le processus.

---

## 📋 Table des Matières

1. [Code of Conduct](#code-of-conduct)
2. [Comment Contribuer](#comment-contribuer)
3. [Setup de Développement](#setup-de-développement)
4. [Standards de Code](#standards-de-code)
5. [Processus de Pull Request](#processus-de-pull-request)
6. [Types de Contributions](#types-de-contributions)
7. [Conventions de Commit](#conventions-de-commit)

---

## 📜 Code of Conduct

Nous nous engageons à fournir un environnement accueillant. Tous les contributeurs doivent :

- ✅ Respecter les différences de point de vue
- ✅ Fournir des critiques constructives
- ✅ Se concentrer sur ce qui est meilleur pour la communauté
- ✅ Montrer de l'empathie envers les autres contributeurs

**Comportements inacceptables** : harcèlement, insultes, discrimination, spam.

---

## ✨ Comment Contribuer

### 1. Signaler un Bug 🐛

**Avant de signaler :**
- Vérifier si le bug existe déjà dans [Issues](https://github.com/smartsniper31/unique-theme-launcher/issues)
- Essayer de reproduire le bug

**Créer un Issue :**
```
Title: [BUG] Courte description du problème

Body:
## Description
Description détaillée du bug

## Steps to Reproduce
1. Ouvrir l'app
2. Aller à [écran]
3. Cliquer sur [bouton]
4. Observer le bug

## Expected Behavior
Ce qui devrait se passer

## Actual Behavior
Ce qui se passe réellement

## Environment
- Flutter Version: 3.x.x
- Device: Samsung Galaxy S23
- Android Version: 14
- Logs:
  ```
  [copier les logs pertinents]
  ```
```

### 2. Suggérer une Feature 💡

```
Title: [FEATURE] Courte description de l'idée

Body:
## Description
Pourquoi cette feature est nécessaire

## Use Case
Comment cela aide l'utilisateur

## Proposed Solution
Comment vous l'implémenteriez (optionnel)

## Alternatives Considered
Autres solutions possibles
```

### 3. Contribuer du Code 💻

Voir [Processus de Pull Request](#processus-de-pull-request)

### 4. Améliorer la Documentation 📚

- Corriger les typos
- Clarifier les instructions
- Ajouter des exemples
- Traducations bienvenues

---

## 🛠️ Setup de Développement

### Prérequis

```bash
# Vérifier les versions
flutter --version    # 3.0.0+
dart --version      # 3.0.0+
java -version       # 11+
```

### Installation Locale

```bash
# 1. Fork le repo
# (Depuis GitHub UI)

# 2. Cloner votre fork
git clone https://github.com/YOUR_USERNAME/unique-theme-launcher.git
cd unique-theme-launcher

# 3. Ajouter upstream (pour rester à jour)
git remote add upstream https://github.com/smartsniper31/unique-theme-launcher.git

# 4. Installer dépendances
flutter pub get

# 5. Générer fichiers
flutter pub run build_runner build

# 6. Vérifier que tout fonctionne
flutter test
```

### Vérifier votre Setup

```bash
flutter doctor -v
# Tous les items doivent être ✓
```

---

## 📏 Standards de Code

### Dart Conventions

**Nommage :**
```dart
// ❌ Mauvais
class userProfile {}
void getUserData() {}

// ✅ Correct
class UserProfile {}
void _getUserData() {}
```

**Style :**
```dart
// ✅ Format avec dart format
dart format .

// ✅ Lint avec dart analyze
dart analyze

// ✅ Pas de warnings
```

### Règles de Code

| Aspect | Règle |
|:---|:---|
| **Max Line Length** | 120 caractères |
| **Indentation** | 2 espaces (jamais tabs) |
| **Imports** | Triés: dart, flutter, packages, relatifs |
| **Constructors** | Const quand possible |
| **Comments** | Anglais seulement, pas de code commenté |

### Exemple de Fichier Bien Formaté

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unique_theme_launcher/core/utils/color_utils.dart';

/// Gère la détection automatique du nom utilisateur.
/// 
/// Essaie successivement:
/// 1. Google Sign-In
/// 2. Contacts
/// 3. SMS
/// 4. Fallback à "Toi"
class NameDetector {
  /// Détecte le nom avec timeout de 5s
  /// 
  /// Return: Le nom détecté ou "Toi"
  static Future<String> detectName() async {
    try {
      final name = await _detectFromGoogle();
      if (name.isNotEmpty) return name;
      
      return _detectFromContacts() ?? 'Toi';
    } catch (e) {
      debugPrint('Error detecting name: $e');
      return 'Toi';
    }
  }
  
  static Future<String> _detectFromGoogle() async {
    // Implémentation...
  }
}
```

### Commentaires & Documentation

```dart
// ✅ Bon : explique le POURQUOI
/// Ajouter un délai car la détection de contacts
/// est async et peut être lente sur devices anciens
await Future.delayed(Duration(milliseconds: 500));

// ❌ Mauvais : état le QUOI (évident)
// Attendre 500ms
await Future.delayed(Duration(milliseconds: 500));

// ❌ Mauvais : code commenté
// userProfile = await storage.getProfile();
```

### Tests

**Obligatoire pour :**
- ✅ Nouvelles fonctions publiques
- ✅ Bug fixes
- ✅ Logique complexe

```dart
// test/unit_tests.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:unique_theme_launcher/core/utils/color_utils.dart';

void main() {
  group('ColorUtils', () {
    test('generateColorFromName returns valid HSL color', () {
      final color = ColorUtils.generateColorFromName('Alex');
      
      expect(color, isNotNull);
      expect(color.alpha, equals(255));
    });
    
    test('generateColorFromName produces consistent colors', () {
      final color1 = ColorUtils.generateColorFromName('Test');
      final color2 = ColorUtils.generateColorFromName('Test');
      
      expect(color1, equals(color2));
    });
  });
}

// Lancer les tests
flutter test
```

---

## 🔄 Processus de Pull Request

### 1. Créer une Branche

```bash
# Mettre à jour main
git checkout main
git pull upstream main

# Créer une branche feature
git checkout -b feature/mon-feature
# ou bugfix/mon-bugfix
# ou docs/ma-documentation
```

**Nommage des branches :**
```
feature/name-of-feature     # Nouvelle fonctionnalité
bugfix/description          # Correction de bug
docs/what-changed           # Documentation
test/what-is-tested         # Tests
refactor/what-improved      # Refactoring
```

### 2. Faire vos Changements

```bash
# Editer vos fichiers
# Tester localement
flutter test
flutter run

# Ajouter les changements
git add .

# Committer (voir conventions ci-dessous)
git commit -m "feat: add name detection from Google Sign-In"
```

### 3. Préparer la PR

```bash
# Format le code
dart format .

# Lint
dart analyze

# Tests
flutter test

# Puis commit + push
git push origin feature/mon-feature
```

### 4. Créer la Pull Request

**Depuis la GitHub UI :**

**Title :**
```
feat: Add support for multiple detection sources
```

**Description Template :**
```markdown
## Description
Brief explanation of what this PR does

## Type of Change
- [ ] 🐛 Bug fix (non-breaking change which fixes an issue)
- [ ] ✨ New feature (non-breaking change which adds functionality)
- [ ] 📚 Documentation update
- [ ] 🔄 Refactoring
- [ ] ⚡ Performance improvement

## Related Issues
Closes #123
Related to #456

## Changes Made
- Point 1
- Point 2
- Point 3

## Testing
How did you test these changes?

## Screenshots (if applicable)
[Add screenshots for UI changes]

## Checklist
- [x] My code follows the code style of this project
- [x] I have performed a self-review of my own code
- [x] I have commented my code, particularly in hard-to-understand areas
- [x] I have made corresponding changes to the documentation
- [x] My changes generate no new warnings
- [x] I have added tests that prove my fix is effective or that my feature works
- [x] New and existing tests pass locally with my changes
```

### 5. Répondre aux Reviews

- Soyez respectueux et ouvert aux critiques
- Expliquez votre approche si nécessaire
- Faites les changements demandés
- Repushez après modifications (la PR se mettra à jour auto)

### 6. Merge

Une fois approuvée, l'équipe merge la PR. Félicitations ! 🎉

---

## 📝 Types de Contributions

### 🐛 Bug Fixes
- Titre: `fix: description courte`
- Inclure: test case reproduisant le bug
- Inclure: test validant la fix

### ✨ Features
- Titre: `feat: description courte`
- Inclure: documentation
- Inclure: tests
- Inclure: screenshots si UI changement

### 📚 Documentation
- Titre: `docs: what changed`
- Clarté et précision
- Exemples si applicable

### 🧪 Tests
- Titre: `test: what is tested`
- Augmenter la couverture (70%+ cible)

### 🔄 Refactoring
- Titre: `refactor: what improved`
- Pas de changement fonctionnel
- Explique les bénéfices

### ⚡ Performance
- Titre: `perf: what optimized`
- Inclure: benchmarks avant/après
- Inclure: résultats détaillés

---

## 💬 Conventions de Commit

Format : `type(scope): description`

### Types
- `feat`: Nouvelle fonctionnalité
- `fix`: Correction de bug
- `docs`: Documentation
- `style`: Formatage, pas de logique changée
- `refactor`: Refactorization
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Build, dependencies, tooling

### Exemples

```bash
# Feature
git commit -m "feat(detection): add SMS name detection"

# Fix
git commit -m "fix(ui): correct color generation on Android 11+"

# Docs
git commit -m "docs: update installation guide"

# Refactor
git commit -m "refactor(provider): simplify state management logic"

# Multiple lignes (si besoin)
git commit -m "feat(battery): add real-time battery monitoring

- Integrate battery_plus package
- Display battery in custom unit format
- Update UI every second
- Add tests for battery detector"
```

---

## 🚀 Tips pour une Bonne Contribution

1. **Petit et Focalisé** : Une branche = une feature/fix
2. **Communicatif** : Décrivez bien ce que vous faites
3. **Testez** : Avant de submitter, testez localement
4. **Documentez** : Commentaires + doc string
5. **Respectueux** : Soyez sympa et patient
6. **À Jour** : Rebase avant merge si nécessaire
7. **Signez** : Considérez signer vos commits (`git commit -S`)

---

## ❓ Questions ?

- 📖 Voir le [README](README.md)
- 💬 Ouvrir une [Discussion](https://github.com/smartsniper31/unique-theme-launcher/discussions)
- 🐛 Chercher une [Issue](https://github.com/smartsniper31/unique-theme-launcher/issues)

---

**Merci pour votre contribution ! 🙌**
