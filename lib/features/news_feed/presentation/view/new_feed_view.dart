import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/news_feed/data/model/news_model.dart';
import 'package:news_app/features/news_feed/presentation/bloc/news_bloc.dart';
import 'package:news_app/features/news_feed/presentation/view/news_details_view.dart';

class NewFeedView extends StatefulWidget {
  const NewFeedView({super.key});

  @override
  State<NewFeedView> createState() => _NewFeedViewState();
}

class _NewFeedViewState extends State<NewFeedView> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      context.read<NewsBloc>().add(LoadMoreNews());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News Feed')),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Article>? articles;
          bool isLoadingMore = false;

          if (state is NewsLoaded) {
            articles = state.articles;
          } else if (state is NewsLoadingMore) {
            articles = state.articles;
            isLoadingMore = true;
          }

          if (articles != null) {
            final itemCount = articles.length + (isLoadingMore ? 1 : 0);
            return RefreshIndicator(
              onRefresh: () async {
                context.read<NewsBloc>().add(RefreshNews());
              },
              child: ListView.separated(
                separatorBuilder: (context, index) => const Divider(),
                controller: scrollController,
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  if (index == articles!.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final article = articles[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NewsDetailsView(article: article),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: CachedNetworkImage(
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        imageUrl: article.urlToImage,
                      ),
                      title: Text(article.title),
                      subtitle: Text(article.description),
                    ),
                  );
                },
              ),
            );
          } else if (state is NewsError) {
            return Center(child: Text(state.message));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
