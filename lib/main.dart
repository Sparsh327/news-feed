import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:news_app/core/di/di.dart';

import 'package:news_app/features/news_feed/presentation/bloc/news_bloc.dart';
import 'package:news_app/features/news_feed/presentation/view/new_feed_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // final NewsRepositoryImpl newsRepository;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<NewsBloc>()..add(FetchNews()), // Fetch news when the app starts

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
