class AltinFiyati {
  final String name;
  final double buy;
  final double sell;

  AltinFiyati({required this.name, required this.buy, required this.sell});

  factory AltinFiyati.fromJson(Map<String, dynamic> json) {
    return AltinFiyati(
      name: json['name'] ?? "Bilinmiyor",
      buy: double.tryParse(json['buying'].toString()) ?? 0.0,
      sell: double.tryParse(json['selling'].toString()) ?? 0.0,
    );
  }
}
