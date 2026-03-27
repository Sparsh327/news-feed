part of 'news_bloc.dart';

sealed class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

final class NewsInitial extends NewsState {}

final class NewsLoading extends NewsState {}

final class NewsLoaded extends NewsState {
  final List<Article> articles;
  final bool hasMore;
  const NewsLoaded({required this.articles, required this.hasMore});

  @override
  List<Object> get props => [articles, hasMore];
}

final class NewsLoadingMore extends NewsState {
  final List<Article> articles;
  const NewsLoadingMore(this.articles);

  @override
  List<Object> get props => [articles];
}

final class NewsError extends NewsState {
  final String message;
  const NewsError(this.message);

  @override
  List<Object> get props => [message];
}

