import 'package:news_app/features/news_feed/data/model/news_model.dart';

abstract class NewsRepository {
  Future<NewsModel> fetchNews({int page = 1, int pageSize = 20});
  Future<NewsModel?> getCachedNews();
}
