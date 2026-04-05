class CustomUnits {
  final String unitName;
  final double timeMultiplier; // 1 unité = X heures
  final double batteryMultiplier; // 1 unité = 1%

  CustomUnits(
      {required this.unitName,
      required this.timeMultiplier,
      required this.batteryMultiplier});

  factory CustomUnits.fallback() {
    return CustomUnits(
      unitName: "toi",
      timeMultiplier: 1.0,
      batteryMultiplier: 0.01,
    );
  }

  String formatTime(DateTime now, DateTime installTime) {
    final hours = now.difference(installTime).inHours;
    final value = hours / timeMultiplier;
    return "${value.toStringAsFixed(1)} $unitName-h";
  }

  String formatBattery(double level) {
    final value = (level * 100) * batteryMultiplier;
    return "${value.toStringAsFixed(1)} $unitName-pwr";
  }

  factory CustomUnits.fromJson(Map<String, dynamic> json) => CustomUnits(
        unitName: json['unitName'],
        timeMultiplier: json['timeMultiplier'],
        batteryMultiplier: json['batteryMultiplier'],
      );

  Map<String, dynamic> toJson() => {
        'unitName': unitName,
        'timeMultiplier': timeMultiplier,
        'batteryMultiplier': batteryMultiplier,
      };
}
