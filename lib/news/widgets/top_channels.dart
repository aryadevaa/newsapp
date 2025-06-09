import 'package:flutter/material.dart';
import 'package:newsapp/news/bloc/get_sources_bloc.dart';
import 'package:newsapp/news/model/source.dart';
import 'package:newsapp/news/model/source_response.dart';
import 'package:newsapp/news/screens/source_detail.dart';
import 'package:newsapp/news/style/theme.dart' as Style;

class TopChannelsWidget extends StatefulWidget {
  @override
  _TopChannelsWidgetState createState() => _TopChannelsWidgetState();
}

class _TopChannelsWidgetState extends State<TopChannelsWidget> {
  // Inisialisasi objek GetSourcesBloc
  final GetSourcesBloc _getSourcesBloc = GetSourcesBloc();

  @override
  void initState() {
    super.initState();
    // Memanggil getSources() menggunakan objek yang sudah diinstansiasi
    _getSourcesBloc.getSources();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SourceResponse>(
      stream: _getSourcesBloc.subject.stream, // Mengakses stream dari objek
      builder: (context, AsyncSnapshot<SourceResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data?.error != null && snapshot.data!.error.length > 0) {
            return Container(); // Menangani error jika ada
          }
          return _buildSourcesWidget(snapshot.data!);
        } else if (snapshot.hasError) {
          return Container(); // Menangani error jika ada
        } else {
          return Container(); // Menampilkan loading atau pesan kesalahan lainnya
        }
      },
    );
  }

  Widget _buildSourcesWidget(SourceResponse data) {
    List<SourceModel> sources = data.sources;
    if (sources.isEmpty) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("No More Sources", style: TextStyle(color: Colors.black45)),
          ],
        ),
      );
    } else {
      return Container(
        height: 115.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: sources.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.only(top: 10.0, right: 0.0),
              width: 80.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => SourceDetail(source: sources[index]),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                      tag: sources[index].id,
                      child: Container(
                        width: 50.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                              offset: Offset(1.0, 1.0),
                            ),
                          ],
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              "assets/logos/${sources[index].id}.png",
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      sources[index].name,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.4,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.0,
                      ),
                    ),
                    SizedBox(height: 3.0),
                    Text(
                      sources[index].category,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: 1.4,
                        color: Style.Colors.titleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 9.0,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
