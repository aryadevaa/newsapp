class SourceModel {
  final String id;
  final String name;
  final String description;
  final String url;
  final String category;
  final String country;
  final String language;

  // Konstruktor dengan named parameters
  SourceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.category,
    required this.country,
    required this.language,
  });

  // Factory method for converting JSON to an object
  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(
      id: json["id"] ?? 'Unknown', // Default jika null
      name: json["name"] ?? 'No Name', // Default jika null
      description: json["description"] ?? 'No Description Available', // Default jika null
      url: json["url"] ?? '', // Default jika null
      category: json["category"] ?? '', // Default jika null
      country: json["country"] ?? '', // Default jika null
      language: json["language"] ?? '', // Default jika null
    );
  }

  // Method to convert object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'url': url,
      'category': category,
      'country': country,
      'language': language,
    };
  }
}
