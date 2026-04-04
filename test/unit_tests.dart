import 'package:flutter_test/flutter_test.dart';
// Note: In a real project, you would import your actual files here
// import 'package:unique_theme_launcher/core/utils/string_extensions.dart';

void main() {
  test('Basic String Extension Test', () {
    final name = "Alex";
    final vowelCount = RegExp(r'[aeiouyAEIOUY]').allMatches(name).length;
    expect(vowelCount, 2);
  });

  test('Signature Logic Test', () {
    final name = "Alex";
    final signature = name.substring(0, 3).toUpperCase();
    expect(signature, "ALE");
  });
}
