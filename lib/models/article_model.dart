class Article {
  final int id;
  final int userId;
  final String title;
  final String body;
  final bool isFavorite;

  Article({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.isFavorite = false,});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
    );
  }

  Article copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
    bool? isFavorite,
  }) {
    return Article(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
