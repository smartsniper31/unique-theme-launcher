import 'package:flutter/material.dart';

class ColorUtils {
  static Color parseHexColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  static String toHex(Color color) {
    // ignore: deprecated_member_use
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }
}

extension ColorExtension on Color {
  String toHex() => ColorUtils.toHex(this);
}
