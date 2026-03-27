import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:news_app/core/network/dio_client.dart';
import 'package:news_app/features/news_feed/data/data_source/local_data_source.dart';
import 'package:news_app/features/news_feed/data/data_source/remote_data_source.dart';
import 'package:news_app/features/news_feed/data/model/news_model.dart';
import 'package:news_app/features/news_feed/data/repository/news_repository_impl.dart';
import 'package:news_app/features/news_feed/presentation/bloc/news_bloc.dart';
import 'package:news_app/features/news_feed/presentation/view/new_feed_view.dart';

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NewsModelAdapter());
  Hive.registerAdapter(ArticleAdapter());
  Hive.registerAdapter(SourceAdapter());
  final box = await Hive.openBox<NewsModel>('newsBox');
  final localDataSource = LocalDataSourceImpl(box);
  final dioClient = DioClient();
  final remoteDataSource = RemoteDataSourceImpl(dioClient: dioClient);
  final newsRepository = NewsRepositoryImpl(localDataSource, remoteDataSource);

  runApp(MyApp(newsRepository: newsRepository));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.newsRepository});

  final NewsRepositoryImpl newsRepository;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          NewsBloc(newsRepository: newsRepository)..add(FetchNews()),

      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: NewFeedView(),
      ),
    );
  }
}
