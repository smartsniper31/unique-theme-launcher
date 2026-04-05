enum IconDensity { low, medium, high }

class VisualRules {
  final double cornerRadius;
  final IconDensity iconDensity;
  final int gridColumns;
  final String dominantColor; // Hex string
  final int fractalSeed;
  final double iconSize;
  final double fontSize;
  final bool useRoundedIcons;

  VisualRules({
    required this.cornerRadius,
    required this.iconDensity,
    required this.gridColumns,
    required this.dominantColor,
    required this.fractalSeed,
    required this.iconSize,
    required this.fontSize,
    required this.useRoundedIcons,
  });

  factory VisualRules.fallback() {
    return VisualRules(
      cornerRadius: 12.0,
      iconDensity: IconDensity.medium,
      gridColumns: 4,
      dominantColor: "#9E9E9E",
      fractalSeed: 0,
      iconSize: 56.0,
      fontSize: 16.0,
      useRoundedIcons: true,
    );
  }

  factory VisualRules.fromJson(Map<String, dynamic> json) => VisualRules(
        cornerRadius: json['cornerRadius'],
        iconDensity: IconDensity.values
            .firstWhere((e) => e.toString() == json['iconDensity']),
        gridColumns: json['gridColumns'],
        dominantColor: json['dominantColor'],
        fractalSeed: json['fractalSeed'],
        iconSize: json['iconSize'],
        fontSize: json['fontSize'],
        useRoundedIcons: json['useRoundedIcons'],
      );

  Map<String, dynamic> toJson() => {
        'cornerRadius': cornerRadius,
        'iconDensity': iconDensity.toString(),
        'gridColumns': gridColumns,
        'dominantColor': dominantColor,
        'fractalSeed': fractalSeed,
        'iconSize': iconSize,
        'fontSize': fontSize,
        'useRoundedIcons': useRoundedIcons,
      };
}
