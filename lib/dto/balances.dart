class Balances {
  int idBalance;
  String nim;
  int balance;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  Balances({
    required this.idBalance,
    required this.nim,
    required this.balance,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory Balances.fromJson(Map<String, dynamic> json) => Balances(
        idBalance: json["id_balance"],
        nim: json["nim"],
        balance: json["balance"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id_balance": idBalance,
        "nim": nim,
        "balance": balance,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
