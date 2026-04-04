import 'package:battery_plus/battery_plus.dart';

class BatteryDetector {
  final Battery _battery = Battery();

  Future<double> getLevel() async {
    final level = await _battery.batteryLevel;
    return level / 100.0;
  }
}
