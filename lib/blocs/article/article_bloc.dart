import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/article_model.dart';
import '../../repositories/article_repository.dart';
import 'article_event.dart';
import 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final ArticleRepository repository;
  List<Article> _allArticles = [];
  List<int> _favoriteIds = [];

  ArticleBloc(this.repository) : super(ArticleInitial()) {
    on<FetchArticles>(_onFetchArticles);
    on<RefreshArticles>(_onRefreshArticles);
    on<SearchArticles>(_onSearchArticles);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  void _onFetchArticles(FetchArticles event, Emitter<ArticleState> emit) async {
    emit(ArticleLoading());
    try {
      _allArticles = await repository.fetchArticles();
      await _loadFavorites();
      emit(ArticleLoaded(_allArticles, _favoriteIds));
    } catch (e) {
      emit(ArticleError(e.toString()));
    }
  }

  void _onRefreshArticles(RefreshArticles event, Emitter<ArticleState> emit) async {
    try {
      _allArticles = await repository.fetchArticles();
      emit(ArticleLoaded(_allArticles, _favoriteIds));
    } catch (e) {
      emit(ArticleError(e.toString()));
    }
  }

  void _onSearchArticles(SearchArticles event, Emitter<ArticleState> emit) {
    final query = event.query.toLowerCase();

    final filteredArticles = _allArticles.where((article) {
      return article.title.toLowerCase().contains(query);
    }).toList();

    emit(ArticleLoaded(filteredArticles, _favoriteIds));
  }

  void _onToggleFavorite(ToggleFavorite event, Emitter<ArticleState> emit) async {
    final articleId = event.articleId;

    // Toggle favorite ID
    if (_favoriteIds.contains(articleId)) {
      _favoriteIds.remove(articleId);
    } else {
      _favoriteIds.add(articleId);
    }

    await _saveFavorites();

    // Update articles' isFavorite flags
    final updatedArticles = _allArticles.map((article) {
      return article.copyWith(
        isFavorite: _favoriteIds.contains(article.id),
      );
    }).toList();

    emit(ArticleLoaded(updatedArticles, _favoriteIds));
  }



  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteIds = prefs.getStringList('favorites')?.map(int.parse).toList() ?? [];
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favoriteIds.map((e) => e.toString()).toList());
  }
}
