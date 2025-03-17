class kurFiyatlari {
  final String name;
  final double rate;
  final double calculated;

  kurFiyatlari({
    required this.name,
    required this.rate,
    required this.calculated,
  });

  factory kurFiyatlari.fromJson(Map<String, dynamic> json) {
    return kurFiyatlari(
      name: json['name'] ?? "Bilinmiyor",
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
      calculated: (json['calculated'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
