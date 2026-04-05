import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dynamic_theme.dart';
import '../widgets/battery_indicator.dart';
import '../widgets/time_display.dart';
import '../widgets/greeting_card.dart';
import '../widgets/living_name.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DynamicTheme>(context);

    return Scaffold(
      backgroundColor: theme.primaryColor.withValues(alpha: 0.05),
      appBar: AppBar(
        title: LivingName(
          name: theme.userName,
          color: Colors.white,
          fontSize: theme.fontSize,
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        backgroundColor: theme.primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GreetingCard(),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Énergie",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const BatteryIndicator(),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Temps",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const TimeDisplay(),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: theme.visualRules.gridColumns,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: theme.cornerRadius,
                    mainAxisSpacing: theme.cornerRadius,
                  ),
                  itemCount: 12, // Dummy icons
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(theme.cornerRadius),
                      ),
                      child: Icon(
                        Icons.apps,
                        color: theme.primaryColor,
                        size: theme.iconSize,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  "Signature: ${theme.profile.hardware.signature}",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
