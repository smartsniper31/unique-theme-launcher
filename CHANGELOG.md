# Changelog

Tous les changements notables de ce projet sont documentés dans ce fichier.

Le format est basé sur [Keep a Changelog](https://keepachangelog.com/),
et ce projet adhère au [Semantic Versioning](https://semver.org/).

---

## [1.0.0-beta] - 2026-04-04

### ✨ Added (Ajoutées)
- ✅ Auto-detection du nom utilisateur
  - Google Sign-In integration
  - Contacts reading
  - SMS parsing
  - Fallback à "Toi"
- ✅ Génération de signature unique
  - Basée sur IMEI + Device ID + Timestamp + Hash(name)
  - Conversion en format lisible (ALX-P7-33-A5F6)
- ✅ UI dynamique générée depuis le nom
  - Couleurs HSL basées sur hash du nom
  - Grille responsive
  - Coins arrondis personnalisés
  - Animations contextuelles
- ✅ Unité de mesure personnalisée
  - Batterie affichées en "{value} {name}-pwr"
  - Temps affichées en "{value} {name}-h"
- ✅ Messages vivants et contextuels
  - Salutations matinales (6h-12h)
  - Salutations après-midi (12h-18h)
  - Salutations soirée (18h-23h)
- ✅ Indicateur de batterie temps réel
  - Refresh chaque seconde
  - Intégration battery_plus
- ✅ Stockage local sécurisé
  - Format JSON chiffré
  - Aucun cloud, aucun tracking
  - Utilise Hive pour stockage performant
- ✅ Architecture Clean (MVVM + Provider)
  - Séparation claire des couches
  - Réutilisabilité du code
  - Testabilité améliorée
- ✅ Support Android (API 21+)
  - Testé sur Android 5.0 à 15.0
  - Optimisé pour tous les types de devices
- ✅ Permissions intelligentes
  - Dégradation gracieuse si permissions refusées
  - Fallback automatique
  - Aucune crash garantie

### 📚 Documentation
- ✅ README.md complet (850+ lignes)
  - Vision et concepts
  - Architecture détaillée
  - Installation step-by-step
  - API reference
  - Troubleshooting
  - Roadmap future
- ✅ CONTRIBUTING.md pour contributeurs
  - Code standards
  - Process PR
  - Commit conventions
- ✅ Code comments et docstrings
- ✅ Architecture diagrams (Mermaid)

### 🏗️ Infrastructure
- ✅ pubspec.yaml avec dépendances optimisées
- ✅ ProGuard/R8 configuration pour releases
- ✅ AndroidManifest.xml avec permissions
- ✅ .gitignore pour Flutter/Android/Web
- ✅ GitHub repository setup
- ✅ CI/CD ready (pas encore implémenté)

### 🧪 Testing
- ✅ Structure test/ setup
- ✅ Unit tests templates
- ✅ Mock providers pour tests
- ✅ Test coverage baseline (20%)

---

## [1.1.0] - Planifié (Q3 2026)

### 🆕 À venir
- [ ] Détection WhatsApp (profile nom)
- [ ] Détection Telegram (username)
- [ ] Détection WiFi network name
- [ ] Custom name input (opt-in)
- [ ] Multi-profile support
- [ ] Thème templates pré-définis
- [ ] Dark mode automatic
- [ ] Accessibility improvements

---

## [1.2.0] - Planifié (Q4 2026)

### 🆕 À venir
- [ ] In-app theme editor
- [ ] Custom unit names
- [ ] Home screen widgets
- [ ] Tasker integration
- [ ] Backup/Restore profiles
- [ ] Cloud backup option
- [ ] Theme sharing

---

## [2.0.0] - Planifié (2027)

### 🚀 Major Release
- [ ] iOS support
- [ ] Web platform (PWA)
- [ ] Wear OS support
- [ ] Cross-device sync
- [ ] AI-powered personalization
- [ ] Cloud themes marketplace

---

## Notes de Version Détaillées

### v1.0.0-beta - Release d'Accès Beta

**ce qui est stable :** 
- ✅ Core detection engine
- ✅ UI generation
- ✅ Storage system
- ✅ Android support

**ce qui peut changer :**
- 🟡 API interne (Provider structure)
- 🟡 Model definitions
- 🟡 Color generation algorithm
- 🟡 Message system

**limites connues :**
- ❌ iOS pas supporté
- ❌ Web expérimental seulement
- ❌ Pas de sync multi-device
- ❌ Test coverage partielle (20%)

**pour reporter un bug :**
- Ouvrir une [issue](https://github.com/smartsniper31/unique-theme-launcher/issues)
- Inclure: version, device, logs
- Étapes pour reproduire

---

## Légende

- ✅ Complète/Implémentée
- 🟡 En cours/Partiellement
- 🔜 À venir bientôt
- 🟠 En discussion
- ❌ Non supporté/Rejeté
- 🐛 Bug connu
- 🚀 Priorité haute

---

## Historique des Versions Anciennes

### [0.9.0-alpha] - 2026-01-15 (Non Public)
- Premier prototype interne
- Détection de base
- UI statique

### [0.8.0] - 2026-01-01 (Non Public)
- Setup projet initial
- Architecture planning

---

## Support des Versions

| Version | Support |Jusqu'à |
|:---|:---|:---|
| 1.0.x | ✅ Actif | 2027-06 |
| 1.1.x | 🔜 Planifié | 2027-12 |
| 0.9.x | ❌ EOL | N/A |

---

## Comment Mettre à Jour

### De beta vers 1.0 (futur)
```bash
flutter pub upgrade
flutter clean
flutter pub get
flutter pub run build_runner build
flutter run
```

### Rollback à version antérieure

```bash
git checkout tags/v1.0.0-beta
```

---

## Remerciements

Merci à tous les contributeurs et testeurs pour aider à rendre ce projet meilleur ! 🙏

---

Pour plus d'infos :
- 📖 [README](README.md)
- 🤝 [Contributing](CONTRIBUTING.md)
- 💬 [Discussions](https://github.com/smartsniper31/unique-theme-launcher/discussions)
- 🐛 [Issues](https://github.com/smartsniper31/unique-theme-launcher/issues)
