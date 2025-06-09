import 'package:flutter/foundation.dart';
import 'package:newsapp/news/model/article_response.dart';
import 'package:newsapp/news/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetSourceNewsBloc {
  final NewsRepository _repository = NewsRepository();
  final BehaviorSubject<ArticleResponse?> _subject =
      BehaviorSubject<ArticleResponse?>();

  // Mendapatkan data dari API berdasarkan sourceId
  getSourceNews(String sourceId) async {
    try {
      ArticleResponse response = await _repository.getTopHeadlines(
        country: 'us',
      );
      // Menambahkan response ke stream jika data ada
      _subject.sink.add(response);
    } catch (error) {
      // Tangani error dengan memberikan nilai default atau error message
      _subject.sink.addError('Failed to load news data');
    }
  }

  void drainStream() {
    _subject.value = null;
  }

  @mustCallSuper
  void dispose() async {
    await _subject.drain();
    _subject.close();
  }

  // Mendapatkan stream tanpa nilai nullable
  Stream<ArticleResponse> get subjectStream =>
      _subject.stream.where((event) => event != null).map((event) => event!);

  BehaviorSubject<ArticleResponse?> get subject => _subject;
}

final getSourceNewsBloc = GetSourceNewsBloc();
