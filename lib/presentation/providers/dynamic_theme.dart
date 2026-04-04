import 'dart:async';
import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import '../../../data/models/user_profile.dart';
import '../../../data/models/visual_rules.dart';
import '../../../data/models/custom_units.dart';
import '../../../core/utils/color_utils.dart';
import '../../../domain/entities/living_messages.dart';

class DynamicTheme extends ChangeNotifier {
  final UserProfile profile;
  double _currentBatteryLevel = 0.0;
  StreamSubscription<int>? _batterySubscription;

  DynamicTheme(this.profile) {
    _currentBatteryLevel = profile.initialBatteryLevel;
    _initBatteryListener();
  }

  @override
  void dispose() {
    _batterySubscription?.cancel();
    super.dispose();
  }

  void _initBatteryListener() {
    final battery = Battery();
    _batterySubscription = battery.onBatteryStateChanged.listen((BatteryState state) async {
      final level = await battery.batteryLevel;
      updateBatteryLevel(level / 100.0);
    });
  }

  Color get primaryColor => ColorUtils.parseHexColor(profile.visualRules.dominantColor);
  double get cornerRadius => profile.visualRules.cornerRadius;
  double get iconSize => profile.visualRules.iconSize;
  double get fontSize => profile.visualRules.fontSize;
  String get greeting => getGreeting();
  String get userName => profile.identity.name;
  String get formattedBattery => units.formatBattery(currentBatteryLevel);
  VisualRules get visualRules => profile.visualRules;
  CustomUnits get units => profile.units;

  String formatTime(DateTime now) {
    return units.formatTime(now, profile.installTimestamp);
  }

  String getGreeting() {
    final messages = LivingMessagesGenerator.generate(profile.identity.name);
    return messages.getMessage();
  }

  void updateBatteryLevel(double level) {
    _currentBatteryLevel = level;
    notifyListeners();
  }
}
