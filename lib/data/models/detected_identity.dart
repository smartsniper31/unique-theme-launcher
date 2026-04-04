enum NameSource { google, contact, sms, fallback }

class DetectedIdentity {
  final String name;
  final NameSource source;
  final double confidenceScore;

  DetectedIdentity({
    required this.name,
    required this.source,
    required this.confidenceScore,
  });

  factory DetectedIdentity.fromJson(Map<String, dynamic> json) => DetectedIdentity(
    name: json['name'],
    source: NameSource.values.firstWhere((e) => e.toString() == json['source']),
    confidenceScore: json['confidenceScore'],
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'source': source.toString(),
    'confidenceScore': confidenceScore,
  };
}
