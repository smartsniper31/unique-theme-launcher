class HardwareSignature {
  final String model;
  final String manufacturer;
  final String androidVersion;
  final int sdkInt;
  final String androidIdHash;
  final String? imeiHash;
  final String signature;

  HardwareSignature({
    required this.model,
    required this.manufacturer,
    required this.androidVersion,
    required this.sdkInt,
    required this.androidIdHash,
    this.imeiHash,
    required this.signature,
  });

  factory HardwareSignature.fallback() {
    return HardwareSignature(
      model: "Unknown",
      manufacturer: "Unknown",
      androidVersion: "0",
      sdkInt: 0,
      androidIdHash: "0000",
      signature: "FALLBACK-0000",
    );
  }

  factory HardwareSignature.fromJson(Map<String, dynamic> json) =>
      HardwareSignature(
        model: json['model'],
        manufacturer: json['manufacturer'],
        androidVersion: json['androidVersion'],
        sdkInt: json['sdkInt'],
        androidIdHash: json['androidIdHash'],
        imeiHash: json['imeiHash'],
        signature: json['signature'],
      );

  Map<String, dynamic> toJson() => {
        'model': model,
        'manufacturer': manufacturer,
        'androidVersion': androidVersion,
        'sdkInt': sdkInt,
        'androidIdHash': androidIdHash,
        'imeiHash': imeiHash,
        'signature': signature,
      };
}
