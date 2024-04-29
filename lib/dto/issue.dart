class Issues {
  final int idIssues;
  final String title;
  final String? nim;
  final String? imageUrl;
  final String deskripsi;
  final int rating;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Issues(
      {required this.idIssues,
      this.nim,
      required this.title,
      required this.deskripsi,
      required this.rating,
      this.imageUrl,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  factory Issues.fromJson(Map<String, dynamic> json) => Issues(
      idIssues: json['id_customer_service'] as int,
      nim: json['nim'] as String,
      title: json['title_issues'] as String,
      deskripsi: json['description_issues'] as String,
      rating: json['rating'] as int,
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null);
}
