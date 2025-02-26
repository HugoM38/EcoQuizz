class Defi {
  final String id;
  final String titre;
  final String description;
  final int impact;
  final bool unlimited;
  final DateTime? lastDate;

  Defi({
    required this.id,
    required this.titre,
    required this.description,
    required this.impact,
    required this.unlimited,
    this.lastDate,
  });
  
  factory Defi.fromJson(Map<String, dynamic> json) {
    return Defi(
      id: json["_id"]?.toString()
          ?? json["id"]?.toString()
          ?? json["defiId"]?.toString()
          ?? "",
      titre: json["titre"] ?? "",
      description: json["description"] ?? "",
      impact: json["impact"] ?? 0,
      unlimited: json["unlimited"] ?? false,
      lastDate: (json["lastDate"] != null)
          ? DateTime.parse(json["lastDate"])
          : null,
    );
  }

  Defi copyWith({ DateTime? lastDate }) {
    return Defi(
      id: id,
      titre: titre,
      description: description,
      impact: impact,
      unlimited: unlimited,
      lastDate: lastDate ?? this.lastDate,
    );
  }
}
