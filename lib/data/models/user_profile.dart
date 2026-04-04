import 'detected_identity.dart';
import 'hardware_signature.dart';
import 'custom_units.dart';
import 'visual_rules.dart';

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

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    identity: DetectedIdentity.fromJson(json['identity']),
    hardware: HardwareSignature.fromJson(json['hardware']),
    units: CustomUnits.fromJson(json['units']),
    visualRules: VisualRules.fromJson(json['visualRules']),
    installTimestamp: DateTime.parse(json['installTimestamp']),
    initialBatteryLevel: json['initialBatteryLevel'],
    wifiAtInstall: json['wifiAtInstall'],
  );

  Map<String, dynamic> toJson() => {
    'identity': identity.toJson(),
    'hardware': hardware.toJson(),
    'units': units.toJson(),
    'visualRules': visualRules.toJson(),
    'installTimestamp': installTimestamp.toIso8601String(),
    'initialBatteryLevel': initialBatteryLevel,
    'wifiAtInstall': wifiAtInstall,
  };
}
