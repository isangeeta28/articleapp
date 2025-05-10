import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';

class ArticleRepository {
  final String url = "https://jsonplaceholder.typicode.com/posts";

  Future<List<Article>> fetchArticles() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Article.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }
}
