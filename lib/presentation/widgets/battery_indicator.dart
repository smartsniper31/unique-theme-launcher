import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dynamic_theme.dart';

class BatteryIndicator extends StatelessWidget {
  const BatteryIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DynamicTheme>(context);
    return Text(
      theme.units.formatBattery(theme.currentBatteryLevel),
      style: TextStyle(
        color: theme.primaryColor,
        fontSize: theme.visualRules.fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
