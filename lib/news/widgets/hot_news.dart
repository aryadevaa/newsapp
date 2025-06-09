import 'package:flutter/material.dart';
import 'package:newsapp/news/bloc/get_hotnews_bloc.dart';
import 'package:newsapp/news/model/article.dart';
import 'package:newsapp/news/model/article_response.dart';
import 'package:newsapp/news/screens/news_detail.dart';
import 'package:newsapp/news/style/theme.dart' as Style;
import 'package:timeago/timeago.dart' as timeago;

class HotNews extends StatefulWidget {
  const HotNews({super.key});

  @override
  State<HotNews> createState() => _HotNewsState();
}

class _HotNewsState extends State<HotNews> {
  final GetHotNewsBloc _getHotNewsBloc = GetHotNewsBloc();

  @override
  void initState() {
    super.initState();
    _getHotNewsBloc.getHotNews();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleResponse>(
      stream: _getHotNewsBloc.subject.stream, // Mengakses stream dari objek
      builder: (context, AsyncSnapshot<ArticleResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data?.error != null && snapshot.data!.error.length > 0) {
            return Container(); // Menangani error jika ada
          }
          return _buildHotNewsWidget(snapshot.data!);
        } else if (snapshot.hasError) {
          return Container(); // Menangani error jika ada
        } else {
          return Container(); // Menampilkan loading atau pesan kesalahan lainnya
        }
      },
    );
  }

  Widget _buildHotNewsWidget(ArticleResponse data) {
    List<ArticleModel> articles = data.articles;

    if (articles.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("No more news", style: TextStyle(color: Colors.black45)),
          ],
        ),
      );
    } else
      return Container(
        height: articles.length / 2 * 210.0,
        padding: EdgeInsets.all(5.0),
        child: new GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: articles.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => DetailNews(article: articles[index]),
                    ),
                  );
                },
                child: Container(
                  width: 220.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                            ),
                            image: DecorationImage(
                              image:
                                  articles[index].img.isEmpty
                                      ? AssetImage("aseets/img/placeholder.jpg")
                                      : NetworkImage(articles[index].img),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                          top: 15.0,
                          bottom: 15.0,
                        ),
                        child: Text(
                          articles[index].title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(height: 1.3, fontSize: 15.0),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            width: 180,
                            height: 1.0,
                            color: Colors.black12,
                          ),
                          Container(
                            width: 30,
                            height: 3.0,
                            color: Style.Colors.mainColor,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              articles[index].source.name,
                              style: TextStyle(
                                color: Style.Colors.mainColor,
                                fontSize: 9.0,
                              ),
                            ),
                            Text(
                              timeUntil(DateTime.parse(articles[index].date)),
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 9.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}
