import 'package:news_app/features/news_feed/data/data_source/local_data_source.dart';
import 'package:news_app/features/news_feed/data/data_source/remote_data_source.dart';
import 'package:news_app/features/news_feed/data/model/news_model.dart';
import 'package:news_app/features/news_feed/domain/repository/news_repository.dart';

class NewsRepositoryImpl extends NewsRepository {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;
  NewsRepositoryImpl({required this.localDataSource, required this.remoteDataSource});
  @override
  Future<NewsModel> fetchNews({int page = 1, int pageSize = 20}) {
    try {
      return remoteDataSource.fetchNews(page: page, pageSize: pageSize).then((news) {
        if (page == 1) localDataSource.saveNews(news);
        return news;
      });
    } catch (e) {
      return localDataSource.getCachedNews().then((cachedNews) {
        if (cachedNews != null) {
          return cachedNews;
        } else {
          throw Exception('No cached news available: $e');
        }
      });
    }
  }

  @override
  Future<NewsModel?> getCachedNews() {
    try {
      return localDataSource.getCachedNews();
    } catch (e) {
      throw Exception('Failed to get cached news: $e');
    }
  }


}
