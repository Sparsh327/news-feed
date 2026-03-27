import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app/features/news_feed/data/model/news_model.dart';
import 'package:news_app/features/news_feed/domain/repository/news_repository.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc({required this.newsRepository, }) : super(NewsInitial()) {
    on<FetchNews>(_onFetchNews);
    on<RefreshNews>(_onRefreshNews);
    on<LoadMoreNews>(_onLoadMoreNews);
  }

  final NewsRepository newsRepository;
  static const int _pageSize = 20;
  int _currentPage = 1;

  Future<void> _onFetchNews(FetchNews event, Emitter<NewsState> emit) async {
    _currentPage = 1;
    emit(NewsLoading());
    try {
      final news = await newsRepository.fetchNews(
        page: _currentPage,
        pageSize: _pageSize,
      );
      emit(
        NewsLoaded(
          articles: news.articles,
          hasMore: news.articles.length < news.totalResults,
        ),
      );
    } catch (error) {
      emit(NewsError(error.toString()));
    }
  }

  Future<void> _onRefreshNews(
    RefreshNews event,
    Emitter<NewsState> emit,
  ) async {
    _currentPage = 1;
    try {
      final news = await newsRepository.fetchNews(
        page: _currentPage,
        pageSize: _pageSize,
      );
      emit(
        NewsLoaded(
          articles: news.articles,
          hasMore: news.articles.length < news.totalResults,
        ),
      );
    } catch (error) {
      emit(NewsError(error.toString()));
    }
  }

  Future<void> _onLoadMoreNews(
    LoadMoreNews event,
    Emitter<NewsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! NewsLoaded || !currentState.hasMore) return;

    emit(NewsLoadingMore(currentState.articles));
    try {
      _currentPage++;
      final news = await newsRepository.fetchNews(
        page: _currentPage,
        pageSize: _pageSize,
      );
      final allArticles = [...currentState.articles, ...news.articles];
      emit(
        NewsLoaded(
          articles: allArticles,
          hasMore: allArticles.length < news.totalResults,
        ),
      );
    } catch (error) {
      _currentPage--;
      emit(
        NewsLoaded(
          articles: currentState.articles,
          hasMore: currentState.hasMore,
        ),
      );
    }
  }
}
