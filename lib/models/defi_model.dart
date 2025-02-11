class Defi {
  final int id;
  final String titre;
  final String description;
  final int impact;

  Defi({
    required this.id,
    required this.titre,
    required this.description,
    required this.impact,
  });

  factory Defi.fromJson(Map<String, dynamic> json) {
    return Defi(
      id: json["id"],
      titre: json["titre"],
      description: json["description"],
      impact: json["impact"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "titre": titre,
      "description": description,
      "impact": impact,
    };
  }
}
