import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class DioClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://newsapi.org/v2/',
      headers: {'Authorization': 'Bearer ${AppConstants.newsApiKey}'},
    ),
  );

  Dio get client => _dio;
}
