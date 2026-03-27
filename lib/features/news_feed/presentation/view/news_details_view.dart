import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/features/news_feed/data/model/news_model.dart';
import 'package:news_app/features/news_feed/presentation/view/article_web_view.dart';

class NewsDetailsView extends StatelessWidget {
  const NewsDetailsView({required this.article, super.key});
  final Article article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(imageUrl: article.urlToImage),
              const SizedBox(height: 16),
              Text(
                article.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(article.description),
              const SizedBox(height: 16),
              Text(article.content),
              const SizedBox(height: 24),
              if (article.url.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => ArticleWebView(
                              url: article.url,
                              title: article.title,
                            ),
                      ),
                    );
                  },
                  child: Text(
                    'Read Full Article',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
