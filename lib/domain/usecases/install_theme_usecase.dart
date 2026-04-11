import '../../data/sources/name_detector.dart';
import '../../data/sources/device_detector.dart';
import '../../data/sources/battery_detector.dart';
import '../../data/sources/wifi_detector.dart';
import '../../data/storage/user_storage.dart';
import '../../data/models/user_profile.dart';
import '../../data/models/custom_units.dart';
import '../../data/models/visual_rules.dart';
import 'package:flutter/material.dart';

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

    // VisualEngine logic moved to a helper or kept here
    final visualRules =
        VisualEngine.generate(identity.name, hardware.signature);

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
      wifiAtInstall: wifi ?? "Unknown",
    );

    await storage.saveProfile(profile);
  }
}

// VisualEngine helper
class VisualEngine {
  static VisualRules generate(String name, String signature) {
    final vowelCount = RegExp(r'[aeiouyAEIOUY]').allMatches(name).length;
    final nameLength = name.length;

    return VisualRules(
      cornerRadius: (vowelCount * 6.0).clamp(4, 32).toDouble(),
      iconDensity: nameLength < 5
          ? IconDensity.low
          : nameLength > 8
              ? IconDensity.high
              : IconDensity.medium,
      gridColumns: nameLength <= 4
          ? 3
          : nameLength <= 7
              ? 4
              : 5,
      dominantColor: _generateColor(name),
      fractalSeed: signature.hashCode,
      iconSize: nameLength < 5
          ? 64.0
          : nameLength > 8
              ? 48.0
              : 56.0,
      fontSize: (16.0 + vowelCount),
      useRoundedIcons: vowelCount > 2,
    );
  }

  static String _generateColor(String name) {
    final hash = name.hashCode;
    final color = Color((hash & 0xFFFFFF) + 0xFF000000);
    // ignore: deprecated_member_use
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }
}
