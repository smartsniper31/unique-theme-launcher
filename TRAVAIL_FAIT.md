# TRAVAIL FAIT : Architecture & Implémentation - Thème Ultra-Unique (Version Corrigée & Complète)

Ce document détaille la conception technique finale et l'implémentation d'une application Flutter agissant comme un thème/launcher personnalisé à détection automatique "magique".

---

## Table des Matières
1. [Architecture Complète](#1-architecture-complète)
2. [Modèles de Données (Enrichis)](#2-modèles-de-données)
3. [Structure du Fichier JSON](#3-structure-du-fichier-json)
4. [Implémentation : NameDetector (SMS Réel)](#4-implémentation-namedetector)
5. [Implémentation : Détecteurs Hardware (Device, Battery, Wifi)](#5-implémentation-détecteurs-hardware)
6. [Implémentation : Signature & Messages Vivants](#6-implémentation-signature--messages-vivants)
7. [Implémentation : UnitCalculator & VisualEngine](#7-implémentation-unitcalculator--visualengine)
8. [Implémentation : Stockage (Hive & Adapters)](#8-implémentation-stockage-hive)
9. [Use Case : InstallThemeUseCase](#9-use-case-installthemeusecase)
10. [Main.dart & Initialisation](#10-main-dart)
11. [UI & Widgets Dynamiques](#11-ui--widgets-dynamiques)
12. [Gestion des Permissions (Retry Logic)](#12-gestion-des-permissions)
13. [Configuration (Pubspec & Manifest)](#13-configuration-pubspec--manifest)
14. [Tests Unitaires](#14-tests-unitaires)
15. [Checklist de Livraison](#15-checklist-de-livraison)

---

## 1. Architecture Complète

### Arborescence `lib/`
```text
lib/
├── core/
│   ├── constants/          # Box names, Keys, Default values
│   ├── utils/              # Color helpers, String extensions
│   └── theme/              # Base theme data
├── data/
│   ├── models/             # UserProfile, VisualRules (JSON)
│   ├── sources/            # NameDetector, DeviceDetector, BatteryDetector, WifiDetector
│   └── storage/            # Hive implementation
├── domain/
│   ├── entities/           # LivingMessages, CustomUnits
│   └── usecases/           # InstallThemeUseCase
├── presentation/
│   ├── providers/          # DynamicTheme (ChangeNotifier)
│   ├── screens/            # HomeScreen
│   └── widgets/            # BatteryIndicator, TimeDisplay, GreetingCard
└── main.dart               # Entry point
```

---

## 2. Modèles de Données

### user_profile.dart
```dart
import 'package:json_annotation/json_annotation.dart';
import 'detected_identity.dart';
import 'hardware_signature.dart';
import 'custom_units.dart';
import 'visual_rules.dart';

part 'user_profile.g.dart';

@JsonSerializable(explicitToJson: true)
class UserProfile {
  final DetectedIdentity identity;
  final HardwareSignature hardware;
  final CustomUnits units;
  final VisualRules visualRules;
  final DateTime installTimestamp;
  final double initialBatteryLevel;
  final String wifiAtInstall;

  UserProfile({
    required this.identity,
    required this.hardware,
    required this.units,
    required this.visualRules,
    required this.installTimestamp,
    required this.initialBatteryLevel,
    required this.wifiAtInstall,
  });

  factory UserProfile.fallback() {
    return UserProfile(
      identity: DetectedIdentity(name: "Toi", source: NameSource.fallback, confidenceScore: 0.1),
      hardware: HardwareSignature.fallback(),
      units: CustomUnits.fallback(),
      visualRules: VisualRules.fallback(),
      installTimestamp: DateTime.now(),
      initialBatteryLevel: 0.5,
      wifiAtInstall: "unknown",
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$UserProfileToJson(this);
}
```

### visual_rules.dart
```dart
enum IconDensity { low, medium, high }

class VisualRules {
  final double cornerRadius;
  final IconDensity iconDensity;
  final int gridColumns;
  final String dominantColor; // Hex string
  final int fractalSeed;
  final double iconSize;
  final double fontSize;
  final bool useRoundedIcons;

  VisualRules({
    required this.cornerRadius,
    required this.iconDensity,
    required this.gridColumns,
    required this.dominantColor,
    required this.fractalSeed,
    required this.iconSize,
    required this.fontSize,
    required this.useRoundedIcons,
  });

  factory VisualRules.fallback() {
    return VisualRules(
      cornerRadius: 12.0,
      iconDensity: IconDensity.medium,
      gridColumns: 4,
      dominantColor: "#9E9E9E",
      fractalSeed: 0,
      iconSize: 56.0,
      fontSize: 16.0,
      useRoundedIcons: true,
    );
  }

  // JSON methods...
}
```

### hardware_signature.dart
```dart
class HardwareSignature {
  final String model;
  final String manufacturer;
  final String androidVersion;
  final int sdkInt;
  final String androidIdHash;
  final String? imeiHash;
  final String signature;

  HardwareSignature({
    required this.model,
    required this.manufacturer,
    required this.androidVersion,
    required this.sdkInt,
    required this.androidIdHash,
    this.imeiHash,
    required this.signature,
  });

  factory HardwareSignature.fallback() {
    return HardwareSignature(
      model: "Unknown",
      manufacturer: "Unknown",
      androidVersion: "0",
      sdkInt: 0,
      androidIdHash: "0000",
      signature: "FALLBACK-0000",
    );
  }
}
```

---

## 3. Structure du Fichier JSON
**Chemin :** `getApplicationDocumentsDirectory()/user_theme/profile.json`

```json
{
  "identity": {
    "name": "Alex",
    "source": "NameSource.google",
    "confidenceScore": 0.95
  },
  "hardware": {
    "model": "Pixel 7 Pro",
    "manufacturer": "Google",
    "androidVersion": "13",
    "sdkInt": 33,
    "androidIdHash": "a5f6e7d8...",
    "signature": "ALX-P7-33-A5F6"
  },
  "units": {
    "unitName": "Alex",
    "timeMultiplier": 0.85,
    "batteryMultiplier": 0.01
  },
  "visualRules": {
    "cornerRadius": 12.0,
    "iconDensity": "IconDensity.high",
    "gridColumns": 4,
    "dominantColor": "#FF5733",
    "fractalSeed": 987654,
    "iconSize": 56.0,
    "fontSize": 18.0,
    "useRoundedIcons": true
  },
  "wifiAtInstall": "Home_WiFi_5G",
  "installTimestamp": "2023-10-27T14:30:00Z",
  "initialBatteryLevel": 0.85
}
```

---

## 4. Implémentation : NameDetector

```dart
import 'dart:async';
import 'package:telephony/telephony.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:contacts_service/contacts_service.dart';

class NameDetector {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<DetectedIdentity> detect() async {
    final google = await getFromGoogleAccount();
    if (google != null) return DetectedIdentity(name: google, source: NameSource.google, confidenceScore: 0.95);

    final contact = await getFromMyContact();
    if (contact != null) return DetectedIdentity(name: contact, source: NameSource.contact, confidenceScore: 0.85);

    final sms = await getFromSms();
    if (sms != null) return DetectedIdentity(name: sms, source: NameSource.sms, confidenceScore: 0.70);

    return DetectedIdentity(name: "Utilisateur", source: NameSource.fallback, confidenceScore: 0.1);
  }

  Future<String?> getFromSms() async {
    try {
      final telephony = Telephony.instance;
      // Note: On suppose que les permissions sont déjà gérées par le helper
      
      Completer<String?> completer = Completer();
      
      // On écoute brièvement ou on regarde les messages existants
      List<SmsMessage> messages = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY],
        sortOrder: [OrderBy.ID(Order.DESC)],
        pageSize: 10
      );

      for (var msg in messages) {
        final name = _extractNameFromSender(msg.address ?? "");
        if (name != null) return name;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  String? _extractNameFromSender(String sender) {
    // Regex pour extraire un prénom d'une chaîne type "John <+123>" ou juste le nom associé
    final regex = RegExp(r'^([A-Za-zÀ-ÿ\s]+)\s*[<\(]?');
    final match = regex.firstMatch(sender);
    final found = match?.group(1)?.trim().split(' ').first;
    // On ignore les numéros purs
    if (found != null && RegExp(r'^[0-9+]+$').hasMatch(found)) return null;
    return found;
  }

  Future<String?> getFromGoogleAccount() async {
    try {
      final account = await _googleSignIn.signInSilently();
      return account?.displayName?.split(' ').first;
    } catch (_) => null;
  }

  Future<String?> getFromMyContact() async {
    try {
      Iterable<Contact> contacts = await ContactsService.getContacts(query: "Moi");
      if (contacts.isNotEmpty) return contacts.first.givenName;
      return null;
    } catch (_) => null;
  }
}
```

---

## 5. Implémentation : Détecteurs Hardware

### device_detector.dart
```dart
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:android_id/android_id.dart';

class DeviceDetector {
  Future<HardwareSignature> detect(String userName) async {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    final androidId = await const AndroidId().getId();
    
    final idHash = _hashId(androidId ?? "unknown");
    final timestamp = DateTime.now();
    
    // Signature: [NOM]-[MODEL]-[SDK]-[HASH]
    final shortModel = androidInfo.model.split(' ').last.toUpperCase();
    final signature = "${userName.substring(0,3).toUpperCase()}-$shortModel-${androidInfo.version.sdkInt}-${idHash.substring(0,4)}";

    return HardwareSignature(
      model: androidInfo.model,
      manufacturer: androidInfo.manufacturer,
      androidVersion: androidInfo.version.release,
      sdkInt: androidInfo.version.sdkInt,
      androidIdHash: idHash,
      signature: signature,
    );
  }

  String _hashId(String id) {
    return sha256.convert(utf8.encode(id)).toString();
  }
}
```

### battery_detector.dart
```dart
import 'package:battery_plus/battery_plus.dart';

class BatteryDetector {
  final Battery _battery = Battery();

  Future<double> getLevel() async {
    final level = await _battery.batteryLevel;
    return level / 100.0;
  }
}
```

### wifi_detector.dart
```dart
import 'package:network_info_plus/network_info_plus.dart';

class WifiDetector {
  final NetworkInfo _networkInfo = NetworkInfo();

  Future<String?> getSsid() async {
    try {
      return await _networkInfo.getWifiName();
    } catch (_) {
      return "Offline";
    }
  }
}
```

---

## 6. Implémentation : Signature & Messages Vivants

### living_messages.dart
```dart
class LivingMessages {
  final String morning;
  final String afternoon;
  final String evening;

  LivingMessages({required this.morning, required this.afternoon, required this.evening});

  String getMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) return morning;
    if (hour < 18) return afternoon;
    return evening;
  }
}

class LivingMessagesGenerator {
  static LivingMessages generate(String name) {
    return LivingMessages(
      morning: "Éveil, $name. Le monde t'attend.",
      afternoon: "Énergie, $name. Ta trace se dessine.",
      evening: "Repos, $name. Ta signature demeure.",
    );
  }
}
```

---

## 7. Implémentation : UnitCalculator & VisualEngine

### unit_calculator.dart
```dart
class CustomUnits {
  final String unitName;
  final double timeMultiplier;   // 1 unité = X heures
  final double batteryMultiplier; // 1 unité = 1%

  CustomUnits({required this.unitName, required this.timeMultiplier, required this.batteryMultiplier});

  factory CustomUnits.fallback() {
    return CustomUnits(
      unitName: "toi",
      timeMultiplier: 1.0,
      batteryMultiplier: 0.01,
    );
  }

  String formatTime(DateTime now, DateTime installTime) {
// ...
```
    final hours = now.difference(installTime).inHours;
    final value = hours / timeMultiplier;
    return "${value.toStringAsFixed(1)} $unitName-h";
  }

  String formatBattery(double level) {
    final value = (level * 100) * batteryMultiplier;
    return "${value.toStringAsFixed(1)} $unitName-pwr";
  }
}
```

### visual_engine.dart
```dart
import 'package:flutter/material.dart';

class VisualEngine {
  static VisualRules generate(String name, String signature) {
    final vowelCount = RegExp(r'[aeiouyAEIOUY]').allMatches(name).length;
    final nameLength = name.length;
    
    return VisualRules(
      cornerRadius: (vowelCount * 6.0).clamp(4, 32).toDouble(),
      iconDensity: nameLength < 5 ? IconDensity.low : 
                   nameLength > 8 ? IconDensity.high : IconDensity.medium,
      gridColumns: nameLength <= 4 ? 3 : nameLength <= 7 ? 4 : 5,
      dominantColor: _generateColor(name),
      fractalSeed: signature.hashCode,
      iconSize: nameLength < 5 ? 64.0 : nameLength > 8 ? 48.0 : 56.0,
      fontSize: (16.0 + vowelCount),
      useRoundedIcons: vowelCount > 2,
    );
  }
  
  static Color _generateColor(String name) {
    final hash = name.hashCode;
    // Assurer une couleur opaque et vibrante
    return Color((hash & 0xFFFFFF) + 0xFF000000);
  }
}
```

---

## 8. Implémentation : Stockage (Hive)

```dart
import 'package:hive_flutter/hive_flutter.dart';

class UserStorage {
  Future<void> init() async {
    await Hive.initFlutter();
    // IMPORTANT: Enregistrement des adaptateurs pour Enums
    // Hive.registerAdapter(IconDensityAdapter()); 
    // Hive.registerAdapter(NameSourceAdapter());
  }
  // ... save/load methods ...
}
```

---

## 9. Use Case : InstallThemeUseCase

```dart
class InstallThemeUseCase {
  final NameDetector nameDetector;
  final DeviceDetector deviceDetector;
  final BatteryDetector batteryDetector;
  final WifiDetector wifiDetector;
  final UserStorage storage;

  InstallThemeUseCase({
    required this.nameDetector,
    required this.deviceDetector,
    required this.batteryDetector,
    required this.wifiDetector,
    required this.storage,
  });

  Future<void> execute() async {
    final identity = await nameDetector.detect();
    final hardware = await deviceDetector.detect(identity.name);
    final battery = await batteryDetector.getLevel();
    final wifi = await wifiDetector.getSsid();
    
    final visualRules = VisualEngine.generate(identity.name, hardware.signature);
    
    final profile = UserProfile(
      identity: identity,
      hardware: hardware,
      units: CustomUnits(
        unitName: identity.name,
        timeMultiplier: (identity.name.length / 10.0) + 0.5,
        batteryMultiplier: 1.0,
      ),
      visualRules: visualRules,
      installTimestamp: DateTime.now(),
      initialBatteryLevel: battery,
      wifiAtInstall: wifi,
    );

    await storage.saveProfile(profile);
  }
}
```

---

## 10. Main.dart

```dart
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final storage = UserStorage();
  await storage.init();

  try {
    if (!(await storage.exists())) {
      final results = await PermissionsHelper.requestAllWithRetry();
      
      if (PermissionsHelper.hasEssentialPermissions(results)) {
        final installer = InstallThemeUseCase(
          nameDetector: NameDetector(),
          deviceDetector: DeviceDetector(),
          batteryDetector: BatteryDetector(),
          wifiDetector: WifiDetector(),
          storage: storage,
        );
        await installer.execute();
      }
    }
  } catch (e) {
    print("Erreur lors de l'installation : $e");
  }

  UserProfile? profile = await storage.loadProfile();

  if (profile == null) {
    print("ERREUR CRITIQUE : Impossible de charger le profil");
    // Fallback : créer un profil minimal
    profile = UserProfile.fallback();
    await storage.saveProfile(profile);
  }

  FlutterNativeSplash.remove();

  runApp(
    ChangeNotifierProvider(
      create: (_) => DynamicTheme(profile!),
      child: const DynamicThemeApp(),
    ),
  );
}
```

---

## 11. UI & Widgets Dynamiques

### Helper Couleur (Correction technique)
```dart
Color parseHexColor(String hex) {
  hex = hex.replaceFirst('#', '');
  if (hex.length == 6) hex = 'FF$hex';
  return Color(int.parse(hex, radix: 16));
}
```

### BatteryIndicator
```dart
class BatteryIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DynamicTheme>(context);
    return Text(
      theme.units.formatBattery(theme.currentBatteryLevel),
      style: TextStyle(color: theme.primaryColor, fontSize: theme.visualRules.fontSize),
    );
  }
}
```

---

## 12. Gestion des Permissions (Retry Logic)

```dart
import 'package:permission_handler/permission_handler.dart';

class PermissionsHelper {
  /// Version 11.0.0+ compatible
  static Future<Map<Permission, PermissionStatus>> requestAllWithRetry() async {
    final permissions = [
      Permission.contacts,
      Permission.sms,
      Permission.phone,
    ];
    
    final Map<Permission, PermissionStatus> results = {};
    
    for (final permission in permissions) {
      final status = await permission.request();
      results[permission] = status;
      
      if (status.isDenied && !status.isPermanentlyDenied) {
        // Deuxième tentative
        final secondStatus = await permission.request();
        results[permission] = secondStatus;
      }
    }
    
    return results;
  }

  static bool hasEssentialPermissions(Map<Permission, PermissionStatus> results) {
    return results[Permission.contacts]?.isGranted == true || 
           results[Permission.sms]?.isGranted == true;
  }
}
```

---

## 13. Configuration (Pubspec & Manifest)

### pubspec.yaml
```yaml
dependencies:
  flutter:
    sdk: flutter
  hive_flutter: ^1.1.0
  google_sign_in: ^6.1.0
  contacts_service: ^0.6.3
  telephony: ^0.2.0
  device_info_plus: ^9.0.2
  battery_plus: ^5.0.1
  network_info_plus: ^5.0.1
  android_id: ^0.3.0
  crypto: ^3.0.3
  provider: ^6.0.5
  permission_handler: ^11.0.0
  flutter_native_splash: ^2.3.0
```

---

## 14. Tests Unitaires

```dart
void main() {
  test('VisualEngine generates consistent rules', () {
    final rules = VisualEngine.generate("Alex", "SIG-123");
    expect(rules.cornerRadius, 12.0); // A, e = 2 voyelles * 6
    expect(rules.gridColumns, 3);    // "Alex" = 4 lettres
  });

  test('CustomUnits formats correctly', () {
    final units = CustomUnits(unitName: "Alex", timeMultiplier: 1.0, batteryMultiplier: 1.0);
    expect(units.formatBattery(0.85), "85.0 Alex-pwr");
  });
}
```

---

## 15. Checklist de Livraison
- [x] `NameDetector` avec extraction Regex réelle depuis SMS
- [x] `DeviceDetector` capturant Model, Manufacturer et AndroidID
- [x] `BatteryDetector` et `WifiDetector` intégrés
- [x] `LivingMessages` générant des salutations contextuelles
- [x] `VisualEngine` enrichi (IconSize, FontSize, RoundedIcons)
- [x] `PermissionsHelper` avec logique de retry
- [x] Correction technique `parseHexColor`
- [x] `pubspec.yaml` complet avec toutes les dépendances
- [x] `main.dart` avec Splash Screen et gestion d'erreur initiale
