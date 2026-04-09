# Guide Débutant - Build APK Fix (Étape par Étape)

## ✅ Android v2 Embedding = RÉSOLU

## ❌ Problème actuel : contacts_service 0.6.3 obsolète

### Étape 1 : pubspec.yaml
```
dependencies:
  flutter_contacts: ^1.1.8+1  # Remplace contacts_service
```

### Étape 2 : Terminal
```bash
flutter pub get
flutter build apk
