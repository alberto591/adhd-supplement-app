import 'package:flutter/material.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';

class ArticleDetailViewModel extends ChangeNotifier {
  final ArticleRepository _repository;

  ArticleDetailViewModel(this._repository);

  Article? _article;
  Article? get article => _article;

  List<Article> _relatedArticles = [];
  List<Article> get relatedArticles => _relatedArticles;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadArticle(String id) async {
    _isLoading = true;
    notifyListeners();

    _article = await _repository.getArticle(id);
    if (_article != null) {
      _relatedArticles = await _repository.getRelatedArticles(id);
    }

    _isLoading = false;
    notifyListeners();
  }
}
