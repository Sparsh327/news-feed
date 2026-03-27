import 'package:news_app/core/network/dio_client.dart';
import 'package:news_app/features/news_feed/data/model/news_model.dart';

abstract class RemoteDataSource {
  Future<NewsModel> fetchNews({int page = 1, int pageSize = 20});
}

class RemoteDataSourceImpl extends RemoteDataSource {
  final DioClient dioClient;

  RemoteDataSourceImpl({required this.dioClient});

  @override
  Future<NewsModel> fetchNews({int page = 1, int pageSize = 20}) async {
    try {
      final response = await dioClient.client.get(
        'top-headlines',
        queryParameters: {'country': 'us', 'page': page, 'pageSize': pageSize},
      );
      return NewsModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }
}
