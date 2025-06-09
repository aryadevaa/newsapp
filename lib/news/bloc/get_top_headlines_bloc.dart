import 'package:newsapp/news/model/article_response.dart';
import 'package:newsapp/news/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetTopHeadlinesBloc {
  final NewsRepository _repository = NewsRepository();
  final BehaviorSubject<ArticleResponse> _subject =
      BehaviorSubject<ArticleResponse>();

  // Fungsi untuk memanggil API dan mendapatkan headlines
  getHeadlines() async {
    try {
      // Memanggil API untuk mendapatkan top headlines
      ArticleResponse response = await _repository.getTopHeadlines();

      // Menambahkan data ke stream langsung tanpa memeriksa null
      _subject.sink.add(response);
    } catch (e) {
      // Menangani error API
      _subject.sink.addError('Failed to load data: $e');
    }
  }

  // Fungsi untuk menutup stream
  dispose() {
    _subject.close();
  }

  // Mendapatkan stream dari BehaviorSubject
  BehaviorSubject<ArticleResponse> get subject => _subject;
}

// Membuat instance dari GetTopHeadlinesBloc
final getTopHeadlinesBloc = GetTopHeadlinesBloc();
