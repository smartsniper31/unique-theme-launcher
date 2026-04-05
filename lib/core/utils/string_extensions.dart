import 'dart:math' as math;

extension StringExtensions on String {
  int get vowelCount {
    return RegExp(r'[aeiouyAEIOUY]').allMatches(this).length;
  }

  int get consonantCount {
    return length - vowelCount;
  }

  String get firstLetterUpper {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  String get toUnitFormat {
    if (isEmpty) return 'UNK';
    return substring(0, math.min(3, length)).toUpperCase();
  }
}
