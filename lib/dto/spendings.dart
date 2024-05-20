class Spendings {
  int idSpending;
  int spending;
  String nim;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  Spendings({
    required this.idSpending,
    required this.spending,
    required this.nim,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Spendings.fromJson(Map<String, dynamic> json) => Spendings(
        idSpending: json["id_spending"],
        spending: json["spending"],
        nim: json["nim"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id_spending": idSpending,
        "spending": spending,
        "nim": nim,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
