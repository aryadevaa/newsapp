import 'package:newsapp/news/model/source.dart';

class SourceResponse {
  final List<SourceModel> sources;
  final String error;

  SourceResponse(this.sources, this.error);

  SourceResponse.fromJson(Map<String, dynamic> json)
    : sources =
          (json["sources"] as List?)
              ?.map((i) => new SourceModel.fromJson(i))
              .toList() ??
          [],
      error = "";

  SourceResponse.withError(String errorValue)
    : sources = List<SourceModel>.empty(),
      error = errorValue;
}
