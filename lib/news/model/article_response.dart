import 'package:newsapp/news/model/article.dart';

class ArticleResponse {
  final List<ArticleModel> articles;
  final String error;

  // Constructor
  ArticleResponse(this.articles, this.error);

  // Constructor from JSON
  ArticleResponse.fromJson(Map<String, dynamic> json)
    : articles = (json["articles"] as List?)
          ?.map((i) => new ArticleModel.fromJson(i))
          .toList() ?? [], // Default ke list kosong jika null
      error = json['error'] ?? ''; // Jika 'error' null, set ke string kosong

  // Constructor untuk error
  ArticleResponse.withError(String errorValue)
    : articles = List<ArticleModel>.empty(),
      error = errorValue;

  // Menambahkan toJson() untuk mengonversi objek ke JSON
  Map<String, dynamic> toJson() {
    return {
      'articles': articles.map((article) => article.toJson()).toList(),
      'error': error,
    };
  }
}
