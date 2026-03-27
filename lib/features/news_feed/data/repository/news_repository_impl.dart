import 'package:news_app/features/news_feed/data/data_source/local_data_source.dart';
import 'package:news_app/features/news_feed/data/data_source/remote_data_source.dart';
import 'package:news_app/features/news_feed/data/model/news_model.dart';
import 'package:news_app/features/news_feed/domain/repository/news_repository.dart';

class NewsRepositoryImpl extends NewsRepository {
  final LocalDataSource localDataSource;
  final RemoteDataSource remoteDataSource;
  NewsRepositoryImpl({required this.localDataSource, required this.remoteDataSource});
  @override
  Future<NewsModel> fetchNews({int page = 1, int pageSize = 20}) async {
    try {
      final news = await remoteDataSource.fetchNews(page: page, pageSize: pageSize);
      if (page == 1) await localDataSource.saveNews(news);
      return news;
    } catch (e) {
      final cachedNews = await localDataSource.getCachedNews();
      if (cachedNews != null) {
        return cachedNews;
      } else {
        throw Exception('No cached news available: $e');
      }
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
