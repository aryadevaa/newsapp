import 'package:newsapp/news/model/article_response.dart';
import 'package:newsapp/news/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class SearchBloc {
  final NewsRepository _repository = NewsRepository();
  final BehaviorSubject<ArticleResponse> _subject =
      BehaviorSubject<ArticleResponse>();

  // Gantilah pemanggilan search() dengan getEverything() dari repository
  search(String value) async {
    // Gantilah pemanggilan ke getEverything dengan query pencarian
    ArticleResponse response = await _repository.getEverything(value);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<ArticleResponse> get Subject => _subject;
}

final searchBloc = SearchBloc();
