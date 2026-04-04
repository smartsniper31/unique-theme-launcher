import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dynamic_theme.dart';

class TimeDisplay extends StatefulWidget {
  const TimeDisplay({super.key});

  @override
  State<TimeDisplay> createState() => _TimeDisplayState();
}

class _TimeDisplayState extends State<TimeDisplay> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<DynamicTheme>(context);
    return Text(
      theme.formatTime(DateTime.now()),
      style: TextStyle(
        color: theme.primaryColor,
        fontSize: theme.fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
