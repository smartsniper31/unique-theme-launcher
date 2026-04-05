class LivingMessages {
  final String morning;
  final String afternoon;
  final String evening;

  LivingMessages(
      {required this.morning, required this.afternoon, required this.evening});

  String getMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) return morning;
    if (hour < 18) return afternoon;
    return evening;
  }
}

class LivingMessagesGenerator {
  static LivingMessages generate(String name) {
    return LivingMessages(
      morning: "Éveil, $name. Le monde t'attend.",
      afternoon: "Énergie, $name. Ta trace se dessine.",
      evening: "Repos, $name. Ta signature demeure.",
    );
  }
}
