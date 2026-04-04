import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dynamic_theme.dart';

class GreetingCard extends StatelessWidget {
  const GreetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DynamicTheme>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          theme.getGreeting(),
          style: TextStyle(
            color: theme.primaryColor,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Détecté via ${theme.profile.identity.source.toString().split('.').last}",
          style: TextStyle(
            color: Colors.grey[500],
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
