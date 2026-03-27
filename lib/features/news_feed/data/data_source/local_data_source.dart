import 'package:hive/hive.dart';
import 'package:news_app/features/news_feed/data/model/news_model.dart';

abstract class LocalDataSource {
  Future<void> saveNews(NewsModel news);
  Future<NewsModel?> getCachedNews();
}

class LocalDataSourceImpl extends LocalDataSource {
  final Box<NewsModel> newsBox;
  LocalDataSourceImpl(this.newsBox);
  @override
  Future<void> saveNews(NewsModel news) async {
    try {
      await newsBox.put('cachedNews', news);
    } catch (e) {
      throw Exception('Failed to cache news: $e');
    }
  }

  @override
  Future<NewsModel?> getCachedNews() async {
    try {
      return newsBox.get('cachedNews');
    } catch (e) {
      throw Exception('Failed to get cached news: $e');
    }
  }
}
