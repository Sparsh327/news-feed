import 'package:hive/hive.dart';
part 'news_model.g.dart';

@HiveType(typeId: 0)
class NewsModel extends HiveObject {
  @HiveField(0)
  final int totalResults;
  @HiveField(1)
  final List<Article> articles;

  NewsModel({required this.totalResults, required this.articles});
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      totalResults: json['totalResults'] ?? 0,
      articles:
          (json['articles'] as List<dynamic>?)
              ?.map((articleJson) => Article.fromJson(articleJson))
              .toList() ??
          [],
    );
  }
}

@HiveType(typeId: 2)
class Article extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final String urlToImage;
  @HiveField(3)
  final String publishedAt;
  @HiveField(4)
  final String content;
  @HiveField(5)
  final Source source;

  Article({
    required this.source,
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      source: Source.fromJson(json['source'] ?? {}),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      content: json['content'] ?? '',
    );
  }
}

@HiveType(typeId: 3)
class Source extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;

  Source({required this.id, required this.name});
  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(id: json['id'] ?? '', name: json['name'] ?? '');
  }
}
