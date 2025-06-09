import 'package:newsapp/news/model/source.dart';

class ArticleModel {
  final SourceModel source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String img;
  final String date;
  final String content;

  // Constructor
  ArticleModel({
    required this.source,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.img,
    required this.date,
    required this.content,
  });

  // Factory method fromJson untuk konversi dari JSON ke objek
  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      source:
          json["source"] != null
              ? SourceModel.fromJson(
                json["source"],
              ) // Pastikan SourceModel.fromJson mengisi semua parameter
              : SourceModel(
                id: 'Unknown',
                name: 'Unknown',
                description: 'No Description Available',
                url: '',
                category: '',
                country: '',
                language: '',
              ), // Mengisi parameter dengan nilai default
      author: json["author"] ?? 'No Author',
      title: json["title"] ?? 'No Title',
      description: json["description"] ?? 'No Description Available',
      url: json["url"] ?? '',
      img: json["urlToImage"] ?? '',
      date:
          json["publishedAt"] ?? '', // Menggunakan 'publishedAt' untuk tanggal
      content: json["content"] ?? 'No Content',
    );
  }

  // Menambahkan toJson() untuk mengonversi objek ke JSON
  Map<String, dynamic> toJson() {
    return {
      'source': source.toJson(),
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': img,
      'publishedAt': date,
      'content': content,
    };
  }
}
