import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/core/network/dio_client.dart';
import 'package:news_app/features/news_feed/data/data_source/local_data_source.dart';
import 'package:news_app/features/news_feed/data/data_source/remote_data_source.dart';
import 'package:news_app/features/news_feed/data/model/news_model.dart';
import 'package:news_app/features/news_feed/data/repository/news_repository_impl.dart';
import 'package:news_app/features/news_feed/domain/repository/news_repository.dart';
import 'package:news_app/features/news_feed/presentation/bloc/news_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerSingleton<DioClient>(DioClient());

  await Hive.initFlutter();
  Hive.registerAdapter(NewsModelAdapter());
  Hive.registerAdapter(ArticleAdapter());
  Hive.registerAdapter(SourceAdapter());
  final box = await Hive.openBox<NewsModel>('newsBox');
  sl.registerSingleton<Box<NewsModel>>(box);

  sl.registerFactory<LocalDataSource>(() => LocalDataSourceImpl(sl()));

  sl.registerFactory<RemoteDataSource>(
    () => RemoteDataSourceImpl(dioClient: sl()),
  );

  sl.registerFactory<NewsRepository>(
    () => NewsRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
  );

  sl.registerFactory(() => NewsBloc(newsRepository: sl()));
}
