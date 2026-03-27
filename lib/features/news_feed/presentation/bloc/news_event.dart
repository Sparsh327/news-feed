part of 'news_bloc.dart';

sealed class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class FetchNews extends NewsEvent {
  const FetchNews();
}

class RefreshNews extends NewsEvent {
  const RefreshNews();
}

class LoadMoreNews extends NewsEvent {
  const LoadMoreNews();
}
